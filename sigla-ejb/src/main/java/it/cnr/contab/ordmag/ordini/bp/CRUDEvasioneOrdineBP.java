package it.cnr.contab.ordmag.ordini.bp;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Hashtable;
import java.util.Iterator;

import it.cnr.contab.doccont00.core.bulk.MandatoBulk;
import it.cnr.contab.doccont00.core.bulk.MandatoIBulk;
import it.cnr.contab.doccont00.core.bulk.V_doc_passivo_obbligazioneBulk;
import it.cnr.contab.doccont00.ejb.MandatoComponentSession;
import it.cnr.contab.ordmag.ordini.bulk.EvasioneOrdineBulk;
import it.cnr.contab.ordmag.ordini.bulk.OrdineAcqBulk;
import it.cnr.contab.ordmag.ordini.bulk.OrdineAcqConsegnaBulk;
import it.cnr.contab.ordmag.ordini.ejb.EvasioneOrdineComponentSession;
import it.cnr.contab.ordmag.ordini.ejb.OrdineAcqComponentSession;
import it.cnr.jada.action.BusinessProcessException;
import it.cnr.jada.bulk.OggettoBulk;
import it.cnr.jada.util.DateUtils;
import it.cnr.jada.util.action.SimpleCRUDBP;
import it.cnr.jada.util.action.SimpleDetailCRUDController;

/**
 * Gestisce le catene di elementi correlate con il documento in uso.
 */
public class CRUDEvasioneOrdineBP extends SimpleCRUDBP {

	private it.cnr.contab.doccont00.core.bulk.OptionRequestParameter userConfirm = null;
	private boolean carryingThrough = false;
	private boolean isDeleting = false;
	public boolean isInputReadonly() 
	{
			return super.isInputReadonly();
	}

	private final SimpleDetailCRUDController consegne = new SimpleDetailCRUDController("ConsegneDaEvadere",OrdineAcqConsegnaBulk.class,"righeConsegnaDaEvadereColl",this){

		@Override
		public int addDetail(OggettoBulk oggettobulk) throws BusinessProcessException {
			OrdineAcqConsegnaBulk consegna = (OrdineAcqConsegnaBulk)oggettobulk;
			consegna.setTipoConsegna(consegna.getOrdineAcqRiga().getTipoConsegnaDefault());
			int index = super.addDetail(oggettobulk);
			return index;
		}
		
	};

	public final it.cnr.jada.util.action.SimpleDetailCRUDController getConsegne() {
		return consegne;
	}
	
	public CRUDEvasioneOrdineBP() {
		this(EvasioneOrdineBulk.class);
	}
	protected void setTab() {
		setTab("tab","tabOrdineAcq");
		setTab("tabOrdineAcqDettaglio","tabOrdineDettaglio");
	}

	public CRUDEvasioneOrdineBP(Class dettObbligazioniControllerClass) {
		super("Tr");

		setTab();

	}

	/**
	 * CRUDAnagraficaBP constructor comment.
	 * 
	 * @param function
	 *            java.lang.String
	 */
	public CRUDEvasioneOrdineBP(String function)
			throws BusinessProcessException {
		super(function + "Tr");

		setTab();

	}

	protected it.cnr.jada.util.jsp.Button[] createToolbar() {
		it.cnr.jada.util.jsp.Button[] toolbar = new it.cnr.jada.util.jsp.Button[7];
		int i = 0;
		toolbar[i++] = new it.cnr.jada.util.jsp.Button(it.cnr.jada.util.Config.getHandler().getProperties(it.cnr.jada.util.action.CRUDBP.class),"CRUDToolbar.search");
		toolbar[i++] = new it.cnr.jada.util.jsp.Button(it.cnr.jada.util.Config.getHandler().getProperties(it.cnr.jada.util.action.CRUDBP.class),"CRUDToolbar.startSearch");
		toolbar[i++] = new it.cnr.jada.util.jsp.Button(it.cnr.jada.util.Config.getHandler().getProperties(it.cnr.jada.util.action.CRUDBP.class),"CRUDToolbar.freeSearch");
		toolbar[i++] = new it.cnr.jada.util.jsp.Button(it.cnr.jada.util.Config.getHandler().getProperties(it.cnr.jada.util.action.CRUDBP.class),"CRUDToolbar.new");
		toolbar[i++] = new it.cnr.jada.util.jsp.Button(it.cnr.jada.util.Config.getHandler().getProperties(it.cnr.jada.util.action.CRUDBP.class),"CRUDToolbar.save");
		toolbar[i++] = new it.cnr.jada.util.jsp.Button(it.cnr.jada.util.Config.getHandler().getProperties(it.cnr.jada.util.action.CRUDBP.class),"CRUDToolbar.delete");
		toolbar[i++] = new it.cnr.jada.util.jsp.Button(it.cnr.jada.util.Config.getHandler().getProperties(getClass()),"CRUDToolbar.stampa");

		return toolbar;
	}
	public it.cnr.contab.doccont00.core.bulk.OptionRequestParameter getUserConfirm() {
		return userConfirm;
	}
	public void setUserConfirm(it.cnr.contab.doccont00.core.bulk.OptionRequestParameter userConfirm) {
		this.userConfirm = userConfirm;
	}
	public boolean isCarryingThrough() {
		return carryingThrough;
	}
	public void setCarryingThrough(boolean carryingThrough) {
		this.carryingThrough = carryingThrough;
	}

	@Override
	public boolean isDeleteButtonHidden() {
		return true;
	}

	@Override
	public boolean isFreeSearchButtonHidden() {
		return true;
	}

	@Override
	public boolean isSearchButtonHidden() {
		return true;
	}

	@Override
	public boolean isStartSearchButtonHidden() {
		return true;
	}
	public void cercaConsegne(it.cnr.jada.action.ActionContext context) throws it.cnr.jada.action.BusinessProcessException 
	{
		EvasioneOrdineBulk bulk = (EvasioneOrdineBulk) getModel();	
		try 
		{
			
			EvasioneOrdineComponentSession comp = (EvasioneOrdineComponentSession)createComponentSession();
			bulk.setDataBolla(new Timestamp(System.currentTimeMillis()));
			bulk.setDataConsegna(new Timestamp(System.currentTimeMillis()));
			bulk = comp.cercaOrdini(context.getUserContext(), bulk);

			setModel( context, bulk );
			resyncChildren( context );
		} catch(Exception e) 
		{
			throw handleException(e);
		}
	}
}
