
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.general.GCONST" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.workflow.workflow.WorkflowVersion" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="wfAgentCondition" class="weaver.workflow.request.wfAgentCondition" scope="page" />
<%
 
//获取选中的年和月份有多少天
StringBuffer result = new StringBuffer("{");
BaseBean bean=new BaseBean();
User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
}else{
	try{
		int agentcount=0;
	   	String agentids="";
		String retustr="";
		String agetnzt="";
		//2012_53_31/12/2012_6/1/2013_2013-01-07
		int beagenterId = Util.getIntValue(request.getParameter("beagenterId"),0);
	    int agenterId = Util.getIntValue(request.getParameter("agenterId"),0);
	    String beginDate = Util.fromScreen(request.getParameter("beginDate"),user.getLanguage());
	    String beginTime = Util.fromScreen(request.getParameter("beginTime"),user.getLanguage());
	    String endDate = Util.fromScreen(request.getParameter("endDate"),user.getLanguage());
	    String endTime = Util.fromScreen(request.getParameter("endTime"),user.getLanguage());
	  
	    int usertype = Util.getIntValue(request.getParameter("usertype"), 0);
	    int isPendThing=Util.getIntValue(request.getParameter("isPendThing"),0);
	    int agentid=Util.getIntValue(request.getParameter("agentid"),0);
	    String workflowid = Util.null2String(request.getParameter("workflowid"));
	    String agentrange =Util.null2String(request.getParameter("agentrange"));
	    String rangetype =Util.null2String(request.getParameter("rangetype"));
	    //if(agentid>0){
	    //	  agetnzt=wfAgentCondition.getAgentType(""+agentid);
	   // }
	    
	 //  if(!agetnzt.equals("3")){
		   
		   
	  
	    if(beginDate.equals("")){
	    	beginDate="1900-01-01";
	    }
	    if(beginTime.equals("")){
	    	beginTime="00:00";
	    }
	    if(endDate.equals("")){
	    	endDate="2099-12-31";
	    }
	    if(endTime.equals("")){
	    	endTime="23:59";
	    }
	    
	    int isCreateAgenter = 0;
	    if(Util.getIntValue(request.getParameter("isCreateAgenter"),0) == 1){
	      isCreateAgenter = 1;
	    }
	    int isProxyDeal = 0;
	    if(Util.getIntValue(request.getParameter("isProxyDeal"),0) == 1){
	    	isProxyDeal = 1;
	    }
	 
	    boolean flag1 = false;
	    String sql="";
	    String workflowids="";
	    StringBuffer sb = new StringBuffer();
		
	    //如果流程ID不为空，则流程范围类型为空【标示识从编辑页面过来】
	    if(!workflowid.equals("")&&agentrange.equals("")&&rangetype.equals("")){
	    	//workflowids=workflowid+",";
			sb.append(workflowid+",");
	    }

	    //80改造流程代理逻辑
	    if(agentrange.equals("0"))
	    {
	    	flag1 = true;
	    	if (usertype == 0) {
				sql = "select * from workflow_base where isvalid=1 order by workflowname ";
				rs.executeSql(sql);
				while (rs.next()) {
	                //workflowids+=Util.getIntValue(rs.getString("id"))+",";
					sb.append(Util.getIntValue(rs.getString("id"))+",");
				}
			} else if (usertype == 1) {
				//客户用户只能代理“外部访问者支持”类型的流程
				sql = "select id from workflow_base where isvalid=1 and workflowtype=29 order by workflowname";
				rs.executeSql(sql);
				while (rs.next()) {
	                //workflowids+=Util.getIntValue(rs.getString("id"))+",";
				 sb.append(Util.getIntValue(rs.getString("id"))+",");
				}
			}
	      	sql = "";
			workflowids = sb.toString();
	      	if(workflowids.length() > 0){
	      	  workflowids = workflowids.substring(0,workflowids.length() -1);
	      	}
		 }else if(agentrange.equals("1"))
		 {
		    	if(!rangetype.equals(""))
		    	{
		    		if (!rangetype.startsWith(",")) {
		    			workflowids = rangetype;
		    		}
		    	}
		    	flag1 = true;
		 }else{
			 workflowids=workflowid+",";
		 }
		  
 
	    String versionsIds =  WorkflowVersion.getAllVersionStringByWFIDs(workflowids);
	    String overlapAgent=wfAgentCondition.getIsAgent(""+agentid,""+beagenterId,"",beginDate,beginTime,endDate,endTime,versionsIds,""+isCreateAgenter,""+isProxyDeal,""+isPendThing);
		if(!overlapAgent.equals("")){
	    	String str[]=overlapAgent.split("_");
	    	agentcount=Util.getIntValue(""+str[1],0);
	    	agentids=""+str[0];;
	    }
	  // }  
	    session.setAttribute(user.getUID()+"_"+beagenterId+"_"+agenterId,agentids);
	    int _cnt=0;
	    result.append("\"data"+_cnt+"\":{");
	    result.append("\"overlapAgent\":"+JSONObject.quote(Util.null2String(agentcount))+",");
	    result.append("\"agentids\":"+JSONObject.quote(Util.null2String(agentids))+",");
		result.append("\"dbFieldEnd\":0},");
        result.append("\"done\":{\"success\":\"success\",\"info\":\"\"}");
	}catch(Exception e){
		result.append("\"done\":{\"success\":\"failed\",\"info\":\""+e.getMessage()+"\"}");
	}
	
}
result.append("}");

 //System.out.println(result.toString());
%><%=result.toString() %>
