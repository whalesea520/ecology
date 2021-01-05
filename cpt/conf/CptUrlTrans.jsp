<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%><%
String returnvalue="";
String srctype=Util.null2String(request.getParameter("srctype"));
if("trantxss".equals(srctype)){
	String type = Util.null2String(request.getParameter("type"));
	String notwfid = Util.null2String(request.getParameter("notwfid"));
	String sqlwhere="where isbill=1 and exists ( select 1 from workflow_billfield t2 where t2.billid=workflow_base.formid and t2.fieldhtmltype=3 and t2.type="+type+" and workflow_base.id not in("+notwfid+") and formid not in(14,18,19,201,220,221,222,224) )";
	  if(!"".equals(type)&&!"".equals(notwfid)){
		  returnvalue = xssUtil.put(sqlwhere);
	  }
}

out.println(returnvalue);
%>