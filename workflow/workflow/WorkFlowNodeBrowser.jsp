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
		try{
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("33417",user.getLanguage())%>");
		}catch(e){}
	</script>	
</HEAD>
<%
String wfid=Util.null2String(request.getParameter("wfid"));
String titlename = SystemEnv.getHtmlLabelName(18564,user.getLanguage());
String mouldID = Util.null2String(request.getParameter("mouldID"));
boolean hasHead = true;
if(mouldID.equals("")){
	hasHead = false;
}
%>
<BODY>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onclear(),_top} ";
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if(!hasHead){ %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
  		<jsp:param name="mouldID" value="workflow"/>
 		<jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>
<%} %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="WorkflowNodeBrowserMulti.jsp" method=post>
<wea:layout type="table" attributes="{'formTableId':'nodeTable','cols':'3','cws':'20%,40%,40%'}">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item type="thead">ID</wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(15536,user.getLanguage())%></wea:item>
		<%
		String tempPrintNodes=null;
		String tempPrintNodesName=null;
		String tempPrintNodesType=null;
		
		StringBuffer printNodesSb=new StringBuffer();
		printNodesSb.append(" select a.nodeId,b.nodeName,a.nodeType ")
					.append(" from  workflow_flownode a,workflow_nodebase b")
					.append(" where a.workflowId=").append(wfid)
					.append(" and a.nodeid=b.id")
					//添加本条件, 限制查询条件不包括自由流转中的节点
					.append(" and (b.isFreeNode != '1' OR b.isFreeNode IS null)")
					.append(" order by nodeorder asc")
					.append(" ,a.nodeType asc")	
					.append(" ,a.nodeId asc")			
					;
		RecordSet.executeSql(printNodesSb.toString());
		while(RecordSet.next()){
			tempPrintNodes=Util.null2String(RecordSet.getString("nodeId"));
			tempPrintNodesName=Util.null2String(RecordSet.getString("nodeName"));
			tempPrintNodesType=Util.null2String(RecordSet.getString("nodeType"));
		
		%>
			<wea:item><%=tempPrintNodes%><input type="hidden" id="nodeid" name="nodeid" value='<%=tempPrintNodes%>'/><input type="hidden" id="nodename" name="nodename" value='<%=tempPrintNodesName%>'/></wea:item>
			<wea:item><%=tempPrintNodesName%></wea:item>
			<wea:item>
				<%if(tempPrintNodesType.equals("0")){%><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%><%}%>
				<%if(tempPrintNodesType.equals("1")){%><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%><%}%>
				<%if(tempPrintNodesType.equals("2")){%><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%><%}%>
				<%if(tempPrintNodesType.equals("3")){%><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%><%}%>
			</wea:item>
		<%} %>
	</wea:group>
</wea:layout>
</FORM>
<%if(!hasHead){ %>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
<%} %>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="onclear();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
			jQuery("#nodeTable").find("tbody").find("td").css("cursor","pointer");
			jQuery("#nodeTable").find("tbody").find("tr[class!='Spacing']").bind("click",function(){
				var id = jQuery(this).children("td").eq(0).children("#nodeid").val();
				var name = jQuery(this).children("td").eq(0).children("#nodename").val();
				var returnjson  = {id:id,name:name} ;
				if(dialog){
				    dialog.callback(returnjson);
				}else{  
				    window.parent.returnValue  = returnjson;
				    window.parent.close();
				}     
			});
		});
	</script>
</div>
</BODY></HTML>
<script language="javascript">


function js_btnclear_onclick(){
	var returnjson = {id:"",name:""};
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}     
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
