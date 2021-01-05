
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";


String optionid= Util.fromScreen(request.getParameter("optionid"),user.getLanguage());

String userid = user.getUID()+"";

String votingid ="";
String questionid ="";
String desc ="";
String showorder = "";

RecordSet.executeProc("VotingOption_SelectByID",optionid);
if(RecordSet.next()){
    votingid = RecordSet.getString("votingid");
    questionid = RecordSet.getString("questionid");
    desc = RecordSet.getString("description");
    showorder = RecordSet.getString("showorder");
}

String questionname ="";
RecordSet.executeProc("VotingQuestion_SelectByID",questionid);
if(RecordSet.next()){
    questionname = RecordSet.getString("subject");
}
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<% 
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:window.close(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=frmmain name=frmmain action="VotingOptionOperation.jsp" method=post onsubmit="return check_form(this,'subject')">
<input type="hidden" name="method" value="edit">
<input type="hidden" name="questionid" value="<%=questionid%>">
<input type="hidden" name="votingid" value="<%=votingid%>">
<input type="hidden" name="optionid" value="<%=optionid%>">
<TABLE width=100% height=100% border="0" cellspacing="0">
      <colgroup>
        <col width="5">
          <col width="">
            <col width="5">
              <tr>
                <td height="5" colspan="3"></td>
              </tr>
              <tr>
                <td></td>
                <td valign="top">  
                <form name="frmSubscribleHistory" method="post" action="">
                  <TABLE class=Shadow>
                    <tr>
                      <td valign="top">
<table class=viewForm>
  <col width="20%"><col width="80%">
  <TR><TH colSpan=2><div align="left"><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%>:<%=questionname%></div></TH></TR>
  <TR style="height: 1px!important;"><TD  class="line1" colSpan=2></TD></TR>
  <tr>
	<td><%=SystemEnv.getHtmlLabelName(1025,user.getLanguage())%></td>
	<td class=field>
	    <input type="input" name="desc" class="inputStyle" onchange="checkinput('desc','descspan')" style="width:80%" value="<%=Util.toScreenToEdit(desc,user.getLanguage())%>">
	    <span id="descspan"></span>
	</td>
  </tr>
<TR style="height: 1px!important;"><TD  class="line" colSpan=2></TD></TR>
<tr>	
	<td><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></td>
	<td class=field>
	    <input type="input" class=inputStyle name="showorder" value="<%=showorder%>" style="width=20%">
	</td>
  </tr>
  <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
</table>  

                     </td>
                    </tr>
                  </TABLE>  
                  </form>
                </td>
                <td></td>
              </tr>
              <tr>
                <td height="5" colspan="3"></td>
              </tr>
            </table>
</body>


<script language=javascript>
function onSave(){
   if(check_form(document.frmmain,"desc")){
	   document.frmmain.submit();
   }

	
}
 function doDelete(){
	if(confirm("SystemEnv.getHtmlLabelName(82017,user.getLanguage()) ")) {
		document.frmmain.method.value="delete";
		document.frmmain.submit();
	}
}
</script>
</html>