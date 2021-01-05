<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-07-02 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<% 
	if(!HrmUserVarify.checkUserRight("HrmCountriesEdit:Edit",user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
	
	int id = Util.getIntValue(request.getParameter("id"),0);
	String countryname = CountryComInfo.getCountryname(String.valueOf(id));
	String countrydesc = CountryComInfo.getCountrydesc(String.valueOf(id));
	String canceled = "";
	boolean isExsit = false;
	
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(377,user.getLanguage())+":"+countryname+"-"+countrydesc;
	String needfav ="1";
	String needhelp ="";
	
	String sqlWhere = rs.getDBType().equals("oracle")?"where nvl(a.canceled,0) <> 1":"where ISNULL(a.canceled,0) <> 1";
	String sql = "select a.id,a.countryname,a.countrydesc,(case when a.canceled IS NULL then 0 else a.canceled end) as canceled,(case when b.result IS NULL then 0 else b.result end) as result from HrmCountry a left join ( select a.countryid,count(a.id) as result from HrmProvince a "+sqlWhere+" group by a.countryid ) b on a.id = b.countryid where a.id = "+id;
	rs.executeSql(sql);
	if(rs.next()){
		countryname = Util.null2String(rs.getString("countryname"));
		countrydesc = Util.null2String(rs.getString("countrydesc"));
		canceled = Util.null2String(rs.getString("canceled"));
		isExsit = rs.getInt("result") > 0;
	}
	
	if(msgid>0){
		countryname = Util.null2String((String)session.getAttribute("countryname"));
		countrydesc = Util.null2String((String)session.getAttribute("countrydesc"));
		
		session.removeAttribute("countryname");
		session.removeAttribute("countrydesc");
	}
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
			if("<%=isclose%>"=="1"){
				parentWin.closeDialog();
			}
		 	function doSave(){
		    	if(check_form(document.frmMain,'countryname,countrydesc')){
				   	document.frmMain.submit();
		  		}
		 	}
			function doDel(){
				parentWin._cmd = "closeDialog";
				parentWin.doDel('<%=id%>');
			}
			function doCanceled(){
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22153,user.getLanguage())%>",function(){
				  var ajax=ajaxinit();
				  ajax.open("POST", "/hrm/country/HrmCanceledCheck.jsp", true);
				  ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
				  ajax.send("ope=country&cancelFlag=0&id=<%=id%>");
				  ajax.onreadystatechange = function() {
					if (ajax.readyState == 4 && ajax.status == 200) {
						try{
						   window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22155, user.getLanguage())%>");
						   window.location.href = "HrmCountriesEdit.jsp?isclose=1";
						}catch(e){
							return false;
						}
					}
				 }
			  });
			}

			function doISCanceled(){
			   window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22154,user.getLanguage())%>",function(){
				  var ajax=ajaxinit();
				  ajax.open("POST", "/hrm/country/HrmCanceledCheck.jsp", true);
				  ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
				  ajax.send("ope=country&cancelFlag=1&id=<%=id%>");
				  ajax.onreadystatechange = function() {
					if (ajax.readyState == 4 && ajax.status == 200) {
						try{
						  window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22156, user.getLanguage())%>");
						  window.location.href = "HrmCountriesEdit.jsp?isclose=1";
						}catch(e){
							return false;
						}
					}
				 }
			   });
			 }
		</script>
	</head>
	<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			if(HrmUserVarify.checkUserRight("HrmCountriesEdit:Delete", user)&&!isExsit){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			if("0".equals(canceled) || "".equals(canceled) || "Null".equals(canceled)){
				if(!isExsit){
					RCMenu += "{"+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+",javascript:doCanceled(),_self} " ;
					RCMenuHeight += RCMenuHeightStep ;
				}
			}else{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(22152,user.getLanguage())+",javascript:doISCanceled(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
					<%if(HrmUserVarify.checkUserRight("HrmCountriesEdit:Delete", user)&&!isExsit){%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" class="e8_btn_top" onclick="doDel();">
					<%}%>
					<%if("0".equals(canceled) || "".equals(canceled) || "Null".equals(canceled)){if(!isExsit){%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(22151,user.getLanguage())%>" class="e8_btn_top" onclick="doCanceled();">
					<%}}else{%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(22152,user.getLanguage())%>" class="e8_btn_top" onclick="doISCanceled();">
					<%}%>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM id=weaver name=frmMain action="CountryOperation.jsp" method=post >
		<%if(msgid!=-1){%>
		<script type="text/javascript">
		window.top.Dialog.alert('<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>');
		</script>
		<%}%>
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelNames("377,399",user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required='<%=countryname.length()==0%>'>
							<input class=InputStyle maxLength=50 size=30 name="countryname" value="<%=countryname%>" onchange="checkinput('countryname','namespan')"><!--<font color="#FF0000"><%=SystemEnv.getHtmlLabelName(27086,user.getLanguage())%></font>-->
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelNames("377,15767",user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="descspan" required='<%=countrydesc.length()==0%>'>
							<input class=InputStyle maxLength=50 size=50 name="countrydesc" value="<%=countrydesc%>" onchange="checkinput('countrydesc','descspan')"><!--<font color="#FF0000"><%=SystemEnv.getHtmlLabelName(27087,user.getLanguage())%></font>-->
						</wea:required>
					</wea:item>
				</wea:group>
			</wea:layout>		
			<input class=inputstyle type=hidden name=id value="<%=id%>">
			<input class=inputstyle type="hidden" name="operation" value="edit">
		</form>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
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
	</BODY>
</HTML>
