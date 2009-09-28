--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: absences; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE absences (
    id integer NOT NULL,
    since timestamp without time zone,
    until timestamp without time zone,
    doctor_id integer NOT NULL,
    couse character varying(256),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: absences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE absences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: absences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE absences_id_seq OWNED BY absences.id;


--
-- Name: doctor_specialities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE doctor_specialities (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    doctor_id integer NOT NULL,
    speciality_id integer NOT NULL,
    since timestamp without time zone NOT NULL
);


--
-- Name: doctor_specialities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE doctor_specialities_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: doctor_specialities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE doctor_specialities_id_seq OWNED BY doctor_specialities.id;


--
-- Name: examination_kinds; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE examination_kinds (
    id integer NOT NULL,
    name text,
    description text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: examination_kinds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE examination_kinds_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: examination_kinds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE examination_kinds_id_seq OWNED BY examination_kinds.id;


--
-- Name: examinations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE examinations (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    examination_kind_id integer NOT NULL,
    doctor_id integer NOT NULL,
    visit_id integer,
    execution_date timestamp without time zone NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: examinations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE examinations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: examinations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE examinations_id_seq OWNED BY examinations.id;


--
-- Name: places; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE places (
    id integer NOT NULL,
    name text,
    address text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: places_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE places_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: places_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE places_id_seq OWNED BY places.id;


--
-- Name: referral_examination_kinds; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE referral_examination_kinds (
    id integer NOT NULL,
    referral_id integer NOT NULL,
    examination_kind_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: referral_examination_kinds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE referral_examination_kinds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: referral_examination_kinds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE referral_examination_kinds_id_seq OWNED BY referral_examination_kinds.id;


--
-- Name: referrals; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE referrals (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    doctor_id integer NOT NULL,
    visit_id integer,
    expire timestamp without time zone NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: referrals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE referrals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: referrals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE referrals_id_seq OWNED BY referrals.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE roles (
    id integer NOT NULL,
    name character varying(255)
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE roles_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;


--
-- Name: roles_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE roles_users (
    role_id integer,
    user_id integer
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: specialities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE specialities (
    id integer NOT NULL,
    name text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: specialities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE specialities_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: specialities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE specialities_id_seq OWNED BY specialities.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    login character varying(40),
    name character varying(100) DEFAULT ''::character varying,
    email character varying(100),
    crypted_password character varying(40),
    salt character varying(40),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    remember_token character varying(40),
    remember_token_expires_at timestamp without time zone,
    activation_code character varying(40),
    activated_at timestamp without time zone,
    state character varying(255) DEFAULT 'passive'::character varying,
    deleted_at timestamp without time zone,
    type character varying(20) DEFAULT 'User'::character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: visit_reservations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE visit_reservations (
    id integer NOT NULL,
    since timestamp without time zone,
    until timestamp without time zone,
    status character varying(1),
    patient_id integer NOT NULL,
    doctor_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: visit_reservations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE visit_reservations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: visit_reservations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE visit_reservations_id_seq OWNED BY visit_reservations.id;


--
-- Name: visits; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE visits (
    id integer NOT NULL,
    since timestamp without time zone,
    until timestamp without time zone,
    note text,
    patient_id integer NOT NULL,
    doctor_id integer NOT NULL,
    visit_reservation_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: visits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE visits_id_seq OWNED BY visits.id;


--
-- Name: worktimes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE worktimes (
    id integer NOT NULL,
    since timestamp without time zone NOT NULL,
    until timestamp without time zone NOT NULL,
    doctor_id integer NOT NULL,
    place_id integer NOT NULL,
    day_of_week character varying(3) NOT NULL,
    repetition character varying(3) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: worktimes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE worktimes_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: worktimes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE worktimes_id_seq OWNED BY worktimes.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE absences ALTER COLUMN id SET DEFAULT nextval('absences_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE doctor_specialities ALTER COLUMN id SET DEFAULT nextval('doctor_specialities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE examination_kinds ALTER COLUMN id SET DEFAULT nextval('examination_kinds_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE examinations ALTER COLUMN id SET DEFAULT nextval('examinations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE places ALTER COLUMN id SET DEFAULT nextval('places_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE referral_examination_kinds ALTER COLUMN id SET DEFAULT nextval('referral_examination_kinds_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE referrals ALTER COLUMN id SET DEFAULT nextval('referrals_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE specialities ALTER COLUMN id SET DEFAULT nextval('specialities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE visit_reservations ALTER COLUMN id SET DEFAULT nextval('visit_reservations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE visits ALTER COLUMN id SET DEFAULT nextval('visits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE worktimes ALTER COLUMN id SET DEFAULT nextval('worktimes_id_seq'::regclass);


--
-- Name: absences_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY absences
    ADD CONSTRAINT absences_pkey PRIMARY KEY (id);


--
-- Name: doctor_specialities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY doctor_specialities
    ADD CONSTRAINT doctor_specialities_pkey PRIMARY KEY (id);


--
-- Name: examination_kinds_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY examination_kinds
    ADD CONSTRAINT examination_kinds_pkey PRIMARY KEY (id);


--
-- Name: examinations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY examinations
    ADD CONSTRAINT examinations_pkey PRIMARY KEY (id);


--
-- Name: places_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY places
    ADD CONSTRAINT places_pkey PRIMARY KEY (id);


--
-- Name: referral_examination_kinds_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY referral_examination_kinds
    ADD CONSTRAINT referral_examination_kinds_pkey PRIMARY KEY (id);


--
-- Name: referrals_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY referrals
    ADD CONSTRAINT referrals_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: specialities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY specialities
    ADD CONSTRAINT specialities_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: visit_reservations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY visit_reservations
    ADD CONSTRAINT visit_reservations_pkey PRIMARY KEY (id);


--
-- Name: visits_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY visits
    ADD CONSTRAINT visits_pkey PRIMARY KEY (id);


--
-- Name: worktimes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY worktimes
    ADD CONSTRAINT worktimes_pkey PRIMARY KEY (id);


--
-- Name: index_absences_on_doctor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_absences_on_doctor_id ON absences USING btree (doctor_id);


--
-- Name: index_doctor_specialities_on_doctor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_doctor_specialities_on_doctor_id ON doctor_specialities USING btree (doctor_id);


--
-- Name: index_doctor_specialities_on_speciality_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_doctor_specialities_on_speciality_id ON doctor_specialities USING btree (speciality_id);


--
-- Name: index_referrals_on_doctor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_referrals_on_doctor_id ON referrals USING btree (doctor_id);


--
-- Name: index_referrals_on_patient_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_referrals_on_patient_id ON referrals USING btree (patient_id);


--
-- Name: index_referrals_on_visit_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_referrals_on_visit_id ON referrals USING btree (visit_id);


--
-- Name: index_roles_users_on_role_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_roles_users_on_role_id ON roles_users USING btree (role_id);


--
-- Name: index_roles_users_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_roles_users_on_user_id ON roles_users USING btree (user_id);


--
-- Name: index_users_on_login; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_login ON users USING btree (login);


--
-- Name: index_visit_reservations_on_doctor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_visit_reservations_on_doctor_id ON visit_reservations USING btree (doctor_id);


--
-- Name: index_visit_reservations_on_patient_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_visit_reservations_on_patient_id ON visit_reservations USING btree (patient_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20090922201816');

INSERT INTO schema_migrations (version) VALUES ('20090925114249');

INSERT INTO schema_migrations (version) VALUES ('20090925114508');

INSERT INTO schema_migrations (version) VALUES ('20090925120133');

INSERT INTO schema_migrations (version) VALUES ('20090925120813');

INSERT INTO schema_migrations (version) VALUES ('20090925120855');

INSERT INTO schema_migrations (version) VALUES ('20090925122205');

INSERT INTO schema_migrations (version) VALUES ('20090925122438');

INSERT INTO schema_migrations (version) VALUES ('20090925122856');

INSERT INTO schema_migrations (version) VALUES ('20090925123249');

INSERT INTO schema_migrations (version) VALUES ('20090925123902');

INSERT INTO schema_migrations (version) VALUES ('20090925161309');

INSERT INTO schema_migrations (version) VALUES ('20090925212958');