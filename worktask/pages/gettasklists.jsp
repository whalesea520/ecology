
<%@ page language="java" contentType="application/json;charset=UTF-8" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.*,weaver.conn.*,org.json.*,java.math.*,java.text.*,java.util.*,weaver.worktask.worktask.*"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager,
                 weaver.docs.docs.FieldParam,
                 weaver.systeminfo.SystemEnv" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="taskManager" class="weaver.worktask.request.TaskManager" scope="page"/>

<%
out.clearBuffer();
String userid = request.getParameter("userid");
String selfitemdata = WorkTaskResourceUtil.getTasksAsJsonByUserid(userid);
out.println(selfitemdata);
%>