CREATE OR REPLACE TRIGGER AU_L_CONFIGURAZIONE_CNR AFTER  UPDATE  ON CONFIGURAZIONE_CNR for each row
DECLARE
lCONFIGURAZIONE_CNR L_CONFIGURAZIONE_CNR%rowtype;
lTbName varchar2(30);
lUser varchar2(30);
lLogRegistry log_registry%rowtype;
lPG_STORICO number;
begin
--
-- Trigger attivato su  UPDATE  di record da CONFIGURAZIONE_CNR
--
-- Date: 19/03/2004
-- Version: 1.0
--
-- Dependency:CLCONFIGURAZIONE_CNR
--
-- History:
--
-- Date: 19/03/2004
-- Version: 1.0
-- Creazione
--
-- Body:
  select user into lUser from dual;
  lTbName :='CONFIGURAZIONE_CNR';
  select nvl(max(PG_STORICO_),0) into lPG_STORICO from L_CONFIGURAZIONE_CNR;
  lCONFIGURAZIONE_CNR.ESERCIZIO := :OLD.ESERCIZIO;
  lCONFIGURAZIONE_CNR.CD_UNITA_FUNZIONALE := :OLD.CD_UNITA_FUNZIONALE;
  lCONFIGURAZIONE_CNR.CD_CHIAVE_PRIMARIA := :OLD.CD_CHIAVE_PRIMARIA;
  lCONFIGURAZIONE_CNR.CD_CHIAVE_SECONDARIA := :OLD.CD_CHIAVE_SECONDARIA;
  lCONFIGURAZIONE_CNR.VAL01 := :OLD.VAL01;
  lCONFIGURAZIONE_CNR.VAL02 := :OLD.VAL02;
  lCONFIGURAZIONE_CNR.VAL03 := :OLD.VAL03;
  lCONFIGURAZIONE_CNR.VAL04 := :OLD.VAL04;
  lCONFIGURAZIONE_CNR.IM01 := :OLD.IM01;
  lCONFIGURAZIONE_CNR.IM02 := :OLD.IM02;
  lCONFIGURAZIONE_CNR.DT01 := :OLD.DT01;
  lCONFIGURAZIONE_CNR.DT02 := :OLD.DT02;
  lCONFIGURAZIONE_CNR.DACR := :OLD.DACR;
  lCONFIGURAZIONE_CNR.UTCR := :OLD.UTCR;
  lCONFIGURAZIONE_CNR.DUVA := :OLD.DUVA;
  lCONFIGURAZIONE_CNR.UTUV := :OLD.UTUV;
  lCONFIGURAZIONE_CNR.PG_VER_REC := :OLD.PG_VER_REC;
  lCONFIGURAZIONE_CNR.PG_STORICO_ := lPG_STORICO + 1;
  lCONFIGURAZIONE_CNR.USER_ := lUser;
  lCONFIGURAZIONE_CNR.DT_TRANSACTION_ :=  sysdate;
  lCONFIGURAZIONE_CNR.ACTION_ := 'U';
  CLCONFIGURAZIONE_CNR.insertRiga(lTbName,lCONFIGURAZIONE_CNR);
  CLCONFIGURAZIONE_CNR.updateRegistry(lTbName,'U',lUser);
END;
/

