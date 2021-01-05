
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.conn.*" %>
<%@ page import="weaver.general.StaticObj"%>
<jsp:useBean id="SubCompanyVirtualComInfo" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String id = Util.null2String(request.getParameter("id"));
int companyid = Util.getIntValue(request.getParameter("companyid"));
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String subcompanyname = Util.fromScreen(request.getParameter("subcompanyname"),user.getLanguage());
String subcompanydesc = Util.fromScreen(request.getParameter("subcompanydesc"),user.getLanguage());
int supsubcomid=Util.getIntValue(request.getParameter("supsubcomid"),0);
int showorder=Util.getIntValue(request.getParameter("showorder"),0);
String subcompanycode = Util.fromScreen(request.getParameter("subcompanycode"),user.getLanguage());
String sql = "";

if(operation.equals("editsubcompany")){
	sql = " update HrmSubCompanyVirtual set subcompanyname='"+subcompanyname+"', subcompanydesc='"+subcompanydesc+"',"+
				" supsubcomid='"+supsubcomid+"', companyid='"+companyid+"',virtualtypeid='"+companyid+"',showorder="+showorder+"," +
				" subcompanycode='"+subcompanycode+"' where id = "+id;
	rs.executeSql(sql);

	
	
	SysMaintenanceLog.resetParameter();
  SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
	SysMaintenanceLog.setRelatedName(subcompanyname);
	SysMaintenanceLog.setOperateType("2");
	SysMaintenanceLog.setOperateDesc(sql);
	SysMaintenanceLog.setOperateItem("413");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();

	SubCompanyVirtualComInfo.removeSubCompanyCache();
  response.sendRedirect("HrmSubCompanyEdit.jsp?isDialog=1&isclose=1&subcomid="+id);
}else if(operation.equals("addsubcompany")){
	sql = " insert into HrmSubCompanyVirtual (subcompanyname, subcompanydesc, supsubcomid, companyid, virtualtypeid, showorder,subcompanycode)"+
				" values('"+subcompanyname+"','"+subcompanydesc+"','"+supsubcomid+"','"+companyid+"','"+companyid+"',"+showorder+",'"+subcompanycode+"')";
	rs.executeSql(sql);
	
	sql="select min(id) as id from HrmSubCompanyVirtual ";
	rs.executeSql(sql);
	if(rs.next()){
		id=rs.getString("id");
	}
	
	//更新左侧菜单，新增的分部继承上级分部的左侧菜单
	String strWhere=" where resourcetype=2 and resourceid="+supsubcomid; 
	if(supsubcomid==0) strWhere=" where resourcetype=1  and resourceid=1 "; 
	String strSql="insert into leftmenuconfig (userid,infoid,visible,viewindex,resourceid,resourcetype,locked,lockedbyid,usecustomname,customname,customname_e)  select  distinct  userid,infoid,visible,viewindex,"+id+",2,locked,lockedbyid,usecustomname,customname,customname_e from leftmenuconfig "+strWhere;
	rs.executeSql(strSql);



	//更新顶部菜单，新增的分部继承上级分部的顶部菜单
	strWhere=" where resourcetype=2 and resourceid="+supsubcomid; 
	if(supsubcomid==0) strWhere=" where resourcetype=1  and resourceid=1 "; 
	strSql="insert into mainmenuconfig (userid,infoid,visible,viewindex,resourceid,resourcetype,locked,lockedbyid,usecustomname,customname,customname_e)  select  distinct  userid,infoid,visible,viewindex,"+id+",2,locked,lockedbyid,usecustomname,customname,customname_e from mainmenuconfig "+strWhere;
	rs.executeSql(strSql);
	
	SysMaintenanceLog.resetParameter();
  SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
	SysMaintenanceLog.setRelatedName(subcompanyname);
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc(sql);
	SysMaintenanceLog.setOperateItem("413");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();

	SubCompanyVirtualComInfo.removeSubCompanyCache();

	response.sendRedirect("HrmSubCompanyAdd.jsp?isclose=1&subcomid="+id);
}else if(operation.equals("deletesubcompany")){
	sql = " select subcompanyname from HrmSubCompanyVirtual where id = "+id;
	rs.executeSql(sql);
	if(rs.next()){
		subcompanyname = rs.getString("subcompanyname");
	}
	
	sql = " delete from HrmSubCompanyVirtual where id = "+id;
	rs.executeSql(sql);
	
	sql="update hrmsubcompanyvirtual set supsubcomid=0 where supsubcomid="+id;
  rs.executeSql(sql);
  
  SubCompanyVirtualComInfo.removeSubCompanyCache();
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
	SysMaintenanceLog.setRelatedName(subcompanyname);
	SysMaintenanceLog.setOperateType("3");
	SysMaintenanceLog.setOperateDesc(sql);
	SysMaintenanceLog.setOperateItem("413");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();
	
	response.sendRedirect("HrmSubCompanyList.jsp?id="+id);
}
%>