<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.proj.util.PropUtil"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CapitalStateComInfo" class="weaver.cpt.maintenance.CapitalStateComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String isDialog2 = Util.null2String(request.getParameter("isdialog2"));
if("".equals( isDialog)&&!"".equals(isDialog2)){
	isDialog=isDialog2;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/cpt/js/common_wev8.js"></script>
<script type="text/javascript">
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.parent.getParentWindow(parent.window);
}
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</head>
<%
String capitalid = request.getParameter("capitalid");
String nameQuery=Util.null2String(request.getParameter("flowTitle"));

if(!HrmUserVarify.checkUserRight("CptCapital:FlowView", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}

String sql="";
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String resourceid = Util.null2String(request.getParameter("resourceid"));
String stateid = Util.null2String(request.getParameter("stateid"));
String fromdate = Util.null2String(request.getParameter("fromdate"));
String todate = Util.null2String(request.getParameter("todate"));

int ishead = 0 ;

if(! sqlwhere1.equals("")) {
	sql = sqlwhere1 ;
	ishead = 1 ;
}

if(! departmentid.equals("")) {
	if(ishead == 0) {
		sql += " where usedeptid = " + departmentid ;
		ishead = 1;
	}
	else sql += " and usedeptid = " + departmentid ;
}

if(! resourceid.equals("")) {
	if(ishead == 0) {
		sql += " where useresourceid = " + resourceid ;
		ishead = 1;
	}
	else sql += " and useresourceid = " + resourceid ;
}

if(! stateid.equals("")) {
	if(ishead == 0) {
		sql += " where usestatus = " + stateid ;
		ishead = 1;
	}
	else sql += " and usestatus = " + stateid ;
}

if(! fromdate.equals("")) {
	if(ishead == 0) {
		sql += " where usedate >= '" + fromdate + "' " ;
		ishead = 1;
	}
	else sql += " and usedate >= '" + fromdate + "' " ;
}

if(! todate.equals("")) {
	if(ishead == 0) {
		sql += " where usedate <= '" + todate + "' " ;
		ishead = 1;
	}
	else sql += " and usedate <= '" + todate + "' " ;
}

if(! capitalid.equals("")) {
	if(ishead == 0) {
		sql += " where capitalid = " + capitalid ;
		ishead = 1;
	}
	else sql += " and capitalid = " + capitalid ;
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1501,user.getLanguage());
String needfav ="1";
String needhelp ="";
String pageId=Util.null2String(PropUtil.getPageId("cpt_cptcapitalflowview"));
%>
<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=frmain name=frmain action="CptCapitalFlowView.jsp" method=post>
<input type="hidden" name="pageId" id="pageId" value="<%=pageId  %>" />
<input type="hidden" id=sqlwhere1 name="sqlwhere1" value="<%=xssUtil.put(sqlwhere1)%>">
<input type="hidden" id=capitalid name="capitalid" value="<%=capitalid%>">
<input type="hidden" id=isdialog2 name="isdialog2" value="<%=isDialog %>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<span id="advancedSearch" class="advancedSearch" style="display:"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<!-- advanced search -->
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:">
	<wea:layout type="4col">
	    <wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage())%>'>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
	    	<wea:item>
	    		<brow:browser  name="departmentid" browserValue='<%=departmentid%>' browserSpanValue='<%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid ),user.getLanguage())%>' browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp" completeUrl="/data.jsp?type=4"  isMustInput="1" viewType="0" browserOnClick=""  hasInput="true"  isSingle="true" hasBrowser = "true" />
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></wea:item>
	    	<wea:item>
	    		<brow:browser  name="resourceid" browserValue='<%=resourceid%>' browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename (resourceid),user.getLanguage())%>' browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" completeUrl="/data.jsp"  isMustInput="1" viewType="0" browserOnClick=""  hasInput="true"  isSingle="true" hasBrowser = "true" />
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
	    	<wea:item>
	    		<brow:browser  name="stateid" browserValue='<%=stateid%>' browserSpanValue='<%=Util.toScreen(CapitalStateComInfo.getCapitalStatename(stateid),user.getLanguage())%>' browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalStateBrowser.jsp?from=flowview" completeUrl="/data.jsp?type=?"  isMustInput="1" viewType="0" browserOnClick=""  hasInput="true"  isSingle="true" hasBrowser = "true" />
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(1394,user.getLanguage())%></wea:item>
	    	<wea:item>
	    		<span class="wuiDateSpan" selectId="selectdate_sel" selectValue="">
				    <input class=wuiDateSel type="hidden" name="fromdate" value="<%=fromdate%>">
				    <input class=wuiDateSel  type="hidden" name="todate" value="<%=todate%>">
				</span>
	    	</wea:item>
	    </wea:group>
	    
	    
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input class="zd_btn_submit" type="submit" name="submit1" value="<%=SystemEnv.getHtmlLabelNames("197",user.getLanguage())%>"/>
	    		<input class="zd_btn_cancle" type="reset" name="reset" value="<%=SystemEnv.getHtmlLabelNames("2022",user.getLanguage())%>"/>
	    		<input class="zd_btn_cancle" type="button" name="cancel" id="cancel" value="<%=SystemEnv.getHtmlLabelNames("201",user.getLanguage())%>"  />
	    	</wea:item>
	    </wea:group>
	    
	</wea:layout>
</div>


<%

String sqlWhere = sql;

if(!"".equals(nameQuery)){
	//sqlWhere+=" and assortmentname like '%"+nameQuery+"%'";
}

String orderby =" id ";
String tableString = "";
int perpage=16;                                 
String backfields = " id,capitalid,usedate,usedeptid,useresourceid,usecount,useaddress,userequest,usestatus,fee,"+("sqlserver".equalsIgnoreCase( rs.getDBType())?"convert(varchar(1000),remark) remark ":"remark ");
String fromSql  = " CptUseLog ";

tableString =   " <table  pageId=\""+pageId+"\"  instanceid=\"CptCapitalAssortmentTable\" tabletype=\"none\"  pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID(),"cpt")+"\"  >"+
				//" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod='weaver.cpt.util.CapitalTransUtil.getCanDelCptAssortmentShare' />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"DESC\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelNames("1380,264",user.getLanguage())+"ID\" column=\"id\" orderkey=\"id\"   />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(1394,user.getLanguage())+"\" column=\"usedate\" orderkey=\"usedate\"  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(1435,user.getLanguage())+"\" column=\"usedeptid\" orderkey=\"usedeptid\"  transmethod='weaver.hrm.company.DepartmentComInfo.getDepartmentname' />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(179,user.getLanguage())+"\" column=\"useresourceid\" orderkey=\"useresourceid\"  transmethod='weaver.hrm.resource.ResourceComInfo.getResourcename' />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"usestatus\" orderkey=\"usestatus\"  transmethod='weaver.cpt.maintenance.CapitalStateComInfo.getCapitalStatename' />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(1331,user.getLanguage())+"\" column=\"usecount\" orderkey=\"usecount\"  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(1395,user.getLanguage())+"\" column=\"useaddress\" orderkey=\"useaddress\"  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(1491,user.getLanguage())+"\" column=\"fee\" orderkey=\"fee\"  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(454,user.getLanguage())+"\" column=\"remark\" orderkey=\"remark\"  />"+
                "       </head>"+
                "     <popedom column=\"id\"  ></popedom> "+
                "		<operates>"+
					"		<operate href=\"javascript:onDetail();\" text=\""+SystemEnv.getHtmlLabelName(1293,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
				"		</operates>"+                 
                " </table>";
%>

<wea:SplitPageTag  tableString='<%=tableString %>'  mode="run" />



</FORM>
<script language="javascript">
function onDetail(id){
	if(id){
		var url="/cpt/capital/CptCapitalFlowViewDetail.jsp?isdialog=1&id="+id;
		var title="<%=SystemEnv.getHtmlLabelName(1293,user.getLanguage()) %>";
		openDialog(url,title,800,600);
	}
}


function onShowResourceID(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (data!=null){
		if (data.id != ""){
			jQuery("#resourceidspan").html("<A href='/hrm/resource/HrmResource.jsp?id="+data.id+"'>"+data.name+"</A>");
			jQuery("input[name=resourceid]").val(data.id);
		}else {
			jQuery("#resourceidspan").html("");
			jQuery("input[name=resourceid]").val("");
		}
	}
}

 function onShowDepartmentID(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+jQuery("input[name=departmentid").val());
	issame = false; 
	if (data!=null){
		if (data.id != ""){
			if (data.id  == jQuery("input[name=departmentid]").val()){
				issame = true; 
			}
			jQuery("#departmentidspan").html(data.name);
			jQuery("input[name=departmentid]").val(data.id);
		}else{
			jQuery("#departmentidspan").html("");
			jQuery("input[name=departmentid]").val("");
		}
	}
 }

function onShowStateID(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalStateBrowser.jsp?from=flowview");
	if (data!=null){
		if (data.id != ""){
			jQuery("#stateidspan").html(data.name);
			jQuery("input[name=stateid]").val(data.id);
		}else {
			jQuery("#stateidspan").html("");
			jQuery("input[name=stateid]").val("");
		}
	}
}

 function onSubmit()
{
	frmain.submit();
}
 
function onBtnSearchClick(){
	frmain.submit();
}
$(function(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
});
</script>

<%
if("1".equals(isDialog)){
	%>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="onclose()"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>	
	
	<%
}
%>

<script language="javascript">
function onclose(){
	parentWin._table.reLoad();
	parentWin.closeDialog();
}
</script>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
