<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.conn.ConnStatement,weaver.general.BaseBean,weaver.general.Util" %>
<%@ page import="weaver.ldap.LdapUtil" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
if(!HrmUserVarify.checkUserRight("intergration:ldapsetting", user)){
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
	/*qc401253 修复批量绑定、解绑AD用户时，LDAP会清空数据的bug*/
	String isad = Util.null2String(request.getParameter("isad"));//定义一个标识符,用于区别是批量绑定AD账号/批量撤销AD账号
    if ("1".equals(isad)) {
        rs.executeSql("update HrmResource set isAdAccount = '1' where status<4 and loginid is not null");
    } else if ("0".equals(isad)) {
        rs.executeSql("update HrmResource set isAdAccount = '0' where status<4 and loginid is not null");
		
    }
	response.sendRedirect("/integration/ldapsetting.jsp");
	/*qc401253 修复批量绑定、解绑AD用户时，LDAP会清空数据的bug*/		
%>