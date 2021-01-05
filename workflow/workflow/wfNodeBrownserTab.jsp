<!DOCTYPE html>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />

<%
	int nodesmark = 0;
	int wfid=0;
	wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
	String action=Util.null2String(request.getParameter("action"));
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(wfid, 0, user, WfRightManager.OPERATION_CREATEDIR);
	if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<html>
<%
	WFNodeMainManager.resetParameter();
	int design = Util.getIntValue(request.getParameter("design"),0);
	String submitKey="";
	String total="";
	int currentnodeid=0;
	String saveIds="";
	String saveFlag="-1";//  "1"  代表 "全选" 或 "选择部分"
	total=Util.null2String(request.getParameter("total"));
	currentnodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
	submitKey = Util.null2String(request.getParameter("submitKey"));
	String[] selectIds = request.getParameterValues("check_node");
	
if("save".equals(submitKey)){
	
  if(selectIds!=null){

	if(!String.valueOf(selectIds.length).equals(total)){
		for(int i=0; i < selectIds.length; i++){
		  saveIds += ","+selectIds[i];
		}
		saveIds = saveIds.substring(1);
		RecordSet1.executeSql("select * from workflow_logviewnode where workflowid= " + wfid + " and nodeid = " + currentnodeid);
	    if(RecordSet1.next()){
			RecordSet1.executeSql("update workflow_logviewnode set viewnodeids='" + saveIds + "' where workflowid= " + wfid + " and nodeid = " + currentnodeid);
	    }else{
	    	RecordSet1.executeSql("insert into workflow_logviewnode(viewnodeids,workflowid,nodeid) values ('" + saveIds + "','"+wfid+"','"+currentnodeid+"')");
	    }
	}else{
		RecordSet1.executeSql("select * from workflow_logviewnode where workflowid= " + wfid + " and nodeid = " + currentnodeid);
	    if(RecordSet1.next()){
			RecordSet1.executeSql("update workflow_logviewnode set viewnodeids='-1' where workflowid= " + wfid + " and nodeid = " + currentnodeid);
	    }else{
	    	RecordSet1.executeSql("insert into workflow_logviewnode(viewnodeids,workflowid,nodeid) values ('-1','"+wfid+"','"+currentnodeid+"')");
	    }
	}
	
	saveFlag ="1";
	}
	
 else{
	 RecordSet1.executeSql("select * from workflow_logviewnode where workflowid= " + wfid + " and nodeid = " + currentnodeid);
	 if(RecordSet1.next()){
		RecordSet1.executeSql("update workflow_logviewnode set viewnodeids='" + saveIds + "' where workflowid= " + wfid + " and nodeid = " + currentnodeid);
	 }else{
	  	RecordSet1.executeSql("insert into workflow_logviewnode(viewnodeids,workflowid,nodeid) values ('','"+wfid+"','"+currentnodeid+"')");
	 }
	 saveFlag ="-1";
	}
	
}
	
WFManager.setWfid(wfid);
WFManager.getWfInfo();
String message = Util.null2String(request.getParameter("message"));
String viewIdsStr = "-1";
%>
<head>
<script language=javascript>
   <%if(action.equals("dialog")){%>
   		var parentWin = null;
		var dialog = null;
		try{
			parentWin = parent.parent.parent.getParentWindow(parent.parent);
			dialog = parent.parent.parent.getDialog(parent.parent);
		}catch(e){}
		
		function onClose(){
			if(dialog){
		    	dialog.close()
		    }else{
			    window.parent.close();
			}
		}
		//确定
		function onSure(){
		        var ids="",names="";
		        var nodesmark = 0;
		        jQuery("input[name=check_node]").each(function(){
		           if(jQuery(this).is(":checked")){
		              nodesmark++;
		              ids+= ","+jQuery(this).val();
		              names += ","+jQuery(this).attr("title");
		           }
		        });
		        ids = ids.substr(1);
		        names = names.substr(1);
		        var returnjson = {id:ids,name:names};
		        if(nodesmark == jQuery("#nodesmark").val()){
		        	returnjson = {id:"-1",name:"全部"};
		        }
				if(dialog){
					try{
						dialog.callback(returnjson);
					}catch(e){
					}
					dialog.close(returnjson);
		   		}else{ 
		   	        window.parent.returnValue  = returnjson;
		   	 	    window.parent.close();
		   	    }
		}
		//清除
		function onClear(){
		        var ids="-2",names="";
		        var returnjson = {id:ids,name:names};
				if(dialog){
					try{
						dialog.callback(returnjson);
					}catch(e){
					}
					dialog.close(returnjson);
		   		}else{ 
		   	        window.parent.returnValue  = returnjson;
		   	 	    window.parent.close();
		   	    }
		}
   <%}else{%>
	var dialog = parent.parent.getDialog(parent.window);
	//var parentWin = parent.parent.getParentWindow(parent);
	$(document).ready(function(){
  		resizeDialog(document);
	});
	<%}%>
</script>
<%
ArrayList list = new ArrayList();
if(action.equals("dialog")){
	RecordSet.executeSql("select viewnodeids from workflow_flownode where workflowid=" + wfid + " and nodeid = " +currentnodeid);
}else{
	RecordSet.executeSql("select viewnodeids from workflow_logviewnode where workflowid=" + wfid + " and nodeid = " +currentnodeid);
}
if(RecordSet.next()){
	viewIdsStr = RecordSet.getString("viewnodeids");
}else{
	RecordSet.executeSql("select viewnodeids from workflow_flownode where workflowid=" + wfid + " and nodeid = " +currentnodeid);
	if(RecordSet.next()){
		viewIdsStr = RecordSet.getString("viewnodeids");
	}
}
if("-1".equals(viewIdsStr)){//查看全部
	RecordSet.executeSql("select nodeid from workflow_flownode where workflowid=" + wfid+" and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and requestid is null )");
	while(RecordSet.next()){
		list.add(RecordSet.getString("nodeid"));
	}
}
else if( viewIdsStr == null || "".equals(viewIdsStr)){//全部不能查看
	viewIdsStr = "";
}
else{//部分可查看
String tempnodeids[] = Util.TokenizerString2(viewIdsStr, ",");
for(int i=0; i<tempnodeids.length; i++){
list.add(tempnodeids[i]);
}
}

%>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage());
if(message.equals("1")){

titlename = titlename + "<font color=red>Create" +SystemEnv.getHtmlLabelName(15595,user.getLanguage());
titlename = titlename +"!</font>";
}
String needfav ="1";
String needhelp ="";

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
   if(action.equals("dialog")){
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSure(),_self}" ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:onClose(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
   }else{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:save(),_self}" ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:closeWindow(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
   }
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content" style="height: 100%!important;">
<form id=weaver name=weaver method=post action="wfNodeBrownserTab.jsp">
<input type="hidden" value="<%=design%>" name="design">
<table id="topTitle" cellpadding="0" cellspacing="0" >
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan">
		    <%if(action.equals("dialog")){%>
		    <input type="button" value="<%=SystemEnv.getHtmlLabelName(826, user.getLanguage()) %>" class="e8_btn_top"  onclick="onSure();"/>&nbsp;&nbsp;
		    <%}else{%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" class="e8_btn_top"  onclick="save();"/>&nbsp;&nbsp;
			<%}%>
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15596,user.getLanguage())%>'>
		<wea:item attributes="{'isTableList':'true'}">
			<table class="ListStyle" cols=3 id="oTable" cellspacing=0> 
				<colgroup>
					<col width="25%">
					<col width="75%">
				</colgroup>
				<tr class=header> 
					<td>
					<input type='checkbox' name='check_all' <%if("-1".equals(viewIdsStr)){%>checked<%}%> onclick="selectAll()">
					<%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%>
					</td>
					<td><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></td>				            
				</tr>
				<%
				WFNodeMainManager.setWfid(wfid);
				WFNodeMainManager.selectWfNode(); 
				while(WFNodeMainManager.next()){
				nodesmark++;
				int tmpid = WFNodeMainManager.getNodeid();
				String tmpname = WFNodeMainManager.getNodename();
				String tmptype = WFNodeMainManager.getNodetype();
				%>
				<tr>
					<td  height="23"><input type='checkbox' name='check_node' value="<%=tmpid%>" <%if(list.contains(String.valueOf(tmpid))){%> checked <%}%> title="<%=tmpname%>"></td>
					<td  height="23">
					<%if(tmpid!=currentnodeid){%><%=tmpname%><%}else{%><b><%=tmpname%></b><%}%>
					</td>
				</tr>
				<tr class='Spacing' style="height:1px!important;"><td colspan=2 class='paddingLeft18'><div class='intervalDivClass'></div></td></tr> 
				<%}%>
			</table>	
			<input type="hidden" id="nodesmark" name="nodesmark" value="<%=nodesmark%>">
		</wea:item>
	</wea:group>
</wea:layout>
<center>
<input type="hidden" value="<%=wfid%>" name="wfid">
<input type="hidden" value="<%=currentnodeid%>" name="nodeid">
<input type="hidden" value="<%=total%>" name="total">
<input type="hidden" value="<%=submitKey%>" name="submitKey">
<center>
</form>
</div>

<script>
jQuery(document).ready(function(){
	jQuery("#oTable").find("tr[class=Spacing]:last").find("td").removeClass("paddingLeft18").addClass("paddingLeft0");
});
function selectAll(){
	var rows = document.all("check_node").length;
	if(document.all("check_all").checked){
	    for(var i=0; i < rows; i++){
	      var ckn = document.all("check_node")[i];
		  ckn.checked = true;	
		  $(ckn).next().addClass("jNiceChecked"); 
		}
	}else{
		for(var i=0; i < rows; i++){
			var ckn = document.all("check_node")[i];
		 	ckn.checked = false;	
		  	$(ckn).next().removeClass("jNiceChecked"); 
		}
	}
		
}

function save(){
	document.all("submitKey").value = "save";
	document.all("total").value = document.all("check_node").length;
	document.weaver.submit();
}

if("<%=submitKey%>" == "save"){
	closeWindow();
}
	
function closeWindow(){
	var design="<%=design %>";
	if(design=='1'){	//图形化工具打开
		var parentWin = parent.parent.getParentWindow(parent.window);
		parentWin.design_callback('wfNodeBrownser','<%="1".equals(saveFlag)?true:false %>');
	}
	dialog.close();
}

</script>
</body>
</html>
