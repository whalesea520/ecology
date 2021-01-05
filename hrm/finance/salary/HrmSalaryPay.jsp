
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.general.MathUtil,
                 weaver.file.*" %>
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
<jsp:useBean id="HrmKqSystemComInfo" class="weaver.hrm.schedule.HrmKqSystemComInfo" scope="page" />
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>

<%
//generate excel report,xiaofeng
ExcelFile.init ();
   String filename = SystemEnv.getHtmlLabelName(503,user.getLanguage());
   ExcelFile.setFilename(""+filename) ;
   // 下面建立一个头部的样式, 我们系统中的表头都采用这个样式!
   ExcelStyle es = ExcelFile.newExcelStyle("Header") ;
   es.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
   es.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
   es.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
   es.setAlign(ExcelStyle.WeaverHeaderAlign) ;
   
   ExcelStyle es1 = ExcelFile.newExcelStyle("Bold") ;
   es1.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
   es1.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
   es1.setAlign(ExcelStyle.ALIGN_LEFT) ;
   
   ExcelStyle es2 = ExcelFile.newExcelStyle("Total") ;
   es2.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
   es2.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
   es2.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
   es2.setAlign(ExcelStyle.ALIGN_RIGHT) ;

   ExcelSheet et = ExcelFile.newExcelSheet(""+filename) ;

   // 下面设置每一列的宽度, 如果不设置, 将按照excel默认的宽度
   et.addColumnwidth(6000) ;
   et.addColumnwidth(6000) ;
   et.addColumnwidth(6000) ;
   et.addColumnwidth(6000) ;
   ExcelRow er = null ;
   er = et.newExcelRow() ;

   //end


String currentdate = Util.null2String(request.getParameter("currentdate"));

String isself = Util.null2String(request.getParameter("isself"));
Calendar thedate = Calendar.getInstance ();
Calendar thedate1 = Calendar.getInstance ();

if(currentdate.equals("")){
    currentdate = Util.add0(thedate.get(thedate.YEAR), 4) +"-"+
                         Util.add0(thedate.get(thedate.MONTH) + 1, 2) ;
}

int salaryyear = Util.getIntValue(currentdate.substring(0 , 4)) ;
int salarymonth = Util.getIntValue(currentdate.substring(5 , 7)) ;
int salaryendday = Util.getIntValue(HrmKqSystemComInfo.getSalaryenddate(),31) ;

thedate.set( salaryyear , salarymonth-1, salaryendday) ;
thedate1.set( salaryyear , salarymonth-1, 1) ;
if(thedate.get(Calendar.MONTH)!= thedate1.get(Calendar.MONTH)) {
    thedate.set( salaryyear , salarymonth, 1) ;
    thedate.add(Calendar.DATE , -1) ;
}

String salaryenddate =  Util.add0(thedate.get(Calendar.YEAR) , 4) + "-" +
                Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" +
                Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ;

thedate.set( salaryyear , salarymonth-2, salaryendday) ;
thedate1.set( salaryyear , salarymonth-2, 1) ;
if(thedate.get(Calendar.MONTH)!= thedate1.get(Calendar.MONTH)) {
    thedate.set( salaryyear , salarymonth-1, 1) ;
}
else {
    thedate.add(Calendar.DATE , 1) ;
}
String salarybegindate =  Util.add0(thedate.get(Calendar.YEAR) , 4) + "-" +
                Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" +
                Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ;

int payid = 0 ;
int isvalidate = 0 ;
RecordSet.executeSql( "select id , isvalidate from HrmSalaryPay where paydate = '" + currentdate + "'" );
if( RecordSet.next() ) {
    payid = Util.getIntValue( RecordSet.getString("id") ,0 ) ;
    isvalidate = Util.getIntValue( RecordSet.getString("isvalidate") ,0 ) ;
}

String departmentid = Util.null2String(request.getParameter("departmentid"));   // 部门
String jobactivityid = Util.null2String(request.getParameter("jobactivityid")); // 职务
String jobtitle = Util.null2String(request.getParameter("jobtitle"));       // 岗位
String resourceid = Util.null2String(request.getParameter("resourceid"));       // 人力资源
String status = Util.null2String(request.getParameter("status"));       // 人力资源状态
String sqlwhere="";

if( status.equals("") ) status = "8" ;

if(isself.equals("1")) {

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
}

%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(503,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if( payid == 0 ){
RCMenu += "{"+SystemEnv.getHtmlLabelName(15845,user.getLanguage())+",javascript:onCreate(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}else {
RCMenu += "{"+SystemEnv.getHtmlLabelName(15846,user.getLanguage())+",javascript:onReCreate(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15847,user.getLanguage())+",javascript:onChange(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

/* 取消打印部分的菜单
RCMenu += "{"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+SystemEnv.getHtmlLabelName(524,user.getLanguage())+",javascript:onPrintCurrent(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+SystemEnv.getHtmlLabelName(332,user.getLanguage())+",javascript:onPrintAll(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+SystemEnv.getHtmlLabelName(524,user.getLanguage())+"2,javascript:onPrintCurrent2(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+SystemEnv.getHtmlLabelName(332,user.getLanguage())+"2,javascript:onPrintAll2(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
*/

if( isvalidate == 0 ) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(15848,user.getLanguage())+",javascript:onSend(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
}
//added by xiaofeng
RCMenu += "{Excel,/weaver/weaver.file.ExcelOut,ExcelOut} " ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",HrmSalaryManage.jsp?departmentid="+departmentid+"&jobactivityid="+jobactivityid+"&jobtitle="+jobtitle+"&resourceid="+resourceid+"&status="+status+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>

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
<form name=frmmain method=post action="HrmSalaryPay.jsp">
<input class=inputstyle type="hidden" name="method" value="">
<input class=inputstyle type="hidden" name="payid" value="<%=payid%>">
<input class=inputstyle type="hidden" name="salarybegindate" value="<%=salarybegindate%>">
<input class=inputstyle type="hidden" name="salaryenddate" value="<%=salaryenddate%>">
<input type="hidden" name="isself" value="1">

<table class=Viewform>
  <COLGROUP><COL width="10%"><COL width="39%"><COL width="2%"><COL width="10%"><COL width="39%">
      <TBODY>
      <TR class=Title colspan=5>
        <TH><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH>
        <% er.addStringValue(SystemEnv.getHtmlLabelName(324,user.getLanguage()),"Bold"); %>
      </TR>
      <TR class=Spacing>
        <TD class=Line1 colspan=5></TD>
      </TR>
      <TR>
        <TD><%=SystemEnv.getHtmlLabelName(15849,user.getLanguage())%></TD>
          <TD class=Field>
              <BUTTON class=calendar type="button" id=SelectDate onclick=getSdDate(currentdatespan,currentdate)></BUTTON>&nbsp;
              <SPAN id=currentdatespan style="FONT-SIZE: x-small"><%=currentdate%></SPAN>
              <input class=inputstyle type="hidden" name="currentdate" value=<%=currentdate%>>
          </TD>
          <TD>&nbsp;</TD>
        <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
        <TD class=field>
          <button class=Browser id=SelectDeparment onClick="onShowDepartment(departmentspan,departmentid)"></button>
          <span class=inputstyle id=departmentspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></span>
		  <input class=inputstyle id=departmentid type=hidden name=departmentid value="<%=departmentid%>">
        </TD>
        <% //xiaofeng
           ExcelRow er1=et.newExcelRow();
           er1.addStringValue(SystemEnv.getHtmlLabelName(15849,user.getLanguage())+":","Bold");
           er1.addStringValue(currentdate);
           er1.addStringValue(SystemEnv.getHtmlLabelName(124,user.getLanguage())+":","Bold");
           er1.addStringValue(Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage()));
        %>
      </TR>
      <TR><TD class=Line colSpan=6></TD></TR>
      <TR>
        <TD><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></TD>
        <TD class=field>
          <BUTTON class=Browser onClick="onShowJobActivity(jobactivityspan,jobactivityid)"></BUTTON>  <span class=inputstyle id=jobactivityspan>
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
        <% //xiaofeng
           ExcelRow er2=et.newExcelRow();
           er2.addStringValue(SystemEnv.getHtmlLabelName(1915,user.getLanguage())+":","Bold");
           er2.addStringValue(Util.toScreen(JobActivitiesComInfo.getJobActivitiesname(jobactivityid), user.getLanguage()));
           er2.addStringValue(SystemEnv.getHtmlLabelName(6086,user.getLanguage())+":","Bold");
           er2.addStringValue(Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobtitle),user.getLanguage()));
        %>
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
          <SELECT class=inputstyle id=status name=status>
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
         <% //xiaofeng
           ExcelRow er3=et.newExcelRow();
           er3.addStringValue(SystemEnv.getHtmlLabelName(179,user.getLanguage())+":","Bold");
           er3.addStringValue(Util.toScreen(ResourceComInfo.getResourcename(""+resourceid),user.getLanguage()));
           er3.addStringValue(SystemEnv.getHtmlLabelName(15842,user.getLanguage())+":","Bold");
           if(status.equals("9"))
           er3.addStringValue(SystemEnv.getHtmlLabelName(332,user.getLanguage()));
           if(status.equals("0"))
           er3.addStringValue(SystemEnv.getHtmlLabelName(15710,user.getLanguage()));
             if(status.equals("1"))
           er3.addStringValue(SystemEnv.getHtmlLabelName(15711,user.getLanguage()));
             if(status.equals("2"))
           er3.addStringValue(SystemEnv.getHtmlLabelName(480,user.getLanguage()));
             if(status.equals("3"))
           er3.addStringValue(SystemEnv.getHtmlLabelName(15844,user.getLanguage()));
             if(status.equals("4"))
           er3.addStringValue(SystemEnv.getHtmlLabelName(6094,user.getLanguage()));
             if(status.equals("5"))
           er3.addStringValue(SystemEnv.getHtmlLabelName(6091,user.getLanguage()));
             if(status.equals("6"))
           er3.addStringValue(SystemEnv.getHtmlLabelName(6092,user.getLanguage()));
             if(status.equals("7"))
           er3.addStringValue(SystemEnv.getHtmlLabelName(2245,user.getLanguage()));
             if(status.equals("8"))
           er3.addStringValue(SystemEnv.getHtmlLabelName(1831,user.getLanguage()));

        %>
        </TR>
       <TR><TD class=Line colSpan=6></TD></TR>
      </TBODY>
</table>
</form>
<br>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP><COL width="100%">
  <TBODY>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(503,user.getLanguage())%> (<%=salarybegindate%> ~ <%=salaryenddate%>) <%if( payid == 0 ){%><font color=red><%=SystemEnv.getHtmlLabelName(15850,user.getLanguage())%></font><%}%></TH>
    <% //xiaofeng
           ExcelRow er4=et.newExcelRow();
           er4.addStringValue(SystemEnv.getHtmlLabelName(503,user.getLanguage()),"Bold");
    %>
  </TR>
  </TABLE>
<TABLE class=ListStyle cellspacing=1 >
  <TBODY>
  <tr class=Header>
  <TH width="10%" rowspan=2 style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><nobr><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
  <TH width="10%" rowspan=2 style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><nobr><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TH>
  <% //xiaofeng
           ExcelRow er5=et.newExcelRow();
           er5.addStringValue(SystemEnv.getHtmlLabelName(195,user.getLanguage()),"Header");
           er5.addStringValue(SystemEnv.getHtmlLabelName(6086,user.getLanguage()),"Header");
    %>
   <%
    while(SalaryComInfo.next()) {
        et.addColumnwidth(6000) ;
        String itemname = Util.toScreen(SalaryComInfo.getSalaryname(),user.getLanguage()) ;
        String itemtype = Util.null2String(SalaryComInfo.getSalaryItemtype()) ;
        if( !itemtype.equals("2") ) {
   %>
   <TH width="10%" rowspan=2 style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><nobr><%=itemname%></TH>
   <%  er5.addStringValue(itemname,"Header");
        } else { %>
   <TH colspan=2 style="TEXT-ALIGN:center"><nobr><%=itemname%></TH>
   <% er5.addStringValue(itemname,"Header");
        }
    }
   %>
   

  </tr>
  <tr class=Header>
   <%
    //xiaofeng
    ExcelRow er6=et.newExcelRow();
    SalaryComInfo.setTofirstRow() ;
    while(SalaryComInfo.next()) {

        String itemtype = Util.null2String(SalaryComInfo.getSalaryItemtype()) ;
        if( !itemtype.equals("2") ) continue ;
   %>
   <TH width="5%" style="TEXT-ALIGN:center"><nobr><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%></TH>
   <TH width="5%" style="TEXT-ALIGN:center"><nobr><%=SystemEnv.getHtmlLabelName(1851,user.getLanguage())%></TH>
   <%
       er6.addStringValue(SystemEnv.getHtmlLabelName(6087,user.getLanguage()));
       er6.addStringValue(SystemEnv.getHtmlLabelName(1851,user.getLanguage()));
    }
   %>
   </tr>
   <%

       ArrayList colSumList = new ArrayList();
       boolean isBegin = true;
       int curColIndex = 0;
       double temD1 = 0.0;

    if(isself.equals("1")) {
        if( payid != 0 ) {
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

            RecordSet.executeSql( " select id , jobtitle from HrmResource where id >0 " + sqlwhere + " order by departmentid , id " );

            // 为了打印， 将工资设置到session 中
            session.setAttribute("weaversalarykey" , resourceitems) ;
            session.setAttribute("weaversalaryvalue" , salarys) ;
            session.setAttribute("weaversalarywhere" , sqlwhere) ;
            session.setAttribute("weaversalaryyear" , ""+salaryyear) ;
            session.setAttribute("weaversalarymonth" , ""+salarymonth) ;


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
                //xiaofeng
                ExcelRow ers=et.newExcelRow();
                ers.addStringValue(Util.toScreen(ResourceComInfo.getResourcename(""+resourceidrs),user.getLanguage()));
                ers.addStringValue(Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobtitlers),user.getLanguage()));


                SalaryComInfo.setTofirstRow() ;
                curColIndex = 0;
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
                            if( Util.getDoubleValue(salary,0) ==0 ) salary = "" ;
                        }
                        if(isBegin){
                            colSumList.add(new Double(salary+"0"));

                        }else{
                            //colSumList.set(curColIndex,new Double(((Double)(colSumList.get(curColIndex))).doubleValue() + Double.parseDouble(salary+"0")));
                            colSumList.set(curColIndex,new Double(MathUtil.add(((Double)(colSumList.get(curColIndex))).doubleValue() ,Double.parseDouble(salary+"0"))));

                            curColIndex ++;
                        }

   %>
       <td><nobr>
       <% if(itemtype.equals("5") || itemtype.equals("6") ) { %>
       <a href='HrmSalaryDiffPay.jsp?payid=<%=payid%>&resourceid=<%=resourceidrs%>&itemid=<%=itemid%>&currentdate=<%=currentdate%>'>
       <% } %>
       <%=salary%>
       <%
       //xiaofeng
       ers.addValue(salary); 
       if(itemtype.equals("5") || itemtype.equals("6") ) { %>
       </a>
       <%
       
       } %>
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

                        if(isBegin){
                            colSumList.add(new Double(personsalary+"0"));
                            colSumList.add(new Double(companysalary+"0"));

                        }else{
                            //colSumList.set(curColIndex, new Double(((Double)(colSumList.get(curColIndex))).doubleValue() + Double.parseDouble(personsalary+"0")));
                            colSumList.set(curColIndex,new Double(MathUtil.add(((Double)(colSumList.get(curColIndex))).doubleValue() ,Double.parseDouble(personsalary+"0"))));

                            curColIndex ++;
                            //colSumList.set(curColIndex, new Double(((Double)(colSumList.get(curColIndex))).doubleValue() + Double.parseDouble(companysalary+"0")));
                            colSumList.set(curColIndex,new Double(MathUtil.add(((Double)(colSumList.get(curColIndex))).doubleValue() ,Double.parseDouble(companysalary+"0"))));

                            curColIndex ++;
                        }

   %>
       <td><nobr><%=personsalary%></td>
       <td><nobr><%=companysalary%></td>
       <%
         ers.addValue(personsalary);
         ers.addValue(companysalary);
                    }

                }

   %>
   <!--added by xiaofeng -->
   <td><nobr></td>

   </tr>
   <%
                if(isBegin){
                    isBegin = false;
                }
            }
        }
   }
   %>

<tr class=Header>
  <TH width="10%"  style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><nobr><%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%></TH>
  <TH width="10%"  style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><nobr></TH>
   <%   
   //xiaofeng
        ExcelRow er_last=et.newExcelRow();
        er_last.addStringValue(SystemEnv.getHtmlLabelName(358,user.getLanguage()),"Header");
        er_last.addStringValue("","Header");
        
        curColIndex = 0;
        String viewName = "";
    while(SalaryComInfo.next()) {
        String itemtype = Util.null2String(SalaryComInfo.getSalaryItemtype()) ;
        if(colSumList != null && colSumList.size()>0){
            temD1 = ((Double)colSumList.get(curColIndex++)).doubleValue();
        }else{
            temD1 = 0;
        }
        if(temD1 != 0){
            viewName = String.valueOf(temD1);
        }else{
            viewName = "";
        }
        if(!viewName.equals(""))
        viewName=String.valueOf(MathUtil.round(Double.parseDouble(viewName),2));
        if( !itemtype.equals("2") ) {
   %>
   <TH width="10%" ><nobr><%=viewName%></TH>
   <%   
   er_last.addValue(viewName,"Total");
   } else { %>
   <TH width="5%" ><nobr><%=viewName%></TH>
   <%   er_last.addValue(viewName,"Total");
        if(colSumList != null && colSumList.size()>0){
            temD1 = ((Double)colSumList.get(curColIndex++)).doubleValue();
        }else{
            temD1 = 0;
        }
        if(temD1 != 0){
            viewName = String.valueOf(temD1);
        }else{
            viewName = "";
        }
   
   %>
   <TH width="5%" ><nobr><%=viewName%></TH>
   <%   
   er_last.addValue(viewName,"Total");
   }

    }

   %>
 
  </tr>
  </TBODY>
 </TABLE>
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


function onCreate(){
    frmmain.action="HrmSalaryCreate.jsp";
    frmmain.method.value="createpay";
    frmmain.submit();
}

function onReCreate(){
    if( confirm("<%=SystemEnv.getHtmlLabelName(15851,user.getLanguage())%>") ) {
        frmmain.action="HrmSalaryCreate.jsp";
        frmmain.method.value="createpay";
        frmmain.submit();
    }
}

function onChange(){
    frmmain.action="HrmSalaryPayEdit.jsp";
    frmmain.submit();
}

function onSend(){
    if( confirm("<%=SystemEnv.getHtmlLabelName(15852,user.getLanguage())%>") ) {
        frmmain.action="HrmSalaryOperation.jsp";
        frmmain.method.value="send";
        frmmain.submit();
    }
}
function submitData() {
 frmmain.submit();
}

function onPrintCurrent() {
    window.open("HrmSalaryPrint.jsp?printtype=1&printscrope=1&printdet=1","","width=300,height=250,scrollbars=no,resizable=yes") ;
}

function onPrintAll() {
    window.open("HrmSalaryPrint.jsp?printtype=1&printscrope=2&printdet=1","","width=300,height=250,scrollbars=no,resizable=yes") ;
}

function onPrintCurrent2() {
    window.open("HrmSalaryPrint.jsp?printtype=1&printscrope=1&printdet=2","","width=300,height=250,scrollbars=no,resizable=yes") ;
}

function onPrintAll2() {
    window.open("HrmSalaryPrint.jsp?printtype=1&printscrope=2&printdet=2","","width=300,height=250,scrollbars=no,resizable=yes") ;
}

</script>

<script language=vbs>
sub onShowResource(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
        if id(0)<> "" then
            spanname.innerHtml = id(1)
            inputname.value=id(0)
        else
            spanname.innerHtml = ""
            inputname.value=""
        end if
	end if
end sub

sub onShowDepartment(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&inputname.value)
	if (Not IsEmpty(id)) then
        if id(0)<> 0 then
            spanname.innerHtml = id(1)
            inputname.value=id(0)
        else
            spanname.innerHtml = ""
            inputname.value=""
        end if
	end if
end sub

sub onShowJobActivity(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobactivities/JobActivitiesBrowser.jsp")
	if Not isempty(id) then
        if id(0)<> 0 then
            spanname.innerHtml = id(1)
            inputname.value=id(0)
        else
            spanname.innerHtml = ""
            inputname.value=""
        end if
	end if
end sub

sub onShowJobtitle(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp")
	if (Not IsEmpty(id)) then
        if id(0)<> 0 then
            spanname.innerHtml = id(1)
            inputname.value=id(0)
        else
            spanname.innerHtml = ""
            inputname.value=""
        end if
	end if
end sub
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>