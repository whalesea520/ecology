<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.company.SubCompanyComInfo"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML>
<HEAD>
  <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.excheck-3.0_wev8.js"></script>
	<LINK href="/js/ecology8/customSelect/customSelect_wev8.css" type=text/css rel=STYLESHEET></LINK>
	<script src="/js/ecology8/customSelect/customSelect_wev8.js" type="text/javascript"></script>
	<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("124",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e+"-->MutiDepartmentBrowser.jsp");
	}
	var dialog = null;
	try{
		dialog = parent.parent.getDialog(parent);
	}
	catch(e){}
	
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
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(124,user.getLanguage());
String needfav ="1";
String needhelp ="";
int uid=user.getUID();

String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodename=Util.null2String(request.getParameter("nodename"));
String level=Util.null2String(request.getParameter("level"));
String subid=Util.null2String(request.getParameter("subid"));
String selectedDepartmentIds = Util.null2String(request.getParameter("selectedDepartmentIds"));
String passedDepartmentIds = Util.null2String(request.getParameter("passedDepartmentIds"));
String resourceids=Util.null2String(request.getParameter("resourceids"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String selectedids = Util.null2String(request.getParameter("selectedids"));
String[] selecteds = selectedids.split("[,]");
int deptlevel = 0;
int maxnum=0;
if(!"".equals(selectedids)&&!"0".equals(selectedids)){
	for(int i=0;i<selecteds.length;i++){
		if(!"".equals(selecteds[i])&&!"0".equals(selecteds[i])){
			maxnum = DepartmentComInfo.getLevelByDepId(selecteds[i]);
			if(deptlevel<maxnum){
				deptlevel = maxnum;
			}
		}
	}
}
String selectnode = "";
String supcompanyid = "";
if(!"".equals(selectedids)&&!"0".equals(selectedids)){
	for(int i=0;i<selecteds.length;i++){
		if(!"".equals(selecteds[i])&&!"0".equals(selecteds[i])){
			supcompanyid = DepartmentComInfo.getSubcompanyid1(selecteds[i]);
			selectnode = ",dept_"+supcompanyid+"_"+selecteds[i]+selectnode;
		}
	}
}
if(selectnode.startsWith(",")){
	selectnode = selectnode.substring(1);
}
String nodeid=null;
String nodeids=null;
Cookie[] cks= request.getCookies();
String rem="";        
for(int i=0;i<cks.length;i++){
//System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
if(cks[i].getName().equals("departmentmulti"+uid)){
  rem=cks[i].getValue();
  break;
}
}
if(resourceids.equals("")) resourceids=selectedDepartmentIds;
ArrayList selectids=Util.TokenizerString(resourceids,",");
for(int i=0;i<selectids.size();i++){
    String tempdeptid=(String)selectids.get(i);
    String tempsubcomid=DepartmentComInfo.getSubcompanyid1(tempdeptid);
    tempdeptid="|dept_"+tempsubcomid+"_"+tempdeptid;
    if((rem+"|").indexOf(tempdeptid+"|")==-1)   rem+=tempdeptid;
}
if(rem!=null&&rem.length()>1)
nodeids=rem.substring(1);
if(nodeids!=null){
 if(nodeids.indexOf("|")>-1)
  nodeid=nodeids.substring(nodeids.lastIndexOf("|")+1);
 else
  nodeid=nodeids;
}
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

String[] ids=Util.TokenizerString2(nodeids,"|");
CompanyVirtualComInfo.setTofirstRow();
CompanyVirtualComInfo.next();
String dfvirtualtype = CompanyVirtualComInfo.getCompanyid();
String dfvirtualtypename = CompanyVirtualComInfo.getVirtualType();
%>


<BODY>
<div class="zDialog_div_content">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
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
    System.out.println("userightmenu_self == 1>"+(userightmenu_self == 1));
    if(userightmenu_self == 1){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSave(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
       
        RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
        
    }
    RCMenu += "{"+SystemEnv.getHtmlLabelName(19323,user.getLanguage())+",javascript:needSelectAll(!parent.selectallflag,this),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    %>	
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if(userightmenu_self == 1){%>
    <script>
     rightMenu.style.visibility='hidden'
    </script>
<%}%>
    </DIV>

<FORM NAME=select STYLE="margin-bottom:0" action="MutiDepartmentBrowser.jsp" method=post>
   <input class=inputstyle type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere)%>">
   <input class=inputstyle type=hidden name=type value="<%=type%>">
   <input class=inputstyle type=hidden name=id value="<%=id%>">
   <input class=inputstyle type=hidden name=level value="<%=level%>">
   <input class=inputstyle type=hidden name=subid value="<%=subid%>">
   <input class=inputstyle type=hidden name=nodename value="<%=nodename%>">
   <textarea style="display:none" name=passedDepartmentIds ><%=passedDepartmentIds%></textarea>
   <textarea style="display:none" name=selectedDepartmentIds ><%=selectedDepartmentIds%></textarea>
	 <input class=inputstyle type=hidden name=canceledDepartmentIds value="">
	 <input class=inputstyle type=hidden id=virtualtype name=virtualtype value="<%=dfvirtualtype %>">
		<table cellspacing="0" cellpadding="0" style="width:100%;">
			<tr>
				<td class="leftTypeSearch">
					<div class="topMenuTitle" style="border-bottom:none;height: 30px">
						<span class="leftType" style="width: 564px">
							<span><img id="currentImg" src="/images/ecology8/doc/org_wev8.png" width="16"/></span>
							<span>
								<div  id="e8typeDiv" style="width:auto;height:auto;position:relative;line-height: 0px">
									<span id="optionSpan" style="width: 515px;line-height: 30px" onclick="showE8TypeOption();" ><%=dfvirtualtypename%></span>
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
    <TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
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
	<%	if(CompanyVirtualComInfo.getCompanyNum()>0){ %>
	<ul id="e8TypeOption" class="e8TypeOption">
	<%
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
  <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
					<input type="button" class=zd_btn_submit accessKey=O  id=btnok onclick="onSave()" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>">
					<input type="button" class=zd_btn_submit accessKey=2  id=btnclear onclick="onClear()" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>">
        	<input type="button" class=zd_btn_submit accessKey=T  id=btncancel onclick="btncancel_onclick();" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>">
			</wea:item>
		</wea:group>
	</wea:layout>
		<script type="text/javascript">
		jQuery(document).ready(function(){
			//resizeDialog(document);
		});
	</script>
	</div>
</BODY>
<script type="text/javascript">

	
	//<!--
	var selectallflag=false;
	var appendimg = 'subCopany_Colse';
	var appendname = 'selObj';
	var allselect = "all";
	var typename = "checkbox";
	var selectreview = "openall";
	var selectedids = "<%=selectedids%>";
	var cxtree_id = "";
	var cxtree_ids;
	if(selectedids!="0"&&selectedids!=""){
		cxtree_id = "<%=selectnode%>";
		cxtree_ids = cxtree_id.split(',');
		cxtree_id = cxtree_ids[0];
	} 
	
	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		//获取子节点时
		var virtualtype = jQuery("#virtualtype").val();
		if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
    	return "/hrm/companyvirtual/DepartmentMultiXML.jsp?virtualtype="+virtualtype+"&" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
    } else {
    	//初始化时
    	return "/hrm/companyvirtual/DepartmentMultiXML.jsp?deptlevel=<%=deptlevel%>&virtualtype="+virtualtype+"<%if(nodeids!=null){%>&nodeids=<%=nodeids%><%}%>" + "&" + new Date().getTime() + "=" + new Date().getTime();
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

	window.E8EXCEPTHEIGHT = 30;
	$(document).ready(function(){
		//初始化zTree
		var obj =$.fn.zTree.init($("#ztreedeep"), setting, zNodes);
	});
	
	function initTree(){
		jQuery("#tddeeptree").empty().html("<div id='deeptree' style='height:100%;width:100%;overflow:hidden;'><ul id='ztreedeep' class='ztree'></ul></div>");
		var obj =$.fn.zTree.init($("#ztreedeep"), setting, zNodes);
	}
	
	/**
	 * 点击树节点时触发
	 */
	function zTreeOnClick(event, treeId, treeNode) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
	};

	/**
	 * ajax成功后触发
	 */
	function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
		var treeObj = $.fn.zTree.getZTreeObj(treeId);
		if (!selectallflag) {
			var rootnodes = treeObj.getNodesByParamFuzzy("icon", "global", null);
			var homenodes = treeObj.getNodesByParamFuzzy("icon", "Home", null);
			var nodes = treeObj.getNodesByParamFuzzy("icon", appendimg, null);
			setIsExistsCheckbox(treeObj, rootnodes, true);
			setIsExistsCheckbox(treeObj, homenodes, true);
			setIsExistsCheckbox(treeObj, nodes, false);
		} else {
			if (treeNode != undefined && treeNode != null) {
			    if (treeNode.checked) {
				    var childrenNodes = treeNode.childs;
			    	for (var i=0; i<childrenNodes.length; i++) {
			    		childrenNodes[i].isInitAttr = false;
						treeObj.updateNode(childrenNodes[i]);
			    		treeObj.checkNode(childrenNodes[i], true, true);
					}
			    }
		    }
		}

		var node = null;
		if (cxtree_ids != undefined && cxtree_ids != null) {
		    for (var z=0; z<cxtree_ids.length; z++) {
				node = treeObj.getNodeByParam("id", cxtree_ids[z], null);
			    if (node != undefined && node != null ) {
			    	treeObj.selectNode(node);
			    	treeObj.checkNode(node, true, false);
			    }
		    }
		}
		//默认展开第一级
		try{
			var root = jQuery("button.root_close");
			root.click();
		}catch(e){}
	}


	/**
	 * checkbox选中时触发
	 */
	function zTreeOnCheck(event, treeId, treeNode) {
		var treeObj = $.fn.zTree.getZTreeObj(treeId);
		/*
		var colorstr = "";
		if (treeNode.checked) {
			colorstr = "red";
		}
		treeObj.setting.view.fontCss = {};
		treeObj.setting.view.fontCss["color"] = colorstr;
		treeObj.updateNode(treeNode);
		*/
		if (treeNode.isInitAttr == false) {
			return;
		}
		
		var nodes = treeNode.childs;
		if (nodes == null || nodes == undefined) {
			treeObj.reAsyncChildNodes(treeNode, "refresh");
		}
	}
	
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

	/**
	 * 开启关闭全选
	 */
	function needSelectAll(flag, obj){
		selectallflag = flag;
	   	var treeObj = $.fn.zTree.getZTreeObj("ztreedeep");
	   	var type = { "Y":"", "N": ""};
	   	if(selectallflag){
	   		type = { "Y":"s", "N": "s"};
	   	}
	   	treeObj.setting.check.chkboxType = type;

	   	if (!selectallflag) {
			var rootnodes = treeObj.getNodesByParamFuzzy("icon", "global", null);
			var homenodes = treeObj.getNodesByParamFuzzy("icon", "Home", null);
			var nodes = treeObj.getNodesByParamFuzzy("icon", appendimg, null);
			setIsExistsCheckbox(treeObj, rootnodes, true);
			setIsExistsCheckbox(treeObj, homenodes, true);
			setIsExistsCheckbox(treeObj, nodes, false);
		} else {
			var nodes = treeObj.getNodesByParamFuzzy("icon", "images", null);
			setIsExistsCheckbox(treeObj, nodes, false);
		}

	   	var i = $(obj).html().indexOf('>');
	   	if(selectallflag){
	        a = $(obj).html().substring(0,i+1)+' <%=SystemEnv.getHtmlLabelName(19324,user.getLanguage())%>';
	    } else{
	    	a = $(obj).html().substring(0,i+1)+' <%=SystemEnv.getHtmlLabelName(19323,user.getLanguage())%>';
	    }
		$(obj).html(a);
	}
	
	function onSaveJavaScript(){
		var treeObj = $.fn.zTree.getZTreeObj("ztreedeep");
		
	    var idstr = "";
	    var namestr = "";
	    
		var nodes = treeObj.getCheckedNodes(true);
		
		if (nodes == undefined || nodes == "" || nodes.length < 1) {
			return "";
		}
		
		var agceVal = ""; 
		var nuloadnode = "";
		for (var i=0; i<nodes.length; i++) {
			//开启全选 && 是一个父元素 && 被选中
			if (selectallflag && nodes[i].isParent && nodes[i].checked) {
				//子节点
				var childNodes = nodes[i].childs;
				//子节点为空，说明子节点还未ajax加载
				if (childNodes == undefined) {
					if (nodes[i].icon.indexOf(appendimg) != -1) {
						 //agceVal += ajaxGetChildEleValue(nodes[i].value, "dep");
						 if(nuloadnode!="")nuloadnode+=",";
						 nuloadnode+="dep_"+nodes[i].value;
					} else {
						 //agceVal += ajaxGetChildEleValue(nodes[i].value, "com");
						 if(nuloadnode!="")nuloadnode+=",";
						 nuloadnode+="com_"+nodes[i].value;
					}
				}
			}
			
			if (nodes[i].icon.indexOf(appendimg) != -1) {			
				if(idstr!="")idstr += ",";
				idstr += nodes[i].value;
				if(namestr!="")namestr += ",";
				namestr +=  nodes[i].name.replace(",","，");
			}	
		}
		
		$.ajax({
			type : "post",
			url : "MutiDepartmentAjax.jsp",
			data:{
				cmd:"getnuloadnode",
				nuloadnode:nuloadnode
			},
			async : true,
			success : function(data){
				agceVal = $.trim(data);
				var agceValArray = agceVal.split(",");
				var agceArray = null;
				var agceId = "";
				var agceName = "";
				for (var i=0; i<agceValArray.length; i++) {
					agceArray = agceValArray[i].split("_");
					
					if (agceArray != null && agceArray != undefined && agceArray.length > 2) {
						if(agceId!="")agceId += ",";
						agceId += agceArray[agceArray.length - 2];
						if(agceName!="")agceName += ",";
						agceName += agceArray[agceArray.length - 1].replace(",","，");;
					}
				}
				idstr += agceId;
				namestr += agceName;
				resultStr = idstr + "$" + namestr;
	    	var trunStr = "", returnVBArray = null;
	    	trunStr = resultStr;
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
						window.parent.parent.returnValue = returnjson;
					  window.parent.parent.close();
					}
			  } else {
			  	if(dialog){
						dialog.close();
					}else{
				  	window.parent.parent.close();
					}   
				}
			}
		});
	}
	
	function onSave() {
  	trunStr =  onSaveJavaScript();
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
				window.parent.parent.returnValue = returnjson;
		  	window.parent.parent.close();
			}
	}

    
    function ajaxGetChildEleValue(subId, suptype){
    	var ajaxvalue = "";
		$.ajax({
			type : "get",
			url : "MutiDepartmentAjax.jsp?subId=" + subId + "&suptype=" + suptype,
			async : false,
			success : function(data){
				ajaxvalue = $.trim(data);
			}
		});
		
		if (ajaxvalue == undefined && ajaxvalue == null ) {
			ajaxvalue = "";
		}
		return ajaxvalue;
    }
    
    
   function btncancel_onclick(){
		if(dialog){
			dialog.close();
		}else{
	  	window.parent.parent.close();
		}
	}
	
	jQuery(document).ready(function(){
		jQuery(".leftTypeSearch").show();
		jQuery(".leftTypeSearch").height(30);
		jQuery(".leftTypeSearch").height(30);
	})
	//-->
</SCRIPT>
</HTML>