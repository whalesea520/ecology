<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="LgcAssortmentComInfo" class="weaver.lgc.maintenance.LgcAssortmentComInfo" scope="page" />
<%
FileUpload fu = new FileUpload(request);
String operation = Util.null2String(fu.getParameter("operation"));
char separator = Util.getSeparator() ;

if(operation.equalsIgnoreCase("delpic")) {
	String assetid = Util.null2String(fu.getParameter("assetid")) ;
	String assetcountryid = Util.null2String(fu.getParameter("assetcountryid")) ;
	String oldassetimageid= Util.null2String(fu.getParameter("oldassetimage"));
	String assetmark = Util.fromScreen(fu.getParameter("assetmark"),user.getLanguage());
	String assetname = Util.fromScreen(fu.getParameter("assetname"),user.getLanguage());

	RecordSet.executeProc("LgcAsset_UpdatePic",assetid+separator+oldassetimageid);

/*
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(Util.getIntValue(assetid));
	SysMaintenanceLog.setRelatedName(assetmark +"-"+assetname);
    SysMaintenanceLog.setOperateItem("51");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setOperateType("2");
	SysMaintenanceLog.setOperateDesc("LgcAsset_UpdatePic,"+assetid+separator+oldassetimageid);
	SysMaintenanceLog.setSysLogInfo();
*/
	response.sendRedirect("LgcAssetEdit.jsp?paraid="+assetid+"&assetcountryid="+assetcountryid);
	return ;
 }

if(operation.equals("addasset")||operation.equals("editasset")){ 
	if(!HrmUserVarify.checkUserRight("CrmProduct:Add",user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	Calendar today = Calendar.getInstance();
	String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
  	String assetmark = Util.fromScreen(fu.getParameter("assetmark"),user.getLanguage());
		if(assetmark.equals("")) assetmark="0";
	String assetname = Util.fromScreen(fu.getParameter("assetname"),user.getLanguage());
	String barcode = Util.fromScreen(fu.getParameter("barcode"),user.getLanguage());
	String assetcountyid = Util.fromScreen(fu.getParameter("assetcountyid"),user.getLanguage());
		if (assetcountyid.equals("")) { assetcountyid = "0";}
	String startdate = Util.fromScreen(fu.getParameter("startdate"),user.getLanguage());
	String enddate = Util.fromScreen(fu.getParameter("enddate"),user.getLanguage());
	String seclevel = Util.null2String(fu.getParameter("seclevel"));
	String departmentid = Util.null2String(fu.getParameter("departmentid"));
	String resourceid = Util.null2String(fu.getParameter("resourceid"));
	String relatewfid = Util.null2String(fu.getParameter("relatewfid"));
	String assetremark = Util.fromScreen(fu.getParameter("assetremark"),user.getLanguage());
	String currencyid = Util.null2String(fu.getParameter("currencyid"));
	String salesprice = Util.null2String(fu.getParameter("salesprice"));
		if (salesprice.equals("")) { salesprice = "0";}
	String costprice = Util.null2String(fu.getParameter("costprice"));
		if (costprice.equals("")) { costprice = "0";}
	String assettypeid = Util.null2String(fu.getParameter("assettypeid"));
	String assetunitid = Util.null2String(fu.getParameter("assetunitid"));
	String replaceassetid = Util.null2String(fu.getParameter("replaceassetid"));
	String assetversion = Util.fromScreen(fu.getParameter("assetversion"),user.getLanguage());
	String counttypeid = Util.null2String(fu.getParameter("counttypeid"));
	String assetimageid= Util.null2String(fu.uploadFiles("assetimage"));
	String oldassetimageid= Util.null2String(fu.getParameter("oldassetimage"));
	if(assetimageid.equals("") && operation.equalsIgnoreCase("addasset")) 
		assetimageid="0" ;
	if(assetimageid.equals("") && operation.equalsIgnoreCase("editasset"))       
	    assetimageid=oldassetimageid ;
	String assortmentid = Util.null2String(fu.getParameter("assortmentid"));
	String assortmentstr = Util.null2String(fu.getParameter("assortmentstr"));
	String assetattribute = Util.null2String(fu.getParameter("assetattribute"));

	String supassortmentstr = "" ;

	if(!assortmentid.equals("")){
	RecordSet.executeProc("LgcAssetAssortment_SelectByID",assortmentid);
	RecordSet.next();
	supassortmentstr = Util.null2String(RecordSet.getString("supassortmentstr")) ;
	assortmentstr = supassortmentstr+assortmentid+"|";
	}

	String tmpstr1 = "";
	String tmpstr2 = "";
	String tpara = "";
	String npara = "";
	String dpara = "";
	String bpara = "";

	for (int i=1;i<6;i++){
		tmpstr1 = "tff0"+i;
		if (!(tmpstr2=Util.fromScreen(fu.getParameter(tmpstr1),user.getLanguage())).equals(""))
			tpara +=separator+tmpstr2;
		else
			tpara +=separator+"";
	}

	for (int i=1;i<6;i++){
		tmpstr1 = "nff0"+i;
		if (!(tmpstr2=Util.fromScreen(fu.getParameter(tmpstr1),user.getLanguage())).equals(""))
			npara +=separator+tmpstr2;
		else
			npara +=separator+"";
	}

	for (int i=1;i<6;i++){
		tmpstr1 = "dff0"+i;
		if (!(tmpstr2=Util.fromScreen(fu.getParameter(tmpstr1),user.getLanguage())).equals(""))
			dpara +=separator+tmpstr2;
		else
			dpara +=separator+"";
	}

	for (int i=1;i<6;i++){
		tmpstr1 = "bff0"+i;
		if (!(tmpstr2=Util.fromScreen(fu.getParameter(tmpstr1),user.getLanguage())).equals(""))
			bpara +=separator+tmpstr2;
		else
			bpara +=separator+"";
	}
	
	String createrid = ""+user.getUID();
	String createdate = currentdate ;
	String lastmodid = ""+user.getUID();
	String lastmoddate = currentdate ;


    if(operation.equals("addasset")){
	String para = "";
	
	para  = assetmark;
	para += separator+barcode;
	para += separator+seclevel;
	para += separator+assetimageid;
	para += separator+assettypeid;
	para += separator+assetunitid;
	para += separator+replaceassetid;
	para += separator+assetversion;
	para += separator+assetattribute;
	para += separator+counttypeid;
	para += separator+assortmentid;
	para += separator+assortmentstr;
	para += separator+relatewfid;
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
	
	RecordSet.executeProc("LgcAsset_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);
	if(id == -1)  {
		response.sendRedirect("LgcAssetAdd.jsp?msgid=12&paraid="+assortmentid);
		return ;
	}
/*
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName(assetmark +"-"+assetname);
    SysMaintenanceLog.setOperateItem("51");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("LgcAsset_Insert,"+para);
	SysMaintenanceLog.setSysLogInfo();
*/


	//更新各产品类别中的产品总数－－－－－Ｂｅｇｉｎ
	String sqlTemp = "" ;
	String supassortmentStrTemp = Util.StringReplace(supassortmentstr,"|",",") ;
	supassortmentStrTemp = supassortmentStrTemp.substring(0,supassortmentStrTemp.length()-1);

	sqlTemp = "select id, assetcount from LgcAssetAssortment where id in (" + supassortmentStrTemp + ") " ;	
	RecordSet.executeSql(sqlTemp);
	while(RecordSet.next())
	{
		int assetIdTemp = Util.getIntValue(RecordSet.getString("id"),0);
		int assetCountTemp = Util.getIntValue(RecordSet.getString("assetcount"),0);
		assetCountTemp +=1;
		sqlTemp = "update LgcAssetAssortment set assetcount = " + assetCountTemp + " where id = " + assetIdTemp;
		RecordSetV.executeSql(sqlTemp);
	}
	//更新各产品类别中的产品总数－－－－－Ｅｎｄ



	AssetComInfo.removeAssetCache() ;
	LgcAssortmentComInfo.removeLgcAssortmentCache() ;
	response.sendRedirect("LgcAssetAdd.jsp?isclose=1&paraid="+assortmentid+"&assortmentstr="+assortmentstr);   
		
  } //end (operation.equals("addassetment"))
  else if(operation.equals("editasset")){
  	String assetid = Util.null2String(fu.getParameter("assetid"));
	String assetcountryid = Util.null2String(fu.getParameter("assetcountryid"));
	String isdefault = Util.null2String(fu.getParameter("isdefault"));

	//更新各产品类别中的产品总数－－－－－Ｂｅｇｉｎ
	String sqlTemp = "" ;
	String supassortmentStrTemp = "" ;
	sqlTemp = "select assortmentstr from LgcAsset where id = " + assetid ;
	RecordSet.executeSql(sqlTemp);
	if (RecordSet.next()) 
	supassortmentStrTemp = Util.null2String(RecordSet.getString("assortmentstr"));
	//更新各产品类别中的产品总数－－－－－Ｅｎｄ

	if(assetcountryid.equals("")) assetcountryid="0";
	if(isdefault.equals("")) isdefault="1";

	String para = "";
	para  = assetid; 
	para += separator+assetcountryid;
	para += separator+barcode;
	para += separator+seclevel;
	para += separator+assetimageid;
	para += separator+assettypeid;
	para += separator+assetunitid;
	para += separator+replaceassetid;
	para += separator+assetversion;
	para += separator+assetattribute;
	para += separator+counttypeid;
	para += separator+assortmentid;
	para += separator+assortmentstr;
	para += separator+relatewfid;
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
	para += separator+lastmodid;
	para += separator+lastmoddate;
	para += separator+isdefault;
	
	RecordSet.executeProc("LgcAsset_Update",para);

	if(RecordSet.next()) {
		response.sendRedirect("LgcAsset.jsp?paraid="+assetid+"&assetcountryid="+assetcountryid+"&msgid=13");
		return ;
	}
/*	
    SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(Util.getIntValue(assetid));
	SysMaintenanceLog.setRelatedName(assetmark +"-"+assetname);
	SysMaintenanceLog.setOperateType("2");
	SysMaintenanceLog.setOperateDesc("LgcAsset_Update,"+para);
	SysMaintenanceLog.setOperateItem("51");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();
*/


	//更新各产品类别中的产品总数－－－－－Ｂｅｇｉｎ

	if (!supassortmentStrTemp.equals(assortmentstr)){
		
		supassortmentStrTemp = Util.StringReplace(supassortmentStrTemp,"|",",") ;
		supassortmentStrTemp = supassortmentStrTemp.substring(0,supassortmentStrTemp.length()-1);

		sqlTemp = "select id, assetcount from LgcAssetAssortment where id in (" + supassortmentStrTemp + ") " ;	
		RecordSet.executeSql(sqlTemp);
		while(RecordSet.next())
		{
			int assetIdTemp = Util.getIntValue(RecordSet.getString("id"),0);
			int assetCountTemp = Util.getIntValue(RecordSet.getString("assetcount"),0);
			assetCountTemp -=1;
			sqlTemp = "update LgcAssetAssortment set assetcount = " + assetCountTemp + " where id = " + assetIdTemp;
			RecordSetV.executeSql(sqlTemp);
		}

		supassortmentStrTemp = assortmentstr ;
		supassortmentStrTemp = Util.StringReplace(supassortmentStrTemp,"|",",") ;
		supassortmentStrTemp = supassortmentStrTemp.substring(0,supassortmentStrTemp.length()-1);

		sqlTemp = "select id, assetcount from LgcAssetAssortment where id in (" + supassortmentStrTemp + ") " ;	
		RecordSet.executeSql(sqlTemp);
		while(RecordSet.next())
		{
			int assetIdTemp = Util.getIntValue(RecordSet.getString("id"),0);
			int assetCountTemp = Util.getIntValue(RecordSet.getString("assetcount"),0);
			assetCountTemp +=1;
			sqlTemp = "update LgcAssetAssortment set assetcount = " + assetCountTemp + " where id = " + assetIdTemp;
			RecordSetV.executeSql(sqlTemp);
		}
	}

	//更新各产品类别中的产品总数－－－－－Ｅｎｄ

	AssetComInfo.removeAssetCache() ;
	LgcAssortmentComInfo.removeLgcAssortmentCache() ;

	response.sendRedirect("LgcAssetEdit.jsp?isclose=1&assortmentid="+assortmentid); 
 }///end if (operation.equals("editassetment"))  
}//end if (operation.equals("addassetment")||operation.equals("editassetment"))
 else if(operation.equals("deleteasset")){
	if(!HrmUserVarify.checkUserRight("CrmProduct:Add",user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
  	int assetid = Util.getIntValue(fu.getParameter("assetid"));
  	String _assortmentid = Util.null2String(fu.getParameter("assortmentid"));
	String assetcountryid = Util.null2String(fu.getParameter("assetcountryid"));


	String assetmark = Util.fromScreen(fu.getParameter("assetmark"),user.getLanguage());
	String assetname = Util.fromScreen(fu.getParameter("assetname"),user.getLanguage());

	//更新各产品类别中的产品总数－－－－－Ｂｅｇｉｎ
	String sqlTemp = "" ;
	String supassortmentStrTemp = "" ;
	String supassortmentIDTemp = "" ;
	sqlTemp = "select assortmentid,assortmentstr from LgcAsset where id = " + assetid ;
	String restr_supassortmentStrTemp = "";
	RecordSet.executeSql(sqlTemp);
	if (RecordSet.next()) {
		supassortmentIDTemp = Util.null2String(RecordSet.getString("assortmentid"));
		restr_supassortmentStrTemp = Util.null2String(RecordSet.getString("assortmentstr"));
		sqlTemp = "select supassortmentstr from LgcAssetAssortment where id = " + supassortmentIDTemp ;
		RecordSet.executeSql(sqlTemp);
		if (RecordSet.next()) {
			supassortmentStrTemp = Util.null2String(RecordSet.getString("supassortmentstr"));
			supassortmentStrTemp = Util.StringReplace(supassortmentStrTemp,"|",",") ;
			supassortmentStrTemp = supassortmentStrTemp.substring(0,supassortmentStrTemp.length()-1);

			sqlTemp = "select id, assetcount from LgcAssetAssortment where id in (" + supassortmentStrTemp + ") " ;	
			RecordSet.executeSql(sqlTemp);
			while(RecordSet.next())
			{
				int assetIdTemp = Util.getIntValue(RecordSet.getString("id"),0);
				int assetCountTemp = Util.getIntValue(RecordSet.getString("assetcount"),0);
				assetCountTemp -=1;
				sqlTemp = "update LgcAssetAssortment set assetcount = " + assetCountTemp + " where id = " + assetIdTemp;
				RecordSetV.executeSql(sqlTemp);
			}
		}
	}
	//更新各产品类别中的产品总数－－－－－Ｅｎｄ

	String para = ""+assetid;
	       para += separator+assetcountryid;
	RecordSet.executeProc("LgcAsset_Delete",para);

	if(RecordSet.next() && RecordSet.getString(1).equals("-1")){
		response.sendRedirect("LgcAssetEdit.jsp?paraid="+assetid+"&assetcountryid="+assetcountryid+"&msgid=20");
		return ;
	}
/*
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(assetid);
      SysMaintenanceLog.setRelatedName(assetmark +"-"+assetname);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("LgcAsset_Delete,"+para);
      SysMaintenanceLog.setOperateItem("51");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
*/	  
	

	AssetComInfo.removeAssetCache() ;
	LgcAssortmentComInfo.removeLgcAssortmentCache() ;
	String isajax = Util.null2String(request.getParameter("ajax"));
	if(isajax.equals("1"))
	{
		out.clear();
		out.print(restr_supassortmentStrTemp);
	}else
	response.sendRedirect("/lgc/search/LgcProductListInner.jsp?assortmentid="+_assortmentid);
	
 }
%>
