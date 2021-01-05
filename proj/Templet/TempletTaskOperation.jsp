
<%@page import="weaver.file.FileUpload"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.docs.category.security.AclManager " %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="ProjectAccesory" class="weaver.proj.ProjectAccesory" scope="page" />
<jsp:useBean id="PrjTskFieldComInfo" class="weaver.proj.util.PrjTskFieldComInfo" scope="page"/>
<jsp:useBean id="PrjTskFieldManager" class="weaver.proj.util.PrjTskFieldManager" scope="page"/>
<%
String method = Util.null2String(request.getParameter("method"));
int taskTempletID = Util.getIntValue(Util.null2String(request.getParameter("taskTempletID")), -1);
int projID = Util.getIntValue(Util.null2String(request.getParameter("ProjID")), -1);

int accessorynum = Util.getIntValue(request.getParameter("accessory_num"),0);
int deleteField_idnum = Util.getIntValue(request.getParameter("field_idnum"),0);
String accdocids=Util.null2String(request.getParameter("accdocids"));
/* Task BaseInfo */
String taskName = Util.null2String(request.getParameter("subject"));
String taskManager = Util.null2String(request.getParameter("hrmid"));
String beginDate = Util.null2String(request.getParameter("begindate"));
String endDate = Util.null2String(request.getParameter("enddate"));
double workday1 = Util.getDoubleValue(Util.null2String(request.getParameter("workday")), 0.0);
int workday = (int) workday1;
String budget = Util.null2String(request.getParameter("fixedcost"));
String befTaskId = Util.null2String(request.getParameter("taskids02"));
String taskDesc = Util.null2String(request.getParameter("content"));

/* Task RelatedInfo */
String[] docRequired_mainid = request.getParameterValues("requireddocs_mainid");
String[] docRequired_subid = request.getParameterValues("requireddocs_subid");
String[] docRequired_secid = request.getParameterValues("requireddocs_secid");
String[] docRefer = request.getParameterValues("referdocs");
String[] wfRequired = request.getParameterValues("requiredWFIDs");
String isNecessary = "";
String isNecessaryWF = "";


/* Action */
String sql = "";
if(method.equals("edit")){
	sql = "UPDATE Prj_TemplateTask SET taskName='"+taskName+"',taskManager='"+taskManager+"',begindate='"+beginDate+"',enddate='"+endDate+"',workday="+workday+",budget='"+budget+"',befTaskId='"+befTaskId+"',taskDesc='"+taskDesc+"' WHERE id="+taskTempletID;
	RecordSet.executeSql(sql);

	//相关附件操作开始
    String newAccessory = "";
	RecordSet.executeSql("SELECT accessory FROM Prj_TemplateTask WHERE id = " + taskTempletID);
    if(RecordSet.next()){
		String oldAccessory = Util.null2String(RecordSet.getString(1));
	    newAccessory = oldAccessory;
		//删除附件
		if(deleteField_idnum>0){
			for(int i=0;i<deleteField_idnum;i++){
				String field_del_flag = Util.null2String(request.getParameter("field_del_"+i));				
				if(field_del_flag.equals("1")){
					String field_del_value = Util.null2String(request.getParameter("field_id_"+i));
					RecordSet.executeSql("delete DocDetail where id = " + field_del_value);
					if(newAccessory.indexOf(field_del_value)==0){
						newAccessory = Util.StringReplace(newAccessory,field_del_value+",","");
					}else{
						newAccessory = Util.StringReplace(newAccessory,","+field_del_value,"");
					}
				}
			}
		}
		
	}
    
    if(!"".equals(accdocids)){
	    RecordSet.executeSql("update Prj_TemplateTask set accessory ='"+newAccessory+accdocids+"' where id = "+taskTempletID);    
	    
		//给项目里面的相关附件赋查看权限开始
		
		//给项目里面的相关附件赋查看权限结束
		
	}
    //相关附件操作结束
    
    PrjTskFieldManager.updateCusfieldValue(""+taskTempletID, new FileUpload(request) , user,"Prj_TemplateTask");
    
    /********所需流程,所需文档,参考文档*********/
    /**
    sql = "DELETE FROM Prj_TempletTask_needdoc WHERE templetTaskId="+taskTempletID;
	RecordSet.executeSql(sql);
	if(docRequired_secid!=null){
		for(int i=0;i<docRequired_secid.length;i++){
			isNecessary = request.getParameter("necessary"+docRequired_secid[i])==null ? "0" : "1";
			sql = "INSERT INTO Prj_TempletTask_needdoc (templetTaskId,docMainCategory,docSubCategory,docSecCategory,isNecessary) VALUES ("+taskTempletID+","+docRequired_mainid[i]+","+docRequired_subid[i]+","+docRequired_secid[i]+",'"+isNecessary+"')";
			RecordSet.executeSql(sql);
		}
	}

	sql = "DELETE FROM Prj_TempletTask_referdoc WHERE templetTaskId="+taskTempletID;
	RecordSet.executeSql(sql);
	if(docRefer!=null){
		for(int i=0;i<docRefer.length;i++){
			sql = "INSERT INTO Prj_TempletTask_referdoc (templetTaskId,docid) VALUES ("+taskTempletID+","+docRefer[i]+")";
			RecordSet.executeSql(sql);
		}
	}

	sql = "DELETE FROM Prj_TempletTask_needwf WHERE templetTaskId="+taskTempletID;
	RecordSet.executeSql(sql);
	if(wfRequired!=null){
		for(int i=0;i<wfRequired.length;i++){
			isNecessaryWF = request.getParameter("necessaryWF"+wfRequired[i])==null ? "0" : "1";
			sql = "INSERT INTO Prj_TempletTask_needwf (templetTaskId,workflowId,isNecessary) VALUES ("+taskTempletID+","+wfRequired[i]+",'"+isNecessaryWF+"')";
			RecordSet.executeSql(sql);
		}
	}
	**/
}

response.sendRedirect("TempletTaskView.jsp?id="+taskTempletID+"&templetid="+projID);
%>