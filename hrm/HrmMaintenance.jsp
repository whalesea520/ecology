<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<HTML><HEAD>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(60,user.getLanguage());
String needfav ="1";
String needhelp ="";

int userid=user.getUID() ;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
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
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<%if(!software.equals("ALL")){%>
<%
String mainttype = Util.null2String(request.getParameter("mainttype"));
%>
<TABLE class="viewForm">
	<TR>
	<TD align=right>
	<SELECT class=inputstyle name=mainttype onchange="changetype()">
		<OPTION value=S <%if(mainttype.equals("S")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%></OPTION>
		<OPTION value=W <%if(mainttype.equals("W")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></OPTION>
		<OPTION value=D <%if(mainttype.equals("D")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></OPTION>
		<OPTION value=H <%if(mainttype.equals("H")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></OPTION>
<%if(software.equals("ALL") || software.equals("CRM")){%>
		<OPTION value=C <%if(mainttype.equals("C")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(147,user.getLanguage())%></OPTION>
		<OPTION value=R <%if(mainttype.equals("R")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></OPTION>
<%}%>
<%if(software.equals("ALL") || software.equals("HRM")){%>
		<OPTION value=I <%if(mainttype.equals("I")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></OPTION>
<%}%>
<%if(software.equals("ALL") || software.equals("HRM") || software.equals("CRM")){%>
		<OPTION value=F <%if(mainttype.equals("F")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(189,user.getLanguage())%></OPTION>
<%}%>
	</SELECT>
	</TD>
	</TR>
</TABLE>
<%}%>
</DIV>
<TABLE class=viewForm>
  <COLGROUP>
  <COL width="48%">
  <COL width=24>
  <COL width="48%">
  <TBODY>
  <TR>
    <TD vAlign=top>
      <TABLE class=viewForm width="100%">
        <TBODY>
<%if(HrmListValidate.isValidate(1)){%>         
        <TR class=Title> 
          <TH><%=SystemEnv.getHtmlLabelName(376,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(381,user.getLanguage())%></TH>
        </TR>
        <TR class= Spacing> 
          <TD class=Sep2>&nbsp;</TD>
        </TR>
        <TR> 
          <TD> <A href="/hrm/company/HrmCompany.jsp"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></a> / <A href="/hrm/company/HrmSubCompany.jsp"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></a> 
            / <A href="/hrm/company/HrmDepartment.jsp"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></A> / <A href="/hrm/company/HrmDepartLayoutEdit.jsp"><%=SystemEnv.getHtmlLabelName(16249,user.getLanguage())%></A> / <a href="/hrm/location/HrmLocation.jsp"><%=SystemEnv.getHtmlLabelName(378,user.getLanguage())%></a> 
          </TD>
        </TR>
        <%if(software.equals("ALL") || software.equals("HRM")){%>
        <!--<TR> 
          <TD><A href="/hrm/company/HrmCostcenterMainCategory.jsp">总成本中心</a> / 
            <A href="/hrm/company/HrmCostcenterSubCategory.jsp">分成本中心</a> / <A href="/hrm/company/HrmCostcenter.jsp">部门成本中心</A></TD>
        </TR>-->
        <%}%>
        <TR> 
          <TD> <A href="/hrm/jobgroups/HrmJobGroups.jsp"><%=SystemEnv.getHtmlLabelName(805,user.getLanguage())%></A> / <a href="/hrm/jobactivities/HrmJobActivities.jsp"><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></a> 
            / <A href="/hrm/jobtitles/HrmJobTitles.jsp"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></A></TD>
        </TR>
<%}%>         
        </TBODY> 
      </TABLE>
	  <br>
      <TABLE class=viewForm width="100%">
        <TBODY>
<%if(HrmListValidate.isValidate(2)){%>         
        <TR class=Title> 
          <TH><%=SystemEnv.getHtmlLabelName(15882,user.getLanguage())%></TH>
        </TR>
        <TR class= Spacing> 
          <TD class=Sep1>&nbsp;</TD>
        </TR>
        <tr class= Spacing> 
          <td>
<%if(software.equals("ALL") || software.equals("HRM")){%>
            <a href="/hrm/employee/EmployeeView.jsp"><%=SystemEnv.getHtmlLabelName(16250,user.getLanguage())%></a>
<%}else{%>
            <a href="/hrm/resource/HrmResourceAdd.jsp"><%=SystemEnv.getHtmlLabelName(16250,user.getLanguage())%></a>
<%}%>
            / <a href="/hrm/resource/HrmResourceHire.jsp"><%=SystemEnv.getHtmlLabelName(6088,user.getLanguage())%></a>
<%if(software.equals("ALL") || software.equals("HRM")){%>
            / <a href="/hrm/resource/HrmResourceExtend.jsp"><%=SystemEnv.getHtmlLabelName(6089,user.getLanguage())%></a>
<%}%>
            / <a href="/hrm/resource/HrmResourceRedeploy.jsp"><%=SystemEnv.getHtmlLabelName(6090,user.getLanguage())%></a>
            / <a href="/hrm/resource/HrmResourceDismiss.jsp"><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></a>
<%if(software.equals("ALL") || software.equals("HRM")){%>
            / <a href="/hrm/resource/HrmResourceRetire.jsp"><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></a>
            / <a href="/hrm/resource/HrmResourceRehire.jsp"><%=SystemEnv.getHtmlLabelName(6093,user.getLanguage())%></a>
            / <a href="/hrm/resource/HrmResourceFire.jsp"><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></a>
<%}%>
          </td>
        </tr>
<!--    <tr class= Spacing> 
          <td><a href="/hrm/employee/HrmResourceAdd.jsp">入职</a></td>
        </tr>
        <tr class= Spacing> 
          <td><a href="/hrm/employee/EmployeeView.jsp">查看：新入职人员</a></td>
        </tr>-->
<%if(software.equals("ALL") || software.equals("HRM")){%>	
<!--        <tr class= Spacing> 
          <td>
          <a href="/hrm/career/HrmCareerInvite.jsp"><%=SystemEnv.getHtmlLabelName(366,user.getLanguage())%></a> 
          / <a href="/hrm/career/HrmCareerApply.jsp"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(1932,user.getLanguage())%></a>
          / <a href="/hrm/career/HrmCareerApplyAdd.jsp?careerid=0"><%=SystemEnv.getHtmlLabelName(1825,user.getLanguage())%></a>
          </td>
        </tr>
-->
<%}%>

      <tr class= Spacing> 
     <td><a href="/hrm/employee/EmployeeInfoMaintenance.jsp"><%=SystemEnv.getHtmlLabelName(6137,user.getLanguage())%></a></td>
        </tr>

        <tr class= Spacing> 
          <td></td>
        </tr>
<%}%>        
        </TBODY> 
      </TABLE>
<br>
       <TABLE class=viewForm width="100%">
        <TBODY> 
<%if(HrmListValidate.isValidate(9)){%>      
<%if(software.equals("ALL") || software.equals("HRM")){%>
        <TR class=Title> 
          <TH><%=SystemEnv.getHtmlLabelName(6133,user.getLanguage())%></TH>
        </TR>
        <TR class= Spacing> 
          <TD class=Sep1>&nbsp;</TD>
        </TR>
        <tr class= Spacing> 
          <td> 
            <a href="/hrm/career/usedemand/HrmUseDemand.jsp"><%=SystemEnv.getHtmlLabelName(6131,user.getLanguage())%></a>/ 
            <a href="/hrm/career/careerplan/HrmCareerPlan.jsp"><%=SystemEnv.getHtmlLabelName(6132,user.getLanguage())%></a>/ 
            <a href="/hrm/career/HrmCareerInvite.jsp"><%=SystemEnv.getHtmlLabelName(366,user.getLanguage())%></a> </td>
        </tr>
        <tr class= Spacing> 
          <td> <a href="/hrm/career//HrmCareerApply.jsp"><%=SystemEnv.getHtmlLabelName(16251,user.getLanguage())%></a>/ 
            <a href="/hrm/career/HrmCareerManager.jsp"><%=SystemEnv.getHtmlLabelName(6133,user.getLanguage())%></a> </td>
        </tr>
        <tr class= Spacing> 
          <td> <a href="/pweb/index.htm"><%=SystemEnv.getHtmlLabelName(15719,user.getLanguage())%></a> </td>
        </tr>
<%}%>
<%}%>         
        </TBODY> 
      </TABLE>      
	  <br>
      <TABLE class=viewForm width="100%">
        <TBODY> 
<%if(HrmListValidate.isValidate(5)){%>         

        <TR class=Title> 
          <TH>
            <%if(software.equals("ALL") || software.equals("HRM")){%>
                <%=SystemEnv.getHtmlLabelName(16252,user.getLanguage())%> 
            <%}else{%>
                <%=SystemEnv.getHtmlLabelName(16253,user.getLanguage())%>
            <%}%>
          </TH>
        </TR>
        <TR class= Spacing> 
          <TD class=Sep1>&nbsp;</TD>
        </TR>
        <!-- 原有非一致工作时间 -->
    <%if(software.equals("ALL") || software.equals("HRM")){%>        
        <TR> 
          <TD>
            <A href="/hrm/schedule/HrmScheduleDiff.jsp"><%=SystemEnv.getHtmlLabelName(6139,user.getLanguage())%></A>/
            <A href="/hrm/schedule/HrmScheduleMaintance.jsp"><%=SystemEnv.getHtmlLabelName(6138,user.getLanguage())%></A>
          </TD>
        </TR>
    <%}%>        
        <TR> 
          <TD>
             <A href="/hrm/schedule/HrmDefaultScheduleList.jsp"><%=SystemEnv.getHtmlLabelName(16254,user.getLanguage())%></A>/       
    
    <%if(software.equals("ALL") || software.equals("HRM")){%>             
             <A href="/hrm/schedule/HrmArrangeShiftList.jsp"><%=SystemEnv.getHtmlLabelName(16255,user.getLanguage())%></A>/
             <A href="/hrm/schedule/HrmArrangeShiftMaintance.jsp"><%=SystemEnv.getHtmlLabelName(16256,user.getLanguage())%></A>/       
    <%}%>             
             <A href="/hrm/schedule/HrmPubHoliday.jsp"><%=SystemEnv.getHtmlLabelName(370,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(371,user.getLanguage())%></A>
           </td>
        </TR> 
    <%if(software.equals("ALL") || software.equals("HRM")){%> 
         <TR> 
          <TD>
             <A href="/hrm/schedule/HrmTimecardUser.jsp"><%=SystemEnv.getHtmlLabelName(16257,user.getLanguage())%></A>/
             <A href="/hrm/schedule/HrmOutTimecard.jsp"><%=SystemEnv.getHtmlLabelName(16258,user.getLanguage())%></A>/       
             <A href="/hrm/schedule/HrmInTimecard.jsp"><%=SystemEnv.getHtmlLabelName(16259,user.getLanguage())%></A>/
           </td>
        </TR>
    <%}%>
    <%if(software.equals("ALL") || software.equals("HRM")){%> 
         <TR> 
          <TD>
             <A href="/hrm/schedule/HrmWorkTimeWarpList.jsp"><%=SystemEnv.getHtmlLabelName(16675, user.getLanguage())%></A>/
                   
             
           </td>
        </TR>
    <%}%>
<%}%> 
        </TBODY> 
      </TABLE>
      
     <br>
      <TABLE class=viewForm width="100%">
        <TBODY> 
<%if(HrmListValidate.isValidate(4)){%>         
<%if(software.equals("ALL") || software.equals("HRM")){%>
        <TR class=Title> 
          <TH><%=SystemEnv.getHtmlLabelName(16260,user.getLanguage())%></TH>
        </TR>
        <TR class= Spacing> 
          <TD class=Sep1>&nbsp;</TD>
        </TR>
        <tr class= Spacing> 
          <td><a 
            href="/docs/mouldfile/DocMould.jsp?urlfrom=hr"><%=SystemEnv.getHtmlLabelName(15786,user.getLanguage())%></a></td>
        </tr>
        <tr class= Spacing> 
          <td><a 
            href="/hrm/contract/contracttype/HrmContractType.jsp"><%=SystemEnv.getHtmlLabelName(6158,user.getLanguage())%></a></td>
        </tr>
        <tr class= Spacing> 
          <td><a 
            href="/hrm/contract/contract/HrmContract.jsp"><%=SystemEnv.getHtmlLabelName(16260,user.getLanguage())%></a></td>
        </tr>
<%}%>
<%}%>        
        </TBODY> 
      </TABLE>
     
      
    </TD>
    
    <TD></TD>
    <TD vAlign=top>
      
      <TABLE class=viewForm width="100%">
        <TBODY> 
<%if(HrmListValidate.isValidate(3)){%>         
        <TR class=Title> 
          <TH><%=SystemEnv.getHtmlLabelName(16261,user.getLanguage())%></TH>
        </TR>
        <TR class= Spacing> 
          <TD class=Sep1>&nbsp;</TD>
        </TR>
        <TR> 
          <TD> <a href="/hrm/jobcall/HrmJobCall.jsp"><%=SystemEnv.getHtmlLabelName(806,user.getLanguage())%></a> 
            <%if(software.equals("ALL") || software.equals("HRM")){%>
            / <a href="/hrm/speciality/HrmSpeciality.jsp"><%=SystemEnv.getHtmlLabelName(803,user.getLanguage())%></a> 
            / <a href="/hrm/educationlevel/HrmEduLevel.jsp"><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%></a> 
<!--            / <a href="/hrm/competency/HrmCompetency.jsp"><%=SystemEnv.getHtmlLabelName(384,user.getLanguage())%></a> -->
            / <a href="/hrm/usekind/HrmUseKind.jsp"><%=SystemEnv.getHtmlLabelName(804,user.getLanguage())%></a> 
          </TD>
        </TR>
        <!--
        <tr class= Spacing> 
          <td> <a href="/hrm/tools/HrmTrainType.jsp"><%=SystemEnv.getHtmlLabelName(807,user.getLanguage())%></a> 
            / <a href="/hrm/tools/HrmRewardsType.jsp"><%=SystemEnv.getHtmlLabelName(808,user.getLanguage())%></a> 
            / <a href="/hrm/tools/HrmOtherInfoType.jsp"><%=SystemEnv.getHtmlLabelName(375,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></a> 
        -->            
            <%}%>
         <!--   
          </td>
        </tr>
        -->
        <%if(software.equals("ALL") || software.equals("HRM")){%>
        <tr class= Spacing> 
          <td> <a href="/base/ffield/ListHrmResourceFreeField.jsp"><%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%></a> 
            / <a href="/hrm/tools/HrmValidate.jsp"><%=SystemEnv.getHtmlLabelName(6002,user.getLanguage())%></a> 
            / <a href="/hrm/tools/Hrmdsporder.jsp"><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></a> </td>
        </tr>
        <%}%>
        </TBODY> 
<%}%>           
      </TABLE>
	  <br>
<%if(software.equals("ALL") || software.equals("HRM")){%>	
      <%if(HrmListValidate.isValidate(6)){%>
      <TABLE class=viewForm width="100%">
        <TBODY> 
        <TR class=Title> 
          <TH><%=SystemEnv.getHtmlLabelName(2117,user.getLanguage())%></TH>
        </TR>
        <TR class= Spacing> 
          <TD class=Sep1>&nbsp;</TD>
        </TR>
        <!-- 预算暂时去掉
        <tr class= Spacing> 
          <td><a 
            href="/fna/budget/FnaBudget.jsp"><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></a></td>
        </tr>
        -->
        <!-- 原有工资类型
        <tr class= Spacing> 
          <td><a 
            href="/hrm/finance/HrmSalaryComponent.jsp"><%=SystemEnv.getHtmlLabelName(189,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(387,user.getLanguage())%></a>/<a 
            href="/hrm/finance/HrmSalaryComponentTypes.jsp"><%=SystemEnv.getHtmlLabelName(388,user.getLanguage())%></a></td>
        </tr>
        -->
        <tr class= Spacing> 
          <td>
          <a href="/hrm/finance/salary/HrmSalaryItem.jsp"><%=SystemEnv.getHtmlLabelName(16262,user.getLanguage())%></a>
          / <a href="/hrm/finance/bank/HrmBankList.jsp"><%=SystemEnv.getHtmlLabelName(15812,user.getLanguage())%></a>
          </td>
        </tr>
        <tr class= Spacing> 
          <td>
          <a href="/hrm/finance/salary/HrmSalaryManage.jsp"><%=SystemEnv.getHtmlLabelName(16263,user.getLanguage())%></a>
          <!-- / <a href="/hrm/finance/bank/HrmBankList.jsp">薪酬分析</a> -->
          </td>
        </tr>
        </TBODY> 
      </TABLE>
      <%}%>
      <%}%>
	<br>
      <TABLE class=viewForm width="100%">
        <TBODY> 
<%if(HrmListValidate.isValidate(7)){%>     
<%if(software.equals("ALL") || software.equals("HRM")){%>
        <TR class=Title> 
          <TH><%=SystemEnv.getHtmlLabelName(16065,user.getLanguage())%></TH>
        </TR>
        <TR class= Spacing> 
          <TD class=Sep1>&nbsp;</TD>
        </TR>
        <tr class= Spacing> 
          <td><a 
            href="/hrm/award/HrmAwardType.jsp"><%=SystemEnv.getHtmlLabelName(6099,user.getLanguage())%></a>/<a 
            href="/hrm/award/HrmAward.jsp"><%=SystemEnv.getHtmlLabelName(6100,user.getLanguage())%></a>
          </td>
        </tr>
        <tr>
          <td>  
          <a  href="/hrm/check/HrmCheckKind.jsp"><%=SystemEnv.getHtmlLabelName(6118,user.getLanguage())%></a>/<a href="/hrm/check/HrmCheckItem.jsp"><%=SystemEnv.getHtmlLabelName(6117,user.getLanguage())%></a>/<a href="/hrm/actualize/HrmCheckInfo.jsp"><%=SystemEnv.getHtmlLabelName(6124,user.getLanguage())%></a>

          </td>
        </tr>
<%}%>
<%}%>        
        </TBODY> 
      </TABLE>
      <br>
      <TABLE class=viewForm width="100%">
        <TBODY> 
<%if(HrmListValidate.isValidate(8)){%>                
<%if(software.equals("ALL") || software.equals("HRM")){%>
        <TR class=Title> 
          <TH><%=SystemEnv.getHtmlLabelName(16264,user.getLanguage())%></TH>
        </TR>
        <TR class= Spacing> 
          <TD class=Sep1>&nbsp;</TD>
        </TR>
        <tr class= Spacing> 
          <td> <a href="/hrm/train/traintype/HrmTrainType.jsp"><%=SystemEnv.getHtmlLabelName(6130,user.getLanguage())%></a>/ 
               <a href="/hrm/train/trainlayout/HrmTrainLayout.jsp"><%=SystemEnv.getHtmlLabelName(6128,user.getLanguage())%></a>/ 
	       <a href="/hrm/train/trainresource/HrmTrainResource.jsp"><%=SystemEnv.getHtmlLabelName(15879,user.getLanguage())%></a>
		  </td>
        </tr>
        <tr class= Spacing> 
          <td> 
            <a href="/hrm/train/trainplan/HrmTrainPlan.jsp"><%=SystemEnv.getHtmlLabelName(6156,user.getLanguage())%></a>/		    
            <a href="/hrm/train/train/HrmTrain.jsp"><%=SystemEnv.getHtmlLabelName(6136,user.getLanguage())%></a> </td>
        </tr>
<%}%>
<%}%>         
        </TBODY> 
      </TABLE>

<br>
      <TABLE class=viewForm>
        <COLGROUP>
        <COL width="100%">
        <TBODY>
<%if(HrmListValidate.isValidate(10)){%>          
        <TR class=Title>
          <TH><%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())%></TH></TR>
        <TR class= Spacing>
          <TD class=Sep1></TD></TR>
        <TR>
          <TD><A 
            href="/meeting/Maint/ListMeetingType.jsp"><%=SystemEnv.getHtmlLabelName(2104,user.getLanguage())%></A></TD></TR>

             <TR>
          <TD><A 
            href="/meeting/Maint/MeetingRoom.jsp"><%=SystemEnv.getHtmlLabelName(780,user.getLanguage())%></A></TD>
            </TR>
<%}%>
		</TBODY>
	  </TABLE>      
    </TD></TR>
   </TBODY></TABLE>
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
 <script language=javascript>
function changetype(){
    if(document.all("mainttype").value=="S") location = "/system/SystemMaintenance.jsp?mainttype=S";
    if(document.all("mainttype").value=="W") location = "/workflow/WFMaintenance.jsp?mainttype=W";
    if(document.all("mainttype").value=="D") location = "/docs/DocMaintenance.jsp?mainttype=D";
    if(document.all("mainttype").value=="H") location = "/hrm/HrmMaintenance.jsp?mainttype=H";
    if(document.all("mainttype").value=="C") location = "/CRM/CRMMaintenance.jsp?mainttype=C";
    if(document.all("mainttype").value=="R") location = "/proj/ProjMaintenance.jsp?mainttype=R";
    if(document.all("mainttype").value=="F") location = "/fna/FnaMaintenance.jsp?mainttype=F";
    if(document.all("mainttype").value=="I") location = "/cpt/CptMaintenance.jsp?mainttype=I";
}
	</script>
   </BODY>
   </HTML>