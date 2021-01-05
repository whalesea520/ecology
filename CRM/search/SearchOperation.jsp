
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>


<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="CRMSearchComInfo" class="weaver.crm.search.SearchComInfo" scope="session" />


<%
/*在report页面下相关操做*/
	
	String msg=Util.null2String(request.getParameter("msg"));
	String settype=Util.null2String(request.getParameter("settype"));//报表类型

	//通过报表查看客户信息，做查询操作【由于报表查询字段可能是未配置的查询字段，会出现获取不到参数值的情况】
	if(msg.equals("report") && CRMSearchComInfo.getMsg().equals("report")
			&& Util.null2String(request.getParameter("id")).equals("")){
		CRMSearchComInfo.setFieldValue("name" , Util.null2String(request.getParameter("name")));	
		response.sendRedirect("/CRM/search/SearchResult.jsp");
		return;
	}
	String customerName = CRMSearchComInfo.getCustomerName();
	CRMSearchComInfo.resetSearchInfo();
	
	CRMSearchComInfo.setMsg(msg);//msg为report表示为报表
	CRMSearchComInfo.setSettype(settype);//报表类型
	CRMSearchComInfo.setSelectType(Util.null2String(request.getParameter("selectType")));//页面查询类型
	
	rs.execute("select fieldhtmltype ,type,fieldname from CRM_CustomerDefinField where usetable = 'CRM_CustomerInfo' and issearch= 1 and isopen=1");
	String fieldName = "";
	String fieldValue = "";
	while(rs.next()){//保存自定义查询字段的参数值
		 fieldName= rs.getString("fieldname");
		 fieldValue = Util.null2String(request.getParameter(fieldName));	
		 CRMSearchComInfo.setFieldValue(fieldName , fieldValue);	
	}
	
	
	//保存自定义查询字段的参数值
	CRMSearchComInfo.setFieldValue("datetype",Util.null2String(request.getParameter("datetype")));
	CRMSearchComInfo.setFieldValue("fromdate",Util.null2String(request.getParameter("fromdate")));
	CRMSearchComInfo.setFieldValue("enddate",Util.null2String(request.getParameter("enddate")));
	CRMSearchComInfo.setFieldValue("province",Util.null2String(request.getParameter("province")));
	CRMSearchComInfo.setFieldValue("rating",Util.null2String(request.getParameter("rating")));
	CRMSearchComInfo.setFieldValue("contractlevel",Util.null2String(request.getParameter("contractlevel")));
	CRMSearchComInfo.setFieldValue("creditlevel",Util.null2String(request.getParameter("creditlevel")));
	CRMSearchComInfo.setFieldValue("PrjID",Util.null2String(request.getParameter("PrjID")));//项目关联客户信息
	CRMSearchComInfo.setFieldValue("department",Util.null2String(request.getParameter("department")));//部门
	
	if(!Util.null2String(customerName).equals("")){//快速查询页面
		CRMSearchComInfo.setFieldValue("name",customerName);
	}
	
	
if(msg.equals("report")){//报表弹出窗口
	String id=Util.null2String(request.getParameter("id"));

	if(settype.equals("contactway")){
		CRMSearchComInfo.setFieldValue("source",id);
		response.sendRedirect("/CRM/search/SearchResult.jsp");
		return;
	}
	if(settype.equals("customersize")){
		CRMSearchComInfo.setFieldValue("size_n",id);
		response.sendRedirect("/CRM/search/SearchResult.jsp");
		return;
	}
	if(settype.equals("customertype")){
		CRMSearchComInfo.setFieldValue("type",id);
		response.sendRedirect("/CRM/search/SearchResult.jsp");
		return;
	}
	if(settype.equals("customerdesc")){
		CRMSearchComInfo.setFieldValue("description",id);
		response.sendRedirect("/CRM/search/SearchResult.jsp");
		return;
	}
	if(settype.equals("customerstatus")){
		CRMSearchComInfo.setFieldValue("status",id);
		response.sendRedirect("/CRM/search/SearchResult.jsp");
		return;
	}
	if(settype.equals("paymentterm")){
		CRMSearchComInfo.setFieldValue("paymentterm",id);
		response.sendRedirect("/CRM/search/SearchResult.jsp");
		return;
	}
	if(settype.equals("customerrating")){
		CRMSearchComInfo.setFieldValue("rating",id);
		response.sendRedirect("/CRM/search/SearchResult.jsp");
		return;
	}
	if(settype.equals("creditinfo")){
		CRMSearchComInfo.setFieldValue("creditlevel",id);
		response.sendRedirect("/CRM/search/SearchResult.jsp");
		return;
	}
	if(settype.equals("tradeinfo")){
		CRMSearchComInfo.setFieldValue("contractlevel",id);
		response.sendRedirect("/CRM/search/SearchResult.jsp");
		return;
	}
	if(settype.equals("manager")){
		CRMSearchComInfo.setFieldValue("manager",id);
		response.sendRedirect("/CRM/search/SearchResult.jsp");
		return;
	}
	if(settype.equals("department")){
		CRMSearchComInfo.setFieldValue("department",id);
		response.sendRedirect("/CRM/search/SearchResult.jsp");
		return;
	}
	if(settype.equals("sectorinfo")){
		CRMSearchComInfo.setFieldValue("sector",id);
		response.sendRedirect("/CRM/search/SearchResult.jsp");
		return;
	}
	if(settype.equals("city")){
		CRMSearchComInfo.setFieldValue("city",id);
		response.sendRedirect("/CRM/search/SearchResult.jsp");
		return;
	}
	if(settype.equals("province")){
		CRMSearchComInfo.setFieldValue("province",id);
		response.sendRedirect("/CRM/search/SearchResult.jsp");
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

if(destination.equals("crmindept")){
	CRMSearchComInfo.setFieldValue("department",Util.null2String(request.getParameter("depid")));
	response.sendRedirect("/CRM/search/SearchResult.jsp");
	return;
}


if(destination.equals("myAccount")){
	String resourceid =  Util.null2String(request.getParameter("resourceid"));
	if(resourceid.equals("")) resourceid = "" + user.getUID() ;
	CRMSearchComInfo.setFieldValue("manager",resourceid);
	response.sendRedirect("/CRM/search/SearchResult.jsp");
	return;
}

if(destination.equals("QuickSearch")){
	CRMSearchComInfo.setFieldValue("name",Util.null2String(request.getParameter("CustomerName")));
	response.sendRedirect("/CRM/search/SearchResult.jsp");
	return;
}


if(destination.equals("toSimple")){
	response.sendRedirect("/CRM/search/SearchSimple.jsp?actionKey=" + actionKey);
	return;
}
if(destination.equals("toAdvanced")){
	response.sendRedirect("/CRM/search/SearchAdvanced.jsp?actionKey=" + actionKey);
	return;
}

/*--edited by 徐蔚绛 2005-03-09 TD:1546--*/
if(searchtype.equals("simple"))
{
	
	if(actionKey.equals("batchShare")){
	response.sendRedirect("/CRM/data/ShareMutiCustomerList.jsp");
	return;
	}
	else{
	response.sendRedirect("/CRM/search/SearchResult.jsp?pagenum=1");
	return;
	}
    
}

else if(searchtype.equals("advanced")){

  if(actionKey.equals("batchShare")){
	response.sendRedirect("/CRM/data/ShareMutiCustomerList.jsp");
	return;
	}
	else{
	response.sendRedirect("/CRM/search/SearchResult.jsp?pagenum=1");
	return;
	}
}
//td1761 xwj 2005-05-24
else if(searchtype.equals("baseOnCustomerStatus")){
	String CustomerTypes = Util.null2String(request.getParameter("CustomerTypes"));
	String CustomerDesc = Util.null2String(request.getParameter("CustomerDesc"));
	String CustomerStatus = Util.null2String(request.getParameter("CustomerStatus"));
	String CustomerSize = Util.null2String(request.getParameter("CustomerSize"));
	CRMSearchComInfo.setFieldValue("type",CustomerTypes);
	CRMSearchComInfo.setFieldValue("description",CustomerDesc);
	CRMSearchComInfo.setFieldValue("status",CustomerStatus);
	CRMSearchComInfo.setFieldValue("size_n",CustomerSize);
	response.sendRedirect("/CRM/search/SearchResult.jsp?pagenum=1");
	return;
}else if(searchtype.equals("hrmView")){
	CRMSearchComInfo.setFieldValue("searchHrmId",Util.null2String(request.getParameter("searchHrmId")));
	response.sendRedirect("/CRM/search/SearchResult.jsp");
return;
}else{
	String selectType=Util.null2String(request.getParameter("selectType"));
    response.sendRedirect("/CRM/search/SearchResult.jsp?pagenum=1&selectType="+selectType);    
}
   
%>


