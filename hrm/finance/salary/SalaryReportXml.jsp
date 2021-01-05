<%@ page import="java.util.*,weaver.datacenter.*,weaver.general.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page"/>
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page"/>
<jsp:useBean id="SalaryComInfo" class="weaver.hrm.finance.SalaryComInfo" scope="page" />



<%
String printtype = (String)session.getAttribute("weaverprinttype") ;  // 1: 个人 2： 部门
String printscrope = (String)session.getAttribute("weaverprintscrope") ;        // 1: 当前 2： 全部
String salarywhere = (String)session.getAttribute("weaversalarywhere") ;
String salaryyear = (String)session.getAttribute("weaversalaryyear") ;
String salarymonth = (String)session.getAttribute("weaversalarymonth") ;
String groupstr = "salary" ;

ArrayList resourceitems = (ArrayList)session.getAttribute("weaversalarykey") ;
ArrayList salarys = (ArrayList)session.getAttribute("weaversalaryvalue") ;

// 用来存放用户的卡号
ArrayList resourceids = new ArrayList() ;
ArrayList usercodes = new ArrayList() ;


String xmlstring = "<?xml version='1.0' encoding='"+weaver.general.GCONST.XML_UTF8+"'?>" + "\n" ;
xmlstring += "<data>" + "\n" ;

String sql = "" ;
int rowindex = 0;
if(printtype.equals("1")) {
    if(printscrope.equals("1")) 
        sql = " select id , workcode, lastname, sex , departmentid , startdate, locationid, jobtitle,joblevel,islabouunion from HrmResource where id >0 " + salarywhere + " order by departmentid , id " ;
    else 
        sql = " select id , workcode, lastname, sex , departmentid , startdate, locationid, jobtitle,joblevel,islabouunion from HrmResource where id >0 and (status = 0 or status = 1 or status = 2 or status = 3) order by departmentid , id " ;
    
    // 预先查询所有卡号
    RecordSet.executeSql("select * from HrmTimecardUser") ;
    while ( RecordSet.next() ) {
        String resourceid = Util.null2String(RecordSet.getString("resourceid"));  
        String usercode = Util.null2String(RecordSet.getString("usercode")); 
        
        resourceids.add( resourceid ) ;
        usercodes.add( usercode ) ;
    }
}
else {
    sql = " select id , departmentmark from HrmDepartment order by showorder " ;
}


RecordSet.executeSql(sql) ;
while(RecordSet.next()) {
    rowindex ++ ;
    String thegroupstr = groupstr + rowindex ;
    xmlstring += "<row" + rowindex + ">" + "\n";
    xmlstring += "<salary>" + thegroupstr + "</salary>" + "\n";
    xmlstring += "<year>" + salaryyear + "</year>" + "\n";
    xmlstring += "<month>" + salarymonth + "</month>" + "\n";
    
    String theid = Util.null2String( RecordSet.getString("id") ) ;

    if(printtype.equals("1")) {
        String workcode = Util.null2String( RecordSet.getString("workcode") ) ;
        String lastname = Util.null2String( RecordSet.getString("lastname") ) ;
        String sex = Util.null2String( RecordSet.getString("sex") ) ;
        String departmentid = Util.null2String( RecordSet.getString("departmentid") ) ;
        String startdate = Util.null2String( RecordSet.getString("startdate") ) ;
        String locationid = Util.null2String( RecordSet.getString("locationid") ) ;
        String jobtitle = Util.null2String( RecordSet.getString("jobtitle") ) ;
        String joblevel = Util.null2String( RecordSet.getString("joblevel") ) ;
        String islabouunion = Util.null2String( RecordSet.getString("islabouunion") ) ;

        String departmentname = Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage()) ;
        String jobtitlename = Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobtitle),user.getLanguage()) ;
        String jobactivity =  Util.toScreen(JobActivitiesComInfo.getJobActivitiesname(JobTitlesComInfo.getJobactivityid(jobtitle)),user.getLanguage()) ;
        String locationname = Util.toScreen(LocationComInfo.getLocationname(locationid),user.getLanguage()) ;
        String sexname = "" ;
        if(sex.equals("0")) sexname = SystemEnv.getHtmlLabelName(417,user.getLanguage()) ;
        else sexname = SystemEnv.getHtmlLabelName(418,user.getLanguage()) ;
        String islabouunionname = "" ;
        if(islabouunion.equals("1")) islabouunionname = SystemEnv.getHtmlLabelName(163,user.getLanguage()) ;
        else islabouunionname = SystemEnv.getHtmlLabelName(161,user.getLanguage()) ;
        String cardno = "" ;
        int usercodeindex = resourceids.indexOf(theid) ;
        if(usercodeindex != -1) cardno = (String) usercodes.get(usercodeindex) ;


        xmlstring += "<hrmno>" + workcode + "</hrmno>" + "\n";
        xmlstring += "<name>" + lastname + "</name>" + "\n";
        xmlstring += "<sex>" + sexname + "</sex>" + "\n";
        xmlstring += "<depname>" + departmentname + "</depname>" + "\n";
        xmlstring += "<indate>" + startdate + "</indate>" + "\n";
        xmlstring += "<location>" + locationname + "</location>" + "\n";
        xmlstring += "<jobtitle>" + jobtitlename + "</jobtitle>" + "\n";
        xmlstring += "<jobactivity>" + jobactivity + "</jobactivity>" + "\n";
        xmlstring += "<joblevel>" + joblevel + "</joblevel>" + "\n";
        xmlstring += "<cardno>" + cardno + "</cardno>" + "\n";
        xmlstring += "<labouunion>" + islabouunionname + "</labouunion>" + "\n";
    }
    else {
        String departmentmark = Util.null2String( RecordSet.getString("departmentmark") ) ;
        
        xmlstring += "<depname>" + departmentmark + "</depname>" + "\n";
    }

    SalaryComInfo.setTofirstRow() ;
    while(SalaryComInfo.next()) {
        String itemid = Util.null2String(SalaryComInfo.getSalaryItemid()) ;
        String itemtype = Util.null2String(SalaryComInfo.getSalaryItemtype()) ;
        String salary = "" ;
        String personsalary = "" ;
        String companysalary = "" ;

        if( !itemtype.equals("2") ) {
            int salaryindex = resourceitems.indexOf( theid + "_" + itemid ) ;
            if( salaryindex != -1) {
                salary = (String) salarys.get(salaryindex) ;
                if( Util.getDoubleValue(salary,0) ==0 ) salary = "" ;
            }
            
            xmlstring += "<"+itemid+">" + salary + "</"+itemid+">" + "\n";
        } else {
            int salaryindex = resourceitems.indexOf( theid + "_" + itemid+"_1" ) ;
            if( salaryindex != -1) {
                personsalary = (String) salarys.get(salaryindex) ;
                if( Util.getDoubleValue(personsalary,0) == 0 ) personsalary = "" ;
            }  
            salaryindex = resourceitems.indexOf( theid + "_" + itemid+"_2" ) ;
            if( salaryindex != -1) {
                companysalary = (String) salarys.get(salaryindex) ;
                if( Util.getDoubleValue(companysalary,0) == 0 ) companysalary = "" ;
            }  
            xmlstring += "<"+itemid+">" + personsalary + "</"+itemid+">" + "\n";
        }
    }
    xmlstring += "</row" + rowindex + ">" + "\n";
}
xmlstring += "<count>" + rowindex + "</count>\n" ;        
xmlstring += "</data>" + "\n" ;
out.print(xmlstring);

%>


