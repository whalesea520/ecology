<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.alibaba.fastjson.JSONArray"%>
<%@page import="com.alibaba.fastjson.JSONObject"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="fileHandle" class="weaver.contractn.util.FileHandle"
	scope="page" />

<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%
	User usr = HrmUserVarify.getUser(request, response);
	int usrId = usr.getUID();
	Map<String, String> map = fileHandle.uploadFile(request);
	//System.out.println(map.toString());
	String mainid = map.get("mainid");
	String risk_type = map.get("risk_type");
	String possible = map.get("possible");
	String rlevel = map.get("rlevel");
	String start_date = map.get("start_date");
	String end_date = map.get("end_date");
	String control = map.get("riskControl");
	String person = map.get("person");
	String mark = Util.null2String(map.get("mark"));

	String create_date = new SimpleDateFormat("yyyy-MM-dd")
			.format(new Date());
	String create_time = new SimpleDateFormat("HH:mm:ss")
			.format(new Date());

	String sql = "insert into uf_uf_T_CONS_PRO_IN_dt1(mainid,risk_type,possible,rlevel,start_date,end_date,person,control,progress,mark,create_usr,create_date,create_time) values("
			+ mainid
			+","
			+ risk_type
			+ ","
			+ possible
			+ ","
			+ rlevel
			+ ",'"
			+ start_date
			+ "',"
			+ "'"
			+ end_date
			+ "',"
			+ person
			+ ","
			+ control
			+ ","
			+ '1'
			+ ",'"
			+ mark
			+ "',"
			+ usrId
			+ ",'"
			+ create_date + "'," + "'" + create_time + "')";
	String message = "";
    boolean flag=rs.executeSql(sql);    
    if(flag){
        message = "保存成功！";
    }else{
        message = "保存失败！";
    }
    out.println(message);
%>

