<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-06-13 [E7 to E8] -->
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="srwf" class="weaver.system.SysRemindWorkflow" scope="page" />
<%
  	int userid = user.getUID();
  	Calendar todaycal = Calendar.getInstance ();
  	String today = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;
	String _status = Util.null2String(request.getParameter("_status"));
  	String id = Util.fromScreen(request.getParameter("id"),user.getLanguage());
  	String topic = Util.fromScreen(request.getParameter("topic"),user.getLanguage());  
  	String principalid = Util.fromScreen(request.getParameter("principalid"),user.getLanguage());
  	String oldprincipalid = Util.fromScreen(request.getParameter("oldprincipalid"),user.getLanguage());

  	String informmanid = Util.fromScreen(request.getParameter("informmanid"),user.getLanguage());
  	String oldinformmanid = Util.fromScreen(request.getParameter("oldinformmanid"),user.getLanguage());
  	String emailmould = Util.fromScreen(request.getParameter("emailmould"),user.getLanguage());
  	String startdate = Util.fromScreen(request.getParameter("startdate"),user.getLanguage());

  	String budget = Util.fromScreen(request.getParameter("budget"),user.getLanguage());
  	String memo = Util.fromScreen(request.getParameter("memo"),user.getLanguage());
  	int budgettype = Util.getIntValue(request.getParameter("budgettype"),0); 

  	String fare = Util.fromScreen(request.getParameter("fare"),user.getLanguage());  
  	String faretype = Util.fromScreen(request.getParameter("faretype"),user.getLanguage());  
  	String advice = Util.fromScreen(request.getParameter("advice"),user.getLanguage());  
  
  	String operation  = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
  	String sql = "";
  	String para = "";
  	char separator = Util.getSeparator() ; 
  	if(operation.equals("save") || operation.equals("next")){
        para = topic +separator+ principalid + separator+
                informmanid+ separator+ emailmould  +separator+ startdate   + separator+ 
                budget     + separator+ budgettype  +separator+ memo;  
        rs.executeProc("HrmCareerPlan_Insert",para);
        rs.next();
        id = ""+rs.getInt(1);

        SysMaintenanceLog.resetParameter();
        SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
        SysMaintenanceLog.setRelatedName(topic);
        SysMaintenanceLog.setOperateType("1");
        SysMaintenanceLog.setOperateDesc("HrmCareerPlan_Insert,"+para);
        SysMaintenanceLog.setOperateItem("70");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
        SysMaintenanceLog.setSysLogInfo();
        
        response.sendRedirect("HrmCareerPlanAdd.jsp?id="+id+"&_status="+_status+"&isclose="+(operation.equals("next") ? 2 : 1));
  	}else if(operation.equals("edit")){
        para = ""+id + separator+ topic +separator+ principalid + separator+
               informmanid+ separator+ emailmould  +separator+ startdate   + separator+ 
               budget     + separator+ budgettype  +separator+ memo;    
        rs.executeProc("HrmCareerPlan_Update",para);
        
        SysMaintenanceLog.resetParameter();
        SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
        SysMaintenanceLog.setRelatedName(topic);
        SysMaintenanceLog.setOperateType("2");
        SysMaintenanceLog.setOperateDesc("HrmCareerPlan_Update,"+para);
        SysMaintenanceLog.setOperateItem("70");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
        SysMaintenanceLog.setSysLogInfo();
        
		response.sendRedirect("HrmCareerPlanEdit.jsp?id="+id+"&isclose=1&_status="+_status);
  	}else if(operation.equals("delete")){
   	 	para = ""+id;    
    	rs.executeProc("HrmCareerPlan_Delete",para);
    
      	SysMaintenanceLog.resetParameter();
      	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      	SysMaintenanceLog.setRelatedName(topic);
      	SysMaintenanceLog.setOperateType("3");
      	SysMaintenanceLog.setOperateDesc("HrmCareerPlan_Delete,"+para);
      	SysMaintenanceLog.setOperateItem("70");
      	SysMaintenanceLog.setOperateUserid(user.getUID());
      	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      	SysMaintenanceLog.setSysLogInfo();
    	response.sendRedirect("HrmCareerPlan.jsp");
  	}else if(operation.equals("finish")){
	    para = ""+id+separator+today+separator+fare+separator+faretype+separator+advice;    
	    rs.executeProc("HrmCareerPlan_Finish",para);
	    response.sendRedirect("HrmCareerPlanEdit.jsp?id="+id+"&isclose=1&_status="+_status);
  	}else if(operation.equals("step")){
        rs.executeSql("delete from HrmCareerPlanStep where planid = "+id);
        
  		int rownum = Util.getIntValue(request.getParameter("rownum"),0); 
	    for(int i = 0;i<rownum;i++){
            String stepname = Util.fromScreen(request.getParameter("stepname_"+i),user.getLanguage()) ; 
            String stepstartdate = Util.fromScreen(request.getParameter("stepstartdate_"+i),user.getLanguage()) ; 
            String stependdate = Util.fromScreen(request.getParameter("stependdate_"+i),user.getLanguage()) ;
            String info = stepname+stepstartdate+stependdate;
            if(!info.trim().equals("")){
                para = ""+id+separator+stepname+separator+stepstartdate +separator+stependdate;
                rs.executeProc("HrmCareerPlanStep_Insert",para);
            }
        }
	    response.sendRedirect("HrmCareerStep.jsp?isdialog=1&id="+id);
  	}else if(operation.equals("applyinfo")){
		int rownum = Util.getIntValue(request.getParameter("rownum"),0); 
		for(int i = 0;i<rownum;i++){
			String applyid = Util.fromScreen(request.getParameter("applyid_"+i),user.getLanguage()); 
			String isinform = Util.fromScreen(request.getParameter("isinform_"+i),user.getLanguage());
			if(applyid.length() > 0){
				rs.executeSql("update HrmCareerApply set isinform = "+(isinform.length()>0?"1":"0")+" where id = "+applyid);
			}
		}
		response.sendRedirect("HrmCareerApplyInfo.jsp?isdialog=1&planid="+id);
	}
%>
