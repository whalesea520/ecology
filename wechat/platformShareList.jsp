
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.splitepage.transform.SptmForSms" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerContacterComInfo" class="weaver.crm.Maint.CustomerContacterComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<HTML><HEAD>

<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

</head>
<%
int userid=user.getUID();   //Util.getIntValue(request.getParameter("userid"),0);
String platformid = Util.null2String(request.getParameter("id"));
 
String sqlwhere="where 1=1  ";
if(platformid!=null&&!"".equals(platformid)){
	sqlwhere+=" and platformid = '"+platformid+"' ";
}else{
	response.sendRedirect("/wechat/platformList.jsp");
	return;
}

String IDS = Util.null2String(request.getParameter("IDS"));
String operate = Util.null2String(request.getParameter("operate"));
String and="+";
if(null != IDS && !"".equals(IDS)){
	String temStr="";
	if("del".equals(operate)){//删除
		RecordSet.executeSql("select * from wechat_share where id in ("+IDS+")");
		while(RecordSet.next()){
			 SysMaintenanceLog.resetParameter();
			 SysMaintenanceLog.insSysLogInfo(user,RecordSet.getInt("platformid"),"删除共享",RecordSet.getInt("permissiontype")+and+RecordSet.getInt("seclevel")+and+RecordSet.getInt("seclevelMax")+and+RecordSet.getInt("typevalue"),"214","3",0,Util.getIpAddr(request));
		}
		temStr = "delete wechat_share where id in ("+IDS+")";
		RecordSet.executeSql(temStr);
	} 
}

String perpage=PageIdConst.getPageSize(PageIdConst.Wechat_ShareList,user.getUID());

String backFields = " * ";
String sqlFrom = " wechat_share t1";
String tableString=""+
			  "<table  pagesize=\""+perpage+"\" instanceid=\"platformTable\" tabletype=\"checkbox\">"+
			  "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"/>"+
			  "<head>"+                             
					  "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(21956,user.getLanguage())+"\" column=\"permissiontype\" orderkey=\"permissiontype\" transmethod=\"weaver.wechat.WechatTransMethod.getShareType\" otherpara=\""+user.getLanguage()+"\"/>"+
					  "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(106,user.getLanguage())+"\" column=\"typevalue\" transmethod=\"weaver.wechat.WechatTransMethod.getShareTypeValue\" otherpara=\"column:permissiontype\"/>"+
					  "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage())+"\" column=\"seclevel\" transmethod=\"weaver.wechat.WechatTransMethod.getLevel\" otherpara=\"column:seclevelMax+column:permissiontype\"/>"+
			  "</head>";
 tableString +=  "<operates>"+
				"		<operate href=\"javascript:delShare();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
				"</operates>";
tableString += "</table>"; 

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(32639,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY style="overflow: hidden;">

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:doAdd(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %>" class="e8_btn_top middle" onclick="doAdd()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" class="e8_btn_top middle" onclick="doDelete()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span id="hoverBtnSpan" class="hoverBtnSpan">
			
	</span>
</div>
<form id=weaverA name=weaverA method=post action="platformShareList.jsp">
	<input type="hidden" name="operate" value="">
	<input type="hidden" name="IDS" value="">
	<input type="hidden" name="id" value="<%=platformid %>">
</form>


<table width=100% border="0" cellspacing="0" cellpadding="0">
<tr>
	<td valign="top">
			<div class="zDialog_div_content" style="overflow-y:auto;overflow-x:hidden;">
				<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.Wechat_ShareList%>"/>
				 <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>
			</div>
	</td>
</tr>
</table>
 
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout type="2col">
	<!-- 操作 -->
     <wea:group context="">
    	<wea:item type="toolbar">
		  <input type="button"
			value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
			id="zd_btn_cancle" class="e8_btn_cancel" onclick="btn_cancle()">
	    </wea:item>
    </wea:group>
   </wea:layout>
</div>

</body>
<script language="javascript">

$(document).ready(function() {
	resizeDialog(document);
});

var parentWin = null;
var dialog = null;
try{
parentWin = parent.parent.getParentWindow(parent);
}catch(e){}

function btn_cancle(){
	parentWin.closeDialog();
}
 
var diag_vote;
function closeDialog(){
	diag_vote.close();
}

function closeDlgARfsh(){
	diag_vote.close();
	_table.reLoad();
}


function doDelete(){
	var deleteids = _xtable_CheckedCheckboxId();
	if(deleteids==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>");
		return;
	}else{
	    var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
   		window.top.Dialog.confirm(str,function(){
	        jQuery("input[name=operate]").val("del");
	        jQuery("input[name=IDS]").val(deleteids.substr(0,deleteids.length-1));
	        document.forms[0].submit();
	    });
    }
}

function doBack(){
	 
}

function delShare(id){
	var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
 	window.top.Dialog.confirm(str,function(){
       jQuery("input[name=operate]").val("del");
       jQuery("input[name=IDS]").val(id);
       document.forms[0].submit();
    });
    
}

function doAdd(){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = 450;
	diag_vote.Height = 300;
	diag_vote.Modal = true;
	diag_vote.maxiumnable = false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())+SystemEnv.getHtmlLabelName(19910,user.getLanguage())%>";
	diag_vote.URL = "/wechat/platformShareAddTab.jsp?platformid=<%=platformid%>";
	diag_vote.show();
}   

function preDo(){
	//tabSelectChg();
	$("#topTitle").topMenuTitle({});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#hoverBtnSpan").hoverBtn();
}
         
</script>

</html>
