<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.docs.rdeploy.util.PrivateCategoryTree,weaver.docs.rdeploy.bean.PraviteCategoryBean" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
 <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
    int categoryid = Util.getIntValue(request.getParameter("categoryid"), -1);
    String categoryname = Util.null2String(request.getParameter("categoryname"));
	String folderids = Util.null2String(request.getParameter("folderid"));
	RecordSet rs = new RecordSet();
		if(categoryid==0)
		{
			String sql = "select id from DocPrivateSecCategory where categoryname = '" + user.getUID() + "_" + user.getLastname() + "' and parentid=0";
			rs.execute(sql);
			if(rs.next()){
				categoryid = rs.getInt("id");
			}
		}    
    
    String hasClear = Util.null2String(request.getParameter("hasClear")); //是否有清楚按钮 0为没有，1或者空为有
    String hasCancel = Util.null2String(request.getParameter("hasCancel")); //是否有取消按钮 0为没有，1或者空为有
    String hasWarm = Util.null2String(request.getParameter("hasWarm")); //选中后是否有提醒 1为有，0或者空为没有
    String type = Util.null2String(request.getParameter("type")); //1是移动到 2是保存到云盘
	
	PrivateCategoryTree privateCategoryTree = new PrivateCategoryTree();
	PraviteCategoryBean result = privateCategoryTree.getPermittedTree(user,categoryname,categoryid,folderids);
	
  //  MultiCategoryTree tree = am.getPermittedTree(user.getUID(), user.getType(), Util.getIntValue(user.getSeclevel(),0), operationcode,categoryname,-1,params);
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
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelName(129151,user.getLanguage())%>");//
	}catch(e){
	}
	var parentWin = null;
	var dialog = null;
	try{
		var topWi = window;
		var curWi = window;
		while(topWi != topWi.parent){
			curWi = topWi;
			topWi = topWi.parent;
		}
		parentWin = topWi.getParentWindow(curWi);
		dialog = topWi.getDialog(curWi);
	}catch(e){}
</script>
<script>
function clearCategory() {
  	var returnjson = {id:"",name:"",path : ""};
    if(dialog){
		try{
			dialog.callback(returnjson);
		}catch(e){}
		try{
		dialog.close(returnjson);
		}catch(e){}
	}else{
    	window.parent.returnValue=returnjson;
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
function leftMenuClickFn(attr,level,numberType,node,options){
	var treeNode = options.treeNode;
	var treeObj = options.treeObj;
	if(treeNode){
		options = treeNode.options;
		if(treeNode[options.rightKey]==="N"){
			return;
		}
	}
	var id = treeNode.categoryid;
	var mainid = -1;
	var subid = -1;
	var path = treeNode.name;
	var parentTId = treeNode.parentTId;
	var i=0;
	while(!!parentTId){
		i++;
		var parentNode = treeObj.getNodeByTId(parentTId);
		if(i==1)subid = parentNode.categoryid;
		if(i==2)mainid = parentNode.categoryid;
		path = parentNode.name+"/" + path;
		parentTId = parentNode.parentTId;
	}
	if(!subid)subid=-1;
	if(!mainid)mainid=-1;
	//console.log(id+"::"+subid+"::"+mainid+"::"+path);
	var points="<%=SystemEnv.getHtmlLabelName(129296,user.getLanguage())%>?";
	if("<%=type%>" == "1"){
		points="<%=SystemEnv.getHtmlLabelName(129287,user.getLanguage())%>?";
	}else if("<%=type%>" == "2"){
		points="<%=SystemEnv.getHtmlLabelName(129295,user.getLanguage())%>?";
	}
	var data = {tag:1,id:""+id, path:""+path, mainid:""+mainid, subid:""+subid};
	if("<%=hasWarm%>" == "1"){
		window.top.Dialog.confirm(points,function(){
			dataBack(data);
		})
	}else{
		dataBack(data);
	}
	
}

function dataBack(data){
	if(dialog){
		try{
		dialog.callback(data);
		}catch(e){}
		try{
		dialog.close(data);
		}catch(e){}
	}else{
	    window.parent.returnValue = data;
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
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<form name="SearchForm" id="SearchForm" method="post" action="MultiCategorySingleBrowser.jsp">
	<input type="hidden" name="categoryid" value="<%=categoryid %>"/>
	<input type="hidden" name="folderid" value="<%=folderids %>"/>
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage()) %>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(24764,user.getLanguage()) %></wea:item>
			<wea:item><input type="text" class="InputStyle" name="categoryname" id="categoryname" value='<%=categoryname %>'/></wea:item>
		</wea:group>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(32452,user.getLanguage()) %>'>
			<wea:item attributes="{'isTableList':'true'}">
				<div class="ulDiv2" style="position:relative"></div>
			</wea:item>
		</wea:group>
	</wea:layout>
</form>
<script type="text/javascript">
	var expandAllFlag = <%=categoryname.equals("")?false:true%>;
	var demoLeftMenus = <%=result.getTreeCategories().toString()%>;
	
	demoLeftMenus = orderMenus(demoLeftMenus);
	
	function orderMenus(leftMenus){
		var _demoLeftMenus = [];
		for(var _i = leftMenus.length - 1 ;_i >= 0;_i--){
			_demoLeftMenus.push(leftMenus[_i]);
			for(var key in leftMenus[_i]){
				leftMenus[_i][key].submenus = orderMenus(leftMenus[_i][key].submenus);
			}
		}
		leftMenus = _demoLeftMenus;
		return leftMenus;
	}
	
	$(".ulDiv2").leftNumMenu(demoLeftMenus,{
			showZero:false,
			addDiyDom:false,
			multiJson:true,	
			_callback:expandAllFlag?_expandAll:null,	
			clickFunction:function(attr,level,numberType,node,options){
				leftMenuClickFn(attr,level,numberType,node,options);
			}
	});
</script>

<DIV align=right style="display:none">
<%

systemAdminMenu = "";

RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
if(!"0".equals(hasCancel)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%
if(!"0".equals(hasClear)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:clearCategory(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
</DIV>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
 </div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<%if(!"0".equals(hasClear)){ %>
		    		<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="clearCategory();">
		    	<%} %>
		    	<%if(!"0".equals(hasCancel)){ %>
		    		<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
				<%} %>
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			//resizeDialog(document);
			jQuery("#content").height(window.innerHeight - jQuery("#title").height() - jQuery("#zDialog_div_bottom").height());
			
			
			jQuery("#ztreeObj > li.level0 > .e8HoverZtreeDiv > button.level0").click();
		});
	</script>
</div>
</BODY></HTML>
