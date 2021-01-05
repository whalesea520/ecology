<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="DocDetailLog" class="weaver.docs.DocDetailLog" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />

<%@ page import="weaver.common.xtable.*" %>		
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<link rel='stylesheet' type='text/css' href='/js/extjs/resources/css/ext-all_wev8.css' />
<link rel='stylesheet' type='text/css' href='/css/weaver-ext_wev8.css' />
<link rel='stylesheet' type='text/css' href='/js/extjs/resources/css/xtheme-gray_wev8.css'/>
<script type='text/javascript' src='/js/extjs/adapter/ext/ext-base_wev8.js'></script>
<script type='text/javascript' src='/js/extjs/ext-all_wev8.js'></script>   
<jsp:include page="/systeminfo/ExtLangJS.jsp">
    <jsp:param name="languageId" value="<%=user.getLanguage()%>" />
</jsp:include>
<jsp:include page="/systeminfo/WeaverLangJS.jsp">
    <jsp:param name="languageId" value="<%=user.getLanguage()%>" />
</jsp:include>
 <script type="text/javascript" src="/js/WeaverTableExt_wev8.js"></script>  
 <%
	 ArrayList xTableColumnList=new ArrayList();
 %>
<!--声明结束-->

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript">
function onSave(){

}
</script>
</head>
<%
String subname="";

String subject= Util.null2String(request.getParameter("docsubject"));


String sqlWhere = "";
boolean boo=Util.null2String(request.getParameter("flag")).equals("1");
sqlWhere = Util.fromScreen(request.getParameter("sqlwhere"),user.getLanguage());

int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getPerpageLog();
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(83,user.getLanguage());
String needfav ="1";
String needhelp ="";
String docid="0";
if(RecordSet.getDBType().equals("oracle") )
    RecordSet.executeSql("select docid from DocDetailLog "+sqlWhere + " and rownum<2") ;
else
    RecordSet.executeSql("select top 1 docid from DocDetailLog "+sqlWhere) ;
if(RecordSet.next())
    docid=RecordSet.getString("docid");

if(docid!=null&&Util.getIntValue(docid)>0){
RecordSet.executeSql("select seccategory from DocDetail where id = "+docid);
RecordSet.next();
if(SecCategoryComInfo.getLogviewtype(Util.getIntValue(RecordSet.getString(1)))==1&&!user.getLoginid().equalsIgnoreCase("sysadmin")){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

if(!"".equals(docid))
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/docs/docs/DocDsp.jsp?id="+docid+",_self} " ;
else
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%
	
	if(boo)
		sqlWhere+=" and operatetype=0";
		
		String backfields = "id,operatedate,operatetime,operateuserid,operatetype,docid,docsubject,clientaddress,usertype,creatertype";
		String fromSql  = "";
		fromSql  = " from DocDetailLog";
		String orderby = "operatedate ,operatetime" ;
		
		TableColumn xTableColumn_OperateDate=new TableColumn();
		xTableColumn_OperateDate.setColumn("operatedate");
		xTableColumn_OperateDate.setDataIndex("operatedate");
		xTableColumn_OperateDate.setHeader(SystemEnv.getHtmlLabelName(97,user.getLanguage()));
		xTableColumn_OperateDate.setTransmethod("weaver.docs.DocDetailLogTransMethod.getDateTime");
		xTableColumn_OperateDate.setPara_1("column:operatedate");
		xTableColumn_OperateDate.setPara_2("column:operatetime");
		xTableColumn_OperateDate.setSortable(true);		
		xTableColumn_OperateDate.setWidth(0.20); 
		xTableColumnList.add(xTableColumn_OperateDate);
		
		TableColumn xTableColumn_OperateuserId = new TableColumn();
		xTableColumn_OperateuserId.setColumn("operateuserid");
		xTableColumn_OperateuserId.setDataIndex("operateuserid");
		xTableColumn_OperateuserId.setHeader(SystemEnv.getHtmlLabelName(99,user.getLanguage()));
		//xTableColumn_OperateuserId.setTransmethod("weaver.docs.DocDetailLogTransMethod.getUserName");
		xTableColumn_OperateuserId.setTransmethod("weaver.splitepage.transform.SptmForDoc.getName");
		xTableColumn_OperateuserId.setPara_1("column:operateuserid");
		xTableColumn_OperateuserId.setPara_2("column:usertype");	
		xTableColumn_OperateuserId.setSortable(true);
		xTableColumn_OperateuserId.setWidth(0.15); 
		xTableColumnList.add(xTableColumn_OperateuserId);
				
		TableColumn xTableColumn_OperateType = new TableColumn();		
		xTableColumn_OperateType.setColumn("operatetype");
		xTableColumn_OperateType.setDataIndex("operatetype");
		xTableColumn_OperateType.setHeader(SystemEnv.getHtmlLabelName(63,user.getLanguage()));
		xTableColumn_OperateType.setTransmethod("weaver.docs.DocDetailLogTransMethod.getDocStatus");
		xTableColumn_OperateType.setPara_1("column:operatetype");
		xTableColumn_OperateType.setPara_2(Integer.toString(user.getLanguage()));
		xTableColumn_OperateType.setSortable(true);
		xTableColumn_OperateType.setWidth(0.10);
		xTableColumnList.add(xTableColumn_OperateType);
		
		TableColumn xTableColumn_DocId = new TableColumn();		
		xTableColumn_DocId.setColumn("docid");
		xTableColumn_DocId.setDataIndex("docid");
		xTableColumn_DocId.setHeader(SystemEnv.getHtmlLabelName(84,user.getLanguage()));
		xTableColumn_DocId.setTransmethod("weaver.docs.DocDetailLogTransMethod.getDocId");
		xTableColumn_DocId.setPara_1("column:docid");
		xTableColumn_DocId.setSortable(true);
		xTableColumn_DocId.setWidth(0.15);
		xTableColumnList.add(xTableColumn_DocId);
	
		TableColumn xTableColumn_DocSubject = new TableColumn();		
		xTableColumn_DocSubject.setColumn("docid");
		xTableColumn_DocSubject.setDataIndex("docid");
		xTableColumn_DocSubject.setHeader(SystemEnv.getHtmlLabelName(229,user.getLanguage()));
		xTableColumn_DocSubject.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocName");
		xTableColumn_DocSubject.setPara_1("column:docid");
		xTableColumn_DocSubject.setSortable(true);
		xTableColumn_DocSubject.setWidth(0.30);
		xTableColumnList.add(xTableColumn_DocSubject);
		
		TableColumn xTableColumn_ClientAddress = new TableColumn();		
		xTableColumn_ClientAddress.setColumn("clientaddress");
		xTableColumn_ClientAddress.setDataIndex("clientaddress");
		xTableColumn_ClientAddress.setHeader(SystemEnv.getHtmlLabelName(108,user.getLanguage())+SystemEnv.getHtmlLabelName(110,user.getLanguage()));	
		xTableColumn_ClientAddress.setSortable(true);
		xTableColumn_ClientAddress.setWidth(0.10);
		xTableColumnList.add(xTableColumn_ClientAddress);
		
		TableSql xTableSql=new TableSql();
		xTableSql.setBackfields(backfields);
		xTableSql.setPageSize(perpage);
		xTableSql.setSqlform(fromSql);
		xTableSql.setSqlwhere(sqlWhere);
		xTableSql.setSqlgroupby("");
		xTableSql.setSqlprimarykey("id");
		xTableSql.setSqlisdistinct("true");
		xTableSql.setDir(TableConst.DESC);
		xTableSql.setSort(orderby);
		
		Table xTable=new Table(request); 
		xTable.setTableId("xTable_DocDetailLog");
		xTable.setTableGridType(TableConst.NONE);
		xTable.setTableNeedRowNumber(true);												
		xTable.setTableSql(xTableSql);
		xTable.setTableColumnList(xTableColumnList);
		xTable.setUser(user);				
%>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
			<tr>
				<td valign="top">
		        <%=xTable.toString()%>
				</td>
			</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
</BODY>
</HTML>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>