
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.file.ExcelSheet"%>
<%@ page import="weaver.file.ExcelRow"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
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
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />

<%
    String sqlwhere=(String)session.getAttribute("sqlwhere");
    //String orderStr=(String)session.getAttribute("orderStr");
    //String orderStr1=(String)session.getAttribute("orderStr1");
    String sqlstr="";

String leftjointable = CrmShareBase.getTempTable(""+user.getUID());

if(RecordSet.getDBType().equals("oracle")){
	if(user.getLogintype().equals("1")){
        sqlstr = "select distinct t1.subject,t1.predate,t1.preyield,t1.probability,t1.createdate,t1.sellstatusid,t1.endtatusid,t1.customerid,t1.predate from CRM_SellChance  t1,"+leftjointable+" t2,CRM_CustomerInfo t3 "+ sqlwhere +"and t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t2.relateditemid  order by t1.predate desc ";

	}else{
        sqlstr = "select t1.* from CRM_SellChance  t1,CRM_CustomerInfo t3  "+ sqlwhere +"and t3.deleted=0 and t3.id= t1.customerid  and t1.customerid="+user.getUID() + "  order by t1.predate desc ";
	}
}else{
	if(user.getLogintype().equals("1")){
        sqlstr = "select distinct t1.subject,t1.predate,t1.preyield,t1.probability,t1.createdate,t1.sellstatusid,t1.endtatusid,t1.customerid,t1.predate  from CRM_SellChance  t1,"+leftjointable+" t2,CRM_CustomerInfo t3  "+ sqlwhere +"and t3.deleted=0  and t3.id= t1.customerid and t1.customerid = t2.relateditemid ORDER BY t1.predate desc " ;
	}else{
        sqlstr = "select t1.*  from CRM_SellChance t1,CRM_CustomerInfo t3  "+ sqlwhere +"and t3.deleted=0 and t3.id= t1.customerid  and t1.customerid="+user.getUID() + " ORDER BY t1.predate desc " ;
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
    erTitle.addStringValue("机会列表报表");
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
    
    er.addStringValue(SystemEnv.getHtmlLabelName(344,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(2247,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(2248,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(2249,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(1339,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(2250,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(15112,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(136,user.getLanguage()));
   

    String sql_5 = "";
    String endtatusid0 = "";
   
    while(RecordSet.next()){
    
      er = es.newExcelRow();
      
      er.addStringValue(Util.toScreen(RecordSet.getString("subject"),user.getLanguage()));
      er.addStringValue(Util.toScreen(RecordSet.getString("predate"),user.getLanguage()));
      er.addStringValue(Util.toScreen(RecordSet.getString("preyield"),user.getLanguage()));
      er.addStringValue(Util.toScreen(RecordSet.getString("probability"),user.getLanguage()));
      er.addStringValue(Util.toScreen(RecordSet.getString("createdate"),user.getLanguage()));
     
      
      if(RecordSet.getString("sellstatusid")!=null&&!"".equals(RecordSet.getString("sellstatusid"))){
      sql_5="select * from CRM_SellStatus where id ="+RecordSet.getString("sellstatusid");
      rs.executeSql(sql_5);
      rs.next();      
      er.addStringValue(Util.toScreen(rs.getString("fullname"),user.getLanguage()));
      } else er.addStringValue("");
      
      endtatusid0 = Util.toScreen(RecordSet.getString("endtatusid"),user.getLanguage());
     
      if(endtatusid0.equals("0")){
       er.addStringValue(SystemEnv.getHtmlLabelName(1960,user.getLanguage()));
      
      }
      else if(endtatusid0.equals("1")){
      er.addStringValue(SystemEnv.getHtmlLabelName(15242,user.getLanguage()));
      
      }
      else if(endtatusid0.equals("2")){
      er.addStringValue(SystemEnv.getHtmlLabelName(498,user.getLanguage()));
      
      }
      else{
      }
     
      
     er.addStringValue(Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("customerid")),user.getLanguage()));
    
     
    }



    ExcelFile.init() ;
    ExcelFile.setFilename("机会报表") ;
    ExcelFile.addSheet("机会", es) ;
%>
success
<script language="javascript">
    window.location="/weaver/weaver.file.ExcelOut";
</script>