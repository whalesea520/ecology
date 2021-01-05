
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.general.Util,weaver.worktask.worktask.*"%>
<%@ page import="weaver.hrm.company.SubCompanyComInfo"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>

<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core.min_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.excheck.min_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>
<style>
	.root_docu {
		background-color: transparent;
	}
	button {
		background-color: transparent;
	}
	.tasklistspanel{
	    padding:10px;
	    background:#f4f4f4;
	    color:#696969;
	    position: relative;
	}
	.tasklistspanel .taskpanel{
	    margin-bottom:10px;
	}
	.tasklistspanel .tasktable{
	   table-layout: fixed;
	   width: 100%;
	   border-collapse: collapse;
	}
	.tasklistspanel .tasktable thead tr{
	   height:41px; 
	   background:#f0f3f3;
	   border:1px solid #e8e8e8;
	   border-right: 1px solid #d5d5d5;
	   border-left: 1px solid #d5d5d5;
	   border-top: 1px solid #d5d5d5;
	} 
	.tasklistspanel .tasktable thead th{
	   font-weight: normal;
       text-align: left; 
       padding:10px 12px;
       color:#696969;
	} 
	.tasklistspanel .tasktable tr{
	  border:1px solid #eeeeee;
	  background: #ffffff;
	  border-right: 1px solid #d5d5d5;
	  border-left: 1px solid #d5d5d5;
	  border-top: 1px solid #d5d5d5;
	}
	.tasklistspanel .tasktable tr td{
	   padding:10px 12px;
	    color:#696969;
	}
	.tasklistspanel .tasktable tr.rowlast{
	   border-bottom: 1px solid #d5d5d5;
	}
	.tasklistspanel .reqprocess{
	  height:15px;display:inline-block;background:#1bb6a1;vertical-align: middle;border-radius: 5px;
	}
	.tasklistspanel .processval{
	  width:30px;display:inline-block;text-align:center;color:#1bb6a1;
	}
	.tasklistspanel .taskprocess{
	  height:15px;display:inline-block;background:#F19A2E;vertical-align: middle;border-radius: 5px;
	}
	.tasklistspanel .taskprocessval{
	  width:30px;display:inline-block;text-align:center;color:#F19A2E;
	}
	.tasklistspanel .loadingicon{
		position: absolute;
		top: 0;
		left: 0;
		bottom: 0;
		width: 100%;
		text-align: center;
		background: #fff;
		opacity: .5;
		padding-top: 40%;  
	}
	.tasklistspanel .remindinfo{
	   text-align:center;
	   padding-top: 20px;
	}
	.tasklistspanel thead tr.overtimeremind{
	  border-top:2px solid red;
	}
</style>
</HEAD>


<%
String id = user.getUID() + "";
String selfitemdata = WorkTaskResourceUtil.getTasksAsJsonByUserid(id);
%>

<BODY style="overflow-y: hidden;" scroll=no>
    <input type='hidden' value='<%=user.getUID()%>' id='cuid' />
	<FORM NAME=SearchForm STYLE="margin-bottom:0;height:100%;"  method=post target="contentframe">

<table height="100%" width=100% cellspacing="0" cellpadding="0"  valign="top">
	<TR>
	<td height="100%" style="width:23%;" >
	    <div id="pageLeftContent" style="width:100%; width:224px;border-right:1px solid #cad1d7;float:left;">
	         <div style="height: 30px;line-height: 30px;padding-left: 10px;background: #f4fafc;border-bottom: 1px solid #E9E9E2;">
					<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"></span>
					<span style="font-size:14px;font-weight:bold"><%=SystemEnv.getHtmlLabelNames("442,320",user.getLanguage())%></span>
			</div>
			<div style="display:none">
						<span id="searchblockspan"><span  >
						    <input type="text"  style="vertical-align: top;width: 223px;height: 27px;line-height: 27px;"><span class="middle searchImg" style="position: absolute; right: 0px;top: 37px;">
						    <img class="middle" style="vertical-align:top;margin-top:2px;" src="/images/ecology8/request/search-input_wev8.png"></span>
						</span></span>
			</div>
			<div id="deeptree" style="height:100%;width:100%;overflow:scroll;">
                <ul id="ztreedeep" class="ztree"></ul>
            </div> 
	    </div>
	    <div id="tasklistspanel" class='tasklistspanel' style='overflow:auto;'>
	    
	    
	    </div>
	</td>
	</tr>
	</table>
	</FORM>



<script type="text/javascript" src="/worktask/js/tasklist_wev8.js"></script>
<script type="text/javascript">

   var itemdatas = <%=selfitemdata%>;
	
	//<!--
	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		//获取子节点时
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "/worktask/task/GetSubordinateXML.jsp?" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "/worktask/task/GetSubordinateXML.jsp?id=<%=id%>" + "&" + new Date().getTime() + "=" + new Date().getTime();
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
			enable: false       //启用checkbox或者radio

		},
		view: {
			expandSpeed: ""     //效果
		},
		callback: {
			onClick: zTreeOnClick,   //节点点击事件
			onAsyncSuccess: zTreeOnAsyncSuccess  //ajax成功事件
			
		}
	};

	var zNodes =[
	];
	
	$(document).ready(function(){
		//初始化zTree
		$.fn.zTree.init($("#ztreedeep"), setting, zNodes);
		//$("#overFlowDiv").perfectScrollbar();
		$("#tasklistspanel").css("height",($(document.body).height()+"px"));
		$("#pageLeftContent").css("height","100%");
	});
	
	function zTreeOnClick(event, treeId, treeNode) {
	    resetPageRightSrc(treeNode.id);
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	   // if (treeNode.isParent) {
		//	treeObj.expandNode(treeNode);
		//}
		treeObj.checkNode(treeNode, true, false);
		setTaskItems(treeNode.id);
		
	};

	function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
		var nodes = treeObj.transformToArray(treeObj.getNodes());
		if(nodes.length == 1){
			treeObj.expandNode(nodes[0]);
		}
		//treeObj.expandAll(true); 
		//$("#overFlowDiv").perfectScrollbar("update");
	}

	function setTaskItems(userid){
	          var senddata = {};
	          senddata["userid"] = userid;
	          tasklistviews.addLoadingItem();
		      $.ajax({
					  type: "POST",
					  url:"/worktask/pages/gettasklists.jsp",
					  dataType:'json',
					  data:senddata,
					  success:function(data){
					      tasklistviews.removeLoadingItem();
						  tasklistviews.generatorPanels(data);
						//  console.dir(data);
					  }
			    });
	}
	
	function resetPageRightSrc(userid){
	  if(userid !="<%=user.getUID() %>"){
	      $("#pageRight", window.parent.document).attr("src","/worktask/task/tasktab.jsp?subuserid="+userid);
	  }
	}
	//生成面板
	tasklistviews.generatorPanels(itemdatas);
	//-->
</SCRIPT>


</BODY>
</HTML>