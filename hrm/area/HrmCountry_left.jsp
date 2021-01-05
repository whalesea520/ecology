
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<%
	String cid = Util.null2String(request.getParameter("cid"));
	String searchStr = Util.null2String(request.getParameter("searchStr"));
	if(cid.length() == 0 || CountryComInfo.getCountryname(cid).length() == 0){
		cid = "";
	}
%>
<HTML><HEAD>
<style>
.ztree li span.button.ico_close {
    background: rgba(0, 0, 0, 0) none repeat scroll 0 0;
    width:0px !important;
}
.ztree li span.button.ico_open  {
    background: rgba(0, 0, 0, 0) none repeat scroll 0 0;
    width:0px !important;
}
.ztree li span.button.ico_docu {width:0px !important;}
</style>
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />

	<script language="javascript" src="/js/weaver_wev8.js"></script>
	<script type="text/javascript" src="/js/hrm/ztree/js/jquery.ztree.core-3.5_wev8.js"></script>
	<script type="text/javascript" src="/js/hrm/ztree/js/jquery.ztree.excheck-3.5.min_wev8.js"></script>
	<script type="text/javascript" src="/js/hrm/ztree/js/jquery.ztree.exedit-3.5_wev8.js"></script>
	<script type="text/javascript" src="/js/hrm/ztree/js/jquery.ztree.exhide-3.5_wev8.js"></script>
	<script type="text/javascript" src="/js/hrm/ztree/js/ajaxmanager_wev8.js"></script>
	<script type='text/javascript' src='/dwr/interface/Validator.js'></script>
	<script type='text/javascript' src='/dwr/engine.js'></script>
	<script type='text/javascript' src='/dwr/util.js'></script>
			<link rel="stylesheet" href="/hrm/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
			<link REL="stylesheet" type="text/css" href="/css/Weaver_wev8.css" />
			
<script type="text/javascript">

if (navigator.userAgent.indexOf("MSIE 8.0")>0 || navigator.userAgent.indexOf("MSIE 7.0")>0 || navigator.userAgent.indexOf("MSIE 6.0")>0) {
	jQuery(document).ready(function () {
		jQuery("#ztreeDiv").css("height", "500px").css("overflow-y","scroll");
	});
}
</script>
</HEAD>
<BODY>

<FORM NAME=SearchForm id="SearchForm" STYLE="margin-bottom: 0" action="HrmCountry.jsp" method=post target="contentframe">
	<table height="100%" width=100% class="">
		<TR>
			<td>
				<div class="e8_loading" id="e8_loading" style="width: 217px;top:0px; "><%=SystemEnv.getHtmlLabelName(126719, user.getLanguage())%>...</div>
				<div id="scrollcontainer1" style="overflow:hidden;">
					<div id="ztreeDiv" style="height:100%;width:100%;overflow:auto;">
							<ul id="ztreeObj" class="ztree">
							</ul>
						 </div>
				</div>
			</td>
		</tr>
	</table>
	<input class=inputstyle type="hidden" name="countryid" id="countryid">
	<input class=inputstyle type="hidden" name="provinceid" id="provinceid">
	<input class=inputstyle type="hidden" name="cityid" id="cityid">
	<input class=inputstyle type="hidden" name="citytwoid" id="citytwoid">
</FORM>
<script type="text/javascript">
	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		//获取子节点时
		var cid = null;
		if(!!treeNode && !!treeNode.id){
			cid = treeNode.id.replace(/\D/g,"");
		}
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "/hrm/area/HrmCountry_leftXml.jsp?searchStr=<%=searchStr%>&selectedids=&id=" + treeNode.id + "&type="+treeNode.type+"&" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "/hrm/area/HrmCountry_leftXml.jsp?searchStr=<%=searchStr%><%if(cid!=null){%>&init=true&id=<%=cid%><%}%>";
	    }
	};
	//zTree配置信息
	var setting = {
		async: {
			enable: true,       //启用异步加载
			dataType: "text",   //ajax数据类型
			url: getAsyncUrl    //ajax的url
		},
		view: {
			expandSpeed: "",   //效果
			fontCss: getFont,
			showTitle: false,
			nameIsHTML: true,
			showLine: false,
			dblClickExpand: false
		},
		callback: {
			beforeAsync: zTreeBeforeAsync,
			onClick: zTreeOnClick,   //节点点击事件
			onAsyncSuccess: zTreeOnAsyncSuccess1  //ajax成功事件
		}
	};

	var zNodes =[];
	
	jQuery(document).ready(function(){
		//初始化zTree
		jQuery.fn.zTree.init(jQuery("#ztreeObj"), setting);
		var wHeight= window.parent.innerHeight;
		jQuery('#scrollcontainer1').css("height",wHeight-100);
		jQuery('#scrollcontainer1').perfectScrollbar();
		window.parent.onfouc();
	});
	
	 function getFont(treeId, node) {
		return node.font ? node.font : {};
	}
	function zTreeBeforeAsync(treeId, treeNode) {
    	jQuery('#e8_loading').show();
	};
	function zTreeOnAsyncSuccess1(event, treeId, treeNode, msg){
		jQuery('#e8_loading').hide();
		window.parent.onfouc();
	}
	function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
	    var treeObj = jQuery.fn.zTree.getZTreeObj(treeId);
	    //treeObj.expandAll(true);keyword_0
	    var node = treeObj.getNodeByParam("id", "country_<%=cid%>", null);
	    
	    if (node != undefined && node != null ) {
	    	treeObj.selectNode(node);
	    	zTreeOnClick(event, treeId, node);
	    }
	}
	
	function zTreeOnClick(event, treeId, treeNode) {
	    var treeObj = jQuery.fn.zTree.getZTreeObj(treeId);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
		if(treeNode.type == "country"){
			setCountry(treeNode.id);
		}else if(treeNode.type == "province"){
			setProvince(treeNode.id)
		}else if(treeNode.type == "city"){
			setCity(treeNode.id);
		}else if(treeNode.type == "citytwo"){
			setCityTwo(treeNode.id);
		}
		
	};


	function setCountry(nodeId) {
	    var cid=nodeId.substring(nodeId.lastIndexOf("_")+1);
	    if(cid == 0){
			jQuery("#SearchForm").attr("action", "/hrm/HrmTab.jsp?_fromURL=hrmAreaCountry");
	    }else{
			jQuery("#SearchForm").attr("action", "/hrm/HrmTab.jsp?_fromURL=hrmAreaProvince");
	    }
		jQuery("#countryid").val(cid);
		jQuery("#provinceid").val('');
		jQuery("#cityid").val('');
		jQuery("#citytwoid").val('');
		jQuery("#SearchForm")[0].submit();
	}
	
	function setProvince(nodeId) {
	    var pid=nodeId.substring(nodeId.lastIndexOf("_")+1);
		jQuery("#SearchForm").attr("action", "/hrm/HrmTab.jsp?_fromURL=hrmAreaCity");
		jQuery("#countryid").val('');
		jQuery("#provinceid").val(pid);
		jQuery("#cityid").val('');
		jQuery("#citytwoid").val('');
		jQuery("#SearchForm").submit();
	}
	
	function setCity(nodeId) {
	    var pid=nodeId.substring(nodeId.lastIndexOf("_")+1);
		jQuery("#SearchForm").attr("action", "/hrm/HrmTab.jsp?_fromURL=HrmAreaCityTwo");
		jQuery("#countryid").val('');
		jQuery("#provinceid").val('');
		jQuery("#cityid").val(pid);
		jQuery("#citytwoid").val('');
		jQuery("#SearchForm").submit();
	}
	
	function setCityTwo(nodeId) {
	    var pid=nodeId.substring(nodeId.lastIndexOf("_")+1);
		jQuery("#SearchForm").attr("action", "/hrm/HrmTab.jsp?_fromURL=HrmAreaCityTwo");
		jQuery("#countryid").val('');
		jQuery("#provinceid").val('');
		jQuery("#cityid").val('');
		jQuery("#citytwoid").val(pid);
		jQuery("#SearchForm").submit();
	}
</SCRIPT>
</BODY>
</HTML>