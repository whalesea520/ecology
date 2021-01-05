<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<script type="text/javascript">
var parentWin = null;
var dialog = null;
try{
parentWin = parent.getParentWindow(window);
dialog = parent.parent.getDialog(window);
}catch(e){}
 
</script>
<%
	//判断只有管理员才有权限
	int userid = user.getUID();
	if(userid!=1) {
		response.sendRedirect("/notice/noright.jsp");
	  return;
	}
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = "";
	String needfav = "1";
	String needhelp = "";
	String menuTitle = "";
	String message = request.getParameter("message");
	
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

String pathgroupname = SystemEnv.getHtmlLabelNames("18493,18499",user.getLanguage());
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<HTML>
	<HEAD>
		<TITLE>Add Xml</TITLE>

</HEAD>
<BODY style="overflow:hidden;">
	<jsp:include page="/systeminfo/commonTabHead.jsp">
				<jsp:param name="mouldID" value="upgrade" />
				<jsp:param name="navName" value="新建XML文件" />
	</jsp:include>
	<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
	</table>
	<div id="tabDiv" >
	   <span style="font-size:14px;font-weight:bold;"></span> 
	</div>
	<div class="cornerMenuDiv"></div>
	<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'></div>
	<form name="frmAdd" method="post" action="AddXmlOperation.jsp">
	<wea:layout>
		<wea:group context="<%=pathgroupname%>">
		<wea:item><%=SystemEnv.getHtmlLabelNames("18493,18499",user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="pathimage" required="true">
			<input class="inputstyle" name="path" id="path" value="" onchange='checkinput("path","pathimage")'></input>
			</wea:required>
			&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" style="width:100%;max-width:120px!important;" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(83413,user.getLanguage())%>" onclick="onSubmit()"/>
		
		</wea:item>
		</wea:group>
	<wea:group context="XML内容(请根据需要进行修改)">
	<wea:item attributes="{colspan:'full',id:'tableitem'}">
		<textarea id="contentarea" name="contentarea" style="width:100%!important;overflow:auto;">
		</textarea>
	</wea:item>
	</wea:group>
	</wea:layout>
	</form>
</div>
</BODY>
</HTML>


<script type="text/javascript">
	$(document).ready(function(){
		jQuery('#menu_content').perfectScrollbar();
		jQuery("#topTitle").topMenuTitle();	
		jQuery(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
		jQuery("#tabDiv").remove();
		$("#tableitem").removeClass("fieldName");
		var docheight = $(document).height();
		var areaheight = docheight*0.8;
		$("#contentarea").height(areaheight);
		$("#contentarea").text("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n<root>\r\n</root>");
	});
	
	function onSubmit() {
		var path = $("#path").val();
		if(path=="") {
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("18493,18499",user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18622,user.getLanguage())%>");
			return;
		}
		if(path.indexOf(".xml") <= 0) {
			top.Dialog.alert("非XML文件");
			return;
		}
		var contentarea = $("#contentarea").val().trim();
		if(contentarea=="") {
			top.Dialog.alert("请输入XML文件内容");
			return;
		}
		$.ajax({
			url:"AddXmlOperation.jsp",
			dataType:"json",
			type:"post",
			data:{
				"path":$("#path").val(), 
				"contentarea":$("#contentarea").val().trim(),
			},
			success:function(data){
				var res = data.message;
				if(res=="1") {
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(25021,user.getLanguage())%>");
					return;
				} else if(res=="2") {
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82259,user.getLanguage())%>");
					return;
				} else if(res=="error") {
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18493,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(82259,user.getLanguage())%>");
					return;
				} else if(res=="ok") {
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(25008,user.getLanguage())%>");
					window.location.href="EditXml.jsp?fpath="+$("#path").val();
				}
			}
		});
	}
	//屏蔽回车事件
	$(document).keydown(function(event){
		  switch(event.keyCode){
		     case 13:return false; 
		     }
	});
</script>