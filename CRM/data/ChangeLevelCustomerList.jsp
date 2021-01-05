<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="CRMSearchComInfo" class="weaver.crm.search.SearchComInfo" scope="session" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17528,user.getLanguage());
String needfav ="1";
String needhelp ="";
String CRM_SearchWhere = CRMSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
String sql = "" ;

String userid = ""+user.getUID();
String loginType = ""+user.getLogintype();
String userSeclevel = user.getSeclevel();

int perpage=10;
char flag = 2;
String ProcPara = userid+flag+loginType;
RecordSet.executeProc("CRM_Customize_SelectByUid",ProcPara);

boolean hasCustomize = true;
if(RecordSet.getCounts()<=0){
	hasCustomize = false;
}else{
	RecordSet.first();
  perpage=RecordSet.getInt("perpage");
}
if(perpage<=0 )	perpage=10;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(17530,user.getLanguage())+",javascript:doLevelUp(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(17531,user.getLanguage())+",javascript:doLevelDown(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%
    String customerids = Util.null2String(request.getParameter("customerids"));
    if(!HrmUserVarify.checkUserRight("MutiApproveCustomerNoRequest", user)){
        response.sendRedirect("/notice/noright.jsp") ;
        return ;
    }
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

			<FORM name=CRMID id=CRMID action="/CRM/data/ChangeLevelCustomerOperation.jsp" method=post>
            <input type="hidden" name="customerids" value="<%=customerids%>">
            <input type="hidden" name="oper" value="1">
			<%
            String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
            
            String backFields = "t1.id, t1.name, t1.manager, t1.status ";
            String sqlFrom = " CRM_CustomerInfo  t1,"+leftjointable+" t2  ";
            String whereclause=CRM_SearchWhere +" and t1.id = t2.relateditemid";
            String tableString=""+
			  "<table instanceid=\"workflowRequestListTable\" tabletype=\"checkbox\" pagesize=\""+perpage+"\">"+
			  "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlprimarykey=\"t1.id\" sqlorderby=\"t1.name\" sqlsortway=\"desc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(whereclause)+"\"/>"+
			  "<head>"+                             
					  "<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(1976,user.getLanguage())+"\" column=\"name\" orderkey=\"name\"/>"+
					  "<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(1278,user.getLanguage())+"\" column=\"manager\" orderkey=\"manager\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getLastname\" target=\"_fullwindow\" linkkey=\"id\" linkvaluecolumn=\"manager\" href=\"/hrm/resource/HrmResource.jsp\"/>"+
					  "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(1929,user.getLanguage())+"\" column=\"status\" orderkey=\"status\" transmethod=\"weaver.crm.Maint.CustomerStatusComInfo.getCustomerStatusname\"/>"+
			  "</head>"+
			  "</table>";
              %>
            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>	
        </FORM>								
		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

</BODY>
</HTML>
<script language="JavaScript">

function doLevelUp(){
    if(_xtable_CheckedCheckboxId()==""){
    alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%>");
    return false; 
    }
    document.CRMID.customerids.value=_xtable_CheckedCheckboxId()+"-1";
    document.all("oper").value="1";
    document.CRMID.submit();
}
function doLevelDown(){
   if(_xtable_CheckedCheckboxId()==""){
     alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%>");
     return false; 
     }
    document.CRMID.customerids.value=_xtable_CheckedCheckboxId()+"-1";
    document.all("oper").value="2";
    document.CRMID.submit();
}
function goBack(){
   location.href="/CRM/search/SearchResult.jsp";
}
</script>
