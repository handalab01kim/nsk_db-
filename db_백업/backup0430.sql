--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4 (Debian 17.4-1.pgdg120+2)
-- Dumped by pg_dump version 17.4 (Debian 17.4-1.pgdg120+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: private; Type: SCHEMA; Schema: -; Owner: handalab
--

CREATE SCHEMA private;


ALTER SCHEMA private OWNER TO handalab;

--
-- Name: create_channel_related_entries(); Type: FUNCTION; Schema: public; Owner: handalab
--

CREATE FUNCTION public.create_channel_related_entries() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO channel_status (id) VALUES (NEW.id);
    INSERT INTO channel_roi (id) VALUES (NEW.id);
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.create_channel_related_entries() OWNER TO handalab;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: system_log; Type: TABLE; Schema: private; Owner: handalab
--

CREATE TABLE private.system_log (
    idx integer NOT NULL,
    process character varying(64) NOT NULL,
    message character varying(256) NOT NULL,
    "time" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE private.system_log OWNER TO handalab;

--
-- Name: system_log_idx_seq; Type: SEQUENCE; Schema: private; Owner: handalab
--

CREATE SEQUENCE private.system_log_idx_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE private.system_log_idx_seq OWNER TO handalab;

--
-- Name: system_log_idx_seq; Type: SEQUENCE OWNED BY; Schema: private; Owner: handalab
--

ALTER SEQUENCE private.system_log_idx_seq OWNED BY private.system_log.idx;


--
-- Name: channel_info; Type: TABLE; Schema: public; Owner: handalab
--

CREATE TABLE public.channel_info (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    description character varying(256),
    timeset integer DEFAULT 0 NOT NULL,
    preset integer DEFAULT 0 NOT NULL,
    rtspurl character varying(256) NOT NULL,
    pixel integer DEFAULT 50 NOT NULL
);


ALTER TABLE public.channel_info OWNER TO handalab;

--
-- Name: channel_roi; Type: TABLE; Schema: public; Owner: handalab
--

CREATE TABLE public.channel_roi (
    id integer NOT NULL,
    pos character varying(256) DEFAULT '""'::character varying NOT NULL
);


ALTER TABLE public.channel_roi OWNER TO handalab;

--
-- Name: channel_status; Type: TABLE; Schema: public; Owner: handalab
--

CREATE TABLE public.channel_status (
    id integer NOT NULL,
    status integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.channel_status OWNER TO handalab;

--
-- Name: history; Type: TABLE; Schema: public; Owner: handalab
--

CREATE TABLE public.history (
    idx integer NOT NULL,
    id integer NOT NULL,
    name character varying(256) NOT NULL,
    "time" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.history OWNER TO handalab;

--
-- Name: history_idx_seq; Type: SEQUENCE; Schema: public; Owner: handalab
--

CREATE SEQUENCE public.history_idx_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.history_idx_seq OWNER TO handalab;

--
-- Name: history_idx_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: handalab
--

ALTER SEQUENCE public.history_idx_seq OWNED BY public.history.idx;


--
-- Name: member; Type: TABLE; Schema: public; Owner: handalab
--

CREATE TABLE public.member (
    email character varying(64) NOT NULL,
    password character varying(64) NOT NULL,
    admin boolean DEFAULT false NOT NULL,
    nickname character varying(64)
);


ALTER TABLE public.member OWNER TO handalab;

--
-- Name: system_log idx; Type: DEFAULT; Schema: private; Owner: handalab
--

ALTER TABLE ONLY private.system_log ALTER COLUMN idx SET DEFAULT nextval('private.system_log_idx_seq'::regclass);


--
-- Name: history idx; Type: DEFAULT; Schema: public; Owner: handalab
--

ALTER TABLE ONLY public.history ALTER COLUMN idx SET DEFAULT nextval('public.history_idx_seq'::regclass);


--
-- Name: system_log system_log_pk; Type: CONSTRAINT; Schema: private; Owner: handalab
--

ALTER TABLE ONLY private.system_log
    ADD CONSTRAINT system_log_pk PRIMARY KEY (idx);


--
-- Name: channel_info channel_info_pk; Type: CONSTRAINT; Schema: public; Owner: handalab
--

ALTER TABLE ONLY public.channel_info
    ADD CONSTRAINT channel_info_pk PRIMARY KEY (id);


--
-- Name: channel_status channel_status_pk; Type: CONSTRAINT; Schema: public; Owner: handalab
--

ALTER TABLE ONLY public.channel_status
    ADD CONSTRAINT channel_status_pk PRIMARY KEY (id);


--
-- Name: member member_pk; Type: CONSTRAINT; Schema: public; Owner: handalab
--

ALTER TABLE ONLY public.member
    ADD CONSTRAINT member_pk PRIMARY KEY (email);


--
-- Name: channel_roi newtable_pk; Type: CONSTRAINT; Schema: public; Owner: handalab
--

ALTER TABLE ONLY public.channel_roi
    ADD CONSTRAINT newtable_pk PRIMARY KEY (id);


--
-- Name: channel_info after_channel_info_insert; Type: TRIGGER; Schema: public; Owner: handalab
--

CREATE TRIGGER after_channel_info_insert AFTER INSERT ON public.channel_info FOR EACH ROW EXECUTE FUNCTION public.create_channel_related_entries();


--
-- Name: channel_roi channel_roi_channel_info_fk; Type: FK CONSTRAINT; Schema: public; Owner: handalab
--

ALTER TABLE ONLY public.channel_roi
    ADD CONSTRAINT channel_roi_channel_info_fk FOREIGN KEY (id) REFERENCES public.channel_info(id) ON UPDATE SET DEFAULT ON DELETE CASCADE;


--
-- Name: channel_status channel_status_channel_info_fk; Type: FK CONSTRAINT; Schema: public; Owner: handalab
--

ALTER TABLE ONLY public.channel_status
    ADD CONSTRAINT channel_status_channel_info_fk FOREIGN KEY (id) REFERENCES public.channel_info(id) ON UPDATE SET DEFAULT ON DELETE CASCADE;


--
-- Name: history history_channel_info_fk; Type: FK CONSTRAINT; Schema: public; Owner: handalab
--

ALTER TABLE ONLY public.history
    ADD CONSTRAINT history_channel_info_fk FOREIGN KEY (id) REFERENCES public.channel_info(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

