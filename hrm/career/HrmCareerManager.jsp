<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
boolean isoracle = rs.getDBType().equals("oracle") ;
boolean isdb2 = rs.getDBType().equals("db2") ;

boolean hasright = false;

if(HrmUserVarify.checkUserRight("HrmCareerPlanAdd:Add", user)){
   hasright = true;
}
/*
Add by Huang Yu FOR BUG 237 ON May 9th ,2004
如果没有权限则判断是否和该招聘计划相关，即是否是通知人，负责人 或者是审核人
*/
String temptable1 ="";
String sqlStr ="";
if(!hasright){
     temptable1 = "temptable"+Util.getNumberRandom();
     if(isoracle) {
         sqlStr = "CREATE TABLE "+temptable1+"AS SELECT DISTINCT t1.id,t1.topic,t1.principalid,t1.informmanid,t1.startdate  From HrmCareerPlan t1 , HrmCareerInvite t2  , HrmCareerInviteStep t3 WHERE t1.ID = t2.CareerPlanID(+) and t2.ID = t3.InviteID(+) and (t1.enddate = '' or t1.enddate is null) and (t1.principalid = "+user.getUID()+" or t1.informmanid = "+user.getUID()+" or t3.assessor = "+user.getUID()+")";
     }else if(isdb2){
		sqlStr = "create table "+temptable1+"  as ( SELECT DISTINCT t1.id,t1.topic,t1.principalid,t1.informmanid,t1.startdate  From HrmCareerPlan t1 , HrmCareerInvite t2  , HrmCareerInviteStep t3  ) definition only";
        rs.executeSql(sqlStr);
        sqlStr = "insert into "+temptable1+" (   SELECT DISTINCT t1.id,t1.topic,t1.principalid,t1.informmanid,t1.startdate  From HrmCareerPlan t1 , HrmCareerInvite t2  , HrmCareerInviteStep t3 WHERE t1.ID = t2.CareerPlanID(+) and t2.ID = t3.InviteID(+) and (t1.enddate = '' or t1.enddate is null) and (t1.principalid = "+user.getUID()+" or t1.informmanid = "+user.getUID()+" or t3.assessor = "+user.getUID()+")";
	 }
     else{
         sqlStr ="SELECT DISTINCT t1.id,t1.topic,t1.principalid,t1.informmanid,t1.startdate INTO "+temptable1+" From HrmCareerPlan t1 LEFT JOIN HrmCareerInvite t2 ON (t1.ID = t2.CareerPlanID) LEFT JOIN HrmCareerInviteStep t3 ON (t2.ID = t3.InviteID) WHERE (t1.enddate = '' or t1.enddate is null) and (t1.principalid = "+user.getUID()+" or t1.informmanid = "+user.getUID()+" or t3.assessor = "+user.getUID()+")";
     }

     rs.executeSql(sqlStr);
	 //System.out.println("sqlStr = "+sqlStr);
     rs.executeSql("Select count(*) as count From "+temptable1) ;

     if(rs.next()){
		 //System.out.println("sqlCount = "+rs.getInt("count"));
		 if(rs.getInt("count") >0){
			 hasright = true;
		 }else{
			 rs.executeSql("drop table "+temptable1)    ;
		 }
	 }else{
			 rs.executeSql("drop table "+temptable1)    ;
	 }
}

if(!hasright){
     response.sendRedirect("/notice/noright.jsp");
     return;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%


int pagenum = Util.getIntValue(request.getParameter("pagenum"),1);
int perpage = 10;
int numcount = 0;
String sqlnum = "";
if(!temptable1.equals(""))
    sqlnum = "select count(id) from "+temptable1;
else
    sqlnum = "select count(id) from HrmCareerPlan where enddate = ''  or enddate is null";

//System.out.println("sqlnum ="+sqlnum);
rs.executeSql(sqlnum);
if(rs.next()){
	numcount = rs.getInt(1);
  }

String temptable = "temptable"+Util.getNumberRandom();
String sqltemp = "" ;
if(isoracle) {
    if(!temptable1.equals(""))
        sqltemp = "create table "+temptable+" as select * from ( select t1.* from HrmCareerPlan t1,"+temptable1+" t2 WHERE t1.ID = t2.ID order by t1.startdate desc,t1.id desc)  where rownum<"+ (pagenum*perpage+1);
    else
        sqltemp = "create table "+temptable+" as select * from ( select * from HrmCareerPlan where  enddate = ''  or enddate is null order by startdate desc,id desc )  where rownum<"+ (pagenum*perpage+1);
}else if(isdb2){
    if(!temptable1.equals("")){
		sqltemp = "create table "+temptable+"  as ( select t1.* from HrmCareerPlan t1  ) definition only";
        rs.executeSql(sqltemp);
        sqltemp = "insert into "+temptable+" (  select t1.* from HrmCareerPlan t1,"+temptable1+" t2 WHERE t1.ID = t2.ID order by t1.startdate desc,t1.id desc   fetch first "+(pagenum*perpage+1)+"  rows only)";
    }else{
		sqltemp = "create table "+temptable+"  as ( select * from HrmCareerPlan  ) definition only";
        rs.executeSql(sqltemp);
        sqltemp = "insert into "+temptable+" (  select * from HrmCareerPlan where  enddate = ''  or enddate is null order by startdate desc,id desc  fetch first "+(pagenum*perpage+1)+"  rows only)";
    }
}
else {
    if(!temptable1.equals(""))
        sqltemp = "select top "+(pagenum*perpage)+" t1.* into "+temptable+" from HrmCareerPlan t1,"+temptable1+" t2 WHERE t1.ID = t2.ID order by t1.startdate desc,t1.id desc ";
    else
        sqltemp = "select top "+(pagenum*perpage)+" * into "+temptable+" from HrmCareerPlan where enddate = ''  or enddate is null order by startdate desc,id desc";
}

rs.executeSql(sqltemp);
String sqlcount = "select count(id) from "+temptable;
rs.executeSql(sqlcount);
int count = 0;
if(rs.next()){
	count = rs.getInt(1);
}
String sql = "" ;
if(isoracle) {
    sql = "select * from (select * from "+temptable +" order by startdate,id ) where rownum<="+ (count - ((pagenum-1)*perpage)) ;
}else if(isdb2){
    sql = "select * from "+temptable +" order by startdate,id fetch first  "+(count - ((pagenum-1)*perpage)+1)+"  rows only";
}
else {
    sql = "select top "+(count - ((pagenum-1)*perpage)) +" * from "+temptable+" order by startdate,id ";
}

boolean hasnext = false;
if(numcount>pagenum*perpage){
  hasnext = true;
}
//System.out.println("hasnext ="+hasnext);
//System.out.println("numcount="+numcount);
//System.out.println("pagenum*perpage = "+pagenum*perpage);

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6133,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmCareerPlanAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/career/careerplan/HrmCareerPlanAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

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
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=7><%=SystemEnv.getHtmlLabelName(6132,user.getLanguage())%></TH></TR>

  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15669,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15668,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15728,user.getLanguage())%></TD>
  </TR>


<%
//String sql = "select * from HrmCareerPlan";
rs.executeSql(sql);
int needchange = 0;
rs.afterLast() ;
while(rs.previous()){
String	topic=Util.null2String(rs.getString("topic"));
String	principalid=Util.null2String(rs.getString("principalid"));
String  informmanid = Util.null2String(rs.getString("informmanid"));
String  startdate = Util.null2String(rs.getString("startdate"));
String  advice = Util.null2String(rs.getString("advice"));
String enddate = Util.null2String(rs.getString("enddate"));
if(!enddate.equals(""))continue;
try{
  if(needchange ==0){
  needchange = 1;
%>
  <TR class=datalight>
<%
}else{ needchange=0;
%>
  <TR class=datadark>
<%
}
%>
   <td><a href="HrmCareerApplyList.jsp?id=<%=rs.getString("id")%>"><%=topic%></a>
   </td>
   <TD><%=ResourceComInfo.getResourcename(principalid)%></a>
   </TD>
   <TD><%=ResourceComInfo.getResourcename(informmanid)%></a>
   </TD>
   <TD><%=startdate%>
   </TD>
   <TD><%=advice%>
   </TD>
  </TR>
<%
  }catch(Exception e){
  rs.writeLog(e.toString()); } }
String sqldrop =" drop table "+temptable ;
 rs.executeSql(sqldrop);
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
<td height="0" colspan="3"></td>
</tr>
</table>
 </BODY>
</HTML>

<SCRIPT language="javascript">

function pageup(){
    location.href="HrmCareerManager.jsp?pagenum=<%=pagenum-1%>";
}
function pagedown(){
	location.href="HrmCareerManager.jsp?pagenum=<%=pagenum+1%>"
}
</script>