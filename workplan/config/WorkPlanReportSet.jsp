
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.Constants" %>
<%@ page import="weaver.viewform.workplan.WorkPlanVisitViewForm" %>

<%
    if(!HrmUserVarify.checkUserRight("WorkPlanReportSet:Set", user))
    {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
%>

<HTML>
<HEAD>
  <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
  <SCRIPT language="javascript" src="../../js/weaver_wev8.js"></SCRIPT>
</HEAD>

<BODY>
<!--============================= MainFrame标题显示开始 =============================-->
<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(82, user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(19043, user.getLanguage());
    String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<!--============================= MainFrame标题显示结束 =============================-->

<!--============================= 右键菜单开始 =============================-->
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    RCMenu += "{" + SystemEnv.getHtmlLabelName(826,user.getLanguage()) + ",javascript:doSave(),_self}";
    RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<!--============================= 右键菜单结束 =============================-->

  <TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0">
    <COLGROUP>
      <COL width="10">
      <COL width="">
      <COL width="10">
    <TR>
      <TD height="10" colspan="3"></TD>
    </TR>
    <TR>
      <TD ></TD>
      <TD valign="top">
        <TABLE class=Shadow>
          <TR>
            <TD valign="top">  
              <form name="weaver" action="WorkPlanReportSetOperation.jsp?method=addWorkPlanSet" method="post">
                <TABLE class=ViewForm>
                  <COLGROUP>
                    <COL width="20%">
                    <COL width="80%">
                  <TBODY>
                    <!--============================= 选择查看人员和被统计人员开始 =============================-->
                    
                    <!--============================= 查看人员显示部分开始============================-->
                    <TR>
                      <TD>
                        <%=SystemEnv.getHtmlLabelName(19040,user.getLanguage())%>
                      </TD>
                      <TD class="field">
                        <SELECT class=InputStyle name=WorkPlanVisitType onchange="onChangeVisitType()">   
                          <OPTION value="<%= Constants.Hrm_SubCompany %>" selected><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></OPTION> 
                          <OPTION value="<%= Constants.Hrm_Department %>"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></OPTION> 
                          <OPTION value="<%= Constants.Hrm_Station %>"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></OPTION> 
                          <OPTION value="<%= Constants.Hrm_Role %>"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></OPTION> 
                          <OPTION value="<%= Constants.Hrm_All_Member %>"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></OPTION> 
                          <OPTION value="<%= Constants.Hrm_Resource %>"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></OPTION> 
                        </SELECT>
                        &nbsp;&nbsp;
                        <!--======== 分部多选框 ========-->
                        <BUTTON class=Browser style="display:''" onClick="onShowSubcompany('VisitRelatedShareID', 'VisitShowRelatedShareName')" name=VisitShowSubCompany></BUTTON>
                        <!--======== 部门多选框 ========-->
                        <BUTTON class=Browser style="display:none" onClick="onShowDepartment(VisitRelatedShareID, VisitShowRelatedShareName)" name=VisitShowDepartment></BUTTON>
                        <!--======== 岗位多选框 ==========-->
                        <BUTTON class=Browser style="display:none" onclick="onShowPost('VisitRelatedShareID', VisitShowRelatedShareName)" name=VisitShowPost></BUTTON>
                        <!--======== 角色多选框 ========-->
                        <BUTTON class=Browser style="display:none" onclick="onShowRole('VisitRelatedShareID', 'VisitShowRelatedShareName')" name=VisitShowRole></BUTTON>
                        <!--======== 所有人多选框 ========-->
                        
                        <!--======== 人力资源多选框 ========-->
                        <BUTTON class=Browser style="display:none" onClick="onShowResource(VisitRelatedShareID, VisitShowRelatedShareName)" name=VisitShowResource></BUTTON> 

                        <INPUT type=hidden name=VisitRelatedShareID id="VisitRelatedShareID" value="">
                        <SPAN id=VisitShowRelatedShareName name=VisitShowRelatedShareName><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN>                                            
                      </TD>       
                    </TR>
                    <TR>
                      <TD class=Line colSpan=2 id=VisitShowRoleLevelLine name=VisitShowRoleLevelLine style=""></TD>
                    </TR>
                    <TR id=VisitShowSecLevel name=VisitShowSecLevel style="">
                      <TD><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>&nbsp<%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></TD>
                      <TD class="field">
                        <INPUT type=text name=VisitSecLevel class=InputStyle size=6 value="10" onchange='checkinput("VisitSecLevel","VisitSecLevelImage")' onkeypress="ItemCount_KeyPress()">
                        <SPAN id=VisitSecLevelImage></SPAN>
                      </TD>
                    </TR>
                    <TR>
                       <TD class=Line colSpan=2 id=VisitShowSecLevelLine name=VisitShowSecLevelLine style="display:none"></TD>
                    </TR>
                    <!--============================= 查看人员显示部分结束====================-->
                                        
                    <TR  class=Spacing>
                      <TD class=Line colSpan=2></TD>
                    </TR>
                    
                    <!--============================= 被统计人员显示部分开始============================-->
                    <TR>
                      <TD>
                        <%=SystemEnv.getHtmlLabelName(19038,user.getLanguage())%>
                      </TD>
                      <TD class="field">
                        <SELECT class=InputStyle name=WorkPlanReportType onchange="onChangeReportType()">   
                          <OPTION value="<%= Constants.Hrm_SubCompany %>" selected><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></OPTION> 
                          <OPTION value="<%= Constants.Hrm_Department %>"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></OPTION> 
                          <OPTION value="<%= Constants.Hrm_Station %>"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></OPTION> 
                          <OPTION value="<%= Constants.Hrm_Role %>"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></OPTION> 
                          <OPTION value="<%= Constants.Hrm_All_Member %>"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></OPTION> 
                          <OPTION value="<%= Constants.Hrm_Resource %>"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></OPTION> 
                        </SELECT>
                        <!--======== 分部多选框 ========-->
                        <BUTTON class=Browser style="display:''" onClick="onShowSubcompany('ReportRelatedShareID', 'ReportShowRelatedShareName')" name=ReportShowSubCompany></BUTTON>
                        <!--======== 部门多选框 ========-->
                        <BUTTON class=Browser style="display:none" onClick="onShowDepartment(ReportRelatedShareID, ReportShowRelatedShareName)" name=ReportShowDepartment></BUTTON>
                        <!--======== 岗位多选框 ==========-->
                        <BUTTON class=Browser style="display:none" onclick="onShowPost('ReportRelatedShareID', ReportShowRelatedShareName)" name=ReportShowPost></BUTTON>
                        <!--======== 角色多选框 ========-->
                        <BUTTON class=Browser style="display:none" onclick="onShowRole('ReportRelatedShareID', 'ReportShowRelatedShareName')" name=ReportShowRole></BUTTON>
                        <!--======== 人力资源多选框 ========-->
                        <BUTTON class=Browser style="display:none" onClick="onShowResource(ReportRelatedShareID, ReportShowRelatedShareName)" name=ReportShowResource></BUTTON> 

                        <INPUT type=hidden name=ReportRelatedShareID id="ReportRelatedShareID" value="">
                        <SPAN id=ReportShowRelatedShareName name=ReportShowRelatedShareName><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN>                                            
                      </TD>       
                    </TR>
                    <TR>
                      <TD class=Line colSpan=2 id=ReportShowRoleLevelLine name=ReportShowRoleLevelLine style=""></TD>
                    </TR>
                    <TR id=ReportShowSecLevel name=ReportShowSecLevel style="">
                      <TD><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>&nbsp<%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></TD>
                      <TD class="field">
                        <INPUT type=text name=ReportSecLevel class=InputStyle size=6 value="10" onchange='checkinput("ReportSecLevel","ReportSecLevelImage")' onkeypress="ItemCount_KeyPress()">
                        <SPAN id=ReportSecLevelImage></SPAN>
                      </TD>
                    </TR>
                    <TR>
                       <TD class=Line colSpan=2 id=ReportShowSecLevelLine name=ReportShowSecLevelLine style="display:none"></TD>
                    </TR>
                    <!--============================= 被统计人员显示部分结束===========================-->
                                      
                    <!--============================= 选择查看人员和被统计人员结束 =============================-->
                    
                    <TR>
                      <TD colspan=2>
                        <TABLE  width="100%">
                          <TR>
                            <TD width="40%"></TD>
                            <TD width="20%"><img src="/images/arrow_d_wev8.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(83476,user.getLanguage())%>" onclick="addValue()" border="0">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/arrow_u_wev8.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(33266,user.getLanguage())%>" border="0" onclick="removeValue()"></TD>
                            <TD width="40%"></TD>
                          </TR>
                        </TABLE>
                      </TD>
                    <TR>
                    
                    <!--============================= 被统计人员和查看人员列表开始 =============================-->
                    <TR>
                      <TD class=Line colSpan=2></TD>
                    </TR>                    
                    <TR>
                      <TD colspan=2>
                        <table class="listStyle" id="oTable" name="oTable">
                          <COLGROUP>
                            <COL width="4%" align="center">
                            <COL width="24%" align="center">
                            <COL width="24%" align="center">
                            <COL width="24%" align="center">
                            <COL width="24%" align="center">
                          <TR class="header">
                            <TD><input type="checkbox" name="chkAll" onclick="chkAllClick(this)"></TD>
                            <TD><%=SystemEnv.getHtmlLabelName(19039,user.getLanguage())%></TD>
                            <TD><%=SystemEnv.getHtmlLabelName(19038,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></TD>
                            <TD><%=SystemEnv.getHtmlLabelName(19041,user.getLanguage())%></TD>
                            <TD><%=SystemEnv.getHtmlLabelName(19040,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></TD>
                          </TR>
                          <TR class=line>
                            <TD COLspan=6></TD>
                          </TR>
                        </table>
                      </TD>
                    </TR>
                    <!--============================= 被统计人员和查看人员列表结束 =============================-->
                    
                  </TBODY>
                </TABLE>
              </form>
            </TD>
          </TR>
        </TABLE>       
      </TD>
      <TD></TD>
    </TR>
    <TR>
      <TD height="10" COLspan="3"></TD>
    </TR>
  </TABLE>

</BODY>
</HTML>

<SCRIPT LANGUAGE="JavaScript">
<!--
    function onChangeVisitType()
    {
        var workPlanVisitType = document.all("WorkPlanVisitType").value;

        document.all("VisitShowSecLevel").style.display='';
        document.all("VisitShowRoleLevelLine").style.display='';
        
        document.all("VisitShowDepartment").style.display='none';
        document.all("VisitShowSubCompany").style.display='none';
        document.all("VisitShowRole").style.display='none';
        document.all("VisitShowPost").style.display='none';
        document.all("VisitShowResource").style.display='none';
        
        document.all("VisitRelatedShareID").value = -1;
        document.all("VisitSecLevel").value = 10;
        VisitShowRelatedShareName.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
        
        /*====== 所有人 ======*/
        if(<%= Constants.Hrm_All_Member %> == workPlanVisitType)
        {
            VisitShowRelatedShareName.innerHTML = "";
        }
        
        /*====== 分部 ======*/
        if(<%= Constants.Hrm_SubCompany %> == workPlanVisitType)
        {
            document.all("VisitShowSubCompany").style.display='';
        }
    
        /*====== 部门 ======*/
        if(<%= Constants.Hrm_Department %> == workPlanVisitType)
        {
            document.all("VisitShowDepartment").style.display='';
        }
        
        /*====== 角色 ======*/
        if(<%= Constants.Hrm_Role %> == workPlanVisitType)
        {
            document.all("VisitShowRole").style.display='';
        }
        
        /*====== 岗位 ======*/
        if(<%= Constants.Hrm_Station %> == workPlanVisitType)
        {
            document.all("VisitShowPost").style.display='';
        }
        
        /*====== 人力资源 ======*/
        if(<%= Constants.Hrm_Resource %> == workPlanVisitType)
        {
            document.all("VisitShowSecLevel").style.display='none';
            document.all("VisitShowRoleLevelLine").style.display='none';
            document.all("VisitShowResource").style.display='';
        }
    }
    
    function onChangeReportType()
    {
        var workPlanReportType = document.all("WorkPlanReportType").value;

        document.all("ReportShowSecLevel").style.display='';
        document.all("ReportShowRoleLevelLine").style.display='';
        
        document.all("ReportShowDepartment").style.display='none';
        document.all("ReportShowSubCompany").style.display='none';
        document.all("ReportShowRole").style.display='none';
        document.all("ReportShowPost").style.display='none';
        document.all("ReportShowResource").style.display='none';
        
        document.all("ReportRelatedShareID").value = -1;
        document.all("ReportSecLevel").value = 10;
        ReportShowRelatedShareName.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
        
        /*====== 所有人 ======*/
        if(<%= Constants.Hrm_All_Member %> == workPlanReportType)
        {
            ReportShowRelatedShareName.innerHTML = "";
        }
        
        /*====== 分部 ======*/
        if(<%= Constants.Hrm_SubCompany %> == workPlanReportType)
        {
            document.all("ReportShowSubCompany").style.display='';
        }
    
        /*====== 部门 ======*/
        if(<%= Constants.Hrm_Department %> == workPlanReportType)
        {
            document.all("ReportShowDepartment").style.display='';
        }
        
        /*====== 角色 ======*/
        if(<%= Constants.Hrm_Role %> == workPlanReportType)
        {
            document.all("ReportShowRole").style.display='';
        }
        
        /*====== 岗位 ======*/
        if(<%= Constants.Hrm_Station %> == workPlanReportType)
        {
            document.all("ReportShowPost").style.display='';
        }
        
        /*====== 人力资源 ======*/
        if(<%= Constants.Hrm_Resource %> == workPlanReportType)
        {
            document.all("ReportShowSecLevel").style.display='none';
            document.all("ReportShowRoleLevelLine").style.display='none';
            document.all("ReportShowResource").style.display='';
        }
    }


    function removeValue()
    {
        var chks = document.getElementsByName("chkShareDetail");
        
        for (var i=chks.length-1; i>=0; i--)
        {
            var chk = chks[i];
            if (chk.checked)
            {
                oTable.deleteRow(chk.parentElement.parentElement.parentElement.rowIndex)
            }
        }
    }


    function addValue()
    {        
        if (<%= Constants.Hrm_All_Member %> != visitWorkPlanType || <%= Constants.Hrm_All_Member %> != reportWorkPlanType)
        {
            if(!check_form(document.weaver,'VisitRelatedShareID') || !check_form(document.weaver,'ReportRelatedShareID')) 
            {
                return ;
            }
        }

        if (!check_form(document.weaver,'VisitSecLevel') || !check_form(document.weaver,'ReportSecLevel'))
        {
            return;
        }
        
        //下拉列表中的类型ID
        var visitWorkPlanType = document.all("WorkPlanVisitType").value;        
        var reportWorkPlanType = document.all("WorkPlanReportType").value;
        
        //下拉列表中的类型内容
        var visitShareTypeText = document.all("WorkPlanVisitType").options.item(document.all("WorkPlanVisitType").selectedIndex).innerText;        
        var reportShareTypeText = document.all("WorkPlanReportType").options.item(document.all("WorkPlanReportType").selectedIndex).innerText;        

        //选择框选中项ID
        var visitRelatedShareIDs = document.all("VisitRelatedShareID").value;   
        var reportRelatedShareIDs = document.all("ReportRelatedShareID").value;
        
        //选择框选中项内容
        var visitRelatedShareNames = document.all("VisitShowRelatedShareName").innerHTML;
        var reportRelatedShareNames = document.all("ReportShowRelatedShareName").innerHTML;

        //安全级别
        var visitSecLevelValue = document.all("VisitSecLevel").value;
        var reportSecLevelValue = document.all("ReportSecLevel").value;


        //主键 + 下拉列表中的类型ID + 选择框选中项ID + 安全级别
        var totalValue = "-1" + "_" + reportWorkPlanType + "_," + reportRelatedShareIDs + ",_" + reportSecLevelValue + "_" + visitWorkPlanType + "_," + visitRelatedShareIDs + ",_" + visitSecLevelValue;
        var oRow = oTable.insertRow();
        var oRowIndex = oRow.rowIndex;

        if (0 == oRowIndex % 2)
        {
            oRow.className = "dataLight";
        }
        else
        {
            oRow.className = "dataDark";
        }

        for (var i = 1; i <= 5; i++)
        //生成一行中的每一列
        {
            oCell = oRow.insertCell();
            var oDiv = document.createElement("div");
            if (1 == i) 
            {
                oDiv.innerHTML="<input class='inputStyle' type='checkbox' name='chkShareDetail' value='" + totalValue + "'><input type='hidden' name='txtShareDetail' value='" + totalValue+"'>";
            }
            else if (2 == i)
            {
                oDiv.innerHTML = reportShareTypeText;
            }
            else if (3 == i)
            {
                if(<%= Constants.Hrm_All_Member %> != reportWorkPlanType)
                {
                    oDiv.innerHTML = reportRelatedShareNames;
                }               
                if(<%= Constants.Hrm_All_Member %> != reportWorkPlanType && <%= Constants.Hrm_Resource %> != reportWorkPlanType)
                {
                    oDiv.innerHTML += " / ";
                }
                if(<%= Constants.Hrm_Resource %> != reportWorkPlanType)
                {
                    oDiv.innerHTML += reportSecLevelValue;
                }
            }
            else if (4 == i)
            {
                oDiv.innerHTML = visitShareTypeText;
            }
            else if (5 == i)
            {
                if(<%= Constants.Hrm_All_Member %> != visitWorkPlanType)
                {
                    oDiv.innerHTML = visitRelatedShareNames;
                }
                if(<%= Constants.Hrm_All_Member %> != visitWorkPlanType && <%= Constants.Hrm_Resource %> != visitWorkPlanType)
                {
                    oDiv.innerHTML += " / ";
                }
                if(<%= Constants.Hrm_Resource %> != visitWorkPlanType)
                {
                    oDiv.innerHTML += visitSecLevelValue;
                }
                
            }
            
            oCell.appendChild(oDiv);
        }
    }


    function chkAllClick(obj)
    {
        var chks = document.getElementsByName("chkShareDetail");
        for (var i=0; i<chks.length; i++)
        {
            var chk = chks[i];
            chk.checked=obj.checked;
        }
    }
    
    function doSave()
    {
        document.weaver.submit();
    }
    
    function init()
    {
    <%
        List workPlanVisitViewFormArrayList = (List)(request.getAttribute("workPlanVisitViewFormArrayList"));

        for(int i = 0; i < workPlanVisitViewFormArrayList.size(); i++)
        {
            WorkPlanVisitViewForm workPlanVisitViewForm = new WorkPlanVisitViewForm();
            
            workPlanVisitViewForm = (WorkPlanVisitViewForm)workPlanVisitViewFormArrayList.get(i);            
    %>
    
            var totalValue = "<%= workPlanVisitViewForm.getWorkPlanVisitSetID() %>" + "_" + "<%= workPlanVisitViewForm.getWorkPlanReportType() %>" + "_" + "<%= workPlanVisitViewForm.getWorkPlanReportContentID() %>" + "_" + "<%= workPlanVisitViewForm.getWorkPlanReportSec() %>" + "_" + "<%= workPlanVisitViewForm.getWorkPlanVisitType() %>" + "_" + "<%= workPlanVisitViewForm.getWorkPlanVisitContentID() %>" + "_" + "<%= workPlanVisitViewForm.getWorkPlanVisitSec() %>";
            var oRow = oTable.insertRow();
            var oRowIndex = oRow.rowIndex;
    
            if (0 == oRowIndex % 2)
            {
                oRow.className = "dataLight";
            }
            else
            {
                oRow.className = "dataDark";
            }
    
            for (var i = 1; i <= 5; i++)
            //生成一行中的每一列
            {
                oCell = oRow.insertCell();
                var oDiv = document.createElement("div");
                if (1 == i) 
                {
                    oDiv.innerHTML="<input class='inputStyle' type='checkbox' name='chkShareDetail' value='" + totalValue + "'><input type='hidden' name='txtShareDetail' value='" + totalValue+"'>";
                }
                else if (2 == i)
                {
                    oDiv.innerHTML = "<%= workPlanVisitViewForm.getWorkPlanReportTypeName() %>";
                }
                else if (3 == i)
                {
                    oDiv.innerHTML = "<%= workPlanVisitViewForm.getWorkPlanReportContentName() %>";
                }
                else if (4 == i)
                {
                    oDiv.innerHTML = "<%= workPlanVisitViewForm.getWorkPlanVisitTypeName() %>";
                }
                else if (5 == i)
                {
                    oDiv.innerHTML = "<%= workPlanVisitViewForm.getWorkPlanVisitContentName() %>";   
                }
                
                oCell.appendChild(oDiv);
            }
    <%            
        }
    %>
    }
    
    init();
    
//-->
</SCRIPT>


<SCRIPT language=VBS>
sub onShowSubcompany(inputename, tdname)
    <%--for TD.4240 edited by wdl--%>
    linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id="
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="&document.all(inputename).value)
    if NOT isempty(id) then
        if id(0)<> "" then        
        resourceids = id(0)
        resourcename = id(1)
        sHtml = ""
        resourceids = Mid(resourceids,2,len(resourceids))
        resourcename = Mid(resourcename,2,len(resourcename))
        document.all(inputename).value = resourceids
        while InStr(resourceids,",") <> 0
            curid = Mid(resourceids,1,InStr(resourceids,",")-1)
            curname = Mid(resourcename,1,InStr(resourcename,",")-1)
            resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
            resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
            sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
        wend
        sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
        document.all(tdname).innerHtml = sHtml
        <%--
        document.all(tdname).innerHtml ="<a href='/hrm/company/HrmSubCompanyDsp.jsp?id="+id(0)+"'>"+ id(1)+"</a>"
        document.all(inputename).value=id(0)
        --%>
        else
        document.all(tdname).innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
        document.all(inputename).value=""
        end if
    end if
    <%--end--%>
end sub


sub onShowDepartment(inputname,spanname)
    linkurl="/hrm/company/HrmDepartmentDsp.jsp?id="
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="&inputname.value)
    if (Not IsEmpty(id)) then
    if id(0)<> "" then
        resourceids = id(0)
        resourcename = id(1)
        sHtml = ""
        resourceids = Mid(resourceids,2,len(resourceids))
        resourcename = Mid(resourcename,2,len(resourcename))
        inputname.value= resourceids
        while InStr(resourceids,",") <> 0
            curid = Mid(resourceids,1,InStr(resourceids,",")-1)
            curname = Mid(resourcename,1,InStr(resourcename,",")-1)
            resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
            resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
            sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
        wend
        sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
        spanname.innerHtml = sHtml
    else    
        spanname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
        inputname.value="0"
    end if
    end if
end sub


sub onShowResource(inputname,spanname)
    linkurl="/hrm/resource/HrmResource.jsp?id="
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
    if (Not IsEmpty(id)) then
    if id(0)<> "" then
        resourceids = id(0)
        resourcename = id(1)
        sHtml = ""
        resourceids = Mid(resourceids,2,len(resourceids))
        resourcename = Mid(resourcename,2,len(resourcename))
        inputname.value= resourceids
        while InStr(resourceids,",") <> 0
            curid = Mid(resourceids,1,InStr(resourceids,",")-1)
            curname = Mid(resourcename,1,InStr(resourcename,",")-1)
            resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
            resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
            sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
        wend
        sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
        spanname.innerHtml = sHtml
    else    
        spanname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
        inputname.value="0"
    end if
    end if
end sub


sub onShowCRM(inputname,spanname)
  temp =inputname.value
    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="+temp)
    if (Not IsEmpty(id1)) then
        if (Len(id1(0)) > 500) then '<%=SystemEnv.getHtmlLabelName(83509,user.getLanguage())%>
            result = msgbox("<%=SystemEnv.getHtmlLabelName(20738,user.getLanguage())%>",48,"<%=SystemEnv.getHtmlLabelName(18739,user.getLanguage())%>")
            spanname.innerHtml =""
            inputname.value=""
        elseif id1(0)<> "" then
            resourceids = id1(0)
            resourcename = id1(1)
            sHtml = ""
            resourceids = Mid(resourceids,2,len(resourceids))
            inputname.value= resourceids
            resourcename = Mid(resourcename,2,len(resourcename))
            while InStr(resourceids,",") <> 0
                curid = Mid(resourceids,1,InStr(resourceids,",")-1)
                curname = Mid(resourcename,1,InStr(resourcename,",")-1)
                resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
                resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
                sHtml = sHtml&"<a href='/CRM/data/ViewCustomer.jsp?CustomerID="&curid&"'>"&curname&"</a>&nbsp"
            wend
            sHtml = sHtml&"<a href='/CRM/data/ViewCustomer.jsp?CustomerID="&resourceids&"'>"&resourcename&"</a>&nbsp"
            spanname.innerHtml = sHtml
        else
            spanname.innerHtml =""
            inputname.value=""
        end if
    end if
    
end sub


sub onShowRole(inputename,tdname)
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
    if NOT isempty(id) then
            if id(0)<> "" then
        document.all(tdname).innerHtml = id(1)
        document.all(inputename).value=id(0)
        else
        document.all(tdname).innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
        document.all(inputename).value=""
        end if
    end if
end sub


sub onShowPost(inputname,spanname)
    tmpids = document.all(inputname).value
    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MultiPostBrowser.jsp?resourceids="&tmpids)
    
    if (Not IsEmpty(id1)) then
        if id1(0)<> "" then
            resourceids = id1(0)
            resourcename = id1(1)
            sHtml = ""          
            resourceids = Mid(resourceids,2,len(resourceids))         
            document.all(inputname).value= resourceids
            resourcename = Mid(resourcename,2,len(resourcename))

            while InStr(resourceids,",") <> 0
                curid = Mid(resourceids,1,InStr(resourceids,",")-1)
                curname = Mid(resourcename,1,InStr(resourcename,",")-1)
                resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
                resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
                sHtml = sHtml&""&curname&"&nbsp"
            wend

            sHtml = sHtml&""&resourcename&"&nbsp"
            spanname.innerHtml = sHtml          

        else
            document.all(spanname).innerHtml = ""
            document.all(inputname).value = ""
        end if
    end if
end sub
</SCRIPT>

