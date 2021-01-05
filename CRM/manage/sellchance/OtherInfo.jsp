
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<%
	String[] otherinfo = {"描述客户方关键需求","请简述系统厂商、使用情况、内部评价、及遇到的问题","请简述相应的外围资源关系情况"
		,"请描述客户方对我方此方面的优势以及你的强化策略","请描述客户方对我方此方面的劣势以及你的弱化策略","友商名称"
		,"请上传你在商机跟进过程中的","请描述客户方对友商此方面的印象及评价","请描述针对友商此方面你该如何应对的策略"
		,"请描述代理商的主营业务，包括主要经营业务、以往及目前代理的品牌、营业收入、老客户数量、业务经营区域","请描述代理商的销售及服务人员构成和数量","请描述代理商负责人对OA的看法、市场的认识、以及已经接触过的OA厂商等信息"
		,"请描述代理商内已参加泛微培训的人员、以及是否通过考核的情况"};
    List opptList = (List)request.getSession().getAttribute("CRM_SC_OPPTLIST");
	String sellchanceid = Util.null2String(request.getParameter("sellchanceid"));
	String customerid = "";
	rs.executeSql("select t.customerid from CRM_SellChance t where t.id="+sellchanceid);
	if(rs.next()) customerid = Util.null2String(rs.getString(1)); 
	boolean canedit = false;
	if(!customerid.equals("")){
		//判断此客户是否存在
		rs.executeProc("CRM_CustomerInfo_SelectByID",customerid);
		if(!rs.next()){
			return;
		}
		//判断是否有查看该客户商机权限
		int sharelevel = CrmShareBase.getRightLevelForCRM(user.getUID()+"",customerid);
		if(sharelevel<1){
			return;
		}
		//判断是否有编辑该客户商机权限
		if(sharelevel>1){
			canedit = true;
		}
		if(rs.getInt("status")==7 || rs.getInt("status")==8 || rs.getInt("status")==10){
			canedit = false;
		}
	}
	//boolean canedit = Util.null2String(request.getParameter("canedit")).equals("true")?true:false;
	boolean hasPath = Util.null2String(request.getParameter("hasPath")).equals("true")?true:false;
	String docIds1 = Util.null2String(request.getParameter("docIds1"));
	String docIds2 = Util.null2String(request.getParameter("docIds2"));
	String docIds3 = Util.null2String(request.getParameter("docIds3"));
	String docIds4 = Util.null2String(request.getParameter("docIds4"));
	String docIds5 = Util.null2String(request.getParameter("docIds5"));
	String docIds6 = Util.null2String(request.getParameter("docIds6"));
	String mainId = Util.null2String(request.getParameter("mainId"));
	String subId = Util.null2String(request.getParameter("subId"));
	String secId = Util.null2String(request.getParameter("secId"));
	String maxsize = Util.null2String(request.getParameter("maxsize"));
	String sql = "";
%>
							<!-- 关键需求开始 -->
							<%
								sql = "select t1.id as setid,t1.infotype,t1.item,t2.id,t2.remark"
										+" from CRM_SellChance_Set t1 left join CRM_SellChance_Other t2 on t1.id=t2.setid and t2.sellchanceid="+sellchanceid
										+" where t1.infotype=1 order by t1.id";
								rs.executeSql(sql);
							%>
							<table style="width: 100%;margin-top: 20px;" cellpadding="0" cellspacing="0" border="0">
								<colgroup><col width="7px"/><col width="6px"/><col width="*"/></colgroup>
								<tr>
									<td class="item_icon3"></td>
									<td></td>
									<td>
										<div class="item_title item_title3">客户方关键需求分析
											<%if(!docIds1.equals("")){ %><font class="relatedoc">(参考知识：<%=cmutil.getDocName(docIds1) %>)</font><%} %>
										</div>
										<div class="item_line item_line3"></div>
										<table id="apply_table" class="other_table" cellpadding="0" cellspacing="0" border="0">
											<colgroup><col width="125px;"/><col width="*"/></colgroup>
											<%
												while(rs.next()){ 
													String setid = Util.null2String(rs.getString("setid"));
													if(Util.null2String(rs.getString("id")).equals("")){
														rs2.executeSql("insert into CRM_SellChance_Other(sellchanceid,setid,type,remark) values("+sellchanceid+","+setid+",1,'')");
													}
											%>
												<tr>
													<td class="title2">
														<%=Util.null2String(rs.getString("item")).trim() %>
													</td>
													<td>
														<%if(canedit){ %>
															<textarea id="apply_<%=setid %>" name="apply_<%=setid %>" _item="<%=Util.null2String(rs.getString("item")).trim() %>" _type="1" _setid="<%=setid %>" _index="0" class="other_input <%if(Util.null2String(rs.getString("remark")).equals("")){ %>input_blur<%} %>" style="overflow: auto;margin-top:2px;margin-bottom:2px;vertical-align: middle"
																><%if(Util.null2String(rs.getString("remark")).equals("")){ %><%=otherinfo[0] %><%}else{ %><%=Util.convertDB2Input(rs.getString("remark")) %><%} %></textarea>
														<%}else{ %>
															<%if(Util.null2String(rs.getString("remark")).equals("")){ %>
																<div class="input_blur"><%=otherinfo[0] %></div>
															<%}else{ %>
																<%=Util.toHtml(Util.convertDB2Input(rs.getString("remark"))) %>
															<%} %>
														<%} %>
								             		</td>
								             	</tr>
								             <%} %>
										</table>
									</td>
								</tr>
							</table>
							<!-- 关键需求结束 -->
							<!-- 优劣势分析开始 -->
							<%
								sql = "select t1.id as setid,t1.infotype,t1.item,t2.id,t2.remark,t2.remark2"
										+" from CRM_SellChance_Set t1 left join CRM_SellChance_Other t2 on t1.id=t2.setid and t2.type=2 and t2.sellchanceid="+sellchanceid
										+" where t1.infotype=2 order by t1.id";
								rs.executeSql(sql);
							%>
							<table style="width: 100%;margin-top: 20px;" cellpadding="0" cellspacing="0" border="0">
								<colgroup><col width="7px"/><col width="6px"/><col width="*"/></colgroup>
								<tr>
									<td class="item_icon4"></td>
									<td></td>
									<td>
										<div class="item_title item_title4">我方的竞争优劣势分析
											<%if(!docIds2.equals("")){ %><font class="relatedoc">(参考知识：<%=cmutil.getDocName(docIds2) %>)</font><%} %>
										</div>
										<div class="item_line item_line4"></div>
										<table id="match_table" class="other_table" cellpadding="0" cellspacing="0" border="0">
											<colgroup><col width="125px;"/><col width="*"/><col width="125px;"/><col width="*"/></colgroup>
											<%
												while(rs.next()){ 
													String setid = Util.null2String(rs.getString("setid"));
													if(Util.null2String(rs.getString("id")).equals("")){
														rs2.executeSql("insert into CRM_SellChance_Other(sellchanceid,setid,type,remark,remark2) values("+sellchanceid+","+setid+",2,'','')");
													}
											%>
												<tr>
													<td class="title2">
														<%=Util.null2String(rs.getString("item")).trim() %>优势
													</td>
													<td>
														<%if(canedit){ %>
															<textarea id="apply_<%=setid %>" name="apply_<%=setid %>" _item="我方<%=Util.null2String(rs.getString("item")).trim() %>优势" _type="2" _setid="<%=setid %>" _index="3" class="other_input <%if(Util.null2String(rs.getString("remark")).equals("")){ %>input_blur<%} %>" style="width:95%;overflow: auto;margin-top:2px;margin-bottom:2px;vertical-align: middle"
																><%if(Util.null2String(rs.getString("remark")).equals("")){ %><%=otherinfo[3] %><%}else{ %><%=Util.convertDB2Input(rs.getString("remark")) %><%} %></textarea>
														<%}else{ %>
															<%if(Util.null2String(rs.getString("remark")).equals("")){ %>
																<div class="input_blur"><%=otherinfo[3] %></div>
															<%}else{ %>
																<%=Util.toHtml(Util.convertDB2Input(rs.getString("remark"))) %>
															<%} %>
														<%} %>
								             		</td>
								             		<td class="title2">
														<%=Util.null2String(rs.getString("item")).trim() %>劣势
													</td>
													<td>
														<%if(canedit){ %>
															<textarea id="apply2_<%=setid %>" name="apply_<%=setid %>" _item="我方<%=Util.null2String(rs.getString("item")).trim() %>劣势" _type="21" _setid="<%=setid %>" _index="4" class="other_input <%if(Util.null2String(rs.getString("remark2")).equals("")){ %>input_blur<%} %>" style="width:95%;overflow: auto;margin-top:2px;margin-bottom:2px;vertical-align: middle"
																><%if(Util.null2String(rs.getString("remark2")).equals("")){ %><%=otherinfo[4] %><%}else{ %><%=Util.convertDB2Input(rs.getString("remark2")) %><%} %></textarea>
														<%}else{ %>
															<%if(Util.null2String(rs.getString("remark2")).equals("")){ %>
																<div class="input_blur"><%=otherinfo[4] %></div>
															<%}else{ %>
																<%=Util.toHtml(Util.convertDB2Input(rs.getString("remark2"))) %>
															<%} %>
														<%} %>
								             		</td>
								             	</tr>
								             <%} %>
										</table>
									</td>
								</tr>
							</table>
							<!-- 优劣势分析结束 -->
							<!-- 友商优劣势分析开始 -->
							<table id="table_other" style="width: 100%;margin-top: 20px;" cellpadding="0" cellspacing="0" border="0">
								<colgroup><col width="7px"/><col width="6px"/><col width="*"/></colgroup>
								<tr>
									<td class="item_icon5"></td>
									<td></td>
									<td>
										<div class="item_title item_title5">
											<div style="float: left;font-family: '微软雅黑';font-size: 14px;">友商的竞争优劣势分析
											<%if(!docIds6.equals("")){ %><font class="relatedoc">(参考知识：<%=cmutil.getDocName(docIds6) %>)</font><%} %>
											</div>
											<%if(canedit){ %>
											<div id="btn_oppt" style="" class="btn_addoppt">
												点击添加友商
											</div>
											<div id="opptselect" style="width: 150px;position: absolute;display: none;background: #F9F9F9;border-bottom: 1px #F3F3F3 solid;border-radius: 2px;-moz-border-radius: 2px;-webkit-border-radius: 2px;">
												
												<%//查找友商信息
												for(int i=0;i<opptList.size();i++){ 
													String[] oppts = (String[])opptList.get(i);
												%>
												<div class="selectitem" _id="<%=oppts[0] %>" _name="<%=oppts[1] %>" onclick="doAddOppt(this)">
													<%=oppts[1] %>
													<div style="display: none;">
														<%if(!Util.null2String(oppts[2]).equals("")){ %>
															<div style="float: left;"><font class="relatedoc">(参考知识：<%=cmutil.getDocName(Util.null2String(oppts[2])) %>)</font></div>
														<%} %>
													</div>
												</div>
												<%} %>
											</div>
											<%} %>
										</div>
										<div class="item_line item_line5"></div>
										<table id="oppt_table" class="other_table" cellpadding="0" cellspacing="0" border="0">
											<colgroup><col width="125px;"/><col width="*"/><col width="125px;"/><col width="*"/></colgroup>
											<%
												
												sql = "select t1.id,t1.batchid,t1.setid,t1.opptid,t1.opptname,t1.remark,t1.remark2,se.item,oppt.item as opptitem,oppt.doc"
													+" from CRM_SellChance_Other t1,CRM_SellChance_Set se,CRM_SellChance_Set oppt "
													+" where t1.setid=se.id and t1.opptid=oppt.id and t1.sellchanceid="+sellchanceid
													+" and se.infotype=2 and oppt.infotype=6 order by t1.batchid,t1.id";
											
												//sql = "select t2.id,t2.item,t2.doc from CRM_SellChance_Other t1,CRM_SellChance_Set t2 where t1.opptid=t2.id and t2.infotype=6 group by t2.id";
												rs.executeSql(sql);
											%>
												
											<%
												String tempbatchid = "";
												while(rs.next()){ 
													String batchid = Util.null2String(rs.getString("batchid"));
													String setid = Util.null2String(rs.getString("setid"));
													String opptid = Util.null2String(rs.getString("opptid"));
											%>
											<%	if(!tempbatchid.equals(batchid)){ 
													tempbatchid = batchid;
											%>
												<tr class="oppttitle oppt<%=batchid %> opptid<%=opptid %>">
													<td class="oppttd"><%=rs.getString("opptitem") %>
													<%if(rs.getString("opptitem").equals("其他")){ %>
														<%if(canedit){ %>
														<input type="text" class="oppt_input <%if(Util.null2String(rs.getString("opptname")).equals("")){ %>input_blur<%} %>"
														 _index="5" _batchid="<%=batchid %>" value="<%if(Util.null2String(rs.getString("opptname")).equals("")){ %><%=otherinfo[5]%><%}else{%><%=Util.null2String(rs.getString("opptname")) %><%} %>"/>
														<%}else{ %>
															<%=Util.null2String(rs.getString("opptname")) %>
														<%} %>
													<%} %>
													</td>
													<td colspan="3">
														<%if(!Util.null2String(rs.getString("doc")).equals("")){ %>
															<div style="float: left;"><font class="relatedoc">(参考知识：<%=cmutil.getDocName(Util.null2String(rs.getString("doc"))) %>)</font></div>
														<%} %>
														<%if(canedit){ %>
														<div class="opptdel" onclick="delOppt('<%=batchid %>','<%=rs.getString("opptitem") %>')" title="删除"></div>
														<%} %>
													</td>
												</tr>
											<%	} %>
												<tr class="opptitem oppt<%=batchid %>">
													<td class="title2">
														<%=Util.null2String(rs.getString("item")).trim() %><font style="color: #BFBFBF !important;font-size: 10px;">---客户方印象及评价</font>
													</td>
													<td>
														<%if(canedit){ %>
															<textarea id="apply_<%=setid %>_<%=opptid %>_<%=batchid %>" name="apply_<%=setid %>_<%=opptid %>_<%=batchid %>" _batchid="<%=batchid %>" _type="6" _setid="<%=setid %>" _index="7" class="other_input <%if(Util.null2String(rs.getString("remark")).equals("")){ %>input_blur<%} %>" style="width:95%;overflow: auto;margin-top:2px;margin-bottom:2px;vertical-align: middle"
																 _item="<%=Util.null2String(rs.getString("opptitem")) %><%=Util.null2String(rs.getString("opptname")) %><%=Util.null2String(rs.getString("item")).trim() %>优势"
																><%if(Util.null2String(rs.getString("remark")).equals("")){ %><%=otherinfo[7] %><%}else{ %><%=Util.convertDB2Input(rs.getString("remark")) %><%} %></textarea>
														<%}else{ %>
															<%if(Util.null2String(rs.getString("remark")).equals("")){ %>
																<div class="input_blur"><%=otherinfo[7] %></div>
															<%}else{ %>
																<%=Util.toHtml(Util.convertDB2Input(rs.getString("remark"))) %>
															<%} %>
														<%} %>
								             		</td>
								             		<td class="title2">
														<%=Util.null2String(rs.getString("item")).trim() %><font style="color: #BFBFBF !important;font-size: 10px;">---应对策略</font>
													</td>
													<td>
														<%if(canedit){ %>
															<textarea id="apply2_<%=setid %>_<%=opptid %>_<%=batchid %>" name="apply2_<%=setid %>_<%=opptid %>_<%=batchid %>" _batchid="<%=batchid %>" _type="61" _setid="<%=setid %>" _index="8" class="other_input <%if(Util.null2String(rs.getString("remark2")).equals("")){ %>input_blur<%} %>" style="width:95%;overflow: auto;margin-top:2px;margin-bottom:2px;vertical-align: middle"
																 _item="<%=Util.null2String(rs.getString("opptitem")) %><%=Util.null2String(rs.getString("opptname")) %><%=Util.null2String(rs.getString("item")).trim() %>劣势"
																 ><%if(Util.null2String(rs.getString("remark2")).equals("")){ %><%=otherinfo[8] %><%}else{ %><%=Util.convertDB2Input(rs.getString("remark2")) %><%} %></textarea>
														<%}else{ %>
															<%if(Util.null2String(rs.getString("remark2")).equals("")){ %>
																<div class="input_blur"><%=otherinfo[8] %></div>
															<%}else{ %>
																<%=Util.toHtml(Util.convertDB2Input(rs.getString("remark2"))) %>
															<%} %>
														<%} %>
								             		</td>
								             	</tr>
								             <%} %>
										</table>
									</td>
								</tr>
							</table>
							<!-- 友商优劣势分析结束 -->
							<!-- 信息化情况开始 -->
							<%
								sql = "select t1.id as setid,t1.infotype,t1.item,t2.id,t2.remark"
										+" from CRM_SellChance_Set t1 left join CRM_SellChance_Other t2 on t1.id=t2.setid and t2.sellchanceid="+sellchanceid
										+" where t1.infotype=3 order by t1.id";
								rs.executeSql(sql);
							%>
							<table style="width: 49%;margin-top: 20px;float: left;" cellpadding="0" cellspacing="0" border="0">
								<colgroup><col width="7px"/><col width="6px"/><col width="*"/></colgroup>
								<tr>
									<td class="item_icon6"></td>
									<td></td>
									<td>
										<div class="item_title item_title6">客户方信息化情况
											<%if(!docIds3.equals("")){ %><font class="relatedoc">(参考知识：<%=cmutil.getDocName(docIds3) %>)</font><%} %>
										</div>
										<div class="item_line item_line6"></div>
										<table id="info_table" class="other_table" cellpadding="0" cellspacing="0" border="0">
											<colgroup><col width="125px;"/><col width="*"/></colgroup>
											<%
												while(rs.next()){ 
													String setid = Util.null2String(rs.getString("setid"));
													if(Util.null2String(rs.getString("id")).equals("")){
														rs2.executeSql("insert into CRM_SellChance_Other(sellchanceid,setid,type,remark) values("+sellchanceid+","+setid+",3,'')");
													}
											%>
												<tr>
													<td class="title2">
														<%=Util.null2String(rs.getString("item")).trim() %>
													</td>
													<td>
														<%if(canedit){ %>
															<textarea id="apply_<%=setid %>" name="apply_<%=setid %>" _item="<%=Util.null2String(rs.getString("item")).trim() %>" _type="3" _setid="<%=setid %>" _index="1" class="other_input <%if(Util.null2String(rs.getString("remark")).equals("")){ %>input_blur<%} %>" style="width:96%;overflow: auto;margin-top:2px;margin-bottom:2px;vertical-align: middle"
																><%if(Util.null2String(rs.getString("remark")).equals("")){ %><%=otherinfo[1] %><%}else{ %><%=Util.convertDB2Input(rs.getString("remark")) %><%} %></textarea>
														<%}else{ %>
															<%if(Util.null2String(rs.getString("remark")).equals("")){ %>
																<div class="input_blur"><%=otherinfo[1] %></div>
															<%}else{ %>
																<%=Util.toHtml(Util.convertDB2Input(rs.getString("remark"))) %>
															<%} %>
														<%} %>
								             		</td>
								             	</tr>
								             <%} %>
										</table>
									</td>
								</tr>
							</table>
							<!-- 信息化情况结束 -->
							<!-- 外围资源关系情况开始 -->
							<%
								sql = "select t1.id as setid,t1.infotype,t1.item,t2.id,t2.remark"
										+" from CRM_SellChance_Set t1 left join CRM_SellChance_Other t2 on t1.id=t2.setid and t2.sellchanceid="+sellchanceid
										+" where t1.infotype=5 order by t1.id";
								rs.executeSql(sql);
							%>
							<table style="width: 50%;margin-top: 20px;margin-left: 0px;float: right;" cellpadding="0" cellspacing="0" border="0">
								<colgroup><col width="7px"/><col width="6px"/><col width="*"/></colgroup>
								<tr>
									<td class="item_icon6"></td>
									<td></td>
									<td>
										<div class="item_title item_title6">客户方外围资源关系情况
											<%if(!docIds5.equals("")){ %><font class="relatedoc">(参考知识：<%=cmutil.getDocName(docIds5) %>)</font><%} %>
										</div>
										<div class="item_line item_line6"></div>
										<table id="res_table" class="other_table" cellpadding="0" cellspacing="0" border="0">
											<colgroup><col width="125px;"/><col width="*"/></colgroup>
											<%
												while(rs.next()){ 
													String setid = Util.null2String(rs.getString("setid"));
													if(Util.null2String(rs.getString("id")).equals("")){
														rs2.executeSql("insert into CRM_SellChance_Other(sellchanceid,setid,type,remark) values("+sellchanceid+","+setid+",5,'')");
													}
											%>
												<tr>
													<td class="title2">
														<%=Util.null2String(rs.getString("item")).trim() %>
													</td>
													<td>
														<%if(canedit){ %>
															<textarea id="apply_<%=setid %>" name="apply_<%=setid %>" _item="<%=Util.null2String(rs.getString("item")).trim() %>" _type="5" _setid="<%=setid %>" _index="2" class="other_input <%if(Util.null2String(rs.getString("remark")).equals("")){ %>input_blur<%} %>" style="width:96%;overflow: auto;margin-top:2px;margin-bottom:2px;vertical-align: middle"
																><%if(Util.null2String(rs.getString("remark")).equals("")){ %><%=otherinfo[2] %><%}else{ %><%=Util.convertDB2Input(rs.getString("remark")) %><%} %></textarea>
														<%}else{ %>
															<%if(Util.null2String(rs.getString("remark")).equals("")){ %>
																<div class="input_blur"><%=otherinfo[2] %></div>
															<%}else{ %>
																<%=Util.toHtml(Util.convertDB2Input(rs.getString("remark"))) %>
															<%} %>
														<%} %>
								             		</td>
								             	</tr>
								             <%} %>
										</table>
									</td>
								</tr>
							</table>
							<!-- 外围资源关系情况结束 -->
							<!-- 相关文件开始 -->
							<%
								sql = "select t1.id as setid,t1.infotype,t1.item,t2.id,t2.remark"
										+" from CRM_SellChance_Set t1 left join CRM_SellChance_Other t2 on t1.id=t2.setid and t2.sellchanceid="+sellchanceid
										+" where t1.infotype=4 order by t1.id";
								rs.executeSql(sql);
							%>
							<table style="width: 100%;margin-top: 20px;margin-left: 0px;float: left;" cellpadding="0" cellspacing="0" border="0">
								<colgroup><col width="7px"/><col width="6px"/><col width="*"/></colgroup>
								<tr>
									<td class="item_icon8"></td>
									<td></td>
									<td>
										<div class="item_title item_title8">相关文件
											<%if(!docIds4.equals("")){ %><font class="relatedoc">(参考知识：<%=cmutil.getDocName(docIds4) %>)</font><%} %>
										</div>
										<div class="item_line item_line8"></div>
										<table id="res_table" class="other_table" cellpadding="0" cellspacing="0" border="0">
											<colgroup><col width="125px;"/><col width="*"/></colgroup>
											<%
												while(rs.next()){ 
													String setid = Util.null2String(rs.getString("setid"));
													if(Util.null2String(rs.getString("id")).equals("")){
														rs2.executeSql("insert into CRM_SellChance_Other(sellchanceid,setid,type,remark) values("+sellchanceid+","+setid+",4,'')");
													}
											%>
												<tr>
													<td class="title2">
														<%=Util.null2String(rs.getString("item")).trim() %>
													</td>
													<td id="filetd_<%=setid %>">
													<%
														List _fileidList = Util.TokenizerString(Util.null2String(rs.getString("remark")),",");
														for(int i=0;i<_fileidList.size();i++){
															if(!"0".equals(_fileidList.get(i)) && !"".equals(_fileidList.get(i))){
																DocImageManager.resetParameter();
													            DocImageManager.setDocid(Integer.parseInt((String)_fileidList.get(i)));
													            DocImageManager.selectDocImageInfo();
													            DocImageManager.next();
													            String docImagefileid = DocImageManager.getImagefileid();
													            int docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
													            String docImagefilename = DocImageManager.getImagefilename();
													%>
													<div class='txtlink txtlink<%=_fileidList.get(i) %>' onmouseover='showdel(this)' onmouseout='hidedel(this)'>
														<div style='float: left;'>
															<a href="javaScript:openFullWindowHaveBar('/CRM/manage/util/ViewDoc.jsp?id=<%=_fileidList.get(i) %>&sellchanceid=<%=sellchanceid %>')"><%=docImagefilename %></a>
															&nbsp;<a href='/CRM/manage/util/ViewDoc.jsp?id=<%=_fileidList.get(i) %>&sellchanceid=<%=sellchanceid %>&fileid=<%=docImagefileid %>'>下载(<%=docImagefileSize/1000 %>K)</a>
														</div>
														<%if(canedit){ %>
														<div class='btn_del' onclick="doDelItem('<%=Util.null2String(rs.getString("item")).trim() %>','<%=_fileidList.get(i) %>','<%=setid %>')"></div>
														<div class='btn_wh'></div>
														<%} %>
													</div>
													<% 		} 
														}
														if(_fileidList.size()==0){
													%>
														<div class='txtlink input_blur' style='margin-right: 5px'><%=otherinfo[6] %><%=Util.null2String(rs.getString("item")).trim() %>文件</div>
													<%	} %>
													<%if(canedit){ 
														if(hasPath){
													%>
											  			<div id="uploadDiv<%=setid %>" class="upload" mainId="<%=mainId%>" subId="<%=subId%>" secId="<%=secId%>" maxsize="<%=maxsize%>" setid="<%=setid %>"></div>
											  			<script type="text/javascript">$(document).ready(function(){bindUploaderDiv($("#uploadDiv<%=setid %>"),"<%=Util.null2String(rs.getString("item")).trim() %>","<%=sellchanceid%>");});</script>	
											  		<%	}else{ %>
											  			<font color="red"><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
											  		<%	}
											  		  } 
											  		%>
								             		</td>
								             	</tr>
								             <%} %>
										</table>
									</td>
								</tr>
							</table>
							<!-- 相关文件结束 -->