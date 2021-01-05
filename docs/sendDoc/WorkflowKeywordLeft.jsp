
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<jsp:useBean id="WorkflowKeywordComInfo"
	class="weaver.docs.senddoc.WorkflowKeywordComInfo" scope="page" />

<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.Util" %>
<%

String keywordId=Util.null2String(request.getParameter("keywordId"));

boolean exist=false;
if(keywordId!=null){
	exist=WorkflowKeywordComInfo.getKeywordName(""+keywordId).equals("")?false:true;
}

if(!exist){
	keywordId="";
}

%>

<FORM NAME=SearchForm id="SearchForm" STYLE="margin-bottom: 0"
	action="WorkflowKeywordDsp.jsp" method=post target="contentframe">


<table height="100%" width=100% class="LayoutTable e8_Noborder" valign="top">

	<!--######## Search Table Start########-->
	<TR>
		<td height="100%">
		<div id="ztreeDiv" style="height:100%;width:100%;">
             	<ul id="ztreeObj" class="ztree"></ul>
             </div>
		</td>
	</tr>
</table>

<input class=inputstyle type="hidden" name="id" id="hdnid"> <!--########//Search Table End########-->
</FORM>

<script type="text/javascript">
	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		//获取子节点时
		var keywordId = null;
		if(!!treeNode && !!treeNode.id){
			keywordId = treeNode.id.replace(/\D/g,"");
		}
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "/docs/sendDoc/WorkflowKeywordLeftXML.jsp?keywordId="+keywordId+"&" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "/docs/sendDoc/WorkflowKeywordLeftXML.jsp<%if(keywordId!=null){%>?init=true&keywordId=<%=keywordId%><%}%>";
	    }
	};
	//zTree配置信息
	var setting = {
		async: {
			enable: true,       //启用异步加载
			dataType: "text",   //ajax数据类型
			url: getAsyncUrl    //ajax的url
		},
		data: {
			simpleData: {
				enable: true,   //返回的json数据为简单数据类型，非复杂json数据类型
				idKey:"id",     //tree的标识属性
				pIdKey:"pId",   //父节点标识属性
				rootPId: 0      //顶级节点的父id
			}
		},
		view: {
			expandSpeed: ""     //效果
		},
		callback: {
			onClick: zTreeOnClick,   //节点点击事件
			onAsyncSuccess: zTreeOnAsyncSuccess  //ajax成功事件
		}
	};

	var zNodes =[];
	
	$(document).ready(function(){
		//初始化zTree
		$.fn.zTree.init($("#ztreeObj"), setting, zNodes);
	});
	
	function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    //treeObj.expandAll(true);keyword_0
	    var node = treeObj.getNodeByParam("id", "keyword_<%=keywordId%>", null);
	    
	    if (node != undefined && node != null ) {
	    	treeObj.selectNode(node);
	    	zTreeOnClick(event, treeId, node);
	    }
	}
	
	function zTreeOnClick(event, treeId, treeNode) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
		setKeyword(treeNode.id);
	};


	function setKeyword(nodeId) {

	    var keywordId=nodeId.substring(nodeId.lastIndexOf("_")+1);

		if(keywordId==0){
		    $("#SearchForm").attr("action", "DocKeywordTab.jsp");
		    $("#hdnid").val(keywordId);
		    $("#SearchForm")[0].submit();
		}else{
		    $("#SearchForm").attr("action", "DocKeywordTab.jsp?_fromURL=2");
		    $("#hdnid").val(keywordId);
		    $("#SearchForm")[0].submit();
		}
	}
</SCRIPT>