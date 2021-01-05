
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.general.*" %>
<%@ page import="weaver.workflow.workflow.WFOpinionInfo" %>
<jsp:useBean id="WFOpinionManager" class="weaver.workflow.workflow.WFOpinionManager" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<script language=javascript src="/js/weaver_wev8.js"></script>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(18880,user.getLanguage());
int workflowId = Util.getIntValue(request.getParameter("wfid"),0) ;
String ajax=Util.null2String(request.getParameter("ajax"));
String needcheck = "";
String needhelp ="";
%>

</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(ajax.equals("1")){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitFields(),_self} " ;
    RCMenuHeight += RCMenuHeightStep;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:history.back(-1),_self} " ;
    RCMenuHeight += RCMenuHeightStep;
}
%>
<%if(!ajax.equals("1")){%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%}else{%>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<%}%>

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

<FORM id=weaver name="formlabel" action="WFOpinionFieldOperation.jsp" method="post">
	<input type="hidden" value="<%=workflowId%>" name="workflowid">
	<table width="100%">
		<tr valign="top">
			<td align="left"><b><%=titlename%></b></td>
			<td align="right"><BUTTON Class=Btn type=button accessKey=A onclick="addrow()">
				<U>A</U>-<%=SystemEnv.getHtmlLabelName(17998,user.getLanguage())%></BUTTON>
			</td>
		</tr>
	</table>
<hr>
	
	<div style="DISPLAY: none" id="lable_cn">
		<%=SystemEnv.getHtmlLabelName(18881,user.getLanguage())%>:
		<input class=InputStyle name="label_cn" type="text" maxlength=20 onblur="check_label()">		
		<input class=InputStyle name="fieldid" type=hidden maxlength=20>
		<span id="span_label_id"><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>
	</div>
	<div style="DISPLAY: none" id="lable_en">
		<%=SystemEnv.getHtmlLabelName(18882,user.getLanguage())%>:
		<input class=InputStyle name="label_en" type=text maxlength=20>
	</div>
	<%if(GCONST.getZHTWLANGUAGE()==1){ %>
	<div style="DISPLAY: none" id="lable_tw">
		<%=SystemEnv.getHtmlLabelName(21865,user.getLanguage())%>:
		<input class=InputStyle name="label_tw" type=text maxlength=20>
	</div>
	<%} %>
	
	<div style="DISPLAY: none" id="type_cn">
		<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:
	    <select size="1" name="type_cn">
			<option value="1" selected><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></option>
			<option value="2" ><%=SystemEnv.getHtmlLabelName(6163,user.getLanguage())%></option>
			<option value="3" ><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></option>
			<option value="4" ><%=SystemEnv.getHtmlLabelName(18434,user.getLanguage())%></option>
			<option value="5" ><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></option>
			<option value="6" ><%=SystemEnv.getHtmlLabelName(840,user.getLanguage())%></option>
			<option value="7" ><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></option>
			<option value="8" ><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%></option>
			<option value="9" ><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%></option>
	    </select>
	</div>
	
	<div style="DISPLAY: none" id="action">
		<img src="/images/icon_ascend_wev8.gif" height="14" onclick="up(this)">
    	<img src="/images/icon_descend_wev8.gif" height="14" onclick="down(this)">
    	<img src="/images/delete_wev8.gif" height="14" onclick="del(this)">
	</div>
	

<TABLE cellSpacing=0 cellPadding=1 width="100%" border=0 id="inputface">
<COLGROUP>
	<col width="32%" valign="top">
	<col width="32%" valign="top">
	<col width="21%" valign="top">
	<col width="12%" valign="top">
	<%
	List fieldList = WFOpinionManager.getFieldValuesByWorkflowId(workflowId);
	//System.out.println("size():"+fieldList.size());
	if(fieldList != null){
		for(int i=0; i<fieldList.size(); i++){
			WFOpinionInfo info = (WFOpinionInfo)fieldList.get(i);
			String label_cn = info.getLabel_cn();
			String label_en = info.getLabel_en();
			String label_tw = info.getLabel_tw();
			String type_cn = info.getType_cn();
			int fieldid = info.getId();
	%>
	
    <tr>
	    <td style="border-bottom:silver 1pt solid">
		    <%=SystemEnv.getHtmlLabelName(18881,user.getLanguage())%>:
		    <input  class=InputStyle type="text" name="label_cn" value="<%=label_cn%>" onblur="check_label()">		    
		    <input type="hidden" name="fieldid" value="<%=fieldid%>">	
		    <span id="span_label_id"></span>	    
	    </td>
	    <td style="border-bottom:silver 1pt solid">
		    <%=SystemEnv.getHtmlLabelName(18882,user.getLanguage())%>:
		    <input  class=InputStyle name="label_en" value="<%=label_en%>">
	    </td>
	    <%if(GCONST.getZHTWLANGUAGE()==1){ %>
	    <td style="border-bottom:silver 1pt solid">
		    <%=SystemEnv.getHtmlLabelName(21865,user.getLanguage())%>:
		    <input  class=InputStyle name="label_tw" value="<%=label_tw%>">
	    </td>
	    <%} %>
	    <td style="border-bottom:silver 1pt solid">
		    <%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:
			<select size="1" name="type_cn">
				<option value="1" <%if(type_cn.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></option>
				<option value="2" <%if(type_cn.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6163,user.getLanguage())%></option>
				<option value="3" <%if(type_cn.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></option>
				<option value="4" <%if(type_cn.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18434,user.getLanguage())%></option>
				<option value="5" <%if(type_cn.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></option>
				<option value="6" <%if(type_cn.equals("6")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(840,user.getLanguage())%></option>
				<option value="7" <%if(type_cn.equals("7")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></option>
				<option value="8" <%if(type_cn.equals("8")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%></option>
				<option value="9" <%if(type_cn.equals("9")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%></option>
		    </select>
	    </td>  
	    <td style="border-bottom:silver 1pt solid">
	    	<img src="/images/icon_ascend_wev8.gif" height="14" onclick="upitem(this)">
    		<img src="/images/icon_descend_wev8.gif" height="14" onclick="downitem(this)">
	    	<img src="/images/delete_wev8.gif" height="14" onclick="delitem(this)">
	    </td>
    </tr> 
    	<%}%>
    <%}%>
</COLGROUP>
</td>
</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="4"></td>
</tr>
</table>

</FORM>
</BODY>
</HTML>

<SCRIPT LANGUAGE=javascript>
function addrow(){
	var oRow;
	var oCell;

	oRow = inputface.insertRow();
	oCell = oRow.insertCell();
    oCell.style.borderBottom="silver 1pt solid";
	oCell.innerHTML = lable_cn.innerHTML ;
	oCell = oRow.insertCell();
    oCell.style.borderBottom="silver 1pt solid";
	oCell.innerHTML = lable_en.innerHTML;
	<%if(GCONST.getZHTWLANGUAGE()==1){ %>
	oCell.innerHTML = lable_tw.innerHTML;
	oCell = oRow.insertCell();
    oCell.style.borderBottom="silver 1pt solid";
    <%}%>
	oCell = oRow.insertCell();
    oCell.style.borderBottom="silver 1pt solid";
	oCell.innerHTML = type_cn.innerHTML ;	
    oCell = oRow.insertCell();
    oCell.style.borderBottom="silver 1pt solid";
	oCell.innerHTML = action.innerHTML ;
}

function del(obj){
	var rowobj = obj.parentElement.parentElement;
	rowobj.parentElement.deleteRow(rowobj.rowIndex);
}

function delitem(obj){
	var rowobj = obj.parentElement.parentElement;
	rowobj.parentElement.deleteRow(rowobj.rowIndex);
}

function upitem(obj){
	if(obj.parentElement.parentElement.rowIndex==0){
		return;
	}
	var tobj = obj.parentElement.parentElement.parentElement;
	var rowobj = tobj.insertRow(obj.parentElement.parentElement.rowIndex-1);
	for(var i=0; i<4; i++){
		var cellobj = rowobj.insertCell()
        //cellobj.style.borderBottom="silver 1pt solid";
		cellobj.innerHTML = obj.parentElement.parentElement.cells[i].innerHTML;
	}
	tobj.deleteRow(obj.parentElement.parentElement.rowIndex);
}

function downitem(obj){
	if(obj.parentElement.parentElement.rowIndex==obj.parentElement.parentElement.parentElement.rows.length-1){
		return;
	}
	var tobj = obj.parentElement.parentElement.parentElement;
	var rowobj = tobj.insertRow(obj.parentElement.parentElement.rowIndex+2);
	for(var i=0; i<4; i++){
		var cellobj = rowobj.insertCell()
        //cellobj.style.borderBottom="silver 1pt solid";
		cellobj.innerHTML = obj.parentElement.parentElement.cells[i].innerHTML;
	}
	tobj.deleteRow(obj.parentElement.parentElement.rowIndex);
}

function up(obj){
	if(obj.parentElement.parentElement.rowIndex==0){
		return;
	}
	var tobj = obj.parentElement.parentElement.parentElement;
	var rowobj = tobj.insertRow(obj.parentElement.parentElement.rowIndex-1);
	for(var i=0; i<4; i++){
		var cellobj = rowobj.insertCell()
        cellobj.style.borderBottom="silver 1pt solid";
		cellobj.innerHTML = obj.parentElement.parentElement.cells[i].innerHTML;
	}
	tobj.deleteRow(obj.parentElement.parentElement.rowIndex);
}

function down(obj){
	if(obj.parentElement.parentElement.rowIndex==obj.parentElement.parentElement.parentElement.rows.length-1){
		return;
	}
	var tobj = obj.parentElement.parentElement.parentElement;
	var rowobj = tobj.insertRow(obj.parentElement.parentElement.rowIndex+2);
	for(var i=0; i<4; i++){
		var cellobj = rowobj.insertCell()
        cellobj.style.borderBottom="silver 1pt solid";
		cellobj.innerHTML = obj.parentElement.parentElement.cells[i].innerHTML;
	}
	tobj.deleteRow(obj.parentElement.parentElement.rowIndex);
}

function clearTempObj(){
    lable_cn.innerHTML="";
    lable_en.innerHTML="";
    <%if(GCONST.getZHTWLANGUAGE()==1){ %>
    lable_tw.innerHTML="";
    <%}%>
    type_cn.innerHTML="";
    action.innerHTML="";
}

</SCRIPT>
<script language="javascript">
function submitFields()
{
	if (check_opinion_form()){
        clearTempObj();
		weaver.submit();
    }
}

function check_label(){
	var obj = document.getElementsByName("label_cn");
	var spanids = document.getElementsByName("span_label_id");
	if(obj.length){
		for(var i=1; i<obj.length; i++){
			if(trim(obj[i].value) == ""){
				spanids[i].innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
			}else{
				spanids[i].innerHTML = "";
			}
		}
	}
	return true;
}

function check_opinion_form(){
	var obj = document.getElementsByName("label_cn");
	var spanids = document.getElementsByName("span_label_id");
	if(obj.length){
		for(var i=1; i<obj.length; i++){
			if(trim(obj[i].value) == ""){
				spanids[i].innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
				alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
				return false;
			}else{
				spanids[i].innerHTML = "";
			}
		}
	}
	return true;
}
</script>
