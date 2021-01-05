<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="ContacterShareBase" class="weaver.crm.ContacterShareBase" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(15118,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
//add by xwj on 2005-03-25 for TD 1554
RCMenu += "{"+"Excel,javascript:ContractExport(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%
int resource=Util.getIntValue(request.getParameter("viewer"),0);
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getPerpageLog();
if(perpage<=1 )	perpage=10;
String resourcename=ResourceComInfo.getResourcename(resource+"");
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String datetype = Util.null2String(request.getParameter("datetype"));

String customer=Util.fromScreen(request.getParameter("customer"),user.getLanguage());
String status=Util.fromScreen(request.getParameter("status"),user.getLanguage());
String preyield=Util.fromScreen(request.getParameter("preyield"),user.getLanguage());
String product=Util.fromScreen(request.getParameter("product"),user.getLanguage());
String preyield_1=Util.fromScreen(request.getParameter("preyield_1"),user.getLanguage());
String department=Util.fromScreen(request.getParameter("department"),user.getLanguage());
String province=Util.fromScreen(request.getParameter("province"),user.getLanguage());
String city=Util.fromScreen(request.getParameter("city"),user.getLanguage());
int ViewType = Util.getIntValue(request.getParameter("ViewType"),0);//0为按照时间查询，1为按照人力资源查询
String parentid=Util.fromScreen(request.getParameter("parentid"),user.getLanguage());


//out.print(customer);
String sqlwhere= "t1.id != 0";
if(!parentid.equals("")){
	sqlwhere+=" and t4.parentid="+parentid;
}
if(resource!=0){
	sqlwhere+=" and t1.manager="+resource;
}
if(!"".equals(datetype) && !"6".equals(datetype)){
	sqlwhere += " and t3.planDate >= '"+TimeUtil.getDateByOption(datetype+"","0")+"'";
	sqlwhere += " and t3.planDate <= '"+TimeUtil.getDateByOption(datetype+"","")+"'";
}
if("6".equals(datetype) && !fromdate.equals("")){
	sqlwhere+=" and t3.planDate>='"+fromdate+"'";
}
if("6".equals(datetype) && !enddate.equals("")){
	sqlwhere+=" and t3.planDate<='"+enddate+"'";
}

if(!customer.equals("")){
	sqlwhere+=" and t1.crmId="+customer;
}

if(!preyield.equals("")){
	sqlwhere+=" and t3.sumPrice>="+preyield;
}
if(!preyield_1.equals("")){
	sqlwhere+=" and t3.sumPrice<="+preyield_1;
}

if(!product.equals("")){
	sqlwhere+=" and t3.productId ="+product;
}

if(!department.equals("")) {
	sqlwhere+=" and t4.department="+department;
}

if(!province.equals("")){
	sqlwhere+=" and t4.province="+province;
}
if(!city.equals("")){
	sqlwhere+=" and t4.city="+city;
}

String orderStr = "";
if (ViewType == 0 ) {orderStr = "  t3.id  ";}
if (ViewType == 1 ) {orderStr = "  t1.manager  ";}

session.setAttribute("sqlwhere",sqlwhere);
session.setAttribute("orderStr",orderStr);


%>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="ContractExport()" type="button"  value="<%=SystemEnv.getHtmlLabelName(28343,user.getLanguage()) %>"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>


<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;overflow: auto" >	
<form id=weaver name=frmmain method=post action="ContractProReportChild.jsp">
<input type=hidden id=pagenum name=pagenum value="<%=pagenum%>">
<wea:layout type="4Col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
		<%if(!user.getLogintype().equals("2")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="viewer" 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
				browserValue='<%=resource+""%>' 
				browserSpanValue = '<%=Util.toScreen(resourcename,user.getLanguage())%>'
				isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
				completeUrl="/data.jsp" width="150px" ></brow:browser>
		</wea:item>
		<%}%>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(534,user.getLanguage())%>  </wea:item>
		<wea:item>
			<INPUT class=InputStyle maxLength=50 size=6 id="preyield" name="preyield"    onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield")' value="<%=preyield%>" style="width: 80px;">
			-
			<INPUT class=InputStyle maxLength=50 size=6 id="preyield_1" name="preyield_1"   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield_1")' value="<%=preyield_1%>" style="width: 80px;">
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(15115,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="product" 
			browserUrl="/systeminfo/BrowserMain.jsp?url=/lgc/search/LgcProductBrowser.jsp"
			browserValue='<%=product+""%>' 
			browserSpanValue = '<%=Util.toScreen(AssetComInfo.getAssetName(product),user.getLanguage())%>'
			isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			completeUrl="/data.jsp?type=product" width="150px" ></brow:browser>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="customer" 
			browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
			browserValue='<%=customer+""%>' 
			browserSpanValue = '<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(customer),user.getLanguage())%>'
			isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			completeUrl="/data.jsp?type=7" width="150px" ></brow:browser>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(1050,user.getLanguage())%></wea:item>
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
				<BUTTON type=button class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
				<SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
				<input type="hidden" name="fromdate" value=<%=fromdate%>>
				－
				<BUTTON type=button class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
				<SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
				<input type="hidden" name="enddate" value=<%=enddate%>>  
			</span>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="department" 
			browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
			browserValue='<%=department+""%>' 
			browserSpanValue = '<%=Util.toScreen(DepartmentComInfo.getDepartmentname(department),user.getLanguage())%>'
			isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			completeUrl="/data.jsp?type=4" width="150px" ></brow:browser>
		</wea:item>
		
		<wea:item> <%=SystemEnv.getHtmlLabelName(643,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="province" 
			browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/province/ProvinceBrowser.jsp"
			browserValue='<%=province+""%>' 
			browserSpanValue = '<%=ProvinceComInfo.getProvincename(province)%>'
			isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			completeUrl="/data.jsp?type=2222" width="150px" ></brow:browser>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></wea:item>
		<wea:item>  
			<brow:browser viewType="0" name="city" 
			browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp"
			browserValue='<%=city+""%>' 
			browserSpanValue = '<%=CityComInfo.getCityname(city)%>'
			isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			completeUrl="/data.jsp?type=58" width="150px" ></brow:browser>
		</wea:item> 
		
		<wea:item><%=SystemEnv.getHtmlLabelName(455,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></wea:item>
		<wea:item>
			<select  class=InputStyle size="1" name="ViewType">
				<option value="0" <%if (ViewType==0) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></option>
				<option value="1" <%if (ViewType==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
			</select>
		</wea:item>
		
		<wea:item> <%=SystemEnv.getHtmlLabelName(591,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="parentid" 
			browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
			browserValue='<%=parentid+""%>' 
			browserSpanValue = '<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(parentid),user.getLanguage())%>'
			isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			completeUrl="/data.jsp?type=7" width="150px" ></brow:browser>
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

String  backfields  =  "t3.id, t3.productId, t3.number_n ,t3.factnumber_n , t3.planDate, t3.sumPrice , t1.name , t1.crmId,t1.manager";     
String  fromSql=" CRM_Contract  t1,"+ContacterShareBase.getTempTable(user.getUID()+"")+"  t2 , CRM_ContractProduct t3,CRM_CustomerInfo  t4 ";
sqlwhere = sqlwhere +"  and t1.id = t2.relateditemid  and t1.crmId = t4.id and t3.contractId = t1.id ";
String  orderby  =  orderStr;
if(!user.getLogintype().equals("1")){
	fromSql = "CRM_Contract t1 , CRM_ContractProduct t3,CRM_CustomerInfo  t4 ";
	sqlwhere  = sqlwhere +"  and t1.crmId = t4.id and t3.contractId = t1.id and t1.crmId="+user.getUID();
}
if(ViewType == 1){
	String managerBackFields = "null as id , null as productId , null as number_n ,null as factnumber_n , null as planDate ,"+
		" null as  sumPrice , null as  name , null as  crmId  , t1.manager ";
	String dataBackfields = "t3.id, t3.productId, t3.number_n ,t3.factnumber_n , t3.planDate, t3.sumPrice , t1.name , t1.crmId,t1.manager" ;
	backfields = "id , productId , number_n ,factnumber_n ,planDate ,sumPrice , name ,crmId ,manager";
	fromSql = " (select distinct "+managerBackFields +" from "+ fromSql+" where "+sqlwhere+
		"	union all select "+dataBackfields+" from "+fromSql+" where "+sqlwhere+") t8";
	sqlwhere = "";
	orderby = " manager , id ";
}


// System.err.println("select "+backfields+" from "+ fromSql+" where "+sqlwhere+" order by "+orderby);

String tableString = null;
if(ViewType == 0){
 	tableString =" <table instanceid=\"info\"  pageId=\""+PageIdConst.CRM_RPContractProduct+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_RPContractProduct,user.getUID(),PageIdConst.CRM)+"\" tabletype=\"none\">"+ 
	"<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  "+
		"sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t3.id\" sqlsortway=\"Desc\"/>"+
	"<head>"+
	"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(6161,user.getLanguage()) +"\" column=\"name\""+ 
		" transmethod=\"weaver.crm.report.CRMReporttTransMethod.getContractName\" otherpara=\"column:crmId+column:productId+column:manager\"/>"+ 
	"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(15115,user.getLanguage()) +"\" column=\"productId\""+
		" transmethod =\"weaver.lgc.asset.AssetComInfo.getAssetName\""+
		" href=\"/lgc/asset/LgcAsset.jsp\" linkkey=\"paraid\" linkvaluecolumn=\"productId\" target=\"_blank\"/>"+ 
	"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(15228,user.getLanguage()) +"\" column=\"number_n\"/>"+ 
	"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(15229,user.getLanguage()) +"\" column=\"factnumber_n\"/>"+ 
	"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(15230,user.getLanguage()) +"\" column=\"number_n\""+
		" transmethod=\"weaver.crm.report.CRMReporttTransMethod.getContractUnreceive\" otherpara=\"column:factnumber_n\" />"+ 
	"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(1050,user.getLanguage()) +"\" column=\"planDate\"/>"+ 
	"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(534,user.getLanguage()) +"\" column=\"sumPrice\"/>"+ 
	"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(1268,user.getLanguage()) +"\" column=\"crmId\""+
		" transmethod=\"weaver.crm.Maint.CustomerInfoComInfo.getCustomerInfoname\""+
		" href=\"/CRM/data/ViewCustomer.jsp\" linkkey=\"CustomerID\" linkvaluecolumn=\"crmId\" target=\"_blank\"/>"+ 	
	"</head>"+   			
	"</table>";
}


if(ViewType == 1){
	tableString =" <table instanceid=\"info\"  pageId=\""+PageIdConst.CRM_RPContractProduct+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_RPContractProduct,user.getUID(),PageIdConst.CRM)+"\" tabletype=\"none\">"+ 
	"<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  "+
		"sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"/>"+
	"<head>"+
	"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(6161,user.getLanguage()) +"\" column=\"name\""+ 
		" transmethod=\"weaver.crm.report.CRMReporttTransMethod.getContractName\" otherpara=\"column:crmId+column:productId+column:manager\"/>"+ 
	"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(15115,user.getLanguage()) +"\" column=\"productId\""+
		" transmethod =\"weaver.lgc.asset.AssetComInfo.getAssetName\""+
		" href=\"/lgc/asset/LgcAsset.jsp\" linkkey=\"paraid\" linkvaluecolumn=\"productId\" target=\"_blank\"/>"+ 
	"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(15228,user.getLanguage()) +"\" column=\"number_n\"/>"+ 
	"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(15229,user.getLanguage()) +"\" column=\"factnumber_n\"/>"+ 
	"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(15230,user.getLanguage()) +"\" column=\"number_n\""+
		" transmethod=\"weaver.crm.report.CRMReporttTransMethod.getContractUnreceive\" otherpara=\"column:factnumber_n\" />"+ 
	"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(1050,user.getLanguage()) +"\" column=\"planDate\"/>"+ 
	"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(534,user.getLanguage()) +"\" column=\"sumPrice\"/>"+ 
	"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(1268,user.getLanguage()) +"\" column=\"crmId\""+
		" transmethod=\"weaver.crm.Maint.CustomerInfoComInfo.getCustomerInfoname\""+
		" href=\"/CRM/data/ViewCustomer.jsp\" linkkey=\"CustomerID\" linkvaluecolumn=\"crmId\" target=\"_blank\"/>"+ 	
	"</head>"+   			
	"</table>";
}
%>
<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.CRM_RPContractProduct%>">
<wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="false"/>




<script language=javascript>

$(document).ready(function(){
	jQuery("#topTitle").topMenuTitle({searchFn:null});
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

function doSearch() {
    document.frmmain.submit();
}


function comparenumber(){
    lownumber = eval(toFloat(document.all("preyield").value,0));
    highnumber = eval(toFloat(document.all("preyield_1").value,0));
}
</SCRIPT>

<iframe id="searchexport" name="searchexport" style="display:none"></iframe>
<script language=javascript>
function ContractExport(){
     _xtable_getAllExcel();;
}
</script>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</body>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
