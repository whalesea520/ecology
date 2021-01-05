<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.social.manager.SocialManageService"%>
<%@page import="weaver.social.im.SocialImLogin"%> 
<%@ include file="/social/im/SocialIMCommon.jsp" %>
<link rel="stylesheet" href="/social/css/base_wev8.css" type="text/css" />
<link rel="stylesheet" href="/social/css/im_wev8.css" type="text/css" />

<%
String userid=""+user.getUID();
boolean isAllowNewWin = SocialImLogin.checkAllowWindowDepart(userid);
//获取本地人员信息
String localUserInfo=SocialIMService.getLocalUserInfo(user,userid);
localUserInfo = localUserInfo.replaceAll("\n","").replaceAll("\r", "");
boolean frompc = "pc".equals(from);
//加载客户端设置
String pcClientSettings = SocialClientProp.serialize();
//检查用户发起群聊权限
JSONObject pcGroupChatSet = SocialIMService.getGroupChatSet(user);
//检查用户发起系统广播权限
JSONObject sysBroadcastSet = SocialIMService.getSysBroadcastSet(user);  
//获取考勤签到相关信息
JSONObject pcSignInfo = SocialIMService.getIMSignInfos(user);
//是否禁止考勤签到
boolean signForbit = SocialClientProp.getPropValue(SocialClientProp.FORBIT_SIGN).equals("1");
//是否禁止主次账号切换
boolean accountSwitchForbit = SocialClientProp.getPropValue(SocialClientProp.FORBIT_ACCOUNTSWITCH).equals("1");
//是否禁用群聊
boolean isGroupChatForbit = "1".equals(SocialClientProp.getPropValue(SocialClientProp.FORBIT_GROUPCHAT));
//是否禁用自定义管理
boolean customAppForbit = "1".equals(SocialClientProp.getPropValue(SocialClientProp.FORBIT_CUSTOMAPPS));
//是否禁用组织结构
boolean isGroupOrgForbit = "1".equals(SocialClientProp.getPropValue(SocialClientProp.FORBIT_ORG));
//是否禁用发送图片
boolean isImgSendCutForbit = "1".equals(SocialClientProp.getPropValue(SocialClientProp.FORBIT_PICSEND));
//是否禁用文件传输
boolean isFileTransForbit = "1".equals(SocialClientProp.getPropValue(SocialClientProp.FORBIT_FILETRANSFER));
//是否禁用流程分享
boolean isWfShareForbit = "1".equals(SocialClientProp.getPropValue(SocialClientProp.FORBIT_WFSHARE));
//是否禁用文档分享
boolean isDocShareForbit = "1".equals(SocialClientProp.getPropValue(SocialClientProp.FORBIT_DOCSHARE));
//是否禁用文件夹传输
boolean ifForbitFolderTransfer = "1".equals(SocialClientProp.getPropValue(SocialClientProp.FORBIT_FOLDERTRANSFER));
//是否禁用oa菜单
boolean isMenuItemForbit = "1".equals(SocialClientProp.getPropValue(SocialClientProp.FORBIT_MENUITEM));
//是否禁用必达
boolean isBingForbit = "1".equals(SocialClientProp.getPropValue(SocialClientProp.FORBIT_BING));
//是否禁用抖动
boolean ifForbitShake = "1".endsWith(SocialClientProp.getPropValue(SocialClientProp.FORBIT_SHAKE));
//是否禁用群文件共享
boolean isGroupFileShareForbit = "1".equals(SocialClientProp.getPropValue(SocialClientProp.FORBIT_GROUPFILESHARE));
//是否禁用密聊密聊
boolean isForbitPrivateChat = "1".equals(SocialClientProp.getPropValue(SocialClientProp.FORBIT_PRIVATECHAT));
//是否禁用客户
boolean ifForbitCustomer = "1".endsWith(SocialClientProp.getPropValue(SocialClientProp.FORBIT_CUSTOMER));

//是否开启云盘
String isOpenDisk =weaver.file.Prop.getPropValue("network2Emessage", "openDisk");
//是否开启投票
String isOpenVote =weaver.file.Prop.getPropValue("groupcharvote", "groupchatvote");
//String pcClientSettings = "";
String attachmentMaxsize="50";
//系统菜单高度
String level0 = "367", level1 = "177", level2 = "100",level3 = "60";
//websessionkey web登录的唯一标识
String websessionkey = Util.null2String(request.getParameter("websessionkey"));
%>	
<body class="imMainbg1" style="">

<style>
	.dataLoading{position:absolute;top:0px;bottom:0px;left:0px;right:0px;background: url('/express/task/images/bg_ahp_wev8.png');display: none;z-index:1000}
	.atwho-view{}
	.imMainbg{
	   background:url(/social/images/im_bg_wev8.jpg);
	   filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod='scale');
	   -moz-background-size:100% 100%;
	   background-size:100% 100%;
	}
	
	#_DialogBGMask{
		/*background-color:#fff !important;*/
	}
	<%
        if(from.equals("pc")){
        Boolean isAero = Boolean.parseBoolean(request.getParameter("isAero")); // 是否支持透明，true支持，false不支持
    %>
        
		.imMainbox{
            <% if(isAero) { %> 
			box-shadow:rgba(0, 0, 0, 0.25) 0px 0px 5px 1px;
            <% } %>
			width:auto;
			height:auto;
		}
        .imMainbox-p5 {
            <% if(isAero) { %> 
            top:5px;
            left:5px;
            bottom:5px;
            right:5px;
            <% } else { %> 
            top:0px;
            left:0px;
            bottom:0px;
            right:0px;
            <% } %> 
        }
        .imMainbox-p0 {
            top:0px;
            left:0px;
            bottom:0px;
            right:0px;
        }
		.imMainbg{background:none;}
		.leftMenudiv .chatItem .targetName{width: 142px;}
		.leftMenudiv .chatItem .itemconverright{width: 210px;}
		.leftMenudiv .chatItem .itemcenter{width:95px;}
		.leftMenudiv .chatItem .lastName, .leftMenudiv .chatItem .jobtitle{width:95px;}
		.leftMenudiv .chatItem .deptName, .leftMenudiv .chatItem .subName, .leftMenudiv .chatItem .mobile{width:95px;}
		.conTabs .conTabItem{width:<%=isGroupOrgForbit?"33%":"70px"%>;}
		.imMainbox .imCenterdiv{width:auto;border-right: 1px solid #e1e8f5;right:281px;}
		.imMainbox .imRightdiv{width: 281px;height:auto;top:0px;border-left: 1px solid #e7e7e7;box-shadow: -3px 0px 4px -2px #e7e7e7;}
	  	.leftMenudiv .chatItem .msgcontent{width:170px;height: 16px;}
	  	.imMainbox .imSlid{right: 281px;}
	  	.imMainbox .defaultdiv{right:281px;width:auto;}
		.imMainbox .chatIMdivBox{position:absolute;height:auto;}
		#recentListdiv,#discussListdiv{top:186px;bottom:<%=customAppForbit?"41":"71"%>px;position:absolute;height:auto !important;width:100%;background:#f4f9f8;}
		#contactListdiv{top:222px;bottom:<%=customAppForbit?"41":"71"%>px;position:absolute;height:auto !important;width:100%;background:#f4f9f8;}
		.imMainbox .bottomToolbar{position: absolute;bottom: 6px;width: 100%;}
		.imMainbox .imSlideDiv{height:auto;bottom:0px;right: 281px;}
		.imMainbox .addressTitle{text-align: left;padding-left: 20px;}
		.imMainbox .imSearchInputdiv{width: 280px;}
		.imMainbox .imSearchList{width: 281px;}
		.imToptab .tabitem {width: 70px;}
		.arrow-up {
			left: 136px;
		   	background: url('/social/images/im/im_arrow_wev8.png');
		   	border: unset;
		   	width: 12px;
		   	height: 8px;
		   	top: -8px;
		}
		#sysMenuRoot{
			position: absolute;
    		bottom: 20px;
    		left: -90px;
    		z-index: 5000;
    		overflow-y: auto;
    		color: #494949;
		}
		.max-height-0{max-height: <%=level0%>px;}
		.max-height-1{max-height: <%=level1%>px;}
		.max-height-2{max-height: <%=level2%>px;}
		.max-height-3{max-height: <%=level3%>px;}
		#sysMenuRoot li:hover {
			color: #fff;
			cursor: pointer;
		}
		#sysMenuRoot li{
			text-overflow: ellipsis;
    		white-space: nowrap;
    		overflow: hidden;
    		line-height: 21px;
    		padding-left: 3px;
    	}
    	
    	#sysMenuRoot li>span.oamenu-icon{
			background: url("/social/images/pcmodels/oamenu_wev8.png") center center no-repeat;
			width: 14px;
			height: 25px;
			line-height: 25px;
    	}
    	#sysMenuRoot li:hover>span.oamenu-icon{
			background: url("/social/images/pcmodels/oamenu_h_wev8.png") center center no-repeat;
    	}
    	
    	#sysMenuRoot li  span.title{
			max-width: 82px;
			vertical-align: text-top;
		    display: inline-block;
		    text-overflow: ellipsis;
		    white-space: nowrap;
		    overflow: hidden; 		
    	}
		#sysMenuRoot ul, #sysMenuRoot{width: 100px;overflow-x: hidden;}
	<%}%>
	<%if(from.equals("main")){%>
		.imMainbg{background:none;}
		.leftMenudiv .chatItem .targetName{width: 142px;}
		.leftMenudiv .chatItem .itemconverright{width: 210px;}
		.leftMenudiv .chatItem .itemcenter{width:95px;}
		.leftMenudiv .chatItem .lastName, .leftMenudiv .chatItem .jobtitle{width:95px;}
		.leftMenudiv .chatItem .deptName, .leftMenudiv .chatItem .subName, .leftMenudiv .chatItem .mobile{width:95px;}
		.conTabs .conTabItem{width:70px;}
		.imMainbox .defaultdiv{background:none;width: 681px;}
		.imMainbox .imCenterdiv{width: 550px;border-right: 1px solid #e1e8f5;}
		.imMainbox .imRightdiv{width: 281px;height:0px;width:0px;top:auto;}
		.imMainbox{  
			right: 0px;
	  	    left: auto;
	  	    width: 963px;
	  	}
	  	.leftMenudiv .chatItem .msgcontent{width:170px;height: 16px;}
	  	.imMainbox .imSlid{right: 281px;}
	  	.imMainbox .imSearchdiv {    margin-left: 10px; margin-right: 10px;}
	  	.imToptab {background: #5cb5d8;height: 65px;border-bottom: unset;}
	  	.imToptab .tabitem .tabresent{background-image: url('/social/images/im_resent_wev8.png');}
		.imToptab .tabitem .tabgroup{background-image: url('/social/images/im_group_wev8.png');}
		.imToptab .tabitem .tabcontact{background-image: url('/social/images/im_contact_wev8.png');background-position-x: center;}
		
		.imToptab .activeitem .tabresent{background-image: url('/social/images/im_resent_h_wev8.png');}
		.imToptab .activeitem .tabgroup{background-image: url('/social/images/im_group_h_wev8.png');}
		.imToptab .activeitem .tabcontact{background-image: url('/social/images/im_contact_h_wev8.png');}
		
		.imToptab .activeitem .tabname{
			filter:alpha(opacity=100);
			-moz-opacity:1;
			-khtml-opacity:1;
			opacity: 1;
		}
		.imToptab .tabitem .tabname{
		 	text-align: center;
		 	margin-top:5px;
		 	margin-bottom:3px;
		 	color:#fff;
		 	filter:alpha(opacity=50);
			-moz-opacity:0.5;
			-khtml-opacity: 0.5;
			opacity: 0.5;
			padding-top: 23px;
			width: 100%;
		}
		.imToptab .tabitem .recentmsgcount {
			top: 82px;
    		left: 56px;
		}
		#recentListdiv,#discussListdiv{height: 420px;background:#f4f9f8;}
		#contactListdiv{height: 384px;background:#f4f9f8;}
		.conTabs {background: #7ec9e3;border-bottom: unset;}
		.conTabs .conTabItem{
			 float: left;
			 width:<%=isGroupOrgForbit?"33%":"70px"%>;
			 text-align:center;
			 color:#fff;
			 filter:alpha(opacity=50);
			-moz-opacity:0.5;
			-khtml-opacity: 0.5;
			opacity: 0.5;
			cursor:pointer;
			max-width :70px;
			height:35px;
			white-space:nowrap;
			overflow: hidden;
　 			text-overflow: ellipsis;
		 }
		 .conTabs .conActItem{
		 	filter:alpha(opacity=100);
			-moz-opacity:1;
			-khtml-opacity: 1;
			opacity: 1;
		 }
		 .imToptab .tabitem .tabicon {background-position: center center;background-size: unset;}
  	<%}%>
</style>
<!-- 右键菜单 -->
<div tabindex="9" class="rightMenudiv">
	
</div>

<!--@右键信息-->
<div id="atMessage" style="overflow:hidden;display:none;">
	<div id="atName"></div>
</div>

<!--个性签名卡片-->
<div id="imSignaturesTitle" style="overflow:hidden;display:none;">
	<div id="signTitle"></div>
</div>

<!-- 个性签名及头像-->
<div id="imSignaturesMessage" style="overflow:hidden;display:none;">
	<div id="imToken">
		<img src="" class="imPic" onerror="this.src='/messager/images/icon_m_wev8.jpg'">
	</div>
	<div id="imMessage">
		<div id="imName"></div>
		<div id="imJob"></div>
		<div style="color:#969696;display:inline-block;padding-top: 5px;overflow:auto"><%=SystemEnv.getHtmlLabelName(131613, user.getLanguage())%>：</div><div id="imPhone"></div><!-- 手机 -->
		<div id="imSign"></div>
	</div>
	<div onclick="$(this).parent().hide()" style="cursor: pointer; position: absolute;top: 3px;right: 3px;width: 18px;height: 18px;text-align: center;line-height: 17px;border-radius: 9px;font-size: 18px;">×</div>
</div>

<%--新增浮动卡片--%>
<div id="userMiniCard" style="overflow:hidden;display:none;">
<table class="userMiniCardTable">
		<colgroup><col width="50px"><col width="*"></colgroup>
		<tbody>
			<tr id="userMiniCardTrFirst">
				<td id=userMiniCardName align="left" valign="middle" class="ellipsis"></td>
				<td id=userMiniCardJob align="left" valign="middle" class="ellipsis"></td>
			</tr>
			<tr id="userMiniCardTrSecond">
				<td id=userMiniCardPhoneIcon align="left" valign="middle"><img src="/social/images/mobilephone_wev8.png"/></td>
				<td id=userMiniCardMobilephone align="left" valign="middle" class="ellipsis"></td>
			</tr>
		</tbody>
	</table>
</div>

<%--群分组操作卡片--%>
<div id="discussListNav" style="overflow:hidden;display:none;">
    <ul class="nav">  
        <li><a href="#" _target="add"><p class="text"><%=SystemEnv.getHtmlLabelName(131614, user.getLanguage())%></p></a></li><!-- 添加群聊分组 -->
        <li><a href="#" _target="rename"><p class="text"><%=SystemEnv.getHtmlLabelName(131615, user.getLanguage())%></p></a></li><!-- 重命名 -->
        <li><a href="#" _target="delete"><p class="text"><%=SystemEnv.getHtmlLabelName(131616, user.getLanguage())%></p></a></li><!-- 删除群聊分组 -->
    </ul>
</div>
<%--群组操作卡片--%>
<ul class="sf-menu sf-vertical">
    <li class="current">
        <a href="#"  _target="move"><%=SystemEnv.getHtmlLabelName(131617, user.getLanguage())%></a><!-- 移动群至 -->
    </li>
    <li><a href="#"  _target="quit"><%=SystemEnv.getHtmlLabelName(131618, user.getLanguage())%></a></li><!-- 退出该群 -->
</ul>

<%--用户状态切换卡片--%>
<div class="userStatusPanel">
    <div class="arrow"></div>
    <div class="userStatusPanelList">
        <li onclick="OnLineStatusUtil.switchUserStatus(this)"><img src="/social/images/userStatus/top/online.png"/>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" _target="online"><%=SystemEnv.getHtmlLabelName(131096, user.getLanguage())%></a></li>
        <li onclick="OnLineStatusUtil.switchUserStatus(this)"><img src="/social/images/userStatus/top/away.png"/>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" _target="away"><%=SystemEnv.getHtmlLabelName(131097, user.getLanguage())%></a></li>  
        <li onclick="OnLineStatusUtil.switchUserStatus(this)"><img src="/social/images/userStatus/top/busy.png"/>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" _target="busy"><%=SystemEnv.getHtmlLabelName(131098, user.getLanguage())%></a></li>
    </div>
</div>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
<!-- 图片预览 -->
<div class="IMConfirm"></div>

<!-- 聊天窗口 模板 -->
<iframe id="chatDivFrm" src="/social/im/SocialIMChatTp.jsp?from=<%=from %>&pcOS=<%=pcOS %>&isOpenVote=<%=isOpenVote%>&isOpenDisk=<%=isOpenDisk%>&isWfShareForbit=<%=isWfShareForbit?"1":"0" %>&isDocShareForbit=<%=isDocShareForbit?"1":"0" %>&ifForbitFolderTransfer=<%=ifForbitFolderTransfer?"1":"0" %>&isFileTransForbit=<%=isFileTransForbit?"1":"0" %>&isImgSendCutForbit=<%=isImgSendCutForbit?"1":"0" %>&ifForbitShake=<%=ifForbitShake?"1":"0"%>&isForbitPrivateChat=<%=isForbitPrivateChat?"1":"0"%>&ifForbitCustomer=<%=ifForbitCustomer?"1":"0"%>" style="display:none;">
</iframe>

<!-- 文件下载 -->
<iframe id="downloadFrame" style="display: none"></iframe>

<div id="IMbg" class="IMbg" style="display:none;"></div>
<div class="imMainbox imMainbox-p5" style="" id="imMainbox">

	<div class="defaultdiv" id="imDefaultdiv" onclick="<%=from.equals("main")?"parent.showIMdiv(0)":""%>">
		<%if(!from.equals("main")){%>
			<div style="margin-top:<%=frompc?"140":"200"%>px;">
				<img src="/social/images/im/im_nochat_<%=frompc?"pc_":"" %>wev8.png">
			</div>
			<div style="color:#C4C4C4;margin-top:20px;font-size:16px;"><%=SystemEnv.getHtmlLabelName(frompc?127224:126853, user.getLanguage())%></div><!-- 未选择聊天 -->
		<%}%>
	</div>
	<%if(frompc){ %>
	<!-- 色值蒙版 -->
	<div class="colorFiltBg" style="display:none;opacity:0.2;right:281px;position:absolute;left:0;width:auto;height:100%;filter:alpha(opacity=20);"></div>
	<%} %>
	<div id="imLeftdiv" class="imLeftdiv scrollbar">
		<div id="chatIMTabs" class="chatIMTabs">
			
		</div>
	</div>
	<div id="imCenterdiv" class="imCenterdiv">
		<div id="chatIMdivBox" class="chatdivBox winbox chatIMdivBox"></div>
	</div>
	<!-- 右侧弹出区域 -->
	<div id="imSlideDiv" class="imSlideDiv">
		<jsp:include page="/social/im/SocialDiscussSetting.jsp">
			<jsp:param name="from" value="<%=from %>"/>
			<jsp:param name="groupSet" value="<%=pcGroupChatSet.toString() %>"/>
		</jsp:include>
		<iframe frameborder="0" scrolling="no" width="100%" height="100%"></iframe>
	</div>
	<!-- 个人信息编辑区域 -->
	<div id="imPersonEditDiv" class="imPersonEditDiv" style="display:none;">
		<jsp:include page="/social/im/SocialIMPcModels.jsp?model=personeditblock">
			<jsp:param name="from" value="<%=from %>"/>
			<jsp:param name="ClientSet" value="<%=pcClientSettings %>"/>
		</jsp:include>
	</div>
	<!-- 快捷回复区域 -->
	<div id="quickreplyDiv" class="quickreplyDiv" style="display:none;">
		<div class="headDiv"><%=SystemEnv.getHtmlLabelName(130290, user.getLanguage())%>
		&nbsp;&nbsp;
        <span class="checkboxDiv" style="display: inline-block;vertical-align: middle;height:50%">
            <input type="checkbox" tzCheckbox="true"  onclick=""/>  
        </span>
        <img title="开启表示点击直接发送，关闭代表可以编辑再发送" src="/images/tooltip_wev8.png" align="absMiddle" />
        <span class="btnDiv" onclick="QuickReplyUtil.openCustomSetting()"></span></div><!-- 快捷回复 -->
		<div class="listDiv">
			<jsp:include page="/social/im/socialQuickReplyList.jsp"></jsp:include>
		</div>
	</div>
	<div class="imRightdiv">
			<div class="addressTitle">
			<%if(from.equals("main")){%>	
				<div class="imCoseBtn" onclick="parent.showIMdiv(0)" title="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>">×</div><!-- 关闭 -->
			<%}%>
             <!-- pc客户端 -->
            <% if("pc".equals(from)){ %>
            	e-message
                <div class="pc-toolbar pc-clear no-drag none-select">
                	<!-- 换肤按钮 -->
					<jsp:include page="/social/im/SocialIMPcModels.jsp?model=skinitemblock">
					</jsp:include>
					<div id="pcOnTop" class="pc-imOnTopBtn" data-title="<%=SystemEnv.getHtmlLabelName(129799, user.getLanguage())%>"></div><!-- 窗口前置 -->
					<div id = "windowTool" class="pcontop clickHide" style="display:none">
					<div class="topnarrow"></div>
						<div  class="checkpane" _index="1"></div>
						<div style="margin:3px;">
							<div id="tool-1" class="pcontopItme">
								<span><%=SystemEnv.getHtmlLabelName(129800, user.getLanguage())%></span><!-- 保持窗口最前 -->
							</div>
						</div>
					</div>
                    <div id="pcMin" class="pc-imMinBtn" data-title="<%=SystemEnv.getHtmlLabelName(19965, user.getLanguage())%>"></div><!-- 最小化 -->
                    <div id="pcMax" class="pc-imMaxBtn" data-title="<%=SystemEnv.getHtmlLabelName(19944, user.getLanguage())%>"></div><!-- 最大化 -->
                    <div id="pcClose" class="pc-imCoseBtn" data-title="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"></div><!-- 关闭 -->
                </div>
            <% }else{ %>
            	<%=SystemEnv.getHtmlLabelName(1515, user.getLanguage())%><!-- 通讯录 -->
            <%}%>
			</div>
					<%if(frompc && !signForbit){ %>
	<!-- 签到按钮 -->
	<jsp:include page="/social/im/SocialIMPcModels.jsp?model=signitemblock">
	</jsp:include>
	<%} %>
			<%if("pc".equals(from)) { %>
				 <!-- 功能入口按钮组 -->
                <jsp:include page="/social/im/SocialIMPcModels.jsp?model=headtoolbar"></jsp:include>
			<%} %>
			<div class="imSearchdiv">
				<div class="imSearchBtn" onclick="doMemberSearch();"></div> 
				<div style="float: left;margin-left:10px;">
					<input type="text" value="<%=SystemEnv.getHtmlLabelName(130148, user.getLanguage())%>" onfocus="dropRecent(event, this)" 
						onclick="javascript:$(this).select();" class="imInputdiv"/><!-- 请输入关键字 -->
				</div>
				<div class="clear"></div>
			</div>
			<!-- 顶部导航 -->
			<div class="imToptab">
				<div class="tabitem activeitem" _target="recent">
					<div class="tabicon tabresent">
						<div class="tabname"><%=SystemEnv.getHtmlLabelName(24515, user.getLanguage())%></div><!-- 最近 -->
                        <div class="recentmsgcount" _msgcount="0" >0</div>
					</div>
				</div>
				
				<div class="tabitem" _target="contact">
					<div class="tabicon tabcontact">
						<div class="tabname"><%=SystemEnv.getHtmlLabelName(572, user.getLanguage())%></div><!-- 联系人 -->
					</div>
				</div>
				
				<div class="tabitem" _target="discuss" _color="#f47564" _url="/social/workers/SocialWorkersRight.jsp">
					<div class="tabicon tabgroup">
						<div class="tabname"><%=SystemEnv.getHtmlLabelName(126854, user.getLanguage())%></div><!-- 群聊 -->
					</div>
				</div>
				
				<div class="clear"></div>
			</div>
			<div class="clear"></div>
			<!-- 顶部导航 -->
			
			<!-- 左侧菜单 -->
			<div class="leftMenus" style="padding-top:0px;background:#fff;">
				<div class="conTabs" id="imConTabs" style="display:none;">
					<div class="arrow-up"></div>
					<div class="conTabItem conActItem" _target="dept" onclick="changeContactTab(this)"><%=SystemEnv.getHtmlLabelName(18511, user.getLanguage())%></div><!-- 同部门 -->
					<div class="conTabItem" _target="lower" onclick="changeContactTab(this)"><%=SystemEnv.getHtmlLabelName(15089, user.getLanguage())%></div><!-- 我的下属 -->
					<%if(!isGroupOrgForbit){ %>
					<div class="conTabItem" _target="hrmOrg" onclick="changeContactTab(this)"><%=SystemEnv.getHtmlLabelName(18770, user.getLanguage())%></div><!-- 按组织结构 -->
					<%} %>
					<div class="conTabItem" _target="hrmGroup" onclick="changeContactTab(this)"><%=SystemEnv.getHtmlLabelName(81554, user.getLanguage())%></div><!-- 常用组 -->
					<div class="clear"></div>
				</div>
				<div id="searchResultListDiv" class="leftMenudiv" style="display:none;z-index:100">
					<input type="text" value="<%=SystemEnv.getHtmlLabelName(32933, user.getLanguage())%>" maxlength="50" onkeyup="doMemberSearch(this, event)" onclick="javascript:$(this).select();" class="imSearchInputdiv"><!-- 请输入关键字 -->
					<div class="imSearchClose">
						<span class="btn-radius-small">×</span>
					</div>
					<div id="imSearchList" class="imSearchList _hideit scrollbar"></div>
				</div>
				<div id="recentListdiv" class="leftMenudiv scrollbar" style="overflow:auto;display:block;">
						<div id="recentLoading" class='dataloading' style="position:absolute;top:0px;bottom:0px;left:0px;right:0px;z-index:1000;text-align:center;height:auto;padding-top:50%;">
							<img src='/social/images/loading_large_wev8.gif'/>
						</div>
				</div>
				<div id="contactListdiv" class="leftMenudiv scrollbar" style="overflow:auto;display:none;">
					<div class="hrmTreeItem" style='width: 100%;display:none;'>
						<ul id='hrmOrgTree' class='hrmOrg' style='width: 100%;display:none;'></ul>
						<ul id='hrmGroupTree' class='hrmOrg' style='width: 100%;display:none;'></ul>
					</div>
					<div id='deptConb' class='hrmOrg' style="width: 100%;display:none;"></div>
					<div id='lowerConb' class='hrmOrg' style="width: 100%;display:none;"></div>
				</div>
				<div id="discussListdiv" class="leftMenudiv scrollbar" style="overflow:auto;display:none;">
					<div id="discussTree" class="ztree"></div>
				</div>
			</div>
			<!-- 左侧菜单 -->
			
			<div class="bottomToolbar">
				<div id="pcmod-ftb">
				 <% if("pc".equals(from) && !customAppForbit){ %>
				 <jsp:include page="/social/im/SocialIMPcModels.jsp?model=footertoolbar"></jsp:include>
				 <%} %>
				 </div>
				<!-- 工具条 -->
				<div class="rightNavdiv">
				<%if(frompc){ %>
					<%if(!isMenuItemForbit){ %>
                    <!-- 
					<div class="menuNav rightNavbox" title="菜单" onclick="PcWinSizeUtils.base();"></div>
                    <div class="menuNav rightNavbox" title="菜单" onclick="PcWinSizeUtils.all();"></div>
                     -->
                    <div class="menuNav rightNavbox" title="<%=SystemEnv.getHtmlLabelName(131619, user.getLanguage())%>" onclick="MenuUtil.showMenuItem(this, event);"></div><!-- 菜单 -->
                   	<ul id='sysMenuRoot' isshow='0' level='0' style='display:none;'></ul>
                    <%} %>
					<div class="pcsettingNav rightNavbox" title="<%=SystemEnv.getHtmlLabelName(774, user.getLanguage())%>" onclick="openSysSetting();"></div><!-- 系统设置 -->
				<%} %>
					<div class="favourateNav rightNavbox" title="<%=SystemEnv.getHtmlLabelName(18030, user.getLanguage())%>" onclick="ChatUtil.goMyFavourate();"></div><!-- 我的收藏 -->
					<%if(!isBingForbit){ %>
					<div class="bingNav rightNavbox" title="<%=SystemEnv.getHtmlLabelName(126359, user.getLanguage())%>" onclick="ChatUtil.goBing();"></div><!-- 必达 -->
					<%} %>
					<% if("0".equals(sysBroadcastSet.getString("isSysBroadcastForbit"))) { %>
                    <div class="sysBroadcastNav rightNavbox" title="<%=SystemEnv.getHtmlLabelName(127152, user.getLanguage())%>" onclick="ChatUtil.goSysBroadcast();"></div><!-- 系统广播 -->
					<% } %>
					<% if(!isForbitPrivateChat && IS_BASE_ON_OPENFIRE){%>
					<div class="privateChatNav rightNavbox" title="<%=SystemEnv.getHtmlLabelName(131962, user.getLanguage())%>" onclick="ChatUtil.goPrivate();"></div><!--密聊-->
					<%}%>
					<%if(frompc && false){ %>
					<div class="chatrecNav rightNavbox" title="<%=SystemEnv.getHtmlLabelName(126855, user.getLanguage())%>" onclick="window.alert('开发中...');"></div><!-- 聊天记录 -->
				<%} %>
				</div>
				<%if("0".equals(pcGroupChatSet.optString("isGroupChatForbit")) && "1".equals(pcGroupChatSet.optString("hasGroupChatRight"))){ %>
				<div onclick="DiscussUtil.addDiscuss(event);"class="adddiscussDiv">
					<span style="margin-left:30px;"><%=SystemEnv.getHtmlLabelName(126852, user.getLanguage())%></span> <!-- 发起群聊 -->
				</div>
				<%} %>
			</div>
			
	</div>
</div>

<div id="msgbox" class="msgbox winbox"></div>
<div id="viewdivBox" class="chatdivBox winbox" style="display:none;overflow:auto;z-index: 11"></div>

<style>
    .popbox{position:fixed;left:223px;right:319px;top:0px;bottom:0px;background:#fff;display:none;}
</style>

<!-- @提醒 -->
<div id="relatedMsgdiv" class="chatgroupmsga">
	<div class="relatedHead">
		<img _hrmid="1" src="" class="userHead head22">
	</div>
	<div class="relatedContent ellipsis"></div>
	<div class="clearmsg" onclick="cleargroupmsg(this)" ></div>
	<div class="clear"></div>
</div>
<!-- 聊天窗口浮动提醒 -->
<div id="chatWinFloatMsgdiv" class="chatWinFloatMsgdiv chatgroupmsga">
	<div class="levelType"></div>
	<div class="msgContent"></div>
	<div class="clearmsg" onclick="cleargroupmsg(this)" ></div>
	<div class="clear"></div>
</div>

<!-- 会话模板 -->
<div class="converTemp chatItem" style="display:none;" onclick="showConverChatpanel(this)" ondblclick="clearTimeout($(this).data('timerid'))" onmousedown="goMounseHandler(this,event)" >
	<div class="itemleft">
		<img src="/messager/images/icon_m_wev8.jpg" class="head35 targetHead" onerror="this.src='/messager/images/icon_m_wev8.jpg'"/>
	</div>
	<div class="itemconverright">
		<div>
			<div class="targetName ellipsis left">
				<span class="name"></span>
				<span class="signatures"></span>
			</div>
			<div class="latestTime right"></div>
			<div class="clear"></div>
		</div>
		<div style="margin-top:3px;">
			<div class="msgcontent ellipsis left"></div>
			<div class="msgcount right" _msgcount="0" >0</div>
			<div class="clear"></div>
		</div>
	</div>
	<div class="clear"></div>
</div>

<!-- 快捷搜索模板 -->
<div id="tempSearchHrmItem" class="chatItem" style="display:none" _targetid="" _targetName="" _targetHead="" _targetType="0">
	<div class="itemleft" style="float: left;">
		<img src="" class="head35" onerror="this.src='/messager/images/icon_m_wev8.jpg'"/>
	</div>
	<div class="itemcenter" style="float: left;">
		<div class="lastName ellipsis">
			<div class="name"></div>
			<img src="/social/images/signatures.png" class="signatures"/>
		</div>
		<div class="deptName ellipsis"></div>
	</div>
	<div class="itemright" style="float: left;">
		<div class="mobile ellipsis"></div>
		<div class="subName ellipsis"></div>
	</div>
	<div class="clear"></div>
</div>
<!-- 快捷搜索模板 -->
<div id="tempSearchGroupItem" class="chatItem groupItem" style="display:none"_targetid="" _targetName="" _targetHead="/social/images/head_group.png" _targetType="1">
	<div class="itemleft">
		<img src="" onerror="this.src='/social/images/head_group.png'" class="head35 targetHead"/>
	</div>
	<div class="itemconverright">
		<div class="groupName ellipsis"></div>			
	</div>
	<div class="clear"></div>
</div>

<!-- 聊天记录模板 -->
<div id="tempChatItem" class="chatItemdiv" style="display:none;">
	<div class="chatRItem">
			<div class="chatHead">
				<img src="/messager/images/icon_m_wev8.jpg" class="head35 userimage" onmousedown="ChatUtil.iconRightClick($(this).parents('.chatItemdiv'),event)" onmouseenter="ChatUtil.showImSignPic(this)" onmouseleave="ChatUtil.hideImSignPic(this)" onclick="showConverChatpanel($(this).parents('.chatItemdiv'))" onerror="this.src='/messager/images/icon_m_wev8.jpg'">
			</div>
			<div class="chattd">
				<div class="chatName"></div>
				<div class="clear"></div>
				<div class="chatArrow"></div>
				<div class="chatContentdiv">
					<div class="chatContent"
						onmouseover="IM_Ext.showFloatMenu(event,this)"
						onmouseout="IM_Ext.hideFloatMenu(event,this);"></div>
					<div class="msgUnreadCount" onclick="ChatUtil.showMsgReadStatus(this)"></div>
					<div class="clear"></div>
					
				</div>
				<div class="clear"></div>
			</div>
			<div class="clear"></div>
	</div>	
</div>
<!-- 浮动提示 -->
<div id="warn">
	<div class="title"></div>
</div>


<!-- 消息浮动菜单模板 -->
<div id="tempchatFloatmenu" class="chatFloatmenuWrap"  style="display:none;"
		onmouseover="if(IM_Ext.isMouseLeaveOrEnter(event, this)) $(this).data('isLocked', 1).show();"
		onmouseout="if(IM_Ext.isMouseLeaveOrEnter(event, this)) $(this).data('isLocked', 0).hide();">
	<div class="chatFloatmenu" >
		<div class="floatmenuItem opCollect imShowOn" onclick="IM_Ext.doFloatMenuClick('opCollect', this);"><%=SystemEnv.getHtmlLabelName(28111, user.getLanguage())%><span class="rightSplit"></span></div><!-- 收藏 -->
		<div class="floatmenuItem opForward imShowOn" onclick="IM_Ext.doFloatMenuClick('opForward', this);"><%=SystemEnv.getHtmlLabelName(6011, user.getLanguage())%><span class="rightSplit"></span></div><!-- 转发 -->
		<%if(!isBingForbit){ %>
		<div class="floatmenuItem opBing imShowOn" onclick="IM_Ext.doFloatMenuClick('opBing', this);"><%=SystemEnv.getHtmlLabelName(126359, user.getLanguage())%><span class="rightSplit"></span></div><!-- 必达 -->
        <%} %>
        <% if(frompc) { %>
	        <% if(isOpenDisk.equals("1")){%>
				<div class="floatmenuItem opCancelDisk imShowOn" onclick="IM_Ext.doFloatMenuClick('opCancelDisk', this); " style ="width:90px"><%=SystemEnv.getHtmlLabelName(129680, user.getLanguage())%><span class="rightSplit"></span></div><!-- 取消分享 -->
				<div class="floatmenuItem opSaveDisk imShowOn" onclick="IM_Ext.doFloatMenuClick('opSaveDisk', this);" style ="width:90px" ><%=SystemEnv.getHtmlLabelName(129681, user.getLanguage())%><span class="rightSplit"></span></div><!-- 存入云盘 -->
	        <% } %>
        <% } %>
        <div class="floatmenuItem opCopy imShowOn" <%=frompc?"":"id='copybtn'" %> _menuType="floatmenuItem_copy" onclick="ClipboardUtil.execCopy(this, event)"><%=SystemEnv.getHtmlLabelName(77, user.getLanguage())%><span class="rightSplit"></span></div><!-- 复制 -->
        <div class="floatmenuItem opWithDraw imShowOn" onclick="IM_Ext.doFloatMenuClick('opWithDraw', this);"><%=SystemEnv.getHtmlLabelName(131620, user.getLanguage())%></div><!-- 撤回 -->
		<div class="floatmenuItem opDelete" style="display:none;" onclick="IM_Ext.doFloatMenuClick('opDelete', this);"><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></div><!-- 删除 -->
		<div class="floatmenuItem opMore" onclick="IM_Ext.imDropMenu(this);" style="display:none;"><%=SystemEnv.getHtmlLabelName(17499, user.getLanguage())%></div><!-- 更多 -->
		<!-- 更多子菜单 -->
		<div class="imFloatSubMenu" style="display:none;">
			<div class="floatSubMenuItem opSendToBlog imShowOn"
				onclick="IM_Ext.doSubMenuItemClick('opSendToBlog', 'opMore', this);">
				<img src="/social/images/floatsubmenu_golog_wev8.png">	
				<span><%=SystemEnv.getHtmlLabelName(126856, user.getLanguage())%><span><!-- 发送到日志 -->
			</div>
			<div class="floatSubMenuItem opSendToTask imShowOn lastItem" 
				onclick="IM_Ext.doSubMenuItemClick('opSendToTask', 'opMore', this);">
				<img src="/social/images/floatsubmenu_gotask_wev8.png">
				<span><%=SystemEnv.getHtmlLabelName(126857, user.getLanguage())%></span><!-- 转为任务 -->
			</div>
		</div>
	</div>
</div>
<!-- 附件发送模板 -->
<div class="accitem" id="accMsgTemp" style="display:none;">		
	<div class="accicon" style="background:url('/social/images/acc_doc_wev8.png') no-repeat center center;"></div>										
	<div class="accContent">							
	  <div>
	  	<div class="filename ellipsis opdiv" style="width:150px;float:left;" _fileId="0" onclick="viewIMFile(this)">社交平台需求说明书.doc</div>					
	    <div class="filesize" style="float:left;">(4.82M)</div>	
	    <div class="clear"></div>
	  </div>
	  <div class="sendok"><%=SystemEnv.getHtmlLabelName(126858, user.getLanguage())%></div><!-- 文件发送成功 -->
	  <div class="accline"></div>
	  <div class="optiondiv">
	  	 <% if(frompc) { %>
	    	<a href="javascript:void(0)" class="opdiv opfile" _fileId="0" onclick="downAccFile(this,true)"><%=SystemEnv.getHtmlLabelName(131622, user.getLanguage())%></a><!-- 接收 -->
	    	<a href="javascript:void(0)" class="opdiv opdir" _fileId="0" onclick="downAccFile(this)" ><%=SystemEnv.getHtmlLabelName(131623, user.getLanguage())%></a><!-- 另存为 -->
	  	<%}else{ %>
	  		<a href="javascript:void(0)" class="opdiv" _fileId="0" onclick="downAccFile(this)" ><%=SystemEnv.getHtmlLabelName(258, user.getLanguage())%></a><!-- 下载 -->
	  	<%} %>
	  </div>
	</div>
	<div class="clear"></div>  
	<div class="acccomplete"></div>
    <% if("pc".equals(from)) { %>
    <div class="pc-fileDlBar">
        <div class="progress pc-progress">
        	<div class="progress-bar" role="progressbar" style="width: 0%;"></div>
        </div>
    </div>
    <% } %>		
</div>

<!-- 附件列表模板 -->
<div class="accitem" id="accFileItemTemp" _fileid="0" style="display:none;">
	<div class="accicon" style="background:url('/social/images/acc_default_wev8.png') no-repeat center center;"></div>
	<div class="acccdiv">
		<div>
			<a href="javascript:void(0)" class="fileName opdiv" onclick="viewIMFile(this)"><%=SystemEnv.getHtmlLabelName(17517, user.getLanguage())%></a><!-- 文件名称 -->
		</div>
		<div style="margin-top:10px;">
			<span class="fileSize"><%=SystemEnv.getHtmlLabelName(2036, user.getLanguage())%></span><!-- 大小 -->
			<span class="senderName"><%=SystemEnv.getHtmlLabelName(16975, user.getLanguage())%>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(18530, user.getLanguage())%></span><!-- 发送人   发送日期 -->
		</div>
	</div>
	<div class="btn1 download imDownload opdiv"  onclick="downAccFile(this)"><%=SystemEnv.getHtmlLabelName(258, user.getLanguage())%></div><!-- 下载 -->
	<!-- 
	<div class="btn1 download imDelete opdiv"  onclick="delAccFile(this)"><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></div>
	 -->
	<div class="clear"></div>
</div>

<!-- 分享消息模板 -->
<div id="shareMsgTemp" class="shareMsgItem" style="display:none;">
	<div class="shareTitle"><%=SystemEnv.getHtmlLabelName(18015, user.getLanguage())%></div><!-- 流程 -->
	<div class="shareContentdiv">
		<div class="shareContent"></div>
		<div class="shareDetail opdiv" onclick="viewShare(this)" _shareid="0" _sharetype="">
			<%=SystemEnv.getHtmlLabelName(2121, user.getLanguage())%>&nbsp;&nbsp;
		</div><!-- 详细信息 -->
	</div>
</div>

<!-- 任务消息模板 -->
<div id="taskMsgTemp" class="taskMsgItem" style="display:none;">
	<div class="taskMsgTitle">
		 任务<div class="taskStateTip"></div>
	</div>
	<div class="taskMsgContentdiv">
		<div class="taskMsgContent">
			<div class="taskTitle ellipsis"></div>
			<div class="taskCreator"></div>
			<div class="taskCreatime"></div>
		</div>
		<div class="taskMsgDetail opdiv" onclick="">
			<div class="taskComplete taskState" onclick="ChatUtil.completeTask(this);"><%=SystemEnv.getHtmlLabelName(555, user.getLanguage())%></div><!-- 完成 -->
		</div>
	</div>
</div>

<!-- 必达消息模板 -->
<div id="dingMsgTemp" class="dingMsgItem" style="display:none;">
	<div class="dingMsgTitle">
		 必达<div class="dingStateTip"></div>
	</div>
	<div class="dingMsgContentdiv">
		<div class="dingMsgContent">
			<div class="dingTitle ellipsis"></div>
			<div class="dingCreator"></div>
			<div class="dingCreatime"></div>
		</div>
		<div class="dingMsgDetail opdiv" onclick="">
			<div class="dingComfirm dingState" onclick="ChatUtil.comfirmDing(this);"><%=SystemEnv.getHtmlLabelName(126859, user.getLanguage())%></div><!-- 确认收到 -->
		</div>
	</div>
</div>
<!-- 投票消息模板 -->
<div id="voteMsgTemp" class="voteMsgItem" style="display:none;">
	<div class="voteMsgTitle"></div>
	<div class="voteMsgContentdiv">
	<div class="accicon" ><img class="voteImg"></div>
		<div class="voteMsgContent">
			<div class="voteDetail ellipsis"></div>
			<div class="voteMsgDeadline"></div>
		</div>
		<div class="accline"></div>
		<div class="voteMsgDetail opdiv" onclick="viewShare(this)" _shareid="0" _sharetype="">
			<%=SystemEnv.getHtmlLabelName(2121, user.getLanguage())%>&nbsp;&nbsp;
		</div>
	</div>
</div>
<!-- 图文消息模板 -->
<div id="tempTextImg" class="textImgMsgItem" title="<%=SystemEnv.getHtmlLabelName(126860, user.getLanguage())%>" style="display:none;"><!-- 打开分享 -->
	<div class="content">
		<div class="imgcot">
			
		</div>
		<div class="textcot ellipsis">
			
		</div>
	</div>
</div>	
<div id="hrmcard" class="hrmcard"></div>
<audio id="smsReceivedAudio" style="width: 0px;height: 0px;display: none;" src="<%if (isxp) {%>/social/im/js/sms-received.ogg<%} else {%>/social/im/js/sms-received.mp3<%}%>" controls="controls"></audio>

<% if (frompc) {%>
	<audio id="pcShakeWinAudio" style="width: 0px;height: 0px;display: none;" src="<%if (isxp) {%>/social/im/js/sms-shakeWin.ogg<%} else {%>/social/im/js/sms-shakeWin.wav<%}%>"  controls="controls"></audio>
<%} %>
</body>

<script type="text/javascript">
  var _color="#995dd8"; //模块基本色
  var _module="home";   //模块
  var _localhost="";
  var labelcount = 0;
  var pageIndex = 1;
  var dialog = null;
  var from="<%=from%>";
  
  var versionTag = undefined;
  
  var ISAllowNW = <%=isAllowNewWin%>;
  var CLIENT = 'NXP';
  //是否使用旧版本emessage登陆
  var nwFlag='<%=nwFlag%>';
  var new_win = "";
  
  window.onbeforeunload = function(){
      if(ChatUtil.isFromPc()){
          //其他模块会刷新页面，导致web版本强制下线
          M_ISFORCEONLINE = true;  //强制下线
	  }
	  client.disconnect();
  } 
  
  //监听窗口状态
  /*
	$(window.top).focus(function(){
		this.IMUtil.cache.isWindowFocus = 1;
		$("#chatIMTabs .chatIMTabActiveItem").click();
		checkClearUnreadStatus();
	}).blur(function(){
		this.IMUtil.cache.isWindowFocus = 0;
	});
  */
  $(document).ready(function(){	
  	setTimeout(function(){
  		$(".dataloading").hide();
  	}, 8000);
  	
  
  	
  	//初始化中间区域高度
  	var clientHeight=$(window).height();
  	var clientWidth=$(window).width();
  	
  	if("<%=from%>"!="main"&&"<%=from%>"!="pc"){
	  	var imMainTop=(clientHeight-$("#imMainbox").height())/2;
	  	var imMainLeft=(clientWidth-$("#imMainbox").width())/2;
	  	$("#imMainbox").css({"top":imMainTop,"left":imMainLeft});
  	}
  	$("#centerLeftbox").css("min-height",clientHeight-20);
  	
  	//getConversationList(); //获取最近聊天
  	
  	loadLocalUserInfo(<%=localUserInfo%>);
  	
  	loadUserInfo(); //加载人员信息
  	
  	loadLocalConvers();//加载本地会话
  	
  	loadSettingInfo();//加载设置信息
  	
  	initIMNavTop(); //初始化顶部
  	
	initBodyClick(); //初始化页面单击事件 	
	
	initPageEvent();
	
	//加载消息提醒监听
	initNotifHandler();
	
	//加载网页窗口监听
	initBrowerTabHandler(window.self);
	
  	//$('#imMainbox .scrollbar').perfectScrollbar();
  	IMUtil.imPerfectScrollbar($('#imMainbox .scrollbar'));
  	$('#content').perfectScrollbar();
  	$('#quickreplyDiv').find('.listDiv').perfectScrollbar();
	//绑定滚动条事件，保证当前窗口滚动条处于最上层
	$("#imMainbox .chatListbox").live('hover',function(event){ 
		if(event.type=='mouseenter'){ 
			var scrollbarid=$(this).attr("_scrollbarid");
			if($(this).hasClass("fileList")){
				scrollbarid=$(this).find(".acclist").attr("_scrollbarid");
			}
			$("#imMainbox .chatListScrollbar").css({"z-index":"1000"});
			if(!isSlideDivOn()){
				$("#"+scrollbarid).css({"z-index":"1001"}).show();
			}
		}else{ 
			//doSomething... 
		} 
	})
	//小e滚动条问题
	$('#notice_-1').live('hover',function(event){ 
		if(event.type=='mouseenter'){
		var chatList = $("#imMainbox .chatListbox");
		var length = chatList.length;
		for(var i = 0;i< length;i++){
		 try{$("#"+$(chatList[i]).attr("_scrollbarid")).hide()}catch(e){}			
			}
		}
	})
	ChatUtil.initLocalDB(); //初始化本地数据库
	//绑定滑动页面的滚动条
	$('#imSlideDiv').mouseover(function(){
		hideChatWinScrollers();
	});
	
	//加载客户端设置
	loadClientSetInfo();
	//加载客户端系统菜单
	MenuUtil.cache.MaxHeightAry = ["<%=level0%>","<%=level1%>","<%=level2%>","<%=level3%>"];
	MenuUtil.loadSysMenuInfo(0,0,0);
	//加载组织结构
	loadOrgTreeInfo();
	//处理上下文菜单
	loadContextMenu();
	//监听连接状态, 暂时只开放私有部署的web版
	if("<%=from%>"!="pc" && IS_BASE_ON_OPENFIRE){
		initConnStatusMonitor();
	}
	//缓存人员下载路径
	if("<%=from%>"=="pc"){
		loadAccSavePath();
	}
	//缓存被撤销消息
	loadWithdrawMsg();
	loadwebAndpcConfig();
	//初始化系统按钮提示
	initSystemTip();
	//初始化客户端时间显示监听器
	initTimeRefresher();
  });
  
  function initTimeRefresher(){
  	setTimeout(function(){
  		var curTimeMillis = new Date().getTime().toString();
  		if(curTimeMillis >= ZERO_TIME_MILLIS) {
  			// 更新最近列表时间
  			updateRecentTime();
  			// 更新零点时间
			var days = (Number(curTimeMillis) - ZERO_TIME_MILLIS) / 86400000;
			ZERO_TIME_MILLIS = ZERO_TIME_MILLIS + (1 +days) * 86400000;
  		}
  		setTimeout(arguments.callee, 30000);
  	}, 30000);
  }
  
  function updateRecentTime(){
  	var recentList = $('#recentListdiv');
  	var chatitems = recentList.find('.chatItem');
  	chatitems.each(function(){
  		var _this = $(this);
  		var sendtime = getFormateTime(_this.attr('_sendtime'));
  		_this.find('.latestTime').text(sendtime);
  	});
  }
  
  function initSystemTip() {
  	$('#pc-skinitemblock .itemblock, #pcOnTop, #pcMin, #pcMax, #pcClose').mouseenter(function(){
  		var _this = $(this);
  		_this.justToolsTip({
  			animation:"fadeIn",
	        height:"26px",
	        theme: "theme-system",
	        contents:_this.attr("data-title"),
	        gravity:'bottom'
  		});
  	}).bind('click', function(){
  		$('.just-tooltip').remove();
  	});
  }
  
  function loadWithdrawMsg(){
  	$.post('/social/im/SocialIMOperation.jsp?operation=getWithdrawMsg', function(data){
  		try{
  			data = JSON.parse(data);
  		}catch(err){
  			
  		}
		WithdrawGlobal = data;
	});
  }
  
  function loadAccSavePath(){
  	//return;
  	$.post('/social/im/SocialImPcUtils.jsp', { method : 'getLastsavepath'}, function(data){
  		try{
  			data = JSON.parse(data);
  		}catch(err){
  			
  		}
		DownloadSet = data;
	});
  }
	function loadwebAndpcConfig(){
  	//web和pc端公共配置
		$.post('/social/im/SocialImPcUtils.jsp',{method : 'getUserSysConfig', osType :'4'},function(data){
			try{
				data = JSON.parse(data);
			}catch(err){
				
			}
			if(data.isSuccess){
				if(typeof data.config ==='object'){
					WebAndpcConfig = data.config;
				}
			}
		});
	}
  //var isConfirmLock = false;
  function initConnStatusMonitor(){
  	var options = {
		"onclick": {
			"fn": function(ele){
				client.reconnect(function(isSuccess){
					if(isSuccess){
						var chatwin = ChatUtil.getchatwin(ele);
						if(chatwin.length > 0) {
							var chatType = chatwin.attr('_targettype');
							var acceptId = chatwin.attr('_targetid');
							ChatUtil.getHistoryMessages(chatType,acceptId,10,true);
						}
					}
					
				});
			}
		}
	};
  	setTimeout(function(){
  		client.writeLog('当前链接状态：'+M_SERVERSTATUS);
		client.writeLog('是否正在进行重连：'+M_ISRECONNECT);
  		if(!M_SERVERSTATUS && !M_ISFORCEONLINE){
  			if(!M_ISRECONNECT){
  				ChatUtil.postFloatNotice(social_i18n('FloatNotice5'), "info", options);
  			}
  		}
  		setTimeout(arguments.callee, 10000);
  	}, 10000);
  }
  
  function loadContextMenu(){
  	//重写上下文菜单
	document.oncontextmenu = function(evt){
		evt = evt || window.event;
		var targetObj = evt.target || evt.srcElement;
		if(from == 'pc'){
			if($(targetObj).hasClass('chatcontent')){
				var options = {
					menuList: [
							   	{ menuName: "粘贴", clickfunc: "$(this).hide();IMUtil.doPaste(null, event, '"+$(targetObj).attr('id')+"');"}
							  ],
					left: evt.clientX,
					top: evt.clientY
				};
				showRightMenu(targetObj, options);
			}
			return false;
		}
		// 屏蔽最近列表
		var $target = $(targetObj);
		if($target.hasClass('rightMenuItem')) {
			return false;
		}else if($target.closest('#recentListdiv').length > 0){
			return false;
		}
		// 屏蔽聊天窗口头像
		else if($target.closest('.chatHead').length > 0){
			return false;
		}
		return true;
	};
  }
  
  function loadOrgTreeInfo(){
  	loadIMDataList("hrmOrg");
  	loadIMDataList("hrmGroup");
  }
  
  var ClientSet = {};
  var SignInfo = {};
  var GroupChatSet = {};
  var DownloadSet = {};
  var WithdrawGlobal = {};
  var WebAndpcConfig ={};
  var websessionkey = "<%=websessionkey%>";
  var isxp =<%=isxp%>;
  function loadClientSetInfo(){
  	try{
		ClientSet=JSON.parse('<%=pcClientSettings%>');
		SignInfo=JSON.parse('<%=pcSignInfo.toString()%>');
		GroupChatSet=JSON.parse('<%=pcGroupChatSet.toString()%>');
		//检测pc端签到
		if(from == 'pc'){
			PcModels.doIMSign(1);
			PcModels.regSignStateListener();
		}
		//alert(PcClientSet.maxGroupMems);
		DiscussUtil.settings.MAX_MEMS = ClientSet.maxGroupMems;
	}catch(err){
		client.error("获取客户端设置错误",err);
	}
  }
  
  function dosearch(obj) {
	$(obj).parent().hide();
	var keyword = $(obj).text();
	$('#groupsearchinput').val(keyword);
	$('#groupsearchinput').parents('.searchRdiv').find('.searchbtn2').click();
  }
	
  function showSearchReulst(keyword){
	var searchpanel = $('.msgcenter .searchpanel');
	var left=24;
	var top=57;
	var param = {"operation":"searchGroupname","keyword":keyword}
		 
	displayLoading(1);
	$.post("/social/group/SocialGroupHtmlOperation.jsp",param,function(data){
		if(data == '')
		searchpanel.html(data);
	  	searchpanel.fadeIn(500);
	  	displayLoading(0);
	});
	
	searchpanel.css({"left":left,"top":top}).show();
	stopEvent();
  }
  
  function delImg(obj){
  	$(obj).parents(".imgitemdiv").remove();	
  	var imgCount = $(".imgBox .fsUploadProgress .imgitemdiv").length;
	if(imgCount<9 && 0<imgCount){
  		$(".imgBox .imgAdddiv").show();
  		$("#centerLeftbox").find('.appimg').addClass('appimg2');
  	}else {
  		$("#centerLeftbox").find('.appimg').removeClass('appimg2');
  	}
  }
  
  function remarkImgUploadCallback(contentTarget,docid,file){
  			//alert("file.id："+file.id);
  		var swffileid=file.id;
  		var swffile=$("#"+swffileid);
  		var url="/weaver/weaver.file.FileDownload?fileid="+docid;
  		$(".imgBox #"+swffileid+" .defimg").attr("src",url).attr("href",url);
  		$(".imgBox #"+swffileid+" .fileProgress").remove();
  		$(".imgBox #"+swffileid).attr("_imageid",docid);
  		
  		initFancyImg($(".imgBox #"+swffileid+" .defimg"));
  		
  		if($(".imgBox .fsUploadProgress .imgitemdiv").length==9){
  			$(".imgBox .imgAdddiv").hide();
  		}
  		
  		$("#centerLeftbox").find('.appimg').addClass('appimg2');
  }		
  
  function remarkAccUploadCalssback(contentTarget,docid,file){
  		$("#centerLeftbox").find('.appacc').addClass('appacc2');
  		
  		var swffileid=file.id;
  		var swffile=$("#"+swffileid);
  		$(".accBox #"+swffileid+" .fileProgress").remove();
  		$(".accBox #"+swffileid).attr("_accid",docid);
  		
  }
  
  //解散群或者退出群删除群菜单
  function delGroupMenuItem(groupid){
  	$("#chat_1_"+groupid).remove();
  }
  
  // 更新个性签名
  function updateSearchSignatures(signatures) {
  	for(var id in signatures) {
        if(userInfos[id]){
         	userInfos[id].signatures=signatures[id];
        }
        //添加个性签名
        var chatItemObj = $("#imSearchList").find(".chatItem[_targetid='"+id+"']");
		if(signatures[id]==""){
			chatItemObj.find(".itemcenter").find(".signatures").remove();
		}else{
			chatItemObj.find(".itemcenter").find(".signatures").bind('mouseenter',function(event){
				 var mainid = $(this).parent().parent().parent().attr("_targetid");	
				 var top = event.clientY;
				 var left = event.clientX;
				 try{
				 	var signTitle=userInfos[mainid].signatures;
				 }catch(err){
				 	var signTitle="";
				 }
				 if(countByte(signTitle)>=42){
				 	$("#imSignaturesTitle").css("left", left-150);
				 }else if(countByte(signTitle)>=34){
					$("#imSignaturesTitle").css("left", left-130);
				 }else if(countByte(signTitle)>=26){
				 	$("#imSignaturesTitle").css("left", left-110);
				 }else{
				 	$("#imSignaturesTitle").css("left", left-80);
				 }						  
				 $("#imSignaturesTitle").css("top", top-65);
				 $("#imSignaturesTitle").find('#signTitle').html(signTitle);
				 $("#imSignaturesTitle").css('display','block');
			}).bind('mouseleave',function(){
				$("#imSignaturesTitle").hide();
			})
		}
     }
  }
  
  // 更新手机号
  function updateSearchMobileShow(mobileshows) {
  	var ms = "";
  	for(var id in mobileshows) {
        ms = mobileshows[id];
        if(userInfos[id]){
         	userInfos[id].mobileshow=ms;
        }
        var chatItemObj = $("#imSearchList").find(".chatItem[_targetid='"+id+"']");
		if (ms != "") {
			chatItemObj.find('.mobile').text(ms);
		}
     }
  }
   
  //加载查询列表
  function renderViewList(data) {
  		$("#searchResultListDiv>.imSearchList").html(data);
		var searchRestSize = parseInt($("#hrmListSize").val());
		var chatItems = $("#imSearchList").find('.chatItem');
		var len = chatItems.length;
		chatItems.off().on("click", function(){
			showConverChatpanel(this);
		}).on("dblclick", function(){clearTimeout($(this).data('timerid'));});
		var tempidary = [], $item;
		for(var i = 0; i < len; ++i){
			$item = $(chatItems[i]);
			var targetid = $item.attr("_targetid");
           	var targettype = $item.attr("_targettype");
           	// 只更新4页的个性签名
            if(targettype==0 && i <= 32){
            	tempidary.push(targetid);
            }
		}
		if(tempidary.length > 0){
			$.post("/social/im/SocialIMOperation.jsp?operation=updateCardInfo",{"userids":tempidary.join(',')},function(data){
            	var cardInfo = $.trim(data);
            	var cardInfoObj = $.parseJSON(cardInfo);
            	var signatures = cardInfoObj.signature;
            	var mobileshow = cardInfoObj.mobileshow;
            	
            	if(mobileshow) {
            		updateSearchMobileShow(mobileshow);
            	}
            	
            	if(!signatures && tempidary.length == 1){
            		$("#imSearchList").find('.signatures').remove();
            	}else
            		updateSearchSignatures(signatures);
			})
		}
		if(searchRestSize <= 0) {
                // 未查到联系人
			showEmptyResultDiv(1, "imSearchList", "<%=SystemEnv.getHtmlLabelName(126861,user.getLanguage())%>", 200);
		}else{
			showEmptyResultDiv(0, "imSearchList", "");
		}
  }
  
  // 查询服务端
  function getRemoteSearch(keyword, target, cb) {
  	var url = "/social/im/SocialIMLeft.jsp?menuType="+target+"&keyword="+keyword;
    $.post(encodeURI(url),function(data){
  		if(typeof cb !== 'undefined'){
  			cb(data);
  		}
  	});
  }
  // 查询本地缓存数组
  function searchUserInfos(keyword) {
  	// console.time('testsearch');
	var item, mobile, py, userName,status,flag, result={}, dismissionStatus= ['4', '5', '6', '7'], count = 0;
	for(var id in userInfos){
		item = userInfos[id];
		status = item.status;
		flag = item.flag;
		if(!item || isNaN(parseInt(id)) || id == '1' || 
			(typeof status != 'undefined' && dismissionStatus.indexOf(status) != -1) || 
			typeof flag != 'undefined' && flag == 1){
			continue;
		}
		userName = item.userName?item.userName.toLowerCase():"";
		py = item.py?item.py.toLowerCase():"";
		mobile = item.mobileShow?item.mobileShow:"";
		keyword = keyword.toLowerCase();
		if(userName.indexOf(keyword) != -1 || py.indexOf(keyword) != -1 || mobile.indexOf(keyword) != -1) {
			result[id] = item;
			// 搜索到32条数据就不搜了
			if(++count > 32) {
				break;
			}
		}
	}
	// console.timeEnd('testsearch');
	// console.log('轮询次数：', testCount);
	return result;
}
  // 查询本地缓存
  function getLocalTempSearch(keyword, target, cb) {
  	// 开启了分权? 就用服务端查询吧
  	if(!IS_USE_APPDETACH && WebWorker.supportWebWorker()){
		/*
  		WebWorker.startWorker("UserInfoSearcher", 
  			"/social/im/js/workers/UserInfoSearcher.js", 
  			{'keyword':keyword, 'userInfos': userInfos}, 
  			function(data){
  				handleData(data);
  			});
		*/
		handleData(searchUserInfos(keyword));
		function handleData(data) {
			var size = IMUtil.getObjectLen(data);
			var htmls = "";
			var item;
			for(var i in data){
				item = data[i];
				var chatItem = $('#tempSearchHrmItem').clone().removeAttr('id').show();
				chatItem.attr('_targetid', item.userid);
				chatItem.attr('_targetName', item.userName);
				chatItem.attr('_targetHead', item.userHead);
				chatItem.find('.head35').attr('src', item.userHead);
				chatItem.find('.name').text(item.userName);
				chatItem.find('.deptName').text(item.deptName);
				chatItem.find('.mobile').text(item.mobileShow);
				chatItem.find('.subName').text(item.jobtitle);
				htmls+=chatItem[0].outerHTML;
			}
			// 添加群组
			var groupItems = $('#recentListdiv').find(".chatItem[_targettype='1']"), groupName, tmpGroupName;
			for(var j = 0; j < groupItems.length; ++j){
				var $self = $(groupItems[j]);
				groupName = $self.attr('_targetname');
				tmpGroupName = groupName.toLowerCase();
				if(tmpGroupName.indexOf(keyword.toLowerCase()) != -1){
					var groupChatItem = $('#tempSearchGroupItem').clone().removeAttr('id').show();
					groupChatItem.attr('_targetid', $self.attr('_targetid'));
					groupChatItem.attr('_targetName', $self.attr('_targetname'));
					groupChatItem.attr('_targetHead', $self.attr('_targethead'));
					groupChatItem.find('.itemleft>img').attr('src', $self.attr('_targethead'));
					groupChatItem.find('.groupName').text( $self.attr('_targetname'));
					htmls+=groupChatItem[0].outerHTML;
					size++;
				}
			}
			htmls += "<input type='hidden' id='hrmListSize' value='"+size+"' />"
			if(typeof cb !== 'undefined'){
				cb(htmls);
			}
		}
  	}else{
  		// 不支持web worker，还用老的查询
  		getRemoteSearch(keyword, target, cb);
  	}
  }
  
 //加载通讯录数据
  function loadIMDataList(target, force){
      if(target=='discuss'&&!$('.imToptab').find('.tabitem[_target=discuss]').hasClass('activeitem')){
          return;
      }
  	  if("<%=isGroupChatForbit?"1":"0"%>" == '1' && target == 'discuss'){
  	  	 console.log("群聊被禁止");
	  	 return;
	  }
  	  if(target=="hrmOrg"||target=="hrmGroup"){
  	  		$("#contactListdiv .hrmOrg").hide();
  	  		var targetHrmTree = $("#"+target+"Tree");
  	  		targetHrmTree.show();
  	  		if($("#"+target+"Tree").html() == '' || !!force){
  	  			if(!!force){
  	  				targetHrmTree.empty();
  	  			}
  	  			if(target == 'hrmOrg' && targetHrmTree.data('loading') && !force) {
  	  				return;
  	  			}else{
  	  				targetHrmTree.data('loading','loading');
  	  			}
  	  			targetHrmTree.treeview({
			       url:"/social/im/SocialHrmOrgTree.jsp?operation="+target
			    });
  	  		}
  	  		$("#contactListdiv .chatItem").remove();
  	  }else if(target=="recent"){ //最近
  			
      }else if(target=="tempSearch") {
      		var keyword = getKeyword();
      		
      		// 先查询本地缓存
      		getLocalTempSearch(keyword, target, function(data){
      			renderViewList(data);
      		});
      }else{
    	  //暂时先隐藏群聊分组功能
    	  var isDiscussList=true;
    	  var isopenfire = (IS_BASE_ON_OPENFIRE && IS_BASE_ON_OPENFIRE == true) ? 1 : 0;
    	  if(!isDiscussList)
    		{  
  		  	$.post("/social/im/SocialIMLeft.jsp?menuType="+target, {isopenfire : isopenfire},function(data){
  		  		if(target=="discuss"){	  			
  		  			$("#discussListdiv").html(data);
  		  			$("#discussListdiv .chatItem").off().on("click", function(){
  			  			showConverChatpanel(this);
  			  		}).on("dblclick", function(){clearTimeout($(this).data('timerid'));});  			
  		  	  }else{
                  $("#contactListdiv .hrmOrg").hide();
                  $("#"+target+"Conb .chatItem").remove();
                  if($('#imConTabs .conActItem').attr('_target') === target) {
                      $("#"+target+"Conb").append(data).show();
                  }
                  $("#contactListdiv .chatItem").off().on("click", function(){
                      showConverChatpanel(this);
                  }).on("dblclick", function(){clearTimeout($(this).data('timerid'));});
              }
  		  	});
    	}else{
            if(target=="discuss"){
            //初始化群组数
                var zTreeObj;
                var zNodes;
                var setting = {
                    async: {
                        enable: true,       //启用异步加载
                        dataType: "json",  //ajax数据类型
                        url: DiscussUtil.getDiscussAsyncUrl,   //ajax的url
                        asyncParam: ["id"]
                      },
                    isSimpleData: true,  
                    treeNodeKey: "id",
                    treeNodeParentKey: "pId",
                    view: {
                        expandSpeed: "fast",   //效果
                        dblClickExpand: false,   //屏蔽掉双击事件
                        selectedMulti: false //设置是否允许同时选中多个节点
                    },
                    callback: {
                        onRightClick:DiscussUtil.onDiscussRightClick,
                        onClick:DiscussUtil.onDiscussClick,
                        onAsyncSuccess :DiscussUtil.onAsyncSuccess
                    }};
                    zTreeObj = $.fn.zTree.init($("#discussTree"), setting, zNodes);
                  $("#discussListdiv").perfectScrollbar();
				  //空白区域右键群聊菜单
				  $("#discussListdiv").bind('mousedown',function(e){
					  var e = e|| window.event,
					  chooseTarget = e.target || e.srcElement;
					  //console.log(chooseTarget);
					  //console.log(chooseTarget.id);
					  if(chooseTarget.id=='discussListdiv'){
						//console.log(e.which);
						if(e.button==2){						
						var treeId = 'discussTree';
						var treeNode = $.fn.zTree.getZTreeObj("discussTree").getNodes()[0];
						DiscussUtil.onDiscussRightClick(e,treeId ,treeNode); 
					  } 
					  }					  
				  });
    		}else{
    			$.post("/social/im/SocialIMLeft.jsp?menuType="+target, {isopenfire : isopenfire},function(data){

                  $("#contactListdiv .hrmOrg").hide();
                  $("#"+target+"Conb .chatItem").remove();
                  
                  if($('#imConTabs .conActItem').attr('_target') === target) {
                      $("#"+target+"Conb").append(data).show();
                  }
                  $("#contactListdiv .chatItem").off().on("click", function(){
                      showConverChatpanel(this);
                  }).on("dblclick", function(){clearTimeout($(this).data('timerid'));});
                  
                  var memArr = new Array();
                  
                  $("#"+target+"Conb").find('.chatItem').each(function(index,obj){
                  	  var targetid = $(obj).attr("_targetid");
                  	  var targettype = $(obj).attr("_targettype");
                  	  if(targettype==0){
                  	    memArr.push(targetid);
                  	  	//添加个性签名
						var signatures = "";
    					try {
							signatures=userInfos[targetid].signatures;
						}catch(err){
							signatures="";
						}
						if(signatures==""){
							$(obj).find(".itemcenter").find(".signatures").remove();
						}else{
							//$(obj).find(".itemcenter").find(".signatures").attr("title",signatures);
							$(obj).find(".itemcenter").find(".signatures").bind('mouseenter',function(event){
								 var mainid = $(this).parent().parent().parent().attr("_targetid");	
								 var top = event.clientY;
	  							 var left = event.clientX;
	  							 try{
	  							 	var signTitle=userInfos[mainid].signatures;
	  							 }catch(err){
	  							 	var signTitle="";
	  							 }
	  							 if(countByte(signTitle)>=42){
	  							 	$("#imSignaturesTitle").css("left", left-150);
	  							 }else if(countByte(signTitle)>=34){
	  								$("#imSignaturesTitle").css("left", left-130);
	  							 }else if(countByte(signTitle)>=26){
	  							 	$("#imSignaturesTitle").css("left", left-110);
	  							 }else{
	  							 	$("#imSignaturesTitle").css("left", left-80);
	  							 }						  
	  							 $("#imSignaturesTitle").css("top", top-65);
	  							 $("#imSignaturesTitle").find('#signTitle').html(signTitle);
	  							 $("#imSignaturesTitle").css('display','block');
							
							}).bind('mouseleave',function(){
								$("#imSignaturesTitle").hide();
							})
						}
                  	  }
                  
                  });
                  OnLineStatusUtil.getUserOnlineStatus(memArr);
    			});
     }
  }
  }
}
  function closeAddress(){
	$("#addressdiv",window.parent).hide();
	$("#IMbg",window.parent).hide();
  }
  
</script>

