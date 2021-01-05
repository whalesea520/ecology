
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RelatedRequestCount" class="weaver.workflow.request.RelatedRequestCount" scope="page"/>
<jsp:useBean id="CoworkDAO" class="weaver.cowork.CoworkDAO" scope="page"/>
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="page" />
<jsp:useBean id="SearchComInfo1" class="weaver.proj.search.SearchComInfo" scope="session" />
<%
String CustomerID = Util.null2String(request.getParameter("CustomerID"));
String message = Util.null2String(request.getParameter("message"));

int userid = user.getUID();
String logintype = ""+user.getLogintype();
int usertype = 0;
if(logintype.equals("2"))
	usertype= 1;
//get doc count

DocSearchComInfo.resetSearchInfo();
DocSearchComInfo.addDocstatus("1");
DocSearchComInfo.addDocstatus("2");
DocSearchComInfo.addDocstatus("5");
DocSearchComInfo.setCrmid(CustomerID);
String whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
DocSearchManage.getSelectResultCount(whereclause,user) ;
String doccount=""+DocSearchManage.getRecordersize();

//get cowork count
int allCount = CoworkDAO.getAllCoworkCountByCustomerID(CustomerID);
int canViewCount = CoworkDAO.getCoworkCountByCustomerID(userid,CustomerID);

//get request count
int tempid=Util.getIntValue(CustomerID,0);
RelatedRequestCount.resetParameter();
RelatedRequestCount.setUserid(userid);
RelatedRequestCount.setUsertype(usertype);
RelatedRequestCount.setRelatedid(tempid);
RelatedRequestCount.setRelatedtype("crm");
RelatedRequestCount.selectRelatedCount();

//get crm count
SearchComInfo1.resetSearchInfo();
SearchComInfo1.setcustomer(CustomerID);
String Prj_SearchSql="";
String prjcount="0";
Prj_SearchSql = "select count(*) from Prj_ProjectInfo  t1,PrjShareDetail t2 "+SearchComInfo1.FormatSQLSearch(user.getLanguage()) +" and t1.id = t2.prjid and t2.usertype="+user.getLogintype()+" and t2.userid="+user.getUID();
RecordSet.executeSql(Prj_SearchSql);
if(RecordSet.next()){
	prjcount = ""+RecordSet.getInt(1);
}

%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>

<BODY>
<base target="_blank" />
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<BR>
	  <TABLE class=ViewForm cellpadding="0" cellspacing="0">
        <TBODY>
        <TR class=Title>
            <TH colSpan=4><%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(351,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing>
          <TD class=Line1 colSpan=5></TD>
		</TR>
                          <TR>
                              <TD colSpan=4>
                                <TABLE class="ViewForm">
								<COLGROUP> <COL width="30%"> <COL width="70%">
                                  <TBODY>
<%if(!user.getLogintype().equals("2")){%>
									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(614,user.getLanguage())%></TD>
										<TD class=Field>
										 <a href="/CRM/data/ContractList.jsp?CustomerID=<%=CustomerID%>"><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></a>
										</TD>
									</TR>

									<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
<%}%>
<%if(!user.getLogintype().equals("2")){%>
									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(428,user.getLanguage())%></TD>
										<TD class=Field>
										 <a href="/fna/report/expense/FnaExpenseCrmDetail.jsp?crmid=<%=CustomerID%>"><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></a>
										</TD>
									</TR>
									<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
<%}%>

									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></TD>
										<TD class=Field>
										<a href="/proj/search/SearchOperation.jsp?customer=<%=CustomerID%>"><%=prjcount%></a>
										</TD>
									</TR>
									<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>


									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TD>
										<TD class=Field>
										 <a href="/docs/search/DocSearchTemp.jsp?crmid=<%=CustomerID%>&list=all"><%=doccount%></a>
										</TD>
									</TR>
									<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>

									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(17855,user.getLanguage())%></TD>
										<TD class=Field>
										 <a href="/cowork/coworkview.jsp?CustomerID=<%=CustomerID%>&type=all"><%=allCount%></a>(<%=(allCount-canViewCount)%><%=SystemEnv.getHtmlLabelName(84375,user.getLanguage())%>)
										</TD>
									</TR>
									<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>

									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(360,user.getLanguage())%>)</TD>
										<TD class=Field>
										<a href="/workflow/search/WFSearchTemp.jsp?crmids=<%=CustomerID%>&nodetype=0"><%=RelatedRequestCount.getCount0()%></A>
										</TD>
									</TR>
									<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%>)</TD>
										<TD class=Field>
										<a href="/workflow/search/WFSearchTemp.jsp?crmids=<%=CustomerID%>&nodetype=1"><%=RelatedRequestCount.getCount1()%></A>
										</TD>
									</TR>
									<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%>)</TD>
										<TD class=Field>
										<a href="/workflow/search/WFSearchTemp.jsp?crmids=<%=CustomerID%>&nodetype=2"><%=RelatedRequestCount.getCount2()%></A>
										</TD>
									</TR>
									<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(553,user.getLanguage())%>)</TD>
										<TD class=Field>
										<a href="/workflow/search/WFSearchTemp.jsp?crmids=<%=CustomerID%>&nodetype=3"><%=RelatedRequestCount.getCount3()%></A>
										</TD>
									</TR>
									<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%>)</TD>
										<TD class=Field>
										<a href="/workflow/search/WFSearchTemp.jsp?crmids=<%=CustomerID%>"><%=RelatedRequestCount.getTotalcount()%></a>
										</TD>
									</TR>
									<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
                                  </TBODY>
                                </TABLE>
                              </TD>
                            </TR>
					     </TBODY>
					  </TABLE>

</BODY>
</HTML>



