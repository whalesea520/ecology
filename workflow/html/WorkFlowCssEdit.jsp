<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="cssFileManager" class="weaver.workflow.html.CssFileManager" scope="page" />
<%@ page import="weaver.workflow.html.CssDetailBean" %>
<%
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
int id = Util.getIntValue(request.getParameter("id"));	
String opttype = Util.null2String(request.getParameter("opttype"));
String optStr = "";
if(id <= 0){
	opttype = "add";
}else{
	opttype = "edit";
}
if("add".equals(opttype)){
	optStr = SystemEnv.getHtmlLabelName(82, user.getLanguage());
}else if("edit".equals(opttype)){
	optStr = SystemEnv.getHtmlLabelName(93, user.getLanguage());
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(28118,user.getLanguage())+":"+optStr;
String needfav ="1";
String needhelp ="";
boolean iscssFileUsed = cssFileManager.cssFileUsed(id);
CssDetailBean cssDetailBean = new CssDetailBean();
if("edit".equals(opttype)){
	cssDetailBean = cssFileManager.getCssDetail(id);
}
int detailid = cssDetailBean.getDetailid();
String cssname = cssDetailBean.getCssname();
String outerbordercolor = cssDetailBean.getOuterbordercolor();
int outerbordersize = cssDetailBean.getOuterbordersize();
String requestnamecolor = cssDetailBean.getRequestnamecolor();
int requestnamesize = cssDetailBean.getRequestnamesize();
String requestnamefont = cssDetailBean.getRequestnamefont();
int requestnamestyle0 = cssDetailBean.getRequestnamestyle0();
int requestnamestyle1 = cssDetailBean.getRequestnamestyle1();
String maintablecolor = cssDetailBean.getMaintablecolor();
int maintablesize = cssDetailBean.getMaintablesize();
int mainfieldsize = cssDetailBean.getMainfieldsize();
String mainfieldcolor = cssDetailBean.getMainfieldcolor();
String mainfieldnamecolor = cssDetailBean.getMainfieldnamecolor();
String mainfieldvaluecolor = cssDetailBean.getMainfieldvaluecolor();
int mainfieldheight = cssDetailBean.getMainfieldheight();
String detailtablecolor = cssDetailBean.getDetailtablecolor();
int detailtablesize = cssDetailBean.getDetailtablesize();
int detailfieldheight = cssDetailBean.getDetailfieldheight();
int detailfieldsize = cssDetailBean.getDetailfieldsize();
String detailfieldcolor = cssDetailBean.getDetailfieldcolor();
String detailfieldnamecolor = cssDetailBean.getDetailfieldnamecolor();
String detailfieldvaluecolor = cssDetailBean.getDetailfieldvaluecolor();
String isadd = "0";
if(!"".equals(cssname)) isadd = "1";
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if("edit".equals(opttype)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(28118, user.getLanguage())%>"/>
</jsp:include>

<form name="frmmain" id="frmmain" method="post" action="/workflow/html/WorkFlowCssOperation.jsp">
	<input type="hidden" id="opttype" name="opttype" value="<%=opttype%>">
	<input type="hidden" id="cssid" name="cssid" value="<%=id%>">
	<input type="hidden" id="detailid" name="detailid" value="<%=detailid%>">
	<input type="hidden" id="isadd" name="isadd" value="<%=isadd%>">

<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context="<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>">
		<wea:item>CSS<%=SystemEnv.getHtmlLabelName(17517,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" class="InputStyle" id="cssname" name="cssname" maxlength="20" style="width:50%" value="<%=cssname%>" temptitle="CSS<%=SystemEnv.getHtmlLabelName(17517,user.getLanguage())%>" onchange="checkinput('cssname','cssnamespan')">
			<span id="cssnamespan"><%if("".equals(cssname)){%><IMG src="/images/BacoError_wev8.gif" align="absMiddle"><%}%></span>
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(28128, user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(495, user.getLanguage())%></wea:item>
		<wea:item>
			<%out.println(cssFileManager.getColorEleStr("outerbordercolor", outerbordercolor, 1));%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(203, user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" class="InputStyle" id="outerbordersize" name="outerbordersize" value="<%=outerbordersize%>" maxlength="1" style="width:100px" onchange="checkPlusnumber1(this)" onKeyPress="ItemPlusCount_KeyPress()">px
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(229, user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(495, user.getLanguage())%></wea:item>
		<wea:item><%out.println(cssFileManager.getColorEleStr("requestnamecolor", requestnamecolor, 1));%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(16197, user.getLanguage())%></wea:item>
		<wea:item><input type="text" class="InputStyle" id="requestnamesize" name="requestnamesize" value='<%=requestnamesize%>' maxlength="2" style="width:100px" onchange="checkPlusnumber1(this)" onKeyPress="ItemPlusCount_KeyPress()">pt</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(16189, user.getLanguage())%></wea:item>
		<wea:item><input type="text" class="InputStyle" id="requestnamefont" name="requestnamefont" value='<%=requestnamefont%>' maxlength="6" style="width:100px"></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1014, user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" class="InputStyle" id="requestnamestyle0" name="requestnamestyle0" value="1" <%if(requestnamestyle0==1){out.print("checked");}%>><%=SystemEnv.getHtmlLabelName(23002, user.getLanguage())%>
			&nbsp;&nbsp;
			<input type="checkbox" class="InputStyle" id="requestnamestyle1" name="requestnamestyle1" value="1" <%if(requestnamestyle1==1){out.print("checked");}%>><%=SystemEnv.getHtmlLabelName(23003, user.getLanguage())%>		
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(18020, user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(19445, user.getLanguage())%></wea:item>
		<wea:item><%out.println(cssFileManager.getColorEleStr("maintablecolor", maintablecolor, 1));%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(28125 , user.getLanguage())%></wea:item>
		<wea:item><input type="text" class="InputStyle" id="maintablesize" name="maintablesize" value='<%=maintablesize%>' maxlength="1" style="width:100px" onchange="checkPlusnumber1(this)" onKeyPress="ItemPlusCount_KeyPress()">px</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(28124, user.getLanguage())%></wea:item>
		<wea:item><input type="text" class="InputStyle" id="mainfieldheight" name="mainfieldheight" value='<%=mainfieldheight%>' maxlength="2" style="width:100px" onchange="checkPlusnumber1(this)" onKeyPress="ItemPlusCount_KeyPress()">px</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15456, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(16197, user.getLanguage())%></wea:item>
		<wea:item><input type="text" class="InputStyle" id="mainfieldsize" name="mainfieldsize" value='<%=mainfieldsize%>' maxlength="2" style="width:100px" onchange="checkPlusnumber1(this)" onKeyPress="ItemPlusCount_KeyPress()">pt</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(28137, user.getLanguage())%></wea:item>
		<wea:item><%out.println(cssFileManager.getColorEleStr("mainfieldcolor", mainfieldcolor, 1));%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(28122, user.getLanguage())%></wea:item>
		<wea:item><%out.println(cssFileManager.getColorEleStr("mainfieldnamecolor", mainfieldnamecolor, 1));%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(28123, user.getLanguage())%></wea:item>
		<wea:item><%out.println(cssFileManager.getColorEleStr("mainfieldvaluecolor", mainfieldvaluecolor, 1));%></wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(18550, user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(19445, user.getLanguage())%></wea:item>
		<wea:item><%out.println(cssFileManager.getColorEleStr("detailtablecolor", detailtablecolor, 1));%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(28125 , user.getLanguage())%></wea:item>
		<wea:item><input type="text" class="InputStyle" id="detailtablesize" name="detailtablesize" value='<%=detailtablesize%>' maxlength="1" style="width:100px" onchange="checkPlusnumber1(this)" onKeyPress="ItemPlusCount_KeyPress()">px</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(28124, user.getLanguage())%></wea:item>
		<wea:item><input type="text" class="InputStyle" id="detailfieldheight" name="detailfieldheight" value='<%=detailfieldheight%>' maxlength="2" style="width:100px" onchange="checkPlusnumber1(this)" onKeyPress="ItemPlusCount_KeyPress()">px</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15456, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(16197, user.getLanguage())%></wea:item>
		<wea:item><input type="text" class="InputStyle" id="detailfieldsize" name="detailfieldsize" value='<%=detailfieldsize%>' maxlength="2" style="width:100px" onchange="checkPlusnumber1(this)" onKeyPress="ItemPlusCount_KeyPress()">pt</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(28137, user.getLanguage())%></wea:item>
		<wea:item><%out.println(cssFileManager.getColorEleStr("detailfieldcolor", detailfieldcolor, 1));%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(28122, user.getLanguage())%></wea:item>
		<wea:item><%out.println(cssFileManager.getColorEleStr("detailfieldnamecolor", detailfieldnamecolor, 1));%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(28123, user.getLanguage())%></wea:item>
		<wea:item><%out.println(cssFileManager.getColorEleStr("detailfieldvaluecolor", detailfieldvaluecolor, 1));%></wea:item>
	</wea:group>
</wea:layout>
</form>
</body>
</html>
<script language="javascript">
function onSave(obj){
	if(check_form(frmmain, "cssname")){
		document.getElementById("opttype").value = "save";
		frmmain.submit();
		enableAllmenu();
	}
}
function onBack(){
	location.href = "/workflow/html/WorkFlowCssList.jsp";
}
function onDelete(){
	<%if(iscssFileUsed == false){%>
	if(isdel()){
	<%}else{%>
	if(confirm("<%=SystemEnv.getHtmlLabelName(28152,user.getLanguage())%>")){
	<%}%>
		document.getElementById("opttype").value = "delete";
		frmmain.submit();
		enableAllmenu();
	}
}
function setMenubarBgColor(o){
	var reg = /^#(([a-f]|[A-F]|\d){6})$/;
	if(!reg.test(o.value)){
		alert("<%=SystemEnv.getHtmlLabelName(19777,user.getLanguage())%>");			
		document.getElementById(o.name+"td").style.backgroundColor = "";  //颜色显示
		o.value = "#";  //数据输入
	}else if(!checkRepetitiveColor(o.value, o.value)){
		document.getElementById(o.name+"td").style.backgroundColor = "";  //颜色显示
		o.value = "#";  //数据输入	
	}else{
		document.getElementById(o.name+"td").style.backgroundColor = o.value;  //颜色显示	
	}
}

function getColorFromColorPicker(inputname){
	var dialogObject = new Object();
	var colorValue = "";

	colorValue = (window.showModalDialog("/systeminfo/template/ColorPicker.jsp", dialogObject, "dialogWidth:330px; dialogHeight:300px; center:yes; help:no; resizable:no; status:no")).toUpperCase();

	if("" != colorValue && checkRepetitiveColor(colorValue, document.getElementById(inputname).value)){
		document.getElementById(inputname+"td").style.backgroundColor = colorValue;  //颜色显示
		document.getElementById(inputname).value = colorValue;  //数据输入
	}
}
function checkRepetitiveColor(inputColor, nowColor){//检测所选颜色是否可以使用  true：可以使用输入颜色  false：不可以使用输入颜色
	var count = 0;
	var total = 1;
	var inputColor = inputColor.toUpperCase();
	var nowColor = nowColor.toUpperCase();

	for(var i = 1; i <= frmmain.length; i++){
		var tmpName = frmmain.elements[i-1].name;
		var tmpValue = frmmain.elements[i-1].value.toUpperCase();

		if("color" == tmpName && "#" != tmpValue && inputColor == tmpValue){
			if(inputColor == nowColor && count < total){
				count++;
			}else{
				alert("<%=SystemEnv.getHtmlLabelName(19778,user.getLanguage())%>");
				return false;
			}
		}
	}
	return true;
}
</script>
