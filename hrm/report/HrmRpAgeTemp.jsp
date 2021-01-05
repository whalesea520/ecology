<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="HrmSearchComInfo" class="weaver.hrm.search.HrmSearchComInfo" scope="session" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String whereclause="";

int year=Util.getIntValue(request.getParameter("year"),0);
String[] resourcetypes=Util.TokenizerString2(request.getParameter("resourcetype"),",");
int departmentid=Util.getIntValue(request.getParameter("departmentid"),0);

Calendar today = Calendar.getInstance();
int curyear=today.getTime().getYear()+1900;
int ishead=0;
      if(departmentid==0)	whereclause="";
      else	whereclause=" departmentid="+departmentid;
      if(Util.contains(resourcetypes,"2")){
      	if(whereclause.equals(""))	whereclause=" resourcetype in('2";
      	else	whereclause+=" and resourcetype in('2";
      	ishead=1;
      }
      if(Util.contains(resourcetypes,"1")){
      	if(whereclause.equals(""))	whereclause=" resourcetype in('1";
      	else{
      		if(ishead==0)	whereclause+=" and resourcetype in('1";
      		else	whereclause+="','1";
      	}
      	ishead=1;
      }
      if(Util.contains(resourcetypes,"3")){
      	if(whereclause.equals(""))	whereclause=" resourcetype in('3";
      	else{
      		if(ishead==0)	whereclause+=" and resourcetype in('3";
      		else	whereclause+="','3";
      	}
      	ishead=1;
      }
      if(Util.contains(resourcetypes,"4")){
      	if(whereclause.equals(""))	whereclause=" resourcetype in('4";
      	else{
      		if(ishead==0)	whereclause+=" and resourcetype in('4";
      		else	whereclause+="','4";
      	}
      	ishead=1;
      }
      if(ishead==1)	whereclause+="')";
		
if(year==19){
	if(whereclause.equals(""))	whereclause=" ("+curyear+"-left(birthday,4))<="+year;
	else whereclause+=" and ("+curyear+"-left(birthday,4))<="+year;
}
else if(year==55){
	if(whereclause.equals(""))	whereclause=" (birthday<>'' and birthday is not null) and ("+curyear+"-left(birthday,4))>="+year;
	else whereclause+=" and (birthday<>'' and birthday is not null) and ("+curyear+"-left(birthday,4))>="+year;
}
else if(year==0){
	if(whereclause.equals(""))	whereclause=" (birthday='' or birthday is null)";
	else whereclause+=" and (birthday='' or birthday is null)";
}
else{
	int endyear=year+4;
	if(whereclause.equals(""))	whereclause=" ("+curyear+"-left(birthday,4))>="+year+" and ("+curyear+"-left(birthday,4))<="+endyear;
	else whereclause+=" and ("+curyear+"-left(birthday,4))>="+year+" and ("+curyear+"-left(birthday,4))<="+endyear;
}

HrmSearchComInfo.resetSearchInfo();

HrmSearchComInfo.setResourcesql(whereclause);

HrmSearchComInfo.setOrderby("id");

out.print(whereclause);
int userid=user.getUID();
RecordSet.executeSql("select dspperpage from HrmUserDefine where userid="+userid);
RecordSet.next();
String perpage=RecordSet.getString("dspperpage");
if(perpage.equals(""))	perpage="10";
response.sendRedirect("/hrm/search/HrmResourceSearchResult.jsp?");
%>