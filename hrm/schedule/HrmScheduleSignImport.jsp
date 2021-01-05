<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
<%
	if (!HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	//jQuery("#searchfrm").submit();
}
</script>
<STYLE type=text/css>
#loading{
    position:absolute;
    left:45%;
    background:#ffffff;
    top:40%;
    padding:8px;
    z-index:20001;
    height:auto;
    border:1px solid #ccc;
    display:none;
}
</STYLE>

</head>
<%
	String imagefilename = "/images/hdHRMCard_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(17887, user.getLanguage());
	String needfav = "1";
	String needhelp = "";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:dosubmit();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	<td></td>
	<td class="rightSearchSpan" style="text-align:right;">
		<input type=button class="e8_btn_top" onClick="dosubmit()" value="<%=SystemEnv.getHtmlLabelName(615, user.getLanguage())%>">
		<!-- 
		<input type=button class="e8_btn_top" onClick="openHistoryLog()" value="<%=SystemEnv.getHtmlLabelName(24644, user.getLanguage())%>">
		 -->
		<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
	</td>
	</tr>
</table>
<FORM id=frmMain name=frmMain action="HrmScheduleSignImportProcess.jsp" method=post enctype="multipart/form-data" target="downLoad">
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(33582, user.getLanguage())%></wea:item>
      <wea:item>
        <select name="keyField" id="keyField" style="width: 80px;">
            <option value="workcode"><%=SystemEnv.getHtmlLabelName(714, user.getLanguage())%></option>
            <option value="lastname"><%=SystemEnv.getHtmlLabelName(413, user.getLanguage())%></option>
        </select>
        <span style="" >
                <%=SystemEnv.getHtmlLabelName(33583, user.getLanguage())%>
        </span>
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(16699, user.getLanguage())%></wea:item>
      <wea:item>
        <input class=inputstyle style="width: 360px" type="file" name="excelfile" onchange='checkinput("excelfile","excelfilespan");this.value=trim(this.value)'><SPAN id=excelfilespan>
         <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
        </SPAN>
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(27625, user.getLanguage())%></wea:item>
      <wea:item><a href='/hrm/schedule/inputexcellfile/input1.xls'><%=SystemEnv.getHtmlLabelName(22273, user.getLanguage())%></a>&nbsp;</wea:item>
		</wea:group>
	</wea:layout> 
</form>
<wea:layout type="2col">
<wea:group context='<%=SystemEnv.getHtmlLabelName(33584,user.getLanguage())%>' attributes="{'groupOperDisplay':'none','itemAreaDisplay':'block'}">
		<wea:item attributes="{'colspan':'full'}">
			<!-- 编号 姓名 用户类别	考勤类别	考勤日期	考勤时间	客户端IP -->
			1、<%=SystemEnv.getHtmlLabelName(124999,user.getLanguage())%>。<br>
			2、<%=SystemEnv.getHtmlLabelName(125000,user.getLanguage())%>。<br>
			3、<%=SystemEnv.getHtmlLabelName(125001,user.getLanguage())%>。<br>
			4、<%=SystemEnv.getHtmlLabelName(125002,user.getLanguage())%>。 <br>
			5、<%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%>：<%=SystemEnv.getHtmlLabelName(125003,user.getLanguage())%><br>
			6、<%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%>：<%=SystemEnv.getHtmlLabelName(125004,user.getLanguage())%><br>
			<!--
			7、<%=SystemEnv.getHtmlLabelName(16044,user.getLanguage())%>：<%=SystemEnv.getHtmlLabelName(125005,user.getLanguage())%><br>
			-->
			7、<%=SystemEnv.getHtmlLabelName(33456,user.getLanguage())%>：<%=SystemEnv.getHtmlLabelName(125006,user.getLanguage())%><br>
			8、<%=SystemEnv.getHtmlLabelName(27961,user.getLanguage())%>：<%=SystemEnv.getHtmlLabelName(125007,user.getLanguage())%><br>
			9、<%=SystemEnv.getHtmlLabelName(33586,user.getLanguage())%>：<%=SystemEnv.getHtmlLabelName(125008,user.getLanguage())%><br>
		</wea:item>
	</wea:group>
</wea:layout>
<!-- 导入等待 -->
 <div id="loading">	
		<span  id="loading-msg" style="display: block;"><%=SystemEnv.getHtmlLabelName(84628, user.getLanguage())%>......</span>
 </div>
<iframe onload="jsIframeOnLoad()" name="downLoad" id="downLoad" class="flowFrame" frameborder="0" height="100%" width="100%;" style="display:none"></iframe>
<script language=javascript>
function check_form(frm)
{
	if(document.frmMain.excelfile.value==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>！");
		return false;
	}
	return true;
}

var isSubmit = false;
/*提交请求，通过隐藏iframe提交*/
function dosubmit() {
 	$("#downLoad").css("display","none");
	$("#downLoad").html("");
  if(check_form(document.frmMain)) {
      $("#loading").css("display","block");
      isSubmit = true;
      document.frmMain.submit() ; 
  }
}

function jsIframeOnLoad(){
 if(isSubmit){
 	$("#loading").css("display","none");
 	$("#downLoad").css("display","");
 }
}
</script>
</BODY>
</HTML>
