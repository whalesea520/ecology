
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetCT" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<%
int userId = user.getUID();
int subCompanyId = user.getUserSubCompany1();
String sqlwhere = " where 1=1";
RecordSet.executeSql("select carsdetachable from SystemSet");
int detachable=0;
if(RecordSet.next()){
    detachable=RecordSet.getInt(1);
   
}
if(detachable==1){
	if(!"".equals(Util.null2String(request.getParameter("subCompanyId")))){
		subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"));
	}
	//operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"Car:Maintenance",subCompanyId);
	if(userId!=1){
		String sqltmp = "";
		String blonsubcomid="";
		char flag=Util.getSeparator();
		rs2.executeProc("HrmRoleSR_SeByURId", ""+userId+flag+"Car:Maintenance");
		while(rs2.next()){
			blonsubcomid=rs2.getString("subcompanyid");
			sqltmp += (", "+blonsubcomid);
		}
		if(!"".equals(sqltmp)){//角色设置的权限
			sqltmp = sqltmp.substring(1);
			sqlwhere += " and subcompanyid in ("+sqltmp+") ";
		}else{
			sqlwhere += " and subcompanyid="+user.getUserSubCompany1() ;
		}
	}
}else{
	subCompanyId = -1;
}
String carNo = Util.null2String(request.getParameter("carNo"));
String flowTitle = Util.null2String(request.getParameter("flowTitle2"));
String[] carType = request.getParameterValues("carType");
String factoryNo = Util.null2String(request.getParameter("factoryNo"));
String driver = Util.null2String(request.getParameter("driver"));
String startdate = Util.null2String(request.getParameter("startdate"));
String enddate = Util.null2String(request.getParameter("enddate"));
String carTypeTemp = "";

if(!carNo.equals("")){
	sqlwhere += " and carNo like '%"+carNo+"%'";
}else{
	if(!"".equals(flowTitle)){
		sqlwhere += " and carNo like '%"+flowTitle+"%'";
	}
}
if(carType!=null&&carType.length>0){
	for(int i=0;i<carType.length;i++){
		carTypeTemp +=","+carType[i];
	}
	carTypeTemp = carTypeTemp.substring(1);
	sqlwhere += " and carType in ("+carTypeTemp+")";
}
if(!factoryNo.equals("")){
	sqlwhere += " and factoryNo like '%"+factoryNo+"%'";
}
if(!startdate.equals("")){
	sqlwhere += " and buyDate >= '"+startdate+"'";
}
if(!enddate.equals("")){
	sqlwhere += " and buyDate <= '"+enddate+"'";
}
if(!driver.equals("")){
	sqlwhere += " and driver ='"+driver+"'";
}
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int	perpage=10;
%>

<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
//搜索:车辆信息
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(20316,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;//搜索
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",CarSearchIframe.jsp,_self} " ;//返回
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0" >
			<tr>
				<td class="rightSearchSpan">
					<input type="text" class="searchInput" value="<%=flowTitle%>" id="flowTitle" name="flowTitle"/>
					&nbsp;&nbsp;<!-- 高级搜索 -->
					<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995, user.getLanguage())%></span>&nbsp;&nbsp;
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
				</td>
			</tr>
		</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:hide;overflow: auto" >
	<form id="frmmain" NAME="frmmain" STYLE="margin-bottom:0" action="/car/CarSearchResult.jsp" method=post> 
		<iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
		<input type="hidden" name="flowTitle2" value="<%=flowTitle%>">
		<wea:layout type="4col">
			<wea:group context="" attributes="{groupDisplay:none}">
				<wea:item><!-- 车辆类型 -->
					<%=SystemEnv.getHtmlLabelName(920,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
				</wea:item>
				<wea:item>
					<%
						RecordSetCT.executeProc("CarType_Select","");
						while(RecordSetCT.next()){
							String isChecked = "";
							if (carTypeTemp.indexOf(Util.null2String(RecordSetCT.getString("id"))) != -1) isChecked = "checked"; 
					%>			
							<input class=inputstyle name="carType" <%=isChecked%> type="checkbox" value="<%=RecordSetCT.getString("id")%>"><%=Util.toScreen(RecordSetCT.getString("name"),user.getLanguage())%>
					<%  
					    }
					%>	
				</wea:item>
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(20319,user.getLanguage())%><!-- 车牌号 -->
				</wea:item>
				<wea:item>
					<INPUT type="text" class=Inputstyle style="width:240px;" name="carNo" value="<%=carNo%>">
				</wea:item>
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(20318,user.getLanguage())%><!-- 厂牌型号 -->
				</wea:item>
				<wea:item>
					<INPUT type="text" class=Inputstyle style="width:240px;" name="factoryNo" value="<%=factoryNo%>">
				</wea:item>
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(16914,user.getLanguage())%><!-- 购置日期 -->
				</wea:item>
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%>&nbsp;&nbsp;<!-- 从 -->
					<input id="startdate" name="startdate" value="<%=startdate%>" type="hidden" class=wuiDate  ></input> 
				
					<%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%>&nbsp;&nbsp;<!-- 到 -->
					<input id="enddate" name="enddate" value="<%=enddate%>" type="hidden" class=wuiDate />
				</wea:item>
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(17649,user.getLanguage())%><!-- 司机 -->
				</wea:item>
				<wea:item>
					<brow:browser viewType="0" name="driver" browserValue='<%=driver%>' 
  		 				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
						hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="1"
						completeUrl="/data.jsp" linkUrl=""  width="228px" 
						browserDialogWidth="500px"
						browserSpanValue='<%=driver!=""?Util.toScreen(ResourceComInfo.getResourcename(driver+""),user.getLanguage()):""%>'
						></brow:browser>
				</wea:item>
			</wea:group>
			<wea:group context="">
				<wea:item type="toolbar">
					<input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" id="searchBtn"/><!-- 搜索 -->
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="onClear();"/><!-- 重置 -->
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/><!-- 取消 -->
				</wea:item>
			</wea:group>
		</wea:layout>
	</form>
</div>

		        	<%
		            String backfields = "id, factoryNo, carNo, carType, driver, buyDate";
		            String fromSql  = "from CarInfo";
		            String sqlWhere = sqlwhere;
		            String orderby = "id" ;
		            String tableString = "";
		            tableString =" <table instanceid=\"CarTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
		                                     "		<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"desc\" sqlisdistinct=\"true\"/>"+
		                                     "		<head>"+//厂牌型号
		                                     "			<col width=\"17%\"  text=\""+SystemEnv.getHtmlLabelName(20318,user.getLanguage())+"\" column=\"factoryNo\" orderkey=\"factoryNo\" />"+
		                                     			//车牌号
		                                     "			<col width=\"17%\"   text=\""+SystemEnv.getHtmlLabelName(20319,user.getLanguage())+"\" column=\"carNo\"  orderkey=\"carNo\" linkvaluecolumn=\"id\" linkkey=\"id\" href=\"javascript:showDialog('/car/CarInfoViewTab.jsp?id={0}&amp;fg=1&amp;flag=1&amp;dialog=1')\" target=\"_self\"/>"+
		                                     			//类型
		                                   	 "			<col width=\"17%\"   text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"carType\" orderkey=\"carType\" transmethod=\"weaver.car.CarTypeComInfo.getCarTypename\" />"+
		                                   	 			//司机
		                                   	 "			<col width=\"17%\"   text=\""+SystemEnv.getHtmlLabelName(17649,user.getLanguage())+"\" column=\"driver\"  orderkey=\"driver\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" />"+
		                                   	 			//购置日期
		                      				 "			<col width=\"17%\"   text=\""+SystemEnv.getHtmlLabelName(16914,user.getLanguage())+"\" column=\"buyDate\"  orderkey=\"buyDate\" />"+
		                                     "		</head>"+
		                                     "</table>";
		         %>
		         <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />

<script language=vbs>
sub getStartDate()
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	document.all("startdatespan").innerHtml= returndate
	document.all("startdate").value=returndate
end sub

sub getEndDate()
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	document.all("enddatespan").innerHtml= returndate
	document.all("enddate").value=returndate
end sub
</script>
<script language=javascript>
var diag_vote;
function doSearch(){
	//document.frmmain.action="CarInfoMaintenance.jsp";
	document.frmmain.action="CarSearchResult.jsp";
	document.frmmain.submit();
}
function doDel(){
	if(isdel()){
		document.frmmain.submit();
	}
}
function onBtnSearchClick(){
	document.frmmain.flowTitle2.value = jQuery("#flowTitle").val();
	document.frmmain.carNo.value = jQuery("#flowTitle").val();
	jQuery("#frmmain").submit();
}
function onClear(){
	$("form input[name='carType']").each(function(){
		changeCheckboxStatus(this,false);
	});
	$('form input[type=text]').val('');
	$('form textarea').val('');
	$('form select').val('');
	$("form input[id='driver']").val('');
	$("form span[id='driverspan']").text('');
	$("form input[id='startdate']").val('');
	$("form span[id^='startdate']").text('');
	$("form input[id='enddate']").val('');
	$("form span[id^='enddate']").text('');
}
function showDialog(url){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 600;
	diag_vote.Height = 550;
	diag_vote.Modal = true;
	diag_vote.checkDataChange = false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(20316,user.getLanguage())%>";//车辆信息
	diag_vote.maxiumnable = true;
	diag_vote.URL = url;
	diag_vote.show();
}
function closeDlgARfsh(){
	diag_vote.close();
	doSearch();
}
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
</html>
