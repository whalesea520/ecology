
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="cmutil" class="weaver.cs.util.CommonTransUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<style type="text/css">
			TABLE.ListStyle TR.Header TH{
				white-space: nowrap !important;
			}
			TABLE.ListStyle TBODY TR TD{
				padding-top:5px !important;
				padding-bottom:5px !important;
				vertical-align:middle !important;
			}
		</style>
	</head>
	<%
		String imagefilename = "/images/hdReport_wev8.gif";
		String titlename = "商机跟进信息";
		String needfav ="1";
		String needhelp ="";


		String docIds1 = "";
		String docIds2 = "";
		String docIds3 = "";
		String docIds4 = "";
		String docIds5 = "";
		String docIds6 = "";
		rs.executeSql("select infotype,item from CRM_SellChance_Set where infotype in (11,22,33,44,55,66) order by id "); 
		while(rs.next()){
			if("11".equals(rs.getString("infotype"))) docIds1 = Util.null2String(rs.getString("item"));
			if("22".equals(rs.getString("infotype"))) docIds2 = Util.null2String(rs.getString("item"));
			if("33".equals(rs.getString("infotype"))) docIds3 = Util.null2String(rs.getString("item"));
			if("44".equals(rs.getString("infotype"))) docIds4 = Util.null2String(rs.getString("item"));
			if("55".equals(rs.getString("infotype"))) docIds5 = Util.null2String(rs.getString("item"));
			if("66".equals(rs.getString("infotype"))) docIds6 = Util.null2String(rs.getString("item"));
		}
		
		String maincategory = "";
		String subcategory = "";
		String seccategory = "";
		String pathcategory = "";
		rs.executeSql("select infotype,item from CRM_SellChance_Set where infotype in (111,222,333,444) order by id "); 
		while(rs.next()){
			if("111".equals(rs.getString("infotype"))) maincategory = Util.null2String(rs.getString("item"));
			if("222".equals(rs.getString("infotype"))) subcategory = Util.null2String(rs.getString("item"));
			if("333".equals(rs.getString("infotype"))) seccategory = Util.null2String(rs.getString("item"));
		}
		if(!"".equals(maincategory) && !"".equals(subcategory) && !"".equals(seccategory))
		pathcategory = "/"+MainCategoryComInfo.getMainCategoryname(maincategory)+
        	"/"+SubCategoryComInfo.getSubCategoryname(subcategory)+
        	"/"+SecCategoryComInfo.getSecCategoryname(seccategory);
	%>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			String sql = "select id from HrmRoleMembers where  roleid = 8 and rolelevel = 2 and resourceid = " + user.getUID();
			rs.executeSql(sql);
			if(rs.next()) {
				RCMenu += "{" + SystemEnv.getHtmlLabelName(93, user.getLanguage()) + ",TemplateEdit.jsp,_self} ";
				RCMenuHeight += RCMenuHeightStep;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10">
				<col width="">
				<col width="10">
			</colgroup>
				<tr>
					<td></td>
					<td valign="top">
						<form id=frmMain name=frmMain action="TemplateOperation.jsp" method="post">
						<table style="width:100%;margin-top:5px;" cellpadding="0" cellspacing="0" border="0">
							<colgroup>
								<col width="49%">
								<col width="2%">
								<col width="49%">
							</colgroup>
							<tr>
								<td valign="top">
									<TABLE class=ViewForm>
										<!-- 需求匹配开始 -->
										<TR class=Title>
											<TH>
												<span style="float: left">需求匹配</span>
											</th>
										</TR>
										<TR class=spacing style="height: 1px;"><TD class=line1></TD></TR>
										<TR>
											<TD vAlign=top>
												<TABLE id="oTable1" class=ListStyle cellspacing=1>
													<colgroup>
														<col width="20%">
														<col width="80%">
													</colgroup>
													<TBODY>
														<TR>
															<td>参考文档：</td>
															<td>
																<%=cmutil.getDocName(docIds1) %>
															</td>
														</TR>
														<%
															rs.executeSql("select item from CRM_SellChance_Set where infotype=1 order by id "); 
															while(rs.next()){
														%>
														<TR>
															<td colspan="2">
																<%=Util.toScreen(rs.getString("item"),user.getLanguage()) %>
															</td>
														</TR>
														<%
															} 
														%>
													</TBODY>
												</TABLE>
											</TD>
										</TR>
										<!-- 需求匹配结束 -->
										<!-- 竞争优势分析开始 -->
										<TR class=Title>
											<TH>
												<span style="float: left">竞争优势分析</span>
											</th>
										</TR>
										<TR class=spacing style="height: 1px;"><TD class=line1></TD></TR>
										<TR>
											<TD vAlign=top>
												<TABLE id="oTable2" class=ListStyle cellspacing=1>
													<colgroup>
														<col width="20%">
														<col width="80%">
													</colgroup>
													<TBODY>
														<TR>
															<td>参考文档：</td>
															<td>
																<%=cmutil.getDocName(docIds2) %>
															</td>
														</TR>
														<%
															rs.executeSql("select item from CRM_SellChance_Set where infotype=2 order by id "); 
															while(rs.next()){
														%>
														<TR>
															<td colspan="2">
																<%=Util.toScreen(rs.getString("item"),user.getLanguage()) %>
															</td>
														</TR>
														<%
															} 
														%>
													</TBODY>
												</TABLE>
											</TD>
										</TR>
										<!-- 竞争优势分析结束 -->
										<!-- 外围资源开始 -->
										<TR class=Title>
											<TH>
												<span style="float: left">外围资源关系情况</span>
											</th>
										</TR>
										<TR class=spacing style="height: 1px;"><TD class=line1></TD></TR>
										<TR>
											<TD vAlign=top>
												<TABLE id="oTable5" class=ListStyle cellspacing=1>
													<colgroup>
														<col width="20%">
														<col width="80%">
													</colgroup>
													<TBODY>
														<TR>
															<td>参考文档：</td>
															<td>
																<%=cmutil.getDocName(docIds5) %>
															</td>
														</TR>
														<%
															rs.executeSql("select item from CRM_SellChance_Set where infotype=5 order by id "); 
															while(rs.next()){
														%>
														<TR>
															<td colspan="2">
																<%=Util.toScreen(rs.getString("item"),user.getLanguage()) %>
															</td>
														</TR>
														<%
															} 
														%>
													</TBODY>
												</TABLE>
											</TD>
										</TR>
										<!-- 外围资源结束 -->
										<!-- 打单策略类型开始 -->
										<TR class=Title>
											<TH>
												<span style="float: left">打单策略类型</span>
											</th>
										</TR>
										<TR class=spacing style="height: 1px;"><TD class=line1></TD></TR>
										<TR>
											<TD vAlign=top>
												<TABLE id="oTable5" class=ListStyle cellspacing=1>
													<colgroup>
														<col width="20%">
														<col width="80%">
													</colgroup>
													<TBODY>
														<%
															rs.executeSql("select item from CRM_SellChance_Set where infotype=7 order by id "); 
															while(rs.next()){
														%>
														<TR>
															<td colspan="2">
																<%=Util.toScreen(rs.getString("item"),user.getLanguage()) %>
															</td>
														</TR>
														<%
															} 
														%>
													</TBODY>
												</TABLE>
											</TD>
										</TR>
										<!-- 打单策略类型结束 -->
									</TABLE>
								</td>
								<td></td>
								<td valign="top">
									<TABLE class=ViewForm>
										<!-- 信息化情况开始 -->
										<TR class=Title>
											<TH>
												<span style="float: left">信息化情况</span>
											</th>
										</TR>
										<TR class=spacing style="height: 1px;"><TD class=line1></TD></TR>
										<TR>
											<TD vAlign=top>
												<TABLE id="oTable3" cols=2 class=ListStyle cellspacing=1>
													<colgroup>
														<col width="20%">
														<col width="80%">
													</colgroup>
													<TBODY>
														<TR>
															<td>参考文档：</td>
															<td>
																<%=cmutil.getDocName(docIds3) %>
															</td>
														</TR>
														<%
															rs.executeSql("select item from CRM_SellChance_Set where infotype=3 order by id "); 
															while(rs.next()){
														%>
														<TR>
															<td colspan="2">
																<%=Util.toScreen(rs.getString("item"),user.getLanguage()) %>
															</td>
														</TR>
														<%
															} 
														%>
													</TBODY>
												</TABLE>
											</TD>
										</TR>
										<!-- 需求匹配结束 -->
										<!-- 专业度匹配开始 -->
										<TR class=Title>
											<TH>
												<span style="float: left">专业度匹配</span>
											</th>
										</TR>
										<TR class=spacing style="height: 1px;"><TD class=line1></TD></TR>
										<TR>
											<TD vAlign=top>
												<TABLE id="oTable4" cols=2 class=ListStyle cellspacing=1>
													<colgroup>
														<col width="20%">
														<col width="80%">
													</colgroup>
													<TBODY>
														<TR>
															<td>参考文档：</td>
															<td>
																<%=cmutil.getDocName(docIds4) %>
															</td>
														</TR>
														<%
															rs.executeSql("select item from CRM_SellChance_Set where infotype=4 order by id "); 
															while(rs.next()){
														%>
														<TR>
															<td colspan="2">
																<%=Util.toScreen(rs.getString("item"),user.getLanguage()) %>
															</td>
														</TR>
														<%
															} 
														%>
													</TBODY>
												</TABLE>
											</TD>
										</TR>
										<!-- 专业度匹配结束 -->
										<!-- 友商开始 -->
										<TR class=Title>
											<TH>
												<span style="float: left">友商名称</span>
											</th>
										</TR>
										<TR class=spacing style="height: 1px;"><TD class=line1></TD></TR>
										<TR>
											<TD vAlign=top>
												<TABLE id="oTable6" cols=2 class=ListStyle cellspacing=1>
													<colgroup>
														<col width="40%">
														<col width="60%">
													</colgroup>
													<TBODY>
														<TR>
															<td>参考文档：</td>
															<td>
																<%=cmutil.getDocName(docIds6) %>
															</td>
														</TR>
														<%
															rs.executeSql("select item,doc from CRM_SellChance_Set where infotype=6 order by id "); 
															while(rs.next()){
														%>
														<TR>
															<td>
																<%=Util.toScreen(rs.getString("item"),user.getLanguage()) %>
															</td>
															<td>
																<%=cmutil.getDocName(Util.null2String(rs.getString("doc"))) %>
															</td>
														</TR>
														<%
															} 
														%>
													</TBODY>
												</TABLE>
											</TD>
										</TR>
										<!-- 友商结束 -->
									</TABLE>
								</td>
							</tr>
							<tr>
								<td colspan="3">
									<TABLE class=ViewForm>
										<TR class=Title>
											<TH>
												附件上传
											</th>
										</TR>
										<TR class=spacing style="height: 1px;"><TD class=line1></TD></TR>
										<TR>
											<TD vAlign=top>
												<TABLE id="oTable4" class=ListStyle cellspacing=1>
													<colgroup>
														<col width="20%">
														<col width="80%">
													</colgroup>
													<TBODY>
														<TR>
															<td>附件上传目录：</td>
															<td>
																<%=pathcategory%>
															</td>
														</TR>
													</TBODY>
												</TABLE>
											</TD>
										</TR>
										<TR class=Title>
											<TH>
												销售状态维护
											</th>
										</TR>
										<TR class=spacing style="height: 1px;"><TD class=line1></TD></TR>
										<TR>
											<TD vAlign=top>
												<TABLE id="oTable4" class=ListStyle cellspacing=1>
													<colgroup>
														<col width="20%">
														<col width="80%">
													</colgroup>
													<TBODY>
														<TR>
															<td colspan="2">
																<a href="/CRM/sellchance/ListCRMStatus.jsp" target="_blank">销售状态列表</a>
															</td>
														</TR>
													</TBODY>
												</TABLE>
											</TD>
										</TR>
									</TABLE>
								</td>
							</tr>
							
						</table>
						
						</form>
					</td>
					<td></td>
				</tr>
				<tr style="height: 10px;">
					<td height="10" colspan="3"></td>
				</tr>
		</table>
	</BODY>
</HTML>