<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="UseKindComInfo" class="weaver.hrm.job.UseKindComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
char separator = Util.getSeparator() ;
boolean canedit = HrmUserVarify.checkUserRight("HrmCareerInviteEdit:Edit", user) ;
String paraid = Util.null2String(request.getParameter("paraid")) ;
String careerinviteid = paraid ;

RecordSet.executeProc("HrmCareerInvite_SelectById",careerinviteid);
RecordSet.next();

String careerpeople = Util.null2String(RecordSet.getString("careerpeople"));
String careerage = Util.null2String(RecordSet.getString("careerage"));
String careersex = Util.null2String(RecordSet.getString("careersex"));
String careeredu = Util.null2String(RecordSet.getString("careeredu"));
String careermode = Util.null2String(RecordSet.getString("careermode"));
String careername = Util.toScreen(RecordSet.getString("careername"),user.getLanguage());
String careeraddr = Util.toScreen(RecordSet.getString("careeraddr"),user.getLanguage());
String careerclass = Util.toScreen(RecordSet.getString("careerclass"),user.getLanguage());
String careerdesc = Util.toScreen(RecordSet.getString("careerdesc"),user.getLanguage());
String careerrequest = Util.toScreen(RecordSet.getString("careerrequest"),user.getLanguage());
String careerremark = Util.toScreen(RecordSet.getString("careerremark"),user.getLanguage());

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(366,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps></DIV>
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<FORM name=frmain action=HrmCareerInviteOperation.jsp? method=post>
  <DIV><BUTTON class=btnSave accessKey=S onclick='location.href="/hrm/career/HrmCareerApplyAdd.jsp?careerid=<%=careerinviteid%>"'><U>S</U>-<%=SystemEnv.getHtmlLabelName(1863,user.getLanguage())%></BUTTON> 
<BUTTON class=btn  accessKey=R onclick='location.href="HrmCareerInviteWeb.jsp?"'><U>R</U>-<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%></BUTTON>
</DIV>
<input type="hidden" name="operation" value="editcareerinvite">
<input type="hidden" name="careerinviteid" value="<%=careerinviteid%>">

  <table class=Form>
    <colgroup> <col width="49%"> <col width=10> <col width="49%"> <tbody> 
    <tr> 
      <td valign=top> 
        <table width="100%">
          <colgroup> <col width=15%> <col width=85%><tbody> 
          <tr class=Section> 
            <th colspan=2 >
              <div align="left"><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%></div>
            </th>
          </tr>
          <tr class=Separator> 
            <td class=Sep1 colspan=2></td>
          </tr>
          <tr> 
            <td >岗位</td>
            <td class=Field ><%=JobTitlesComInfo.getJobTitlesname(careername)%>
	    </td>
          </tr>
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1864,user.getLanguage())%></td>
            <td class=Field> <%=careerpeople%>
            </td>
          </tr>
<!--          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1865,user.getLanguage())%></td>
            <td class=Field><%=careerclass%>
            </td>
          </tr>
-->          
          <tr> 
            <td>用工性质</td>
            <td class=Field><%=UseKindComInfo.getUseKindname(careermode)%>
            </td>
          </tr>
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(419,user.getLanguage())%></td>
            <td class=Field> <%=careeraddr%>
            </td>
          </tr>
             </tbody> 
        </table>
      </td>
      <td valign=top> 
        <table width="100%">
          <colgroup> <col width=15%> <col width=85%> <tbody> 
          <tr class=Section> 
            <th colspan=2>
              <div align="left"><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></div>
            </th>
          </tr>
          <tr class=Separator> 
            <td class=Sep1 colspan=2></td>
          </tr>
          <tr> 
            <td width><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></td>
      <TD width=35% class=field>
		<%if (careersex.equals("0")){%><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%><%}%>
		<%if (careersex.equals("1")){%><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%><%}%>
		<%if (careersex.equals("2")){%><%=SystemEnv.getHtmlLabelName(763,user.getLanguage())%><%}%>
		</TD>
            </td>
          </tr>
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(671,user.getLanguage())%></td>
            <td class=Field> <%=careerage%>
            </td>
          </tr>
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1860,user.getLanguage())%></td>
      <TD width=40% class=field>
		<%if (careeredu.equals("0")){%><%=SystemEnv.getHtmlLabelName(764,user.getLanguage())%><%}%>
		<%if (careeredu.equals("1")){%><%=SystemEnv.getHtmlLabelName(765,user.getLanguage())%><%}%>
		<%if (careeredu.equals("2")){%><%=SystemEnv.getHtmlLabelName(766,user.getLanguage())%><%}%>
		<%if (careeredu.equals("3")){%><%=SystemEnv.getHtmlLabelName(767,user.getLanguage())%><%}%>
		<%if (careeredu.equals("4")){%><%=SystemEnv.getHtmlLabelName(768,user.getLanguage())%><%}%>
		<%if (careeredu.equals("5")){%><%=SystemEnv.getHtmlLabelName(769,user.getLanguage())%><%}%>
		<%if (careeredu.equals("6")){%><%=SystemEnv.getHtmlLabelName(763,user.getLanguage())%><%}%>
		</TD>
          </tr>
          </tbody> 
        </table>
      </td>
    </tr>
    <tr> 
      <td  colspan="2"> 
<TABLE class=Form>
          <TBODY> 
          <TR class=Section> 
            <TH><%=SystemEnv.getHtmlLabelName(1858,user.getLanguage())%></TH>
          </TR>
          <TR class=Separator> 
            <TD class=sep2></TD>
          </TR>
          <TR> 
            <TD vAlign=top> <%=careerdesc%>
            </TD>
          </TR>
          </TBODY> 
        </TABLE>
       <TABLE class=Form>
          <TBODY> 
          <TR class=Section> 
            <TH>
              <p><%=SystemEnv.getHtmlLabelName(1868,user.getLanguage())%></p>
              </TH>
          </TR>
          <TR class=Separator> 
            <TD class=sep2></TD>
          </TR>
          <TR> 
            <TD vAlign=top> <%=careerrequest%>
            </TD>
          </TR>
          </TBODY> 
        </TABLE>
		<TABLE class=Form>
          <TBODY> 
          <TR class=Section> 
            <TH><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TH>
          </TR>
          <TR class=Separator> 
            <TD class=sep2></TD>
          </TR>
          <TR> 
            <TD vAlign=top> <%=careerremark%>
            </TD>
          </TR>
          </TBODY> 
        </TABLE>
      </td>
    </tr>
    </tbody> 
  </table>
</FORM>
</BODY></HTML>
