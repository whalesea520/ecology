<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- modified by wcd 2014-09-04 [原E7组织机构图表改造] -->
<%@ page import="weaver.hrm.common.*,weaver.hrm.chart.domain.*" %>
<%@page import="weaver.hrm.appdetach.AppDetachComInfo"%>
<script language="javascript" type="text/javascript" src="/appres/hrm/js/jquery_wev8.js"></script>
<script type="text/javascript">
	var _jQuery = jQuery.noConflict(true);
</script>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="OrgChartManager" class="weaver.hrm.chart.manager.OrgChartManager" scope="page" />
<jsp:useBean id="CRMSearchComInfo" class="weaver.crm.search.SearchComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="HrmChartSetManager" class="weaver.hrm.chart.manager.HrmChartSetManager" scope="page" />
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" />
<jsp:useBean id="HrmCompanyVirtualManager" class="weaver.hrm.chart.manager.HrmCompanyVirtualManager" scope="page" />
<%
	String imagefilename = "/images/hdHRMCard_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(562,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	AppDetachComInfo AppDetachComInfo = new AppDetachComInfo();
	boolean isOutCustomer = AppDetachComInfo.isOutCustomer(""+user.getUID());//是否为外部用户
	boolean isCustomManager = AppDetachComInfo.isCustomManager(""+user.getUID());//是否为外部用户
	
	String sg = Util.null2String(request.getParameter("s_g"));
	String sorgid = Util.null2String(request.getParameter("sorgid"));
	int showtype = Util.getIntValue(request.getParameter("showtype"),0);
	int shownum = Util.getIntValue(request.getParameter("shownum"),1);
	String showmode = Util.null2String(request.getParameter("showmode"),"down");
	Map map = new HashMap();
	HrmChartSet bean = null;
	if(sg.length()==0){
		map.put("is_sys",1);
		bean = HrmChartSetManager.get(map);
	}else if(sg.equals("true")){
		if(bean == null){
			bean = new HrmChartSet();
			bean.setIsSys(0);
			bean.setAuthor(user.getUID());
		}
		bean.setShowType(showtype);
		bean.setShowNum(shownum);
		bean.setShowMode(showmode);
	}
	if(bean != null){
		showtype = bean.getShowType();
		shownum = bean.getShowNum();
		showmode = bean.getShowMode();
	}
	showmode = showmode.equals("down") ? "mfchart" : showmode;
	shownum = shownum <= 0 ? 1 : shownum;
	if(0==showtype) shownum = 10000;
	boolean isPOrg = false;
	String showName = "";
	if(CompanyComInfo.next()){
		showName = CompanyComInfo.getCompanyname();
		isPOrg = Tools.isNull(sorgid) ? true : CompanyComInfo.getCompanyid().equals(sorgid);
	}
	if(isOutCustomer){
		sorgid="-10000";
		showName = CompanyVirtualComInfo.getVirtualType(sorgid);
		isPOrg = false;
	}
	String cmd = Util.null2String(request.getParameter("cmd"));
	String status = Util.null2String(request.getParameter("status"));
	String docStatus = Util.null2String(request.getParameter("docStatus"));
	String customerType = Util.null2String(request.getParameter("customerType"));
	String customerStatus = Util.null2String(request.getParameter("customerStatus"));
	String workType = Util.null2String(request.getParameter("workType"));
	String projectStatus = Util.null2String(request.getParameter("projectStatus"));
%>

<html>
	<head>
		<title><%=SystemEnv.getHtmlLabelName(562,user.getLanguage())%></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css"/>
		<link type="text/css" rel="stylesheet" href="/appres/hrm/css/orgchart_wev8.css"/>
		<link type="text/css" rel="stylesheet" href="/appres/hrm/css/mfcommon_wev8.css"/>
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" type="text/javascript" src="/appres/hrm/js/orgchart_wev8.js"></script>
		<script language="javascript" type="text/javascript" src="/appres/hrm/js/jchart_wev8.js"></script>
		<script language="javascript" type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
		<script type="text/javascript">
			var on = new MFCommon();
			var dialog = null;
			var shownum = "";
			var showtype = "";
			var showmode = "";
			
			function closeDialog(){
				if(dialog)
					dialog.close();
				window.location.href="/org/OrgChartHRM.jsp?s_g=true&shownum="+shownum+"&showtype="+showtype+"&showmode="+showmode+"&cmd=<%=cmd%>&sorgid=<%=sorgid%>";
			}
			
			function onBtnSearchClick(){
				jQuery("#searchfrm").submit();
			}
			
			function openUrl(type,id){
				var url;
				if(type == '0'){
					url = "/hrm/HrmTab.jsp?_fromURL=HrmDepartmentDsp&id="+id;
				} else {
					url = "/hrm/HrmTab.jsp?_fromURL=HrmDepartment&id="+id;
				}
				window.open(url);
			}
			
			function resetSelect(){
				var obj = $GetEle("status");
				if(obj)changeSelectValue(obj.id,"8");
				obj = $GetEle("docStatus");
				if(obj)changeSelectValue(obj.id,"0");
				obj = $GetEle("customerType");
				if(obj)changeSelectValue(obj.id,"<%=customerType%>");
				obj = $GetEle("customerStatus");
				if(obj)changeSelectValue(obj.id,"<%=customerStatus%>");
				obj = $GetEle("workType");
				if(obj)changeSelectValue(obj.id,"<%=workType%>");
				obj = $GetEle("projectStatus");
				if(obj)changeSelectValue(obj.id,"<%=projectStatus%>");	
			}
			
			function doDel(id){
				CO.NodeObject.deleteNodeWithData(id);
			}
			
			function showOrg(obj){
				window.parent.location.href = "/hrm/HrmTab.jsp?_fromURL=OrgChartHRM&sorgid=<%=sorgid%>&cmd="+$(obj).attr("id");
			}
			
			function changeOrg(id){
				window.parent.location.href = "/hrm/HrmTab.jsp?_fromURL=OrgChartHRM&sorgid="+id;
			}
			
			function openWin(type, id){
				try{
					if(type == "subcompany"){
						window.open("/hrm/HrmTab.jsp?_fromURL=<%=isPOrg ? "HrmSubCompanyDsp" : "HrmSubCompanyDspVirtual"%>&id="+id);
					} else {
						window.open("/hrm/HrmTab.jsp?_fromURL=<%=isPOrg ? "HrmDepartmentDsp" : "HrmDepartmentDspVirtual"%>&id="+id.substr(1)+"&hasTree=false");
					}
				}catch(e){}
			}
		</script>
	</head>
	<body>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form action="" name="searchfrm" id="searchfrm">
			<input type="hidden" name="cmd" value="<%=cmd%>">
			<input type="hidden" name="showmode" value="<%=showmode%>">
			<input type="hidden" name="sorgid" value="<%=sorgid%>">
			<table id="topTitle" class="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<%
							if(CompanyVirtualComInfo.getCompanyNum()>0){
								CompanyComInfo.setTofirstRow();
						%>
							<select name="sOrg" notBeauty="true" onchange="changeOrg(this.value);">
								<%
									if(CompanyComInfo.next()&&!isOutCustomer){
								%>
								<option value="<%=CompanyComInfo.getCompanyid()%>"><%=CompanyComInfo.getCompanyname()%></option>
								<%
									}
									String _vcId = "";
									while(CompanyVirtualComInfo.next()){
										_vcId = CompanyVirtualComInfo.getCompanyid();
										if(_vcId.equals("-10000") && !isOutCustomer&&!isCustomManager)continue;
								%>
								<option value="<%=_vcId%>" <%=sorgid.equals(_vcId)?"selected":""%>><%=CompanyVirtualComInfo.getVirtualType()%></option>
								<%
									}
								%>
							<select>
						<%
							}
						%>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
						<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
				<wea:layout type="4col">
					<wea:group context="<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>">
						<%
							if(Tools.isNull(cmd)){
						%>
						<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
						<wea:item>
							<%if(status.equals("")){status = "8";}%>
							<select class="inputstyle" id="status" name="status">
								<option value="9" <% if(status.equals("9")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
								<option value="0" <% if(status.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></option>
								<option value="1" <% if(status.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></option>
								<option value="2" <% if(status.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
								<option value="3" <% if(status.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></option>
								<option value="4" <% if(status.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></option>
								<option value="5" <% if(status.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></option>
								<option value="6" <% if(status.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></option>
								<option value="7" <% if(status.equals("7")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
								<option value="8" <% if(status.equals("8")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%></option>
							</select>
						</wea:item>
						<wea:item>&nbsp;</wea:item>
						<wea:item>&nbsp;</wea:item>
						<%}else if(cmd.equals("doc")){%>
						<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
						<wea:item>
							<select class="InputStyle" id="docStatus" name="docStatus">
								<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
								<option value="0" <%=docStatus.equals("0")?"selected":""%>><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%></option>
								<option value="1" <%=docStatus.equals("1")?"selected":""%>><%=SystemEnv.getHtmlLabelName(18431,user.getLanguage())%></option>
								<option value="2" <%=docStatus.equals("2")?"selected":""%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
								<option value="3" <%=docStatus.equals("3")?"selected":""%>><%=SystemEnv.getHtmlLabelName(359,user.getLanguage())%></option>
								<option value="4" <%=docStatus.equals("4")?"selected":""%>><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></option>
								<option value="5" <%=docStatus.equals("5")?"selected":""%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
								<option value="6" <%=docStatus.equals("6")?"selected":""%>><%=SystemEnv.getHtmlLabelName(19564,user.getLanguage())%></option>
								<option value="7" <%=docStatus.equals("7")?"selected":""%>><%=SystemEnv.getHtmlLabelName(15750,user.getLanguage())%></option>
								<option value="8" <%=docStatus.equals("8")?"selected":""%>><%=SystemEnv.getHtmlLabelName(15358,user.getLanguage())%></option>
								<option value="9" <%=docStatus.equals("9")?"selected":""%>><%=SystemEnv.getHtmlLabelName(21556,user.getLanguage())%></option>
							</select>
						</wea:item>
						<wea:item>&nbsp;</wea:item>
						<wea:item>&nbsp;</wea:item>
						<%}else if(cmd.equals("customer")){%>
						<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
						<wea:item>
							<select id="customerType" name="customerType" class="InputStyle">
								<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
								<%
									rs.executeProc("CRM_CustomerType_SelectAll","");
									while(rs.next()){
										String tmpid=rs.getString("id");
										out.println("<option value='"+tmpid+"' "+(customerType.equals(tmpid)?"selected='selected'":"")+">"+rs.getString("fullname")+"</optin>");
									}
								%>
							</select>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
						<wea:item>
							<select id="customerStatus" name="customerStatus" class="InputStyle">
								<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
								<%
									rs.executeSql("select id , fullname from CRM_CustomerStatus");
									while(rs.next()){
										String tmpid = rs.getString("id");
										if(CRMSearchComInfo.getCustomerStatus().equals(tmpid) ||customerStatus.equals(tmpid)){
											out.println("<option value='"+tmpid+"' selected='selected' >"+rs.getString("fullname")+"</optin>");
										}else{
											out.println("<option value='"+tmpid+"'>"+rs.getString("fullname")+"</optin>");
										}
									}
								%>
							</select>
						</wea:item>
						<%}else if(cmd.equals("project")){%>
						<wea:item><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></wea:item>
						<wea:item>
							<select class="InputStyle" name="workType" id="workType">
								<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
								<%while(WorkTypeComInfo.next()){%>
									<option value="<%=WorkTypeComInfo.getWorkTypeid()%>" <%=workType.equals(WorkTypeComInfo.getWorkTypeid())?"selected":""%>><%=WorkTypeComInfo.getWorkTypename()%></option>
								<%}%>
							</select>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(587,user.getLanguage())%></wea:item>
						<wea:item>
							<select id="projectStatus" name="projectStatus" class=InputStyle>
								<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
								<%while(ProjectStatusComInfo.next()){%>
									<option value="<%=ProjectStatusComInfo.getProjectStatusid()%>" <%=projectStatus.equals(ProjectStatusComInfo.getProjectStatusid())?"selected":""%>><%=ProjectStatusComInfo.getProjectStatusdesc()%></option>
								<%}%>
							</select>
						</wea:item>
						<%}%>
					</wea:group>
					<wea:group context="">
						<wea:item type="toolbar">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick()"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();resetSelect()"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
						</wea:item>
					</wea:group>
				</wea:layout>
			</div>
		</form>
		<div id="contentDiv" style="position:absolute!important;top:120px!important;height:auto!important;position:relative;height:100%;bottom:4px;width:100%;overflow:auto;">
			<div class="xTable_message" style="top:25%;left:43%"><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%></div>
		</div>
		<div id="box_org_tree" class="box_org_tree"></div>
		<script type="text/javascript">
			var cmd = "<%=cmd%>";
			var sorgid = "<%=sorgid%>";
			var shownum = "<%=shownum%>";
			var showName = "<%=showName%>";
			var showtype = "<%=showtype%>";
			var showmode = "<%=showmode%>";
			var isShow = ";;P";
			
			var status = "<%=status%>";
			var docStatus = "<%=docStatus%>";
			var customerType = "<%=customerType%>";
			var customerStatus = "<%=customerStatus%>";
			var workType = "<%=workType%>";
			var projectStatus = "<%=projectStatus%>";
			var data = {};
			
			function showChart(){
				if (typeof onBtnSearchClick != "undefined" && onBtnSearchClick instanceof Function) {
					$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
				}
				window.chart = new MFChart();
				var adapter = {
					"id": "id",
					"pid": "pid",
					"type": "type",
					"logo": "logo",
					"name": "name",
					"title": "title",
					"showNum":"true",
					"num":"num",
					"nTitle":"nTitle",
					"oDisplay":"oDisplay",
					"subRCount":"subRCount",
					"subTitle":"subTitle",
					"cOnclick":"cOnclick",
					"sOnclick":"sOnclick",
					"hasChild":"hasChild",
					"needPlus":"needPlus"
				};
				var DemoOption = {
					"adapter": adapter,
					"htmlContent" : chart.htmlContent,
					"onCreateAllTreeCallback" : chart.onCreateAllTreeCallback,
					"addEventToNode" : chart.addEventToNode,
					"createHtmlContent" : chart.createHtmlContent,
					"showtype" : showtype,
					"shownum" : shownum
				};
				window.CO = new CreateOrgchartBS($.extend({
					"orgType":showmode,
					"data":data, 		
					"wrap":$("#box_org_tree")
				}, DemoOption));
				window.CO.init();
				doDel();
				window.chart.isWrapDraggableSubCtrl = false;
				window.chart.isWrapDraggable = false;
				_jQuery(".main_table_company").css("cssText","margin-top:14px!important;");
				$("#contentDiv").hide();
			}
			
			function initData(){
				$("#contentDiv").show();
				var ajax = ajaxinit();
				ajax.open("POST", on.ajaxUrl(), true);
				ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
				ajax.send(encodeURI("cmd=initChart&arg0="+sorgid+"&arg1="+shownum+"&arg2="+showName+"&arg3=<%=String.valueOf(isPOrg)%>&arg4="+status+"&arg5="+docStatus+"&arg6="+customerType+"&arg7="+customerStatus+"&arg8="+workType+"&arg9="+projectStatus+"&arg10="+cmd+"&arg11=;;P"));
				ajax.onreadystatechange = function() {
					if (ajax.readyState == 4 && ajax.status == 200) {
						try{
							var result = ajax.responseText;
							if(result && result != ""){
								data = jQuery.parseJSON(result);
								showChart();
							}
						}catch(e){
							return false;
						}
					}
				}
			}
			
			_jQuery(function(){
				initData();
			});
		</script>
	</body>
</html>