<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="requestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
</HEAD>
<%
String paraId = Util.null2String(request.getParameter("paraid")) ;

String organizationid = "";
String organizationtype = "";
String occurDate = "";
String amount = "";
String credenceNo = "";
String relatedWFId = "";
String remark = "";

rs.executeSql("SELECT * FROM FnaLoanInfo WHERE id = " + paraId);
if (rs.next()) {
	organizationid = Util.null2String(rs.getString("organizationid"));
	organizationtype = Util.null2String(rs.getString("organizationtype"));
	occurDate = Util.null2String(rs.getString("occurdate"));
	amount = Util.null2String(rs.getString("amount"));
	credenceNo = Util.null2String(rs.getString("debitremark"));
	relatedWFId = Util.null2String(rs.getString("releatedid"));
	remark = Util.null2String(rs.getString("remark"));
} else
	return;
String showname="";
    if(organizationtype.equals("3")){
                                showname = "<A href='/hrm/resource/HrmResource.jsp?id="+organizationid+"'>"+Util.toScreen(ResourceComInfo.getLastname(organizationid),user.getLanguage()) +"</A>";
                                }else if(organizationtype.equals("2")){
                                showname = "<A href='/hrm/company/HrmDepartmentDsp.jsp?id="+organizationid+"'>"+Util.toScreen(DepartmentComInfo.getDepartmentname(organizationid),user.getLanguage()) +"</A>";
                                }else if(organizationtype.equals("1")){
                                showname = "<A href='/hrm/company/HrmSubCompanyDsp.jsp?id="+organizationid+"'>"+Util.toScreen(SubCompanyComInfo.getSubCompanyname(organizationid),user.getLanguage())+"</A>";
                                }
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1052,user.getLanguage()) + ":&nbsp;"
                            +SystemEnv.getHtmlLabelName(93,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
if (HrmUserVarify.checkUserRight("FinanceWriteOff:Maintenance",user)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
//added by lupeng 2004.2.25
//add the Back menu item to popup menu
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//end
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<TABLE width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<COLGROUP>
<COL width="10">
<COL width="">
<COL width="10">
<TR>
	<TD height="10" colspan="3"></TD>
</TR>

<TR>
	<TD></TD>
	<TD valign="top">
		<TABLE class="Shadow">
		<TR>
		<TD valign="top">
		<FORM style="MARGIN-TOP: 0px" id="frmmain" name="frmmain" method="post" action="FnaPersonalReturnOperation.jsp">
			<INPUT type="hidden" name="operation" value="edit">
			<INPUT type="hidden" name="paraid" value="<%=paraId%>">
	<TABLE class="ViewForm">
	  <COL width="10%">
	  <COL width="37%">
	  <COL width="6%">
	  <COL width="10%">
	  <COL width="37%">    
    <TR>
        <TD><%=SystemEnv.getHtmlLabelName(18797,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%></TD>
        <TD class=field>
            <select id='organizationtype' name='organizationtype' onchange='clearSpan()'>
                <option value=3 <%if(organizationtype.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%></option>
                <option value=2 <%if(organizationtype.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
                <option value=1 <%if(organizationtype.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option></select>
                <button  type='button'class=Browser onclick='onShowOrganization(organizationspan,organizationid)'></button>
                <span id='organizationspan'>
                   <%=showname%>
                    <%
                        if (organizationid.equals("")) {
                    %>
                     <img src="/images/BacoError_wev8.gif" align=absmiddle>
                   <%
                        }
                   %>
                </span>
                   <input type=hidden id='organizationid' name='organizationid' value=<%=organizationid%>>
        </TD>
		<TD></TD>
        <TD><%=SystemEnv.getHtmlLabelName(15394,user.getLanguage())%></TD>
        <TD class="Field">
            <button  type='button'class="calendar" onclick="onShowDate(occurdatespan,occurdate)"></BUTTON>
            <SPAN id="occurdatespan"><%=occurDate%></SPAN>
            <INPUT type="hidden" name="occurdate" value="<%=occurDate%>"></TD>

    </TR>
    <TR style="height: 1px"><TD class="Line" colSpan="2"></TD><TD></TD><TD class="Line" colSpan="2"></TD></TR> 
    <TR>
        <TD><%=SystemEnv.getHtmlLabelName(15503,user.getLanguage())%></TD>
        <TD class="Field">
        	<select name="operationtype">
        		<option value="0" <%if(Util.getDoubleValue(amount,0)<=0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(24862,user.getLanguage())%></option>
        		<option value="1" <%if(Util.getDoubleValue(amount,0)>0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(24861,user.getLanguage())%></option>
        	</select>
            </TD>
		<TD></TD>
        <TD><%=SystemEnv.getHtmlLabelName(15395,user.getLanguage())%></TD>
        <TD class="Field">
			<INPUT class="InputStyle" type=text name="amount" size="10" onKeyPress="ItemNum_KeyPress()" 
            onBlur="checknumber1(this);checkinput('amount','amountspan')" value="<%=Math.abs(Util.getDoubleValue(amount,0))%>">
            <SPAN id="amountspan"></SPAN>
        </TD>
    </TR>
    <TR style="height: 1px"><TD class="Line" colSpan="2"></TD><TD></TD><TD class="Line" colSpan="2"></TD></TR>
    <TR>
        <TD><%=SystemEnv.getHtmlLabelName(874,user.getLanguage())%></TD>
        <TD class="Field">
			<INPUT class="InputStyle" type="text" size="30" name="debitremark" onchange="checkinput('debitremark','debitremarkspan')" value="<%=credenceNo%>">
            <SPAN id="debitremarkspan"></SPAN>
        </TD>
        <TD></TD>
		<TD><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></TD>
        <TD class="Field">
			<button  type='button'class="browser" onclick="onShowRequest()"></BUTTON>
            <SPAN id="requestspan"><%=Util.toScreen(requestComInfo.getRequestname(relatedWFId),user.getLanguage())%></SPAN>
            <INPUT class="InputStyle" type="hidden" name="requestid" >
        </TD>
    </TR>
    <TR style="height: 1px"><TD class="Line" colSpan="2"></TD><TD></TD><TD class="Line" colSpan="2"></TD></TR> 
    <TR>
        <TD><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TD>
        <TD colspan="4" class="Field">
			<TEXTAREA class="InputStyle" name="summary" style="width:80%" rows="3"><%=Util.toScreen(remark,user.getLanguage())%></TEXTAREA></TD>
    </TR>
    <TR style="height: 1px"><TD class="Line" colSpan="5"></TD></TR> 
		</TABLE></FORM>
		</TD>
		</TR>
		</TABLE>
	</TD>
	<TD></TD>
</TR>
<TR>
	<TD height="10" colspan="3"></TD>
</TR>
</TABLE>
<SCRIPT language="vbs">
sub onShowResource()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourcespan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmmain.resourceid.value=id(0)
	frmmain.action="FnaPersonalReturn.jsp"
    frmmain.submit()
	else 
	resourcespan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	frmmain.resourceid.value=""
	end if
	end if
end sub

sub onShowDoc()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "0" then
	docspan.innerHtml = "<A href='/docs/docs/DocDetail.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmmain.docid.value=id(0)
	else 
	docspan.innerHtml = ""
	frmmain.docid.value=""
	end if
	end if
end sub

sub onShowRequest1()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	requestspan.innerHtml = "<A href='/docs/docs/DocDetail.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmmain.requestid.value=id(0)
	else 
	requestspan.innerHtml = ""
	frmmain.requestid.value=""
	end if
	end if
end sub
</SCRIPT>

<SCRIPT language="javascript">
function doSave(){
    if	(check_form(frmmain,'resourceid,name,occurdate,amount,debitremark')) {
		document.frmmain.submit();
	}
}

function goBack() {
	document.location.href = "FnaPersonalReturnView.jsp?paraid=<%=paraId%>";
}
function clearSpan() {
    $G("organizationspan").innerHTML = "";
    $G("organizationid").value = "";
}
function onShowOrganization(spanname, inputname) {
    if (jQuery("select[name=organizationtype]" ).val() == "3")
        return onShowHR(spanname, inputname);
    else if (jQuery("select[name=organizationtype]" ).val() == "2")
        return onShowDept(spanname, inputname);
    else if (jQuery("select[name=organizationtype]" ).val() == "1")
        return onShowSubcom(spanname, inputname);
    else
        return null;
}
function onShowHR(spanname, inputname) {
	try {
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
    if (data != null) {
        if (data.id != "") {
            jQuery(spanname).html("<A href='/hrm/resource/HrmResource.jsp?id="+data.id+"'>"+data.name+"</A>");
            jQuery(inputname).val(data.id);
            document.forms[0].action="FnaPersonalReturn.jsp";
            document.forms[0].submit();
        } else {
            if (ismand == 1){
                jQuery(spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			}else{
                jQuery(spanname).html("");
				
			}
			jQuery(inputname).val("");
        }
    }
	 } catch(e) {
        return;
    }
}

function onShowDept(spanname, inputname) {
	try {
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+jQuery(inputname).val());
    if (data != null) {
        if (data.id != "") {
            jQuery(spanname).html("<A href='/hrm/company/HrmDepartmentDsp.jsp?id="+data.id+"'>"+data.name+"</A>");
            jQuery(inputname).val(data.id);
            document.forms[0].action="FnaPersonalReturn.jsp";
            document.forms[0].submit();
        } else {
            if (ismand == 1){
                jQuery(spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			}else{
                jQuery(spanname).html("");
				
			}
			jQuery(inputname).val("");
        }
    }
	} catch(e) {
        return;
    }
}
function onShowSubcom(spanname, inputname) {
	try {
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="+inputname.value);
    if (data != null) {
        if (data.id != "") {
            jQuery(spanname).html("<A href='/hrm/company/HrmSubCompanyDsp.jsp?id="+data.id+"'>"+data.name+"</A>");
            jQuery(inputname).val(data.id);
            document.forms[0].action="FnaPersonalReturn.jsp" ;
            document.forms[0].submit();
        } else {
            if (ismand == 1){
                jQuery(spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			}else{
                jQuery(spanname).html("");
				
			}
			jQuery(inputname).val("");
        }
    }
	 } catch(e) {
        return;
    }
}

function onShowRequest(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp");
	if (data!=null){
		if (data.id != ""){
			jQuery("#requestspan").html("<A href='/workflow/request/ViewRequest.jsp?isrequest=1&requestid="+data.id+"' target='_blank'>"+data.name+"</A>");
			jQuery("input[name=requestid]").val(data.id);
		}else{ 
			jQuery("#requestspan").html("");
			jQuery("input[name=requestid]").val("");
		}
	}
}
</SCRIPT>
</BODY>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>

