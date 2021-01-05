
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%

String basicsalary = Util.fromScreen(request.getParameter("basicsalary"),user.getLanguage());
String overtimepara = Util.fromScreen(request.getParameter("overtimepara"),user.getLanguage());
String receptionpara = Util.fromScreen(request.getParameter("receptionpara"),user.getLanguage());
String basicKM=Util.fromScreen(request.getParameter("basicKM"),user.getLanguage());
String basicKMpara = Util.fromScreen(request.getParameter("basicKMpara"),user.getLanguage());
String basictime=Util.fromScreen(request.getParameter("basictime"),user.getLanguage());
String basictimepara = Util.fromScreen(request.getParameter("basictimepara"),user.getLanguage());
String basicout=Util.fromScreen(request.getParameter("basicout"),user.getLanguage());
String basicoutpara = Util.fromScreen(request.getParameter("basicoutpara"),user.getLanguage());
String publicpara = Util.fromScreen(request.getParameter("publicpara"),user.getLanguage());

if(basicsalary.equals(""))  basicsalary="0";
if(overtimepara.equals(""))  overtimepara="0";
if(receptionpara.equals(""))  receptionpara="0";
if(basicKM.equals(""))  basicKM="0";
if(basicKMpara.equals(""))  basicKMpara="0";
if(basictime.equals(""))  basictime="0";
if(basictimepara.equals(""))  basictimepara="0";
if(basicout.equals(""))  basicout="0";
if(basicoutpara.equals(""))  basicoutpara="0";
if(publicpara.equals(""))  publicpara="0";

char flag = Util.getSeparator() ;
String para = basicsalary + flag + overtimepara + flag + receptionpara + flag + basicKM + flag + basicKMpara + 
              flag + basictime + flag + basictimepara + flag + basicout + flag + basicoutpara + flag + publicpara;
RecordSet.executeProc("CarDriverBasicinfo_Insert",para);
response.sendRedirect("CarDriverBasicinfo.jsp");
%>
