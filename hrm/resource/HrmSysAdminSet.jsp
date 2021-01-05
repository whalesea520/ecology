
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.hrm.settings.RemindSettings, weaver.hrm.common.*, weaver.hrm.autotask.domain.*" %>
<!-- Added by wcd 2014-12-29 -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="HrmUsbAutoDateManager" class="weaver.hrm.autotask.manager.HrmUsbAutoDateManager" scope="page" />
<%
	String isDialog = Util.null2String(request.getParameter("isdialog"),"1");
	String userId = Util.null2String(request.getParameter("id"));
	
	String imagefilename = "/images/hdHRMCard_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(32496,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	RemindSettings settings = (RemindSettings)application.getAttribute("hrmsettings");
	String firmcode = settings.getFirmcode();
	String usercode = settings.getUsercode();
	int dynapass_enable = settings.getNeeddynapass();
	int needdynapassdefault = settings.getNeeddynapassdefault();
	String needusbHt = settings.getNeedusbHt();
	String needusbdefaultHt = settings.getNeedusbdefaultHt();
	String needusbDt = settings.getNeedusbDt();
	String needusbdefaultDt = settings.getNeedusbdefaultDt();
	String userUsbType = "";
	String usbstate = "";
	String mobile = "";
	String serial = "";
	String tokenKey = "";
	rs.executeSql("select userUsbType,usbstate,mobile,serial,tokenKey from HrmResourcemanager where id = "+userId );
	if(rs.next()){
		userUsbType = Tools.vString(rs.getString("userUsbType"));
		usbstate = Tools.vString(rs.getString("usbstate"));
		mobile = Tools.vString(rs.getString("mobile"));
		serial = Tools.vString(rs.getString("serial"));
		tokenKey = Tools.vString(rs.getString("tokenKey"));
	}
	String needauto = "1";
	String enableDate = "";
	String enableUsbType = userUsbType;
	String defaultDate = TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),1);
	Map automap = new HashMap();
	automap.put("userId", userId);
	HrmUsbAutoDate autoDate = HrmUsbAutoDateManager.get(automap);
	if(autoDate != null){
		needauto = String.valueOf(autoDate.getNeedAuto());
		enableDate = autoDate.getEnableDate();
		enableUsbType = String.valueOf(autoDate.getEnableUsbType());
	}
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<script language="javascript" type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script type="text/javascript">
			var common = new MFCommon();
			var parentWin = parent.parent.getParentWindow(parent);
			var parentDialog = parent.parent.getDialog(parent);
			var userId = "<%=userId%>";
			
			function doSave(){
				var userUsbType = jQuery("#userUsbType").val(); 
				var usbstate = jQuery("#usbstate").val();
				
				if((userUsbType == "4" && usbstate != "1" && !check_form(document.frmMain, "mobile"))){
					return false;
				}
				
                if(userUsbType=="2" && (usbstate != "1" || (usbstate == "1" && $GetEle("needauto").checked)) && !check_form(document.frmMain, "serial")){
					return false;
				}
				
				if(userUsbType=="3" && (usbstate != "1" || (usbstate == "1" && $GetEle("needauto").checked)) && !check_form(document.frmMain, "tokenKey")){
					return false;
				}
				
				if(usbstate == "1"){
					var needauto = $GetEle("needauto").checked;
					var enableDate = $GetEle("enableDate").value;
					var enableUsbType = $GetEle("enableUsbType").value;
					common.ajax("cmd=saveUsbAutoDate&arg0="+userId+"&arg1="+needauto+"&arg2="+enableDate+"&arg3="+enableUsbType);
				} else {
					common.ajax("cmd=saveUsbAutoDate&arg0="+userId+"&arg1=false&arg2=&arg3=0");
				}
				
				var mobile = $GetEle("mobile").value;
				var serial = $GetEle("serial").value;
				var tokenKey = $GetEle("tokenKey").value;
				common.ajax("cmd=saveAdminUsbSet&arg0="+userId+"&arg1="+userUsbType+"&arg2="+usbstate+"&arg3="+mobile+"&arg4="+serial+"&arg5="+tokenKey);
				parentDialog.close();
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
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave()">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM id="frmMain" name="frmMain" action="" method=post >
			<input type="hidden" id="username" name="username" value="" />
			<input type="hidden" id="loginid" name="loginid" value="" >
			<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
				  	<wea:item><%=SystemEnv.getHtmlLabelName(81629,user.getLanguage())%></wea:item>
				  	<wea:item>
				  		<select onchange="changeshow(this);change(this);onUserUsbTypeChange();" name="userUsbType" id="userUsbType" style="width:100px">
							<option value="-1">&nbsp;</option>
							<%if(dynapass_enable == 1){%>
							<option value="4" <%if("4".equals(userUsbType)){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(32511,user.getLanguage())%></option>
							<%}if("1".equals(needusbHt)){%>
							<option value="2" <%if("2".equals(userUsbType)){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(21589,user.getLanguage())%></option>
							<%}if("1".equals(needusbDt)){%>
							<option value="3" <%if("3".equals(userUsbType)){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(32896,user.getLanguage())%></option>
							<%}%>
						</select>
						&nbsp;
						<span id="spanusbstate">
						<select id="usbstate" name="usbstate" onchange="javascript:chooseUsbs(this);">
							<option value="0" <%=(usbstate!=null&&usbstate.equals("0"))?"selected":"" %>><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></option>
							<option value="1" <%=(usbstate!=null&&usbstate.equals("1"))?"selected":"" %>><%=SystemEnv.getHtmlLabelName(18096,user.getLanguage())%></option>
							<option value="2" <%=(usbstate!=null&&usbstate.equals("2"))?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21384,user.getLanguage())%></option>
						</select>
						</span>
					</wea:item>
					<%
						String itemAttrs = "{'samePair':'needautoItem','display':'"+("1".equals(usbstate) ? "" : "none")+"'}";
					%>
					<wea:item attributes='<%=itemAttrs%>'><%=SystemEnv.getHtmlLabelNames("81855,18095",user.getLanguage())%></wea:item>
				  	<wea:item attributes='<%=itemAttrs%>'>
				  		<span id="enableDateInfo">
							<input type="checkbox" id="needauto" name="needauto" value="1" <%if(needauto.equals("1")){%>checked<%}%> onclick="changeTokenKeySpan(this)">
							&nbsp;&nbsp;&nbsp;&nbsp;
							<%=SystemEnv.getHtmlLabelNames("18095,97",user.getLanguage())%>：
							<input class=inputstyle type=text size=4 name="days" maxlength="4" style="width: 40px;"
								onKeyPress="ItemCount_KeyPress()" onBlur="checknumber('days');checkcount('days');dealDate(this.value)" onChange="ckNumber('days');"  value="" />
							<%=SystemEnv.getHtmlLabelNames("1925,18110",user.getLanguage())%>&nbsp;&nbsp;
							<BUTTON class=Calendar type="button" id=selectdate onclick="getDate(enableDateSpan,enableDate);"></BUTTON>
							<SPAN id=enableDateSpan><%if(enableDate.equals("")){%><%=defaultDate%><%}else{%><%=enableDate %><%}%></SPAN>
							<input class=inputstyle type="hidden" name="enableDate" value="<%if(enableDate.equals("")){%><%=defaultDate%><%}else{%><%=enableDate %><%}%>" onPropertyChange="setDefaultDate(this.value,'<%=defaultDate %>');">
							<span style="margin-left:20px"><%=SystemEnv.getHtmlLabelNames("18095,599",user.getLanguage())%>
								<select name="enableUsbType" id="enableUsbType">
									<option value="0" <%if("0".equals(enableUsbType)){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></option>
									<!--<option value="1" <%if("1".equals(enableUsbType)){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(18096,user.getLanguage())%></option>-->
									<option value="2" <%if("2".equals(enableUsbType)){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(21384,user.getLanguage())%></option>
								 </select>
							 </span>
						</span>
					</wea:item>
					<%
						boolean isShowMobile = "4".equals(userUsbType) && dynapass_enable == 1;
						isShowMobile = (isShowMobile && !usbstate.equals("1")) || (isShowMobile && (usbstate.equals("1") && mobile.length() > 0));
						itemAttrs = "{'samePair':'mobileItem','display':'"+(isShowMobile ? "" : "none")+"'}";
					%>
					<wea:item attributes='<%=itemAttrs%>'><%=SystemEnv.getHtmlLabelName(81630,user.getLanguage())%></wea:item>
				  	<wea:item attributes='<%=itemAttrs%>'>
				  		<wea:required id="mobilespan" required='<%=mobile.length() == 0%>'>
				  			<input class="inputstyle" type="text" size=15 id="mobile" name="mobile" value="<%=mobile%>" onchange="checkinput('mobile','mobilespan')">
						</wea:required>
					</wea:item>
					<%
						itemAttrs = "{'samePair':'serialItem','display':'"+(("2".equals(userUsbType) && "1".equals(needusbHt)) ? "" : "none")+"'}";
					%>
					<wea:item attributes='<%=itemAttrs%>'><%=SystemEnv.getHtmlLabelName(21597,user.getLanguage())%></wea:item>
				  	<wea:item attributes='<%=itemAttrs%>'>
				  		<wea:required id="serialspan" required='<%=serial.length() == 0%>'>
				  			<input class="inputstyle" type="text" size=30 id="serial" name="serial" value="<%=serial%>" onblur="changeSerial()"  onchange="changeSerial()" >
						</wea:required>
						<button type="button" class="e8_btn_top"  id="changeUsb" onclick="updateKey()" style="display:<%="2".equals(userUsbType)?"":"none"%>;margin-left:10px;">
						   <%=("2".equals(userUsbType)&&serial.equals(""))?SystemEnv.getHtmlLabelName(28032,user.getLanguage()):SystemEnv.getHtmlLabelName(83738,user.getLanguage())%>
						</button>
					</wea:item>
					<%
						itemAttrs = "{'samePair':'tokenKeyItem','display':'"+(("3".equals(userUsbType) && "1".equals(needusbDt)) ? "" : "none")+"'}";
					%>
					<wea:item attributes='<%=itemAttrs%>'><%=SystemEnv.getHtmlLabelName(32897,user.getLanguage())%></wea:item>
				  	<wea:item attributes='<%=itemAttrs%>'>
				  		<wea:required id="tokenKeyspan" required='<%=(usbstate!=null&&!usbstate.equals("1")) && tokenKey.length() == 0%>'>
				  			<input class="inputstyle" type="text" size=30 maxlength="10" id="tokenKey" name="tokenKey" value="<%=tokenKey%>" onchange="changeTokenKey()" onblur="checkTokenKey();changeTokenKey()" >
						</wea:required>
					</wea:item>
				</wea:group>
			</wea:layout>
		</form>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="parentDialog.close();">
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
		<OBJECT id="htactx" name="htactx" classid=clsid:FB4EE423-43A4-4AA9-BDE9-4335A6D3C74E codebase="HTActX.cab#version=1,0,0,1" style="HEIGHT: 0px; WIDTH: 0px"></OBJECT>
		<script type="text/javascript">
		function getUserName(){
			try{
				var hCard = htactx.OpenDevice(1);//打开设备
				if(hCard==0){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21607, user.getLanguage())%>");
					return "";
				}
				
				try{
					var userName = htactx.GetUserName(hCard);//获取用户名
					htactx.CloseDevice(hCard);
					return userName;
				}catch(e){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21607, user.getLanguage())%>");
					htactx.CloseDevice(hCard);
					return "";
				}
			}catch(e){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21607, user.getLanguage())%>");
				return "";
			}
		}
		</script>
		<script type="text/javascript">
			function changeshow(obj){
			    var usbstate = $GetEle("usbstate").value;
				if(usbstate == "1"){
					showEle("needautoItem");
				}else {
					hideEle("needautoItem");
				}
				if(obj.value=="2"){
					hideEle("mobileItem");
					showEle("serialItem");
					hideEle("tokenKeyItem");
					
					jQuery("#changeUsb").show();
					if("<%=serial%>"=="")
						jQuery("#changeUsb").html("<%=SystemEnv.getHtmlLabelName(28032,user.getLanguage())%>");  
					else
						jQuery("#changeUsb").html("<%=SystemEnv.getHtmlLabelName(83738,user.getLanguage())%>");      
				} else if(obj.value=="3"){
					hideEle("mobileItem");
					hideEle("serialItem");
					showEle("tokenKeyItem");
					
					jQuery("#changeUsb").hide();
				} else if(obj.value=="4"){
					if(usbstate == "1"){
						if($GetEle("mobile").value.length != 0) showEle("mobileItem");
						else hideEle("mobileItem");
					} else {
						showEle("mobileItem");
					}
					hideEle("serialItem");
					hideEle("tokenKeyItem");
				} else{
					hideEle("mobileItem");
					hideEle("serialItem");
					hideEle("tokenKeyItem");
					hideEle("needautoItem");
				}
			}
			  
			function change(obj){
				if(obj.value=="2") change2(obj);   
			}
			
			function change2(obj){
				try{
					var returnstr = getUserName();
					if(returnstr){
						frmMain.username.value = returnstr;
						frmMain.loginid.value = returnstr;
					}
				}catch(e){}
			}
            
            function onUserUsbTypeChange(){
              jQuery("#spanusbstate").hide();
            	if(jQuery("#userUsbType").val()!=-1){
            		jQuery("#spanusbstate").show();
            	}
				chooseUsbs($GetEle("usbstate"));
            }
            
            function chooseUsbs(obj){
				if(obj.value==1){
					if($GetEle("needauto").checked) {
						$GetEle("tokenKeyspan").innerHTML = $GetEle("tokenKey").value == '' ? "<IMG src='/images/BacoError_wev8.gif' align='absMiddle'>" : "";
						$GetEle("serialspan").innerHTML = $GetEle("serial").value == '' ? "<IMG src='/images/BacoError_wev8.gif' align='absMiddle'>" : "";
					} else {
						$GetEle("tokenKeyspan").innerHTML = "";	
						$GetEle("serialspan").innerHTML = "";
					}
            		changeshow(jQuery("#userUsbType")[0]);
            	}else{
					$GetEle("tokenKeyspan").innerHTML = $GetEle("tokenKey").value == '' ? "<IMG src='/images/BacoError_wev8.gif' align='absMiddle'>" : "";
					$GetEle("serialspan").innerHTML = $GetEle("serial").value == '' ? "<IMG src='/images/BacoError_wev8.gif' align='absMiddle'>" : "";
            		change(jQuery("#userUsbType")[0]);
					changeshow(jQuery("#userUsbType")[0]);
            	}
            }
			
			function updateKey(){
				var needusb = jQuery("#userUsbType").val();
				if(needusb=="2")   
					updateKey2();
				else if(needusb=="3")
					bindTokenKey();      
			}
			
			function updateKey2(){
				try{
					var returnstr = getUserName();
					if(returnstr){
						frmMain.username.value = returnstr;
						frmMain.loginid.value = returnstr;
					}
				}catch(e){}
			}
			
			function bindTokenKey(){
				url=encodeURIComponent("/login/bindTokenKey.jsp?requestFrom=system&userid=<%=userId%>");  
				result=window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url,null,"dialogWidth=620px;");
				if(result&&result.tokenKey!=""){
					jQuery("#tokenKey").val(result.tokenKey);
				}
			}
			
			function changeTokenKeySpan(obj) {
				if(obj.checked) {
					$GetEle("tokenKeyspan").innerHTML = $GetEle("tokenKey").value == '' ? "<IMG src='/images/BacoError_wev8.gif' align='absMiddle'>" : "";
					$GetEle("serialspan").innerHTML = $GetEle("serial").value == '' ? "<IMG src='/images/BacoError_wev8.gif' align='absMiddle'>" : "";
				} else {
					$GetEle("tokenKeyspan").innerHTML = "";
					$GetEle("serialspan").innerHTML = "";
				}
			}
			
			function changeSerial() {
				if($GetEle("usbstate").value==1){
					if($GetEle("needauto").checked) {
						checkinput('serial','serialspan');
					} else {
						$GetEle("serialspan").innerHTML = "";
					}
				}else{
					checkinput('serial','serialspan');
				}
			}
			
			function changeTokenKey() {
				if($GetEle("usbstate").value==1){
					if($GetEle("needauto").checked) {
						checkinput('tokenKey','tokenKeyspan');
					} else {
						$GetEle("tokenKeyspan").innerHTML = "";	
					}
            	}else{
					checkinput('tokenKey','tokenKeyspan');
            	}
			}
			
			function getDate(spanname,inputname){  
				WdatePicker({lang:common.getLanguageStr(),minDate:'%y-%M-{%d+1}', el:spanname,
					onpicked:function(dp){
						var returnvalue = dp.cal.getDateStr();
						$dp.$(inputname).value = returnvalue;
						resetDays(returnvalue);
					},
					oncleared:function(dp){
						$dp.$(inputname).value = '';
						$GetEle("days").value = '';
					}
				});
			}
			
			function setDefaultDate(value,defaultDate){
				if(value==''){
					$GetEle("enableDate").value=defaultDate;
					$GetEle("enableDateSpan").innerHTML=defaultDate;
				}
			}
			
			function resetDays(date){
				var currentDate = new Date();
				$GetEle("days").value = common.daysBetween(common.date2str(currentDate,"yyyy-MM-dd"), date);
			}
			
			function dealDate(days){
				if(days > 0){
					var enableDate = new Date();
					enableDate.setDate(enableDate.getDate()+parseInt(days));
					$GetEle("enableDate").value = common.date2str(enableDate,"yyyy-MM-dd");
					$GetEle("enableDateSpan").innerHTML = common.date2str(enableDate,"yyyy-MM-dd");
				}
			}
			
			function ckNumber(days){
				var temp=/^\d+(\.\d+)?$/;
				var days = $GetEle(days);
				if(temp.test(days.value)==false){
					days.value = "";
				}
			}
            
            function isdigit(s){
				return s.match(/\d*/i) == s;
		    }
            
            function checkTokenKey(){
				var tokenKey = jQuery("#tokenKey");
				if(tokenKey.val()!=""&&(!isdigit(tokenKey.val())||tokenKey.val().length!=10)){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83745,user.getLanguage())%>");
					tokenKey.val("");
					tokenKey.focus();
				}else if(tokenKey.val()!=""){ 
					jQuery.post("/login/LoginOperation.jsp",{'method':'checkIsUsed','userid':<%=userId%>,'tokenKey':tokenKey.val()},function(data){
						data=eval("("+data+")");
						var status=data.status;
						if(status=="1"){
							window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(83755,user.getLanguage())%>"'+data.lastname+'",<%=SystemEnv.getHtmlLabelName(83757,user.getLanguage())%>');
							tokenKey.val("");
							tokenKey.focus();
						}
					});
				}
            }
			$(document).ready(function() {
            	onUserUsbTypeChange();
            });
		</script>
	</BODY>
</HTML>
