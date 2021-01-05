
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<!DOCTYPE html><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
</head>
<%
int subCompanyId=0;
int userId = user.getUID();
String sqlwhere = " where 1=1";
int operatelevel=0;
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("carsdetachable")),0);
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
		if(!"".equals(sqltmp)){
			operatelevel=2;
		}else{
			operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"Car:Maintenance",user.getUserSubCompany1());
		}

	}else{
		operatelevel=2;
	}
}else{
	subCompanyId = -1;
    if(userId==1||HrmUserVarify.checkUserRight("Car:Maintenance", user))
    	operatelevel=2;
}
String carNo = Util.null2String(request.getParameter("carNo"));
String flowTitle = Util.null2String(request.getParameter("flowTitle2"));
String carType = Util.null2String(request.getParameter("carType"));
String factoryNo = Util.null2String(request.getParameter("factoryNo"));
String startdate = Util.null2String(request.getParameter("startdate"));
String enddate = Util.null2String(request.getParameter("enddate"));

if(!carNo.equals("")){
	sqlwhere += " and carNo like '%"+carNo+"%'";
} else {
	if(!"".equals(flowTitle)){
		sqlwhere += " and carNo like '%"+flowTitle+"%'";
	}
}
if(!carType.equals("")){
	sqlwhere += " and carType="+carType+"";
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
if(subCompanyId>0){
	if(user.getUID()==1){
		if(subCompanyId>0){
			sqlwhere += " and subCompanyId="+subCompanyId;
		}else{
			sqlwhere += " and subCompanyId>=0";
		}
	}else{
		//sqlwhere += " and subCompanyId="+subCompanyId+" and subCompanyId>0";
		if(subCompanyId>0){
			sqlwhere += " and subCompanyId="+subCompanyId;
		}else{
			sqlwhere += " and subCompanyId>0";
		}
	}
}
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int	perpage=10;
%>

<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
//维护:车辆信息
String titlename = SystemEnv.getHtmlLabelName(60,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(20316,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(subCompanyId!=0){
	if(operatelevel>0){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(20317,user.getLanguage())+",javascript: doAdd(),_self} " ;//新建车辆
		RCMenuHeight += RCMenuHeightStep ;
	}
	if(operatelevel>-1){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;//搜索
		RCMenuHeight += RCMenuHeightStep ;
	}
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<%if(operatelevel>0){%><!-- 新建 -->
				<span title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>" style="font-size: 12px;cursor: pointer;">
					<input class="e8_btn_top middle" onclick="javascript:doAdd()" type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"/>
				</span>
			<%}%>
			<input type="text" class="searchInput" value="<%=flowTitle%>" id="flowTitle" name="flowTitle"/>
			&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995, user.getLanguage())%></span>&nbsp;&nbsp;<!-- 高级搜索 -->
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
		</wea:item>
	</wea:group>
</wea:layout>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:hide;overflow: auto" >
<FORM id="frmmain" NAME="frmmain" STYLE="margin-bottom:0" action="/car/CarInfoMaintenanceIframe.jsp" method=post>
<iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
	<input type="hidden" name="subCompanyId" value="<%=subCompanyId%>">
	<input type="hidden" name="flowTitle2" value="<%=flowTitle%>">
	<wea:layout type="4col">
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(20318,user.getLanguage())%><!-- 厂牌型号 -->
			</wea:item>
			<wea:item>
				<input type="text" class=InputStyle  name=factoryNo value="<%=factoryNo%>">
			</wea:item>
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(20319,user.getLanguage())%><!-- 车牌号 -->
			</wea:item>
			<wea:item>
				<input type="text" class=InputStyle name=carNo value="<%=carNo%>">
			</wea:item>
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%><!-- 类型 -->
			</wea:item>
			<wea:item>
				<select name="carType">
					<option value="">
          			<%
          			RecordSet.executeProc("CarType_Select","");
          			while(RecordSet.next()){
          			%>
          			<option value="<%=RecordSet.getString("id")%>" <%if(carType.equals(RecordSet.getString("id"))){%>selected<%}%>><%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%>
          			<%}%>
				</select>
			</wea:item>
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(16914,user.getLanguage())%><!-- 购置日期 -->
			</wea:item>
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%>&nbsp;&nbsp;<!-- 从 -->
				<input name="startdate" type="hidden" class=wuiDate value="<%=startdate%>" ></input>
				<%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%>&nbsp;&nbsp;<!-- 到 -->
				<input name="enddate" type="hidden" class=wuiDate value="<%=enddate%>" />
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
	</FORM>
	<input type="hidden" name="pageId" id="pageId" value="mode_customsearch:car" _showCol="false"/>
</div>
		        	<%
		        	perpage = Util.getIntValue(PageIdConst.getPageSize("mode_customsearch:car" ,user.getUID(), "formmode:pagenumber"),perpage);
		            String backfields = "id, factoryNo, carNo, carType, driver, buyDate ";
		            String fromSql  = " from CarInfo ";
		            String sqlWhere = sqlwhere;
		            //out.println("sqlWhere:"+sqlWhere);
		            String orderby = "id" ;
		            String tableString = "";
		            tableString =" <table instanceid=\"CarTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
		                                     "		<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"desc\" sqlisdistinct=\"true\"/>"+
		                                     "		<head>"+//厂牌型号
		                                     "			<col width=\"17%\"  text=\""+SystemEnv.getHtmlLabelName(20318,user.getLanguage())+"\" column=\"factoryNo\" orderkey=\"factoryNo\" />"+
		                                     			//车牌号
		                                     "			<col width=\"17%\"   text=\""+SystemEnv.getHtmlLabelName(20319,user.getLanguage())+"\" column=\"carNo\"  orderkey=\"carNo\" linkvaluecolumn=\"id\" linkkey=\"id\" href=\"javascript:showDialog2('/car/CarInfoViewTab.jsp?id={0}&amp;fg=1&amp;flag=1&amp;dialog=1')\" target=\"_self\"/>"+
		                                     			//类型
		                                   	 "			<col width=\"17%\"   text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"carType\" orderkey=\"carType\" transmethod=\"weaver.car.CarTypeComInfo.getCarTypename\" />"+
		                                   	 			//司机
		                                   	 "			<col width=\"17%\"   text=\""+SystemEnv.getHtmlLabelName(17649,user.getLanguage())+"\" column=\"driver\"  orderkey=\"driver\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" />"+
		                                   	 			//购置日期
		                      				 "			<col width=\"17%\"   text=\""+SystemEnv.getHtmlLabelName(16914,user.getLanguage())+"\" column=\"buyDate\"  orderkey=\"buyDate\" />"+
		                                     "		</head>"+
											 "		<operates width=\"15%\">";
					if(operatelevel>0){					//编辑
						tableString +=		 "    		<operate href=\"javascript:doEdit()\"  text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>";
					}
					if(operatelevel>1){                 //删除
						tableString +=		 "    		<operate href=\"javascript:doDel()\"  text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\"  index=\"1\"/>";
					}
						tableString +=		 "		</operates>"+
		                                     "</table>";
		         %>
		         <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
<script language=javascript>
var diag_vote;
function doSearch(){
	document.frmmain.submit();
}

function doAdd(){
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
	//新增车辆信息
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(1421,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(20316,user.getLanguage())%>";
	diag_vote.URL = "/car/CarInfoAddTab.jsp?subCompanyId=<%=subCompanyId%>&dialog=1";
	diag_vote.show();
}

function doEdit(id){
	url = "/car/CarInfoEditTab.jsp?id="+id+"&dialog=1";
	showDialog(url);
	//document.frmmain.action="CarInfoEditTab.jsp?id="+id;
	//document.frmmain.submit();
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
	//编辑车辆信息
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(20316,user.getLanguage())%>";
	diag_vote.maxiumnable = true;
	diag_vote.URL = url;
	diag_vote.show();
}
function showDialog2(url){
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
	//车辆信息
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(20316,user.getLanguage())%>";
	diag_vote.maxiumnable = true;
	diag_vote.URL = url;
	diag_vote.show();
}
function doDel(id){
	//if(isdel()){
	//	document.frmmain.action="CarInfoOperation.jsp?operation=del&id="+id;
	//	document.frmmain.submit();
	//}
	
	var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
	Dialog.confirm(
		str, 
		function(){
			document.frmmain.action="CarInfoOperation.jsp?operation=del&id="+id;
			document.frmmain.submit();
		}, 
		function(){
			return;
		}, 
		200, 
		80
	);
}
function onBtnSearchClick(){
	document.frmmain.flowTitle2.value = jQuery("#flowTitle").val();
	document.frmmain.carNo.value = jQuery("#flowTitle").val();
	jQuery("#frmmain").submit();
}
function disModalDialog(url, spanobj, inputobj, need, curl) {
	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "" && wuiUtil.getJsonValueByIndex(id, 0) != "0") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}
function onClear(){
	$("form input[type=hidden][name^='startdate']").val("");
	$("form input[type=hidden][name^='enddate']").val("")
	$("form span[id^='startdate']").text('');
	$("form span[id^='enddate']").text('');
	
    $('form input[type=text]').val('');
    //清除下拉框
    jQuery("#advancedSearchDiv td select[ishide!='1']").val("");
	jQuery("#advancedSearchDiv td a[class='sbSelector']").html("");
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
