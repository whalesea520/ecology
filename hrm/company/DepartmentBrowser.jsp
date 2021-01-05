<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@ page import="weaver.hrm.company.CompanyTreeNode"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyVirtualComInfo" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="DepartmentVirtualComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page" />
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
			if(window.console)console.log(e+"-->DepartmentBrowser.jsp");
		}
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
	
	function changeShowType(obj,showtype){
		var title = jQuery(obj).find(".e8text").html();
		var title1 = jQuery(obj).find(".e8text").attr("title");
		jQuery("#optionSpan").html(title);
		jQuery("#virtualtype").val(showtype);
		jQuery("#leftTree").css("background-color",jQuery(".leftTypeSearch").css("background-color"));
		jQuery("span[id^='showspan']").each(function(){
			jQuery(this).addClass("e8imgSel");
		});
		jQuery("#showspan"+showtype).removeClass("e8imgSel");
		showE8TypeOption();
		initTree();
	}

	function showE8TypeOption(closed){
		if(closed){
			jQuery("#e8TypeOption").hide();
		}else{
			jQuery("#e8TypeOption").toggle();
		}
		if(jQuery("#e8TypeOption").css("display")=="none"){
			jQuery("span.leftType").removeClass("leftTypeSel");
			var src = jQuery("#currentImg").attr("src");
			if(src){
				jQuery("#currentImg").attr("src",src);
			}
			jQuery("#e8typeImg").attr("src","/images/ecology8/doc/down_wev8.png");
		}else{
			jQuery("span.leftType").addClass("leftTypeSel");
			jQuery("#e8TypeOption").width(jQuery("span.leftType").width()+10);
			var src = jQuery("#currentImg").attr("src");
			if(src){
				jQuery("#currentImg").attr("src",src);
			}
			jQuery("#e8typeImg").attr("src","/images/ecology8/doc/down_sel_wev8.png");
		}
		return;
	}
</script>
</HEAD>
<%
String f_weaver_belongto_userid=Util.fromScreen(request.getParameter("f_weaver_belongto_userid"),user.getLanguage());
String f_weaver_belongto_usertype=Util.fromScreen(request.getParameter("f_weaver_belongto_usertype"),user.getLanguage());
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
String show_virtual_org = Util.null2String(request.getParameter("show_virtual_org"));
boolean showvirtual = false;
CompanyVirtualComInfo.setUser(user);
if(!show_virtual_org.equals("-1")&&CompanyVirtualComInfo.getCompanyNum()>0){
	showvirtual = true;
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(124,user.getLanguage());
String needfav ="1";
String needhelp ="";
int uid=user.getUID();
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String excludeid=Util.null2String(request.getParameter("excludeid"));
String nodename=Util.null2String(request.getParameter("nodename"));
String level=Util.null2String(request.getParameter("level"));
String subid=Util.null2String(request.getParameter("subid"));
String selectedDepartmentIds = Util.null2String(request.getParameter("selectedDepartmentIds"));
String passedDepartmentIds = Util.null2String(request.getParameter("passedDepartmentIds"));
String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String selectedids = Util.null2String(request.getParameter("selectedids"));
boolean isVirual = false;
if(Util.getIntValue(selectedids)<-1) isVirual = true;

int deptlevel = 0;
if(!"".equals(selectedids)&&!"0".equals(selectedids)){
	if(isVirual){
		deptlevel = DepartmentVirtualComInfo.getLevelByDepId(selectedids);
	}else{
		deptlevel = DepartmentComInfo.getLevelByDepId(selectedids);
	}
}
String selectnode = selectedids;
String supcompanyid = "";
if(!"".equals(selectedids)&&!"0".equals(selectedids)){
	if(isVirual){
		supcompanyid = DepartmentVirtualComInfo.getSubcompanyid1(selectedids);
	}else{
		supcompanyid = DepartmentComInfo.getSubcompanyid1(selectedids);
	}
	selectnode = supcompanyid+"_"+selectnode;
}
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
    if(!deptname.equals("")&&subcom.equals(nodeid.substring(nodeid.indexOf("_")+1,nodeid.lastIndexOf("_")))&&!nodeid.substring(nodeid.lastIndexOf("_")+1).equals(excludeid))
        exist=true;
        if(!excludeid.equals("")){

            String idInCookie=nodeid.substring(nodeid.lastIndexOf("_")+1);
            //System.out.println("excludeid="+excludeid);
            List l=new ArrayList();
            SubCompanyComInfo.getDepartTreeList(l,subcom,excludeid,0,999,"",null,null);
            //System.out.println(l.size());
            for(Iterator iter=l.iterator();iter.hasNext();){
                   CompanyTreeNode node=(CompanyTreeNode)iter.next() ;
                //System.out.println("nodeid="+node.getId());
                   if(node.getType().equals("dept")&&node.getId().equals(idInCookie)){
                       exist=false;
                       break;
                   }
            }

        }

}
if(!exist)
nodeid=null;
%>

<!-- onload="initTree()" --> 
<BODY scroll="no">
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
<%} %>
    </DIV>

  <FORM NAME=select STYLE="margin-bottom:0" action="DepartmentBrowser.jsp" method=post>
      <input class=inputstyle type=hidden name=type value="<%=type%>">
      <input class=inputstyle type=hidden name=id value="<%=id%>">
      <input class=inputstyle type=hidden name=level value="<%=level%>">
      <input class=inputstyle type=hidden name=subid value="<%=subid%>">
      <input class=inputstyle type=hidden name=nodename value="<%=nodename%>">
      <textarea style="display:none" name=passedDepartmentIds ><%=passedDepartmentIds%></textarea>
      <textarea style="display:none" name=selectedDepartmentIds ><%=selectedDepartmentIds%></textarea>
      <input class=inputstyle type=hidden id=virtualtype name=virtualtype value="">
<%if(showvirtual){ %>
<table cellspacing="0" cellpadding="0" style="width:100%;">
	<tr>
		<td class="leftTypeSearch">
			<div class="topMenuTitle" style="border-bottom:none;height: 30px">
				<span class="leftType" style="width: 564px;height: 0px">
					<span><img id="currentImg" src="/images/ecology8/doc/org_wev8.png" width="16"/></span>
					<span>
						<div  id="e8typeDiv" style="width:auto;height:auto;position:relative;line-height: 0px">
							<span id="optionSpan" style="width: 515px;line-height: 30px" onclick="showE8TypeOption();" ><%=CompanyComInfo.getCompanyname("1")%></span>
							<%if(CompanyVirtualComInfo.getCompanyNum()>0){ %>
							<span style="width:16px;height:16px;cursor:pointer;" onclick="showE8TypeOption();">
								<img id="e8typeImg" src="/images/ecology8/doc/down_wev8.png"/>
							</span>
							<%} %>
						</div>
					</span>
			</div>
		</td>
	</tr>
</table>
<%} %>
      <TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
           <TR class=Line1><TH colspan="4" ></TH></TR>
            <TR>
                <TD id="tddeeptree" colspan="4" WIDTH="100%">
                  <!-- <div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" />
                  -->
                 
                   <div id="deeptree" style="height:100%;width:100%;overflow:scroll;">
                   	<ul id="ztreedeep" class="ztree"></ul>
                   </div>
                 
                </TD>
            </TR>
		    </TABLE>
		</FORM>
		</div>
	<%	if(CompanyVirtualComInfo.getCompanyNum()>0){ %>
	<ul id="e8TypeOption" class="e8TypeOption">
	<%
	if(CompanyComInfo.getCompanyNum()>0){
		CompanyComInfo.setTofirstRow();
		while(CompanyComInfo.next()){
	%>
		<li onclick="changeShowType(this,<%=CompanyComInfo.getCompanyid() %>);">
			<span id="showspan<%=CompanyComInfo.getCompanyid() %>" class="e8img"><img src="/images/ecology8/doc/current_wev8.png"/></span>
			<span class="e8img"><img src="/images/ecology8/doc/org_sel_wev8.png"/></span>
			<span class="e8text"><%=CompanyComInfo.getCompanyname()%></span>
		</li>
	<%}}
	if(CompanyVirtualComInfo.getCompanyNum()>0){
		CompanyVirtualComInfo.setTofirstRow();
		while(CompanyVirtualComInfo.next()){
		%>
		<li onclick="changeShowType(this,<%=CompanyVirtualComInfo.getCompanyid() %>);">
			<span id="showspan<%=CompanyVirtualComInfo.getCompanyid() %>" class="e8img e8imgSel"><img src="/images/ecology8/doc/current_wev8.png"/></span>
			<span class="e8img"><img src="/images/ecology8/doc/org_sel_wev8.png"/></span>
			<span class="e8text" title="<%=CompanyVirtualComInfo.getVirtualType() %>"><%=CompanyVirtualComInfo.getVirtualType().length()>4?CompanyVirtualComInfo.getVirtualType():CompanyVirtualComInfo.getVirtualType()%></span>
		</li>
		<%} %>
	</ul>
<%} %>
<%} %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col" needImportDefaultJsAndCss="false">
		<wea:group context="">
			<wea:item type="toolbar">
		<input type="button" class=zd_btn_submit  id=btnok onclick="onSave();" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>">
		<input type="button" class=zd_btn_submit  id=btnclear onclick="onClear();" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>">
    <input type="button" class=zd_btn_submit  id=btncancel onclick="btncancel_onclick();" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>">
</wea:item>
</wea:group>
</wea:layout>
</div>
</BODY>
</HTML>

<script type="text/javascript">
	//<!--
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
	
	<%if(showvirtual){%>
	window.E8EXCEPTHEIGHT = 30;
	<%}%>
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
