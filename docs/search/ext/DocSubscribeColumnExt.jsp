
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@ page import="weaver.general.*"%>
<%@ page import="weaver.docs.docSubscribe.*"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.common.xtable.*"%>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<%
	ArrayList xTableColumnList = new ArrayList();
	ArrayList xTableOperationList = new ArrayList();
	ArrayList xTableToolBarList = new ArrayList();
	TableSql xTableSql = new TableSql();
	Table xTable = new Table(request);
	User user = HrmUserVarify.getUser (request , response) ;
	if(user==null){
		return;
	}
%>
<%
	TableColumn xTableColumn_Id = new TableColumn();
	xTableColumn_Id.setColumn("docid");
	xTableColumn_Id.setDataIndex("docid");
	xTableColumn_Id.setHeader("&nbsp;&nbsp;");
	xTableColumn_Id
			.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocIcon");
	xTableColumn_Id.setPara_1("column:id");
	xTableColumn_Id.setSortable(false);
	xTableColumn_Id.setHideable(true);
	xTableColumn_Id.setWidth(0.03);
	xTableColumnList.add(xTableColumn_Id);
	
	TableColumn xTableColumn_Docsubject = new TableColumn();
	xTableColumn_Docsubject.setColumn("docsubject");
	xTableColumn_Docsubject.setDataIndex("docsubject");
	xTableColumn_Docsubject.setHeader(SystemEnv.getHtmlLabelName(58,
			user.getLanguage()));
	xTableColumn_Docsubject.setSortable(true);
	xTableColumn_Docsubject.setHideable(true);
	xTableColumn_Docsubject.setWidth(0.3);
	xTableColumnList.add(xTableColumn_Docsubject);
	
	TableColumn xTableColumn_OwnerId = new TableColumn();
	xTableColumn_OwnerId.setColumn("t1$&$ownerId");
	xTableColumn_OwnerId.setDataIndex("t1$&$ownerId");
	xTableColumn_OwnerId.setHeader(SystemEnv.getHtmlLabelName(2094,
			user.getLanguage()));
	xTableColumn_OwnerId
			.setTransmethod("weaver.splitepage.transform.SptmForDoc.getName");
	xTableColumn_OwnerId.setPara_1("column:ownerId");
	xTableColumn_OwnerId.setPara_2("column:usertype");
	xTableColumn_OwnerId.setSortable(true);
	xTableColumn_OwnerId.setHideable(true);
	xTableColumn_OwnerId.setWidth(0.15);
	xTableColumnList.add(xTableColumn_OwnerId);

	TableColumn xTableColumn_Doccreatedate = new TableColumn();
	xTableColumn_Doccreatedate.setColumn("doccreatedate");
	xTableColumn_Doccreatedate.setDataIndex("doccreatedate");
	xTableColumn_Doccreatedate.setHeader(SystemEnv.getHtmlLabelName(
			722, user.getLanguage()));
	xTableColumn_Doccreatedate.setSortable(true);
	xTableColumn_Doccreatedate.setHideable(true);
	xTableColumn_Doccreatedate.setWidth(0.15);
	xTableColumnList.add(xTableColumn_Doccreatedate);

	TableColumn xTableColumn_Doclastmoddate = new TableColumn();
	xTableColumn_Doclastmoddate.setColumn("doclastmoddate");
	xTableColumn_Doclastmoddate.setDataIndex("doclastmoddate");
	xTableColumn_Doclastmoddate.setHeader(SystemEnv.getHtmlLabelName(
			723, user.getLanguage()));
	xTableColumn_Doclastmoddate.setSortable(true);
	xTableColumn_Doclastmoddate.setHideable(true);
	xTableColumn_Doclastmoddate.setWidth(0.15);
	xTableColumnList.add(xTableColumn_Doclastmoddate);

	TableColumn xTableColumn_Replaydoccount = new TableColumn();
	xTableColumn_Replaydoccount.setColumn("replaydoccount");
	xTableColumn_Replaydoccount.setDataIndex("replaydoccount");
	xTableColumn_Replaydoccount.setTransmethod("weaver.splitepage.transform.SptmForDoc.getAllEditionReplaydocCount");
	xTableColumn_Replaydoccount.setPara_1("column:id");
	xTableColumn_Replaydoccount.setPara_2("column:replaydoccount");
	xTableColumn_Replaydoccount.setHeader(SystemEnv.getHtmlLabelName(
			117, user.getLanguage()));
	xTableColumn_Replaydoccount.setSortable(false);
	xTableColumn_Replaydoccount.setHideable(true);
	xTableColumn_Replaydoccount.setWidth(0.1);
	xTableColumnList.add(xTableColumn_Replaydoccount);

	/*
	TableColumn xTableColumn_Docpublishtype = new TableColumn();
	xTableColumn_Docpublishtype.setColumn("docpublishtype");
	xTableColumn_Docpublishtype.setDataIndex("docpublishtype");
	xTableColumn_Docpublishtype.setHeader(SystemEnv.getHtmlLabelName(
			602, user.getLanguage()));
	xTableColumn_Docpublishtype
			.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocPublicType");
	xTableColumn_Docpublishtype.setPara_1("column:docpublishtype");
	xTableColumn_Docpublishtype.setPara_2(user.getLanguage() + "");
	xTableColumn_Docpublishtype.setSortable(true);
	xTableColumn_Docpublishtype.setHideable(true);
	xTableColumn_Docpublishtype.setWidth(0.1);
	xTableColumnList.add(xTableColumn_Docpublishtype);
	*/
	
	TableColumn xTableColumn_DocStatus = new TableColumn();
	xTableColumn_DocStatus.setColumn("docstatus");
	xTableColumn_DocStatus.setDataIndex("docstatus");
	xTableColumn_DocStatus.setHeader(SystemEnv.getHtmlLabelName(
			602, user.getLanguage()));
	xTableColumn_DocStatus
			.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocStatus3");
	xTableColumn_DocStatus.setPara_1("column:id");
	xTableColumn_DocStatus.setPara_2(user.getLanguage() + "+column:docstatus+column:seccategory");
	xTableColumn_DocStatus.setSortable(true);
	xTableColumn_DocStatus.setHideable(true);
	xTableColumn_DocStatus.setWidth(0.1);
	xTableColumnList.add(xTableColumn_DocStatus);
	
	int pagesize = UserDefaultManager.getNumperpage();
	
    if(pagesize <2) pagesize=10;              
	xTable.setTableNeedRowNumber(true);
	xTableSql.setBackfields("t1.id, t1.docsubject,t1.doccreaterid,t1.doccreatedate,t1.doclastmoddate,t1.seccategory,t1.replaydoccount,t1.docpublishtype,t1.ownerId,t1.usertype");
	xTableSql.setPageSize(pagesize);
	xTableSql.setDir(TableConst.DESC);
	xTableSql.setSort("doccreatedate");
	xTableSql.setSqlprimarykey("t1.id");
	xTableSql.setSqlisdistinct("true");
	xTable.setTableSql(xTableSql);
	xTable.setTableColumnList(xTableColumnList);
	xTable.setTableGridType(TableConst.CHECKBOX);
	xTable.setUser(user);
	xTable.setTableId("docsubscribe");
	
%>
<%
	out.println(xTable.toString2("_table"));
	return;
%>