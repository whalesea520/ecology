<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="TrainPlanComInfo" class="weaver.hrm.train.TrainPlanComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="CareerApplyComInfo" class="weaver.hrm.career.HrmCareerApplyComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String id = Util.null2String(request.getParameter("id"));
boolean isoracle = rs.getDBType().equals("oracle") ;

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String nowdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);

String informman = "" ;
String principalid = "" ;
rs.executeSql("select * from HrmCareerPlan where id ="+id); 
while(rs.next()){
  principalid = Util.null2String(rs.getString("principalid"));
  informman = Util.null2String(rs.getString("informmanid"));  
}

boolean isInformer = (Util.getIntValue(informman)==user.getUID());
boolean isPrincipal = (Util.getIntValue(principalid)==user.getUID());

String jobtitleid = Util.null2String(request.getParameter("jobtitle")); 
//为了从其它页面跳转
if( jobtitleid.equals("") ) { 
    jobtitleid = Util.null2String((String)session.getAttribute("HRMCarreerJobtitle")) ;
}
else {
    session.setAttribute("HRMCarreerJobtitle",jobtitleid) ;
}

String  sqlwhere ="";;
if(!jobtitleid.equals("")){
      sqlwhere = " and jobtitle = "+jobtitleid;
}  
    
int pagenum = Util.getIntValue(request.getParameter("pagenum"),1);
int perpage = 10;
int numcount = 0;
String sqlnum = "select count(id) from HrmCareerApply where careerinviteid in ( select id from HrmCareerInvite where careerplanid = "+id+") "+sqlwhere;  
rs.executeSql(sqlnum);
rs.next();
numcount = rs.getInt(1);


String temptable = "temptable"+Util.getNumberRandom();
String sqltemp = "" ;
if(isoracle) {
    sqltemp = "create table "+temptable+" as select * from ( select * from HrmCareerApply where careerinviteid in ( select id from HrmCareerInvite where careerplanid = "+id+") " +sqlwhere+" order by createdate desc,id desc )  where rownum<"+ (pagenum*perpage+1);
}
else {
    sqltemp = "select top "+(pagenum*perpage)+" * into "+temptable+" from HrmCareerApply where careerinviteid in ( select id from HrmCareerInvite where careerplanid = "+id+") "+sqlwhere+" order by createdate desc,id desc";
}

rs.executeSql(sqltemp);
String sqlcount = "select count(id) from "+temptable;
rs.executeSql(sqlcount);
rs.next();
int count = rs.getInt(1);
boolean hasnext = false;
if(numcount>pagenum*perpage){
  hasnext = true;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6133,user.getLanguage())+": "+SystemEnv.getHtmlLabelName(773,user.getLanguage());;
String needfav ="1";
String needhelp ="";


%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(isInformer){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doInform(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmCareerPlanAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/career/HrmCareerManager.jsp,_self} " ;
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
<FORM name=resource id=resource action="HrmInterviewOperation.jsp" method=post>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="20%">
  <COL width="15%">
  <COL width="35%">
  <COL width="20%">
  <COL width="10%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=5><%=SystemEnv.getHtmlLabelName(773,user.getLanguage())%></TH></TR>
    <TR class=Header>    
    <TD><%=SystemEnv.getHtmlLabelName(1932,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15671,user.getLanguage())%></TD> 
    <TD></TD>    
    <TD><%=SystemEnv.getHtmlLabelName(1929,user.getLanguage())%></TD>    
    <TD><%=SystemEnv.getHtmlLabelName(15705,user.getLanguage())%></TD>    
  </TR>

<%  
int needchange=0; 
    
    String sql = "" ;
    if(isoracle) {
        sql = "select * from (select * from "+temptable +" order by createdate,id ) where rownum<="+ (count - ((pagenum-1)*perpage)) ;
    }
    else {
        sql = "select top "+(count - ((pagenum-1)*perpage)) +" * from "+temptable+" order by createdate,id "; 
    }
     
      rs.executeSql(sql);
	  rs.afterLast() ;
      while(rs.previous()){        
        String resourceid = Util.null2String(rs.getString("id"));
        String jobtitle = Util.null2String(rs.getString("jobtitle"));
        String lastname = Util.null2String(rs.getString("lastname"));                
        int status = CareerApplyComInfo.getStatus(resourceid);
        String stepname = CareerApplyComInfo.getStepname(resourceid);        
        String isinform = Util.null2String(rs.getString("isinform"));
      if(needchange%2==0){
        needchange ++;
%>
  <TR class=datadark> 
<%
      }else{
      needchange ++;
%>   
  <TR class=datalight> 
<%
      }
%>  
    <TD><a href="/hrm/career/HrmCareerApplyEdit.jsp?applyid=<%=resourceid%>"><%=lastname%></a></TD>
    <TD>
        <%=JobTitlesComInfo.getJobTitlesname(jobtitle)%>      
    </TD>    
    <td>      
      <%if(isInformer || CareerApplyComInfo.isAssessor(resourceid,user.getUID()) ){%><a href="HrmInterviewPlan.jsp?id=<%=resourceid%>&planid=<%=id%>&jobtitle=<%=jobtitleid%>"><%=SystemEnv.getHtmlLabelName(6103,user.getLanguage())%></a>/<%}%>
      <%if(CareerApplyComInfo.isTester(resourceid,user.getUID())){%><a href="HrmInterviewResult.jsp?id=<%=resourceid%>&result=1&planid=<%=id%>&jobtitle=<%=jobtitleid%>"><%=SystemEnv.getHtmlLabelName(15376,user.getLanguage())%></a>/
      <a href="HrmInterviewResult.jsp?id=<%=resourceid%>&result=2&planid=<%=id%>&jobtitle=<%=jobtitleid%>"><%=SystemEnv.getHtmlLabelName(15689,user.getLanguage())%></a>/
      <a href="HrmInterviewResult.jsp?id=<%=resourceid%>&result=0&planid=<%=id%>&jobtitle=<%=jobtitleid%>"><%=SystemEnv.getHtmlLabelName(15690,user.getLanguage())%></a>/<%}%>
      <%if(isInformer){%><a href="/sendmail/HrmMailMerge.jsp?applyid=<%=resourceid%>&jobtitle=<%=jobtitleid%>"><%=SystemEnv.getHtmlLabelName(15691,user.getLanguage())%></a>/<%}%>
      <%if(CareerApplyComInfo.isAssessor(resourceid,user.getUID())){%><a href="HrmInterviewAssess.jsp?id=<%=resourceid%>&planid=<%=id%>&jobtitle=<%=jobtitleid%>"><%=SystemEnv.getHtmlLabelName(6102,user.getLanguage())%></a>/ <%}%>     
      <%if(HrmUserVarify.checkUserRight("HrmCareerApply:Hire",user) || isPrincipal ){%><a href="HrmCareerApplyToResource.jsp?id=<%=resourceid%>&planid=<%=id%>&jobtitle=<%=jobtitleid%>"><%=SystemEnv.getHtmlLabelName(1853,user.getLanguage())%></a><%}%>
    </td>
    <td>
      <%=stepname%>
      <%if(status == 0){%><%=SystemEnv.getHtmlLabelName(15706,user.getLanguage())%><%}%>
      <%if(status == 1){%><%=SystemEnv.getHtmlLabelName(15376,user.getLanguage())%><%}%>
      <%if(status == 2){%><%=SystemEnv.getHtmlLabelName(15704,user.getLanguage())%><%}%>
    </td>
    <td>
      <input class=inputstyle type=checkbox name=actor value=<%=resourceid%> <%if(isinform.equals("1")){%>checked <%}%> <%if(!isInformer){%>disabled<%}%>>
    </td>
  </TR>
<%    }
String sqldrop =" drop table "+temptable ;
 rs.executeSql(sqldrop);
%>
 </TBODY>
 </TABLE>
<input class=inputstyle type=hidden name=operation> 
<input class=inputstyle type=hidden name=planid value="<%=id%>">
<input class=inputstyle type=hidden name=id value="<%=id%>">
<input class=inputstyle type=hidden name=jobtitleid value="<%=jobtitleid%>">
<input class=inputstyle type=hidden name=pagenum >
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
function doSave() {
   document.resource.submit() ;
}
function doDelete() {
  if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>？")){
   document.resource.operation.value="plandelete";
   document.resource.submit() ;
  } 
}
function doBack() {
   location="HrmCareerApplyList.jsp?id=<%=id%>";
}
function doInform() {   
   document.resource.operation.value="inform";
   document.resource.submit() ;
}

function pageup(){
    document.resource.pagenum.value="<%=pagenum-1%>";    
    document.resource.action="HrmCareerApplyList.jsp";
    document.resource.submit();
}
function pagedown(){
    document.resource.pagenum.value="<%=pagenum+1%>";    
    document.resource.action="HrmCareerApplyList.jsp";
    document.resource.submit();
}
</script>
</BODY>
</HTML>
