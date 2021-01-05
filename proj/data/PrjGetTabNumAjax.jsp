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
	
	String type=Util.null2String(request.getParameter("type"));
	String src=Util.null2String(request.getParameter("src"));
	int statusid=Util.getIntValue (request.getParameter("statusid"),-1);
	String sqlwhere=Util.null2String(request.getParameter("sqlwhere"));
	String sqlwhere2=Util.null2String(request.getParameter("sqlwhere2"));
	JSONObject jsonObject=new JSONObject();
	
	String sql="";
	String sql1="";
	String sql2="";
	String sql3="";
	String sql4="";
	int totalCount1=0;
	int totalCount2=0;
	int totalCount3=0;
	int totalCount4=0;
	if("taskexec".equalsIgnoreCase(type)){//任务执行
		sql="select count(t1.id) as totalcount from Prj_TaskProcess t1,Prj_ProjectInfo t2 ";
		
		sql1=sql+sqlwhere2;
		sql2=sql+sqlwhere2+" and t1.begindate>'"+CurrentDate+"' ";
		sql3=sql+sqlwhere2+" and t1.begindate<='"+CurrentDate+"' and t1.enddate>='"+CurrentDate+"' ";
		sql4=sql+sqlwhere2+" and t1.enddate<'"+CurrentDate+"' ";
		
		if("todo".equalsIgnoreCase(src)){
			sql2=sql+sqlwhere;
		}else if("doing".equalsIgnoreCase(src)){
			sql3=sql+sqlwhere;
		}else if("overtime".equalsIgnoreCase(src)){
			sql4=sql+sqlwhere;
		}else{
			sql1=sql+sqlwhere;
		}
	}else if("prjexec".equalsIgnoreCase(type)){//项目执行
		sql="select count(t1.id) as totalcount from Prj_ProjectInfo t1 ";
		
		sql1=sql+sqlwhere2;
		
		sql2=sql+sqlwhere2+" and t1.status='5' ";
		sql3=sql+sqlwhere2+" and t1.status='1' ";
		sql4=sql+sqlwhere2+" and t1.status='2' ";
		
		
		if("todo".equalsIgnoreCase(src)){
			sql2=sql+sqlwhere;
		}else if("doing".equalsIgnoreCase(src)){
			sql3=sql+sqlwhere;
		}else if("overtime".equalsIgnoreCase(src)){
			sql4=sql+sqlwhere;
		}else if("".equalsIgnoreCase(src) ){
			sql1=sql+sqlwhere2;
		}
		
		//System.out.println("sql1:========="+sql1);
	}else if("myprj".equalsIgnoreCase(type)){//我的项目
		sql="select count(t1.id) as totalcount from Prj_ProjectInfo t1 ";
		
		sql1=sql+sqlwhere2;
		sql2=sql+sqlwhere2+" and t1.status not in(0,3,4,6,7) ";
		sql3=sql+sqlwhere2+" and t1.status='4' ";
		sql4=sql+sqlwhere2+" and t1.status='3' ";
		
		
		if("all".equalsIgnoreCase(src)){
			sql1=sql+sqlwhere;
		}else if("frozen".equalsIgnoreCase(src)){
			sql3=sql+sqlwhere;
		}else if("complete".equalsIgnoreCase(src)){
			sql4=sql+sqlwhere;
		}else{
			sql2=sql+sqlwhere;
		}
		
	}
	
	rs.executeSql(sql1);
	rs.next();
	totalCount1= rs.getInt(1);
	rs.executeSql(sql2);
	rs.next();
	totalCount2= rs.getInt(1);
	rs.executeSql(sql3);
	rs.next();
	totalCount3= rs.getInt(1);
	rs.executeSql(sql4);
	rs.next();
	totalCount4= rs.getInt(1);
	
	if(totalCount1<0) totalCount1=0;
	if(totalCount2<0) totalCount2=0;
	if(totalCount3<0) totalCount3=0;
	if(totalCount4<0) totalCount4=0;
	
	jsonObject.put("totalCount1", totalCount1);
	jsonObject.put("totalCount2", totalCount2);
	jsonObject.put("totalCount3", totalCount3);
	jsonObject.put("totalCount4", totalCount4);
	
	if("prjexec".equalsIgnoreCase(type)){//自定义状态
		String sql11="select t1.status,count(t1.id) as totalcount from prj_projectinfo t1 where exists (select 1 from prj_projectstatus t2 "+sqlwhere+" and t2.id=t1.status and ( t2.issystem is null or t2.issystem !='1' ) ) group by t1.status ";
		rs.executeSql(sql11);
		JSONArray arr=new JSONArray();
		while(rs.next()){
			JSONObject obj=new JSONObject();
			obj.put("status", rs.getString("status"));
			obj.put("totalcount", ""+Util.getIntValue( rs.getString("totalcount"),0));
			arr.add(obj);
		}
		jsonObject.put("cusStatusNum",arr);
		
	}
	
	
	out.print(jsonObject.toString());
	
}

%>
