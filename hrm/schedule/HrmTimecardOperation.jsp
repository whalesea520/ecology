<%@ page import="java.util.*,weaver.general.Util,weaver.file.*,weaver.systeminfo.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>

<%
User user = HrmUserVarify.getUser (request , response);
if(user == null)  return ;
ArrayList userdates = new ArrayList() ;
ArrayList intimes = new ArrayList() ;
ArrayList outtimes = new ArrayList() ;

String startdate = Util.null2String(request.getParameter("startdate")) ;
String enddate = Util.null2String(request.getParameter("enddate")) ;
Calendar thedate = Calendar.getInstance() ; 

int fromyear = Util.getIntValue(startdate.substring(0 , 4)) ; 
int frommonth = Util.getIntValue(startdate.substring(5 , 7)) ; 
int fromday = Util.getIntValue(startdate.substring(8 , 10)) ; 

int toyear = Util.getIntValue(enddate.substring(0 , 4)) ; 
int tomonth = Util.getIntValue(enddate.substring(5 , 7)) ; 
int today = Util.getIntValue(enddate.substring(8 , 10)) ; 

String thestartdate = Util.add0(fromyear , 4) + Util.add0(frommonth , 2) + Util.add0(fromday , 2) ;
String theenddate = Util.add0(toyear , 4) + Util.add0(tomonth , 2) + Util.add0(today , 2) ;
String tempstartdate = thestartdate ;

thedate.set(toyear,tomonth - 1 , today) ;
thedate.add(Calendar.DATE ,1 ) ;
String tempenddate =  Util.add0(thedate.get(Calendar.YEAR) , 4) + 
                    Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) +  
                    Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 

thedate.set(fromyear,frommonth - 1 , fromday) ; 

while( tempstartdate.compareTo(tempenddate) <= 0 ) {
    
    RecordSet.executeSql("select * from " + tempstartdate , "ecologydb" ) ; 

    while (RecordSet.next() ) {
        String timerecoder = Util.null2String(RecordSet.getString("temp")) ;
        if( timerecoder.length() < 28 ) continue ;
        if( !timerecoder.equals("") ) {
            String usercode = timerecoder.substring(18,28) ;
            String tempdate = timerecoder.substring(3,11) ;
            String temptime = timerecoder.substring(11,15) ;
            
            String thedatestr = tempdate.substring(0,4) +"-"+
                                tempdate.substring(4,6) +"-"+
                                tempdate.substring(6,8)  ;

            if( tempdate.compareTo(thestartdate) >= 0 && tempdate.compareTo(theenddate) <= 0 ) {

                String thetime = temptime.substring(0,2) +":"+
                                 temptime.substring(2,4) ;

                
                int usercodeindex = userdates.indexOf(usercode+"_"+thedatestr) ;
                if( usercodeindex == -1 ) {
                    userdates.add(usercode+"_"+thedatestr) ;
                    if( thetime.compareTo("12:00") > 0 ) {
                        outtimes.add(thetime) ;
                        intimes.add("") ;
                    }
                    else {
                        intimes.add(thetime) ;
                        outtimes.add("") ;
                    }
                }
                else {
                   if( thetime.compareTo("12:00") > 0 ) outtimes.set(usercodeindex,thetime) ;
                   else intimes.set(usercodeindex,thetime) ;
                }
            }
        }
    }

    thedate.add(Calendar.DATE , 1) ; 
    tempstartdate =  Util.add0(thedate.get(Calendar.YEAR) , 4) + 
                Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + 
                Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 
}



ExcelFile.init ();
ExcelFile.setFilename(startdate+" - " + enddate) ;
ExcelStyle es = ExcelFile.newExcelStyle("Header") ;
es.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
es.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
es.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
es.setAlign(ExcelStyle.WeaverHeaderAlign) ;

ExcelSheet et = ExcelFile.newExcelSheet("Timecard") ;

et.addColumnwidth(8000) ;
et.addColumnwidth(8000) ;
et.addColumnwidth(8000) ;
et.addColumnwidth(8000) ;

ExcelRow er = null ;

er = et.newExcelRow() ;
er.addStringValue("Usercode","Header"); 
er.addStringValue("Date","Header"); 
er.addStringValue("Intime","Header"); 
er.addStringValue("Outtime","Header"); 

for( int i = 0 ; i< userdates.size() ; i++ ) {
    String userdate = (String) userdates.get(i) ;
    String userdatearr[] = Util.TokenizerString2(userdate,"_") ;
    String usercode = userdatearr[0] ;
    String thedatestr = userdatearr[1] ;
    String intime = (String) intimes.get(i) ;
    String outtime = (String) outtimes.get(i) ;
    
    er = et.newExcelRow() ;
    er.addStringValue(usercode); 
    er.addStringValue(thedatestr); 
    er.addStringValue(intime); 
    er.addStringValue(outtime); 
}

%>

<br>

<%=SystemEnv.getHtmlLabelName(16723,user.getLanguage())%> <a href="/weaver/weaver.file.ExcelOut"><%=startdate%> - <%=enddate%>.xls</a>
<br>
