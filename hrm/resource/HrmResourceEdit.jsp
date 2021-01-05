<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CostcenterComInfo" class="weaver.hrm.company.CostCenterComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="JobGroupsComInfo" class="weaver.hrm.job.JobGroupsComInfo" scope="page"/>
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page"/>
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="BankComInfo" class="weaver.hrm.finance.BankComInfo" scope="page"/>
<jsp:useBean id="ContacterTitleComInfo" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page"/>
<jsp:useBean id="UseKindComInfo" class="weaver.hrm.job.UseKindComInfo" scope="page"/>
<jsp:useBean id="JobTypeComInfo" class="weaver.hrm.job.JobTypeComInfo" scope="page"/>
<jsp:useBean id="JobCallComInfo" class="weaver.hrm.job.JobCallComInfo" scope="page"/>


<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String id = Util.null2String(request.getParameter("id"));
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

RecordSet.executeProc("HrmResource_SelectByID",id);
RecordSet.next();
String loginid = Util.toScreenToEdit(RecordSet.getString("loginid"),user.getLanguage()) ;			/*登录id*/
String firstname = Util.toScreenToEdit(RecordSet.getString("firstname"),user.getLanguage()) ;			/*名*/
String lastname = Util.toScreenToEdit(RecordSet.getString("lastname"),user.getLanguage()) ;			/*姓*/
String aliasname= Util.toScreenToEdit(RecordSet.getString("aliasname"),user.getLanguage()) ;				/*别名*/
String titleid= Util.toScreenToEdit(RecordSet.getString("titleid"),user.getLanguage()) ;				/*称呼*/
String sex = Util.toScreenToEdit(RecordSet.getString("sex"),user.getLanguage()) ;
/*
性别:
0:男性
1:女性
2:未知
*/
String birthday = Util.toScreenToEdit(RecordSet.getString("birthday"),user.getLanguage()) ;			/*生日*/
String nationality = Util.toScreenToEdit(RecordSet.getString("nationality"),user.getLanguage()) ;		/*国籍*/
String defaultlanguage = Util.toScreenToEdit(RecordSet.getString("defaultlanguage"),user.getLanguage()) ;	/*口语语言*/
String systemlanguage = Util.toScreenToEdit(RecordSet.getString("systemlanguage"),user.getLanguage()) ;	/*系统语言*/
String maritalstatus = Util.toScreenToEdit(RecordSet.getString("maritalstatus"),user.getLanguage()) ;
/*
婚姻状况:
0:未婚
1:已婚
2:离异
3:同居
*/
String marrydate = Util.toScreenToEdit(RecordSet.getString("marrydate"),user.getLanguage()) ;			/*结婚日期*/
String extphone = Util.toScreenToEdit(RecordSet.getString("extphone"),user.getLanguage()) ;			/*分机电话*/
String telephone = Util.toScreenToEdit(RecordSet.getString("telephone"),user.getLanguage()) ;			/*办公电话*/
String mobile = Util.toScreenToEdit(RecordSet.getString("mobile"),user.getLanguage()) ;				/*移动电话*/
String mobilecall = Util.toScreenToEdit(RecordSet.getString("mobilecall"),user.getLanguage()) ;			/*呼机*/
String email = Util.toScreenToEdit(RecordSet.getString("email"),user.getLanguage()) ;				/*电邮*/
String countryid = Util.toScreenToEdit(RecordSet.getString("countryid"),user.getLanguage()) ;			/*工作国家*/
String locationid = Util.toScreenToEdit(RecordSet.getString("locationid"),user.getLanguage()) ;			/*工作地址*/
String workroom = Util.toScreenToEdit(RecordSet.getString("workroom"),user.getLanguage()) ;			/*办公室*/
String homeaddress = Util.toScreenToEdit(RecordSet.getString("homeaddress"),user.getLanguage()) ;				/*家庭地址*/
String homepostcode = Util.toScreenToEdit(RecordSet.getString("homepostcode"),user.getLanguage()) ;				/*家庭邮编*/
String homephone = Util.toScreenToEdit(RecordSet.getString("homephone"),user.getLanguage()) ;				/*家庭电话*/
String resourcetype = Util.toScreenToEdit(RecordSet.getString("resourcetype"),user.getLanguage()) ;
/*
人力资源种类:
承包商: F
职员: H
学生: D
*/
String startdate = Util.toScreenToEdit(RecordSet.getString("startdate"),user.getLanguage()) ;			/*工作日期*/
String enddate = Util.toScreenToEdit(RecordSet.getString("enddate"),user.getLanguage()) ;			/*系统结束日期*/
String contractdate = Util.toScreenToEdit(RecordSet.getString("contractdate"),user.getLanguage()) ;		/*合同结束日期*/
String jobtitle = Util.toScreenToEdit(RecordSet.getString("jobtitle"),user.getLanguage()) ;			/*职位*/
String jobgroup= Util.toScreenToEdit(RecordSet.getString("jobgroup"),user.getLanguage()) ;			/*工作类别*/
String jobactivity= Util.toScreenToEdit(RecordSet.getString("jobactivity"),user.getLanguage()) ;			/*职责*/
String jobactivitydesc = Util.toScreenToEdit(RecordSet.getString("jobactivitydesc"),user.getLanguage()) ;	/*职责描述*/
String joblevel = Util.toScreenToEdit(RecordSet.getString("joblevel"),user.getLanguage()) ;			/*工作级别*/
String seclevel = Util.toScreenToEdit(RecordSet.getString("seclevel"),user.getLanguage()) ;
String seclevel2=seclevel;
/*安全级别*/
String departmentid = Util.toScreenToEdit(RecordSet.getString("departmentid"),user.getLanguage()) ;
String departmentid2=departmentid;
/*所属部门*/
String costcenterid = Util.toScreenToEdit(RecordSet.getString("costcenterid"),user.getLanguage()) ;		/*所属成本中心*/
String managerid = Util.toScreenToEdit(RecordSet.getString("managerid"),user.getLanguage()) ;			/*经理*/
String assistantid = Util.toScreenToEdit(RecordSet.getString("assistantid"),user.getLanguage()) ;		/*助理*/
String purchaselimit = Util.toScreenToEdit(RecordSet.getString("purchaselimit"),user.getLanguage()) ;		/*支付审核限制*/
String currencyid = Util.toScreenToEdit(RecordSet.getString("currencyid"),user.getLanguage()) ;				/*支付计算币种*/
String bankid1 = Util.toScreenToEdit(RecordSet.getString("bankid1"),user.getLanguage()) ;			/*工资银行1*/
String accountid1 = Util.toScreenToEdit(RecordSet.getString("accountid1"),user.getLanguage()) ;			/*工资帐号1*/
String bankid2 = Util.toScreenToEdit(RecordSet.getString("bankid2"),user.getLanguage()) ;			/*工资银行2*/
String accountid2 = Util.toScreenToEdit(RecordSet.getString("accountid2"),user.getLanguage()) ;				/*工资帐号2*/
String securityno = Util.toScreenToEdit(RecordSet.getString("securityno"),user.getLanguage()) ;				/*社会安全号*/
String creditcard = Util.toScreenToEdit(RecordSet.getString("creditcard"),user.getLanguage()) ;				/*信用卡号*/
String expirydate = Util.toScreenToEdit(RecordSet.getString("expirydate"),user.getLanguage()) ;					/*信用卡失效日期*/
String resourceimageid = Util.getFileidOut(RecordSet.getString("resourceimageid")) ;				/*照片id 由SequenceIndex表得到，和使用它的表相关联*/

/*新增加的部分*/
String certificatecategory = Util.toScreenToEdit(RecordSet.getString("certificatecategory"),user.getLanguage()) ;/**/
String certificatenum = Util.toScreenToEdit(RecordSet.getString("certificatenum"),user.getLanguage()) ;			/*证件号码*/
String nativeplace = Util.toScreenToEdit(RecordSet.getString("nativeplace"),user.getLanguage()) ;				/*籍贯*/
String educationlevel = Util.toScreenToEdit(RecordSet.getString("educationlevel"),user.getLanguage()) ;			/*学历*/
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
String bememberdate = Util.toScreenToEdit(RecordSet.getString("bememberdate"),user.getLanguage()) ;				/*入团日期*/
String bepartydate = Util.toScreenToEdit(RecordSet.getString("bepartydate"),user.getLanguage()) ;				/*入党日期*/
String bedemocracydate = Util.toScreenToEdit(RecordSet.getString("bedemocracydate"),user.getLanguage()) ;		/*民主日期*/
String regresidentplace = Util.toScreenToEdit(RecordSet.getString("regresidentplace"),user.getLanguage()) ;		/*户口所在地*/
String healthinfo = Util.toScreenToEdit(RecordSet.getString("healthinfo"),user.getLanguage()) ;					/*健康状况*/
/*
健康状况:
0:优秀
1:良好
2:一般
3:较差
*/
String residentplace = Util.toScreenToEdit(RecordSet.getString("residentplace"),user.getLanguage()) ;			/*现居住地*/
String policy = Util.toScreenToEdit(RecordSet.getString("policy"),user.getLanguage()) ;							/*政治面貌*/
String degree = Util.toScreenToEdit(RecordSet.getString("degree"),user.getLanguage()) ;							/*学位*/
String height = Util.toScreenToEdit(RecordSet.getString("height"),user.getLanguage()) ;							/*身高*/
String homepage = Util.toScreenToEdit(RecordSet.getString("homepage"),user.getLanguage()) ;						/*个人主页*/
String train = Util.toScreenToEdit(RecordSet.getString("train"),user.getLanguage()) ;							/*培训及持有证书*/

String worktype = Util.toScreenToEdit(RecordSet.getString("worktype"),user.getLanguage()) ;						/*工种*/
String usekind = Util.toScreenToEdit(RecordSet.getString("usekind"),user.getLanguage()) ;						/*用工性质*/
String workcode = Util.toScreenToEdit(RecordSet.getString("workcode"),user.getLanguage()) ;						/*工号*/
String contractbegintime = Util.toScreenToEdit(RecordSet.getString("contractbegintime"),user.getLanguage()) ;	/*合同开始日期*/
String jobright = Util.toScreenToEdit(RecordSet.getString("jobright"),user.getLanguage()) ;						/*工作权利*/
String jobcall = Util.toScreenToEdit(RecordSet.getString("jobcall"),user.getLanguage()) ;						/*现职称*/
String jobtype = Util.toScreenToEdit(RecordSet.getString("jobtype"),user.getLanguage()) ;						/*职务类别*/
String accumfundaccount = Util.toScreenToEdit(RecordSet.getString("accumfundaccount"),user.getLanguage()) ;		/*公积帐号*/
/*altered at 2002-09-03*/
String birthplace = Util.toScreenToEdit(RecordSet.getString("birthplace"),user.getLanguage()) ;						/*出生地*/
String folk = Util.toScreenToEdit(RecordSet.getString("folk"),user.getLanguage()) ;									/*民族*/
String residentphone = Util.toScreenToEdit(RecordSet.getString("residentphone"),user.getLanguage()) ; 	             /*现居住地电话*/
String residentpostcode = Util.toScreenToEdit(RecordSet.getString("residentpostcode"),user.getLanguage()) ;			/*现居住地邮编*/


/*创建信息*/
String createrid = Util.toScreenToEdit(RecordSet.getString("createrid"),user.getLanguage()) ;					/*创建人id*/
String createdate = Util.toScreenToEdit(RecordSet.getString("createdate"),user.getLanguage()) ;					/*创建日期*/
String lastmodid = Util.toScreenToEdit(RecordSet.getString("lastmodid"),user.getLanguage()) ;					/*最后修改人id*/
String lastmoddate = Util.toScreenToEdit(RecordSet.getString("lastmoddate"),user.getLanguage()) ;					/*修改日期*/
/*自定义字段*/
String datefield[] = new String[5] ;
String numberfield[] = new String[5] ;
String textfield[] = new String[5] ;
String tinyintfield[] = new String[5] ;

for(int k=1 ; k<6;k++) datefield[k-1] = RecordSet.getString("datefield"+k) ;
for(int k=1 ; k<6;k++) numberfield[k-1] = RecordSet.getString("numberfield"+k) ;
for(int k=1 ; k<6;k++) textfield[k-1] = RecordSet.getString("textfield"+k) ;
for(int k=1 ; k<6;k++) tinyintfield[k-1] = RecordSet.getString("tinyintfield"+k) ;

boolean isSelf = false;
boolean displayAll=false;
 
if (id.equals(""+user.getUID())&&!(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user,departmentid))){
	isSelf = true;
}

if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user,departmentid)){
	displayAll=true;
}


if(!(displayAll||isSelf))  {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}


String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = firstname+" "+lastname;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
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
<FORM name=resource id=resource action=HrmResourceOperation.jsp method=post enctype="multipart/form-data">
<input type=hidden name=operation value="editresource">
<input type=hidden name=id value="<%=id%>">
   
  <TABLE class=viewForm>
    <COLGROUP> 
    <COL width="49%"> 
    <COL width=10> 
    <COL width="49%"> 
    <TBODY> 
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> <COL width=30%> <COL width=70%> <TBODY> 
          <TR class=title> 
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(411,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing> 
            <TD class=Line1 colSpan=2></TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(460,user.getLanguage())%></TD>
            <TD class=Field> 
              <INPUT class=inputStyle maxLength=30 size=30 
            name="firstname" value="<%=firstname%>">
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(461,user.getLanguage())%></TD>
            <TD class=Field> 
              <INPUT class=inputStyle maxLength=30 name="lastname"
            onchange='checkinput("lastname","lastnameimage")' value="<%=lastname%>">
              <SPAN id=lastnameimage></SPAN></TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(462,user.getLanguage())%></TD>
            <TD class=Field> <BUTTON class=Browser onclick="onShowTitleID()"></BUTTON> 
              <SPAN id=titleidspan><%=Util.toScreen(ContacterTitleComInfo.getContacterTitlename(titleid),user.getLanguage())%></SPAN> 
              <INPUT type=hidden name=titleid value="<%=titleid%>">
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></TD>
            <TD class=Field> 
              <select class=inputStyle id=sex 
              name=sex>
                <option value=0 <% if(sex.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%></option>
                <option value=1 <% if(sex.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%></option>
                </select>
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(464,user.getLanguage())%></TD>
            <TD class=Field><BUTTON class=Calendar type="button" id=selectbirthday onclick="getbirthdayDate()"></BUTTON> 
              <SPAN id=birthdayspan ><%=birthday%></SPAN> 
              <input type="hidden" name="birthday" value="<%=birthday%>">
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1826,user.getLanguage())%></td>
            <td class=Field> 
              <input class=inputStyle maxlength=10  size=5
            name=height onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("height")' value="<%=height%>">
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1827,user.getLanguage())%></td>
            <td class=Field> 
              <select class=inputStyle id=healthinfo name=healthinfo>
                <option value=0 <% if(healthinfo.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(824,user.getLanguage())%></option>
                <option value=1 <% if(healthinfo.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%></option>
                <option value=2 <% if(healthinfo.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></option>
                <option value=3 <% if(healthinfo.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(825,user.getLanguage())%></option>
              </select>
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(465,user.getLanguage())%></TD>
            <TD class=Field><BUTTON class=Browser id=SelectNationality onclick="onShowNationality()"></BUTTON> 
              <SPAN id=nationalityspan><%=Util.toScreen(CountryComInfo.getCountrydesc(nationality),user.getLanguage())%></SPAN> 
              <INPUT class=inputStyle id=nationality type=hidden name=nationality value="<%=nationality%>">
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
           <td><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(467,user.getLanguage())%></td>
            <td class=Field><button class=Browser id=SelectLanguage onClick="onShowDefaultLanguage()"></button> 
              <span class=inputStyle id=defaultlanguagespan><%=Util.toScreen(LanguageComInfo.getLanguagename(defaultlanguage),user.getLanguage())%></span> 
              <input class=inputStyle id=defaultlanguage type=hidden name=defaultlanguage value="<%=defaultlanguage%>">
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
           <TD><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%></TD>
            <TD class=Field><BUTTON class=Browser id=SelectLanguage onclick="onShowSystemLanguage()"></BUTTON> 
              <SPAN class=inputStyle id=systemlanguagespan><%=Util.toScreen(LanguageComInfo.getLanguagename(systemlanguage),user.getLanguage())%></SPAN> 
              <INPUT class=inputStyle id=systemlanguage type=hidden name=systemlanguage value="<%=systemlanguage%>">
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(469,user.getLanguage())%></TD>
            <TD class=Field> 
              <SELECT class=inputStyle id=maritalstatus name=maritalstatus>
                <OPTION value=""> 
                <OPTION value=0 <% if(maritalstatus.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(470,user.getLanguage())%></OPTION>
                <OPTION value=1 <% if(maritalstatus.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(471,user.getLanguage())%></OPTION>
                </SELECT>
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
<!--
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(474,user.getLanguage())%></td>
            <td class=Field><button class=Calendar id=selectmarrydate onClick="getmarryDate()"></button> 
              <span id=marrydatespan ><%=marrydate%></span> 
-->
              <input type="hidden" name="marrydate" value="<%=marrydate%>">
<!--
            </td>
          </tr>
-->
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1838,user.getLanguage())%> </td>
            <td class=Field> 
              <input class=inputStyle maxlength=30 size=30 
            name=certificatecategory value="<%=certificatecategory%>">
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1839,user.getLanguage())%></td>
            <td class=Field> 
              <input class=inputStyle maxlength=60 size=30 
            name=certificatenum value="<%=certificatenum%>">
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1840,user.getLanguage())%></td>
            <td class=Field> 
              <input class=inputStyle maxlength=60 size=30 
            name=nativeplace value="<%=nativeplace%>">
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1886,user.getLanguage())%></td>
            <td class=Field> 
              <input class=inputStyle maxlength=60 size=30 
            name=folk value="<%=folk%>">
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1828,user.getLanguage())%></td>
            <td class=Field> 
              <input class=inputStyle maxlength=60 size=30 
            name=regresidentplace value="<%=regresidentplace%>">
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1885,user.getLanguage())%></td>
            <td class=Field> 
              <input class=inputStyle maxlength=60 size=30 
            name=birthplace value="<%=birthplace%>">
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1829,user.getLanguage())%></td>
            <td class=Field> 
              <input class=inputStyle maxlength=60 size=30 
            name=residentplace value="<%=residentplace%>">
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1930,user.getLanguage())%></td>
            <td class=Field> 
              <input class=inputStyle maxlength=60 size=30 
            name=residentphone value="<%=residentphone%>">
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1931,user.getLanguage())%></td>
            <td class=Field> 
              <input class=inputStyle maxlength=60 size=30 
            name=residentpostcode value="<%=residentpostcode%>"  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("residentpostcode")'>
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1848,user.getLanguage())%></td>
            <td class=Field> 
              <input class=inputStyle maxlength=100 size=30 
            name=homepage value="<%=homepage%>">
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
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
          <TR class=spacing> 
            <TD class=line1 colSpan=2></TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(412,user.getLanguage())%></TD>
            <TD class=Field><% if( displayAll) { %>
              <INPUT class=inputStyle maxLength=20 
            onchange='checkinput("loginid","loginidimage")' size=15 
            name=loginid value="<%=loginid%>"><%} else {%>
            <%=loginid%><INPUT type=hidden name=loginid value="<%=loginid%>"><%}%>
              <SPAN id=loginidimage></SPAN></TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></td>
            <td class=Field> 
              <input class=inputStyle  
            onChange='checkinput("password","passwordimage")' size=15 
            name=password type="password" value="novalue$1" >
              <span id=passwordimage></span></td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(501,user.getLanguage())%></td>
            <td class=Field> 
              <input class=inputStyle  
            onChange='checkinput("confirmpassword","confirmpasswordimage")' size=15 
            name=confirmpassword type="password" value="novalue$1" >
              <span id=confirmpasswordimage></span>
              </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(475,user.getLanguage())%></td>
            <td class=Field> 
              <input class=inputStyle maxlength=20 size=15  name=aliasname type="text" value="<%=aliasname%>">
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <td><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%></td>
            <td class=Field> 
              <select class=inputStyle id=educationlevel name=educationlevel>
                <option value="0" <% if(educationlevel.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></option>
                <option value="1"  <% if(educationlevel.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(819,user.getLanguage())%></option>
                <option value="2" <% if(educationlevel.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(764,user.getLanguage())%></option>
               <option value="12" <% if(educationlevel.equals("12")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2122,user.getLanguage())%></option>
               <option value="13" <% if(educationlevel.equals("13")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2123,user.getLanguage())%></option>
                <option value="3" <% if(educationlevel.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(820,user.getLanguage())%></option>
                <option value="4" <% if(educationlevel.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(765,user.getLanguage())%></option>
                <option value="5" <% if(educationlevel.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(766,user.getLanguage())%></option>
                <option value="6" <% if(educationlevel.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(767,user.getLanguage())%></option>
                <option value="7" <% if(educationlevel.equals("7")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(768,user.getLanguage())%></option>
                <option value="8" <% if(educationlevel.equals("8")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(769,user.getLanguage())%></option>
                <option value="9" <% if(educationlevel.equals("9")) {%>selected<%}%>>MBA</option>
                <option value="10" <% if(educationlevel.equals("10")) {%>selected<%}%>>EMBA</option>
                <option value="11" <% if(educationlevel.equals("11")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2119,user.getLanguage())%></option>
              </select>
            </td>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1833,user.getLanguage())%></td>
            <td class=Field> 
              <input class=inputStyle maxlength=30 size=30 
            name=degree value="<%=degree%>">
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1834,user.getLanguage())%></td>
            <td class=Field><button class=Calendar type="button" id=selectbememberdate onClick="getbememberdateDate()"></button> 
              <span id=bememberdatespan ><%=bememberdate%></span> 
              <input type="hidden" name="bememberdate" value="<%=bememberdate%>">
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1835,user.getLanguage())%></td>
            <td class=Field><button class=Calendar type="button" id=selectbepartydate onClick="getbepartydateDate()"></button> 
              <span id=bepartydatespan ><%=bepartydate%></span> 
              <input type="hidden" name="bepartydate" value="<%=bepartydate%>">
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
<!--
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1836,user.getLanguage())%></td>
            <td class=Field><button class=Calendar id=selectbedemocracydate onClick="getbedemocracydateDate()"></button> 
              <span id=bedemocracydatespan ><%=bedemocracydate%></span> 
-->
              <input type="hidden" name="bedemocracydate" value="<%=bedemocracydate%>">
<!--
            </td>
          </tr>
-->
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1837,user.getLanguage())%></td>
            <td class=Field> 
              <input class=inputStyle maxlength=30 size=30 
            name=policy value="<%=policy%>">
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td valign="top"><%=SystemEnv.getHtmlLabelName(1841,user.getLanguage())%></td>
            <td class=Field> 
              <textarea class=inputstyle   style="width:80%" name=train rows="6"><%=train%></textarea>
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></TD>
            <TD class=Field> 
              <% if(resourceimageid.equals("") || resourceimageid.equals("0")) {%>
              <input class=inputstyle type="file" name="resourceimage">
              <%} else {%>
              <img border=0  width=200 src="/weaver/weaver.file.FileDownload?fileid=<%=resourceimageid%>"> 
              <BUTTON class=btnDelete id=Delete accessKey=P onclick="onDelPic()"><U>P</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></BUTTON> 
              <% } %>
              <input type="hidden" name="oldresourceimage" value="<%=resourceimageid%>">
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          </TBODY> 
        </TABLE>
      </TD>
    </TR>
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> 
          <COL width=30%> 
          <COL width=70%> 
          <TBODY> 
          <TR class=title> 
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(476,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=2></TD>
          </TR>
           <TR> 
            <!-- -->
            <TD><%=SystemEnv.getHtmlLabelName(6005,user.getLanguage())%></TD>
            <TD class=Field> 
              <INPUT class=inputStyle maxLength=25 size=30 
            name=extphone value="<%=extphone%>">
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <!-- -->
            <TD><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></TD>
            <TD class=Field> 
              <INPUT class=inputStyle maxLength=25 size=30 
            name=telephone value="<%=telephone%>">
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <!---->
            <TD><%=SystemEnv.getHtmlLabelName(422,user.getLanguage())%></TD>
            <TD class=Field> 
              <INPUT class=inputStyle maxLength=25 size=30 
            name=mobile value="<%=mobile%>">
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></TD>
            <TD class=Field> 
              <INPUT class=inputStyle maxLength=15 size=30 
            name=mobilecall value="<%=mobilecall%>">
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></TD>
            <TD class=Field> 
              <INPUT class=inputStyle maxLength=128 size=30 
            name=email value="<%=email%>">
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          </TBODY> 
        </TABLE>
      </TD>
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> 
          <COL width=30%> 
          <COL width=70%> 
          <TBODY> 
          <TR class=Title> 
            <TH colSpan=2>&nbsp;</TH>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=2></TD>
          </TR>
          <tr> 
            <td id=lblLocation><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></td>
            <td class=Field id=txtLocation><BUTTON class=Browser id=SelectCountryCode onclick="onShowCountryID()"></BUTTON> 
              <SPAN id=countryidspan><%=Util.toScreen(CountryComInfo.getCountrydesc(countryid),user.getLanguage())%></SPAN> 
              <INPUT id=CountryCode type=hidden name=countryid value="<%=countryid%>">
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD id=lblLocation><%=SystemEnv.getHtmlLabelName(419,user.getLanguage())%></TD>
            <TD class=Field id=txtLocation><BUTTON class=Browser 
            id=SelectLocation onclick="onShowLocationID()"></BUTTON> <SPAN class=inputStyle 
            id=locationidspan><%=Util.toScreen(LocationComInfo.getLocationname(locationid),user.getLanguage())%></SPAN> 
              <INPUT id=locationid type=hidden name=locationid value="<%=locationid%>">
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td id=lblRoom><%=SystemEnv.getHtmlLabelName(420,user.getLanguage())%></td>
            <td class=Field id=txtRoom> 
              <input class=inputStyle maxlength=30 size=30 name=workroom value="<%=workroom%>">
            </td>
            <!---->
          </tr>.
          <TR><TD class=Line colSpan=2></TD></TR> 
          </TBODY> 
        </TABLE>
      </TD>
    </TR>
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> 
          <COL width=30%> 
          <COL width=70%> 
          <TBODY> 
          <TR class=title> 
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(478,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=2></TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></TD>
            <TD class=Field> 
              <INPUT class=inputStyle maxLength=100 size=30 
            name=homeaddress value="<%=homeaddress%>">
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(479,user.getLanguage())%></TD>
            <TD class=Field> 
              <INPUT class=inputStyle maxLength=8 size=30 
            name=homepostcode onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("homepostcode")' value="<%=homepostcode%>">
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          </TBODY> 
        </TABLE>
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> 
          <COL width=30%> 
          <COL width=70%> 
          <TBODY> 
          <TR class=title> 
            <TH colSpan=4>&nbsp;</TH>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=3></TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></TD>
            <TD class=Field> 
              <INPUT class=inputStyle maxLength=15 size=30 
            name=homephone value="<%=homephone%>">
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          </TBODY> 
        </TABLE>
      </TD>
	  	<!-- ---------------------------------------------------------------------------->	  
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> 
          <COL width=30%> 
          <COL width=70%> 
          <TBODY> 
          <TR class=Title> 
            <TH colSpan=2 height="19"><%=SystemEnv.getHtmlLabelName(380,user.getLanguage())%></TH>
          </TR>
          <TR class= Spacing> 
            <TD class=Line1 colSpan=2></TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
            <TD class=Field> <%if((!isSelf)||(displayAll)){%>
              <SELECT class=inputStyle id=resourcetype name=resourcetype>
                <OPTION value=1 <% if(resourcetype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(130,user.getLanguage())%></OPTION>
                <OPTION value=2 <% if(resourcetype.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(131,user.getLanguage())%></OPTION>
                <OPTION value=3 <% if(resourcetype.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(134,user.getLanguage())%></OPTION>
                <OPTION value=4 <% if(resourcetype.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></OPTION>
                <OPTION value=5 <% if(resourcetype.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1932,user.getLanguage())%></OPTION>
              </SELECT>
			  <%} else {%>
			  <% if(resourcetype.equals("1")) {%><%=SystemEnv.getHtmlLabelName(130,user.getLanguage())%>
			  <input type=hidden name=resourcetype value="1">
			  <%}%>
			  <% if(resourcetype.equals("2")) {%><%=SystemEnv.getHtmlLabelName(131,user.getLanguage())%>
			  <input type=hidden name=resourcetype value="2">
			  <%}%>
			  <% if(resourcetype.equals("3")) {%><%=SystemEnv.getHtmlLabelName(134,user.getLanguage())%>
			  <input type=hidden name=resourcetype value="3">
			  <%}%>
			  <% if(resourcetype.equals("4")) {%><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%>
			  <input type=hidden name=resourcetype value="4">
			  <%}%>
			  <% if(resourcetype.equals("5")) {%><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%>
			  <input type=hidden name=resourcetype value="5">
			  <%}%>
			  <%}%>
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(804,user.getLanguage())%></td>
            <td class=Field>
			<%if((!isSelf)||(displayAll)){%>
			 <button class=Browser onClick="onShowUsekind()"></button> 
              <span id=usekindspan><%=Util.toScreen(UseKindComInfo.getUseKindname(usekind),user.getLanguage())%></span> 
       		  <%} else {%>
			  <%=Util.toScreen(UseKindComInfo.getUseKindname(usekind),user.getLanguage())%>
			  <%}%>
			  <input type=hidden name=usekind value="<%=usekind%>">
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1933,user.getLanguage())%></td>
            <td class=Field> <%if((!isSelf)||(displayAll)){%>
              <input class=inputStyle maxlength=60 size=30 
            name=workcode value="<%=workcode%>">
			<%} else {%>
			<%=workcode%>
			<input type=hidden name=workcode value="<%=workcode%>">
			<%}%>
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1934,user.getLanguage())%></td>
            <td class=Field> <%if((!isSelf)||(displayAll)){%>
              <input class=inputStyle maxlength=60 size=30 
            name=worktype value="<%=worktype%>">
			<%} else {%>
			<%=worktype%>
			<input type=hidden name=worktype value="<%=worktype%>">
			<%}%>
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          </TBODY> 
        </TABLE>
      </TD>
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> 
          <COL width=30%> 
          <COL width=70%> 
          <TBODY> 
          <TR class=Title> 
            <TH colSpan=2>&nbsp;</TH>
          </TR>
          <TR class= Spacing> 
            <TD class=Line1 colSpan=2></TD>
          </TR>
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1940,user.getLanguage())%></td>
            <td class=Field><%if((!isSelf)||(displayAll)){%>
			<button class=Calendar id=selectstartdate type="button" onClick="getstartDate()"></button> 
              <span id=startdatespan ><%=startdate%></span> 
			  <%} else {%>
			  <%=startdate%>
			  <%}%>
			 <input type="hidden" name="startdate" value="<%=startdate%>">
            </td>
          </tr>
          <td><%=SystemEnv.getHtmlLabelName(1936,user.getLanguage())%></td>
          <td class=Field><%if((!isSelf)||(displayAll)){%>
		  <button class=Calendar type="button" id=selectcontractbegintime onClick="getContractbegintimeDate()"></button> 
            <span id=contractbegintimespan ><%=contractbegintime%></span> 
          <%} else {%>
			<%=contractbegintime%>
			<%}%>
			<input type="hidden" name="contractbegintime"  value="<%=contractbegintime%>">
          </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(482,user.getLanguage())%></TD>
            <TD class=Field><%if((!isSelf)||(displayAll)){%>
			<BUTTON class=Calendar type="button" id=selectcontractdate onclick="getcontractDate()"></BUTTON> 
              <SPAN id=contractdatespan ><%=contractdate%></SPAN> 
              <%} else {%>
			  <%=contractdate%>
			  <%}%><input type="hidden" name="contractdate" value="<%=contractdate%>">
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(483,user.getLanguage())%></TD>
            <TD class=Field><%if((!isSelf)||(displayAll)){%>
			 <BUTTON class=Calendar type="button" id=selectenddate onclick="getHendDate()"></BUTTON> 
              <SPAN id=enddatespan ><%=enddate%></SPAN> 
      		  <%} else {%>
			  <%=enddate%>
			  <%}%>
			  <input type="hidden" name="enddate" value="<%=enddate%>">
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          </TBODY> 
        </TABLE>
      </TD>
    </TR>
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> 
          <COL width=30%> 
          <COL width=70%> 
          <TBODY> 
          <TR class=Title> 
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(376,user.getLanguage())%></TH>
          </TR>
          <TR class= Spacing> 
            <TD class=line1 colSpan=2></TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%></TD>
            <TD class=Field><%if((!isSelf)||(displayAll)){%>
			<BUTTON class=Browser id=SelectJobTitle onclick="onShowJobtitle()"></BUTTON> 
              <SPAN id=jobtitlespan><%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobtitle),user.getLanguage())%></SPAN> 
			  <%} else {%>
			  <%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobtitle),user.getLanguage())%>
			  <%}%>
			   <INPUT id=jobtitle type=hidden name=jobtitle value="<%=jobtitle%>">
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(484,user.getLanguage())%></td>
            <td class=Field> <%if((!isSelf)||(displayAll)){%>
              <input class=inputStyle maxlength=3 size=5 
            name=joblevel onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevel")' value="<%=joblevel%>">
			<%} else {%>
			<%=joblevel%>
			<input type="hidden" name="joblevel" value="<%=joblevel%>">
			<%}%>
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1937,user.getLanguage())%></td>
            <td class=Field> <%if((!isSelf)||(displayAll)){%>
			<button class=Browser onClick="onShowJobcall()"></button> 
              <span id=jobcallspan><%=Util.toScreen(JobCallComInfo.getJobCallname(jobcall),user.getLanguage())%></span> 
       		  <%} else {%>
			  <%=Util.toScreen(JobCallComInfo.getJobCallname(jobcall),user.getLanguage())%>
			  <%}%>
			  <input type=hidden name=jobcall value="<%=jobcall%>">
            </td>
          </tr>
        <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(805,user.getLanguage())%></td>
            <td class=Field> <%if((!isSelf)||(displayAll)){%>
			<button class=Browser onClick="onShowJobtype()"></button> 
              <span id=jobtypespan><%=Util.toScreen(JobTypeComInfo.getJobTypename(jobtype),user.getLanguage())%></span> 
			  <%} else {%>
			  <%=Util.toScreen(JobTypeComInfo.getJobTypename(jobtype),user.getLanguage())%>
			  <%}%>
			  <input type=hidden name=jobtype value="<%=jobtype%>">
            </td>
          </tr>
        <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(120,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></TD>
            <TD class=Field> <%if((!isSelf)||(displayAll)){%>
              <INPUT class=inputStyle maxLength=3 size=5 
            name=seclevel onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("seclevel");checkinput("seclevel","seclevelimage")' value="<%=seclevel%>">
			<SPAN id=seclevelimage></SPAN>
			<%} else {%>
			<%=seclevel%>
			<input type="hidden" name="seclevel" value="<%=seclevel%>">
			<%}%>
            </TD>
          </TR>
       <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1938,user.getLanguage())%></td>
            <td class=Field> <%if((!isSelf)||(displayAll)){%>
              <input class=inputStyle maxlength=100 size=30 
            name=jobright value="<%=jobright%>">
			<%} else {%>
			<%=jobright%>
			<input type="hidden" name="jobright" value="<%=jobright%>">
			<%}%>
            </td>
          </tr>
        <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
           <TD><%=SystemEnv.getHtmlLabelName(382,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
            <TD class=Field> <%if((!isSelf)||(displayAll)){%>
              <INPUT class=inputStyle maxLength=90 size=30 
            name=jobactivitydesc value="<%=jobactivitydesc%>">
			<%} else {%>
			<%=jobactivitydesc%>
			<input type="hidden" name="jobactivitydesc" value="<%=jobactivitydesc%>">
			<%}%>
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
<!--
          <tr> 
            <td ><%=SystemEnv.getHtmlLabelName(485,user.getLanguage())%></td>
            <td class=Field > <%if((!isSelf)||(displayAll)){%>
-->
              <input class=inputStyle type=hidden
            maxlength=16 size=10 value="<%=purchaselimit%>" name=purchaselimit onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("purchaselimit")'>
<!--
            <%} else {%>
			<%=purchaselimit%>
			<input type="hidden" name="purchaselimit" value="<%=purchaselimit%>">
			<%}%>
			</td>
          </tr>
-->
          <TR> 
            <td id=lblLimit><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></td>
            <td class=Field id=txtLimit><%if((!isSelf)||(displayAll)){%>
			<BUTTON class=Browser 
            id=SelectCurrencyID onClick="onShowCurrencyID()"></BUTTON> <SPAN class=inputStyle 
            id=currencyidspan><%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%></SPAN> 
			  <%} else {%>
			  <%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%>
			  <%}%>
			   <INPUT id=currencyid type=hidden name=currencyid value="<%=currencyid%>">
            </td>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          </TBODY> 
        </TABLE>
      </TD>
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP>
          <COL width=30%> 
          <COL width=70%> 
          <TBODY> 
          <TR class=Title> 
            <TH colSpan=2>&nbsp;</TH>
          </TR>
          <TR class= Spacing> 
            <TD class=line1Span=2></TD>
          </TR>
         <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
            <TD class=Field><%if((!isSelf)||(displayAll)){%>
			<button class=Browser id=SelectDeparment onClick="onShowDepartment()"></button> 
              <span class=inputStyle id=departmentspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></span> 
			  <%} else {%>
			  <%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%>
			  <%}%>
			  <input id=departmentid type=hidden name=departmentid value="<%=departmentid%>">
            </TD>
          </TR>
           <TR><TD class=Line colSpan=2></TD></TR> 
         <TR>             <TD><%=SystemEnv.getHtmlLabelName(425,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(426,user.getLanguage())%></TD>
            <TD class=Field><%if((!isSelf)||(displayAll)){%>
			<button class=Browser id=SelectCostCenter onClick="onShowCostCenter()"></button> 
              <span class=inputStyle id=costcenterspan><%=Util.toScreen(CostcenterComInfo.getCostCentername(costcenterid),user.getLanguage())%></span> 
			  <%} else {%>
			  <%=Util.toScreen(CostcenterComInfo.getCostCentername(costcenterid),user.getLanguage())%>
			  <%}%>   
			  <input id=costcenterid type=hidden name=costcenterid value="<%=costcenterid%>">
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(2120,user.getLanguage())%></TD>
            <TD class=Field><%if((!isSelf)||(displayAll)){%>
			<BUTTON class=Browser id=SelectManagerID onClick="onShowManagerID()"></BUTTON> 
              <span 
            id=manageridspan><%=Util.toScreen(ResourceComInfo.getResourcename(managerid),user.getLanguage())%></span> 
        	<%} else {%>
			<%=Util.toScreen(ResourceComInfo.getResourcename(managerid),user.getLanguage())%>
			<%}%>
			<INPUT class=inputStyle id=managerid  type=hidden name=managerid value="<%=managerid%>">
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD id=lblAss><%=SystemEnv.getHtmlLabelName(441,user.getLanguage())%></TD>
            <TD class=Field id=txtAss><%if((!isSelf)||(displayAll)){%>
			<BUTTON class=Browser 
            id=SelectAssistantID onClick="onShowAssistantID()"></BUTTON> <SPAN class=inputStyle 
            id=assistantidspan><%=Util.toScreen(ResourceComInfo.getResourcename(assistantid),user.getLanguage())%></SPAN>
			<%} else {%>
			<%=Util.toScreen(ResourceComInfo.getResourcename(assistantid),user.getLanguage())%>
			<%}%>
			<INPUT class=inputStyle id=assistantid  type=hidden name=assistantid value="<%=assistantid%>">
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          </TBODY>
        </TABLE>
      </TD>
    </TR>
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> 
         <COL width=30%> 
         <COL width=70%> 
           <TBODY> 
          <TR class=Title> 
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(389,user.getLanguage())%></TH>
          </TR>
          <TR class= Spacing> 
            <TD class=Line1 colSpan=2></TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(185,user.getLanguage())%> 1</TD>
            <TD class=Field><%if((!isSelf)||(displayAll)){%>
			 <button class=Browser id=SelectBank onClick="onShowBank(bankid1span,bankid1)"></button> 
              <span class=inputStyle id=bankid1span><%=Util.toScreen(BankComInfo.getBankname(bankid1),user.getLanguage())%></span> 
              
			  <%} else {%>
			  <%=Util.toScreen(BankComInfo.getBankname(bankid1),user.getLanguage())%>
			  <%}%>
			  <input id=bankid1 type=hidden name=bankid1 value=<%=bankid1%>>
            </TD>
          </TR>
         <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(389,user.getLanguage())%> 1</TD>
            <TD class=Field> <%if((!isSelf)||(displayAll)){%>
              <INPUT class=inputStyle maxLength=34 size=30 
            name=accountid1 value="<%=accountid1%>">
			<%} else {%>
			<%=accountid1%>
			<input type="hidden" name="accountid1" value="<%=accountid1%>">
			<%}%>
            </TD>
          </TR>
         <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(185,user.getLanguage())%> 2</td>
            <td class=Field><%if((!isSelf)||(displayAll)){%>
			 <button class=Browser id=SelectBank onClick="onShowBank(bankid2span,bankid2)"></button> 
              <span class=inputStyle id=bankid2span><%=Util.toScreen(BankComInfo.getBankname(bankid2),user.getLanguage())%></span> 
             
			  <%} else {%>
			  <%=Util.toScreen(BankComInfo.getBankname(bankid2),user.getLanguage())%>
			  <%}%>
			   <input id=bankid2 type=hidden name=bankid2 value=<%=bankid2%>>
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(389,user.getLanguage())%> 2</td>
            <td class=Field> <%if((!isSelf)||(displayAll)){%>
              <input class=inputStyle maxlength=34 size=30  name=accountid2 value="<%=accountid2%>">
			<%} else {%>
			<%=accountid2%>
			<input type="hidden" name="accountid2" value="<%=accountid2%>">
			<%}%>
            </td>
          </tr>
         <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(486,user.getLanguage())%></TD>
            <TD class=Field> <%if((!isSelf)||(displayAll)){%>
              <INPUT class=inputStyle maxLength=50 size=30 
            name=securityno value="<%=securityno%>">
			<%} else {%>
			<%=securityno%>
			<input type="hidden" name="securityno" value="<%=securityno%>">
			<%}%>
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1939,user.getLanguage())%></td>
            <td class=Field> <%if((!isSelf)||(displayAll)){%>
              <input class=inputStyle maxlength=60 size=30 
            name=accumfundaccount value="<%=accumfundaccount%>">
			<%} else {%>
			<%=accumfundaccount%>
			<input type="hidden" name="accumfundaccount" value="<%=accumfundaccount%>">
			<%}%>
            </td>
          </tr>
         <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(487,user.getLanguage())%></TD>
            <TD class=Field> <%if((!isSelf)||(displayAll)){%>
              <INPUT class=inputStyle maxLength=34 
            name=creditcard value="<%=creditcard%>">
			<%} else {%>
			<%=creditcard%>
			<input type="hidden" name="creditcard" value="<%=creditcard%>">
			<%}%>
            </TD>
          </TR>
         <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(488,user.getLanguage())%></TD>
            <TD class=Field><%if((!isSelf)||(displayAll)){%>
			<BUTTON class=Calendar type="button" id=SelectCreditcardExpirationDate onclick="getexpiryDate()"></BUTTON> 
              <SPAN id=expirydatespan ><%=expirydate%></SPAN> 
             
			  <%} else {%>
			  <%=expirydate%>
			  <%}%>
			   <input type="hidden" name="expirydate" value="<%=expirydate%>">
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          </TBODY> 
        </TABLE>
      </TD>
      <TD vAlign=top> 
        <TABLE class=viewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%></TH>
          </TR>
        <TR class= Spacing>
          <TD class=Line1 colSpan=2></TD></TR>
<%
boolean hasFF = true;
RecordSet.executeProc("Base_FreeField_Select","hr");
if(RecordSet.getCounts()<=0)
	hasFF = false;
else
	RecordSet.first();
	
if(hasFF)
{
	for(int i=1;i<=5;i++)
	{
		if(RecordSet.getString(i*2+1).equals("1"))
		{%>
        <TR>
          <TD><%=Util.toScreen(RecordSet.getString(i*2),user.getLanguage())%></TD>
          <TD class=Field><%if((!isSelf)||(displayAll)){%>
		  <BUTTON class=Calendar type="button" onclick="getHreDate(<%=i%>)"></BUTTON> 
              <SPAN id=datespan<%=i%> ><%=datefield[i-1]%></SPAN> 
               <%} else {%>
			  <%=datefield[i-1]%>
			   <%}%>
			   <input type="hidden" name="dff0<%=i%>" id="dff0<%=i%>" value="<%=datefield[i-1]%>">
			  </TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSet.getString(i*2+11).equals("1"))
		{%>
        <TR>
          <TD><%=Util.toScreen(RecordSet.getString(i*2+10),user.getLanguage())%></TD>
          <TD class=Field><%if((!isSelf)||(displayAll)){%>
		  <INPUT class=inputStyle maxLength=30 size=30 name="nff0<%=i%>" value="<%=numberfield[i-1]%>">
		  <%} else {%>
		  <%=numberfield[i-1]%>
		  <input type="hidden" name="nff0<%=i%>" value="<%=numberfield[i-1]%>">
		  <%}%>
		  </TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSet.getString(i*2+21).equals("1"))
		{%>
        <TR>
          <TD><%=Util.toScreen(RecordSet.getString(i*2+20),user.getLanguage())%></TD>
          <TD class=Field><%if((!isSelf)||(displayAll)){%>
		  <INPUT class=inputStyle maxLength=100 size=30 name="tff0<%=i%>" value="<%=Util.toScreen(textfield[i-1],user.getLanguage())%>">
		  <%} else {%>
		  <%=Util.toScreen(textfield[i-1],user.getLanguage())%>
		  <input type="hidden" name="tff0<%=i%>" value="<%=Util.toScreen(textfield[i-1],user.getLanguage())%>">
		  <%}%>
		  </TD>
        </TR>
      <TR><TD class=Line colSpan=2></TD></TR> 
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSet.getString(i*2+31).equals("1"))
		{%>
        <TR>
          <TD><%=Util.toScreen(RecordSet.getString(i*2+30),user.getLanguage())%></TD>
          <TD class=Field><%if((!isSelf)||(displayAll)){%>
		  <INPUT type=checkbox name="bff0<%=i%>" value="1" <%if(tinyintfield[i-1].equals("1")){%> checked<%}%>>
		  <%} else {%>
		  <INPUT type=checkbox name="bff0<%=i%>" value="1" <%if(tinyintfield[i-1].equals("1")){%> checked<%}%> disabled>
		  <%}%>
		  </TD>
        </TR>
     <TR><TD class=Line colSpan=2></TD></TR> 
    <%}
	}
}
%>
<input type=hidden name=seclevel2 value=<%=seclevel2%>>
<input type=hidden name=departmentid2 value=<%=departmentid2%>>
<input type=hidden name=managerid2 value=<%=managerid%>>
        </TBODY>
	  </TABLE>
      </TD>
    </TR>
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
<script language=vbs>
sub onShowDefaultLanguage()
	id = window.showModalDialog("/systeminfo/language/LanguageBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	defaultlanguagespan.innerHtml = id(1)
	resource.defaultlanguage.value=id(0)
	else
	defaultlanguagespan.innerHtml = ""
	resource.defaultlanguage.value=""
	end if
	end if
end sub

sub onShowSystemLanguage()
	id = window.showModalDialog("/systeminfo/language/LanguageBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	systemlanguagespan.innerHtml = id(1)
	resource.systemlanguage.value=id(0)
	else
	systemlanguagespan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.systemlanguage.value=""
	end if
	end if
end sub

sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&resource.departmentid.value)
	issame = false 
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	if id(0) = resource.departmentid.value then
		issame = true 
	end if
	departmentspan.innerHtml = id(1)
	resource.departmentid.value=id(0)
	else
	departmentspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.departmentid.value=""
	end if
	if issame = false then
			costcenterspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			resource.costcenterid.value=""
	end if
	end if
end sub


sub onShowCostCenter()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/CostcenterBrowser.jsp?sqlwhere= where departmentid="&resource.departmentid.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	costcenterspan.innerHtml = id(1)
	resource.costcenterid.value=id(0)
	else 
	costcenterspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.costcenterid.value=""
	end if
	end if
end sub

sub onShowManagerID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	manageridspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.managerid.value=id(0)
	else 
	manageridspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.managerid.value=""
	end if
	end if
end sub

sub onShowAssistantID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	assistantidspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.assistantid.value=id(0)
	else 
	assistantidspan.innerHtml = ""
	resource.assistantid.value=""
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
	currencyidspan.innerHtml = ""
	resource.currencyid.value=""
	end if
	end if
end sub

sub onShowNationality()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	nationalityspan.innerHtml = id(1)
	resource.nationality.value=id(0)
	else 
	nationalityspan.innerHtml = ""
	resource.nationality.value=""
	end if
	end if
end sub

sub onShowCountryID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	countryidspan.innerHtml = id(1)
	resource.countryid.value=id(0)
	else 
	countryidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.countryid.value=""
	end if
	end if
end sub

sub onShowLocationID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/location/LocationBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	locationidspan.innerHtml = id(1)
	resource.locationid.value=id(0)
	else 
	locationidspan.innerHtml = ""
	resource.locationid.value=""
	end if
	end if
end sub

sub onShowJobtitle()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	jobtitlespan.innerHtml = id(1)
	resource.jobtitle.value=id(0)
	else 
	jobtitlespan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.jobtitle.value=""
	end if
	end if
end sub

sub onShowTitleID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/ContacterTitleBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	titleidspan.innerHtml = id(1)
	resource.titleid.value=id(0)
	else 
	titleidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.titleid.value=""
	end if
	end if
end sub

sub onShowBank(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/finance/BankBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = id(1)
	inputname.value=id(0)
	else 
	spanname.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub

sub onShowRegresidentplace()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	regresidentplacespan.innerHtml = id(1)
	resource.regresidentplace.value=id(0)
	else 
	regresidentplacespan.innerHtml = ""
	resource.regresidentplace.value=""
	end if
	end if
end sub

sub onShowResidentplace()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	residentplacespan.innerHtml = id(1)
	resource.residentplace.value=id(0)
	else 
	residentplacespan.innerHtml = ""
	resource.residentplace.value=""
	end if
	end if
end sub

sub onShowUsekind()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/usekind/UseKindBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	usekindspan.innerHtml = id(1)
	resource.usekind.value=id(0)
	else 
	usekindspan.innerHtml = ""
	resource.usekind.value=""
	end if
	end if
end sub

sub getContractbegintimeDate()
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	Contractbegintimespan.innerHtml= returndate
	resource.Contractbegintime.value=returndate
end sub

sub onShowJobType()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtype/JobtypeBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	jobtypespan.innerHtml = id(1)
	resource.jobtype.value=id(0)
	else 
	jobtypespan.innerHtml = ""
	resource.jobtype.value=""
	end if
	end if
end sub

sub onShowJobCall()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobcall/JobcallBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	jobcallspan.innerHtml = id(1)
	resource.jobcall.value=id(0)
	else 
	jobcallspan.innerHtml = ""
	resource.jobcall.value=""
	end if
	end if
end sub

</script>

<Script language="javascript">
function onDelPic(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(8,user.getLanguage())%>")) {
		document.resource.operation.value="delpic";
		document.resource.submit();
	}
}

function doSave() {
    if(check_form(document.resource,"loginid,password,lastname,titleid,systemlanguage,countryid,jobtitle,departmentid,costcenterid,managerid,seclevel")) {
		if(document.resource.password.value != document.resource.confirmpassword.value)  {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15803,user.getLanguage())%>!") ;
			return ;
		}
		document.resource.submit()  ;
	}
}
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>