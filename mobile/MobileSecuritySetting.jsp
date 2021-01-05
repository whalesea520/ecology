
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

<script type='text/javascript' src='/js/jquery/jquery_wev8.js'></script>


</head>
<%
	if (!HrmUserVarify.checkUserRight("MobileSecurity:Setting", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(26589, user.getLanguage());
	String needfav = "1";
	String needhelp = "";
%>

<%
int userid = 0;
String udid = "";
int isused = 0;
String lastName = "";
weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
rs.execute("select MobileUserUDID.userid, MobileUserUDID.udid, MobileUserUDID.isused, hrmresource.lastName from MobileUserUDID inner join hrmresource on MobileUserUDID.userid = hrmresource.id");

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:doSave(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>



<FORM style="MARGIN-TOP: 0px" name=frmMain id="disabled" method=post action="MobileSecuritySettingOperation.jsp">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
	<colgroup>
		<col width="10">
		<col width="">
		<col width="10">
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
	<tr>
		<td></td>
		<td valign="top">
		<TABLE class=Shadow >
			<tr>
				<td valign="top">

				<TABLE class=ViewForm>
					<COLGROUP>
						<COL width="20%">
						<COL width="80%">
					<TBODY>
						<!-- 模块设置 -->
						<TR class=Title>
							<TH><%=SystemEnv.getHtmlLabelName(26590, user.getLanguage()) %></TH>
							<td align="right">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage()) %>" onclick="addModuleConfig();">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage()) %>" onclick="deleteModuleConfig();">
							</td>
						</TR>
						<TR class=Spacing>
							<TD class=Line1 colSpan=2></TD>
						</TR>
						<tr>
						<td colspan=2 style="margin:0;padding:0;">
							<TABLE id="table_module_config" class=BroswerStyle cellspacing="0" cellpadding="0" width="100%">
								<colgroup>
									<col width="2%">
									<col width="20%">
									<col width="*">
									<col width="20%">
								</colgroup>
								<tr class=DataHeader>
									<th></td>
									<th><%=SystemEnv.getHtmlLabelName(24533, user.getLanguage()) %></td>
									<th>UDID</td>
									<th><%=SystemEnv.getHtmlLabelName(18095, user.getLanguage()) %></td>
								</tr>
								<TR class=Line><TH colspan="4" ></TH></TR> 
								<%
								int i=1;
								for (;rs.next();i++) {
									userid = Util.getIntValue(rs.getString("userid"), 0);
									udid = Util.null2String(rs.getString("udid"));
									isused = Util.getIntValue(rs.getString("isused"), 0);
									lastName = Util.null2String(rs.getString("lastName")); 
								%>
								<tr>
									<td>
										<input type="checkbox" id="visible_<%=i %>" name="uss_visibles">
									</td>
									<td>
										<BUTTON class=Browser id=SelectCaller_<%=i %> onclick="onShowHrmCaller('userspan_<%=i %>','userid_<%=i %>','1')"></BUTTON><SPAN id=userspan_<%=i %>><a href="/hrm/resource/HrmResource.jsp?id=<%=userid %>"><%=lastName %></a></SPAN><input type="hidden" id="userid_<%=i %>" name="userid" value="<%=userid %>">
									</td>
									<td>
										<input type="text" id="udid_<%=i %>" name="udid" class="InputStyle" style="width:80%" value="<%=udid %>" onChange="checkinput('udid_<%=i %>','namespan_<%=i %>')">
										<span id="namespan_<%=i %>"></span>
									</td>
									<td>
										<input type="checkbox" id="isused_<%=i %>" name="isused" <%=isused == 1 ? "checked" : "" %> onclick="isusedclick(this)">
										<input type="hidden" id="used_<%=i %>" name="used" value="<%=isused %>">
									</td>
								</tr>
								<TR>
									<TD class="Line" colSpan=4></TD>
								</TR>
								<%
								}
								%>
							</table>					
						</td>
						</tr>
					</TBODY>
				</TABLE>
				</td>
				
			</tr>
			<tr>
				<td height="10" colspan="3"></td>
			</tr>
		</table>
		</td>
		<td>
		</td>
	</tr>
</table>


</FORM>

</BODY>
</HTML>
<script language=vbs>

sub  onShowHrmCaller(spanname,inputename,needinput)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	document.all(spanname).innerHtml= "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	document.all(inputename).value=id(0)
	else 
	if needinput = "1" then
	document.all(spanname).innerHtml= "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	else
	document.all(spanname).innerHtml= ""
	end if
	document.all(inputename).value=""
	end if
	end if
end sub
</SCRIPT>

<script type="text/javascript">
	function isusedclick(_this) {
		if ($(_this).attr("checked")) {
			$(_this).next().val("1");
		} else {
			$(_this).next().val("0");
		}
	}

	function doSave(){
		$(":input").attr("disabled", "true");
		var userids = document.getElementsByName("userid");
		var udids = document.getElementsByName("udid");
	
		for (var i=0; i<userids.length; i++) {
			if (userids[i] == null || userids[i] == undefined || userids[i].value == "") {
				alert("<%=SystemEnv.getHtmlLabelName(15859, user.getLanguage()) %>");
				$(":input").attr("disabled", "");
				return false;
			}
		}
		
		for (var i=0; i<udids.length; i++) {
			if (udids[i] == null || udids[i] == undefined || udids[i].value == "") {
				alert("<%=SystemEnv.getHtmlLabelName(15859, user.getLanguage()) %>");
				$(":input").attr("disabled", "");
				udids[i].focus();
				return false;
			}
		}
		$(":input").attr("disabled", "");
		frmMain.submit();
	}
	var total = <%=i %>;
	function addModuleConfig(){
		var table = document.getElementById("table_module_config");
		if(table) {
			var oRow = table.insertRow();
			var oCell = oRow.insertCell();
			total = total + 1;
			oCell.innerHTML = "<input type=\"checkbox\" id=\"visible_"+ total + "\" class=\"InputStyle\" name=\"uss_visibles\" value=\"0\"> ";
			oCell = oRow.insertCell();
			oCell.innerHTML = "<BUTTON class=Browser id=SelectCaller_1 onclick=\"onShowHrmCaller('userspan_" + total + "','userid_" + total + "','1')\"></BUTTON><SPAN id=userspan_" + total + "> <IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN><input type=\"hidden\" id=\"userid_" + total + "\" name=\"userid\">";
			oCell = oRow.insertCell();
			oCell.innerHTML = "<input type=\"text\" class=\"InputStyle styled input\" id=\"udid_"+ total + "\" name=\"udid\" class=\"InputStyle\" style=\"width:80%\" onChange=\"checkinput('udid_" + total + "','namespan_" + total + "')\"><span id=\"namespan_" + total + "\"><img src=\"/images/BacoError_wev8.gif\" align=absmiddle></span>";
			oCell = oRow.insertCell();
			oCell.innerHTML = "<input type=\"checkbox\" id=\"isused_"+ total + "\" name=\"isused\" onclick=\"isusedclick(this)\"><input type=\"hidden\" id=\"used_<%=i %>\" name=\"used\" value=\"0\">";
			oRow = table.insertRow();
			oCell = oRow.insertCell();
			oCell.colSpan = 4;
			oCell.className = "Line";
		}
	}
	
	function deleteModuleConfig(){
		var chkids = document.getElementsByName("uss_visibles");
		var count = chkids.length;
		for(var i=count-1;i>=0;i--){
			if(chkids[i]&&chkids[i].checked){
				var tr = chkids[i].parentElement.parentElement;
				if(tr){
					tr.parentElement.deleteRow(tr.rowIndex+1);
					tr.parentElement.deleteRow(tr.rowIndex);
				}
			}
		}
	}
</script>