--
-- PostgreSQL database dump
--

-- Dumped from database version 12.9 (Debian 12.9-1.pgdg110+1)
-- Dumped by pg_dump version 12.9 (Debian 12.9-1.pgdg110+1)

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
-- Name: hdb_catalog; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA hdb_catalog;


ALTER SCHEMA hdb_catalog OWNER TO postgres;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


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
-- Name: base_annonce; Type: TABLE; Schema: public; Owner: postgres
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
-- Name: base_annonce_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
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
-- Name: base_annonce_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.base_annonce_id_seq OWNED BY public.base_annonce.id;


--
-- Name: base_categorie; Type: TABLE; Schema: public; Owner: postgres
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
-- Name: base_categorie_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
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
-- Name: base_categorie_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.base_categorie_id_seq OWNED BY public.base_categorie.id;


--
-- Name: base_image; Type: TABLE; Schema: public; Owner: postgres
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
-- Name: base_image_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
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
-- Name: base_image_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.base_image_id_seq OWNED BY public.base_image.id;


--
-- Name: base_message; Type: TABLE; Schema: public; Owner: postgres
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
-- Name: base_message_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
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
-- Name: base_message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.base_message_id_seq OWNED BY public.base_message.id;


--
-- Name: base_typologie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.base_typologie (
    id integer NOT NULL,
    libelle text NOT NULL,
    page smallint NOT NULL
);


ALTER TABLE public.base_typologie OWNER TO postgres;

--
-- Name: base_typologie_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
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
-- Name: base_typologie_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.base_typologie_id_seq OWNED BY public.base_typologie.id;


--
-- Name: base_annonce id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.base_annonce ALTER COLUMN id SET DEFAULT nextval('public.base_annonce_id_seq'::regclass);


--
-- Name: base_categorie id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.base_categorie ALTER COLUMN id SET DEFAULT nextval('public.base_categorie_id_seq'::regclass);


--
-- Name: base_image id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.base_image ALTER COLUMN id SET DEFAULT nextval('public.base_image_id_seq'::regclass);


--
-- Name: base_message id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.base_message ALTER COLUMN id SET DEFAULT nextval('public.base_message_id_seq'::regclass);


--
-- Name: base_typologie id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.base_typologie ALTER COLUMN id SET DEFAULT nextval('public.base_typologie_id_seq'::regclass);


--
-- Data for Name: hdb_action_log; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_action_log (id, action_name, input_payload, request_headers, session_variables, response_payload, errors, created_at, response_received_at, status) FROM stdin;
\.


--
-- Data for Name: hdb_cron_event_invocation_logs; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_cron_event_invocation_logs (id, event_id, status, request, response, created_at) FROM stdin;
\.


--
-- Data for Name: hdb_cron_events; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_cron_events (id, trigger_name, scheduled_time, status, tries, created_at, next_retry_at) FROM stdin;
\.


--
-- Data for Name: hdb_metadata; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_metadata (id, metadata, resource_version) FROM stdin;
1	{"sources":[{"kind":"postgres","name":"jt","tables":[{"object_relationships":[{"using":{"foreign_key_constraint_on":"id_categorie"},"name":"categorie"}],"table":{"schema":"public","name":"base_annonce"},"array_relationships":[{"using":{"foreign_key_constraint_on":{"column":"id_annonce","table":{"schema":"public","name":"base_image"}}},"name":"images"}]},{"object_relationships":[{"using":{"foreign_key_constraint_on":"id_typologie"},"name":"typologie"}],"table":{"schema":"public","name":"base_categorie"},"array_relationships":[{"using":{"foreign_key_constraint_on":{"column":"id_categorie","table":{"schema":"public","name":"base_annonce"}}},"name":"annonces"}]},{"object_relationships":[{"using":{"foreign_key_constraint_on":"id_annonce"},"name":"annonce"}],"table":{"schema":"public","name":"base_image"}},{"table":{"schema":"public","name":"base_message"}},{"table":{"schema":"public","name":"base_typologie"},"array_relationships":[{"using":{"foreign_key_constraint_on":{"column":"id_typologie","table":{"schema":"public","name":"base_categorie"}}},"name":"categorie"}]}],"configuration":{"connection_info":{"use_prepared_statements":false,"database_url":"postgres://postgres:postgrespassword@postgres:5432/postgres","isolation_level":"read-committed"}}}],"version":3}	29
\.


--
-- Data for Name: hdb_scheduled_event_invocation_logs; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_scheduled_event_invocation_logs (id, event_id, status, request, response, created_at) FROM stdin;
\.


--
-- Data for Name: hdb_scheduled_events; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_scheduled_events (id, webhook_conf, scheduled_time, retry_conf, payload, header_conf, status, tries, created_at, next_retry_at, comment) FROM stdin;
\.


--
-- Data for Name: hdb_schema_notifications; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_schema_notifications (id, notification, resource_version, instance_id, updated_at) FROM stdin;
1	{"metadata":false,"remote_schemas":[],"sources":["jt"]}	29	9c769726-c2c6-4f7a-a42e-f0104b49bea2	2021-11-17 15:47:03.730734+00
\.


--
-- Data for Name: hdb_version; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_version (hasura_uuid, version, upgraded_on, cli_state, console_state) FROM stdin;
29f7cafc-4834-4569-a67d-f3b4e2e507eb	47	2021-11-17 08:34:11.29971+00	{}	{"console_notifications": {"admin": {"date": "2021-11-19T13:19:41.286Z", "read": "default", "showBadge": false}}, "telemetryNotificationShown": true}
\.


--
-- Data for Name: base_annonce; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.base_annonce (id, id_categorie, titre, ordre, extrait, description, date_creation, date_modification, date_publication, archive, disponibilite, genere, brouillon, afficher) FROM stdin;
2	1	Annuaire g├®n├®raliste d'entreprises de travaux publics ├á##Marseille Provence##Jalis	127	Un guide pratique et utile pour profiter du meilleur du web. Des informations et des services en ligne. Un panorama de savoir-faire, de ressources et de comp├®tences ├á votre disposition 	<p>Un guide pratique et utile pour profiter du meilleur du web. Des informations et des services en ligne. Un panorama de savoir-faire, de ressources et de comp├®tences ├á votre disposition.<br /><br /></p> <p>Retrouvez les <a href="https://www.jalis.fr/leurs-temoignages-1.html">t├®moignages de nos clients</a>.┬á</p>	2021-07-22	2021-07-22	2021-07-22	0	0	0	0	1
3	1	super annonce jalis	127	Un guide pratique et utile pour profiter du meilleur du web. Des informations et des services en ligne. Un panorama de savoir-faire, de ressources et de comp├®tences ├á votre disposition 	Where does it come from? Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.  The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.	2021-07-22	2021-07-22	2021-07-22	0	0	0	0	1
\.


--
-- Data for Name: base_categorie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.base_categorie (id, id_parent, id_typologie, nom, ordre, accueil, url, url_ancienne, seo_url, seo_titre, seo_description, seo_h1, seo_ariane, parent, visible, visible2, laius, nb_images, nb_fichier, tpl_listing, tpl_fiche) FROM stdin;
1	0	1	La soci├®t├®	10	1		\N	accueil-la-societe	Sp├®cialiste pour les travaux publics ├á Miramas, Istres, Salon-de-Provence (13)	Ô£à Vous cherchez un sp├®cialiste pour vos travaux publics et vos travaux de terrassement pour les trous de piscine ├á Miramas (13) ? Vous souhaitez une entreprise de travaux publics pour des mises aux normes de fosses septiques en cas de vente ? Contactez-nous.	Entreprise de travaux publics en r├®gion Provence-Alpes-C├┤te d'Azur	\N	0	1	1	0	1	0		page_accueil
\.


--
-- Data for Name: base_image; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.base_image (id, id_annonce, nom, legende, titile, recadree, ordre) FROM stdin;
2	2	agenceweb_jalis.gif	Agence SEO ├á Marseille	\N	0	0
3	3	annuaire_guidejalis.gif	annuaire	\N	0	0
\.


--
-- Data for Name: base_message; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.base_message (id, date, nom, telephone, fax, email, objet, adresse, message, statut) FROM stdin;
\.


--
-- Data for Name: base_typologie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.base_typologie (id, libelle, page) FROM stdin;
1	accueil	1
\.


--
-- Name: base_annonce_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.base_annonce_id_seq', 3, true);


--
-- Name: base_categorie_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.base_categorie_id_seq', 1, true);


--
-- Name: base_image_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.base_image_id_seq', 3, true);


--
-- Name: base_message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.base_message_id_seq', 1, false);


--
-- Name: base_typologie_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.base_typologie_id_seq', 1, true);


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
-- Name: base_annonce base_annonce_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.base_annonce
    ADD CONSTRAINT base_annonce_id_key UNIQUE (id);


--
-- Name: base_annonce base_annonce_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.base_annonce
    ADD CONSTRAINT base_annonce_pkey PRIMARY KEY (id);


--
-- Name: base_categorie base_categorie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.base_categorie
    ADD CONSTRAINT base_categorie_pkey PRIMARY KEY (id);


--
-- Name: base_image base_image_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.base_image
    ADD CONSTRAINT base_image_pkey PRIMARY KEY (id);


--
-- Name: base_typologie base_typologie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
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
-- Name: base_annonce base_annonce_id_categorie_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.base_annonce
    ADD CONSTRAINT base_annonce_id_categorie_fkey FOREIGN KEY (id_categorie) REFERENCES public.base_categorie(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: base_categorie base_categorie_id_typologie_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.base_categorie
    ADD CONSTRAINT base_categorie_id_typologie_fkey FOREIGN KEY (id_typologie) REFERENCES public.base_typologie(id);


--
-- Name: base_image base_image_id_annonce_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.base_image
    ADD CONSTRAINT base_image_id_annonce_fkey FOREIGN KEY (id_annonce) REFERENCES public.base_annonce(id);


--
-- PostgreSQL database dump complete
--

