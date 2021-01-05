
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CareerInviteComInfo" class="weaver.hrm.career.CareerInviteComInfo" scope="page"/>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="ContacterTitleComInfo" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="CareerApplyComInfo" class="weaver.hrm.career.HrmCareerApplyComInfo" scope="page"/>
<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript">
function imgSet(obj) {
	var imgHeight = obj.height;
	if(imgHeight>=250)obj.height = 250;
}
</script>
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
int picture = rs.getInt("picture");
String pictureshowname = "";
if(picture>0){
    rs1.executeSql("select imagefilename from ImageFile where imagefileid="+picture);
    if(rs1.next()){
        pictureshowname=rs1.getString("imagefilename");
    }
}

String firstname = Util.toScreen(rs.getString("firstname"),user.getLanguage()) ;			/*名*/
String lastname = Util.toScreen(rs.getString("lastname"),user.getLanguage()) ;			/*姓*/
String titleid= Util.toScreen(rs.getString("titleid"),user.getLanguage()) ;				/*称呼*/
String sex = Util.toScreen(rs.getString("sex"),user.getLanguage()) ;

String birthday = Util.toScreen(rs.getString("birthday"),user.getLanguage()) ;			/*生日*/
String nationality = Util.toScreen(rs.getString("nationality"),user.getLanguage()) ;		/*国籍*/
String defaultlanguage = Util.toScreen(rs.getString("defaultlanguage"),user.getLanguage()) ;	/*口语语言*/
String maritalstatus = Util.toScreen(rs.getString("maritalstatus"),user.getLanguage()) ;

String marrydate = Util.toScreen(rs.getString("marrydate"),user.getLanguage()) ;			/*结婚日期*/
String email = Util.toScreen(rs.getString("email"),user.getLanguage()) ;				/*电邮*/
String homeaddress = Util.toScreen(rs.getString("homeaddress"),user.getLanguage()) ;				/*家庭地址*/
String homepostcode = Util.toScreen(rs.getString("homepostcode"),user.getLanguage()) ;/*家庭邮编*/

String homephone = Util.toScreen(rs.getString("homephone"),user.getLanguage()) ;				/*家庭电话*/
String certificatecategory = Util.toScreen(rs.getString("certificatecategory"),user.getLanguage()) ;/**/
String certificatenum = Util.toScreen(rs.getString("certificatenum"),user.getLanguage()) ;			/*证件号码*/
String nativeplace = Util.toScreen(rs.getString("nativeplace"),user.getLanguage()) ;
/*籍贯*/
String educationlevel = Util.toScreen(rs.getString("educationlevel"),user.getLanguage()) ;			/*学历*/
String bememberdate = Util.toScreen(rs.getString("bememberdate"),user.getLanguage()) ;				/*入团日期*/
String bepartydate = Util.toScreen(rs.getString("bepartydate"),user.getLanguage()) ;				/*入党日期*/
String bedemocracydate = Util.toScreen(rs.getString("bedemocracydate"),user.getLanguage()) ;		/*民主日期*/
String regresidentplace = Util.toScreen(rs.getString("regresidentplace"),user.getLanguage()) ;		/*户口所在地*/
String healthinfo = Util.toScreen(rs.getString("healthinfo"),user.getLanguage()) ;					/*健康状况*/
String residentplace = Util.toScreen(rs.getString("residentplace"),user.getLanguage()) ;			/*现居住地*/
String policy = Util.toScreen(rs.getString("policy"),user.getLanguage()) ;							/*政治面貌*/
String degree = Util.toScreen(rs.getString("degree"),user.getLanguage()) ;							/*学位*/
String height = Util.toScreen(rs.getString("height"),user.getLanguage()) ;							/*身高*/
String homepage = Util.toScreen(rs.getString("homepage"),user.getLanguage()) ;						/*个人主页*/
String train = Util.toScreen(rs.getString("train"),user.getLanguage()) ;							/*培训及持有证书*/
String numberid = Util.toScreen(rs.getString("numberid"),user.getLanguage()) ;							/*培训及持有证书*/

rs.executeProc("HrmCareerApplyOtherInfo_SByApp",applyid);
rs.next();

String contactor = Util.toScreen(rs.getString("contactor"),user.getLanguage()) ;							/*联系人*/
String category = Util.toScreen(rs.getString("category"),user.getLanguage()) ;						/*应聘者类别*/
String major = Util.toScreen(rs.getString("major"),user.getLanguage()) ;						/*专业*/
//String salarynow = Util.toScreen(String.valueOf(rs.getFloat("salarynow")),user.getLanguage()) ;/*当前年薪*/	
String salarynow = Util.toScreen(rs.getString("salarynow"),user.getLanguage()) ;	
String worktime = Util.toScreen(rs.getString("worktime"),user.getLanguage()) ;				/*工作年限*/
//String salaryneed = Util.toScreen(String.valueOf(rs.getFloat("salaryneed")),user.getLanguage()) ;	/*年薪低限*/
String salaryneed = Util.toScreen(rs.getString("salaryneed"),user.getLanguage()) ;		
String reason = Util.toScreen(rs.getString("reason"),user.getLanguage()) ;							/**/
String otherrequest = Util.toScreen(rs.getString("otherrequest"),user.getLanguage()) ;		/**/
String selfcomment = Util.toScreen(rs.getString("selfcomment"),user.getLanguage()) ;		/*自荐书*/
String currencyid = Util.toScreen(rs.getString("currencyid"),user.getLanguage()) ;				/*币种*/

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

boolean isInformer = (Util.getIntValue(informman)==user.getUID());
boolean isPrincipal = (Util.getIntValue(principalid)==user.getUID());
boolean isAssessor = CareerApplyComInfo.isAssessor(applyid,user.getUID());
boolean isTester = CareerApplyComInfo.isTester(applyid,user.getUID());

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(89,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(773,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+ SystemEnv.getHtmlLabelNames("257,22967",user.getLanguage()) +",HrmCareerApplyPrint.jsp?applyid="+applyid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(HrmUserVarify.checkUserRight("HrmCareerApplyEdit:Edit",user)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:doEdit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(15687,user.getLanguage())+",/hrm/career/HrmCareerApplyPerView.jsp?id="+applyid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15688,user.getLanguage())+",/hrm/career/HrmCareerApplyWorkView.jsp?id="+applyid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(isInformer) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(6103,user.getLanguage())+",javascript:OnInterview(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmCareerApply:Hire",user) || isPrincipal ) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(1853,user.getLanguage())+",javascript:OnHire(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmCareerApply:Hire",user) || isTester || isPrincipal ){
RCMenu += "{"+SystemEnv.getHtmlLabelName(119,user.getLanguage())+",/hrm/career/HrmShare.jsp?applyid="+applyid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(isTester){
RCMenu += "{"+SystemEnv.getHtmlLabelName(15376,user.getLanguage())+",javascript:OnPass(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15689,user.getLanguage())+",javascript:OnBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15690,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(15691,user.getLanguage())+",javascript:sendmail(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(isAssessor){
RCMenu += "{"+SystemEnv.getHtmlLabelName(6102,user.getLanguage())+",/hrm/career/HrmInterviewAssess.jsp?id="+applyid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
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
<FORM name=resource id=resource method=post>
	<input class=inputstyle type=hidden name=operation>
	<input class=inputstyle type=hidden name=applyid value="<%=applyid%>">
<TABLE class=viewForm>
    <COLGROUP>
    <COL width="*">
    <COL width="145">
    <TBODY>
    <TR>
      <TD vAlign=top>
        <TABLE width="100%">
          <COLGROUP> <COL width=30%> <COL width=70%><TBODY>
          <TR class=title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing style="height:2px">
            <TD class=line1 colSpan=2></TD>
          </TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
            <TD class=Field>
              <%=lastname%>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=6></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></TD>
            <TD class=Field>
              <% if(sex.equals("0")) {%><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%><%}%>
              <% if(sex.equals("1")) {%><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%><%}%>
              <% if(sex.equals("2")) {%><%=SystemEnv.getHtmlLabelName(463,user.getLanguage())%><%}%>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=6></TD></TR>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(15675,user.getLanguage())%></td>
            <td class=Field>
              <% if(category.equals("0")) {%><%=SystemEnv.getHtmlLabelName(134,user.getLanguage())%><%}%>
              <% if(category.equals("1")) {%><%=SystemEnv.getHtmlLabelName(1830,user.getLanguage())%><%}%>
              <% if(category.equals("2")) {%><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%><%}%>
              <% if(category.equals("3")) {%><%=SystemEnv.getHtmlLabelName(1832,user.getLanguage())%><%}%>
            </td>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(15692,user.getLanguage())%></TD>
            <TD class=Field>
                <%=CareerInviteComInfo.getCareerInvitedate(inviteid)%>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(15671,user.getLanguage())%></TD>
            <TD class=Field>
               <%=JobTitlesComInfo.getJobTitlesname(jobtitle)%>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          </TBODY>
        </TABLE>
    	</TD>
    	
    	<TD vAlign=top>
        <TABLE width="100%">
          <COLGROUP>
          <COL width=30%>
          <COL width=70%>
          <TBODY>
          <TR class=title>
            <TH colSpan=2>&nbsp;</TH>
          </TR>
          <TR class=spacing style="height:2px">
            <TD class=line1 colSpan=2></TD>
          </TR>
	       <TR>
	          <%if(picture>0){%>
	          <TD class=Field colspan="2" align="center">
	          <img width="145" src="/weaver/weaver.file.FileDownload?fileid=<%=picture%>&download=1" onload="imgSet(this)">
	          </TD>
	          <%}%>
	       </TR>
	       <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          </TBODY>
        </TABLE>
      </TD>
    </TR>
  </TBODY>
</TABLE>
<TABLE class=viewForm>
    <COLGROUP>
    <COL width="49%">
    <COL width="49%">
    <TBODY>
<TR class=title>
  <TD vAlign=top colspan=2 >
  <table class=viewForm >
    <colgroup>
      <col width="15%">
      <col width="35%">
      <col width="15%">
      <col width="35%">
    <tbody>
    <TR class=title>
      <TH colspan=4> <%=SystemEnv.getHtmlLabelName(1842,user.getLanguage())%></TH>
    </TR>
    <TR class=spacing style="height:2px">
      <TD class=line1  colspan=4></TD>
    </TR>
    <tr>
      <td> <%=SystemEnv.getHtmlLabelName(1843,user.getLanguage())%></td>
      <td valign=top class=Field >
        <%=salarynow%>
      </td>
      <td><%=SystemEnv.getHtmlLabelName(1844,user.getLanguage())%>
      </td>
      <td valign=top class=Field >
        <%=worktime%>
      </td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=6></TD></TR>
    <tr>
      <td  > <%=SystemEnv.getHtmlLabelName(1845,user.getLanguage())%></td>
      <td valign=top class=Field >
        <%=salaryneed%>
      </td>
      <td><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></td>
      <td class=Field>
	<%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%>
      </td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=6></TD></TR>
    <tr>
      <Td  > <%=SystemEnv.getHtmlLabelName(1846,user.getLanguage())%></Td>
      <TD vAlign=top colspan="3" class=Field >
        <%=reason%>
      </TD>
    </TR>
    <TR class=title>
      <Td  > <%=SystemEnv.getHtmlLabelName(1847,user.getLanguage())%></Td>
      <TD vAlign=top colspan="3" class=Field >
        <%=otherrequest%>
      </TD>
    </TR>
    <TR style="height:1px"><TD class=Line colSpan=6></TD></TR>
    </tbody>
  </table>
</td>
</tr>

 <% if(HrmUserVarify.checkUserRight("HrmCareerApplyEdit:Edit",user)) {%>
	   <TR>
      <TD vAlign=top>
        <TABLE width="100%">
          <COLGROUP>
          <COL width=30%>
          <COL width=70%>
          <TBODY>
          <TR class=title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(569,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing style="height:2px">
            <TD class=line1 colSpan=2></TD>
          </TR>
        <tr>
            <td><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></td>
            <td class=Field>   <%=contactor%>
             </td>
          </tr>
     <TR style="height:1px"><TD class=Line colSpan=6></TD></TR>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(479,user.getLanguage())%></td>
            <td class=Field> <%=homepostcode%>
              </td>
          </tr>
     <TR style="height:1px"><TD class=Line colSpan=6></TD></TR>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></td>
            <td class=Field><%=homeaddress%>
             </td>
          </tr>
     <TR style="height:1px"><TD class=Line colSpan=6></TD></TR>
          </TBODY>
        </TABLE>
      </TD>
      <TD vAlign=top>
        <TABLE width="100%">
          <COLGROUP>
     <COL width=30%>
     <COL width=70%>
     <TBODY>
          <TR class=title>
            <TH colSpan=4>&nbsp;</TH>
          </TR>
          <TR class=spacing style="height:2px">
            <TD class=line1 colSpan=3></TD>
          </TR>

          <TR>
            <td><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></td>
            <td class=Field>
			 <%=email%>
              </td>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=6></TD></TR>
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></td>
            <td class=Field>
			<%=homephone%>
               </td>
          </TR>
     <TR style="height:1px"><TD class=Line colSpan=6></TD></TR>
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(1848,user.getLanguage())%></td>
            <td class=Field> <%=homepage%>
             </td>
          </TR>
     <TR style="height:1px"><TD class=Line colSpan=6></TD></TR>

          </TBODY>
        </TABLE>
      </TD>
    </TR>
    <TR>
        <TD colspan="2"><%=SystemEnv.getHtmlLabelName(1849,user.getLanguage())%></TD>

      </TR>
      <TR style="height:1px"><TD class=Line colSpan=6></TD></TR>
      <TR>
        <TD colspan = "4" class="Field"><%=selfcomment%></TD>
      </TR>
<% }%>

<TR class=title>
  <TD vAlign=top colspan=2 >
  <table class=liststyle cellspacing=1 >
    <colgroup>
      <col width="20%">
      <col width="20%">
      <col width="20%">
      <col width="10%">
      <col width="30%">
    <tbody>
    <TR class=header>
      <TH colspan=5> <%=SystemEnv.getHtmlLabelName(15693,user.getLanguage())%></TH>
    </TR>

    <tr class=header>
      <td> <%=SystemEnv.getHtmlLabelName(15694,user.getLanguage())%></td>
      <td >
        <%=SystemEnv.getHtmlLabelName(15695,user.getLanguage())%>
      </td>
      <td >
        <%=SystemEnv.getHtmlLabelName(15696,user.getLanguage())%>
      </td>
      <td>
        <%=SystemEnv.getHtmlLabelName(15697,user.getLanguage())%>
      </td>
      <td>
        <%=SystemEnv.getHtmlLabelName(15698,user.getLanguage())%>
      </td>
    </tr>


<%
  int line = 0;
  int isfirst = 0;
  String temp = "";
  String sql = "select * from HrmInterviewAssess where resourceid = "+applyid+" order by stepid ";
  rs.executeSql(sql);
  while(rs.next()){
    String stepid = Util.null2String(rs.getString("stepid"));
    if(!temp.equals(stepid)){
      temp = stepid;
      isfirst =1;
    }
    String assessor = Util.null2String(rs.getString("assessor"));
    String assessdate = Util.null2String(rs.getString("assessdate"));
    String remark = Util.null2String(rs.getString("remark"));
    int result = Util.getIntValue(rs.getString("result"));
    if(line%2 == 0){
      line++;
%>
    <tr class=datalight>
<%
    }else{
      line++;
%>
    <tr class=datadark>
<%
    }
%>
      <td>
<%
  if(isfirst == 1){
    isfirst = 0;
%>
        <%=CareerInviteComInfo.getInviteStepname(stepid)%>
<%
  }
%>
      </td>
      <td >
        <%=ResourceComInfo.getResourcename(assessor)%>
      </td>
      <td><%=assessdate %></td>
      <td>
	<%if(result==0){%><%=SystemEnv.getHtmlLabelName(15699,user.getLanguage())%><%}%>
        <%if(result==1){%><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%><%}%>
        <%if(result==2){%><%=SystemEnv.getHtmlLabelName(15700,user.getLanguage())%><%}%>
      </td>
      <td>
	<%=remark%>
      </td>
    </TR>
<%
  }
%>
    </tbody>
  </table>
</td>
</tr>
<TR class=title>
  <TD vAlign=top colspan=2 >
  <br>
  <table class=liststyle cellspacing=1 >
    <colgroup>
      <col width="20%">
      <col width="20%">
      <col width="20%">
      <col width="10%">
      <col width="30%">
    <tbody>
    <TR class=header>
      <TH colspan=5> <%=SystemEnv.getHtmlLabelName(15701,user.getLanguage())%></TH>
    </TR>
       <tr class=header>
      <td> <%=SystemEnv.getHtmlLabelName(15694,user.getLanguage())%></td>
      <td >
        <%=SystemEnv.getHtmlLabelName(15662,user.getLanguage())%>
      </td>
      <td >
        <%=SystemEnv.getHtmlLabelName(15702,user.getLanguage())%>
      </td>
      <td>
        <%=SystemEnv.getHtmlLabelName(15703,user.getLanguage())%>
      </td>
      <td>
        <%=SystemEnv.getHtmlLabelName(15698,user.getLanguage())%>
      </td>
    </tr>


<%
  int line2 = 0;
  sql = "select * from HrmInterviewResult where resourceid = "+applyid+" order by stepid ";
  rs.executeSql(sql);
  while(rs.next()){
    String stepid = Util.null2String(rs.getString("stepid"));
    String tester = Util.null2String(rs.getString("tester"));
    String testdate = Util.null2String(rs.getString("testdate"));
    String remark = Util.null2String(rs.getString("remark"));
    int result = Util.getIntValue(rs.getString("result"));
    if(line2%2 == 0){
      line2++;
%>
    <tr class=datalight>
<%
    }else{
      line2++;
%>
    <tr class=datadark>
<%
    }
%>
      <td>
        <%=CareerInviteComInfo.getInviteStepname(stepid)%>
      </td>
      <td >
        <%=ResourceComInfo.getResourcename(tester)%>
      </td>
      <td><%=testdate %></td>
      <td class=Field>
	<%if(result==0){%><%=SystemEnv.getHtmlLabelName(15690,user.getLanguage())%><%}%>
        <%if(result==1){%><%=SystemEnv.getHtmlLabelName(15376,user.getLanguage())%><%}%>
        <%if(result==2){%><%=SystemEnv.getHtmlLabelName(15704,user.getLanguage())%><%}%>
      </td>
      <td class=Field>
	<%=remark%>
      </td>
    </TR>
<%
  }
%>
    </tbody>
</table>
</td>
</tr>
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

function doEdit(){
    location="HrmCareerApplyEditDo.jsp?applyid=<%=applyid%>";
}

  function sendmail(){
    var tmpvalue = "<%=email%>";
    while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);
	if (tmpvalue=="" || tmpvalue.indexOf("@") <1 || tmpvalue.indexOf(".") <1 || tmpvalue.length <5) {
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83458,user.getLanguage())%>");
        return;
    }
    window.location = "/sendmail/HrmMailMerge.jsp?applyid=<%=applyid%>";
  }
</script>
</BODY>
</HTML>