<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FlowExceptionHandle" class="weaver.workflow.request.FlowExceptionHandle" scope="page" />
<html>
<head>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
	String fromWhere = Util.null2String(request.getParameter("fromWhere"));
	int workflowid=Util.getIntValue(Util.null2String(request.getParameter("workflowid")),0);
	int nodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
	String sql = "";
	String navName = "";
	if("exceptionHandle".equals(fromWhere)){		//空岗跳过选择指定节点
		navName = SystemEnv.getHtmlLabelNames("172,33417", user.getLanguage());
		sql = " select nb.id,nb.nodename,fn.nodetype from workflow_nodebase nb,workflow_flownode fn "
			+ " where nb.id=fn.nodeid and fn.workflowid="+workflowid+" and nb.id<>"+nodeid+" and (nb.IsFreeNode is null or nb.IsFreeNode<>'1') ";
		int nodeattribute = FlowExceptionHandle.getNodeAttribute(workflowid, nodeid);
		if(nodeattribute == 2){		//分叉中间点
			String branchNodes = FlowExceptionHandle.getCurrentBranchAllNodes(workflowid, nodeid);
			sql += " and fn.nodeid in ("+branchNodes+") ";		//分叉中间点只能选择当前分支的分叉中间点及合并点
		}else{
			sql += " and nb.nodeattribute<>'2' ";				//一般节点不能选择分叉中间点
		}
		sql += " order by fn.nodeorder, fn.nodetype,nb.id";
	}else{
		navName = SystemEnv.getHtmlLabelName(31857, user.getLanguage());
		
		sql = " select nb.id,nb.nodename,fn.nodetype from workflow_nodebase nb,workflow_flownode fn "
			+ " where nb.id=fn.nodeid and fn.workflowid="+workflowid+" and nb.id<>"+nodeid+" and (nb.IsFreeNode is null or nb.IsFreeNode<>'1') ";
		int nodeattribute = FlowExceptionHandle.getNodeAttribute(workflowid, nodeid);
		if(nodeattribute == 2){		//分叉中间点
			String branchNodes = FlowExceptionHandle.getCurrentBranchAllNodes(workflowid, nodeid);
			sql += " and fn.nodeid in ("+branchNodes+") ";		//分叉中间点只能选择当前分支的分叉中间点及合并点
		}else{
			sql += " and nb.nodeattribute<>'2' ";				//一般节点不能选择分叉中间点
		}
		sql += " order by fn.nodeorder, fn.nodetype,nb.id";
	}
	RecordSet.executeSql(sql);
%>
<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=navName %>"/>
</jsp:include>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:doClear(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:doClose(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<TABLE id="BrowseTable" class=ListStyle cellspacing=0 STYLE="margin-top:0">
<TR class=header>
	<TH style="display:none;"></TH>
	<TH width=60%><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></TH>
	<TH width=40%><%=SystemEnv.getHtmlLabelName(15536,user.getLanguage())%></TH>
</TR>
<%
int rownum=0;
String nodetype="";
while(RecordSet.next()){
	rownum++;
	nodetype=Util.null2String(RecordSet.getString("nodetype"));
	if(rownum%2==1){
	%>
		<TR class=DataLight>
 <% }else{%>
		<TR class=DataDark>
 <% } %>
			<TD style="display:none;"><%=Util.null2String(RecordSet.getString("id")) %></TD>
			<TD><%=Util.null2String(RecordSet.getString("nodename")) %></TD>
			<TD>
				<%if(nodetype.equals("0")){%><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%><%}%>
				<%if(nodetype.equals("1")){%><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%><%}%>
				<%if(nodetype.equals("2")){%><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%><%}%>
				<%if(nodetype.equals("3")){%><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%><%}%>
			</TD>
		</TR>
<%}%>
</TABLE>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
		    <wea:group context="">
		    	<wea:item type="toolbar">
		    		<input class="zd_btn_cancle" type="submit" id="btnClose" onclick="doClose();" 
		    			value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
		    	</wea:item>
		    </wea:group>
		</wea:layout>
</div>
<script language=javascript>
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
jQuery(document).ready(function(){
	$("#BrowseTable").find("tr[class!='Spacing']").bind("click",function(){
		var returnjson = {id:$(this).find("td:eq(0)").text(),name:$(this).find("td:eq(1)").text()};
		if(dialog){
			dialog.callback(returnjson);
		}else{
		    window.parent.returnValue=returnjson;
    		window.parent.close();
		}
	});
});

function doClear(){
	var returnjson ={id:"",name:""};
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}
}

function doClose(){
	if(dialog){
		dialog.close();
	}else{
		window.parent.close();
	}
}
</script>
</body>
</html>