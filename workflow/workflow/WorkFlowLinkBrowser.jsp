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
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("15587",user.getLanguage())%>");
		}catch(e){}
	</script>	
</HEAD>
<%
String wfid=Util.null2String(request.getParameter("wfid"));
%>
<BODY>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onclear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
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
<wea:layout type="table" attributes="{'formTableId':'nodeTable','cols':'4','cws':'20%,20%,40%,20%'}">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item type="thead">ID</wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(15611,user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(33413,user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("15075,15587",user.getLanguage())%></wea:item>
		<%
		String linkName=null;
		String linkCondition=null;
		String linkId = null;
		String isReject = "0";
		
		StringBuffer printNodesSb=new StringBuffer();
		printNodesSb.append("select id,isreject,linkname,conditioncn from workflow_nodelink")
					.append(" where workflowId=").append(wfid);
		RecordSet.executeSql(printNodesSb.toString());
		while(RecordSet.next()){
			linkId = Util.null2String(RecordSet.getString("id"));
			linkName=Util.null2String(RecordSet.getString("linkname"));
			linkCondition=Util.null2String(RecordSet.getString("conditioncn"));
			isReject = Util.null2String(RecordSet.getString("isreject"));
		
		%>
			<wea:item><%=linkId%><input type="hidden" id="linkId" name="linkId" value='<%=linkId%>'/><input type="hidden" id="linkName" name="linkName" value='<%=linkName%>'/></wea:item>
			<wea:item><%=linkName%></wea:item>
			<wea:item><%=linkCondition%></wea:item>
			<wea:item><%=isReject.equals("1")?SystemEnv.getHtmlLabelName(236,user.getLanguage()):""%></wea:item>
		<%} %>
	</wea:group>
</wea:layout>
</FORM>
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
				var id = jQuery(this).children("td").eq(0).children("#linkId").val();
				var name = jQuery(this).children("td").eq(0).children("#linkName").val();
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
