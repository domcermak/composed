SET
    statement_timeout = 0;
SET
    lock_timeout = 0;
SET
    idle_in_transaction_session_timeout = 0;
SET
    client_encoding = 'UTF8';
SET
    standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET
    check_function_bodies = false;
SET
    xmloption = content;
SET
    client_min_messages = warning;
SET
    row_security = off;


--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA IF NOT EXISTS public;


--
-- Name: session_type; Type: ENUM; Schema: public; Owner: -
--

CREATE TYPE public.session_type AS ENUM ('user');


--
-- Name: worker_type; Type: ENUM; Schema: public; Owner: -
--

CREATE TYPE public.worker_type AS ENUM ('text_to_image_worker', 'sketch_to_image_worker');


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sessions
(
    id         serial                      NOT NULL,
    uuid       uuid                        NOT NULL,
    type       public.session_type         NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schedules
(
    id              serial                      NOT NULL,
    session_id      bigint                      NOT NULL,
    sketch_image    bytea,
    original_text   text,
    translated_text text,
    created_at      timestamp without time zone NOT NULL
);

--
-- Name: generated_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.generated_images
(
    id              serial                      NOT NULL,
    generated_image bytea                       NOT NULL,
    schedule_id     bigint                      NOT NULL,
    user_notified   boolean DEFAULT false       NOT NULL,
    worker_type     public.worker_type          NOT NULL,
    created_at      timestamp without time zone NOT NULL
);


--
-- Name: sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: scheduled_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_pkey PRIMARY KEY (id);


--
-- Name: generated_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generated_images
    ADD CONSTRAINT generated_images_pkey PRIMARY KEY (id);


--
-- Name: fk__scheduled_images__sessions; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT fk__schedules__sessions
        FOREIGN KEY (session_id)
            REFERENCES public.sessions (id) ON
            DELETE
            CASCADE;


--
-- Name: fk__generated_images__scheduled_images; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generated_images
    ADD CONSTRAINT fk__generated_images__schedules
        FOREIGN KEY (schedule_id)
            REFERENCES public.schedules (id) ON
            DELETE
            CASCADE;


--
-- Name: idx_sessions_type_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_sessions_type_uuid ON public.sessions (type, uuid);
