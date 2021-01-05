<%@ page language="java" import="java.util.*" pageEncoding="GBK"%>
<jsp:useBean id="HandwrittenSignatureManager" class="weaver.mobile.webservices.workflow.soa.HandwrittenSignatureManager" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
 <%
 			//选中对应的签章验证该签章的密码
 		    boolean flag = false;
 			int markId=0;
  			String markNameId = request.getParameter("markNameId");
  			String password = request.getParameter("markNamePwd");
  			String  sql = "select * from HandwrittenSignature where markId = "+markNameId+" and password = "+password+"";
  			rs.executeSql(sql);
  			if(rs.next()){
  				//markPath = rs.getString("markPath");
  				markId = rs.getInt("markId");
  				//markPath = markPath.replaceAll("\\\\","\\\\\\\\");
  				flag = true;
  			}
//	  		out.println("({flag:"+flag+",markPath:\""+markPath+"\"})");
	  		out.println("({flag:"+flag+",markId:"+markId+"})");
%>
