<%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.fna.budget.BudgetHandler"%>
<%@page import="weaver.general.TimeUtil"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.fna.general.FnaSynchronized"%><jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;

boolean canEdit = HrmUserVarify.checkUserRight("FnaSystemSetEdit:Edit",user);
if(!canEdit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String operation = Util.null2String(request.getParameter("operation"));

if(operation.equals("clearDirtyData")){
	String currentTimeString = TimeUtil.getCurrentTimeString();
	String[] currentTimeStringArray = currentTimeString.split(" ");
	String[] dayArray = currentTimeStringArray[0].split("-");
	String[] timeArray = currentTimeStringArray[1].split(":");
	
	if("oracle".equals(rs.getDBType())){
		rs.executeSql("create table bkCddFbi"+dayArray[0]+dayArray[1]+dayArray[2]+timeArray[0]+timeArray[1]+timeArray[2]+" as Select * from FnaBudgetInfo");
		rs.executeSql("create table bkCddFbid"+dayArray[0]+dayArray[1]+dayArray[2]+timeArray[0]+timeArray[1]+timeArray[2]+" as Select * from FnaBudgetInfoDetail");
	}else{
		rs.executeSql("select * into bkCddFbi"+dayArray[0]+dayArray[1]+dayArray[2]+timeArray[0]+timeArray[1]+timeArray[2]+" from FnaBudgetInfo");
		rs.executeSql("select * into bkCddFbid"+dayArray[0]+dayArray[1]+dayArray[2]+timeArray[0]+timeArray[1]+timeArray[2]+" from FnaBudgetInfoDetail");
	}
	
	String sql = "select DISTINCT a.budgetinfoid \n" +
		" from FnaBudgetInfoDetail a \n" +
		" where not EXISTS (select 1 from FnaBudgetInfo b where a.budgetinfoid = b.id)";
	rs.executeSql(sql);
	while(rs.next()){
		int delFnaBudgetInfoId = rs.getInt("budgetinfoid");
		BudgetHandler.deleteFnaBudgetInfoAndFnaBudgetInfoDetail(delFnaBudgetInfoId);
	}
	
	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(83323,user.getLanguage()))+"}");//处理成功!
	out.flush();
	return;
	
}else if(operation.equals("releaseSynData")){
	String lockGuids = Util.null2String(request.getParameter("lockGuids"));
	if(!"".equals(lockGuids)){
		String[] lockGuids_array = lockGuids.split(",");
		int lockGuids_array_len = lockGuids_array.length;
		for(int i=0;i<lockGuids_array_len;i++){
			String lockGuid = Util.null2String(lockGuids_array[i]).trim();
			if(!"".equals(lockGuid)){
				try{
					FnaSynchronized.releaseLock_by_lockGuid(lockGuid, user.getLanguage());
				}catch(Exception ex1){}
			}
		}
	}
	
	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(83323,user.getLanguage()))+"}");//处理成功!
	out.flush();
	return;
	
}
%>
