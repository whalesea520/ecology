<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.GCONST"%>
<%@ page import="weaver.general.IsGovProj"%>
<jsp:useBean id="SystemLogMonitorUtil" class="weaver.system.SystemLogMonitorUtil" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
		<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
		<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
	</head>

	<%
		int isgoveproj = Util.getIntValue(IsGovProj.getPath(), 0);//0:非政务系统，1：政务系统
		String imagefilename = "/images/hdDOC_wev8.gif";
		String titlename = "系统监控";
		String needfav = "1";
		String needhelp = "";
	%>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
				String monitortype =  Util.null2String(request.getParameter("monitortype"));
				String fromdate = Util.null2String(request.getParameter("fromdate"));
				String todate = Util.null2String(request.getParameter("todate"));
				String monitorbody =  Util.null2String(request.getParameter("monitorbody"));
				String monitorbodyid =  Util.null2String(request.getParameter("monitorbodyid"));
				int perpage = Util.getIntValue(Util.null2String(request.getParameter("perpage")), 10);
				SystemLogMonitorUtil.setMonitortype(monitortype);
				SystemLogMonitorUtil.setFromdate(fromdate);
				SystemLogMonitorUtil.setTodate(todate);
				SystemLogMonitorUtil.setMonitorbody(monitorbody);
				SystemLogMonitorUtil.setMonitorbodyid(monitorbodyid);
				SystemLogMonitorUtil.setPerpage(perpage);
				SystemLogMonitorUtil.setUser(user);
			%>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ",javascript:OnChangePage(),_self}";
			RCMenuHeight += RCMenuHeightStep;
			if(!"".equals(monitortype)&&!"4".equals(monitortype))
			{
				RCMenu += "{" + SystemEnv.getHtmlLabelName(18363, user.getLanguage()) + ",javascript:_table.firstPage(),_self}";
				RCMenuHeight += RCMenuHeightStep;
				RCMenu += "{" + SystemEnv.getHtmlLabelName(1258, user.getLanguage()) + ",javascript:_table.prePage(),_self}";
				RCMenuHeight += RCMenuHeightStep;
				RCMenu += "{" + SystemEnv.getHtmlLabelName(1259, user.getLanguage()) + ",javascript:_table.nextPage(),_self}";
				RCMenuHeight += RCMenuHeightStep;
				RCMenu += "{" + SystemEnv.getHtmlLabelName(18362, user.getLanguage()) + ",javascript:_table.lastPage(),_self}";
				RCMenuHeight += RCMenuHeightStep;
		    }
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<FORM id=weaver name=weaver method=post action="SystemLogMonitorTab.jsp">
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(197 ,user.getLanguage()) %>" style='display:none;' class="e8_btn_top" onclick="OnChangePage();"/>
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
		<div id='divshowreceivied' style='background: #FFFFFF; padding: 3px; width: 100%' valign='top'>
		</div>
		<wea:layout type="4col">
				<wea:group context="系统监控查询条件">
						<wea:item><%=SystemEnv.getHtmlLabelName(2239, user.getLanguage()) %></wea:item>
						<wea:item>
							<wea:required id="monitortypespan" required="true" value='<%=monitortype %>'>
							<select size=1 class=InputStyle id=monitortype name=monitortype style="width: 150" onchange="changeMonitorType();checkinput('monitortype','monitortypespan')">
								<option value="">
									&nbsp;
								</option>
								<option value="1" <% if(monitortype.equals("1")) {%> selected
									<%}%>>非授权访问文档</option>
								<option value="2" <% if(monitortype.equals("2")) {%> selected
									<%}%>>非授权访问客户</option>
								<option value="3" <% if(monitortype.equals("3")) {%> selected
									<%}%>>异常登陆系统</option>
								<option value="4" <% if(monitortype.equals("4")) {%> selected
									<%}%>>未使用动态密码</option>
							</select>
							</wea:required>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(97, user.getLanguage())%></wea:item>
						<wea:item>
							<button type="button" class="calendar" id="SelectDate" onclick="getDate(fromdatespan,fromdate)"></button>&nbsp;
						 	<span id="fromdatespan"><%=fromdate %></span>
						  	-&nbsp;&nbsp;<button type="button" class="calendar" id="SelectDate2" onclick="getDate(todatespan,todate)"></button>&nbsp;
						  	<span id="todatespan"><%=todate %></span>
						  	</span>
						  	<input type="hidden" name="fromdate" value="<%=fromdate %>">
						  	<input type="hidden" name="todate" value="<%=todate %>">
						  	
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(665, user.getLanguage())+SystemEnv.getHtmlLabelName(106, user.getLanguage()) %></wea:item>
						<wea:item>
							<span id="monitorbodyspan" style='float: left;' >
								<select id=monitorbody name=monitorbody class=InputStyle onchange="changeMonitorBody();">
									<% if(!monitortype.equals("")) {%>
									<option value="1" <% if(monitorbody.equals("1")) {%>
										selected <%}%>><%=SystemEnv.getHtmlLabelName(1867, user.getLanguage()) %></option>
									<% if(monitortype.equals("1")) {%>
									<option value="2" <% if(monitorbody.equals("2")) {%>
										selected <%}%>><%=SystemEnv.getHtmlLabelName(22243, user.getLanguage()) %></option>
									<option value="3" <% if(monitorbody.equals("3")) {%>
										selected <%}%>><%=SystemEnv.getHtmlLabelName(92, user.getLanguage()) %></option>
									<%} %>
									<% if(monitortype.equals("2")) {%>
									<option value="4" <% if(monitorbody.equals("4")) {%>
										selected <%}%>><%=SystemEnv.getHtmlLabelName(136, user.getLanguage())%></option>
										<%} %>
									<%} %>
								</select>
								&nbsp;
							</span>
							<span id="monitorbodyiddiv" <% if(monitortype.equals("")) {%>style='display:none;'<%} %>>
							<%
							String monitorbodynames = "";
							ArrayList bodyidList = Util.TokenizerString(monitorbodyid,",");
							for(int i=0;i<bodyidList.size();i++)
							{
								String bodyid = (String)bodyidList.get(i);
								if(monitorbody.equals("1"))
								{
									monitorbodynames += ResourceComInfo.getLastname(bodyid)+",";
								}
								else if(monitorbody.equals("2"))
								{
									monitorbodynames += DocComInfo.getDocname(bodyid)+",";
								}
								else if(monitorbody.equals("3"))
								{
									monitorbodynames += SecCategoryComInfo.getSecCategoryname(bodyid)+",";
								}
								else if(monitorbody.equals("4"))
								{
									monitorbodynames += CustomerInfoComInfo.getCustomerInfoname(bodyid)+",";
								}
							}
							%>
							<brow:browser viewType="0" name="monitorbodyid" browserValue='<%= monitorbodyid+"" %>'
							 browserOnClick="" browserUrl="" getBrowserUrlFn="onShowMonitorBody"
							 hasInput="false"  width="150px" isSingle="true" hasBrowser = "true" isMustInput='1' 
							 completeUrl="/data.jsp" 
							  browserSpanValue='<%=Util.toScreen(monitorbodynames,user.getLanguage())%>'> 
							   </brow:browser> 
							</span>
						</wea:item>
					</wea:group>
					<wea:group context="" attributes="{'groupDisplay':'none'}">
						<wea:item type="toolbar">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(197 ,user.getLanguage()) %>" class="zd_btn_submit" id="zd_btn_submit" onclick="OnChangePage();"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022 ,user.getLanguage()) %>" class="e8_btn_cancel" onclick="resetCondtion();"/>
						</wea:item>
					</wea:group>
				</wea:layout>
			

			<%
				if(!"".equals(monitortype)&&!"4".equals(monitortype))
				{
				String tableString = SystemLogMonitorUtil.getTableString();
			%>

			<TABLE width="100%">
				<tr>
					<td valign="top">
						<wea:SplitPageTag tableString='<%=tableString%>' mode="run" />
					</td>
				</tr>
			</TABLE>
			<%
			}
			else if("4".equals(monitortype))
			{
				List userlist = SystemLogMonitorUtil.getNoUseDynaPassUsers();
			%>
			<TABLE width="100%">
				<tr>
					<td valign="top">
						<DIV class=table>
							<TABLE class=ListStyle cellSpacing=1>
								<THEAD>
									<TR class=HeaderForXtalbe>
										<TH id=operatedate width="40%">
											<%=SystemEnv.getHtmlLabelName(21965, user.getLanguage()) %>&nbsp;
										</TH>
										<TH id=operatetime width="60%">
											<%=SystemEnv.getHtmlLabelName(18939, user.getLanguage()) %>&nbsp;
										</TH>
									</TR>
								</THEAD>
								<TBODY>
									<%
									for(int i=0;i<userlist.size();i++)
									{
										String uid = (String)userlist.get(i);
										String username = ResourceComInfo.getLastname(uid);
										String departmentname = DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(uid));
										String classname = (i%2==0)?"DataDark":"DataLight";
										
										if(!"".equals(username))
										{
									%>
									<TR style="VERTICAL-ALIGN: middle" class=<%=classname %>>
										<TD align=left>
											<a href="javascript:this.openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id=<%=uid %>')"><%=username %></a>
										</TD>
										<TD align=left>
											<a href="javascript:this.openFullWindowForXtable('/hrm/company/HrmDepartmentDsp.jsp?id=<%=ResourceComInfo.getDepartmentID(uid) %>')"><%=departmentname %></a>
										</TD>
									</TR>
									<%
										}
									} 
									%>
								</TBODY>
							</TABLE>
						</DIV>
					</td>
				</tr>
			</TABLE>
			<%
			}
			%>
		</form>
		
<SCRIPT language="javascript">
function onShowMonitorBody()
{
	tmpval = document.all("monitorbody").value
	tmpbodyval = document.all("monitorbodyid").value
	if(tmpval=="")
	{
		top.Dialog.alert("请先选择监控类型!");
		return;
	}
	if(tmpval == "1")
		return "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpbodyval;
	else if(tmpval == "2")
		return "/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="+tmpbodyval;
	else if(tmpval == "3")
		return "/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategoryMBrowser.jsp?selectids="+tmpbodyval;
	else if(tmpval == "4")
		return "/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="+tmpbodyval;
}
function changeMonitorType()
{
	var monitortype = document.weaver.monitortype.value;;
	var monitorbody = document.weaver.monitorbody.value;
	if(monitortype=="1")
	{
		if(monitorbody=="4")
		{
			document.getElementById("monitorbodyidspan").innerHTML = "";
			document.weaver.monitorbodyid.value="";
		}
	}
	else if(monitortype=="2")
	{
		if(monitorbody=="2"||monitorbody=="3")
		{
			document.getElementById("monitorbodyidspan").innerHTML = "";
			document.weaver.monitorbodyid.value="";
		}
	}
	else if(monitortype=="3")
	{
		if(monitorbody!="1")
		{
			document.getElementById("monitorbodyidspan").innerHTML = "";
			document.weaver.monitorbodyid.value="";
		}
	}
	else if(monitortype=="4")
	{
		document.getElementById("monitorbodyidspan").innerHTML = "";
		document.weaver.monitorbodyid.value="";
	}
	rebuildSelect(monitortype);
}
function rebuildSelect(monitortype)
{
	var selectstr="";
	if(monitortype=="1")
	{
    	selectstr="<select id=monitorbody name=monitorbody class=InputStyle onchange='changeMonitorBody();'>"+
					  "	<option value='1'><%=SystemEnv.getHtmlLabelName(1867, user.getLanguage()) %></option>"+
					  "	<option value='2'><%=SystemEnv.getHtmlLabelName(22243, user.getLanguage()) %></option>"+
					  "	<option value='3'><%=SystemEnv.getHtmlLabelName(92, user.getLanguage()) %></option>"+
					  "</select>"+
					"&nbsp;";
	}
	else if(monitortype=="2")
	{
    	selectstr="<select id=monitorbody name=monitorbody class=InputStyle onchange='changeMonitorBody();'>"+
					  "	<option value='1'><%=SystemEnv.getHtmlLabelName(1867, user.getLanguage()) %></option>"+
					  "	<option value='4'><%=SystemEnv.getHtmlLabelName(136, user.getLanguage()) %></option>"+
					  "</select>"+
					"&nbsp;";
	}
	else if(monitortype=="3"||monitortype=="4")
	{
		selectstr="<select id=monitorbody name=monitorbody class=InputStyle onchange='changeMonitorBody();'>"+
					  "	<option value='1'><%=SystemEnv.getHtmlLabelName(1867, user.getLanguage()) %></option>"+
					  "</select>"+
					"&nbsp;";
	}
	else
	{
		selectstr="<select id=monitorbody name=monitorbody class=InputStyle onchange='changeMonitorBody();'>"+
					  "</select>"+
					"&nbsp;";
	}
	var monitorbodyspan = document.getElementById("monitorbodyspan");
	monitorbodyspan.innerHTML = selectstr;
    jQuery(monitorbodyspan).jNice();
    jQuery(monitorbodyspan).find("select").selectbox("detach");
    jQuery(monitorbodyspan).find("select").selectbox();
    if(monitortype=="")
    	jQuery("#monitorbodyiddiv").hide();
    else
    	jQuery("#monitorbodyiddiv").show();
}
function changeMonitorBody()
{
	document.getElementById("monitorbodyidspan").innerHTML = "";
	document.weaver.monitorbodyid.value="";
}
function resetCondtion()
{
	weaver.monitortype.value = "";
	jQuery(weaver.monitortype).selectbox("detach");
	jQuery(weaver.monitortype).selectbox();
	
    changeMonitorType();
    checkinput('monitortype','monitortypespan');
    
    
    weaver.fromdate.value = "";
    weaver.todate.value = "";
    document.getElementById("fromdatespan").innerHTML = "";
    document.getElementById("todatespan").innerHTML = "";
    
	document.getElementById("monitorbodyidspan").innerHTML = "";
	document.weaver.monitorbodyid.value="";
}
function OnChangePage()
{
	var tmpval = document.all("monitorbody").value
	if(tmpval=="")
	{
		top.Dialog.alert("请先选择监控类型!");
		return;
	}
	document.weaver.submit();
}
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:OnChangePage});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#advancedSearch").bind("click", function(){
	  $(".searchInput").val('');
	});
});
</script>
	</body>
</html>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
