<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ContacterTitleComInfo" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String resourceid = Util.null2String(request.getParameter("resourceid"));

RecordSet.executeProc("HrmResource_SelectByID",resourceid);
RecordSet.next();
String firstname = Util.toScreen(RecordSet.getString("firstname"),user.getLanguage()) ;			/*名*/
String lastname = Util.toScreen(RecordSet.getString("lastname"),user.getLanguage()) ;			/*姓*/
String titleid = Util.toScreen(RecordSet.getString("titleid"),user.getLanguage()) ;
String birthday = Util.toScreen(RecordSet.getString("birthday"),user.getLanguage()) ;			/*生日*/
String certificatecategory = Util.toScreenToEdit(RecordSet.getString("certificatecategory"),user.getLanguage()) ;/**/
String certificatenum = Util.toScreenToEdit(RecordSet.getString("certificatenum"),user.getLanguage()) ;			/*证件号码*/
String bememberdate = Util.toScreenToEdit(RecordSet.getString("bememberdate"),user.getLanguage()) ;				/*入团日期*/
String bepartydate = Util.toScreenToEdit(RecordSet.getString("bepartydate"),user.getLanguage()) ;				/*入党日期*/
String bedemocracydate = Util.toScreenToEdit(RecordSet.getString("bedemocracydate"),user.getLanguage()) ;		/*民主日期*/
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
String train = Util.toScreenToEdit(RecordSet.getString("train"),user.getLanguage()) ;							/*培训及持有证书*/
String maritalstatus = Util.toScreenToEdit(RecordSet.getString("maritalstatus"),user.getLanguage()) ;
/*
婚姻状况:
0:未婚
1:已婚
2:离异
3:同居
*/
String marrydate = Util.toScreenToEdit(RecordSet.getString("marrydate"),user.getLanguage()) ;			/*结婚日期*/
String homeaddress = Util.toScreenToEdit(RecordSet.getString("homeaddress"),user.getLanguage()) ;				/*家庭地址*/
String homepostcode = Util.toScreenToEdit(RecordSet.getString("homepostcode"),user.getLanguage()) ;				/*家庭邮编*/
String homephone = Util.toScreenToEdit(RecordSet.getString("homephone"),user.getLanguage()) ;				/*家庭电话*/
/*altered at 2002-09-03*/
String birthplace = Util.toScreenToEdit(RecordSet.getString("birthplace"),user.getLanguage()) ;						/*出生地*/
String folk = Util.toScreenToEdit(RecordSet.getString("folk"),user.getLanguage()) ;									/*民族*/
String residentphone = Util.toScreenToEdit(RecordSet.getString("residentphone"),user.getLanguage()) ; 	             /*现居住地电话*/
String residentpostcode = Util.toScreenToEdit(RecordSet.getString("residentpostcode"),user.getLanguage()) ;			/*现居住地邮编*/


/*显示权限判断*/

boolean isSelf		=	false;
boolean displayAll	=	false;

if(HrmUserVarify.checkUserRight("HrmResource:Display",user))  {
	displayAll		=	true;
}

if (resourceid.equals(""+user.getUID()) ){
	isSelf = true;
}

if(!(displayAll||isSelf)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<TR><TD 
style="FONT-WEIGHT: bold; COLOR: red"></TD></TR>
<BUTTON class=btn accessKey=B onclick='window.history.back(-1)'><U>B</U>-<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%></BUTTON>

<TABLE class=Form width="100%">

  <TBODY>
  <TR>
    <TD vAlign=top width="100%"> 
      <TABLE width="100%">
        <COLGROUP> <COL width="17%"> <COL width="83%"> <TBODY> 
        <TR class=Section> 
          <TH colSpan=2><%=SystemEnv.getHtmlLabelName(411,user.getLanguage())%></TH>
        </TR>
        <TR class=Separator> 
          <TD class=Sep1 colSpan=2></TD>
        </TR>
        <TR> 
          <TD><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(462,user.getLanguage())%></TD>
          <TD class=Field><%=firstname%> <%=lastname%>, <a href="/CRM/Maint/EditContacterTitle.jsp?id=<%=titleid%>"><%=Util.toScreen(ContacterTitleComInfo.getContacterTitlename(titleid),user.getLanguage())%></a></TD>
        </TR>
        <TR> 
          <TD><%=SystemEnv.getHtmlLabelName(1964,user.getLanguage())%></TD>
          <TD class=FIELD><%=birthday%></TD>
        </TR>
        <tr> 
          <td><%=SystemEnv.getHtmlLabelName(1826,user.getLanguage())%></td>
          <td class=Field> <%=height%> </td>
        </tr>
        <TR> 
          <TD><%=SystemEnv.getHtmlLabelName(1827,user.getLanguage())%></TD>
          <TD class=FIELD> 
            <% if(healthinfo.equalsIgnoreCase("0")) {%>
            <%=SystemEnv.getHtmlLabelName(824,user.getLanguage())%> 
            <%} if(healthinfo.equalsIgnoreCase("1")) {%>
            <%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%> 
            <%} if(healthinfo.equalsIgnoreCase("2")) {%>
            <%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%> 
            <%} if(healthinfo.equalsIgnoreCase("3")) {%>
            <%=SystemEnv.getHtmlLabelName(825,user.getLanguage())%> 
            <%}%>
          </TD>
        </TR>
        <TD><%=SystemEnv.getHtmlLabelName(469,user.getLanguage())%></TD>
        <TD class=FIELD> 
          <% if(maritalstatus.equalsIgnoreCase("0")) {%>
          <%=SystemEnv.getHtmlLabelName(470,user.getLanguage())%> 
          <%} if(maritalstatus.equalsIgnoreCase("1")) {%>
          <%=SystemEnv.getHtmlLabelName(471,user.getLanguage())%> 
          <%} if(maritalstatus.equalsIgnoreCase("2")) {%>
          <%=SystemEnv.getHtmlLabelName(472,user.getLanguage())%> 
          <%} if(maritalstatus.equalsIgnoreCase("3")) {%>
          <%=SystemEnv.getHtmlLabelName(473,user.getLanguage())%> 
          <%}%>
        </TD>
        </TR>
<!--
        <TR> 
          <td><%=SystemEnv.getHtmlLabelName(1965,user.getLanguage())%></td>
          <td class=Field> <%=marrydate%></td>
        </TR>
-->
        <TR> 
          <TD><%=SystemEnv.getHtmlLabelName(1833,user.getLanguage())%></TD>
          <TD class=FIELD><%=degree%></TD>
        </TR>
        <tr> 
          <td><%=SystemEnv.getHtmlLabelName(1966,user.getLanguage())%><br>
          </td>
          <td class=Field> <%=bememberdate%>, <%=bepartydate%></td>
        </tr>
<!--
        <tr> 
          <td><%=SystemEnv.getHtmlLabelName(1836,user.getLanguage())%></td>
          <td class=Field> <%=bedemocracydate%> </td>
        </tr>
-->
        <TR> 
          <TD><%=SystemEnv.getHtmlLabelName(1837,user.getLanguage())%></TD>
          <TD class=FIELD><%=policy%></TD>
        </TR>
        <TR> 
          <TD><%=SystemEnv.getHtmlLabelName(1838,user.getLanguage())%></TD>
          <TD class=FIELD><%=certificatecategory%></TD>
        </TR>
        <TR> 
          <TD><%=SystemEnv.getHtmlLabelName(1839,user.getLanguage())%></TD>
          <TD class=FIELD><%=certificatenum%></TD>
        </TR>
        <tr> 
          <td><%=SystemEnv.getHtmlLabelName(1886,user.getLanguage())%></td>
          <td class=Field> 
            <%=folk%>
          </td>
        </tr>
        <tr> 
          <td><%=SystemEnv.getHtmlLabelName(1885,user.getLanguage())%></td>
          <td class=Field> <%=birthplace%> </td>
        </tr>
        <tr> 
          <td><%=SystemEnv.getHtmlLabelName(1829,user.getLanguage())%></td>
          <td class=FIELD><%=residentplace%></td>
        </tr>
        <tr> 
          <td><%=SystemEnv.getHtmlLabelName(1930,user.getLanguage())%></td>
          <td class=Field> <%=residentphone%> </td>
        </tr>
        <tr> 
          <td><%=SystemEnv.getHtmlLabelName(1931,user.getLanguage())%></td>
          <td class=Field> <%=residentpostcode%> </td>
        </tr>
        <tr> 
          <td><%=SystemEnv.getHtmlLabelName(1967,user.getLanguage())%></td>
          <td class=FIELD><%=homeaddress%></td>
        </tr>
        <tr> 
          <td><%=SystemEnv.getHtmlLabelName(1968,user.getLanguage())%></td>
          <td class=Field> <%=homepostcode%> </td>
        </tr>
        <tr class="Form"> 
          <td><%=SystemEnv.getHtmlLabelName(1969,user.getLanguage())%></td>
          <td class=Field><%=homephone%></td>
        </tr>
        <tr class="Form"> 
          <td><%=SystemEnv.getHtmlLabelName(1841,user.getLanguage())%></td>
          <td class=Field><%=train%></td>
        </tr>
        </TBODY> 
      </TABLE>
    </TD>
    </TBODY></TABLE>
</BODY>

</HTML>
