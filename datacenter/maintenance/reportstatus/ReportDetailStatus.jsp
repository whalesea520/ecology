<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String inprepid = Util.null2String(request.getParameter("inprepid"));
rs.executeProc("T_InputReport_SelectByInprepid",""+inprepid);
rs.next() ;
String inprepname = Util.toScreenToEdit(rs.getString("inprepname"),user.getLanguage()) ;
String inpreptablename = Util.null2String(rs.getString("inpreptablename")) ;
String inprepbugtablename = Util.null2String(rs.getString("inprepbugtablename")) ;
String inprepfrequence = Util.null2String(rs.getString("inprepfrequence")) ;
String inprepbudget = Util.null2String(rs.getString("inprepbudget")) ;
String inprepforecast = Util.null2String(rs.getString("inprepforecast")) ;
int isinputmultiline = Util.getIntValue(rs.getString("isinputmultiline"),0) ;
String sql = "" ;



String inprepbudgetrq = Util.null2String(request.getParameter("inprepbudgetrq")) ;
if( inprepbudgetrq.equals("")) inprepbudgetrq = "0" ;

if( inprepbudgetrq.equals("1") ) inpreptablename = inpreptablename + "_buget" ;
else if( inprepbudgetrq.equals("2") ) inpreptablename = inpreptablename + "_forecast" ;
    
    
    
    

String currentdate = Util.null2String(request.getParameter("date")) ;
String currentyear = Util.null2String(request.getParameter("year")) ;
String currentmonth = Util.null2String(request.getParameter("month")) ;
String currentday = Util.null2String(request.getParameter("day")) ;
String thedate = "" ;

if( currentdate.equals("") && (inprepfrequence.equals("5") || inprepfrequence.equals("0"))) {
    Calendar today = Calendar.getInstance();
    today.add(Calendar.DATE, -1) ;
    currentyear = Util.add0(today.get(Calendar.YEAR), 4) ;
    currentmonth = Util.add0(today.get(Calendar.MONTH) + 1, 2) ;
    currentday = Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
    currentdate = currentyear + "-" + currentmonth + "-" + currentday ;
}

if( currentyear.equals("") && !inprepfrequence.equals("5") && !inprepfrequence.equals("0")) {
    Calendar today = Calendar.getInstance();
    currentyear = Util.add0(today.get(Calendar.YEAR), 4) ;
    currentmonth = Util.add0(today.get(Calendar.MONTH) + 1, 2) ;
    currentday = Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
}

if(!inprepfrequence.equals("0")) {
	switch (Util.getIntValue(inprepfrequence)) {
		case 1:
			thedate = currentyear + "-01-15" ;
			break ;
		case 2:
			thedate = currentyear + "-"+currentmonth+"-15" ;
			break ;
		case 3:
			thedate = currentyear + "-"+currentmonth+"-"+currentday ;
			break ;
        case 4:
		case 5:
			thedate = currentdate ;
			break ;
	}

}


String imagefilename = "/images/hdHRM.gif";
String titlename = Util.toScreen("输入报表审核",user.getLanguage(),"0") + inprepname ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<jsp:useBean id="xss" class="weaver.filter.XssUtil" scope="page" />
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere="+xss.put("where operateitem=98 and relatedid="+inprepid)+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",ReportStatus.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep;
/*
RCMenu += "{"+SystemEnv.getHtmlLabelName(16624,user.getLanguage())+",javascript:doConfirm(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(16623,user.getLanguage())+",ReportDetailCheck.jsp?inprepid="+inprepid+"&thetable="+inpreptablename+",_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(16630,user.getLanguage())+",javascript:doUpload(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/datacenter/input/InputReportDate.jsp?inprepid="+inprepid+"&fromcheck=1,_self} " ;
RCMenuHeight += RCMenuHeightStep;

if(!inprepfrequence.equals("0")) {
    RCMenu += "{"+SystemEnv.getHtmlLabelName(16625,user.getLanguage())+",/datacenter/maintenance/reportstatus/ModDate.jsp?type=1&inprepid="+inprepid+",_self} " ;
    RCMenuHeight += RCMenuHeightStep;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(16626,user.getLanguage())+",/datacenter/maintenance/reportstatus/ModDate.jsp?type=2&inprepid="+inprepid+",_self} " ;
    RCMenuHeight += RCMenuHeightStep;
}
*/
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=frmmain name=frmmain method=post action="ReportDetailStatus.jsp">
<input type=hidden name="inprepid"  value="<%=inprepid%>">
<input type=hidden name="thedate"  value="<%=thedate%>">
<input type=hidden name="thetable"  value="<%=inpreptablename%>">
<input type="hidden" name="operation" value="check">
<input type="hidden" name="fromcheck" value="1">

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

<table class=viewform>
  <COLGROUP><COL width="10%"><COL width="39%"><COL width="2%"><COL width="10%"><COL width="39%">
      <TBODY> 
      <TR class=title colspan=5> 
        <TH>条件</TH>
      </TR>
      <TR class=spacing style="height:1px;">
        <TD class=line1 colspan=5></TD>
      </TR>
      <TR> 
        <TD>报表日期</TD>
          <TD class=Field>
		  <% if(!inprepfrequence.equals("5") && !inprepfrequence.equals("4") && !inprepfrequence.equals("0")) { %>
		  年：<select class="InputStyle" name="year">
		  <% for(int i=2 ; i>-3;i--) {
		  		int tempyear = Util.getIntValue(currentyear) - i ;
				String selected = "" ;
				if( i==0) selected = "selected" ;
		  %>
          <option value="<%=tempyear%>" <%=selected%>><%=tempyear%></option>
		  <%}%>
		  </select>
		  <% if(!inprepfrequence.equals("1")) { %>
		  月：<select class="InputStyle" name="month">
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
		  旬：<select class="InputStyle" name="day">
          <option value="05" <%if(currentday.compareTo("10") < 0 ) {%>selected<%}%>>上旬</option>
		  <option value="15" <%if(currentday.compareTo("10")>=0 && currentday.compareTo("20")<0) {%>selected<%}%>>中旬</option>
		  <option value="25" <%if(currentday.compareTo("20") >=0 ) {%>selected<%}%>>下旬</option>
		  </select>
          <%}%>
		  <%}  else {%>
		  <BUTTON type=button  class=Calendar onclick="gettheDate('date', 'datespan')"></BUTTON> 
              <SPAN id=datespan ><%=currentdate%></SPAN> 
              <input type="hidden" name="date" id="date" value="<%=currentdate%>">
		  <%}%>
		  </TD>
        <TD>&nbsp;</TD>
        <TD>类型</TD>
        <TD class=field> 
          <input type="radio" name="inprepbudgetrq" value="0" <%if(inprepbudgetrq.equals("0")) {%>checked <%}%>>实际
          <%if(inprepbudget.equals("1")) {%><input type="radio" name="inprepbudgetrq" value="1" <%if(inprepbudgetrq.equals("1")) {%>checked <%}%>>预算<%}%>
          <%if(inprepforecast.equals("1")) {%><input type="radio" name="inprepbudgetrq" value="2" <%if(inprepbudgetrq.equals("2")) {%>checked <%}%>>预测<%}%>
        </TD>
      </TR> <TR class=spacing style="height:1px;">
        <TD class=line1 colspan=5></TD>
      </TR>
      </TBODY>
</table>
<%
      int crmcount = 0 ;
      int reportcount = 0 ;
      int noreportcount = 0 ;

      sql = "select count(distinct crmid) from " + inpreptablename + " where modtype='0' and reportdate ='" + thedate + "' and inputstatus <> '9' " ;
      rs.executeSql(sql);
      if(rs.next()){
		reportcount = Util.getIntValue( rs.getString(1) , 0 ) ;
      }
        
      sql = "select count(crmid) from T_InputReportHrm where inprepid = " + inprepid  ;
      rs.executeSql(sql);
	  if(rs.next()){	
        crmcount = Util.getIntValue( rs.getString(1) , 0 ) ;
      }

      noreportcount = crmcount - reportcount ;
%>

 <br>
<TABLE class=liststyle cellspacing=1 >
  <COLGROUP>
  <COL width="20%">
  <COL width="20%">
  <COL width="10%">
  <COL width="20%">
  <COL width="10%">
  <TBODY>
  <TR class=header>
    <TH colSpan=3>报表填报状态 
    (未填报：<IMG SRC="/images/BacoDelete.gif" BORDER="0" HEIGHT="16px" WIDTH="16px"> 已填报：<IMG SRC="/images/iedit.gif" BORDER="0" HEIGHT="16px" WIDTH="16px"> 已审核：<IMG SRC="/images/BacoCheckName.gif" BORDER="0" HEIGHT="16px" WIDTH="16px">)
    </TH>
    <TH colSpan=3 style="TEXT-ALIGN: right">报表填报状态 
    (应填报：<%=crmcount%> 未填报：<%=noreportcount%>  已填报：<%=reportcount%> )
    </TH>
    </TR>

  <TR class=Header>
    <TD>填报单位</TD>
	<TD>填报日期</TD>
    <TD>填报状态</TD>
    <TD>填报人</TD>
    <TD>状态详细</TD>
  </TR>
    <TR class=line  style="height:1px;">
    <TD colSpan=6 ></TD></TR>
<%
      ArrayList inputids = new ArrayList() ;
      ArrayList crmids = new ArrayList() ;
      ArrayList inputdates = new ArrayList() ;
      ArrayList inputstatuss = new ArrayList() ;
      ArrayList reportuserids = new ArrayList() ;
	  ArrayList dspdates=new ArrayList();
      boolean hasnocheck = false ; 

      sql = "select inputid,crmid,inputdate,inputstatus,reportuserid,inprepdspdate from " + inpreptablename + " where modtype='0' and reportdate ='" + thedate + "' and inputstatus <> '9' " ;
      rs.executeSql(sql);
      while(rs.next()){
		String inputid = Util.null2String(rs.getString("inputid")) ;
		String crmid = Util.null2String(rs.getString("crmid")) ;
		String inputdate = Util.null2String(rs.getString("inputdate")) ;
        String inputstatus = Util.null2String(rs.getString("inputstatus")) ;
        String reportuserid = Util.null2String(rs.getString("reportuserid")) ;
		String dspdate = Util.null2String(rs.getString("inprepdspdate")) ;
                
        inputids.add(inputid) ;
        crmids.add(crmid) ;
        inputdates.add(inputdate) ;
        inputstatuss.add(inputstatus) ;
        reportuserids.add(reportuserid) ;
		dspdates.add(dspdate);
      }
        
      int needchange = 0;
      sql = "select crmid from T_InputReportHrm where inprepid = " + inprepid  ;
      rs.executeSql(sql);
	  while(rs.next()){ 
		ArrayList crmidlist = Util.TokenizerString(Util.null2String(rs.getString("crmid")),",") ;
		for(int i=0;i<crmidlist.size();i++){
			String inputid = "" ;
			String inputdate = "" ;
			String inputstatus = "" ;
			String reportuserid = "" ;
			String reportusername = "" ;
			String confirmusername = "" ;
			String dspdate="";
			String crmid=(String)crmidlist.get(i);
			int crmidindex = crmids.indexOf( crmid ) ;

        if( crmidindex != -1 ) {
            inputid = (String)inputids.get( crmidindex ) ;
            inputdate = (String)inputdates.get( crmidindex ) ;
            inputstatus = (String)inputstatuss.get( crmidindex ) ;
            reportuserid = (String)reportuserids.get( crmidindex ) ;
			dspdate = (String)dspdates.get( crmidindex ) ;

            if( !reportuserid.equals("") && !reportuserid.equals("0") ) {
                reportusername = ResourceComInfo.getLastname(reportuserid) ;
            }

            if(inputstatus.equals("0")) hasnocheck = true ;
        }
        else hasnocheck = true ;

       	if(needchange ==0){
       		needchange = 1;
%>
  <TR class=datalight>
  <%
  	}else{
  		needchange=0;
  %><TR class=datadark>
  <%  	}%>
    <TD><% if( crmidindex != -1) { if(isinputmultiline==1){%><a href='ReportConfirmMtiDetail.jsp?thetable=<%=inpreptablename%>&thedate=<%=thedate%>&dspdate=<%=dspdate%>&inprepid=<%=inprepid%>&crmid=<%=crmid%>&inprepbudget=<%=inprepbudgetrq%>&formstatus=1'><%  } else {%><a href='ReportConfirmDetail.jsp?thetable=<%=inpreptablename%>&inputid=<%=inputid%>&inprepid=<%=inprepid%>&inprepbudget=<%=inprepbudgetrq%>&formstatus=1'><%}}%><%=CustomerInfoComInfo.getCustomerInfoname(crmid)%><% if( crmidindex != -1) { %></a><%}%>
	</TD>
    <TD><%=inputdate%></TD>
	<TD>
    <% if( crmidindex == -1) { %><IMG SRC="/images/BacoDelete.gif" BORDER="0" HEIGHT="16px" WIDTH="16px">
    <% } else if( inputstatus.equals("0") ) {%><IMG SRC="/images/iedit.gif" BORDER="0" HEIGHT="16px" WIDTH="16px">
    <% } else if( inputstatus.equals("4") ) {%><IMG SRC="/images/BacoCheckName.gif" BORDER="0" HEIGHT="16px" WIDTH="16px"><%}%>
    </TD>
    <TD><%=reportusername%></TD>
	<TD><% if(isinputmultiline==1){%><a href='ReportMtiDetailCrm.jsp?thetable=<%=inpreptablename%>&crmid=<%=crmid%>&inprepid=<%=inprepid%>&inprepbudget=<%=inprepbudgetrq%>'><%  } else {%><a href='ReportDetailCrm.jsp?thetable=<%=inpreptablename%>&crmid=<%=crmid%>&inprepid=<%=inprepid%>&inprepbudget=<%=inprepbudgetrq%>'><%}%>详细</a></TD>
  </TR>
<%}}%>
</tbody>
</table>
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

<input type=hidden name="hasnocheck"  <% if(hasnocheck) {%>value="1" <%}%>>
</form>

<script language=javascript>
function doSubmit() {
	$G("frmmain").submit();
}

function doConfirm() {
    
    if($G("hasnocheck").value=="1") {
        alert("还有未填报的单位或为确认的单位，不能审核确认！") ;
    }
    else {
        $G("frmmain").action = "ReportConfirmOperation.jsp" ;
        $G("frmmain").submit() ;
    }
}

function doUpload() {
	$G("frmmain").action="/datacenter/input/InputReportMutiUpload.jsp" ;
	$G("frmmain").submit() ;
}
</script>
</BODY></HTML>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>