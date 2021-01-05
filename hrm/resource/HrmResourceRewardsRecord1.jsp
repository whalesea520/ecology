<%@ page import="weaver.general.Util,weaver.conn.*,java.math.*,
                 weaver.hrm.resource.ResourceComInfo" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="AwardComInfo" class="weaver.hrm.award.AwardComInfo" scope="page" />
<jsp:useBean id="CheckItemComInfo" class="weaver.hrm.check.CheckItemComInfo" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
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
String qname = Util.null2String(request.getParameter("qname"));
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
String sql = "" ;
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script type="text/javascript">
		function onBtnSearchClick(){
			jQuery("#searchfrm").submit();
		}
		</script>
	</head>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form action="HrmResourceRewardsRecord1.jsp" name="searchfrm" id="searchfrm" method="post" >
			<input type="hidden" name="resourceid" value="<%=resourceid%>"/>
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<input type="text" class="searchInput" name="qname" value="<%=qname%>" onkeypress=""/>
						<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
		</form>
<%if(!isfromtab){ %>
<TABLE class=Shadow>
<%}else{ %>
<TABLE width='100%'>
<%} %>
<tr>
<td valign="top">
<%
ArrayList checkiditemids = new ArrayList() ;
ArrayList results = new ArrayList() ;
String _sql = rs.getDBType().equals("oracle")?"number":"decimal";
sql = " select a.checkid,a.proportion,b.checkitemid,cast((b.result*b.checkitemproportion/100) as "+_sql+"(10,2)) as bresult"+
      " from HrmByCheckPeople a left join HrmCheckGrade b on a.id = b.checkpeopleid "+
      " where a.resourceid="+resourceid;

rs.executeSql( sql ) ;
while( rs.next() ) {
    String checkid = Util.null2String(rs.getString(1));
    double proportion = Util.getDoubleValue(rs.getString(2),0);
    String checkitemid = Util.null2String(rs.getString(3));
    double tempresultsum = Util.getDoubleValue(rs.getString(4),0);

    int checkiditemidindex = checkiditemids.indexOf( checkid + "_" + checkitemid ) ;
    if( checkiditemidindex == -1 ) {
        checkiditemids.add( checkid + "_" + checkitemid ) ;
        results.add( "" + tempresultsum ) ;
    }
    else {
        double tempoldresultsum = Util.getDoubleValue( (String)results.get(checkiditemidindex) ,0) ;
        tempresultsum += tempoldresultsum ;
        results.set( checkiditemidindex , "" + tempresultsum ) ;

    }
}


ArrayList checkids = new ArrayList() ;
ArrayList hasrecordcounts = new ArrayList() ;

sql = " select checkid , count(resourceid) from HrmByCheckPeople where resourceid="+resourceid +
      " and result > 0 group by checkid " ;

rs.executeSql(sql);
while(rs.next()){
    String checkid = Util.null2String(rs.getString(1));
    String hasrecordcount = Util.null2String(rs.getString(2));
    checkids.add( checkid ) ;
    hasrecordcounts.add( hasrecordcount ) ;

}


String checktypeid = "" ;
String checkitemid = "" ;
String checkitemproportion = "" ;
ArrayList checktypeids = new ArrayList() ;
ArrayList checkitemids = new ArrayList() ;
ArrayList checkitemproportions = new ArrayList() ;
sql = " select checktypeid,checkitemid,checkitemproportion from HrmcheckKindItem " ;
rs.executeSql(sql);
while(rs.next()){
    checktypeid = Util.null2String(rs.getString(1)) ;
    checkitemid = Util.null2String(rs.getString(2)) ;
    checkitemproportion = Util.null2String(rs.getString(3)) ;
    checktypeids.add(checktypeid) ;
    checkitemids.add(checkitemid) ;
    checkitemproportions.add(checkitemproportion) ;

}
sql ="select distinct a.checktypeid from HrmCheckList a,HrmByCheckPeople b "+
      " where a.id = b.checkid and b.resourceid = "+resourceid ;
rs.executeSql(sql);
boolean isShowRecord = rs.getCounts()>0;
while(rs.next()) {
    checktypeid = Util.null2String(rs.getString("checktypeid"));
    String kindname = "" ;
    sql = "select kindname from HrmCheckKind where id="+checktypeid ;
    rs2.executeSql(sql) ;
    if(rs2.next()) kindname = Util.toScreen(rs2.getString("kindname"),user.getLanguage()) ;

%>
    <TABLE class=ListStyle cellspacing=1 >
        <TR class=header>
            <TH><%=kindname%></TH>
        </tr>
    </table>
    <TABLE class=ListStyle cellspacing=1  >
    <tr class=Header>
    <Td><%=SystemEnv.getHtmlLabelName(15653,user.getLanguage())%></Td>
    <Td><%=SystemEnv.getHtmlLabelName(15649,user.getLanguage())%></Td>
    <Td><%=SystemEnv.getHtmlLabelName(15650,user.getLanguage())%></Td>
   </tr>
    <%
    String checkid = "",checkname="";
    sql = " select b.id, b.startdate, b.enddate, b.checkname,a.result  from (select b.id, sum(cast((a.result*a.proportion/100)as decimal(10,2))) as result from HrmByCheckPeople a left join HrmCheckList b on a.checkid = b.id "+        
    	  " where a.resourceid = "+resourceid + " and a.result > 0 and b.checktypeid = "+checktypeid +
    	  " group by b.id ) a left join HrmCheckList b on a.id = b.id ";
	if(qname.length()>0){
		sql += " where b.checkname like '%"+qname+"%'";
	}
    rs2.executeSql(sql) ;
    boolean isLight = false;
    while(rs2.next()) {
        checkid = Util.null2String(rs2.getString(1)) ;
        String startdate = Util.null2String(rs2.getString(2));
        String enddate = Util.null2String(rs2.getString(3));
        checkname = Util.null2String(rs2.getString(4)) ;
        String resourceresultsum = Util.null2String(rs2.getString(5));

        String hasrecordcount = "" ;
        int checkidindex = checkids.indexOf( checkid ) ;
        if( checkidindex != -1 ) hasrecordcount = (String)hasrecordcounts.get(checkidindex) ;
        isLight = !isLight ;

    %>
   <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
     <td><a href="/hrm/HrmTab.jsp?_fromURL=HrmResourceRewardsRecordDetail&checkid=<%=checkid%>" target="_fullwindow"><%=checkname%></a></td>
    <TD><%=resourceresultsum%></TD>
    <TD><%=hasrecordcount%></TD>
 </tr>
 <%
    }
 %>
</table>
<%
}
if(!isShowRecord){
String backfields = " a.checktypeid,'' c1, '' c2, '' c3 "; 
String fromSql  = " from HrmCheckList a,HrmByCheckPeople b ";
String sqlWhere = " where a.id = b.checkid and b.resourceid = "+resourceid;
String orderby = "" ;
String tableString = " <table pageId=\""+ PageIdConst.HRM_ResourceRewardRecord2+"\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_ResourceRewardRecord2,user.getUID(),PageIdConst.HRM)+"\" >"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.checktypeid\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
    "			<head>"+
    "				<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(15653,user.getLanguage())+"\" column=\"c1\" orderkey=\"c1\" />"+
    "				<col width=\"30%\"   text=\""+SystemEnv.getHtmlLabelName(15649,user.getLanguage())+"\" column=\"c2\" orderkey=\"c2\"/>"+
    "				<col width=\"30%\"   text=\""+SystemEnv.getHtmlLabelName(15650,user.getLanguage())+"\" column=\"c3\" orderkey=\"c3\"/>"+
    "			</head>"+
    " </table>";
%>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
<%
}
%>
</td>
</tr>
</TABLE>
</BODY></HTML>
