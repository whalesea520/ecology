
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="workPlanShare" class="weaver.WorkPlan.WorkPlanShare" scope="page" />
<jsp:useBean id="workPlanExchange" class="weaver.WorkPlan.WorkPlanExchange" scope="page"/>

<%
	String method = Util.null2String(request.getParameter("method"));
	String para = "";
	char sep = Util.getSeparator();
	
	String planID = Util.null2String(request.getParameter("planID"));
	
	if (method.equals("add")) 
	{
		String shareType = Util.null2String(request.getParameter("sharetype"));
		String shareId = Util.null2String(request.getParameter("relatedshareid"));
		String roleLevel = Util.null2String(request.getParameter("rolelevel"));
		String secLevel = ""+Util.getIntValue(request.getParameter("seclevel"), 0);
		String seclevelMax = ""+Util.getIntValue(request.getParameter("seclevelMax"), 255);
		String shareLevel = Util.null2String(request.getParameter("sharelevel"));
		String companyVirtual= Util.null2String(request.getParameter("companyVirtual")); //维度
		String userId = "0";
		String deptId = "0";
		String roleId = "0";
		String forAll = "0";
		String subCompanyID = "0";

		if (shareType.equals("1"))
		{
			userId = shareId;
			secLevel = "0";
			
			 String userIds[]  = Util.TokenizerString2(shareId,",");
			    if(userIds.length>0){
	                for(String uid : userIds){
					    String shareSql="insert into WorkPlanShare (workPlanId, shareType, userId, subCompanyID, deptId, roleId, forAll, roleLevel, securityLevel, shareLevel, securityLevelMax,fromuser)" +
						" values ('"+planID+"','"+shareType+"','"+uid+"','"+subCompanyID+"','"+deptId+"','"+roleId+"','"+forAll+"','"+roleLevel+"','"+secLevel+"','"+shareLevel+"','"+seclevelMax+"',"+user.getUID()+")";
					    rs.execute(shareSql);
	                }
			    }
		}
		else if (shareType.equals("2"))
		{
		    String deptIds[]  = Util.TokenizerString2(shareId,",");
		    if(deptIds.length>0){
                for(String did : deptIds){
				    String shareSql="insert into WorkPlanShare (workPlanId, shareType, userId, subCompanyID, deptId, roleId, forAll, roleLevel, securityLevel, shareLevel, securityLevelMax,fromuser)" +
					" values ('"+planID+"','"+shareType+"','"+userId+"','"+subCompanyID+"','"+did+"','"+roleId+"','"+forAll+"','"+roleLevel+"','"+secLevel+"','"+shareLevel+"','"+seclevelMax+"',"+user.getUID()+")";
				    rs.execute(shareSql);
                }
		    }
		}
		else if (shareType.equals("3"))
		{
		    roleId = shareId;
		    String shareSql="insert into WorkPlanShare (workPlanId, shareType, userId, subCompanyID, deptId, roleId, forAll, roleLevel, securityLevel, shareLevel, securityLevelMax,fromuser)" +
			" values ('"+planID+"','"+shareType+"','"+userId+"','"+subCompanyID+"','"+deptId+"','"+roleId+"','"+forAll+"','"+roleLevel+"','"+secLevel+"','"+shareLevel+"','"+seclevelMax+"',"+user.getUID()+")";
		    rs.execute(shareSql);
		}
		else if (shareType.equals("5"))
		{
		    String subCompanyIDs[]  = Util.TokenizerString2(shareId,",");
		    if(subCompanyIDs.length>0){
                for(String sid : subCompanyIDs){
		    String shareSql="insert into WorkPlanShare (workPlanId, shareType, userId, subCompanyID, deptId, roleId, forAll, roleLevel, securityLevel, shareLevel, securityLevelMax,fromuser)" +
			" values ('"+planID+"','"+shareType+"','"+userId+"','"+sid+"','"+deptId+"','"+roleId+"','"+forAll+"','"+roleLevel+"','"+secLevel+"','"+shareLevel+"','"+seclevelMax+"',"+user.getUID()+")";
		    rs.execute(shareSql);
                }
		    }
		}
		else if (shareType.equals("6"))
		{
		    secLevel = "0";
		    String shareSql="insert into WorkPlanShare (workPlanId, shareType, userId, subCompanyID, deptId, roleId, forAll, roleLevel, securityLevel, shareLevel, securityLevelMax,fromuser,companyVirtual)" +
			" values ('"+planID+"','"+shareType+"','"+userId+"','"+subCompanyID+"','"+deptId+"','"+roleId+"','"+forAll+"','"+roleLevel+"','"+secLevel+"','"+shareLevel+"','"+seclevelMax+"',"+user.getUID()+",'"+companyVirtual+"')";
			rs.execute(shareSql);
		}else if("8".equals(shareType)){
        	String jobid[]  = Util.TokenizerString2(Util.null2String(request.getParameter("jobid")),",");
            int joblevel = Util.getIntValue(request.getParameter("joblevel"), 0); 
            String joblevelvalue ="";
            if(joblevel==1){
            	joblevelvalue=Util.null2String(request.getParameter("sublevelids"));
            }else if(joblevel==2){
            	joblevelvalue=Util.null2String(request.getParameter("deplevelids"));
            }
            if(jobid.length>0){
                for(String jid : jobid){
                	String shareSql="insert into WorkPlanShare (workPlanId, shareType,jobtitleid,joblevel,joblevelvalue,shareLevel,fromuser)" +
            		" values ('"+planID+"','"+shareType+"','"+jid+"','"+joblevel+"','"+joblevelvalue+"','"+shareLevel+"',"+user.getUID()+")";
            	    rs.execute(shareSql);
                }
            }
        }else{
		    forAll = "1";
			String shareSql="insert into WorkPlanShare (workPlanId, shareType, userId, subCompanyID, deptId, roleId, forAll, roleLevel, securityLevel, shareLevel, securityLevelMax,fromuser)" +
			" values ('"+planID+"','"+shareType+"','"+userId+"','"+subCompanyID+"','"+deptId+"','"+roleId+"','"+forAll+"','"+roleLevel+"','"+secLevel+"','"+shareLevel+"','"+seclevelMax+"',"+user.getUID()+")";
			rs.execute(shareSql);
		}
		//rs.executeProc("WorkPlanShare_Ins", para);
		workPlanShare.changeShare(String.valueOf(user.getUID()),planID)	;
        workPlanShare.setShareDetail(planID);
        
        workPlanExchange.exchangeAdd(Integer.parseInt(planID), String.valueOf(user.getUID()), user.getLogintype());  //标识日程已被编辑
        
	    //response.sendRedirect("WorkPlanShare.jsp?planID=" + planID);
		%>
	<script type="text/javascript">
		var parentWin = parent.getParentWindow(window);
		parentWin.closeDlgARfsh();
	</script>
	
	<%
	 return;
	}

	if (method.equals("delete")) 
	{
		String delId = Util.null2String(request.getParameter("delid"));
		if(!"".equals(delId)){
			rs.executeSql("select DISTINCT fromuser from WorkPlanShare WHERE workplanid="+planID+" and id in (" + delId +")");
			while(rs.next()){
				workPlanShare.changeShare(rs.getString("fromuser"),planID);
			}
			rs.executeSql("DELETE WorkPlanShare WHERE workplanid="+planID+" and id in (" + delId +")");
			
			workPlanShare.setShareDetail(planID);
			
			workPlanExchange.exchangeAdd(Integer.parseInt(planID), String.valueOf(user.getUID()), user.getLogintype());  //标识日程已被编辑
			
		}
		
		//response.sendRedirect("WorkPlanShare.jsp?planID=" + planID);
		return;
	}
%>