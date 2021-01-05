
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.common.xtable.*" %>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<link rel='stylesheet' type='text/css' href='/js/extjs/resources/css/ext-all_wev8.css' />
		<link rel='stylesheet' type='text/css' href='/js/extjs/resources/css/xtheme-gray_wev8.css'/>
		<link rel='stylesheet' type='text/css' href='/css/weaver-ext_wev8.css' />
		<script type='text/javascript' src='/js/extjs/adapter/ext/ext-base_wev8.js'></script>
		<script type='text/javascript' src='/js/extjs/ext-all_wev8.js'></script>   
		<%
   			if (user.getLanguage() == 7) {
   		%>
			<script type='text/javascript' src='/js/extjs/build/locale/ext-lang-zh_CN_gbk_wev8.js'></script>
			<script type='text/javascript' src='/js/weaver-lang-cn-gbk_wev8.js'></script>
		<%
			} else if (user.getLanguage() == 8) {
		%>
			<script type='text/javascript' src='/js/extjs/build/locale/ext-lang-en_wev8.js'></script>
			<script type='text/javascript' src='/js/weaver-lang-en-gbk_wev8.js'></script>
		<%
			}
		%>
		<script type="text/javascript" src="/js/WeaverTableExt_wev8.js"></script>  
		<link rel="stylesheet" type="text/css" href="/css/weaver-ext-grid_wev8.css" />
	</HEAD>
	<%
		String imagefilename = "/images/hdDOC_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(26180, user.getLanguage());
		String needfav = "1";
		String needhelp = "";
	%>
	<BODY style="overflow: hidden;">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			//RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:onReSearch(),_top} " ;
			//RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<%
			/**
			String sql = "select t1.id, t1.name,t1.type,t1.manager,t1.status,t1.createdate " 
				+ " from CRM_CustomerInfo t1 " 
				+ " where (t1.deleted=0 or t1.deleted is null) and (t1.source = 20 or t1.source = 8 or t1.source = 19 or t1.source = 30 or t1.source = 31) and t1.manager=" + user.getUID() 
				+ " and not exists (select t2.customerId from CRM_CustomerFeedback t2 where t2.customerId=t1.id and (t2.isValid=0 or t2.isValid=1))" 
				+ " order by t1.createdate desc";
			*/
			//String sql = "select distinct t1.id,t1.name,t1.type,t1.manager,t1.status,t1.createdate from CRM_CustomerInfo t1 where t1.manager=80 and t1.id not in(select id from CRM_ViewLog1) order by t1.createdate";
			//System.out.println("sql = " + sql);
			
			String backfields = "t1.id,t1.name,t1.type,t1.manager,t1.status,t1.createdate";
			String fromSql = " CRM_CustomerInfo t1";
			String sqlWhere	= " where (t1.deleted=0 or t1.deleted is null) and (t1.source = 20 or t1.source = 8 or t1.source = 19 or t1.source = 30 or t1.source = 31) and t1.manager=" + user.getUID() 
				+ " and not exists (select t2.customerId from CRM_CustomerFeedback t2 where t2.customerId=t1.id and (t2.isValid=0 or t2.isValid=1))";	
			String orderby = " t1.createdate ";
			//RecordSet.executeSql(sql);
		%>
		<table width=100% height=96% border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10">
				<col width="">
				<col width="10">
			</colgroup>
			<tbody>
			<tr style="height: 10px;">
				<td height="10" colspan="3"></td>
			</tr>
			<tr>
				<td></td>
				<td valign="top">
					<TABLE class=Shadow>
						<tr>
							<td valign="top">
							<TABLE class="ViewForm" id="searchTable"></TABLE>
								<%
									ArrayList xTableColumnList = new ArrayList();

									TableColumn xTableColumn_1 = new TableColumn();
									xTableColumn_1.setColumn("id");
									xTableColumn_1.setDataIndex("id");
									xTableColumn_1.setHeader(SystemEnv.getHtmlLabelName(1268, user.getLanguage()));
									xTableColumn_1.setTransmethod("weaver.cs.util.CommonTransUtil.transCustomerId");
									xTableColumn_1.setPara_1("column:id");
									xTableColumn_1.setSortable(false);
									xTableColumn_1.setWidth(0.015);
									xTableColumn_1.setHideable(true);
									xTableColumnList.add(xTableColumn_1);
									
									TableColumn xTableColumn_2 = new TableColumn();
									xTableColumn_2.setColumn("type");
									xTableColumn_2.setDataIndex("type");
									xTableColumn_2.setHeader(SystemEnv.getHtmlLabelName(63, user.getLanguage()));
									xTableColumn_2.setTransmethod("weaver.crm.Maint.CustomerTypeComInfo.getCustomerTypename");
									xTableColumn_2.setPara_1("column:type");
									xTableColumn_2.setSortable(false);
									xTableColumn_2.setWidth(0.007);
									xTableColumn_2.setHideable(true);
									xTableColumnList.add(xTableColumn_2);
									
									TableColumn xTableColumn_3 = new TableColumn();
									xTableColumn_3.setColumn("manager");
									xTableColumn_3.setDataIndex("manager");
									xTableColumn_3.setHeader(SystemEnv.getHtmlLabelName(1278, user.getLanguage()));
									xTableColumn_3.setTransmethod("weaver.cs.util.CommonTransUtil.transCustomerManager");
									xTableColumn_3.setPara_1("column:id");
									xTableColumn_3.setSortable(false);
									xTableColumn_3.setWidth(0.007);
									xTableColumn_3.setHideable(true);
									xTableColumnList.add(xTableColumn_3);
									
									TableColumn xTableColumn_4 = new TableColumn();
									xTableColumn_4.setColumn("status");
									xTableColumn_4.setDataIndex("status");
									xTableColumn_4.setHeader(SystemEnv.getHtmlLabelName(1929, user.getLanguage()));
									xTableColumn_4.setTransmethod("weaver.crm.Maint.CustomerStatusComInfo.getCustomerStatusname");
									xTableColumn_4.setPara_1("column:status");
									xTableColumn_4.setSortable(true);
									xTableColumn_4.setWidth(0.007);
									xTableColumn_4.setHideable(true);
									xTableColumnList.add(xTableColumn_4);
									
									TableColumn xTableColumn_5 = new TableColumn();
									xTableColumn_5.setColumn("createdate");
									xTableColumn_5.setDataIndex("createdate");
									xTableColumn_5.setHeader(SystemEnv.getHtmlLabelName(722, user.getLanguage()));
									xTableColumn_5.setSortable(true);
									xTableColumn_5.setWidth(0.007);
									xTableColumn_5.setHideable(true);
									xTableColumnList.add(xTableColumn_5);
									
									TableSql xTableSql = new TableSql();
									xTableSql.setBackfields(backfields);
									xTableSql.setPageSize(20);
									xTableSql.setSqlform(fromSql);
									xTableSql.setSqlwhere(sqlWhere);
									xTableSql.setSqlprimarykey("t1.id");
									xTableSql.setSqlisdistinct("false");
									xTableSql.setDir(TableConst.DESC);
									xTableSql.setSort(orderby);

									Table xTable = new Table(request);

									xTable.setTableGridType(TableConst.NONE);
									xTable.setTableNeedRowNumber(true);
									xTable.setTableSql(xTableSql);
									xTable.setTableColumnList(xTableColumnList);
								%>
								<%=xTable.myToString("40")%>
								
							</td>
						</tr>
					</TABLE>
				</td>
				<td></td>
			</tr>
			<tr>
				<td height="10" colspan="3"></td>
			</tr>
			</tbody>
		</table>
	</body>
	<script type="text/javascript">
		function onRefresh(){
			document.location = "/CRM/data/NoFeedbackList.jsp";
		}
	</script>
</html>