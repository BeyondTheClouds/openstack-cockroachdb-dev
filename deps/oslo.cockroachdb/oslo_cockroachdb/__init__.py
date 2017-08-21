import psycopg2
import psycopg2.errorcodes
import sqlalchemy.exc
from cockroachdb.sqlalchemy.dialect import savepoint_state


def txn_retries():
    def decorator(fn):
        def decorated(*args, **kwargs):
            while True:
                try:
                    savepoint_state.cockroach_restart = True
                    return fn(*args, **kwargs)
                    savepoint_state.cockroach_restart = False
                except sqlalchemy.exc.DatabaseError as e:
                    if isinstance(e.orig, psycopg2.OperationalError) and\
                       e.orig.pgcode == psycopg2.errorcodes.SERIALIZATION_FAILURE:
                        continue
                    raise
        return decorated
    return decorator
