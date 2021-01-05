<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<% if(!HrmUserVarify.checkUserRight("FnaBudgetAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CostcenterComInfo" class="weaver.hrm.company.CostCenterComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BudgetModuleComInfo" class="weaver.fna.maintenance.BudgetModuleComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>

</head>
<%
String budgetdepartmentid = Util.null2String(request.getParameter("departmentid")) ;
String budgetresourceid = Util.null2String(request.getParameter("resourceid")) ;
String budgetcostcenterid = "" ;
if(!budgetresourceid.equals("")) {
budgetdepartmentid = ResourceComInfo.getDepartmentID(budgetresourceid) ;
budgetcostcenterid = ResourceComInfo.getCostcenterID(budgetresourceid) ;
}
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

RecordSet.executeProc("FnaCurrency_SelectByDefault","");
RecordSet.next();
String defcurrenyid = RecordSet.getString(1);

String fnayear = "" ;
RecordSet.executeProc("FnaYearsPeriods_SelectMaxYear","");
if(RecordSet.next()) fnayear = RecordSet.getString("fnayear") ;
else fnayear = Util.add0(today.get(Calendar.YEAR), 4) ;

String budgetmoduleid = "" ;
if(budgetmoduleid.equals(""))  {
RecordSet.executeProc("FnaYearsPeriods_SDefaultBudget",fnayear) ;
if(RecordSet.next()) budgetmoduleid = RecordSet.getString(1) ;
}

String imagefilename = "/images/hdFIN_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(386,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(365,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
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

<%if(msgid!=-1){%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<form id=frmMain name=frmMain method=post action=FnaBudgetOperation.jsp >
<input class=inputstyle type=hidden name="operation" value="addbudget">
  <input class=inputstyle type=hidden name="budgetdefcurrencyid" value="<%=defcurrenyid%>">
  <input class=inputstyle type=hidden name="createdate" value="<%=currentdate%>">
   <table class=Viewform>
    <COLGROUP> <COL width="10%"> <COL width="33%"> <COL width=10> <COL width="15%"> 
    <COL width="40%"> <TBODY> 
    <TR class=Title> 
      <TH colSpan=5><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></TH>
    </TR>
    <TR class=Spacing> 
      <TD class=Line1 colSpan=5></TD>
    </TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
      <td class=field> <button class=Browser id=SelectDeparment onClick="onShowDepartment()"></button> 
        <span class=inputstyle id=departmentspan> 
        <% if(!budgetdepartmentid.equals("")) {%>
        <%=Util.toScreen(DepartmentComInfo.getDepartmentname(budgetdepartmentid),user.getLanguage())%> 
        <%} else {%>
        <img src="/images/BacoError_wev8.gif" align=absMiddle> 
        <%}%>
        </span> 
        <input class=inputstyle id=budgetdepartmentid type=hidden name=budgetdepartmentid value="<%=budgetdepartmentid%>">
      </td>
      <td>&nbsp;</td>
      <td><%=SystemEnv.getHtmlLabelName(446,user.getLanguage())%></td>
      <td class=field> 
        <select class=inputstyle name="fnayear">
          <%
		RecordSet.executeProc("FnaYearsPeriods_Select","");
		while(RecordSet.next()) {
			String thefnayear = RecordSet.getString("fnayear") ;
		%>
          <option value="<%=thefnayear%>" <% if(thefnayear.equals(fnayear)) {%>selected<%}%>><%=thefnayear%></option>
          <%}%>
        </select>
        <input class=inputstyle id=periodsid name=periodsid maxlength="2" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("periodsid");checkinput("periodsid","periodsidimage")' size="8">
      <SPAN id=periodsidimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
	  </td>
    </tr>
    <TR><TD class=Line colSpan=6></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(515,user.getLanguage())%></td>
      <td class=field> <button class=Browser id=SelectCostCenter onClick="onShowCostCenter()"></button> 
        <span class=inputstyle id=budgetcostercenteridspan> 
        <% if(!budgetcostcenterid.equals("")) {%>
        <%=Util.toScreen(CostcenterComInfo.getCostCentername(budgetcostcenterid),user.getLanguage())%> 
        <%} else {%>
        <IMG src="/images/BacoError_wev8.gif" align=absMiddle> 
        <%}%>
        </span> 
        <input class=inputstyle id=budgetcostercenterid type=hidden name=budgetcostcenterid>
      </td>
      <td>&nbsp;</td>
      <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
      <td class=field> <BUTTON class=Browser id=SelecResourceid onClick="onShowResourceID()"></BUTTON> 
        <span id=budgetresourceidspan> 
        <% if(!budgetresourceid.equals("")) {%>
        <A href="/hrm/resource/HrmResource.jsp?id=<%=budgetresourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(budgetresourceid),user.getLanguage())%></A> 
        <%} else {%>
        <IMG src="/images/BacoError_wev8.gif" align=absMiddle> 
        <%}%>
        </span> 
        <input class=inputstyle  id=budgetresourceid type=hidden name=budgetresourceid value="<%=budgetresourceid%>">
      </td>
    </tr>
    <TR><TD class=Line colSpan=6></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></td>
      <td class=field> <BUTTON class=Browser 
            id=SelectCurrencyID onClick="onShowCurrencyID()"></BUTTON> <SPAN class=inputstyle 
            id=budgetcurrencyidspan><%=Util.toScreen(CurrencyComInfo.getCurrencyname(defcurrenyid),user.getLanguage())%></SPAN> 
        <input class=inputstyle id=budgetcurrencyid type=hidden name=budgetcurrencyid value="<%=defcurrenyid%>">
      </td>
      <td>&nbsp;</td>
      <td><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%></td>
      <td class=field> 
        <select class=inputstyle class=fieldshort id=budgetmoduleid name=budgetmoduleid>
          <% while(BudgetModuleComInfo.next()) { 
		String tmpbudgetmoduleid = BudgetModuleComInfo.getBudgetModuleid() ;
		String tmpbudgetmodulename = Util.toScreen(BudgetModuleComInfo.getBudgetModulename(), user.getLanguage()) ;
		%>
          <option value=<%=tmpbudgetmoduleid%> <% if(budgetmoduleid.equals(tmpbudgetmoduleid)) {%>selected <%}%>><%=tmpbudgetmodulename%></option>
          <%}%>
        </select>
      </td>
    </tr>
<TR><TD class=Line colSpan=6></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(588,user.getLanguage())%></td>
      <td class=field> 
        <input class=inputstyle type="text" name="budgetexchangerate" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("budgetexchangerate");checkinput("budgetexchangerate","budgetexchangerateimage")' size=20 value="1.000" maxlength="10">
        <span id=budgetexchangerateimage></span></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp; </td>
    </tr>
    <TR><TD class=Line colSpan=2></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>
      <td class=field>
        <textarea class=inputstyle name="budgetremark" cols="30"></textarea>
        </td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp; </td>
    </tr>
    <TR><TD class=Line colSpan=2></TD></TR> 
    <TR class=Header> 
      <TH colSpan=5><%=SystemEnv.getHtmlLabelName(663,user.getLanguage())%></TH>
    </TR>
    <TR class=Spacing> 
      <TD class=Sep1 colSpan=5></TD>
    </TR>
    <tr> 
      <td colspan=5> <BUTTON class=btnSave accessKey=A onClick="addRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,user.getLanguage())%></BUTTON> 
      </td>
    </tr>
    </tbody> 
  </table>
  <TABLE class=ListSylet id="oTable" cols=7>
    <COLGROUP> 
	<COL width="15%"> 
	<COL width="15%"> 
	<COL width="15%"> 
	<COL width="15%"> 
	<COL width="15%"> 
	<COL width="15%"> 
	<COL width="20%"> 
    <TBODY> 
    <TR class=Header> 
      <TD><%=SystemEnv.getHtmlLabelName(585,user.getLanguage())%></TD>
      <TD>CRM</TD>
      <TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></TD>
      <TD><%=SystemEnv.getHtmlLabelName(145,user.getLanguage())%></TD>
	  <TD><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TD>
	  <TD><%=SystemEnv.getHtmlLabelName(534,user.getLanguage())%></TD>
	  <TD><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TD>
    </TR>
    <TR class=Line><TD colspan="7" ></TD></TR> 
    <tr> 
      <td><nobr><button class=Browser id=SelectCostCenter onClick='onShowLedger(ledgeridspan0,ledgerid0)'></button> 
        <span class=inputstyle id=ledgeridspan0><img src="/images/BacoError_wev8.gif" align=absMiddle></span> 
        <input class=inputstyle id=ledgerid0 type=hidden name=ledgerid0> </td>
      <td><nobr>
	  <button class=Browser id=SelectDeparment onClick='onShowParent(budgetcrmidspan0,budgetcrmid0)'></button> 
        <span class=inputstyle id=budgetcrmidspan0></span> 
        <input class=inputstyle type=hidden name=budgetcrmid0>
      </td>
      <td><nobr>
	  <button class=Browser onClick='onShowProject(budgetprojectidspan0,budgetprojectid0)'></button> 
        <span id=budgetprojectidspan0></span> 
        <input class=inputstyle type=hidden name=budgetprojectid0>
      </td>
      <td><nobr> 
       <button class=Browser onClick="onShowItemID(budgetitemidspan0,budgetitemid0)"></button>
	   <span id=budgetitemidspan0></span> 
        <input class=inputstyle type=hidden id="budgetitemid0" name="budgetitemid0"></td>
		<td><nobr> 
        <button class=Browser onClick='onShowDoc(budgetdocidspan0,budgetdocid0)'></button> 
		<span id=budgetdocidspan0></span>
        <input class=inputstyle type=hidden name=budgetdocid0>
      </td>
	  <td><nobr>
        <input class=inputstyle type=text id='budgetaccount0' name='budgetaccount0' size=15 onKeyPress='ItemCount_KeyPress()' onBlur='checknumber1(this)' maxlength='15'>
        <button class=Calculate id=SelectNumber onClick='onShowNumber(budgetaccount0)'></button>
	  </td>
	  <td><nobr>
        <input class=inputstyle type=text name='budgetremark0' maxlength='100'>
      </td>
    </tr>
    </tbody> 
  </table>
<input class=inputstyle type="hidden" name="totaldetail" value=1> 
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

<script language=vbscript>
sub onShowItemID(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/asset/LgcAssetBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
		spanname.innerHtml = "<A href='/lgc/asset/LgcAsset.jsp?paraid="&id(0)&"'>"&id(1)&"</A>"
		inputname.value=id(0)
	else 
		spanname.innerHtml = ""
		inputname.value=""
	end if
	end if
end sub

sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmMain.budgetdepartmentid.value)
	issame = false 
	if (Not IsEmpty(id)) then
		if id(0)<> 0 then
			if id(0) = frmMain.budgetdepartmentid.value then
				issame = true 
			end if
			departmentspan.innerHtml = id(1)
			frmMain.budgetdepartmentid.value=id(0)
		else
			departmentspan.innerHtml = "<img src='/images/BacoError_wev8.gif' align=absMiddle>"
			frmMain.budgetdepartmentid.value=""
		end if
		
		if issame = false then
			budgetcostercenteridspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			frmMain.budgetcostercenterid.value=""
			budgetresourceidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			frmMain.budgetresourceid.value=""
		end if
	end if
end sub

sub onShowCostCenter()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/CostcenterBrowser.jsp?sqlwhere= where departmentid="&frmMain.budgetdepartmentid.value)
	issame = false 
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
		if id(0) = frmMain.budgetdepartmentid.value then
				issame = true 
		end if
		budgetcostercenteridspan.innerHtml = id(1)
		frmMain.budgetcostercenterid.value=id(0)
	else 
		budgetcostercenteridspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		frmMain.budgetcostercenterid.value=""
	end if
	if issame = false then
			budgetresourceidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			frmMain.budgetresourceid.value=""
	end if
	end if
end sub

sub onShowCurrencyID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp")
	if NOT isempty(id) then
		if id(0)<> "" then
		budgetcurrencyidspan.innerHtml = id(1)
		frmMain.budgetcurrencyid.value=id(0)
		else
		budgetcurrencyidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		frmMain.budgetcurrencyid.value= ""
		end if
	end if
end sub

sub onShowResourceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?sqlwhere= where costcenterid="&frmMain.budgetcostercenterid.value)
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	budgetresourceidspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmMain.budgetresourceid.value=id(0)
	else 
	budgetresourceidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	frmMain.budgetresourceid.value=""
	end if
	end if
end sub


sub onShowDoc(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if NOT isempty(id) then
		if id(0)<> 0 then
		spanname.innerHtml = "<A href='/docs/docs/DocDsp.jsp?id="&id(0)&"'>"&id(1)&"</A>"
		inputname.value=id(0)
		else
		spanname.innerHtml = Empty
		inputname.value=""
		end if
	end if
end sub

sub onShowParent(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = "<A href='/CRM/data/ViewCustomer.jsp?CustomerID="&id(0)&"'>"&id(1)&"</A>"
	inputname.value=id(0)
	else 
	spanname.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub

sub onShowProject(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp")
	if NOT isempty(id) then
	    if id(0)<> "" then
		spanname.innerHtml = id(1)
		inputname.value=id(0)
		else
		spanname.innerHtml = empty
		inputname.value=""
		end if
	end if
end sub

sub onShowNumber(inputename) 
	returnnumber = window.showModalDialog("/systeminfo/Calculate.jsp",,"dialogHeight:230px;dialogwidth:208px")
	if returnnumber <> "" then
	inputename.value = returnnumber
	end if
end sub

sub onShowLedger(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/FnaLedgerBrowser.jsp")
	if NOT isempty(id) then
	    if id(0)<> "" then
		spanname.innerHtml = id(1)
		inputname.value=id(0)
		else
		spanname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		inputname.value=""
		end if
	end if
end sub

</script>
<script language="JavaScript" src="/js/addRowBg_wev8.js" >   
</script>  
<script language=javascript>
var rowindex=1;
var totalrows=1;
var totaldebit = 0 ;
var totalcredit = 0 ;
var rowColor="" ;
function addRow()
{	
	ncol = oTable.cols;
	oRow = oTable.insertRow();
    rowColor = getRowBg();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
        oCell.style.background= rowColor;
		switch(j) {
			case 0: 
				var oDiv = document.createElement("div");
				var sHtml = "<nobr><button class=Browser id=SelectCostCenter onClick='onShowLedger(ledgeridspan"+rowindex+",ledgerid"+rowindex+")'></button> "+
        					"<span class=inputstyle id=ledgeridspan"+rowindex+"><img src='/images/BacoError_wev8.gif' align=absMiddle></span>"+ 
        					"<input class=inputstyle id=ledgerid"+rowindex+" type=hidden name=ledgerid"+rowindex+">"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div");
				var sHtml = "<nobr><button class=Browser id=SelectDeparment onClick='onShowParent(budgetcrmidspan"+rowindex+",budgetcrmid"+rowindex+")'></button>"+ 
        					"<span class=inputstyle id=budgetcrmidspan"+rowindex+"></span> "+
        					"<input class=inputstyle type=hidden name=budgetcrmid"+rowindex+">" ;
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2: 
				var oDiv = document.createElement("div");
				var sHtml = "<nobr><button class=Browser onClick='onShowProject(budgetprojectidspan"+rowindex+",budgetprojectid"+rowindex+")'></button> "+
        					"<span id=budgetprojectidspan"+rowindex+"></span> "+
        					"<input class=inputstyle type=hidden name=budgetprojectid"+rowindex+">";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3: 
				var oDiv = document.createElement("div");
				var sHtml = "<nobr><button class=Browser onClick='onShowItemID(budgetitemidspan"+rowindex+",budgetitemid"+rowindex+")'></button>"+
        					"<span id=budgetitemidspan"+rowindex+"></span> "+				
							"<input class=inputstyle type=hidden id='budgetitemid"+rowindex+"' name='budgetitemid"+rowindex+"'> ";
				oDiv.innerHTML = sHtml;    
				oCell.appendChild(oDiv);   
				break;
			case 4: 
				var oDiv = document.createElement("div");
				var sHtml = "<nobr><button class=Browser onClick='onShowDoc(budgetdocidspan"+rowindex+",budgetdocid"+rowindex+")'></button> "+ 
							"<span id=budgetdocidspan"+rowindex+"></span>"+
        					"<input class=inputstyle type=hidden name=budgetdocid"+rowindex+">";
				oDiv.innerHTML = sHtml;    
				oCell.appendChild(oDiv);   
				break;
			case 5: 
				var oDiv = document.createElement("div");
				var sHtml = "<nobr><input class=inputstyle type=text id='budgetaccount"+rowindex+"' name='budgetaccount"+rowindex+"' size=15 onKeyPress='ItemCount_KeyPress()' onBlur='checknumber1(this)' maxlength='15'>"+
							"<button class=Calculate id=SelectNumber onClick='onShowNumber(budgetaccount"+rowindex+")'></button>";
				oDiv.innerHTML = sHtml;    
				oCell.appendChild(oDiv);   
				break;
			case 6: 
				var oDiv = document.createElement("div");
				var sHtml = "<nobr><input class=inputstyle type=text name='budgetremark"+rowindex+"' maxlength='100'>" ;
				oDiv.innerHTML = sHtml;    
				oCell.appendChild(oDiv);   
				break;
		}
	}
	rowindex = rowindex*1 +1;
	frmMain.totaldetail.value=rowindex;
	totalrows = rowindex;
	
}

function checkvalue() {
	parastr = "budgetdepartmentid,budgetcostercenterid,budgetcurrencyid,budgetexchangerate,budgetresourceid,periodsid" ;
	for(i=0; i<totalrows ; i++) {
		if(document.all("budgetaccount"+i).value != "") {
			parastr += ",ledgerid"+i ;
		}
	}
	if(!check_form(document.frmMain,parastr)) return false ;
	if(eval(frmMain.budgetexchangerate.value) == 0) {
		alert("<%=SystemEnv.getHtmlNoteName(32,user.getLanguage())%>") ;
		return false ;
	}
	return true ;
}
function submitData() {
if(checkvalue()){
 frmMain.submit();
}
}
</script>
</body>
</html>