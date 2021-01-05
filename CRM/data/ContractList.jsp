
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.sql.Timestamp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ContractTypeComInfo" class="weaver.crm.Maint.ContractTypeComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="ContacterShareBase" class="weaver.crm.ContacterShareBase" scope="page"/>

<%@ taglib uri="/browserTag" prefix="brow"%>
<%
    String CustomerID = request.getParameter("CustomerID");
	boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
    //out.print(CustomerID);
	RecordSet.executeProc("CRM_Contract_Select",CustomerID);

%>
<HTML><HEAD>
<%if(isfromtab) {%>
<%} %>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(614,user.getLanguage()) + " : " + "<a href=\"#\" onclick=\"javascript:parent.location='/CRM/data/ViewCustomer.jsp?CustomerID=" + CustomerID + "'\">" +  Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(CustomerID),user.getLanguage()) + "</a>";
String needfav ="1";
String needhelp ="";

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

String name = Util.null2String(request.getParameter("name"));
String typeId = Util.null2String(request.getParameter("typeId"));
String price = Util.null2String(request.getParameter("price"));
String price_1 = Util.null2String(request.getParameter("price_1"));
String status = Util.null2String(request.getParameter("status"));
String startDateBegin = Util.null2String(request.getParameter("startDateBegin"));
String startDateEnd = Util.null2String(request.getParameter("startDateEnd"));
String datetypeStart = Util.null2String(request.getParameter("datetypeStart"));
String endDateBegin = Util.null2String(request.getParameter("endDateBegin"));
String endDateEnd = Util.null2String(request.getParameter("endDateEnd"));
String datetypeEnd = Util.null2String(request.getParameter("datetypeEnd"));
String manager = Util.null2String(request.getParameter("manager"));
String managerDepartment = Util.null2String(request.getParameter("managerDepartment"));
String managerSubCompany = Util.null2String(request.getParameter("managerSubCompany"));
String creater = Util.null2String(request.getParameter("creater"));
String createrDepartment = Util.null2String(request.getParameter("createrDepartment"));
String createrSubCompany = Util.null2String(request.getParameter("createrSubCompany"));

/*check right begin*/

String useridcheck=""+user.getUID();

boolean canview=false;
boolean canedit=false;

//String ViewSql="select * from CrmShareDetail where crmid="+CustomerID+" and usertype="+user.getLogintype()+" and userid="+user.getUID();

//RecordSetV.executeSql(ViewSql);

//if(RecordSetV.next())
//{
//	 canview=true;
//	 if(RecordSetV.getString("sharelevel").equals("2")){
//		canedit=true;	  
//	 }else if (RecordSetV.getString("sharelevel").equals("3") || RecordSetV.getString("sharelevel").equals("4")){
//		canedit=true;		
//	 }
//}

int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
if(sharelevel>0){
    canview=true;
    if(sharelevel>1) canedit=true;
}

/*check right end*/

String childWhere = "";
if(!"".equals(name)){
	childWhere += " and name like '%" + name + "%'";
}

if(!"".equals(typeId)){
	childWhere += " and typeId = '" + typeId + "'";
}

if(!"".equals(price)){
	childWhere += " and price >= '" + price + "'";
}

if(!"".equals(price_1)){
	childWhere += " and price <= '" + price_1 + "'";
}

if(!"".equals(status)){
	childWhere += " and status = '" + status + "'";
}
if(!"".equals(datetypeStart) && !"6".equals(datetypeStart)){
	childWhere += " and startDate >= '"+TimeUtil.getDateByOption(datetypeStart+"","0")+"'";
	childWhere += " and startDate <= '"+TimeUtil.getDateByOption(datetypeStart+"","")+"'";
}
if ("6".equals(datetypeStart) && !startDateBegin.equals("")) {
	childWhere += " and startDate >= '" + startDateBegin + "'";
}

if ("6".equals(datetypeStart) && !startDateEnd.equals("")) {
	childWhere += " and startDate <= '" + startDateEnd + "'";
}

if (!endDateBegin.equals("")) {
	childWhere += " and endDate >= '" + endDateBegin + "'";
}
if(!"".equals(datetypeEnd) && !"6".equals(datetypeEnd)){
	childWhere += " and endDate >= '"+TimeUtil.getDateByOption(datetypeEnd+"","0")+"'";
	childWhere += " and endDate <= '"+TimeUtil.getDateByOption(datetypeEnd+"","")+"'";
}
if ("6".equals(datetypeEnd) && !endDateEnd.equals("")) {
	childWhere += " and endDate <= '" + endDateEnd + "'";
}
if("6".equals(datetypeEnd) && !"".equals(manager)){
	childWhere += " and manager in (" + manager + ")";
}

if(!"".equals(managerDepartment)){
	childWhere += " and manager in (select id from HrmResource where departmentid in ( " + managerDepartment + "))";
}

if(!"".equals(managerSubCompany)){
	childWhere += " and manager in (select id from HrmResource where subcompanyid1 in ( " + managerSubCompany + "))";
}

if(!"".equals(creater)){
	childWhere += " and creater in (" + creater + ")";
}

if(!"".equals(createrDepartment)){
	childWhere += " and creater in (select id from HrmResource where departmentid in ( " + createrDepartment + "))";
}

if(!"".equals(createrSubCompany)){
	childWhere += " and creater in (select id from HrmResource where subcompanyid1 in ( " + createrSubCompany + "))";
}
%>
<BODY>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	
	<tr><td class="rightSearchSpan" style="text-align:right;">
		<% if (canedit) {%>
			<input class="e8_btn_top middle" onclick="doAdd(this)" type="button"  value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>"/>
            <input class="e8_btn_top middle" onclick="deleteInfos()" type="button"  value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>"/>
		<%} %>
		<input type="text" class="searchInput"  id="searchSubject" name="searchSubject" value="<%=name %>" onchange="searchSubject()"/>
		<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
		<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
	</td></tr>
</table>

<!-- 高级搜索 -->
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
<form id=weaver name=frmmain method=post action="/CRM/data/ContractList.jsp">
<input type="hidden" name="CustomerID" value="<%=CustomerID %>">
<input type="hidden" name="isfromtab" value="<%=CustomerID %>">

<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(15142,user.getLanguage())%></wea:item>
	  	<wea:item><input class=InputStyle  maxLength=120 size=29 name="name" value='<%=name %>' style="width: 150px;"></wea:item>
	  	
	  	<wea:item><%=SystemEnv.getHtmlLabelName(6083,user.getLanguage())%></wea:item>
	  	<wea:item>
	  		<select class=InputStyle id=typeId name=typeId style="width: 100px;">
	  			<option value="" ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
	          	<% while(ContractTypeComInfo.next()){ %>
	            <option value=<%=ContractTypeComInfo.getContractTypeid()%> <%if(typeId.equals(ContractTypeComInfo.getContractTypeid())){%>selected<%}%>><%=ContractTypeComInfo.getContractTypename()%></option>
	            <%}%>
			</select>
	  	</wea:item>
	  	
	  	<wea:item><%=SystemEnv.getHtmlLabelName(6146,user.getLanguage())%>  </wea:item>
	    <wea:item>
	    	<INPUT text style="width: 100px;" class=InputStyle maxLength=20 size=12 id="price" name="price" value="<%=price %>"    onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield");comparenumber()' >
	    	-
	    	<INPUT text style="width: 100px;" class=InputStyle maxLength=20 size=12 id="price_1" name="price_1" value="<%=price_1 %>"  onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield_1");comparenumber()'>
	    </wea:item>

	  	<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
	  	<wea:item>
	  		<select class=InputStyle id=status name=status style="width: 100px;">
	  			<option value="" ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
	            <option value="0"><%=SystemEnv.getHtmlLabelName(615,user.getLanguage()) %></option>
	            <option value="-1"><%=SystemEnv.getHtmlLabelName(2242,user.getLanguage()) %></option>
	            <option value="1"><%=SystemEnv.getHtmlLabelName(359,user.getLanguage()) %></option>
	            <option value="2"><%=SystemEnv.getHtmlLabelName(6095,user.getLanguage()) %></option>
	            <option value="3"><%=SystemEnv.getHtmlLabelName(555,user.getLanguage()) %></option>
			</select>
	  	</wea:item>
	  	<wea:item><%=SystemEnv.getHtmlLabelName(1936,user.getLanguage())%>  </wea:item>
	  	<wea:item>
	  		<span>
	        	<SELECT  name="datetypeStart" id="datetypeStart" onchange="onChangetypeStart(this)" style="width: 100px;">
				  <option value="" 	<%if(datetypeStart.equals("")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				  <option value="1" <%if(datetypeStart.equals("1")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
				  <option value="2" <%if(datetypeStart.equals("2")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
				  <option value="3" <%if(datetypeStart.equals("3")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
				  <option value="4" <%if(datetypeStart.equals("4")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
				  <option value="5" <%if(datetypeStart.equals("5")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
				  <option value="6" <%if(datetypeStart.equals("6")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
				</SELECT>     
			</span>
        
        	<span id="dateTdStart" style="margin-left: 10px;padding-top: 5px;">
		  		<BUTTON type="button" class=calendar id=SelectDate onclick=getDate(startDateBeginSpan,startDateBegin)></BUTTON>&nbsp;
				<SPAN id="startDateBeginSpan" ><%=startDateBegin %></SPAN>
				<input type="hidden" name="startDateBegin" value="<%=startDateBegin %>">
				-
				<BUTTON type="button" class=calendar id=SelectDate onclick=getDate(startDateEndSpan,startDateEnd)></BUTTON>&nbsp;
				<SPAN id="startDateEndSpan" ><%=startDateEnd %></SPAN>
				<input type="hidden" name="startDateEnd" value="<%=startDateEnd %>" >
			</span>
	  	</wea:item>
	  	<wea:item><%=SystemEnv.getHtmlLabelName(15944,user.getLanguage())%>  </wea:item>
	    <wea:item>
	    	<span>
	        	<SELECT  name="datetypeEnd" id="datetypeEnd" onchange="onChangetypeEnd(this)" style="width: 100px;">
				  <option value="" 	<%if(datetypeEnd.equals("")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				  <option value="1" <%if(datetypeEnd.equals("1")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
				  <option value="2" <%if(datetypeEnd.equals("2")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
				  <option value="3" <%if(datetypeEnd.equals("3")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
				  <option value="4" <%if(datetypeEnd.equals("4")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
				  <option value="5" <%if(datetypeEnd.equals("5")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
				  <option value="6" <%if(datetypeEnd.equals("6")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
				</SELECT>     
			</span>
        
        	<span id="dateTdEnd" style="margin-left: 10px;padding-top: 5px;">
		    	<BUTTON type="button" class=calendar id=SelectDate onclick=getDate(endDateBeginSpan,endDateBegin)></BUTTON>&nbsp;
				<SPAN id="endDateBeginSpan" ><%=endDateBegin %></SPAN>
				<input type="hidden" name="endDateBegin" value="<%=endDateBegin %>">
				-
				<BUTTON type="button" class=calendar id=SelectDate onclick=getDate(endDateEndSpan,endDateEnd)></BUTTON>&nbsp;
				<SPAN id="endDateEndSpan" ><%=endDateEnd %></SPAN>
				<input type="hidden" name="endDateEnd" value="<%=endDateEnd %>">
			</span>
	    </wea:item>
	 </wea:group>
	    
	 <wea:group context='<%=SystemEnv.getHtmlLabelName(32843,user.getLanguage())%>' attributes="{'itemAreaDisplay':'none'}" >
	  	<wea:item><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></wea:item>
	  	<wea:item>
	  		<brow:browser viewType="0" name="manager" 
	         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
	         browserValue = '<%=manager%>' 
 			 browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(manager),user.getLanguage())%>'
	         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
	         completeUrl="/data.jsp" width="150px" ></brow:browser>
	  	</wea:item>
	  	<wea:item><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
	  	<wea:item>
	  		<brow:browser viewType="0" name="managerDepartment" 
	         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
	         browserValue = '<%=managerDepartment%>' 
 			 browserSpanValue='<%=Util.toScreen(DepartmentComInfo.getDepartmentname(managerDepartment),user.getLanguage())%>'
	         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
	         completeUrl="/data.jsp?type=57" width="150px" ></brow:browser>
	  	</wea:item>
	  	<wea:item><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
	    <wea:item>
	    	<brow:browser viewType="0" name="managerSubCompany" 
	         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
	         browserValue = '<%=managerSubCompany%>' 
 			 browserSpanValue='<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(managerSubCompany),user.getLanguage())%>'
	         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
	         completeUrl="/data.jsp?type=164" width="150px" ></brow:browser>
	    </wea:item>
	  
	  	<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></wea:item>
	  	<wea:item>
	  		<brow:browser viewType="0" name="creater" 
	         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
	         browserValue = '<%=creater%>' 
 			 browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(creater),user.getLanguage())%>'
	         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
	         completeUrl="/data.jsp" width="150px" ></brow:browser>
	  	</wea:item>
	  	<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
	  	<wea:item>
	  		<brow:browser viewType="0" name="createrDepartment" 
	         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
	         browserValue = '<%=createrDepartment%>' 
 			 browserSpanValue='<%=Util.toScreen(DepartmentComInfo.getDepartmentname(createrDepartment),user.getLanguage())%>'
	         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
	         completeUrl="/data.jsp?type=57" width="150px" ></brow:browser>
	  	</wea:item>
	  	<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
	    <wea:item>
	    	<brow:browser viewType="0" name="createrSubCompany" 
	         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
	         browserValue = '<%=createrSubCompany%>' 
 			 browserSpanValue='<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(createrSubCompany),user.getLanguage())%>'
	         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
	         completeUrl="/data.jsp?type=164" width="150px" ></brow:browser>
	    </wea:item>
	</wea:group>
	
	<wea:group context="" attributes="{'Display':'none'}">
		<wea:item type="toolbar">
			<input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(82529,user.getLanguage())%>" id="searchBtn"/>
			<input type="button" onclick="resetCondition()" value="<%=SystemEnv.getHtmlLabelName(2022 ,user.getLanguage()) %>" class="e8_btn_cancel" onclick="resetCondtion();"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
</wea:layout>

</form>
</div>


<%
    String tableString = "";
	String backfields = " t1.id,t1.name,t1.TypeId,t1.price,t1.status,t1.manager,t1.startDate,t1.crmid ";
	String fromSql  = " CRM_Contract t1 left join "+ContacterShareBase.getTempTable(user.getUID()+"")+" t2 on t1.id = t2.relateditemid" ;
	String sqlWhere = " t1.id = t2.relateditemid and crmId="+CustomerID+childWhere;
	String orderby = "";
    tableString = " <table pageId=\""+PageIdConst.CRM_ContractList+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_ContractList,user.getUID(),PageIdConst.CRM)+"\" tabletype=\"checkbox\">"+
				  " <sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\"/>"+
                  " <checkboxpopedom showmethod=\"weaver.crm.report.CRMContractTransMethod.getContractCheckInfo\" popedompara=\"column:status\"  />"+
	              " <head>"+
	              " <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"id\" orderkey=\"name\" transmethod=\"weaver.crm.report.CRMContractTransMethod.getContractName\" otherpara=\"column:crmid\"/>"+
	              "	<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(6083,user.getLanguage())+"\" column=\"TypeId\" orderkey=\"TypeId\" transmethod=\"weaver.crm.Maint.CRMTransMethod.getContractTypeName\"/>"+
	              "	<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(614,user.getLanguage())+SystemEnv.getHtmlLabelName(534,user.getLanguage())+"\" column=\"price\" orderkey=\"price\"/>"+
	              "	<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"status\" orderkey=\"status\" otherpara='"+user.getLanguage()+"' transmethod=\"weaver.crm.Maint.CRMTransMethod.getContractStatus\"/>"+
	              "	<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(2097,user.getLanguage())+"\" column=\"manager\" orderkey=\"manager\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getLastname\"/>"+
	              "	<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(1970,user.getLanguage())+"\" column=\"startDate\" orderkey=\"startDate\"/>"+
	 			  "	</head>"+
	 			  "<operates width=\"15%\">"+
	 			  " <popedom transmethod=\"weaver.crm.report.CRMContractTransMethod.getContractOpratePopedomCustomer\"  otherpara=\"column:status+"+user.getUID()+"\"></popedom> "+
	 			 	"     <operate  href=\"javascript:editInfo()\" otherpara=\"column:crmid\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\"  index=\"0\"/>"+
	 				"     <operate  href=\"javascript:approveInfo()\" otherpara=\"column:crmId\" text=\""+SystemEnv.getHtmlLabelName(15143,user.getLanguage())+"\" target=\"_fullwindow\"  index=\"1\"/>"+
	 				"     <operate  href=\"javascript:signInfo()\" otherpara=\"column:crmId\" text=\""+SystemEnv.getHtmlLabelName(6095,user.getLanguage())+"\" target=\"_fullwindow\"  index=\"2\"/>"+
	 				"     <operate  href=\"javascript:execute()\" otherpara=\"column:crmId\" text=\""+SystemEnv.getHtmlLabelName(15144,user.getLanguage())+"\" target=\"_self\"  index=\"3\"/>"+
	 				"     <operate  href=\"javascript:doView(0)\" otherpara=\"column:crmId\" text=\""+SystemEnv.getHtmlLabelName(360,user.getLanguage())+"\" target=\"_fullwindow\"  index=\"4\"/>"+
	 				"     <operate  href=\"javascript:doView(1)\" otherpara=\"column:crmId\" text=\""+SystemEnv.getHtmlLabelName(15153,user.getLanguage())+"\" target=\"_fullwindow\"  index=\"5\"/>"+
	 				"     <operate  href=\"javascript:doView(2)\" otherpara=\"column:crmId\" text=\""+SystemEnv.getHtmlLabelName(2112,user.getLanguage())+"\" target=\"_fullwindow\"  index=\"6\"/>"+
	 				"     <operate  href=\"javascript:doDelete()\" otherpara=\"column:crmId\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\"  index=\"7\"/>"+
			      "</operates>"+
	 			  "</table>";
  %>
  	<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.CRM_ContractList%>">
	<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY>

<script type="text/javascript">
var diag = null;

function closeDialog(){
	if(diag)
		diag.close();
	_table.reLoad();
}

function refreshInfo(){
	_table.reLoad();
}
function getDialog(title,width,height){
    diag =new window.top.Dialog();
    diag.currentWindow = window; 
    diag.Modal = true;
    diag.Drag=true;
	diag.Width =width?width:680;
	diag.Height =height?height:420;
	diag.Title = title;
	return diag;
} 


function resetCondtion(){
	document.getElementById("weaver").reset();
	jQuery("select").find("option[value='']").attr("selected",true); 
	jQuery("input[name='startDateBegin']").val("");
	jQuery("input[name='startDateEnd']").val("");
	jQuery("input[name='endDateBegin']").val("");
	jQuery("input[name='endDateEnd']").val("");
	jQuery("span[id='startDateBeginSpan']").html("");
	jQuery("span[id='startDateEndSpan']").html("");
	jQuery("span[id='endDateBeginSpan']").html("");
	jQuery("span[id='endDateEndSpan']").html("");
}

$(document).ready(function(){
	$("#topTitle").topMenuTitle({searchFn:searchName});
	$("#hoverBtnSpan").hoverBtn();
	if("<%=datetypeStart%>" == 6){
		jQuery("#dateTdStart").show();
	}else{
		jQuery("#dateTdStart").hide();
	}
	if("<%=datetypeEnd%>" == 6){
		jQuery("#dateTdEnd").show();
	}else{
		jQuery("#dateTdEnd").hide();
	}				
});

function onChangetypeStart(obj){
	if(obj.value == 6){
		jQuery("#dateTdStart").show();
	}else{
		jQuery("#dateTdStart").hide();
	}
}

function onChangetypeEnd(obj){
	if(obj.value == 6){
		jQuery("#dateTdEnd").show();
	}else{
		jQuery("#dateTdEnd").hide();
	}
}
function searchName(){
	var name =$(".searchInput").val();
	jQuery("#name").val(name);
	$("#weaver").submit();
}

function searchSubject(){
	var searchSubject = jQuery("#searchSubject").val();
	window.frmmain.action = "/CRM/data/ContractList.jsp?&name="+encodeURI(searchSubject);
	window.frmmain.submit();
}


function doView(type , contractId){
	if(type == 0){
	 	type = "info";
	}else{
		type = type==1?"contact":"share";
	}
	var diag =getDialog("<%=SystemEnv.getHtmlLabelNames("367,34244",user.getLanguage())%>",1000,600);
	diag.URL = "/CRM/data/ContractViewTab.jsp?type="+type+"&id="+contractId+"&"+new Date().getTime();
	diag.ShowButtonRow=false;
	diag.show();
	document.body.click();

}

function doAdd(obj){
	diag =getDialog("<%=SystemEnv.getHtmlLabelNames("82,34244",user.getLanguage())%>",1000,600);
	diag.URL = '/CRM/data/ContractAdd.jsp?CustomerID=<%=CustomerID%>';
	diag.show();
	document.body.click();
}

function editInfo(contractId ,customerid){
	diag =getDialog("<%=SystemEnv.getHtmlLabelNames("93,34244",user.getLanguage())%>",1000,600);
	diag.URL = "/CRM/data/ContractEdit.jsp?isfromtab=false&contractId="+contractId+"&CustomerID="+customerid+"&"+new Date().getTime();
	diag.ShowButtonRow=false;
	diag.show();
	document.body.click();
}
function showInfo(contractId){
	diag =getDialog("<%=SystemEnv.getHtmlLabelNames("367,34244",user.getLanguage())%>",1000,600);
	diag.URL = "/CRM/data/ContractView.jsp?isfromtab=false&id="+contractId+"&"+new Date().getTime();
	diag.ShowButtonRow=false;
	diag.show();
	document.body.click();
}

function approveInfo(contractId ,customerid){
	jQuery.post("/CRM/data/ContractOperation.jsp",{"method":"approve","contractId":contractId,"crmId":customerid},function(){
		_table.reLoad();
	});
}
function signInfo(contractId ,customerid){
	jQuery.post("/CRM/data/ContractOperation.jsp",{"method":"isCustomerCheck","contractId":contractId,"crmId":customerid},function(){
		_table.reLoad();
	});
}
function doDelete(contractId ,customerid){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>",function(){
	    jQuery.post("/CRM/data/ContractOperation.jsp",{"method":"deleteContract","contractId":contractId,"crmId":customerid},function(){
	        _table.reLoad();
	    });
	});
}

function comeBack(customerID){
	if(parent){
		location="/CRM/data/ViewCustomerTotal.jsp?CustomerID="+customerID;
	}else{
		location="/CRM/data/ViewCustomer.jsp?CustomerID="+customerID;
	}
}


//执行完成
function execute(contractId ,customerid){
	jQuery.post("/CRM/data/ContractOperation.jsp?method=isSuccess",{"crmId":customerid,"contractId":contractId});
	_table.reLoad();
}
function deleteInfos(){
    var contractIds = _xtable_CheckedCheckboxId();
    if("" == contractIds){
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22000,user.getLanguage())%>");
        return;
    }
    window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>",function(){
        jQuery.post("/CRM/data/ContractOperation.jsp",{"contractIds":contractIds,"method":"batchDel"},function(){
            _table.reLoad();
        });
    });
    
}
</script>
</HTML>
