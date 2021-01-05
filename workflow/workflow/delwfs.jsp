
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<!--add by xhheng @ 2004/12/07 for TDID 1317-->
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.workflow.workflow.WorkflowVersion" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="WFMainManager" class="weaver.workflow.workflow.WFMainManager" scope="page"/>
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />

<%
  //modify by xhheng @ 2004/12/07 for TDID 1317 start
  //删除工作流日志
  String del_ids[]=request.getParameterValues("delete_wf_id");
  int typeid=Util.getIntValue(request.getParameter("typeid"),0);
  String wfids = Util.null2String(request.getParameter("wfids"));
  String isTemplate=Util.null2String(request.getParameter("isTemplate"));

  if(!"".equals(wfids) && del_ids==null){
  	del_ids = Util.TokenizerString2(wfids, ",");
  }
  List<String> delidsList = new ArrayList<String>();

  for(int i=0;i<del_ids.length;i++){
    
    String allversionwfids = WorkflowVersion.getAllVersionStringByWFIDs(del_ids[i]);
    
    String[] del_ids_temp = Util.TokenizerString2(allversionwfids, ",");
    for(String delid : del_ids_temp){
	    //modify by xhheng @20050104 for TD 1317
	    SysMaintenanceLog.resetParameter();
	    SysMaintenanceLog.setRelatedId((new Integer(delid)).intValue());
	    WFManager.setWfid((new Integer(delid)).intValue());
	    WFManager.getWfInfo();
	    SysMaintenanceLog.setRelatedName(WFManager.getWfname());
	    SysMaintenanceLog.setOperateType("3");
	    SysMaintenanceLog.setOperateDesc("WrokFlow_delete");
	    SysMaintenanceLog.setOperateItem("85");
	    SysMaintenanceLog.setOperateUserid(user.getUID());
	    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	    SysMaintenanceLog.setIstemplate(Util.getIntValue(isTemplate));    
	    SysMaintenanceLog.setSysLogInfo();
	    
	    delidsList.add(delid);
    }
  }
  //modify by xhheng @20050104 for TD 1317
  WFMainManager.DeleteWf(delidsList.toArray(new String[delidsList.size()]));
  //modify by xhheng @ 2004/12/07 for TDID 1317 end

  WorkflowComInfo.removeWorkflowCache();
  response.sendRedirect("managewf.jsp?isclose=1&typeid="+typeid+"&isTemplate="+isTemplate);
%>
