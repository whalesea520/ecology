<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String jobtitle = Util.null2String(request.getParameter("jobtitle"));
String tempcareerdesc = Util.null2String(request.getParameter("careerdesc"));
boolean isoracle = RecordSet.getDBType().equals("oracle") ;

String  sqlwhere ="";
if (!jobtitle.equals("")){ 
	sqlwhere = " where careername ='"+Util.fromScreen2(jobtitle,user.getLanguage())+"' ";
if (!tempcareerdesc.equals(""))
		sqlwhere +=" and careerdesc like '%"+Util.fromScreen2(tempcareerdesc,user.getLanguage())+"%' ";
}
else{
	if (!tempcareerdesc.equals(""))
		sqlwhere +=" where careerdesc like '%"+Util.fromScreen2(tempcareerdesc,user.getLanguage())+"%' ";
}

int pagenum = Util.getIntValue(request.getParameter("pagenum"),1);
int perpage = 10;
int numcount = 0;
String sqlnum = "select count(id) from HrmCareerInvite "+sqlwhere;
RecordSet.executeSql(sqlnum);
RecordSet.next();
numcount = RecordSet.getInt(1);

String temptable = "temptable"+Util.getNumberRandom();
String sqltemp = "" ;

if(isoracle) {
    sqltemp = "create table "+temptable+" as select * from ( select * from HrmCareerInvite "+sqlwhere+" order by createdate desc,id desc )  where rownum<"+ (pagenum*perpage+1);
}
else {
    sqltemp = "select top "+(pagenum*perpage)+" * into "+temptable+" from HrmCareerInvite "+sqlwhere+" order by createdate desc,id desc";
}


RecordSet.executeSql(sqltemp);
String sqlcount = "select count(id) from "+temptable;
RecordSet.executeSql(sqlcount);
RecordSet.next();
int count = RecordSet.getInt(1);
String sqlstr = "" ;
if(isoracle) {
    sqlstr = "select * from (select * from "+temptable +" order by createdate,id  ) where rownum<="+ (count - ((pagenum-1)*perpage)) ;
}
else {
    sqlstr = "select top "+(count - ((pagenum-1)*perpage)) +" * from "+temptable+" order by createdate,id ";
}

boolean hasnext = false;
if(numcount>pagenum*perpage){
  hasnext = true;
}

//String sqlstr = "select * from HrmCareerInvite " + sqlwhere ;

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(366,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmCareerInviteAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(527,user.getLanguage())+",javascript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",/hrm/career/HrmCareerInviteAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(HrmUserVarify.checkUserRight("HrmCareerInvite:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem ="+58+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{-}" ;
if(pagenum>1){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:pageup(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(hasnext){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:pagedown(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM NAME=frmain action="HrmCareerInvite.jsp" method=post>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<table class=ViewForm border=0>
    <colgroup> 
    <col width="6%"> 
    <col width="45%"> 
    <col width="6%"> 
    <col width="43%"> 
    <tbody> 
    <tr> 
      <th align=left colspan=4><%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%></th>
    </tr>
    <tr class=Spacing style="height:2px"> 
      <td class=Line1 colspan=4></td>
    </tr>
    <tr> 
      <td width="10%"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></td>      
	<TD class=Field width="40%">

           <input class="wuiBrowser" id=jobtitle type=hidden name=jobtitle value="<%=jobtitle%>"
		   _url="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp"
		   _displayText="<%=JobTitlesComInfo.getJobTitlesname(jobtitle)%>">	  
	</TD>
      <td width="10%"><%=SystemEnv.getHtmlLabelName(15708,user.getLanguage())%></td>
      <TD class=Field width="40%"><input class=inputstyle name=careerdesc value=<%=tempcareerdesc%>></TD>
    </tr>
    </tbody> 
  </table>
<TABLE class=ListStyle cellspacing=1 >
  <TBODY>
  <TR class=Header>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(366,user.getLanguage())%></TH>
  </TR>
  </TBODY></TABLE>
<TABLE class=ListStyle cellspacing=1 >

  <COLGROUP>
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(1859,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(1860,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(1861,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(1862,user.getLanguage())%></TH>
	<TH></TH>
	</TR>

    </THEAD>
<%
int i= 0;
RecordSet.executeSql(sqlstr);
RecordSet.afterLast() ;
while(RecordSet.previous()) {
	String id = RecordSet.getString("id") ;
	String careername = Util.toScreen(RecordSet.getString("careername"),user.getLanguage()) ;
	String careerpeople = Util.null2String(RecordSet.getString("careerpeople")) ;
	String careersex = Util.null2String(RecordSet.getString("careersex")) ; 
	String careeredu = Util.null2String(RecordSet.getString("careeredu")) ;
	String createrid = Util.null2String(RecordSet.getString("createrid")) ;
	String createdate = Util.null2String(RecordSet.getString("createdate"));
	String careersexstr="";
	String careeredustr="";
	if (careersex.equals("0")) careersexstr = SystemEnv.getHtmlLabelName(417,user.getLanguage());
	else if	(careersex.equals("1")) careersexstr = SystemEnv.getHtmlLabelName(418,user.getLanguage());
	else if (careersex.equals("2")) careersexstr = SystemEnv.getHtmlLabelName(763,user.getLanguage());
	if (careeredu.equals("0")) careeredustr = SystemEnv.getHtmlLabelName(764,user.getLanguage());
	else if	(careeredu.equals("1")) careeredustr = SystemEnv.getHtmlLabelName(765,user.getLanguage());
	else if (careeredu.equals("2")) careeredustr = SystemEnv.getHtmlLabelName(766,user.getLanguage());
	else if (careeredu.equals("3")) careeredustr = SystemEnv.getHtmlLabelName(767,user.getLanguage());
	else if (careeredu.equals("4")) careeredustr = SystemEnv.getHtmlLabelName(768,user.getLanguage());
	else if (careeredu.equals("5")) careeredustr = SystemEnv.getHtmlLabelName(769,user.getLanguage());	
	else if (careeredu.equals("6")) careeredustr = SystemEnv.getHtmlLabelName(763,user.getLanguage());	
    
    // 刘煜修改，为了和以前的相一致
    if( Util.getIntValue(careername) != -1 ) careername = JobTitlesComInfo.getJobTitlesname(careername) ;

if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
<%
}
%>
    <TD><a href='/hrm/career/HrmCareerApplyViewDetail.jsp?paraid=<%=id%>'><%=Util.add0(Util.getIntValue(id),12)%></a></TD>
	<TD><%=careername%> </TD>
	<TD><%=careerpeople%></TD>
	<TD><%=careersexstr%></TD>
	<TD><%=careeredustr%></TD>
	<TD><%=Util.toScreen(ResourceComInfo.getResourcename(createrid),user.getLanguage())%></TD>
	<TD><%=createdate%></TD>
	<TD>
<%
  if(HrmUserVarify.checkUserRight("HrmCareerInviteEdit:Edit", user)){
%>	
	  <A HREF="HrmCareerInviteEdit.jsp?paraid=<%=id%>"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></A>
<%}%>	  
	</TD>
    </TR>
<%}
String sqldrop =" drop table "+temptable ;
 RecordSet.executeSql(sqldrop);
%>
<input class=inputstyle type=hidden name=pagenum >

</tr>
</TABLE>
</FORM>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>

<SCRIPT language="vbs">  
sub onShowJobtitle()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	jobtitlespan.innerHtml = id(1)
	frmain.jobtitle.value=id(0)
	else 
	jobtitlespan.innerHtml = ""
	frmain.jobtitle.value=""
	end if
	end if
end sub  
</SCRIPT>
<SCRIPT language="javascript">
function OnSubmit(){
		document.frmain.submit();
}
function pageup(){
    document.frmain.pagenum.value="<%=pagenum-1%>";    
    document.frmain.action="HrmCareerInvite.jsp";
    document.frmain.submit();
}
function pagedown(){
    document.frmain.pagenum.value="<%=pagenum+1%>";    
    document.frmain.action="HrmCareerInvite.jsp";
    document.frmain.submit();
}
</script>
  </BODY>
</HTML>