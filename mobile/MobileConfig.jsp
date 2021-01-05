
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
<jsp:useBean id="docNewsComInfo" class="weaver.docs.news.DocNewsComInfo" scope="page" />
<jsp:useBean id="secCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="docTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="docComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />

</head>
<%
	if (!HrmUserVarify.checkUserRight("Mobile:Setting", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(23665, user.getLanguage());
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
	String homeLogo = "";
	String headerTxt = "";
	String footerTxt = "";
	String xmlRpcUrl = request.getServerName()+":"+request.getServerPort()+"/"+request.getContextPath();
	String licenseFile = "";
	float version = 1.0f;
	String welcomeImg = "";
	String clientBg = "";
	//取出页眉、页脚、Logo、License、版本信息
	RecordSet rs=new RecordSet();
	rs.executeSql("select * from mobileconfig where mc_type in (1,2,3,4,6,10,11,12) and mc_name='target'");
	while(rs.next()){
		int type = rs.getInt("mc_type");
		if(type==1)
			homeLogo=Util.null2String(rs.getString("mc_value"));
		else if(type==2)
			headerTxt=Util.null2String(rs.getString("mc_value"));
		else if(type==3)
			footerTxt=Util.null2String(rs.getString("mc_value"));
		else if(type==4)
			xmlRpcUrl=Util.null2String(rs.getString("mc_value"));
		else if(type==6)
			licenseFile=Util.null2String(rs.getString("mc_value"));
		else if(type==10)
			version=Float.parseFloat(Util.null2String(rs.getString("mc_value")));
		else if(type==11)
			clientBg=Util.null2String(rs.getString("mc_value"));
		else if(type==12)
			welcomeImg=Util.null2String(rs.getString("mc_value"));
	}
	
	//取出模块配置信息
	int maxindex = 0;
	Map modules = new HashMap();
	Map moduleindex = new HashMap();
	List moduleorder = new ArrayList();
	rs=new RecordSet();
	rs.executeSql("select * from mobileconfig where mc_type = 5 order by mc_scope");
	while(rs.next()){
		String tmpid = Util.null2String(rs.getString("id"));
		String tmptype = Util.null2String(rs.getString("mc_type"));
		String tmpscope = Util.null2String(rs.getString("mc_scope"));
		String tmpmodule = Util.null2String(rs.getString("mc_module"));
		String tmpname = Util.null2String(rs.getString("mc_name"));
		String tmpvalue = Util.null2String(rs.getString("mc_value"));
		
		String tmpfrom="";
		String tmpfromids="";
		String tmpshowstr = "";
		String tmpincludereplay = "";
		
		Map moduleconfig = (Map) modules.get(tmpscope);
		if(moduleconfig==null){
			moduleconfig=new HashMap();
			moduleconfig.put("id",tmpid);
			moduleconfig.put("type",tmptype);
			moduleconfig.put("scope",tmpscope);
			moduleconfig.put("module",tmpmodule);
		}
		
		moduleconfig.put(tmpname,tmpvalue);
		
		if(tmpname.equals("index")){
			if(Util.getIntValue(tmpscope)>maxindex) maxindex = Util.getIntValue(tmpscope);
			
			moduleindex.put(tmpvalue,tmpscope);
			moduleorder.add(Util.getIntValue(tmpvalue));
		}

		if((tmpmodule.equals("2")||tmpmodule.equals("3"))&&tmpname.equals("target")){
			String[] t = new String[]{"","",""};
			if(!"".equals(tmpvalue)) t=Util.TokenizerString2(tmpvalue,"|");
			
			if(t==null||t.length==0) t = new String[]{"","",""};
			if(t.length>2)
			{
				tmpfrom = t[0];
				tmpfromids = t[1];
				tmpincludereplay = t[2];
			}
			tmpshowstr = "";

			if(tmpfromids!=null&&!"".equals(tmpfromids)){
				String[] tid = Util.TokenizerString2(tmpfromids,",");
				for(int i=0;tid!=null&&i<tid.length;i++){
					if(tid[i]==null||"".equals(tid[i])) continue;
					if("1".equals(tmpfrom)){
						tmpshowstr = tmpshowstr + "<a href='/docs/news/NewsDsp.jsp?id="+tid[i]+"'>" + docNewsComInfo.getDocNewsname(tid[i]) +"</a>&nbsp;";
					} else if("2".equals(tmpfrom)){
						tmpshowstr = tmpshowstr + "<a href='/docs/search/DocSearchView.jsp?showtype=0&displayUsage=0&fromadvancedmenu=0&infoId=0&showDocs=0&showTitle=1&maincategory=&subcategory=&seccategory="+tid[i]+"'>"+secCategoryComInfo.getSecCategoryname(tid[i])+"</a>&nbsp;";
					} else if("3".equals(tmpfrom)){
						tmpshowstr = tmpshowstr + "<a href='/docs/docdummy/DocDummyList.jsp?dummyId="+tid[i]+"'>"+docTreeDocFieldComInfo.getTreeDocFieldName(tid[i])+"</a>&nbsp";
					} else if("4".equals(tmpfrom)){
						tmpshowstr = tmpshowstr + "<a href=/docs/docs/DocDsp.jsp?id="+tid[i]+"'>"+docComInfo.getDocname(tid[i])+"</a>&nbsp";
					}
				}
			}
			moduleconfig.put("from",tmpfrom);
			moduleconfig.put("fromids",tmpfromids);
			moduleconfig.put("showstr",tmpshowstr);
			moduleconfig.put("includereplay",tmpincludereplay);
		}
		modules.put(tmpscope,moduleconfig);
	}
	//排序
	Collections.sort(moduleorder);
%>


<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="/mobile/MobileConfigOperation.jsp" enctype="multipart/form-data">
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
						<tr><TH colspan="2"><%=SystemEnv.getHtmlLabelName(22186, user.getLanguage())+":"+version%></TH></tr>
						<TR class=Title>
							<TH colSpan=2><%=SystemEnv.getHtmlLabelName(16451, user.getLanguage())%></TH>
						</TR>
						
						<TR class=Spacing style="height:1px;">
							<TD class=Line1 colSpan=2></TD>
						</TR>
						<tr>
							<td><%=SystemEnv.getHtmlLabelName(18363, user.getLanguage())%>LOGO</td>
							<td class=Field>
								<%
								String homeLogoUrl = "/weaver/weaver.file.FileDownload?fileid="+homeLogo;
								%>
								<input type="hidden" name="flag" value="0">
								<input type="hidden" name="deleteHomeLogoFlag" id="deleteHomeLogoFlag" value="<% if(homeLogo!=null&&!"".equals(homeLogo)){ %>0<%}else{%>1<%}%>">
								<div id="homeLogoDiv" style="display:<% if(homeLogo!=null&&!"".equals(homeLogo)){ %>block<%}else{%>none<%}%>">
									<img src="<%=homeLogoUrl%>" style="height:120px;width:170px">
									<input type="button" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>" onclick="deleteHomeLogo();">
									<script type="text/javascript">
									function deleteHomeLogo(){
										if(window.confirm("<%=SystemEnv.getHtmlLabelName(15097, user.getLanguage())%>")){
											document.getElementById("deleteHomeLogoFlag").value = "1";
											document.getElementById("homeLogoDiv").style.display = "none";
											document.getElementById("homeLogoUpload").style.display = "block";
										}
									}
									</script>
								</div>
								<div id="homeLogoUpload" style="display:<% if(homeLogo!=null&&!"".equals(homeLogo)){ %>none<%}else{%>block<%}%>">
									<input type="file" name="HomeLogo" class="InputStyle" style="width:90%">
								</div>
							</td>
						</tr>
						
						<TR style="height:1px;">
							<TD class=Line colSpan=2></TD>
						</TR>
						<tr>
							<td><%=SystemEnv.getHtmlLabelName(224, user.getLanguage())%></td>
							<td class=Field><input type="text" name="headerTxt" class="InputStyle" style="width:90%" value="<%=headerTxt%>"></td>
						</tr>
						
						<TR style="height:1px;">
							<TD class=Line colSpan=2></TD>
						</TR>
						<tr>
							<td><%=SystemEnv.getHtmlLabelName(323, user.getLanguage())%></td>
							<td class=Field><input type="text" name="footerTxt" class="InputStyle" style="width:90%" value="<%=footerTxt%>"></td>
						</tr>
						
						<TR style="height:1px;">
							<TD class=Line colSpan=2></TD>
						</TR>
						<tr>
							<td>ecology<%=SystemEnv.getHtmlLabelName(110, user.getLanguage())%></td>
							<td class=Field>http://<input type="text" name="XmlRpcUrl" class="InputStyle" style="width:85%" value="<%=xmlRpcUrl%>"></td>
						</tr>
						<TR style="height:1px;">
							<TD class=Line colSpan=2></TD>
						</TR>
						<TR>
							<TD colSpan=2>&nbsp;</TD>
						</TR>
						
						<!-- 模块设置 -->
						<TR class=Title>
							<TH><%=SystemEnv.getHtmlLabelName(23669, user.getLanguage())%></TH>
							<td align="right">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>" onclick="addModuleConfig();">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>" onclick="deleteModuleConfig();">
							</td>
						</TR>
						<TR class=Spacing style="height:1px;">
							<TD class=Line1 colSpan=2></TD>
						</TR>
						<tr>
							<td colspan="2">
							
							<input type="hidden" id="configTotal" name="configTotal" value="<%=moduleorder.size()%>">
							<input type="hidden" id="maxindex" name="maxindex" value="<%=maxindex%>">
							
							<TABLE id="table_module_config" class=BroswerStyle cellspacing="1" cellpadding="1" width="100%">
							<colgroup>
								<col width="1%">
								<col width="19%">
								<col width="20%">
								<col width="8%">
								<col width="10%">
								<col width="10%">
								<%--暂时屏蔽图标设置
								<col width="*">
								--%>
							</colgroup>
							<tr class=DataHeader>
								<th></td>
								<th nowrap><%=SystemEnv.getHtmlLabelName(606, user.getLanguage())%></td>
								<th nowrap><%=SystemEnv.getHtmlLabelName(19049, user.getLanguage())%></td>
								<th nowrap><%=SystemEnv.getHtmlLabelName(15603, user.getLanguage())%></td>
								<th nowrap><%=SystemEnv.getHtmlLabelName(15513, user.getLanguage())%></td>
								<th nowrap><%=SystemEnv.getHtmlLabelName(19480, user.getLanguage())%></td>
								<%--暂时屏蔽图标设置
								<th><%=SystemEnv.getHtmlLabelName(22969, user.getLanguage())%><font color="#666666">&nbsp;[&nbsp;<%=SystemEnv.getHtmlLabelName(25312, user.getLanguage())%>&nbsp;]&nbsp;</font></td>
								--%>
							</tr>
							<TR class=Line><TH colspan="7" ></TH></TR> 
							<%
							//循环取出数据显示
							for(int i=0;i<moduleorder.size();i++){
								String index = moduleorder.get(i)+"";
								String modulescope = (String) moduleindex.get(index);
								Map moduleconfig = (Map) modules.get(modulescope);
							%>
							<tr>
								<td>
									<input type="checkbox" id="chk_<%=modulescope%>" name="chk_id" class="InputStyle">
									<input type="hidden" style="width:60px" id="id_<%=modulescope%>" name="config_ids" value="<%=moduleconfig.get("id")%>">
									<input type="hidden" style="width:60px" id="type_<%=modulescope%>" name="config_types" value="<%=moduleconfig.get("type")%>">
									<input type="hidden" style="width:60px" id="scope_<%=modulescope%>" name="config_scopes" value="<%=modulescope%>">
									<input type="hidden" style="width:60px" id="target_<%=modulescope%>" name="config_targets" value="<%=moduleconfig.get("target")%>">
									<input type="hidden" style="width:60px" id="typeids_<%=modulescope%>" name="config_typeids" value="<%=moduleconfig.get("typeids")%>">
									<input type="hidden" style="width:60px" id="flowids_<%=modulescope%>" name="config_flowids" value="<%=moduleconfig.get("flowids")%>">
									<input type="hidden" style="width:60px" id="nodeids_<%=modulescope%>" name="config_nodeids" value="<%=moduleconfig.get("nodeids")%>">
									<input type="hidden" style="width:60px" id="from_<%=modulescope%>" name="config_froms" value="<%=moduleconfig.get("from")%>">
									<input type="hidden" style="width:60px" id="fromids_<%=modulescope%>" name="config_fromids" value="<%=moduleconfig.get("fromids")%>">
									<input type="hidden" style="width:60px" id="includereplay_<%=modulescope%>" name="config_includereplays" value="<%=moduleconfig.get("includereplay")%>">
									<div style="display:none;" id="showstr_<%=modulescope%>"><%=moduleconfig.get("showstr")%></div>
								</td>
								<td>
									<input type="text" id="label_<%=modulescope%>" name="config_labels" class="InputStyle" style="width:80%" value="<%=moduleconfig.get("label")%>">
								</td>
								<td>
									<select id="module_<%=modulescope%>" name="config_modules" style="width:80%;" onChange="onChangeModule(this,<%=modulescope%>);">
										<option value="1" <%if(moduleconfig.get("module").equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16658, user.getLanguage())%></option>
										<option value="2" <%if(moduleconfig.get("module").equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(316, user.getLanguage())%></option>
										<option value="3" <%if(moduleconfig.get("module").equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(23666, user.getLanguage())%></option>
										<% if(version-2.0 > 0.000001){ %>
										<%-- 暂时屏蔽，待功能完成后开放
										<option value="4" <%if(moduleconfig.get("module").equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2211, user.getLanguage())%></option>
										<option value="5" <%if(moduleconfig.get("module").equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2103, user.getLanguage())%></option>
										--%>
										<option value="6" <%if(moduleconfig.get("module").equals("6")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1515, user.getLanguage())%></option>
										<option value="7" <%if(moduleconfig.get("module").equals("7")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17992, user.getLanguage())%></option>
										<option value="8" <%if(moduleconfig.get("module").equals("8")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17991, user.getLanguage())%></option>
										<option value="9" <%if(moduleconfig.get("module").equals("9")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1210, user.getLanguage())%></option>
										<option value="10" <%if(moduleconfig.get("module").equals("10")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21639, user.getLanguage())%></option>										
										<% } else { %>
										<option value="4" <%if(moduleconfig.get("module").equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2211, user.getLanguage())%></option>
										<option value="5" <%if(moduleconfig.get("module").equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2103, user.getLanguage())%></option>
										<option value="6" <%if(moduleconfig.get("module").equals("6")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1515, user.getLanguage())%></option>
										<% } %>
									</select>
								</td>
								<td>
								<input type="checkbox" id="visible_<%=modulescope%>" name="config_visibles" <%if(moduleconfig.get("label")!=null&&"1".equals(moduleconfig.get("visible"))){%>checked<%}%> value="<%=modulescope%>">
								</td>
								<td>
								<input type="text" id="index_<%=modulescope%>" name="config_indexs" class="InputStyle" onKeyPress="ItemCount_KeyPress()" style="width:80%" value="<%=index%>">
								</td>
								<td>
									<div id="module_setting_<%=modulescope%>">
									<% if(moduleconfig.get("module")!=null&&"1".equals(moduleconfig.get("module"))){ %>
									<input type="button" value="<%=SystemEnv.getHtmlLabelName(68, user.getLanguage())%>" onclick="showworkflowfrom(<%=modulescope%>);">
									<% } else if(moduleconfig.get("module")!=null&&"2".equals(moduleconfig.get("module"))){ %>
									<input type="button" value="<%=SystemEnv.getHtmlLabelName(68, user.getLanguage())%>" onclick="showDocumentFrom(<%=modulescope%>);">
									<% } else if(moduleconfig.get("module")!=null&&"3".equals(moduleconfig.get("module"))){ %>
									<input type="button" value="<%=SystemEnv.getHtmlLabelName(68, user.getLanguage())%>" onclick="showDocumentFrom(<%=modulescope%>);">
									<% } else if((version-2.0 > 0.000001)&&moduleconfig.get("module")!=null&&("7".equals(moduleconfig.get("module"))
											||"8".equals(moduleconfig.get("module"))||"9".equals(moduleconfig.get("module"))||"10".equals(moduleconfig.get("module")))){%>
									<input type="button" value="<%=SystemEnv.getHtmlLabelName(68, user.getLanguage())%>" onclick="showworkflowfrom(<%=modulescope%>);">
									<% } %>
									</div>
								</td>
								<%--暂时屏蔽图标设置
								<td>
								--%>
								<td style="display:none">
									<% 
									String icon = (String)moduleconfig.get("icon"); 
									String iconUrl = "/weaver/weaver.file.FileDownload?fileid="+icon;
									%>
									<input type="hidden" id="deleteIconFlag_<%=modulescope%>" name="config_deleteiconflags" value="<% if(icon!=null&&!"".equals(icon)){ %>0<%}else{%>1<%}%>">
									<input type="hidden" id="iconindex_<%=modulescope%>" name="config_iconindexs" value="<%=modulescope%>">
									<div id="iconDiv_<%=modulescope%>" style="display:<% if(icon!=null&&!"".equals(icon)){ %>block<%}else{%>none<%}%>">
										<img src="<%=iconUrl%>">
										<input type="hidden" id="iconid__<%=modulescope%>" name="config_iconids" value="<%=icon%>">
										<input type="button" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>" onclick="deleteIcon(<%=modulescope%>);">
									</div>
									<div id="iconUpload_<%=modulescope%>" style="display:<% if(icon!=null&&!"".equals(icon)){ %>none<%}else{%>block<%}%>">
										<input type="file" id="icon_<%=modulescope%>" name="config_iconfile_<%=modulescope%>" class="InputStyle">
									</div>
								</td>
							</tr>
							<TR style="height:1px;">
								<TD class=Line colSpan=7></TD>
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
		<td></td>
	</tr>
</table>

<script type="text/javascript">
function deleteIcon(modulescope){
	if(window.confirm("<%=SystemEnv.getHtmlLabelName(15097, user.getLanguage())%>")){
		document.getElementById("deleteIconFlag_"+modulescope).value = "1";
		document.getElementById("iconDiv_"+modulescope).style.display = "none";
		document.getElementById("iconUpload_"+modulescope).style.display = "block";
	}
}
</script>

<div id="workflowwin" class="x-hidden">
<iframe BORDER=0 FRAMEBORDER='no' NORESIZE=NORESIZE id='ifrmViewType' name='ifrmViewType' width='100%' height='400px' scrolling='NO' src=''></iframe>
</div>

<div id="documentwin" class="x-hidden">
	<table class=viewform width="100%" height="100%">
		<colgroup>
			<col width='27%' />
			<col width='73%' />
		</colgroup>
		<TR>
			<TD>
				<input type=radio name=rdi_0 id=news_0 value=''> <%=SystemEnv.getHtmlLabelName(16356,user.getLanguage())%><!--新闻中心-->
			</TD>
			<td>
				<BUTTON class=Browser onclick=onSelectNew("news_0","spannews_0",0)></BUTTON>
				<SPAN id="spannews_0"></SPAN>
			</TD>
		</TR>
		<TR>
			<TD>
				<input type=radio name=rdi_0 id=cate_0 value=''> <%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%><!--文档目录-->
			</TD>
			<TD>
				<BUTTON class=Browser onclick=onSelectMultiCatalog("cate_0","spancate_0",0)></BUTTON>
				<SPAN id=spancate_0></SPAN><br><input id=chkcate_0 type=checkbox name=chk_0><%=SystemEnv.getHtmlLabelName(20568,user.getLanguage())%></TD>
			</TD>
		</TR>
		<TR>
			<TD>
				<input type=radio name=rdi_0 id=dummy_0 value=''> <%=SystemEnv.getHtmlLabelName(20482,user.getLanguage())%><!--虚拟目录-->
			</TD>
			<TD>
				<BUTTON class=Browser onClick=onSelectMutiDummy("dummy_0","spandummy_0",0)></BUTTON>
				<SPAN id=spandummy_0></SPAN><br><input id=chkdummy_0 type=checkbox name=chk_0><%=SystemEnv.getHtmlLabelName(20568,user.getLanguage())%></TD>
			</TD>
		</TR>
		<TR>
			<TD>
				<input type=radio name=rdi_0 id=docids_0 value=''> <%=SystemEnv.getHtmlLabelName(20533,user.getLanguage())%><!--指定文档-->
			</TD>
			<TD>
				<BUTTON class=Browser onclick=onSelectMDocs("docids_0","spandocids_0",0)></BUTTON>
				<SPAN ID=spandocids_0></SPAN>
			</TD>
		</TR>
		<TR style="height:1px;">
			<TD CLASS=LINE COLSPAN=2></TD>
		</TR>
	</table>
</div>

</FORM>

</BODY>
</HTML>
<script type="text/javascript">
	function doSave(){
		if(doCheck()) {
			frmMain.submit();
		}
	}
	
	function doCheck() {
		var existedindexs = new Array();
		var configindexs = document.getElementsByName("config_indexs");
		if(configindexs&&configindexs.length>0){
			for(var i=0;i<configindexs.length;i++) {
				var value = configindexs[i].value;
				for(var j=0;j<existedindexs.length;j++){
					if(existedindexs[j]==value) {
						alert("<%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18082,user.getLanguage())%> !");
						return false;
					}
				}
				existedindexs.push(value);
			}
		}
	}
	
	function showworkflowfrom(scope) {
		document.getElementById("ifrmViewType").src = "WorkflowCenterBrowser.jsp?scope=" + scope;
		var win;
		if(!win){
			win = new Ext.Window({
		           contentEl:"workflowwin",
		           width:500,
		           height:470,
		           modal:true,
		           closable:true,
		           closeAction:"hide",
		           buttons:[{text:"<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%>",handler:function(){onWorkflowOk(scope);win.hide();}},{text:"<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>",handler:function(){onWorkflowCancel(scope);win.hide();}}],
		           buttonAlign:"center",
		           title:"<%=SystemEnv.getHtmlLabelName(21672,user.getLanguage())%>"
		        });
		}
        win.show();
	}

	function onWorkflowOk(scope) {
		window.frames["ifrmViewType"].window.onGetChecked();
		document.getElementById("typeids_"+scope).value = window.frames["ifrmViewType"].document.getElementById("typeids").value;
		document.getElementById("flowids_"+scope).value = window.frames["ifrmViewType"].document.getElementById("flowids").value;
		document.getElementById("nodeids_"+scope).value = window.frames["ifrmViewType"].document.getElementById("nodeids").value;
	}

	function onWorkflowCancel(scope) {
		document.getElementById("ifrmViewType").src = "";
	}
	
	function clearDocumentForm() {
		document.getElementById("news_0").value = "";
		document.getElementById("spannews_0").innerHTML = "";
		
		document.getElementById("cate_0").value = "";
		document.getElementById("spancate_0").innerHTML = "";
		document.getElementById("chkcate_0").checked = false;
		
		document.getElementById("dummy_0").value = "";
		document.getElementById("spandummy_0").innerHTML = "";
		document.getElementById("chkdummy_0").checked = false;
		
		document.getElementById("docids_0").value = "";
		document.getElementById("spandocids_0").innerHTML = "";
	}	
	
	function initDocumentForm(scope) {
		if(document.getElementById("from_"+scope).value=="1") {
			document.getElementById("news_0").checked = true;
			document.getElementById("news_0").value = document.getElementById("fromids_"+scope).value;
			document.getElementById("spannews_0").innerHTML = document.getElementById("showstr_"+scope).innerHTML;
		}
		
		if(document.getElementById("from_"+scope).value=="2") {
			document.getElementById("cate_0").checked = true;
			document.getElementById("cate_0").value = document.getElementById("fromids_"+scope).value;
			document.getElementById("spancate_0").innerHTML = document.getElementById("showstr_"+scope).innerHTML;
			if(document.getElementById("includereplay_"+scope).value=="1")
				document.getElementById("chkcate_0").checked = true;
			else
				document.getElementById("chkcate_0").checked = false;
		}
		
		if(document.getElementById("from_"+scope).value=="3") {
			document.getElementById("dummy_0").checked = true;
			document.getElementById("dummy_0").value = document.getElementById("fromids_"+scope).value;
			document.getElementById("spandummy_0").innerHTML = document.getElementById("showstr_"+scope).innerHTML;
			if(document.getElementById("includereplay_"+scope).value=="1")
				document.getElementById("chkdummy_0").checked = true;
			else
				document.getElementById("chkdummy_0").checked = false;
		}
		
		if(document.getElementById("from_"+scope).value=="4") {
			document.getElementById("docids_0").checked = true;
			document.getElementById("docids_0").value = document.getElementById("fromids_"+scope).value;
			document.getElementById("spandocids_0").innerHTML = document.getElementById("showstr_"+scope).innerHTML;
		}
	}	
	
	function showDocumentFrom(scope) {
		var win;
		if(!win){
			win = new Ext.Window({
		           contentEl:"documentwin",
		           width:500,
		           height:400,
		           modal:true,
		           closable:true,
		           closeAction:"hide",
		           buttons:[{text:"<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%>",handler:function(){onDocumentOk(scope);win.hide();}},{text:"<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>",handler:function(){onDocumentCancel(scope);win.hide();}}],
		           buttonAlign:"center",
		           title:"<%=SystemEnv.getHtmlLabelName(20532,user.getLanguage())%>"
		        });
		}
        win.show();
		clearDocumentForm();
		initDocumentForm(scope);
	}

	function onDocumentOk(scope) {
		var from = "";
		var fromids = "";
		var includereplay = "";
		var showstr = "";
		
		if(document.getElementById("news_0").checked) {
			from = "1";
			fromids = document.getElementById("news_0").value;
			includereplay = "0";
			showstr = document.getElementById("spannews_0").innerHTML;
		}
		
		if(document.getElementById("cate_0").checked) {
			from = "2";
			fromids = document.getElementById("cate_0").value;
			includereplay = document.getElementById("chkcate_0").checked?"1":"0";
			showstr = document.getElementById("spancate_0").innerHTML;
		}
		
		if(document.getElementById("dummy_0").checked) {
			from = "3";
			fromids = document.getElementById("dummy_0").value;
			includereplay = document.getElementById("chkdummy_0").checked?"1":"0";
			showstr = document.getElementById("spandummy_0").innerHTML;
		}
		
		if(document.getElementById("docids_0").checked) {
			from = "4";
			fromids = document.getElementById("docids_0").value;
			includereplay = "0";
			showstr = document.getElementById("spandocids_0").innerHTML;
		}
		
		document.getElementById("from_"+scope).value = from;
		document.getElementById("fromids_"+scope).value = fromids;
		document.getElementById("includereplay_"+scope).value = includereplay;
		document.getElementById("showstr_"+scope).innerHTML = showstr;
		document.getElementById("target_"+scope).value = from + "|" + fromids + "|" + includereplay;
		
		clearDocumentForm();
	}

	function onDocumentCancel(scope) {
		clearDocumentForm();
	}

	function onSelectNew(input,span,scope) {
		var vbid = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/news/NewsBrowser.jsp");
		if(vbid) {
			clearDocumentForm();
			document.getElementById("news_0").checked = true;
			if (vbid.id!="") {
				document.getElementById(span).innerHTML = "<a href='/docs/news/NewsDsp.jsp?id="+vbid.id+"'>"+vbid.name+"</a>";
				document.getElementById(input).value=vbid.id;
			} else { 
				document.getElementById(span).innerHtml = "";
				document.getElementById(input).value="0";
			}
		}
	}

	function onSelectMultiCatalog(input,span,scope){
		var vbid = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp?selectids="+$("#"+input).val());
		if(vbid) {
			clearDocumentForm();
			document.getElementById("cate_0").checked = true;
			if (vbid.id!="") {
				var dummyidArray = vbid.id.split(",");
				var dummynames = vbid.name.split(",");
				var sHtml = "";
				for(var k=0;k<dummyidArray.length;k++){
					if(dummyidArray[k]&&dummynames[k]&&dummyidArray[k]!=""&&dummynames[k]!="")
						sHtml = sHtml+"<a href='/docs/search/DocSearchView.jsp?showtype=0&displayUsage=0&fromadvancedmenu=0&infoId=0&showDocs=0&showTitle=1&maincategory=&subcategory=&seccategory="+dummyidArray[k]+"'>"+dummynames[k]+"</a>&nbsp";
				}
				document.getElementById(input).value=vbid.id;
				document.getElementById(span).innerHTML=sHtml;
			} else {			
				document.getElementById(input).value="0";
				document.getElementById(span).innerHTML="";
			}
		}
	}

	function onSelectMutiDummy(input,span,scope) {
		var vbid = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="+$("#"+input).val());
		if(vbid) {
			clearDocumentForm();
			document.getElementById("dummy_0").checked = true;
			if (vbid.id!="") {
				dummyidArray=vbid.id.split(",");
				dummynames=vbid.name.split(",");
				var sHtml = "";
				for(var k=0;k<dummyidArray.length;k++){
					if(dummyidArray[k]&&dummynames[k]&&dummyidArray[k]!=""&&dummynames[k]!="")
						sHtml = sHtml+"<a href='/docs/docdummy/DocDummyList.jsp?dummyId="+dummyidArray[k]+"'>"+dummynames[k]+"</a>&nbsp";
				}
				document.getElementById(input).value=vbid.id;
				document.getElementById(span).innerHTML=sHtml;
			} else {			
				document.getElementById(input).value="0";
				document.getElementById(span).innerHTML="";
			}
		}
	}

	function onSelectMDocs(input,span,scope){
		var vbid = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="+$("#"+input).val());
		if(vbid) {
			clearDocumentForm();
			document.getElementById("docids_0").checked = true;
			if (vbid.id!="") {
				dummyidArray=vbid.id.split(",");
				dummynames=vbid.name.split(",");
				var sHtml = "";
				for(var k=0;k<dummyidArray.length;k++){
					if(dummyidArray[k]&&dummynames[k]&&dummyidArray[k]!=""&&dummynames[k]!="")
						sHtml = sHtml+"<a href=/docs/docs/DocDsp.jsp?id="+dummyidArray[k]+"'>"+dummynames[k]+"</a>&nbsp";
				}
				document.getElementById(input).value=vbid.id;
				document.getElementById(span).innerHTML = sHtml;
			} else {
				document.getElementById(input).value="0";
				document.getElementById(span).innerHTML ="";
			}
		}
	}
	
	function onChangeModule(obj,scope){
		document.getElementById("target_"+scope).value = "";
		document.getElementById("typeids_"+scope).value = "";
		document.getElementById("flowids_"+scope).value = "";
		document.getElementById("nodeids_"+scope).value = "";
		document.getElementById("from_"+scope).value = "";
		document.getElementById("fromids_"+scope).value = "";
		document.getElementById("includereplay_"+scope).value = "";
		document.getElementById("showstr_"+scope).innerHTML = "";
		if(obj.value=="1"<%if(version-2.0 > 0.000001){%>||obj.value=="7"||obj.value=="8"||obj.value=="9"||obj.value=="10"<%}%>){
			document.getElementById("module_setting_"+scope).innerHTML = "<input type=\"button\" value=\"<%=SystemEnv.getHtmlLabelName(68, user.getLanguage())%>\" onclick=\"showworkflowfrom("+scope+");\">";
		} else if(obj.value=="2"||obj.value=="3"){
			document.getElementById("module_setting_"+scope).innerHTML = "<input type=\"button\" value=\"<%=SystemEnv.getHtmlLabelName(68, user.getLanguage())%>\" onclick=\"showDocumentFrom("+scope+");\">";
		} else {
			document.getElementById("module_setting_"+scope).innerHTML = "";
		}
	}
	
	function addModuleConfig(){
		var table = document.getElementById("table_module_config");
		if(table) {
			var oRow = table.insertRow(-1);
			var oCell = oRow.insertCell(-1);
			var index = parseInt(document.getElementById("maxindex").value) + 1;
			document.getElementById("maxindex").value = index;
			var total = parseInt(document.getElementById("configTotal").value) + 1;
			document.getElementById("configTotal").value = total;
			
			oCell.innerHTML = 
			"<input type=\"checkbox\" id=\"chk_"+index+"\" class=\"InputStyle\" name=\"chk_id\" value=\"0\"> " +
			"<input type=\"hidden\" style=\"width:60px\" id=\"id_"+index+"\" name=\"config_ids\" value=\"0\"> " +
			"<input type=\"hidden\" style=\"width:60px\" id=\"type_"+index+"\" name=\"config_types\" value=\"5\"> " +
			"<input type=\"hidden\" style=\"width:60px\" id=\"scope_"+index+"\" name=\"config_scopes\" value=\""+index+"\"> " +
			"<input type=\"hidden\" style=\"width:60px\" id=\"target_"+index+"\" name=\"config_targets\" value=\"\"> " +
			"<input type=\"hidden\" style=\"width:60px\" id=\"typeids_"+index+"\" name=\"config_typeids\" value=\"\"> " +
			"<input type=\"hidden\" style=\"width:60px\" id=\"flowids_"+index+"\" name=\"config_flowids\" value=\"\"> " +
			"<input type=\"hidden\" style=\"width:60px\" id=\"nodeids_"+index+"\" name=\"config_nodeids\" value=\"\"> " +
			"<input type=\"hidden\" style=\"width:60px\" id=\"from_"+index+"\" name=\"config_froms\" value=\"\"> " +
			"<input type=\"hidden\" style=\"width:60px\" id=\"fromids_"+index+"\" name=\"config_fromids\" value=\"\"> " +
			"<input type=\"hidden\" style=\"width:60px\" id=\"includereplay_"+index+"\" name=\"config_includereplays\" value=\"\"> " +
			"<div style=\"display:none;\" id=\"showstr_"+index+"\"></div>";
			oCell = oRow.insertCell(-1);
			oCell.innerHTML = 
			"<input type=\"text\" id=\"label_"+index+"\" name=\"config_labels\" class=\"InputStyle\" style=\"width:80%\" value=\"\">";
			oCell = oRow.insertCell(-1);
			oCell.innerHTML = 
			"<select id=\"module_"+index+"\" name=\"config_modules\" onKeyPress=\"ItemCount_KeyPress()\" style=\"width:80%;\" onChange=\"onChangeModule(this,"+index+");\">"+
			"<option value=\"1\" selected><%=SystemEnv.getHtmlLabelName(16658, user.getLanguage())%></option>"+
			"<option value=\"2\"><%=SystemEnv.getHtmlLabelName(316, user.getLanguage())%></option>"+
			"<option value=\"3\"><%=SystemEnv.getHtmlLabelName(23666, user.getLanguage())%></option>"+
			<% if(version-2.0 > 0.000001){ %>
			<%-- 暂时屏蔽，待功能完成后开放
			"<option value=\"4\"><%=SystemEnv.getHtmlLabelName(2211, user.getLanguage())%></option>"+
			"<option value=\"5\"><%=SystemEnv.getHtmlLabelName(2103, user.getLanguage())%></option>"+
			--%>
			"<option value=\"6\"><%=SystemEnv.getHtmlLabelName(1515, user.getLanguage())%></option>"+
			"<option value=\"7\"><%=SystemEnv.getHtmlLabelName(17992, user.getLanguage())%></option>"+
			"<option value=\"8\"><%=SystemEnv.getHtmlLabelName(17991, user.getLanguage())%></option>"+
			"<option value=\"9\"><%=SystemEnv.getHtmlLabelName(1210, user.getLanguage())%></option>"+
			"<option value=\"10\"><%=SystemEnv.getHtmlLabelName(21639, user.getLanguage())%></option>"+
			<% } else { %>
			"<option value=\"4\"><%=SystemEnv.getHtmlLabelName(2211, user.getLanguage())%></option>"+
			"<option value=\"5\"><%=SystemEnv.getHtmlLabelName(2103, user.getLanguage())%></option>"+
			"<option value=\"6\"><%=SystemEnv.getHtmlLabelName(1515, user.getLanguage())%></option>"+
			<% } %>
			"</select>";
			oCell = oRow.insertCell(-1);
			oCell.innerHTML =
			"<input type=\"checkbox\" checked name=\"config_visibles\" id=\"visible_"+index+"\" value=\""+index+"\">";
			oCell = oRow.insertCell(-1);
			oCell.innerHTML = 
			"<input type=\"text\" id=\"index_"+index+"\" name=\"config_indexs\" class=\"InputStyle\" style=\"width:80%\" value=\""+total+"\">";
			oCell = oRow.insertCell(-1);
			oCell.innerHTML = 
			"<div id=\"module_setting_"+index+"\">"+
			"<input type=\"button\" value=\"<%=SystemEnv.getHtmlLabelName(68, user.getLanguage())%>\" onclick=\"showworkflowfrom("+index+");\">"+
			"</div>";
			oCell = oRow.insertCell(-1);
			oCell.innerHTML = 
			"<input type=\"hidden\" id=\"deleteIconFlag_"+index+"\" name=\"config_deleteiconflags\" value=\"1\">"+
			"<input type=\"hidden\" id=\"iconindex_"+index+"\" name=\"config_iconindexs\" value=\""+index+"\">"+
			"<div id=\"iconUpload_"+index+"\" style=\"display:block\">"+
			"	<input type=\"file\" id=\"icon_"+index+"\" name=\"config_iconfile_"+index+"\" class=\"InputStyle\" style=\"width:90%\">"+
			"</div>";
			oRow = table.insertRow(-1);
			oCell = oRow.insertCell(-1);
			oCell.colSpan = 7;
			oCell.className = "Line";
		}
	}
	
	function deleteModuleConfig(){
		var chkids = document.getElementsByName("chk_id");
		var count = chkids.length;
		for(var i=count-1;i>=0;i--){
			if(chkids[i]&&chkids[i].checked){
				var tr = jQuery(chkids[i]).parent().parent()[0];
				if(tr){
					jQuery(tr).parent()[0].deleteRow(tr.rowIndex+1);
					jQuery(tr).parent()[0].deleteRow(tr.rowIndex);
					document.getElementById("configTotal").value = parseInt(document.getElementById("configTotal").value) - 1;
				}
			}
		}
	}
</script>