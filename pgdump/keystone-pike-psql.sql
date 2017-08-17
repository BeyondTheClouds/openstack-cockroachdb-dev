--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

DROP DATABASE keystone;
--
-- Name: keystone; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE keystone WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C';


\connect keystone

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: entity_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE entity_type AS ENUM (
    'user',
    'group'
);


--
-- Name: type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE type AS ENUM (
    'UserProject',
    'GroupProject',
    'UserDomain',
    'GroupDomain'
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: access_token; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE access_token (
    id character varying(64) NOT NULL,
    access_secret character varying(64) NOT NULL,
    authorizing_user_id character varying(64) NOT NULL,
    project_id character varying(64) NOT NULL,
    role_ids text NOT NULL,
    consumer_id character varying(64) NOT NULL,
    expires_at character varying(64)
);


--
-- Name: assignment; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assignment (
    type type NOT NULL,
    actor_id character varying(64) NOT NULL,
    target_id character varying(64) NOT NULL,
    role_id character varying(64) NOT NULL,
    inherited boolean NOT NULL
);


--
-- Name: config_register; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE config_register (
    type character varying(64) NOT NULL,
    domain_id character varying(64) NOT NULL
);


--
-- Name: consumer; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE consumer (
    id character varying(64) NOT NULL,
    description character varying(64),
    secret character varying(64) NOT NULL,
    extra text NOT NULL
);


--
-- Name: credential; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE credential (
    id character varying(64) NOT NULL,
    user_id character varying(64) NOT NULL,
    project_id character varying(64),
    type character varying(255) NOT NULL,
    extra text,
    key_hash character varying(64) NOT NULL,
    encrypted_blob text NOT NULL
);


--
-- Name: endpoint; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE endpoint (
    id character varying(64) NOT NULL,
    legacy_endpoint_id character varying(64),
    interface character varying(8) NOT NULL,
    service_id character varying(64) NOT NULL,
    url text NOT NULL,
    extra text,
    enabled boolean DEFAULT true NOT NULL,
    region_id character varying(255)
);


--
-- Name: endpoint_group; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE endpoint_group (
    id character varying(64) NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    filters text NOT NULL
);


--
-- Name: federated_user; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE federated_user (
    id integer NOT NULL,
    user_id character varying(64) NOT NULL,
    idp_id character varying(64) NOT NULL,
    protocol_id character varying(64) NOT NULL,
    unique_id character varying(255) NOT NULL,
    display_name character varying(255)
);


--
-- Name: federated_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE federated_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: federated_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE federated_user_id_seq OWNED BY federated_user.id;


--
-- Name: federation_protocol; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE federation_protocol (
    id character varying(64) NOT NULL,
    idp_id character varying(64) NOT NULL,
    mapping_id character varying(64) NOT NULL
);


--
-- Name: group; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "group" (
    id character varying(64) NOT NULL,
    domain_id character varying(64) NOT NULL,
    name character varying(64) NOT NULL,
    description text,
    extra text
);


--
-- Name: id_mapping; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE id_mapping (
    public_id character varying(64) NOT NULL,
    domain_id character varying(64) NOT NULL,
    local_id character varying(64) NOT NULL,
    entity_type entity_type NOT NULL
);


--
-- Name: identity_provider; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE identity_provider (
    id character varying(64) NOT NULL,
    enabled boolean NOT NULL,
    description text,
    domain_id character varying(64) NOT NULL
);


--
-- Name: idp_remote_ids; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE idp_remote_ids (
    idp_id character varying(64),
    remote_id character varying(255) NOT NULL
);


--
-- Name: implied_role; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE implied_role (
    prior_role_id character varying(64) NOT NULL,
    implied_role_id character varying(64) NOT NULL
);


--
-- Name: local_user; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE local_user (
    id integer NOT NULL,
    user_id character varying(64) NOT NULL,
    domain_id character varying(64) NOT NULL,
    name character varying(255) NOT NULL,
    failed_auth_count integer,
    failed_auth_at timestamp without time zone
);


--
-- Name: local_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE local_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: local_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE local_user_id_seq OWNED BY local_user.id;


--
-- Name: mapping; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mapping (
    id character varying(64) NOT NULL,
    rules text NOT NULL
);


--
-- Name: migrate_version; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE migrate_version (
    repository_id character varying(250) NOT NULL,
    repository_path text,
    version integer
);


--
-- Name: nonlocal_user; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE nonlocal_user (
    domain_id character varying(64) NOT NULL,
    name character varying(255) NOT NULL,
    user_id character varying(64) NOT NULL
);


--
-- Name: password; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE password (
    id integer NOT NULL,
    local_user_id integer NOT NULL,
    password character varying(128),
    expires_at timestamp without time zone,
    self_service boolean DEFAULT false NOT NULL,
    password_hash character varying(255),
    created_at_int bigint DEFAULT 0::bigint NOT NULL,
    expires_at_int bigint,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: password_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE password_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: password_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE password_id_seq OWNED BY password.id;


--
-- Name: policy; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE policy (
    id character varying(64) NOT NULL,
    type character varying(255) NOT NULL,
    blob text NOT NULL,
    extra text
);


--
-- Name: policy_association; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE policy_association (
    id character varying(64) NOT NULL,
    policy_id character varying(64) NOT NULL,
    endpoint_id character varying(64),
    service_id character varying(64),
    region_id character varying(64)
);


--
-- Name: project; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE project (
    id character varying(64) NOT NULL,
    name character varying(64) NOT NULL,
    extra text,
    description text,
    enabled boolean,
    domain_id character varying(64) NOT NULL,
    parent_id character varying(64),
    is_domain boolean DEFAULT false NOT NULL
);


--
-- Name: project_endpoint; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE project_endpoint (
    endpoint_id character varying(64) NOT NULL,
    project_id character varying(64) NOT NULL
);


--
-- Name: project_endpoint_group; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE project_endpoint_group (
    endpoint_group_id character varying(64) NOT NULL,
    project_id character varying(64) NOT NULL
);


--
-- Name: region; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE region (
    id character varying(255) NOT NULL,
    description character varying(255) NOT NULL,
    parent_region_id character varying(255),
    extra text
);


--
-- Name: request_token; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE request_token (
    id character varying(64) NOT NULL,
    request_secret character varying(64) NOT NULL,
    verifier character varying(64),
    authorizing_user_id character varying(64),
    requested_project_id character varying(64) NOT NULL,
    role_ids text,
    consumer_id character varying(64) NOT NULL,
    expires_at character varying(64)
);


--
-- Name: revocation_event; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE revocation_event (
    id integer NOT NULL,
    domain_id character varying(64),
    project_id character varying(64),
    user_id character varying(64),
    role_id character varying(64),
    trust_id character varying(64),
    consumer_id character varying(64),
    access_token_id character varying(64),
    issued_before timestamp without time zone NOT NULL,
    expires_at timestamp without time zone,
    revoked_at timestamp without time zone NOT NULL,
    audit_id character varying(32),
    audit_chain_id character varying(32)
);


--
-- Name: revocation_event_new_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE revocation_event_new_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: revocation_event_new_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE revocation_event_new_id_seq OWNED BY revocation_event.id;


--
-- Name: role; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE role (
    id character varying(64) NOT NULL,
    name character varying(255) NOT NULL,
    extra text,
    domain_id character varying(64) DEFAULT '<<null>>'::character varying NOT NULL
);


--
-- Name: sensitive_config; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sensitive_config (
    domain_id character varying(64) NOT NULL,
    "group" character varying(255) NOT NULL,
    option character varying(255) NOT NULL,
    value text NOT NULL
);


--
-- Name: service; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE service (
    id character varying(64) NOT NULL,
    type character varying(255),
    enabled boolean DEFAULT true NOT NULL,
    extra text
);


--
-- Name: service_provider; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE service_provider (
    auth_url character varying(256) NOT NULL,
    id character varying(64) NOT NULL,
    enabled boolean NOT NULL,
    description text,
    sp_url character varying(256) NOT NULL,
    relay_state_prefix character varying(256) DEFAULT 'ss:mem:'::character varying NOT NULL
);


--
-- Name: token; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE token (
    id character varying(64) NOT NULL,
    expires timestamp without time zone,
    extra text,
    valid boolean NOT NULL,
    trust_id character varying(64),
    user_id character varying(64)
);


--
-- Name: trust; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trust (
    id character varying(64) NOT NULL,
    trustor_user_id character varying(64) NOT NULL,
    trustee_user_id character varying(64) NOT NULL,
    project_id character varying(64),
    impersonation boolean NOT NULL,
    deleted_at timestamp without time zone,
    expires_at timestamp without time zone,
    remaining_uses integer,
    extra text
);


--
-- Name: trust_role; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trust_role (
    trust_id character varying(64) NOT NULL,
    role_id character varying(64) NOT NULL
);


--
-- Name: user; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "user" (
    id character varying(64) NOT NULL,
    extra text,
    enabled boolean,
    default_project_id character varying(64),
    created_at timestamp without time zone,
    last_active_at date,
    domain_id character varying(64) NOT NULL
);


--
-- Name: user_group_membership; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_group_membership (
    user_id character varying(64) NOT NULL,
    group_id character varying(64) NOT NULL
);


--
-- Name: user_option; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_option (
    user_id character varying(64) NOT NULL,
    option_id character varying(4) NOT NULL,
    option_value text
);


--
-- Name: whitelisted_config; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE whitelisted_config (
    domain_id character varying(64) NOT NULL,
    "group" character varying(255) NOT NULL,
    option character varying(255) NOT NULL,
    value text NOT NULL
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY federated_user ALTER COLUMN id SET DEFAULT nextval('federated_user_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY local_user ALTER COLUMN id SET DEFAULT nextval('local_user_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY password ALTER COLUMN id SET DEFAULT nextval('password_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY revocation_event ALTER COLUMN id SET DEFAULT nextval('revocation_event_new_id_seq'::regclass);


--
-- Data for Name: access_token; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: assignment; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO assignment (type, actor_id, target_id, role_id, inherited) VALUES ('UserProject', 'bca055d2e51c4906bc4ede90b19cb5bc', '983a1240b6f64ca4b8788775269bac07', 'aa76752ef6ea49b480dd14bd85cdac7a', false);
INSERT INTO assignment (type, actor_id, target_id, role_id, inherited) VALUES ('UserDomain', 'bca055d2e51c4906bc4ede90b19cb5bc', 'default', 'aa76752ef6ea49b480dd14bd85cdac7a', false);
INSERT INTO assignment (type, actor_id, target_id, role_id, inherited) VALUES ('UserProject', 'a0133f254fb642c0b96c55327e929d62', '25668bd56003443eb582335156e25c5d', '48ea5c3a718b455ca991f477bfd8a215', false);
INSERT INTO assignment (type, actor_id, target_id, role_id, inherited) VALUES ('UserProject', 'bca055d2e51c4906bc4ede90b19cb5bc', '25668bd56003443eb582335156e25c5d', 'aa76752ef6ea49b480dd14bd85cdac7a', false);
INSERT INTO assignment (type, actor_id, target_id, role_id, inherited) VALUES ('UserProject', 'a0133f254fb642c0b96c55327e929d62', '25668bd56003443eb582335156e25c5d', '97da667f719140d9a17eb2eea86e5750', false);
INSERT INTO assignment (type, actor_id, target_id, role_id, inherited) VALUES ('UserProject', 'a0133f254fb642c0b96c55327e929d62', '315ad00c131e46128a42d4d3f406823d', '48ea5c3a718b455ca991f477bfd8a215', false);
INSERT INTO assignment (type, actor_id, target_id, role_id, inherited) VALUES ('UserProject', '4d9d71156ca14c8c89bd5bd5d2937bdd', '23cf11c96a094e03b5c8e9c5e842c971', '48ea5c3a718b455ca991f477bfd8a215', false);
INSERT INTO assignment (type, actor_id, target_id, role_id, inherited) VALUES ('UserProject', 'bca055d2e51c4906bc4ede90b19cb5bc', '23cf11c96a094e03b5c8e9c5e842c971', 'aa76752ef6ea49b480dd14bd85cdac7a', false);
INSERT INTO assignment (type, actor_id, target_id, role_id, inherited) VALUES ('UserProject', '4d9d71156ca14c8c89bd5bd5d2937bdd', '23cf11c96a094e03b5c8e9c5e842c971', '97da667f719140d9a17eb2eea86e5750', false);
INSERT INTO assignment (type, actor_id, target_id, role_id, inherited) VALUES ('GroupProject', '840b80bf8b23418188c40ccd984c0b27', '25668bd56003443eb582335156e25c5d', '48ea5c3a718b455ca991f477bfd8a215', false);
INSERT INTO assignment (type, actor_id, target_id, role_id, inherited) VALUES ('GroupProject', '840b80bf8b23418188c40ccd984c0b27', '25668bd56003443eb582335156e25c5d', '97da667f719140d9a17eb2eea86e5750', false);
INSERT INTO assignment (type, actor_id, target_id, role_id, inherited) VALUES ('GroupProject', '840b80bf8b23418188c40ccd984c0b27', '23cf11c96a094e03b5c8e9c5e842c971', '48ea5c3a718b455ca991f477bfd8a215', false);
INSERT INTO assignment (type, actor_id, target_id, role_id, inherited) VALUES ('GroupProject', '840b80bf8b23418188c40ccd984c0b27', '23cf11c96a094e03b5c8e9c5e842c971', '97da667f719140d9a17eb2eea86e5750', false);
INSERT INTO assignment (type, actor_id, target_id, role_id, inherited) VALUES ('GroupProject', '9ba28e8d3baf416dabc19e89c44939ac', '983a1240b6f64ca4b8788775269bac07', 'aa76752ef6ea49b480dd14bd85cdac7a', false);


--
-- Data for Name: config_register; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: consumer; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: credential; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: endpoint; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO endpoint (id, legacy_endpoint_id, interface, service_id, url, extra, enabled, region_id) VALUES ('cb7a1a15c55045b1a6e2c8a13f30e408', NULL, 'admin', '7c4cdc881fe844ebae5652b58cf3bd77', 'http://10.0.2.15', '{}', true, 'RegionOne');
INSERT INTO endpoint (id, legacy_endpoint_id, interface, service_id, url, extra, enabled, region_id) VALUES ('036488f0659a4d40846f6719a094a5ed', NULL, 'public', '7c4cdc881fe844ebae5652b58cf3bd77', 'http://10.0.2.15', '{}', true, 'RegionOne');


--
-- Data for Name: endpoint_group; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: federated_user; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: federated_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('federated_user_id_seq', 1, false);


--
-- Data for Name: federation_protocol; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: group; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "group" (id, domain_id, name, description, extra) VALUES ('9ba28e8d3baf416dabc19e89c44939ac', 'default', 'admins', 'openstack admin group', '{}');
INSERT INTO "group" (id, domain_id, name, description, extra) VALUES ('840b80bf8b23418188c40ccd984c0b27', 'default', 'nonadmins', 'non-admin group', '{}');


--
-- Data for Name: id_mapping; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: identity_provider; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: idp_remote_ids; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: implied_role; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: local_user; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO local_user (id, user_id, domain_id, name, failed_auth_count, failed_auth_at) VALUES (1, 'bca055d2e51c4906bc4ede90b19cb5bc', 'default', 'admin', 0, NULL);
INSERT INTO local_user (id, user_id, domain_id, name, failed_auth_count, failed_auth_at) VALUES (2, 'a0133f254fb642c0b96c55327e929d62', 'default', 'demo', 0, NULL);
INSERT INTO local_user (id, user_id, domain_id, name, failed_auth_count, failed_auth_at) VALUES (3, '4d9d71156ca14c8c89bd5bd5d2937bdd', 'default', 'alt_demo', 0, NULL);


--
-- Name: local_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('local_user_id_seq', 3, true);


--
-- Data for Name: mapping; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: migrate_version; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO migrate_version (repository_id, repository_path, version) VALUES ('keystone_data_migrate', '/opt/stack/keystone/keystone/common/sql/data_migration_repo', 24);
INSERT INTO migrate_version (repository_id, repository_path, version) VALUES ('keystone', '/opt/stack/keystone/keystone/common/sql/migrate_repo', 109);
INSERT INTO migrate_version (repository_id, repository_path, version) VALUES ('keystone_contract', '/opt/stack/keystone/keystone/common/sql/contract_repo', 24);
INSERT INTO migrate_version (repository_id, repository_path, version) VALUES ('keystone_expand', '/opt/stack/keystone/keystone/common/sql/expand_repo', 24);


--
-- Data for Name: nonlocal_user; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: password; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO password (id, local_user_id, password, expires_at, self_service, password_hash, created_at_int, expires_at_int, created_at) VALUES (1, 1, NULL, NULL, false, '$2b$04$A9gMmnspRfVtdOoYj.eER.9lkYn.Ds4yXEedno6hmm2AwOW7gKkLe', 1502991837247698, NULL, '2017-08-17 17:43:57.247698');
INSERT INTO password (id, local_user_id, password, expires_at, self_service, password_hash, created_at_int, expires_at_int, created_at) VALUES (2, 2, NULL, NULL, false, '$2b$04$lefmGwNu2ve.JuWi28TZsuk8lLiP3IOqksLcgPBEVQOrjyvQqqMrO', 1502991863333401, NULL, '2017-08-17 17:44:23.333401');
INSERT INTO password (id, local_user_id, password, expires_at, self_service, password_hash, created_at_int, expires_at_int, created_at) VALUES (3, 3, NULL, NULL, false, '$2b$04$FEz13D58ELnoyXKTa8fmde5VZUlHvogFHgUXmHyYfTvKxlNKfn5GO', 1502991887698739, NULL, '2017-08-17 17:44:47.698739');


--
-- Name: password_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('password_id_seq', 3, true);


--
-- Data for Name: policy; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: policy_association; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: project; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO project (id, name, extra, description, enabled, domain_id, parent_id, is_domain) VALUES ('<<keystone.domain.root>>', '<<keystone.domain.root>>', '{}', '', false, '<<keystone.domain.root>>', NULL, true);
INSERT INTO project (id, name, extra, description, enabled, domain_id, parent_id, is_domain) VALUES ('default', 'Default', '{}', 'The default domain', true, '<<keystone.domain.root>>', NULL, true);
INSERT INTO project (id, name, extra, description, enabled, domain_id, parent_id, is_domain) VALUES ('983a1240b6f64ca4b8788775269bac07', 'admin', '{}', 'Bootstrap project for initializing the cloud.', true, 'default', 'default', false);
INSERT INTO project (id, name, extra, description, enabled, domain_id, parent_id, is_domain) VALUES ('5f122d9f0bd24070ba6730d76891b46b', 'service', '{}', '', true, 'default', 'default', false);
INSERT INTO project (id, name, extra, description, enabled, domain_id, parent_id, is_domain) VALUES ('315ad00c131e46128a42d4d3f406823d', 'invisible_to_admin', '{}', '', true, 'default', 'default', false);
INSERT INTO project (id, name, extra, description, enabled, domain_id, parent_id, is_domain) VALUES ('25668bd56003443eb582335156e25c5d', 'demo', '{}', '', true, 'default', 'default', false);
INSERT INTO project (id, name, extra, description, enabled, domain_id, parent_id, is_domain) VALUES ('23cf11c96a094e03b5c8e9c5e842c971', 'alt_demo', '{}', '', true, 'default', 'default', false);


--
-- Data for Name: project_endpoint; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: project_endpoint_group; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO region (id, description, parent_region_id, extra) VALUES ('RegionOne', '', NULL, '{}');


--
-- Data for Name: request_token; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: revocation_event; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: revocation_event_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('revocation_event_new_id_seq', 1, false);


--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO role (id, name, extra, domain_id) VALUES ('aa76752ef6ea49b480dd14bd85cdac7a', 'admin', '{}', '<<null>>');
INSERT INTO role (id, name, extra, domain_id) VALUES ('9fe2ff9ee4384b1894a90878d3e92bab', '_member_', '{}', '<<null>>');
INSERT INTO role (id, name, extra, domain_id) VALUES ('a4b4932fde934b3f98dec3ad287caa20', 'service', '{}', '<<null>>');
INSERT INTO role (id, name, extra, domain_id) VALUES ('c9b93a7d8b6d42349c8dccad42840293', 'ResellerAdmin', '{}', '<<null>>');
INSERT INTO role (id, name, extra, domain_id) VALUES ('776e634ce1d74810ac63948856ca7c19', 'Member', '{}', '<<null>>');
INSERT INTO role (id, name, extra, domain_id) VALUES ('48ea5c3a718b455ca991f477bfd8a215', 'member', '{}', '<<null>>');
INSERT INTO role (id, name, extra, domain_id) VALUES ('97da667f719140d9a17eb2eea86e5750', 'anotherrole', '{}', '<<null>>');


--
-- Data for Name: sensitive_config; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: service; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO service (id, type, enabled, extra) VALUES ('7c4cdc881fe844ebae5652b58cf3bd77', 'identity', true, '{"name": "keystone"}');


--
-- Data for Name: service_provider; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: token; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: trust; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: trust_role; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "user" (id, extra, enabled, default_project_id, created_at, last_active_at, domain_id) VALUES ('bca055d2e51c4906bc4ede90b19cb5bc', '{}', true, NULL, '2017-08-17 17:43:57.273552', NULL, 'default');
INSERT INTO "user" (id, extra, enabled, default_project_id, created_at, last_active_at, domain_id) VALUES ('a0133f254fb642c0b96c55327e929d62', '{"email": "demo@example.com"}', true, NULL, '2017-08-17 17:44:23.3349', NULL, 'default');
INSERT INTO "user" (id, extra, enabled, default_project_id, created_at, last_active_at, domain_id) VALUES ('4d9d71156ca14c8c89bd5bd5d2937bdd', '{"email": "alt_demo@example.com"}', true, NULL, '2017-08-17 17:44:47.700083', NULL, 'default');


--
-- Data for Name: user_group_membership; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: user_option; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: whitelisted_config; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: access_token_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY access_token
    ADD CONSTRAINT access_token_pkey PRIMARY KEY (id);


--
-- Name: assignment_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assignment
    ADD CONSTRAINT assignment_pkey PRIMARY KEY (type, actor_id, target_id, role_id, inherited);


--
-- Name: config_register_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY config_register
    ADD CONSTRAINT config_register_pkey PRIMARY KEY (type);


--
-- Name: consumer_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY consumer
    ADD CONSTRAINT consumer_pkey PRIMARY KEY (id);


--
-- Name: credential_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY credential
    ADD CONSTRAINT credential_pkey PRIMARY KEY (id);


--
-- Name: domain_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY id_mapping
    ADD CONSTRAINT domain_id UNIQUE (domain_id, local_id, entity_type);


--
-- Name: duplicate_trust_constraint; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY trust
    ADD CONSTRAINT duplicate_trust_constraint UNIQUE (trustor_user_id, trustee_user_id, project_id, impersonation, expires_at);


--
-- Name: endpoint_group_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY endpoint_group
    ADD CONSTRAINT endpoint_group_pkey PRIMARY KEY (id);


--
-- Name: endpoint_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY endpoint
    ADD CONSTRAINT endpoint_pkey PRIMARY KEY (id);


--
-- Name: federated_user_idp_id_protocol_id_unique_id_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY federated_user
    ADD CONSTRAINT federated_user_idp_id_protocol_id_unique_id_key UNIQUE (idp_id, protocol_id, unique_id);


--
-- Name: federated_user_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY federated_user
    ADD CONSTRAINT federated_user_pkey PRIMARY KEY (id);


--
-- Name: federation_protocol_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY federation_protocol
    ADD CONSTRAINT federation_protocol_pkey PRIMARY KEY (id, idp_id);


--
-- Name: group_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "group"
    ADD CONSTRAINT group_pkey PRIMARY KEY (id);


--
-- Name: id_mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY id_mapping
    ADD CONSTRAINT id_mapping_pkey PRIMARY KEY (public_id);


--
-- Name: identity_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY identity_provider
    ADD CONSTRAINT identity_provider_pkey PRIMARY KEY (id);


--
-- Name: idp_remote_ids_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY idp_remote_ids
    ADD CONSTRAINT idp_remote_ids_pkey PRIMARY KEY (remote_id);


--
-- Name: implied_role_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY implied_role
    ADD CONSTRAINT implied_role_pkey PRIMARY KEY (prior_role_id, implied_role_id);


--
-- Name: ixu_group_name_domain_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "group"
    ADD CONSTRAINT ixu_group_name_domain_id UNIQUE (domain_id, name);


--
-- Name: ixu_nonlocal_user_user_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY nonlocal_user
    ADD CONSTRAINT ixu_nonlocal_user_user_id UNIQUE (user_id);


--
-- Name: ixu_project_name_domain_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY project
    ADD CONSTRAINT ixu_project_name_domain_id UNIQUE (domain_id, name);


--
-- Name: ixu_role_name_domain_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY role
    ADD CONSTRAINT ixu_role_name_domain_id UNIQUE (name, domain_id);


--
-- Name: ixu_user_id_domain_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT ixu_user_id_domain_id UNIQUE (id, domain_id);


--
-- Name: local_user_domain_id_name_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY local_user
    ADD CONSTRAINT local_user_domain_id_name_key UNIQUE (domain_id, name);


--
-- Name: local_user_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY local_user
    ADD CONSTRAINT local_user_pkey PRIMARY KEY (id);


--
-- Name: local_user_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY local_user
    ADD CONSTRAINT local_user_user_id_key UNIQUE (user_id);


--
-- Name: mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mapping
    ADD CONSTRAINT mapping_pkey PRIMARY KEY (id);


--
-- Name: migrate_version_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY migrate_version
    ADD CONSTRAINT migrate_version_pkey PRIMARY KEY (repository_id);


--
-- Name: nonlocal_user_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY nonlocal_user
    ADD CONSTRAINT nonlocal_user_pkey PRIMARY KEY (domain_id, name);


--
-- Name: password_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY password
    ADD CONSTRAINT password_pkey PRIMARY KEY (id);


--
-- Name: policy_association_endpoint_id_service_id_region_id_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY policy_association
    ADD CONSTRAINT policy_association_endpoint_id_service_id_region_id_key UNIQUE (endpoint_id, service_id, region_id);


--
-- Name: policy_association_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY policy_association
    ADD CONSTRAINT policy_association_pkey PRIMARY KEY (id);


--
-- Name: policy_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY policy
    ADD CONSTRAINT policy_pkey PRIMARY KEY (id);


--
-- Name: project_endpoint_group_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY project_endpoint_group
    ADD CONSTRAINT project_endpoint_group_pkey PRIMARY KEY (endpoint_group_id, project_id);


--
-- Name: project_endpoint_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY project_endpoint
    ADD CONSTRAINT project_endpoint_pkey PRIMARY KEY (endpoint_id, project_id);


--
-- Name: project_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY project
    ADD CONSTRAINT project_pkey PRIMARY KEY (id);


--
-- Name: region_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY region
    ADD CONSTRAINT region_pkey PRIMARY KEY (id);


--
-- Name: request_token_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY request_token
    ADD CONSTRAINT request_token_pkey PRIMARY KEY (id);


--
-- Name: revocation_event_new_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY revocation_event
    ADD CONSTRAINT revocation_event_new_pkey PRIMARY KEY (id);


--
-- Name: role_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);


--
-- Name: sensitive_config_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sensitive_config
    ADD CONSTRAINT sensitive_config_pkey PRIMARY KEY (domain_id, "group", option);


--
-- Name: service_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY service
    ADD CONSTRAINT service_pkey PRIMARY KEY (id);


--
-- Name: service_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY service_provider
    ADD CONSTRAINT service_provider_pkey PRIMARY KEY (id);


--
-- Name: token_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY token
    ADD CONSTRAINT token_pkey PRIMARY KEY (id);


--
-- Name: trust_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY trust
    ADD CONSTRAINT trust_pkey PRIMARY KEY (id);


--
-- Name: trust_role_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY trust_role
    ADD CONSTRAINT trust_role_pkey PRIMARY KEY (trust_id, role_id);


--
-- Name: user_group_membership_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_group_membership
    ADD CONSTRAINT user_group_membership_pkey PRIMARY KEY (user_id, group_id);


--
-- Name: user_option_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_option
    ADD CONSTRAINT user_option_pkey PRIMARY KEY (user_id, option_id);


--
-- Name: user_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: whitelisted_config_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY whitelisted_config
    ADD CONSTRAINT whitelisted_config_pkey PRIMARY KEY (domain_id, "group", option);


--
-- Name: group_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX group_id ON user_group_membership USING btree (group_id);


--
-- Name: ix_access_token_authorizing_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ix_access_token_authorizing_user_id ON access_token USING btree (authorizing_user_id);


--
-- Name: ix_access_token_consumer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ix_access_token_consumer_id ON access_token USING btree (consumer_id);


--
-- Name: ix_actor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ix_actor_id ON assignment USING btree (actor_id);


--
-- Name: ix_default_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ix_default_project_id ON "user" USING btree (default_project_id);


--
-- Name: ix_request_token_consumer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ix_request_token_consumer_id ON request_token USING btree (consumer_id);


--
-- Name: ix_revocation_event_audit_id_issued_before; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ix_revocation_event_audit_id_issued_before ON revocation_event USING btree (audit_id, issued_before);


--
-- Name: ix_revocation_event_issued_before; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ix_revocation_event_issued_before ON revocation_event USING btree (issued_before);


--
-- Name: ix_revocation_event_new_revoked_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ix_revocation_event_new_revoked_at ON revocation_event USING btree (revoked_at);


--
-- Name: ix_revocation_event_project_id_issued_before; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ix_revocation_event_project_id_issued_before ON revocation_event USING btree (project_id, issued_before);


--
-- Name: ix_revocation_event_user_id_issued_before; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ix_revocation_event_user_id_issued_before ON revocation_event USING btree (user_id, issued_before);


--
-- Name: ix_token_expires; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ix_token_expires ON token USING btree (expires);


--
-- Name: ix_token_expires_valid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ix_token_expires_valid ON token USING btree (expires, valid);


--
-- Name: ix_token_trust_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ix_token_trust_id ON token USING btree (trust_id);


--
-- Name: ix_token_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ix_token_user_id ON token USING btree (user_id);


--
-- Name: service_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX service_id ON endpoint USING btree (service_id);


--
-- Name: access_token_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_token
    ADD CONSTRAINT access_token_consumer_id_fkey FOREIGN KEY (consumer_id) REFERENCES consumer(id);


--
-- Name: endpoint_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY endpoint
    ADD CONSTRAINT endpoint_service_id_fkey FOREIGN KEY (service_id) REFERENCES service(id);


--
-- Name: federated_user_idp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY federated_user
    ADD CONSTRAINT federated_user_idp_id_fkey FOREIGN KEY (idp_id) REFERENCES identity_provider(id) ON DELETE CASCADE;


--
-- Name: federated_user_protocol_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY federated_user
    ADD CONSTRAINT federated_user_protocol_id_fkey FOREIGN KEY (protocol_id, idp_id) REFERENCES federation_protocol(id, idp_id) ON DELETE CASCADE;


--
-- Name: federated_user_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY federated_user
    ADD CONSTRAINT federated_user_user_id_fkey FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- Name: federation_protocol_idp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY federation_protocol
    ADD CONSTRAINT federation_protocol_idp_id_fkey FOREIGN KEY (idp_id) REFERENCES identity_provider(id) ON DELETE CASCADE;


--
-- Name: fk_endpoint_region_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY endpoint
    ADD CONSTRAINT fk_endpoint_region_id FOREIGN KEY (region_id) REFERENCES region(id);


--
-- Name: fk_user_group_membership_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_group_membership
    ADD CONSTRAINT fk_user_group_membership_group_id FOREIGN KEY (group_id) REFERENCES "group"(id);


--
-- Name: fk_user_group_membership_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_group_membership
    ADD CONSTRAINT fk_user_group_membership_user_id FOREIGN KEY (user_id) REFERENCES "user"(id);


--
-- Name: identity_provider_domain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY identity_provider
    ADD CONSTRAINT identity_provider_domain_id_fkey FOREIGN KEY (domain_id) REFERENCES project(id);


--
-- Name: idp_remote_ids_idp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY idp_remote_ids
    ADD CONSTRAINT idp_remote_ids_idp_id_fkey FOREIGN KEY (idp_id) REFERENCES identity_provider(id) ON DELETE CASCADE;


--
-- Name: implied_role_implied_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY implied_role
    ADD CONSTRAINT implied_role_implied_role_id_fkey FOREIGN KEY (implied_role_id) REFERENCES role(id) ON DELETE CASCADE;


--
-- Name: implied_role_prior_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY implied_role
    ADD CONSTRAINT implied_role_prior_role_id_fkey FOREIGN KEY (prior_role_id) REFERENCES role(id) ON DELETE CASCADE;


--
-- Name: local_user_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY local_user
    ADD CONSTRAINT local_user_user_id_fkey FOREIGN KEY (user_id, domain_id) REFERENCES "user"(id, domain_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: nonlocal_user_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY nonlocal_user
    ADD CONSTRAINT nonlocal_user_user_id_fkey FOREIGN KEY (user_id, domain_id) REFERENCES "user"(id, domain_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: password_local_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY password
    ADD CONSTRAINT password_local_user_id_fkey FOREIGN KEY (local_user_id) REFERENCES local_user(id) ON DELETE CASCADE;


--
-- Name: project_domain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY project
    ADD CONSTRAINT project_domain_id_fkey FOREIGN KEY (domain_id) REFERENCES project(id);


--
-- Name: project_endpoint_group_endpoint_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY project_endpoint_group
    ADD CONSTRAINT project_endpoint_group_endpoint_group_id_fkey FOREIGN KEY (endpoint_group_id) REFERENCES endpoint_group(id);


--
-- Name: project_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY project
    ADD CONSTRAINT project_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES project(id);


--
-- Name: request_token_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY request_token
    ADD CONSTRAINT request_token_consumer_id_fkey FOREIGN KEY (consumer_id) REFERENCES consumer(id);


--
-- Name: user_domain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_domain_id_fkey FOREIGN KEY (domain_id) REFERENCES project(id);


--
-- Name: user_option_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_option
    ADD CONSTRAINT user_option_user_id_fkey FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

