<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="ContacterTitleComInfo" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>

<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String applyid=Util.null2String(request.getParameter("applyid"));


String careerid = "";
String firstname = "";			/*名*/
String lastname = "";			/*姓*/
String aliasname= "";				/*别名*/
String titleid= "";				/*称呼*/

String sex = "";
/*
性别:
0:男性
1:女性
2:未知
*/
String birthday = "";			/*生日*/
String nationality = "" ;		/*国籍*/
String defaultlanguage = "" ;	/*口语语言*/
String maritalstatus = "" ;
/*
婚姻状况:
0:未婚
1:已婚
2:离异
3:同居
*/
String marrydate = "";			/*结婚日期*/
String email ="";				/*电邮*/
String homeaddress = "";				/*家庭地址*/
String homepostcode ="" ;				/*家庭邮编*/
String homephone = "";				/*家庭电话*/

String certificatecategory = "";/**/
String certificatenum ="";			/*证件号码*/
String nativeplace ="";				/*籍贯*/
String educationlevel = "";			/*学历*/
/*
学历:
0:初中
1:高中
2:中技
3:中专
4:大专
5:本科
6:硕士
7:博士
8:其它
*/
String bememberdate ="";				/*入团日期*/
String bepartydate ="";				/*入党日期*/
String bedemocracydate ="" ;		/*民主日期*/
String regresidentplace = "";		/*户口所在地*/
String healthinfo = "" ;					/*健康状况*/
/*
健康状况:
0:优秀
1:良好
2:一般
3:较差
*/
String residentplace = "";			/*现居住地*/
String policy = "";							/*政治面貌*/
String degree ="" ;							/*学位*/
String height = "";							/*身高*/
String homepage = "" ;						/*个人主页*/
String train = "";							/*培训及持有证书*/
String numberid ="";
String contactor ="" ;							/*联系人*/
String category = "" ;						/*应聘者类别*/
String major ="";						/*专业*/							
String salarynow = "";				/*当前年薪*/
String worktime = "" ;				/*工作年限*/
String salaryneed = "" ;				/*年薪低限*/				
String reason = "" ;							/**/
String otherrequest = "" ;		/**/
String selfcomment ="" ;		/*自荐书*/
String currencyid = "";				/*币种*/

RecordSet.executeProc("HrmCareerApply_SelectById",applyid);
while(RecordSet.next()){
careerid = RecordSet.getString("careerid");
firstname =  RecordSet.getString("firstname") ;			/*名*/
lastname = RecordSet.getString("lastname") ;			/*姓*/
aliasname= RecordSet.getString("aliasname") ;				/*别名*/
titleid= RecordSet.getString("titleid") ;				/*称呼*/
sex = RecordSet.getString("sex") ;
/*
性别:
0:男性
1:女性
2:未知
*/
birthday = RecordSet.getString("birthday");			/*生日*/
nationality = RecordSet.getString("nationality");		/*国籍*/
defaultlanguage =  RecordSet.getString("defaultlanguage");	/*口语语言*/
maritalstatus =  RecordSet.getString("maritalstatus");
/*
婚姻状况:
0:未婚
1:已婚
2:离异
3:同居
*/
marrydate =RecordSet.getString("marrydate") ;			/*结婚日期*/
email =RecordSet.getString("email");				/*电邮*/
homeaddress =RecordSet.getString("homeaddress");				/*家庭地址*/
homepostcode =RecordSet.getString("homepostcode");				/*家庭邮编*/
homephone =RecordSet.getString("homephone") ;				/*家庭电话*/
certificatecategory = RecordSet.getString("certificatecategory") ;/**/
certificatenum = RecordSet.getString("certificatenum");			/*证件号码*/
nativeplace = RecordSet.getString("nativeplace") ;				/*籍贯*/
educationlevel = RecordSet.getString("educationlevel");			/*学历*/

bememberdate = RecordSet.getString("bememberdate") ;				/*入团日期*/
bepartydate = RecordSet.getString("bepartydate");				/*入党日期*/
bedemocracydate = RecordSet.getString("bedemocracydate");		/*民主日期*/
regresidentplace = RecordSet.getString("regresidentplace") ;		/*户口所在地*/
healthinfo = RecordSet.getString("healthinfo");					/*健康状况*/

residentplace = RecordSet.getString("residentplace");			/*现居住地*/
policy = RecordSet.getString("policy");							/*政治面貌*/
degree = RecordSet.getString("degree");							/*学位*/
height = RecordSet.getString("height");							/*身高*/
homepage =RecordSet.getString("homepage");						/*个人主页*/
train = RecordSet.getString("train");							/*培训及持有证书*/
numberid = Util.toScreen(RecordSet.getString("numberid"),user.getLanguage()) ;							
}

RecordSet.executeProc("HrmCareerApplyOtherInfo_SByApp",applyid);
if (RecordSet.next()){

contactor = Util.toScreen(RecordSet.getString("contactor"),user.getLanguage()) ;							/*联系人*/
category = Util.toScreen(RecordSet.getString("category"),user.getLanguage()) ;						/*应聘者类别*/
major = Util.toScreen(RecordSet.getString("major"),user.getLanguage()) ;						/*专业*/		
salarynow = Util.toScreen(RecordSet.getString("salarynow"),user.getLanguage()) ;				/*当前年薪*/
worktime = Util.toScreen(RecordSet.getString("worktime"),user.getLanguage()) ;				/*工作年限*/
 salaryneed = Util.toScreen(RecordSet.getString("salaryneed"),user.getLanguage()) ;				/*年薪低限*/				
reason = Util.toScreen(RecordSet.getString("reason"),user.getLanguage()) ;							/**/
otherrequest = Util.toScreen(RecordSet.getString("otherrequest"),user.getLanguage()) ;		/**/
selfcomment = Util.toScreen(RecordSet.getString("selfcomment"),user.getLanguage()) ;		/*自荐书*/
currencyid = Util.toScreen(RecordSet.getString("currencyid"),user.getLanguage()) ;				/*币种*/
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(773,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(365,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1402,user.getLanguage())+",javascript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(103,user.getLanguage())+",javascript:OnBack(),_self} " ;
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
<FORM name=resource id=resource method=post>
<input class=inputstyle type=hidden name=careerid value="<%=careerid%>">
  <TABLE class=ViewForm>
    <COLGROUP> <COL width="50%"> <COL width="50%"> <TBODY> 
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> <COL width=30%> <COL width=70%> <TBODY> 
          <TR class=Title> 
            <TH colSpan=2 ><%=SystemEnv.getHtmlLabelName(411,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=2></TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(460,user.getLanguage())%></TD>
            <TD class=Field> <%=firstname%>
              <input class=inputstyle type=hidden  name="firstname" value="<%=firstname%>">
			</TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(461,user.getLanguage())%></TD>
            <TD class=Field> <%=lastname%>
              <input class=inputstyle type=hidden  name="lastname"  value="<%=lastname%>">
              </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(462,user.getLanguage())%></TD>
            <TD class=Field> <%=Util.toScreen(ContacterTitleComInfo.getContacterTitlename(titleid),user.getLanguage())%> 
              <input class=inputstyle type=hidden name=titleid value="<%=titleid%>">
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></TD>
            <TD class=Field> 
                <% if(sex.equals("0")) {%><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%><%}%>
                 <% if(sex.equals("1")) {%><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%><%}%>
                <% if(sex.equals("2")) {%><%=SystemEnv.getHtmlLabelName(463,user.getLanguage())%><%}%>
				  <input class=inputstyle type=hidden  name="sex" value="<%=sex%>">
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(464,user.getLanguage())%></TD>
            <TD class=Field><%=birthday%>
              <input class=inputstyle type="hidden" name="birthday" value="<%=birthday%>">
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1826,user.getLanguage())%></td>
            <td class=Field><%=height%>
			  <input class=inputstyle type=hidden  name="height" value="<%=height%>"> 
             </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1827,user.getLanguage())%></td>
            <td class=Field> 
                <% if(healthinfo.equals("0")) {%><%=SystemEnv.getHtmlLabelName(824,user.getLanguage())%><%}%>
                 <% if(healthinfo.equals("1")) {%><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%><%}%>
                <% if(healthinfo.equals("2")) {%><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%><%}%>
                <% if(healthinfo.equals("3")) {%><%=SystemEnv.getHtmlLabelName(825,user.getLanguage())%><%}%>
 			<input class=inputstyle type=hidden  name="healthinfo" value="<%=healthinfo%>"> 
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(465,user.getLanguage())%></TD>
            <TD class=Field><%=Util.toScreen(CountryComInfo.getCountrydesc(nationality),user.getLanguage())%>
              <INPUT class=inputStyle id=nationality type=hidden name=nationality value="<%=nationality%>">
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
           <td><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(467,user.getLanguage())%></td>
            <td class=Field><%=Util.toScreen(LanguageComInfo.getLanguagename(defaultlanguage),user.getLanguage())%>
              <input class=inputStyle id=defaultlanguage type=hidden name=defaultlanguage value="<%=defaultlanguage%>">
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(469,user.getLanguage())%></TD>
            <TD class=Field> 
                <% if(maritalstatus.equals("0")) {%><%=SystemEnv.getHtmlLabelName(470,user.getLanguage())%><%}%>
                 <% if(maritalstatus.equals("1")) {%><%=SystemEnv.getHtmlLabelName(471,user.getLanguage())%><%}%>
                <% if(maritalstatus.equals("2")) {%><%=SystemEnv.getHtmlLabelName(472,user.getLanguage())%><%}%>
                <% if(maritalstatus.equals("3")) {%><%=SystemEnv.getHtmlLabelName(473,user.getLanguage())%><%}%>
                 <input class=inputstyle type="hidden" name="maritalstatus" value="<%=maritalstatus%>">
			</TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(474,user.getLanguage())%></td>
            <td class=Field><%=marrydate%>
              <input class=inputstyle type="hidden" name="marrydate" value="<%=marrydate%>">
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1828,user.getLanguage())%></td>
            <td class=Field><%=regresidentplace%>
              <input class=inputstyle type=hidden name=regresidentplace value="<%=regresidentplace%>">
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1829,user.getLanguage())%></td>
            <td class=Field><%=residentplace%>
              <input class=inputstyle type=hidden name=residentplace value="<%=residentplace%>">
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          </TBODY> 
        </TABLE>
      </TD>
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> <COL width=30%> <COL width=70%> <TBODY> 
          <TR class=Title> 
            <TH colSpan=2>&nbsp;</TH>
          </TR>
          <TR class=spacing> 
            <TD class=Sep1 colSpan=2></TD>
            <TR> 
            <td><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
            <TD class=Field><%=numberid%></TD>
           <input class=inputstyle type=hidden name=numberid value="<%=numberid%>">
            </tr>
            <TR><TD class=Line colSpan=2></TD></TR> 
       <TR> 
            <td><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></td>
            <td class=Field> 
                <% if(category.equals("0")) {%><%=SystemEnv.getHtmlLabelName(134,user.getLanguage())%><%}%>
                 <% if(category.equals("1")) {%><%=SystemEnv.getHtmlLabelName(1830,user.getLanguage())%><%}%>
                <% if(category.equals("2")) {%><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%><%}%>
                 <% if(category.equals("3")) {%><%=SystemEnv.getHtmlLabelName(1832,user.getLanguage())%><%}%>
	     <INPUT class=inputStyle id=category type=hidden name=category value="<%=category%>">			 
             </td>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
		  	<TR>
      <TD><%=SystemEnv.getHtmlLabelName(803,user.getLanguage())%></TD>
       <TD class=Field>
	   <%=major%>
       <INPUT class=inputStyle id=major type=hidden name=major value="<%=major%>">
       </TD>
    </TR>
    <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <td><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%></td>
            <td class=Field> 
            <% if(educationlevel.equals("0")) {%>
            <%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%> 
            <%}%>
            <% if(educationlevel.equals("1")) {%>
            <%=SystemEnv.getHtmlLabelName(819,user.getLanguage())%> 
            <%}%>
            <% if(educationlevel.equals("2")) {%>
            <%=SystemEnv.getHtmlLabelName(764,user.getLanguage())%> 
            <%}%>
            <% if(educationlevel.equals("12")) {%>
            <%=SystemEnv.getHtmlLabelName(2122,user.getLanguage())%> 
            <%}%>
            <% if(educationlevel.equals("13")) {%>
            <%=SystemEnv.getHtmlLabelName(2123,user.getLanguage())%> 
            <%}%>
            <% if(educationlevel.equals("3")) {%>
            <%=SystemEnv.getHtmlLabelName(820,user.getLanguage())%> 
            <%}%>
            <% if(educationlevel.equals("4")) {%>
            <%=SystemEnv.getHtmlLabelName(765,user.getLanguage())%> 
            <%}%>
            <% if(educationlevel.equals("5")) {%>
            <%=SystemEnv.getHtmlLabelName(766,user.getLanguage())%> 
            <%}%>
            <% if(educationlevel.equals("6")) {%>
            <%=SystemEnv.getHtmlLabelName(767,user.getLanguage())%> 
            <%}%>
            <% if(educationlevel.equals("7")) {%>
            <%=SystemEnv.getHtmlLabelName(768,user.getLanguage())%> 
            <%}%>
            <% if(educationlevel.equals("8")) {%>
            <%=SystemEnv.getHtmlLabelName(769,user.getLanguage())%> 
            <%}%>
            <% if(educationlevel.equals("9")) {%>
            MBA 
            <%}%>
            <% if(educationlevel.equals("10")) {%>
            EMBA 
            <%}%>
            <% if(educationlevel.equals("11")) {%>
             <%=SystemEnv.getHtmlLabelName(2119,user.getLanguage())%>  
            <%}%>
			<input class=inputstyle type="hidden" name="educationlevel" value="<%=educationlevel%>">
            </td>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1833,user.getLanguage())%></td>
            <td class=Field><%=degree%> 
			<input class=inputstyle type="hidden" name="degree" value="<%=degree%>">
           </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1834,user.getLanguage())%></td>
            <td class=Field><%=bememberdate%>
              <input class=inputstyle type="hidden" name="bememberdate" value="<%=bememberdate%>">
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1835,user.getLanguage())%></td>
            <td class=Field><%=bepartydate%>
              <input class=inputstyle type="hidden" name="bepartydate" value="<%=bepartydate%>">
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1836,user.getLanguage())%></td>
            <td class=Field><%=bedemocracydate%>
              <input class=inputstyle type="hidden" name="bedemocracydate" value="<%=bedemocracydate%>">
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td height="29"><%=SystemEnv.getHtmlLabelName(1837,user.getLanguage())%></td>
            <td class=Field > <%=policy%>
			<input class=inputstyle type="hidden" name="policy" value="<%=policy%>">
              </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1838,user.getLanguage())%> </td>
            <td class=Field> <%=certificatecategory%>
			<input class=inputstyle type="hidden" name="certificatecategory" value="<%=certificatecategory%>">
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1839,user.getLanguage())%></td>
            <td class=Field> <%=certificatenum%>
			<input class=inputstyle type="hidden" name="certificatenum" value="<%=certificatenum%>">
             </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1840,user.getLanguage())%></td>
            <td class=Field> <%=nativeplace%>
			<input class=inputstyle type="hidden" name="nativeplace" value="<%=nativeplace%>">
           </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          </TBODY> 
        </TABLE>
      </TD>
    </TR>
	 <TR class=spacing valign="top"> 
      <TD  colspan=2 > 
        <table width="100%">
          <colgroup> <col width=15%> <col width=85%> <tbody> 
           <tr> 
		  <td ><%=SystemEnv.getHtmlLabelName(1841,user.getLanguage())%></td>
            <td  class=Field > 
              <%=train%>
			  <input class=inputstyle type="hidden" name="train" value="<%=train%>">
            </td>
            </tr>
           <TR><TD class=Line colSpan=2></TD></TR>
          </tbody> 
        </table>
		 </td>
       </tr>
       <TR class=title> 
	 <TD vAlign=top colspan=2 > 
	<table class=viewForm >
		 <colgroup> 
         <col width="15%"> 
         <col width=35％> 
         <col width="15％"> 
         <col width="35％"> 
         <tbody> 
	  <TR class=title> 
        <TH colspan=4> <%=SystemEnv.getHtmlLabelName(1842,user.getLanguage())%></TH>
        </TR>
       <TR class=spacing> 
            <TD class=line1 colspan=4></TD>
     </TR>
	  <tr> 
       <td > <%=SystemEnv.getHtmlLabelName(1843,user.getLanguage())%></td>
                  <td valign=top class=Field > <%=salarynow%>
				    <input class=inputstyle type="hidden" name="salarynow" value="<%=salarynow%>">
                     </td>
                   <td><%=SystemEnv.getHtmlLabelName(1844,user.getLanguage())%></td>
            <td valign=top class=Field >   <%=worktime%>
			<input class=inputstyle type="hidden" name="worktime" value="<%=worktime%>">
                 </td>
                </tr>
                <TR><TD class=Line colSpan=6></TD></TR> 
                <tr> 
          <td  > <%=SystemEnv.getHtmlLabelName(1845,user.getLanguage())%></td>
                  <td valign=top class=Field > <%=salaryneed%>
				  <input class=inputstyle type="hidden" name="salaryneed" value="<%=salaryneed%>">
                    </td>
                   <td><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></td>
            <td class=Field>
			<%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%>
			  <input class=inputstyle id=currencyid type=hidden name=currencyid value="<%=currencyid%>">
            </td>
                </tr>
                <TR><TD class=Line colSpan=6></TD></TR> 
                <tr> 
                  <Td  > <%=SystemEnv.getHtmlLabelName(1846,user.getLanguage())%></Td>
                  <TD vAlign=top colspan="3" class=Field >  <%=reason%>
				  <input class=inputstyle id=reason type=hidden name=reason value="<%=reason%>">
                  </TD>
                </TR>
                <TR><TD class=Line colSpan=2></TD></TR> 
                <TR class=title> 
                  <Td  > <%=SystemEnv.getHtmlLabelName(1847,user.getLanguage())%></Td>
                  <TD vAlign=top colspan="3" class=Field > <%=otherrequest%>
				  <input class=inputstyle  type=hidden name=otherrequest value="<%=otherrequest%>">
                  </TD>
                </TR>
                </tbody> 
              </table>
             </td>
            </tr>
	      <TR><TD class=Line colSpan=2></TD></TR> 
	   <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> <COL width=30%> <COL width=70%> <TBODY> 
          <TR class=title> 
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(569,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=2></TD>
          </TR>
        <tr> 
            <td><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></td>
            <td class=Field>   <%=contactor%>
			<input class=inputstyle  type=hidden name=contactor value="<%=contactor%>">
             </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(479,user.getLanguage())%></td>
            <td class=Field> <%=homepostcode%>
			<input class=inputstyle  type=hidden name=homepostcode value="<%=homepostcode%>">
              </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></td>
            <td class=Field><%=homeaddress%> 
			<input class=inputstyle  type=hidden name=homeaddress value="<%=homeaddress%>">
             </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          </TBODY> 
        </TABLE>
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> <COL width=30%> <COL width=70%> <TBODY> 
          <TR class=title> 
            <TH colSpan=4>&nbsp;</TH>
          </TR>
          <TR class=spacing> 
            <TD class=Sep3 colSpan=3></TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></td>
            <td class=Field>
			 <%=email%>
			<input class=inputstyle  type=hidden name=email value="<%=email%>">
              </td>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <td><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></td>
            <td class=Field>
			<%=homephone%> 
			<input class=inputstyle  type=hidden name=homephone value="<%=homephone%>">
               </td>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <td><%=SystemEnv.getHtmlLabelName(1848,user.getLanguage())%></td>
            <td class=Field> <%=homepage%>
			<input class=inputstyle  type=hidden name=homepage value="<%=homepage%>">
             </td>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          </TBODY> 
        </TABLE>
      </TD>
	  </TR>
	  
	   
	<TR class=spacing valign="top"> 
      <TD  colspan=2> 
        <table width="100%">
          <colgroup> 
          <col width=15%> 
          <col width=85%> 
          <tbody> 
           <tr> 
		    <td ><%=SystemEnv.getHtmlLabelName(1849,user.getLanguage())%></td>
            <td  class=Field > <%=selfcomment%>
			<input class=inputstyle  type=hidden name=selfcomment value="<%=selfcomment%>">
            </td>
            </tr>
           <TR><TD class=Line colSpan=2></TD></TR>
          </tbody> 
        </table>
		 </td>
       </tr>
       
   	<input class=inputstyle type=hidden name=applyid value="<%=applyid%>">

      <!-- ---------------------------------------------------------------------------->
    </TBODY> 
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

</BODY>
<SCRIPT language="javascript">
function OnSubmit(){
    document.resource.action="HrmCareerApplyAdd2.jsp";
    document.resource.submit();   
}
function OnBack(){
    document.resource.action = "HrmCareerApplyAdd.jsp";
 	document.resource.submit();
}
</script>
</HTML>