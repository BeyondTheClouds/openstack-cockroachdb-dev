#!/usr/bin/env python

# Copyright 2014 Hewlett-Packard Development Company, L.P.
# Copyright 2014 Samsung Electronics
# All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

import sys
import subunit
import testtools
import json

import six
import ast

OSTREAM = sys.stdout

def split_lines(content):
    """Split log into lines"""
    res = []

    if isinstance(content, six.string_types):
        res = content.splitlines()
    elif isinstance(content, testtools.content.Content):
        res = content.as_text().splitlines()

    return res

def filter_sql_query(log):
    """Extract SQL statements from log"""
    sqls = []

    for q in log:
        if 'sqlalchemy.engine.base.Engine' in q:
            # Remove '2017-11-22 15:17:14,810 INFO [sqlalchemy.engine.base.Engine] '
            q = q[61:].strip()
            sqls.append(q)
        elif sqls and not q.startswith('2017-'):
            # Rest of previous SQL query: append to previous sql
            sqls[-1] = sqls[-1] + ' ' + q.strip()

    return sqls

def expand_sql_template(log):
    """Expand SQL template.

    Expand
      > SELECT a FROM b WHERE a.c = ? AND a.d = ?
      > (1,2)
    Into
      > SELECT a FROM b WHERE a.c = 1 AND a.d = 2
    """

    # Expand template
    log.reverse()
    for i, l in enumerate(log):
        if l.startswith('('):
            values = ast.literal_eval(l) # Template values
            sql = log[i+1]               # Templated query

            # Expand
            for v in values:
                sql = sql.replace('?', str(v), 1)

            log[i+1] = sql

    # Remove template values
    log.reverse()
    log = [ sql for sql in log if not sql.startswith('(') ]

    return log

def formatsql(log):
    log = split_lines(log)
    log = filter_sql_query(log)
    log = expand_sql_template(log)

    return log

def handle_test(test):
    name = test['id']
    status = test['status'] is 'success'
    sql = formatsql(test['details'].get("pythonlogging:''", ''))

    if status and sql:
        res = {
            'name': name,
            'sql': sql
        }
        OSTREAM.write(json.dumps(res))
        OSTREAM.write(',\n')

def trace():
    case = subunit.ByteStreamToStreamResult(sys.stdin, non_subunit_name='stdout')
    result = testtools.StreamToDict(handle_test) # Call handle_test
                                                 # when test completes
    OSTREAM.write("[\n")
    result.startTestRun()
    case.run(result)
    result.stopTestRun()
    OSTREAM.write("]\n")


exit(trace())
