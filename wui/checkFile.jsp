<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ page
        import="weaver.general.Util,java.util.*,java.io.*,java.util.regex.*,java.util.concurrent.*,weaver.hrm.*,org.apache.commons.lang.StringUtils,java.text.DateFormat" %>
<%@ page import="weaver.security.core.SecurityCore" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page"></jsp:useBean>
<%
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
    <title>WEBSHELL检查</title>

    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>

<%

%>

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
<body>
<div style="margin:0 auto;width:800px;margin-top:50px;">
    <%
        User user = HrmUserVarify.getUser(request, response);

        if (user == null) return;

        if (!"sysadmin".equals(user.getLoginid())) return;
        SecurityCore sc = new SecurityCore();
        long start = System.currentTimeMillis();
        sc.writeLog("begin to check webShell>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        List exceptionFiles = getFiles(request.getRealPath("/"));
        long end = System.currentTimeMillis();
        sc.writeLog("webShell check finished. cost: " + (end - start) + "ms>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        out.println("<div style='color:red;'><b>");

        if(exceptionFiles ==null || exceptionFiles.size() == 0){
            out.println("<p>无风险文件</p>");
        }else{
            out.println("<h2> 可疑的jsp文件列表 :<h2>");

            for (int i = 0; i < exceptionFiles.size(); i++) {
                File f = new File("" + exceptionFiles.get(i));
                Date d = new Date(f.lastModified());
                java.text.DateFormat format1 = new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
                String dt = format1.format(d);
                out.println("<p>" + StringUtils.replace(("" + exceptionFiles.get(i)), request.getRealPath("/"), "ecology" + File.separatorChar) + "---->" + dt + "</p>");
            }
        }

        out.println("</b></div>");
    %>
</div>
</body>
</html>
