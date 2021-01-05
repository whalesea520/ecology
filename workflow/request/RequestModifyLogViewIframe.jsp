<!--
created by cyril on 2008-07-09
表单修改日志功能
-->

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.general.TimeUtil"%>
<%@ page import="java.util.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="FieldValue" class="weaver.workflow.field.FieldValue" scope="page" />
<%
	boolean isMonitor = false;//流程督办人
	int ismonitor = Util.getIntValue(request.getParameter("ismonitor"), 0);
	int urger = Util.getIntValue(request.getParameter("urger"), 0);	
	if(ismonitor==1 || urger==1)
		isMonitor = true;
	String workflowid = "";
	String requestid = Util.null2String(request.getParameter("requestid"));
	String pnodeid = Util.null2String(request.getParameter("nodeid"));
	//System.out.println("pnodeid = "+pnodeid);
	String isAll = Util.null2String(request.getParameter("isAll"));
	String requestname = "";
	String sql = "";
	String viewNodeids = "";

	RecordSet.executeProc("workflow_Requestbase_SByID", requestid + "");
	RecordSet.next();
	requestname = RecordSet.getString("requestname");
	workflowid = RecordSet.getString("workflowid");
    ArrayList detailtables=new ArrayList();
    int isbill=0;
    int billid=0;
    RecordSet.executeSql("select formid,isbill from workflow_base where id="+workflowid);
    if(RecordSet.next()){
    	isbill=RecordSet.getInt(2);
        billid=RecordSet.getInt(1);
        RecordSet.executeSql("select tablename from workflow_billdetailtable where billid="+billid+" order by orderid");
        while(RecordSet.next()){
            detailtables.add(RecordSet.getString(1));
        }
    }

	boolean isOracle = RecordSet.getDBType().equals("oracle");
	
	//取流程所有节点
	String allNodeids = "";
	
	if(!isMonitor) {
		sql = "select nodeid from workflow_flownode where workflowid="+workflowid;
		RecordSet.executeSql(sql);
		while(RecordSet.next()) {
			allNodeids += RecordSet.getString("nodeid")+",";
		}
		//out.println("all="+allNodeids);
		
		RecordSet.executeSql("select viewnodeids from workflow_logviewnode where workflowid=" + workflowid + " and nodeid = " +pnodeid);
		if(RecordSet.next()){
			String ids = RecordSet.getString("viewnodeids");
			if (ids != null && !ids.equals("")) {
				//out.println(ids);
				if (!ids.equals("-1")) {
					viewNodeids += ids;
				}else if(ids.equals("-1")) {
					if(!viewNodeids.equals("") && !viewNodeids.substring(viewNodeids.length()-1, viewNodeids.length()).equals(","))
						viewNodeids += ",";
					viewNodeids += allNodeids;
					//out.println(viewNodeids);
				}
			}
			
			if(!viewNodeids.equals("")){
				if(viewNodeids.indexOf(",") > 0){
					viewNodeids = viewNodeids.substring(0, viewNodeids.length()-1);
				}
			}
		}else{
			sql = "select viewnodeids from workflow_flownode where workflowid=" + workflowid + " ";
			sql += " and nodeid=" + pnodeid;
			RecordSet.executeSql(sql);
			//out.println(sql);
			if(RecordSet.next()) {
				String ids = RecordSet.getString("viewnodeids");
				if (ids != null && !ids.equals("")) {
					//out.println(ids);
					if (!ids.equals("-1")) {
						viewNodeids += ids;
					}
					else if(ids.equals("-1")) {
						if(!viewNodeids.equals("") && !viewNodeids.substring(viewNodeids.length()-1, viewNodeids.length()).equals(","))
							viewNodeids += ",";
						viewNodeids += allNodeids;
						//out.println(viewNodeids);
					}
				}
			}
			if(!viewNodeids.equals(""))
				viewNodeids = viewNodeids.substring(0, viewNodeids.length()-1);
		}
		//out.println("===>"+viewNodeids+"<===<br>");
	}

	StringBuffer s = new StringBuffer();
	//主字段修改记录
	s = new StringBuffer();
	s.append("select * ");
	if(isOracle)
		s.append("from (select * ");
	s.append("from (select id, ");
	s.append("-1 sn,-1 fieldorder,optKind,-1 optType,requestId,nodeId,");
	s.append("(select nodename from workflow_nodebase where id=t.Nodeid) nodeName,");
	s.append("isBill,fieldLableId,");
	s.append("-1 fieldGroupId,fieldId,fieldHtmlType,fieldType,fieldNameCn,");
	s.append("fieldNameEn,fieldNameTw,");
	if(!isOracle) {
		s.append("convert(varchar(8000),fieldOldText) fieldOldText,");
		s.append("convert(varchar(8000),fieldNewText) fieldNewText,");
	}
	else {
		s.append("fieldOldText,fieldNewText,");
	}
	s.append("modifierType,agentId,modifierId,modifierIP,modifyTime from workflow_track t ");
	s.append("where t.requestid = " + requestid + " ");
	s.append("and (fieldid in (select fieldid from workflow_nodeform where isView=1 and nodeid=t.nodeid) ");
	s.append("or fieldid in (select fieldid from workflow_modeview where isView=1 and nodeid=t.nodeid) ");
	s.append("or fieldid=-1) ");
	if (!isAll.equals("1")) {//只显示本节点
		s.append("and t.nodeid=" + pnodeid + " ");
	}
	if(!isMonitor) {//非监控
		//s.append("and (nodeid in (select nodeid from workflow_currentoperator where userid="+user.getUID()+" and requestid=t.requestId) ");
		if(!viewNodeids.equals(""))
			s.append(" and ( nodeid in (" + viewNodeids + ") ");
		else
			s.append("and ( 1=2 ");
		s.append(") ");
	}
	s.append(") a ");
	s.append("UNION ALL ");
	s.append("select * ");
	s.append("from (select t1.id,t1.sn,t2.fieldorder,t1.optKind,t1.optType,t1.requestId,t1.nodeId,");
	s.append("(select nodename from workflow_nodebase where id=t1.Nodeid) nodeName,");
	s.append("t1.isBill,t1.fieldLableId,");
	s.append("t1.fieldGroupId,t1.fieldId,t1.fieldHtmlType,t1.fieldType,t1.fieldNameCn,t1.fieldNameEn,fieldNameTw,");
	if(!isOracle) {
		s.append("convert(varchar(8000),t1.fieldOldText) fieldOldText,");
		s.append("convert(varchar(8000),t1.fieldNewText) fieldNewText,");
	}
	else {
		s.append("t1.fieldOldText,t1.fieldNewText,");
	}
	s.append("t1.modifierType,t1.agentId,t1.modifierId,t1.modifierIP,t1.modifyTime ");
	s.append("from workflow_trackdetail t1, ");
    if(isbill==1){
    s.append("(select a.id as fieldid,b.orderid as groupId,a.dsporder as fieldorder ");
	s.append("from workflow_billfield a,workflow_billdetailtable b ");
	s.append("where a.viewtype = '1' and a.detailtable=b.tablename and b.billid="+billid+" ) t2 ");
    }else{
	s.append("(select fieldid,groupId,fieldorder ");
	s.append("from workflow_formfield ");
	s.append("where isdetail = '1'  and formid="+billid+") t2 ");
    }
	s.append("where t1.requestid = " + requestid + " ");
	if (!isAll.equals("1")) {//只显示本节点
		s.append("and t1.nodeid=" + pnodeid + " ");
	}
	if(!isMonitor) {
		//s.append("and (t1.nodeid in (select nodeid from workflow_currentoperator where userid="+user.getUID()+" and requestid=t1.requestId) ");
		if(!viewNodeids.equals(""))
			s.append(" and ( t1.nodeid in (" + viewNodeids + ") ");
		else
			s.append("and ( 1=2 ");
		s.append(") ");
	}
	s.append("and (t1.fieldid in (select fieldid from workflow_nodeform where isView=1 and nodeid=t1.nodeid) ");
	s.append("or t1.fieldid in (select fieldid from workflow_modeview where isView=1 and nodeid=t1.nodeid) ");
	s.append(") ");
	s.append("and t1.fieldid = t2.fieldid ");
    if(isbill==1){
        s.append("and t1.fieldgroupid+1 = t2.groupid ");
    }else{
        s.append("and t1.fieldgroupid = t2.groupid ");
    }
	if(isOracle)
		s.append("order by t1.modifyTime, t1.sn,  t2.fieldorder, t1.modifierId, t1.nodeId, t1.optType, t1.fieldgroupid, t1.modifierIP ");
	s.append(") b ");
	if(isOracle)
		s.append(") ");
	s.append("order by modifytime, sn, fieldorder, modifierid, nodeid, opttype, fieldGroupId, modifierip,id");
	//System.out.println("s.toString() = "+s.toString());
	RecordSet.executeSql(s.toString());
	/*
	 if(RecordSet.getCounts()<=0){
	 response.sendRedirect("/base/error/DBError.jsp?type=FindData");
	 return;
	 }
	*/
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<style>
#dettb td {
	height: 22px;
}

.add {
	color: #00FF00;
}

.mod {
	color: #FF0000;
}

.del {
	color: #0000FF;
}
</style>
</HEAD>
<%
	String imagefilename = "/images/hdReport_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(21621, user.getLanguage()) + " - " + SystemEnv.getHtmlLabelName(648, user.getLanguage()) + ":<a href=ViewRequest.jsp?requestid=" + requestid + ">" + Util.toScreen(requestname, user.getLanguage()) + "</a>";
	String needfav = "1";
	String needhelp = "";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
	if (isAll.equals("0")) {
		RCMenu += "{" + SystemEnv.getHtmlLabelName(20234, user.getLanguage()) + ",javascript:doViewAll(1),_self}";
		RCMenuHeight += RCMenuHeightStep;
	} else {
		RCMenu += "{" + SystemEnv.getHtmlLabelName(89, user.getLanguage()) + SystemEnv.getHtmlLabelName(18564, user.getLanguage()) + ",javascript:doViewAll(0),_self}";
		RCMenuHeight += RCMenuHeightStep;
	}
	//RCMenu += "{" + SystemEnv.getHtmlLabelName(1290, user.getLanguage()) + ",javascript:doBack(),_self}";
	//RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
			
			<table class=ListStyle cellspacing=1 border="1px" bordercolor="#ccc" style="border-top:1px solid rgb(248,248,248);">
							<colgroup>
								<col width="15%">
								<col>
							<tbody>
								<tr class="HeaderForXtalbe">
									<th width="15%"><%=SystemEnv.getHtmlLabelName(15586, user.getLanguage())%></th>
									<th><%=SystemEnv.getHtmlLabelName(15275, user.getLanguage())%></th>
								</tr>
								<!-- 
								<TR class=Line style="height: 1px;"> 
									<Th colspan="2"></Th>
								</TR>
							 	-->
								<%
									boolean isDetail = false;//是否明细
									boolean isDetailRow = false;//是否明细一行结束
									boolean isDetailRowRow = false;//是否明细中的一行结束
									StringBuffer detBuf = new StringBuffer();//明细拼接
									String previousFieldName = "";//明细循环的开始field

									boolean isMatch = false;//是否匹配
									boolean isLoadDetail = false;//是否加载明细
									boolean isContentClose = false;//主字段内容标签是否关闭
									boolean isDetailClose = false;//主字段内容标签是否关闭
									Map fieldMap = new HashMap();//明细字段的列表

									Map typeMap = new HashMap();//操作类型
									typeMap.put("1", SystemEnv.getHtmlLabelName(456, user.getLanguage()));
									typeMap.put("2", SystemEnv.getHtmlLabelName(103, user.getLanguage()));
									typeMap.put("3", SystemEnv.getHtmlLabelName(91, user.getLanguage()));
									
									Map levelMap = new HashMap();
									levelMap.put("0", SystemEnv.getHtmlLabelName(225, user.getLanguage()));
									levelMap.put("1", SystemEnv.getHtmlLabelName(15533, user.getLanguage()));
									levelMap.put("2", SystemEnv.getHtmlLabelName(2087, user.getLanguage()));
									
									Map msgMap =  new HashMap();
									msgMap.put("0", SystemEnv.getHtmlLabelName(17583, user.getLanguage()));
									msgMap.put("1", SystemEnv.getHtmlLabelName(17584, user.getLanguage()));
									msgMap.put("2", SystemEnv.getHtmlLabelName(17585, user.getLanguage()));

									StringBuffer s1 = new StringBuffer();
									StringBuffer s2 = new StringBuffer();

									String modifytime = "";
									String modifierip = "";
									int modifierid = 0;
									int modifiertype = 0;
									int nodeid = 0;
									int eqnodeid = 0;
									int esn = -1;
									String egroupId = "";
									int sid = 0;//主字段当前记录数
									int rowid = 1;//行号
									int cnt = RecordSet.getCounts();//主字段修改总记录数
									String optKind = "";
									while (RecordSet.next()) {
										optKind = RecordSet.getString("optKind");
										//out.println("modifytime="+RecordSet.getString("modifytime"));
										sid++;
										//如果是第一次或者不匹配的话set值
										if (sid > 1) {
											if (modifytime.equals(RecordSet.getString("modifytime")) && modifierip.equals(RecordSet.getString("modifierip")) && modifierid == RecordSet.getInt("modifierid") && modifiertype == RecordSet.getInt("modifiertype") && nodeid == RecordSet.getInt("nodeid")) {
												isMatch = true;
												eqnodeid = nodeid;
											} else {
												eqnodeid = nodeid;
												isMatch = false;
											}
										}
										//第二次开始循环检查标签是关闭
										if (sid > 1 && isMatch == false) {
											//关闭主字段
											if (isContentClose == true) {
												if (isDetailRowRow == true) {
													if (!s1.toString().equals(""))
														out.println(s1.toString() + "</tr>");
													if (!s2.toString().equals(""))
														out.println(s2.toString() + "</tr>");
													isDetailRowRow = false;
												}
												s1 = new StringBuffer();
												s2 = new StringBuffer();
												if (isDetailClose == true) {
													out.println("</table></td></tr><!-- 2.detail end -->");
													isDetailClose = false;
												}
												out.println("</table><!-- 2.content end -->");
												isContentClose = false;
											}
											//关闭明细标签
											if (isDetailRow == true) {
												out.println("<!-- 第二次开始循环 关闭明细标签 --></table>");
												isDetailRow = false;
											}
								%>
								<!--第二次开始循环检查标签是关闭-->
								</td>
								</tr>
								<tr>
									<td colspan="2" height=8></td>
								</tr>
								<%
									}
										if (sid == 1 || isMatch == false) {
											modifytime = RecordSet.getString("modifytime");
											modifierip = RecordSet.getString("modifierip");
											modifierid = RecordSet.getInt("modifierid");
											modifiertype = RecordSet.getInt("modifiertype");
											nodeid = RecordSet.getInt("nodeid");
											if (sid == 1)
												eqnodeid = nodeid;
											rowid = 1;
										} else
											rowid++;
										if (isMatch == false) {
											esn = -1;
											egroupId = "";//节点不匹配，明细组重置
											//判断是否在相同的节点
											//out.println(eqnodeid+"<====>"+nodeid);
											if (sid > 1 && eqnodeid == nodeid) {
								%>
								<!-- 相同的节点 -->
								<tr>
									<th>
										<%=RecordSet.getString("nodeName")%>
										<%if("monitor".equals(optKind)){ %>
											(<span style="color: red"><%=SystemEnv.getHtmlLabelName(665, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(103, user.getLanguage())%></span>)
										<%} %>
									</th>
									<th>
											<%
											if(RecordSet.getInt("agentId")==-1 && RecordSet.getInt("modifierid")==-1) {
											%>
												<%=SystemEnv.getHtmlLabelName(468, user.getLanguage())%> 
											<%
											}
											else {
												if(RecordSet.getInt("agentId")!=-1) {
											%>
											<a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(ResourceComInfo.getDepartmentID(RecordSet.getString("agentId")),user.getLanguage())%>"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(RecordSet.getString("agentId"))),user.getLanguage())%></a>
	               							/
											<a href="javaScript:openhrm(<%=RecordSet.getString("agentId")%>);" onclick='pointerXY(event);'>
											<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("agentId")), user.getLanguage())%></a>
											->
											<%
											}
											%>
											<a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(ResourceComInfo.getDepartmentID(RecordSet.getString("modifierid")),user.getLanguage())%>"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(RecordSet.getString("modifierid"))),user.getLanguage())%></a>
	               							/
											<a
												href="javaScript:openhrm(<%=RecordSet.getString("modifierid")%>);" onclick='pointerXY(event);'>
											<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("modifierid")), user.getLanguage())%></a>
											<%
											}
											%>
											</th>
								</tr>
								<tr>
									<td></td>
									<td>
									<%
										} else {
									%> <!-- 不同节点 -->
								<tr class=>
									<th width="15%">
										<%=RecordSet.getString("nodeName")%>
										<%if("monitor".equals(optKind)){ %>
											(<span style="color: red"><%=SystemEnv.getHtmlLabelName(665, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(103, user.getLanguage())%></span>)
										<%} %>
									</th>
									<th>
									<%
									if(RecordSet.getInt("agentId")==-1 && RecordSet.getInt("modifierid")==-1) {
									%>
										<%=SystemEnv.getHtmlLabelName(468, user.getLanguage())%> 
									<%
									}
									else {
										if(RecordSet.getInt("agentId")!=-1) {
									%>
									<a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(ResourceComInfo.getDepartmentID(RecordSet.getString("agentId")),user.getLanguage())%>"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(RecordSet.getString("agentId"))),user.getLanguage())%></a>
	               					/
									<a href="javaScript:openhrm(<%=RecordSet.getString("agentId")%>);" onclick='pointerXY(event);'>
									<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("agentId")), user.getLanguage())%></a>
									->
									<%
									}
									%>
									<a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=Util.toScreen(ResourceComInfo.getDepartmentID(RecordSet.getString("modifierid")),user.getLanguage())%>"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(RecordSet.getString("modifierid"))),user.getLanguage())%></a>
	               					/
									<a href="javaScript:openhrm(<%=RecordSet.getString("modifierid")%>);" onclick='pointerXY(event);'>
									<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("modifierid")), user.getLanguage())%></a>
									<%
									}
									%>
									</th>
								</tr>
								<!-- 
								<TR class=Line style="height: 1px;">
									<Th colspan="2"></Th>
								</TR>
								-->
								<tr>
									<td></td>
									<td>
									<%
										}
												isContentClose = true;//开启主字段内容
									%> <!-- content start -->
									<table id=dettb border="0" cellpadding="0" cellspacing="0"
										width="100%">
										<tr>
											<td><%=RecordSet.getString("modifytime")%>&nbsp;&nbsp;
											<%if(!(RecordSet.getInt("agentId")==-1 && RecordSet.getInt("modifierid")==-1)) {%>
											IP:<%=RecordSet.getString("modifierip")%>
											<%} %>
											</td>
										</tr>
										<%
											}
												if (RecordSet.getInt("opttype") == -1) {//非明细的处理
													//处理行背景
													String bgcolor = "";
													if ((rowid % 2) == 1)
														bgcolor = " bgcolor = #EAEAEA ";
													else
														bgcolor = "";
										%>
										<tr <%=bgcolor%>>
											<td><%=rowid%>、 <%
												//检查是否单据,单据的字段名称取法不同
														if (RecordSet.getInt("isBill") == 1) {
											%> [<%=SystemEnv.getHtmlLabelName(RecordSet.getInt("fieldLableId"), user.getLanguage())%>]
											<%
												} else {
											%> [<%if(user.getLanguage()==7){%><%=RecordSet.getString("fieldNameCn")%><%}else if(user.getLanguage()==9){%><%=RecordSet.getString("fieldNameTw")%><%}else{%><%=RecordSet.getString("fieldNameEn")%><%}%>]
											<%
												}
											
											if(RecordSet.getInt("fieldid")==-1) {//标题等字段的处理												
												String strLevel = "";
												String strMsg = "";
												String title = "";
												String showname1 = "";
												String showname2 = "";
												for(int m=0; m<2; m++) {
													if(RecordSet.getInt("fieldLableId")==15534) {//紧急程度 0:正常 1:重要 2:紧急17586
														if(m==0)
															strLevel = (String) levelMap.get(Util.null2String(RecordSet.getString("fieldOldText")));
														else
															strLevel = (String) levelMap.get(Util.null2String(RecordSet.getString("fieldNewText")));
													}
													else if(RecordSet.getInt("fieldLableId")==17586) {//短信提醒 0:不短信提醒 1:离线短信提醒 2在线短信提醒
														if(m==0)
															strMsg = (String) msgMap.get(Util.null2String(RecordSet.getString("fieldOldText")));
														else
															strMsg = (String) msgMap.get(Util.null2String(RecordSet.getString("fieldNewText")));
													}
													else {//标题
														if(m==0)
															title = Util.null2String(RecordSet.getString("fieldOldText"));
														else
															title = Util.null2String(RecordSet.getString("fieldNewText"));
													}
													if(m==0)
														showname1 = Util.null2String(strLevel)+Util.null2String(strMsg)+Util.null2String(title);
													else
														showname2 = Util.null2String(strLevel)+Util.null2String(strMsg)+Util.null2String(title);
												}
												
												
											%>
												<%=SystemEnv.getHtmlLabelName(623, user.getLanguage())%> 
												"<span class=mod><%=showname1%></span>"
												<%=SystemEnv.getHtmlLabelName(21623, user.getLanguage())%> 
												"<span class=mod><%=showname2%></span>"
											<%
											}
											else {
												//附件的特殊处理
												if(RecordSet.getInt("fieldHtmlType")!=6) {
												%>
												<%=SystemEnv.getHtmlLabelName(623, user.getLanguage())%> 
												"<span class=mod><%=FieldValue.getFieldValue(session, RecordSet.getInt("fieldid"), RecordSet.getInt("fieldHtmlType"), RecordSet.getInt("fieldType"), Util.null2String(RecordSet.getString("fieldOldText")), RecordSet.getInt("isBill"))%></span>"
												<%
												}
												%>
												<%=SystemEnv.getHtmlLabelName(21623, user.getLanguage())%> 
												"<span class=mod><%=FieldValue.getFieldValue(session, RecordSet.getInt("fieldid"), RecordSet.getInt("fieldHtmlType"), RecordSet.getInt("fieldType"), Util.null2String(RecordSet.getString("fieldNewText")), RecordSet.getInt("isBill"))%></span>"
											<%
											}
											%>
											</td>
										</tr>
										<%
											} else {//明细的处理
													if (egroupId.equals("") || !egroupId.equals(nodeid + "_" + RecordSet.getInt("fieldGroupId"))) {//不是同一个明细则打印出标题
														egroupId = nodeid + "_" + RecordSet.getInt("fieldGroupId");
                                                        esn=-1;
														//关闭明细列表
														if (isDetailClose == true) {
															if (!s1.toString().equals(""))
																out.println(s1.toString() + "</tr>");
															if (!s2.toString().equals(""))
																out.println(s2.toString() + "</tr>");
															out.println("</table></td></tr><!-- 1.detail end -->");
															isDetailClose = false;
														}
														isDetailClose = true;//开启明细列表
														//判断是否为模板
														weaver.workflow.workflow.WFModeNodeFieldManager wFModeNodeFieldManager=new weaver.workflow.workflow.WFModeNodeFieldManager();
														boolean isMode=wFModeNodeFieldManager.getIsModeByWorkflowIdAndNodeId(Util.getIntValue(workflowid), nodeid);
														//得到明细字段名称
														s = new StringBuffer();

														if(isbill==1){
                                                            s.append("select a.id as fieldid, ");
                                                            s.append("(select labelname from HtmlLabelInfo t ");
                                                            s.append("where t.languageid = 7 and t.indexid = a.fieldlabel) fieldNameCn,");
                                                            s.append("(select labelname from HtmlLabelInfo t where t.languageid = 8 and t.indexid = a.fieldlabel) fieldNameEn, ");
                                                            s.append("(select labelname from HtmlLabelInfo t where t.languageid = 9 and t.indexid = a.fieldlabel) fieldNameTw ");
														    s.append("from workflow_billfield a ");
														    s.append("where a.viewtype = '1' ");
                                                            s.append("and a.id in (select fieldid from ");
                                                            if(isMode) s.append(" workflow_modeview ");
                                                            else s.append(" workflow_nodeform ");
                                                            s.append("where isView=1 and nodeid=" + nodeid + ") ");//只取节点中显示的
                                                            s.append(" and a.detailtable= '" + detailtables.get(RecordSet.getInt("fieldGroupId")) + "' order by dsporder ");
														}else{
                                                            s.append("select a.fieldid, ");
                                                            s.append("(select fieldlable from workflow_fieldlable t ");
                                                            s.append("where t.langurageid = 7 and t.fieldid = a.fieldid and t.formid = a.formid) fieldNameCn,");
                                                            s.append("(select fieldlable from workflow_fieldlable t where t.langurageid = 8 and t.fieldid = a.fieldid ");
                                                            s.append("and t.formid = a.formid) fieldNameEn, ");
                                                            s.append("(select fieldlable from workflow_fieldlable t where t.langurageid = 9 and t.fieldid = a.fieldid ");
                                                            s.append("and t.formid = a.formid) fieldNameTw ");
														    s.append("from workflow_formfield a ");
														    s.append("where a.isdetail = '1' ");
                                                            s.append("and a.fieldid in (select fieldid from ");
                                                            if(isMode) s.append(" workflow_modeview ");
                                                            else s.append(" workflow_nodeform ");
                                                            s.append("where isView=1 and nodeid=" + nodeid + ") ");//只取节点中显示的
                                                            s.append("and a.groupId = " + RecordSet.getInt("fieldGroupId") + " and a.formid="+billid+" order by fieldorder ");
														}

														rs.executeSql(s.toString());
														//out.println(s.toString());
														s1 = new StringBuffer();
														s2 = new StringBuffer();
														out.println("<TR class=Line><TD style=\"height:3px\"></TD></TR>");
														out.println("<!-- detail start --><tr><td><table id=dettb border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
														/*明细标题*/

														out.println("<tr bgcolor=#D2D2D2><td>" + SystemEnv.getHtmlLabelName(104, user.getLanguage()) + "</td>");
														while (rs.next()) {
															fieldMap.put(rs.getString("fieldid"), rs.getString("fieldid") + "");
															out.println("<td>&nbsp;");
															if(user.getLanguage()==7) {
																out.println(rs.getString("fieldNameCn"));
															}
															else if(user.getLanguage()==9) {
																out.println(rs.getString("fieldNameTw"));
															}
															else {
																out.println(rs.getString("fieldNameEn"));
															}
															out.println("&nbsp;</td>");
														}
														out.println("</tr>");
														out.println("<TR bgcolor=#A1A1A1><TD style=\"height:2px\" colSpan=" + rs.getCounts() + 1 + "></TD></TR>");

														/*END 明细标题*/
													}
													if (esn == -1 || esn != RecordSet.getInt("sn")) {
														esn = RecordSet.getInt("sn");
														if (isDetailRowRow == true) {
															if (!s1.toString().equals(""))
																out.println(s1.toString() + "</tr>");
															if (!s2.toString().equals(""))
																out.println(s2.toString() + "</tr>");
															isDetailRowRow = false;
														}
														s1 = new StringBuffer();
														s2 = new StringBuffer();
														isDetailRowRow = true;
														if (RecordSet.getInt("opttype") == 1)//新增的情况下
															s1.append("<tr><td class=add>" + typeMap.get(RecordSet.getString("optType")) + "</td>");
														if (RecordSet.getInt("opttype") == 2) {//修改的情况下
															//s2 = new StringBuffer();
															s1.append("<tr bgcolor=#EAEAEA><td class=mod>" + typeMap.get(RecordSet.getString("optType")) + "(" + SystemEnv.getHtmlLabelName(502, user.getLanguage()) + ")</td>");
															s2.append("<tr><td class=mod>" + typeMap.get(RecordSet.getString("optType")) + "(" + SystemEnv.getHtmlLabelName(21673, user.getLanguage()) + ")</td>");
														}
														if (RecordSet.getInt("opttype") == 3)//删除的情况下
															s1.append("<tr><td class=del>" + typeMap.get(RecordSet.getString("optType")) + "</td>");
													}

													if (fieldMap.get(RecordSet.getString("fieldid")) != null) {//不在列表中的字段不显示
														if (RecordSet.getInt("opttype") == 1) {//新增
															s1.append("<td class=add>&nbsp;" + FieldValue.getFieldValue(session, RecordSet.getInt("fieldid"), RecordSet.getInt("fieldHtmlType"), RecordSet.getInt("fieldType"), Util.null2String(RecordSet.getString("fieldNewText")), RecordSet.getInt("isBill")) + "</td>");
														} else if (RecordSet.getInt("opttype") == 2) {//修改
															s1.append("<td class=mod>&nbsp;" + FieldValue.getFieldValue(session, RecordSet.getInt("fieldid"), RecordSet.getInt("fieldHtmlType"), RecordSet.getInt("fieldType"), Util.null2String(RecordSet.getString("fieldOldText")), RecordSet.getInt("isBill")) + "</td>");
															s2.append("<td class=mod>&nbsp;" + FieldValue.getFieldValue(session, RecordSet.getInt("fieldid"), RecordSet.getInt("fieldHtmlType"), RecordSet.getInt("fieldType"), Util.null2String(RecordSet.getString("fieldNewText")), RecordSet.getInt("isBill")) + "</td>");
														} else if (RecordSet.getInt("opttype") == 3) {//删除
															s1.append("<td class=del>&nbsp;" + FieldValue.getFieldValue(session, RecordSet.getInt("fieldid"), RecordSet.getInt("fieldHtmlType"), RecordSet.getInt("fieldType"), Util.null2String(RecordSet.getString("fieldOldText")), RecordSet.getInt("isBill")) + "</td>");
														}
													}
												}
												//判断是否已经到尾部,到了关闭标签
												if (sid == cnt) {
													if (isDetailRowRow == true) {
														if (!s1.toString().equals(""))
															out.println(s1.toString() + "</tr>");
														if (!s2.toString().equals(""))
															out.println(s2.toString() + "</tr>");
														isDetailRowRow = false;
													}
													//System.out.println("s1="+s1.toString());
													//System.out.println("s2="+s2.toString());
													s1 = new StringBuffer();
													s2 = new StringBuffer();
													//关闭明细列表
													if (isDetailClose == true) {
														out.println("<!-- 3.detail end --></table></td></tr>");
														isDetailClose = false;
													}
													//判断主字段内容是否开启,开启则关闭
													if (isContentClose == true) {
														out.println("</table><!-- 3.content end -->");
														isContentClose = false;
													}
													//关闭明细标签
													if (isDetailRow == true) {
														out.println("<!-- 关闭明细 --></table>");
														isDetailRow = false;
													}
										%>
										</td>
										</tr>
										<tr>
											<td colspan="2" height=8></td>
										</tr>
										<%
											}
												//判断第一次
												if (sid == 1) {
													isMatch = true;
												}
											}
										%>
										</tbody>
									</table>
									</td>
								</tr>
						</table>
			<%
if (cnt == 0) {
        %>
        <div style="text-align:center;width:100%;">
        	<%=SystemEnv.getHtmlLabelName(22521,user.getLanguage())%>
        </div>
        <%
    }
%>



<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;" >	
			<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu" id="rightclickcornerMenu"></span>
		</td>
	</tr>
</table>
					
</BODY>
</HTML>

<script>
var URL = '/workflow/request/RequestModifyLogViewIframe.jsp?requestid=<%=requestid%>&nodeid=<%=pnodeid%>';
function doViewAll(flag) {
	location.href = URL+"&isAll="+flag+"&ismonitor=<%=ismonitor%>&urger=<%=urger%>";
}
function doBack() {
	location.href = 'ViewRequest.jsp?requestid=<%=requestid%>';
}
</script>