
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>

<%
String userid = ""+user.getUID();

 String  subid=DepartmentComInfo.getSubcompanyid1(ResourceComInfo.getDepartmentID(userid));

String supids=SubCompanyComInfo.getAllSupCompany(subid);
String sql="";
    Calendar today = Calendar.getInstance();
String currentyear= Util.add0(today.get(Calendar.YEAR), 4);
int currentmonth= today.get(Calendar.MONTH)+1;
if(supids.endsWith(",")){
    supids=supids.substring(0,supids.length()-1);
    sql="select * from hrmschedulediff where workflowid=5 and (diffscope=0 or (diffscope>0 and subcompanyid="+subid+") or (diffscope=2 and subcompanyid in("+supids+")))";
}
else
    sql="select * from hrmschedulediff where workflowid=5 and (diffscope=0 or (diffscope>0 and subcompanyid="+subid+"))";
    String sql1;
    sql1="select * from hrmschedulemonth a,hrmresource b where a.hrmid=b.id  and b.id="+userid+"  and a.theyear='"+currentyear+"'";
    RecordSet.executeSql(sql);
    //System.out.println(sql);
RecordSet1.executeSql(sql1);

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(19421,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(15880,user.getLanguage())+SystemEnv.getHtmlLabelName(1477,user.getLanguage())+",HrmScheduleMonthHistory.jsp?id=+"+userid+",_self} " ;
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
<TABLE class=Shadow>
<tr>
<td valign="top">
<b>
<%=currentyear+SystemEnv.getHtmlLabelName(17138,user.getLanguage())+SystemEnv.getHtmlLabelName(19397,user.getLanguage())+"("+user.getLastname()+")"%>
</b>
<TABLE class=ListStyle cellspacing=1>
  <TBODY>

  <TR class=spacing>

  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(15880,user.getLanguage())+SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></TH>
    <%while(RecordSet.next()){%>
    <TH><%=RecordSet.getString("diffname")%></TH>
    <%} %>
  </TR>
  <TR class=Line style="height:1px;"><TD colspan=<%=RecordSet.getCounts()+1%> style="padding:0;"></TD></TR>
<%
     
boolean isLight = false;


	while(currentmonth>0){
		if(isLight)
		{%>	
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>
    <TD><%=currentyear+"-"+Util.add0(currentmonth,2)%></TD>

   <%RecordSet.beforFirst();while(RecordSet.next()){
     String type=RecordSet.getString("id");
     RecordSet1.beforFirst();
     String val="";
     while(RecordSet1.next()){
         if(RecordSet1.getString("themonth").equals(Util.add0(currentmonth,2))&&RecordSet1.getString("difftype").equals(type)){
           val= RecordSet1.getString("hours");
           break;
         }
     }
     %>
    <TD class=Field><%=val%></TD>
     <%}%>

  </TR>
<%
	isLight = !isLight;
    currentmonth-=1;
}

%>
  <TR class=Line style="height:1px;"><TD colspan=<%=RecordSet.getCounts()+1%> style="padding:0;"></TD></TR>
   <TD><%=currentyear+"("+SystemEnv.getHtmlLabelName(358,user.getLanguage())+")"%></TD>
   <%RecordSet.beforFirst();while(RecordSet.next()){
     String type=RecordSet.getString("id");
     RecordSet1.beforFirst();
     float val=0;
     while(RecordSet1.next()){
         if(RecordSet1.getString("difftype").equals(type)){
           val+= RecordSet1.getFloat("hours");
           
         }
     }
     %>
    <TD class=Field><%=val%></TD>
     <%}%>
 </TBODY>
 </TABLE>
 	
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
function submitData() {
window.history.back();
}

function onReSearch(){
	location.href="/meeting/search/Search.jsp";
}
</script>
</body>
</html>
