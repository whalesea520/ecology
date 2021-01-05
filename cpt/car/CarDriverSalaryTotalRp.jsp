
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
if(!HrmUserVarify.checkUserRight("Car:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17631,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17676,user.getLanguage());

String needfav ="1";
String needhelp ="";


String sql="" ;
String show=Util.fromScreen(request.getParameter("show"),user.getLanguage());
String driverid = Util.fromScreen(request.getParameter("driverid"),user.getLanguage());
String startdate1 = Util.fromScreen(request.getParameter("startdate1"),user.getLanguage());
String startdate2 = Util.fromScreen(request.getParameter("startdate2"),user.getLanguage());
//String starttime1 = Util.fromScreen(request.getParameter("starttime1"),user.getLanguage());
//String starttime2 = Util.fromScreen(request.getParameter("starttime2"),user.getLanguage());

if(show.equals("default")){
    Calendar today = Calendar.getInstance();
    String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                         Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                         Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
    int thisyear=today.get(Calendar.YEAR);
    int thismonth=today.get(Calendar.MONTH);
    int thisday=today.get(Calendar.DAY_OF_MONTH)+1;

    int fromday=1;
    int endday=0;
    today.set(thisyear,thismonth,fromday);
    startdate1= Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
    today.set(thisyear,thismonth+1,endday);
    startdate2=Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                   Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                   Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(354,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

	<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
		<colgroup>
		<col width="10">
		<col width="">
		<col width="10">
	
		<tr>
			<td height="10" colspan="3"></td>
		</tr>
		<tr>
			<td ></td>
			<td valign="top">
			
			<TABLE class="Shadow">
			<tr>
			<td valign="top">
			
<form name=frmmain action="CarDriverSalaryTotalRp.jsp">

<table class=viewform>
  <COLGROUP>
  <COL width="10%"><COL width="40%"><COL width="10%"><COL width="40%">
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(17649,user.getLanguage())%></td>
    <TD class=Field>
        <select name="driverid" size=1 style="width:80%" onchange="frmmain.submit()">
        <option value=""><%=SystemEnv.getHtmlLabelName(17650,user.getLanguage())%></option>
<%
     sql="select distinct driverid from cardriverdata";
     RecordSet.executeSql(sql);
     while(RecordSet.next()){
        String tmpdriverid=RecordSet.getString("driverid");
        String tmpdrivername=ResourceComInfo.getResourcename(tmpdriverid+"");
        String selected ="" ;
        if(tmpdriverid.equals(driverid))    selected="selected " ;
%>      <option value="<%=tmpdriverid%>" <%=selected%>><%=tmpdrivername%></option>
<%
     }
%>
        </select>
    </TD>
      
    <td><%=SystemEnv.getHtmlLabelName(17656,user.getLanguage())%>
    <TD class=Field><BUTTON type='button' class=Calendar onclick="getStartdate1()"></BUTTON>
    <input type=hidden name="startdate1" value="<%=startdate1%>">
    <SPAN id=startdate1span><%=startdate1%></SPAN>&nbsp;&nbsp;&nbsp;-
    <BUTTON type='button' class=Calendar onclick="getStartdate2()"></BUTTON>
    <input type=hidden name="startdate2" value="<%=startdate2%>">
    <SPAN id=startdate2span><%=startdate2%></SPAN>
  </tr>
</table>
</form>

<br>
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
  <COL width="10%"><COL width="10%"><COL width="10%"><COL width="10%"><COL width="10%">
  <COL width="10%"><COL width="10%"><COL width="10%"><COL width="20%">
  <TBODY>
  <TR class=Header><th colspan=9><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></th></tr>
  <TR class=separator>
    <TD class=Sep1 colSpan=9></TD></TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(17649,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(17659,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(17685,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(17662,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(17686,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(17682,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(17683,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(17684,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(17687,user.getLanguage())%></TD>
  </tr>
<%
    //司机基本基数信息
    sql = "select * from cardriverbasicinfo";
	RecordSet.executeSql(sql);
	RecordSet.next();
    String basicsalary = RecordSet.getString("basicsalary");
    float receptionpara = RecordSet.getFloat("receptionpara");
    float basickm = RecordSet.getFloat("basicKM");
    float basickmpara = RecordSet.getFloat("basicKMpara");
    float basictime = RecordSet.getFloat("basictime");
    float basictimepara = RecordSet.getFloat("basictimepara");
    int basicout = RecordSet.getInt("basicout");
    float basicoutpara = RecordSet.getFloat("basicoutpara");
    
    boolean islight=true;
    sql="select * from cardriverdata ";
    String sqlwhere = "" ;
    if(!driverid.equals("")){
        if(sqlwhere.equals(""))
            sqlwhere+=" where driverid =" + driverid ;
        else 
            sqlwhere+=" and driverid =" + driverid ;
    }
    if(!startdate1.equals("")){
        if(sqlwhere.equals(""))
            sqlwhere+=" where startdate >='" + startdate1 + "'" ;
        else 
            sqlwhere+=" and startdate >='" + startdate1 + "'" ;
    }
    if(!startdate2.equals("")){
        if(sqlwhere.equals(""))
            sqlwhere+=" where startdate <='" + startdate2 + "'" ;
        else 
            sqlwhere+=" and startdate <='" + startdate2 + "'" ;
    }
    
    sql=sql + sqlwhere + " order by driverid,startdate desc,starttime desc" ;

    String tmpsql="";
    String tmpdriverid="";
    float totalrunkm = 0;
    float totalruntime =0;
    float totalkm = 0;
    float totaltime = 0 ;
    int totalcarout = 0 ;
    int totalreception = 0 ;
    float floatsalary = 0 ;
    float totalsalary = 0 ;
    float countrunkm = 0;
    float countruntime =0;
    float counttotalkm = 0 ;
    float counttotaltime = 0 ;
    int countcarout = 0 ;
    int countreception = 0 ;
    float countfloatsalary = 0 ;
    float counttotalsalary = 0 ;
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
        boolean showtotal=false ;
        
    	String	driverid1=RecordSet.getString("driverid");
    	int  isreception=RecordSet.getInt("isreception");
    	int  iscarout=RecordSet.getInt("iscarout");
    	String  startdate = RecordSet.getString("startdate");
    	String  starttime = RecordSet.getString("starttime");
    	String  backtime = RecordSet.getString("backtime");
    	String  remark = RecordSet.getString("remark");
    	float	runkm=RecordSet.getFloat("runKM");
    	float  runtime = RecordSet.getFloat("runtime");
    	float  normalkm = RecordSet.getFloat("normalkm");
    	float  overtimekm = RecordSet.getFloat("overtimekm");
    	float  normaltime = RecordSet.getFloat("normaltime");
    	float  overtime = RecordSet.getFloat("overtime");
    	float  realkm = RecordSet.getFloat("realkm");
    	float  realtime = RecordSet.getFloat("realtime");
    	
    	String drivername=ResourceComInfo.getResourcename(driverid1+"");
    	
    	if(!tmpdriverid.equals(driverid1)){
    	    tmpdriverid=driverid1 ;
    	    totalrunkm = runkm ;
    	    totalruntime = runtime ;
    	    totalkm = realkm ;
    	    totaltime = realtime ;
    	    totalcarout = iscarout ;
    	    totalreception = isreception ;
    	} else {
    	    totalrunkm += runkm ;
    	    totalruntime += runtime ;
    	    totalkm += realkm ;
    	    totaltime += realtime ;
    	    totalcarout += iscarout ;
    	    totalreception += isreception ;
    	}
    	if(RecordSet.next()){
    	    if(!tmpdriverid.equals(RecordSet.getString("driverid")))
    	        showtotal=true ;
    	    RecordSet.previous() ;
    	}
    	else    showtotal=true ;
    	
    	if(showtotal){
    	    float extkm = totalkm - basickm ;
    	    //if(extkm<0) extkm = 0 ;
    	    float exttime = totaltime - basictime ;
    	    //if(exttime<0) exttime = 0 ;
    	    int extout = totalcarout - basicout ;
    	    //if(extout<0)    extout = 0 ;
    	    floatsalary = extkm * basickmpara + exttime * basictimepara + extout*basicoutpara + totalreception*receptionpara ;
    	    
    	    /*
    	    float extkm1 = basickm - totalkm ;
    	    if(extkm1<0) extkm1 = 0 ;
    	    float exttime1 = basictime - totaltime ;
    	    if(exttime1<0) exttime1 = 0 ;
    	    int extout1 = basicout - totalcarout ;
    	    if(extout1<0)    extout1 = 0 ;
    	    float basicsalary1 = Util.getFloatValue(basicsalary) - (extkm1 * basickmpara + exttime1 * basictimepara + extout1*basicoutpara);
    	    basicsalary1 = (float) (int)(basicsalary1*100)/100 ;
    	    totalsalary = basicsalary1 + floatsalary ;
    	    */
    	    totalsalary = Util.getFloatValue(basicsalary) + floatsalary ;
    	    countfloatsalary+=floatsalary ;
    	    counttotalsalary+=totalsalary ;
    	    countrunkm += totalrunkm;
            countruntime +=totalruntime;
            counttotalkm +=totalkm ;
            counttotaltime += totaltime ;
            countcarout += totalcarout ;
            countreception += totalreception ;
            floatsalary = (float) ((int)(floatsalary*100))/100 ;
    	}
    	
%>
<%if(showtotal){%>
  <TR <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
    <td><%=drivername%></td>
    <td><%=Util.getPointValue(String.valueOf(totalrunkm),2,"0.00")%></td>
    <td><%=Util.getPointValue(String.valueOf(totalkm),2,"0.00")%></td>
    <td><%=Util.getPointValue(String.valueOf(totalruntime),2,"0.00")%></td>
    <td><%=Util.getPointValue(String.valueOf(totaltime),2,"0.00")%></td>
    <td><%=totalcarout%></td>
    <td><%=totalreception%></td>
    <td><%=Util.getPointValue(String.valueOf(floatsalary),2,"0.00")%></td>
    <td><%=Util.getPointValue(String.valueOf(totalsalary),2,"0.00")%></td>
  </tr>
<%}%>
<%
        islight=!islight ; 
    }
%>  
  <TR class=TOTAL style="FONT-WEIGHT: bold; COLOR: red">
    <TD><%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%></TD>
    <TD align=right><%=Util.getFloatStr(Util.getPointValue(String.valueOf(countrunkm),2,"0.00"),3)%></TD>	
    <TD align=right><%=Util.getFloatStr(Util.getPointValue(String.valueOf(counttotalkm),2,"0.00"),3)%></TD>	
    <TD align=right><%=Util.getFloatStr(Util.getPointValue(String.valueOf(countruntime),2,"0.00"),3)%></TD>	
    <TD align=right><%=Util.getFloatStr(Util.getPointValue(String.valueOf(counttotaltime),2,"0.00"),3)%></TD>	
    <TD align=right><%=countcarout%></TD>	
    <TD align=right><%=countreception%></TD>	
    <td align=right><%=Util.getFloatStr(Util.getPointValue(String.valueOf(countfloatsalary),2,"0.00"),3)%></td>	
    <td align=right><%=Util.getFloatStr(Util.getPointValue(String.valueOf(counttotalsalary),2,"0.00"),3)%></td>
  </tr>
 </TBODY></TABLE>
			
			</td>
			</tr>
			</TABLE>
			
			</td>
			<td></td>
		</tr>
		<tr>
			<td height="10" colspan="3"></td>
		</tr>
	</table>

<script language=javascript>
 function onSubmit(){
	document.frmmain.submit();
 }
 </script>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
