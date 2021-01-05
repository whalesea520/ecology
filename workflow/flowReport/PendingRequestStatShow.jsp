
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.util.*" %>
<%@ page import="weaver.teechart.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/browserTag" prefix="brow" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="subCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="workTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="workflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="shareRights" class="weaver.workflow.report.UserShareRights" scope="page"/>
<jsp:useBean id="WorkflowVersion" class="weaver.workflow.workflow.WorkflowVersion" scope="page" />
<jsp:useBean id="ReportAuthorization" class="weaver.workflow.report.ReportAuthorization" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
		<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
		<style>
			#loadingExcel {
				position: absolute;
				background: #ffffff;
				left: 50%;
				top: 40%;
				padding: 8px;
				z-index: 20001;
				height: auto;
				border: 1px solid #ccc;
				display: none;
			}
			TABLE.ListStyle TR.Tot TD {
				BACKGROUND-COLOR: #ECFDEA;
			}
			TABLE.ListStyle TR.Tot TD.Tit {
				FONT-WEIGHT: BOLD;
				TEXT-ALIGN: RIGHT;
			}
			TABLE.ListStyle TR.Tot TD.Num,TABLE.ListStyle TR TD.TypeName a,TABLE.ListStyle TR TD.FlowName a {
				COLOR: #538DD5;
			}
			TABLE.ListStyle TR.Obj TD.Num {
				FONT-WEIGHT: BOLD;
			}
			TABLE.ListStyle TR {
				vertical-align: middle;
			}
			TABLE.ListStyle TR TD {
				border-top:1px #E9E9E2 solid;
				height: 30px;
				vertical-align: middle;
				text-overflow: ellipsis;
				white-space: nowrap;
				word-break: keep-all;
				overflow: hidden;
			}
		</style>
	</head>

	<BODY>
<%
	String imagefilename = "/images/hdReport_wev8.gif";
	String needfav = "1";
	String needhelp = "";

	String titlename = SystemEnv.getHtmlLabelName(19028, user.getLanguage());
	String userRights = ReportAuthorization.getUserRights("-2", user);//得到用户查看范围
	if (userRights.equals("-100")) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	String objType = SystemEnv.getHtmlLabelName(1867, user.getLanguage());

	int objType1 = Util.getIntValue(request.getParameter("objType"), 1);
	String objIds = Util.null2String(request.getParameter("objId"));
	String objNames = "";
	if (!"".equals(objIds)) {		
		if (objIds.startsWith(",")) {
			objIds = objIds.replaceFirst(",", "");
		}
		String[] objIdArr = objIds.split(",");
		switch (objType1){
			case 1:
				if (objIdArr.length == 1) {
					objNames = Util.toScreen(resourceComInfo.getLastname(objIdArr[0]), user.getLanguage());
				} else {
					StringBuilder sb = new StringBuilder();
					for(int i = 0; i < objIdArr.length; i++) {
						if(i > 0){
							sb.append(",");
						}
						sb.append(Util.toScreen(resourceComInfo.getLastname(objIdArr[i]), user.getLanguage()));
					}
					objNames = sb.toString();
				}
		      	break;
			case 2:
				if (objIdArr.length == 1) {
					objNames = Util.toScreen(departmentComInfo.getDepartmentname(objIdArr[0]), user.getLanguage());
				} else {
					StringBuilder sb = new StringBuilder();
					for(int i = 0; i < objIdArr.length; i++) {
						if(i > 0){
							sb.append(",");
						}
						sb.append(Util.toScreen(departmentComInfo.getDepartmentname(objIdArr[i]), user.getLanguage()));
					}
					objNames = sb.toString();
				}
				break;
			case 3:
				if (objIdArr.length == 1) {
					objNames = Util.toScreen(subCompanyComInfo.getSubCompanyname(objIdArr[0]), user.getLanguage());
				} else {
					StringBuilder sb = new StringBuilder();
					for(int i = 0; i < objIdArr.length; i++) {
						if(i > 0){
							sb.append(",");
						}
						sb.append(Util.toScreen(subCompanyComInfo.getSubCompanyname(objIdArr[i]), user.getLanguage()));
					}
					objNames = sb.toString();
				}
				break;
		}
	}
	String typeId=Util.null2String(request.getParameter("typeId"));//得到搜索条件
	String wfIds = Util.null2String(request.getParameter("wfId"));
	String allVersionsWfIds =  WorkflowVersion.getAllVersionStringByWFIDs(wfIds);
	String wfNames = "";
	if (!"".equals(wfIds)) {
		if (wfIds.startsWith(",")) {
			wfIds = wfIds.replaceFirst(",", "");
		}
		String[] wfIdArr = wfIds.split(",");
		if (wfIdArr.length == 1) {
			wfNames = Util.toScreen(workflowComInfo.getWorkflowname(wfIdArr[0]), user.getLanguage());
		} else {
			StringBuilder sb = new StringBuilder();
			for(int i = 0; i < wfIdArr.length; i++) {
				if(i > 0){
					sb.append(",");
				}
				sb.append(Util.toScreen(workflowComInfo.getWorkflowname(wfIdArr[i]), user.getLanguage()));
			}
			wfNames = sb.toString();
		}
	}
	String datefrom = Util.toScreenToEdit(request.getParameter("datefrom"), user.getLanguage());
	String dateto = Util.toScreenToEdit(request.getParameter("dateto"), user.getLanguage());

	String devfromdate = Util.null2String(request.getParameter("devfromdate"));
	String devtodate = Util.null2String(request.getParameter("devtodate"));
	

	String sqlCondition = " "; //未查询前不显示记录

	String sql = "";

	String exportpara = "objType=" + objType1
			+ "&datefrom=" + datefrom + "&dateto=" + dateto + "&wfId="
			+ allVersionsWfIds + "&devfromdate=" + devfromdate + "&devtodate="
			+ devtodate + "&typeId=" + typeId;
	session.setAttribute("objIds",objIds);
	String newwhere = "";
	if (!datefrom.equals("")) {//开始日期

		newwhere = " workflow_currentoperator.receivedate >= '"
				+ datefrom + "'";//workflow_currentoperator.receivedate,workflow_currentoperator.receivetime
	}
	if (!dateto.equals("")) {//结束日期
		if (!newwhere.equals(""))
			newwhere += " and ";
		newwhere += " workflow_currentoperator.receivedate <= '"
				+ dateto + "' ";
	}
	
	if (!typeId.equals("")){
		if (!newwhere.equals(""))
			newwhere += " and ";
		newwhere += "  workflow_currentoperator.workflowtype=" + typeId;
	}

	if (!"".equals(devfromdate)) {
		sqlCondition = " and exists (select 1 from workflow_requestbase where requestid = workflow_currentoperator.requestid and createdate >='"
				+ devfromdate + "')";
	}
	if (!"".equals(devtodate)) {
		sqlCondition += " and exists (select 1 from workflow_requestbase where requestid = workflow_currentoperator.requestid and createdate <='"
				+ devtodate + "')";
	}
	//td11783 end

	String typeid = "";
	String typecount = "";
	String typename = "";
	String workflowid = "";
	String workflowcount = "";
	String newremarkwfcount0 = "";
	String newremarkwfcount1 = "";
	String workflowname = "";
	ArrayList users = new ArrayList();
	ArrayList wftypes = new ArrayList();
	ArrayList wftypecounts = new ArrayList();
	ArrayList workflows = new ArrayList();
	ArrayList workflowcounts = new ArrayList(); //总计
	ArrayList temp = new ArrayList();
	ArrayList newremarkwfcounts0 = new ArrayList();
	ArrayList wftypecounts0 = new ArrayList();
	ArrayList wfUsers = new ArrayList();
	ArrayList flowUsers = new ArrayList();
	if (userRights.equals("")) {
		sqlCondition += " and exists (select 1 from hrmresource where id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3))";
	} else {
		sqlCondition += " and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in ("
				+ userRights + ") and hrmresource.status in (0,1,2,3))";
	}
	//sqlCondition=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in ("+userRights+") and hrmresource.status in (0,1,2,3))";

	String sql2 = "";
	String sqlfrom = "";

	switch (objType1) {
	case 1:
		objType = SystemEnv.getHtmlLabelName(179, user.getLanguage());;
		sql = "select userid,workflowtype, workflowid,"
				+ " count(distinct requestid) workflowcount from "
				+ " workflow_currentoperator where "
				+ (allVersionsWfIds.equals("") ? "" : "workflowid in (" + allVersionsWfIds
						+ ") and ")
				+ (newwhere.equals("") ? "" : newwhere + " and ")
				+ "  workflowtype > 0 and isremark in ('0','1','5','8','9','7') and islasttimes=1 and  usertype='0' ";
		sql += " and ("+Util.getSubINClause(objIds,"userid","in")+")";
		sqlfrom = "workflow_currentoperator,workflow_requestbase a";
		sql2 = " where workflow_currentoperator.workflowtype>0 and workflow_currentoperator.isremark in ('0','1','5','8','9','7') and workflow_currentoperator.islasttimes=1 and  workflow_currentoperator.usertype='0'  and workflow_currentoperator.requestid=a.requestid";
		sql2 += (wfIds.equals("") ? ""
				: " and workflow_currentoperator.workflowid in ("
						+ allVersionsWfIds + ") ");
		sql2 += (newwhere.equals("") ? "" : " and " + newwhere);
		sql2 += sqlCondition;
		sql += sqlCondition;
		sql += " group by userid,workflowtype, workflowid ";
		sql += " order by userid,workflow_currentoperator.workflowtype, workflowid";
		
		break;
	case 2:
		sql = "select a.departmentid,workflowtype, workflowid,"
				+ " count(distinct requestid) workflowcount from "
				+ " workflow_currentoperator ,hrmresource a  where "
				+ (allVersionsWfIds.equals("") ? "" : "workflowid in (" + allVersionsWfIds
						+ ") and ")
				+ (newwhere.equals("") ? "" : newwhere + " and ")
				+ "  workflowtype > 0 and isremark in ('0','1','5','8','9','7') and  usertype='0' and islasttimes=1 and  a.id=workflow_currentoperator.userid ";
		sql += " and a.departmentid in (" + objIds + ")";
		sql += sqlCondition;
		sqlfrom = "workflow_currentoperator,hrmresource b ,workflow_requestbase a";
		sql2 = "where workflow_currentoperator.workflowtype>0 and workflow_currentoperator.isremark in ('0','1','5','8','9','7') and workflow_currentoperator.islasttimes=1 and  workflow_currentoperator.usertype='0'  and b.id=workflow_currentoperator.userid and workflow_currentoperator.requestid=a.requestid";
		sql2 += (allVersionsWfIds.equals("") ? ""
				: " and workflow_currentoperator.workflowid in ("
						+ allVersionsWfIds + ") ");
		sql2 += (newwhere.equals("") ? "" : " and " + newwhere);
		sql2 += sqlCondition;
		sql += " group by a.departmentid,workflowtype, workflowid ";
		sql += " order by a.departmentid,workflow_currentoperator.workflowtype, workflowid";
		objType = SystemEnv.getHtmlLabelName(124, user.getLanguage());
		break;
	case 3:
		sql = "select a.subcompanyid1,workflowtype, workflowid,"
				+ " count(distinct requestid) workflowcount from "
				+ " workflow_currentoperator ,hrmresource a  where "
				+ (allVersionsWfIds.equals("") ? "" : "workflowid in (" + allVersionsWfIds
						+ ") and ")
				+ (newwhere.equals("") ? "" : newwhere + " and ")
				+ "  workflowtype > 0 and isremark in ('0','1','5','8','9','7') and islasttimes=1 and  usertype='0' and a.id=workflow_currentoperator.userid ";
		sql += " and a.subcompanyid1 in (" + objIds + ")";
		sql += sqlCondition;

		sqlfrom = "workflow_currentoperator,hrmresource b ,workflow_requestbase a";
		sql2 = " where workflow_currentoperator.workflowtype>0 and workflow_currentoperator.isremark in ('0','1','5','8','9','7') and workflow_currentoperator.islasttimes=1 and  workflow_currentoperator.usertype='0'  and b.id=workflow_currentoperator.userid and workflow_currentoperator.requestid=a.requestid";
		sql2 += (allVersionsWfIds.equals("") ? ""
				: " and workflow_currentoperator.workflowid in ("
						+ allVersionsWfIds + ") ");
		sql2 += (newwhere.equals("") ? "" : " and " + newwhere);
		sql2 += sqlCondition;

		sql += " group by a.subcompanyid1,workflowtype, workflowid ";
		sql += " order by a.subcompanyid1,workflow_currentoperator.workflowtype, workflowid";
		objType = SystemEnv.getHtmlLabelName(141, user.getLanguage());
		break;
	}
	RecordSet.writeLog("==============sql="+sql);
	if (!"".equals(objIds)) {
		RecordSet.executeSql(sql);
		//System.out.println("===========================>sql= " + sql);
		while (RecordSet.next()) {
			String theworkflowid = Util.null2String(RecordSet.getString("workflowid"));
			String objId = Util.null2String(RecordSet.getString(1));
			String theworkflowtype = Util.null2String(RecordSet.getString("workflowtype"));
			int theworkflowcount = Util.getIntValue(RecordSet.getString("workflowcount"), 0);
			theworkflowid = WorkflowVersion.getActiveVersionWFID(theworkflowid);
			if (workflowComInfo.getIsValid(theworkflowid).equals("1")) {
				int userIndex = users.indexOf(objId);
				int wfindex = workflows.indexOf(objId+","+theworkflowid);
	            if(wfindex != -1) {
		     	String beforecount[] = newremarkwfcounts0.get(wfindex).toString().split(",");
	                int wfCount  = Util.getIntValue(beforecount[2]) + theworkflowcount;	                
	                //System.out.println("===========================>theworkflowid= "+ theworkflowid + ", " +beforecount[1] + ":"+ beforecount[2]);
	                //System.out.println("===========================>workflows= "+ workflows + ", newremarkwfcounts0=" +newremarkwfcounts0 + ", wfindex="+ wfindex + ", addindex="+ addindex + "\n\n");
	                //System.out.println("========================workflows= " + workflows + "\n\n\n");
	            	newremarkwfcounts0.set(wfindex, objId+","+theworkflowid+","+wfCount);
	            }else{
	                workflows.add(objId+","+theworkflowid);
	                newremarkwfcounts0.add(objId+","+theworkflowid+","+theworkflowcount);
	            }
				flowUsers.add(objId);
				int wftindex = wftypes.indexOf(theworkflowtype);
				int tempIndex = temp.indexOf(objId + "$"+ theworkflowtype);
				if (userIndex != -1) {
					workflowcounts.set(userIndex,""+ (Util.getIntValue((String) workflowcounts.get(userIndex),0) + theworkflowcount));
					if (tempIndex != -1) {
						wftypecounts.set(tempIndex,""+ (Util.getIntValue((String) wftypecounts.get(tempIndex),0) + theworkflowcount));
					} else {
						temp.add(objId + "$" + theworkflowtype);
						wftypes.add(theworkflowtype);
						wfUsers.add(objId);
						wftypecounts.add("" + theworkflowcount);
					}
				} else {
					temp.add(objId + "$" + theworkflowtype);
					users.add(objId);
					workflowcounts.add("" + theworkflowcount);
					wftypes.add(theworkflowtype);
					wfUsers.add(objId);
					wftypecounts.add("" + theworkflowcount);
				}

			}
		}
	}
%>

		<!-- start -->
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage())
					+ ",javascript:submitData(),_self}";
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+ SystemEnv.getHtmlLabelName(28343, user.getLanguage())
					+",javascript:doExportExcel(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan" style="text-align: right;">
					<input type="button" class="e8_btn_top_first" value="<%=SystemEnv.getHtmlLabelName(82529, user.getLanguage())%>" onClick="submitData();" />
					<input type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(28343, user.getLanguage())%>" onClick="doExportExcel();" />
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<div id="mainDiv">
			<FORM id=frmMain name=frmMain action=PendingRequestStatShow.jsp method=post>
	
				<wea:layout type="4col" attributes="{expandAllGroup:true}">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(15774, user.getLanguage())%>'>
						<wea:item><%=objType%>
							<input type="hidden" name="objType" value="<%=objType1%>" />
						</wea:item>
						<wea:item>
							<brow:browser width="200px" viewType="0" name="objId" browserValue='<%=objIds%>' 
							    getBrowserUrlFn="getObjWindowUrl"
							    completeUrl="javascript:getAjaxUrl();"
								hasInput="true" isSingle="false" hasBrowser="true"
								isMustInput="2"
								browserSpanValue='<%=objNames%>'></brow:browser>
						</wea:item>

						<wea:item><%=SystemEnv.getHtmlLabelName(33234, user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="typeId"
								browserValue='<%=typeId%>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser.jsp"
								_callback="changeFlowType"
								hasInput="true" isSingle="true" hasBrowser="true"
								isMustInput="1" completeUrl="/data.jsp?type=worktypeBrowser"
								browserDialogWidth="600px"
								browserSpanValue='<%=workTypeComInfo.getWorkTypename(typeId)%>'>
							</brow:browser>
						</wea:item>
						
						<!-- 工作流 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="wfId"
								browserValue='<%=wfIds%>'
								getBrowserUrlFn="getFlowWindowUrl" hasInput="true"
								isSingle="true" hasBrowser="true" isMustInput="1"
								completeUrl="/data.jsp?type=workflowBrowser"
								browserSpanValue='<%=wfNames%>'>
							</brow:browser>
						</wea:item>
						
						<%--
						<wea:item><%=SystemEnv.getHtmlLabelName(18104, user.getLanguage())%></wea:item>
						<wea:item>

					        <brow:browser viewType="0" name="wfId" browserValue='<%=wfIds %>' 
					        	 browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp" 
					        	 idKey="id" nameKey="name"  hasInput="true" width="80%" isSingle="false" 
					        	 hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=workflowBrowser"  
					        	 browserSpanValue='<%=(wfNames) %>'>
					        </brow:browser>
						</wea:item> --%>

						<wea:item><%=SystemEnv.getHtmlLabelName(124799, user.getLanguage())%></wea:item>
						<wea:item>
							<span class="wuiDateSpan" selectId="dateselect" >
								<input class=wuiDateSel type="hidden" name="datefrom" value="<%=datefrom%>">
								<input class=wuiDateSel type="hidden" name="dateto" value="<%=dateto%>">
							</span>
						</wea:item>

						<!-- 创建日期 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(722, user.getLanguage())%></wea:item>
						<wea:item>
							<span class="wuiDateSpan" selectId="devdateselect">
								<input class=wuiDateSel type="hidden" name="devfromdate" value="<%=devfromdate%>">
								<input class=wuiDateSel type="hidden" name="devtodate" value="<%=devtodate%>">
							</span>
						</wea:item>
					</wea:group>

					<wea:group context='<%=SystemEnv.getHtmlLabelName(33518, user.getLanguage())%>'>
						<wea:item attributes="{'colspan':'full','isTableList':'true'}">

							<%
								int total = 0;
								if (!"".equals(objIds)) {
								  	for (int i=0;i<users.size();i++) {
										total += Util.getIntValue("" + workflowcounts.get(i), 0);
									}
								}
							%>
							<TABLE class="ListStyle" cellspacing="0" style="table-layout: fixed;">
									<!--详细内容在此-->
								  <col width="350px"> 
								  <col width="150px">
								<thead>
									<TR class="HeaderForXtalbe"> 
										<th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=objType%></th>
										<th><%=SystemEnv.getHtmlLabelName(1207, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(16851, user.getLanguage())%></th>
										<th>
											<span><%=SystemEnv.getHtmlLabelName(31143, user.getLanguage())%></span>
											<span class="xTable_algorithmdesc" title="<%=SystemEnv.getHtmlLabelName(24518, user.getLanguage())%>=<%=objType%><%=SystemEnv.getHtmlLabelName(124803, user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(124804, user.getLanguage())%>/<%=objType%><%=SystemEnv.getHtmlLabelName(124806, user.getLanguage())%>">
											<img style="vertical-align:top;" src="/images/info_wev8.png">
											</span>
										</th>
									</tr>
								</thead>
								<tbody>
									<%if (users.size() > 0) { %>
									<tr class="Tot">
										<td class="Tit"><%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%></td>
										<td class="Num"><%=total%></td>
										<td></td>
									</tr>
									<%
									}%>
								</tbody>
							</TABLE>
							<div id="mytableflow" style="overflow:auto;">
	  						 <div>
							<TABLE class="ListStyle" cellspacing="0" style="table-layout: fixed;">
									<!--详细内容在此-->
								  <col width="350px"> 
								  <col width="150px">
								<tbody>
									<%
  									//BarTeeChart bar = null;
										//bar = TeeChartFactory.createBarChart(SystemEnv.getHtmlLabelName(19028, user.getLanguage()), 700, 2000);
										//bar.isDebug();
										//bar.setMarksStyle(BarTeeChart.SMS_Value);
										//if (users.size() > 1)
											//bar.setExternalJs("if(document.all('seriesType3'))document.all('seriesType3').disabled=true;");
										//List maxList = new ArrayList();
										//List tmpList = new ArrayList();
										//Map[] dataMap = new HashMap[users.size()];
										String chartTitle = null;
										String percentString = "0.00%";
										int objCount = 0;
										for (int i = 0; i < users.size(); i++) {
											String sql3 = "";
											String userId = "" + users.get(i);
											//dataMap[i] = new HashMap();
	  								%>
									<tr class="Obj">
										<td >
											<span name="img<%=i%>_" onclick="changeImg('img<%=i%>_','detail<%=i%>_', true)" style="cursor:hand;float:left;">
												<IMG SRC="/images/-_wev8.png" BORDER="0" HEIGHT="9px" WIDTH="9px"></img>
											</span>
											&nbsp;
										<%
											switch (objType1) {
										case 1:
											sql3 = sql2+ " and workflow_currentoperator.userid="+ users.get(i);
											out.print("<a href='javaScript:openhrm("
															+ users.get(i)+ ");' onclick='pointerXY(event);'>"
															+ resourceComInfo.getLastname(""+ users.get(i))
															+ "</a>");
											chartTitle = resourceComInfo.getLastname(""+ users.get(i));
											break;
										case 2:
											sql3 = sql2 + " and  b.departmentid="+ users.get(i);
											out.print("<a href='/hrm/company/HrmDepartmentDsp.jsp?id="
															+ users.get(i)+ "' target='_new'>"
															+ departmentComInfo.getDepartmentname(""+ users.get(i))
															+ "</a>");
											chartTitle = departmentComInfo.getDepartmentname(""+ users.get(i));
											break;
										case 3:
											sql3 = sql2 + " and  b.subcompanyid1="+ users.get(i);
											out.print("<a href='/hrm/company/HrmSubCompanyDsp.jsp?id="
															+ users.get(i)+ "' target='_new'>"
															+ subCompanyComInfo.getSubCompanyname(""+ users.get(i))
															+ "</a>");
											chartTitle = subCompanyComInfo.getSubCompanyname(""+ users.get(i));
											break;
										}
										%></td>
										<%
											objCount = Util.getIntValue("" + workflowcounts.get(i), 0);
											if (total > 0) {
											    percentString = "" + (objCount * 100D / total);
											    percentString = Util.round(percentString, 2) + "%";
										    }
									    %>
										<td class="Num"><a href="WorkflowList.jsp?sql=<%=xssUtil.put(sql3)%>&fromsql=<%=xssUtil.put(sqlfrom)%>" target="_newlist"><%=objCount%></a></td>
										<td>
										   	<div class="e8_outPercent">
												<span class="e8_innerPercent" style="width:<%=percentString%>"></span>
												<span class="e8_innerText"><%=percentString%></span>
											</div>
										</td>
									</tr>
									<%
										int j0 = 0;
										for (int j = 0; j < wftypes.size(); j++) {
											j0++;
											String tempObjId = "" + wfUsers.get(j);
											String wfId = "" + wftypes.get(j);
											if (!tempObjId.equals(userId))
												continue;
											/*****************************/
											//dataMap[i].put(workTypeComInfo.getWorkTypename(wfId),wftypecounts.get(j).toString());
											//tmpList.add(workTypeComInfo.getWorkTypename(wfId));
											/*****************************/
									%>
									<tr name="detail<%=i%>_">
										<td class="TypeName">
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<span name="img<%=i%>_<%=j0%>" onclick="changeImg('img<%=i%>_<%=j0%>','detail<%=i%>_<%=j0%>')" style="cursor:hand">
												<IMG SRC="/images/+_wev8.png"  BORDER="0" HEIGHT="9px" WIDTH="9px"></img>
									    	</span>&nbsp;
											<a href="WorkflowList.jsp?sql=<%=xssUtil.put(sql3)%>&fromsql=<%=xssUtil.put(sqlfrom)%>&workflowtypeid=<%=wfId%>" target="_newlist"><%=workTypeComInfo.getWorkTypename(wfId)%></a>
										</td>
										<%
											percentString = "0.00%";
											int typeCount = Util.getIntValue("" + wftypecounts.get(j), 0);
											if (objCount > 0) {
											    percentString = "" + (typeCount * 100D / objCount);
											    percentString = Util.round(percentString, 2) + "%";
										    }
									    %>
										<td><%=typeCount%></td>
										<td>
										   	<div class="e8_outPercent" style="border:1px solid #F2D39C;">
												<span class="e8_innerPercent" style="background-color:#F2D39C;width:<%=percentString%>"></span>
												<span class="e8_innerText"><%=percentString%></span>
											</div>
										</td>
									</tr>
									
									<%
										for (int k = 0; k < workflows.size(); k++) {
											String wflowid = (String) workflows.get(k);
											String wfid01[] = wflowid.split(",");
											String wfisshow = wfid01[1];
											
											String curtypeid = workflowComInfo.getWorkflowtype("" + wfisshow);
											if(!curtypeid.equals(wfId) || !wfid01[0].equals(userId))
												continue;
											
											//String tempUser = "" + flowUsers.get(k);
											//if (!curtypeid.equals(wfId) || !tempUser.equals(userId))
											//	continue;
											
											String wfcountisshow = "";
											
											for(int x=0;x<newremarkwfcounts0.size();x++){
												String wfcount01[] = newremarkwfcounts0.get(x).toString().split(",");
												if(!userId.equals(wfcount01[0]) || !wfisshow.equals(wfcount01[1]))
													continue;
													
												wfcountisshow = wfcount01[2];
											}
											
									%>
									<tr name="detail<%=i%>_<%=j0%>" style="display:none;">
										<td class="FlowName">
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										　　	<a href="WorkflowList.jsp?sql=<%=xssUtil.put(sql3)%>&fromsql=<%=xssUtil.put(sqlfrom)%>&workflowid=<%=wfisshow%>" target="_newlist"><%=workflowComInfo.getWorkflowname("" + wfisshow)%></a>
										</td>
										<td>
										<%=wfcountisshow%>
										</td>
										<td></td>
									</tr>
								
									<%
											workflows.remove(k);
											//	flowUsers.remove(k);
											newremarkwfcounts0.remove(k);
											--k;
											}
											//wftypes.remove(j);
											//wfUsers.remove(j);
											//wftypecounts.remove(j);
											//j--;

										}
												//dataMap[i].put("title", chartTitle + "("+ workflowcounts.get(i) + ")");
										}

											//HashSet hprstmp = new HashSet(tmpList);
											//tmpList.clear();
											//tmpList.addAll(hprstmp);
											//maxList = tmpList;

											//BarChartModel bc = null;
											//String tmp = null;
											//for (int i = 0; i < dataMap.length; i++) {
												//tmpList = new ArrayList();
												//for (int n = 0; n < maxList.size(); n++) {
													//tmp = maxList.get(n).toString();
													//bc = new BarChartModel();
													//bc.setCategoryName(tmp);
													//bc.setValue(dataMap[i].containsKey(tmp) ? dataMap[i].get(tmp).toString(): "0");
													//tmpList.add(bc);
												//}
												//if (dataMap.length == 1)
													//bar.addSeries(dataMap[i].get("title").toString(), tmpList, "");
												//else
													//bar.addSeries(dataMap[i].get("title").toString(), tmpList);//这里颜色为空表示list中每一项都为随机色
											//}//End for.

										//没有记录的人员/部门/分部
										ArrayList queryObj = Util.TokenizerString(objIds, ",");
										for (int m = 0; m < queryObj.size(); m++) {
											String tempRights = "," + userRights + ",";
											if (users.indexOf("" + queryObj.get(m)) == -1 && tempRights.indexOf("," + resourceComInfo.getDepartmentID("" + queryObj.get(m)) + ",") > 0) {
								%>
									<tr class="Obj">
									<td>
										<span style="cursor:hand;float:left;">
											<IMG SRC="/images/-_wev8.png" BORDER="0" HEIGHT="9px" WIDTH="9px"></img>
										</span>
										&nbsp;
									<%
										switch (objType1) {
											case 1:
												out.print("<a href='javaScript:openhrm("
																+ queryObj.get(m)+ ");' onclick='pointerXY(event);'>"
																+ resourceComInfo.getLastname(""+ queryObj.get(m))
																+ "</a>");
												break;
											case 2:
												out.print("<a href='/hrm/company/HrmDepartmentDsp.jsp?id="
																+ queryObj.get(m)+ "' target='_new'>"
																+ departmentComInfo.getDepartmentname(""+ queryObj.get(m))
																+ "</a>");
												break;
											case 3:
												out.print("<a href='/hrm/company/HrmSubCompanyDsp.jsp?id="
																+ queryObj.get(m)+ "' target='_new'>"
																+ subCompanyComInfo.getSubCompanyname(""+ queryObj.get(m))
																+ "</a>");
												break;
											}
										%>
									</td>
									<td class="Num">0</td>
									<td></td>
									</tr>
									<%}}
										if (users.size() > 0) {
									%>
									<tr class="Tot">
										<td class="Tit"><%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%></td>
										<td class="Num"><%=total%></td>
										<td></td>
									</tr>
									<%}%>
								</tbody>
							</table>
								<!--详细内容结束-->
							</div>
							</div>

						</wea:item>
					</wea:group>
					</wea:layout>

			</FORM>
		</div>

		<jsp:include page="/workflow/flowReport/IncludeExcelBody.jsp">
			<jsp:param name="exportProcess" value="flowTime"></jsp:param>
			<jsp:param name="exportSQL" value="<%=xssUtil.put(exportpara)%>"></jsp:param>
		</jsp:include>
		<!-- end -->

	</body>

<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

<script type="text/javascript">
	function changeFlowType() {
		_writeBackData('wfId', 1, {id:'',name:''});
	}

	function resizeMyTable() {
		var height = jQuery('body').height() - 200;
		if (height <= 100) {
			height = 100;
		}
		jQuery('#mytableflow').height(height);
	}

	jQuery(document).ready(function() {
		jQuery('.ListStyle td,.ListStyle th').each(function() {
			jQuery(this).attr('title', jQuery(this).text().trim());
		});
		resizeMyTable();
		jQuery('body').resize(function(){
	    	resizeMyTable();
	    });
	});

	function doExportExcel(){
		jQuery("#loadingExcel").show();
		document.getElementById("exportExcel").src = "PendingRequestStatXLS.jsp?<%=exportpara%>&rund="+(new Date().getTime());
	}

	function submitData(){
		if (check_form(frmMain,'objId')) {
			$G("frmMain").submit();
		}
	}

	function getObjWindowUrl() {
		var objType1 = <%=objType1%>;
		if (objType1 == 2) {
			var tmpids = document.all('objId').value;
			return "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" + tmpids + "&selectedDepartmentIds=" + tmpids+"&show_virtual_org=-1";
		} else if (objType1 == 3) {
			var tmpids = document.all('objId').value;
			return "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=" + tmpids + "&selectedDepartmentIds=" + tmpids+"&show_virtual_org=-1";
		} else {
			return "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" + $G('objId').value;
		}           
	}

	function setHref(a, type) {
		var para = 'objType=' + type
				 + '&wfId=' + $G('wfId').value
				 + '&dateselect=' + $G('dateselect').value
				 + '&devdateselect=' + $G('devdateselect').value
				 + '&datefrom=' + $G('datefrom').value
				 + '&dateto=' + $G('dateto').value
				 + '&devfromdate=' + $G('devfromdate').value
				 + '&devtodate=' + $G('devtodate').value;
		jQuery(a).attr('href', '/workflow/flowReport/PendingRequestStatShow.jsp?' + para);
	}

	function changeImg(obj1, obj2, isStarts) {
		var trs;
		var spans;
		if (isStarts) {
			trs = jQuery('tr[name^=' + obj2 + ']');
			spans = jQuery('span[name^=' + obj1 + ']');
		} else {
			trs = jQuery('tr[name=' + obj2 + ']');
			spans = jQuery('span[name=' + obj1 + ']');
		}
		if (trs.length > 0) {
			if (trs.css('display') == 'none') {
				spans.html("<IMG SRC='/images/-_wev8.png' BORDER=0 HEIGHT=9px WIDTH=9px></img>");
				trs.show();
			} else {
				spans.html("<IMG SRC='/images/+_wev8.png' BORDER=0 HEIGHT=9px WIDTH=9px></img>");
				trs.hide();
			}
		}
	}

	function getFlowWindowUrl(){
		return "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowTypeBrowser.jsp?typeid=" + $G("typeId").value;
	}
	
	function getAjaxUrl(){
		var objType1 = <%=objType1%>;
		var url = "";
		if (objType1 == 2) {
			url = "/data.jsp?type=4";
		} else if (objType1 == 3) {
			url = "/data.jsp?type=164";
		} else {
			url = "/data.jsp";
		}
		return url;
	}
</script>
</html>
