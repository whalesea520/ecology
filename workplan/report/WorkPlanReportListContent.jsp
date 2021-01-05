
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.Constants" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.WorkPlan.WorkPlanReportData" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.domain.workplan.WorkPlanReport" %>
<%@ page import="weaver.domain.workplan.UserWorkPlan" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="report" class="weaver.WorkPlan.WorkPlanReport" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="JavaScript" src="/js/weaver_wev8.js"></SCRIPT>
<STYLE>
    .vis0   { visibility:"hidden" }
    .vis1   { visibility:"visible" }
</STYLE>
</HEAD>

<%  
  String type = request.getParameter("type");
  
  WorkPlanReport workPlanReport = (WorkPlanReport)session.getAttribute("workPlanReport");

  List userWorkPlanList = (ArrayList)workPlanReport.getUserWorkPlanList();

  /* ============================= 得到当前时间开始 ============================= */  
  Calendar cal = Calendar.getInstance();

  //String currDate = Util.add0(cal.get(Calendar.YEAR), 4) + "-" + Util.add0(cal.get(Calendar.MONTH) + 1, 2) + "-" + Util.add0(cal.get(Calendar.DAY_OF_MONTH), 2);
  int currYear = cal.get(Calendar.YEAR);
  int currWeek = cal.get(Calendar.WEEK_OF_YEAR);
  int currMonth = cal.get(Calendar.MONTH) + 1;
  //int currQuarter = (currMonth + 2) / 3;

  /* ============================= 得到当前时间结束 ============================= */
  
  /* ============================= 配置下拉列表时间数值开始 ============================= */  
  int lowerYear = 2000;
  int upperYear = currYear + 1;
  String[] years = new String[upperYear - lowerYear];
  for (int i = 0; i < upperYear-lowerYear; i++)
  {
    years[i] = String.valueOf(lowerYear + i);
  }
 
  /* ============================= 配置下拉列表时间数值结束 ============================= */
    
  String year = "";
  String week = "";
  String month = "";
  
  if(null == workPlanReport.getYear() || "".equals(workPlanReport.getYear()))
  {
      year = String.valueOf(currYear);
  }
  else
  {
      year = workPlanReport.getYear();
  }

  if (type.equals("1"))
  //周
  {
      if(null == workPlanReport.getWeek() || "".equals(workPlanReport.getWeek()) || "-1".equals(workPlanReport.getWeek()))
      {
          week = String.valueOf(currWeek);
      }
      else
      {
          week = workPlanReport.getWeek();
      }
  }
  else if (type.equals("2"))
  //月
  {
      if(null == workPlanReport.getMonth() || "".equals(workPlanReport.getMonth()) || "-1".equals(workPlanReport.getMonth()))
      {
          month = String.valueOf(currMonth);
      }
      else
      {
          month = workPlanReport.getMonth();
      }    
  }
%>

<BODY>

<!--============================= 右键菜单开始 =============================-->
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
  RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self}" ;
  RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<!--============================= 右键菜单结束 =============================-->

<TABLE width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
  <COLGROUP>
    <COL width="10">
    <COL width="">
    <COL width="10">
  <TR>
    <TD height="10" colspan="3"></TD>
  </TR>
  <TR>
    <TD></TD>
    <TD valign="top">
    <FORM id="frmmain" name="frmmain" method="post" action="WorkPlanReportListOperation.jsp">
      <input type="hidden" name="from" value="inner">  
      <TABLE class="Shadow">
        <TR>
        <TD valign="top">          
          <!--============================= 上部下拉选择区域开始 =============================-->
          <LABEL style="width:800">
          <TABLE class="ViewForm">
            <COLGROUP>
              <COL width="10%">
              <COL width="37%">
              <COL width="6%">
              <COL width="10%">
              <COL width="37%">
            <TBODY>     
            <TR>
              <TD><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></TD>
              <!--============================= 年 下拉菜单开始 =============================-->
              <TD class="Field">
                <SELECT name="year">
                <%
                  for (int i = 0; i < years.length; i++)
                  {
                %>
                  <OPTION value="<%=years[i]%>" 
                <%
                    if (years[i].equals(year))
                    {
                %> 
                      selected
                <%
                    }
                %>
                  ><%=years[i]%></OPTION>
                <%
                  }
                %>
                </SELECT>
              </TD>
              <!--============================= 年 下拉菜单结束 =============================-->
              <TD></TD>
              <!--============================= 周 下拉菜单开始 =============================-->
              <%
                if ("1".equals(type))
                //周报
                {
              %>
              <TD><%=SystemEnv.getHtmlLabelName(1926,user.getLanguage())%></TD>
              <TD class="Field">
                <SELECT name="week">
                <%
                  for (int i = 1; i <= 52; i++)
                  {
                %>
                  <OPTION value="<%=i%>"
                <%
                    if (String.valueOf(i).equals(week))
                    {
                %>
                      selected
                <%
                    }
                %>><%=i%></OPTION>
                <%
                  }
                %>
                </SELECT>
              </TD>              
              <!--============================= 周 下拉菜单结束 =============================-->
              <%
                }
                else if ("2".equals(type))
                //月报
                {  
              %>
              <!--============================= 月 下拉菜单开始 =============================-->
              <TD><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></TD>
              <TD class="Field">
                <SELECT name="month">
                <%
                  for (int i = 1; i <= 12; i++)
                  {
                %>
                    <OPTION value="<%=i%>" 
                <%
                    if (String.valueOf(i).equals(month))
                    {
                %>
                    selected
                <%
                    }
                %>><%=i%></OPTION>
                <%
                  }
                %>
                </SELECT>
              </TD>
              <!--============================= 月 下拉菜单结束 =============================-->
              <%
                }
              %>                            
            </TR>
            
            <TR>
              <TD class="Line" colSpan="2"></TD><TD></TD><TD class="Line" colSpan="2"></TD>
            </TR>

            <TR>
              <TD><%=SystemEnv.getHtmlLabelName(842,user.getLanguage())%></TD>
              <!--============================= 计划类型 下拉菜单开始 =============================-->
              <TD class="Field">
                <SELECT name="planType">
                  <OPTION value="<%= Constants.WorkPlan_Type_All %>" <%if (Constants.WorkPlan_Type_All.equals(workPlanReport.getPlanType())) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
                  <OPTION value="<%= Constants.WorkPlan_Type_Plan %>" <%if (Constants.WorkPlan_Type_Plan.equals(workPlanReport.getPlanType())) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(15090,user.getLanguage())%></OPTION>
                  <OPTION value="<%= Constants.WorkPlan_Type_ConferenceCalendar %>" <%if (Constants.WorkPlan_Type_ConferenceCalendar.equals(workPlanReport.getPlanType())) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(1038,user.getLanguage())%></OPTION>
                  <OPTION value="<%= Constants.WorkPlan_Type_ProjectCalendar %>" <%if (Constants.WorkPlan_Type_ProjectCalendar.equals(workPlanReport.getPlanType())) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(16095,user.getLanguage())%></OPTION>
                  <OPTION value="<%= Constants.WorkPlan_Type_CustomerContact %>" <%if (Constants.WorkPlan_Type_CustomerContact.equals(workPlanReport.getPlanType())) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(6082,user.getLanguage())%></OPTION>
                  <OPTION value="<%= Constants.WorkPlan_Type_PersonalScratchpad %>" <%if (Constants.WorkPlan_Type_PersonalScratchpad.equals(workPlanReport.getPlanType())) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(17487,user.getLanguage())%></OPTION>
                  <!--<OPTION value="<%= Constants.WorkPlan_Type_PurposePlan %>" <%if (Constants.WorkPlan_Type_PurposePlan.equals(workPlanReport.getPlanType())) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(18181,user.getLanguage())%></OPTION>-->
                </SELECT>
              </TD>
              <!--============================= 计划类型 下拉菜单结束 =============================-->              
              <TD></TD>
              <TD><%=SystemEnv.getHtmlLabelName(17524,user.getLanguage())%></TD>
              <!--============================= 计划状态 下拉菜单开始 =============================-->
              <TD class="Field">
                <SELECT name="planStatus">
                  <OPTION value="<%= Constants.WorkPlan_Status_All %>" <%if (Constants.WorkPlan_Status_All.equals(workPlanReport.getPlanStatus())) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
                  <OPTION value="<%= Constants.WorkPlan_Status_Unfinished %>" <%if (Constants.WorkPlan_Status_Unfinished.equals(workPlanReport.getPlanStatus())) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(732,user.getLanguage())%></OPTION>
                  <OPTION value="<%= Constants.WorkPlan_Status_Finished %>" <%if (Constants.WorkPlan_Status_Finished.equals(workPlanReport.getPlanStatus())) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(1961,user.getLanguage())%></OPTION>
                  <OPTION value="<%= Constants.WorkPlan_Status_Archived %>" <%if (Constants.WorkPlan_Status_Archived.equals(workPlanReport.getPlanStatus())) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></OPTION>
                </SELECT>
              </TD>
              <!--============================= 计划状态 下拉菜单结束 =============================-->
            </TR>
            <TR>
              <TD class="Line" colSpan="2"></TD><TD></TD><TD class="Line" colSpan="2"></TD>
            </TR>      
           </TBODY>
          </TABLE>
          </LABEL>
          <!--============================= 上部下拉选择区域结束 =============================-->
          
          <!--============================= 下部显示列表开始 =============================-->
          <%
            if ("1".equals(type))
            {
          %>
          <TABLE class="ListStyle" cellspacing="1" id="result">
            <COLGROUP>
              <COL width="9%">
              <COL width="13%">
              <COL width="13%">
              <COL width="13%">
              <COL width="13%">
              <COL width="13%">
              <COL width="13%">
              <COL width="13%">
              <COL width="13%">
            <TBODY>
            <TR class="Header">
              <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
              <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(398,user.getLanguage())%></TD>              
              <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(392,user.getLanguage())%></TD>
              <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(393,user.getLanguage())%></TD>
              <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(394,user.getLanguage())%></TD>
              <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(395,user.getLanguage())%></TD>
              <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(396,user.getLanguage())%></TD>
              <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(397,user.getLanguage())%></TD>
            </TR>
            <TR class="Line"><TD colspan="8"></TD></TR>
            <%
              for(int i = 0; i < userWorkPlanList.size(); i++)
              {
                if(0 == i % 2)
                {
            %>
            <TR CLASS=DataLight>
            <%    
                }
                else
                {
            %>
            <TR CLASS=DataDark>
            <%    
                }
                
                UserWorkPlan userWorkPlan = (UserWorkPlan)userWorkPlanList.get(i);                 
            %>
              <TD valign="top" style="TEXT-ALIGN: center">
                  <%= userWorkPlan.getUserName() %>
              </TD>
            <%
                Map dayWorkPlanMap = (Hashtable)userWorkPlan.getDayWorkPlanMap();
                  
                for(int j = 0; j < 7; j++)
                {
            %>
              <TD valign="top">
            <%
                  if(null != dayWorkPlanMap.get(new Integer(j).toString()))
                  {
            %>
                <%= dayWorkPlanMap.get(new Integer(j).toString()) %>
              </TD>
            <%
                  }
                }
            %>
            </TR>
            <%
              }
            %>
          </TABLE>
          <%
            }
            else if("2".equals(type))
            {
          %>
          <TABLE class="ListStyle" cellspacing="1" id="result">
            <TR class="Header">
              <TD style="TEXT-ALIGN: center"><LABEL style="width:50"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></LABEL></TD>
            <%
              for(int i = 0; i < new Integer(workPlanReport.getSearchEndDate().substring(8, workPlanReport.getSearchEndDate().length())).intValue(); i++)
              {
            %>

              <TD width="100" style="TEXT-ALIGN: center"><label style="width:100"><%= i + 1 %></LABEL></TD>
            <%
              }
            %>
            </TR>
            <TR class="Line"><TD colspan="8"></TD></TR>
            <%
              for(int i = 0; i < userWorkPlanList.size(); i++)
              {
                if(0 == i % 2)
                {
            %>            
            <TR CLASS=DataLight>
            <%    
                }
                else
                {
            %>
            <TR CLASS=DataDark>
            <%  }               
                UserWorkPlan userWorkPlan = (UserWorkPlan)userWorkPlanList.get(i);                 
            %>
              <TD valign="top" style="TEXT-ALIGN: center">
                  <%= userWorkPlan.getUserName() %>
              </TD>
            <%
                Map dayWorkPlanMap = (Hashtable)userWorkPlan.getDayWorkPlanMap();
                  
                for(int j = 0; j < new Integer(workPlanReport.getSearchEndDate().substring(8, workPlanReport.getSearchEndDate().length())).intValue(); j++)
                {
            %>
              <TD width="100" valign="top">
                <LABEL style="width:100">
            <%
                  if(null != dayWorkPlanMap.get(new Integer(j).toString()))
                  {
            %>
                <%= dayWorkPlanMap.get(new Integer(j).toString()) %>
                </LABEL>
              </TD>
            <%
                  }
                }
            %>
            </TR>
            <%
              }
            %>
          </TABLE>
          <%
            }
          %>
          <!--============================= 下部显示列表结束 =============================-->
        </TD>
        </TR>
      </TABLE>
    </FORM>
    </TD>
    <TD></TD>
  </TR>
  <TR>
    <TD height="10" colspan="3"></TD>
  </TR>
</TABLE>

</BODY>


<SCRIPT language="VBS" src="/js/browser/DateBrowser.vbs"></SCRIPT>
<SCRIPT language="VBS" src="/js/browser/HrmResourceBrowser.vbs"></SCRIPT>

<SCRIPT language="JavaScript">
function doView(workid) {   
    openFullWindow("../data/WorkPlanDetail.jsp?workid="+workid+"&from=1");
}

function doSearch() 
{
    document.frmmain.action = "WorkPlanReportListOperation.jsp?type=<%= request.getParameter("type") %>";
    document.frmmain.submit();
}

function viewTypeChanged() {
    var selectedValue = document.all("planType").value;
    if (selectedValue == "v3")
        document.all("underlingspan").className = "vis1";
    else
        document.all("underlingspan").className = "vis0";
}
</SCRIPT>
</HTML>