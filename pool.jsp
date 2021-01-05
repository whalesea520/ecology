<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="org.apache.commons.logging.Log"%>
<%@page import="org.apache.commons.logging.LogFactory"%>
<%@page import="org.logicalcobwebs.proxool.*"%>
<%@page import="org.logicalcobwebs.proxool.admin.SnapshotIF"%>
<%@page import="org.logicalcobwebs.proxool.admin.StatisticsIF"%>

<%@page import="javax.servlet.ServletException"%>
<%@page import="javax.servlet.ServletOutputStream"%>
<%@page import="java.io.IOException"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Properties"%>
<%@page import="java.lang.management.ManagementFactory"%>
<%@page import="java.lang.management.ThreadInfo"%>
<%@page import="java.lang.management.ThreadMXBean"%>

<%@page import="weaver.general.StaticObj"%>
<%@page import="weaver.hrm.User"%>

<%
User user = (User) session.getAttribute("weaver_user@bean");
if(user == null || !"sysadmin".equals(user.getLoginid())){
	out.print("auth fail, please contact sysadmin...");
	return;
}
%>

<HTML>
<HEAD>
<meta charset="utf-8">
<meta http-equiv="Pragma" content="no-cache">
<TITLE>Proxool Admin</TITLE>
</HEAD>
<BODY>

<%!
private static final Log LOG = LogFactory.getLog(org.logicalcobwebs.proxool.admin.servlet.AdminServlet.class);
private static final String[] STATUS_CLASSES = {"null", "available", "active", "offline"};
public static final String OUTPUT_FULL = "full";
public static final String OUTPUT_SIMPLE = "simple";
private String output;
private String[] cssFiles;
private String[] jsFiles;
private static final String STATISTIC = "statistic";
private static final String CORE_PROPERTY = "core-property";
private static final String STANDARD_PROPERTY = "standard-property";
private static final String DELEGATED_PROPERTY = "delegated-property";
private static final String SNAPSHOT = "snapshot";
private static final DateFormat TIME_FORMAT = new SimpleDateFormat("HH:mm:ss");
private static final DateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
private static final DecimalFormat DECIMAL_FORMAT = new DecimalFormat("0.00");
private static final String DETAIL = "detail";
private static final String DETAIL_MORE = "more";
private static final String DETAIL_LESS = "less";
private static final String TAB = "tab";
private static final String TAB_DEFINITION = "definition";
private static final String TAB_SNAPSHOT = "snapshot";
private static final String TAB_STATISTICS = "statistics";
private static final String ALIAS = "alias";
private static final String CONNECTION_ID = "id";
private static final String POOL_TIMER_NAME = "_pool_timer_";
private StaticObj staticObj = StaticObj.getInstance();
%>

<%!
/**
 * Output the tabs that we are showing at the top of the page
 * @param out where to write the HTNL to
 * @param alias the current pool
 * @param link the URL to get back to this servlet
 * @param tab the active tab
 * @param statisticsAvailable whether statistics are available (true if configured and ready)
 * @param statisticsComingSoon whether statistics will be available (true if configured but not ready yet)
 */
private void doTabs(ServletOutputStream out, String alias, String link, String tab, boolean statisticsAvailable, boolean statisticsComingSoon) throws IOException {
    out.println("<ul>");
    out.println("<li class=\"" + (tab.equals(TAB_DEFINITION) ? "active" : "inactive") + "\"><a class=\"quiet\" href=\"" + link + "?alias=" + alias + "&tab=" + TAB_DEFINITION + "\">Definition</a></li>");
    out.println("<li class=\"" + (tab.equals(TAB_SNAPSHOT) ? "active" : "inactive") + "\"><a class=\"quiet\" href=\"" + link + "?alias=" + alias + "&tab=" + TAB_SNAPSHOT + "\">Snapshot</a></li>");
    if (statisticsAvailable) {
        out.println("<li class=\"" + (tab.equals(TAB_STATISTICS) ? "active" : "inactive") + "\"><a class=\"quiet\" href=\"" + link + "?alias=" + alias + "&tab=" + TAB_STATISTICS + "\">Statistics</a></li>");
    } else if (statisticsComingSoon) {
        out.println("<li class=\"disabled\">Statistics</li>");
    }
    out.println("</ul>");
}

/**
 * Output the statistics. If there are more than one set of statistics then show them all.
 * @param out where to write HTML to
 * @param statisticsArray the statistics we have ready to see
 * @param cpd defines the connection
 */
private void doStatistics(ServletOutputStream out, StatisticsIF[] statisticsArray, ConnectionPoolDefinitionIF cpd) throws IOException {

    for (int i = 0; i < statisticsArray.length; i++) {
        StatisticsIF statistics = statisticsArray[i];

        openDataTable(out);

        printDefinitionEntry(out, ProxoolConstants.ALIAS, cpd.getAlias(), CORE_PROPERTY);

        // Period
        printDefinitionEntry(out, "Period", TIME_FORMAT.format(statistics.getStartDate()) + " to " + TIME_FORMAT.format(statistics.getStopDate()), STATISTIC);

        // Served
        printDefinitionEntry(out, "Served", statistics.getServedCount() + " (" + DECIMAL_FORMAT.format(statistics.getServedPerSecond()) + "/s)", STATISTIC);

        // Refused
        printDefinitionEntry(out, "Refused", statistics.getRefusedCount() + " (" + DECIMAL_FORMAT.format(statistics.getRefusedPerSecond()) + "/s)", STATISTIC);

        // averageActiveTime
        printDefinitionEntry(out, "Average active time", DECIMAL_FORMAT.format(statistics.getAverageActiveTime() / 1000) + "s", STATISTIC);

        // activityLevel
        StringBuffer activityLevelBuffer = new StringBuffer();
        int activityLevel = (int) (100 * statistics.getAverageActiveCount() / cpd.getMaximumConnectionCount());
        activityLevelBuffer.append(activityLevel);
        activityLevelBuffer.append("%<br/>");
        String[] colours = {"0000ff", "eeeeee"};
        int[] lengths = {activityLevel, 100 - activityLevel};
        drawBarChart(activityLevelBuffer, colours, lengths);
        printDefinitionEntry(out, "Activity level", activityLevelBuffer.toString(), STATISTIC);

        closeTable(out);
    }
}

/**
 * We can draw a bar chart simply enough. The two arrays passed as parameters must be of equal length
 * @param out where to write the HTML
 * @param colours the colur (CSS valid string) for each segment
 * @param lengths the length of each segment. Can be any size since the chart just takes up as much room
 * as possible as uses the relative length of each segment.
 */
private void drawBarChart(StringBuffer out, String[] colours, int[] lengths) {
    out.append("<table style=\"margin: 8px; font-size: 50%;\" width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\"><tr>");

    // Calculate total length
    int totalLength = 0;
    for (int i = 0; i < colours.length; i++) {
        totalLength += lengths[i];
    }

    // Draw segments
    for (int j = 0; j < colours.length; j++) {
        String colour = colours[j];
        int length = lengths[j];
        if (length > 0) {
            out.append("<td style=\"background-color: #");
            out.append(colour);
            out.append("\" width=\"");
            out.append(100 * length / totalLength);
            out.append("%\">&nbsp;</td>");
        }
    }
    out.append("</tr></table>");
}

/**
 * Output the {@link ConnectionPoolDefinitionIF definition}
 * @param out where to write the HTML
 * @param cpd the definition
 */
private void doDefinition(ServletOutputStream out, ConnectionPoolDefinitionIF cpd) throws IOException {
    openDataTable(out);

    /*
        TODO: it would be nice to have meta-data in the definition so that this is much easier.
     */
    printDefinitionEntry(out, ProxoolConstants.ALIAS, cpd.getAlias(), CORE_PROPERTY);
    printDefinitionEntry(out, ProxoolConstants.DRIVER_URL, cpd.getUrl(), CORE_PROPERTY);
    printDefinitionEntry(out, ProxoolConstants.DRIVER_CLASS, cpd.getDriver(), CORE_PROPERTY);
    printDefinitionEntry(out, ProxoolConstants.MINIMUM_CONNECTION_COUNT, String.valueOf(cpd.getMinimumConnectionCount()), STANDARD_PROPERTY);
    printDefinitionEntry(out, ProxoolConstants.MAXIMUM_CONNECTION_COUNT, String.valueOf(cpd.getMaximumConnectionCount()), STANDARD_PROPERTY);
    printDefinitionEntry(out, ProxoolConstants.PROTOTYPE_COUNT, cpd.getPrototypeCount() > 0 ? String.valueOf(cpd.getPrototypeCount()) : null, STANDARD_PROPERTY);
    printDefinitionEntry(out, ProxoolConstants.SIMULTANEOUS_BUILD_THROTTLE, String.valueOf(cpd.getSimultaneousBuildThrottle()), STANDARD_PROPERTY);
    printDefinitionEntry(out, ProxoolConstants.MAXIMUM_CONNECTION_LIFETIME, formatMilliseconds(cpd.getMaximumConnectionLifetime()), STANDARD_PROPERTY);
    printDefinitionEntry(out, ProxoolConstants.MAXIMUM_ACTIVE_TIME, formatMilliseconds(cpd.getMaximumActiveTime()), STANDARD_PROPERTY);
    printDefinitionEntry(out, ProxoolConstants.HOUSE_KEEPING_SLEEP_TIME, (cpd.getHouseKeepingSleepTime() / 1000) + "s", STANDARD_PROPERTY);
    printDefinitionEntry(out, ProxoolConstants.HOUSE_KEEPING_TEST_SQL, cpd.getHouseKeepingTestSql(), STANDARD_PROPERTY);
    printDefinitionEntry(out, ProxoolConstants.TEST_BEFORE_USE, String.valueOf(cpd.isTestBeforeUse()), STANDARD_PROPERTY);
    printDefinitionEntry(out, ProxoolConstants.TEST_AFTER_USE, String.valueOf(cpd.isTestAfterUse()), STANDARD_PROPERTY);
    printDefinitionEntry(out, ProxoolConstants.RECENTLY_STARTED_THRESHOLD, formatMilliseconds(cpd.getRecentlyStartedThreshold()), STANDARD_PROPERTY);
    printDefinitionEntry(out, ProxoolConstants.OVERLOAD_WITHOUT_REFUSAL_LIFETIME, formatMilliseconds(cpd.getOverloadWithoutRefusalLifetime()), STANDARD_PROPERTY);
    printDefinitionEntry(out, ProxoolConstants.INJECTABLE_CONNECTION_INTERFACE_NAME, String.valueOf(cpd.getInjectableConnectionInterface()), STANDARD_PROPERTY);
    printDefinitionEntry(out, ProxoolConstants.INJECTABLE_STATEMENT_INTERFACE_NAME, String.valueOf(cpd.getInjectableStatementInterface()), STANDARD_PROPERTY);
    printDefinitionEntry(out, ProxoolConstants.INJECTABLE_CALLABLE_STATEMENT_INTERFACE_NAME, String.valueOf(cpd.getInjectableCallableStatementInterface()), STANDARD_PROPERTY);
    printDefinitionEntry(out, ProxoolConstants.INJECTABLE_PREPARED_STATEMENT_INTERFACE_NAME, String.valueOf(cpd.getInjectablePreparedStatementInterface()), STANDARD_PROPERTY);

    // fatalSqlExceptions
    String fatalSqlExceptions = null;
    if (cpd.getFatalSqlExceptions() != null && cpd.getFatalSqlExceptions().size() > 0) {
        StringBuffer fatalSqlExceptionsBuffer = new StringBuffer();
        Iterator i = cpd.getFatalSqlExceptions().iterator();
        while (i.hasNext()) {
            String s = (String) i.next();
            fatalSqlExceptionsBuffer.append(s);
            fatalSqlExceptionsBuffer.append(i.hasNext() ? ", " : "");
        }
        fatalSqlExceptions = fatalSqlExceptionsBuffer.toString();
    }
    printDefinitionEntry(out, ProxoolConstants.FATAL_SQL_EXCEPTION, fatalSqlExceptions, STANDARD_PROPERTY);
    printDefinitionEntry(out, ProxoolConstants.FATAL_SQL_EXCEPTION_WRAPPER_CLASS, cpd.getFatalSqlExceptionWrapper(), STANDARD_PROPERTY);
    printDefinitionEntry(out, ProxoolConstants.STATISTICS, cpd.getStatistics(), STANDARD_PROPERTY);
    printDefinitionEntry(out, ProxoolConstants.STATISTICS_LOG_LEVEL, cpd.getStatisticsLogLevel(), STANDARD_PROPERTY);
    printDefinitionEntry(out, ProxoolConstants.VERBOSE, String.valueOf(cpd.isVerbose()), STANDARD_PROPERTY);
    printTraceEntry(out, ProxoolConstants.TRACE, String.valueOf(cpd.isTrace()), STANDARD_PROPERTY, cpd.getAlias());
    // Now all the properties that are forwarded to the delegate driver.
    Properties p = cpd.getDelegateProperties();
    Iterator i = p.keySet().iterator();
    while (i.hasNext()) {
        String name = (String) i.next();
        String value = p.getProperty(name);
        // Better hide the password!
        if (name.toLowerCase().indexOf("password") > -1 || name.toLowerCase().indexOf("passwd") > -1) {
            value = "******";
        }
        printDefinitionEntry(out, name + " (delegated)", value, DELEGATED_PROPERTY);
    }

    closeTable(out);

}

/**
 * Output a {@link SnapshotIF snapshot} of the pool.
 * @param out where to write the HTML
 * @param cpd defines the pool
 * @param link the URL back to this servlet
 * @param level either {@link #DETAIL_LESS} or {@link #DETAIL_MORE}
 * @param connectionId the connection we want to drill into (optional)
 */
private void doSnapshot(ServletOutputStream out, ConnectionPoolDefinitionIF cpd, String link, String level, String connectionId) throws IOException, ProxoolException {
    boolean detail = (level != null && level.equals(DETAIL_MORE));
    SnapshotIF snapshot = ProxoolFacade.getSnapshot(cpd.getAlias(), detail);

    if (snapshot != null) {

        openDataTable(out);

        printDefinitionEntry(out, ProxoolConstants.ALIAS, cpd.getAlias(), CORE_PROPERTY);

        // dateStarted
        printDefinitionEntry(out, "Start date", DATE_FORMAT.format(snapshot.getDateStarted()), SNAPSHOT);

        // snapshot date
        printDefinitionEntry(out, "Snapshot", TIME_FORMAT.format(snapshot.getSnapshotDate()), SNAPSHOT);

        // connections
        StringBuffer connectionsBuffer = new StringBuffer();
        connectionsBuffer.append(snapshot.getActiveConnectionCount());
        connectionsBuffer.append(" (active), ");
        connectionsBuffer.append(snapshot.getAvailableConnectionCount());
        connectionsBuffer.append(" (available), ");
        if (snapshot.getOfflineConnectionCount() > 0) {
            connectionsBuffer.append(snapshot.getOfflineConnectionCount());
            connectionsBuffer.append(" (offline), ");
        }
        connectionsBuffer.append(snapshot.getMaximumConnectionCount());
        connectionsBuffer.append(" (max)<br/>");
        String[] colours = {"ff9999", "66cc66", "cccccc"};
        int[] lengths = {snapshot.getActiveConnectionCount(), snapshot.getAvailableConnectionCount(),
                snapshot.getMaximumConnectionCount() - snapshot.getActiveConnectionCount() - snapshot.getAvailableConnectionCount()};
        drawBarChart(connectionsBuffer, colours, lengths);
        printDefinitionEntry(out, "Connections", connectionsBuffer.toString(), SNAPSHOT);

        // servedCount
        printDefinitionEntry(out, "Served", String.valueOf(snapshot.getServedCount()), SNAPSHOT);

        // refusedCount
        printDefinitionEntry(out, "Refused", String.valueOf(snapshot.getRefusedCount()), SNAPSHOT);

        //TODO releaseAllActiveConnOfDummyThread
        out.println("    <tr>");
	    out.print("      <th valign=\"top\">");
	    out.print("Pool option");
	    out.println(":</th>");
	    out.print("      <td class=\"" + SNAPSHOT + "\"nowrap>");
        out.print("&nbsp;Clean ActiveTime:&nbsp;<input value=\"60\" id=\"cleanActiveTime\" style=\"width:100px;\">S");
        out.print("&nbsp;<input type=\"button\" value=\"clear leak\" id=\"cleanButton\" onclick=\"releaseAllActiveConnOfDummyThread('"+cpd.getAlias()+"')\" >");
        out.print("&nbsp;<input type=\"button\" value=\"clean active\" id=\"cleanActiveButton\" onclick=\"releaseAllActiveConn('"+cpd.getAlias()+"')\" >&nbsp;<br>");
        //out.print("&nbsp;<input type=\"button\" value=\"clear leak\" id=\"cleanButton\" onclick=\"releaseAllActiveConnOfDummyThread('"+cpd.getAlias()+"')\" title=\"将会释放所有空线程占用的活动连接，其活动时间超过输入框中的时间，单位:秒\" >");
        //out.print("&nbsp;<input type=\"button\" value=\"clean active\" id=\"cleanActiveButton\" onclick=\"releaseAllActiveConn('"+cpd.getAlias()+"')\" title=\"将会释放所有活动连接，其活动时间超过输入框中的时间，单位:秒\" >");
        //out.print("&nbsp;(will release all active connections of dummy thread which active time greater than the input)&nbsp;<br>");
        //out.print("&nbsp;(将会释放所有空线程占用的活动连接，其活动时间超过输入框中的时间，单位:秒)&nbsp;");
	    
        out.print("&nbsp;Clean ActiveTime:&nbsp;<input value=\"10\" id=\"autoCleanActiveTime\" style=\"width:100px;\">Min");
        if(staticObj.getObject(POOL_TIMER_NAME + cpd.getAlias()) == null){
	        out.print("&nbsp;<input type=\"button\" value=\"start auto release\" id=\"autoCleanButton\" onclick=\"startAutoClean('"+cpd.getAlias()+"')\">");
        } else {
        	out.print("&nbsp;<input type=\"button\" value=\"stop auto release\" id=\"autoCleanButton\" onclick=\"stopAutoClean('"+cpd.getAlias()+"')\">");
        }
       	out.print("&nbsp;(auto release active connections which active time greater than the input)&nbsp;");
       	
        out.print("</td>");
	    out.println("    </tr>");
	    
        if (!detail) {
            out.println("    <tr>");
            out.print("        <td colspan=\"2\" align=\"right\"><form action=\"" + link + "\" method=\"GET\">");
            out.print("<input type=\"hidden\" name=\"" + ALIAS + "\" value=\"" + cpd.getAlias() + "\">");
            out.print("<input type=\"hidden\" name=\"" + TAB + "\" value=\"" + TAB_SNAPSHOT + "\">");
            out.print("<input type=\"hidden\" name=\"" + DETAIL + "\" value=\"" + DETAIL_MORE + "\">");
            out.print("<input type=\"submit\" value=\"More information&gt;\">");
            out.println("</form></td>");
            out.println("    </tr>");
        } else {

            out.println("    <tr>");
            out.print("      <th width=\"200\" valign=\"top\">");
            out.print("Details:<br>(click ID to drill down)");
            out.println("</th>");
            out.print("      <td>");

            doSnapshotDetails(out, cpd, snapshot, link, connectionId);

            out.println("</td>");
            out.println("    </tr>");

            long drillDownConnectionId;
            if (connectionId != null) {
                drillDownConnectionId = Long.valueOf(connectionId).longValue();
                ConnectionInfoIF drillDownConnection = snapshot.getConnectionInfo(drillDownConnectionId);
                if (drillDownConnection != null) {
                    out.println("    <tr>");
                    out.print("      <th valign=\"top\">");
                    out.print("Connection #" + connectionId);
                    out.println("</td>");
                    out.print("      <td>");

                    doDrillDownConnection(out, drillDownConnection);

                    out.println("</td>");
                    out.println("    </tr>");
                }
            }

            out.println("    <tr>");
            out.print("        <td colspan=\"2\" align=\"right\"><form action=\"" + link + "\" method=\"GET\">");
            out.print("<input type=\"hidden\" name=\"" + ALIAS + "\" value=\"" + cpd.getAlias() + "\">");
            out.print("<input type=\"hidden\" name=\"" + TAB + "\" value=\"" + TAB_SNAPSHOT + "\">");
            out.print("<input type=\"hidden\" name=\"" + DETAIL + "\" value=\"" + DETAIL_LESS + "\">");
            out.print("<input type=\"submit\" value=\"&lt; Less information\">");
            out.println("</form></td>");
            out.println("    </tr>");
        }

        closeTable(out);
    }
}

/**
 * If we want a {@link #DETAIL_MORE more} detailed {@link SnapshotIF snapshot} then {@link #doSnapshot(javax.servlet.ServletOutputStream, org.logicalcobwebs.proxool.ConnectionPoolDefinitionIF, String, String, String)}
 * calls this too
 * @param out where to write the HTML
 * @param cpd defines the pool
 * @param snapshot snapshot
 * @param link the URL back to this servlet
 * @param connectionId the connection we want to drill into (optional)
 * @param connectionId
 * @throws IOException
 */
private void doSnapshotDetails(ServletOutputStream out, ConnectionPoolDefinitionIF cpd, SnapshotIF snapshot, String link, String connectionId) throws IOException {

    long drillDownConnectionId = 0;
    if (connectionId != null) {
        drillDownConnectionId = Long.valueOf(connectionId).longValue();
    }

    if (snapshot.getConnectionInfos() != null && snapshot.getConnectionInfos().length > 0) {
        out.println("<table cellpadding=\"2\" cellspacing=\"0\" border=\"0\">");
        out.println("  <tbody>");

        out.print("<tr>");
        out.print("<td>#</td>");
        out.print("<td align=\"center\">born</td>");
        out.print("<td align=\"center\">last<br>start</td>");
        out.print("<td align=\"center\">lap<br>(ms)</td>");
        out.print("<td>&nbsp;thread</td>");
        out.print("<td>&nbsp;stack</td>");
        out.print("<td>&nbsp;option</td>");
        out.print("</tr>");

        ConnectionInfoIF[] connectionInfos = snapshot.getConnectionInfos();
        for (int i = 0; i < connectionInfos.length; i++) {
            ConnectionInfoIF connectionInfo = connectionInfos[i];

            if (connectionInfo.getStatus() != ConnectionInfoIF.STATUS_NULL) {

                out.print("<tr>");

                // drillDownConnectionId
                out.print("<td style=\"background-color: #");
                if (connectionInfo.getStatus() == ConnectionInfoIF.STATUS_ACTIVE) {
                    out.print("ffcccc");
                } else if (connectionInfo.getStatus() == ConnectionInfoIF.STATUS_AVAILABLE) {
                    out.print("ccffcc");
                } else if (connectionInfo.getStatus() == ConnectionInfoIF.STATUS_OFFLINE) {
                    out.print("ccccff");
                }
                out.print("\" style=\"");

                if (drillDownConnectionId == connectionInfo.getId()) {
                    out.print("border: 1px solid black;");
                    out.print("\">");
                    out.print(connectionInfo.getId());
                } else {
                    out.print("border: 1px solid transparent;");
                    out.print("\"><a href=\"");
                    out.print(link);
                    out.print("?");
                    out.print(ALIAS);
                    out.print("=");
                    out.print(cpd.getAlias());
                    out.print("&");
                    out.print(TAB);
                    out.print("=");
                    out.print(TAB_SNAPSHOT);
                    out.print("&");
                    out.print(DETAIL);
                    out.print("=");
                    out.print(DETAIL_MORE);
                    out.print("&");
                    out.print(CONNECTION_ID);
                    out.print("=");
                    out.print(connectionInfo.getId());
                    out.print("\">");
                    out.print(connectionInfo.getId());
                    out.print("</a>");
                }
                out.print("</td>");

                // birth
                out.print("<td>&nbsp;");
                out.print(TIME_FORMAT.format(connectionInfo.getBirthDate()));
                out.print("</td>");

                // started
                out.print("<td>&nbsp;");
                out.print(connectionInfo.getTimeLastStartActive() > 0 ? TIME_FORMAT.format(new Date(connectionInfo.getTimeLastStartActive())) : "-");
                out.print("</td>");

                // active
                out.print("<td align=\"right\" class=\"");
                out.print(getStatusClass(connectionInfo));
                out.print("\">");
                String active = "&nbsp;";
                if (connectionInfo.getTimeLastStopActive() > 0) {
                    active = String.valueOf((int) (connectionInfo.getTimeLastStopActive() - connectionInfo.getTimeLastStartActive()));
                } else if (connectionInfo.getTimeLastStartActive() > 0) {
                    active = String.valueOf((int) (snapshot.getSnapshotDate().getTime() - connectionInfo.getTimeLastStartActive()));
                }
                out.print(active);
                out.print("&nbsp;&nbsp;</td>");

                // requester
                String requester = connectionInfo.getRequester();
                out.print("<td>&nbsp;");
                out.print(requester != null ? requester : "-");
                out.print("</td>");
                
             	//TODO stack
                out.print("<td>&nbsp;");
                if (requester == null) {
                	out.print("-");
                } else {
                    out.print("<a href=\"");
                    out.print("javascript:getJstackInfo('"+requester+"')");
                    out.print("\">jstack</a>");
                }
                out.print("&nbsp;</td>");
                
             	//TODO option: release, kill thread...
                out.print("<td>&nbsp;");
                if (requester == null) {
                	out.print("-");
                } else {
                	boolean isActive = connectionInfo.getStatus() == ConnectionInfoIF.STATUS_ACTIVE;
                	out.print("<a href=\"");
                    out.print("javascript:release('"+cpd.getAlias()+"', "+connectionInfo.getId()+", "+isActive+")");
                    out.print("\">release</a>&nbsp;&nbsp;");
                	
                    out.print("<a href=\"");
                    out.print("javascript:killThread('"+requester+"')");
                    out.print("\">killThread</a>");
                }
                out.print("&nbsp;</td>");

                out.println("</tr>");
            }
        }
        out.println("  </tbody>");
        out.println("</table>");

    } else {
        out.println("No connections yet");
    }
}

/**
 * What CSS class to use for a particular connection.
 * @param info so we know the {@link org.logicalcobwebs.proxool.ConnectionInfoIF#getStatus()} status
 * @return the CSS class
 * @see #STATUS_CLASSES
 */
private static String getStatusClass(ConnectionInfoIF info) {
    try {
        return STATUS_CLASSES[info.getStatus()];
    } catch (ArrayIndexOutOfBoundsException e) {
        LOG.warn("Unknown status: " + info.getStatus());
        return "unknown-" + info.getStatus();
    }
}

private void doDrillDownConnection(ServletOutputStream out, ConnectionInfoIF drillDownConnection) throws IOException {

    // sql calls
    String[] sqlCalls = drillDownConnection.getSqlCalls();
    for (int i = 0; sqlCalls != null && i < sqlCalls.length; i++) {
        String sqlCall = sqlCalls[i];
        out.print("<div class=\"drill-down\">");
        out.print("sql = ");
        out.print(sqlCall);
        out.print("</div>");
    }

    // proxy
    out.print("<div class=\"drill-down\">");
    out.print("proxy = ");
    out.print(drillDownConnection.getProxyHashcode());
    out.print("</div>");

    // delegate
    out.print("<div class=\"drill-down\">");
    out.print("delegate = ");
    out.print(drillDownConnection.getDelegateHashcode());
    out.print("</div>");

    // url
    out.print("<div class=\"drill-down\">");
    out.print("url = ");
    out.print(drillDownConnection.getDelegateUrl());
    out.print("</div>");

}

private void openHtml(ServletOutputStream out) throws IOException {
    //out.println("<html><header><title>Proxool Admin</title>");
    //out.println("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8;\">");
    out.println("<style media=\"screen\">");
    out.println("body {background-color: #93bde6;}\n" +
            "div.version {font-weight: bold; font-size: 100%; margin-bottom: 8px;}\n" +
            "h1 {font-weight: bold; font-size: 100%}\n" +
            "option {padding: 2px 24px 2px 4px;}\n" +
            "input {margin: 0px 0px 4px 12px;}\n" +
            "table.data {font-size: 90%; border-collapse: collapse; border: 1px solid black;}\n" +
            "table.data th {background: #bddeff; width: 25em; text-align: left; padding-right: 8px; font-weight: normal; border: 1px solid black;}\n" +
            "table.data td {background: #ffffff; vertical-align: top; padding: 0px 2px 0px 2px; border: 1px solid black;}\n" +
            "td.null {background: yellow;}\n" +
            "td.available {color: black;}\n" +
            "td.active {color: red;}\n" +
            "td.offline {color: blue;}\n" +
            "div.drill-down {}\n" +
            "ul {list-style: none; padding: 0px; margin: 0px; position: relative; font-size: 90%;}\n" +
            "li {padding: 0px; margin: 0px 4px 0px 0px; display: inline; border: 1px solid black; border-width: 1px 1px 0px 1px;}\n" +
            "li.active {background: #bddeff;}\n" +
            "li.inactive {background: #eeeeee;}\n" +
            "li.disabled {background: #dddddd; color: #999999; padding: 0px 4px 0px 4px;}\n" +
            "a.quiet {color: black; text-decoration: none; padding: 0px 4px 0px 4px; }\n" +
            "a.quiet:hover {background: white;}\n");
    out.println("</style>");
    // If we have configured cssFiles then that will override what we have above
    if (cssFiles != null) {
    	for(String cssFile : cssFiles){
	        out.println("<link rel=\"stylesheet\" media=\"screen\" type=\"text/css\" href=\"" + cssFile + "\"></script>");
    	}
    }
    if (jsFiles != null) {
    	for(String jsFile : jsFiles){
	        out.println("<script type=\"text/javascript\" src=\""+jsFile+"\" charset=\"UTF-8\"></script>");
    	}
    }
    
    //out.println("</header><body>");
}

private void closeHtml(ServletOutputStream out) throws IOException {
    //out.println("</body></html>");
}

private void openDataTable(ServletOutputStream out) throws IOException {
    out.println("<table cellpadding=\"2\" cellspacing=\"0\" border=\"1\" class=\"data\">");
    out.println("  <tbody>");
}

private void closeTable(ServletOutputStream out) throws IOException {
    out.println("  </tbody>");
    out.println("</table>");
    out.println("<br/>");
}

private void printTraceEntry(ServletOutputStream out, String name, String value, String type, String alias) throws IOException {
    out.println("    <tr>");
    out.print("      <th valign=\"top\">");
    out.print(name);
    out.println(":</th>");
    out.print("      <td class=\"" + type + "\"nowrap>");
    if (value != null && !value.equals("null")) {
        out.print(value);
        if(value == "true"){
        	out.print("&nbsp;&nbsp;<input value=\"Close\" type=\"button\" onclick=\"closeTrace('"+alias+"')\">");
        } else if(value == "false"){
        	out.print("&nbsp;&nbsp;<input value=\"Open\" type=\"button\" onclick=\"openTrace('"+alias+"')\">");
        }
    } else {
        out.print("-");
    }
    out.print("</td>");
    out.println("    </tr>");
}

private void printDefinitionEntry(ServletOutputStream out, String name, String value, String type) throws IOException {
    out.println("    <tr>");
    out.print("      <th valign=\"top\">");
    out.print(name);
    out.println(":</th>");
    out.print("      <td class=\"" + type + "\"nowrap>");
    if (value != null && !value.equals("null")) {
        out.print(value);
    } else {
        out.print("-");
    }
    out.print("</td>");
    out.println("    </tr>");
}

/**
 * Output the list of available connection pools. If there are none then display a message saying that.
 * If there is only one then just display nothing (and the pool will displayed by default)
 * @param out where to write the HTML
 * @param alias identifies the current pool
 * @param tab identifies the tab we are on so that changing pools doesn't change the tab
 * @param link the URL back to this servlet
 */
private void doList(ServletOutputStream out, String alias, String tab, String link) throws IOException {

    String[] aliases = ProxoolFacade.getAliases();

    if (aliases.length == 0) {
        out.println("<p>No pools have been registered.</p>");
    } else if (aliases.length == 1) {
        // Don't bother listing. Just show it.
    } else {
        out.println("<form action=\"" + link + "\" method=\"GET\" name=\"alias\">");
        out.println("<select name=\"alias\" size=\"" + Math.min(aliases.length, 5) + "\">");
        for (int i = 0; i < aliases.length; i++) {
            out.print("  <option value=\"");
            out.print(aliases[i]);
            out.print("\"");
            out.print(aliases[i].equals(alias) ? " selected" : "");
            out.print(">");
            out.print(aliases[i]);
            out.println("</option>");
        }
        out.println("</select>");
        out.println("<input name=\"" + TAB + "\" value=\"" + tab + "\" type=\"hidden\">");
        out.println("<input value=\"Show\" type=\"submit\">");
        out.println("</form>");
    }
}

/**
 * Express time in an easy to read HH:mm:ss format
 *
 * @param time in milliseconds
 * @return time (e.g. 180000 = 00:30:00)
 * @see #TIME_FORMAT
 */
private String formatMilliseconds(long time) {
    if (time > Integer.MAX_VALUE) {
        return time + "ms";
    } else {
        Calendar c = Calendar.getInstance();
        c.clear();
        c.add(Calendar.MILLISECOND, (int) time);
        return TIME_FORMAT.format(c.getTime());
    }
}

%>

<%
output = OUTPUT_FULL;
cssFiles = new String[]{"/js/jquery/jquery_dialog.css","/js/jquery/jquery_dialog_wev8.css"};
jsFiles = new String[]{"/js/jquery/jquery.js","/js/jquery/jquery_dialog.js","/js/jquery/jquery_wev8.js","/js/jquery/jquery_dialog_wev8.js"};

response.setHeader("Pragma", "no-cache");
//response.setContentType("text/html;charset=UTF-8");
String link = request.getRequestURI();

// Check the alias and if not defined and there is only one
// then use that.
String alias = request.getParameter(ALIAS);
// Check we can find the pool.
ConnectionPoolDefinitionIF def = null;
if (alias != null) {
    try {
        def = ProxoolFacade.getConnectionPoolDefinition(alias);
    } catch (ProxoolException e) {
        alias = null;
    }
}
String[] aliases = ProxoolFacade.getAliases();
if (alias == null) {
    if (aliases.length > 0) {
        alias = aliases[0];
    }
}
if (def == null && alias != null) {
    try {
        def = ProxoolFacade.getConnectionPoolDefinition(alias);
    } catch (ProxoolException e) {
        throw new ServletException("Couldn't find pool with alias " + alias);
    }
}

String tab = request.getParameter(TAB);
if (tab == null) {
    tab = TAB_DEFINITION;
}

// If we are showing the snapshot, are we showing it in detail or not?
String snapshotDetail = request.getParameter(DETAIL);

// If we are showing the snapshot, are we drilling down into a connection?
String snapshotConnectionId = request.getParameter(CONNECTION_ID);

try {
    if (output.equals(OUTPUT_FULL)) {
        response.setContentType("text/html");
        openHtml(response.getOutputStream());
    }
    response.getOutputStream().println("<div class=\"version\">Proxool " + Version.getVersion() + "</div>");
    doList(response.getOutputStream(), alias, tab, link);
    // Skip everything if there aren't any pools
    if (aliases != null && aliases.length > 0) {
        StatisticsIF[] statisticsArray = ProxoolFacade.getStatistics(alias);
        final boolean statisticsAvailable = (statisticsArray != null && statisticsArray.length > 0);
        final boolean statisticsComingSoon = def.getStatistics() != null;
        // We can't be on the statistics tab if there are no statistics
        if (!statisticsComingSoon && tab.equals(TAB_STATISTICS)) {
            tab = TAB_DEFINITION;
        }
        doTabs(response.getOutputStream(), alias, link, tab, statisticsAvailable, statisticsComingSoon);
        if (tab.equals(TAB_DEFINITION)) {
            doDefinition(response.getOutputStream(), def);
        } else if (tab.equals(TAB_SNAPSHOT)) {
            doSnapshot(response.getOutputStream(), def, link, snapshotDetail, snapshotConnectionId);
        } else if (tab.equals(TAB_STATISTICS)) {
            doStatistics(response.getOutputStream(), statisticsArray, def);
        } else {
            throw new ServletException("Unrecognised tab '" + tab + "'");
        }
    }
} catch (ProxoolException e) {
    throw new ServletException("Problem serving Proxool Admin", e);
}

%>

<script type="text/javascript">
	function getJstackInfo(threadName){
		var url = "poolOperation.jsp?operation=getJstackInfo&threadName="+threadName;
		if(window.JqueryDialog && window.JqueryDialog.Open1){
			JqueryDialog.Open1("JstackInfo " + threadName,url,650,420,false,false,true);
		} else {
			window.open(url);
		}
	}
	
	function killThread(threadName){
		if(confirm("kill thread " + threadName + "(all connections this thread hold will be released) ?")){
			var url = "poolOperation.jsp?operation=killThread&threadName="+threadName;
			if(window.JqueryDialog && window.JqueryDialog.Open1){
				JqueryDialog.Open1("KillThread " + threadName,url,650,420,false,false,true);
			} else {
				window.open(url);
			}
		}
	}
	
	function release(alias, connId, isActive){
		var flag = isActive ? confirm("connection "+connId+" is active, still release ?") : true;
		if(flag){
			var url = "poolOperation.jsp?operation=release&alias="+alias+"&force=1&connId="+connId;
			if(window.JqueryDialog && window.JqueryDialog.Open1){
				JqueryDialog.Open1("Release connection " + connId,url,650,420,false,false,true);
			} else {
				window.open(url);
			}
		}
	}
	
	function releaseAllActiveConnOfDummyThread(alias, activeTime){
		var cleanActiveTime = document.getElementById("cleanActiveTime").value;
		if(isNaN(cleanActiveTime) || cleanActiveTime<=0){
			alert("activeTime must greater than 0s");
			return;
		}
		cleanActiveTime = cleanActiveTime*1000; //s->ms
		if(confirm("releaseAllActiveConnOfDummyThread, active time > "+cleanActiveTime+"ms ?")){
			var url = "poolOperation.jsp?operation=releaseAllActiveConnOfDummyThread&alias="+alias+"&activeTime="+cleanActiveTime;
			if(window.JqueryDialog && window.JqueryDialog.Open1){
				JqueryDialog.Open1("ReleaseAllActiveConnOfDummyThread ",url,650,420,false,false,true);
			} else {
				window.open(url);
			}
		}
	}
	
	function releaseAllActiveConn(alias){
		var cleanActiveTime = document.getElementById("cleanActiveTime").value;
		if(isNaN(cleanActiveTime) || cleanActiveTime<=0){
			alert("activeTime must greater than 0s");
			return;
		}
		cleanActiveTime = cleanActiveTime*1000; //s->ms
		if(confirm("releaseAllActiveConn, active time > "+cleanActiveTime+"ms ?")){
			var url = "poolOperation.jsp?operation=releaseAllActiveConn&alias="+alias+"&activeTime="+cleanActiveTime;
			if(window.JqueryDialog && window.JqueryDialog.Open1){
				JqueryDialog.Open1("ReleaseAllActiveConn ",url,650,420,false,false,true);
			} else {
				window.open(url);
			}
		}
	}
	
	function startAutoClean(alias){
		var autoCleanActiveTime = document.getElementById("autoCleanActiveTime").value;
		if(isNaN(autoCleanActiveTime) || autoCleanActiveTime<=0){
			alert("autoCleanActiveTime must greater than 0 min");
			return;
		}
		autoCleanActiveTime = autoCleanActiveTime * 60 * 1000; //min->ms
		var url = "poolOperation.jsp?operation=startAutoClean&alias="+alias+"&autoCleanActiveTime="+autoCleanActiveTime;
		if(window.JqueryDialog && window.JqueryDialog.Open1){
			JqueryDialog.Open1("startAutoClean",url,650,420,false,false,true);
		} else {
			window.open(url);
		}
	}
	
	function stopAutoClean(alias){
		var url = "poolOperation.jsp?operation=stopAutoClean&alias="+alias;
		if(window.JqueryDialog && window.JqueryDialog.Open1){
			JqueryDialog.Open1("stopAutoClean",url,650,420,false,false,true);
		} else {
			window.open(url);
		}
	}
	
	function openTrace(alias){
		var url = "poolOperation.jsp?operation=openTrace&dataType=json&alias="+alias;
		if(window.$){
			$.ajax({
				url: url,
				cache: false,
				dataType: 'json', 
				success : function(data){
					alert(data && data.res);
					window.location.reload(true);
				},
				error : function(data){
					alert('openTrace error!');
				}
			});
		} else {
			window.open(url);
		}
	}
	
	function closeTrace(alias){
		var url = "poolOperation.jsp?operation=closeTrace&dataType=json&alias="+alias;
		if(window.$){
			$.ajax({
				url: url,
				cache: false,
				dataType: 'json',
				success : function(data){
					alert(data && data.res);
					window.location.reload(true);
				},
				error : function(data){
					alert('closeTrace error!');
				}
			});
		} else {
			window.open(url);
		}
	}
	
</script>

<%
if (output.equals(OUTPUT_FULL)) {
    closeHtml(response.getOutputStream());
}
%>

</BODY>
</HTML>