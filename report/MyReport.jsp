<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="ReportTypeComInfo" class="weaver.workflow.report.ReportTypeComInfo" scope="page" />
<jsp:useBean id="ReportComInfo" class="weaver.workflow.report.ReportComInfo" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = Util.toScreen("我的报表",user.getLanguage(),"0");
String needfav ="1";
String needhelp ="";

String userid =""+user.getUID();
String usertype=user.getLogintype() ;
int userseclevel=Util.getIntValue(user.getSeclevel(),0) ;
char flag=2 ;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps></DIV>
<TABLE class=Form width="40%" border=0>
  <COLGROUP> <COL width="48%"> <COL width=24> <COL width="48%">
  <tr>
  <td valign="top">
  <TABLE class=Form width="100%">
    <TBODY>
    <TR class=Section><TH><%=SystemEnv.getHtmlLabelName(2115,user.getLanguage())%></TH></TR>
    <TR class=separator><TD class=Sep1></TD></TR>
<%if((user.getLogintype().equals("1")&&(userseclevel>=20))){%>
    <tr><TD><A href="/docs/report/DocRpCreater.jsp"><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(79,user.getLanguage())%></A></TD></tr> 
    <TR><TD><A href="/docs/report/DocRpRelative.jsp"><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></A></TD></TR>
    <TR><TD><A href="/report/RpReadView.jsp?object=1"><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(260,user.getLanguage())%></A></TD></TR>
    <TR><TD><a href="/docs/report/DocRpMainCategorySum.jsp"><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></a></TD></TR>
    <TR><TD><A href="/docs/report/DocRpDocSum.jsp"><%=SystemEnv.getHtmlLabelName(16360,user.getLanguage())%></A></TD></TR>
    <TR><TD><a href="/docs/report/DocRpCreaterSum.jsp"><%=SystemEnv.getHtmlLabelName(151,user.getLanguage())%> 20: <%=SystemEnv.getHtmlLabelName(79,user.getLanguage())%></a></TD></TR>
    <!--TR><TD><a href="/docs/report/DocRpLanguageSum.jsp"><%=SystemEnv.getHtmlLabelName(151,user.getLanguage())%> 20: <%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%></a></TD></TR !-->
<%if(software.equals("ALL")){%>
    <TR><TD><a href="/docs/report/DocRpCrmSum.jsp"><%=SystemEnv.getHtmlLabelName(151,user.getLanguage())%> 20: <%=SystemEnv.getHtmlLabelName(147,user.getLanguage())%></a></TD></TR>
    <TR><TD><a href="/docs/report/DocRpResourceSum.jsp"><%=SystemEnv.getHtmlLabelName(151,user.getLanguage())%> 20: <%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></a></TD></TR>
    <TR><TD><a href="/docs/report/DocRpProjectSum.jsp"><%=SystemEnv.getHtmlLabelName(151,user.getLanguage())%> 20: <%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></a></TD></TR>
    <TR><TD><a href="/docs/report/DocRpDepartmentSum.jsp"><%=SystemEnv.getHtmlLabelName(151,user.getLanguage())%> 20: <%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></a></TD></TR>
<%}%>
<%}%>
<%  RecordSet.executeProc("Workflow_StaticReport_SByMU","1"+flag+userid+flag+usertype);
    while(RecordSet.next()){
        String tmppagename=RecordSet.getString("pagename");
        String reportid=RecordSet.getString("reportid");
        String name=RecordSet.getString("name");
%>
    <TR><TD><A href="/workflow/report/<%=tmppagename%>?reportid=<%=reportid%>"><%=Util.toScreen(name,user.getLanguage())%></A></TD></TR>
<%}%>
    </tbody>
  </table>
<br>
<%if(software.equals("ALL") || software.equals("CRM")){%>
  <TABLE class=Form width="100%">
    <TBODY>
    <TR class=Section><TH><%=SystemEnv.getHtmlLabelName(2113,user.getLanguage())%></TH></TR>
    <TR class=separator><TD class=Sep1></TD></TR>    
<%if(user.getLogintype().equals("1")){%>    
    <TR><TD><A href="/CRM/report/CustomerTypeRpSum.jsp"><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></A></TD></TR>
    <TR><TD><A href="/CRM/report/CustomerStatusRpSum.jsp"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></A></TD></TR>
	<TR><TD><A href="/CRM/report/PaymentTermRpSum.jsp"><%=SystemEnv.getHtmlLabelName(577,user.getLanguage())%></A></TD></TR>
    <TR><TD><A href="/CRM/report/CreditInfoRpSum.jsp"><%=SystemEnv.getHtmlLabelName(580,user.getLanguage())%></A></TD></TR>
	<TR><TD><A href="/CRM/report/TradeInfoRpSum.jsp"><%=SystemEnv.getHtmlLabelName(581,user.getLanguage())%></A></TD></TR>
	<TR><TD><A href="/CRM/report/CustomerDescRpSum.jsp"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></A></TD></TR>
    <TR><TD><A href="/CRM/report/ManagerRpSum.jsp"><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></A></TD></TR>
    <TR><TD><A href="/CRM/report/DepartmentRpSum.jsp"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></A></TD></TR>
    <TR><TD><A href="/CRM/report/ContactWayRpSum.jsp"><%=SystemEnv.getHtmlLabelName(1219,user.getLanguage())%></A></TD></TR>
	<TR><TD><A href="/CRM/report/SectorInfoRpSum.jsp"><%=SystemEnv.getHtmlLabelName(575,user.getLanguage())%></A></TD></TR>
	<TR><TD><A href="/CRM/report/CustomerSizeRpSum.jsp"><%=SystemEnv.getHtmlLabelName(576,user.getLanguage())%></A></TD></TR>
    <TR><TD><A href="/CRM/report/AddressRpSum.jsp"><%=SystemEnv.getHtmlLabelName(1220,user.getLanguage())%></A></TD></TR>
    <TR><TD><A href="/CRM/report/CRMContactLogRp.jsp"><%=SystemEnv.getHtmlLabelName(1221,user.getLanguage())%></A></TD></TR>	
	<TR><TD><A href="/CRM/report/CRMShareLogRp.jsp"><%=SystemEnv.getHtmlLabelName(1222,user.getLanguage())%></A></TD></TR>    
<%}%>   
<%  RecordSet.executeProc("Workflow_StaticReport_SByMU","3"+flag+userid+flag+usertype);
    while(RecordSet.next()){
        String tmppagename=RecordSet.getString("pagename");
        String reportid=RecordSet.getString("reportid");
        String name=RecordSet.getString("name");
%>
    <TR><TD><A href="/workflow/report/<%=tmppagename%>?reportid=<%=reportid%>"><%=Util.toScreen(name,user.getLanguage())%></A></TD></TR>
<%}%>  
  </table> 
<br>
  <TABLE class=Form width="100%">
    <TBODY>
    <TR class=Section><TH><%=SystemEnv.getHtmlLabelName(2114,user.getLanguage())%></TH></TR>
    <TR class=separator><TD class=Sep1></TD></TR>
<%if(user.getLogintype().equals("1")){%> 
    <tr><td><a href="/proj/report/ProjectTypeRpSum.jsp"><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></a></td></tr>  
    <tr><td><a href="/proj/report/WorkTypeRpSum.jsp"><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></a></td></tr>  
    <tr><td><a href="/proj/report/ProjectStatusRpSum.jsp"><%=SystemEnv.getHtmlLabelName(587,user.getLanguage())%></a></td></tr>
    <tr><td><a href="/proj/report/ManagerRpSum.jsp"><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></a></td></tr>  
    <tr><td><a href="/proj/report/DepartmentRpSum.jsp"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></a></td></tr>  
<%}%>
<%  RecordSet.executeProc("Workflow_StaticReport_SByMU","6"+flag+userid+flag+usertype);
    while(RecordSet.next()){
        String tmppagename=RecordSet.getString("pagename");
        String reportid=RecordSet.getString("reportid");
        String name=RecordSet.getString("name");
%>
    <TR><TD><A href="/workflow/report/<%=tmppagename%>?reportid=<%=reportid%>"><%=Util.toScreen(name,user.getLanguage())%></A></TD></TR>
<%}%> 
  </table>
<%}%>

  </td>
  <td></td>
  <TD vAlign=top>
  <TABLE class=Form width="100%">
    <TBODY>
    <TR class=Section><TH>组织</TH></TR>
    <TR class=separator><TD class=Sep1></TD></TR>
    <tr><td><a href="/org/OrgChartDoc.jsp"><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></a></td></tr>  
    <tr><td><a href="/org/OrgChartHRM.jsp">人力资源</a></td></tr> 
<%if(software.equals("ALL") || software.equals("CRM")){%>
    <tr><td><a href="/org/OrgChartCRM.jsp">CRM</a></td></tr> 
    <tr><td><a href="/org/OrgChartProj.jsp">项目</a></td></tr> 
<%}%>
<%if(software.equals("ALL")){%>
    <tr><td><a href="/org/OrgChartCpt.jsp">资产</a></td></tr> 
    <tr><td><a href="/org/OrgChartFna.jsp">财务</a></td></tr> 
<%}%>
  </table>
<br>
  <TABLE class=Form width="100%">
    <TBODY>
    <TR class=Section><TH>人力资源</TH></TR>
    <TR class=separator><TD class=Sep1></TD></TR>
<%if(user.getLogintype().equals("1")){%>
    <%if(userseclevel>=50 || userid.equals("1")){%>
    <TR><TD><A href="/hrm/report/HrmRpAge.jsp"><%=SystemEnv.getHtmlLabelName(671,user.getLanguage())%></A></TD></TR>
    <TR><TD><A href="/hrm/report/HrmRpJob.jsp"><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></A></TD></TR>
    <tr><td><a href="/hrm/report/HrmRpSeclevel.jsp"><%=SystemEnv.getHtmlLabelName(120,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></a>/<a href="/hrm/report/HrmRpJoblevel.jsp"><%=SystemEnv.getHtmlLabelName(484,user.getLanguage())%></a></td></tr>
    <%}%>
    <%if(userseclevel>=20){%>
    <tr><td><%=SystemEnv.getHtmlLabelName(834,user.getLanguage())%>:<a href="/hrm/report/HrmRpTrainPeoNumByType.jsp"><%=SystemEnv.getHtmlLabelName(1882,user.getLanguage())%></a>/<a href="/hrm/report/HrmRpTrainPeoNumByDep.jsp"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></a></td></tr>
    <tr><td><%=SystemEnv.getHtmlLabelName(833,user.getLanguage())%>:<a href="/hrm/report/HrmRpTrainHourByType.jsp"><%=SystemEnv.getHtmlLabelName(1882,user.getLanguage())%></a>/<a href="/hrm/report/HrmRpTrainHourByDep.jsp"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></a></td></tr>
    <%if(HrmUserVarify.checkUserRight("HrmResource:Absense",user)) {%>  
    <TR><TD><A href="/hrm/report/HrmRpAbsense.jsp"><%=SystemEnv.getHtmlLabelName(670,user.getLanguage())%></A></TD></TR>
    <%}
    }
    /*权限判断,人力资产管理员以及其所有上级*/
    boolean canView = false;
    ArrayList allCanView = new ArrayList();
    String tempsql = "select resourceid from HrmRoleMembers where roleid = 4 ";
    RecordSet.executeSql(tempsql);
    while(RecordSet.next()){
    	String tempid = RecordSet.getString("resourceid");
    	allCanView.add(tempid);
    	AllManagers.getAll(tempid);
    	while(AllManagers.next()){
    		allCanView.add(AllManagers.getManagerID());
    	}
    }// end while
    for (int i=0;i<allCanView.size();i++){
    	if(userid.equals((String)allCanView.get(i)))
    		canView = true;
    }
    if(canView){
    %>
    <TR><TD><A href="/hrm/report/HrmRpResource.jsp"><%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%></A></TD></TR>
    <%}%>
    <TR><TD><A href="/hrm/report/HrmRpContact.jsp"><%=SystemEnv.getHtmlLabelName(1515,user.getLanguage())%></A></TD></TR>
    <%  /*权限判断,资产管理员以及其所有上级*/
    canView = false;
    allCanView.clear();
    String sql = "select resourceid from HrmRoleMembers where roleid = 32 ";
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
    	String tempid = RecordSet.getString("resourceid");
    	allCanView.add(tempid);
    	AllManagers.getAll(tempid);
    	while(AllManagers.next()){
    		allCanView.add(AllManagers.getManagerID());
    	}
    }// end while 
    for (int i=0;i<allCanView.size();i++){
    	if(userid.equals((String)allCanView.get(i)))
    		canView = true;
    }
    if(canView){
    %>
    <tr><td><a href="/cpt/report/CptRpCarDriver.jsp">驾驶员统计表</a></td></tr>
    <%}%>
<%}%>
<%  RecordSet.executeProc("Workflow_StaticReport_SByMU","2"+flag+userid+flag+usertype);
    while(RecordSet.next()){
        String tmppagename=RecordSet.getString("pagename");
        String reportid=RecordSet.getString("reportid");
        String name=RecordSet.getString("name");
%>
    <TR><TD><A href="/workflow/report/<%=tmppagename%>?reportid=<%=reportid%>"><%=Util.toScreen(name,user.getLanguage())%></A></TD></TR>
<%}%> 
  </table>
<br>
<%if(software.equals("ALL")){%>
  <TABLE class=Form width="100%">
    <TBODY>
    <TR class=Section><TH>资产管理</TH></TR>
    <TR class=separator><TD class=Sep1></TD></TR>
<%if(user.getLogintype().equals("1")){%> 
    <TR><TD><A href="/cpt/report/CptRpCapitalGroupSum.jsp"><%=SystemEnv.getHtmlLabelName(831,user.getLanguage())%></A></TD></TR>
    <tr><td><a href="/cpt/report/CptRpCapitalResourceSum.jsp"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></a></td></tr>
    <tr><td><a href="/cpt/report/CptRpCapitalDepartmentSum.jsp"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></a></td></tr>
    <TR><TD><A href="/cpt/report/CptRpCapitalStateSum.jsp"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></A></TD></TR>
<%  /*权限判断,资产管理员以及其所有上级*/
    boolean canView = false;
    ArrayList allCanView = new ArrayList();
    String sql = "select resourceid from HrmRoleMembers where roleid = 7 ";
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
    	String tempid = RecordSet.getString("resourceid");
    	allCanView.add(tempid);
    	AllManagers.getAll(tempid);
    	while(AllManagers.next()){
    		allCanView.add(AllManagers.getManagerID());
    	}
    }// end while 
    for (int i=0;i<allCanView.size();i++){
    	if(userid.equals((String)allCanView.get(i)))
    		canView = true;
    }
    if(canView){
%>
    <tr><td><a href="/cpt/report/CptRpCptCompare.jsp">计划实际比较表</a></td></tr>
    <tr><td><a href="/cpt/report/CptRpCptDepart.jsp">部门需求统计表</a></td></tr>
    <tr><td><a href="/cpt/report/CptRpCapital.jsp"><%=SystemEnv.getHtmlLabelName(1439,user.getLanguage())%></a></td></tr>
    <tr><td><a href="/cpt/report/CptRpCapitalFlow.jsp"><%=SystemEnv.getHtmlLabelName(1501,user.getLanguage())%></a></td></tr>
    <tr><td><a href="/cpt/report/CptRpCapitalCheckStock.jsp"><%=SystemEnv.getHtmlLabelName(1506,user.getLanguage())%></a></td></tr> 
    <tr><td><a href="/cpt/report/CptRpCapitalApportion.jsp"><%=SystemEnv.getHtmlLabelName(1511,user.getLanguage())%></a></td></tr> 
    <tr><td><a href="/cpt/report/CptRpOfficeSupply.jsp"><%=SystemEnv.getHtmlLabelName(1513,user.getLanguage())%></a></td></tr> 
<%  }%>    
<%  /*权限判断,资产管理员以及其所有上级*/
    canView = false;
    allCanView.clear();
    sql = "select resourceid from HrmRoleMembers where roleid = 32 ";
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
    	String tempid = RecordSet.getString("resourceid");
    	allCanView.add(tempid);
    	AllManagers.getAll(tempid);
    	while(AllManagers.next()){
    		allCanView.add(AllManagers.getManagerID());
    	}
    }// end while 
    for (int i=0;i<allCanView.size();i++){
    	if(userid.equals((String)allCanView.get(i)))
    		canView = true;
    }
    if(canView){
%>
    <tr><td><a href="/cpt/report/CptRpCptCar.jsp">车辆统计表</a></td></tr>
<%  }%> 
<%}%>
<%  RecordSet.executeProc("Workflow_StaticReport_SByMU","4"+flag+userid+flag+usertype);
    while(RecordSet.next()){
        String tmppagename=RecordSet.getString("pagename");
        String reportid=RecordSet.getString("reportid");
        String name=RecordSet.getString("name");
%>
    <TR><TD><A href="/workflow/report/<%=tmppagename%>?reportid=<%=reportid%>"><%=Util.toScreen(name,user.getLanguage())%></A></TD></TR>
<%}%> 
  </table>
<br>
  <TABLE class=Form width="100%">
    <TBODY>
    <TR class=Section><TH>财务管理</TH></TR>
    <TR class=separator><TD class=Sep1></TD></TR>
<%if(user.getLogintype().equals("1")){%> 
    <TR><TD><A href="/fna/report/RptManagementDetailQuery.jsp">管理费用明细</A></TD></TR>
    <%if(HrmUserVarify.checkUserRight("MoneyWeek:All", user)){%>
    <TR><TD><A href="/fna/report/RptMoneyWeekDetailquery.jsp">货币资金</A></TD></TR>
    <%}%>
    <%if(HrmUserVarify.checkUserRight("OtherArPerson:All", user)){%>
    <TR><TD><A href="/fna/report/RptOtherArpersonDetailQuery.jsp">个人往来</A></TD></TR>
    <%}%>
<%}%>
<%  RecordSet.executeProc("Workflow_StaticReport_SByMU","7"+flag+userid+flag+usertype);
    while(RecordSet.next()){
        String tmppagename=RecordSet.getString("pagename");
        String reportid=RecordSet.getString("reportid");
        String name=RecordSet.getString("name");
%>
    <TR><TD><A href="/workflow/report/<%=tmppagename%>?reportid=<%=reportid%>"><%=Util.toScreen(name,user.getLanguage())%></A></TD></TR>
<%}%> 
  </table> 
<%}%>

  </td>
  </tr>
</table>

<!----------------------------------------------------------------------------------------->
<TABLE class=Form width="40%" border=0>
  <COLGROUP> <COL width="48%"> <COL width=24> <COL width="48%">
  <tr>
  <td>  
<%
	ArrayList hasrightreports = new ArrayList() ;
    ArrayList hasrightreportsbytypes = new ArrayList() ;
    int theodd  = 0 ;
    RecordSet.executeSql("select reportid from WorkflowReportShareDetail where userid="+user.getUID()+" and usertype=1 ");
    while(RecordSet.next()) {
        String tempreportid = Util.null2String(RecordSet.getString(1)) ;
        hasrightreports.add(tempreportid) ;
    }
	ReportTypeComInfo.setTofirstRow() ;
	while(ReportTypeComInfo.next()) {
	    if(theodd % 2 == 0) {
			theodd ++ ;
			continue ;
		}
        hasrightreportsbytypes.clear() ;
        ReportComInfo.setTofirstRow() ;
		while(ReportComInfo.next(ReportTypeComInfo.getReportTypeid())) {
            String tempreportid = ReportComInfo.getReportid() ;
            if(hasrightreports.indexOf(tempreportid) < 0) continue ;
            hasrightreportsbytypes.add(tempreportid) ;
        }
        if(hasrightreportsbytypes.size() == 0)  {
            theodd ++ ;
			continue ;
		}
		theodd ++ ;
%>
      <table class=Form>
        <colgroup> <col width="100%"> <tbody> 
        <tr class=Section> 
          <th><%=Util.toScreen(ReportTypeComInfo.getReportTypename(),user.getLanguage())%>
        </tr>
        <tr class=Separator> 
          <td class=Sep3></td>
		 <%
		 for(int i = 0 ; i< hasrightreportsbytypes.size() ; i++) {
		%>  
        <tr> 
          <td><a href="/workflow/report/ReportCondition.jsp?id=<%=hasrightreportsbytypes.get(i)%>"><%=Util.toScreen(ReportComInfo.getReportname((String)hasrightreportsbytypes.get(i)),user.getLanguage())%></a></td>
        </tr>
		<%}%>
        </tbody>
      </table>
	  <%}%>      
  </td>
  <TD></TD>
    <TD>
	<%
	 theodd  = 0 ;
	 ReportTypeComInfo.setTofirstRow() ;
	 while(ReportTypeComInfo.next()) {
	 	if(theodd % 2 != 0) {
			theodd ++ ;
			continue ;
		}
        hasrightreportsbytypes.clear() ;
        ReportComInfo.setTofirstRow() ;
		while(ReportComInfo.next(ReportTypeComInfo.getReportTypeid())) {
            String tempreportid = ReportComInfo.getReportid() ;
            if(hasrightreports.indexOf(tempreportid) < 0) continue ;
            hasrightreportsbytypes.add(tempreportid) ;
        }
        if(hasrightreportsbytypes.size() == 0)  {
            theodd ++ ;
			continue ;
		}

		theodd ++ ;
		%> 
      <table class=Form>
        <colgroup> <col width="100%"> <tbody> 
        <tr class=Section> 
          <th><%=Util.toScreen(ReportTypeComInfo.getReportTypename(),user.getLanguage())%> 
        </tr>
        <tr class=Separator> 
          <td class=Sep3></td>
		 <%
		 for(int i = 0 ; i< hasrightreportsbytypes.size() ; i++) {
		%>  
        <tr> 
          <td><a href="/workflow/report/ReportCondition.jsp?id=<%=hasrightreportsbytypes.get(i)%>"><%=Util.toScreen(ReportComInfo.getReportname((String)hasrightreportsbytypes.get(i)),user.getLanguage())%></a></td>
        </tr>
		<%}%>
        </tbody>
      </table>
	  <%}%>
  </td>
  </tr>
</table>