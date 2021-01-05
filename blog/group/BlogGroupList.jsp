<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="gms" class="weaver.blog.service.BlogGroupService" scope="page" />
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<link href="/blog/css/base_wev8.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js"></script>
<style>
	.footwall UL{margin-left: 0px;float:left;padding-left: 0px; }
	.footwall SPAN.line {
		LINE-HEIGHT: 17px; DISPLAY: block; CLEAR: left; FONT-SIZE: 12px;text-align:left;
	}
	.footwall A.figure {
		DISPLAY: block; FLOAT: left
	}
	.footwall .info {
		PADDING-LEFT: 8px; DISPLAY: block; FLOAT: left
	}
	.footwall .info .gray-time {
		COLOR: #808080;
		width:90px;
	    text-overflow:ellipsis; 
	    white-space:nowrap; 
	    overflow:hidden;
	}
	.footwall .info A.addfriend {
		LINE-HEIGHT: 17px; PADDING-LEFT: 13px; DISPLAY: inline-block; BACKGROUND: url(http://s.xnimg.cn/imgpro/icons/plus-green_wev8.png) no-repeat left center
	}
	.footwall .action-triger {
		POSITION: absolute; WIDTH: 18px; DISPLAY: block; BACKGROUND: url(http://s.xnimg.cn/imgpro/icons/arrow-down_wev8.png) no-repeat center 50%; HEIGHT: 16px; TOP: 0px; RIGHT: 0px
	}
	.footwall .visible {
		BACKGROUND-COLOR: #b8d4e8; VISIBILITY: visible !important
	}
	.footwall .round-border {
		BORDER-BOTTOM: #83acc6 0px solid; BORDER-LEFT: #83acc6 1px solid; BACKGROUND-COLOR: white; BORDER-TOP: #83acc6 1px solid; BORDER-RIGHT: #83acc6 1px solid
	}
	.footwall img{border:0px;}
	
	.footwall .LIhover,.footwall .LInormal,.footwall .LIselected {
		WIDTH: 180px;DISPLAY: block; FLOAT: left; HEIGHT: 145px; OVERFLOW: hidden;
		padding-top:12px;
	}
	
	.footwall .LIdiv {
		POSITION: relative; width:166px;
	}
	
	.footwall .LInormal .LIdiv{
			border:solid 2px #dddddd;margin-right: 8px;
			padding:8px 0px 0px 8px;
	}
		
	.footwall .LIhover .LIdiv,.footwall .LIselected .LIdiv{
			border:solid 2px #3fbfff;margin-right: 8px;
			padding:8px 0px 0px 8px;
	}
		
	.footwall .selected_icon {
		background: url("/blog/images/attention_nocheck_wev8.png") no-repeat;
		top: -10px; 
		width: 21px; 
		height: 21px; 
		right: -5px; 
		overflow: hidden; 
		display: none; 
		position: absolute;
		cursor:pointer;
	}
	.footwall .LIhover .selected_icon{
		display: block;
	}
	
	.footwall .LIselected .selected_icon{
		background: url("/blog/images/attention_check_wev8.png") no-repeat;
		display: block;
	}
	
	.groups {
		border-style: solid;
		border-color: #BBB;
		border-width: 1px;
		border-radius: 3px;
		display:none;
	}
	.groupiteam {
		height: 26px;
		background-color: #F6F6F6;
		color: black;
		padding: 0px 10px 0px 10px;
		line-height: 25px;
	}
	.groupiteamhover {
		background-color: #E6E6E6;;
	}
	.li_decimal{ 
		 list-style-type:decimal ; 
		 list-style-position: inside;
		 float:left;
		 width:135px;
		 color:#666;
	 }
	 .overText{
		display:inline-block;
		overflow: hidden;
		white-space: nowrap;
		-o-text-overflow: ellipsis; /*--4 opera--*/
		text-overflow: ellipsis;
	 }
	 #hidedivmsg{padding-top:10px;}
	 .footwall .LIdiv {
			POSITION: relative; width:186px;
	 }
	 .footwall .LIhover,.footwall .LInormal,.footwall .LIselected {
			WIDTH: 200px;DISPLAY: block; FLOAT: left; HEIGHT: 145px; OVERFLOW: hidden;
			padding-top:12px;
	 }
	 
	 .norecord {
	    margin-top: 20px;
	    padding-bottom: 20px;
	    width: 100%;
	    text-align: center
	}
</style>

<%
	String groupid = Util.null2String(request.getParameter("groupid"));
	String imagefilename = "/images/hdReport_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(81313,user.getLanguage())+SystemEnv.getHtmlLabelName(19653,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	Map group=gms.getGroupsById(groupid);
	String groupName=Util.null2String(group.get("groupname"));
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>			
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

</head>
	<body>
		<div style="margin-top:10px;margin-right:10px;text-align:right;">
			
			<%if(!groupid.equals("all")&&!groupid.equals("nogroup")){%>
				<span name="all" title="<%=SystemEnv.getHtmlLabelName(81296,user.getLanguage())%>" style="font-size: 12px;cursor: pointer;">
					<input id="moveToGroup" target="#moveGroups" class="e8_btn_top middle" onclick="moveToGroup(this,event)" type="button" value="<%=SystemEnv.getHtmlLabelName(81296,user.getLanguage()) %>"/>
				</span>
			<%}%>
			<span name="union" title="<%=SystemEnv.getHtmlLabelName(31267,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input id="copyToGroup" target="#copyGroups" class="e8_btn_top middle" onclick="copyToGroup(this,event)" type="button" value="<%=SystemEnv.getHtmlLabelName(31267,user.getLanguage()) %>"/>
			</span>
			<span name="all" title="<%=SystemEnv.getHtmlLabelName(30131,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
					<input id="deleteContact" class="e8_btn_top middle" onclick="addGroup()" type="button"value="<%=SystemEnv.getHtmlLabelName(30131,user.getLanguage()) %>"/>
			</span>
			<%if(!groupid.equals("all")&&!groupid.equals("nogroup")){%>
				<span name="all" title="<%=SystemEnv.getHtmlLabelName(93149,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
					<input id="deleteContact" class="e8_btn_top middle" onclick="editGroup()" type="button"value="<%=SystemEnv.getHtmlLabelName(125559,user.getLanguage()) %>"/>
				</span>
				<span name="all" title="<%=SystemEnv.getHtmlLabelName(83150,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
					<input id="deleteContact" class="e8_btn_top middle" onclick="deleteContacts()" type="button"value="<%=SystemEnv.getHtmlLabelName(83150,user.getLanguage()) %>"/>
				</span>
				
				<span name="all" title="<%=SystemEnv.getHtmlLabelName(30908,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
					<input class="e8_btn_top middle" onclick="deleteGroup(<%=groupid%>)" type="button"	
						value="<%=SystemEnv.getHtmlLabelName(30908,user.getLanguage()) %>"/>
				</span>
			<%}%>
		</div>
		<div class="relative p-t-15">
			<div id="myAttentiondiv">
			</div>
		</div>
		
		
		<!-- Load组列表 -->
		<div id="moveGroups" class="absolute  w-120 maxh-400 ofy-scroll groups" style="position: absolute;">
			<div id="groupContain"></div>
			<div class="w-all groupiteam hand" method="cmtg" onclick="addGroup(this)">
				<span class="overText w-90"><%=SystemEnv.getHtmlLabelName(31194,user.getLanguage()) %></span>
			</div>
		</div>
		<!-- Load组列表 -->
		<div id="copyGroups" class="absolute  w-120 maxh-400 ofy-scroll groups" style="position: absolute;">
			<div id="groupContain"></div>
			<div class="w-all groupiteam hand" method="cctg" onclick="addGroup(this)">
				<span class="overText w-90"><%=SystemEnv.getHtmlLabelName(31195,user.getLanguage()) %></span>
			</div>
		</div>
		
		<div  id="hidedivmsg" class="hide">
			<div style="height: 100%">
				<ul style="overflow: auto;" id="srzulid">
				</ul>
			</div>
		</div>
		
	</body>
	
	
	<script type="text/javascript">
	
	var groupid="<%=groupid%>";
	var groupName="<%=groupName%>";
	
	jQuery(document).ready(function() {
		reLoadGroups("<%=groupid %>");
		reLoad();
		
		$(document.body).click(function(){
			hideGroups();
		});
		
	});
	
	function hideGroups(){
		$("div.groups").hide();
	}
	
	function reLoad(){
		$("#myAttentiondiv").load("/blog/group/BlogGroupHrm.jsp?userid=<%=user.getUID()%>&groupid=<%=groupid%>");
	}
	
	//刷新【移动到组】和【复制到组】中的组列表
	function reLoadGroups(currentGroup) {
		var param = {"currentGroup": currentGroup,"method":"getGroupList"};
		$.get("/blog/group/BlogGroupOperation.jsp", param, function(data) {
			var _moveGroups = $("#moveGroups").find("#groupContain");
			var _copyGroups = $("#copyGroups").find("#groupContain");
			_moveGroups.html(data);
			_copyGroups.html(data);
			initMoveToGroup(_moveGroups);
			initCopyToGroup(_copyGroups);
			
			inithover();
		});
		
		function inithover() {
			var _groupiteam = $("div.groupiteam");
			_groupiteam.mouseover(function() {
				$(this).addClass("groupiteamhover");
			});
			_groupiteam.mouseout(function(){
				$(this).removeClass("groupiteamhover");
			});
		}
	}
	
	//智能显示被隐藏的组列表
	function capacity(himself) {
		var _position = parent.parent.$(himself).offset();
		var _targer = parent.parent.$(himself).attr("target");
		$(_targer).css({top:_position.top+25, left: _position.left});
		$("div.groups").each(function() {
			if(this != $(_targer)[0]) {
				$(this).hide();
			}
		});
		$(_targer).toggle();
	}
	
	//移动到组
	function moveToGroup(himself,event){
		stopEvent(event);
		capacity(himself);
	}
	
	//移动到组 
	function initMoveToGroup(groups){
		$(groups).find("div").bind("click", function(){
			var gourp = this;
			var contactsId = getContactsId();
			
			if(contactsId.length != 0) {
				var param = {"idSet": contactsId.toString(), "sourceGroup": <%=groupid %>, "destGroup": gourp.id, "method": "move"};
				$.post("/blog/group/BlogGroupOperation.jsp", param, function(){
					window.parent.refreshTreeSed();
					reLoad(); //重新加载当前联系人列表
				});
			} else {
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81308,user.getLanguage()) %>"); 
			}
		})
	}
	
	//复制到组
	function copyToGroup(himself,event){
		stopEvent(event);
		capacity(himself);
	}
	
	//复制到组
	function initCopyToGroup(groups){
		$(groups).find("div").bind("click", function(){
			var gourp = this;
			var contactsId = getContactsId();
			if(contactsId.length != 0) {
				var param = {"idSet": contactsId.toString(), "sourceGroup":"<%=groupid %>", "destGroup": gourp.id, "method": "copy"};
				$.post("/blog/group/BlogGroupOperation.jsp", param, function(){
					window.parent.refreshTreeSed();
					reLoad(); //重新加载当前联系人列表
				});
			} else {
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81308,user.getLanguage()) %>"); 
			}
		})
	}
	

	
	
	//获取被选中联系人id
	function getContactsId(){
		var _contactsId = new Array();
		$("#footwall_visitme .LIselected").each(function(){
			var _id = $(this).attr("_attentionid");
			if(_id != "")
				_contactsId.push(_id);
		});
		
		return _contactsId;
	}

	//阻止事件冒泡
	function stopEvent(event) {
		if (event.stopPropagation) { 
			// this code is for Mozilla and Opera 
			event.stopPropagation();
		} 
		else if (window.event) { 
			// this code is for IE 
			window.event.cancelBubble = true; 
		}
	}
	
	//删除组
	function deleteGroup(groupid){
		if(groupid=='all' || groupid=='nogroup') {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30909,user.getLanguage()) %>");
		} else {
			window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(83062,user.getLanguage()) %>？",function(){
				var param = {"id": groupid, "method": "delete"};
				$.get("/blog/group/BlogGroupOperation.jsp", param, function() {
					window.parent.refreshTreeSed(true);
				});
			});
		}
	}
	
	var diag;
	function addGroup(himself) {
	var _method = $(himself).attr("method");
	
	if(_method){
		
	}else{
		_method = "addGroup";
	}
	var contactsId =getContactsId();
	
	if(_method=="cmtg" || _method=="cctg") {
		if(contactsId.length==0) {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81308,user.getLanguage()) %>");
			return;
		}
	}
	
	diag = new window.top.Dialog();
	diag.Width = 300;
	diag.Height = 80;
	diag.Title = "<%=SystemEnv.getHtmlLabelName(81302,user.getLanguage()) %>";
	diag.InnerHtml = '<div id="groupEditor" style="padding-top: 30px;">' +
					 '<span><%=SystemEnv.getHtmlLabelName(81303 ,user.getLanguage()) %>：</span>' +
					 '<span><input type="text" maxlength="12" class="w-200" name="groupName"></span>' +
					 '</div>';
	if(_method == "addGroup") {
		diag.OKEvent = createGroup;		//点击确定后调用的方法
	} else if(_method == "cmtg") {
		diag.OKEvent = cmtg;			//点击确定后调用的方法
	} else if(_method == "cctg") {
		diag.OKEvent = cctg;			//点击确定后调用的方法
	}
	diag.okLabel = '<%=SystemEnv.getHtmlLabelName(826 ,user.getLanguage()) %>'; 
	diag.cancelLabel = '<%=SystemEnv.getHtmlLabelName(201 ,user.getLanguage()) %>';
	diag.show();
	
	//请求添加组
	function createGroup(){
		
		var _groupName = $.trim($(window.top.document).find("input[name=groupName]").val());
		if( _groupName == ""){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81311,user.getLanguage()) %>"); 
			return;
		}
		$("#_ButtonOK_0").attr("disabled",true);
		var para ={method: "add", groupName: _groupName};
		$.post("/blog/group/BlogGroupOperation.jsp", para, function(data){
			if(data == 0) {
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30910,user.getLanguage()) %>");
				$("#_ButtonOK_0").attr("disabled",false)
			} else if(data == 1) {
				window.parent.refreshTreeSed(); //重新加载左侧组列表
				diag.close();
			} else if(data == -1){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage()) %>");	
				$("#_ButtonOK_0").attr("disabled",false)
			}
		})
	}
	
	//请求新建并移动到组
	function cmtg() {
		var _groupName = $.trim($(window.top.document).find("input[name=groupName]").val());
		if( _groupName == ""){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81311,user.getLanguage()) %>"); 
			return;
		}
		$("#_ButtonOK_0").attr("disabled",true)
		var param ={"idSet": contactsId.toString(), "sourceGroup": groupid, "groupName": _groupName, method: "cmtg"};
		$.post("/blog/group/BlogGroupOperation.jsp", param, function(data){
			if(data == 0) {
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30910,user.getLanguage()) %>");
				$("#_ButtonOK_0").attr("disabled",false)
			} else if(data == 1) {
				window.parent.refreshTreeSed(); //重新加载左侧组列表
				reLoad(); //重新加载当前联系人列表
				diag.close();
			} else if(data == -1){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage()) %>");
				$("#_ButtonOK_0").attr("disabled",false)
			}
		})
	}
	//请求新建并复制到组
	function cctg() {
		var _groupName = $.trim($(window.top.document).find("input[name=groupName]").val());
		if( _groupName == ""){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81311,user.getLanguage()) %>"); 
			return;
		}
		$("#_ButtonOK_0").attr("disabled",true)
		var param ={"idSet": contactsId.toString(),  "groupName": _groupName, method: "cctg"};
		$.post("/blog/group/BlogGroupOperation.jsp", param, function(data){
			if(data == 0) {
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30910,user.getLanguage()) %>");
				$("#_ButtonOK_0").attr("disabled",false)
			} else if(data == 1) {
				window.parent.refreshTreeSed(); //重新加载左侧组列表
				reLoad(); //重新加载当前联系人列表
				diag.close();
			} else if(data == -1){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage()) %>");
				$("#_ButtonOK_0").attr("disabled",false)
			}
		})
	}
}

//修改分组信息
function editGroup() {
	var diag = new window.top.Dialog();
	diag.Width = 300;
	diag.Height = 80;
	diag.Title = "<%=SystemEnv.getHtmlLabelName(81302,user.getLanguage()) %>";
	diag.InnerHtml = '<div id="groupEditor" style="padding-top: 30px;">' +
					 '<span><%=SystemEnv.getHtmlLabelName(81303 ,user.getLanguage()) %>：</span>' +
					 '<span><input type="text" class="w-200" maxlength="12" name="groupName" value="<%=groupName%>" ></span>' +
					 '</div>';
	diag.ShowButtonRow=true;		
	
	diag.OKEvent = saveGroup;			//点击确定后调用的方法
	diag.show();
	
	//请求添加组
	function saveGroup(){
	
		var _groupName = $.trim($(window.top.document).find("input[name=groupName]").val());
		if( _groupName == ""){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81311,user.getLanguage()) %>"); 
			return;
		}
		$("#_ButtonOK_0").attr("disabled",true)
		var _param = {"method": "edit", "id": groupid, "groupName":_groupName};
		$.post("/blog/group/BlogGroupOperation.jsp", _param, function(data){
			
			if(data == 0) {
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30910,user.getLanguage()) %>");
			} else if(data == 1) {
				window.parent.refreshTreeSed();
				diag.close();
				
			} else if(data == -1){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage()) %>");	
				$("#_ButtonOK_0").attr("disabled",false)
			}
			
		})
	}
}

//从改组删除
function deleteContacts() {
	var contactsId =getContactsId();
	if(contactsId.length > 0){
		var diag = new window.top.Dialog();
		diag.Width = 300;
		diag.Height =80;
		diag.Title = "<%=SystemEnv.getHtmlLabelName(81299,user.getLanguage()) %>";
		
		diag.InnerHtml = '<div class="w-all h-all">' +
						 		'<div class="font14" style="position: relative;top: 29px;"><%=SystemEnv.getHtmlLabelName(31192,user.getLanguage()) %>？</div>' +
							 '</div>';
	
		diag.OKEvent = submitDelete;//点击确定后调用的方法
		diag.show();
	} else {
		alert("<%=SystemEnv.getHtmlLabelName(81305,user.getLanguage()) %>");
	}
	
	function submitDelete() {
		var param = {"idSet": contactsId.toString(), "sourceGroup": groupid, "method": "removeUser"};
		$.get("/blog/group/BlogGroupOperation.jsp", param, function(){
			window.parent.refreshTreeSed();
			reLoad(); //重新加载当前联系人列表 
			diag.close();
		});
	}
}


</script>
	
	
	
</html>