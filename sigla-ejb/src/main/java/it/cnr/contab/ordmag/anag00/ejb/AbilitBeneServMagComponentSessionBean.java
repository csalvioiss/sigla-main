package it.cnr.contab.ordmag.anag00.ejb;

import javax.annotation.PostConstruct;
import javax.ejb.Remove;
import javax.ejb.Stateless;

import it.cnr.jada.ejb.CRUDComponentSessionBean;
@Stateless(name="CNRORDMAG00_EJB_AbilitBeneServMagComponentSession")
public class AbilitBeneServMagComponentSessionBean extends it.cnr.jada.ejb.CRUDComponentSessionBean implements AbilitBeneServMagComponentSession {
	@PostConstruct
	public void ejbCreate() {
		componentObj = new it.cnr.contab.ordmag.anag00.comp.AbilitBeneServMagComponent();
	}
	@Remove
	public void ejbRemove() throws javax.ejb.EJBException {
		componentObj.release();
	}
	
	public static CRUDComponentSessionBean newInstance() throws javax.ejb.EJBException {
		return new AbilitBeneServMagComponentSessionBean();
	}

}
