<%@ page import="weaver.general.Util" %>
<jsp:useBean id="WFInfo" class="weaver.workflow.workflow.WFManager" scope="page" />
<jsp:useBean id="WFMainManager" class="weaver.workflow.workflow.WFMainManager" scope="page" />
<%WFMainManager.resetParameter();%>
<jsp:setProperty name="WFMainManager" property = "*"/>
<html>
<head>
<title><%=SystemEnv.getHtmlLabelName(15004,user.getLanguage())%></title>
<script language="javascript">
function CheckAll(checked) {
len = document.form2.elements.length;
var i=0;
for( i=0; i<len; i++) {
if (document.form2.elements[i].name=='delete_form_id') {
document.form2.elements[i].checked=(checked==true?true:false);
} } }


function unselectall()
{
    if(document.form2.checkall0.checked){
	document.form2.checkall0.checked =0;
    }
}
function confirmdel() {
	return confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>") ;
}

function OpenNewWindow(sURL,w,h)
{
  var iWidth = 0 ;
  var iHeight = 0 ;
  iWidth=(window.screen.availWidth-10)*w;
  iHeight=(window.screen.availHeight-50)*h;
  ileft=(window.screen.availWidth - iWidth)/2;
  itop= (window.screen.availHeight - iHeight + 50)/2;
  var szFeatures = "" ;
  szFeatures =	"resizable=no,status=no,menubar=no,width=" + 
				iWidth + ",height=" + iHeight*h + ",top="+itop+",left="+ileft
  window.open(sURL,"",szFeatures)
}

</script>
</head>
<body>
      <table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#FFFFFF">
        <tr> 
          <td colspan="7" height="23" bgcolor="#7777FF"><b><font color="#FFFFFF"><%=SystemEnv.getHtmlLabelName(15004,user.getLanguage())%></font></b></td>
        </tr>
        <tr> 
          <td colspan="7" align="center" height="15"></td>
        </tr>
          <tr> 
            <td width="40%" align="center" bgcolor="#CCCCCC" height="23"><%=SystemEnv.getHtmlLabelName(2079,user.getLanguage())%></td>
            <td width="40%" align="center" bgcolor="#CCCCCC" height="23"><%=SystemEnv.getHtmlLabelName(15594,user.getLanguage())%></td>
            <td width="20%" align="center" bgcolor="#CCCCCC" height="23"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></td>
          </tr>
          <%
            WFMainManager.selectWf();

            while(WFMainManager.next()){
              WFInfo = WFMainManager.getWFManager();
			  
          %>
          <tr> 
            <td width="40%" align="center" bgcolor="#D2D1F1"><%=WFInfo.getWfname()%></td>
            <td width="40%" align="center" bgcolor="#D2D1F1"><%=WFInfo.getWfdes()%></td>
            <td width="20%" align="center" bgcolor="#D2D1F1"><a href="request_operation.jsp?wfid=<%=WFInfo.getWfid()%>&src=addrequest&formid=<%=WFInfo.getFormid()%>"><img border="0" src="/images/ar_wev8.gif"></td>            
          </tr>
          <%}
            WFMainManager.closeStatement();
          %>
      </table>
