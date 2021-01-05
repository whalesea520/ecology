
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>

<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />

<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>

<STYLE>
	.vis1	{ visibility:visible }
	.vis2	{ visibility:hidden }
	.vis3   { display:inline}
	.vis4   { display:none }
	
</STYLE>
</head>
<%
if(!HrmUserVarify.checkUserRight("intergration:ldapsetting",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String test = Util.null2String(request.getParameter("test"));
String errormsg = Util.null2String(request.getParameter("errormsg"));
errormsg=URLDecoder.decode(errormsg,"utf-8");
String flage = Util.null2String(request.getParameter("flage"));
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = "LDAP"+SystemEnv.getHtmlLabelName(26267,user.getLanguage());//集成
String needfav ="1";
String needhelp ="";
String note3 = SystemEnv.getHtmlLabelName(81879,user.getLanguage());
String isuseldap = "";
String ldaptype = "";
String factoryclass = "";
String ldapserverurl = "";
String ldapserverurl2 = "";
String ldaparea = "";
String ldapuser = "";
String ldappasswd = "";
String isUac = "";
String uacValue = "";
String ldaplogin = "";
String ldapcondition = "";
String TimeModul = "0";
String Frequency = "";
String frequencyy = "";
String createType = "";
String createTime = "";
String needSynOrg = "";
String needSynPerson = "";
String needSynPassword = "";
String passingCert = "";
String keystorepath = "";
String keystorepassword = "";
String needDismiss = "";
String needCloseDep = "";
String passwordpolicy = "";
String encriptpwd = "";//密码是否加密
String ldapSyncMethod = "";//ldap同步方法
String userblacklist = "";//用户同步排除列表

String sql = "select * from ldapset";
rs.executeSql(sql);
if(rs.next())
{
	isuseldap = Util.null2String(rs.getString("isuseldap"));
	ldaptype = Util.null2String(rs.getString("ldaptype"));
	factoryclass = Util.null2String(rs.getString("factoryclass"));
	ldapserverurl = Util.null2String(rs.getString("ldapserverurl"));
	ldapserverurl2 = Util.null2String(rs.getString("ldapserverurl2"));
	ldaparea = Util.null2String(rs.getString("ldaparea"));
	ldapuser = Util.null2String(rs.getString("ldapuser"));
	ldappasswd = Util.null2String(rs.getString("ldappasswd"));
	isUac = Util.null2String(rs.getString("isUac"));
	uacValue = Util.null2String(rs.getString("uacValue"));
	ldaplogin = Util.null2String(rs.getString("ldaplogin"));
	
	ldapcondition = Util.toHtml10(Util.null2String(rs.getString("ldapcondition")));
	TimeModul = Util.null2String(rs.getString("TimeModul"));
	Frequency = Util.null2String(rs.getString("Frequency"));
	frequencyy = Util.null2String(rs.getString("frequencyy"));
	createType = Util.null2String(rs.getString("createType"));
	createTime = Util.null2String(rs.getString("createTime"));
	needSynOrg = Util.null2String(rs.getString("needSynOrg"));
	needSynPassword = Util.null2String(rs.getString("needSynPassword"));
	passingCert = Util.null2String(rs.getString("passingCert"));
	keystorepath = Util.null2String(rs.getString("keystorepath"));
	keystorepassword = Util.null2String(rs.getString("keystorepassword"));
	needSynPerson = Util.null2String(rs.getString("needSynPerson"));
	passwordpolicy = Util.null2String(rs.getString("passwordpolicy"));
	ldapSyncMethod = Util.null2String(rs.getString("ldapSyncMethod"));	//LDAP同步方式
	userblacklist = Util.null2String(rs.getString("userblacklist"));
	
	encriptpwd = Util.null2String(rs.getString("encriptpwd"));//密码是否加密
	if(encriptpwd.equals("1")){//加密，对密码解密
		String password=new BaseBean().getPropValue("AESpassword", "pwd");
		if(password.equals("")){//缺省解密密码
			password="1";
		}
		ldappasswd = weaver.general.AES.decrypt(ldappasswd, password);//解密
	}
}
else
{
	factoryclass = "com.sun.jndi.ldap.LdapCtxFactory";
}

String companyval = "";
String departmentval = "";
String ouattr = "";
StringBuffer sBuffer_outype = new StringBuffer();
rs.executeSql("select * from ldapsetoutype");
if(rs.next()) {
	ouattr = rs.getString("ouattr");
	companyval = rs.getString("subcompany");
	departmentval = rs.getString("department");
}
%>

<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(25496,user.getLanguage())+",javascript:onSubmitAndTest(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(Util.null2String(isuseldap).equals("1"))
{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(33284, user.getLanguage())+",javascript:viewSearchUrl(),_self} ";//获取同步菜单地址
	RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td><br></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">			
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onSubmit()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(25496 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onSubmitAndTest()"/>
			<%
			if(Util.null2String(isuseldap).equals("1"))
			{
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(33284 ,user.getLanguage()) %>" class="e8_btn_top" onclick="viewSearchUrl()"/>
			<%
			}
			%>
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
<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="/integration/ldapsettingOperation.jsp">
<input type="hidden" id="method" name="method" value="add">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
	  <wea:item><%=SystemEnv.getHtmlLabelName(26472,user.getLanguage()) %></wea:item><!-- 是否启用 -->
	  <wea:item>
			<input class="inputstyle" type=checkbox tzCheckbox='true' id="isuseldap" name="isuseldap" value="1" <%if(isuseldap.equals("1"))out.println("checked"); %>>
	  </wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage()) %></wea:item><!-- 类型 -->
	  <wea:item>
			<select style='width:120px!important;' id="ldaptype" name="ldaptype">
				<option value="ad" <%if(ldaptype.equals("ad")) out.println("selected"); %>>AD</option>
				<option value="OpenLDAP" <%if(ldaptype.equals("OpenLDAP")) out.println("selected"); %>>OpenLDAP</option>
				<option value="sun one" <%if(ldaptype.equals("sun one")) out.println("selected"); %>>SUN ONE</option>
			</select>
	  </wea:item>
	  <wea:item>LDAP <%=SystemEnv.getHtmlLabelName(32285,user.getLanguage()) %></wea:item><!-- 驱动类 -->
	  <wea:item>
	  	<wea:required id="factoryclassimage" required="true" value='<%=factoryclass %>'>
	  	<input class="inputstyle" style='width:280px!important;' type=text size=50 maxLength="100" id="factoryclass" name="factoryclass" value="<%=factoryclass %>" onchange='checkinput("factoryclass","factoryclassimage")'>
	  	</wea:required>
	  </wea:item>
	  <wea:item>LDAP <%=SystemEnv.getHtmlLabelName(32286,user.getLanguage()) %>(Ldap->OA)</wea:item><!-- 服务器地址 -->
	  <wea:item>
	  	<wea:required id="ldapserverurlimage" required="true" value='<%=ldapserverurl %>'>
	  	<input class="inputstyle" style='width:280px!important;' type=text size=50 maxLength="100" id="ldapserverurl" name="ldapserverurl" value="<%=ldapserverurl %>" onchange='checkinput("ldapserverurl","ldapserverurlimage")'>
	  	</wea:required>
		<SPAN class="e8tips" style="CURSOR: hand" id=remind title="<%=SystemEnv.getHtmlLabelName(383025,user.getLanguage()) %>"><IMG src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN>
	  </wea:item>
	 
	  <wea:item><%=SystemEnv.getHtmlLabelName(2072,user.getLanguage()) %></wea:item><!-- 用户名 -->
	  <wea:item>
	  	<wea:required id="ldapuserimage" required="true" value='<%=ldapuser %>'>
	  	<input class="inputstyle" style='width:280px!important;' type=text maxLength="255" id="ldapuser" name="ldapuser" value="<%=ldapuser %>" onchange='checkinput("ldapuser","ldapuserimage")'>
	  	</wea:required>
		<SPAN class="e8tips" style="CURSOR: hand" id=remind title="<%=SystemEnv.getHtmlLabelName(383026,user.getLanguage()) %>"><IMG src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN>
	  </wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(409,user.getLanguage()) %></wea:item><!-- 密码 -->
	  <wea:item>
	  	<wea:required id="ldappasswdimage" required="true" value='<%=ldappasswd %>'>
	  	<input class="inputstyle" style='width:280px!important;' type=password maxLength="50" id="ldappasswd" name="ldappasswd" value="<%=ldappasswd %>" onchange='checkinput("ldappasswd","ldappasswdimage")'>
	  	</wea:required>
	  </wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(32287,user.getLanguage()) %></wea:item><!-- 同步域 -->
	  <wea:item>
	  	<wea:required id="ldapareaimage" required="true" value='<%=ldaparea %>'>
	  	<input class="inputstyle" style='width:280px!important;' type=text size=50 maxLength="4000" id="ldaparea" name="ldaparea" value="<%=ldaparea %>" onchange='checkinput("ldaparea","ldapareaimage")'>
	  	</wea:required>
	  	<SPAN class="e8tips" style="CURSOR: hand" id=remind title="<%=SystemEnv.getHtmlLabelName(32288,user.getLanguage())+"<br/>OU中出现\\,需要写成\\\\" %>"><IMG src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN>
	  </wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(32298,user.getLanguage()) %></wea:item><!-- 集成登陆ECOLOGY域名/地址 -->
	  <wea:item>
	  	<input class="inputstyle" style='width:280px!important;' type=text size=50 maxLength="100" id="ldaplogin" name="ldaplogin" value="<%=ldaplogin %>">
	  	<SPAN class="e8tips" style="CURSOR: hand" id=remind title="<%=SystemEnv.getHtmlLabelName(126720,user.getLanguage()) %>"><IMG src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN>	  	
	  </wea:item>
	  <wea:item>
	  	<%=SystemEnv.getHtmlLabelName(132171,user.getLanguage())%><!-- 开启/关闭SSO登录-->
	  </wea:item>
	  <wea:item>
	  		&nbsp;
	  		<input type="button" value="<%=SystemEnv.getHtmlLabelName(32164 ,user.getLanguage()) %>" class="e8_btn_top" onclick="openSSO();"/>&nbsp;&nbsp;
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(309 ,user.getLanguage()) %>" class="e8_btn_top" onclick="closeSSO();"/>		
	  		<SPAN class="e8tips" style="CURSOR: hand" id=remind title="<%=SystemEnv.getHtmlLabelName(132195,user.getLanguage()) %>"><IMG src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN> 	
	  </wea:item>
	  
	  <wea:item>
			<%=SystemEnv.getHtmlLabelName(383007,user.getLanguage())%><!-- 批量绑定AD账号 -->
	  </wea:item>
	 <wea:item>
		&nbsp;
		<input type="button" value="<%=SystemEnv.getHtmlLabelName(383007 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onSubmitAddAllAD();"/>&nbsp;&nbsp;
		<SPAN class="e8tips" style="CURSOR: hand" id=remind title="<%=SystemEnv.getHtmlLabelName(383209,user.getLanguage()) %>"><IMG src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN>
	 </wea:item>

	<wea:item>
		<%=SystemEnv.getHtmlLabelName(383008,user.getLanguage())%><!-- 批量撤销AD账号 -->
	</wea:item>
	<wea:item>
		&nbsp;
		<input type="button" value="<%=SystemEnv.getHtmlLabelName(383008 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onSubmitDeleteAllAD();"/>&nbsp;&nbsp;
		<SPAN class="e8tips" style="CURSOR: hand" id=remind title="<%=SystemEnv.getHtmlLabelName(383210,user.getLanguage()) %>"><IMG src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN>
	</wea:item>
	  
	  <wea:item><p style="font-weight:bold;"><%=SystemEnv.getHtmlLabelName(82262,user.getLanguage()) %></p></wea:item>
	  <wea:item></wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(81792,user.getLanguage()) %></wea:item><!-- 同步组织结构 -->
	  <wea:item>
			<input class="inputstyle" type=checkbox tzCheckbox='true' id="needSynOrg" name="needSynOrg" onclick="showdetail('needSynOrg');" value="y" <%if(needSynOrg.equals("y"))out.println("checked"); %>>
	  </wea:item>
	   <wea:item><%=SystemEnv.getHtmlLabelName(81793,user.getLanguage()) %></wea:item><!-- 同步人员 -->
	  <wea:item>
			<input class="inputstyle" type=checkbox tzCheckbox='true' id="needSynPerson" name="needSynPerson" onclick="showdetail('needSynPerson');" value="y" <%if(needSynPerson.equals("y"))out.println("checked"); %>>
	  </wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(81670,user.getLanguage()) %></wea:item><!-- 是否检查帐户禁用状态 -->
	  <wea:item>
	  	<input class="inputstyle" type=checkbox tzCheckbox='true' id="isUac" name="isUac" value="1" <%if(isUac.equals("1")) out.println("checked"); %>>
	  </wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(32299,user.getLanguage()) %></wea:item><!-- 同步条件 -->
	  <wea:item>
		<textarea class="inputstyle" style='width:280px!important;' rows="3" id="ldapcondition" name="ldapcondition" onchange='checkinput("ldapcondition","ldapconditionimage")'><%=ldapcondition %></textarea>
	  	<SPAN class="e8tips" style="CURSOR: hand" id=remind title="<%=SystemEnv.getHtmlLabelName(32293,user.getLanguage()) %>"><IMG src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN>
	  </wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(32220,user.getLanguage()) %></wea:item><!-- 同步方式 -->
		<wea:item>
			<select id="hrmethod" name="ldapSyncMethod" style='width:180px!important;'>
				<option value="1" <%if("1".equals(ldapSyncMethod)) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(30107,user.getLanguage()) %></option><!-- 手动同步 -->
				<option value="2" <%if("2".equals(ldapSyncMethod)) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(32221,user.getLanguage()) %></option><!-- 自动同步 -->
				<option value="3" <%if("3".equals(ldapSyncMethod)) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(30107,user.getLanguage())+SystemEnv.getHtmlLabelName(31052,user.getLanguage())+SystemEnv.getHtmlLabelName(32221,user.getLanguage()) %></option><!-- 手动&自动同步 -->
			</select>
	  </wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(32223,user.getLanguage()) %></wea:item><!-- 同步频率 -->
	  <wea:item>
	  	<SPAN class=itemspan>
		  	<SELECT style='width:120px!important;float:left;' id="TimeModul" name="TimeModul" onchange="showFre(this.value)">
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
	  <wea:item><p style="font-weight:bold;"><%=SystemEnv.getHtmlLabelName(82263,user.getLanguage()) %></p></wea:item>
	  <wea:item></wea:item>
	  
	  
	  <wea:item><%=SystemEnv.getHtmlLabelName(81794,user.getLanguage())%></wea:item><!-- 同步密码 -->
	  <wea:item>
			<input class="inputstyle" type=checkbox tzCheckbox='true' id="needSynPassword" name="needSynPassword" value="y" <%if(needSynPassword.equals("y"))out.println("checked"); %> onClick="onChangeOA2ADCfg(this)">
	  </wea:item>
	  
	  <wea:item><%=SystemEnv.getHtmlLabelName(132191,user.getLanguage())%></wea:item><!-- 绕过ad证书 -->
	  <wea:item>
			<input class="inputstyle" type=checkbox tzCheckbox='true' id="passingCert" name="passingCert" value="y" <%if(passingCert.equals("y"))out.println("checked"); %> onClick="passingCertCfg(this)">
	  </wea:item>
	  
	  <wea:item>LDAP<%=SystemEnv.getHtmlLabelName(32286,user.getLanguage()) %>(OA-><%=SystemEnv.getHtmlLabelName(82313,user.getLanguage())%>)</wea:item><!-- 服务器地址 -->
	  <wea:item>
	  	<wea:required id="ldapserverurlimage2" required='<%=needSynPassword.equals("y")%>' value="<%=ldapserverurl2 %>">
	  	<input class="inputstyle" style='width:280px!important;' type=text size=50 maxLength="100" id="ldapserverurl2" name="ldapserverurl2" value="<%=ldapserverurl2 %>" onchange='checkinput("ldapserverurl2","ldapserverurlimage2")' onblur='checkNeedSynPassword()'>
	  	</wea:required>
	  </wea:item>
	 
	  <wea:item  attributes="{'samePair':'certpair'}"><%=SystemEnv.getHtmlLabelName(81795,user.getLanguage())%><span style="color:red">(<%=SystemEnv.getHtmlLabelName(21760,user.getLanguage())%>)</span>
	  </wea:item><!-- 证书路径 -->
	  <wea:item  attributes="{'samePair':'certpair'}">
	  	<input class="inputstyle" style='width:280px!important;' type=text size=50 maxLength="100" id="keystorepath" name="keystorepath" value="<%=keystorepath %>" onchange='checkinput("keystorepath","keystorepathimage")'>
	  </wea:item>
	  <wea:item  attributes="{'samePair':'certpair'}"><%=SystemEnv.getHtmlLabelName(81796,user.getLanguage())%><span style="color:red">(<%=SystemEnv.getHtmlLabelName(21760,user.getLanguage())%>)</span>
	  </wea:item><!-- 证书密码 -->
	  <wea:item  attributes="{'samePair':'certpair'}">
	  	<input class="inputstyle" style='width:280px!important;' type=password size=50 maxLength="100" id="keystorepassword" name="keystorepassword" value="<%=keystorepassword %>" onchange='checkinput("keystorepassword","keystorepasswordimage")'></input>

		<!-- 在线导入证书 -->
		&nbsp;&nbsp;<input type="button" value="<%=SystemEnv.getHtmlLabelName(131957,user.getLanguage())%>" onClick="doOnlineImportCert();" class="e8_btn_submit"/>	  	
	  	&nbsp;&nbsp;<input  type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(25496 ,user.getLanguage()) %>" onclick="testssl()"></input>
	  <span id="testsslres"></span>
	  
	  
	  </wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(81797,user.getLanguage())%>
	  </wea:item><!-- AD域密码策略 -->
	  <wea:item>
	  	<textarea class="inputstyle" style='width:280px!important;' rows="3" id="passwordpolicy" name="passwordpolicy" onchange='checkinput("passwordpolicy","passwordpolicyimage")'><%=passwordpolicy %></textarea>
	  	<SPAN class="e8tips" style="CURSOR: hand" id=remind title="<%=SystemEnv.getHtmlLabelName(81797,user.getLanguage())%>"><IMG src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN>
	  </wea:item>
	  
	  
	  <!-- 同步黑名单 -->
	  <wea:item><p style="font-weight:bold;"><%=SystemEnv.getHtmlLabelName(382106,user.getLanguage())%></p></wea:item>
	  <wea:item></wea:item>
	   <wea:item><%=SystemEnv.getHtmlLabelName(382107,user.getLanguage())%></wea:item>
	  <wea:item>
	  	<textarea class="inputstyle" style='width:280px!important;' rows="4" id="userblacklist" name="userblacklist" ><%=userblacklist %></textarea>
	  	<SPAN class="e8tips" style="CURSOR: hand" id=remind title="<%=SystemEnv.getHtmlLabelName(382108,user.getLanguage())%>"><IMG src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN>
	  </wea:item>
	  
	  
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(82370,user.getLanguage())%>' attributes="{'samePair':'SetInfo4','groupOperDisplay':'none','itemAreaDisplay':'block',id='divisionheader'}">
		<wea:item type="groupHead">
	    </wea:item>
	    <wea:item attributes="{'colspan':'4','isTableList':'true'}">
	   		<div id="outypesetting">
				<wea:layout type="table" attributes="{'cols':'4','cws':'5%,30%,30%,30%'}">
					<wea:group context="" attributes="{'groupDisplay':'none'}">
						<wea:item type="thead">&nbsp;</wea:item>
						<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(82372,user.getLanguage())%></wea:item><!-- OU类型的标识属性 -->
						<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(82387,user.getLanguage())%></wea:item><!-- 表示分部的值 -->
						<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(82388,user.getLanguage())%></wea:item><!-- 表示部门的值 -->
						<wea:item >&nbsp;</wea:item>
						<wea:item>
							<input class="inputstyle" style='width:280px!important;' type=text size=50 id="ouattr" name="ouattr" value="<%=ouattr %>" onchange='checkinput("ouattr","ouattrimage")'>
						</wea:item>
						<wea:item>
							<input class="inputstyle" style='width:280px!important;' type=text size=50 id="companyval" name="companyval" value="<%=companyval %>" onchange='checkinput("companyval","companyvalimage")'>
						</wea:item>
						<wea:item>
							<input class="inputstyle" style='width:280px!important;' type=text size=50 id="departmentval" name="departmentval" value="<%=departmentval %>" onchange='checkinput("departmentval","departmentvalimage")'>
						</wea:item>
					</wea:group>
				</wea:layout>
			</div>
	    </wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(81799,user.getLanguage())%>' attributes="{'samePair':'SetInfo1','groupOperDisplay':'none','itemAreaDisplay':'block',id='divisionheader'}">
		<wea:item type="groupHead">
		  <div style='float:right;'>
			<input id='addbutton' type="button" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>(ALT+A)" onClick="addRow('division')" ACCESSKEY="A" class="addbtn"/>
			<input type="button" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>(ALT+G)" onClick="removeRow('division')" ACCESSKEY="G" class="delbtn"/>
		  </div>
	    </wea:item>
	    <wea:item attributes="{'colspan':'2','isTableList':'true'}">
	   	<div id="division">
		</div>
	    </wea:item>
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(82267,user.getLanguage())%>' attributes="{'samePair':'SetInfo2','groupOperDisplay':'none','itemAreaDisplay':'block',id='divisionfieldheader'}">
		<wea:item type="groupHead">
			<div style="float:right;">
				<input id='addbutton' type="button" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>(ALT+A)" onClick="addRow('divisionfield')" ACCESSKEY="A" class="addbtn"/>
				<input type="button" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>(ALT+G)" onClick="removeRow('divisionfield')" ACCESSKEY="G" class="delbtn"/>
			</div>
		</wea:item>
		<wea:item attributes="{'colspan':'2','isTableList':'true'}">
	   		<div id="divisionfield">
			</div>
	  	</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(82268,user.getLanguage())%>' attributes="{'samePair':'SetInfo3','groupOperDisplay':'none','itemAreaDisplay':'block',id='departmentfieldheader'}">
		<wea:item type="groupHead">
			<div style="float:right;">
				<input id='addbutton' type="button" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>(ALT+A)" onClick="addRow('departmentfield')" ACCESSKEY="A" class="addbtn"/>
				<input type="button" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>(ALT+G)" onClick="removeRow('departmentfield')" ACCESSKEY="G" class="delbtn"/>
			</div>
		</wea:item>
		<wea:item attributes="{'colspan':'2','isTableList':'true'}">
	   		<div id="departmentfield">
			</div>
	  	</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(32239,user.getLanguage())%>' attributes="{'samePair':'SetInfo5','groupOperDisplay':'none','itemAreaDisplay':'block'}">
	  <wea:item type="groupHead">
		  <div style='float:right;'>
			<input id='addbutton' type="button" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>(ALT+A)" onClick="addRow('outtersetting')" ACCESSKEY="A" class="addbtn"/>
			<input type="button" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>(ALT+G)" onClick="removeRow('outtersetting')" ACCESSKEY="G" class="delbtn"/>
		  </div>
	  </wea:item>
	  <wea:item attributes="{'colspan':'2','isTableList':'true'}">
	  	<div id="outtersetting">
		</div>
	  </wea:item>
	</wea:group>
</wea:layout>
<br>

  </FORM>
</BODY>

<script language="javascript">
$.ready(function() {
	
});
<%
	rs.executeSql("SELECT * FROM ldapsetparam order by id");
	StringBuffer ajaxdata = new StringBuffer();
	while (rs.next()) 
	{
        int id= Util.getIntValue(rs.getString("id"),0);
        String ldapattr= Util.null2String(rs.getString("ldapattr"));
        String userattr= Util.null2String(rs.getString("userattr"));
        ajaxdata.append("[");
        ajaxdata.append("{name:'paramid',value:'',iseditable:true,type:'input'},");
        ajaxdata.append("{name:'paramids',value:'',iseditable:true,type:'input'},");
        ajaxdata.append("{name:'userattr',value:'"+rs.getString("userattr") +"',label:'"+rs.getString("userattr") +"',iseditable:true,type:'browser'},");
        ajaxdata.append("{name:'ldapattr',value:'"+rs.getString("ldapattr") +"',iseditable:true,type:'input'}");
        ajaxdata.append("],");
	}
	String tempajaxdata = ajaxdata.toString();
	if(!"".equals(tempajaxdata))
	{
		tempajaxdata = tempajaxdata.substring(0,(tempajaxdata.length()-1));
	}
	tempajaxdata = "["+tempajaxdata+"]";
	//System.out.println("tempajaxdata : "+tempajaxdata);
	
	rs.executeSql("SELECT * FROM ldapsetdetail order by id");
	StringBuffer sbuffer = new StringBuffer();
	while (rs.next()) 
	{	
		String subcompanyid = rs.getString("subcompanyid");
		String subcompanyname = "";
		rs2.executeSql("SELECT t.subcompanyname FROM HrmSubCompany t where t.id="+subcompanyid);
		if(rs2.next()) {
			subcompanyname = rs2.getString("subcompanyname").replaceAll("\\\\","\\\\\\\\\\\\\\\\");
		}
        sbuffer.append("[");
        sbuffer.append("{name:'subcompanyid',value:'"+rs.getString("subcompanyid")+"',label:'"+subcompanyname+"',iseditable:true,type:'browser'},");
        sbuffer.append("{name:'subcompanydomain',value:'"+rs.getString("subcompanydomain").replaceAll("\\\\","\\\\\\\\\\\\\\\\") +"',iseditable:true,type:'input'}");
       
        
        sbuffer.append("],");
	}
	String tempajaxdata2 = sbuffer.toString();
	if(!"".equals(tempajaxdata2)) {
		tempajaxdata2 = tempajaxdata2.substring(0,(tempajaxdata2.length()-1));
	}
	//tempajaxdata2= "";
	tempajaxdata2 = "["+tempajaxdata2+"]";
	
	rs.executeSql("select * from ldapsetsubparam order by id");
	StringBuffer sBuffer_sub = new StringBuffer();
	while(rs.next()) {
		String ldapattr= Util.null2String(rs.getString("ldapsubattr"));
        String subattr= Util.null2String(rs.getString("subattr"));
        sBuffer_sub.append("[");
        sBuffer_sub.append("{name:'subattr',value:'"+subattr +"',label:'"+subattr +"',iseditable:true,type:'browser'},");
        sBuffer_sub.append("{name:'ldapsubattr',value:'"+ldapattr+"',iseditable:true,type:'input'}");
        sBuffer_sub.append("],");
	}
	String tempajaxdata3 = sBuffer_sub.toString();
	if(!"".equals(tempajaxdata3)) {
		tempajaxdata3 = tempajaxdata3.substring(0,(tempajaxdata3.length()-1));
	}
	tempajaxdata3 = "["+tempajaxdata3+"]";
	
	rs.executeSql("select * from ldapsetdepparam order by id");
	StringBuffer sBuffer_dep = new StringBuffer();
	while(rs.next()) {
		String ldapattr= Util.null2String(rs.getString("ldapdepattr"));
        String depattr= Util.null2String(rs.getString("depattr"));
        sBuffer_dep.append("[");
        sBuffer_dep.append("{name:'depattr',value:'"+depattr+"',label:'"+depattr+"',iseditable:true,type:'browser'},");
        sBuffer_dep.append("{name:'ldapdepattr',value:'"+ldapattr +"',iseditable:true,type:'input'}");
        sBuffer_dep.append("],");
	}
	String tempajaxdata4 = sBuffer_dep.toString();
	if(!"".equals(tempajaxdata4)) {
		tempajaxdata4 = tempajaxdata4.substring(0,(tempajaxdata4.length()-1));
	}
	tempajaxdata4 = "["+tempajaxdata4+"]";
	
	
	//String note1= "";
	
	//String note2 = "指定域中的组织结构与OA中的分部的对应关系(目前只支持一级分部的同步)，例：ou=subcompany1,ou=company1,dc=weaver,dc=com";+
	String note2 = SystemEnv.getHtmlLabelName(82314,user.getLanguage())+"<br/>OU中出现\\\\,需要写成\\\\\\\\" ;
%>
//{width:"47%",colname:"<%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%>",itemhtml:"<span class='browser' completeurl='' browserurl='/systeminfo/BrowserMain.jsp?url=/workflow/dmlaction/dmlTableFieldsBrowser.jsp?dmltablename=hrmresource' isMustInput='1' name='userattr' browserspanvalue='a' isSingle='true'></span>"},
																						   //<span class='browser' completeurl='/data.jsp?type=23' browserurl='/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata=1' name='capitalid' isMustInput='2' isSingle='true' _callback='loadinfo' ></span>
var items=[  
    {width:"47%",colname:"<%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%>",itemhtml:"<span class='browser' completeurl='/data.jsp' browserurl='/systeminfo/BrowserMain.jsp?mouldID=workflow&dmltablename=hrmresource&url=/workflow/dmlaction/dmlTableFieldsBrowser.jsp' isMustInput='1' name='userattr' isSingle='true' _callback='onSetTableField'></span>"},
    //{width:"47%",colname:"<%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%>",itemhtml:"<button type='button' class=Browser onClick=\"onShowTableField(this,'hrmresource');\"></BUTTON><input type=text id='userattr' name='userattr' value='' style='border:0px;' readOnly='true'><SPAN></SPAN>"},
    {width:"47%",colname:"<%=SystemEnv.getHtmlLabelName(20969,user.getLanguage())%>",itemhtml:"<INPUT class='Inputstyle' type='text' name='ldapattr'  value='' ><SPAN class='e8tips' style='CURSOR: hand' id=remind title='<%=SystemEnv.getHtmlLabelName(32295,user.getLanguage())%>'><IMG src='/images/tooltip_wev8.png' align='absMiddle'/></SPAN>"}];
var items_2=[
	//{width:"47%",colname:"<%=SystemEnv.getHtmlLabelName(33553,user.getLanguage())%>",itemhtml:"<INPUT class='Inputstyle' type='text' name='subcompanycode'  value='' />"},
	{width:"47%",colname:"<%=SystemEnv.getHtmlLabelName(33553,user.getLanguage())%>",itemhtml:"<span class='browser' completeurl='/data.jsp?type=164' browserurl='/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser.jsp?selectedids=' isAutoComplete='true' isMustInput='1' hasInput='true' name='subcompanyid' isSingle='true'></span>"},
	{width:"47%",colname:"<%=SystemEnv.getHtmlLabelName(32287,user.getLanguage())%>",itemhtml:"<INPUT class='Inputstyle' type='text' name='subcompanydomain'  value='' ><span class='mustinput'></span><SPAN class='e8tips' style='CURSOR: hand' id=remind title='<%=note2%>'><img src='/images/tooltip_wev8.png' align='absMiddle'/></SPAN>"}
];
var item_3=[
	{width:"47%",colname:"<%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%>",itemhtml:"<span class='browser' completeurl='/data.jsp' browserurl='/systeminfo/BrowserMain.jsp?mouldID=workflow&dmltablename=HrmSubCompany&url=/workflow/dmlaction/dmlTableFieldsBrowser.jsp' isMustInput='1' name='subattr' isSingle='true'></span>"},
    {width:"47%",colname:"<%=SystemEnv.getHtmlLabelName(20969,user.getLanguage())%>",itemhtml:"<INPUT class='Inputstyle' type='text' name='ldapsubattr'  value='' ><SPAN class='e8tips' style='CURSOR: hand' id=remind title='<%=SystemEnv.getHtmlLabelName(32295,user.getLanguage())%>'><IMG src='/images/tooltip_wev8.png' align='absMiddle'/></SPAN>"}];
var item_4=[
	{width:"47%",colname:"<%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%>",itemhtml:"<span class='browser' completeurl='/data.jsp' browserurl='/systeminfo/BrowserMain.jsp?mouldID=workflow&dmltablename=HrmDepartment&url=/workflow/dmlaction/dmlTableFieldsBrowser.jsp' isMustInput='1' name='depattr' isSingle='true'></span>"},
    {width:"47%",colname:"<%=SystemEnv.getHtmlLabelName(20969,user.getLanguage())%>",itemhtml:"<INPUT class='Inputstyle' type='text' name='ldapdepattr'  value='' ><SPAN class='e8tips' style='CURSOR: hand' id=remind title='<%=SystemEnv.getHtmlLabelName(32295,user.getLanguage())%>'><IMG src='/images/tooltip_wev8.png' align='absMiddle'/></SPAN>"}];


var option= {
   navcolor:"#003399",
   basictitle:"",
   toolbarshow:true,
   colItems:items,
   addrowtitle:"<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>",
   deleterowstitle:"<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>",
   usesimpledata:true,
   openindex:false,
   addrowCallBack:function() {
	jQuery(".e8tips").wTooltip({html:true});
   },
   configCheckBox:true,
   checkBoxItem:{"itemhtml":"<INPUT class='groupselectbox' type='checkbox' name='paramid'><INPUT type='hidden' name='paramids' value='-1'>","width":"6%"},
   initdatas:eval("<%=tempajaxdata%>")
};
var option2 = {
	navcolor:"#003399",
    basictitle:"",
    toolbarshow:true,
    colItems:items_2,
    addrowtitle:"<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>",
    deleterowstitle:"<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>",
    usesimpledata:true,
    openindex:false,
    addrowCallBack:function() {
	jQuery(".e8tips").wTooltip({html:true});
    },
    configCheckBox:true,
    checkBoxItem:{"itemhtml":"<INPUT class='groupselectbox' type='checkbox' name='paramid'><INPUT type='hidden' name='paramids' value='-1'>","width":"6%"},
    initdatas:eval("<%=tempajaxdata2%>")
};
 var option_dif= {
   navcolor:"#003399",
   basictitle:"",
   toolbarshow:true,
   colItems:item_3,
   addrowtitle:"<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>",
   deleterowstitle:"<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>",
   usesimpledata:true,
   openindex:false,
   addrowCallBack:function() {
	jQuery(".e8tips").wTooltip({html:true});
   },
   configCheckBox:true,
   checkBoxItem:{"itemhtml":"<INPUT class='groupselectbox' type='checkbox' name='paramid'><INPUT type='hidden' name='paramids' value='-1'>","width":"6%"},
   initdatas:eval("<%=tempajaxdata3%>")
};
 var option_def= {
   navcolor:"#003399",
   basictitle:"",
   toolbarshow:true,
   colItems:item_4,
   addrowtitle:"<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>",
   deleterowstitle:"<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>",
   usesimpledata:true,
   openindex:false,
   addrowCallBack:function() {
	jQuery(".e8tips").wTooltip({html:true});
   },
   configCheckBox:true,
   checkBoxItem:{"itemhtml":"<INPUT class='groupselectbox' type='checkbox' name='paramid'><INPUT type='hidden' name='paramids' value='-1'>","width":"6%"},
   initdatas:eval("<%=tempajaxdata4%>")
};

var group=null;
var group2 = null;
var group_dif = null;
var group_def = null;

jQuery(document).ready(function(){
	
	//alert(jQuery("#encrypttype").val());
	group=new WeaverEditTable(option);
    jQuery("#outtersetting").append(group.getContainer());
    var params=group.getTableSeriaData();
    //reshowCheckBox();
    
    group2=new WeaverEditTable(option2);
    jQuery("#division").append(group2.getContainer());
    var params2=group2.getTableSeriaData();
   
    group_dif=new WeaverEditTable(option_dif);
    jQuery("#divisionfield").append(group_dif.getContainer());
    var params_dif=group_dif.getTableSeriaData();
    
    group_def=new WeaverEditTable(option_def);
    jQuery("#departmentfield").append(group_def.getContainer());
    var params_def=group_def.getTableSeriaData();
    
    reshowCheckBox();
    if("<%=needSynOrg%>" == "y") {//同步组织结构 
		showGroup("SetInfo1");
		showGroup("SetInfo2");
		showGroup("SetInfo3");
		showGroup("SetInfo4");
    } else {
		hideGroup("SetInfo1");
		hideGroup("SetInfo2");
		hideGroup("SetInfo3");
		hideGroup("SetInfo4");
    }
	if("<%=needSynPerson%>" == "y") {//同步人员
		showGroup("SetInfo5");
	}else {
		hideGroup("SetInfo5");
	}
    jQuery(".optionhead").hide();
    jQuery(".tablecontainer").css("padding-left","0px");
    jQuery(".e8tips").wTooltip({html:true});
});
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


function onSubmitAddAllAD(){
	//批量绑定AD账号
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(383213,user.getLanguage())%>", function (){
		$.ajax({
			url : "/integration/ldapsettingOperation1.jsp?isad=1",
			type : "post",
			//data:{keystorepath:$("#keystorepath").val(),keystorepassword:$("#keystorepassword").val(),ldapuser:$("#ldapuser").val(),ldappasswd:$("#ldappasswd").val()},
			datatype : "json",
			success : function() {
				//top.Dialog.alert("绑定AD账号成功");				
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(132199,user.getLanguage())%>");
			}
		});
	});
	
}


function onSubmitDeleteAllAD(){
	//批量撤销AD账号
	 top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(383214,user.getLanguage())%>",function(){
		$.ajax({
			url : "/integration/ldapsettingOperation1.jsp?isad=0",
			type : "post",
			//data:{keystorepath:$("#keystorepath").val(),keystorepassword:$("#keystorepassword").val(),ldapuser:$("#ldapuser").val(),ldappasswd:$("#ldappasswd").val()},
			datatype : "json",
			success : function() {
				//top.Dialog.alert("撤销AD账号成功");				
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(132199,user.getLanguage())%>");
			}
		});
	});
	
}


function onSubmit(){
	var needSynOrg = $("#needSynOrg").attr("checked");//同步组织结构开启状态
	var subcompanyids = jQuery("input[name='subcompanyid']");
	//document.getElementsByName("subcompanycode");
	//var subcompanydomains = document.getElementsByName("subcompanydomain");
	//QC279506[80][90]LDAP集成-开启同步组织架构时，分部对应设置建议加必填项验证 start
	var subcompanydomains = jQuery("input[name='subcompanydomain']");
	if(needSynOrg){
	if(subcompanyids.length==0){
	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130686,user.getLanguage())%>");
			return;
	}
	}
	//QC279506[80][90]LDAP集成-开启同步组织架构时，分部对应设置建议加必填项验证 end
	for(var k = 0; needSynOrg && k < subcompanyids.length; k++) {
		if(subcompanyids[k].value== "" || subcompanydomains[k].value=="") {
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82328,user.getLanguage())%>");
			return;
		}
		
		var temp = subcompanydomains[k].value;
		var temp2 = subcompanyids[k].value;
		for(var m = k+1; m < subcompanyids.length; m++) {
			if(temp == subcompanydomains[m].value) {
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82332,user.getLanguage())%>");
				return;
			}
			
			if(temp2 == subcompanyids[m].value) {
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82336,user.getLanguage())%>");
				return;
			}
		}
	}
	//分部字段对应判断
	var ldapsubattrs = jQuery("input[name='ldapsubattr']");
	var subattrs = jQuery("input[name='subattr']");
	var subflag = 0;
	var subflag2 = 0;
	var flag_subcompanydesc = 0;
	for(k =0 ; k < subattrs.length; k++) {
		if(subattrs[k].value == "" || ldapsubattrs[k].value == "") {
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82284,user.getLanguage())%>");
			return;
		}
		var tempsubattr = subattrs[k].value;
		for(var t = k+1; t < subattrs.length; t++) {
			if(tempsubattr == subattrs[t].value) {
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82309,user.getLanguage())%>");
				return;
			}
		}
		if("subcompanyname" == subattrs[k].value) {
			subflag++;
		}
		if("subcompanycode" == subattrs[k].value) {
			subflag2++;
		}
		if("subcompanydesc" == subattrs[k].value){
            flag_subcompanydesc++;
		}
	}
	
	if(subflag == 0 && $("#needSynOrg").attr("checked")) {
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83177,user.getLanguage())%>");
		return;
	}
	if(flag_subcompanydesc == 0 && $("#needSynOrg").attr("checked")){
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130038,user.getLanguage())%>");
        return;
	}
	//分部对应关系设置中，勿同步子分部的编号，子分部的编号默认是ou的guid，代码中需要分部编号确认分部的上下级关系
	if(subflag2 != 0 && $("#needSynOrg").attr("checked")) {
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83187,user.getLanguage())%>");
		return;
	}
	
	//部门字段对应判断
	var ldapdepattrs = jQuery("input[name='ldapdepattr']");
	var depattrs = jQuery("input[name='depattr']");
	var depflag = 0;
	var depflag2 = 0;
	var flagDepMark = 0;
	for(k =0 ; k < depattrs.length; k++) {
		if(depattrs[k].value == "" || ldapdepattrs[k].value == "") {
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82285,user.getLanguage())%>");
			return;
		}
		
		var tempdepattr = depattrs[k].value;
		for(var s = k+1; s < depattrs.length; s++) {
			if(tempdepattr == depattrs[s].value) {
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82310,user.getLanguage())%>");
				return;
			}
		}
		if("departmentmark" == depattrs[k].value){
		    flagDepMark++;
		}
		if("departmentname" == depattrs[k].value) {
			depflag++;
		}
		if("departmentcode" == depattrs[k].value) {
			depflag2++;
		}
	}
	if(depflag == 0 && $("#needSynOrg").attr("checked")) {
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83178,user.getLanguage())%>");
		return;
	}
	if(flagDepMark == 0 && $("#needSynOrg").attr("checked")){
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130037,user.getLanguage())%>");
        return;
	}
	//部门对应关系设置中，勿同步部门编号，部门编号默认是ou的guid，代码中需要部门编号确认部门的上下级关系
	if(depflag2 != 0 && $("#needSynOrg").attr("checked")) {
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83186,user.getLanguage())%>");
		return;
	}
	
	//ou类型设置判断
	var ouattrs = $("input[name='ouattr']");
	var companyvals = $("input[name='companyval']");
	var departmentvals = $("input[name='departmentval']");
	for(k = 0; k < ouattrs.length; k++) {
		if(ouattrs[k].value != "" || companyvals[k].value != "" || departmentvals[k].value != "") {
			if(ouattrs[k].value == "" || companyvals[k].value == "" || departmentvals[k].value == "") {
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82493,user.getLanguage())%>");
				return;
			}
		}
	}
	
	
	
	//人员对应设置判断
	var ldapuserattrs = $("input[name='ldapattr']");
	var userattrs = $("input[name='userattr']");
    var hasloginid = false;
    var haslastname = false;
    for (var i = 0; i < userattrs.length; i++)
    {
        var userattr = userattrs[i];
		if(typeof(userattrs[i]) == "undefined" || typeof(userattrs[i].value) == "undefined")
        	continue;
        if(typeof(ldapuserattrs[i]) == "undefined" || typeof(ldapuserattrs[i].value) == "undefined")
        	continue;
        if(userattrs[i].value == "" || ldapuserattrs[i].value == "") {
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130999,user.getLanguage())%>");
			return;
		}
        for(var s = i+1; s < userattrs.length; s++) {
        	if(false == userattr.disabled && false == userattrs[s].disabled){
				if(userattr.value == userattrs[s].value) {
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130978,user.getLanguage())%>");
					return;
				}
			}
		}
        
        if(false == userattr.disabled)
        {
        	var userattrval = userattr.value;
        	if(userattrval=="loginid")
        	{
        		hasloginid = true;
        	}
        	if(userattrval=="lastname")
        	{
        		haslastname = true;
        	}
        }
    }
	
	var checked1 = $("#needSynPerson").attr("checked");//同步人员选项
    if(checked1 && !hasloginid)
    {
    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82311,user.getLanguage())%>");
    	return;
    }
    if(checked1 && !haslastname)
    {
    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82312,user.getLanguage())%>");
    	return;
    }
	var checked2 = $("#needSynPassword").attr("checked");//同步密码到AD选项
	if(checked2){
		if(check_form(frmMain,"ldapserverurl,factoryclass,ldaparea,ldapuser,ldappasswd,ldapserverurl2")) frmMain.submit();
	}else{
		if(check_form(frmMain,"ldapserverurl,factoryclass,ldaparea,ldapuser,ldappasswd")) frmMain.submit();
	}
	
   // var needSynPw = $("#needSynPassword").checked;
  // alert(needSynPw);
   // if("y" == needSynPw) {
   // 	if(check_form(frmMain,"ldapserverurl,ldapserverurl2,factoryclass,ldaparea,ldapuser,ldappasswd")) frmMain.submit();
   // } else {
    //	if(check_form(frmMain,"ldapserverurl,factoryclass,ldaparea,ldapuser,ldappasswd")) frmMain.submit();
   // }
    
    
}


function onSubmitAndTest(){

    var needSynOrg = $("#needSynOrg").attr("checked");//同步组织结构开启状态
    var subcompanyids = jQuery("input[name='subcompanyid']");
    //document.getElementsByName("subcompanycode");
    //var subcompanydomains = document.getElementsByName("subcompanydomain");
    var subcompanydomains = jQuery("input[name='subcompanydomain']");
    if(needSynOrg){
        if(subcompanyids.length==0){
            top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130686,user.getLanguage())%>");
            return;
        }
    }
    for(var k = 0; needSynOrg && k < subcompanyids.length; k++) {
        if(subcompanyids[k].value== "" || subcompanydomains[k].value=="") {
            top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82328,user.getLanguage())%>");
            return;
        }

        var temp = subcompanydomains[k].value;
        var temp2 = subcompanyids[k].value;
        for(var m = k+1; m < subcompanyids.length; m++) {
            if(temp == subcompanydomains[m].value) {
                top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82332,user.getLanguage())%>");
                return;
            }

            if(temp2 == subcompanyids[m].value) {
                top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82336,user.getLanguage())%>");
                return;
            }
        }
    }
    //分部字段对应判断
    var ldapsubattrs = jQuery("input[name='ldapsubattr']");
    var subattrs = jQuery("input[name='subattr']");
    var subflag = 0;
    var subflag2 = 0;
    var flag_subcompanydesc = 0;
    for(k =0 ; k < subattrs.length; k++) {
        if(subattrs[k].value == "" || ldapsubattrs[k].value == "") {
            top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82284,user.getLanguage())%>");
            return;
        }
        var tempsubattr = subattrs[k].value;
        for(var t = k+1; t < subattrs.length; t++) {
            if(tempsubattr == subattrs[t].value) {
                top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82309,user.getLanguage())%>");
                return;
            }
        }
        if("subcompanyname" == subattrs[k].value) {
            subflag++;
        }
        if("subcompanycode" == subattrs[k].value) {
            subflag2++;
        }
        if("subcompanydesc" == subattrs[k].value){
            flag_subcompanydesc++;
        }
    }

    if(subflag == 0 && $("#needSynOrg").attr("checked")) {
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83177,user.getLanguage())%>");
        return;
    }
    if(flag_subcompanydesc == 0 && $("#needSynOrg").attr("checked")){
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130038,user.getLanguage())%>");
        return;
    }
    //分部对应关系设置中，勿同步子分部的编号，子分部的编号默认是ou的guid，代码中需要分部编号确认分部的上下级关系
    if(subflag2 != 0 && $("#needSynOrg").attr("checked")) {
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83187,user.getLanguage())%>");
        return;
    }

    //部门字段对应判断
    var ldapdepattrs = jQuery("input[name='ldapdepattr']");
    var depattrs = jQuery("input[name='depattr']");
    var depflag = 0;
    var depflag2 = 0;
    var flagDepMark = 0;
    for(k =0 ; k < depattrs.length; k++) {
        if(depattrs[k].value == "" || ldapdepattrs[k].value == "") {
            top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82285,user.getLanguage())%>");
            return;
        }

        var tempdepattr = depattrs[k].value;
        for(var s = k+1; s < depattrs.length; s++) {
            if(tempdepattr == depattrs[s].value) {
                top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82310,user.getLanguage())%>");
                return;
            }
        }
        if("departmentmark" == depattrs[k].value){
            flagDepMark++;
        }
        if("departmentname" == depattrs[k].value) {
            depflag++;
        }
        if("departmentcode" == depattrs[k].value) {
            depflag2++;
        }
    }
    if(depflag == 0 && $("#needSynOrg").attr("checked")) {
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83178,user.getLanguage())%>");
        return;
    }
    if(flagDepMark == 0 && $("#needSynOrg").attr("checked")){
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130037,user.getLanguage())%>");
        return;
    }
    //部门对应关系设置中，勿同步部门编号，部门编号默认是ou的guid，代码中需要部门编号确认部门的上下级关系
    if(depflag2 != 0 && $("#needSynOrg").attr("checked")) {
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83186,user.getLanguage())%>");
        return;
    }

    //ou类型设置判断
    var ouattrs = $("input[name='ouattr']");
    var companyvals = $("input[name='companyval']");
    var departmentvals = $("input[name='departmentval']");
    for(k = 0; k < ouattrs.length; k++) {
        if(ouattrs[k].value != "" || companyvals[k].value != "" || departmentvals[k].value != "") {
            if(ouattrs[k].value == "" || companyvals[k].value == "" || departmentvals[k].value == "") {
                top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82493,user.getLanguage())%>");
                return;
            }
        }
    }



    //人员对应设置判断
    var userattrs = document.getElementsByName("userattr");
    var hasloginid = false;
    var haslastname = false;
    for (var i = 0; i < userattrs.length; i++)
    {
        var userattr = userattrs[i];
        if(false == userattr.disabled)
        {
            var userattrval = userattr.value;
            if(userattrval=="loginid")
            {
                hasloginid = true;
            }
            if(userattrval=="lastname")
            {
                haslastname = true;
            }
        }
    }

    var checked1 = $("#needSynPerson").attr("checked");//同步人员选项
    if(checked1 && !hasloginid)
    {
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82311,user.getLanguage())%>");
        return;
    }
    if(checked1 && !haslastname)
    {
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82312,user.getLanguage())%>");
        return;
    }

	document.frmMain.method.value="test";
	var checked = $("#needSynPassword").attr("checked");
	if(checked){
		if(check_form(frmMain,"ldapserverurl,factoryclass,ldaparea,ldapuser,ldappasswd,ldapserverurl2")) frmMain.submit();
	}else{
		if(check_form(frmMain,"ldapserverurl,factoryclass,ldaparea,ldapuser,ldappasswd")) frmMain.submit();
	}
	//var needSynPw = $("#needSynPassword").val();
	
    //if("y" == needSynPw) {
   // 	if(check_form(frmMain,"ldapserverurl,ldapserverurl2,factoryclass,ldaparea,ldapuser,ldappasswd")) frmMain.submit();
   // } else {
    //	if(check_form(frmMain,"ldapserverurl,factoryclass,ldaparea,ldapuser,ldappasswd")) frmMain.submit();
    //}
    
}
function onSetTableField(event,data,name){
	//Dialog.alert("event : "+event);
	//var obj= event.target || event.srcElement;
	//var fieldname = "";
	//if(data){
	//	if(data.id != ""){
	//		fieldname = data.name;
	//		alert("data : "+data.id+" data.name : "+data.name+" data.a1 : "+data.a1);
	//	}else{
	//		fieldname = "";
	//	}
	//}
	//obj.nextSibling.value=fieldname;
	var obj= event.target || event.srcElement;
	var fieldname = "";
	var fieldloginid ="";
	if(data){
		if(data.id != ""){
			fieldname = data.name;
			data.id = data.a1;
			fieldloginid = data.id;
			//alert("data : "+data.id+" data.name : "+data.name+" fieldloginid : "+data.a1);
		}else{
			fieldname = "";
			fieldloginid = "";
		}
	}
	obj.nextSibling.value=fieldname;
	
	//后续补上代码,完善功能
	
}
function addRow(v)
{
	if("division" == v)
	{
		group2.addRow(null);
	} else if("divisionfield" == v) {
		group_dif.addRow(null);
	} else if("departmentfield" == v){
		group_def.addRow(null);
	}else {
		group.addRow(null);
	}
}
function removeRow(v)
{
	var count = 0;//删除数据选中个数
	jQuery("#"+v+" input[name='paramid']").each(function(){
		if($(this).is(':checked')){
			count++;
		}
	});
	//alert(v+":"+count);
	if(count==0){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage()) %>");
	}else{
        if("division" == v)
		{
			group2.deleteRows();
		} else if("divisionfield" == v) {
			group_dif.deleteRows();
		} else if("departmentfield" == v){
			group_def.deleteRows();
		}else {
			group.deleteRows();
		}
	}
}
function viewSearchUrl()
{
	prompt("","/integration/integrationTab.jsp?urlType=15");
}



function testssl() {
	$.ajax({
		url : "/integration/testSSL.jsp",
		type : "post",
		data:{keystorepath:$("#keystorepath").val(),keystorepassword:$("#keystorepassword").val(),ldapuser:$("#ldapuser").val(),ldappasswd:$("#ldappasswd").val()},
		datatype : "json",
		success : function(res) {
			if(res.indexOf("ok") > 0) {
				//$("#testsslres").text("<%=SystemEnv.getHtmlLabelName(82325,user.getLanguage()) %>");
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82325,user.getLanguage())%>");
				onSubmit();
			} else if(res.indexOf("1") > -1){
				$("#testsslres").text("<%=SystemEnv.getHtmlLabelName(81848,user.getLanguage()) %>");
				
			} else if(res.indexOf("2") > -1) {
				$("#testsslres").text("<%=SystemEnv.getHtmlLabelName(81795,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(27685,user.getLanguage()) %>");
			} else if(res.indexOf("3") > -1) {
				$("#testsslres").text("<%=SystemEnv.getHtmlLabelName(81796,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(27685,user.getLanguage()) %>");
			} else {
				$("#testsslres").text("<%=SystemEnv.getHtmlLabelName(81827,user.getLanguage()) %>");
			}
			$("#testsslres").css("color","red");
			
		}
	
	});
}

var switchState = 0;
function showdetail(val) {
	/*
	var initval = "<%=needSynOrg%>";
	if(initval == "y") {
		if(switchState%2==0) {
			
			hideGroup("SetInfo1");
			hideGroup("SetInfo2");
			hideGroup("SetInfo3");
			hideGroup("SetInfo4");
		} else {
			showGroup("SetInfo1");
			showGroup("SetInfo2");
			showGroup("SetInfo3");
			showGroup("SetInfo4");
		}
		switchState++;
	} else if(initval != "y"){
		if(switchState%2==0) {
			showGroup("SetInfo1");
			showGroup("SetInfo2");
			showGroup("SetInfo3");
			showGroup("SetInfo4");
		} else {
			hideGroup("SetInfo1");
			hideGroup("SetInfo2");
			hideGroup("SetInfo3");
			hideGroup("SetInfo4");
		}
		switchState++;
	}
	*/
	var checked = $("#"+val).attr("checked");
	if(val=="needSynOrg"){//同步组织结构 
		if(checked){
			showGroup("SetInfo1");
			showGroup("SetInfo2");
			showGroup("SetInfo3");
			showGroup("SetInfo4");
		} else {
			hideGroup("SetInfo1");
			hideGroup("SetInfo2");
			hideGroup("SetInfo3");
			hideGroup("SetInfo4");
		}
	} else if(val=="needSynPerson"){//同步人员 
		if(checked){
			showGroup("SetInfo5");
		} else {
			hideGroup("SetInfo5");
		}
	}
}
	
	<%if("false".equals(test)){%>
	    <%if(errormsg.equals("1")&&"1".equals(flage)){%>
		top.Dialog.alert("LDAP<%=SystemEnv.getHtmlLabelName(32286,user.getLanguage()) %>(<%=SystemEnv.getHtmlLabelName(82313,user.getLanguage())%>->OA)<%=SystemEnv.getHtmlLabelName(32296,user.getLanguage())%>!");//测试不通过，请检查设置
		<%}else if(errormsg.equals("1")&&"2".equals(flage)){%>
		top.Dialog.alert("LDAP(OA-><%=SystemEnv.getHtmlLabelName(82313,user.getLanguage())%>)<%=SystemEnv.getHtmlLabelName(32296,user.getLanguage())%>!");//测试不通过，请检查设置
		<%}else if(errormsg.equals("2")){%>
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32287,user.getLanguage()) %>,<%=SystemEnv.getHtmlLabelName(2072,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(21695,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(409,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(32296,user.getLanguage())%>!");//测试不通过，请检查设置
		<%}else if(errormsg.equals("3")){%>
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32285,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(32296,user.getLanguage())%>!");//测试不通过，请检查设置
		<%} else if(errormsg.equals("codenull")){
			rs.executeSql("select subcompanyname from hrmsubcompany where id="+flage);
			String name = "";
			if(rs.next()) {
				name = rs.getString("subcompanyname");
			}
			 
		%>
		top.Dialog.alert("<%=name%><%=SystemEnv.getHtmlLabelName(81809,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(82241,user.getLanguage())%>");
        <%} else if(errormsg.indexOf("bucunzai")>-1){
			String exist=SystemEnv.getHtmlLabelName(126728,user.getLanguage());
			String notexist=SystemEnv.getHtmlLabelName(23084,user.getLanguage());
		    String msg_no=errormsg.replaceAll("bucunzai",notexist);
		    msg_no=msg_no.replaceAll("cunzai",exist);
		%>
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32296,user.getLanguage())%>!  ou:<%=msg_no%> ");//测试不通过，请检查设置

		<%} else{%>
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32296,user.getLanguage())%>!");//测试不通过，请检查设置
		<%}%>
	<%}else if("true".equals(test)){%>
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32297,user.getLanguage())%>!");//测试通过
	<%}%>

//
function onChangeOA2ADCfg(obj){
	var checked = $("#needSynPassword").attr("checked");
	if(checked){
		if($("#ldapserverurl2").val()==""){
			$("#ldapserverurlimage2").html("<IMG src=\"/images/BacoError_wev8.gif\" align=absMiddle />");
		}
	}else{
		$("#ldapserverurlimage2").html("");
	}
}
//绕过证书
function passingCertCfg(obj){
	//var checked = $("#passingCert").attr("checked");
	//if(checked){
//		hideEle("certpair");
	//}else{
		//showEle("certpair");
	//}
}
//LDAP服务器地址(OA->域)这个输入框离开时，校验修改AD密码是否选择了。如果未选择，将必填标识取消
function checkNeedSynPassword(){
	var checked = $("#needSynPassword").attr("checked");
	if(!checked){
		$("#ldapserverurlimage2").html("");
	}
}

/*334371 [80][90][优化]Ldap集成-增加AD单点登录跳转配置项 start*/
//开启SSO登录 
function openSSO(){	
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(132100,user.getLanguage())%>",function(){ 
			$.ajax({
				url:"/integration/IsSSOLogin.jsp",
				data:{"isSSOLogin":"1"},
				type:"post",
				dataType:"json",
				cache:false,
				success:function(result){
					if(result){
						top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(132199,user.getLanguage())%>");
					}else{
						top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(132200,user.getLanguage())%>");
					}
				},
				error:function(){
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(132200,user.getLanguage())%>");
				}
			});		
	});
}
//关闭SSO登录
function closeSSO(){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33703,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>",function(){ 
			$.ajax({
				url:"/integration/IsSSOLogin.jsp",
				data:{"isSSOLogin":"0"},
				type:"post",
				dataType:"json",
				cache:false,
				success:function(result){
					if(result){
						top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(132199,user.getLanguage())%>");
					}else{
						top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(132200,user.getLanguage())%>");
					}
				},
				error:function(){
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(132200,user.getLanguage())%>");
				}
			});		
	});
}
/*334371 [80][90][优化]Ldap集成-增加AD单点登录跳转配置项 end*/


function doOnlineImportCert() {
           
			window.showModalDialog( "/integration/ldapcert.jsp",
							"<%=SystemEnv.getHtmlLabelName(131957,user.getLanguage())%>",
							"dialogWidth:800px;resizable=no;status=no;dialogHeight:600px;dialogLeft:200px;dialogTop:150px;center:yes;help:yes;resizable");
}

</script>

</HTML>
