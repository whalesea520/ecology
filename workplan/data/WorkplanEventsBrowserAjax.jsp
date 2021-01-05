
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.*,weaver.file.Prop" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@page import="weaver.WorkPlan.WorkPlanShareUtil"%>
<%@page import="weaver.conn.RecordSet"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%!
private String getShareSql(User user){
	int userId=user.getUID();
	int deptid=user.getUserDepartment();
	int compid=user.getUserSubCompany1();
	int security=Util.getIntValue(user.getSeclevel());
	String userType=user.getLogintype();
	String sql="SELECT workId from WorkPlanShareDetail where "+
	 "   (objId = "+userId+" and usertype = "+userType+" and shareType = 1 and securityLevel = 0 and securityLevelMax = 0) "+
	 "or (objId = "+userId+" and usertype = "+userType+" and shareType = 6 and securityLevel = 0 and securityLevelMax = 0) "+
	 "or (objId = "+userId+" and usertype = "+userType+" and shareType = 7 and securityLevel = 0 and securityLevelMax = 0) "+
	 "or (objId = "+compid+" and usertype="+userType+" and shareType=2 and  securityLevel<="+security+" and  securityLevelMax>="+security+") "+
	 "or (objId = "+deptid+" and usertype="+userType+" and shareType=3 and  securityLevel<="+security+" and  securityLevelMax>="+security+") ";
	
	RecordSet rs = new RecordSet();
	rs.execute("SELECT * from hrmRoleMembers where resourceid="+userId);
	while(rs.next()){
		int roleid=Util.getIntValue(rs.getString("roleid"),-1);
		int roleLeve=Util.getIntValue(rs.getString("rolelevel"),0);
		if(roleid>0){
			sql+="or (objId = "+roleid+" and usertype="+userType+" and shareType=4 and  securityLevel<="+security+" and  securityLevelMax>="+security+" and "+roleLeve+">=rolelevel ) ";
		}
		
	}
	return sql;
}
%>
<%
User user = HrmUserVarify.getUser (request , response) ;
String src = Util.null2String(request.getParameter("src"));
String systemIds = Util.null2String(request.getParameter("systemIds"));
if(systemIds.trim().startsWith(",")){
	systemIds = systemIds.substring(1);
}
int perpage = Util.getIntValue(request.getParameter("pageSize"),10) ;
int pagenum = Util.getIntValue(request.getParameter("currentPage") , 1) ;
String sqlWhere = " where 1=1 ";
JSONObject json = new JSONObject();
if(src.equalsIgnoreCase("dest")){//右侧已选择列表的sql条件
	if (!systemIds.equals("")) {
		sqlWhere += " and id in ("+systemIds+")";
		
		SplitPageParaBean spp = new SplitPageParaBean();
	
		spp.setBackFields("workPlan.ID, workPlan.name,workPlan.resourceID, workPlan.urgentLevel, workPlan.type_n, workPlan.createrID, workPlan.status, workPlan.beginDate, workPlan.beginTime, workPlan.endDate, workPlan.createDate, workPlan.createTime");
		spp.setSqlFrom(" workPlan ");
		spp.setSqlWhere(sqlWhere);
		spp.setSqlOrderBy("workPlan.beginDate, workPlan.beginTime");
		spp.setPrimaryKey("id");
		spp.setDistinct(false);
		spp.setSortWay(spp.ASC);
		SplitPageUtil spu = new SplitPageUtil();
		spu.setSpp(spp);
	
		String id=null;
		
		rs = spu.getAllRs();
	
		JSONArray jsonArr = new JSONArray();
		while(rs.next()) {
			id = rs.getString("id");

			JSONObject tmp = new JSONObject();
			tmp.put("id",id);
			tmp.put("name",rs.getString("name"));
			tmp.put("createrid",ResourceComInfo.getLastname(rs.getString("createrid")));
			tmp.put("begindate",rs.getString("begindate"));
			tmp.put("enddate",rs.getString("begindate"));
			jsonArr.add(tmp);
		}
		json.put("currentPage", 1);
		json.put("totalPage", 1);
		json.put("mapList",jsonArr.toString());
		out.println(json.toString());
		return;
		
	} else {
		json.put("currentPage", 1);
		json.put("totalPage", 1);
		json.put("mapList","");
		out.println(json.toString());
		return;
	}
}else{//左侧待选择列表的sql条件
		String shareSql=getShareSql(user);
		String planName = Util.null2String(request.getParameter("planname"));  //日程名
		String urgentLevel = Util.null2String(request.getParameter("urgentlevel"));  //紧急程度
		String planType = Util.null2String(request.getParameter("plantype"));  //日程类型
		String planStatus = Util.null2String(request.getParameter("planstatus"));  //状态  0：代办；1：完成；2、归档
		String createrId = Util.null2String(request.getParameter("createrid"));  //提交人
		String receiveID = Util.null2String(request.getParameter("receiveID"));  //接收ID
		int timeSag = Util.getIntValue(request.getParameter("timeSag"),0);
		int timeSagEnd = Util.getIntValue(request.getParameter("timeSagEnd"),0);
		String beginDate = Util.null2String(request.getParameter("begindate"));  //开始日期
		String endDate = Util.null2String(request.getParameter("enddate"));  //结束日期
		String beginDate2 = Util.null2String(request.getParameter("begindate2"));  //开始日期
		String endDate2 = Util.null2String(request.getParameter("enddate2"));  //结束日期   

		sqlWhere ="WHERE workPlan.ID = workPlanShareDetail.workID";
		if(!systemIds.equals("")){
			sqlWhere += " and  workPlan.ID not in ("+systemIds+") " ;
		}
		if(!"".equals(planName) && null != planName)
		{
			planName=planName.replaceAll("\"","＂");
			planName=planName.replaceAll("'","＇");
			sqlWhere += " AND workPlan.name LIKE '%" + planName + "%'";
		}
		if(!"".equals(urgentLevel) && null != urgentLevel)
		{	
			if("1".equals(urgentLevel)){
				sqlWhere += " AND (workPlan.urgentLevel = '1' or workPlan.urgentLevel='')";
			}else{
				sqlWhere += " AND workPlan.urgentLevel = '" + urgentLevel + "'";
			}
		}
		if(!"".equals(planType) && null != planType)
		{
			sqlWhere += " AND workPlan.type_n = '" + planType + "'";
		}
		if(!"".equals(planStatus) && null != planStatus)
		{
			sqlWhere += " AND workPlan.status = '" + planStatus + "'";
		}
		if(!"".equals(createrId) && null != createrId)
		{
			sqlWhere += " AND workPlan.createrid = " + createrId;
		}
		
		//日程类型 1：人力资源 
		if(!"".equals(receiveID) && null != receiveID)
		{
			//人力资源
			if (rs.getDBType().equals("oracle")) {
				sqlWhere+=" and ( ','||workPlan.resourceID||',' LIKE '%,"+ receiveID + ",%') " ;
			} else {
				sqlWhere+=" and ( ','+workPlan.resourceID+',' LIKE '%,"	+ receiveID + ",%') ";
			}							
		}
		
		if(timeSag > 0&&timeSag<6){
			String doclastmoddatefrom = TimeUtil.getDateByOption(""+timeSag,"0");
			String doclastmoddateto = TimeUtil.getDateByOption(""+timeSag,"1");
			if(!doclastmoddatefrom.equals("")){
				sqlWhere += " and workPlan.beginDate >= '" + doclastmoddatefrom + "'";
			}
			
			if(!doclastmoddateto.equals("")){
				sqlWhere += " and workPlan.beginDate <= '" + doclastmoddateto + "'";
			}
			
		}else{
			if(timeSag==6){//指定时间
				if((!"".equals(beginDate) && null != beginDate))
				{
					sqlWhere += " AND workPlan.beginDate >= '" + beginDate+ "'";								    
				   // sqlWhere += "' OR workPlan.endDate IS NULL)";
				}
				if((!"".equals(endDate) && null != endDate))
				{
					sqlWhere += " AND workPlan.beginDate <= '" + endDate + "'";
				}
			}
			
		}
		
		if(timeSagEnd > 0&&timeSagEnd<6){
			String doclastmoddatefrom = TimeUtil.getDateByOption(""+timeSagEnd,"0");
			String doclastmoddateto = TimeUtil.getDateByOption(""+timeSagEnd,"1");
			if(!doclastmoddatefrom.equals("")){
				sqlWhere += " and workPlan.endDate >= '" + doclastmoddatefrom + "'";
			}
			
			if(!doclastmoddateto.equals("")){
				sqlWhere += " and workPlan.endDate <= '" + doclastmoddateto + "'";
			}
			
		}else{
			if(timeSagEnd==6){//指定时间
				if((!"".equals(beginDate2) && null != beginDate2))
				{
					sqlWhere += " AND workPlan.endDate >= '" + beginDate2+ "'";								    
				   // sqlWhere += "' OR workPlan.endDate IS NULL)";
				}
				if((!"".equals(endDate2) && null != endDate2))
				{
					sqlWhere += " AND workPlan.endDate <= '" + endDate2+ "'";								    
				   // sqlWhere += "' OR workPlan.endDate IS NULL)";
				}
			}
			
		}
		 
 
	 
	//System.out.println("sqlWhere:"+sqlWhere);
	SplitPageParaBean spp = new SplitPageParaBean();
	
	spp.setBackFields("workPlan.ID, workPlan.name,workPlan.resourceID, workPlan.urgentLevel, workPlan.type_n, workPlan.createrID, workPlan.status, workPlan.beginDate, workPlan.beginTime, workPlan.endDate, workPlan.createDate, workPlan.createTime");
	spp.setSqlFrom(" WorkPlan workPlan, ("+shareSql+") workPlanShareDetail ");
	spp.setSqlWhere(sqlWhere);
	spp.setSqlOrderBy("workPlan.beginDate, workPlan.beginTime");
	spp.setPrimaryKey("id");
	spp.setDistinct(true);
	spp.setSortWay(spp.DESC);
	SplitPageUtil spu = new SplitPageUtil();
	spu.setSpp(spp);

	int RecordSetCounts = spu.getRecordCount();
	int totalPage = RecordSetCounts/perpage;
	if(totalPage%perpage>0||totalPage==0){
		totalPage++;
	}

	String id=null;
	
	rs = spu.getCurrentPageRs(pagenum, perpage);

	JSONArray jsonArr = new JSONArray();
	while(rs.next()) {
		id = rs.getString("id");
		 

		JSONObject tmp = new JSONObject();
		tmp.put("id",id);
		tmp.put("name",rs.getString("name"));
		tmp.put("createrid",ResourceComInfo.getLastname(rs.getString("createrid")));
		tmp.put("begindate",rs.getString("begindate"));
		tmp.put("enddate",rs.getString("begindate"));
		jsonArr.add(tmp);
	}
	json.put("currentPage", pagenum);
	json.put("totalPage", totalPage);
	json.put("mapList",jsonArr.toString());
	out.println(json.toString());
	//System.out.println(json.toString());
	}
%>
				