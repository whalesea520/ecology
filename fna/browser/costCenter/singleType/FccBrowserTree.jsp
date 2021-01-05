<!-- 
|last modified by cyril on 2008-07-31
//|改写人力资源树
//|将deepTree改成xtree,取消HTC控件
 -->
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>  
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="appDetachComInfo" class="weaver.hrm.appdetach.AppDetachComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<script type="text/javascript">
FIXTREEHEIGHT=180;
</script>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core.min_wev8.js"></script>
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
<script type="text/javascript">
//FIXTREEHEIGHT=185;
var dialog = null;
try{
	dialog = parent.parent.parent.getDialog(parent.parent);
}catch(ex1){}
 </script>
</HEAD>
<% 
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1867,user.getLanguage());
String needfav ="1";
String needhelp ="";

String needsystem = Util.null2String(request.getParameter("needsystem"));
String seclevelto=Util.fromScreen(request.getParameter("seclevelto"),user.getLanguage());
String from = Util.null2String(request.getParameter("from"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodename=Util.null2String(request.getParameter("nodename"));
String level=Util.null2String(request.getParameter("level"));
String subid=Util.null2String(request.getParameter("subid"));
String virtualtype=Util.null2String(request.getParameter("virtualtype"));
String sqltag=Util.null2String(request.getParameter("sqltag"));
String workflowid = Util.null2String(request.getParameter("workflowid"));
String fieldid = Util.null2String(request.getParameter("fieldid"));
String selectedid = Util.null2String(request.getParameter("selectedid"));
String fcctype = Util.null2String(request.getParameter("fcctype"));

int uid=user.getUID();
int tabid=0;


%>
<BODY style="vertical-align: top;">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td class="rightSearchSpan" style="text-align:right;">
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="Select1.jsp" method=post target="frame2">
	<input class=inputstyle type=hidden name=sqltag value=<%=sqltag%>>
	<input class=inputstyle type=hidden name=from value=<%=from%>>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
BaseBean baseBean_self = new BaseBean();
int userightmenu_self = 1;
try{
	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}
if(userightmenu_self == 1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+", javascript:document.SearchForm.btnclear.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<BUTTON class=btnok accessKey=1 style="display:none" onclick="btncancel_onclick()" id=btnok><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<BUTTON class=btn accessKey=2 style="display:none" id=btnclear onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
	
<script>
rightMenu.style.visibility='hidden'
</script>	

<table width=100% class="ViewForm" valign="top" height="185px" style="vertical-align: top;">
	<TR height="185px">
	<td valign="top">
		<ul id="fnaWfTree" class="ztree"></ul>
	</td>
	</tr>
</table>
  <input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input class=inputstyle type="hidden" name="tabid" >
  <input class=inputstyle type="hidden" name="companyid" >
  <input class=inputstyle type="hidden" name="subcompanyid" >
  <input class=inputstyle type="hidden" name="departmentid" >
  <input class=inputstyle type="hidden" name="nodeid" >
  <input class=inputstyle type=hidden name=seclevelto value="<%=seclevelto%>">
  <input class=inputstyle type=hidden name=needsystem value="<%=needsystem%>">
  <input class=inputstyle type=hidden name=virtualtype value="<%=virtualtype%>">
  <input class=inputstyle type="hidden" name="isNoAccount" id="isNoAccount">
  <input class=inputstyle type="hidden" name="alllevel" id="alllevel" value="1"/>
  <input class=inputstyle type="hidden" name="fccGroupId" id="fccGroupId" value="0"/>
	<!--########//Search Table End########-->
	</FORM>


</BODY>
</HTML>

<!-- 一下js代码是从body体 里面挪出来的 2012-8-06  ypc 修改 start -->
<script language="javascript">

function onClick(id){
    document.SearchForm.fccGroupId.value=id;

	document.SearchForm.action="/fna/browser/costCenter/singleType/FccBrowserList.jsp?workflowid=<%=workflowid%>&fieldid=<%=fieldid%>&selectedid=<%=selectedid %>&fcctype=<%=fcctype %>";
	document.SearchForm.submit();
}

function quickQry(qname){
	//alert("quickQry qname="+qname);
}

var global_clickId = "";
function do_reAsyncChildNodes(_id,_clickId){
	try{
		//alert("do_reAsyncChildNodes _id="+_id+";_clickId="+_clickId);
		var treeObj = jQuery.fn.zTree.getZTreeObj("fnaWfTree");
		if(_id.indexOf("0_") == 0){
			treeObj.reAsyncChildNodes(null, "refresh");
		}else{
			global_clickId = _clickId;
			var nodes = treeObj.getNodesByParam("id", _id, null);
			nodes[0].isParent = true;
			treeObj.reAsyncChildNodes(nodes[0], "refresh");
		}
	}catch(ex){}
}

var setting = {
	async: {
		enable: true,
		url:"/fna/browser/costCenter/FccBrowserMultiTreeAjax.jsp?workflowid=<%=workflowid%>&fieldid=<%=fieldid%>",
		autoParam:["id"],
		otherParam:{"otherParam":"0"},
		dataFilter: filter
	},
	callback: {
		onClick: fnaWfTree_onClick,
		onAsyncSuccess: fnaWfTree_onAsyncSuccess
	}
};

function fnaWfTree_onClick(event, treeId, treeNode, clickFlag) {
	try{
		var idArray = (treeNode.id+"").split("_");
		var idType = idArray[0];
		var id = idArray[1];
	    onClick(id);
	}catch(e){
		alert(e.message);
	}
}

var isFirst = true;
function fnaWfTree_onAsyncSuccess(event, treeId, treeNode, clickFlag) {
	try{
		if(treeNode && treeNode.tId){
		}else{
			var _isFirst = false;
			if(isFirst){
				isFirst = false;
				_isFirst = true;
			}
			
			var _clickId = global_clickId;
			global_clickId = "";
			
			var treeObj = $.fn.zTree.getZTreeObj(treeId);
			var nodes = treeObj.getNodes();
			if(nodes.length==1){
				var _a = treeObj.expandNode(nodes[0], true, false, true);
				treeObj.selectNode(nodes[0]);
				try{
					if(_isFirst){
						var _idArray = (nodes[0].id+"").split("_");
						var _id = _idArray[1];
						onClick(_id);
					}
				}catch(ex1){}
			}
		}
	}catch(e){
		alert(e.message);
	}
}


function filter(treeId, parentNode, childNodes) {
	if (!childNodes) return null;
	for (var i=0, l=childNodes.length; i<l; i++) {
		childNodes[i].name = childNodes[i].name.replace(/\.n/g, '.');
	}
	return childNodes;
}

function onlyFnaWf_onclick(){
	jQuery.fn.zTree.init(jQuery("#fnaWfTree"), setting);
}

jQuery(document).ready(function(){
	onlyFnaWf_onclick();
});

	function btnclear_onclick(){
		if(dialog){
	  	var returnjson = {id:"", name:""};
	   	try{
          dialog.callback(returnjson);
     }catch(e){}

try{
     dialog.close(returnjson);
 }catch(e){}
	  }else{
	    window.parent.parent.returnValue = {id:"", name:""};
	    window.parent.parent.close();
		}
	}
	
	function btncancel_onclick(){
		if(dialog){
	  	dialog.close();
	  }else{
	    window.parent.parent.close();
		}   
	}
</script>