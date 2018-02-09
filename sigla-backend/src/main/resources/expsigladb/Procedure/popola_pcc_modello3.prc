CREATE OR REPLACE procedure popola_pcc_modello3 is
begin
declare
cursor testata_pag is
--CODICE_UNIVOCO_UFFICIO_IPA o codice_univoco_pcc
select  fattura_passiva.esercizio,fattura_passiva.cd_unita_organizzativa,fattura_passiva.pg_fattura_passiva,ti_fattura,fattura_passiva.cd_terzo,
				fattura_passiva.cd_cds,fattura_passiva.im_totale_fattura,fattura_passiva.STATO_PAGAMENTO_FONDO_ECO, fattura_passiva.PG_COMPENSO,FL_FATTURA_COMPENSO ,
				DT_FATTURA_FORNITORE,NR_FATTURA_FORNITORE,fattura_passiva.identificativo_sdi,
				cd_iso,ti_nazione,terzo_uo.codice_univoco_pcc,
anagrafico.partita_iva ana_partita_iva,anagrafico.codice_fiscale ana_codice_fiscale ,
fattura_passiva.fl_split_payment split,sum(fattura_passiva_riga.im_iva) tot_iva,sum(fattura_passiva_riga.im_imponibile) tot_imp,fattura_passiva.TI_ISTITUZ_COMMERC
from fattura_passiva,nazione,anagrafico,terzo,terzo terzo_uo,fattura_passiva_riga
where
	fattura_passiva.cd_cds = fattura_passiva_riga.cd_cds  and
   fattura_passiva.cd_unita_organizzativa = fattura_passiva_riga.cd_unita_organizzativa and
   fattura_passiva.esercizio = fattura_passiva_riga.esercizio  and
   fattura_passiva.pg_fattura_passiva =   fattura_passiva_riga.pg_fattura_passiva and
	 terzo_uo.cd_unita_organizzativa = fattura_passiva.cd_unita_organizzativa and
   anagrafico.cd_anag = terzo.cd_anag and
    --fattura_passiva.identificativo_sdi in('83468891','83468887','83224285','82633958','83689220') and
   --fattura_passiva.identificativo_sdi in( 83313811,83043906) and
   terzo.cd_terzo  = fattura_passiva.cd_terzo and
   (terzo_uo.cd_terzo = (select min(cd_terzo) from terzo uo where
   uo.cd_unita_organizzativa =   fattura_passiva.cd_unita_organizzativa and
   fattura_passiva.identificativo_sdi is null) or
   (fattura_passiva.identificativo_sdi is not null and
   terzo_uo.cd_unita_organizzativa =   fattura_passiva.cd_unita_organizzativa
   and exists(select 1 from documento_ele_trasmissione where
   documento_ele_trasmissione.identificativo_sdi = fattura_passiva.identificativo_sdi and
   documento_ele_trasmissione.codice_destinatario = terzo_uo.CODICE_UNIVOCO_UFFICIO_IPA))) and
   nazione.pg_nazione =  anagrafico.pg_nazione_fiscale and
   (DT_FATTURA_FORNITORE    > (select dt01 from configurazione_cnr where
   cd_chiave_primaria   = 'REGISTRO_UNICO_FATPAS' and
   cd_chiave_secondaria = 'DATA_INIZIO') or
   (fattura_passiva.identificativo_sdi is not null))
   and (fattura_passiva.stato_cofi in('P','Q') or
   	    STATO_PAGAMENTO_FONDO_ECO = 'R' or
   	    (FL_FATTURA_COMPENSO = 'Y' and
   	     exists(select 1 from compenso
   	     where
   	     compenso.stato_cofi='P' and
   	     fattura_passiva.ESERCIZIO_COMPENSO = compenso.esercizio and
   	     fattura_passiva.CDS_COMPENSO       = compenso.cd_cds and
   	     fattura_passiva.UO_COMPENSO				= compenso.cd_unita_organizzativa and
   	     fattura_passiva.PG_COMPENSO			  = compenso.pg_compenso)))
   and exists
   (select 1 from modello2_pcc
   where
   nvl(modello2_pcc.codice_segnalazione,'OK')='OK' and
   --modello2_pcc.codice_segnalazione='OK' and
   --nvl(modello2_pcc.descrizione_segnalazione,' ')!='ELETTRONICA' AND
   modello2_pcc.NUMERO_FATTURA = fattura_passiva.NR_FATTURA_FORNITORE AND
   modello2_pcc.data_emissione = fattura_passiva.DT_FATTURA_FORNITORE AND
   modello2_pcc.id_fiscale_IVA =substr(decode(nazione.TI_NAZIONE,'E',nvl(anagrafico.partita_iva,anagrafico.codice_fiscale),decode(nazione.cd_iso||anagrafico.partita_iva,nazione.cd_iso,anagrafico.codice_fiscale,nazione.cd_iso||anagrafico.partita_iva)),0,16))
   and not exists
   (select 1 from modello3_pcc
   where
   nvl(modello3_pcc.codice_segnalazione,'OK')='OK' and
   modello3_pcc.azione='CP' and
   modello3_pcc.importo_pagato=fattura_passiva.im_totale_fattura  and
   modello3_pcc.NUMERO_FATTURA = fattura_passiva.NR_FATTURA_FORNITORE AND
   modello3_pcc.data_emissione = fattura_passiva.DT_FATTURA_FORNITORE AND
   modello3_pcc.id_fiscale_IVA =substr(decode(nazione.TI_NAZIONE,'E',nvl(anagrafico.partita_iva,anagrafico.codice_fiscale),decode(nazione.cd_iso||anagrafico.partita_iva,nazione.cd_iso,anagrafico.codice_fiscale,nazione.cd_iso||anagrafico.partita_iva)),0,16))
   group by fattura_passiva.esercizio,fattura_passiva.cd_unita_organizzativa,fattura_passiva.pg_fattura_passiva,ti_fattura,fattura_passiva.cd_terzo,
   fattura_passiva.cd_cds,fattura_passiva.im_totale_fattura,fattura_passiva.STATO_PAGAMENTO_FONDO_ECO, fattura_passiva.PG_COMPENSO,FL_FATTURA_COMPENSO ,
   DT_FATTURA_FORNITORE,NR_FATTURA_FORNITORE,fattura_passiva.identificativo_sdi,
   cd_iso,ti_nazione,terzo_uo.codice_univoco_pcc,
	anagrafico.partita_iva ,anagrafico.codice_fiscale  ,fattura_passiva.fl_split_payment,fattura_passiva.TI_ISTITUZ_COMMERC
   order by fattura_passiva.esercizio,fattura_passiva.cd_unita_organizzativa,fattura_passiva.pg_fattura_passiva;


  cursor testata_cont is
--CODICE_UNIVOCO_UFFICIO_IPA o codice_univoco_pcc
select fattura_passiva.*,cd_iso,ti_nazione,terzo_uo.codice_univoco_pcc,
anagrafico.partita_iva ana_partita_iva,anagrafico.codice_fiscale ana_codice_fiscale
from fattura_passiva,nazione,anagrafico,terzo,terzo terzo_uo
where
	 terzo_uo.cd_unita_organizzativa = fattura_passiva.cd_unita_organizzativa and
   anagrafico.cd_anag = terzo.cd_anag and
   terzo.cd_terzo  = fattura_passiva.cd_terzo and
   (terzo_uo.cd_terzo = (select min(cd_terzo) from terzo uo where
   uo.cd_unita_organizzativa =   fattura_passiva.cd_unita_organizzativa and
   fattura_passiva.identificativo_sdi is null) or
   (fattura_passiva.identificativo_sdi is not null and
   terzo_uo.cd_unita_organizzativa =   fattura_passiva.cd_unita_organizzativa
   and exists(select 1 from documento_ele_trasmissione where
   documento_ele_trasmissione.identificativo_sdi = fattura_passiva.identificativo_sdi and
   documento_ele_trasmissione.codice_destinatario = terzo_uo.CODICE_UNIVOCO_UFFICIO_IPA))) and
   nazione.pg_nazione =  anagrafico.pg_nazione_fiscale and
   DT_FATTURA_FORNITORE    > (select dt01 from configurazione_cnr where
   cd_chiave_primaria   = 'REGISTRO_UNICO_FATPAS' and
   cd_chiave_secondaria = 'DATA_INIZIO')
   --and stato_liquidazione is not null
  /* and (fattura_passiva.stato_cofi !='P' and
   	    STATO_PAGAMENTO_FONDO_ECO = 'N' and
   	    ((FL_FATTURA_COMPENSO = 'Y' and
   	     exists(select 1 from compenso
   	     where
   	     compenso.stato_cofi!='P' and
   	     fattura_passiva.ESERCIZIO_COMPENSO = compenso.esercizio and
   	     fattura_passiva.CDS_COMPENSO       = compenso.cd_cds and
   	     fattura_passiva.UO_COMPENSO				= compenso.cd_unita_organizzativa and
   	     fattura_passiva.PG_COMPENSO			  = compenso.pg_compenso))
        or FL_FATTURA_COMPENSO ='N'))
   and exists(Select 1 from fattura_passiva_riga
		where
     nvl(im_diponibile_nc,0)!=0 and
     				fattura_passiva_riga.stato_cofi  not in('P','A') and
						fattura_passiva_riga.cd_cds  = fattura_passiva.cd_cds  and
          	fattura_passiva_riga.cd_unita_organizzativa  = fattura_passiva.cd_unita_organizzativa and
        		fattura_passiva_riga.esercizio               = fattura_passiva.esercizio     and
        		fattura_passiva_riga.pg_fattura_passiva      = fattura_passiva.pg_fattura_passiva )   */
   and exists
   (select 1 from modello2_pcc
   where
   modello2_pcc.NUMERO_FATTURA = fattura_passiva.NR_FATTURA_FORNITORE AND
   modello2_pcc.data_emissione = fattura_passiva.DT_FATTURA_FORNITORE AND
   nvl(modello2_pcc.codice_segnalazione,'OK')='OK' and
   --modello2_pcc.codice_segnalazione='OK' and
   --nvl(modello2_pcc.descrizione_segnalazione,' ')!='ELETTRONICA' AND
   modello2_pcc.id_fiscale_IVA =substr(decode(nazione.TI_NAZIONE,'E',nvl(anagrafico.partita_iva,anagrafico.codice_fiscale),decode(nazione.cd_iso||anagrafico.partita_iva,nazione.cd_iso,anagrafico.codice_fiscale,nazione.cd_iso||anagrafico.partita_iva)),0,16))
   and not exists
   		 (select 1 from modello3_pcc
   				where
   				 modello3_pcc.CODICE_UFFICIO =terzo_uo.codice_univoco_pcc and
				   modello3_pcc.azione  ='CP' and
				   nvl(modello3_pcc.codice_segnalazione,'OK')='OK' and
				   modello3_pcc.numero_fattura = fattura_passiva.nr_fattura_fornitore and
				   modello3_pcc.data_emissione = fattura_passiva.dt_fattura_fornitore and
				   modello3_pcc.id_fiscale_IVA =substr(decode(nazione.TI_NAZIONE,'E',nvl(anagrafico.partita_iva,anagrafico.codice_fiscale),decode(nazione.cd_iso||anagrafico.partita_iva,nazione.cd_iso,anagrafico.codice_fiscale,nazione.cd_iso||anagrafico.partita_iva)),0,16))
   order by esercizio,fattura_passiva.cd_unita_organizzativa,pg_fattura_passiva;

	cursor cig_cupImpegno(es number,cds varchar2,uo varchar2,pg number,cd_terzo_in number) is
	select
	ds_obbligazione,ds_elemento_voce,sum(v_doc_passivo_obbligazione.im_scadenza)imp,cd_cig,cd_cup, decode(FL_INV_BENI_COMP,'Y','CA',decode(FL_INV_BENI_PATR,'Y','CA','CO')) natura,
	v_doc_passivo_obbligazione.esercizio_obbligazione,v_doc_passivo_obbligazione.cd_cds_obbligazione,v_doc_passivo_obbligazione.pg_obbligazione,v_doc_passivo_obbligazione.esercizio_ori_obbligazione
  from v_doc_passivo_obbligazione,obbligazione,obbligazione_scadenzario,contratto,elemento_voce
        where
        v_doc_passivo_obbligazione.cd_cds  = cds  and
      	v_doc_passivo_obbligazione.cd_unita_organizzativa  = uo and
        v_doc_passivo_obbligazione.esercizio               = es  and
        v_doc_passivo_obbligazione.PG_DOCUMENTO_AMM      = pg  and
        v_doc_passivo_obbligazione.CD_TERZO              =cd_terzo_in  AND
        v_doc_passivo_obbligazione.CD_TIPO_DOCUMENTO_AMM in('FATTURA_P','COMPENSO') and
        v_doc_passivo_obbligazione.stato_cofi not in('A') and
        	  obbligazione.cd_cds                 = obbligazione_scadenzario.cd_cds
        AND obbligazione.esercizio              = obbligazione_scadenzario.esercizio
        AND obbligazione.esercizio_originale    = obbligazione_scadenzario.esercizio_originale
        AND obbligazione.pg_obbligazione        = obbligazione_scadenzario.pg_obbligazione
        AND obbligazione_scadenzario.cd_cds                      = v_doc_passivo_obbligazione.cd_cds_obbligazione
        AND obbligazione_scadenzario.esercizio                   = v_doc_passivo_obbligazione.esercizio_obbligazione
        AND obbligazione_scadenzario.esercizio_originale         = v_doc_passivo_obbligazione.esercizio_ori_obbligazione
        AND obbligazione_scadenzario.pg_obbligazione             = v_doc_passivo_obbligazione.pg_obbligazione
        AND obbligazione_scadenzario.pg_obbligazione_scadenzario = v_doc_passivo_obbligazione.pg_obbligazione_scadenzario
        and elemento_voce.esercizio 			= obbligazione.esercizio
        AND elemento_voce.ti_appartenenza = obbligazione.ti_appartenenza
        AND elemento_voce.ti_gestione 		= obbligazione.ti_gestione
        AND elemento_voce.cd_elemento_voce = obbligazione.cd_elemento_voce
        AND contratto.esercizio         (+)= obbligazione.esercizio_contratto
        AND contratto.stato             (+)= obbligazione.stato_contratto
        AND contratto.pg_contratto      (+)= obbligazione.pg_contratto
  group by ds_obbligazione,ds_elemento_voce,cd_cig,cd_cup, decode(FL_INV_BENI_COMP,'Y','CA',decode(FL_INV_BENI_PATR,'Y','CA','CO')),
	v_doc_passivo_obbligazione.esercizio_obbligazione,v_doc_passivo_obbligazione.cd_cds_obbligazione,v_doc_passivo_obbligazione.pg_obbligazione,v_doc_passivo_obbligazione.esercizio_ori_obbligazione;

  cursor cig_cupMandato(es number,cds varchar2,uo varchar2,pg number,cd_terzo_in number,dt_fat date,nr_fat varchar2) is
	select dt_emissione,--??? dt_emissione
	ds_mandato,ds_elemento_voce,sum(nvl(mandato_siope.importo,mandato_riga.im_mandato_riga)) imp,cd_cig,mandato_siope_cup.cd_cup, sum(nvl(mandato_siope_cup.importo,0)) imp_cup,decode(FL_INV_BENI_COMP,'Y','CA',decode(FL_INV_BENI_PATR,'Y','CA','CO')) natura,mandato_riga.esercizio,mandato_riga.cd_cds,mandato_riga.pg_mandato,
	v_doc_passivo_obbligazione.esercizio_obbligazione,v_doc_passivo_obbligazione.cd_cds_obbligazione,v_doc_passivo_obbligazione.pg_obbligazione,v_doc_passivo_obbligazione.esercizio_ori_obbligazione,v_doc_passivo_obbligazione.pg_obbligazione_scadenzario,
  ANAGRAFICO.PARTITA_IVA,ANAGRAFICO.CODICE_FISCALE,cd_iso,ti_nazione,decode(v_doc_passivo_obbligazione.CD_TIPO_DOCUMENTO_AMM,'FATTURA_P', v_doc_passivo_obbligazione.IM_IMPONIBILE_DOC_AMM,fattura_passiva.IM_TOTALE_IMPONIBILE) tot_imp,v_doc_passivo_obbligazione.IM_TOTALE_DOC_AMM tot_doc
	from v_doc_passivo_obbligazione,obbligazione,obbligazione_scadenzario,contratto,
				mandato_riga,mandato_siope_cup,elemento_voce,nazione,anagrafico,terzo,MANDATO,mandato_siope,fattura_passiva
          where
            anagrafico.cd_anag = terzo.cd_anag and
   				  terzo.cd_terzo  = nvl(mandato_riga.cd_terzo_cedente,mandato_riga.cd_terzo) and
   					nazione.pg_nazione =  anagrafico.pg_nazione_fiscale and
          	v_doc_passivo_obbligazione.cd_cds  = cds  and
          	v_doc_passivo_obbligazione.cd_unita_organizzativa  = uo and
        		v_doc_passivo_obbligazione.esercizio               = es  and
        		v_doc_passivo_obbligazione.PG_DOCUMENTO_AMM      = pg  and
        		v_doc_passivo_obbligazione.CD_TERZO              =cd_terzo_in  AND
        		((v_doc_passivo_obbligazione.DT_FATTURA_FORNITORE = dt_fat and
        		v_doc_passivo_obbligazione.NR_FATTURA_FORNITORE = nr_fat and
        		v_doc_passivo_obbligazione.CD_TIPO_DOCUMENTO_AMM ='FATTURA_P' AND
        		fattura_passiva.esercizio = v_doc_passivo_obbligazione.esercizio and
   	      	fattura_passiva.cd_cds     = v_doc_passivo_obbligazione.cd_cds and
   	      	fattura_passiva.cd_unita_organizzativa			= v_doc_passivo_obbligazione.cd_unita_organizzativa and
   	      	fattura_passiva.pg_fattura_passiva		  = v_doc_passivo_obbligazione.PG_DOCUMENTO_AMM ) or
            (v_doc_passivo_obbligazione.CD_TIPO_DOCUMENTO_AMM ='COMPENSO'  AND
            fattura_passiva.DT_FATTURA_FORNITORE = dt_fat and
        		fattura_passiva.NR_FATTURA_FORNITORE = nr_fat and
            fattura_passiva.ESERCIZIO_COMPENSO = v_doc_passivo_obbligazione.esercizio and
            fattura_passiva.CDS_COMPENSO       = v_doc_passivo_obbligazione.cd_cds and
            fattura_passiva.UO_COMPENSO			 	 = v_doc_passivo_obbligazione.cd_unita_organizzativa and
            fattura_passiva.PG_COMPENSO			   = v_doc_passivo_obbligazione.PG_DOCUMENTO_AMM )) and
        	  obbligazione.cd_cds                 = obbligazione_scadenzario.cd_cds  and
        	  obbligazione.esercizio              = obbligazione_scadenzario.esercizio
        AND obbligazione.esercizio_originale    = obbligazione_scadenzario.esercizio_originale
        AND obbligazione.pg_obbligazione        = obbligazione_scadenzario.pg_obbligazione
        AND obbligazione_scadenzario.cd_cds                      = v_doc_passivo_obbligazione.cd_cds_obbligazione
        AND obbligazione_scadenzario.esercizio                   = v_doc_passivo_obbligazione.esercizio_obbligazione
        AND obbligazione_scadenzario.esercizio_originale         = v_doc_passivo_obbligazione.esercizio_ori_obbligazione
        AND obbligazione_scadenzario.pg_obbligazione             = v_doc_passivo_obbligazione.pg_obbligazione
        AND obbligazione_scadenzario.pg_obbligazione_scadenzario = v_doc_passivo_obbligazione.pg_obbligazione_scadenzario
        and elemento_voce.esercizio 			= obbligazione.esercizio
        AND elemento_voce.ti_appartenenza = obbligazione.ti_appartenenza
        AND elemento_voce.ti_gestione 		= obbligazione.ti_gestione
        AND elemento_voce.cd_elemento_voce = obbligazione.cd_elemento_voce
        AND contratto.esercizio         (+)= obbligazione.esercizio_contratto
        AND contratto.stato             (+)= obbligazione.stato_contratto
        AND contratto.pg_contratto      (+)= obbligazione.pg_contratto
        and v_doc_passivo_obbligazione.CD_TIPO_DOCUMENTO_AMM =mandato_riga.CD_TIPO_DOCUMENTO_AMM
        and v_doc_passivo_obbligazione.cd_cds 						= mandato_riga.cd_cds_doc_amm
        AND v_doc_passivo_obbligazione.cd_unita_organizzativa = mandato_riga.cd_uo_doc_amm
        AND v_doc_passivo_obbligazione.esercizio 							=  mandato_riga.esercizio_doc_amm
        AND v_doc_passivo_obbligazione.PG_DOCUMENTO_AMM 		= mandato_riga.pg_doc_amm
        AND v_doc_passivo_obbligazione.cd_cds_obbligazione 		= mandato_riga.cd_cds
        AND v_doc_passivo_obbligazione.esercizio_obbligazione = mandato_riga.esercizio_obbligazione
        AND v_doc_passivo_obbligazione.pg_obbligazione 				=  mandato_riga.pg_obbligazione
        AND v_doc_passivo_obbligazione.pg_obbligazione_scadenzario =  mandato_riga.pg_obbligazione_scadenzario
        AND v_doc_passivo_obbligazione.esercizio_ori_obbligazione  =   mandato_riga.esercizio_ori_obbligazione
        --AND v_doc_passivo_obbligazione.PG_banca 		= mandato_riga.pg_banca
        and mandato_riga.cd_cds = mandato_siope.cd_cds (+)
        AND mandato_riga.esercizio = mandato_siope.esercizio(+)
        AND mandato_riga.pg_mandato = mandato_siope.pg_mandato(+)
        AND mandato_riga.esercizio_obbligazione = mandato_siope.esercizio_obbligazione(+)
        AND mandato_riga.esercizio_ori_obbligazione = mandato_siope.esercizio_ori_obbligazione(+)
        AND mandato_riga.pg_obbligazione = mandato_siope.pg_obbligazione(+)
        AND mandato_riga.pg_obbligazione_scadenzario =mandato_siope.pg_obbligazione_scadenzario(+)
        AND mandato_riga.cd_cds_doc_amm = mandato_siope.cd_cds_doc_amm(+)
        AND mandato_riga.cd_uo_doc_amm = mandato_siope.cd_uo_doc_amm(+)
        AND mandato_riga.esercizio_doc_amm =mandato_siope.esercizio_doc_amm(+)
        AND mandato_riga.cd_tipo_documento_amm =mandato_siope.cd_tipo_documento_amm(+)
        AND mandato_riga.pg_doc_amm = mandato_siope.pg_doc_amm (+)
        and mandato_siope.cd_cds = mandato_siope_cup.cd_cds (+)
        AND mandato_siope.esercizio = mandato_siope_cup.esercizio (+)
        AND mandato_siope.pg_mandato = mandato_siope_cup.pg_mandato(+)
        AND mandato_siope.esercizio_obbligazione = mandato_siope_cup.esercizio_obbligazione(+)
        AND mandato_siope.esercizio_ori_obbligazione = mandato_siope_cup.esercizio_ori_obbligazione(+)
        AND mandato_siope.pg_obbligazione = mandato_siope_cup.pg_obbligazione(+)
        AND mandato_siope.pg_obbligazione_scadenzario =mandato_siope_cup.pg_obbligazione_scadenzario(+)
        AND mandato_siope.cd_cds_doc_amm = mandato_siope_cup.cd_cds_doc_amm(+)
        AND mandato_siope.cd_uo_doc_amm = mandato_siope_cup.cd_uo_doc_amm(+)
        AND mandato_siope.esercizio_doc_amm =mandato_siope_cup.esercizio_doc_amm(+)
        AND mandato_siope.cd_tipo_documento_amm =mandato_siope_cup.cd_tipo_documento_amm(+)
        AND mandato_siope.pg_doc_amm = mandato_siope_cup.pg_doc_amm(+)
        AND mandato_siope.esercizio_siope =mandato_siope_cup.esercizio_siope(+)
        AND mandato_siope.ti_gestione =mandato_siope_cup.ti_gestione(+)
        AND mandato_siope.cd_siope = mandato_siope_cup.cd_siope(+)
        AND mandato_siope_cup.importo(+) !=0
        AND mandato.cd_cds = mandato_riga.cd_cds
        AND mandato.esercizio = mandato_riga.esercizio
        AND mandato.pg_mandato = mandato_riga.pg_mandato
        and mandato.stato='P'
        and mandato_riga.stato!='A'
        and not exists
   		 (select 1 from modello3_pcc,nazione n2,anagrafico a2,terzo t2
   				where
   				 a2.cd_anag = t2.cd_anag and
   				 t2.cd_terzo  = v_doc_passivo_obbligazione.cd_terzo and
   				 n2.pg_nazione =  a2.pg_nazione_fiscale and
				   modello3_pcc.azione  ='CP' and
				   modello3_pcc.ESTREMI_IMPEGNO_CP = v_doc_passivo_obbligazione.esercizio_ori_obbligazione||'/'||v_doc_passivo_obbligazione.esercizio_obbligazione||'/'||v_doc_passivo_obbligazione.cd_cds_obbligazione||'/'||v_doc_passivo_obbligazione.pg_obbligazione and
				   modello3_pcc.numero_mandato=mandato.esercizio||'/'||mandato.cd_cds||'/'||mandato.pg_mandato and
				   modello3_pcc.NUMERO_FATTURA = nr_fat AND
				   modello3_pcc.data_emissione = dt_fat AND
				   modello3_pcc.id_fiscale_IVA =substr(decode(n2.TI_NAZIONE,'E',nvl(a2.partita_iva,a2.codice_fiscale),decode(n2.cd_iso||a2.partita_iva,n2.cd_iso,a2.codice_fiscale,n2.cd_iso||a2.partita_iva)),0,16))
		group by ds_mandato,ds_elemento_voce,dt_emissione,cd_cig,mandato_siope_cup.cd_cup, decode(FL_INV_BENI_COMP,'Y','CA',decode(FL_INV_BENI_PATR,'Y','CA','CO')),mandato_riga.esercizio,mandato_riga.cd_cds,mandato_riga.pg_mandato,
	 v_doc_passivo_obbligazione.esercizio_obbligazione,v_doc_passivo_obbligazione.cd_cds_obbligazione,v_doc_passivo_obbligazione.pg_obbligazione,v_doc_passivo_obbligazione.esercizio_ori_obbligazione,v_doc_passivo_obbligazione.pg_obbligazione_scadenzario,
	 ANAGRAFICO.PARTITA_IVA,ANAGRAFICO.CODICE_FISCALE,cd_iso,ti_nazione,decode(v_doc_passivo_obbligazione.CD_TIPO_DOCUMENTO_AMM,'FATTURA_P', v_doc_passivo_obbligazione.IM_IMPONIBILE_DOC_AMM,fattura_passiva.IM_TOTALE_IMPONIBILE),v_doc_passivo_obbligazione.IM_TOTALE_DOC_AMM
		order by
	 mandato_riga.pg_mandato,v_doc_passivo_obbligazione.esercizio_obbligazione,v_doc_passivo_obbligazione.cd_cds_obbligazione,v_doc_passivo_obbligazione.pg_obbligazione,v_doc_passivo_obbligazione.esercizio_ori_obbligazione,v_doc_passivo_obbligazione.pg_obbligazione_scadenzario,
	 ANAGRAFICO.PARTITA_IVA,ANAGRAFICO.CODICE_FISCALE,cd_iso,ti_nazione,mandato_siope_cup.cd_cup;

	   cursor testata_scad is
--CODICE_UNIVOCO_UFFICIO_IPA o codice_univoco_pcc
select fattura_passiva.*,cd_iso,ti_nazione,terzo_uo.codice_univoco_pcc
from fattura_passiva,nazione,anagrafico,terzo,terzo terzo_uo
where
	 terzo_uo.cd_unita_organizzativa = fattura_passiva.cd_unita_organizzativa and
   anagrafico.cd_anag = terzo.cd_anag and
   terzo.cd_terzo  = fattura_passiva.cd_terzo and
  (terzo_uo.cd_terzo = (select min(cd_terzo) from terzo uo where
   uo.cd_unita_organizzativa =   fattura_passiva.cd_unita_organizzativa and
   fattura_passiva.identificativo_sdi is null) or
   (fattura_passiva.identificativo_sdi is not null and
   terzo_uo.cd_unita_organizzativa =   fattura_passiva.cd_unita_organizzativa
   and exists(select 1 from documento_ele_trasmissione where
   documento_ele_trasmissione.identificativo_sdi = fattura_passiva.identificativo_sdi and
   documento_ele_trasmissione.codice_destinatario = terzo_uo.CODICE_UNIVOCO_UFFICIO_IPA))) and
   nazione.pg_nazione =  anagrafico.pg_nazione_fiscale and
   DT_FATTURA_FORNITORE    > (select dt01 from configurazione_cnr where
   cd_chiave_primaria   = 'REGISTRO_UNICO_FATPAS' and
   cd_chiave_secondaria = 'DATA_INIZIO')
   and stato_liquidazione ='LIQ'
   and dt_scadenza <TO_DATE('01'||TO_CHAR(SYSDATE,'MMYYYY'),'DDMMYYYY')
   and (fattura_passiva.stato_cofi  not in('P','A') and
   	    STATO_PAGAMENTO_FONDO_ECO = 'N' and
   	    ((FL_FATTURA_COMPENSO = 'Y' and
   	     exists(select 1 from compenso
   	     where
   	     compenso.stato_cofi  not in('P','A') and
   	     fattura_passiva.ESERCIZIO_COMPENSO = compenso.esercizio and
   	     fattura_passiva.CDS_COMPENSO       = compenso.cd_cds and
   	     fattura_passiva.UO_COMPENSO				= compenso.cd_unita_organizzativa and
   	     fattura_passiva.PG_COMPENSO			  = compenso.pg_compenso))
        or FL_FATTURA_COMPENSO ='N'))
   and exists(Select 1 from fattura_passiva_riga
		where
     nvl(im_diponibile_nc,0)!=0 and
     				fattura_passiva_riga.stato_cofi  not in('P','A') and
						fattura_passiva_riga.cd_cds  = fattura_passiva.cd_cds  and
          	fattura_passiva_riga.cd_unita_organizzativa  = fattura_passiva.cd_unita_organizzativa and
        		fattura_passiva_riga.esercizio               = fattura_passiva.esercizio     and
        		fattura_passiva_riga.pg_fattura_passiva      = fattura_passiva.pg_fattura_passiva )
   and exists
   (select 1 from modello2_pcc
   where
   modello2_pcc.NUMERO_FATTURA = fattura_passiva.nr_fattura_fornitore AND
   modello2_pcc.data_emissione = fattura_passiva.dt_fattura_fornitore AND
   modello2_pcc.id_fiscale_IVA =substr(decode(nazione.TI_NAZIONE,'E',nvl(anagrafico.partita_iva,anagrafico.codice_fiscale),decode(nazione.cd_iso||anagrafico.partita_iva,nazione.cd_iso,anagrafico.codice_fiscale,nazione.cd_iso||anagrafico.partita_iva)),0,16))
   and not exists
   		 (select 1 from modello3_pcc,nazione n2,anagrafico a2,terzo t2
   				where
   				 a2.cd_anag = t2.cd_anag and
   				 t2.cd_terzo  = fattura_passiva.cd_terzo and
   				 n2.pg_nazione =  a2.pg_nazione_fiscale and
				   modello3_pcc.azione  ='CS' and
				   modello3_pcc.dt_scadenza = fattura_passiva.dt_scadenza and
				   modello3_pcc.numero_fattura = fattura_passiva.nr_fattura_fornitore and
				   modello3_pcc.data_emissione = fattura_passiva.dt_fattura_fornitore and
				   modello3_pcc.id_fiscale_IVA =substr(decode(n2.TI_NAZIONE,'E',nvl(a2.partita_iva,a2.codice_fiscale),decode(n2.cd_iso||a2.partita_iva,n2.cd_iso,a2.codice_fiscale,n2.cd_iso||a2.partita_iva)),0,16))
		order by esercizio,fattura_passiva.cd_unita_organizzativa,pg_fattura_passiva;

   pag testata_pag%rowtype;
   cont testata_cont%rowtype;
   scad testata_scad%rowtype;
   oldStato varchar2(20):=null;
   newStato varchar2(20):=null;
   stato varchar2(20):=null;
   causale varchar2(20):=null;
   c cig_cupMandato%rowtype;
   cOld cig_cupMandato%rowtype:=null;
   i cig_cupImpegno%rowtype;
   Tot_associato_cup number:=0;

begin
/*
-- Contabilizzate
open testata_cont;
loop
fetch testata_cont  into cont;
exit when testata_cont%notfound;
	open cig_cupImpegno(cont.esercizio,cont.cd_cds,cont.cd_unita_organizzativa,nvl(cont.pg_compenso,cont.pg_fattura_passiva),cont.cd_terzo);
  loop
    fetch cig_cupImpegno into i;
        exit when cig_cupImpegno%notfound;
		oldStato:=null;
             begin
  	           select distinct stato_debito into oldStato from modello3_pcc
    	         where
	             azione ='CO' and
	             NUMERO_FATTURA = cont.NR_FATTURA_FORNITORE AND
	   					 data_emissione = cont.DT_FATTURA_FORNITORE AND
	   					 nvl(progr_registrazione,'NA')=nvl(to_char(cont.IDENTIFICATIVO_SDI),'NA') and
	   					 nvl(codice_segnalazione,'OK') ='OK'	 and
	   					 id_fiscale_IVA =substr(decode(cont.TI_NAZIONE,'E',nvl(cont.ana_partita_iva,cont.ana_codice_fiscale),decode(cont.cd_iso||cont.ana_partita_iva,cont.cd_iso,cont.ana_codice_fiscale,cont.cd_iso||cont.ana_partita_iva)),0,16)
	             and lotto =
	             (select max(lotto) from modello3_pcc
	             where
	             azione ='CO' and
	             NUMERO_FATTURA = cont.NR_FATTURA_FORNITORE AND
	   					 data_emissione = cont.DT_FATTURA_FORNITORE AND
	   					 --nvl(progr_registrazione,'NA')=to_char(cont.IDENTIFICATIVO_SDI) and
							 nvl(codice_segnalazione,'OK') ='OK'	 and
	   					 id_fiscale_IVA =substr(decode(cont.TI_NAZIONE,'E',nvl(cont.ana_partita_iva,cont.ana_codice_fiscale),decode(cont.cd_iso||cont.ana_partita_iva,cont.cd_iso,cont.ana_codice_fiscale,cont.cd_iso||cont.ana_partita_iva)),0,16));
	   	       exception when no_data_found then
                null;
                when too_many_rows then
                  dbms_output.put_line('cont.NR_FATTURA_FORNITORE '||cont.NR_FATTURA_FORNITORE||' data '||cont.DT_FATTURA_FORNITORE||' piva '||cont.ana_partita_iva);
             end;
             if(cont.FL_FATTURA_COMPENSO='Y') then
               select stato_liquidazione,causale into stato,causale from compenso
               where
                    cont.ESERCIZIO_COMPENSO = compenso.esercizio and
   	     						cont.CDS_COMPENSO       = compenso.cd_cds and
   	     						cont.UO_COMPENSO				= compenso.cd_unita_organizzativa and
   	     						cont.PG_COMPENSO			  = compenso.pg_compenso;
   	     			newStato:=stato;
             else
               stato:=nvl(cont.stato_liquidazione,'SOSP');
               newStato:=stato;
               causale:=cont.causale;
             end if;
               if(oldStato is not null and substr(oldStato,1,1)!=substr(newStato,1,1)) then
	               if instr(oldStato,'NL')= 0 and instr(oldStato,'NOLIQ') =0 then
	               		--dbms_output.put_line('old 1 '||oldStato);
	               		if (instr(oldStato,'da')>0) then
	                		newStato:=nvl(stato,'SOSP')||'da'||substr(oldStato,instr(oldStato,'da')+2);
	                	else
	                	  if(instr(stato,'NOLIQ') =1 )then
	                			newStato:='NLda'||oldStato;
	                		else
	                		  newStato:=stato||'da'||oldStato;
	                		 end if;
	                	end if;
	                	--dbms_output.put_line('new 1 '||newStato);
	               elsif	 (instr(oldStato,'NL')= 1 or instr(oldStato,'NOLIQ') =1 )then
	               		--dbms_output.put_line('old 2 '||oldStato);
	               		newStato:=nvl(stato,'SOSP')||'daNL';
	               		--dbms_output.put_line('new 2 '||newStato);
	               elsif instr(oldStato,'NL')> 1 then
	               		--dbms_output.put_line('old 3 '||oldStato);
	                	newStato:='NLda'||substr(oldStato,1,instr(oldStato,'da')-1);
	                	--dbms_output.put_line('new 3 '||newStato);
	               end if;
	             end if;

	               		if(length(newStato)>9) then
	               			dbms_output.put_line('fat  '||cont.NR_FATTURA_FORNITORE);
	               			dbms_output.put_line('old  '||oldStato);
	               		  dbms_output.put_line('new  '||newStato);
	               		end if;
             --oldStato:='SOSP';
             if (oldStato is null or substr(oldStato,1,1)!=substr(newStato,1,1)) then
  				   	insert into modello3_pcc(lotto ,
  				   													CODICE_FISCALE_AMM ,
																			CODICE_UFFICIO     ,
																			CODICE_FISCALE     ,
																			ID_FISCALE_IVA     ,
																			AZIONE             ,
																			PROGR_REGISTRAZIONE,
																			NUMERO_FATTURA     ,
																			DATA_EMISSIONE     ,
																			IMPORTO_TOTALE     ,
																			numero_protocollo,
																			data_protocollo,
																			note_rc,
																			data_rifiuto,
																			descrizione_rf,
																			IMPORTO_MOVIMENTO  ,
																			NATURA_SPESA_CO    ,
																			CAPITOLI_SPESA_CO  ,
																			STATO_DEBITO       ,
																			CAUSALE            ,
																			DESCRIZIONE_CO     ,
																			ESTREMI_IMPEGNO_CO ,
																			CODICE_CIG_CO      ,
																			CODICE_CUP_CO      ,
																			comunica_scadenza  ,
 																			importo_scadenza   ,
 																		  dt_scadenza  			 ,
																			IMPORTO_PAGATO     ,
																			NATURA_SPESA_CP    ,
																			CAPITOLI_SPESA_CP  ,
																			ESTREMI_IMPEGNO_CP ,
																			NUMERO_MANDATO     ,
																			DATA_MANDATO       ,
																			ID_FISCALE_IVA_CP  ,
																			CODICE_CIG_CP      ,
																			CODICE_CUP_CP      ,
																			DESCRIZIONE_CP     ,
																			CODICE_SEGNALAZIONE,
																			DESCRIZIONE_SEGNALAZIONE) values
					 (to_date(to_char(sysdate,'dd/mm/yyyy hh24:mi'),'dd/mm/yyyy hh24:mi'),'80054330586',cont.codice_univoco_pcc,
						substr(nvl(cont.ana_codice_fiscale,cont.ana_partita_iva),0,16),
						substr(decode(cont.TI_NAZIONE,'E',nvl(cont.ana_partita_iva,cont.ana_codice_fiscale),decode(cont.cd_iso||cont.ana_partita_iva,cont.cd_iso,cont.ana_codice_fiscale,cont.cd_iso||cont.ana_partita_iva)),0,16),
						'CO',
						nvl(to_char(cont.identificativo_sdi),'NA'),--PROGR_REGISTRAZIONE
						cont.NR_FATTURA_FORNITORE,cont.dt_FATTURA_FORNITORE,
						decode(cont.FL_FATTURA_COMPENSO,'Y',i.imp,cont.im_totale_fattura),
						--cont.im_totale_fattura,
						null, --numero_protocollo
						null, --data_protocollo
						null, --note_rc
						null, --data_rifiuto
						null, --descrizione_rf
						--decode(cont.ti_fattura,'F',i.imp,cont.im_totale_fattura),-- importo_movimento
						--decode(cont.im_totale_fattura-decode(cont.ti_fattura,'F',i.imp,cont.im_totale_fattura),abs(cont.im_totale_fattura-decode(cont.ti_fattura,'F',i.imp,cont.im_totale_fattura)),decode(cont.ti_fattura,'F',i.imp,cont.im_totale_fattura),cont.im_totale_fattura),
						decode(cont.FL_FATTURA_COMPENSO,'Y',i.imp,decode(cont.ti_fattura,'F',i.imp,cont.im_totale_fattura)),
						decode(instr(newStato,'LIQ'),1,i.natura,'NA'), -- NATURA_SPESA_CO
						decode(instr(newStato,'LIQ'),1,substr(i.ds_elemento_voce,1,100),'NA'), -- CAPITOLI_SPESA_CO
						newStato, -- STATO_DEBITO
						decode(newStato,'SOSP','ATTLIQ',causale), -- causale
						substr(i.ds_obbligazione,1,95), -- descrizione_co
						i.esercizio_ori_obbligazione||'/'||i.esercizio_obbligazione||'/'||i.cd_cds_obbligazione||'/'||i.pg_obbligazione, -- estremi impegno
						decode(instr(newStato,'LIQ'),1,nvl(i.cd_cig,'NA'),'NA'), -- codice_cig_co
						decode(instr(newStato,'LIQ'),1,nvl(i.cd_cup,'NA'),'NA'), -- codice_cig_co
						null, null,null, -- CS
						null,null,-- CP
						null, -- capitolo
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,null);
				end if;
end loop;
close cig_cupImpegno;
end loop;
close testata_cont;
*/
open testata_pag;
loop
fetch testata_pag  into pag;
exit when testata_pag%notfound;
	--dbms_output.put_line(pag.identificativo_sdi || pag.esercizio ||pag.cd_cds ||pag.cd_unita_organizzativa ||nvl(pag.pg_compenso,pag.pg_fattura_passiva) ||pag.cd_terzo ||pag.dt_FATTURA_FORNITORE ||pag.NR_FATTURA_FORNITORE);
  Tot_associato_cup:=0;
  cOld:=null;
  open cig_cupMandato(pag.esercizio,pag.cd_cds,pag.cd_unita_organizzativa,nvl(pag.pg_compenso,pag.pg_fattura_passiva),pag.cd_terzo,pag.dt_FATTURA_FORNITORE,pag.NR_FATTURA_FORNITORE);
  loop
    fetch cig_cupMandato into c;
        exit when cig_cupMandato%notfound;
        --dbms_output.put_line('LOOP '||C.TOT_IMP);
             	if(cOld.esercizio_ori_obbligazione is not null and
             	(	cOld.esercizio_ori_obbligazione!=c.esercizio_ori_obbligazione or
						  	cOld.esercizio_obbligazione			!= c.esercizio_obbligazione or
						  	cOld.cd_cds_obbligazione				!= c.cd_cds_obbligazione or
								cOld.pg_obbligazione						!= c.pg_obbligazione or
								cOld.PG_OBBLIGAZIONE_SCADENZARIO!= c.PG_OBBLIGAZIONE_SCADENZARIO or
								cOld.pg_mandato									!= c.pg_mandato)) then
							if (cOld.imp>Tot_associato_cup and Tot_associato_cup!=0 and pag.ti_fattura ='F' ) then
							dbms_output.put_line('insert 1');
								insert into modello3_pcc(lotto,
					   													CODICE_FISCALE_AMM ,
																			CODICE_UFFICIO     ,
																			CODICE_FISCALE     ,
																			ID_FISCALE_IVA     ,
																			AZIONE             ,
																			PROGR_REGISTRAZIONE,
																			NUMERO_FATTURA     ,
																			DATA_EMISSIONE     ,
																			IMPORTO_TOTALE     ,
																			numero_protocollo,
																			data_protocollo,
																			note_rc,
																			data_rifiuto,
																			descrizione_rf,
																			IMPORTO_MOVIMENTO  ,
																			NATURA_SPESA_CO    ,
																			CAPITOLI_SPESA_CO  ,
																			STATO_DEBITO       ,
																			CAUSALE            ,
																			DESCRIZIONE_CO     ,
																			ESTREMI_IMPEGNO_CO ,
																			CODICE_CIG_CO      ,
																			CODICE_CUP_CO      ,
																			comunica_scadenza  ,
 																			importo_scadenza   ,
 																		  dt_scadenza  			 ,
																			IMPORTO_PAGATO     ,
																			NATURA_SPESA_CP    ,
																			CAPITOLI_SPESA_CP  ,
																			ESTREMI_IMPEGNO_CP ,
																			NUMERO_MANDATO     ,
																			DATA_MANDATO       ,
																			ID_FISCALE_IVA_CP  ,
																			CODICE_CIG_CP      ,
																			CODICE_CUP_CP      ,
																			DESCRIZIONE_CP     ,
																			CODICE_SEGNALAZIONE,
																			DESCRIZIONE_SEGNALAZIONE) values
					 (to_date(to_char(sysdate,'dd/mm/yyyy hh24:mi'),'dd/mm/yyyy hh24:mi'),'80054330586',pag.codice_univoco_pcc,
						substr(nvl(pag.ana_codice_fiscale,pag.ana_partita_iva),0,16),
						substr(decode(pag.TI_NAZIONE,'E',nvl(pag.ana_partita_iva,pag.ana_codice_fiscale),decode(pag.cd_iso||pag.ana_partita_iva,pag.cd_iso,pag.ana_codice_fiscale,pag.cd_iso||pag.ana_partita_iva)),0,16),
						'CP',
						nvl(to_char(pag.identificativo_sdi),'NA'),--PROGR_REGISTRAZIONE
						pag.NR_FATTURA_FORNITORE,pag.dt_FATTURA_FORNITORE,
						decode(pag.FL_FATTURA_COMPENSO,'Y',cOld.imp,pag.im_totale_fattura),
						--pag.im_totale_fattura,
						null, --numero_protocollo
						null, --data_protocollo
						null, --note_rc
						null, --data_rifiuto
						null, --descrizione_rf
						null, -- importo_movimento
						null, -- NATURA_SPESA_CO
						null, -- CAPITOLI_SPESA_CO
						null, -- STATO_DEBITO
						null, -- causale
						null, -- descrizione_co
						null, -- estremi impegno
						null, -- codice_cig_co
						null, -- codice_cup_co
						null, null,null, -- CS
						--decode (pag.split,'N',(cOld.imp-Tot_associato_cup),round(((cOld.imp-Tot_associato_cup)*pag.tot_imp)/(pag.tot_imp+pag.tot_iva),2)),
						decode (pag.split,'N',(cOld.imp-Tot_associato_cup),decode(pag.TI_ISTITUZ_COMMERC,'C',(cOld.imp-Tot_associato_cup) ,round(((cOld.imp-Tot_associato_cup)*cOld.tot_imp)/(cOld.tot_doc),2))),
						cOld.natura,
						substr(cOld.ds_elemento_voce,1,100), -- capitolo
						cOld.esercizio_ori_obbligazione||'/'||cOld.esercizio_obbligazione||'/'||cOld.cd_cds_obbligazione||'/'||cOld.pg_obbligazione,
						cOld.esercizio||'/'||cOld.cd_cds||'/'||cOld.pg_mandato,
						cOld.dt_emissione,
						decode(pag.STATO_PAGAMENTO_FONDO_ECO,'N',substr(decode(cOld.TI_NAZIONE,'E',nvl(cOld.partita_iva,cOld.codice_fiscale),decode(cOld.cd_iso||cOld.partita_iva,cOld.cd_iso,cOld.codice_fiscale,cOld.cd_iso||cOld.partita_iva)),0,16),substr(decode(pag.TI_NAZIONE,'E',nvl(pag.ana_partita_iva,pag.ana_codice_fiscale),decode(pag.cd_iso||pag.ana_partita_iva,pag.cd_iso,pag.ana_codice_fiscale,pag.cd_iso||pag.ana_partita_iva)),0,16)),
						nvl(cOld.cd_cig,'NA'),
						'NA', --cup
						substr(cOld.ds_mandato,1,95),
						null,null);
				end if;
				Tot_associato_cup:=0;
			end if;
			--dbms_output.put_line('insert 2 imp_cup '||c.imp_cup||' mandato '||c.imp||' imponibile '||pag.tot_imp||' fat '||pag.im_totale_fattura||' tot_imp '||c.tot_imp||' tot_doc '||c.tot_doc);
					  if ( nvl(c.imp_cup ,0)!= 0 or nvl(c.imp ,0)!= 0) then
					   insert into modello3_pcc(lotto,
					   													CODICE_FISCALE_AMM ,
																			CODICE_UFFICIO     ,
																			CODICE_FISCALE     ,
																			ID_FISCALE_IVA     ,
																			AZIONE             ,
																			PROGR_REGISTRAZIONE,
																			NUMERO_FATTURA     ,
																			DATA_EMISSIONE     ,
																			IMPORTO_TOTALE     ,
																			numero_protocollo,
																			data_protocollo,
																			note_rc,
																			data_rifiuto,
																			descrizione_rf,
																			IMPORTO_MOVIMENTO  ,
																			NATURA_SPESA_CO    ,
																			CAPITOLI_SPESA_CO  ,
																			STATO_DEBITO       ,
																			CAUSALE            ,
																			DESCRIZIONE_CO     ,
																			ESTREMI_IMPEGNO_CO ,
																			CODICE_CIG_CO      ,
																			CODICE_CUP_CO      ,
																			comunica_scadenza  ,
 																			importo_scadenza   ,
 																		  dt_scadenza  			 ,
																			IMPORTO_PAGATO     ,
																			NATURA_SPESA_CP    ,
																			CAPITOLI_SPESA_CP  ,
																			ESTREMI_IMPEGNO_CP ,
																			NUMERO_MANDATO     ,
																			DATA_MANDATO       ,
																			ID_FISCALE_IVA_CP  ,
																			CODICE_CIG_CP      ,
																			CODICE_CUP_CP      ,
																			DESCRIZIONE_CP     ,
																			CODICE_SEGNALAZIONE,
																			DESCRIZIONE_SEGNALAZIONE) values
					 (to_date(to_char(sysdate,'dd/mm/yyyy hh24:mi'),'dd/mm/yyyy hh24:mi'),'80054330586',pag.codice_univoco_pcc,
						substr(nvl(pag.ana_codice_fiscale,pag.ana_partita_iva),0,16),
						substr(decode(pag.TI_NAZIONE,'E',nvl(pag.ana_partita_iva,pag.ana_codice_fiscale),decode(pag.cd_iso||pag.ana_partita_iva,pag.cd_iso,pag.ana_codice_fiscale,pag.cd_iso||pag.ana_partita_iva)),0,16),
						'CP',
						nvl(to_char(pag.identificativo_sdi),'NA'),--PROGR_REGISTRAZIONE
						pag.NR_FATTURA_FORNITORE,pag.dt_FATTURA_FORNITORE,
						decode(pag.FL_FATTURA_COMPENSO,'Y',c.imp,pag.im_totale_fattura),
						--pag.im_totale_fattura,
						null, --numero_protocollo
						null, --data_protocollo
						null, --note_rc
						null, --data_rifiuto
						null, --descrizione_rf
						null, -- importo_movimento
						null, -- NATURA_SPESA_CO
						null, -- CAPITOLI_SPESA_CO
						null, -- STATO_DEBITO
						null, -- causale
						null, -- descrizione_co
						null, -- estremi impegno
						null, -- codice_cig_co
						null, -- codice_cup_co
						null, null,null, -- CS
						round(decode(pag.split,'N',decode(c.imp_cup,0,c.imp,c.imp_cup),decode(pag.TI_ISTITUZ_COMMERC,'C', decode(c.imp_cup,0,c.imp,c.imp_cup),decode(c.imp_cup,0,c.imp,c.imp_cup)*c.tot_imp/c.tot_doc)),2),
						--round(decode(pag.split,'N',decode(pag.ti_fattura,'F',decode(c.imp_cup,0,c.imp,c.imp_cup),pag.im_totale_fattura),decode(pag.TI_ISTITUZ_COMMERC,'C', decode(pag.ti_fattura,'F',decode(c.imp_cup,0,c.imp,c.imp_cup),pag.im_totale_fattura) ,decode(pag.ti_fattura,'F',decode(c.imp_cup,0,c.imp,c.imp_cup),pag.im_totale_fattura)*c.tot_imp/c.tot_doc)),2),
						--round(decode(pag.split,'N',decode(pag.ti_fattura,'F',decode(c.imp_cup,0,c.imp,c.imp_cup),pag.im_totale_fattura),(decode(pag.ti_fattura,'F',decode(c.imp_cup,0,c.imp,c.imp_cup),pag.im_totale_fattura)*pag.tot_imp/(pag.tot_imp+pag.tot_iva))),2),
						--decode(c.imp_cup,0,c.imp,c.imp_cup),
						c.natura,
						substr(c.ds_elemento_voce,1,100), -- capitolo
						c.esercizio_ori_obbligazione||'/'||c.esercizio_obbligazione||'/'||c.cd_cds_obbligazione||'/'||c.pg_obbligazione,
						c.esercizio||'/'||c.cd_cds||'/'||c.pg_mandato,
						c.dt_emissione,
						decode(pag.STATO_PAGAMENTO_FONDO_ECO,'N',substr(decode(c.TI_NAZIONE,'E',nvl(c.partita_iva,c.codice_fiscale),decode(c.cd_iso||c.partita_iva,c.cd_iso,c.codice_fiscale,c.cd_iso||c.partita_iva)),0,16),substr(decode(pag.TI_NAZIONE,'E',nvl(pag.ana_partita_iva,pag.ana_codice_fiscale),decode(pag.cd_iso||pag.ana_partita_iva,pag.cd_iso,pag.ana_codice_fiscale,pag.cd_iso||pag.ana_partita_iva)),0,16)),
						nvl(c.cd_cig,'NA'),
						nvl(c.cd_cup,'NA'),
						substr(c.ds_mandato,1,95),
						null,null);
						cOld:=c;
						Tot_associato_cup:=Tot_associato_cup+c.imp_cup;
					end if;
end loop;
	   					if (c.imp>Tot_associato_cup and Tot_associato_cup!=0 and pag.ti_fattura ='F' ) then
	   					dbms_output.put_line('insert 3');
			 					insert into modello3_pcc(lotto,
					   													CODICE_FISCALE_AMM ,
																			CODICE_UFFICIO     ,
																			CODICE_FISCALE     ,
																			ID_FISCALE_IVA     ,
																			AZIONE             ,
																			PROGR_REGISTRAZIONE,
																			NUMERO_FATTURA     ,
																			DATA_EMISSIONE     ,
																			IMPORTO_TOTALE     ,
																			numero_protocollo,
																			data_protocollo,
																			note_rc,
																			data_rifiuto,
																			descrizione_rf,
																			IMPORTO_MOVIMENTO  ,
																			NATURA_SPESA_CO    ,
																			CAPITOLI_SPESA_CO  ,
																			STATO_DEBITO       ,
																			CAUSALE            ,
																			DESCRIZIONE_CO     ,
																			ESTREMI_IMPEGNO_CO ,
																			CODICE_CIG_CO      ,
																			CODICE_CUP_CO      ,
																			comunica_scadenza  ,
 																			importo_scadenza   ,
 																		  dt_scadenza  			 ,
																			IMPORTO_PAGATO     ,
																			NATURA_SPESA_CP    ,
																			CAPITOLI_SPESA_CP  ,
																			ESTREMI_IMPEGNO_CP ,
																			NUMERO_MANDATO     ,
																			DATA_MANDATO       ,
																			ID_FISCALE_IVA_CP  ,
																			CODICE_CIG_CP      ,
																			CODICE_CUP_CP      ,
																			DESCRIZIONE_CP     ,
																			CODICE_SEGNALAZIONE,
																			DESCRIZIONE_SEGNALAZIONE) values
					 (to_date(to_char(sysdate,'dd/mm/yyyy hh24:mi'),'dd/mm/yyyy hh24:mi'),'80054330586',pag.codice_univoco_pcc,
						substr(nvl(pag.ana_codice_fiscale,pag.ana_partita_iva),0,16),
						substr(decode(pag.TI_NAZIONE,'E',nvl(pag.ana_partita_iva,pag.ana_codice_fiscale),decode(pag.cd_iso||pag.ana_partita_iva,pag.cd_iso,pag.ana_codice_fiscale,pag.cd_iso||pag.ana_partita_iva)),0,16),
						'CP',
						nvl(to_char(pag.identificativo_sdi),'NA'),--PROGR_REGISTRAZIONE
						pag.NR_FATTURA_FORNITORE,pag.dt_FATTURA_FORNITORE,
						decode(pag.FL_FATTURA_COMPENSO,'Y',c.imp,pag.im_totale_fattura),
						--pag.im_totale_fattura,
						null, --numero_protocollo
						null, --data_protocollo
						null, --note_rc
						null, --data_rifiuto
						null, --descrizione_rf
						null, -- importo_movimento
						null, -- NATURA_SPESA_CO
						null, -- CAPITOLI_SPESA_CO
						null, -- STATO_DEBITO
						null, -- causale
						null, -- descrizione_co
						null, -- estremi impegno
						null, -- codice_cig_co
						null, -- codice_cup_co
						null, null,null, -- CS
						--decode (pag.split,'N',(c.imp-Tot_associato_cup),round(((c.imp-Tot_associato_cup)*pag.tot_imp)/(pag.tot_imp+pag.tot_iva),2)),
						decode (pag.split,'N',(c.imp-Tot_associato_cup),decode(pag.TI_ISTITUZ_COMMERC,'C',(c.imp-Tot_associato_cup) ,round(((c.imp-Tot_associato_cup)*c.tot_imp)/(c.tot_doc),2))),
						c.natura,
						substr(c.ds_elemento_voce,1,100), -- capitolo
						c.esercizio_ori_obbligazione||'/'||c.esercizio_obbligazione||'/'||c.cd_cds_obbligazione||'/'||c.pg_obbligazione,
						c.esercizio||'/'||c.cd_cds||'/'||c.pg_mandato,
						c.dt_emissione,
						decode(pag.STATO_PAGAMENTO_FONDO_ECO,'N',substr(decode(c.TI_NAZIONE,'E',nvl(c.partita_iva,c.codice_fiscale),decode(c.cd_iso||c.partita_iva,c.cd_iso,c.codice_fiscale,c.cd_iso||c.partita_iva)),0,16),substr(decode(pag.TI_NAZIONE,'E',nvl(pag.ana_partita_iva,pag.ana_codice_fiscale),decode(pag.cd_iso||pag.ana_partita_iva,pag.cd_iso,pag.ana_codice_fiscale,pag.cd_iso||pag.ana_partita_iva)),0,16)),
						nvl(c.cd_cig,'NA'),
						'NA', --cup
						substr(c.ds_mandato,1,95),
						null,null);
				end if;
close cig_cupMandato;

end loop;
close testata_pag;

-- SCADUTE
/*
open testata_scad;
loop
fetch testata_scad  into scad;
exit when testata_scad%notfound;
					   	insert into modello3_pcc(lotto ,
  				   													CODICE_FISCALE_AMM ,
																			CODICE_UFFICIO     ,
																			CODICE_FISCALE     ,
																			ID_FISCALE_IVA     ,
																			AZIONE             ,
																			PROGR_REGISTRAZIONE,
																			NUMERO_FATTURA     ,
																			DATA_EMISSIONE     ,
																			IMPORTO_TOTALE     ,
																			numero_protocollo,
																			data_protocollo,
																			note_rc,
																			data_rifiuto,
																			descrizione_rf,
																			IMPORTO_MOVIMENTO  ,
																			NATURA_SPESA_CO    ,
																			CAPITOLI_SPESA_CO  ,
																			STATO_DEBITO       ,
																			CAUSALE            ,
																			DESCRIZIONE_CO     ,
																			ESTREMI_IMPEGNO_CO ,
																			CODICE_CIG_CO      ,
																			CODICE_CUP_CO      ,
																			comunica_scadenza  ,
 																			importo_scadenza   ,
 																		  dt_scadenza  			 ,
																			IMPORTO_PAGATO     ,
																			NATURA_SPESA_CP    ,
																			CAPITOLI_SPESA_CP  ,
																			ESTREMI_IMPEGNO_CP ,
																			NUMERO_MANDATO     ,
																			DATA_MANDATO       ,
																			ID_FISCALE_IVA_CP  ,
																			CODICE_CIG_CP      ,
																			CODICE_CUP_CP      ,
																			DESCRIZIONE_CP     ,
																			CODICE_SEGNALAZIONE,
																			DESCRIZIONE_SEGNALAZIONE) values
					 (to_date(to_char(sysdate,'dd/mm/yyyy hh24:mi'),'dd/mm/yyyy hh24:mi'),'80054330586',scad.codice_univoco_pcc,
						substr(nvl(scad.codice_fiscale,scad.partita_iva),0,16),
						substr(decode(scad.TI_NAZIONE,'E',nvl(scad.partita_iva,scad.codice_fiscale),decode(scad.cd_iso||scad.partita_iva,scad.cd_iso,scad.codice_fiscale,scad.cd_iso||scad.partita_iva)),0,16),
						'CS',
						nvl(to_char(scad.identificativo_sdi),'NA'),--PROGR_REGISTRAZIONE
						scad.NR_FATTURA_FORNITORE,scad.dt_FATTURA_FORNITORE,
						scad.im_totale_fattura,
						null, --numero_protocollo
						null, --data_protocollo
						null, --note_rc
						null, --data_rifiuto
						null, --descrizione_rf
						null,-- importo_movimento
						null,-- NATURA_SPESA_CO
						null, -- CAPITOLI_SPESA_CO
						null, -- STATO_DEBITO
						null, -- causale
						null, -- descrizione_co
						null, -- estremi impegno
						null, -- codice_cig_co
						null, -- codice_cup_co
						'SI', scad.im_totale_fattura,scad.dt_scadenza, -- CS
						null,null,-- CP
						null, -- capitolo
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,null);
end loop;
close testata_scad;
*/
commit;
end;
end;
/


