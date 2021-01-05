
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.general.TimeUtil,java.util.*,java.math.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="FnaBudgetInfoComInfo" class="weaver.fna.maintenance.FnaBudgetInfoComInfo" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page"/>
<%
    boolean canView = true;//可查看
    boolean canEdit = true;//可编辑
    boolean canShowDistributiveBudget = true;//是否显示已分配预算

    String fnabudgetinfoid = Util.null2String(request.getParameter("fnabudgetinfoid"));//ID
    String fnabudgettypeid = Util.null2String(request.getParameter("fnabudgettypeid"));//科目ID

    String revision = "";//版本
    String organizationid = "";//组织ID
    String organizationtype = "";//组织类型
    String budgetperiods = "";//期间ID
    String budgetyears = "";//期间年
    String status = "";//状态
    String budgetstatus = "";//审批状态

    String sqlstr = "";
    char separator = Util.getSeparator();
    Calendar today = Calendar.getInstance();
    String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
            Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
            Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);

    if (fnabudgetinfoid != null && !"".equals(fnabudgetinfoid)) {
        sqlstr = " select budgetperiods,budgetorganizationid,organizationtype,budgetstatus,revision,status from FnaBudgetInfo where id = " + fnabudgetinfoid;
        RecordSet.executeSql(sqlstr);
        if (RecordSet.next()) {
            budgetperiods = Util.null2String(RecordSet.getString("budgetperiods"));
            organizationid = Util.null2String(RecordSet.getString("budgetorganizationid"));
            organizationtype = Util.null2String(RecordSet.getString("organizationtype"));
            budgetstatus = Util.null2String(RecordSet.getString("budgetstatus"));
            revision = Util.null2String(RecordSet.getString("revision"));
            status = Util.null2String(RecordSet.getString("status"));
        }
    } else {
        canView = false;
    }

//取当前期间的年份
    if ("".equals(budgetyears)) {
        sqlstr = " select fnayear from FnaYearsPeriods where id = " + budgetperiods;
        RecordSet.executeSql(sqlstr);
        if (RecordSet.next()) {
            budgetyears = Util.null2String(RecordSet.getString("fnayear"));
        }
    }

//取状态
    if ("".equals(status) || "".equals(budgetstatus)) {
        sqlstr = " select status,budgetstatus from FnaBudgetInfo where budgetperiods = " + budgetperiods + " and budgetorganizationid = " + organizationid + " and organizationtype = " + organizationtype + " and revision = " + revision;
        RecordSet.executeSql(sqlstr);
        if (RecordSet.next()) {
            status = Util.null2String(RecordSet.getString("status"));
            budgetstatus = Util.null2String(RecordSet.getString("budgetstatus"));
        } else {
            status = "0";
            budgetstatus = "0";
        }
    }

//取科目名称
    String fnabudgetfirstypetname = "";
    String fnabudgetfirstypetid = "";
    String fnabudgetsecondtypename = "";
    String fnabudgetsecondtypeid = "";
    String fnabudgettypename = "";
    String fnabudgettypeperiod = "";
    if (fnabudgettypeid != null && !"".equals(fnabudgettypeid)) {
        sqlstr = " select name,supsubject from FnaBudgetfeeType where feelevel = 3 and id = " + fnabudgettypeid;
        RecordSet.executeSql(sqlstr);
        if (RecordSet.next()) {
            fnabudgettypename = Util.null2String(RecordSet.getString("name"));
            fnabudgetsecondtypeid = Util.null2String(RecordSet.getString("supsubject"));
        }
        sqlstr = " select name,supsubject from FnaBudgetfeeType where feelevel = 2 and id = " + fnabudgetsecondtypeid;
        RecordSet.executeSql(sqlstr);
        if (RecordSet.next()) {
            fnabudgetsecondtypename = Util.null2String(RecordSet.getString("name"));
            fnabudgetfirstypetid = Util.null2String(RecordSet.getString("supsubject"));
        }
        sqlstr = " select name,feeperiod from FnaBudgetfeeType where feelevel = 1 and id = " + fnabudgetfirstypetid;
        RecordSet.executeSql(sqlstr);
        if (RecordSet.next()) {
            fnabudgetfirstypetname = Util.null2String(RecordSet.getString("name"));
            fnabudgettypeperiod = Util.null2String(RecordSet.getString("feeperiod"));
        }
    } else {
        canView = false;
    }

//检查权限
    int right = -1;//-1：禁止、0：只读、1：编辑、2：完全操作
    if ("0".equals(organizationtype)) {
        if (HrmUserVarify.checkUserRight("HeadBudget:Maint", user))
            right = Util.getIntValue(HrmUserVarify.getRightLevel("HeadBudget:Maint", user), 0);
    } else {
        if (Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0) == 1) {//如果分权
            int subCompanyId = 0;
            if ("1".equals(organizationtype))
                subCompanyId = (new Integer(organizationid)).intValue();
            else if ("2".equals(organizationtype))
                subCompanyId = (new Integer(DepartmentComInfo.getSubcompanyid1(organizationid))).intValue();
            else if ("3".equals(organizationtype))
                subCompanyId = (new Integer(DepartmentComInfo.getSubcompanyid1(ResourceComInfo.getDepartmentID(organizationid)))).intValue();
            right = CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "SubBudget:Maint", subCompanyId);
        } else {
            if (HrmUserVarify.checkUserRight("SubBudget:Maint", user))
                right = Util.getIntValue(HrmUserVarify.getRightLevel("SubBudget:Maint", user), 0);
        }
    }
    if (right < 0) canView = false;//可查看
    if (right < 1) canEdit = false;//不可编辑

    if (!"0".equals(status) && !"1".equals(status)) canEdit = false;//历史和待审批状态，不能修改

    if ("3".equals(organizationtype)) {
        canShowDistributiveBudget = false;//人员预算无“已分配预算”统计项
        canView = false;//人员预算无科目链接
    }

    if (!canView) {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }

    String imagefilename = "/images/hdReport_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(386, user.getLanguage());
    String needfav = "1";
    String needhelp = "";

    double tmpnum = 0d;
    double tmpnum1 = 0d;
    double tmpnum2 = 0d;
    double tmpsum = 0d;
    double tmpsum1 = 0d;
%>
<HTML><HEAD>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
    <style>
        #tabPane tr td {
            padding-top: 2px
        }

        #monthHtmlTbl td, #seasonHtmlTbl td {
            cursor: hand;
            text-align: center;
            padding: 0 2px 0 2px;
            color: #333;
            text-decoration: underline
        }

        .cycleTD {
            font-family: MS Shell Dlg, Arial;
            background-image: url( /images/tab2_wev8.png );
            cursor: hand;
            font-weight: bold;
            text-align: center;
            color: #666;
            border-bottom: 1px solid #879293;
        }

        .cycleTDCurrent {
            font-family: MS Shell Dlg, Arial;
            padding-top: 2px;
            background-image: url( /images/tab.active2_wev8.png );
            cursor: hand;
            font-weight: bold;
            text-align: center;
            color: #666
        }

        .seasonTDCurrent, .monthTDCurrent {
            color: black;
            font-weight: bold;
            background-color: #CCC
        }

        #subTab {
            border-bottom: 1px solid #879293;
            padding: 0
        }

        #goalGroupStatus {
            text-align: center;
            color: black;
            font-weight: bold
        }
    </style>
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    if (canEdit) {
        RCMenu += "{" + SystemEnv.getHtmlLabelName(103, user.getLanguage()) + ",javascript:onEdit(),_self} ";
        RCMenuHeight += RCMenuHeightStep;
    }
    RCMenu += "{" + SystemEnv.getHtmlLabelName(1290, user.getLanguage()) + ",javascript:onBack(),_self} ";
    RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
    <td height="10" colspan="3"></td>
</tr>
<tr>
<td></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<FORM id="frmMain" name="frmMain" action="FnaBudgetView.jsp" method=post>
<INPUT name="fnabudgetinfoid" type="hidden" value="<%=fnabudgetinfoid%>">

<!--表头 开始-->

<TABLE class="ViewForm">
<TBODY>
<colgroup>
<col width="16%">
<col width="*">
<TR>
    <TH class=Title colspan=2>
        <%
            String fnatitle = "<font size=\"3\">";
            if ("0".equals(organizationtype))
                fnatitle += (Util.toScreen(CompanyComInfo.getCompanyname(organizationid), user.getLanguage()));
            if ("1".equals(organizationtype))
                fnatitle += (Util.toScreen(SubCompanyComInfo.getSubCompanyname(organizationid), user.getLanguage()));
            if ("2".equals(organizationtype))
                fnatitle += (Util.toScreen(DepartmentComInfo.getDepartmentname(organizationid), user.getLanguage()));
            if ("3".equals(organizationtype))
                fnatitle += (Util.toScreen(ResourceComInfo.getResourcename(organizationid), user.getLanguage()));
            fnatitle += budgetyears;
            fnatitle += SystemEnv.getHtmlLabelName(15375, user.getLanguage());
            fnatitle += "</font><font color=Green>(";
            if (!"0".equals(status)) {
                fnatitle += SystemEnv.getHtmlLabelName(567, user.getLanguage());//版本
                fnatitle += ":";
                fnatitle += revision;
                fnatitle += "&nbsp;";
                if ("1".equals(status)) fnatitle += SystemEnv.getHtmlLabelName(18431, user.getLanguage());//生效
                if ("2".equals(status)) fnatitle += SystemEnv.getHtmlLabelName(1477, user.getLanguage());//历史
                if ("3".equals(status)) fnatitle += SystemEnv.getHtmlLabelName(2242, user.getLanguage());//待审批
            } else fnatitle += SystemEnv.getHtmlLabelName(220, user.getLanguage());//草稿
            fnatitle += ")</font>";
            out.println(fnatitle);
        %>
    </TH>
</TR>

<TR class=Spacing>
    <TD class=Sep1 colSpan=2></TD>
</TR>

<TR><TD class=Line colSpan=5></TD></TR>

<tr>
    <td><%=SystemEnv.getHtmlLabelName(16455, user.getLanguage())%></td>
    <td class=Field>
        <%
            if ("0".equals(organizationtype))
                out.print(Util.toScreen(CompanyComInfo.getCompanyname(organizationid), user.getLanguage())
                        + "<b>(" + SystemEnv.getHtmlLabelName(140, user.getLanguage()) + ")</b>");
            if ("1".equals(organizationtype))
                out.print(Util.toScreen(SubCompanyComInfo.getSubCompanyname(organizationid), user.getLanguage())
                        + "<b>(" + SystemEnv.getHtmlLabelName(141, user.getLanguage()) + ")</b>");
            if ("2".equals(organizationtype))
                out.print(Util.toScreen(DepartmentComInfo.getDepartmentname(organizationid), user.getLanguage())
                        + "<b>(" + SystemEnv.getHtmlLabelName(124, user.getLanguage()) + ")</b>");
            if ("3".equals(organizationtype))
                out.print(Util.toScreen(ResourceComInfo.getResourcename(organizationid), user.getLanguage())
                        + "<b>(" + SystemEnv.getHtmlLabelName(1867, user.getLanguage()) + ")</b>");
        %>
        <input name="organizationid" type="hidden" value="<%=organizationid%>">
        <input name="organizationtype" type="hidden" value="<%=organizationtype%>">
    </td>
</tr>

<TR><TD class=Line colSpan=5></TD></TR>

<tr>
    <td><%=SystemEnv.getHtmlLabelName(15365, user.getLanguage())%></td>
    <td class=Field><%=budgetyears%>
        <input type="hidden" name="budgetperiods" value="<%=budgetperiods%>">
    </td>
</tr>

<TR><TD class=Line colSpan=5></TD></TR>

<tr>
    <td><%=SystemEnv.getHtmlLabelName(1462, user.getLanguage())%></td>
    <td class=Field><%=fnabudgetfirstypetname%>/<%=fnabudgetsecondtypename%>/<%=fnabudgettypename%>
        <input type="hidden" name="fnabudgettypeid" value="<%=fnabudgettypeid%>">
    </td>
</tr>

<TR><TD class=Line colSpan=5></TD></TR>

<tr>
    <td><%=SystemEnv.getHtmlLabelName(18501, user.getLanguage())%></td>
    <td class=Field>
        <span id="budget_sum"></span>
        <%-- // Todo 预算总额
          tmpnum1 = FnaBudgetInfoComInfo.getBudgetAmount(fnabudgetinfoid);
          out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum1));
          --%>
    </td>
</tr>

<TR><TD class=Line colSpan=5></TD></TR>

<tr>
    <td>
        <% if (canShowDistributiveBudget) { %>
        <%=SystemEnv.getHtmlLabelName(18502, user.getLanguage())%>
        <%}%>
    </td>
    <td class=Field>
        <% if (canShowDistributiveBudget) { %>
        <span id="allotted_sum"></span>
        <%-- // Todo 已分配预算
          tmpnum2 = FnaBudgetInfoComInfo.getDistributiveBudgetAmount(organizationid,organizationtype,budgetperiods);
                  out.print("<font color="+(tmpnum2<tmpnum1?"GREEN":"BLACK")+">");
          out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum2));
                  out.print("</font>");
          --%>
        <%}%>
    </td>
</tr>

<TR><TD class=Line colSpan=5></TD></TR>

<TR><TD colSpan=5 height=5></TD></TR>

</TBODY>
</TABLE>
</FORM>

<!--表头 结束-->

<TABLE width=100% class=ListStyle cellspacing=1 id="monthbudgetlisttable" style="display:block">
<%
    int calculateCount = 0;
    if ("1".equals(fnabudgettypeperiod)) { //月度
        calculateCount = 12;
    }
    if ("2".equals(fnabudgettypeperiod)) { //季度
        calculateCount = 4;
    }
    if ("3".equals(fnabudgettypeperiod)) { //半年
        calculateCount = 2;
    }
    if ("4".equals(fnabudgettypeperiod)) { //年
        calculateCount = 1;
    }
%>
<COLGROUP>
<col width="180">
<% for (int i = 1; i <= calculateCount; i++) { %>
<col width="100">
<% } %>
<col width="100">
<THEAD>

    <TR CLASS="Header"><th colspan="<%=calculateCount+2%>">
        <%
            if ("0".equals(organizationtype))
                out.print(Util.toScreen(CompanyComInfo.getCompanyname(organizationid), user.getLanguage()));
            if ("1".equals(organizationtype))
                out.print(Util.toScreen(SubCompanyComInfo.getSubCompanyname(organizationid), user.getLanguage()));
            if ("2".equals(organizationtype))
                out.print(Util.toScreen(DepartmentComInfo.getDepartmentname(organizationid), user.getLanguage()));
        %>
        - <%=fnabudgettypename%> - <%=budgetyears%>
    </th></tr>

    <TR class=Header>
        <th><%=SystemEnv.getHtmlLabelName(17741, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(106, user.getLanguage())%></th>
        <% for (int i = 1; i <= calculateCount; i++) { %>
        <th><%=i%><%=SystemEnv.getHtmlLabelName(15372, user.getLanguage())%></th>
        <%}%>
        <th><%=SystemEnv.getHtmlLabelName(1013, user.getLanguage())%></th>
    </tr>
    <TR class=Line><TD colspan="<%=calculateCount+2%>"></TD></TR>
</THEAD>

<TR CLASS="datalight">
    <TD><%=SystemEnv.getHtmlLabelName(18501, user.getLanguage())%></TD>
    <%
        tmpnum = 0d;
        tmpsum = 0d;
        tmpsum1 = 0d;

        Map distributiveBudgetAmount = FnaBudgetInfoComInfo.getDistributiveBudgetAmount(organizationid, organizationtype, budgetperiods, fnabudgettypeid);
        Map budgetTypeAmount = FnaBudgetInfoComInfo.getBudgetTypeAmount(fnabudgetinfoid, fnabudgettypeid);

        for (int i = 1; i <= calculateCount; i++) {
    %>
    <TD ALIGN="RIGHT">
        <%
            tmpnum = Util.getDoubleValue(Util.null2o((String) budgetTypeAmount.get("" + i)));//FnaBudgetInfoComInfo.getBudgetTypeAmount(fnabudgetinfoid,(new Integer(i)).toString(),fnabudgettypeid);
            tmpsum += tmpnum;
            out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum));
            tmpnum = Util.getDoubleValue(Util.null2o((String) distributiveBudgetAmount.get("" + i)));//FnaBudgetInfoComInfo.getDistributiveBudgetAmount(organizationid,organizationtype,budgetperiods,(new Integer(i)).toString(),fnabudgettypeid);
            tmpsum1 += tmpnum;
        %>
    </TD>
    <%
        }
    %>
    <TD ALIGN="RIGHT">
        <%
            out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpsum));
        %>
        <script language="JavaScript">
            document.getElementById("budget_sum").innerHTML = "<%=FnaBudgetInfoComInfo.getStrFromDouble(tmpsum)%>";
            document.getElementById("allotted_sum").innerHTML = "<%=FnaBudgetInfoComInfo.getStrFromDouble(tmpsum1)%>";
        </script>
    </TD>
</TR>

<%  //所有预算只取生效版本
    boolean isLight = true;
    if ("0".equals(organizationtype)) {
        sqlstr = " select a.id as fnabudgetinfoid,h.id as budgetorganizationid,1 as organizationtype from HrmSubCompany h "
                + " left join FnaBudgetInfo a on h.id = a.budgetorganizationid "
                + " and a.organizationtype = 1 "
                + " and a.budgetperiods = " + budgetperiods
                + " and a.status in (1) "
                + " where h.companyid = " + organizationid
                + " and h.supsubcomid = 0 "
                + " order by organizationtype desc,budgetorganizationid desc ";
    } else if ("1".equals(organizationtype)) {
        sqlstr = " select a.id as fnabudgetinfoid,h.id as budgetorganizationid,1 as organizationtype from HrmSubCompany h "
                + " left join FnaBudgetInfo a on h.id = a.budgetorganizationid "
                + " and a.organizationtype = 1 "
                + " and a.budgetperiods = " + budgetperiods
                + " and a.status in (1) "
                + " where h.supsubcomid = " + organizationid
                + " UNION "
                + " select a.id as fnabudgetinfoid,h.id as budgetorganizationid,2 as organizationtype from HrmDepartment h "
                + " left join FnaBudgetInfo a on h.id = a.budgetorganizationid "
                + " and a.organizationtype = 2 "
                + " and a.budgetperiods = " + budgetperiods
                + " and a.status in (1) "
                + " where h.subcompanyid1 = " + organizationid
                + " and h.supdepid = 0 "
                + " order by organizationtype desc,budgetorganizationid desc ";
    } else if ("2".equals(organizationtype)) {
        sqlstr = " select a.id as fnabudgetinfoid,h.id as budgetorganizationid,2 as organizationtype from HrmDepartment h "
                + " left join FnaBudgetInfo a on h.id = a.budgetorganizationid "
                + " and a.organizationtype = 2 "
                + " and a.budgetperiods = " + budgetperiods
                + " and a.status in (1) "
                + " where h.supdepid = " + organizationid
                + " UNION "
                + " select a.id as fnabudgetinfoid,h.id as budgetorganizationid,3 as organizationtype from HrmResource h "
                + " left join FnaBudgetInfo a on h.id = a.budgetorganizationid "
                + " and a.organizationtype = 3 "
                + " and a.budgetperiods = " + budgetperiods
                + " and a.status in (1) "
                + " where h.departmentid = " + organizationid
                + " and h.status IN (0, 1, 2, 3) "
                + " order by organizationtype desc,budgetorganizationid desc ";
    }
    RecordSet.executeSql(sqlstr);
    while (RecordSet.next()) {
        String tmpfnabudgetinfoid = Util.null2String(RecordSet.getString("fnabudgetinfoid"));
        String tmporganizationid = Util.null2String(RecordSet.getString("budgetorganizationid"));
        String tmporganizationtype = Util.null2String(RecordSet.getString("organizationtype"));
        String tmporganizationname = "";
        if ("0".equals(tmporganizationtype))
            tmporganizationname = (Util.toScreen(CompanyComInfo.getCompanyname(tmporganizationid), user.getLanguage()));
        if ("1".equals(tmporganizationtype))
            tmporganizationname = (Util.toScreen(SubCompanyComInfo.getSubCompanyname(tmporganizationid), user.getLanguage()));
        if ("2".equals(tmporganizationtype))
            tmporganizationname = (Util.toScreen(DepartmentComInfo.getDepartmentname(tmporganizationid), user.getLanguage()));
        if ("3".equals(tmporganizationtype))
            tmporganizationname = (Util.toScreen(ResourceComInfo.getResourcename(tmporganizationid), user.getLanguage()));

        isLight = !isLight;
%>
<TR CLASS="<%=(isLight?"datalight":"datadark")%>">
    <TD NOWRAP><%=tmporganizationname%></TD>
    <%
        tmpnum = 0d;
        tmpsum = 0d;
        Map tmpbudgetTypeAmount = FnaBudgetInfoComInfo.getBudgetTypeAmount(tmpfnabudgetinfoid, fnabudgettypeid);

        for (int i = 1; i <= calculateCount; i++) {
    %>
    <TD ALIGN="RIGHT">
        <%
            tmpnum = Util.getDoubleValue(Util.null2o((String) tmpbudgetTypeAmount.get("" + i)));//FnaBudgetInfoComInfo.getBudgetTypeAmount(tmpfnabudgetinfoid,(new Integer(i)).toString(),fnabudgettypeid);
            tmpsum += tmpnum;
            out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum));
        %>
    </TD>
    <% } %>
    <TD ALIGN="RIGHT">
        <%
            out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpsum));
        %>
    </TD>
</TR>
<%
    }
%>
<TR class=Line><TD colspan="<%=calculateCount+2%>"></TD></TR>
</TBODY>
</TABLE>


</td>
</tr>
</TABLE>

</td>
<td></td>
</tr>
<tr>
    <td height="5" colspan="3"></td>
</tr>
</table>

<script language=javascript>
    function onEdit() {
        location.href = "FnaBudgetTypeEdit.jsp?fnabudgetinfoid=<%=fnabudgetinfoid%>&fnabudgettypeid=<%=fnabudgettypeid%>";
        //document.frmMain.action="FnaBudgetEdit.jsp";
        //document.frmMain.submit();
    }
    function onBack() {
        location.href = "FnaBudgetView.jsp?fnabudgetinfoid=<%=fnabudgetinfoid%>";
        //document.frmMain.action="FnaBudgetView.jsp";
        //document.frmMain.submit();
    }

</script>


</BODY>
</HTML>