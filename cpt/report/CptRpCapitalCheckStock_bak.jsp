<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
if(!HrmUserVarify.checkUserRight("CptCapitalCheckStock:Display",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String capitalid = request.getParameter("capitalid");

int TotalCount = Util.getIntValue(request.getParameter("TotalCount"),0);

String sql="";
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
//查询条件
String checkstockno = Util.null2String(request.getParameter("checkstockno"));   //编号
String departmentid = Util.null2String(request.getParameter("departmentid"));   //部门    
String location = Util.null2String(request.getParameter("location"));           //地点
String checkerid = Util.null2String(request.getParameter("checkerid"));         //盘点人
String approverid = Util.null2String(request.getParameter("approverid"));       //审批人 
String checkstatus = "1";
String fromdate = Util.null2String(request.getParameter("fromdate"));           //盘点日期从
String todate = Util.null2String(request.getParameter("todate"));               //盘点日期至    

//分页相关
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getIntValue(request.getParameter("perpage"),0);
if(perpage<=1 )	perpage=10;

String temptable = "cpttemptable"+ Util.getNumberRandom() ;

int ishead = 0 ;

if(! sqlwhere1.equals("")) {
	sql = sqlwhere1 ;
	ishead = 1 ;
}

if(! departmentid.equals("")) {
	if(ishead == 0) {
		sql += " where departmentid = " + departmentid ;
		ishead = 1;
	}
	else sql += " and departmentid = " + departmentid ;
}

if(! checkstockno.equals("")) {
	if(ishead == 0) {
		sql += " where checkstockno like '%" + checkstockno+"%' ";
		ishead = 1;
	}
	else sql += " and checkstockno like '%" + checkstockno+"%' ";
}

if(! location.equals("")) {
	if(ishead == 0) {
		sql += " where location like '%" + location+"%' ";
		ishead = 1;
	}
	else sql += " and location like '%" + location+"%' ";
}

if(! checkerid.equals("")) {
	if(ishead == 0) {
		sql += " where checkerid = " + checkerid ;
		ishead = 1;
	}
	else sql += " and checkerid = " + checkerid ;
}

if(! approverid.equals("")) {
	if(ishead == 0) {
		sql += " where approverid = " + approverid ;
		ishead = 1;
	}
	else sql += " and approverid = " + approverid ;
}

if(! checkstatus.equals("")) {
	if(ishead == 0) {
		sql += " where checkstatus = " + checkstatus ;
		ishead = 1;
	}
	else sql += " and checkstatus = " + checkstatus ;
}

if(! fromdate.equals("")) {
	if(ishead == 0) {
		sql += " where createdate >= '" + fromdate + "' " ;
		ishead = 1;
	}
	else sql += " and createdate >= '" + fromdate + "' " ;
}

if(! todate.equals("")) {
	if(ishead == 0) {
		sql += " where createdate <= '" + todate + "' " ;
		ishead = 1;
	}
	else sql += " and createdate <= '" + todate + "' " ;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1506,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<DIV class=HdrProps></DIV>
<FORM id=weaver name=frmain action="CptRpCapitalCheckStock.jsp" method=post>
<input type="hidden" id=sqlwhere1 name="sqlwhere1" value="<%=xssUtil.put(sqlwhere1)%>">

<BUTTON class=BtnRefresh id=cmdRefresh accessKey=R 
      type="submit" name=cmdRefresh><U>R</U>-<%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%></BUTTON> 
<table class=form>
  <colgroup> 
  <col width="10%"><col width="20%"><col width="10%"><col width="20%">
  <col width="10%">  <col width="30%">
  <tbody> 
   <TR class=Section>
   <tr> 
      <td><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
   <td class=Field> 
    <input class=saveHistory maxlength=20 name="checkstockno" size=18 value="<%=checkstockno%>">
    </td>
    <td><%=SystemEnv.getHtmlLabelName(1387,user.getLanguage())%></td>
     <td class=Field> 
    <input class=saveHistory maxlength=200 name="location" size=18 value="<%=location%>">
    </td>
	<td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
    <td class=Field>
        <button class=Browser id=SelectDeparmentID onClick="onShowDepartmentID()"></button> 
        <span class=saveHistory id=departmentidspan>
        <%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%>
        </span> 
        <input id=departmentid type=hidden name=departmentid value="<%=departmentid%>">
    </td>
  </tr>
   <tr> 
      <td><%=SystemEnv.getHtmlLabelName(1416,user.getLanguage())%></td>
    <td class=Field><BUTTON class=Browser id=SelectCheckerID onClick="onShowCheckerID()"></BUTTON> 
      <span id=checkeridspan><%=Util.toScreen(ResourceComInfo.getResourcename(checkerid),user.getLanguage())%></span> 
      <INPUT class=saveHistory id=checkerid type=hidden name=checkerid value="<%=checkerid%>"></td>
    <td><%=SystemEnv.getHtmlLabelName(439,user.getLanguage())%></td>
    <td class=Field><BUTTON class=Browser id=SelectApproverID onClick="onShowApproverID()"></BUTTON> 
      <span id=approveridspan><%=Util.toScreen(ResourceComInfo.getResourcename(approverid),user.getLanguage())%></span> 
      <INPUT class=saveHistory id=approverid type=hidden name=approverid value="<%=approverid%>"></td>
   <td><%=SystemEnv.getHtmlLabelName(1424,user.getLanguage())%></td>
    <td class=Field><button class=calendar id=SelectDate onClick=gettheDate(fromdate,fromdatespan)></button>&nbsp; 
      <span id=fromdatespan style="FONT-SIZE: x-small"><%=fromdate%></span> -&nbsp;&nbsp;<button class=calendar 
      id=SelectDate2 onClick="gettheDate(todate,todatespan)"></button>&nbsp; <span id=todatespan " style="FONT-SIZE: x-small"><%=todate%></span> 
      <input type="hidden" id=fromdate name="fromdate" value="<%=fromdate%>">
      <input type="hidden" id=todate name="todate" value="<%=todate%>">
    </td>
  </tr>
  </tbody> 
</table>

<TABLE class=ListShort>
  <COLGROUP>
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <TBODY>
<BR>  
<TR class=Section>
    <TH colSpan=5><A HREF="CptCapital.jsp?id=<%=capitalid%>"><%=Util.toScreen(CapitalComInfo.getCapitalname(capitalid),user.getLanguage())%></A></TH></TR>

 <TR class=separator>
    <TD class=Sep1 colSpan=5 ></TD></TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1416,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(439,user.getLanguage())%></TD>
  </TR>
 
<%
<%
if(rs.getDBType().equals("oracle")){
	sql = "create table "+temptable+"  as select * from (select * from CptCheckStock "+sql+" order by approvedate desc ) where rownum<"+ (pagenum*perpage+2);
}else if(rs.getDBType().equals("db2")){
    sql = "create table "+temptable+"  as (select * from CptCheckStock ) definition only";
    rs.execute(sql);
    sql = " insert into  "+temptable+"  ( select * from CptCheckStock "+sql+" order by approvedate desc fetch first "+(pagenum*perpage+1)+" rows only";
}else{
	sql = "select top "+(pagenum*perpage+1)+" * into "+temptable+" from CptCheckStock "+sql+" order by approvedate desc ";
}

rs.execute(sql);   

rs.executeSql("Select count(id) RecordSetCounts from "+temptable);
boolean hasNextPage=false;
int RecordSetCounts = 0;
if(rs.next()){
	RecordSetCounts = rs.getInt("RecordSetCounts");
}
if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}
	String sqltemp="";
if(rs.getDBType().equals("oracle")){
	sqltemp="select * from (select * from  "+temptable+" order by approvedate) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
}else{
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+"  order by approvedate ";
}

rs.executeSql(sqltemp);

int totalline=1;

int needchange = 0;
      if(rs.last()){
      do{
        String  tempid = rs.getString("id");
		String	tempcheckstockno=Util.toScreen(rs.getString("checkstockno"),user.getLanguage());
		String	tempstockdesc=Util.toScreen(rs.getString("checkstockdesc"),user.getLanguage());
        String  tempcheckstatus = rs.getString("checkstatus");
        String  tempcheckerid = rs.getString("checkerid");
        String  tempapproverid = Util.toScreen(rs.getString("approverid"),user.getLanguage());
       try{
       	if(needchange ==0){
       		needchange = 1;
%>
  <TR class=datalight>
  <%
  	}else{
  		needchange=0;
  %><TR class=datadark>
  <%  	}
  %>
      <TD><A HREF="../maintenance/CptCapitalCheckStockEdit.jsp?checkstockid=<%=""+tempid%>"><%=tempcheckstockno%></A></TD>
      <TD><%=tempstockdesc%></TD>
      <TD>
      <%if(tempcheckstatus.equals("0")){%><%=SystemEnv.getHtmlLabelName(1422,user.getLanguage())%><%}%>
      <%if(tempcheckstatus.equals("1")){%><%=SystemEnv.getHtmlLabelName(1423,user.getLanguage())%><%}%>
      </TD>
       <TD><%=Util.toScreen(ResourceComInfo.getResourcename(tempcheckerid),user.getLanguage())%></TD>
      <TD>
      <%=Util.toScreen(ResourceComInfo.getResourcename(tempapproverid),user.getLanguage())%>
      </TD>
  </TR>
   <%  if(hasNextPage){
		totalline+=1;
		if(totalline>perpage)	break;
	 }
      }catch(Exception e){
        //System.out.println(e.toString());
      }
    }while(rs.previous());
 }
 rs.executeSql("drop table "+temptable);
%>  
 </TBODY></TABLE>
 <table align=right>
   <tr>
   <td>&nbsp;</td>
   <td><%if(pagenum>1){%><button class=btn accessKey=P onclick="onNextPage(1)"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button><%}%> </td>
   <td><%if(hasNextPage){%><button class=btn accessKey=N onclick="onNextPage(2)"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button><%}%></td>
   <input type="hidden" id=TotalCount name="TotalCount" value="<%=TotalCount%>">
   <input type="hidden" id=pagenum name="pagenum">
   <td>&nbsp;</td>
   </tr>
</TABLE>
 </FORM>
 <script language=vbs>
sub onShowCheckerID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	checkeridspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmain.checkerid.value=id(0)
	else 
	checkeridspan.innerHtml = ""
	frmain.checkerid.value=""
	end if
	end if
end sub

sub onShowApproverID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	approveridspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmain.approverid.value=id(0)
	else 
	approveridspan.innerHtml = ""
	frmain.approverid.value=""
	end if
	end if
end sub

 sub onShowDepartmentID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmain.departmentid.value)
	issame = false 
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	if id(0) = frmain.departmentid.value then
		issame = true 
	end if
	departmentidspan.innerHtml = id(1)
	frmain.departmentid.value=id(0)
	else
	departmentidspan.innerHtml = ""
	frmain.departmentid.value=""
	end if
	end if
end sub

</script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function onNextPage(next){
    if(next==1){
        document.all("pagenum").value=<%=pagenum-1%>;
    }else if (next==2){
        document.all("pagenum").value=<%=pagenum+1%>;
    }
    document.frmain.submit();
}
//-->
</SCRIPT>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
