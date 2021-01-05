<!DOCTYPE html>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<%
    String ajax=Util.null2String(request.getParameter("ajax"));
	int wfid=0;
	wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(wfid, 0, user, WfRightManager.OPERATION_CREATEDIR);
	if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%WFNodeMainManager.resetParameter();%>
<html>
<%
	String wfname="";
	String wfdes="";
	String title="";
	String isTemplate="";
	int formid=0;
    String isbill = "";
    String isFree = "0";
	title="edit";
	WFManager.setWfid(wfid);
	WFManager.getWfInfo();
	wfname=WFManager.getWfname();
	wfdes=WFManager.getWfdes();
	
	formid = WFManager.getFormid();
    isbill = WFManager.getIsBill();
    isTemplate=WFManager.getIsTemplate();
    isFree = WFManager.getIsFree();
	String message = Util.null2String(request.getParameter("message"));
	int rowsum=0;
	WorkflowVersion  wfversion = new WorkflowVersion(wfid+"");
%>
<head>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<link type="text/css" href="/js/ecology8/base/jquery-ui_wev8.css" rel=stylesheet>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/dojo_wev8.js"></script>
<script type="text/javascript" src="/js/tab_wev8.js"></script>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage());
if(message.equals("1")){

titlename = titlename + "<font color=red>Create" +SystemEnv.getHtmlLabelName(15595,user.getLanguage());
titlename = titlename +"!</font>";
}
String needfav ="";
String needhelp ="";
%>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
if( !isFree.equals("1") ){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(15598,user.getLanguage())+",javascript:addRow(event),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%
if( !isFree.equals("1") ){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(15599,user.getLanguage())+",javascript:subclear(event),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:selectall(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
    if(!ajax.equals("1"))
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:history.back(-1),_self}" ;
    else
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:cancelEditNode(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script type="text/javascript">
function checknumber(objectname)
{
    var objvalue = objectname.value ; 
    var isnumber = false ;
    if(isNaN(parseInt(objvalue))) {
        isnumber = true ;
    }
    //if(window.console) console.log("isnumber = "+isnumber+" objvalue = "+objvalue);
    if(isnumber) {
        objectname.value = "" ;
    }else{
    	if(parseInt(objvalue)>100){
    		objectname.value = "100" ;
    		//if(window.console) console.log("objvalue = 100/"+objvalue);
        }else{
        	objectname.value = parseInt(objvalue) ;    
        }
    }    
}
</script>
<form id=nodeform name=nodeform method=post action="wf_operation.jsp">
<%
    if(ajax.equals("1")){
%>
<input type=hidden name=ajax value="1">
<%
    }
%>
<% String needcheck=""; %>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15596,user.getLanguage())%>' attributes="{'groupOperDisplay':'none'}">

		<%
		//当不是自由流程时，才可以增加或者删除节点 
		if( !isFree.equals("1") ){
		%>
		<wea:item type="groupHead">
 		  	<button Class=addbtn type=button accessKey=A onclick="addRow(event)" title="<%=SystemEnv.getHtmlLabelName(15598,user.getLanguage())%>"></button>
		  	<button Class=delbtn type=button accessKey=D onclick="subclear(event)" title="<%=SystemEnv.getHtmlLabelName(15599,user.getLanguage()) %>"></button> 		
		</wea:item>
		<%	
		}
		%>
		
		<wea:item attributes="{'isTableList':'true'}">
			<table class="ListStyle" cellspacing=0  cols=4 id="oTableAddwfnode">
				<colgroup>
					<col width="10%">
					<col width="30%">
					<col width="30%">
					<col width="30%">
				</colgroup>
				<tr class="header notMove">
					<td><input type='checkbox' name='check_nodeAll' onclick="changeCheck(this);"></td>
					<td><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></td>
					<td><%=SystemEnv.getHtmlLabelName(15536,user.getLanguage())%></td>
					<td><%=SystemEnv.getHtmlLabelName(21393,user.getLanguage())%></td>
				</tr>
				<tr class='Spacing' style="height:1px!important;"><td colspan=4 class='paddingLeft18'><div class='intervalDivClass'></div></td></tr>
				<%
				WFNodeMainManager.setWfid(wfid);
				WFNodeMainManager.selectWfNode(); 
				while(WFNodeMainManager.next()){
					int tmpid = WFNodeMainManager.getNodeid();
					String tmpname = WFNodeMainManager.getNodename();
					String tmptype = WFNodeMainManager.getNodetype();
					int tmporder = WFNodeMainManager.getNodeorder();
					String tmpattribute = WFNodeMainManager.getNodeattribute();
					int tmppassnum = WFNodeMainManager.getNodepassnum();
					needcheck += ",node_"+rowsum+"_name";
					String disabledWhenIsFree = "";
					if( isFree.equals("1") ){
						disabledWhenIsFree = "disabled";
					}
				%>
				<tr>
					<td  height="23"><input type='checkbox' name='check_node' value="<%=tmpid%>" >&nbsp;<img moveimg src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>' /></td>
					<td  height="23">
						<input type="hidden" name="node_<%=rowsum%>_id" value="<%=tmpid%>">
						<input type="hidden" name="node_order_<%=rowsum%>" value="<%=tmporder %>">
						<input class=Inputstyle type="text" name="node_<%=rowsum%>_name" value="<%=tmpname%>" onblur="checkinput('node_<%=rowsum%>_name','node_<%=rowsum%>_namespan');checkSameName(<%=rowsum%>,this.value)" maxlength=30>
						<span id="node_<%=rowsum%>_namespan"><%if(tmpname.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
					</td>
					<td  height="23">
						<%
						//当为自由流程时，禁用select后，此隐藏域用于传值

						if( isFree.equals("1") ){
						%>
							<input type="hidden" name="node_<%=rowsum%>_type" value="<%=tmptype%>" />
						<%
						}
						%>
						<select class=inputstyle  name="node_<%=rowsum%>_type" <%=disabledWhenIsFree%>>
						    <option value="-1">********<%=SystemEnv.getHtmlLabelName(15597,user.getLanguage())%>***********</option>
						    <option value="0" <%if(tmptype.equals("0")){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%></strong>
						    <option value="1" <%if(tmptype.equals("1")){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></strong>
						    <option value="2" <%if(tmptype.equals("2")){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></strong>
						    <option value="3" <%if(tmptype.equals("3")){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></strong>
						</select>
					</td>
					<td  height="23">
						<%
						//当为自由流程时，禁用select后，此隐藏域用于传值

						if( isFree.equals("1") ){
						%>
							<input type="hidden" name="node_<%=rowsum%>_attribute" value="<%=tmpattribute%>" />
						<%
						}
						%>
						<select class=inputstyle  name="node_<%=rowsum%>_attribute" onchange=changeattri(this) <%=disabledWhenIsFree%>>
						    <option value="0" <%if(tmpattribute.equals("0")){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></strong></option>
						    <option value="1" <%if(tmpattribute.equals("1")){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(21394,user.getLanguage())%></strong></option>
						    <option value="2" <%if(tmpattribute.equals("2")){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(21395,user.getLanguage())%></strong></option>
						    <option value="3" <%if(tmpattribute.equals("3")){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(21396,user.getLanguage())%></strong></option>
						    <option value="4" <%if(tmpattribute.equals("4")){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(21397,user.getLanguage())%></strong></option>
						    <option value="5" <%if(tmpattribute.equals("5")){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(126603,user.getLanguage())%></strong></option>
						</select>
					    <input type='input' class='InputStyle' size='5' maxlength=3 name='node_<%=rowsum%>_passnum' style='width:30px;<%if(!tmpattribute.equals("3")&&!tmpattribute.equals("5")){%>display:none;<%}%>' value="<%=tmppassnum%>" onkeyup=checknumber(this) onBlur="checkcount1(this);checknumber(this)">
					    <span id="p_<%=rowsum%>" style='<%if(!tmpattribute.equals("5")){%>display:none;<%} %>'>%</span>
					    <SPAN class='.e8tips' style='CURSOR: hand;<%if(!tmpattribute.equals("5")){%>display:none;<%} %>' id='remind_<%=rowsum%>' title='<%=SystemEnv.getHtmlLabelName(126604,user.getLanguage()) %>'><IMG id='ext-gen124' align='absMiddle' src='/images/remind_wev8.png'></SPAN>
					    
					</td>    
				</tr>
				<tr class='Spacing' style="height:1px!important;"><td colspan=4 class='paddingLeft18'><div class='intervalDivClass'></div></td></tr>
				<%
				rowsum += 1;
				}
				%>
			</table>		
		</wea:item>
	</wea:group>
</wea:layout>
<center>
<input type="hidden" value="wfnodeadd" name="src" id="src">
<input type="hidden" value="<%=wfid%>" name="wfid" id="wfid">
<input type="hidden" value="<%=formid%>" name="formid" id="formid">
<input type="hidden" value="0" name="nodesnum" id="nodesnum">
<input type="hidden" value="" name="delids" id="delids">
<input type="hidden" value="<%=isbill%>" name="isbill" id="isbill">
<input type="hidden" value="<%=needcheck%>" name="needcheck" id="needcheck" >
<!-- 是否保存新版本，并将所有改动在新版本上体现 -->
<input type="hidden" value="0" name="isSaveNewVersionAndEdit" id="isSaveNewVersionAndEdit" >
<input type="hidden" value="<%=wfid%>" name="newversionWFID" id="newversionWFID">
<center>
</form>
<script type="text/javascript">
jQuery(document).ready(function(){
	jQuery("#oTableAddwfnode").find("tr[class=Spacing]:last").find("td").removeClass("paddingLeft18").addClass("paddingLeft0");
	registerDragEvent();
	jQuery("tr.notMove").bind("mousedown", function() {
		return false;
	});
	jQuery("span[id^=remind]").wTooltip({html:true});
});
jQuery(function(){
	$("#oTableAddwfnode").find("tr")
	.live("mouseover",function(){$(this).find("img[moveimg]").attr("src","/proj/img/move-hot_wev8.png")})
	.live("mouseout",function(){$(this).find("img[moveimg]").attr("src","/proj/img/move_wev8.png")});
});
function registerDragEvent() {
	var fixHelper = function(e, ui) {
		ui.children().each(function() {
		    $(this).width($(this).width()); // 在拖动时，拖动行的cell（单元格）宽度会发生改变。在这里做了处理就没问题了

		    $(this).height($(this).height());
		});
		return ui;
	};

	var copyTR = null;
	var startIdx = 0;

	jQuery("#oTableAddwfnode tbody tr").bind("mousedown", function(e) {
		copyTR = jQuery(this).next("tr.Spacing");
	});
        
    jQuery("#oTableAddwfnode tbody").sortable({ // 这里是talbe tbody，绑定 了sortable
        helper: fixHelper, // 调用fixHelper
        axis: "y",
        start: function(e, ui) {
        	ui.helper.addClass("moveMousePoint");
            ui.helper.addClass("e8_hover_tr") // 拖动时的行，要用ui.helper
            if(ui.item.hasClass("notMove")) {
            	e.stopPropagation && e.stopPropagation();
            	e.cancelBubble = true;
            }
            if(copyTR) {
       			copyTR.hide();
       		}
       		startIdx = ui.item.get(0).rowIndex;
            return ui;
        },
        stop: function(e, ui) {
        	jQuery(ui.item).removeClass("moveMousePoint");
            ui.item.removeClass("e8_hover_tr"); // 释放鼠标时，要用ui.item才是释放的行
        	if(ui.item.get(0).rowIndex < 1) { // 不能拖动到表头上方

                if(copyTR) {
           			copyTR.show();
           		}
        		return false;
        	}
           	if(copyTR) {
	       	  	/* if(ui.item.get(0).rowIndex > startIdx) {
	        	  	ui.item.before(copyTR.clone().show());
				}else {
	        	  	ui.item.after(copyTR.clone().show());
				} */
				if(ui.item.prev("tr").attr("class") == "Spacing") {
					ui.item.after(copyTR.clone().show());
				}else {
					ui.item.before(copyTR.clone().show());
				}
	       	  	copyTR.remove();
	       	  	copyTR = null;
       		}
           	return ui;
        }
    });
}

function changeCheck(vthis){
	var flag=$(vthis).attr("checked");
	if(flag){
		$("[name='check_node']").attr("checked",true).next().addClass("jNiceChecked");
	}else{
		$("[name='check_node']").attr("checked",false).next().removeClass("jNiceChecked");
	}
}

</script>
<%
    if(ajax.equals("1")){
%>
<div id=noderowsum style="display:none;"><%=rowsum%></div>
<script type="text/javascript">
var rowindex = -1;
var delids = "";
function addRow(evt)
{
	evt.stopPropagation && evt.stopPropagation();
	evt.cancelBubble = true;
	//ypc 2012-09-03 声明oTable
	var oTable = null;
	oTable = $G("oTableAddwfnode");
	if(rowindex == -1)
    rowindex=$GetEle("noderowsum").innerHTML;
    ncol = jQuery(oTable).attr("cols");
	oRow = oTable.insertRow(-1);

	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height=24;
		oCell.style.background= "";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node' value='0'>&nbsp;<img moveimg src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>' />";
				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<select class=inputstyle  name='node_"+rowindex+"_type'><option value='-1'>********<%=SystemEnv.getHtmlLabelName(15597, user.getLanguage())%>***********</option><option value='0'><strong><%=SystemEnv.getHtmlLabelName(125, user.getLanguage())%></strong><option value='1'><strong><%=SystemEnv.getHtmlLabelName(142, user.getLanguage())%></strong><option value='2'><strong><%=SystemEnv.getHtmlLabelName(615, user.getLanguage())%></strong><option value='3'><strong><%=SystemEnv.getHtmlLabelName(251, user.getLanguage())%></strong></select>";
				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='hidden' name='node_order_" + rowindex + "' value=''><input type='input' class='InputStyle'name='node_"+rowindex+"_name' onblur='checkinput(\"node_"+rowindex+"_name\",\"node_"+rowindex+"_namespan\");checkSameName("+rowindex+",this.value)' maxlength=30><span id='node_"+rowindex+"_namespan'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				break;
            case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<select class=inputstyle  name='node_"+rowindex+"_attribute' onchange=changeattri(this)><option value='0'><%=SystemEnv.getHtmlLabelName(154, user.getLanguage())%></option><option value='1'><%=SystemEnv.getHtmlLabelName(21394, user.getLanguage())%></option><option value='2'><%=SystemEnv.getHtmlLabelName(21395, user.getLanguage())%></option><option value='3'><%=SystemEnv.getHtmlLabelName(21396, user.getLanguage())%></option><option value='4'><%=SystemEnv.getHtmlLabelName(21397, user.getLanguage())%></option><option value='5'><%=SystemEnv.getHtmlLabelName(126603, user.getLanguage())%></option></select><input type='input' class='InputStyle' size='5' maxlength=3 name='node_"+rowindex+"_passnum' style='display:none;width:30px;' onkeyup='checknumber(this)' onBlur='checkcount1(this);checknumber(this)' ><span id='p_"+rowindex+"' style='display:none;'>%</span><SPAN class='.e8tips' style='CURSOR: hand;display:none;' id='remind_"+rowindex+"' title='<%=SystemEnv.getHtmlLabelName(126604,user.getLanguage()) %>'><IMG id='ext-gen124' align='absMiddle' src='/images/remind_wev8.png'></SPAN>";
				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				break;
        }
	}
	$G("needcheck").value = $G("needcheck").value+",node_"+rowindex+"_name";
	rowindex = rowindex*1 +1;
	jQuery("body").jNice();
	beautySelect();//美化下拉框组件

	//reflash();

}

function subclear(evt){
	evt.stopPropagation && evt.stopPropagation();
	evt.cancelBubble = true;

	var flag = false;
	var ids = document.getElementsByName('check_node');
	for(i=0; i<ids.length; i++) {
		if(ids[i].checked==true) {
			flag = true;
			break;
		}
	}
    if(flag) {
		var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
		top.Dialog.confirm(str, function (){
			deleteRow1("oTableAddwfnode");
		}, function () {}, 320, 90,true);
		
    }else{
    	top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}

function deleteRow1(oTableName){
   //xtp 2014-07-16
	
    $(document.nodeform.elements).each(function(){
    	if($(this).attr("name") === "check_node")
    	{
    		if($(this).is(":checked")){
    			if($(this).val() != 0)
    				delids +=","+ $(this).val();
   				$(this).closest("tr").remove();
    		}
    	}
    });
    //var oTable = null;
	//if (oTableName != null && oTableName != undefined) {
	//	oTable = $G(oTableName);
	//}
    //if(rowindex == -1)
    //	rowindex=document.all("noderowsum").innerHTML;
    //len = document.nodeform.elements.length;
	//var i=0;
	//var rowsum1 = 0;
	//for(i=len-1; i >= 0;i--) {
	//	if (document.nodeform.elements[i].name=='check_node')
	//	{
	//		alert(document.nodeform.elements[i].checked+"");
	//		rowsum1 += 1;
	//	}
	//}
	//for(i=len-1; i >= 0;i--) {
	//	if (document.nodeform.elements[i].name=='check_node'){
	//		if(document.nodeform.elements[i].checked==true) {
	//			if(document.nodeform.elements[i].value!='0')
	//				delids +=","+ document.nodeform.elements[i].value;
	//			oTable.deleteRow(rowsum1);
	//		}
	//		rowsum1 -=1;
	//	}
	//
	//}
}

function selectall(){
	enableAllmenu();
    var needcheck = $G("needcheck").value;
    if(check_form(nodeform,needcheck)){
    if(rowindex == -1){
		rowindex=$G("noderowsum").innerHTML;
	}
    try{
    	var createnodes = 0;
    	var processednodes = 0;
    	var processpointstart = 0;
    	var processpointmiddle = 0;
    	var processpointend3 = 0;
    	var processpointend4 = 0;
    	var processpointend5 = 0;
    	if(rowindex>0){
	    	for(i=0;i<rowindex;i++){
				try{
					if($GetEle("node_"+i+"_name"))
					{
						var nodename = $GetEle("node_"+i+"_name").value;
						
						if(nodename.indexOf("<")>-1||nodename.indexOf(">")>-1||nodename.indexOf("'")>-1||nodename.indexOf(",")>-1||nodename.indexOf("\"")>-1)
						{
							top.Dialog.alert("<%=Util.toHtml(SystemEnv.getHtmlLabelName(25775, user.getLanguage()))%>");
							$GetEle("node_"+i+"_name").focus();
							displayAllmenu();
							return;
						}
					}
					
					if($GetEle("node_"+i+"_type").value==-1){
						top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15597, user.getLanguage())%>");
						displayAllmenu();
						return;
					}else if($GetEle("node_"+i+"_type").value==0){
					    createnodes = createnodes+1;
					}else if($GetEle("node_"+i+"_type").value==3){
					    processednodes = processednodes+1;
					}else if($GetEle("node_"+i+"_type").value==5){
					    processednodes = processednodes+1;
					}
				}catch(e){ }
				try{
					if($GetEle("node_"+i+"_attribute").value==1){
						processpointstart++;
					}
					if($GetEle("node_"+i+"_attribute").value==2){
						processpointmiddle++;
					}
					if($GetEle("node_"+i+"_attribute").value==3){
						processpointend3++;
					}
					if($GetEle("node_"+i+"_attribute").value==4){
						processpointend4++;
					}
					if($GetEle("node_"+i+"_attribute").value==5){
						processpointend5++;
					}
				}catch(e){}
	    	}
	    }
	    /*
	    if(processpointstart>1){
	    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(25489, user.getLanguage())%>");
			displayAllmenu();
	    	return;
	    }
	    */
	    //必须有一个分叉起始点
	    if(processpointstart==0){
	    	if(processpointmiddle !=0 || processpointend3 !=0 || processpointend4 !=0|| processpointend5 !=0){
	    		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(25492, user.getLanguage())%>");
				displayAllmenu();
		    	return;
	    	}
	    }
	    //如果有分叉起始点，有且仅有一个通过分支数合并或指定通过分支合并。

		
		/*
	    if(processpointstart==1){
	    	if((processpointend3+processpointend4)!=1){
	    		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(25493, user.getLanguage())%>");
				displayAllmenu();
		    	return;
	    	}
	    }
	    */
	    
	    if(createnodes!=1){
	    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15595, user.getLanguage())%>");
			displayAllmenu();
	       return;
	    }
	    if(processednodes<1){
	    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(25218, user.getLanguage())%>");
			displayAllmenu();
	       return;
	    }
	    
	    $("input[name^='node_order_']").each(function(i) {
			jQuery(this).val(i+1);
		});
	    
  	}catch(e){
  		top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(127353, user.getLanguage())%>' + e.message + '<%=SystemEnv.getHtmlLabelName(129423, user.getLanguage())%>' +   e.lineNumber + '<%=SystemEnv.getHtmlLabelName(126639, user.getLanguage())%>');
		displayAllmenu();
  	}
  	document.nodeform.nodesnum.value=rowindex;
	document.nodeform.delids.value=delids;
	document.nodeform.isSaveNewVersionAndEdit.value = "0";
    if (<%=wfversion.isActive() %> && delids != null && delids != "" && '1' != '<%=isTemplate%>') {
    	confirmContent = "<%=SystemEnv.getHtmlLabelName(129424, user.getLanguage())%>";
    	window.top.Dialog.confirm(
			confirmContent,
			    alterCurrVersion
			, function () {
				document.nodeform.nodesnum.value = "0";
				document.nodeform.delids.value = "";
				displayAllmenu();
			}, 520, 90, true, {name:'<%=SystemEnv.getHtmlLabelName(129425, user.getLanguage())%>', click:saveAsNewVersionAndEdit},
			'<%=SystemEnv.getHtmlLabelName(129426, user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>', window);
    } else {
		document.nodeform.submit(); 	
    }
   }else{
	displayAllmenu();
   }
}
/**
*修改当前版本
*/
function alterCurrVersion() {
    tab3oldurl="";
    tab4oldurl="";
    tab6oldurl="";
    tab000001OldURL="";
    document.nodeform.isSaveNewVersionAndEdit.value = "0";
    doPost(document.nodeform,parent.tab2, doPostCallback); 
}

/**
 * 存为新版
 */
function saveAsNewVersionAndEdit() {
    tab3oldurl="";
    tab4oldurl="";
    tab6oldurl="";
    tab000001OldURL="";
    document.nodeform.isSaveNewVersionAndEdit.value = "1";
    doPost(document.nodeform,parent.tab2, doPostCallback); 
}

function doPostCallback() {
	var newVersionwfid = "";
	var loadinterval = window.setInterval(function () {
		newVersionwfid = jQuery("#newversionWFID").val();
		if (newVersionwfid != undefined && newVersionwfid != "") {
			window.clearInterval(loadinterval);
    		var url="/workflow/workflow/Editwfnode.jsp?ajax=1&wfid=" + newVersionwfid + "&isTemplate=<%=isTemplate %>";
    		window.location.href = url;
		}
	}, 200);
}

function checkSameName(thisrowindex,thisvalue){
    try{
        if(rowindex == -1){
            rowindex=$G("noderowsum").innerHTML;
        }
        if(rowindex>0){
            for(i=0;i<rowindex;i++){
                if(thisrowindex!=i){
                    if(thisvalue!=""&&thisvalue==$G("node_"+i+"_name").value){
                    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(25217, user.getLanguage())%>！");
                        $G("node_"+thisrowindex+"_name").value = "";
                        $G("node_"+thisrowindex+"_namespan").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
                    }
                }
            }
        }
    }catch(e){}
}

function changeattri(obj){
    var attriname=obj.name;
    var passnumname=attriname.substring(0,attriname.length-9)+"passnum";
    var attrinamearry = attriname.split("_");
    var rowindex = attrinamearry[1];
    //if(window.console) console.log("rowindex="+rowindex+" passnumname="+passnumname);
    try{
        var passnumobj = jQuery("input[name='"+passnumname+"']");
	    if(obj.value=="3"){
	        jQuery(passnumobj).show();
	    	jQuery("#p_"+rowindex).hide();
	    	jQuery("#remind_"+rowindex).hide();
	    	jQuery(passnumobj).val("");
	    }else if(obj.value=="5"){
	    	jQuery(passnumobj).show();
	    	jQuery(passnumobj).val("100");
	    	
	    	jQuery("#p_"+rowindex).show();
	    	jQuery("#remind_"+rowindex).show();
	    }else{
	    	jQuery(passnumobj).hide();
	
	        jQuery("#p_"+rowindex).hide();
	    	jQuery("#remind_"+rowindex).hide();
	    }
    }catch(e){
		//if(window.console) console.log(e.message);
    }
}

function cancelEditNode(){
	window.location="/workflow/workflow/Editwfnode.jsp?ajax=1&wfid=<%=wfid%>";
}
</script>
<%}else{%>
<script type="text/javascript">
rowindex = "<%=rowsum%>";
delids = "";
function addRow()
{
	ncol = oTable.cols;

	oRow = oTable.insertRow();

	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell();
		oCell.style.height=24;
		oCell.style.background= "";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node' value='0'>&nbsp;<img moveimg src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>' />";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<select class=inputstyle  name='node_"+rowindex+"_type'><option value='-1'>********<%=SystemEnv.getHtmlLabelName(15597,user.getLanguage())%>***********</option><option value='0'><strong><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%></strong><option value='1'><strong><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></strong><option value='2'><strong><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></strong><option value='3'><strong><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></strong></select>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='input' class='InputStyle'name='node_"+rowindex+"_name' onblur='checkinput(\"node_"+rowindex+"_name\",\"node_"+rowindex+"_namespan\");checkSameName("+rowindex+",this.value)' maxlength=30><span id='node_"+rowindex+"_namespan'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
            case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<select class=inputstyle  name='node_"+rowindex+"_attribute' onchange=changeattri(this)><option value='0'><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></option><option value='1'><%=SystemEnv.getHtmlLabelName(21394,user.getLanguage())%></option><option value='2'><%=SystemEnv.getHtmlLabelName(21395,user.getLanguage())%></option><option value='3'><%=SystemEnv.getHtmlLabelName(21396,user.getLanguage())%></option><option value='4'><%=SystemEnv.getHtmlLabelName(21397,user.getLanguage())%></option><option value='5'><%=SystemEnv.getHtmlLabelName(126603,user.getLanguage())%></option></select><input type='input' class='InputStyle' size='5' maxlength=3 name='node_"+rowindex+"_passnum' style='display:none;width:30px;' onkeyup=checknumber(this) onBlur='checkcount1(this);checknumber(this)'><span id='p_"+rowindex+"' style='display:none;'>%</span><SPAN class='.e8tips' style='CURSOR: hand;display:none;' id='remind_"+rowindex+"' title='<%=SystemEnv.getHtmlLabelName(126604,user.getLanguage()) %>'><IMG id='ext-gen124' align='absMiddle' src='/images/remind_wev8.png'></SPAN>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
                break;
        }
	}
	document.getElementById("needcheck").value = document.getElementById("needcheck").value+",node_"+rowindex+"_name";
	rowindex = rowindex*1 +1;
	jQuery("body").jNice();
}

function changeattri(obj){
    var attriname=obj.name;
    var passnumname=attriname.substring(0,attriname.length-9)+"passnum";
    var attrinamearry = attriname.split("_");
    var rowindex = attrinamearry[1];
    //if(window.console) console.log("rowindex="+rowindex+" passnumname="+passnumname);
    try{
        var passnumobj = jQuery("input[name='"+passnumname+"']");
	    if(obj.value=="3"){
	        jQuery(passnumobj).show();
	    	jQuery("#p_"+rowindex).hide();
	    	jQuery("#remind_"+rowindex).hide();
	    	jQuery(passnumobj).val("");
	    }else if(obj.value=="5"){
	    	jQuery(passnumobj).show();
	    	jQuery(passnumobj).val("100");
	    	
	    	jQuery("#p_"+rowindex).show();
	    	jQuery("#remind_"+rowindex).show();
	    }else{
	    	jQuery(passnumobj).hide();
	
	        jQuery("#p_"+rowindex).hide();
	    	jQuery("#remind_"+rowindex).hide();
	    }
    }catch(e){
		//if(window.console) console.log(e.message);
    }
}

function deleteRow1()
{

	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				if(document.forms[0].elements[i].value!='0')
					delids +=","+ document.forms[0].elements[i].value;
				oTable.deleteRow(rowsum1+1);
			}
			rowsum1 -=1;
		}

	}
}

//function selectall(){
//	document.forms[0].nodesnum.value=rowindex;
//	document.forms[0].delids.value=delids;
//	window.document.forms[0].submit();
//}

function subclear(){
if (isdel()) {
deleteRow1();
}
}

</script>
<%}%>
</body>

</html>
