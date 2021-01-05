
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<HEAD>
	<LINK href = "/css/Weaver_wev8.css" type = "text/css" rel="STYLESHEET">
	<SCRIPT language = "javascript" src = "/js/weaver_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>
</HEAD>
<%
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(17561,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(82,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
	<BODY>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
		
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:location='PhraseList.jsp',_self} " ;
		RCMenuHeight += RCMenuHeightStep;
     %>

	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<FORM  NAME ="frmAdd" id="frmAdd" method="post" action="PhraseOperate.jsp">
		<INPUT type="hidden" name="operation">
    <TABLE class=ViewForm  width="100%" CELLSPACING="0">
	<br>
	 <colgroup>
		<col width="7%">
		<col width="92%">
		<col width="1%">
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(18774,user.getLanguage())%></TD>
			<TD class="field"><INPUT TYPE="text" class="inputStyle" maxLength=30 size=50 NAME="phraseShort" onblur="checkLength()" onchange='checkinput("phraseShort","phraseShortpan")'>
			 <SPAN id=phraseShortpan>
               <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
              </SPAN>
              <br><span><font color="red"><%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>30(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)</font></span>
			</TD >
			<td class="field"></td>
		</TR>
		<TR style="height:1px;">
		<TD class=Line colspan=3 ></TD>
		</TR>
		<TR>	
			<TD><%=SystemEnv.getHtmlLabelName(18775,user.getLanguage())%></TD>
			<TD class="field" >
	            <textarea viewtype="1" class="Inputstyle" name="phraseDesc" id="phraseDesc" rows="4" cols="100" style="width:80%;display:none" 
	               onchange="checkLengthfortext('phraseDesc','1000','<%=SystemEnv.getHtmlLabelName(18775,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')"></textarea>
				<br><span style="color:red">(<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>1000,<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)</span>
			</TD>
			<td class="field">
				<div id="phraseDescspan" >
		           <IMG src="/images/BacoError_wev8.gif" style="align:absMiddle" align="absMiddle">
		       	</div>
			</td>
		<TR>		
    </TABLE>		
	</FORM>
	</BODY>
<script defer>
	function funcremark_log(){
	   	CkeditorExt.initEditor("frmAdd","phraseDesc","<%=user.getLanguage()%>",CkeditorExt.NO_IMAGE,200)
		CkeditorExt.checkText("phraseDescspan","phraseDesc");
		CkeditorExt.toolbarExpand(false,"phraseDesc");
	}
	if (window.addEventListener){
	    window.addEventListener("load", funcremark_log, false);
	}else if (window.attachEvent){
	    window.attachEvent("onload", funcremark_log);
	}else{
	    window.onload=funcremark_log;
	}
</script>

	<script language=javascript>
		function onSave() {
		  
		  var value = document.getElementsByName("phraseDesc")[0].value;
		  
		  if(trim(value)==''){
		  		alert('<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>');
		  		return;
		  }

		  
		  if(check_form(frmAdd,'phraseShort')){ <%--xwj td 1802 on 2005-04-27--%>
			window.frmAdd.operation.value="add" ;
			window.frmAdd.submit();
		 }
		}
		
		function checkLength(){
			tmpvalue = document.all("phraseShort").value;
			if(realLength(tmpvalue)>30){
				alert("<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>30(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)");
				while(true){
					tmpvalue = tmpvalue.substring(0,tmpvalue.length-1);
					if(realLength(tmpvalue)<=30){
						document.all("phraseShort").value = tmpvalue;
						return;
					}
				}
			}
		}
	</script>
</HTML>
