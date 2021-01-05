<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id="JobGroupsComInfo" class="weaver.hrm.job.JobGroupsComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
String src = Util.null2String(request.getParameter("src"));
String jobgroupid = Util.null2String(request.getParameter("jobgroupid"));
String jobactivitieid = Util.null2String(request.getParameter("jobactivitieid"));
String jobtitlemark = Util.null2String(request.getParameter("jobtitlemark"));
String jobtitlename = Util.null2String(request.getParameter("jobtitlename"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String check_per = Util.null2String(request.getParameter("jobtitles"));
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
				JSONObject tmp = new JSONObject();
				tmp.put("id",tmpid);
				tmp.put("jobtitlename",JobTitlesComInfo.getJobTitlesname(tmpid));
				String tmpjobactivityid= JobTitlesComInfo.getJobactivityid(tmpid);
				tmp.put("jobactivitymark",JobActivitiesComInfo.getJobActivitiesmarks(tmpjobactivityid));
				String tmpjobgroupid= JobActivitiesComInfo.getJobgroupid(tmpjobactivityid);
				tmp.put("jobgroupname",JobGroupsComInfo.getJobGroupsname(tmpjobgroupid));
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
	if(sqlwhere.length()==0)sqlwhere += " where 1=1";
	sqlwhere += " and a.id = b.jobgroupid and b.id = c.jobactivityid ";
	if(!jobgroupid.equals("")){
		sqlwhere += " and a.id ="+jobgroupid;
	}
	if(!jobactivitieid.equals("")){
		sqlwhere += " and b.id= "+jobactivitieid;
	}
	if(!jobtitlemark.equals("")){
		sqlwhere += " and c.jobtitlemark like '%" + Util.fromScreen2(jobtitlemark,user.getLanguage()) +"%' ";
	}
	if(!jobtitlename.equals("")){
		sqlwhere += " and c.jobtitlename like '%" + Util.fromScreen2(jobtitlename,user.getLanguage()) +"%' ";
	}
	//屏蔽已选人员
	String excludeId = Util.null2String(request.getParameter("excludeId"));
	if(excludeId.length()==0)excludeId=check_per;
	if(excludeId.length()>0){
		sqlwhere += " and c.id not in ("+excludeId+")";
	}
	
	SplitPageParaBean spp = new SplitPageParaBean();
	spp.setBackFields(" c.id,c.jobtitlemark,c.jobtitlename,a.jobgroupname,b.jobactivitymark ");
	spp.setSqlFrom("HrmJobGroups a,HrmJobActivities b,HrmJobTitles c");
	spp.setSqlWhere(sqlwhere);
	spp.setSqlOrderBy("c.jobtitlemark");
	spp.setPrimaryKey("c.id");
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

		JSONObject tmp = new JSONObject();
		tmp.put("id",id);
		tmp.put("jobtitlename",rs.getString("jobtitlename"));
		tmp.put("jobactivitymark",rs.getString("jobactivitymark"));
		tmp.put("jobgroupname",rs.getString("jobgroupname"));
		jsonArr.add(tmp);
	}
	json.put("currentPage", pagenum);
	json.put("totalPage", totalPage);
	json.put("mapList",jsonArr.toString());
	out.println(json.toString());
}
%>
				