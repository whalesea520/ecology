<!DOCTYPE html>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<script type="text/javascript">
		var parentWin = parent.parent.getParentWindow(parent);
		var dialog = parent.parent.getDialog(parent);
	</script>
</HEAD>
<%
String wfid=Util.null2String(request.getParameter("wfid"));
String workflowId = wfid.split("_")[0];
List printNodesList=Util.TokenizerString(wfid.split("_")[1],",");
%>
<BODY>
<div class="zDialog_div_content" style="height: 100%!important;">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSure(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onclear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:onClose(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(81822,user.getLanguage())%>"/>
</jsp:include>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="WorkflowNodeBrowserMulti.jsp" method=post>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" id="zd_btn_cancle"  class="e8_btn_top" onclick="onSure()">
			<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<TABLE ID=BrowseTable class=ListStyle cellspacing=0 STYLE="margin-top:0">
<TR class=header>
<TH width=30%><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(15611,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(125082,user.getLanguage()) %></TH>
</tr>
<%
int i=0;
int rowNum=0;
String tempPrintNodes=null;
String tempPrintNodesName=null;
String tempPrintlinkname=null;
String isbulidcode=null;

StringBuffer printNodesSb=new StringBuffer();
printNodesSb.append(" SELECT a.id,a.nodeid,a.linkname,a.linkorder,a.isbulidcode,b.nodename ")
			.append(" FROM workflow_nodelink a,workflow_nodebase b, workflow_nodebase c ")
			.append(" WHERE wfrequestid IS NULL ")
			.append(" AND a.nodeid = b.id AND workflowid= ").append(workflowId)
			.append(" AND (b.isFreeNode != '1' OR b.isFreeNode IS null) ")
            .append(" AND a.destnodeid = c.id AND (c.isFreeNode != '1' OR c.isFreeNode IS null) ")
			.append(" ORDER BY a.linkorder,a.nodeid,a.id ");

//System.out.println("printNodesSb.toString() = "+printNodesSb.toString());
RecordSet.executeSql(printNodesSb.toString());
while(RecordSet.next()){
	tempPrintNodes=Util.null2String(RecordSet.getString("id"));
	tempPrintNodesName=Util.null2String(RecordSet.getString("nodeName"));
	tempPrintlinkname=Util.null2String(RecordSet.getString("linkname"));
	isbulidcode=Util.null2String(RecordSet.getString("isbulidcode"));
	
	if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
	<%
	}
	%>
    <input type="hidden" id="printNodes_<%=rowNum%>" name="printNodes_<%=rowNum%>" value="<%=tempPrintNodes%>">
    <input type="hidden" id="printNodesName_<%=rowNum%>" name="printNodesName_<%=rowNum%>" value="<%=tempPrintlinkname%>">
	<TD><%=tempPrintNodesName%></TD>
	<TD><%=tempPrintlinkname %></TD>
	<TD><input type="checkbox" value="1" name="checkbox_<%=rowNum%>" id="checkbox_<%=rowNum%>" <%=printNodesList.contains(tempPrintNodes)?"checked":""%>></TD>	
</TR>
<%
	rowNum++;
}
%>

<input type="hidden" id="rowNum" name="rowNum" value="<%=rowNum%>">
</TABLE></FORM>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
				<input type="button" accessKey=O  id=btnok  value="<%="O-"+SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" id="zd_btn_submit_0" class="zd_btn_submit" onclick="onSure();">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="onclear();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
			//jquery(".zDialog_div_content").css("height","100%");
		});
	</script>
</div>
</div>
</BODY></HTML>
<script language="javascript">
function onSure(){
    var printNodes="";
    var printNodesName="";
	var rowNum=document.getElementById("rowNum").value;

	for(i=0;i<rowNum;i++){
		if(document.getElementById("checkbox_"+i).checked){
			printNodes=printNodes+","+document.getElementById("printNodes_"+i).value;
			printNodesName=printNodesName+","+document.getElementById("printNodesName_"+i).value;
		}
	}
    if(printNodes!=""){
		printNodes=printNodes.substr(1);
		printNodesName=printNodesName.substr(1);
	}
	
  	var returnjson  = {id:printNodes,name:printNodesName} ;
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}     
}


function js_btnclear_onclick(){
	var returnjson = {id:"",name:""};
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}     
}

function checkAll(){
	var rowNum=document.getElementById("rowNum").value;
	for(i=0;i<rowNum;i++){
		document.getElementById("checkbox_"+i).checked = true;
	}
	onSure();
}

function onclear(){
    js_btnclear_onclick();
}

function onClose()
{
	if(dialog){
	    dialog.close();
	}else{  
		window.parent.close() ;
	}	
}
</script>