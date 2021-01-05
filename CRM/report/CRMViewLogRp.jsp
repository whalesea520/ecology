<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("LogView:View", user))  {
        response.sendRedirect("/notice/noright.jsp") ;
	    return ;
    }
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(730,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(679,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<%
int viewer=Util.getIntValue(request.getParameter("viewer"),0);
int manager=Util.getIntValue(request.getParameter("manager"),0);
int customer=Util.getIntValue(request.getParameter("customer"),0);
String searchName = Util.null2String(request.getParameter("searchName"));

String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String datetype = Util.null2String(request.getParameter("datetype"));


String sqlwhere="";
if(viewer!=0){
	sqlwhere+=" and t1.viewer="+viewer;
}
if(manager!=0){
	sqlwhere+=" and t3.manager="+manager;
}
if(viewer!=0){
	sqlwhere+=" and t1.id="+customer;
}

if(!"".equals(searchName)){
	sqlwhere = " and t3.name like '%"+searchName+"%'";
}

if(!"".equals(datetype) && !"6".equals(datetype)){
	sqlwhere += " and viewdate >= '"+TimeUtil.getDateByOption(datetype+"","0")+" 00:00:00'";
	sqlwhere += " and viewdate <= '"+TimeUtil.getDateByOption(datetype+"","")+" 00:00:00'";
}

if("6".equals(datetype) && !"".equals(fromdate)){
	sqlwhere += " and viewdate > '"+fromdate+" 00:00:00'";
}

if("6".equals(datetype) && !"".equals(enddate)){
	sqlwhere += " and viewdate < '"+enddate+" 23:59:59'";
}


if(sqlwhere.equals("")){
	sqlwhere += " and t1.id != 0 " ;
}
%>

<BODY>
<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input type="text" class="searchInput"  id="searchNameInfo" name="searchNameInfo" value="<%=searchName%>" />
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
<form id=weaver name=weaver method=post action="CRMViewLogRp.jsp">
<input type="hidden" name="searchName" value="<%=searchName %>">  
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>' attributes="">
		<wea:item><%=SystemEnv.getHtmlLabelName(730,user.getLanguage())+SystemEnv.getHtmlLabelName(136,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="customer" 
			        browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
			        browserValue='<%=customer+""%>' 
			        browserSpanValue = '<%=CustomerInfoComInfo.getCustomerInfoname(customer+"")%>'
			        isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			        completeUrl="/data.jsp" width="150px" ></brow:browser>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="manager" 
		        browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
		        browserValue='<%=manager+""%>' 
		        browserSpanValue = '<%=ResourceComInfo.getResourcename(manager+"")%>'
		        isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		        completeUrl="/data.jsp" width="150px" ></brow:browser>
		</wea:item>
					
		<wea:item><%=SystemEnv.getHtmlLabelName(15530,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="viewer" 
		        browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
		        browserValue='<%=viewer+""%>' 
		        browserSpanValue = '<%=ResourceComInfo.getResourcename(viewer+"")%>'
		        isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		        completeUrl="/data.jsp" width="150px" ></brow:browser>
		</wea:item>
		
	  
	  <wea:item><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></wea:item>
       <wea:item>
       		<span>
	        	<SELECT  name="datetype" id="datetype" onchange="onChangetype(this)" style="width: 100px;">
				  <option value="" 	<%if(datetype.equals("")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				  <option value="1" <%if(datetype.equals("1")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
				  <option value="2" <%if(datetype.equals("2")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
				  <option value="3" <%if(datetype.equals("3")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
				  <option value="4" <%if(datetype.equals("4")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
				  <option value="5" <%if(datetype.equals("5")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
				  <option value="6" <%if(datetype.equals("6")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
				</SELECT>     
			</span>
        
        	<span id="dateTd" style="margin-left: 10px;padding-top: 5px;">
				<button class="Calendar" style="height: 16px" type="button" onclick="getDate(startdatespan,fromdate)" value="<%=fromdate%>"></button>
				<span id="startdatespan"><%=fromdate%></span>
				<input type="hidden" id="fromdate" name="fromdate">
				－
				<button class="Calendar" style="height: 16px" type="button" onclick="getDate(enddatespan,enddate)" value="<%=enddate%>"></button>
				<span id="enddatespan"><%=enddate%></span>
				<input type="hidden" id="enddate" name="enddate">
			</span>
       </wea:item> 
		        	
	</wea:group>
	
	<wea:group context="" attributes="{'Display':'none'}">
		<wea:item type="toolbar">
			<input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(82529,user.getLanguage())%>" id="searchBtn"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(27088,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondition()"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
	
</wea:layout>
</form>
</div>

<%
String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
String orderby = "t1.viewdate ,t1.viewtime ";
String fromSql = "CRM_ViewLog1  t1,"+leftjointable+"  t2 , CRM_CustomerInfo t3 ";
String sqlWhere = " t1.id = t2.relateditemid and t1.id = t3.id "+sqlwhere;
String backfields = "t1.* , t3.manager  ";
if(!user.getLogintype().equals("1")){
	fromSql = "CRM_ViewLog1  t1";
	sqlWhere =  " t1.agent="+user.getUID()+sqlwhere;
}


String tableString =" <table instanceid=\"info\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_ViewLog,user.getUID(),PageIdConst.CRM)+"\" tabletype=\"none\" pageId=\""+PageIdConst.CRM_ViewLog+"\">"+ 
"<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  "+
	"sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\"/>"+
"<head>"+
"<col width=\"15%\"  text=\""+ SystemEnv.getHtmlLabelName(1273,user.getLanguage()) +"\" column=\"viewer\" "+
	" otherpara=\"column:submitertype+"+user.getLogintype()+"\" transmethod=\"weaver.crm.report.CRMReporttTransMethod.getSubmiterInfo\" />"+
"<col width=\"20%\"  text=\""+ SystemEnv.getHtmlLabelName(1272,user.getLanguage()) +"\" column=\"viewdate\""+
	" otherpara=\"column:viewtime\" transmethod=\"weaver.crm.report.CRMReporttTransMethod.getCrmModifyTime\"/>"+ 
"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(730,user.getLanguage())+SystemEnv.getHtmlLabelName(136,user.getLanguage()) +"\" column=\"id\""+ 
	" transmethod=\"weaver.crm.Maint.CustomerInfoComInfo.getCustomerInfoname\""+
	" href=\"/CRM/data/ViewCustomer.jsp\" linkkey = \"CustomerID\" linkvaluecolumn = \"id\"/>"+ 
"<col width=\"15%\"  text=\""+ SystemEnv.getHtmlLabelName(1278,user.getLanguage()) +"\" column=\"manager\" "+
	" otherpara=\""+user.getLogintype()+"\" transmethod=\"weaver.crm.report.CRMReporttTransMethod.getManagerInfo\" />"+
"<col width=\"20%\"  text=\""+ SystemEnv.getHtmlLabelName(33586,user.getLanguage()) +"\" column=\"ipaddress\" />"+ 
"</head>"+   			
"</table>";

%>

<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.CRM_ViewLog%>">
<wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="false"/>

</body>
<script type="text/javascript">
  
$(document).ready(function(){
	jQuery("#topTitle").topMenuTitle({searchFn:searchInfo});
	jQuery("#hoverBtnSpan").hoverBtn();
	if("<%=datetype%>" == 6){
		jQuery("#dateTd").show();
	}else{
		jQuery("#dateTd").hide();
	}
});
 function onChangetype(obj){
	if(obj.value == 6){
		jQuery("#dateTd").show();
	}else{
		jQuery("#dateTd").hide();
	}
}
	
function onChangetype(obj){
	if(obj.value == 7){
		jQuery("#defineDate").show();
	}else{
		jQuery("#defineDate").hide();
	}
}

function searchInfo(){
	jQuery("input[name='searchName']").val(jQuery("#searchNameInfo").val());
	weaver.submit();
}

</script>
<script language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<script language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
