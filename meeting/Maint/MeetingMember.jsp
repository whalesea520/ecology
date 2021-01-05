
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<%
boolean canedit=false;
if(HrmUserVarify.checkUserRight("MeetingType:Maintenance",user)) {
	canedit=true;
   }

String meetingtype = Util.null2String(request.getParameter("meetingtype"));
int subcompanyid = Util.getIntValue(request.getParameter("subCompanyId"),user.getUserSubCompany1());
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(2106,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canedit==true){
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/meeting/Maint/MeetingType_left.jsp?subCompanyId="+subcompanyid+",_self} " ;
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

<%if(canedit){%>
<FORM id=weaverA  name=weaverA action="MeetingMemberOperation.jsp" method=post  >
<input class=inputstyle type="hidden" name="method" value="add">
<input class=inputstyle type="hidden" name="meetingtype" value="<%=meetingtype%>">
<INPUT class=inputstyle id=subcompanyid type=hidden name=subcompanyid value="<%=subcompanyid%>">
<TABLE class=viewform>
  <COLGROUP>
  <COL width="15%">
  <COL width=85%>
  <TBODY>
  <TR class=separator style="height: 1px;">
          <TD class=Sep1 colSpan=4></TD></TR>
          
          <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
          <TD class=Field>
			<SELECT class=inputstyle name=membertype onchange="onChangeMembertype()">
			  <option value="1">HRM
			  <%if(isgoveproj==0){%>
<%if(software.equals("ALL") || software.equals("CRM")){%>
			  <option value="2">CRM
<%}%>
<%}%>
			</SELECT>
		  </TD>
        </TR>
         <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
           <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2106,user.getLanguage())%></TD>
          <TD class=Field>
			  <button type=button  class=Browser id=SelectHrmID onclick="onShowHrmID('memberidspan','memberid')" name=showhrm></BUTTON> 
			  <button type=button  class=Browser id=SelectCrmID style="display:none" onclick="onShowCrmID('memberidspan','memberid')" name=showcrm></BUTTON>
              <input class=inputstyle id=memberid type=hidden name=memberid>
              <SPAN id=memberidspan><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN> 
		  </TD>
        </TR>
          <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
          <TR>
          <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
          <TD class=Field>
              <input name=desc class=inputstyle style="width=80%">
		  </TD>
        </TR>
    <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
  </TBODY>
</TABLE>
</FORM>

<FORM id=weaverD action="MeetingMemberOperation.jsp" method=post>
<input class=inputstyle type="hidden" name="method" value="delete">
<input class=inputstyle type="hidden" name="meetingtype" value="<%=meetingtype%>">
<INPUT class=inputstyle id=subcompanyid type=hidden name=subcompanyid value="<%=subcompanyid%>">
<TABLE class=form>
  <COLGROUP>
  <COL width="20%">
  <COL width=80%>
  <TBODY>
  <TR class=Spacing>
          <TD class=Sep1 colSpan=2></TD></TR>
           <TR>
          <TD colSpan=2>
		  <button class=btnDelete accessKey=D type=submit onclick="return isdel()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
	  
		  </TD>
        </TR>
  </TBODY>
</TABLE>
<%}%>
	  <TABLE class=ListStyle cellspacing=1 >
        <TBODY>
	    <TR class=Header>
			<th width=10>&nbsp;</th>
			<th><%=SystemEnv.getHtmlLabelName(2106,user.getLanguage())%></th>
			<th><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></th>
	    </TR>
     <TR style="height:1px;" class=Line><TD colspan="3" ></TD></TR> 
<%
String id="";
RecordSet.executeProc("Meeting_Member_SelectAll",meetingtype);
boolean isLight = false;
while(RecordSet.next())
{
		if(isLight)
		{%>	
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>

			<td width=10><%if(canedit){%><input class=inputstyle type=checkbox name=MeetingMemberIDs value="<%=RecordSet.getString("id")%>"><%}%></td>
			<td>
				<%if(RecordSet.getString("membertype").equals("1")){%>
					<A href='/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("memberid")%>'><%=ResourceComInfo.getResourcename(RecordSet.getString("memberid"))%></a>
				<%}else{%>
					<A href='/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSet.getString("memberid")%>'><%=CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("memberid"))%></a>
				<%}%>
			</td>
			<td><%=RecordSet.getString("desc_n")%></td>
    </tr>
<%	
	isLight = !isLight;
	id += RecordSet.getString("memberid")+",";
}%>
<input type='hidden' name='memberids' id='memberids' value='<%=id%>'/>
</TBODY>
</TABLE>
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
<script language=javascript>
function submitData() {
	if(check_form(weaverA,"memberid")){
		if(document.getElementById('memberids').value.length > 2000){
			alert('<%=SystemEnv.getHtmlLabelName(24476,user.getLanguage())%>');
			return;
		}
	 	weaverA.submit();
	}
}
  function onChangeMembertype(){
	thisvalue=$GetEle("membertype").value
	weaverA.memberid.value=""

	memberidspan.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"

	if(thisvalue==1){
 		$GetEle("showhrm").style.display='';
	}
	else{
		$GetEle("showhrm").style.display='none';
	}
	if(thisvalue==2){
 		$GetEle("showcrm").style.display='';
	}
	else{
		$GetEle("showcrm").style.display='none';
	}}
</script>
<script type="text/javascript">
function disModalDialog(url, spanobj, inputobj, need, curl) {

	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}



function onShowHrmID(tdname,inputename) {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			, $GetEle(tdname)
			, $GetEle(inputename)
			, true
			, "/hrm/resource/HrmResource.jsp?id=");
}

function onShowCrmID(tdname,inputename) {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
			, $GetEle(tdname)
			, $GetEle(inputename)
			, true
			, "/CRM/data/ViewCustomer.jsp?CustomerID=");
}
</script>

</body>
</html>