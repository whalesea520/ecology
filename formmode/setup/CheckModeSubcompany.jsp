<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.general.Util" %>
<%@ page import="net.sf.json.*" %>
<%@ page import="java.util.*" %>
<%
    String  type = Util.null2String(request.getParameter("flag"));
    String  subcompany = Util.null2String(request.getParameter("subcompany"));
    
    String sql = "";
    if(type.equals("total")){
    	JSONArray options = new JSONArray();
    	String appTotal = "";
    	String modeTotal = "";
    	sql = "select count(1) as num from modeTreeField where subcompanyid IS NULL or subcompanyid =-1 or subcompanyid = ''";
    	rs.executeSql(sql);
    	if(rs.next()){
    		appTotal = rs.getString(1);
    		JSONObject option = new JSONObject();
    		option.accumulate("app",appTotal);
    		options.add(option);
    	}
    	sql = "select count(1) as num from modeinfo where subcompanyid IS NULL or subcompanyid =-1 or subcompanyid = ''";
    	rs.executeSql(sql);
    	if(rs.next()){
    		modeTotal = rs.getString(1);
    		JSONObject option = new JSONObject();
    		option.accumulate("mode",modeTotal);
    		options.add(option);
    	}
    	out.print(options.toString());
    }else{
    	sql = "update modeTreeField set subcompanyid="+subcompany+" where subcompanyid IS NULL or subcompanyid =-1 or subcompanyid = ''";
    	rs.executeSql(sql);
    	sql = "update modeinfo set subcompanyid="+subcompany+" where subcompanyid IS NULL or subcompanyid =-1 or subcompanyid = ''";
    	rs.executeSql(sql);
    	sql = "update workflow_bill set subcompanyid3="+subcompany+" where subcompanyid3 IS NULL or subcompanyid3 =-1 or subcompanyid3 = ''";
    	rs.executeSql(sql);
    }
    
%>