
<%
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>
<%!private boolean isInitDebug() {
        try {
            Class debugAgent = Class.forName("com.weaver.onlinedebug.DebugAgent");
            Boolean isInitAll = (Boolean) debugAgent.getDeclaredMethod("isInitAll", new Class[] {}).invoke(null, new Object[] {});
            if (isInitAll != null && isInitAll.booleanValue()) {
                return true;
            }
        } catch (Exception e) {
            //e.printStackTrace();
        }
        return false;

    }%>

<%
    String debugDataKey = "weaver_onlinedebug_debugdata";
    String debugCurrentClassKey = "weaver_onlinedebug_debugcurrentclass";
    String debugCurrentLineKey = "weaver_onlinedebug_debugcurrentline";
    String debugCurrentSeqKey = "weaver_onlinedebug_debugcurrentseq";

    Object user = session.getAttribute("weaver_user@bean");
    if (user == null) {
        out.print("请先登录系统&nbsp;&nbsp;<input type='button' value='重试' onclick=\"javascript:top.location='/debug/debug.jsp'\"> ");
        return;
    }

    Object debugCurrentClass = session.getAttribute(debugCurrentClassKey);
    Object debugCurrentLine = session.getAttribute(debugCurrentLineKey);
%>