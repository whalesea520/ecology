<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));

char separator = Util.getSeparator() ;

if(operation.equals("addassetstock")||operation.equals("editassetstock")){ 
	String warehouseid = Util.null2String(request.getParameter("warehouseid"));
	String assetid = Util.null2String(request.getParameter("assetid"));
	String stocknum = Util.null2String(request.getParameter("stocknum"));
	String unitprice = Util.null2String(request.getParameter("unitprice"));
	String trandefcurrencyid = Util.null2String(request.getParameter("trandefcurrencyid"));
	String currencyid = Util.null2String(request.getParameter("currencyid"));
	String exchangerate = Util.null2String(request.getParameter("exchangerate"));
//	BigDecimal  defcountprice = new BigDecimal("0") ;
//	BigDecimal  countprice = new BigDecimal("0") ;
//	BigDecimal  defunitprice = new BigDecimal("0") ;



 if(operation.equals("addassetstock")){
	String para = "";
	
	para  = warehouseid;
	para += separator+assetid;
	para += separator+stocknum;
	para += separator+unitprice;
	para += separator+trandefcurrencyid;
	para += separator+currencyid;
	para += separator+exchangerate;
	
	RecordSet.executeProc("LgcAssetStock_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);
	if(id == -1)  {
		response.sendRedirect("LgcAssetStockAdd.jsp?msgid=12&paraid="+assetid);
		return ;
	}

	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName("");
    SysMaintenanceLog.setOperateItem("56");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("LgcAssetStock_Insert,"+para);
	SysMaintenanceLog.setSysLogInfo();

	response.sendRedirect("LgcAssetStock.jsp?paraid="+assetid);
 } //end 
  else if(operation.equals("editassetstock")){
	String assetstockid = Util.null2String(request.getParameter("assetstockid"));

	String para = "";
	
	para  = assetstockid;
	para += separator+warehouseid;
	para += separator+assetid;
	para += separator+stocknum;
	para += separator+unitprice;
	para += separator+trandefcurrencyid;
	para += separator+currencyid;
	para += separator+exchangerate;

	RecordSet.executeProc("LgcAssetStock_Update",para);
	RecordSet.next();

	int	id = RecordSet.getInt(1);
	if(id == -1)  {
		response.sendRedirect("LgcAssetStockEdit.jsp?msgid=13&paraid="+assetid);
		return ;
	}

    SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(Util.getIntValue(assetstockid));
	SysMaintenanceLog.setRelatedName("");
	SysMaintenanceLog.setOperateType("2");
	SysMaintenanceLog.setOperateDesc("LgcAssetStock_Update,"+para);
	SysMaintenanceLog.setOperateItem("56");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();

	response.sendRedirect("LgcAssetStock.jsp?paraid="+assetid);
 }///end if 
}//end if 
 else if(operation.equals("deleteassetstock")){
	String assetstockid = Util.null2String(request.getParameter("assetstockid"));
    String warehouseid = Util.null2String(request.getParameter("warehouseid"));
	String assetid = Util.null2String(request.getParameter("assetid"));

	String para = ""+assetstockid+separator+warehouseid+separator+assetid;
	RecordSet.executeProc("LgcAssetStock_Delete",para);
	RecordSet.next();

	int	id = RecordSet.getInt(1);
	if(id == -1)  {
		response.sendRedirect("LgcAssetStockEdit.jsp?msgid=20&paraid="+assetid);
		return ;
	}

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(assetstockid));
      SysMaintenanceLog.setRelatedName("");
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("LgcAssetStock_Delete,"+para);
      SysMaintenanceLog.setOperateItem("56");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	response.sendRedirect("LgcAssetStock.jsp?paraid="+assetid);
 }
%>
