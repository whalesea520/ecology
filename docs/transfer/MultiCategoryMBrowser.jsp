<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="rc" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="dc" class="weaver.hrm.company.DepartmentComInfo" scope="page" />		
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />	
<%
    int categoryid = Util.getIntValue(request.getParameter("categoryid"), -1);
    int categorytype = Util.getIntValue(request.getParameter("categorytype"), -1);
    int operationcode = -1;
    String categoryname = Util.null2String(request.getParameter("categoryname"));
    String selectids = Util.null2String(request.getParameter("idStr"));
    boolean isAll = Util.null2String(request.getParameter("isAll")).equalsIgnoreCase("true");
    
    String _type = Util.null2String(request.getParameter("type"));
    int fromid = Util.getIntValue(request.getParameter("fromid"));
    boolean isHidden = Boolean.valueOf(Util.null2String(request.getParameter("isHidden"),"false"));
		String isDialog = Util.null2String(request.getParameter("isdialog"));
		String toid=Util.null2String(request.getParameter("toid"));
		String jsonSql = request.getParameter("jsonSql");//Tools.getURLDecode(request.getParameter("jsonSql"));
		String oldJson = jsonSql;
		jsonSql = Tools.replace(jsonSql,"\"","\\\\\"");
    int permissiontype =-1;
    String codeName = Util.null2String(request.getParameter("_fromURL"));
    if(codeName.startsWith("auth")) codeName=codeName.substring(4);
		//目录创建权限
		if("T141".equals(codeName)||"C141".equals(codeName)||"D121".equals(codeName)){//人员
			operationcode=0;permissiontype=5;
		} else if("T221".equals(codeName)||"C241".equals(codeName)||"D221".equals(codeName)){//部门
			operationcode=0;permissiontype=1;
		} else if("T321".equals(codeName)||"C341".equals(codeName)||"D321".equals(codeName)){//分部
			operationcode=0;permissiontype=6;
		} else if("T411".equals(codeName)||"C431".equals(codeName)||"D411".equals(codeName)){//角色
			operationcode=0;permissiontype=2;
		}
		
		//目录复制权限
		if("T142".equals(codeName)||"C142".equals(codeName)||"D122".equals(codeName)){//人员
			operationcode=3;permissiontype=5;
		} else if("T222".equals(codeName)||"C242".equals(codeName)||"D222".equals(codeName)){//部门
			operationcode=3;permissiontype=1;
		} else if("T322".equals(codeName)||"C342".equals(codeName)||"D322".equals(codeName)){//分部
			operationcode=3;permissiontype=6;
		} else if("T412".equals(codeName)||"C432".equals(codeName)||"D412".equals(codeName)){//角色
			operationcode=3;permissiontype=2;
		}
		
		//目录移动权限
		if("T143".equals(codeName)||"C143".equals(codeName)||"D123".equals(codeName)){//人员
			operationcode=2;permissiontype=5;
		} else if("T223".equals(codeName)||"C243".equals(codeName)||"D223".equals(codeName)){//部门
			operationcode=2;permissiontype=1;
		} else if("T323".equals(codeName)||"C343".equals(codeName)||"D323".equals(codeName)){//分部
			operationcode=2;permissiontype=6;
		} else if("T413".equals(codeName)||"C433".equals(codeName)||"D413".equals(codeName)){//角色
			operationcode=2;permissiontype=2;
		}
		
		User fromuser=new User();
		fromuser.setUid(fromid);
		fromuser.setLoginid(rc.getLoginID("" + fromid));
		fromuser.setFirstname(rc.getFirstname("" + fromid));
		fromuser.setLastname(rc.getLastname("" + fromid));
		fromuser.setLogintype("1");
		fromuser.setLanguage(7);
		fromuser.setEmail(rc.getEmail("" + fromid));
		fromuser.setLocationid(rc.getLocationid("" + fromid));
		fromuser.setResourcetype(rc.getResourcetype("" + fromid));
		fromuser.setJobtitle(rc.getJobTitle("" + fromid));
		fromuser.setJoblevel(rc.getJoblevel("" + fromid));
		fromuser.setSeclevel(rc.getSeclevel("" + fromid));
		fromuser.setUserDepartment(Util.getIntValue(rc.getDepartmentID("" + fromid), 0));
		fromuser.setUserSubCompany1(Util.getIntValue(dc.getSubcompanyid1(fromuser.getUserDepartment() + ""), 0));
		fromuser.setManagerid(rc.getManagerID("" + fromid));
		fromuser.setAssistantid(rc.getAssistantID("" + fromid));
    
    MultiAclManager am = new MultiAclManager();
    MultiCategoryTree tree = am.getPermittedTree(fromuser.getUID(), fromuser.getType(), Util.getIntValue(fromuser.getSeclevel(),0), operationcode,permissiontype,categoryname);
    
    int count=tree.getAllCategoryIds().size();
    List treelist=tree.getAllCategoryIds();
    if(isAll){
    	selectids="";
    	for(int i=0;i<count;i++){
    		selectids +=","+treelist.get(i);	
    	}
    	if(!"".equals(selectids)) selectids=selectids.substring(1);
    }
    
    MJson mjson = new MJson(oldJson, true);
		String oJson = Tools.getURLEncode(mjson.toString());
		try{
			mjson.removeArrayValue(_type);
		} catch(Exception e){}
		String nJson = Tools.getURLEncode(mjson.toString());
    
%>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser_wev8.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.excheck.min_wev8.js"></script>
<script type="text/javascript">
	//window.FIXTREEHEIGHT = 389;
	window.E8EXCEPTHEIGHT = 80;
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("16398",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e+"-->CategoryBrowser.jsp");
	}
	var parentWin = null;
	var parentDialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		parentDialog = parent.parent.getDialog(parent);
	}catch(e){}
</script>
<script>

function onClose(){
	if(parentDialog){
		parentDialog.close();
	}else{
    	window.parent.close();
    }
}

function setZtreeCheckbox(obj){
	var status = jQuery(obj).attr("_status");
	var treeObj = getZTreeObj();
	if(!status){//当前关闭全选状态
		jQuery(obj).attr("_status",1);
		jQuery(obj).text("<%= SystemEnv.getHtmlLabelName(19324,user.getLanguage())%>");
		treeObj.setting.check.chkboxType = { "Y": "s", "N": ""};
	}else{
		jQuery(obj).attr("_status",0);
		jQuery(obj).text("<%= SystemEnv.getHtmlLabelName(19323,user.getLanguage())%>");
		treeObj.setting.check.chkboxType = { "Y": "", "N": ""};
	}
}

function zTreeOnCheck(event, treeId, treeNode) {
	var treeObj = getZTreeObj();
	treeObj.expandNode(treeNode,true);
}

function selectDone(){
	var treeObj = getZTreeObj();
	var nodes = treeObj.getCheckedNodes(true);
	var id = "";
	var path = "";
	var path2 = "";
	var parentTId = 0;
	for(var i=0;i<nodes.length;i++){
		var node = nodes[i];
		if(!id){
			id=node.categoryid;
		}else{
			id=id+","+node.categoryid;
		}
	}
	try{id=id.toString();}catch(e){id="";}
	if (parentDialog) {
		var data = {
			type: '<%=_type%>',
			isAll: false,
			id: id,
			json: '<%=nJson%>'
		};
		parentDialog.callback(data);
		parentDialog.close();
	}
}

function clearselect() {
	if (parentDialog) {
		var data = {
			type: '<%=_type%>',
			isAll: false,
			id: '',
			json: '<%=nJson%>'
		};
		parentDialog.callback(data);
		parentDialog.close();
	}
}

function selectAll(){
			var treeObj = getZTreeObj();
			treeObj.checkAllNodes(true);
			
			selectDone();
			/*
			if (parentDialog) {
				var data = {
					type: '<%=_type%>',
					isAll: true,
					count: <%=count%>,
					json: '<%=oJson%>'
				};
				parentDialog.callback(data);
				parentDialog.close();
			}*/
		}

function onSearch(){
	document.SearchForm.submit();
}
</script>
</HEAD>
<BODY style="overflow:hidden;">
<div class="zDialog_div_content">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_top" onclick="onSearch();">
				<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<form name="SearchForm" id="SearchForm" method="post" action="MultiCategoryMBrowser.jsp">
	<input type="hidden" name="operationcode" value="<%=operationcode %>"/>
	<input type="hidden" name="categoryid" value="<%=categoryid %>"/>
	<input type="hidden" name="categorytype" value="<%=categorytype %>"/>
	<input type="hidden" name="_fromURL" value="<%=codeName %>"/>
	<input type="hidden" name="fromid" value="<%=fromid %>"/>
	<input type="hidden" name="type" value="<%=_type %>"/>
	<input type="hidden" name="jsonSql" value="<%=xssUtil.put(jsonSql) %>"/>
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage()) %>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(24764,user.getLanguage()) %></wea:item>
			<wea:item><input type="text" class="InputStyle" name="categoryname" id="categoryname" value='<%=categoryname %>'/></wea:item>
		</wea:group>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(32452,user.getLanguage()) %>'>
			<wea:item type="groupHead">
				<button _show="true" type="button" class="e8_btn_top" id="allcheckbtn" name="allcheckbtn" onclick="setZtreeCheckbox(this);"><%= SystemEnv.getHtmlLabelName(19323,user.getLanguage())%></button>
			</wea:item>
			<wea:item attributes="{'isTableList':'true'}">
				<div class="ulDiv2"></div>
			</wea:item>
		</wea:group>
	</wea:layout>
</form>
<script type="text/javascript">
	var demoLeftMenus = <%= tree.getTreeCategories().toString()%>;
	var expandAllFlag = <%=categoryname.equals("")?false:true%>;
	var selectids = "<%=selectids%>";
	function _categoryCallback(){
		if(!!selectids){
			checkedDefaultNode("categoryid",selectids);
		}
		if(expandAllFlag){
			_expandAll();
		}
	}
	$(".ulDiv2").leftNumMenu(demoLeftMenus,{
			showZero:false,
			addDiyDom:false,
			multiJson:true,
			_callback:_categoryCallback,	
			setting:{
				view: {
					expandSpeed: ""
				},
				callback: {
					onClick: _leftMenuClickFunction,
					onCheck:zTreeOnCheck   
				},
				check:{
					enable:true,
					autoCheckTrigger:true,
					chkStyle: "checkbox",
					chkboxType:{ "Y": "", "N": "" }
				}				
			}
	});
</script>

<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(555,user.getLanguage())+",javascript:selectDone(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(556,user.getLanguage())+",javascript:selectAll(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btn accessKey=1 onclick="onClose()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<!-- <BUTTON type="button" class=btn accessKey=2 onclick="clearselect()" id=btnclear><U></U><%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON> -->
</DIV>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
 </div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
				<input type="button" accessKey=0  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(555,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="selectDone();">
		    <input type="button" id=btnclear value="<%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="selectAll();">
		    <!-- <input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="clearselect();"> -->
		    <input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
</BODY></HTML>
