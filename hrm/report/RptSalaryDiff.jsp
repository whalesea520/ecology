
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
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

<%
String deptid = Util.null2String(request.getParameter("deptid"));
String dept = DepartmentComInfo.getDepartmentname(deptid);
if(dept.equals(""))
	dept = "&nbsp;";
String resourceid = Util.null2String(request.getParameter("resourceid"));
String resource = "";
String tempids="";
if(resourceid.equals(""))
	resource = "&nbsp;";
else
{
	tempids = resourceid;
	do
	{
		int tempid = 0;
		int index = tempids.indexOf(',');
		if(index<0)
		{
			tempid = Util.getIntValue(tempids);
			tempids = "";
			resource += "<a href=/hrm/resource/HrmResource.jsp?id="+tempid+">"+ResourceComInfo.getResourcename(""+tempid)+"</a>";
		}
		else
		{
			tempid = Util.getIntValue(tempids.substring(0,index));
			tempids = tempids.substring(index+1);
			resource += "<a href=/hrm/resource/HrmResource.jsp?id="+tempid+">"+ResourceComInfo.getResourcename(""+tempid)+"</a>,&nbsp";
		}

	}while(!tempids.equals(""));
}

String currentdate = Util.null2String(request.getParameter("currentdate"));
if(currentdate.equals("")){
    Calendar today = Calendar.getInstance();
    currentdate = Util.add0(today.get(today.YEAR), 4) +"-"+
                         Util.add0(today.get(today.MONTH) + 1, 2) ;
}

int year = Util.getIntValue(currentdate.substring(0,4),1);
int month = Util.getIntValue(currentdate.substring(5),1);

month--;
if(month<1)
{
	year--;
	month = 12;
}
String comparedate = Util.add0(year,4) + "-" + Util.add0(month,2);

int payid = 0 ;
RecordSet.executeSql( "select id from HrmSalaryPay where paydate = '" + currentdate + "'" );
if( RecordSet.next() ) {
    payid = Util.getIntValue( RecordSet.getString("id") ,0 ) ;
}

int payido = 0 ;
RecordSet.executeSql( "select id from HrmSalaryPay where paydate = '" + comparedate + "'" );
if( RecordSet.next() ) {
    payido = Util.getIntValue( RecordSet.getString("id") ,0 ) ;
}
int colnums=0;
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(503,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps></DIV>
<form name=frmmain method=post action="RptSalaryDiff.jsp">
<DIV class=BtnBar>
    <BUTTON language=VBS class=BtnReset id=button1 accessKey=R name=button1 onclick="javascript:location.href='/hrm/report/HrmRp.jsp'"><U>R</U>-<%=SystemEnv.getHtmlLabelName(1290, user.getLanguage())%></BUTTON>
</DIV>
<table class=form>
  <colgroup>
  <col width="10%">
  <col width="20%">
  <col width="2%">
  <col width="10%">
  <col width="20%">
  <col width="2%">
  <col width="10%">
  <col width="26%">
  <TBODY> 
      <TR class=section> 
        <TH colspan=8><%=SystemEnv.getHtmlLabelNames("503,1025",user.getLanguage()) %></TH>
      </TR>
      <TR class=separator>
        <TD class=sep1 colspan=8></TD>
      </TR>
<TR>
  <TD><%=SystemEnv.getHtmlLabelName(445, user.getLanguage())%>－<%=SystemEnv.getHtmlLabelName(6076, user.getLanguage())%></TD>
  <TD class=Field>
      <BUTTON class=calendar id=SelectDate onclick=getcurrentdate()></BUTTON>&nbsp;
      <SPAN id=currentdatespan style="FONT-SIZE: x-small"><%=currentdate%></SPAN>
      <input type="hidden" name="currentdate" value=<%=currentdate%>>
  </TD>
  <TD>&nbsp;</TD>
  <TD><%=SystemEnv.getHtmlLabelName(124, user.getLanguage())%></TD>
  <TD class=Field>
      <BUTTON class=Browser id=SelectDepartment onclick=onShowDepartment()></BUTTON>&nbsp;
      <SPAN id=departmentspan style="FONT-SIZE: x-small"><%=dept%></SPAN>
      <input type="hidden" name="deptid" value=<%=deptid%>>
  </TD>
  <TD>&nbsp;</TD>
  <TD><%=SystemEnv.getHtmlLabelName(362, user.getLanguage())%></TD>
  <TD class=Field>
      <BUTTON class=Browser id=SelectResource onclick=onShowResourceID()></BUTTON>&nbsp;
      <SPAN id=resourceidspan style="FONT-SIZE: x-small"><%=resource%></SPAN>
      <input id=resourceid type="hidden" name="resourceid" value=<%=resourceid%>>
  </TD>
</TR>
</table>
</form>
<br>
<TABLE class=listshort>
  <COLGROUP><COL width="100%">
  <TBODY> 
  <TR class=section> 
    <TH><%=SystemEnv.getHtmlLabelName(503, user.getLanguage())%> <%if( payid == 0 ){%><font color=red><%=SystemEnv.getHtmlLabelName(15850, user.getLanguage())%></font><%} else if( payido == 0 ){%><font color=red><%=SystemEnv.getHtmlLabelName(129084, user.getLanguage())%></font><% }else{%></TH>
  </TR>
  <TR class=separator> 
    <TD class=sep1></TD>
  </TR>
</TABLE>
<TABLE class=ListShort>
  <TBODY>
  <tr class=Header>
  <TH width="3%" rowspan=2 style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><%=SystemEnv.getHtmlLabelName(413, user.getLanguage())%></TH>
  <TH width="7%" rowspan=2 style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><%=SystemEnv.getHtmlLabelName(6086, user.getLanguage())%></TH>
   <% 
    while(SalaryComInfo.next()) {
        String itemname = Util.toScreen(SalaryComInfo.getSalaryname(),user.getLanguage()) ;
        String itemtype = Util.null2String(SalaryComInfo.getSalaryItemtype()) ;
			colnums++;
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
			colnums++;

   %>
   <TH width="5%" style="TEXT-ALIGN:center"><%=SystemEnv.getHtmlLabelName(6087, user.getLanguage())%></TH> 
   <TH width="5%" style="TEXT-ALIGN:center"><%=SystemEnv.getHtmlLabelName(1851, user.getLanguage())%></TH> 
   <%
    }
   %>
   </tr>
   <%
    if( payid != 0 ) {
        ArrayList resourceitems = new ArrayList() ;
        ArrayList resourceitemso = new ArrayList() ;
        ArrayList salarys = new ArrayList() ;
        ArrayList salaryso = new ArrayList() ;
        ArrayList itemsc = new ArrayList() ;
        ArrayList itemsp = new ArrayList() ;

        RecordSet.executeSql( "select itemid , hrmid, salary from HrmSalaryPaydetail where payid = " + payid );
        while( RecordSet.next() ) {
            String itemid = Util.null2String( RecordSet.getString("itemid") ) ;
            String hrmid = Util.null2String( RecordSet.getString("hrmid") ) ;
            String salary = "" + Util.getDoubleValue( RecordSet.getString("salary") , 0 ) ;
            resourceitems.add( hrmid + "_" + itemid ) ;
            salarys.add( salary ) ;
        }

        RecordSet.executeSql( "select itemid , hrmid, salary from HrmSalaryPaydetail where payid = " + payido );
        while( RecordSet.next() ) {
            String itemid = Util.null2String( RecordSet.getString("itemid") ) ;
            String hrmid = Util.null2String( RecordSet.getString("hrmid") ) ;
            String salary = "" + Util.getDoubleValue( RecordSet.getString("salary") , 0 ) ;
            resourceitemso.add( hrmid + "_" + itemid ) ;
            salaryso.add( salary ) ;
        }

		String SqlStr1 = " select id , jobtitle from HrmResource where status !='4' and status !='7' order by departmentid , id ";
		String SqlStr2 = " select id , jobtitle from HrmResource where status !='4' and status !='7' and id in ("+resourceid+") order by departmentid , id ";
		String SqlStr3 = " select id , jobtitle from HrmResource where status !='4' and status !='7' and departmentid=" + deptid + " order by departmentid , id ";
		if(!deptid.equals(""))
	   {
        RecordSet.executeSql( SqlStr3 );
	   }
	   else if(!resourceid.equals(""))
	   {
        RecordSet.executeSql( SqlStr2 );
	   }
	   else
	   {
        RecordSet.executeSql( SqlStr1 );
	   }

        while(RecordSet.next()) {
            String resourceidrs = Util.null2String(RecordSet.getString("id")) ;
            String jobtitlers = Util.null2String(RecordSet.getString("jobtitle")) ;
  %>
  <tr class='datadark'>
  <td><nobr><%=Util.toScreen(ResourceComInfo.getResourcename(""+resourceidrs),user.getLanguage())%></td>
      <td><nobr><%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobtitlers),user.getLanguage())%></td>
  <%
            SalaryComInfo.setTofirstRow() ;
            itemsc.clear();
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
                        if( salary.equals("0") ) salary = "" ;
                    }
					itemsc.add(salary);
   %> 
       <td><%=salary%></td>
   <%           } else {
                    int salaryindex = resourceitems.indexOf( resourceidrs + "_" + itemid+"_1" ) ;
                    if( salaryindex != -1) {
                        personsalary = (String) salarys.get(salaryindex) ;
                        if( personsalary.equals("0") ) personsalary = "" ;
                    }  
                    salaryindex = resourceitems.indexOf( resourceidrs + "_" + itemid+"_2" ) ;
                    if( salaryindex != -1) {
                        companysalary = (String) salarys.get(salaryindex) ;
                        if( companysalary.equals("0") ) companysalary = "" ;
                    }  
					itemsc.add(personsalary);
					itemsc.add(companysalary);
   %>
       <td><%=personsalary%></td>
       <td><%=companysalary%></td>
   <%           }     
            }
   %>
   </tr>
  <tr class='datadark'>
  <td colspan=2 align=right><%=SystemEnv.getHtmlLabelName(17028, user.getLanguage())%></td>
  <%
            SalaryComInfo.setTofirstRow() ;
            itemsp.clear();
            while(SalaryComInfo.next()) {
                String itemid = Util.null2String(SalaryComInfo.getSalaryItemid()) ;
                String itemtype = Util.null2String(SalaryComInfo.getSalaryItemtype()) ;
                String salary = "" ;
                String personsalary = "" ;
                String companysalary = "" ;

                if( !itemtype.equals("2") ) {
                    int salaryindex = resourceitemso.indexOf( resourceidrs + "_" + itemid ) ;
                    if( salaryindex != -1) {
                        salary = (String) salaryso.get(salaryindex) ;
                        if( salary.equals("0") ) salary = "" ;
                    }
					itemsp.add(salary);
   %> 
       <td><%=salary%></td>
   <%           } else {
                    int salaryindex = resourceitemso.indexOf( resourceidrs + "_" + itemid+"_1" ) ;
                    if( salaryindex != -1) {
                        personsalary = (String) salaryso.get(salaryindex) ;
                        if( personsalary.equals("0") ) personsalary = "" ;
                    }  
                    salaryindex = resourceitemso.indexOf( resourceidrs + "_" + itemid+"_2" ) ;
                    if( salaryindex != -1) {
                        companysalary = (String) salaryso.get(salaryindex) ;
                        if( companysalary.equals("0") ) companysalary = "" ;
                    }  
					itemsp.add(personsalary);
					itemsp.add(companysalary);
   %>
       <td><%=personsalary%></td>
       <td><%=companysalary%></td>
   <%           }     
            }
   %>
   </tr>
  <tr class='datalight'>
  <td colspan=2 align=right><%=SystemEnv.getHtmlLabelNames("128046,336",user.getLanguage()) %>
</td>
<%   for(int i=0;i<colnums;i++)
       {
	        double valuec = Util.getDoubleValue( (String)itemsc.get(i) , 0 );
	        double valuep = Util.getDoubleValue( (String)itemsp.get(i) , 0 );
			double temp1 =  valuec - valuep;
			double temp2 =  ((int)(temp1 / valuep * 10000)) / 100;
			String str = ""+temp2+"%";
			if((valuep<=1e-8)&&(valuec>1e-8))
		    {
				str = "Infinity";
			}
%><td><%if(temp1>=0){%><font color=red><%=str%></font><%}else{%><font color=blue><%=str%></font><%}%></td>
<%     }
%>
   </tr>
   
   <%   }
    }
}
   %>
  </TBODY>
 </TABLE>

<script language=vbs>

sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmmain.deptid.value)
	issame = false 
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
		if id(0) = frmmain.deptid.value then
			issame = true 
		end if
		departmentspan.innerHtml = id(1)
		frmmain.deptid.value=id(0)
		resourceidspan.innerHtml = "&nbsp;"
		frmmain.resourceid.value=""
        frmmain.submit()
		else
		departmentspan.innerHtml = "&nbsp;"
		frmmain.deptid.value=""
		end if
	end if
end sub

sub onShowResourceID()
	id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
	if id1(0)<> "" then
		resourceids = id1(0)
		resourcename = id1(1)
		sHtml = ""
		resourceids = Mid(resourceids,2,len(resourceids))
		frmmain.resourceid.value= resourceids
		resourcename = Mid(resourcename,2,len(resourcename))
		while InStr(resourceids,",") <> 0
			curid = Mid(resourceids,1,InStr(resourceids,",")-1)
			curname = Mid(resourcename,1,InStr(resourcename,",")-1)
			resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
			resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
			sHtml = sHtml&"<a href=/hrm/resource/HrmResource.jsp?id="&curid&">"&curname&"</a>&nbsp"
		wend
		sHtml = sHtml&"<a href=/hrm/resource/HrmResource.jsp?id="&resourceids&">"&resourcename&"</a>&nbsp"
		resourceidspan.innerHtml = sHtml
		departmentspan.innerHtml = "&nbsp;"
		frmmain.deptid.value=""
        frmmain.submit()
	else
		resourceidspan.innerHtml = "&nbsp;"
		frmmain.resourceid.value=""
	end if
	
end sub
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
