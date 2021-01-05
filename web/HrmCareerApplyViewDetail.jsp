<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
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
String paraid = Util.null2String(request.getParameter("paraid")) ;
String careerinviteid = paraid ;

RecordSet.executeProc("HrmCareerInvite_SelectById",careerinviteid);
RecordSet.next();

String careerpeople = Util.null2String(RecordSet.getString("careerpeople"));
String careerage = Util.null2String(RecordSet.getString("careerage"));
String careersex = Util.null2String(RecordSet.getString("careersex"));
String careeredu = Util.null2String(RecordSet.getString("careeredu"));
String careermode = Util.null2String(RecordSet.getString("careermode"));
String careername = Util.toScreen(RecordSet.getString("careername"),7);
String careeraddr = Util.toScreen(RecordSet.getString("careeraddr"),7);
String careerclass = Util.toScreen(RecordSet.getString("careerclass"),7);
String careerdesc = Util.toScreen(RecordSet.getString("careerdesc"),7);
String careerrequest = Util.toScreen(RecordSet.getString("careerrequest"),7);
String careerremark = Util.toScreen(RecordSet.getString("careerremark"),7);

%>
<BODY>
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,7)%>
</font>
</DIV>
<%}%>
<FORM name=frmain action=HrmCareerInviteOperation.jsp? method=post>
  <DIV><BUTTON class=btnSave accessKey=S onclick='location.href="/web/careerapply/HrmCareerApplyAdd.jsp?careerid=<%=careerinviteid%>"'><U>S</U>-<%=SystemEnv.getHtmlLabelName(1863,7)%></BUTTON> 
<BUTTON class=btn  accessKey=R onclick='location.href="HrmCareerInviteWeb.jsp?"'><U>R</U>-<%=SystemEnv.getHtmlLabelName(1290,7)%></BUTTON>
</DIV>
<input type="hidden" name="operation" value="editcareerinvite">
<input type="hidden" name="careerinviteid" value="<%=careerinviteid%>">

  <table class=Form>
    <colgroup> <col width="49%"> <col width=10> <col width="49%"> <tbody> 
    <tr> 
      <td valign=top> 
        <table width="100%">
          <colgroup> <col width=25%> <col width=75%><tbody> 
          <tr class=Section> 
            <th colspan=2 >
              <div align="left"><%=SystemEnv.getHtmlLabelName(357,7)%></div>
            </th>
          </tr>
          <tr class=Separator> 
            <td height="1" background="/web/images/bg_hdotline_wev8.gif" colspan=2></td>
          </tr>
          <tr> 
            <td >岗位</td>
            <td bgcolor="F6F6F6" ><%=JobTitlesComInfo.getJobTitlesname(careername)%>
	    </td>
          </tr>
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1864,7)%></td>
            <td bgcolor="F6F6F6"> <%=careerpeople%>
            </td>
          </tr>
<!--          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1865,7)%></td>
            <td bgcolor="F6F6F6"><%=careerclass%>
            </td>
          </tr>
-->          
          <tr> 
            <td>用工性质</td>
            <td bgcolor="F6F6F6"><%=UseKindComInfo.getUseKindname(careermode)%>
            </td>
          </tr>
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(419,7)%></td>
            <td bgcolor="F6F6F6"> <%=careeraddr%>
            </td>
          </tr>
             </tbody> 
        </table>
      </td>
      <td valign=top> 
        <table width="100%">
          <colgroup> <col width=25%> <col width=75%> <tbody> 
          <tr class=Section> 
            <th colspan=2>
              <div align="left"><%=SystemEnv.getHtmlLabelName(1867,7)%></div>
            </th>
          </tr>
          <tr class=Separator> 
            <td height="1" background="/web/images/bg_hdotline_wev8.gif" colspan=2></td>
          </tr>
          <tr> 
            <td width><%=SystemEnv.getHtmlLabelName(416,7)%></td>
      <TD width=35% bgcolor="F6F6F6">
		<%if (careersex.equals("0")){%><%=SystemEnv.getHtmlLabelName(417,7)%><%}%>
		<%if (careersex.equals("1")){%><%=SystemEnv.getHtmlLabelName(418,7)%><%}%>
		<%if (careersex.equals("2")){%><%=SystemEnv.getHtmlLabelName(763,7)%><%}%>
		</TD>
            </td>
          </tr>
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(671,7)%></td>
            <td bgcolor="F6F6F6"> <%=careerage%>
            </td>
          </tr>
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1860,7)%></td>
      <TD width=40% bgcolor="F6F6F6">
		<%if (careeredu.equals("0")){%><%=SystemEnv.getHtmlLabelName(764,7)%><%}%>
		<%if (careeredu.equals("1")){%><%=SystemEnv.getHtmlLabelName(765,7)%><%}%>
		<%if (careeredu.equals("2")){%><%=SystemEnv.getHtmlLabelName(766,7)%><%}%>
		<%if (careeredu.equals("3")){%><%=SystemEnv.getHtmlLabelName(767,7)%><%}%>
		<%if (careeredu.equals("4")){%><%=SystemEnv.getHtmlLabelName(768,7)%><%}%>
		<%if (careeredu.equals("5")){%><%=SystemEnv.getHtmlLabelName(769,7)%><%}%>
		<%if (careeredu.equals("6")){%><%=SystemEnv.getHtmlLabelName(763,7)%><%}%>
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
            <TH><%=SystemEnv.getHtmlLabelName(1858,7)%></TH>
          </TR>
          <TR class=Separator> 
            <TD height="1" background="/web/images/bg_hdotline_wev8.gif"></TD>
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
              <p><%=SystemEnv.getHtmlLabelName(1868,7)%></p>
              </TH>
          </TR>
          <TR class=Separator> 
            <TD height="1" background="/web/images/bg_hdotline_wev8.gif"></TD>
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
            <TH><%=SystemEnv.getHtmlLabelName(454,7)%></TH>
          </TR>
          <TR class=Separator> 
            <TD height="1" background="/web/images/bg_hdotline_wev8.gif"></TD>
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
