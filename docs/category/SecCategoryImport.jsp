<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	if (!HrmUserVarify.checkUserRight("DocSecCategoryAdd:add",user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent.window);
var dialog = parent.parent.getDialog(parent.window);
</script>
<!--For Jquery UI-->
<link href="/js/jquery/ui/jquery-ui_wev8.css" type="text/css" rel=stylesheet>
<script type="text/javascript" src="/js/jquery/ui/ui.core_wev8.js"></script>
<!--For Dialog-->
<script type="text/javascript" src="/js/jquery/ui/ui.dialog_wev8.js"></script>

</head>
<%
	String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
    String isDialog = Util.null2String(request.getParameter("isdialog"));
	String flag=Util.null2String(request.getParameter("flag"));
	String titlename = SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(18596,user.getLanguage());	
	String categoryid=Util.null2String(request.getParameter("categoryid"));
	//是否开启分权并且有目录id,并且分权分部subcompanyid为空时去查询
	boolean isUseDocManageDetach=ManageDetachComInfo.isUseDocManageDetach();
	if(isUseDocManageDetach&&Util.getIntValue(categoryid,0)>0&&Util.getIntValue(subcompanyid,0)<=0){
		String parentId="";
		RecordSet.executeSql("select id,parentid,subcompanyid from docseccategory  where id = "+categoryid);
		if(RecordSet.next()){
			parentId=RecordSet.getString("parentid");
			subcompanyid=RecordSet.getString("subcompanyid");
		}												
			while(Util.getIntValue(parentId,0)>0&&Util.getIntValue(subcompanyid,0)<=0){	//目录还有上级目录并且分权分部subcompanyid还没查到
				RecordSet.executeSql("select id,parentid,subcompanyid from docseccategory  where id = "+parentId);
				if(RecordSet.next()){
					parentId=RecordSet.getString("parentid");
					subcompanyid=RecordSet.getString("subcompanyid");
				}else{
					break;
				}
			}		
	}
	
%>
<BODY>
<div id="over" class="over" style="display: none;position: absolute;top: 0;left: 0;width: 100%;height: 100%;background-color: white;opacity: 0.75;filter:Alpha(opacity=75);z-index: 1000;"></div>
<div id="loading2" class="loading2" style="display: none;position: absolute;top: 40%;left: 30%;width: 40%;height: 30%;z-index: 1001;font-size:16px;text-align: center;"><img src="/formmode/js/ext/resources/images/default/shared/blue-loading_wev8.gif"  /><%=SystemEnv.getHtmlLabelName(20904,user.getLanguage())%></div>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:dosubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(24644,user.getLanguage())+",javascript:openHistoryLog(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	<td></td>
	<td class="rightSearchSpan" style="text-align:right;">
		<input type=button class="e8_btn_top" id="dosubmit" onClick="dosubmit(this)" value="<%=SystemEnv.getHtmlLabelName(615, user.getLanguage())%>">
		<input type=button class="e8_btn_top" id="openHistoryLog" onClick="openHistoryLog()" value="<%=SystemEnv.getHtmlLabelName(24644, user.getLanguage())%>">
		<span id="mymenu" title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
	</td>
	</tr>
</table>
<FORM id=docform name=docform action="/docs/category/SecCategoryImportProcess.jsp" method=post enctype="multipart/form-data" >
 <input type=hidden id="subcompanyid" name="subcompanyid"  value=<%=subcompanyid%> />
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>'>
      <wea:item><%=SystemEnv.getHtmlLabelName(19971, user.getLanguage())%></wea:item>
      <wea:item><a href='/docs/category/inputexcelfile/categoryinput.xls' style="color: #30b5ff"><%=SystemEnv.getHtmlLabelName(28576, user.getLanguage())%></a>&nbsp;<%=SystemEnv.getHtmlLabelName(20211, user.getLanguage())%></wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(16699, user.getLanguage())%></wea:item>
      <wea:item>
        <input class=inputstyle style="width: 360px" type="file" name="excelfile" accept=".xls"  onchange='checkinput("excelfile","excelfilespan");this.value=trim(this.value)'><SPAN id=excelfilespan>
         <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
        </SPAN>
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(128518, user.getLanguage())%></wea:item>
      <wea:item>
        <INPUT class=InputStyle tzCheckbox="true" type=checkbox  value=1 name="isupdate" > 
		<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(128519, user.getLanguage())%>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
      </wea:item>
		</wea:group>
	</wea:layout> 
	
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())+SystemEnv.getHtmlLabelName(85,user.getLanguage())%>' attributes="{'samePair':'RemarkInfo','groupOperDisplay':'none','itemAreaDisplay':'block'}">
		  <wea:item attributes="{'colspan':'2'}">
			<BR>
		 	1、<%=SystemEnv.getHtmlLabelName(34275, user.getLanguage())%><a href='/docs/category/inputexcelfile/categoryinput.xls' style="color: #30b5ff"><%=SystemEnv.getHtmlLabelName(28576, user.getLanguage())%></a>。
			<BR><BR>
			2、<%=SystemEnv.getHtmlLabelName(128520, user.getLanguage())%>
			<BR><BR>
			3、<%=SystemEnv.getHtmlLabelName(128521, user.getLanguage())%>
			<BR><BR>
			4、<%=SystemEnv.getHtmlLabelName(128522, user.getLanguage())%>
			<BR><BR>
			5、<%=SystemEnv.getHtmlLabelName(128523, user.getLanguage())%>
			<BR><BR>
			6、<%=SystemEnv.getHtmlLabelName(128524, user.getLanguage())%>
			<BR><BR>			
			7、<%=SystemEnv.getHtmlLabelName(128525, user.getLanguage())%>
			<BR><BR>
			8、<%=SystemEnv.getHtmlLabelName(128526, user.getLanguage())%>
			<BR><BR>
		</wea:item>
		</wea:group>
	</wea:layout>	
</form>
<%if("1".equals(isDialog)){ %>
   </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.parent.getDialog(parent.window).close()">
			</wea:item>
		</wea:group>
	</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
			jQuery(".e8tips").wTooltip({html:true});
		});
	</script>
<%} %> 


<script language=javascript>

	
		
	if(<%=flag.equals("-1")%>){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128527,user.getLanguage())%>");
		parent.jQuery("#over,#loading2").remove();
	}

	function dosubmit() {
		if(check_form()) {
		  showLoading();
		  $("#docform").submit();
		}
	}
	function checkinput(elementname,spanid){
		var tmpvalue = $GetEle(elementname).value;
		// 处理$GetEle可能找不到对象时的情况，通过id查找对象
		if(tmpvalue==undefined)
			tmpvalue=document.getElementById(elementname).value;

		while(tmpvalue.indexOf(" ") >= 0){
			tmpvalue = tmpvalue.replace(" ", "");
		}
		if(!/\.xls$/.test(tmpvalue)){
			tmpvalue="";
			$GetEle(elementname).value = "";
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128528,user.getLanguage())%>");
			}
		if(tmpvalue != ""){
			while(tmpvalue.indexOf("\r\n") >= 0){
				tmpvalue = tmpvalue.replace("\r\n", "");
			}
			if(tmpvalue != ""){
				$GetEle(spanid).innerHTML = "";
			}else{
				$GetEle(spanid).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
			}
		}else{
			$GetEle(spanid).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		}
	}	
	function check_form()
	{
		if(document.docform.excelfile.value==""){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>！");
			return false;
		}
		return true;
	}
	function showLoading()
			{
				if(parent.jQuery("#over,#loading2").length == 0){
					parent.jQuery("body").append(jQuery("#over,#loading2").show());
				}else{
					parent.jQuery("#over,#loading2").show();
				}
			}	
/*打开历史导入记录*/
	function openHistoryLog(){
		dialog = new window.top.Dialog();
		dialog.currentWindow = window; 
		dialog.URL = "/docs/category/SecCategoryImportHistory.jsp?isdialog=1";
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(24644,user.getLanguage())%>";
		dialog.Width = 650;
		dialog.Height = 450;
		dialog.Drag = true;
		dialog.show();
	}
</script>

</BODY>
</HTML>
