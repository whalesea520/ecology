<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="java.util.HashMap"%>
<%@page import="weaver.general.TimeUtil"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>

<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<%

User user = HrmUserVarify.getUser(request, response);

if(user == null){
	out.print("{}");
}else{
	int userid=user.getUID();
	String CurrentDate=TimeUtil.getCurrentDateString();
	String CurrentTime=TimeUtil.getOnlyCurrentTimeString();
	
	String src=Util.null2String(request.getParameter("src"));
	String type=Util.null2String(request.getParameter("type"));
	String sortid=Util.null2String(request.getParameter("sortid"));
	JSONObject jsonObject=new JSONObject();
	
	
	if("getnum".equalsIgnoreCase(src)){//取未读数量
		String sql=""+
				" select count(t1.id) from Exchange_Info t1 "+
				" where t1.sortid='"+sortid+"' and t1.type_n='"+type.toUpperCase()+"' and t1.creater!='"+userid+"' and not exists "+
				" (select 1 from Prj_XchgInfo_ViewLog t2 where t2.xchg_id=t1.id and t2.viewer_id='"+userid+"' ) ";
		int count=0;
		rs.executeSql(sql);
		rs.next();
		count=Util.getIntValue( rs.getString(1),0);
		
		jsonObject.put("count", count);
		
	}else if("updatenum".equalsIgnoreCase(src)){//更新为已读
		String sql=""+
				" select t1.id from Exchange_Info t1 "+
				" where t1.sortid='"+sortid+"' and t1.type_n='"+type.toUpperCase()+"' and t1.creater!='"+userid+"' and not exists "+
				" (select 1 from Prj_XchgInfo_ViewLog t2 where t2.xchg_id=t1.id and t2.viewer_id='"+userid+"' ) ";
		String sql2=" insert into Prj_XchgInfo_ViewLog(xchg_id,sortid,type_n,viewer_id,view_date,view_time)"+
				" values(?,'"+sortid+"','"+type+"','"+userid+"','"+CurrentDate+"','"+CurrentTime+"') ";
		rs.executeSql(sql);
		while(rs.next()){
			String xchg_id=rs.getString("id");
			rs2.executeSql(sql2.replace("?", xchg_id));
		}
		
		jsonObject.put("count", 0);
	}
	
	
	out.print(jsonObject.toString());
	
}

%>
