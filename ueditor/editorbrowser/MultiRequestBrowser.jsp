
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util,java.text.SimpleDateFormat" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.workflow.request.RequestBrowser"%>
<%@ page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@ page import="weaver.general.GCONST"%>
<%@ page import="weaver.general.IsGovProj"%>
<%@ page import="weaver.docs.category.CategoryUtil"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo"
	class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo"
	class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo"
	class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo"
	class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo"
	class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="crmComInfo"
	class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="sysInfo" class="weaver.system.SystemComInfo"
	scope="page" />
<jsp:useBean id="Browsedatadefinition" class="weaver.workflow.request.Browsedatadefinition" scope="page"/>
<HTML>
	<HEAD>
		<LINK rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
		<LINK rel="stylesheet" type="text/css" href="/css/ereportstyle_wev8.css">
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script language=javascript
			src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
		<script type='text/javascript'
			src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
		<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
		<script type="text/javascript"
			src="/js/dragBox/rightspluingForBrowser_wev8.js"></script>
			<script type="text/javascript">
			var parentWin = null;
		var dialog = null;
		var config = null;
		try {
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		} catch (e) {
		}
		$(document).ready(function(){
		   if(!!dialog && dialog.Title == "相关流程"){
		   	$("#objName").html(dialog.Title);
		   }else{
		    $("#objName").html("多请求");
		   }
		});
			</script>
		<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
		<style type="text/css">
.e8_box_d  td {
	vertical-align: middle;
	text-align: left;
	border-bottom: 1px solid #f3f2f2;
	height: 30px;
	white-space: nowrap;
	color: #929393;
	overflow: hidden;
	text-overflow: ellipsis;
}

.LayoutTable .fieldName {
	padding-left:20px!important;
}
</style>
	</HEAD>

	<%
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");//设置日期格式
		String currentdate=df.format(new Date());
	
		String sqlwhere = "";
		String userid = ""+user.getUID() ;
		String usertype="0";
		if(user.getLogintype().equals("2")) usertype="1";
		String fieldid =Util.null2String(request.getParameter("fieldid"));
		String title =Util.null2String(request.getParameter("title"));
		String currworkflowid = Util.null2String(request.getParameter("currworkflowid"));
	
		if(!fieldid.equals("")){
			String newwfs[]=fieldid.split("_");
			fieldid=newwfs[0];
		 }
	
		String issearch= Util.null2String(request.getParameter("issearch"));
		String requestname = Util.null2String(request.getParameter("requestname"));
		String creater = Util.null2String(request.getParameter("creater"));
		String createdatestart = Util.null2String(request.getParameter("createdatestart"));
		String createdateend = Util.null2String(request.getParameter("createdateend"));
		String isrequest = Util.null2String(request.getParameter("isrequest"));
		String requestmark = Util.null2String(request.getParameter("requestmark"));
		String prjids=Util.null2String(request.getParameter("prjids"));
		String crmids=Util.null2String(request.getParameter("crmids"));
		String workflowid=Util.null2String(request.getParameter("workflowid"));
		String department =Util.null2String(request.getParameter("department"));
		String status = Util.null2String(request.getParameter("status"));
		String subid=Util.null2String(request.getParameter("subid"));
		int date2during = Util.getIntValue(request.getParameter("date2during"), 0);

		int olddate2during = 0;
		BaseBean baseBean = new BaseBean();
		String date2durings = "";
		try {
			date2durings = Util.null2String(baseBean.getPropValue("wfdateduring", "wfdateduring"));
		} catch (Exception e) {
		}
		String[] date2duringTokens = Util.TokenizerString2(date2durings, ",");
		if (date2duringTokens.length > 0) {
			olddate2during = Util.getIntValue(date2duringTokens[0], 0);
		}
		if (olddate2during < 0 || olddate2during > 36) {
			olddate2during = 0;
		}

		String resourceids = Util.null2String(request.getParameter("resourceids"));
		String resourcenames = Util.null2String(request.getParameter("resourcenames"));
		
		List<Map<String, String>> list = null;
		if(!fieldid.equals("")&&!currworkflowid.equals("")){
			if (Browsedatadefinition.read(currworkflowid, fieldid)) {		
			   	list = Browsedatadefinition.getList();
			} else {
				list = new ArrayList<Map<String, String>>();
			}
		} else {
			list = new ArrayList<Map<String, String>>();
		}
		String check_per = Util.null2String(request.getParameter("resourceids"));
		
		if(list.size()>0){
			String requestname01 = Browsedatadefinition.getRequestname();
			String workflowtype = Browsedatadefinition.getWorkflowtype();
			String Processnumber = Browsedatadefinition.getProcessnumber();
			String createtype = Browsedatadefinition.getCreatetype();
			String createtypeid = Browsedatadefinition.getCreatetypeid();
			String createdepttype = Browsedatadefinition.getCreatedepttype();
			String department01 = Browsedatadefinition.getDepartment();
			String createsubtype = Browsedatadefinition.getCreatesubtype();
			String createsubid = Browsedatadefinition.getCreatesubid();
			String createdatetype = Browsedatadefinition.getCreatedatetype();
			String createdatestart01 = Browsedatadefinition.getCreatedatestart();
			String createdateend01 = Browsedatadefinition.getCreatedateend();
			String xgxmid = Browsedatadefinition.getXgxmid();
			String xgkhid = Browsedatadefinition.getXgkhid();
			String gdtype = Browsedatadefinition.getGdtype();
			String jsqjtype = Browsedatadefinition.getJsqjtype();

			if(requestname.equals("")&&issearch.equals("")){
		    	requestname=requestname01;
		    }

			if(workflowid.equals("")&&issearch.equals("")){
		    	workflowid=workflowtype;
		    }

			if(requestmark.equals("")&&issearch.equals("")){
		    	requestmark=Processnumber;
		    }

			if(createtype.equals("0")&&issearch.equals("")){
		    	 creater=creater;
		     }
		     if(createtype.equals("1")&&issearch.equals("")){
		    	 if(creater.equals("")){
		    	   creater=""+user.getUID();
		    	 }
		     }
		     if(createtype.equals("2")&&issearch.equals("")){
		    	 if(creater.equals("")){
		    		 creater=createtypeid;
		    	 } 
		     }

		     if(department.equals("")&&issearch.equals("")){
			     if(createdepttype.equals("0")){
			    	 department=department;
			     } 
			     
			     if(createdepttype.equals("1")){
			    	    department=""+user.getUserDepartment();
			     }
			     if(createdepttype.equals("2")){
			       if(department.equals("")){
				     department=""+department01;
				    } 
			     }
		     }

		     if(subid.equals("")&&issearch.equals("")){
			    if(createsubtype.equals("0")){
			    	subid=department;
			     } 
			     if(createsubtype.equals("1")){
			    	 subid=""+user.getUserSubCompany1();
			     }
			     if(createsubtype.equals("2")){
			       if(subid.equals("")){
			    	   subid=""+createsubid;
				    } 
			     } 
		 	}

		     if(createdatestart.equals("")&&createdateend.equals("")&&issearch.equals("")){
		    	  if(createdatetype.equals("2")){//今天
		    		  createdatestart=""+currentdate;
		    		  createdateend=""+currentdate;
		    	  }if(createdatetype.equals("3")){//本周
		    		  createdatestart=df.format(Browsedatadefinition.getMonday());
		    		  createdateend=df.format(Browsedatadefinition.getSunday());
		    	  }if(createdatetype.equals("4")){//本月
		    		  createdatestart=df.format(Browsedatadefinition.getFirstDayOfMonth());
		    		  createdateend=df.format(Browsedatadefinition.getLastDayOfMonth());
		    	  }if(createdatetype.equals("5")){//本季
		    		  createdatestart=df.format(Browsedatadefinition.getFirstDayOfQuarter());
		    		  createdateend=df.format(Browsedatadefinition.getLastDayOfQuarter());
		    	  }if(createdatetype.equals("6")){//本年
		    		  createdatestart=Browsedatadefinition.getYearDateStart();
		    		  createdateend=Browsedatadefinition.getYearDateEnd();
		    	  }if(createdatetype.equals("7")){//指定日期
		    		  createdatestart=createdatestart01;
		    		  createdateend=createdateend01; 
		    	  } 
		     } else {
		    	 if(createdatestart.equals("")&&issearch.equals("")){
		    		 createdatestart=createdatestart01;
			     }
			     if(createdateend.equals("")&&issearch.equals("")){
			    	 createdateend=createdateend01;
			     }
		     }

		     if(prjids.equals("")&&issearch.equals("")){
		    	 prjids=xgxmid;
		    }

		     if(crmids.equals("")&&issearch.equals("")){
		        crmids=xgkhid;
		    }

		     if(status.equals("")&&issearch.equals("")){
		    	 status=gdtype;
		     }

		     if(date2during==0){
		    	date2during=Util.getIntValue(jsqjtype,0);
		    } 
		   if (isrequest.equals("")) isrequest = "1";
		}
	%>
	<BODY scroll="no" style="overflow-x: hidden;overflow-y:hidden">
	<jsp:include page="/systeminfo/commonTabHead.jsp">
   		<jsp:param name="mouldID" value="workflow"/>
  	 	<jsp:param name="navName" value=""/>
	</jsp:include>
	<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_top"  onclick="javascript:document.SearchForm.btnsearch.click()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
	</table>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

		<FORM id=weaver name=SearchForm style="margin-bottom: 0" action="MultiRequestBrowser.jsp" method=post>
			<input type="hidden" name="pagenum" id="pagenum" value=''>
			<input type="hidden" name="resourceids" value="">
			<input type="hidden" name="isrequest" value='<%=isrequest%>'>
			<input type="hidden" name="issearch" id="issearch"  >
			<input type="hidden" name="currworkflowid" value="<%=currworkflowid%>">
			<input type="hidden" name="fieldid" value='<%=fieldid%>'>
			<DIV align=right style="display: none">
				<%
					RCMenu += "{"
							+ SystemEnv.getHtmlLabelName(197, user.getLanguage())
							+ ",javascript:document.SearchForm.btnsearch.click(),_self} ";
					RCMenuHeight += RCMenuHeightStep;
				%>
				<button type="button" class=btnSearch accessKey=S type=submit
					id=btnsearch onclick="btn_search();">
					<U>S</U>-<%=SystemEnv.getHtmlLabelName(197, user.getLanguage())%></BUTTON>
				<%
					RCMenu += "{" + SystemEnv.getHtmlLabelName(826, user.getLanguage())
							+ ",javascript:document.SearchForm.btnok.click(),_self} ";
					RCMenuHeight += RCMenuHeightStep;
				%>
				<button type="button" class=btn accessKey=O id=btnok
					onclick="btn_ok();">
					<U>O</U>-<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%></BUTTON>
				<%
					RCMenu += "{"
							+ SystemEnv.getHtmlLabelName(201, user.getLanguage())
							+ ",javascript:document.SearchForm.btncancel.click(),_self} ";
					RCMenuHeight += RCMenuHeightStep;
				%>
				<button type="button" class=btnReset accessKey=T type=reset
					id=btncancel onclick="btn_cancel();">
					<U>T</U>-<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%></BUTTON>
				
			</DIV>
			<wea:layout type="4col">
				<wea:group context="<%=SystemEnv.getHtmlLabelName(20331, user
									.getLanguage())%>">
			<%if (list.size() > 0) {%>
   			<%
   				for (int j = 0; j < list.size(); j++) {
					Map<String, String> map = list.get(j);
					String type = Util.null2String(map.get("type"));
					String titlestr = "";
					if (type.equals("1")) {
						titlestr = "请求标题";
					}
					if (type.equals("2")) {
						titlestr = "流程类型";
					}
					if (type.equals("3")) {
						titlestr = "编号";
					}
					if (type.equals("4")) {
						titlestr = "创建人";
					}
					if (type.equals("5")) {
						titlestr = "创建人部门";
					}
					if (type.equals("6")) {
						titlestr = "创建人分部";
					}
					if (type.equals("7")) {
						titlestr = "创建日期";
					}
					if (type.equals("8")) {
						titlestr = "相关项目";
					}
					if (type.equals("9")) {
						titlestr = "相关客户";
					}
					if (type.equals("10")) {
						titlestr = "归档状态";
					}
					if (type.equals("11")) {
						titlestr = "接收期间";
					}
   			%>
   					<%if (type.equals("1")) {%>
   						<wea:item><%=titlestr%></wea:item>
						<wea:item><input name=requestname class=Inputstyle value='<%=requestname%>' <%if("1".equals(map.get("readonly"))){%>readonly="readonly"<%}%>></wea:item>
					<%} else if (type.equals("2")) {%>
						<%if (!user.getLogintype().equals("2")) {
							String workflowids[] = Util.TokenizerString2(workflowid, ",");
							String workflowestr = "";
							for (int i = 0; i < workflowids.length; i++) {
								if (!workflowids[i].equals("") && !workflowids[i].equals("0")) {
									workflowestr += (!workflowestr.equals("") ? "," : "")
											+ Util.null2String(WorkflowComInfo.getWorkflowname(workflowids[i]));
									if (workflowids.length > 3 && i == 2) {
										workflowestr += "...";
										break;
									}

								}
							}
						%>
							<wea:item><%=titlestr%></wea:item>
							<wea:item><span><brow:browser viewType="0" name="workflowid"
								browserValue='<%=workflowid%>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/MutilWorkflow_Browser.jsp"
								hasInput="true" isSingle="false" hasBrowser="true"
								isMustInput='<%="1".equals(map.get("readonly")) ? "0" : "1"%>' linkUrl="#"
								completeUrl="/data.jsp?type=workflowBrowser"
								browserSpanValue='<%=workflowestr%>'>
							</brow:browser></span></wea:item>
						<%}%>
					<%} else if (type.equals("3")) {%>
						<wea:item><%=titlestr%></wea:item>
						<wea:item><input name=requestmark class=Inputstyle value='<%=requestmark%>' <%if("1".equals(map.get("readonly"))){%>readonly="readonly"<%}%> /></wea:item>
					<%} else if (type.equals("4")) {
						String creates[] = Util.TokenizerString2(creater, ",");
						String createnames = "";
						for (int i = 0; i < creates.length; i++) {
							if (!creates[i].equals("") && !creates[i].equals("0")) {
								createnames += (!createnames.equals("") ? "," : "")
										+ ResourceComInfo.getResourcename(creates[i]);
							}
						}
					%>
						<%
							String isMustInput = "1";
							if (user.getLogintype().equals("2")) {
								isMustInput = "0";
							} else if ("1".equals(map.get("readonly"))) {
								isMustInput = "0";
							}
						%>
						<wea:item><%=titlestr%></wea:item>
						<wea:item><span><brow:browser viewType="0" name="creater"
								browserValue='<%=creater%>'
								completeUrl="/data.jsp?type=1"
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
								hasInput="true" isSingle="false" hasBrowser="true"
								isMustInput='<%=isMustInput%>' linkUrl="#"
								browserSpanValue='<%=createnames%>'>
						</brow:browser></span></wea:item>
					<%} else if (type.equals("5")) {
						String departments[] = Util.TokenizerString2(department, ",");
						String departmentnames = "";
						for (int i = 0; i < departments.length; i++) {
							if (!departments[i].equals("") && !departments[i].equals("0")) {
								departmentnames += (!departmentnames.equals("") ? "," : "")
										+ DepartmentComInfo.getDepartmentname(departments[i]);
							}
						}
					%>
						<wea:item><%=titlestr%></wea:item>
						<wea:item><span><brow:browser viewType="0" name="department"
								browserValue='<%=department%>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
								hasInput="true" isSingle="false" hasBrowser="true"
								completeUrl="/data.jsp?type=4"
								isMustInput='<%="1".equals(map.get("readonly")) ? "0" : "1"%>' linkUrl="#"
								browserSpanValue='<%=departmentnames%>'>
						</brow:browser></span></wea:item>
					<%} else if (type.equals("6")) {
						String subids[] = Util.TokenizerString2(subid, ",");
						String subnames = "";
						for (int i = 0; i < subids.length; i++) {
							if (!subids[i].equals("") && !subids[i].equals("0")) {
								subnames += (!subnames.equals("") ? "," : "")
										+ SubCompanyComInfo.getSubCompanyname(subids[i]);
							}
						}
					%>
						<wea:item><%=titlestr%></wea:item>
						<wea:item><span><brow:browser viewType="0" name="subid"
								browserValue='<%=subid%>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="
								hasInput="true" isSingle="false" hasBrowser="true"
								completeUrl="/data.jsp?type=164"
								isMustInput='<%="1".equals(map.get("readonly")) ? "0" : "1"%>' linkUrl="#"
								browserSpanValue='<%=subnames%>'>
						</brow:browser></span></wea:item>
					<%} else if (type.equals("7")) {%>
						<wea:item><%=titlestr%></wea:item>
						<wea:item><button type="button" class=Calendar id=selectbirthday <%if(!"1".equals(map.get("readonly"))){%>onclick="getTheDate(createdatestart,createdatestartspan)"<%}%>></BUTTON>
						<SPAN id=createdatestartspan><%=createdatestart%></SPAN>
			  - &nbsp;<button type="button" class=Calendar id=selectbirthday1 <%if(!"1".equals(map.get("readonly"))){%>onclick="getTheDate(createdateend,createdateendspan)"<%}%>></BUTTON>
						<SPAN id=createdateendspan><%=createdateend%></SPAN>
						<input type="hidden" id=createdatestart name="createdatestart" value="<%=createdatestart%>">
						<input type="hidden" id=createdateend name="createdateend" value="<%=createdateend%>"></wea:item>
					<%} else if (type.equals("8")) {
						String projname = "";
						if (!prjids.equals("")) {
							String st[] = prjids.split(",");
							for (int i = 0; i < st.length; i++) {
								String str01 = "" + st[i];
								if (!str01.equals("")) {
									projname += "  " + ProjectInfoComInfo.getProjectInfoname(str01);
								}
							}
						}
					%>
						<wea:item><%=titlestr%></wea:item>
						<wea:item><span><brow:browser viewType="0" name="prjids"
								browserValue='<%=prjids%>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp?resourceids="
								hasInput="true" isSingle="false" hasBrowser="true"
								isMustInput='<%="1".equals(map.get("readonly")) ? "0" : "1"%>' linkUrl="#"
								completeUrl="/data.jsp?type=8"
								browserSpanValue='<%=projname%>'>
						</brow:browser></span></wea:item>
					<%} else if (type.equals("9")) {
						String crmname = "";
						if (!crmids.equals("")) {
							String st[] = crmids.split(",");
							for (int i = 0; i < st.length; i++) {
								String str01 = "" + st[i];
								if (!str01.equals("")) {
									crmname += "  " + crmComInfo.getCustomerInfoname(str01);
								}
							}
						}
					%>
						<wea:item><%=titlestr%></wea:item>
						<wea:item><span><brow:browser viewType="0" name="crmids"
								browserValue='<%=crmids%>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="
								hasInput="true" isSingle="false" hasBrowser="true"
								completeUrl="/data.jsp?type=7"
								isMustInput='<%="1".equals(map.get("readonly")) ? "0" : "1"%>' linkUrl="#"
								browserSpanValue='<%=crmname%>'>
						</brow:browser></span></wea:item>
					<%} else if (type.equals("10")) {%>
						<wea:item><%=titlestr%></wea:item>
						<wea:item><select <%if("1".equals(map.get("readonly"))){%>disabled="true"<%}%> id=status name=status>
							<OPTION value="">全部</OPTION>
							<OPTION value="1" <%if (status.equals("1")) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(23773, user.getLanguage())%></OPTION>
							<OPTION value="2" <%if (status.equals("2")) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(23774, user.getLanguage())%></OPTION>
						</select></wea:item>
					<%} else if (type.equals("11")) {%>
						<wea:item><%=titlestr%></wea:item>
						<wea:item><select <%if("1".equals(map.get("readonly"))){%>disabled="true"<%}%> class=inputstyle size=1 id=date2during name=date2during>
							<option value="">&nbsp;</option>
							<%
								for (int i = 0; i < date2duringTokens.length; i++) {
									int tempdate2during = Util.getIntValue(date2duringTokens[i], 0);
									if (tempdate2during > 36 || tempdate2during < 1) {
										continue;
									}
							%>
							<!-- 最近个月 -->
							<option value="<%=tempdate2during%>" <%if (date2during == tempdate2during) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(24515,user.getLanguage())%><%=tempdate2during%><%=SystemEnv.getHtmlLabelName(26301,user.getLanguage())%></option>
							<%}%>
							<!-- 全部 -->
							<option value="38" <%if (date2during == 38) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
						</select></wea:item>
					<%}%>
				<%}%>
			<%} else {%>
				<wea:item><%=SystemEnv.getHtmlLabelName(1334, user
											.getLanguage())%>
					</wea:item>
					<wea:item>
						<input name=requestname class=Inputstyle value="<%=requestname%>">
					</wea:item>
					<wea:item>
						<%
							if (!user.getLogintype().equals("2")) {
						%><%=SystemEnv.getHtmlLabelName(882, user
												.getLanguage())%>
						<%
							}
						%>
					</wea:item>
					<wea:item>
						<%
							if (!user.getLogintype().equals("2")) {
						%>
						<span> <brow:browser viewType="0" name="creater"
								browserValue='<%=creater%>'
								completeUrl="/data.jsp?type=1"
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
								hasInput="true" isSingle="false" hasBrowser="true"
								isMustInput='1' linkUrl="#" width="80%"
								browserSpanValue='<%=Util.toScreen(ResourceComInfo
													.getResourcename(creater),
													user.getLanguage())%>'></brow:browser>
						</span>
						<%
							}
						%>
					</wea:item>

					<wea:item><%=SystemEnv.getHtmlLabelName(722, user
											.getLanguage())%></wea:item>
					<wea:item>
						<button type="button" class=Calendar id=selectbirthday
							onclick="getTheDate(createdatestart,createdatestartspan)"></BUTTON>
						<SPAN id=createdatestartspan><%=createdatestart%></SPAN>
			  - &nbsp;<button type="button" class=Calendar id=selectbirthday1
							onclick="getTheDate(createdateend,createdateendspan)"></BUTTON>
						<SPAN id=createdateendspan><%=createdateend%></SPAN>
						<input type="hidden" id=createdatestart name="createdatestart"
							value="<%=createdatestart%>">
						<input type="hidden" id=createdateend name="createdateend"
							value="<%=createdateend%>">
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(19502, user
											.getLanguage())%>
					</wea:item>
					<wea:item>
						<input name=requestmark class=Inputstyle value="<%=requestmark%>">
					</wea:item>

					<wea:item><%=SystemEnv.getHtmlLabelName(19225, user
											.getLanguage())%>
					</wea:item>
					<wea:item>
						<span> <%
 	String departments[] = Util.TokenizerString2(
 							department, ",");
 					String departmentnames = "";
 					for (int i = 0; i < departments.length; i++) {
 						if (!departments[i].equals("")
 								&& !departments[i].equals("0")) {
 							departmentnames += (!departmentnames
 									.equals("") ? "," : "")
 									+ DepartmentComInfo
 											.getDepartmentname(departments[i]);
 						}
 					}
 %> <brow:browser viewType="0" name="department"
								browserValue='<%=department%>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp"
								hasInput="true" isSingle="false" hasBrowser="true"
								completeUrl="/data.jsp?type=4"
								isMustInput='1' linkUrl="#" width="80%"
								browserSpanValue='<%=departmentnames%>'>
							</brow:browser> </span>
					</wea:item>
<%--
					<wea:item><%=SystemEnv.getHtmlLabelName(101, user
											.getLanguage())%>
					</wea:item>
					<wea:item>
						<span> <brow:browser viewType="0" name="prjids"
								browserValue='<%=prjids%>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp"
								hasInput="true" isSingle="false" hasBrowser="true"
								isMustInput='1' linkUrl="#" width="80%"
								completeUrl="/data.jsp?type=8"
								browserSpanValue='<%=ProjectInfoComInfo
												.getProjectInfoname(prjids)%>'></brow:browser>
						</span>
					</wea:item>
 --%>
					<wea:item><%=SystemEnv.getHtmlLabelName(15433, user
											.getLanguage())%>
					</wea:item>
					<wea:item>
						<span> <brow:browser viewType="0" name="workflowid"
								browserValue='<%=workflowid%>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp"
								hasInput="true" isSingle="false" hasBrowser="true"
								isMustInput='1' linkUrl="#" width="80%"
								completeUrl="/data.jsp?type=workflowBrowser"
								browserSpanValue='<%=WorkflowComInfo
												.getWorkflowname(workflowid)%>'></brow:browser>
						</span>
					</wea:item>
					<%--
					<wea:item><%=SystemEnv.getHtmlLabelName(136, user
											.getLanguage())%>
					</wea:item>
					<wea:item>
						<span> <brow:browser viewType="0" name="crmids"
								browserValue='<%=crmids%>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
								hasInput="true" isSingle="false" hasBrowser="true"
								completeUrl="/data.jsp?type=7"
								isMustInput='1' linkUrl="#" width="80%"
								browserSpanValue='<%=crmComInfo
												.getCustomerInfoname(crmids)%>'>
							</brow:browser> </span>
					</wea:item>
 --%>
					<wea:item><%=SystemEnv.getHtmlLabelName(19061, user
											.getLanguage())%>
					</wea:item>
					<wea:item>
						<select id=status name=status>
							<OPTION value=""></OPTION>
							<OPTION value="1"
								<%if (status.equals("1"))
							out.println("selected");%>><%=SystemEnv.getHtmlLabelName(23773, user
											.getLanguage())%></OPTION>
							<OPTION value="2"
								<%if (status.equals("2"))
							out.println("selected");%>><%=SystemEnv.getHtmlLabelName(23774, user
											.getLanguage())%></OPTION>
						</select>
					</wea:item>
					<%
						if (date2duringTokens.length > 0) {
					%>
					<wea:item><%=SystemEnv.getHtmlLabelName(103, user
												.getLanguage())%><%=SystemEnv.getHtmlLabelName(446, user
												.getLanguage())%>
					</wea:item>
					<wea:item>
						<select class=inputstyle size=1 id=date2during name=date2during>
							<option value="">
								&nbsp;
							</option>
							<%
								for (int i = 0; i < date2duringTokens.length; i++) {
														int tempdate2during = Util.getIntValue(
																date2duringTokens[i], 0);
														if (tempdate2during > 36
																|| tempdate2during < 1) {
															continue;
														}
							%>
							<!-- 最近个月 -->
							<option value="<%=tempdate2during%>"
								<%if (date2during == tempdate2during) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(24515,
													user.getLanguage())%><%=tempdate2during%><%=SystemEnv.getHtmlLabelName(26301,
													user.getLanguage())%></option>
							<%
								}
							%>
							<!-- 全部 -->
							<option value="38" <%if (date2during == 38) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(332, user
												.getLanguage())%></option>
						</select>
					</wea:item>
					<%
						}
					%>
				<%
					}
				%>
					
				</wea:group>
				
				
				<wea:group context="" attributes="{'groupDisplay':'none'}">
					<wea:item attributes="{'colspan':'full'}">&nbsp;</wea:item>
				</wea:group>
			</wea:layout>
			<div id="dialog">
				<div id='colShow'></div>
			</div>

			<div style="display: none;">
				<button accessKey=T id=myfun1 type=button onclick="resetCondtion();">
					<U>T</U>-<%=SystemEnv.getHtmlLabelName(199, user.getLanguage())%></BUTTON>
			</div>
		</FORM>
		<script type="text/javascript">

		var dialog = null;
		var config = null;
		try {
			dialog = parent.getDialog(window);
		} catch (e) {
		}
		function showMultiRequestDialog(selectids) {
			config = rightsplugingForBrowser.createConfig();
			config.srchead = [ "请求", "创建者", "创建时间" ];
			config.container =$("#colShow");
		    config.searchLabel="";
		    config.hiddenfield="requestid";
		    config.saveLazy = true;//取消实时保存
		    config.saveurl= "/workflow/request/MultiRequestBrowserAjax.jsp?src=save";
		    config.srcurl = "/workflow/request/MultiRequestBrowserAjax.jsp?src=src";
		    config.desturl = "/workflow/request/MultiRequestBrowserAjax.jsp?src=dest";
		    config.delteurl= "/workflow/request/MultiRequestBrowserAjax.jsp?src=save";
		    config.pagesize = 10;
		    config.formId = "weaver";
		    config.selectids = selectids;
			try{
				config.dialog = dialog;
			}catch(e){
			   console.log(e);
			}
		   	jQuery("#colShow").html("");
		    rightsplugingForBrowser.createRightsPluing(config);
		    
		}
		function onClose(){
			try{
				if(dialog){
					dialog.close();
				}else{
					window.parent.close();
				}
			}catch(e){
				window.parent.close();
			}
		}
		function onReset(){
			SearchForm.reset();
		}
		function doSearch()
		{
		    document.getElementById("issearch").value="issearch";
			setResourceStr();
		    document.all("resourceids").value = resourceids.substring(1) ;
		    document.SearchForm.submit();
		}
		jQuery(document).ready(function(){
			showMultiRequestDialog("<%=resourceids%>");
		});
		
		function btn_ok(){
	        	 dialog.OKEvent();
	    }
		function btn_search(){
        	rightsplugingForBrowser.system_btnsearch_onclick(config);
    	}
		function btn_cancel(){
        		dialog.close();
   		}
		
	</script>
		
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	</BODY>
</HTML>
<script type="text/javascript">
	resourceids = "<%=resourceids%>";
	resourcenames = "<%=resourcenames%>";
	function btnclear_onclick() {
		var e=e||event;
	    var target=e.srcElement||e.target;
	
	    if( target.nodeName =="TD"||target.nodeName =="A"  ){
			var returnjson = {id:"",name:""};
			if(dialog){
				try{
					dialog.callback(returnjson);
				}catch(e){}
				dialog.close(returnjson);
   			}else{ 
   	        	window.parent.returnValue  = returnjson;
   	 	    	window.parent.close();
   	    	}
		}
	}

	function btnok_onclick(e){
	    var e=e||event;
	    var target=e.srcElement||e.target;
	
	    if( target.nodeName =="TD"||target.nodeName =="A"  ){
			var returnjson = {id:resourceids,name:resourcenames};
			if(dialog){
				try{
					dialog.callback(returnjson);
				}catch(e){}
				dialog.close(returnjson);
   			}else{ 
   	        	window.parent.returnValue  = returnjson;
   	 	    	window.parent.close();
   	    	}
		}
	}

	function btnsub_onclick() {
		setResourceStr();
		$("#resourceids").val(resourceids);
		document.SearchForm.submit();
	}

	function setResourceStr(){	
		resourceids ="";
		resourcenames = "";
		for(var i=0;i<resourceArray.length;i++){
			resourceids += ","+resourceArray[i].split("~")[0] ;
			resourcenames += ","+resourceArray[i].split("~")[1] ;
		}
		$("input[name=resourceids]").val(resourceids.substring(1));
	}

	function onShowDepartment(){
		var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+$G("department").value)    
	    if (results) {
			if (results.id!="") {
			  $G("departmentspan").innerHTML =results.name.substr(1);
			  $G("department").value=results.id.substr(1);
			}else{
			  $G("departmentspan").innerHTML ="";
			  $G("department").value="";
			}
	     }		
	}

	function onShowBranch(inputename,tdname){
		var ids = jQuery("#"+inputename).val();            
		var datas=null;
		var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置; 
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+ids+"&selectedDepartmentIds="+ids);
	    
	    if (datas){
		    if (datas.id!= "" ){
		    	var ids=datas.id.slice(1).split(",");
		    	var names=datas.name.slice(1).split(",");
		    	var i=0;
		    	var strs="";
	            for(i=0;i<ids.length;i++){
	                strs=strs+""+names[i]+"&nbsp;";
	            }
				jQuery("#"+tdname).html(strs);
				jQuery("#"+inputename).val(datas.id.slice(1));
			}
			else{
				jQuery("#"+tdname).html("");
				jQuery("#"+inputename).val("");
			}
		}
	}
	
	function onShowWorkFlow2(inputname, spanname) {
		var retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/MutilWorkflow_Browser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
		if (retValue != null) {
			if (wuiUtil.getJsonValueByIndex(retValue, 0) != "" ) {
				$G(spanname).innerHTML = wuiUtil.getJsonValueByIndex(retValue, 1).substr(1,wuiUtil.getJsonValueByIndex(retValue, 1).length);
				$G(inputname).value = wuiUtil.getJsonValueByIndex(retValue, 0).substr(1,wuiUtil.getJsonValueByIndex(retValue, 0).length);
			} else { 
				$G(inputname).value = "";
				$G(spanname).innerHTML = "";
			}
		}
	}
	function onShowManagerID2(inputname,spanname){
		var opts={
				_dwidth:'550px',
				_dheight:'550px',
				_url:'about:blank',
				_scroll:"no",
				_dialogArguments:"",
				
				value:""
			};
		var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;url=/hrm/resource/MutiResourceBrowser.jsp
		opts.top=iTop;
		opts.left=iLeft;
		var resourceids=$("#creater").val();
		data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+resourceids,"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
		if (data){
			if (data.id!=""){
				  spanname.innerHTML = data.name.substr(1);
				//end
				inputname.value=data.id.substr(1);
			}else{
				spanname.innerHTML = "";
				inputname.value="";
			}
		}
	}
	function onShowManagerID(inputname,spanname){
		var opts={
				_dwidth:'550px',
				_dheight:'550px',
				_url:'about:blank',
				_scroll:"no",
				_dialogArguments:"",
				
				value:""
			};
		var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
		opts.top=iTop;
		opts.left=iLeft;
		
		data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp","","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
		if (data){
			if (data.id!=""){
				//update by liaodong for qc57566 in 20130906 start
				  //spanname.innerHTML = "<A href='/hrm/resource/HrmResource.jsp?id="+data.id+"'>"+data.name+"</A>";
				  spanname.innerHTML = data.name;
				//end
				inputname.value=data.id;
			}else{
				spanname.innerHTML = "";
				inputname.value="";
			}
		}
	}
</script>
<script type="text/javascript" src="/js/browser/WorkFlowBrowser_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
