
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
String titlename = SystemEnv.getHtmlLabelName(17599,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(18615,user.getLanguage());
String needfav ="1";
String needhelp ="";

String questionid=Util.fromScreen(request.getParameter("questionid"),user.getLanguage());
String questionname ="";
String votingid ="";
RecordSet.executeProc("VotingQuestion_SelectByID",questionid);
if(RecordSet.next()){
    questionname = RecordSet.getString("subject");
    votingid = RecordSet.getString("votingid");
}
int rowindex=0;
%>
<BODY>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<% 
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:window.doSave(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:window.close(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=frmmain name=frmmain action="/voting/VotingOptionOperation.jsp" method=post>
<input type="hidden" name="method" value="add">
<input type="hidden" name="nodesnum" value="1">
<input type="hidden" name="votingid" value="<%=votingid%>">
<input type="hidden" name="questionid" value="<%=questionid%>">
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

<table Class=ListShort>
  <TR class=Section><TH><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%>:<%=questionname%></TH></TR>
  <TR>
      <TD><hr></TD>
  </TR>
  <TR>
      <TD>
           <DIV>
            <BUTTON class=btnNew type="button" accessKey=A onclick="addRow()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON> 
            <BUTTON class=btnDelete type="button" accessKey=D onclick="if(isdel()){deleteRow();}"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>	
          </DIV>
      </TD>
  </TR> 
  <tr><td>
    <table class=ListShort cols=1 id="oTable">   
    <tr><td>
        <table class=form style="table-layout: fixed;">
        <col width="8%"><col width="84%"><col width="8%">
        <tr class=header>
            <td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></td>
        </tr>
        </table>
    </td></tr>
    <tr><td>
        <table class=form style="table-layout: fixed;">
        <col width="8%"><col width="84%"><col width="8%">
        <tr>
          <td class=field><input type=checkbox class="inputStyle" name="check_option" value="<%=rowindex%>"></td>
          <td class=field>
    	    <input type="input" name="desc_<%=rowindex%>" class="inputStyle" onchange="checkinput1(desc_<%=rowindex%>,descspan_<%=rowindex%>)" style="width:85%"><span id="descspan_<%=rowindex%>"><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>
    	  </td>
    	  <td class=field>
    	    <input type="input" class=inputStyle name="showorder_<%=rowindex%>" style="width:80%">
    	  </td>
        </tr>
        <table>
    </td></tr>
    <%rowindex++;%>
    </table>
  </td></tr>
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
rowindex = "<%=rowindex%>";
function addRow()
{
	ncol = oTable.rows.item(0).cells.length ;
	oRow = oTable.insertRow(-1);
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1); 
		oCell.style.height=24;
		oCell.style.background= "#efefef";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<table class=form><col width='8%'><col width='84%'><col width='8%'>"+
	            "<tr>"+
	            "<td class=field><input type='checkbox' class=inputStyle name='check_option' value="+rowindex+">"+
	            "</td>"+
	            "<td class=field><input type='input' class=inputStyle  name='desc_"+rowindex+"' onchange='checkinput1(desc_"+rowindex+",descspan_"+rowindex+")' style='width:85%'>"+ 
	            "<span id='descspan_"+rowindex+"'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>"+
	            "</td>"+
	            "<td class=field><input type='input' class=inputStyle name='showorder_"+rowindex+"' style='width:80%'></td>"+
                "</tr></table>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	rowindex = rowindex*1 +1;
}

function deleteRow()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_option')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_option'){
			if(document.forms[0].elements[i].checked==true) {
				oTable.deleteRow(rowsum1);	
			}
			rowsum1 -=1;
		}
	
	}	
}

function doSave(){
	parastr = "" ;
	len = document.forms[0].elements.length;
	var i=0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_option')
			parastr+=",desc_"+document.forms[0].elements[i].value;
	}
	if(parastr!="") parastr=parastr.substring(1);
	if(check_form(document.frmmain,parastr)){
		document.frmmain.nodesnum.value=rowindex;
		document.frmmain.submit();
		window.close();
	}
}
</script>
</html>