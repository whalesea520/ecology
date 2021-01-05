
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.wechat.receive.BandVerifyAction"%>
<%
String operate=request.getParameter("operate");
if("band".equals(operate)){//绑定
	
	String username=request.getParameter("username");
	String pwd=request.getParameter("pwd");
	String openid=request.getParameter("openid");
	String state=request.getParameter("state");
	String usertype=request.getParameter("usertype");
	String target=request.getParameter("target");
	if(!"".equals(username)&&!"".equals(pwd)){
		if(BandVerifyAction.verifyLogin(username, pwd,usertype, openid,state)){
			rs.execute("select id,userid,usertype from wechat_band where publicid='"+state+"' and openid='"+openid+"'");
		    if(rs.next()){
				response.sendRedirect("bandInfo.jsp?target="+target+"&id="+rs.getInt("id")+"&userid="+rs.getInt("userid")+"&usertype="+rs.getInt("usertype"));
		    }
		}else{
		      response.sendRedirect("result.jsp?type=band&msg=error");
		}
	}else{
		response.sendRedirect("result.jsp?type=band&msg=error");
	}
}else if("cancelBand".equals(operate)){//解绑
	String id=request.getParameter("id");
	if(BandVerifyAction.cancelBand(id)){
	 	response.sendRedirect("result.jsp?type=cancelBand&msg=success");
	}else{
		response.sendRedirect("result.jsp?type=cancelBand&msg=error");
	}	
}else{
	response.sendRedirect("result.jsp?type=system&msg=operate");
}
%>