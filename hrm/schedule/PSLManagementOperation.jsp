<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="HrmPaidSickManagement" class="weaver.hrm.schedule.HrmPaidSickManagement" scope="page" />

<%
String operation = Util.null2String(request.getParameter("operation"));
String cmd = Util.null2String(request.getParameter("cmd"));
String subcompanyid = Util.null2String(request.getParameter("subCompanyId"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String PSLyear = Util.null2String(request.getParameter("PSLyear"));
String leavetype = Util.null2String(request.getParameter("leavetype"));
String sql="";

if(operation.equals("edit")){
   if(!HrmUserVarify.checkUserRight("PaidSickLeave:All", user)){
      response.sendRedirect("/notice/noright.jsp");
      return;
   }
      
   String resourceid[] = request.getParameterValues("resourceid");
   String PSLdays[] = request.getParameterValues("PSLdays");
  
   if(resourceid!=null){
     for(int i=0;i<resourceid.length;i++){
         String tempresourceid = resourceid[i];
         String tempPSLdays = PSLdays[i];
         tempPSLdays = "" + Util.round(Util.getFloatValue(tempPSLdays,0)+"",2);
         sql = "delete from HrmPSLManagement where resourceid = " + tempresourceid + " and PSLyear = " + PSLyear+" and leavetype="+leavetype;
         RecordSet.executeSql(sql);
         sql = "insert into HrmPSLManagement (resourceid,PSLyear,PSLdays,status,leavetype) values ('"+tempresourceid+"','"+PSLyear+"','"+tempPSLdays+"',1,"+leavetype+")";
         RecordSet.executeSql(sql);
     }
   }
   response.sendRedirect("PSLManagementView.jsp?subCompanyId="+subcompanyid+"&departmentid="+departmentid+"&cmd="+cmd+"&leavetype="+leavetype);
}

if(operation.equals("batchprocess")){
   if(!HrmUserVarify.checkUserRight("PaidSickLeave:All", user)){
      response.sendRedirect("/notice/noright.jsp");
      return;
   }
   Calendar today = Calendar.getInstance();
   //String currentdate= Util.add0(today.get(Calendar.YEAR),4) +"-"+ Util.add0(today.get(Calendar.MONTH)+1,2) +"-"+ Util.add0(today.get(Calendar.DAY_OF_MONTH),2);   
   String currentdate = PSLyear+"-"+ Util.add0(today.get(Calendar.MONTH)+1,2) +"-"+ Util.add0(today.get(Calendar.DAY_OF_MONTH),2);
   
   HashMap userStartDate = new HashMap();//所有用户的合同开始日期
   HashMap userSubCompanyId = new HashMap();
   HashMap userDepartmentId = new HashMap();
   RecordSet.executeSql("select * from hrmresource");
   while(RecordSet.next()){
      userStartDate.put(RecordSet.getString("id"),Util.null2String(RecordSet.getString("startdate")));
      userSubCompanyId.put(RecordSet.getString("id"),Util.null2String(RecordSet.getString("subcompanyid1")));
      userDepartmentId.put(RecordSet.getString("id"),Util.null2String(RecordSet.getString("departmentid")));
   }
   
   String resourceid[] = request.getParameterValues("resourceid");
   if(resourceid!=null){
	   String result = "";
		if(cmd.length() != 0){
			result = HrmPaidSickManagement.getBatchProcess(subcompanyid,departmentid,leavetype);
		   if(result.equals("-1")){
			  response.sendRedirect("PSLManagementEdit.jsp?message=12&subCompanyId="+subcompanyid+"&departmentid="+departmentid+"&leavetype="+leavetype);
		   }
		   
		   //人员卡片上面的工作信息，可以录入合同开始日期，合同开始日期则为到职日期,年假批量处理，根据工龄来初始化
		   HashMap BatchProcess = new HashMap();//批量处理设置，工龄 + 年假天数
		   RecordSet.executeSql("select * from HrmPSLBatchProcess where subcompanyid = " + result + " and leavetype="+leavetype+" order by workingage desc");
		   int workingage[] = new int[RecordSet.getCounts()];//工龄
		   int j = 0;
		   while(RecordSet.next()){
			  BatchProcess.put(RecordSet.getFloat("workingage")+"",RecordSet.getString("PSLdays"));
			  workingage[j++] = (int) RecordSet.getFloat("workingage");     
		   }
		   
			 for(int i=0;i<resourceid.length;i++){
			   String startdate = userStartDate.get(resourceid[i]).toString();
			   if(startdate.equals("")) startdate = currentdate;
			   int days = TimeUtil.dateInterval(startdate,currentdate);
			   int _workingage = days/365;
			   float PSLdays = HrmPaidSickManagement.getPaidSickDays(BatchProcess,workingage,_workingage);

			   PSLdays = Util.getFloatValue(Util.round(""+PSLdays,2));
			   String tempresourceid = resourceid[i];
			   sql = "delete from hrmPSLmanagement where resourceid = " + tempresourceid + " and PSLyear = " + PSLyear+" and leavetype="+leavetype;
			   RecordSet.executeSql(sql);
			   sql = "insert into hrmPSLmanagement (resourceid,PSLyear,PSLdays,status,leavetype) values ('"+tempresourceid+"','"+PSLyear+"','"+PSLdays+"',1,"+leavetype+")";
			   RecordSet.executeSql(sql);       
			 }
	   }/*else{
			for(int i=0;i<resourceid.length;i++){
				String startdate = userStartDate.get(resourceid[i]).toString();
			   if(startdate.equals("")) startdate = currentdate;
			   int days = TimeUtil.dateInterval(startdate,currentdate);
			   int _workingage = days/365;
			   String _subcompanyid = userSubCompanyId.get(resourceid[i]).toString();
			   String _departmentid = userDepartmentId.get(resourceid[i]).toString();
			   result = HrmPaidSickManagement.getBatchProcess(_subcompanyid,_departmentid);
			   if(result.equals("-1")){
				  response.sendRedirect("PSLManagementEdit.jsp?message=12&subCompanyId="+_subcompanyid+"&departmentid="+_departmentid);
			   }
			   //人员卡片上面的工作信息，可以录入合同开始日期，合同开始日期则为到职日期,年假批量处理，根据工龄来初始化
			   HashMap BatchProcess = new HashMap();//批量处理设置，工龄 + 年假天数
			   RecordSet.executeSql("select * from HrmPSLBatchProcess where subcompanyid = " + result + " order by workingage desc");
			   int workingage[] = new int[RecordSet.getCounts()];//工龄
			   int j = 0;
			   while(RecordSet.next()){
				  BatchProcess.put(RecordSet.getFloat("workingage")+"",RecordSet.getString("PSLdays"));
				  workingage[j++] = (int) RecordSet.getFloat("workingage");     
			   }
		   
			   float PSLdays = HrmPaidSickManagement.getPaidSickDays(BatchProcess,workingage,_workingage);
			   String tempresourceid = resourceid[i];
			   sql = "delete from hrmPSLmanagement where resourceid = " + tempresourceid + " and PSLyear = " + PSLyear;
			   RecordSet.executeSql(sql);
			   sql = "insert into hrmPSLmanagement (resourceid,PSLyear,PSLdays,status) values ('"+tempresourceid+"','"+PSLyear+"','"+PSLdays+"',1)";
			   RecordSet.executeSql(sql);  
			}
	   }*/
   }
   response.sendRedirect("PSLManagementView.jsp?subCompanyId="+subcompanyid+"&departmentid="+departmentid+"&cmd="+cmd+"&leavetype="+leavetype);
}

%>


