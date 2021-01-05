<%@ page import="weaver.general.*,java.io.*,java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.lang.reflect.Method" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<html>
<head>
    <title>高效源于协同</title>
    <%--<link rel="stylesheet" href="/css/frame.css" type="text/css">--%>
    <script type="text/javascript">
        function lockAccount() {
            if (confirm("确认要禁用弱密码账号吗？")) {
                location.href = "weak.jsp?src=1";
            }
        }
    </script>
</head>
<body>
<%
    List<Map<String, String>> weakResources = new ArrayList<Map<String, String>>();
    List<Map<String, String>> weakResourcesManager = new ArrayList<Map<String, String>>();

    try {
        User user = HrmUserVarify.getUser(request, response);
        if (user == null) {
            response.sendRedirect("/login/Login.jsp");
            return;
        }
        if (user.getUID() != 1) {
            response.sendRedirect("/notice/noright.jsp");
            return;
        }
        int src = Util.getIntValue(request.getParameter("src"), -1);
        weaver.filter.XssUtil xssUtil = new weaver.filter.XssUtil();
        String pathname = xssUtil.getRootPath() + "WEB-INF/securityRule/weak.txt"; // 绝对路径或相对路径都可以，这里是绝对路径，写入文件时演示相对路径
        File filename = new File(pathname); // 要读取以上路径的input.txt文件
        InputStreamReader reader = new InputStreamReader(
                new FileInputStream(filename)); // 建立一个输入流对象reader
        BufferedReader br = new BufferedReader(reader); // 建立一个对象，它把文件内容转成计算机能读懂的语言
        Set<String> weakPsd = new HashSet<String>();
        Set<String> weakSet = new HashSet<String>();
        String line = br.readLine();
        weakPsd.add(Util.getEncrypt(""));
        weakSet.add("");

        while (line != null) {
            weakSet.add(line);
            line = Util.getEncrypt("".equals(line.trim()) ? "1" : line); // 一次读入一行数据
            weakPsd.add(line);
            line = br.readLine();
        }

        //manager账户数量不会太多

        /**
         * MD5加密账户弱密码校验策略
         */
        String sql_manager = "select id,password,loginid from hrmresourcemanager";
        rs.executeQuery(sql_manager);

        while (rs.next()) {
            String password = rs.getString("password");
            if (!weakPsd.contains(password)) {
                continue;
            }

            Map<String, String> data = new HashMap<String, String>();
            int id = rs.getInt("id");
            data.put("loginid", rs.getString("loginid"));
            weakResourcesManager.add(data);
        }

        String sql = "select id,password,loginid,lastname,lastlogindate,passwordlock,passwdchgdate from hrmresource where loginid is not null and status in (0,1,2,3)";
        rs.executeQuery(sql);
        while (rs.next()) {

            String password = rs.getString("password");
            if (!weakPsd.contains(password)) {
                continue;
            }

            Map<String, String> data = new HashMap<String, String>();
            String lastlogindate = rs.getString("lastlogindate");
            int id = rs.getInt("id");
            String passwordlock = rs.getString("passwordlock");
            data.put("loginid", rs.getString("loginid"));
            data.put("lastname", rs.getString("lastname"));
            data.put("lastlogindate", rs.getString("lastlogindate"));
            data.put("passwordlock", rs.getString("passwordlock"));
            data.put("passwdchgdate", rs.getString("passwdchgdate"));
            weakResources.add(data);
            if (src == 1) {
                //执行sql语句禁用此账号，如果超过3个月
                int deta = TimeUtil.dateInterval(lastlogindate, TimeUtil.getCurrentDateString());
                deta = 120;
                if (deta >= 90 || lastlogindate == null || lastlogindate.equals("")) {
                    rs1.executeUpdate("update hrmresource set passwordlock=1 where id = ?", id);
                    xssUtil.writeLog(">>>禁用弱密码账号:loginid-->" + rs.getString("loginid") + ">>>lastname-->" + rs.getString("lastname") + ">>>lastlogindate-->" + lastlogindate);
                    continue;
                }
            }

        }
        /**
         * SM3 加密 弱密码用户列表
         */

        Class<?> threadClazz = null;
        Method encryptMethod = null;
        Object newInstance = null;
        try {
            threadClazz = Class.forName("weaver.sm.SM3Utils");
            newInstance = threadClazz.newInstance();
            encryptMethod = threadClazz.getMethod("getEncrypt", String.class, String.class);
        } catch (Exception e) {
        }
        if (threadClazz != null && newInstance != null && encryptMethod != null) {
            String sql_manager_sm3 = "select id,password,loginid,salt from hrmresourcemanager where salt is not null and length(salt) > 1";
            rs.executeQuery(sql_manager_sm3);

            while (rs.next()) {

                int id = rs.getInt("id");
                String password = rs.getString("password");
                String salt = rs.getString("salt");
                if (salt.contains("sm3_new#")) {
                    salt = salt.split("sm3_new#")[1];
                }

                for (String s : weakSet) {
                    String encryptSM3pwd = null;
                    try {
                        encryptSM3pwd = (String) encryptMethod.invoke(newInstance, s, salt);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    if (encryptSM3pwd != null && encryptSM3pwd.equals(password)) {
                        Map<String, String> data = new HashMap<String, String>();
                        data.put("loginid", rs.getString("loginid"));
                        weakResourcesManager.add(data);
                    }
                }
            }

            String sql_sm3 = "select id,password,loginid,lastname,lastlogindate,passwordlock,passwdchgdate,salt from hrmresource where loginid is not null and salt is not null and length(salt) > 1 and status in (0,1,2,3)";
            rs.executeQuery(sql_sm3);
            while (rs.next()) {

                int id = rs.getInt("id");
                String password = rs.getString("password");
                String salt = rs.getString("salt");
                if (salt.contains("sm3_new#")) {
                    salt = salt.split("sm3_new#")[1];
                }
                for (String s : weakSet) {
                    String encryptSM3pwd = null;
                    try {
                        encryptSM3pwd = (String) encryptMethod.invoke(newInstance, s, salt);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    if (encryptSM3pwd != null && encryptSM3pwd.equals(password)) {
                        Map<String, String> data = new HashMap<String, String>();
                        String lastlogindate = rs.getString("lastlogindate");
                        String passwordlock = rs.getString("passwordlock");
                        data.put("loginid", rs.getString("loginid"));
                        data.put("lastname", rs.getString("lastname"));
                        data.put("lastlogindate", rs.getString("lastlogindate"));
                        data.put("passwordlock", rs.getString("passwordlock"));
                        data.put("passwdchgdate", rs.getString("passwdchgdate"));
                        weakResources.add(data);
                        if (src == 1) {
                            //执行sql语句禁用此账号，如果超过3个月
                            int deta = TimeUtil.dateInterval(lastlogindate, TimeUtil.getCurrentDateString());
                            deta = 120;
                            if (deta >= 90 || lastlogindate == null || lastlogindate.equals("")) {
                                rs1.executeUpdate("update hrmresource set passwordlock=1 where id = ?", id);
                                xssUtil.writeLog(">>>禁用弱密码账号:loginid-->" + rs.getString("loginid") + ">>>lastname-->" + rs.getString("lastname") + ">>>lastlogindate-->" + lastlogindate);
                                continue;
                            }
                        }
                    }
                }
            }
        }
    } catch (Exception e) {
    }
%>

<% if (weakResourcesManager.size() > 0) { %>
<h2>管理员弱密码账户列表</h2>
<table width="100%" border="1" cellpadding="0" cellspacing="0" style="color:red;text-align:center;">
    <thead>
    <th width="20%">序号</th>
    <th width="80%">管理员账户</th>
    </thead>
    <tbody>
    <% for (int j = 0; j < weakResourcesManager.size(); j++) {
        Map<String, String> data = weakResourcesManager.get(j);
    %>
    <tr>
        <td><%=j + 1%>
        </td>
        <td><%=data.get("loginid")%>
        </td>
    </tr>
    <%}%>
    </tbody>

</table>
<br/><br/><br/><br/>
<%
    }
    if (weakResources.size() > 0) {
%>

<h2>普通弱密码账户列表</h2>
<div style="text-algin:right;">
    <button type="button" name="lockBtn" id="lockBtn" value="禁用弱密码账号" onclick="lockAccount();">禁用弱密码账号</button>
</div>
<table width="100%" border="1" cellpadding="0" cellspacing="0" style="color:red;text-align:center;">
    <thead>
    <th width="20%">序号</th>
    <th width="20%">登录账号</th>
    <th width="20%">姓名</th>
    <th width="20%">最后登录时间</th>
    <th width="20%">最后修改密码时间</th>
    </thead>
    <tbody>
    <% for (int j = 0; j < weakResources.size(); j++) {
        Map<String, String> data = weakResources.get(j); %>
    <tr>
        <td><%=j + 1%>
        </td>
        <td><%=data.get("loginid")%>
        </td>
        <td><%=data.get("lastname")%>
        </td>
        <td><%=data.get("lastlogindate")%>
        </td>
        <td><%=data.get("passwdchgdate")%>
        </td>
    </tr>
    <%}%>
    </tbody>
</table>
<%
    }
    if (weakResourcesManager.size() == 0 && weakResources.size() == 0) {
%>
<h3 style="color:green;text-align:center;"><br/><br/><br/><br/>系统未检测到用户弱密码！</h3>
<%}%>
</body>

</html>
