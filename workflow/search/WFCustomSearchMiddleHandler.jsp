
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="WorkFlowUtil" class="weaver.workflow.workflow.WorkFlowUtil" scope="page" />

<!--
  此页面为查询流程的中间处理页面。
  此页面用于将从WFSearchPageFrame.jsp页面中提交的自定义查询条件拼接成sql的where条件，
  WFSearchPageFrame.jsp页面中的系统字段条件在本页面中不进行处理，统一由下一个页面处理。
  然后再次请求转发到数据查询和结果展示页面。

  本页面实现的功能：
    拼接自定义查询条件；
    查询符合条件的requestid；
    将requestid存入request；
    转发到下一个页面WFSearchShow.jsp；
-->
<%

boolean isoracle = (RecordSet.getDBType()).equals("oracle") ;
boolean isdb2 = (RecordSet.getDBType()).equals("db2") ;

String isbill = "0";
String formID = "0";
String customid = Util.null2String(request.getParameter("customid"));
String isfrom = Util.null2String(request.getParameter("isfrom"));
String workflowid = Util.null2String(request.getParameter("workflowid"));
List<String> fieldids = new ArrayList<String>();
List<String> fieldhtmltypes = new ArrayList<String>();
List<String> fieldtypes = new ArrayList<String>();
List<String> fielddbtypes = new ArrayList<String>();

if(customid != null && !customid.equals("")){
    rs.executeSql("select * from workflow_custom where id="+customid);
    if(rs.next()){
        isbill = ""+Util.getIntValue(rs.getString("isbill"),0);
        formID = ""+Util.getIntValue(rs.getString("formid"),0);
    }
}else{
  request.getRequestDispatcher("WFSearchShow.jsp").forward(request, response);
  return;
}

//下面开始自定义查询条件
String[] checkcons = request.getParameterValues("check_con");

String sqlwhere=" ";

if(checkcons!=null){

  for(int i=0;i<checkcons.length;i++){

		String tmpid      = ""+checkcons[i];
		String tmpcolname = ""+Util.null2String(request.getParameter("con"+tmpid+"_colname"));
		String htmltype   = ""+Util.null2String(request.getParameter("con"+tmpid+"_htmltype"));
		String type       = ""+Util.null2String(request.getParameter("con"+tmpid+"_type"));
		String tmpopt     = ""+Util.null2String(request.getParameter("con"+tmpid+"_opt"));
		String tmpvalue   = ""+Util.null2String(request.getParameter("con"+tmpid+"_value"));
		String tmpopt1    = ""+Util.null2String(request.getParameter("con"+tmpid+"_opt1"));
		String tmpvalue1  = ""+Util.null2String(request.getParameter("con"+tmpid+"_value1"));

    if (tmpvalue.isEmpty() && tmpvalue1.isEmpty()) {
    	continue;
    }
  	//是自定义表单
	  String isnull="nvl";
    if(!rs2.getDBType().equals("oracle")){
  	   isnull="isNull";
    }

   	if(isbill.equals("1")){
   		 rs2.executeSql("select t.id, t.fieldname, t.detailtable, bdt.id,bil.tablename,"+isnull+"(bil.detailkeyfield,'mainid') detailkeyfield from workflow_billfield t, Workflow_billdetailtable bdt,workflow_bill bil where bil.id = bdt.billid and t.detailtable = bdt.tablename and t.id = "+tmpid+" and viewtype = 1 "); // 查询工作流单据表的信息
   	}else{//是系统表单,查询是否是明细表字段属性
   		rs2.executeSql("select * from workflow_formdictdetail where id= "+tmpid);
   	} 
   	 //如果是明细表字段,进行下面的处理.
   	if (rs2.next()){ 
   		String tempsql = WorkFlowUtil.getQuerySqlCondition("dt", htmltype,  type,
   				 tmpid,  tmpopt,  tmpopt1,  tmpvalue,
   				 tmpvalue1,  tmpcolname,  isoracle,  isdb2);	
   		//如果是单据,添加明细表的条件!!
   		 if(isbill.equals("1")){
   				//得到明细字段的列名.
   				String fdname = rs2.getString("fieldname");
   				//明细表名
   				String dtname = rs2.getString("detailtable");
   				//主表名
   				String tbname = rs2.getString("tablename");
   				//主表明细表关联属性
   				String dkeyfield = rs2.getString("detailkeyfield"); 
   				sqlwhere+=" and exists( select 1 from "+dtname+" dt where dt."+dkeyfield +"=d.id "+tempsql+") ";
   		 }else{
   			//得到系统表单的明细表属性列名
   			String dtfieldname = rs2.getString("fieldname");
   			//系统表单的明细表就是一张表,叫做Workflow_formdetail,主表和明细表是通过requestid关联.
   			sqlwhere+=" and exists( select 1 from Workflow_formdetail dt where dt.requestid=t1.requestid "+tempsql+") ";
   		}
  	}else{   //不是明细表字段进行下面的处理.
   		sqlwhere += WorkFlowUtil.getQuerySqlCondition("d", htmltype,  type,
   				 tmpid,  tmpopt,  tmpopt1,  tmpvalue,
   				 tmpvalue1,  tmpcolname,  isoracle,  isdb2);
   	}  
 	}
} 

//自定查询的数据源表的别名
final String CUSTOM_TABLE_NAME_ALIAS = "ctna";
//获取自定义查询条件的数据源表
String customTableName = "";
if(isbill.equals("0")){
  customTableName = "workflow_form";
}else{
  RecordSet.execute("select tablename from workflow_bill where id=" + formID);
  if(RecordSet.next()){
    customTableName = RecordSet.getString("tablename");
  }
}


//获取自定查询定义的需要展现的字段
String customFieldQuerySql = "";
if( isbill.equals("0") ){
  customFieldQuerySql = "select fieldname,fieldid,fieldhtmltype,type,fielddbtype from workflow_customdspfield wc"
                      + " inner join  workflow_formdict wf on wf.id=wc.fieldid and wc.customid="+customid+" and wc.ifshow=1"
                      + " order by wc.showorder asc";
}else{ 
  customFieldQuerySql = "select fieldname,fieldid,fieldhtmltype,type,fielddbtype from workflow_customdspfield wc"
                      + " inner join workflow_billfield wb on wc.fieldid=wb.id and wc.customid="+customid+" and wc.ifshow=1"
                      + " where wb.billid=" + formID
                      + " order by wc.showorder asc";
}

RecordSet.execute(customFieldQuerySql);
//拼接自定义查询中定义的需要展现的字段名称
String fieldNameList = "";
while(RecordSet.next()){
    //QC164444
    //防止字段名字冲突
    //fieldNameList += ( CUSTOM_TABLE_NAME_ALIAS + "." +RecordSet.getString("fieldname") + ",");
    fieldNameList += ( CUSTOM_TABLE_NAME_ALIAS + "." +RecordSet.getString("fieldname") + " as " + CUSTOM_TABLE_NAME_ALIAS + "_" + RecordSet.getString("fieldname") + ",");
  
  fieldids.add(RecordSet.getString("fieldid"));
  fieldhtmltypes.add(RecordSet.getString("fieldhtmltype"));
  fieldtypes.add(RecordSet.getString("type"));
  fielddbtypes.add(RecordSet.getString("fielddbtype"));
}
if(fieldNameList.length() > 0){
  fieldNameList = fieldNameList.substring(0, fieldNameList.length() - 1);
} 

//获取自定查询定义的需要展现字段的中文名称
String customFieldLabelQuerySql = "";
if(isbill.equals("0")){
  customFieldLabelQuerySql = "select wf.fieldlable from workflow_fieldlable wf"
                           + " inner join workflow_customdspfield wc on wf.fieldid=wc.fieldid and wc.customid="+customid+" and wc.ifshow=1"
                           + " where wf.formid="+formID+" and wf.langurageid="+user.getLanguage()+" order by wc.showorder asc";
}else{
  customFieldLabelQuerySql = "select hl.labelname fieldlable from workflow_customdspfield wc"
                           + " inner join workflow_billfield wb on wb.id=wc.fieldid and wc.customid="+customid+" and wc.ifshow=1"
                           + " inner join htmllabelInfo hl on hl.indexid=wb.fieldlabel"
                           + " where languageid="+user.getLanguage()+" order by wc.showorder asc";
}
RecordSet.execute(customFieldLabelQuerySql);
String fieldLabelList = "";
while(RecordSet.next()){
  fieldLabelList += (RecordSet.getString("fieldlable") + ",");
}
if(fieldLabelList.length() > 0){
  fieldLabelList = fieldLabelList.substring(0, fieldLabelList.length() - 1);
} 

//查询符合自定查询条件的requesetid
String querySql = "";
if(isbill.equals("0")){
  querySql = "select requestid from workflow_form d where d.billformid=" + formID + sqlwhere;
}else{
  RecordSet.execute("select tablename from workflow_bill where id = " + formID);
  String tableName = "";
  if(RecordSet.next()){
    tableName = RecordSet.getString("tablename");
  }

  querySql = "select requestid from "+tableName+" d where 1=1 " + sqlwhere;
}
//System.out.println("debug-sql:" + querySql);
RecordSet.execute(querySql);

String requestIdList = "(" + querySql + ")";

request.setAttribute("CustomSearch_IsNeed", "true");
request.setAttribute("CustomSearch_TableNameAlias", CUSTOM_TABLE_NAME_ALIAS);
request.setAttribute("CustomSearch_TableName", customTableName);
request.setAttribute("CustomSearch_FieldLabelList", fieldLabelList);
request.setAttribute("CustomSearch_FieldNameList", fieldNameList);
request.setAttribute("CustomSearch_RequestIdList", requestIdList);
request.setAttribute("CUSTOMSEARCH_FIELDIDS", fieldids);
request.setAttribute("CUSTOMSEARCH_FIELDHTMLTYPES", fieldhtmltypes);
request.setAttribute("CUSTOMSEARCH_FIELDTYPES", fieldtypes);
request.setAttribute("CUSTOMSEARCH_FIELDDBTYPES", fielddbtypes);

request.getRequestDispatcher("WFSearchShow.jsp").forward(request, response);  
%>