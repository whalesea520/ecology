<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="OperateUtil" class="weaver.pr.util.OperateUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	if (!HrmUserVarify.checkUserRight("GP_BaseSettingMaint", user)){
		response.sendRedirect("/workrelate/plan/util/Message.jsp");
		return;
	}

	String sql = "";
	String operation = Util.fromScreen3(request.getParameter("operation"),user.getLanguage());
	String resourceid = Util.fromScreen3(request.getParameter("resourceid"),user.getLanguage());
	String resourcetype = Util.fromScreen3(request.getParameter("resourcetype"),user.getLanguage());
	
	String isweek = Util.getIntValue(request.getParameter("isweek"),0)+"";      
	String ismonth = Util.getIntValue(request.getParameter("ismonth"),0)+"";   
	String iswremind = Util.getIntValue(request.getParameter("iswremind"),0)+"";      
	String ismremind = Util.getIntValue(request.getParameter("ismremind"),0)+"";    
	String wstarttype = Util.getIntValue(request.getParameter("wstarttype"),0)+"";     
	String wstartdays = Util.getIntValue(request.getParameter("wstartdays"),0)+"";     
	String wendtype = Util.getIntValue(request.getParameter("wendtype"),0)+"";       
	String wenddays = Util.getIntValue(request.getParameter("wenddays"),0)+"";       
	String mstarttype = Util.getIntValue(request.getParameter("mstarttype"),0)+"";     
	String mstartdays = Util.getIntValue(request.getParameter("mstartdays"),0)+"";     
	String mendtype = Util.getIntValue(request.getParameter("mendtype"),0)+"";       
	String menddays = Util.getIntValue(request.getParameter("menddays"),0)+"";       
	String programcreate = Util.null2String(request.getParameter("programcreate"));  
	if(!programcreate.equals("") && !programcreate.startsWith(",")) programcreate = "," + programcreate;
	if(!programcreate.equals("") && !programcreate.endsWith(",")) programcreate = programcreate + ",";
	String reportaudit = Util.null2String(request.getParameter("reportaudit"));  
	if(!reportaudit.equals("") && !reportaudit.startsWith(",")) reportaudit = "," + reportaudit;
	if(!reportaudit.equals("") && !reportaudit.endsWith(",")) reportaudit = reportaudit + ",";
	String manageraudit = Util.getIntValue(request.getParameter("manageraudit"),0)+"";       
	String reportview = Util.null2String(request.getParameter("reportview"));  
	if(!reportview.equals("") && !reportview.startsWith(",")) reportview = "," + reportview;
	if(!reportview.equals("") && !reportview.endsWith(",")) reportview = reportview + ",";
	String isself = Util.getIntValue(request.getParameter("isself"),0)+"";         
	String ismanager = Util.getIntValue(request.getParameter("ismanager"),0)+""; 
	String docsecid = Util.getIntValue(request.getParameter("docsecid"),0)+"";  
	
	String subcompanyids = Util.fromScreen3(request.getParameter("subcompanyids"),user.getLanguage());
	
	ArrayList resourceidList = new ArrayList();
	if(operation.equals("del")){
		String setid = Util.null2String(request.getParameter("setid"));
		rs.executeSql("delete from PR_BaseSetting where id="+setid);
	}else{
		//保存
		if(operation.equals("save")){
			String resourceids = resourceid;
			if("3".equals(resourcetype)){
				String departmentids = Util.fromScreen3(request.getParameter("departmentids"),user.getLanguage());
				if(!departmentids.equals("")){
					resourceids += ","+departmentids;
				}
			}else{
				if(!subcompanyids.equals("")){
					resourceids += ","+subcompanyids;
				}
			}
		 	resourceidList = Util.TokenizerString(resourceids,",");
		}else if(operation.equals("sync")){
			resourceidList = SubCompanyComInfo.getSubCompanyLists(resourceid,resourceidList);
		}
		
		String rid = "";
		for(int i=0;i<resourceidList.size();i++){
			rid = (String)resourceidList.get(i);
			if(!"".equals(rid)){
				rs.executeSql("delete from PR_BaseSetting where resourcetype="+resourcetype+" and resourceid="+rid);
				sql = "insert into PR_BaseSetting(resourceid,resourcetype,isweek,ismonth,wstarttype,wstartdays,wendtype,wenddays,mstarttype,mstartdays,mendtype,menddays"
					+",programcreate,reportaudit,manageraudit,reportview,isself,ismanager,docsecid,iswremind,ismremind)"
					+" values "
					+"("+rid+","+resourcetype+","+isweek+","+ismonth
					+","+wstarttype+","+wstartdays+","+wendtype+","+wenddays+","+mstarttype+","+mstartdays+","+mendtype+","+menddays
					+",'"+programcreate+"','"+reportaudit+"',"+manageraudit+",'"+reportview+"',"+isself+","+ismanager+","+docsecid+","+iswremind+","+ismremind+")";
				rs.executeSql(sql);
				OperateUtil.updatePlanBySetting(rid);
			}
		}
	}
	
	response.sendRedirect("BaseSetting.jsp?resourceid="+resourceid+"&resourcetype="+resourcetype);
%>
