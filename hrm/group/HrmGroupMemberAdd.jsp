
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<!-- modified by wcd 2014-07-07 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	int groupid = Util.getIntValue(request.getParameter("groupid"));
	String groupname=Util.null2String(request.getParameter("name"));
	boolean canEdit = true ;
	String isdisable = !canEdit?"disabled":"";
	String ordisplay = !canEdit?" style='display:none' ":"";
	
	String imagefilename = "/images/hdReport_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(119,user.getLanguage())+" : "+ groupname;
	String needfav ="1";
	String needhelp ="";
	
	String defaultLevel = "10";
	String defaultLevelTo = "100";
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var parentDialog = parent.parent.getDialog(parent);
			if("<%=isclose%>"=="1"){
				parentWin.closeDialog();	
			}
			function doProc(event,data,name){
				$GetEle("relatedshareid").value += ($GetEle("relatedshareid").value == "" ? "" : ",") + data.id;
			}
			
			function doDelProc(text,fieldid,params){
				$GetEle("relatedshareid").value = jQuery("#"+fieldid).val();
			}
			
			function doSave() {
				thisvalue=document.frmMain.sharetype.value;
				if (thisvalue==1){
					if(check_form(document.frmMain,'relatedshareid')){
						document.frmMain.seclevel.value=0;
						document.frmMain.seclevelto.value=0;
						document.frmMain.submit();
					}
				}else if (thisvalue==2){
					if(check_form(document.frmMain,'relatedshareid,seclevel,seclevelto'))
					document.frmMain.submit();
				}else if (thisvalue==3){
					if(check_form(document.frmMain,'relatedshareid,seclevel,seclevelto'))
					document.frmMain.submit();
				}else if (thisvalue==4){
					if(check_form(document.frmMain,'relatedshareid,seclevel,seclevelto'))
					document.frmMain.submit();
				}else if (thisvalue==5){
					if(check_form(document.frmMain,'seclevel,seclevelto'))
					document.frmMain.submit();
				}else if (thisvalue==7){
					document.frmMain.seclevel.value=0;
					document.frmMain.seclevelto.value=0;
					if(check_form(document.frmMain,'relatedshareid')){
						if($GetEle("jobtitlelevel").value=="1"){
							if(check_form(document.frmMain,'jobtitledepartment')){
								document.frmMain.submit();
							}
						}else if($GetEle("jobtitlelevel").value=="2"){
							if(check_form(document.frmMain,'jobtitlesubcompany')){
								document.frmMain.submit();
							}
						}else{
							document.frmMain.submit();
						}
					}
				}else{
					$GetEle("relatedshareid").value += ($GetEle("relatedshareid").value == "" ? "" : ",") + $GetEle("customid").value;
					if(check_form(document.frmMain,'relatedshareid,seclevel,seclevelto'))
						document.frmMain.submit();
				}
			}
			function onChangeSharetype(){
				var thisvalue=document.frmMain.sharetype.value;
				document.frmMain.relatedshareid.value="";
				hideEle("item_seclevel");
				hideEle("item_rolelevel");
				hideEle("item_jobtitlelevel");
				showEle("item_sharetypeoption");
				$GetEle("showresource").style.display='none';
				$GetEle("showsubcompany").style.display='none';
				$GetEle("showdepartment").style.display='none';
				$GetEle("showrole").style.display='none';
				$GetEle("showjobtitle").style.display='none';
				$GetEle("showjobtitlesubcompany").style.display='none';
				$GetEle("showjobtitledepartment").style.display='none';
				
				if(thisvalue==1){
					$GetEle("showresource").style.display='';
					document.frmMain.seclevel.value=0;
					document.frmMain.seclevelto.value=0;
				}else if(thisvalue==2){
					$GetEle("showsubcompany").style.display='';
					document.frmMain.seclevel.value=10;
					document.frmMain.seclevelto.value=100;
					showEle("item_seclevel");
				}else if(thisvalue==3){
					$GetEle("showdepartment").style.display='';
					document.frmMain.seclevel.value=10;
					document.frmMain.seclevelto.value=100;
					showEle("item_seclevel");
				}else if(thisvalue==4){
					$GetEle("showrole").style.display='';
					showEle("item_rolelevel");
					showEle("item_seclevel");
					document.frmMain.seclevel.value=10;
					document.frmMain.seclevelto.value=100;
				}else if(thisvalue==7){
					$GetEle("showjobtitle").style.display='';
					showEle("item_jobtitlelevel");
					document.frmMain.seclevel.value=0;
					document.frmMain.seclevelto.value=0;
				}else if(thisvalue==5){
					document.frmMain.relatedshareid.value=-1;
					document.frmMain.seclevel.value=10;
					document.frmMain.seclevelto.value=100;
					hideEle("item_sharetypeoption");
					showEle("item_seclevel");
				}
			}
			
			function onjobtitlelevelChange(){
				$GetEle("showjobtitlesubcompany").style.display='none';
				$GetEle("showjobtitledepartment").style.display='none';
				if(jQuery("#jobtitlelevel").val()=="1"){
					$GetEle("showjobtitledepartment").style.display='';
				}else if(jQuery("#jobtitlelevel").val()=="2"){
					$GetEle("showjobtitlesubcompany").style.display='';
				}
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
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_top} " ;
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
		<FORM id=weaver name=frmMain action="HrmGroupMemberOperation.jsp" method=post onsubmit="return check_form(this,'userid,subcompanyid,departmentid,roleid,sharetype,rolelevel,seclevel,seclevelto,sharelevel')">
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(2112,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
					<wea:item>
						<SELECT name=sharetype onchange="onChangeSharetype()" style="width: 120px;">
						  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
						  <option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
						  <option value="3" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
						  <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
						  <option value="7"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option>
						  <option value="5"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></option>
						</SELECT>
					</wea:item>
					<wea:item attributes="{'samePair':'item_sharetypeoption'}"><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%></wea:item>
					<wea:item attributes="{'samePair':'item_sharetypeoption'}">
						<span <%=ordisplay%>>
							<span id="showresource" style="display:none">
								<brow:browser viewType="0" name="rsid" browserValue="" 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids="
									hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
									completeUrl="/data.jsp" width="60%" browserSpanValue="" _callback="doProc" afterDelCallback="doDelProc">
								</brow:browser>
							</span>
							<span id="showsubcompany" style="display:none">
								<brow:browser viewType="0" name="sbid" browserValue="" 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids="
									hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
									completeUrl="/data.jsp?type=164" width="60%" browserSpanValue="" _callback="doProc" afterDelCallback="doDelProc">
								</brow:browser>
							</span>
							<span id="showdepartment" style="display:''">
								<brow:browser viewType="0" name="did" browserValue="" 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
									hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
									completeUrl="/data.jsp?type=4" width="60%" browserSpanValue="" _callback="doProc" afterDelCallback="doDelProc">
								</brow:browser>
							</span>
							<span id="showrole" style="display:none">
								<brow:browser viewType="0" name="rid" browserValue="" 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/MutiRolesBrowser.jsp?resourceids="
									hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
									completeUrl="/data.jsp?type=65" width="60%" browserSpanValue="" _callback="doProc" afterDelCallback="doDelProc">
								</brow:browser>
							</span>
							<span id="showjobtitle" style="display:none">
								<brow:browser viewType="0" name="jobtitle" browserValue="" 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?resourceids="
									hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
									completeUrl="/data.jsp?type=24" width="60%" browserSpanValue="" _callback="doProc" afterDelCallback="doDelProc">
								</brow:browser>
							</span>
						</span>		
					</wea:item>
					<wea:item attributes="{'samePair':'item_rolelevel'}"><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
					<wea:item attributes="{'samePair':'item_rolelevel'}">
						<SELECT name=rolelevel>
							<option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
							<option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
							<option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
						</SELECT>
					</wea:item>
					<wea:item attributes="{'samePair':'item_jobtitlelevel'}"><%=SystemEnv.getHtmlLabelName(28169,user.getLanguage())%></wea:item>
					<wea:item attributes="{'samePair':'item_jobtitlelevel'}">
						<SELECT id=jobtitlelevel name=jobtitlelevel onchange="onjobtitlelevelChange()" style="float: left;">
							<option value="0" selected><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
							<option value="1"><%=SystemEnv.getHtmlLabelName(19438,user.getLanguage())%>
							<option value="2"><%=SystemEnv.getHtmlLabelName(19437,user.getLanguage())%>
						</SELECT>
						<span id="showjobtitlesubcompany" style="display:none">
							<brow:browser viewType="0" name="jobtitlesubcompany" browserValue="" 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids="
								hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
								completeUrl="/data.jsp?type=164" width="60%" browserSpanValue="">
							</brow:browser>
						</span>
						<span id="showjobtitledepartment" style="display:none">
							<brow:browser viewType="0" name="jobtitledepartment" browserValue="" 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
								hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
								completeUrl="/data.jsp?type=4" width="60%" browserSpanValue="">
							</brow:browser>
						</span>
					</wea:item>
					<wea:item attributes="{'samePair':'item_seclevel'}"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
					<wea:item attributes="{'samePair':'item_seclevel'}">
						<wea:required id="namespan" required='<%=(defaultLevel.length()==0||defaultLevelTo.length()==0)%>'>
							<INPUT type=text name=seclevel size=6 value="<%=defaultLevel%>" onchange='checkinput("seclevel","namespan")' style="width: 100px">
							<INPUT type=text name=seclevelto size=6 value="<%=defaultLevelTo%>" onchange='checkinput("seclevelto","namespan")' style="width: 100px">
						</wea:required>
					</wea:item>
				</wea:group>
			</wea:layout>
			<INPUT type="hidden" name="relatedshareid" value="">
			<input type="hidden" name="method" value="add">
			<input type="hidden" name="groupid" value="<%=groupid%>">
		</form>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="parentDialog.closeByHand();">
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
			onChangeSharetype();
		});
	</script>
<%} %>
	</BODY>
</HTML>
