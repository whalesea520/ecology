<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.workflow.workflow.WFOpinionInfo" %>
<jsp:useBean id="WFOpinionNodeManager" class="weaver.workflow.workflow.WFOpinionNodeManager" scope="page" />
<%
    String ajax=Util.null2String(request.getParameter("ajax"));
    //System.out.println("ajax=="+ajax);
    int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
    int nodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
    int linecolor = 0;
%>
<%if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
}
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
</head>

<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>  

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(!ajax.equals("1"))
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitNodeData(),_self} " ;
else
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:nodeOpinionfieldsave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
if(!ajax.equals("1"))
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",Editwfnode.jsp?wfid="+wfid+",_self} " ;
else
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:cancelEditNode(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
if(!ajax.equals("1")){
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%}else{%>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<%}%>
<form id="opinionform" name="opinionform" method=post action="WFOpinionNodeFieldOperation.jsp" >
<%if(ajax.equals("1")){%>
<input type=hidden name=ajax value="1">
<%}%>
<input type="hidden" name="workflowid" value="<%=wfid%>">
<input type="hidden" name="nodeid" value="<%=nodeid%>">
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

<table class="viewform">
   <COLGROUP>
   <COL width="20%">
   <COL width="80%">  
<%if(!ajax.equals("1")){%>
       <TR class="Title">
    	  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></TH></TR>
    <TR class="Spacing">
    	  <TD class="Line1" colSpan=2></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(2079,user.getLanguage())%></td>
    <td class=field></td>
  </tr>
    <TR class="Spacing">
    	  <TD class="Line" colSpan=2></TD></TR>
 <tr>
    <td><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></td>
    <td class=field></td>
  </tr>   <TR class="Spacing">
    	  <TD class="Line" colSpan=2></TD></TR>

  <tr>
    <td><%=SystemEnv.getHtmlLabelName(15600,user.getLanguage())%></td>    
  </tr>   <TR class="Spacing">
    	  <TD class="Line" colSpan=2></TD></TR>
   <tr>
    <td><%=SystemEnv.getHtmlLabelName(15594,user.getLanguage())%></td>
    <td class=field></td>
  </tr>
          <TR class="Spacing">
    	  <TD class="Line" colSpan=2></TD></TR>
   <tr>
    <td><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></td>
    <td class=field></td>
  </tr>   <TR class="Spacing">
    	  <TD class="Line1" colSpan=2></TD></TR>
  <tr>
          <td colspan="2" align="center" height="15"></td>
        </tr>
<%}%>
          <TR class="Title">
    	  <TH><%=SystemEnv.getHtmlLabelName(18888,user.getLanguage())%></th><th>
    	  </TH></TR>
		  
</table>

<div id="tdiv">
<table class="viewform">
<COLGROUP>
   <COL width="20%">
   <COL width="80%">  
   <TR class="Spacing">
    	  <TD class="Line" colSpan=2></TD></TR>
</table>
</div>
<div id="odiv">
  <table class=liststyle cellspacing=1  >
      	<COLGROUP>
  	<COL width="20%">
  	<COL width="20%">
  	<COL width="20%">
  	<COL width="20%">
  	<COL width="20%">
<tr class=header> 
            <td><%=SystemEnv.getHtmlLabelName(18895,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(18896,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(15605,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(18897,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(18898,user.getLanguage())%></td>
</tr><TR class=Line ><TD colSpan=5></TD></TR> 

<%
List list = WFOpinionNodeManager.getFieldNodeValuesByWorkflowId(wfid, nodeid);
if(list != null){
	for(int i=0; i<list.size(); i++){
		WFOpinionInfo info = (WFOpinionInfo)list.get(i);
		int isUse = info.getIsUse();
		int isMust = info.getIsMust();
		int isView = info.getIsView();
		int isEdit = info.getIsEdit();
		int id = info.getId();
		String type_cn = info.getType_cn();
%>
	<tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%>> 
	    <td><%=info.getLabel_cn()%></td>
        <td>
          <input type="checkbox" id="isUse" name="isUse_<%=id%>" value="1" <%if(isUse == 1){%>checked<%}%> onClick="if(this.checked==false){document.opinionform.isMust_<%=id%>.checked=false;document.opinionform.isMust_<%=id%>.disabled='true';}else if(this.checked==true){document.opinionform.isMust_<%=id%>.disabled=false;}">
        </td>
        <td>
          <input type="checkbox" id="isMust" name="isMust_<%=id%>" value="1" <%if(isMust == 1){%>checked<%}%> <%if(isUse != 1){%>disabled ='true'<%}%> onClick="if(this.checked==true){document.opinionform.isMust_<%=id%>.disabled=false;}">
        </td>
        <td>
          <input type="checkbox" id="isView" name="isView_<%=id%>" value="1" <%if(isView == 1){%>checked<%}%> onClick="if(this.checked==false){document.opinionform.isEdit_<%=id%>.checked=false;}">
        </td>
        <td>
          <input type="checkbox" id="isEdit" name="isEdit_<%=id%>" value="1" <%if(isEdit == 1){%>checked<%}%> onClick="if(this.checked==true){document.opinionform.isView_<%=id%>.checked=true;}" <%if(!type_cn.equals("1") && !type_cn.equals("2")){%>disabled ='true'<%}%>>
        </td>
	</tr>	 
	<%
		if(linecolor==0) {
			linecolor=1;
		}else{
			linecolor=0;
		}
	%> 
	<%}%>	
<%}%>
</table>

</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
</table>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
</table>
</div>
</form>

<%if(!ajax.equals("1")){%>
<script language="javascript">
function submitNodeData()
{
	if (check_form(opinionform,''))
		opinionform.submit();
}
</script>
<%}%>
</body>
</html>
