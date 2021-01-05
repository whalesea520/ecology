
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

<link rel='stylesheet' type='text/css' href='/js/extjs/resources/css/ext-all_wev8.css' />
<link rel='stylesheet' type='text/css' href='/css/weaver-ext_wev8.css' />
<link rel='stylesheet' type='text/css' href='/js/extjs/resources/css/xtheme-gray_wev8.css'/>
<link rel="stylesheet" type="text/css" href="/css/weaver-ext-grid_wev8.css" />

<script type='text/javascript' src='/js/jquery/jquery_wev8.js'></script>
<script type='text/javascript' src='/js/extjs/adapter/jquery/jquery_wev8.js'></script>
<script type='text/javascript' src='/js/extjs/adapter/jquery/ext-jquery-adapter_wev8.js'></script>
<script type='text/javascript' src='/js/extjs/ext-all_wev8.js'></script>

<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="subCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="rolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />

</head>
<%
	String plugintype = Util.null2String(request.getParameter("plugintype"));
	if(plugintype==null||"".equals(plugintype)){
		if(HrmUserVarify.checkUserRight("Messages:All", user)){
			plugintype = "messager";
		} else if (HrmUserVarify.checkUserRight("Mobile:Setting", user)) {
			plugintype = "mobile";
		} else {
			response.sendRedirect("/notice/noright.jsp");
			return;
		}
	} else {
		if("messager".equals(plugintype)&&HrmUserVarify.checkUserRight("Messages:All", user)){
			plugintype = "messager";
		} else if ("mobile".equals(plugintype)&&HrmUserVarify.checkUserRight("Mobile:Setting", user)) {
			plugintype = "mobile";
		} else {
			response.sendRedirect("/notice/noright.jsp");
			return;
		}
	}

	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename = plugintype+" "+SystemEnv.getHtmlLabelName(18454, user.getLanguage());
	String needfav = "1";
	String needhelp = "";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:doSave(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
	//取出用户信息
	RecordSet rs=new RecordSet();
	List licenseuserlist = new ArrayList();
	rs.executeSql("select * from PluginLicenseUser where plugintype = '"+plugintype+"' order by id");
	while(rs.next()){
		Map lu = new HashMap();
		
		String id = Util.null2String(rs.getString("id"));
		String sharetype = Util.null2String(rs.getString("sharetype"));
		String sharevalue = Util.null2String(rs.getString("sharevalue"));
		String seclevel = Util.null2String(rs.getString("seclevel"));
		
		lu.put("id",id);
		lu.put("sharetype",sharetype);
		lu.put("sharevalue",sharevalue);
		lu.put("seclevel",seclevel);
		
		licenseuserlist.add(lu);
	}
%>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="PluginLicenseUserOperation.jsp">
<input type="hidden" id="plugintype" name="plugintype" value="<%=plugintype%>">
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
		<TABLE class=Shadow>
			<tr>
				<td valign="top">

				<TABLE class=ViewForm>
					<COLGROUP>
						<COL width="20%">
						<COL width="80%">
					<TBODY>
						<tr><td colspan="2"></td></tr>
						<!-- 用户设置 -->
						<TR class=Title>
							<TH>&nbsp;<%=SystemEnv.getHtmlLabelName(18454, user.getLanguage())%></TH>
							<td align="right">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>" onclick="addUser();">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>" onclick="deleteUser();">
							</td>
						</TR>
						<TR class=Spacing style="height:1px;">
							<TD class=Line colSpan=2></TD>
						</TR>
						<tr>
							<td colspan="2">
							
							<input type="hidden" id="userTotal" name="userTotal" value="<%=licenseuserlist.size()%>">
							
							<TABLE id="table_user" class=BroswerStyle cellspacing="1" cellpadding="1" width="100%">
							<colgroup>
								<col width="5%">
								<col width="25%">
								<col width="35%">
								<col width="35%">
							</colgroup>
							<tr class=DataHeader>
								<th><input type="checkbox" id="usr_all" name="usr_all" class="InputStyle" onclick="doselectall(this);"></td>
								<th><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></td>
								<th><%=SystemEnv.getHtmlLabelName(139, user.getLanguage())%></td>
								<th><%=SystemEnv.getHtmlLabelName(106, user.getLanguage())%></td>
							</tr>
							<TR  style="height:1px;" class=Line><TH colspan="6" ></TH></TR>
							<% 
							for(int i=0;i<licenseuserlist.size();i++){ 
								Map lu = (Map)licenseuserlist.get(i);
								
								String id = Util.null2String((String)lu.get("id"));
								String sharetype = Util.null2String((String)lu.get("sharetype"));
								String seclevel = Util.null2String((String)lu.get("seclevel"));
								String sharevalue = Util.null2String((String)lu.get("sharevalue"));
								
								String name = "";
								String[] showid = Util.TokenizerString2(sharevalue,",");
								String show = "";
								String type = "";
								if("0".equals(sharetype)){
									//人力资源
									name = SystemEnv.getHtmlLabelName(179, user.getLanguage());
									type = "";
									for(int j=0;j<showid.length;j++){
										show+= "<a href='/hrm/resource/HrmResource.jsp?id="+showid[j]+"'>"+resourceComInfo.getLastname(showid[j])+"</a>&nbsp;";
									}
								} else if("1".equals(sharetype)){
									//分部
									name = SystemEnv.getHtmlLabelName(141, user.getLanguage());
									type = SystemEnv.getHtmlLabelName(683, user.getLanguage()) + ":" + seclevel;
									for(int j=0;j<showid.length;j++){
										show+= "<a href='/hrm/company/HrmSubCompanyDsp.jsp?id="+showid[j]+"'>"+subCompanyComInfo.getSubCompanyname(showid[j])+"</a>&nbsp;";
									}
								} else if("2".equals(sharetype)){
									//部门
									name = SystemEnv.getHtmlLabelName(124, user.getLanguage());
									type = SystemEnv.getHtmlLabelName(683, user.getLanguage()) + ":" + seclevel;
									for(int j=0;j<showid.length;j++){
										show+= "<a href='/hrm/company/HrmDepartmentDsp.jsp?id="+showid[j]+"'>"+departmentComInfo.getDepartmentname(showid[j])+"</a>&nbsp;";
									}
								} else if("3".equals(sharetype)){
									//角色
									name = SystemEnv.getHtmlLabelName(122, user.getLanguage());
									
									String rolelevel = showid[0].substring(showid[0].length()-1);
									String roleid = showid[0].substring(0,showid[0].length()-1);
									
									int roletext = 124;
									if(Util.getIntValue(rolelevel,0)==0) roletext = 124;
									else if(Util.getIntValue(rolelevel,0)==1) roletext = 141;
									else if(Util.getIntValue(rolelevel,0)==2) roletext = 140;
									
									type = SystemEnv.getHtmlLabelName(683, user.getLanguage()) + ":" + seclevel + "/" + SystemEnv.getHtmlLabelName(3005, user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(roletext,user.getLanguage()) ;
									show+= ""+rolesComInfo.getRolesRemark(roleid)+"&nbsp;";
								} else if("4".equals(sharetype)){
										//所有人
										name = SystemEnv.getHtmlLabelName(1340, user.getLanguage());
										type = SystemEnv.getHtmlLabelName(683, user.getLanguage()) + ":" + seclevel;
										show = "";
								}
							%>
							<tr>
								<td>
								<input type="checkbox" id="usr_<%=i%>" name="usr_i" class="InputStyle" value="<%=id%>">
								<input type="hidden" id="usr_id<%=i%>" name="usr_id" class="InputStyle" value="<%=id%>">
								<input type="hidden" id="usr_sharetype<%=i%>" name="usr_sharetype" class="InputStyle" value="<%=sharetype%>">
								<input type="hidden" id="usr_seclevel<%=i%>" name="usr_seclevel" class="InputStyle" value="<%=seclevel%>">
								<input type="hidden" id="usr_sharevalue<%=i%>" name="usr_sharevalue" class="InputStyle" value="<%=sharevalue%>">
								</td>
								<td><%=name%></td>
								<td><%=type%></td>
								<td><%=show%></td>
							</tr>
							<TR style="height:1px;">
								<TD class=Line colSpan=6></TD>
							</TR>
							<% } %>
							</TABLE>
							</td>
						</tr>
						<TR>
							<TD colSpan=2>&nbsp;</TD>
						</TR>
					</TBODY>
				</TABLE>
				</td>
			</tr>
			<tr>
				<td height="10" colspan="3"></td>
			</tr>
		</table>
		</td>
		<td></td>
	</tr>
</table>

<div id="userwin" class="x-hidden">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">    
        <tr>
            <td valign="top">
                <TABLE width=100% height=100%>
                    <tr>
                        <td valign="top">  
                              <TABLE class=ViewForm>
                                <COLGROUP>
                                <COL width="30%">
                                <COL width="70%">
                                <TBODY>            
                                    <TR>
                                        <TD>
                                           <%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%>
                                        </TD>
                                            
                                        <TD class="field">
                                            <SELECT class=InputStyle name="sharetype" id="sharetype" onChange="onChangeSharetype()" >   
                                                <option value="1" selected><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option> 
                                                <option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
                                                <option value="3"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
                                                <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>    
                                                <option value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>    
                                            </SELECT>
                                            &nbsp;&nbsp;
                                            <BUTTON type=button class=Browser style="display:''" onClick="onShowResource('relatedshareid','showrelatedsharename');" name=showresource></BUTTON> 
                                            <BUTTON type=button class=Browser style="display:none" onClick="onShowSubcompany('relatedshareid','showrelatedsharename');" name=showsubcompany></BUTTON> 
                                            <BUTTON type=button class=Browser style="display:none" onClick="onShowDepartment('relatedshareid','showrelatedsharename');" name=showdepartment></BUTTON> 
                                            <BUTTON type=button class=Browser style="display:none" onClick="onShowRole('relatedshareid','showrelatedsharename');" name=showrole></BUTTON>
                                            <INPUT type=hidden name=relatedshareid  id="relatedshareid" value="">
                                            <span id=showrelatedsharename ></span>                                            
                                        </TD>
                                    </TR>
                                    <TR style="height:1px;">
                                        <TD class=Line colSpan=2></TD>
                                    </TR>

                                    <TR id=showrolelevel name=showrolelevel style="display:none">
                                        <TD>
                                            <%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%>
                                        </TD>
                                        <td class="field">
                                             <SELECT id="rolelevel" name="rolelevel">
                                                    <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
                                                    <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
                                                    <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
                                             </SELECT>
                                        </td>
                                    </TR>
                                     <TR style="height:1px;">
                                        <TD class=Line colSpan=2  id=showrolelevel_line style="display:none"></TD>
                                     </TR>

                                      <TR id=showseclevel style="display:none">
                                        <TD>
                                             <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
                                        </TD>
                                        <td class="field">
                                             <INPUT type=text name="seclevel" class=InputStyle size=6 value="10" onchange='checkinput("seclevel","seclevelimage")' onKeyPress="ItemCount_KeyPress()">
                                             <span id=seclevelimage></span>
                                        </td>
                                    </TR>
                                     <TR style="height:1px;">
                                        <TD class=Line colSpan=2 id=showseclevel_line style="display:none"></TD>
                                     </TR>
                                </TBODY>
                            </TABLE>
                        </td>
                    </tr>
                </TABLE>
            </td>
        </tr>
        </table>
</div>

</FORM>

</BODY>
</HTML>
<script type="text/javascript">
	function doselectall(obj) {
		if(obj) $("input[name=usr_i]").each(function(){this.checked = obj.checked;});		
	}

	function doSave(){
		frmMain.submit();
	}
	
	function addUser(){
		var win;
		if(!win){
			win = new Ext.Window({
		           contentEl:"userwin",
		           y:100,
		           width:500,
		           height:400,
		           modal:true,
		           closable:true,
		           closeAction:"hide",
		           buttons:[{text:"<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%>",handler:function(){onUserOk();win.hide();}},{text:"<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>",handler:function(){onUserCancel();win.hide();}}],
		           buttonAlign:"center",
		           title:"<%=SystemEnv.getHtmlLabelName(18454,user.getLanguage())%>"
		        });
		}
		onChangeSharetype();
        win.show();
	}

	function onUserOk(){
		var table = document.getElementById("table_user");
		if(table) {
		 	var sharetype = $GetEle("sharetype").value;
		 	var seclevel = $GetEle("seclevel").value;
		 	var rolelevel = $GetEle("rolelevel").value;
		 	var relatedshareids = $GetEle("relatedshareid").value;

		 	var sharetypetext = $GetEle("sharetype").options[$GetEle("sharetype").selectedIndex].text;
		 	var showrelatedsharenames = document.getElementById("showrelatedsharename").innerHTML;
		 	var roleleveltext = $GetEle("rolelevel").options[$GetEle("rolelevel").selectedIndex].text;

		 	if(sharetype=="5") relatedshareids = "0";
		 	
		 	var relatedshareid = relatedshareids.split(",");
		 	var showrelatedsharename = showrelatedsharenames.split("&nbsp;");

			for(var i=0;i<relatedshareid.length;i++){
				if(!relatedshareid[i]||relatedshareid[i]=="") continue;
			 	var showsharetype = "";
				var showseclevel = "";
				var showsharevalue = "";
				var showid = "0";
				
				var showsharetypetext = "";
				var showsecleveltext = "";
				var showsharevaluetext = "";
				
				if(sharetype=="1"){
					showsharetype = "0";
					showsharetypetext = sharetypetext;
					showseclevel = "";
					showsecleveltext = "";
					showsharevalue = relatedshareid[i];
					showsharevaluetext = showrelatedsharename[i];
				} else if(sharetype=="2"){
					showsharetype = "1";
					showsharetypetext = sharetypetext;
					showseclevel = seclevel;
					showsecleveltext = "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>:" + seclevel;
					showsharevalue = relatedshareid[i];
					showsharevaluetext = showrelatedsharename[i];
				} else if(sharetype=="3"){
					showsharetype = "2";
					showsharetypetext = sharetypetext;
					showseclevel = seclevel;
					showsecleveltext = "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>:" + seclevel;
					showsharevalue = relatedshareid[i];
					showsharevaluetext = showrelatedsharename[i];
				} else if(sharetype=="4"){
					showsharetype = "3";
					showsharetypetext = sharetypetext;
					showseclevel = seclevel;
					showsecleveltext = "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>:" + seclevel + "/" + "<%=SystemEnv.getHtmlLabelName(3005, user.getLanguage())%>:" + roleleveltext;
					showsharevalue = relatedshareid[i] + rolelevel;
					showsharevaluetext = showrelatedsharename[i];
				} else if(sharetype=="5"){
					showsharetype = "4";
					showsharetypetext = sharetypetext;
					showseclevel = seclevel;
					showsecleveltext = "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>:" + seclevel;
					showsharevalue = relatedshareid[i];
					showsharevaluetext = showrelatedsharename[i];
				}
				
				var oRow = table.insertRow(-1);
				var oCell = oRow.insertCell(-1);
				var index = parseInt(document.getElementById("userTotal").value) + 1;
				document.getElementById("userTotal").value = index;
				oCell.innerHTML = "<input type=\"checkbox\" id=\"usr_"+index+"\" class=\"InputStyle\" name=\"usr_i\" value=\""+showid+"\"> " +
								  "<input type=\"hidden\" id=\"usr_id"+index+"\" name=\"usr_id\" value=\""+showid+"\"> " +
								  "<input type=\"hidden\" id=\"usr_sharetype"+index+"\" name=\"usr_sharetype\" value=\""+showsharetype+"\"> " +
								  "<input type=\"hidden\" id=\"usr_seclevel"+index+"\" name=\"usr_seclevel\" value=\""+showseclevel+"\"> " +
								  "<input type=\"hidden\" id=\"usr_sharevalue"+index+"\" name=\"usr_sharevalue\" value=\""+showsharevalue+"\">";
				oCell = oRow.insertCell(-1);
				oCell.innerHTML = showsharetypetext;
				oCell = oRow.insertCell(-1);
				oCell.innerHTML = showsecleveltext;
				oCell = oRow.insertCell(-1);
				oCell.innerHTML = showsharevaluetext;
				oCell = oRow.insertCell(-1);
				oRow = table.insertRow(-1);
				oRow.style.height='1px';
				oCell = oRow.insertCell(-1);
				
				oCell.colSpan = 4;
				oCell.className = "Line";
			}

		 	$GetEle("sharetype").value = "1";
		 	$GetEle("seclevel").value = "";
		 	$GetEle("rolelevel").value = "";
		 	$GetEle("relatedshareid").value = "";
		 	document.getElementById("showrelatedsharename").innerHTML = "";
		 	onChangeSharetype();
		}
	}

	function onUserCancel() {
	 	$GetEle("sharetype").value = "1";
	 	$GetEle("seclevel").value = "";
	 	$GetEle("rolelevel").value = "";
	 	$GetEle("relatedshareid").value = "";
	 	document.getElementById("showrelatedsharename").innerHTML = "";
	 	onChangeSharetype();
	}

	function deleteUser(){
		var chkids = document.getElementsByName("usr_i");
		var count = chkids.length;
		var deleted = 0;
		if(count>0) {
			for(var i=count;i>=0;i--){
				if(chkids[i]&&chkids[i].checked){
					deleted++;
				}
			}
			if(deleted<=0){
				alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
			} else {
				if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){			
					for(var i=count;i>=0;i--){
						if(chkids[i]&&chkids[i].checked){
							var tr = jQuery(chkids[i]).parent().parent();
							if(tr){
							    var nexttr=tr.next();
							    tr.remove();
							    nexttr.remove();
								document.getElementById("userTotal").value = parseInt(document.getElementById("userTotal").value) - 1;
							}
						}
					}
				}
			}
		}
	}

	function onChangeSharetype(){
		var thisvalue=$GetEle("sharetype").value;
		$GetEle("relatedshareid").value="";
		$GetEle("showseclevel").style.display='';
		$GetEle("showseclevel_line").style.display='';
		if(thisvalue==1){
			$GetEle("showresource").style.display='';
			$GetEle("showseclevel").style.display='none';
		    $GetEle("showseclevel_line").style.display='none';
		    $GetEle("seclevel").value=0;
		} else {
			$GetEle("showresource").style.display='none';
		}
		if(thisvalue==2){
	 		$GetEle("showsubcompany").style.display='';
	 		$GetEle("seclevel").value=10;
		} else {
			$GetEle("showsubcompany").style.display='none';
			$GetEle("seclevel").value=10;
		}
		if(thisvalue==3){
		 	$GetEle("showdepartment").style.display='';
		 	$GetEle("seclevel").value=10;
		} else {
			$GetEle("showdepartment").style.display='none';
			$GetEle("seclevel").value=10;
		}
		if(thisvalue==4){
		 	$GetEle("showrole").style.display='';
			$GetEle("showrolelevel").style.display='';
		    $GetEle("showrolelevel_line").style.display='';
		    $GetEle("rolelevel").style.display='';
			$GetEle("seclevel").value=10;
		} else {
			$GetEle("showrole").style.display='none';
			$GetEle("showrolelevel").style.display='none';
		    $GetEle("showrolelevel_line").style.display='none';
		    $GetEle("rolelevel").style.display='none';
			$GetEle("seclevel").value=10;
	    }
		if(thisvalue==5){
		 	$GetEle("seclevel").value=0;
		} else {
			$GetEle("seclevel").value=0;
		}
	}


	function onShowResource(inputename,tdname){
		var ids = jQuery("#"+inputename).val(); 
		var datas=null;
		var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置; 
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+ids);
	    if (datas){
		    if (datas.id!= "" ){
		    	var ids=datas.id.slice(1).split(",");
		    	var names=datas.name.slice(1).split(",");
		    	var i=0;
		    	var strs="";
	            for(i=0;i<ids.length;i++){
	                strs=strs+"<a href=javaScript:openhrm("+ids[i]+"); onclick='pointerXY(event);'>"+names[i]+"</a>&nbsp";
	            }
				jQuery("#"+tdname).html(strs);
			    jQuery("#"+inputename).val(datas.id.slice(1));
			}
			else{
				jQuery("#"+tdname).html("");
				jQuery("#"+inputename).val("");
			}
		}
	}
	function onShowSubcompany(inputename,tdname){
		var ids = jQuery("#"+inputename).val(); 
		var datas=null;
		var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置; 
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+ids);
	    if (datas){
		    if (datas.id!= "" ){
		    	var ids=datas.id.slice(1).split(",");
		    	var names=datas.name.slice(1).split(",");
		    	var i=0;
		    	var strs="";
	            for(i=0;i<ids.length;i++){
	                strs=strs+"<a target='_blank' href='/hrm/company/HrmSubCompanyDsp.jsp?id="+ids[i]+"'>"+names[i]+"</a>&nbsp";
	            }
				jQuery("#"+tdname).html(strs);
			    jQuery("#"+inputename).val(datas.id.slice(1));
			}
			else{
				jQuery("#"+tdname).html("");
				jQuery("#"+inputename).val("");
			}
		}
	}
	function onShowDepartment(inputename,tdname){
		var ids = jQuery("#"+inputename).val();            
		var datas=null;
		var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置; 
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser1.jsp?selectedids="+ids+"&selectedDepartmentIds="+ids);
	    
	    if (datas){
		    if (datas.id!= "" ){
		    	var ids=datas.id.slice(1).split(",");
		    	var names=datas.name.slice(1).split(",");
		    	var i=0;
		    	var strs="";
	            for(i=0;i<ids.length;i++){
	                strs=strs+"<a target='_blank' href=/hrm/company/HrmDepartmentDsp.jsp?id="+ids[i]+">"+names[i]+"</a>&nbsp";
	            }
				jQuery("#"+tdname).html(strs);
				jQuery("#"+inputename).val(datas.id.slice(1));
			}
			else{
				jQuery("#"+tdname).html("");
				jQuery("#"+inputename).val("");
			}
		}
	}
	function onShowRole(inputename,tdname){
		var ids = jQuery("#"+inputename).val();            
		var datas=null;
		var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置; 
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp");
	    
	    if (datas){
		    if (datas.id!= "" ){
				jQuery("#"+tdname).html(datas.name);
				jQuery("#"+inputename).val(datas.id);
			}
			else{
				jQuery("#"+tdname).html("");
				jQuery("#"+inputename).val("");
			}
		}
	}
</script>