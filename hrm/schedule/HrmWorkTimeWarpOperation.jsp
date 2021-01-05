<%@ page import="weaver.general.*" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="HrmTimeCardManage" class="weaver.hrm.schedule.HrmTimeCardManage" scope="page"/>

<%

char separator = Util.getSeparator() ;
String procedurepara="";

String startdate = Util.null2String(request.getParameter("startdate")) ; // 从
String enddate = Util.null2String(request.getParameter("enddate")) ; // 到

Calendar thedate = Calendar.getInstance() ; 
String currentdate = Util.add0(thedate.get(Calendar.YEAR) , 4) + "-" + 
          Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
          Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ;

boolean initTimecardInfo = HrmTimeCardManage.initTimecardInfo(startdate,enddate) ;

if(!initTimecardInfo) {
    response.sendRedirect("HrmWorkTimeWarpList.jsp?fromdate="+startdate+"&enddate="+enddate+"&errmsg=1");
    return ;
}


// 获得一般工作时间
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

// 获得日期对应的星期 , 1为星期日， 2为星期一

ArrayList selectdates = new ArrayList() ; 
ArrayList selectweekdays = new ArrayList() ; 

int fromyear = Util.getIntValue(startdate.substring(0 , 4)) ; 
int frommonth = Util.getIntValue(startdate.substring(5 , 7)) ; 
int fromday = Util.getIntValue(startdate.substring(8 , 10)) ; 
String fromtempdate = startdate ; 

thedate.set(fromyear,frommonth - 1 , fromday) ; 

while( fromtempdate.compareTo(enddate) <= 0 ) {
    selectdates.add(fromtempdate) ; 
    selectweekdays.add("" + thedate.get(Calendar.DAY_OF_WEEK)) ; 

    thedate.add(Calendar.DATE , 1) ; 
    fromtempdate =  Util.add0(thedate.get(Calendar.YEAR) , 4) + "-" + 
                Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
                Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 
}


// 公众假日, 调整工作日 和 调整休息日 

ArrayList holidaydates = new ArrayList() ;      //公众假日
ArrayList changetypes = new ArrayList() ;       //调整类型  1：设置为法定假日 2： 设置为工作日 3： 设置为休息日
ArrayList workrelatedays = new ArrayList() ;      //调整为工作日对应的星期 1: 星期日 2:星期一 .... 7:星期六 

// "select holidaydate from HrmPubHoliday where countryid = "+countryid; 暂时未实现国家
RecordSet.executeSql("select holidaydate , changetype, relateweekday from HrmPubHoliday where holidaydate>='" + startdate + "' and holidaydate <= '" + enddate + "' ") ; 
while( RecordSet.next() ) {
    String holidaydate = Util.null2String(RecordSet.getString("holidaydate")) ;
    String changetype = Util.null2String(RecordSet.getString("changetype")) ;
    String relateweekday = Util.null2String(RecordSet.getString("relateweekday")) ;

    holidaydates.add(holidaydate) ; 
    changetypes.add(changetype) ; 
    workrelatedays.add(relateweekday) ; 
}



// 获得排班工作时间

ArrayList shiftids = new ArrayList() ;
ArrayList shiftbegintimes = new ArrayList() ;
ArrayList shiftendtimes = new ArrayList() ;

RecordSet.executeProc("HrmArrangeShift_Select" , "") ; 
while( RecordSet.next() ) {
    shiftids.add(Util.null2String(RecordSet.getString("id"))) ;
    shiftbegintimes.add(Util.null2String(RecordSet.getString("shiftbegintime"))) ;
    shiftendtimes.add(Util.null2String(RecordSet.getString("shiftendtime"))) ;
}

// 得到按照排班来管理的所有人员
ArrayList reesourceshifts = new ArrayList() ; 
RecordSet.executeSql("  select resourceid from HrmArrangeShiftSet "  ) ; 
while( RecordSet.next() ) { 
    String resourceid = Util.null2String(RecordSet.getString("resourceid")) ; 
    reesourceshifts.add( resourceid ) ; 
}


// 获得所有当期排班的信息

ArrayList shiftresources = new ArrayList() ;
ArrayList shifttypeids = new ArrayList() ;
RecordSet.executeSql(" select distinct resourceid,shiftdate,shiftid from HrmArrangeShiftInfo where shiftdate >= '" + startdate + "' and shiftdate <= '"+ enddate + "' ") ; 
while( RecordSet.next() ) {
    String resourceid = Util.null2String(RecordSet.getString("resourceid"));
    String shiftdate =   Util.null2String(RecordSet.getString("shiftdate"));
    String shiftid =   Util.null2String(RecordSet.getString("shiftid"));

    int reesourceshiftdateindex = shiftresources.indexOf(resourceid+"_"+shiftdate) ;
    if( reesourceshiftdateindex == -1 ) {
        shiftresources.add(resourceid+"_"+shiftdate) ;
        ArrayList tempshiftids = new ArrayList() ;
        tempshiftids.add(shiftid) ;
        shifttypeids.add(tempshiftids) ;
    }
    else {
        ArrayList tempshiftids = (ArrayList) shifttypeids.get(reesourceshiftdateindex) ;
        tempshiftids.add(shiftid) ;
        shifttypeids.set(reesourceshiftdateindex ,tempshiftids) ;
    }
}

// 获得所有当期的正常打卡信息

ArrayList timecardresources = new ArrayList() ;
ArrayList intimes = new ArrayList() ;
ArrayList outtimes = new ArrayList() ;
ArrayList relateshiftids = new ArrayList() ;

RecordSet.executeSql(" select * from HrmTimecardInfo where timecarddate >= '" + startdate + "' and timecarddate <= '"+ enddate + "' and relateshiftid != -1 ") ; 

while( RecordSet.next() ) {
    String resourceid = Util.null2String(RecordSet.getString("resourceid"));
    String timecarddate =   Util.null2String(RecordSet.getString("timecarddate"));
    String intime =   Util.null2String(RecordSet.getString("intime"));
    String outtime =   Util.null2String(RecordSet.getString("outtime"));
    String relateshiftid =   Util.null2String(RecordSet.getString("relateshiftid"));

    int timecardresourceindex = timecardresources.indexOf(resourceid+"_"+timecarddate) ;
    if( timecardresourceindex == -1 ) {
        timecardresources.add(Util.null2String(RecordSet.getString("resourceid")) + "_" +  Util.null2String(RecordSet.getString("timecarddate")) ) ;
        ArrayList tempintimes = new ArrayList() ;
        ArrayList tempouttimes = new ArrayList() ;
        ArrayList temprelateshiftids = new ArrayList() ;

        tempintimes.add(intime) ;
        tempouttimes.add(outtime) ;
        temprelateshiftids.add(relateshiftid) ;

        intimes.add(tempintimes) ;
        outtimes.add(tempouttimes) ;
        relateshiftids.add(temprelateshiftids) ;
    }
    else {
        ArrayList tempintimes = (ArrayList) intimes.get(timecardresourceindex) ;
        ArrayList tempouttimes = (ArrayList) outtimes.get(timecardresourceindex) ;
        ArrayList temprelateshiftids = (ArrayList) relateshiftids.get(timecardresourceindex) ;

        tempintimes.add(intime) ;
        tempouttimes.add(outtime) ;
        temprelateshiftids.add(relateshiftid) ;

        intimes.set(timecardresourceindex ,tempintimes) ;
        outtimes.set(timecardresourceindex ,tempouttimes) ;
        relateshiftids.set(timecardresourceindex ,temprelateshiftids) ;
    }
}


// 获得考勤增加类型的最小计算时间
int theminouttime = 0 ;
RecordSet.executeSql(" select min(mindifftime) from HrmScheduleDiff where difftype = '0' ") ; 
if( RecordSet.next() ) {
    theminouttime = Util.getIntValue( RecordSet.getString(1) , 0 ) ;
}


// 获得考勤减少类型的最小计算时间
ArrayList diffids = new ArrayList() ;
ArrayList diffmintimes = new ArrayList() ;

RecordSet.executeSql(" select id , mindifftime from HrmScheduleDiff where difftype = '1' ") ; 
if( RecordSet.next() ) {
    diffids.add(Util.null2String(RecordSet.getString("id"))) ;
    diffmintimes.add(Util.null2String(RecordSet.getString("mindifftime"))) ;
}

// 初始化计算表, 包括清除偏差表, 并将请假表的打卡时间记为0
RecordSet.executeSql(" delete HrmWorkTimeWarp where diffdate >= '" +startdate+ "' and diffdate <= '" +enddate+ "' " ) ; 
// RecordSet.executeSql( " update HrmScheduleMaintance set realcarddifftime = 0  " ) ; // 有问题



// 当期的输入加班的增加类型的偏差

RecordSet.executeSql(" select * from HrmTimecardInfo where timecarddate >= '" + startdate + "' and timecarddate <= '"+ enddate + "' and relateshiftid = -1 ") ; 

while( RecordSet.next() ) {
    String tempresourceid = Util.null2String(RecordSet.getString("resourceid")) ;
    String tempcarddate = Util.null2String(RecordSet.getString("timecarddate")) ;
    String tempintime = Util.null2String(RecordSet.getString("intime")) ;
    String tempouttime = Util.null2String(RecordSet.getString("outtime")) ;

    int theaps = Math.abs( Util.timediff1(tempintime,tempouttime ) ) ; 
    
    String counttime = "" + theaps ;

    if( theaps >= theminouttime ) {         // 大于增加类型最小的最小计算时间,才记入偏差
        String thediffid = "" ;
        String thedifftype = "0" ;
        String diffcounttime = "0" ;        // 考勤计算时间
        
        // 属于增加类型的考勤
        RecordSet2.executeSql( " select * from HrmScheduleMaintance where startdate <= '" + tempcarddate +"' and enddate >= '" + tempcarddate + "' and difftype = '0' and resourceid = " + tempresourceid ) ;

        if( RecordSet2.getCounts() < 2 ) {
            if( RecordSet2.next() ) {
                thediffid = Util.null2String(RecordSet2.getString("id")) ;
                diffcounttime = Util.null2String(RecordSet2.getString("realdifftime")) ;
            }
        }
        else {
            int theminaps = 9999999 ;

            while ( RecordSet2.next() ) {
                String tempdiffid = Util.null2String(RecordSet2.getString("id")) ;
                String tempstartdate = Util.null2String(RecordSet2.getString("startdate")) ;
                String tempstarttime = Util.null2String(RecordSet2.getString("starttime")) ;
                String tempenddate = Util.null2String(RecordSet2.getString("enddate")) ;
                String tempendtime = Util.null2String(RecordSet2.getString("endtime")) ;
                String temprealdifftime = Util.null2String(RecordSet2.getString("realdifftime")) ;

                // 进行初始赋值， 如果考勤没有时间填写，则用第一个找到的偏差
                if( thediffid.equals("") ) {
                    thediffid = tempdiffid ;
                    diffcounttime = temprealdifftime ;
                }

                if( tempstarttime.equals("") )  continue ;

                // 用入公司时间和加班开始时间比较

                theaps = Math.abs( Util.timediff1(tempstarttime,tempintime ) ) ;

                if( theaps < theminaps ) {
                    thediffid = tempdiffid ;
                    theminaps = theaps ;
                    diffcounttime = temprealdifftime ;
                }
            }
        }

        procedurepara= thediffid + separator + tempresourceid + separator + tempcarddate + separator + thedifftype + separator + tempintime + separator + tempouttime + separator + "" + separator + "" + separator + counttime + separator + diffcounttime ; 
        RecordSet.executeProc("HrmWorkTimeWarp_Insert",procedurepara) ;
    }
}






// 每人每日的偏差信息 ,只选择有对应打卡用户并且在职的用户

RecordSet.executeSql(" select id from Hrmresource where status in (0,1,2,3) and id in (select resourceid from HrmTimecardUser where usercode is not null and usercode != '' ) ") ; 

while( RecordSet.next() ) {
    String resourceid = Util.null2String(RecordSet.getString("id")) ;

    String tempdate = startdate ; 
    thedate.set(fromyear,frommonth - 1 , fromday) ; 
    while( tempdate.compareTo(enddate) <= 0 ) {

        // 该人该日应该的上下班时间和对应的排班id， 
        ArrayList theintimes = new ArrayList() ;
        ArrayList theouttimes = new ArrayList() ;
        ArrayList theshiftids = new ArrayList() ;

        
        // 检查该人是否按照排班来管理的所有人员
        int shiftindex = reesourceshifts.indexOf(resourceid) ;
        if( shiftindex != -1 ) {        // 该人以排班计算
            int shiftdateindex = shiftresources.indexOf(resourceid+"_"+tempdate) ;
            if( shiftdateindex != -1 ) { // 该人该天有排班
                ArrayList tempshiftids = (ArrayList) shifttypeids.get(shiftdateindex) ;
                for( int k = 0 ; k< tempshiftids.size() ; k++ ) {
                    String theshiftid = (String)tempshiftids.get(k) ;
                    int theshiftindex = shiftids.indexOf(theshiftid) ;
                    if( theshiftindex != -1 ) {
                        String theintime = (String)shiftbegintimes.get(theshiftindex) ;
                        String theouttime = (String)shiftendtimes.get(theshiftindex) ;
                        theintimes.add(theintime) ;
                        theouttimes.add(theouttime) ;
                        theshiftids.add(theshiftid) ;
                    }
                }
            }
        }
        else {                          // 否则以一般工作时间计算
            int theweekday = 0 ;
            String theintime = "" ;
            String theouttime = "" ;

            int holidayindex = holidaydates.indexOf(tempdate) ;
            if( holidayindex != -1 ) {   // 有调整时间
                String changetype = (String) changetypes.get( holidayindex ) ; 
                String relateweekday = (String) workrelatedays.get( holidayindex ) ; 
                if( changetype.equals("2") ) theweekday = Util.getIntValue(relateweekday , 0 ) ;
            }
            else {
                int weekdayindex = selectdates.indexOf(tempdate) ; 
                theweekday = Util.getIntValue((String)selectweekdays.get(weekdayindex)) ;
            }

            if( theweekday != 0 ) {
                switch (theweekday) {
                    case 1:
                        theintime = sunstarttime1 ;
                        theouttime = sunendtime2 ;
                        theintimes.add(theintime) ;
                        theouttimes.add(theouttime) ;
                        theshiftids.add("0") ;
                        break ;
                    case 2:
                        theintime = monstarttime1 ;
                        theouttime = monendtime2 ;
                        theintimes.add(theintime) ;
                        theouttimes.add(theouttime) ;
                        theshiftids.add("0") ;
                        break ;
                    case 3:
                        theintime = tuestarttime1 ;
                        theouttime = tueendtime2 ;
                        theintimes.add(theintime) ;
                        theouttimes.add(theouttime) ;
                        theshiftids.add("0") ;
                        break ;
                    case 4:
                        theintime = wedstarttime1 ;
                        theouttime = wedendtime2 ;
                        theintimes.add(theintime) ;
                        theouttimes.add(theouttime) ;
                        theshiftids.add("0") ;
                        break ;
                    case 5:
                        theintime = thustarttime1 ;
                        theouttime = thuendtime2 ;
                        theintimes.add(theintime) ;
                        theouttimes.add(theouttime) ;
                        theshiftids.add("0") ;
                        break ;
                    case 6:
                        theintime = fristarttime1 ;
                        theouttime = friendtime2 ;
                        theintimes.add(theintime) ;
                        theouttimes.add(theouttime) ;
                        theshiftids.add("0") ;
                        break ;
                    case 7:
                        theintime = satstarttime1 ;
                        theouttime = satendtime2 ;
                        theintimes.add(theintime) ;
                        theouttimes.add(theouttime) ;
                        theshiftids.add("0") ;
                        break ;
                }
            }
        }

        // 实际的上下班打卡时间
        ArrayList realintimes = new ArrayList() ;
        ArrayList realouttimes = new ArrayList() ;
        ArrayList realshiftids = new ArrayList() ;

        int timecardindex = timecardresources.indexOf(resourceid+"_"+tempdate) ;
        if( timecardindex != -1 ) {        // 该人该日有打卡记录
            realintimes = (ArrayList) intimes.get(timecardindex) ;
            realouttimes = (ArrayList) outtimes.get(timecardindex) ;
            realshiftids = (ArrayList) relateshiftids.get(timecardindex) ;
        }
        
        // 对应考勤部变量变量
        String thediffid = "" ;
        String thedifftype = "" ;
        String counttime = "0" ;        // 实际计算时间
        String diffcounttime = "0" ;        // 考勤计算时间

        if( theshiftids.size() >= realshiftids.size() ) { // 当应该上班次数大于等于实际上班次数的时候， 用应该的作为基准
            
            for( int k = 0 ; k< theshiftids.size() ; k++ ) {
                String theshiftid = (String) theshiftids.get(k) ;
                String theintime = (String) theintimes.get(k) ;
                String theouttime = (String) theouttimes.get(k) ;

                int realshiftidindex = realshiftids.indexOf(theshiftid) ;
                if( realshiftidindex != -1 ) {      // 有对应的打卡记录
                    String intime = (String) realintimes.get(realshiftidindex) ;
                    String outtime = (String) realouttimes.get(realshiftidindex) ;

                    // 比较上班时间的差异

                    if( ( intime.length() < 5 || outtime.length() < 5 ) && theintime.length() == 5 && theouttime.length() == 5 ) {     // 某一个实际打卡时间缺少，属于减少类型
                        thediffid = "" ;
                        diffcounttime = "0" ; 
                        thedifftype = "1" ;
                        
                        RecordSet2.executeSql( " select * from HrmScheduleMaintance where startdate <= '" + tempdate +"' and enddate >= '" + tempdate + "' and difftype = '1' and resourceid = " + resourceid ) ;

                        if( RecordSet2.getCounts() < 2 ) {
                            if( RecordSet2.next() ) {
                                thediffid = Util.null2String(RecordSet2.getString("id")) ;
                                diffcounttime = Util.null2String(RecordSet2.getString("realdifftime")) ;
                            }
                        }
                        else {
                            int theminaps = 9999999 ;

                            while ( RecordSet2.next() ) {
                                String tempdiffid = Util.null2String(RecordSet2.getString("id")) ;
                                String tempstartdate = Util.null2String(RecordSet2.getString("startdate")) ;
                                String tempstarttime = Util.null2String(RecordSet2.getString("starttime")) ;
                                String tempenddate = Util.null2String(RecordSet2.getString("enddate")) ;
                                String tempendtime = Util.null2String(RecordSet2.getString("endtime")) ;
                                String temprealdifftime = Util.null2String(RecordSet2.getString("realdifftime")) ;
                                
                                // 进行初始赋值， 如果考勤没有时间填写，则用第一个找到的偏差
                                if( thediffid.equals("") ) {
                                    thediffid = tempdiffid ;
                                    diffcounttime = temprealdifftime ;
                                }


                                if( intime.equals("") && !tempstarttime.equals("") ) {              // 如果入公司打卡缺失，用入公司时间比较
                                    int theaps = Math.abs( Util.timediff1(tempstarttime,theintime ) ) ;
                                    if( theaps < 0 ) theaps = -1 * theaps ;

                                    if( theaps < theminaps ) {
                                        thediffid = tempdiffid ;
                                        theminaps = theaps ;
                                        diffcounttime = temprealdifftime ;
                                    }
                                }
                                else if( outtime.equals("") && !tempendtime.equals("") ) {                              // 用出公司时间比较  
                                    int theaps = Math.abs( Util.timediff1(tempendtime,theouttime ) ) ;
                                    if( theaps < 0 ) theaps = -1 * theaps ;

                                    if( theaps < theminaps ) {
                                        thediffid = tempdiffid ;
                                        theminaps = theaps ;
                                        diffcounttime = temprealdifftime ;
                                    }
                                }
                            }
                        }

                        counttime = "" + Math.abs( Util.timediff1(theouttime,theintime ) ) ;  

                        procedurepara= thediffid + separator + resourceid + separator + tempdate + separator + thedifftype + separator + intime + separator + outtime + separator + theintime + separator + theouttime + separator + counttime + separator + diffcounttime ; 
                        RecordSet.executeProc("HrmWorkTimeWarp_Insert",procedurepara) ;
                    }
                    else if( ( theintime.length() < 5 || theouttime.length() < 5 ) && intime.length() == 5 && outtime.length() == 5 ) {         // 属于增加类型
                        
                        int theaps = Math.abs( Util.timediff1(outtime,intime ) ) ;   
                        counttime = "" + theaps ;

                        if( theaps >= theminouttime ) {         // 大于增加类型最小的最小计算时间,才记入偏差
                            thediffid = "" ;
                            diffcounttime = "0" ; 
                            thedifftype = "0" ;
                        
                            RecordSet2.executeSql( " select * from HrmScheduleMaintance where startdate <= '" + tempdate +"' and enddate >= '" + tempdate + "' and difftype = '0' and resourceid = " + resourceid ) ;

                            if( RecordSet2.getCounts() < 2 ) {
                                if( RecordSet2.next() ) {
                                    thediffid = Util.null2String(RecordSet2.getString("id")) ;
                                    diffcounttime = Util.null2String(RecordSet2.getString("realdifftime")) ;
                                }
                            }
                            else {
                                int theminaps = 9999999 ;

                                while ( RecordSet2.next() ) {
                                    String tempdiffid = Util.null2String(RecordSet2.getString("id")) ;
                                    String tempstartdate = Util.null2String(RecordSet2.getString("startdate")) ;
                                    String tempstarttime = Util.null2String(RecordSet2.getString("starttime")) ;
                                    String tempenddate = Util.null2String(RecordSet2.getString("enddate")) ;
                                    String tempendtime = Util.null2String(RecordSet2.getString("endtime")) ;
                                    String temprealdifftime = Util.null2String(RecordSet2.getString("realdifftime")) ;

                                    // 进行初始赋值， 如果考勤没有时间填写，则用第一个找到的偏差
                                    if( thediffid.equals("") ) {
                                        thediffid = tempdiffid ;
                                        diffcounttime = temprealdifftime ;
                                    }

                                    if( tempstarttime.equals("") )  continue ;

                                    // 用入公司时间比较
                                    theaps = Math.abs( Util.timediff1(tempstarttime,intime ) ) ; 
                                    if( theaps < 0 ) theaps = -1 * theaps ;

                                    if( theaps < theminaps ) {
                                        thediffid = tempdiffid ;
                                        theminaps = theaps ;
                                        diffcounttime = temprealdifftime ;
                                    }
                                }
                            }

                            procedurepara= thediffid + separator + resourceid + separator + tempdate + separator + thedifftype + separator + intime + separator + outtime + separator + theintime + separator + theouttime + separator + counttime + separator + diffcounttime ;
                            RecordSet.executeProc("HrmWorkTimeWarp_Insert",procedurepara) ;

                        }
                    }
                    else {
                        if( intime.compareTo(theintime) < 0 && intime.length() == 5) {         // 属于增加类型
                            
                            int theaps = Math.abs( Util.timediff1(theintime,intime ) ) ; 
                            counttime = "" + theaps ;

                            if( theaps >= theminouttime ) {
                                thediffid = "" ;
                                diffcounttime = "0" ; 
                                thedifftype = "0" ;
                            
                                RecordSet2.executeSql( " select * from HrmScheduleMaintance where startdate <= '" + tempdate +"' and enddate >= '" + tempdate + "' and difftype = '0' and resourceid = " + resourceid ) ;

                                if( RecordSet2.getCounts() < 2 ) {
                                    if( RecordSet2.next() ) {
                                        thediffid = Util.null2String(RecordSet2.getString("id")) ;
                                        diffcounttime = Util.null2String(RecordSet2.getString("realdifftime")) ;
                                    }
                                }
                                else {
                                    int theminaps = 9999999 ;

                                    while ( RecordSet2.next() ) {
                                        String tempdiffid = Util.null2String(RecordSet2.getString("id")) ;
                                        String tempstartdate = Util.null2String(RecordSet2.getString("startdate")) ;
                                        String tempstarttime = Util.null2String(RecordSet2.getString("starttime")) ;
                                        String tempenddate = Util.null2String(RecordSet2.getString("enddate")) ;
                                        String tempendtime = Util.null2String(RecordSet2.getString("endtime")) ;
                                        String temprealdifftime = Util.null2String(RecordSet2.getString("realdifftime")) ;

                                        // 进行初始赋值， 如果考勤没有时间填写，则用第一个找到的偏差
                                        if( thediffid.equals("") ) {
                                            thediffid = tempdiffid ;
                                            diffcounttime = temprealdifftime ;
                                        }

                                        if( tempstarttime.equals("") ) continue ;

                                        // 用入公司时间和加班开始时间比较
                                        theaps = Math.abs( Util.timediff1(tempstarttime,intime ) ) ; 
                                        if( theaps < 0 ) theaps = -1 * theaps ;

                                        if( theaps < theminaps ) {
                                            thediffid = tempdiffid ;
                                            theminaps = theaps ;
                                            diffcounttime = temprealdifftime ;
                                        }
                                    }
                                }

                                procedurepara= thediffid + separator + resourceid + separator + tempdate + separator + thedifftype + separator + intime + separator + outtime + separator + theintime + separator + theouttime + separator + counttime + separator + diffcounttime ;  
                                RecordSet.executeProc("HrmWorkTimeWarp_Insert",procedurepara) ;
                                
                            }
                        }
                        if ( intime.compareTo(theintime) > 0 ) {       // 属于减少类型
                            thediffid = "" ;
                            diffcounttime = "0" ; 
                            thedifftype = "1" ;
                            
                            RecordSet2.executeSql( " select * from HrmScheduleMaintance where startdate <= '" + tempdate +"' and enddate >= '" + tempdate + "' and difftype = '1' and resourceid = " + resourceid ) ;

                            if( RecordSet2.getCounts() < 2 ) {
                                if( RecordSet2.next() ) {
                                    thediffid = Util.null2String(RecordSet2.getString("id")) ;
                                    diffcounttime = Util.null2String(RecordSet2.getString("realdifftime")) ;
                                }
                            }
                            else {
                                int theminaps = 9999999 ;

                                while ( RecordSet2.next() ) {
                                    String tempdiffid = Util.null2String(RecordSet2.getString("id")) ;
                                    String tempstartdate = Util.null2String(RecordSet2.getString("startdate")) ;
                                    String tempstarttime = Util.null2String(RecordSet2.getString("starttime")) ;
                                    String tempenddate = Util.null2String(RecordSet2.getString("enddate")) ;
                                    String tempendtime = Util.null2String(RecordSet2.getString("endtime")) ;
                                    String temprealdifftime = Util.null2String(RecordSet2.getString("realdifftime")) ;

                                    // 进行初始赋值， 如果考勤没有时间填写，则用第一个找到的偏差
                                    if( thediffid.equals("") ) {
                                        thediffid = tempdiffid ;
                                        diffcounttime = temprealdifftime ;
                                    }

                                    if( tempendtime.equals("") ) continue ;

                                    // 用入公司时间和请假结束时间比较
                                    int theaps = Math.abs( Util.timediff1(tempendtime,intime ) ) ; 
                                    if( theaps < 0 ) theaps = -1 * theaps ;

                                    if( theaps < theminaps ) {
                                        thediffid = tempdiffid ;
                                        theminaps = theaps ;
                                        diffcounttime = temprealdifftime ;
                                    }
                                }
                            }

                            counttime = "" + Math.abs( Util.timediff1(theintime,intime ) ) ; 
                            
                            procedurepara= thediffid + separator + resourceid + separator + tempdate + separator + thedifftype + separator + intime + separator + outtime + separator + theintime + separator + theouttime + separator + counttime + separator + diffcounttime ;  
                            RecordSet.executeProc("HrmWorkTimeWarp_Insert",procedurepara) ;

                        }
                        if( outtime.compareTo(theouttime) < 0 && outtime.length() == 5) {      // 属于减少类型
                            thediffid = "" ;
                            diffcounttime = "0" ; 
                            thedifftype = "1" ;
                            
                            RecordSet2.executeSql( " select * from HrmScheduleMaintance where startdate <= '" + tempdate +"' and enddate >= '" + tempdate + "' and difftype = '1' and resourceid = " + resourceid ) ;

                            if( RecordSet2.getCounts() < 2 ) {
                                if( RecordSet2.next() ) {
                                    thediffid = Util.null2String(RecordSet2.getString("id")) ;
                                    diffcounttime = Util.null2String(RecordSet2.getString("realdifftime")) ;
                                }
                            }
                            else {
                                int theminaps = 9999999 ;

                                while ( RecordSet2.next() ) {
                                    String tempdiffid = Util.null2String(RecordSet2.getString("id")) ;
                                    String tempstartdate = Util.null2String(RecordSet2.getString("startdate")) ;
                                    String tempstarttime = Util.null2String(RecordSet2.getString("starttime")) ;
                                    String tempenddate = Util.null2String(RecordSet2.getString("enddate")) ;
                                    String tempendtime = Util.null2String(RecordSet2.getString("endtime")) ;
                                    String temprealdifftime = Util.null2String(RecordSet2.getString("realdifftime")) ;

                                    // 进行初始赋值， 如果考勤没有时间填写，则用第一个找到的偏差
                                    if( thediffid.equals("") ) {
                                        thediffid = tempdiffid ;
                                        diffcounttime = temprealdifftime ;
                                    }

                                    if( tempstarttime.equals("") ) continue ;

                                    // 用出公司时间和请假开始时间比较
                                    int theaps = Math.abs( Util.timediff1(tempstarttime,outtime ) ) ;
                                    if( theaps < 0 ) theaps = -1 * theaps ;

                                    if( theaps < theminaps ) {
                                        thediffid = tempdiffid ;
                                        theminaps = theaps ;
                                        diffcounttime = temprealdifftime ;
                                    }
                                }
                            }

                            counttime = "" + Math.abs( Util.timediff1(theouttime,outtime ) ) ;

                            procedurepara= thediffid + separator + resourceid + separator + tempdate + separator + thedifftype + separator + intime + separator + outtime + separator + theintime + separator + theouttime + separator + counttime + separator + diffcounttime ;  
                            RecordSet.executeProc("HrmWorkTimeWarp_Insert",procedurepara) ;

                        }
                        if( outtime.compareTo(theouttime) > 0 ) {      // 属于增加类型
                            int theaps = Math.abs( Util.timediff1(theouttime,outtime ) ) ;
                            counttime = "" + theaps ;

                            if( theaps >= theminouttime ) {
                                thediffid = "" ;
                                diffcounttime = "0" ; 
                                thedifftype = "0" ;
                            
                                RecordSet2.executeSql( " select * from HrmScheduleMaintance where startdate <= '" + tempdate +"' and enddate >= '" + tempdate + "' and difftype = '0' and resourceid = " + resourceid ) ;

                                if( RecordSet2.getCounts() < 2 ) {
                                    if( RecordSet2.next() ) {
                                        thediffid = Util.null2String(RecordSet2.getString("id")) ;
                                        diffcounttime = Util.null2String(RecordSet2.getString("realdifftime")) ;
                                    }
                                }
                                else {
                                    int theminaps = 9999999 ;

                                    while ( RecordSet2.next() ) {
                                        String tempdiffid = Util.null2String(RecordSet2.getString("id")) ;
                                        String tempstartdate = Util.null2String(RecordSet2.getString("startdate")) ;
                                        String tempstarttime = Util.null2String(RecordSet2.getString("starttime")) ;
                                        String tempenddate = Util.null2String(RecordSet2.getString("enddate")) ;
                                        String tempendtime = Util.null2String(RecordSet2.getString("endtime")) ;
                                        String temprealdifftime = Util.null2String(RecordSet2.getString("realdifftime")) ;

                                        // 进行初始赋值， 如果考勤没有时间填写，则用第一个找到的偏差
                                        if( thediffid.equals("") ) {
                                            thediffid = tempdiffid ;
                                            diffcounttime = temprealdifftime ;
                                        }

                                        if( tempendtime.equals("") )  continue ;

                                        // 用出公司时间和加班结束时间比较
                                        theaps = Math.abs( Util.timediff1(tempendtime,outtime ) ) ;
                                        if( theaps < 0 ) theaps = -1 * theaps ;

                                        if( theaps < theminaps ) {
                                            thediffid = tempdiffid ;
                                            theminaps = theaps ;
                                            diffcounttime = temprealdifftime ;
                                        }
                                    }
                                }

                                procedurepara= thediffid + separator + resourceid + separator + tempdate + separator + thedifftype + separator + intime + separator + outtime + separator + theintime + separator + theouttime + separator + counttime + separator + diffcounttime ;
                                RecordSet.executeProc("HrmWorkTimeWarp_Insert",procedurepara) ;
                            }
                        }
                    }
                }
                else {  // 应该上班的种类没有对应的实际上班, 属于缺勤
                    thediffid = "" ;
                    diffcounttime = "0" ; 
                    thedifftype = "1" ;
                            
                    RecordSet2.executeSql( " select * from HrmScheduleMaintance where startdate <= '" + tempdate +"' and enddate >= '" + tempdate + "' and difftype = '1' and resourceid = " + resourceid ) ;

                    if( RecordSet2.getCounts() < 2 ) {
                        if( RecordSet2.next() ) {
                            thediffid = Util.null2String(RecordSet2.getString("id")) ;
                            diffcounttime = Util.null2String(RecordSet2.getString("realdifftime")) ;
                        }
                    }
                    else {
                        int theminaps = 9999999 ;

                        while ( RecordSet2.next() ) {
                            String tempdiffid = Util.null2String(RecordSet2.getString("id")) ;
                            String tempstartdate = Util.null2String(RecordSet2.getString("startdate")) ;
                            String tempstarttime = Util.null2String(RecordSet2.getString("starttime")) ;
                            String tempenddate = Util.null2String(RecordSet2.getString("enddate")) ;
                            String tempendtime = Util.null2String(RecordSet2.getString("endtime")) ;
                            String temprealdifftime = Util.null2String(RecordSet2.getString("realdifftime")) ;

                            // 进行初始赋值， 如果考勤没有时间填写，则用第一个找到的偏差
                            if( thediffid.equals("") ) {
                                thediffid = tempdiffid ;
                                diffcounttime = temprealdifftime ;
                            }

                            if( tempstarttime.equals("") ) continue ;

                            // 用应该入公司时间和请假开始时间比较
                            int theaps = Math.abs( Util.timediff1(tempstarttime,theintime ) ) ;
                            if( theaps < 0 ) theaps = -1 * theaps ;

                            if( theaps < theminaps ) {
                                thediffid = tempdiffid ;
                                theminaps = theaps ;
                                diffcounttime = temprealdifftime ;
                            }
                        }
                    }

                    counttime = "" + Math.abs( Util.timediff1(theintime,theouttime ) ) ;

                    procedurepara= thediffid + separator + resourceid + separator + tempdate + separator + thedifftype + separator + "" + separator + "" + separator + theintime + separator + theouttime + separator + counttime + separator + diffcounttime ;  
                    RecordSet.executeProc("HrmWorkTimeWarp_Insert",procedurepara) ;
                }
            }       // 应该上班的次数循序结束
        }
        else { // 当实际上班次数大于等于应该上班次数的时候， 用实际的作为基准
            
            for( int k = 0 ; k< realshiftids.size() ; k++ ) {
                String realshiftid = (String) realshiftids.get(k) ;
                String intime = (String) realintimes.get(k) ;
                String outtime = (String) realouttimes.get(k) ;

                int theshiftidindex = theshiftids.indexOf(realshiftid) ;

                if( theshiftidindex != -1 ) {      // 有对应的应该上班记录
                    String theintime = (String) theintimes.get(theshiftidindex) ;
                    String theouttime = (String) theouttimes.get(theshiftidindex) ;

                    // 比较上班时间的差异

                    if( ( intime.length() < 5 || outtime.length() < 5 ) && theintime.length() == 5 && theouttime.length() == 5 ) {     // 某一个实际打卡时间缺少，属于减少类型
                        thediffid = "" ;
                        diffcounttime = "0" ; 
                        thedifftype = "1" ;
                        
                        RecordSet2.executeSql( " select * from HrmScheduleMaintance where startdate <= '" + tempdate +"' and enddate >= '" + tempdate + "' and difftype = '1' and resourceid = " + resourceid ) ;

                        if( RecordSet2.getCounts() < 2 ) {
                            if( RecordSet2.next() ) {
                                thediffid = Util.null2String(RecordSet2.getString("id")) ;
                                diffcounttime = Util.null2String(RecordSet2.getString("realdifftime")) ;
                            }
                        }
                        else {
                            int theminaps = 9999999 ;

                            while ( RecordSet2.next() ) {
                                String tempdiffid = Util.null2String(RecordSet2.getString("id")) ;
                                String tempstartdate = Util.null2String(RecordSet2.getString("startdate")) ;
                                String tempstarttime = Util.null2String(RecordSet2.getString("starttime")) ;
                                String tempenddate = Util.null2String(RecordSet2.getString("enddate")) ;
                                String tempendtime = Util.null2String(RecordSet2.getString("endtime")) ;
                                String temprealdifftime = Util.null2String(RecordSet2.getString("realdifftime")) ;
                                
                                // 进行初始赋值， 如果考勤没有时间填写，则用第一个找到的偏差
                                if( thediffid.equals("") ) {
                                    thediffid = tempdiffid ;
                                    diffcounttime = temprealdifftime ;
                                }


                                if( intime.equals("") && !tempstarttime.equals("") ) {              // 如果入公司打卡缺失，用入公司时间比较
                                    int theaps = Math.abs( Util.timediff1(tempstarttime,theintime ) ) ;
                                    if( theaps < 0 ) theaps = -1 * theaps ;

                                    if( theaps < theminaps ) {
                                        thediffid = tempdiffid ;
                                        theminaps = theaps ;
                                        diffcounttime = temprealdifftime ;
                                    }
                                }
                                else if( outtime.equals("") && !tempendtime.equals("") ) {                              // 用出公司时间比较  
                                    int theaps = Math.abs( Util.timediff1(tempendtime,theouttime ) ) ;
                                    if( theaps < 0 ) theaps = -1 * theaps ;

                                    if( theaps < theminaps ) {
                                        thediffid = tempdiffid ;
                                        theminaps = theaps ;
                                        diffcounttime = temprealdifftime ;
                                    }
                                }
                            }
                        }

                        counttime = "" + Math.abs( Util.timediff1(theouttime,theintime ) ) ;  

                        procedurepara= thediffid + separator + resourceid + separator + tempdate + separator + thedifftype + separator + intime + separator + outtime + separator + theintime + separator + theouttime + separator + counttime + separator + diffcounttime ; 
                        RecordSet.executeProc("HrmWorkTimeWarp_Insert",procedurepara) ;
                    }
                    else if( ( theintime.length() < 5 || theouttime.length() < 5 ) && intime.length() == 5 && outtime.length() == 5 ) {         // 属于增加类型
                        
                        int theaps = Math.abs( Util.timediff1(outtime,intime ) ) ; 
                        counttime = "" + theaps ;

                        if( theaps >= theminouttime ) {         // 大于增加类型最小的最小计算时间,才记入偏差
                            thediffid = "" ;
                            diffcounttime = "0" ; 
                            thedifftype = "0" ;
                        
                            RecordSet2.executeSql( " select * from HrmScheduleMaintance where startdate <= '" + tempdate +"' and enddate >= '" + tempdate + "' and difftype = '0' and resourceid = " + resourceid ) ;

                            if( RecordSet2.getCounts() < 2 ) {
                                if( RecordSet2.next() ) {
                                    thediffid = Util.null2String(RecordSet2.getString("id")) ;
                                    diffcounttime = Util.null2String(RecordSet2.getString("realdifftime")) ;
                                }
                            }
                            else {
                                int theminaps = 9999999 ;

                                while ( RecordSet2.next() ) {
                                    String tempdiffid = Util.null2String(RecordSet2.getString("id")) ;
                                    String tempstartdate = Util.null2String(RecordSet2.getString("startdate")) ;
                                    String tempstarttime = Util.null2String(RecordSet2.getString("starttime")) ;
                                    String tempenddate = Util.null2String(RecordSet2.getString("enddate")) ;
                                    String tempendtime = Util.null2String(RecordSet2.getString("endtime")) ;
                                    String temprealdifftime = Util.null2String(RecordSet2.getString("realdifftime")) ;

                                    // 进行初始赋值， 如果考勤没有时间填写，则用第一个找到的偏差
                                    if( thediffid.equals("") ) {
                                        thediffid = tempdiffid ;
                                        diffcounttime = temprealdifftime ;
                                    }

                                    if( tempstarttime.equals("") )  continue ;

                                    // 用入公司时间比较
                                    theaps = Math.abs( Util.timediff1(tempstarttime,intime ) ) ; 
                                    if( theaps < 0 ) theaps = -1 * theaps ;

                                    if( theaps < theminaps ) {
                                        thediffid = tempdiffid ;
                                        theminaps = theaps ;
                                        diffcounttime = temprealdifftime ;
                                    }
                                }
                            }

                            procedurepara= thediffid + separator + resourceid + separator + tempdate + separator + thedifftype + separator + intime + separator + outtime + separator + theintime + separator + theouttime + separator + counttime + separator + diffcounttime ; 
                            RecordSet.executeProc("HrmWorkTimeWarp_Insert",procedurepara) ;

                        }
                    }
                    else {
                        if( intime.compareTo(theintime) < 0 && intime.length() == 5) {         // 属于增加类型
                            
                            int theaps = Math.abs( Util.timediff1(theintime,intime ) ) ; 
                            counttime = "" + theaps ;

                            if( theaps >= theminouttime ) {
                                thediffid = "" ;
                                diffcounttime = "0" ; 
                                thedifftype = "0" ;
                            
                                RecordSet2.executeSql( " select * from HrmScheduleMaintance where startdate <= '" + tempdate +"' and enddate >= '" + tempdate + "' and difftype = '0' and resourceid = " + resourceid ) ;

                                if( RecordSet2.getCounts() < 2 ) {
                                    if( RecordSet2.next() ) {
                                        thediffid = Util.null2String(RecordSet2.getString("id")) ;
                                        diffcounttime = Util.null2String(RecordSet2.getString("realdifftime")) ;
                                    }
                                }
                                else {
                                    int theminaps = 9999999 ;

                                    while ( RecordSet2.next() ) {
                                        String tempdiffid = Util.null2String(RecordSet2.getString("id")) ;
                                        String tempstartdate = Util.null2String(RecordSet2.getString("startdate")) ;
                                        String tempstarttime = Util.null2String(RecordSet2.getString("starttime")) ;
                                        String tempenddate = Util.null2String(RecordSet2.getString("enddate")) ;
                                        String tempendtime = Util.null2String(RecordSet2.getString("endtime")) ;
                                        String temprealdifftime = Util.null2String(RecordSet2.getString("realdifftime")) ;

                                        // 进行初始赋值， 如果考勤没有时间填写，则用第一个找到的偏差
                                        if( thediffid.equals("") ) {
                                            thediffid = tempdiffid ;
                                            diffcounttime = temprealdifftime ;
                                        }

                                        if( tempstarttime.equals("") ) continue ;

                                        // 用入公司时间和加班开始时间比较
                                        theaps = Math.abs( Util.timediff1(tempstarttime,intime ) ) ; 
                                        if( theaps < 0 ) theaps = -1 * theaps ;

                                        if( theaps < theminaps ) {
                                            thediffid = tempdiffid ;
                                            theminaps = theaps ;
                                            diffcounttime = temprealdifftime ;
                                        }
                                    }
                                }

                                procedurepara= thediffid + separator + resourceid + separator + tempdate + separator + thedifftype + separator + intime + separator + outtime + separator + theintime + separator + theouttime + separator + counttime + separator + diffcounttime ;  
                                RecordSet.executeProc("HrmWorkTimeWarp_Insert",procedurepara) ;
                                
                            }
                        }
                        if ( intime.compareTo(theintime) > 0 ) {       // 属于减少类型
                            thediffid = "" ;
                            diffcounttime = "0" ; 
                            thedifftype = "1" ;
                            
                            RecordSet2.executeSql( " select * from HrmScheduleMaintance where startdate <= '" + tempdate +"' and enddate >= '" + tempdate + "' and difftype = '1' and resourceid = " + resourceid ) ;

                            if( RecordSet2.getCounts() < 2 ) {
                                if( RecordSet2.next() ) {
                                    thediffid = Util.null2String(RecordSet2.getString("id")) ;
                                    diffcounttime = Util.null2String(RecordSet2.getString("realdifftime")) ;
                                }
                            }
                            else {
                                int theminaps = 9999999 ;

                                while ( RecordSet2.next() ) {
                                    String tempdiffid = Util.null2String(RecordSet2.getString("id")) ;
                                    String tempstartdate = Util.null2String(RecordSet2.getString("startdate")) ;
                                    String tempstarttime = Util.null2String(RecordSet2.getString("starttime")) ;
                                    String tempenddate = Util.null2String(RecordSet2.getString("enddate")) ;
                                    String tempendtime = Util.null2String(RecordSet2.getString("endtime")) ;
                                    String temprealdifftime = Util.null2String(RecordSet2.getString("realdifftime")) ;

                                    // 进行初始赋值， 如果考勤没有时间填写，则用第一个找到的偏差
                                    if( thediffid.equals("") ) {
                                        thediffid = tempdiffid ;
                                        diffcounttime = temprealdifftime ;
                                    }

                                    if( tempendtime.equals("") ) continue ;

                                    // 用入公司时间和请假结束时间比较
                                    int theaps = Math.abs( Util.timediff1(tempendtime,intime ) ) ; 
                                    if( theaps < 0 ) theaps = -1 * theaps ;

                                    if( theaps < theminaps ) {
                                        thediffid = tempdiffid ;
                                        theminaps = theaps ;
                                        diffcounttime = temprealdifftime ;
                                    }
                                }
                            }

                            counttime = "" + Math.abs( Util.timediff1(theintime,intime ) ) ; 
                            
                            procedurepara= thediffid + separator + resourceid + separator + tempdate + separator + thedifftype + separator + intime + separator + outtime + separator + theintime + separator + theouttime + separator + counttime + separator + diffcounttime ;  
                            RecordSet.executeProc("HrmWorkTimeWarp_Insert",procedurepara) ;

                        }
                        if( outtime.compareTo(theouttime) < 0 && outtime.length() == 5) {      // 属于减少类型
                            thediffid = "" ;
                            diffcounttime = "0" ; 
                            thedifftype = "1" ;
                            
                            RecordSet2.executeSql( " select * from HrmScheduleMaintance where startdate <= '" + tempdate +"' and enddate >= '" + tempdate + "' and difftype = '1' and resourceid = " + resourceid ) ;

                            if( RecordSet2.getCounts() < 2 ) {
                                if( RecordSet2.next() ) {
                                    thediffid = Util.null2String(RecordSet2.getString("id")) ;
                                    diffcounttime = Util.null2String(RecordSet2.getString("realdifftime")) ;
                                }
                            }
                            else {
                                int theminaps = 9999999 ;

                                while ( RecordSet2.next() ) {
                                    String tempdiffid = Util.null2String(RecordSet2.getString("id")) ;
                                    String tempstartdate = Util.null2String(RecordSet2.getString("startdate")) ;
                                    String tempstarttime = Util.null2String(RecordSet2.getString("starttime")) ;
                                    String tempenddate = Util.null2String(RecordSet2.getString("enddate")) ;
                                    String tempendtime = Util.null2String(RecordSet2.getString("endtime")) ;
                                    String temprealdifftime = Util.null2String(RecordSet2.getString("realdifftime")) ;

                                    // 进行初始赋值， 如果考勤没有时间填写，则用第一个找到的偏差
                                    if( thediffid.equals("") ) {
                                        thediffid = tempdiffid ;
                                        diffcounttime = temprealdifftime ;
                                    }

                                    if( tempstarttime.equals("") ) continue ;

                                    // 用出公司时间和请假开始时间比较
                                    int theaps = Math.abs( Util.timediff1(tempstarttime,outtime ) ) ;
                                    if( theaps < 0 ) theaps = -1 * theaps ;

                                    if( theaps < theminaps ) {
                                        thediffid = tempdiffid ;
                                        theminaps = theaps ;
                                        diffcounttime = temprealdifftime ;
                                    }
                                }
                            }

                            counttime = "" + Math.abs( Util.timediff1(theouttime,outtime ) ) ;

                            procedurepara= thediffid + separator + resourceid + separator + tempdate + separator + thedifftype + separator + intime + separator + outtime + separator + theintime + separator + theouttime + separator + counttime + separator + diffcounttime ;  
                            RecordSet.executeProc("HrmWorkTimeWarp_Insert",procedurepara) ;

                        }
                        if( outtime.compareTo(theouttime) > 0 ) {      // 属于增加类型
                            int theaps = Math.abs( Util.timediff1(theouttime,outtime ) ) ;
                            counttime = "" + theaps ;

                            if( theaps >= theminouttime ) {
                                thediffid = "" ;
                                diffcounttime = "0" ; 
                                thedifftype = "0" ;
                            
                                RecordSet2.executeSql( " select * from HrmScheduleMaintance where startdate <= '" + tempdate +"' and enddate >= '" + tempdate + "' and difftype = '0' and resourceid = " + resourceid ) ;

                                if( RecordSet2.getCounts() < 2 ) {
                                    if( RecordSet2.next() ) {
                                        thediffid = Util.null2String(RecordSet2.getString("id")) ;
                                        diffcounttime = Util.null2String(RecordSet2.getString("realdifftime")) ;
                                    }
                                }
                                else {
                                    int theminaps = 9999999 ;

                                    while ( RecordSet2.next() ) {
                                        String tempdiffid = Util.null2String(RecordSet2.getString("id")) ;
                                        String tempstartdate = Util.null2String(RecordSet2.getString("startdate")) ;
                                        String tempstarttime = Util.null2String(RecordSet2.getString("starttime")) ;
                                        String tempenddate = Util.null2String(RecordSet2.getString("enddate")) ;
                                        String tempendtime = Util.null2String(RecordSet2.getString("endtime")) ;
                                        String temprealdifftime = Util.null2String(RecordSet2.getString("realdifftime")) ;

                                        // 进行初始赋值， 如果考勤没有时间填写，则用第一个找到的偏差
                                        if( thediffid.equals("") ) {
                                            thediffid = tempdiffid ;
                                            diffcounttime = temprealdifftime ;
                                        }

                                        if( tempendtime.equals("") )  continue ;

                                        // 用出公司时间和加班结束时间比较
                                        theaps = Math.abs( Util.timediff1(tempendtime,outtime ) ) ;
                                        if( theaps < 0 ) theaps = -1 * theaps ;

                                        if( theaps < theminaps ) {
                                            thediffid = tempdiffid ;
                                            theminaps = theaps ;
                                            diffcounttime = temprealdifftime ;
                                        }
                                    }
                                }

                                procedurepara= thediffid + separator + resourceid + separator + tempdate + separator + thedifftype + separator + intime + separator + outtime + separator + theintime + separator + theouttime + separator + counttime + separator + diffcounttime ; 
                                RecordSet.executeProc("HrmWorkTimeWarp_Insert",procedurepara) ;
                            }
                        }
                    }
                }
                else {  // 实际上班的种类没有对应的应该上班, 属于加班
                    
                    int theaps = Math.abs( Util.timediff1(intime,outtime ) ) ;
                    counttime = "" + theaps ;

                    if( theaps >= theminouttime ) {
                        thediffid = "" ;
                        diffcounttime = "0" ; 
                        thedifftype = "0" ;
                    
                        RecordSet2.executeSql( " select * from HrmScheduleMaintance where startdate <= '" + tempdate +"' and enddate >= '" + tempdate + "' and difftype = '0' and resourceid = " + resourceid ) ;

                        if( RecordSet2.getCounts() < 2 ) {
                            if( RecordSet2.next() ) {
                                thediffid = Util.null2String(RecordSet2.getString("id")) ;
                                diffcounttime = Util.null2String(RecordSet2.getString("realdifftime")) ;
                            }
                        }
                        else {
                            int theminaps = 9999999 ;

                            while ( RecordSet2.next() ) {
                                String tempdiffid = Util.null2String(RecordSet2.getString("id")) ;
                                String tempstartdate = Util.null2String(RecordSet2.getString("startdate")) ;
                                String tempstarttime = Util.null2String(RecordSet2.getString("starttime")) ;
                                String tempenddate = Util.null2String(RecordSet2.getString("enddate")) ;
                                String tempendtime = Util.null2String(RecordSet2.getString("endtime")) ;
                                String temprealdifftime = Util.null2String(RecordSet2.getString("realdifftime")) ;

                                // 进行初始赋值， 如果考勤没有时间填写，则用第一个找到的偏差
                                if( thediffid.equals("") ) {
                                    thediffid = tempdiffid ;
                                    diffcounttime = temprealdifftime ;
                                }

                                if( tempstarttime.equals("") )  continue ;

                                // 用入公司时间和加班开始时间比较
                                theaps = Math.abs( Util.timediff1(tempstarttime,intime ) ) ;
                                if( theaps < 0 ) theaps = -1 * theaps ;

                                if( theaps < theminaps ) {
                                    thediffid = tempdiffid ;
                                    theminaps = theaps ;
                                    diffcounttime = temprealdifftime ;
                                }
                            }
                        }

                        procedurepara= thediffid + separator + resourceid + separator + tempdate + separator + thedifftype + separator + intime + separator + outtime + separator + "" + separator + "" + separator + counttime + separator + diffcounttime ; 
                        RecordSet.executeProc("HrmWorkTimeWarp_Insert",procedurepara) ;
                    }
                }
            }       // 应该上班的次数循序结束
        }
                    
        thedate.add(Calendar.DATE , 1) ; 
        tempdate =  Util.add0(thedate.get(Calendar.YEAR) , 4) + "-" + 
                    Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
                    Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 
    }
}


// 重新计算打卡表中的偏差
RecordSet.executeSql(" select diffid , counttime from HrmWorkTimeWarp where  diffid is not null and diffid != 0 ") ; 
while( RecordSet.next() ) {
    String tempdiffid = Util.null2String(RecordSet.getString("diffid")) ;
    String tempcounttime = Util.null2String(RecordSet.getString("counttime")) ;

    if( Util.getIntValue(tempcounttime,0) != 0 ) {
        RecordSet.executeSql(" update HrmScheduleMaintance set realcarddifftime = realcarddifftime + " + tempcounttime + " where id = " + tempdiffid ) ; 
    }
}

response.sendRedirect("HrmWorkTimeWarpList.jsp?fromdate="+startdate+"&enddate="+enddate);

%>