
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="LgcSearchComInfo" class="weaver.lgc.search.LgcSearchComInfo" scope="session" />
<%
String method = Util.null2String(request.getParameter("method"));

String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;
if(method.equals("getTreeJson"))
{
	
}

if(operation.equals("lgcindept")){
	String departmentid =Util.null2String(request.getParameter("depid"));
	LgcSearchComInfo.setDepartmentid(departmentid);
	response.sendRedirect("LgcSearchResult.jsp?start=1");  
}
else if(operation.equals("search")){
	LgcSearchComInfo.resetSearchInfo();

	String msg = Util.null2String(request.getParameter("msg"));
	String assetmark = Util.fromScreen2(request.getParameter("assetmark"),user.getLanguage());
	String assetname   =Util.fromScreen2(request.getParameter("assetname"),user.getLanguage());
	String assetcountry =Util.null2String(request.getParameter("assetcountry"));
	String assetassortment =Util.null2String(request.getParameter("assetassortment"));
	String assetstatus =Util.null2String(request.getParameter("assetstatus"));
	String assettype = Util.null2String(request.getParameter("assettype"));
	String assetversion = Util.fromScreen2(request.getParameter("assetversion"),user.getLanguage());
	String[] assetattributes = request.getParameterValues("assetattribute") ;
	String assetsalespricefrom =Util.null2String(request.getParameter("assetsalespricefrom"));
	String assetsalespriceto =Util.null2String(request.getParameter("assetsalespriceto"));
	String departmentid =Util.null2String(request.getParameter("departmentid"));
	String resourceid =Util.null2String(request.getParameter("resourceid"));
	String crmid =Util.null2String(request.getParameter("crmid"));
	String orderby =Util.null2String(request.getParameter("orderby"));
	String assetattribute = "" ;
	
	if(assetattributes != null) {
		for(int i=0; i<assetattributes.length ; i++) {
			if(assetattributes[i] != null) assetattribute += assetattributes[i] + "|" ;
		}
	}


	if(msg.equals("myitem")){
		resourceid = "" + user.getUID() ;
	}

	LgcSearchComInfo.setAssetmark(assetmark);
	LgcSearchComInfo.setAssetname(assetname);
	LgcSearchComInfo.setAssetcountry(assetcountry);
	LgcSearchComInfo.setAssetassortment(assetassortment);
	LgcSearchComInfo.setAssetstatus(assetstatus);
	LgcSearchComInfo.setAssettype(assettype);
	LgcSearchComInfo.setAssetversion(assetversion);
	LgcSearchComInfo.setAssetattribute(assetattribute);
	LgcSearchComInfo.setAssetsalespricefrom(assetsalespricefrom);
	LgcSearchComInfo.setAssetsalespriceto(assetsalespriceto);
	LgcSearchComInfo.setDepartmentid(departmentid);
	LgcSearchComInfo.setResourceid(resourceid);
	LgcSearchComInfo.setCrmid(crmid);
	LgcSearchComInfo.setOrderby(orderby);


	response.sendRedirect("LgcSearchResult.jsp?start=1");  
}

else if(operation.equals("searchdefine")){
	String returnurl = Util.null2String(request.getParameter("returnurl"));
	String userid = ""+ user.getUID() ;
	String hasassetmark = Util.null2String(request.getParameter("hasassetmark"));
	String hasassetname  = Util.null2String(request.getParameter("hasassetname"));
	String hasassetcountry = Util.null2String(request.getParameter("hasassetcountry"));
	String hasassetassortment = Util.null2String(request.getParameter("hasassetassortment"));
	String hasassetstatus = Util.null2String(request.getParameter("hasassetstatus"));
	String hasassettype = Util.null2String(request.getParameter("hasassettype"));
	String hasassetversion = Util.null2String(request.getParameter("hasassetversion"));
	String hasassetattribute = Util.null2String(request.getParameter("hasassetattribute"));
	String hasassetsalesprice = Util.null2String(request.getParameter("hasassetsalesprice"));
	String hasdepartment = Util.null2String(request.getParameter("hasdepartment"));
	String hasresource = Util.null2String(request.getParameter("hasresource"));
	String hascrm = Util.null2String(request.getParameter("hascrm"));
	String perpage= Util.null2String(request.getParameter("perpage"));
	String assetcol1 = Util.null2String(request.getParameter("assetcol1"));
	String assetcol2 = Util.null2String(request.getParameter("assetcol2"));
	String assetcol3 = Util.null2String(request.getParameter("assetcol3"));
	String assetcol4 = Util.null2String(request.getParameter("assetcol4"));
	String assetcol5 = Util.null2String(request.getParameter("assetcol5"));
	String assetcol6 = Util.null2String(request.getParameter("assetcol6"));

	if(Util.getIntValue(perpage,0) == 0) perpage = "20" ;

	String para = userid + separator + hasassetmark+ separator + hasassetname+ separator + hasassetcountry + separator + hasassetassortment+ separator + hasassetstatus    + separator + hasassettype + separator + hasassetversion  + separator + hasassetattribute  + separator + hasassetsalesprice+ separator + hasdepartment      + separator + hasresource  + separator + hascrm  + separator + perpage  + separator + assetcol1     + separator + assetcol2   + separator + assetcol3 + separator + assetcol4  + separator + assetcol5    + separator + assetcol6 ;

	RecordSet.executeProc("LgcSearchDefine_Insert",para);
	
	if(returnurl.equals("my")) response.sendRedirect("LgcMyAssetView.jsp?id="+userid);
	else response.sendRedirect("LgcSearch.jsp");
}
else if(operation.equals("addmould")){
	String assetmark = Util.fromScreen(request.getParameter("assetmark"),user.getLanguage());
	String assetname   =Util.fromScreen(request.getParameter("assetname"),user.getLanguage());
	String assetcountry =Util.null2String(request.getParameter("assetcountry"));
	String assetassortment =Util.null2String(request.getParameter("assetassortment"));
	String assetstatus =Util.null2String(request.getParameter("assetstatus"));
	String assettype = Util.null2String(request.getParameter("assettype"));
	String assetversion = Util.fromScreen(request.getParameter("assetversion"),user.getLanguage());
	String[] assetattributes = request.getParameterValues("assetattribute") ;
	String assetsalespricefrom =Util.null2String(request.getParameter("assetsalespricefrom"));
	String assetsalespriceto =Util.null2String(request.getParameter("assetsalespriceto"));
	String departmentid =Util.null2String(request.getParameter("departmentid"));
	String resourceid =Util.null2String(request.getParameter("resourceid"));
	String crmid =Util.null2String(request.getParameter("crmid"));
	String assetattribute = "" ;
	
	if(assetattributes != null) {
		for(int i=0; i<assetattributes.length ; i++) {
			if(assetattributes[i] != null) assetattribute += assetattributes[i] + "|" ;
		}
	}

	String mouldname=Util.fromScreen(request.getParameter("mouldname"),user.getLanguage());
	String userid= "" + user.getUID();
	
	String para = mouldname + separator+userid + separator + assetmark + separator + assetname + separator + assetcountry   + separator + assetassortment + separator + assetstatus   + separator + assettype + separator + assetversion + separator + assetattribute + separator + assetsalespricefrom + separator + assetsalespriceto + separator + departmentid + separator + resourceid + separator + crmid ;
	
	RecordSet.executeProc("LgcSearchMould_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);
	response.sendRedirect("LgcSearch.jsp?mouldid="+id);
}

else if(operation.equals("updatemould")){
	String id = Util.null2String(request.getParameter("mouldid"));
	String assetmark = Util.fromScreen(request.getParameter("assetmark"),user.getLanguage());
	String assetname   =Util.fromScreen(request.getParameter("assetname"),user.getLanguage());
	String assetcountry =Util.null2String(request.getParameter("assetcountry"));
	String assetassortment =Util.null2String(request.getParameter("assetassortment"));
	String assetstatus =Util.null2String(request.getParameter("assetstatus"));
	String assettype = Util.null2String(request.getParameter("assettype"));
	String assetversion = Util.fromScreen(request.getParameter("assetversion"),user.getLanguage());
	String[] assetattributes = request.getParameterValues("assetattribute") ;
	String assetsalespricefrom =Util.null2String(request.getParameter("assetsalespricefrom"));
	String assetsalespriceto =Util.null2String(request.getParameter("assetsalespriceto"));
	String departmentid =Util.null2String(request.getParameter("departmentid"));
	String resourceid =Util.null2String(request.getParameter("resourceid"));
	String crmid =Util.null2String(request.getParameter("crmid"));
	String assetattribute = "" ;
	
	if(assetattributes != null) {
		for(int i=0; i<assetattributes.length ; i++) {
			if(assetattributes[i] != null) assetattribute += assetattributes[i] + "|" ;
		}
	}

	String para = id + separator + assetmark + separator + assetname + separator + assetcountry   + separator + assetassortment + separator + assetstatus   + separator + assettype + separator + assetversion + separator + assetattribute + separator + assetsalespricefrom + separator + assetsalespriceto + separator + departmentid + separator + resourceid + separator + crmid ;
	
	RecordSet.executeProc("LgcSearchMould_Update",para);
	response.sendRedirect("LgcSearch.jsp?mouldid="+id);
}
else if(operation.equals("deletemould")){
	String id = Util.null2String(request.getParameter("mouldid"));

	RecordSet.executeProc("LgcSearchMould_Delete",id);
	response.sendRedirect("LgcSearch.jsp");
}
%>
