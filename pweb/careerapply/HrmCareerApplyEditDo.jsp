<%@ page import="weaver.general.Util,
                 weaver.systeminfo.SystemEnv" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CareerInviteComInfo" class="weaver.hrm.career.CareerInviteComInfo" scope="page"/>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="ContacterTitleComInfo" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="CareerApplyComInfo" class="weaver.hrm.career.HrmCareerApplyComInfo" scope="page"/>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<%

int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String applyid = Util.null2String(request.getParameter("applyid"));

rs.executeProc("HrmCareerApply_SelectById",applyid);
rs.next();

String inviteid = Util.null2String(rs.getString("careerinviteid"));
String jobtitle = Util.null2String(rs.getString("jobtitle"));
String ischeck = Util.null2String(rs.getString("ischeck"));
String ishire = Util.null2String(rs.getString("ishire"));

String firstname = Util.toScreen(rs.getString("firstname"),7) ;			/*名*/
String lastname = Util.toScreen(rs.getString("lastname"),7) ;			/*姓*/
String titleid= Util.toScreen(rs.getString("titleid"),7) ;				/*称呼*/
String sex = Util.toScreen(rs.getString("sex"),7) ;

String birthday = Util.toScreen(rs.getString("birthday"),7) ;			/*生日*/
String nationality = Util.toScreen(rs.getString("nationality"),7) ;		/*国籍*/
String defaultlanguage = Util.toScreen(rs.getString("defaultlanguage"),7) ;	/*口语语言*/
String maritalstatus = Util.toScreen(rs.getString("maritalstatus"),7) ;

String marrydate = Util.toScreen(rs.getString("marrydate"),7) ;			/*结婚日期*/
String email = Util.toScreen(rs.getString("email"),7) ;				/*电邮*/
String homeaddress = Util.toScreen(rs.getString("homeaddress"),7) ;				/*家庭地址*/
String homepostcode = Util.toScreen(rs.getString("homepostcode"),7) ;/*家庭邮编*/

String homephone = Util.toScreen(rs.getString("homephone"),7) ;				/*家庭电话*/
String certificatecategory = Util.toScreen(rs.getString("certificatecategory"),7) ;/**/
String certificatenum = Util.toScreen(rs.getString("certificatenum"),7) ;			/*证件号码*/
String nativeplace = Util.toScreen(rs.getString("nativeplace"),7) ;
/*籍贯*/
String educationlevel = Util.toScreen(rs.getString("educationlevel"),7) ;			/*学历*/
String bememberdate = Util.toScreen(rs.getString("bememberdate"),7) ;				/*入团日期*/
String bepartydate = Util.toScreen(rs.getString("bepartydate"),7) ;				/*入党日期*/
String bedemocracydate = Util.toScreen(rs.getString("bedemocracydate"),7) ;		/*民主日期*/
String regresidentplace = Util.toScreen(rs.getString("regresidentplace"),7) ;		/*户口所在地*/
String healthinfo = Util.toScreen(rs.getString("healthinfo"),7) ;					/*健康状况*/
String residentplace = Util.toScreen(rs.getString("residentplace"),7) ;			/*现居住地*/
String policy = Util.toScreen(rs.getString("policy"),7) ;							/*政治面貌*/
String degree = Util.toScreen(rs.getString("degree"),7) ;							/*学位*/
String height = Util.toScreen(rs.getString("height"),7) ;							/*身高*/
String homepage = Util.toScreen(rs.getString("homepage"),7) ;						/*个人主页*/
String train = Util.toScreen(rs.getString("train"),7) ;							/*培训及持有证书*/
String numberid = Util.toScreen(rs.getString("numberid"),7) ;							/*培训及持有证书*/

rs.executeProc("HrmCareerApplyOtherInfo_SByApp",applyid);
rs.next();

String contactor = Util.toScreen(rs.getString("contactor"),7) ;							/*联系人*/
String category = Util.toScreen(rs.getString("category"),7) ;						/*应聘者类别*/
String major = Util.toScreen(rs.getString("major"),7) ;						/*专业*/
String salarynow = Util.toScreen(rs.getString("salarynow"),7) ;				/*当前年薪*/
String worktime = Util.toScreen(rs.getString("worktime"),7) ;				/*工作年限*/
String salaryneed = Util.toScreen(rs.getString("salaryneed"),7) ;				/*年薪低限*/
String reason = Util.toScreen(rs.getString("reason"),7) ;							/**/
String otherrequest = Util.toScreen(rs.getString("otherrequest"),7) ;		/**/
String selfcomment = Util.toScreen(rs.getString("selfcomment"),7) ;		/*自荐书*/
String currencyid = Util.toScreen(rs.getString("currencyid"),7) ;				/*币种*/

String informman = "" ;
String principalid = "" ;
String planid = "" ;
if( !inviteid.equals("")) {
    rs.executeSql("select a.* from HrmCareerPlan a , HrmCareerInvite b where a.id = b.careerplanid and b.id = "+inviteid);
    while(rs.next()){
      principalid = Util.null2String(rs.getString("principalid"));
      informman = Util.null2String(rs.getString("informmanid"));
      planid = Util.null2String(rs.getString("id"));
    }
}



String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(93,7)+" : "+SystemEnv.getHtmlLabelName(773,7);
String needfav ="1";
String needhelp ="";
%>
<BODY>

<FORM name=resource id=resource method=post action="HrmCareerApplyOperation.jsp">
	<input class=inputstyle type=hidden name=operation value="saveApply">
	<input class=inputstyle type=hidden name=applyid value="<%=applyid%>">

  <DIV>
<BUTTON class=btn id=Edit accessKey=S onclick="doSave()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86, 7)%></BUTTON>
<BUTTON class=btn id=Delete accessKey=P onclick="location='HrmCareerApplyPerView.jsp?id=<%=applyid%>'"><U>P</U>-<%=SystemEnv.getHtmlLabelName(15687, 7)%></BUTTON>
<BUTTON class=btn id=Delete accessKey=W onclick="location='HrmCareerApplyWorkView.jsp?id=<%=applyid%>'"><U>W</U>-<%=SystemEnv.getHtmlLabelName(15688, 7)%></BUTTON>
</DIV>
  <TABLE class=ViewForm>
    <COLGROUP>
    <COL width="49%">
    <COL width=10>
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
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(1361,7)%></TH>
          </TR>
          <TR class=spacing>
            <TD class=Line1 colSpan=2></TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(413,7)%></TD>
            <TD class=Field>
              <INPUT class=inputstyle maxLength=30 size=30 name="lastname" onchange='checkinput("lastname","lastnamespan")' value="<%=lastname%>">
              <SPAN id=lastnamespan>
                <%if(lastname.equals("")){%>
                <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
                <%}%>
              </SPAN>
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(416,7)%></TD>
            <TD class=Field>
              <select class=inputstyle id=sex name=sex>
                <option value=0 <%if(sex.equals("0") ){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(417,7)%></option>
                <option value=1 <%if(sex.equals("1") ){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(418,7)%></option>
              </select>
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(15675,7)%></td>
            <td class=Field>
              <select class=inputstyle id=category name=category>
                <option value=""></option>
                <option value="0" <%if(category.equals("0") ){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(134,7)%></option>
                <option value="1" <%if(category.equals("1") ){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(1830,7)%></option>
                <option value="2" <%if(category.equals("2") ){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1831,7)%></option>
                <option value="3" <%if(category.equals("3") ){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1832,7)%></option>
              </select>
            </td>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR>
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
          <TR class=Title>
            <TH colSpan=4>&nbsp;</TH>
          </TR>
          <TR class=spacing>
            <TD class=Line1 colSpan=3></TD>
          </TR>
<!--
          <TR>
            <TD>相关招聘信息发布时间</TD>
            <TD class=Field>
-->

          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(15671,7)%></TD>
            <TD class=Field>
<%
    String careername = "" ;
    if(inviteid.equals("")){
      careername = jobtitle ;
      if( Util.getIntValue(careername) != -1 ) careername = JobTitlesComInfo.getJobTitlesname(jobtitle) ;
%>
	      <BUTTON class=Browser id=Selectcareerinvite onclick="onShowCareerInvite()"></BUTTON>
              <SPAN id=jobtitlespan><%=careername%><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
<%  }else{
       careername = jobtitle ;
       if( Util.getIntValue(careername) != -1 ) careername = JobTitlesComInfo.getJobTitlesname(jobtitle) ;
%>
               <%=careername%>
<%}%>
              <input class=inputstyle id=jobtitle type=hidden name=jobtitle value="<%=jobtitle%>" onchange='checkinput("jobtitle","jobtitlespan")'>
              <input class=inputstyle id=careerinvite type=hidden name=careerinvite value="<%=inviteid%>" onchange='checkinput("careerinvite","careerinvitespan")'>
            </TD>
          </TR>
       <TR><TD class=Line colSpan=2></TD></TR>
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
           <TH colspan=4> <%=SystemEnv.getHtmlLabelName(1842,7)%></TH>
         </TR>
         <TR class=Spacing>
            <TD class=Line1  colspan=4></TD>
         </TR>
	  <tr>
            <td  > <%=SystemEnv.getHtmlLabelName(1843,7)%></td>
            <td valign=top class=Field >
              <input class=inputstyle maxlength=30  size=30 name=salarynow  onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("salarynow")' value="<%=salarynow%>">
	    </td>
            <td><%=SystemEnv.getHtmlLabelName(1844,7)%></td>
            <td valign=top class=Field >
               <input class=inputstyle maxlength=30  size=30 name=worktime  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("worktime");checkinput("worktime","worktimeimage")' value="<%=worktime%>" >
            <SPAN id=worktimeimage>
                <%if(worktime.equals("")){%>
                <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
                <%}%>
            </SPAN>
	    </td>
          </tr>
          <TR><TD class=Line colSpan=6></TD></TR>
          <tr>
            <td  > <%=SystemEnv.getHtmlLabelName(1845,7)%></td>
            <td valign=top class=Field >
              <input class=inputstyle maxlength=30  size=30 name=salaryneed  onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("salaryneed");checkinput("salaryneed","salaryneedimage")' value="<%=salaryneed%>">
	      <SPAN id=salaryneedimage>
             <%if(salaryneed.equals("")){%>
                <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
                <%}%>
          </SPAN>
	    </td>
            <td><%=SystemEnv.getHtmlLabelName(406,7)%></td>
            <td class=Field>
	       <brow:browser viewType="0" name="currencyid" 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' 
					completeUrl=""   width="240px" zDialog="true"  browserValue='<%=currencyid %>'  
					browserSpanValue='<%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),7)%>'>
					browserSpanValue="">
			</brow:browser>
            </td>
          </tr>
          <TR><TD class=Line colSpan=6></TD></TR>
          <tr>
            <Td  > <%=SystemEnv.getHtmlLabelName(1846,7)%></Td>
            <TD vAlign=top colspan="3" class=Field >
              <TEXTAREA class=inputstyle style="WIDTH: 100%" name=reason rows=3><%=Util.fromHtmlToEdit(reason)%></TEXTAREA>
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR>
          <TR class=Section>
            <Td  > <%=SystemEnv.getHtmlLabelName(1847,7)%></Td>
            <TD vAlign=top colspan="3" class=Field >
              <TEXTAREA class=inputstyle style="WIDTH: 100%" name=otherrequest rows=3><%=Util.fromHtmlToEdit(otherrequest)%></TEXTAREA>
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR>
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
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(569,7)%></TH>
          </TR>
          <TR class=Spacing>
            <TD class=Line1 colSpan=2></TD>
          </TR>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(572,7)%></td>
            <td class=Field>
              <input class=inputstyle maxlength=30 size=30 name=contactor onchange='checkinput("contactor","contactorimage")'  value="<%=contactor%>">
	          <SPAN id=contactorimage>
              <%if(contactor.equals("")){%>
              <IMG src='/images/BacoError_wev8.gif' align=absMiddle>
              <%}%>
              </SPAN>
            </td>
          </tr>
          <TR><TD class=Line colSpan=6></TD></TR>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(479,7)%></td>
            <td class=Field>
              <input class=inputstyle maxlength=8 size=30 name=homepostcode onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("homepostcode");checkinput("homepostcode","homepostcodeimage")' value="<%=homepostcode%>">
	          <SPAN id=homepostcodeimage>
              <%if(homepostcode.equals("")){%>
                <IMG src='/images/BacoError_wev8.gif' align=absMiddle>
              <%}%>
              </SPAN>
            </td>
          </tr>
          <TR><TD class=Line colSpan=6></TD></TR>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(110,7)%></td>
            <td class=Field>
              <input class=inputstyle maxlength=100 size=30  onchange='checkinput("homeaddress","homeaddressimage")' name=homeaddress value="<%=homeaddress%>">
	      <SPAN id=homeaddressimage>
            <%if(homeaddress.equals("")){%>
              <IMG src='/images/BacoError_wev8.gif' align=absMiddle>
              <%}%>
          </SPAN>
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR>
          </TBODY>
        </TABLE>
      <TD vAlign=top>
        <TABLE width="100%">
          <COLGROUP> <COL width=30%> <COL width=70%> <TBODY>
          <TR class=Title>
            <TH colSpan=4>&nbsp;</TH>
          </TR>
          <TR class=Spacing>
            <TD class=Line1 colSpan=3></TD>
          </TR>
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(477,7)%></td>
            <td class=Field>
              <input class=inputstyle maxlength=128 size=30  onchange='checkinput_email("email","emailimage")'  name=email value="<%=email%>">
	      <SPAN id=emailimage>
              <%if(email.equals("")){%>
              <IMG src='/images/BacoError_wev8.gif' align=absMiddle>
              <%}%>
          </SPAN>
            </td>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR>
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(421,7)%></td>
            <td class=Field>
              <input class=inputstyle maxlength=15 size=30  onchange='checkinput("homephone","homephoneimage")'  name=homephone value="<%=homephone%>">
	          <SPAN id=homephoneimage>
               <%if(homephone.equals("")){%>
              <IMG src='/images/BacoError_wev8.gif' align=absMiddle>
              <%}%>
              </SPAN>
            </td>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR>
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(1848,7)%></td>
            <td class=Field>
              <input class=inputstyle maxlength=100 size=30 name=homepage value="<%=homepage%>">
            </td>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR>
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
	    <td ><%=SystemEnv.getHtmlLabelName(1849,7)%></td>
            <td  class=Field >
              <textarea class=inputstyle style="WIDTH: 100%" name=selfcomment rows=6><%=Util.fromHtmlToEdit(selfcomment)%></textarea>
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR>
        </tbody>
      </table>
    </td>
  </tr>
 </FORM>
</td>
</tr>
</TABLE>


<script language=vbs>
sub onShowCareerInvite()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/career/CareerInviteBrowser.jsp?")
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
<SCRIPT language="javascript">
function OnPass(){
    location="HrmInterviewResult.jsp?id=<%=applyid%>&result=1&planid=<%=planid%>";
}
function OnHire(){
    document.resource.action = "HrmCareerApplyToResource.jsp?id=<%=applyid%>&planid=<%=planid%>";
 	document.resource.submit();
}
function onDelete(){
		location="HrmInterviewResult.jsp?id=<%=applyid%>&result=0&planid=<%=planid%>";
}

function OnBack(){
    location="HrmInterviewResult.jsp?id=<%=applyid%>&result=2&planid=<%=planid%>";
}

function OnInterview(){
    location="HrmInterviewPlan.jsp?id=<%=applyid%>&planid=<%=planid%>";
}

function OnAssess(){
    location="HrmInterviewAssess.jsp?id=<%=applyid%>&planid=<%=planid%>";
}

function doCancel(){
    location="HrmCareerApplyEdit.jsp?applyid=<%=applyid%>";
}

function doSave() {
   if(check_form(document.resource,'lastname,jobtitle,careerinvite,worktime,salaryneed,contactor,homepostcode,homeaddress,email,homephone')){
      document.resource.submit() ;
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
    if(tmpvalue==null){
        continue;
    }
	while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);

	if(tmpname!="" &&items.indexOf(tmpname+",")!=-1 && tmpvalue == ""){
		 alert("<%=SystemEnv.getHtmlLabelName(31122, 7)%>");
		 return false;
		}

	}
	return true;
}
</script>
</BODY>
</HTML>
