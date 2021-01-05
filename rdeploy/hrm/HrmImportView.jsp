<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Map.Entry"%>
<%@ page import="weaver.rdeploy.hrm.HrmResourceVo"%>
<%@ page import="weaver.rdeploy.hrm.HrmImportProcessRd"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.StaticObj"%>
<jsp:useBean id="HrmImportProcessRd" class="weaver.rdeploy.hrm.HrmImportProcessRd" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="../../js/jquery/jquery_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<style type="text/css">
.lastnameError{
	background-color: #ffe5e5;
}
.mobileError{
	background-color: #ffe5e5;
}
</style>

<script type="text/javascript">
function doSubmit(){
	jQuery("#message").show();
	frmMain.submit();
}
function jsGoBack(){
	window.location.href="HrmImportFieldSetting.jsp";
}
</script>
</head>
<body>
<FORM id=weaver name=frmMain action="HrmImportOperation.jsp" method=post>
<input type=hidden id="operation" name=cmd value="import">
<div style="padding-left: 50px;padding-top: 10px;width: 582px;">
<table  style="width: 100%;text-align: center;">
<%
Map<Integer,String> errorInfo = null;
StaticObj staticObj=StaticObj.getInstance();
if(staticObj.getObject("errorInfo")!=null)errorInfo=(Map<Integer,String>)staticObj.getObject("errorInfo");
List<HrmResourceVo> lsHrmResource = null;
if(staticObj.getObject("lsHrmResource")!=null)lsHrmResource=(List<HrmResourceVo>)staticObj.getObject("lsHrmResource");
%><tr style="height: 35px"><td style="width580px;word-wrap:break-word;word-break:break-all;">
<%
if(errorInfo!=null && errorInfo.size()>0){
Iterator<Entry<Integer,String>> iterError = errorInfo.entrySet().iterator();
while(iterError.hasNext()){
  Map.Entry<Integer,String> entry = iterError.next();
  int errortype = entry.getKey(); 
  String errorRowIndex = entry.getValue(); 
%>
<font color="#ff6464"><%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%><%=errorRowIndex %><%=SystemEnv.getHtmlLabelName(18620,user.getLanguage())%><%=HrmImportProcessRd.getErrorInfo(errortype)  %></font><br>
<%}%>
</td></tr>
<%}else{ %>
<tr style="height: 35px"><td></td></tr>
<%} %>
</table>
	<div style="border:1px solid #d1dce1;margin-top: 10px;">
	<table id="myTable" style="width: 100%;table-layout:fixed;border-collapse:collapse;text-align: center;">
		<colgroup>
			<col width="45px">
			<col width="20%">
			<col width="20%">
			<col width="20%">
			<col width="20%">
			<col width="20%">
		</colgroup>
		<tr style="height: 35px;">
			<td style="border-bottom:1px solid #d0dbe0;background-color: #f2f5f7;text-align: center;"><font style="color: #66888f">1</font></td>
			<td style="border-left:1px solid #eaf1f4;border-bottom:1px solid #eaf1f4;text-align: center;"><font style="color: #526336"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage()) %></font></td>
			<td style="border-left:1px solid #eaf1f4;border-bottom:1px solid #eaf1f4;text-align: center;"><font style="color: #526336"><%=SystemEnv.getHtmlLabelName(422,user.getLanguage()) %></font></td>
			<td style="border-left:1px solid #eaf1f4;border-bottom:1px solid #eaf1f4;text-align: center;"><font style="color: #526336"><%=SystemEnv.getHtmlLabelName(416,user.getLanguage()) %></font></td>
			<td style="border-left:1px solid #eaf1f4;border-bottom:1px solid #eaf1f4;text-align: center;"><font style="color: #526336"><%=SystemEnv.getHtmlLabelName(421,user.getLanguage()) %></font></td>
			<td style="border-left:1px solid #eaf1f4;border-bottom:1px solid #eaf1f4;text-align: center;"><font style="color: #526336"><%=SystemEnv.getHtmlLabelName(20869,user.getLanguage()) %></font></td>
		</tr>
		<%
		if(lsHrmResource!=null && lsHrmResource.size()>0){
		int rowIndex = 2;
		int rowCount = lsHrmResource.size();
    for(HrmResourceVo HrmResourceVo :lsHrmResource){
        if(rowIndex-1==rowCount){%>
    <tr style="height: 35px;">
			<td style="background-color: #f2f5f7;text-align: center;"><font style="color: #66888f"><%=rowIndex++ %></font></td>
			<td style="border-left:1px solid #eaf1f4;text-align: center;" <%=HrmResourceVo.getLastnameError()?"class='lastnameError' rowindex='"+(rowIndex-1)+"'":"" %>><font style="color: #526336"><%=HrmResourceVo.getLastname() %></font></td>
			<td style="border-left:1px solid #eaf1f4;text-align: center;" <%=HrmResourceVo.getMobileError()?"class='mobileError' rowindex='"+(rowIndex-1)+"'":"" %>><font style="color: #526336"><%=HrmResourceVo.getMobile() %></font></td>
			<td style="border-left:1px solid #eaf1f4;text-align: center;"><font style="color: #526336"><%=HrmResourceVo.getSex() %></font></td>
			<td style="border-left:1px solid #eaf1f4;text-align: center;"><font style="color: #526336"><%=HrmResourceVo.getTelephone() %></font></td>
			<td style="border-left:1px solid #eaf1f4;text-align: center;"><font style="color: #526336"><%=HrmResourceVo.getEmail() %></font></td>
		</tr>
        <%}else{%>
		<tr style="height: 35px;">
			<td style="border-bottom:1px solid #d0dbe0;background-color: #f2f5f7;text-align: center;"><font style="color: #66888f"><%=rowIndex++ %></font></td>
			<td style="border-left:1px solid #eaf1f4;border-bottom:1px solid #eaf1f4;text-align: center;" <%=HrmResourceVo.getLastnameError()?"class='lastnameError' rowindex='"+(rowIndex-1)+"'":"" %>><font style="color: #526336"><%=HrmResourceVo.getLastname() %></font></td>
			<td style="border-left:1px solid #eaf1f4;border-bottom:1px solid #eaf1f4;text-align: center;" <%=HrmResourceVo.getMobileError()?"class='mobileError' rowindex='"+(rowIndex-1)+"'":"" %>><font style="color: #526336"><%=HrmResourceVo.getMobile() %></font></td>
			<td style="border-left:1px solid #eaf1f4;border-bottom:1px solid #eaf1f4;text-align: center;"><font style="color: #526336"><%=HrmResourceVo.getSex() %></font></td>
			<td style="border-left:1px solid #eaf1f4;border-bottom:1px solid #eaf1f4;text-align: center;"><font style="color: #526336"><%=HrmResourceVo.getTelephone() %></font></td>
			<td style="border-left:1px solid #eaf1f4;border-bottom:1px solid #eaf1f4;text-align: center;"><font style="color: #526336"><%=HrmResourceVo.getEmail() %></font></td>
		</tr>
		<%} %>
		<%}} %>
	</table>
</div>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(1876,user.getLanguage()) %>" class="e8_btn_cancel" onclick="jsGoBack()">
		    		<input type="button" value="<%=(errorInfo!=null && errorInfo.size()>0)?SystemEnv.getHtmlLabelName(125340,user.getLanguage()):SystemEnv.getHtmlLabelName(18596,user.getLanguage()) %>" class="e8_btn_cancel" onclick="doSubmit()"> 
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
<div id="message" style="width: 174px;height: 174px;border: 1px solid #e1e1e1;position: absolute;top: 200px;left: 250px;display: none;"><img src="/rdeploy/hrm/img/loading.gif"></div>
</body>
</<HTML>