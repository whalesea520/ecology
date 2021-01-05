
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />

<%@page import="weaver.hrm.resource.HrmSynDAO"%>
<%@page import="org.apache.commons.lang.StringUtils"%><HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs2_wev8.css" rel="stylesheet" />
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/jQuery.modalDialog_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/wuiform/jquery.wuiform_wev8.js"></script>


<STYLE>
	.vis1	{ visibility:visible }
	.vis2	{ visibility:hidden }
	.vis3   { display:inline}
	.vis4   { display:none }
	
	table.setbutton td
	{
		padding-top:10px; 
	}
	table ul#tabs
	{
		width:85%!important;
	}
</STYLE>
</head>
<%
if(!HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user)){
 	response.sendRedirect("/notice/noright.jsp");
 	return;
}

String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = "HR"+SystemEnv.getHtmlLabelName(32214,user.getLanguage());//同步集成";
String isimportsuccess = Util.null2String(request.getParameter("isimportsuccess"));
String filename = Util.null2String(request.getParameter("filename"));
String needfav ="1";
String needhelp ="";
String isuselhr = "";
String intetype = "1";
String dbsource = "";
String webserviceurl = "";
String invoketype = "";
String customparams = "";
String custominterface = "";
String hrmethod = "";
String TimeModul = "0";
String Frequency = "";
String frequencyy = "";
String createType = "";
String createTime = "";
String jobtable = "";
String depttable = "";
String subcomtable = "";
String hrmtable = "";
String jobmothod = "";
String deptmothod = "";
String subcommothod = "";
String hrmmethod = "";

String jobparam = "";
String deptparam = "";
String subcomparam = "";
String hrmparam = "";
String subcomouternew = "";
String deptouternew = "";
String jobouternew = "";
String hrmouternew = "";

String defaultPwd = "";//密码默认值
String pwdSyncType = "";//默认密码同步规则
String issynrtx = "";//是否同步rtx

String tiptitle1 = SystemEnv.getHtmlLabelName(32215,user.getLanguage());//"选择数据库方式时，需要填写岗位、部门、分部、人员待同步数据的表；如果选择WEBSERVICE方式，则需要填写WEBSERVICE路径，对应接口方法，需要传递的参数，返回值必须是XML格式，在明细中需要填写XPATH路径，以便程序获得正确的数据。"; 
String tiptitle2 = SystemEnv.getHtmlLabelName(27919,user.getLanguage());//"需要调用的WebService服务的地址，不需要后面的\"?wsdl\""; 
boolean canexport = false;
String sql = "select * from hrsyncset";
rs.executeSql(sql);
if(rs.next())
{
	isuselhr = Util.null2String(rs.getString("isuselhr"));
	intetype = Util.null2String(rs.getString("intetype"));
	dbsource = Util.null2String(rs.getString("dbsource"));
	webserviceurl = Util.null2String(rs.getString("webserviceurl"));
	invoketype = Util.null2String(rs.getString("invoketype"));
	customparams = Util.null2String(rs.getString("customparams"));
	custominterface = Util.null2String(rs.getString("custominterface"));
	hrmethod = Util.null2String(rs.getString("hrmethod"));
	TimeModul = Util.null2String(rs.getString("TimeModul"));
	Frequency = Util.null2String(rs.getString("Frequency"));
	frequencyy = Util.null2String(rs.getString("frequencyy"));
	createType = Util.null2String(rs.getString("createType"));
	createTime = Util.null2String(rs.getString("createTime"));
	jobtable = Util.null2String(rs.getString("jobtable"));
	depttable = Util.null2String(rs.getString("depttable"));
	subcomtable = Util.null2String(rs.getString("subcomtable"));
	hrmtable = Util.null2String(rs.getString("hrmtable"));
	jobmothod = Util.null2String(rs.getString("jobmothod"));
	deptmothod = Util.null2String(rs.getString("deptmothod"));
	subcommothod = Util.null2String(rs.getString("subcommothod"));
	hrmmethod = Util.null2String(rs.getString("hrmmethod"));
	
	jobparam = Util.null2String(rs.getString("jobparam"));
	deptparam = Util.null2String(rs.getString("deptparam"));
	subcomparam = Util.null2String(rs.getString("subcomparam"));
	hrmparam = Util.null2String(rs.getString("hrmparam"));
	
	subcomouternew = Util.null2String(rs.getString("subcomouternew"));
	deptouternew = Util.null2String(rs.getString("deptouternew"));
	jobouternew = Util.null2String(rs.getString("jobouternew"));
	hrmouternew = Util.null2String(rs.getString("hrmouternew"));
	canexport = true;
	
	defaultPwd = Util.null2String(rs.getString("defaultPwd"));//密码默认值
	
	pwdSyncType = Util.null2String(rs.getString("pwdsynctype"));//默认密码同步规则
	
	issynrtx = Util.null2String(rs.getString("issynrtx"));//是否同步rtx
}else{
	issynrtx = "1";
}
%>

<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(canexport){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+",javascript:exportFile(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(18596,user.getLanguage())+",javascript:importFile(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onSave()"/>
			<%if(canexport){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(17416 ,user.getLanguage()) %>" class="e8_btn_top" onclick="exportFile();"/>
			<%} %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(18596 ,user.getLanguage()) %>" class="e8_btn_top" onclick="importFile();"/>
			<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
</div>
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
</div>
<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="/integration/hrsettingOperation.jsp" enctype="multipart/form-data">
<input type="hidden" id="operation" name="operation" value="">
<input type="hidden" id="invoketype" name="invoketype" value="1">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
	  
				  <wea:item><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage()) %></wea:item><!-- 启用 -->
				  <wea:item>
					<input class="inputstyle" tzCheckbox="true" type=checkbox id="isuselhr" name="isuselhr" value="1" <%if(isuselhr.equals("1"))out.print("checked"); %>>
				  </wea:item>
				  <wea:item><%=SystemEnv.getHtmlLabelName(32217,user.getLanguage()) %></wea:item><!-- 集成方式 -->
				  <wea:item>
						<select id="intetype" style='width:180px!important;' name="intetype" onchange="javascript:changeIntegration(this.value);" title="<%=tiptitle1 %>">
							<option value="1" <%if("1".equals(intetype)) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(15024,user.getLanguage()) %></option><!-- 数据库 -->
							<option value="2" <%if("2".equals(intetype)) out.print("selected"); %>>Webservice <%=SystemEnv.getHtmlLabelName(32218,user.getLanguage()) %></option><!-- 接口方式 -->
							<option value="3" <%if("3".equals(intetype)) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(32219,user.getLanguage()) %></option><!-- 自定义方式 -->
						</select>
						<SPAN class="e8tips" style="CURSOR: hand" id=remind title="<%=tiptitle1 %>"><IMG src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN>
				  </wea:item>
		            <%--//QC302947 [80][90]HR同步-解决导入数据后数据源必填项红色感叹号丢失问题 -start--%>
		            <%--//修改说明:出现问题的原因在于无论dbsource的值是否和pointid值匹配,wea-required的value都有值了.--%>
		            <%--//解决方案:新建一个dbsourceFlag变量用来区分这种情况--%>
		            <%
			            String dbsourceFlag = "";
			            ArrayList pointArrayLists = DataSourceXML.getPointArrayList();
			            if (pointArrayLists.contains(dbsource)) {
				            dbsourceFlag= dbsource;
			            }
		            %>
				  <wea:item attributes="{'samePair':'dbsource'}"><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage()) %></wea:item><!-- 数据源 -->
				  <wea:item attributes="{'samePair':'dbsource'}">
				  	<wea:required id="dbsourceimage" required="true" value='<%=dbsourceFlag %>'>
                    <%--//QC302947 [80][90]HR同步-解决导入数据后数据源必填项红色感叹号丢失问题 -end--%>
					<select id="dbsource" style='width:180px!important;' name="dbsource" onchange='checkinput("dbsource","dbsourceimage")'>
						<option></option>
						<%
						ArrayList pointArrayList = DataSourceXML.getPointArrayList();
						for(int i=0;i<pointArrayList.size();i++){
						    String pointid = (String)pointArrayList.get(i);
						    String isselected = "";
						    if(dbsource.equals(pointid)){
						        isselected = "selected";
						    }
						%>
						<option value="<%=pointid%>" <%=isselected%>><%=pointid%></option>
						<%    
						}
					    %>
					</select>
					</wea:required>
				    <!--<input type="button" value="<%=SystemEnv.getHtmlLabelName(68,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage()) %>" onClick="setDataSource();" class="e8_btn_submit"/>-->
				  </wea:item>
                    <%--//QC302947 [80][90]HR同步-解决导入数据后数据源必填项红色感叹号丢失问题 -start--%>
                    <%--//修改说明:出现问题的原因在于无论webserviceurl的值是否和webid值匹配,wea-required的value都有值了.--%>
                    <%--//解决方案:新建一个wsUrlFlag变量用来区分这种情况--%>
                    <%
                        ArrayList<String> wsUrls = new ArrayList<String>();
                        String wsUrlFlag = "";
                        String queryWsregiste = "select * from wsregiste order by id";
                        rs.executeSql(queryWsregiste);
                        while(rs.next()){
                            wsUrls.add(String.valueOf(rs.getInt("id")));
                        }
                        if(wsUrls.contains(webserviceurl)){
                        wsUrlFlag = webserviceurl;
                        }
                    %>
                    <%--//QC302947 [80][90]HR同步-解决导入数据后数据源必填项红色感叹号丢失问题 -start--%>
				  <wea:item attributes="{'samePair':'webservice'}">WEBSERVICE<%=SystemEnv.getHtmlLabelName(110,user.getLanguage()) %></wea:item><!-- 地址 -->
				  <wea:item attributes="{'samePair':'webservice'}">
				  	<wea:required id="webserviceurlimage" required="true" value='<%=wsUrlFlag %>'>
					<select id="webserviceurl" style='width:180px!important;' name="webserviceurl" onchange='checkinput("webserviceurl","webserviceurlimage");ParseWSDL()'>
					  	<option></option>
					  	<%
					  	String sqlweb = "select * from wsregiste order by id";
					  	rs.executeSql(sqlweb);
					  	while(rs.next())
					  	{
					  		String webid = rs.getString("id");
					  		String customname = rs.getString("customname");
					  		String tempwebserviceurl = rs.getString("webserviceurl");
					  		String selectstr = "";
					  		if(webserviceurl.equals(webid))
					  			selectstr = "selected";
					  		out.print("<option value='"+webid+"' "+selectstr+" title='"+tempwebserviceurl+"'>"+customname+"</option>");
					  	}
					    %>
				  	</select>
				  	</wea:required>
				  	<%-- <input type="button" value="<%=SystemEnv.getHtmlLabelName(68,user.getLanguage()) %>Webservice" onClick="setWebservice();" class="e8_btn_submit"/> --%>
				  </wea:item>
				<!--tr class="webservice">
				  <td>WEBSERVICE调用方式</td>
				  <td class=Field>
					<select id="invoketype" name="invoketype">
						<option value="1" <%if("1".equals(invoketype)) out.print("selected"); %>>SOAP</option>
						<option value="2" <%if("2".equals(invoketype)) out.print("selected"); %>>API</option>
					</select>
				  </td>
				</tr>
				<TR class="webservice" style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				  -->
				  <wea:item attributes="{'samePair':'custommethod'}"><%=SystemEnv.getHtmlLabelName(32203,user.getLanguage()) %></wea:item><!-- 自定义接口名 -->
				  <wea:item attributes="{'samePair':'custommethod'}">
				  	<wea:required id="custominterfaceimage" required="true" value='<%=custominterface %>'>
					<input class="inputstyle" type=text size=50 id="custominterface" name="custominterface" value="<%=custominterface %>" onchange='checkinput("custominterface","custominterfaceimage")'>
					</wea:required>
				  	<SPAN class="e8tips" style="CURSOR: hand" id=remind title="<%=SystemEnv.getHtmlLabelName(82931,user.getLanguage())%>"><IMG src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN>
				  </wea:item>
				  <wea:item><%=SystemEnv.getHtmlLabelName(32220,user.getLanguage()) %></wea:item><!-- 同步方式 -->
				  <wea:item>
						<select id="hrmethod" name="hrmethod" style='width:180px!important;'>
							<option value="1" <%if("1".equals(hrmethod)) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(30107,user.getLanguage()) %></option><!-- 手动同步 -->
							<option value="2" <%if("2".equals(hrmethod)) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(32221,user.getLanguage()) %></option><!-- 自动同步 -->
							<option value="3" <%if("3".equals(hrmethod)) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(30107,user.getLanguage())+SystemEnv.getHtmlLabelName(31052,user.getLanguage())+SystemEnv.getHtmlLabelName(32221,user.getLanguage()) %></option><!-- 手动&自动同步 -->
						</select>
				  </wea:item>
				  <wea:item><%=SystemEnv.getHtmlLabelName(32223,user.getLanguage())%></wea:item><!-- 同步频率 -->
				  <wea:item>
				  	<SPAN class=itemspan>
					  	<SELECT style='width:135px!important;float:left;' id="TimeModul" name="TimeModul" onchange="showFre(this.value)">
							<OPTION value="3" <%if("3".equals(TimeModul)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></OPTION><!--天-->
							<OPTION value="0" <%if("0".equals(TimeModul)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1926,user.getLanguage())%></OPTION><!--周-->
							<OPTION value="1" <%if("1".equals(TimeModul)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></OPTION><!--月-->
							<OPTION value="2" <%if("2".equals(TimeModul)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></OPTION><!--年-->
						</SELECT>
					</SPAN>
					<%
						/*String TimeModul = "";
						String Frequency = "";
						String frequencyy = "";
						String createType = "";
						String createTime = "";*/
			
						String a="vis4";
				  		String b="vis4";
				  		String c="vis4";
				  		String d="vis4";
				  		if (Util.null2String(TimeModul).equals("0"))
						{
						    a="vis3";
						}
						else if (Util.null2String(TimeModul).equals("1"))
						{
						    b="vis3";
						}
						else if (Util.null2String(TimeModul).equals("2"))
						{
						    c="vis3";
						}
						else if (Util.null2String(TimeModul).equals("3"))
						{
						    d="vis3";
						}
					%>
					<SPAN class=itemspan>
					&nbsp;&nbsp;&nbsp;
					</SPAN>
					<!--================== 天 ==================-->
					<SPAN id="show_3" class="<%=d%> itemspan" >
						<SPAN class=itemspan>
							<%=SystemEnv.getHtmlLabelName(539,user.getLanguage())%>&nbsp;
						</SPAN>
						<SPAN class=itemspan>
							<SELECT style='width:80px!important;' name="dayTime">
							<%
							for(int i = 0; i < 24; i++)
							{
							%>
								<OPTION value="<%= Util.add0(i, 2) %>:00" <%if((Util.add0(i, 2) + ":00").equals(createTime) && "3".equals(TimeModul)){%>selected<%}%>><%= Util.add0(i, 2) %>:00</OPTION>
							<%
							}
							%>
						  	</SELECT>
					  	</SPAN>
					  	<SPAN class=itemspan>
					  	</SPAN>
					</SPAN>
						
					<!--================== 周 ==================-->
					<SPAN id="show_0" class="<%=a%> itemspan">
						<SPAN class=itemspan>
							<%=SystemEnv.getHtmlLabelName(545,user.getLanguage())%>
						</SPAN>
						<SPAN class=itemspan>
							<SELECT style='width:80px!important;' name="fer_0">
				 				<OPTION value="1" <%if (Frequency.equals("1") && "0".equals(TimeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16100, user.getLanguage())%></OPTION>
				 				<OPTION value="2" <%if (Frequency.equals("2") && "0".equals(TimeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16101, user.getLanguage())%></OPTION>
				 				<OPTION value="3" <%if (Frequency.equals("3") && "0".equals(TimeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16102, user.getLanguage())%></OPTION>
				 				<OPTION value="4" <%if (Frequency.equals("4") && "0".equals(TimeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16103, user.getLanguage())%></OPTION>
				 				<OPTION value="5" <%if (Frequency.equals("5") && "0".equals(TimeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16104, user.getLanguage())%></OPTION>
				 				<OPTION value="6" <%if (Frequency.equals("6") && "0".equals(TimeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16105, user.getLanguage())%></OPTION>
				 				<OPTION value="7" <%if (Frequency.equals("7") && "0".equals(TimeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16106, user.getLanguage())%></OPTION>
							</SELECT>
						</SPAN>
						<SPAN class=itemspan>
							<SELECT style='width:80px!important;' name="weekTime">
							<%
							for(int i = 0; i < 24; i++)
							{
							%>
								<OPTION value="<%= Util.add0(i, 2) %>:00" <%if((Util.add0(i, 2) + ":00").equals(createTime) && "0".equals(TimeModul)){%>selected<%}%>><%= Util.add0(i, 2) %>:00</OPTION>
							<%
							}
							%>
						  	</SELECT>
					  	</span>
					  	<SPAN class=itemspan>
					  	</SPAN>
					</SPAN>
					
					<!--================== 月 ==================-->
					<SPAN id="show_1" class="<%=b%> itemspan">
						<SPAN class=itemspan>
							<%=SystemEnv.getHtmlLabelName(541,user.getLanguage())%>
						</SPAN>
						<SPAN class=itemspan>
							<SELECT style='width:80px!important;' name="monthType">
								<OPTION value="0" <%if (createType.equals("0") && "1".equals(TimeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18817,user.getLanguage())%></OPTION>
								<OPTION value="1" <%if (createType.equals("1") && "1".equals(TimeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18816,user.getLanguage())%></OPTION>
							</SELECT>
						</SPAN>
						<SPAN class=itemspan>
							<%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%>
						</SPAN>
						<SPAN class=itemspan>
							<SELECT style='width:80px!important;' name="fer_1">
							<%
								for (int i = 1; i <= 28; i++) 
								{
							%>
								<OPTION value="<%=i%>" <%if (Util.null2String(Frequency).equals(""+i) && "1".equals(TimeModul)) {%>selected<%}%>><%=i%></OPTION>
							<%
								}
							%>
							</SELECT>
						</span>
						<SPAN class=itemspan>
							<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>&nbsp;
						</SPAN>
						<SPAN class=itemspan>
							<SELECT style='width:80px!important;' name="monthTime">
							<%
							for(int i = 0; i < 24; i++)
							{
							%>
								<OPTION value="<%= Util.add0(i, 2) %>:00" <%if((Util.add0(i, 2) + ":00").equals(createTime) && "1".equals(TimeModul)){%>selected<%}%>><%= Util.add0(i, 2) %>:00</OPTION>
							<%
							}
							%>
						  	</SELECT>
					  	</SPAN>
					  	<SPAN class=itemspan>
						</SPAN>
					</SPAN>
					
					<!--================== 年 ==================-->
					<SPAN id="show_2" class="<%=c%> itemspan">
						<SPAN class=itemspan>
							<%=SystemEnv.getHtmlLabelName(546,user.getLanguage())%>
						</SPAN>
						<SPAN class=itemspan>
							<SELECT style='width:80px!important;' name="fer_2">
						 	<%
						 		for (int i = 1; i <= 12; i++) 
						 		{
						 	%>
								<OPTION value="<%= Util.add0(i, 2) %>" <%if (Util.null2String(Frequency).equals(""+i) && "2".equals(TimeModul)) {%>selected<%}%>><%= Util.add0(i, 2) %></OPTION>
							<%
								}
							%>
							</SELECT>
						</span>
						<SPAN class=itemspan>
							<%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
						</SPAN>
						<SPAN class=itemspan>
							<SELECT style='width:80px!important;' name="yearType">														
								<OPTION value="0" <%if (createType.equals("0") && "2".equals(TimeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18817,user.getLanguage())%></OPTION>
								<OPTION value="1" <%if (createType.equals("1") && "2".equals(TimeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18816,user.getLanguage())%></OPTION>
							</SELECT>
						</span>
						<SPAN class=itemspan>
							<%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%>
						</span>
						<SPAN class=itemspan>
							<SELECT style='width:80px!important;' name="frey">
							<%
								for (int i = 1; i <= 28; i++) 
								{
							%>
								<OPTION value="<%=i%>" <%if(frequencyy.equals(""+i) && "2".equals(TimeModul)) {%>selected<%}%>><%=i%></OPTION>
							<%
								}
							%>
							</SELECT>
						</SPAN>
						<SPAN class=itemspan>
							<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>&nbsp;
						</span>
						<SPAN class=itemspan>
							<%//=Util.null2String(wp.getFrequencyy())%>
							<SELECT style='width:80px!important;' name="yearTime">
							<%
							for(int i = 0; i < 24; i++)
							{
							%>
								<OPTION value="<%= Util.add0(i, 2) %>:00" <%if((Util.add0(i, 2) + ":00").equals(createTime) && "2".equals(TimeModul)){%>selected<%}%>><%= Util.add0(i, 2) %>:00</OPTION>
							<%
							}
							%>
						  	</SELECT>
					  	</SPAN>
					  	<SPAN class=itemspan>
					  		&nbsp;
					  	</SPAN>
					</SPAN>
				  </wea:item>
				  <wea:item attributes="{'samePair':'defaultPwd'}"><%=SystemEnv.getHtmlLabelName(126584, user.getLanguage())%></wea:item>
				  <wea:item attributes="{'samePair':'defaultPwd'}">
						<input class="inputstyle" type=text size=50 id="defaultPwd" name="defaultPwd" value="<%=defaultPwd %>" >
				  </wea:item>
				  <wea:item attributes="{'samePair':'pwdsynctype'}"><%=SystemEnv.getHtmlLabelName(127830, user.getLanguage())%></wea:item><!-- 默认密码同步规则 -->
				  <wea:item attributes="{'samePair':'pwdsynctype'}">
						<select id="pwdsynctype" name="pwdsynctype" style='width:180px!important;'>
							<option value="1" <%if("1".equals(pwdSyncType)) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(127805, user.getLanguage())%></option><!-- MD5加密 -->
							<option value="2" <%if("2".equals(pwdSyncType)) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(77, user.getLanguage())%></option><!-- 复制 -->
						</select>
						<SPAN class="e8tips" style="CURSOR: hand" id=remind title="<%=SystemEnv.getHtmlLabelName(127806,user.getLanguage()) %>"><IMG src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN>
				  </wea:item>
				  	<!--QC:271260HR同步新增一个是否同步rtx选项 -->
				  	<%
				  	RecordSet rs_rtx = new RecordSet();
				  	String isusesynim = "";
				  	rs_rtx.executeSql("select isusedrtx,RtxOrOCSType from rtxsetting");
				  	if(rs_rtx.next()){
				  		if("1".equals(rs_rtx.getString(1)) && ("0".equals(rs_rtx.getString(2)) || "1".equals(rs_rtx.getString(2)))){
				  			isusesynim = "1";
				  		}
				  	}
		  			%>
	  			  <wea:item attributes="{'samePair':'issynrtx'}"><%=SystemEnv.getHtmlLabelName(18240,user.getLanguage())+"IM" %></wea:item><!-- 同步rtx -->
				  <wea:item attributes="{'samePair':'issynrtx'}">
					<input class="inputstyle" tzCheckbox="true" type=checkbox id="issynrtx" name="issynrtx" value="1" <%if(issynrtx.equals("1") && isusesynim.equals("1")){%>checked  <%}if(!isusesynim.equals("1")){%> disabled<%}%> >
					<SPAN class="e8tips" style="CURSOR: hand" id=remind title="<%=SystemEnv.getHtmlLabelName(130654,user.getLanguage()) %>"><IMG src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN>
				  </wea:item>
				  
				  
			</wea:group>
			<wea:group attributes="{'samePair':'SetDBTableInfo','groupOperDisplay':'none','itemAreaDisplay':'none'}" context='<%=SystemEnv.getHtmlLabelName(18240, user.getLanguage())+SystemEnv.getHtmlLabelName(31902, user.getLanguage())+SystemEnv.getHtmlLabelName(68, user.getLanguage())%>'>
				  <wea:item attributes="{'samePair':'dbsource'}"><%=SystemEnv.getHtmlLabelName(32226, user.getLanguage())%></wea:item><!-- 同步分部表设置 -->
				  <wea:item attributes="{'samePair':'dbsource'}">
				  	<wea:required id="subcomtableimage" required="true" value='<%=subcomtable %>'>
				  	<input class="inputstyle" style="float:left" type=text size=50 id="subcomtable" name="subcomtable" value="<%=subcomtable %>" onchange='checkinput("subcomtable","subcomtableimage");clearInput("subcomouternewdiv")'>
				  	</wea:required>
					<SPAN class=itemspan>
						<SPAN style="float:left">
							&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(32243,user.getLanguage())%>&nbsp;
						</span>
						<span class='e8Browser'  id=subcomouternewdiv></span>
					</SPAN>
				  </wea:item>
				  <wea:item attributes="{'samePair':'dbsource'}"><%=SystemEnv.getHtmlLabelName(32225, user.getLanguage())%></wea:item><!-- 同步部门表设置 -->
				  <wea:item attributes="{'samePair':'dbsource'}">
				  	<wea:required id="depttableimage" required="true" value='<%=depttable %>'>
				  	<input class="inputstyle"  style="float:left" type=text size=50 id="depttable" name="depttable" value="<%=depttable %>" onchange='checkinput("depttable","depttableimage");clearInput("deptouternewdiv")'>
				  	</wea:required>
					<SPAN class=itemspan>
						<SPAN  style="float:left">
								&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(32243,user.getLanguage())%>&nbsp;
						</SPAN>
						<span class='e8Browser'  id=deptouternewdiv></span>
					</SPAN>
				  </wea:item>
				  <wea:item attributes="{'samePair':'dbsource'}"><%=SystemEnv.getHtmlLabelName(32224, user.getLanguage())%></wea:item><!-- 同步岗位表设置 -->
				  <wea:item attributes="{'samePair':'dbsource'}">
				  	<wea:required id="jobtableimage" required="false" value='<%=jobtable %>'>
				  	<input class="inputstyle" style="float:left"  type=text size=50 id="jobtable" name="jobtable" value="<%=jobtable %>" onchange='clearInput("jobouternewdiv")'>
				  	</wea:required>
					<SPAN class=itemspan>
						<SPAN style="float:left">
							&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(32243,user.getLanguage())%>&nbsp;
						</span>
						<span class='e8Browser'  id=jobouternewdiv></span>
					</SPAN>
				  </wea:item>
				  <wea:item attributes="{'samePair':'dbsource'}"><%=SystemEnv.getHtmlLabelName(32227, user.getLanguage())%></wea:item><!-- 同步人员表设置 -->
				  <wea:item attributes="{'samePair':'dbsource'}">
				  	<wea:required id="hrmtableimage" required="true" value='<%=hrmtable %>'>
				  	<input class="inputstyle" style="float:left"  type=text size=50 id="hrmtable" name="hrmtable" value="<%=hrmtable %>" onchange='checkinput("hrmtable","hrmtableimage");clearInput("hrmouternewdiv")'>
				  	</wea:required>
					<SPAN class=itemspan>
						<SPAN style="float:left">
							&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(32243,user.getLanguage())%>&nbsp;
						</span>
						<span class='e8Browser'  id=hrmouternewdiv></span>
					</SPAN>
				  </wea:item>
		    </wea:group>
			<wea:group attributes="{'samePair':'SetWebserviceMethodInfo','groupOperDisplay':'none','itemAreaDisplay':'none'}" context='<%=SystemEnv.getHtmlLabelName(18240, user.getLanguage())+SystemEnv.getHtmlLabelName(32363, user.getLanguage())+SystemEnv.getHtmlLabelName(604, user.getLanguage())%>'>
				  <wea:item attributes="{'samePair':'webservice webservicelistparams','colspan':'2'}">
				    <div class="webservicelistparams e8_box" id="tabbox1" style='height:42px;'>
		    			<ul class="tab_menu" id="tabs2" style="width:100%">
		    			   <li style='padding-left:0px!important;'><a href="#" onclick="showListTab2()"><%=SystemEnv.getHtmlLabelName(32232, user.getLanguage())%></a></li><!-- 同步分部接口方法 -->
					       <li><a href="#" onclick="showListTab2()"><%=SystemEnv.getHtmlLabelName(32230, user.getLanguage())%></a></li><!-- 同步部门接口方法 -->
					       <li><a href="#" onclick="showListTab2()"><%=SystemEnv.getHtmlLabelName(32228, user.getLanguage())%></a></li><!-- 同步岗位接口方法 -->
					       <li><a href="#" onclick="showListTab2()"><%=SystemEnv.getHtmlLabelName(32234, user.getLanguage())%></a></li><!-- 同步人员接口方法 -->
					    </ul>
					    <div id="rightBox" class="e8_rightBox" style="width:0px;">
					    </div>
					    <div class="tab_box" style="display:none;">
					    </div>
					</div>
				  </wea:item>
				  <wea:item attributes="{'samePair':'webservice webservicelistparams1 webservicelistparam'}"><%=SystemEnv.getHtmlLabelName(32232, user.getLanguage())%></wea:item><!-- 同步分部接口方法 -->
				  <wea:item attributes="{'samePair':'webservice webservicelistparams1 webservicelistparam'}">
				  	<wea:required id="subcommothodimage" required="true" value='<%=subcommothod %>'>
				  	<select id="subcommothod" style='width:280px!important;' name="subcommothod" onchange='checkinput("subcommothod","subcommothodimage");ParseMethod(this,1);'>
				  	<option></option>
				  	<%
				  	if(!"".equals(webserviceurl))
				  	{
					  	String sqljob = "SELECT * FROM wsregistemethod where mainid="+webserviceurl+" order by methodname,id";
					  	rs.executeSql(sqljob);
					  	while(rs.next())
					  	{
					  		String methodid = rs.getString("id");
					  		String methodname = rs.getString("methodname");
					  		String methoddesc = rs.getString("methoddesc");
					  		String selectstr = "";
					  		if(subcommothod.equals(methodid))
					  			selectstr = "selected";
					  		out.print("<option value='"+methodid+"' "+selectstr+" title='"+methoddesc+"'>"+methodname+"</option>");
					  	}
				  	}
				  	%>
				  	</select>
				  	</wea:required>
				  </wea:item>
				 <!--  <td><%=SystemEnv.getHtmlLabelName(32233, user.getLanguage())%></td>同步分部接口参数 -->
				  <wea:item attributes="{'samePair':'webservice webservicelistparams1 webservicelistparam','colspan':'2','isTableList':'true'}">
				  	<div id="subcommothodparams">
				  		<table class="ListStyle">
				  			<COLGROUP>
				  			<COL width='3%'>
				  			<COL width='15%'>
				  			<COL width='15%'>
				  			<COL width='25%'>
				  			<COL width='15%'>
				  			<COL width='25%'>
				  			<tr class="header">
							   <th>&nbsp;</th>
							   <th style='padding-left:0px!important;'><%=SystemEnv.getHtmlLabelName(20968, user.getLanguage())%></th><!-- 参数名 -->
							   <th><%=SystemEnv.getHtmlLabelName(561, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%></th><!-- 参数类型 -->
							   <th><%=SystemEnv.getHtmlLabelName(32392, user.getLanguage())%></th><!-- 是否数组 -->
							   <th><%=SystemEnv.getHtmlLabelName(32393, user.getLanguage())%></th><!-- 分隔符 -->
							   <th><%=SystemEnv.getHtmlLabelName(17637, user.getLanguage())%></th><!-- 参数值 -->
							</tr>
							<%
						  	if(!"".equals(subcommothod))
						  	{
						  		int countindex = 0;
							  	String sqljob = "SELECT * FROM wsmethodparamvalue where methodid="+subcommothod+" and contenttype=1 order by paramname,id";
							  	rs.executeSql(sqljob);
							  	while(rs.next())
							  	{
							  		String methodid = rs.getString("methodid");
							  		String paramname = rs.getString("paramname");
							  		String paramtype = rs.getString("paramtype");
							  		String isarray = rs.getString("isarray");
							  		String paramsplit = rs.getString("paramsplit");
							  		String paramvalue = rs.getString("paramvalue");
							  		boolean ck=paramvalue.contains("\"");
							  		String ischeck = "";
							  		if("1".equals(isarray))
							  			ischeck = "checked";
							  		countindex++;
							  		String className = "";
							  		if (0 == countindex % 2)
							        {
							            className = "DataLight";
							        }
							        else
							        {
							            className = "DataDark";
							        }
							%>
							<tr class='<%=className %>'>
							   <td>&nbsp;</td>
							   <td style='padding-left:0px!important;'><INPUT type='hidden' name='methodtype' value='1'><INPUT class='Inputstyle' type='text' name='paramname' value='<%=paramname %>' readonly></td>
							   <td><INPUT class='Inputstyle' type='text' name='paramtype' value='<%=paramtype %>' readonly></td>
							   <td><INPUT class='Inputstyle' type='checkbox' name='tempisarray' <%=ischeck %> onclick="if(this.checked){this.parentElement.nextSibling.value=1;}else{this.parentElement.nextSibling.value=0;}"><INPUT type='hidden' name='isarray' value='<%=isarray %>'></td>
							   <td><INPUT class='Inputstyle' type='text' maxLength=10 name='paramsplit' value='<%=paramsplit %>'></td>
							   <%if(ck){ %>
							   <td><INPUT class='Inputstyle' type='text' maxLength=1000 name='paramvalue' value='<%=paramvalue %>' ></td>
							   <%}else{ %>
							   <td><INPUT class='Inputstyle' type='text' maxLength=1000 name='paramvalue' value="<%=paramvalue %>" ></td>
							   <%} %>
						    </tr>
							<%
							  	}
						  	}
						  	%>
						</table>
				  	</div>
				  </wea:item>
				  <wea:item attributes="{'samePair':'webservice webservicelistparams2 webservicelistparam'}"><%=SystemEnv.getHtmlLabelName(32230, user.getLanguage())%></wea:item><!-- 同步部门接口方法 -->
				  <wea:item attributes="{'samePair':'webservice webservicelistparams2 webservicelistparam'}">
				  	<wea:required id="deptmothodimage" required="true" value='<%=deptmothod %>'>
				  	<select id="deptmothod" style='width:280px!important;' name="deptmothod" onchange='checkinput("deptmothod","deptmothodimage");ParseMethod(this,2);'>
				  	<option></option>
				  	<%
				  	if(!"".equals(webserviceurl))
				  	{
					  	String sqljob = "SELECT * FROM wsregistemethod where mainid="+webserviceurl+" order by methodname,id";
					  	rs.executeSql(sqljob);
					  	while(rs.next())
					  	{
					  		String methodid = rs.getString("id");
					  		String methodname = rs.getString("methodname");
					  		String methoddesc = rs.getString("methoddesc");
					  		String selectstr = "";
					  		if(deptmothod.equals(methodid))
					  			selectstr = "selected";
					  		out.print("<option value='"+methodid+"' "+selectstr+" title='"+methoddesc+"'>"+methodname+"</option>");
					  	}
				  	}
				  	%>
				  	</select>
				  	</wea:required>
				  </wea:item>
				  <!-- <td><%=SystemEnv.getHtmlLabelName(32231, user.getLanguage())%></td>同步部门接口参数 -->
				  <wea:item attributes="{'samePair':'webservice webservicelistparams2 webservicelistparam','colspan':'2','isTableList':'true'}">
				  	<div id="deptmothodparams">
				  		<table class="ListStyle">
				  			<COLGROUP>
				  			<COL width='3%'>
				  			<COL width='15%'>
				  			<COL width='15%'>
				  			<COL width='25%'>
				  			<COL width='15%'>
				  			<COL width='30%'>
				  			<tr class="header">
				  				<th>&nbsp;</th>
							   <th style='padding-left:0px!important;'><%=SystemEnv.getHtmlLabelName(20968, user.getLanguage())%></th><!-- 参数名 -->
							   <th><%=SystemEnv.getHtmlLabelName(561, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%></th><!-- 参数类型 -->
							   <th><%=SystemEnv.getHtmlLabelName(32392, user.getLanguage())%></th><!-- 是否数组 -->
							   <th><%=SystemEnv.getHtmlLabelName(32393, user.getLanguage())%></th><!-- 分隔符 -->
							   <th><%=SystemEnv.getHtmlLabelName(17637, user.getLanguage())%></th><!-- 参数值 -->
							</tr>
							<%
						  	if(!"".equals(deptmothod))
						  	{
						  		int countindex = 0;
							  	String sqljob = "SELECT * FROM wsmethodparamvalue where methodid="+deptmothod+" and contenttype=2 order by paramname,id";
							  	rs.executeSql(sqljob);
							  	while(rs.next())
							  	{
							  		String methodid = rs.getString("methodid");
							  		String paramname = rs.getString("paramname");
							  		String paramtype = rs.getString("paramtype");
							  		String isarray = rs.getString("isarray");
							  		String paramsplit = rs.getString("paramsplit");
							  		String paramvalue = rs.getString("paramvalue");
							  		boolean ck=paramvalue.contains("\"");
							  		String ischeck = "";
							  		if("1".equals(isarray))
							  			ischeck = "checked";
							  		countindex++;
							  		String className = "";
							  		if (0 == countindex % 2)
							        {
							            className = "DataLight";
							        }
							        else
							        {
							            className = "DataDark";
							        }
							%>
							<tr class='<%=className %>'>
								<td>&nbsp;</td>
							   <td style='padding-left:0px!important;'><INPUT type='hidden' name='methodtype' value='2'><INPUT class='Inputstyle' type='text' name='paramname' value='<%=paramname %>' readonly></td>
							   <td><INPUT class='Inputstyle' type='text' name='paramtype' value='<%=paramtype %>' readonly></td>
							   <td><INPUT class='Inputstyle' type='checkbox' name='tempisarray' <%=ischeck %> onclick="if(this.checked){this.parentElement.nextSibling.value=1;}else{this.parentElement.nextSibling.value=0;}"><INPUT type='hidden' name='isarray' value='<%=isarray %>'></td>
							   <td><INPUT class='Inputstyle' type='text' maxLength=10 name='paramsplit' value='<%=paramsplit %>'></td>
							    <%if(ck){ %>
							   <td><INPUT class='Inputstyle' type='text' maxLength=1000 name='paramvalue' value='<%=paramvalue %>' ></td>
							   <%}else{ %>
							   <td><INPUT class='Inputstyle' type='text' maxLength=1000 name='paramvalue' value="<%=paramvalue %>" ></td>
							   <%} %>
						    </tr>
							<%
							  	}
						  	}
						  	%>
						</table>
				  	</div>
				  </wea:item>
				  <wea:item attributes="{'samePair':'webservice webservicelistparams3 webservicelistparam'}"><%=SystemEnv.getHtmlLabelName(32228, user.getLanguage())%></wea:item><!-- 同步岗位接口方法 -->
				  <wea:item attributes="{'samePair':'webservice webservicelistparams3 webservicelistparam'}">
				  	<wea:required id="jobmothodimage" required="false" value='<%=jobmothod %>'>
				  	<select id="jobmothod" style='width:280px!important;' name="jobmothod" onchange='ParseMethod(this,3);'>
				  	<option></option>
				  	<%
				  	if(!"".equals(webserviceurl))
				  	{
					  	String sqljob = "SELECT * FROM wsregistemethod where mainid="+webserviceurl+" order by methodname,id";
					  	rs.executeSql(sqljob);
					  	while(rs.next())
					  	{
					  		String methodid = rs.getString("id");
					  		String methodname = rs.getString("methodname");
					  		String methoddesc = rs.getString("methoddesc");
					  		String selectstr = "";
					  		if(jobmothod.equals(methodid))
					  			selectstr = "selected";
					  		out.print("<option value='"+methodid+"' "+selectstr+" title='"+methoddesc+"'>"+methodname+"</option>");
					  	}
				  	}
				  	%>
				  	</select>
				  	</wea:required>
				  </wea:item>
				  <!--<td><%=SystemEnv.getHtmlLabelName(32229, user.getLanguage())%></td> 同步岗位接口参数 -->
				  <wea:item attributes="{'samePair':'webservice webservicelistparams3 webservicelistparam','colspan':'2','isTableList':'true'}">
				  	<div id="jobmothodparams">
				  		<table class="ListStyle">
				  			<COLGROUP>
				  			<COL width='3%'>
				  			<COL width='15%'>
				  			<COL width='15%'>
				  			<COL width='25%'>
				  			<COL width='15%'>
				  			<COL width='30%'>
				  			<tr class="header">
				  				<th>&nbsp;</th>
							   <th style='padding-left:0px!important;'><%=SystemEnv.getHtmlLabelName(20968, user.getLanguage())%></th><!-- 参数名 -->
							   <th><%=SystemEnv.getHtmlLabelName(561, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%></th><!-- 参数类型 -->
							   <th><%=SystemEnv.getHtmlLabelName(32392, user.getLanguage())%></th><!-- 是否数组 -->
							   <th><%=SystemEnv.getHtmlLabelName(32393, user.getLanguage())%></th><!-- 分隔符 -->
							   <th><%=SystemEnv.getHtmlLabelName(17637, user.getLanguage())%></th><!-- 参数值 -->
							</tr>
							<%
						  	if(!"".equals(jobmothod))
						  	{
						  		int countindex = 0;
							  	String sqljob = "SELECT * FROM wsmethodparamvalue where methodid="+jobmothod+" and contenttype=3 order by paramname,id";
							  	rs.executeSql(sqljob);
							  	while(rs.next())
							  	{
							  		String methodid = rs.getString("methodid");
							  		String paramname = rs.getString("paramname");
							  		String paramtype = rs.getString("paramtype");
							  		String isarray = rs.getString("isarray");
							  		String paramsplit = rs.getString("paramsplit");
							  		String paramvalue = rs.getString("paramvalue");
							  		boolean ck=paramvalue.contains("\"");
							  		String ischeck = "";
							  		if("1".equals(isarray))
							  			ischeck = "checked";
						  			countindex++;
							  		String className = "";
							  		if (0 == countindex % 2)
							        {
							            className = "DataLight";
							        }
							        else
							        {
							            className = "DataDark";
							        }
								%>
							<tr class='<%=className %>'>
								<td>&nbsp;</td>
							   <td style='padding-left:0px!important;'><INPUT type='hidden' name='methodtype' value='3'><INPUT class='Inputstyle' type='text' name='paramname' value='<%=paramname %>' readonly></td>
							   <td><INPUT class='Inputstyle' type='text' name='paramtype' value='<%=paramtype %>' readonly></td>
							   <td><INPUT class='Inputstyle' type='checkbox' name='tempisarray' <%=ischeck %> onclick="if(this.checked){this.parentElement.nextSibling.value=1;}else{this.parentElement.nextSibling.value=0;}"><INPUT type='hidden' name='isarray' value='<%=isarray %>'></td>
							   <td><INPUT class='Inputstyle' type='text' maxLength=10 name='paramsplit' value='<%=paramsplit %>'></td>
							    <%if(ck){ %>
							   <td><INPUT class='Inputstyle' type='text' maxLength=1000 name='paramvalue' value='<%=paramvalue %>' ></td>
							   <%}else{ %>
							   <td><INPUT class='Inputstyle' type='text' maxLength=1000 name='paramvalue' value="<%=paramvalue %>" ></td>
							   <%} %>
						    </tr>
							<%
							  	}
						  	}
						  	%>
						</table>
				  	</div>
				  </wea:item>
				  <wea:item attributes="{'samePair':'webservice webservicelistparams4 webservicelistparam'}"><%=SystemEnv.getHtmlLabelName(32234, user.getLanguage())%></wea:item><!-- 同步人员接口方法 -->
				  <wea:item attributes="{'samePair':'webservice webservicelistparams4 webservicelistparam'}">
				  	<wea:required id="hrmmethodimage" required="true" value='<%=hrmmethod %>'>
				  	<select id="hrmmethod" style='width:280px!important;' name="hrmmethod" onchange='checkinput("hrmmethod","hrmmethodimage");ParseMethod(this,4);'>
				  	<option></option>
				  	<%
				  	if(!"".equals(webserviceurl))
				  	{
					  	String sqljob = "SELECT * FROM wsregistemethod where mainid="+webserviceurl+" order by methodname,id";
					  	rs.executeSql(sqljob);
					  	while(rs.next())
					  	{
					  		String methodid = rs.getString("id");
					  		String methodname = rs.getString("methodname");
					  		String methoddesc = rs.getString("methoddesc");
					  		String selectstr = "";
					  		if(hrmmethod.equals(methodid))
					  			selectstr = "selected";
					  		out.print("<option value='"+methodid+"' "+selectstr+" title='"+methoddesc+"'>"+methodname+"</option>");
					  	}
				  	}
				  	%>
				  	</select>
				  	</wea:required>
				  </wea:item>
				  <!-- <td><%=SystemEnv.getHtmlLabelName(32235, user.getLanguage())%></td>同步人员接口参数 -->
				  <wea:item attributes="{'samePair':'webservice webservicelistparams4 webservicelistparam','colspan':'2','isTableList':'true'}">
				  	<div id="hrmmethodparams">
				  		<table class="ListStyle">
				  			<COLGROUP>
				  			<COL width='3%'>
				  			<COL width='15%'>
				  			<COL width='15%'>
				  			<COL width='25%'>
				  			<COL width='15%'>
				  			<COL width='30%'>
				  			<tr class="header">
				  				<th>&nbsp;</th>
							   <th style='padding-left:0px!important;'><%=SystemEnv.getHtmlLabelName(20968, user.getLanguage())%></th><!-- 参数名 -->
							   <th><%=SystemEnv.getHtmlLabelName(561, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%></th><!-- 参数类型 -->
							   <th><%=SystemEnv.getHtmlLabelName(32392, user.getLanguage())%></th><!-- 是否数组 -->
							   <th><%=SystemEnv.getHtmlLabelName(32393, user.getLanguage())%></th><!-- 分隔符 -->
							   <th><%=SystemEnv.getHtmlLabelName(17637, user.getLanguage())%></th><!-- 参数值 -->
							</tr>
							<%
						  	if(!"".equals(hrmmethod))
						  	{
						  		int countindex = 0;
							  	String sqljob = "SELECT * FROM wsmethodparamvalue where methodid="+hrmmethod+" and contenttype=4 order by paramname,id";
							  	rs.executeSql(sqljob);
							  	while(rs.next())
							  	{
							  		String methodid = rs.getString("methodid");
							  		String paramname = rs.getString("paramname");
							  		String paramtype = rs.getString("paramtype");
							  		String isarray = rs.getString("isarray");
							  		String paramsplit = rs.getString("paramsplit");
							  		String paramvalue = rs.getString("paramvalue");
							  		boolean ck=paramvalue.contains("\"");
							  		String ischeck = "";
							  		if("1".equals(isarray))
							  			ischeck = "checked";
							  		
							  		countindex++;
							  		String className = "";
							  		if (0 == countindex % 2)
							        {
							            className = "DataLight";
							        }
							        else
							        {
							            className = "DataDark";
							        }
							%>
							<tr class='<%=className %>'>
								<td>&nbsp;</td>
							   <td style='padding-left:0px!important;'><INPUT type='hidden' name='methodtype' value='4'><INPUT class='Inputstyle' type='text' name='paramname' value='<%=paramname %>' readonly></td>
							   <td><INPUT class='Inputstyle' type='text' name='paramtype' value='<%=paramtype %>' readonly></td>
							   <td><INPUT class='Inputstyle' type='checkbox' name='tempisarray' <%=ischeck %> onclick="if(this.checked){this.parentElement.nextSibling.value=1;}else{this.parentElement.nextSibling.value=0;}"><INPUT type='hidden' name='isarray' value='<%=isarray %>'></td>
							   <td><INPUT class='Inputstyle' type='text' maxLength=10 name='paramsplit' value='<%=paramsplit %>'></td>
							   <%if(ck){ %>
							   <td><INPUT class='Inputstyle' type='text' maxLength=1000 name='paramvalue' value='<%=paramvalue %>' ></td>
							   <%}else{ %>
							   <td><INPUT class='Inputstyle' type='text' maxLength=1000 name='paramvalue' value="<%=paramvalue %>" ></td>
							   <%} %>
						    </tr>
							<%
							  	}
						  	}
						  	%>
						</table>
				  	</div>
				  </wea:item>
			</wea:group>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(26422,user.getLanguage())+SystemEnv.getHtmlLabelName(68,user.getLanguage())%>' attributes="{'samePair':'SetDetailInfo','groupOperDisplay':'none','itemAreaDisplay':'block'}">
				  <wea:item attributes="{'samePair':'tablelistparams','colspan':'2','display':'none'}">
				    <div class="listparams e8_box" id="tabbox2" style='height:42px;'>
		    			<ul class="tab_menu" id="tabs" style="width:85%!important;">
					       <li style='padding-left:0px!important;'><a href="#"><%=SystemEnv.getHtmlLabelName(32238, user.getLanguage())%></a></li><!-- 分部同步对应关系设置 -->
					       <li><a href="#"><%=SystemEnv.getHtmlLabelName(32237, user.getLanguage())%></a></li><!-- 部门同步对应关系设置 -->
					       <li><a href="#"><%=SystemEnv.getHtmlLabelName(32236, user.getLanguage())%></a></li><!-- 岗位同步对应关系设置 -->
					       <li><a href="#"><%=SystemEnv.getHtmlLabelName(32239, user.getLanguage())%></a></li><!-- 人员同步对应关系设置 -->
					       <li><a href="#"><%=SystemEnv.getHtmlLabelName(82932, user.getLanguage())%></a></li><!-- 同步关系设置说明 -->
					    </ul>
					    <div id="" class="" style="width:15%;height:41px;float:right;top:0px!important;">
					    	
		         			<TABLE width=100% class="setbutton" id='button1' style="display:none;">
		           				<TR>
		           					<!--th align=left><%=SystemEnv.getHtmlLabelName(32238, user.getLanguage())%></th--><!-- 分部同步对应关系设置 -->
		           					<TD align=right colspan="2" style="background: #fff;">
		           						<input type="button" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onClick="addRow(1)" class="addbtn"/>
		           						<input type="button" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onClick="removeRow(1)" class="delbtn"/>
		           					</TD>
		           				</TR>
		         			</TABLE>
		         			<TABLE width=100% class="setbutton" id='button2' style="display:none;">
		           				<TR>
		           					<!--th align=left><%=SystemEnv.getHtmlLabelName(32237, user.getLanguage())%></th--><!-- 部门同步对应关系设置 -->
		           					<TD align=right colspan="2" style="background: #fff;">
		           						<input type="button" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onClick="addRow(2)" class="addbtn"/>
		           						<input type="button" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onClick="removeRow(2)" class="delbtn"/>
		           					</TD>
		           				</TR>
		         			</TABLE>
		         			<TABLE width=100% class="setbutton" id='button3'>
		           				<TR>
		           					<!-- th align=left><%=SystemEnv.getHtmlLabelName(32236, user.getLanguage())%></th --><!-- 岗位同步对应关系设置 -->
		           					<TD align=right colspan="2" style="background: #fff;">
		           						<input type="button" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onClick="addRow(3)" class="addbtn"/>
		           						<input type="button" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onClick="removeRow(3)" class="delbtn"/>
		           					</TD>
		           				</TR>
		         			</TABLE>
		         			<TABLE width=100% class="setbutton" id='button4' style="display:none;">
		           				<TR>
		           					<!--th align=left>
		           						<%=SystemEnv.getHtmlLabelName(32239, user.getLanguage())%>
		           					</th-->
		           					<!-- 人员同步对应关系设置 -->
		           					<TD align=right colspan="2" style="background: #fff;">
		           						<input type="button" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onClick="addRow(4)" class="addbtn"/>
		           						<input type="button" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onClick="removeRow(4)" class="delbtn"/>
		           					</TD>
		           				</TR>
		         			</TABLE>
					    </div>
					    <div class="tab_box" style="display:none;">
					    </div>
					  </div>
				  </wea:item>
				  <wea:item attributes="{'samePair':'tablelistparams tablelistparams1 listparam','display':'none','colspan':'2','isTableList':'true'}">
                    <TABLE class="ListStyle" id="oTable1" name="oTable1">
                      	<COLGROUP>
                        <COL width="3%">
                        <COL width="10%">
                        <COL width="10%">
                        <COL width="8%">
                        <COL width="8%">
                        <COL width="10%">
                        <TR class="header">
                            <Th><INPUT type="checkbox" id="chkAll1" name="chkAll" onClick="chkAllClick(this,1)"></Th>
                            <Th><%=SystemEnv.getHtmlLabelName(32248, user.getLanguage())%></Th><!-- 分部表属性字段 -->
							<Th><%=SystemEnv.getHtmlLabelName(32241, user.getLanguage())%></Th><!-- 同步对应字段/XML属性 -->
	                        <Th><%=SystemEnv.getHtmlLabelName(32242, user.getLanguage())%></Th><!-- 关键匹配字段 -->
	                        <Th><%=SystemEnv.getHtmlLabelName(32249, user.getLanguage())%></Th><!-- 上级分部标识字段 -->
	                        <Th><%=SystemEnv.getHtmlLabelName(23128, user.getLanguage())%></Th><!-- 转换规则 -->
                        </TR>  		
                      </TABLE>
				  </wea:item>
				  <wea:item attributes="{'samePair':'tablelistparams tablelistparams2 listparam','display':'none','colspan':'2','isTableList':'true'}">
                    <TABLE class="ListStyle" id="oTable2" name="oTable2">
                      	<COLGROUP>
                        <COL width="3%">
                        <COL width="10%" >
                        <COL width="10%" >
                        <COL width="8%" >
                        <COL width="8%" >
                        <COL width="8%" >
                        <COL width="10%" >
                        <TR class="header">
                            <Th><INPUT type="checkbox" id="chkAll2" name="chkAll" onClick="chkAllClick(this,2)"></Th>
                            <Th><%=SystemEnv.getHtmlLabelName(32245, user.getLanguage())%></Th><!-- 部门表属性字段 -->
							<Th><%=SystemEnv.getHtmlLabelName(32241, user.getLanguage())%></Th><!-- 同步对应字段/XML属性 -->
	                        <Th><%=SystemEnv.getHtmlLabelName(32242, user.getLanguage())%></Th><!-- 关键匹配字段 -->
	                        <Th><%=SystemEnv.getHtmlLabelName(32246, user.getLanguage())%></Th><!-- 上级部门标识字段 -->
	                        <Th><%=SystemEnv.getHtmlLabelName(32247, user.getLanguage())%></Th><!-- 分部标识字段 -->
	                        <Th><%=SystemEnv.getHtmlLabelName(23128, user.getLanguage())%></Th><!-- 转换规则 -->
                        </TR> 		
                      </TABLE>
				  </wea:item>
				</tr>
				<wea:item attributes="{'samePair':'tablelistparams tablelistparams3 listparam','display':'none','colspan':'2','isTableList':'true'}">
                    <TABLE class="ListStyle" id="oTable3" name="oTable3">
                      	<COLGROUP>
                        <COL width="3%">
                        <COL width="20%">
                        <COL width="25%">
                        <COL width="25%">
                        <COL width="27%">
                        <TR class="header">
                            <Th><INPUT type="checkbox" id="chkAll3" name="chkAll" onClick="chkAllClick(this,3)"></Th>
                            <Th><%=SystemEnv.getHtmlLabelName(124998, user.getLanguage())%></Th><!-- 岗位表属性字段 -->
							<Th><%=SystemEnv.getHtmlLabelName(32241, user.getLanguage())%></Th><!-- 同步对应字段/XML属性 -->
	                        <Th><%=SystemEnv.getHtmlLabelName(32242, user.getLanguage())%></Th><!-- 关键匹配字段 -->
	                        <Th><%=SystemEnv.getHtmlLabelName(23128, user.getLanguage())%></Th><!-- 转换规则 -->
                        </TR>	
                      </TABLE>
				  </wea:item>
				  <wea:item attributes="{'samePair':'tablelistparams tablelistparams4 listparam','display':'none','colspan':'2','isTableList':'true'}">
                    <TABLE class="ListStyle" id="oTable4" name="oTable4">
                      	<COLGROUP>
                        <COL width="3%">
                        <COL width="10%">
                        <COL width="10%">
                        <COL width="8%">
                        <COL width="8%">
                        <COL width="8%">
                        <COL width="8%">
                        <COL width="10%">
                        <TR class="header">
                            <Th><INPUT type="checkbox" id="chkAll4" name="chkAll" onClick="chkAllClick(this,4)"></Th>
                            <Th><%=SystemEnv.getHtmlLabelName(32250, user.getLanguage())%></Th><!-- 人员表属性字段 -->
							<Th><%=SystemEnv.getHtmlLabelName(32241, user.getLanguage())%></Th><!-- 同步对应字段/XML属性 -->
	                        <Th><%=SystemEnv.getHtmlLabelName(32242, user.getLanguage())%></Th><!-- 关键匹配字段 -->
	                        <Th><%=SystemEnv.getHtmlLabelName(32251, user.getLanguage())%></Th><!-- 上级标识字段 -->
	                        <Th><%=SystemEnv.getHtmlLabelName(32244, user.getLanguage())%></Th><!-- 部门标识字段 -->
	                        <Th><%=SystemEnv.getHtmlLabelName(32252, user.getLanguage())%></Th><!-- 岗位标识字段 -->
	                        <Th><%=SystemEnv.getHtmlLabelName(23128, user.getLanguage())%></Th><!-- 转换规则 -->
                        </TR>	
                      </TABLE>
				  </wea:item>
				  <wea:item attributes="{'samePair':'tablelistparams tablelistparams5 listparam','colspan':'2'}">
						<%=SystemEnv.getHtmlLabelName(82934, user.getLanguage())%>
						<BR>
						<%=SystemEnv.getHtmlLabelName(82935, user.getLanguage())%>
						<BR>
						<%=SystemEnv.getHtmlLabelName(82936, user.getLanguage())%>
						<BR>
						<%=SystemEnv.getHtmlLabelName(82937, user.getLanguage())%>
						<BR>
						<%=SystemEnv.getHtmlLabelName(82938, user.getLanguage())%>
						<BR>
						<%=SystemEnv.getHtmlLabelName(128548, user.getLanguage())%>
						<BR>
						<%=SystemEnv.getHtmlLabelName(128549, user.getLanguage())%>
						<BR>
						<%=SystemEnv.getHtmlLabelName(129986, user.getLanguage())%>
						<BR>
						<%=SystemEnv.getHtmlLabelName(128551, user.getLanguage())%>
						<BR>
						
				  </wea:item>
			</wea:group>
		</wea:layout>
		<br>
  </FORM>
</BODY>

<script language="javascript">

function clearInput(id){
	$("#"+id+" input").val("");
	$("#"+id.substring(0,id.length-3)+"span").html("");
}

	function onShowTableField(parames){
		//tablename,type,order
		var jsonarrs = eval(parames);
		var tablename = jsonarrs.tablename;
		var type = jsonarrs.type;
		var order = jsonarrs.order;
		var fieldname = "";
		var datasource = "";
		var tablename2 = "";
		
		if("2"==type)
		{
			datasource = frmMain.dbsource.value;
			if(order==1)
	    	{
	    		tablename2 = frmMain.subcomtable.value;
	    	}
	    	else if(order==2)
	    	{
	    		tablename2 = frmMain.depttable.value;
	    	}
	    	else if(order==3)
	    	{
	    		tablename2 = frmMain.jobtable.value;
	    	}
	    	else if(order==4)
	    	{
	    		tablename2 = frmMain.hrmtable.value;
	    	}
		}
		else
		{
			tablename2 = tablename;
		}
		//alert("type : "+type+" datasource : "+datasource+" tablename2 : "+tablename2)
    	if(tablename2=="")
    	{
    		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32253, user.getLanguage())%>");//对应表名未填写，请填写！
    		return;
    	}
		var urls = "/systeminfo/BrowserMain.jsp?mouldID=integration&dmltablename="+tablename2+"&datasourceid="+datasource+"&url=%2Fworkflow%2Fdmlaction%2FdmlTableFieldsBrowser.jsp%3FcallSource%3Dhrsetting";
		if("2"!=type) urls = "/systeminfo/BrowserMain.jsp?mouldID=integration&dmltablename="+tablename2+"&datasourceid="+datasource+"&url=/integration/hrsettingfield.jsp";
		//var id_t = showModalDialog(urls);
		//if(id_t){
		//	if(id_t.id != ""&& typeof id_t!='undefined'){
		//		fieldname = wuiUtil.getJsonValueByIndex(id_t, 0);
		//	}else{
		//		fieldname = "";
		//	}
		//}
		//obj.nextSibling.value=fieldname;
		//alert("urls : "+urls);
		return urls;
	}
	function onSetOATableField(event,data,name,paras,tg){
		//Dialog.alert("event : "+event);
		var obj = null;
		//alert(typeof(tg)+"  event : "+event);
		if(typeof(tg)=='undefined'){
			obj= event.target || event.srcElement;
		}
		else
		{
			obj = tg;
		}
		try
		{
			//alert("obj.parentElement.parentElement.parentElement.parentElement : "+obj.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.outerHTML);
			//obj.parentElement.parentElement.parentElement.parentElement.parentElement.nextSibling.value = data.name;
			jQuery(obj).closest("td").find("input[name='oafield']").val(data.a1);
			//alert(obj.parentElement.parentElement.parentElement.parentElement.nextSibling.outerHTML+"  "+obj.parentElement.parentElement.parentElement.parentElement.nextSibling.value)
			//288265 [80][90]HR同步-同步对应字段设置中选择属性字段时，建议做字段不能重复选择验证
			var count=0;
			var objtype=jQuery(obj).closest("tr").find("input[name='type']").val();
			var oafields=	jQuery("#oTable"+objtype+" input[name='oafield']");
				jQuery.each(oafields, function(j, n){
				if($(this).val()==data.a1){
				count++;
				}
				});
				if(count>1){
				Dialog.alert("存在重复属性，请检查");
			jQuery(obj).closest("td").find("span[name='oafieldspanimg']").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>")
			jQuery(obj).closest("td").find("span[name='oafieldspan']").html("");
			jQuery(obj).closest("td").find("input[name='oafield']").val("");
			}
		    //288265 [80][90]HR同步-同步对应字段设置中选择属性字段时，建议做字段不能重复选择验证
		}
		catch(e)
		{
		}
	}
	function onSetTableField(event,data,name,paras,tg){
		//Dialog.alert("event : "+event);
		var obj = null;
		//alert(typeof(tg)+"  event : "+event);
		if(typeof(tg)=='undefined'){
			obj= event.target || event.srcElement;
		}
		else
		{
			obj = tg;
		}
		try
		{
			//alert("obj.parentElement.parentElement.parentElement.parentElement : "+obj.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.outerHTML);
			//obj.parentElement.parentElement.parentElement.parentElement.parentElement.nextSibling.value = data.name;
			jQuery(obj).closest("div.e8Browser").parent().children("input[name='outfield']").val(data.name);
			//alert(obj.parentElement.parentElement.parentElement.parentElement.nextSibling.outerHTML+"  "+obj.parentElement.parentElement.parentElement.parentElement.nextSibling.value)
		}
		catch(e)
		{
		}
		//alert(event+"  "+name);
		
	}
	
	function changeIntegration(objvalue)
	{
		var type = objvalue;
		if(type=="1")
		{
			showEle("dbsource");
			showGroup('SetDBTableInfo');
			hideGroup('SetWebserviceMethodInfo');
			showGroup('SetDetailInfo');
			hideEle("custommethod");
			showEle("tablelistparams");
			showEle("tablelistparams1");
			hideEle("tablelistparams2");
			hideEle("tablelistparams3");
			hideEle("tablelistparams4");
			hideEle("tablelistparams5");
			hideEle("webservice");
			hideEle("webservicelistparams");
			hideEle("webservicelistparams1");
			hideEle("webservicelistparams2");
			hideEle("webservicelistparams3");
			hideEle("webservicelistparams4");
			showEle("defaultPwd");
			showEle("pwdsynctype");
			showEle("issynrtx");
			showListTab2();
			/*QC302663 [80][90]HR同步-解决WebService初始化下的配置字段缺少必填项提示的问题 start*/
			if(document.getElementById("xmlspanid_2_1")){
			    for(var i=2;i<=6;i++){
				   for(var j=1;j<=2;j++){
				       document.getElementById("xmlspanid_"+i+"_"+j).style.visibility = "hidden";
				   }
				
				}
			}
			if(document.getElementById("xmlspanid_2_3")){
				for(var i=2;i<=4;i++){
				    document.getElementById("xmlspanid_"+i+"_3").style.visibility = "hidden";
				}
			}
			if(document.getElementById("xmlspanid_2_4")){
				for(var i=2;i<=8;i++){
				    document.getElementById("xmlspanid_"+i+"_4").style.visibility = "hidden";
				}
			}
			/*QC302663 [80][90]HR同步-解决WebService初始化下的配置字段缺少必填项提示的问题 end*/
		}
		else if(type=="2")
		{
			
			hideEle("dbsource");
			hideEle("custommethod");
			hideGroup('SetDBTableInfo');
			showGroup('SetWebserviceMethodInfo');
			showGroup('SetDetailInfo');
			showEle("tablelistparams");
			showEle("tablelistparams1");
			hideEle("tablelistparams2");
			hideEle("tablelistparams3");
			hideEle("tablelistparams4");
			hideEle("tablelistparams5");
			showEle("webservice");
			showEle("webservicelistparams");
			showEle("webservicelistparams1");
			hideEle("webservicelistparams2");
			hideEle("webservicelistparams3");
			hideEle("webservicelistparams4");
			showEle("defaultPwd");
			showEle("pwdsynctype");
			showEle("issynrtx");
			showListTab1();
			showListTab2();
			/*QC302663 [80][90]HR同步-解决WebService初始化下的配置字段缺少必填项提示的问题 start*/
		   if(document.getElementById("xmlspanid_2_1")){
			    for(var i=2;i<=6;i++){
				   for(var j=1;j<=2;j++){
				       document.getElementById("xmlspanid_"+i+"_"+j).style.visibility = "visible";
				   }
				}
			}
			if(document.getElementById("xmlspanid_2_3")){
				for(var i=2;i<=4;i++){
				    document.getElementById("xmlspanid_"+i+"_3").style.visibility = "visible";
				}
			}
			if(document.getElementById("xmlspanid_2_4")){
				for(var i=2;i<=8;i++){
				    document.getElementById("xmlspanid_"+i+"_4").style.visibility = "visible";
				}
			}
			/*QC302663 [80][90]HR同步-解决WebService初始化下的配置字段缺少必填项提示的问题 end*/
		}
		else if(type=="3")
		{
			hideEle("dbsource");
			showEle("custommethod");
			hideEle("tablelistparams");
			hideEle("webservice");
			hideEle("webservicelistparams");
			hideGroup('SetDBTableInfo');
			hideGroup('SetWebserviceMethodInfo');
			hideGroup('SetDetailInfo');
			hideEle("defaultPwd");
			hideEle("pwdsynctype");
			hideEle("issynrtx");
		}
		changeTableField(objvalue);
	}

	function bindouttable(){
		var arr=["subcomouternew","deptouternew","jobouternew","hrmouternew"];
		var arrValue = ["<%=subcomouternew%>","<%=deptouternew%>","<%=jobouternew%>","<%=hrmouternew%>"];
		for(var i=0;i<arr.length;i++){
			var id = arr[i];
			jQuery("#"+id+"div").e8Browser({
				   name:id,
				   viewType:"0",
				   browserValue:""+arrValue[i],
				   isMustInput:"1",
				   browserSpanValue:""+arrValue[i],
				   getBrowserUrlFn:'onShowTableField',
				   getBrowserUrlFnParams:"{tablename:'',type:'2',order:'"+(i+1)+"'}",
				   hasInput:false,
				   linkUrl:"#",
				   isSingle:true,
				   completeUrl:"/data.jsp",
				   browserUrl:"",
				   hasAdd:false,
				   width:'20%',
				   _callback:"onSetTableField"
				});
		}

		//3个必填字段后面的红色感叹号处理
		var img = ["subcomtableimage","depttableimage","hrmtableimage","jobtableimage"];
		for(var i=0;i<img.length;i++){
			$("#"+img[i]).css("float","left");
			//为了红色图标显示或者隐藏时，后面的部分横向位置不移动
			var pre = $("#"+img[i]).prev();
			var sp = $("<span style='width:20px;float:left'>&nbsp;</span>")
			sp.css("display","-moz-inline-box");
			sp.css("display","inline-block");
			sp.append($("#"+img[i]));
			pre.after(sp);
		}
	}
	
	function addRow(order)
    {        
    	var tablename = "hrmsubcompany";
    	if(order==1)
    	{
    		tablename = "hrmsubcompany";
    	}
    	else if(order==2)
    	{
    		tablename = "hrmdepartment";
    	}
    	else if(order==3)
    	{
    		tablename = "hrmjobtitles";
    	}
    	else if(order==4)
    	{
    		tablename = "hrmresource";
    	}
    	var rownum = document.getElementById("oTable"+order).rows.length;
        var oRow = document.getElementById("oTable"+order).insertRow(rownum);
        var oRowIndex = oRow.rowIndex;
        
        if (0 == oRowIndex % 2)
        {
            oRow.className = "DataLight";
        }
        else
        {
            oRow.className = "DataDark";
        }
		
		/*============ 选择 ============*/
        var oCell = oRow.insertCell(0);
        var oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT type='checkbox' name='paramid_"+order+"'><INPUT type='hidden' name='paramids_"+order+"' value='-1'><INPUT type='hidden' name='type' value='"+order+"'>";
        oCell.appendChild(oDiv);
        jQuery(oCell).jNice();
        
        oCell = oRow.insertCell(1);
        oDiv = document.createElement("div");
        
        //if (0 == oRowIndex % 2)
        //{
        //    oDiv.innerHTML="<button type='button' class=Browser onClick=\"onShowTableField(this,'"+tablename+"',1,"+order+");\"></BUTTON><INPUT type='text' name='oafield' style='border:0px;' readOnly='true' value=''><SPAN></SPAN>";
        //}
        //else
        //{
        //	oDiv.innerHTML="<button type='button' class=Browser onClick=\"onShowTableField(this,'"+tablename+"',1,"+order+");\"></BUTTON><INPUT type='text' name='oafield' style='border:0px;BACKGROUND-COLOR:#FFF;' readOnly='true' value=''><SPAN></SPAN>";
        //} 
                                
        oCell.appendChild(oDiv);
        jQuery(oDiv).e8Browser({
		   name:"oafield",
		   viewType:"0",
		   browserValue:"",
		   isMustInput:"2",
		   browserSpanValue:"",
		   getBrowserUrlFn:'onShowTableField',
		   getBrowserUrlFnParams:"{tablename:'"+tablename+"',type:'1',order:'"+order+"'}",
		   hasInput:false,
		   linkUrl:"#",
		   isSingle:true,
		   completeUrl:"/data.jsp",
		   browserUrl:"",
		   hasAdd:false,
		   width:'90%',
		   _callback:"onSetOATableField"
		});
		
		var intetype = frmMain.intetype.value;
		
		
        oCell = oRow.insertCell(2);
        oDiv = document.createElement("div");
        //if("1"==intetype)
        //{
        //	if (0 == oRowIndex % 2)
	    //    {
	    //        oDiv.innerHTML="<button type='button' class=Browser name=TableField onClick=\"onShowTableField(this,'',2,"+order+");\"></BUTTON><INPUT class='Inputstyle' type='text' name='outfield' value='' style='border:0px;' readOnly='true'>";
	    //    }
	    //    else
	    //    {
	    //    	oDiv.innerHTML="<button type='button' class=Browser name=TableField onClick=\"onShowTableField(this,'',2,"+order+");\"></BUTTON><INPUT class='Inputstyle' type='text' name='outfield' value='' style='border:0px;BACKGROUND-COLOR:#FFF;' readOnly='true'>";
	    //    }
        //}
        //if("2"==intetype)
        //{
        //	oDiv.innerHTML="<button type='button' class=Browser style='display:none;' name=TableField onClick=\"onShowTableField(this,'',2,"+order+");\"></BUTTON><INPUT class='Inputstyle' type='text' name='outfield' value=''>";
        //}
        var outfielddisplay = "";
        var outbrowserfielddisplay = "";
        /*QC302663 [80][90]HR同步-解决WebService初始化下的配置字段缺少必填项提示的问题 start*/
        var outspandisplay="";
        if("1"==intetype)
        {
        	outfielddisplay = "none";
        	outbrowserfielddisplay = "block";
        	outspandisplay = "hidden";
        }
        else if("2"==intetype)
        {
        	outfielddisplay = "inline";
        	outbrowserfielddisplay = "none";
        	outspandisplay = "visible";
        }
         var spannum= rownum+1;
        oDiv.innerHTML="<div class='e8Browser' style='display:"+outbrowserfielddisplay+"'></div><INPUT class='Inputstyle' style='display:"+outfielddisplay+";width:90%;' type='text' name='outfield' value='' onblur='check_isExist(this,"+spannum+","+order+")' /><span id='xmlspanid_"+spannum+"_"+order+"' style='visibility:"+outspandisplay+";'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>";
       
       
        /*QC302663 [80][90]HR同步-解决WebService初始化下的配置字段缺少必填项提示的问题 end*/
        oCell.appendChild(oDiv);
       	jQuery(oDiv).find(".e8Browser").e8Browser({
		   name:"tempoutfield",
		   viewType:"0",
		   browserValue:"",
		   isMustInput:"2",
		   browserSpanValue:"",
		   getBrowserUrlFn:'onShowTableField',
		   getBrowserUrlFnParams:"{tablename:'',type:'2',order:'"+order+"'}",
		   hasInput:false,
		   linkUrl:"#",
		   isSingle:true,
		   completeUrl:"/data.jsp",
		   browserUrl:"",
		   hasAdd:false,
		   width:'90%',
		   _callback:"onSetTableField"
		});
        
        oCell = oRow.insertCell(3);
        oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT class='Inputstyle iskeyfield"+order+"' type='checkbox' name='tempiskeyfield' onclick=\"changeCheck('iskeyfield"+order+"',this);if(this.checked){this.parentElement.nextSibling.value=1;}else{this.parentElement.nextSibling.value=0;}\"><INPUT class='Inputstyle' type='hidden' name='iskeyfield' value=''>";
        oCell.appendChild(oDiv);
        jQuery(oCell).jNice();
        
        
        if(order==1)
    	{
	        oCell = oRow.insertCell(4);
	        oDiv = document.createElement("div");
	        oDiv.innerHTML="<INPUT class='Inputstyle isparentfield1' type='checkbox' name='tempisparentfield' onclick=\"changeCheck('isparentfield1',this);if(this.checked){this.parentElement.nextSibling.value=1;}else{this.parentElement.nextSibling.value=0;}\"><INPUT class='Inputstyle' type='hidden' name='isparentfield' value=''>"
	        				+"<INPUT class='Inputstyle' type='hidden' name='isdeptfield' value=''>"
	        				+"<INPUT class='Inputstyle' type='hidden' name='issubcomfield' value=''>"
	        				+"<INPUT class='Inputstyle' type='hidden' name='ishrmdeptfield' value=''>"
	        				+"<INPUT class='Inputstyle' type='hidden' name='ishrmjobfield' value=''>";
	        oCell.appendChild(oDiv);
	        jQuery(oCell).jNice();
    	}
    	else if(order==2)
    	{
    		oCell = oRow.insertCell(4);
	        oDiv = document.createElement("div");
	        oDiv.innerHTML="<INPUT class='Inputstyle isparentfield2' type='checkbox' name='tempisparentfield' onclick=\"changeCheck('isparentfield2',this);if(this.checked){this.parentElement.nextSibling.value=1;}else{this.parentElement.nextSibling.value=0;}\"><INPUT class='Inputstyle' type='hidden' name='isparentfield' value=''>";
	        oCell.appendChild(oDiv);
	        jQuery(oCell).jNice();
	        
	        oCell = oRow.insertCell(5);
	        oDiv = document.createElement("div");
	        oDiv.innerHTML="<INPUT class='Inputstyle issubcomfield2' type='checkbox' name='tempissubcomfield' onclick=\"changeCheck('issubcomfield2',this);if(this.checked){this.parentElement.nextSibling.value=1;}else{this.parentElement.nextSibling.value=0;}\"><INPUT class='Inputstyle' type='hidden' name='issubcomfield' value=''>"
	        				+"<INPUT class='Inputstyle' type='hidden' name='isdeptfield' value=''>"
	        				+"<INPUT class='Inputstyle' type='hidden' name='ishrmdeptfield' value=''>"
	        				+"<INPUT class='Inputstyle' type='hidden' name='ishrmjobfield' value=''>";
	        oCell.appendChild(oDiv);
	        jQuery(oCell).jNice();
    	}
    	else if(order==3)
    	{
    	}
    	else if(order==4)
    	{
    		oCell = oRow.insertCell(4);
	        oDiv = document.createElement("div");
	        oDiv.innerHTML="<INPUT class='Inputstyle isparentfield4' type='checkbox' name='tempisparentfield' onclick=\"changeCheck('isparentfield4',this);if(this.checked){this.parentElement.nextSibling.value=1;}else{this.parentElement.nextSibling.value=0;}\"><INPUT class='Inputstyle' type='hidden' name='isparentfield' value=''>";
	        oCell.appendChild(oDiv);
	        jQuery(oCell).jNice();
	        
	        oCell = oRow.insertCell(5);
	        oDiv = document.createElement("div");
	        oDiv.innerHTML="<INPUT class='Inputstyle ishrmdeptfield4' type='checkbox' name='tempishrmdeptfield' onclick=\"changeCheck('ishrmdeptfield4',this);if(this.checked){this.parentElement.nextSibling.value=1;}else{this.parentElement.nextSibling.value=0;}\"><INPUT class='Inputstyle' type='hidden' name='ishrmdeptfield' value=''>";
	        oCell.appendChild(oDiv);
	        jQuery(oCell).jNice();
	        
	        oCell = oRow.insertCell(6);
	        oDiv = document.createElement("div");
	        oDiv.innerHTML="<INPUT class='Inputstyle ishrmjobfield4' type='checkbox' name='tempishrmjobfield' onclick=\"changeCheck('ishrmjobfield4',this);if(this.checked){this.parentElement.nextSibling.value=1;}else{this.parentElement.nextSibling.value=0;}\"><INPUT class='Inputstyle' type='hidden' name='ishrmjobfield' value=''>"
	        				+"<INPUT class='Inputstyle' type='hidden' name='isdeptfield' value=''>"
	        				+"<INPUT class='Inputstyle' type='hidden' name='issubcomfield' value=''>";
	        oCell.appendChild(oDiv);
	        jQuery(oCell).jNice();
    	}
    	var indexcell = 0;
    	if(order==1)
    	{
    		indexcell = 5;
    	}
    	else if(order==2)
    	{
    		indexcell = 6;
    	}
    	else if(order==3)
    	{
    		indexcell = 4;
    	}
    	else if(order==4)
    	{
    		indexcell = 7;
    	}
    	oCell = oRow.insertCell(indexcell);
        oDiv = document.createElement("div");
        oDiv.innerHTML="<textarea id='transql' name='transql' cols=25 rows=2 style='width:95%!important;'></textarea>";
        if(order==3){
	        oDiv.innerHTML += "<INPUT class='Inputstyle' type='hidden' name='isdeptfield' value=''>"
	        				+"<INPUT class='Inputstyle' type='hidden' name='isparentfield' value=''>"
	        				+"<INPUT class='Inputstyle' type='hidden' name='issubcomfield' value=''>"
	        				+"<INPUT class='Inputstyle' type='hidden' name='ishrmdeptfield' value=''>"
	        				+"<INPUT class='Inputstyle' type='hidden' name='ishrmjobfield' value=''>";
        }
        oCell.appendChild(oDiv);
    }
    function chkAllClick(obj,order)
    {
        var chks = document.getElementsByName("paramid_"+order);
        
        for (var i = 0; i < chks.length; i++)
        {
            var chk = chks[i];
            
            if(false == chk.disabled)
            {
            	chk.checked = obj.checked;
            	try
            	{
            		if(chk.checked)
            			jQuery(chk.nextSibling).addClass("jNiceChecked");
            		else
            			jQuery(chk.nextSibling).removeClass("jNiceChecked");
            	}
            	catch(e)
            	{
            	}
            }
        }
    }
    function removeRow(order)
    {
		var count = 0;//删除数据选中个数
		jQuery("input[name='paramid_"+order+"']").each(function(){
			if($(this).is(':checked')){
				count++;
			}
		});
		//alert(v+":"+count);
		if(count==0){
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage()) %>");
		}else{
    	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
	        var chks = document.getElementsByName("paramid_"+order);
	       
	        for (var i = chks.length - 1; i >= 0; i--)
	        {
	            var chk = chks[i];
	            //alert(chk.parentElement.parentElement.parentElement.rowIndex);
	            if (chk.checked)
	            {
	                document.getElementById("oTable"+order).deleteRow(chk.parentElement.parentElement.parentElement.parentElement.rowIndex)
	            }
	        }
	        var chk = document.getElementById("chkAll"+order);
	        chk.checked = false
           	try
           	{
           		if(chk.checked)
           			jQuery(chk.nextSibling).addClass("jNiceChecked");
           		else
           			jQuery(chk.nextSibling).removeClass("jNiceChecked");
           	}
           	catch(e)
           	{
           	}
	    }, function () {}, 320, 90);
		}
    }
function init()
{
	var intetype = frmMain.intetype.value;
<%
		rs.executeSql("SELECT * FROM hrsyncsetparam order by type,id");
		
		Map subComName = HrmSynDAO.getFeildName(1,user.getLanguage());
		Map deptName = HrmSynDAO.getFeildName(2,user.getLanguage());
		Map jobName = HrmSynDAO.getFeildName(3,user.getLanguage());
		//QC306284 [80][90]优化-HR同步， 岗位表属性字段中的字段显示名进行调整以便于理解 -start
	   //职务ID
	    jobName.put("jobactivityid", SystemEnv.getHtmlLabelNames("1915,32011", user.getLanguage()));
	    //任职资格
	    jobName.put("jobcompetency", SystemEnv.getHtmlLabelName(895, user.getLanguage()));
	    //岗位简称
	    jobName.put("jobtitlemark", SystemEnv.getHtmlLabelNames("6086,399", user.getLanguage()));
	    //岗位全称
	    jobName.put("jobtitlename", SystemEnv.getHtmlLabelNames("6086,15767", user.getLanguage()));
	    //QC306284 [80][90]优化-HR同步， 岗位表属性字段中的字段显示名进行调整以便于理解 -end
		Map userName = HrmSynDAO.getFeildName(4,user.getLanguage());
		Map fieldMap = new HashMap();
		fieldMap.put(1,subComName);
		fieldMap.put(2,deptName);
		fieldMap.put(3,jobName);
		fieldMap.put(4,userName);
		
		while (rs.next()) 
		{
	        int type = Util.getIntValue(rs.getString("type"),0);
	        String oafield = Util.null2String(rs.getString("oafield"));
	        String outfield = Util.null2String(rs.getString("outfield"));
	        String iskeyfield = Util.null2String(rs.getString("iskeyfield"));
	        String isnewfield = Util.null2String(rs.getString("isnewfield"));
	        
	        //是否为上级字段，部门，分部，人员中需要使用
	        String isparentfield = Util.null2String(rs.getString("isparentfield"));
	        //部门关键字段，部门所属分部
	        String issubcomfield = Util.null2String(rs.getString("issubcomfield"));
	        //岗位关键字段，岗位所属部门
	        String isdeptfield = Util.null2String(rs.getString("isdeptfield"));
	        //人员关键字段
	        String ishrmdeptfield = Util.null2String(rs.getString("ishrmdeptfield"));
	        String ishrmjobfield = Util.null2String(rs.getString("ishrmjobfield"));
	        
	        String transql = Util.null2String(rs.getString("transql"));
	        
	        String fieldCnName = (String)((Map)fieldMap.get(type)).get(oafield);
	        fieldCnName = StringUtils.isBlank(fieldCnName)?oafield:fieldCnName; 
%>
			var tablename = "";
	    	if("1"=="<%=type%>")
	    	{
	    		tablename = "hrmsubcompany";
	    	}
	    	else if("2"=="<%=type%>")
	    	{
	    		tablename = "hrmdepartment";
	    	}
	    	else if("3"=="<%=type%>")
	    	{
	    		tablename = "hrmjobtitles";
	    	}
	    	else if("4"=="<%=type%>")
	    	{
	    		tablename = "hrmresource";
	    	}
	    	var rownum = document.getElementById("oTable<%=type%>").rows.length;
	    	//alert(rownum);
			var oRow = document.getElementById("oTable<%=type%>").insertRow(rownum);
	        var oRowIndex = oRow.rowIndex;
	
	        if (0 == oRowIndex % 2)
	        {
	            oRow.className = "DataLight";
	        }
	        else
	        {
	            oRow.className = "DataDark";
	        }
		
			/*============ 选择 ============*/
	        var oCell = oRow.insertCell(0);
	        var oDiv = document.createElement("div");
	        oDiv.innerHTML="<INPUT type=checkbox name='paramid_<%=type %>'><INPUT type='hidden' name='paramids_<%=type %>' value='-1'><INPUT type='hidden' name='type' value='<%=type%>'><SPAN></SPAN>";
	        oCell.appendChild(oDiv);
	        jQuery(oCell).jNice();
	        
	        /*============ 名称 ============*/
	        oCell = oRow.insertCell(1);
	        oDiv = document.createElement("div");
	        //if (0 == oRowIndex % 2)
	        //{
	        //    oDiv.innerHTML="<button type='button' class=Browser onClick=\"onShowTableField(this,'"+tablename+"',1,<%=type%>);\"></BUTTON><INPUT type='text' name='oafield' style='border:0px;' readOnly='true' value='<%=oafield%>'><SPAN></SPAN>";
	        //}
	        //else
	        //{
	        //    oDiv.innerHTML="<button type='button' class=Browser onClick=\"onShowTableField(this,'"+tablename+"',1,<%=type%>);\"></BUTTON><INPUT type='text' name='oafield' style='border:0px;BACKGROUND-COLOR:#FFF;' readOnly='true' value='<%=oafield%>'><SPAN></SPAN>";
	        //}                        
	        oCell.appendChild(oDiv);
	        jQuery(oDiv).e8Browser({
			   name:"oafield",
			   viewType:"0",
			   browserValue:"<%=oafield%>",
			   isMustInput:"2",
			   browserSpanValue:"<%=fieldCnName%>",
			   getBrowserUrlFn:'onShowTableField',
			   getBrowserUrlFnParams:"{tablename:'"+tablename+"',type:'1',order:'<%=type%>'}",
			   hasInput:false,
			   linkUrl:"#",
			   isSingle:true,
			   completeUrl:"/data.jsp",
			   browserUrl:"",
			   hasAdd:false,
			   width:'90%',
			   _callback:"onSetOATableField"
			});
	        
			oCell = oRow.insertCell(2);
	        oDiv = document.createElement("div");
	        var outfielddisplay = "";
	        if("1"==intetype)
	        {
	        	outfielddisplay = "none";
	        }
	        /*QC302663 [80][90]HR同步-解决WebService初始化下的配置字段缺少必填项提示的问题 start*/
	        if("2"==intetype)
	        {
	        	outfielddisplay = "inline";
	        }
	        var spannum=rownum+1;
	        var typenum="<%=type%>";
	        oDiv.innerHTML="<div class='e8Browser'></div><INPUT class='Inputstyle' style='display:"+outfielddisplay+";width:90%;' type='text' name='outfield' value='<%=outfield %>' onblur='check_isExist(this,"+spannum+","+typenum+")'><span id='xmlspanid_"+spannum+"_"+typenum+"' style='display:none'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>";
	        
	        if(""!="<%=outfield%>"){
		         $("#xmlspanid_"+spannum+"_"+typenum).hide();
		    }else{
		         $("#xmlspanid_"+spannum+"_"+typenum).show();
		    }
		    /*QC302663 [80][90]HR同步-解决WebService初始化下的配置字段缺少必填项提示的问题 end*/
	        oCell.appendChild(oDiv);
	        try
	        {
		       	jQuery(oDiv).find(".e8Browser").e8Browser({
				   name:"tempoutfield",
				   viewType:"0",
				   browserValue:"<%=outfield %>",
				   isMustInput:"2",
				   browserSpanValue:"<%=outfield %>",
				   getBrowserUrlFn:'onShowTableField',
				   getBrowserUrlFnParams:"{tablename:'',type:'2',order:'<%=type%>'}",
				   hasInput:false,
				   linkUrl:"#",
				   isSingle:true,
				   completeUrl:"/data.jsp",
				   browserUrl:"",
				   width:'90%',
				   hasAdd:false,
				   _callback:"onSetTableField"
				});
			}
			catch(e)
			{
				//alert(e);
			}
	        oCell = oRow.insertCell(3);
	        oDiv = document.createElement("div");
	        oDiv.innerHTML="<INPUT class='Inputstyle iskeyfield<%=type%>' type='checkbox' name='tempiskeyfield' <%if("1".equals(iskeyfield)){%>checked<%}%> onclick=\"changeCheck('iskeyfield<%=type%>',this);if(this.checked){this.parentElement.nextSibling.value=1;}else{this.parentElement.nextSibling.value=0;}\"><INPUT class='Inputstyle' type='hidden' name='iskeyfield' value='<%=iskeyfield %>'>";
	        oCell.appendChild(oDiv);
	        jQuery(oCell).jNice();
	        
	        
	        if("<%=type %>"==1)
	    	{
	    		oCell = oRow.insertCell(4);
		        oDiv = document.createElement("div");
		        oDiv.innerHTML="<INPUT class='Inputstyle isparentfield1' type='checkbox' name='tempisparentfield' <%if("1".equals(isparentfield)){%>checked<%}%> onclick=\"changeCheck('isparentfield1',this);if(this.checked){this.parentElement.nextSibling.value=1;}else{this.parentElement.nextSibling.value=0;}\"><INPUT class='Inputstyle' type='hidden' name='isparentfield' value='<%=isparentfield%>'>"
		        				+"<INPUT class='Inputstyle' type='hidden' name='isdeptfield' value='0'>"
		        				+"<INPUT class='Inputstyle' type='hidden' name='issubcomfield' value='0'>"
		        				+"<INPUT class='Inputstyle' type='hidden' name='ishrmdeptfield' value='0'>"
		        				+"<INPUT class='Inputstyle' type='hidden' name='ishrmjobfield' value='0'>";
		        oCell.appendChild(oDiv);
		        jQuery(oCell).jNice();
	    	}
	    	else if("<%=type %>"==2)
	    	{
	    		oCell = oRow.insertCell(4);
		        oDiv = document.createElement("div");
		        oDiv.innerHTML="<INPUT class='Inputstyle isparentfield2' type='checkbox' name='tempisparentfield' <%if("1".equals(isparentfield)){%>checked<%}%> onclick=\"changeCheck('isparentfield2',this);if(this.checked){this.parentElement.nextSibling.value=1;}else{this.parentElement.nextSibling.value=0;}\"><INPUT class='Inputstyle' type='hidden' name='isparentfield' value='<%=isparentfield%>'>";
		        oCell.appendChild(oDiv);
		        jQuery(oCell).jNice();
		        
		        oCell = oRow.insertCell(5);
		        oDiv = document.createElement("div");
		        oDiv.innerHTML="<INPUT class='Inputstyle issubcomfield2' type='checkbox' name='tempissubcomfield' <%if("1".equals(issubcomfield)){%>checked<%}%> onclick=\"changeCheck('issubcomfield2',this);if(this.checked){this.parentElement.nextSibling.value=1;}else{this.parentElement.nextSibling.value=0;}\"><INPUT class='Inputstyle' type='hidden' name='issubcomfield' value='<%=issubcomfield%>'>"
		        				+"<INPUT class='Inputstyle' type='hidden' name='isdeptfield' value='0'>"
		        				+"<INPUT class='Inputstyle' type='hidden' name='ishrmdeptfield' value='0'>"
		        				+"<INPUT class='Inputstyle' type='hidden' name='ishrmjobfield' value='0'>";
		        oCell.appendChild(oDiv);
		        jQuery(oCell).jNice();
	    	}
	    	else if("<%=type %>"==3)
	    	{
	    	}
	    	else if("<%=type %>"==4)
	    	{
	    		oCell = oRow.insertCell(4);
		        oDiv = document.createElement("div");
		        oDiv.innerHTML="<INPUT class='Inputstyle isparentfield4' type='checkbox' name='tempisparentfield' <%if("1".equals(isparentfield)){%>checked<%}%> onclick=\"changeCheck('isparentfield4',this);if(this.checked){this.parentElement.nextSibling.value=1;}else{this.parentElement.nextSibling.value=0;}\"><INPUT class='Inputstyle' type='hidden' name='isparentfield' value='<%=isparentfield%>'>";
		        oCell.appendChild(oDiv);
		        jQuery(oCell).jNice();
		        
		        oCell = oRow.insertCell(5);
		        oDiv = document.createElement("div");
		        oDiv.innerHTML="<INPUT class='Inputstyle ishrmdeptfield4' type='checkbox' name='tempishrmdeptfield' <%if("1".equals(ishrmdeptfield)){%>checked<%}%> onclick=\"changeCheck('ishrmdeptfield4',this);if(this.checked){this.parentElement.nextSibling.value=1;}else{this.parentElement.nextSibling.value=0;}\"><INPUT class='Inputstyle' type='hidden' name='ishrmdeptfield' value='<%=ishrmdeptfield%>'>";
		        oCell.appendChild(oDiv);
		        jQuery(oCell).jNice();
		        
		        oCell = oRow.insertCell(6);
		        oDiv = document.createElement("div");
		        oDiv.innerHTML="<INPUT class='Inputstyle ishrmjobfield4' type='checkbox' name='tempishrmjobfield' <%if("1".equals(ishrmjobfield)){%>checked<%}%> onclick=\"changeCheck('ishrmjobfield4',this);if(this.checked){this.parentElement.nextSibling.value=1;}else{this.parentElement.nextSibling.value=0;}\"><INPUT class='Inputstyle' type='hidden' name='ishrmjobfield' value='<%=ishrmjobfield%>'>"
		        				+"<INPUT class='Inputstyle' type='hidden' name='isdeptfield' value='0'>"
		        				+"<INPUT class='Inputstyle' type='hidden' name='issubcomfield' value='0'>";
		        oCell.appendChild(oDiv);
		        jQuery(oCell).jNice();
	    	}
	    	var indexcell = 0;
	    	if("<%=type %>"==1)
	    	{
	    		indexcell = 5;
	    	}
	    	else if("<%=type %>"==2)
	    	{
	    		indexcell = 6;
	    	}
	    	else if("<%=type %>"==3)
	    	{
	    		indexcell = 4;
	    	}
	    	else if("<%=type %>"==4)
	    	{
	    		indexcell = 7;
	    	}
    		oCell = oRow.insertCell(indexcell);
	        oDiv = document.createElement("div");
	        oDiv.innerHTML="<textarea id='transql' name='transql' cols=25 rows=2 style='width:95%!important;'></textarea>";
			jQuery(oDiv).find("textarea").html('<%=(Util.toHtmlForSplitPage(transql.replaceAll("[\\n\\r\\t]"," ")))%>');
	        if("<%=type %>"==3){
	        	oDiv.innerHTML += "<INPUT class='Inputstyle' type='hidden' name='isdeptfield' value='<%=isdeptfield%>'>"
    				+"<INPUT class='Inputstyle' type='hidden' name='isparentfield' value='0'>"
    				+"<INPUT class='Inputstyle' type='hidden' name='issubcomfield' value='0'>"
    				+"<INPUT class='Inputstyle' type='hidden' name='ishrmdeptfield' value='0'>"
    				+"<INPUT class='Inputstyle' type='hidden' name='ishrmjobfield' value='0'>";
	        }
	        oCell.appendChild(oDiv);
<%
		}

%>
}

function changeCheck(classname,obj)
{
	var status = obj.checked;
	
	if(('isparentfield4'==classname&&!obj.checked)) {
	changeCheckboxStatus(jQuery("."+classname),false);
	$("."+classname).parent().next().val("0");
	}else{
	//alert("status : "+status);
	//alert("classname : "+classname);
	//$("."+classname).attr("checked",false);
	//$("."+classname).next().val("0");
	changeCheckboxStatus(jQuery("."+classname),false);
	$("."+classname).parent().next().val("0");
	changeCheckboxStatus(jQuery(obj),true);
	}
	if(obj.checked)
	{
		
		obj.parentElement.nextSibling.value=1;
		jQuery(obj.nextSibling).addClass("jNiceChecked");
	}
	else
	{
		obj.parentElement.nextSibling.value=0;
	}
}
function changeTableField(intetype)
{
	if(intetype==1)
	{
		$("input[name='outfield']").hide();
		$(".e8Browser").show();
	}
	else
	{
		$("input[name='outfield']").show();
		$(".e8Browser").hide();
	}
}
$(document).ready(function(){
	init();
	bindouttable();
	
	changeIntegration('<%=intetype%>');
	hideEle("tablelistparams2");
	hideEle("tablelistparams3");
	hideEle("tablelistparams4");
	hideEle("tablelistparams5");
	
	hideEle("webservicelistparams2");
	hideEle("webservicelistparams3");
	hideEle("webservicelistparams4");
	if("<%=isimportsuccess%>"=="false")
	{
		top.Dialog.alert('<%=SystemEnv.getHtmlLabelNames("31246,128199",user.getLanguage()) %>');//"导入失败"
	}
	else if("<%=isimportsuccess%>"=="true")
	{
		top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(28450,user.getLanguage()) %>');//"导入成功"
	}
	reshowCheckBox();

	<%if(!canexport){%>
		//第一次加载
		firstLoad();
	<%}%>
});

function firstLoad(){
	//分部
	addRow(1),addRow(1),addRow(1),addRow(1),addRow(1);
	var comArr=new Array();
	<%
	String[] feildCom = {"outkey","subcompanyname","subcompanycode","supsubcomid","subcompanydesc"};
	for(String f : feildCom){
		String text = (String)subComName.get(f);
		text = StringUtils.isBlank(text)?f:text; 
		out.print("comArr.push({value:'"+f+"',text:'"+text+"'});");
	}
	%>
	oaFirstFeild(comArr,1);
	oaFirstCheck({iskeyfield:1,isparentfield:4},1);
	
	//部门
	addRow(2),addRow(2),addRow(2),addRow(2),addRow(2);
	var deptArr=new Array();
	<%
	String[] feildDept = {"outkey","departmentname","supdepid","subcompanyid1","departmentmark"};
	for(String f : feildDept){
		String text = (String)deptName.get(f);
		text = StringUtils.isBlank(text)?f:text; 
		out.print("deptArr.push({value:'"+f+"',text:'"+text+"'});");
	}
	%>
	oaFirstFeild(deptArr,2);
	oaFirstCheck({iskeyfield:1,isparentfield:3,issubcomfield:4},2);
	
	//岗位
	addRow(3),addRow(3),addRow(3);
	var jobArr=new Array();
	<%
	String[] feildJob = {"outkey","jobtitlename","jobtitlemark"};
	for(String f : feildJob){
		String text = (String)jobName.get(f);
		text = StringUtils.isBlank(text)?f:text; 
		out.print("jobArr.push({value:'"+f+"',text:'"+text+"'});");
	}
	%>
	oaFirstFeild(jobArr,3);
	oaFirstCheck({iskeyfield:1},3);
	
	//人员
	addRow(4),addRow(4),addRow(4),addRow(4),addRow(4),addRow(4),addRow(4);
	var userArr=new Array();
	<%
	String[] feildUser = {"outkey","loginid","lastname","managerid","departmentid","jobtitle","password"};
	for(String f : feildUser){
		String text = (String)userName.get(f);
		text = StringUtils.isBlank(text)?f:text; 
		out.print("userArr.push({value:'"+f+"',text:'"+text+"'});");
	}
	%>
	oaFirstFeild(userArr,4);
	oaFirstCheck({iskeyfield:1,isparentfield:4,ishrmdeptfield:5,ishrmjobfield:6},4);
}
/**
 * arr:默认要出现的行集合，每一行为一个对象，有value和text属性，用来显示和实际值
 * type:1-4，表示公司到人员，那个tab下的
 */
function oaFirstFeild(arr,type){
	$("#oTable"+type+" tr[class!=header]").each(function(i){
		var inp = $(this).find("td:eq(1) input");
		inp.val(arr[i].value);
		var span='<span class="e8_showNameClass e8_showNameClassPadding"><a onclick="return false;" href="#'+arr[i].text+'" title="'+arr[i].text+'">'+arr[i].text+'</a></span>';
		inp.next().html(span);
		$(this).find("span[name=oafieldspanimg]").hide();
	});
}
/**
 * obj:要选中的check框及其所在的表格行
 * type:1-4，表示公司到人员，那个tab下的
 */
function oaFirstCheck(obj,type){
	var trs = $("#oTable"+type+" tr[class!=header]");
	var cheks = ["iskeyfield","isparentfield","issubcomfield","isdeptfield","ishrmdeptfield","ishrmjobfield"];
	for(var i=0;i<cheks.length;i++){
		if(obj[cheks[i]]){
			var tr = trs.get(obj[cheks[i]]-1);
			$(tr).find("input[name="+cheks[i]+"]").val(1);
			$(tr).find("input[name="+cheks[i]+"]").closest("div").find("input[type=checkbox]").attr("checked", true);
			$(tr).find("input[name="+cheks[i]+"]").closest("td").find("span[class=jNiceCheckbox]").addClass("jNiceChecked");
		}
	}
}
function showListTab1()
{
	try
	{
		jQuery('#tabbox1').Tabs({
	    	getLine:1,
        	staticOnLoad:false,
        	needInitBoxHeight:false,
	    	container:"#tabbox1"
	    });
	    showListTab();
    }
    catch(e)
    {
    }
}
function showListTab2()
{
	try
	{
	    jQuery('#tabbox2').Tabs({
	    	getLine:1,
        	staticOnLoad:false,
        	needInitBoxHeight:false,
	    	container:"#tabbox2"
	    });
	    showListTab();
    }
    catch(e)
    {
    }
}

function showListTab()
{
	jQuery.jqtab = function(tabtit,tab_conbox,shijian) {
		showEle(tab_conbox);
		$(tabtit).find("li:first").addClass("current").show();
		//alert($(tabtit).find("li:first").html());
		$(tabtit).find("li").bind(shijian,function(){
		    $(this).addClass("current").siblings("li").removeClass("current"); 
			var activeindex = $(tabtit).find("li").index(this)+1;
			//alert(activeindex);
			hideEle("tablelistparams1");
			hideEle("tablelistparams2");
			hideEle("tablelistparams3");
			hideEle("tablelistparams4");
			hideEle("tablelistparams5");
			$(".setbutton").hide();
			showEle("tablelistparams"+activeindex);
			$("#button"+activeindex).show();
			return false;
		});
	
	};
	/*调用方法如下：*/
	$.jqtab("#tabs","tablelistparams1","click");
	$("#tabs").find("li:first").click();
	
	jQuery.jqtab2 = function(tabtit,tab_conbox,shijian) {
		showEle(""+tab_conbox);
		$(tabtit).find("li:first").addClass("current").show();
		
		$(tabtit).find("li").bind(shijian,function(){
		    $(this).addClass("current").siblings("li").removeClass("current"); 
			var activeindex = $(tabtit).find("li").index(this)+1;
			hideEle("webservicelistparams1");
			hideEle("webservicelistparams2");
			hideEle("webservicelistparams3");
			hideEle("webservicelistparams4");
			showEle("webservicelistparams"+activeindex);
			return false;
		});
	
	};
	/*调用方法如下：*/
	$.jqtab2("#tabs2","webservicelistparams1","click");
	$("#tabs2").find("li:first").click();
	
	// 移除.magic-line的click事件
	$(".magic-line").unbind();
}
function showFre(mode)
{
	for(i = 0; i < 4; i++)
	{
		document.getElementById("show_" + i).className = "vis4";
	}
	if("9" != mode)
	{
		document.getElementById("show_" + mode).className = "vis3";
	}
}
function exportFile()
{
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(83566,user.getLanguage())%>", function (){
        frmMain.operation.value = "export";
		onSubmit();
    }, function () {}, 320, 90);
}
var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}
//新建子目录
function openDialog(url,title,width,height){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = url;
	dialog.Title = title;
	dialog.Width = width;
	dialog.Height = height;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
function importFile()
{
	var url = "/integration/hrsettingimport.jsp?isdialog=1";
	var title = "<%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%>";
	openDialog(url,title,500,200);
}
var parseWSDL = "<%=webserviceurl%>";
var METHOD_PARAMS_TABLE_HTML = "<table class='ListStyle'><COLGROUP><COL width='1%' align='left'><COL width='15%' align='left'><COL width='15%' align='left'><COL width='25%' align='left'><COL width='15%' align='left'><COL width='25%' align='left'>"+
	"<tr class='header'>"+
    "<td>&nbsp;</td>"+
    "<td><%=SystemEnv.getHtmlLabelName(20968, user.getLanguage())%></td>"+
    "<td><%=SystemEnv.getHtmlLabelName(561, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%></td>"+
    "<td><%=SystemEnv.getHtmlLabelName(32392, user.getLanguage())%></td>"+
    "<td><%=SystemEnv.getHtmlLabelName(32393, user.getLanguage())%></td>"+
    "<td><%=SystemEnv.getHtmlLabelName(17637, user.getLanguage())%>&nbsp;&nbsp;<SPAN class=\"e8tips\" style=\"CURSOR: hand\" id=remind title=\"<%=SystemEnv.getHtmlLabelName(84659, user.getLanguage())%>\"><IMG src=\"/images/tooltip_wev8.png\" align=\"absMiddle\"/></SPAN></td>"+
    "</tr>";
function ParseWSDL()
{
    //alert("test : "+idx);
    var webserviceurl = jQuery("#webserviceurl").val();
    if(parseWSDL == webserviceurl){
    	return;
    }
    parseWSDL = webserviceurl;
    if(""!=webserviceurl)
    {
	    var timestamp = (new Date()).valueOf();
	    var params = "operator=getregisteinfo&id="+webserviceurl+"&ts="+timestamp;
	    //alert(params);
	    jQuery.ajax({
	        type: "POST",
	        url: "/integration/WSsettingOperation.jsp",
	        data: params,
	        success: function(msg){
	        	var result = jQuery.trim(msg);
	            if(result!="")
	            {
	            	var jsonarrs = eval(result);
	            	//alert(result);
	            	var selectel = document.getElementById("jobmothod");
	            	selectel.innerHTML = "";
   					selectel.options.add(new Option("",""));
	            	for(var i = 0;i<jsonarrs.length;i++)
	            	{
	            		var methodid = jsonarrs[i].id;
	            		var methodname = jsonarrs[i].methodname;
	            		var methoddesc = jsonarrs[i].methoddesc;
						var eo = new Option(methodname,methodid);
						eo.title = methoddesc;
				   		selectel.options.add(eo);
	            	}
	            	
					 var methoddiv = document.getElementById("jobmothodparams");
                    methoddiv.innerHTML = METHOD_PARAMS_TABLE_HTML + "</table>";
                    jQuery(methoddiv).jNice();
                    jQuery(".e8tips").wTooltip({html:true});
					jQuery(selectel).selectbox("detach");
	            	jQuery(selectel).selectbox();
					
	            	var selectel = document.getElementById("deptmothod");
	            	selectel.innerHTML = "";
   					selectel.options.add(new Option("",""));
	            	for(var i = 0;i<jsonarrs.length;i++)
	            	{
	            		var methodid = jsonarrs[i].id;
	            		var methodname = jsonarrs[i].methodname;
	            		var methoddesc = jsonarrs[i].methoddesc;
						var eo = new Option(methodname,methodid);
						eo.title = methoddesc;
				   		selectel.options.add(eo);
	            	}
					var methoddiv = document.getElementById("deptmothodparams");
                    methoddiv.innerHTML = METHOD_PARAMS_TABLE_HTML + "</table>";
                    jQuery(methoddiv).jNice();
                    jQuery(".e8tips").wTooltip({html:true});
					jQuery(selectel).selectbox("detach");
	            	jQuery(selectel).selectbox();
					
	            	var selectel = document.getElementById("subcommothod");
	            	selectel.innerHTML = "";
   					selectel.options.add(new Option("",""));
	            	for(var i = 0;i<jsonarrs.length;i++)
	            	{
	            		var methodid = jsonarrs[i].id;
	            		var methodname = jsonarrs[i].methodname;
	            		var methoddesc = jsonarrs[i].methoddesc;
						var eo = new Option(methodname,methodid);
						eo.title = methoddesc;
				   		selectel.options.add(eo);
	            	}
					var methoddiv = document.getElementById("subcommothodparams");
                    methoddiv.innerHTML = METHOD_PARAMS_TABLE_HTML + "</table>";
                    jQuery(methoddiv).jNice();
                    jQuery(".e8tips").wTooltip({html:true});
					jQuery(selectel).selectbox("detach");
	            	jQuery(selectel).selectbox();
					
	            	var selectel = document.getElementById("hrmmethod");
	            	selectel.innerHTML = "";
   					selectel.options.add(new Option("",""));
	            	for(var i = 0;i<jsonarrs.length;i++)
	            	{
	            		var methodid = jsonarrs[i].id;
	            		var methodname = jsonarrs[i].methodname;
	            		var methoddesc = jsonarrs[i].methoddesc;
						var eo = new Option(methodname,methodid);
						eo.title = methoddesc;
				   		selectel.options.add(eo);
	            	}
	            	var methoddiv = document.getElementById("hrmmethodparams");
                    methoddiv.innerHTML = METHOD_PARAMS_TABLE_HTML + "</table>";
                    jQuery(methoddiv).jNice();
                    jQuery(".e8tips").wTooltip({html:true});
					jQuery(selectel).selectbox("detach");
	            	jQuery(selectel).selectbox();
					
	            	//alert("selectel : "+selectel.innerHTML)
	            	$("#subcommothodimage").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	            	$("#deptmothodimage").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	            	$("#hrmmethodimage").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	            }
	            else
	            {
	            	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32394,user.getLanguage()) %>");//获取wsdl描述存在问题，请检查webservice url是否正确!
	            }
	        }
	    });
    }else{
    	var jobmothod = document.getElementById("jobmothod");
    	jobmothod.innerHTML = "";
   		jobmothod.options.add(new Option("",""));
		var methoddiv = document.getElementById("jobmothodparams");
		methoddiv.innerHTML = METHOD_PARAMS_TABLE_HTML + "</table>";
		jQuery(methoddiv).jNice();
		jQuery(".e8tips").wTooltip({html:true});
    	jQuery(jobmothod).selectbox("detach");
	    jQuery(jobmothod).selectbox();
	    
    	var deptmothod = document.getElementById("deptmothod");
    	deptmothod.innerHTML = "";
   		deptmothod.options.add(new Option("",""));
		var methoddiv = document.getElementById("deptmothodparams");
		methoddiv.innerHTML = METHOD_PARAMS_TABLE_HTML + "</table>";
		jQuery(methoddiv).jNice();
		jQuery(".e8tips").wTooltip({html:true});
    	jQuery(deptmothod).selectbox("detach");
	    jQuery(deptmothod).selectbox();
	    $("#deptmothodimage").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	    
	    var subcommothod = document.getElementById("subcommothod");
	    subcommothod.innerHTML = "";
   		subcommothod.options.add(new Option("",""));
		var methoddiv = document.getElementById("subcommothodparams");
		methoddiv.innerHTML = METHOD_PARAMS_TABLE_HTML + "</table>";
		jQuery(methoddiv).jNice();
		jQuery(".e8tips").wTooltip({html:true});
    	jQuery(subcommothod).selectbox("detach");
	    jQuery(subcommothod).selectbox();
	    $("#subcommothodimage").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	    
	    var hrmmethod = document.getElementById("hrmmethod");
	    hrmmethod.innerHTML = "";
   		hrmmethod.options.add(new Option("",""));
		var methoddiv = document.getElementById("hrmmethodparams");
		methoddiv.innerHTML = METHOD_PARAMS_TABLE_HTML + "</table>";
		jQuery(methoddiv).jNice();
		jQuery(".e8tips").wTooltip({html:true});
    	jQuery(hrmmethod).selectbox("detach");
	    jQuery(hrmmethod).selectbox();
	    $("#hrmmethodimage").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
    }
}
function setDataSource()
{
	parent.document.location.href="/integration/integrationTab.jsp?urlType=3"
}
function setWebservice()
{
	parent.document.location.href="/integration/integrationTab.jsp?urlType=1"
}
function ParseMethod(obj,type)
{
    //alert("test : "+idx);
    var methodid = jQuery(obj).val();
    if(""!=methodid)
    {
	    var timestamp = (new Date()).valueOf();
	    var params = "operator=getmethodinfo&methodid="+methodid+"&ts="+timestamp;
	    //alert(params);
	    jQuery.ajax({
	        type: "POST",
	        url: "/integration/WSsettingOperation.jsp",
	        data: params,
	        success: function(msg){
	        	var result = jQuery.trim(msg);
	            if(result!="")
	            {
	            	//alert(result)
	            	var jsonarrs = eval(result);
	            	var tempobj;
	            	if(type==1)
	            	{
		            	tempobj = document.getElementById("subcommothodparams");
		            	changemethodname(type,tempobj,jsonarrs)
	            	}
	            	else if(type==2)
	            	{
		            	tempobj = document.getElementById("deptmothodparams");
		            	changemethodname(type,tempobj,jsonarrs)
	            	}
	            	else if(type==3)
	            	{
		            	tempobj = document.getElementById("jobmothodparams");
		            	changemethodname(type,tempobj,jsonarrs)
	            	}
	            	else if(type==4)
	            	{
		            	tempobj = document.getElementById("hrmmethodparams");
		            	changemethodname(type,tempobj,jsonarrs)
	            	}
					var magicLine = $("#tabbox2 .magic-line");
                    magicLine.css("top", $("#tabbox2 .current").position().top+30);
	            }
	            else
	            {
	            	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83572, user.getLanguage())%>")
	            }
	        }
	    });
    }else{
		try {
            var tempobj;
            if (type == 1) {
                tempobj = document.getElementById("subcommothodparams");
                changemethodname(type,tempobj);
            } else if (type == 2) {
                tempobj = document.getElementById("deptmothodparams");
                changemethodname(type,tempobj);
            } else if (type == 3) {
                tempobj = document.getElementById("jobmothodparams");
                changemethodname(type,tempobj);
            } else if (type == 4) {
                tempobj = document.getElementById("hrmmethodparams");
                changemethodname(type,tempobj);
            }
            var magicLine = $("#tabbox2 .magic-line");
            magicLine.css("top", $("#tabbox2 .current").position().top+30);
        }catch(e){
            console.error(e);
		}
	}
}
function changemethodname(type,obj,paramlist)
{
	//alert(paramlist.length);
    var methoddiv = obj;
    //alert(methoddiv.innerHTML);
    var htmlstr = "<table class='ListStyle'><COLGROUP><COL width='3%' align='left'><COL width='15%' align='left'><COL width='15%' align='left'><COL width='25%' align='left'><COL width='15%' align='left'><COL width='25%' align='left'>";
    htmlstr += "<tr class='header'>"+
        "<td>&nbsp;</td>"+
        "<td><%=SystemEnv.getHtmlLabelName(20968, user.getLanguage())%></td>"+
        "<td><%=SystemEnv.getHtmlLabelName(561, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%></td>"+
        "<td><%=SystemEnv.getHtmlLabelName(32392, user.getLanguage())%></td>"+
        "<td><%=SystemEnv.getHtmlLabelName(32393, user.getLanguage())%></td>"+
        "<td><%=SystemEnv.getHtmlLabelName(17637, user.getLanguage())%></td>"+
        "</tr>";

	if(null!=paramlist&&paramlist.length>0)
	{

		for(var i = 0;i<paramlist.length;i++)
		{
			var params = paramlist[i];
			var id = params.id;
			var name = params.paramname;
			var kind = params.paramtype;
			var isarray = params.isarray;
			var ischeck = (isarray=="1")?"checked":"";
			htmlstr += "<tr>"+
					   "<td>&nbsp;</td>"+
					   "<td><INPUT type='hidden' name='methodtype' value='"+type+"'><INPUT class='Inputstyle' type='text' name='paramname' value='"+name+"' readonly></td>"+
					   "<td><INPUT class='Inputstyle' type='text' name='paramtype' value='"+kind+"' readonly></td>"+
					   "<td><INPUT class='Inputstyle' type='checkbox' name='tempisarray' "+ischeck+" onclick=\"if(this.checked){this.parentElement.nextSibling.value=1;}else{this.parentElement.nextSibling.value=0;}\"><INPUT type='hidden' name='isarray' value='"+isarray+"'></td>"+
					   "<td><INPUT class='Inputstyle' type='text' maxLength=10 name='paramsplit' value=''></td>"+
					   "<td><INPUT class='Inputstyle' type='text' maxLength=1000 name='paramvalue' value=''></td>"+
					   "</tr>";
			//alert(params.name)
		}
	}
    htmlstr += "</table>";
    methoddiv.innerHTML = htmlstr;
    jQuery(methoddiv).jNice();
}
function onSave()
{
	frmMain.operation.value = "save";
	onSubmit();
}
function onSubmit(){
	//if(!$("#jobmothod").val() && !$("#jobtable").val()){ 只要职责表为空就清空所有职责关联设置
	if(!$("#jobtable").val()){
		$("#oTable3 tr[class!=header]").remove();
	}
	var intetype = frmMain.intetype.value;
	var hasnulloafield = false;
	var hasdepartmentmark = false;
	var hasdepartmentname = false;
	var hassubcompanyname = false;
	var hassubcompanydesc = false;
	var hasjobtitlemark = false;
	var hasjobtitlename = false;
	/*Hrmresource:  
         status  (现在默认为空，可以和systemlanguage一样给个默认值)
	  Hrmdepartment :
                departmentmark 
                departmentname
	  Hrmsubcompany :
                subcompanyname 
                subcompanydesc
	  Hrmjobtitles:
                jobtitlemark 
                jobtitlename 
                jobactivityid */
	var oafields = jQuery("input[name='oafield']");
	jQuery.each(oafields, function(j, n){
      //alert( "Item #" + i + ": " + n );
      //alert("i : "+i+"    " +$(this).attr("checked"));
      if($(this).val()=="")
      {
      	hasnulloafield = true;
      }
      if($(this).val()=="departmentmark")
      {
      	hasdepartmentmark = true;
      }
      if($(this).val()=="departmentname")
      {
      	hasdepartmentname = true;
      }
      if($(this).val()=="subcompanyname")
      {
      	hassubcompanyname = true;
      }
      if($(this).val()=="subcompanydesc")
      {
      	hassubcompanydesc = true;
      }
      
      if($(this).val()=="jobtitlemark")
      {
      	hasjobtitlemark = true;
      }
      if($(this).val()=="jobtitlename")
      {
      	hasjobtitlename = true;
      }
      
    });
    
    var hasnulloutfield = false;
    var outfields = jQuery("input[name='outfield']");
	jQuery.each(outfields, function(j, n){
      //alert( "Item #" + i + ": " + n );
      //alert("i : "+i+"    " +$(this).attr("checked"));
      
      if($(this).val()=="")
      {
      	//alert($(this)[0].outerHTML);
        hasnulloutfield = true;
      }
    });
    
    //------------------------------------------------------------------------------------------------------------------------------
    //获取数据源
    var validatedbsource = $("#dbsource").val();
    //获取同步表设置信息
    var validatesubcomtable = $("#subcomtable").val();//分部
    var validatedepttable = $("#depttable").val();//部门
    var validatehrmtable = $("#hrmtable").val();//人员
    /*QC302663 [80][90]HR同步-解决WebService初始化下的配置字段缺少必填项提示的问题，岗位信息保存后，没有显示到列表上的问题,除去断点 start*/
   // debugger
   /*QC302663 [80][90]HR同步-解决WebService初始化下的配置字段缺少必填项提示的问题，岗位信息保存后，没有显示到列表上的问题,除去断点 start*/
    if(intetype==1 && !validatedbsource){
    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82092, user.getLanguage())%>!");//请选择数据源!
      	return;
    }
    if(intetype==1 && !validatesubcomtable){
    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32226, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15808, user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(23073, user.getLanguage())%>!");//同步分部表设置未设置，请填写!
      	return;
    }
    if(intetype==1 && !validatedepttable){
    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32225, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15808, user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(23073, user.getLanguage())%>!");//同步部门表设置未设置，请填写!
      	return;
    }
    if(intetype==1 && !validatehrmtable){
    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32227, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15808, user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(23073, user.getLanguage())%>!");//同步人员表设置未设置，请填写!
      	return;
    }
    //------------------------------------------------------------------------------------------------------------------------------
    
    //------------------------------------------------------------------------------------------------------------------------------
    //webservice优先级判断设置1. WEBSERVICE地址 2. 同步接口方法  3. 同步对应字段设置
    var validateWebserviceurl = $("#webserviceurl").val();
    var validateSubcommothod = $("#subcommothod").val();
    var validateDeptmothod = $("#deptmothod").val();
    var validateHrmmethod = $("#hrmmethod").val();
    
    if(intetype==2 && !validateWebserviceurl){
    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128937, user.getLanguage())%>WEBSERVICE<%=SystemEnv.getHtmlLabelName(110,user.getLanguage()) %>!");//请选择WEBSERVICE地址!
      	return;
    }
    if(intetype==2 && !validateSubcommothod){
    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128937, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(32232,user.getLanguage()) %>!");//请选择同步分部接口方法!
    	return;
    }
    if(intetype==2 && !validateDeptmothod){
    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128937, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(32230,user.getLanguage()) %>!");//请选择同步部门接口方法!
    	return;
    }
    if(intetype==2 && !validateHrmmethod){
    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128937, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(32234,user.getLanguage()) %>!");//请选择同步人员接口方法!
    	return;
    }
    //------------------------------------------------------------------------------------------------------------------------------
    
    if(hasnulloafield  && intetype!=3)
    {
    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32254, user.getLanguage())%>!");//数据属性字段不完整，请填写
      	return;
    }
    if(hasnulloutfield  && intetype!=3)
    {
    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32255, user.getLanguage())%>!");//同步属性字段不完整，请填写
      	return;
    }
    if(!hassubcompanyname && intetype!=3)
    {
    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83311, user.getLanguage())+subComName.get("subcompanyname")%>");//未设置分部简称同步属性，请设置!
      	return;
    }
    if(!hassubcompanydesc && intetype!=3)
    {
    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83312, user.getLanguage())+subComName.get("subcompanydesc")%>");//未设置分部描述同步属性，请设置!
      	return;
    }
    if(!hasdepartmentmark && intetype!=3)
    {
    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83309, user.getLanguage())+deptName.get("departmentmark")%>");//未设置部门标识同步属性，请设置!
      	return;
    }
    if(!hasdepartmentname && intetype!=3)
    {
    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83310, user.getLanguage())+deptName.get("departmentname")%>");//未设置部门名称同步属性，请设置!
      	return;
    }
    var issubcomfields = $('.issubcomfield2');
	var hassubcomfield = false;
	jQuery.each(issubcomfields, function(j, n){
      //alert( "Item #" + i + ": " + n );
      if($(this).attr("checked"))
      {
      	hassubcomfield = true;
      }
    });
    if(!hassubcomfield  && intetype!=3)
    {
   		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32261, user.getLanguage())+"!"+deptName.get("subcompanyid1")%>");//部门表必须有一个分部标识字段，请选择
   		return;
    }
    if(!hasjobtitlemark && intetype==1 && $("#jobtable").val()!="")
    {
    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83313, user.getLanguage())+jobName.get("jobtitlemark")%>");//未设置岗位标识同步属性，请设置!
      	return;
    }
    if(!hasjobtitlename && intetype==1 && $("#jobtable").val()!="")
    {
    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83314, user.getLanguage())+jobName.get("jobtitlename")%>");//未设置岗位描述同步属性，请设置!
      	return;
    }
	var iskeyfields = $('.iskeyfield'+i);
	for(var i = 1;i<5;i++)
	{
		var iskeyfields = $('.iskeyfield'+i);
		var haskeychecked = false;
		jQuery.each(iskeyfields, function(j, n){
	      //alert( "Item #" + i + ": " + n );
	      //alert("i : "+i+"    " +$(this).attr("checked"));
	      if($(this).attr("checked"))
	      {
	      	haskeychecked = true;
	      }
	    });
	    if(!haskeychecked  && intetype!=3)
	    {
	    	if(i==1)
	    	{
	    		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32258, user.getLanguage())%>！");//分部表必须有一个关键匹配标识字段，请选择
	    		return;
	    	}
	    	else if(i==2)
	    	{
	    		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32257, user.getLanguage())%>！");//部门表必须有一个关键匹配标识字段，请选择
	    		return;
	    	}
	    	else if(i==3 && $("#jobtable").val()!="" && intetype == 1)
	    	{
	    		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32256, user.getLanguage())%>！");//岗位表必须有一个关键匹配标识字段，请选择
	    		return;
	    	}
	    	else if(i==4)
	    	{
	    		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32259, user.getLanguage())%>！");//人员表必须有一个关键匹配标识字段，请选择
	    		return;
	    	}
	    }
	    haskeychecked = false;
	}
	/*
	var isdeptfields = $('.isdeptfield3');
	var hasdeptfield = false;
	jQuery.each(isdeptfields, function(j, n){
      //alert( "Item #" + i + ": " + n );
      if($(this).attr("checked"))
      {
      	hasdeptfield = true;
      }
    });
    if(!hasdeptfield  && intetype!=3)
    {
   		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32260, user.getLanguage())%>！");//岗位表必须有一个部门标识字段，请选择
   		return;
    }
    
    var issubcomfields = $('.issubcomfield2');
	var hassubcomfield = false;
	jQuery.each(issubcomfields, function(j, n){
      //alert( "Item #" + i + ": " + n );
      if($(this).attr("checked"))
      {
      	hassubcomfield = true;
      }
    });
    if(!hassubcomfield  && intetype!=3)
    {
   		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32261, user.getLanguage())%>！");//部门表必须有一个分部标识字段，请选择
   		return;
    }
    */
    var ishrmdeptfields = $('.ishrmdeptfield4');
	var hashrmdeptfield = false;
	jQuery.each(ishrmdeptfields, function(j, n){
      //alert( "Item #" + i + ": " + n );
      if($(this).attr("checked"))
      {
      	hashrmdeptfield = true;
      }
    });
    if(!hashrmdeptfield  && intetype!=3)
    {
   		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32262, user.getLanguage())+"！"+userName.get("departmentid")%>");//人员表必须有一个部门标识字段，请选择
   		return;
    }
     /*
    var ishrmjobfields = $('.ishrmjobfield4');
	var hashrmjobfield = false;
	jQuery.each(ishrmjobfields, function(j, n){
      //alert( "Item #" + i + ": " + n );
      if($(this).attr("checked"))
      {
      	hashrmjobfield = true;
      }
    });
    if(!hashrmjobfield  && intetype!=3)
    {
   		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32263, user.getLanguage())%>！");//人员表必须有一个岗位标识字段，请选择
   		return;
    }
    */
	var checkfields = "";
	var intetype = frmMain.intetype.value;
	if(intetype=="1")
		checkfields = "dbsource,depttable,subcomtable,hrmtable";
	else if(intetype=="2")
		checkfields = "webserviceurl,deptmothod,subcommothod,hrmmethod";
	else if(intetype=="3")
		checkfields = "customparams,custominterface";
	
    if(check_form(frmMain,checkfields))
    {
    	if(frmMain.operation.value =="export")
    	{
    		frmMain.target = "_blank"
    	}
    	else
    	{
    		frmMain.target = "_self"
    	}
    	frmMain.submit();
    }
	
}
function viewSearchUrl()
{
	prompt("","/integration/integrationTab.jsp?urlType=14");
}
jQuery(document).ready(function(){
	jQuery(".e8tips").wTooltip({html:true});
});
/*QC302663 [80][90]HR同步-解决WebService初始化下的配置字段缺少必填项提示的问题 start*/
function check_isExist(object,spannum,typenum){

   if(object.value!=""){
       $("#xmlspanid_"+spannum+"_"+typenum).hide();
   }else{
       $("#xmlspanid_"+spannum+"_"+typenum).show();
   }
   
}
/*QC302663 [80][90]HR同步-解决WebService初始化下的配置字段缺少必填项提示的问题 end*/
</script>

</HTML>
