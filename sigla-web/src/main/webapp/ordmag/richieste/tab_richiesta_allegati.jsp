<%@ page 
	import="it.cnr.jada.util.jsp.*,it.cnr.jada.action.*,java.util.*,it.cnr.jada.util.action.*,it.cnr.jada.*,it.cnr.contab.ordmag.richieste.bp.CRUDRichiestaUopBP,it.cnr.contab.ordmag.richieste.bulk.RichiestaUopRigaBulk,it.cnr.contab.ordmag.anag00.*"
%>
<%	CRUDRichiestaUopBP bp = (CRUDRichiestaUopBP)BusinessProcess.getBusinessProcess(request);%>
<script language="JavaScript">
function doScaricaAllegato() {	
	  doPrint('genericdownload/<%=bp.getNomeAllegato()%>?methodName=scaricaAllegatoGenerico&it.cnr.jada.action.BusinessProcess=<%=bp.getPath()%>');
}
</script>
<%  bp.getCrudArchivioAllegati().writeHTMLTable(pageContext,bp.getAllegatiFormName(),true,false,true,"100%","150px"); %>  
<div class="Group">
  <table>
  	<% bp.getCrudArchivioAllegati().writeForm(out, bp.getAllegatiFormName());  %>
  </table>
</div> 