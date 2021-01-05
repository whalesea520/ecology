
<%@page import="weaver.proj.Maint.ProjectInfoComInfo"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.workflow.report.RequestDeleteLog"%>
<%@page import="weaver.hrm.attendance.manager.HrmAttVacationManager"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/docs/common.jsp" %>
<%@ page import="java.util.*,java.net.*" %>
<%@ page import="weaver.cpt.util.CptWfUtil" %>
<%@ page import="weaver.workflow.request.RequestDeleteUtils" %>

<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/>
<%--------------xwj for td2831 on 20050921 begin-----%>
<jsp:useBean id="DocExtUtil" class="weaver.docs.docs.DocExtUtil" scope="page" />
<jsp:useBean id="RecordSetDelRq" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetDelDoc" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetDelCheck" class="weaver.conn.RecordSet" scope="page" />
<%--------------xwj for td2831 on 20050921 end-----%>
<jsp:useBean id="wflm" class="weaver.system.SysWFLMonitor" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="prjComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="CoworkShareManager" class="weaver.cowork.CoworkShareManager" scope="page" />
<jsp:useBean id="monitor" class="weaver.workflow.monitor.Monitor" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<%
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String deletedocids[] = request.getParameterValues("deletedocid");

if(operation.equals("deletedoc")){
	if(!HrmUserVarify.checkUserRight("DocEdit:Delete",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
	String deletedocidstr = "" ;
    if( deletedocids != null ) {
        for(int i=0 ; i<deletedocids.length; i++ ) {
            if(deletedocidstr.equals("")) deletedocidstr = deletedocids[i] ;
            else deletedocidstr += "," + deletedocids[i] ;
        }

        if( !deletedocidstr.equals("") ) {

            RecordSet.executeSql(" delete DocDetail where id in ( " + deletedocidstr + " ) " ) ;
            RecordSet.executeSql(" delete DocImageFile where docid in ( " + deletedocidstr + " ) " ) ;
            RecordSet.executeSql(" delete DocShare where docid in ( " + deletedocidstr + " ) " ) ;
            RecordSet.executeSql(" delete ShareinnerDoc where sourceid in ( " + deletedocidstr + " ) " ) ;
            RecordSet.executeSql(" delete ShareouterDoc where sourceid in ( " + deletedocidstr + " ) " ) ;
        }

        for(int i=0 ; i<deletedocids.length; i++ ) {
            DocComInfo.deleteDocInfoCache(deletedocids[i]);
        }
    }
  	
 	response.sendRedirect("docs/DocMonitor.jsp");
}

if(operation.equals("deleteworkflow")){
	
    /*这里记录下所有需要回传回去的查询参数值 End*/
    String paraStr = "fromself=1";
    String workflowid_tmp = Util.null2String(request.getParameter("workflowid"));
    String nodetype_tmp = Util.null2String(request.getParameter("nodetype"));
    String fromdate_tmp = Util.null2String(request.getParameter("fromdate"));
    String todate_tmp = Util.null2String(request.getParameter("todate"));
    String creatertype_tmp = Util.null2String(request.getParameter("creatertype"));
    String createrid_tmp = Util.null2String(request.getParameter("createrid"));
    String requestlevel_tmp = Util.null2String(request.getParameter("requestlevel"));
    String requestname_tmp = Util.null2String(request.getParameter("requestname"));
    String requestid_tmp1 = Util.null2String(request.getParameter("requestid"));
    paraStr += "&workflowid="+URLEncoder.encode(workflowid_tmp)+"&nodetype="+URLEncoder.encode(nodetype_tmp);
    paraStr += "&fromdate="+URLEncoder.encode(fromdate_tmp)+"&todate="+URLEncoder.encode(todate_tmp);
    paraStr += "&creatertype="+URLEncoder.encode(creatertype_tmp)+"&createrid="+URLEncoder.encode(createrid_tmp);
    paraStr += "&requestlevel="+URLEncoder.encode(requestlevel_tmp)+"&requestname="+URLEncoder.encode(requestname_tmp);
    paraStr += "&requestid="+URLEncoder.encode(requestid_tmp1);
    /*这里记录下所有需要回传回去的查询参数值 End*/

    String deleteworkflowidstr=Util.null2String(request.getParameter("multiRequestIds"));
	
    RequestDeleteUtils rdu = new RequestDeleteUtils();
	rdu.executeMonitorDelete(deleteworkflowidstr,user,request.getRemoteAddr());
	
    out.println(paraStr);
}
 
//2004-7-12 modify by Evan:增加客户删除功能
if(operation.equals("deletecrm")){
	if(!HrmUserVarify.checkUserRight("EditCustomer:Delete",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
	String deletecrmid = Util.null2String(request.getParameter("deletecrmid"));
	
	ArrayList deletecrmids = Util.TokenizerString(deletecrmid,",");
	String deletecrmidstr = "" ;
    if( deletecrmids != null ) {
        for(int i=0 ; i<deletecrmids.size(); i++ ) {
            if(deletecrmidstr.equals("")) deletecrmidstr = (String)deletecrmids.get(i) ;
            else deletecrmidstr += "," + (String)deletecrmids.get(i) ;
        }
        if( !deletecrmidstr.equals("") ) {

           RecordSet.executeSql("update CRM_CustomerInfo set deleted='1' where id in( "+deletecrmidstr+")");
		   RecordSet.executeSql("delete from CRM_Contract where crmId in( "+deletecrmidstr+")");
        }
        for(int i=0 ; i<deletecrmids.size(); i++ ) {
            String Tcrmid=(String)deletecrmids.get(i);
            CustomerInfoComInfo.deleteCustomerInfoCache(Tcrmid);
            SysMaintenanceLog.resetParameter();
			SysMaintenanceLog.setRelatedId(Util.getIntValue(Tcrmid));
			SysMaintenanceLog.setRelatedName(CustomerInfoComInfo.getCustomerInfoname(Tcrmid));
			SysMaintenanceLog.setOperateType("3");
			SysMaintenanceLog.setOperateDesc("update CRM_CustomerInfo set deleted='1' where id ="+Tcrmid);
			SysMaintenanceLog.setOperateItem("99");
			SysMaintenanceLog.setOperateUserid(user.getUID());
			SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
			SysMaintenanceLog.setSysLogInfo();
        }
    }

 	response.sendRedirect("crm/CustomerMonitor.jsp");
}

//2006-11-29 modify by yshxu:增加协作监控删除功能
if(operation.equals("deletecowork")){
	if(!HrmUserVarify.checkUserRight("collaborationmanager:edit",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
	String deletecoworkid = Util.null2String(request.getParameter("deletecoworkid"));
    
	ArrayList deletecoworkids = Util.TokenizerString(deletecoworkid,",");
	String deletecoworkidstr = "" ;
    if( deletecoworkids != null ) {
        for(int i=0 ; i<deletecoworkids.size(); i++ ) {
        	String tempcoworkid = (String)deletecoworkids.get(i);
            RecordSet.executeSql("select name from cowork_items where id="+tempcoworkid);
			PoppupRemindInfoUtil.deletePoppupRemindInfo(Util.getIntValue(tempcoworkid),9);
		
            RecordSet.next();
			String tempcoworkname = RecordSet.getString("name");
			
			SysMaintenanceLog.resetParameter();
			SysMaintenanceLog.setRelatedId(Util.getIntValue(tempcoworkid));
			SysMaintenanceLog.setRelatedName(tempcoworkname);
			SysMaintenanceLog.setOperateType("3");
			SysMaintenanceLog.setOperateDesc("delete from cowork_items where id="+tempcoworkid+";delete from cowork_discuss where coworkid="+tempcoworkid);
			SysMaintenanceLog.setOperateItem("90");
			SysMaintenanceLog.setOperateUserid(user.getUID());
			SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
			SysMaintenanceLog.setSysLogInfo();
            
            if(deletecoworkidstr.equals("")) {
            	deletecoworkidstr = tempcoworkid;
            } else {
            	deletecoworkidstr += "," + tempcoworkid ;
            }
        }
        //删除协作内容和协作讨论
        if( !deletecoworkidstr.equals("") ) {
		  //PoppupRemindInfoUtil.updatePoppupRemindInfo(RecordSetDelRq.getInt(1),9,RecordSetDelRq.getString(2),Util.getIntValue(delRqid,0));

           RecordSet.executeSql("delete from cowork_items where id in( "+deletecoworkidstr+")");
           RecordSet.executeSql("delete from cowork_discuss where coworkid in( "+deletecoworkidstr+")");
        }
    }
	//更新协作提醒信息的数量
	RecordSet.executeProc("reset_CoworkRemind","");

 	response.sendRedirect("cowork/CoworkMonitor.jsp");
}
//结束协作
if(operation.equals("endCowork")){
	if(!HrmUserVarify.checkUserRight("collaborationmanager:edit",user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	String coworkid = Util.null2String(request.getParameter("coworkids"));
	//协作提醒
	ArrayList coworkids = Util.TokenizerString(coworkid,",");
	
	String remark = SystemEnv.getHtmlLabelName(19076,user.getLanguage());
	char flag = 2;
	int userId=user.getUID();
	Date now=new Date();
	SimpleDateFormat date=new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat time=new SimpleDateFormat("HH:mm:ss");
	String createdate=date.format(now);
	String createtime=time.format(now);
	for(int k=0;k<coworkids.size();k++){
		String tempCoworkid=(String)coworkids.get(k);
		//协作是打开的，才进行结束操作
		RecordSet.executeSql("select status from cowork_items where status=1 and id ="+tempCoworkid);
		if(RecordSet.next()){
			List parterList=CoworkShareManager.getShareList("parter",tempCoworkid);//协作参与人
			
			//协作结束讨论记录
		 	String Proc=tempCoworkid+flag+userId+flag+createdate+flag+createtime+flag+remark+flag+""+flag+""+flag+""+flag+""+flag+""+flag+""+flag+"0"+flag+"0";
			RecordSet.executeProc("cowork_discuss_insert",Proc);
			ArrayList poppuplist=new ArrayList();
			//协作结束提醒
			for(int i=0;i<parterList.size();i++){
				    Map map=new HashMap();
				    map.put("userid",""+Util.getIntValue((String)parterList.get(i)));
				    map.put("type","9");
				    map.put("logintype","0");
				    map.put("requestid",""+Util.getIntValue(tempCoworkid));
				    map.put("requestname","");
				    map.put("workflowid","-1");
				    map.put("creater","");
				    poppuplist.add(map);
		           // PoppupRemindInfoUtil.insertPoppupRemindInfo(Util.getIntValue((String)parterList.get(i)),9,"0",Util.getIntValue(tempCoworkid));	
			}
			 PoppupRemindInfoUtil.insertPoppupRemindInfo(poppuplist);
			
			//结束协作
			RecordSet.executeSql("update cowork_items set status=2 where id ="+tempCoworkid);
		}
	}
	response.sendRedirect("cowork/CoworkMonitor.jsp");
}

/**
 * 增加项目监控删除功能
 * @author hubo
 * @date 2007-5-30
 */
if(operation.equals("deleteproj")){
	String from = Util.null2String(request.getParameter("from"));
	String ids = Util.null2String(request.getParameter("deleteprojid"));
	if("mymanagerproject".equalsIgnoreCase(from)){
		String prjmanagerid= ProjectInfoComInfo.getProjectInfomanager(ids);
		String prjstatus= ProjectInfoComInfo.getProjectInfostatus(ids);
		if(!prjmanagerid.equals(""+user.getUID())||(!"0".equals(""+prjstatus)&&!"7".equals(""+prjstatus))){
			response.sendRedirect("/notice/noright.jsp") ;
			return ;
		}
	}else{
		if(!HrmUserVarify.checkUserRight("EditProject:Delete",user)) {
			response.sendRedirect("/notice/noright.jsp") ;
			return ;
		}
	}
	
	
	if(ids.endsWith(",")){
		ids = ids.substring(0,ids.length()-1);
	}

	String[] _ids = Util.TokenizerString2(ids, ",");
	String tempprjid = "";
	String tempprjname = "";
	for(int i=0;i<_ids.length;i++){
		tempprjid = _ids[i];
		//RecordSet.executeSql("select name from prj_projectinfo where id="+tempprjid);
		//RecordSet.next();
		//tempprjname = RecordSet.getString("name");
		tempprjname = prjComInfo.getProjectInfoname(tempprjid);
		
		SysMaintenanceLog.resetParameter();
		SysMaintenanceLog.setRelatedId(Util.getIntValue(tempprjid));
		SysMaintenanceLog.setRelatedName(tempprjname);
		SysMaintenanceLog.setOperateType("3");
		SysMaintenanceLog.setOperateDesc("delete from prj_projectinfo where id="+tempprjid+"");
		SysMaintenanceLog.setOperateItem("95");
		SysMaintenanceLog.setOperateUserid(user.getUID());
		SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
		SysMaintenanceLog.setSysLogInfo();
	}

	//删除项目
    RecordSet.executeSql("DELETE FROM Prj_ProjectInfo WHERE id IN ("+ids+")");
	//删除项目任务
	RecordSet.executeSql("DELETE FROM Prj_TaskProcess WHERE prjid IN ("+ids+")");
	//删除项目日程
	RecordSet.executeSql("DELETE FROM WorkPlan WHERE type_n=2 AND projectid IN ("+ids+")");
	
	ProjectInfoComInfo.removeProjectInfoCache();
	//response.sendRedirect("proj/ProjMonitor.jsp");
	//return;
}
%>