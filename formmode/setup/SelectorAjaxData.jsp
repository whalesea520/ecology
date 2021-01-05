<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.general.Util" %>
<%@ page import="net.sf.json.*" %>
<%@ page import="java.util.*" %>
<%
	String fieldid = Util.null2String(request.getParameter("fieldid"));
	String sql = "select selectvalue,selectname from workflow_SelectItem where fieldid= " + fieldid + " and cancel <> '1'";
	rs.executeSql(sql);
	JSONArray options = new JSONArray();
	while(rs.next()) {
		JSONObject option = new JSONObject();
		option.put("selectvalue", Util.null2String(rs.getString("selectvalue")));
		option.put("selectname", Util.null2String(rs.getString("selectname")));
		options.add(option);
	}
	JSONObject result = new JSONObject();
	response.setCharacterEncoding("UTF-8");
	result.put("result", options.toString());
	out.print(result.toString());
%>