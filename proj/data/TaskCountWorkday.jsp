
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page"/>




<%
String method = request.getParameter("method");
String type = request.getParameter("type");

String taskrecordid = request.getParameter("taskrecordid");
String ProjID=Util.null2String(request.getParameter("ProjID"));
String parentid=Util.null2String(request.getParameter("parentid"));
String parentids=Util.null2String(request.getParameter("parentids"));
String parenthrmids=Util.null2String(request.getParameter("parenthrmids"));
String hrmid=Util.null2String(request.getParameter("hrmid"));
String oldhrmid=Util.null2String(request.getParameter("oldhrmid"));
String finish=Util.null2String(request.getParameter("finish"));
String level=Util.null2String(request.getParameter("level"));
String subject=Util.null2String(request.getParameter("subject"));
String begindate=Util.null2String(request.getParameter("begindate"));
String enddate=Util.null2String(request.getParameter("enddate"));
String workday=Util.null2String(request.getParameter("workday"));
String fixedcost=Util.null2String(request.getParameter("fixedcost"));
String islandmark=Util.null2String(request.getParameter("islandmark"));
String pretask=Util.null2String(request.getParameter("taskids02"));
String content=Util.null2String(request.getParameter("content"));

int i;
int frombackyear = Util.getIntValue(begindate.substring(0,4)) ; //开始的年份
int frombackmonth = Util.getIntValue(begindate.substring(5,7)) ; //开始的月份
int frombackday = Util.getIntValue(begindate.substring(8,10)); //开始的天数

if(enddate.compareTo(begindate)==0){
    i=1;
}else{

Calendar thedate1 = Calendar.getInstance ();

thedate1.set(frombackyear,frombackmonth-1,frombackday) ;  
    for(i=1;;i++){
        thedate1.add(Calendar.DATE, 1) ; //增加天数
        String forecastStartDate = Util.add0(thedate1.get(Calendar.YEAR), 4) +"-"+
                   Util.add0(thedate1.get(Calendar.MONTH) + 1, 2) +"-"+
                   Util.add0(thedate1.get(Calendar.DAY_OF_MONTH), 2) ;
        if(enddate.compareTo(forecastStartDate) <=0)
            break;
    }
    i=i+1;
}

workday= "" + i;
/**/
if(method.equals("add")&&type.equals("plan")){
%>

<HTML>
<BODY  onload="weaver.submit();" >
<FORM  id=weaver name=weaver action="/proj/plan/AddTask.jsp" method=post >
<input type="hidden" name="taskrecordid" value="<%=taskrecordid%>">
<input type="hidden" name="ProjID" value="<%=ProjID%>">
<input type="hidden" name="parentid" value="<%=parentid%>">
<input type="hidden" name="parentids" value="<%=parentids%>">
<input type="hidden" name="parenthrmids" value="<%=parenthrmids%>">
<input type="hidden" name="hrmid" value="<%=hrmid%>">
<input type="hidden" name="oldhrmid" value="<%=oldhrmid%>">
<input type="hidden" name="finish" value="<%=finish%>">
<input type="hidden" name="level" value="<%=level%>">
<input type="hidden" name="subject" value="<%=subject%>">
<input type="hidden" name="begindate" value="<%=begindate%>">
<input type="hidden" name="enddate" value="<%=enddate%>">
<input type="hidden" name="workday" value="<%=workday%>">
<input type="hidden" name="fixedcost" value="<%=fixedcost%>">
<input type="hidden" name="islandmark" value="<%=islandmark%>">
<input type="hidden" name="taskids02" value="<%=pretask%>">
<input type="hidden" name="content" value="<%=content%>">
<input type="hidden" name="sign" value="1">
</TBODY>
</FORM>
</HTML>

<%}%>

<%
if(method.equals("edit")&&type.equals("plan")){
%>

<HTML>
<BODY  onload="weaver.submit();" >
<FORM  id=weaver name=weaver action="/proj/plan/EditTask.jsp" method=post >
<input type="hidden" name="taskrecordid" value="<%=taskrecordid%>">
<input type="hidden" name="ProjID" value="<%=ProjID%>">
<input type="hidden" name="parentid" value="<%=parentid%>">
<input type="hidden" name="parentids" value="<%=parentids%>">
<input type="hidden" name="parenthrmids" value="<%=parenthrmids%>">
<input type="hidden" name="hrmid" value="<%=hrmid%>">
<input type="hidden" name="oldhrmid" value="<%=oldhrmid%>">
<input type="hidden" name="finish" value="<%=finish%>">
<input type="hidden" name="level" value="<%=level%>">
<input type="hidden" name="subject" value="<%=subject%>">
<input type="hidden" name="begindate" value="<%=begindate%>">
<input type="hidden" name="enddate" value="<%=enddate%>">
<input type="hidden" name="workday" value="<%=workday%>">
<input type="hidden" name="fixedcost" value="<%=fixedcost%>">
<input type="hidden" name="islandmark" value="<%=islandmark%>">
<input type="hidden" name="taskids02" value="<%=pretask%>">
<input type="hidden" name="content" value="<%=content%>">
<input type="hidden" name="sign" value="1">
</TBODY>
</FORM>
</HTML>

<%}%>

<%
if(method.equals("add")&&type.equals("process")){
%>

<HTML>
<BODY  onload="weaver.submit();" >
<FORM  id=weaver name=weaver action="/proj/process/AddTask.jsp" method=post >
<input type="hidden" name="taskrecordid" value="<%=taskrecordid%>">
<input type="hidden" name="ProjID" value="<%=ProjID%>">
<input type="hidden" name="parentid" value="<%=parentid%>">
<input type="hidden" name="parentids" value="<%=parentids%>">
<input type="hidden" name="parenthrmids" value="<%=parenthrmids%>">
<input type="hidden" name="hrmid" value="<%=hrmid%>">
<input type="hidden" name="oldhrmid" value="<%=oldhrmid%>">
<input type="hidden" name="finish" value="<%=finish%>">
<input type="hidden" name="level" value="<%=level%>">
<input type="hidden" name="subject" value="<%=subject%>">
<input type="hidden" name="begindate" value="<%=begindate%>">
<input type="hidden" name="enddate" value="<%=enddate%>">
<input type="hidden" name="workday" value="<%=workday%>">
<input type="hidden" name="fixedcost" value="<%=fixedcost%>">
<input type="hidden" name="islandmark" value="<%=islandmark%>">
<input type="hidden" name="taskids02" value="<%=pretask%>">
<input type="hidden" name="content" value="<%=content%>">
<input type="hidden" name="sign" value="1">
</TBODY>
</FORM>
</HTML>

<%}%>


<%
if(method.equals("edit")&&type.equals("process")){
%>

<HTML>
<BODY  onload="weaver.submit();" >
<FORM  id=weaver name=weaver action="/proj/process/EditTask.jsp" method=post >
<input type="hidden" name="taskrecordid" value="<%=taskrecordid%>">
<input type="hidden" name="ProjID" value="<%=ProjID%>">
<input type="hidden" name="parentid" value="<%=parentid%>">
<input type="hidden" name="parentids" value="<%=parentids%>">
<input type="hidden" name="parenthrmids" value="<%=parenthrmids%>">
<input type="hidden" name="hrmid" value="<%=hrmid%>">
<input type="hidden" name="oldhrmid" value="<%=oldhrmid%>">
<input type="hidden" name="finish" value="<%=finish%>">
<input type="hidden" name="level" value="<%=level%>">
<input type="hidden" name="subject" value="<%=subject%>">
<input type="hidden" name="begindate" value="<%=begindate%>">
<input type="hidden" name="enddate" value="<%=enddate%>">
<input type="hidden" name="workday" value="<%=workday%>">
<input type="hidden" name="fixedcost" value="<%=fixedcost%>">
<input type="hidden" name="islandmark" value="<%=islandmark%>">
<input type="hidden" name="taskids02" value="<%=pretask%>">
<input type="hidden" name="content" value="<%=content%>">
<input type="hidden" name="sign" value="1">
</TBODY>
</FORM>
</HTML>

<%}%>



