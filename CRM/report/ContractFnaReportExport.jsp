
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.file.ExcelSheet,
                 weaver.file.ExcelRow" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="ContacterShareBase" class="weaver.crm.ContacterShareBase" scope="page"/>

<%
    String sqlwhere=(String)session.getAttribute("sqlwhere");
    String orderStr=" order by "+(String)session.getAttribute("orderStr")+" asc ";
    String sqlstr="";


    if(RecordSet.getDBType().equals("oracle")){
	  if(user.getLogintype().equals("1")){
        sqlstr = "select t3.* , t1.name , t1.crmId,t1.manager from CRM_Contract  t1,"+ContacterShareBase.getTempTable(user.getUID()+"")+"  t2 , CRM_ContractPayMethod t3,CRM_CustomerInfo  t4  "+ sqlwhere +"  and t1.id = t2.relateditemid  and t1.crmId = t4.id and t3.contractId = t1.id " + orderStr;

	  }else{
        sqlstr = "select t3.*  , t1.name , t1.crmId,t1.manager from CRM_Contract  t1 , CRM_ContractPayMethod t3,CRM_CustomerInfo  t4   "+ sqlwhere +"  and t1.crmId = t4.id and t3.contractId = t1.id and t1.crmId="+user.getUID() + orderStr;
	  }
    }else{
	  if(user.getLogintype().equals("1")){
        sqlstr = "select  t3.* , t1.name , t1.crmId, t1.manager from CRM_Contract  t1,"+ContacterShareBase.getTempTable(user.getUID()+"")+" t2 , CRM_ContractPayMethod t3,CRM_CustomerInfo  t4  "+ sqlwhere +"  and t1.id = t2.relateditemid  and t1.crmId = t4.id and t3.contractId = t1.id " + orderStr ;
	  }else{
        sqlstr = "select  t3.* , t1.name , t1.crmId, t1.manager from CRM_Contract t1 , CRM_ContractPayMethod t3,CRM_CustomerInfo  t4  "+ sqlwhere +"  and t1.crmId = t4.id and t3.contractId = t1.id and t1.crmId="+user.getUID() + orderStr ;
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
    erTitle.addStringValue("");
    erTitle.addStringValue("合同应收应付报表");
    erTitle.addStringValue("");
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
    erEmpty.addStringValue("");
    erEmpty.addStringValue("");
   /*----------------added by xwj td1554 on 2005-05-25 ---------------end-------------*/
    
    
    er.addStringValue(SystemEnv.getHtmlLabelName(6161,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(15132,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(15137,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(15224,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(15225,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(15138,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(15226,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(15227,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(15135,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(1268,user.getLanguage()));
      
  
    int typeId;
    double tempNum;
    while(RecordSet.next()){
      typeId = RecordSet.getInt("typeId");
      er = es.newExcelRow();
      er.addStringValue(RecordSet.getString("name"));
      er.addStringValue(RecordSet.getString("prjName"));
      er.addStringValue(((typeId == 1)?Util.toScreen(RecordSet.getString("payPrice"),user.getLanguage()):"-"));
      er.addStringValue(((typeId == 1)?Util.toScreen(RecordSet.getString("factPrice"),user.getLanguage()):"-"));
      double price_cc= Util.getDoubleValue(RecordSet.getString("factPrice"),0);
      double sum = Util.getDoubleValue(RecordSet.getString("payPrice"),0) ;
             tempNum = sum - price_cc;
      String SS = tempNum+"";
      if(SS.indexOf("E") != -1){ //modify TD2084 by xys
           SS= Util.getPointValue(Util.getfloatToString(""+tempNum));
      }else{
           SS= Util.getPointValue(""+tempNum);
      }  
      er.addStringValue(((typeId == 1)?Util.toScreen(String.valueOf(SS),user.getLanguage()):"-"));
      er.addStringValue(((typeId == 2)?Util.toScreen(RecordSet.getString("payPrice"),user.getLanguage()):"-"));
      er.addStringValue(((typeId == 2)?Util.toScreen(RecordSet.getString("factPrice"),user.getLanguage()):"-"));
      er.addStringValue(((typeId == 2)?Util.toScreen(String.valueOf(SS),user.getLanguage()):"-"));
      er.addStringValue(Util.toScreen(RecordSet.getString("payDate"),user.getLanguage()));
      er.addStringValue(Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("crmId")),user.getLanguage()));
     
    }

    ExcelFile.init() ;
    ExcelFile.setFilename("合同应收应付报表") ;
    ExcelFile.addSheet("合同应收应付", es) ;
%>
success
<script language="javascript">
    window.location="/weaver/weaver.file.ExcelOut";
</script>