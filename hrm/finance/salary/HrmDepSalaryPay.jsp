
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.file.*" %>
<%@ page import="java.util.*" %>

<%
if(!HrmUserVarify.checkUserRight("HrmResourceComponentEdit:Edit", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SalaryComInfo" class="weaver.hrm.finance.SalaryComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SalaryManager" class="weaver.hrm.finance.SalaryManager" scope="page" />
<jsp:useBean id="HrmKqSystemComInfo" class="weaver.hrm.schedule.HrmKqSystemComInfo" scope="page" />
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<%
//xiaofeng
//generate excel report,xiaofeng
   ExcelFile.init ();
   String filename = SystemEnv.getHtmlLabelName(124,user.getLanguage())+SystemEnv.getHtmlLabelName(503,user.getLanguage());
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

/* 取消打印部分的菜单 
RCMenu += "{"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+",javascript:onPrintCurrent(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
*/

if( isvalidate == 0 ) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(15848,user.getLanguage())+",javascript:onSend(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
}
//added by xiaofeng
RCMenu += "{Excel,/weaver/weaver.file.ExcelOut,ExcelOut} " ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",HrmSalaryManage.jsp,_self} " ;
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
<form name=frmmain method=post action="HrmDepSalaryPay.jsp">
<input class=inputstyle type="hidden" name="method" value="">
<input class=inputstyle type="hidden" name="payid" value="<%=payid%>">
<input class=inputstyle type="hidden" name="salarybegindate" value="<%=salarybegindate%>">
<input class=inputstyle type="hidden" name="salaryenddate" value="<%=salaryenddate%>">
<input type="hidden" name="fromdepartment" value="1">

<table class=Viewform>
  <COLGROUP><COL width="10%"><COL width="90%">
    <TBODY> 
      <TR class=Title colspan=2> 
        <TH><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH>
      </TR>
      <TR class=Spacing>
        <TD class=Line1 colspan=2></TD>
      <% er.addStringValue(SystemEnv.getHtmlLabelName(324,user.getLanguage()),"Bold"); %>
      </TR>
      <TR>
        <TD><%=SystemEnv.getHtmlLabelName(15849,user.getLanguage())%></TD>
          <TD class=Field>
              <BUTTON class=calendar type="button" id=SelectDate onclick=getSdDate(currentdatespan,currentdate)></BUTTON>&nbsp;
              <SPAN id=currentdatespan style="FONT-SIZE: x-small"><%=currentdate%></SPAN>
              <input class=inputstyle type="hidden" name="currentdate" value=<%=currentdate%>>
          </TD>
          <% //xiaofeng
           ExcelRow er1=et.newExcelRow();
           er1.addStringValue(SystemEnv.getHtmlLabelName(15849,user.getLanguage())+":","Bold");
           er1.addStringValue(currentdate);
        %>
      </TR>
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
           ExcelRow er2=et.newExcelRow();
           er2.addStringValue(SystemEnv.getHtmlLabelName(503,user.getLanguage())+":","Bold");
           er2.addStringValue(salarybegindate+"~"+salaryenddate);
           
        %>
  </TR>
  </TABLE>
<TABLE class=ListStyle cellspacing=1 >
  <TBODY>
  <tr class=Header>
  <TH width="10%" rowspan=2 style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><nobr><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TH>
   <%
    ExcelRow er3=et.newExcelRow();
    er3.addStringValue(SystemEnv.getHtmlLabelName(124,user.getLanguage()),"Header"); 
    while(SalaryComInfo.next()) {
        et.addColumnwidth(6000) ;
        String itemname = Util.toScreen(SalaryComInfo.getSalaryname(),user.getLanguage()) ;
        String itemtype = Util.null2String(SalaryComInfo.getSalaryItemtype()) ;
        if( !itemtype.equals("2") ) {
   %>
   <TH width="10%" rowspan=2 style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><nobr><%=itemname%></TH>
   <%   
    er3.addStringValue(itemname,"Header");
   } else { %>
   <TH colspan=2 style="TEXT-ALIGN:center"><nobr><%=itemname%></TH>
   <%   
    er3.addStringValue(itemname,"Header");
   }
    }
   %>
  </tr>
  <tr class=Header>
   <%
    ExcelRow er4=et.newExcelRow();  
    SalaryComInfo.setTofirstRow() ;
    while(SalaryComInfo.next()) {
        String itemtype = Util.null2String(SalaryComInfo.getSalaryItemtype()) ;
        if( !itemtype.equals("2") ) continue ;
   %>
   <TH width="5%" style="TEXT-ALIGN:center"><nobr><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%></TH> 
   <TH width="5%" style="TEXT-ALIGN:center"><nobr><%=SystemEnv.getHtmlLabelName(1851,user.getLanguage())%></TH> 
   <%
    er4.addStringValue(SystemEnv.getHtmlLabelName(6087,user.getLanguage()),"Bold");
    er4.addStringValue(SystemEnv.getHtmlLabelName(1851,user.getLanguage()),"Bold");
    }
   %>
   </tr>
   <%
    if( payid != 0 ) {
        ArrayList resourceitems = new ArrayList() ;
        ArrayList salarys = new ArrayList() ;

        RecordSet.executeSql( "select a.itemid , b.departmentid, sum(a.salary) as salary from HrmSalaryPaydetail a, HrmResource b where a.hrmid = b.id and payid = " + payid + " group by a.itemid , b.departmentid ");
        while( RecordSet.next() ) {
            String itemid = Util.null2String( RecordSet.getString("itemid") ) ;
            String departmentid = Util.null2String( RecordSet.getString("departmentid") ) ;
            String salary = "" + Util.getDoubleValue( RecordSet.getString("salary") , 0 ) ;
            resourceitems.add( departmentid + "_" + itemid ) ;
            salarys.add( salary ) ;
        }

        RecordSet.executeSql( " select id from HrmDepartment order by showorder " );

        // 为了打印， 将工资设置到session 中
        session.setAttribute("weaversalarykey" , resourceitems) ;
        session.setAttribute("weaversalaryvalue" , salarys) ;
        session.setAttribute("weaversalaryyear" , ""+salaryyear) ;
        session.setAttribute("weaversalarymonth" , ""+salarymonth) ;

        boolean isLight = false;
        while(RecordSet.next()) {
            String departmentidrs = Util.null2String(RecordSet.getString("id")) ;
            isLight = !isLight ;
  %>
  <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
  <td><nobr><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentidrs),user.getLanguage())%></td>
  <%        
  //xiaofeng
                ExcelRow ers=et.newExcelRow();
                ers.addStringValue(Util.toScreen(DepartmentComInfo.getDepartmentname(departmentidrs),user.getLanguage()));
            
            SalaryComInfo.setTofirstRow() ;
            while(SalaryComInfo.next()) {
                String itemid = Util.null2String(SalaryComInfo.getSalaryItemid()) ;
                String itemtype = Util.null2String(SalaryComInfo.getSalaryItemtype()) ;
                String salary = "" ;
                String personsalary = "" ;
                String companysalary = "" ;

                if( !itemtype.equals("2") ) {
                    int salaryindex = resourceitems.indexOf( departmentidrs + "_" + itemid ) ;
                    if( salaryindex != -1) {
                        salary = (String) salarys.get(salaryindex) ;
                        if( Util.getDoubleValue(salary,0) ==0 ) salary = "" ;
                    }
   %> 
       <td><nobr>
       <%=salary%>
       </td>
   <%           
   ers.addValue(salary); 
   } else {
                    int salaryindex = resourceitems.indexOf( departmentidrs + "_" + itemid+"_1" ) ;
                    if( salaryindex != -1) {
                        personsalary = (String) salarys.get(salaryindex) ;
                        if( Util.getDoubleValue(personsalary,0) == 0 ) personsalary = "" ;
                    }  
                    salaryindex = resourceitems.indexOf( departmentidrs + "_" + itemid+"_2" ) ;
                    if( salaryindex != -1) {
                        companysalary = (String) salarys.get(salaryindex) ;
                        if( Util.getDoubleValue(companysalary,0) == 0 ) companysalary = "" ;
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
   </tr>
   <%   }
    }
   %>
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

function onPrintCurrent() {
    window.open("HrmSalaryPrint.jsp?printtype=2","","width=300,height=250,scrollbars=no,resizable=no") ;
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