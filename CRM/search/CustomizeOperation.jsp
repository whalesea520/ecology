
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%
String CurrentUser = ""+user.getUID();
String logintype = ""+user.getLogintype();

String method = Util.fromScreen(request.getParameter("method"),user.getLanguage());

String row1col1 = Util.fromScreen(request.getParameter("row1col1"),user.getLanguage());
String row1col2 = Util.fromScreen(request.getParameter("row1col2"),user.getLanguage());
String row1col3 = Util.fromScreen(request.getParameter("row1col3"),user.getLanguage());
String row1col4 = Util.fromScreen(request.getParameter("row1col4"),user.getLanguage());
String row1col5 = Util.fromScreen(request.getParameter("row1col5"),user.getLanguage());
String row1col6 = Util.fromScreen(request.getParameter("row1col6"),user.getLanguage());
String row2col1 = Util.fromScreen(request.getParameter("row2col1"),user.getLanguage());
String row2col2 = Util.fromScreen(request.getParameter("row2col2"),user.getLanguage());
String row2col3 = Util.fromScreen(request.getParameter("row2col3"),user.getLanguage());
String row2col4 = Util.fromScreen(request.getParameter("row2col4"),user.getLanguage());
String row2col5 = Util.fromScreen(request.getParameter("row2col5"),user.getLanguage());
String row2col6 = Util.fromScreen(request.getParameter("row2col6"),user.getLanguage());
String row3col1 = Util.fromScreen(request.getParameter("row3col1"),user.getLanguage());
String row3col2 = Util.fromScreen(request.getParameter("row3col2"),user.getLanguage());
String row3col3 = Util.fromScreen(request.getParameter("row3col3"),user.getLanguage());
String row3col4 = Util.fromScreen(request.getParameter("row3col4"),user.getLanguage());
String row3col5 = Util.fromScreen(request.getParameter("row3col5"),user.getLanguage());
String row3col6 = Util.fromScreen(request.getParameter("row3col6"),user.getLanguage());
//add by xhheng @20050118 for TD 1345
int perpage=Util.getIntValue(Util.null2String(request.getParameter("PERPAGE")),0);

String ProcPara = "";
char flag = 2;
if(method.equals("update"))
{
	ProcPara = CurrentUser;
	ProcPara += flag+logintype;
	ProcPara += flag+row1col1;
	ProcPara += flag+row1col2;
	ProcPara += flag+row1col3;
	ProcPara += flag+row1col4;
	ProcPara += flag+row1col5;
	ProcPara += flag+row1col6;
	ProcPara += flag+row2col1;
	ProcPara += flag+row2col2;
	ProcPara += flag+row2col3;
	ProcPara += flag+row2col4;
	ProcPara += flag+row2col5;
	ProcPara += flag+row2col6;
	ProcPara += flag+row3col1;
	ProcPara += flag+row3col2;
	ProcPara += flag+row3col3;
	ProcPara += flag+row3col4;
	ProcPara += flag+row3col5;
	ProcPara += flag+row3col6;
  //add by xhheng @20050118 for TD 1345
  ProcPara += flag+(new Integer(perpage)).toString();
	RecordSet.executeProc("CRM_Customize_Update",ProcPara);
}
else
{
	ProcPara = CurrentUser;
	ProcPara += flag+logintype;
	ProcPara += flag+row1col1;
	ProcPara += flag+row1col2;
	ProcPara += flag+row1col3;
	ProcPara += flag+row1col4;
	ProcPara += flag+row1col5;
	ProcPara += flag+row1col6;
	ProcPara += flag+row2col1;
	ProcPara += flag+row2col2;
	ProcPara += flag+row2col3;
	ProcPara += flag+row2col4;
	ProcPara += flag+row2col5;
	ProcPara += flag+row2col6;
	ProcPara += flag+row3col1;
	ProcPara += flag+row3col2;
	ProcPara += flag+row3col3;
	ProcPara += flag+row3col4;
	ProcPara += flag+row3col5;
	ProcPara += flag+row3col6;
  //add by xhheng @20050118 for TD 1345
  ProcPara += flag+(new Integer(perpage)).toString();
	RecordSet.executeProc("CRM_Customize_Insert",ProcPara);
}

response.sendRedirect("/CRM/search/Customize.jsp");
%>
