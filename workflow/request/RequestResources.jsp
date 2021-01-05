
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.request.RequestResources"%>
<%@page import="weaver.conn.RecordSet"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<!DOCTYPE html>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>

<%
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid=user.getUID(); 
int usertype = 0 ;
int requestid = Util.getIntValue(request.getParameter("requestid"));
int workflowid = Util.getIntValue(request.getParameter("workflowid"));
int isbill = Util.getIntValue(request.getParameter("isbill"));
int formid = Util.getIntValue(request.getParameter("formid"));
int tabindex = Util.getIntValue(request.getParameter("tabindex"), 0);
String reportid = Util.null2String(request.getParameter("reportid"));
String isfromreport = Util.null2String(request.getParameter("isfromreport"));
String isfromflowreport = Util.null2String(request.getParameter("isfromflowreport"));
String isshared = Util.null2String(request.getParameter("iswfshare"));

RequestResources reqresources = new RequestResources(user, workflowid, requestid, isbill, formid,reportid,isfromreport,isfromflowreport,isshared);
%>
<HTML><HEAD>

<!--以下是显示定制组件所需的js -->
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
<script type='text/javascript' src='/dwr/interface/DocReadTagUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%@ include file="/hrm/resource/simpleHrmResource_wev8.jsp" %>

<script type="text/javascript">
function ondownload(id, p2, tagert) {
	//window.top.location='/weaver/weaver.file.FileDownload?fileid=' + id + '&download=1&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid %>&desrequestid=0&fromrequest=1';
	document.location.href='/weaver/weaver.file.FileDownload?fileid=' + id + '&download=1&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid %>&desrequestid=0';
	return ;
}

function doopenreq(id, p2, tagert) {
	window.open('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&isrequest=1&requestid=' + id);
	return ;
}

function doopendoc(id, p2, tagert) {
	window.open('/docs/docs/DocDsp.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&isrequest=1&id=' + id + '&requestid=<%=requestid %>');
	return ;
}
function openDocExt(showid,versionid,docImagefileid,isedit){
    jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
    // isAppendTypeField参数标识  当前字段类型是附件上传类型，不论该附件所在文档内容是否为空、或者存在最新版本，在该链接打开页面永远打开该附件内容、不显示该附件所在文档内容。
    if(isedit==1){
        openFullWindowHaveBar("/docs/docs/DocEditExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>");
    }else{
        openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>&isAppendTypeField=1");
    }
}
function addDocReadTag(docId) {
    //user.getLogintype() 当前用户类型  1: 类别用户  2:外部用户
    DocReadTagUtil.addDocReadTag(docId,<%=user.getUID()%>,<%=user.getLogintype()%>,"<%=request.getRemoteAddr()%>",returnTrue);
}
function returnTrue(o){
	return ;
}
</script>

<style type="text/css">
.resourcename {

}
.resourcenameimage {
	display:inline-block;
	height:23px;
	width:23px;
}

.xls {
	background:url('/images/ecology8/workflow/2_wev8.jpg')
}


</style>
</head>
<BODY scroll="no">
<%
String tableString = "";
int perpage=10;              

String sqlWhere = "";
String orderby ="";
String backfields = "";
String fromSql  = "";

fromSql = " " + reqresources.getReqResSqlByType(tabindex) + " ";
sqlWhere = " where 1=1 ";
backfields = " id, resname, restype, creator, creatortype, createdate, docid ,versionid ";
orderby = " id ";

tableString =   " <table instanceid=\"workflow_RequestSourceTable\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_REQUEST_REQUESTRESOURCES,user.getUID())+"\" >"+
                "     <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlorderby=\"" + orderby + "\" sqlprimarykey=\"id\" sqlsortway=\"ASC\" sqlisdistinct=\"true\" />"+
                "     <head>"+
                "         <col width=\"5%\" text=\"\" column=\"restype\" orderkey=\"restype\" transmethod=\"weaver.workflow.request.RequestResources.getResImageHtml\" otherpara=\"column:restype\" />"+
                "         <col width=\"45%\" text=\""+SystemEnv.getHtmlLabelName(15924,user.getLanguage())+"\" column=\"resname\" orderkey=\"resname\" transmethod=\"weaver.workflow.request.RequestResources.getResDisplayHtml\" otherpara=\"column:id+column:restype+" + requestid + "+" +  userid +"+column:docid+column:versionid\" />"+
                "         <col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creator\" otherpara=\"column:creatortype\" orderkey=\"creator\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />"+
                "         <col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(1339,user.getLanguage())+"\" column=\"createdate\" orderkey=\"createdate\" />"+
                "       </head>"+
                "     <operates>"+
				"  		<popedom transmethod=\"weaver.workflow.request.RequestResources.getResOperaotes\" otherpara=\"column:restype+column:docid+column:resname\"></popedom> " +
                "		<operate href=\"javascript:doopenreq();\" text=\""+SystemEnv.getHtmlLabelName(360,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
                "		<operate href=\"javascript:doopendoc();\" text=\""+SystemEnv.getHtmlLabelName(360,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
                "		<operate href=\"javascript:ondownload();\" text=\""+SystemEnv.getHtmlLabelName(31156,user.getLanguage())+"\" target=\"_self\" index=\"2\"/>"+
				"		</operates>"+                   
                " </table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_REQUEST_REQUESTRESOURCES %>"/>
<TABLE width="100%" cellspacing=0 cellpadding="0" height="100%">
    <tr>
        <td valign="top">  
            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
        </td>
    </tr>
</TABLE>	

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;" >	
			<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu" id="rightclickcornerMenu"></span>
		</td>
	</tr>
</table>		
</body>
</html>
