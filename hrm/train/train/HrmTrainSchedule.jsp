<%--
*@Modified By Charoes Huang
*@Date July 9,2004
*@Description For bug  304
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.train.TrainLayoutComInfo" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page" />
<jsp:useBean id="TrainPlanComInfo" class="weaver.hrm.train.TrainPlanComInfo" scope="page" />
<jsp:useBean id="TrainResourceComInfo" class="weaver.hrm.train.TrainResourceComInfo" scope="page" />
<jsp:useBean id="TrainComInfo" class="weaver.hrm.train.TrainComInfo" scope="page" />
<%@ include file="/hrm/header.jsp" %>
<html>
<HTML>
<%
String id = Util.null2String(request.getParameter("id"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}

function doDel(id){
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		var idArr = id.split(",");
		var ajaxNum = 0;
		for(var i=0;i<idArr.length;i++){
			ajaxNum++;
			jQuery.ajax({
				url:"TrainDayOperation.jsp?isdialog=1&operation=delete&id="+idArr[i],
				type:"post",
				async:true,
				complete:function(xhr,status){
					ajaxNum--;
					if(ajaxNum==0){
						_table.reLoad();
					}
				}
			});
		}
	});
}

var dialog = null;
var dialogforCloseBtn = parent.parent.getDialog(parent);//modify by zhh 2016-11-10 qc 187152 为当前窗口单独创建一个对象，并初始化
function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmTrainDayAdd&isdialog=1";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,16150",user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmTrainDayEdit&isdialog=1&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(16151,user.getLanguage())%>";
	}
	url += "&trainid=<%=id%>";
	
	dialog.Width = 600;
	dialog.Height = 503;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function onLog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/systeminfo/SysMaintenanceLog.jsp?isdialog=1&secid=65&sqlwhere=where operateitem=83 and relatedid="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}
</script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(89,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(678,user.getLanguage());
String needfav ="1";
String needhelp ="";

String name = Util.null2String(request.getParameter("name"));
String description = Util.null2String(request.getParameter("description"));

String qname = Util.null2String(request.getParameter("flowTitle"));

int perpage=Util.getIntValue(request.getParameter("perpage"),0);
rs.executeProc("HrmUserDefine_SelectByID",""+user.getUID());
if(rs.next()){
	perpage =Util.getIntValue(rs.getString(36),-1);
}

if(perpage<=1 )	perpage=10;
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="" name="searchfrm" id="searchfrm">
<input id="id" name="id" type="hidden" value="<%=id %>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(16151,user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
			<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>
<%
String backfields = " id, trainid, traindate, starttime, endtime, daytraincontent, "+
									 " (SELECT count(*) FROM  HrmTrainActor WHERE traindayid = HrmTrainDay.id) as actor,  "+
									 " (SELECT count(*) FROM  HrmTrainActor WHERE traindayid = HrmTrainDay.id and isattend =1) as attendactor  "; 
String fromSql = " FROM HrmTrainDay ";
String sqlWhere = " where trainid =  "+id;
String orderby = " traindate desc " ;
String tableString = "";

if(!qname.equals("")){
	sqlWhere += " and daytraincontent like '%"+qname+"%'";
}		

//操作字符串
String  operateString= "";
operateString = "<operates width=\"20%\">";
operateString+="<operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\" isalwaysshow=\"1\"/>";
operateString+="<operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\" isalwaysshow=\"1\"/>";
operateString+="</operates>";

tableString =" <table instanceid=\"hrmTrainScheduleTable\" pageId=\""+Constants.HRM_M_5051+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_M_5051,user.getUID(),Constants.HRM)+"\" tabletype=\"checkbox\" >"+
		" <checkboxpopedom showmethod=\"weaver.hrm.HrmTransMethod.getHrmTrainScheduleCheckbox\" id=\"checkbox\"  popedompara=\"column:id\" />"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Asc\"/>"+
    operateString+
    "			<head>"+
    "				<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(97,user.getLanguage()) +"\" column=\"traindate\" orderkey=\"traindate\" />"+
    "				<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(742,user.getLanguage()) +"\" column=\"starttime\" orderkey=\"starttime\" />"+
    "				<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(743,user.getLanguage()) +"\" column=\"endtime\" orderkey=\"endtime\" />"+
    "				<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(15916,user.getLanguage()) +"\" column=\"daytraincontent\" orderkey=\"daytraincontent\" />"+
    "				<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(33428,user.getLanguage()) +"\" column=\"actor\" orderkey=\"actor\" />"+
    "				<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(33429,user.getLanguage()) +"\" column=\"attendactor\" orderkey=\"attendactor\" />"+
    "			</head>"+
    " </table>";
%>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" /> 
  <%if("1".equals(isDialog)){ %>
  </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialogforCloseBtn.closeByHand();">
	    	</wea:item>
	   	</wea:group>
	  </wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
</BODY>
 </HTML>
