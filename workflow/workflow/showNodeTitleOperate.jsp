
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser_wev8.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<body>
<%if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<%
int design = Util.getIntValue(request.getParameter("design"),0);
int wfid = Util.getIntValue(request.getParameter("wfid"),0);
int nodeid = Util.getIntValue(request.getParameter("nodeid"),0);

String nodetitle= Util.null2String(request.getParameter("nodetitle"));

String src = Util.null2String(request.getParameter("src"));

if(src.equals("")){
	RecordSet.executeSql("select nodetitle from workflow_flownode where workflowId="+wfid+" and nodeId="+nodeid);
	if(RecordSet.next()){
		nodetitle = Util.null2String(RecordSet.getString("nodetitle"));
	}
}

if(src.equals("save")){
	RecordSet.executeSql("update workflow_flownode set nodetitle='"+nodetitle+"' where workflowId="+wfid+" and nodeId="+nodeid);
}

%>

<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(68,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(21668,user.getLanguage()) ;
    String needfav = "";
    String needhelp = "";
%>

<%
if(design==0) {
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%
}
%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
if(design==1) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:designOnClose(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
else {
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="showNodeTitleOperate.jsp" method="post">
<input type="hidden" value="<%=wfid%>" name="wfid">
<input type="hidden" value="" name="src">
<input type="hidden" value="<%=nodeid%>" name="nodeid">
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

		    <TABLE class="viewform">
		    <COLGROUP>
		    <COL width="25%">
		    <COL width="75%">
		    <TR class="Title">
		        <TH colSpan=2><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></TH>
		    </TR>                                
		    <TR class="Spacing">
		        <TD class="Line1" colSpan=2></TD>
		    </TR>
		    <TR>
			    <TD><%=SystemEnv.getHtmlLabelName(21668,user.getLanguage())%></TD>
			    <TD class=Field>
				<INPUT class=InputStyle maxLength=10 size=20 name="nodetitle" value = "<%=nodetitle%>">
				</TD>
		    </TR>
		    <TR class="Spacing">
		        <TD class="Line" colSpan=2></TD>
		    </TR>
		    </TABLE>

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


</form>

</body>
</html>

<script language=javascript>

function onSave(){
	document.all("src").value="save";
	document.SearchForm.submit();
}


function onClose(){
    <%if(!"".equals(nodetitle)){%>
        window.parent.returnValue = "1"
    <%}else{%>
        window.parent.returnValue = "0"
    <%}%>
	window.parent.close();
}

<%
if(src.equals("save") && design==0){
%>
onClose();
<%
}	
%>
//工作流图形化确定
function designOnClose() {
	window.parent.design_callback('showNodeTitleOperate');
}
</script>



