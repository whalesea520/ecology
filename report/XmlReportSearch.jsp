<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="XmlReportManage" class="weaver.report.XmlReportManage" scope="page" />
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String year = Util.null2String(request.getParameter("year"));
String month = Util.null2String(request.getParameter("month"));
Calendar todaycal = Calendar.getInstance ();
if(year.equals("")){
year = Util.add0(todaycal.get(Calendar.YEAR), 4);
month = Util.add0(todaycal.get(Calendar.MONTH)+1, 2);
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(22377,user.getLanguage());
String needfav ="1";
String needhelp ="";

String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String rptFlag=Util.null2String(request.getParameter("rptFlag"));
String rptType = "";
String rptHeader = "";
if(!rptFlag.equals("")) rptType = rptFlag.substring(rptFlag.indexOf(":")+1);
if(!rptFlag.equals("")) rptHeader = rptFlag.substring(0, rptFlag.indexOf(":"));
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:checkSubmit(),_self} " ;
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
<form name=frmmain method=get action="XmlReportSearch.jsp">
<table class=ViewForm>
<colgroup>
<col width="15%">
<col width="25%">
<col width="15%">
<col width="25%">
<col width="5%">
<col width="15%">
<tbody>
<TR class="Title"> 
      <TH colSpan="2"><%=SystemEnv.getHtmlLabelName(15505,user.getLanguage())%></TH>
    </TR>
<TR class=Spacing>
  <TD colspan=8 class=line1></TD>
</TR>
<tr>    
    <td width=10%><%=SystemEnv.getHtmlLabelName(15517,user.getLanguage())%></td>
    <td class=field>
	<select class=inputstyle name="rptFlag" onchange="changeReport(this);checkinput('rptFlag','rptFlagimage')">
	<option value=""></option>
	<%
	Map viewMap = new HashMap();
	StringBuffer s = new StringBuffer();
	s.append("select distinct t2.relateditemid as rptFlag from HrmResource t1, XMLREPORT_ShareInfo t2 where ");
	s.append("t1.id='"+user.getUID()+"' and (");
	s.append("(t2.sharetype = 4 and t2.foralluser = 1 and t2.seclevel <= t1.seclevel) ");
	s.append("or (t2.sharetype = 1 and t2.userid = t1.id) ");
	s.append("or (t2.sharetype = 2 and t2.departmentid = t1.departmentid and t2.seclevel <= t1.seclevel) ");
	s.append("or (t2.sharetype = 3 and t1.id in (SELECT resourceid FROM hrmrolemembers where roleid = t2.roleid) and t2.seclevel <= t1.seclevel) ");
	s.append(")");
	rs.executeSql(s.toString());
	out.println(s.toString());
	while(rs.next()) {
		viewMap.put(rs.getString("rptFlag"), "X");
	}
	Map rptNameMap = XmlReportManage.getReportName();
	Iterator it = rptNameMap.entrySet().iterator();
	while(it.hasNext()) {
		Map.Entry entry = (Map.Entry) it.next();
		//out.println(entry.getKey()+"  "+entry.getValue()+"<br>");
		String fg = entry.getKey().toString();
		fg = fg.substring(0, fg.indexOf(":"));
		if(viewMap.get(fg)==null) continue;
	%>
         <option value=<%=entry.getKey()%> <%if(rptFlag.equals(entry.getKey())){%>selected<%}%>><%=entry.getValue()%></option>
	<%
	}
	%>
       </select><SPAN id="rptFlagimage"><%if(rptFlag.equals("")){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN>
    </td>
     <td width=10%><%=SystemEnv.getHtmlLabelName(22376,user.getLanguage())%></td>
    <td class=field><div id="D_DIV" style="display:none">
    <BUTTON class=calendar id=SelectDate onclick=getDate(fromdatespan,fromdate)></BUTTON>&nbsp;
    <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
    <input class=inputstyle type="hidden" name="fromdate" value=<%=fromdate%>>
    －<BUTTON class=calendar id=SelectDate onclick=getDate(enddatespan,enddate)></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
    <input class=inputstyle type="hidden" name="enddate" value=<%=enddate%>></div>
	<select id="Y_DIV" style="display:none" name="year">
	<%
	int yrs = Util.getIntValue(weaver.file.Prop.getPropValue("xmlreport", "report.years"),10);
	int yr = Util.getIntValue(Util.add0(todaycal.get(Calendar.YEAR), 4));
	for(int i=0; i<yrs; i++) {
	%>
		<option value="<%=yr%>" <%if(year.equals(""+yr)){%>selected<%}%>><%=yr%></option>
	<%
		yr--;
	}
	%>
	</select>
	<select id="M_DIV" style="display:none" name="month">
	<%
	for(int i=1; i<=12; i++) {
	%>
		<option value="<%if(i<10){%>0<%}%><%=i%>" <%if(!month.equals("") && Util.getIntValue(month)==i){%>selected<%}%>><%if(i<10){%>0<%}%><%=i%></option>
	<%
	}
	%>
	</select>
    </td>
</tr>
<TR><TD class=Line colSpan=6></TD></TR> 
</tbody>
</table>
<table class=ListStyle cellspacing=1 >
<colgroup>
<col width="50">
<col width="200">
<col>
<col width="150">
</colgroup>
<tbody>
   <tr class=header>
    <td><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></td>
	<td><%=SystemEnv.getHtmlLabelName(22376,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(15517,user.getLanguage())%></td>
	<!--td><%=SystemEnv.getHtmlLabelName(22376,user.getLanguage())%></td-->
  </tr>
  <TR class=Line><TD colspan="5" ></TD></TR>
<%
boolean isRemote = Util.null2String(weaver.file.Prop.getPropValue("xmlreport", "report.remote")).equals("1") || Util.null2String(weaver.file.Prop.getPropValue("xmlreport", "report.remote")).equals("");
if(isRemote) {
	String updateDate = "";
	if(rptType.equals("D")) updateDate = fromdate;
	else if(rptType.equals("Y")) updateDate = year;
	else if(rptType.equals("M")) updateDate = year+"-"+month;
	List list = XmlReportManage.getXmlFile(rptHeader, rptType, updateDate, Util.null2String(enddate));
	for(int i=1; i<=list.size(); i++) {
		String[] strs = new String[2];
		strs = (String[]) list.get(i-1);
%>
  <TR>
    <TD><%=i%></TD>
	<TD><%=strs[0]%></TD>
    <TD><a href="XmlReportViewer.jsp?rptName=<%=rptHeader+strs[0]+".xml"%>&rptFlag=<%=rptHeader%>"><%=rptNameMap.get(rptFlag)%><%=strs[0]%></a></TD>
  </TR>
<%
	}
}
else {
	String sql = "SELECT * FROM XmlReport WHERE 1=1 ";
	if(rptType.equals("D")) {
		if(!fromdate.equals(""))
			sql += "AND rptDate>='"+fromdate+"' ";
		if(!enddate.equals(""))
			sql += "AND rptDate<='"+enddate+"' ";
	}
	else if(rptType.equals("Y")) {
		sql += "AND rptDate='"+year+"' ";
	}
	else if(rptType.equals("M")) {
		sql += "AND rptDate='"+year+"-"+month+"' ";
	}
	//out.println("--->"+tempType+"<br>");
	if(!rptFlag.equals("")) sql += "AND rptFlag='"+rptFlag.substring(0, rptFlag.indexOf(":"))+"' ";
	if(!rptType.equals(""))
		rs.executeSql(sql);
	//out.println(sql);
	int i = 0;
	while(rs.next()) {
		i++;
%>
  <TR>
    <TD><%=i%></TD>
	<TD><%=rs.getString("rptDate")%></TD>
    <TD><a href="XmlReportViewer.jsp?rptName=<%=rs.getString("rptName")%>&rptFlag=<%=rptHeader%>"><%=rs.getString("rptTitle")%>
	</a></TD>
	<!--td><%=rs.getString("updateDate")%></td-->
  </TR> 
<%
	}
}
%>
</table>
<br>
</form>

<script language=javascript>  
function submitData() {
 frmmain.submit();
}
</script>

<script language=vbs>
sub onShowScheduleDiff(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/schedule/HrmScheduleDiffBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> 0 then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHtml = ""
		document.all(inputename).value=""
		end if
	end if
end sub
</script>
</body>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
<script>
function changeReport(obj) {
	try {
		var type = obj.value.substring(obj.value.indexOf(":")+1);
		//alert(type);
		if(type=='D') document.getElementById('D_DIV').style.display='';
		else document.getElementById('D_DIV').style.display='none';
		if(type=='M') document.getElementById('M_DIV').style.display='';
		else document.getElementById('M_DIV').style.display='none';
		if(type=='Y' || type=='M') document.getElementById('Y_DIV').style.display='';
		else document.getElementById('Y_DIV').style.display='none';
	}
	catch(e){alert('<%=SystemEnv.getHtmlLabelName(22383,user.getLanguage())%>!');}
}
<%
if(!rptType.equals("")) {
%>
	document.getElementById('<%=rptType%>_DIV').style.display='';
<%
	if(rptType.equals("M")) {
%>
	document.getElementById('Y_DIV').style.display='';
<%
	}
}
%>

function checkSubmit() {
	var obj = document.getElementById('rptFlag');
	if(obj.value!=''){
		submitData();
	}
	else {
		obj.focus();
		alert('<%=SystemEnv.getHtmlLabelName(22384,user.getLanguage())%>!');
	}
}
</script>