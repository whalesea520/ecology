
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SystemLogItemTypeComInfo" class="weaver.systeminfo.SystemLogItemTypeComInfo" scope="page" />

<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%	
	String relatedname = Util.null2String(request.getParameter("relatedname"));
	String itemname = Util.null2String(request.getParameter("itemname"));
	String fromdate = Util.null2String(request.getParameter("fromdate")) ;
	String todate = Util.null2String(request.getParameter("todate")) ;
	String typeid = Util.null2String(request.getParameter("typeid"));
	int operatesmalltype = Util.getIntValue(request.getParameter("operatesmalltype"),0);//0: 维护日志  1：操作日志
	String currentuser = Util.null2String(request.getParameter("currentuser"));
	if(currentuser.equals("")){
		currentuser = ""+user.getUID();
	}
	String doccreatedateselect = Util.null2String(request.getParameter("doccreatedateselect"));
	if(doccreatedateselect.equals(""))doccreatedateselect="1";

	if(!doccreatedateselect.equals("") && !doccreatedateselect.equals("0") && !doccreatedateselect.equals("6")){
		fromdate = TimeUtil.getDateByOption(doccreatedateselect,"0");
		todate = TimeUtil.getDateByOption(doccreatedateselect,"1");
	}
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(17625, user.getLanguage());
	String needfav ="1";
	String needhelp ="";

    String absentUrl="/report/ChartMeetingAbsent.jsp?currentuser="+currentuser;

%>
<HTML>
  <HEAD>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
  </HEAD>
  <BODY>
    <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(354,user.getLanguage())+",javascript:doSearchsubmit(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	%>

	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; ">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(28343,user.getLanguage())%>" class="e8_btn_top" onclick="exportExcel();">
				<input type="text" id="flowTitle" class="searchInput" name="flowTitle" value="<%= relatedname %>" onchange="setKeyword('flowTitle','relatedname','report');"/>
				<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<div class="advancedSearchDiv" id="advancedSearchDiv"> 
	<FORM id=report name=report action="Statistics.jsp" method=post  >
		<input type="hidden" name="operatesmalltype" id="operatesmalltype" value="<%=operatesmalltype %>"/>
		<div style="display:none;">
		<brow:browser viewType="0" name="currentuser" browserValue='<%= ""+currentuser %>' 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
				hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='1' _callback="setNavName"
				completeUrl="/data.jsp" temptitle='<%= SystemEnv.getHtmlLabelName(17482,user.getLanguage())%>'
				browserSpanValue="">
		</brow:browser>
	</div>
		<wea:layout type="4col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>' >
				<wea:item><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%></wea:item>
				<wea:item>
					<input type="text" id="relatedname" name="relatedname" value="<%=relatedname %>"/>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelNames(operatesmalltype==1?"30585,33367":"33281",user.getLanguage())%></wea:item>
				<wea:item>
					<input type="text" id="itemname" name="itemname" value="<%=itemname %>"/>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(19049, user.getLanguage())%></wea:item>
			<wea:item>
				<select id="typeid" name="typeid">
					<option value=""><%=SystemEnv.getHtmlLabelName(332, user.getLanguage()) %></option>
					<%
					SystemLogItemTypeComInfo.setTofirstRow();
					while(SystemLogItemTypeComInfo.next()){
					%>
					<option value="<%=SystemLogItemTypeComInfo.getSystemLogItemTypeId() %>" <%=typeid.equals(""+SystemLogItemTypeComInfo.getSystemLogItemTypeId())?"selected":"" %>><%=SystemLogItemTypeComInfo.getSystemLogItemlabelname(""+SystemLogItemTypeComInfo.getSystemLogItemTypeId(),""+user.getLanguage()+"+"+operatesmalltype) %></option>
					<%} %>
				</select>
			</wea:item>
				 <!-- 时间范围 -->
				<wea:item ><%=SystemEnv.getHtmlLabelName(19482,user.getLanguage())%></wea:item>
				<wea:item>
					<span class="wuiDateSpan" selectId="doccreatedateselect">
					    <input class=wuiDateSel type="hidden" name="fromdate" value="<%=fromdate%>">
					    <input class=wuiDateSel  type="hidden" name="todate" value="<%=todate%>">
					</span>
				</wea:item>
			</wea:group>
			<wea:group context="">
				<wea:item type="toolbar">
					<input type="button" onclick="doSearchsubmit()" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtionAVS();"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
				</wea:item>
			</wea:group>
		</wea:layout>
	</FORM>
	</div>
	<wea:layout needImportDefaultJsAndCss="false" attributes="{'expandAllGroup':'true'}">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item>
				<div id="absentDiv" style="position:relative; margin:0px auto; padding:0px; height:220px; overflow: hidden;">
					<iframe id="absentUrl" frameborder="0" height="220px" width="99%;" scrolling="no"></iframe>
				</div>
			</wea:item>
		</wea:group>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(33258,user.getLanguage())%>'>
			<wea:item attributes="{'isTableList':'true','colspan':'full'}">	
			<%
			//时间		类型					项目					对象										客户端地址	
			String backfields = " id,operateuserid,operateusertype, operatedate, operateTime, operatetype, lableId, relatedName, clientaddress, typeid "; 
			String fromSql  = " from SysMaintenanceLog, SystemLogItem ";
			String sqlWhere = " where SysMaintenanceLog.operateItem = SystemLogItem.itemId and SystemLogItem.itemid != 60 and (SysMaintenanceLog.operatesmalltype!=1 or SysMaintenanceLog.operatesmalltype is null)";
			if(operatesmalltype==1){
				sqlWhere = " where SysMaintenanceLog.operateItem = SystemLogItem.itemId and SystemLogItem.itemid != 60 and SysMaintenanceLog.operatesmalltype=1";
			}
			String orderby = " operatedate " ;
			String tableString = "";

			if(!relatedname.equals("")){
				sqlWhere += " and relatedName like '%"+relatedname+"%'";
			}
			if(!itemname.equals("")){
				sqlWhere += " and itemdesc like '%"+itemname+"%'";
			}			
			if (!"".equals(typeid)) { 
				if(typeid.equals("-1")){
					sqlWhere += " and SystemLogItem.typeid is null ";
				}else{
					sqlWhere += " and SystemLogItem.typeid = "+typeid;
				}
			}
			
			if(!"-1".equals(currentuser)){
				sqlWhere += " and SysMaintenanceLog.operateuserid="+currentuser;
			}
			
			if(!"".equals(fromdate)){
				sqlWhere += " and SysMaintenanceLog.operatedate >= '"+fromdate+"'"; 
			}
			
			if(!"".equals(todate)){
				sqlWhere += " and SysMaintenanceLog.operatedate <= '"+todate+"'"; 
			}
			
			int perpage = 10;

			tableString =" <table instanceid=\"HrmSysAdminBasicTable\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_INDEXDOCLOGSTA,user.getUID(),PageIdConst.DOC)+"\" >"+
					"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"SysMaintenanceLog.id\" sqlsortway=\"desc\" />"+
			    "			<head>";
			    if("-1".equals(currentuser)){
			    	tableString += "			<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(17482, user.getLanguage())+"\" column=\"operateuserid\" orderkey=\"operateuserid\" otherpara=\"column:operateusertype\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" />";
			    }
			   tableString += "			<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(97, user.getLanguage())+"\" column=\"operateDate\" orderkey=\"operateDate\" otherpara=\"column:operateTime\" transmethod=\"weaver.splitepage.transform.SptmForCowork.combineDateTime\" />"+
			    "			<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelNames("25037,63", user.getLanguage())+"\" column=\"operateType\" otherpara=\"column:typeid+" + user.getLanguage() + "\" orderkey=\"operateType\" transmethod=\"weaver.splitepage.transform.SptmForCowork.getTypeName\"/>"+
			    "			<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelNames(operatesmalltype==1?"30585,33367":"33281", user.getLanguage())+"\" column=\"lableId\" orderkey=\"lableId\" otherpara=\"" + user.getLanguage() + "\" transmethod=\"weaver.splitepage.transform.SptmForCowork.getItemLableName\"/>"+
			    "			<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(106, user.getLanguage())+"\" column=\"relatedName\" orderkey=\"relatedName\"/>"+
			    "			<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(19049, user.getLanguage())+"\" column=\"typeid\" orderkey=\"typeid\" transmethod=\"weaver.systeminfo.SystemLogItemTypeComInfo.getSystemLogItemlabelname\" otherpara=\"" + user.getLanguage()+"+"+operatesmalltype + "\"/>"+
			    "			<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(108, user.getLanguage())+SystemEnv.getHtmlLabelName(110, user.getLanguage())+"\" orderkey=\"clientAddress\" column=\"clientAddress\"/>"+
			    "			</head>"+
			    " </table>";
			%>
			<input type="hidden" name="pageId" id="pageId" _showCol="false" value="<%= PageIdConst.DOC_INDEXDOCLOGSTA %>"/>
			<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" /> 
		</wea:item>
		</wea:group>
	</wea:layout>
  </BODY>
</HTML>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT LANGUAGE="JavaScript">

 
 $(document).ready(function () {
    //js控制iframe加载
    window.setTimeout(function(){
	   	var url = "<%=absentUrl%>";
	   	var params = decodeURIComponent(jQuery("#report").serialize());
	   	url += "&"+params;
	   	url+="&currentuser=<%=currentuser%>";
	    $('#absentUrl').attr("src",url);
		jQuery('#overFlowDiv').perfectScrollbar();
	 	if (window.jQuery.client.browser == "Chrome") {
	 		jQuery('#overFlowDiv').height(jQuery(window).height()-2);
			jQuery('#overFlowDiv').perfectScrollbar('update');
	 	}
		jQuery("#absentDiv").css("display","");
	},300);
	parent.openResource(document);
	parent.switchOperateType(document);
 });


function exportExcel(){
	_xtable_getAllExcel();
}

function preDo(){
	//tabSelectChg();
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	jQuery("#hoverBtnSpan").hoverBtn();
}

function onBtnSearchClick(){
	//var name=$("input[name='t_name']",parent.document).val();
	//$("input[name='names']").val(name);
	doSearchsubmit();
}

function doSearchsubmit(){
	$('#report').submit();
}

function onSearch(obj) {
    obj.disabled = true ;
    doSearchsubmit();
}

function setNavName(e,datas,name,params){
		if(datas){
			if(datas.id==""){
				datas.name = "所有人";
				jQuery("#currentuser").val(-1);
			}
			jQuery("#e8_resource",parent.document).html(datas.name);
			doSearchsubmit();
		}
}



 
 

</SCRIPT>
