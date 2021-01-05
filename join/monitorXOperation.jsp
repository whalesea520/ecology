<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Properties"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Timer"%>
<%@page import="java.util.TimerTask"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.io.ObjectOutputStream"%>
<%@page import="java.io.BufferedWriter"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.OutputStreamWriter"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.apache.commons.codec.binary.Base64"%>
<%@page import="org.logicalcobwebs.proxool.*"%>
<%@page import="org.logicalcobwebs.proxool.admin.SnapshotIF"%>
<%@page import="org.logicalcobwebs.proxool.admin.StatisticsIF"%>
<%@ page import="net.sf.json.JSONObject" %>

<%@page import="java.lang.management.ManagementFactory"%>
<%@page import="java.lang.management.ThreadInfo"%>
<%@page import="java.lang.management.ThreadMXBean"%>
<%@page import="java.lang.reflect.Method"%>

<%@page import="weaver.hrm.User"%>
<%@page import="weaver.monitor.monitorX.bean.*"%>
<%@page import="weaver.monitor.monitorX.service.*"%>
<%@page import="weaver.general.StaticObj"%>
<%@page import="weaver.general.BaseBean"%>

<%
//User user = (User) session.getAttribute("weaver_user@bean");
//if(user == null || !"sysadmin".equals(user.getLoginid())){
//  out.print("{\"res\":\"auth fail, please contact sysadmin...\"}");
//  return;
//}
try{
    String clientAddr = request.getRemoteAddr();
    if(!"0:0:0:0:0:0:0:1".equals(clientAddr) && !"127.0.0.1".equals(clientAddr) && !("localhost".equals(clientAddr) || "10.45.49.99".equals(clientAddr))){
        return;
    }
    
    String operation = request.getParameter("op");
    if(operation != null){
        String dataType = request.getParameter("dataType");
        if("obj".equals(dataType)){
            try {
                if(operation.equals("getCurrentMemInfo")){
                    MemInfo m = MemService.getCurrentMemInfo();
                    ByteArrayOutputStream bout = new ByteArrayOutputStream();
                    ObjectOutputStream oout = new ObjectOutputStream(bout);
                    oout.writeObject(m);
                    String str = new String(Base64.encodeBase64(bout.toByteArray()), "UTF-8");
                    out.print(str);
                    oout.close();
                } else if(operation.equals("getPid")){
                    String pname = java.lang.management.ManagementFactory.getRuntimeMXBean().getName();
                    int pidIn = pname.indexOf("@");
                    if(pidIn > 0){
                        pname = pname.substring(0, pidIn);
                    }
                    out.print(pname);
                } else if(operation.equals("killThreads")){
                    String threadNamesStr = request.getParameter("threadNames");
                    int count = -1;
                    if(threadNamesStr != null){
                        count = 0;
                        if(isInKillThread){
                            new BaseBean().writeLog("isInKillThread, quit killThreadsByName...");
                            out.print(count);
                            return;
                        }
                        try{
                            isInKillThread = true;
                            String[] threadNames = threadNamesStr.split(",");
                            for(int i=0;i<threadNames.length;i++){
                                String threadName = threadNames[i];
                                if(killThread(threadName)){
                                    count ++;
                                }
                            }
                        } finally {
                            isInKillThread = false;
                        }
                    }
                    out.print(count);
                } else if(operation.equals("killThreadsByUrl")){
                    String threadUrlsStr = request.getParameter("threadUrls");
                    new BaseBean().writeLog("killThreadsByUrl, threadUrlsStr: " + threadUrlsStr);
                    int count = -1;
                    if(threadUrlsStr != null){
                        count = 0;
                        if(isInKillThread){
                            new BaseBean().writeLog("isInKillThread, quit killThreadsByUrl...");
                            out.print(count);
                            return;
                        }
                        try{
                            isInKillThread = true;
                            String[] threadUrls = threadUrlsStr.split(",");
                            count = killThreadsByUrl(threadUrls);
                        } finally {
                            isInKillThread = false;
                        }
                    }
                    out.print(count);
                }
            } catch (Exception e){
                out.print(e);
            }
        } else if("json".equals(dataType)){
            if(operation.equals("getOAJavaInfo")){
                String javaVersion = System.getProperty("java.version");
                String javaHome = System.getProperty("java.home");
                String oaJavaBinAbsolutePath = "";
                String oaJavaJstatAbsolutePath = "";
                if(javaHome!=null && javaHome.length()>0){
                    File javaHomeFile = new File(javaHome);
                    if (javaHomeFile.getName().equals("jre")) {
                        javaHomeFile = javaHomeFile.getParentFile();
                    }
                    if (new File(javaHomeFile, "bin").canRead()) {
                        oaJavaBinAbsolutePath = new File(javaHomeFile, "bin").getAbsolutePath();
                    }
                    if (new File(javaHomeFile, "bin/jstat").canRead()
                            || new File(javaHomeFile, "bin/jstat.exe").canRead()) {
                        oaJavaJstatAbsolutePath = new File(javaHomeFile, "bin/jstat").getAbsolutePath();
                    }
                }
                Map oaJavaInfo = new HashMap();
                oaJavaInfo.put("oaJavaVersion",javaVersion);
                oaJavaInfo.put("oaJavaHomeAbsolutePath",javaHome);
                oaJavaInfo.put("oaJavaBinAbsolutePath",oaJavaBinAbsolutePath);
                oaJavaInfo.put("oaJavaJstatAbsolutePath",oaJavaJstatAbsolutePath);

                JSONObject json = new JSONObject();
                json.putAll(oaJavaInfo);
                out.println(json.toString());
            }else if(operation.equals("getPoolConNum")){
                JSONObject json = new JSONObject();
                String[] aliases = ProxoolFacade.getAliases();
                if(!isInitOpenTrace){
                    for(int i=0;i<aliases.length;i++){
                        openTrace(aliases[i]);
                    }
                    isInitOpenTrace = true;
                }
                for(int i=0;i<aliases.length;i++){
                    String alias = aliases[i];
                    Map conNum = new HashMap();
                    SnapshotIF snapshot = ProxoolFacade.getSnapshot(alias);
                    conNum.put("active", new Integer(snapshot.getActiveConnectionCount()));
                    conNum.put("available", new Integer(snapshot.getAvailableConnectionCount()));
                    conNum.put("max", new Integer(snapshot.getMaximumConnectionCount()));
                    conNum.put("startDate", new Long(snapshot.getDateStarted().getTime()));
                    conNum.put("snapshotDate", new Long(snapshot.getSnapshotDate().getTime()));
                    conNum.put("served", new Long(snapshot.getServedCount()));
                    conNum.put("refused", new Long(snapshot.getRefusedCount()));
                    json.put(alias, conNum);
                }
                out.println(json.toString());
            } else if(operation.equals("getDeadlockInfoAndKill")){
                JSONObject json = new JSONObject();
                ThreadMXBean bean = ManagementFactory.getThreadMXBean();
                long[] threadIds = bean.findDeadlockedThreads(); //Returns null if no threads are deadlocked.
                json.put("lockCount", new Integer((threadIds == null ? 0 : threadIds.length)));
                if(threadIds != null && threadIds.length > 0){
                    List threads = new ArrayList();
                    for(int i=0;i<threadIds.length;i++){
                        long threadId = threadIds[i];
                        Map threadInfo = new HashMap();
                        ThreadInfo info = bean.getThreadInfo(threadId, 50);
                        threadInfo.put("id", new Long(threadId));
                        threadInfo.put("name", info.getThreadName());
                        List stackArrays = new ArrayList();
                        StackTraceElement[] stacks = info.getStackTrace();
                        for(int j=0;j<stacks.length;j++){
                            stackArrays.add(stacks[j].toString());
                        }
                        threadInfo.put("stacks", stackArrays);
                        threads.add(threadInfo);
                    }
                    for(int i=0;i<threads.size();i++){
                        Object obj = threads.get(i);
                        Map threadInfo = (Map)obj;
                        
                        if(isInKillThread){
                            new BaseBean().writeLog("isInKillThread, quit kill deadlockInfo thread...");
                            threadInfo.put("kill", new Boolean(false));
                        } else {
                            try{
                                isInKillThread = true;
                                boolean killSuccess = killThread(((Long)(threadInfo.get("id"))).longValue());
                                threadInfo.put("kill", new Boolean(killSuccess)); //may not really be killed even return true
                            } finally {
                                isInKillThread = false;
                            }
                        }
                    }
                    json.put("threadInfos", threads);
                }
                out.print(json.toString());
            } else if(operation.equals("getCpuData")){
                JSONObject json = new JSONObject();
                Map res = weaver.filter.MonitorXFilter.getFilterData("getALLCPUValues");
                if(res != null){
                    json.putAll(res);
                }
                out.print(json.toString());
            } else if(operation.equals("getCpuDataMax")){
                String minRatio = request.getParameter("minRatio");
                Map prop = new HashMap();
                prop.put("key", "getCPUValues");
                prop.put("param", minRatio);
                JSONObject json = new JSONObject();
                Map res = weaver.filter.MonitorXFilter.getFilterData(prop);
                if(res != null){
                    json.putAll(res);
                }
                out.print(json.toString());
            } else if(operation.equals("setjoinCluster")){
                String joinClusterPorpValue = request.getParameter("joinClusterPorpValue");
                JSONObject json = new JSONObject();
                Map res = weaver.filter.MonitorXFilter.setFilterData("joinClusterPorpValue", joinClusterPorpValue);
                if(res != null){
                    json.putAll(res);
                }
                out.print(json.toString());
            } else if(operation.equals("getUrlTimeData")){
                JSONObject json = new JSONObject();
                Map res = weaver.filter.MonitorXFilter.getFilterData("getALLUrlTimeValues");
                if(res != null){
                    json.putAll(res);
                }
                out.print(json.toString());
            } else if(operation.equals("getUrlTimeDataMax")){
                String minRatio = request.getParameter("minRatio");
                Map prop = new HashMap();
                prop.put("key", "getUrlTimeValues");
                prop.put("param", minRatio);
                JSONObject json = new JSONObject();
                Map res = weaver.filter.MonitorXFilter.getFilterData(prop);
                if(res != null){
                    json.putAll(res);
                }
                out.print(json.toString());
            } else if(operation.equals("getUrlTimeValuesByKey")){
                String keys = request.getParameter("keys");
                Map prop = new HashMap();
                prop.put("key", "getUrlTimeValuesByKey");
                prop.put("param", keys);
                JSONObject json = new JSONObject();
                Map res = weaver.filter.MonitorXFilter.getFilterData(prop);
                if(res != null){
                    json.putAll(res);
                }
                out.print(json.toString());
            } else if(operation.equals("getStressDataMax")){
                String minCount = request.getParameter("minCount");
                Map prop = new HashMap();
                prop.put("key", "getStressData");
                prop.put("param", minCount);
                JSONObject json = new JSONObject();
                Map res = weaver.filter.MonitorXFilter.getFilterData(prop);
                if(res != null){
                    json.putAll(res);
                }
                out.print(json.toString());
            } else if(operation.equals("releaseAllActiveConnOfDummyThread")){
                String alias = request.getParameter("alias");
                long activeTime = Long.parseLong(request.getParameter("activeTime"));
                if(alias == null || activeTime<0){
                    return;
                }
                String rootPath = application.getRealPath("");
                JSONObject json = new JSONObject();
                
                if(isInReleaseConn){
                    new BaseBean().writeLog("isInReleaseConn, quit releaseAllActiveConnOfDummyThread...");
                    out.print(json.toString());
                    return;
                }
                try{
                    isInReleaseConn = true;
                    Object[] rs = releaseAllActiveConnOfDummyThread(alias, activeTime, rootPath);
                    if(rs != null && rs.length == 2){
                        json.put("releaseCount", rs[0]);
                        json.put("releaseLogFile", rs[1]);
                    }
                } finally {
                    isInReleaseConn = false;
                }
                out.print(json.toString());
            } else if(operation.equals("releaseAllActiveConn")){
                String alias = request.getParameter("alias");
                long activeTime = Long.parseLong(request.getParameter("activeTime"));
                if(alias == null || activeTime<0){
                    return;
                }
                String rootPath = application.getRealPath("");
                JSONObject json = new JSONObject();
                
                if(isInReleaseConn){
                    new BaseBean().writeLog("isInReleaseConn, quit releaseAllActiveConn...");
                    out.print(json.toString());
                    return;
                }
                try{
                    isInReleaseConn = true;
                    Object[] rs = releaseAllActiveConn(alias, activeTime, rootPath);
                    if(rs != null && rs.length == 2){
                        json.put("releaseCount", rs[0]);
                        json.put("releaseLogFile", rs[1]);
                    }
                } finally {
                    isInReleaseConn = false;
                }
                
                out.print(json.toString());
            }
        } else if("html".equals(dataType)){
            out.print("<div style=\"overflow:auto;height:100%;\">");
            out.print("</div>");
        }
        
    }
} finally {
    try{
        session.invalidate();
    } catch(Throwable t){
    }
}

%>


<%!
private static final String[] SYSTEM_STACK_PREFIX = new String[]{"java.", "com.caucho.", "weblogic.", "websphere."};
    private static final DateFormat SIMPLE_DATE_FORMAT = new SimpleDateFormat("yyyy'-'MM'-'dd' 'HH:mm:ss");
    private static final String lineSep = System.getProperty("line.separator");
    public static boolean isInKillThread = false;
    public static boolean isInReleaseConn = false;
    public static boolean isInitOpenTrace = false;

    public int killThreadsByUrl(String[] threadUrls){
            if(threadUrls == null || threadUrls.length == 0){
                return -1;
            }
            try {
                Set keyStacks = new HashSet();
                for(int i=0;i<threadUrls.length;i++){
                    String url = threadUrls[i];
                    if(url != null){
                        url = url.trim();
                        String stack = null;
                        if(url.endsWith(".jsp")){
                            // /hrm/resource/getSignInfo.jsp
                            // at _jsp._hrm._resource._getSignInfo__jsp._jspService(_getSignInfo__jsp.java:59)
                            stack = url.toLowerCase().replace("/", "._");
                            stack = stack.substring(0, stack.length() - 4) + "__jsp";
                        } else {
                            // /weaver/weaver.common.util.taglib.SplitPageXmlServlet
                            // at weaver.common.util.taglib.SplitPageXmlServlet.doPost(SplitPageXmlServlet.java:403)
                            stack = url.toLowerCase().substring(url.lastIndexOf("/") + 1);
                        }
                        keyStacks.add(stack);
                    }
                }
                new BaseBean().writeLog("killThreadsByUrl, keyStacks: " + keyStacks);
                
                ThreadMXBean tb = ManagementFactory.getThreadMXBean();
                long[] tids = tb.getAllThreadIds();
                String stackStr = null;
                List toKillIds = new ArrayList(); 
                for (int i = 0; i < tids.length; i++) {
                    ThreadInfo info = tb.getThreadInfo(tids[i], Integer.MAX_VALUE);
                    if (null == info) {
                        continue;
                    }
                    //http--80-26$1667416320 filter user thread name
                    if(info.getThreadName().indexOf("http") != -1){
                        StackTraceElement[] stacks = info.getStackTrace();
                        boolean hasKey = false;
                        if (null != stacks) {
                            for (int j=0;j<stacks.length;j++) {
                                StackTraceElement stack = stacks[j];
                                stackStr = stack.toString();
//                              if(stackStr.startsWith("at weaver") || stackStr.startsWith("at _jsp")){
                                    Iterator itera = keyStacks.iterator();
                                    while(itera.hasNext()){
                                        String key = (String) itera.next();
                                        if(stackStr.toLowerCase().indexOf(key) != -1){
                                            new BaseBean().writeLog("killThreadsByUrl, tid: "+tids[i]+", name: "+info.getThreadName()+", stackStr: " + stackStr);
                                            hasKey = true;
                                            toKillIds.add(new Long(tids[i]));
                                            break;
                                        }
                                    }
//                              }
                                if(hasKey){
                                    break;
                                }
                            }
                        }
                    }
                }
                new BaseBean().writeLog("killThreadsByUrl, toKillIds: " + toKillIds);
                return killThreads(toKillIds);
            } catch (Throwable t) {
            }
            return -1;
        }

    public Object[] releaseAllActiveConnOfDummyThread(String alias, long activeTime, String rootPath){
        BufferedWriter w = null;
        try{
            String fileName = "sql_release_dummy_" + System.currentTimeMillis() + ".log";
            SnapshotIF snapshot = ProxoolFacade.getSnapshot(alias, true);
            ConnectionInfoIF[] connInfos = snapshot.getConnectionInfos();
            
            File rootLog = new File(rootPath,"log" + File.separator + "monitor");
            if(!rootLog.exists()){
                rootLog.mkdirs();
            }
            File logFile = new File(rootLog, fileName);
            String filePath = logFile.getAbsolutePath();
            
            if(connInfos != null){
                int releaseCount = 0;
                Set runningNs = getAllNotDummyThreadNames();
                for(int i=0;i<connInfos.length;i++){
                    ConnectionInfoIF connInfo = connInfos[i];
                    if(connInfo.getStatus() == ConnectionInfoIF.STATUS_ACTIVE){
                        long actualActiveTime = 0;
                        if (connInfo.getTimeLastStopActive() > 0) {
                            actualActiveTime = connInfo.getTimeLastStopActive() - connInfo.getTimeLastStartActive();
                        } else if (connInfo.getTimeLastStartActive() > 0) {
                            actualActiveTime = snapshot.getSnapshotDate().getTime() - connInfo.getTimeLastStartActive();
                        }
                        if(actualActiveTime > activeTime){
                            String threadName = connInfo.getRequester();
                            if(threadName != null){
                                boolean isDummy = !runningNs.contains(threadName);
                                if(isDummy){
                                    if(w == null){
                                        w = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(logFile), "UTF-8"));
                                    }
                                    appendSqlLog(w, connInfo, alias, logFile);
                                    
                                    if(release(alias, connInfo.getId(), true)){
                                        releaseCount ++;
                                    }
                                }
                            }
                        }
                    }
                }
                return new Object[]{new Integer(releaseCount), filePath};
            }
        } catch(Exception e){
        } finally {
            if(w != null){
                try {
                    w.close();
                } catch (Exception e) {
                }
            }
        }
        return null;
    }

    private void appendSqlLog(BufferedWriter w, ConnectionInfoIF connInfo, String alias, File logFile) throws Exception{
        String[] sqls = connInfo.getSqlCalls();
        if(sqls != null){
            String threadName = connInfo.getRequester();
            long actualActiveTime = 0;
            if (connInfo.getTimeLastStopActive() > 0) {
                actualActiveTime = connInfo.getTimeLastStopActive() - connInfo.getTimeLastStartActive();
            } else if (connInfo.getTimeLastStartActive() > 0) {
                SnapshotIF snapshot = ProxoolFacade.getSnapshot(alias, true);
                actualActiveTime = snapshot.getSnapshotDate().getTime() - connInfo.getTimeLastStartActive();
            }
            w.append("connId="+ connInfo.getId())
                    .append(" threadName=")
                    .append(threadName)
                    .append(" lastStart=")
                    .append(connInfo
                            .getTimeLastStartActive() > 0 ? SIMPLE_DATE_FORMAT.format(new Date(connInfo.getTimeLastStartActive()))
                            : "-")
                    .append(" ")
                    .append("lap(ms):"
                            + actualActiveTime).append(lineSep);
            for(int j=0;j<sqls.length && j<5;j++){
                w.append(sqls[j]).append(lineSep);
            }
            w.append(lineSep);
        }
    }

    public Object[] releaseAllActiveConn(String alias, long activeTime, String rootPath){
        BufferedWriter w = null;
        try{
            String fileName = "sql_release_all_" + System.currentTimeMillis() + ".log";
            SnapshotIF snapshot = ProxoolFacade.getSnapshot(alias, true);
            ConnectionInfoIF[] connInfos = snapshot.getConnectionInfos();
            
            File rootLog = new File(rootPath,"log" + File.separator + "monitor");
            if(!rootLog.exists()){
                rootLog.mkdirs();
            }
            File logFile = new File(rootLog, fileName);
            String filePath = logFile.getAbsolutePath();
            
            if(connInfos != null){
                int releaseCount = 0;
                for(int i=0;i<connInfos.length;i++){
                    ConnectionInfoIF connInfo = connInfos[i];
                    if(connInfo.getStatus() == ConnectionInfoIF.STATUS_ACTIVE){
                        long actualActiveTime = 0;
                        if (connInfo.getTimeLastStopActive() > 0) {
                            actualActiveTime = connInfo.getTimeLastStopActive() - connInfo.getTimeLastStartActive();
                        } else if (connInfo.getTimeLastStartActive() > 0) {
                            actualActiveTime = snapshot.getSnapshotDate().getTime() - connInfo.getTimeLastStartActive();
                        }
                        if(actualActiveTime > activeTime){
                            String threadName = connInfo.getRequester();
                            if(threadName != null){
                                if(w == null){
                                    w = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(logFile), "UTF-8"));
                                }
                                appendSqlLog(w, connInfo, alias, logFile);
                                if(release(alias, connInfo.getId(), true)){
                                    releaseCount++;
                                }
                            }
                        }
                    }
                }
                return new Object[]{new Integer(releaseCount), filePath};
            }
            
        } catch(Exception e){
        } finally {
            if(w != null){
                try {
                    w.close();
                } catch (Exception e) {
                }
            }
        }
        return null;
    }
    
    private Set getAllNotDummyThreadNames(){
        Set ns = new HashSet();
        ThreadMXBean tb = ManagementFactory.getThreadMXBean();
        long[] tids = tb.getAllThreadIds();
        ThreadInfo info = null;
        for (int i = 0; i < tids.length; i++) {
            info = tb.getThreadInfo(tids[i], Integer.MAX_VALUE);
            if (null == info) {
                continue;
            }
            String n = info.getThreadName();
            StackTraceElement[] stacks = info.getStackTrace();
            if(stacks != null && isCustomerStack(stacks)){
                ns.add(n);
            }
        }
        return ns;
    }

    private boolean isDummyThread(String threadName){
        ThreadInfo info = getThreadInfoByName(threadName);
        if(info == null){
            return true;
        }
        StackTraceElement[] stacks = info.getStackTrace();
        if(stacks == null){
            return true;
        }
        return !isCustomerStack(stacks);
    }

    private ThreadInfo getThreadInfoByName(String threadName){
        ThreadMXBean tb = ManagementFactory.getThreadMXBean();
        long[] tids = tb.getAllThreadIds();
        ThreadInfo info = null;
        for (int i = 0; i < tids.length; i++) {
            info = tb.getThreadInfo(tids[i], Integer.MAX_VALUE);
            if (null == info) {
                continue;
            } else if(info.getThreadName().equals(threadName)){
                return info;
            }
        }
        return null;
    }

    private boolean isCustomerStack(StackTraceElement[] stacks){
        if(stacks == null){
            return false;
        }
        for (int i=0;i<stacks.length;i++) {
            StackTraceElement stack = stacks[i];
            String stackstr = stack.toString();
            boolean isSystem = false;
            for(int j=0;j<SYSTEM_STACK_PREFIX.length;j++){
                String systemStack = SYSTEM_STACK_PREFIX[j];
                if(stackstr.startsWith(systemStack)){
                    isSystem = true;
                    break;
                }
            }
            if(!isSystem){
                return true;
            }
        }
        return false;
    }

    private boolean release(String alias, long id, boolean force){
        try{
            return ProxoolFacade.killConnecton(alias, id, !force);
        } catch(ProxoolException e){
        }
        return false;
    }
    
    private String updateTrace(String alias, boolean open){
        Properties info = new Properties();
        info.setProperty(ProxoolConstants.TRACE_PROPERTY, Boolean.valueOf(open).toString());
        try{
            ProxoolFacade.updateConnectionPool(ProxoolConstants.PROPERTY_PREFIX+alias, info);
            return (open ? "open" : "close") + " trace success, alias: " + alias;       
        } catch (Exception e){
            e.printStackTrace();
            return (open ? "open" : "close") + " trace fail, alias: " + alias + ", error: " + e.getMessage();
        }
    }
    
    private String openTrace(String alias){
        return updateTrace(alias, true);
    }
    
    private String closeTrace(String alias){
        return updateTrace(alias, false);
    }
    
    
    //XXX
    private static final String POOL_TIMER_NAME = "_pool_timer_";
    private static final BaseBean baseBean = new BaseBean();

    /**
     * 获取线程堆栈信息
     */
    public static String getJstackInfo(String threadName) {
        if(threadName == null || threadName.trim().length() == 0){
            return null;
        }
        StringBuilder sb = new StringBuilder();
        ThreadMXBean tb = ManagementFactory.getThreadMXBean();
        long[] tids = tb.getAllThreadIds();
        boolean exist = false;
        for (int i = 0; i < tids.length; i++) {
            long cputime = tb.getThreadCpuTime(tids[i]);
            ThreadInfo info = tb.getThreadInfo(tids[i], Integer.MAX_VALUE);
            if (null == info) {
                continue;
            }
            if(info.getThreadName().equals(threadName)){
                exist = true;
                sb.append("\"").append(info.getThreadName()).append("\"")
                .append("&nbsp;").append("id").append("=\"")
                .append(info.getThreadId()).append("\"&nbsp;")
                .append("CPU_Time=").append(cputime).append("&nbsp;<br/>");
                
                Thread.State state = info.getThreadState();
                sb.append("&nbsp;java.lang.Thread.State:&nbsp;").append(state.name()).append("&nbsp;<br/>");
                StackTraceElement[] stacks = info.getStackTrace();
                if (null != stacks) {
                    for (StackTraceElement stack : stacks) {
                        sb.append("&nbsp;&nbsp;at&nbsp;").append(stack.toString()).append("<br/>");
                    }
                    
                    //sb.append("isDummy: "+!isCustomerStack(stacks)+"&nbsp;");             
                }
                break;
            }
        }
        if(!exist){
            sb.append("thread " + threadName + " doesn't exist right now!");
        }
        return sb.toString();
    }
    
    /**
     * 停止单个线程(线程处于死锁状态时不一定能停止该线程)，并释放这个线程持有的所有连接
     * @param threadName 线程名称
     * @return
     */
    public boolean killThread(String threadName){
        if(threadName == null || threadName.trim().length() == 0){
            return false;
        }
        releaseByThreadName(threadName);
        
        Thread tar = getThread(threadName);
        if(tar != null){
            stopThreadByReflect(tar);
            return true;
        }
        return false;
    }
    
    /**
     * 停止单个线程(线程处于死锁状态时不一定能停止该线程)，并释放这个线程持有的所有连接
     * @param threadId 线程id
     * @return
     */
    public boolean killThread(long threadId){
        Thread tar = getThread(threadId);
        if(tar != null){
            String threadName = tar.getName();
            releaseByThreadName(threadName);
            stopThreadByReflect(tar);
            return true;
        }
        return false;
    }
    
    public int killThreads(List<Long> toKillIds){
        if(toKillIds == null || toKillIds.size() == 0){
            return -1;
        }
        int count = 0;
        try {
            List<String> ts = new ArrayList<String>();
            ThreadGroup rootGroup = Thread.currentThread().getThreadGroup();
            while (rootGroup.getParent() != null) {
                rootGroup = rootGroup.getParent();
            }
            
            Thread[] tds = new Thread[(int) (rootGroup.activeCount() * 1.5)];
            int tc = rootGroup.enumerate(tds, true);
            for (int i = 0; i < tc; i++) {
                if(toKillIds.contains(tds[i].getId())){
                    ts.add(tds[i].getName());
                    stopThreadByReflect(tds[i]);
                    count ++;
                }
            }
            for(String tname : ts){
                releaseByThreadName(tname);
            }
        } catch (Throwable t) {
            // TODO: handle exception
        }
        return count;
    }
    
    void stopThreadByReflect(Thread t) {
        try {
            ThreadDeath death = new ThreadDeath();
            Method resume0Method = Thread.class.getDeclaredMethod("resume0");
            Method stop0Method = Thread.class.getDeclaredMethod("stop0", Object.class);
            resume0Method.setAccessible(true);
            stop0Method.setAccessible(true);
            resume0Method.invoke(t);
            stop0Method.invoke(t, death);
            baseBean.writeLog("stopThreadByReflect, threadId: " + t.getId() + ", threadName: " + t.getName());
        } catch (Throwable th) {
        }
    }
    
    void stopThreadByOriMethod(Thread t) throws Throwable{
        t.stop();
        baseBean.writeLog("stopThreadByOriMethod, threadId: " + t.getId() + ", threadName: " + t.getName());
    }
    
    private Thread getThread(String threadName){
        ThreadGroup rootGroup = Thread.currentThread().getThreadGroup();
        while (rootGroup.getParent() != null) {
            rootGroup = rootGroup.getParent();
        }

        Thread[] tds = new Thread[(int) (rootGroup.activeCount() * 1.5)];
        int tc = rootGroup.enumerate(tds, true);
        for (int i = 0; i < tc; i++) {
            if (tds[i].getName().equals(threadName)) {
                return tds[i];
            }
        }
        return null;
    }
    
    private Thread getThread(long threadId){
        ThreadGroup rootGroup = Thread.currentThread().getThreadGroup();
        while (rootGroup.getParent() != null) {
            rootGroup = rootGroup.getParent();
        }

        Thread[] tds = new Thread[(int) (rootGroup.activeCount() * 1.5)];
        int tc = rootGroup.enumerate(tds, true);
        for (int i = 0; i < tc; i++) {
            if (tds[i].getId() == threadId) {
                return tds[i];
            }
        }
        return null;
    }
    
    private int releaseByThreadName(String threadName){
        int i = 0;
        try{
            for(String alias : ProxoolFacade.getAliases()){
                SnapshotIF snapshot = ProxoolFacade.getSnapshot(alias, true);
                ConnectionInfoIF[] connInfos = snapshot.getConnectionInfos();
                if(connInfos != null){
                    for(ConnectionInfoIF connInfo : connInfos){
                        if(threadName.equals(connInfo.getRequester())){
                            if(release(alias, connInfo.getId(), true)){
                                i++;
                            }
                        }
                    }
                }
            }
        } catch(ProxoolException e){
        }
        return i;
    } 
    
    private static void appendSqlLog(BufferedWriter w, ConnectionInfoIF connInfo, String alias, String fileName) throws Exception{
        String[] sqls = connInfo.getSqlCalls();
        if(sqls != null){
            String threadName = connInfo.getRequester();
            long actualActiveTime = 0;
            if (connInfo.getTimeLastStopActive() > 0) {
                actualActiveTime = connInfo.getTimeLastStopActive() - connInfo.getTimeLastStartActive();
            } else if (connInfo.getTimeLastStartActive() > 0) {
                SnapshotIF snapshot = ProxoolFacade.getSnapshot(alias, true);
                actualActiveTime = snapshot.getSnapshotDate().getTime() - connInfo.getTimeLastStartActive();
            }
            if(w == null){
                w = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(new File(fileName)), "UTF-8"));
            }
            w.append("connId="+ connInfo.getId())
                    .append(" threadName=")
                    .append(threadName)
                    .append(" lastStart=")
                    .append(connInfo
                            .getTimeLastStartActive() > 0 ? SIMPLE_DATE_FORMAT.format(new Date(
                            connInfo.getTimeLastStartActive()))
                            : "-")
                    .append(" ")
                    .append("lap(ms):"
                            + actualActiveTime).append(lineSep);
            for(int j=0;j<sqls.length && j<5;j++){
                w.append(sqls[j]).append(lineSep);
            }
        }
    }

    public Object[] releaseAllActiveConn(String alias, long activeTime){
        BufferedWriter w = null;
        try{
            String fileName = "sql_release_all_" + System.currentTimeMillis() + ".log";
            //获取快照及连接详情
            SnapshotIF snapshot = ProxoolFacade.getSnapshot(alias, true);
            ConnectionInfoIF[] connInfos = snapshot.getConnectionInfos();
            if(connInfos != null){
                int releaseCount = 0;
                for(int i=0;i<connInfos.length;i++){
                    ConnectionInfoIF connInfo = connInfos[i];
                    //如果是活动连接
                    if(connInfo.getStatus() == ConnectionInfoIF.STATUS_ACTIVE){
                        long actualActiveTime = 0;
                        if (connInfo.getTimeLastStopActive() > 0) {
                            actualActiveTime = connInfo.getTimeLastStopActive() - connInfo.getTimeLastStartActive();
                        } else if (connInfo.getTimeLastStartActive() > 0) {
                            actualActiveTime = snapshot.getSnapshotDate().getTime() - connInfo.getTimeLastStartActive();
                        }
                        //如果连接活动时间大于指定的阈值
                        if(actualActiveTime > activeTime){
                            String threadName = connInfo.getRequester();
                            if(threadName != null){
                                appendSqlLog(w, connInfo, alias, fileName);
                                //释放该连接
                                if(release(alias, connInfo.getId(), true)){
                                    releaseCount++;
                                }
                            }
                        }
                    }
                }
                return new Object[]{releaseCount, fileName};
            }
            
        } catch(Exception e){
        } finally {
            if(w != null){
                try {
                    w.close();
                } catch (Exception e) {
                }
            }
        }
        return null;
    }
    
%>