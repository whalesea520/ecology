<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-06-27 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%
if(!HrmUserVarify.checkUserRight("HrmRolesAdd:Add", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
	rs.executeProc("SystemSet_Select","");
	rs.next();
	int detachable=Util.getIntValue(rs.getString("detachable"),0);
	int hrmdetachable=Util.getIntValue(String.valueOf(session.getAttribute("hrmdetachable")),0);

	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	
	String roleID=Util.null2String(request.getParameter("roleID"));
	rs.execute("hrmroles_selectSingle",roleID);
	rs.next();

	int roletype=Util.getIntValue(rs.getString(4),0);
	int subcompanyid=Util.getIntValue(rs.getString(5),0);
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(122,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(431,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
			if("<%=isclose%>"=="1"){
				parentWin.id = "<%=roleID%>";
				parentWin.closeDialog();	
			}
			function doShow(){
				var thisvalue = document.frmMain.sharetype.value;
				document.frmMain.relatedshareid.value="";
				$GetEle("showseclevel").style.display='';
				$GetEle("showsecleveltitle").style.display='';
				if(thisvalue==1){
					$GetEle("showresource").style.display='';
					$GetEle("showseclevel").style.display='none';
					$GetEle("showsecleveltitle").style.display='none';
				}else{
					$GetEle("showresource").style.display='none';
				}
				if(thisvalue==3){
					$GetEle("showdepartment").style.display='';
				}else{
					$GetEle("showdepartment").style.display='none';
				}
				if(thisvalue==4){
					$GetEle("showrole").style.display='';
					$GetEle("rolelevel").style.display='';
					$GetEle("showtitle").style.display='';
				}else{
					$GetEle("showrole").style.display='none';
					$GetEle("rolelevel").style.display='none';
					$GetEle("showtitle").style.display='none';
				}
				if(thisvalue==5){
					document.frmMain.relatedshareid.value="";
				}
				if(thisvalue==6){
					$GetEle("showresourcemanager").style.display='';
					$GetEle("showseclevel").style.display='none';
					$GetEle("showsecleveltitle").style.display='none';
				}else{
					$GetEle("showresourcemanager").style.display='none';
				}
				if(thisvalue==7){
					$GetEle('relatedshareid').value = 1;
					$GetEle("showseclevel").style.display='none';
					$GetEle("showsecleveltitle").style.display='none';
				}else{
					$GetEle('relatedshareid').value = "";
				}
			}
			function doProc(event,data,name){
				$GetEle("relatedshareid").value = $GetEle(""+name).value;
			}
			function doDelProc(text,fieldid,params) {
				$GetEle("relatedshareid").value = $GetEle(""+fieldid).value;
			}
			function doSave() {
				var thisvalue = $GetEle("frmMain").sharetype.value;
				$GetEle("frmMain").operationType.value = "New";
				if($GetEle("seclevelimage1").innerHTML !="" || $GetEle("seclevelimage2").innerHTML !=""){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
					return;
				}
				if ( (thisvalue==1)||(thisvalue==3)||(thisvalue==4)||(thisvalue==6)){
					if(check_form($GetEle("frmMain"),'relatedshareid')){
						$GetEle("frmMain").submit();
					}
				}else{
					$GetEle("frmMain").submit();
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
		<FORM id=frmMain name=frmMain action="HrmRolesMembersOperation.jsp" method=post >
			<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
				  	<wea:item><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></wea:item>
				  	<wea:item>
				  		<span><%=RolesComInfo.getRolesRemark(roleID)%></span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<select name="level" id="level" style="width:30%">
								<option value=2 selected><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
								<option value=1><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
								<option value=0><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
							</select>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%></wea:item>
					<wea:item>
						<table style="width:100%"><tr>
						<td style="width:30%">
						<SELECT style="width:100%" name=sharetype onchange="doShow()">
						<%if(roletype==0){%>
							<option value="1" selected><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
							<option value="3"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
							<option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
							<%if(detachable==1){//开启分权系统管理员才有权限%>
								<%if(user.getUID()==1){ %>
								<option value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>
								<%} %>
							<%}else{ %>
							<option value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>
							<%} %>
							<%if(detachable==1){%>
							<option value="6"><%=SystemEnv.getHtmlLabelName(17870,user.getLanguage())%></option>
							<%}%>
							<%if(detachable==1){//开启分权系统管理员才有权限%>
							<%if(user.getUID()==1){ %>
							<option value="7"><%=SystemEnv.getHtmlLabelName(16139,user.getLanguage())%></option>
							<%} %>
							<%}else{ %>
							<option value="7"><%=SystemEnv.getHtmlLabelName(16139,user.getLanguage())%></option>
							<%} %>
						<%}else{%>
							<option value="1" selected><%=SystemEnv.getHtmlLabelName(17870,user.getLanguage())%></option>
						<%}%>
						</SELECT>
						</td>
						<td style="width:70%">
						<%if(roletype==0){
							String browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MultiResourceBrowserByRight.jsp?rightStr=HrmRolesAdd:Add&selectedids=";
							String completeUrl = "/data.jsp?type=1";
							if(detachable==1&&user.getUID()!=1){
							  String subcomstr=SubCompanyComInfo.getRightSubCompany(user.getUID(),"HrmRolesAdd:Add",0);
							  completeUrl = "/data.jsp?type=1&whereClause="+xssUtil.put(" t1.subcompanyid1 in("+subcomstr+")");
							}
						%>
							<span id="showresource" style="display:''">
							<brow:browser viewType="0" name="rid" browserValue="" 
								browserUrl="<%=browserUrl %>"
								hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
								completeUrl="<%=completeUrl %>" width="60%" browserSpanValue="" _callback="doProc">
							</brow:browser>
							</span>
							<span id="showresourcemanager" style="display:none">
							<%
							completeUrl = "/data.jsp?type=sysadmin";
							if(detachable==1&&user.getUID()!=1){
							  completeUrl = "/data.jsp?type=sysadmin&whereClause= creator="+user.getUID();
							}
							%>
							<brow:browser viewType="0" name="rmid" browserValue="" 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/systeminfo/sysadmin/sysadminBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
								completeUrl="<%=completeUrl %>" width="60%" browserSpanValue="" _callback="doProc">
							</brow:browser>
							</span>
						<%}else{%>
							<span id="showresourcemanager" style="display:''">
							<%
							String completeUrl = "/data.jsp?type=sysadmin";
							if(detachable==1&&user.getUID()!=1){
							  completeUrl = "/data.jsp?type=sysadmin&whereClause= creator="+user.getUID();
							}
							%>
							<brow:browser viewType="0" name="_rmid" browserValue="" 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/systeminfo/sysadmin/sysadminBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
								completeUrl="<%=completeUrl %>" width="60%" browserSpanValue="" _callback="doProc">
							</brow:browser>
							</span>
						<%}%>
						<span id="showdepartment" style="display:none">
						<%
						String browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentByRightBrowser.jsp?rightStr=HrmRolesAdd:Add&show_virtual_org=-1&selectedids=";
						String completeUrl = "/data.jsp?type=4";
						if(detachable==1&&user.getUID()!=1){
						  String subcomstr=SubCompanyComInfo.getRightSubCompany(user.getUID(),"HrmRolesAdd:Add",0);
						  completeUrl = "/data.jsp?type=4&whereClause="+xssUtil.put(" t1.subcompanyid1 in("+subcomstr+")");
						}
						%>
						<brow:browser viewType="0" name="did" browserValue="" 
							browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentByRightBrowser.jsp?rightStr=HrmRolesAdd:Add&show_virtual_org=-1&selectedids="
							hasInput="true" isSingle="false" hasBrowser="true" isMustInput='2'
							completeUrl="<%=completeUrl %>" width="60%" browserSpanValue="" _callback="doProc">
						</brow:browser>
						</span>
						<span id="showrole" style="display:none">
						<%
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/MutiRolesBrowser.jsp?selectedids=";
						completeUrl = "/data.jsp?type=65";
						if(detachable==1&&user.getUID()!=1){
							browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/MutiRolesBrowser.jsp?sqlwhere= where subcompanyid="+subcompanyid+"&selectedids=";
							completeUrl="/data.jsp?type=65&whereClause= subcompanyid="+subcompanyid;
						}
						%>
						<brow:browser viewType="0" name="roleid" browserValue="" 
							browserUrl="<%=browserUrl %>"
							hasInput="true" isSingle="false" hasBrowser="true" isMustInput='2'
							completeUrl="<%=completeUrl %>" width="60%" browserSpanValue="" _callback="doProc">
						</brow:browser>
						</span>
						</td>
						</tr></table>
					</wea:item>
					<wea:item><span id=showsecleveltitle name=showsecleveltitle style="display:none"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:</span></wea:item>
					<wea:item>
						<span id=showseclevel name=showseclevel style="display:none">
							<INPUT style="width:15%" type=text name=seclevel size=3 value="10" onkeyup="validnum(this,seclevelimage1)"><SPAN id=seclevelimage1></SPAN> - <INPUT style="width:15%" type=text name=seclevelmax size=3 value="100"  onkeyup="validnum(this,seclevelimage2)"><SPAN id=seclevelimage2></SPAN>
						</span>
					</wea:item>
					<wea:item><span id=showtitle name=showtitle style="display:none"><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></span></wea:item>
					<wea:item>
						<span>
							<select name="rolelevel" id="rolelevel" style="display:none;width:37%">
								<option value=0><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
								<option value=1><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
								<option value=2><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
							</select>
						</span>
					</wea:item>
				</wea:group>
			</wea:layout>
			<input type=hidden name="relatedshareid">
			<input type=hidden name="operationType">
			<input type=hidden name="roleID" value="<%=roleID%>">
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
	
<script type="text/javascript">
function validnum(obj,spanid){
    checkPlusnumber1(obj);
    
   if(obj.value ==""){
   		spanid.innerHTML ="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
   }else{
   		spanid.innerHTML="";
   }
}
</script>
</HTML>
