
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.systeminfo.SystemEnv"%> 
<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="MobileInit.jsp"%>
<HTML>
<HEAD>
     <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<link href="/mobile/plugin/browser/css/Weaver_wev8.css" rel="stylesheet" type="text/css" >
    <script type="text/javascript" src="/mobile/plugin/browser/js/zTree/js/jquery-1.4.4.min_wev8.js"></script>
	<link rel="stylesheet" href="/mobile/plugin/browser/js/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<script type="text/javascript" src="/mobile/plugin/browser/js/zTree/js/jquery.ztree.core.min_wev8.js"></script>
	<script type="text/javascript" src="/mobile/plugin/browser/js/zTree/js/jquery.ztree.excheck.min_wev8.js"></script>
    
</HEAD>

<%
String para=Util.null2String(request.getParameter("para"));

String treeDocFieldIds="";
String needPeop="";
int pos=para.indexOf("_");
if(pos==-1){
	if(para.length()!=0) treeDocFieldIds=para;
	else {
		treeDocFieldIds="";
		needPeop="0";
	}	
} else {
	treeDocFieldIds=para.substring(0,pos);
	needPeop=para.substring(pos+1);
}

String[] treeDocFieldIdArray=Util.TokenizerString2(treeDocFieldIds,",");


String nodeid=null;

boolean exist=false;
if(treeDocFieldIdArray.length>=1){
	nodeid="field_"+treeDocFieldIdArray[treeDocFieldIdArray.length-1];

    String treeDocFieldName=DocTreeDocFieldComInfo.getTreeDocFieldName(treeDocFieldIdArray[0]);
    if(!treeDocFieldName.equals("")){
		exist=true;
	}
    else{
        exist=false;
	}
}

if(!exist){
	nodeid=null;
}

String splitflag=Util.null2String(request.getParameter("splitflag"));
if("".equals(splitflag)) splitflag = ",";
%>


<BODY onload="" scroll="no" style="overflow-y: hidden;padding: 0px;margin: 0px;">
    <table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
        <colgroup>
        <col width="10">
        <col width="">
        <col width="10">
        <tr style="height: 430px;">
            <td ></td>
            <td valign="top">
                <TABLE class=Shadow style="width: 100%">
                    <tr>
                        <td  valign="top">
                            <FORM NAME=select STYLE="margin-bottom:0" action="DocReceiveUnitBrowserMulti.jsp" method=post>

      
                                <TABLE  ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">     
                                     <TR class=Line1><TH colspan="4" ></TH></TR>
                                      <TR  >
									  <input type="hidden" name="selObj">
                                          <TD height=420 colspan="4" width="100%">                                            
												<div id="deeptree" style="height:100%;width:100%;overflow:scroll;">
	                                            	<ul id="ztreedeep" class="ztree"></ul>
	                                            </div>
                                          </TD>
                                      </TR>  
                                       <tr> <td height="25" colspan="3"></td></tr>
								        <tr>
								        <td align="center" valign="bottom" colspan=3>  
									<BUTTON type='button' class=btn accessKey=O  id=btnok onclick="onSave()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
									<BUTTON type='button' class=btn accessKey=2  id=btnclear onclick="onClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
								        <BUTTON type='button' class=btnReset accessKey=T  id=btncancel onclick="window.parent.close()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
								        </td>
								        </tr>                                  
                                </TABLE>
                            </FORM>
                         </td>
                    </tr>
                </TABLE>
            </td>
            <td></td>
        </tr>
       
    </table>
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
	    	return "/mobile/plugin/browser/DocTreeDocFieldBrowserMultiXML.jsp?" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "/mobile/plugin/browser/DocTreeDocFieldBrowserMultiXML.jsp?needPeop=<%=needPeop%>" + "&" + new Date().getTime() + "=" + new Date().getTime();
	    }
	};
	//zTree配置信息
	var setting = {
		async: {
			enable: true,       //启用异步加载
			type:"get",
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

        var rootnodes = treeObj.getNodesByParamFuzzy("icon", "global16", null);
        setIsExistsCheckbox(treeObj, rootnodes, true);

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
	        window.parent.returnValue  = returnjson;
	        window.parent.close();
	    } else {
	        window.parent.close();     
		}
    }
    
    function onClear() {
	    window.parent.returnValue = {id:"", name:""};
	    window.parent.close();
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
	
	/**
	 * 设置某些节点集合是否显示checkbox
	 */
	function setIsExistsCheckbox(treeObj, nodes, flag) {
		if (nodes != undefined && nodes != null) {
			for (var i=0; i<nodes.length; i++) {
				if (nodes[i].nocheck == flag) {
					continue;
				}
				
				nodes[i].nocheck = flag;
				treeObj.updateNode(nodes[i]);
			}
		}
	}
	
	//-->
</SCRIPT>
</HTML>