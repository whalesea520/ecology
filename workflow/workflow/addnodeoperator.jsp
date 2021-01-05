<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="WFNodeOperatorManager" class="weaver.workflow.workflow.WFNodeOperatorManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%WFNodeOperatorManager.resetParameter();%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript">
function CheckAll(checked) {
len = document.form2.elements.length;
var i=0;
for( i=0; i<len; i++) {
if (document.form2.elements[i].name=='delete_wf_id') {
document.form2.elements[i].checked=(checked==true?true:false);
} } }


function unselectall()
{
    if(document.form2.checkall0.checked){
	document.form2.checkall0.checked =0;
    }
}
function confirmdel() {
	len = document.form2.elements.length;
	var i=0;
	var hasitem = 0;
	for( i=0; i<len; i++) {
		if (document.form2.elements[i].name=='delete_wf_id') {
			if(document.form2.elements[i].checked==true)
				hasitem = 1;
		} 
	} 
	if(hasitem == 0){
		alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>!");
		return false;
	}
	return confirm("<%=SystemEnv.getHtmlLabelName(15459,user.getLanguage())%>?") ;
}

</script>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage());
String needfav ="1";
String needhelp ="";

int groupnum = 0;
String nodetype="";
int design = Util.getIntValue(request.getParameter("design"),0);
%>
</head>
<body>
<%
if(design==0) {
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%
}
%>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	String wfid=""+Util.getIntValue(request.getParameter("wfid"),0);
	int formid=Util.getIntValue(request.getParameter("formid"),0);
	int nodeid=Util.getIntValue(request.getParameter("nodeid"),0);
	String isbill=Util.null2String(request.getParameter("isbill"));
	String iscust=Util.null2String(request.getParameter("iscust"));
	
	char flag=2;
	RecordSet.executeProc("workflow_NodeType_Select",""+wfid+flag+nodeid);
	
	if(RecordSet.next())
		nodetype = RecordSet.getString("nodetype");
	
%>
 <form name="form2" method="post"  action="wf_operation.jsp">

  <div id=odiv2 > 

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:onnewone(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:submitDel(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
if(design==1) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:designOnClose(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
else {
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/workflow/workflow/Editwfnode.jsp?wfid="+wfid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=87 and relatedid="+nodeid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<input type="hidden" value="<%=design%>" name="design">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

     <table class="ViewForm">
      	<COLGROUP>
  	<COL width="5%">
  	<COL width="70%">
  	<COL width="25%">
        <TR class="Title">
    	  <TH colSpan=3><%=SystemEnv.getHtmlLabelName(15544,user.getLanguage())%></TH></TR>
  	<TR class="Spacing">
    	  <TD class="Line1" colSpan=3></TD></TR>
       <input type=hidden name=src value="delgroups">
          <input type=hidden name=wfid value="<%=wfid%>">
          <input type=hidden name=formid value="<%=formid%>">
          <input type=hidden name=nodeid value="<%=nodeid%>">
          <input type=hidden name=isbill value="<%=isbill%>">
          <input type=hidden name=iscust value="<%=iscust%>">
          <!--modify by xhheng @ 2004/12/10 for TDID 1448-->
          <input type=hidden name=nodetype value="<%=nodetype%>">
          <tr class=header> 
            <td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(15545,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></td>            
          </tr>	<TR class="Spacing">
    	  <TD class="Line1" colSpan=3></TD></TR>
          <%
          
	    int linecolor=0;
	    WFNodeOperatorManager.setNodeid(nodeid);
            WFNodeOperatorManager.selectNodeOperator();
            while(WFNodeOperatorManager.next()){
            	groupnum ++;
			  
          %>
           <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> > 
            <td> 
              <input type="checkbox"  name="delete_wf_id" value="<%=WFNodeOperatorManager.getId()%>" onClick=unselectall()>
            </td>
            <td><%=WFNodeOperatorManager.getName()%></td>
            <td><a href="editoperatorgroup.jsp?design=<%=design%>&nodeid=<%=nodeid%>&wfid=<%=wfid%>&formid=<%=formid%>&isbill=<%=isbill%>&iscust=<%=iscust%>&id=<%=WFNodeOperatorManager.getId()%>"><img src="/images/iedit_wev8.gif" width="16" height="16" border="0"></a> 
            </td>
          </tr><TR><TD class=Line colSpan=3></TD></TR> 
          <%
           if(linecolor==0) linecolor=1;
          else linecolor=0;
          }
            WFNodeOperatorManager.closeStatement();
            //图形设计模式下如果未建操作组直接跳转至新增页面
            if(design==1 && groupnum==0){response.sendRedirect("addoperatorgroup.jsp?design="+design+"&nodeid="+nodeid+"&wfid="+wfid+"&formid="+formid+"&isbill="+isbill+"&iscust="+iscust);}
          %>
          <tr> 
            <td colspan="9" height="19"> 
              <input type="checkbox" name="checkall0" onClick="CheckAll(checkall0.checked)" value="ON">
              <%=SystemEnv.getHtmlLabelName(2241,user.getLanguage())%></td>
          </tr>
          
               </table>
         
        </div>
		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
        </form>

<script language=javascript>
function onnewone()
{
	if(<%=groupnum%> > 0 && <%=nodetype%> ==0){
		alert("Create<%=SystemEnv.getHtmlLabelName(15546,user.getLanguage())%>Group!");
	}
	else{
		location='';
	}
}
</script>
<script language="javascript">
function submitData()
{
	if (check_form(weaver,'type,desc'))
		weaver.submit();
}

function submitDel()
{
	if(confirmdel()){
		form2.submit();
		}
}
//工作流图形化确定
function designOnClose() {
	window.parent.design_callback('addnodeoperator');
}
</script>
</body>
</html>