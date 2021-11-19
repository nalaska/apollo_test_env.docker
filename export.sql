--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Drop databases (except postgres and template1)
--





--
-- Drop roles
--

DROP ROLE postgres;


--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'md5d870fdc733701e62d2e02d9ab278c235';






--
-- Databases
--

--
-- Database "template1" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 12.8 (Debian 12.8-1.pgdg110+1)
-- Dumped by pg_dump version 12.8 (Debian 12.8-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

UPDATE pg_catalog.pg_database SET datistemplate = false WHERE datname = 'template1';
DROP DATABASE template1;
--
-- Name: template1; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';


ALTER DATABASE template1 OWNER TO postgres;

\connect template1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE template1; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- Name: template1; Type: DATABASE PROPERTIES; Schema: -; Owner: postgres
--

ALTER DATABASE template1 IS_TEMPLATE = true;


\connect template1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE template1; Type: ACL; Schema: -; Owner: postgres
--

REVOKE CONNECT,TEMPORARY ON DATABASE template1 FROM PUBLIC;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 12.8 (Debian 12.8-1.pgdg110+1)
-- Dumped by pg_dump version 12.8 (Debian 12.8-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE postgres;
--
-- Name: postgres; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';


ALTER DATABASE postgres OWNER TO postgres;

\connect postgres

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- Name: hdb_catalog; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA hdb_catalog;


ALTER SCHEMA hdb_catalog OWNER TO postgres;

--
-- Name: jt; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA jt;


ALTER SCHEMA jt OWNER TO postgres;

--
-- Name: gen_hasura_uuid(); Type: FUNCTION; Schema: hdb_catalog; Owner: postgres
--

CREATE FUNCTION hdb_catalog.gen_hasura_uuid() RETURNS uuid
    LANGUAGE sql
    AS $$select gen_random_uuid()$$;


ALTER FUNCTION hdb_catalog.gen_hasura_uuid() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: hdb_action_log; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_action_log (
    id uuid DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    action_name text,
    input_payload jsonb NOT NULL,
    request_headers jsonb NOT NULL,
    session_variables jsonb NOT NULL,
    response_payload jsonb,
    errors jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    response_received_at timestamp with time zone,
    status text NOT NULL,
    CONSTRAINT hdb_action_log_status_check CHECK ((status = ANY (ARRAY['created'::text, 'processing'::text, 'completed'::text, 'error'::text])))
);


ALTER TABLE hdb_catalog.hdb_action_log OWNER TO postgres;

--
-- Name: hdb_cron_event_invocation_logs; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_cron_event_invocation_logs (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    event_id text,
    status integer,
    request json,
    response json,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE hdb_catalog.hdb_cron_event_invocation_logs OWNER TO postgres;

--
-- Name: hdb_cron_events; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_cron_events (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    trigger_name text NOT NULL,
    scheduled_time timestamp with time zone NOT NULL,
    status text DEFAULT 'scheduled'::text NOT NULL,
    tries integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    next_retry_at timestamp with time zone,
    CONSTRAINT valid_status CHECK ((status = ANY (ARRAY['scheduled'::text, 'locked'::text, 'delivered'::text, 'error'::text, 'dead'::text])))
);


ALTER TABLE hdb_catalog.hdb_cron_events OWNER TO postgres;

--
-- Name: hdb_metadata; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_metadata (
    id integer NOT NULL,
    metadata json NOT NULL,
    resource_version integer DEFAULT 1 NOT NULL
);


ALTER TABLE hdb_catalog.hdb_metadata OWNER TO postgres;

--
-- Name: hdb_scheduled_event_invocation_logs; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_scheduled_event_invocation_logs (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    event_id text,
    status integer,
    request json,
    response json,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE hdb_catalog.hdb_scheduled_event_invocation_logs OWNER TO postgres;

--
-- Name: hdb_scheduled_events; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_scheduled_events (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    webhook_conf json NOT NULL,
    scheduled_time timestamp with time zone NOT NULL,
    retry_conf json,
    payload json,
    header_conf json,
    status text DEFAULT 'scheduled'::text NOT NULL,
    tries integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    next_retry_at timestamp with time zone,
    comment text,
    CONSTRAINT valid_status CHECK ((status = ANY (ARRAY['scheduled'::text, 'locked'::text, 'delivered'::text, 'error'::text, 'dead'::text])))
);


ALTER TABLE hdb_catalog.hdb_scheduled_events OWNER TO postgres;

--
-- Name: hdb_schema_notifications; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_schema_notifications (
    id integer NOT NULL,
    notification json NOT NULL,
    resource_version integer DEFAULT 1 NOT NULL,
    instance_id uuid NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT hdb_schema_notifications_id_check CHECK ((id = 1))
);


ALTER TABLE hdb_catalog.hdb_schema_notifications OWNER TO postgres;

--
-- Name: hdb_version; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_version (
    hasura_uuid uuid DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    version text NOT NULL,
    upgraded_on timestamp with time zone NOT NULL,
    cli_state jsonb DEFAULT '{}'::jsonb NOT NULL,
    console_state jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE hdb_catalog.hdb_version OWNER TO postgres;

--
-- Name: base_annonce; Type: TABLE; Schema: jt; Owner: postgres
--

CREATE TABLE public.base_annonce (
    id integer NOT NULL,
    id_categorie integer NOT NULL,
    titre text NOT NULL,
    ordre smallint NOT NULL,
    extrait text,
    description text NOT NULL,
    date_creation date NOT NULL,
    date_modification date NOT NULL,
    date_publication date NOT NULL,
    archive integer DEFAULT 0 NOT NULL,
    disponibilite integer DEFAULT 0 NOT NULL,
    genere integer DEFAULT 0 NOT NULL,
    brouillon integer DEFAULT 0 NOT NULL,
    afficher integer DEFAULT 10 NOT NULL
);


ALTER TABLE public.base_annonce OWNER TO postgres;

--
-- Name: base_annonce_id_seq; Type: SEQUENCE; Schema: jt; Owner: postgres
--

CREATE SEQUENCE public.base_annonce_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.base_annonce_id_seq OWNER TO postgres;

--
-- Name: base_annonce_id_seq; Type: SEQUENCE OWNED BY; Schema: jt; Owner: postgres
--

ALTER SEQUENCE public.base_annonce_id_seq OWNED BY public.base_annonce.id;


--
-- Name: base_categorie; Type: TABLE; Schema: jt; Owner: postgres
--

CREATE TABLE public.base_categorie (
    id integer NOT NULL,
    id_parent smallint DEFAULT 0 NOT NULL,
    id_typologie integer NOT NULL,
    nom text NOT NULL,
    ordre integer NOT NULL,
    accueil integer NOT NULL,
    url text NOT NULL,
    url_ancienne text,
    seo_url text NOT NULL,
    seo_titre text NOT NULL,
    seo_description text NOT NULL,
    seo_h1 text NOT NULL,
    seo_ariane text,
    parent smallint DEFAULT 0 NOT NULL,
    visible smallint NOT NULL,
    visible2 smallint NOT NULL,
    laius smallint NOT NULL,
    nb_images smallint NOT NULL,
    nb_fichier smallint NOT NULL,
    tpl_listing text NOT NULL,
    tpl_fiche text NOT NULL
);


ALTER TABLE public.base_categorie OWNER TO postgres;

--
-- Name: base_categorie_id_seq; Type: SEQUENCE; Schema: jt; Owner: postgres
--

CREATE SEQUENCE public.base_categorie_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.base_categorie_id_seq OWNER TO postgres;

--
-- Name: base_categorie_id_seq; Type: SEQUENCE OWNED BY; Schema: jt; Owner: postgres
--

ALTER SEQUENCE public.base_categorie_id_seq OWNED BY public.base_categorie.id;


--
-- Name: base_image; Type: TABLE; Schema: jt; Owner: postgres
--

CREATE TABLE public.base_image (
    id integer NOT NULL,
    id_annonce integer NOT NULL,
    nom text NOT NULL,
    legende text NOT NULL,
    titile text DEFAULT 'null'::text,
    recadree smallint DEFAULT 0 NOT NULL,
    ordre smallint DEFAULT 0 NOT NULL
);


ALTER TABLE public.base_image OWNER TO postgres;

--
-- Name: base_image_id_seq; Type: SEQUENCE; Schema: jt; Owner: postgres
--

CREATE SEQUENCE public.base_image_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.base_image_id_seq OWNER TO postgres;

--
-- Name: base_image_id_seq; Type: SEQUENCE OWNED BY; Schema: jt; Owner: postgres
--

ALTER SEQUENCE public.base_image_id_seq OWNED BY public.base_image.id;


--
-- Name: base_message; Type: TABLE; Schema: jt; Owner: postgres
--

CREATE TABLE public.base_message (
    id integer NOT NULL,
    date date NOT NULL,
    nom text NOT NULL,
    telephone integer NOT NULL,
    fax integer,
    email text NOT NULL,
    objet text NOT NULL,
    adresse text,
    message text NOT NULL,
    statut boolean NOT NULL
);


ALTER TABLE public.base_message OWNER TO postgres;

--
-- Name: base_message_id_seq; Type: SEQUENCE; Schema: jt; Owner: postgres
--

CREATE SEQUENCE public.base_message_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.base_message_id_seq OWNER TO postgres;

--
-- Name: base_message_id_seq; Type: SEQUENCE OWNED BY; Schema: jt; Owner: postgres
--

ALTER SEQUENCE public.base_message_id_seq OWNED BY public.base_message.id;


--
-- Name: base_typologie; Type: TABLE; Schema: jt; Owner: postgres
--

CREATE TABLE public.base_typologie (
    id integer NOT NULL,
    libelle text NOT NULL,
    page smallint NOT NULL
);


ALTER TABLE public.base_typologie OWNER TO postgres;

--
-- Name: base_typologie_id_seq; Type: SEQUENCE; Schema: jt; Owner: postgres
--

CREATE SEQUENCE public.base_typologie_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.base_typologie_id_seq OWNER TO postgres;

--
-- Name: base_typologie_id_seq; Type: SEQUENCE OWNED BY; Schema: jt; Owner: postgres
--

ALTER SEQUENCE public.base_typologie_id_seq OWNED BY public.base_typologie.id;


--
-- Name: base_annonce id; Type: DEFAULT; Schema: jt; Owner: postgres
--

ALTER TABLE ONLY public.base_annonce ALTER COLUMN id SET DEFAULT nextval('public.base_annonce_id_seq'::regclass);


--
-- Name: base_categorie id; Type: DEFAULT; Schema: jt; Owner: postgres
--

ALTER TABLE ONLY public.base_categorie ALTER COLUMN id SET DEFAULT nextval('public.base_categorie_id_seq'::regclass);


--
-- Name: base_image id; Type: DEFAULT; Schema: jt; Owner: postgres
--

ALTER TABLE ONLY public.base_image ALTER COLUMN id SET DEFAULT nextval('public.base_image_id_seq'::regclass);


--
-- Name: base_message id; Type: DEFAULT; Schema: jt; Owner: postgres
--

ALTER TABLE ONLY public.base_message ALTER COLUMN id SET DEFAULT nextval('public.base_message_id_seq'::regclass);


--
-- Name: base_typologie id; Type: DEFAULT; Schema: jt; Owner: postgres
--

ALTER TABLE ONLY public.base_typologie ALTER COLUMN id SET DEFAULT nextval('public.base_typologie_id_seq'::regclass);


--
-- Name: hdb_action_log hdb_action_log_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_action_log
    ADD CONSTRAINT hdb_action_log_pkey PRIMARY KEY (id);


--
-- Name: hdb_cron_event_invocation_logs hdb_cron_event_invocation_logs_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_event_invocation_logs
    ADD CONSTRAINT hdb_cron_event_invocation_logs_pkey PRIMARY KEY (id);


--
-- Name: hdb_cron_events hdb_cron_events_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_events
    ADD CONSTRAINT hdb_cron_events_pkey PRIMARY KEY (id);


--
-- Name: hdb_metadata hdb_metadata_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_metadata
    ADD CONSTRAINT hdb_metadata_pkey PRIMARY KEY (id);


--
-- Name: hdb_metadata hdb_metadata_resource_version_key; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_metadata
    ADD CONSTRAINT hdb_metadata_resource_version_key UNIQUE (resource_version);


--
-- Name: hdb_scheduled_event_invocation_logs hdb_scheduled_event_invocation_logs_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_event_invocation_logs
    ADD CONSTRAINT hdb_scheduled_event_invocation_logs_pkey PRIMARY KEY (id);


--
-- Name: hdb_scheduled_events hdb_scheduled_events_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_events
    ADD CONSTRAINT hdb_scheduled_events_pkey PRIMARY KEY (id);


--
-- Name: hdb_schema_notifications hdb_schema_notifications_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_schema_notifications
    ADD CONSTRAINT hdb_schema_notifications_pkey PRIMARY KEY (id);


--
-- Name: hdb_version hdb_version_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_version
    ADD CONSTRAINT hdb_version_pkey PRIMARY KEY (hasura_uuid);


--
-- Name: base_annonce base_annonce_id_key; Type: CONSTRAINT; Schema: jt; Owner: postgres
--

ALTER TABLE ONLY public.base_annonce
    ADD CONSTRAINT base_annonce_id_key UNIQUE (id);


--
-- Name: base_annonce base_annonce_pkey; Type: CONSTRAINT; Schema: jt; Owner: postgres
--

ALTER TABLE ONLY public.base_annonce
    ADD CONSTRAINT base_annonce_pkey PRIMARY KEY (id);


--
-- Name: base_categorie base_categorie_pkey; Type: CONSTRAINT; Schema: jt; Owner: postgres
--

ALTER TABLE ONLY public.base_categorie
    ADD CONSTRAINT base_categorie_pkey PRIMARY KEY (id);


--
-- Name: base_image base_image_pkey; Type: CONSTRAINT; Schema: jt; Owner: postgres
--

ALTER TABLE ONLY public.base_image
    ADD CONSTRAINT base_image_pkey PRIMARY KEY (id);


--
-- Name: base_message base_message_pkey; Type: CONSTRAINT; Schema: jt; Owner: postgres
--

ALTER TABLE ONLY public.base_message
    ADD CONSTRAINT base_message_pkey PRIMARY KEY (id);


--
-- Name: base_typologie base_typologie_pkey; Type: CONSTRAINT; Schema: jt; Owner: postgres
--

ALTER TABLE ONLY public.base_typologie
    ADD CONSTRAINT base_typologie_pkey PRIMARY KEY (id);


--
-- Name: hdb_cron_event_invocation_event_id; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE INDEX hdb_cron_event_invocation_event_id ON hdb_catalog.hdb_cron_event_invocation_logs USING btree (event_id);


--
-- Name: hdb_cron_event_status; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE INDEX hdb_cron_event_status ON hdb_catalog.hdb_cron_events USING btree (status);


--
-- Name: hdb_cron_events_unique_scheduled; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE UNIQUE INDEX hdb_cron_events_unique_scheduled ON hdb_catalog.hdb_cron_events USING btree (trigger_name, scheduled_time) WHERE (status = 'scheduled'::text);


--
-- Name: hdb_scheduled_event_status; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE INDEX hdb_scheduled_event_status ON hdb_catalog.hdb_scheduled_events USING btree (status);


--
-- Name: hdb_version_one_row; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE UNIQUE INDEX hdb_version_one_row ON hdb_catalog.hdb_version USING btree (((version IS NOT NULL)));


--
-- Name: hdb_cron_event_invocation_logs hdb_cron_event_invocation_logs_event_id_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_event_invocation_logs
    ADD CONSTRAINT hdb_cron_event_invocation_logs_event_id_fkey FOREIGN KEY (event_id) REFERENCES hdb_catalog.hdb_cron_events(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: hdb_scheduled_event_invocation_logs hdb_scheduled_event_invocation_logs_event_id_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_event_invocation_logs
    ADD CONSTRAINT hdb_scheduled_event_invocation_logs_event_id_fkey FOREIGN KEY (event_id) REFERENCES hdb_catalog.hdb_scheduled_events(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: base_annonce base_annonce_id_categorie_fkey; Type: FK CONSTRAINT; Schema: jt; Owner: postgres
--

ALTER TABLE ONLY public.base_annonce
    ADD CONSTRAINT base_annonce_id_categorie_fkey FOREIGN KEY (id_categorie) REFERENCES public.base_categorie(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: base_categorie base_categorie_id_typologie_fkey; Type: FK CONSTRAINT; Schema: jt; Owner: postgres
--

ALTER TABLE ONLY public.base_categorie
    ADD CONSTRAINT base_categorie_id_typologie_fkey FOREIGN KEY (id_typologie) REFERENCES public.base_typologie(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: base_image base_image_id_annonce_fkey; Type: FK CONSTRAINT; Schema: jt; Owner: postgres
--

ALTER TABLE ONLY public.base_image
    ADD CONSTRAINT base_image_id_annonce_fkey FOREIGN KEY (id_annonce) REFERENCES public.base_annonce(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

