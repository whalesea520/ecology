<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.hrm.common.*,weaver.hrm.chart.domain.*" %>
<%@ page import="weaver.hrm.*,java.util.*" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="OrgChartManager" class="weaver.hrm.chart.manager.OrgChartManager" scope="page" />
<jsp:useBean id="HrmCompanyVirtualManager" class="weaver.hrm.chart.manager.HrmCompanyVirtualManager" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" />
<jsp:useBean id="HrmChartSetManager" class="weaver.hrm.chart.manager.HrmChartSetManager" scope="page" />
<%
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
    String sorgid = Util.null2String(request.getParameter("sorgid"));
    String id = Util.null2String(request.getParameter("id"));
	String type = Util.null2String(request.getParameter("type"));
	String isShow = Util.null2String(request.getParameter("isShow"));
	
	Map map = new HashMap();
	map.put("is_sys",1);
	//HrmChartSet bean = HrmChartSetManager.get(map);
	int shownum = 1;
	/*if(bean != null){
		shownum = bean.getShowNum();
	}
	shownum = shownum <= 0 ? 1 : shownum;*/
    boolean isPOrg = false;
	String showName = "";
	if(CompanyComInfo.next()){
		showName = CompanyComInfo.getCompanyname();
		isPOrg = Tools.isNull(sorgid) ? true : CompanyComInfo.getCompanyid().equals(sorgid);
	}
	HrmCompanyVirtual cvBean = null;
	if(!isPOrg){
		cvBean = HrmCompanyVirtualManager.get(sorgid);
		showName = cvBean != null ? cvBean.getVirtualtype() : "";
	}
	String status = Util.null2String(request.getParameter("status"));
	String docStatus = Util.null2String(request.getParameter("docStatus"));
	String customerType = Util.null2String(request.getParameter("customerType"));
	String customerStatus = Util.null2String(request.getParameter("customerStatus"));
	String workType = Util.null2String(request.getParameter("workType"));
	String projectStatus = Util.null2String(request.getParameter("projectStatus"));
	map.clear();
	map.put("status",status);
	map.put("docStatus",docStatus);
	map.put("customerType",customerType);
	map.put("customerStatus",customerStatus);
	map.put("workType",workType);
	map.put("projectStatus",projectStatus);
	
	if(rs.getDBType().equals("oracle"))
	{
		rs.executeSql("update HrmSubCompany set tlevel=(select templevel from tempHrmSubCompanyView where tempHrmSubCompanyView.id=HrmSubCompany.id) where nvl(tlevel,0)=0"); 
	}
	else
	{
		rs.executeSql("update HrmSubCompany set tlevel=(select level from tempHrmSubCompanyView where tempHrmSubCompanyView.id=HrmSubCompany.id) where isnull(tlevel,0)=0");
	}
	if(rs.getDBType().equals("oracle"))
	{
		rs.executeSql("update HrmSubCompanyVirtual set tlevel=(select templevel from tempHrmSubCompanyVirtualView where tempHrmSubCompanyVirtualView.id=HrmSubCompanyVirtual.id) where nvl(tlevel,0)=0"); 
	}
	else
	{
		rs.executeSql("update HrmSubCompanyVirtual set tlevel=(select level from tempHrmSubCompanyVirtualView where tempHrmSubCompanyVirtualView.id=HrmSubCompanyVirtual.id) where isnull(tlevel,0)=0");
	}
	if(rs.getDBType().equals("oracle"))
	{
		rs.executeSql("update HrmDepartment set tlevel=(select templevel from tempHrmDepartmentView where tempHrmDepartmentView.id=HrmDepartment.id) where nvl(tlevel,0)=0");; 
	}
	else
	{
		rs.executeSql("update HrmDepartment set tlevel=(select level from tempHrmDepartmentView where tempHrmDepartmentView.id=HrmDepartment.id) where isnull(tlevel,0)=0");
	}
	if(rs.getDBType().equals("oracle"))
	{
		rs.executeSql("update HrmDepartmentVirtual set tlevel=(select templevel from tempHrmDepartmentVirtualView where tempHrmDepartmentVirtualView.id=HrmDepartmentVirtual.id) where nvl(tlevel,0)=0");
	}
	else
	{
		rs.executeSql("update HrmDepartmentVirtual set tlevel=(select level from tempHrmDepartmentVirtualView where tempHrmDepartmentVirtualView.id=HrmDepartmentVirtual.id) where isnull(tlevel,0)=0");
	}
	StringBuffer data = new StringBuffer();
	//System.out.println("type ; "+type);
	if(type.equals("subcompany"))
	{
		OrgChartManager.setPOrg(isPOrg);
		int currentlevel = OrgChartManager.getSubCompangLevel(id);
		OrgChartManager.setShownum(shownum+currentlevel);
		if(isShow.endsWith("B"))
			map = null;
		OrgChartManager.initBySubId(user, request, map, isShow, isPOrg, cvBean);
		
		data.append("[");
		data.append(OrgChartManager.getDataBySubId(id));
		data.append("]");
	}
	else if(type.equals("dept"))
	{
		id = id.replaceAll("d","");
		OrgChartManager.setPOrg(isPOrg);
		int currentlevel = OrgChartManager.getDepartmentLevel(id);
		//System.out.println("shownum : "+shownum+" currentlevel : "+currentlevel);
		OrgChartManager.setShownum(shownum+currentlevel);
		if(isShow.endsWith("B"))
			map = null;
		OrgChartManager.initBySubId(user, request, map, isShow, isPOrg, cvBean);
		
		String conditionsql = "";//" and t.supdepid="+id;
		weaver.hrm.company.OrgOperationUtil OrgOperationUtil = new weaver.hrm.company.OrgOperationUtil();
		String tempids = OrgOperationUtil.getAllDepartmentIds(id, isPOrg ? "0" : "1");
		if("".equals(tempids))
			tempids = "0";
		conditionsql = " and id in("+tempids+") and id!= "+id+" ";
		
		data.append("[");
		data.append(OrgChartManager.appendDepartment(conditionsql));
		data.append("]");
	}
	//System.out.println("data : "+data);
	out.println(data.toString());
%>