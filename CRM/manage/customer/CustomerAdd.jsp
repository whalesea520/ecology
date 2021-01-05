
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="java.net.URLEncoder"%>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CustomerDescComInfo" class="weaver.crm.Maint.CustomerDescComInfo" scope="page" />
<jsp:useBean id="CustomerSizeComInfo" class="weaver.crm.Maint.CustomerSizeComInfo" scope="page" />
<jsp:useBean id="ContactWayComInfo" class="weaver.crm.Maint.ContactWayComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="ContacterTitleComInfo" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<%
	String userid = user.getUID()+"";
	String type = Util.null2String(request.getParameter("type1"));
	String name = Util.null2String(request.getParameter("name1"));
	if(type.equals("19")){
		response.sendRedirect("/CRM/data/AddPerCustomer.jsp?type1="+type+"&name1=" + URLEncoder.encode(name));
		return;
	}
	
	String CreditAmount = "" ;
	String CreditTime = "";
	rs.executeSql("select * from CRM_CustomerCredit");
	if (rs.next()) {
		CreditAmount = Util.null2String(rs.getString("CreditAmount"));
		CreditTime = Util.null2String(rs.getString("CreditTime"));
	}
	boolean isperson = (type.equals("26"))?true:false;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>新建客户</title>
		<script language="javascript" src="../js/jquery-1.8.3.min_wev8.js"></script>
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<script language=javascript src="/js/checkData_wev8.js"></script>
		<script language="javascript" src="../js/jquery.fuzzyquery.min_wev8.js"></script>
		<script language="javascript" src="../js/util_wev8.js"></script>
		<link rel="stylesheet" href="../css/Base_wev8.css" />
		<style type="text/css">
			html,body{
				overflow:auto;
			}
			
			.item_title{width: auto;height: 20px;font-size: 14px;font-weight: bold;margin-left: 4px;font-family: '微软雅黑';}
			.item_table{width: 100%;}
			.item_table td.title{background: #F6F6F6;font-family: '微软雅黑';}
			
			
			.item_input{width: 90%;border: 1px #CCCCCC solid;border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;}
			.item_input_focus{border: 1px #1A8CFF solid;box-shadow:0px 0px 1px #1A8CFF;-moz-box-shadow:0px 0px 1px #1A8CFF;-webkit-box-shadow:0px 0px 1px #1A8CFF;}
			.btn_browser1{width:25px;height:22px;float: left;margin-left: 0px;margin-top: 2px;cursor: pointer;
				background: url('../images/btn_browser_wev8.png') center no-repeat !important;}
			.txt_browser{width:auto;line-height:22px;float: left;margin-left: 4px;margin-top: 2px;}
			
			.item_select {
				position: absolute;
				display: none;
				overflow: hidden;
				background: #fff;
				border: 1px #CCCCCC solid;
				box-shadow: 0px 0px 1px #fff;
				border-radius: 3px;
				-moz-border-radius: 3px;
				-webkit-border-radius: 3px;
				
				overflow-y: auto;
				overflow-x: hidden;
				SCROLLBAR-DARKSHADOW-COLOR: #CDCDCD;
				SCROLLBAR-ARROW-COLOR: #E2E2E2;
				SCROLLBAR-3DLIGHT-COLOR: #CDCDCD;
				SCROLLBAR-SHADOW-COLOR: #CDCDCD;
				SCROLLBAR-HIGHLIGHT-COLOR: #CDCDCD;
				SCROLLBAR-FACE-COLOR: #CDCDCD;
				scrollbar-track-color: #E2E2E2;
			}
			
			.item_option{
				min-width: 80px;
				padding-left: 10px;
				padding-right: 10px;
				line-height: 22px;
				cursor: pointer;
				font-family: '微软雅黑';
			}
			.item_option_hover{
				background-color: #0080C0;color: #FAFAFA;
			}
			.btn_add{margin-left: 10px;}
		</style>
		<!--[if IE]> 
		<style type="text/css">
			input{line-height: 180%;}
		</style>
		<![endif]-->
	</head>
	<body onbeforeunload="protectCus()">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(this),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location='/CRM/data/AddCustomerExist.jsp',_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/CRM/manage/util/RightClickMenu.jsp" %>
		<form id="weaver" name="weaver" action="/CRM/data/CustomerOperation.jsp" method=post onsubmit='return check_form(this,"Name,Abbrev,Address1,Language,Type,Description,Size,Source,Sector,Manager,Department,Title,FirstName,JobTitle,Email,seclevel,CreditAmount,CreditTime")' enctype="multipart/form-data">
		<input type="hidden" name="method" value="add" />
		<%if(isperson){ %><input type="hidden" name="isperson" value="1" /><%} %>
		<table id="main" style="width: 100%;height: 100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td align="center">
					<div style="width: 98%;height: 100%;margin: 0px auto;text-align: left;">
						<div style="width: 100%;height: 28px;border: 1px #CCCCCC solid;margin-top: 4px;background: url('../images/title_bg_wev8.gif') repeat-x;">
							<div style="line-height: 28px;margin-left: 10px;font-weight: bold;font-family: '微软雅黑';">新建客户</div>
						</div>
						
						<div style="width: 100%;">
							<table style="width: 100%;margin-top: 20px;" cellpadding="0" cellspacing="0" border="0">
								<colgroup><col width="7px"/><col width="6px"/><col width="*"/></colgroup>
								<tr>
									<td class="item_icon1"></td>
									<td></td>
									<td valign="top">
										<table style="width: 100%;height: auto" cellpadding="0" cellspacing="0" border="0">
											<colgroup><col width="50%"/><col width="50%"/></colgroup>
											<tr>
												<!-- 一般信息开始 -->
												<td valign="top">
													<div class="item_title item_title1"><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></div>
													<div class="item_line item_line1"></div>
													<table class="item_table" cellpadding="0" cellspacing="0" border="0">
														<colgroup><col width="125px"/><col width="*"/></colgroup>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
															<td class="data">
																<input class="item_input" maxlength=50 id="name" name="Name" onchange="checkinput('Name','Nameimage')" value="<%=name%>" />
																<span id="Nameimage">
																	<%if(name.equals("")){%><img src='/images/BacoError_wev8.gif' align=absMiddle /><%}%>
																</span>
															</td>
														</tr>
														<%if(!isperson){ %>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(17080,user.getLanguage())%></td>
															<td class="data">
																<input class="item_input" maxlength=50 name="crmcode" />
															</td>
														</tr>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(642,user.getLanguage())%>）</td>
															<td class="data">
																<input class="item_input" maxlength=50 name="Abbrev" onchange="checkinput('Abbrev','Abbrevimage')" />
																<span id="Abbrevimage"><img src="/images/BacoError_wev8.gif" align=absMiddle /></span>
															</td>
														</tr>
														<%} %>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>1</td>
															<td class="data">
																<input class="item_input" maxlength=120 name="Address1" onchange="checkinput('Address1','Address1image')" />
																<span id="Address1image"><img src="/images/BacoError_wev8.gif" align=absMiddle /></span>
															</td>
														</tr>
														<%if(!isperson){ %>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>2</td>
															<td class="data">
																<input class="item_input" maxlength=120 name="Address2" />
															</td>
														</tr>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>3</td>
															<td class="data">
																<input class="item_input" maxlength=120 name="Address3" />
															</td>
														</tr>
														<%} %>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(479,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></td>
															<td class="data">
																<div style="float:left;width:40%"><input class="item_input" maxlength=10 name="Zipcode"/></div>
																<div class="btn_browser1" style="float: left;" onclick="onShowBrowser('/hrm/city/CityBrowser.jsp','City',1)"></div>
																<div class="txt_browser" id="CitySpan" style="height: 22px;vertical-align: middle" ><img src="/images/BacoError_wev8.gif" align=absMiddle style="margin-top: 4px;"/></div>
																<input type="hidden" id="City" name="City" value=""/>
															</td>
														</tr>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(25223,user.getLanguage())%></td>
															<td class="data">
																<div class="btn_browser1" onclick="onShowBrowser('/hrm/city/CityTwoBrowser.jsp','citytwoCode',1)"></div>
																<div class="txt_browser" id="citytwoCodeSpan"></div>
																<input type="hidden" id="citytwoCode" name="citytwoCode" value=""/>
															</td>
														</tr>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(643,user.getLanguage())%></td>
															<td class="data">
																<div class="btn_browser1" onclick="onShowBrowser('/hrm/country/CountryBrowser.jsp','Country',1)" ></div>
																<div class="txt_browser" id="CountrySpan"><%=Util.toScreen(CountryComInfo.getCountryname(""+user.getCountryid()),user.getLanguage())%></div>
																<input type="hidden" id="Country" name="Country" value="<%=user.getCountryid()%>"/>
															</td>
														</tr>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%></td>
															<td class="data">
																<input type="text" class="item_input input_select" style="width: 120px !important;" id="languagename" name="languagename" _selectid="language_select" value="<%=LanguageComInfo.getLanguagename(user.getLanguage()+"") %>" readonly="readonly"/>
																<input type="hidden" id="language" name="Language" value="<%=user.getLanguage() %>"/>
															</td>
														</tr>
														<tr>
												        	<td class="title"><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></td>
												          	<td class="data">
												          		<input class="item_input" maxlength=120 name="Phone" onchange="checkinput('Phone','PhoneImage')" style="width:40%"/>
																<span id="PhoneImage"><img src="/images/BacoError_wev8.gif" align=absMiddle /></span>
												          		<input class="item_input" maxlength=50 name="Fax" style="width:40%;margin-left: 5px;" />
												          	</td>
												        </tr>
												        <tr>
												        	<td class="title"><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></td>
												          	<td class="data">
												          		<input class="item_input" maxlength=150 id="Email" name="Email" onchange="checkmyemail('Email','Emailimage')" />
																<span id="Emailimage"><img src="/images/BacoError_wev8.gif" align=absMiddle /></span>
												          	</td>
												        </tr>
												        <tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(76,user.getLanguage())%></td>
															<td class="data">
																<input class="item_input" maxlength=150 name="Website" value="http://"/>
															</td>
														</tr>
														<%if(!isperson){ %>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(634,user.getLanguage())%></td>
															<td class="data">
																<textarea name="introduction" onkeypress="checktext();" class="item_input" style="height: 50px"></textarea>
															</td>
														</tr>
														<%} %>
													</table>
												</td>
												<!-- 一般信息结束 -->
												<!-- 分类信息开始 -->
												<td valign="top">
													<div class="item_title item_title1"><%=SystemEnv.getHtmlLabelName(574,user.getLanguage())%></div>
													<div class="item_line item_line1"></div>
													<table class="item_table" cellpadding="0" cellspacing="0" border="0">
														<colgroup><col width="125px"/><col width="*"/></colgroup>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
															<td class="data">
																<input type="text" class="item_input input_select" style="width: 120px !important;" id="statusname" name="statusname" _selectid="status_select" 
																	value="" readonly="readonly" onblur="checkinput('CustomerStatus','statusImage')"/>
																<input type="hidden" id="status" name="CustomerStatus" value=""/>
																<span id="statusImage"><img src='/images/BacoError_wev8.gif' align=absMiddle /></span>
															</td>
														</tr>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
															<td class="data">
																<input type="text" class="item_input input_select" style="width: 120px !important;" id="typename" name="typename" _selectid="type_select" 
																	value="<%if(!type.equals("")){%><%=Util.toScreen(CustomerTypeComInfo.getCustomerTypename(type),user.getLanguage())%><%}%>" readonly="readonly"
																	onblur="checkinput('Type','typeImage')"/>
																<input type="hidden" id="type" name="Type" value="<%=type %>"/>
																<span id="typeImage">
																	<%if(type.equals("")){%><img src='/images/BacoError_wev8.gif' align=absMiddle /><%} %>
																</span>
															</td>
														</tr>
														<%if(!isperson){ %>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></td>
															<td class="data">
																<input type="text" class="item_input input_select" style="width: 120px !important;" id="descriptionname" name="descriptionname" _selectid="desc_select"
																 	value="" readonly="readonly" onblur="checkinput('Description','descriptionImage')"/>
																<input type="hidden" id="description" name="Description" value="" />
																<span id="descriptionImage"><img src='/images/BacoError_wev8.gif' align=absMiddle /></span>
															</td>
														</tr>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(576,user.getLanguage())%></td>
															<td class="data">
																<input type="text" class="item_input input_select" style="width: 120px !important;" id="size_nname" name="size_nname" _selectid="size_n_select" 
																	value="" readonly="readonly" onblur="checkinput('Size','size_nImage')"/>
																<input type="hidden" id="size_n" name="Size" value="" />
																<span id="size_nImage"><img src='/images/BacoError_wev8.gif' align=absMiddle /></span>
															</td>
														</tr>
														<%} %>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(645,user.getLanguage())%></td>
															<td class="data">
																<input type="text" class="item_input input_select" style="width: 120px !important;" id="sourcename" name="sourcename" _selectid="source_select"
																	value="" readonly="readonly" onblur="checkinput('Source','sourceImage')"/>
																<input type="hidden" id="source" name="Source" value="" />
																<span id="sourceImage"><img src='/images/BacoError_wev8.gif' align=absMiddle /></span>
															</td>
														</tr>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(575,user.getLanguage())%></td>
															<td class="data">
														  		<div class="btn_browser1" onclick="onShowBrowser('/CRM/Maint/SectorInfoBrowser.jsp','sector',1)" ></div>
																<div class="txt_browser" id="sectorSpan"><img src="/images/BacoError_wev8.gif" align=absMiddle  style='margin-top:4px;'/></div>
																<input type="hidden" id="sector" name="Sector" value=""/>
															</td>
														</tr>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></td>
															<td class="data">
														  		<input type="hidden" id="manager_val" name="Manager" value="<%=userid %>"/>
																<div class="txtlink showcon txtlink<%=userid %>" onmouseover='showdel(this)' onmouseout='hidedel(this)'>
																	<div style="float: left;"><%=cmutil.getHrm(userid) %></div>
																</div>
														  		<input id="manager" name="manager" class="add_input2" _init="1" _searchwidth="80" _searchtype="hrm"/>
														  		<div class="btn_add"></div>
														  		<div class="btn_browser" onclick="onShowBrowser2('manager','/hrm/resource/ResourceBrowser.jsp')"></div>
															</td>
														</tr>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(25171,user.getLanguage())%><!-- 开拓人员 --></td>
															<td class="data">
																<div id="exploiterImage" style="float:left;margin-right: 2px;"></div>
																<input type="hidden" id="exploiter_val" name="exploiterIds" value=""/>
																<input id="exploiter" class="add_input2" _init="1" _searchwidth="80" _searchtype="hrm"/>
																<div class="btn_add"></div>
														  		<div class="btn_browser" onclick="onShowBrowser2('exploiter','/hrm/resource/MutiResourceBrowser.jsp')"></div>
															</td>
														</tr>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(24976,user.getLanguage())%><!-- 客服负责人 --></td>
															<td class="data">
																<input type="hidden" id="principal_val" name="principalIds" value=""/>
																<input id="principal" class="add_input2" _init="1" _searchwidth="80" _searchtype="hrm"/>
																<div class="btn_add"></div>
															  	<div class="btn_browser" onclick="onShowBrowser2('principal','/hrm/resource/MutiResourceBrowser.jsp')"></div>
															</td>
														</tr>
														<%if(!isperson){ %>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(132,user.getLanguage())%></td>
															<td class="data">
																<div id="agentImage" style="float:left;margin-right: 2px;"></div>
																<input type="hidden" id="agent_val" name="Agent" value=""/>
														  		<input id="agent" name="agent" class="add_input2" _init="1" _searchwidth="160" _searchtype="agent"/>
														  		<div class="btn_add"></div>
														  		<div class="btn_browser" onclick="onShowBrowser2('agent','/CRM/data/CustomerBrowser.jsp?sqlwhere=where t1.type in (3,4,11,12,13,14,15,16,17,18,20,21,25,19)')"></div>
															</td>
														</tr>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(591,user.getLanguage())%></td>
															<td class="data">
																<input type="hidden" id="parentid_val" name="Parent" value=""/>
														  		<input id="parentid" name="parentid" class="add_input2" _init="1" _searchwidth="160" _searchtype="crm"/>
														  		<div class="btn_add"></div>
														  		<div class="btn_browser" onclick="onShowBrowser2('parentid','/CRM/data/CustomerBrowser.jsp')"></div>
															</td>
														</tr>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></td>
															<td class="data">
																<input type="hidden" id="documentid_val" name="Document" value=""/>
														  		<input id="documentid" name="documentid" class="add_input2" _init="1" _searchwidth="160" _searchtype="doc"/>
														  		<div class="btn_add"></div>
														  		<div class="btn_browser" onclick="onShowBrowser2('documentid','/docs/docs/DocBrowser.jsp')"></div>
															</td>
														</tr>
														<%} %>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(6069,user.getLanguage())%></td>
															<td class="data">
																<input type="hidden" id="introductionDoc_val" name="introductionDocid" value=""/>
														  		<input id="introductionDoc" name="introductionDoc" class="add_input2" _init="1" _searchwidth="160" _searchtype="doc"/>
														  		<div class="btn_add"></div>
														  		<div class="btn_browser" onclick="onShowBrowser2('introductionDoc','/docs/docs/DocBrowser.jsp')"></div>
															</td>
														</tr>
														<%if(!isperson){ %>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(120,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></td>
															<td class="data">
																<input class="item_input" style="width: 40px;" maxlength=3 size=5 id="seclevel" name="seclevel" onkeypress="ItemCount_KeyPress()" onblur="checknumber('seclevel');checkinput('seclevel','seclevelimage')" value="0"/>
																<span id="seclevelimage"></span>
															</td>
														</tr>
														<%} %>
													</table>
												</td>
												<!-- 分类信息结束 -->
											</tr>
											<tr>
												<!-- 联系人开始 -->
												<td valign="top">
													<div class="item_title item_title1"><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></div>
													<div class="item_line item_line1"></div>
													<table class="item_table" cellpadding="0" cellspacing="0" border="0">
														<colgroup><col width="125px"/><col width="*"/></colgroup>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(462,user.getLanguage())%></td>
															<td class="data">
																<input type="text" class="item_input input_select" style="width: 120px !important;" id="titlename" name="titlename" _selectid="title_select" 
																	value="" readonly="readonly" onblur="checkinput('Title','titleImage')"/>
																<input type="hidden" id="title" name="Title" value=""/>
																<span id="titleImage"><img src='/images/BacoError_wev8.gif' align=absMiddle /></span>
															</td>
														</tr>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td>
															<td class="data">
																<input class="item_input" maxlength=50 name="FirstName" onchange="checkinput('FirstName','FirstNameimage')" />
																<span id="FirstNameimage"><img src="/images/BacoError_wev8.gif" align=absMiddle /></span>
															</td>
														</tr>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(640,user.getLanguage())%></td>
															<td class="data">
																<input class="item_input" maxlength=100 name="JobTitle" onchange="checkinput('JobTitle','JobTitleimage')" />
																<span id="JobTitleimage"><img src="/images/BacoError_wev8.gif" align=absMiddle /></span>
															</td>
														</tr>
														<%if(!isperson){ %>
														<tr>
															<td class="title">项目角色</td>
															<td class="data">
																<input type="text" class="item_input input_select" id="projectrole" name="projectrole" style="width: 200px !important;" _selectid="pr_select" 
																	value=""/>
															</td>
														</tr>
														<tr>
															<td class="title">意向判断</td>
															<td class="data">
																<input type="text" class="item_input input_select" style="width: 120px !important;" id="attitudename" name="attitudename" _selectid="attitude_select" 
																	value="" readonly="readonly"/>
																<input type="hidden" id="attitude" name="attitude" value=""/>
															</td>
														</tr>
														<tr>
															<td class="title">关注点</td>
															<td class="data">
																<input class="item_input" maxlength=200 name="attention" />
															</td>
														</tr>
														<%} %>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></td>
															<td class="data">
																<input class="item_input" maxlength=150 name="CEmail" onblur="mailValid()"/>
															</td>
														</tr>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(420,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></td>
															<td class="data">
																<input class="item_input" maxlength=20 name="PhoneOffice" />
															</td>
														</tr>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(619,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></td>
															<td class="data">
																<input class="item_input" maxlength=20 name="PhoneHome" />
															</td>
														</tr>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></td>
															<td class="data">
																<input class="item_input" maxlength=20 name="Mobile" />
															</td>
														</tr>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(25101,user.getLanguage())%><!-- IM号码--></td>
															<td class="data">
																<input class="item_input" maxlength=100 name="imcode" />
															</td>
														</tr>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(25102,user.getLanguage())%><!-- 状态 --></td>
															<td class="data">
																<select name="status">
													          		<option value="1"><%=SystemEnv.getHtmlLabelName(2246,user.getLanguage())%><!-- 有效 --></option>
													          		<option value="0"><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%><!-- 离职 --></option>
													          		<option value="2"><%=SystemEnv.getHtmlLabelName(463,user.getLanguage())%><!-- 未知 --></option>
													          	</select>
															</td>
														</tr>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(25103,user.getLanguage())%><!-- 是否需要联系 --></td>
															<td class="data">
																<select name="isneedcontact">
													          		<option value="1"><%=SystemEnv.getHtmlLabelName(25104,user.getLanguage())%><!-- 是 --></option>
													          		<option value="0"><%=SystemEnv.getHtmlLabelName(25105,user.getLanguage())%><!-- 否 --></option>
													          	</select>
															</td>
														</tr>
														<%if(!isperson){ %>
														<tr>
															<td class="title">是否人脉</td>
															<td class="data">
																<select name="isperson">
													          		<option value="0"><%=SystemEnv.getHtmlLabelName(25105,user.getLanguage())%><!-- 否 --></option>
													          		<option value="1"><%=SystemEnv.getHtmlLabelName(25104,user.getLanguage())%><!-- 是 --></option>
													          	</select>
															</td>
														</tr>
														<%} %>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(15707,user.getLanguage())%></td>
															<td class="data">
																<input class=inputstyle maxLength=20 type="file" STYLE="width:95%" name="photoid" />
															</td>
														</tr>
													</table>
												</td>
												<!-- 联系人结束 -->
												<!-- 帐务及其他开始 -->
												<td valign="top">
													<div class="item_title item_title1"><%=SystemEnv.getHtmlLabelName(15125,user.getLanguage())%></div>
													<div class="item_line item_line1"></div>
													<table class="item_table" cellpadding="0" cellspacing="0" border="0">
														<colgroup><col width="125px"/><col width="*"/></colgroup>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(6097,user.getLanguage())%></td>
															<td class="data">
																<input class="item_input" style="width: 200px;" maxlength=11 name="CreditAmount" onchange="checkdecimal_length('CreditAmount',8);checkinput('CreditAmount','CreditAmountimage');"
																	 onkeypress="ItemNum_KeyPress()" onblur="checknumber('CreditAmount')" value="<%=CreditAmount%>"/>
																<span id="CreditAmountimage"></span>
															</td>
														</tr>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(6098,user.getLanguage())%></td>
															<td class="data">
																<input class="item_input" style="width: 200px;" maxlength=3 name="CreditTime" onchange="checkinput('CreditTime','CreditTimeimage')" 
																	onkeypress="ItemCount_KeyPress()" onblur="checknumber('CreditTime')" value="<%=CreditTime%>"/>
																<span id="CreditTimeimage"></span>
															</td>
														</tr>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(17084,user.getLanguage())%></td>
															<td class="data">
																<input class="item_input" style="width: 200px;" maxlength=200 name="bankname" />
															</td>
														</tr>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(571,user.getLanguage())%></td>
															<td class="data">
																<input class="item_input" style="width: 200px;" maxlength=50 name="accountname" />
															</td>
														</tr>
														<tr>
															<td class="title"><%=SystemEnv.getHtmlLabelName(17085,user.getLanguage())%></td>
															<td class="data">
																<input class="item_input" style="width: 200px;" maxlength=200 name="accounts" onkeypress="ItemCount_KeyPress()"/>
															</td>
														</tr>
													</table>
													<div class="item_title item_title1"><%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%></div>
													<div class="item_line item_line1"></div>
													<table class="item_table" cellpadding="0" cellspacing="0" border="0">
														<colgroup><col width="125px"/><col width="*"/></colgroup>
														<%
															boolean hasFF = true;
															rs2.executeProc("Base_FreeField_Select","c1");
															if(rs2.next()){
																for(int i=1;i<=5;i++)
																{
																	if(rs2.getString(i*2+1).equals("1")){%>
																	<tr>
																		<td class="title"><%=Util.toScreen(rs2.getString(i*2),user.getLanguage())%></td>
																		<td class="data">
																			<button type="button" class=Calendar onclick="getCrmDate(<%=i%>)"></button> 
																        	<span id="datespan<%=i%>"></span> 
																            <input type="hidden" name="dff0<%=i%>" id="dff0<%=i%>" />
																		</td>
																	</tr>
																	<%}
																}
																for(int i=1;i<=5;i++)
																{
																	if(rs2.getString(i*2+11).equals("1")){%>
															        <tr>
																		<td class="title"><%=Util.toScreen(rs2.getString(i*2+10),user.getLanguage())%></td>
																		<td class="data">
																			<input type="text" class="item_input" id="nff0<%=i%>" name="nff0<%=i%>" onkeypress="ItemNum_KeyPress()" onblur='checknumber("nff0<%=i%>")' value="0.0" maxlength="30" />
																		</td>
																	</tr>
																	<%}
																}
																for(int i=1;i<=5;i++)
																{
																	if(rs2.getString(i*2+21).equals("1")){%>
																	<tr>
																		<td class="title"><%=Util.toScreen(rs2.getString(i*2+20),user.getLanguage())%></td>
																		<td class="data">
																			<input type="text" class="item_input" id="tff0<%=i%>" name="tff0<%=i%>" value="" maxlength="100"/>
																		</td>
																	</tr>
																	<%}
																}
																for(int i=1;i<=5;i++)
																{
																	if(rs2.getString(i*2+31).equals("1")){%>
																	<tr>
																		<td class="title"><%=Util.toScreen(rs2.getString(i*2+30),user.getLanguage())%></td>
																		<td class="data">
																			<input type=checkbox name="bff0<%=i%>" value="1" />
																		</td>
																	</tr>
																	<%}
																}
															} 
														%>
													</table>
												</td>
												<!-- 帐务及其他结束 -->
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</div>
					</div>
				</td>
			</tr>
			<tr style="height: 10px;"><td style="height: 10px;font-size: 0px;">&nbsp;</td></tr>
		</table>
		<div id="language_select" class="item_select" _inputid="language">
			<% 
				while(LanguageComInfo.next()){
			%>
			<div class="item_option" _val="<%=LanguageComInfo.getLanguageid() %>"><%=LanguageComInfo.getLanguagename() %></div>
			<%	} %>
		</div>
		<div id="status_select" class="item_select" _inputid="status" style="">
			<% 
				CustomerStatusComInfo.setTofirstRow();
				while(CustomerStatusComInfo.next()){
			%>
			<div class="item_option" _val="<%=CustomerStatusComInfo.getCustomerStatusid() %>" title="<%=CustomerStatusComInfo.getCustomerStatusdesc() %>"><%=CustomerStatusComInfo.getCustomerStatusname() %></div>
			<%	} %>
		</div>
		<div id="type_select" class="item_select" _inputid="type" style="width:160px;height: 300px;overflow-x: hidden;overflow-y: auto;">
			<% 
				CustomerTypeComInfo.setTofirstRow();
				while(CustomerTypeComInfo.next()){
			%>
			<div class="item_option" _val="<%=CustomerTypeComInfo.getCustomerTypeid() %>"><%=CustomerTypeComInfo.getCustomerTypename() %></div>
			<%	} %>
		</div>
		<div id="desc_select" class="item_select" _inputid="description">
			<% 
				CustomerDescComInfo.setTofirstRow();
				while(CustomerDescComInfo.next()){
			%>
			<div class="item_option" _val="<%=CustomerDescComInfo.getCustomerDescid() %>"><%=CustomerDescComInfo.getCustomerDescname() %></div>
			<%	} %>
		</div>
		<div id="size_n_select" class="item_select" _inputid="size_n">
			<% 
				CustomerSizeComInfo.setTofirstRow();
				while(CustomerSizeComInfo.next()){
			%>
			<div class="item_option" _val="<%=CustomerSizeComInfo.getCustomerSizeid() %>"><%=CustomerSizeComInfo.getCustomerSizedesc() %></div>
			<%	} %>
		</div>
		<div id="source_select" class="item_select" _inputid="source" style="width:150px;height: 300px;overflow-x: hidden;overflow-y: auto;">
			<% 
				ContactWayComInfo.setTofirstRow();
				while(ContactWayComInfo.next()){
			%>
			<div class="item_option" _val="<%=ContactWayComInfo.getContactWayid() %>"><%=ContactWayComInfo.getContactWayname() %></div>
			<%	} %>
		</div>
		<div id="title_select" class="item_select" _inputid="title">
			<% 
				ContacterTitleComInfo.setTofirstRow();
				while(ContacterTitleComInfo.next()){
			%>
			<div class="item_option" _val="<%=ContacterTitleComInfo.getContacterTitleid() %>"><%=ContacterTitleComInfo.getContacterTitlename() %></div>
			<%	} %>
		</div>
		<div id="attitude_select" class="item_select" _inputid="attitude">
			<div class="item_option" _val=""></div>
			<div class="item_option" _val="支持我方">支持我方</div>
			<div class="item_option" _val="未表态">未表态</div>
			<div class="item_option" _val="未反对">未反对</div>
			<div class="item_option" _val="反对">反对</div>
		</div>
		<div id="pr_select" style="min-width: 100px;height: auto;overflow: hidden;position: absolute;display: none;background: #fff;
															border: 1px #CACACA solid;padding-left: 0px;padding-right: 0px;
															border-radius: 3px;
															-moz-border-radius: 3px;
															-webkit-border-radius: 3px;
															box-shadow: 0px 0px 3px #CACACA;
															-moz-box-shadow: 0px 0px 3px #CACACA;
															-webkit-box-shadow: 0px 0px 3px #CACACA;">
				<div id="roleitem_项目决策人" class="roletype">项目决策人</div>
				<div id="roleitem_客户高层" class="roletype">客户高层</div>
				<div id="roleitem_内部向导" class="roletype">内部向导</div>
				<div id="roleitem_技术影响人" class="roletype">技术影响人</div>
				<div id="roleitem_需求影响人" class="roletype">需求影响人</div>
				<div id="roleitem_其他" class="roletype">其他</div>
				<div style="width: 100%;text-align: center;height: 22px;line-height: 22px;">
					<a style="width: 50%;text-align: center;" href="###" onclick="updateRoleType()">确定</a>&nbsp;
					<a style="width: 50%;text-align: center;" href="###" onclick="cancelRoleType()">取消</a>
				</div>
		</div>
		</form>
		<script type="text/javascript">
			$(document).ready(function(){

				//表格行背景效果及操作按钮控制绑定
				$("table.item_table").find("td.data").bind("click mouseenter",function(){
					$(".btn_add").hide();$(".btn_browser").hide();
					$(this).addClass("td_hover").prev("td.title").addClass("td_hover");
					$(this).find(".item_input").addClass("item_input_hover");
					//$(this).find(".item_num").width(100);
					if($(this).find("input.add_input2").css("display")=="none"){
						$(this).find("div.btn_add").show();
						$(this).find("div.btn_browser").show();
					}
					$(this).find("div.btn_add2").show();
					$(this).find("div.btn_browser2").show();
					if($(this).attr("id")=="websitetd") $("#websitelink").show();
					if($(this).attr("id")=="emailtd") $("#emaillink").show();
					//$(this).find("div.upload").show();
				}).bind("mouseleave",function(){
					$(this).removeClass("td_hover").prev("td.title").removeClass("td_hover");
					$(this).find(".item_input").removeClass("item_input_hover");
					//$(this).find(".item_num").width(40);
					if($(this).find("input.add_input2").css("display")=="none"){
						$(this).find("div.btn_add").hide();
						$(this).find("div.btn_browser").hide();
					}
					$(this).find("div.btn_add2").hide();
					$(this).find("div.btn_browser2").hide();
					if($(this).attr("id")=="websitetd") $("#websitelink").hide();
					if($(this).attr("id")=="emailtd") $("#emaillink").hide();
					//$(this).find("div.upload").hide();
				});

				$(".item_input").bind("focus",function(){
					var ww = document.body.clientHeight;
					$(this).addClass("item_input_focus");
					var _selectid = getVal($(this).attr("_selectid"));
					if(_selectid!=""){
						var _top = $(this).offset().top + 26;
						var _left = $(this).offset().left;
						if((_top+$("#"+_selectid).height())>ww){
							_top = _top-26-$("#"+_selectid).height();
						}
						$("#"+_selectid).css({"top":_top,"left":_left}).show();
					}
				}).bind("blur",function(){
					$(this).removeClass("item_input_focus");
				});

				$("div.item_option").bind("mouseover",function(){
					$(this).addClass("item_option_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("item_option_hover");
				}).bind("click",function(){
					var _inputid = $(this).parent().attr("_inputid");
					var sval = $(this).attr("_val");
					
					if(_inputid=="source"){
						if(sval==1 || sval==18){
							if($("#exploiter_val").val()==""){
								$("#exploiterImage").html("<img src='/images/BacoError_wev8.gif' align=absMiddle style='margin-top:4px;'/>");
							}
						}else{
							$("#exploiterImage").html("");
						}
						if(sval==22 || sval==23 || sval==24 || sval==25 || sval==26 || sval==27){
							if($("#agent_val").val()==""){
								$("#agentImage").html("<img src='/images/BacoError_wev8.gif' align=absMiddle style='margin-top:4px;'/>");
							}
						}else{
							$("#agentImage").html("");
						}
					}
					if(_inputid=="type"){
						var oldvalue = $("#type").val();
						if(sval!=oldvalue && (sval==19 || sval==26 || oldvalue==19 || oldvalue==26)){
							if(confirm("更改为此类型客户页面会重新加载，已输入的所有信息不会保存，确认切换客户类型？")){
								window.location = "/CRM/manage/customer/CustomerAdd.jsp?type1="+sval+"&name1="+$("#name").val();
							}
							return;	
						}
					}

					$("#"+_inputid).val(sval);
					$("#"+_inputid+"name").val($(this).html());
					$("#"+_inputid+"Image").html("");
				});
				//输入添加按钮事件绑定
				$("div.btn_add").bind("click",function(){
					$(this).hide();
					$(this).nextAll("div.btn_browser").hide();
					$(this).prevAll("div.showcon").hide();
					$(this).prevAll("input.add_input").show().focus();
					$(this).prevAll("input.add_input2").show().focus();
					$(this).prevAll("div.btn_select").show();
				});
				//联想输入框事件绑定
				$("input.add_input2").bind("focus",function(){
					if($(this).attr("_init")==1){
						$(this).FuzzyQuery({
							url:"/CRM/manage/util/GetData.jsp",
							record_num:5,
							filed_name:"name",
							searchtype:$(this).attr("_searchtype"),
							divwidth: $(this).attr("_searchwidth"),
							updatename:$(this).attr("id"),
							operate:"select",
							updatetype:"str"
						});
						$(this).attr("_init",0);
					}
					foucsobj2 = this;
				}).bind("blur",function(e){
					$(this).val("");
					$(this).hide();
					$(this).nextAll("div.btn_add").show();
					$(this).nextAll("div.btn_browser").show();
					$(this).prevAll("div.showcon").show();
				});

				$("div.roletype").bind("mouseover",function(){
					$(this).addClass("roletype_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("roletype_hover");
				}).bind("click",function(){
					if($(this).hasClass("roletype_select")){
						$(this).removeClass("roletype_select");
					}else{
						$(this).addClass("roletype_select");
					}
				});

				$(document).bind("click",function(e){
					var target=$.event.fix(e).target;
					if(!$(target).hasClass("item_select")){
						$("div.item_select").hide();
						if($(target).hasClass("input_select")){
							var _selectid = $(target).attr("_selectid");
							$("#"+_selectid).show();
						}
					}
				});

			});
			//选择内容后执行
			function doSelectUpdate(fieldname,id,name){
				var addtxt = "";

				if(fieldname=="exploiter") $("#exploiterImage").html("");
				if(fieldname=="agent") $("#agentImage").html("");

				if(fieldname=="exploiter" || fieldname=="principal"){
					var addids = "";
					var ids = id.split(",");
					var names = name.split(",");
					var vals = $("#"+fieldname+"_val").val();
					for(var i=0;i<ids.length;i++){
						if((","+vals+",").indexOf(","+ids[i]+",")<0 && $.trim(ids[i])!=""){
							addids += "," + ids[i];
							addtxt += doTransName(fieldname,ids[i],names[i]);
						}
					}
					if(addids==""){
						return;
					}else{
						addids = addids.substring(1);
						if(vals!="") addids = vals+","+addids;
						$("#"+fieldname).before(addtxt);
						//$("#"+fieldname+"_val").val(vals+","+addids);
						exeUpdate(fieldname,addids);
					}
				}else{
					tempval = $("#"+fieldname).val();
					if(tempval==id) return;

					addtxt = doTransName(fieldname,id,name);
					$("#"+fieldname).prev("div.txtlink").remove();
					$("#"+fieldname).before(addtxt);

					exeUpdate(fieldname,id);
				}
			}
			//执行编辑
			function exeUpdate(fieldname,fieldvalue){
				$("#"+fieldname+"_val").val(fieldvalue);
			}
			//删除选择性内容
			function doDelItem(fieldname,fieldvalue,setid){
				$("#"+fieldname).prevAll("div.txtlink"+fieldvalue).remove();
				if(fieldname=="exploiter" || fieldname=="principal"){
					var vals = ","+$("#"+fieldname+"_val").val()+",";
					var _index = vals.indexOf(","+fieldvalue+",")
					if(_index>-1 && $.trim(fieldvalue)!=""){
						vals = vals.substring(0,_index+1)+vals.substring(_index+(fieldvalue+"").length+2);
						if(vals!="" && vals!=","){
							vals = vals.substring(1,vals.length-1);
						}else{
							vals = "";
						}
						//$("#"+fieldname+"_val").val(vals);
						exeUpdate(fieldname,vals);
					}
				}else{
					exeUpdate(fieldname,'');
				}

				var sval = $("#source").val();
				if(fieldname=="exploiter" && $("#exploiter_val").val()=="" && (sval==1 || sval==18)) $("#exploiterImage").html("<img src='/images/BacoError_wev8.gif' align=absMiddle style='margin-top:4px;'/>");
				if(fieldname=="agent" && $("#agent_val").val()=="" && (sval==22 || sval==23 || sval==24 || sval==25 || sval==26 || sval==27)) $("#agentImage").html("<img src='/images/BacoError_wev8.gif' align=absMiddle style='margin-top:4px;'/>");
			}
			//修改项目角色
			function updateRoleType(){
				var selectnames = "";
				$("div.roletype_select").each(function(){
					selectnames += "," + $(this).html();
				});
				if(selectnames!=""){
					selectnames = selectnames.substring(1);
				}

				$("#projectrole").val(selectnames);
				$("#pr_select").hide();
			}
			function cancelRoleType(){
				$("#pr_select").hide();
			}
			
			function onShowBrowser(url,fieldid,must){
				var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
				if (datas) {
				    if(datas.id!=""){
				    	$("#"+fieldid).val(datas.id);
					    $("#"+fieldid+"Span").html(datas.name);
				    }else{
				    	$("#"+fieldid).val("");
				    	if(must==1){
				    		$("#"+fieldid+"Span").html("<img src='/images/BacoError_wev8.gif' align=absMiddle style='margin-top:4px;'/>");
					    }else{
					    	$("#"+fieldid+"Span").html("");
						}
				    }
				}
			}
			function onShowBrowser2(fieldname,url){
				var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
			    if (datas) {
				    if(datas.id!=""){
				    	doSelectUpdate(fieldname,datas.id,datas.name);
					}
			    }
			}
			//显示删除按钮
			function showdel(obj){
				$(obj).find("div.btn_del").show();
				$(obj).find("div.btn_wh").hide();
			}
			//隐藏删除按钮
			function hidedel(obj){
				$(obj).find("div.btn_del").hide();
				$(obj).find("div.btn_wh").show();
			}

			function checkSubmit(obj){
				window.onbeforeunload=null;
				if(check_form(weaver,"Name,Abbrev,Address1,Language,Type,Description,Size,Source,Sector,Manager,Department,Title,FirstName,JobTitle,Email,seclevel,CreditAmount,CreditTime,City,CustomerStatus,Phone")){
					var source = $("#source").val();
					
					if(source==1 || source==18){//如果为电话开拓则开拓人员为必填
						if(check_form(weaver,"exploiterIds")){
							obj.disabled = true;
							weaver.submit();
						}
					}
					<%if(!user.getLogintype().equals("2")){%>//如果为代理商伙伴类则中介机构为必填
						else if(source==22 || source==23 || source==24 || source==25 || source==26 || source==27){
							if(check_form(weaver,"Agent")){
								obj.disabled = true;
								weaver.submit();
							}
						}
					<%}%>
					else{
						obj.disabled = true; 
						weaver.submit();
					}
				}
			}
			function protectCus(){
				if(!checkDataChange())
					event.returnValue="<%=SystemEnv.getHtmlLabelName(18675,user.getLanguage())%>";
			}
			function mailValid() {
				var emailStr = document.all("CEmail").value;
				emailStr = emailStr.replace(" ","");
				if (!checkEmail(emailStr)) {
					alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage())%>");
					document.all("CEmail").focus();
					return;
				}
			}
			function checktext(){
				if(document.all("introduction").value.length>100){
					document.all("introduction").value=document.all("introduction").value.substring(0,99);
					alert('最大长度为100');
					return;
				}
			}

			function check_form(thiswins,items)
			{
				var isconn = false;
				try {
					var xmlhttp;
				    if (window.XMLHttpRequest) {
				    	xmlhttp = new XMLHttpRequest();
				    }  
				    else if (window.ActiveXObject) {
				    	xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");  
				    }
				    var URL = "/systeminfo/CheckConn.jsp?userid=<%=user.getUID()%>&time="+new Date();
				    xmlhttp.open("GET",URL, false);
				    xmlhttp.send(null);
				    var result = xmlhttp.status;
				    if(result==200) {
					    isconn = true;
				    	var response_flag = xmlhttp.responseText;
				    	if(response_flag!='0') {
				    		var flag_msg = '';
				    		if(response_flag=='1') {
				    			var diag = new Dialog();
								diag.Width = 300;
								diag.Height = 180;
								diag.ShowCloseButton=false;
								diag.Title = "<%=SystemEnv.getHtmlLabelName(26263,user.getLanguage())%>";
								diag.URL = "/wui/theme/ecology7/page/loginSmall.jsp?username=<%=user.getLoginid()%>";
								diag.show();
						        return false;
				    		}
				    		else if(response_flag=='2') {
				    			flag_msg = '<%=SystemEnv.getHtmlLabelName(21403,user.getLanguage())%>';
				    		}
				    		if(response_flag=='3') {
				    			flag_msg = '<%=SystemEnv.getHtmlLabelName(23670,user.getLanguage())%>';
				   
				    			return false;
				    		}
				    		flag_msg += '\r\n\r\n<%=SystemEnv.getHtmlLabelName(21791,user.getLanguage())%>';
				        	return confirm(flag_msg);
				        }
				    }
				    xmlhttp = null;

				    <%if(new weaver.conn.RecordSet().getDBType().equals("oracle")){%>
				    try {
					    var lenck = true;
					    var tempfieldvlaue = document.getElementById("htmlfieldids").value;
					    while(true) {
						    var tempfield = tempfieldvlaue.substring(0, tempfieldvlaue.indexOf(","));
						    tempfieldvlaue = tempfieldvlaue.substring(tempfieldvlaue.indexOf(",")+1);
						    var fieldid = tempfield.substring(0, tempfield.indexOf(";"));
						    var fieldname = tempfield.substring(tempfield.indexOf(";")+1);
						    if(fieldname=='') break;
						    if(!checkLengthOnly(fieldid,'4000',fieldname,'<%=SystemEnv.getHtmlLabelName(524,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')) {
							    lenck = false;
							    break;
						    }
					    }
					    if(lenck==false) return false;
				    }
				    catch(e) {}
				    <%}%>
				}
				catch(e) {
					return check_conn();
				}
				if(!isconn)
					return check_conn();
				
				thiswin = thiswins
				items = ","+items + ",";
				
				var tempfieldvlaue1 = "";
				try{
					tempfieldvlaue1 = document.getElementById("htmlfieldids").value;
				}catch (e) {
				}

				for(i=1;i<=thiswin.length;i++){
					tmpname = thiswin.elements[i-1].name;
					tmpvalue = thiswin.elements[i-1].value;
				    if(tmpvalue==null){
				        continue;
				    }

					if(tmpname!="" && items.indexOf(","+tmpname+",")!=-1){
						if(tempfieldvlaue1.indexOf(tmpname+";") == -1){
							while(tmpvalue.indexOf(" ") >= 0){
								tmpvalue = tmpvalue.replace(" ", "");
							}
							while(tmpvalue.indexOf("\r\n") >= 0){
								tmpvalue = tmpvalue.replace("\r\n", "");
							}

							if(tmpvalue == ""){
								if(thiswin.elements[i-1].getAttribute("temptitle")!=null){
									alert("\""+thiswin.elements[i-1].getAttribute("temptitle")+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
									return false;
								}else{
									alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>!");
									return false;
								}
							}
						} else {
							var divttt=document.createElement("div");
							divttt.innerHTML = tmpvalue;
							var tmpvaluettt = jQuery.trim(jQuery(divttt).text());
							if(tmpvaluettt == ""){
								if(thiswin.elements[i-1].getAttribute("temptitle")!=null){
									alert("\""+thiswin.elements[i-1].getAttribute("temptitle")+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
									return false;
								}else{
									alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>!");
									return false;
								}
							}
						}
					}
				}
				return true;
			}
			function doTransName(fieldname,id,name){
				var delname = fieldname;
				if(startWith(fieldname,"_")) fieldname = fieldname.substring(1);
				var restr = "";
				restr += "<div class='txtlink ";
				if(fieldname=="manager" || fieldname=="agent" || fieldname=="parentid" || fieldname=="documentid" || fieldname=="introductionDoc"){restr += "showcon";}
				restr += " txtlink"+id+"' onmouseover='showdel(this)' onmouseout='hidedel(this)'>";
				restr += "<div style='float: left;'>";
					
				if(fieldname=="manager" || fieldname=="exploiterIds" || fieldname=="principalIds"){
					restr += "<a href='/hrm/resource/HrmResource.jsp?id="+id+"' target='_blank'>"+name+"</a>";
				}else if(fieldname=="agent"){
					restr += "<a href=javaScript:openFullWindowHaveBar('/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+id+"') >"+name+"</a>";
				}else if(fieldname=="documentid" || fieldname=="introductionDocid"){
					restr += "<a href=javaScript:openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id="+id+"') >"+name+"</a>";
				}else{
					restr += name;
				}
				restr +="</div>";
				if(fieldname!="manager" && fieldname!="city" && fieldname!="type" && fieldname!="description" && fieldname!="size_n"
					&& fieldname!="source" && fieldname!="sector"){
					restr += "<div class='btn_del' onclick=\"doDelItem('"+delname+"','"+id+"')\"></div>"
					   		+ "<div class='btn_wh'></div>";
				}
				restr += "</div>";
				return restr;
			}
		</script>
	</body>
</html>
