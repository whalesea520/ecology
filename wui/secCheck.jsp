<%--
  Created by IntelliJ IDEA.
  User: zhangfeng
  Date: 2019/5/31
  Time: 13:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page
        import="org.dom4j.Document,org.dom4j.Element,org.dom4j.io.SAXReader,weaver.conn.RecordSet,weaver.filter.SecurityCheckList,weaver.general.Util,weaver.hrm.User" %>
<%@ page import="weaver.hrm.settings.ChgPasswdReminder" %>
<%@ page import="weaver.hrm.settings.RemindSettings" %>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.charset.Charset" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.jar.JarEntry" %>
<%@ page import="java.util.jar.JarFile" %>
<%@ page import="weaver.hrm.*,java.util.Properties" %>
<%@ page import="java.lang.reflect.InvocationTargetException" %>
<%@ page import="java.lang.reflect.Method" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="xssutil" class="weaver.filter.XssUtil"></jsp:useBean>
<jsp:useBean id="csui" class="weaver.filter.msg.CheckSecurityUpdateInfo"></jsp:useBean>

<%
    User user = (User) session.getAttribute("weaver_user@bean");
    if (user == null || !"sysadmin".equals(user.getLoginid())) {
        out.println("请使用管理员权限查看");
        return;
    }
%>

<html>
<title>一键巡检</title>
<body>
<table width="100%" border="1" cellpadding="0" cellspacing="0" style="text-align:center;">
    <thead>
    <th width="20%">检查项</th>
    <th width="20%">检查结果</th>
    <th width="60%">详情及处置意见</th>
    </thead>
    <tbody>

    <%!
        private long getVersion(String fileuploadPath) throws IOException {
            String path = this.getClass().getResource(fileuploadPath).getPath();
            if (path == null) {
                return -1;
            }

            Properties props = System.getProperties();
            String Osname = props.getProperty("os.name");
            if (Osname.contains("Windows")) {
                path = path.substring("file:/".length(), path.indexOf("jar") + "jar".length());
            } else {
                path = path.substring("file:".length(), path.indexOf("jar") + "jar".length());
            }
            JarFile jarFileFileupload = new JarFile(path);
            long version = 0;
            Enumeration<JarEntry> enume = jarFileFileupload.entries();

            while (enume.hasMoreElements()) {
                JarEntry entry = enume.nextElement();
                if ("META-INF/MANIFEST.MF".equals(entry.getName())) {
                    InputStream input = jarFileFileupload.getInputStream(entry);
                    BufferedReader readerMF = new BufferedReader(new InputStreamReader(input));
                    String line = readerMF.readLine();
                    while (null != line) {
                        if (line.contains("Implementation-Version:")) {
                            String versionNow = line.substring(line.lastIndexOf("Implementation-Version:") + "Implementation-Version:".length());
                            long versionNowInt = 0;
                            String[] tmps = versionNow.trim().split("\\.");
                            if (1 == tmps.length) {
                                int i = 12 - tmps[0].length();
                                while (0 < i) {
                                    tmps[0] += "0";
                                    i--;
                                }
                                versionNowInt = Long.parseLong(tmps[0]);
                            } else if (2 == tmps.length) {
                                int a = 3 - tmps[0].length();
                                while (0 < a) {
                                    tmps[0] += "0";
                                    a--;
                                }
                                int b = 9 - tmps[1].length();
                                while (0 < b) {
                                    tmps[1] += "0";
                                    b--;
                                }
                                versionNowInt = Long.parseLong(tmps[0] + tmps[1]);
                            } else if (3 == tmps.length) {
                                int a = 3 - tmps[0].length();
                                while (0 < a) {
                                    tmps[0] += "0";
                                    a--;
                                }

                                int b = 3 - tmps[1].length();
                                while (0 < b) {
                                    tmps[1] += "0";
                                    b--;
                                }

                                int c = 6 - tmps[2].length();
                                while (0 < c) {
                                    tmps[2] += "0";
                                    c--;
                                }
                                versionNowInt = Long.parseLong(tmps[0] + tmps[1] + tmps[2]);
                            } else if (4 == tmps.length) {

                                int a = 3 - tmps[0].length();
                                while (0 < a) {
                                    tmps[0] += "0";
                                    a--;
                                }
                                int b = 3 - tmps[1].length();
                                while (0 < b) {
                                    tmps[1] += "0";
                                    b--;
                                }
                                int c = 3 - tmps[2].length();
                                while (0 < c) {
                                    tmps[2] += "0";
                                    c--;
                                }
                                int d = 3 - tmps[3].length();
                                while (0 < d) {
                                    tmps[3] += "0";
                                    d--;
                                }
                                versionNowInt = Long.parseLong(tmps[0] + tmps[1] + tmps[2] + tmps[3]);
                            }
                            return versionNowInt;
                        }
                        line = readerMF.readLine();
                    }
                    break;
                }
            }
            return 0;
        }

    %>


    <%

        int type = Util.getIntValue(request.getParameter("type"), -1);
        int code = Util.getIntValue(request.getParameter("code"), -1);
        String nextLine = "<br/>";
        String pass = "<span style=\"color:green;text-align:center;\">检查通过</span>";
        String refuse = "<span style=\"color:red;text-align:center;\">检查不通过</span>";
        String check = "<span style=\"color:yellow;text-align:center;\">需要人工检查</span>";

        String checkStatusMsg = "";
        String checkMessage = "";
    %>
    <tr>

        <td>安全包版本检测</td>
        <%
            String ecversion = "";
            String cversion = "";
            rs.executeQuery("select companyname,cversion from license");
            if (rs.next()) {
                cversion = rs.getString("cversion");
                ecversion = "E" + cversion.substring(0, 1);
            }
            csui.getRemoteServerVersion();
            String newOANowVersion = csui.getNewversion();
            String currentVersion = csui.getVersion();

            String newRuleVersion = csui.getRuleNewVersion();
            String currentRuleVersion = csui.getRuleVersion();

            if (newOANowVersion != null && !"".equals(newOANowVersion.trim())) {
                if (csui.getNewversion().compareTo(csui.getVersion()) > 0) {
                    checkStatusMsg = refuse;
                    checkMessage += "当前OA版本为：" + ecversion + "</br> 当前补丁包版本：" + currentVersion + " 最新官网补丁包版本: " + newOANowVersion
                            + "</br>当前安全补丁版本过低请及时升级到最新版本.";
                    if (csui.getRuleNewVersion().compareTo(csui.getRuleVersion()) > 0) {
                        checkMessage += "</br>当前规则库版本: " + currentRuleVersion + " 最新官网规则库版本: " + newRuleVersion + "</br>当前安全库版本过低请及时升级到最新版本.";
                    } else {
                        checkMessage += "</br>当前规则库版本: " + currentRuleVersion + " 最新官网规则库版本: " + newRuleVersion + "</br>当前安全库版本已是最新版本.";
                    }
                } else {
                    checkStatusMsg = pass;
                    checkMessage += "当前OA版本为：" + ecversion + "</br> 当前补丁包版本：" + currentVersion + " 最新官网补丁包版本: " + newOANowVersion
                            + "</br>当前安全补丁版本已是最新.";
                    if (csui.getRuleNewVersion().compareTo(csui.getRuleVersion()) > 0) {
                        checkStatusMsg = refuse;
                        checkMessage += "</br>当前规则库版本: " + currentRuleVersion + " 最新官网规则库版本: " + newRuleVersion + "</br>当前安全库版本过低请及时升级到最新版本.";
                    } else {
                        checkMessage += "</br>当前规则库版本: " + currentRuleVersion + " 最新官网规则库版本: " + newRuleVersion + "</br>当前安全库版本已是最新版本.";
                    }
                }
            } else {
                checkStatusMsg = check;
                checkMessage += "当前OA版本为：" + ecversion + "</br> 当前补丁包版本：" + currentVersion + " 最新官网补丁包版本: " + newOANowVersion
                        + "</br>无法检测到官网补丁包版本,请人工确认." + "</br>当前规则库版本: "
                        + currentRuleVersion + " 最新官网规则库版本: " + newRuleVersion + "</br>无法检测到官网规则库版本,请人工确认.";
            }


        %>
        <td><%=checkStatusMsg%>
        </td>
        <td><%=checkMessage%>
        </td>

    </tr>

    <tr>
        <td>
            JDK版本检测
        </td>

        <%
            Properties props = System.getProperties();
            String jdkVersion = props.getProperty("java.version");
            String[] strarr = jdkVersion.split("[\\_\\.]");
            if (strarr[0] != null && Integer.parseInt(strarr[0].toString()) > 1) {
                checkStatusMsg = check;
                checkMessage = "无法确认的JDK版本，请人工校验！";
            } else if (strarr[1] != null && Integer.parseInt(strarr[1].toString()) == 8) {
                if (Integer.parseInt(strarr[strarr.length - 1].toString()) >= 121) {
                    checkStatusMsg = pass;
                    checkMessage = "当前JDK版本为：" + jdkVersion + "</br> 当前JDK版本为可靠版本！";
                } else {
                    checkStatusMsg = refuse;
                    checkMessage = "当前JDK版本为：" + jdkVersion + "</br> 当前JDK版本过低，推荐使用JDK8 121版本之后的版本";
                }
            } else if (strarr[1] != null && Integer.parseInt(strarr[1].toString()) == 7) {
                if (Integer.parseInt(strarr[strarr.length - 1].toString()) >= 131) {
                    checkStatusMsg = pass;
                    checkMessage = "当前JDK版本为：" + jdkVersion + "</br> 当前JDK版本为可靠版本！";
                } else {
                    checkStatusMsg = refuse;
                    checkMessage = "当前JDK版本为：" + jdkVersion + "</br> 当前JDK版本过低，推荐使用JDK7 131版本之后的版本";
                }
            } else if (strarr[1] != null && Integer.parseInt(strarr[1].toString()) == 6) {
                if (Integer.parseInt(strarr[strarr.length - 1].toString()) >= 141) {
                    checkStatusMsg = pass;
                    checkMessage = "当前JDK版本为：" + jdkVersion + "</br> 当前JDK版本为可靠版本！";
                } else {
                    checkStatusMsg = refuse;
                    checkMessage = "当前JDK版本为：" + jdkVersion + "</br> 当前JDK版本过低，推荐使用JDK6 141版本之后的版本";
                }
            } else {
                checkStatusMsg = check;
                checkMessage = "当前JDK版本为：" + jdkVersion + "</br> 过高或过低的JDK版本，需要进行进一步确认。";
            }
        %>

        <td><%=checkStatusMsg%>
        </td>
        <td><%=checkMessage%>
        </td>
    </tr>

    <tr>
        <td>检查Webservice是否开启</td>
        <%
            SAXReader reader = new SAXReader();
            String rootPath = xssutil.getRootPath();
            String rulePath = rootPath + "WEB-INF" + File.separatorChar + "weaver_security_config.xml";
            File file = new File(rulePath);
            Document document = reader.read(file);
            Element root = document.getRootElement();
            Element WebServiceCheckStatue = root.element("enable-service-check");
            if (WebServiceCheckStatue != null) {
                String webServiceStatue = WebServiceCheckStatue.getTextTrim();
                if ("true".equals(webServiceStatue)) {
                    checkStatusMsg = pass;
                    checkMessage = "webService已开启";
                } else {
                    checkStatusMsg = refuse;
                    checkMessage = "webService服务未开启。</br> 请修改/ecology/WEB-INF/weaver_security_config.xml，将 enable-service-check" +
                            "            标签对应的值改为true。";
                }
            } else {
                checkStatusMsg = check;
                checkMessage = "未检测到相应配置，请人工确认。</br> 确认/ecology/WEB-INF/weaver_security_config.xml 是否存在，以及enable-service-check 标签是否存在。";
            }
        %>
        <td><%=checkStatusMsg%>
        </td>
        <td><%=checkMessage%>
        </td>
    </tr>

    <tr>
        <td>CommonCollection.jar包版本检测</td>
        <%
            Integer checkCommonCollection = 0;

            String commonCollectionPath = "/org/apache/commons/collections/CollectionUtils.class";

            long commonCollectionVersion = getVersion(commonCollectionPath);

            if (commonCollectionVersion >= 300200200000L) {
                checkCommonCollection = 1;
                checkStatusMsg = pass;
                checkMessage = "可靠的CommonCollection.jar包版本!";
            }

            if (checkCommonCollection == 0) {
                checkStatusMsg = refuse;
                checkMessage = "CommonCollection.jar包版本过低或未检测到，替换/Resin/lib 下的对应依赖！";
            }
        %>
        <td><%=checkStatusMsg%>
        </td>
        <td><%=checkMessage%>
        </td>
    </tr>

    <tr>
        <td>CommonFileUpload.jar包版本检测</td>
        <%
            String fileuploadPath = "/org/apache/commons/fileupload/DiskFileUpload.class";
            long version = getVersion(fileuploadPath);
            int checkCommonFileUpload = 0;

            if (version >= 100300300000L) {
                checkCommonFileUpload = 1;
                checkStatusMsg = pass;
                checkMessage = "可靠的CommonFileUpload包版本!";
            }

            if (checkCommonFileUpload == 0) {
                checkStatusMsg = refuse;
                checkMessage = "CommonFileUpload包版本过低或未检测到，替换下/ecology/WEB-INF/lib 下的对应依赖！";
            }
        %>
        <td><%=checkStatusMsg%>
        </td>
        <td><%=checkMessage%>
        </td>
    </tr>

    <%!
        private static List whiteList = new Vector();
        final static String SPECIAL_CODE = "%@";

        static {
            //基础白名单
            whiteList.add("debug.jsp");
            whiteList.add("debugm.jsp");
            whiteList.add("SecurityInspectionCheck.jsp");
            whiteList.add("monitorXOperation.jsp");
            whiteList.add("checkdone.jsp");
            whiteList.add("secCheck.jsp");
            whiteList.add("checkFile.jsp");
            //getRuntime白名单
            whiteList.add("checkredis.jsp");
            whiteList.add("MyJsp.jsp");
            //getRuntime白名单
            whiteList.add("checkredis.jsp");
            whiteList.add("getredis.jsp");
            whiteList.add("redis\\ecologyClusterConfigCheck.jsp");
            //base64白名单
            whiteList.add("datacenter\\maintenance\\inputreport\\InputReportEdit.jsp");
            whiteList.add("debug\\upload.jsp");
            whiteList.add("debug\\uploadm.jsp");
            whiteList.add("synccache.jsp");
            //@include白名单
            whiteList.add("cloudstore\\resource\\pc\\com\\icon-coms\\index.jsp");
            whiteList.add("workrelate\\goal\\data\\TreeShowNew.jsp");
            //常用白名单
            whiteList.add("ecologyClusterConfigCheck.jsp");
            whiteList.add("\\join\\SecurityInspectionCheck.jsp");
            whiteList.add("\\wui\\secCheck.jsp");
            whiteList.add("getredis.jsp");
            whiteList.add("checkreds.jsp");
            whiteList.add("ecology\\formmode\\zh_remindtest.jsp");
        }

        private boolean fileWhiteListCheck(String path) {

            if (path == null || "".equals(path)) {
                return false;
            }

            for (Object white : whiteList) {
                if (path.contains((String) white)) {
                    return true;
                }
            }

            return false;
        }


        public List getFiles(String filepath) {
            List files = new Vector();
            listFiles(files, filepath);
            return files;
        }

        public void listFiles(List files, String dirName) {
            try {
                File dirFile = new File(dirName);
                if (!dirFile.exists() || (!dirFile.isDirectory())) {
                } else {
                    File[] tmpfiles = dirFile.listFiles();
                    for (int i = 0; i < tmpfiles.length; i++) {
                        File f = tmpfiles[i];
                        if (f.isFile()) {
                            if (f.getName().toLowerCase().contains(".jsp")) {
                                if (checkFile(f)) {
                                    files.add(f.getAbsolutePath());
                                }
                            }
                        } else if (f.isDirectory()) {
                            if (!f.getPath().trim().endsWith("WEB-INF"))
                                listFiles(files, f.getAbsolutePath());
                        }
                    }
                }
            } catch (Exception e) {
            }
        }

        public boolean checkCode(String code) {
            if (code == null) return false;

            code = code.toLowerCase();
            if (code.contains("\\u0065") || code.contains("\\u0074")
                    || code.contains("\\u0052") || code.contains("\\u006e") || code.contains("\\u0069") || code.contains("\\u006d")
                    || code.contains("\\u0050") || code.contains("\\u0072") || code.contains("\\u006f") || code.contains("\\u0063") || code.contains("\\u0073")
                    || code.contains("\\u0042") || code.contains("\\u006c") || code.contains("\\u0064") || code.contains("\\u0075")
                    || code.contains("\\u0053") || code.contains("\\u006b") || code.contains("\\u0043") || code.contains("\\u0068") || code.contains("\\u0061")
                    || code.contains("\\u0041") || code.contains("\\u0045") || code.contains("\\u0036") || code.contains("\\u0034") || code.contains("\\u002e")
                    || code.contains("\\u0067") || code.contains("\\u004d") || code.contains("\\u0028") || code.contains("\\u0066") || code.contains("\\u004e")
                    || code.contains("\\u003b")
            ) {
                return true;
            } else if (code.contains("getruntime")) {
                return true;
            } else if (code.contains("processbuilder")) {
                return true;
            } else if (code.contains("https://github.com/sensepost/regeorg")) {
                return true;
            } else if (code.contains("socketchannel")) {
                return true;
            } else if (code.contains("base64encoder")) {
                return true;
            } else if (code.contains(".getMethod(")) {
                return true;
            } else if (code.contains("@include") && !code.contains(".jsp\"")) {
                return true;
            } else {
                return false;
            }
        }

        private boolean checkFile(File file) {
            if (fileWhiteListCheck(file.getPath())) {
                return false;
            } else {
                BufferedReader is = null;
                boolean isComment = false;
                String readline;
                try {
                    is = new BufferedReader(new InputStreamReader(new FileInputStream(file)));
                    StringBuilder sb = null;
                    while ((readline = is.readLine()) != null) {
                        sb = new StringBuilder();
                        sb.append(readline);
                        String tmp = readline.trim();

                        while (!tmp.trim().endsWith(">") && !tmp.trim().endsWith(";")) {
                            tmp = is.readLine();
                            if (tmp == null) break;
                            sb.append(tmp.trim());
                        }
                        if (sb.toString().contains(SPECIAL_CODE)) {
                            sb.toString().replaceAll("\\s+", "");
                        }
                        if (checkCode(sb.toString())) {
                            return true;
                        }
                    }
                    return false;

                } catch (Exception e) {
                } finally {
                    try {
                        is.close();
                    } catch (Exception e) {
                    }
                }
                return false;
            }
        }
    %>

    <%
        if (type != 1) {
    %>
    <tr>
        <td>检查是否包含webshell后门文件</td>

        <%
            List<String> exceptionFiles = getFiles(xssutil.getRootPath());
            if (exceptionFiles.isEmpty()) {
                checkStatusMsg = pass;
                checkMessage = "没有发现可疑项。";
            } else {
                checkMessage = "疑似webshell的脚本文件如下：</br>";
                checkStatusMsg = refuse;
                for (String fileName : exceptionFiles) {
                    checkMessage += fileName + "</br>";
                }
            }
        %>
        <td><%=checkStatusMsg%>
        </td>
        <td><%=checkMessage%>
        </td>
    </tr>
    <%}%>

    <%!
        private static final char[] DIGITS_LOWER = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};

        public char[] encodeHex(byte[] data, char... toDigits) {
            int l = data.length;
            char[] out = new char[l << 1];
            int i = 0;

            for (int var5 = 0; i < l; ++i) {
                out[var5++] = toDigits[(240 & data[i]) >>> 4];
                out[var5++] = toDigits[15 & data[i]];
            }

            return out;
        }

        public String md5Hex(String input) {
            try {
                MessageDigest digest = MessageDigest.getInstance("MD5");
                digest.update(input.getBytes());
                byte[] md5bytes = digest.digest();
                return new String(encodeHex(md5bytes, DIGITS_LOWER));
            } catch (Throwable var4) {
                return null;
            }
        }
    %>

    <tr>

        <td>检测弱密码</td>
        <%
            List<Map<String, String>> weakResources = new ArrayList<Map<String, String>>();
            List<Map<String, String>> weakResourcesManager = new ArrayList<Map<String, String>>();
            weaver.filter.XssUtil xssUtil = new weaver.filter.XssUtil();
            String pathname = xssUtil.getRootPath() + "WEB-INF/securityRule/weak.txt"; // 绝对路径或相对路径都可以，这里是绝对路径，写入文件时演示相对路径
            File filename = new File(pathname); // 要读取以上路径的input.txt文件
            InputStreamReader reader2 = new InputStreamReader(
                    new FileInputStream(filename)); // 建立一个输入流对象reader
            BufferedReader br = new BufferedReader(reader2); // 建立一个对象，它把文件内容转成计算机能读懂的语言
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

            if (weakResources.size() > 0 || weakResourcesManager.size() > 0) {
                checkStatusMsg = refuse;
                checkMessage = "系统中存在" + (weakResources.size() + weakResourcesManager.size()) + "个弱密码用户，请及时处理. 访问/wui/weak.jsp 获取明细信息.";
            } else {
                checkStatusMsg = pass;
                checkMessage = "无弱密码信息";
            }
        %>
        <td><%=checkStatusMsg%>
        </td>
        <td><%=checkMessage%>
        </td>
    </tr>

    <tr>

        <td>验证码策略检测</td>
        <%
            ChgPasswdReminder reminder = new ChgPasswdReminder();
            RemindSettings settings = reminder.getRemindSettings();
            int needvalidate = settings.getNeedvalidate();
            String getopenpasswordlock = settings.getOpenPasswordLock();
            int checkValidate = 0;
            int checkPwdLock = 0;

            if (needvalidate == 1) {
                checkValidate = 1;
                checkStatusMsg = pass;
                checkMessage = "验证码已开启.";
            }
            if (checkValidate == 0) {
                checkStatusMsg = refuse;
                checkMessage = "验证码未开启，请开启验证码校验功能.";
            }
        %>
        <td><%=checkStatusMsg%>
        </td>
        <td><%=checkMessage%>
        </td>
    </tr>
    <tr>
        <td>密码锁定策略检测</td>
        <%
            if ("1".equals(getopenpasswordlock)) {

                checkPwdLock = 1;
                checkStatusMsg = pass;
                checkMessage = "密码锁定策略已开启";
            }
            if (checkPwdLock == 0) {
                checkStatusMsg = refuse;
                checkMessage = "密码锁定策略未开启";
            }
        %>
        <td><%=checkStatusMsg%>
        </td>
        <td><%=checkMessage%>
        </td>
    </tr>

    <tr>
        <td>监控日志检测</td>

        <%
            Map map = xssutil.getTmpForbiddenIpMap();
            xssutil.getForbiddenCount();

            int forbiddenMsg = 0;

            if (map != null && !map.isEmpty()) {
                for (Object o : map.entrySet()) {
                    Map.Entry entry = (Map.Entry) o;
                    Map ipMap = (Map) entry.getValue();
                    int count = xssutil.getIntValue((String) ipMap.get("count"), 0);
                    if (count > 10) {
                        forbiddenMsg++;
                    }
                }
            }

            if (forbiddenMsg == 0) {
                checkStatusMsg = pass;
                checkMessage = "无异常日志";
            } else {
                checkStatusMsg = refuse;
                checkMessage = "出现部分异常日志，请前往 /security/monitor/Monitor.jsp 确认.";
            }
        %>
        <td><%=checkStatusMsg%>
        </td>
        <td><%=checkMessage%>
        </td>
    </tr>

    <tr>

        <td>是否开启accesslog</td>
        <%
            SecurityCheckList scl = new SecurityCheckList();
            if (scl.isEnableAccessLog() || ecversion.toLowerCase().equals("e9")) {
                checkStatusMsg = pass;
                checkMessage = "已开启accesslog";
            } else {
                checkStatusMsg = refuse;
                checkMessage = "未开启accesslog";
            }
        %>
        <td><%=checkStatusMsg%>
        </td>
        <td><%=checkMessage%>
        </td>
    </tr>

    <tr>

        <td>synccache.jsp 是否是安全版本</td>
        <%
            file = new File(xssutil.getRootPath() + "synccache.jsp");
            BufferedReader reader1 = null;

            try {
                if (file.exists()) {
                    reader1 = new BufferedReader(new FileReader(file));
                    String tempString = null;
                    // 一次读入一行，直到读入null为文件结束
                    while ((tempString = reader1.readLine()) != null) {
                        // 显示行号
                        if (tempString.toLowerCase().contains("SerialKiller".toLowerCase())) {
                            checkStatusMsg = pass;
                            checkMessage = "为安全的synccache.jsp版本.";
                            break;
                        } else {
                            checkStatusMsg = refuse;
                            checkMessage = "为不安全的synccache.jsp版本,请及联系巡检人员获取安全版本,若为非集群状态请删除该文件.";
                        }
                    }
                } else {
                    checkStatusMsg = pass;
                    checkMessage = "非集群环境无该风险";
                }


            } catch (IOException e) {
                checkStatusMsg = check;
                checkMessage = "打开文件异常请人工检测.";
            } finally {
                try {
                    reader1.close();
                } catch (Exception e) {

                }
            }
        %>
        <td><%=checkStatusMsg%>
        </td>
        <td><%=checkMessage%>
        </td>
    </tr>
    <tr>
        <td>检测反序列化补丁是否已经升级</td>
        <%
            file = new File(xssutil.getRootPath() + "checkSuc.jsp");
            if (file.exists()) {
                checkStatusMsg = pass;
                checkMessage = "反序列化补丁已经升级";
            } else {
                checkStatusMsg = refuse;
                checkMessage = "请及时去泛微安全官网升级你的反序列化补丁,官网地址为:https://www.weaver.com.cn/cs/securityDownload.asp";
            }
        %>
        <td><%=checkStatusMsg%>
        </td>
        <td><%=checkMessage%>
        </td>
    </tr>

    <tr>
        <td>检测bsh补丁是否已经升级</td>
        <%
            file = new File(xssutil.getRootPath() + "/security/checkbsh.jsp");
            if (file.exists()) {
                checkStatusMsg = pass;
                checkMessage = "bsh补丁已经升级";
            } else {
                checkStatusMsg = refuse;
                checkMessage = "请及时去泛微安全官网升级你的bsh补丁,官网地址为:https://www.weaver.com.cn/cs/securityDownload.asp";
            }
        %>
        <td><%=checkStatusMsg%>
        </td>
        <td><%=checkMessage%>
        </td>
    </tr>

    <tr>
        <td>检测sql注入补丁是否已经升级</td>
        <%
            file = new File(xssutil.getRootPath() + "/security/checksql20191010.jsp");
            if (file.exists()) {
                checkStatusMsg = pass;
                checkMessage = "sql注入已经升级";
            } else {
                checkStatusMsg = refuse;
                checkMessage = "请及时去泛微安全官网升级你的sql注入补丁,官网地址为:https://www.weaver.com.cn/cs/securityDownload.asp";
            }
        %>
        <td><%=checkStatusMsg%>
        </td>
        <td><%=checkMessage%>
        </td>
    </tr>
    </tbody>
</table>

</body>
</html>
