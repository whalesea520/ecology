
<%@page import="weaver.workflow.browserdatadefinition.ConditionField"%><%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="CustomerDescComInfo" class="weaver.crm.Maint.CustomerDescComInfo" scope="page" />
<jsp:useBean id="CustomerSizeComInfo" class="weaver.crm.Maint.CustomerSizeComInfo" scope="page" />
<jsp:useBean id="SectorInfoComInfo" class="weaver.crm.Maint.SectorInfoComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>

<%

int bdf_wfid = Util.getIntValue(request.getParameter("bdf_wfid"));
int bdf_fieldid = Util.getIntValue(request.getParameter("bdf_fieldid"));
int bdf_viewtype = Util.getIntValue(request.getParameter("bdf_viewtype"));
String selectSecond = Util.null2String(request.getParameter("selectSecond"));
List<ConditionField> list = null;
if(-1 != bdf_wfid){
	list = ConditionField.readAll(bdf_wfid,bdf_fieldid,bdf_viewtype);
}

String name = Util.null2String(request.getParameter("name"));
String crmcode = Util.null2String(request.getParameter("crmcode"));

String type = Util.null2String(request.getParameter("type"));

String city = Util.null2String(request.getParameter("City"));
String country1 = Util.null2String(request.getParameter("country1"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String sqlwhere = "1=1";
String sqlwherep = Util.null2String(request.getParameter("sqlwhere"));
if(sqlwherep.trim().startsWith("where")) {
    sqlwherep = sqlwherep.replace("where"," ");
}
if(!sqlwherep.equals(""))
	sqlwhere+=" and "+sqlwherep;
String crmManager = Util.null2String(request.getParameter("crmManager"));

String sectorInfo = Util.null2String(request.getParameter("sectorInfo"));
String customerStatus = Util.null2String(request.getParameter("customerStatus"));
String customerDesc = Util.null2String(request.getParameter("customerDesc"));
String customerSize = Util.null2String(request.getParameter("customerSize"));
Map hiddenMap = new HashMap();
%>
<BODY scroll="auto">

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:dialog.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
 <jsp:include page="/systeminfo/commonTabHead.jsp">
    <jsp:param name="mouldID" value="customer"/>
    <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(16407,user.getLanguage()) %>"/>
 </jsp:include>
 
 <table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" onclick="document.SearchForm.submit()" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
 
<DIV align=right style="display:none">
	<button type="button" class=btnSearch accessKey=S type=submit onclick="document.SearchForm.submit()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
	<button type="button" class=btnReset accessKey=T type=reset onclick="document.SearchForm.reset()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
	<button type="button" class=btn accessKey=1 onclick="dialog.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
	<button type="button" class=btn accessKey=2 id=btnclear onclick="btnclear_onclick();"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>

<div class="zDialog_div_content">
<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="CustomerBrowser.jsp" method=post>
<input type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
<input type="hidden" name="pagenum" value=''>
<input type="hidden" name="bdf_wfid" value="<%=bdf_wfid %>">
<input type="hidden" name="bdf_fieldid" value="<%=bdf_fieldid %>">
<input type="hidden" name="bdf_viewtype" value="<%=bdf_viewtype %>">
<input type="hidden" name="selectSecond" value="1">

<div style="max-height:155px;overflow:hidden;" id="e8QuerySearchArea">
<wea:layout type="4col" >
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		<%if(null != list && 0 != list.size()){ 
			for(ConditionField conditionField : list){
				String fieldName = conditionField.getFieldName();
				String isMustInput = conditionField.isReadonly()?"0":"1";
				if(!selectSecond.equals("1")){
					String fieldValue = conditionField.getValue();
					if(conditionField.getValueType().equals("3") && conditionField.isGetValueFromFormField()){ 
						fieldValue = Util.null2String(request.getParameter("bdf_"+fieldName));
						fieldValue = fieldValue.split(",")[0];
					}
					if(conditionField.getValueType().equals("1") && fieldName.equals("crmManager")){
						fieldValue = user.getUID()+"";
					}
					if(conditionField.getValueType().equals("1") && fieldName.equals("departmentid")){
						fieldValue = user.getUserDepartment()+"";
					}
					if(conditionField.getValueType().equals("3") && fieldName.equals("departmentid")){//部门选择表单字段为但
						fieldValue = Util.null2String(request.getParameter("bdf_"+fieldName));
						fieldValue = conditionField.getDepartmentIds(fieldValue).split(",")[0];
					}
					
					if(fieldName.equals("name")) name = name.equals("")?fieldValue:name;
					if(fieldName.equals("crmcode")) crmcode = crmcode.equals("")?fieldValue:crmcode;
					if(fieldName.equals("type")) type = type.equals("")?fieldValue:type;
					if(fieldName.equals("customerStatus")) customerStatus = customerStatus.equals("")?fieldValue:customerStatus;
					if(fieldName.equals("country1")) country1 = country1.equals("")?fieldValue:country1;
					if(fieldName.equals("City")) city = city.equals("")?fieldValue:city;
					if(fieldName.equals("crmManager")) crmManager = crmManager.equals("")?fieldValue:crmManager;
					if(fieldName.equals("departmentid")) departmentid = departmentid.equals("")?fieldValue:departmentid;
					if(fieldName.equals("customerDesc")) customerDesc = customerDesc.equals("")?fieldValue:customerDesc;
					if(fieldName.equals("customerSize")) customerSize = customerSize.equals("")?fieldValue:customerSize;
					if(fieldName.equals("sectorInfo")) sectorInfo = sectorInfo.equals("")?fieldValue:sectorInfo;
				}
				
		%>
			
			<%if(fieldName.equals("name")){if(conditionField.isHide()){hiddenMap.put("name",name);continue;}%>
				<wea:item><%=SystemEnv.getHtmlLabelName(1268,user.getLanguage())%></wea:item>
				<wea:item><input class="InputStyle"  name="name" 
					value="<%=name%>" style="width: 120px;"
					<%if(conditionField.isReadonly()) out.println("readonly='readonly'"); %>></wea:item>
					
			<%} else if(fieldName.equals("crmcode")){if(conditionField.isHide()){hiddenMap.put("crmcode",crmcode);continue;}%>
				<wea:item><%=SystemEnv.getHtmlLabelName(17080,user.getLanguage())%></wea:item>
				<wea:item><input class="InputStyle"  name="crmcode" 
					value="<%=conditionField.getValue()%>" style="width: 120px;"
					<%if(conditionField.isReadonly()) out.println("readonly='readonly'"); %>></wea:item>
					
			<%} else if(fieldName.equals("type")){if(conditionField.isHide()){hiddenMap.put("type",type);continue;}%>
				<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="type" 
				        browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerTypeBrowser.jsp"
				        browserValue='<%=type%>' 
				        browserSpanValue='<%=CustomerTypeComInfo.getCustomerTypename(type) %>'
				        isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='<%=isMustInput %>'
				        completeUrl="/data.jsp?type=customerType" width="150px" ></brow:browser>
				</wea:item>
				
			<%} else if(fieldName.equals("customerStatus")){if(conditionField.isHide()){hiddenMap.put("customerStatus",customerStatus);continue;}%>
				<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="customerStatus" 
				        browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp"
				        browserValue='<%=customerStatus%>'
				        browserSpanValue='<%=CustomerStatusComInfo.getCustomerStatusname(customerStatus) %>'
				        isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='<%=isMustInput %>'
				        completeUrl="/data.jsp?type=customerStatus" width="150px" ></brow:browser>
				</wea:item>
				
			<%} else if(fieldName.equals("country1")){if(conditionField.isHide()){hiddenMap.put("country1",country1);continue;}%>
				<wea:item><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="country1" 
				         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp"
				         browserValue='<%=country1 %>' 
				         browserSpanValue = '<%=CountryComInfo.getCountrydesc(country1)%>'
				         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='<%=isMustInput %>'
				         completeUrl="/data.jsp?type=1111" width="150px" ></brow:browser>  
			    </wea:item>
			    
			<%} else if(fieldName.equals("City")){if(conditionField.isHide()){hiddenMap.put("City",city);continue;}%>
				<wea:item><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="City" 
					 browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp"
					 browserValue='<%=city%>' 
					 browserSpanValue = '<%=CityComInfo.getCityname(city)%>'
					 isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='<%=isMustInput %>'
					 completeUrl="/data.jsp?type=58" width="150px" ></brow:browser> 
				</wea:item>
				
			<%} else if(fieldName.equals("crmManager")){if(conditionField.isHide()){hiddenMap.put("crmManager",crmManager);continue;}%>
				 <wea:item><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></wea:item>
		         <wea:item>
		         	<brow:browser viewType="0" name="crmManager" 
				         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
				         browserValue = '<%=crmManager%>' 
				         browserSpanValue='<%=ResourceComInfo.getResourcename(crmManager)%>'
				         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='<%=isMustInput %>'
				         completeUrl="/data.jsp" width="150px" ></brow:browser>
		         </wea:item>
		         
			<%} else if(fieldName.equals("departmentid")){if(conditionField.isHide()){hiddenMap.put("departmentid",departmentid);continue;}%>
				<wea:item><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())+SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="departmentid" 
				         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
				         browserValue = '<%=departmentid%>' 
				         browserSpanValue='<%=DepartmentComInfo.getDepartmentname(departmentid)%>'
				         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='<%=isMustInput %>'
				         completeUrl="/data.jsp?type=4" width="150px" ></brow:browser>
				</wea:item>
				
			<%} else if(fieldName.equals("customerDesc")){if(conditionField.isHide()){hiddenMap.put("customerDesc",customerDesc);continue;}%>
				<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="customerDesc" 
				         browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerDescBrowser.jsp"
				         browserValue = '<%=customerDesc%>' 
				         browserSpanValue='<%=CustomerDescComInfo.getCustomerDescname(customerDesc)%>'
				         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='<%=isMustInput %>'
				         completeUrl="/data.jsp?type=customerDesc" width="150px" ></brow:browser>
				</wea:item>
			<%} else if(fieldName.equals("customerSize")){if(conditionField.isHide()){hiddenMap.put("customerSize",customerSize);continue;}%>
				<wea:item><%=SystemEnv.getHtmlLabelName(576,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="customerSize" 
				         browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerSizeBrowser.jsp"
				         browserValue = '<%=customerSize%>' 
				         browserSpanValue='<%=CustomerSizeComInfo.getCustomerSizename(customerSize)%>'
				         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='<%=isMustInput %>'
				         completeUrl="/data.jsp?type=customerSize" width="150px" ></brow:browser>
				</wea:item>
				
			<%} else if(fieldName.equals("sectorInfo")){if(conditionField.isHide()){hiddenMap.put("sectorInfo",sectorInfo);continue;}%>
				<wea:item><%=SystemEnv.getHtmlLabelName(575,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="sectorInfo" 
				         browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/SectorInfoBrowser.jsp"
				         browserValue = '<%=sectorInfo%>' 
				         browserSpanValue='<%=SectorInfoComInfo.getSectorInfoname(sectorInfo)%>'
				         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='<%=isMustInput %>'
				         completeUrl="/data.jsp?type=sector" width="150px" ></brow:browser>
				</wea:item>
			<%} %>
		<%}}else{ %>
			<wea:item><%=SystemEnv.getHtmlLabelName(1268,user.getLanguage())%></wea:item>
			<wea:item><input class=InputStyle  name=name value='<%=name%>' style="width: 120px;"></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(17080,user.getLanguage())%></wea:item>
			<wea:item>
				<input class=InputStyle  name=crmcode value="<%=crmcode%>" style="width: 120px;">
			</wea:item>
			
			
			<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="type" 
			        browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerTypeBrowser.jsp"
			        browserValue='<%=type%>'
			        browserSpanValue='<%=CustomerTypeComInfo.getCustomerTypename(type) %>'
			        isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			        completeUrl="/data.jsp?type=customerType" width="150px" ></brow:browser>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="customerStatus" 
			        browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp"
			        browserValue='<%=customerStatus%>'
			        browserSpanValue='<%=CustomerStatusComInfo.getCustomerStatusname(customerStatus) %>'
			        isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			        completeUrl="/data.jsp?type=customerStatus" width="150px" ></brow:browser>
			</wea:item>
			
			
			<wea:item><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></wea:item>
			<wea:item>
				 <brow:browser viewType="0" name="country1" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp"
			         browserValue='<%=country1 %>' 
			         browserSpanValue = '<%=CountryComInfo.getCountrydesc(country1)%>'
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			         completeUrl="/data.jsp?type=1111" width="150px" ></brow:browser>  
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="City" 
				 browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp"
				 browserValue='<%=city%>' 
				 browserSpanValue = '<%=CityComInfo.getCityname(city)%>'
				 isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
				 completeUrl="/data.jsp?type=58" width="150px" ></brow:browser> 
			</wea:item>
			
			
			 <wea:item><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></wea:item>
	         <wea:item>
	         	<brow:browser viewType="0" name="crmManager" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			         browserValue = '<%=crmManager%>' 
			         browserSpanValue='<%=ResourceComInfo.getResourcename(crmManager)%>'
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			         completeUrl="/data.jsp" width="150px" ></brow:browser>
	         </wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())+SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="departmentid" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
			         browserValue = '<%=departmentid%>' 
			         browserSpanValue='<%=DepartmentComInfo.getDepartmentname(departmentid)%>'
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			         completeUrl="/data.jsp?type=4" width="150px" ></brow:browser>
			</wea:item>
			
			
			<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="customerDesc" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerDescBrowser.jsp"
			         browserValue = '<%=customerDesc%>' 
			         browserSpanValue='<%=CustomerDescComInfo.getCustomerDescname(customerDesc)%>'
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			         completeUrl="/data.jsp?type=customerDesc" width="150px" ></brow:browser>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(576,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="customerSize" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerSizeBrowser.jsp"
			         browserValue = '<%=customerSize%>' 
			         browserSpanValue='<%=CustomerSizeComInfo.getCustomerSizename(customerSize)%>'
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			         completeUrl="/data.jsp?type=customerSize" width="150px" ></brow:browser>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(575,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="sectorInfo" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/SectorInfoBrowser.jsp"
			         browserValue = '<%=sectorInfo%>' 
			         browserSpanValue='<%=SectorInfoComInfo.getSectorInfoname(sectorInfo)%>'
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			         completeUrl="/data.jsp?type=sector" width="150px" ></brow:browser>
			</wea:item>
		<%} %>
	</wea:group>
</wea:layout>
<%for(Object key : hiddenMap.keySet()){ %>
	<input type="hidden" name="<%=key %>" value="<%=hiddenMap.get(key) %>">
<%} %>
</div>


<%

//if(!"".equals(sqlwhere)){
//	sqlwhere = sqlwhere.replace("where"," and");
//}

if(!name.equals("")){
	sqlwhere += " and t1.name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";
}
if(!crmcode.equals("")){
	sqlwhere += " and t1.crmcode like '%" + Util.fromScreen2(crmcode,user.getLanguage()) +"%' ";
}
if(!type.equals("")){
	if(type.indexOf(',')>-1)
		sqlwhere += " and t1.type in" + type;
	else
		sqlwhere += " and t1.type = "+ type;
}
if(!city.equals("")){
	sqlwhere += " and t1.city = " + city ;
}
if(!country1.equals("")){
	sqlwhere += " and t1.country = "+ country1;
}
if(!departmentid.equals("")){
	sqlwhere += " and t1.department =" + departmentid +" " ;
}
if(!crmManager.equals("")){
	sqlwhere += " and t1.manager =" + crmManager +" " ;
}

if(!sectorInfo.equals("")){
	sqlwhere += " and t1.sector = "+ sectorInfo;
}
if(!customerStatus.equals("")){
	sqlwhere += " and t1.status = "+ customerStatus;
}
if(!customerDesc.equals("")){
	sqlwhere += " and t1.description = "+ customerDesc;
}
if(!customerSize.equals("")){
	sqlwhere += " and t1.size_n = "+ customerSize;
}

sqlwhere += " and t1.id != 0 " ;
String leftjointable = CrmShareBase.getTempTable(""+user.getUID());

String backfields = "t1.id , t1.name , t1.manager , t1.status ,t1.type";

String fromSql =" CRM_CustomerInfo t1";
int pagesize = 10;
if(user.getLogintype().equals("1")){
	fromSql += " left join "+leftjointable+" t2 on t1.id = t2.relateditemid ";
	sqlwhere+=" and t1.deleted<>1 and t1.id = t2.relateditemid ";
}else{
	sqlwhere+=" and t1.deleted<>1 and t1.agent="+user.getUID();
}
sqlwhere = Util.toHtmlForSplitPage(sqlwhere);
String orderby = "t1.id";

String tableString =" <table instanceid='BrowseTable' tabletype='none' pagesize=\""+pagesize+"\">"+ 
"<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+sqlwhere+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\"/>"+
"<head>"+
"<col hide=\"true\" width=\"5%\" text=\"\" column=\"id\"/>"+ 
"<col width=\"45%\"  text=\""+ SystemEnv.getHtmlLabelName(1268,user.getLanguage()) +"\" orderkey=\"name\" column=\"name\"/>"+ 
"<col width=\"20%\"  text=\""+ SystemEnv.getHtmlLabelName(63,user.getLanguage()) +"\" orderkey=\"type\" column=\"type\""+
" transmethod=\"weaver.crm.Maint.CustomerTypeComInfo.getCustomerTypename\"/>"+ 
"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(1278,user.getLanguage()) +"\" orderkey=\"manager\" column=\"manager\""+
	" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\"/>"+ 
"</head>"+   			
"</table>";
%>

<div id="e8resultArea">
	<wea:SplitPageTag tableString='<%=tableString%>'   mode="run" isShowTopInfo="false" />
</div>
</FORM>
</div>


<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" accessKey=2  id=btnclear value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btnclear_onclick()">
				<input type="button" accessKey=1  id=btnclear value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close()">
	   		</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY></HTML>
<script type="text/javascript">
var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}catch(e){}



jQuery(function(){
	
	jQuery(".ListStyle").find("tbody tr").live('click',function(){
		var id = jQuery.trim(jQuery(this).find("td:eq(1)").html());
		var name = jQuery.trim(jQuery(this).find("td:eq(2)").html());
		
		var returnValue = {id:id,name:name};
		if(dialog){
			try{
	            dialog.callback(returnValue);
	      	}catch(e){}
	      	 
		  	try{
		       dialog.close(returnValue);
		   }catch(e){}
		}else{
     		window.parent.parent.returnValue = returnValue;
	 		window.parent.parent.close();
		}
		
	});
});

function btnclear_onclick(){
	var returnValue = {id:"",name:""};
	if(dialog){
		try{
            dialog.callback(returnValue);
       }catch(e){}
	  	try{
	       dialog.close(returnValue);
	   }catch(e){}
	}else{
		window.parent.returnValue = returnValue;
		window.parent.close();
	}
	
}
</script>
