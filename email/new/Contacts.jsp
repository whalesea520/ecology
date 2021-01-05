<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>

<html>
	<head>
		<link rel="stylesheet" href="/css/ecology8/request/leftNumMenu_wev8.css" type="text/css" />
		<script type="text/javascript" src="/js/ecology8/request/leftNumMenu_wev8.js"></script>
		<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
	</head>
<body scroll="no">


<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;"  >

	<tr>
		<td class="leftTypeSearch">
			<div class="topMenuTitle">
				<span class="leftType">
				<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"/></span>
				<span><%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %>
				</span>
				</span>
				<span class="leftSearchSpan">
					&nbsp;<input type="text" class="leftSearchInput" />
				</span>
				
			</div>
		</td>
		
		<td rowspan="2" style="height:100%">
			<iframe id="tabcontentframe" src="/email/new/ContactListFrame.jsp?mailgroupid=<%=Integer.MAX_VALUE%>" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		</td>
	</tr>
	
	<tr>
		<td style="width:23%;" class="flowMenusTd">
			<div class="flowMenuDiv"  >
				<div style="overflow:hidden;height:300px;position:relative;" id="overFlowDiv" >
					<div class="ulDiv" id="e8treeArea"></div>
				</div>
			</div>
		</td>
	</tr>
</table>
	
	</body>
</html>

<script>
	var currentGroup = <%=Integer.MAX_VALUE %>;
	
	window.typeid=null;
	window.workflowid=null;
	window.nodeids=null;
	window.notExecute = false;
	
	var groupName = null;
	wuiform.init=function(){
		wuiform.textarea();
		wuiform.wuiBrowser();
		wuiform.select();
	}
	
	var demoLeftMenus = "";
	
	function refreshTreeData(datatype){
		jQuery.ajax({
			url:"/email/new/GroupListLeftNew.jsp",
			async: true,
			beforeSend:function(){
				if(jQuery("#e8treeArea").children().length>0 && datatype == "frame"){
					return false;
				}
				if(jQuery(".leftTypeSearch").css("display") === "none");
				else
					e8_before2();
			},
			complete:function(){
				e8_after2();
			},
			success:function(data){
				jQuery(".ulDiv").html("");
				demoLeftMenus = eval('('+data+')');
				leftNumMenu();
				jQuery(".ulDiv").height(jQuery(".ulDiv").children(":first").height());
				window.setTimeout(function(){
					jQuery(".ulDiv").height(jQuery(".ulDiv").children(":first").height());
				},1000);
			}
		});
	}
	
	function leftNumMenu(){
		var	numberTypes={flowAll:{hoverColor:"#EE5F5F",color:"#EE5F5F",title:"<%=SystemEnv.getHtmlLabelName(16378,user.getLanguage()) %>"}};
		
		$(".ulDiv").leftNumMenu(demoLeftMenus,{
			numberTypes:numberTypes,
			showZero:false,
			menuStyles:["menu_lv1",""],
			expand:{
				url:function(attr,level){
					return attr.urlSum;
				},
				done:function(children,attr,level){
					jQuery(".ulDiv").height(jQuery(".ulDiv").children(":first").height());
					jQuery('#overFlowDiv').perfectScrollbar("update");
				}
			},
			clickFunction:function(attr,level,numberType){
				leftMenuClickFn(attr,level,numberType);
			}
		});
		var sumCount=0;
		$(".e8_level_2").each(function(){
			sumCount+=parseInt($(this).find(".e8_block:last").html());
		});
	}
	
	function leftMenuClickFn(attr,level,numberType){
		groupName = attr.name;
		currentGroup = attr.id;
		$(".flowFrame").attr("src","/email/new/ContactListFrame.jsp?mailgroupid="+attr.id+"&"+new Date().getTime());
	}
	
	function refreshChild(){
		document.getElementById('tabcontentframe').contentWindow.document.getElementById('tabcontentframe').contentWindow._table.reLoad();
	}
	
	
</script>



<script>


var diag = null;
var contactsId = null;

//打开添加组窗口
function addGroup(himself) {
	var _method = $(himself).attr("method");
	if(_method){
		
	}else{
		_method = "addGroup";
	}
	
	contactsId = document.getElementById('tabcontentframe').contentWindow.document.getElementById('tabcontentframe').contentWindow.getContactsId();
	if(_method=="cmtg" || _method=="cctg") {
		if(contactsId.length==0) {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81308,user.getLanguage()) %>");
			return;
		}
	}
	
	diag = new window.top.Dialog();
	diag.currentWindow = window;
	diag.Width = 400;
	diag.Height = 150;
	diag.Title = "<%=SystemEnv.getHtmlLabelName(30131,user.getLanguage()) %>";
	diag.URL = "/email/new/ContactsGroup.jsp?method="+_method;
			
	diag.show();
	
	document.getElementById('tabcontentframe').contentWindow.document.getElementById('tabcontentframe').contentWindow.jQuery("body").trigger("click")
}	
	
//请求添加组
function createGroup(_groupName){
	var para ={method: "add", groupName: _groupName};
	$.post("/email/new/GroupManageOperation.jsp", para, function(data){
		if(data == 0) {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30910,user.getLanguage()) %>");
		} else if(data == 1) {
			refreshTreeData("data");
			 //重新加载左侧组列表
			diag.close();
			
		} else if(data == -1){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage()) %>");	
			$("#_ButtonOK_0").attr("disabled",false)
		}
		
	})
}

//请求新建并移动到组
function cmtg(_groupName) {
	var param ={"idSet": contactsId.toString(), "sourceGroup": currentGroup, "groupName": _groupName, method: "cmtg"};
	$.post("/email/new/ContactManageOperation.jsp", param, function(data){
		if(data == 0) {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30910,user.getLanguage()) %>");
		} else if(data == 1) {
			
			refreshChild(); 
			refreshTreeData("data");
			diag.close();
		} else if(data == -1){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage()) %>");
			$("#_ButtonOK_0").attr("disabled",false)
		}
	})
}
//请求新建并复制到组
function cctg(_groupName) {
	var param ={"idSet": contactsId.toString(),  "groupName": _groupName, method: "cctg"};
	$.post("/email/new/ContactManageOperation.jsp", param, function(data){
		if(data == 0) {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30910,user.getLanguage()) %>");
		} else if(data == 1) {
			refreshChild(); 
			refreshTreeData("data");
			diag.close();
		} else if(data == -1){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage()) %>");
			$("#_ButtonOK_0").attr("disabled",false)
		}
	})
}



//修改分组信息
function editGroup(mailgroupid) {
	diag = new window.top.Dialog();
	diag.currentWindow = window;
	diag.Width = 400;
	diag.Height = 150;
	diag.Title = "<%=SystemEnv.getHtmlLabelName(103,user.getLanguage())+SystemEnv.getHtmlLabelName(81313,user.getLanguage()) %>";
	diag.URL = "/email/new/ContactsGroup.jsp?method=edit&groupName="+encodeURI(encodeURI(groupName));
	
	diag.show();
	document.getElementById('tabcontentframe').contentWindow.document.getElementById('tabcontentframe').contentWindow.jQuery("body").trigger("click")
}

//请求添加组
function editGroupInfo(_groupName){
	
	var para ={method: "edit", "groupName": _groupName , "id":currentGroup};
	$.post("/email/new/GroupManageOperation.jsp", para, function(data){
		if(data == 0) {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30910,user.getLanguage()) %>");
		} else if(data == 1) {
			refreshTreeData("data");
			refreshChild();
			diag.close();
			
		} else if(data == -1){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage()) %>");	
			$("#_ButtonOK_0").attr("disabled",false)
		}
		
	})
}


//删除联系人
function deleteContacts(contactsId, mailgroupid) {
	if(contactsId.length > 0){
		diag = new window.top.Dialog();
		diag.currentWindow = window;
		diag.Width = 400;
		diag.Height = 90;
		diag.Title = "<%=SystemEnv.getHtmlLabelName(81299,user.getLanguage()) %>";
		if(mailgroupid==<%=Integer.MIN_VALUE %> || mailgroupid==<%=Integer.MAX_VALUE %>) {
			window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(31188,user.getLanguage()) %>",function(){
				submitDelete(true);
			});
		} else {
		
			window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(31192,user.getLanguage()) %>",function(){
				submitDelete(false);
			});
			// window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(31192,user.getLanguage()) %><br/>"+
				// 		 				" <span><input type='checkbox' id='isTrDel' onchange='setIsTrDel(this)'></span>" +
				//		 				" <span><%=SystemEnv.getHtmlLabelName(31193,user.getLanguage()) %></span>" 
				//		 				,function(){
									
				// submitDelete(true);
			// });
			
		}
		// diag.OKEvent = submitDelete;//点击确定后调用的方法
		// diag.show();
		
	} else {
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81305,user.getLanguage()) %>");
	}
	
	function submitDelete(_isTrDel) {
		var param = {"idSet": contactsId.toString(), "isTrDel": _isTrDel, "sourceGroup": mailgroupid, "method": "delete"};
		jQuery.post("/email/new/ContactManageOperation.jsp", param, function(){
			refreshTreeData("data"); //重新加载左侧组列表
			refreshChild(); //重新加载当前联系人列表
			diag.close();
		});
		
	}
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

/**************start*****************MailContactAdd.jsp页面依赖代码******************************************/
//载入添加联系人页面
function addContact() {
	diag = new window.top.Dialog();
	diag.currentWindow = window;
	diag.Width = 500;
	diag.Height = 520;
	diag.Title = "<%=SystemEnv.getHtmlLabelNames("82,572",user.getLanguage()) %>";
	diag.URL = "/email/new/MailContacterAdd.jsp";
	diag.show();
}

//载入指定的联系人
function loadContact(id) {
	diag = new window.top.Dialog();
	diag.currentWindow = window;
	diag.Width = 500;
	diag.Height = 520;
	diag.Title = "<%=SystemEnv.getHtmlLabelNames("93,572",user.getLanguage()) %>";
	diag.URL = "/email/new/MailContacterAdd.jsp?id="+ id;
	diag.show();
	
}


function closeWin(){
	diag.close();
	refreshChild();
	refreshTreeData("data");
}

/**************end*****************MailContactAdd.jsp页面依赖代码******************************************/
</script>