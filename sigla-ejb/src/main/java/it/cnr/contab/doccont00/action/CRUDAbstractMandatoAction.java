package it.cnr.contab.doccont00.action;

import it.cnr.contab.doccont00.core.bulk.*;
import java.util.*;
import it.cnr.contab.doccont00.bp.*;
import it.cnr.jada.action.*;
import it.cnr.jada.bulk.*;
import it.cnr.jada.util.action.*;

/**
 * <!-- @TODO: da completare -->
 */

public abstract class CRUDAbstractMandatoAction extends it.cnr.jada.util.action.CRUDAction {
public CRUDAbstractMandatoAction() {
	super();
}
/**
 * Gestisce il caricamento dei documenti passivi
 *
 */
 //
// Gestisce la selezione del bottone "Nuova Scadenza"
//
public Forward doAddToCRUDMain_SospesiSelezionati(ActionContext context)
{
	
	try 
	{
		CRUDAbstractMandatoBP bp = (CRUDAbstractMandatoBP)context.getBusinessProcess();
		it.cnr.jada.util.RemoteIterator ri = bp.cercaSospesi(context);
		it.cnr.jada.util.ejb.EJBCommonServices.openRemoteIterator(context, ri);
		if (ri == null || ri.countElements() == 0) {
			it.cnr.jada.util.ejb.EJBCommonServices.closeRemoteIterator(ri);
			bp.setMessage("La ricerca non ha fornito alcun risultato.");
			return context.findDefaultForward();
/*		}
		else if (ri.countElements() == 1) {
			OggettoBulk bulk = (OggettoBulk)ri.nextElement();
			if (ri instanceof javax.ejb.EJBObject)
				((javax.ejb.EJBObject)ri).remove();
			bp.setMessage("La ricerca ha fornito un solo risultato.");
			bp.edit(context,bulk);
			return context.findDefaultForward();*/
		} else {
	//		bp.setModel(context,filtro);
			BulkInfo bulkInfo = BulkInfo.getBulkInfo(SospesoBulk.class);
			SelezionatoreListaBP nbp = (SelezionatoreListaBP)context.createBusinessProcess("Selezionatore");
			nbp.setColumns( bulkInfo.getColumnFieldPropertyDictionary("SospesiMandato"));
			nbp.setIterator(context,ri);
			nbp.setMultiSelection( true );
			nbp.setBulkInfo(bulkInfo);
			context.addHookForward("seleziona",this,"doRiportaSelezioneSospesi");
			return context.addBusinessProcess(nbp);
		}
	} catch(Throwable e) {
		return handleException(context,e);
	}
	/*
	try 
	{
		CRUDAbstractMandatoBP bp = (CRUDAbstractMandatoBP)getBusinessProcess(context);
		fillModel( context );		
		bp.caricaSospesi(context);
		return context.findDefaultForward();
	} 
	catch(Throwable e) {return handleException(context,e);}
	*/
}
/**
 * Gestisce il caricamento dei documenti passivi
 *
 */
public Forward doCercaSospesi(ActionContext context)
{
	
	try 
	{
		fillModel(context);
		CRUDAbstractMandatoBP bp = (CRUDAbstractMandatoBP)context.getBusinessProcess();
		it.cnr.jada.util.RemoteIterator ri = bp.cercaSospesi(context);
		it.cnr.jada.util.ejb.EJBCommonServices.openRemoteIterator(context, ri);
		if (ri == null || ri.countElements() == 0) {
			it.cnr.jada.util.ejb.EJBCommonServices.closeRemoteIterator(ri);
			bp.setMessage("La ricerca non ha fornito alcun risultato.");
			return context.findDefaultForward();
/*		}
		else if (ri.countElements() == 1) {
			OggettoBulk bulk = (OggettoBulk)ri.nextElement();
			if (ri instanceof javax.ejb.EJBObject)
				((javax.ejb.EJBObject)ri).remove();
			bp.setMessage("La ricerca ha fornito un solo risultato.");
			bp.edit(context,bulk);
			return context.findDefaultForward();*/
		} else {
	//		bp.setModel(context,filtro);
			BulkInfo bulkInfo = BulkInfo.getBulkInfo(SospesoBulk.class);
			SelezionatoreListaBP nbp = (SelezionatoreListaBP)context.createBusinessProcess("Selezionatore");
			nbp.setColumns( bulkInfo.getColumnFieldPropertyDictionary("SospesiDocCont"));
			nbp.setIterator(context,ri);
			nbp.setMultiSelection( true );
//			nbp.setBulkInfo(bulkInfo);
			context.addHookForward("seleziona",this,"doRiportaSelezioneSospesi");
			return context.addBusinessProcess(nbp);
		}
	} catch(Throwable e) {
		return handleException(context,e);
	}
	/*
	try 
	{
		CRUDAbstractMandatoBP bp = (CRUDAbstractMandatoBP)getBusinessProcess(context);
		fillModel( context );		
		bp.caricaSospesi(context);
		return context.findDefaultForward();
	} 
	catch(Throwable e) {return handleException(context,e);}
	*/
}
/**
 * Gestisce un comando di cancellazione.
 */
public Forward doConfermaElimina(ActionContext context, int choice ) throws java.rmi.RemoteException 
{
	try 
	{
		fillModel(context);
		if ( choice == OptionBP.YES_BUTTON )
		{
			CRUDBP bp = getBusinessProcess(context);
			bp.delete(context);
			bp.setMessage("Annullamento effettuato");
		}	
		return context.findDefaultForward();
	} catch(Throwable e) {
		return handleException(context,e);
	}
}
/**
 * Gestisce un comando di cancellazione.
 */
public Forward doElimina(ActionContext context) throws java.rmi.RemoteException {
	try {
		fillModel(context);

		CRUDBP bp = getBusinessProcess(context);
		
		CRUDAbstractMandatoBP bpm = (CRUDAbstractMandatoBP)context.getBusinessProcess();
				 
		if (!bp.isDeleteButtonEnabled()) {
			bp.setMessage("Non � possibile cancellare in questo momento");
		} else 
		{
			MandatoBulk mandato = (MandatoBulk) bp.getModel();
			if ( mandato.isDipendenteDaAltroDocContabile() )
				bp.setMessage( "Non � possibile annullare il mandato perch� e' stato originato da un altro doc. contabile" );
			else    if ( bpm.isDipendenteDaConguaglio(context,mandato) )
				    bp.setMessage( "Non � possibile annullare il mandato poich� e' stato gi� effettuato il conguaglio del compenso a cui � collegato" );
			else	if ( mandato.getDoc_contabili_collColl().size() > 0 )	
				return openConfirm(context,"All'annullamento del mandato anche i documenti contabili collegati verranno annullati. Vuoi continuare?",OptionBP.CONFIRM_YES_NO,"doConfermaElimina");
			else 
				return doConfermaElimina(context,OptionBP.YES_BUTTON);
			}
		return context.findDefaultForward();
	} catch(Throwable e) {
		return handleException(context,e);
	}
}
/**
	 * Metodo utilizzato per gestire la conferma a seguito del controllo sul compenso
	 *
	 * @param context <code>ActionContext</code> in uso.
	 * @param option Esito della risposta alla richiesta di sfondamento
	 *
	 * @return <code>Forward</code>
	 *
	 * @exception <code>RemoteException</code>
	 *
	 */

public Forward doOnCompensoFailed( ActionContext context, int option) 
{

	if (option == it.cnr.jada.util.action.OptionBP.OK_BUTTON) 
	{
		try 
		{
			CRUDAbstractMandatoBP bp = (CRUDAbstractMandatoBP) getBusinessProcess(context);
			it.cnr.contab.doccont00.core.bulk.CompensoOptionRequestParameter param = new CompensoOptionRequestParameter();
			param.setCheckCompensoRequired( new Boolean(true) );
			bp.delete( context, param );
		} 
		catch(Throwable e) 
		{
			return handleException(context,e);
		}
	}
	return context.findDefaultForward();
}
/**
 * Gestisce la selezione dei sospesi
 *
 */
public Forward doRiportaSelezioneSospesi(ActionContext context)
{
	
	try 
	{
		CRUDAbstractMandatoBP bp = (CRUDAbstractMandatoBP)context.getBusinessProcess();
		bp.aggiungiSospesi( context );
		return context.findDefaultForward();
	} catch(Throwable e) 
	{
		return handleException(context,e);
	}
	
}
}
