
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.file.ExcelSheet,
                 weaver.file.ExcelRow" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet_count" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="ContractComInfo" class="weaver.crm.Maint.ContractComInfo" scope="page"/>
<jsp:useBean id="ContractTypeComInfo" class="weaver.crm.Maint.ContractTypeComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="EvaluationLevelComInfo" class="weaver.crm.Maint.EvaluationLevelComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%
    String sqlwhere=(String)session.getAttribute("sqlwhere");
    //String orderStr=(String)session.getAttribute("orderStr");
    //String orderStr1=(String)session.getAttribute("orderStr1");
    String sqlstr="";

String leftjointable = CrmShareBase.getTempTable(""+user.getUID());

if(RecordSet.getDBType().equals("oracle")){
	if(user.getLogintype().equals("1")){
		sqlstr = "select distinct t1.id, t1.evaluation, t1.manager, t1.createdate from CRM_CustomerInfo  t1,"+leftjointable+"  t2 "+ sqlwhere +" and t1.deleted <>1 and t1.id = t2.relateditemid order by t1.createdate desc ";
	}else{
		sqlstr = "select distinct t1.id, t1.evaluation, t1.manager, t1.createdate from CRM_CustomerInfo  t1  "+ sqlwhere +" and t1.deleted <>1 and t1.agent="+user.getUID() + "  order by t1.createdate desc ";
	}
}else{
	if(user.getLogintype().equals("1")){
		sqlstr = "select distinct t1.id, t1.evaluation, t1.manager, t1.createdate  from CRM_CustomerInfo  t1,"+leftjointable+"  t2 "+ sqlwhere +" and t1.deleted <>1 and t1.id = t2.relateditemid ORDER BY t1.createdate desc " ;
	}else{
		sqlstr = "select distinct t1.id, t1.evaluation, t1.manager, t1.createdate  from CRM_CustomerInfo t1 "+ sqlwhere +" and t1.deleted <>1 and t1.agent="+user.getUID() + " ORDER BY t1.createdate desc " ;
	}

}
    
    RecordSet.executeSql(sqlstr);

    ExcelSheet es = new ExcelSheet();

    ExcelRow erTitle = es.newExcelRow();//added by xwj td1554 on 2005-05-25
    ExcelRow erEmpty = es.newExcelRow();//added by xwj td1554 on 2005-05-25
	  ExcelRow er = es.newExcelRow();
	  
	   /*----------------added by xwj td1554 on 2005-05-25 ---------------begin--------*/
    erTitle.addStringValue("");
    erTitle.addStringValue("客户价值报表");
    erTitle.addStringValue("");
    erTitle.addStringValue("");
    
    erEmpty.addStringValue("");
    erEmpty.addStringValue("");
    erEmpty.addStringValue("");
    erEmpty.addStringValue("");
   /*----------------added by xwj td1554 on 2005-05-25 ---------------end-------------*/
	  
    er.addStringValue(SystemEnv.getHtmlLabelName(1268,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(6073,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(1278,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(1339,user.getLanguage()));
   
    while(RecordSet.next()){
   
      er = es.newExcelRow();
      er.addStringValue(Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("id")),user.getLanguage()));
      er.addStringValue(Util.toScreen(EvaluationLevelComInfo.getEvaluationLevelname(RecordSet.getString("evaluation")),user.getLanguage()));
      er.addStringValue(Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("manager")),user.getLanguage()));//td1554 xwj on 2005-05-24
      er.addStringValue(Util.toScreen(RecordSet.getString("createdate"),user.getLanguage()));
    
     
    }

    ExcelFile.init() ;
    ExcelFile.setFilename("客户价值报表") ;
    ExcelFile.addSheet("客户价值", es) ;
%>
success
<script language="javascript">
    window.location="/weaver/weaver.file.ExcelOut";
</script>