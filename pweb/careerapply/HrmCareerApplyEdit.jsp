
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.*" %>
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
String firstname = Util.null2String(rs.getString("firstname")) ;			/*名*/
String lastname = Util.null2String(rs.getString("lastname")) ;			/*姓*/
String titleid= Util.null2String(rs.getString("titleid")) ;				/*称呼*/
String sex = Util.null2String(rs.getString("sex")) ;
String birthday = Util.null2String(rs.getString("birthday")) ;			/*生日*/
String nationality = Util.null2String(rs.getString("nationality")) ;		/*国籍*/
String defaultlanguage = Util.null2String(rs.getString("defaultlanguage")) ;	/*口语语言*/
String maritalstatus = Util.null2String(rs.getString("maritalstatus")) ;
String marrydate = Util.null2String(rs.getString("marrydate")) ;			/*结婚日期*/
String email = Util.null2String(rs.getString("email")) ;				/*电邮*/
String homeaddress = Util.null2String(rs.getString("homeaddress")) ;				/*家庭地址*/
String homepostcode = Util.null2String(rs.getString("homepostcode")) ;				/*家庭邮编*/
String homephone = Util.null2String(rs.getString("homephone")) ;				/*家庭电话*/
String certificatecategory = Util.null2String(rs.getString("certificatecategory")) ;/**/
String certificatenum = Util.null2String(rs.getString("certificatenum")) ;			/*证件号码*/
String nativeplace = Util.null2String(rs.getString("nativeplace")) ;				/*籍贯*/
String educationlevel = Util.null2String(rs.getString("educationlevel")) ;			/*学历*/
String bememberdate = Util.null2String(rs.getString("bememberdate")) ;				/*入团日期*/
String bepartydate = Util.null2String(rs.getString("bepartydate")) ;				/*入党日期*/
String bedemocracydate = Util.null2String(rs.getString("bedemocracydate")) ;		/*民主日期*/
String regresidentplace = Util.null2String(rs.getString("regresidentplace")) ;		/*户口所在地*/
String healthinfo = Util.null2String(rs.getString("healthinfo")) ;					/*健康状况*/
String residentplace = Util.null2String(rs.getString("residentplace")) ;			/*现居住地*/
String policy = Util.null2String(rs.getString("policy")) ;							/*政治面貌*/
String degree = Util.null2String(rs.getString("degree")) ;							/*学位*/
String height = Util.null2String(rs.getString("height")) ;							/*身高*/
String homepage = Util.null2String(rs.getString("homepage")) ;						/*个人主页*/
String train = Util.null2String(rs.getString("train")) ;							/*培训及持有证书*/
String numberid = Util.null2String(rs.getString("numberid")) ;							/*培训及持有证书*/

rs.executeProc("HrmCareerApplyOtherInfo_SByApp",applyid);
rs.next();

String contactor = Util.null2String(rs.getString("contactor")) ;							/*联系人*/
String category = Util.null2String(rs.getString("category")) ;						/*应聘者类别*/
String major = Util.null2String(rs.getString("major")) ;						/*专业*/							
String salarynow = Util.null2String(rs.getString("salarynow")) ;				/*当前年薪*/
String worktime = Util.null2String(rs.getString("worktime")) ;				/*工作年限*/
String salaryneed = Util.null2String(rs.getString("salaryneed")) ;				/*年薪低限*/				
String reason = Util.null2String(rs.getString("reason")) ;							/**/
String otherrequest = Util.null2String(rs.getString("otherrequest")) ;		/**/
String selfcomment = Util.null2String(rs.getString("selfcomment")) ;		/*自荐书*/
String currencyid = Util.null2String(rs.getString("currencyid")) ;				/*币种*/

%>
<BODY>
<DIV class=HdrProps></DIV>
<!--<FORM name=resource id=resource method=post>-->
	<input type=hidden name=operation>
	<input type=hidden name=applyid value="<%=applyid%>">

<DIV>
<BUTTON class=btn id=Edit accessKey=E onclick="location='HrmCareerApplyEditDo.jsp?applyid=<%=applyid%>'"><U>E</U>-<%=SystemEnv.getHtmlLabelName(93, 7)%></BUTTON>
<BUTTON class=btn id=Delete accessKey=P onclick="location='HrmCareerApplyPerView.jsp?id=<%=applyid%>'"><U>P</U>-<%=SystemEnv.getHtmlLabelName(15687, 7)%></BUTTON>
<BUTTON class=btn id=Delete accessKey=W onclick="location='HrmCareerApplyWorkView.jsp?id=<%=applyid%>'"><U>W</U>-<%=SystemEnv.getHtmlLabelName(15688, 7)%></BUTTON>
</DIV>

<TABLE class=Form>
    <COLGROUP> <COL width="49%"> <COL width=10> <COL width="49%"> <TBODY> 
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> <COL width=30%> <COL width=70%><TBODY> 
          <TR class=Section> 
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(1361, 7)%></TH>
          </TR>
          <TR class=Separator> 
            <TD class=Sep1 colSpan=2></TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(413, 7)%></TD>
            <TD class=Field> 
              <%=lastname%>
            </TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(416, 7)%></TD>
            <TD class=Field> 
              <% if(sex.equals("0")) {%><%=SystemEnv.getHtmlLabelName(417,7)%><%}%>
              <% if(sex.equals("1")) {%><%=SystemEnv.getHtmlLabelName(418,7)%><%}%>
              <% if(sex.equals("2")) {%><%=SystemEnv.getHtmlLabelName(463,7)%><%}%>
            </TD>
          </TR>
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(15675, 7)%></td>
            <td class=Field> 
              <% if(category.equals("0")) {%><%=SystemEnv.getHtmlLabelName(134,7)%><%}%>
              <% if(category.equals("1")) {%><%=SystemEnv.getHtmlLabelName(1830,7)%><%}%>
              <% if(category.equals("2")) {%><%=SystemEnv.getHtmlLabelName(1831,7)%><%}%>
              <% if(category.equals("3")) {%><%=SystemEnv.getHtmlLabelName(1832,7)%><%}%>
            </td>
          </TR>     
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
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15692, 7)%></TD>
            <TD class=Field>              
                <%=CareerInviteComInfo.getCareerInvitedate(inviteid)%>              
            </TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15671, 7)%></TD>
            <TD class=Field>                             
               <%=JobTitlesComInfo.getJobTitlesname(jobtitle)%>              
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
      <col width="35%"> 
      <col width="15%"> 
      <col width="35%">
    <tbody> 
    <TR class=Section> 
      <TH colspan=4> <%=SystemEnv.getHtmlLabelName(1842, 7)%></TH>
    </TR>
    <TR class=Separator> 
      <TD class=sep2  colspan=4></TD>
    </TR>
    <tr> 
      <td> <%=SystemEnv.getHtmlLabelName(1843, 7)%></td>
      <td valign=top class=Field > 
        <%=salarynow%>
      </td>
      <td><%=SystemEnv.getHtmlLabelName(20398, 7)%>
      </td>
      <td valign=top class=Field >   
        <%=worktime%>
      </td>
    </tr>
    <tr> 
      <td  > <%=SystemEnv.getHtmlLabelName(15673, 7)%></td>
      <td valign=top class=Field > 
        <%=salaryneed%>
      </td>
      <td><%=SystemEnv.getHtmlLabelName(406, 7)%></td>
      <td class=Field>
	<%=Util.null2String(CurrencyComInfo.getCurrencyname(currencyid))%>
      </td>
    </tr>
    <tr> 
      <Td  > <%=SystemEnv.getHtmlLabelName(1846, 7)%></Td>
      <TD vAlign=top colspan="3" class=Field >  
        <%=reason%>
      </TD>
    </TR>
    <TR class=Section> 
      <Td  > <%=SystemEnv.getHtmlLabelNames("375,18201",7) %></Td>
      <TD vAlign=top colspan="3" class=Field > 
        <%=otherrequest%>
      </TD>
    </TR>
    </tbody> 
  </table>
</td>
</tr>    

 
	   <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> <COL width=30%> <COL width=70%> <TBODY> 
          <TR class=Section> 
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(569,7)%></TH>
          </TR>
          <TR class=Separator> 
            <TD class=Sep3 colSpan=2></TD>
          </TR>
        <tr> 
            <td><%=SystemEnv.getHtmlLabelName(572,7)%></td>
            <td class=Field>   <%=contactor%>
             </td>
          </tr>
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(479,7)%></td>
            <td class=Field> <%=homepostcode%>
              </td>
          </tr>
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(110,7)%></td>
            <td class=Field><%=homeaddress%> 
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
            <td><%=SystemEnv.getHtmlLabelName(477,7)%></td>
            <td class=Field>
			 <%=email%>
              </td>
          </TR>
          <TR> 
            <td><%=SystemEnv.getHtmlLabelName(421,7)%></td>
            <td class=Field>
			<%=homephone%> 
               </td>
          </TR>
          <TR> 
            <td><%=SystemEnv.getHtmlLabelName(1848,7)%></td>
            <td class=Field> <%=homepage%>
             </td>
          </TR>

          </TBODY>
        </TABLE>
      </TD>
    </TR>
    <TR>
        <TD colspan="2"><%=SystemEnv.getHtmlLabelName(1849,7)%></TD>

      </TR>
      <TR><TD class=Line colSpan=6></TD></TR>
      <TR>
        <TD colspan = "4" class="Field"><%=selfcomment%></TD>
      </TR>
 </TABLE>
  <!--</FORM>-->
  </BODY>
<SCRIPT language="javascript">
function OnPass(){
    location="HrmInterviewResult.jsp?id=<%=applyid%>&result=1";
}
function OnHire(){
    document.resource.action = "HrmCareerApplyToResource.jsp?id=<%=applyid%>";
 	document.resource.submit();
}
function onDelete(){
		location="HrmInterviewResult.jsp?id=<%=applyid%>&result=0";
}

function OnBack(){
    location="HrmInterviewResult.jsp?id=<%=applyid%>&result=2";
}

function OnInterview(){
    location="HrmInterviewPlan.jsp?id=<%=applyid%>";
}

function OnAssess(){
    location="HrmInterviewAssess.jsp?id=<%=applyid%>";
}
</script>
</HTML>
