<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));

char separator = Util.getSeparator() ;

if(operation.equals("addassetcrm")||operation.equals("editassetcrm")){ 
	String crmid = Util.null2String(request.getParameter("crmid"));
	String ismain = Util.null2String(request.getParameter("ismain"));
	String assetcode = Util.fromScreen(request.getParameter("assetcode"),user.getLanguage());
	String currencyid = Util.null2String(request.getParameter("currencyid"));
	String purchaseprice = Util.null2String(request.getParameter("purchaseprice"));
	String taxrate = Util.null2String(request.getParameter("taxrate"));
	String unitid = Util.null2String(request.getParameter("unitid"));
	String packageunit = Util.null2String(request.getParameter("packageunit"));
	String supplyremark = Util.fromScreen(request.getParameter("supplyremark"),user.getLanguage());
	String docid = Util.null2String(request.getParameter("docid"));
	String assetid = Util.null2String(request.getParameter("assetid"));
	String countryid = Util.null2String(request.getParameter("countryid"));

 if(operation.equals("addassetcrm")){
	String para = "";
	
	para  = assetid;
	para += separator+crmid;
	para += separator+countryid;
	para += separator+ismain;
	para += separator+assetcode;
	para += separator+currencyid;
	para += separator+purchaseprice;
	para += separator+taxrate;
	para += separator+unitid;
	para += separator+packageunit;
	para += separator+supplyremark;
	para += separator+docid;
	
	RecordSet.executeProc("LgcAssetCrm_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);

	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName("");
    SysMaintenanceLog.setOperateItem("55");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("LgcAssetCrm_Insert,"+para);
	SysMaintenanceLog.setSysLogInfo();

	response.sendRedirect("LgcAssetCrm.jsp?paraid="+assetid+"&countryid="+countryid);
 } //end 
  else if(operation.equals("editassetcrm")){
	String assetcrmid = Util.null2String(request.getParameter("assetcrmid"));

	String para = "";
	
	para  = assetcrmid;
	para += separator+assetid;
	para += separator+crmid;
	para += separator+countryid;
	para += separator+ismain;
	para += separator+assetcode;
	para += separator+currencyid;
	para += separator+purchaseprice;
	para += separator+taxrate;
	para += separator+unitid;
	para += separator+packageunit;
	para += separator+supplyremark;
	para += separator+docid;
	
	RecordSet.executeProc("LgcAssetCrm_Update",para);
	RecordSet.next();

    SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(Util.getIntValue(assetcrmid));
	SysMaintenanceLog.setRelatedName("");
	SysMaintenanceLog.setOperateType("2");
	SysMaintenanceLog.setOperateDesc("LgcAssetCrm_Update,"+para);
	SysMaintenanceLog.setOperateItem("55");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();

	response.sendRedirect("LgcAssetCrm.jsp?paraid="+assetid+"&countryid="+countryid);
 }///end if 
}//end if 
 else if(operation.equals("deleteassetcrm")){
  	int assetcrmid = Util.getIntValue(request.getParameter("assetcrmid"));
	String assetid = Util.null2String(request.getParameter("assetid"));
	String countryid = Util.null2String(request.getParameter("countryid"));

	String para = ""+assetcrmid;
	RecordSet.executeProc("LgcAssetCrm_Delete",para);
	RecordSet.next();

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(assetcrmid);
      SysMaintenanceLog.setRelatedName("");
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("LgcAssetCrm_Delete,"+para);
      SysMaintenanceLog.setOperateItem("55");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
	  
	response.sendRedirect("LgcAssetCrm.jsp?paraid="+assetid+"&countryid="+countryid);
 }
%>
