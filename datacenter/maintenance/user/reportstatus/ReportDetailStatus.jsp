<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

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

if( currentdate.equals("") && inprepfrequence.equals("5")) {
    Calendar today = Calendar.getInstance();
    today.add(Calendar.DATE, -1) ;
    currentyear = Util.add0(today.get(Calendar.YEAR), 4) ;
    currentmonth = Util.add0(today.get(Calendar.MONTH) + 1, 2) ;
    currentday = Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
    currentdate = currentyear + "-" + currentmonth + "-" + currentday ;
}

if( currentyear.equals("") && !inprepfrequence.equals("5")) {
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
<%@ include file="/systeminfo/TopTitle.jsp" %>
<FORM id=weaver name=frmmain method=post action="ReportDetailStatus.jsp">
<input type=hidden name="inprepid"  value="<%=inprepid%>">
<input type=hidden name="thedate"  value="<%=thedate%>">
<input type=hidden name="thetable"  value="<%=inpreptablename%>">
<input type="hidden" name="operation" value="check">
<DIV class=HdrProps></DIV>
<div>
<BUTTON class=btnRefresh accessKey=R type="submit"><U>R</U>-刷新</BUTTON>
<BUTTON class=btnSave accessKey=C type="button" onClick="doConfirm();"><U>C</U>-审核确认</BUTTON>
<BUTTON class=btnSave accessKey=S type="button" onClick="location.href='ReportDetailCheck.jsp?inprepid=<%=inprepid%>&thetable=<%=inpreptablename%>'"><U>S</U>-审核状态</BUTTON>
<BUTTON class=BtnNew id=button2 accessKey=N name=button2 onclick="location.href='/datacenter/input/InputReportDate.jsp?inprepid=<%=inprepid%>&fromcheck=1'"><U>N</U>-<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></BUTTON>
<% if(!inprepfrequence.equals("0")) {%>
<BUTTON class=Btn id=button1 accessKey=M name=button1 onclick="location.href='/datacenter/maintenance/reportstatus/ModDate.jsp?type=1&inprepid=<%=inprepid%>'"><U>M</U>-月修正</BUTTON>
<BUTTON class=Btn id=button3 accessKey=Y name=button3 onclick="location.href='/datacenter/maintenance/reportstatus/ModDate.jsp?type=2&inprepid=<%=inprepid%>'"><U>Y</U>-年修正</BUTTON>
<%}%>
</div>

<br>
<table class=viewform>
  <COLGROUP><COL width="10%"><COL width="39%"><COL width="2%"><COL width="10%"><COL width="39%">
      <TBODY> 
      <TR class=title colspan=5> 
        <TH>条件</TH>
      </TR>
      <TR class=spacing>
        <TD class=line1 colspan=5></TD>
      </TR>
      <TR> 
        <TD>报表日期</TD>
          <TD class=Field>
		  <% if(!inprepfrequence.equals("5")) { %>
		  年：<select name="year">
		  <% for(int i=2 ; i>-3;i--) {
		  		int tempyear = Util.getIntValue(currentyear) - i ;
				String selected = "" ;
				if( i==0) selected = "selected" ;
		  %>
          <option value="<%=tempyear%>" <%=selected%>><%=tempyear%></option>
		  <%}%>
		  </select>
		  <% if(!inprepfrequence.equals("1")) { %>
		  月：<select name="month">
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
		  <option value="15" <%if(currentmonth.compareTo("10")>=0 && currentmonth.compareTo("20")<0) {%>selected<%}%>>中旬</option>
		  <option value="25" <%if(currentmonth.compareTo("20") >=0 ) {%>selected<%}%>>下旬</option>
		  </select>
          <%}%>
		  <%}  else {%>
		  <BUTTON class=Calendar onclick="getDate()"></BUTTON> 
              <SPAN id=datespan style="FONT-SIZE: x-small"><%=currentdate%></SPAN> 
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
      </TR>
      </TBODY>
</table>
<%
      int crmcount = 0 ;
      int reportcount = 0 ;
      int confirmcount = 0 ;
      int noreportcount = 0 ;

      sql = "select count(*) from " + inpreptablename + " where modtype='0' and reportdate ='" + thedate + "' " ;
      
      rs.executeSql(sql);
      if(rs.next()){
		reportcount = Util.getIntValue( rs.getString(1) , 0 ) ;
      }
        
      sql = "select count(crmid) from T_InputReportCrm where inprepid = " + inprepid  ;
      rs.executeSql(sql);
	  if(rs.next()){	
        crmcount = Util.getIntValue( rs.getString(1) , 0 ) ;
      }

      sql = "select count(*) from " + inpreptablename + " where modtype='0' and reportdate ='" + thedate + "' and inputstatus != '0' " ;
      
      rs.executeSql(sql);
      if(rs.next()){
		confirmcount = Util.getIntValue( rs.getString(1) , 0 ) ;
      }

      noreportcount = crmcount - reportcount ;
%>

 <br>
<TABLE class=liststyle cellspacing=1 >
  <COLGROUP>
  <COL width="40%">
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <TBODY>
  <TR class=title>
    <TH colSpan=2>报表填报状态 
    (未填报：<IMG SRC="\images\BacoDelete.gif" BORDER="0" HEIGHT="16px" WIDTH="16px"> 已填报：<IMG SRC="\images\iedit.gif" BORDER="0" HEIGHT="16px" WIDTH="16px"> 已确认：<IMG SRC="\images\BacoCheck.gif" BORDER="0" HEIGHT="16px" WIDTH="16px"> 已审核：<IMG SRC="\images\BacoCheckName.gif" BORDER="0" HEIGHT="16px" WIDTH="16px">)
    </TH>
    <TH colSpan=2 style="TEXT-ALIGN: right">报表填报状态 
    (应填报：<%=crmcount%> 未填报：<%=noreportcount%>  已填报：<%=reportcount%>  已确认：<%=confirmcount%> )
    </TH>
    </TR>
  <TR class=spacing>
    <TD class=line1 colSpan=4 ></TD></TR>
  <TR class=Header>
    <TD>填报单位</TD>
	<TD>填报日期</TD>
    <TD>填报状态</TD>
    <TD>状态详细</TD>
  </TR>
<%
      ArrayList inputids = new ArrayList() ;
      ArrayList crmids = new ArrayList() ;
      ArrayList inputdates = new ArrayList() ;
      ArrayList inputstatuss = new ArrayList() ;
      boolean hasnocheck = false ; 

      sql = "select inputid , crmid ,inputdate ,inputstatus from " + inpreptablename + " where modtype='0' and reportdate ='" + thedate + "' " ;
      
      rs.executeSql(sql);
      while(rs.next()){
		String inputid = Util.null2String(rs.getString("inputid")) ;
		String crmid = Util.null2String(rs.getString("crmid")) ;
		String inputdate = Util.null2String(rs.getString("inputdate")) ;
        String inputstatus = Util.null2String(rs.getString("inputstatus")) ;
        
        inputids.add(inputid) ;
        crmids.add(crmid) ;
        inputdates.add(inputdate) ;
        inputstatuss.add(inputstatus) ;
      }
        
      int needchange = 0;
      sql = "select crmid from T_InputReportCrm where inprepid = " + inprepid  ;
      rs.executeSql(sql);
	  while(rs.next()){	
        String crmid = Util.null2String(rs.getString("crmid")) ;
        int crmidindex = crmids.indexOf( crmid ) ;
        String inputid = "" ;
		String inputdate = "" ;
        String inputstatus = "" ;

        if( crmidindex != -1 ) {
            inputid = (String)inputids.get( crmidindex ) ;
            inputdate = (String)inputdates.get( crmidindex ) ;
            inputstatus = (String)inputstatuss.get( crmidindex ) ;

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
    <TD><% if( crmidindex != -1) { %><a href='ReportConfirmDetail.jsp?thetable=<%=inpreptablename%>&inputid=<%=inputid%>&inprepid=<%=inprepid%>'><%}%><%=CustomerInfoComInfo.getCustomerInfoname(crmid)%><% if( crmidindex != -1) { %></a><%}%>
	</TD>
    <TD><%=inputdate%></TD>
	<TD>
    <% if( crmidindex == -1) { %><IMG SRC="\images\BacoDelete.gif" BORDER="0" HEIGHT="16px" WIDTH="16px">
    <% } else if( inputstatus.equals("0") ) {%><IMG SRC="\images\iedit.gif" BORDER="0" HEIGHT="16px" WIDTH="16px">
    <% } else if( inputstatus.equals("1") ) {%><IMG SRC="\images\BacoCheck.gif" BORDER="0" HEIGHT="16px" WIDTH="16px">
    <% } else if( inputstatus.equals("2") ) {%><IMG SRC="\images\BacoCheckName.gif" BORDER="0" HEIGHT="16px" WIDTH="16px"><%}%>
    </TD>
	<TD><a href='ReportDetailCrm.jsp?thetable=<%=inpreptablename%>&crmid=<%=crmid%>&inprepid=<%=inprepid%>'>详细</a></TD>
  </TR>
<%}%>
</tbody>
</table>
<input type=hidden name="hasnocheck"  <% if(hasnocheck) {%>value="1" <%}%>>
</form>
<script language=vbs>
sub getDate()
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	if returndate <> "" then
		window.document.frmMain.date.value= returndate
		datespan.innerHtml = returndate
	end if
end sub
</script>

<script language=javascript>
function doConfirm() {
    
    if(document.frmmain.hasnocheck.value=="1") {
        alert("还有未填报的单位或为确认的单位，不能审核确认！") ;
    }
    else {
        document.frmmain.action = "ReportConfirmOperation.jsp" ;
        document.frmmain.submit() ;
    }
}
</script>
</BODY></HTML>
