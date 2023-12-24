--
-- PostgreSQL database dump
--

-- Dumped from database version 15.5
-- Dumped by pg_dump version 16.0

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: tur; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tur (
    turno integer NOT NULL,
    turad character varying(15) NOT NULL
);


ALTER TABLE public.tur OWNER TO postgres;

--
-- Name: getirtur(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getirtur(turid integer) RETURNS public.tur
    LANGUAGE plpgsql
    AS $$
DECLARE
    turkaydi tur;
BEGIN
    SELECT * INTO turkaydi FROM tur WHERE turNo = turid;
    RETURN turkaydi;
END;
$$;


ALTER FUNCTION public.getirtur(turid integer) OWNER TO postgres;

--
-- Name: hayvanturekle(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.hayvanturekle() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    
    IF NEW.turno = 1 THEN
        INSERT INTO Memeli (turNo, ad) VALUES (NEW.turno, NEW.hayvanAd);
    ELSIF NEW.turno = 2 THEN
        INSERT INTO Surungen (turNo, ad) VALUES (NEW.turno, NEW.hayvanAd);
    ELSIF NEW.turno = 3 THEN
        INSERT INTO Kus (turNo, ad) VALUES (NEW.turno, NEW.hayvanAd);
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.hayvanturekle() OWNER TO postgres;

--
-- Name: hayvanvekalitimisil(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.hayvanvekalitimisil() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        -- Silinen kaydın türüne göre ilgili tablodan da silme işlemi yap
        DELETE FROM Memeli WHERE turNo = OLD.turNo;
        DELETE FROM Surungen WHERE turNo = OLD.turNo;
        DELETE FROM Kus WHERE turNo = OLD.turNo;
    END IF;

    RETURN OLD;
END;
$$;


ALTER FUNCTION public.hayvanvekalitimisil() OWNER TO postgres;

--
-- Name: maasbilgisiekle(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.maasbilgisiekle(maas integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO maasbilgisi (maasMiktari) VALUES (maas);
END;
$$;


ALTER FUNCTION public.maasbilgisiekle(maas integer) OWNER TO postgres;

--
-- Name: maasbilgisiguncelle(integer, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.maasbilgisiguncelle(maasid integer, yenimaas numeric) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE maasbilgisi SET maasMiktari = yenimaas WHERE maasNo = maasid;
END;
$$;


ALTER FUNCTION public.maasbilgisiguncelle(maasid integer, yenimaas numeric) OWNER TO postgres;

--
-- Name: maasbilgisisil(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.maasbilgisisil(maasid integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM maasbilgisi WHERE maasNo = maasid;
END;
$$;


ALTER FUNCTION public.maasbilgisisil(maasid integer) OWNER TO postgres;

--
-- Name: personel_insert_trigger(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.personel_insert_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Yeni eklenen personel kaydını kullanarak ilgili tablolara ekleme yapma
    IF NEW.personeltur = 'saglikci' THEN
        INSERT INTO saglikci (personelno, ad, soyad) VALUES (NEW.personelno, NEW.ad, NEW.soyad);
    ELSIF NEW.personeltur = 'bakici' THEN
        INSERT INTO bakici (personelno, ad, soyad) VALUES (NEW.personelno, NEW.ad, NEW.soyad);
    ELSIF NEW.personeltur = 'guvenlikgorevlisi' THEN
        INSERT INTO guvenlikgorevlisi (personelno, ad, soyad) VALUES (NEW.personelno, NEW.ad, NEW.soyad);
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.personel_insert_trigger() OWNER TO postgres;

--
-- Name: personelkalitimisil(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.personelkalitimisil() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        -- Silinen personelin türüne göre ilgili tablodan da silme işlemi yap
        DELETE FROM Saglikci WHERE personelno = OLD.personelno;
        DELETE FROM Bakici WHERE personelno = OLD.personelno;
        DELETE FROM GuvenlikGorevlisi WHERE personelno = OLD.personelno;
    END IF;

    RETURN OLD;
END;
$$;


ALTER FUNCTION public.personelkalitimisil() OWNER TO postgres;

--
-- Name: personel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personel (
    personelno integer NOT NULL,
    ad character varying(15),
    soyad character varying(15),
    personeltur character varying(30),
    maasno integer
);


ALTER TABLE public.personel OWNER TO postgres;

--
-- Name: bakici; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bakici (
    personelno integer
)
INHERITS (public.personel);


ALTER TABLE public.bakici OWNER TO postgres;

--
-- Name: beslenme_bilgisi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.beslenme_bilgisi (
    beslenmeno integer NOT NULL,
    beslenme_tipi character varying(50)
);


ALTER TABLE public.beslenme_bilgisi OWNER TO postgres;

--
-- Name: beslenme_bilgisi_beslenmeno_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.beslenme_bilgisi_beslenmeno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.beslenme_bilgisi_beslenmeno_seq OWNER TO postgres;

--
-- Name: beslenme_bilgisi_beslenmeno_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.beslenme_bilgisi_beslenmeno_seq OWNED BY public.beslenme_bilgisi.beslenmeno;


--
-- Name: biletsatis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.biletsatis (
    biletno integer NOT NULL,
    biletfiyat integer
);


ALTER TABLE public.biletsatis OWNER TO postgres;

--
-- Name: biletsatis_biletno_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.biletsatis_biletno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.biletsatis_biletno_seq OWNER TO postgres;

--
-- Name: biletsatis_biletno_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.biletsatis_biletno_seq OWNED BY public.biletsatis.biletno;


--
-- Name: guvenlikgorevlisi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.guvenlikgorevlisi (
    personelno integer
)
INHERITS (public.personel);


ALTER TABLE public.guvenlikgorevlisi OWNER TO postgres;

--
-- Name: habitat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.habitat (
    habitatno integer NOT NULL,
    habitat_tipi character varying(50)
);


ALTER TABLE public.habitat OWNER TO postgres;

--
-- Name: habitat_habitatno_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.habitat_habitatno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.habitat_habitatno_seq OWNER TO postgres;

--
-- Name: habitat_habitatno_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.habitat_habitatno_seq OWNED BY public.habitat.habitatno;


--
-- Name: hayvan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hayvan (
    hayvanno integer NOT NULL,
    hayvanad character varying(15),
    turno integer,
    agirlik integer,
    habitatno integer,
    beslenmetipino integer,
    bakicino integer
);


ALTER TABLE public.hayvan OWNER TO postgres;

--
-- Name: il; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.il (
    ilno integer NOT NULL,
    ilad character varying(30)
);


ALTER TABLE public.il OWNER TO postgres;

--
-- Name: il_ilno_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.il_ilno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.il_ilno_seq OWNER TO postgres;

--
-- Name: il_ilno_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.il_ilno_seq OWNED BY public.il.ilno;


--
-- Name: kus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kus (
    turno integer,
    ad character varying(15)
)
INHERITS (public.tur);


ALTER TABLE public.kus OWNER TO postgres;

--
-- Name: maasbilgisi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.maasbilgisi (
    maasno integer NOT NULL,
    maasmiktari integer
);


ALTER TABLE public.maasbilgisi OWNER TO postgres;

--
-- Name: maasbilgisi_maasno_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.maasbilgisi_maasno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.maasbilgisi_maasno_seq OWNER TO postgres;

--
-- Name: maasbilgisi_maasno_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.maasbilgisi_maasno_seq OWNED BY public.maasbilgisi.maasno;


--
-- Name: memeli; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.memeli (
    turno integer,
    ad character varying(15)
)
INHERITS (public.tur);


ALTER TABLE public.memeli OWNER TO postgres;

--
-- Name: saglikci; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.saglikci (
    personelno integer
)
INHERITS (public.personel);


ALTER TABLE public.saglikci OWNER TO postgres;

--
-- Name: surungen; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.surungen (
    turno integer,
    ad character varying(15)
)
INHERITS (public.tur);


ALTER TABLE public.surungen OWNER TO postgres;

--
-- Name: ziyaretci; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ziyaretci (
    ziyaretcino integer NOT NULL,
    ad character varying(30),
    soyad character varying(30),
    gun date,
    yas integer,
    bilet integer,
    il integer
);


ALTER TABLE public.ziyaretci OWNER TO postgres;

--
-- Name: ziyaretci_ziyaretcino_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ziyaretci_ziyaretcino_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ziyaretci_ziyaretcino_seq OWNER TO postgres;

--
-- Name: ziyaretci_ziyaretcino_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ziyaretci_ziyaretcino_seq OWNED BY public.ziyaretci.ziyaretcino;


--
-- Name: beslenme_bilgisi beslenmeno; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beslenme_bilgisi ALTER COLUMN beslenmeno SET DEFAULT nextval('public.beslenme_bilgisi_beslenmeno_seq'::regclass);


--
-- Name: biletsatis biletno; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biletsatis ALTER COLUMN biletno SET DEFAULT nextval('public.biletsatis_biletno_seq'::regclass);


--
-- Name: habitat habitatno; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.habitat ALTER COLUMN habitatno SET DEFAULT nextval('public.habitat_habitatno_seq'::regclass);


--
-- Name: il ilno; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.il ALTER COLUMN ilno SET DEFAULT nextval('public.il_ilno_seq'::regclass);


--
-- Name: maasbilgisi maasno; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maasbilgisi ALTER COLUMN maasno SET DEFAULT nextval('public.maasbilgisi_maasno_seq'::regclass);


--
-- Name: ziyaretci ziyaretcino; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ziyaretci ALTER COLUMN ziyaretcino SET DEFAULT nextval('public.ziyaretci_ziyaretcino_seq'::regclass);


--
-- Data for Name: bakici; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: beslenme_bilgisi; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.beslenme_bilgisi VALUES
	(2, 'Etçil'),
	(3, 'Otçul'),
	(1, 'hepçil');


--
-- Data for Name: biletsatis; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.biletsatis VALUES
	(1, 50),
	(2, 40),
	(3, 30);


--
-- Data for Name: guvenlikgorevlisi; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.guvenlikgorevlisi VALUES
	(1, 'baha', 'bakan', NULL, NULL);


--
-- Data for Name: habitat; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.habitat VALUES
	(1, 'Orman'),
	(2, 'su'),
	(3, 'çöl');


--
-- Data for Name: hayvan; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.hayvan VALUES
	(1, 'Aslan', 1, 132, 1, 2, NULL),
	(2, 'kaplan', 1, 132, 1, 2, 1);


--
-- Data for Name: il; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.il VALUES
	(1, 'İstanbul'),
	(2, 'Ankara'),
	(3, 'İzmir');


--
-- Data for Name: kus; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: maasbilgisi; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.maasbilgisi VALUES
	(1, 5000),
	(2, 4500),
	(3, 6000),
	(11, 1000);


--
-- Data for Name: memeli; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.memeli VALUES
	(1, 'memeli', 'kaplan');


--
-- Data for Name: personel; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.personel VALUES
	(1, 'baha', 'bakan', 'guvenlikgorevlisi', NULL);


--
-- Data for Name: saglikci; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: surungen; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: tur; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tur VALUES
	(2, 'surungen'),
	(1, 'memeli'),
	(3, 'kus');


--
-- Data for Name: ziyaretci; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ziyaretci VALUES
	(1, 'Ali', 'Yılmaz', '2023-01-01', 30, NULL, NULL),
	(2, 'Fatma', 'Kaya', '2023-02-01', 25, NULL, NULL),
	(3, 'Veli', 'Demir', '2023-03-01', 35, NULL, NULL);


--
-- Name: beslenme_bilgisi_beslenmeno_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.beslenme_bilgisi_beslenmeno_seq', 3, true);


--
-- Name: biletsatis_biletno_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.biletsatis_biletno_seq', 3, true);


--
-- Name: habitat_habitatno_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.habitat_habitatno_seq', 2, true);


--
-- Name: il_ilno_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.il_ilno_seq', 3, true);


--
-- Name: maasbilgisi_maasno_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.maasbilgisi_maasno_seq', 13, true);


--
-- Name: ziyaretci_ziyaretcino_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ziyaretci_ziyaretcino_seq', 3, true);


--
-- Name: beslenme_bilgisi beslenme_bilgisi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beslenme_bilgisi
    ADD CONSTRAINT beslenme_bilgisi_pkey PRIMARY KEY (beslenmeno);


--
-- Name: biletsatis biletsatis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biletsatis
    ADD CONSTRAINT biletsatis_pkey PRIMARY KEY (biletno);


--
-- Name: guvenlikgorevlisi guvenlikgorevlisi_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.guvenlikgorevlisi
    ADD CONSTRAINT guvenlikgorevlisi_pk PRIMARY KEY (personelno) INCLUDE (personelno);


--
-- Name: habitat habitat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.habitat
    ADD CONSTRAINT habitat_pkey PRIMARY KEY (habitatno);


--
-- Name: hayvan hayvan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hayvan
    ADD CONSTRAINT hayvan_pkey PRIMARY KEY (hayvanno);


--
-- Name: il il_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.il
    ADD CONSTRAINT il_pkey PRIMARY KEY (ilno);


--
-- Name: kus kus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kus
    ADD CONSTRAINT kus_pkey PRIMARY KEY (turno);


--
-- Name: maasbilgisi maasbilgisi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maasbilgisi
    ADD CONSTRAINT maasbilgisi_pkey PRIMARY KEY (maasno);


--
-- Name: memeli memeli_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memeli
    ADD CONSTRAINT memeli_pkey PRIMARY KEY (turno);


--
-- Name: personel personel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personel
    ADD CONSTRAINT personel_pkey PRIMARY KEY (personelno);


--
-- Name: bakici personelno_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bakici
    ADD CONSTRAINT personelno_pk PRIMARY KEY (personelno) INCLUDE (personelno);


--
-- Name: surungen surungen_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.surungen
    ADD CONSTRAINT surungen_pkey PRIMARY KEY (turno);


--
-- Name: tur tur_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tur
    ADD CONSTRAINT tur_pkey PRIMARY KEY (turno);


--
-- Name: saglikci tur_primerykey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saglikci
    ADD CONSTRAINT tur_primerykey PRIMARY KEY (personelno) INCLUDE (personelno);


--
-- Name: ziyaretci ziyaretci_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ziyaretci
    ADD CONSTRAINT ziyaretci_pkey PRIMARY KEY (ziyaretcino);


--
-- Name: fki_bilet_foreignkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_bilet_foreignkey ON public.ziyaretci USING btree (bilet);


--
-- Name: fki_il_foreignkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_il_foreignkey ON public.ziyaretci USING btree (il);


--
-- Name: personel after_delete_personel; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER after_delete_personel AFTER DELETE ON public.personel FOR EACH ROW EXECUTE FUNCTION public.personelkalitimisil();


--
-- Name: hayvan delete_from_child_tables_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER delete_from_child_tables_trigger AFTER DELETE ON public.hayvan FOR EACH ROW EXECUTE FUNCTION public.hayvanvekalitimisil();


--
-- Name: hayvan hayvan_after_insert; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER hayvan_after_insert AFTER INSERT ON public.hayvan FOR EACH ROW EXECUTE FUNCTION public.hayvanturekle();


--
-- Name: personel personel_insert_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER personel_insert_trigger AFTER INSERT ON public.personel FOR EACH ROW EXECUTE FUNCTION public.personel_insert_trigger();


--
-- Name: ziyaretci bilet_foreignkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ziyaretci
    ADD CONSTRAINT bilet_foreignkey FOREIGN KEY (bilet) REFERENCES public.biletsatis(biletno) NOT VALID;


--
-- Name: hayvan hayvan_beslenmetipino_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hayvan
    ADD CONSTRAINT hayvan_beslenmetipino_fkey FOREIGN KEY (beslenmetipino) REFERENCES public.beslenme_bilgisi(beslenmeno);


--
-- Name: hayvan hayvan_habitatno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hayvan
    ADD CONSTRAINT hayvan_habitatno_fkey FOREIGN KEY (habitatno) REFERENCES public.habitat(habitatno);


--
-- Name: ziyaretci il_foreignkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ziyaretci
    ADD CONSTRAINT il_foreignkey FOREIGN KEY (il) REFERENCES public.il(ilno) NOT VALID;


--
-- Name: kus kus_turno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kus
    ADD CONSTRAINT kus_turno_fkey FOREIGN KEY (turno) REFERENCES public.tur(turno);


--
-- Name: kus kus_turno_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kus
    ADD CONSTRAINT kus_turno_fkey1 FOREIGN KEY (turno) REFERENCES public.tur(turno);


--
-- Name: personel personel_maasno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personel
    ADD CONSTRAINT personel_maasno_fkey FOREIGN KEY (maasno) REFERENCES public.maasbilgisi(maasno);


--
-- Name: surungen surungen_turno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.surungen
    ADD CONSTRAINT surungen_turno_fkey FOREIGN KEY (turno) REFERENCES public.tur(turno);


--
-- Name: surungen surungen_turno_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.surungen
    ADD CONSTRAINT surungen_turno_fkey1 FOREIGN KEY (turno) REFERENCES public.tur(turno);


--
-- PostgreSQL database dump complete
--

