--
-- PostgreSQL database dump
--

\restrict F1nkIxj1vhcqRsY4HriftIyJICHIsllKYVaOeyz88zIsghipicMUmfVDaRe63UV

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2025-12-18 22:39:07

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
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 5203 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 258 (class 1255 OID 16759)
-- Name: ayniisimkontrol(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ayniisimkontrol() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM AnimasyonDizileri WHERE LOWER(Ad) = LOWER(NEW.Ad)) THEN
        RAISE EXCEPTION 'Hata: % isminde bir dizi zaten veritabanında kayıtlı!', NEW.Ad;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.ayniisimkontrol() OWNER TO postgres;

--
-- TOC entry 255 (class 1255 OID 16753)
-- Name: diziara(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.diziara(aranan_kelime character varying) RETURNS TABLE(id integer, ad character varying, puan numeric, yil integer)
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY 
        SELECT 
            AnimasyonDizileri.AnimasyonID, 
            AnimasyonDizileri.Ad, 
            AnimasyonDizileri.IMDB_Puani, 
            AnimasyonDizileri.YayinYili_Baslangic
        FROM AnimasyonDizileri
        WHERE AnimasyonDizileri.Ad ILIKE '%' || aranan_kelime || '%';
    END;
    $$;


ALTER FUNCTION public.diziara(aranan_kelime character varying) OWNER TO postgres;

--
-- TOC entry 259 (class 1255 OID 16767)
-- Name: diziekle(character varying, numeric, integer, integer, character varying, character varying, integer, integer, text, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.diziekle(p_ad character varying, p_imdb numeric, p_yil integer, p_bitis integer, p_janra character varying, p_teknik character varying, p_sezon integer, p_bolum integer, p_oduller text, p_yonetmen character varying, p_platform character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO AnimasyonDizileri (
        Ad, IMDB_Puani, YayinYili_Baslangic, 
        YayinYili_Bitis, Janra, Teknik, SezonSayisi, BolumSayisi, Oduller, Yonetmenler, Platformlar
    ) VALUES (
        p_ad, p_imdb, p_yil, 
        p_bitis, p_janra, p_teknik, p_sezon, p_bolum, p_oduller, p_yonetmen, p_platform
    );
END;
$$;


ALTER FUNCTION public.diziekle(p_ad character varying, p_imdb numeric, p_yil integer, p_bitis integer, p_janra character varying, p_teknik character varying, p_sezon integer, p_bolum integer, p_oduller text, p_yonetmen character varying, p_platform character varying) OWNER TO postgres;

--
-- TOC entry 260 (class 1255 OID 16768)
-- Name: diziguncelle(integer, character varying, numeric, integer, integer, character varying, character varying, integer, integer, text, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.diziguncelle(p_id integer, p_ad character varying, p_imdb numeric, p_yil integer, p_bitis integer, p_janra character varying, p_teknik character varying, p_sezon integer, p_bolum integer, p_oduller text, p_yonetmen character varying, p_platform character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE AnimasyonDizileri SET
        Ad = p_ad, 
        IMDB_Puani = p_imdb, 
        YayinYili_Baslangic = p_yil,
        YayinYili_Bitis = p_bitis, 
        Janra = p_janra, 
        Teknik = p_teknik,
        SezonSayisi = p_sezon, 
        BolumSayisi = p_bolum, 
        Oduller = p_oduller, 
        Yonetmenler = p_yonetmen, 
        Platformlar = p_platform
    WHERE AnimasyonID = p_id;
END;
$$;


ALTER FUNCTION public.diziguncelle(p_id integer, p_ad character varying, p_imdb numeric, p_yil integer, p_bitis integer, p_janra character varying, p_teknik character varying, p_sezon integer, p_bolum integer, p_oduller text, p_yonetmen character varying, p_platform character varying) OWNER TO postgres;

--
-- TOC entry 256 (class 1255 OID 16755)
-- Name: dizisil(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.dizisil(p_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM AnimasyonDizileri WHERE AnimasyonID = p_id;
END;
$$;


ALTER FUNCTION public.dizisil(p_id integer) OWNER TO postgres;

--
-- TOC entry 254 (class 1255 OID 16746)
-- Name: imdb_kontrol(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.imdb_kontrol() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF NEW.IMDB_Puani > 10 OR NEW.IMDB_Puani < 0 THEN
		RAISE EXCEPTION 'Hata: IMDB puanı 0 ile 10 arasında olmalıdır.';
		END IF;
		RETURN NEW;
	END;
	$$;


ALTER FUNCTION public.imdb_kontrol() OWNER TO postgres;

--
-- TOC entry 257 (class 1255 OID 16757)
-- Name: ismiguzellestir(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ismiguzellestir() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    
    NEW.Ad := INITCAP(NEW.Ad);
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.ismiguzellestir() OWNER TO postgres;

--
-- TOC entry 253 (class 1255 OID 16743)
-- Name: yil_kontrol(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.yil_kontrol() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF NEW.YayinYili_Baslangic > EXTRACT(YEAR FROM CURRENT_DATE) THEN
		RAISE EXCEPTION 'Hata: Yayın yılı gelecek bir tarih olamaz.';
		END IF;
		RETURN NEW;
	END;
	$$;


ALTER FUNCTION public.yil_kontrol() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 238 (class 1259 OID 16601)
-- Name: animasyon_janra; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.animasyon_janra (
    id integer NOT NULL,
    animasyonid integer NOT NULL,
    janraid integer NOT NULL
);


ALTER TABLE public.animasyon_janra OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16600)
-- Name: animasyon_janra_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.animasyon_janra_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.animasyon_janra_id_seq OWNER TO postgres;

--
-- TOC entry 5204 (class 0 OID 0)
-- Dependencies: 237
-- Name: animasyon_janra_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.animasyon_janra_id_seq OWNED BY public.animasyon_janra.id;


--
-- TOC entry 252 (class 1259 OID 16720)
-- Name: animasyon_odul; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.animasyon_odul (
    id integer NOT NULL,
    animasyonid integer NOT NULL,
    odulid integer NOT NULL
);


ALTER TABLE public.animasyon_odul OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 16719)
-- Name: animasyon_odul_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.animasyon_odul_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.animasyon_odul_id_seq OWNER TO postgres;

--
-- TOC entry 5205 (class 0 OID 0)
-- Dependencies: 251
-- Name: animasyon_odul_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.animasyon_odul_id_seq OWNED BY public.animasyon_odul.id;


--
-- TOC entry 244 (class 1259 OID 16655)
-- Name: animasyon_platform; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.animasyon_platform (
    id integer NOT NULL,
    animasyonid integer NOT NULL,
    platformid integer NOT NULL
);


ALTER TABLE public.animasyon_platform OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 16654)
-- Name: animasyon_platform_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.animasyon_platform_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.animasyon_platform_id_seq OWNER TO postgres;

--
-- TOC entry 5206 (class 0 OID 0)
-- Dependencies: 243
-- Name: animasyon_platform_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.animasyon_platform_id_seq OWNED BY public.animasyon_platform.id;


--
-- TOC entry 240 (class 1259 OID 16621)
-- Name: animasyon_teknik; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.animasyon_teknik (
    id integer NOT NULL,
    animasyonid integer NOT NULL,
    teknikid integer NOT NULL
);


ALTER TABLE public.animasyon_teknik OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 16620)
-- Name: animasyon_teknik_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.animasyon_teknik_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.animasyon_teknik_id_seq OWNER TO postgres;

--
-- TOC entry 5207 (class 0 OID 0)
-- Dependencies: 239
-- Name: animasyon_teknik_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.animasyon_teknik_id_seq OWNED BY public.animasyon_teknik.id;


--
-- TOC entry 228 (class 1259 OID 16463)
-- Name: animasyondizileri; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.animasyondizileri (
    animasyonid integer NOT NULL,
    ad character varying(100) NOT NULL,
    yayinyili_baslangic integer,
    yayinyili_bitis integer,
    imdb_puani numeric(3,1),
    devamdurumu boolean,
    studyoid integer,
    janra character varying(100),
    teknik character varying(50),
    sezonsayisi integer DEFAULT 1,
    bolumsayisi integer DEFAULT 0,
    oduller text,
    yonetmenler character varying(255),
    platformlar character varying(255)
);


ALTER TABLE public.animasyondizileri OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16462)
-- Name: animasyondizileri_animasyonid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.animasyondizileri_animasyonid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.animasyondizileri_animasyonid_seq OWNER TO postgres;

--
-- TOC entry 5208 (class 0 OID 0)
-- Dependencies: 227
-- Name: animasyondizileri_animasyonid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.animasyondizileri_animasyonid_seq OWNED BY public.animasyondizileri.animasyonid;


--
-- TOC entry 234 (class 1259 OID 16583)
-- Name: janralar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.janralar (
    janraid integer NOT NULL,
    ad character varying(50) NOT NULL
);


ALTER TABLE public.janralar OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16582)
-- Name: janralar_janraid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.janralar_janraid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.janralar_janraid_seq OWNER TO postgres;

--
-- TOC entry 5209 (class 0 OID 0)
-- Dependencies: 233
-- Name: janralar_janraid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.janralar_janraid_seq OWNED BY public.janralar.janraid;


--
-- TOC entry 248 (class 1259 OID 16691)
-- Name: karakter_seslendirmen; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.karakter_seslendirmen (
    id integer NOT NULL,
    karakterid integer NOT NULL,
    kisiid integer NOT NULL,
    dil character varying(30)
);


ALTER TABLE public.karakter_seslendirmen OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 16690)
-- Name: karakter_seslendirmen_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.karakter_seslendirmen_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.karakter_seslendirmen_id_seq OWNER TO postgres;

--
-- TOC entry 5210 (class 0 OID 0)
-- Dependencies: 247
-- Name: karakter_seslendirmen_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.karakter_seslendirmen_id_seq OWNED BY public.karakter_seslendirmen.id;


--
-- TOC entry 246 (class 1259 OID 16676)
-- Name: karakterler; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.karakterler (
    karakterid integer NOT NULL,
    animasyonid integer NOT NULL,
    ad character varying(100) NOT NULL,
    rolturu character varying(50)
);


ALTER TABLE public.karakterler OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 16675)
-- Name: karakterler_karakterid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.karakterler_karakterid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.karakterler_karakterid_seq OWNER TO postgres;

--
-- TOC entry 5211 (class 0 OID 0)
-- Dependencies: 245
-- Name: karakterler_karakterid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.karakterler_karakterid_seq OWNED BY public.karakterler.karakterid;


--
-- TOC entry 220 (class 1259 OID 16390)
-- Name: kisiler; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kisiler (
    kisiid integer NOT NULL,
    ad character varying(50) NOT NULL,
    soyad character varying(50) NOT NULL,
    dogumtarihi date
);


ALTER TABLE public.kisiler OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16389)
-- Name: kisiler_kisiid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.kisiler_kisiid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.kisiler_kisiid_seq OWNER TO postgres;

--
-- TOC entry 5212 (class 0 OID 0)
-- Dependencies: 219
-- Name: kisiler_kisiid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kisiler_kisiid_seq OWNED BY public.kisiler.kisiid;


--
-- TOC entry 250 (class 1259 OID 16711)
-- Name: oduller; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.oduller (
    odulid integer NOT NULL,
    ad character varying(100) NOT NULL
);


ALTER TABLE public.oduller OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 16710)
-- Name: oduller_odulid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.oduller_odulid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.oduller_odulid_seq OWNER TO postgres;

--
-- TOC entry 5213 (class 0 OID 0)
-- Dependencies: 249
-- Name: oduller_odulid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.oduller_odulid_seq OWNED BY public.oduller.odulid;


--
-- TOC entry 242 (class 1259 OID 16646)
-- Name: platformlar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.platformlar (
    platformid integer NOT NULL,
    ad character varying(50) NOT NULL
);


ALTER TABLE public.platformlar OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 16645)
-- Name: platformlar_platformid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.platformlar_platformid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.platformlar_platformid_seq OWNER TO postgres;

--
-- TOC entry 5214 (class 0 OID 0)
-- Dependencies: 241
-- Name: platformlar_platformid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.platformlar_platformid_seq OWNED BY public.platformlar.platformid;


--
-- TOC entry 224 (class 1259 OID 16415)
-- Name: senaristler; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.senaristler (
    senaristid integer NOT NULL,
    kisiid integer NOT NULL
);


ALTER TABLE public.senaristler OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16414)
-- Name: senaristler_senaristid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.senaristler_senaristid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.senaristler_senaristid_seq OWNER TO postgres;

--
-- TOC entry 5215 (class 0 OID 0)
-- Dependencies: 223
-- Name: senaristler_senaristid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.senaristler_senaristid_seq OWNED BY public.senaristler.senaristid;


--
-- TOC entry 226 (class 1259 OID 16429)
-- Name: seslendirmenler; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.seslendirmenler (
    seslendirmenid integer NOT NULL,
    kisiid integer NOT NULL
);


ALTER TABLE public.seslendirmenler OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16428)
-- Name: seslendirmenler_seslendirmenid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seslendirmenler_seslendirmenid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seslendirmenler_seslendirmenid_seq OWNER TO postgres;

--
-- TOC entry 5216 (class 0 OID 0)
-- Dependencies: 225
-- Name: seslendirmenler_seslendirmenid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.seslendirmenler_seslendirmenid_seq OWNED BY public.seslendirmenler.seslendirmenid;


--
-- TOC entry 230 (class 1259 OID 16472)
-- Name: sezonlar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sezonlar (
    sezonid integer NOT NULL,
    animasyonid integer NOT NULL,
    sezonno integer NOT NULL,
    bolumsayisi integer
);


ALTER TABLE public.sezonlar OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16471)
-- Name: sezonlar_sezonid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sezonlar_sezonid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sezonlar_sezonid_seq OWNER TO postgres;

--
-- TOC entry 5217 (class 0 OID 0)
-- Dependencies: 229
-- Name: sezonlar_sezonid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sezonlar_sezonid_seq OWNED BY public.sezonlar.sezonid;


--
-- TOC entry 236 (class 1259 OID 16592)
-- Name: studyolar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.studyolar (
    studyoid integer NOT NULL,
    ad character varying(100) NOT NULL
);


ALTER TABLE public.studyolar OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16591)
-- Name: studyolar_studyoid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.studyolar_studyoid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.studyolar_studyoid_seq OWNER TO postgres;

--
-- TOC entry 5218 (class 0 OID 0)
-- Dependencies: 235
-- Name: studyolar_studyoid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.studyolar_studyoid_seq OWNED BY public.studyolar.studyoid;


--
-- TOC entry 232 (class 1259 OID 16574)
-- Name: teknikler; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teknikler (
    teknikid integer NOT NULL,
    ad character varying(50) NOT NULL
);


ALTER TABLE public.teknikler OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16573)
-- Name: teknikler_teknikid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.teknikler_teknikid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.teknikler_teknikid_seq OWNER TO postgres;

--
-- TOC entry 5219 (class 0 OID 0)
-- Dependencies: 231
-- Name: teknikler_teknikid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.teknikler_teknikid_seq OWNED BY public.teknikler.teknikid;


--
-- TOC entry 222 (class 1259 OID 16401)
-- Name: yonetmenler; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.yonetmenler (
    yonetmenid integer NOT NULL,
    kisiid integer NOT NULL
);


ALTER TABLE public.yonetmenler OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16400)
-- Name: yonetmenler_yonetmenid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.yonetmenler_yonetmenid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.yonetmenler_yonetmenid_seq OWNER TO postgres;

--
-- TOC entry 5220 (class 0 OID 0)
-- Dependencies: 221
-- Name: yonetmenler_yonetmenid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.yonetmenler_yonetmenid_seq OWNED BY public.yonetmenler.yonetmenid;


--
-- TOC entry 4955 (class 2604 OID 16604)
-- Name: animasyon_janra id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animasyon_janra ALTER COLUMN id SET DEFAULT nextval('public.animasyon_janra_id_seq'::regclass);


--
-- TOC entry 4962 (class 2604 OID 16723)
-- Name: animasyon_odul id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animasyon_odul ALTER COLUMN id SET DEFAULT nextval('public.animasyon_odul_id_seq'::regclass);


--
-- TOC entry 4958 (class 2604 OID 16658)
-- Name: animasyon_platform id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animasyon_platform ALTER COLUMN id SET DEFAULT nextval('public.animasyon_platform_id_seq'::regclass);


--
-- TOC entry 4956 (class 2604 OID 16624)
-- Name: animasyon_teknik id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animasyon_teknik ALTER COLUMN id SET DEFAULT nextval('public.animasyon_teknik_id_seq'::regclass);


--
-- TOC entry 4948 (class 2604 OID 16466)
-- Name: animasyondizileri animasyonid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animasyondizileri ALTER COLUMN animasyonid SET DEFAULT nextval('public.animasyondizileri_animasyonid_seq'::regclass);


--
-- TOC entry 4953 (class 2604 OID 16586)
-- Name: janralar janraid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.janralar ALTER COLUMN janraid SET DEFAULT nextval('public.janralar_janraid_seq'::regclass);


--
-- TOC entry 4960 (class 2604 OID 16694)
-- Name: karakter_seslendirmen id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.karakter_seslendirmen ALTER COLUMN id SET DEFAULT nextval('public.karakter_seslendirmen_id_seq'::regclass);


--
-- TOC entry 4959 (class 2604 OID 16679)
-- Name: karakterler karakterid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.karakterler ALTER COLUMN karakterid SET DEFAULT nextval('public.karakterler_karakterid_seq'::regclass);


--
-- TOC entry 4944 (class 2604 OID 16393)
-- Name: kisiler kisiid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kisiler ALTER COLUMN kisiid SET DEFAULT nextval('public.kisiler_kisiid_seq'::regclass);


--
-- TOC entry 4961 (class 2604 OID 16714)
-- Name: oduller odulid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oduller ALTER COLUMN odulid SET DEFAULT nextval('public.oduller_odulid_seq'::regclass);


--
-- TOC entry 4957 (class 2604 OID 16649)
-- Name: platformlar platformid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.platformlar ALTER COLUMN platformid SET DEFAULT nextval('public.platformlar_platformid_seq'::regclass);


--
-- TOC entry 4946 (class 2604 OID 16418)
-- Name: senaristler senaristid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.senaristler ALTER COLUMN senaristid SET DEFAULT nextval('public.senaristler_senaristid_seq'::regclass);


--
-- TOC entry 4947 (class 2604 OID 16432)
-- Name: seslendirmenler seslendirmenid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seslendirmenler ALTER COLUMN seslendirmenid SET DEFAULT nextval('public.seslendirmenler_seslendirmenid_seq'::regclass);


--
-- TOC entry 4951 (class 2604 OID 16475)
-- Name: sezonlar sezonid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sezonlar ALTER COLUMN sezonid SET DEFAULT nextval('public.sezonlar_sezonid_seq'::regclass);


--
-- TOC entry 4954 (class 2604 OID 16595)
-- Name: studyolar studyoid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.studyolar ALTER COLUMN studyoid SET DEFAULT nextval('public.studyolar_studyoid_seq'::regclass);


--
-- TOC entry 4952 (class 2604 OID 16577)
-- Name: teknikler teknikid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teknikler ALTER COLUMN teknikid SET DEFAULT nextval('public.teknikler_teknikid_seq'::regclass);


--
-- TOC entry 4945 (class 2604 OID 16404)
-- Name: yonetmenler yonetmenid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yonetmenler ALTER COLUMN yonetmenid SET DEFAULT nextval('public.yonetmenler_yonetmenid_seq'::regclass);


--
-- TOC entry 5183 (class 0 OID 16601)
-- Dependencies: 238
-- Data for Name: animasyon_janra; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.animasyon_janra (id, animasyonid, janraid) FROM stdin;
1	3	10
2	3	12
\.


--
-- TOC entry 5197 (class 0 OID 16720)
-- Dependencies: 252
-- Data for Name: animasyon_odul; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.animasyon_odul (id, animasyonid, odulid) FROM stdin;
\.


--
-- TOC entry 5189 (class 0 OID 16655)
-- Dependencies: 244
-- Data for Name: animasyon_platform; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.animasyon_platform (id, animasyonid, platformid) FROM stdin;
2	3	4
\.


--
-- TOC entry 5185 (class 0 OID 16621)
-- Dependencies: 240
-- Data for Name: animasyon_teknik; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.animasyon_teknik (id, animasyonid, teknikid) FROM stdin;
1	3	7
2	3	8
\.


--
-- TOC entry 5173 (class 0 OID 16463)
-- Dependencies: 228
-- Data for Name: animasyondizileri; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.animasyondizileri (animasyonid, ad, yayinyili_baslangic, yayinyili_bitis, imdb_puani, devamdurumu, studyoid, janra, teknik, sezonsayisi, bolumsayisi, oduller, yonetmenler, platformlar) FROM stdin;
9	Phineas And Ferb	2007	2025	8.1	\N	\N	Komedi, Müzikal	2D	5	155	Emmy Ödülleri (4+)\r\nKids' Choice Ödülleri (2)\r\nDiğer Ödüller (3)	Dan Povenmire, Jeff "Swampy" Marsh	Disney+
11	Star Vs. The Forces Of Evil	2012	2019	7.9	\N	\N	Aksiyon, Komedi	2D	4	77	Emmy Ödülleri (1)\r\nBTVA Seslendirme Ödülleri (3)	Dominic Bisignano	Disney+
12	Gravity Falls	2012	2016	8.9	\N	\N	Macera, Gizem, Komedi	2D	2	40	Emmy Ödülleri (2)\r\nAnnie Ödülleri (3)\r\nBAFTA Çocuk Ödülleri (1)\r\nDiğer Ödüller (4+)	Mike Rianda	Disney+
10	Over The Garden Wall	2014	2014	8.7	\N	\N	Gizem, Komedi, Dram	2D	1	10	Emmy Ödülleri (4)\r\nOttawa Uluslararası Animasyon Festivali (1)\r\nReuben Ödülleri (1)\r\n	Nate Cash, Bert Youn	Prime Video
13	Gintama	2005	2021	8.7	\N	\N	Komedi, Aksiyon, Parodi	2D	7	367	Tokyo Anime Award Festival (2016)\r\nJapan Gold Disc Award (2012)	Shinji Takamatsu, Yoichi Fujita, Chizuru Miyawaki	Crunchyroll
14	Avatar: The Last Airbender	2005	2008	9.3	\N	\N	Aksiyon, Macera, Dram	2D	3	61	Peabody Ödülü (2008)\r\nPrimetime Emmy Ödülü\r\nAnnie Ödülleri (3)\r\nNickelodeon Kids' Choice Awards (1+)	Michael Dante DiMartino, Bryan Konietzko	
3	Arcane	2021	\N	9.0	t	4	Aksiyon	3D/2D	2	18	Annie Ödülleri (16)\r\nEmmy Ödülleri (8)\r\nDiğer Ödüller (2)\r\n	Pascal Charrue, Arnaud Delord, Bart Maunoury	Netflix
8	Blue Eye Samurai	2023	\N	8.7	\N	\N	Aksiyon, Dram	2D/3D	1	8	Emmy Ödülleri (4)\r\nAnnie Ödülleri (6)\r\nDiğer Ödüller (1)	Jane Wu	Netflix
\.


--
-- TOC entry 5179 (class 0 OID 16583)
-- Dependencies: 234
-- Data for Name: janralar; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.janralar (janraid, ad) FROM stdin;
10	Aksiyon
11	Bilim Kurgu
12	Dram
\.


--
-- TOC entry 5193 (class 0 OID 16691)
-- Dependencies: 248
-- Data for Name: karakter_seslendirmen; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.karakter_seslendirmen (id, karakterid, kisiid, dil) FROM stdin;
1	1	1	İngilizce
\.


--
-- TOC entry 5191 (class 0 OID 16676)
-- Dependencies: 246
-- Data for Name: karakterler; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.karakterler (karakterid, animasyonid, ad, rolturu) FROM stdin;
1	3	Jinx	Başrol
\.


--
-- TOC entry 5165 (class 0 OID 16390)
-- Dependencies: 220
-- Data for Name: kisiler; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kisiler (kisiid, ad, soyad, dogumtarihi) FROM stdin;
1	Ella	Purnell	1996-09-17
\.


--
-- TOC entry 5195 (class 0 OID 16711)
-- Dependencies: 250
-- Data for Name: oduller; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.oduller (odulid, ad) FROM stdin;
7	Emmy Awards
8	Annie Awards
\.


--
-- TOC entry 5187 (class 0 OID 16646)
-- Dependencies: 242
-- Data for Name: platformlar; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.platformlar (platformid, ad) FROM stdin;
4	Netflix
\.


--
-- TOC entry 5169 (class 0 OID 16415)
-- Dependencies: 224
-- Data for Name: senaristler; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.senaristler (senaristid, kisiid) FROM stdin;
\.


--
-- TOC entry 5171 (class 0 OID 16429)
-- Dependencies: 226
-- Data for Name: seslendirmenler; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.seslendirmenler (seslendirmenid, kisiid) FROM stdin;
\.


--
-- TOC entry 5175 (class 0 OID 16472)
-- Dependencies: 230
-- Data for Name: sezonlar; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sezonlar (sezonid, animasyonid, sezonno, bolumsayisi) FROM stdin;
1	3	1	9
2	3	2	9
\.


--
-- TOC entry 5181 (class 0 OID 16592)
-- Dependencies: 236
-- Data for Name: studyolar; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.studyolar (studyoid, ad) FROM stdin;
4	Fortiche Production
\.


--
-- TOC entry 5177 (class 0 OID 16574)
-- Dependencies: 232
-- Data for Name: teknikler; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teknikler (teknikid, ad) FROM stdin;
7	3D
8	2D
\.


--
-- TOC entry 5167 (class 0 OID 16401)
-- Dependencies: 222
-- Data for Name: yonetmenler; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.yonetmenler (yonetmenid, kisiid) FROM stdin;
\.


--
-- TOC entry 5221 (class 0 OID 0)
-- Dependencies: 237
-- Name: animasyon_janra_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.animasyon_janra_id_seq', 2, true);


--
-- TOC entry 5222 (class 0 OID 0)
-- Dependencies: 251
-- Name: animasyon_odul_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.animasyon_odul_id_seq', 1, false);


--
-- TOC entry 5223 (class 0 OID 0)
-- Dependencies: 243
-- Name: animasyon_platform_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.animasyon_platform_id_seq', 2, true);


--
-- TOC entry 5224 (class 0 OID 0)
-- Dependencies: 239
-- Name: animasyon_teknik_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.animasyon_teknik_id_seq', 2, true);


--
-- TOC entry 5225 (class 0 OID 0)
-- Dependencies: 227
-- Name: animasyondizileri_animasyonid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.animasyondizileri_animasyonid_seq', 16, true);


--
-- TOC entry 5226 (class 0 OID 0)
-- Dependencies: 233
-- Name: janralar_janraid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.janralar_janraid_seq', 12, true);


--
-- TOC entry 5227 (class 0 OID 0)
-- Dependencies: 247
-- Name: karakter_seslendirmen_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.karakter_seslendirmen_id_seq', 1, true);


--
-- TOC entry 5228 (class 0 OID 0)
-- Dependencies: 245
-- Name: karakterler_karakterid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.karakterler_karakterid_seq', 1, true);


--
-- TOC entry 5229 (class 0 OID 0)
-- Dependencies: 219
-- Name: kisiler_kisiid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kisiler_kisiid_seq', 1, true);


--
-- TOC entry 5230 (class 0 OID 0)
-- Dependencies: 249
-- Name: oduller_odulid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.oduller_odulid_seq', 8, true);


--
-- TOC entry 5231 (class 0 OID 0)
-- Dependencies: 241
-- Name: platformlar_platformid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.platformlar_platformid_seq', 4, true);


--
-- TOC entry 5232 (class 0 OID 0)
-- Dependencies: 223
-- Name: senaristler_senaristid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.senaristler_senaristid_seq', 1, false);


--
-- TOC entry 5233 (class 0 OID 0)
-- Dependencies: 225
-- Name: seslendirmenler_seslendirmenid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seslendirmenler_seslendirmenid_seq', 1, false);


--
-- TOC entry 5234 (class 0 OID 0)
-- Dependencies: 229
-- Name: sezonlar_sezonid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sezonlar_sezonid_seq', 2, true);


--
-- TOC entry 5235 (class 0 OID 0)
-- Dependencies: 235
-- Name: studyolar_studyoid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.studyolar_studyoid_seq', 4, true);


--
-- TOC entry 5236 (class 0 OID 0)
-- Dependencies: 231
-- Name: teknikler_teknikid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.teknikler_teknikid_seq', 8, true);


--
-- TOC entry 5237 (class 0 OID 0)
-- Dependencies: 221
-- Name: yonetmenler_yonetmenid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.yonetmenler_yonetmenid_seq', 1, false);


--
-- TOC entry 4982 (class 2606 OID 16609)
-- Name: animasyon_janra animasyon_janra_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animasyon_janra
    ADD CONSTRAINT animasyon_janra_pkey PRIMARY KEY (id);


--
-- TOC entry 4996 (class 2606 OID 16728)
-- Name: animasyon_odul animasyon_odul_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animasyon_odul
    ADD CONSTRAINT animasyon_odul_pkey PRIMARY KEY (id);


--
-- TOC entry 4988 (class 2606 OID 16663)
-- Name: animasyon_platform animasyon_platform_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animasyon_platform
    ADD CONSTRAINT animasyon_platform_pkey PRIMARY KEY (id);


--
-- TOC entry 4984 (class 2606 OID 16629)
-- Name: animasyon_teknik animasyon_teknik_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animasyon_teknik
    ADD CONSTRAINT animasyon_teknik_pkey PRIMARY KEY (id);


--
-- TOC entry 4972 (class 2606 OID 16470)
-- Name: animasyondizileri animasyondizileri_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animasyondizileri
    ADD CONSTRAINT animasyondizileri_pkey PRIMARY KEY (animasyonid);


--
-- TOC entry 4978 (class 2606 OID 16590)
-- Name: janralar janralar_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.janralar
    ADD CONSTRAINT janralar_pkey PRIMARY KEY (janraid);


--
-- TOC entry 4992 (class 2606 OID 16699)
-- Name: karakter_seslendirmen karakter_seslendirmen_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.karakter_seslendirmen
    ADD CONSTRAINT karakter_seslendirmen_pkey PRIMARY KEY (id);


--
-- TOC entry 4990 (class 2606 OID 16684)
-- Name: karakterler karakterler_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.karakterler
    ADD CONSTRAINT karakterler_pkey PRIMARY KEY (karakterid);


--
-- TOC entry 4964 (class 2606 OID 16398)
-- Name: kisiler kisiler_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kisiler
    ADD CONSTRAINT kisiler_pkey PRIMARY KEY (kisiid);


--
-- TOC entry 4994 (class 2606 OID 16718)
-- Name: oduller oduller_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oduller
    ADD CONSTRAINT oduller_pkey PRIMARY KEY (odulid);


--
-- TOC entry 4986 (class 2606 OID 16653)
-- Name: platformlar platformlar_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.platformlar
    ADD CONSTRAINT platformlar_pkey PRIMARY KEY (platformid);


--
-- TOC entry 4968 (class 2606 OID 16422)
-- Name: senaristler senaristler_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.senaristler
    ADD CONSTRAINT senaristler_pkey PRIMARY KEY (senaristid);


--
-- TOC entry 4970 (class 2606 OID 16436)
-- Name: seslendirmenler seslendirmenler_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seslendirmenler
    ADD CONSTRAINT seslendirmenler_pkey PRIMARY KEY (seslendirmenid);


--
-- TOC entry 4974 (class 2606 OID 16480)
-- Name: sezonlar sezonlar_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sezonlar
    ADD CONSTRAINT sezonlar_pkey PRIMARY KEY (sezonid);


--
-- TOC entry 4980 (class 2606 OID 16599)
-- Name: studyolar studyolar_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.studyolar
    ADD CONSTRAINT studyolar_pkey PRIMARY KEY (studyoid);


--
-- TOC entry 4976 (class 2606 OID 16581)
-- Name: teknikler teknikler_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teknikler
    ADD CONSTRAINT teknikler_pkey PRIMARY KEY (teknikid);


--
-- TOC entry 4966 (class 2606 OID 16408)
-- Name: yonetmenler yonetmenler_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yonetmenler
    ADD CONSTRAINT yonetmenler_pkey PRIMARY KEY (yonetmenid);


--
-- TOC entry 5013 (class 2620 OID 16760)
-- Name: animasyondizileri tetikleyici_ayniisim; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tetikleyici_ayniisim BEFORE INSERT ON public.animasyondizileri FOR EACH ROW EXECUTE FUNCTION public.ayniisimkontrol();


--
-- TOC entry 5014 (class 2620 OID 16758)
-- Name: animasyondizileri tetikleyici_basharf; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tetikleyici_basharf BEFORE INSERT OR UPDATE ON public.animasyondizileri FOR EACH ROW EXECUTE FUNCTION public.ismiguzellestir();


--
-- TOC entry 5015 (class 2620 OID 16747)
-- Name: animasyondizileri trg_imdb_kontrol; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_imdb_kontrol BEFORE INSERT OR UPDATE ON public.animasyondizileri FOR EACH ROW EXECUTE FUNCTION public.imdb_kontrol();


--
-- TOC entry 5016 (class 2620 OID 16744)
-- Name: animasyondizileri trg_yil_kontrol; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_yil_kontrol BEFORE INSERT OR UPDATE ON public.animasyondizileri FOR EACH ROW EXECUTE FUNCTION public.yil_kontrol();


--
-- TOC entry 5002 (class 2606 OID 16610)
-- Name: animasyon_janra animasyon_janra_animasyonid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animasyon_janra
    ADD CONSTRAINT animasyon_janra_animasyonid_fkey FOREIGN KEY (animasyonid) REFERENCES public.animasyondizileri(animasyonid);


--
-- TOC entry 5003 (class 2606 OID 16615)
-- Name: animasyon_janra animasyon_janra_janraid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animasyon_janra
    ADD CONSTRAINT animasyon_janra_janraid_fkey FOREIGN KEY (janraid) REFERENCES public.janralar(janraid);


--
-- TOC entry 5011 (class 2606 OID 16729)
-- Name: animasyon_odul animasyon_odul_animasyonid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animasyon_odul
    ADD CONSTRAINT animasyon_odul_animasyonid_fkey FOREIGN KEY (animasyonid) REFERENCES public.animasyondizileri(animasyonid);


--
-- TOC entry 5012 (class 2606 OID 16734)
-- Name: animasyon_odul animasyon_odul_odulid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animasyon_odul
    ADD CONSTRAINT animasyon_odul_odulid_fkey FOREIGN KEY (odulid) REFERENCES public.oduller(odulid);


--
-- TOC entry 5006 (class 2606 OID 16664)
-- Name: animasyon_platform animasyon_platform_animasyonid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animasyon_platform
    ADD CONSTRAINT animasyon_platform_animasyonid_fkey FOREIGN KEY (animasyonid) REFERENCES public.animasyondizileri(animasyonid);


--
-- TOC entry 5007 (class 2606 OID 16669)
-- Name: animasyon_platform animasyon_platform_platformid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animasyon_platform
    ADD CONSTRAINT animasyon_platform_platformid_fkey FOREIGN KEY (platformid) REFERENCES public.platformlar(platformid);


--
-- TOC entry 5004 (class 2606 OID 16630)
-- Name: animasyon_teknik animasyon_teknik_animasyonid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animasyon_teknik
    ADD CONSTRAINT animasyon_teknik_animasyonid_fkey FOREIGN KEY (animasyonid) REFERENCES public.animasyondizileri(animasyonid);


--
-- TOC entry 5005 (class 2606 OID 16635)
-- Name: animasyon_teknik animasyon_teknik_teknikid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animasyon_teknik
    ADD CONSTRAINT animasyon_teknik_teknikid_fkey FOREIGN KEY (teknikid) REFERENCES public.teknikler(teknikid);


--
-- TOC entry 5000 (class 2606 OID 16640)
-- Name: animasyondizileri fk_animasyon_studyo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animasyondizileri
    ADD CONSTRAINT fk_animasyon_studyo FOREIGN KEY (studyoid) REFERENCES public.studyolar(studyoid);


--
-- TOC entry 5009 (class 2606 OID 16700)
-- Name: karakter_seslendirmen karakter_seslendirmen_karakterid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.karakter_seslendirmen
    ADD CONSTRAINT karakter_seslendirmen_karakterid_fkey FOREIGN KEY (karakterid) REFERENCES public.karakterler(karakterid);


--
-- TOC entry 5010 (class 2606 OID 16705)
-- Name: karakter_seslendirmen karakter_seslendirmen_kisiid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.karakter_seslendirmen
    ADD CONSTRAINT karakter_seslendirmen_kisiid_fkey FOREIGN KEY (kisiid) REFERENCES public.kisiler(kisiid);


--
-- TOC entry 5008 (class 2606 OID 16685)
-- Name: karakterler karakterler_animasyonid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.karakterler
    ADD CONSTRAINT karakterler_animasyonid_fkey FOREIGN KEY (animasyonid) REFERENCES public.animasyondizileri(animasyonid);


--
-- TOC entry 4998 (class 2606 OID 16423)
-- Name: senaristler senaristler_kisiid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.senaristler
    ADD CONSTRAINT senaristler_kisiid_fkey FOREIGN KEY (kisiid) REFERENCES public.kisiler(kisiid);


--
-- TOC entry 4999 (class 2606 OID 16437)
-- Name: seslendirmenler seslendirmenler_kisiid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seslendirmenler
    ADD CONSTRAINT seslendirmenler_kisiid_fkey FOREIGN KEY (kisiid) REFERENCES public.kisiler(kisiid);


--
-- TOC entry 5001 (class 2606 OID 16481)
-- Name: sezonlar sezonlar_animasyonid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sezonlar
    ADD CONSTRAINT sezonlar_animasyonid_fkey FOREIGN KEY (animasyonid) REFERENCES public.animasyondizileri(animasyonid);


--
-- TOC entry 4997 (class 2606 OID 16409)
-- Name: yonetmenler yonetmenler_kisiid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yonetmenler
    ADD CONSTRAINT yonetmenler_kisiid_fkey FOREIGN KEY (kisiid) REFERENCES public.kisiler(kisiid);


-- Completed on 2025-12-18 22:39:07

--
-- PostgreSQL database dump complete
--

\unrestrict F1nkIxj1vhcqRsY4HriftIyJICHIsllKYVaOeyz88zIsghipicMUmfVDaRe63UV

