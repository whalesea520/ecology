<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%

String operation = Util.null2String(request.getParameter("operation"));
String catalogid = Util.null2String(request.getParameter("catalogid"));
String assetid = Util.null2String(request.getParameter("assetid"));
String webshopreturn = Util.null2String(request.getParameter("webshopreturn"));
String theassortment = Util.null2String(request.getParameter("theassortment"));
String selectedid = Util.null2String(request.getParameter("selectedid"));
String thecountry = Util.null2String(request.getParameter("thecountry"));
String theassetcountry = Util.null2String(request.getParameter("theassetcountry"));
String theattributes = Util.null2String(request.getParameter("theattributes"));
String isthenew = Util.null2String(request.getParameter("isthenew"));
String start = Util.null2String(request.getParameter("start"));
String webshoptype = Util.null2String(request.getParameter("webshoptype"));
String webshopmanageid = Util.null2String(request.getParameter("webshopmanageid"));
String userid = ""+ user.getUID() ;
int cookieage = 3*60*60*24 ;

if(operation.equals("add")) {
	int buyitemcount = Util.getIntValue(Util.getCookie(request, "CoItem_"+userid+"_"+assetid+"_"+thecountry),-1) ;
	int buycount = Util.getIntValue(Util.getCookie(request, "CoItemAll_"+userid),-1) ;

	if(buyitemcount == -1) buyitemcount = 1 ;
	else buyitemcount = buyitemcount+1 ;
	if(buycount == -1) buycount = 1 ;
	else buycount = buycount+1 ;

	Util.setCookie(response , "CoItem_"+userid+"_"+assetid+"_"+thecountry , ""+buyitemcount , cookieage) ;
	Util.setCookie(response , "CoItemAll_"+userid , ""+buycount , cookieage) ;

	if(webshopreturn.equals("1")) 
	response.sendRedirect("LgcCatalogsView.jsp?id="+catalogid+"&theassortment="+theassortment+"&selectedid="+selectedid+"&thecountry="+thecountry+"&theattributes="+theattributes+"&isthenew=0&start="+start);
	else
	response.sendRedirect("LgcAssetBasket.jsp?catalogid="+catalogid+"&theassortment="+theassortment+"&selectedid="+selectedid+"&thecountry="+thecountry+"&theattributes="+theattributes+"&isthenew=0&start="+start+"&webshoptype="+webshoptype+"&webshopmanageid="+webshopmanageid);
}

if(operation.equals("delete")) {
	String cookiename = Util.null2String(request.getParameter("thecookiename"));
    int buyitemcount = Util.getIntValue(Util.getCookie(request,cookiename)) ;
	Util.setCookie(response , cookiename , "" , 0) ;
	int buycount = Util.getIntValue(Util.getCookie(request, "CoItemAll_"+userid)) - buyitemcount ;
	Util.setCookie(response , "CoItemAll_"+userid , ""+buycount , cookieage) ;

	response.sendRedirect("LgcAssetBasket.jsp?catalogid="+catalogid+"&theassortment="+theassortment+"&selectedid="+selectedid+"&thecountry="+thecountry+"&theattributes="+theattributes+"&isthenew=0&start="+start+"&webshoptype="+webshoptype+"&webshopmanageid="+webshopmanageid);
}

if(operation.equals("addasset")) {
	int buyitemcount = Util.getIntValue(Util.getCookie(request, "CoItem_"+userid+"_"+assetid+"_"+theassetcountry),-1) ;
	int buycount = Util.getIntValue(Util.getCookie(request, "CoItemAll_"+userid),-1) ;

	if(buyitemcount == -1) buyitemcount = 1 ;
	else buyitemcount = buyitemcount+1 ;
	if(buycount == -1) buycount = 1 ;
	else buycount = buycount+1 ;

	Util.setCookie(response , "CoItem_"+userid+"_"+assetid+"_"+theassetcountry , ""+buyitemcount , cookieage) ;
	Util.setCookie(response , "CoItemAll_"+userid , ""+buycount , cookieage) ;

	response.sendRedirect("LgcAssetBasket.jsp?catalogid="+catalogid+"&theassortment="+theassortment+"&selectedid="+selectedid+"&thecountry="+thecountry+"&theattributes="+theattributes+"&isthenew=0&start="+start+"&webshoptype="+webshoptype+"&webshopmanageid="+webshopmanageid);
}

if(operation.equals("change")) {
	Enumeration theparanames = request.getParameterNames() ;
	int buycount = 0 ;
	while(theparanames.hasMoreElements()) {
		String paraname = (String)theparanames.nextElement() ;
		if(paraname.indexOf("CoItem_"+userid+"_") <0) continue ;
		int paravalue = Util.getIntValue(request.getParameter(paraname),-1) ;
		if(paravalue <0) paravalue = Util.getIntValue(Util.getCookie(request, paraname),0) ;
		if(paravalue == 0 ) {
			Util.setCookie(response , paraname , "" , 0) ;
			continue ;
		}
		buycount += paravalue ;
		Util.setCookie(response , paraname , ""+paravalue , cookieage) ;
	}

	Util.setCookie(response , "CoItemAll_"+userid , ""+buycount , cookieage) ;

	response.sendRedirect("LgcAssetBasket.jsp?catalogid="+catalogid+"&theassortment="+theassortment+"&selectedid="+selectedid+"&thecountry="+thecountry+"&theattributes="+theattributes+"&isthenew=0&start="+start+"&webshoptype="+webshoptype+"&webshopmanageid="+webshopmanageid);
}

if(operation.equals("userinfo")) {
	Enumeration theparanames = request.getParameterNames() ;
	int buycount = 0 ;
	while(theparanames.hasMoreElements()) {
		String paraname = (String)theparanames.nextElement() ;
		if(paraname.indexOf("CoItem_"+userid+"_") <0) continue ;
		int paravalue = Util.getIntValue(request.getParameter(paraname),-1) ;
		if(paravalue <0) paravalue = Util.getIntValue(Util.getCookie(request, paraname),0) ;
		if(paravalue == 0 ) {
			Util.setCookie(response , paraname , "" , 0) ;
			continue ;
		}
		buycount += paravalue ;
		Util.setCookie(response , paraname , ""+paravalue , cookieage) ;
	}

	Util.setCookie(response , "CoItemAll_"+userid , ""+buycount , cookieage) ;

	response.sendRedirect("LgcBasketUserInfo.jsp?catalogid="+catalogid+"&theassortment="+theassortment+"&selectedid="+selectedid+"&thecountry="+thecountry+"&theattributes="+theattributes+"&isthenew=0&start="+start+"&webshoptype="+webshoptype+"&webshopmanageid="+webshopmanageid);
}


if(operation.equals("confirm")) {
	Enumeration theparanames = request.getParameterNames() ;
	int buycount = 0 ;
	while(theparanames.hasMoreElements()) {
		String paraname = (String)theparanames.nextElement() ;
		if(paraname.indexOf("CoItem_"+userid+"_") <0) continue ;
		int paravalue = Util.getIntValue(request.getParameter(paraname),-1) ;
		if(paravalue <0) paravalue = Util.getIntValue(Util.getCookie(request, paraname),0) ;
		if(paravalue == 0 ) {
			Util.setCookie(response , paraname , "" , 0) ;
			continue ;
		}
		buycount += paravalue ;
		Util.setCookie(response , paraname , ""+paravalue , cookieage) ;
	}

	Util.setCookie(response , "CoItemAll_"+userid , ""+buycount , cookieage) ;

	response.sendRedirect("LgcBasketConfirm.jsp?catalogid="+catalogid+"&theassortment="+theassortment+"&selectedid="+selectedid+"&thecountry="+thecountry+"&theattributes="+theattributes+"&isthenew=0&start="+start+"&webshoptype="+webshoptype+"&webshopmanageid="+webshopmanageid);
}

if(operation.equals("adduserinfo")) {
	

	String username = Util.fromScreen(request.getParameter("username"),user.getLanguage());
	String useremail = Util.fromScreen(request.getParameter("useremail"),user.getLanguage());
	String receiveaddress = Util.fromScreen(request.getParameter("receiveaddress"),user.getLanguage());
	String postcode = Util.fromScreen(request.getParameter("postcode"),user.getLanguage());
	String telephone1 = Util.fromScreen(request.getParameter("telephone1"),user.getLanguage());
	String telephone2 = Util.fromScreen(request.getParameter("telephone2"),user.getLanguage());
	String purchaseremark = Util.fromScreen(request.getParameter("purchaseremark"),user.getLanguage());

	user.setLastname(username) ;
	user.setEmail(useremail) ;
	user.setReceiveaddress(receiveaddress) ;
	user.setPostcode(postcode) ;
	user.setTelephone(telephone1) ;
	user.setMobile(telephone2) ;
	user.setRemark(purchaseremark) ;
	
	response.sendRedirect("LgcBasketConfirm.jsp?catalogid="+catalogid+"&theassortment="+theassortment+"&selectedid="+selectedid+"&thecountry="+thecountry+"&theattributes="+theattributes+"&isthenew=0&start="+start+"&webshoptype="+webshoptype+"&webshopmanageid="+webshopmanageid);
}



if(operation.equals("endsubmit")) {
	RecordSet rs = new RecordSet() ;
	char separator = Util.getSeparator() ;

	String usertype = "" ;
	if(webshoptype.equals("0")) usertype = "0" ;
	else {
		String theusertype = user.getResourcetype() ;
		if(theusertype.equals("F") || theusertype.equals("H") || theusertype.equals("D") || theusertype.equals("T"))  usertype = "9" ; 
		else if(theusertype.equals("O")) usertype = "2" ; 
		else usertype = "1" ; 
	}
	String currencyid = Util.null2String(request.getParameter("thecurrencyid"));
	String purchasecount = Util.null2String(request.getParameter("pricecount"));	
	String username = user.getUsername() ;
	String usercountry = user.getCountryid() ;
	String useremail = user.getEmail() ;
	String receiveaddress = user.getReceiveaddress() ;
	String postcode = user.getPostcode() ;
	String telephone1 = user.getTelephone() ;
	String telephone2 = user.getMobile() ;
	String receivetype = "" ;
	String paymentmode = "1" ;
	String purchaseremark = user.getRemark() ;
	Calendar today = Calendar.getInstance();
	String purchasedate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;


	String para = usertype + separator + userid + separator + username + separator + usercountry 
				  + separator + useremail + separator + receiveaddress + separator + receivetype 
				  + separator + postcode + separator + telephone1 + separator + telephone2 
				  + separator + paymentmode + separator + currencyid + separator + purchasecount
				  + separator + purchaseremark + separator + purchasedate + separator + webshopmanageid;

	rs.executeProc("LgcWebShop_Insert",para);
	rs.next() ;
	String id = rs.getString(1) ;


	Cookie thecookies[] = request.getCookies() ;
	if(thecookies != null) {
		for(int i=0 ; i<thecookies.length ; i++) {
			String cookiename = thecookies[i].getName() ;
			if(cookiename.indexOf("CoItem_"+userid+"_") <0) continue ;
			String tempstr[] = Util.TokenizerString2(cookiename,"_") ;
			String theassetid = tempstr[2] ;
			String countryid = tempstr[3] ;
			String purchasenum = Util.null2String(Util.getCookie(request,cookiename)) ;
			para = theassetid + separator + countryid + separator + purchasenum ; 
			rs.executeProc("LgcAssetPrice_Select",para);
			rs.next() ;
			String assetprice = Util.null2String(rs.getString(1)) ;
			String taxrate = Util.null2String(rs.getString(2)) ;
			String thecurrencyid = Util.null2String(rs.getString(3));
			
			para = id + separator + theassetid + separator + countryid + separator + thecurrencyid 
			+ separator + assetprice + separator + taxrate + separator + purchasenum ;
			
			rs.executeProc("LgcWebShopDetail_Insert",para);

			Util.setCookie(response , cookiename , "" , 0) ;
		}
	}
	Util.setCookie(response , "CoItemAll_"+userid , "" , 0) ;

	response.sendRedirect("LgcCatalogsView.jsp?id="+catalogid+"&theassortment="+theassortment+"&selectedid="+selectedid+"&thecountry="+thecountry+"&theattributes="+theattributes+"&isthenew=0&start="+start);
}

%>