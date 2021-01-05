
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.SplitPageParaBean" %>
<%@ page import="weaver.general.SplitPageUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@page import="weaver.meeting.MeetingShareUtil"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />

<%
User user = HrmUserVarify.getUser(request,response);
//是否分权系统，如不是，则不显示框架，直接转向到列表页面
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("meetingdetachable")),0);
int subid=Util.getIntValue(request.getParameter("subCompanyId"));
int forall=Util.getIntValue(request.getParameter("forall"), 0);
if(subid<0){
        subid=user.getUserSubCompany1();
}

ArrayList subcompanylist=SubCompanyComInfo.getRightSubCompany(user.getUID(),"MeetingType:Maintenance");
String names = Util.null2String(request.getParameter("names"));
int selsubCompanyId = Util.getIntValue(request.getParameter("selsubCompanyId"), -1);
String src = Util.null2String(request.getParameter("src"));
String check_per = Util.null2String(request.getParameter("systemIds"));
if(check_per.trim().startsWith(",")){
	check_per = check_per.substring(1);
}
int perpage = Util.getIntValue(request.getParameter("pageSize"),10) ;
int pagenum = Util.getIntValue(request.getParameter("currentPage") , 1) ;
String sqlWhere = "";
JSONObject json = new JSONObject();
if(src.equalsIgnoreCase("dest")){
	if (!check_per.equals("")) {
		if(check_per.indexOf(",")==0){
			check_per=check_per.substring(1);
		}
		sqlWhere += " and id in ("+check_per+")";
	} else {
		json.put("currentPage", 1);
		json.put("totalPage", 1);
		json.put("mapList","");
		out.println(json.toString());
		return;
	}
} else {
	if(!"".equals(names)) sqlWhere += " and name like '%"+names+"%' ";
	if(detachable==1){
		if( selsubCompanyId > 0){
			sqlWhere += " and subcompanyid = "+selsubCompanyId+" ";
		}
		/*
		String subcompanys=SubCompanyComInfo.getRightSubCompanyStr1(""+subid,subcompanylist);
		for(int i=0; i<subcompanylist.size(); i++){
			if(!"".equals(subcompanys)){
				subcompanys += ","+(String)subcompanylist.get(i);
			}else{
				subcompanys = (String)subcompanylist.get(i);
			}
		}
		if( selsubCompanyId > 0){
			sqlWhere += " and subcompanyid = "+selsubCompanyId+" ";
		} else {
			if(subcompanys.length()>0){
				sqlWhere += " and subcompanyid in("+subcompanys+") ";
			}else{
				if(HrmUserVarify.checkUserRight("MeetingType:Maintenance",user)){
					sqlWhere += " and 1=2 ";
				}else{
					sqlWhere += " and subcompanyid="+user.getUserSubCompany1()+" ";
				}
			}
		}
		*/
	}
	if (check_per.equals("")) {
		check_per = Util.null2String(request.getParameter("excludeId"));
	}
	if (!check_per.equals("")) {
		if(check_per.indexOf(',')==0){
			check_per=check_per.substring(1);
		}
		sqlWhere += " and id not in ("+check_per+")";
	}
	String prmSql = " and exists ( "+
		" SELECT 1 FROM MeetingType_share b where meeting_type.id = b.mtid and b.departmentid = "+user.getUserDepartment()+" and b.deptlevel <= "+user.getSeclevel()+" AND b.deptlevelMax >= "+user.getSeclevel()+" AND b.permissiontype = 1 "+
		" UNION ALL "+
		" SELECT 1 FROM MeetingType_share b where meeting_type.id = b.mtid and b.subcompanyid in ("+
			user.getUserSubCompany1()+","+user.getUserSubCompany2()+","+user.getUserSubCompany3()+","+user.getUserSubCompany4()+") and b.sublevel <= "+user.getSeclevel()+" and b.sublevelMax >= "+user.getSeclevel()+" AND b.permissiontype = 6 "+
		" UNION ALL "+
		" SELECT 1 FROM MeetingType_share b where meeting_type.id = b.mtid and b.seclevel <= "+user.getSeclevel()+" and b.seclevelMax >= "+user.getSeclevel()+" AND b.permissiontype = 3 "+
		" UNION ALL "+
		" SELECT 1 FROM MeetingType_share b where meeting_type.id = b.mtid AND b.userid = "+user.getUID()+" AND b.permissiontype = 5 "+
		" UNION ALL "+
		" SELECT 1 FROM MeetingType_share b, hrmRoleMembers hr WHERE meeting_type.id = b.mtid AND hr.roleid = b.roleid AND hr.resourceid = "+user.getUID()+" AND hr.rolelevel >= b.rolelevel AND b.seclevel <= "+user.getSeclevel()+" and b.seclevelMax >= "+user.getSeclevel()+" AND b.permissiontype = 2 ) ";
	if(forall != 1){
		sqlWhere += MeetingShareUtil.getTypeShareSql(user);
	}
}


if(sqlWhere.length() > 4){
	sqlWhere = " where " + sqlWhere.substring(4);
} else {
	sqlWhere = "";
}
//System.out.println("sqlWhere:"+sqlWhere);
SplitPageParaBean spp = new SplitPageParaBean();

spp.setBackFields("id, name, subcompanyid,dsporder");
spp.setSqlFrom("meeting_type a");
spp.setSqlWhere(sqlWhere);
spp.setSqlOrderBy(" dsporder,name ");
spp.setPrimaryKey("id");
spp.setDistinct(true);
spp.setSortWay(spp.ASC);
SplitPageUtil spu = new SplitPageUtil();
spu.setSpp(spp);

int RecordSetCounts = spu.getRecordCount();
int totalPage = RecordSetCounts/perpage;
if(totalPage%perpage>0||totalPage==0){
	totalPage++;
}

String id=null;
String name=null;
String subcompanyid=null;

int i=0;

weaver.conn.RecordSet rs = spu.getCurrentPageRs(pagenum, perpage);

JSONArray jsonArr = new JSONArray();
while(rs.next()) {
	id = rs.getString("id");
	name = Util.null2String(rs.getString("name"));
	subcompanyid = Util.null2String(rs.getString("subcompanyid"));
	JSONObject tmp = new JSONObject();
	tmp.put("id",id);
	tmp.put("name",name);
	if (detachable == 1) {
		tmp.put("subcompanyid",SubCompanyComInfo.getSubCompanyname(subcompanyid));
	}
	
	jsonArr.add(tmp);
}
json.put("currentPage", pagenum);
json.put("totalPage", totalPage);
json.put("mapList",jsonArr.toString());
out.println(json.toString());
%>