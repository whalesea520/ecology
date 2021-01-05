
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.file.ExcelSheet,
                 weaver.file.ExcelRow" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="ContacterShareBase" class="weaver.crm.ContacterShareBase" scope="page"/>

<%
    String sqlwhere=(String)session.getAttribute("sqlwhere");
    String orderStr=" order by "+(String)session.getAttribute("orderStr")+" asc";
    String sqlstr="";
	if(!sqlwhere.equals("") && (sqlwhere.indexOf("where")!=-1)){
		sqlwhere = sqlwhere.replace("where","and");
	}

if(RecordSet.getDBType().equals("oracle")){
	if(user.getLogintype().equals("1")){
         sqlstr = "select t3.* , t1.name , t1.crmId,t1.manager from CRM_Contract  t1,"+ContacterShareBase.getTempTable(user.getUID()+"")+"  t2 , CRM_ContractProduct t3,CRM_CustomerInfo  t4  where  t1.id = t2.relateditemid and t1.crmId = t4.id and t3.contractId = t1.id " + orderStr;

	}else{
        sqlstr = "select t3.*  , t1.name , t1.crmId,t1.manager from CRM_Contract  t1 , CRM_ContractProduct t3,CRM_CustomerInfo  t4   "+ sqlwhere +"  and t1.crmId = t4.id and t3.contractId = t1.id and t1.crmId="+user.getUID() + orderStr;
	}
}else if(RecordSet.getDBType().equals("db2")){
	if(user.getLogintype().equals("1")){
         sqlstr = "select t3.* , t1.name , t1.crmId,t1.manager from CRM_Contract  t1,"+ContacterShareBase.getTempTable(user.getUID()+"")+"  t2 , CRM_ContractProduct t3,CRM_CustomerInfo  t4  where t1.id = t2.relateditemid and t1.crmId = t4.id and t3.contractId = t1.id "+ orderStr;
    }else{
        sqlstr = "select t3.*  , t1.name , t1.crmId,t1.manager from CRM_Contract  t1 , CRM_ContractProduct t3,CRM_CustomerInfo  t4   "+ sqlwhere +"  and t1.crmId = t4.id and t3.contractId = t1.id and t1.crmId="+user.getUID() + orderStr;
    }
}else{
	if(user.getLogintype().equals("1")){
        sqlstr = "select t3.*  , t1.name , t1.crmId,t1.manager  from CRM_Contract  t1,"+ContacterShareBase.getTempTable(user.getUID()+"")+"  t2 , CRM_ContractProduct t3,CRM_CustomerInfo  t4  where t1.id = t2.relateditemid  and t1.crmId = t4.id and t3.contractId = t1.id " + orderStr ;
	}else{
        sqlstr = "select t3.* , t1.name , t1.crmId,t1.manager   from CRM_Contract t1 , CRM_ContractProduct t3,CRM_CustomerInfo  t4  "+ sqlwhere +"  and t1.crmId = t4.id and t3.contractId = t1.id and t1.crmId="+user.getUID() + orderStr ;
	}
}
    
    RecordSet.executeSql(sqlstr);

    ExcelSheet es = new ExcelSheet();
    
    ExcelRow erTitle = es.newExcelRow();//added by xwj td1554 on 2005-05-25
    ExcelRow erEmpty = es.newExcelRow();//added by xwj td1554 on 2005-05-25
	  ExcelRow er = es.newExcelRow();
	  
	   /*----------------added by xwj td1554 on 2005-05-25 ---------------begin--------*/
    erTitle.addStringValue("");
    erTitle.addStringValue("");
    erTitle.addStringValue("");
    erTitle.addStringValue("合同产品报表");
    erTitle.addStringValue("");
    erTitle.addStringValue("");
    erTitle.addStringValue("");
    erTitle.addStringValue("");
   
    
    erEmpty.addStringValue("");
    erEmpty.addStringValue("");
    erEmpty.addStringValue("");
    erEmpty.addStringValue("");
    erEmpty.addStringValue("");
    erEmpty.addStringValue("");
    erEmpty.addStringValue("");
    erEmpty.addStringValue("");
   /*----------------added by xwj td1554 on 2005-05-25 ---------------end-------------*/
   
    er.addStringValue(SystemEnv.getHtmlLabelName(6161,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(15115,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(15228,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(15229,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(15230,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(1050,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(534,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(1268,user.getLanguage()));
      
  
  
  
    while(RecordSet.next()){
   
      er = es.newExcelRow();
      er.addStringValue(RecordSet.getString("name"));
      er.addStringValue(Util.toScreen(AssetComInfo.getAssetName(RecordSet.getString("productId")),user.getLanguage()));
      er.addStringValue(RecordSet.getString("number_n"));
      er.addStringValue(RecordSet.getString("factnumber_n"));
      er.addStringValue(String.valueOf(Util.getIntValue(RecordSet.getString("number_n"),0) - Util.getIntValue(RecordSet.getString("factnumber_n"),0)));
      er.addStringValue(Util.toScreen(RecordSet.getString("planDate"),user.getLanguage()));
      er.addStringValue(Util.toScreen(RecordSet.getString("sumPrice"),user.getLanguage()));
      er.addStringValue(Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("crmId")),user.getLanguage()));
    
     
    }

    ExcelFile.init() ;
    ExcelFile.setFilename("合同产品报表") ;
    ExcelFile.addSheet("合同产品", es) ;
%>
success
<script language="javascript">
    window.location="/weaver/weaver.file.ExcelOut";
</script>