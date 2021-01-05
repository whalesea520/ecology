<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-06-17 [E7 to E8] -->
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CareerInviteComInfo" class="weaver.hrm.career.CareerInviteComInfo" scope="page"/>
<jsp:useBean id="hdc" class="weaver.hrm.tools.HrmDateCheck" scope="page"/>
<jsp:useBean id="HrmCareerApplyComInfo" class="weaver.hrm.career.HrmCareerApplyComInfo" scope="page"/>
<jsp:useBean id="srwf" class="weaver.system.SysRemindWorkflow" scope="page" />
<%
  Calendar todaycal = Calendar.getInstance ();
  String today = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;

String operation = Util.null2String(request.getParameter("operation"));

char separator = Util.getSeparator() ;

String careerinviteid = Util.null2String(request.getParameter("inviteId"));
String cmd = Util.null2String(request.getParameter("cmd"));

if(operation.equals("add")||operation.equals("next")||operation.equals("edit")){
	String careername = Util.fromScreen(request.getParameter("careername"),user.getLanguage());
	String careerpeople = Util.null2String(request.getParameter("careerpeople"));
	String careerage = Util.fromScreen(request.getParameter("careerage"),user.getLanguage());
	String careersex = Util.null2String(request.getParameter("careersex"));

	String careeredu = Util.null2String(request.getParameter("careeredu"));
	String careermode = Util.fromScreen(request.getParameter("careermode"),user.getLanguage());
	String careeraddr = Util.fromScreen(request.getParameter("careeraddr"),user.getLanguage());
	String careerclass = Util.fromScreen(request.getParameter("careerclass"),user.getLanguage());

	String careerdesc = Util.fromScreen(request.getParameter("careerdesc"),user.getLanguage());
	String careerrequest = Util.fromScreen(request.getParameter("careerrequest"),user.getLanguage());
	String careerremark = Util.fromScreen(request.getParameter("careerremark"),user.getLanguage());
	String planid = Util.fromScreen(request.getParameter("careerplan"),user.getLanguage());	

	String isweb = Util.fromScreen(request.getParameter("isweb"),user.getLanguage());
        
	String createrid = ""+user.getUID();
	String createdate = today ;
	String lastmodid = ""+user.getUID();
	String lastmoddate = today ;

     if(operation.equals("add") || operation.equals("next")){
        String para = "";
        
        para  = careername;
        para += separator+careerpeople;
        para += separator+careerage;
        para += separator+careersex;

        para += separator+careeredu;
        para += separator+careermode;
        para += separator+careeraddr;
        para += separator+careerclass;

        para += separator+careerdesc;
        para += separator+careerrequest;
        para += separator+careerremark;
        para += separator+createrid;

        para += separator+createdate;
        para += separator+planid;
        para += separator+isweb;
        
        RecordSet.executeProc("HrmCareerInvite_Insert",para);
        RecordSet.next() ;
        int	id = RecordSet.getInt(1);
		careerinviteid = String.valueOf(id);
		try{
			SysMaintenanceLog.resetParameter();
			SysMaintenanceLog.setRelatedId(id);
			SysMaintenanceLog.setRelatedName(Util.add0(Util.getIntValue(id+""),12));
			SysMaintenanceLog.setOperateItem("58");
			SysMaintenanceLog.setOperateUserid(user.getUID());
			SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
			SysMaintenanceLog.setOperateType("1");
			SysMaintenanceLog.setOperateDesc("HrmCareerInvite_Insert,");
			SysMaintenanceLog.setSysLogInfo();
		}catch(Exception e){}
    }else if(operation.equals("edit")){

        String para = "";
        
        para  = careerinviteid;
        para += separator+careername;
        para += separator+careerpeople;
        para += separator+careerage;
        para += separator+careersex;
        para += separator+careeredu;
        para += separator+careermode;
        para += separator+careeraddr;
        para += separator+careerclass;
        para += separator+careerdesc;
        para += separator+careerrequest;
        para += separator+careerremark;
        para += separator+lastmodid;
        para += separator+lastmoddate;
        para += separator+planid;
        para += separator+isweb;
        
        RecordSet.executeProc("HrmCareerInvite_Update",para);
        RecordSet.next();
		try{
			SysMaintenanceLog.resetParameter();
			SysMaintenanceLog.setRelatedId(Util.getIntValue(careerinviteid));
			SysMaintenanceLog.setRelatedName(Util.add0(Util.getIntValue(careerinviteid),12));
			SysMaintenanceLog.setOperateType("2");
			SysMaintenanceLog.setOperateDesc("HrmCareerInvite_Update,");
			SysMaintenanceLog.setOperateItem("58");
			SysMaintenanceLog.setOperateUserid(user.getUID());
			SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
			SysMaintenanceLog.setSysLogInfo();
		}catch(Exception e){}
    }
	CareerInviteComInfo.removeCareerInviteCache();
	response.sendRedirect("/hrm/career/inviteinfo/content.jsp?id="+careerinviteid+"&isclose="+(operation.equals("next") ? 2 : 1)+"&cmd="+cmd+"&planid="+planid); 
}else if(operation.equals("addinvite")){
	String planid = Util.fromScreen(request.getParameter("planid"),user.getLanguage());
	String ids = Util.fromScreen(request.getParameter("ids"),user.getLanguage());
	if(ids.length() > 0){
		String _sql = "update HrmCareerInvite set careerplanid = "+planid+" where id in ("+ids+")";
		rs.executeSql(_sql);
	}
	response.sendRedirect("list.jsp?isdialog=1&cmd=notchangeplan&planid="+planid);
}else if(operation.equals("step")){
	Hashtable ht = new Hashtable();
	ht = HrmCareerApplyComInfo.getApplyStage(careerinviteid);
	RecordSet.executeSql("delete from HrmCareerInviteStep where inviteid = "+careerinviteid);
    
	int rownum = Util.getIntValue(request.getParameter("rownum"),0); 
	for(int i = 0;i<rownum;i++){
		String stepname = Util.fromScreen(request.getParameter("stepname_"+i),user.getLanguage()) ; 
		String stepstartdate = Util.fromScreen(request.getParameter("stepstartdate_"+i),user.getLanguage()) ; 
		String stependdate = Util.fromScreen(request.getParameter("stependdate_"+i),user.getLanguage()) ;           
		String assessor = Util.fromScreen(request.getParameter("assessor_"+i),user.getLanguage()) ;           
		String assessstartdate = Util.fromScreen(request.getParameter("assessstartdate_"+i),user.getLanguage()) ;           
		String assessenddate = Util.fromScreen(request.getParameter("assessenddate_"+i),user.getLanguage()) ;           
		String informdate = Util.fromScreen(request.getParameter("informdate_"+i),user.getLanguage()) ;           
	  
		String info = stepname+stepstartdate+stependdate+assessor+assessstartdate+assessenddate+informdate;
	  
		if(!info.trim().equals("")){
			String para = ""+careerinviteid + separator + stepname + separator + stepstartdate   + separator +
				stependdate       + separator + assessor + separator + assessstartdate + separator +
				assessenddate     + separator + informdate;
			RecordSet.executeProc("HrmCareerInviteStep_Insert",para);
		}
	}
	HrmCareerApplyComInfo.updateNowStep(ht,careerinviteid);
	response.sendRedirect("InviteSchedule.jsp?method="+Util.null2String(request.getParameter("method"))+"&isdialog=1&inviteid="+careerinviteid);
}else if(operation.equals("delete")){
	RecordSet.executeProc("HrmCareerInvite_Delete",careerinviteid);
	RecordSet.next();
	try{
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(careerinviteid));
	  SysMaintenanceLog.setRelatedName(Util.add0(Util.getIntValue(careerinviteid),12));
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmCareerInvite_Delete,");
      SysMaintenanceLog.setOperateItem("58");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
	}catch(Exception e){}
	CareerInviteComInfo.removeCareerInviteCache();
	response.sendRedirect("/hrm/career/inviteinfo/content.jsp?isclose=1&cmd="+cmd+"&planid="+Util.null2String(request.getParameter("planid"))); 
 }
%>