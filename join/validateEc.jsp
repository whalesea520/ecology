<%@ page import="com.alibaba.fastjson.JSONObject,weaver.general.BaseBean,weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.lang.reflect.InvocationTargetException" %>
<%@ page import="java.lang.reflect.Method" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<%
    List<Map<String, String>> weakResources = new ArrayList<Map<String, String>>();
    List<Map<String, String>> weakResourcesManager = new ArrayList<Map<String, String>>();
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

    String sql = "select id,password,loginid,lastname,lastlogindate,passwordlock,passwdchgdate,salt from hrmresource where loginid is not null and status in (0,1,2,3)";
    rs.executeQuery(sql);
    while (rs.next()) {

        String password = rs.getString("password");
        if (!weakPsd.contains(password)) {
            continue;
        }

        Map<String, String> data = new HashMap<String, String>();
        data.put("loginid", rs.getString("loginid"));
        weakResources.add(data);

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
                } catch (IllegalAccessException e) {
                    e.printStackTrace();
                } catch (InvocationTargetException e) {
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
                } catch (IllegalAccessException e) {
                    e.printStackTrace();
                } catch (InvocationTargetException e) {
                    e.printStackTrace();
                }
                if (encryptSM3pwd != null && encryptSM3pwd.equals(password)) {
                    Map<String, String> data = new HashMap<String, String>();
                    data.put("loginid", rs.getString("loginid"));
                    weakResources.add(data);
                }
            }
        }
    }


    JSONObject jsonObject = new JSONObject();
    if (weakResources.size() > 0 || weakResourcesManager.size() > 0) {
        jsonObject.put("status", "1");
    } else {
        jsonObject.put("status", "0");
    }
    out.println(jsonObject.toJSONString());

%>
