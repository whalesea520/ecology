<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="net.sf.json.JSONObject"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
	User user = HrmUserVarify.getUser(request, response);
	if(user==null)return;
	String src = Util.null2String(request.getParameter("src"));
	String selectedids = Util.null2String(request.getParameter("systemIds"));
	int perpage = Util.getIntValue(request.getParameter("pageSize"),10) ;
	int pagenum = Util.getIntValue(request.getParameter("currentPage") , 1) ;
	
	if (src.equalsIgnoreCase("dest")) {
		JSONArray jsonArr = new JSONArray();
		JSONObject json = new JSONObject();
		if (!selectedids.equals("")) {
			String sql = " select a.id as jobgroupid, c.id, c.jobtitlemark, b.jobactivityname, a.jobgroupname " 
								 + " from HrmJobGroups a, HrmJobActivities b, HrmJobTitlesTemplet c " 
								 + " where a.id =b.jobgroupid and b.id = c.jobactivityid and c.id in (" + selectedids + ")";
			rs.executeSql(sql);
			while (rs.next()) {
				JSONObject tmp = new JSONObject();
				tmp.put("id", rs.getString("id"));
				tmp.put("jobtitlename", rs.getString("jobtitlemark"));
				//tmp.put("jobgroupname", rs.getString("jobgroupname"));
				tmp.put("jobactivityname", rs.getString("jobactivityname"));
				jsonArr.add(tmp);
			}
		}
		json.put("mapList", jsonArr.toString());
		out.println(json.toString());
		return;
	}
	JSONArray jsonArr = new JSONArray();
	JSONObject json = new JSONObject();
	String jobgroup = Util.null2String(request.getParameter("jobgroup"));
	String jobactivity = Util.null2String(request.getParameter("jobactivity"));
	String jobtitlemark = Util.null2String(request.getParameter("jobtitlemark"));
	String jobtitlename = Util.null2String(request.getParameter("jobtitlename"));
	
  String sqlwhere = " a.id =b.jobgroupid and b.id = c.jobactivityid ";
  if(jobgroup.length()>0){
  	sqlwhere+=" and a.id ="+jobgroup;
  }
  
  if(jobactivity.length()>0){
  	sqlwhere+=" and b.id ="+jobactivity;
  }
  
  if(jobtitlemark.length()>0){
  	sqlwhere+=" and c.jobtitlemark like '%"+jobtitlemark+"%'";
  }
  
  if(jobtitlename.length()>0){
  	sqlwhere+=" and c.jobtitlename like '%"+jobtitlename+"%'";
  }
  
  if(selectedids.length()>0){
  	sqlwhere += " and c.id not in ("+selectedids+")";
  }
  
	SplitPageParaBean spp = new SplitPageParaBean();
	spp.setBackFields(" a.id as jobgroupid, c.id, c.jobtitlemark, b.jobactivityname, a.jobgroupname ");
	spp.setSqlFrom(" HrmJobGroups a, HrmJobActivities b, HrmJobTitlesTemplet c ");
	spp.setSqlWhere(sqlwhere);
	spp.setSqlOrderBy(" jobgroupid, b.id ");
	spp.setPrimaryKey("c.id");
	spp.setDistinct(false);
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
		JSONObject tmp = new JSONObject();
		tmp.put("id", rs.getString("id"));
		tmp.put("jobtitlemark", rs.getString("jobtitlemark"));
		//tmp.put("jobgroupname", rs.getString("jobgroupname"));
		tmp.put("jobactivityname", rs.getString("jobactivityname"));
		jsonArr.add(tmp);
	}
	json.put("mapList", jsonArr.toString());
	out.println(json.toString());
%>
