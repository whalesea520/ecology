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
int joblevel=Util.getIntValue(request.getParameter("joblevel"),0);

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
		
if(whereclause.equals(""))	whereclause+=" joblevel="+joblevel;
else	whereclause+=" and joblevel="+joblevel;

HrmSearchComInfo.resetSearchInfo();

HrmSearchComInfo.setResourcesql(whereclause);

HrmSearchComInfo.setOrderby("id");

out.print(whereclause);
response.sendRedirect("/hrm/search/HrmResourceSearchResult.jsp?hassql=1");
%>