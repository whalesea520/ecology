
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="cmutil" class="weaver.cs.util.CommonTransUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String sql = "select id from HrmRoleMembers where  roleid = 8 and rolelevel = 2 and resourceid = " + user.getUID();
	rs.executeSql(sql);
	if(!rs.next()) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
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
		String titlename = "商机跟进信息设置";
		String needfav ="1";
		String needhelp ="";


		String docIds1 = "";
		String docIds2 = "";
		String docIds3 = "";
		String docIds4 = "";
		String docIds5 = "";
		String docIds6 = "";
		String docsetid1 = "";
		String docsetid2 = "";
		String docsetid3 = "";
		String docsetid4 = "";
		String docsetid5 = "";
		String docsetid6 = "";
		rs.executeSql("select id,infotype,item from CRM_SellChance_Set where infotype in (11,22,33,44,55,66) order by id "); 
		while(rs.next()){
			if("11".equals(rs.getString("infotype"))){
				docIds1 = Util.null2String(rs.getString("item"));
				docsetid1 = Util.null2String(rs.getString("id"));
			}
			if("22".equals(rs.getString("infotype"))){
				docIds2 = Util.null2String(rs.getString("item"));
				docsetid2 = Util.null2String(rs.getString("id"));
			}
			if("33".equals(rs.getString("infotype"))){
				docIds3 = Util.null2String(rs.getString("item"));
				docsetid3 = Util.null2String(rs.getString("id"));
			}
			if("44".equals(rs.getString("infotype"))){
				docIds4 = Util.null2String(rs.getString("item"));
				docsetid4 = Util.null2String(rs.getString("id"));
			}
			if("55".equals(rs.getString("infotype"))){
				docIds5 = Util.null2String(rs.getString("item"));
				docsetid5 = Util.null2String(rs.getString("id"));
			}
			if("66".equals(rs.getString("infotype"))){
				docIds6 = Util.null2String(rs.getString("item"));
				docsetid6 = Util.null2String(rs.getString("id"));
			}
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
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this);,_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			
			RCMenu += "{" + SystemEnv.getHtmlLabelName(1290, user.getLanguage()) + ",TemplateInfo.jsp,_self} ";
			RCMenuHeight += RCMenuHeightStep;
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
						<input class=inputstyle type="hidden" id="rownum1" name="rownum1" />
						<input class=inputstyle type="hidden" id="rownum2" name="rownum2" />
						<input class=inputstyle type="hidden" id="rownum3" name="rownum3" />
						<input class=inputstyle type="hidden" id="rownum4" name="rownum4" />
						<input class=inputstyle type="hidden" id="rownum5" name="rownum5" />
						<input class=inputstyle type="hidden" id="rownum6" name="rownum6" />
						<input class=inputstyle type="hidden" id="rownum7" name="rownum7" />
						<input class=inputstyle type="hidden" id="docsetid1" name="docsetid1" value="<%=docsetid1 %>"/>
						<input class=inputstyle type="hidden" id="docsetid2" name="docsetid2" value="<%=docsetid2 %>"/>
						<input class=inputstyle type="hidden" id="docsetid3" name="docsetid3" value="<%=docsetid3 %>"/>
						<input class=inputstyle type="hidden" id="docsetid4" name="docsetid4" value="<%=docsetid4 %>"/>
						<input class=inputstyle type="hidden" id="docsetid5" name="docsetid5" value="<%=docsetid5 %>"/>
						<input class=inputstyle type="hidden" id="docsetid6" name="docsetid6" value="<%=docsetid6 %>"/>
						<input type=hidden id='pathcategory' name='pathcategory' value="<%=pathcategory%>" />
						<input type=hidden id='maincategory' name='maincategory' value="<%=maincategory%>" />
						<INPUT type=hidden id='subcategory' name='subcategory' value="<%=subcategory%>" />
						<INPUT type=hidden id='seccategory' name='seccategory' value="<%=seccategory%>" />
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
												<span style="float: right">
													<BUTTON type="button" class=btnNew accessKey=A onClick="addRow(1);">
														<U>A</U>-<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>
													</BUTTON>
													<BUTTON type="button" class=btnDelete accessKey=D onClick="javascript:if(isdel()){deleteRow(1);};">
														<U>D</U>-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>
													</BUTTON>
												</span>
											</th>
										</TR>
										<TR class=spacing style="height: 1px;"><TD class=line1></TD></TR>
										<TR>
											<TD vAlign=top>
												<TABLE id="oTable1" cols=2 class=ListStyle cellspacing=1>
													<colgroup>
														<col width="20%">
														<col width="80%">
													</colgroup>
													<TBODY>
														<TR>
															<td>参考文档：</td>
															<td>
																<INPUT class="wuiBrowser" type="hidden" id="docIds1" name="docIds1" value="<%=docIds1 %>"
																_displayTemplate="<A href=javaScript:openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=#b{id}')>#b{name}</A>" 
																_displayText="<%=cmutil.getDocName(docIds1) %>" _param="documentids"
																_url="/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp" />
															</td>
														</TR>
														<%
															int rownum1 = 0;
															rs.executeSql("select id,item from CRM_SellChance_Set where infotype=1 order by id "); 
															while(rs.next()){
														%>
														<TR>
															<td>
																<input type='checkbox' name='check_node1' value='0'>
																<input type="hidden" id='id1_<%=rownum1 %>' name='id1_<%=rownum1 %>' value="<%=rs.getString("id") %>"/>
															</td>
															<td>
																<input type="text" class="InputStyle" id='item1_<%=rownum1 %>' name='item1_<%=rownum1 %>' value="<%=Util.toScreen(rs.getString("item"),user.getLanguage()) %>" style="width:98%" maxlength='100'/>
															</td>
														</TR>
														<%
															rownum1++;
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
												<span style="float: right">
													<BUTTON type="button" class=btnNew accessKey=A onClick="addRow(2);">
														<U>A</U>-<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>
													</BUTTON>
													<BUTTON type="button" class=btnDelete accessKey=D onClick="javascript:if(isdel()){deleteRow(2);};">
														<U>D</U>-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>
													</BUTTON>
												</span>
											</th>
										</TR>
										<TR class=spacing style="height: 1px;"><TD class=line1></TD></TR>
										<TR>
											<TD vAlign=top>
												<TABLE id="oTable2" cols=2 class=ListStyle cellspacing=1>
													<colgroup>
														<col width="20%">
														<col width="80%">
													</colgroup>
													<TBODY>
														<TR>
															<td>参考文档：</td>
															<td>
																<INPUT class="wuiBrowser" type="hidden" id="docIds2" name="docIds2" value="<%=docIds2 %>"
																_displayTemplate="<A href=javaScript:openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=#b{id}')>#b{name}</A>" 
																_displayText="<%=cmutil.getDocName(docIds2) %>" _param="documentids"
																_url="/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp" />
															</td>
														</TR>
														<%
															int rownum2 = 0;
															rs.executeSql("select id,item from CRM_SellChance_Set where infotype=2 order by id "); 
															while(rs.next()){
														%>
														<TR>
															<td>
																<input type='checkbox' name='check_node2' value='0'>
																<input type="hidden" id='id2_<%=rownum2 %>' name='id2_<%=rownum2 %>' value="<%=rs.getString("id") %>"/>
															</td>
															<td>
																<input type="text" class="InputStyle" id='item2_<%=rownum2 %>' name='item2_<%=rownum2 %>' value="<%=Util.toScreen(rs.getString("item"),user.getLanguage()) %>" style="width:98%" maxlength='100'/>
															</td>
														</TR>
														<%
															rownum2++;
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
												<span style="float: right">
													<BUTTON type="button" class=btnNew accessKey=A onClick="addRow(5);">
														<U>A</U>-<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>
													</BUTTON>
													<BUTTON type="button" class=btnDelete accessKey=D onClick="javascript:if(isdel()){deleteRow(5);};">
														<U>D</U>-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>
													</BUTTON>
												</span>
											</th>
										</TR>
										<TR class=spacing style="height: 1px;"><TD class=line1></TD></TR>
										<TR>
											<TD vAlign=top>
												<TABLE id="oTable5" cols=2 class=ListStyle cellspacing=1>
													<colgroup>
														<col width="20%">
														<col width="80%">
													</colgroup>
													<TBODY>
														<TR>
															<td>参考文档：</td>
															<td>
																<INPUT class="wuiBrowser" type="hidden" id="docIds5" name="docIds5" value="<%=docIds5 %>"
																_displayTemplate="<A href=javaScript:openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=#b{id}')>#b{name}</A>" 
																_displayText="<%=cmutil.getDocName(docIds5) %>" _param="documentids"
																_url="/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp" />
															</td>
														</TR>
														<%
															int rownum5 = 0;
															rs.executeSql("select id,item from CRM_SellChance_Set where infotype=5 order by id "); 
															while(rs.next()){
														%>
														<TR>
															<td>
																<input type='checkbox' name='check_node5' value='0'>
																<input type="hidden" id='id5_<%=rownum5 %>' name='id5_<%=rownum5 %>' value="<%=rs.getString("id") %>"/>
															</td>
															<td>
																<input type="text" class="InputStyle" id='item5_<%=rownum5 %>' name='item5_<%=rownum5 %>' value="<%=Util.toScreen(rs.getString("item"),user.getLanguage()) %>" style="width:98%" maxlength='100'/>
															</td>
														</TR>
														<%
															rownum5++;
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
												<span style="float: right">
													<BUTTON type="button" class=btnNew accessKey=A onClick="addRow(7);">
														<U>A</U>-<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>
													</BUTTON>
													<BUTTON type="button" class=btnDelete accessKey=D onClick="javascript:if(isdel()){deleteRow(7);};">
														<U>D</U>-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>
													</BUTTON>
												</span>
											</th>
										</TR>
										<TR class=spacing style="height: 1px;"><TD class=line1></TD></TR>
										<TR>
											<TD vAlign=top>
												<TABLE id="oTable7" cols=2 class=ListStyle cellspacing=1>
													<colgroup>
														<col width="20%">
														<col width="80%">
													</colgroup>
													<TBODY>
														<TR style="height: 0px;display: none;">
															<td style="height: 0px;"></td>
															<td style="height: 0px;"></td>
														</TR>
														<%
															int rownum7 = 0;
															rs.executeSql("select id,item from CRM_SellChance_Set where infotype=7 order by id "); 
															while(rs.next()){
														%>
														<TR>
															<td>
																<input type='checkbox' name='check_node7' value='0'>
																<input type="hidden" id='id7_<%=rownum7 %>' name='id7_<%=rownum7 %>' value="<%=rs.getString("id") %>"/>
															</td>
															<td>
																<input type="text" class="InputStyle" id='item7_<%=rownum7 %>' name='item7_<%=rownum7 %>' value="<%=Util.toScreen(rs.getString("item"),user.getLanguage()) %>" style="width:98%" maxlength='100'/>
															</td>
														</TR>
														<%
															rownum7++;
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
												<span style="float: right">
													<BUTTON type="button" class=btnNew accessKey=A onClick="addRow(3);">
														<U>A</U>-<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>
													</BUTTON>
													<BUTTON type="button" class=btnDelete accessKey=D onClick="javascript:if(isdel()){deleteRow(3);};">
														<U>D</U>-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>
													</BUTTON>
												</span>
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
																<INPUT class="wuiBrowser" type="hidden" id="docIds3" name="docIds3" value="<%=docIds3 %>"
																_displayTemplate="<A href=javaScript:openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=#b{id}')>#b{name}</A>" 
																_displayText="<%=cmutil.getDocName(docIds3) %>" _param="documentids"
																_url="/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp" />
															</td>
														</TR>
														<%
															int rownum3 = 0;
															rs.executeSql("select id,item from CRM_SellChance_Set where infotype=3 order by id "); 
															while(rs.next()){
														%>
														<TR>
															<td>
																<input type='checkbox' name='check_node3' value='0'>
																<input type="hidden" id='id3_<%=rownum3 %>' name='id3_<%=rownum3 %>' value="<%=rs.getString("id") %>"/>
															</td>
															<td>
																<input type="text" class="InputStyle" id='item3_<%=rownum3 %>' name='item3_<%=rownum3 %>' value="<%=Util.toScreen(rs.getString("item"),user.getLanguage()) %>" style="width:98%" maxlength='100'/>
															</td>
														</TR>
														<%
															rownum3++;
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
												<span style="float: right">
													<BUTTON type="button" class=btnNew accessKey=A onClick="addRow(4);">
														<U>A</U>-<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>
													</BUTTON>
													<BUTTON type="button" class=btnDelete accessKey=D onClick="javascript:if(isdel()){deleteRow(4);};">
														<U>D</U>-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>
													</BUTTON>
												</span>
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
																<INPUT class="wuiBrowser" type="hidden" id="docIds4" name="docIds4" value="<%=docIds4 %>"
																_displayTemplate="<A href=javaScript:openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=#b{id}')>#b{name}</A>" 
																_displayText="<%=cmutil.getDocName(docIds4) %>" _param="documentids"
																_url="/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp" />
															</td>
														</TR>
														<%
															int rownum4 = 0;
															rs.executeSql("select id,item from CRM_SellChance_Set where infotype=4 order by id "); 
															while(rs.next()){
														%>
														<TR>
															<td>
																<input type='checkbox' name='check_node4' value='0'>
																<input type="hidden" id='id4_<%=rownum4 %>' name='id4_<%=rownum4 %>' value="<%=rs.getString("id") %>"/>
															</td>
															<td>
																<input type="text" class="InputStyle" id='item4_<%=rownum4 %>' name='item4_<%=rownum4 %>' value="<%=Util.toScreen(rs.getString("item"),user.getLanguage()) %>" style="width:98%" maxlength='100'/>
															</td>
														</TR>
														<%
															rownum4++;
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
												<span style="float: right">
													<BUTTON type="button" class=btnNew accessKey=A onClick="addRow(6);">
														<U>A</U>-<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>
													</BUTTON>
													<BUTTON type="button" class=btnDelete accessKey=D onClick="javascript:if(isdel()){deleteRow(6);};">
														<U>D</U>-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>
													</BUTTON>
												</span>
											</th>
										</TR>
										<TR class=spacing style="height: 1px;"><TD class=line1></TD></TR>
										<TR>
											<TD vAlign=top>
												<TABLE id="oTable6" cols=3 class=ListStyle cellspacing=1>
													<colgroup>
														<col width="20%">
														<col width="40%">
														<col width="40%">
													</colgroup>
													<TBODY>
														<TR>
															<td>参考文档：</td>
															<td>
																<INPUT class="wuiBrowser" type="hidden" id="docIds6" name="docIds6" value="<%=docIds6 %>"
																_displayTemplate="<A href=javaScript:openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=#b{id}')>#b{name}</A>" 
																_displayText="<%=cmutil.getDocName(docIds6) %>" _param="documentids"
																_url="/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp" />
															</td>
															<td></td>
														</TR>
														<%
															int rownum6 = 0;
															rs.executeSql("select id,item,doc from CRM_SellChance_Set where infotype=6 order by id "); 
															while(rs.next()){
														%>
														<TR>
															<td width="20%">
																<input type='checkbox' name='check_node6' value='0'>
																<input type="hidden" id='id6_<%=rownum6 %>' name='id6_<%=rownum6 %>' value="<%=rs.getString("id") %>"/>
															</td>
															<td width="40%">
																<input type="text" class="InputStyle" id='item6_<%=rownum6 %>' name='item6_<%=rownum6 %>' value="<%=Util.toScreen(rs.getString("item"),user.getLanguage()) %>" style="width:98%" maxlength='100'/>
															</td>
															<td width="40%">
																<BUTTON type="button" class=Browser onClick="onShowDocs('itemdoc_<%=rownum6 %>','itemdocspan_<%=rownum6 %>')"></BUTTON>
													    		<span id="itemdocspan_<%=rownum6 %>"><%=cmutil.getDocName(rs.getString("doc"))%></span>
													    		<INPUT type=hidden id='itemdoc_<%=rownum6 %>' name='itemdoc_<%=rownum6 %>' value="<%=Util.null2String(rs.getString("doc"))%>">
															</td>
														</TR>
														<%
															rownum6++;
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
												<TABLE id="oTable4" cols=2 class=ListStyle cellspacing=1>
													<colgroup>
														<col width="20%">
														<col width="80%">
													</colgroup>
													<TBODY>
														<TR>
															<td>附件上传目录：</td>
															<td>
																<BUTTON type="button" class=Browser onClick="onShowCatalog()" name=selectCategory></BUTTON>
													    		<span id="mypathspan"><%=pathcategory%></span>
													    		<INPUT type=hidden id='mypath' name='mypath' value="<%=pathcategory%>">
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
		<script type="text/javascript">
		function onSave(obj){
			obj.disabled = true;
			jQuery('#frmMain').submit();
		}
		
		jQuery("#rownum1").val(<%=rownum1%>);
		jQuery("#rownum2").val(<%=rownum2%>);
		jQuery("#rownum3").val(<%=rownum3%>);
		jQuery("#rownum4").val(<%=rownum4%>);
		jQuery("#rownum5").val(<%=rownum5%>);
		jQuery("#rownum6").val(<%=rownum6%>);
		jQuery("#rownum7").val(<%=rownum7%>);
		function addRow(index)
		{
			rowindex = jQuery("#rownum"+index).val();
			var table = $G("oTable"+index);
			var ncol = jQuery("#oTable"+index).attr("cols");
			var oRow = table.insertRow(-1);
			for(j=0; j<ncol; j++) {
				oCell = oRow.insertCell(-1);
				oCell.style.height=24;
				switch(j) {
					case 0:
						var oDiv = document.createElement("div");
						var sHtml = "<input type='checkbox' name='check_node"+index+"' value='0'>";
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;
		            case 1:
		            	var oDiv = document.createElement("div");
						var sHtml = "<input type='text' class='InputStyle' maxlength='100' id='item"+index+"_"+rowindex+"' name='item"+index+"_"+rowindex+"' style='width:98%'/>";
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;
		            case 2:
		            	var oDiv = document.createElement("div");
						var sHtml = "<BUTTON type='button' class=Browser onClick=onShowDocs('itemdoc_"+rowindex+"','itemdocspan_"+rowindex+"')></BUTTON>"
			    			+"<span id='itemdocspan_"+rowindex+"'></span>"
			    			+"<INPUT type=hidden id='itemdoc_"+rowindex+"' name='itemdoc_"+rowindex+"' value=''>";
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;
				}
			}
			rowindex = rowindex*1 +1;
			jQuery("#rownum"+index).val(rowindex);
		}
		function deleteRow(index)
		{
			var table = $G("oTable"+index);
			var len = document.forms[0].elements.length;
			var i=0;
			var rowsum1 = 1;
		    for(i=len-1; i >= 0;i--) {
				if (document.forms[0].elements[i].name==('check_node'+index))
					rowsum1 += 1;
			}

			for(i=len-1; i >= 0;i--) {
				if (document.forms[0].elements[i].name==('check_node'+index)){
					if(document.forms[0].elements[i].checked==true) {
						table.deleteRow(rowsum1-1);
					}
					rowsum1 -=1;
				}
			}
		}
		function onShowCatalog() {
		    var datas = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp");
		    if (datas) {
		    	if (datas.id!= "") {
		    	  jQuery("#mypathspan").html(datas.path);
		          jQuery("#mypath").val(datas.path);
		          jQuery("#pathcategory").val(datas.path);
		          jQuery("#maincategory").val(datas.mainid);
		          jQuery("#subcategory").val(datas.subid);
		          jQuery("#seccategory").val(datas.id);
		        }else{
		          jQuery("#mypathspan").html("");
		          jQuery("#mypath").val("");
		          jQuery("#pathcategory").val("");
		          jQuery("#maincategory").val("");
		          jQuery("#subcategory").val("");
		          jQuery("#seccategory").val("");
		        }
		    }
		}
		function onShowDocs(inputid,spanid) {
		    var datas = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp");
		    if (datas) {
		    	if (datas.id!= "") {
		          	jQuery("#"+inputid).val(datas.id.substring(1));
		          	jQuery("#"+spanid).html(datas.name.substring(1));
		        }else{
			        jQuery("#"+inputid).val("");
			        jQuery("#"+spanid).html("");
		        }
		    }
		}
		</script>
	</BODY>
</HTML>