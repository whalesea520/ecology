
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.general.Util" %>

<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="recordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%
    if(!HrmUserVarify.checkUserRight("WorkPlanTypeSet:Set", user))
    {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }	
%>

<HTML>
<HEAD>
	
<%
	boolean returnFlag = false;

	String workPlanTypeID[] = request.getParameterValues("workPlanTypeIDs");
	String workPlanTypeName[] = request.getParameterValues("workPlanTypeName");
	for(int i=0;i<workPlanTypeName.length;i++){
	    workPlanTypeName[i] = Util.convertInput2DB(workPlanTypeName[i]);
	}
	String workPlanTypeColor[] = request.getParameterValues("color");
	String available[] = request.getParameterValues("available");

	String workPlanIDs[] = request.getParameterValues("workPlanIDs");
	String workplannames[] = request.getParameterValues("workplanname");
	String wcolors[] = request.getParameterValues("wcolor");
	String wavailables[] = request.getParameterValues("wavailable");
	
	String needWorkPlanString = "-1";
	String needOverWorkPlanString = "-1";
	
	List existsWorkPlanList = new ArrayList();	

	for(int i = 0; i < workPlanTypeID.length; i++)
	{
	    if(!"-1".equals(workPlanTypeID[i]))
	    {
	    	needWorkPlanString += ","+workPlanTypeID[i];
	    }
		//System.out.println(available[i]);
	}
	for(int i = 0; i < workPlanIDs.length; i++)
	{
	    if(!"-1".equals(workPlanIDs[i]))
	    {
	    	needOverWorkPlanString += ","+workPlanIDs[i];
	    }
		//System.out.println(available[i]);
	}
	if(needWorkPlanString.length() > 0)
	{
	    //System.out.println("DELETE FROM WorkPlanType WHERE workPlanTypeID NOT IN (" + needWorkPlanString + ")");
	    
	    //更改类型为被删除类型的日程为 默认类型
	    recordSet.executeSql("SELECT WorkPlanTypeId FROM WorkPlanType WHERE workPlanTypeID NOT IN (" + needWorkPlanString + ")");
	    while(recordSet.next())
	    {
	        int WorkPlanTypeId = recordSet.getInt("WorkPlanTypeId");
	        recordSet1.executeSql("SELECT 1 FROM WorkPlan WHERE type_n = " + WorkPlanTypeId);	        
	        if(recordSet1.next())
	        {
	            returnFlag = true;
	            break;
	        }
	    }
	}

	if(returnFlag)
	{
	    request.setAttribute("note", new String(SystemEnv.getHtmlLabelName(20210, user.getLanguage())));
	}
	else
	{
	    recordSet.executeSql("DELETE FROM WorkPlanType WHERE workPlanTypeID NOT IN (" + needWorkPlanString + ")");
	    recordSet.executeSql("DELETE FROM OverWorkPlan WHERE id NOT IN (" + needOverWorkPlanString + ")");
	    recordSet.executeSql("DELETE FROM WorkPlanMonitor WHERE workPlanTypeID NOT IN (" + needWorkPlanString + ")");
	    
	    for(int i = 0; i < workPlanTypeID.length; i++)
		{
		    if("-1".equals(workPlanTypeID[i]))
		    {
		    	//System.out.println("INSERT INTO WorkPlanType(workPlanTypeName, workPlanTypeAttribute, workPlanTypeColor, available, displayOrder) VALUES('" + workPlanTypeName[i] + "', 0, '" + workPlanTypeColor[i] +  "', '" + available[i] + "', " + i + ")");
		        recordSet.executeSql("INSERT INTO WorkPlanType(workPlanTypeName, workPlanTypeAttribute, workPlanTypeColor, available, displayOrder) VALUES('" + workPlanTypeName[i] + "', 0, '" + workPlanTypeColor[i] +  "', '" + available[i] + "', " + i + ")");
		    }
		    else
		    {
		        //System.out.println("UPDATE WorkPlanType SET workPlanTypeName = '" + workPlanTypeName[i] + "', workPlanTypeColor = '" + workPlanTypeColor[i] +  "', available = '" + available[i] + "', displayOrder = " + i + " WHERE workPlanTypeID = " + workPlanTypeID[i]);
		        recordSet.executeSql("UPDATE WorkPlanType SET workPlanTypeName = '" + workPlanTypeName[i] + "', workPlanTypeColor = '" + workPlanTypeColor[i] +  "', available = '" + available[i] + "', displayOrder = " + i + " WHERE workPlanTypeID = " + workPlanTypeID[i]);
		    }
		}
	    for(int i = 0;i<workPlanIDs.length;i++)
	    {
	    	String sql = "";
	    	if("-1".equals(workPlanIDs[i]))
	    	{
	    		sql = "insert into overworkplan(id,workplanname,workplancolor,wavailable) values("+i+",'"+workplannames[i]+"','"+wcolors[i]+"',"+wavailables[i]+")";
	    	}
	    	else
	    	{
	    		sql = "UPDATE overworkplan set workplanname='"+workplannames[i]+"',workplancolor='"+wcolors[i]+"',wavailable="+wavailables[i]+" where id="+workPlanIDs[i];
	    	}
	    	if(!"".equals(sql))
	    		recordSet.executeSql(sql);
	    }
	    
	    SysMaintenanceLog.resetParameter();
	    SysMaintenanceLog.insSysLogInfo(user,0,"日程类型","日程类型设置","211","2",0,Util.getIpAddr(request));
	}
	
	response.sendRedirect("WorkPlanTypeSet.jsp");

%>

</HEAD>

<BODY>
</BODY>
	
</HTML>
