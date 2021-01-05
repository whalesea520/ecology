<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="LgcAssortmentComInfo" class="weaver.lgc.maintenance.LgcAssortmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
FileUpload fu = new FileUpload(request);
String operation = Util.null2String(fu.getParameter("operation"));
char separator = Util.getSeparator() ;

if(operation.equalsIgnoreCase("delpic")) {
	if(!HrmUserVarify.checkUserRight("CrmProduct:Add",user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	String assortmentid = Util.null2String(fu.getParameter("assortmentid")) ;
	String oldassortmentimageid= Util.null2String(fu.getParameter("oldassortmentimage"));
	String assortmentmark = Util.fromScreen(fu.getParameter("assortmentmark"),user.getLanguage());
	String assortmentname = Util.fromScreen(fu.getParameter("assortmentname"),user.getLanguage());

	RecordSet.executeProc("LgcAssetAssortment_UpdatePic",assortmentid+separator+oldassortmentimageid);

/*
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(Util.getIntValue(assortmentid));
	SysMaintenanceLog.setRelatedName(assortmentmark +"-"+assortmentname);
    SysMaintenanceLog.setOperateItem("43");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setOperateType("2");
	SysMaintenanceLog.setOperateDesc("LgcAssetAssortment_UpdatePic,"+assortmentid+separator+oldassortmentimageid);
	SysMaintenanceLog.setSysLogInfo();
*/
	response.sendRedirect("LgcAssortmentEdit.jsp?paraid="+assortmentid);
	return ;
 }

if(operation.equals("addassortment")||operation.equals("editassortment")){     
	if(!HrmUserVarify.checkUserRight("CrmProduct:Add",user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
  	String assortmentmark = Util.fromScreen(fu.getParameter("assortmentmark"),user.getLanguage());
	String assortmentname = Util.fromScreen(fu.getParameter("assortmentname"),user.getLanguage());
	String seclevel = Util.null2String(fu.getParameter("seclevel"));
	String resourceid = Util.null2String(fu.getParameter("resourceid"));
	String supassortmentid = Util.null2String(fu.getParameter("supassortmentid"));
	String supassortmentstr = Util.null2String(fu.getParameter("supassortmentstr"));
	String assortmentremark=Util.fromScreen(fu.getParameter("Remark"),user.getLanguage());
	String assortmentimageid= Util.null2String(fu.uploadFiles("assortmentimage"));
	String oldassortmentimageid= Util.null2String(fu.getParameter("oldassortmentimage"));
	String iself = Util.null2String(fu.getParameter("iself"));
	if(assortmentimageid.equals("") && operation.equalsIgnoreCase("addassortment")) 
		assortmentimageid="0" ;
	if(assortmentimageid.equals("") && operation.equalsIgnoreCase("editassortment"))       
	    assortmentimageid=oldassortmentimageid ;
	if("".equals(supassortmentid) || supassortmentid == null){
		supassortmentid = "0";
	}
	String tff01name = Util.fromScreen(fu.getParameter("tff01"),user.getLanguage());
	String tff02name = Util.fromScreen(fu.getParameter("tff02"),user.getLanguage());
	String tff03name = Util.fromScreen(fu.getParameter("tff03"),user.getLanguage());
	String tff04name = Util.fromScreen(fu.getParameter("tff04"),user.getLanguage());
	String tff05name = Util.fromScreen(fu.getParameter("tff05"),user.getLanguage());
	String nff01name = Util.fromScreen(fu.getParameter("nff01"),user.getLanguage());
	String nff02name = Util.fromScreen(fu.getParameter("nff02"),user.getLanguage());
	String nff03name = Util.fromScreen(fu.getParameter("nff03"),user.getLanguage());
	String nff04name = Util.fromScreen(fu.getParameter("nff04"),user.getLanguage());
	String nff05name = Util.fromScreen(fu.getParameter("nff05"),user.getLanguage());
	String dff01name = Util.fromScreen(fu.getParameter("dff01"),user.getLanguage());
	String dff02name = Util.fromScreen(fu.getParameter("dff02"),user.getLanguage());
	String dff03name = Util.fromScreen(fu.getParameter("dff03"),user.getLanguage());
	String dff04name = Util.fromScreen(fu.getParameter("dff04"),user.getLanguage());
	String dff05name = Util.fromScreen(fu.getParameter("dff05"),user.getLanguage());
	String bff01name = Util.fromScreen(fu.getParameter("bff01"),user.getLanguage());
	String bff02name = Util.fromScreen(fu.getParameter("bff02"),user.getLanguage());
	String bff03name = Util.fromScreen(fu.getParameter("bff03"),user.getLanguage());
	String bff04name = Util.fromScreen(fu.getParameter("bff04"),user.getLanguage());
	String bff05name = Util.fromScreen(fu.getParameter("bff05"),user.getLanguage());

	String tff01use = "";
	String tff02use = "";
	String tff03use = "";
	String tff04use = "";
	String tff05use = "";
	String nff01use = "";
	String nff02use = "";
	String nff03use = "";
	String nff04use = "";
	String nff05use = "";
	String dff01use = "";
	String dff02use = "";
	String dff03use = "";
	String dff04use = "";
	String dff05use = "";
	String bff01use = "";
	String bff02use = "";
	String bff03use = "";
	String bff04use = "";
	String bff05use = "";

	if (tff01name.equals("")) { tff01use = "0"; } else { tff01use = "1"; }
	if (tff02name.equals("")) { tff02use = "0"; } else { tff02use = "1"; }
	if (tff03name.equals("")) { tff03use = "0"; } else { tff03use = "1"; }
	if (tff04name.equals("")) { tff04use = "0"; } else { tff04use = "1"; }
	if (tff05name.equals("")) { tff05use = "0"; } else { tff05use = "1";}
	if (nff01name.equals("")) { nff01use = "0"; } else { nff01use = "1"; }
	if (nff02name.equals("")) { nff02use = "0"; } else { nff02use = "1"; }
	if (nff03name.equals("")) { nff03use = "0"; } else { nff03use = "1"; }
	if (nff04name.equals("")) { nff04use = "0"; } else { nff04use = "1"; }
	if (nff05name.equals("")) { nff05use = "0"; } else { nff05use = "1"; }
	if (dff01name.equals("")) { dff01use = "0"; } else { dff01use = "1"; }
	if (dff02name.equals("")) { dff02use = "0"; } else { dff02use = "1"; }
	if (dff03name.equals("")) { dff03use = "0"; } else { dff03use = "1"; }
	if (dff04name.equals("")) { dff04use = "0"; } else { dff04use = "1"; }
	if (dff05name.equals("")) { dff05use = "0"; } else { dff05use = "1"; }
	if (bff01name.equals("")) { bff01use = "0"; } else { bff01use = "1"; }
	if (bff02name.equals("")) { bff02use = "0"; } else { bff02use = "1"; }
	if (bff03name.equals("")) { bff03use = "0"; } else { bff03use = "1"; }
	if (bff04name.equals("")) { bff04use = "0"; } else { bff04use = "1"; }
	if (bff05name.equals("")) { bff05use = "0"; } else { bff05use = "1"; }

 if(operation.equals("addassortment")){
	String para = "";
	
	para  = assortmentmark;
	para += separator+assortmentname;
	para += separator+seclevel;
	para += separator+resourceid;
	para += separator+assortmentimageid;
	para += separator+assortmentremark;
	para += separator+supassortmentid;
	para += separator+supassortmentstr;
	para += separator+dff01name;
	para += separator+dff01use;
	para += separator+dff02name;
	para += separator+dff02use;
	para += separator+dff03name;
	para += separator+dff03use;
	para += separator+dff04name;
	para += separator+dff04use;
	para += separator+dff05name;
	para += separator+dff05use;
	para += separator+nff01name;
	para += separator+nff01use;
	para += separator+nff02name;
	para += separator+nff02use;
	para += separator+nff03name;
	para += separator+nff03use;
	para += separator+nff04name;
	para += separator+nff04use;
	para += separator+nff05name;
	para += separator+nff05use;
	para += separator+tff01name;
	para += separator+tff01use;
	para += separator+tff02name;
	para += separator+tff02use;
	para += separator+tff03name;
	para += separator+tff03use;
	para += separator+tff04name;
	para += separator+tff04use;
	para += separator+tff05name;
	para += separator+tff05use;
	para += separator+bff01name;
	para += separator+bff01use;
	para += separator+bff02name;
	para += separator+bff02use;
	para += separator+bff03name;
	para += separator+bff03use;
	para += separator+bff04name;
	para += separator+bff04use;
	para += separator+bff05name;	
	para += separator+bff05use;
	
	RecordSet.executeProc("LgcAssetAssortment_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);
	if(id == -1)  {
		response.sendRedirect("LgcAssortment.jsp?msgid=28");
		return ;
	}
/*
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName(assortmentmark +"-"+assortmentname);
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("LgcAssetAssortment_Insert,"+para);
	SysMaintenanceLog.setOperateItem("43");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();
*/
	LgcAssortmentComInfo.removeLgcAssortmentCache() ;

	if(!iself.equals(""))
		response.sendRedirect("LgcAssortmentAdd.jsp?isclose=1"+"&aid="+id+"&apid="+supassortmentid);
	else
	{
		if(!supassortmentid.equals("0") && !supassortmentid.equals(""))
			response.sendRedirect("LgcAssortmentAdd.jsp?isclose=1&paraid="+supassortmentid+"&aid="+id+"&apid="+supassortmentid);
		else
			response.sendRedirect("LgcAssortmentAdd.jsp?isclose=1"+"&aid="+id+"&apid="+supassortmentid);
	}
 } //end (operation.equals("addassortment"))
 else if(operation.equals("editassortment")){
  	String assortmentid = Util.null2String(fu.getParameter("assortmentid"));
	
	String para = "";	
	para = assortmentid;
	para += separator+assortmentmark;
	para += separator+assortmentname;
	para += separator+seclevel;
	para += separator+resourceid;
	para += separator+assortmentimageid;
	para += separator+assortmentremark;
	para += separator+supassortmentid;
	para += separator+supassortmentstr;
	para += separator+dff01name;
	para += separator+dff01use;
	para += separator+dff02name;
	para += separator+dff02use;
	para += separator+dff03name;
	para += separator+dff03use;
	para += separator+dff04name;
	para += separator+dff04use;
	para += separator+dff05name;
	para += separator+dff05use;
	para += separator+nff01name;
	para += separator+nff01use;
	para += separator+nff02name;
	para += separator+nff02use;
	para += separator+nff03name;
	para += separator+nff03use;
	para += separator+nff04name;
	para += separator+nff04use;
	para += separator+nff05name;
	para += separator+nff05use;
	para += separator+tff01name;
	para += separator+tff01use;
	para += separator+tff02name;
	para += separator+tff02use;
	para += separator+tff03name;
	para += separator+tff03use;
	para += separator+tff04name;
	para += separator+tff04use;
	para += separator+tff05name;
	para += separator+tff05use;
	para += separator+bff01name;
	para += separator+bff01use;
	para += separator+bff02name;
	para += separator+bff02use;
	para += separator+bff03name;
	para += separator+bff03use;
	para += separator+bff04name;
	para += separator+bff04use;
	para += separator+bff05name;	
	para += separator+bff05use;
	
	RecordSet.executeProc("LgcAssetAssortment_Update",para);

	if(RecordSet.next()) {
		response.sendRedirect("LgcAssortmentView.jsp?paraid="+assortmentid+"&msgid=13");
		return ;
	}
/*	
    SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(Util.getIntValue(assortmentid));
	SysMaintenanceLog.setRelatedName(assortmentmark +"-"+assortmentname);
	SysMaintenanceLog.setOperateType("2");
	SysMaintenanceLog.setOperateDesc("LgcAssetAssortment_Update,"+para);
	SysMaintenanceLog.setOperateItem("43");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();
*/
	LgcAssortmentComInfo.removeLgcAssortmentCache() ;
	
	if(!iself.equals(""))
		response.sendRedirect("LgcAssortmentAdd.jsp?isclose=1&paraid="+assortmentid+"&aid="+assortmentid+"&apid="+supassortmentid);
	else
	{
		if(!supassortmentid.equals("0") && !supassortmentid.equals(""))
			response.sendRedirect("LgcAssortmentAdd.jsp?isclose=1&paraid="+supassortmentid+"&aid="+assortmentid+"&apid="+supassortmentid);
		else
			response.sendRedirect("LgcAssortmentAdd.jsp?isclose=1"+"&aid="+assortmentid+"&apid="+supassortmentid);
	}
	
 }//end if (operation.equals("editassortment"))
}//end if (operation.equals("addassortment")||operation.equals("editassortment"))
 else if(operation.equals("deleteassortment")){
	if(!HrmUserVarify.checkUserRight("CrmProduct:Add",user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
  	int assortmentid = Util.getIntValue(fu.getParameter("assortmentid"));

	String assortmentmark = Util.fromScreen(fu.getParameter("assortmentmark"),user.getLanguage());
	String assortmentname = Util.fromScreen(fu.getParameter("assortmentname"),user.getLanguage());
	String supassortmentid = Util.null2String(fu.getParameter("supassortmentid"));

	String para = ""+assortmentid;
	RecordSet.executeProc("LgcAssetAssortment_Delete",para);

	if(RecordSet.next() && RecordSet.getString(1).equals("-1")){
		response.sendRedirect("LgcAssortmentEdit.jsp?paraid="+assortmentid+"&msgid=20");
		return ;
	}
/*
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(assortmentid);
      SysMaintenanceLog.setRelatedName(assortmentmark +"-"+assortmentname);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("LgcAssetAssortment_Delete,"+para);
      SysMaintenanceLog.setOperateItem("43");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
*/	  
	LgcAssortmentComInfo.removeLgcAssortmentCache() ;
	if(supassortmentid.equals(""))
		response.sendRedirect("LgcAssortment.jsp");
	else
		response.sendRedirect("LgcAssortment.jsp?assortmentid="+supassortmentid);
 }
%>
