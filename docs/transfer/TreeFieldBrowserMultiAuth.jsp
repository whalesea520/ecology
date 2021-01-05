
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>

<%@ include file="/hrm/header.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page"/>
	
<HTML>
<HEAD>
	<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.excheck.min_wev8.js"></script>
    <script type="text/javascript">
		try{
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("20482",user.getLanguage())%>");
		}catch(e){
			if(window.console)console.log(e);
		}
		var parentWin = null;
		var parentDialog = null;
		try{
			parentWin = parent.parent.getParentWindow(parent);
			parentDialog = parent.parent.getDialog(parent);
		}catch(e){}
	</script>
</HEAD>

<%
String para=Util.null2String(request.getParameter("para"));

String treeDocFieldIds=Util.null2String(request.getParameter("idStr"));
String needPeop="1";

boolean isAll = Util.null2String(request.getParameter("isAll")).equalsIgnoreCase("true");
String _type = Util.null2String(request.getParameter("type"));
int fromid = Util.getIntValue(request.getParameter("fromid"));
String toid=Util.null2String(request.getParameter("toid"));
String jsonSql = Tools.getURLDecode(request.getParameter("jsonSql"));
String oldJson = jsonSql;
jsonSql = Tools.replace(jsonSql,"\"","\\\\\"");
		
int permissiontype =-1;
String codeName = Util.null2String(request.getParameter("_fromURL"));
if(codeName.startsWith("auth")) codeName=codeName.substring(4);
		
//虚拟目录
if("T145".equals(codeName)||"C145".equals(codeName)||"D125".equals(codeName)){//人员
	permissiontype=5;
}

StringBuilder _sql = new StringBuilder();
_sql.append("select distinct dirid from DirAccessControlList where dirtype=99 and permissiontype="+permissiontype+" and operationcode=99 and userid="+fromid);

rs.executeSql("select count(1) as count from (" + _sql.toString() + ") temp");
long count = 0;
if (rs.next()) {
	count = Long.parseLong(Util.null2String(rs.getString("count"), "0"));
}

MJson mjson = new MJson(oldJson, true);
if (mjson.exsit(_type)) {
	mjson.updateArrayValue(_type, _sql.toString());
} else {
	mjson.putArrayValue(_type, _sql.toString());
}
String oJson = Tools.getURLEncode(mjson.toString());
try{
	mjson.removeArrayValue(_type);
} catch(Exception e){}
String nJson = Tools.getURLEncode(mjson.toString());

if(isAll){
	treeDocFieldIds="";
	rs.executeSql("select distinct dirid from DirAccessControlList where dirtype=99 and permissiontype=5 and operationcode=99 and userid="+fromid);
	while(rs.next()){
		treeDocFieldIds +=","+rs.getString("dirid");
	}
	if(!"".equals(treeDocFieldIds)) treeDocFieldIds=treeDocFieldIds.substring(1);
}
String[] treeDocFieldIdArray=Util.TokenizerString2(treeDocFieldIds,",");

String splitflag=Util.null2String(request.getParameter("splitflag"));
if("".equals(splitflag)) splitflag = ",";
%>


<BODY onload="" scroll="no">
	<div class="zDialog_div_content">
	<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
    <DIV align=right>
    <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
    <%
    BaseBean baseBean_self = new BaseBean();
    int userightmenu_self = 1;
    try{
    	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
    }catch(Exception e){}
    if(userightmenu_self == 1){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(19323,user.getLanguage())+",javascript:needSelectAll(!parent.selectallflag,this),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
    }
    %>	
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if(userightmenu_self == 1){%>
    <script>
     rightMenu.style.visibility='hidden'
    </script>
<%}%>
    </DIV>

<FORM NAME=select STYLE="margin-bottom:0" action="DocReceiveUnitBrowserMulti.jsp" method=post>


  <wea:layout attributes="{'formTableId':'BrowseTable'}">
   	<wea:group context="" attributes="{'groupDisplay':'none'}">
   		<wea:item attributes="{'isTableList':'true'}">
			<input type="hidden" name="selObj">
			<div id="deeptree" style="height:100%;width:100%;overflow:scroll;">
                <ul id="ztreedeep" class="ztree"></ul>
            </div>
   		</wea:item>
	</wea:group>
  </wea:layout>
</FORM>
 <div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=0  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(555,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="selectDone();">
			    <input type="button" id=btnclear value="<%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="selectAll();">
			   	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
</BODY>



<script type="text/javascript">

	
	//<!--
	var cxtree_id = "";
	var selectallflag = false;
	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		//获取子节点时
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "/docs/category/DocTreeDocFieldBrowserMultiXML.jsp?" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "/docs/category/DocTreeDocFieldBrowserMultiXML.jsp?needPeop=<%=needPeop%>&fromid=<%=fromid%>&permissiontype=<%=permissiontype%>" + "&" + new Date().getTime() + "=" + new Date().getTime();
	    }
	};
	//zTree配置信息
	var setting = {
		async: {
			enable: true,       //启用异步加载
			dataType: "text",   //ajax数据类型
			url: getAsyncUrl    //ajax的url
		},
		check: {
			enable: true,       //启用checkbox或者radio
			chkStyle: "checkbox",  //check类型为checkbox
			chkboxType: { "Y" : "", "N" : "" } 
		},
		view: {
			expandSpeed: ""     //效果
		},
		callback: {
			onClick: zTreeOnClick,   //节点点击事件
			onCheck: zTreeOnCheck,
			onAsyncSuccess: zTreeOnAsyncSuccess  //ajax成功事件
		}
	};

	var zNodes =[
	];
	
	$(document).ready(function(){
		//初始化zTree
		$.fn.zTree.init($("#ztreedeep"), setting, zNodes);
	});
	
	function zTreeOnClick(event, treeId, treeNode) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
	};

	function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
		//window.console.log(msg);
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);

	    if (selectallflag) {
	    	 if (treeNode != undefined && treeNode != null) {
	 		    if (treeNode.checked) {
	 			    var childrenNodes = treeNode.childs;
	 		    	for (var i=0; i<childrenNodes.length; i++) {
	 		    		treeObj.checkNode(childrenNodes[i], true, false);
	 				}
	 		    }
	 	    }
	    }
	    
	    var node = null;
	    <%
	    for(int i=0;i<treeDocFieldIdArray.length;i++){
		%>
			node = treeObj.getNodeByParam("id", "field_<%=treeDocFieldIdArray[i] %>", null);
		    if (node != undefined && node != null ) {
		    	treeObj.selectNode(node);
		    	treeObj.checkNode(node, true, true);
		    }
		<%
		}
		%>
	}
	
	function selectDone(){
		
		var nameStr="";
	    var treeObj = $.fn.zTree.getZTreeObj("ztreedeep");
		var nodes = treeObj.getCheckedNodes(true);
		
		if (nodes == undefined || nodes == "" || nodes.length < 1) {
			
		} else {
			for (var i=0; i<nodes.length; i++) {
				nameStr += nodes[i].value+",";
			}	
		}
		
		if(nameStr.match(/,$/)){
				nameStr = nameStr.substring(0,nameStr.length-1);
			}
		
	if (parentDialog) {
		var data = {
			type: '<%=_type%>',
			isAll: false,
			id: nameStr,
			json: '<%=nJson%>'
		};
		parentDialog.callback(data);
		parentDialog.close();
	}
}

function selectAll(){
	var treeObj = $.fn.zTree.getZTreeObj("ztreedeep");
	treeObj.checkAllNodes(true);
			
	var data = {
		type: '<%=_type%>',
		isAll: true,
		count: <%=count%>,
		json: '<%=oJson%>'
	};
	parentDialog.callback(data);
	parentDialog.close();		
}
	
	function onSaveJavaScript(){
	    var nameStr="";
	    var idStr = "";
	    var treeObj = $.fn.zTree.getZTreeObj("ztreedeep");
		var nodes = treeObj.getCheckedNodes(true);
		
		if (nodes == undefined || nodes == "" || nodes.length < 1) {
			return "";
		}
		
		for (var i=0; i<nodes.length; i++) {
			nameStr += "," + nodes[i].value;
			idStr += "," + nodes[i].name;
		}
		
		resultStr = nameStr + "$" + idStr;
	    return resultStr;
	}
	
	function onSave() {
    	var  trunStr = "", returnVBArray = null;
	    trunStr =  onSaveJavaScript();
	    if(trunStr != "") {
			returnVBArray = trunStr.split("$");
			var returnjson = {id:returnVBArray[0], name:returnVBArray[1]};
	        if(parentDialog){
				try{
				parentDialog.callback(returnjson);
				}catch(e){}
				try{
				parentDialog.close(returnjson);
				}catch(e){}
			}else{
		        window.parent.returnValue  = returnjson;
		        window.parent.close();
		    }
	    } else {
	        if(parentDialog){
	    		parentDialog.close();
	    	}else{
	        	window.parent.close();
	        }
		}
    }
    
    function onClear() {
	    if(parentDialog){
	    	var returnjson = {id:"", name:""};
			try{
	    	parentDialog.callback(returnjson);
			}catch(e){}
			try{
	    	parentDialog.close(returnjson);
			}catch(e){}

	    }else{
		    window.parent.returnValue = {id:"", name:""};
		    window.parent.close();
		}
	}
	
	function onClose(){
		 if(parentDialog){
	    	parentDialog.close()
	    }else{
		    window.parent.close();
		}
	}
	
	function needSelectAll(flag, obj){
		selectallflag = flag;
	   
	   	var treeObj = $.fn.zTree.getZTreeObj("ztreedeep");
	   	var type = { "Y":"", "N": ""};
	   	if(selectallflag){
	   		type = { "Y":"s", "N": "s"};
	   	}
	   	treeObj.setting.check.chkboxType = type;
	   	var i = $(obj).html().indexOf('>');
	   	if(selectallflag){
	        a = $(obj).html().substring(0,i+1)+' <%=SystemEnv.getHtmlLabelName(19324,user.getLanguage())%>';
	    } else{
	    	a = $(obj).html().substring(0,i+1)+' <%=SystemEnv.getHtmlLabelName(19323,user.getLanguage())%>';
	    }
		$(obj).html(a);
	}
	
	function zTreeOnCheck(event, treeId, treeNode) {
		var treeObj = $.fn.zTree.getZTreeObj(treeId);

		var nodes = treeNode.childs;
		
		if (nodes == null || nodes == undefined) {
			treeObj.reAsyncChildNodes(treeNode, "refresh");
		} else {
			if (selectallflag && treeNode.checked) {
		    	for (var i=0; i<nodes.length; i++) {
			    	if (nodes[i].checked) {
			    		treeObj.checkNode(nodes[i], false, false);	
			    	}
			    	treeObj.checkNode(nodes[i], true, false);
				}
			}
		}
	}
	
	function check() {}
	//-->
</SCRIPT>
</HTML>