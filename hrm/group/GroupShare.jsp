
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<!-- modified by wcd 2014-07-07 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="GroupAction" class="weaver.hrm.group.GroupAction" scope="page" />
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
			function doSave() {
				thisvalue=document.frmMain.sharetype.value;
				if (thisvalue==1)
					{if(check_form(document.frmMain,'relatedshareid'))
					document.frmMain.submit();}
				else if (thisvalue==2)
					{if(check_form(document.frmMain,'relatedshareid'))
					document.frmMain.submit();}
				else if (thisvalue==3)
					{if(check_form(document.frmMain,'relatedshareid'))
					document.frmMain.submit();}
				else if (thisvalue==4)
					{if(check_form(document.frmMain,'relatedshareid'))
					document.frmMain.submit();}
				else
					document.frmMain.submit();
			}
			function onChangeSharetype(){
				var thisvalue=document.frmMain.sharetype.value;
				document.frmMain.relatedshareid.value="";
				if(thisvalue==1){
					$GetEle("showresource").style.display='';
					$GetEle("showseclevel").style.display='none';
					$GetEle("showsecleveltitle").style.display='none';
				}
				else{
					$GetEle("showresource").style.display='none';
					$GetEle("showseclevel").style.display='';
					$GetEle("showsecleveltitle").style.display='';
				}
				if(thisvalue==2){
					$GetEle("showsubcompany").style.display='';
					document.frmMain.seclevel.value=10;
				}
				else{
					$GetEle("showsubcompany").style.display='none';
					document.frmMain.seclevel.value=10;
				}
				if(thisvalue==3){
					$GetEle("showdepartment").style.display='';
					document.frmMain.seclevel.value=10;
				}
				else{
					$GetEle("showdepartment").style.display='none';
					document.frmMain.seclevel.value=10;
				}
				if(thisvalue==4){
					$GetEle("showrole").style.display='';
					$GetEle("showrolelevel").style.visibility='visible';
					$GetEle("showroleleveltitle").style.visibility='visible';
					document.frmMain.seclevel.value=10;
				}
				else{
					$GetEle("showrole").style.display='none';
					$GetEle("showrolelevel").style.visibility='hidden';
					$GetEle("showroleleveltitle").style.visibility='hidden';
					document.frmMain.seclevel.value=10;
				}
				if(thisvalue==5){
					document.frmMain.relatedshareid.value=-1;
					document.frmMain.seclevel.value=10;
				}
				if(thisvalue<0){
					document.frmMain.relatedshareid.value=-1;
					document.frmMain.seclevel.value=0;
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
		<FORM id=weaver name=frmMain action="GroupShareOperation.jsp" method=post onsubmit="return check_form(this,'userid,subcompanyid,departmentid,roleid,sharetype,rolelevel,seclevel,sharelevel')">
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%>'>
					<wea:item>
						  <SELECT class=InputStyle  name=sharetype onchange="onChangeSharetype()" <%=isdisable%>>
						  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
						  <option value="3" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
						  <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
						  <option value="5"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></option>
						 <%while(CustomerTypeComInfo.next()){
							String curid=CustomerTypeComInfo.getCustomerTypeid();
							String curname=CustomerTypeComInfo.getCustomerTypename();
							String optionvalue="-"+curid;
						%>
							<option value="<%=optionvalue%>"><%=Util.toScreen(curname,user.getLanguage())%></option>
						<%
						}%>
						</SELECT>
					</wea:item>
					<wea:item>
						<span <%=ordisplay%>>
							<span id="showresource" style="display:none">
								<brow:browser viewType="0" name="rsid" browserValue="" 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids="
									hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
									completeUrl="/data.jsp" width="60%" browserSpanValue="" _callback="doProc">
								</brow:browser>
							</span>
							<span id="showsubcompany" style="display:none">
								<brow:browser viewType="0" name="sbid" browserValue="" 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
									hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
									completeUrl="/data.jsp?type=164" width="60%" browserSpanValue="" _callback="doProc">
								</brow:browser>
							</span>
							<span id="showdepartment" style="display:''">
								<brow:browser viewType="0" name="did" browserValue="" 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
									hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
									completeUrl="/data.jsp?type=4" width="60%" browserSpanValue="" _callback="doProc">
								</brow:browser>
							</span>
							<span id="showrole" style="display:none">
								<brow:browser viewType="0" name="rid" browserValue="" 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/MutiRolesBrowser.jsp?resourceids="
									hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
									completeUrl="/data.jsp?type=65" width="60%" browserSpanValue="" _callback="doProc">
								</brow:browser>
							</span>
						</span>		
					</wea:item>
					<wea:item>
						<span id=showsecleveltitle name=showsecleveltitle>
							<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:
						</span>		
					</wea:item>
					<wea:item>
						<span <%=ordisplay%>>
							<span id=showseclevel name=showseclevel>
								<wea:required id="namespan" required='<%=defaultLevel.length()==0%>'>
									<INPUT type=text name=seclevel class=InputStyle size=6 value="<%=defaultLevel%>" onchange='checkinput("seclevel","namespan")' <%=isdisable%>>
								</wea:required>
							</span>
						</span>		
					</wea:item>
					<wea:item>
						<span id="showroleleveltitle" name="showroleleveltitle" style="visibility:hidden">
							<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>:
						</span>		
					</wea:item>
					<wea:item>
						<span <%=ordisplay%>>
							<span id=showrolelevel name=showrolelevel style="visibility:hidden">
								<SELECT class=InputStyle  name=rolelevel  <%=isdisable%>>
									<option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
									<option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
									<option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
								</SELECT>
							</span>
						</span>		
					</wea:item>
				</wea:group>
			</wea:layout>
			<wea:layout type="4col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(17748,user.getLanguage())+SystemEnv.getHtmlLabelName(119,user.getLanguage())%>'>
					<%
						RecordSet=GroupAction.getShare(groupid);
						int sharetype = -1;
						while(RecordSet.next()){
							sharetype = RecordSet.getInt("sharetype");
							if(sharetype==1){
					%>
						<wea:item><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></wea:item>
						<wea:item>
							<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("userid")),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
							<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
						</wea:item>
					<%
							}else if(sharetype==2){
					%>
						<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
						<wea:item>
							<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(RecordSet.getString("subcompanyid")),user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
							<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
						</wea:item>
					<%
							}else if(sharetype==3){
					%>
						<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
						<wea:item>
							<%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSet.getString("departmentid")),user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
							<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
						</wea:item>
					<%
							}else if(sharetype==4){
					%>
						<wea:item><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></wea:item>
						<wea:item>
							<%=Util.toScreen(RolesComInfo.getRolesRemark(RecordSet.getString("roleid")),user.getLanguage())%>/<% if(RecordSet.getInt("rolelevel")==0)%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
							<% if(RecordSet.getInt("rolelevel")==1)%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
							<% if(RecordSet.getInt("rolelevel")==2)%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
							<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
						</wea:item>
					<%
							}else if(sharetype==5){
					%>
						<wea:item><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())+SystemEnv.getHtmlLabelName(127,user.getLanguage())%></wea:item>
						<wea:item>
							<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
							<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
						</wea:item>
					<%
							}else if(sharetype<0){
								String crmtype= "" + ((-1)*RecordSet.getInt("sharetype")) ;
								String crmtypename=CustomerTypeComInfo.getCustomerTypename(crmtype);
					%>
						<wea:item><%=Util.toScreen(crmtypename,user.getLanguage())%></wea:item>
						<wea:item>
							<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<% if(RecordSet.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
							<% if(RecordSet.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
						</wea:item>
					<%
							}
					%>
						<wea:item>
							<%if(canEdit){%>
								<a href="GroupShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&groupid=<%=groupid%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
							<%}%>
						</wea:item>
						<wea:item>&nbsp;</wea:item>
					<%	}%>
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
		});
	</script>
<%} %>
	</BODY>
</HTML>
