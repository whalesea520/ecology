
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="UseKindComInfo" class="weaver.hrm.job.UseKindComInfo" scope="page" />
<%@ include file="/systeminfo/ParameterFilter.jsp"%>
<%
	int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
	String isDialog = Util.null2String(request.getParameter("isdialog"));
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
	
	String careereduname = "";
	if(!"".equals(careeredu)){
		RecordSet.executeSql("select * from HrmEducationLevel  where id= "+careeredu);
		RecordSet.next();
		careereduname = Util.toScreen(RecordSet.getString("name"),7);
	}
%>
<HTML>
	<HEAD>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
		</script>
</head>
<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
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

  <DIV><BUTTON class=btnSave accessKey=S onclick='location.href="/pweb/careerapply/HrmCareerApplyAdd.jsp?careerid=<%=careerinviteid%>"'><U>S</U>-<%=SystemEnv.getHtmlLabelName(1863,user.getLanguage())%></BUTTON> 
<!-- <BUTTON class=btn  accessKey=R onclick='location.href="/pweb/careerapply/HrmCareerInviteWeb.jsp?"'><U>R</U>-<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%></BUTTON> -->
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
            <td ><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></td>
            <td class=Field ><%=JobTitlesComInfo.getJobTitlesname(careername)%>
	    </td>
          </tr>
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1864,user.getLanguage())%></td>
            <td class=Field> <%=careerpeople%>
            </td>
          </tr>
<!--          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1865,7)%></td>
            <td class=Field><%=careerclass%>
            </td>
          </tr>
-->          
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(804,user.getLanguage())%></td>
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
		<%=careereduname %>
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
	<%if("1".equals(isDialog)){ %>
		</div>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom" align="center">
			<wea:layout type="2col">
		    	<wea:group context="">
			    	<wea:item type="toolbar">
			    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="dialog.closeByHand();">
			    	</wea:item>
			   	</wea:group>
		  	</wea:layout>
		</div>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				resizeDialog(document);
			});
		</script>
	<%} %>
</BODY></HTML>
