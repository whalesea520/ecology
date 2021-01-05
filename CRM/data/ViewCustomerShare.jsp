
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" /> <!--added by xwj for td2044 on 2005-05-30-->

<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(621,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:addShare(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+",javascript:delShare(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>

<table id="topTitle" cellpadding="0" cellspacing="0" >
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage()) %>" class="e8_btn_top"  onclick="addShare()"/>&nbsp;&nbsp;
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(23777, user.getLanguage()) %>" class="e8_btn_top" onclick="delShare()"/>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 


<form id=weaver name=frmmain method=post action="ViewCustomerShare.jsp">

<%
String CustomerID=Util.null2String(request.getParameter("CustomerID"));
String language=String.valueOf(user.getLanguage());
String backFields = " id,sharetype,contents,seclevel,seclevelMax,rolelevel,sharelevel,jobtitleid,joblevel,scopeid,isdefault ";
String sqlFrom = " CRM_ShareInfo ";
int perpage=10;
String whereclause=" where ( relateditemid = "+CustomerID+" and (isdefault is null or (isdefault=1 and sharelevel=3 and sharetype=1)))";
String operateString= "<operates width=\"15%\">";
operateString+=" <popedom transmethod=\"weaver.splitepage.operate.SpopForCus.getCusShareOpratePopedom\" column=\"isdefault\"></popedom> ";
operateString+="     <operate href=\"javascript:delShareQuick()\"   text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\"  index=\"0\"/>";
operateString+="</operates>";
String tableString=""+
			  "<table  pageId=\""+PageIdConst.CRM_ShreList+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_ShreList,user.getUID(),PageIdConst.CRM)+"\" tabletype=\"checkbox\">"+
			  "<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"id\" sqlorderby=\"sharetype\" sqlsortway=\"asc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(whereclause)+"\"/>"+
			  "<checkboxpopedom showmethod=\"weaver.splitepage.operate.SpopForCus.getCusShareCheckInfo\" popedompara=\"column:isdefault\"  />"+
			  "<head>"+                             
					  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(21956,user.getLanguage())+"\" column=\"sharetype\" orderkey=\"sharetype\" otherpara=\""+language+"\" transmethod=\"weaver.crm.CRMTransMethod.getShareTypeName\"/>"+
					  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(106,user.getLanguage())+"\" column=\"contents\" otherpara=\"column:sharetype+"+language+"+column:jobtitleid+column:joblevel+column:scopeid\" transmethod=\"weaver.crm.CRMTransMethod.getShareValueName\"/>"+
					  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage())+"\" column=\"seclevel\" otherpara=\"column:sharetype+column:rolelevel+"+language+"+column:seclevelMax+column:joblevel+column:scopeid\" transmethod=\"weaver.crm.CRMTransMethod.getSecLevelName\"/>"+
					  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(3005,user.getLanguage())+"\" column=\"sharelevel\" orderkey=\"sharelevel\" otherpara=\""+language+"\" transmethod=\"weaver.crm.CRMTransMethod.getShareLevelName\"/>"+
			  "</head>"+operateString+
			  "</table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.CRM_ShreList%>">
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>

</form>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<script type="text/javascript">

$(document).ready(function(){
	$("#topTitle").topMenuTitle();
});

var dialog=null;

function closeDialog(){
	if(dialog)
		dialog.close();
}
//新建、编辑称呼 add by Dracula @2014-1-23
function addShare(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/CRM/data/AddShare.jsp?isfromtab=true&itemtype=2&CustomerID=<%=CustomerID%>&isfromCrmTab=true";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(18645,user.getLanguage()) %>";
	
	dialog.Width = 420;
	dialog.Height =300;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
	document.body.click();	
}

function addShareCallback(){
	_table.reLoad();
	dialog.close();
}

function delShare(){
	var id=_xtable_CheckedCheckboxId();
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>!");
		return;
	}
	id = id.substring(0,id.length-1);
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		jQuery.post("/CRM/data/ShareOperation.jsp",{"method":"batchDelete","CustomerID":"<%=CustomerID%>","id":id},function(){
			_table.reLoad();
		});
	});
}

function delShareQuick(id){
	
	jQuery.ajax({
		url:"/CRM/data/ShareOperation.jsp?method=delete&CustomerID=<%=CustomerID%>&id="+id,
		type:"post",
		async:true,
		complete:function(xhr,status){
			_table.reLoad();
		}
	});
}

</script>
</body>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
