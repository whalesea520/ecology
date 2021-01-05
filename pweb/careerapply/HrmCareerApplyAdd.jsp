
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%@ include file="/systeminfo/ParameterFilter.jsp"%>
<%@ taglib uri="/browserTag" prefix="brow"%>


<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/js/chechinput_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
<script type="text/javascript" src="/js/jquery.table_wev8.js"></script>
<script language="javascript" type="text/javascript" src="/js/init_wev8.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<script language=javascript src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/messagejs/highslide/highslide-full_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_7_wev8.js"></script>
<link rel="stylesheet" href="/css/init_wev8.css" type="text/css" />
<SCRIPT language="javascript">
function showAlert(msg){
    alert(msg);
}
function showConfirm(msg){
    return confirm(msg);
}
function checkPass(){
    document.resource.submit() ;
}
</script>
</HEAD>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

String careerid = Util.null2String(request.getParameter("careerid"));
String sql = "select * from HrmCareerInvite where id = "+careerid;
rs.executeSql(sql);
String opendate = "";
String jobtitle = "";
while(rs.next()){
 opendate = Util.null2String(rs.getString("createdate"));
 jobtitle = Util.null2String(rs.getString("careername"));
}

String inviteid = Util.null2String(request.getParameter("careerinvite"));

boolean hasFF = true;
RecordSet.executeProc("Base_FreeField_Select","hr");
if(RecordSet.getCounts()<=0)
	hasFF = false;
else
	RecordSet.first();

%>
<BODY>
<iframe id="checkHas" style="display:none"></iframe>
<DIV class=HdrProps></DIV>
<FORM name=resource id=resource action="/pweb/careerapply/HrmCareerApplyOperation.jsp" method=post>

	<input type=hidden name=operation value="add">
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
        <input type=hidden name=id value="<%=id%>">

<DIV><BUTTON class=btnSave accessKey=S type=button onClick="doSave()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(1402, 7)%></BUTTON> </DIV>
  <TABLE class=Form>
    <COLGROUP> <COL width="49%"> <COL width=10> <COL width="49%"> <TBODY>
    <TR>
      <TD vAlign=top>
        <TABLE width="100%">
          <COLGROUP> <COL width=30%> <COL width=70%><TBODY>
          <TR class=Section>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(81711, 7)%></TH>
          </TR>
          <TR class=Separator>
            <TD class=Sep1 colSpan=2></TD>
          </TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(413, 7)%></TD>
            <TD class=Field>
              <INPUT class=saveHistory maxLength=30 size=30 name="lastname" id="lastname" onchange='checkinput("lastname","lastnamespan")'>
              <SPAN id=lastnamespan>
               <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
              </SPAN>
            </TD>
          </TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(416, 7)%></TD>
            <TD class=Field>
              <select class=saveHistory id=sex name=sex>
                <option value=0 selected><%=SystemEnv.getHtmlLabelName(417,7)%></option>
                <option value=1><%=SystemEnv.getHtmlLabelName(418,7)%></option>
              </select>
            </TD>
          </TR>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(15675, 7)%></td>
            <td class=Field>
              <select class=saveHistory id=category name=category>
                <option value=""></option>
                <option value="0" ><%=SystemEnv.getHtmlLabelName(134,7)%></option>
                <option value="1"  ><%=SystemEnv.getHtmlLabelName(1830,7)%></option>
                <option value="2" ><%=SystemEnv.getHtmlLabelName(1831,7)%></option>
                <option value="3" ><%=SystemEnv.getHtmlLabelName(1832,7)%></option>
              </select>
            </td>
          </TR>
<!--
          <TR>
            <TD>照片</TD>
            <TD class=Field>
              <input type="file" name="photoid">
            </TD>
          </TR>
-->
          </TBODY>
        </TABLE>
    </TR>
    <TD vAlign=top>
        <TABLE width="100%">
          <COLGROUP> <COL width=30%> <COL width=70%> <TBODY>
          <TR class=Section>
            <TH colSpan=4>&nbsp;</TH>
          </TR>
          <TR class=Separator>
            <TD class=Sep3 colSpan=3></TD>
          </TR>
<!--
          <TR>
            <TD>相关招聘信息发布时间</TD>
            <TD class=Field>
-->
<%if(careerid.equals("")){%>
<!--              <BUTTON class=Browser id=Selectcareerinvite onclick="onShowCareerInvite()"></BUTTON>
              <SPAN id=careerinvitespan>
               <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
              </SPAN>
 -->
<%}else{
%>
<!--               <%=opendate%>-->
<%}%>
<!--              <INPUT id=careerinvite type=hidden name=careerinvite value="<%=careerid%>" onchange='checkinput("careerinvite","careerinvitespan")'>
            </TD>
          </TR>
-->
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(15671, 7)%></TD>
            <TD class=Field>
<%if(careerid.equals("")){%>
<!--              <BUTTON class=Browser id=SelectJobTitle></BUTTON> -->
	      <BUTTON class=Browser id=Selectcareerinvite onclick="onShowCareerInvite()"></BUTTON>
              <SPAN id=jobtitlespan>
                <%=JobTitlesComInfo.getJobTitlesname(jobtitle)%>
               <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
              </SPAN>
<%}else{
%>
               <%=JobTitlesComInfo.getJobTitlesname(jobtitle)%>
<%}%>
              <INPUT id=jobtitle type=hidden name=jobtitle value="<%=jobtitle%>"onchange='checkinput("jobtitle","jobtitlespan")'>
              <INPUT id=careerinvite type=hidden name=careerinvite value="<%=careerid%>" onchange='checkinput("careerinvite","careerinvitespan")'>
            </TD>
          </TR>
          </TBODY>
        </TABLE>
      </TD>
    </TR>
    <TR class=Section>
       <TD vAlign=top colspan=2 >
       <table class=Form >
	 <colgroup>
	   <col width="15%">
	   <col width=35％>
	   <col width="15％">
           <col width="35％">
         <tbody>
	 <TR class=Section>
           <TH colspan=4> <%=SystemEnv.getHtmlLabelName(1842, 7)%></TH>
         </TR>
         <TR class=Separator>
            <TD class=sep2  colspan=4></TD>
         </TR>
	  <tr>
            <td  > <%=SystemEnv.getHtmlLabelName(1843, 7)%></td>
            <td valign=top class=Field >
              <input class=saveHistory maxlength=30  size=30 name=salarynow  onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("salarynow")'>
	    </td>
            <td><%=SystemEnv.getHtmlLabelName(20398, 7)%></td>
            <td valign=top class=Field >
               <input class=saveHistory maxlength=30  size=30 name=worktime  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("worktime");checkinput("worktime","worktimeimage")' >
		<SPAN id=worktimeimage><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN>
	    </td>
          </tr>
          <tr>
            <td  > <%=SystemEnv.getHtmlLabelName(1845, 7)%></td>
            <td valign=top class=Field >
              <input class=saveHistory maxlength=30  size=30 name=salaryneed  onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("salaryneed");checkinput("salaryneed","salaryneedimage")'>
	      <SPAN id=salaryneedimage><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN>
	    </td>
            <td><%=SystemEnv.getHtmlLabelName(406, 7)%></td>
            <td class=Field>
            <brow:browser viewType="0" name="currencyid" browserValue="" 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' 
					completeUrl="/data.jsp?type=12"   width="240px" zDialog="true"
					browserSpanValue="">
			</brow:browser>
	       <!--<BUTTON class=Browser id=SelectCurrencyID onClick="onShowCurrencyID1()" type="button"></BUTTON>
	       <SPAN class=saveHistory id=currencyidspan></SPAN>
	       <INPUT id=currencyid type=hidden name=currencyid >
            -->
            </td>
          </tr>
          <tr>
            <Td  > <%=SystemEnv.getHtmlLabelName(1846, 7)%></Td>
            <TD vAlign=top colspan="3" class=Field >
              <TEXTAREA class=saveHistory style="WIDTH: 100%" name=reason rows=6></TEXTAREA>
            </TD>
          </TR>
          <TR class=Section>
            <Td  > <%=SystemEnv.getHtmlLabelName(1847, 7)%></Td>
            <TD vAlign=top colspan="3" class=Field >
              <TEXTAREA class=saveHistory style="WIDTH: 100%" name=otherrequest rows=6></TEXTAREA>
            </TD>
          </TR>
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
          <TR class=Section>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(569, 7)%></TH>
          </TR>
          <TR class=Separator>
            <TD class=Sep3 colSpan=2></TD>
          </TR>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(572, 7)%></td>
            <td class=Field>
              <input class=saveHistory maxlength=30 size=30 name=contactor onchange='checkinput("contactor","contactorimage")'  >
	      <SPAN id=contactorimage><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN>
            </td>
          </tr>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(479, 7)%></td>
            <td class=Field>
              <input class=saveHistory maxlength=8 size=30 name=homepostcode onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("homepostcode");checkinput("homepostcode","homepostcodeimage")' >
	      <SPAN id=homepostcodeimage><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN>
            </td>
          </tr>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(110, 7)%></td>
            <td class=Field>
              <input class=saveHistory maxlength=100 size=30  onchange='checkinput("homeaddress","homeaddressimage")' name=homeaddress >
	      <SPAN id=homeaddressimage><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN>
            </td>
          </tr>
          </TBODY>
        </TABLE>
      <TD vAlign=top>
        <TABLE width="100%">
          <COLGROUP> <COL width=30%> <COL width=70%> <TBODY>
          <TR class=Section>
            <TH colSpan=4>&nbsp;</TH>
          </TR>
          <TR class=Separator>
            <TD class=Sep3 colSpan=3></TD>
          </TR>
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(477, 7)%></td>
            <td class=Field>
              <input class=saveHistory maxlength=128 size=30  onchange='checkinput_email("email","emailimage")'  name=email >
	      <SPAN id=emailimage><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN>
            </td>
          </TR>
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(421, 7)%></td>
            <td class=Field>
              <input class=saveHistory maxlength=15 size=30  onchange='checkinput("homephone","homephoneimage")'  name=homephone >
	      <SPAN id=homephoneimage><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN>
            </td>
          </TR>
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(1848, 7)%></td>
            <td class=Field>
              <input class=saveHistory maxlength=100 size=30 name=homepage >
            </td>
          </TR>
          </TBODY>
        </TABLE>
      </TD>
    </TR>
    <TR class=Separator valign="top">
      <TD  colspan=2>
        <table width="100%">
          <colgroup>
            <col width=15%>
            <col width=85%>
          <tbody>
          <tr>
	    <td ><%=SystemEnv.getHtmlLabelName(1849, 7)%></td>
            <td  class=Field >
              <textarea class=saveHistory style="WIDTH: 100%" name=selfcomment rows=6></textarea>
            </td>
          </tr>
        </tbody>
      </table>
    </td>
  </tr>


  </FORM>
<script language=vbs>

sub onShowCareerInvite()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/career/CareerInviteBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	//careerinvitespan.innerHtml = id(3)
	resource.careerinvite.value=id(0)
	jobtitlespan.innerHtml = id(1)
	resource.jobtitle.value= id(2)
	else
	//careerinvitespan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.careerinvite.value=""
	jobtitlespan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.jobtitle.value=""
	end if
	end if
end sub
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
function doSave() {
    if(check_form(document.resource,'lastname,jobtitle,careerinvite,worktime,salaryneed,contactor,homepostcode,homeaddress,email,homephone')){
    	$.ajax({
						type:"POST",
						url:"/hrm/career/applyinfo/careerApplyCheck.jsp",
						data: {lastname:$("#lastname").val(),cmd:"add",id:""},
           		 		dataType: "json",
						success: function(data){
							if(data > 0){
								window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(413,7)%>"+$("#lastname").val()+"<%=SystemEnv.getHtmlLabelName(24943,7)%>"+",<%=SystemEnv.getHtmlLabelName(15382,7)%>",function(){
									 checkPass();
								});
							}else{
								checkPass()
								// checkHas.location="HrmCareerApplyCheck.jsp?lastname="+$("#lastname").val();
							}
						},
						 error:function(data){     
					          window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19327,7)%>"); 
					          return;    
					     }     
								
					});
     
      //document.resource.submit() ;
    }
  }
function check_form(thiswins,items)
{
	thiswin = thiswins
	items = items + ",";

	for(i=1;i<=thiswin.length;i++)
	{
	tmpname = thiswin.elements[i-1].name;
	tmpvalue = thiswin.elements[i-1].value;
	while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);

	if(tmpname!="" &&items.indexOf(tmpname+",")!=-1 && tmpvalue == ""){
		 alert("<%=SystemEnv.getHtmlNoteName(14,7)%>");
		 return false;
		}

	}
	return true;
}

function onShowCurrencyID1(){
	var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp");
	if (id!=""){
		if (id.id!=""){
			$("#currencyidspan").html(id.name);
			$("#currencyid").val(id.id);
		}else{
			$("#currencyidspan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			$("#currencyid").val("");
			//currencyidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
			//resource.currencyid.value="";
		}
	}
	return;
}

</script>

</BODY>
</HTML>
