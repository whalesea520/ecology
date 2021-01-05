
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;
%>

<%
    String srcPath = Util.null2String(request.getParameter("srcPath"));
    String targetPath = Util.null2String(request.getParameter("targetPath"));
    String strSql = "";
    String strSqlMoudle = "";
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<META http-equiv=Content-Type content="text/html; charset=UTF-8">
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<BODY>
<%
    out.println("&nbsp;&nbsp;正在执行更改,请稍候...");
    if(RecordSet.getDBType().equals("oracle")){
         strSql = "update imagefile set filerealpath = REPLACE(filerealpath,'" + srcPath + "','" + targetPath +"')";
         strSqlMoudle = "update DocMouldFile set mouldpath = REPLACE(mouldpath,'" + srcPath + "','" + targetPath +"')";
    } else {
         strSql = "update imagefile set filerealpath = REPLACE(filerealpath,'" + srcPath + "','" + targetPath +"')";
         strSqlMoudle = "update DocMouldFile set mouldpath = REPLACE(mouldpath,'" + srcPath + "','" + targetPath +"')";
    }
    RecordSet.writeLog("Execute update imagefile is "+strSql);
   RecordSet.writeLog("Execute update DocMouldFile is "+strSqlMoudle);
    if (RecordSet.executeSql(strSql)&&RecordSet.executeSql(strSqlMoudle)){
        out.println("<br>&nbsp;&nbsp;更改完成!若需继续请点<a href=SystemFilePathChange.jsp>这里</a>,若需进入系统请点<a href=/index.htm>这里</a>.");        
    } else {
        out.println("<br>&nbsp;&nbsp;<font color='red'>命令执行不成功,请检查系统!</font>");
        RecordSet.writeLog("执行语句: "+ strSql +"   不成功");
    }
%>

</BODY>
</HTML>