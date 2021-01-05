
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
String titlename = SystemEnv.getHtmlLabelName(17631,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17674,user.getLanguage());

String needfav ="1";
String needhelp ="";

String sql="" ;
String show=Util.fromScreen(request.getParameter("show"),user.getLanguage());
String departmentid = Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());
String cartypeid = Util.fromScreen(request.getParameter("cartypeid"),user.getLanguage());
String startdate1 = Util.fromScreen(request.getParameter("startdate1"),user.getLanguage());
String startdate2 = Util.fromScreen(request.getParameter("startdate2"),user.getLanguage());

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
			
<form name=frmmain action="CarUseRp.jsp">

<table class=viewform>
  <COLGROUP>
  <COL width="10%"><COL width="20%"><COL width="10%"><COL width="20%"><COL width="10%"><COL width="30%">
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
    <TD class=Field>
        <select name="departmentid" size=1 style="width:80%" onchange="frmmain.submit()">
        <option value=""><%=SystemEnv.getHtmlLabelName(17679,user.getLanguage())%></option>
<%
     sql="select distinct usedepartment from cardriverdata";
     RecordSet.executeSql(sql);
     while(RecordSet.next()){
        String tmpid=RecordSet.getString("usedepartment");
        String tmpname=DepartmentComInfo.getDepartmentname(tmpid);
        String selected ="" ;
        if(tmpid.equals(departmentid))    selected="selected " ;
%>      <option value="<%=tmpid%>" <%=selected%>><%=tmpname%></option>
<%
     }
%>
        </select>
    </TD>
      
    <td><%=SystemEnv.getHtmlLabelName(17651,user.getLanguage())%></td>
    <td class=field>
        <select name="cartypeid" size=1 style="width:80%" onchange="frmmain.submit()">
        <option value=""><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(17651,user.getLanguage())%></option>
<%
     sql="select * from cartype";
     RecordSet.executeSql(sql);
     while(RecordSet.next()){
        String tempCartypeid=RecordSet.getString("id");
        String cartypename=RecordSet.getString("name");
        String selected ="" ;
        if(tempCartypeid.equals(cartypeid))    selected="selected " ;
%>      <option value="<%=tempCartypeid%>" <%=selected%>><%=cartypename%></option>
<%
     }
%>
        </select>
    </td>

    <td><%=SystemEnv.getHtmlLabelName(17656,user.getLanguage())%></td>
    <TD class=Field><BUTTON class=Calendar onclick="getStartdate1()"></BUTTON>
    <input type=hidden name="startdate1" value="<%=startdate1%>">
    <SPAN id=startdate1span><%=startdate1%></SPAN>&nbsp;&nbsp;&nbsp;-
    <BUTTON class=Calendar onclick="getStartdate2()"></BUTTON>
    <input type=hidden name="startdate2" value="<%=startdate2%>">
    <SPAN id=startdate2span><%=startdate2%></SPAN></td>
  </tr>
</table>
</form>

<br>
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
  <COL width="15%"><COL width="10%"><COL width="10%"><COL width="10%">
  <COL width="10%"><COL width="10%"><COL width="20%"><COL width="10%">
  <TBODY>
  <TR class=Header><th colspan=8><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></th></tr>
  <TR class=separator>
    <TD class=Sep1 colSpan=8></TD></TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(17656,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(17657,user.getLanguage())%></TD>
    <td><%=SystemEnv.getHtmlLabelName(17651,user.getLanguage())%></td>
    <TD><%=SystemEnv.getHtmlLabelName(17659,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(17670,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(17680,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1491,user.getLanguage())%></TD>
  </TR>
<% 
    boolean islight=true;
    sql="select * from cardriverdata ";
    String sqlwhere = "" ;
    if(!departmentid.equals("")){
        if(sqlwhere.equals(""))
            sqlwhere+=" where (','+usedepartment+',') like '%" + (","+departmentid+",") +"%'" ;
        else 
            sqlwhere+=" and (','+usedepartment+',') like '%" + (","+departmentid+",") +"%'" ;
    }
    if(!cartypeid.equals("")){
        if(sqlwhere.equals(""))
            sqlwhere+=" where cartypeid = " + cartypeid ;
        else 
            sqlwhere+=" and cartypeid = " + cartypeid;
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
    
    sql=sql + sqlwhere + " order by startdate desc,starttime desc" ;
    
    String tmpsql="";
    float totalfee = 0 ;
    float totalkm = 0 ;
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
    	String	usedepartment=RecordSet.getString("usedepartment");
    	float	runkm=RecordSet.getFloat("runKM");
    	String  cartypeid1 = RecordSet.getString("cartypeid");
    	String  startdate = RecordSet.getString("startdate");
    	String  starttime = RecordSet.getString("starttime");
    	String  backtime = RecordSet.getString("backtime");
    	String  useperson = RecordSet.getString("useperson");
    	String  remark = RecordSet.getString("remark");
    	
    	rs.executeProc("CarType_SelectByID",cartypeid1);
    	rs.next();
    	String cartypename=rs.getString("name");
    	float usefee = rs.getFloat("usefee");
    	float tmpfee = runkm * usefee ;
    	
    	ArrayList departmentids = Util.TokenizerString(usedepartment,",");
    	String usedepartmentname = "" ;
    	    	
    	for(int i=0;i<departmentids.size(); i++){
    	    String tmpdepartmentid = (String) departmentids.get(i);
    	    usedepartmentname+=","+DepartmentComInfo.getDepartmentname(tmpdepartmentid);
    	}
    	if(!usedepartmentname.equals(""))   usedepartmentname=usedepartmentname.substring(1);
        if(!departmentid.equals("")){
    	    if(departmentids.size()>1){
    	        tmpfee=tmpfee/departmentids.size();
    	    }
        }

        ArrayList usepersonids = Util.TokenizerString(useperson,",");
    	String usepersonname = "" ;
    	    	
    	for(int i=0;i<usepersonids.size(); i++){
    	    String tmpusepersonid = (String) usepersonids.get(i);
    	    usepersonname+=","+ResourceComInfo.getResourcename(tmpusepersonid+"");
    	}
    	if(!usepersonname.equals(""))   usepersonname=usepersonname.substring(1);
    	tmpfee=(float)((int)(tmpfee*100))/100;
    	
%>
    <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
        <TD><%=usedepartmentname%></TD>
        <TD><%=startdate%></TD>
        <td><%=starttime%>-<%=backtime%></td>
        <TD><%=cartypename%></TD>
        <td><%=Util.getPointValue(String.valueOf(runkm),2,"0.00")%></td>
        <td><%=usepersonname%></td>
        <td><%=remark%></td>
        <td><%=Util.getPointValue(String.valueOf(tmpfee),2,"0.00")%></td>
    </TR>
<%
        islight=!islight ; 
        totalfee+=tmpfee ;
        totalkm +=runkm ;
    }
%>  
  <TR class=TOTAL style="FONT-WEIGHT: bold; COLOR: red">
    <TD><%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%></TD>
    <TD colspan=4 align=right><%=Util.getFloatStr(Util.getPointValue(String.valueOf(totalkm),2,"0.00"),3)%></TD>
    <TD colspan=3 align=right><%=Util.getFloatStr(Util.getPointValue(String.valueOf(totalfee),2,"0.00"),3)%></TD>	
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