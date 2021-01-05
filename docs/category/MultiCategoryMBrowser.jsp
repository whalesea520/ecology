<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<%
    int categoryid = Util.getIntValue(request.getParameter("categoryid"), -1);
    int categorytype = Util.getIntValue(request.getParameter("categorytype"), -1);
    int operationcode = Util.getIntValue(request.getParameter("operationcode"), -1);
    String categoryname = Util.null2String(request.getParameter("categoryname"));
    String selectids = Util.null2String(request.getParameter("selectids"));
    if(selectids.equals("")){
    	selectids = Util.null2String(request.getParameter("para"));
    }
	if(selectids.indexOf(",")==0)
		selectids=selectids.substring(1);
	selectids=selectids.replaceAll(",,+", ",");
    MultiAclManager am = new MultiAclManager();
    if (categoryid != -1 && categorytype != -1) {
        if (!am.hasPermission(categoryid, categorytype, user.getUID(), user.getType(), Util.getIntValue(user.getSeclevel(),0), operationcode)) {
            response.sendRedirect("/notice/noright.jsp");
        	return;
        }
    }
    MultiCategoryTree tree = am.getPermittedTree(user.getUID(), user.getType(), Util.getIntValue(user.getSeclevel(),0), operationcode,categoryname);
   // out.println(tree.treeCategories);
%>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser_wev8.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.excheck.min_wev8.js"></script>
<script type="text/javascript">
	//window.FIXTREEHEIGHT = 389;
	window.E8EXCEPTHEIGHT = 80;
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("16398",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e+"-->CategoryBrowser.jsp");
	}
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
</script>
<script>
function clearCategory() {
    if(dialog){
		try{
		dialog.callback({id:"",path2:"",path:""});
		}catch(e){}
		try{
		dialog.close({id:"",path2:"",path:""});
		}catch(e){}
	}else{
    	window.parent.returnValue={id:"",path2:"",path:""}
    	window.parent.close();
    }
}
function onClose(){
	if(dialog){
		dialog.close();
	}else{
    	window.parent.close();
    }
}

function setZtreeCheckbox(obj){	
	var status = jQuery(obj).attr("_status");
	var treeObj = getZTreeObj();
	if(!status||status==0){//当前关闭全选状态
		jQuery(obj).attr("_status",1);
		jQuery(obj).text("<%= SystemEnv.getHtmlLabelName(19324,user.getLanguage())%>");
		treeObj.setting.check.chkboxType = { "Y": "s", "N": "s"};
	}else{
		jQuery(obj).attr("_status",0);
		jQuery(obj).text("<%= SystemEnv.getHtmlLabelName(19323,user.getLanguage())%>");
		treeObj.setting.check.chkboxType = { "Y": "", "N": ""};
	}
}

function zTreeOnCheck(event, treeId, treeNode) {
	var treeObj = getZTreeObj();
	treeObj.expandNode(treeNode,true);
	
	
	
}

function onOk(){
	var treeObj = getZTreeObj();
	var nodes = treeObj.getCheckedNodes(true);
	var id = "";
	var path = "";
	var path2 = "";
	var parentTId = 0;
	for(var i=0;i<nodes.length;i++){
		var node = nodes[i];
		if(!id){
			id=node.categoryid;
		}else{
			id=id+","+node.categoryid;
		}
		if(!path2){
			path2 = node.name;
		}else{
			path2 = path2+","+node.name;
		}
		parentTId = node.parentTId;
		var curPath = node.name;
		while(!!parentTId){
			var parentNode = treeObj.getNodeByTId(parentTId);
			curPath = parentNode.name+"/" + curPath;
			parentTId = parentNode.parentTId;
		}
		if(!path){
			path = curPath;
		}else{
			path = path + "," + curPath;
		}
	}
	if(dialog){
		try{
			dialog.callback({id:id,path:path,path2:path2});
			}catch(e){}
			try{
			dialog.close({id:id,path:path,path2:path2});
			}catch(e){}
		}else{
	    	window.parent.returnValue={id:id,path:path,path2:path2};
	    	window.parent.close();
	    }
}

function onSearch(){
	document.SearchForm.submit();
}
</script>
</HEAD>
<BODY style="overflow:hidden;">
<div class="zDialog_div_content">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_top" onclick="onSearch();">
				<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<form name="SearchForm" id="SearchForm" method="post" action="MultiCategoryMBrowser.jsp">
	<input type="hidden" name="operationcode" value="<%=operationcode %>"/>
	<input type="hidden" name="categoryid" value="<%=categoryid %>"/>
	<input type="hidden" name="categorytype" value="<%=categorytype %>"/>
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage()) %>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(24764,user.getLanguage()) %></wea:item>
			<wea:item><input type="text" class="InputStyle" name="categoryname" id="categoryname" value='<%=categoryname %>'/></wea:item>
		</wea:group>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(32452,user.getLanguage()) %>'>
			<wea:item type="groupHead">
				<button _show="true" type="button" class="e8_btn_top" id="allcheckbtn" name="allcheckbtn" onclick="setZtreeCheckbox(this);"><%= SystemEnv.getHtmlLabelName(19323,user.getLanguage())%></button>
			</wea:item>
			<wea:item attributes="{'isTableList':'true'}">
				<div class="ulDiv2"></div>
			</wea:item>
		</wea:group>
	</wea:layout>
</form>
<script type="text/javascript">
	var demoLeftMenus = <%= tree.getTreeCategories().toString()%>;
	var expandAllFlag = <%=categoryname.equals("")?false:true%>;
	var selectids = "<%=selectids%>";
	function _categoryCallback(){
		if(!!selectids){
			checkedDefaultNode("categoryid",selectids);
		}
		if(expandAllFlag){
			_expandAll();
		}
	}
	$(".ulDiv2").leftNumMenu(demoLeftMenus,{
			showZero:false,
			addDiyDom:false,
			multiJson:true,
			_callback:_categoryCallback,	
			setting:{
				view: {
					expandSpeed: ""
				},
				callback: {
					onClick: _leftMenuClickFunction,
					onCheck:zTreeOnCheck   
				},
				check:{
					enable:true,
					autoCheckTrigger:true,
					chkStyle: "checkbox",
					chkboxType:{ "Y": "", "N": "" }
				}				
			}
	});
</script>

<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onOk(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btn accessKey=1 onclick="onClose()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btn accessKey=2 onclick="clearCategory()" id=btnclear><U></U><%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
 </div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
				<input type="button" accessKey=0  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="onOk();">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="clearCategory();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
</BODY></HTML>
