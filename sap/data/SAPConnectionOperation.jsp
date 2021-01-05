<%@page import="com.sap.mw.jco.JCO"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	String operation = Util.null2String(request.getParameter("operation"));
	String code = Util.null2String(request.getParameter("code"));
	String hostname = Util.null2String(request.getParameter("hostname"));
	String sapclient = Util.null2String(request.getParameter("sapclient"));
	String userid = Util.null2String(request.getParameter("userid"));
	String password = Util.null2String(request.getParameter("password"));
	String language = Util.null2String(request.getParameter("language"));
	String systemnumber = Util.null2String(request.getParameter("systemnumber"));

	if ("add".equals(operation)) {
		RecordSet.execute("select * from SAPCONN where code = '" + code	+ "'");
		if (RecordSet.next()) {
			request.getRequestDispatcher("/sap/data/SAPConnectionNew.jsp?errorcode=101").forward(request, response);
			return;
		}
		RecordSet.execute("insert into SAPCONN(code,hostname,sapclient,userid,password,language,systemnumber) values('"
						+ code + "','" + hostname + "','" + sapclient + "','" + userid + "','" + password + "','"
						+ language + "','" + systemnumber + "')");
	} else if ("edit".equals(operation)) {
		String _code = Util.null2String(request.getParameter("_code"));
		if (!_code.equals(code)) {
			RecordSet.execute("select * from SAPCONN where code = '"+ code + "'");
			if (RecordSet.next()) {
				request.getRequestDispatcher("/sap/data/SAPConnectionNew.jsp?errorcode=101").forward(request, response);
				return;
			}
		}
		RecordSet.execute("update SAPCONN set code='" + code
				+ "',hostname='" + hostname + "',sapclient='"
				+ sapclient + "',userid='" + userid + "',password='"
				+ password + "',language='" + language
				+ "',systemnumber='" + systemnumber
				+ "' where code = '" + _code + "'");
				
		//清除连接池中的该项连接配置，以便启用新的连接池的配置，这样可以防止重启服务的麻烦
		//对应这个文件/src/weaver/interfaces/sap/SAPConn.java
		JCO.removeClientPool("Pool");		
		if(!"".equals(code)&&null!=code){
			JCO.removeClientPool(code);		
		}	  
	} else if ("delete".equals(operation)) {
		RecordSet.execute("delete from SAPCONN where code='" + code
				+ "'");
	} else if ("default".equals(operation)) {
		RecordSet.execute("update SAPCONN set isdefault = 2");
		RecordSet
				.execute("update sapconn set isdefault = 1 where code='"
						+ code + "'");
	}
	response.sendRedirect("/sap/data/SAPConnection.jsp");
%>