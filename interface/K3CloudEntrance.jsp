<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="weaver.conn.RecordSet" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />


<%
    String sysid = Util.null2String(request.getParameter("id"));//系统标识
    String uid = Util.null2String(request.getParameter("uid"));
    //k3server,dbid,appid,lcid为固定值
    //username,appsecret为用户录入
    String k3server = "";
    String dbid = "";
    String username = "";
    String appid = "";
    String appsecret = "";
    String timestamp = "";
    String lcid = "";
    String k3Sql = "select * from outter_sysparam where sysid ='"+ sysid +"'";
    RecordSet rs = new RecordSet();
    rs.executeSql(k3Sql);
    while (rs.next()) {
        String paramname = rs.getString("paramname");
        if (paramname.equals("k3server")){
            k3server = rs.getString("paramvalue");
        }else if(paramname.equals("dbid")) {
            dbid = rs.getString("paramvalue");
        }else if(paramname.equals("appid")) {
            appid = rs.getString("paramvalue");
        }else if (paramname.equals("lcid")){
           lcid = rs.getString("paramvalue");
        }else if (paramname.equals("appsecret")) {
            appsecret = rs.getString("paramvalue");
        }
    }

    //获取用户录入的数据
//    RecordSet userDataRS = new RecordSet();
//    String userDataSql = "select * from outter_params where sysid='"+sysid+"'"+ "and userid='"+uid+"'";
//    userDataRS.executeSql(userDataSql);
//    while (userDataRS.next()) {
//        String paramname = userDataRS.getString("paramname");
//        if (paramname.equals("username")) {
//            username = userDataRS.getString("paramvalue");
//        }
//    }
    timestamp = Long.toString(System.currentTimeMillis() / 1000);
    boolean urlIsRight = K3Utils.checkK3CloudUrl(k3server, dbid,  user.getLoginid(), appid, appsecret, timestamp, lcid);
    if (urlIsRight) {
        String k3CloudUrl = K3Utils.getK3CloudUrl(k3server,dbid,  user.getLoginid(), appid, appsecret, timestamp, lcid);
        response.sendRedirect(k3CloudUrl);
    }else {

//        response.sendError(503, "单点登录信息不完整");
    }


%>

