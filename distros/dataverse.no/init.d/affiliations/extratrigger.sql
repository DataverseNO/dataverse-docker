CREATE TABLE IF NOT EXISTS public.dvnoaffiliations (
    id bigint,
    dvno_affiliation character varying(255) DEFAULT NULL::character varying,
    dvno_group_name character varying(255) DEFAULT NULL::character varying,
    dvno_email_level integer DEFAULT 2
);

ALTER TABLE public.dvnoaffiliations OWNER TO dataverse;

CREATE OR REPLACE FUNCTION public.affiliationupdate() RETURNS trigger
     LANGUAGE plpgsql
     AS $$

BEGIN
    update authenticateduser set affiliation=dvno_affiliation from dvnoaffiliations where dvno_group_name=substring(email, '\S+\W(\w+\W+\w+)') and substring(email, '\S+\W(\w+\W+\w+)') in (select dvno_group_name from dvnoaffiliations);
    update authenticateduser set affiliation=dvno_affiliation from dvnoaffiliations where dvno_group_name=substring(email, '\S+\W(\w+\W+\w+\W+\w+)') and substring(email, '\S+\W(\w+\W+\w+\W+\w+)') in (select dvno_group_name from dvnoaffiliations);

RETURN NULL;
END;
$$
CREATE TRIGGER affiliation_trigger AFTER INSERT ON public.authenticateduser FOR EACH ROW EXECUTE PROCEDURE public.affiliationupdate();
