/*
 * Created by BulkGenerator 2.0 [07/12/2009]
 * Date 06/12/2012
 */
package it.cnr.contab.config00.bulk;
import it.cnr.contab.anagraf00.core.bulk.TerzoBulk;
import it.cnr.contab.config00.sto.bulk.Unita_organizzativaBulk;
import it.cnr.contab.util.ICancellatoLogicamente;
import it.cnr.jada.action.ActionContext;
import it.cnr.jada.bulk.OggettoBulk;
import it.cnr.jada.util.action.CRUDBP;
public class CigBulk extends CigBase implements ICancellatoLogicamente{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	/**
	 * [TERZO Tabella contenente le entit� anagrafiche di secondo livello (terzi). Ogni entit� anagrafica di secondo livello afferisce ad una di primo (ANAGRAFICO).

Rappresenta le sedi, reali o per gestione, in cui si articola un soggetto anagrafico]
	 **/
	private TerzoBulk terzo =  new TerzoBulk();
	/**
	 * [UNITA_ORGANIZZATIVA Rappresentazione dei Centri di Spesa e delle Unit� Organizzative in una struttura ad albero organizzata su pi� livelli]
	 **/
	private Unita_organizzativaBulk unitaOrganizzativa =  new Unita_organizzativaBulk();
	/**
	 * Created by BulkGenerator 2.0 [07/12/2009]
	 * Table name: CIG
	 **/
	public CigBulk() {
		super();
	}
	/**
	 * Created by BulkGenerator 2.0 [07/12/2009]
	 * Table name: CIG
	 **/
	public CigBulk(java.lang.String cdCig) {
		super(cdCig);
	}
	/**
	 * Created by BulkGenerator 2.0 [07/12/2009]
	 * Restituisce il valore di: [Tabella contenente le entit� anagrafiche di secondo livello (terzi). Ogni entit� anagrafica di secondo livello afferisce ad una di primo (ANAGRAFICO).

Rappresenta le sedi, reali o per gestione, in cui si articola un soggetto anagrafico]
	 **/
	public TerzoBulk getTerzo() {
		return terzo;
	}
	/**
	 * Created by BulkGenerator 2.0 [07/12/2009]
	 * Setta il valore di: [Tabella contenente le entit� anagrafiche di secondo livello (terzi). Ogni entit� anagrafica di secondo livello afferisce ad una di primo (ANAGRAFICO).

Rappresenta le sedi, reali o per gestione, in cui si articola un soggetto anagrafico]
	 **/
	public void setTerzo(TerzoBulk terzo)  {
		this.terzo=terzo;
	}
	/**
	 * Created by BulkGenerator 2.0 [07/12/2009]
	 * Restituisce il valore di: [Rappresentazione dei Centri di Spesa e delle Unit� Organizzative in una struttura ad albero organizzata su pi� livelli]
	 **/
	public Unita_organizzativaBulk getUnitaOrganizzativa() {
		return unitaOrganizzativa;
	}
	/**
	 * Created by BulkGenerator 2.0 [07/12/2009]
	 * Setta il valore di: [Rappresentazione dei Centri di Spesa e delle Unit� Organizzative in una struttura ad albero organizzata su pi� livelli]
	 **/
	public void setUnitaOrganizzativa(Unita_organizzativaBulk unitaOrganizzativa)  {
		this.unitaOrganizzativa=unitaOrganizzativa;
	}
	/**
	 * Created by BulkGenerator 2.0 [07/12/2009]
	 * Restituisce il valore di: [cdTerzoRup]
	 **/
	public java.lang.Integer getCdTerzoRup() {
		TerzoBulk terzo = this.getTerzo();
		if (terzo == null)
			return null;
		return getTerzo().getCd_terzo();
	}
	/**
	 * Created by BulkGenerator 2.0 [07/12/2009]
	 * Setta il valore di: [cdTerzoRup]
	 **/
	public void setCdTerzoRup(java.lang.Integer cdTerzoRup)  {
		this.getTerzo().setCd_terzo(cdTerzoRup);
	}
	/**
	 * Created by BulkGenerator 2.0 [07/12/2009]
	 * Restituisce il valore di: [cdUnitaOrganizzativa]
	 **/
	public java.lang.String getCdUnitaOrganizzativa() {
		Unita_organizzativaBulk unitaOrganizzativa = this.getUnitaOrganizzativa();
		if (unitaOrganizzativa == null)
			return null;
		return getUnitaOrganizzativa().getCd_unita_organizzativa();
	}
	/**
	 * Created by BulkGenerator 2.0 [07/12/2009]
	 * Setta il valore di: [cdUnitaOrganizzativa]
	 **/
	public void setCdUnitaOrganizzativa(java.lang.String cdUnitaOrganizzativa)  {
		this.getUnitaOrganizzativa().setCd_unita_organizzativa(cdUnitaOrganizzativa);
	}
	
	public OggettoBulk initializeForInsert(CRUDBP crudbp, ActionContext actioncontext) {
		setFlValido(Boolean.TRUE);
		return super.initializeForInsert(crudbp, actioncontext);
	};
	
	@Override
	public OggettoBulk initializeForFreeSearch(CRUDBP crudbp,
			ActionContext actioncontext) {
		terzo =  new TerzoBulk();
		unitaOrganizzativa =  new Unita_organizzativaBulk();
		return super.initializeForFreeSearch(crudbp, actioncontext);
	}
	
	public boolean isCancellatoLogicamente() {
		return !getFlValido();
	}
	public void cancellaLogicamente() {
		setFlValido(Boolean.FALSE);
	}
}