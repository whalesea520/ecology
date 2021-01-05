<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="log" class="weaver.systeminfo.SysMaintenanceLog" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String opera=Util.fromScreen(request.getParameter("operation"),user.getLanguage());
char separator = Util.getSeparator();
String procedurepara="";
int id=Util.getIntValue(request.getParameter("id"),0);
String countryid=Util.fromScreen(request.getParameter("countryid"),user.getLanguage());
String holidaydate=Util.null2String(request.getParameter("holidaydate"));
String holidayname=Util.fromScreenVoting(request.getParameter("holidayname"),user.getLanguage());
String changetype=Util.fromScreen(request.getParameter("changetype"),user.getLanguage());
String relateweekday=Util.fromScreen(request.getParameter("relateweekday"),user.getLanguage());
String year=Util.fromScreen(request.getParameter("year"),user.getLanguage());
String showtype=Util.fromScreen(request.getParameter("showtype"),user.getLanguage());

if(opera.equals("selectdate")){

    RecordSet.executeSql("select id from HrmPubHoliday where countryid =" + Util.getIntValue(request.getParameter("countryid"),0) + " and holidaydate = '"+ holidaydate +"' " );
    
	if(RecordSet.next()) {
        response.sendRedirect("HrmPubHolidayAdd.jsp?selectdate=2&countryid="+countryid+"&holidaydate="+holidaydate+"&showtype="+showtype+"&year="+year);
        return ;
    }

    // 获得一般工作时间,判断选择的日期是否为休息日
    String monstarttime1 = "" ; 
    String monendtime1 = "" ; 
    String monstarttime2 = "" ; 
    String monendtime2 = "" ;  

    String tuestarttime1 = "" ; 
    String tueendtime1 = "" ; 
    String tuestarttime2 = "" ;  
    String tueendtime2 = "" ; 

    String wedstarttime1 = "" ;  
    String wedendtime1 = "" ; 
    String wedstarttime2 = "" ; 
    String wedendtime2 = "" ; 

    String thustarttime1 = "" ; 
    String thuendtime1 = "" ; 
    String thustarttime2 = "" ; 
    String thuendtime2 = "" ;  

    String fristarttime1 = "" ; 
    String friendtime1 = "" ; 
    String fristarttime2 = "" ; 
    String friendtime2 = "" ; 

    String satstarttime1 = "" ; 
    String satendtime1 = "" ; 
    String satstarttime2 = "" ; 
    String satendtime2 = "" ; 

    String sunstarttime1 = "" ; 
    String sunendtime1 = "" ; 
    String sunstarttime2 = "" ; 
    String sunendtime2 = "" ; 

    ArrayList weekrestdays = new ArrayList() ;

    RecordSet.executeProc("HrmSchedule_Select_Current" , holidaydate) ; 
    if( RecordSet.next() ) {
        
        monstarttime1 = Util.null2String(RecordSet.getString("monstarttime1")) ;
        monendtime1 = Util.null2String(RecordSet.getString("monendtime1")) ;
        monstarttime2 = Util.null2String(RecordSet.getString("monstarttime2")) ;
        monendtime2 = Util.null2String(RecordSet.getString("monendtime2")) ;

        tuestarttime1 = Util.null2String(RecordSet.getString("tuestarttime1")) ;
        tueendtime1 = Util.null2String(RecordSet.getString("tueendtime1")) ;
        tuestarttime2 = Util.null2String(RecordSet.getString("tuestarttime2")) ;
        tueendtime2 = Util.null2String(RecordSet.getString("tueendtime2")) ;

        wedstarttime1 = Util.null2String(RecordSet.getString("wedstarttime1")) ;
        wedendtime1 = Util.null2String(RecordSet.getString("wedendtime1")) ;
        wedstarttime2 = Util.null2String(RecordSet.getString("wedstarttime2")) ;
        wedendtime2 = Util.null2String(RecordSet.getString("wedendtime2")) ;

        thustarttime1 = Util.null2String(RecordSet.getString("thustarttime1")) ;
        thuendtime1 = Util.null2String(RecordSet.getString("thuendtime1")) ;
        thustarttime2 = Util.null2String(RecordSet.getString("thustarttime2")) ;
        thuendtime2 = Util.null2String(RecordSet.getString("thuendtime2")) ;

        fristarttime1 = Util.null2String(RecordSet.getString("fristarttime1")) ;
        friendtime1 = Util.null2String(RecordSet.getString("friendtime1")) ;
        fristarttime2 = Util.null2String(RecordSet.getString("fristarttime2")) ;
        friendtime2 = Util.null2String(RecordSet.getString("friendtime2")) ;

        satstarttime1 = Util.null2String(RecordSet.getString("satstarttime1")) ;
        satendtime1 = Util.null2String(RecordSet.getString("satendtime1")) ;
        satstarttime2 = Util.null2String(RecordSet.getString("satstarttime2")) ;
        satendtime2 = Util.null2String(RecordSet.getString("satendtime2")) ; 

        sunstarttime1 = Util.null2String(RecordSet.getString("sunstarttime1")) ;
        sunendtime1 = Util.null2String(RecordSet.getString("sunendtime1")) ;
        sunstarttime2 = Util.null2String(RecordSet.getString("sunstarttime2")) ;
        sunendtime2 = Util.null2String(RecordSet.getString("sunendtime2")) ;
    }

    if( sunstarttime1.equals("") && sunendtime1.equals("") && sunstarttime2.equals("") && sunendtime2.equals("") )   weekrestdays.add("0") ;
    if( monstarttime1.equals("") && monendtime1.equals("") && monstarttime2.equals("") && monendtime2.equals("") )   weekrestdays.add("1") ;
    if( tuestarttime1.equals("") && tueendtime1.equals("") && tuestarttime2.equals("") && tueendtime2.equals("") )   weekrestdays.add("2") ;
    if( wedstarttime1.equals("") && wedendtime1.equals("") && wedstarttime2.equals("") && wedendtime2.equals("") )   weekrestdays.add("3") ;
    if( thustarttime1.equals("") && thuendtime1.equals("") && thustarttime2.equals("") && thuendtime2.equals("") )   weekrestdays.add("4") ;
    if( fristarttime1.equals("") && friendtime1.equals("") && fristarttime2.equals("") && friendtime2.equals("") )   weekrestdays.add("5") ;
    if( satstarttime1.equals("") && satendtime1.equals("") && satstarttime2.equals("") && satendtime2.equals("") )   weekrestdays.add("6") ;

    Calendar tempday = Calendar.getInstance();
    if(holidaydate.length()>0){
    	tempday.set(Util.getIntValue(holidaydate.substring(0,4)), Util.getIntValue(holidaydate.substring(5,7))-1,Util.getIntValue(holidaydate.substring(8,10)));
    }

    if(weekrestdays.indexOf(""+tempday.getTime().getDay()) != -1 ) {   // 休息日
        response.sendRedirect("HrmPubHolidayAdd.jsp?selectdate=1&countryid="+countryid+"&holidaydate="+holidaydate+"&selectdatetype=2"+"&showtype="+showtype+"&year="+year+"&isdialog=1");
        return ;
    }
    else {
        response.sendRedirect("HrmPubHolidayAdd.jsp?selectdate=1&countryid="+countryid+"&holidaydate="+holidaydate+"&selectdatetype=1"+"&showtype="+showtype+"&year="+year+"&isdialog=1");
        return ;
    } 

}
if(opera.equals("insert")){
	if(!HrmUserVarify.checkUserRight("HrmPubHolidayAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}


	procedurepara= countryid + separator + holidaydate + separator + holidayname + separator + changetype + separator + relateweekday ;
	RecordSet.executeProc("HrmPubHoliday_Insert",procedurepara);
	RecordSet.next();
	id= Util.getIntValue(RecordSet.getString(1),0);
	log.resetParameter();
	log.setRelatedId(id);
    log.setRelatedName(holidayname);
    log.setOperateType("1");
//  log.setOperateDesc("HrmSchedule_Insert");
    log.setOperateItem("21");
    log.setOperateUserid(user.getUID());
    log.setClientAddress(request.getRemoteAddr());
    log.setSysLogInfo();
    
    new weaver.hrm.schedule.HrmKqSystemComInfo().removeSystemCache() ;
    
    response.sendRedirect("HrmPubHolidayAdd.jsp?id="+id+"&isclose=1&countryid="+countryid+"&showtype="+showtype+"&year="+year);
}
if(opera.equals("save")){
	if(!HrmUserVarify.checkUserRight("HrmPubHolidayEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	procedurepara= ""+id + separator + holidayname + separator + changetype + separator + relateweekday ;
	RecordSet.executeProc("HrmPubHoliday_Update",procedurepara);
	log.resetParameter();
	log.setRelatedId(id);
        log.setRelatedName(holidayname);
      	log.setOperateType("2");
//      log.setOperateDesc("HrmSchedule_Insert");
      	log.setOperateItem("21");
      	log.setOperateUserid(user.getUID());
      	log.setClientAddress(request.getRemoteAddr());
      	log.setSysLogInfo();
      	
      	new weaver.hrm.schedule.HrmKqSystemComInfo().removeSystemCache() ;
      	
     	response.sendRedirect("HrmPubHolidayEdit.jsp?id="+id+"&isclose=1&countryid="+countryid+"&showtype="+showtype+"&year="+year);
}
if(opera.equals("delete")){
	if(!HrmUserVarify.checkUserRight("HrmPubHolidayEdit:Delete", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	RecordSet.executeSql("select holidayname from HrmPubHoliday where id ="+id);
	if(RecordSet.next())holidayname= RecordSet.getString("holidayname");
	RecordSet.executeProc("HrmPubHoliday_Delete",id+""+separator+countryid);
	RecordSet.next();
	if(RecordSet.getInt(1)==2){ %>
	<%=SystemEnv.getHtmlLabelName(497,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(423,user.getLanguage())%>
	<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(498,user.getLanguage())%><a href="HrmPubHoliday.jsp"><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></a>
	<%}
	else{

	log.resetParameter();
	log.setRelatedId(id);
        log.setRelatedName(holidayname);
      	log.setOperateType("3");
//      log.setOperateDesc("HrmSchedule_Insert");
      	log.setOperateItem("21");
      	log.setOperateUserid(user.getUID());
      	log.setClientAddress(request.getRemoteAddr());
      	log.setSysLogInfo();
      	
      	new weaver.hrm.schedule.HrmKqSystemComInfo().removeSystemCache() ;
      	
     		response.sendRedirect("HrmPubHolidayEdit.jsp?isclose=1&countryid="+countryid+"&showtype="+showtype+"&year="+year);
     	}
}
if(opera.equals("copy")){
	String fromyear=Util.fromScreen(request.getParameter("fromyear"),user.getLanguage());
	String toyear=Util.fromScreen(request.getParameter("toyear"),user.getLanguage());
	RecordSet.executeProc("HrmPubHoliday_Copy", fromyear+separator+toyear+separator+countryid);
	
	new weaver.hrm.schedule.HrmKqSystemComInfo().removeSystemCache() ;
	
	response.sendRedirect("HrmPubHoliday.jsp?countryid="+countryid+"&showtype="+showtype+"&year="+year);
}
%>