
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@ page import="weaver.hrm.company.CompanyTreeNode"%>
<%@page import="weaver.hrm.User"%>
<%@page import="java.util.Iterator"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%@ include file="MobileInit.jsp"%>
<HTML>
<HEAD>
	<script type="text/javascript" src="/mobile/plugin/browser/js/zTree/js/jquery-1.4.4.min_wev8.js"></script>
	<link rel="stylesheet" href="/mobile/plugin/browser/js/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<script type="text/javascript" src="/mobile/plugin/browser/js/zTree/js/jquery.ztree.core.min_wev8.js"></script>
	<script type="text/javascript" src="/mobile/plugin/browser/js/zTree/js/jquery.ztree.excheck.min_wev8.js"></script>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</HEAD>
<%
String browserType=Util.null2String(request.getParameter("browserType"));   //浏览框类型
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String excludeid=Util.null2String(request.getParameter("excludeid"));
String nodename=Util.null2String(request.getParameter("nodename"));
String level=Util.null2String(request.getParameter("level"));
String subid=Util.null2String(request.getParameter("subid"));
String selectedDepartmentIds = Util.null2String(request.getParameter("selectedDepartmentIds"));
String passedDepartmentIds = Util.null2String(request.getParameter("passedDepartmentIds"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String selectedids = Util.null2String(request.getParameter("selectedids"));  //传递过来的id
//selectedids=",56,54,47";
//selectedids=",27,22";

String selectnode ="";
String supcompanyid = "";

String[] selecteds = selectedids.split("[,]");
int deptlevel = 0;
int maxnum=0;

if(browserType.equals("departmentMulti")){        //选中已经选择的部门
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
	
	if(!"".equals(selectedids)&&!"0".equals(selectedids)){
		for(int i=0;i<selecteds.length;i++){
			if(!"".equals(selecteds[i])&&!"0".equals(selecteds[i])){
				supcompanyid = DepartmentComInfo.getSubcompanyid1(selecteds[i]);
				selectnode = ",dept_"+supcompanyid+"_"+selecteds[i]+selectnode;
			}
		}
	}
}else if(browserType.equals("subcompanyMuti")){  //选中已经选择的分部
	if(!"".equals(selectedids)&&!"0".equals(selectedids)){
	for(int i=0;i<selecteds.length;i++){
		if(!"".equals(selecteds[i])&&!"0".equals(selecteds[i])){
			selectnode = ",com_"+selecteds[i]+selectnode;
		}
	}
    }
}


if(selectnode.startsWith(",")){
	selectnode = selectnode.substring(1);
}

String nodeid=null;
Cookie[] cks= request.getCookies();
String rem=null;

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
<BODY scroll="no" style="padding: 0px;margin: 0px;">
 <FORM NAME=select STYLE="margin-bottom:0" action="/mobile/plugin/browser/DepartmentBrowser.jsp" method=post>
    <input class=inputstyle type=hidden name=type value="<%=type%>">
    <input class=inputstyle type=hidden name=id value="<%=id%>">
    <input class=inputstyle type=hidden name=level value="<%=level%>">
    <input class=inputstyle type=hidden name=subid value="<%=subid%>">
    <input class=inputstyle type=hidden name=nodename value="<%=nodename%>">
    <table   width=100% height=100% border="0" cellspacing="0" cellpadding="0" style="margin: 0px;padding: 0px;">
        <colgroup>
        <col width="10">
        <col width="">
        <col width="10">
        <tr>
            <td ></td>
            <td valign="top">
                <TABLE  class=Shadow width="100%">
                    <tr>
                        <td valign="top">
                                <TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
                                      <TR>
                                          <TD colspan="4" WIDTH="100%">
	                                            <div id="deeptree" style="height:<%=browserType.equals("resourceMulti")?250:420%>px;width:100%;overflow:scroll;">
	                                            	<ul id="ztreedeep" class="ztree"></ul>
	                                            </div>
                                          </TD>
                                      </TR>
                                      <%if(!browserType.equals("resourceMulti")){%>
	                                       <tr style="height:10px"> <td height="0" colspan="3"></td></tr>
									       <tr>
										        <td align="center" valign="bottom" colspan=3>
													<BUTTON type="button" class=btn accessKey=O  id=btnok onclick="onSave()"><u>O</u>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
													<BUTTON type="button" class=btn accessKey=2  id=btnclear onclick="onClear()"><u>2</u>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
											        <BUTTON type="button" class=btnReset accessKey=T  id=btncancel onclick="window.parent.close()"><u>T</u>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
											        <%if(browserType=="departmentMulti"||browserType=="subcompanyMuti"){ %>
											        <BUTTON type="button" class=btnReset accessKey=T  id=btncancel onclick="needSelectAll(!selectallflag,this)">开启全选</BUTTON>
										            <%}%>
										        </td>
									        </tr>
								        <%} %>
                                </TABLE>
                         </td>
                    </tr>
                </TABLE>
            </td>
            <td></td>
        </tr>
    </table>
  </FORM>  
</BODY>
</HTML>

<script type="text/javascript">
	//<!--
	var browserType="<%=browserType%>";  //浏览框类型  多选  单选
	var selectallflag=false;             //是否开启全选
	var appendimg = 'subCopany_Colse';
	var appendname = 'selObj';
	var allselect = 'all';
	var selectedids = "<%=selectedids%>";
	var cxtree_id = "";
	if(selectedids!="0" && selectedids!=""){
		cxtree_id = "dept_<%=selectnode%>";
	}
	
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
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "/mobile/plugin/browser/HrmOrgTreeData.jsp?" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "/mobile/plugin/browser/HrmOrgTreeData.jsp?deptlevel=<%=deptlevel%>&excludeid=<%=excludeid%><%if(nodeid!=null){%>&init=true&nodeid=<%=nodeid%><%}%>&browserType="+browserType+ "&" + new Date().getTime() + "=" + new Date().getTime();
	    }
	};
	//zTree配置信息
	var setting;
	if(browserType=="departmentSingle"||browserType=="subcompanySingle"){
	   setting = {
		async: {
			enable: true,       //启用异步加载
			type:"get",
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
	}else if(browserType=="departmentMulti"||browserType=="subcompanyMuti"){
		setting = {
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
    }else if(browserType=="resourceMulti"){
	    setting = {
			async: {
				enable: true,       //启用异步加载
				type:"get",
				dataType: "text",   //ajax数据类型
				url: getAsyncUrl    //ajax的url
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
	}
	var zNodes =[];
	
	$(document).ready(function(){
		//初始化zTree
		$.fn.zTree.init($("#ztreedeep"), setting, zNodes);
	});
	
	function zTreeOnClick(event, treeId, treeNode) {
	    var nodeid=treeNode.nodeid;
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
		treeObj.checkNode(treeNode, true, false);
		
		if(browserType=="resourceMulti"){
		   jQuery("#frame2",window.parent.document)[0].contentWindow.setResourceStr();
		   var resourceids=jQuery("#frame2",window.parent.document)[0].contentWindow.resourceids;
		   if(nodeid.indexOf("dept")!=-1){
		      var nodeids=nodeid.split("_");
		      var subcompanyid=nodeids[1];
		      var departmentid=nodeids[2];
		      jQuery(window.parent.document).find("#frame2").attr("src","/mobile/plugin/browser/MutiResourceSelect.jsp?subcompanyid="+subcompanyid+"&departmentid="+departmentid+"&nodeid="+nodeid+"&resourceids="+resourceids);
		   }else if(nodeid.indexOf("com")!=-1){
		       var nodeids=nodeid.split("_");
		       var subcompanyid=nodeids[1];
		       jQuery(window.parent.document).find("#frame2").attr("src","/mobile/plugin/browser/MutiResourceSelect.jsp?subcompanyid="+subcompanyid+"&nodeid="+nodeid+"&resourceids="+resourceids);
		   }
		}
	};
	
	function onSave() {
    	var  trunStr = "", returnVBArray = null;
    	if(browserType=="departmentSingle"||browserType=="subcompanySingle")      //分部、部门单选
	       trunStr =getSingleResult(); 
	    else if(browserType=="departmentMulti"||browserType=="subcompanyMuti")    //分部、部门多选
	       trunStr=getMultiResult();
	    
	    if(trunStr != "") {
			returnVBArray = trunStr.split("$");
			var returnjson = {id:returnVBArray[0],name:returnVBArray[1]};
			/*
			if (window.opener != undefined) {
			       window.opener.returnValue =returnjson;
			}else {
			       window.returnValue =returnjson;
			}
			*/
	        window.returnValue  = returnjson;
	        window.close();
	    } else {
	        window.close();     
		}
    }
    
    function onClear() {
	    window.parent.returnValue = {id:"",name:""};
	    window.parent.close();
	}
	
	/**
	 * checkbox选中时触发
	 */
	function zTreeOnCheck(event, treeId, treeNode) {
		var treeObj = $.fn.zTree.getZTreeObj(treeId);
		if (treeNode.isInitAttr == false) {
			return;
		}
		
		var nodes = treeNode.childs;
		if (nodes == null || nodes == undefined) {
			treeObj.reAsyncChildNodes(treeNode, "refresh");
		}
	}
	
	/**
	 * ajax成功后触发
	 */
	function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    if(browserType=="subcompanyMuti")
	       appendimg="Home";
	    
		if (!selectallflag) {
			var rootnodes = treeObj.getNodesByParamFuzzy("icon", "global", null);
			setIsExistsCheckbox(treeObj, rootnodes, true);
			if(browserType!="subcompanySingle"){
				var homenodes = treeObj.getNodesByParamFuzzy("icon", "Home", null);
				var nodes = treeObj.getNodesByParamFuzzy("icon", appendimg, null);
				setIsExistsCheckbox(treeObj, homenodes, true);
				setIsExistsCheckbox(treeObj, nodes, false);
			}
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
	
	//获取分部、部门多选结果
	function getMultiResult(){
		var treeObj = $.fn.zTree.getZTreeObj("ztreedeep");
		if(browserType=="subcompanyMuti")
		   appendimg="Home";
	    var idstr = "";
	    var namestr = "";
	    
		var nodes = treeObj.getCheckedNodes(true);
		
		if (nodes == undefined || nodes == "" || nodes.length < 1) {
			return "";
		}
		
		var agceVal = ""; 
		for (var i=0; i<nodes.length; i++) {
			//开启全选 && 是一个父元素 && 被选中
			if (selectallflag && nodes[i].isParent && nodes[i].checked) {
				//子节点
				var childNodes = nodes[i].childs;
				//子节点为空，说明子节点还未ajax加载
				if (childNodes == undefined) {
					if (nodes[i].icon.indexOf(appendimg) != -1) {
						agceVal += ajaxGetChildEleValue(nodes[i].value, "dep");
					} else {
						agceVal += ajaxGetChildEleValue(nodes[i].value, "com");
					}
				}
			}

			if (nodes[i].icon.indexOf(appendimg) != -1) {
				idstr += "," + nodes[i].value;
				namestr += "," + nodes[i].name;
			}
		}
		
		var agceValArray = agceVal.split(",");
		var agceArray = null;
		var agceId = "";
		var agceName = "";
		for (var i=0; i<agceValArray.length; i++) {
			agceArray = agceValArray[i].split("_");
			
			if (agceArray != null && agceArray != undefined && agceArray.length > 2) {
				agceId += ",";
				agceId += agceArray[agceArray.length - 2];
				agceName += ",";
				agceName += agceArray[agceArray.length - 1];
			}
		}
		idstr += agceId;
		namestr += agceName;
		
		if(idstr.length>0)
		   idstr=idstr.substr(1);
		   
		if(namestr.length>0)
		   namestr=namestr.substr(1);
		
		resultStr = idstr + "$" + namestr;
	    return resultStr;
	}
	
	//获得分部、部门单选选择结果
	function getSingleResult(){
	
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
	    }else if(arraytemp.length > 2) {
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
	
	function ajaxGetChildEleValue(subId, suptype){
    	var ajaxvalue = "";
		$.ajax({
			type : "get",
			url : "/mobile/plugin/browser/BrowserOperation.jsp?operation=getHrmOrgChildren&subId=" + subId + "&suptype=" + suptype,
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
	//-->
	</SCRIPT>
