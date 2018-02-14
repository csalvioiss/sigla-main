--------------------------------------------------------
--  DDL for View V_CONS_FATTURA_GAE_SPLIT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "V_CONS_FATTURA_GAE_SPLIT" ("CD_CDS", "CD_UNITA_ORGANIZZATIVA", "ESERCIZIO_FATTURA", "MESE", "PG_FATTURA_PASSIVA", "PROGRESSIVO_RIGA", "CD_BENE_SERVIZIO", "DS_RIGA_FATTURA", "TI_FATTURA", "IM_IMPONIBILE", "IM_IVA", "CD_VOCE_IVA", "ESERCIZIO_OBBLIGAZIONE", "ESERCIZIO_ORI_OBBLIGAZIONE", "PG_OBBLIGAZIONE", "PG_OBBLIGAZIONE_SCADENZARIO", "CD_ELEMENTO_VOCE", "CD_TERZO", "CD_CENTRO_RESPONSABILITA", "CD_LINEA_ATTIVITA", "IM_VOCE", "IM_QUOTA") AS 
  select
    FATTURA_PASSIVA_RIGA.CD_CDS,
    FATTURA_PASSIVA_RIGA.CD_UNITA_ORGANIZZATIVA,
    FATTURA_PASSIVA_RIGA.ESERCIZIO,
    TO_NUMBER (TO_CHAR (fattura_passiva.dt_registrazione, 'mm')) mese,
    FATTURA_PASSIVA_RIGA.PG_FATTURA_PASSIVA,
    FATTURA_PASSIVA_RIGA.PROGRESSIVO_RIGA,
    FATTURA_PASSIVA_RIGA.CD_BENE_SERVIZIO,
    FATTURA_PASSIVA_RIGA.DS_RIGA_FATTURA,
    decode (FATTURA_PASSIVA.TI_FATTURA,'C','Nota Credito', 'D','Nota Debito','Fattura') ti_fattura,
    decode (FATTURA_PASSIVA.TI_FATTURA,'C',-FATTURA_PASSIVA_RIGA.IM_IMPONIBILE,FATTURA_PASSIVA_RIGA.IM_IMPONIBILE )im_imponibile,
    decode (FATTURA_PASSIVA.TI_FATTURA,'C',-FATTURA_PASSIVA_RIGA.IM_IVA,FATTURA_PASSIVA_RIGA.IM_IVA )IM_IVA,
    FATTURA_PASSIVA_RIGA.CD_VOCE_IVA,
 		OBBLIGAZIONE_SCADENZARIO.ESERCIZIO ESERCIZIO_OBBLIGAZIONE,
    OBBLIGAZIONE_SCADENZARIO.ESERCIZIO_ORIGINALE ESERCIZIO_ORI_OBBLIGAZIONE,
    OBBLIGAZIONE_SCADENZARIO.PG_OBBLIGAZIONE,
    OBBLIGAZIONE_SCADENZARIO.PG_OBBLIGAZIONE_SCADENZARIO,
    OBBLIGAZIONE.CD_ELEMENTO_VOCE,
	FATTURA_PASSIVA.CD_TERZO,
	OBBLIGAZIONE_SCAD_VOCE.CD_CENTRO_RESPONSABILITA,
	OBBLIGAZIONE_SCAD_VOCE.CD_LINEA_ATTIVITA,
	round((FATTURA_PASSIVA_RIGA.IM_IMPONIBILE *OBBLIGAZIONE_SCAD_VOCE.IM_VOCE)/OBBLIGAZIONE_SCADENZARIO.im_scadenza,2) im_voce,
	decode (FATTURA_PASSIVA.TI_FATTURA,'C',- round(((FATTURA_PASSIVA_RIGA.IM_IMPONIBILE *OBBLIGAZIONE_SCAD_VOCE.IM_VOCE)/OBBLIGAZIONE_SCADENZARIO.im_scadenza /FATTURA_PASSIVA_RIGA.IM_IMPONIBILE) * IM_IVA*(100-percentuale)/100,2),
	round(((FATTURA_PASSIVA_RIGA.IM_IMPONIBILE *OBBLIGAZIONE_SCAD_VOCE.IM_VOCE)/OBBLIGAZIONE_SCADENZARIO.im_scadenza /FATTURA_PASSIVA_RIGA.IM_IMPONIBILE) * IM_IVA*(100-percentuale)/100,2)) im_quota
FROM
    FATTURA_PASSIVA ,
    FATTURA_PASSIVA_RIGA ,
    OBBLIGAZIONE_SCADENZARIO ,
    OBBLIGAZIONE , OBBLIGAZIONE_SCAD_VOCE ,pro_rata
WHERE
    pro_rata.esercizio = fattura_passiva.esercizio -1 and
    FATTURA_PASSIVA_RIGA.TI_ISTITUZ_COMMERC ='C' and
    FATTURA_PASSIVA.FL_SPLIT_PAYMENT = 'Y' and
    OBBLIGAZIONE_SCADENZARIO.im_scadenza !=0 and
    NVL(FATTURA_PASSIVA_RIGA.IM_IMPONIBILE,0) !=0 AND
    NVL(FATTURA_PASSIVA_RIGA.IM_IVA,0) !=0 AND
    NVL(OBBLIGAZIONE_SCAD_VOCE.IM_VOCE,0) !=0 AND
	  FATTURA_PASSIVA.CD_CDS = FATTURA_PASSIVA_RIGA.CD_CDS AND
    FATTURA_PASSIVA.CD_UNITA_ORGANIZZATIVA = FATTURA_PASSIVA_RIGA.CD_UNITA_ORGANIZZATIVA AND
    FATTURA_PASSIVA.ESERCIZIO = FATTURA_PASSIVA_RIGA.ESERCIZIO AND
    FATTURA_PASSIVA.PG_FATTURA_PASSIVA = FATTURA_PASSIVA_RIGA.PG_FATTURA_PASSIVA AND
    FATTURA_PASSIVA_RIGA.CD_CDS_OBBLIGAZIONE = OBBLIGAZIONE_SCADENZARIO.CD_CDS AND
    FATTURA_PASSIVA_RIGA.ESERCIZIO_OBBLIGAZIONE = OBBLIGAZIONE_SCADENZARIO.ESERCIZIO AND
    FATTURA_PASSIVA_RIGA.ESERCIZIO_ORI_OBBLIGAZIONE = OBBLIGAZIONE_SCADENZARIO.ESERCIZIO_ORIGINALE AND
    FATTURA_PASSIVA_RIGA.PG_OBBLIGAZIONE = OBBLIGAZIONE_SCADENZARIO.PG_OBBLIGAZIONE AND
    FATTURA_PASSIVA_RIGA.PG_OBBLIGAZIONE_SCADENZARIO = OBBLIGAZIONE_SCADENZARIO.PG_OBBLIGAZIONE_SCADENZARIO AND
    OBBLIGAZIONE_SCADENZARIO.CD_CDS = OBBLIGAZIONE.CD_CDS AND
    OBBLIGAZIONE_SCADENZARIO.ESERCIZIO = OBBLIGAZIONE.ESERCIZIO AND
    OBBLIGAZIONE_SCADENZARIO.ESERCIZIO_ORIGINALE = OBBLIGAZIONE.ESERCIZIO_ORIGINALE AND
    OBBLIGAZIONE_SCADENZARIO.PG_OBBLIGAZIONE = OBBLIGAZIONE.PG_OBBLIGAZIONE  AND
    OBBLIGAZIONE_SCADENZARIO.CD_CDS = OBBLIGAZIONE_SCAD_VOCE.CD_CDS	AND
    OBBLIGAZIONE_SCADENZARIO.ESERCIZIO =      OBBLIGAZIONE_SCAD_VOCE.ESERCIZIO	AND
    OBBLIGAZIONE_SCADENZARIO.ESERCIZIO_ORIGINALE = OBBLIGAZIONE_SCAD_VOCE.ESERCIZIO_ORIGINALE	AND
    OBBLIGAZIONE_SCADENZARIO.PG_OBBLIGAZIONE =  OBBLIGAZIONE_SCAD_VOCE.PG_OBBLIGAZIONE	AND
    OBBLIGAZIONE_SCADENZARIO.PG_OBBLIGAZIONE_SCADENZARIO = OBBLIGAZIONE_SCAD_VOCE.PG_OBBLIGAZIONE_SCADENZARIO
union
select
    FATTURA_PASSIVA_RIGA.CD_CDS,
    FATTURA_PASSIVA_RIGA.CD_UNITA_ORGANIZZATIVA,
    FATTURA_PASSIVA_RIGA.ESERCIZIO,
    TO_NUMBER (TO_CHAR (fattura_passiva.dt_registrazione, 'mm')) mese,
    FATTURA_PASSIVA_RIGA.PG_FATTURA_PASSIVA,
    FATTURA_PASSIVA_RIGA.PROGRESSIVO_RIGA,
    FATTURA_PASSIVA_RIGA.CD_BENE_SERVIZIO,
    FATTURA_PASSIVA_RIGA.DS_RIGA_FATTURA,
    decode (FATTURA_PASSIVA.TI_FATTURA,'C','Nota Credito', 'D','Nota Debito','Fattura') ti_fattura,
    decode (FATTURA_PASSIVA.TI_FATTURA,'C',-FATTURA_PASSIVA_RIGA.IM_IMPONIBILE,FATTURA_PASSIVA_RIGA.IM_IMPONIBILE )im_imponibile,
    decode (FATTURA_PASSIVA.TI_FATTURA,'C',-FATTURA_PASSIVA_RIGA.IM_IVA,FATTURA_PASSIVA_RIGA.IM_IVA )IM_IVA,
    FATTURA_PASSIVA_RIGA.CD_VOCE_IVA,
    OBBLIGAZIONE_SCADENZARIO.ESERCIZIO ESERCIZIO_OBBLIGAZIONE,
    OBBLIGAZIONE_SCADENZARIO.ESERCIZIO_ORIGINALE ESERCIZIO_ORI_OBBLIGAZIONE,
    OBBLIGAZIONE_SCADENZARIO.PG_OBBLIGAZIONE,
    OBBLIGAZIONE_SCADENZARIO.PG_OBBLIGAZIONE_SCADENZARIO,
    OBBLIGAZIONE.CD_ELEMENTO_VOCE,
	FATTURA_PASSIVA.CD_TERZO,
	OBBLIGAZIONE_SCAD_VOCE.CD_CENTRO_RESPONSABILITA,
	OBBLIGAZIONE_SCAD_VOCE.CD_LINEA_ATTIVITA,
	round((FATTURA_PASSIVA_RIGA.IM_IMPONIBILE *OBBLIGAZIONE_SCAD_VOCE.IM_VOCE)/OBBLIGAZIONE_SCADENZARIO.im_scadenza,2) im_voce,
	decode (FATTURA_PASSIVA.TI_FATTURA,'C',- round(((FATTURA_PASSIVA_RIGA.IM_IMPONIBILE *OBBLIGAZIONE_SCAD_VOCE.IM_VOCE)/OBBLIGAZIONE_SCADENZARIO.im_scadenza /FATTURA_PASSIVA_RIGA.IM_IMPONIBILE) * IM_IVA*(100-percentuale)/100,2),
	round(((FATTURA_PASSIVA_RIGA.IM_IMPONIBILE *OBBLIGAZIONE_SCAD_VOCE.IM_VOCE)/OBBLIGAZIONE_SCADENZARIO.im_scadenza /FATTURA_PASSIVA_RIGA.IM_IMPONIBILE) * IM_IVA*(100-percentuale)/100,2)) im_quota
FROM
    FATTURA_PASSIVA ,
    FATTURA_PASSIVA_RIGA ,
    OBBLIGAZIONE_SCADENZARIO,
    OBBLIGAZIONE , OBBLIGAZIONE_SCAD_VOCE ,pro_rata,compenso
WHERE
    pro_rata.esercizio = fattura_passiva.esercizio -1 and
    FATTURA_PASSIVA_RIGA.TI_ISTITUZ_COMMERC ='C' and
    FATTURA_PASSIVA.FL_SPLIT_PAYMENT = 'Y' and
    NVL(FATTURA_PASSIVA_RIGA.IM_IMPONIBILE,0) !=0 AND
    NVL(FATTURA_PASSIVA_RIGA.IM_IVA,0) !=0 AND
    NVL(OBBLIGAZIONE_SCAD_VOCE.IM_VOCE,0) !=0 AND
    OBBLIGAZIONE_SCADENZARIO.im_scadenza !=0 and
	  FATTURA_PASSIVA.CD_CDS = FATTURA_PASSIVA_RIGA.CD_CDS AND
    FATTURA_PASSIVA.CD_UNITA_ORGANIZZATIVA = FATTURA_PASSIVA_RIGA.CD_UNITA_ORGANIZZATIVA AND
    FATTURA_PASSIVA.ESERCIZIO = FATTURA_PASSIVA_RIGA.ESERCIZIO AND
    FATTURA_PASSIVA.PG_FATTURA_PASSIVA = FATTURA_PASSIVA_RIGA.PG_FATTURA_PASSIVA AND
    fattura_passiva.ESERCIZIO_COMPENSO = compenso.esercizio and
   	fattura_passiva.CDS_COMPENSO       = compenso.cd_cds and
   	fattura_passiva.UO_COMPENSO				= compenso.cd_unita_organizzativa and
   	fattura_passiva.PG_COMPENSO			  = compenso.pg_compenso and
    OBBLIGAZIONE_SCADENZARIO.esercizio = compenso.esercizio_obbligazione	and
    OBBLIGAZIONE_SCADENZARIO.esercizio_originale = compenso.esercizio_ori_obbligazione	and
    OBBLIGAZIONE_SCADENZARIO.cd_cds = compenso.cd_cds_obbligazione		and
    OBBLIGAZIONE_SCADENZARIO.pg_obbligazione = compenso.pg_obbligazione		and
    OBBLIGAZIONE_SCADENZARIO.pg_obbligazione_scadenzario= compenso.pg_obbligazione_scadenzario	and
    OBBLIGAZIONE_SCADENZARIO.CD_CDS = OBBLIGAZIONE.CD_CDS AND
    OBBLIGAZIONE_SCADENZARIO.ESERCIZIO = OBBLIGAZIONE.ESERCIZIO AND
    OBBLIGAZIONE_SCADENZARIO.ESERCIZIO_ORIGINALE = OBBLIGAZIONE.ESERCIZIO_ORIGINALE AND
    OBBLIGAZIONE_SCADENZARIO.PG_OBBLIGAZIONE = OBBLIGAZIONE.PG_OBBLIGAZIONE  AND
    OBBLIGAZIONE_SCADENZARIO.CD_CDS = OBBLIGAZIONE_SCAD_VOCE.CD_CDS	AND
    OBBLIGAZIONE_SCADENZARIO.ESERCIZIO =      OBBLIGAZIONE_SCAD_VOCE.ESERCIZIO	AND
    OBBLIGAZIONE_SCADENZARIO.ESERCIZIO_ORIGINALE = OBBLIGAZIONE_SCAD_VOCE.ESERCIZIO_ORIGINALE	AND
    OBBLIGAZIONE_SCADENZARIO.PG_OBBLIGAZIONE =  OBBLIGAZIONE_SCAD_VOCE.PG_OBBLIGAZIONE	AND
    OBBLIGAZIONE_SCADENZARIO.PG_OBBLIGAZIONE_SCADENZARIO = OBBLIGAZIONE_SCAD_VOCE.PG_OBBLIGAZIONE_SCADENZARIO
    order by 1,2,3,4,5,6;