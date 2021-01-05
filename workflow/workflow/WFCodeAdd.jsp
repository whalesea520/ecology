<!DOCTYPE html>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<HTML>
<%
String ishtml=Util.null2String(request.getParameter("ishtml"));
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17998, user.getLanguage());
String needfav = "1";
String needhelp = "";
int wfid=0;
wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
String isbill = "";
int formid=0;

WFManager.setWfid(wfid);
WFManager.getWfInfo();
formid = WFManager.getFormid();
isbill = WFManager.getIsBill();

String SQL = null;

if("1".equals(isbill)){
	SQL = "select formField.id,fieldLable.labelName as fieldLable "
               + "from HtmlLabelInfo  fieldLable ,workflow_billfield  formField "
               + "where fieldLable.indexId=formField.fieldLabel "
               + "  and formField.billId= " + formid
               + "  and formField.viewType=0 "
               + "  and fieldLable.languageid =" + user.getLanguage();
}else{
	SQL = "select formDict.ID, fieldLable.fieldLable "
               + "from workflow_fieldLable fieldLable, workflow_formField formField, workflow_formdict formDict "
               + "where fieldLable.formid = formField.formid and fieldLable.fieldid = formField.fieldid and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "
               + "and formField.formid = " + formid
               + " and fieldLable.langurageid = " + user.getLanguage();
}

String selectFieldSql=null;//选择框
if("1".equals(isbill)){
	selectFieldSql = SQL + " and formField.fieldHtmlType = '5' order by formField.dspOrder";
}else{
    selectFieldSql = SQL + " and formDict.fieldHtmlType = '5' order by formField.fieldorder";
}
String subCompanyFieldSql=null;////(42,164)-->单多分部、(169,170)-->分权单多分部    /systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp 164,194
if("1".equals(isbill)){
	subCompanyFieldSql = SQL + " and formField.fieldHtmlType = '3' and formField.type in(164,169) order by formField.dspOrder";
}else{
    subCompanyFieldSql = SQL + " and formDict.fieldHtmlType = '3' and formDict.type in(164,169) order by formField.fieldorder";
}
String onlyDepartmentFieldSql=null;//部门编码 td add by 78162 单选
if("1".equals(isbill)){
	onlyDepartmentFieldSql = SQL + " and formField.fieldHtmlType = '3' and formField.type =4 order by formField.dspOrder";
}else{
	onlyDepartmentFieldSql = SQL + " and formDict.fieldHtmlType = '3' and formDict.type =4 order by formField.fieldorder";
}        
String departmentFieldSql=null;//(4,57)-->单多部门、(167,168)-->分权单多部门
if("1".equals(isbill)){
	departmentFieldSql = SQL + " and formField.fieldHtmlType = '3' and formField.type in(4,167) order by formField.dspOrder";
}else{
    departmentFieldSql = SQL + " and formDict.fieldHtmlType = '3' and formDict.type in(4,167) order by formField.fieldorder";
}
String yearFieldSql=null;//年
if("1".equals(isbill)){
	//yearFieldSql = SQL + " and formField.fieldHtmlType = '3' and formField.type in(2,178) order by formField.dspOrder";
	yearFieldSql = SQL + " and ((formField.fieldHtmlType = '3' and formField.type in(2))or(formField.fieldHtmlType = '5' and exists(select 1 from workflow_selectitem where isBill="+isbill+" and workflow_selectitem.fieldId=formField.id and selectName>'1900' and selectName<'2099'))) order by formField.dspOrder";
}else{
    //yearFieldSql = SQL + " and formDict.fieldHtmlType = '3' and formDict.type in(2,178) order by formField.fieldorder";
    yearFieldSql = SQL + " and ((formDict.fieldHtmlType = '3' and formDict.type in(2))or(formDict.fieldHtmlType = '5' and exists(select 1 from workflow_selectitem where isBill="+isbill+" and workflow_selectitem.fieldId=formDict.id and selectName>'1900' and selectName<'2099'))) order by formField.fieldorder";
}

String monthFieldSql=null;//月
if("1".equals(isbill)){
	monthFieldSql = SQL + " and formField.fieldHtmlType = '3' and formField.type in(2) order by formField.dspOrder";
}else{
    monthFieldSql = SQL + " and formDict.fieldHtmlType = '3' and formDict.type in(2) order by formField.fieldorder";
}

String dateFieldSql=null;//日
if("1".equals(isbill)){
	dateFieldSql = SQL + " and formField.fieldHtmlType = '3' and formField.type in(2) order by formField.dspOrder";
}else{
    dateFieldSql = SQL + " and formDict.fieldHtmlType = '3' and formDict.type in(2) order by formField.fieldorder";
}

int tempFieldId=0;
int selectFieldId=0;
%>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">
	jQuery(document).ready(function(){

	});

	var parentWin = parent.getParentWindow(window);
	var dialog = parent.getDialog(window);

	function onSure(){
		var manifestation = "";
		manifestation = jQuery("#fieldManifestation").find("option:selected").val();
		var fieldType = "";
		fieldType = jQuery("#fieldType").find("option:selected").val();
		var fieldValue = "";
		fieldValue = jQuery("#fieldValue").find("option:selected").val();
		var fieldtext = jQuery("#fieldValue").find("option:selected").text();
	  	var returnjson  = {manifestation:manifestation,fieldType:fieldType,fieldValue:fieldValue,fieldtext:fieldtext};
	  	if(fieldValue == "" || fieldValue == undefined){
	  		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859, user.getLanguage()) %>");
	  		return false;
	  	}
		try{
	        dialog.callback(returnjson);
	    }catch(e){}
		try{
	     	dialog.close(returnjson);
	 	}catch(e){}
	}
	
	function onchangeselect(){
		var manifestation = jQuery("#fieldManifestation").find("option:selected").val();
		var fieldType = jQuery("#fieldType");
		//alert(fieldType.html());
		jQuery("#fieldType").empty(); //清空
		//jQuery("#fieldValue").empty(); //清空

		if(manifestation == "1"){//浏览按钮
			fieldType.selectbox("detach");
			var option = "<option value='1'><%=SystemEnv.getHtmlLabelName(27511, user.getLanguage()) %></option>";
			option += "<option value='2'><%=SystemEnv.getHtmlLabelName(33553, user.getLanguage()) %></option>";
			option += "<option value='3'><%=SystemEnv.getHtmlLabelName(22753, user.getLanguage()) %></option>";
			fieldType.append(option);
			fieldType.selectbox("attach");
			onchangeselectvalue();
			//fieldType.beautySelect();
			//jQuery("#fieldType").find("option[text='']").attr("selected",true); 
		}else if(manifestation == "2"){//选择框
			fieldType.selectbox("detach");
			fieldType.css("display","none");
			fieldType.selectbox("attach");
			var fieldValue = jQuery("#fieldValue");
			fieldValue.empty();
			fieldValue.selectbox("detach");
			var option = null;
			<%
			RecordSet.executeSql(selectFieldSql);  
			while(RecordSet.next()){
			tempFieldId = RecordSet.getInt("ID");
			%>
			option += "<option value='<%=tempFieldId%>'><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>";
			<%}%>
			fieldValue.append(option);
			//onchangeselectvalue();
			fieldValue.selectbox("attach");
			//jQuery("#fieldType").find("option[text='年月日']").attr("selected",true); 
		}else{//年月日
			fieldType.selectbox("detach");
			var option = "<option value='4'><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%></option>";
			option += "<option value='5'><%=SystemEnv.getHtmlLabelName(445, user.getLanguage()) %></option>";
			option += "<option value='6'><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></option>";
			option += "<option value='7'><%=SystemEnv.getHtmlLabelName(390, user.getLanguage()) %></option>";
			fieldType.append(option); 
			fieldType.selectbox("attach");
			onchangeselectvalue();
			//jQuery("#fieldType").find("option[text='年月日']").attr("selected",true);
		}
	}

	function onchangeselectvalue(){
		var fieldType = jQuery("#fieldType").find("option:selected").val();
		var fieldValue = jQuery("#fieldValue");
		jQuery("#fieldValue").empty(); //清空

		if(fieldType == "1"){//部门
			fieldValue.selectbox("detach");
			var option = "<option value='1'><%=SystemEnv.getHtmlLabelName(19225, user.getLanguage()) %></option>";
			<%
			RecordSet.executeSql(departmentFieldSql);  
			while(RecordSet.next()){
			tempFieldId = RecordSet.getInt("ID");
			selectFieldId=tempFieldId;
			%>
			option += "<option value=<%= tempFieldId %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>";
			<%}%>
			fieldValue.append(option);
			fieldValue.selectbox("attach");
		}else if(fieldType == "2"){//分部
			fieldValue.selectbox("detach");
			var option = "<option value='4'><%=SystemEnv.getHtmlLabelName(22788, user.getLanguage()) %></option>";
			<%
			RecordSet.executeSql(subCompanyFieldSql);  
			while(RecordSet.next()){
			tempFieldId = RecordSet.getInt("ID");
			selectFieldId=tempFieldId;
			%>
			option += "<option value=<%= tempFieldId %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>";
			<%}%>
			fieldValue.append(option); 
			fieldValue.selectbox("attach");
		}else if(fieldType == "3"){//上级分部
			fieldValue.selectbox("detach");
			var option = "<option value='7'><%=SystemEnv.getHtmlLabelName(22787, user.getLanguage()) %></option>";
			<%
			RecordSet.executeSql(subCompanyFieldSql);  
			while(RecordSet.next()){
			tempFieldId = RecordSet.getInt("ID");
			selectFieldId=tempFieldId;
			%>
			option += "<option value=<%= tempFieldId %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>";
			<%}%>
			fieldValue.append(option); 
			fieldValue.selectbox("attach");
		}else if(fieldType == "4"){//当前日期
			fieldValue.selectbox("detach");
			var option = "<option value='10'><%=SystemEnv.getHtmlLabelName(15625, user.getLanguage()) %></option>";
			fieldValue.append(option); 
			fieldValue.selectbox("attach");
		}else if(fieldType == "5"){//当前年份
			fieldValue.selectbox("detach");
			var option = "<option value='11'><%=SystemEnv.getHtmlLabelName(22793, user.getLanguage()) %></option>";
			<%
			RecordSet.executeSql(yearFieldSql);  
			while(RecordSet.next()){
			tempFieldId = RecordSet.getInt("ID");
			selectFieldId=tempFieldId;
			%>
			option += "<option value=<%= tempFieldId %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>";
			<%}%>
			fieldValue.append(option); 
			fieldValue.selectbox("attach");
		}else if(fieldType == "6"){//当前月份
			fieldValue.selectbox("detach");
			var option = "<option value='12'><%=SystemEnv.getHtmlLabelName(22794, user.getLanguage()) %></option>";
			<%
			RecordSet.executeSql(monthFieldSql);  
			while(RecordSet.next()){
			tempFieldId = RecordSet.getInt("ID");
			selectFieldId=tempFieldId;
			%>
			option += "<option value=<%= tempFieldId %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>";
			<%}%>
			fieldValue.append(option); 
			fieldValue.selectbox("attach");
		}else if(fieldType == "7"){//当前日期
			fieldValue.selectbox("detach");
			var option = "<option value='13'><%=SystemEnv.getHtmlLabelName(15625, user.getLanguage()) %></option>";
			<%
			RecordSet.executeSql(dateFieldSql);  
			while(RecordSet.next()){
			tempFieldId = RecordSet.getInt("ID");
			selectFieldId=tempFieldId;
			%>
			option += "<option value=<%= tempFieldId %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>";
			<%}%>
			fieldValue.append(option); 
			fieldValue.selectbox("attach");
		}else{//年月日
			fieldValue.selectbox("detach");
			fieldValue.selectbox("attach");
		}
	}

	function onClose(){
		dialog.close();
	}
</script>
</HEAD>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:onSure(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content" style="height: 100%!important;">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="coderOperation.jsp" method=post>
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(17998, user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(687, user.getLanguage())%></wea:item>
		<wea:item>
			<select class="inputstyle" id="fieldManifestation" name="fieldManifestation" onchange="onchangeselect()">
				<option value=1><%=SystemEnv.getHtmlLabelName(695, user.getLanguage())%></option>
				<option value=2><%=SystemEnv.getHtmlLabelName(690, user.getLanguage())%></option>
				<option value=3><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%></option>
			</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(33234, user.getLanguage())%></wea:item>
		<wea:item>
			<select class="inputstyle" id="fieldType" name="fieldType" onchange="onchangeselectvalue()">
				<option value='1'><%=SystemEnv.getHtmlLabelName(27511, user.getLanguage()) %></option>
				<option value='2'><%=SystemEnv.getHtmlLabelName(33553, user.getLanguage()) %></option>
				<option value='3'><%=SystemEnv.getHtmlLabelName(22753, user.getLanguage()) %></option>
			</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(21847, user.getLanguage())%></wea:item>
		<wea:item>
			<select class="inputstyle" id="fieldValue" name="fieldValue">
				<option value='1'><%=SystemEnv.getHtmlLabelName(19225, user.getLanguage()) %></option>
				<%
				RecordSet.executeSql(departmentFieldSql);  
				while(RecordSet.next()){
				tempFieldId = RecordSet.getInt("ID");
				selectFieldId=tempFieldId;
				%>
				<option value=<%= tempFieldId %>><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>
				<%}%>
			</select>
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
				<input type="button" accessKey=O  id=btnok  value="<%="O-"+SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" id="zd_btn_submit_0" class="zd_btn_submit" onclick="onSure();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
			</wea:item>
		</wea:group>
	</wea:layout>

</div>
</div>
</BODY>
</HTML>
