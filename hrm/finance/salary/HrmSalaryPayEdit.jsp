
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%
if(!HrmUserVarify.checkUserRight("HrmResourceComponentEdit:Edit", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SalaryComInfo" class="weaver.hrm.finance.SalaryComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="SalaryManager" class="weaver.hrm.finance.SalaryManager" scope="page" />
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />

<%
String currentdate = Util.null2String(request.getParameter("currentdate"));
String payid = Util.null2String(request.getParameter("payid"));

String departmentid = Util.null2String(request.getParameter("departmentid"));   // 部门
String jobactivityid = Util.null2String(request.getParameter("jobactivityid")); // 职务
String jobtitle = Util.null2String(request.getParameter("jobtitle"));       // 岗位
String resourceid = Util.null2String(request.getParameter("resourceid"));       // 人力资源
String status = Util.null2String(request.getParameter("status"));       // 人力资源状态

if( status.equals("") ) status = "8" ;

String sqlwhere="";
if( !departmentid.equals("") ){
    sqlwhere+=" and departmentid = " + departmentid;
}
if( !jobactivityid.equals("") ){
    sqlwhere+=" and jobtitle in ( select id from HrmJobTitles where jobactivityid = " + jobactivityid + " ) " ;
}
if( !jobtitle.equals("") ){
    sqlwhere+=" and jobtitle = " + jobtitle;
}
if( !resourceid.equals("") ){
    sqlwhere+=" and id = " + resourceid;
}
if( !status.equals("9") ) {
    if( status.equals("8") )
        sqlwhere+=" and (status = 0 or status = 1 or status = 2 or status = 3) " ;
    else 
        sqlwhere+=" and status = " + status ;
}

String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(503,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/finance/salary/HrmSalaryPay.jsp?currentdate="+currentdate+"&departmentid="+departmentid+"&jobactivityid="+jobactivityid+"&jobtitle="+jobtitle+"&resourceid="+resourceid+"&status="+status+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
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
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<form name=frmmain method=post action="HrmSalaryPayEdit.jsp">
<input class=inputstyle type="hidden" name="method" value="changepay">
<input class=inputstyle type="hidden" name="needref" value="0">
<input class=inputstyle type="hidden" name="payid" value="<%=payid%>">
<input class=inputstyle type="hidden" name="currentdate" value="<%=currentdate%>">
<table class=Viewform>
  <COLGROUP><COL width="10%"><COL width="39%"><COL width="2%"><COL width="10%"><COL width="39%">
      <TBODY> 
      <TR class=Title colspan=5> 
        <TH><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH>
      </TR>
      <TR class=Spacing>
        <TD class=Line1 colspan=5></TD>
      </TR>
      <TR>
        <TD><%=SystemEnv.getHtmlLabelName(15849,user.getLanguage())%></TD>
          <TD class=Field>
              <BUTTON class=calendar type="button" id=SelectDate onclick=getcurrentdate()></BUTTON>&nbsp;
              <SPAN id=currentdatespan style="FONT-SIZE: x-small"><%=currentdate%></SPAN>
              <input class=inputstyle type="hidden" name="currentdate" value=<%=currentdate%>>
          </TD>
          <TD>&nbsp;</TD>
        <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
        <TD class=field>
          <button class=Browser id=SelectDeparment onClick="onShowDepartment(departmentspan,departmentid)"></button> 
          <span class=InputStyle id=departmentspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></span> 
		  <input class=inputstyle id=departmentid type=hidden name=departmentid value="<%=departmentid%>">
        </TD>
      </TR>
      <TR><TD class=Line colSpan=6></TD></TR> 
      <TR> 
        <TD><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></TD>
        <TD class=field> 
          <BUTTON class=Browser onClick="onShowJobActivity(jobactivityspan,jobactivityid)"></BUTTON>  <span class=InputStyle id=jobactivityspan>
           <%=Util.toScreen(JobActivitiesComInfo.getJobActivitiesname(jobactivityid), user.getLanguage())%>
          </span> 
          <input class=inputstyle id=jobactivityid type=hidden name=jobactivityid value="<%=jobactivityid%>">
        </TD>
        <TD>&nbsp;</TD>
        <TD><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TD>
        <TD class=field>
          <BUTTON class=Browser id=SelectJobTitle onclick="onShowJobtitle(jobtitlespan,jobtitle)"></BUTTON> 
          <SPAN id=jobtitlespan><%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobtitle),user.getLanguage())%></SPAN> 
          <input class=inputstyle id=jobtitle type=hidden name=jobtitle value="<%=jobtitle%>">
        </TD>
      </TR>
      <TR><TD class=Line colSpan=6></TD></TR> 
      <TR>
        <TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
        <TD class=field> 
          <button class=browser onClick="onShowResource(resourceidspan,resourceid)"></button>
          <span id=resourceidspan>
          <%=Util.toScreen(ResourceComInfo.getResourcename(""+resourceid),user.getLanguage())%>
          </span>
          <input class=inputstyle type=hidden name=resourceid value="<%=resourceid%>">
        </TD>
        <TD>&nbsp;</TD>
         <TD><%=SystemEnv.getHtmlLabelName(15842,user.getLanguage())%></TD>
         <TD class=Field> 
          <SELECT class=InputStyle id=status name=status>
           <OPTION value="9" <% if(status.equals("9")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>                   
           <OPTION value="0" <% if(status.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></OPTION>
           <OPTION value="1" <% if(status.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></OPTION>
           <OPTION value="2" <% if(status.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></OPTION>
           <OPTION value="3" <% if(status.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></OPTION>
           <OPTION value="4" <% if(status.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></OPTION>
           <OPTION value="5" <% if(status.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></OPTION>
           <OPTION value="6" <% if(status.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></OPTION>
           <OPTION value="7" <% if(status.equals("7")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></OPTION>
           <OPTION value="8" <% if(status.equals("8")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%></OPTION>                   
         </SELECT>
         </TD>
        </TR>
      <TR><TD class=Line colSpan=6></TD></TR> 
      </TBODY>
</table>
<br>
<TABLE class=ListStyle cellspacing=1 >
  <TBODY>
  <tr class=Header>
  <TH width="10%" rowspan=2 style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
  <TH width="10%" rowspan=2 style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TH>
   <% 
    while(SalaryComInfo.next()) {
        String itemname = Util.toScreen(SalaryComInfo.getSalaryname(),user.getLanguage()) ;
        String itemtype = Util.null2String(SalaryComInfo.getSalaryItemtype()) ;
        if( !itemtype.equals("2") ) {
   %>
   <TH width="10%" rowspan=2 style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><%=itemname%></TH>
   <%   } else { %>
   <TH colspan=2 style="TEXT-ALIGN:center"><%=itemname%></TH>
   <%   }
    }
   %>
  </tr>
  <tr class=Header>
   <% 
    SalaryComInfo.setTofirstRow() ;
    while(SalaryComInfo.next()) {
        String itemtype = Util.null2String(SalaryComInfo.getSalaryItemtype()) ;
        if( !itemtype.equals("2") ) continue ;
   %>
   <TH width="5%" style="TEXT-ALIGN:center"><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%></TH> 
   <TH width="5%" style="TEXT-ALIGN:center"><%=SystemEnv.getHtmlLabelName(1851,user.getLanguage())%></TH> 
   <%
    }
   %>
   </tr>
   <TR class=Line><TD colspan="12" ></TD></TR> 
   <%
    ArrayList resourceitems = new ArrayList() ;
    ArrayList salarys = new ArrayList() ;

    RecordSet.executeSql( "select itemid , hrmid, salary from HrmSalaryPaydetail where payid = " + payid );
    while( RecordSet.next() ) {
        String itemid = Util.null2String( RecordSet.getString("itemid") ) ;
        String hrmid = Util.null2String( RecordSet.getString("hrmid") ) ;
        String salary = "" + Util.getDoubleValue( RecordSet.getString("salary") , 0 ) ;
        resourceitems.add( hrmid + "_" + itemid ) ;
        salarys.add( salary ) ;
    }

    // RecordSet.executeSql( " select id , jobtitle from HrmResource where status !='4' and status !='7' order by departmentid , id " );  暂时去掉状态， 可以对所有人进行编辑
    
    RecordSet.executeSql( " select id , jobtitle from HrmResource where id >0 " + sqlwhere + " order by departmentid , id " );

    boolean isLight = false;
    while(RecordSet.next()) {
        String resourceidrs = Util.null2String(RecordSet.getString("id")) ;
        String jobtitlers = Util.null2String(RecordSet.getString("jobtitle")) ;
        isLight = !isLight ;
    %>
  <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
  <td><nobr><%=Util.toScreen(ResourceComInfo.getResourcename(""+resourceidrs),user.getLanguage())%></td>
      <td><nobr><%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobtitlers),user.getLanguage())%></td>
  <%
        SalaryComInfo.setTofirstRow() ;
        while(SalaryComInfo.next()) {
            String itemid = Util.null2String(SalaryComInfo.getSalaryItemid()) ;
            String itemtype = Util.null2String(SalaryComInfo.getSalaryItemtype()) ;
            String salary = "" ;
            String personsalary = "" ;
            String companysalary = "" ;

            if( !itemtype.equals("2") ) {
                int salaryindex = resourceitems.indexOf( resourceidrs + "_" + itemid ) ;
                if( salaryindex != -1) {
                    salary = (String) salarys.get(salaryindex) ;
                    if( Util.getDoubleValue(salary,0) == 0 ) salary = "" ;
                }
   %> 
       <td><INPUT class=InputStyle maxLength=50 size=10 name="<%=resourceidrs%>_<%=itemid%>" onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)' value="<%=salary%>">
       <input class=inputstyle type=hidden name="old_<%=resourceidrs%>_<%=itemid%>" value="<%=salary%>">
       </td>
<%           } else {
                int salaryindex = resourceitems.indexOf( resourceidrs + "_" + itemid+"_1" ) ;
                if( salaryindex != -1) {
                    personsalary = (String) salarys.get(salaryindex) ;
                    if( Util.getDoubleValue(personsalary,0) == 0 ) personsalary = "" ;
                }  
                salaryindex = resourceitems.indexOf( resourceidrs + "_" + itemid+"_2" ) ;
                if( salaryindex != -1) {
                    companysalary = (String) salarys.get(salaryindex) ;
                    if( Util.getDoubleValue(companysalary,0) == 0 ) companysalary = "" ;
                }  
   %>
       <td><INPUT class=InputStyle maxLength=50 size=10 name="<%=resourceidrs%>_<%=itemid%>_1" onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)' value="<%=personsalary%>">
       <input class=inputstyle type=hidden name="old_<%=resourceidrs%>_<%=itemid%>_1" value="<%=personsalary%>"></td>
       <td><INPUT class=InputStyle maxLength=50 size=10 name="<%=resourceidrs%>_<%=itemid%>_2" onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)' value="<%=companysalary%>">
       <input class=inputstyle type=hidden name="old_<%=resourceidrs%>_<%=itemid%>_2" value="<%=companysalary%>"></td>
<%           }     
        }
   %>
   </tr>
   <%}%>
  </TBODY>
 </TABLE>
</form>
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
function doSubmit(){
    if( confirm("<%=SystemEnv.getHtmlLabelName(15853,user.getLanguage())%>") ) {
        document.frmmain.needref.value = "1" ;
    }
    document.frmmain.action="HrmSalaryOperation.jsp" ;
    document.frmmain.submit() ;
}
function submitData() {
 frmmain.submit();
}
</script>
</BODY>
</HTML>