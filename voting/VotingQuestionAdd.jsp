
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
String titlename = SystemEnv.getHtmlLabelName(17599,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(18614,user.getLanguage());
String needfav ="1";
String needhelp ="";

String votingid=Util.fromScreen(request.getParameter("votingid"),user.getLanguage());
String votingname ="";
RecordSet.executeProc("Voting_SelectByID",votingid);
if(RecordSet.next()){
    votingname = RecordSet.getString("subject");
}
int rowindex=0;
%>
<BODY>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<% 
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:window.close(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=frmmain name=frmmain action="VotingQuestionOperation.jsp" method=post>
<input type="hidden" name="method" value="add">
<input type="hidden" name="nodesnum" value="1">
<input type="hidden" name="votingid" value="<%=votingid%>">
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
<table Class=listStyle>
  <TR><TH><div align="left"><%=SystemEnv.getHtmlLabelName(17599,user.getLanguage())%>:<%=votingname%></div></TH></TR>
  <TR><TD><hr></TD></TR>
  <tr><td>
  <DIV>
	<BUTTON class=btnNew type="button" accessKey=A onclick="addRow()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
	<BUTTON class=btnDelete type="button" accessKey=D onclick="if(isdel()){deleteRow();}"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>	
  </DIV>
    <table class=ListShort cols=1 id="oTable">
    <tr><td>
        <table class=form style="table-layout: fixed">
        <col width="8%"><col width="20%"><col width="32%"><col width="10%"><col width="12%"><col width="12%"><col width="6%">
        <tr class=header>
            <td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(15205,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(21725,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(18603,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></td>
        </tr>
        </table>
    </td></tr>
    <tr><td>
        <table class=form style="table-layout: fixed;">
        <colgroup>
        <col width="8%"><col width="20%"><col width="32%"><col width="10%"><col width="12%"><col width="12%"><col width="6%">
        <tr>
          <td class=field><input type=checkbox class=inputStyle name="check_question" value="<%=rowindex%>"></td>
          <td class=field>
    	    <input type="input"  class=inputStyle name="subject_<%=rowindex%>"  onchange="checkinput1(subject_<%=rowindex%>,subjectspan_<%=rowindex%>);checkLength('subject_<%=rowindex%>','350','<%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')" style="width:85%"><span id="subjectspan_<%=rowindex%>"><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>
    	  </td>
    	  <td class=field>
    	    <input type="input" class=inputStyle name="desc_<%=rowindex%>" style="width:90%">
    	  </td>
    	  <td class=field><input type=checkbox class=inputStyle name="ismulti_<%=rowindex%>" value="1"></td>
    	  <td class=field>
    	    <input type="input" class=inputStyle name="ismultino_<%=rowindex%>" style="width:40%" onblur="checkMultinoFun(<%=rowindex%>)">
    	  </td>
    	  <td class=field><input type=checkbox class=inputStyle name="isother_<%=rowindex%>" value="1"></td>
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
	// var cells = tab.rows.item(0).cells.length ;
	ncol = oTable.rows.item(0).cells.length ;
	oRow = oTable.insertRow(-1);
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1); 
		oCell.style.height=24;
		oCell.style.background= "#efefef";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<table class=form><col width='8%'><col width='20%'><col width='32%'><col width='10%'><col width='12%'><col width='12%'><col width='6%'>"+
	            "<tr>"+
	            "<td class=field><input type='checkbox'  class=inputStyle name='check_question' value="+rowindex+">"+
	            "</td>"+
	            "<td class=field><input type='input' class=inputStyle name='subject_"+rowindex+"' onchange='checkinput1(subject_"+rowindex+",subjectspan_"+rowindex+")' style='width:85%'>"+ 
	            "<span id='subjectspan_"+rowindex+"'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>"+
	            "</td>"+
	            "<td class=field><input type='input' class=inputStyle name='desc_"+rowindex+"' style='width:90%'>"+
	            "</td>"+
	            "<td class=field><input type='checkbox' class=inputStyle name='ismulti_"+rowindex+"' value='1'>"+
                "</td>"+
                "<td class=field><input type='input' class=inputStyle name='ismultino_"+rowindex+"' style='width:40%' onblur='checkMultinoFun(ismultino_"+rowindex+")'>"+
                "<td class=field><input type='checkbox' class=inputStyle name='isother_"+rowindex+"' value='1'>"+
                "</td>"+
                "<td class=field><input type='input' class=inputStyle name='showorder_"+rowindex+"' style='width:80%'>"+
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
		if (document.forms[0].elements[i].name=='check_question')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_question'){
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
		if (document.forms[0].elements[i].name=='check_question')
			parastr+=",subject_"+document.forms[0].elements[i].value;
	}
	if(parastr!="") parastr=parastr.substring(1);
	if(check_form(document.frmmain,parastr)){
		document.frmmain.nodesnum.value=rowindex;
		document.frmmain.submit();
	}
}

function onDel(){
    if(isdel()){
        deleteRow() ;
    }	
}

function checkMultinoFun(obj){
  var checkNumber = 0;
  if(obj == 0){
    checkNumber = document.all("ismultino_"+obj).value;
  }else{
    checkNumber = obj.value;
  }
  if(checkNumber != ""){
	  if(checkNumber < 0 || checkNumber == 0){
	    alert("<%=SystemEnv.getHtmlLabelName(21765,user.getLanguage())%>");
	    obj.value = "";
	  }
  }
}
</script>
</html>