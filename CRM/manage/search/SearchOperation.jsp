
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>


<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="CRMSearchComInfo" class="weaver.crm.search.SearchComInfo" scope="session" />


<%
/*在report页面下相关操做*/
	String settype=Util.null2String(request.getParameter("settype"));
	String customercity=Util.null2String(request.getParameter("customercity"));//从AddressReSum.jsp页面取得值
	if(settype.equals("customercity")) //在report页面下选地理分布时
	{
		CRMSearchComInfo.setCustomerCity(customercity);//在Bean中setCustomerCity
    //perpage数据由CRM_Customize表读取，此处不必传入  modify by xhheng @20050118 for TD 1345
		response.sendRedirect("/CRM/search/SearchResult.jsp?pagenum=1");
		return;
	}
CRMSearchComInfo.resetSearchInfo();
String msg=Util.null2String(request.getParameter("msg"));
if(msg.equals("report")){
	String id=Util.null2String(request.getParameter("id"));
	if(settype.equals("contactway")){
		CRMSearchComInfo.setContactWay(id);
		response.sendRedirect("/CRM/search/SearchResult.jsp?pagenum=1");
		return;
	}
	if(settype.equals("customersize")){
		CRMSearchComInfo.setCustomerSize(id);
		response.sendRedirect("/CRM/search/SearchResult.jsp?pagenum=1");
		return;
	}
	if(settype.equals("customertype")){
		CRMSearchComInfo.addCustomerType(id);
		response.sendRedirect("/CRM/search/SearchResult.jsp?pagenum=1");
		return;
	}
	if(settype.equals("customerdesc")){
		CRMSearchComInfo.setCustomerDesc(id);
		response.sendRedirect("/CRM/search/SearchResult.jsp?pagenum=1");
		return;
	}
	if(settype.equals("customerstatus")){
		CRMSearchComInfo.setCustomerStatus(id);
		response.sendRedirect("/CRM/search/SearchResult.jsp?pagenum=1");
		return;
	}
	if(settype.equals("paymentterm")){
		CRMSearchComInfo.setPaymentTerm(id);
		response.sendRedirect("/CRM/search/SearchResult.jsp?pagenum=1");
		return;
	}
	if(settype.equals("customerrating")){
		CRMSearchComInfo.setCustomerRating(id);
		response.sendRedirect("/CRM/search/SearchResult.jsp?pagenum=1");
		return;
	}
	if(settype.equals("creditinfo")){
		CRMSearchComInfo.setCreditLevel(id);

		response.sendRedirect("/CRM/search/SearchResult.jsp?pagenum=1");
		return;
	}
	if(settype.equals("tradeinfo")){
		CRMSearchComInfo.setContractLevel(id);
		response.sendRedirect("/CRM/search/SearchResult.jsp?pagenum=1");
		return;
	}
	if(settype.equals("manager")){
		CRMSearchComInfo.setAccountManager(id);
		response.sendRedirect("/CRM/search/SearchResult.jsp?pagenum=1");
		return;
	}
	if(settype.equals("department")){
		CRMSearchComInfo.setCustomerDept(id);
		response.sendRedirect("/CRM/search/SearchResult.jsp?pagenum=1");
		return;
	}
	if(settype.equals("sectorinfo")){
		CRMSearchComInfo.setCustomerSector(id);
		response.sendRedirect("/CRM/search/SearchResult.jsp?pagenum=1");
		return;
	}
	if(settype.equals("city")){
		CRMSearchComInfo.setCustomerCity(id);
		response.sendRedirect("/CRM/search/SearchResult.jsp?pagenum=1");
		return;
	}
	if(settype.equals("province")){
		CRMSearchComInfo.setCustomerProvince(id);
		response.sendRedirect("/CRM/search/SearchResult.jsp?pagenum=1");
		return;
	}
/*返回到一个出错页面，待定义*/
	response.sendRedirect("/notice/noright.jsp");
	return;
}


String actionKey = Util.null2String(request.getParameter("actionKey"));
String destination = Util.null2String(request.getParameter("destination"));
String searchtype = Util.null2String(request.getParameter("searchtype"));
CRMSearchComInfo.setSearchtype(searchtype);

if(destination.equals("crmindept"))
{

	CRMSearchComInfo.setCustomerRegion(Util.null2String(request.getParameter("depid")));
	response.sendRedirect("/CRM/search/SearchResult.jsp?pagenum=1");
	return;
}


if(destination.equals("myAccount"))
{
	String resourceid =  Util.null2String(request.getParameter("resourceid"));
	if(resourceid.equals("")) resourceid = "" + user.getUID() ;
	CRMSearchComInfo.setAccountManager(resourceid);
	response.sendRedirect("/CRM/search/SearchResult.jsp?pagenum=1&destination=myAccount");
	return;
}

CRMSearchComInfo.setCustomerName(Util.null2String(request.getParameter("CustomerName")));
if(destination.equals("QuickSearch"))
{
	response.sendRedirect("/CRM/search/SearchResult.jsp?pagenum=1");
	return;
}

String CustomerTypes[]=request.getParameterValues("CustomerTypes");
if(CustomerTypes != null)
{
	for(int i=0;i<CustomerTypes.length;i++)
	{
		CRMSearchComInfo.addCustomerType(CustomerTypes[i]);
	}
}

/*Modify by 杨国生 2004-10-25 For TD1259*/
CRMSearchComInfo.setCustomerCode(Util.null2String(request.getParameter("CustomerCode")));
CRMSearchComInfo.setCustomerCity(Util.null2String(request.getParameter("CustomerCity")));
CRMSearchComInfo.setCustomerProvince(Util.null2String(request.getParameter("CustomerProvince")));
CRMSearchComInfo.setCustomerCountry(Util.null2String(request.getParameter("CustomerCountry")));
CRMSearchComInfo.setCustomerRegion(Util.null2String(request.getParameter("CustomerRegion")));
CRMSearchComInfo.setCustomerSector(Util.null2String(request.getParameter("CustomerSector")));
CRMSearchComInfo.setCustomerDesc(Util.null2String(request.getParameter("CustomerDesc")));
CRMSearchComInfo.setContacterFirstName(Util.null2String(request.getParameter("ContacterFirstName")));
CRMSearchComInfo.setContacterLastName(Util.null2String(request.getParameter("ContacterLastName")));
CRMSearchComInfo.setContacterAge(Util.null2String(request.getParameter("age")));
CRMSearchComInfo.setContacterAgeTo(Util.null2String(request.getParameter("ageTo")));
CRMSearchComInfo.setContacterIDCard(Util.null2String(request.getParameter("IDCard")));
CRMSearchComInfo.setCustomerStatus(Util.null2String(request.getParameter("CustomerStatus")));
CRMSearchComInfo.setAccountManager(Util.null2String(request.getParameter("AccountManager")));
CRMSearchComInfo.setContactWay(Util.null2String(request.getParameter("ContactWay")));
CRMSearchComInfo.setCustomerSize(Util.null2String(request.getParameter("CustomerSize")));
CRMSearchComInfo.setCustomerOrigin(Util.null2String(request.getParameter("CustomerOrigin")));
CRMSearchComInfo.setFromDate(Util.null2String(request.getParameter("fromdate")));
CRMSearchComInfo.setEndDate(Util.null2String(request.getParameter("enddate")));
CRMSearchComInfo.setPrjID(Util.null2String(request.getParameter("PrjID")));
CRMSearchComInfo.setFirstNameDesc(Util.null2String(request.getParameter("FirstNameDesc")));
CRMSearchComInfo.setLastNameDesc(Util.null2String(request.getParameter("LastNameDesc")));

CRMSearchComInfo.setDebtorNumber(Util.null2String(request.getParameter("DebtorNumber")));
CRMSearchComInfo.setWebAccess(Util.null2String(request.getParameter("WebAccess")));
CRMSearchComInfo.setCreditorNumber(Util.null2String(request.getParameter("CreditorNumber")));

CRMSearchComInfo.setCustomerAddress1(Util.null2String(request.getParameter("CustomerAddress1")));
CRMSearchComInfo.setCustomerRating(Util.null2String(request.getParameter("CustomerRating")));
CRMSearchComInfo.setCustomerPostcode(Util.null2String(request.getParameter("CustomerPostcode")));
CRMSearchComInfo.setCustomerTelephone(Util.null2String(request.getParameter("CustomerTelephone")));
CRMSearchComInfo.setCustomerParent(Util.null2String(request.getParameter("CustomerParent")));
CRMSearchComInfo.setContacterManager(Util.null2String(request.getParameter("ContacterManager")));

CRMSearchComInfo.setContacterEmail(Util.null2String(request.getParameter("ContacterEmail")));
CRMSearchComInfo.setCustomerCreater(Util.null2String(request.getParameter("CustomerCreater")));
CRMSearchComInfo.setCustomerModifier(Util.null2String(request.getParameter("CustomerModifier")));

CRMSearchComInfo.setContacterAge(Util.null2String(request.getParameter("age")));
CRMSearchComInfo.setContacterAgeTo(Util.null2String(request.getParameter("ageTo")));
CRMSearchComInfo.setContacterIDCard(Util.null2String(request.getParameter("IDCard")));

CRMSearchComInfo.setTypeFrom(Util.null2String(request.getParameter("TypeFrom")));
CRMSearchComInfo.setTypeTo(Util.null2String(request.getParameter("TypeTo")));
CRMSearchComInfo.setStatusFrom(Util.null2String(request.getParameter("StatusFrom")));
CRMSearchComInfo.setStatusTo(Util.null2String(request.getParameter("StatusTo")));
CRMSearchComInfo.setCustomerCounty(Util.null2String(request.getParameter("citytwoCode")));


CRMSearchComInfo.setActionKey(actionKey);// add by xwj 2005-03-10  td:1546

if(destination.equals("toSimple"))
{
	response.sendRedirect("/CRM/search/SearchSimple.jsp?actionKey=" + actionKey);
	return;
}
if(destination.equals("toAdvanced"))
{
	response.sendRedirect("/CRM/search/SearchAdvanced.jsp?actionKey=" + actionKey);
	return;
}

/**增加联系记录相关查询条件  edited by 丁坤宇 2011-10-31 TD:16057*/
String invalid = Util.fromScreen3(request.getParameter("invalid"), user.getLanguage());
String isContact = Util.fromScreen3(request.getParameter("isContact"), user.getLanguage());
String contactDateFrom = Util.null2String(request.getParameter("contactDateFrom"));
String contactDateTo = Util.null2String(request.getParameter("contactDateTo"));
String noContactFrom = Util.null2String(request.getParameter("noContactFrom"));
String noContactTo = Util.null2String(request.getParameter("noContactTo"));
String ContacterMobile = Util.null2String(request.getParameter("ContacterMobile"));
String contact_sql = "";
if(!invalid.equals("")){
	contact_sql += " and "+(invalid.equals("1")?"":"not")+" exists (select 1 from CRM_ContactSetting cs where cs.customerId=t1.id and cs.invalid=1) ";
}
if(isContact.equals("0")){
	contact_sql += " and not exists (select 1 from CRM_ContactSetting cs where cs.customerId=t1.id and cs.isContact=1) ";
}else if(isContact.equals("1")){
	contact_sql += " and exists (select 1 from CRM_ContactSetting cs where cs.customerId=t1.id and cs.isContact=1";
	if(!contactDateFrom.equals("")){
		contact_sql += " and cs.contactDate >= '"+contactDateFrom+"' ";
	}
	if(!contactDateTo.equals("")){
		contact_sql += " and cs.contactDate <= '"+contactDateTo+"' ";
	}
	contact_sql += ")";
}
if(!noContactFrom.equals("") || !noContactTo.equals("")){
	contact_sql += " and NOT EXISTS " 
				    + " (SELECT a.id FROM WorkPlan a " 
					  + " WHERE a.type_n = '3' and a.crmid = CONVERT(varchar,t1.id) ";
	
	if(!noContactFrom.equals("")){
		contact_sql += " AND a.begindate>='"+noContactFrom+"'";
	}
	if(!noContactTo.equals("")){
		contact_sql += " AND a.begindate<='"+noContactTo+"'";
	}
	contact_sql += ")";
}
if(!ContacterMobile.equals("")){
	contact_sql += " and exists (select 1 from CRM_CustomerContacter cc where cc.customerid=t1.id and cc.mobilephone like '%"+ContacterMobile+"%')";
}
String crmcode = Util.fromScreen3(request.getParameter("crmcode"), user.getLanguage());
String othername = Util.fromScreen3(request.getParameter("othername"), user.getLanguage());
String signname = Util.fromScreen3(request.getParameter("signname"), user.getLanguage());
String allname = Util.fromScreen3(request.getParameter("allname"), user.getLanguage());
if(!crmcode.equals("")){
	contact_sql += " and t1.crmcode like '%"+crmcode+"%'";
}
if(!othername.equals("")){
	contact_sql += " and exists (select 1 from CRM_OtherName oname where oname.customerid=t1.id and oname.nametype=1 and oname.customername like '%"+othername+"%')";
}
if(!signname.equals("")){
	contact_sql += " and exists (select 1 from CRM_OtherName oname where oname.customerid=t1.id and oname.nametype=2 and oname.customername like '%"+signname+"%')";
}
if(!allname.equals("")){
	contact_sql += " and (t1.name like '%"+allname+"%'"
		+" or exists (select 1 from CRM_OtherName oname where oname.customerid=t1.id and (oname.nametype=1 or oname.nametype=2) and oname.customername like '%"+allname+"%'))";
}

/**增加省份和城市的多查询条件，此处只用于地图报表查询使用*/
String provinceIds = Util.fromScreen3(request.getParameter("provinceIds"), user.getLanguage());
String cityIds = Util.fromScreen3(request.getParameter("cityIds"), user.getLanguage());
String createdatefrom = Util.fromScreen3(request.getParameter("createdatefrom"), user.getLanguage());
String createdateto = Util.fromScreen3(request.getParameter("createdateto"), user.getLanguage());
String othersql = Util.fromScreen3(request.getParameter("othersql"), user.getLanguage());
String map_sql = "";
if(!createdatefrom.equals("")){
	map_sql += " and t1.createdate>='"+createdatefrom+"'";
	map_sql += " and t1.createdate<='"+createdateto+"'";//有开始日期则一定有结束日期
	if(!provinceIds.equals("") && !cityIds.equals("")){
		map_sql += " and (exists(select 1 from HrmCity c where t1.city=c.id and c.provinceid in ("+provinceIds+")) or t1.city in ("+cityIds+")) ";
	}else{
		if(!provinceIds.equals("")){
			map_sql += " and exists(select 1 from HrmCity c where t1.city=c.id and c.provinceid in ("+provinceIds+"))";
		}else if(!cityIds.equals("")){
			map_sql += " and t1.city in ("+cityIds+") ";
		}else{
			map_sql += " and t1.city<>0 and t1.city is not null";
			map_sql += " and exists(select 1 from HrmProvince p,HrmCity c where p.countryid=1 and p.id=c.provinceid and t1.city=c.id)";
		}
	}
}
if(!othersql.equals("")) map_sql += othersql;


/*--edited by 徐蔚绛 2005-03-09 TD:1546--*/
if(searchtype.equals("simple") || searchtype.equals("advanced"))
{
	
	if(actionKey.equals("batchShare")){
		String iscs = Util.null2String(request.getParameter("iscs"));
		if("1".equals(iscs)){
			contact_sql += " and EXISTS (select cp.id from CS_CustomerPrincipal cp where cp.customerId=t1.id) ";
		}else if("0".equals(iscs)){
			contact_sql += " and not EXISTS (select cp.id from CS_CustomerPrincipal cp where cp.customerId=t1.id) ";
		}
		request.getSession().setAttribute("CRM_SHARE_CONTACTSQL",contact_sql);
		response.sendRedirect("/CRM/data/ShareMutiCustomerList.jsp");
		return;
	}else if(actionKey.equals("batchTransfer")){/**增加批量转移  edited by 丁坤宇 2011-11-02 TD:16057*/
		request.getSession().setAttribute("CRM_TRANSFER_CONTACTSQL",contact_sql);
		response.sendRedirect("/CRM/data/TransferMutiCustomerList.jsp");
		return;
	}else{
		request.getSession().setAttribute("CRM_SEARCH_CONTACTSQL",contact_sql);
		response.sendRedirect("/CRM/search/SearchResult.jsp?pagenum=1");
		return;
	}
    
}
/**
else if(searchtype.equals("advanced")){

  	if(actionKey.equals("batchShare")){
		response.sendRedirect("/CRM/data/ShareMutiCustomerList.jsp");
		return;
	}else{
		response.sendRedirect("/CRM/search/SearchResult.jsp?pagenum=1");
		return;
	}
}*/
//td1761 xwj 2005-05-24
else if(searchtype.equals("baseOnCustomerStatus")){
	request.getSession().setAttribute("CRM_SEARCH_CONTACTSQL",contact_sql);
	response.sendRedirect("/CRM/search/SearchResult.jsp?pagenum=1");
	return;
}

else{
	request.getSession().setAttribute("CRM_SEARCH_CONTACTSQL",contact_sql);
	request.getSession().setAttribute("CRM_SEARCH_MAPSQL",map_sql);
    response.sendRedirect("/CRM/search/SearchResult.jsp?pagenum=1");    
}
   
%>


