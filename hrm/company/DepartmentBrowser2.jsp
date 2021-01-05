
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.company.SubCompanyComInfo"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
  <link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.excheck.min_wev8.js"></script>
	<LINK href="/js/ecology8/customSelect/customSelect_wev8.css" type=text/css rel=STYLESHEET></LINK>
	<script src="/js/ecology8/customSelect/customSelect_wev8.js" type="text/javascript"></script>
	<script type="text/javascript">
		try{
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("124",user.getLanguage())%>");
		}catch(e){
			if(window.console)console.log(e+"-->DepartmentBrowser2.jsp");
		}
	var dialog = null;
	try{
		dialog = parent.parent.getDialog(parent);
	}
	catch(e){}
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(124,user.getLanguage());
String needfav ="1";
String needhelp ="";
int uid=user.getUID();
String excludeid=Util.null2String(request.getParameter("excludeid"));
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodename=Util.null2String(request.getParameter("nodename"));
String level=Util.null2String(request.getParameter("level"));
String subid=Util.null2String(request.getParameter("subid"));
String selectedDepartmentIds = Util.null2String(request.getParameter("selectedDepartmentIds"));
String passedDepartmentIds = Util.null2String(request.getParameter("passedDepartmentIds"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String notCompany = Util.null2String(request.getParameter("notCompany"));
String allselect = Util.null2String(request.getParameter("allselect"));
String rightStr=Util.null2String(request.getParameter("rightStr"));
String selectedids = Util.null2String(request.getParameter("selectedids"));
int deptlevel = Util.getIntValue(request.getParameter("deptlevel"),0);
if(!"".equals(selectedids)&&!"0".equals(selectedids)&&deptlevel==0){
	deptlevel = DepartmentComInfo.getLevelByDepId(selectedids);
}
String selectnode = selectedids;
String supcompanyid = "";
if(!"".equals(selectedids)){
supcompanyid = DepartmentComInfo.getSubcompanyid1(selectedids);
selectnode = supcompanyid+"_"+selectnode;
}
//isedit如果为1则显示具有编辑权限以上的分部
int isedit=Util.getIntValue(request.getParameter("isedit"));
String nodeid=null;
Cookie[] cks= request.getCookies();
String rem=null;
for(int i=0;i<cks.length;i++){
//System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
if(cks[i].getName().equals("departmentsingle"+uid)){
  rem=cks[i].getValue();
  break;
}
}
if(rem!=null&&rem.length()>0)
nodeid=rem;

boolean exist=false;
if(nodeid!=null&&nodeid.indexOf("dept")>-1){
    String deptname=DepartmentComInfo.getDepartmentname(nodeid.substring(nodeid.lastIndexOf("_")+1));
    String subcom=DepartmentComInfo.getSubcompanyid1(nodeid.substring(nodeid.lastIndexOf("_")+1));
    if(!deptname.equals("")&&subcom.equals(nodeid.substring(nodeid.indexOf("_")+1,nodeid.lastIndexOf("_"))))
       exist=true;
    else
      exist=false;
}
if(!exist)
nodeid=null;

%>


<BODY onload="initTree()">
<div class="zDialog_div_content">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
    <DIV align=right>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
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
        RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_self} " ;
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
		<FORM NAME=select STYLE="margin-bottom:0" action="DepartmentBrowser.jsp" method=post>
		    <input class=inputstyle type=hidden name=type value="<%=type%>">
		    <input class=inputstyle type=hidden name=id value="<%=id%>">
		    <input class=inputstyle type=hidden name=level value="<%=level%>">
		    <input class=inputstyle type=hidden name=subid value="<%=subid%>">
		    <input class=inputstyle type=hidden name=nodename value="<%=nodename%>">
		    <textarea style="display:none" name=passedDepartmentIds ><%=passedDepartmentIds%></textarea>
		    <textarea style="display:none" name=selectedDepartmentIds ><%=selectedDepartmentIds%></textarea>
		    <TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0;" width="100%">
         	<TR class=Line1><TH colspan="4" ></TH></TR>
          <TR>
                <TD id="tddeeptree" colspan="4" WIDTH="100%">
                   <div id="deeptree" style="height:100%;width:100%;overflow:scroll;">
                   	<ul id="ztreedeep" class="ztree"></ul>
                   </div>
                 
                </TD>
          </TR>
		    </TABLE>
		</FORM>
		</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col" needImportDefaultJsAndCss="false">
		<wea:group context="">
			<wea:item type="toolbar">
				<input class=zd_btn_submit type="button" accessKey=O  id=btnok onclick="onSave()" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>">
				<input class=zd_btn_submit type="button" accessKey=2  id=btnclear onclick="onClear()" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>">
		    <input class=zd_btn_cancle type="button" accessKey=T  id=btncancel onclick="btncancel_onclick()" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>">
		</wea:item>
		</wea:group>
		</wea:layout>           
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
	</div>
</BODY>
</HTML>

<script language="javaScript">

var appendimg = 'subCopany_Colse';
	var appendname = 'selObj';
	var allselect = 'all';
	var selectedids = "<%=selectedids%>";
	var cxtree_id = "";
	if(selectedids!="0" && selectedids!=""){
		cxtree_id = "dept_<%=selectnode%>";
	}
	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		//获取子节点时
		var virtualtype = jQuery("#virtualtype").val();
		if(virtualtype<0){
			if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "/hrm/companyvirtual/DepartmentSingleXML.jsp?deptlevel=<%=deptlevel%>&virtualtype="+virtualtype+"&subcompanyid=<%=subcompanyid%>&" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "/hrm/companyvirtual/DepartmentSingleXML.jsp?deptlevel=<%=deptlevel%>&virtualtype="+virtualtype+"&subcompanyid=<%=subcompanyid%>&excludeid=<%=excludeid%><%if(nodeid!=null){%>&init=true&nodeid=<%=nodeid%><%}%>" + "&" + new Date().getTime() + "=" + new Date().getTime();
	    }
		}else{
			if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "/hrm/tree/DepartmentSingleXML.jsp?"+ treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "/hrm/tree/DepartmentSingleXML.jsp?deptlevel=<%=deptlevel%>&excludeid=<%=excludeid%><%if(nodeid!=null){%>&init=true&nodeid=<%=nodeid%><%}%>" + "&" + new Date().getTime() + "=" + new Date().getTime();
	    }
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
		var obj =$.fn.zTree.init($("#ztreedeep"), setting, zNodes);
	});
	
	function initTree(){
		jQuery("#tddeeptree").empty().html("<div id='deeptree' style='height:100%;width:100%;overflow:hidden;'><ul id='ztreedeep' class='ztree'></ul></div>");
		var obj =$.fn.zTree.init($("#ztreedeep"), setting, zNodes);
	}
	
	function zTreeOnClick(event, treeId, treeNode) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
		treeObj.checkNode(treeNode, true, false);
	};


	var isInit = true;
	function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    var node = treeObj.getNodeByParam("id", cxtree_id, null);
	    if (node != undefined && node != null && isInit) {
	    	treeObj.selectNode(node);
	    	treeObj.checkNode(node, true, true);
	    	isInit = false;
	    }
	    
	    //默认展开第一级
			try{
				var root = jQuery("button.root_close");
				root.click();
			}catch(e){}
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
	    if(arraytemp.length > 2) {
	    	resultStr = arraytemp[2];;
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
			returnVBArray[0] = (returnVBArray[0] == '0') ? '' : returnVBArray[0] ;
			var returnjson = {id:returnVBArray[0], name:returnVBArray[1]};
         	if(dialog){
				try{
              		 dialog.callback(returnjson);
     			}catch(e){}
				try{
				     dialog.close(returnjson);
				 }catch(e){}
			}else{
				//window.parent.returnValue = returnjson;
		  	    //window.parent.close();
		  	    returnValue(dialog,window.parent,returnVBArray[0],returnVBArray[1],1);
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
      var returnjson = {id:"",name:""};
			if(dialog){
				try{
         			 dialog.callback(returnjson);
			     }catch(e){}
			
				try{
			     dialog.close(returnjson);
			 	}catch(e){}
			}else{
				//window.parent.returnValue = returnjson;
		  		//window.parent.close();
		  		returnValue(dialog,window.parent,"","",1);
			}
	}
	
	function btncancel_onclick(){
    		if(dialog){
				dialog.close();
			}else{
	  			window.parent.close();
			}
	}

	//设置浏览按钮返回值 兼容老式的弹出窗口及chrome37+
	function returnValue(dialog,opWin,ids,names,type){
		try {
			if (dialog) {
				//E8弹出窗口模式
				
				if(type==1){
					//设置值
					try {
						dialog.callback({
							id : ids,
							name : names
						});
					} catch (e) {
					}
					//关闭
					try {
						dialog.close({
							id : ids,
							name : names
						});
					} catch (e) {
					}
				}else{
					//关闭
					try {
						dialog.close();
					} catch (e) {
					}
				}
				
			} else {
				//老式弹出窗口操作
				doSetValue(opWin,ids,names,type);
			}
		} catch (e) {
			//老式弹出窗口操作
			doSetValue(opWin,ids,names,type);
		}
	}
	function doSetValue(opWin,ids,names,type){
		/**
		var opWin = window.parent;
		if (config.parentWin)
			opWin = config.parentWin;
		*/
		try {
			//chrome37+ 处理
			var dialogflag = (typeof (systemshowModalDialog) == 'undefined' && !!!window.showModalDialog);
			dialogflag = (dialogflag || systemshowModalDialog);
			
			//设置值
			if(type==1){
				if (dialogflag) {
					try {
						opWin.opener.dialogReturnValue = {
							id : ids,
							name : names
						};
					} catch (_96e) {
					}
				}
				opWin.returnValue = {
					id : ids,
					name : names
				};
			}
			//关闭
			if (dialogflag) {
				try {
					opWin.opener.closeHandle();
				} catch (_96e) {
				}
			}
			opWin.close();
		} catch (e) {
			//设置值
			if (type == 1) {
				opWin.returnValue = {
					id : ids,
					name : names
				};
			}
			//关闭
			opWin.close();
		}
	}
	
	jQuery(document).ready(function(){
		jQuery(".leftTypeSearch").show();
		jQuery(".leftTypeSearch").height(30);
		jQuery(".leftTypeSearch").height(30);
	})
	//-->
	</SCRIPT>
