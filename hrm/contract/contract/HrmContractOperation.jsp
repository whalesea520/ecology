<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="srwf" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="ctci" class="weaver.hrm.contract.ContractTypeComInfo" scope="page"/>
<%
   String id = Util.null2String(request.getParameter("id")); 
   String sql = "select * from HrmContract where id ="+id;
   rs.executeSql(sql);
   rs.next();
	String operation = Util.null2String(request.getParameter("operation"));   
	if(operation.equals("delete")){
	String contractname = Util.null2String(rs.getString("contractname"));
		rs.executeSql("delete from HrmContract where id ="+id);
		SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(contractname);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmContract_Delete");
      SysMaintenanceLog.setOperateItem("105");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

		response.sendRedirect("/hrm/contract/contract/HrmContract.jsp");
		return;
	}
   Calendar todaycal = Calendar.getInstance ();
   String today = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;
                   
   
  String accepter="";
  String title="";
  String remark="";
  String submiter="";
  String subject="";

      String typeid = Util.null2String(rs.getString("contracttypeid"));
      String contractenddate = Util.null2String(rs.getString("contractenddate"));
      String proenddate = Util.null2String(rs.getString("proenddate"));
      String contractman = Util.null2String(rs.getString("contractman"));
      String infoman = ctci.getRemindMan(typeid);
      int remindaheaddate = ctci.getRemindAheadDate(typeid);
      
      if(Util.dayDiff(today,contractenddate) == remindaheaddate){        
        subject=SystemEnv.getHtmlLabelName(15783,user.getLanguage());
        subject+=":"+ResourceComInfo.getResourcename(contractman);
        infoman +=",";
        ArrayList al = Util.TokenizerString(infoman,",");
        for(int i = 0; i<al.size();i++){
          accepter = (String)al.get(i);
          title = SystemEnv.getHtmlLabelName(15783,user.getLanguage());
          title += ":System Remind ";
          title += "-"+ResourceComInfo.getResourcename(contractman);
          title += "-"+today;
          remark="<a href=/hrm/contract/contract/HrmContractEdit.jsp?id="+id+">"+Util.fromScreen2(subject,7)+"</a>";
          submiter="0";
          srwf.setPrjSysRemind(title,0,Util.getIntValue(submiter),accepter,remark);
        }
      }

      if(ctci.isHireContract(Util.getIntValue(typeid))){      
        if(Util.dayDiff(today,proenddate) == remindaheaddate){          
        
          subject=SystemEnv.getHtmlLabelName(15784,user.getLanguage());
          subject+=":"+ResourceComInfo.getResourcename(contractman);
          infoman +=",";
          ArrayList al = Util.TokenizerString(infoman,",");
          for(int i = 0; i<al.size();i++){
            accepter = (String)al.get(i);
            title = SystemEnv.getHtmlLabelName(15784,user.getLanguage());
            title += ":System Remind ";
            title += "-"+ResourceComInfo.getResourcename(contractman);
            title += "-"+today;
            remark="<a href=/hrm/contract/contract/HrmContractEdit.jsp?id="+id+">"+Util.fromScreen2(subject,7)+"</a>";
            submiter="0";
            srwf.setPrjSysRemind(title,0,Util.getIntValue(submiter),accepter,remark);
          }
        }  
      }
      response.sendRedirect("/hrm/contract/contract/HrmContract.jsp");

%>
