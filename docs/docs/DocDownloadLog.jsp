<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<%
	int id = Util.getIntValue(request.getParameter("id"),0);
 %>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
var dialog = null;
try{
	dialog = parent.parent.getDialog(parent); 
}catch(e){}
</script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript">
	function onBtnSearchClick(){
		jQuery("#report").submit();
	}
</script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(70,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(68,user.getLanguage());
String needfav ="1";
String needhelp ="";
String isDialog = Util.null2String(request.getParameter("isdialog"));
String creater = Util.null2String(request.getParameter("creater")) ;
String department = Util.null2String(request.getParameter("department")) ;
if(department.startsWith(","))  department=department.substring(1);
String imagename = Util.null2String(request.getParameter("imagename")) ;
String fromdate = Util.null2String(request.getParameter("fromdate")) ;
String todate = Util.null2String(request.getParameter("todate")) ;
String doccreatedateselect = Util.null2String(request.getParameter("doccreatedateselect"));
if(doccreatedateselect.equals(""))doccreatedateselect="1";

if(!doccreatedateselect.equals("") && !doccreatedateselect.equals("0") && !doccreatedateselect.equals("6")){
	fromdate = TimeUtil.getDateByOption(doccreatedateselect,"0");
	todate = TimeUtil.getDateByOption(doccreatedateselect,"1");
}

String creatername = "";
String whereclause = " where 1=1 ";
if(!fromdate.equals("")) {
	if(whereclause.equals("")) whereclause +="where downloadtime >='"+fromdate+"'" ;
	else whereclause +=" and downloadtime >='"+fromdate+"'" ;
}
if(!todate.equals("")) {
	if(whereclause.equals("")) whereclause +="where downloadtime <='"+todate+" 23:59:59'" ;
	else whereclause +=" and downloadtime <='"+todate+" 23:59:59'" ;
}
if(!imagename.equals("")){
	whereclause+=" and imagename like '%"+imagename+"%' ";
}
if(!creater.equals("")){
	whereclause+="and userid in ("+creater+") ";
	String[] tmpArr = creater.split(",");
	for(int i=0;i<tmpArr.length;i++){
		if(creatername.equals("")){
			creatername = Util.toScreen(ResourceComInfo.getLastname(tmpArr[i]),user.getLanguage());
		}else{
			creatername = creatername+","+Util.toScreen(ResourceComInfo.getLastname(tmpArr[i]),user.getLanguage());
		}
	}
}
String departmentname = "";
if(!department.equals("")){
	whereclause+="and userid in (select id from hrmresource where departmentid in ("+department+") )";
	String[] tmpArr = department.split(",");
	for(int i=0;i<tmpArr.length;i++){
		if(departmentname.equals("")){
			departmentname = Util.toScreen(DepartmentComInfo.getDepartmentname(tmpArr[i]),user.getLanguage());
		}else{
			departmentname = departmentname+","+Util.toScreen(DepartmentComInfo.getDepartmentname(tmpArr[i]),user.getLanguage());
		}
	}
}

%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="text" id="flowTitle" class="searchInput" name="flowTitle" value="<%= imagename %>" onchange="setKeyword('flowTitle','imagename','report');"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
	<FORM id=report name=report action=DocDownloadLog.jsp method=post>
	
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
	    <wea:item><%=SystemEnv.getHtmlLabelNames("17517",user.getLanguage())%></wea:item>
	    <wea:item>
	    	<input class=InputStyle id="imagename"  type="text" name="imagename" value="<%=imagename%>">
	    </wea:item>
	    <wea:item><%=SystemEnv.getHtmlLabelName(17519,user.getLanguage())%></wea:item>
	    <wea:item>
	    	<span class="wuiDateSpan" selectId="doccreatedateselect" selectValue="<%= doccreatedateselect%>">
			    <input class=wuiDateSel type="hidden" name="fromdate" value="<%=fromdate%>">
			    <input class=wuiDateSel  type="hidden" name="todate" value="<%=todate%>">
			</span>
	    </wea:item>
	    <wea:item><%=SystemEnv.getHtmlLabelName(17516,user.getLanguage())%></wea:item>
	    <wea:item>
	    <brow:browser viewType="0" name="creater" browserValue='<%= ""+creater %>' 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MultiResourceBrowser.jsp?resourceids="
				hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp" 
				browserSpanValue='<%=creatername%>'>
		</brow:browser>
	    </wea:item>
	    <wea:item><%=SystemEnv.getHtmlLabelNames("17516,27511",user.getLanguage())%></wea:item>
	    <wea:item>
	    <brow:browser viewType="0" name="department" browserValue='<%= ""+department %>' 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?resourceids="
				hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=4" 
				browserSpanValue='<%=departmentname%>'>
		</brow:browser>
	    </wea:item>
	  </wea:group>
	  <wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item type="toolbar">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
	  </wea:layout>
	</FORM>
</div>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>



			<%
				//设置好搜索条件				
				String tableString=""+
					   "<table pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_DOWNLOADDOCLOGSTA,user.getUID(),PageIdConst.DOC)+"\" tabletype=\"none\">"+
					   "<sql backfields=\"userid,username, downloadtime, imagename, docname, docid,clientaddress\" sqlwhere=\""+Util.toHtmlForSplitPage(whereclause)+"\"  sqlform=\"DownloadLog\" sqlorderby=\"downloadtime\"  sqlprimarykey=\"downloadtime\" sqlsortway=\"desc\"  />"+
					   "<head>";
					   		tableString +=	 "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(17517,user.getLanguage())+"\" column=\"imagename\"  orderkey=\"imagename\" />";
					   		tableString += "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(17516,user.getLanguage())+"\" column=\"userid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"column:usertype\" orderkey=\"username\"/>";
					   		tableString += "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(17518,user.getLanguage())+"\" column=\"docid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocDownLogURL\" otherpara=\"column:docname\" orderkey=\"docname\"/>";
					   		tableString+=	 "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(17519,user.getLanguage())+"\" column=\"downloadtime\"  orderkey=\"downloadtime\" />";
							tableString += "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(17484,user.getLanguage())+"\" column=\"clientaddress\" orderkey=\"clientaddress\"/>"+
					   "</head>"+
					   "</table>";      
			  %>
			  <input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.DOC_DOWNLOADDOCLOGSTA %>"/>
							<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/> 
 <%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
				</wea:item>
			</wea:group>
		</wea:layout>
</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
 </BODY></HTML>
