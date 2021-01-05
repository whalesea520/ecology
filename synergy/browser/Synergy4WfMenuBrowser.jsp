
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page"/>
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML>
<HEAD>
    <link href="/css/Weaver_wev8.css" rel="stylesheet" type="text/css" >
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.excheck.min_wev8.js"></script>
</HEAD>

<%
int uid=user.getUID();
String type=Util.null2String(request.getParameter("nodetype"));
String id=Util.null2String(request.getParameter("id"));

String para=Util.null2String(request.getParameter("para"));
String isRemember = "false";
String remeStr = "" ;
 
 
%>


<BODY>
	<div class="zDialog_div_content">
		<table id="topTitle" cellpadding="0" cellspacing="0" >
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan">
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table> 
    <DIV align=right>
    <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
    <%
        RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSave(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;

        RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
        
    %>	
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
    <script>
     rightMenu.style.visibility='hidden';
     var parentWin = null;
		var dialog = null;
		try{
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		}catch(e){}
    </script>
    
    </DIV>
   
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
    <div id="zDialog_div_bottom" class="zDialog_div_bottom">
	    <wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
			    	<input type="button" accessKey=O  id=btnok  value="<%="O-"+SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" id="zd_btn_submit_0" class="zd_btn_submit" onclick="onSave();">
			    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="onClear();">
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
</div> 
</BODY>
</HTML>
	<SCRIPT type="text/javascript">
	var selectallflag=true;
	var cxtree_ids;
	  function onSave() {
    	var  trunStr = "", returnVBArray = null;
	    trunStr =  onSaveJavaScript();
	    if(trunStr != "") {
			returnVBArray = trunStr.split("$");
			var returnjson = {id:returnVBArray[0], name:returnVBArray[1]};
	        if(dialog){
				var isdel = $("input[name=norepeatedname]",parent.document).attr("checked")?"1":"0";
				parentWin.copyLayoutSetforChoose(isdel,returnVBArray[0],"doc","menu");
				dialog.close()
			}else{
		        window.parent.returnValue  = returnjson;
		        window.parent.close();
		    }
	    } else {
			if(dialog){
	    		dialog.close();
	    	}else{
	        	window.parent.close();
	        } 
		}
    }
    
   function onClear() {
	    if(dialog){
	    	var returnjson = {id:"", name:""};
	    	//dialog.callback(returnjson);
	    	dialog.close()
	    }else{
		    window.parent.returnValue = {id:"", name:""};
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
	
	
		<!--
		var setting = {
			async: {
				enable: true,
				url: getUrl
			},
			check: {
				enable: true,
				chkStyle: "checkbox",
				chkboxType: { "Y": "ps", "N": "ps" }
			},
			data: {
				simpleData: {
					enable: true
				},
				keep: {
					parent: true
				}
			},
			view: {
				expandSpeed: ""
			},
			  callback: {
			   onClick: zTreeOnClick,   //节点点击事件
			   onCheck: zTreeOnCheck,
			   onAsyncSuccess: zTreeOnAsyncSuccess  //ajax成功事件
			 }
		};

	 
		function getUrl(treeId, treeNode) {
			var param =""; 
		    if(treeNode){
		       param="id="+treeNode.id;
		    }
			return "/synergy/browser/Synergy4MenuBrowserOperation.jsp?" + param+"&stype=wf&language=<%=user.getLanguage()%>";
		}
		$(document).ready(function(){
			$.fn.zTree.init($("#ztreedeep"),setting);
		});
		
		function zTreeOnClick(event, treeId, treeNode) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
	};
		var flagre='false';
		function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
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
		
	    if (cxtree_ids != undefined && cxtree_ids != null && flagre=='false') {
			flagre='true';
		    for (var z=0; z<cxtree_ids.length; z++) {
				node = treeObj.getNodeByParam("id", "q_" + cxtree_ids[z], null);
			    if (node != undefined && node != null ) {
			    	treeObj.selectNode(node);
			    	treeObj.checkNode(node, true, false);
			    }
		    }
		}
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
		 var checkid=""+nodes[i].id;
		 if (checkid.indexOf("q_")<0) {
				nameStr += "," + nodes[i].id;
				idStr += "," + nodes[i].name;
			 }
		}
	 	resultStr = nameStr + "$" + idStr;
	    return resultStr;
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
	
	
		 function onCheck(e,treeId,treeNode){
            var treeObj=$.fn.zTree.getZTreeObj("treeDemo"),
            nodes=treeObj.getCheckedNodes(true),
            v="";
            for(var i=0;i<nodes.length;i++){
               v+= nodes[i].id+",";
            }
              document.getElementById('test').value=v;
            }
		
       
		//-->
	</SCRIPT>
 
	 