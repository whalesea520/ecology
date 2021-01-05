<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

<!--<script language=javascript src="/js/ecology8/docs/docSearchExt_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/DocSearchInit_wev8.js"></script>-->

<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>

<script type="text/javascript">
/*
function onBtnSearchClick(){
  document.frmMain.action="/system/sysdetach/AppDetachEdit.jsp";
	jQuery("#frmMain").submit();
}
*/
</script>

</head>
<%
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
                     
String qname = Util.null2String(request.getParameter("flowTitle"));
//System.out.println(">>>>>>>>>>>>>>>>>>>>qname="+qname);                     

int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getIntValue(request.getParameter("perpage"),0);
if(perpage<=1 )	perpage=10;

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{" + SystemEnv.getHtmlLabelName(1290, user.getLanguage()) + ",javascript:doCancel(),_self} ";
RCMenuHeight += RCMenuHeightStep;

/*
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
*/

String backfields = " id,fromid,frominfoid,fromtype,fromcontent,fromseclevel,toid,toinfoid,totype,tocontent,toseclevel ";
String sqlWhere = " ";
String fromSql  = " from SysDetachReport ";
String orderby = " id " ;
String tableString = "";
    tableString =" <table instanceid=\"sysDetachDetail\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
                 "	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlprimarykey=\"id\" sqlorderby=\""+orderby+"\"  sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
                 "			<head>"+
                 "				<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(431,user.getLanguage())+"\" column=\"fromid\" otherpara=\"" + user.getLanguage() + "\" transmethod=\"weaver.hrm.appdetach.AppDetachComInfo.getMemberInfo\" />"+
    			 "				<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(19467,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(141,user.getLanguage())+"\" column=\"toid\" otherpara=\"" + user.getLanguage() + "\" transmethod=\"weaver.hrm.appdetach.AppDetachComInfo.getScopeSubcompanyInfo\" />"+
                 "				<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(19467,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"\" column=\"toid\" otherpara=\"" + user.getLanguage() + "\" transmethod=\"weaver.hrm.appdetach.AppDetachComInfo.getScopeDepartmentInfo\" />"+
				 "				<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(19467,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(122,user.getLanguage())+"\" column=\"toid\" otherpara=\"" + user.getLanguage() + "\" transmethod=\"weaver.hrm.appdetach.AppDetachComInfo.getScopeRoleInfo\" />"+
				 "				<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(19467,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(179,user.getLanguage())+"\" column=\"toid\" otherpara=\"" + user.getLanguage() + "\" transmethod=\"weaver.hrm.appdetach.AppDetachComInfo.getScopeResourceInfo\" />"+
                 "			</head>"+
                 " </table>";
String sql = "SELECT " + backfields + " " + fromSql + " " + sqlWhere + " ORDER BY " + orderby;
//out.println(sql);
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver name=frmMain action="AppDetachReport.jsp" method=post>

		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%>" class="e8_btn_top" onclick="doCancel();"/>
					<%--<input type="button" value="<%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%>" class="e8_btn_top" onclick="_table.prePage();"/>--%>				
					<%--<input type="button" value="<%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%>" class="e8_btn_top" onclick="_table.nextPage();"/>--%>
					<%--<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>--%>
<!--			        <span id="advancedSearch" class="advancedSearch">高级搜索</span>-->
					<span title="<%=SystemEnv.getHtmlLabelName(83721, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		
<table width=100% height=96% border="0" cellspacing="0" cellpadding="0">
    <colgroup>
    <col width="10">
    <col width="">
    <col width="10">

<!--    <tr><td height="10" colspan="3"></td></tr>-->
    <tr>
        <td ></td>
        <td valign="top">
        <TABLE class=Shadow>
            <tr>
                <td valign="top">
                    <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
                </td>
            </tr>
        </TABLE>
        </td>
        <td></td>
    </tr>
    <tr><td height="10" colspan="3"></td></tr>
</table>
</FORM>
</BODY>
</HTML>
<script type="text/javascript">
function doCancel(){
	location.href = 'AppDetachList.jsp';
}
</script>
