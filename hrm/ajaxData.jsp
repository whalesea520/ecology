<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page"/>
<jsp:useBean id="DepartmentVirtualComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser(request,response);
//人力资源 ajax公共页面
String cmd = Util.null2String(request.getParameter("cmd"));
JSONObject jsonObj = new JSONObject();
char separator = Util.getSeparator() ;
String sql = "";

if(cmd.equals("traintype")){
	//获得培训种类
	int typeid = Util.getIntValue(request.getParameter("typeid"));
	sql = " SELECT typecontent, typeaim FROM hrmTrainType where id = "+typeid;
	rs.executeSql(sql);
	if(rs.next()){
		jsonObj.put("typecontent",rs.getString("typecontent"));
		jsonObj.put("typeaim",rs.getString("typeaim"));
	}
	out.print(jsonObj.toString());
}else if(cmd.equals("trainlayout")){
	int trainlayoutid = Util.getIntValue(request.getParameter("trainlayoutid"));
	sql = " SELECT layoutcontent, layoutaim, layoutstartdate, layoutenddate FROM hrmtrainlayout where id = "+trainlayoutid;
	rs.executeSql(sql);
	if(rs.next()){
		jsonObj.put("layoutcontent",rs.getString("layoutcontent"));
		jsonObj.put("layoutaim",rs.getString("layoutaim"));
		jsonObj.put("layoutstartdate",rs.getString("layoutstartdate"));
		jsonObj.put("layoutenddate",rs.getString("layoutenddate"));
	}
	out.print(jsonObj.toString());
}else if(cmd.equals("trainplan")){
	int trainplanid = Util.getIntValue(request.getParameter("trainplanid"));
	sql = " SELECT planorganizer, planstartdate,planenddate,plancontent,planaim FROM HrmTrainPlan where id = "+trainplanid;
	rs.executeSql(sql);
	if(rs.next()){
		String planorganizer = Util.null2String(rs.getString("planorganizer"));
		jsonObj.put("planorganizer",planorganizer);
		jsonObj.put("planorganizername",ResourceComInfo.getLastnameAllStatus(planorganizer));
		jsonObj.put("plancontent",rs.getString("plancontent"));
		jsonObj.put("planaim",rs.getString("planaim"));
		jsonObj.put("planstartdate",rs.getString("planstartdate"));
		jsonObj.put("planenddate",rs.getString("planenddate"));
	}
	out.print(jsonObj.toString());
}else if(cmd.equals("checkcompany")){
	//校验总部是否可以删除
	boolean canDel = true;
	String companyid = request.getParameter("companyid");
	sql = " select count(*) from hrmsubcompanyvirtual where companyid= "+companyid;
	rs.executeSql(sql);
	if(rs.next()){
		if(rs.getInt(1)>0){
			canDel = false;
		}
	}
	if(canDel){
		out.print("1");
	}else{
		out.print("0");
	}
}else if(cmd.equals("checksubcompany")){
	//校验分部部是否可以删除
	boolean canDel = true;
	String subcompanyid = request.getParameter("subcompanyid");
	sql = "select count(*) from hrmdepartmentvirtual where subcompanyid1=" + subcompanyid;
	rs.executeSql(sql);
	if(rs.next()){
		if(rs.getInt(1)>0){
			canDel = false;
		}
	}
	
	if(canDel){
		sql = "select count(*) from hrmresourcevirtual where subcompanyid1=" + subcompanyid;
		rs.executeSql(sql);
		if(rs.next()){
			if(rs.getInt(1)>0){
				canDel = false;
			}
		}
	}
	if(canDel){
		out.print("1");
	}else{
		out.print("0");
	}
}else if(cmd.equals("checkdepartment")){
	//校验总部是否可以删除
	boolean canDel = true;
	String departmentid = request.getParameter("departmentid");
	sql = "select count(*) from hrmresourcevirtual where departmentid=" + departmentid;
 	rs.executeSql(sql);
	if(rs.next()){
		if (rs.getInt(1) > 0){
			canDel = false;
	 	}
	}
	if(canDel){
		out.print("1");
	}else{
		out.print("0");
	}
}else if(cmd.equals("checkvirtualtype")){
	//校验总部是否重复
	String id =Util.null2String(request.getParameter("id"));
	String virtualtype = request.getParameter("virtualtype");

	boolean canSave = true;
	sql = "select count(*) from hrmcompanyvirtual where virtualtype='" + virtualtype+"'";
	if(id.length()>0)sql+=" and id!= "+id;
 	rs.executeSql(sql);
	if(rs.next()){
		if (rs.getInt(1) > 0){
			canSave = false;
	 	}
	}
	if(canSave){
		out.print("1");
	}else{
		out.print("0");
	}
}else if(cmd.equals("checksubcompanyname")){
	//校验分部是否重复
	String id =Util.null2String(request.getParameter("id"));
	String companyid =Util.null2String(request.getParameter("companyid"));
	String subcompanyname = request.getParameter("subcompanyname");
	String subcompanydesc = request.getParameter("subcompanydesc");
	
	boolean canSave = true;
	sql = "select count(*) from hrmsubcompanyvirtual where subcompanyname='" + subcompanyname+"'";
	if(id.length()>0)sql+=" and id!= "+id;
	if(companyid.length()>0)sql+=" and companyid= "+companyid;
	//System.out.println(sql);
 	rs.executeSql(sql);
	if(rs.next()){
		if (rs.getInt(1) > 0){
			canSave = false;
	 	}
	}
	
	if(canSave){
		sql = "select count(*) from hrmsubcompanyvirtual where subcompanydesc='" + subcompanydesc+"'";
		if(id.length()>0)sql+=" and id!= "+id;
		if(companyid.length()>0)sql+=" and companyid= "+companyid;
	 	rs.executeSql(sql);
		if(rs.next()){
			if (rs.getInt(1) > 0){
				canSave = false;
		 	}
		}
	}
  
	if(canSave){
		out.print("1");
	}else{
		out.print("0");
	}
}else if(cmd.equals("checkdepartmentname")){
	//校验部门是否重复
	String id =Util.null2String(request.getParameter("id"));
	String subcompanyid = request.getParameter("subcompanyid");
	String departmentmark = request.getParameter("departmentmark");
	String departmentname = request.getParameter("departmentname");
	
	boolean canSave = true;
	sql = "select count(*) from hrmdepartmentvirtual where subcompanyid1 = "+subcompanyid+" and departmentmark='" + departmentmark+"'";
	if(id.length()>0)sql+=" and id!= "+id;
 	rs.executeSql(sql);
	if(rs.next()){
		if (rs.getInt(1) > 0){
			canSave = false;
	 	}
	}
	
	if(canSave){
		sql = "select count(*) from hrmdepartmentvirtual where subcompanyid1 = "+subcompanyid+" and  departmentname='" + departmentname+"'";
		if(id.length()>0)sql+=" and id!= "+id;
	 	rs.executeSql(sql);
		if(rs.next()){
			if (rs.getInt(1) > 0){
				canSave = false;
		 	}
		}
	}
	if(canSave){
		out.print("1");
	}else{
		out.print("0");
	}
}else if(cmd.equals("isNeedSign")){
	String[] signInfo = HrmScheduleDiffUtil.getSignInfo(user);
	boolean isNeedSign = Boolean.parseBoolean(signInfo[0]);
	String sign_flag = signInfo[1];
	String signType = signInfo[2];
	JSONObject tmp = new JSONObject();
	tmp.put("isNeedSign",isNeedSign);
	tmp.put("sign_flag",sign_flag);
	tmp.put("signType",signType);
	//System.out.println(tmp.toString());
	out.println(tmp.toString());
}else if(cmd.equals("checksysadmin")){
	String id = Util.null2String(request.getParameter("id"));
	String lastname = request.getParameter("lastname");
	String loginid = request.getParameter("loginid");
	String result = "0";
	sql = "select count(*) from HrmResourceAllView where lastname='" + lastname+"'";
	if(id.length()>0)sql+=" and id!= "+id;
 	rs.executeSql(sql);
	if(rs.next()){
		if (rs.getInt(1) > 0) result = "1";
	}
	
	if(result.equals("0")){
		sql = "select id  from HrmResourceAllView where loginid='" + loginid+"'";
		if(id.length()>0)sql+=" and id!= "+id;
	 	rs.executeSql(sql);
		if(rs.next()){
			if (rs.getInt(1) > 0) result = "2";
		}
	}
	JSONObject tmp = new JSONObject();
	tmp.put("result",result);
	//System.out.println(tmp.toString());
	out.println(tmp.toString());
}else if(cmd.equals("checkResourceVirtual")){
	JSONArray jsonArr = new JSONArray();
	String virtualtype = Util.null2String(request.getParameter("virtualtype"));
	String resourceids = Util.null2String(request.getParameter("resourceids"));
		
	//判断是否唯一
	sql = " SELECT lastname, departmentid,virtualtype FROM HrmResourceVirtualView where virtualtype = " + virtualtype
			+ " and id in ("+resourceids+")";
	rs.executeSql(sql);
	while(rs.next()){
		JSONObject tmp = new JSONObject();
		tmp.put("lastname",rs.getString("lastname"));
		tmp.put("departmentname",DepartmentVirtualComInfo.getDepartmentname(rs.getString("departmentid")));
		tmp.put("virtualtypename", CompanyVirtualComInfo.getVirtualType(rs.getString("virtualtype")));
		jsonArr.add(tmp);
	}
	
	out.println(jsonArr.toString());
}else if(cmd.equals("checkLastname")){
	boolean flag = false;
	String lastname = Util.null2String(request.getParameter("lastname"));
	String resourceid = Util.null2String(request.getParameter("resourceid"));
	if(lastname.length()>0){
		//判断workcode是否重复
		sql = " SELECT count(1) FROM hrmresource WHERE lastname = '"+lastname+"' ";
		if(resourceid.length()>0){
			sql += " and id!="+resourceid;
		}
		rs.executeSql(sql);
		if(rs.next()){
			if(rs.getInt(1)>0)flag = true;
		}
	}
	if(flag){
		out.println("1");
	}else{
		out.println("0");
	}
}else if(cmd.equals("checkLoginid")){
	boolean flag = false;
	String loginid = Util.null2String(request.getParameter("loginid"));
	String resourceid = Util.null2String(request.getParameter("resourceid"));
	if(loginid.length()>0){
		//判断workcode是否重复
		sql = " SELECT count(1) FROM hrmresource WHERE loginid = '"+loginid+"' ";
		if(resourceid.length()>0){
			sql += " and id!="+resourceid;
		}
		rs.executeSql(sql);
		if(rs.next()){
			if(rs.getInt(1)>0)flag = true;
		}
	}
	if(flag){
		out.println("1");
	}else{
		out.println("0");
	}
}else if(cmd.equals("checkOutManager")){
	boolean flag = false;
	String customid = Util.null2String(request.getParameter("customid"));
	String resourceid = Util.null2String(request.getParameter("resourceid"));
	if(customid.length()>0){
		sql = " SELECT COUNT(1) FROM hrmresourceout WHERE customid="+customid+" AND isoutmanager=1 ";
		if(resourceid.length()>0){
			sql += " and resourceid!="+resourceid;
		}
		rs.executeSql(sql);
		if(rs.next()){
			if(rs.getInt(1)>0)flag = true;
		}
	}
	if(flag){
		out.println("1");
	}else{
		out.println("0");
	}
}

%>