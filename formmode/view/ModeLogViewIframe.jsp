<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rst" class="weaver.conn.RecordSetTrans" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />


<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(83,user.getLanguage());//日志
String needfav ="";
String needhelp ="";

String modeId = Util.null2String(request.getParameter("modeId"));
String relatedId = Util.null2String(request.getParameter("relatedId"));
String resourceid = Util.null2String(request.getParameter("resourceid"));
String fromdate = Util.null2String(request.getParameter("fromdate"));
String todate = Util.null2String(request.getParameter("todate"));
String operatetypeStr = "";
String[] operatetypeArr = request.getParameterValues("operatetype");
if(operatetypeArr != null){
	for(String stype : operatetypeArr){
		operatetypeStr += stype + ",";
	}
	if(!operatetypeStr.equals("")){
		operatetypeStr = operatetypeStr.substring(0, operatetypeStr.length() - 1);
	}
}else{
	String initFlag = Util.null2String(request.getParameter("initFlag"));
	if(initFlag.equals("1")){
		operatetypeStr = "1,2,5";
	}
}
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/FormmodeUtil_wev8.js"></script>
<style type="">
.logDetailLoading{
	background: url('/images/messageimages/loading_wev8.gif') no-repeat;
	background-position: 10px 5px;
}
</style>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:OnSubmit(),_self}";//搜索
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15033,user.getLanguage())+", javascript:window.parent.close(), _self} " ;//关闭窗口
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" onclick="javascript:OnSubmit()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>

<form name="frmSearch" id="frmSearch" method="post" action="/formmode/view/ModeLogViewIframe.jsp">
<input type="hidden" name="modeId" value="<%=modeId %>"/>
<input type="hidden" name="relatedId" value="<%=relatedId %>"/>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10px">
<col width="*">
<col width="10px">
</colgroup>
<tr>
	<td></td>
	<td valign="top">
		<table class="ViewForm">
			<COLGROUP>
				<COL width="15%">
				<COL width="35%">
				<COL width="15%">
				<COL width="35%">
			</COLGROUP>
			<tr class="Title">
				<th colspan="4" style="padding-left: 5px;"><%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%><!-- 查询条件 --></th>
			</tr>
			<tr class="Spacing" style="height: 1px !important;">
				<td class="Line1" colspan="4"></td>
			</tr>
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(99,user.getLanguage())%><!-- 操作者 --></td>
				<td class="Field">
				<brow:browser viewType="0" name="resourceid" browserValue='<%=resourceid%>' 
									browserOnClick="onShowResourceID('resourceid','resourceidspan')"
									hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
									completeUrl="/data.jsp" width="135px" 
									browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%>'>
							</brow:browser>
				</td>
				<td><%=SystemEnv.getHtmlLabelName(15503,user.getLanguage())%><!-- 操作类型 --></td>
				<td class="Field">
					<input type="checkbox" value="1" name="operatetype" <%if(operatetypeStr.indexOf("1") != -1){%> checked="checked" <%}%>/><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%><!-- 新建 -->&nbsp;
					<input type="checkbox" value="2" name="operatetype" <%if(operatetypeStr.indexOf("2") != -1){%> checked="checked" <%}%>/><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%><!-- 编辑 -->&nbsp;
					<input type="checkbox" value="4" name="operatetype" <%if(operatetypeStr.indexOf("4") != -1){%> checked="checked" <%}%>/><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%><!-- 查看 -->&nbsp;
					<input type="checkbox" value="5" name="operatetype" <%if(operatetypeStr.indexOf("5") != -1){%> checked="checked" <%}%>/><%=SystemEnv.getHtmlLabelName(25465,user.getLanguage())%><!-- 批量修改 -->
				</td>
			</tr>
			<tr style="height:1px"><td colspan=4 class=Line></td></tr>
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%><!-- 日期 --></td>
				<td class="Field">
					<button class="Calendar" id="SelectDate" onclick="getLimitStartDate('fromdatespan','fromdate','todatespan','todate')" type="button"></button>&nbsp;
					<span id="fromdatespan"><%=fromdate %></span> -&nbsp;&nbsp;
					<button class="Calendar" id="SelectDate2" onclick="getLimitEndDate('fromdatespan','fromdate','todatespan','todate')" type="button"></button>&nbsp; 
					<span id="todatespan"><%=todate %></span>
					<input name="fromdate" id="fromdate" type="hidden" value="<%=fromdate %>">
					<input name="todate" id="todate" type="hidden" value="<%=todate %>">
				</td>
				<td class="Field"></td>
				<td class="Field"></td>
			</tr>
			<tr style="height:1px"><td colspan=4 class=Line></td></tr>
		</table>
		<br/>
		<%
		String perpage = "10";
		String backFields = "a.id, a.relatedid, a.operatedesc, a.operateuserid, a.operatedate, a.operatetime, a.clientaddress, " + modeId + " as modeid ";
		String sqlFrom = " from ModeViewLog_"+modeId+" a";
		String sqlWhere = " where a.relatedid= " + relatedId;
		if(!"".equals(resourceid))
		{
		    sqlWhere += " and a.operateuserid = " + resourceid;
		}
		if(!"".equals(fromdate))
		{
		    sqlWhere += " and a.operatedate >= '" + fromdate + "'";				    
		}
		if(!"".equals(todate))
		{
		    sqlWhere += " and a.operatedate <= '" + todate + "'";
		}
		if(!"".equals(operatetypeStr)){
			 sqlWhere += " and a.operatetype in (" + operatetypeStr + ")";
		}
		String tableString=""+
					  "<table  pagesize=\""+perpage+"\" tabletype=\"none\">"+
						  "<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"a.id\" sqlsortway=\"Desc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"/>"+
						  "<head>"+//操作者
								  "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(99,user.getLanguage())+"\" column=\"operateuserid\" orderkey=\"operateuserid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" />"+
								  //日期
								  "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(97,user.getLanguage())+"\" column=\"operatedate\" orderkey=\"operatedate\" />"+
								  //时间
								  "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(277,user.getLanguage())+"\" column=\"operatetime\" orderkey=\"operatetime\" />"+
								  //类型
								  "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"operatedesc\" orderkey=\"operatedesc\" />"+
								  "<col width=\"15%\"  text=\"IP\" column=\"clientaddress\" orderkey=\"clientaddress\" transmethod=\"weaver.formmode.service.FormInfoService.getViewLogClientaddress\" otherpara=\"column:id\"/>"+
								  //"<col width=\"15%\"  text=\"字段日志明细\" column=\"id\" orderkey=\"id\" transmethod=\"weaver.formmode.service.FormInfoService.getViewFieldLogDetailHtm\" />"+
						  "</head>"+
						  "<operates><popedom transmethod=\"weaver.formmode.service.FormInfoService.getViewLogOperate\" otherpara=\"column:modeid\"></popedom> "
							 + "<operate href=\"javascript:viewFieldLogDetail();\" text=\""+SystemEnv.getHtmlLabelName(82274,user.getLanguage())+"\" target=\"_self\"  index=\"0\"/>"//字段日志
							 + "</operates>"+
					  "</table>";
		%>
		
		<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>
	</td>
	<td></td>
</tr>
</table>
</form>

<script type="text/javascript">
function OnSubmit(){
	var frmSearch = document.getElementById("frmSearch");
	frmSearch.submit();
}

function viewFieldLogDetail(viewlogid){
	var $viewFieldLogDetailA = $("#viewFieldLogDetailA_" + viewlogid);
	
	var $viewFieldLogDetailTR = $("#viewFieldLogDetailTR_" + viewlogid);
	
	if($viewFieldLogDetailTR.length == 0){
		
		$viewFieldLogDetailTR = $("<tr id='viewFieldLogDetailTR_"+viewlogid+"' style='vertical-align: middle;height:auto;display:none;'><td colspan='6' style='padding-left:30px;padding-bottom:25px;background-color:#fff !important;height:auto;'></td></tr>");
		var $viewFieldLogDetailTD = $viewFieldLogDetailTR.children("td");
		$viewFieldLogDetailTD.addClass("logDetailLoading");
		$viewFieldLogDetailTD.html("<%=SystemEnv.getHtmlLabelName(82275,user.getLanguage())%>");//数据加载中，请稍候...
		var $viewLogTR = $viewFieldLogDetailA.parent().parent();
		$viewLogTR.after($viewFieldLogDetailTR);
		
		FormmodeUtil.doAjaxDataLoad('/formmode/setup/formSettingsAction.jsp?action=getFieldLogDetail&viewlogid='+viewlogid+'&modeid=<%=modeId%>', function(datas){
			
			var containerHtml = "<table class='ListStyle' style='border:1px solid #dadada;width:100%;table-layout: fixed;' cellspacing='0'>" +
			"<thead><tr class='HeaderForXtalbe'>" +
			"<th align='left' style='height: 30px; overflow: hidden; display: none; white-space: nowrap; -ms-word-break: keep-all; -ms-text-overflow: ellipsis;'></th>" +
			"<th align='left' style='width: 15%; height: 30px; overflow: hidden; white-space: nowrap; -ms-word-break: keep-all; -ms-text-overflow: ellipsis;'><%=SystemEnv.getHtmlLabelName(31644,user.getLanguage())%>&nbsp;</th>" +//字段名
			//"<th align='left' style='width: 15%; height: 30px; overflow: hidden; white-space: nowrap; -ms-word-break: keep-all; -ms-text-overflow: ellipsis;'>字段名称&nbsp;</th>" +
			"<th align='left' style='width: 15%; height: 30px; overflow: hidden; white-space: nowrap; -ms-word-break: keep-all; -ms-text-overflow: ellipsis;'><%=SystemEnv.getHtmlLabelName(82276,user.getLanguage())%>&nbsp;</th>" +//字段值(当前修改)
			"<th align='left' style='width: 15%; height: 30px; overflow: hidden; white-space: nowrap; -ms-word-break: keep-all; -ms-text-overflow: ellipsis;'><%=SystemEnv.getHtmlLabelName(82277,user.getLanguage())%>&nbsp;</th>" +//字段值(修改前)
			"<th align='left' style='width: 15%; height: 30px; overflow: hidden; white-space: nowrap; -ms-word-break: keep-all; -ms-text-overflow: ellipsis;'><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%>&nbsp;</th>" +//操作
			"</tr></thead>" +
			"<tbody>";
			
			for(var i = 0; datas && i < datas.length; i++){
				var data = datas[i];
				containerHtml += "<tr style='vertical-align: middle;'>" +
				"<td style='background-color:#fff !important;width: 3%; height: 30px; display: none;'>&nbsp;</td>" +
				"<td align='left' style='background-color:#fff !important;color:#000;height: 30px; overflow: hidden; vertical-align: middle; white-space: nowrap; -ms-word-break: keep-all; -ms-text-overflow: ellipsis;'>"+data.labelname+"<span style='margin-left:5px;font-size:11px;color:#929393;'>("+data.fieldname+")</span></td>" +
				//"<td align='left' style='background-color:#fff !important;color:#000;height: 30px; overflow: hidden; vertical-align: middle; white-space: nowrap; -ms-word-break: keep-all; -ms-text-overflow: ellipsis;'>"+data.fieldname+"</td>" +
				"<td align='left' style='background-color:#fff !important;color:#000;height: 30px; overflow: hidden; vertical-align: middle; white-space: nowrap; -ms-word-break: keep-all; -ms-text-overflow: ellipsis;'>"+data.fieldvalue+"</td>" +
				"<td align='left' style='background-color:#fff !important;color:#000;height: 30px; overflow: hidden; vertical-align: middle; white-space: nowrap; -ms-word-break: keep-all; -ms-text-overflow: ellipsis;'>"+data.prefieldvalue+"</td>" +
				"<td align='left' style='background-color:#fff !important;color:#000;height: 30px; overflow: hidden; vertical-align: middle; white-space: nowrap; -ms-word-break: keep-all; -ms-text-overflow: ellipsis;'><a href=\"javascript:viewFieldLogDetail2("+data.fieldid+",'-"+data.labelname+"("+data.fieldname+")');\"><%=SystemEnv.getHtmlLabelName(82278,user.getLanguage())%></a></td>" +//查看该字段所有日志
				"</tr>";
			}
			
			containerHtml += "</tbody></table>";
			//containerHtml = "";		
			$viewFieldLogDetailTD.removeClass("logDetailLoading");
			$viewFieldLogDetailTD.html(containerHtml);
		});
	}
	
	 if($viewFieldLogDetailTR.is(':visible')){
		 $viewFieldLogDetailTR.fadeOut(300);
		 $viewFieldLogDetailA.html("<%=SystemEnv.getHtmlLabelName(82279,user.getLanguage())%>");//点击查看
	 }else{
		 $viewFieldLogDetailTR.fadeIn(300);
		 $viewFieldLogDetailA.html("<%=SystemEnv.getHtmlLabelName(82280,user.getLanguage())%>");//点击隐藏
	 }
}

function viewFieldLogDetail2(fieldid, desc){
	var menuStyle_dialog = new window.top.Dialog();
	menuStyle_dialog.currentWindow = window;   //传入当前window
 	menuStyle_dialog.Width = 700;
 	menuStyle_dialog.Height = 500;
 	menuStyle_dialog.maxiumnable=true;
 	menuStyle_dialog.Modal = true;
 	var t = "<%=SystemEnv.getHtmlLabelName(261,user.getLanguage()) + SystemEnv.getHtmlLabelName(83,user.getLanguage())%>";//字段日志
 	if(desc){
 		t += desc;
 	}
 	menuStyle_dialog.Title = t; 
 	menuStyle_dialog.URL = "/formmode/view/ModeLogViewDetail.jsp?modeId=<%=modeId%>&relatedId=<%=relatedId%>&fieldid="+fieldid;
 	menuStyle_dialog.show();
}

function onShowResourceID(inputname,spanname){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			_displayTemplate:"#b{name}",
			_displaySelector:"",
			_required:"no",
			_displayText:"",
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
		
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp",
	    		"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if (datas) {
		if (datas.id!= "") {
			
			$("#"+spanname).html("<A href='javascript:openhrm("+datas.id+");' onclick='pointerXY(event);'>"+datas.name+"</A>");

			$("input[name="+inputname+"]").val(datas.id);
		}else{
			$("#"+spanname).html("");
			$("input[name="+inputname+"]").val("");
		}
	}
}
</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
