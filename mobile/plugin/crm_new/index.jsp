<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@ page import="weaver.hrm.User"%>
<%@page import="weaver.conn.RecordSet"%>
<%
User user = MobileUserInit.getUser(request, response);
if(user == null){
	out.println("无用户，请登录");
	return;
}

RecordSet rs = new RecordSet();
boolean cardReg = false;
rs.execute("select isopen from CRM_CardRegSettings where id=1 ");
if(rs.next()){
	cardReg = "1".equals(rs.getString("isopen"));
}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimum-scale=1.0, maximum-scale=1.0">
<title>客户</title>
<link rel="stylesheet" href="/mobile/plugin/crm_new/css/mobilebone.min.css">
<link rel="stylesheet" href="/mobile/plugin/crm_new/css/crm.css">
<link rel="stylesheet" type="text/css" href="/mobile/plugin/crm_new/css/datedropper.css">
<link rel="stylesheet" type="text/css" href="/mobile/plugin/crm_new/css/mobile_homepagewrap_wev8.css">
<script type="text/javascript">var E3005CF26D9F9AC78773E16572827297 = "<%=user.getUID()%>";</script>
<script src="/mobile/plugin/crm_new/js/position_wev8.js"></script>
</head>
<body>

<div id="crm_main" class="page out" data-onpagefirstinto="buildCrmListPage">
	<div class="common_msg">操作成功</div>
	<div id="crm_container" class="content">
		<div id="crm_list" class="in panel" data-title="客户" data-callback="panelChange" data-form="show_hide">
			<div class="header" data-role="header">
				<div class="tab">
					<ul>
						<li data-filter="&opt=my" data-tabId="a">我的客户</li>
						<li data-tabId="b">全部</li>
						<li data-filter="&opt=attention" data-tabId="c">关注</li>
						<li class="more around" data-tabId="d">附近</li>
					</ul>
				</div>
				<div class="right addBtn"></div>
			</div>
			<div class="pop_menu">
			</div>
			<div class="dialogCoverContainer" style="display: none;position: absolute;">
				<div class="dialogCoverMark show"></div>
				<div class="dialogCoverWrap">
					<ul class="dialogCover">
						<a href="/mobile/plugin/crm_new/customerAddExist.jsp" data-reload="true">
							<li id="menu_a" class="menuLi" data-id="a" data-value="" style="border-bottom: 1px solid rgb(228, 228, 228);">
								<div class="menuText" >
									普通新建
								</div>
								<img src="/mobile/plugin/crm_new/images/bar/3b.gif" class="menuIcon">
							</li>
						</a>
						<%if(cardReg){ %>
						<a href="/mobile/plugin/crm_new/card.jsp?refresh=refresh" data-reload="true">
							<li id="menu_b" class="menuLi" data-id="b" data-value="">
								<div class="menuText">
									名片识别
								</div>
								<img src="/mobile/plugin/crm_new/images/bar/1b.gif" class="menuIcon">
							</li>
						</a>
						<%} %>
					</ul>
					<ul class="dialogCover_cancel">
						<li class="cancel">
							取消
						</li>
					</ul>
				</div>
			</div>
			<div class="content">
				<div class="listSearch">
					<form disabledEnterSubmit action="">
					<img src="/mobile/plugin/crm_new/images/searchright_wev8.gif" class="btn"/>
					<input type="search" placeholder="Search..."/>
					<a href="#crm_search" class="as_btn"><div class="line one"></div><div class="line two"></div><div class="line three"></div></a>
					</form>
				</div>
				<div class="listRefresh scroll_loading"><span class="pullDownIcon"></span><span class="pullDownLabel">正在加载数据...</span></div>
				<div class="listContent">
					<div class="scroll_scroller">
						<div class="pullDown">
							<span class="pullDownIcon"></span><span class="pullDownLabel">下拉可以刷新</span>
						</div>
						<ul class="list"></ul>
						<div class="crm_loading"><div class="spinner"><div class="bounce1"></div><div class="bounce2"></div><div class="bounce3"></div></div></div>
						<div class="no_data">没有数据显示</div>
						<div class="load_more">加载更多</div>
					</div>
				</div>
			</div>
		</div>
		<div id="crm_business" class="out panel" data-title="商机"  data-onpagefirstinto="buildCrmListPage" data-callback="panelChange" data-form="show_hide">
			<div class="header" data-role="header">
				<div class="tab">
					<ul>
						<li data-filter="&opt=my" data-tabId="a">我的商机</li>
						<li data-tabId="b">全部</li>
						<li data-filter="&opt=attention" data-tabId="c">关注</li>
						<li data-filter="&opt=expire" data-tabId="d">到期提醒</li>
					</ul>
				</div>
				<div class="right addBtn"><a href="/mobile/plugin/crm_new/crmSellChanceAdd.jsp" style="display: block;height:45px;" data-reload="true"></a></div>
			</div>
			<div class="content">
				<div class="listSearch">
					<form disabledEnterSubmit action="">
					<img src="/mobile/plugin/crm_new/images/searchright_wev8.gif" class="btn"/>
					<input type="search" placeholder="Search..."/>
					</form>
				</div>
				<div class="listRefresh scroll_loading"><span class="pullDownIcon"></span><span class="pullDownLabel">正在加载数据...</span></div>
				<div class="listContent">
					<div class="scroll_scroller">
						<div class="pullDown">
							<span class="pullDownIcon"></span><span class="pullDownLabel">下拉可以刷新</span>
						</div>
						<ul class="list"></ul>
						<div class="crm_loading"><div class="spinner"><div class="bounce1"></div><div class="bounce2"></div><div class="bounce3"></div></div></div>
						<div class="no_data">没有数据显示</div>
						<div class="load_more">加载更多</div>
					</div>
				</div>
			</div>
		</div>
		<div id="crm_partner" class="out panel" data-title="伙伴" data-onpagefirstinto="buildCrmListPage" data-callback="panelChange" data-form="show_hide">
			<div class="header" data-role="header">
				<div class="tab">
					<ul>
						<li data-filter="&opt=my" data-tabId="a">我的伙伴</li>
						<li data-tabId="b">全部</li>
						<li data-filter="&opt=attention" data-tabId="c">关注</li>
						<li class="more around" data-tabId="d">附近</li>
					</ul>
				</div>
			</div>
			<div class="pop_menu">
				<div class="arrow"></div>
				<ul data-for="#crm_partner .tab li.around">
					<li class="pos_msg"></li>
		    	</ul>
			</div>
			<div class="content">
				<div class="listSearch">
					<form disabledEnterSubmit action="">
					<img src="/mobile/plugin/crm_new/images/searchright_wev8.gif" class="btn"/>
					<input type="search" placeholder="Search..."/>
					<a href="#crm_search" class="as_btn"><div class="line one"></div><div class="line two"></div><div class="line three"></div></a>
					</form>
				</div>
				<div class="listRefresh scroll_loading"><span class="pullDownIcon"></span><span class="pullDownLabel">正在加载数据...</span></div>
				<div class="listContent">
					<div class="scroll_scroller">
						<div class="pullDown">
							<span class="pullDownIcon"></span><span class="pullDownLabel">下拉可以刷新</span>
						</div>
						<ul class="list"></ul>
						<div class="crm_loading"><div class="spinner"><div class="bounce1"></div><div class="bounce2"></div><div class="bounce3"></div></div></div>
						<div class="no_data">没有数据显示</div>
						<div class="load_more">加载更多</div>
					</div>
				</div>
			</div>
		</div>
		<div id="crm_people" class="out panel" data-title="人脉" data-onpagefirstinto="buildCrmListPage" data-callback="panelChange" data-form="show_hide">
			<div class="header" data-role="header">
				<div class="tab">
					<ul>
						<li data-filter="&opt=my" data-tabId="a">我的人脉</li>
						<li data-tabId="b">全部</li>
						<li data-filter="&opt=attention" data-tabId="c">关注</li>
						<li class="more around" data-tabId="d">附近</li>
					</ul>
				</div>
			</div>
			<div class="pop_menu">
				<div class="arrow"></div>
				<ul data-for="#crm_people .tab li.around">
					<li class="pos_msg"></li>
		    	</ul>
			</div>
			<div class="content">
				<div class="listSearch">
					<form disabledEnterSubmit action="">
					<img src="/mobile/plugin/crm_new/images/searchright_wev8.gif" class="btn"/>
					<input type="search" placeholder="Search..."/>
					<a href="#crm_search" class="as_btn"><div class="line one"></div><div class="line two"></div><div class="line three"></div></a>
					</form>
				</div>
				<div class="listRefresh scroll_loading"><span class="pullDownIcon"></span><span class="pullDownLabel">正在加载数据...</span></div>
				<div class="listContent">
					<div class="scroll_scroller">
						<div class="pullDown">
							<span class="pullDownIcon"></span><span class="pullDownLabel">下拉可以刷新</span>
						</div>
						<ul class="list"></ul>
						<div class="crm_loading"><div class="spinner"><div class="bounce1"></div><div class="bounce2"></div><div class="bounce3"></div></div></div>
						<div class="no_data">没有数据显示</div>
						<div class="load_more">加载更多</div>
					</div>
				</div>
			</div>
		</div>
		<div id="crm_contacter" class="out panel" data-title="联系人" data-onpagefirstinto="buildCrmListPage" data-callback="panelChange" data-form="show_hide">
			<div class="header" data-role="header">
				<div class="tab">
					<ul>
						<li data-filter="&opt=my" data-tabId="c">我的联系人</li>
						<li data-filter="&opt=all" data-tabId="a">全部</li>
						<li data-filter="&opt=hadContact" data-tabId="b">最近联系</li>
						<%--<li data-filter="&opt=isMain" data-tabId="c">主联系人</li>--%>
					</ul>
				</div>
				<div class="right addBtn"><span style="display: block;height:45px;" data-reload="true"></span></div>
			</div>
			<div class="pop_menu">
				<div class="arrow"></div>
				<ul data-for="#crm_contacter .tab li.around">
					<li class="pos_msg"></li>
				</ul>
			</div>
			<div class="dialogCoverContainer" style="display: none;position: absolute;">
				<div class="dialogCoverMark show"></div>
				<div class="dialogCoverWrap">
					<ul class="dialogCover">
						<a href="/mobile/plugin/crm_new/crmContactsAddNew.jsp" data-reload="true">
							<li id="menu_a" class="menuLi" data-id="a" data-value="" style="border-bottom: 1px solid rgb(228, 228, 228);">
								<div class="menuText" >
									普通新建
								</div>
								<img src="/mobile/plugin/crm_new/images/bar/3b.gif" class="menuIcon">
							</li>
						</a>
						<%if(cardReg){ %>
						<a href="/mobile/plugin/crm_new/card.jsp?refresh=refresh" data-reload="true">
							<li id="menu_b" class="menuLi" data-id="b" data-value="">
								<div class="menuText">
									名片识别
								</div>
								<img src="/mobile/plugin/crm_new/images/bar/1b.gif" class="menuIcon" >
							</li>
						</a>
						<%} %>
					</ul>
					<ul class="dialogCover_cancel">
						<li class="cancel">
							取消
						</li>
					</ul>
				</div>
			</div>
			<div class="content">
				<div class="listSearch">
					<form disabledEnterSubmit action="">
						<img src="/mobile/plugin/crm_new/images/searchright_wev8.gif" class="btn"/>
						<input type="search" placeholder="Search..."/>
						<a href="#crm_contacter_search" class="as_btn" id="crm_link_two"><div class="line one"></div><div class="line two"></div><div class="line three"></div></a>
					</form>
				</div>
				<div class="listRefresh scroll_loading"><span class="pullDownIcon"></span><span class="pullDownLabel">正在加载数据...</span></div>
				<div class="listContent">
					<div class="scroll_scroller">
						<div class="pullDown">
							<span class="pullDownIcon"></span><span class="pullDownLabel">下拉可以刷新</span>
						</div>
						<ul class="list"></ul>
						<div class="crm_loading"><div class="spinner"><div class="bounce1"></div><div class="bounce2"></div><div class="bounce3"></div></div></div>
						<div class="no_data">没有数据显示</div>
						<div class="load_more">加载更多</div>
					</div>
				</div>
			</div>
		</div>
    </div>
	<div class="footer">
	    <nav class="tabBar">
	    	<a href="#crm_list" data-rel="auto" class="tab-item active" data-container="crm_container" data-classpage="panel" onclick="javascript:CRM.freshByTab(this);">
	    		<span class="icon icon-crm"></span>
	    		<span class="tab-label">客户</span>
	    	</a>
	    	<a href="#crm_business" data-rel="auto" class="tab-item" data-container="crm_container" data-classpage="panel" onclick="javascript:CRM.freshByTab(this);">
	    		<span class="icon icon-business"></span>
	    		<span class="tab-label">商机</span>
	    	</a>
	    	<a href="#crm_partner" data-rel="auto" class="tab-item" data-container="crm_container" data-classpage="panel" onclick="javascript:CRM.freshByTab(this);">
	    		<span class="icon icon-partner"></span> 
	    		<span class="tab-label">伙伴</span>
	    	</a>
	    	<a href="#crm_people" data-rel="auto" class="tab-item" data-container="crm_container" data-classpage="panel" onclick="javascript:CRM.freshByTab(this);">
	    		<span class="icon icon-people"></span>
	    		<span class="tab-label">人脉</span>
	    	</a>
	    	<a href="#crm_contacter" data-rel="auto" class="tab-item" data-container="crm_container" data-classpage="panel" onclick="javascript:CRM.freshByTab(this);">
				<span class="icon icon-contacter"></span>
				<span class="tab-label">联系人</span>
			</a>
	    </nav>
	</div>
</div>
<div id="crm_search" class="page out" data-title="客户查询" data-onpagefirstinto="buildCrmSearchPage" data-callback="crmSearchPageShow">
	<div class="header" data-role="header">
		<div class="left" onclick="javascript:history.go(-1);">客户查询</div>
		<div class="right">搜索</div>
	</div>
	<div class="content">
		<form disabledEnterSubmit action="">
			<div class="field" data-flag="searchKey">
				<div>标题 :</div>
				<div><input placeholder="客户名称/客户地址" type="search" data-fieldname="searchKey"></div>
			</div>
			<div class="search_my">
			<div class="field" style="border-bottom: none;" data-flag="manager">
				<div>经理 :</div>
				<div>
					<a href="/mobile/plugin/crm_new/crmManager.jsp" class="more">
						<div class="text"></div>
						<input type="hidden" data-fieldname="manager"/>
						<div class="tip">选择客户经理，不选择默认为"我"</div>
					</a>
					<div class="clear-btn"></div>
				</div>
			</div>
			<div class="field" style="padding-left: 15px;" data-flag="managerType">
				<ul class="hori_check">
					<li class="checked" data-value="my">仅本人</li><li data-value="my_under">含下属</li><li data-value="under">仅下属</li>
				</ul>
				<input type="hidden" data-fieldname="managerType" value="my"/>
			</div>
			</div>
			<div class="field" data-flag="status">
				<div>状态 :</div>
				<div>
					<a href="/mobile/plugin/crm_new/crmStatus.jsp" class="more">
						<div class="text"></div>
						<input data-fieldname="status" type="hidden"/>
						<div class="tip"></div>
					</a>
					<div class="clear-btn"></div>
				</div>
			</div>
			<div class="field" data-flag="sector">
				<div>行业 :</div>
				<div>
					<a href="/mobile/plugin/crm_new/crmSector.jsp" class="more">
						<div class="text"></div>
						<input data-fieldname="sector" type="hidden"/>
						<div class="tip"></div>
					</a>
					<div class="clear-btn"></div>
				</div>
			</div>
			<div class="field vertical" data-flag="label">
				<div>标签 :</div>
				<div>
					<ul class="hori_check" data-type="CAN_CANCEL"></ul>
					<input type="hidden" data-fieldname="label"/>
				</div>
			</div>
		</form>
	</div>
</div>
<div id="crm_contacter_search" class="page out" data-title="联系人查询" data-onpagefirstinto="buildCrmContacterSearchPage">
	<div class="header" data-role="header">
		<div class="left" onclick="javascript:history.go(-1);">联系人查询</div>
		<div class="right">搜索</div>
	</div>
	<div class="content">
		<form disabledEnterSubmit action="">
			<div class="field" data-flag="searchKey">
				<div>名称:</div>
				<div><input placeholder="名称" type="search" data-fieldname="searchKey"></div>
			</div>
			<div class="field" data-flag="mobilePhone">
				<div>手机:</div>
				<div><input placeholder="手机" type="search" data-fieldname="mobilePhone"></div>
			</div>
			<div class="field" data-flag="customerid">
				<div>客户:</div>
				<div>
					<a href="/mobile/plugin/crm_new/crmCustomer.jsp?callback=CRM.setCrmContacterSearchValue" class="more">
						<div class="text"></div>
						<input data-fieldname="customerid" type="hidden"/>
						<div class="tip"></div>
					</a>
					<div class="clear-btn"></div>
				</div>
			</div>
		</form>
	</div>
</div>
<script src="/mobile/plugin/crm_new/js/jquery.1.7.2.min.js"></script>
<script src="/mobile/plugin/crm_new/js/datedropper.min.js"></script>
<script src="/mobile/plugin/crm_new/js/mobilebone.js"></script>
<script src="/mobile/plugin/crm_new/js/fastclick.min_wev8.js"></script>
<script src="/mobile/plugin/crm_new/js/iscroll-min.js"></script>
<script src="/mobile/plugin/crm_new/js/toucher.js"></script>
<script src="/mobile/plugin/crm_new/js/toucher_util.js"></script>
<script src="/mobile/plugin/crm_new/js/crm.js"></script>
<script src="/mobile/plugin/crm_new/js/baidu/api_wev8.js"></script>
<script src="/mobile/plugin/crm_new/js/baidu/convertor_wev8.js"></script>
<!-- 增加：实现语音识别js -->
<script src="/mobile/plugin/crm_new/js/voice.js"></script>
<!-- 增加：图片上传 -->
<script src="/mobilemode/js/mpc/photo_wev8.js"></script>
<link type="text/css" rel="stylesheet" media="all" href="/mobilemode/css/mpc/photo_wev8.css"/>
</body>
</html>
