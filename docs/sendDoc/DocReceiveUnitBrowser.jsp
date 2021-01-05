
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<%

int userId=user.getUID();
// 传递的值，格式为excludeid_superiorUnitId.
String rightStr_tmp = Util.null2String(request.getParameter("rightStr"));
String transferValue=Util.null2String(request.getParameter("transferValue"));
String[]  transferValueArray=Util.TokenizerString2(transferValue,"_");
String excludeid=Util.null2String(request.getParameter("excludeid"));
String id=Util.null2String(request.getParameter("id"));
String superiorUnitId=Util.null2String(request.getParameter("superiorUnitId"));
session.setAttribute("rightStr_tmp"+user.getUID(), rightStr_tmp);
if(excludeid.equals("")&&transferValueArray.length>=1){
	excludeid=Util.null2String(transferValueArray[0]);
}

if(superiorUnitId.equals("")&&transferValueArray.length>=2){
    superiorUnitId=Util.null2String(transferValueArray[1]);
}

String nodeid="unit_"+superiorUnitId;

boolean exist=false;

String receiveUnitName=DocReceiveUnitComInfo.getReceiveUnitName(superiorUnitId);
if(!receiveUnitName.equals("")){
	exist=true;
}
else{
	exist=false;
}

if(!exist){
	nodeid=null;
}

%>

<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
    <script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery-1.4.4.min_wev8.js"></script>
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core.min_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.excheck.min_wev8.js"></script>
</HEAD>



<BODY>
    <DIV align=right>
    <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
    <%
    BaseBean baseBean_self = new BaseBean();
    int userightmenu_self = 1;
    try{
    	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
    }catch(Exception e){}
    if(userightmenu_self == 1){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSave(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;

        RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;

        RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
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

    <table   width=100% height=100% border="0" cellspacing="0" cellpadding="0">
        <colgroup>
        <col width="10">
        <col width="">
        <col width="10">
        <tr>
            <td height="10" colspan="3"></td>
        </tr>
        <tr>
            <td ></td>
            <td valign="top">
                <TABLE  class=Shadow>
                    <tr>
                        <td valign="top">
                            <FORM NAME=select STYLE="margin-bottom:0" action="DepartmentBrowser.jsp" method=post>

                                <TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
                                     <TR class=Line1><TH colspan="4" ></TH></TR>
                                      <TR>
                                          <TD height=450 colspan="4" width="100%">
                                            <!-- 
                                            <div id="deeptree" class="deeptree" CfgXMLSrc="/css/TreeConfig.xml" />
                                             -->
                                             <div id="deeptree" style="height:100%;width:100%;overflow:scroll;">
                                            	<ul id="ztreedeep" class="ztree"></ul>
                                            </div>
                                          </TD>
                                      </TR>
                                      <tr> <td height="10" colspan="3"></td></tr>
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
</HTML>

<script type="text/javascript">
	//<!--
	var cxtree_id = "<%=nodeid %>";
	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		//获取子节点时
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "/docs/sendDoc/DocReceiveUnitBrowserSingleXML.jsp?" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "/docs/sendDoc/DocReceiveUnitBrowserSingleXML.jsp?excludeid=<%=excludeid%>&superiorUnitId=<%=superiorUnitId%>" + "&" + new Date().getTime() + "=" + new Date().getTime();
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
			chkStyle: "radio",  //check类型为radio
			radioType: "all",   //radio选择范围
			chkboxType: { "Y" : "", "N" : "" } 
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
	});
	
	function zTreeOnClick(event, treeId, treeNode) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
		treeObj.checkNode(treeNode, true, false);
	};


	function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    var node = treeObj.getNodeByParam("id", cxtree_id, null);
	    treeObj.expandAll(true);
	    
	    if (node != undefined && node != null ) {
	    	treeObj.selectNode(node);
	    	treeObj.checkNode(node, true, true);
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
			nameStr = nodes[i].nodeid;
			idStr = nodes[i].name;
		}
		var arraytemp = nameStr.split("_");
	
	    var resultStr = "0";
	    if(arraytemp.length > 1) {
	    	resultStr = arraytemp[1];;
	    }
	
		var strtmp2 = "";
		for(var i=0;i<arraytemp.length;i++){
			if(i>2){
				strtmp2 = strtmp2 + "_" + arraytemp[i];
			}
		}
		resultStr = resultStr + "$" + idStr;
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
	//-->
</SCRIPT>