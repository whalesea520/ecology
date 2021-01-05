<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util,java.util.*" %>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="customerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<%@ include file="/datacenter/maintenance/inputreport/InputReportHrmInclude.jsp" %>

<%
String inprepid = Util.null2String(request.getParameter("inprepid"));
String fromcheck = Util.null2String(request.getParameter("fromcheck"));

String thecloseperiod = "" ;
rs.executeSql("select fnayearperiodsid from FnaYearsPeriodsList where isclose='1' ");
while(rs.next()) {
    thecloseperiod += "," + Util.null2String(rs.getString(1)) ;
}

thecloseperiod += "," ;

// 是否具有月修正和年修正的权利, 是否可以选择其它客户
boolean hasmodright = false ;
boolean hasselcrmright = false ;
String theselcrmids = "" ;

this.rs=rs;
this.req=request;
Map inReportHrm=null;
if(!fromcheck.equals("1")) {
	inReportHrm=this.getHrmSecurityInfoByUserId(user.getUID(),Integer.parseInt(inprepid));
}

rs.executeSql("select * from T_InputReport where inprepid="+inprepid);
rs.next() ;

String inprepname = Util.toScreenToEdit(rs.getString("inprepname"),user.getLanguage()) ;
String inpreptablename = Util.null2String(rs.getString("inpreptablename")) ;
String inprepbugtablename = Util.null2String(rs.getString("inprepbugtablename")) ;
String inprepfrequence = Util.null2String(rs.getString("inprepfrequence")) ;
String isMultiLine=Util.null2String(rs.getString("isInputMultiLine"));
String inprepbudget = Util.null2String(rs.getString("inprepbudget")) ;
String inprepforecast = Util.null2String(rs.getString("inprepforecast")) ;
String inprepbudgetstatus = Util.null2String(rs.getString("inprepbudgetstatus")) ;
String modulefilename = Util.null2String(rs.getString("modulefilename")) ;
String helpdocid = Util.null2String(rs.getString("helpdocid")) ;

rs.executeSql("select modulefilename from T_InputReporthrm where inprepid="+inprepid+" and hrmid="+user.getUID());
if(rs.next()){
    String temp=Util.null2String(rs.getString("modulefilename"));
    if(!temp.equals("")) modulefilename=temp;
}

Calendar today = Calendar.getInstance();
today.add(Calendar.DATE, -1) ;
String currentyear = Util.add0(today.get(Calendar.YEAR), 4) ;
String currentmonth = Util.add0(today.get(Calendar.MONTH) + 1, 2) ;
String currentday = Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String currentdate = currentyear + "-" + currentmonth + "-" + currentday ;

String imagefilename = "/images/hdCRMAccount.gif";
String titlename = SystemEnv.getHtmlLabelName(20739,user.getLanguage())+"-"+inprepname;
String needfav ="1";
String needhelp ="";


boolean hascollect=false;
rs.executeSql("select * from T_CollectSettingInfo where reporthrmid="+inReportHrm.get("id"));
if(rs.next()){
    hascollect=true;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>


<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:doSubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;

if(hascollect){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1823,user.getLanguage())+",javascript:doCollect(this),_self} " ;
    RCMenuHeight += RCMenuHeightStep;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(16630,user.getLanguage())+",javascript:doUpload(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

if(hasmodright) {
    RCMenu += "{"+SystemEnv.getHtmlLabelName(16625,user.getLanguage())+",javascript:doMonthModify(),_self} " ;
    RCMenuHeight += RCMenuHeightStep;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(16626,user.getLanguage())+",javascript:doYearModify(),_self} " ;
    RCMenuHeight += RCMenuHeightStep;
}
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doback(),_self} " ;
//RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id=frmMain name= frmMain action="InputReportData.jsp" method=post>
<input type="hidden" name="reportHrmId" value="<%=inReportHrm.get("id")%>">
<input type="hidden" name="inprepid" value="<%=inprepid%>">
<input type="hidden" name="inprepname" value="<%=inprepname%>">
<input type="hidden" name="inpreptablename" value="<%=inpreptablename%>">
<input type="hidden" name="inprepbugtablename" value="<%=inprepbugtablename%>">
<input type="hidden" name="inprepfrequence" value="<%=inprepfrequence%>">
<input type="hidden" name="currentyear" value="<%=currentyear%>">
<input type="hidden" name="currentmonth" value="<%=currentmonth%>">
<input type="hidden" name="currentday" value="<%=currentday%>">
<input type="hidden" name="currentdate" value="<%=currentdate%>">
<input type="hidden" name="fromcheck" value="<%=fromcheck%>">
<input type="hidden" name="modulefilename" value="<%=modulefilename%>">
<input type="hidden" name="helpdocid" value="<%=helpdocid%>">
<input type="hidden" name="type" value="">
<input type="hidden" name="iscollect" value="0">


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


	  <TABLE class=viewform width=250>
        <COLGROUP>
		<COL width="50">
  		<COL width="200">
        <TBODY>
		
		<% if((inprepbudget.equals("1") && inprepbudgetstatus.equals("1")) || inprepforecast.equals("1")) {%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
          
      <td class=Field id=txtLocation> 
        <input type="radio" name="inprepbudget" value="0" checked><%=SystemEnv.getHtmlLabelName(628,user.getLanguage())%>
        <% if(inprepforecast.equals("1")) {%><input type="radio" name="inprepbudget" value="2"><%=SystemEnv.getHtmlLabelName(17010,user.getLanguage())%><%}%>
        <% if(inprepbudget.equals("1") && inprepbudgetstatus.equals("1")) {%><input type="radio" name="inprepbudget" value="1"><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%><%}%>
        </TD>
        </TR><TR><TD class=Line colSpan=6></TD></TR> 
		<% }
        else { %>
        <input type="hidden" name="inprepbudget" value="0"> 
        <%}%>
		
        <%
			if(fromcheck.equals("1") || (inReportHrm!=null)) {
				if(inReportHrm!=null)
					theselcrmids=inReportHrm.get("crmIds").toString();
		%>
          <TR>
          <TD><%=SystemEnv.getHtmlLabelName(16902,user.getLanguage())%></TD>
          <td class=Field id=txtLocation>
		  <%
		  	boolean isSingleCrm=false;
		  	if(!theselcrmids.equalsIgnoreCase(""))
				isSingleCrm=(Util.TokenizerString2(theselcrmids,",").length>1)?false:true;
			if(!isSingleCrm){
		   %>
			  <button class=Browser onClick="onShowCustomer('crmspan','crmid','<%=theselcrmids%>')"></button>
			  
			<%
				theselcrmids="";
			}%>
        	<input type="hidden" id="crmid" name="crmid" value="<%=theselcrmids%>">
         <SPAN id="crmspan">
		 <%if(isSingleCrm)
		 		out.print(this.getCrmNameByCrmIds(customerInfoComInfo,theselcrmids));
		   else
		   		out.print("<IMG src='/images/BacoError.gif' align='absMiddle'>");
		  %>
		  </SPAN>
		 <%}else{%>
			 <input type="hidden" id="crmid" name="crmid" value="<%=user.getUID()%>">
		 <%}%>
        <TR><TD class=Line colSpan=6></TD></TR> <TR>
          <TD><%=SystemEnv.getHtmlLabelName(20716,user.getLanguage())%></TD>
          <TD class=Field>
		  <% if(!inprepfrequence.equals("5") && !inprepfrequence.equals("0") && !inprepfrequence.equals("4")) { %>
		  <%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>：<select name="year">
		  <%  for(int i=2 ; i>-3;i--) {
		  		int tempyear = Util.getIntValue(currentyear) - i ;
				String selected = "" ;
				if( i==0) selected = "selected" ;
		  %>
          <option value="<%=tempyear%>" <%=selected%>><%=tempyear%></option>
		  <%}%>
		  </select>
		  <% if(inprepfrequence.equals("6")){%>
          半年：<select name="month">
          <option value="01" <%if(currentmonth.compareTo("07") < 0 ) {%>selected<%}%>>上半年</option>
		  <option value="07" <%if(currentmonth.compareTo("07") >=0 ) {%>selected<%}%>>下半年</option>
		  </select>
          <% }else if(inprepfrequence.equals("7")) { %>
          季：<select name="month">
          <option value="01" <%if(currentmonth.compareTo("04") < 0 ) {%>selected<%}%>>一季度</option>
		  <option value="04" <%if(currentmonth.compareTo("04")>=0 && currentmonth.compareTo("07")<0) {%>selected<%}%>>二季度</option>
          <option value="07" <%if(currentmonth.compareTo("07")>=0 && currentmonth.compareTo("10")<0) {%>selected<%}%>>三季度</option>
          <option value="10" <%if(currentmonth.compareTo("10") >=0 ) {%>selected<%}%>>四季度</option>
		  </select>
          <% }else if(!inprepfrequence.equals("1")) { %>
		  <%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>：<select name="month">
          <option value="01" <%if(currentmonth.equals("01")) {%>selected<%}%>>1</option>
		  <option value="02" <%if(currentmonth.equals("02")) {%>selected<%}%>>2</option>
		  <option value="03" <%if(currentmonth.equals("03")) {%>selected<%}%>>3</option>
		  <option value="04" <%if(currentmonth.equals("04")) {%>selected<%}%>>4</option>
		  <option value="05" <%if(currentmonth.equals("05")) {%>selected<%}%>>5</option>
		  <option value="06" <%if(currentmonth.equals("06")) {%>selected<%}%>>6</option>
		  <option value="07" <%if(currentmonth.equals("07")) {%>selected<%}%>>7</option>
		  <option value="08" <%if(currentmonth.equals("08")) {%>selected<%}%>>8</option>
		  <option value="09" <%if(currentmonth.equals("09")) {%>selected<%}%>>9</option>
		  <option value="10" <%if(currentmonth.equals("10")) {%>selected<%}%>>10</option>
		  <option value="11" <%if(currentmonth.equals("11")) {%>selected<%}%>>11</option>
		  <option value="12" <%if(currentmonth.equals("12")) {%>selected<%}%>>12</option>
		  </select>
          <%}%>
		  <% if(inprepfrequence.equals("3")) { %>
		  旬：<select name="day">
          <option value="05" <%if(currentday.compareTo("10") < 0 ) {%>selected<%}%>>上旬</option>
		  <option value="15" <%if(currentday.compareTo("10")>=0 && currentday.compareTo("20")<0) {%>selected<%}%>>中旬</option>
		  <option value="25" <%if(currentday.compareTo("20") >=0 ) {%>selected<%}%>>下旬</option>
		  </select>
          <%}%>
          <%}  else {%>
		  <BUTTON class=Calendar onClick="getDate()"></BUTTON> 
              <SPAN id=datespan style="FONT-SIZE: x-small"><%=currentdate%></SPAN> 
              <input type="hidden" name="date" id="date" value="<%=currentdate%>">
		  <%}%>
		  </TD>
        </TR><TR><TD class=Line colSpan=6></TD></TR>
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

</FORM>
<jsp:useBean id="xss" class="weaver.filter.XssUtil" scope="page" />
          
<script language="VBScript">
sub getDate()
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	if returndate <> "" then
		window.document.frmMain.date.value= returndate
		datespan.innerHtml = returndate
	end if
end sub

sub onShowCustomer(tdname,inputename,thevalue)
	Dim url
    if thevalue = "" then
	    url="/systeminfo/BrowserMain.jsp?url=/datacenter/input/CustomerBrowser.jsp?sqlwhere=<%=xss.put("where 1=2%26isSecurity=false")%>"
    else
		url="/systeminfo/BrowserMain.jsp?url=/datacenter/input/CustomerBrowser.jsp?sqlwhere=where t1.id in ("&thevalue&")%26isSecurity=false"
    end if
    id = window.showModalDialog(url)
	if NOT isempty(id) then
        if id(0)<> "" then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value = id(0)
		else
		document.all(tdname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		document.all(inputename).value =""
		end if
	end if
end sub

</script>

<script language=javascript>
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}

function doSubmit(obj) {
    if(check_form(document.frmMain,'crmid')) {
        <% if(!inprepfrequence.equals("5") && !inprepfrequence.equals("4") && !inprepfrequence.equals("0")) { %>
            selectedperiod = document.frmMain.year.value ;
            <% if(!inprepfrequence.equals("1")) { %>
                selectedperiod += document.frmMain.month.value ;
            <%} else {%>
                selectedperiod += "13" ;
            <%}%>
        <%} else {%>
            selectedperiod = document.frmMain.date.value.substring(0,4) + document.frmMain.date.value.substring(5,7) ;
        <%}%>

        if('<%=thecloseperiod%>'.indexOf(','+selectedperiod+',') >= 0 ) {
            alert("<%=SystemEnv.getHtmlLabelName(20742,user.getLanguage())%>") ;
            return false ;
        }

        <% if(isMultiLine.equals("1")) { %>
            document.frmMain.action="InputReportMtiData.jsp" ;
        <%}%>

        document.frmMain.submit() ;
        obj.disabled=true;
    }
}

function doCollect(obj) {
    if(check_form(document.frmMain,'crmid')) {
        var tyear,tmonth,tday,tdate;
        <% if(!inprepfrequence.equals("5") && !inprepfrequence.equals("4") && !inprepfrequence.equals("0")) { %>
            selectedperiod = document.frmMain.year.value ;
            tyear=document.frmMain.year.value;
            <% if(!inprepfrequence.equals("1")) { %>
                selectedperiod += document.frmMain.month.value ;
                tmonth=document.frmMain.month.value;
            <%} else { if(inprepfrequence.equals("3")) {%>
                tday=document.frmMain.day.value;
            <% }%>
                selectedperiod += "13" ;
            <%}%>
        <%} else {%>
            selectedperiod = document.frmMain.date.value.substring(0,4) + document.frmMain.date.value.substring(5,7) ;
            tdate = document.frmMain.date.value;
        <%}%>
        <%if(hascollect){%>
            var ajax=ajaxinit();
            ajax.open("POST", "CollectCheck.jsp", true);
            ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
            ajax.send("inprepid=<%=inprepid%>&hrmid=<%=user.getUID()%>&inprepfrequence=<%=inprepfrequence%>&currentdate=<%=currentdate%>&year="+tyear+"&month="+tmonth+"&day="+tday+"&date="+tdate+"&crmid="+document.frmMain.crmid.value);
            //获取执行状态
            ajax.onreadystatechange = function() {
                //如果执行状态成功，那么就把返回信息写到指定的层里
                if (ajax.readyState == 4 && ajax.status == 200) {
                    try{
                        var rsvalue = ajax.responseText;
                        var s = rsvalue.split("|");
                        if(s[0]==2){
                            alert("<%=SystemEnv.getHtmlLabelName(20775,user.getLanguage())%>");
                            return false;
                        }else{
                        if(s[1]!=""){
                            if(!confirm(s[1]+"<%=SystemEnv.getHtmlLabelName(20740,user.getLanguage())%>")){
                                return false;
                            }
                        }
                        if(s[0]==1){
                            if(!confirm("<%=SystemEnv.getHtmlLabelName(20741,user.getLanguage())%>")){
                                return false;
                            }
                        }
                        document.frmMain.iscollect.value="1";
                        if('<%=thecloseperiod%>'.indexOf(','+selectedperiod+',') >= 0 ) {
                            alert("<%=SystemEnv.getHtmlLabelName(20742,user.getLanguage())%>") ;
                            return false ;
                        }

                        <% if(isMultiLine.equals("1")) { %>
                            document.frmMain.action="InputReportMtiData.jsp" ;
                        <%}%>

                        document.frmMain.submit() ;
                        obj.disabled=true;
                        }
                    }catch(e){
                        return false;
                    }
                }
            }
        <%}else{%>

        if('<%=thecloseperiod%>'.indexOf(','+selectedperiod+',') >= 0 ) {
            alert("<%=SystemEnv.getHtmlLabelName(20742,user.getLanguage())%>") ;
            return false ;
        }

        <%// if(inprepfrequence.equals("0")) { 
        if(isMultiLine.equalsIgnoreCase("1")){%>
            document.frmMain.action="InputReportMtiData.jsp" ;
        <%}%>

        document.frmMain.submit() ;
        obj.disabled=true;
        <%}%>
    }
}

function doMonthModify() {
    document.frmMain.action="ModData.jsp" ;
    document.frmMain.type.value="1" ;
    document.frmMain.submit() ;
}

function doYearModify() {
    document.frmMain.action="ModData.jsp" ;
    document.frmMain.type.value="2" ;
    document.frmMain.submit() ;
}

function doUpload() {
	if(check_form(document.frmMain,'crmid')){
		document.frmMain.action="InputReportMutiUpload.jsp";
		document.frmMain.submit() ;
	}
}
function doback(){
    window.location="InputReportPortal.jsp";
}
</script>

</BODY>
</HTML>
