
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.workflow.browserdatadefinition.ConditionField"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="SectorInfoComInfo" class="weaver.crm.Maint.SectorInfoComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="CustomerDescComInfo" class="weaver.crm.Maint.CustomerDescComInfo" scope="page" />
<jsp:useBean id="CustomerSizeComInfo" class="weaver.crm.Maint.CustomerSizeComInfo" scope="page" />
<jsp:useBean id="RecordSetCT" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>

<style type="text/css">
#departmentid, #country1 {
	width:100%;
}
</style>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/rightspluingForBrowserNew_wev8.js"></script>
<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<%
String name = Util.null2String(request.getParameter("name"));
String crmcode = Util.null2String(request.getParameter("crmcode"));
String type = Util.null2String(request.getParameter("type"));
String city = Util.null2String(request.getParameter("City"));
String country1 = Util.null2String(request.getParameter("country1"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String check_per = Util.null2String(request.getParameter("resourceids"));
String crmManager = Util.null2String(request.getParameter("crmManager"));
String customerStatus = Util.null2String(request.getParameter("customerStatus"));

String sectorInfo = Util.null2String(request.getParameter("sectorInfo"));
String customerDesc = Util.null2String(request.getParameter("customerDesc"));
String customerSize = Util.null2String(request.getParameter("customerSize"));


int bdf_wfid = Util.getIntValue(request.getParameter("bdf_wfid"));
int bdf_fieldid = Util.getIntValue(request.getParameter("bdf_fieldid"));
int bdf_viewtype = Util.getIntValue(request.getParameter("bdf_viewtype"));
String selectSecond = Util.null2String(request.getParameter("selectSecond"));
List<ConditionField> list = null;
if(-1 != bdf_wfid){
	list = ConditionField.readAll(bdf_wfid,bdf_fieldid,bdf_viewtype);
}
Map hiddenMap = new HashMap();
%>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:btnOnSearch(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.weaver.reset(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</HEAD>

<BODY>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(136,user.getLanguage()) %>"/>
</jsp:include>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" onclick="btnOnSearch()" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<div class="zDialog_div_content">
<FORM id=weaver  name=weaver STYLE="margin-bottom:0" action="MutiCustomerBrowser.jsp" method=post onsubmit="btnOnSearch();return false;">
<input type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
<input type="hidden" name="pagenum" value=''>
<input type="hidden" name="resourceids" value="">
<input type="hidden" name="crmManager" value="<%=crmManager%>">
<input type="hidden" name="bdf_wfid" value="<%=bdf_wfid %>">
<input type="hidden" name="bdf_fieldid" value="<%=bdf_fieldid %>">
<input type="hidden" name="bdf_viewtype" value="<%=bdf_viewtype %>">
<input type="hidden" name="selectSecond" value="1">

<div style="overflow: auto;max-height:155px" id="e8QuerySearchArea">
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>' attributes="{'groupSHBtnDisplay':'none'}">
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
</div>
<%for(Object key : hiddenMap.keySet()){ %>
	<input type="hidden" name="<%=key %>" value="<%=hiddenMap.get(key) %>">
<%} %>
<wea:layout type="4col">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item attributes="{'isTableList':'true','colspan':'full'}">
				<div id="dialog">
					<div id='colShow'></div>
				</div>
			</wea:item>
	</wea:group>
</wea:layout>
<div style="width:0px;height:0px;overflow:hidden;">
	<button type="submit"></button>
</div>

</FORM>	
</div>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" class=zd_btn_submit accessKey=O  id=btnok value="O-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"></input>
				<input type="button" class=zd_btn_submit accessKey=2  id=btnclear value="2-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>"></input>
		        <input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"></input>
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</BODY></HTML>

<script type="text/javascript">

var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}catch(e){}

jQuery(document).ready(function(){
 		showMultiDocDialog("<%=check_per%>");
});


function showMultiDocDialog(selectids){
	
	var config = null;
	config= rightsplugingForBrowser.createConfig();
    config.srchead=["<%=SystemEnv.getHtmlLabelName(460,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%>"];
    config.container =$("#colShow");
    config.searchLabel="";
    config.hiddenfield="id";
    config.saveLazy = true;//取消实时保存
    config.saveurl= "/CRM/data/MutiCustomerBrowserAjax.jsp?src=save";
    config.srcurl = "/CRM/data/MutiCustomerBrowserAjax.jsp?src=src";
    config.desturl = "/CRM/data/MutiCustomerBrowserAjax.jsp?src=dest&resourceids=<%=check_per%>";
    config.delteurl="/CRM/data/MutiCustomerBrowserAjax.jsp?src=save";
    config.pagesize = 10;
    config.formId = "weaver";
    config.selectids = selectids;
    config.searchAreaId = "e8QuerySearchArea";
    
	try{
		config.dialog = dialog;
	}catch(e){
	
	}
   	jQuery("#colShow").html("");
    rightsplugingForBrowser.createRightsPluing(config);
    jQuery("#btnok").bind("click",function(){
    	rightsplugingForBrowser.system_btnok_onclick(config);
    });
    jQuery("#btnclear").bind("click",function(){
    	rightsplugingForBrowser.system_btnclear_onclick(config);
    });
    jQuery("#btncancel").bind("click",function(){
    	rightsplugingForBrowser.system_btncancel_onclick(config);
    });
    jQuery("#btnsearch").bind("click",function(){
    	rightsplugingForBrowser.system_btnsearch_onclick(config);
    });
}
function btnOnSearch(){
 jQuery("#btnsearch").trigger("click");
}


var btnok_onclick = function(){
	jQuery("#btnok").click();
}

var btnclear_onclick = function(){
	jQuery("#btnclear").click();
}

function onClose(){
	 if(dialog){
    	dialog.close()
    }else{
	    window.parent.close();
	}
}
</script>

