package it.cnr.contab.anagraf00.comp;

import it.cnr.contab.anagraf00.core.bulk.BancaBulk;
import it.cnr.contab.anagraf00.core.bulk.TerzoBulk;
import it.cnr.contab.anagraf00.tabrif.bulk.Rif_modalita_pagamentoBulk;
import it.cnr.contab.client.docamm.Banca;
import it.cnr.contab.docamm00.ejb.FatturaAttivaSingolaComponentSession;
import it.cnr.contab.utenze00.bp.Costanti;
import it.cnr.contab.utenze00.bp.WSUserContext;
import it.cnr.jada.UserContext;
import it.cnr.jada.comp.ComponentException;

import java.io.StringWriter;
import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.annotation.security.DeclareRoles;
import javax.ejb.EJB;
import javax.ejb.Stateless;
import javax.jws.WebService;
import javax.xml.bind.annotation.XmlSeeAlso;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.soap.MessageFactory;
import javax.xml.soap.Name;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPConstants;
import javax.xml.soap.SOAPException;
import javax.xml.soap.SOAPFactory;
import javax.xml.soap.SOAPFault;
import javax.xml.soap.SOAPMessage;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.ws.soap.SOAPFaultException;

import org.jboss.ws.api.annotation.WebContext;
import org.w3c.dom.DOMImplementation;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

/**
 * Questa classe svolge le operazioni fondamentali di lettura, scrittura e
 * filtro dei dati immessi o richiesti dall'utente. In oltre sovrintende alla
 * gestione e creazione dati a cui l'utente stesso non ha libero accesso e/o non
 * gli sono trasparenti.
 */
@Stateless
@WebService(endpointInterface = "it.cnr.contab.anagraf00.ejb.BancaComponentSessionWS")
@XmlSeeAlso({ java.util.ArrayList.class })
@DeclareRoles({ "WSUserRole", "IITRole" })
@WebContext(authMethod = "WSSE", contextRoot = "SIGLA-SIGLAEJB")
public class BancaComponentWS {
	@EJB FatturaAttivaSingolaComponentSession fatturaAttivaSingolaComponentSession;

	public java.util.ArrayList<Banca> cercaBanche(Integer terzo,
			String modalita, String query, String dominio, Integer numMax,
			String user, String ricerca) throws Exception {
		try {
			java.util.ArrayList<Banca> listaBanche = new ArrayList<Banca>();
			List banche = null;
			if (user == null)
				user = "IIT";
			if (ricerca == null)
				ricerca = "selettiva";
			if (numMax == null)
				numMax = 20;
			UserContext userContext = new WSUserContext(user, null,
					new Integer(java.util.Calendar.getInstance().get(
							java.util.Calendar.YEAR)), null, null, null);
			if (terzo == null)
				throw new SOAPFaultException(faultTerzoNonDefinito());
			if (modalita == null)
				throw new SOAPFaultException(faultModalitaNonDefinita());
			if (query == null) {
				throw new SOAPFaultException(faultQueryNonDefinita());
			} else if (dominio == null
					|| (!dominio.equalsIgnoreCase("codice") && !dominio
							.equalsIgnoreCase("descrizione"))) {
				throw new SOAPFaultException(faultDominioNonDefinito());
			} else {
				try {
					TerzoBulk terzo_db = new TerzoBulk();
					terzo_db = (((TerzoBulk) fatturaAttivaSingolaComponentSession
							.completaOggetto(userContext, new TerzoBulk(terzo))));
					if (terzo_db == null)
						throw new SOAPFaultException(faultTerzoNonDefinito());
					else {
						Rif_modalita_pagamentoBulk rif_mod = new Rif_modalita_pagamentoBulk();
						rif_mod = (((Rif_modalita_pagamentoBulk) fatturaAttivaSingolaComponentSession
								.completaOggetto(
										userContext,
										new Rif_modalita_pagamentoBulk(modalita))));
						if (rif_mod == null)
							throw new SOAPFaultException(
									faultModalitaNonDefinita());
						else
							banche = fatturaAttivaSingolaComponentSession
									.findListaBancheWS(userContext,
											terzo.toString(), modalita, query,
											dominio, ricerca);
					}
				} catch (NumberFormatException e) {
					throw new SOAPFaultException(faultFormato());
				} catch (ComponentException e) {
					throw new SOAPFaultException(faultGenerico());
				} catch (RemoteException e) {
					throw new SOAPFaultException(faultGenerico());
				}
			}

			int num = 0;
			if (banche != null && !banche.isEmpty()) {
				for (Iterator i = banche.iterator(); i.hasNext()
						&& num < new Integer(numMax).intValue();) {
					BancaBulk banca = (BancaBulk) i.next();
					Banca bank = new Banca();
					bank.setCodice(banca.getPg_banca());
					bank.setDescrizione(banca.getIntestazione());
					bank.setAbi(banca.getAbi());
					bank.setCab(banca.getCab());
					bank.setNumeroconto(banca.getNumero_conto());
					bank.setIban(banca.getCodice_iban());
					listaBanche.add(bank);
					num++;
				}
			}
			return listaBanche;
		} catch (SOAPFaultException e) {
			throw e;
		} catch (Exception e) {
			throw new SOAPFaultException(faultGenerico());
		}
	}

	public String cercaBancheXml(String terzo, String modalita, String query,
			String dominio, String numMax, String user, String ricerca)
			throws Exception {
		List banche = null;
		UserContext userContext = new WSUserContext(user, null, new Integer(
				java.util.Calendar.getInstance().get(java.util.Calendar.YEAR)),
				null, null, null);
		if (terzo == null)
			throw new SOAPFaultException(faultTerzoNonDefinito());
		if (modalita == null)
			throw new SOAPFaultException(faultModalitaNonDefinita());
		if (query == null) {
			throw new SOAPFaultException(faultQueryNonDefinita());
		} else if (dominio == null
				|| (!dominio.equalsIgnoreCase("codice") && !dominio
						.equalsIgnoreCase("descrizione"))) {
			throw new SOAPFaultException(faultDominioNonDefinito());
		} else {
			try {
				TerzoBulk terzo_db = new TerzoBulk();
				terzo_db = (((TerzoBulk) fatturaAttivaSingolaComponentSession
						.completaOggetto(userContext, new TerzoBulk(
								new Integer(terzo)))));
				if (terzo_db == null)
					throw new SOAPFaultException(faultTerzoNonDefinito());
				else {
					Rif_modalita_pagamentoBulk rif_mod = new Rif_modalita_pagamentoBulk();
					rif_mod = (((Rif_modalita_pagamentoBulk) fatturaAttivaSingolaComponentSession
							.completaOggetto(userContext,
									new Rif_modalita_pagamentoBulk(modalita))));
					if (rif_mod == null)
						throw new SOAPFaultException(faultModalitaNonDefinita());
					else
						banche = fatturaAttivaSingolaComponentSession
								.findListaBancheWS(userContext, terzo,
										modalita, query, dominio, ricerca);
				}
			} catch (NumberFormatException e) {
				throw new SOAPFaultException(faultFormato());
			} catch (ComponentException e) {
				throw new SOAPFaultException(faultGenerico());
			} catch (RemoteException e) {
				throw new SOAPFaultException(faultGenerico());
			}
		}
		try {
			return generaXML(numMax, banche);
		} catch (Exception e) {
			throw new SOAPFaultException(faultGenerico());
		}
	}

	private SOAPFault faultGenerico() throws SOAPException {
		return generaFault(new String(Costanti.ERRORE_WS_100.toString()),
				Costanti.erroriWS.get(Costanti.ERRORE_WS_100));
	}

	private SOAPFault faultQueryNonDefinita() throws SOAPException {
		return generaFault(new String(Costanti.ERRORE_WS_101.toString()),
				Costanti.erroriWS.get(Costanti.ERRORE_WS_101));
	}

	private SOAPFault faultDominioNonDefinito() throws SOAPException {
		return generaFault(new String(Costanti.ERRORE_WS_102.toString()),
				Costanti.erroriWS.get(Costanti.ERRORE_WS_102));
	}

	private SOAPFault faultTerzoNonDefinito() throws SOAPException {
		return generaFault(new String(Costanti.ERRORE_WS_103.toString()),
				Costanti.erroriWS.get(Costanti.ERRORE_WS_103));
	}

	private SOAPFault faultModalitaNonDefinita() throws SOAPException {
		return generaFault(new String(Costanti.ERRORE_WS_104.toString()),
				Costanti.erroriWS.get(Costanti.ERRORE_WS_104));
	}

	private SOAPFault faultFormato() throws SOAPException {
		return generaFault(new String(Costanti.ERRORE_WS_112.toString()),
				Costanti.erroriWS.get(Costanti.ERRORE_WS_112));
	}

	public String generaXML(String numMax, List banche)
			throws ParserConfigurationException, TransformerException {
		if (numMax == null)
			numMax = new Integer(20).toString();
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		DocumentBuilder builder = factory.newDocumentBuilder();
		DOMImplementation impl = builder.getDOMImplementation();
		Document xmldoc = impl.createDocument(null, "root", null);
		Element root = xmldoc.getDocumentElement();
		root.setAttributeNS("http://www.w3.org/2001/XMLSchema-instance",
				"xsi:noNamespaceSchemaLocation",
				"https://contab.cnr.it/SIGLA/schema/cercabanca.xsd");

		root.appendChild(generaNumeroModalita(xmldoc, banche));
		int num = 0;
		if (banche != null && !banche.isEmpty()) {
			for (Iterator i = banche.iterator(); i.hasNext()
					&& num < new Integer(numMax).intValue();) {
				BancaBulk banca = (BancaBulk) i.next();
				root.appendChild(generaDettaglioBanca(xmldoc, banca
						.getPg_banca().toString(), banca.getIntestazione(),
						banca.getAbi(), banca.getCab(),
						banca.getNumero_conto(), banca.getCodice_iban()));
				num++;
			}
		}

		DOMSource domSource = new DOMSource(xmldoc);
		StringWriter domWriter = new StringWriter();
		StreamResult streamResult = new StreamResult(domWriter);

		TransformerFactory tf = TransformerFactory.newInstance();
		Transformer serializer = tf.newTransformer();
		serializer.setOutputProperty(OutputKeys.ENCODING, "ISO-8859-1");
		// serializer.setOutputProperty(OutputKeys.DOCTYPE_SYSTEM,"http://150.146.206.250/DTD/cercaterzi.dtd");
		// serializer.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC,"cercatariffari");
		serializer.setOutputProperty(OutputKeys.INDENT, "yes");
		serializer.setOutputProperty(OutputKeys.STANDALONE, "no");
		serializer.transform(domSource, streamResult);
		return domWriter.toString();
	}

	private Element generaNumeroModalita(Document xmldoc, List banche) {
		Element e = xmldoc.createElement("numris");
		Node n = xmldoc.createTextNode(new Integer(banche.size()).toString());
		e.appendChild(n);
		return e;
	}

	private Element generaDettaglioBanca(Document xmldoc, String codice,
			String descrizione, String abi, String cab, String cc, String iban) {

		Element element = xmldoc.createElement("banca");

		Element elementCodice = xmldoc.createElement("codice");
		Node nodeCodice = xmldoc.createTextNode(codice);
		elementCodice.appendChild(nodeCodice);
		element.appendChild(elementCodice);

		Element elementStato = xmldoc.createElement("descrizione");
		Node nodeStato = xmldoc.createTextNode(descrizione);
		elementStato.appendChild(nodeStato);
		element.appendChild(elementStato);

		Element elementAbi = xmldoc.createElement("abi");
		Node nodeAbi = xmldoc.createTextNode(abi == null ? "" : abi);
		elementAbi.appendChild(nodeAbi);
		element.appendChild(elementAbi);

		Element elementCab = xmldoc.createElement("cab");
		Node nodeCab = xmldoc.createTextNode(cab == null ? "" : cab);
		elementCab.appendChild(nodeCab);
		element.appendChild(elementCab);

		Element elementcc = xmldoc.createElement("numeroconto");
		Node nodecc = xmldoc.createTextNode(cc == null ? "" : cc);
		elementcc.appendChild(nodecc);
		element.appendChild(elementcc);

		Element elementiban = xmldoc.createElement("iban");
		Node nodeiban = xmldoc.createTextNode(iban == null ? "" : iban);
		elementiban.appendChild(nodeiban);
		element.appendChild(elementiban);
		return element;
	}

	private SOAPFault generaFault(String localName, String stringFault)
			throws SOAPException {
		MessageFactory factory = MessageFactory.newInstance();
		SOAPMessage message = factory.createMessage();
		SOAPFactory soapFactory = SOAPFactory.newInstance();
		SOAPBody body = message.getSOAPBody();
		SOAPFault fault = body.addFault();
		Name faultName = soapFactory.createName(localName, "",
				SOAPConstants.URI_NS_SOAP_ENVELOPE);
		fault.setFaultCode(faultName);
		fault.setFaultString(stringFault);
		return fault;
	}

}
