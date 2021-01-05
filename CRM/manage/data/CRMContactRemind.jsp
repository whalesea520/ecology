
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.common.xtable.*" %>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
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
		/**
		String currUserId = String.valueOf(user.getUID());
		String loginType = user.getLogintype();
		String sql = "";

		ArrayList crmids = new ArrayList();
		ArrayList lastcontactdate = new ArrayList();

		ArrayList crmIds = new ArrayList();
		ArrayList befores = new ArrayList();

		ArrayList contactDates = new ArrayList();

		if (!user.getLogintype().equals("2"))
			sql = "SELECT DISTINCT t1.id, t2.before, t2.lastestContactDate FROM CRM_CustomerInfo t1, CRM_ContacterLog_Remind t2" + " WHERE t1.id = t2.customerid AND t1.manager = " + currUserId + " AND t1.deleted <> 1 AND t2.isremind = 0";
		else
			sql = "SELECT DISTINCT t1.id, t2.before, t2.lastestContactDate FROM CRM_CustomerInfo t1, CRM_ContacterLog_Remind t2" + " WHERE t1.id = t2.customerid AND t1.agent = " + currUserId + " AND t1.deleted <> 1 AND t2.isremind = 0";

		//rs.writeLog(sql);

		rs.executeSql(sql);
		while (rs.next()) {
			crmIds.add(rs.getString(1));
			befores.add(rs.getString(2));
			contactDates.add(Util.null2String(rs.getString(3)));
		}

		Calendar currCal = Calendar.getInstance();
		Calendar tmpCal = Calendar.getInstance();
		int tmpYear = 0;
		int tmpMonth = 0;
		int tmpDate = 0;

		String m_crmId = "";
		String m_contactDate = "";
		int m_before = 0;

		for (int i = 0; i < crmIds.size(); i++) {
			m_crmId = (String) crmIds.get(i);
			m_contactDate = (String) contactDates.get(i);
			if (!m_contactDate.equals("")) {

				tmpYear = Util.getIntValue(m_contactDate.substring(0, 4));
				tmpMonth = Util.getIntValue(m_contactDate.substring(5, 7)) - 1;
				tmpDate = Util.getIntValue(m_contactDate.substring(8, 10));

				tmpCal.set(tmpYear, tmpMonth, tmpDate);

				m_before = Util.getIntValue((String) befores.get(i), 0);
				tmpCal.add(Calendar.DATE, m_before);

				if (tmpCal.before(currCal)) {
					crmids.add(m_crmId);
					lastcontactdate.add(m_contactDate);
				}
			} else {
				crmids.add(m_crmId);
				lastcontactdate.add("");
			}
		}
		*/

		String imagefilename = "/images/hdReport_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(16403, user.getLanguage());
		String needfav = "1";
		String needhelp = "";
		
		
		
		String backfields = "t1.id, t2.before, t2.lastestContactDate";
		String fromSql = " CRM_CustomerInfo t1, CRM_ContacterLog_Remind t2";
		String sqlWhere	= " where t1.id = t2.customerid and t1.deleted <> 1 AND t2.isremind = 0 and t1."+(!user.getLogintype().equals("2")?"manager":"agent")+" = " + user.getUID()
			+" and (t2.lastestContactDate is null or t2.lastestContactDate=''"
			+"  or t2.lastestContactDate < Convert(VARCHAR(10), DateAdd(\"d\",isnull(t2.before,0)*-1,GETDATE()),126))";
		String orderby = " t1.id ";
	%>

	<BODY style="overflow: hidden;">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

		<TABLE width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<COLGROUP>
				<COL width="10">
				<COL width="">
				<COL width="10">
			</COLGROUP>
			<TR>
				<TD height="10" colspan="3"></TD>
			</TR>
			<TR>
				<TD></TD>
				<TD valign="top">
					<TABLE class="Shadow">
						<TR>
							<TD valign="top">
								<TABLE class="ViewForm" id="searchTable"></TABLE>
								<%
									ArrayList xTableColumnList = new ArrayList();

									TableColumn xTableColumn_1 = new TableColumn();
									xTableColumn_1.setColumn("id");
									xTableColumn_1.setDataIndex("id");
									xTableColumn_1.setHeader(SystemEnv.getHtmlLabelName(6061, user.getLanguage()));
									xTableColumn_1.setTransmethod("weaver.cs.util.CommonTransUtil.transCustomerId");
									xTableColumn_1.setPara_1("column:id");
									xTableColumn_1.setSortable(false);
									xTableColumn_1.setWidth(0.015);
									xTableColumn_1.setHideable(true);
									xTableColumnList.add(xTableColumn_1);
									
									TableColumn xTableColumn_2 = new TableColumn();
									xTableColumn_2.setColumn("lastestContactDate");
									xTableColumn_2.setDataIndex("lastestContactDate");
									xTableColumn_2.setHeader(SystemEnv.getHtmlLabelName(15232, user.getLanguage()));
									xTableColumn_2.setSortable(false);
									xTableColumn_2.setWidth(0.007);
									xTableColumn_2.setHideable(true);
									xTableColumnList.add(xTableColumn_2);
									
									TableSql xTableSql = new TableSql();
									xTableSql.setBackfields(backfields);
									xTableSql.setPageSize(20);
									xTableSql.setSqlform(fromSql);
									xTableSql.setSqlwhere(sqlWhere);
									xTableSql.setSqlprimarykey("t1.id");
									xTableSql.setSqlisdistinct("true");
									xTableSql.setDir(TableConst.DESC);
									xTableSql.setSort(orderby);

									Table xTable = new Table(request);

									xTable.setTableGridType(TableConst.NONE);
									xTable.setTableNeedRowNumber(true);
									xTable.setTableSql(xTableSql);
									xTable.setTableColumnList(xTableColumnList);
								%>
								<%=xTable.myToString("40")%>
							</TD>
						</TR>
					</TABLE>
				</TD>
				<TD></TD>
			</TR>
		</TABLE>
	</BODY>
</HTML>