<%@ page import="weaver.general.Util,weaver.file.*" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<% //jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/ %>
<jsp:useBean id="HrmSearchComInfo" class="weaver.hrm.search.HrmSearchComInfo" scope="session"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String userid =""+user.getUID();

/*权限判断,人力资产管理员以及其所有上级*/
//boolean canView = false;
//ArrayList allCanView = new ArrayList();
//String tempsql = "select resourceid from HrmRoleMembers where roleid = 4 ";
//RecordSet.executeSql(tempsql);
//while(RecordSet.next()){
//	String tempid = RecordSet.getString("resourceid");
//	allCanView.add(tempid);
//	AllManagers.getAll(tempid);
//	while(AllManagers.next()){
//		allCanView.add(AllManagers.getManagerID());
//	}
//}// end while
//
//for (int i=0;i<allCanView.size();i++){
//	if(userid.equals((String)allCanView.get(i))){
//		canView = true;
//	}
//}
//
//if(!canView) {
//	response.sendRedirect("/notice/noright.jsp") ;
//	return ;
//}
/*权限判断结束*/

String tempsearchsql = HrmSearchComInfo.FormatSQLSearch();

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1515,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:onReSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{Excel , /weaver/weaver.file.ExcelOut,ExcelOut} " ;
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
 
<table border=1 width=100%>
<tr>
<td>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
   <TBODY>
 <TR class=Header>
    <TH colSpan=19><%=SystemEnv.getHtmlLabelName(1515,user.getLanguage())%></TH></TR>
  <TR class=Header>
          <TD width="13%"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
          <TD width="11%"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>          
          <TD width="15%"><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></TD>
          <TD width="15%"><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></TD>
           <TD width="15%"><%=SystemEnv.getHtmlLabelName(422,user.getLanguage())%></TD>
           <TD width="10%"><%=SystemEnv.getHtmlLabelName(15714,user.getLanguage())%></TD>
           <TD width="6%"><%=SystemEnv.getHtmlLabelName(420,user.getLanguage())%></TD>
          <TD width="15%"><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></TD>
  </TR>
  <TR class=Line><TD colspan="19" ></TD></TR> 
 
<%
ExcelSheet es = new ExcelSheet() ;
ExcelRow er = es.newExcelRow () ;

er.addStringValue(SystemEnv.getHtmlLabelName(124,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(413,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(15714,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(421,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(494,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(422,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(420,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(477,user.getLanguage())) ;

es.addExcelRow(er) ;

//sql = "select top "+(pagenum*perpage+1)+" * into "+temptable+" from CptUseLog "+sql+" order by usedate desc";
//rs.execute(sql);   
//
//rs.executeSql("Select count(id) RecordSetCounts from "+temptable);
//boolean hasNextPage=false;
//int RecordSetCounts = 0;
//if(rs.next()){
//	RecordSetCounts = rs.getInt("RecordSetCounts");
//}
//if(RecordSetCounts>pagenum*perpage){
//	hasNextPage=true;
//}
//String sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+"  order by usedate";
//rs.executeSql(sqltemp);(被下面的搜索语句代替)

String department		 =Util.fromScreen(request.getParameter("department"),user.getLanguage());
String resourcename   =Util.fromScreen2(request.getParameter("resourcename"),user.getLanguage());
String sex            =Util.fromScreen(request.getParameter("sex"),user.getLanguage());
String startdate      =Util.fromScreen(request.getParameter("startdate"),user.getLanguage());
String startdateTo    =Util.fromScreen(request.getParameter("startdateTo"),user.getLanguage());
String birthday       =Util.fromScreen(request.getParameter("birthday"),user.getLanguage());
String birthdayTo     =Util.fromScreen(request.getParameter("birthdayTo"),user.getLanguage());
String subcompany1    =Util.fromScreen(request.getParameter("subcompany1"),user.getLanguage());
String strResult = "";
boolean isoracle=RecordSet.getDBType().equals("oracle");

if(!department.equals("")&&!department.equals("0")){
	strResult += " and a.departmentid = "+department ;
}
if(!resourcename.equals("")){
	strResult += " and a.lastname like '%"+resourcename +"%' ";
}
if(!sex.equals("")){
	strResult += " and a.sex = '"+sex+"'";
}
if(!startdate.equals("")){
	strResult += " and a.startdate >= '"+startdate+"'";
}
if(!startdateTo.equals("")){
	if(!isoracle){
		strResult += " and a.startdate <= '"+startdateTo+"' and a.startdate<>''";
	}else{ //如果数据库为oracle的话
		strResult += " and a.startdate <= '"+startdateTo+"' and a.startdate is not null";
	}
}
if(!birthday.equals("")){
	strResult += " and a.birthday >= '"+birthday+"'";
}
if(!birthdayTo.equals("")){
	if(!isoracle){
		strResult += " and a.birthday <= '"+birthdayTo+"' and a.birthday<>''";
	}else{ //如果数据库为oracle的话
		strResult += " and a.birthday <= '"+birthdayTo+"' and a.birthday is not null";
	}
}
if(!subcompany1.equals("0")&&!subcompany1.equals("")){
	strResult += " and a.subcompanyid1 = "+subcompany1 ;
}

String sql = "select a.* from HrmResource a,HrmDepartment b,HrmSubcompany c WHERE (a.accounttype is null or a.accounttype=0) and a.departmentid=b.id AND a.subcompanyid1=c.id AND a.status IN (0,1,2,3) AND a.status!=10"+strResult+" ORDER BY  a.dsporder,a.departmentid";
rs.executeSql(sql);
//out.println(sql);
int needchange = 0;
    while(rs.next()){
        String  id = rs.getString("id");
     if(!id.equals("1")){  //过滤系统管理员
        String	departmentid=Util.toScreen(rs.getString("departmentid"),user.getLanguage());
        String	lastname=Util.toScreen(rs.getString("lastname"),user.getLanguage());
       String	mobilecall=Util.toScreen(rs.getString("mobilecall"),user.getLanguage());
        String	telephone=Util.toScreen(rs.getString("telephone"),user.getLanguage());
        String	fax=Util.toScreen(rs.getString("fax"),user.getLanguage());
         //String	mobile=Util.toScreen(rs.getString("mobile"),user.getLanguage());
         String mobile = ResourceComInfo.getMobileShow(id, user) ;
         String	email=Util.toScreen(rs.getString("email"),user.getLanguage());
         String	workroom=Util.toScreen(rs.getString("workroom"),user.getLanguage());
        
        er = es.newExcelRow() ;
		er.addStringValue(Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage()));
		er.addStringValue(lastname) ;
		er.addStringValue(mobilecall) ;
		er.addStringValue(telephone) ;
		er.addStringValue(fax) ;
		er.addStringValue(mobile) ;
		er.addStringValue(workroom) ;
		er.addStringValue(email) ;
		es.addExcelRow(er) ;
		
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
          <TD width="13%"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></TD>
          <TD width="11%"><A HREF="../resource/HrmResource.jsp?id=<%=id%>" target="_blank"><%=Util.toScreen(ResourceComInfo.getResourcename(id),user.getLanguage())%></A></TD>          
          <TD width="15%"><%=telephone%></TD>
           <TD width="15%"><%=fax%> </TD>
           <TD width="15%"><%=mobile%> </TD>
           <TD width="10%"><%=mobilecall%></TD>
           <TD width="6%"><%=workroom%> </TD>
           <TD width="15%"><%=email%> </TD>
  </TR>
<% // if(hasNextPage){
//		totalline+=1;
//		if(totalline>perpage)	break;
//	 }
      }catch(Exception e){
        rs.writeLog(e.toString());
      }
     }//end if
    };
// rs.executeSql("drop table "+temptable);

 ExcelFile.init() ;
 ExcelFile.setFilename(SystemEnv.getHtmlLabelName(1515,user.getLanguage())) ;
 ExcelFile.addSheet(SystemEnv.getHtmlLabelName(1515,user.getLanguage()), es) ;

%>  
 </TBODY></TABLE>
 </td>
 </tr>
  </table>
 </FORM>
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
function onReSearch(){
	location.href="HrmRpContact.jsp";
}
</script>
</BODY>
</HTML>