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
* Date 15/02/2006
*/
package it.cnr.contab.varstanz00.bulk;

import it.cnr.jada.persistency.Keyed;

public class Var_stanz_resBase extends Var_stanz_resKey implements Keyed {
//    CD_CDS VARCHAR(30) NOT NULL
	private java.lang.String cd_cds;
 
//    CD_CENTRO_RESPONSABILITA VARCHAR(30) NOT NULL
	private java.lang.String cd_centro_responsabilita;
 
//    DT_APERTURA TIMESTAMP(7) NOT NULL
	private java.sql.Timestamp dt_apertura;
 
//    DS_DELIBERA VARCHAR(300)
	private java.lang.String ds_delibera;
 
//    DS_VARIAZIONE VARCHAR(300) NOT NULL
	private java.lang.String ds_variazione;
 
//    DT_CHIUSURA TIMESTAMP(7)
	private java.sql.Timestamp dt_chiusura;
 
//    DT_APPROVAZIONE TIMESTAMP(7)
	private java.sql.Timestamp dt_approvazione;
 
//    DT_ANNULLAMENTO TIMESTAMP(7)
	private java.sql.Timestamp dt_annullamento;
 
//    DS_AGGIUNTIVA VARCHAR(300)
	private java.lang.String ds_aggiuntiva;
 
//    STATO VARCHAR(3) NOT NULL
	private java.lang.String stato;
 
//    TIPOLOGIA VARCHAR(3) NOT NULL
	private java.lang.String tipologia;

//	TIPOLOGIA VARCHAR(3) NOT NULL
	private java.lang.String tipologia_fin;

//	ESERCIZIO_RES NUMBER(4) NOT NULL
 	private Integer esercizio_residuo;
 	
	// FL_PERENZIONE CHAR(1) NOT NULL
	private java.lang.Boolean fl_perenzione;

	// TI_MOTIVAZIONE_VARIAZIONE VARCHAR2(10)
	private java.lang.String tiMotivazioneVariazione;

	// ID_MATRICOLA VARCHAR2(10)
	private java.lang.Long idMatricola;

	// ID_BANDO VARCHAR2(30)
	private java.lang.String idBando;
	
	// DS_CAUSALE VARCHAR2(50)
	private java.lang.String ds_causale;

	// PG_PROGETTO_RIMODULAZIONE NUMBER (10) NULL
	private java.lang.Integer pg_progetto_rimodulazione;

	// PG_RIMODULAZIONE NUMBER (10) NULL
	private java.lang.Integer pg_rimodulazione;
	
	public Var_stanz_resBase() {
		super();
	}
	public Var_stanz_resBase(java.lang.Integer esercizio, java.lang.Long pg_variazione) {
		super(esercizio, pg_variazione);
	}
	public java.lang.String getCd_cds () {
		return cd_cds;
	}
	public void setCd_cds(java.lang.String cd_cds)  {
		this.cd_cds=cd_cds;
	}
	public java.lang.String getCd_centro_responsabilita () {
		return cd_centro_responsabilita;
	}
	public void setCd_centro_responsabilita(java.lang.String cd_centro_responsabilita)  {
		this.cd_centro_responsabilita=cd_centro_responsabilita;
	}
	public java.sql.Timestamp getDt_apertura () {
		return dt_apertura;
	}
	public void setDt_apertura(java.sql.Timestamp dt_apertura)  {
		this.dt_apertura=dt_apertura;
	}
	public java.lang.String getDs_delibera () {
		return ds_delibera;
	}
	public void setDs_delibera(java.lang.String ds_delibera)  {
		this.ds_delibera=ds_delibera;
	}
	public java.lang.String getDs_variazione () {
		return ds_variazione;
	}
	public void setDs_variazione(java.lang.String ds_variazione)  {
		this.ds_variazione=ds_variazione;
	}
	public java.sql.Timestamp getDt_chiusura () {
		return dt_chiusura;
	}
	public void setDt_chiusura(java.sql.Timestamp dt_chiusura)  {
		this.dt_chiusura=dt_chiusura;
	}
	public java.sql.Timestamp getDt_approvazione () {
		return dt_approvazione;
	}
	public void setDt_approvazione(java.sql.Timestamp dt_approvazione)  {
		this.dt_approvazione=dt_approvazione;
	}
	public java.sql.Timestamp getDt_annullamento () {
		return dt_annullamento;
	}
	public void setDt_annullamento(java.sql.Timestamp dt_annullamento)  {
		this.dt_annullamento=dt_annullamento;
	}
	public java.lang.String getDs_aggiuntiva () {
		return ds_aggiuntiva;
	}
	public void setDs_aggiuntiva(java.lang.String ds_aggiuntiva)  {
		this.ds_aggiuntiva=ds_aggiuntiva;
	}
	public java.lang.String getStato () {
		return stato;
	}
	public void setStato(java.lang.String stato)  {
		this.stato=stato;
	}
	public java.lang.String getTipologia () {
		return tipologia;
	}
	public void setTipologia(java.lang.String tipologia)  {
		this.tipologia=tipologia;
	}
	/**
	 * @return
	 */
	public java.lang.String getTipologia_fin() {
		return tipologia_fin;
	}
	
	/**
	 * @param string
	 */
	public void setTipologia_fin(java.lang.String string) {
		tipologia_fin = string;
	}
	
	/**
	 * @return
	 */
	public Integer getEsercizio_residuo() {
		return esercizio_residuo;
	}
	
	/**
	 * @param integer
	 */
	public void setEsercizio_residuo(Integer integer) {
		esercizio_residuo = integer;
	}
	public java.lang.Boolean getFl_perenzione() {
		return fl_perenzione;
	}
	public void setFl_perenzione(java.lang.Boolean fl_perenzione) {
		this.fl_perenzione = fl_perenzione;
	}

	public java.lang.String getTiMotivazioneVariazione() {
		return tiMotivazioneVariazione;
	}
	
	public void setTiMotivazioneVariazione(java.lang.String tiMotivazioneVariazione) {
		this.tiMotivazioneVariazione = tiMotivazioneVariazione;
	}
	
	public java.lang.Long getIdMatricola() {
		return idMatricola;
	}
	
	public void setIdMatricola(java.lang.Long idMatricola) {
		this.idMatricola = idMatricola;
	}

	public java.lang.String getIdBando() {
		return idBando;
	}
	
	public void setIdBando(java.lang.String idBando) {
		this.idBando = idBando;
	}
	
	public java.lang.String getDs_causale() {
		return ds_causale;
	}
	
	public void setDs_causale(java.lang.String ds_causale) {
		this.ds_causale = ds_causale;
	}

	public java.lang.Integer getPg_progetto_rimodulazione() {
		return pg_progetto_rimodulazione;
	}
	
	public void setPg_progetto_rimodulazione(java.lang.Integer pg_progetto_rimodulazione) {
		this.pg_progetto_rimodulazione = pg_progetto_rimodulazione;
	}
	
	public java.lang.Integer getPg_rimodulazione() {
		return pg_rimodulazione;
	}

	public void setPg_rimodulazione(java.lang.Integer pg_rimodulazione) {
		this.pg_rimodulazione = pg_rimodulazione;
	}
}