<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;

if(operation.equals("addcatalog")){


  	String catalogname = Util.fromScreen(request.getParameter("catalogname"),user.getLanguage());
	String catalogdesc = Util.fromScreen(request.getParameter("catalogdesc"),user.getLanguage());
	String catalogorder = Util.null2String(request.getParameter("catalogorder"));  
	String perpage = Util.null2String(request.getParameter("perpage"));  
	String seclevelfrom = Util.null2String(request.getParameter("seclevelfrom"));
	String seclevelto = Util.null2String(request.getParameter("seclevelto"));
	String navibardsp = Util.null2String(request.getParameter("navibardsp"));
	String navibarbgcolor = Util.null2String(request.getParameter("navibarbgcolor"));
	String navibarfontcolor = Util.null2String(request.getParameter("navibarfontcolor"));
	String navibarfontsize = Util.null2String(request.getParameter("navibarfontsize"));
	String navibarfonttype = Util.null2String(request.getParameter("navibarfonttype"));
	String toolbardsp = Util.null2String(request.getParameter("toolbardsp"));
	String toolbarwidth = Util.null2String(request.getParameter("toolbarwidth")); 
	String toolbarbgcolor = Util.null2String(request.getParameter("toolbarbgcolor"));
	String toolbarfontcolor = Util.null2String(request.getParameter("toolbarfontcolor"));
	String toolbarlinkbgcolor = Util.null2String(request.getParameter("toolbarlinkbgcolor"));
	String toolbarlinkfontcolor = Util.null2String(request.getParameter("toolbarlinkfontcolor"));
	String toolbarfontsize = Util.null2String(request.getParameter("toolbarfontsize"));
	String toolbarfonttype = Util.null2String(request.getParameter("toolbarfonttype"));
	String countrydsp = Util.null2String(request.getParameter("countrydsp")); 
	String countrydeftype = Util.null2String(request.getParameter("countrydeftype"));
	String countryid = Util.null2String(request.getParameter("countryid"));
	String searchbyname = Util.null2String(request.getParameter("searchbyname")); 
	String searchbycrm = Util.null2String(request.getParameter("searchbycrm")); 
	String searchadv = Util.null2String(request.getParameter("searchadv"));  
	String assortmentdsp = Util.null2String(request.getParameter("assortmentdsp"));
	String assortmentname = Util.fromScreen(request.getParameter("assortmentname"),user.getLanguage());
	String assortmentsql = Util.fromScreen(request.getParameter("assortmentsql"),user.getLanguage());
	String attributedsp = Util.null2String(request.getParameter("attributedsp"));  
	String attributecol = Util.null2String(request.getParameter("attributecol"));  
	String attributefontsize = Util.null2String(request.getParameter("attributefontsize"));
	String attributefonttype = Util.null2String(request.getParameter("attributefonttype"));
	String assetsql = Util.fromScreen(request.getParameter("assetsql"),user.getLanguage());
	String assetcol1 = Util.null2String(request.getParameter("assetcol1"));
	String assetcol2 = Util.null2String(request.getParameter("assetcol2"));
	String assetcol3 = Util.null2String(request.getParameter("assetcol3"));
	String assetcol4 = Util.null2String(request.getParameter("assetcol4"));
	String assetcol5 = Util.null2String(request.getParameter("assetcol5"));
	String assetcol6 = Util.null2String(request.getParameter("assetcol6"));
	String assetfontsize = Util.null2String(request.getParameter("assetfontsize"));
	String assetfonttype = Util.null2String(request.getParameter("assetfonttype"));
	String webshopdap = Util.null2String(request.getParameter("webshopdap"));  
	String webshoptype = Util.null2String(request.getParameter("webshoptype"));
	String webshopreturn = Util.null2String(request.getParameter("webshopreturn"));  
	String webshopmanageid = Util.null2String(request.getParameter("webshopmanageid"));
	String createrid = ""+user.getUID() ;
	Calendar today = Calendar.getInstance();
	String createdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
	
	if(perpage.equals("0") || perpage.equals("")) perpage = "10" ;
	if(toolbarwidth.equals("0") || toolbarwidth.equals("")) toolbarwidth = "0" ;
	if(countrydsp.equals("")) countrydsp = "0" ;
	if(searchbyname.equals("")) searchbyname = "0" ;
	if(searchbycrm.equals("")) searchbycrm = "0" ;
	if(searchadv.equals("")) searchadv = "0" ;
	if(assortmentdsp.equals("")) assortmentdsp = "0" ;
	if(attributedsp.equals("")) attributedsp = "0" ;
	if(attributecol.equals("0") || attributecol.equals("")) attributecol = "5" ;
	if(webshopdap.equals("")) webshopdap = "0" ;
	if(webshopreturn.equals("")) webshopreturn = "0" ;
	

	String para = catalogname + separator + catalogdesc + separator + catalogorder 
		+ separator + perpage + separator + seclevelfrom + separator + seclevelto 
		+ separator + navibardsp + separator + navibarbgcolor + separator + navibarfontcolor 
		+ separator + navibarfontsize + separator + navibarfonttype + separator + toolbardsp 
		+ separator + toolbarwidth + separator + toolbarbgcolor + separator + toolbarfontcolor 
	+ separator + toolbarlinkbgcolor + separator + toolbarlinkfontcolor + separator + toolbarfontsize 
		+ separator + toolbarfonttype + separator + countrydsp + separator + countrydeftype 
		+ separator + countryid + separator + searchbyname + separator + searchbycrm 
		+ separator + searchadv + separator + assortmentdsp + separator + assortmentname 
		+ separator + assortmentsql + separator + attributedsp + separator + attributecol 
		+ separator + attributefontsize + separator + attributefonttype + separator + assetsql 
		+ separator + assetcol1 + separator + assetcol2 + separator + assetcol3 
		+ separator + assetcol4 + separator + assetcol5 + separator + assetcol6 
		+ separator + assetfontsize + separator + assetfonttype + separator + webshopdap 
		+ separator + webshoptype + separator + webshopreturn + separator + webshopmanageid 
		+ separator + createrid + separator + createdate ; 

	RecordSet.executeProc("LgcCatalogs_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName(catalogname);
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("LgcCatalogs_Insert,"+para);
	SysMaintenanceLog.setOperateItem("52");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();

	response.sendRedirect("LgcCatalogs.jsp");
 }
else if(operation.equals("editcatalog")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String catalogname = Util.fromScreen(request.getParameter("catalogname"),user.getLanguage());
	String catalogdesc = Util.fromScreen(request.getParameter("catalogdesc"),user.getLanguage());
	String catalogorder = Util.null2String(request.getParameter("catalogorder"));  
	String perpage = Util.null2String(request.getParameter("perpage"));  
	String seclevelfrom = Util.null2String(request.getParameter("seclevelfrom"));
	String seclevelto = Util.null2String(request.getParameter("seclevelto"));
	String navibardsp = Util.null2String(request.getParameter("navibardsp"));
	String navibarbgcolor = Util.null2String(request.getParameter("navibarbgcolor"));
	String navibarfontcolor = Util.null2String(request.getParameter("navibarfontcolor"));
	String navibarfontsize = Util.null2String(request.getParameter("navibarfontsize"));
	String navibarfonttype = Util.null2String(request.getParameter("navibarfonttype"));
	String toolbardsp = Util.null2String(request.getParameter("toolbardsp"));
	String toolbarwidth = Util.null2String(request.getParameter("toolbarwidth")); 
	String toolbarbgcolor = Util.null2String(request.getParameter("toolbarbgcolor"));
	String toolbarfontcolor = Util.null2String(request.getParameter("toolbarfontcolor"));
	String toolbarlinkbgcolor = Util.null2String(request.getParameter("toolbarlinkbgcolor"));
	String toolbarlinkfontcolor = Util.null2String(request.getParameter("toolbarlinkfontcolor"));
	String toolbarfontsize = Util.null2String(request.getParameter("toolbarfontsize"));
	String toolbarfonttype = Util.null2String(request.getParameter("toolbarfonttype"));
	String countrydsp = Util.null2String(request.getParameter("countrydsp")); 
	String countrydeftype = Util.null2String(request.getParameter("countrydeftype"));
	String countryid = Util.null2String(request.getParameter("countryid"));
	String searchbyname = Util.null2String(request.getParameter("searchbyname")); 
	String searchbycrm = Util.null2String(request.getParameter("searchbycrm")); 
	String searchadv = Util.null2String(request.getParameter("searchadv"));  
	String assortmentdsp = Util.null2String(request.getParameter("assortmentdsp"));
	String assortmentname = Util.fromScreen(request.getParameter("assortmentname"),user.getLanguage());
	String assortmentsql = Util.fromScreen(request.getParameter("assortmentsql"),user.getLanguage());
	String attributedsp = Util.null2String(request.getParameter("attributedsp"));  
	String attributecol = Util.null2String(request.getParameter("attributecol"));  
	String attributefontsize = Util.null2String(request.getParameter("attributefontsize"));
	String attributefonttype = Util.null2String(request.getParameter("attributefonttype"));
	String assetsql = Util.fromScreen(request.getParameter("assetsql"),user.getLanguage());
	String assetcol1 = Util.null2String(request.getParameter("assetcol1"));
	String assetcol2 = Util.null2String(request.getParameter("assetcol2"));
	String assetcol3 = Util.null2String(request.getParameter("assetcol3"));
	String assetcol4 = Util.null2String(request.getParameter("assetcol4"));
	String assetcol5 = Util.null2String(request.getParameter("assetcol5"));
	String assetcol6 = Util.null2String(request.getParameter("assetcol6"));
	String assetfontsize = Util.null2String(request.getParameter("assetfontsize"));
	String assetfonttype = Util.null2String(request.getParameter("assetfonttype"));
	String webshopdap = Util.null2String(request.getParameter("webshopdap"));  
	String webshoptype = Util.null2String(request.getParameter("webshoptype"));
	String webshopreturn = Util.null2String(request.getParameter("webshopreturn"));  
	String webshopmanageid = Util.null2String(request.getParameter("webshopmanageid"));
	String createrid = ""+user.getUID() ;
	Calendar today = Calendar.getInstance();
	String createdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
	
	if(perpage.equals("0") || perpage.equals("")) perpage = "10" ;
	if(toolbarwidth.equals("0") || toolbarwidth.equals("")) toolbarwidth = "0" ;
	if(countrydsp.equals("")) countrydsp = "0" ;
	if(searchbyname.equals("")) searchbyname = "0" ;
	if(searchbycrm.equals("")) searchbycrm = "0" ;
	if(searchadv.equals("")) searchadv = "0" ;
	if(assortmentdsp.equals("")) assortmentdsp = "0" ;
	if(attributedsp.equals("")) attributedsp = "0" ;
	if(attributecol.equals("0") || attributecol.equals("")) attributecol = "5" ;
	if(webshopdap.equals("")) webshopdap = "0" ;
	if(webshopreturn.equals("")) webshopreturn = "0" ;
	

	String para = ""+id + separator + catalogname + separator + catalogdesc + separator + catalogorder 
		+ separator + perpage + separator + seclevelfrom + separator + seclevelto 
		+ separator + navibardsp + separator + navibarbgcolor + separator + navibarfontcolor 
		+ separator + navibarfontsize + separator + navibarfonttype + separator + toolbardsp 
		+ separator + toolbarwidth + separator + toolbarbgcolor + separator + toolbarfontcolor 
	+ separator + toolbarlinkbgcolor + separator + toolbarlinkfontcolor + separator + toolbarfontsize 
		+ separator + toolbarfonttype + separator + countrydsp + separator + countrydeftype 
		+ separator + countryid + separator + searchbyname + separator + searchbycrm 
		+ separator + searchadv + separator + assortmentdsp + separator + assortmentname 
		+ separator + assortmentsql + separator + attributedsp + separator + attributecol 
		+ separator + attributefontsize + separator + attributefonttype + separator + assetsql 
		+ separator + assetcol1 + separator + assetcol2 + separator + assetcol3 
		+ separator + assetcol4 + separator + assetcol5 + separator + assetcol6 
		+ separator + assetfontsize + separator + assetfonttype + separator + webshopdap 
		+ separator + webshoptype + separator + webshopreturn + separator + webshopmanageid 
		+ separator + createrid + separator + createdate ; 

	RecordSet.executeProc("LgcCatalogs_Update",para);
	
    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(id);
    SysMaintenanceLog.setRelatedName(catalogname);
    SysMaintenanceLog.setOperateType("2");
    SysMaintenanceLog.setOperateDesc("LgcCatalogs_Update,"+para);
    SysMaintenanceLog.setOperateItem("52");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();

 	response.sendRedirect("LgcCatalogs.jsp");
 }
 else if(operation.equals("deletecatalog")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String catalogname = Util.fromScreen(request.getParameter("catalogname"),user.getLanguage());
	String para = ""+id;
	RecordSet.executeProc("LgcCatalogs_Delete",para);
	

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(catalogname);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("LgcCatalogs_Delete,"+para);
      SysMaintenanceLog.setOperateItem("52");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
	  
 	response.sendRedirect("LgcCatalogs.jsp");
 }
%>