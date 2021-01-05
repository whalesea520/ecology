<%@ page import="java.io.PrintWriter"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%-- Created BY Charoes Huang on May 20,2004--%>
<%!
   public void test(JspWriter out) throws Exception{
         out.println("hello world") ;
   }
%>
<Script language="javascript">

<%--
 *Author: Charoes Huang
 *compare two date string ,the date format is: yyyy-mm-dd hh:mm
 *return 0 if date1==date2
 *       1 if date1>date2
 *       -1 if date1<date2
--%>
<!--
function compareDate(date1,date2){
	//format the date format to "mm-dd-yyyy hh:mm"
	var ss1 = date1.split("-",3);
	var ss2 = date2.split("-",3);

	date1 = ss1[1]+"-"+ss1[2]+"-"+ss1[0];
	date2 = ss2[1]+"-"+ss2[2]+"-"+ss2[0];

	var t1,t2;
	t1 = Date.parse(date1);
	t2 = Date.parse(date2);
	if(t1==t2) return 0;
	if(t1>t2) return 1;
	if(t1<t2) return -1;

    return 0;
}
<%--
   Created By Charoes Huang On May 20 ,2004
   Check ,if startDate > endDate  then alert the errorMsg and return false;otherwise return true;
--%>
function checkDateRange(startDateObj,endDateObj,errorMsg){
    var startDate =  startDateObj.value;
    var endDate = endDateObj.value;
    if(compareDate(startDate,endDate)==1){
        alert(errorMsg);
        return false;
    }
    return true;
}
<%--
    Created By Charoes Huang On May 21,2004
    Check if the checked Date between startdate and enddate
--%>
function checkDateBetween(startDate,checkedDate,endDate,errorMsg){
    if(compareDate(startDate,checkedDate)==1 || compareDate(checkedDate,endDate) == 1){
        alert(errorMsg);
        return false;
    }
    return true;
}
-->
</Script>