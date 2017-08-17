--
-- PostgreSQL database dump
--

DROP DATABASE keystone;
--
-- Name: keystone; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE keystone ENCODING = 'UTF8' ;


\connect keystone

SET search_path = public, pg_catalog;

--
-- Name: access_token; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE access_token (
    id character varying(64) NOT NULL PRIMARY KEY,
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
    type STRING NOT NULL,
    actor_id character varying(64) NOT NULL,
    target_id character varying(64) NOT NULL,
    role_id character varying(64) NOT NULL,
    inherited boolean NOT NULL,
    CONSTRAINT asignment_pk  PRIMARY KEY (type, actor_id, target_id, role_id, inherited)
);


--
-- Name: config_register; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE config_register (
    type character varying(64) NOT NULL PRIMARY KEY,
    domain_id character varying(64) NOT NULL
);


--
-- Name: consumer; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE consumer (
    id character varying(64) NOT NULL PRIMARY KEY,
    description character varying(64),
    secret character varying(64) NOT NULL,
    extra text NOT NULL
);


--
-- Name: credential; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE credential (
    id character varying(64) NOT NULL PRIMARY KEY,
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
    id character varying(64) NOT NULL PRIMARY KEY,
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
    id character varying(64) NOT NULL PRIMARY KEY,
    name character varying(255) NOT NULL,
    description text,
    filters text NOT NULL
);


--
-- Name: federated_user; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE federated_user (
    id SERIAL NOT NULL PRIMARY KEY,
    user_id character varying(64) NOT NULL,
    idp_id character varying(64) NOT NULL,
    protocol_id character varying(64) NOT NULL,
    unique_id character varying(255) NOT NULL,
    display_name character varying(255)
);


--
-- Name: federation_protocol; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE federation_protocol (
    id character varying(64) NOT NULL,
    idp_id character varying(64) NOT NULL,
    mapping_id character varying(64) NOT NULL,
    CONSTRAINT federation_protocol_pkey PRIMARY KEY (id, idp_id)
);


--
-- Name: group; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE "group" (
    id character varying(64) NOT NULL PRIMARY KEY,
    domain_id character varying(64) NOT NULL,
    name character varying(64) NOT NULL,
    description text,
    extra text
);


--
-- Name: id_mapping; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE id_mapping (
    public_id character varying(64) NOT NULL PRIMARY KEY,
    domain_id character varying(64) NOT NULL,
    local_id character varying(64) NOT NULL,
    entity_type STRING NOT NULL
);


--
-- Name: identity_provider; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE identity_provider (
    id character varying(64) NOT NULL PRIMARY KEY,
    enabled boolean NOT NULL,
    description text,
    domain_id character varying(64) NOT NULL
);


--
-- Name: idp_remote_ids; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE idp_remote_ids (
    idp_id character varying(64),
    remote_id character varying(255) NOT NULL PRIMARY KEY
);


--
-- Name: implied_role; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE implied_role (
    prior_role_id character varying(64) NOT NULL,
    implied_role_id character varying(64) NOT NULL,
    CONSTRAINT federation_protocol_pkey PRIMARY KEY (prior_role_id, implied_role_id)
);


--
-- Name: local_user; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE local_user (
    id SERIAL NOT NULL PRIMARY KEY,
    user_id character varying(64) NOT NULL,
    domain_id character varying(64) NOT NULL,
    name character varying(255) NOT NULL,
    failed_auth_count integer,
    failed_auth_at timestamp without time zone
);

--
-- Name: mapping; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE mapping (
    id character varying(64) NOT NULL PRIMARY KEY,
    rules text NOT NULL
);


--
-- Name: migrate_version; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE migrate_version (
    repository_id character varying(250) NOT NULL PRIMARY KEY,
    repository_path text,
    version integer
);


--
-- Name: nonlocal_user; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE nonlocal_user (
    domain_id character varying(64) NOT NULL,
    name character varying(255) NOT NULL,
    user_id character varying(64) NOT NULL,
    CONSTRAINT nonlocal_user_pkey PRIMARY KEY (domain_id, name)
);


--
-- Name: password; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE password (
    id SERIAL  NOT NULL PRIMARY KEY,
    local_user_id integer NOT NULL,
    password character varying(128),
    expires_at timestamp without time zone,
    self_service boolean DEFAULT false NOT NULL,
    password_hash character varying(255),
    created_at timestamp without time zone NOT NULL
);

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
    id character varying(64) NOT NULL PRIMARY KEY,
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
    project_id character varying(64) NOT NULL,
    CONSTRAINT project_endpoint_pkey PRIMARY KEY (endpoint_id, project_id)
);


--
-- Name: project_endpoint_group; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE project_endpoint_group (
    endpoint_group_id character varying(64) NOT NULL,
    project_id character varying(64) NOT NULL,
    CONSTRAINT project_endpoint_group_pkey PRIMARY KEY (endpoint_group_id, project_id)
);


--
-- Name: region; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE region (
    id character varying(255) NOT NULL PRIMARY KEY,
    description character varying(255) NOT NULL,
    parent_region_id character varying(255),
    extra text
);


--
-- Name: request_token; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE request_token (
    id character varying(64) NOT NULL PRIMARY KEY,
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
    id SERIAL NOT NULL PRIMARY KEY,
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
-- Name: role; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE role (
    id character varying(64) NOT NULL PRIMARY KEY,
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
    value text NOT NULL,
    CONSTRAINT sensitive_config_pkey PRIMARY KEY (domain_id, "group", option)
);


--
-- Name: service; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE service (
    id character varying(64) NOT NULL PRIMARY KEY,
    type character varying(255),
    enabled boolean DEFAULT true NOT NULL,
    extra text
);


--
-- Name: service_provider; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE service_provider (
    auth_url character varying(256) NOT NULL PRIMARY KEY,
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
    id character varying(64) NOT NULL PRIMARY KEY,
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
    id character varying(64) NOT NULL PRIMARY KEY,
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
    role_id character varying(64) NOT NULL,
    CONSTRAINT trust_role_pkey PRIMARY KEY (trust_id, role_id)
);


--
-- Name: user; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE "user" (
    id character varying(64) NOT NULL PRIMARY KEY,
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
    group_id character varying(64) NOT NULL,
    CONSTRAINT user_group_membership_pkey PRIMARY KEY (user_id, group_id)
);


--
-- Name: user_option; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE user_option (
    user_id character varying(64) NOT NULL,
    option_id character varying(4) NOT NULL,
    option_value text,
    CONSTRAINT user_option_pkey PRIMARY KEY (user_id, option_id)
);


--
-- Name: whitelisted_config; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE whitelisted_config (
    domain_id character varying(64) NOT NULL,
    "group" character varying(255) NOT NULL,
    option character varying(255) NOT NULL,
    value text NOT NULL,
    CONSTRAINT whitelisted_config_pkey PRIMARY KEY (domain_id, "group", option)
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

--- ALTER TABLE ONLY federated_user ALTER COLUMN id SET DEFAULT nextval('federated_user_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

--- ALTER TABLE ONLY local_user ALTER COLUMN id SET DEFAULT nextval('local_user_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

--- ALTER TABLE ONLY password ALTER COLUMN id SET DEFAULT nextval('password_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

--- ALTER TABLE ONLY revocation_event ALTER COLUMN id SET DEFAULT nextval('revocation_event_new_id_seq'::regclass);


--
-- Data for Name: access_token; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: assignment; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO assignment (type, actor_id, target_id, role_id, inherited) VALUES ('UserProject', '08bdcc01a2f9415d967f2fb6ab44d50a', 'de323fb857e843b2be04ca59d129a234', '4d99333e721940e4bb278e213d1c770d', false);
INSERT INTO assignment (type, actor_id, target_id, role_id, inherited) VALUES ('UserDomain', '08bdcc01a2f9415d967f2fb6ab44d50a', 'default', '4d99333e721940e4bb278e213d1c770d', false);
INSERT INTO assignment (type, actor_id, target_id, role_id, inherited) VALUES ('UserProject', 'd21896e8420649fe9c7e41f01ba40c55', 'ea73f6bb8c4544518fe903efc737acf3', '833d37e07b324b399b32ae4811d05b33', false);
INSERT INTO assignment (type, actor_id, target_id, role_id, inherited) VALUES ('UserProject', '08bdcc01a2f9415d967f2fb6ab44d50a', 'ea73f6bb8c4544518fe903efc737acf3', '4d99333e721940e4bb278e213d1c770d', false);
INSERT INTO assignment (type, actor_id, target_id, role_id, inherited) VALUES ('UserProject', 'd21896e8420649fe9c7e41f01ba40c55', 'ea73f6bb8c4544518fe903efc737acf3', '6f1f43276f0840fb8d20566bdd5e1a80', false);
INSERT INTO assignment (type, actor_id, target_id, role_id, inherited) VALUES ('UserProject', 'd21896e8420649fe9c7e41f01ba40c55', 'a31769f11b4847dfbb2b44dba784ca42', '833d37e07b324b399b32ae4811d05b33', false);
INSERT INTO assignment (type, actor_id, target_id, role_id, inherited) VALUES ('UserProject', 'c1f5c10a52e94d45b81cd37430155828', '8d1d8b4447284b2481a69f01c8c428bb', '833d37e07b324b399b32ae4811d05b33', false);
INSERT INTO assignment (type, actor_id, target_id, role_id, inherited) VALUES ('UserProject', '08bdcc01a2f9415d967f2fb6ab44d50a', '8d1d8b4447284b2481a69f01c8c428bb', '4d99333e721940e4bb278e213d1c770d', false);
INSERT INTO assignment (type, actor_id, target_id, role_id, inherited) VALUES ('UserProject', 'c1f5c10a52e94d45b81cd37430155828', '8d1d8b4447284b2481a69f01c8c428bb', '6f1f43276f0840fb8d20566bdd5e1a80', false);
INSERT INTO assignment (type, actor_id, target_id, role_id, inherited) VALUES ('GroupProject', 'dc3e3aaf3664411b98d1c48b14b0c2e8', 'ea73f6bb8c4544518fe903efc737acf3', '833d37e07b324b399b32ae4811d05b33', false);
INSERT INTO assignment (type, actor_id, target_id, role_id, inherited) VALUES ('GroupProject', 'dc3e3aaf3664411b98d1c48b14b0c2e8', 'ea73f6bb8c4544518fe903efc737acf3', '6f1f43276f0840fb8d20566bdd5e1a80', false);
INSERT INTO assignment (type, actor_id, target_id, role_id, inherited) VALUES ('GroupProject', 'dc3e3aaf3664411b98d1c48b14b0c2e8', '8d1d8b4447284b2481a69f01c8c428bb', '833d37e07b324b399b32ae4811d05b33', false);
INSERT INTO assignment (type, actor_id, target_id, role_id, inherited) VALUES ('GroupProject', 'dc3e3aaf3664411b98d1c48b14b0c2e8', '8d1d8b4447284b2481a69f01c8c428bb', '6f1f43276f0840fb8d20566bdd5e1a80', false);
INSERT INTO assignment (type, actor_id, target_id, role_id, inherited) VALUES ('GroupProject', '6b02cf133c5741ec87e77d50eb9d5867', 'de323fb857e843b2be04ca59d129a234', '4d99333e721940e4bb278e213d1c770d', false);


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

INSERT INTO endpoint (id, legacy_endpoint_id, interface, service_id, url, extra, enabled, region_id) VALUES ('f913a501d7a743a199ddf697f5b1641f', NULL, 'admin', '71e79e35bcc54afeac977cc84764533b', 'http://10.0.2.15', '{}', true, 'RegionOne');
INSERT INTO endpoint (id, legacy_endpoint_id, interface, service_id, url, extra, enabled, region_id) VALUES ('6ea0212b7f4946629ba12e22ac3779d4', NULL, 'public', '71e79e35bcc54afeac977cc84764533b', 'http://10.0.2.15', '{}', true, 'RegionOne');



--- SELECT pg_catalog.setval('federated_user_id_seq', 1, false);


--
-- Data for Name: federation_protocol; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: group; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "group" (id, domain_id, name, description, extra) VALUES ('6b02cf133c5741ec87e77d50eb9d5867', 'default', 'admins', 'openstack admin group', '{}');
INSERT INTO "group" (id, domain_id, name, description, extra) VALUES ('dc3e3aaf3664411b98d1c48b14b0c2e8', 'default', 'nonadmins', 'non-admin group', '{}');


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

INSERT INTO local_user (id, user_id, domain_id, name, failed_auth_count, failed_auth_at) VALUES (1, '08bdcc01a2f9415d967f2fb6ab44d50a', 'default', 'admin', 0, NULL);
INSERT INTO local_user (id, user_id, domain_id, name, failed_auth_count, failed_auth_at) VALUES (2, 'd21896e8420649fe9c7e41f01ba40c55', 'default', 'demo', 0, NULL);
INSERT INTO local_user (id, user_id, domain_id, name, failed_auth_count, failed_auth_at) VALUES (3, 'c1f5c10a52e94d45b81cd37430155828', 'default', 'alt_demo', 0, NULL);


--
-- Name: local_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

--- SELECT pg_catalog.setval('local_user_id_seq', 3, true);


--
-- Data for Name: mapping; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: migrate_version; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO migrate_version (repository_id, repository_path, version) VALUES ('keystone_data_migrate', '/opt/stack/keystone/keystone/common/sql/data_migration_repo', 23);
INSERT INTO migrate_version (repository_id, repository_path, version) VALUES ('keystone', '/opt/stack/keystone/keystone/common/sql/migrate_repo', 109);
INSERT INTO migrate_version (repository_id, repository_path, version) VALUES ('keystone_contract', '/opt/stack/keystone/keystone/common/sql/contract_repo', 23);
INSERT INTO migrate_version (repository_id, repository_path, version) VALUES ('keystone_expand', '/opt/stack/keystone/keystone/common/sql/expand_repo', 23);



--
-- Data for Name: nonlocal_user; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: password; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO password (id, local_user_id, password, expires_at, self_service, password_hash, created_at) VALUES (1, 1, NULL, NULL, false, '$2b$04$/1NkNsDTZbyg5yvolYXq8ufsJlZFgysobJkVienxNZfRq/SmjUHYK', '2017-08-10 10:36:29.414803');
INSERT INTO password (id, local_user_id, password, expires_at, self_service, password_hash, created_at) VALUES (2, 2, NULL, NULL, false, '$2b$04$3oku2Zq.86wjP6ybNfk9lOZoHUM1cqR6SAnDzBJyBEUSWsYQ34U.K', '2017-08-10 10:36:54.553759');
INSERT INTO password (id, local_user_id, password, expires_at, self_service, password_hash, created_at) VALUES (3, 3, NULL, NULL, false, '$2b$04$kZiv1qtZf7GpTBrpz.vMYe3/qKDx0Pr3xQuSNFBO0JlH8Eo7.LSQS', '2017-08-10 10:37:17.728999');


--- SELECT pg_catalog.setval('password_id_seq', 3, true);


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
INSERT INTO project (id, name, extra, description, enabled, domain_id, parent_id, is_domain) VALUES ('de323fb857e843b2be04ca59d129a234', 'admin', '{}', 'Bootstrap project for initializing the cloud.', true, 'default', 'default', false);
INSERT INTO project (id, name, extra, description, enabled, domain_id, parent_id, is_domain) VALUES ('b6682d680a754250bc686b739036a81d', 'service', '{}', '', true, 'default', 'default', false);
INSERT INTO project (id, name, extra, description, enabled, domain_id, parent_id, is_domain) VALUES ('a31769f11b4847dfbb2b44dba784ca42', 'invisible_to_admin', '{}', '', true, 'default', 'default', false);
INSERT INTO project (id, name, extra, description, enabled, domain_id, parent_id, is_domain) VALUES ('ea73f6bb8c4544518fe903efc737acf3', 'demo', '{}', '', true, 'default', 'default', false);
INSERT INTO project (id, name, extra, description, enabled, domain_id, parent_id, is_domain) VALUES ('8d1d8b4447284b2481a69f01c8c428bb', 'alt_demo', '{}', '', true, 'default', 'default', false);


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




--- SELECT pg_catalog.setval('revocation_event_new_id_seq', 1, false);


--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO role (id, name, extra, domain_id) VALUES ('4d99333e721940e4bb278e213d1c770d', 'admin', '{}', '<<null>>');
INSERT INTO role (id, name, extra, domain_id) VALUES ('9fe2ff9ee4384b1894a90878d3e92bab', '_member_', '{}', '<<null>>');
INSERT INTO role (id, name, extra, domain_id) VALUES ('a59478aba14547f8b8739589d7a3da88', 'service', '{}', '<<null>>');
INSERT INTO role (id, name, extra, domain_id) VALUES ('54c57c478cf74098a2831864f5a94ac0', 'ResellerAdmin', '{}', '<<null>>');
INSERT INTO role (id, name, extra, domain_id) VALUES ('631f65c026a3473fb378d5840661f617', 'Member', '{}', '<<null>>');
INSERT INTO role (id, name, extra, domain_id) VALUES ('833d37e07b324b399b32ae4811d05b33', 'member', '{}', '<<null>>');
INSERT INTO role (id, name, extra, domain_id) VALUES ('6f1f43276f0840fb8d20566bdd5e1a80', 'anotherrole', '{}', '<<null>>');


--
-- Data for Name: sensitive_config; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: service; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO service (id, type, enabled, extra) VALUES ('71e79e35bcc54afeac977cc84764533b', 'identity', true, '{"name": "keystone"}');


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

INSERT INTO "user" (id, extra, enabled, default_project_id, created_at, last_active_at, domain_id) VALUES ('08bdcc01a2f9415d967f2fb6ab44d50a', '{}', true, NULL, '2017-08-10 10:36:29.4446', NULL, 'default');
INSERT INTO "user" (id, extra, enabled, default_project_id, created_at, last_active_at, domain_id) VALUES ('d21896e8420649fe9c7e41f01ba40c55', '{"email": "demo@example.com"}', true, NULL, '2017-08-10 10:36:54.555453', NULL, 'default');
INSERT INTO "user" (id, extra, enabled, default_project_id, created_at, last_active_at, domain_id) VALUES ('c1f5c10a52e94d45b81cd37430155828', '{"email": "alt_demo@example.com"}', true, NULL, '2017-08-10 10:37:17.730495', NULL, 'default');


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

--- ALTER TABLE ONLY access_token
--- ADD CONSTRAINT access_token_pkey PRIMARY KEY (id);


--
-- Name: assignment_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY assignment
---    ADD CONSTRAINT assignment_pkey PRIMARY KEY (type, actor_id, target_id, role_id, inherited);


--
-- Name: config_register_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY config_register
---     ADD CONSTRAINT config_register_pkey PRIMARY KEY (type);


--
-- Name: consumer_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY consumer
---     ADD CONSTRAINT consumer_pkey PRIMARY KEY (id);


--
-- Name: credential_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY credential
---     ADD CONSTRAINT credential_pkey PRIMARY KEY (id);


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

--- ALTER TABLE ONLY endpoint_group
---     ADD CONSTRAINT endpoint_group_pkey PRIMARY KEY (id);


--
-- Name: endpoint_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY endpoint
---     ADD CONSTRAINT endpoint_pkey PRIMARY KEY (id);


--
-- Name: federated_user_idp_id_protocol_id_unique_id_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY federated_user
    ADD CONSTRAINT federated_user_idp_id_protocol_id_unique_id_key UNIQUE (idp_id, protocol_id, unique_id);


--
-- Name: federated_user_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY federated_user
---     ADD CONSTRAINT federated_user_pkey PRIMARY KEY (id);


--
-- Name: federation_protocol_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY federation_protocol
---     ADD CONSTRAINT federation_protocol_pkey PRIMARY KEY (id, idp_id);


--
-- Name: group_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY "group"
---     ADD CONSTRAINT group_pkey PRIMARY KEY (id);


--
-- Name: id_mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY id_mapping
---     ADD CONSTRAINT id_mapping_pkey PRIMARY KEY (public_id);


--
-- Name: identity_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY identity_provider
---     ADD CONSTRAINT identity_provider_pkey PRIMARY KEY (id);


--
-- Name: idp_remote_ids_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY idp_remote_ids
---     ADD CONSTRAINT idp_remote_ids_pkey PRIMARY KEY (remote_id);


--
-- Name: implied_role_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY implied_role
---     ADD CONSTRAINT implied_role_pkey PRIMARY KEY (prior_role_id, implied_role_id);


--
-- Name: ixu_group_name_domain_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY "group"
    ADD CONSTRAINT ixu_group_name_domain_id UNIQUE (domain_id, name);


--
-- Name: ixu_nonlocal_user_user_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY nonlocal_user
---     ADD CONSTRAINT ixu_nonlocal_user_user_id UNIQUE (user_id);


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

--- ALTER TABLE ONLY local_user
---     ADD CONSTRAINT local_user_pkey PRIMARY KEY (id);


--
-- Name: local_user_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY local_user
---     ADD CONSTRAINT local_user_user_id_key UNIQUE (user_id);


--
-- Name: mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY mapping
---     ADD CONSTRAINT mapping_pkey PRIMARY KEY (id);


--
-- Name: migrate_version_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY migrate_version
---     ADD CONSTRAINT migrate_version_pkey PRIMARY KEY (repository_id);


--
-- Name: nonlocal_user_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY nonlocal_user
---     ADD CONSTRAINT nonlocal_user_pkey PRIMARY KEY (domain_id, name);


--
-- Name: password_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY password
---     ADD CONSTRAINT password_pkey PRIMARY KEY (id);


--
-- Name: policy_association_endpoint_id_service_id_region_id_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY policy_association
    ADD CONSTRAINT policy_association_endpoint_id_service_id_region_id_key UNIQUE (endpoint_id, service_id, region_id);


--
-- Name: policy_association_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY policy_association
---     ADD CONSTRAINT policy_association_pkey PRIMARY KEY (id);


--
-- Name: policy_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY policy
---     ADD CONSTRAINT policy_pkey PRIMARY KEY (id);


--
-- Name: project_endpoint_group_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY project_endpoint_group
---     ADD CONSTRAINT project_endpoint_group_pkey PRIMARY KEY (endpoint_group_id, project_id);


--
-- Name: project_endpoint_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY project_endpoint
---     ADD CONSTRAINT project_endpoint_pkey PRIMARY KEY (endpoint_id, project_id);


--
-- Name: project_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY project
---     ADD CONSTRAINT project_pkey PRIMARY KEY (id);


--
-- Name: region_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY region
---     ADD CONSTRAINT region_pkey PRIMARY KEY (id);


--
-- Name: request_token_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY request_token
---     ADD CONSTRAINT request_token_pkey PRIMARY KEY (id);


--
-- Name: revocation_event_new_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY revocation_event
---     ADD CONSTRAINT revocation_event_new_pkey PRIMARY KEY (id);


--
-- Name: role_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY role
---     ADD CONSTRAINT role_pkey PRIMARY KEY (id);


--
-- Name: sensitive_config_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY sensitive_config
---     ADD CONSTRAINT sensitive_config_pkey PRIMARY KEY (domain_id, "group", option);


--
-- Name: service_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY service
---     ADD CONSTRAINT service_pkey PRIMARY KEY (id);


--
-- Name: service_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY service_provider
---     ADD CONSTRAINT service_provider_pkey PRIMARY KEY (id);


--
-- Name: token_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY token
---     ADD CONSTRAINT token_pkey PRIMARY KEY (id);


--
-- Name: trust_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY trust
---     ADD CONSTRAINT trust_pkey PRIMARY KEY (id);


--
-- Name: trust_role_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY trust_role
---     ADD CONSTRAINT trust_role_pkey PRIMARY KEY (trust_id, role_id);


--
-- Name: user_group_membership_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY user_group_membership
---     ADD CONSTRAINT user_group_membership_pkey PRIMARY KEY (user_id, group_id);


--
-- Name: user_option_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY user_option
---     ADD CONSTRAINT user_option_pkey PRIMARY KEY (user_id, option_id);


--
-- Name: user_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY "user"
---     ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: whitelisted_config_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

--- ALTER TABLE ONLY whitelisted_config
---     ADD CONSTRAINT whitelisted_config_pkey PRIMARY KEY (domain_id, "group", option);


--
-- Name: group_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX group_id ON user_group_membership (group_id);


--
-- Name: ix_access_token_authorizing_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX ix_access_token_authorizing_user_id ON access_token (authorizing_user_id);


--
-- Name: ix_access_token_consumer_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX ix_access_token_consumer_id ON access_token (consumer_id);


--
-- Name: ix_actor_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX ix_actor_id ON assignment (actor_id);

--
-- Name: ix_default_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX ix_default_project_id ON "user" (default_project_id);

--
-- Name: ix_request_token_consumer_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX ix_request_token_consumer_id ON request_token (consumer_id);


--
-- Name: ix_revocation_event_audit_id_issued_before; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX ix_revocation_event_audit_id_issued_before ON revocation_event (audit_id, issued_before);


--
-- Name: ix_revocation_event_issued_before; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX ix_revocation_event_issued_before ON revocation_event  (issued_before);


--
-- Name: ix_revocation_event_new_revoked_at; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX ix_revocation_event_new_revoked_at ON revocation_event (revoked_at);


--
-- Name: ix_revocation_event_project_id_issued_before; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX ix_revocation_event_project_id_issued_before ON revocation_event (project_id, issued_before);


--
-- Name: ix_revocation_event_user_id_issued_before; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX ix_revocation_event_user_id_issued_before ON revocation_event (user_id, issued_before);


--
-- Name: ix_token_expires; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX ix_token_expires ON token (expires);


--
-- Name: ix_token_expires_valid; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX ix_token_expires_valid ON token (expires, valid);


--
-- Name: ix_token_trust_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX ix_token_trust_id ON token (trust_id);


--
-- Name: ix_token_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX ix_token_user_id ON token (user_id);


--
-- Name: service_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX service_id ON endpoint (service_id);


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
    ADD CONSTRAINT federated_user_idp_id_fkey FOREIGN KEY (idp_id) REFERENCES identity_provider(id)
;


--
-- Name: federated_user_protocol_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

CREATE INDEX protocol_idp_idx ON federated_user (protocol_id, idp_id);

ALTER TABLE ONLY federated_user
    ADD CONSTRAINT federated_user_protocol_id_fkey FOREIGN KEY (protocol_id, idp_id) REFERENCES federation_protocol(id, idp_id) ;


--
-- Name: federated_user_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

CREATE INDEX user_id_idx ON federated_user (user_id);

ALTER TABLE ONLY federated_user
    ADD CONSTRAINT federated_user_user_id_fkey FOREIGN KEY (user_id) REFERENCES "user"(id) ;


--
-- Name: federation_protocol_idp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

CREATE INDEX idp_idx ON federation_protocol (idp_id);

ALTER TABLE ONLY federation_protocol
    ADD CONSTRAINT federation_protocol_idp_id_fkey FOREIGN KEY (idp_id) REFERENCES identity_provider(id) ;


--
-- Name: fk_endpoint_region_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

CREATE INDEX region_idx ON endpoint (region_id);

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

CREATE INDEX domain_idx ON identity_provider (domain_id);

ALTER TABLE ONLY identity_provider
    ADD CONSTRAINT identity_provider_domain_id_fkey FOREIGN KEY (domain_id) REFERENCES project(id);


--
-- Name: idp_remote_ids_idp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

CREATE INDEX idp_idx ON idp_remote_ids (idp_id);

ALTER TABLE ONLY idp_remote_ids
    ADD CONSTRAINT idp_remote_ids_idp_id_fkey FOREIGN KEY (idp_id) REFERENCES identity_provider(id) ;


--
-- Name: implied_role_implied_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

CREATE INDEX implied_role_idx ON implied_role (implied_role_id);

ALTER TABLE ONLY implied_role
    ADD CONSTRAINT implied_role_implied_role_id_fkey FOREIGN KEY (implied_role_id) REFERENCES role(id) ;


--
-- Name: implied_role_prior_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY implied_role
    ADD CONSTRAINT implied_role_prior_role_id_fkey FOREIGN KEY (prior_role_id) REFERENCES role(id) ;


--
-- Name: local_user_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

CREATE INDEX user_domain_idx ON local_user (user_id, domain_id);

ALTER TABLE ONLY local_user
    ADD CONSTRAINT local_user_user_id_fkey FOREIGN KEY (user_id, domain_id) REFERENCES "user"(id, domain_id)  ;


--
-- Name: nonlocal_user_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

CREATE INDEX user_domain_idx ON nonlocal_user (user_id, domain_id);

ALTER TABLE ONLY nonlocal_user
    ADD CONSTRAINT nonlocal_user_user_id_fkey FOREIGN KEY (user_id, domain_id) REFERENCES "user"(id,
domain_id);


--
-- Name: password_local_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

CREATE INDEX local_user_idx ON password (local_user_id);

ALTER TABLE ONLY password
    ADD CONSTRAINT password_local_user_id_fkey FOREIGN KEY (local_user_id) REFERENCES local_user(id) ;


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

CREATE INDEX parent_idx ON project (parent_id);

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

CREATE INDEX domain_idx ON "user" (domain_id);

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_domain_id_fkey FOREIGN KEY (domain_id) REFERENCES project(id);


--
-- Name: user_option_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_option
    ADD CONSTRAINT user_option_user_id_fkey FOREIGN KEY (user_id) REFERENCES "user"(id) ;


--
-- Name: public; Type: ACL; Schema: -; Owner: -
--

--- REVOKE ALL ON SCHEMA public FROM PUBLIC;
--- REVOKE ALL ON SCHEMA public FROM postgres;
--- GRANT ALL ON SCHEMA public TO postgres;
--- GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--