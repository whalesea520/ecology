
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetL" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>

<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>

<%
String CustomerID = Util.null2String(request.getParameter("CustomerID"));
String log=Util.null2String(request.getParameter("log"));
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
RecordSetL.executeProc("CRM_Log_Select",CustomerID);

RecordSet.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
if(RecordSet.getCounts()<=0)
{
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
	return;
}
RecordSet.first();

/*check right begin*/

String useridcheck=""+user.getUID();
String customerDepartment=""+RecordSet.getString("department") ;

boolean canview=false;
boolean canedit=false;
boolean canviewlog=false;
boolean canmailmerge=false;
boolean canapprove=false;

int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
if(sharelevel>0){
     canview=true;
     canviewlog=true;
     canmailmerge=true;
     if(sharelevel==2) canedit=true;
     if(sharelevel==3||sharelevel==4){
         canedit=true;
         canapprove=true;
     }
}

if(useridcheck.equals(RecordSet.getString("agent"))) {
	 canview=true;
	 canedit=true;
	 canviewlog=true;
	 canmailmerge=true;
 }

if(RecordSet.getInt("status")==7 || RecordSet.getInt("status")==8){
	canedit=false;
}

/*check right end*/

if(!canview){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<%
String submiter = Util.null2String(request.getParameter("submiter"));
String department = Util.null2String(request.getParameter("department"));
String subDepartment = Util.null2String(request.getParameter("subDepartment"));
String logtype = Util.null2String(request.getParameter("logtype"));
String clientip = Util.null2String(request.getParameter("clientip"));
String datetype = Util.null2String(request.getParameter("datetype"));
String startDate = Util.null2String(request.getParameter("startDate"));
String endDate = Util.null2String(request.getParameter("endDate"));
String childWhere = "";
if (!submiter.equals("")) {
	childWhere += " and submiter = '" + submiter + "'";
}

if (!department.equals("")) {
	childWhere += " and submiter in ( select id from HrmResource where departmentid = '"+department+"')" ;
}

if (!subDepartment.equals("")) {
	childWhere += " and submiter in ( select id from HrmResource where subcompanyid1 = '"+subDepartment+"')" ;
}
if (!logtype.equals("")) {
	childWhere += " and logtype = '" + logtype + "'";
}

if (!clientip.equals("")) {
	childWhere += " and clientip like '%" + clientip + "%'";
}

if(!"".equals(datetype) && !"6".equals(datetype)){
	childWhere += " and submitdate >= '"+TimeUtil.getDateByOption(datetype+"","0")+"'";
	childWhere += " and submitdate <= '"+TimeUtil.getDateByOption(datetype+"","")+"'";
}

if("6".equals(datetype) && !"".equals(startDate)){
	childWhere += " and submitdate >= '" + startDate + "'";
}

if("6".equals(datetype) && !"".equals(endDate)){
	childWhere += " and submitdate <= '" + endDate + "'";
}


%>
<HTML><HEAD>
<%if(isfromtab) {%>
<%} %>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename =  SystemEnv.getHtmlLabelName(103,user.getLanguage())+SystemEnv.getHtmlLabelName(264,user.getLanguage())+" - <a href='/CRM/data/ViewModify.jsp?log="+log+"&CustomerID="+RecordSet.getString("id")+"'>"+SystemEnv.getHtmlLabelName(361,user.getLanguage())+"</a>"+" - "+SystemEnv.getHtmlLabelName(136,user.getLanguage())+":<a href='/CRM/data/ViewCustomer.jsp?log="+log+"&CustomerID="+RecordSet.getString("id")+"'>"+Util.toScreen(RecordSet.getString("name"),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(!isfromtab){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
	String[] first={"n","d","a","p","m","u"};
	String[] second = {"c","a","s"};
	int[] firstMsg = {82,91,602,582,93,216};
	int[] secondMsg = {572,110,119};
	String options="";
	for(int i=0;i< first.length ;i++){
		options +="<option value=\""+first[i]+"\">"+SystemEnv.getHtmlLabelName(firstMsg[i],user.getLanguage())+"</option>";
	}
	
	for(int i=0;i< first.length ;i++){
		for(int m =0 ;m < second.length ; m++){
			options +="<option value=\""+first[i]+second[m]+"\">"
				+SystemEnv.getHtmlLabelName(firstMsg[i],user.getLanguage())+":"
				+SystemEnv.getHtmlLabelName(secondMsg[m],user.getLanguage())+"</option>";
		}
		
	}
	
%>

<%if(!isfromtab){%>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(15275,user.getLanguage())%>"/>
</jsp:include>
<%}else{%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr><td class="rightSearchSpan" style="text-align:right;">
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
	</td></tr>
</table>
<%}%>
<!-- 高级搜索 -->
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
<form id=weaver name=frmmain method=post action="/CRM/data/ViewLog.jsp?log=<%=log%>&CustomerID=<%=CustomerID%>&isfromtab=<%=isfromtab %>">
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%>'>
	
			<wea:item><%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="submiter" 
		         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
		         browserValue = '<%=submiter%>' 
	 			 browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(submiter),user.getLanguage())%>'
		         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		         completeUrl="/data.jsp" width="150px" >
		        </brow:browser>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(27511,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="department" 
		         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
		         browserValue = '<%=department%>' 
	 			 browserSpanValue='<%=Util.toScreen(DepartmentComInfo.getDepartmentname(department),user.getLanguage())%>'
		         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		         completeUrl="/data.jsp?type=57" width="150px" >
		        </brow:browser>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="subDepartment" 
		         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
		         browserValue = '<%=subDepartment%>' 
	 			 browserSpanValue='<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(subDepartment),user.getLanguage())%>'
		         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		         completeUrl="/data.jsp?type=164" width="150px" >
		         </brow:browser>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(15503,user.getLanguage())%></wea:item>
			<wea:item>
				<select class=InputStyle  size="1" name="logtype" style="width: 100px;">
					<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
					<%=options %>
				</select>
			</wea:item>
			
			<wea:item>IP<%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></wea:item>
			<wea:item>
				<INPUT class=InputStyle maxLength=120 name="clientip" value="<%= clientip%>" style="width: 150px;"/>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(15502,user.getLanguage())%></wea:item>
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
			        <input name="startDate" type="hidden"/>
					<input name="startDate" class="wuiDate"  _span="startDateSpan" value="<%= startDate%>"/>
					－
					<input name="endDate" class="wuiDate"  _span="endDateSpan"  value="<%= endDate%>"/>
					<input name="endDate" type="hidden"/>
				</span>
			</wea:item>
	</wea:group>
	
	<wea:group context="" attributes="{'Display':'none'}">
		<wea:item type="toolbar">
			<input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(82529,user.getLanguage())%>" id="searchBtn"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(27088,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondition()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
		
	</wea:group>
	
</wea:layout>
		
</form>
</div>

<%
    String tableString = "";
	String backfields = "submitdate,submittime,submiter,submitertype,clientip,logtype ";
	String fromSql  = " CRM_Log " ;
	String sqlWhere = " customerid = "+CustomerID+" "+childWhere;
	String orderby = " submitdate desc,submittime desc";
	tableString = " <table pageId=\""+PageIdConst.CRM_ModifyLog+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_ModifyLog,user.getUID(),PageIdConst.CRM)+"\" tabletype=\"none\">"+
				  " <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"customerid\" sqlsortway=\"Desc\"/>"+
	              " <head>"+
	              "	<col width='20%' text='"+SystemEnv.getHtmlLabelName(15502,user.getLanguage())+"' column=\"submitdate\" orderkey=\"submitdate\"  otherpara='column:submittime' transmethod=\"weaver.crm.Maint.CRMTransMethod.getDateTime\"/>"+
	              "	<col width='20%' text='"+SystemEnv.getHtmlLabelName(17482,user.getLanguage())+"' column=\"submiter\" orderkey=\"submiter\"  otherpara='column:submitertype+"+user.getLogintype()+"' transmethod=\"weaver.crm.Maint.CRMTransMethod.getLogSubmiter\"/>"+
	              "	<col width='20%' text='"+SystemEnv.getHtmlLabelName(32531,user.getLanguage())+"' column=\"clientip\" orderkey=\"clientip\"/>"+
	              "	<col width='40%' text='"+SystemEnv.getHtmlLabelName(15503,user.getLanguage())+"' column=\"logtype\" orderkey=\"logtype\" otherpara='"+CustomerID+"+"+user.getLanguage()+"+column:submittime+column:submitdate+column:logcontent' transmethod=\"weaver.crm.Maint.CRMTransMethod.getLogType\"/>"+
	 			  "	</head></table>";
  %>
<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.CRM_ModifyLog%>"> 
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>

<%if(!isfromtab){ %>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close();">
			</wea:item>
		</wea:group>	
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
<%} %>

<SCRIPT language="JavaScript">

jQuery(function(){
	jQuery("select[name='logtype']").selectbox("detach");
	jQuery("select[name='logtype']").val("<%=logtype%>"); 
	beautySelect();
	if("<%=datetype%>" == 6){
		jQuery("#dateTd").show();
	}else{
		jQuery("#dateTd").hide();
	}
});


function resetCondtion(){
	document.getElementById("weaver").reset();
	jQuery("select").find("option[value='']").attr("selected",true); 
	jQuery("input[name='startDate']").val("");
	jQuery("input[name='endDate']").val("");
	jQuery("span[name='startDateSpan']").html("");
	jQuery("span[name='endDateSpan']").html("");
}

$(document).ready(function(){
			
		jQuery("#topTitle").topMenuTitle({searchFn:searchName});
		jQuery("#hoverBtnSpan").hoverBtn();
				
});

function searchName(){
	
}

function onChangetype(obj){
	if(obj.value == 6){
		jQuery("#dateTd").show();
	}else{
		jQuery("#dateTd").hide();
	}
}
</SCRIPT>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</BODY>
</HTML>
