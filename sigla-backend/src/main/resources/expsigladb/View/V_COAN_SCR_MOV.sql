--------------------------------------------------------
--  DDL for View V_COAN_SCR_MOV
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "V_COAN_SCR_MOV" ("CD_CDS", "ESERCIZIO", "CD_UNITA_ORGANIZZATIVA", "PG_SCRITTURA", "DS_SCRITTURA", "ORIGINE_SCRITTURA", "CD_TIPO_DOCUMENTO", "CD_CDS_DOCUMENTO", "CD_UO_DOCUMENTO", "PG_NUMERO_DOCUMENTO", "ESERCIZIO_DOCUMENTO_AMM", "CD_COMP_DOCUMENTO", "IM_SCRITTURA", "STATO", "ATTIVA", "CD_VOCE_EP", "DS_VOCE_EP", "SEZIONE", "CD_CENTRO_RESPONSABILITA", "IM_MOVIMENTO", "CD_FUNZIONE", "CD_NATURA") AS 
  (SELECT
--
-- Date: 07/05/2004
-- Version: 1.0
--
-- Vista di estrazione join scritture movimenti conti
--
-- History:
-- Date: 14/04/2004
-- Version: 1.0
-- Creazione
--
-- Body:
--
 a.CD_CDS,
 a.ESERCIZIO,
 a.CD_UNITA_ORGANIZZATIVA,
 a.PG_SCRITTURA,
 a.DS_SCRITTURA,
 a.ORIGINE_SCRITTURA,
 a.CD_TIPO_DOCUMENTO,
 a.CD_CDS_DOCUMENTO,
 a.CD_UO_DOCUMENTO,
 a.PG_NUMERO_DOCUMENTO,
 a.ESERCIZIO_DOCUMENTO_AMM,
 a.CD_COMP_DOCUMENTO,
 a.IM_SCRITTURA,
 a.STATO,
 a.ATTIVA,
 b.CD_VOCE_EP,
 c.DS_VOCE_EP,
 b.SEZIONE,
 B.cd_CENTRO_rESPONSABILITA,
 b.IM_MOVIMENTO,
 b.CD_FUNZIONE,
 B.CD_NATURA
 FROM SCRITTURA_ANALITICA a,MOVIMENTO_COAN b,VOCE_EP c WHERE
      a.CD_CDS=b.CD_CDS
  AND a.ESERCIZIO=b.ESERCIZIO
  AND a.CD_UNITA_ORGANIZZATIVA=b.CD_UNITA_ORGANIZZATIVA
  AND a.PG_SCRITTURA=b.PG_SCRITTURA
  AND b.ESERCIZIO=c.ESERCIZIO
  AND b.ESERCIZIO=c.ESERCIZIO
  AND b.CD_VOCE_EP=c.CD_VOCE_EP
) ORDER BY
  ESERCIZIO,
  cd_cds,
  cd_unita_organizzativa,
  pg_scrittura,
  pg_movimento
;

   COMMENT ON TABLE "V_COAN_SCR_MOV"  IS 'Vista di estrazione join scritture movimenti conti';
