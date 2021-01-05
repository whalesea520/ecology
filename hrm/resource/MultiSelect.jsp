<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="net.sf.json.*"%>
<%@ page import="weaver.hrm.resource.TreeNode"%>
<%@ page import="weaver.hrm.settings.ChgPasswdReminder"%>
<%@ page import="weaver.workflow.browserdatadefinition.ConditionField"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="MutilResourceBrowser" class="weaver.hrm.resource.MutilResourceBrowser" scope="page" /><jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" /><jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
String tabid = Util.null2String(request.getParameter("tabid"));
String show_virtual_org = Util.null2String(request.getParameter("show_virtual_org"));
String f_weaver_belongto_userid=Util.fromScreen(request.getParameter("f_weaver_belongto_userid"),user.getLanguage());
String f_weaver_belongto_usertype=Util.fromScreen(request.getParameter("f_weaver_belongto_usertype"),user.getLanguage());
String bdf_wfid = Util.null2String(request.getParameter("bdf_wfid"));
String bdf_fieldid = Util.null2String(request.getParameter("bdf_fieldid"));
String bdf_viewtype = Util.null2String(request.getParameter("bdf_viewtype"));

ChgPasswdReminder reminder=new ChgPasswdReminder();
RemindSettings settings=reminder.getRemindSettings();
String checkUnJob = Util.null2String(settings.getCheckUnJob(),"0");//非在职人员信息查看控制 启用后，只有有“离职人员查看”权限的用户才能检索非在职人员

List<ConditionField> lsConditionField = null;
if(bdf_wfid.length()>0){
	lsConditionField = ConditionField.readAll(Util.getIntValue(bdf_wfid),Util.getIntValue(bdf_fieldid),Util.getIntValue(bdf_viewtype));
}
boolean isAllHide = true;
for(int i=0;lsConditionField!=null&&i<lsConditionField.size();i++){
	if(!lsConditionField.get(i).isHide()){
		isAllHide = false;
		break;
	}
}

//System.out.println(isAllHide);

Random random = new Random(1000);
int rand = random.nextInt();
boolean E8EXCEPTHEIGHT = false;
if(!show_virtual_org.equals("-1")&&CompanyVirtualComInfo.getCompanyNum()>0&&(tabid.equals("1")||tabid.equals("2")||tabid.equals("3"))){
	E8EXCEPTHEIGHT = true;
}
boolean canEditGroup = HrmUserVarify.checkUserRight("CustomGroup:Edit", user);
%>
<html>
	<head>
	<link REL="stylesheet" type="text/css" href="/css/Weaver_wev8.css" />
	<link rel="stylesheet" href="/hrm/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
	<link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type=text/css rel=stylesheet>
	<script language=javascript src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>
	<script language="javascript" src="/js/weaver_wev8.js"></script>
	<script type="text/javascript" src="/js/hrm/ztree/js/jquery.ztree.core-3.5_wev8.js"></script>
	<script type="text/javascript" src="/js/hrm/ztree/js/jquery.ztree.excheck-3.5.min_wev8.js"></script>
	<script type="text/javascript" src="/hrm/group/js/jquery.ztree.exedit-3.5_wev8.js"></script>
	<script type="text/javascript" src="/js/hrm/ztree/js/jquery.ztree.exhide-3.5_wev8.js"></script>
	<script type="text/javascript" src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
	<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
	<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.overlabel_wev8.js"></script>
	<script type="text/javascript" src="/js/hrm/ztree/js/ajaxmanager_wev8.js"></script>
	<script type="text/javascript" src="/js/hrm/ztree/js/hrmmutilresource_wev8.js?t<%=rand %>"></script>
	<LINK href="/js/ecology8/customSelect/customSelect_wev8.css" type=text/css rel=STYLESHEET></LINK>
	<script src="/js/ecology8/customSelect/customSelect_wev8.js" type="text/javascript"></script>
	<style>
	.ztree li span.button.add {
    	background-image:url("/hrm/group/icon/add.png");
	    margin-left: 2px;
	    margin-right: 0px;
	}
	.ztree li span.button.edit1 {
    background-image:url("/hrm/group/icon/edit.png");
	    margin-left: 2px;
	    margin-right: 0px;
	}
	.ztree li span.button.remove1 {
    	background-image:url("/hrm/group/icon/del.png");
	    margin-left: 2px;
	    margin-right: 0px;
	}
	.ztree li span.button.suggest1 {
    	background-image:url("/hrm/group/icon/suggest.png");
	    margin-left: 2px;
	    margin-right: 0px;
	}
	.ztree li a.curSelectedNode{
		width: 100%;
		height:25px!important;
		margin-left:-500px;
		padding-left:500px;
		padding-top: 1px!important;
	}
	.ztree li a{
	    max-height:25px;
	    min-height:25px;
	}
	</style>
	<script type="text/javascript">
	var parentWin = null;
	var dialog = null;
	var dialogGroup = null;
	try{
		parentWin = parent.parent.parent.getParentWindow(parent.parent);
		dialog = parent.parent.parent.getDialog(parent.parent);
	}catch(e){}
	<%if(E8EXCEPTHEIGHT){%>
	window.E8EXCEPTHEIGHT = 30;
	<%}%>
	var canEditGroup = <%=canEditGroup%>;
	jQuery(document).ready(function(){
		jQuery(".leftTypeSearch").show();
		jQuery(".leftTypeSearch").height(30);
		jQuery(".leftTypeSearch").height(30);
	})
	function changeShowType(obj,showtype){
		var title = jQuery(obj).find(".e8text").html();
		var title1 = jQuery(obj).find(".e8text").attr("title");
		var tabid = jQuery("#tabid").val();
		jQuery("#optionSpan").html(title);
		jQuery("#virtualtype").val(showtype);
		jQuery("#leftTree").css("background-color",jQuery(".leftTypeSearch").css("background-color"));
		jQuery("span[id^='showspan']").each(function(){
			jQuery(this).addClass("e8imgSel");
		});
		jQuery("#showspan"+showtype).removeClass("e8imgSel");
		showE8TypeOption();
		changeVirtualType();
	}

	function showE8TypeOption(closed){
		if(closed){
			jQuery("#e8TypeOption").hide();
		}else{
			jQuery("#e8TypeOption").toggle();
		}
		if(jQuery("#e8TypeOption").css("display")=="none"){
			jQuery("span.leftType").removeClass("leftTypeSel");
			var src = jQuery("#currentImg").attr("src");
			if(src){
				jQuery("#currentImg").attr("src",src);
			}
			jQuery("#e8typeImg").attr("src","/images/ecology8/doc/down_wev8.png");
		}else{
			jQuery("span.leftType").addClass("leftTypeSel");
			jQuery("#e8TypeOption").width(jQuery("span.leftType").width()+17);
			var src = jQuery("#currentImg").attr("src");
			if(src){
				jQuery("#currentImg").attr("src",src);
			}
			jQuery("#e8typeImg").attr("src","/images/ecology8/doc/down_sel_wev8.png");
		}
		return;
	}
	
	var tmpNode; 
	var cxtree_id = "";
	var virtualtype = "";	
	//zTree配置信息
	var setting = {
		async: {
			enable: true,       //启用异步加载
			dataType: "text",   //ajax数据类型
			url: getAsyncUrl    //ajax的url
		},
		check: {
			enable: true,       //启用checkbox或者radio
			chkStyle: "checkbox",  //check类型为radio
			radioType: "all",   //radio选择范围
			chkboxType: { "Y" : "", "N" : "" } 
		},
		view: {
			expandSpeed: "",   //效果
			showTitle: false,
			nameIsHTML: true,
			showLine: false,
			dblClickExpand: false,
			addHoverDom: addHoverDom,
			removeHoverDom: removeHoverDom
		},
		callback: {
			onClick: zTreeOnClick,   //节点点击事件
			onDblClick:zTreeOnDblClick,
			onAsyncSuccess: zTreeOnAsyncSuccess  //ajax成功事件
			<%if(tabid.equals("4")){%>
			,beforeRemove: beforeRemove,
			beforeEditName: beforeEditName,
			beforeRename: beforeRename
			<%}%>
		},
		<%if(tabid.equals("4")){%>
		edit: {
				removeTitle: "<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>",
				renameTitle: "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>",
				suggestTitle: "<%=SystemEnv.getHtmlLabelName(16159,user.getLanguage())%>",
				enable: true,
				editNameSelectAll: false,
				showRemoveBtn: true,
				showRenameBtn: true,
				showAddBtn: true
			}
		<%}%>
	};
		
	function removeHoverDom(treeId, treeNode) {
		$("#suggestBtn_"+treeNode.tId).unbind().remove();
	};
	
	function addHoverDom(treeId, treeNode) {
		if((canEditGroup && treeNode.nodeid=="group_-2")||treeNode.nodeid=="group_-3"){
		  var thisClass = "add";
			var sObj = $("#" + treeNode.tId + "_span");
			if (treeNode.editNameFlag || $("#addBtn_"+treeNode.tId).length>0) return;
			var addStr = "<span class='button "+thisClass+"' id='addBtn_" + treeNode.tId + "' title='添加' onfocus='this.blur();'></span>";
			sObj.after(addStr);
			var btn = $("#addBtn_"+treeNode.tId);
			if (btn) btn.bind("click", function(){
				addGroup(treeNode);
				return false;
			});
		}
	};
		
	function removeHoverDom(treeId, treeNode) {
		$("#addBtn_"+treeNode.tId).unbind().remove();
	};
	
	function beforeEditName(treeId, treeNode) {
		var zTree = $.fn.zTree.getZTreeObj("treeDemo");
		zTree.selectNode(treeNode);
		editGroup(treeNode);
		return false;
	}
	
	function beforeRemove(treeId, treeNode) {
		var zTree = $.fn.zTree.getZTreeObj("treeDemo");
		zTree.selectNode(treeNode);
		if(treeNode&&treeNode.isParent&&false){
			window.top.Dialog.alert(treeNode.name+"<%=SystemEnv.getHtmlLabelName(129246, user.getLanguage())%>");
		}else{
			delGroup(treeNode); 
		}
		return false;
	}

	function beforeRename(treeId, treeNode, newName, isCancel) {
		if (newName.length == 0) {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81506, user.getLanguage())%>.");
			var zTree = $.fn.zTree.getZTreeObj("treeDemo");
			setTimeout(function(){zTree.editName(treeNode)}, 10);
			return false;
		}
		return true;
	}

	function updateNode(newName) {
		tmpNode.name=newName;
		var zTree = $.fn.zTree.getZTreeObj("treeDemo");
		zTree.updateNode(tmpNode)
		return true;
	}
	
	function addNode(newNode) {
		var zTree = $.fn.zTree.getZTreeObj("treeDemo");
 		var parentNode = zTree.getNodeByParam("nodeid", newNode.parentid, null);
		zTree.addNodes(parentNode, newNode);
		return true;
	}
	
	function closeDialog(){
		if(dialogGroup) dialogGroup.close();
	}
		
	function doDetail(id){
		dialogGroup = new window.top.Dialog();
		dialogGroup.currentWindow = window;
		dialogGroup.Title = "<%=SystemEnv.getHtmlLabelNames("93",user.getLanguage())%>";
	  	dialogGroup.URL = "/hrm/HrmDialogTab.jsp?_fromURL=hrmGroup&method=HrmGroupBaseAdd&cmd=edit&showpage=1&isdialog=1&id="+id;
		dialogGroup.Width = 700;
		dialogGroup.Height = 500;
		dialogGroup.Drag = true;
		dialogGroup.textAlign = "center";
		dialogGroup.show();
	}	
	
	function addGroup(node){
		var type=0;
		if(node.nodeid=="group_-2")type=1;
		dialogGroup = new window.top.Dialog();
		dialogGroup.currentWindow = window;
		dialogGroup.Title = "<%=SystemEnv.getHtmlLabelNames("82",user.getLanguage())%>";
	  dialogGroup.URL = "/hrm/HrmDialogTab.jsp?_fromURL=hrmGroup&method=HrmGroupBaseAdd&isdialog=1&type="+type+"&istree=1";
		dialogGroup.Width = 700;
		dialogGroup.Height = 500;
		dialogGroup.Drag = true;
		dialogGroup.textAlign = "center";
		dialogGroup.show();
	}

	function doEdit(id){
		dialogGroup = new window.top.Dialog();
		dialogGroup.currentWindow = window;
		dialogGroup.Title = "<%=SystemEnv.getHtmlLabelNames("93",user.getLanguage())%>";
	  dialogGroup.URL = "/hrm/HrmDialogTab.jsp?_fromURL=hrmGroup&method=HrmGroupBaseAdd&cmd=edit&isdialog=1&id="+id+"&istree=1";
		dialogGroup.Width = 700;
		dialogGroup.Height = 500;
		dialogGroup.Drag = true;
		dialogGroup.textAlign = "center";
		dialogGroup.show();
	}
			
	function editGroup(node){
		tmpNode = node;
		doEdit(node.id)
	}	
	
	function delGroup(node){
		var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
			jQuery.ajax({
				url:"/hrm/group/GroupOperation.jsp?operation=deletegroup&groupid="+node.id,
				type:"post",
				async:true,
				complete:function(xhr,status){
					treeObj.removeNode(node);
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20461,user.getLanguage())%>");
				}
			});
		});
	}
	
	function suggestGroup(nodeid){
		dialogGroup = new window.top.Dialog();
		dialogGroup.currentWindow = window;
		dialogGroup.Title = "<%=SystemEnv.getHtmlLabelName(126253,user.getLanguage())%>";
	  dialogGroup.URL = "/hrm/HrmDialogTab.jsp?_fromURL=hrmGroup&method=HrmGroupSuggest&isdialog=1&id="+nodeid;
		dialogGroup.Width = 700;
		dialogGroup.Height = 500;
		dialogGroup.Drag = true;
		dialogGroup.textAlign = "center";
		dialogGroup.show();
	}
	</script>
	<%
	
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(1867,user.getLanguage());
		String needfav ="1";
		String needhelp ="";
	%>	
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok.click(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel.click(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear.click(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<style type="text/css">
		.advancedSearch1{
			display:-moz-inline-box;
			display: inline-block;
			cursor:pointer;
			position: relative;
			z-index:2;
			color:#888686;
			margin-bottom:0px;
			height:21px;
			padding-left:5px;
			padding-right:5px;
			line-height:21px;
			font-size:12px;
			border-top:1px solid #F5F2F2;
			border-right:1px solid #F5F2F2;
			border-bottom:1px solid #F5F2F2;
			background-color:#fff;
		}
		.advancedSearch{height:23px}
		.advancedSearch.click{height:23px}
		.e8_select_tr{background-color: #dff1ff;}
		.searchImg1{
			display:inline;
			cursor:pointer;
			padding-left:5px !important;
			padding-right:5px !important;
		}
		.e8_box_s {
			height: 496px;
			width: 348px;
			padding-left: 2px;
		}
		.e8_box_bottommenu{
			border-bottom: 0px;
			border-right: 1px solid #ccc;
			border-left: 1px solid #ccc;
			width:342px;}
		
		.e8_box_d {
			height: 496px;
			width: 263px;
		}
		
		.e8_box_s thead td,.e8_box_d thead td {
			background-color: #ffffff;
			border-bottom: 1px solid #ffffff;
			white-space: nowrap;
			color: #000;
		}
		
		.e8_box_topmenu {
			width: 100%;
			height: 20px;
			border: none;
			line-height: 20px;
			text-align: left;
			border-collapse: collapse;
		}
		
		.e8_box_topmenu input {
			height: auto;
			width: auto;
		}
		
		.e8_box_middle {
			overflow: hidden;
			position: relative;
			border: 1px solid #dadedb;
			border-bottom: 0px;
		}
		.e8_box_slice{
			width: 57px;
			vertical-align: middle;
		}
		.e8_first_arrow{
			margin-top: 135px;
		}
		.e8_box_topmenu thead td {
			text-overflow: ellipsis;
			white-space: nowrap;
		}
		.searchInputSpan{
			top: 0px;
			height:23px;
		}
		.e8_box_s  td{
	    vertical-align: middle;
	    text-align: left;
	    border-bottom: 0px;
	    height:30px;
	    color:#242424;
	    overflow:hidden;
	    text-overflow:ellipsis;
	    /*white-space: nowrap;*/
		}
		.e8_box_d  td{
	    vertical-align: middle;
	    text-align: left;
	    border-bottom: 0px;
	    height:30px;
	    color:#242424;
	    overflow:hidden;
	    text-overflow:ellipsis;
	    /*white-space: nowrap;*/
		}
	  .overlabel{
		position:absolute;
		z-index:1;
		font-size:12px;
		font-weight:normal;
		color:#dadedb!important;
		line-height: 22px!important;
		
	}
	</style>
	<script type="text/javascript">
		try{
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("1867",user.getLanguage())%>");
		}catch(e){
			if(window.console)console.log(e+"-->MutilResourceBrowser.jsp");
		}
		var virtualtypedatas = null;
		<%
		if(CompanyVirtualComInfo.getCompanyNum()>0&&false){
			TreeNode root = new TreeNode();
			TreeNode node = new TreeNode();
			if(CompanyComInfo.getCompanyNum()>0){
				CompanyComInfo.setTofirstRow();
				while(CompanyComInfo.next()){
					node = new TreeNode();
					String dfvirtualtypename = CompanyComInfo.getCompanyname();
					node.setId(CompanyComInfo.getCompanyid());
					node.setName(dfvirtualtypename.length()>4?dfvirtualtypename.substring(0,4):dfvirtualtypename);
					root.AddChildren(node);
				}
			}
			if(CompanyVirtualComInfo.getCompanyNum()>0){
				CompanyVirtualComInfo.setTofirstRow();
				while(CompanyVirtualComInfo.next()){
					node = new TreeNode();
					String dfvirtualtypename = CompanyVirtualComInfo.getVirtualType();
					node.setId(CompanyVirtualComInfo.getCompanyid());
					node.setName(dfvirtualtypename.length()>4?dfvirtualtypename.substring(0,4):dfvirtualtypename);
					root.AddChildren(node);
				}
			}
			JSONArray jObject = JSONArray.fromObject(root.getChildren());	
			out.println(" virtualtypedatas = "+jObject.toString());
		}
		%>
		
	</script>
	</head>
	<%
		String workflow = Util.null2String(request.getParameter("workflow"));
		String qname = Util.null2String(request.getParameter("flowTitle"));
		String isNoAccount = Util.null2String(request.getParameter("isNoAccount"));
		String selectedids = Util.null2String(request.getParameter("selectedids"));
		String fromHrmStatusChange = Util.null2String(request.getParameter("fromHrmStatusChange"));
		String resourcetype = Util.null2String(request.getParameter("resourcetype"));
		String resourcestatus = Util.null2String(request.getParameter("resourcestatus"));
		String seclevelto=Util.fromScreen(request.getParameter("seclevelto"),user.getLanguage());    
		String sqlwhere=Util.null2String(request.getParameter("sqlwhere"));
		String rightStr = Util.null2String(request.getParameter("rightStr"));
		String personCmd = Util.null2String(request.getParameter("personCmd"));
		String virtualtype=Util.null2String(request.getParameter("virtualtype"));
		//added by wcd 2014-07-08 start
		String alllevel = Util.null2String(request.getParameter("alllevel"));
		//if(tabid.equals("3")&&alllevel.length()==0){
			//alllevel="1";
		//}
		if(fromHrmStatusChange.length()>0){
			isNoAccount = Util.null2String(request.getParameter("isNoAccount"),"1");
		}
		//记录最后一次tabid
		int uid=user.getUID();
		String rem=(String)session.getAttribute("MutiResourceBrowser");
		if(rem==null){
			Cookie[] cks= request.getCookies();
			for(int i=0;i<cks.length;i++){
				//System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
				if(cks[i].getName().equals("MutiResourceBrowser"+uid)){
					rem=cks[i].getValue();
					break;
				}
			}

		if(rem!=null){
		 if(Util.null2String(rem).length()>1){
			rem=tabid+rem.substring(1);
		 }
		}else
		  rem=tabid;
		}
		rem=tabid;
		session.setAttribute("MutiResourceBrowser",rem);
		Cookie ck = new Cookie("MutiResourceBrowser"+uid,rem); 
		ck.setMaxAge(30*24*60*60);
		response.addCookie(ck);
		if(lsConditionField!=null){
			for(ConditionField conditionField: lsConditionField){
				boolean isHide = conditionField.isHide();
				//if(isHide)continue;
				boolean isReadonly = conditionField.isReadonly();
				String filedname = conditionField.getFieldName();
				String valuetype = conditionField.getValueType();
				boolean isGetValueFromFormField = conditionField.isGetValueFromFormField();
				String filedvalue = "";
				if(isGetValueFromFormField){
					//表单字段 bdf_fieldname
					filedvalue = Util.null2String(request.getParameter(filedname));
					/*
					if(filedvalue.length()>0){
						filedvalue = Util.TokenizerString2(filedvalue,",")[0];
						if(filedname.equals("subcompanyid")){
							filedvalue = conditionField.getSubcompanyIds(filedvalue);
						}else if(filedname.equals("departmentid")){
							filedvalue = conditionField.getDepartmentIds(filedvalue);
						}
					}*/
				}else{
					if(valuetype.equals("1")){
						//当前操作者所属
						if(filedname.equals("subcompanyid")){
							filedvalue = ""+ResourceComInfo.getSubCompanyID(""+user.getUID());
						}else if(filedname.equals("departmentid")){
							filedvalue = ""+ResourceComInfo.getDepartmentID(""+user.getUID());
						}
					}else{
						//指定字段
						if(filedname.equals("virtualtype")){
							filedvalue = conditionField.getValueType();
						}else{
							filedvalue = conditionField.getValue();
						}
					}
				}
				if(isReadonly||isHide){
					//隐藏域要显示
					if(filedname.equals("status")&&filedvalue.equals("8"))filedvalue="";
					if(filedname.equals("jobtitle"))filedvalue=JobTitlesComInfo.getJobTitlesname(filedvalue);
				}
				if(isReadonly||isHide){
					if(filedvalue.length()>0){
						if(sqlwhere.length()>0){
							if(filedname.equals("roleid")){
								sqlwhere += " and hr.ID in (select t1.ResourceID from hrmrolemembers t1,hrmroles t2 where t1.roleid = t2.ID and t2.ID="+filedvalue+" ) " ;
							}else if(filedname.equals("virtualtype")){
								sqlwhere += " and EXISTS (SELECT * FROM hrmresourcevirtual WHERE hr.id=resourceid AND virtualtype="+filedvalue+" )" ;
							}else if(filedname.equals("jobtitle")){
								sqlwhere += " and hr.jobtitle in(select id from HrmJobTitles where jobtitlename like '%" + filedvalue +"%') ";
							}else{
								if(filedname.equals("lastname")){
									sqlwhere+= " and hr."+filedname+" like '%"+filedvalue+"%'";
								}else{
									if(filedname.equals("subcompanyid")){
										filedname="subcompanyid1";
										sqlwhere+= " and hr.subcompanyid1 in ("+filedvalue+")";
									}else if(filedname.equals("departmentid")){
										sqlwhere+= " and hr."+filedname+" in ("+filedvalue+")";
									}else{
										sqlwhere+= " and hr."+filedname+" = '"+filedvalue+"'";
									}
								}
							}
						}else{
							if(filedname.equals("roleid")){
					  		sqlwhere += " hr.ID in (select t1.ResourceID from hrmrolemembers t1,hrmroles t2 where t1.roleid = t2.ID and t2.ID="+filedvalue+" ) " ;
							}else if(filedname.equals("virtualtype")){
								sqlwhere += " EXISTS (SELECT * FROM hrmresourcevirtual WHERE hr.id=resourceid AND virtualtype="+filedvalue+" )" ;
							}else if(filedname.equals("jobtitle")){
								sqlwhere += " hr.jobtitle in(select id from HrmJobTitles where jobtitlename like '%" + filedvalue +"%') ";
							}else{
								if(filedname.equals("lastname")){
									sqlwhere+= " hr."+filedname+" like '%"+filedvalue+"%'";
								}else{
									if(filedname.equals("subcompanyid")){
										filedname="subcompanyid1";
										sqlwhere+= " hr.subcompanyid1 in ("+filedvalue+")";
									}else if(filedname.equals("departmentid")){
										sqlwhere+= " hr."+filedname+" in ("+filedvalue+")";
									}else{
										sqlwhere+= " hr."+filedname+" = '"+filedvalue+"'";
									}
								}
							}
						}
					}
				}
			}
		}
%>
	<body>
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
			  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
		<div id="dialog" style="width: 670px;">
			<div id="colShow">
				<div class="e8_box_s">
					<table class="e8_box_srctop e8_box_topmenu">
						<thead>
							<tr>
								<td>
									<span id="searchblockspan" style="width: 284px;display: inline-block;">
										<span class="searchInputSpan" style="position:relative;width: 288px">
																		<label for="flowTitle" class="overlabel" style="text-indent: 0px; cursor: text;"><%=SystemEnv.getHtmlLabelName(124853, user.getLanguage())%></label>
											<input type="text" class="searchInput middle" id="flowTitle" name="flowTitle" value="<%=qname %>" onkeyup="jsSourceSearch(this)" onfocus="onSearchFocus()" onblur="onSearchFocusLost()" style="vertical-align: top;width: 258px">
											<span class="middle searchImg"><img class="middle" style="vertical-align:top;margin-top:2px;" src="/images/ecology8/request/search-input_wev8.png"></span>
										</span>
									</span>
									<%if(lsConditionField!=null&&lsConditionField.size()>0&&isAllHide){ %>
									<span id="advancedSearch1" class="advancedSearch" style="background-color: #dadedb;"><%=SystemEnv.getHtmlLabelName(21995, user.getLanguage())%></span>
									<%}else{ %>
									<span id="advancedSearch" class="advancedSearch" onclick="jsChangeAdvancedSearchDiv();"><%=SystemEnv.getHtmlLabelName(21995, user.getLanguage())%></span>
									<%} %>
								</td>
							</tr>
						</thead>
					</table>
					<div class="advancedSearchDiv" id="advancedSearchDiv" style="z-index: 999;position: absolute;width: 348px;margin-top: -3px; ">
						<form action="" name="searchfrm" id="searchfrm" method=post>
						<!-- 隐藏域 -->
						<input type="hidden" id="f_weaver_belongto_userid" name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid %>">
						<input type="hidden" id="f_weaver_belongto_usertype" name="f_weaver_belongto_usertype" value="<%=f_weaver_belongto_usertype %>">
						<input type="hidden" id="workflow" name="workflow" value="<%=workflow %>">
						<input type="hidden" id="oldtabid" name="oldtabid" value="<%=tabid %>">
						<input type="hidden" id="tabid" name="tabid" value="<%=tabid %>">
						<input type="hidden" id="selectedids" name="selectedids" value="<%=selectedids %>">					
						<input type="hidden" id="cmd" name="cmd" value='HrmResourceMultiSelect'>
						<input type="hidden" id="sqlwhere" name="sqlwhere" value="<%=xssUtil.put(sqlwhere)%>">
						<input type="hidden" id="resourcetype"name="resourcetype"  value='<%=resourcetype%>'>
						<input type="hidden" id="resourcestatus" name="resourcestatus" value='<%=resourcestatus%>'>	
						<input type="hidden" id="seclevelto" name="seclevelto" value='<%=seclevelto%>'>
						<input type="hidden" id="rightStr" name="rightStr" value='<%=rightStr%>'>
						<input type="hidden" id="personCmd" name="personCmd" value='<%=personCmd%>'>
						<%if(CompanyVirtualComInfo.getCompanyNum()==0){ %>
						<input type="hidden" id="virtualtype" name="virtualtype" value='<%=virtualtype%>'>
						<%} %>
						<input type="hidden" id="fromHrmStatusChange" name="fromHrmStatusChange" value='<%=fromHrmStatusChange%>'>
						<input type="hidden" id="mousedown" name="mousedown" value="">
						<input type="hidden" id="isNoAccount" name="isNoAccount" value="<%=isNoAccount %>">
						<input type="hidden" id="alllevel" name="alllevel" value="<%=alllevel %>">
						<input type="hidden" id="currentPage" name="currentPage" value="1">
						<%if(lsConditionField!=null && lsConditionField.size()>0){ 
						  Hashtable<String,String> htHide = new Hashtable<String,String>();
						%>
						<input type="hidden" id="lsConditionField" name="lsConditionField" value="1">
					  <wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
						<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
					  <%
						for(ConditionField conditionField: lsConditionField){
							boolean isHide = conditionField.isHide();
							//if(isHide)continue;
							boolean isReadonly = conditionField.isReadonly();
							String filedname = conditionField.getFieldName();
							String valuetype = conditionField.getValueType();
							boolean isGetValueFromFormField = conditionField.isGetValueFromFormField();
							String filedvalue = "";
							if(isGetValueFromFormField){
								//表单字段 bdf_fieldname
								filedvalue = Util.null2String(request.getParameter(filedname));
								/*
								if(filedvalue.length()>0){
									filedvalue = Util.TokenizerString2(filedvalue,",")[0];
									if(filedname.equals("subcompanyid")){
										filedvalue = conditionField.getSubcompanyIds(filedvalue);
									}else if(filedname.equals("departmentid")){
										filedvalue = conditionField.getDepartmentIds(filedvalue);
									}
								}*/
							}else{
								if(valuetype.equals("1")){
									//当前操作者所属
									if(filedname.equals("subcompanyid")){
										filedvalue = ""+ResourceComInfo.getSubCompanyID(""+user.getUID());
									}else if(filedname.equals("departmentid")){
										filedvalue = ""+ResourceComInfo.getDepartmentID(""+user.getUID());
									}
								}else{
									//指定字段
									if(filedname.equals("virtualtype")){
										filedvalue = conditionField.getValueType();
									}else{
										filedvalue = conditionField.getValue();
									}
								}
							}
							if(isHide){
								//隐藏域要显示
								if(filedname.equals("status")&&filedvalue.equals("8"))filedvalue="";
								if(filedname.equals("jobtitle"))filedvalue=JobTitlesComInfo.getJobTitlesname(filedvalue);
								htHide.put(filedname,filedvalue);
								continue;
							}
							//姓名 状态 分部 部门 岗位 角色
							if(filedname.equals("lastname")){
							%>
								<wea:item><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
								<wea:item><input class=inputstyle id=lastname name=lastname <%=isReadonly?"readonly":"" %> value='<%=filedvalue %>'></wea:item>
							<%}else if(filedname.equals("virtualtype")){%>
							<%if(CompanyVirtualComInfo.getCompanyNum()>0){ %>
					     <wea:item><%=SystemEnv.getHtmlLabelName(82531,user.getLanguage())%></wea:item>
					  	 <wea:item>
					    	<select id=virtualtype name=virtualtype style="width: 153px">
					    		<option value=""></option>
					    		<%
					    		if(CompanyComInfo.getCompanyNum()>0){
					    			CompanyComInfo.setTofirstRow();
					    			while(CompanyComInfo.next()){
					    		%>
					    		<option value="<%=CompanyComInfo.getCompanyid() %>" <%=filedvalue.equals(CompanyComInfo.getCompanyid())?"selected":"" %>><%=CompanyComInfo.getCompanyname() %></option>
					    		<%} }%>
					    		<%
					    		CompanyVirtualComInfo.setTofirstRow();
					    		while(CompanyVirtualComInfo.next()){
					    		%>
					    		<option value="<%=CompanyVirtualComInfo.getCompanyid() %>" <%=filedvalue.equals(CompanyVirtualComInfo.getCompanyid())?"selected":"" %>><%=CompanyVirtualComInfo.getVirtualType() %></option>
					    		<%} %>
					    	</select>
					     </wea:item>
					    	<%} %>
							<%}else if(filedname.equals("status")){
							%>
								<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
								<wea:item>
									<%if(isReadonly){ %>
									<input type="hidden" id=status name=status value="<%=filedvalue.equals("8")?"":filedvalue %>">
									<%}%>
							    <select class=inputstyle id=status name=status <%=isReadonly?"disabled":"" %>>
							    <%
							    List<String> lsList = conditionField.getCanSelectValueList();
							   	for(String option:lsList){
							   		%>
							   		<option value="<%=option.equals("8")?"":option %>" <%=filedvalue.endsWith(option)?"selected":"" %>><%=ResourceComInfo.getStatusName(Util.getIntValue(option),user) %></option>
							   		<%	
							   	}
							   %>
							   </select>
								</wea:item>
							<%
							}else if(filedname.equals("subcompanyid")){
								String isMustInput = isReadonly?"0":"1";
							%>
								<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
								<wea:item>
									<brow:browser viewType="0" name="subcompanyid" browserValue='<%=filedvalue %>' 
									browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids="
					        hasInput="true" isSingle="false" hasBrowser="true" isMustInput='<%=isMustInput %>'
					        completeUrl="/data.jsp?type=164"
					        _callback="jsSubcompanyCallback" browserSpanValue='<%=SubCompanyComInfo.getSubcompanynames(filedvalue) %>'>
					      </brow:browser>
								</wea:item>
							<%
							}else if(filedname.equals("departmentid")){
								String isMustInput = isReadonly?"0":"1";
							%>
								<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
								<wea:item>
								  <brow:browser viewType="0" name="departmentid" browserValue='<%=filedvalue %>' 
					        browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
					        hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='<%=isMustInput %>'
					        completeUrl="/data.jsp?type=4"
					        _callback="jsDepartmentCallback" browserSpanValue='<%=DepartmentComInfo.getDepartmentNames(filedvalue) %>'>
					      </brow:browser>
								</wea:item>
							<%
							}else if(filedname.equals("jobtitle")){
								String isMustInput = isReadonly?"0":"1";
							%>
								<wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item>
								<wea:item>
											<input class=inputstyle id=jobtitle name=jobtitle maxlength=60 value="<%=JobTitlesComInfo.getJobTitlesname(filedvalue) %>">
								<!-- 
									 <brow:browser viewType="0"  name="jobtitle" browserValue='<%=filedvalue %>' 
								   browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp" 
								   hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='<%=isMustInput %>'
								   completeUrl="/data.jsp?type=hrmjobtitles" width="80%" browserSpanValue='<%=JobTitlesComInfo.getJobTitlesname(filedvalue) %>'>
								 	</brow:browser>
								 -->
								</wea:item>
							<%
							}else if(filedname.equals("roleid")){
								String isMustInput = isReadonly?"0":"1";
							%>
								<wea:item><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></wea:item>
								<wea:item>
									<brow:browser viewType="0" temptitle="" name="roleid" browserValue='<%=filedvalue %>'
										browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp" 
										hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='<%=isMustInput %>'
										completeUrl="/data.jsp?type=65" width="80%"
										browserSpanValue='<%=RoleComInfo.getRolesRemark(filedvalue) %>'>
									</brow:browser>
								</wea:item>
							<%
							}
							} %>
					</wea:group>
					<wea:group context="">
						<wea:item type="toolbar">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
					  	<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_submit" onclick="resetCondtion();jQuery('#flowTitle').val('');">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" onclick="jsChangeAdvancedSearchDiv();"/>
						</wea:item>
					</wea:group>
					</wea:layout>
				  <%
					//显示隐藏域
				  Set<String> key = htHide.keySet();
				  for (Iterator<String> it = key.iterator(); it.hasNext();) {
					  String fieldname = (String) it.next();
					  String fieldvalue = htHide.get(fieldname);
				  %>
				  <input type="hidden" id="<%=fieldname %>" name="<%=fieldname %>" value="<%=fieldvalue %>" >
				 <%}%>
					<%}else{ %>
						<wea:layout type="2col">
								<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>' attributes="{groupDisplay:none}">
										<wea:item><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
										<wea:item><input type="text" class=inputstyle id=lastname name=lastname onkeyup="javascript:jsChangelastname()" style="width: 183px;"></wea:item>
										<%if(CompanyVirtualComInfo.getCompanyNum()>0){ %>
								     <wea:item><%=SystemEnv.getHtmlLabelName(82531,user.getLanguage())%></wea:item>
								  	 <wea:item>
								    	<select id=virtualtype name=virtualtype style="width: 153px">
								    		<option value=""></option>
								    		<%
								    		if(CompanyComInfo.getCompanyNum()>0){
								    			CompanyComInfo.setTofirstRow();
								    			while(CompanyComInfo.next()){
								    		%>
								    		<option value="<%=CompanyComInfo.getCompanyid() %>" <%=virtualtype.equals(CompanyComInfo.getCompanyid())?"selected":"" %>><%=CompanyComInfo.getCompanyname() %></option>
								    		<%} }%>
								    		<%
								    		CompanyVirtualComInfo.setTofirstRow();
								    		while(CompanyVirtualComInfo.next()){
								    		%>
								    		<option value="<%=CompanyVirtualComInfo.getCompanyid() %>" <%=virtualtype.equals(CompanyVirtualComInfo.getCompanyid())?"selected":"" %>><%=CompanyVirtualComInfo.getVirtualType() %></option>
								    		<%} %>
								    	</select>
								     </wea:item>
							    	<%} %>
										<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
							      <wea:item>
							        <select class=inputstyle id=status name=status onchange="jsCheckIsNoAccount(this)" style="width: 153px">
							        	<%if(fromHrmStatusChange.equals("HrmResourceTry")){ %>
							        	  <option value="" selected ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
										  		<option value=2 ><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
							        	<%}else if(fromHrmStatusChange.equals("HrmResourceHire")) {%>
							           	<option value="" selected ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option> 
										  		<option value=0 ><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></option>
												  <option value=2 ><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
												  <option value=3 ><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></option>
							          <%}else if(fromHrmStatusChange.equals("HrmResourceExtend")) {%>
							        	  <option value="" selected ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
										  		<option value=1><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></option>
							            <option value=0 ><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></option>
							            <option value=2 ><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
							            <option value=3 ><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></option>
							        	<%}else if(fromHrmStatusChange.equals("HrmResourceDismiss")) {%>
							        		<option value="" selected ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
												  <option value=0 ><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></option>
												  <option value=1 ><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></option>
												  <option value=2 ><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
												  <option value=3 ><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></option>
												  <option value=7 ><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
							     	  	<%}else if(fromHrmStatusChange.equals("HrmResourceRetire")) {%>
							     	  		<option value="" selected ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
										  		<option value=1><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></option>
							     	  	<%}else if(fromHrmStatusChange.equals("HrmResourceFire")) {%>
							     	  	  <option value="" selected ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
							            <option value=0 ><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></option>
										  		<option value=1 ><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></option>
							            <option value=2 ><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
										  		<option value=3 ><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></option>
							     	  	<%}else if(fromHrmStatusChange.equals("HrmResourceRehire")) {%>
							     	  	  <option value="" selected ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
												  <option value=4 ><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></option>
												  <option value=5 ><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></option>
												  <option value=6 ><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></option>
												  <option value=7 ><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
							        	<%}else{ %>
							     		<%
							     		if("1".equals(checkUnJob)){//启用后，只有有“离职人员查看”权限的用户才能检索非在职人员
							     		if(HrmUserVarify.checkUserRight("hrm:departureView",user)){ %>
							          <option value=9 ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
								        <%}}else{%>
							          <option value=9 ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
								        <%} %>
							          <option value="8" selected><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%></option>
							          <option value=0 ><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></option>
							          <option value=1 ><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></option>
							          <option value=2 ><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
							          <option value=3 ><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></option>
							        <%
							   		if("1".equals(checkUnJob)){//启用后，只有有“离职人员查看”权限的用户才能检索非在职人员
							        	if(HrmUserVarify.checkUserRight("hrm:departureView",user)){ %>
							          <option value=4 ><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></option>
							          <option value=5 ><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></option>
							          <option value=6 ><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></option>
							          <option value=7 ><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
							        <%}}else{%>
							          <option value=4 ><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></option>
							          <option value=5 ><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></option>
							          <option value=6 ><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></option>
							          <option value=7 ><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
							        <%} %>
							          <%} %>
							        </select>
							      </wea:item>
										<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
							      <wea:item>
								    	<brow:browser viewType="0" id="subcompanyid" name="subcompanyid" browserValue="" 
								        browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids="
								        hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
								        completeUrl="/data.jsp?type=164"
								        _callback="jsSubcompanyCallback" browserSpanValue="">
								      </brow:browser>
							      </wea:item>
										<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
							      <wea:item>
								      <brow:browser viewType="0" id="departmentid" name="departmentid" browserValue="" 
								        browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
								        hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
								        completeUrl="/data.jsp?type=4"
								        _callback="jsDepartmentCallback" browserSpanValue="">
								      </brow:browser>
							      </wea:item>
										<wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item>
										<wea:item>
												<input class=inputstyle id=jobtitle name=jobtitle maxlength=60 >
							      </wea:item>
										<wea:item><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></wea:item>
										<wea:item>
							      	<brow:browser viewType="0" id="roleid" name="roleid" browserValue="" 
								        browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/roles/HrmRolesBrowser.jsp?selectedids="
								        hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								        completeUrl="/data.jsp?type=65" browserSpanValue="">
							      	</brow:browser>
							      </wea:item>
								</wea:group>
								<wea:group context="">
								<wea:item type="toolbar">
									<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
							  	<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_submit" onclick="resetCondtion();jQuery('#flowTitle').val('');">
									<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" onclick="jsChangeAdvancedSearchDiv();"/>
								</wea:item>
							</wea:group>
						</wea:layout>
						<%} %>
						</form>
					</div>
					<div style="position: absolute;top: 32px;left: 295px;padding-right: 5px;margin-top: <%=!E8EXCEPTHEIGHT?"5":"35" %>px;z-index: 11;">
						<img id="imgalllevel" src="/hrm/css/zTreeStyle/img/alllevelshow_wev8.png" title="<%=tabid.equals("2")?""+SystemEnv.getHtmlLabelName(83783,user.getLanguage()): SystemEnv.getHtmlLabelName(33454,user.getLanguage())%>">
					</div>
					<div style="position: absolute;top: 32px;left: 320px;padding-left: 2px;padding-right: 5px;margin-top: <%=!E8EXCEPTHEIGHT?"5":"35" %>px;z-index: 11">
						<img id="imgisnoaccount" src="/hrm/css/zTreeStyle/img/noaccountshow_wev8.png" title="<%=SystemEnv.getHtmlLabelName(31504, user.getLanguage())%>">
					</div>
					<% if(tabid.equals("2")&&false){ %>
						<div id='managerSel' style="position: absolute;top: 62px;left: 5px;padding-right: 5px;padding-top: 5px;z-index: 11"></div>
					<%} %>
					<div id="tabTypeOption">
					<%if(E8EXCEPTHEIGHT){ %>
					<table cellspacing="0" cellpadding="0" style="width:100%;">
						<tr>
							<td class="leftTypeSearch" style="border-right: 0px;">
								<div class="topMenuTitle" style="border-bottom:none;width: 346px;height: 30px;border-top: 1px solid #DADADA;border-left: 1px solid #DADADA;border-right: 1px solid #DADADA;">
									<span class="leftType" style="width: 332px;height: 0px;">
										<span><img id="currentImg" src="/images/ecology8/doc/org_wev8.png" width="16"/></span>
										<span>
											<div  id="e8typeDiv" style="width:auto;height:auto;position:relative;line-height: 0px">
												<span id="optionSpan" style="width: 285px;line-height: 30px" onclick="showE8TypeOption();" ><%=SystemEnv.getHtmlLabelName(83179,user.getLanguage())%></span>
												<%if(CompanyVirtualComInfo.getCompanyNum()>0){ %>
												<span style="width:16px;height:16px;cursor:pointer;" onclick="showE8TypeOption();">
													<img id="e8typeImg" src="/images/ecology8/doc/down_wev8.png"/>
												</span>
												<%} %>
											</div>
										</span>
								</div>
							</td>
						</tr>
					</table>
					<%} %>
					<%	if(CompanyVirtualComInfo.getCompanyNum()>0){ %>
					<ul id="e8TypeOption" class="e8TypeOption">
					<%
					if(CompanyComInfo.getCompanyNum()>0){
						CompanyComInfo.setTofirstRow();
						while(CompanyComInfo.next()){
					%>
						<li onclick="changeShowType(this,<%=CompanyComInfo.getCompanyid() %>);">
							<span id="showspan<%=CompanyComInfo.getCompanyid() %>" class="e8img"><img src="/images/ecology8/doc/current_wev8.png"/></span>
							<span class="e8img"><img src="/images/ecology8/doc/org_sel_wev8.png"/></span>
							<span class="e8text"><%=SystemEnv.getHtmlLabelName(83179,user.getLanguage())%></span>
						</li>
					<%}}
					if(CompanyVirtualComInfo.getCompanyNum()>0){
						CompanyVirtualComInfo.setTofirstRow();
						while(CompanyVirtualComInfo.next()){
						%>
						<li onclick="changeShowType(this,<%=CompanyVirtualComInfo.getCompanyid() %>);">
							<span id="showspan<%=CompanyVirtualComInfo.getCompanyid() %>" class="e8img e8imgSel"><img src="/images/ecology8/doc/current_wev8.png"/></span>
							<span class="e8img"><img src="/images/ecology8/doc/org_sel_wev8.png"/></span>
							<span class="e8text" title="<%=CompanyVirtualComInfo.getVirtualType() %>"><%=CompanyVirtualComInfo.getVirtualType().length()>4?CompanyVirtualComInfo.getVirtualType():CompanyVirtualComInfo.getVirtualType()%></span>
						</li>
						<%} %>
					</ul>
				<%} %>
				<%} %>
				</div>
					<div class="e8_box_middle ps-container" id="src_box_middle" style="width: 346px;">
						<%if(tabid.equals("3")||tabid.equals("4")){%>
								<div class="zTreeDemoBackground left">
									<ul id="treeDemo" class="ztree" style="height: 800px"></ul>
								</div>
						<%}else{ %>
						<table class="e8_box_source" style="border-collapse: collapse;border-spacing:0px;width: 100%;">
							<tbody>
							</tbody>
						</table>
						<%} %>
					</div>
					<div class="e8_box_src e8_box_bottommenu" style="display: none;">
					</div>
				</div>
				<div class="e8_box_slice">
					<div>
						<img id="singleArrowTo" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"
							class="e8_box_mutiarrow e8_first_arrow"
							src="/js/dragBox/img/4_wev8.png">
					</div>
					<div>
						<img id="singleArrowFrom" title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>" class="e8_box_mutiarrow"
							src="/js/dragBox/img/5_wev8.png">
					</div>
					<div class="multiHeight" style="height: 135px"></div>
					<div>
						<img id="multiArrowTo" title="<%=SystemEnv.getHtmlLabelName(83786,user.getLanguage())%>" class="e8_box_mutiarrow"
							src="/js/dragBox/img/6_wev8.png">
					</div>

					<div>
						<img id="multiArrowFrom" title="<%=SystemEnv.getHtmlLabelName(83787,user.getLanguage())%>" class="e8_box_mutiarrow"
							src="/js/dragBox/img/7_wev8.png">
					</div>
				</div>
				<div class="e8_box_d">
					<table class="e8_box_desttop e8_box_topmenu">
						<thead>
							<tr>
								<td style="height: 30px">
									<span id="searchblockspan">
										<span class="searchInputSpan" style="position:relative;width: 261px">
											<label for="flowTitle1" class="overlabel" style="text-indent: 0px; cursor: text;"><%=SystemEnv.getHtmlLabelName(83788,user.getLanguage())%></label>
											<input type="text" class="searchInput middle" id="flowTitle1" name="flowTitle1" value="<%=qname %>" onkeyup="jsTargetSearch(this)" style="vertical-align: top;width: 230px">
											<span class="middle searchImg1"><img class="middle" style="vertical-align:top;margin-top:2px;" src="/images/ecology8/request/search-input_wev8.png"></span>
										</span>
									</span>
								</td>
							</tr>
						</thead>
					</table>
					<div class="e8_box_middle ps-container" id="dest_box_middle" style="width: 261px">
						<table id="e8_dest_table" class="e8_box_target" style="border-collapse: collapse;">
							<tbody></tbody>
						</table>
					</div>
					<div class="e8_box_src e8_box_bottommenu" style="width: 257px;display: none;">
						<table style="width: 100%;">
							<tr>
								<td style="text-align: center;"><%=SystemEnv.getHtmlLabelName(31503,user.getLanguage())%>&nbsp;<span id="e8_box_target_num11" style="text-decoration:underline;">0</span>&nbsp;<%=SystemEnv.getHtmlLabelName(127, user.getLanguage())%></td>
							</tr>
						</table>
					</div>
				</div>
			</div>
		</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="">
		<wea:item type="toolbar">
			<input type="button" class=zd_btn_submit id=btnok val="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" onclick="jsOK()"></input>
			<input type="button" class=zd_btn_submit id=btnclear value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" onclick="jsClear()"></input>
			<input type="button" class=zd_btn_cancle id=btncancel value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" onclick="jsCancel()"></input>
		</wea:item>
	</wea:group>
</wea:layout>
<div id="tmpTitle" style="display: none;"></div>
<!-- 用于缓存之前信息 -->
<div id="e8_box_middle_bak" style="display: none;"></div>
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
		var reminHei = jQuery("body").height()-32-41;
		var topmenuHei = jQuery(".topMenuTitle").height();
		if(topmenuHei != null){
		   reminHei = reminHei- topmenuHei;
		}
		jQuery(".e8_box_middle").height(reminHei);
		
		<%if(lsConditionField!=null&&lsConditionField.size()>0){%>
		if(jQuery("#tabchange",parent.document).val()=="0"){
			jsChangeAdvancedSearchDiv();
			onBtnSearchClick();
			jQuery("#tabchange",parent.document).val("1");
		}
		<%}%>
	});
	var E8EXCEPTHEIGHT =<%=E8EXCEPTHEIGHT?"30":"0" %> 
	var i = 0;
	function expandZH(){
	
		var height; 
		if(dialog == null){
			height = jQuery("body").height()-135-E8EXCEPTHEIGHT;
		}else{
			height = dialog.Height-135-E8EXCEPTHEIGHT;
		}
		jQuery(".e8_box_middle").css("height",height);
		jQuery("#dest_box_middle").css("height",(height+E8EXCEPTHEIGHT));
		jQuery(".e8_box_slice").css("height",height+30);
		jQuery(".multiHeight").css("height",30);
		if(jQuery(".e8_box_middle").css("height")==(height+"px")){
			i=10
		}
		if(i<10){
			window.setTimeout(function(){
				expandZH();
			},1000);
		}
		i++;
	}
	expandZH();
	
	function confimrHeight(){
		var srcHeight = jQuery("#src_box_middle").css("height");
		var destHeight = jQuery("#dest_box_middle").css("height");
		var toT = jQuery(".topMenuTitle").css("height");
		if(toT){
			if(srcHeight && destHeight){
				jQuery("#dest_box_middle").css("height",parseInt(srcHeight)+parseInt(toT));
			}
		}else{
			if(srcHeight && destHeight){
				jQuery("#dest_box_middle").css("height",srcHeight);
			}
		}
	}

	window.onload = function(){
		createOrRefreshScrollBar("src_box_middle","update");
		//在页面加载完成后对两边选择框的高度进行重新赋值，避免出现高度不一致的情况
		//window.setTimeout(confimrHeight,100);
	};
</script>
</div>
<div id="hshadowAdvancedSearchOuterDiv" style="top: 228px; height: 300px;width: 348px;margin-left:2px;display: none;position: absolute;background:rgb(220, 226, 241);z-index:2;opacity:0.6"></div>
</body>
</html>
