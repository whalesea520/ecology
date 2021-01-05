
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="java.util.List" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.WorkPlan.WorkPlanLogMan" %>
<%@ page import="weaver.WorkPlan.WorkPlanExchange" %>
<%@ page import="weaver.WorkPlan.WorkPlanHandler" %>

<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />

<HTML>
	<HEAD>
		<TITLE></TITLE>
<%
	RecordSet recordSet = new RecordSet();
	String workPlanIDs = request.getParameter("workPlanIDs");
	String method= request.getParameter("method");

	if(!"".equals(workPlanIDs) && null != workPlanIDs)
	{
	    WorkPlanExchange exchange = new WorkPlanExchange();
	    WorkPlanHandler workPlanHandler = new WorkPlanHandler();
	    WorkPlanLogMan logMan = new WorkPlanLogMan();
	    
	    String userID = String.valueOf(user.getUID());
		List workPlanList = Util.TokenizerString(workPlanIDs, ",");						
		
		recordSet.executeSql("select workplantypeid from WorkPlanMonitor where hrmid="+userID);//获取当前用户监控的日程类型
		List workPlanType=new ArrayList<String>();
		while(recordSet.next()){
			workPlanType.add(Util.null2String(recordSet.getString("workplantypeid")));
		}
		for(int i = 0; i < workPlanList.size(); i++)
		{
			String workPlanID = (String)workPlanList.get(i);
		
			recordSet.executeSql("SELECT * FROM WorkPlan WHERE id = " + workPlanID);
			if(recordSet.next())
			{
				String name=Util.null2String(recordSet.getString("name"));
				String type=Util.null2String(recordSet.getString("type_n"));
				if(workPlanType.contains(type)){//如果监控类型中包含当前类型才可删除
				  if("delete".equals(method)){//删除
					String logParams[] = new String[]
					{ workPlanID, WorkPlanLogMan.TP_DELETE, userID, Util.getIpAddr(request) };
					logMan.writeViewLog(logParams);
					
					workPlanHandler.delete(workPlanID);
			
					exchange.workPlanDelete(Integer.parseInt(workPlanID));
					
					SysMaintenanceLog.resetParameter();
					SysMaintenanceLog.setRelatedId(Util.getIntValue(workPlanID));
					SysMaintenanceLog.setOperateUserid(user.getUID());
					SysMaintenanceLog.setOperateType("4");
					SysMaintenanceLog.setRelatedName(name);
				    SysMaintenanceLog.setClientAddress(Util.getIpAddr(request));
				    SysMaintenanceLog.setOperateDesc("日程监控删除");
				    SysMaintenanceLog.setOperateItem("91");
				    SysMaintenanceLog.setOperatesmalltype(1);
				    SysMaintenanceLog.setOperateusertype(Util.getIntValue(user.getLogintype()));
				    SysMaintenanceLog.setSysLogInfo();   
				}
				//QC333914 日程监控增加强制完成功能
				 if("finish".equals(method)){
					 RecordSet rs=new RecordSet();
					 String sql="select * from workplaneditlog where fieldname='状态:强制完成' and workPlanId=? order by logDate Desc,logTime Desc";
					 rs.executeQuery(sql,workPlanID);
					 String status="";
					 if(rs.next()){
						 status=rs.getString("newValue");
					 }
					 if("".equals(status)||"0".equals(status)){//没有强制完成记录,则进行记录
						 String[] logParameter = new String[]
						 { workPlanID, "状态:强制完成", "0", "1", userID, Util.getIpAddr(request) };
						 logMan.writeEditLog(logParameter);
						 workPlanHandler.finishWorkPlan(workPlanID);
					 }
					 
				 }
			   }
			}			
		}
	}
	
	response.sendRedirect("WorkPlanMonitor.jsp");		
%>
	</HEAD>

<BODY>
</BODY>

</HTML>
