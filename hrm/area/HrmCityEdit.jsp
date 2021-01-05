
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- modified by wcd 2014-07-02 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<%@ include file="/hrm/area/areainit.jsp" %>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page" />
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<%
	if(!HrmUserVarify.checkUserRight("HrmCityEdit:Edit", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	
	int id = Util.getIntValue(request.getParameter("id"),0);
	String cityname = CityComInfo.getCityname(String.valueOf(id));
	String citylongitude = CityComInfo.getCitylongitude(String.valueOf(id));
	String citylatitude = CityComInfo.getCitylatitude(String.valueOf(id));
	String provinceid = CityComInfo.getCityprovinceid(String.valueOf(id));
	String countryid = CityComInfo.getCitycountryid(String.valueOf(id));
	String canceled = CityComInfo.getCitycanceled(String.valueOf(id));
	String provinceCanceled = "";
	int result = 0;
	
	String sql = "select a.id,a.cityname,a.citylongitude,a.citylatitude,a.provinceid,a.countryid,a.canceled,(case when b.canceled IS NULL then '0' else b.canceled end) as provinceCanceled,(select count(id) from HrmLocations where locationcity = a.id) as result from HrmCity a left join HrmProvince b on a.provinceid = b.id where a.id = "+id;
	rs.executeSql(sql);
	if(rs.next()){
		cityname = Util.null2String(rs.getString("cityname"));
		citylongitude = Util.null2String(rs.getString("citylongitude"));
		if(Tools.parseToDouble(citylongitude) == -1){
			citylongitude = "";
		}
		citylatitude = Util.null2String(rs.getString("citylatitude"));
		if(Tools.parseToDouble(citylatitude) == -1){
			citylatitude = "";
		}
		countryid = Util.null2String(rs.getString("countryid"));
		canceled = Util.null2String(rs.getString("canceled"));
		provinceCanceled = Util.null2String(rs.getString("provinceCanceled"));
		result = rs.getInt("result");
	}
	
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(493,user.getLanguage())+":"+cityname;
	String needfav ="1";
	String needhelp ="";
	int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
	if(msgid>0){
		cityname = Util.null2String((String)session.getAttribute("cityname"));
		citylongitude = Util.null2String((String)session.getAttribute("citylongitude"));
		citylatitude = Util.null2String((String)session.getAttribute("citylatitude"));
		session.removeAttribute("cityname");
		session.removeAttribute("citylongitude");
		session.removeAttribute("citylatitude");
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
		    	if(check_form(document.frmMain,'cityname,countryid,provinceid,citylatitude,citylongitude')){
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
				  ajax.open("POST", "/hrm/area/HrmCanceledCheck.jsp", true);
				  ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
				  ajax.send("ope=city&cancelFlag=0&id=<%=id%>");
				  ajax.onreadystatechange = function() {
					if (ajax.readyState == 4 && ajax.status == 200) {
						try{
						   window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22155, user.getLanguage())%>");
						   window.location.href = "HrmCityEdit.jsp?isclose=1";
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
				  ajax.open("POST", "/hrm/area/HrmCanceledCheck.jsp", true);
				  ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
				  ajax.send("ope=city&cancelFlag=1&id=<%=id%>");
				  ajax.onreadystatechange = function() {
					if (ajax.readyState == 4 && ajax.status == 200) {
						try{
						  window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22156, user.getLanguage())%>");
						  window.location.href = "HrmCityEdit.jsp?isclose=1";
						}catch(e){
							return false;
						}
					}
				 }
			   });
			 }
		</script>
	</head>
	<BODY >
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content" >
		<%} %>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			if(HrmUserVarify.checkUserRight("HrmCityEdit:Delete", user) && result == 0 && !"1".equals(canceled)){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			if("0".equals(canceled) || "".equals(canceled) || "Null".equals(canceled)){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+",javascript:doCanceled(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}else{
				if(!"1".equals(provinceCanceled)){
					RCMenu += "{"+SystemEnv.getHtmlLabelName(22152,user.getLanguage())+",javascript:doISCanceled(),_self} " ;
					RCMenuHeight += RCMenuHeightStep ;
				}
			}
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<%if(msgid!=-1){%>
		<script type="text/javascript">
		window.top.Dialog.alert('<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage()).replace(SystemEnv.getHtmlLabelName(377,user.getLanguage())+SystemEnv.getHtmlLabelName(399,user.getLanguage()),SystemEnv.getHtmlLabelName(195,user.getLanguage()))%>');
		</script>
		<%}%>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
					<%if(HrmUserVarify.checkUserRight("HrmCityEdit:Delete", user) && result == 0 && !"1".equals(canceled)){%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" class="e8_btn_top" onclick="doDel();">
					<%}%>
					<%if("0".equals(canceled) || "".equals(canceled) || "Null".equals(canceled)){%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(22151,user.getLanguage())%>" class="e8_btn_top" onclick="doCanceled();">
					<%}else{if(!"1".equals(provinceCanceled)){%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(22152,user.getLanguage())%>" class="e8_btn_top" onclick="doISCanceled();">
					<%}}%>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM id=weaver name=frmMain action="CityOperation.jsp" method=post >
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required='<%=cityname.length()==0%>'>
							<input class=InputStyle maxLength=30 size=30 name="cityname" value="<%=cityname%>" onchange="checkinput('cityname','namespan')"><!--<font color="#FF0000"><%=SystemEnv.getHtmlLabelName(27086,user.getLanguage())%></font>-->
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(801,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="citylongitudespan" >
							<input class=inputstyle type=text size=30 maxlength="7" name="citylongitude" value="<%=citylongitude%>"  onKeyPress="ItemNum_KeyPress()" onchange="checknumber1_jd(this,'citylongitude','citylongitudespan')">
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(802,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="citylatitudespan" >
							<input class=inputstyle type=text size=30 maxlength="7" name="citylatitude" value="<%=citylatitude%>" onKeyPress="ItemNum_KeyPress()" onchange="checknumber1_jd(this,'citylatitude','citylatitudespan')" >
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
			areromancedivbyid("_areaselect_provinceid");
		});
		
		function checknumber1_jd(a,b,c){
			checknumber1(a);
			//checkinput(b,c);
		}
	</script>
<%} %>
	</BODY>
</HTML>
