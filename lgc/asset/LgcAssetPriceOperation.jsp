<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));

char separator = Util.getSeparator() ;

if(operation.equals("addassetprice")||operation.equals("editassetprice")){ 
	String pricedesc = Util.fromScreen(request.getParameter("pricedesc"),user.getLanguage());
	String numfrom = Util.null2String(request.getParameter("numfrom"));
	String numto = Util.null2String(request.getParameter("numto"));
	String currencyid = Util.null2String(request.getParameter("currencyid"));
	String unitprice = Util.null2String(request.getParameter("unitprice"));
	String taxrate = Util.null2String(request.getParameter("taxrate"));

 if(operation.equals("addassetprice")){
	String assetid = Util.null2String(request.getParameter("assetid"));
	String assetcountryid = Util.null2String(request.getParameter("assetcountryid"));

	String para = "";
	
	para  = assetid;
	para += separator+assetcountryid;
	para += separator+pricedesc;
	para += separator+numfrom;
	para += separator+numto;
	para += separator+currencyid;
	para += separator+unitprice;
	para += separator+taxrate;
	
	RecordSet.executeProc("LgcAssetPrice_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);
	if(id == -1)  {
		response.sendRedirect("LgcAssetPriceAdd.jsp?paraid="+assetid+"&assetcountryid="+assetcountryid);
		return ;
	}

	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName("");
    SysMaintenanceLog.setOperateItem("54");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("LgcAssetPrice_Insert,"+para);
	SysMaintenanceLog.setSysLogInfo();

	AssetComInfo.removeAssetCache() ;
	response.sendRedirect("LgcAssetPrice.jsp?paraid="+assetid+"&assetcountryid="+assetcountryid);
 } //end 
  else if(operation.equals("editassetprice")){
	String assetpriceid = Util.null2String(request.getParameter("assetpriceid"));
	String redirect = Util.null2String(request.getParameter("redirect"));

	String para = "";
	
	para  = assetpriceid;
	para += separator+pricedesc;
	para += separator+numfrom;
	para += separator+numto;
	para += separator+currencyid;
	para += separator+unitprice;
	para += separator+taxrate;
	
	RecordSet.executeProc("LgcAssetPrice_Update",para);
	RecordSet.next();
	String assetid=RecordSet.getString("assetid");
	String assetcountyid=RecordSet.getString("assetcountyid");		

    SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(Util.getIntValue(assetpriceid));
	SysMaintenanceLog.setRelatedName("");
	SysMaintenanceLog.setOperateType("2");
	SysMaintenanceLog.setOperateDesc("LgcAssetPrice_Update,"+para);
	SysMaintenanceLog.setOperateItem("53");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();

	AssetComInfo.removeAssetCache() ;
	if (redirect.equals("1"))
		response.sendRedirect("LgcAsset.jsp?paraid="+assetid+"&assetcountryid="+assetcountyid);
	else
		response.sendRedirect("LgcAssetPrice.jsp?paraid="+assetid+"&assetcountryid="+assetcountyid);
 }///end if 
}//end if 
 else if(operation.equals("deleteassetprice")){
  	int assetpriceid = Util.getIntValue(request.getParameter("assetpriceid"));
	String redirect = Util.null2String(request.getParameter("redirect"));

	String para = ""+assetpriceid;
	RecordSet.executeProc("LgcAssetPrice_Delete",para);
	RecordSet.next();
	String assetid=RecordSet.getString("assetid");
	String assetcountyid=RecordSet.getString("assetcountyid");

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(assetpriceid);
      SysMaintenanceLog.setRelatedName("");
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("LgcAssetPrice_Delete,"+para);
      SysMaintenanceLog.setOperateItem("51");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
	  
	AssetComInfo.removeAssetCache() ;

	if (redirect.equals("1"))
		response.sendRedirect("LgcAsset.jsp?paraid="+assetid+"&assetcountryid="+assetcountyid);
	else
		response.sendRedirect("LgcAssetPrice.jsp?paraid="+assetid+"&assetcountryid="+assetcountyid);
 }
%>
