
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<% if(!HrmUserVarify.checkUserRight("HrmCareerApplyAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript">
function showAlert(msg){
    window.top.Dialog.alert(msg);
}
function showConfirm(msg){
    if(confirm(msg))
        checkPass();

     return;
}
function checkPass(){
    saveBtn.disabled = true;
    document.resource.submit() ;
}
</script>
</HEAD>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

String careerid = Util.null2String(request.getParameter("careerid"));
String sql = "select * from HrmCareerInvite where id = "+careerid;
String opendate ="";
String jobtitle ="";
if(!careerid.equals("")){
    rs.executeSql(sql);
    while(rs.next()){
     opendate = Util.null2String(rs.getString("createdate"));
     jobtitle = Util.null2String(rs.getString("careername"));
    }
}

boolean hasFF = true;
RecordSet.executeProc("Base_FreeField_Select","hr");
if(RecordSet.getCounts()<=0)
	hasFF = false;
else
	RecordSet.first();

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(773,user.getLanguage());
String needfav ="1";
String needhelp ="";

int userId=0, subCompanyId=0;
userId = user.getUID();

if(request.getParameter("subCompanyId")!=null){
	subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"));
}else{
	subCompanyId = user.getUserSubCompany1();
}

if(subCompanyId==-1){
	rs.executeSql("select dftsubcomid from SystemSet");
	if(rs.next()){
		subCompanyId = rs.getInt("dftsubcomid");
	}
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1402,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<iframe id="checkHas" style="display:none"></iframe>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<%
/*登录名冲突*/
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<FORM name=resource id=resource action="HrmCareerApplyOperation.jsp" method=post enctype="multipart/form-data">
<input class=inputstyle type=hidden name=operation value="add">
<input class=inputstyle type=hidden name=subCompanyId value="<%=subCompanyId%>">
<%
  sql = "select max(id) from HrmResource";
  rs.executeSql(sql);
  rs.next();
  int id = rs.getInt(1);
  sql = "select max(id) from HrmCareerApply";
  rs.executeSql(sql);
  rs.next();
  if(id<rs.getInt(1)){
    id = rs.getInt(1);
  }
    id +=1;
%>
<input class=inputstyle type=hidden name=id value="<%=id%>">
  <TABLE class=ViewForm>
    <COLGROUP>
    <COL width="49%">
    <COL width="49%">
    <TBODY>
    <TR>
      <TD vAlign=top>
        <TABLE width="100%">
          <COLGROUP>
          <COL width=30%>
          <COL width=70%>
          <TBODY>
          <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing style="height:2px">
            <TD class=Line1 colSpan=2></TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
            <TD class=Field>
              <INPUT class=inputstyle maxLength=30 size=30 name="lastname" onchange='checkinput("lastname","lastnamespan")'>
              <SPAN id=lastnamespan>
               <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
              </SPAN>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></TD>
            <TD class=Field>
              <select class=inputstyle id=sex name=sex>
                <option value=0 selected><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%></option>
                <option value=1><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%></option>
              </select>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(15675,user.getLanguage())%></td>
            <td class=Field>
              <select class=inputstyle id=category name=category>
                <option value=""></option>
                <option value="0" ><%=SystemEnv.getHtmlLabelName(134,user.getLanguage())%></option>
                <option value="1"  ><%=SystemEnv.getHtmlLabelName(1830,user.getLanguage())%></option>
                <option value="2" ><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%></option>
                <option value="3" ><%=SystemEnv.getHtmlLabelName(1832,user.getLanguage())%></option>
              </select>
            </td>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          </TBODY>
        </TABLE>
       </TD>
    </TR>
    <TR>
      <TD vAlign=top>
        <TABLE width="100%">
          <COLGROUP> <COL width=30%> <COL width=70%> <TBODY>
          <TR class=Title>
            <TH colSpan=4>&nbsp;</TH>
          </TR>
          <TR class=spacing style="height:2px">
            <TD class=Line1 colSpan=3></TD>
          </TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(15671,user.getLanguage())%></TD>
            <TD class=Field>
					<%
						String careername = "" ;
						careername = jobtitle ;
						if( Util.getIntValue(careername) != -1 ) careername = JobTitlesComInfo.getJobTitlesname(jobtitle) ;
						if(careerid.equals("")){
					%>
							<BUTTON class=Browser type="button" id=Selectcareerinvite onClick="onShowCareerInvite()"></BUTTON>
							<SPAN id=jobtitlespan><%=careername%><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
					<%}else{%>
							<%=careername%>
					<%}%>
              <input class=inputstyle id=jobtitle type=hidden name=jobtitle value="<%=jobtitle%>" onchange='checkinput("jobtitle","jobtitlespan")'>
              <input class=inputstyle id=careerinvite type=hidden name=careerinvite value="<%=careerid%>" onchange='checkinput("careerinvite","careerinvitespan")'>
            </TD>
          </TR>
       <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
       <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15707,user.getLanguage())%></TD>
          <TD class=Field>
          <input class=inputstyle type=file name="picture">
          </TD>
       </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          </TBODY>
        </TABLE>
      </TD>
    </TR>
    <TR class=Title>
       <TD vAlign=top colspan=2 >
       <table class=ViewForm >
	 <colgroup>
	   <col width="15%">
	   <col width=35％>
	   <col width="15％">
       <col width="35％">
         <tbody>
	 <TR class=Title>
           <TH colspan=4> <%=SystemEnv.getHtmlLabelName(1842,user.getLanguage())%></TH>
         </TR>
         <TR class=Spacing style="height:2px">
            <TD class=Line1  colspan=4></TD>
         </TR>
	  <tr>
            <td  > <%=SystemEnv.getHtmlLabelName(1843,user.getLanguage())%></td>
            <td valign=top class=Field >
              <input class=inputstyle maxlength=30  size=30 name=salarynow  onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("salarynow")'>
	    </td>
            <td><%=SystemEnv.getHtmlLabelName(1844,user.getLanguage())%></td>
            <td valign=top class=Field >
               <input class=inputstyle maxlength=3  size=30 name=worktime  onKeyPress="ItemCount_KeyPress(event)" onBlur='checknumber("worktime");checkinput("worktime","worktimeimage")' >
		<SPAN id=worktimeimage><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN>
	    </td>
          </tr>
          <TR style="height:1px"><TD class=Line colSpan=6></TD></TR>
          <tr>
            <td  > <%=SystemEnv.getHtmlLabelName(1845,user.getLanguage())%></td>
            <td valign=top class=Field >
              <input class=inputstyle maxlength=30  size=30 name=salaryneed  onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("salaryneed");checkinput("salaryneed","salaryneedimage")'>
	      <SPAN id=salaryneedimage><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN>
	    </td>
            <td><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></td>
            <td class=Field>

	       <input class="wuiBrowser" id=currencyid type=hidden name=currencyid 
		   _url="/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp">
            </td>
          </tr>
          <TR style="height:1px"><TD class=Line colSpan=6></TD></TR>
          <tr>
            <Td  > <%=SystemEnv.getHtmlLabelName(1846,user.getLanguage())%></Td>
            <TD vAlign=top colspan="3" class=Field >
              <TEXTAREA class=inputstyle style="WIDTH: 100%" name=reason rows=6></TEXTAREA>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR class=Section>
            <Td  > <%=SystemEnv.getHtmlLabelName(1847,user.getLanguage())%></Td>
            <TD vAlign=top colspan="3" class=Field >
              <TEXTAREA class=inputstyle style="WIDTH: 100%" name=otherrequest rows=6></TEXTAREA>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
        </tbody>
      </table>
    </td>
  </tr>
  <TR>
    <TD vAlign=top>
      <TABLE width="100%">
        <COLGROUP>
          <COL width=30%>
          <COL width=70%>
        <TBODY>
          <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(569,user.getLanguage())%></TH>
          </TR>
          <TR class=Spacing style="height:2px">
            <TD class=Line1 colSpan=2></TD>
          </TR>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></td>
            <td class=Field>
              <input class=inputstyle maxlength=30 size=30 name=contactor onchange='checkinput("contactor","contactorimage")'  >
	      <SPAN id=contactorimage><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN>
            </td>
          </tr>
          <TR style="height:1px"><TD class=Line colSpan=6></TD></TR>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(479,user.getLanguage())%></td>
            <td class=Field>
              <input class=inputstyle maxlength=8 size=30 name=homepostcode onKeyPress="ItemCount_KeyPress(event)" onBlur='checknumber("homepostcode");' >
            </td>
          </tr>
          <TR style="height:1px"><TD class=Line colSpan=6></TD></TR>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></td>
            <td class=Field>
              <input class=inputstyle maxlength=100 size=30 name=homeaddress >
            </td>
          </tr>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          </TBODY>
        </TABLE>
      <TD vAlign=top>
        <TABLE width="100%">
          <COLGROUP> <COL width=30%> <COL width=70%> <TBODY>
          <TR class=Title>
            <TH colSpan=4>&nbsp;</TH>
          </TR>
          <TR class=Spacing style="height:2px">
            <TD class=Line1 colSpan=3></TD>
          </TR>
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></td>
            <td class=Field>
              <input class=inputstyle maxlength=128 size=30  onchange='checkinput_email("email","emailimage")'  name=email >
	      <SPAN id=emailimage><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN>
            </td>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></td>
            <td class=Field>
              <input class=inputstyle maxlength=15 size=30  onchange='checkinput("homephone","homephoneimage")'  name=homephone >
	          <SPAN id=homephoneimage><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN>
            </td>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(1848,user.getLanguage())%></td>
            <td class=Field>
              <input class=inputstyle maxlength=100 size=30 name=homepage >
            </td>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          </TBODY>
        </TABLE>
      </TD>
    </TR>
    <TR class=Spacing valign="top">
      <TD  colspan=2>
        <table width="100%">
          <colgroup>
            <col width=15%>
            <col width=85%>
          <tbody>
          <tr>
	    <td ><%=SystemEnv.getHtmlLabelName(1849,user.getLanguage())%></td>
            <td  class=Field >
              <textarea class=inputstyle style="WIDTH: 100%" name=selfcomment rows=6></textarea>
            </td>
          </tr>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
        </tbody>
      </table>
    </td>
  </tr>
	</Tbody>
  </TABLE>
 </FORM>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>
<script language=vbs>

sub onShowCurrencyID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	currencyidspan.innerHtml = id(1)
	resource.currencyid.value=id(0)
	else
	currencyidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.currencyid.value=""
	end if
	end if
end sub
</script>

<script language=javascript>
function onShowCareerInvite(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/career/CareerInviteBrowser.jsp?");
	if (data||data!=null){
	if (data.id!=0){
	//careerinvitespan.innerHtml = id(3)
	jQuery("#careerinvite").val(data.id);
	jQuery("#jobtitlespan").html(data.name);
	jQuery("#jobtitle").val(data.other1);
	}else{
	//careerinvitespan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	jQuery("#careerinvite").val("");
	jQuery("#jobtitlespan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	jQuery("#jobtitle").val("");
	}
	}
}

var saveBtn ;
function doSave(obj) {
   saveBtn = obj;
   if(check_form(jQuery("#resource")[0],'lastname,jobtitle,careerinvite,worktime,salaryneed,contactor,email,homephone')){
      document.getElementById("checkHas").src="HrmCareerApplyCheck.jsp?lastname="+jQuery("input[name=lastname]").val();
    }
}
</script>

</BODY>
</HTML>