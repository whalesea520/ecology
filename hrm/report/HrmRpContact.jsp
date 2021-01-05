<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CapitalStateComInfo" class="weaver.cpt.maintenance.CapitalStateComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String userid =""+user.getUID();
String subcompany1=user.getUserSubCompany1()+"" ;

/*权限判断,人力资产管理员以及其所有上级*/
//boolean canView = false;
//ArrayList allCanView = new ArrayList();
//String tempsql = "select resourceid from HrmRoleMembers where roleid = 4 ";
//RecordSet.executeSql(tempsql);
//while(RecordSet.next()){
//	String tempid = RecordSet.getString("resourceid");
//	allCanView.add(tempid);
//	AllManagers.getAll(tempid);
//	while(AllManagers.next()){
//		allCanView.add(AllManagers.getManagerID());
//	}
//}// end while
//
//for (int i=0;i<allCanView.size();i++){
//	if(userid.equals((String)allCanView.get(i))){
//		canView = true;
//	}
//}
//
//if(!canView) {
//	response.sendRedirect("/notice/noright.jsp") ;
//	return ;
//}
/*权限判断结束*/

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1515,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
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
<FORM id=weaver name=frmain action="HrmRpContactResult.jsp" method=post>
<input class=inputStyle type="hidden" name="orderby" value="departmentid,dsporder">
<table class=ViewForm>
    <colgroup> <col width="10%"> <col width="20%"> <col width="10%"> <col width="25%"><col width="10%"> 
    <col width="25%"><tbody> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
      <td class=Field><input class=wuiBrowser id=department type=hidden name=department 
	_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
	>
        
      </td>
      <TD><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
      <TD class=Field>
        <INPUT class=inputStyle name=resourcename size=20>
      </TD>
      <TD><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></td>
      <TD class=Field> 
        <select class=inputStyle id=sex name=sex>
          <option value="" selected></option>
          <option value=0 ><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%></option>
          <option value=1 ><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%></option>
        </select>
      </TD>
    </tr>
<TR style="height:2px"><TD class=Line colSpan=6></TD></TR> 
    <tr> 
     <TD><%=SystemEnv.getHtmlLabelName(380,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(530,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
      <TD class=Field><BUTTON type=button class=Calendar id=selectstartdate onclick="gettheDate(startdate,startdatespan)"></BUTTON> 
        <SPAN id=startdatespan ></SPAN>- 
        <BUTTON type=button class=Calendar id=selectstartdateTo onclick="gettheDate(startdateTo,startdateTospan)"></BUTTON> 
        <SPAN id=startdateTospan ></SPAN> 
        <input class=inputStyle type="hidden" name="startdate">
        <input class=inputStyle type="hidden" name="startdateTo">
      <TD><%=SystemEnv.getHtmlLabelName(464,user.getLanguage())%></td>
      <TD class=Field><BUTTON type=button class=Calendar id=selectbirthday onclick="gettheDate(birthday,birthdayspan)"></BUTTON> 
        <SPAN id=birthdayspan ></SPAN> 
        - <BUTTON type=button class=Calendar id=selectbirthdayTo onclick="gettheDate(birthdayTo,birthdayTospan)"></BUTTON> 
        <SPAN id=birthdayTospan ></SPAN> 
        <input class=inputStyle type="hidden" name="birthday">
        <input class=inputStyle type="hidden" name="birthdayTo">
      <td><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></td>
      <td class=Field>
        <input class=wuiBrowser class=inputStyle id=subcompany1 type=hidden name=subcompany1 value="<%=subcompany1%>"
        _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
        displayText="<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(subcompany1),user.getLanguage())%>"
        >
      </td>
    </tr>
    <TR style="height:2px"><TD class=Line colSpan=6></TD></TR> 
    </tbody> 
  </table>
 </FORM>
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
 <script language=vbs>
sub onShowResourceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourceidspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmain.resourceid.value=id(0)
	else 
	resourceidspan.innerHtml = ""
	frmain.resourceid.value=""
	end if
	end if
end sub
sub onShowDepartmentID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmain.department.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	departmentspan.innerHtml = id(1)
	frmain.department.value=id(0)
	else
	departmentspan.innerHtml = ""
	frmain.department.value=""
	end if
	end if
end sub

sub onShowSubCompany()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="&frmain.subcompany1.value)
	issame = false 
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	subcompanyspan.innerHtml = id(1)
	frmain.subcompany1.value=id(0)
	else
	subcompanyspan.innerHtml = ""
	frmain.subcompany1.value=""
	end if
	end if
end sub

sub onShowStateID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalStateBrowser.jsp?from=flowview")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	stateidspan.innerHtml = id(1)
	frmain.stateid.value=id(0)
	else 
	stateidspan.innerHtml = ""
	frmain.stateid.value=""
	end if
	end if
end sub

sub onShowCapitalID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	capitalidspan.innerHtml = id(1)
	frmain.capitalid.value=id(0)
	else 
	capitalidspan.innerHtml = ""
	frmain.capitalid.value=""
	end if
	end if
end sub
</script>
<script language=javascript>  
$(document).ready(function(){
$("#subcompany1Span").html("<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(subcompany1),user.getLanguage())%>");  
});
function submitData() {
 frmain.submit();
}
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>