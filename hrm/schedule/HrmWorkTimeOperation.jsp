<%@ page import="weaver.general.*" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="HrmTimeCardManage" class="weaver.hrm.schedule.HrmTimeCardManage" scope="page"/>
<jsp:useBean id="HrmKqSystemComInfo" class="weaver.hrm.schedule.HrmKqSystemComInfo" scope="page" />

<%

char separator = Util.getSeparator() ;
String procedurepara="";

String operation = Util.null2String(request.getParameter("operation")) ;
String workdate = Util.null2String(request.getParameter("workdate")) ; // 

int salaryyear = Util.getIntValue(workdate.substring(0 , 4)) ;
int salarymonth = Util.getIntValue(workdate.substring(5 , 7)) ;
int salaryendday = Util.getIntValue(HrmKqSystemComInfo.getSalaryenddate(),31) ;

Calendar thedate = Calendar.getInstance ();
thedate.set( salaryyear , salarymonth-1, salaryendday) ; 
String enddate =  Util.add0(thedate.get(Calendar.YEAR) , 4) + "-" + 
                Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
                Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 

thedate.set( salaryyear , salarymonth-2, salaryendday) ; 
thedate.add(Calendar.DATE , 1) ; 
String startdate =  Util.add0(thedate.get(Calendar.YEAR) , 4) + "-" + 
                Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
                Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 


// 获得所有的排班种类
ArrayList shiftids = new ArrayList() ; 
ArrayList shiftcounts = new ArrayList() ; 

RecordSet.executeSql("select id from HrmArrangeShift where ishistory='0' order by id ") ; 
while ( RecordSet.next() ) { 
    String id = Util.null2String(RecordSet.getString("id")) ; 
    shiftids.add(id) ; 
    shiftcounts.add("") ; 
} 
shiftids.add("0") ;         // 一般工作时间
shiftcounts.add("") ;


// 初始化计算表, 
RecordSet.executeSql(" delete HrmWorkTimeCount where workdate = '" +workdate+ "' " ) ; 


if( operation.equals("create") ) {

    boolean initTimecardInfo = HrmTimeCardManage.initTimecardInfo(startdate,enddate) ;

    if(!initTimecardInfo) {
        response.sendRedirect("HrmWorkTimeList.jsp?workdate="+workdate+"&errmsg=1");
        return ;
    }



    // 获得一般工作时间,判断休息日
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

    RecordSet.executeProc("HrmSchedule_Select_Current" , startdate) ; 
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

    if( sunstarttime1.equals("") && sunendtime1.equals("") && sunstarttime2.equals("") && sunendtime2.equals("") )   weekrestdays.add("1") ;
    if( monstarttime1.equals("") && monendtime1.equals("") && monstarttime2.equals("") && monendtime2.equals("") )   weekrestdays.add("2") ;
    if( tuestarttime1.equals("") && tueendtime1.equals("") && tuestarttime2.equals("") && tueendtime2.equals("") )   weekrestdays.add("3") ;
    if( wedstarttime1.equals("") && wedendtime1.equals("") && wedstarttime2.equals("") && wedendtime2.equals("") )   weekrestdays.add("4") ;
    if( thustarttime1.equals("") && thuendtime1.equals("") && thustarttime2.equals("") && thuendtime2.equals("") )   weekrestdays.add("5") ;
    if( fristarttime1.equals("") && friendtime1.equals("") && fristarttime2.equals("") && friendtime2.equals("") )   weekrestdays.add("6") ;
    if( satstarttime1.equals("") && satendtime1.equals("") && satstarttime2.equals("") && satendtime2.equals("") )   weekrestdays.add("7") ;


    // 获得当期的公众假日, 调整休息日，排除这些属于加班的出勤

    ArrayList holidaydatetypes = new ArrayList() ;      //公众假日和类型

    RecordSet.executeSql("select holidaydate , changetype, relateweekday from HrmPubHoliday where holidaydate>='" + startdate + "' and holidaydate <= '" + enddate + "' ") ; 
    while( RecordSet.next() ) {
        String holidaydate = Util.null2String(RecordSet.getString("holidaydate")) ;
        String changetype = Util.null2String(RecordSet.getString("changetype")) ;

        holidaydatetypes.add(holidaydate+"_"+changetype) ; 
    }

    // 得到正常上班的日期
    String realworkday = "" ;
    int fromyear = Util.getIntValue(startdate.substring(0 , 4)) ; 
    int frommonth = Util.getIntValue(startdate.substring(5 , 7)) ; 
    int fromday = Util.getIntValue(startdate.substring(8 , 10)) ; 
    String fromtempdate = startdate ; 
    
    thedate.set(fromyear,frommonth - 1 , fromday) ; 

    while( fromtempdate.compareTo(enddate) <= 0 ) {

        // 属于休息日并且没有被调整为工作日，不计入正常上班的日期
        if( weekrestdays.indexOf("" + thedate.get(Calendar.DAY_OF_WEEK)) != -1 && holidaydatetypes.indexOf(fromtempdate+"_2") == -1 ) {
            thedate.add(Calendar.DATE , 1) ; 
            fromtempdate =  Util.add0(thedate.get(Calendar.YEAR) , 4) + "-" + 
                        Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
                        Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 
            continue ;
        }
        
        // 如果被调整为假日或者休息日，不计入正常上班的日期
        if( holidaydatetypes.indexOf(fromtempdate+"_1") != -1 && holidaydatetypes.indexOf(fromtempdate+"_3") != -1 ) {
            thedate.add(Calendar.DATE , 1) ; 
            fromtempdate =  Util.add0(thedate.get(Calendar.YEAR) , 4) + "-" + 
                        Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
                        Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 
            continue ;
        }

        if( realworkday.equals("") ) realworkday = "'"+fromtempdate+"'" ;
        else realworkday += ",'"+fromtempdate+"'" ;

        thedate.add(Calendar.DATE , 1) ; 
        fromtempdate =  Util.add0(thedate.get(Calendar.YEAR) , 4) + "-" + 
                    Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
                    Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 
    } 

    // 获得所有当期的打卡信息
    RecordSet.executeSql(" select count(resourceid) as shiftcount , resourceid,  relateshiftid from HrmTimecardInfo where timecarddate >= '" + startdate + "' and timecarddate <= '"+ enddate + "' and " +
    " ( (timecarddate in ("+ realworkday +") and relateshiftid = 0 ) or relateshiftid > 0 ) " + 
    " group by resourceid , relateshiftid " ) ; 

    while( RecordSet.next() ) {
        String resourceid = Util.null2String(RecordSet.getString("resourceid")) ;
        String shiftid = Util.null2String(RecordSet.getString("relateshiftid")) ;
        String shiftcount = "" + Util.getIntValue(RecordSet.getString("shiftcount"), 0 ) ;

        procedurepara= resourceid + separator + workdate + separator + shiftid + separator + shiftcount ; 
        RecordSet.executeProc("HrmWorkTimeCount_Insert",procedurepara) ;
    }
}
else if( operation.equals("save") ) {

    RecordSet.executeSql(" select id from Hrmresource where status in (0,1,2,3) and id in (select resourceid from HrmTimecardUser where usercode is not null and usercode != '' ) ") ; 

    while( RecordSet.next() ) {
        String resourceid = Util.null2String(RecordSet.getString("id")) ;

        for( int i = 0 ; i< shiftids.size() ; i++ ) {
            String shiftid = (String)shiftids.get( i ) ;
            String shiftcount = Util.null2String(request.getParameter(resourceid+"_"+shiftid)) ;
            if( Util.getIntValue(shiftcount,0) == 0 ) continue ;

            procedurepara= resourceid + separator + workdate + separator + shiftid + separator + shiftcount ; 
            RecordSet.executeProc("HrmWorkTimeCount_Insert",procedurepara) ;
        }
    }
}

response.sendRedirect("HrmWorkTimeList.jsp?workdate="+workdate);

%>