<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.*" %>
<%@page import="java.net.*"%>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.*"%>
<%@ page import="weaver.cowork.*"%>
<%@ page import="weaver.file.FileUpload" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CoTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page" />
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");

FileUpload fu = new FileUpload(request);
int userid=Util.getIntValue(fu.getParameter("userid"));
String module = Util.null2String((String)fu.getParameter("module"));
String scope = Util.null2String((String)fu.getParameter("scope"));

int pageIndex = Util.getIntValue(fu.getParameter("pageindex"), 1);
int pageSize = Util.getIntValue(fu.getParameter("pagesize"), 10);

String titleurl = Util.null2String((String)request.getParameter("title"));
String title = URLDecoder.decode(titleurl,"UTF-8");

String clienttype = Util.null2String((String)fu.getParameter("clienttype"));
String clientlevel = Util.null2String((String)fu.getParameter("clientlevel"));

String keyword = Util.null2String(fu.getParameter("keyword"));
int labelid = Util.getIntValue(fu.getParameter("labelid"), 0);

%>
				<jsp:include page="CoworkOperation.jsp">
					<jsp:param value="getCoworkList" name="operation"/>
					<jsp:param value="<%=keyword%>" name="keyword"/>
					<jsp:param value="<%=labelid%>" name="labelid"/>
					<jsp:param value="<%=pageIndex%>" name="pageindex"/>
					<jsp:param value="<%=pageSize%>" name="pagesize"/>
					<jsp:param value="<%=userid%>" name="userid"/>
				</jsp:include>
	