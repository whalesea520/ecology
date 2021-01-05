
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.common.xtable.*" %>		
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="cmutil" class="weaver.crm.util.TransUtil" scope="page" />
<jsp:useBean id="ContactWayComInfo" class="weaver.crm.Maint.ContactWayComInfo" scope="page" />
<%
	if (!HrmUserVarify.checkUserRight("CRM_CustomerSourceSearch", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<link rel='stylesheet' type='text/css' href='/js/extjs/resources/css/ext-all_wev8.css' />
		<link rel='stylesheet' type='text/css' href='/js/extjs/resources/css/xtheme-gray_wev8.css'/>
		<link rel='stylesheet' type='text/css' href='/css/weaver-ext_wev8.css' />
		<script type='text/javascript' src='/js/extjs/adapter/ext/ext-base_wev8.js'></script>
		<script type='text/javascript' src='/js/extjs/ext-all_wev8.js'></script>   
		<%if(user.getLanguage()==7) {%>
			<script type='text/javascript' src='/js/extjs/build/locale/ext-lang-zh_CN_gbk_wev8.js'></script>
			<script type='text/javascript' src='/js/weaver-lang-cn-gbk_wev8.js'></script>
		<%} else if(user.getLanguage()==8) {%>
			<script type='text/javascript' src='/js/extjs/build/locale/ext-lang-en_wev8.js'></script>
			<script type='text/javascript' src='/js/weaver-lang-en-gbk_wev8.js'></script>
		<%} else if(user.getLanguage()==9) {%>
			<script type='text/javascript' src='/js/extjs/build/locale/ext-lang-zh_TW_wev8.js'></script>
			<script type='text/javascript' src='/js/weaver-lang-tw-gbk_wev8.js'></script>
		<%}%>
		<script type="text/javascript" src="/js/WeaverTableExt_wev8.js"></script>  
		<link rel="stylesheet" type="text/css" href="/css/weaver-ext-grid_wev8.css" />
	</head>
	<%
		String imagefilename = "/images/hdReport_wev8.gif";
		String titlename = "客户来源查询";
		String needfav = "1";
		String needhelp = "";
		
		int perpage=20;
		
		String crmname = Util.fromScreen3(request.getParameter("crmname"), user.getLanguage());
		String manager = Util.fromScreen3(request.getParameter("manager"), user.getLanguage());
		String creater = Util.fromScreen3(request.getParameter("creater"), user.getLanguage());
		String source = Util.fromScreen3(request.getParameter("source"), user.getLanguage());
		
		String backfields = " t.id,t.name,t.manager,t.source,t.status,t.deleted,l.submiter as creater,l.submitdate  ";
		String fromSql = " CRM_CustomerInfo t left join CRM_Log l on t.id=l.customerid and l.logtype = 'n'";
		String orderby = " t.id";
		String sqlWhere = "where 1=1 ";

		if(!crmname.equals("")){
			if(crmname.indexOf("+")>0){
				String[] ands = crmname.split("\\+");
				if(ands.length>0){
					sqlWhere += " and ( ";
					for(int i=0;i<ands.length;i++){
						if(i == 0){
							sqlWhere += " t.name like '%" + ands[i] + "%'";
						}else{
							sqlWhere += " and t.name like '%" + ands[i] + "%'";
						}
					}
					sqlWhere += " ) ";
				}
			}else{
				String[] ors = crmname.split(" ");
				if(ors.length>0){
					sqlWhere += " and ( ";
					for(int i=0;i<ors.length;i++){
						if(i == 0){
							sqlWhere += " t.name like '%" + ors[i] + "%'";
						}else{
							sqlWhere += " or t.name like '%" + ors[i] + "%'";
						}
					}
					sqlWhere += " ) ";
				}
			}
		}
		
		if(!manager.equals("")){
			sqlWhere += " and t.manager ="+manager;
		}
		if(!creater.equals("")){
			sqlWhere += " and l.submiter ="+creater;
		}
		if(!source.equals("")){
			sqlWhere += " and t.source ="+source;
		}
	%>
	<BODY  style="overflow: hidden">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ",javascript:onSearch();,_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form id="frmMain" name="frmMain" action="CustomerSourceSearch.jsp" method="post">
		<table width=100% height=96% border="0" cellspacing="0" cellpadding="0" valign="top">
			<colgroup>
				<col width="10">
				<col width="">
				<col width="10">
			</colgroup>
			<tr style="height: 10px;">
				<td height="10" colspan="3"></td>
			</tr>
			<tr>
				<td></td>
				<td valign="top">
					<TABLE class=Shadow>
						<tr>
							<td valign="top">
								<TABLE class=ViewForm id=searchTable>
									<COLGROUP>
										<COL width="15%">
										<COL width="35%">
										<COL width="15%">
										<COL width="35%">
									</COLGROUP>
									<TBODY>
										<TR>
											<TD>客户名称</TD>
											<TD class="Field">
												<INPUT class=inputstyle type=text id=crmname name=crmname value="<%=crmname%>" style="width:95%" maxlength="20"/>
											</TD>
											<TD>来源</TD>
          									<TD class=Field>
              									<INPUT type=hidden class="wuiBrowser" _displayText="<%=ContactWayComInfo.getContactWaydesc(source)%>" 
              										_url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/ContactWayBrowser.jsp" 
              										name="source" value="<%=source%>">
              								</TD>
        								</TR>
        								<tr style="height: 1px;"><td class=Line colspan=4></td></tr>
        								<TR>
											<TD>客户经理</TD>
											<TD class=Field>
												<INPUT class="wuiBrowser" type="hidden" id="manager" name="manager" value="<%=manager %>"
													_displayTemplate="<A href='javaScript:openhrm(#b{id})' onclick='pointerXY(event)'>#b{name}</A>" 
								          	 		_displayText="<%=cmutil.getPerson(manager) %>" _param="resourceids" 
								          	 		_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" />
											</TD>
											<TD>创建人</TD>
											<TD class=Field>
												<INPUT class="wuiBrowser" type="hidden" id="creater" name="creater" value="<%=creater %>"
													_displayTemplate="<A href='javaScript:openhrm(#b{id})' onclick='pointerXY(event)'>#b{name}</A>" 
								          	 		_displayText="<%=cmutil.getPerson(creater) %>" _param="resourceids" 
								          	 		_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" />
											</TD>
										</TR>
										<tr style="height: 1px;"><td class=Line colspan=4></td></tr>
									</TBODY>
								</TABLE>
							<%if(!crmname.equals("")){ %>
											<%
												//System.out.println("recordList_sql:"+ "select "+backfields+" from "+fromSql+ sqlWhere);
											
												ArrayList xTableColumnList=new ArrayList();
												

												TableColumn xTableColumn_customerName=new TableColumn();
												xTableColumn_customerName.setColumn("id");
												xTableColumn_customerName.setDataIndex("id");
												xTableColumn_customerName.setHeader(SystemEnv.getHtmlLabelName(24974,user.getLanguage()));
												xTableColumn_customerName.setTransmethod("weaver.crm.util.TransUtil.getCustomerLink");
												xTableColumn_customerName.setPara_1("column:id");
												xTableColumn_customerName.setPara_2("column:name");
												xTableColumn_customerName.setSortable(true);
												xTableColumn_customerName.setHideable(false);
												xTableColumn_customerName.setWidth(0.01); 
												xTableColumnList.add(xTableColumn_customerName);
												
												TableColumn xTableColumn_customerManager=new TableColumn();
												xTableColumn_customerManager.setColumn("manager");
												xTableColumn_customerManager.setDataIndex("manager");
												xTableColumn_customerManager.setHeader("客户经理");
												xTableColumn_customerManager.setTransmethod("weaver.crm.util.TransUtil.getPerson");
												xTableColumn_customerManager.setPara_1("column:manager");
												xTableColumn_customerManager.setSortable(true);
												xTableColumn_customerManager.setHideable(true);
												xTableColumn_customerManager.setWidth(0.005); 
												xTableColumnList.add(xTableColumn_customerManager);
												
												TableColumn xTableColumn_creater=new TableColumn();
												xTableColumn_creater.setColumn("creater");
												xTableColumn_creater.setDataIndex("creater");
												xTableColumn_creater.setHeader("创建人");
												xTableColumn_creater.setTransmethod("weaver.crm.util.TransUtil.getPerson");
												xTableColumn_creater.setPara_1("column:creater");
												xTableColumn_creater.setSortable(true);
												xTableColumn_creater.setHideable(true);
												xTableColumn_creater.setWidth(0.005); 
												xTableColumnList.add(xTableColumn_creater);
												
												TableColumn xTableColumn_source2=new TableColumn();
												xTableColumn_source2.setColumn("source2");
												xTableColumn_source2.setDataIndex("source2");
												xTableColumn_source2.setHeader("初始来源");
												xTableColumn_source2.setTransmethod("weaver.crm.util.TransUtil.getCreateSource");
												xTableColumn_source2.setPara_1("column:id");
												xTableColumn_source2.setPara_2("column:source");
												xTableColumn_source2.setSortable(false);
												xTableColumn_source2.setHideable(false);
												xTableColumn_source2.setWidth(0.005); 
												xTableColumnList.add(xTableColumn_source2);
												
												TableColumn xTableColumn_source1=new TableColumn();
												xTableColumn_source1.setColumn("source");
												xTableColumn_source1.setDataIndex("source");
												xTableColumn_source1.setHeader("当前来源");
												xTableColumn_source1.setTransmethod("weaver.crm.Maint.ContactWayComInfo.getContactWayname");
												xTableColumn_source1.setPara_1("column:source");
												xTableColumn_source1.setSortable(true);
												xTableColumn_source1.setHideable(false);
												xTableColumn_source1.setWidth(0.005); 
												xTableColumnList.add(xTableColumn_source1);
												
												TableColumn xTableColumn_status=new TableColumn();
												xTableColumn_status.setColumn("status");
												xTableColumn_status.setDataIndex("status");
												xTableColumn_status.setHeader("状态");
												xTableColumn_status.setTransmethod("weaver.crm.util.TransUtil.getCustomerStatus");
												xTableColumn_status.setPara_1("column:status");
												xTableColumn_status.setPara_2("column:deleted");
												xTableColumn_status.setSortable(true);
												xTableColumn_status.setHideable(false);
												xTableColumn_status.setWidth(0.005); 
												xTableColumnList.add(xTableColumn_status);
												
												TableSql xTableSql=new TableSql();
												xTableSql.setBackfields(backfields);
												xTableSql.setPageSize(perpage);
												xTableSql.setSqlform(fromSql);
												xTableSql.setSqlwhere(sqlWhere);
												xTableSql.setSqlprimarykey("t.id");
												xTableSql.setSqlisdistinct("true");
												xTableSql.setSort(orderby);
												xTableSql.setDir(TableConst.ASC);

												Table xTable=new Table(request); 
												
												xTable.setTableGridType(TableConst.NONE);
												xTable.setTableNeedRowNumber(true);												
												xTable.setTableSql(xTableSql);
												xTable.setTableColumnList(xTableColumnList);
												
											%>
											<%=xTable.toString4()%>
								<%}else{ %>
								<div style="line-height:30px;padding-left:5px;font-size:13px;font-weight:bold;">请输入客户名称查询!</div>
								<%} %>
							</td>
						</tr>
					</TABLE>
				</td>
				<td></td>
			</tr>
		</table>
		</form>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				jQuery('#crmname').selectRange(jQuery("#crmname").val().length,jQuery("#crmname").val().length);
			});
			function onSearch(){
				jQuery("#frmMain").submit();   
			}
			document.onkeydown=keyListener;
			function keyListener(e){
			    e = e ? e : event;   
			    if(e.keyCode == 13){    
			    	onSearch();  
			    }    
			}
			$.fn.selectRange = function(start, end) {
				return this.each(function() {
					if (this.setSelectionRange) {
						this.focus();
						this.setSelectionRange(start, end);
					} else if (this.createTextRange) {
						var range = this.createTextRange();
						range.collapse(true);
						range.moveEnd('character', end);
						range.moveStart('character', start);
						range.select();
					}
				});
			};
		</script>
	</BODY>
</HTML>