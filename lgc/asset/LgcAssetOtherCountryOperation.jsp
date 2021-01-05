<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));
String assetid = Util.null2String(request.getParameter("assetid"));
String assetmark = Util.null2String(AssetComInfo.getAssetMark("assetid"));

char separator = Util.getSeparator() ;

	Calendar today = Calendar.getInstance();
	String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
	String assetname = Util.fromScreen(request.getParameter("assetname"),user.getLanguage());
	String assetcountyid = Util.null2String(request.getParameter("assetcountyid"));
	if (assetcountyid.equals("")) { assetcountyid = "0";}
	String startdate = Util.fromScreen(request.getParameter("startdate"),user.getLanguage());
	String enddate = Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
	String departmentid = Util.null2String(request.getParameter("departmentid"));
	String resourceid = Util.null2String(request.getParameter("resourceid"));
	String assetremark = Util.fromScreen(request.getParameter("assetremark"),user.getLanguage());
	String currencyid = Util.null2String(request.getParameter("currencyid"));
	String salesprice = Util.null2String(request.getParameter("salesprice"));
	String costprice = Util.null2String(request.getParameter("costprice"));
	String isdefault = Util.null2String(request.getParameter("isdefault"));
	if (isdefault.equals("")) isdefault = "0";

	String tmpstr1 = "";
	String tmpstr2 = "";
	String tpara = "";
	String npara = "";
	String dpara = "";
	String bpara = "";

	for (int i=1;i<6;i++){
		tmpstr1 = "tff0"+i;
		if (!(tmpstr2=Util.fromScreen(request.getParameter(tmpstr1),user.getLanguage())).equals(""))
			tpara +=separator+tmpstr2;
		else
			tpara +=separator+"";
	}

	for (int i=1;i<6;i++){
		tmpstr1 = "nff0"+i;
		if (!(tmpstr2=Util.fromScreen(request.getParameter(tmpstr1),user.getLanguage())).equals(""))
			npara +=separator+tmpstr2;
		else
			npara +=separator+"";
	}

	for (int i=1;i<6;i++){
		tmpstr1 = "dff0"+i;
		if (!(tmpstr2=Util.fromScreen(request.getParameter(tmpstr1),user.getLanguage())).equals(""))
			dpara +=separator+tmpstr2;
		else
			dpara +=separator+"";
	}

	for (int i=1;i<6;i++){
		tmpstr1 = "bff0"+i;
		if (!(tmpstr2=Util.fromScreen(request.getParameter(tmpstr1),user.getLanguage())).equals(""))
			bpara +=separator+tmpstr2;
		else
			bpara +=separator+"";
	}
	
	String createrid = ""+user.getUID();
	String createdate = currentdate ;
	String lastmodid = ""+user.getUID();
	String lastmoddate = currentdate ;

 if(operation.equals("addassetothercountry")){
	String para = "";
	
	para  = assetid;
	para += separator+assetname;
	para += separator+assetcountyid;
	para += separator+startdate;
	para += separator+enddate;
	para += separator+departmentid;
	para += separator+resourceid;
	para += separator+assetremark;
	para += separator+currencyid;
	para += separator+salesprice;
	para += separator+costprice;
	para += dpara;
	para += npara;
	para += tpara;
	para += bpara;
	para += separator+createrid;
	para += separator+createdate;
	para += separator+lastmodid;
	para += separator+lastmoddate;
	para += separator+isdefault;

	RecordSet.executeProc("LgcAssetCountry_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);
	if(id == -1)  {
		response.sendRedirect("LgcAssetAddOtherCountry.jsp?paraid="+assetid+"&msgid=12");
		return ;
	}

	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName(assetmark +"-"+assetname);
    SysMaintenanceLog.setOperateItem("53");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("LgcAssetCountry_Insert,"+para);
	SysMaintenanceLog.setSysLogInfo();

	AssetComInfo.removeAssetCache() ;
	response.sendRedirect("LgcAsset.jsp?paraid="+assetid);
 } //end 
 
%>
