<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="weaver.general.*"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.file.FileUpload"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cmutil" class="weaver.pr.util.TransUtil" scope="page" />


<%  request.setCharacterEncoding("UTF-8");
    List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
	String msg ="";
	int totalpage = 0;//总页数
	try{
		FileUpload fu = new FileUpload(request);
		String currentUserId = user.getUID()+"";
		String currentdate = TimeUtil.getCurrentDateString();
		int pageNum = Util.getIntValue(fu.getParameter("pageNum"),1);//第几页
		
		String type1 = Util.null2String(fu.getParameter("type1"));
		String hrmids = Util.fromScreen3(fu.getParameter("hrmids"),user.getLanguage());
		String subids = Util.fromScreen3(fu.getParameter("subids"), user.getLanguage());
		String deptids = Util.fromScreen3(fu.getParameter("deptids"), user.getLanguage());
		String hrmname = Util.null2String(fu.getParameter("hrmname"));
		ResourceComInfo resourceComInfo = new ResourceComInfo();
		
		String innerSql =" t.id,t.planname,t.userid,h.lastname,hs.subcompanyname,hd.departmentname,t.year,t.type1,t.type2,t.status,t.startdate,t.enddate,h.departmentid,h.subcompanyid1,h.jobtitle,(case when exists (select 1 from PR_PlanReportLog rp where t.id = rp.planid and rp.operator = "+currentUserId+") then 1 else 0 end) nums ";
		String whereSql = " PR_PlanReport t,HrmResource h,HrmSubCompany hs,HrmDepartment hd ";
		if("oracle".equals(rs.getDBType())){
			whereSql +=" where t.isvalid=1 and t.status=1 and t.userid=h.id and h.subcompanyid1 = hs.id and h.departmentid = hd.id and t.startdate<='"+currentdate+"'"+" and t.enddate>='"+currentdate+"'"
	 		+" and h.status in (0,1,2,3) and h.loginid is not null"
			+" and (exists(select 1 from PR_PlanReportAudit aa where aa.planid=t.id and aa.userid="+currentUserId+"))";
		}else{
			whereSql +=" where t.isvalid=1 and t.status=1 and t.userid=h.id and h.subcompanyid1 = hs.id and h.departmentid = hd.id and t.startdate<='"+currentdate+"'"+" and t.enddate>='"+currentdate+"'"
		 	+" and h.status in (0,1,2,3) and h.loginid is not null and h.loginid<>''"
			+" and (exists(select 1 from PR_PlanReportAudit aa where aa.planid=t.id and aa.userid="+currentUserId+"))";
		}
		if(type1!=null && !"".equals(type1) && !"0".equals(type1)){
			whereSql += " and t.type1 =" + type1;
		}
		if(!hrmids.equals("")){
			whereSql += " and t.userid in ("+hrmids+")";
		}
		if(!"".equals(subids)){
			whereSql += " and h.subcompanyid1 in ("+subids+")";
		}
		if(!"".equals(deptids)){
			whereSql += " and h.departmentid in ("+deptids+")";
		}
		if(!"".equals(hrmname)){
			whereSql += " and h.lastname like '%"+hrmname+"%'";
		}
		String orderSql = " order by nums,t.userid ";	
		String orderSql1 = " order by nums desc,userid desc ";	
		String orderSql2 = " order by nums,userid ";	
		
		String countSql = "select count(h.id) total from "+whereSql;
		//System.out.println(countSql);
		rs.executeSql(countSql);
		int iTotal = 0;  //总条数
		if(rs.next()){
			iTotal = rs.getInt("total");
		}
		int _pagesize = 5; //每页显示页数
		if(iTotal>0){
			totalpage = iTotal / _pagesize;
			if(iTotal % _pagesize >0) totalpage += 1;
			int iNextNum = pageNum * _pagesize;
			int ipageset = _pagesize;
			if(iTotal - iNextNum + _pagesize < _pagesize) ipageset = iTotal - iNextNum + _pagesize;
			if(iTotal < _pagesize) ipageset = iTotal;
			String sql = "";
			int dcount = 0;
			if(rs.getDBType().equals("oracle")){
				sql = "select "+innerSql+" from " +whereSql+orderSql;
				sql = "select A.*,rownum rn from (" + sql + ") A where rownum <= " +  (iNextNum-dcount);
				sql = "select B.* from (" + sql + ") B where rn > " + (iNextNum -dcount - _pagesize);
			}else{
				sql = "select top " + ipageset +" A.* from (select top "+ (iNextNum-dcount) + innerSql+" from "+ whereSql+ orderSql+ ") A "+orderSql1;
				sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderSql2;
			}
			//System.out.println(sql);
			rs.executeSql(sql);
			Map<String,Object> maps = null;
			while(rs.next()){
				maps = new HashMap<String,Object>();
				String enddate = Util.null2String(rs.getString("enddate"));
				String id = Util.null2String(rs.getString("id"));
				String userid = Util.null2String(rs.getString("userid"));
				String subname = Util.null2String(rs.getString("subcompanyname"));
				String userimg = resourceComInfo.getMessagerUrls(userid);//人头像
				String planname = Util.null2String(rs.getString("planname"));
				String departmentname = Util.null2String(rs.getString("departmentname"));
				String nums = Util.null2String(rs.getString("nums"));
				String stat = "";
				if(TimeUtil.dateInterval(enddate, currentdate)>0){
					stat = "0";
				}else{
					stat ="1"; 
				}
				maps.put("userimg",userimg);
				maps.put("planname",planname);
				maps.put("nums",nums);
				maps.put("subname",subname);
				maps.put("departmentname",departmentname);
				maps.put("enddate",enddate);
				maps.put("stat",stat);
				maps.put("id",id);
				list.add(maps);
			}
			msg ="0";
		}else{
			msg = "暂无工作计划报告信息";
		}
	}catch(Exception e){
		msg = "数据加载失败,请稍后再试";
	}
	JSONObject json = new JSONObject();
	json.put("list",list);
	json.put("msg",msg);
	json.put("totalpage",totalpage);
	out.print(json.toString());
%>