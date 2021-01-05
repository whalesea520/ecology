<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("ofs:ofssetting", user)){
 	response.sendRedirect("/notice/noright.jsp");
 	return;
}
String backto = Util.null2String(request.getParameter("backto"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelNames("31694,127023",user.getLanguage());//归档流程注册信息
String needfav ="1";
String needhelp ="";

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
if(HrmUserVarify.checkUserRight("ofs:ofssetting", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32159,user.getLanguage())+",javascript:doSaveAndNext(),_TOP} " ;//保存并进入详细设置
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<%if(HrmUserVarify.checkUserRight("ofs:ofssetting", user)){%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="submitData()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>" class="e8_btn_top" onclick="doSaveAndNext()"/>
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
<FORM id=weaver name=frmMain action="OfsInfoDetailOperation.jsp?isdialog=1" method=post  >
<input class=inputstyle type=hidden name="backto" value="<%=backto%>">
<input class=inputstyle type="hidden" id='operation' name=operation value="add">
<wea:layout><!-- 基本信息 -->
	<wea:group context="<%=SystemEnv.getHtmlLabelName(1361 ,user.getLanguage())%>" attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></wea:item><!--标识 -->
		<wea:item attributes="{'id':'syscode_td'}">
  			  <wea:required id="syscodeimage" required="true" value="">
				<input class=inputstyle type='text' onpaste="return false" style='width:280px!important;' size='100' maxlength="100" name="syscode" _noMultiLang='true'  id="syscode"  onkeyup="this.value=this.value.replace(/[^0-9a-zA-Z]/g,'');" onblur="checkinput('syscode','syscodeimage');checkvalues(this.name);" >
            </wea:required>
		</wea:item>

		<wea:item><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item><!--简称 -->
		<wea:item>
            <wea:required id="sysshortnameimage" required="true">
            	<input class=inputstyle type=text style='width:280px!important;' size=100 maxlength="100" name="sysshortname"   id="sysshortname" onchange='checkinput("sysshortname","sysshortnameimage");checkvalues(this.name);' onblur="checkshortname();">
            </wea:required>
		</wea:item>	
		<wea:item><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></wea:item><!--全称 -->
		<wea:item>
            <wea:required id="sysfullnameimage" required="true">
            	<input class=inputstyle type=text style='width:280px!important;' size=100 maxlength="100" name="sysfullname"   id="sysfullname" onchange='checkinput("sysfullname","sysfullnameimage");checkvalues(this.name);'>
            </wea:required>
		</wea:item>	
		<wea:item><%=SystemEnv.getHtmlLabelNames("32363,120",user.getLanguage())%>IP</wea:item><!--接口安全IP-->
		<wea:item>
            <wea:required id="SecurityIpimage" required="false">
            	<input class=inputstyle type=text style='width:280px!important;' size=100 maxlength="100" name="securityip" onblur="checkEngMsg(this);" _noMultiLang='true' >
            	<SPAN class="e8tips" style="CURSOR: hand" id=remind title="<%=SystemEnv.getHtmlLabelName(128476,user.getLanguage()) %>"><IMG align=absMiddle src="/images/remind_wev8.png"></SPAN>
            </wea:required>
		</wea:item>
		<wea:item>PC<%=SystemEnv.getHtmlLabelNames("110,583",user.getLanguage())%></wea:item><!-- PC地址前缀 -->
		<wea:item>
            <wea:required id="Pcprefixurlimage" required="true">
            	<input class=inputstyle type=text style='width:280px!important;' size=100 maxlength="100" name="pcprefixurl" _noMultiLang='true'  onchange='checkinput("pcprefixurl","Pcprefixurlimage")'>
            </wea:required>
		</wea:item>
		<wea:item>APP<%=SystemEnv.getHtmlLabelNames("110,583",user.getLanguage())%></wea:item><!--APP地址前缀-->
		<wea:item>
            <wea:required id="Appprefixurlimage" required="false">
            	<input class=inputstyle type=text style='width:280px!important;' size=100 maxlength="100" name="appprefixurl" _noMultiLang='true' >
            </wea:required>
		</wea:item>	
		<wea:item><%=SystemEnv.getHtmlLabelNames("1867,23128",user.getLanguage())%></wea:item><!--人员转换规则-->
		<wea:item>
			<select id="hrmtransrule" style='width:120px!important;' name="hrmtransrule" >
			  <option value="0">OA<%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%>ID</option>
			  <option value="1">OA<%=SystemEnv.getHtmlLabelNames("674,83594",user.getLanguage())%></option><!-- OA登录账号-->
			  <option value="2"><%=SystemEnv.getHtmlLabelName(1933,user.getLanguage())%></option><!-- 工号-->
			  <option value="3"><%=SystemEnv.getHtmlLabelName(1887,user.getLanguage())%></option><!-- 身份证号-->
			  <option value="4"><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></option><!-- 电子邮件-->
			</select>
		</wea:item>	
		<wea:item><%=SystemEnv.getHtmlLabelNames("81855,125,16579",user.getLanguage())%></wea:item><!--自动创建流程类型-->
		<wea:item>
	           <input class="inputstyle" type="checkbox" tzCheckbox='true' id="autocreatewftype" name="autocreatewftype" value="1" checked>
		</wea:item>	
		<wea:item><%=SystemEnv.getHtmlLabelNames("93,16579",user.getLanguage())%></wea:item><!--编辑流程类型-->
		<wea:item>
	           <input class="inputstyle" type="checkbox" tzCheckbox='true' id="editwftype" name="editwftype" value="1" checked>
		</wea:item>	
		<wea:item><%=SystemEnv.getHtmlLabelNames("18526,126871",user.getLanguage())%></wea:item><!--接收流程数据-->
		<wea:item>
	           <input class="inputstyle" type="checkbox" tzCheckbox='true' id="receivewfdata" name="receivewfdata" value="1" checked>
		</wea:item>	
	</wea:group>
</wea:layout>
<br>
 </form>

<script language=javascript>
jQuery(document).ready(function(){
	jQuery(".e8tips").wTooltip({html:true});
});
//QC286837 [80][90]统一待办中心集成-编辑/注册异构系统页面，IP地址文本框可以输入中文 Start
function checkEngMsg(_this){
    var val = $(_this).val();
    var reg  = /^[^\u4e00-\u9fa5]{0,}$/;
    if(val && !(reg.test(val))){
        $(_this).val("");
	}

}
//QC286837 [80][90]统一待办中心集成-编辑/注册异构系统页面，IP地址文本框可以输入中文 End
function checkvalues(obj) {
	var timestamp = (new Date()).valueOf();
	var values = jQuery("#"+obj).val();
	var id = '';
	var params = "operation=checkinput&id="+id+"&values="+values+"&field="+obj+"&ts="+timestamp;
	jQuery.ajax({
			type : "post",
			cache : false,
			processData : false,
	        url: "/integration/ofs/OfsInfoDetailCheckInputAjax.jsp",
	        data: params,
	        success: function(msg){
	        	if(msg != ''){
	        		top.Dialog.alert(msg);
	        		jQuery("#"+obj).val("");
	        		jQuery("#"+obj+"image").html("<img align=\"absMiddle\" src=\"/images/BacoError_wev8.gif\">");
	        	}
		}
	});
}
function submitData() {
	var checkvalue = "syscode,sysshortname,sysfullname,pcprefixurl";
    if(check_form(frmMain,checkvalue)){
        
        frmMain.submit();
    }else{
  
    }
}

function onBack(){
	parentWin.closeDialog();
}


function doSaveAndNext() {
   jQuery("#operation").val("addAndNext"); 
   var checkvalue = "syscode,sysshortname,sysfullname,pcprefixurl";
    if(check_form(frmMain,checkvalue)){
        frmMain.submit();
    }else{
  
    }
}

//QC331058 [80][90][优化]统一待办中心集成-异构系统页面，名称内含的符号为反转义-优化start
//检查简称的输入
function checkshortname(){
	/* var value = jQuery("#sysshortname").val().replace(/[-\+=\`~!@#$%^&\*\(\)\[\]{};:'",.<>\/\?\\|]/g,"");
	jQuery("#sysshortname").val(value); */
	var value = jQuery("#sysshortname").val();
	value = $.trim(value);	
	if(isSpecialChar(value)){//包含特殊字符
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(132009,user.getLanguage())%>");
		jQuery("#sysshortname").val("");
		checkinput("sysshortname","sysshortnameimage");
		return false;
	}
	return true;
}

//检测字符中是否含有特殊字符
function isSpecialChar(str){
	var reg = /[-\+=\`~!@#$%^&\*\(\)\[\]{};:'",.<>\/\?\\|]/;
	return reg.test(str);
}
//QC331058 [80][90][优化]统一待办中心集成-异构系统页面，名称内含的符号为反转义-优化end
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