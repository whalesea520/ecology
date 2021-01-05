<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="LedgerComInfo" class="weaver.fna.maintenance.LedgerComInfo" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(189,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%
String resourceid=Util.fromScreen(request.getParameter("resourceid"),user.getLanguage());
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String todate=Util.fromScreen(request.getParameter("todate"),user.getLanguage());
String basictype=Util.fromScreen(request.getParameter("basictype"),user.getLanguage());
String detailtype=Util.fromScreen(request.getParameter("detailtype"),user.getLanguage());

if(resourceid.equals(""))	resourceid=""+user.getUID();

String resourcename=ResourceComInfo.getResourcename(resourceid);
Calendar now = Calendar.getInstance();
String today=Util.add0(now.get(Calendar.YEAR), 4) +"-"+
			Util.add0(now.get(Calendar.MONTH) + 1, 2) +"-"+
        	Util.add0(now.get(Calendar.DAY_OF_MONTH), 2) ;
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=10;
boolean hasNextPage=false;
%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:onReset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{-}" ;	
if(pagenum>1){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",/hrm/resource/HrmResourceExchange.jsp?pagenum="+(pagenum-1)+"&resourceid="+resourceid+"&fromdate="+fromdate+"&todate="+todate+"&basictype="+basictype+"&detailtype="+detailtype+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(hasNextPage){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",/hrm/resource/HrmResourceExchange.jsp?pagenum="+(pagenum-1)+"&resourceid="+resourceid+"&fromdate="+fromdate+"&todate="+todate+"&basictype="+basictype+"&detailtype="+detailtype+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
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

<form name=frmmain method=post action="HrmResourceExchange.jsp">
  <table class=viewform>
  	<col width=15%><col width=35%><col width=15%><col width=35%>
  	<TR CLASS=title> 
      <TH colspan=8><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH>
    </TR>
    <TR Class=spacing> 
      <TD CLASS=line1 colspan=8></TD>
    </TR>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
      <td class=field>
        <BUTTON class=Browser id=SelecResourceid onClick="onShowResourceID()"></BUTTON> 
        <span id=resourceidspan> <A href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>"><%=resourcename%></A></span> 
        <INPUT class=inputstyle id=resourceid type=hidden name=resourceid value="<%=resourceid%>">
      </td>
      <td><%=SystemEnv.getHtmlLabelName(446,user.getLanguage())%></td>
      <td class=field>
      	<button class=calendar onclick="getfromDate()"></button>
        <span id=fromdatespan><%=Util.toScreen(fromdate,user.getLanguage())%></span>-
        <button class=calendar onclick="gettoDate()"></button>
        <span id=todatespan><%=Util.toScreen(todate,user.getLanguage())%></span>
        <input type=hidden name="fromdate" value="<%=fromdate%>">
        <input type=hidden name="todate" value="<%=todate%>">
      </td>
	</tr>
    <TR><TD class=Line colSpan=6></TD></TR> 
	<tr>    
      <td><%=SystemEnv.getHtmlLabelName(863,user.getLanguage())%></td>
      <td class=field>
      	<select class=inputstyle name=basictype size=1 style="width:60%" onchange="onBasicSelect()">
      		<option value="" <%if(basictype.equals("")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
      		<option value="1" <%if(basictype.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1945,user.getLanguage())%></option>
      		<option value="2" <%if(basictype.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1946,user.getLanguage())%></option>
      		<option value="3" <%if(basictype.equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1947,user.getLanguage())%></option>
      		<option value="4" <%if(basictype.equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1948,user.getLanguage())%></option>
      	</select>
      </td>

      <td><%=SystemEnv.getHtmlLabelName(1281,user.getLanguage())%></td>
      <td class=field>
      	<%if(basictype.equals("")){%>
      	<select class=inputstyle name=detailtype size=1 style="width:60%" onchange="onDetailSelect()">
      		<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
      	</select>
      	<%}%>
      	<%if(basictype.equals("1")){%>
      	<select class=inputstyle name=detailtype size=1 style="width:90%" onchange="onDetailSelect()">
      		<option value="" <%if(detailtype.equals("")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
      		<option value="1" <%if(detailtype.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1949,user.getLanguage())%></option>
      	</select>
      	<%}%>
      	<%if(basictype.equals("2")){%>
      	<select class=inputstyle name=detailtype size=1 style="width:90%" onchange="onDetailSelect()">
      		<option value="" <%if(detailtype.equals("")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
      		<option value="1" <%if(detailtype.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1950,user.getLanguage())%></option>
      		<option value="2" <%if(detailtype.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1951,user.getLanguage())%></option>
      	</select>
      	<%}%>
      	<%if(basictype.equals("3")){%>
      	<select class=inputstyle name=detailtype size=1 style="width:90%" onchange="onDetailSelect()">
      		<option value="" <%if(detailtype.equals("")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
      		<option value="1" <%if(detailtype.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1952,user.getLanguage())%></option>
      	</select>
      	<%}%>
      	<%if(basictype.equals("4")){%>
      	<select class=inputstyle name=detailtype size=1 style="width:90%" onchange="onDetailSelect()">
      		<option value="" <%if(detailtype.equals("")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
      		<option value="1" <%if(detailtype.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1953,user.getLanguage())%></option>
      	</select>
      	<%}%>
      </td>
    </tr>
   <TR><TD class=Line colSpan=6></TD></TR> 
  </table>
  <br>
<%
boolean islight=true;
int totalline=1;
String temptable = "temptable"+ Util.getNumberRandom() ;
String sql="";
if(RecordSet.getDBType().equals("oracle")){
	sql = "create table "+temptable+"  as select * from (select t1.* from bill_hrmFinance t1,workflow_requestbase t2 "+
		" where t1.resourceid="+resourceid+" and t1.requestid=t2.requestid and t2.currentnodetype='3'";
}else{
	sql="select top "+(pagenum*perpage+1)+" t1.* into "+temptable+
		" from bill_hrmFinance t1,workflow_requestbase t2 "+
		" where t1.resourceid="+resourceid+" and t1.requestid=t2.requestid and t2.currentnodetype='3'";
}
if(!basictype.equals(""))	sql+=" and t1.basictype="+basictype;
if(!detailtype.equals(""))	sql+=" and t1.detailtype="+detailtype;
if(!fromdate.equals(""))	sql+=" and t1.occurdate>='"+fromdate+"'";
if(!todate.equals(""))		sql+=" and t1.occurdate<='"+todate+"'";
else	sql+=" and t1.occurdate<='"+today+"'";

if(RecordSet.getDBType().equals("oracle")){
	sql+=" order by occurdate desc) where rownum<"+ (pagenum*perpage+2);
}else{
	sql+=" order by occurdate desc";
}

RecordSet.executeSql(sql);
RecordSet.executeSql("Select count(id) RecordSetCounts from "+temptable);
int RecordSetCounts = 0;
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}
if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}
	String sqltemp="";
if(RecordSet.getDBType().equals("oracle")){
	sqltemp="select * from (select * from  "+temptable+" order by occurdate) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
}else{
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+"  order by occurdate ";
}

RecordSet.executeSql(sqltemp);
RecordSet.executeSql("drop table "+temptable);
%>  
  <table class=ListStyle cellspacing=1 >
  	<col width=10%>
    <col width=12%>
    <col width=13%>
    <col width=15%>
  	<col width=10%>
    <col width=15%>
    <col width=10%>
    <col width=15%>
  	<TR CLASS=Header> 
      <TH colspan=8><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></TH>
    </TR>
     <tr class=header>
      <td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>	
      <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>	
      <td><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>	
      <td><%=SystemEnv.getHtmlLabelName(534,user.getLanguage())%></td>	
      <td><%=SystemEnv.getHtmlLabelName(796,user.getLanguage())%></td>	
      <td><%=SystemEnv.getHtmlLabelName(797,user.getLanguage())%></td>	
      <td><%=SystemEnv.getHtmlLabelName(798,user.getLanguage())%></td>	
      <td><%=SystemEnv.getHtmlLabelName(799,user.getLanguage())%></td>	
	</tr>
    <TR class=Line><TD colspan="8" ></TD></TR> 
<%while(RecordSet.next()){
	String occurdate=RecordSet.getString("occurdate");
	String tmpbasictype=RecordSet.getString("basictype");
	String tmpdetailtype=RecordSet.getString("detailtype");
	String name=RecordSet.getString("name");
	String requestid=RecordSet.getString("requestid");
	String amount=RecordSet.getString("amount");
	String debitledgeid=RecordSet.getString("debitledgeid");
	String debitremark=RecordSet.getString("debitremark");
	String creditledgeid=RecordSet.getString("creditledgeid");
	String creditremark=RecordSet.getString("creditremark");
	String currencyid=RecordSet.getString("currencyid");
	String currencyname=CurrencyComInfo.getCurrencyname(currencyid);
	String typename="";
	if(tmpbasictype.equals("1"))	typename=Util.toScreen(SystemEnv.getHtmlLabelName(1949,user.getLanguage()),user.getLanguage(),"0");
	if(tmpbasictype.equals("2")){
		if(tmpdetailtype.equals("1"))
			typename=Util.toScreen(SystemEnv.getHtmlLabelName(1950,user.getLanguage()),user.getLanguage(),"0");
		if(tmpdetailtype.equals("2"))
			typename=Util.toScreen(SystemEnv.getHtmlLabelName(1951,user.getLanguage()),user.getLanguage(),"0");
	}
	if(tmpbasictype.equals("3"))	typename=Util.toScreen(SystemEnv.getHtmlLabelName(1952,user.getLanguage()),user.getLanguage(),"0");
	if(tmpbasictype.equals("4"))	typename=Util.toScreen(SystemEnv.getHtmlLabelName(1953,user.getLanguage()),user.getLanguage(),"0");
%>	
	<tr <%if(islight){%> class=datadark <%} else {%> class=datalight <%}%>>
	  <td><%=Util.toScreen(occurdate,user.getLanguage())%></td>
	  <td><%=typename%></td>
	  <td><a href="/workflow/request/ViewRequest.jsp?requestid=<%=requestid%>">
	  <%=Util.toScreen(name,user.getLanguage())%></a></td>
	  <td><%=Util.toScreen(currencyname,user.getLanguage())%> <%=amount%></td>
	  <td><%=Util.toScreen(LedgerComInfo.getLedgername(debitledgeid),user.getLanguage())%></td>
	  <td><%=Util.toScreen(debitremark,user.getLanguage())%></td>
	  <td><%=Util.toScreen(LedgerComInfo.getLedgername(creditledgeid),user.getLanguage())%></td>
	  <td><%=Util.toScreen(creditremark,user.getLanguage())%></td>
	</tr>
<%	islight=!islight;
	if(hasNextPage){
		totalline+=1;
		if(totalline>perpage)	break;
	}
 }%>
   
  </table>
</form>
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
 frmMain.submit();

 function onReset() {
 frmmain.reset();
}

function onBasicSelect(){
	frmmain.detailtype.value="";
	frmmain.submit();
}
function onDetailSelect(){
	frmmain.submit();
}
</script>
<script language=vbs>
sub onShowResourceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	frmmain.resourceid.value=id(0)
	document.frmmain.submit()
	end if
	end if
end sub
</script>
</body>
</table>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>