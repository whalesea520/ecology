<%@ page import="weaver.general.Util,weaver.conn.*,java.math.*,
                 weaver.hrm.resource.ResourceComInfo" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="AwardComInfo" class="weaver.hrm.award.AwardComInfo" scope="page" />
<jsp:useBean id="CheckItemComInfo" class="weaver.hrm.check.CheckItemComInfo" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%!
   /**
    * Added By Charoes Huang On May 20 ,2004
    * @param resourceid
    * @param comInfo
    * @return  the resource name string with hyper link
    */
   private String getRecourceLinkStr(String resourceid,ResourceComInfo comInfo){
       String linkStr ="";
       String[] resources =Util.TokenizerString2(resourceid,",");
       for(int i=0;i<resources.length;i++){
           linkStr += "<A href=\"/hrm/resource/HrmResource.jsp?id="+resources[i]+"\">"+comInfo.getResourcename(resources[i])+"</A>&nbsp;";
       }
       return linkStr;
   }
%>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String resourceid = Util.null2String(request.getParameter("resourceid")) ;
AllManagers.getAll(resourceid);
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
//added by hubo,20060113
if(resourceid.equals("")) resourceid=String.valueOf(user.getUID());
boolean isSelf		=	false;
boolean isManager	=	false;
if (resourceid.equals(""+user.getUID()) ){
	isSelf = true;
}
while(AllManagers.next()){
	String tempmanagerid = AllManagers.getManagerID();
	if (tempmanagerid.equals(""+user.getUID())) {
		isManager = true;
	}
}
if(!(isSelf||isManager||HrmUserVarify.checkUserRight("HrmResource:RewardsRecord",user))) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
char separator = Util.getSeparator() ;

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(16065,user.getLanguage());
String needfav ="1";
String needhelp ="";

String qname = Util.null2String(request.getParameter("flowTitle"));

%>
<HTML><HEAD>
<%if(isfromtab) {%>
<base target='_blank'/>
<%} %>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}
function showDetail(id){
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("81800,87",user.getLanguage())%>";
	url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmAwardEdit&id="+id+"&cmd=showdetail";
	dialog.Width = 800;
	dialog.Height = 500;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
</script>
</head>
<BODY>
<% if(!isfromtab){%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%}%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="/hrm/resource/HrmResourceRewardsRecord2.jsp" name="searchfrm" id="searchfrm">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
			<input type="hidden" name="resourceid" value="<%=resourceid %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >	
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		
	</wea:group>
	<wea:group context="">
		<wea:item type="toolbar">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
	  </wea:item>
	</wea:group>
</wea:layout>
</div>
</form>
<%
String backfields = " * "; 
String fromSql  = " from HrmAwardInfo ";
String sqlWhere = " where 1=1 ";
String orderby = "  rpdate desc " ;
String tableString = "";

if("oracle".equals(rs.getDBType())){
	sqlWhere += " and concat(concat(',',resourseid),',') like '%," +resourceid+",%'" ;
}else if("db2".equals(rs.getDBType())){
	sqlWhere += " and concat(concat(',',resourseid),',') like '%," +resourceid+",%'" ;
}else{
	sqlWhere += " and ','+resourseid+',' like '%," +resourceid+",%'" ;
}

if(!qname.equals("")){
	sqlWhere += " and rptitle like '%"+qname+"%'";
}
String operateString= "<operates width=\"20%\">";
operateString+=" <popedom transmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicOperate\" otherpara=\"true\"></popedom> ";
operateString+="     <operate href=\"javascript:showDetail();return false;\" text=\""+SystemEnv.getHtmlLabelName(2121,user.getLanguage())+"\" index=\"0\"/>";
operateString+="</operates>";
tableString =" <table pageId=\""+ PageIdConst.HRM_ResourceRewardRecord2+"\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_ResourceRewardRecord2,user.getUID(),PageIdConst.HRM)+"\" >"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Asc\" sqlisdistinct=\"false\"/>"+
    operateString+
    "			<head>"+
    "				<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(15665,user.getLanguage())+"\" column=\"rptitle\" orderkey=\"rptitle\" />"+
    "				<col width=\"30%\"   text=\""+SystemEnv.getHtmlLabelName(1962,user.getLanguage())+"\" column=\"rpdate\" orderkey=\"rpdate\"/>"+
    "				<col width=\"30%\"   text=\""+SystemEnv.getHtmlLabelName(6099,user.getLanguage())+"\" column=\"rptypeid\" orderkey=\"rptypeid\" transmethod=\"weaver.hrm.award.AwardComInfo.getAwardName\"/>"+
    "			</head>"+
    " </table>";
%>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  /> 
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_ResourceRewardRecord2 %>"/>
</BODY></HTML>
