<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-07-02 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/hrm/area/areainit.jsp" %>
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("HrmCityAdd:Add", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String provinceid = Util.null2String(request.getParameter("provinceid"));
	
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(493,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
	String cityname = Util.null2String((String)session.getAttribute("cityname"));
	String citylongitude = Util.null2String((String)session.getAttribute("citylongitude"));
	String citylatitude = Util.null2String((String)session.getAttribute("citylatitude"));
	session.removeAttribute("cityname");
	session.removeAttribute("citylongitude");
	session.removeAttribute("citylatitude");
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
		 	var isSubmited = false ;
		 	function doSave(event){
				if(isSubmited) return  ;
				isSubmited = true ;
		    	if(check_form(document.frmMain,'cityname,provinceid')){
				   	document.frmMain.submit();
		  		}
				isSubmited = false ;
		 	}
		 	
		 	function checknumber1_jd(a,b,c){
				checknumber1(a);
				//checkinput(b,c);
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
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<%if(msgid!=-1){%>
		<script type="text/javascript">
		window.top.Dialog.alert('<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage()).replace(SystemEnv.getHtmlLabelName(377,user.getLanguage())+SystemEnv.getHtmlLabelName(399,user.getLanguage()),SystemEnv.getHtmlLabelName(195,user.getLanguage()))%>');
		</script>
		<%}%>
		<FORM id=weaver name=frmMain action="CityOperation.jsp" method=post >
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required="true">
							<input class=InputStyle maxLength=30 size=30 name="cityname" onchange="checkinput('cityname','namespan')" value="<%=cityname %>"><!--<font color="#FF0000"><%=SystemEnv.getHtmlLabelName(27086,user.getLanguage())%></font>-->
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(801,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="citylongitudespan" >
							<input class=inputstyle type=text size=30 maxlength="7" name="citylongitude" onKeyPress="ItemNum_KeyPress()" onchange="checknumber1_jd(this,'citylongitude','citylongitudespan')" value="<%=citylongitude %>">
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(802,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="citylatitudespan" >
							<input class=inputstyle type=text size=30 maxlength="7" name="citylatitude" onKeyPress="ItemNum_KeyPress()" onchange="checknumber1_jd(this,'citylatitude','citylatitudespan')"  value="<%=citylatitude %>">
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(800,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<div areaType="province" areaName="provinceid" areaValue="<%=provinceid%>" 
		 					areaSpanValue="<%=Util.formatMultiLang(ProvinceComInfo.getProvincename(provinceid),user.getLanguage()+"")%>"  areaMustInput="2"  areaCallback=""  class="_areaselect" id="_areaselect_provinceid"></div>
						</span>
					</wea:item>
				</wea:group>
			</wea:layout>		
			<input class=inputstyle type="hidden" name="operation" value="add">
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
			areromancedivbyid("_areaselect_provinceid");
			checkinput('cityname','namespan');
		});
	</script>
<%} %>
	</BODY>
</HTML>
