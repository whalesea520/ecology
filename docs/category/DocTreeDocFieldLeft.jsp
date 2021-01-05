
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ page import="weaver.docs.category.DocTreeDocFieldConstant" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>

<%

String treeDocFieldId=Util.null2String(request.getParameter("treeDocFieldId"));
String err=Util.null2String(request.getParameter("err"));
%>
<%
User user = HrmUserVarify.getUser (request , response) ;
%>
	
	<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<base target="mainFrame"/>


<FORM NAME=SearchForm id="SearchForm" STYLE="margin-bottom: 0"
	action="DocTreeDocFieldDsp.jsp" method=post target="contentframe">
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<script>
		rightMenu.style.visibility = 'hidden'
	</script>

<table height="100%" width=100% class="LayoutTable">

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
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "/docs/category/DocTreeDocFieldLeftXML.jsp?" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "/docs/category/DocTreeDocFieldLeftXML.jsp";
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
			expandSpeed: "",     //效果
			showIcon:false
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
	    treeObj.expandAll(true);
		var node = treeObj.getNodeByParam("id", "field_<%=treeDocFieldId%>", null);
	    
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
		setTreeDocField(treeNode.id);
	};

	function setTreeDocField(nodeId) {
	    var treeDocFieldId = nodeId.substring(nodeId.lastIndexOf("_")+1);
		if(treeDocFieldId == <%=DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID%>){
			$("#SearchForm").attr("action", "DocTreeTab.jsp");
		    $("#hdnid").val(treeDocFieldId);
		    $("#SearchForm")[0].submit();
		}else{
			$("#SearchForm").attr("action", "DocTreeTab.jsp?_fromURL=2");
		    $("#hdnid").val(treeDocFieldId);
		    $("#SearchForm")[0].submit();
		}
	}
	jQuery(document).ready(function(){
		setTreeDocField("<%="field_"+DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID%>");
	});
</SCRIPT>