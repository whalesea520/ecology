<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- modified by wcd 2014-07-16 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
	String imagefilename = "/images/hdReport_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(16559,user.getLanguage())+"—"+SystemEnv.getHtmlLabelName(15505,user.getLanguage()) ;
	String needfav ="1";
	String needhelp ="";
	
	boolean hasViewAllRight=false;
	if(HrmUserVarify.checkUserRight("BohaiInsuranceScheduleReport:View", user)){
		hasViewAllRight=true;
	}
	String isself = Util.null2String(request.getParameter("isself"));

	Calendar today = Calendar.getInstance ();
	String currentDate = Util.add0(today.get(Calendar.YEAR), 4) + "-"
					   + Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-"
					   + Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);

	//int resourceId=0;
	//int departmentId=0;
	//int subCompanyId=0;
	String fromDate = Util.null2String(request.getParameter("fromDate"));
	String toDate = Util.null2String(request.getParameter("toDate"));

	if(fromDate.equals("")||toDate.equals("")){
		fromDate=currentDate;
		toDate=currentDate;
	}

	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),0);
	int departmentId = Util.getIntValue(request.getParameter("departmentId"),0);
	String resourceId = strUtil.vString(request.getParameter("resourceId"));

	if(!hasViewAllRight){
		resourceId=String.valueOf(user.getUID());
		departmentId=user.getUserDepartment();
		subCompanyId=user.getUserSubCompany1();
		isself = "1";
	}
%>
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>		
		<script language="javascript">
			var dialog = null;
			var dWidth = 800;
			var dHeight = 500;
			
			function todo(url,title,_dWidth,_dHeight){
				if(dialog==null){
					dialog = new window.top.Dialog();
				}
				dialog.currentWindow = window;
				dialog.Title = title;
				dialog.Width = _dWidth ? _dWidth : dWidth;
				dialog.Height = _dHeight ? _dHeight : dHeight;
				dialog.Drag = true;
				dialog.maxiumnable = true;
				dialog.URL = url;
				dialog.show();
			}
			
			function showSignInDetail(){
				todo("/hrm/HrmDialogTab.jsp?_fromURL=systemRightGroup&method=add","<%=SystemEnv.getHtmlLabelNames("82,492",user.getLanguage())%>");
			}
			
			function submitData() {
				if(check_form(document.frmMain,"fromDate,toDate")){
					if(document.frmMain.fromDate.value > document.frmMain.toDate.value) {
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>") ;
					}else if("<%=hasViewAllRight%>"=="true"&&$GetEle("subCompanyId").value==""&&$GetEle("departmentId").value==""&&$GetEle("resourceId").value==""){
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())+SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>");
					}else{
						document.frmMain.submit();
					}
					
				}
			}
			function ajaxinit(){
				var ajax=false;
				try {
					ajax = new ActiveXObject("Msxml2.XMLHTTP");
				} catch (e) {
					try {
						ajax = new ActiveXObject("Microsoft.XMLHTTP");
					} catch (E) {
						ajax = false;
					}
				}
				if (!ajax && typeof XMLHttpRequest!='undefined') {
					ajax = new XMLHttpRequest();
				}
				return ajax;
			}
			function showdata(){
				var ajax=ajaxinit();
				ajax.open("POST", "HrmScheduleDiffReportResultData.jsp", true);
				ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
				ajax.send("fromDate=<%=fromDate%>&toDate=<%=toDate%>&subCompanyId=<%=subCompanyId%>&departmentId=<%=departmentId%>&resourceId=<%=resourceId%>");
				//获取执行状态
				ajax.onreadystatechange = function() {
					//如果执行状态成功，那么就把返回信息写到指定的层里
					if (ajax.readyState == 4 && ajax.status == 200) {
						try{
							document.all("showdatadiv").innerHTML=ajax.responseText;
						}catch(e){
							return false;
						}
					}
				}
			}
			function exportExcel(){
				if(check_form(document.frmMain,"fromDate,toDate")){
					if(document.frmMain.fromDate.value > document.frmMain.toDate.value) {
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>") ;
					}else if("<%=hasViewAllRight%>"=="true"&&$GetEle("subCompanyId").value==""&&$GetEle("departmentId").value==""&&$GetEle("resourceId").value==""){
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())+SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>");
					}else{
						document.getElementById("excels").src = "HrmScheduleDiffReportExcel.jsp?cmd=HrmScheduleDiffReport&tnum=20078&fromDate="+document.frmMain.fromDate.value+"&toDate="+document.frmMain.toDate.value+"&resourceId="+$GetEle("resourceId").value+"&departmentId="+$GetEle("departmentId").value+"&subCompanyId="+$GetEle("subCompanyId").value;
					}
				}
			}
		</script>
	</head>
	<body onload="<%=isself.equals("1")?"showdata()":""%>">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			if(hasViewAllRight){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:reset(),_self}" ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			RCMenu += "{"+SystemEnv.getHtmlLabelName(28343,user.getLanguage())+",javascript:exportExcel(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type=button class="e8_btn_top" onclick="submitData();" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
					<input type=button class="e8_btn_top" onclick="exportExcel();" value="<%=SystemEnv.getHtmlLabelName(28343,user.getLanguage())%>"></input>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<form id=frmMain name=frmMain method=post action="HrmScheduleDiffReport.jsp">
			<input type="hidden" name="isself" value="1">
			<wea:layout type="4col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(15505,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></wea:item>
					<wea:item>
						<span class="wuiDateSpan" selectId="createdateselect" selectValue="" _needAllOption="false">
							<input class=wuiDateSel type="hidden" name="fromDate" id="fromDate" value="<%=fromDate%>">
							<input class=wuiDateSel type="hidden" name="toDate" id="toDate" value="<%=toDate%>">
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
					<wea:item>
						<%if(hasViewAllRight){%>
						<span>
							<brow:browser viewType="0" name="subCompanyId" browserValue='<%=String.valueOf(subCompanyId)%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?show_virtual_org=-1"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=164&show_virtual_org=-1" width="60%" browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(String.valueOf(subCompanyId))%>'>
							</brow:browser>
						</span>
						<%}else{%>
							<span id=subCompanyNameSpan><%=SubCompanyComInfo.getSubCompanyname(String.valueOf(subCompanyId))%></span> 
							<input class=inputStyle id=subCompanyId type=hidden name=subCompanyId value="<%=subCompanyId%>">
						<%} %>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
					<wea:item>
						<%if(hasViewAllRight){%>
						<span>
							<brow:browser viewType="0" name="departmentId" browserValue='<%=String.valueOf(departmentId)%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?show_virtual_org=-1"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=4&show_virtual_org=-1" width="60%" browserSpanValue='<%=DepartmentComInfo.getDepartmentname(String.valueOf(departmentId))%>'>
							</brow:browser>
						</span>
						<%}else{%>
							<SPAN id=departmentNameSpan><%=DepartmentComInfo.getDepartmentname(String.valueOf(departmentId))%></SPAN> 
							<INPUT class=inputstyle type=hidden name=departmentId value="<%=departmentId%>" >
						<%} %>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></wea:item>
					<wea:item>
						<%if(hasViewAllRight){%>
						<span>
							<brow:browser viewType="0" name="resourceId" browserValue='<%=String.valueOf(resourceId)%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/resource/ResourceBrowser.jsp?excludeid="
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=1" width="60%" browserSpanValue='<%=resourceId.length() == 0 ? "" : ResourceComInfo.getMulResourcename1(String.valueOf(resourceId))%>'>
							</brow:browser>
						</span>
						<%}else{%>
							<SPAN id=resourceNameSpan><%=resourceId.length() == 0 ? "" : ResourceComInfo.getMulResourcename(String.valueOf(resourceId))%></SPAN> 
							<INPUT class=inputstyle type=hidden name=resourceId value="<%=resourceId%>" >
						<%} %>
					</wea:item>
				</wea:group>
			</wea:layout>
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelNames("15101,356",user.getLanguage())%>' >
					<wea:item>
						<div id="showdatadiv" style="<%=isself.equals("1")?"":"display:none"%>;width:97%">
							<div id='message_table_Div' class="xTable_message">
								<%=SystemEnv.getHtmlLabelName(20204,user.getLanguage())%>
							</div>
						</div>
					</wea:item>
				</wea:group>
			</wea:layout>
		</form>
		<iframe name="excels" id="excels" src="" style="display:none" ></iframe>
	</body>
<script type="text/javascript">
//提示窗口
     jQuery(document).ready(function(){
     	 jQuery("#message_table_Div").hide();
       var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;   
	     var pLeft= document.body.offsetWidth/2-50;   
	     jQuery("#message_table_Div").css("position", "absolute");
	     jQuery("#message_table_Div").css("top", pTop);
	     jQuery("#message_table_Div").css("left", pLeft); 
	     <%if(isself.equals("1")){%>
	     	jQuery("#message_table_Div").show();
	     <%}%>
     })
     
function reset(){
  jQuery("#subCompanyId").val("");
  jQuery("#subCompanyIdspan").html("");
  jQuery("#departmentId").val("");
  jQuery("#departmentIdspan").html("");
  jQuery("#resourceId").attr("value","");
  jQuery("#resourceIdspan").html("");
  jQuery("#frmMain").find("select").selectbox("reset");
}
</script>
</html>

