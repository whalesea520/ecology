<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
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

int isplan = Util.getIntValue(request.getParameter("isplan"),0);

if(operation.equals("info")){
   String careerinviteid = Util.null2String(request.getParameter("careerinviteid"));
   String id = hdc.getCareerPlanByInvite(careerinviteid);
   String jobtitle = hdc.getJobTitleByInvite(careerinviteid);
   String sql = "select name,assessor,informdate from HrmCareerInviteStep where inviteid = "+careerinviteid;
   RecordSet.executeSql(sql);
   while(RecordSet.next()){
    String stepname = Util.null2String(RecordSet.getString("name"));
    String assessor = Util.null2String(RecordSet.getString("assessor"));
    String informdate = Util.null2String(RecordSet.getString("informdate"));
    if(today.equals(informdate)){
	          String accepter="";
              String title="";
              String remark="";
              String submiter="";
              String subject="";

        subject=SystemEnv.getHtmlLabelName(15727,user.getLanguage());
        subject+=":"+stepname;
        accepter = assessor;
        title = SystemEnv.getHtmlLabelName(15727,user.getLanguage());
        title += ":"+stepname;
        title += ":System Remind ";
        title += "-"+today;
        remark="<a href=/hrm/career/HrmCareerApplyList.jsp?jobtitle="+jobtitle+"&id="+id+">"+Util.fromScreen2(subject,7)+"</a>";
        submiter=""+user.getUID();
        srwf.setPrjSysRemind(title,0,Util.getIntValue(submiter),accepter,remark);
     }
   }
   response.sendRedirect("HrmCareerInvite.jsp?");
}

if(operation.equals("addcareerinvite")||operation.equals("editcareerinvite")){		
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
	String planid = Util.fromScreen(request.getParameter("plan"),user.getLanguage());	

	String isweb = Util.fromScreen(request.getParameter("isweb"),user.getLanguage());
	int rownum = Util.getIntValue(request.getParameter("rownum"),0); 	
        
	String createrid = ""+user.getUID();
	String createdate = today ;
	String lastmodid = ""+user.getUID();
	String lastmoddate = today ;


     if(operation.equals("addcareerinvite")){
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
		try{
			SysMaintenanceLog.resetParameter();
			SysMaintenanceLog.setRelatedId(id);
			//SysMaintenanceLog.setRelatedName(" "); TD25213
			SysMaintenanceLog.setRelatedName(Util.add0(Util.getIntValue(id+""),12));
			SysMaintenanceLog.setOperateItem("58");
			SysMaintenanceLog.setOperateUserid(user.getUID());
			SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
			SysMaintenanceLog.setOperateType("1");
			SysMaintenanceLog.setOperateDesc("HrmCareerInvite_Insert,");
			SysMaintenanceLog.setSysLogInfo();
		}catch(Exception e){
		
		}
        CareerInviteComInfo.removeCareerInviteCache();
            
        String jobtitle = hdc.getJobTitleByInvite(""+id);
       
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
                para = ""+id             + separator + stepname + separator + stepstartdate   + separator +
                       stependdate       + separator + assessor + separator + assessstartdate + separator +
                       assessenddate     + separator + informdate;	        
                RecordSet.executeProc("HrmCareerInviteStep_Insert",para);
              }
                  
            }
        if(isplan==1){
           response.sendRedirect("/hrm/career/careerplan/HrmCareerPlanEdit.jsp?id="+planid); 
        }else if(isplan==2){
            response.sendRedirect("/hrm/career/careerplan/HrmCareerPlanEditDo.jsp?id="+planid); 
        }else{
            response.sendRedirect("HrmCareerInvite.jsp?");
        }
     } //end 
    else if(operation.equals("editcareerinvite")){
        String careerinviteid = Util.null2String(request.getParameter("careerinviteid"));

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
			//SysMaintenanceLog.setRelatedName(" ");  TD25213
			SysMaintenanceLog.setRelatedName(Util.add0(Util.getIntValue(careerinviteid),12));
			SysMaintenanceLog.setOperateType("2");
			SysMaintenanceLog.setOperateDesc("HrmCareerInvite_Update,");
			SysMaintenanceLog.setOperateItem("58");
			SysMaintenanceLog.setOperateUserid(user.getUID());
			SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
			SysMaintenanceLog.setSysLogInfo();
		}catch(Exception e){
			
		}
        CareerInviteComInfo.removeCareerInviteCache();
        
        Hashtable ht = new Hashtable();
        ht = HrmCareerApplyComInfo.getApplyStage(careerinviteid);	
        
            String sql = "delete from HrmCareerInviteStep where inviteid = "+careerinviteid;
            RecordSet.executeSql(sql);    
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
                para = ""+careerinviteid + separator + stepname + separator + stepstartdate   + separator +
                       stependdate       + separator + assessor + separator + assessstartdate + separator +
                       assessenddate     + separator + informdate;
                
                RecordSet.executeProc("HrmCareerInviteStep_Insert",para);
              }
            }
            HrmCareerApplyComInfo.updateNowStep(ht,careerinviteid);
            
        if(isplan==1){
           response.sendRedirect("/hrm/career/careerplan/HrmCareerPlanEdit.jsp?id="+planid); 
        }else if(isplan==2){
            response.sendRedirect("/hrm/career/careerplan/HrmCareerPlanEditDo.jsp?id="+planid); 
        }else{
            response.sendRedirect("HrmCareerInvite.jsp?");
        }
     }///end if 
}//end if 
 else if(operation.equals("deletecareerinvite")){
  	int careerinviteid = Util.getIntValue(request.getParameter("careerinviteid"));
    String planid = Util.fromScreen(request.getParameter("plan"),user.getLanguage());

	String para = ""+careerinviteid;
	RecordSet.executeSql("select careername from HrmCareerInvite where id=" + careerinviteid);
	RecordSet.next();
	String careername = RecordSet.getString(1);
	
	RecordSet.executeProc("HrmCareerInvite_Delete",para);
	RecordSet.next();
	try{
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(careerinviteid);
	  //SysMaintenanceLog.setRelatedName(" ");  TD25213
	  SysMaintenanceLog.setRelatedName(Util.add0(Util.getIntValue(careerinviteid + ""),12));
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmCareerInvite_Delete,");
      SysMaintenanceLog.setOperateItem("58");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
	}catch(Exception e){
	
	}
	CareerInviteComInfo.removeCareerInviteCache();

	if(isplan==1){
       response.sendRedirect("/hrm/career/careerplan/HrmCareerPlanEdit.jsp?id="+planid); 
    }else if(isplan==2){
        response.sendRedirect("/hrm/career/careerplan/HrmCareerPlanEditDo.jsp?id="+planid); 
    }else{
        response.sendRedirect("HrmCareerInvite.jsp?");
    }  
 }
%>