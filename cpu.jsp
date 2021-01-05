<%@ page import="java.lang.management.*,java.util.*"%>
<%@ page import="weaver.filter.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%
    java.text.DecimalFormat df = new java.text.DecimalFormat("##.#");
	Map<String, Object> resp = MonitorXFilter.getFilterData("getALLCPUValues");
	List<Map<String, Object>> data = resp == null ? new ArrayList<Map<String, Object>>() : (List<Map<String, Object>>) resp.get("result");
    //List<CPUDataVO> data = MonitorXFilter.getFilterData("getALLCPUValues");
    String action = request.getParameter("action");
    if ("timePer".equals(action)) {
        Collections.sort(data, new Comparator<Map<String, Object>>() {
			public int compare(Map<String, Object> o1,
					Map<String, Object> o2) {
				long d1 = (Long)o1.get("timeSum") / (Long)o1.get("count");
				long d2 = (Long)o2.get("timeSum") / (Long)o2.get("count");
				if (d1 > d2) {
                    return -1;
                } else if (d1 < d2) {
                    return 1;
                } else {
                    return 0;
                }
			}
		});
    } else if ("clear".equals(action)) {
		application.setAttribute("__cpu_lastcleartime", new java.text.SimpleDateFormat("yyyy'-'MM'-'dd' 'HH:mm:ss").format(new java.util.Date())); 
        MonitorXFilter.setFilterData("clearAllCPU", null);
		%>
		<script>location.href = "cpu.jsp";</script>
		<%
    } else if ("count".equals(action)) {
        Collections.sort(data, new Comparator<Map<String, Object>>() {
            public int compare(Map<String, Object> o1,
					Map<String, Object> o2) {
            	long o1Count = (Long)o1.get("count");
            	long o2Count = (Long)o2.get("count");
                if (o1Count > o2Count) {
                    return -1;
                } else if (o1Count < o2Count) {
                    return 1;
                } else {
                    return 0;
                }
            }
        });
    } else {
        Collections.sort(data, new Comparator<Map<String, Object>>() {
            public int compare(Map<String, Object> o1,
					Map<String, Object> o2) {
            	float o1SumRatio = (Float)o1.get("sumRatio");
            	float o2SumRatio = (Float)o2.get("sumRatio");
                if (o1SumRatio > o2SumRatio) {
                    return -1;
                } else if (o1SumRatio < o2SumRatio) {
                    return 1;
                } else {
                    return 0;
                }
            }
        });
    }
    

    long sum = 0;
	long sumCount = 0;
	int dataLength = data.size();
    for (int i = 0; i < dataLength; i++) {
		sum += ((Long)data.get(i).get("timeSum") + (Long)data.get(i).get("excuteTime"));
		sumCount += (Long)data.get(i).get("count");
	}

    long avgTime = (sumCount == 0 ? 0 : sum/sumCount);
	long avgCount = (dataLength == 0 ? 0 : sumCount/dataLength);
	
%>
<a href="urltime.jsp">browse urltime.jsp</a>
&nbsp;
<a href="cpu.jsp?action=clear" title="clear all expire data(not include running threads)">Clear</a>
&nbsp;
<a href="cpu.jsp?action=timeSum">TimeRatio Sort</a>
&nbsp;
<a href="cpu.jsp?action=count">Count Sort</a>
&nbsp;
<a href="cpu.jsp?action=timePer">TimePer Sort</a>
&nbsp;
<span title="every url count average">AVG COUNT = <%=avgCount%></span>
&nbsp;
<span title="every request cpu average">AVG CPU = <%=avgTime%>ms</span>
&nbsp;
<span>LAST CLEAR = <%=application.getAttribute("__cpu_lastcleartime")%></span>
<table border=1>
    <tr>
        <th>url</th>
        <th>time sum(ms)</th>
		<th>time ratio</th>
        <th>count</th>
        <th>time per(ms)</th>
		<th>excuting..</th>
    </tr>
    <%
        for (int i = 0; i < data.size() && i < 200; i++) {
    %>
    <tr>
        <td><%=data.get(i).get("key")%></td>
        <td><%=data.get(i).get("timeSum")%></td>
		<td><%=df.format(data.get(i).get("sumRatio"))%>%</td>
        <td><%=data.get(i).get("count")%></td>
        <td><%=(Long)data.get(i).get("timeSum") / (Long)data.get(i).get("count")%></td>
		<td><%=data.get(i).get("excuteTime")%></td>
    </tr>
    <%
        }
    %>
</table>