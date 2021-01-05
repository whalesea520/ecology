<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@page import="weaver.expdoc.ExpUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("intergration:expsetting", user)){
 	response.sendRedirect("/notice/noright.jsp");
 	return;
}
ExpUtil eu=new ExpUtil();
ArrayList arrayRs=new ArrayList();
arrayRs=eu.getDatasourceNames();
String backto = Util.null2String(request.getParameter("backto"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(125745,user.getLanguage());//归档FTP注册
String needfav ="1";
String needhelp ="";
/*QC295960 [80][90]流程归档集成-解决归档配置中FTP配置名称可重复的问题 start */
String name = Util.null2String(request.getParameter("name"));
/*QC295960 [80][90]流程归档集成-解决归档配置中FTP配置名称可重复的问题 end */
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<script language=javascript >
var parentWin = parent.parent.getParentWindow(parent);
</script>
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("intergration:expsetting", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<%if(HrmUserVarify.checkUserRight("intergration:expsetting", user)){%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="submitData()"/>
			<%}%>
			<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
</div>
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
</div>
<FORM id=weaver name=frmMain action="ExpFtpDetailOperation.jsp?isdialog=1" method=post enctype="multipart/form-data" >
<input class=inputstyle type=hidden name="backto" value="<%=backto%>">
<input class=inputstyle type="hidden" name=operation value="add">
<wea:layout><!-- 基本信息 -->
	<wea:group context="<%=SystemEnv.getHtmlLabelName(81711,user.getLanguage())%>" attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item>
            <wea:required id="nameimage" required="true">
            	<input class=inputstyle type=text style='width:280px!important;' size=100 maxlength="100" name="name"  onchange='checkinput("name","nameimage")'>
            </wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></wea:item>
		<wea:item>
            <wea:required id="adressimage" required="true">
            	<input class=inputstyle type=text style='width:280px!important;' size=100 maxlength="100" name="adress" onchange='checkinput("adress","adressimage")' _noMultiLang='true'>
            </wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(84629,user.getLanguage())%></wea:item>
		<wea:item>
            <wea:required id="portimage" >
            	<input class=inputstyle type=text style='width:140px!important;' size=10 maxlength="30" name="port" id="port" value='21' _noMultiLang='true'>
            </wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(2072,user.getLanguage())%></wea:item>
		<wea:item>
            <wea:required id="ftpuserimage" required="true">
            	<input class=inputstyle type=text style='width:140px!important;' size=100 maxlength="100" name="ftpuser" onchange='checkinput("ftpuser","ftpuserimage")'>
            </wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></wea:item>
		<wea:item>
            <wea:required id="ftppwdimage" >
            	<input class=inputstyle type=password style='width:200px!important;' size=100 maxlength="100" name="ftppwd" _noMultiLang='true'>
            </wea:required>
		</wea:item>		
		<wea:item><%=SystemEnv.getHtmlLabelName(84630,user.getLanguage())%></wea:item>
		<wea:item>
            <wea:required id="pathimage" required="true">
            	<input class=inputstyle type=text style='width:280px!important;' size=100 maxlength="100" name="path"  onchange='checkinput("path","pathimage")' _noMultiLang='true'>
            </wea:required>
		</wea:item>	
	</wea:group>
</wea:layout>
<br>
 </form>

<script language=javascript>
function submitData() {
	var checkvalue = "name,adress,path,ftpuser";
    if(check_form(frmMain,checkvalue)){
        frmMain.submit();
    }
}
function onBack(){
	parentWin.closeDialog();
}

$(function () {
            $("#port").keyup(function () {
                //如果输入非数字，则替换为''，如果输入数字
                this.value = this.value.replace(/[^\d]/g, '');
            });
			/*QC295960 [80][90]流程归档集成-解决归档配置中FTP配置名称可重复的问题 start */
			if(""!="<%=name%>"){
               top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129932,user.getLanguage())%>"+"！");//名称重复，请重新输入！ 
            }
			/*QC295960 [80][90]流程归档集成-解决归档配置中FTP配置名称可重复的问题 end */
   });
</script>
<%if("1".equals(isDialog)){ %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" onclick='onBack();'></input>
				</wea:item>
			</wea:group>
		</wea:layout>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				resizeDialog(document);
			});
		</script>
	</div>
</div>
<%} %>
</BODY>
</HTML>