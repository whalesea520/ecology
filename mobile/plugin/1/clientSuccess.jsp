
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.*" %>
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");
String error = Util.null2String(request.getParameter("error"));
%>

<html><head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="author" content="Weaver E-Mobile Dev Group" />
    <meta name="description" content="Weaver E-mobile" />
    <meta name="keywords" content="weaver,e-mobile" />
    <meta name="viewport" content="width=device-width,minimum-scale=1.0, maximum-scale=1.0" />
    <title></title>
</head>
<script type="text/javascript">
    function submitResult(){
        var error = "<%=error%>";        
        if(error != ""){
            error = "error:" + error;
            return error;
        }
        var url = "true:success";
        return url;
    }
</script>
</html>