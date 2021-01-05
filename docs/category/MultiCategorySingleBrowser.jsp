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
    String currentSecId = Util.null2String(request.getParameter("currentSecId"));
    
    String hasClear = Util.null2String(request.getParameter("hasClear")); //是否有清楚按钮 0为没有，1或者空为有
    String hasCancel = Util.null2String(request.getParameter("hasCancel")); //是否有取消按钮 0为没有，1或者空为有
    String hasWarm = Util.null2String(request.getParameter("hasWarm")); //选中后是否有提醒 1为有，0或者空为没有
    
    Map<String,Object> params = new HashMap<String,Object>();
    params.put("currentSecId",currentSecId);
    MultiAclManager am = new MultiAclManager();
    if (categoryid != -1 && categorytype != -1) {
        if (!am.hasPermission(categoryid, categorytype, user.getUID(), user.getType(), Util.getIntValue(user.getSeclevel(),0), operationcode)) {
            response.sendRedirect("/notice/noright.jsp");
        	return;
        }
    }
    MultiCategoryTree tree = am.getPermittedTree(user.getUID(), user.getType(), Util.getIntValue(user.getSeclevel(),0), operationcode,categoryname,-1,params);
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
  	var returnjson = {id:"",name:""};
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
	
var data = {tag:1,id:""+id, path:""+path, mainid:""+mainid, subid:""+subid};
	if("<%=hasWarm%>" == "1"){
		window.top.Dialog.confirm("确定要发布到此目录吗?",function(){
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
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_top" onclick="onSearch();">
				<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<form name="SearchForm" id="SearchForm" method="post" action="MultiCategorySingleBrowser.jsp">
	<input type="hidden" name="operationcode" value="<%=operationcode %>"/>
	<input type="hidden" name="categoryid" value="<%=categoryid %>"/>
	<input type="hidden" name="categorytype" value="<%=categorytype %>"/>
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
	var demoLeftMenus = <%= tree.getTreeCategories().toString()%>;
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
if(!"0".equals(hasCancel)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<BUTTON type="button" class=btn accessKey=1 onclick="onClose()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
if(!"0".equals(hasClear)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<BUTTON type="button" class=btn accessKey=2 onclick="clearCategory()" id=btnclear><U></U><%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
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
			resizeDialog(document);
		});
	</script>
</div>
</BODY></HTML>
