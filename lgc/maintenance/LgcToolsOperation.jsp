<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.lgc.maintenance.AssetAssortmentComInfo" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;

if(operation.equals("attributemove")){
     
  	String assortmentid = Util.null2String(request.getParameter("assortmentid"));
	String issales_from = Util.null2String(request.getParameter("issales_from"));
	String issales_to = Util.null2String(request.getParameter("issales_to"));
	String ispurchase_from = Util.null2String(request.getParameter("ispurchase_from"));
	String ispurchase_to = Util.null2String(request.getParameter("ispurchase_to"));
	String isstock_from = Util.null2String(request.getParameter("isstock_from"));
	String isstock_to = Util.null2String(request.getParameter("isstock_to"));
	String iswebsales_from = Util.null2String(request.getParameter("iswebsales_from"));
	String iswebsales_to = Util.null2String(request.getParameter("iswebsales_to"));
	String isorder_from = Util.null2String(request.getParameter("isorder_from"));
	String isorder_to = Util.null2String(request.getParameter("isorder_to"));
	String para = "";
	int countid = 0 ;
	
	if(!issales_from.equals("")) {
		para = assortmentid + separator + "1|" ;
		if(issales_from.equals("0")) RecordSet.executeProc("LgcAttributeMove_Add",para);
		else RecordSet.executeProc("LgcAttributeMove_Remove",para);
		RecordSet.next() ;
		countid += RecordSet.getInt(1) ;
	}

	if(!ispurchase_from.equals("")) {
		para = assortmentid + separator + "2|" ;
		if(ispurchase_from.equals("0")) RecordSet.executeProc("LgcAttributeMove_Add",para);
		else RecordSet.executeProc("LgcAttributeMove_Remove",para);
		RecordSet.next() ;
		countid += RecordSet.getInt(1) ;
	}

	if(!isstock_from.equals("")) {
		para = assortmentid + separator + "3|" ;
		if(isstock_from.equals("0")) RecordSet.executeProc("LgcAttributeMove_Add",para);
		else RecordSet.executeProc("LgcAttributeMove_Remove",para);
		RecordSet.next() ;
		countid += RecordSet.getInt(1) ;
	}

	if(!iswebsales_from.equals("")) {
		para = assortmentid + separator + "4|" ;
		if(iswebsales_from.equals("0")) RecordSet.executeProc("LgcAttributeMove_Add",para);
		else RecordSet.executeProc("LgcAttributeMove_Remove",para);
		RecordSet.next() ;
		countid += RecordSet.getInt(1) ;
	}

	if(!isorder_from.equals("")) {
		para = assortmentid + separator + "5|" ;
		if(isorder_from.equals("0")) RecordSet.executeProc("LgcAttributeMove_Add",para);
		else RecordSet.executeProc("LgcAttributeMove_Remove",para);
		RecordSet.next() ;
		countid += RecordSet.getInt(1) ;
	}

	response.sendRedirect("LgcAttributeMove.jsp?countid="+countid);
 }
 else if(operation.equals("assortmentmove")){
     
  	String assortmentid1 = Util.null2String(request.getParameter("assortmentid1"));
	String assortmentid2 = Util.null2String(request.getParameter("assortmentid2"));
	String[] selectasset = request.getParameterValues("selectasset");
	
	String para = "" ;
	int countid = 0 ;
	
	if(selectasset != null) {
		for(int i=0 ; i< selectasset.length ; i++) {
			if(selectasset[i] != null) {
				para = assortmentid2 + separator + selectasset[i] ;
				RecordSet.executeProc("LgcAssortmentMove_Move",para);
				countid ++ ;
			}
		}
	}

	if(countid != 0) {
		AssetAssortmentComInfo ac = new AssetAssortmentComInfo() ;
		para = assortmentid1 + separator + assortmentid2 + separator + countid ;
		RecordSet.executeProc("LgcAssortmentMove_ChgCount",para);
		ac.removeAssetAssortmentCache() ;
	}

	response.sendRedirect("LgcAssortmentMove.jsp?countid="+countid);
 }
 else if(operation.equals("markchange")){
     
  	String assetid = Util.null2String(request.getParameter("assetid"));
	String assetmark = Util.null2String(request.getParameter("assetmark"));
	String msgid = "" ;
	
	String para = assetid + separator + assetmark ;
	RecordSet.executeProc("LgcAssetmark_Change",para);
	if(RecordSet.next()) msgid = "13" ;
	else msgid = "29" ;

	response.sendRedirect("LgcAssetmarkChg.jsp?msgid="+msgid);
 }
%>
