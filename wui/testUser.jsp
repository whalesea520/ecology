
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.general.*" %>
<%
    //判断密码强制修改
    String changepwd = (String)request.getSession().getAttribute("changepwd");
    if("n".equals(changepwd)){
        request.getSession().removeAttribute("changepwd");
        response.sendRedirect("/login/Login.jsp");
        return;
    }else if("y".equals(changepwd)){
        request.getSession().removeAttribute("changepwd");
    }


/*用户验证*/
    User user = HrmUserVarify.getUser (request , response) ;
    if(user==null) {
        response.sendRedirect("/login/Login.jsp");
        return;
    }
    String from = Util.null2String(request.getParameter("from"));
    if("preview".equals(from))
        session.removeAttribute("SESSION_CURRENT_THEME");
%>

<script language="JavaScript">
    function doSubmit() {
        var username  = "<%=user.getLoginid()%>";//获取用户名
        var password  = "<%=user.getPwd()%>";//获取密码
		alert("http://localhost:9091/imooc_students/users/Users_login_success.jsp?username="+username+"&password="+password);
        window.location.href="http://localhost:9091/imooc_students/users/Users_login_success.jsp?username="+username+"&password="+password;
		
    }
</script>

<html>
<body>
<table>
    <tr>
        <td width="30%">用户名：</td>
        <td><%=user.getLoginid()%></td>
    </tr>
    <tr>
        <td width="30%">密码：</td>
        <td><%=user.getPwd()%></td>
    </tr>
    <tr>
        <td width="30%"><input type="submit" onclick="doSubmit()" value="跳转"/></td>
    </tr>
</table>
</body>
</html>
