/*
 * Copyright (C) 2019  Consiglio Nazionale delle Ricerche
 *
 *     This program is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU Affero General Public License as
 *     published by the Free Software Foundation, either version 3 of the
 *     License, or (at your option) any later version.
 *
 *     This program is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU Affero General Public License for more details.
 *
 *     You should have received a copy of the GNU Affero General Public License
 *     along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

/*
* Created by Generator 1.0
* Date 19/10/2005
*/
package it.cnr.contab.prevent01.bulk;
import it.cnr.contab.config00.sto.bulk.CdrBulk;
import it.cnr.contab.config00.sto.bulk.Unita_organizzativa_enteBulk;
import it.cnr.contab.progettiric00.core.bulk.Progetto_sipBulk;
import it.cnr.contab.progettiric00.core.bulk.Progetto_sipHome;
import it.cnr.contab.utenze00.bp.CNRUserContext;
import it.cnr.jada.UserContext;
import it.cnr.jada.bulk.BulkHome;
import it.cnr.jada.persistency.IntrospectionException;
import it.cnr.jada.persistency.PersistencyException;
import it.cnr.jada.persistency.PersistentCache;
import it.cnr.jada.persistency.sql.FindClause;
import it.cnr.jada.persistency.sql.PersistentHome;
import it.cnr.jada.persistency.sql.SQLBuilder;

import java.sql.SQLException;

public class Pdg_esercizioHome extends BulkHome {
	public Pdg_esercizioHome(java.sql.Connection conn) {
		super(Pdg_esercizioBulk.class, conn);
	}
	public Pdg_esercizioHome(java.sql.Connection conn, PersistentCache persistentCache) {
		super(Pdg_esercizioBulk.class, conn, persistentCache);
	}

	public Pdg_esercizioBulk findEsercizioPrecedente( Pdg_esercizioBulk esercizioCorrente ) throws IntrospectionException, PersistencyException
	{
		Pdg_esercizioBulk esercizioPrecente = (Pdg_esercizioBulk)findByPrimaryKey( new Pdg_esercizioKey( new Integer(esercizioCorrente.getEsercizio().intValue() - 1), esercizioCorrente.getCd_centro_responsabilita()));
		return esercizioPrecente;
	
	}
	public Pdg_esercizioBulk findEsercizioSuccessivo( Pdg_esercizioBulk esercizioCorrente ) throws IntrospectionException, PersistencyException
	{
		return (Pdg_esercizioBulk)findByPrimaryKey( new Pdg_esercizioKey( new Integer( esercizioCorrente.getEsercizio().intValue() + 1), esercizioCorrente.getCd_centro_responsabilita()));
	
	}

	/**
	 * Indica che tutti i CDR utilizzatori del progetto abbiano chiuso i piani di gestione
	 *
	 * @param esercizio esercizio di bilancio
	 * @param pgProgetto identificativo del progetto
	 * @return true se tutti i CDR utilizzatori del progetto abbiano chiuso i piani di gestione
	 * @throws SQLException
	 */
	public boolean isAllPdgpProgettoChiusi(Integer esercizio, Integer pgProgetto) throws SQLException {
		SQLBuilder sqlPdgEsercizio = this.createSQLBuilder();
		sqlPdgEsercizio.addClause(FindClause.AND,"esercizio",SQLBuilder.EQUALS,esercizio);
		sqlPdgEsercizio.addClause(FindClause.AND,"stato",SQLBuilder.NOT_EQUALS,Pdg_esercizioBulk.STATO_CHIUSURA_GESTIONALE_CDR);
		sqlPdgEsercizio.addTableToHeader("PDG_MODULO");
		sqlPdgEsercizio.addSQLJoin("PDG_ESERCIZIO.ESERCIZIO", "PDG_MODULO.ESERCIZIO");
		sqlPdgEsercizio.addSQLJoin("PDG_ESERCIZIO.CD_CENTRO_RESPONSABILITA", "PDG_MODULO.CD_CENTRO_RESPONSABILITA");
		sqlPdgEsercizio.addSQLClause(FindClause.AND,"PDG_MODULO.PG_PROGETTO",SQLBuilder.EQUALS,pgProgetto);

		return !sqlPdgEsercizio.executeExistsQuery(getConnection());
	}
}