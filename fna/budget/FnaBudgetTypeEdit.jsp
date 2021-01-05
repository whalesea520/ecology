
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.general.TimeUtil,java.util.*,java.math.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="FnaBudgetInfoComInfo" class="weaver.fna.maintenance.FnaBudgetInfoComInfo" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page"/>
<%
    /*
    // 具有查看该部门权限的人， 本部门主管和财务管理员
    boolean canView = HrmUserVarify.checkUserRight("FnaBudget:All",user,departmentid) ;
    boolean canedit =  HrmUserVarify.checkUserRight("FnaBudgetEdit:Edit", user) && (""+user.getUserDepartment()).equals(departmentid) ;
    boolean canapprove = HrmUserVarify.checkUserRight("FnaBudget:Approve",user) ;
    // 将通过作为单独的权限
    boolean canprocess = HrmUserVarify.checkUserRight("FnaBudget:Process",user) ;
    if(!canView && !canedit && !canapprove && !canprocess) {
        response.sendRedirect("/notice/noright.jsp") ;
        return ;
    }
    */
    boolean canEdit = true;//可编辑
    boolean canSave = true;//可保存草稿
    boolean canApprove = true;//可保存新版本并批准
    boolean canShowDistributiveBudget = true;//是否显示已分配预算

    String fnabudgetinfoid = Util.null2String(request.getParameter("fnabudgetinfoid"));//ID
    String fnabudgettypeid = Util.null2String(request.getParameter("fnabudgettypeid"));//科目ID
    int msgid = Util.getIntValue(request.getParameter("msgid"), -1);

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
        canEdit = false;
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
        canEdit = false;
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
    if (right < 1) canEdit = false;//不可编辑

    if (right > 1) {
        canSave = true;//可保存草稿
        canApprove = true;//可保存新版本并批准
        canShowDistributiveBudget = true;//是否显示已分配预算
    } else {
        canSave = true;//可保存草稿
        canApprove = false;//可保存新版本并批准
        canShowDistributiveBudget = true;//是否显示已分配预算
    }

    if (!"0".equals(status) && !"1".equals(status)) canEdit = false;

    if ("3".equals(organizationtype)) {
        canShowDistributiveBudget = false;
        canEdit = false;
    }

    if (!canEdit) {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }

    String imagefilename = "/images/hdReport_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(386, user.getLanguage());
    String needfav = "1";
    String needhelp = "";

    double tmpnum = 0d;
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
<SCRIPT language="javascript">
function formatNum(num,toFix) {
    if(isNaN(num)) return (toFix?"0.00":"0");
    if(toFix) return num.toFixed(2);
    else {
        if(num-Math.floor(num)==0) return Math.floor(num);
        else return num.toFixed(2);
    }
}

function onCalculete(obj) {
    var tmpn = 0;
    var tmpnum = 0;
    var tmpyearnum = 0;
    var tmpallnum = 0;
    var splitstrarray = obj.name.split("_");
    //将该行的选择框选中
    var t = eval("document.frmMain.CHK_IDS");
    var FnaOrgTypes = eval("document.frmMain.FnaOrgTypes");
	if (t != null && t.length > 0) {
        for (i = 1; i < t.length; i++){
            if(t[i].value==splitstrarray[1]){
                t[i].checked = true;
                break;
            }
        }
    }
    //汇总年新预算
    tmpn = eval("document.frmMain." + splitstrarray[0] + "_" + splitstrarray[1] + "_" + splitstrarray[2] + "_" + splitstrarray[3] + "_sum").value;
    var yearnew_input = parseFloat(tmpn == ""?0:tmpn);
    var aobj = eval("document.frmMain." + splitstrarray[0] + "_" + splitstrarray[1] + "_" + splitstrarray[2] + "_" + splitstrarray[3]);
    var yearnew = 0;
    for (i = 0; aobj != null && i < aobj.length; i++) {
        tmpn = aobj[i].value;
        yearnew = yearnew + parseFloat(tmpn == ""?0:tmpn);
    }
    yearnew = formatNum(yearnew,false);
    if (yearnew_input > yearnew) {
        yearnew = formatNum(yearnew_input,false);
    }
    eval("document.frmMain." + splitstrarray[0] + "_" + splitstrarray[1] + "_" + splitstrarray[2] + "_" + splitstrarray[3] + "_sum").value = yearnew;
}

</script>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    if (canSave) {//保存
        RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:onSave(),_self} ";
        RCMenuHeight += RCMenuHeightStep;
    }
    if (canApprove) {//批准生效
        RCMenu += "{" + SystemEnv.getHtmlLabelName(142, user.getLanguage()) + SystemEnv.getHtmlLabelName(18431, user.getLanguage()) + ",javascript:onApprove(),_self} ";
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

<span id="errormsg" style="color:red"></span>

<FORM id="frmMain" name="frmMain" action="FnaBudgetView.jsp" method=post>
<input type="hidden" name="operation">
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
        <%-- // 预算总额 --%>
        <span id="budget"></span>
        <input type="hidden" name="budget" value="">
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
        <%-- // 已分配预算 --%>
        <% if (canShowDistributiveBudget) { %>
        <span id="allottedbudget"></span>
        <input type="hidden" name="allottedbudget" value="">
        <%}%>
    </td>
</tr>

<TR><TD class=Line colSpan=5></TD></TR>

<TR><TD colSpan=5 height=5></TD></TR>

</TBODY>
</TABLE>

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
        <table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td>
            <%
                if ("0".equals(organizationtype))
                    out.print(Util.toScreen(CompanyComInfo.getCompanyname(organizationid), user.getLanguage()));
                if ("1".equals(organizationtype))
                    out.print(Util.toScreen(SubCompanyComInfo.getSubCompanyname(organizationid), user.getLanguage()));
                if ("2".equals(organizationtype))
                    out.print(Util.toScreen(DepartmentComInfo.getDepartmentname(organizationid), user.getLanguage()));
            %>
            - <%=fnabudgettypename%> - <%=budgetyears%>
            <input name="calculateCount" type="hidden" value="<%=calculateCount%>">
        </td><td align=right>
            <table cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td>
                        <BUTTON class=btnEdit
                    onclick="onAverage2();"><%=SystemEnv.getHtmlLabelName(18879, user.getLanguage())%></BUTTON>
                    </td>
                    <td>
                        <BUTTON class=btnEdit
                    onclick="onAverage();"><%=SystemEnv.getHtmlLabelName(18579, user.getLanguage())%></BUTTON>
                    </td>
                </tr>
            </table>
        </td></tr></table>
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

<%-- 预算总额 --%>

<TR CLASS="datalight">
    <TD><input name="CHK_IDS" type="checkbox"
               onClick="onSelectAll();"><%=SystemEnv.getHtmlLabelName(18501, user.getLanguage())%></TD>
    <%
        tmpnum = 0d;
        tmpsum = 0d;
        tmpsum1 = 0d;

        Map distributiveBudgetAmount = FnaBudgetInfoComInfo.getDistributiveBudgetAmount(organizationid, organizationtype, budgetperiods, fnabudgettypeid);
        Map budgetTypeAmount = FnaBudgetInfoComInfo.getBudgetTypeAmount(fnabudgetinfoid, fnabudgettypeid);

        for (int i = 1; i <= calculateCount; i++) {
    %>
    <TD ALIGN="RIGHT">
        <span id="Fna_All_Budget_<%=i%>">
        <%
            tmpnum = Util.getDoubleValue(Util.null2o((String) budgetTypeAmount.get("" + i)));//FnaBudgetInfoComInfo.getBudgetTypeAmount(fnabudgetinfoid, (new Integer(i)).toString(), fnabudgettypeid);
            tmpsum += tmpnum;
            out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum));
            tmpnum = Util.getDoubleValue(Util.null2o((String) distributiveBudgetAmount.get("" + i)));//FnaBudgetInfoComInfo.getDistributiveBudgetAmount(organizationid, organizationtype, budgetperiods, (new Integer(i)).toString(), fnabudgettypeid);
            tmpsum1 += tmpnum;
        %>
        </span>
        <span id="Msg_All_Budget_<%=i%>"></span>
    </TD>
    <%
        }
    %>
    <TD ALIGN="RIGHT">
        <%
            out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpsum));
        %>
        <script language="JavaScript">
            document.getElementById("budget").innerHTML = "<%=FnaBudgetInfoComInfo.getStrFromDouble(tmpsum)%>";
            document.getElementById("allottedbudget").innerHTML = "<%=FnaBudgetInfoComInfo.getStrFromDouble(tmpsum1)%>";
        </script>
    </TD>
</TR>

<%-- 预算列表 --%>

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
    String sql = "";
    while (RecordSet.next()) {
        String tmpfnabudgetinfoid = Util.null2String(RecordSet.getString("fnabudgetinfoid"));
        String tmporganizationid = Util.null2String(RecordSet.getString("budgetorganizationid"));
        String tmporganizationtype = Util.null2String(RecordSet.getString("organizationtype"));
        String tmporganizationname = "";
        if ("0".equals(tmporganizationtype))
            tmporganizationname = (Util.toScreen(CompanyComInfo.getCompanyname(tmporganizationid), user.getLanguage()));
        if ("1".equals(tmporganizationtype))
        {
            tmporganizationname = (Util.toScreen(SubCompanyComInfo.getSubCompanyname(tmporganizationid), user.getLanguage()));
            sql = "select * from HrmSubCompany where canceled='1' and id="+tmporganizationid;
        }
        if ("2".equals(tmporganizationtype))
        {
            tmporganizationname = (Util.toScreen(DepartmentComInfo.getDepartmentname(tmporganizationid), user.getLanguage()));
            sql = "select * from hrmdepartment where canceled='1' and id="+tmporganizationid;
        }
        if ("3".equals(tmporganizationtype))
            tmporganizationname = (Util.toScreen(ResourceComInfo.getResourcename(tmporganizationid), user.getLanguage()));
        if(!"".equals(sql))
        {
	        RecordSet2.execute(sql);
	        if(RecordSet2.next())
	        {
	        	continue;
	        }
        }

        isLight = !isLight;
%>
<TR CLASS="<%=(isLight?"datalight":"datadark")%>">
    <TD NOWRAP>
        <input name="CHK_IDS" type="checkbox" value="<%=tmporganizationid%>"><%=tmporganizationname%>
        <input name="FnaOrgIDs" type="hidden" value="<%=tmporganizationid%>">
        <input name="FnaOrgTypes" type="hidden" value="<%=tmporganizationtype%>">
    </TD>
    <%
        tmpnum = 0d;
        tmpsum = 0d;
        Map tmpbudgetTypeAmount = FnaBudgetInfoComInfo.getBudgetTypeAmount(tmpfnabudgetinfoid, fnabudgettypeid);

        for (int i = 1; i <= calculateCount; i++) {
    %>
    <TD ALIGN="RIGHT">
        <%
            tmpnum = Util.getDoubleValue(Util.null2o((String) tmpbudgetTypeAmount.get("" + i)));//FnaBudgetInfoComInfo.getBudgetTypeAmount(tmpfnabudgetinfoid, (new Integer(i)).toString(), fnabudgettypeid);
            tmpsum += tmpnum;
        %>
        <input name="Fna_<%=tmporganizationid%>_<%=tmporganizationtype%>_Budgets" type="text" onblur="onCalculete(this);" class=InputStyle
               maxlength=20 style="text-align:right;" size=6
               value="<%=FnaBudgetInfoComInfo.getStrFromDouble(tmpnum,false)%>">
    </TD>
    <% } %>
    <TD ALIGN="RIGHT">
        <input name="Fna_<%=tmporganizationid%>_<%=tmporganizationtype%>_Budgets_sum" type="text" onblur="onCalculete(this);" class=InputStyle maxlength=20
               style="text-align:right;" size=6 value="<%=FnaBudgetInfoComInfo.getStrFromDouble(tmpsum,false)%>">
        <span id="msg_<%=tmporganizationid%>_<%=tmporganizationtype%>_budgets"></span>
    </TD>
</TR>
<%
    }
%>
<TR class=Line><TD colspan="<%=calculateCount+2%>"></TD></TR>
</TBODY>
</TABLE>
</FORM>


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
function onAverage() {
    var aobj = eval("document.frmMain.CHK_IDS");
    var FnaOrgTypes = eval("document.frmMain.FnaOrgTypes");

	for (i = 1; aobj != null && i < aobj.length; i++) {
        if (aobj[i].checked) {
			var id;
			if(typeof(FnaOrgTypes[0])=="undefined") 
		        id = aobj[i].value + "_" + FnaOrgTypes.value;
            else 
				id = aobj[i].value + "_" + FnaOrgTypes[i-1].value;
			tmpn = eval("document.frmMain.Fna_" + id + "_Budgets_sum").value;
            var yearnum = parseFloat(tmpn == ""?0:tmpn);

            var cobj = eval("document.frmMain.Fna_" + id + "_Budgets");
            var avaragenum = 0;

            for (j = 0; cobj != null && j < cobj.length; j++) {
                var tmpnum = cobj[j].value;
                if (tmpnum == "") avaragenum++;
                else yearnum = yearnum - tmpnum;
            }

            if (avaragenum > 0 && yearnum > 0) {
                var avaragevalue = formatNum(parseFloat(yearnum / avaragenum),false);
                var avaragelastvalue = formatNum(parseFloat(yearnum - (avaragevalue * (avaragenum - 1))),false);

                for (j = 0,k = 0; cobj != null && j < cobj.length; j++) {
                    tmpnum = cobj[j].value;
                    if (tmpnum == "") {
                        k++;
                        cobj[j].value = (k == avaragenum?avaragelastvalue:avaragevalue);
                    }
                }
            }
        }
    }
}

function onAverage2() {
    var t1 = eval("document.frmMain.CHK_IDS");
    var FnaOrgTypes = eval("document.frmMain.FnaOrgTypes");
	for (j = 1; j <= <%=calculateCount%>; j++) {
        var allnum = document.getElementById("Fna_All_Budget_" + j).innerHTML;
        allnum = parseFloat(allnum == ""?0:allnum);
        var calnum = 0;
        for (i = 1; t1 != null && i < t1.length; i++) {
	        	var id;
				if(typeof(FnaOrgTypes[0])=="undefined") {
						id =  t1[i].value + "_" + FnaOrgTypes.value;
				}else{
						id = t1[i].value + "_" + FnaOrgTypes[i-1].value;
				}
                var t2 = eval("document.frmMain.Fna_" + id + "_Budgets");
                var tmpnum = 0;
                if(t2.length==null) tmpnum = t2.value;
                else tmpnum = t2[j - 1].value;
                if(tmpnum == ""&&t1[i].checked) calnum++;
                else {
                    tmpnum = parseFloat(tmpnum == ""?0:tmpnum);
                    allnum -= tmpnum;
                }
        }
        if (allnum > 0 && calnum > 0) {
            var avaragevalue = formatNum(parseFloat(allnum / calnum),false);
            var avaragelastvalue = formatNum(parseFloat(allnum - (avaragevalue * (calnum - 1))),false);
            for (k = 1,p=0; t1 != null && k < t1.length; k++) {
                if(t1[k].checked){
                	var id ;
					if(typeof(FnaOrgTypes[0])=="undefined") {
						id =  t1[k].value + "_" + FnaOrgTypes.value;
					}else{
							id =  t1[k].value + "_" + FnaOrgTypes[k-1].value;
					}
                    var t2 = eval("document.frmMain.Fna_" + id + "_Budgets");
                    var tmpsum = 0;
                    if(t2.length==null) tmpnum = t2.value;
                    else tmpnum = t2[j - 1].value;
                    if(tmpnum == ""){
                        p++;
                        t2[j - 1].value = (p==calnum)?avaragelastvalue:avaragevalue;
                    }
                }
            }
        }
    }
    for (j = 1; j < t1.length; j++) {
        if(t1[j].checked){
            var tmpsum = 0;
            var tmpnum = 0;
            var id ;
			if(typeof(FnaOrgTypes[0])=="undefined") {
				id = t1[j].value + "_" + FnaOrgTypes.value;
			}else{
				id = t1[j].value + "_" + FnaOrgTypes[j-1].value;
			}
            var t2 = eval("document.frmMain.Fna_" + id + "_Budgets");
            for (k = 0; k < t2.length; k++) {
                tmpnum = t2[k].value;
                tmpsum += parseFloat(tmpnum == ""?0:tmpnum)
            }
            tmpsum = formatNum(tmpsum,false);
            eval("document.frmMain.Fna_" + id + "_Budgets_sum").value = tmpsum;
        }
    }
}

function check(chkitem1, chkitem2) {
    var rtnvalue = true;
    var t1 = eval("document.frmMain.FnaOrgIDs");
    var FnaOrgTypes = eval("document.frmMain.FnaOrgTypes");
	//清除错误标记
    eval("errormsg").innerHTML = "";
    for (j = 0; j < t1.length; j++)
        eval("msg_" + t1[j].value + "_" + FnaOrgTypes[j].value + "_budgets").innerHTML = "";
    for (j = 1; j <= <%=calculateCount%>; j++)
        eval("Msg_All_Budget_" + j).innerHTML = "";
    //检查年汇总是否相等
    if (t1 != null && chkitem1) {
        var tmpflag = true;
        for (j = 0; j < t1.length; j++) {
            var tmpsum1 = 0;
            var tmpsum2 = 0;
            var tmpnum = 0;
            var id = t1[j].value + "_" + FnaOrgTypes[j].value;
            tmpnum = eval("document.frmMain.Fna_" + id + "_Budgets_sum").value;
            if(typeof(tmpnum)=='undefined') tmpnum = 0;
            tmpsum1 = parseFloat(tmpnum == ""?0:tmpnum);
            var t2 = eval("document.frmMain.Fna_" + id + "_Budgets");
            for (k = 0; k < t2.length; k++) {
                tmpnum = t2[k].value;
                tmpsum2 += parseFloat(tmpnum == ""?0:tmpnum)
            }
            if(t2.length==null) tmpsum2 += parseFloat(t2.value == ""?0:t2.value);
            if (tmpsum1.toFixed(2) != tmpsum2.toFixed(2)) {
                eval("msg_" + id + "_budgets").innerHTML = "<font color=RED><b>!</b></font>";
                tmpflag = false;
            }
        }
        if (!tmpflag) {
            eval("errormsg").innerHTML += "<%=SystemEnv.getHtmlLabelName(18755,user.getLanguage())%><br>";
            rtnvalue = false;
        }
    }
    //检查下级部门预算之和是否大于总预算
    if (t1 != null && chkitem2) {
        var tmpflag = true;
        for (j = 1; j <= <%=calculateCount%>; j++) {
            var tmpsum1 = 0;
            var tmpsum2 = 0;
            var tmpnum = 0;
            tmpnum = document.getElementById("Fna_All_Budget_" + j).innerHTML;
            tmpsum1 = parseFloat(tmpnum == ""?0:tmpnum);
            for (k = 0; t1 != null && k < t1.length; k++) {
                var id = t1[k].value + "_" + FnaOrgTypes[k].value;
                var t2 = eval("document.frmMain.Fna_" + id + "_Budgets");
                if(t2.length==null) tmpnum = t2.value;
                else tmpnum = t2[j - 1].value;
                tmpsum2 = tmpsum2 + parseFloat(tmpnum == ""?0:tmpnum);
            }
            if (tmpsum1 < tmpsum2) {
                eval("Msg_All_Budget_" + j).innerHTML = "<font color=RED><b>!</b></font>";
                tmpflag = false;
            }
        }
        if (!tmpflag) {
            eval("errormsg").innerHTML += "<%=SystemEnv.getHtmlLabelName(18764,user.getLanguage())%><br>";
            rtnvalue = false;
        }
    }
    return rtnvalue;
}

function onSelectAll() {
    var t = eval("document.frmMain.CHK_IDS");
    if (t != null && t.length > 0) {
        for (i = 1; i < t.length; i++) t[i].checked = t[0].checked;
    }
}

function onSave() {
    if (check(true, false)) {
    <%if(status.equals("1")){%>
        if (confirm("<%=SystemEnv.getHtmlLabelName(18752,user.getLanguage())%>")) {
        <%}%>
            document.frmMain.action = "FnaBudgetOperation.jsp";
            document.frmMain.operation.value = "edittypebudget";
            document.frmMain.submit();
        <%if(status.equals("1")){%>
        }
    <%}%>
    }
}

function onApprove() {
    if (check(true, true)) {
        document.frmMain.action = "FnaBudgetOperation.jsp";
        document.frmMain.operation.value = "approvetypefnabudget";
        document.frmMain.submit();
    }
}

function onBack() {
    location.href = "<%=(request.getHeader("referer").indexOf("FnaBudgetEdit")==-1?"FnaBudgetTypeView.jsp":"FnaBudgetEdit.jsp")%>?fnabudgetinfoid=<%=fnabudgetinfoid%><%=(request.getHeader("referer").indexOf("FnaBudgetEdit")==-1?"&fnabudgettypeid="+fnabudgettypeid:"")%>";
    //document.frmMain.action="FnaBudgetView.jsp";
    //document.frmMain.submit();
}
<% if (msgid != -1) { %>
check(true, true);
<%}%>
</script>

</BODY>
</HTML>