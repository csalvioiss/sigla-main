/*
 * Created by BulkGenerator 2.0 [07/12/2009]
 * Date 21/09/2017
 */
package it.cnr.contab.ordmag.magazzino.bulk;
import java.sql.Connection;
import java.util.Optional;

import it.cnr.contab.ordmag.anag00.MagazzinoBulk;
import it.cnr.contab.ordmag.anag00.MagazzinoHome;
import it.cnr.contab.ordmag.anag00.TipoMovimentoMagAzBulk;
import it.cnr.contab.ordmag.anag00.TipoMovimentoMagAzHome;
import it.cnr.contab.ordmag.anag00.TipoMovimentoMagBulk;
import it.cnr.contab.ordmag.anag00.TipoMovimentoMagHome;
import it.cnr.contab.ordmag.anag00.TipoOperazioneOrdBulk;
import it.cnr.contab.ordmag.anag00.UnitaOperativaOrdBulk;
import it.cnr.contab.ordmag.anag00.UnitaOperativaOrdHome;
import it.cnr.jada.UserContext;
import it.cnr.jada.bulk.BulkHome;
import it.cnr.jada.comp.ComponentException;
import it.cnr.jada.persistency.PersistencyException;
import it.cnr.jada.persistency.PersistentCache;
import it.cnr.jada.persistency.sql.CompoundFindClause;
import it.cnr.jada.persistency.sql.FindClause;
import it.cnr.jada.persistency.sql.SQLBuilder;

public class ScaricoMagazzinoHome extends BulkHome {
	private static final long serialVersionUID = 1L;

	public ScaricoMagazzinoHome(Connection conn) {
		super(ScaricoMagazzinoBulk.class, conn);
	}
	
	public ScaricoMagazzinoHome(Connection conn, PersistentCache persistentCache) {
		super(ScaricoMagazzinoBulk.class, conn, persistentCache);
	}

	public SQLBuilder selectUnitaOperativaAbilitataByClause(UserContext userContext, ScaricoMagazzinoBulk bulk, UnitaOperativaOrdHome unitaOperativaHome, UnitaOperativaOrdBulk unitaOperativaBulk, 
			CompoundFindClause compoundfindclause) throws PersistencyException{
		return unitaOperativaHome.selectUnitaOperativeAbilitateByClause(userContext, compoundfindclause, TipoOperazioneOrdBulk.OPERAZIONE_MAGAZZINO);
	}
	
	public SQLBuilder selectMagazzinoAbilitatoByClause(UserContext userContext, ScaricoMagazzinoBulk bulk, MagazzinoHome magazzinoHome, MagazzinoBulk magazzinoBulk,  
			CompoundFindClause compoundfindclause) throws PersistencyException, ComponentException {
		return magazzinoHome.selectMagazziniAbilitatiByClause(userContext, bulk.getUnitaOperativaAbilitata(), TipoOperazioneOrdBulk.OPERAZIONE_MAGAZZINO, compoundfindclause);
	}

	public SQLBuilder selectTipoMovimentoMagByClause(UserContext userContext, ScaricoMagazzinoBulk bulk, TipoMovimentoMagHome tipoMovimentoMagHome, TipoMovimentoMagBulk tipoMovimentoMagBulk,  
			CompoundFindClause compoundfindclause) throws PersistencyException, ComponentException {
		CompoundFindClause clause = new CompoundFindClause();
		Optional.ofNullable(compoundfindclause).ifPresent(cfc->clause.addChild(cfc));
		clause.addClause(FindClause.AND, "tipo", SQLBuilder.EQUALS, TipoMovimentoMagBulk.SCARICO_MANUALE);
		SQLBuilder sqlBuilder = tipoMovimentoMagHome.selectByClause(clause);
		
		TipoMovimentoMagAzHome tipoAzhome = (TipoMovimentoMagAzHome)getHomeCache().getHome(TipoMovimentoMagAzBulk.class);
		SQLBuilder sqlExists = tipoAzhome.createSQLBuilder();
		sqlExists.addSQLJoin("TIPO_MOVIMENTO_MAG_AZ.CD_CDS", SQLBuilder.EQUALS, "TIPO_MOVIMENTO_MAG.CD_CDS");
		sqlExists.addSQLJoin("TIPO_MOVIMENTO_MAG_AZ.CD_TIPO_MOVIMENTO", SQLBuilder.EQUALS, "TIPO_MOVIMENTO_MAG.CD_TIPO_MOVIMENTO");
		
		sqlBuilder.addSQLExistsClause(FindClause.AND, sqlExists);
		return sqlBuilder;
	}
}