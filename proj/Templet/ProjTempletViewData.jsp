<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.docs.docs.CustomFieldManager"%>
<jsp:useBean id="ProjTempletUtil" class="weaver.proj.Templet.ProjTempletUtil" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
//User user = HrmUserVarify.getUser (request , response) ;
//if(user == null)  return ;
int templetId = Util.getIntValue(request.getParameter("templetId"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String preview =Util.null2String( request.getParameter("preview"));
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
String status ="";
String  strSql = "select * from Prj_Template where id="+templetId;      
RecordSet.executeSql(strSql);
if (RecordSet.next()){
    status = Util.null2String(RecordSet.getString("status"));//模板状态
}
//判断是否具有项目编码的维护权限
boolean canMaint = false ;
if (HrmUserVarify.checkUserRight("ProjTemplet:Maintenance", user)) {       
    canMaint = true ;
}
%>
<!DOCTYPE html>
<html>
<head>
<link href="/proj/js/colortip-1.0/colortip-1.0-jquery_wev8.css" rel="stylesheet" type="text/css" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script language=javascript src="/js/weaver_wev8.js"></script>

<SCRIPT language="javascript"  type='text/javascript' src="/js/ArrayList_wev8.js"></SCRIPT>
<SCRIPT language="javascript"  type='text/javascript' src="/js/projTask/ProjTask_wev8.js"></SCRIPT>
<script type="text/javascript" src="/js/projTask/temp/prjTask_wev8.js"></script>
<script type="text/javascript" src="/js/projTask/temp/jquery.z4x_wev8.js"></script>
<script type="text/javascript" src="/js/projTask/temp/ProjectAddTaskI2_wev8.js"></script>
<script type="text/javascript" src="/js/projTask/TaskUtil_wev8.js"></script>
<script type="text/javascript" src="/js/projTask/TaskDrag_wev8.js"></script>

<script src="/proj/js/fancytree/lib/jquery1.11.min_wev8.js" type="text/javascript"></script>
<link type="text/css" rel="stylesheet" href="/proj/js/fancytree/lib/jquery-ui-1.10/jquery-ui_wev8.css" />
<script src="/proj/js/fancytree/lib/jquery-ui-1.10/jquery-ui.min_wev8.js" type="text/javascript"></script>
<script type="text/javascript">
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.parent.getParentWindow(parent.window);
	var parentDialog = parent.parent.getDialog(parent);
}
</script>

<style type="text/css">
	/* custom alignment (set by 'renderColumns'' event) */
	td.alignRight {
	   text-align: right;
	}
	td input[type=input] {
		width: 40px;
	}
</style>
<script src="/proj/js/fancytree/lib/jquery-ui-contextmenu/jquery.ui-contextmenu_wev8.js" type="text/javascript"></script>
<link href="/proj/js/fancytree/src/skin-win7/ui.fancytree_wev8.css" rel="stylesheet" type="text/css">
<script src="/proj/js/fancytree/src/jquery.fancytree_wev8.js" type="text/javascript"></script>
<script src="/proj/js/fancytree/src/jquery.fancytree.dnd_wev8.js" type="text/javascript"></script>
<script src="/proj/js/fancytree/src/jquery.fancytree.edit_wev8.js" type="text/javascript"></script>
<script src="/proj/js/fancytree/src/jquery.fancytree.gridnav_wev8.js" type="text/javascript"></script>
<script src="/proj/js/fancytree/src/jquery.fancytree.table_wev8.js" type="text/javascript"></script>


<style type="text/css">
	.ui-menu {
		width: 150px;
		font-size: 63%;
	}
html { overflow-x:hidden; }
</style>

<script type="text/javascript">
var	CLIPBOARD = null;
$(function(){

	$("#tblTask").fancytree({
		checkbox: false,
		titlesTabbable: true,     // Add all node titles to TAB chain
		icons:false,
		debugLevel:0,
		source: {
			url:"/proj/task/PrjTaskTreeJSONData.jsp?loadAll=1&preview=1&src=template&templateId=<%=templetId %>"
		},
		lazyLoad: function(event, data) {
	      var node = data.node;
	      // Issue an ajax request to load child nodes
	      data.result = {
	        url: "/proj/task/PrjTaskTreeJSONData.jsp?loadAll=0&preview=1&src=template&templateId=<%=templetId %>",
	        data: {key: node.key}
	      }
	    },
	    init:function(event,data){//去掉1个样式
	    	$('span.fancytree-title').removeClass('fancytree-title');
	    },
		//extensions: ["edit", "dnd", "table", "gridnav"],
		extensions: [  "table", "gridnav"],

		dnd: {
			preventVoidMoves: true,
			preventRecursiveMoves: true,
			autoExpandMS: 400,
			dragStart: function(node, data) {
				return true;
			},
			dragEnter: function(node, data) {
				// return ["before", "after"];
				return true;
			},
			dragDrop: function(node, data) {
				data.otherNode.moveTo(node, data.hitMode);
			}
		},
		table: {
			indentation: 20,
			nodeColumnIdx: 2,
			checkboxColumnIdx: 0
		},
		gridnav: {
			autofocusInput: false,
			handleCursorKeys: true
		},


		
		renderColumns: function(event, data) {
			//console.log("data info:");
			/**for(var i in data){
				console.log(data[i]);
			}**/
			
			var node = data.node,
			$tdList = $(node.tr).find(">td");
			
			node.setExpanded(true);//自动展开节点
			// (index #0 is rendered by fancytree by adding the checkbox)
			if( node.isFolder() ) {
				// make the title cell span the remaining columns, if it is a folder:
				$tdList.eq(2)
					.prop("colspan", 6)
					.nextAll().remove();
			}

			$tdList.eq(1).text(node.getIndexHier()).addClass("alignRight");
			// (index #2 is rendered by fancytree)
			// $tdList.eq(3).text(node.key);
			var iRowIndex=node.key.substring(1);
			
			var tasknameval=node.title||"";
			var begindate=node.data.begindate||"";
			var enddate=node.data.enddate||"";
			var workday=node.data.workday||"";
			var budget=node.data.budget||"";
			var beftaskid=node.data.beftaskid||"";
			var beftaskname=node.data.beftaskname||"";
			var hrmid=node.data.hrmid||"";
			var hrmname=node.data.hrmname||"";
			//var pid=node.data.pid||"";
			var pid=node.getParent().key.substring(1)||"0";//父亲的索引
			var lv=node.getLevel()||"1";//任务层级
			
			//模板的任务id
			var templatetaskid=node.data.id||"";
			var templatetaskidHtml="<input type='hidden' name='templetTaskId' value='"+templatetaskid+"' />";
			
			var parentindexHtml="<input type='hidden' name='txtParentRowIndex' id='txtParentRowIndex_"+iRowIndex+"' value='"+pid+"' />";
			var levelHtml="<input type='hidden' name='txtLevel' id='txtLevel_"+iRowIndex+"' value='"+lv+"' />";
			
			var rowindexHtml="<input type='hidden' name='txtRowIndex' id='txtRowindex_"+iRowIndex+"' value='"+iRowIndex+"' />";
			var tasknameHtml="<input type='hidden' class='InputStyle'  name='txtTaskName' size='24'  style='width:150px!important;'    id='txtTaskName_"+iRowIndex+"' onchange=''   customIndex='"+iRowIndex+"' value='"+tasknameval+"' />";
			//var worklongHtml="<input type='text' class='InputStyle' style='width:50px!important;' name='txtWorkLong'  size='4' id='txtWorkLong_"+iRowIndex+"'  onKeyPress='ItemNum_KeyPress(this)' onchange='onWorkLongChange(this,txtBeginDate_"+iRowIndex+",spanBeginDate_"+iRowIndex+",txtEndDate_"+iRowIndex+",spanEndDate_"+iRowIndex+")' value='"+workday+"'>"; 
			var worklongHtml="<span>"+workday+"</span>"; 
			var begindateHtml="<button type=\"button\" class=Calendar style='display:none;' onclick='onShowBeginDate(txtBeginDate_"+iRowIndex+",spanBeginDate_"+iRowIndex+",txtEndDate_"+iRowIndex+",spanEndDate_"+iRowIndex+",txtWorkLong_"+iRowIndex+")'></BUTTON>"+
            "<SPAN id=spanBeginDate_"+iRowIndex+" >"+begindate+"</SPAN>"+
            "<input type='hidden' name='txtBeginDate' id='txtBeginDate_"+iRowIndex+"' value='"+begindate+"'>";  
            var enddateHtml ="<button type=\"button\" class=Calendar style='display:none;' onclick='onShowEndDate(txtEndDate_"+iRowIndex+",spanEndDate_"+iRowIndex+",txtBeginDate_"+iRowIndex+",spanBeginDate_"+iRowIndex+",txtWorkLong_"+iRowIndex+")'></BUTTON>"+
            "<SPAN id=spanEndDate_"+iRowIndex+" >"+enddate+"</SPAN>"+
            "<input type='hidden' name='txtEndDate' id='txtEndDate_"+iRowIndex+"' value='"+enddate+"'>";                
            var pretaskHtml="<button type=\"button\" class=Browser style='display:none;' onclick='onSelectBeforeTaskE8(seleBeforeTaskSpan_"+iRowIndex+",seleBeforeTask_"+iRowIndex+")'></button><input type=hidden name='seleBeforeTask' id='seleBeforeTask_"+iRowIndex+"' value='"+beftaskid+"'  onchange='beforeTask_check(this)' ><span id='seleBeforeTaskSpan_"+iRowIndex+"'>"+beftaskname+"</span><input type=hidden name='index_"+iRowIndex+"' id='index_"+iRowIndex+"' value='"+iRowIndex+"'>";
            //var budgetHtml="<input type='text' class='InputStyle' style='width:80px!important;' name='txtBudget' size='8' id='txtBudget_"+iRowIndex+"' onKeyPress='ItemNum_KeyPress(this)' value='"+budget+"'>";                
           var budgetHtml="<span>"+budget+"</span>";                
            var managerHtml="<button type=\"button\" class=Browser style='display:none;' onclick='onSelectApprove(txtManagerSpan_"+iRowIndex+",txtManager_"+iRowIndex+")'></button><input type=hidden name='txtManager' id='txtManager_"+iRowIndex+"' value='"+hrmid+"' ><span id='txtManagerSpan_"+iRowIndex+"'>"+hrmname+"</span>";
            
			$tdList.eq(3).html(parentindexHtml+levelHtml+templatetaskidHtml+rowindexHtml+tasknameHtml+worklongHtml);
			$tdList.eq(4).html(begindateHtml);
			$tdList.eq(5).html(enddateHtml);
			$tdList.eq(6).html(pretaskHtml);
			$tdList.eq(7).html(budgetHtml);
			$tdList.eq(8).html(managerHtml);
			//$tdList.eq(7).html($select);
		}
	}).on("nodeCommand", function(event, data){
		// Custom event handler that is triggered by keydown-handler and
		// context menu:
		/**	
		var refNode, moveMode,
			tree = $(this).fancytree("getTree"),
			node = tree.getActiveNode();

		switch( data.cmd ) {
		case "moveUp":
			node.moveTo(node.getPrevSibling(), "before");
			node.setActive();
			break;
		case "moveDown":
			node.moveTo(node.getNextSibling(), "after");
			node.setActive();
			break;
		case "indent":
			refNode = node.getPrevSibling();
			node.moveTo(refNode, "child");
			refNode.setExpanded();
			node.setActive();
			break;
		case "outdent":
			node.moveTo(node.getParent(), "after");
			node.setActive();
			break;
		case "rename":
			node.editStart();
			break;
		case "remove":
			node.remove();
			break;
		case "addChild":
			refNode = node.addChildren({
				title: "新的子任务",
				isNew: true
			});
			node.setExpanded();
			refNode.editStart();
			break;
		case "addSibling":
			refNode = node.getParent().addChildren({
				title: "<%=SystemEnv.getHtmlLabelNames("83982",user.getLanguage())%>",
				isNew: true
			}, node.getNextSibling());
			refNode.editStart();
			break;
		case "cut":
			CLIPBOARD = {mode: data.cmd, data: node};
			break;
		case "copy":
			CLIPBOARD = {
				mode: data.cmd,
				data: node.toDict(function(n){
					delete n.key;
				})
			};
			break;
		case "clear":
			CLIPBOARD = null;
			break;
		case "paste":
			if( CLIPBOARD.mode === "cut" ) {
				// refNode = node.getPrevSibling();
				CLIPBOARD.data.moveTo(node, "child");
				CLIPBOARD.data.setActive();
			} else if( CLIPBOARD.mode === "copy" ) {
				node.addChildren(CLIPBOARD.data).setActive();
			}
			break;
		default:
			alert("Unhandled command: " + data.cmd);
			return;
		}
		**/
	}).on("keydown", function(e){
		/**
		var c = String.fromCharCode(e.which),
			cmd = null;

		if( c === "N" && e.ctrlKey && e.shiftKey) {
			cmd = "addChild";
		} else if( c === "C" && e.ctrlKey ) {
			cmd = "copy";
		} else if( c === "V" && e.ctrlKey ) {
			cmd = "paste";
		} else if( c === "X" && e.ctrlKey ) {
			cmd = "cut";
		} else if( c === "N" && e.ctrlKey ) {
			cmd = "addSibling";
		} else if( e.which === $.ui.keyCode.DELETE ) {
			cmd = "remove";
		} else if( e.which === $.ui.keyCode.F2 ) {
			cmd = "rename";
		} else if( e.which === $.ui.keyCode.UP && e.ctrlKey ) {
			cmd = "moveUp";
		} else if( e.which === $.ui.keyCode.DOWN && e.ctrlKey ) {
			cmd = "moveDown";
		} else if( e.which === $.ui.keyCode.RIGHT && e.ctrlKey ) {
			cmd = "indent";
		} else if( e.which === $.ui.keyCode.LEFT && e.ctrlKey ) {
			cmd = "outdent";
		}
		if( cmd ){
			$(this).trigger("nodeCommand", {cmd: cmd});
			return false;
		}
		**/
	});

	/*
	 * Context menu (https://github.com/mar10/jquery-ui-contextmenu)
	 
	$("#tblTask").contextmenu({
		delegate: "span.fancytree-title",
		menu: [
			{title: "<%=SystemEnv.getHtmlLabelNames("93",user.getLanguage())%>", cmd: "rename", uiIcon: "ui-icon-pencil" },
			{title: "删除", cmd: "remove", uiIcon: "ui-icon-trash" },
			{title: "----"},
			{title: "添加同级任务", cmd: "addSibling", uiIcon: "ui-icon-plus" },
			{title: "<%=SystemEnv.getHtmlLabelNames("83902",user.getLanguage())%>", cmd: "addChild", uiIcon: "ui-icon-plus" },
			{title: "----"},
			{title: "剪切", cmd: "cut", uiIcon: "ui-icon-scissors"},
			{title: "复制", cmd: "copy", uiIcon: "ui-icon-copy"},
			{title: "粘贴", cmd: "paste", uiIcon: "ui-icon-clipboard", disabled: true }
			],
		beforeOpen: function(event, ui) {
			var node = $.ui.fancytree.getNode(ui.target);
			$("#tblTask").contextmenu("enableEntry", "paste", !!CLIPBOARD);
			node.setActive();
		},
		select: function(event, ui) {
			var that = this;
			// delay the event, so the menu can close and the click event does
			// not interfere with the edit control
			setTimeout(function(){
				$(that).trigger("nodeCommand", {cmd: ui.cmd});
			}, 100);
		}
	});
	*/
});
function hideRightMenu(e){
	var event=$.event.fix(e);
	var element=event.target;
	var tagname=element.tagName.toLowerCase();
	var classname=element.className.toLowerCase();
	//console.log("tagname:"+tagname);
	//console.log("classname:"+classname);
	if(("span"===tagname&&"fancytree-title"===classname) || ("input"===tagname&&"fancytree-edit-input"===classname) ){
		$("#rightMenuIframe").hide();
	}else{
		$("#rightMenuIframe").show();
	}
}
</script>
</head>
<body class="example" oncontextmenu="">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
String editPrjUrl="/proj/Templet/ProjTempletEdit.jsp?templetId="+templetId+"&isdialog="+isDialog;
if(!"1".equals(preview)&&!"2".equals(status) ){
	if (canMaint) {      
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:onEdit("+templetId+"),_self} " ;
	    RCMenuHeight += RCMenuHeightStep ;
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(26601,user.getLanguage())+",javascript:impTempletTask("+templetId+"),_self} " ;
	    RCMenuHeight += RCMenuHeightStep ;
	}
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<!------------------任务列表---------------------开始-->
   <input type="hidden" onclick="getXmlDocStr1()" value="GetXmlDocStr">
   <TEXTAREA NAME="areaLinkXml" id="areaLinkXml" ROWS="6" COLS="100" style="display:none"></TEXTAREA> 
   <!--得到隐藏的层,等此form提交的时候不要忘了清除里的的数据-->  
   <div id="divTaskList" style="display:''">
   <TABLE CLASS="ListStyle" valign="top" cellspacing=1 id="tblTask" >
   			<colgroup>
    	  	<col width="3%">
    	  	<col width="5%">
    	  	<col width="20%">
    	  	<col width="5%">
    	  	<col width="12%">
    	  	<col width="12%">
    	  	<col width="15%">
    	  	<col width="8%">
    	  	<col width="10%">
    	  </colgroup>
    	  <thead>
    	  	<TR class="header">
	           <TH	width="3%"></TH>
	           <TH	width="5%" nowrap><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></TH>
	           <TH	width="20%" id="remindHeader"><%=SystemEnv.getHtmlLabelName(1352,user.getLanguage())%></TH>
	           <TH	width="5%"><%=SystemEnv.getHtmlLabelName(1298,user.getLanguage())%></TH>
	           <TH	width="12%"><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></TH>     
	           <TH	width="12%"><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></TH>
	           <TH	width="15%"><%=SystemEnv.getHtmlLabelName(2233,user.getLanguage())%></TH>
	           <TH	width="8%"><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></TH>
	           <TH	width="10%"><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TH>
	       </TR>
    	  </thead>
          <TBODY></TBODY>
    </TABLE>
</div>   

 
<!------------------任务列表------------------结束-->
<%--
<TEXTAREA NAME="task_xml" id="task_xml" ROWS="6" COLS="100" style="display:none"><%=ProjTempletUtil.getXmlStr()%></TEXTAREA>
<input type="hidden" id="task_iRowIndex" name="task_iRowIndex" value="<%=ProjTempletUtil.getMaxTaskId(templetId)%>">
<input type="hidden" id="task_RowindexNum" name="task_RowindexNum" value="<%=ProjTempletUtil.getTaskNum(templetId)%>">
 --%>
 

<table id="remindtbl" class=ReportStyle style="display:none;">
<TBODY>
<TR><TD>
<%
if(user.getLanguage()==8){
	%>
Warm tips:
1, hold down the task name can drag task; <br>
2, the right mouse button click the task name pop-up task menu <br>
3, support keyboard shortcuts operation; 4, the mouse to double-click a row to modify the task name;	
	<%
}else if(user.getLanguage()==9){
	%>
溫馨提示:
1,按住任務名稱可拖動任務;<br>
2,鼠標右鍵單擊任務名稱彈出任務快捷操作菜單;<br>
3,支持鍵盤快捷鍵操作;4,鼠標雙擊某行修改任務名稱;	
	<%
}else{
	%>
温馨提示:
1,按住任务名称可拖动任务;<br>
2,鼠标右键单击任务名称弹出任务快捷操作菜单;<br>
3,支持键盘快捷键操作;4,鼠标双击某行修改任务名称;
	<%
}

%>

</TD></TR>
</TBODY>
</table>
<script type="text/javascript" src="/proj/js/colortip-1.0/colortip-1.0-jquery_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>


<script type="text/javascript">
//选择前置任务
function onSelectBeforeTaskE8(spanname,inputename){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectTaskBrowser.jsp",document.getElementsByName("txtTaskName"));
	if (datas){
		if(datas.id!=""){
			$(spanname).html(datas.name);
			$(inputename).val(datas.id);
			var oldIndex=$("input[name='txtRowIndex']:eq("+(datas.id-1)+")").val(); 
			$(inputename).attr("oldIndex",oldIndex);
		}else{
			$(spanname).html("");
			$(inputename).val("");
		}
	}
	beforeTask_check(inputename);
}

//选择负责人
function onSelectManagerE8(spanname,inputename){
	tmpids = $("input[name=hrmids02]",parent.document).val();
	//console.log("tmpids:"+tmpids);
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectManagerBrowser.jsp?Members="+tmpids);
	if (datas){
		if(datas.id!=""){
			$(spanname).html("<A href='/hrm/resource/HrmResource.jsp?id="+datas.id+"'>"+datas.name+"</A>");
			$(inputename).val(datas.id);
		}else {
			$(spanname).html( "");
			$(inputename).val("");
		}
	}
}
//多选任务负责人
function onSelectApprove(spanname,inputename){
	
	tmpids = $(inputename).val();
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids);
	if (datas){
		if(datas.id!=""){
			var tempid = datas.id;
			var tempname = datas.name;
			if (tempid.substr(0,1)==',') tempid=tempid.substr(1);
			if (tempname.substr(0,1)==',') tempname = tempname.substr(1);
			//var ids = tempid.split(",");
			var names = tempname.split(",");
			//alert(ids.length);
			var valuename = "";
			for(var i=0;i<names.length;i++){
				valuename += names[i]+"&nbsp;";
			}
			$(spanname).html(valuename);
			$(inputename).val(tempid);
		}else {
			$(spanname).html( "");
			$(inputename).val("");
		}
	}
}

function addRow(){
	var rootNode = $("#tblTask").fancytree("getRootNode");
    var childNode = rootNode.addChildren({
      title: "<%=SystemEnv.getHtmlLabelNames("83982",user.getLanguage())%>",
      folder: false,
      isNew: true
    });
    childNode.editStart();
}
function delRows(){
	if(window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelNames("83983",user.getLanguage())%>",function(){
		$("#tblTask").fancytree("getTree").visit(function(node){
			/**for(var i in node){
				console.log(node[i]);
			}**/
			if(node.selected){
				node.remove();
			}
	  	});
	}));
}

$(function(){
	$("#chkAllObj").bind('click',function(){
		if(!$(this).is(":checked")){
			$("#tblTask").fancytree("getTree").visit(function(node){
	        	node.setSelected(true);
	      	});
		}else{
			$("#tblTask").fancytree("getTree").visit(function(node){
	        	node.setSelected(false);
	      	});
		}
	});
	
	//绑定文本框鼠标悬停效果(貌似没出效果)
	$("#tblTask").delegate("input[type=text]","mouseover",function(){$(this).parent("td").addClass("e8Selected").parent("tr").addClass("Selected");})
	.delegate("input[type=text]","mouseout",function(){$(this).parent("td").removeClass("e8Selected").parent("tr").removeClass("Selected");});
	
	//提示
	/**
	try{
		var remindimg="<a name='remindlink' href='javascript:void(0)' title='"+$("#remindtbl").html()+"'><img src='/wechat/images/remind_wev8.png' align='absMiddle'  /></a>";
		$("#remindHeader").append("&nbsp;&nbsp;&nbsp;&nbsp;").append(remindimg);
	}catch(e){}
	
	$('a[name=remindlink][title]').colorTip({color:'yellow'});
	**/
	//去掉一个样式
	//setTimeout("$('span.fancytree-title').removeClass('fancytree-title');", 2000);
	
});

//提交时重算任务等级和父亲索引
function reloadTaskTree(){
	$("#tblTask").fancytree("getTree").visit(function(node){
		$(node.tr).find("input[type=hidden][name=txtLevel]").val(node.getLevel());
		$(node.tr).find("input[type=hidden][name=txtParentRowIndex]").val(node.getParent().key.substring(1)||"0");
  	});
}

function onEdit(id){
	if(id){
		//var currenttab=jQuery("#currentTab",parent.parent.document).val();
		var currenttab='tab2';
		//alert("currenttab:"+currenttab);
		window.parent.parent.location.href="<%=editPrjUrl %>"+"&currentTab="+currenttab;  
	}
}

function impTempletTask(templetId){
	if(templetId){
		window.parent.parent.location.href="/proj/imp/prjtskTempletimp.jsp?templetId="+templetId;
	}
}
</script>

<%
if("1".equals(isDialog)){
	%>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">

				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
					id="zd_btn_cancle" class="zd_btn_cancle" onclick="parentDialog.close()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>	
	<%
}

%>

</body>
</html>


