
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

session.setAttribute("serachrmmanager",Util.null2String(request.getParameter("notmanager")));

    response.sendRedirect("/CRM/search/SearchResultCrm.jsp?pagenum=1");    

   
%>


