
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.systeminfo.SystemEnv"%> 

<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page"/>
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserService" class="weaver.mobile.browser.BrowserService" scope="page" />
<%@ include file="MobileInit.jsp"%>
<HTML>
<HEAD>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="/mobile/plugin/browser/css/Weaver_wev8.css" rel="stylesheet" type="text/css" >
    <script type="text/javascript" src="/mobile/plugin/browser/js/zTree/js/jquery-1.4.4.min_wev8.js"></script>
	<link rel="stylesheet" href="/mobile/plugin/browser/js/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<script type="text/javascript" src="/mobile/plugin/browser/js/zTree/js/jquery.ztree.core-3.1.min_wev8.js"></script>
	<script type="text/javascript" src="/mobile/plugin/browser/js/zTree/js/jquery.ztree.excheck-3.1.min_wev8.js"></script>
	<style>
		.ztree span{
			word-break:break-all;
		}
		
		.ztree li button.ico_docu {
			background-position: -80px 0;
		}
		
		#selectAll {
			display: inline-block;
			float: right;
			color: #1098ff;
			border: 1px solid #aecef1;
			padding: 0 10px;
			height: 23px;
			line-height: 23px;
			cursor: pointer;
		}
		
		div#selectAll.open {
			color: #ffffff;
			background-color: #1098ff;
		}
	</style>
</HEAD>

<%
int uid=user.getUID();
String type=Util.null2String(request.getParameter("nodetype"));
String id=Util.null2String(request.getParameter("id"));

String para=Util.null2String(request.getParameter("para"));
String isRemember = "false";
String remeStr = "" ;
String mainCateStr = ",";
String subCateStr = ",";
if(!"".equals(para) && !"0".equals(para) && !"remember0".equals(para)){
	if(para.startsWith("remember")){
		para = para.substring(8);
	}
	isRemember = "true";
	String[] secFieldIdArray=Util.TokenizerString2(para,",");
	for(int strIndex=0;strIndex<secFieldIdArray.length;strIndex++){
		String tempSecFieldId = secFieldIdArray[strIndex];
		remeStr +="secField_"+tempSecFieldId+".parentElement.getElementsByTagName(\"INPUT\")[0].checked=true;"
				+"secField_"+tempSecFieldId+".style.color='red';";
				
		String tempSubFieldId = SecCategoryComInfo.getSubCategoryid(tempSecFieldId);
		subCateStr += tempSubFieldId+",";
		mainCateStr += SubCategoryComInfo.getMainCategoryid(tempSubFieldId)+",";
	}
}
String treeDocFieldIds="";
String needPeop="";
Cookie[] cks= request.getCookies();
String rem=null;   
String nodeid=null;
String nodeids=null;
/*
for(int i=0;i<cks.length;i++){
	//System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
if(cks[i].getName().equals("doclistmulti"+uid)){
  rem=cks[i].getValue();
  break;
}
}
*/
if(rem!=null&&rem.length()>1)
nodeids=rem.substring(1);
if(nodeids!=null){
 if(nodeids.indexOf("|")>-1){
  nodeid=nodeids.substring(nodeids.lastIndexOf("|")+1);
 }else
  nodeid=nodeids;
}

boolean exist=true;

String[] ids=Util.TokenizerString2(nodeids,"|");


String splitflag=Util.null2String(request.getParameter("splitflag"));
if("".equals(splitflag)) splitflag = ",";

if("".equals(para)) {
	para = Util.null2String(request.getParameter("selectids"));
}

%>


<BODY style="overflow-y: hidden;padding: 0px;margin: 0px;">
    <table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
        <colgroup>
        <col width="10">
        <col width="">
        <col width="10">
        <tr>
            <td ></td>
            <td valign="top">
                <TABLE class=Shadow style="width: 100%">
                    <tr>
                        <td  valign="top">
                            <FORM NAME=select STYLE="margin-bottom:0" action="CategoryBrowser.jsp" method=post>
							<input class=inputstyle type=hidden name=id value="<%=id%>">
							<input class=inputstyle type=hidden name=type value="<%=type%>">
                                <div style="height: 463px;overflow:auto;overflow-x:hidden;">
                                <TABLE  ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0;TABLE-LAYOUT:fixed;word-break:break-all" width="100%">
                                	<TR class=Line1><TH colspan="4" ></TH></TR>
                                	<tr><td colspan="4">
                                		<span style="font-weight: bold;padding-left: 7px;float: left;padding-top: 9px;"><%=SystemEnv.getHtmlLabelName(33092,user.getLanguage())%></span>
                                		<div id="selectAll" style=""><%=SystemEnv.getHtmlLabelName(19323,user.getLanguage())%></div>
                                		</td>
                                	</tr>
                                      <TR>
                                          <TD height=430 colspan="4" width="500" nowrap="nowrap">                                            
                                                <div id="deeptree" style="height:100%;width:100%;overflow:scroll;">
	                                            	<ul id="ztreedeep" class="ztree"></ul>
	                                            </div>                                             
                                          </TD>
                                      </TR>                                    
                                </TABLE>
                                </div>
                                <div style="height: 40px;padding-top: 25px;" align="center">
                                    <BUTTON type="button" class=btn accessKey=O  id=btnok onclick="onSave()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
	                                <BUTTON type="button" class=btn accessKey=2  id=btnclear onclick="onClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
                                    <BUTTON type="button" class=btnReset accessKey=T  id=btncancel onclick="window.parent.close()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
                                </div>
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
	var selectallflag=false;
	var isremember = "<%=isRemember%>";
	var selectedids = "<%=para%>";
	var cxtree_id = "<%=para%>";
	var cxtree_ids;
	if(selectedids!="0"&&selectedids!=""){
		cxtree_id = "<%=para%>";
		cxtree_ids = cxtree_id.split(',');
		cxtree_id = cxtree_ids[0];
	}
	
	//zTree配置信息
	var setting = {
		check: {
			enable: true,       //启用checkbox或者radio
			chkStyle: "checkbox",  //check类型为checkbox
			chkboxType: { "Y":"", "N": ""} 
		},
		view: {
			expandSpeed: ""     //效果
		},
		callback: {
			onClick: zTreeOnClick,   //节点点击事件
			onCheck: zTreeOnCheck
		}
	};

	var zNodes = <%=BrowserService.getAllDocCategories(user, para) %>;
	
	$(document).ready(function(){
		//初始化zTree
		var treeObj = $.fn.zTree.init($("#ztreedeep"), setting, zNodes);
		var nodes = treeObj.getCheckedNodes(true);
		for(var i=0; i<nodes.length; i++) {
			expendParentNode(treeObj, nodes[i]);
		}
		
		$("#selectAll").click(function(){
			selectallflag = !selectallflag;
			var treeObj = $.fn.zTree.getZTreeObj("ztreedeep");
			var type = { "Y":"", "N": ""};
			if(selectallflag) type = { "Y":"s", "N": "s"};
			treeObj.setting.check.chkboxType = type;
			if(selectallflag) {
				$(this).addClass("open").html("<%=SystemEnv.getHtmlLabelName(19324,user.getLanguage())%>");
			} else {
				$(this).removeClass("open").html("<%=SystemEnv.getHtmlLabelName(19323,user.getLanguage())%>");
			}
		});
	});
	
	function expendParentNode(treeObj, node) {
		var parentNode = node.getParentNode();
		if(!parentNode || parentNode.open == true) return;
		treeObj.expandNode(parentNode, true);
		expendParentNode(treeObj, parentNode);
	}
	
	function zTreeOnClick(event, treeId, treeNode) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
	};
	
	function onSaveJavaScript(){
	    var nameStr="";
	    var idStr = "";
	    var treeObj = $.fn.zTree.getZTreeObj("ztreedeep");
		var nodes = treeObj.getCheckedNodes(true);
		
		if (nodes == undefined || nodes == "" || nodes.length < 1) {
			return "";
		}
		
		for (var i=0; i<nodes.length; i++) {
			nameStr += "," + nodes[i].name;
			idStr += "," + nodes[i].nodeValue;
		}
		
		resultStr = encodeURIComponent(idStr) + "$" + encodeURIComponent(nameStr);
	    return resultStr;
	}
	
	function onSave() {
    	var  trunStr = "", returnVBArray = null;
	    trunStr =  onSaveJavaScript();
	    if(trunStr != "") {
			returnVBArray = trunStr.split("$");
			var returnjson = {id:decodeURIComponent(returnVBArray[0]), name:decodeURIComponent(returnVBArray[1])};
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
	
	function zTreeOnCheck(event, treeId, treeNode) {
		if(!selectallflag) return;
		var treeObj = $.fn.zTree.getZTreeObj(treeId);
		treeObj.expandNode(treeNode, true, true);
	}
	//-->
</SCRIPT>



