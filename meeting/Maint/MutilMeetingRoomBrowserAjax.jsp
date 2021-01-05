<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@page import="weaver.meeting.MeetingShareUtil"%>
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
String src = Util.null2String(request.getParameter("src"));
String subcompany = Util.null2String(request.getParameter("subcompany"));
String name = Util.null2String(request.getParameter("name"));
String mrtype = Util.null2String(request.getParameter("mrtype"));
int forall = Util.getIntValue(request.getParameter("forall"), 0);
String desc = Util.null2String(request.getParameter("desc"));
String equipment = Util.null2String(request.getParameter("equipment"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String check_per = Util.null2String(request.getParameter("systemIds"));
	if(check_per.equals(",")){
		check_per = "";
	}
	if(check_per.equals("")){
		check_per = Util.null2String(request.getParameter("selectids"));
	}
	if(check_per.equals("")){
		check_per = Util.null2String(request.getParameter("systemIds"));
	}
if(!check_per.equals("")){
	if(check_per.substring(0,1).equals(","))check_per = check_per.substring(1);
	if(check_per.substring(check_per.length()-1).equals(","))check_per = check_per.substring(0,check_per.length()-1);
}
int perpage = Util.getIntValue(request.getParameter("pageSize"),10) ;
int pagenum = Util.getIntValue(request.getParameter("currentPage") , 1) ;
JSONArray jsonArr = new JSONArray();
JSONObject json = new JSONObject();
String id=null;
if(src.equalsIgnoreCase("dest")){//右侧已选择列表的sql条件

	try{
		if(check_per.length()>0){
			String[] ids = check_per.split(",");
			for(String tmpid : ids){
				rs.execute("select * from meetingroom where id="+tmpid);
				rs.next();
				String subname=SubCompanyComInfo.getSubCompanyname(rs.getString("subcompanyid"));
				JSONObject tmp = new JSONObject();
				tmp.put("id",tmpid);
				tmp.put("name",MeetingRoomComInfo.getMeetingRoomInfoname(tmpid));
				tmp.put("sub",subname);
				tmp.put("desc",MeetingRoomComInfo.getMeetingRoomInfodesc(tmpid));
				//tmp.put("dev",MeetingRoomComInfo.getMeetingRoomInfoequipment(tmpid));
				jsonArr.add(tmp);
			}
		}
	}catch(Exception e){}
	json.put("currentPage", 1);
	json.put("totalPage", 1);
	json.put("mapList",jsonArr.toString());
	out.println(json.toString());
	return;
}else{//左侧待选择列表的sql条件
	//构建where语句
	sqlwhere = "";

	sqlwhere += " 1=1";
	if (!"".equals(name)) {
		sqlwhere += " and name like '%" + name + "%'";
	}
	if (!"".equals(desc)) {
		sqlwhere += " and roomdesc like '%" + desc + "%'";
	}
	if (!"".equals(subcompany)) {
		sqlwhere += " and subcompanyid = '" + subcompany + "'";
	}
	if (!"".equals(equipment)) {
		sqlwhere += " and equipment like '%" + equipment + "%'";
	}
	if(!"".equals(mrtype)){
		sqlwhere += " and mrtype ='" + mrtype + "'";
	}
	if (forall != 1) {
		sqlwhere += MeetingShareUtil.getRoomShareSql(user);
		sqlwhere += " and (a.status=1 or a.status is null )";
	}
	//屏蔽已选人员
	String excludeId = Util.null2String(request.getParameter("excludeId"));
	if(excludeId.length()==0)excludeId=check_per;
	if(excludeId.length()>0){
		sqlwhere += " and a.id not in ("+excludeId+")";
	}

	SplitPageParaBean spp = new SplitPageParaBean();
	spp.setBackFields(" a.id,a.name,a.subcompanyid,a.roomdesc,a.images,a.dsporder,a.equipment ");
	spp.setSqlFrom("meetingroom a");
	spp.setSqlWhere(sqlwhere);
	spp.setSqlOrderBy("a.dsporder,a.name");
	spp.setPrimaryKey("a.id");
	spp.setDistinct(true);
	spp.setSortWay(spp.ASC);
	SplitPageUtil spu = new SplitPageUtil();
	spu.setSpp(spp);
	int RecordSetCounts = spu.getRecordCount();
	int totalPage = RecordSetCounts/perpage;
	if(totalPage%perpage>0||totalPage==0){
		totalPage++;
	}

	rs = spu.getCurrentPageRs(pagenum, perpage);

	while(rs.next()) {
		id = rs.getString("id");
		String subname=SubCompanyComInfo.getSubCompanyname(rs.getString("subcompanyid"));
		JSONObject tmp = new JSONObject();
		tmp.put("id",id);
		tmp.put("name",rs.getString("name"));
		tmp.put("sub",subname);
		tmp.put("desc",rs.getString("roomdesc"));
		//tmp.put("dev",rs.getString("equipment"));
		jsonArr.add(tmp);
	}
	json.put("currentPage", pagenum);
	json.put("totalPage", totalPage);
	json.put("mapList",jsonArr.toString());
	out.println(json.toString());
}
%>
				