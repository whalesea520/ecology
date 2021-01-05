
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- modified by wcd 2014-09-04 [原E7组织机构图表改造] -->
<%@ page import="weaver.hrm.common.*,weaver.hrm.chart.domain.*" %>
<script language="javascript" type="text/javascript" src="/appres/hrm/js/jquery_wev8.js"></script>
<script type="text/javascript">
	var _jQuery = jQuery.noConflict(true);
</script>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="OrgChartManager" class="weaver.hrm.chart.manager.OrgChartManager" scope="page" />
<jsp:useBean id="HrmChartSetManager" class="weaver.hrm.chart.manager.HrmChartSetManager" scope="page" />
<jsp:useBean id="HrmCompanyVirtualManager" class="weaver.hrm.chart.manager.HrmCompanyVirtualManager" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" />
<%
    if(!HrmUserVarify.checkUserRight("HrmDepartLayoutEdit:Edit", user)) {
        response.sendRedirect("/notice/noright.jsp");
        return;
	}	
    String serverstr=request.getScheme()+"://"+request.getHeader("Host");
	String cmd = Util.null2String(request.getParameter("cmd"));
	String sorgid = Util.null2String(request.getParameter("sorgid"));
	int showtype = Util.getIntValue(request.getParameter("showtype"),0);
	int shownum = Util.getIntValue(request.getParameter("shownum"),1);
	String showmode = Util.null2String(request.getParameter("showmode"),"down");
	
	Map map = new HashMap();
	map.put("is_sys",1);
	HrmChartSet bean = HrmChartSetManager.get(map);
	if(bean != null){
		showtype = bean.getShowType();
		shownum = bean.getShowNum();
		showmode = bean.getShowMode();
	}
	showmode = showmode.equals("down") ? "mfchart" : showmode;
	shownum = shownum <= 0 ? 1 : shownum;
	if(0==showtype) shownum = 10000;
	
	String imagefilename = "/images/hdHRMCard_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(16459,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	boolean isPOrg = false;
	String showName = "";
	if(CompanyComInfo.next()){
		showName = CompanyComInfo.getCompanyname();
		isPOrg = Tools.isNull(sorgid) ? true : CompanyComInfo.getCompanyid().equals(sorgid);
	}
%>

<html>
	<head>
		<title><%=titlename%></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css"/>
		<link type="text/css" rel="stylesheet" href="/appres/hrm/css/orgchart_wev8.css"/>
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" type="text/javascript" src="/appres/hrm/js/orgchart_wev8.js"></script>
		<script language="javascript" type="text/javascript" src="/appres/hrm/js/jchart_wev8.js"></script>
		<script language="javascript" type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script type="text/javascript">
			var on = new MFCommon();
			var dialog = null;
			var shownum = "";
			var showtype = "";
			var showmode = "";
			
			function closeDialog(){
				if(dialog)
					dialog.close();
				window.location.href="/hrm/company/HrmDepartLayoutEdit.jsp?shownum="+shownum+"&showtype="+showtype+"&showmode="+showmode+"&sorgid=<%=sorgid%>";
			}
			
			function doReset(){
				location.reload();
			}
			
			function showSet(){
				var bean = new MFCommon();
				bean.initDialog({width:500,height:300});
				dialog = bean.showDialog("/hrm/HrmDialogTab.jsp?_fromURL=orgChartSet&cmd=system", "<%=SystemEnv.getHtmlLabelNames("32470",user.getLanguage())%>");
			}
			
			function doSubmit(){
				$GetEle("frmMain").submit();
			}
			
			function doDel(id){
				CO.NodeObject.deleteNodeWithData(id);
			}
			
			function changeOrg(id){
				window.parent.location.href = "/hrm/HrmTab.jsp?_fromURL=OrgChartHRM&sorgid="+id;
			}
			
			function openWin(type, id){
				
			}
			
		</script>
	</head>
	<body>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(68,user.getLanguage())+",javascript:showSet();,_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(2022,user.getLanguage())+",javascript:doReset();,_self} " ;
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<%
						if(CompanyVirtualComInfo.getCompanyNum()>0){
							CompanyComInfo.setTofirstRow();
					%>
						<select name="sOrg" notBeauty="true" onchange="changeOrg(this.value);">
							<%
								if(CompanyComInfo.next()){
							%>
							<option value="<%=CompanyComInfo.getCompanyid()%>"><%=CompanyComInfo.getCompanyname()%></option>
							<%
								}
								String _vcId = "";
								while(CompanyVirtualComInfo.next()){
									_vcId = CompanyVirtualComInfo.getCompanyid();
							%>
							<option value="<%=_vcId%>" <%=sorgid.equals(_vcId)?"selected":""%>><%=CompanyVirtualComInfo.getVirtualType()%></option>
							<%
								}
							%>
						<select>
					<%
						}
					%>
					<input type="button" class="e8_btn_top" onclick="showSet();" value="<%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%>"></input>
					<input type="button" class="e8_btn_top" onclick="doReset();" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>"></input>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<div id="contentDiv" style="position:relative;height:100%;bottom:4px;width:100%;overflow:auto;">
			<table id="scrollarea" name="scrollarea" width="100%" height="100%" style="zIndex:-1" >
				<tr>
					<td align="center" valign="center">
						<div style="width:170px;border:1px solid #d0d0d0;"><img src="/images/loading2_wev8.gif" align="absmiddle"><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%></div>
					</td>
				</tr>
			</table>
		</div>
		<div id="box_org_tree" class="box_org_tree"></div>
		<script type="text/javascript">
			var cmd = "<%=cmd%>";
			var sorgid = "<%=sorgid%>";
			var shownum = "<%=shownum%>";
			var showName = "<%=showName%>";
			var showtype = "<%=showtype%>";
			var showmode = "<%=showmode%>";
			var isShow = ";;B";
			
			var status = "";
			var docStatus = "";
			var customerType = "";
			var customerStatus = "";
			var workType = "";
			var projectStatus = "";
			var data = {};
			
			function initData(){
				$("#contentDiv").show();
				var ajax = ajaxinit();
				ajax.open("POST", on.ajaxUrl(), true);
				ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
				ajax.send(encodeURI("cmd=initChart&arg0="+sorgid+"&arg1="+shownum+"&arg2="+showName+"&arg3=<%=String.valueOf(isPOrg)%>&arg4="+status+"&arg5="+docStatus+"&arg6="+customerType+"&arg7="+customerStatus+"&arg8="+workType+"&arg9="+projectStatus+"&arg10="+cmd+"&arg11=;;B"));
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
			
			function showChart(){
				window.chart = new MFChart();
				var adapter = {
					"id": "id",
					"pid": "pid",
					"type": "type",
					"logo": "logo",
					"name": "name",
					"title": "title",
					"showNum":"false",
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
				window.chart.isWrapDraggableSubCtrl = false;
				window.chart.isWrapDraggable = false;
				doDel();
				_jQuery(".main_table_company").css("cssText","margin-top:14px!important;");
				$("#contentDiv").hide();
			}
		</script>
	</body>
</html>