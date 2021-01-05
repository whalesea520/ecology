<%@ page language="java" contentType="text/html; charset=GBK" %> 


<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page"/>
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page"/>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init.jsp" %>
<HTML>
<HEAD>

    <link href="/css/Weaver.css" rel="stylesheet" type="text/css" >
    <script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery-1.4.4.min.js"></script>
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core.min.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.excheck.min.js"></script>
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
for(int i=0;i<cks.length;i++){
	//System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
if(cks[i].getName().equals("doclistmulti"+uid)){
  rem=cks[i].getValue();
  break;
}
}if(rem!=null&&rem.length()>1)
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
%>


<BODY>
    <DIV align=right>
    <%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
    <%
        RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSave(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;

        RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
        
    %>	
    <%@ include file="/systeminfo/RightClickMenu.jsp" %>
    <script>
     rightMenu.style.visibility='hidden'
    </script>
    
    </DIV>

    <table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
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
                <TABLE class=Shadow>
                    <tr>
                        <td  valign="top">
                            <FORM NAME=select STYLE="margin-bottom:0" action="CategoryBrowser.jsp" method=post>
							<input class=inputstyle type=hidden name=id value="<%=id%>">
							<input class=inputstyle type=hidden name=type value="<%=type%>">
      
                                <TABLE  ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">     
                                     <TR class=Line1><TH colspan="4" ></TH></TR>
                                      <TR  >
                                          <TD height=400 colspan="4" width="100%">                                            
                                                <!-- <div id="deeptree" class="deeptree" CfgXMLSrc="/css/TreeConfig.xml" />
                                                -->
                                                <div id="deeptree" style="height:100%;width:100%;overflow:scroll;">
	                                            	<ul id="ztreedeep" class="ztree"></ul>
	                                            </div>                                             
                                          </TD>
                                      </TR>                                    
                                </TABLE>
                            </FORM>
                         </td>
                    </tr>
                </TABLE>
            </td>
            <td></td>
        </tr>
        <tr> <td height="10" colspan="3"></td></tr>
        <tr>
        <td align="center" valign="bottom" colspan=3>  
	<BUTTON type="button" class=btn accessKey=O  id=btnok onclick="onSave()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
	<BUTTON type="button" class=btn accessKey=2  id=btnclear onclick="onClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
        <BUTTON type="button" class=btnReset accessKey=T  id=btncancel onclick="onClose()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
        </td>
        </tr>
    </table>
</BODY>
</HTML>

<script type="text/javascript">

	//<!--
	var selectallflag=true;
	var isremember = "<%=isRemember%>";
	var selectedids = "<%=para%>";
	var cxtree_id = "<%=para%>";
	var cxtree_ids;
	if(selectedids!="0"&&selectedids!=""){
		cxtree_id = "<%=para%>";
		cxtree_ids = cxtree_id.split(',');
		cxtree_id = cxtree_ids[0];
	} 
	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		//获取子节点时
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "/docs/category/MutilCategoryBrowserXML.jsp?" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "/docs/category/MutilCategoryBrowserXML.jsp?needPeop=<%=needPeop%>&mainCateIds=<%=mainCateStr%>&subCateIds=<%=subCateStr%>" + "&" + new Date().getTime() + "=" + new Date().getTime();
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
			chkboxType: { "Y":"", "N": ""} 
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
				node = treeObj.getNodeByParam("id", "secField_" + cxtree_ids[z], null);
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
			if (nodes[i].id.indexOf("secField_") != -1) {
				nameStr += "," + nodes[i].value;
				idStr += "," + nodes[i].name;
			}
		}
		
		resultStr = nameStr + "$" + idStr;
	    return resultStr;
	}
	
	function onSave() {
    	var  trunStr = "", returnVBArray = null;
	    trunStr =  onSaveJavaScript();
	    var returnjson;
	    if(trunStr != "") {
			returnVBArray = trunStr.split("$");
		 	returnjson = {id:returnVBArray[0], name:returnVBArray[1]};
	    } else {
			returnjson = {id:"", name:""};
		}
	    setValue(returnjson);
    }
    
    function onClear() {
    	var returnjson = {id:"", name:""};
    	setValue(returnjson)
	}
    
    function onClose(){
    	/* var dialogflag = (typeof(systemshowModalDialog) == 'undefined' && !!!window.showModalDialog);
    	dialogflag = (dialogflag || systemshowModalDialog);
    	if (dialogflag) {
    	    try  {
    	        window.parent.opener.closeHandle();
    	    } catch (_96e)  {
    	    }
    	} */
    	try  {
	        window.parent.opener.closeHandle();
	    } catch (_96e)  {
	    }
    	window.parent.close();
    }
    
    function setValue(returnjson){
    	/* var dialogflag = (typeof(systemshowModalDialog) == 'undefined' && !!!window.showModalDialog);
    	dialogflag = (dialogflag || systemshowModalDialog);
    	if (dialogflag) {
    	    try  {
    	        window.parent.opener.dialogReturnValue=returnjson;
    	        window.parent.opener.closeHandle();
    	    } catch (_96e)  {
    	    }
    	} */
    	try  {
 	        window.parent.opener.dialogReturnValue=returnjson;
 	        window.parent.opener.closeHandle();
 	    } catch (_96e)  {
 	    }
    	window.parent.returnValue  = returnjson;
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
	//-->
</SCRIPT>



