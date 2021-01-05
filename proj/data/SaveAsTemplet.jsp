
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjTempletUtil" class="weaver.proj.Templet.ProjTempletUtil" scope="page" />
<jsp:useBean id="PriTemplate" class="weaver.proj.PriTemplate" scope="page" />
<%
String projId = Util.null2String(request.getParameter("projId"));

//模板名称
String strTempletName = Util.null2String(request.getParameter("templetName"));

//项目卡片信息
int strPrjType = Util.getIntValue(request.getParameter("txtPrjType"));
int strWorkType = Util.getIntValue(request.getParameter("workType"));
String strMembers = Util.null2String(request.getParameter("members"));
String strIsMemberSee = Util.null2String(request.getParameter("isMemberSee"));
String strCrms = Util.null2String(request.getParameter("crms"));
String strIsCrmSee = Util.null2String(request.getParameter("isCrmSee"));
int strParentProId = Util.getIntValue(request.getParameter("parentProId"));
int strCommentDoc = Util.getIntValue(request.getParameter("commentDoc"));
int strConfirmDoc = Util.getIntValue(request.getParameter("confirmDoc"));
int strAdviceDoc = Util.getIntValue(request.getParameter("adviceDoc"));
int strManager = Util.getIntValue(request.getParameter("manager"));

//项目自定义信息
String dff01=Util.null2String(request.getParameter("dff01"));
String dff02=Util.null2String(request.getParameter("dff02"));
String dff03=Util.null2String(request.getParameter("dff03"));
String dff04=Util.null2String(request.getParameter("dff04"));
String dff05=Util.null2String(request.getParameter("dff05"));

String nff01=Util.null2String(request.getParameter("nff01"));
if(nff01.equals("")) nff01="0.0";
String nff02=Util.null2String(request.getParameter("nff02"));
if(nff02.equals("")) nff02="0.0";
String nff03=Util.null2String(request.getParameter("nff03"));
if(nff03.equals("")) nff03="0.0";
String nff04=Util.null2String(request.getParameter("nff04"));
if(nff04.equals("")) nff04="0.0";
String nff05=Util.null2String(request.getParameter("nff05"));
if(nff05.equals("")) nff05="0.0";

String tff01=Util.fromScreen(request.getParameter("tff01"),user.getLanguage());
String tff02=Util.fromScreen(request.getParameter("tff02"),user.getLanguage());
String tff03=Util.fromScreen(request.getParameter("tff03"),user.getLanguage());
String tff04=Util.fromScreen(request.getParameter("tff04"),user.getLanguage());
String tff05=Util.fromScreen(request.getParameter("tff05"),user.getLanguage());

String bff01=Util.null2String(request.getParameter("bff01"));
if(bff01.equals("")) bff01="0";
String bff02=Util.null2String(request.getParameter("bff02"));
if(bff02.equals("")) bff02="0";
String bff03=Util.null2String(request.getParameter("bff03"));
if(bff03.equals("")) bff03="0";
String bff04=Util.null2String(request.getParameter("bff04"));
if(bff04.equals("")) bff04="0";
String bff05=Util.null2String(request.getParameter("bff05"));
if(bff05.equals("")) bff05="0";

String areaLinkXml = Util.null2String(request.getParameter("areaLinkXml"));
areaLinkXml =  Util.StringReplace(areaLinkXml, "\\\"","\"");

//isNeedAppr	0:模板不需要审批	1:模板需要审批
String strStatus = "";
String sqlT = "SELECT isNeedAppr FROM ProjTemplateMaint";
rs.executeSql(sqlT);
if(rs.next()){
	strStatus = rs.getString("isNeedAppr").equals("0") ? "1" : "0";
}
/*
StringBuffer sql = new StringBuffer("");
sql.append("INSERT INTO Prj_Template ");
sql.append("(isSelected,templetName,proTypeId,workTypeId,proMember,isMemberSee,proCrm,isCrmSee,parentProId,commentDoc,confirmDoc,adviceDoc,Manager,");
sql.append("Datefield1,Datefield2,Datefield3,Datefield4,Datefield5,Numberfield1,Numberfield2,Numberfield3,Numberfield4,Numberfield5,");
sql.append("Textfield1,Textfield2,Textfield3,Textfield4,Textfield5,Tinyintfield1,Tinyintfield2,Tinyintfield3,Tinyintfield4,Tinyintfield5) ");
sql.append("VALUES ");
sql.append("('0','"+strTempletName+"',"+iPrjType+","+iWorkType+",'"+strMembers+"','"+strIsMemberSee+"','"+strCrms+"','"+strIsCrmSee+"',"+iParentProId+","+iCommentDoc+","+iConfirmDoc+","+iAdviceDoc+","+iManager+",");
sql.append("'"+dff01+"','"+dff02+"','"+dff03+"','"+dff04+"','"+dff05+"','"+nff01+"','"+nff02+"','"+nff03+"','"+nff04+"','"+nff05+"',");
sql.append("'"+tff01+"','"+tff02+"','"+tff03+"','"+tff04+"','"+tff05+"','"+bff01+"','"+bff02+"','"+bff03+"','"+bff04+"','"+bff05+"')");

out.println(sql.toString());
//RecordSet.executeSql(sql.toString());
*/

 PriTemplate.setTempletName(strTempletName);
 PriTemplate.setProjectType(strPrjType);
 PriTemplate.setWorkType(strWorkType);
 PriTemplate.setHrmId(strMembers);
 PriTemplate.setIsMemberShow(strIsMemberSee);
 PriTemplate.setAboutMCrm(strCrms);
 PriTemplate.setIsCrmShow(strIsCrmSee);
 PriTemplate.setParentId(strParentProId);
 PriTemplate.setEnvDoc(strCommentDoc);
 PriTemplate.setConDoc(strConfirmDoc);
 PriTemplate.setAdviceDoc(strAdviceDoc);
 PriTemplate.setPrjManager(strManager);
 PriTemplate.setLinkXml(areaLinkXml);
 PriTemplate.setDff01(dff01);
 PriTemplate.setDff02(dff02);
 PriTemplate.setDff03(dff03);
 PriTemplate.setDff04(dff04);
 PriTemplate.setDff05(dff05);
 PriTemplate.setNff01(nff01);
 PriTemplate.setNff02(nff02);
 PriTemplate.setNff03(nff03);
 PriTemplate.setNff04(nff04);
 PriTemplate.setNff05(nff05);
 PriTemplate.setTff01(tff01);
 PriTemplate.setTff02(tff02);
 PriTemplate.setTff03(tff03);
 PriTemplate.setTff04(tff04);
 PriTemplate.setTff05(tff05);
 PriTemplate.setBff01(bff01);
 PriTemplate.setBff02(bff02);
 PriTemplate.setBff03(bff03);
 PriTemplate.setBff04(bff04);
 PriTemplate.setBff05(bff05);
 PriTemplate.AddPrjTemplateInfo();
//int templetID = RecordSet.getFlag();
rs1.executeSql("select id from Prj_Template order by id desc");//获得模板id
rs1.first();
int templetID=rs1.getInt("id");
RecordSet.executeSql("update Prj_Template set status = "+strStatus+" where id = "+templetID);
//------项目类型自定义字段的值的插入
String strSqlCdata = "select * from prj_fielddata where scope='ProjCustomFieldReal' and scopeid="+strPrjType+" and id="+projId ;
RecordSet.executeSql(strSqlCdata);
int columnCount =  RecordSet.getColCounts();
int realColumnCount = columnCount-4;
if (RecordSet.next()){
    String fieldStrs="";
    String fieldValues="";
    //长字段值不能直接拼接sql，包括html文本、多选
	List<Object> clobValueList = new ArrayList<Object>();
    for (int i=0;i<realColumnCount;i++){
        fieldStrs+="field"+i+",";
        String tempValue = Util.null2String(RecordSet.getString("field"+i));
        fieldValues+="?,";
        clobValueList.add(tempValue);
    }

    int tempPos1 = fieldStrs.lastIndexOf(",");
    if (tempPos1!=-1){
        fieldStrs =  fieldStrs.substring(0,tempPos1);
    }

    int tempPos2 = fieldValues.lastIndexOf(",");
    if (tempPos2!=-1){
        fieldValues =  fieldValues.substring(0,tempPos2);       
    }
    Object[] clobObjects = new Object[clobValueList.size()];
 	for (int j=0;j<clobValueList.size();j++) {
 		clobObjects[j] = clobValueList.get(j);
 	}

    String strInsertCData ="insert into prj_fielddata (scope,scopeid,id,"+fieldStrs+") values ('ProjCustomField',"+strPrjType+","+templetID+","+fieldValues+")";      
  
    RecordSet1.executeSql(strInsertCData,false,clobObjects);
}


//主表中要添加relationXml字段的值
//RecordSet.executeSql("select relationXml from Prj_ProjectInfo where id="+projId);
//if (RecordSet.next()){
//    String tempRelationXml = Util.null2String(RecordSet.getString("relationXml"));
//    PriTemplate.setLinkXml(tempRelationXml);
//    PriTemplate.setTempletId(templetID+"");
//    PriTemplate.editLinkXml();
//}
//dong ping 以下导出相关数据到任务明细表模板表中
RecordSet.executeSql("select t1.*,t3.id as parenttaskid,t2.id as befTaskId from Prj_TaskProcess t1 left outer join Prj_TaskProcess t2 on t2.prjid=t1.prjid and t2.taskindex=t1.prefinish left outer join Prj_TaskProcess t3 on t3.id=t1.parentid and t3.prjid=t1.prjid where t1.prjid="+projId);
while (RecordSet.next()){
    String taskId = Util.null2String(RecordSet.getString("id"));
    String taskName = Util.null2String(RecordSet.getString("subject"));
    String workDay = Util.null2String(RecordSet.getString("workDay"));
    String beginDate = Util.null2String(RecordSet.getString("beginDate"));
    String endDate= Util.null2String(RecordSet.getString("endDate"));
    String budget = Util.null2String(RecordSet.getString("fixedcost"));
    String befTaskId = Util.null2String(RecordSet.getString("befTaskId"));
    String parenttaskid = Util.null2String(RecordSet.getString("parenttaskid"));
    String taskManager = Util.null2String(RecordSet.getString("hrmid"));
    String templetTaskId = Util.null2String(RecordSet.getString("id"));
    String taskindex = Util.null2String(RecordSet.getString("taskindex"));


    String strInsertTemplet = "insert into Prj_TemplateTask (templetId,taskName,workDay,beginDate,endDate,budget,befTaskId,taskManager,templetTaskId,parenttaskid,taskindex) values ("+templetID+",'"+taskName+"',"+workDay+",'"+beginDate+"','"+endDate+"','"+budget+"','"+befTaskId+"','"+taskManager+"','"+templetTaskId+"','"+parenttaskid+"','"+taskindex+"')";
    RecordSet1.executeSql(strInsertTemplet);
    RecordSet1.executeSql("select max(id) from Prj_TemplateTask ");
    int nextId = 0;
    if (RecordSet1.next()) nextId = Util.getIntValue(RecordSet1.getString(1));
    //System.out.println(strInsertTemplet);

    //所需文档
    RecordSet1.executeSql("select * from Prj_Task_needdoc where taskId = "+taskId);
    while (RecordSet1.next()){
        String docMainCategory = Util.null2String(RecordSet1.getString("docMainCategory"));
        String docSubCategory = Util.null2String(RecordSet1.getString("docSubCategory"));
        String docSecCategory = Util.null2String(RecordSet1.getString("docSecCategory"));
        String isNecessary = Util.null2String(RecordSet1.getString("isNecessary"));
        
        String strInsertNeeddoc ="insert into Prj_TempletTask_needdoc (templetTaskId,docMainCategory,docSubCategory,docSecCategory,isNecessary) values ("+nextId+","+docMainCategory+","+docSubCategory+","+docSecCategory+","+isNecessary+")  ";
        RecordSet2.executeSql(strInsertNeeddoc);
        //System.out.println(strInsertNeeddoc);
    }
    //所需工作流
    RecordSet1.executeSql("select * from Prj_Task_needwf where taskId = "+taskId);
    while (RecordSet1.next()){
        String workflowid = Util.null2String(RecordSet1.getString("workflowid"));
        String isNecessary = Util.null2String(RecordSet1.getString("isNecessary"));
        
        String strInsertNeedWf ="insert into Prj_TempletTask_needwf (templetTaskId,workflowid,isNecessary) values ("+nextId+","+workflowid+","+isNecessary+")";
        RecordSet2.executeSql(strInsertNeedWf);
        //System.out.println(strInsertNeedWf);
    }

    //参考文档

    RecordSet1.executeSql("select * from Prj_Task_referdoc where taskId = "+taskId);
    while (RecordSet1.next()){
        String docid = Util.null2String(RecordSet1.getString("docid"));        
        
        String strInsertRefdoc ="insert into Prj_TempletTask_referdoc (templetTaskId,docid) values ("+nextId+","+docid+")";
        RecordSet2.executeSql(strInsertRefdoc);
        //System.out.println(strInsertRefdoc);
    }
}

//前置任务修正
//任务在未实际插入数据库前，任务id不确定，此时前置任务保存的id为任务的行号，在任务插入数据库后需要修正实际前置任务id
//rs.executeSql("select id,befTaskId from Prj_TemplateTask where befTaskId!=0 and templetId="+templetID);
//while(rs.next()){
//    String id = rs.getString("id");
//    String befTaskId = rs.getString("befTaskId");
//    String realBefTaskId = befTaskId;
//    rs1.executeSql("select id from Prj_TemplateTask where templetTaskId="+befTaskId+" and templetId="+templetID);
//    if(rs1.next()) realBefTaskId = rs1.getString("id");
//    rs1.executeSql("update Prj_TemplateTask set befTaskId="+realBefTaskId+" where id="+id);
//}
//前置任务修正


//response.sendRedirect("/proj/Templet/ProjTempletView.jsp?templetId="+templetID);
out.println("<script type='text/javascript'>window.top.Dialog.alert('"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+SystemEnv.getHtmlLabelName(15242,user.getLanguage())+"!');location.href='ViewProject.jsp?isfromProjTab=1&ProjID="+projId+"';</script>");
%>
