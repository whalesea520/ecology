<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
int userid=user.getUID();
String pagename=Util.null2String((String)session.getAttribute("fav_pagename"));
String uri=Util.null2String((String)session.getAttribute("fav_uri"));
String querystring=Util.null2String((String)session.getAttribute("fav_querystring"));
String urlname="";

if(!querystring.equals("")){
	querystring=Util.replaceChar(querystring,'^','&');
	urlname=uri+"?"+querystring;
}
else{
	urlname=uri;
}

char separator = Util.getSeparator();
String procedurepara="";
Calendar today = Calendar.getInstance();
int year=today.get(Calendar.YEAR);
int month=today.get(Calendar.MONTH)+1;
int day=today.get(Calendar.DATE);
int hour=today.getTime().getHours();
int minute=today.getTime().getMinutes();
int second=today.getTime().getSeconds();
String date = Util.add0(year, 4) +"-"+Util.add0(month, 2) +"-"+Util.add0(day, 2) ;
String time= Util.add0(hour,2)+":"+Util.add0(minute,2)+":"+Util.add0(second,2);

procedurepara=userid+"" + separator + date + separator + time + separator + pagename + separator + urlname;
if(!urlname.equals("")){
	RecordSet.executeProc("SysFavourite_Insert",procedurepara);
    RecordSet.next();
    //System.out.println(" value= " +RecordSet.getInt(1));
    if(RecordSet.getInt(1)==0){
        session.setAttribute("fav_addfavsuccess","1");
        response.sendRedirect(urlname);
    }else{
        response.sendRedirect(urlname);
    }
}

%>
