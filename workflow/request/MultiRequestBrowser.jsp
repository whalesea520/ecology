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
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="crmComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="sysInfo" class="weaver.system.SystemComInfo" scope="page" />
<jsp:useBean id="Browsedatadefinition" class="weaver.workflow.request.Browsedatadefinition" scope="page"/>

<HTML>
	<HEAD>
		<LINK rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
		<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
		<script type="text/javascript" src="/js/dragBox/rightspluingForBrowserNew_wev8.js"></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
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
		   if(!!dialog && dialog.Title == "<%=SystemEnv.getHtmlLabelName(22105,user.getLanguage())%>"){
		   	$("#objName").html(dialog.Title);
		   }else{
		    $("#objName").html("<%=SystemEnv.getHtmlLabelName(33924,user.getLanguage())%>");
		   }
		});
			</script>
		<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
		<style type="text/css">
		.LayoutTable .fieldName {
			padding-left:20px!important;
		}
		</style>
	</HEAD>

	<%
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");//设置日期格式
		String currentdate = df.format(new Date());
	
		String sqlwhere = "";
		String f_weaver_belongto_userid=Util.fromScreen(request.getParameter("f_weaver_belongto_userid"),user.getLanguage());
		String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
		if("".equals(f_weaver_belongto_userid)){
		   f_weaver_belongto_userid = Util.null2String((String)session.getAttribute("f_weaver_belongto_userid"));
		}
		if("".equals(f_weaver_belongto_usertype)){
		   f_weaver_belongto_usertype = Util.null2String((String)session.getAttribute("f_weaver_belongto_usertype"));
		}
		//System.out.println("-69-f_weaver_belongto_userid--"+f_weaver_belongto_userid);
		user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
		String userID = String.valueOf(user.getUID());
		int userid=user.getUID();
		if(!f_weaver_belongto_userid.equals(userID) && !"".equals(f_weaver_belongto_userid)){
		userID = f_weaver_belongto_userid;
		userid = Util.getIntValue(f_weaver_belongto_userid,0);
		}
		String belongtoshow = "";				
		RecordSet.executeSql("select * from HrmUserSetting where resourceId = "+userID);
					if(RecordSet.next()){
						belongtoshow = RecordSet.getString("belongtoshow");
					}
String userIDAll = String.valueOf(user.getUID());	
String Belongtoids =user.getBelongtoids();
int Belongtoid=0;
String[] arr2 = null;
ArrayList<String> userlist = new ArrayList();
userlist.add(userid + "");
if(!"".equals(Belongtoids)){
userIDAll = userID+","+Belongtoids;
arr2 = Belongtoids.split(",");
for(int i=0;i<arr2.length;i++){
Belongtoid = Util.getIntValue(arr2[i]);
userlist.add(Belongtoid + "");
}
}
		String usertype = "0";
		if("2".equals(user.getLogintype())) usertype = "1";
		String fieldid = Util.null2String(request.getParameter("fieldid"));
		String title = Util.null2String(request.getParameter("title"));
		String currworkflowid = Util.null2String(request.getParameter("currworkflowid"));
		if ("".equals(currworkflowid)) {
			currworkflowid = Util.null2String(request.getParameter("workflowid"));
		}
		if (!"".equals(fieldid)) {
			String newwfs[] = fieldid.split("_");
			fieldid = newwfs[0];
		}
	
		String issearch= Util.null2String(request.getParameter("issearch"));
		String requestname = Util.null2String(request.getParameter("requestname"));
		String creater = Util.null2String(request.getParameter("creater"));
		String createdatestart = Util.null2String(request.getParameter("createdatestart"));
		String createdateend = Util.null2String(request.getParameter("createdateend"));
		String isrequest = Util.null2String(request.getParameter("isrequest"));
		String requestmark = Util.null2String(request.getParameter("requestmark"));
		String prjids = Util.null2String(request.getParameter("prjids"));
		String crmids = Util.null2String(request.getParameter("crmids"));
		String workflowid = Util.null2String(request.getParameter("workflowid"));
		String department = Util.null2String(request.getParameter("department"));
		String status = Util.null2String(request.getParameter("status"));
		String subid = Util.null2String(request.getParameter("subid"));

		int olddate2during = 0;
		BaseBean baseBean = new BaseBean();
		String date2durings = "";
		try{
			date2durings = Util.null2String(baseBean.getPropValue("wfdateduring", "wfdateduring"));
		} catch(Exception e) {}
		String[] date2duringTokens = Util.TokenizerString2(date2durings, ",");
		if (date2duringTokens.length > 0){
			olddate2during = Util.getIntValue(date2duringTokens[0], 0);
		}
		if (olddate2during < 0 || olddate2during > 36) {
			olddate2during = 0;
		}
		int date2during = Util.getIntValue(request.getParameter("date2during"), olddate2during);

        //搜索时获取systemIds,第一次弹出时取resourceids     
		String resourceids = Util.null2String(request.getParameter("systemIds"));
		if ("".equals(resourceids)) {
			resourceids = Util.null2String(request.getParameter("resourceids"));
		}
		String resourcenames = Util.null2String(request.getParameter("resourcenames"));
		String check_per = Util.null2String(request.getParameter("resourceids"));

		List<Map<String, String>> list = null;
		if (!"".equals(fieldid) && !"".equals(currworkflowid)) {
			if (Browsedatadefinition.read(currworkflowid, fieldid)) {
			   	list = Browsedatadefinition.getList();
			} else {
				list = new ArrayList<Map<String, String>>();
			}
		} else {
			list = new ArrayList<Map<String, String>>();
		}

		if ("".equals(isrequest)) {
			isrequest = "1";
		}
		
		/*begin：处理还款流程请求浏览按钮过滤逻辑代码*/
		int bdf_wfid = Util.getIntValue(request.getParameter("bdf_wfid"));
		int bdf_fieldid = Util.getIntValue(request.getParameter("bdf_fieldid"));
		int __requestid = Util.getIntValue(request.getParameter("__requestid"));
		int _fna_wfid = Util.getIntValue(request.getParameter("fna_wfid"));
		int _fna_fieldid = Util.getIntValue(request.getParameter("fna_fieldid"));
		if(bdf_wfid > 0 && _fna_wfid <= 0){
			_fna_wfid = bdf_wfid;
		}
		if(Util.getIntValue(currworkflowid) > 0 && _fna_wfid <= 0){
			_fna_wfid = Util.getIntValue(currworkflowid);
		}
		if(bdf_fieldid > 0 && _fna_fieldid <= 0){
			_fna_fieldid = bdf_fieldid;
		}
		if(Util.getIntValue(fieldid) > 0 && _fna_fieldid <= 0){
			_fna_fieldid = Util.getIntValue(fieldid);
		}
		/*end：处理还款流程请求浏览按钮过滤逻辑代码*/
		
		if (list.size() > 0) {
			if ("".equals(issearch)) {
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
				String xgxmtype = Browsedatadefinition.getXgxmtype();
				String xgxmid = Browsedatadefinition.getXgxmid();
				String xgkhtype = Browsedatadefinition.getXgkhtype();
				String xgkhid = Browsedatadefinition.getXgkhid();
				String gdtype = Browsedatadefinition.getGdtype();
				String jsqjtype = Browsedatadefinition.getJsqjtype();

				if("".equals(requestname)){
					requestname = requestname01;
			    }

				if("".equals(workflowid)){
			   	 	workflowid = workflowtype;
			    }

				if("".equals(requestmark)){
					requestmark = Processnumber;
				}

				if ("".equals(creater)) {
					if("1".equals(createtype)) {
						creater = ""+user.getUID();
					} else if("2".equals(createtype)) {
						creater = createtypeid;
					} else if("3".equals(createtype)) {
						creater = Util.null2String(request.getParameter("cre"));
					}
				}

				if("".equals(department)) {
					if("1".equals(createdepttype)) {
						department = ""+user.getUserDepartment();
					} else if("2".equals(createdepttype)) {
						department = department01;
					} else if("3".equals(createdepttype)) {
						department = Browsedatadefinition.getDepartment(Util.null2String(request.getParameter("dep")));
					}
				}

				if("".equals(subid)) {
					if("1".equals(createsubtype)) {
						subid = ""+user.getUserSubCompany1();
					} else if("2".equals(createsubtype)) {
						subid = ""+createsubid;
					} else if ("3".equals(createsubtype)) {
						subid = Browsedatadefinition.getSubcompany(Util.null2String(request.getParameter("sub")));
					}
				}

				if("".equals(createdatestart) && "".equals(createdateend)){
					if("2".equals(createdatetype)) {//今天
						createdatestart = ""+currentdate;
						createdateend = ""+currentdate;
					} else if("3".equals(createdatetype)) {//本周
						createdatestart = df.format(Browsedatadefinition.getMonday());
						createdateend = df.format(Browsedatadefinition.getSunday());
					} else if("4".equals(createdatetype)){//本月
						createdatestart = df.format(Browsedatadefinition.getFirstDayOfMonth());
						createdateend = df.format(Browsedatadefinition.getLastDayOfMonth());
					} else if("5".equals(createdatetype)){//本季
						createdatestart = df.format(Browsedatadefinition.getFirstDayOfQuarter());
						createdateend = df.format(Browsedatadefinition.getLastDayOfQuarter());
					} else if("6".equals(createdatetype)){//本年
						createdatestart = Browsedatadefinition.getYearDateStart();
						createdateend = Browsedatadefinition.getYearDateEnd();
					} else if("7".equals(createdatetype)){//指定日期
						createdatestart = createdatestart01;
						createdateend = createdateend01; 
					} else if("8".equals(createdatetype)) {
						createdatestart = Util.null2String(request.getParameter("date"));
						createdateend = Util.null2String(request.getParameter("date"));
					}
				} else {
					if("".equals(createdatestart)){
						createdatestart = createdatestart01;
					}
					if("".equals(createdateend)){
						createdateend = createdateend01;
					}
				}

				if("".equals(prjids)) {
					if ("2".equals(xgxmtype)) {
						prjids = xgxmid;
					} else if ("3".equals(xgxmtype)) {
						prjids = Util.null2String(request.getParameter("xgxm"));
					}
				}

				if("".equals(crmids)) {
					if ("2".equals(xgkhtype)) {
						crmids = xgkhid;
					} else if ("3".equals(xgkhtype)) {
						crmids = Util.null2String(request.getParameter("xgkh"));
					}
				}

			    if("".equals(status)){
			   	 	status = gdtype;
			    }

			    date2during = Util.getIntValue(jsqjtype,0);
			}
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
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_top"  onclick="javascript:doSearch(),_self"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
	</table>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

		<div class="zDialog_div_content">
		<FORM id=weaver name=SearchForm style="margin-bottom: 0" action="MultiRequestBrowser.jsp" method=post onsubmit="btnOnSearch();return false;">
			<input type="hidden" name="pagenum" id="pagenum" value=''>
			<input type="hidden" name="resourceids" value="">
			<input type="hidden" name="isrequest" value='<%=isrequest%>'>
			<input type="hidden" name="issearch" id="issearch"  >
			<input type="hidden" name="currworkflowid" value="<%=currworkflowid%>">
			<input type="hidden" name="fieldid" value='<%=fieldid%>'>
			
			<input type="hidden" name="fna_wfid" id="fna_wfid"  value="<%=_fna_wfid %>" />
			<input type="hidden" name="fna_fieldid" id="fna_fieldid"  value="<%=_fna_fieldid %>" />
			<input type="hidden" name="__requestid" id="__requestid"  value="<%=__requestid %>" />
			
			<div style="width:0px;height:0px;overflow:hidden;">
				<button type=submit></BUTTON>
			</div>
			<%if (list.size() > 0) {
			for (int j = 0; j < list.size(); j++) {
				Map<String, String> map = list.get(j);
				String type = map.get("type");
				boolean isHide = Browsedatadefinition.isHide(map.get("hide"));
				String inputName = "";
				String inputValue = "";
				if (isHide) {
					if ("1".equals(type)) {%>
			<input type="hidden" name="requestname" value="<%=requestname%>" />
			<%} else if ("2".equals(type)) {%>
			<input type="hidden" name="workflowid" value="<%=workflowid%>" />
			<%} else if ("3".equals(type)) {%>
			<input type="hidden" name="requestmark" value="<%=requestmark%>" />
			<%} else if ("4".equals(type)) {%>
			<input type="hidden" name="creater" value="<%=creater%>" />
			<%} else if ("5".equals(type)) {%>
			<input type="hidden" name="department" value="<%=department%>" />
			<%} else if ("6".equals(type)) {%>
			<input type="hidden" name="subid" value="<%=subid%>" />
			<%} else if ("7".equals(type)) {%>
			<input type="hidden" name="createdatestart" value="<%=createdatestart%>" />
			<input type="hidden" name="createdateend" value="<%=createdateend%>" />
			<%} else if ("8".equals(type)) {%>
			<input type="hidden" name="prjids" value="<%=prjids%>" />
			<%} else if ("9".equals(type)) {%>
			<input type="hidden" name="crmids" value="<%=crmids%>" />
			<%} else if ("10".equals(type)) {%>
			<input type="hidden" name="status" value="<%=status%>" />
			<%} else if ("11".equals(type)) {%>
			<input type="hidden" name="date2during" value="<%=date2during%>" />
			<%}}}}%>

			<DIV align=right style="display: none">
				<%
					RCMenu += "{"
							+ SystemEnv.getHtmlLabelName(197, user.getLanguage())
							+ ",javascript:document.SearchForm.btnsearch.click(),_self} ";
					RCMenuHeight += RCMenuHeightStep;
				%>
				<button type="button" class=btnSearch accessKey=S type=submit
					id=btnsearch onclick="javascript:doSearch(),_self">
					<U>S</U>-<%=SystemEnv.getHtmlLabelName(197, user.getLanguage())%></BUTTON>
				<%
					RCMenu += "{" + SystemEnv.getHtmlLabelName(826, user.getLanguage())
							+ ",javascript:btn_ok(),_self} ";
					RCMenuHeight += RCMenuHeightStep;
				%>
				<button type="button" class=btn accessKey=O id=btnok
					onclick="btn_ok();">
					<U>O</U>-<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%></BUTTON>
				<%
					RCMenu += "{"
							+ SystemEnv.getHtmlLabelName(201, user.getLanguage())
							+ ",javascript:btn_cancel(),_self} ";
					RCMenuHeight += RCMenuHeightStep;
				%>
				<button type="button" class=btnReset accessKey=T type=reset
					id=btncancel onclick="btn_cancel();">
					<U>T</U>-<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%></BUTTON>
				<%
					RCMenu += "{"
							+ SystemEnv.getHtmlLabelName(311, user.getLanguage())
							+ ",javascript:btn_clear(),_self} ";
					RCMenuHeight += RCMenuHeightStep;
				%>
				<button type="button" class=btn accessKey=2 id=btnclear
					onclick="btn_clear();">
					<U>2</U>-<%=SystemEnv.getHtmlLabelName(311, user.getLanguage())%></BUTTON>
			</DIV>
			<div id="e8QuerySearchArea" style="overflow:auto;height: 155px;">
			<wea:layout type="4col">
				<wea:group attributes="{'groupSHBtnDisplay':'none'}" context="<%=SystemEnv.getHtmlLabelName(15774, user
									.getLanguage())%>">
			<%if (list.size() > 0) {%>
   			<%
 				for (int j = 0; j < list.size(); j++) {
			Map<String, String> map = list.get(j);
			boolean isHide = Browsedatadefinition.isHide(map.get("hide"));
			if (isHide) {
				continue;
			}
			String type = map.get("type");
			boolean isReadonly = Browsedatadefinition.isHide(map.get("readonly"));
 				%>
			<%if ("1".equals(type)) {%>
				<wea:item><%=SystemEnv.getHtmlLabelName(26876, user.getLanguage())%></wea:item>
				<wea:item><input name="requestname" class="Inputstyle" value='<%=requestname%>' <%if(isReadonly){%>readonly="readonly"<%}%>></wea:item>
			<%} else if ("2".equals(type)) {%>
				<%if (!"2".equals(user.getLogintype())) {
					String workflowids[] = Util.TokenizerString2(workflowid, ",");
					String workflowestr = "";
					for (int i = 0; i < workflowids.length; i++) {
						if (!"".equals(workflowids[i]) && !"0".equals(workflowids[i])) {
							workflowestr += (!"".equals(workflowestr) ? "," : "")
									+ Util.null2String(WorkflowComInfo.getWorkflowname(workflowids[i]));
						}
					}
				%>
					<wea:item><%=SystemEnv.getHtmlLabelName(33806, user.getLanguage())%></wea:item>
					<wea:item><span><brow:browser viewType="0" name="workflowid"
						browserValue='<%=workflowid%>'
						browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/MutiWorkflowBrowser.jsp?selectedids="
						browserDialogHeight="650px;"
						hasInput='<%=isReadonly ? "false" : "true"%>' isSingle="false" hasBrowser="true"
						isMustInput='<%=isReadonly ? "0" : "1"%>' linkUrl="#"
						completeUrl="/data.jsp?type=workflowBrowser"
						browserSpanValue='<%=workflowestr%>'>
					</brow:browser></span></wea:item>
				<%}%>
			<%} else if ("3".equals(type)) {%>
				<wea:item><%=SystemEnv.getHtmlLabelName(714, user.getLanguage())%></wea:item>
				<wea:item><input name="requestmark" class="Inputstyle" value='<%=requestmark%>' <%if(isReadonly){%>readonly="readonly"<%}%> /></wea:item>
			<%} else if ("4".equals(type)) {
				String creates[] = Util.TokenizerString2(creater, ",");
				String createnames = "";
				for (int i = 0; i < creates.length; i++) {
					if (!"".equals(creates[i]) && !"0".equals(creates[i])) {
						createnames += (!"".equals(createnames) ? "," : "")
								+ ResourceComInfo.getResourcename(creates[i]);
					}
				}
			%>
				<%
					String hasInput = "true";
					String isMustInput = "1";
					if ("2".equals(user.getLogintype())) {
						isMustInput = "0";
						hasInput = "false";
					} else if (isReadonly) {
						isMustInput = "0";
						hasInput = "false";
					}
				%>
				<wea:item><%=SystemEnv.getHtmlLabelName(882, user.getLanguage())%></wea:item>
				<wea:item><span><brow:browser viewType="0" name="creater"
						browserValue='<%=creater%>'
						completeUrl="/data.jsp?type=1"
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
						hasInput='<%=hasInput%>' isSingle="false" hasBrowser="true"
						isMustInput='<%=isMustInput%>' linkUrl="#"
						browserSpanValue='<%=createnames%>'>
				</brow:browser></span></wea:item>
			<%} else if ("5".equals(type)) {
				String departments[] = Util.TokenizerString2(department, ",");
				String departmentnames = "";
				for (int i = 0; i < departments.length; i++) {
					if (!"".equals(departments[i]) && !"0".equals(departments[i])) {
						departmentnames += (!"".equals(departmentnames) ? "," : "")
								+ DepartmentComInfo.getDepartmentname(departments[i]);
					}
				}
			%>
				<wea:item><%=SystemEnv.getHtmlLabelName(19225, user.getLanguage())%></wea:item>
				<wea:item><span><brow:browser viewType="0" name="department"
						browserValue='<%=department%>'
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
						hasInput='<%=isReadonly ? "false" : "true"%>' isSingle="false" hasBrowser="true"
						completeUrl="/data.jsp?type=4"
						isMustInput='<%=isReadonly ? "0" : "1"%>' linkUrl="#"
						browserSpanValue='<%=departmentnames%>'>
				</brow:browser></span></wea:item>
			<%} else if ("6".equals(type)) {
				String subids[] = Util.TokenizerString2(subid, ",");
				String subnames = "";
				for (int i = 0; i < subids.length; i++) {
					if (!"".equals(subids[i]) && !"0".equals(subids[i])) {
						subnames += (!"".equals(subnames) ? "," : "")
								+ SubCompanyComInfo.getSubCompanyname(subids[i]);
					}
				}
			%>
				<wea:item><%=SystemEnv.getHtmlLabelName(22788, user.getLanguage())%></wea:item>
				<wea:item><span><brow:browser viewType="0" name="subid"
						browserValue='<%=subid%>'
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="
						hasInput='<%=isReadonly ? "false" : "true"%>' isSingle="false" hasBrowser="true"
						completeUrl="/data.jsp?type=164"
						isMustInput='<%=isReadonly ? "0" : "1"%>' linkUrl="#"
						browserSpanValue='<%=subnames%>'>
				</brow:browser></span></wea:item>
			<%} else if ("7".equals(type)) {%>
				<wea:item><%=SystemEnv.getHtmlLabelName(722, user.getLanguage())%></wea:item>
				<wea:item><button type="button" class=Calendar id=selectbirthday <%if(!isReadonly){%>onclick="getTheDate(createdatestart,createdatestartspan)"<%}%>></BUTTON>
				<SPAN id=createdatestartspan><%=createdatestart%></SPAN>
	  - &nbsp;<button type="button" class=Calendar id=selectbirthday1 <%if(!isReadonly){%>onclick="getTheDate(createdateend,createdateendspan)"<%}%>></BUTTON>
				<SPAN id=createdateendspan><%=createdateend%></SPAN>
				<input type="hidden" id="createdatestart" name="createdatestart" value="<%=createdatestart%>">
				<input type="hidden" id="createdateend" name="createdateend" value="<%=createdateend%>"></wea:item>
			<%} else if ("8".equals(type)) {
				String prjidss[] = Util.TokenizerString2(prjids, ",");
				String projnames = "";
				for (int i = 0; i < prjidss.length; i++) {
					if (!"".equals(prjidss[i]) && !"0".equals(prjidss[i])) {
						projnames += (!"".equals(projnames) ? "," : "")
					 			+ ProjectInfoComInfo.getProjectInfoname(prjidss[i]);
					}
				}
			%>
				<wea:item><%=SystemEnv.getHtmlLabelName(782, user.getLanguage())%></wea:item>
				<wea:item><span><brow:browser viewType="0" name="prjids"
						browserValue='<%=prjids%>'
						browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp?resourceids="
						hasInput='<%=isReadonly ? "false" : "true"%>' isSingle="false" hasBrowser="true"
						isMustInput='<%=isReadonly ? "0" : "1"%>' linkUrl="#"
						completeUrl="/data.jsp?type=8"
						browserSpanValue='<%=projnames%>'>
				</brow:browser></span></wea:item>
			<%} else if ("9".equals(type)) {
				String crmidss[] = Util.TokenizerString2(crmids, ",");
				String crmnames = "";
				for (int i = 0; i < crmidss.length; i++) {
					if (!"".equals(crmidss[i]) && !"0".equals(crmidss[i])) {
						crmnames += (!"".equals(crmnames) ? "," : "")
					 			+ crmComInfo.getCustomerInfoname(crmidss[i]);
					}
				}
			%>
				<wea:item><%=SystemEnv.getHtmlLabelName(783, user.getLanguage())%></wea:item>
				<wea:item><span><brow:browser viewType="0" name="crmids"
						browserValue='<%=crmids%>'
						browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="
						hasInput='<%=isReadonly ? "false" : "true"%>' isSingle="false" hasBrowser="true"
						completeUrl="/data.jsp?type=7"
						isMustInput='<%=isReadonly ? "0" : "1"%>' linkUrl="#"
						browserSpanValue='<%=crmnames%>'>
				</brow:browser></span></wea:item>
			<%} else if ("10".equals(type)) {%>
				<wea:item><%=SystemEnv.getHtmlLabelName(19061, user.getLanguage())%></wea:item>
				<wea:item><select <%if(isReadonly){%>disabled="true"<%}%> id=status name=status>
					<OPTION value="">&nbsp;</OPTION>
					<OPTION value="1" <%if (status.equals("1")) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(23773, user.getLanguage())%></OPTION>
					<OPTION value="2" <%if (status.equals("2")) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(23774, user.getLanguage())%></OPTION>
				</select></wea:item>
			<%} else if ("11".equals(type)) {%>
				<wea:item><%=SystemEnv.getHtmlLabelName(31787, user.getLanguage())%></wea:item>
				<wea:item><select <%if(isReadonly){%>disabled="true"<%}%> class=inputstyle size=1 id=date2during name=date2during>
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
				<wea:item><%=SystemEnv.getHtmlLabelName(26876, user
											.getLanguage())%>
					</wea:item>
					<wea:item>
						<input name=requestname class=Inputstyle value="<%=requestname%>">
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(33806, user
											.getLanguage())%>
					</wea:item>
					<wea:item>
						<span> <brow:browser viewType="0" name="workflowid"
								browserValue='<%=workflowid%>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser="true"
								isMustInput='1' linkUrl="#" width="80%"
								completeUrl="/data.jsp?type=workflowBrowser"
								browserSpanValue='<%=WorkflowComInfo
												.getWorkflowname(workflowid)%>'></brow:browser>
						</span>
					</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(19502, user.getLanguage())%>
					</wea:item>
					<wea:item>
						<input name=requestmark class=Inputstyle value="<%=requestmark%>">
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
					<wea:item><%=SystemEnv.getHtmlLabelName(22788, user.getLanguage())%></wea:item>
					<wea:item>
						<%
							String subids[] = Util.TokenizerString2(subid, ",");
							String subnames = "";
							for (int i = 0; i < subids.length; i++) {
								if (!"".equals(subids[i]) && !"0".equals(subids[i])) {
									subnames += (!"".equals(subnames) ? "," : "")
											+ SubCompanyComInfo.getSubCompanyname(subids[i]);
								}
							}
						%>
						<span>
							<brow:browser viewType="0" name="subid"
								browserValue='<%=subid%>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="
								hasInput='true' isSingle="false" hasBrowser="true"
								completeUrl="/data.jsp?type=164"
								isMustInput='1' linkUrl="#"
								browserSpanValue='<%=subnames%>'>
							</brow:browser>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(722, user.getLanguage())%></wea:item>
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
					<wea:item><%=SystemEnv.getHtmlLabelName(782, user.getLanguage())%></wea:item>
					<wea:item>
						<%
							String prjidss[] = Util.TokenizerString2(prjids, ",");
							String projnames = "";
							for (int i = 0; i < prjidss.length; i++) {
								if (!"".equals(prjidss[i]) && !"0".equals(prjidss[i])) {
									projnames += (!"".equals(projnames) ? "," : "")
								 			+ ProjectInfoComInfo.getProjectInfoname(prjidss[i]);
								}
							}
						%>
						<span>
							<brow:browser viewType="0" name="prjids"
								browserValue='<%=prjids%>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp?resourceids="
								hasInput='true' isSingle="false" hasBrowser="true"
								isMustInput='1' linkUrl="#"
								completeUrl="/data.jsp?type=8"
								browserSpanValue='<%=projnames%>'>
							</brow:browser>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(783, user.getLanguage())%>
					</wea:item>
					<wea:item>
						<%
							String crmidss[] = Util.TokenizerString2(crmids, ",");
							String crmnames = "";
							for (int i = 0; i < crmidss.length; i++) {
								if (!"".equals(crmidss[i]) && !"0".equals(crmidss[i])) {
									crmnames += (!"".equals(crmnames) ? "," : "")
								 			+ crmComInfo.getCustomerInfoname(crmidss[i]);
								}
							}
						%>
						<span>
							<brow:browser viewType="0" name="crmids"
									browserValue='<%=crmids%>'
									browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="
									hasInput='true' isSingle="false" hasBrowser="true"
									completeUrl="/data.jsp?type=7"
									isMustInput='1' linkUrl="#"
									browserSpanValue='<%=crmnames%>'>
							</brow:browser> 
						</span>
					</wea:item>
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
					<wea:item><%=SystemEnv.getHtmlLabelName(31787, user
												.getLanguage())%>
					</wea:item>
					<wea:item>
						<select class=inputstyle size=1 id=date2during name=date2during>
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
			</wea:layout>
			</div>

						<div id="dialog">
							<div id='colShow'></div>
						</div>
<input type="hidden" name="f_weaver_belongto_userid" value="<%=request.getParameter("f_weaver_belongto_userid") %>">
			<input type="hidden" name="f_weaver_belongto_usertype" value="<%=request.getParameter("f_weaver_belongto_usertype") %>">
		</FORM>
		</div>
		<script type="text/javascript">
		var parentWin = null;
		var dialog = null;
		var config = null;
		try {
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		} catch (e) {
		}
		function showMultiRequestDialog(selectids) {
			config = rightsplugingForBrowser.createConfig();
			config.srchead = [ "<%=SystemEnv.getHtmlLabelName(33569, user.getLanguage())%>", "<%=SystemEnv.getHtmlLabelName(882, user.getLanguage())%>", "<%=SystemEnv.getHtmlLabelName(1339, user.getLanguage())%>" ];
			config.container = jQuery("#colShow");
		    config.searchLabel="";
		    config.hiddenfield="requestid";
		    config.saveLazy = true;//取消实时保存
		    config.saveurl= "/workflow/request/MultiRequestBrowserAjax.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&src=save&fna_wfid=<%=_fna_wfid%>&fna_fieldid=<%=_fna_fieldid%>&__requestid=<%=__requestid%>";
		    config.srcurl = "/workflow/request/MultiRequestBrowserAjax.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&src=src&fna_wfid=<%=_fna_wfid%>&fna_fieldid=<%=_fna_fieldid%>&__requestid=<%=__requestid%>";
		    config.desturl = "/workflow/request/MultiRequestBrowserAjax.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&src=dest&fna_wfid=<%=_fna_wfid%>&fna_fieldid=<%=_fna_fieldid%>&__requestid=<%=__requestid%>";
		    config.delteurl= "/workflow/request/MultiRequestBrowserAjax.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&src=save&fna_wfid=<%=_fna_wfid%>&fna_fieldid=<%=_fna_fieldid%>&__requestid=<%=__requestid%>";
		    config.pagesize = 10;
		    config.formId = "weaver";
		    config.formatCallbackFn = function(config,destMap,destMapKeys){
		         var ids="",names="";
		         var nameKey = destMap["__nameKey"];
		         for(var i=0;destMapKeys&&i<destMapKeys.length;i++){	              
						var key = destMapKeys[i];
						var dataitem = destMap[key];
						var name = dataitem[nameKey];
						if(name.indexOf("<B>")!=-1){
						   name = name.substring(0,name.indexOf("<B>"));
						}
						if(ids==""){
							ids = key;
						}else{
							ids = ids+","+key;
						}
						if(names==""){
		        			names = name;
		        		}else{
		        			names=names + ","+name;
		        		}
				}
		         return {id:ids,name:names};
		    },
		    config.selectids = selectids;
		    config.searchAreaId = "e8QuerySearchArea";
			try{
				config.dialog = dialog;
			}catch(e){
			   console.log(e);
			}
		   	jQuery("#colShow").html("");
		    rightsplugingForBrowser.createRightsPluing(config);
		
		    jQuery("#btn_Ok").bind("click",function(){
		    	rightsplugingForBrowser.system_btnok_onclick(config);
		    });
		    jQuery("#btn_Clear").bind("click",function(){
				rightsplugingForBrowser.system_btnclear_onclick(config);
		    });
		    jQuery("#btn_Cancel").bind("click",function(){	    	
				rightsplugingForBrowser.system_btncancel_onclick(config);
		    });
		    jQuery("#btn_Search").bind("click",function(){
		    	rightsplugingForBrowser.system_btnsearch_onclick(config);
		    });
		 
		}
		
		function btnOnSearch(){
		    jQuery("#btn_Search").trigger("click");
		}
		function onClose(){
			try{
				if(dialog){
					jQuery("#btn_Cancel").trigger("click");
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
		    //document.getElementById("issearch").value="issearch";
			//setResourceStr();
		    //document.all("resourceids").value = resourceids.substring(1) ;
		    //document.SearchForm.submit();
		    btnOnSearch();
		}
		jQuery(document).ready(function(){
			showMultiRequestDialog("<%=resourceids%>");
		});
		
		function btn_ok(){
	        jQuery("#btn_Ok").trigger("click");
	    }
		function btn_search(){
        	jQuery("#btn_Search").trigger("click");
    	}
		function btn_cancel(){
        	jQuery("#btn_Cancel").trigger("click");
   		}
		function btn_clear(){
        	jQuery("#btn_Clear").trigger("click");
        }
	</script>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom"  style="padding:0px!important;">
		<div style="padding:5px 0px;">
			<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context="" attributes='{\"groupDisplay\":\"none\"}'>
					<wea:item type="toolbar">
					 
						<input type="button" style="display: none;" class=zd_btn_submit
							accessKey=S id=btn_Search
							value="S-<%=SystemEnv.getHtmlLabelName(197, user
										.getLanguage())%>"></input>
					
						<input type="button" class=zd_btn_submit accessKey=O id=btn_Ok
							value="O-<%=SystemEnv.getHtmlLabelName(826, user
										.getLanguage())%>"></input>
						<input type="button" class=zd_btn_submit accessKey=2 id=btn_Clear
							value="2-<%=SystemEnv.getHtmlLabelName(311, user
										.getLanguage())%>"></input>
						<input type="button" class=zd_btn_cancle accessKey=T id=btn_Cancel
							value="T-<%=SystemEnv.getHtmlLabelName(201, user
										.getLanguage())%>"></input>
					</wea:item>
				</wea:group>
			</wea:layout>
			</div>
</div>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
</BODY></HTML>

<script>

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

jQuery(".e8_sep_line:eq(0)").hide();


 function BrowseTable_onmouseover(event){
    var eventObj =event.srcElement ? event.srcElement : event.target;
	if(eventObj.tagName =='TD'){
		jQuery(eventObj).parents("tr:first")[0].className="Selected";
	}else if (eventObj.tagName == 'A'){
		jQuery(eventObj).parents("tr:first")[0].className="Selected";
	}
 }
 
 function BrowseTable_onmouseout(event){
    var eventObj =event.srcElement ? event.srcElement : event.target;
	if(eventObj.tagName =='TD'||eventObj.tagName == 'A'){
		var trObj =jQuery(eventObj).parents("tr:first")[0];
		if(trObj.rowIndex%2 == 0)
			trObj.className ="DataLight";
		else
			trObj.className ="DataDark";
	}
 }
 
 function BrowseTable_onclick(event){
    var e =event.srcElement ? event.srcElement : event.target;
	if(e.tagName == "TD" || e.tagName == "A"){
		//var newEntry = e.parentElement.cells(0).innerText+"~"+e.parentElement.cells(1).innerText ;
		var node = $(e).closest("tr").children("td:first");
		var newEntry = $(node).text();
		newEntry = newEntry + "~" +  $(node).next().text();
		if(!isExistEntry(newEntry,resourceArray)){
			addObjectToSelect(document.all("srcList"),newEntry);
			reloadResourceArray();
		}
	}
 }
 
 function btnok_onclick(){
	 setResourceStr();
	 var returnjson = {id:resourceids,name:resourcenames};
     if(dialog){
	    try{
	        dialog.callback(returnjson);
	    }catch(e){}
		try{
	        dialog.close(returnjson);
		}catch(e){}
	}else{ 
	   	window.parent.returnValue = returnjson;
		window.parent.close();
	 }
 }
 function btnclear_onclick(){
 	var returnjson = {id:"",name:"",fieldtype:"",options:""}; 
	if(dialog){
	    try{
	        dialog.callback(returnjson);
	    }catch(e){}
		try{
	        dialog.close(returnjson);
		}catch(e){}
	}else{ 
	   	window.parent.returnValue = returnjson;
		window.parent.close();
	 }
 }
 function btncancel_onclick(){
	if(dialog) {
		dialog.close();
	} else { 
	    window.parent.close();
   	}
 }
 
 jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
 jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
 jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
 
 jQuery("#btnok").bind("click",btnok_onclick);
 jQuery("#btnclear").bind("click",btnclear_onclick);
 
 function onShowManagerID(inputname,spanname){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	if (results) {
	  if (results.id!=""){
		 //update by liaodong for qc57566 in 20130906 start
		 //spanname.innerHTML = "<A href='/hrm/resource/HrmResource.jsp?id="+results.id+"' target='_blank'>"+results.name+"</A>"
		   spanname.innerHTML = results.name;
		 //end
		inputname.value=results.id
	  }else{
		spanname.innerHTML = ""
		inputname.value=""
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
  function onShowManagerID2(inputename,tdname){
  var ids = jQuery("#"+inputename).val();    
	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+ids);
	if (datas) {
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
  
  function onShowPrjids(){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp");
	if (results) {
	    if (results.id!="") {
		  $G("prjidsspan").innerHTML =results.name;
		  $G("prjids").value=results.id;
		}else{
		  $G("prjidsspan").innerHTML ="";
		  $G("prjids").value="";
	   }
	}
  }
  
</script>

<script language="javascript">
resourceids = "<%=resourceids%>";
resourcenames = "<%=resourcenames%>";

//Load
var resourceArray = new Array();
for(var i =1;i<resourceids.split(",").length;i++){
	
	resourceArray[i-1] = resourceids.split(",")[i]+"~"+resourcenames.split(",")[i];
	//alert(resourceArray[i-1]);
}

loadToList();
function loadToList(){
	var selectObj = document.all("srcList");
	for(var i=0;i<resourceArray.length;i++){
		addObjectToSelect(selectObj,resourceArray[i]);
	}
	
}

function addObjectToSelect(obj,str){
	if(!!!obj || obj.tagName != "SELECT") return;
	var oOption = document.createElement("OPTION");
	obj.options.add(oOption);
	//oOption.value = str.split("~")[0];
	$(oOption).val(str.split("~")[0]);
	//oOption.innerText = str.split("~")[1];
	$(oOption).text(str.split("~")[1]);
	
}

function isExistEntry(entry,arrayObj){
	for(var i=0;i<arrayObj.length;i++){
		if(entry == arrayObj[i].toString()){
			return true;
			
		}
	}
	return false;
}

function upFromList(){
	var destList  = document.all("srcList");
	//var len = destList.options.length;
	var len = $(destList).children("option").size();
	for(var i = 0; i <= (len-1); i++) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i>0 && destList.options[i-1] != null){
				fromtext = destList.options[i-1].text;
				fromvalue = destList.options[i-1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i-1] = new Option(totext,tovalue);
				destList.options[i-1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
      }
   }
   reloadResourceArray();
}
function addToList(){
	var str = document.all("forAddSingleClick").value;
	if(!isExistEntry(str,resourceArray)&&str!=""){
		addObjectToSelect(document.all("srcList"),str);
		document.all("forAddSingleClick").value="";
	}		
	reloadResourceArray();
}
function addAllToList(){
	var table =$("#BrowseTable");
	$("#BrowseTable").find("tr").each(function(){
		var str=$($(this)[0].cells[0]).text()+"~"+$($(this)[0].cells[1]).text();
		if(!isExistEntry(str,resourceArray))
			addObjectToSelect($("select[name=srcList]")[0],str);
	});
	reloadResourceArray();
}

function def(obj){
	if(obj==null||obj=="undefined"||obj=="")return false;
	return true;
}

function deleteFromList(){
	var destList  = document.all("srcList");
	var options = $(destList).children("option");
	options.each(function(){
		if(def($(this).attr("selected"))){
			$(this).remove();
		}
	});
	$(destList).closest("select").attr("style", "width:100%");
	reloadResourceArray();
}
function deleteAllFromList(){
	var destList  = document.all("srcList");
	var options = $(destList).children("option");
	var len = options.size();
	for(var i = (len-1); i >= 0; i--) {
	if ($(options[i]) != null) {
	         $(options[i]).remove();
		  }
	}
	reloadResourceArray();
}
function downFromList(){
	var destList  = document.all("srcList");
	
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i<(len-1) && destList.options[i+1] != null){
				fromtext = destList.options[i+1].text;
				fromvalue = destList.options[i+1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i+1] = new Option(totext,tovalue);
				destList.options[i+1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
      }
   }
   reloadResourceArray();
}
//reload resource Array from the List
function reloadResourceArray(){
	resourceArray = new Array();
	var destList = document.all("srcList");
	var options = $(destList).children("option");
	for(var i=0;i<options.size();i++){
		
		resourceArray[i] = $(options[i]).val()+"~"+$(options[i]).text();//destList.options[i].value+"~"+destList.options[i].text ;
	}
	//alert(resourceArray.length);
}

function setResourceStr(){
	
	resourceids ="";
	resourcenames = "";
	for(var i=0;i<resourceArray.length;i++){
		resourceids += ","+resourceArray[i].split("~")[0] ;
		resourcenames += ","+resourceArray[i].split("~")[1] ;
	}
	//alert(resourceids+"--"+resourcenames);
	document.all("resourceids").value = resourceids.substring(1)
}

function doSearch()
{
    //document.getElementById("issearch").value="issearch";
	//setResourceStr();
    //document.all("resourceids").value = resourceids.substring(1) ;
    //document.SearchForm.submit();
    btnOnSearch();
}

jQuery(document).ready(function(){
	resizeDialog(document);
});
</SCRIPT>
<script type="text/javascript" src="/js/browser/WorkFlowBrowser_wev8.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src='/js/JSDateTime/WdatePicker_wev8.js?rnd="+Math.random()+"'></script>
