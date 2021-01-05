<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="java.text.SimpleDateFormat" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="PrjTimeAndWorkdayUtil" class="weaver.proj.util.PrjTimeAndWorkdayUtil" scope="page" />
<%

String totalbegindate=Util.null2String(request.getParameter("totalbegindate"));
String totalenddate=Util.null2String(request.getParameter("totalenddate"));
String totalactualbegindate=Util.null2String(request.getParameter("totalactualbegindate"));
String totalactualenddate=Util.null2String(request.getParameter("totalactualenddate"));
String ProjID=Util.null2String(request.getParameter("ProjID"));
String version = Util.null2String(request.getParameter("version"));
String totalworkday = "";
String totalworkday1 = "";
String totalworkday2 = "";

Map<String,String> result = PrjTimeAndWorkdayUtil.getTimeForProj(totalbegindate,totalenddate,totalactualbegindate,totalactualenddate,ProjID,version);
totalworkday1 = result.get("totalworkday1");
totalworkday2 = result.get("totalworkday2");
totalworkday = totalworkday1+"/"+totalworkday2;
%>

<%=totalworkday %>

