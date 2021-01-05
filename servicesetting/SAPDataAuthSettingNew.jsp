
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.parseBrowser.SapBrowserComInfo"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.hrm.roles.RolesComInfo"%>
<%@page import="weaver.workflow.workflow.WorkflowComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="ResourceComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="RolesComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="WorkflowComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("SAPDataAuthSetting:Manage",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(28215,user.getLanguage());
String needfav ="1";
String needhelp ="";


SapBrowserComInfo sbc = new SapBrowserComInfo();
List allsapbrowserid = sbc.getAllBrowserId();

int settingid = Util.getIntValue(request.getParameter("settingid"),0); 

rs.execute("select * from SAPData_Auth_setting where id="+settingid);

String name = "";
String browserids = "";
String sources = "";
String resourcetype = "0";
String resourceids = "";
String roleids = "";
String wfids = "";

if(rs.next()){
	name = Util.null2String(rs.getString("name"));
	browserids = Util.null2String(rs.getString("browserids"));
	sources = Util.null2String(rs.getString("sources"));
	resourcetype = Util.null2String(rs.getString("resourcetype"));
	resourceids = Util.null2String(rs.getString("resourceids"));
	roleids = Util.null2String(rs.getString("roleids"));
	wfids = Util.null2String(rs.getString("wfids"));
}

//System.out.println("resourceids=====" + resourceids);

List browseridlist = Util.TokenizerString(browserids,",");
List sourcelist = Util.TokenizerString(sources,",");

%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(settingid > 0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",SAPDataAuthSetting.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
		
			<select class="InputStyle" id="hidden_select" style="display: none;">
				<option value=""></option>
				<%
				for(int i = 0; i<allsapbrowserid.size(); i++){
					String tmpid = allsapbrowserid.get(i) + "";
				%>
				<option value="<%=tmpid %>"><%=tmpid %></option>
				<%
				}
				%>
			</select>
			<select class="InputStyle" id="hidden_select2" style="display: none;">
				<option value=""></option>
				<%
				rs.executeSql("select * from SAPCONN");
				while(rs.next()){
					String code = rs.getString("code");
				%>
				<option value="<%=code%>" ><%=code%></option>
				<%}%>	
			</select>
			<span style="color: red;">
				<%
				String saveFlag = Util.null2String(request.getParameter("saveFlag"));
				if(saveFlag.equals("S")){
					out.print(SystemEnv.getHtmlLabelName(18758,user.getLanguage()) + "!");
				}else if(saveFlag.equals("E")){
					out.print(SystemEnv.getHtmlLabelName(21809,user.getLanguage()));
				}
				%>
			</span>
			
			<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="SAPDataAuthSettingOperation.jsp">
				<input type="hidden" name="operation">
				<input type="hidden" name="settingid" value="<%=settingid %>">
				<table class=ViewForm>
					<COLGROUP> 
					<COL width="20%"> 
					<COL width="80%">
					<TBODY>
						<TR class=Title>
						  <TH colSpan=2><%=titlename%></TH>
						</TR>
						<TR class=Spacing style="height:1px;">
						  <TD class=Line1 colSpan=2></TD>
						</TR>
						<tr>
							<td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage()) %></td>
							<td class="Field">
								<input type="text" name="name" id="name" value="<%=name %>" size="60" maxlength="60" onchange="checkname(this)">
								<span id="namespan">
								<%
									if(name.equals("")){
								%>
								<img src='/images/BacoError_wev8.gif' align=absmiddle>
								<%
									}
								%>
								</span>
							</td>
						</tr>
						<TR class=Spacing style="height:1px;">
						  <TD class=Line colSpan=2></TD>
						</TR>
						<tr>
							<td><%=SystemEnv.getHtmlLabelName(28216,user.getLanguage()) %></td>
							<td class="Field">
								<table class=ViewForm>
									<tr>
										<td colspan="1">
											<BUTTON class = btnNew accessKey = I onClick = "addRow();"><U>I</U>-<%=SystemEnv.getHtmlLabelName(611 , user.getLanguage())%></BUTTON>
								    		<BUTTON class = btnDelete accessKey = D onClick = "javascript:deleteRow()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%></BUTTON>
										</td>
									</tr>

									
									<tr>
										<td>
											<table class="ViewForm" id="oTable_elmt" cols="2">
											<COLGROUP> 
											<COL width="4%"> 
											<COL width="96%">
											</COLGROUP>
											<tbody>
											<%
												for(int i = 0; i<browseridlist.size(); i++){
													String tmpbrowserid = (String)browseridlist.get(i);
													String tmpsource = sourcelist.size()>i ? (String)sourcelist.get(i):"";
											%>
											<tr>
												<td>
													<div>
														<input class=inputstyle type='checkbox' id="check_elmt_<%=i %>"   name='check_elmt' value='0'>
													</div>
												</td>
												<td>
<!--													<input type="hidden" name="sapbrowserid" value="<%=tmpbrowserid %>">-->
													<select class="InputStyle"  id='sapbrowserid_<%=i %>' name='sapbrowserid' onchange='browseridchange(<%=i %>,this)' >
														<option value=""></option>
														<%
														for(int j = 0; j<allsapbrowserid.size(); j++){
															String tmpid = allsapbrowserid.get(j) + "";
														%>
														<option value="<%=tmpid %>" <%if(tmpid.equals(tmpbrowserid)){ %> selected="selected" <%} %>><%=tmpid %></option>
														<%
														}
														%>
													</select>
													<span id='sapbrowseridspan_<%=i %>'></span>
<!--													<input type="hidden" name="sources" value="<%=sources %>">-->
													<select class="InputStyle" name="sources" id="sources_<%=i %>" onchange='sourceschange(<%=i %>,this)'>
														<option value=""></option>
														<%
														rs.executeSql("select * from SAPCONN");
														while(rs.next()){
															String code = rs.getString("code");
														%>
														<option value="<%=code%>" <%if(tmpsource.equals(code)){%>selected<%}%>><%=code%></option>
														<%}%>	
													</select>
													<span id='sourcespan_<%=i %>'></span>
													<span id='detailsetspan_<%=i %>'><a href='javascript:openDetailSet(<%=i %>)'><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage()) %></a></span>
												</td>
											</tr>
											
											<%
												}
											%>
											</tbody>
											</table>
											
										</td>
									</tr>
								</table>
								
							</td>
						</tr>
						<TR class=Spacing style="height:1px;">
						  <TD class=Line colSpan=2></TD>
						</TR>
						<tr>
							<td><%=SystemEnv.getHtmlLabelName(28217,user.getLanguage()) %></td>
							<td class="Field">
								<select name="resourcetype" onchange="resourcetypechange(this)" id="resourcetype">
									<option value="0" <%if(resourcetype.equals("0")){out.print("selected=\"selected\"");} %>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage()) %></option>
									<option value="1" <%if(resourcetype.equals("1")){out.print("selected=\"selected\"");} %>><%=SystemEnv.getHtmlLabelName(122,user.getLanguage()) %></option>
								</select>
								
								<span id="resourceiddiv" style="display: <%=resourcetype.equals("0") ? "" : "none;" %>">
									<button type=button  class=Browser onClick="onShowResource('resourceidspan','resourceid')" name=showresource id="showresource"></BUTTON>
									<span id="resourceidspan">
									<%if(resourceids.equals("")){ %>
									<img src='/images/BacoError_wev8.gif' align=absmiddle>
									<%}else{
										String[] hrmidarr = Util.TokenizerString2(resourceids,",");
										String hrmnames = "";
										for(int i = 0; i<hrmidarr.length; i++){
											hrmnames += ResourceComInfo.getLastname(hrmidarr[i]) + ",";
										}
										if(hrmnames.length() > 0){
											hrmnames = hrmnames.substring(0,hrmnames.length()-1);
										}	
									%>
									<%=hrmnames %>
									<%} %>
									</span>
									<input type="hidden" id="resourceid" name="resourceid" value="<%=resourceids %>">
								</span>
								
								<span id="roleiddiv" style="display: <%=resourcetype.equals("1") ? "" : "none;" %>">
									<button type=button  class=Browser onClick="onShowRole('roleidspan','roleid')" name=showrole id="showrole"></BUTTON>
									<span id="roleidspan" >
									<%if(roleids.equals("")){ %>
									<img src='/images/BacoError_wev8.gif' align=absmiddle>
									<%}else{
										String[] rolearr = Util.TokenizerString2(roleids,",");
										String rolenames = "";
										for(int i = 0; i<rolearr.length; i++){
											rolenames += RolesComInfo.getRolesRemark(rolearr[i]) + ",";
										}
										if(rolenames.length() > 0){
											rolenames = rolenames.substring(0,rolenames.length()-1);
										}
									%>
									<%=rolenames %>
									<%} %>
									</span>
									<input type="hidden" id="roleid" name="roleid" value="<%=roleids %>">
								</span>
							</td>
						</tr>
						<TR class=Spacing style="height:1px;">
						  <TD class=Line colSpan=2></TD>
						</TR>
						<tr>
							<td><%=SystemEnv.getHtmlLabelName(2118,user.getLanguage()) %></td>
							<td class="Field">
								<BUTTON type="button" class=Browser onClick="onShowWorkflow('wfid','wfNamespan')" name=ShowWorkflow></BUTTON>
								<SPAN id=wfNamespan>
								<%if(wfids.equals("")){%>
								<img src='/images/BacoError_wev8.gif' align=absmiddle>
								<%}else{
									String[] wfidarr = Util.TokenizerString2(wfids,",");
									String wfnames = "";
									for(int i = 0; i<wfidarr.length; i++){
										wfnames += WorkflowComInfo.getWorkflowname(wfidarr[i]) + ",";
									}
									if(wfnames.length() > 0){
										wfnames = wfnames.substring(0,wfnames.length()-1);
									}
								%>
								<%=wfnames %>
								<%} %>
								</SPAN>
								<input type=hidden name="wfid" id="wfid" value="<%=wfids %>">
								<input type=hidden name="wfNames" id="wfNames">
							</td>
						</tr>
						<TR class=Spacing style="height:1px;">
						  <TD class=Line1 colSpan=2></TD>
						</TR>
						
					</TBODY>
				</table>
			</FORM>
		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
</BODY>
<script type="text/javascript" src="/js/jquery/jquery_wev8.js"></script>
<script type="text/javascript">
	jQuery(document).ready(function(){
		if(rowindex == 0){
			addRow();
		}
	});
</script>
<script language="javascript">
		var rowindex = <%=browseridlist.size()%>;
		function addRow(){
			var selecthtml = document.getElementById('hidden_select').innerHTML;
			var selecthtml2 = document.getElementById('hidden_select2').innerHTML;
			var ncol = oTable_elmt.cols;
			var oRow = oTable_elmt.insertRow();
			for(var i = 0; i<ncol; i++){
				var oCell = oRow.insertCell();

				switch(i){
					case 0:
						oCell.style.width=10;
						var oDiv = document.createElement("div");
						var sHtml = "<input class=inputstyle type='checkbox' id='check_elmt_"+rowindex+"'  name='check_elmt' value='0'>";
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;
					case 1:
						var oDiv = document.createElement("div");
						var sHtml = "<select class=inputstyle  id='sapbrowserid_"+rowindex+"' name='sapbrowserid' onchange='browseridchange("+rowindex+",this)'>";
						sHtml += selecthtml + '</select>';
						sHtml += "<span id='sapbrowseridspan_"+rowindex+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>&nbsp;";
						sHtml += "<select class=inputstyle  id='sources_"+rowindex+"' name='sources' onchange='sourceschange("+rowindex+",this)'>";
						sHtml += selecthtml2 + '</select>';
						sHtml += "<span id='sourcespan_"+rowindex+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>&nbsp;";
						sHtml += "<span id='detailsetspan_"+rowindex+"' style='display:none;'><a href='javascript:openDetailSet("+rowindex+")'><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage()) %></a></span>";
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;
				}
			}
			rowindex++;
		}
		
		function deleteRow(){
			var rows = jQuery("input[type='checkbox'][name='check_elmt'][checked]");
			if(rows.length == 0){
				alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>!");
				return;
			}
			var rowsize = jQuery("input[type='checkbox'][name='check_elmt']").length;
			if(rowsize <= 1){
				alert('<%=SystemEnv.getHtmlLabelName(28218,user.getLanguage())%>');
				return;
			}
			if(confirm("<%=SystemEnv.getHtmlLabelName(15459,user.getLanguage())%>?")){
			    rows.each(
			    	function(){
			    		/**
						var thisid = jQuery(this).attr('id');
			    		var rowid = thisid.substring(thisid.lastIndexOf('_')+1);
			    		var tmpsapbrowserid = jQuery('#sapbrowserid_'+rowid).val();
			    		if(tmpsapbrowserid && tmpsapbrowserid != ''){
			    			jQuery.post('SAPDataAuthSaveDetailAjax.jsp',{operation:'deleteBrowserid',sapbrowserid:tmpsapbrowserid,settingid:'<%=settingid%>'},function(){});
			    		}**/
			    		
						jQuery(this).parent().parent().parent().remove();
						
			    	}
			    );
		    }
		}
		
		function checkname(obj){
			if(obj.value == ''){
				jQuery('#namespan').html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
			}else{
				jQuery('#namespan').html('');
			}
		}
		function browseridchange(rowindex,obj){
			var val =  obj.value;
			var exists = false;
			if(val != ''){
				jQuery("select[name='sapbrowserid'][value!='']").each(function(){
					var tmpval = this.value;
					if(this != obj){
						if(tmpval == val){
							alert('<%=SystemEnv.getHtmlLabelName(28219,user.getLanguage())%>');
							obj.value = '';
							exists = true;
							return;
						}
					}
				});
				if(!exists){
					jQuery('#sapbrowseridspan_'+rowindex).html('');
					if(jQuery('#sources_'+rowindex).val() != '')
						jQuery('#detailsetspan_'+rowindex).show();
				}else{
					jQuery('#sapbrowseridspan_'+rowindex).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
					jQuery('#detailsetspan_'+rowindex).hide();
				}
			}else{
				jQuery('#sapbrowseridspan_'+rowindex).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
				jQuery('#detailsetspan_'+rowindex).hide();
			}
		}
		
		function sourceschange(rowindex,obj){
			var val =  obj.value;
			if(val != ''){
				jQuery('#sourcespan_'+rowindex).html('');
				if(jQuery('#sapbrowserid_'+rowindex).val()!=''){
					jQuery('#detailsetspan_'+rowindex).show();
				}else{
					jQuery('#detailsetspan_'+rowindex).hide();
				}
			}else{
				jQuery('#sourcespan_'+rowindex).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
				jQuery('#detailsetspan_'+rowindex).hide();
			}
		}
		
		function resourcetypechange(obj){
			if(obj.value == '0'){
				jQuery('#resourceiddiv').show();
				jQuery('#roleiddiv').hide();
			}else{
				jQuery('#resourceiddiv').hide();
				jQuery('#roleiddiv').show();
			}
		}
		
		function onShowResource(spanname, inputname) {
		    tmpids = $GetEle(inputname).value;
		    if(tmpids!="-1"){ 
		     url="/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids;
		    }else{
		     url="/hrm/resource/MutiResourceBrowser.jsp";
		    }
		    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url, "", "dialogWidth:550px;dialogHeight:550px;");
		    try {
		        jsid = new Array();jsid[0]=wuiUtil.getJsonValueByIndex(id, 0);jsid[1]=wuiUtil.getJsonValueByIndex(id, 1);
		    } catch(e) {
		        return;
		    }
		    if(id){
		    	if (jsid != null) {
			        if (jsid[0] != "0" && jsid[1]!="") {
			            $GetEle(spanname).innerHTML = jsid[1].substring(1);
			            $GetEle(inputname).value = jsid[0].substring(1);
			        } else {
			            $GetEle(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
			            $GetEle(inputname).value = "";
			        }
		   	 	}
		    }
		}
		
	function onShowRole(spanname, inputname){
	    tmpids = $GetEle(inputname).value;
	    if(tmpids!="-1"){ 
	      url=escape("/hrm/roles/MutiRolesBrowser.jsp?resourceids="+tmpids);
	    }else{
	      url=escape("/hrm/roles/MutiRolesBrowser.jsp");
	    }
	    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url, "", "dialogWidth:550px;dialogHeight:550px;");
	    try {
	        jsid = new Array();jsid[0]=wuiUtil.getJsonValueByIndex(id, 0);jsid[1]=wuiUtil.getJsonValueByIndex(id, 1);
	        
	    } catch(e) {
	        return;
	    }
	    if(id){
		    if (jsid != null) {
		        if (jsid[0] != "0" && jsid[1]!="") {
		            $GetEle(spanname).innerHTML = jsid[1].substring(1);
		            $GetEle(inputname).value = jsid[0].substring(1);
		        }else {
		            $GetEle(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		            $GetEle(inputname).value = "";
		        }
		    }
		  }
	}
	
	function onShowWorkflow(inputename,showname){
	    tmpids = $G(inputename).value
	    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowMutiBrowser.jsp?wfids="+tmpids);
		if (id1){
	        if (id1.id!="" && id1.id != 0) {
	          resourceids = id1.id;
	          resourcename = id1.name;
	          sHtml = ""
	         
	          resourceids =resourceids.substr(1);
	          $G(inputename).value= resourceids;
	          resourcename =resourcename.substr(1);
	          
	          resourceids=resourceids.split(",");
	          resourcename=resourcename.split(",");
	          for(var i=0;i<resourceids.length;i++){
	              sHtml = sHtml+resourcename[i]+"&nbsp;";
	          }
	          $G(showname).innerHTML = sHtml;
		      $G("wfNames").value=sHtml;
	        }else{
			  $G(showname).innerHTML ="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	          $G(inputename).value="";
	       }
	    }else{
	    	//$G(showname).innerHTML ="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	       // $G(inputename).value="";
	    }
	}
		
		function openDetailSet(rowindex){
			var settingid = <%=settingid%>;
			if(settingid == 0){
				alert('<%=SystemEnv.getHtmlLabelName(28220,user.getLanguage())%>');
				return;
			}
			var sapbrowserid = jQuery('#sapbrowserid_' + rowindex).val();
			var sources = jQuery('#sources_' + rowindex).val();
			var url = 'SAPDataAuthDetailSetting.jsp?sapbrowserid='+sapbrowserid+'&sources='+sources+'&settingid='+settingid;
			var returnval = window.showModalDialog(url, "", "dialogWidth=600px;dialogHeight=550px");
			returnval.sapcodes = encodeURIComponent(returnval.sapcodes);
			
			if(!returnval){
				returnval = {operation:'cancel',settingid:'<%=settingid%>',sapbrowserid:sapbrowserid};
			}
			
			if(returnval.operation == 'clear'){
				if(confirm('<%=SystemEnv.getHtmlLabelName(28221,user.getLanguage())%>')){
					jQuery.post('SAPDataAuthSaveDetailAjax.jsp',returnval,function(data){
						eval('var obj = ' + data);
						if(obj.saveFlag == 'S'){
							alert('<%=SystemEnv.getHtmlLabelName(28222,user.getLanguage())%>');
						}else{
							alert('<%=SystemEnv.getHtmlLabelName(28223,user.getLanguage())%>');
						}
					});
				}
			}else if(returnval.operation == 'savedetail'){
				jQuery.post('SAPDataAuthSaveDetailAjax.jsp',returnval,function(data){
					eval('var obj = ' + data);
					if(obj.saveFlag == 'S'){
						alert('<%=SystemEnv.getHtmlLabelName(22619,user.getLanguage()) %>!');
					}else{
						alert('<%=SystemEnv.getHtmlLabelName(22620,user.getLanguage()) %>!');
					}
				});
			}else{
				jQuery.post('SAPDataAuthSaveDetailAjax.jsp',returnval,function(data){
				});
			}
			
		}
		
		function onSubmit(obj){
			if(jQuery('#name').val() == ''){
				alert('<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage()) %>');
				return;
			}
			if(jQuery("select[name='sapbrowserid'][value='']").length > 0){
				alert('<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage()) %>');
				return;
			}
			if(jQuery("select[name='sources'][value='']").length > 0){
				alert('<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage()) %>');
				return;
			}
			if(jQuery('#resourcetype').val() == '0' && jQuery('#resourceid').val() == ''){
				alert('<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage()) %>');
				return;
			}
			if(jQuery('#resourcetype').val() == '1' && jQuery('#roleid').val() == ''){
				alert('<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage()) %>');
				return;
			}
			if(jQuery('#wfid').val() == ''){
				alert('<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage()) %>');
				return;
			}
			obj.disabled = 'disabled';
			document.frmMain.operation.value = 'baseset';
			document.frmMain.submit();
		}
		
		function onDelete(obj){
			if(confirm('<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage()) %>')){
				obj.disabled = 'disabled';
				document.frmMain.operation.value = 'delete';
				document.frmMain.submit();
			}
		}
</script>

</HTML>
