<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="HrmSearchComInfo" class="weaver.hrm.search.HrmSearchComInfo" scope="session" />
<%
String whereclause="";
String orderclause=" order by id";

int year=Util.getIntValue(request.getParameter("year"),0);
String[] resourcetypes=Util.TokenizerString2(request.getParameter("resourcetype"),",");
int departmentid=Util.getIntValue(request.getParameter("departmentid"),0);
int seclevel=Util.getIntValue(request.getParameter("seclevel"),0);
int activestatus=Util.getIntValue(request.getParameter("activestatus"),0);

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
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

      if(activestatus==1){//活跃
      		if(whereclause.equals(""))	whereclause=" (('"+currentdate+"'>startdate or (startdate='' or startdate is null)) and ('"+currentdate+"'<enddate or (enddate='' or enddate is null)))";
      		else whereclause+=" and (('"+currentdate+"'>startdate or (startdate='' or startdate is null)) and ('"+currentdate+"'<enddate or (enddate='' or enddate is null)))";
      }
      if(activestatus==2){//不活跃
      		if(whereclause.equals(""))	whereclause=" (('"+currentdate+"'<startdate and (startdate<>'' and startdate is not null)) or ('"+currentdate+"'>enddate and (enddate<>'' and enddate is not null)))";
      		else whereclause+=" and (('"+currentdate+"'<startdate and (startdate<>'' and startdate is not null)) or ('"+currentdate+"'>enddate and (enddate<>'' and enddate is not null)))";
      }
      
if(whereclause.equals(""))	whereclause+=" seclevel="+seclevel;
else	whereclause+=" and seclevel="+seclevel;

HrmSearchComInfo.resetSearchInfo();

HrmSearchComInfo.setResourcesql(whereclause);

HrmSearchComInfo.setOrderby("id");

out.print(whereclause);
response.sendRedirect("/hrm/search/HrmResourceSearchResult.jsp?hassql=1");
%>