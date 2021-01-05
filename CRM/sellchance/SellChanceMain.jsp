
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@page import="weaver.cowork.CoworkItemMarkOperation"%>
<%@page import="weaver.crm.customer.CustomerLabelVO"%>
<%@page import="weaver.blog.HrmOrgTree"%>
<%@page import="weaver.crm.customer.CustomerService"%>
<%@page import="weaver.crm.sellchance.SellChanceLabelVO"%>
<%@page import="weaver.crm.sellchance.SellstatusComInfo"%>
<%@page import="weaver.crm.sellchance.SelltypesComInfo"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.crm.util.CrmFieldComInfo"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmUtil" class="weaver.crm.util.CrmUtil" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="rst" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SellstatusComInfo" class="weaver.crm.sellchance.SellstatusComInfo" scope="page" />
<jsp:useBean id="SelltypesComInfo" class="weaver.crm.sellchance.SelltypesComInfo" scope="page" />
<jsp:useBean id="SectorInfoComInfo" class="weaver.crm.Maint.SectorInfoComInfo" scope="page" />
<jsp:useBean id="SellChanceLabelService" class="weaver.crm.sellchance.SellChanceLabelService" scope="page" />
<jsp:useBean id="CustomerStatusCount" class="weaver.crm.CustomerStatusCount" scope="page" />
<jsp:useBean id="CustomerService" class="weaver.crm.customer.CustomerService" scope="page" />
<jsp:useBean id="SellsuccessComInfo" class="weaver.crm.sellchance.SellsuccessComInfo" scope="page" />
<jsp:useBean id="SellfailureComInfo" class="weaver.crm.sellchance.SellfailureComInfo" scope="page" />
<%

	String userid=user.getUID()+"";
	//标签id
	String labelid=Util.null2String(request.getParameter("labelid"));
	
	String name="";
	HrmOrgTree hrmOrg=new HrmOrgTree(request,response);
%>
<head>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<link type="text/css" href="/CRM/css/Base1_wev8.css" rel=stylesheet>
<SCRIPT language="javascript" src="/CRM/js/customerUtil_wev8.js"></script>

<link type='text/css' rel='stylesheet'  href='/CRM/js/tree/js/treeviewAsync/eui.tree_wev8.css'/>
<link type='text/css' rel='stylesheet'  href='/CRM/css/tree_wev8.css'/>
<script language='javascript' type='text/javascript' src='/CRM/js/tree/js/treeviewAsync/jquery.treeview_wev8.js'></script>
<script language='javascript' type='text/javascript' src='/CRM/js/tree/js/treeviewAsync/jquery.treeview.async_wev8.js'></script>

<link type="text/css" href="/CRM/css/Base_wev8.css" rel=stylesheet>


<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
</head>
<style>
.scroll1{overflow-y: auto;overflow-x: hidden;
				SCROLLBAR-DARKSHADOW-COLOR: #ffffff;
			  	SCROLLBAR-ARROW-COLOR: #EAEAEA;
			  	SCROLLBAR-3DLIGHT-COLOR: #EAEAEA;
			  	SCROLLBAR-SHADOW-COLOR: #E0E0E0 ;
			  	SCROLLBAR-HIGHLIGHT-COLOR: #ffffff;
			  	SCROLLBAR-FACE-COLOR: #ffffff;
}
::-webkit-scrollbar-track-piece{
	background-color:#E2E2E2;
	-webkit-border-radius:0;
}
::-webkit-scrollbar{
	width:12px;
	height:8px;
}
::-webkit-scrollbar-thumb{
	height:50px;
	background-color:#CDCDCD;
	-webkit-border-radius:1px;
	outline:0px solid #fff;
	outline-offset:-2px;
	border: 0px solid #fff;
}
::-webkit-scrollbar-thumb:hover{
	height:50px;
	background-color:#BEBEBE;
	-webkit-border-radius:1px;
}
.treeview .hitarea{
	background:url('/CRM/images/icon_arrow2_wev8.png') no-repeat center center;
	height:26px;
}
.treeview .collapsable-hitarea{
	background:url('/CRM/images/icon_arrow1_wev8.png') no-repeat center center;
}
.treeview li{background:none}
span.person{padding:1px 0px 1px 0px;background:none}
.hrmOrg span.person{padding:1px 0px 1px 0px;background:none}
.hrmOrg a{color:#000}
.labelName{color: white;padding-left:5px;padding-right:5px;line-height: 22px;};
.topImgMenu{background:none;border:none !important;}
.btn_prev {
	width: 20px;
	height: 20px;
	background: url('../images/btn_page_wev8.png') no-repeat 0px 0px;
	float: left;
}

.btn_prev_hover {
	background: url('../images/btn_page_wev8.png') no-repeat -25px 0px;
}

.btn_next {
	width: 20px;
	height: 20px;
	background: url('../images/btn_page_wev8.png') no-repeat 0px -25px;
	float: left;
}

.btn_next_hover {
	background: url('../images/btn_page_wev8.png') no-repeat -25px -25px;
}
.cond_year {
	width: 100%;
	background: #fff;
}

.cond_year td {
	background: #FBFBFF;
	line-height: 20px;
	cursor: pointer;
}
.cond_month {
	width: 100%;
	background: #fff;
}

.cond_month td {
	background: #FBFBFF;
	line-height: 20px;
	cursor: pointer;
}

</style>

<%
	int isgoveproj = Util.getIntValue(IsGovProj.getPath(), 0);//0:非政务系统，1：政务系统
	String imagefilename = "/images/hdDOC_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(648, user.getLanguage());
	String needfav = "1";
	String needhelp = "";
	
	int currentMonth=Calendar.getInstance().get(Calendar.MONTH)+1;
	
	int count = CustomerStatusCount.getContactNumber(user.getUID()+"");
	int birthdayCount=CustomerService.getBirthdayCount(userid,currentMonth);
%>
	<BODY style="overflow: hidden;">
	
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<form id="mainForm" action="/cowork/CoworkList.jsp" method="post" target="listFrame">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
						<span style="width:30px;">
							<button title="<%=SystemEnv.getHtmlLabelNames("82,32922", user.getLanguage())%>" type=button class="btn_top" style="background:url('/CRM/images/icon_add_wev8.png') no-repeat left;" _type="add"  onclick="openFullWindowHaveBar('/CRM/sellchance/AddSellChance.jsp?tabtype=add&target=fullwindow')">
							 	<div class="btndiv"></div>
							 	<div style="clear:both;"></div>
							</button>
						</span>
						
						<span style="width:30px;">
							<button title="<%=SystemEnv.getHtmlLabelName(6061, user.getLanguage())%>" type=button class="btn_top" style="background:url('/CRM/images/icon_remind_wev8.png') no-repeat left;" _type="remind"  onclick="openFullWindowHaveBar('/CRM/report/ContactFrame.jsp?tabtype=remind')">
							 	<div class="btndiv"></div>
							 	<%if(count>0){%>
							 		<div style="float:left;">(<%=count%>)</div>
							 	<%}%>
							 	<div style="clear:both;"></div>
							</button>
						</span>
						
						<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
			<td></td>
		</tr>
	</table>
			
	</form>		
	
	<div style="position: relative;height:100%;width:100%" id="maindiv">
	 	<div id="leftdiv" class="northDiv left" style="border-right:1px solid #BDBDBD;height:100%;width:576px;">
	 		<div id="listoperate">
	 			<div id="checkType"  class="main_btn menuitem1" style="width:20px;margin-right:5px;" >
					<div class="menuitem1-l">
						<!--<span id="checkBox"><input id="chkALL" type="checkbox" onclick="setCheckState(this)"/></span>-->
					</div>
				</div>
				<%
				boolean isShowResource=labelid.equals("my")&&hrmOrg.isHavaHrmChildren(userid);
				%>
				<div id="creater_str" _value=""  class="main_btn menuitem1" style="text-align:left;width:60px;<%=isShowResource?"":"display:none"%>" onclick="showMenu(this,'resourceMenu',event)">
					<div class="menuitem1-l menuName" style="white-space:nowrap;width:40px;overflow:hidden;text-overflow:ellipsis;">
						<%=ResourceComInfo.getLastname(userid)%>
					</div>	
					<div class="marrow"></div>
					<div class="seprator"></div>
				</div>
				
				<div id="sellstatusid_str" _value="" class="main_btn menuitem1" style="width:65px;margin-right: 3px;" onclick="showMenu(this,'statusMenu',event)">
					<div class="menuitem1-l menuName" style="white-space:nowrap;width:50px;overflow:hidden;text-overflow:ellipsis;">
						<%=SystemEnv.getHtmlLabelName(82536,user.getLanguage())%><!-- 销售状态 -->
					</div>	
					<div class="marrow"></div>
					<div class="seprator"></div>
				</div>
				
				<div id="predate_str" _value="" class="main_btn menuitem1" style="width:65px;margin-right: 3px;" onclick="showMenu(this,'predateMenu',event)">
					<div class="menuitem1-l menuName" style="white-space:nowrap;width:50px;overflow:hidden;text-overflow:ellipsis;">
						<%=SystemEnv.getHtmlLabelName(2247,user.getLanguage())%><!-- 销售预期 -->
					</div>	
					<div class="marrow"></div>
					<div class="seprator"></div>
				</div>
				
				<div id="preyield_str" _value="" class="main_btn menuitem1" style="width:65px;margin-right: 3px;" onclick="showMenu(this,'preyieldMenu',event)">
					<div class="menuitem1-l menuName" style="white-space:nowrap;width:50px;overflow:hidden;text-overflow:ellipsis;">
						<%=SystemEnv.getHtmlLabelName(2248,user.getLanguage())%><!-- 预期收益 -->
					</div>	
					<div class="marrow"></div>
					<div class="seprator"></div>
				</div>
				
				
				<div id="probability_str" _value="" class="main_btn menuitem1" style="width:65px;margin-right: 3px;" onclick="showMenu(this,'probabilityMenu',event)">
					<div class="menuitem1-l menuName" style="white-space:nowrap;width:50px;overflow:hidden;text-overflow:ellipsis;">
						<%=SystemEnv.getHtmlLabelName(2249,user.getLanguage())%><!-- 可能性 -->
					</div>	
					<div class="marrow"></div>
					<div class="seprator"></div>
				</div>
				
				<div id="contactTime_str" _value="" class="main_btn menuitem1" style="width:65px;margin-right: 3px;" onclick="showMenu(this,'contactTimeMenu',event)">
					<div class="menuitem1-l menuName" style="white-space:nowrap;width:50px;overflow:hidden;text-overflow:ellipsis;">
						<%=SystemEnv.getHtmlLabelName(1275,user.getLanguage())%><!-- 联系时间 -->
					</div>	
					<div class="marrow"></div>
					<div class="seprator"></div>
				</div>
				
				<div id="markType"  class="main_btn menuitem1" style="width:60px;margin-right: 3px;" onclick="showMenu(this,'markTypeMenu',event)">
					<div class="menuitem1-l">
						<span id="sortTypeName"><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%></span>
					</div>	
					<div class="marrow"></div>
				</div>
				
				<div id="operation"  class="main_btn menuitem1" style="width:145px;float: right;">
					<span id="searchblockspan">
						<span class="searchInputSpan" id="searchInputSpan" style="position:relative;top:5px;">
							<input type="text" class="searchInput middle" name="flowTitle" value="" style="vertical-align: top;">
							<span class="middle searchImg" onclick="searchSellchanceName()">
								<img class="middle" style="vertical-align:top;margin-top:2px;" src="/images/ecology8/request/search-input_wev8.png">
							</span>
						</span>
					</span>
					<span id="advancedSearch" class="advancedSearch middle" style="height: 20px !important;vertical-align: middle;"><span><%=SystemEnv.getHtmlLabelName(84381,user.getLanguage()) %></span></span>
				</div>
				
				<div id="resourceMenu" class="drop_list" style="width:120px;overflow: auto;">
				    <div onclick="stopBubble(event)" class="btn_add_label" id="subOrgDiv">
				    	<div class="mine" onclick="showSubTree(this)">
				    		<a href="javascript:doClick(<%=userid%>,4,this,'<%=ResourceComInfo.getLastname(userid)%>')"><%=ResourceComInfo.getLastname(userid)%></a>
				    		<span style="float: right;" id="containsSub" _value="0"><img src="/CRM/images/icon_contain_wev8.png"></span>
				    	</div>
				    </div>
				</div>
				
				<!-- 商机状态 -->
				<div id="statusMenu" class="drop_list" style="width:120px;overflow: auto;">
					<div class="btn_add_type" onclick="doChange(this,'sellstatusid_str','')"><%=SystemEnv.getHtmlLabelNames("332,602",user.getLanguage()) %></div>
					<% 
						SellstatusComInfo.setTofirstRow();
						while(SellstatusComInfo.next()){
					%>
						<div class="btn_add_type" onclick="doChange(this,'sellstatusid_str',<%=SellstatusComInfo.getSellStatusid()%>)"><%=SellstatusComInfo.getSellStatusname() %></div>
					<%}%>	
				</div>
				
				<!-- 销售预期 -->
				<div id="predateMenu" class="drop_list" style="width:120px;overflow: auto;height: 140px;">
					<div id="changecond2" class="div_cond" style="width: 120px;">
                        <table class="cond_year" cellpadding="0" cellspacing="1" border="0">
                            <tr>
                                <td align="center">
                                    <div class="btn_prev" onclick="prevYear()"></div>
                                    <div id="year" style="float: left;width: 78px;line-height: 20px;cursor: default"><%=Calendar.getInstance().get(Calendar.YEAR)%></div>
                                    <div class="btn_next" onclick="nextYear()"></div>
                                </td>
                            </tr>
                        </table>
                        <table class="cond_month" cellpadding="0" cellspacing="1" border="0">
                            <tr>
                            	<td><a href="javascript:doChange(this,'predate_str','01')">01</a></td>
                            	<td><a href="javascript:doChange(this,'predate_str','02')">02</a></td>
                            	<td><a href="javascript:doChange(this,'predate_str','03')">03</a></td>
                            </tr>
                            <tr>
                            	<td><a href="javascript:doChange(this,'predate_str','04')">04</a></td>
                            	<td><a href="javascript:doChange(this,'predate_str','05')">05</a></td>
                            	<td><a href="javascript:doChange(this,'predate_str','06')">06</a></td>
                            </tr>
                            <tr>
                            	<td><a href="javascript:doChange(this,'predate_str','07')">07</a></td>
                            	<td><a href="javascript:doChange(this,'predate_str','08')">08</a></td>
                            	<td><a href="javascript:doChange(this,'predate_str','09')">09</a></td>
                            </tr>
                            <tr>
                            	<td><a href="javascript:doChange(this,'predate_str','10')">10</a></td>
                            	<td><a href="javascript:doChange(this,'predate_str','11')">11</a></td>
                            	<td><a href="javascript:doChange(this,'predate_str','12')">12</a></td>
                            </tr>
                        </table>
                        <table id="changecond2allsel" style="width: 100%;background: #ECECFF;" cellpadding="0" cellspacing="1" border="0">
                            <tr><td>
                            	<div id="clearym" style="width: 100%;height: 28px;text-align: center;cursor: pointer;background: #fff;color: #6D6D6D; "
                            		onclick="doChange(this,'predate_str','')">
                            		<%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %>
                            	</div>
                            </td></tr>
                        </table>
                    </div>
				</div>
				
				<!-- 预期收益 -->
				<div id="preyieldMenu" class="drop_list" style="width:120px;overflow: auto;">
					<div class="btn_add_type" onclick="doChange(this,'preyield_str','')"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %></div>
					<div class="btn_add_type" onclick="doChange(this,'preyield_str','0')">0-5<%=SystemEnv.getHtmlLabelName(84393,user.getLanguage()) %></div>
					<div class="btn_add_type" onclick="doChange(this,'preyield_str','1')">5-10<%=SystemEnv.getHtmlLabelName(84393,user.getLanguage()) %></div>
					<div class="btn_add_type" onclick="doChange(this,'preyield_str','2')">10-20<%=SystemEnv.getHtmlLabelName(84393,user.getLanguage()) %></div>
					<div class="btn_add_type" onclick="doChange(this,'preyield_str','3')">20-50<%=SystemEnv.getHtmlLabelName(84393,user.getLanguage()) %></div>
					<div class="btn_add_type" onclick="doChange(this,'preyield_str','4')">50-100<%=SystemEnv.getHtmlLabelName(84393,user.getLanguage()) %></div>
					<div class="btn_add_type" onclick="doChange(this,'preyield_str','5')">100<%=SystemEnv.getHtmlLabelNames("84393,32886",user.getLanguage()) %>以上</div>
				</div>				
				
				<!-- 可能性 -->
				<div id="probabilityMenu" class="drop_list" style="width:120px;overflow: auto;">
					<div class="btn_add_type" onclick="doChange(this,'probability_str','')"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %></div>
					<div class="btn_add_type" onclick="doChange(this,'probability_str','0')">0-30%</div>
					<div class="btn_add_type" onclick="doChange(this,'probability_str','1')">30%-50%</div>
					<div class="btn_add_type" onclick="doChange(this,'probability_str','2')">50%-70%</div>
					<div class="btn_add_type" onclick="doChange(this,'probability_str','3')">70%-90%</div>
					<div class="btn_add_type" onclick="doChange(this,'probability_str','4')">90%<%=SystemEnv.getHtmlLabelName(32886,user.getLanguage()) %></div>
				</div>				
				
				
				<!-- 联系时间 -->
				<div id="contactTimeMenu" class="drop_list" style="width:120px;overflow: auto;">
					<div class="btn_add_type" onclick="doChange(this,'contactTime_str','')"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %></div>
					<div class="btn_add_type" onclick="doChange(this,'contactTime_str','0')"><%=SystemEnv.getHtmlLabelNames("84388,84384",user.getLanguage()) %></div>
					<div class="btn_add_type" onclick="doChange(this,'contactTime_str','1')"><%=SystemEnv.getHtmlLabelNames("84385,84384",user.getLanguage()) %></div>
					<div class="btn_add_type" onclick="doChange(this,'contactTime_str','2')"><%=SystemEnv.getHtmlLabelNames("84387,84384",user.getLanguage()) %></div>
					<div class="btn_add_type" onclick="doChange(this,'contactTime_str','3')"><%=SystemEnv.getHtmlLabelNames("84389,84384",user.getLanguage()) %></div>
					<div class="btn_add_type" onclick="doChange(this,'contactTime_str','4')"><%=SystemEnv.getHtmlLabelNames("84390,84384",user.getLanguage()) %></div>
					<div class="btn_add_type" onclick="doChange(this,'contactTime_str','5')"><%=SystemEnv.getHtmlLabelNames("20729,84384",user.getLanguage()) %></div>
					<div class="btn_add_type" onclick="doChange(this,'contactTime_str','6')"><%=SystemEnv.getHtmlLabelNames("25201,84384",user.getLanguage()) %></div>
					<div class="btn_add_type" onclick="doChange(this,'contactTime_str','11')"><%=SystemEnv.getHtmlLabelNames("84280",user.getLanguage()) %></div>
					<div class="line-1"><div></div></div>
					<div class="btn_add_type" onclick="doChange(this,'contactTime_str','7')"><%=SystemEnv.getHtmlLabelNames("15537,621",user.getLanguage()) %></div>
					<div class="btn_add_type" onclick="doChange(this,'contactTime_str','8')"><%=SystemEnv.getHtmlLabelNames("84391,621",user.getLanguage()) %></div>
					<div class="btn_add_type" onclick="doChange(this,'contactTime_str','9')"><%=SystemEnv.getHtmlLabelNames("83223,621",user.getLanguage()) %></div>
					<div class="btn_add_type" onclick="doChange(this,'contactTime_str','10')"><%=SystemEnv.getHtmlLabelNames("83224,621",user.getLanguage()) %></div>
				</div>	
				
				
				<div id="markTypeMenu" class="drop_list" style="width:120px;">
					    <div class="btn_add_type" onclick="markAsImportant(this)" _important="0"><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage()) %></div><!-- 全部 -->
					    <div class="btn_add_type" onclick="markAsImportant(this)" _important="1"><%=SystemEnv.getHtmlLabelName(25422,user.getLanguage()) %></div><!-- 任务 -->
					    <div class="line-1"><div></div></div>
					    <%
					    List labelList=SellChanceLabelService.getLabelList(userid+"","all");          //标签列表
					    for(int i=0;i<labelList.size();i++){
					    	SellChanceLabelVO labelVO=(SellChanceLabelVO)labelList.get(i);
					    	String labelId=labelVO.getId();
					    	String labelName=labelVO.getName();
					    	String labelColor =labelVO.getLabelColor();
					    %>
					    <div onclick="stopBubble(event)" class="btn_add_label" _markType="label" _labelid="<%=labelId%>">
					    	<input type="checkbox" value="<%=labelId%>" name="labelcheck"/>
					    	<span  class="labelName" style="background-color:<%=labelColor%>;"><%=labelName%></span>
					    </div>
					    <%}%>
					    <div class="btn_add_label">
					    	<div style="float: left;" onclick="applyLabels()"><%=SystemEnv.getHtmlLabelName(25432,user.getLanguage()) %></div>
					    	<div style="float: left;padding-left: 17px;" onclick="cancelLabels()"><%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %></div>
					    	<div style="float: right;" onclick="labelManage()"><%=SystemEnv.getHtmlLabelName(30747,user.getLanguage()) %></div>
					    	<div style="clear: left;"></div>
					    </div>
				</div>
				
		    </div>
		    
		    <div id="highSearchDiv" name="highSearchDiv" _status="0" class="hide " style="position:fixed; top:55px;right:0px; border: 1px solid #DADADA;border-top:0px;background: #fff;z-index: 999;">
				<form name="weaver" id="weaver">
				<wea:layout type="4col">
				<%
				CrmFieldComInfo comInfo = new CrmFieldComInfo() ;
				Map map = new HashMap();
				rs.execute("select * from CRM_CustomerDefinFieldGroup where usetable = 'CRM_SellChance' order by dsporder asc");
				while(rs.next()){
					rst.execute("select count(*) from CRM_CustomerDefinField where usetable = 'CRM_SellChance' and issearch= 1 and groupid = "+rs.getString("id"));
					rst.next();
					if(rst.getInt(1)==0){
						continue;
					}
					
					
					%>
					<wea:group context='<%=SystemEnv.getHtmlLabelName(rs.getInt("grouplabel"),user.getLanguage())%>'>
						<% while(comInfo.next()){
							//没有作为搜索条件、或者是附件则跳过
							if("CRM_SellChance".equals(comInfo.getUsetable())){
							if(comInfo.getIssearch().trim().equals("") || comInfo.getIssearch().trim().equals("0") || comInfo.getFieldhtmltype() == 6){
								continue;
							}
						%>
							
							<wea:item><%=CrmUtil.getHtmlLableName(comInfo , user)%></wea:item>
							<wea:item>
								<%=CrmUtil.getHtmlElementSetting(comInfo ,Util.null2String(map.get(comInfo.getFieldname())), user , "search")%>
							</wea:item>
						<%}}%>
						
						
					</wea:group>
				<%}%>	
					
					<wea:group context='<%=SystemEnv.getHtmlLabelName(32843,user.getLanguage()) %>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
						<wea:item>
							<span style="float: left;">
								<select class=InputStyle name="includeSubCompany">
									<option value="1"><%=SystemEnv.getHtmlLabelName(18919,user.getLanguage())%></option>
									<option value="2"><%=SystemEnv.getHtmlLabelName(18920,user.getLanguage())%></option>
									<option value="3"><%=SystemEnv.getHtmlLabelName(18921,user.getLanguage())%></option>
								</select>
							</span>
							
							<span style="padding-top: 5px;">
								<brow:browser viewType="0" name="subCompanyId" 
							         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
							         browserValue="" 
							         browserSpanValue = ""
							         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
							         completeUrl="/data.jsp?type=164" width="150px" ></brow:browser>
							</span>
						</wea:item>
						
						<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
						<wea:item>
							<span style="float: left;">
								<select class=InputStyle name="includeSubDepartment">
									<option value="1"><%=SystemEnv.getHtmlLabelName(18916,user.getLanguage())%></option>
									<option value="2"><%=SystemEnv.getHtmlLabelName(18917,user.getLanguage())%></option>
									<option value="3"><%=SystemEnv.getHtmlLabelName(18918,user.getLanguage())%></option>
								</select>
							</span>
							
							<span style="padding-top: 5px;">
								<brow:browser viewType="0" name="departmentId" 
							         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
							         browserValue="" 
							         browserSpanValue = ""
							         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
							         completeUrl="/data.jsp?type=4" width="150px" ></brow:browser>
							</span>
						</wea:item>
						
						<wea:item><%=SystemEnv.getHtmlLabelName(15115,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="productId" 
							         browserUrl="/systeminfo/BrowserMain.jsp?url=/lgc/search/LgcProductBrowser.jsp"
							         browserValue="" 
							         browserSpanValue = ""
							         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
							         completeUrl="/data.jsp?type=product" width="150px" ></brow:browser>
						</wea:item>
					</wea:group>
					
					<wea:group context="" attributes="{'Display':'none'}">
						<wea:item type="toolbar">
							<input type="button" class="e8_btn_submit" onclick="submitdata()" value="<%=SystemEnv.getHtmlLabelName(197 ,user.getLanguage()) %>" id="searchBtn"/>
							<span class="e8_sep_line">|</span>
							<input type="reset" name="button" onclick="resetCondtion(highSearchDiv)" value="<%=SystemEnv.getHtmlLabelName(2022 ,user.getLanguage()) %>" class="e8_btn_cancel"/>
							<span class="e8_sep_line">|</span>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(201 ,user.getLanguage()) %>" class="e8_btn_cancel" id="cancel"/>
							</wea:item>
						</wea:group>
					</wea:layout>	
				</form>	
				</div>

		    <div id="listdiv" style="width: 100%;height: 100%;overflow:auto" class="scroll1">
		    	
				<div id="list_body">
				
				</div>
				 
				  <div id="loadingdiv1" title="<%=SystemEnv.getHtmlLabelName(81558,user.getLanguage()) %>" style="width: 100%;margin-bottom:10px;margin-top:10px;" align="center">
				         <img src='/express/task/images/loading1_wev8.gif' align="absMiddle">
				  </div>
		    </div>
	 	</div>
	 	 
	    <div id="rightdiv" class="centerDiv left" style="width:570px;overflow: hidden;height:100%">
	    	<iframe id='rightframe' src='' height=100% width="100%" border=0 frameborder="0" scrolling="auto"></iframe>
	    </div> 
	</div>    
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>		
		
		<script type="text/javascript">
			var layout="1";
			$(document).ready(function(){
				
				jQuery("#topTitle").topMenuTitle({searchFn:searchSellchanceName});
				jQuery("#hoverBtnSpan").hoverBtn();
				
				initWidth();
				initHeight();
				initData();
				
				$("#advancedSearch").bind("click",function(event){
					jQuery(this).css("line-height","21px");
					if(jQuery("#highSearchDiv").is(":visible")){
						jQuery("#highSearchDiv").hide();
						return;
					}
					hideEle("contactTd","true");
					hideEle("contacterTd","true");
					hideEle("messageTd","true");
					hideEle("sellchanceTd","true");
					
					var menuType=$(".select2").attr("_type");
					var x=$(this).offset().left
					var y=$(this).offset().top
					$("#highSearchDiv").css("top",y+25);
					$("#highSearchDiv").css("left",0);
					
					showEle(menuType+"Td","true");
					
					jQuery("#highSearchDiv").show();
					
				});
				
				$("#cancel").bind("click",function(event){
					$("#highSearchDiv").hide();
				});
				
				jQuery("#containsSub").toggle(function(){
					jQuery(this).find("img").attr("src","/CRM/images/icon_uncontain_wev8.png");
					jQuery("#containsSub").attr("_value","1");
					jQuery(":reset").click();
					reloadData();
				},function(){
					jQuery(this).find("img").attr("src","/CRM/images/icon_contain_wev8.png");
					jQuery("#containsSub").attr("_value","0");
					jQuery(":reset").click();
					reloadData();
				});
				jQuery("#dateTd").hide();
			});
			
			function onChangetype(obj){
				if(obj.value == 6){
					jQuery("#dateTd").show();
				}else{
					jQuery("#dateTd").hide();
				}
			}
			
			
			function doChange(obj,target,value){
				
				var targetObj=$("#"+target);
				var menuName="";
				if("predate_str" == target && "" != value){
					menuName = jQuery.trim(jQuery("#year").html())+"-"+value;
					value = menuName;
				}else if("predate_str" == target && "" == value){
					menuName = "<%=SystemEnv.getHtmlLabelName(2247,user.getLanguage()) %>";
					value = "";
				}else if("sellstatusid_str" == target && "" == value){
					menuName = "<%=SystemEnv.getHtmlLabelName(82536,user.getLanguage()) %>";
					value = "";
				}else if("predate_str" == target && "" == value){
					menuName = "<%=SystemEnv.getHtmlLabelName(2247,user.getLanguage()) %>";
					value = "";
				}else if("preyield_str" == target && "" == value){
					menuName = "<%=SystemEnv.getHtmlLabelName(2248,user.getLanguage()) %>";
					value = "";
				}else if("probability_str" == target && "" == value){
					menuName = "<%=SystemEnv.getHtmlLabelName(2249,user.getLanguage()) %>";
					value = "";
				}else if("contactTime_str" == target && "" == value){
					menuName = "<%=SystemEnv.getHtmlLabelName(1275,user.getLanguage()) %>";
					value = "";
				}else{
					menuName = $(obj).text();
				}
				
				targetObj.find(".menuName").html(menuName).width(50);
				targetObj.attr("_value",value);
				jQuery(":reset").click();
				reloadData();
			}
			var username = "<%=user.getLastname()%>";
			function submitdata(){
				jQuery("#creater_str").find(".menuName").html(username);
				jQuery("#creater_str").attr("_value","");
				jQuery("#containsSub").attr("_value","0");
				
				jQuery("#sellstatusid_str").find(".menuName").html("<%=SystemEnv.getHtmlLabelName(82536,user.getLanguage()) %>");
				jQuery("#sellstatusid_str").attr("_value","");
				
				jQuery("#predate_str").find(".menuName").html("<%=SystemEnv.getHtmlLabelName(2247,user.getLanguage()) %>");
				jQuery("#predate_str").attr("_value","");
				
				jQuery("#preyield_str").find(".menuName").html("<%=SystemEnv.getHtmlLabelName(2248,user.getLanguage()) %>");
				jQuery("#preyield_str").attr("_value","");
				
				jQuery("#probability_str").find(".menuName").html("<%=SystemEnv.getHtmlLabelName(2249,user.getLanguage()) %>");
				jQuery("#probability_str").attr("_value","");
				
				jQuery("#contactTime_str").find(".menuName").html("<%=SystemEnv.getHtmlLabelName(1275,user.getLanguage()) %>");
				jQuery("#contactTime_str").attr("_value","");
				
				$(".searchInput").val($("#subject").val());
				$("#highSearchDiv").hide();
				reloadData();
			}
			function searchSellchanceName(){
				jQuery(":reset").click();
				reloadData();
			}
			
			function reloadData(){
				$("#list_body").html(""); //清空列表数据
				resetScrollParam();	 //重置滚动加载参数
				getData();
			}
			
			function getData(){
			
				var params=getParams();
				$("#loadingdiv1").show();
			    $.post("/CRM/sellchance/SellChanceListNew.jsp?"+params,{pageindex:pageindex,index:index,pagesize:pagesize},function(data){
					    $("#list_body").append(data);
					    hght=0;//恢复滚动条总长，因为$("#mypage").scroll事件一触发，又会得到新值，不恢复的话可能会造成判断错误而再次加载……
					    stop=0;//原因同上。
					    flag=true;
					    jQuery('body').jNice();
					    $("#loadingdiv1").hide();
				});
			}
			
			function getParams(){
				var params = "";
				var labelid="<%=labelid%>";
				var subject =encodeURI($(".searchInput").val());
				$("#subject").val($(".searchInput").val());
				
					var creater_str=$("#creater_str").attr("_value");
					var containsSub = $("#containsSub").attr("_value");
					var sellstatusid_str=$("#sellstatusid_str").attr("_value");
					var predate_str=$("#predate_str").attr("_value");
					var preyield_str=$("#preyield_str").attr("_value");
					var probability_str=$("#probability_str").attr("_value");
					var contactTime_str=$("#contactTime_str").attr("_value");
					
					
					params =jQuery("form").serialize()+"&labelid="+labelid+"&creater_str="+creater_str+"&sellstatusid_str="+sellstatusid_str+
						"&predate_str="+predate_str+"&preyield_str="+preyield_str+"&probability_str="+probability_str+
						"&contactTime_str="+contactTime_str+"&containsSub="+containsSub+"&name="+subject;
	//			params = jQuery("form").serialize()+"&labelid="+labelid+"&subject="+subject;
				return params;
			}
			
			function viewDefault(crmIds){
				$("#rightframe").attr("src","ContactDefaultView.jsp?crmIds="+jQuery.trim(crmIds));
			}
			
			function viewDetail(sellchanceid,obj){
				$("#list").find("tr.selected").removeClass("selected");
				$(obj).parents("tr:first").addClass("selected");
				
				$("#rightframe").attr("src","ContactDetailView.jsp?sellchanceid="+sellchanceid);
			}
			
			function doClick(reaourceid,deptid,obj,name){
				var targetObj=$("#creater_str");
				targetObj.find(".menuName").html(name);
				targetObj.attr("_value",reaourceid);
				__browserNamespace__._writeBackData("creater",2,{id:reaourceid,name:name},{hasInput:true});
				$(".drop_list").hide();
				reloadData();	
			}
			
			
			function setCheckState(obj){
				$("#listdiv").find("input[name='check_node']").each(function(){
					changeCheckboxStatus(this,obj.checked);
			 	});
			}
			
			function labelManage(){
	
			    var title="<%=SystemEnv.getHtmlLabelName(30884,user.getLanguage()) %>";
				diag=getDialog(title,680,400);
				diag.URL = "/CRM/sellchance/SellchanceLabelSetting.jsp";
				diag.show();
				
				//$(diag.okButton).hide();
				
				document.body.click();
			}
			
			//应用标签
			function applyLabels(){
				
				var sellchanceids ="";
				$("#listdiv").find("input[name='chkInTableTag']:checked").each(function(){
					sellchanceids+=","+$(this).attr("checkboxid");
				});
				
				if(sellchanceids==""){
					showAlert("<%=SystemEnv.getHtmlLabelName(84392,user.getLanguage()) %>");
					return true;
				}
				sellchanceids=sellchanceids.substr(1);
				
				var labelids='';
				$("input[name=labelcheck]:checked").each(function(){
					labelids=labelids+","+$(this).val();
				});
				labelids=labelids.length>0?labelids.substr(1):labelids;
				
				jQuery.post("/CRM/sellchance/SellchanceLabelOperation.jsp", {sellchanceids:sellchanceids,type:"addLabel",labelids:labelids},function(data){
		        	
				});
			}
			
			function cancelLabels(){
				var sellchanceids ="";
				$("#listdiv").find("input[name='chkInTableTag']:checked").each(function(){
					sellchanceids+=","+$(this).attr("checkboxid");
				});
				
				if(sellchanceids==""){
					showAlert("<%=SystemEnv.getHtmlLabelName(84392,user.getLanguage()) %>");
					return true;
				}
				sellchanceids=sellchanceids.substr(1);
				
				var labelids='';
				$("input[name=labelcheck]:checked").each(function(){
					labelids=labelids+","+$(this).val();
				});
				labelids=labelids.length>0?labelids.substr(1):labelids;
				
				jQuery.post("/CRM/sellchance/SellchanceLabelOperation.jsp", {sellchanceids:sellchanceids,type:"cancelLabel",labelids:labelids},function(data){
		        	
				});
			
			}
			
			function labelManageCallback(){
				diag.close();
				window.parent.location.reload();
			}
			
			function markImportant(obj){
				var sellchanceid=$(obj).attr("_sellchanceid");
				var important=$(obj).attr("_important");
				$.post("/CRM/sellchance/SellChanceOperation.jsp?method=markimportant&sellchanceId="+sellchanceid+"&important="+important,function(){
					if(important=="1")
					   $(obj).removeClass("important").addClass("important_no").attr("_important","0");
					else
					   $(obj).removeClass("important_no").addClass("important").attr("_important","1");   
				});
			}
			
			function markAsImportant(obj){
			
				if($("#listdiv").find("input[name='chkInTableTag']:checked").length==0){
					showAlert("<%=SystemEnv.getHtmlLabelName(84392,user.getLanguage()) %>");
					return true;
				}
				var important=$(obj).attr("_important");
				
				$("#listdiv").find("input[name='chkInTableTag']:checked").each(function(){
					var sellchanceId=$(this).attr("checkboxid");
					var $this=$(this);
					$.post("/CRM/sellchance/SellChanceOperation.jsp?method=markimportant&sellchanceId="+sellchanceId+"&important="+important,function(){
						if(important=="0")
						   $this.parents("tr:first").find(".important_no").removeClass("important_no").addClass("important").attr("_important","1");
						else
						   $this.parents("tr:first").find(".important").removeClass("important").addClass("important_no").attr("_important","0");   
					});
				});
				
			}
			
			function showMenu(obj,target,e){
				$(".drop_list").hide();
				var targetHeight=$("#"+target).height();
				if(targetHeight>300)
					$("#"+target).height(300);
				$("#"+target).css({
					"left":(target=='checkTypeMenu'?0:$(obj).position().left)+"px",
					"top":($(obj).position().top+(target=='checkTypeMenu'?10:32))+"px"
				}).show();
				
				stopBubble(e);
			}
			
			
			window.onresize=function(){
				setTimeout(function(){
					initWidth(); 
					initHeight();
				},500);
			}
			
			function initWidth(){
				var mainWidth=document.body.clientWidth;
				$("#maindiv").width(mainWidth);
				var rightdivWidth=500;
				var leftdivWidth=mainWidth-rightdivWidth; 
				//$("#leftdiv").width(mainWidth*0.5);
				
				$("#leftdiv").animate({width:leftdivWidth},200,null,function(){
					$("#highSearchDiv").css("width",leftdivWidth-2);
				});
				var leftWidth=$("#leftdiv").width();
				
				$("#rightdiv").animate({width:rightdivWidth-2},200,null,function(){
				
				});
				//$("#rightdiv").width(mainWidth-leftWidth-2);
			}
			
			function initHeight(){
				var mainHeight=document.body.clientHeight;
				var operateHeight=$("#listoperate").height();
				$("#listdiv").height(mainHeight-operateHeight);
			}
			
			function initData(){
				$(document.body).bind("click",function(event){
					if(jQuery(event.target).attr("class")=='btn_prev' || jQuery(event.target).attr("class")=='btn_next'){
						return;
					}
					$(".drop_list").hide();
				})
				$(".btn_add_type").hover(function(){
					$(this).addClass("btn_add_type_hover");
				},function(){
					$(this).removeClass("btn_add_type_hover");
				});
				
				$("#searchInputSpan").hover(function(){
					$(this).addClass("searchImg_hover");
				},function(){
					$(this).removeClass("searchImg_hover");
				});
				
				$(".searchInput").bind("keypress",function(e){
					if(e.keyCode==13){
						searchSellchanceName();
					}
				});
				
				jQuery("#subOrgDiv").append('<ul id="subOrgTree" _status="1" class="hrmOrg" style="width:100%;outline:none;"></ul>');
				jQuery("#subOrgTree").treeview({
			       url:"/blog/hrmOrgTree.jsp",
			       root:"hrm|<%=user.getUID()%>"
			    });
			    
			    $(".expandable-hitarea").bind("click",function(){
			    	var subOrgDivHeight=$("#subOrgDiv").height();
			    	if(subOrgDivHeight>300)
			    		$("#resourceMenu").height(300);
			    	else
			    		$("#resourceMenu").height(subOrgDivHeight);	
			    	
			    });
			}
			
			function doMouseover(obj){
				var type=$(obj).attr("_type");
				$(obj).attr("src","/CRM/images/icon_"+type+"_h_wev8.png");
			}
			
			function doMouseout(obj){
				var type=$(obj).attr("_type");
				$(obj).attr("src","/CRM/images/icon_"+type+".png");
			}
			
			//阻止事件冒泡函数
			 function stopBubble(e)
			 {
			     if (e && e.stopPropagation){
			         e.stopPropagation()
			     }else{
			         window.event.cancelBubble=true
			     }
			}
			function doSearch(e){
				e=e?e:window.event;
				$("#mainForm").submit();
			}
			
			function reLoadList(){
				
			}
			
			function showSubTree(obj){
				
				if($('#subOrgTree').attr('_status')=='1'){
					$('#subOrgTree').hide().attr('_status','0');
					$(obj).css("background-image",'url("/CRM/images/icon_arrow2_wev8.png")');
				}else{ 
					$('#subOrgTree').show().attr('_status','1');
					$(obj).css("background-image",'url("/CRM/images/icon_arrow1_wev8.png")');
				}
			}
			
			function batchApproval(){
				$("#listFrame")[0].contentWindow.batchApproval();
			}
			
			var index=30;           //起始读取下标
			var hght=0;             //初始化滚动条总长
			var stop=0;              //初始化滚动条的当前位置
			var preTop=0;           //滚动条前一个位置，向上滚动时不加载数据
			var pagesize=50000;        //每一次读取数据记录数
			var total=0;   //记录总数
			var flag=false;         //每次请求是否完成标记，避免网速过慢协作类型无法区分 成功返回数据为true
			var timeid; //定时器
			var pageindex=1;
			$(document).ready(function(){//DOM的onload事件
			    
			    getData();
				$("#listdiv").scroll( function() {//定义滚动条位置改变时触发的事件。
				    hght=this.scrollHeight;//得到滚动条总长，赋给hght变量
				    stop=this.scrollTop;//得到滚动条当前值，赋给top变量
				});
			    
			   	//timeid=setInterval("cando();",500);
				
			});
			
			function resetScrollParam(){
				index=30;          
				hght=0;            
				stop=0;             
				preTop=0;           
				pagesize=50000;       
				total=0;  
				flag=false;         
				window.clearInterval(timeid);
				pageindex=1;
			}
			
			function cando(){ 
				if(stop>parseInt(hght/6)&&preTop<stop){//判断滚动条当前位置是否超过总长的1/3，parseInt为取整函数,向下滚动时才加载数据
				    show();
				}
			    preTop=stop;//记录上一个位置
			}
			
			function show(){
			    if(flag){
					index=index+pagesize;
					if(index>total){                    //当读取数量大于总数时
					   index=total;                     //页面数据量等于数据总数
					   window.clearInterval(timeid);    //清除定时器
					}
					flag=false;
			        pageindex++;
				    getData();
				}
			}
			
			function setTotal(totalvalue){
				total=totalvalue;
				if(total<=index)
				   window.clearInterval(timeid);    //清除定时器
			}
			function openWindow(url){
				window.open(url);
			}
			
			function prevYear(){
                $("#year").html(parseInt($("#year").html())-1);
            }
            function nextYear(){
                $("#year").html(parseInt($("#year").html())+1);
            }
			
		</script>	
		<script language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<script language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
	</body>
</html>
