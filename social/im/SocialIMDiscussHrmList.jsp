
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>

<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
<script type="text/javascript" src="/js/ecology8/browserCommon_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/wuiform/jquery.wuiform_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<script type="text/javascript" src="/js/init_wev8.js"></script>
 <script type="text/javascript" src="/wui/common/jquery/plugin/wuiform/jquery.wuiform_wev8.js"></script>
 
<script type="text/javascript" src="/social/js/jquery.tablesort/jquery.tablesort.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<jsp:include page="/social/im/SocialIMUtil.jsp"></jsp:include>
<html>
<head>
	<link rel="stylesheet" href="/social/css/im_wev8.css"/>
	<script src="/social/im/js/IMUtil_wev8.js"></script>	
	<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
</head>
<%
	String titlename = Util.null2String(request.getParameter("discussName"));
	String discussid = Util.null2String(request.getParameter("discussid"));
	String creatorid = Util.null2String(request.getParameter("creatorid"));
	String isdisableadduser = Util.null2String(request.getParameter("isdisableadduser"));
	String IS_BASE_ON_OPENFIRE = Util.null2String(request.getParameter("IS_BASE_ON_OPENFIRE"));
	
	String userid = "" + user.getUID();
	
	creatorid = creatorid.substring(0, creatorid.indexOf("|"));
	
	boolean isCreator = userid.equals(creatorid);
%>

<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="social"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>

<div class="zDialog_div_content" style="height:430px;">

<form id="mainForm" action="/social/group/SocialGroupMemberList.jsp" method="post">
	<input type="hidden" name="discussid" value="<%=discussid%>">
	<wea:layout attributes="{layoutTableId:topTitle}">
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
				<%if("true".equals(IS_BASE_ON_OPENFIRE) && !"true".equals(isdisableadduser)) {%>
			<input class="e8_btn_top middle" onclick="addMember()" type="button" value="<%=SystemEnv.getHtmlLabelName(83476, user.getLanguage())%>"/><!-- 添加 -->
				<% }%>
			<%if(isCreator) {%>
				<input class="e8_btn_top middle" onclick="delMember()" type="button" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"/><!-- 删除 -->
				<%if(IS_BASE_ON_OPENFIRE.equals("true")) {%>
				<input class="e8_btn_top middle" id = "setgroupadminBtn" style="cursor:not-allowed;" onclick="setGroupAdmin()" type="button" value="转让群主身份"/><!-- 转让群 -->
				<%}%>
				<input class="e8_btn_top middle" style="display:none;" onclick="destoryGroup('<%=discussid%>')" type="button" value="<%=SystemEnv.getHtmlLabelName(126972, user.getLanguage())%>"/><!-- 解散群 -->
			<%}else {%>
				<input class="e8_btn_top middle" onclick="quitGroup()" type="button" value="<%=SystemEnv.getHtmlLabelName(126952, user.getLanguage())%>"/><!-- 退出群 -->
			<%} %>
				<input type="text" class="searchInput" name="lastname"  value=""/>
				<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
			</wea:item>
		</wea:group>
	</wea:layout>
	<TABLE id="groupHrmList" class=ListStyle cellspacing=1>
	  <COLGROUP>  
	  <COL width="5%">
	  <COL width="5%">
	  <COL width="20%">
	  <COL width="35%">
	  <COL width="35%">
	  <THEAD>
	  <TR class=HeaderForXtalbe>
	  <th class="no-sort">
	  	<%if(isCreator) {%>
	  		<input type="checkbox" onchange="doSelectAll(this)">
	  	<%} %>
	  </th>
	  <th class="no-sort"></th>
	  <th><%=SystemEnv.getHtmlLabelName(125212, user.getLanguage())%></th><!-- 成员 -->
	  <th><%=SystemEnv.getHtmlLabelName(124, user.getLanguage())%></th><!-- 部门 -->
	  <th><%=SystemEnv.getHtmlLabelName(6086, user.getLanguage())%></th><!-- 岗位 -->
	  </tr>
	  <TBODY></TBODY>
	  </THEAD>
	</TABLE>
</form>

</div>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 

</body>
</html>
<script type="text/javascript">

var creatorid= '<%=creatorid%>';
var IS_BASE_ON_OPENFIRE = '<%=IS_BASE_ON_OPENFIRE%>';
var parentWin=parent.getParentWindow(window);
var ncFlag = parentWin.ChatUtil.isFromPc()&&parentWin.WindowDepartUtil.isAllowWinDepart();
jQuery(document).ready(function(){

	jQuery("#topTitle").topMenuTitle({searchFn:searchMembers});
	jQuery("#hoverBtnSpan").hoverBtn();
	jQuery('#groupHrmList').jNice();
	$('.zDialog_div_content').perfectScrollbar();
	
	discussid="<%=discussid%>";
	userinfos = parentWin.userInfos;
	M_SERVERCONFIG = typeof parentWin.M_SERVERCONFIG==="object"?parentWin.M_SERVERCONFIG:{};
	userids = getMemberids(userinfos);
	discussUsers = getDiscussUsers(discussid);
	dismissionStatus = parentWin.ChatUtil.settings.dismissionStatus;
	loadMembers(discussid, getMemberids(discussUsers));	
	// 绑定排序方法
	bindSortEvent();
});

function bindSortEvent() {
	$('#groupHrmList').tablesort().data('tablesort');
}
//获取指定群的人员信息
function getDiscussUsers(discussid) {
	var discuss = parentWin.discussList[discussid];
	if(discuss){
	   var temp = [], memberid, memberids = discuss.getMemberIdList();
	}else{
	   var temp = [], memberid, memberids = parentWin.NewDiscussUtil.getMemberIdList(discussid);
	}
	
	temp.push(userinfos[creatorid]);//创建人放首位
	for(var i = 0; i < memberids.length; ++i){
		memberid = memberids[i];
		memberid = parentWin.getRealUserId(memberid);
		if((memberid in userinfos) && memberid != creatorid)
			temp.push(userinfos[memberid]);
	}
	return temp;
}

function getMemberids(userinfos) {
	var temp = [];
	for(var i = 0; i < userinfos.length; ++i){
		temp.push(userinfos[i].userid);
	}
	return temp;
}

function searchMembers(){
	var keyword = $.trim($('.searchInput').val());
	var memberids;
	if(keyword == ''){
		memberids = getMemberids(discussUsers);
		loadMembers(discussid, memberids);
		return;
	}
	var userinfo, tempids = [];
	for(var i = 0; i < discussUsers.length; ++i){
		userinfo = discussUsers[i];
		var iLastname = userinfo.userName.indexOf(keyword);
		var iDept = userinfo.deptName.indexOf(keyword);
		var iJob = userinfo.jobtitle.indexOf(keyword);
		if(iLastname != -1 || iDept != -1 || iJob != -1){
			tempids.push(userinfo.userid);
		}else if(userinfo.py){
			var testPy = userinfo.py.toLowerCase();
			var iPy = testPy.indexOf(keyword.toLowerCase());
			if(iPy != -1){
				tempids.push(userinfo.userid);
			}
		}
	}
	loadMembers(discussid, tempids);
}

//从userinfos里获取人员的相关信息
function getFiltedList(memberids){
	var memberid, temp = [];
	if($.inArray(creatorid, memberids) != -1)
		temp.push(creatorid);
	for(var i = 0; i < memberids.length; ++i){
		memberid = memberids[i];
		if((memberid in userinfos) && memberid != creatorid){
			temp.push(memberid);
		}
	}
	return temp;
}	

function appendListRow(userinfo) {
	var _tbody = $('#groupHrmList').find('tbody');
	var dhtml = "<tr CLASS=DataDark>";
	var resourceid=userinfo.userid;
	var status = userinfo.status;
	if(userinfo.userid != creatorid && 'true' == '<%=isCreator%>'){
		dhtml += "<td><input type=\"checkbox\" onclick =\"showSetGroupAdiminBtn()\"><input type=\"hidden\" value=\"" + userinfo.userid + "\"/></td>";
	}else{
		dhtml += "<td><input type=\"hidden\" value=\"" + userinfo.userid + "\"/></td>";
	}
    //创建人
	dhtml += 
		"<td>"+
			(resourceid==creatorid?"<img src='/social/images/group_creater_wev8.png' width='16px' title='<%=SystemEnv.getHtmlLabelName(882, user.getLanguage())%>'></img>":"")+
		"</td>"+
		"<td>" +userinfo.userName + ((parentWin.IMUtil.contains(dismissionStatus, status))?
			"<span style='border:1px solid #c8c8c8;border-radius:3px;margin-left:10px;padding:0 4px;color:#c8c8c8;'>离职</span>":"") + "</td>" +
		"<td>" + (userinfo.deptName?userinfo.deptName:"") + "</td>" +
		"<td>" + (userinfo.jobtitle?userinfo.jobtitle:"") + "</td>" + 
		"</tr>";
	_tbody.append(dhtml);
}
//去除'|'
function getRealIds(memberids) {
	var temp = [], memberid;
	for(var i = 0; i < memberids.length; ++i){
		memberid = memberids[i];
		memberid = parentWin.getRealUserId(memberid);
		temp.push(memberid);
	}
	return temp;
}

function getUserinfoByids(userids) {
	var userid, temp = [];
	for(var i = 0; i < discussUsers.length; i++){
		userid = discussUsers[i].userid;
		if($.inArray(userid, userids) != -1){
			temp.push(discussUsers[i]);
		}
	}
	return temp;
}

function loadMembers(discussid, memberids) {
	memberids = getRealIds(memberids);
	var tempids = getFiltedList(memberids);
	var temp = getUserinfoByids(tempids);
	$("#groupHrmList tbody tr").remove();
	for(var i = 0; i < temp.length; i++){
		appendListRow(temp[i]);
	}
	jQuery('body').jNice();
	showSetGroupAdiminBtn();
}

function addMember(){
	var selectedids = "";
    var discuss = parentWin.discussList[discussid];
    var MemIdArray = discuss.getMemberIdList();
    if(MemIdArray.length > parseInt(parentWin.ClientSet.maxGroupMems)){
       parentWin.showImAlert(parentWin.social_i18n('GroupMemberLimit'));
       return;
    }
    var realUserId = "", creatorId=parentWin.getRealUserId(discuss.getCreatorId());
    for(var i = 0; i < MemIdArray.length; ++i) {
    	realUserId = parentWin.getRealUserId(MemIdArray[i]);
    	var memberinfo=parentWin.getUserInfo(realUserId);
		var status = memberinfo.status;
		if(parentWin.IMUtil.contains(parentWin.ChatUtil.settings.dismissionStatus, status)) {
			continue;
		}
		if(creatorId == realUserId) {
			continue;
		}
    	selectedids += (","+realUserId);
    }
	selectedids = creatorId + selectedids;
	showModalDialogForBrowser(event,'/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?' +
			'selectedids='+selectedids,'#','resourceid',false,1,'',
	{
		name:'resourceBrowser',
		hasInput:false,
		zDialog:true,
		needHidden:true,
		dialogTitle:'人员',
		arguments:'',
		_callback:resourceBrowserCallback
	});
}

function getCheckedIds(){
	var _tbody = $('#groupHrmList').find('tbody');
	var rows = _tbody.children('tr');
	var ids = [];
	var firstTd;
	for(var i = 0; i < rows.length; ++i){
		firstTd = $(rows[i]).find('td:first');
		var chk = firstTd.find(':checkbox');
		if(chk.attr('checked')){
			ids.push(firstTd.find('input[type=hidden]').val());
		}
	}
	return ids;
}

function checkedCreator(ids) {
	for(var i = 0; i < ids.length; ++i){
		if(creatorid == ids[i]){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126973, user.getLanguage())%>"); //您不能删除自己
			return true;
		}
	}
	return false;
}

function delMember(){
	var ids= getCheckedIds();
	if(ids.length <= 0){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126974, user.getLanguage())%>");  //请选择要删除的人员
	}else{
		if(checkedCreator(ids))
			return;
            //确定删除人员？
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(126975, user.getLanguage())%>",function(){
			var memberids;
			debugger;
			for(var i = 0; i < ids.length; ++i){
			    if(ncFlag){
			         parentWin.ClientUtil.removeMemberFromDiscussion(discussid, parentWin.getIMUserId(ids[i]),function(idlist){
                        parentWin.ChatUtil.refreshDiscussioinInfo(discussid,function(discuss){
	                        discussUsers = getDiscussUsers(discussid);//刷新变量
	                        if(!memberids){
	                            memberids = discuss.getMemberIdList();
	                        }
	                        if(IS_BASE_ON_OPENFIRE == 'true'){
	                            memberids.removeValues(idlist);
	                        }
	                        loadMembers(discussid,memberids);
	                        parentWin.updateDiscussInfo(discussid);
	                    })
                    });
			    }else{
				parentWin.client.removeMemberFromDiscussion(discussid, parentWin.getIMUserId(ids[i]),function(idlist){
					parentWin.ChatUtil.refreshDiscussioinInfo(discussid,function(discuss){
						discussUsers = getDiscussUsers(discussid);//刷新变量
						if(!memberids){
							memberids = discuss.getMemberIdList();
						}
						if(IS_BASE_ON_OPENFIRE == 'true'){
							memberids.removeValues(idlist);
						}
						loadMembers(discussid,memberids);
						parentWin.updateDiscussInfo(discussid);	
					})
				});
				}
			}
	 	});
 	}
}


function resourceBrowserCallback(event,data,name,oldid){
	if (data!=null){
        if (data.id!= ""){
			 var resourceids = data.id.split(",");
			 resourceids = parentWin.AccountUtil.checkAccount(resourceids);
             // var memberids = "";
             // for (var i = 0; i < resourceids.length; i++) {
             //     memberids += "," + parentWin.getIMUserId(resourceids[i]);
             // }
             // memberids = memberids.substr(1);
             // var memList = memberids.split(",");
             var memList = [];

             //比较新加的人员和旧的人员是否重合，把相同的剔除
             var MemIdArray = parentWin.discussList[discussid].getMemberIdList();
             var temp = []; //临时数组1 
             var temparray = []; //临时数组2 
             var Memid = "";

             for (var i = 0; i < MemIdArray.length; i++) {
                 if (i == 0) {
                     Memid += parentWin.getRealUserId(MemIdArray[i]);
                 } else {
                     Memid += "," + parentWin.getRealUserId(MemIdArray[i]);
                 }

             }

             var MemList = Memid.split(",");


             for (var i = 0; i < MemList.length; i++) {
                 temp[MemList[i]] = true;
             };

             for (var i = 0; i < resourceids.length; i++) {
                 if (!temp[resourceids[i]]) {
                     temparray.push(resourceids[i]);
                 }
             }

             if (temparray.length == 0) {
                 window.top.Dialog.alert("你所添加的成员已在群组中", function() {});
                 return;
             }

             var Memids = "";
             for (var i = 0; i < temparray.length; i++) {
                 if (i == 0) {
                     Memids += parentWin.getIMUserId(temparray[i]);
                 } else {
                     Memids += "," + parentWin.getIMUserId(temparray[i]);
                 }
             }

             memList = Memids.split(",");
			parentWin.DiscussUtil.checkMemCount(memList, discussid, function(isOver){
				if(isOver){
                    // 超过   人的上限
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(27515, user.getLanguage())%>"+parentWin.DiscussUtil.settings.MAX_MEMS+"<%=SystemEnv.getHtmlLabelName(126966, user.getLanguage())%>");
					return;
				}else{
				    if(ncFlag){
						parentWin.ClientUtil.addMemberToDiscussion(discussid, memList, function(){
							parentWin.ChatUtil.refreshDiscussioinInfo(discussid,function(discuss){
								//刷新变量
								discussUsers = getDiscussUsers(discussid);
								var memberids = discuss.getMemberIdList();
								loadMembers(discussid,memberids);
								parentWin.updateDiscussInfo(discussid);
								//将改讨论组添加到被添加人员的通讯录中 1106 by wyw
								parentWin.IMUtil.addGroupBook(discussid,data.id,"add");
							})
						});
					}else{
					    parentWin.client.addMemberToDiscussion(discussid, memList, function(){
	                        parentWin.ChatUtil.refreshDiscussioinInfo(discussid,function(discuss){
	                            //刷新变量
	                            discussUsers = getDiscussUsers(discussid);
	                            var memberids = discuss.getMemberIdList();
	                            loadMembers(discussid,memberids);
	                            parentWin.updateDiscussInfo(discussid);
	                            //将改讨论组添加到被添加人员的通讯录中 1106 by wyw
	                            parentWin.IMUtil.addGroupBook(discussid,data.id,"add");
	                        })
                        });
					}
				}
			});
        }else{
        }
	 }
}

//解散群
function destoryGroup(discussid){
    // 确定解散该群？
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(126913, user.getLanguage())%>",function(){
 	});
}

//退出群
function quitGroup() {
    // 确定退出群？
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(126963, user.getLanguage())%>",function(){
	    if(ncFlag){
		    parentWin.ClientUtil.quitDiscussion(discussid,function(){
			//移除会话
			    var dlg = parent.getDialog(window);
			    parentWin.ChatUtil.closeConversation('1', discussid);
			    parentWin.ChatUtil.delDiscussBook(discussid);
			    parent.getDialog(window).close();
		    });
		}else{
		    parentWin.client.quitDiscussion(discussid,function(){
            //移除会话
                var dlg = parent.getDialog(window);
                parentWin.ChatUtil.closeConversation('1', discussid);
                parentWin.ChatUtil.delDiscussBook(discussid);
                parent.getDialog(window).close();
            });
		
		}
 	});  
}
  
//全选设置
function doSelectAll(obj) {
	var checkboxs = jQuery("input[type='checkbox']").each(function(){
		changeCheckboxStatus(this,!obj.checked);
 	});
	showSetGroupAdiminBtn();
}
//设置转让群组button状态 getCheckedIds
function showSetGroupAdiminBtn(){
	if(IS_BASE_ON_OPENFIRE!='true' || M_SERVERCONFIG.changeGroupAdmin !="1") {
        $("#setgroupadminBtn").hide();
	    return;
	};
	var ids= getCheckedIds();
	if(ids.length==1){
		$("#setgroupadminBtn").removeAttr("style")
							  .removeAttr("disabled")
							  .addClass("e8_btn_top")
							  .css({"background":"#FFFFFF",
									"color":"",
									"cursor":""});
	
						  
	}else{
		$("#setgroupadminBtn").removeAttr("style")
							  .removeClass("e8_btn_top")
							  .css({"background":"#d9d9d9",
									"color":"#ffffff",
									"cursor":"not-allowed",
									"padding-left":"10px",
									"padding-right":"10px",
									"height":"23px",
									"line-height":"23px",
									"border":"1px solid #aecef1",
									"margin-left":"-8px",
									"font-size":"12px"})
								.attr("disabled",true);		
		
	}
}
//转让该群
function setGroupAdmin(){
	var ids= getCheckedIds();	
	if(ids.length==1){
		var username;
		for(var i =0;i<discussUsers.length;i++){
			if(discussUsers[i].userid == ids[0]) username = discussUsers[i].userName;
		}
		window.top.Dialog.confirm("确定要将群主身份转让给 "+username+" 吗？",function(){
			parentWin.DiscussUtil.DiscussSetFunc.setDiscussionAdmin(discussid,ids,function(discuss){
				parent.getDialog(window).close();		
			});
 		});
	}else{
	  window.top.Dialog.alert("请确定已经选择了转让群的接收用户", function() {});
	}
}
</script>