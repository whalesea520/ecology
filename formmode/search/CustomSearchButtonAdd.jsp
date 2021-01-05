<%@page import="weaver.formmode.service.CustomSearchButtService"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.formmode.interfaces.InterfaceTransmethod"%>
<%@page import="weaver.formmode.service.ModelInfoService"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.formmode.interfaces.action.WSActionManager"%>
<%@page import="weaver.formmode.interfaces.dmlaction.commands.bases.DMLActionBase"%>
<%@page import="weaver.formmode.interfaces.action.SapActionManager"%>
<%@page import="weaver.interfaces.workflow.action.Action"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="InterfaceTransmethod" class="weaver.formmode.interfaces.InterfaceTransmethod" scope="page" />
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if (!HrmUserVarify.checkUserRight("FORMMODEAPP:ALL", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
int id = Util.getIntValue(request.getParameter("id"), 0);
int objid = Util.getIntValue(request.getParameter("objid"), 0);
CustomSearchButtService customSearchButtService = new CustomSearchButtService();
Map<String, Object> data = customSearchButtService.getCustomSearchButtonById(id);
String buttonname = Util.null2String(data.get("buttonname"));
int hreftype = Util.getIntValue(Util.null2String(data.get("hreftype")),1);
int hreftargetOpenWay = Util.getIntValue(Util.null2String(data.get("hreftargetOpenWay")),1);
String hreftargetParid = Util.null2String(data.get("hreftargetParid"));
String hreftargetParval = Util.null2String(data.get("hreftargetParval"));
String hreftarget = Util.null2String(data.get("hreftarget"));
String jsmethodname = Util.null2String(data.get("jsmethodname"));
String jsParameter = Util.null2String(data.get("jsParameter"));
String jsmethodbody = Util.null2String(data.get("jsmethodbody"));
String interfacePath = Util.null2String(data.get("interfacePath"));
int isshow = Util.getIntValue(Util.null2String(data.get("isshow")),1);
String describe = Util.null2String(data.get("describe"));
float showorder = Util.getFloatValue(Util.null2String(data.get("showorder")),0.0f);

String subCompanyIdsql = "SELECT b.subcompanyid FROM mode_customsearch a,modeTreeField b WHERE a.appid=b.id AND a.id="+id;
RecordSet recordSet = new RecordSet();
recordSet.executeSql(subCompanyIdsql);
int subCompanyId = -1;
if(recordSet.next()){
	subCompanyId = recordSet.getInt("subCompanyId");
}
String userRightStr = "FORMMODEAPP:ALL";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);

if(operatelevel>0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javaScript:doSubmit(),_self} " ;//保存
}
if(operatelevel>1){
	if(id!=0){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javaScript:doDel(),_self} " ;//删除
	}
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:doBack(),_self} " ;//返回
RCMenuHeight += RCMenuHeightStep ;
RCMenuHeight += RCMenuHeightStep ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<html>
<head>
<title></title>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
<style type="text/css">
.codeEditFlag{
	padding-left:20px;
	padding-right: 10px;
	height: 16px;
	background:transparent url('/formmode/images/list_edit_wev8.png') no-repeat !important;
	cursor: pointer;
	margin-left: 2px;
	margin-top: 2px;
	position: relative;
}
.codeDelFlag{
	position: absolute;
	top: 2px;
	right: 2px;
	width:9px;
	height:9px;
	background:transparent url('/images/messageimages/delete_wev8.gif') no-repeat !important;
	cursor: pointer;	
}
</style>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
$(document).ready(function () {
	showorhideByHrefType();
});
function showorhideByHrefType(){
	if($("#hreftype option:selected").val()==1){
		$("#jsmethodNameTr,#jsParameterTr,#jsmethodBodyTr,#interfacePathTr").show();
		$("#hreftargetOpenWayTr,#hreftargetParidTr,#hreftargetParvalTr,#hrefTargetTr").hide();
	}else{
		$("#hreftargetOpenWayTr,#hreftargetParidTr,#hreftargetParvalTr,#hrefTargetTr").show();
		$("#jsmethodNameTr,#jsParameterTr,#jsmethodBodyTr,#interfacePathTr").hide();
	}
}
function doSubmit(){
    enableAllmenu();
    if($("#buttonname").val()==""){
    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81968,user.getLanguage())%>",function(){displayAllmenu();});//名称不能为空！
    	return false;
    }
    if($("#hreftype option:selected").val()==2){
    	if($("#hreftarget").val()==""){
    		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81969,user.getLanguage())%>",function(){displayAllmenu();});//链接目标地址不能为空！
    		return false;
    	}
    }else{
    	if($("#jsmethodname").val()==""){
    		top.Dialog.alert("javascript<%=SystemEnv.getHtmlLabelName(81970,user.getLanguage())%>",function(){displayAllmenu();});//方法名不能为空！
    		return false;
    	}
    	if($("#jsmethodbody").val()==""){
    		top.Dialog.alert("javascript<%=SystemEnv.getHtmlLabelName(81971,user.getLanguage())%>",function(){displayAllmenu();});//方法体不能为空！
    		return false;
    	}
    }
    document.WeaverForm.submit();		
}
function doDel(){
   //确定要删除吗？
   top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
       enableAllmenu();
  	   document.WeaverForm.operation.value="delete";
  	   document.WeaverForm.submit();
   });
}
function doBack(){
	enableAllmenu();
	window.location.href = "/formmode/search/CustomSearchButton.jsp?id=<%=objid%>";
}
function checkMethodName(obj){
	var methodName = $(obj).val().trim();
	if(methodName!=''){
		var operateStrLower = methodName.toLowerCase(); 				
		var pos = operateStrLower.indexOf("javascript:");	
		if (pos != -1)  {
			var posBracketStart = methodName.indexOf("(");
			methodName = methodName.substring(0,posBracketStart+1);
			$.ajax({
		        url : '/formmode/search/CustomSearchButtOperation.jsp?operation=checkMethodName',
		        type:"post",	
		        async:true,
		        data:"id=<%=id%>&objid=<%=objid%>&methodName="+methodName,					
		        success:function(msg){  
		        	if("true"==msg.trim()){		
		        		$("#jsmethodname").val("");
						$("#jsmethodnameImage").html("<font color='red'>javascript<%=SystemEnv.getHtmlLabelName(81972,user.getLanguage())%></font>");//方法名已经存在！
		        	}
		        }
     		});
		}
	}
}
</script>
</head>

<body>
<form id="WeaverForm" name="WeaverForm" action="/formmode/search/CustomSearchButtOperation.jsp" method="post">
	<input type="hidden" name="id" id="id" value="<%=id %>" />
	<input type="hidden" name="operation" id="operation" value="create" />
	<input type="hidden" name="objid" id="objid" value="<%=objid%>">
	<table class="e8_tblForm">
		<tr>
			<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td><!-- 名称 -->
			<td class="e8_tblForm_field">
				<input type="text" name="buttonname" id="buttonname" style="width:80%;" value="<%=buttonname%>"  onchange="checkinput('buttonname','buttonnameImage')"/>
				<span id="buttonnameImage"><%if("".equals(buttonname)){%><img src="/images/BacoError_wev8.gif"/><%}%></span>
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(81967,user.getLanguage())%></td><!-- 链接目标方式 -->
			<td class="e8_tblForm_field">
				<select id="hreftype" name="hreftype" onchange="showorhideByHrefType();" style="width:150px;">
					<option value="1" <%if(hreftype==1) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(30176,user.getLanguage())%><!-- 手动输入 --></option>
					<option value="2" <%if(hreftype==2) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(81973,user.getLanguage())%><!-- 链接 --></option>
				</select>
			</td>
		</tr>
		<tr id="hreftargetOpenWayTr">
			<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(81974,user.getLanguage())%><!-- 链接打开方式 --></td>
			<td class="e8_tblForm_field">
				<select id="hreftype" name="hreftargetOpenWay" style="width:150px;">
					<option value="1" <%if(hreftargetOpenWay==1) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(22970,user.getLanguage())%><!-- Tab页 --></option>
					<option value="2" <%if(hreftargetOpenWay==2) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(81975,user.getLanguage())%><!-- 弹出框 --></option>
				</select>
			</td>
		</tr>
		<tr id="hreftargetParidTr">
			<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(81976,user.getLanguage())%>id<!-- 链接目标参数 --></td>
			<td class="e8_tblForm_field">
				<input class="inputstyle" type="text" id="hreftargetParid" name="hreftargetParid" value="<%=hreftargetParid%>" style="width:80%"/>
			</td>
		</tr>
		<tr id="hreftargetParvalTr">
			<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(81976,user.getLanguage())%>field<!-- 链接目标参数 --></td>
			<td class="e8_tblForm_field">
				<input class="inputstyle" type="text" id="hreftargetParval" name="hreftargetParval" value="<%=hreftargetParval%>" style="width:80%"/>
				<div class="e8_label_desc"><%=SystemEnv.getHtmlLabelName(81977,user.getLanguage())%><!-- 链接目标参数field是指查询列表中的字段 --></div>
			</td>
		</tr>
		<tr id="hrefTargetTr">
			<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(30178,user.getLanguage())%><!-- 链接目标地址--></td>
			<td class="e8_tblForm_field" valign="top">
				<textarea id="hreftarget" name="hreftarget" class="inputstyle" rows="3" style="width:80%" onchange="checkinput('hreftarget','hreftargetImage')"><%=hreftarget%></textarea>
				<span id="hreftargetImage"><%if("".equals(hreftarget)){%><img src="/images/BacoError_wev8.gif"/><%}%></span>
			</td>
		</tr>
		<tr id="jsmethodNameTr">
			<td class="e8_tblForm_label">javascript<%=SystemEnv.getHtmlLabelName(81978,user.getLanguage())%><!-- 方法名 --></td>
			<td class="e8_tblForm_field">
				<input class="inputstyle" type="text" id="jsmethodname" name="jsmethodname" value="<%=jsmethodname%>" style="width:80%;" onchange="checkinput('jsmethodname','jsmethodnameImage');checkMethodName(this);"/>
				<span id="jsmethodnameImage"><%if("".equals(jsmethodname)){%><img src="/images/BacoError_wev8.gif"/><%}%></span>
				<div class="e8_label_desc"><%=SystemEnv.getHtmlLabelName(81979,user.getLanguage())%><!-- 方法名命名规范 -->：javascript:onUrl();</div>
			</td>
		</tr>
		<tr id="jsParameterTr">
			<td class="e8_tblForm_label">javascript<%=SystemEnv.getHtmlLabelName(81980,user.getLanguage())%><!-- 方法参数 --></td>
			<td class="e8_tblForm_field">
				<input class="inputstyle" type="text" id="jsParameter" name="jsParameter" value="<%=jsParameter%>" style="width:80%;"/>
				<div class="e8_label_desc"><%=SystemEnv.getHtmlLabelName(81981,user.getLanguage())%><!-- 方法参数命名规范 -->：field1,field2</div>
			</td>
		</tr>
		<tr id="jsmethodBodyTr">
			<td class="e8_tblForm_label">javascript<%=SystemEnv.getHtmlLabelName(81982,user.getLanguage())%><!-- 方法体 --></td>
			<td class="e8_tblForm_field">
				<textarea id="jsmethodbody" name="jsmethodbody" style="width:80%;" rows="10" onchange="checkinput('jsmethodbody','jsmethodbodyImage')"><%=jsmethodbody%></textarea>
				<span id="jsmethodbodyImage"><%if("".equals(jsmethodbody)){%><img src="/images/BacoError_wev8.gif"/><%}%></span>
				<div class="e8_label_desc"><%=SystemEnv.getHtmlLabelName(81983,user.getLanguage())%><!-- 方法体命名规范 -->：function onUrl(id,params){}</div>
			</td>
		</tr>
		<tr id="interfacePathTr">
			<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(82804,user.getLanguage())%><!-- 接口路径 --></td>
			<td class="e8_tblForm_field">
				<input class="inputstyle" type="text" id="interfacePath" name="interfacePath" value="<%=interfacePath%>" style="width:80%;"/>
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(15603,user.getLanguage())%><!-- 是否显示	--></td>
			<td class="e8_tblForm_field">
				<input class="inputstyle" type="checkbox" id="isshow" name="isshow" value="1" <%if(isshow==1) out.println("checked");%>>
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(81710,user.getLanguage())%><!-- 描述 --><div class="e8_label_desc"></div></td>
			<td class="e8_tblForm_field">
				<textarea id="describe" name="describe" style="width:80%;"><%=describe%></textarea>
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%><!-- 显示顺序--></td>
			<td class="e8_tblForm_field">
				<input class="inputstyle" type="text" name="showorder" id="showorder" value="<%=showorder%>" size="5" onkeypress="ItemDecimal_KeyPress('showorder',15,2)" onblur="checknumber1(this);">
			</td>
		</tr>
	</table>
</form>
</body>
</html>
