<%@ page language="java" pageEncoding="utf-8"%>

<%@ page import="weaver.hrm.User,weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@page import="weaver.general.TimeUtil"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<jsp:useBean id="ps" class="weaver.mobile.plugin.ecology.service.PluginServiceImpl" scope="page" />
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="net.sf.json.JSONObject"%>

<%
	String sessionkey = request.getParameter("sessionkey");
	User user = HrmUserVarify.getUser(request,response);
	if(user == null){
	   Map result = ps.getCurrUser(sessionkey);
	   user = new User();
	   user.setUid(Util.getIntValue(result.get("id").toString()));
	   user.setLastname(result.get("name").toString());
	}
	RecordSet rs = new RecordSet();
	
	int type = Util.getIntValue(request.getParameter("type"));
	String method = request.getParameter("method");
	
	if("add".equals(method)){ 
	    JSONObject json = new JSONObject();
	    String searchdate=TimeUtil.getCurrentDateString();
        String searchtime=TimeUtil.getOnlyCurrentTimeString();
        String searchtext = Util.null2String(request.getParameter("searchtext"));
        String checksql = "select id from HistorySearch where userid = '"+user.getUID()+"' and searchtext = '"+searchtext+"' and searchtype=" + type ;
        rs.executeSql(checksql);
        String sql = "";
        if(rs.next())
        {
            sql = "update HistorySearch set searchdate='"+searchdate+"',searchtime='"+searchtime+"' where userid = '"+user.getUID()+"' and searchtext = '"+searchtext+"' and searchtype=" + type ;
            
        }
        else
        {
            sql = "insert into HistorySearch(userid,searchtext,searchdate,searchtime,searchtype) " + 
            "values('"+user.getUID()+"','"+searchtext+"','"+searchdate+"','"+searchtime+"',"+type+")";
        }
        rs.executeSql(sql);
        json.put("flag","1");
        out.println(json);
	}else if("getHistorySearch".equals(method)){
	    String sql = "";
	    if(rs.getDBType().equals("oracle")){
	        sql = "select * from (select searchtext from HistorySearch where userid = '"+user.getUID()+"' and searchtype=" + type +" order by searchdate desc,searchtime desc) where rownum <= 10";
	    }
	    else
	    {
	        sql = "select top 10 searchtext from HistorySearch where userid = '"+user.getUID()+"' and searchtype=" + type +" order by searchdate desc,searchtime desc";
	    }
        rs.executeSql(sql);
        List<String> result = new ArrayList<String>();
        while(rs.next())
        {
            result.add(rs.getString("searchtext"));
        }
        out.println(JSONArray.fromObject(result).toString());
	}else if("clearHistory".equals(method)){
	    JSONObject json = new JSONObject();
	    String sql = "delete from HistorySearch where userid = '"+user.getUID()+"' and searchtype=" + type ;
        rs.executeSql(sql);
        json.put("flag","1");
        out.println(json);
	}
%>
