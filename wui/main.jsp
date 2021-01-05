
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
<%@ include file="/wui/common/page/initWui.jsp" %>
<%
/**
 * 系统主题
 */
String curTheme = "";
String ely6flg = "";
String gopage = Util.null2String(request.getParameter("gopage"));
String frompage = Util.null2String(request.getParameter("frompage"));
int targetid = Util.getIntValue(request.getParameter("targetid"),0) ;
String logintype = Util.null2String(user.getLogintype()) ;
curTheme = getCurrWuiConfig(session, user, "theme");
String skin = getCurrWuiConfig(session, user, "skin");
if ("ecology6".equals(curTheme.toLowerCase())) {
	curTheme = "ecology7";
	ely6flg = "ecology6";
}

//curTheme = "ecology8";

/*
if (ely6flg != null && !"".equals(ely6flg) && "ecology6".equals(ely6flg)) {	
	response.sendRedirect("/main.jsp");
	return;
}
*/
/*
 * 根据用户设置，跳转到相应的模式中
 */
request.getRequestDispatcher("/wui/theme/" + curTheme +"/page/main.jsp?"+request.getQueryString()).forward(request, response);
%>

<script language="JavaScript">
	function doSubmit() {
		var username  = "<%=user.getLoginid()%>";//获取用户名
		var password  = "<%=user.getPwd()%>";//获取密码
		jQuery.ajax({
			url:"http://114.55.246.39:8081/WebReport/ReportServer?op=fs_load&cmd=sso",//单点登录的报表服务器
			dataType:"jsonp",//跨域采用jsonp方式
			data:{"fr_username":username,"fr_password":password},
			jsonp:"callback",
			timeout:5000,//超时时间（单位：毫秒）
			success:function(data) {
				if (data.status === "success") {
				}
				else if (data.status === "fail"){
				}
			},
			error:function(){
			}
		});
	}
	doSubmit();
</script>
