<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.formmode.service.BrowserInfoService"%>
<%@page import="org.apache.lucene.util.StringHelper"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.workflow.workflow.BillComInfo"%>
<%@ include file="/formmode/pub.jsp"%>
<%
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<%
int id = Util.getIntValue(request.getParameter("id"), 0);
boolean isRefreshLeftData = Util.null2String(request.getParameter("isRefreshLeftData")).equals("1");
String customname = "";
String customdesc = "";
String defaultSql = "";
int disQuickSearch = 0;
int opentype = 0;
String norightlist = "";
String formID = "";	
String formName = "";
String isBill = "1";
String modeid=Util.null2String(request.getParameter("modeid"));

BrowserInfoService browserInfoService=new BrowserInfoService();
BillComInfo billComInfo=new BillComInfo();
if(id!=0){
	Map<String,Object> map=browserInfoService.getBrowserInfoById(id);
	if(map.size()>0){
		customname=Util.toScreen(Util.null2String(map.get("customname")),user.getLanguage());
		customdesc=Util.toScreenToEdit(Util.null2String(map.get("customdesc")),user.getLanguage());
		defaultSql=Util.toScreenToEdit(Util.null2String(map.get("defaultsql")),user.getLanguage());
		formID=Util.null2String(map.get("formid"));
		//formName=formComInfo.getFormname(formID);
		formName = Util.null2String(SystemEnv.getHtmlLabelName(Util.getIntValue(billComInfo.getBillLabel(formID)), user.getLanguage()));
		if ("".equals(formName)) formName = "<IMG src=\"/images/BacoError_wev8.gif\" align=absMiddle>";
		else formName = "<a href=\"#\" onclick=\"toformtab('"+formID+"')\" style=\"color:blue;TEXT-DECORATION:none\">"+formName+"</a>";
		modeid=Util.null2String(map.get("modeid"));
	}
}

%>
<html>
<head>
<title></title>
	<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
		<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
		<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css"type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
<style>
*{
	font: 12px Microsoft YaHei;
}
/*
html, body{
	height: 100%;
	overflow-x: hidden;
}*/
.e8_tblForm{
	width: 100%;
	margin: 0 0;
	border-collapse: collapse;
}
.e8_tblForm .e8_tblForm_label{
	vertical-align: top;
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 0;
}
.e8_tblForm .e8_tblForm_field{
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 7px;
	background-color: #f8f8f8;
}
.e8_label_desc{
	color: #aaa;
}

.e8_forGridHidden{
	height: 10px;
}
.e8_ext_grid{
	margin-top: 10px;
}
/*Ext 表格对应的样式(框架)*/
.e8_ext_grid .x-border-layout-ct{
	background-color: #fff;
}
.e8_ext_grid .x-panel-body-noheader{
	border: none;
}
.e8_ext_grid .x-panel-tl{
	border-bottom-width: 0px;
}
.e8_ext_grid .x-panel-ml{
	padding-left: 0px;
	background-image: none;
}
.e8_ext_grid .x-panel-mc{
	padding-top: 0px;
	background-color: #fff;
}
.e8_ext_grid .x-panel-mr{
	padding-right: 0px;
	background-image: none;
}
.e8_ext_grid .x-panel-nofooter .x-panel-bc{
	height: 0px;
	overflow:hidden;
}

/*Ext 表格对应的样式(表格)*/
.e8_ext_grid .x-grid-panel .x-panel-mc .x-panel-body{
	border: none; 
}
.e8_ext_grid .x-grid3-header{
	background: none;
	padding-left: 3px;
	background-color: #E5E5E5;
}
.e8_ext_grid .x-grid3-hd-inner{
	background-image: none;
	background-color:#e5e5e5;
}
.e8_ext_grid .x-grid3-hd-row td{
	background-color: #E5E5E5;
	border-left: none;
	border-right-color: #d0d0d0;
}
.e8_ext_grid .x-grid3-hd-row td .x-grid3-hd-inner{
	color: #333;
}
.e8_ext_grid .x-grid3-row-table td{
	
}
.e8_ext_grid .x-grid3-header-inner{
	background-color: #E5E5E5;
}
.e8_ext_grid td.x-grid3-hd-over .x-grid3-hd-inner{
	background-image: none;
	background-color: #E5E5E5;
}
.e8_ext_grid .x-grid3-hd-over .x-grid3-hd-btn{
	display: none;
}
.e8_ext_grid .x-grid3-scroller{

}
.e8_ext_grid .x-grid3-locked .x-grid3-scroller{
	border-right-color: #d0d0d0;
}
.e8_ext_grid .x-grid3-body .x-grid3-td-checker{
	padding-left: 3px;
	background: none;
}
.e8_ext_grid .x-grid3-cell-inner{
	padding: 1px 3px 1px 5px;
}
.e8_ext_grid .x-grid3-row, .x-grid3-row-selected{
	background-color: #fff !important;
	border-top: 1px solid #fff;
	border-bottom: 1px solid #ededed;
	border-left: 0px;
	border-right: 0px;
}

.e8_ext_grid .x-grid3-body .x-grid3-row-selected .x-grid3-td-checker{
	background-image: none;
}
.e8_ext_grid .x-panel-bc, .e8_ext_grid .x-panel-bl, .e8_ext_grid .x-panel-br{
	background-image:none;
}
</style>
<link rel="stylesheet" type="text/css" href="/formmode/js/ext/resources/css/ext-all_wev8.css" />
<link rel="stylesheet" type="text/css" href="/formmode/js/ext/ux/css/columnLock_wev8.css"/>
<script type="text/javascript" src="/formmode/js/ext/adapter/ext/ext-base_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/ext/ext-all_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/ext/ux/miframe_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/ext/ux/iconMgr_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/ext/ux/columnLock_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/ext/ux/CardLayout_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/ext/ux/Wizard_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/ext/ux/Card_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/ext/ux/Header_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/ext/ux/TreeCheckNodeUI_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/FormmodeUtil_wev8.js"></script>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script>
$(document).ready(function () {
	<%if(isRefreshLeftData){%>
		try{
			parent.parent.refreshData();
		}catch(e){}
	<%}%>
});
function forPageResize(){
	var $body = $(document.body);
	var $forGridHidden = $(".e8_forGridHidden");
	var $extGrid = $("#e8_ext_grid");
	
	var gridHeight = $body.height() - $forGridHidden.outerHeight(true);
	$extGrid.height(gridHeight);
}
Ext.override(Ext.grid.ColumnModel,{
	isLocked :function(colIndex){
		if(this.config[colIndex] instanceof Ext.grid.CheckboxSelectionModel){return true;}
		return this.config[colIndex].locked === true;
	}
});
Ext.override(Ext.grid.CheckboxSelectionModel,{
    selectRow : function(index, keepExisting, preventViewNotify){
		if(this.locked || (index < 0 || index >= this.grid.store.getCount())) return;
		var r = this.grid.store.getAt(index);
		if(r && this.fireEvent("beforerowselect", this, index, keepExisting, r) !== false){
			/*if(!keepExisting || this.singleSelect){
				this.clearSelections();
			}*/
			this.selections.add(r);
			this.last = this.lastActive = index;
			if(!preventViewNotify){
				this.grid.getView().onRowSelect(index);
			}
			this.fireEvent("rowselect", this, index, r);
			this.fireEvent("selectionchange", this);
		}
	},
    handleMouseDown : function(g, rowIndex, e){
        if(e.button !== 0 || this.isLocked()){
            return;
        };
        var view = this.grid.getView();
        if(e.shiftKey && this.last !== false){
            var last = this.last;
            this.selectRange(last, rowIndex, e.ctrlKey);
            this.last = last;             view.focusRow(rowIndex);
        }else{
            var isSelected = this.isSelected(rowIndex);
            if((e.ctrlKey||e.getTarget().className=='x-grid3-row-checker') && isSelected){
                this.deselectRow(rowIndex);
            }else if(!isSelected || this.getCount() > 1){
                this.selectRow(rowIndex, e.ctrlKey || e.shiftKey||e.getTarget().className=='x-grid3-row-checker');
                view.focusRow(rowIndex);
            }
        }
    },
    onHdMouseDown : function(e, t){
        if(t.className == 'x-grid3-hd-checker'){
            e.stopEvent();
            var hd = Ext.fly(t.parentNode);
            var isChecked = hd.hasClass('x-grid3-hd-checker-on');
            if(isChecked){
                hd.removeClass('x-grid3-hd-checker-on');
                this.clearSelections();
            }else{
                hd.addClass('x-grid3-hd-checker-on');
                this.selectAll();
            }
        }
    }
});
Ext.override(Ext.grid.LockingGridView, {
	getEditorParent : function(ed){
		return this.el.dom;
	},
	refreshRow : function(record){
		Ext.grid.LockingGridView.superclass.refreshRow.call(this, record);
		var index = this.ds.indexOf(record);
		this.getLockedRow(index).rowIndex = index;
	}
});

//==================================================
Ext.grid.CheckColumn = function(config){
    Ext.apply(this, config);
    if(!this.id){
        this.id = Ext.id();
    }
    this.renderer = this.renderer.createDelegate(this);
};

Ext.grid.CheckColumn.prototype ={
    init : function(grid){
        this.grid = grid;
        this.grid.on('render', function(){
            var view = this.grid.getView();
            view.mainBody.on('mousedown', this.onMouseDown, this);
        }, this);
    },

    onMouseDown : function(e, t){
        if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){
            e.stopEvent();
            var index = this.grid.getView().findRowIndex(t);
            var record = this.grid.store.getAt(index);
            record.set(this.dataIndex, !record.data[this.dataIndex]);
        }
    },

    renderer : function(v, p, record){
        p_wev8.css += ' x-grid3-check-col-td'; 
        return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
    }
};
//==================================================

var grid;
var store;
		
Ext.onReady(function(){
	
	forPageResize();
	
	$(window).resize(function(){
		//forPageResize();
		if(grid){
			grid.setHeight($("#e8_ext_grid").height());  
		}
	});
		
	var sm = new Ext.grid.CheckboxSelectionModel();

	var titleCombo=new Ext.form.ComboBox({
        typeAhead: true,
        triggerAction: 'all',
        transform:'istitle',
        lazyRender:true,
        listClass: 'x-combo-list-small'
	});
	
	var queryCombo=new Ext.form.ComboBox({
        typeAhead: true,
        triggerAction: 'all',
        transform:'isquery',
        lazyRender:true,
        listClass: 'x-combo-list-small'
	});
	
	var orderCombo=new Ext.form.ComboBox({
        typeAhead: true,
        triggerAction: 'all',
        transform:'isorder',
        lazyRender:true,
        listClass: 'x-combo-list-small'
	});
	
	function formatTitle(value){
		var record=titleCombo.store.getById(value);
		if (typeof(record) == "undefined")
			return '<%=SystemEnv.getHtmlLabelName(30587,user.getLanguage())%>';//否
		else
			return record.get('text');
	}
	
	function formatQuery(value){
		var record=queryCombo.store.getById(value);
		if (typeof(record) == "undefined")
			return '<%=SystemEnv.getHtmlLabelName(30587,user.getLanguage())%>';//否
		else
			return record.get('text');
	}
	
	function formatOrder(value){
		var record=orderCombo.store.getById(value);
		if (typeof(record) == "undefined")
			return '<%=SystemEnv.getHtmlLabelName(30587,user.getLanguage())%>';//否
		else
			return record.get('text');
	}
	
	var cm = new Ext.grid.LockingColumnModel([sm, {
	    header: "<%=SystemEnv.getHtmlLabelName(33331,user.getLanguage())%>",//字段
	    dataIndex: 'fieldname',
	    width: 150,
	    locked: true
	}, {
	    header: "<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>",//名称
	    dataIndex: 'fieldlabelname',
	    width: 100,
	    locked: true
	}, {
	    header: "<%=SystemEnv.getHtmlLabelName(19501,user.getLanguage())%>?",//标题字段?
	    dataIndex: 'istitle',
	    width: 80,
	    renderer: formatTitle,
	    editor: titleCombo
	}, {
	    header: "<%=SystemEnv.getHtmlLabelName(22394,user.getLanguage())%>",//标题显示顺序
	    dataIndex: 'showorder',
	    width: 90,
	    editor: new Ext.form.TextField({                
		    allowBlank: true         
		})
	}, {
	    header: "<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>?",//查询条件?
	    dataIndex: 'isquery',
	    width: 80,
	    renderer: formatQuery,
	    editor: queryCombo
	}, {
	    header: "<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%>",//查询显示顺序
	    dataIndex: 'queryorder',
	    width: 110,
	    editor: new Ext.form.TextField({                
		    allowBlank: true           
		})
	}, {
	    header: "<%=SystemEnv.getHtmlLabelName(338,user.getLanguage())%>?",//排序?
	    dataIndex: 'isorder',
	    width: 80,
	    renderer: formatOrder,
	    editor: orderCombo
	}, {
	    header: "<%=SystemEnv.getHtmlLabelName(22413,user.getLanguage())%>",//排序优先级
	    dataIndex: 'orderlevel',
	    width: 110
	}]);

	store = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
      		method:"post",
       		url: '/weaver/weaver.formmode.servelt.BrowserAction?action=getFieldsJSON&id=<%=id%>'
		}),
		reader: new Ext.data.JsonReader({
			root: 'result',
			totalProperty: 'totalCount',
			fields: ['fieldid', 'fieldname', 'fieldlabel', 'fieldlabelname', 'isquery', 'isshow', 'showorder', 'queryorder', 'istitle', 'colwidth','isorder','orderlevel']
        }),
        remoteSort: true
	});
	
	store.on('load',function(st,recs) {
        for (var i = 0; i < recs.length; i++) {
            var indoor = recs[i].get('isshow');
            if (indoor==1) {
                sm.selectRecords([recs[i]], true);
            }
        }
    });
			
	grid = new Ext.grid.LockingEditorGridPanel({
	    store: store,
	    cm: cm,
	    sm: sm,
	    region: 'center',
	    renderTo: 'e8_ext_grid',
	    height: $("#e8_ext_grid").height(),
	    loadMask: true,
	    frame: true,
	    clicksToEdit: 1,
	    //plugins: [checkColumnQuery,checkColumnTitle],
	    viewConfig: {
	        center: {
	            autoScroll: true
	        },
	        forceFit: false,
	        enableRowBody: true,
	        sortAscText: '<%=SystemEnv.getHtmlLabelName(339,user.getLanguage())%>',//升序
	        sortDescText: '<%=SystemEnv.getHtmlLabelName(340,user.getLanguage())%>',//降序
	        columnsText: '<%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%>',//列定义
	        getRowClass: function(record, rowIndex, p, store){
	            return 'x-grid3-row-collapsed';
	        }
	    }
	});
	
	grid.on("cellclick", function(grid, rowIndex, columnIndex, e){
	    var record = grid.store.getAt(rowIndex);
	});

	store.load();
	store.on('load',function(st,recs) {
        for (var i = 0; i < recs.length; i++) {
            var indoor = recs[i].get('isshow');
            if (indoor==1) {
                sm.selectRecords([recs[i]], true);
            }
        }
	});
	sm.on('rowselect', function(selMdl, rowIndex, rec) {
	    rec.set('isshow', 1);
	});
	sm.on('rowdeselect',function(selMdl,rowIndex,rec){
	    rec.set('isshow', 0); 
	});
});
</script>
</head>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(33416,user.getLanguage())+",javascript:location.href='/formmode/setup/browserAdd.jsp?modeid="+modeid+"',_top} " ;//新建浏览框
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_top} " ;//保存
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;//删除
RCMenuHeight += RCMenuHeightStep;

//共享
RCMenu += "{"+SystemEnv.getHtmlLabelName(119,user.getLanguage())+",javascript:doCustomSearchBatchSet(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

//批量
RCMenu += "{"+SystemEnv.getHtmlLabelName(27244,user.getLanguage())+",javascript:doBatchSet(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(30247,user.getLanguage())+",javascript:createmenu(),_self} " ;//创建查询菜单
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(30248,user.getLanguage())+",javascript:viewmenu(),_self} " ;//查看查询菜单地址
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(30245,user.getLanguage())+",javascript:createmenu1(),_self} " ;//创建监控菜单
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(30246,user.getLanguage())+",javascript:viewmenu1(),_self} " ;//查看监控菜单地址
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<form id="weaver" name="frmMain" method="post" action="/weaver/weaver.formmode.servelt.BrowserAction">
<input type="hidden" name="id" id="id" value="<%=id %>" />
<input type="hidden" name="modeid" id="modeid" value="<%=modeid %>"/>
<input type="hidden" name="action" id="action" value="customedit"/>
<input type="hidden" name="detailjson" id="detailjson" value=""/>
<table class="e8_tblForm">
<tr>
	<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(82014,user.getLanguage())%><!-- 自定义浏览框名称 --></td>
	<td class="e8_tblForm_field">
		<input type="text" name="customname" style="width:80%;" value="<%=customname %>"/> 
		<img src="/images/BacoError_wev8.gif"/>
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%><!-- 表单名称 --></td>
	<td class="e8_tblForm_field">
	    <BUTTON class="Browser" type="button" onClick="onShowFormSelect( formid, formidSpan)"  name=formidSelect></BUTTON>
	    <INPUT id="formid" type="hidden" name="formid" value="<%=formID %>">
		<span id="formidSpan"><%=formName %></span>
		<span id="formidCheckSpan" style="margin-left: 5px;"></span>
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(81366,user.getLanguage())%><!-- 固定查询条件 --></td>
	<td class="e8_tblForm_field">
		<textarea name="defaultsql" style="width:80%;height:50px;overflow:auto;"><%=defaultSql %></textarea>
		<div class="e8_label_desc"><%=SystemEnv.getHtmlLabelName(81388,user.getLanguage())%><!-- 表单主表表名的别名为t1，查询条件的格式为: t1.a = '1' and t1.b = '3' and t1.c like '%22%' 。 --></div>
	</td>
</tr>
<tr>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%><!-- 描述 --><div class="e8_label_desc"><%=SystemEnv.getHtmlLabelName(82015,user.getLanguage())%><!-- 描述自定义浏览框的用途。 --></div></td>
	<td class="e8_tblForm_field">
		<textarea name="customdesc" style="width:80%;height:50px;overflow:auto;"><%=customdesc %></textarea>
	</td>
</tr>
</table>
<div class="e8_forGridHidden">
	<select name="istitle" id="istitle" style="display: none;">
        <option value="1"><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><!-- 是 -->
        <option value="0"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><!-- 否 -->
    </select>
      <select name="isquery" id="isquery" style="display: none;">
        <option value="1"><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><!-- 是 -->
        <option value="0"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><!-- 否 -->
    </select>
    <select name="isorder" id="isorder" style="display: none;">
        <option value="1"><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><!-- 是 -->
        <option value="0"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><!-- 否 -->
    </select>
</div>

<div id="e8_ext_grid" class="e8_ext_grid">
	
</div>
</form>

<script type="text/javascript">
function submitData()
{
	var records = grid.getSelectionModel().getSelections();
	var json = [];
	Ext.each(records, function(item){
		  json.push(item.data);
	});
	document.weaver.detailjson.value=Ext.util.JSON.encode(json);
	if (<%=id==0%>) {
		document.weaver.action.value="customadd";
	}
	//var checkfields = "";
    	//checkfields = 'formid,customname';
	//if (check_form(frmMain,checkfields)){
        enableAllmenu();
		frmMain.submit();
    //}
}
function doback(){
	enableAllmenu();
	location.href="/formmode/browser/CustomBrowser.jsp?modeid=<%=modeid%>";
}
function onDelete(){
	document.weaver.action.value="customdelete";
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {//你确定要删除这条记录吗?
		enableAllmenu();
		frmMain.submit();
	}
}

function onShowModeSelect(inputName, spanName){
	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp");
	if (datas){
	    if(datas.id!=""){
		    $(inputName).val(datas.id);
			if ($(inputName).val()==datas.id){
		    	$(spanName).html(datas.name);
			}
	    }else{
		    $(inputName).val("");
			$(spanName).html("");
		}
	}
}

function doCustomSearchBatchSet(){
    if(confirm("<%=SystemEnv.getHtmlLabelName(31851,user.getLanguage())%>")){ //在此页面设置查看或监控权限后，模块中设置的共享或监控权限将不能访问对应的菜单页面
    	location.href="/formmode/search/CustomSearchShare.jsp?id=<%=id%>";
    }
    
}

function doBatchSet(){
    enableAllmenu();
    location.href="/formmode/batchoperate/ModeBatchSet.jsp?id=<%=id%>";
}

function createmenu(){
	var url = "/formmode/search/CustomSearchBySimple.jsp?customid=<%=id%>";
	window.open("/formmode/menu/CreateMenu.jsp?menuaddress="+escape(url));
}
function viewmenu(){
	var url = "/formmode/search/CustomSearchBySimple.jsp?customid=<%=id%>";
	prompt("<%=SystemEnv.getHtmlLabelName(28624,user.getLanguage())%>",url);//查看菜单地址
}

function createmenu1(){
	var url = "/formmode/search/CustomSearchBySimple.jsp?customid=<%=id%>&viewtype=3";
	window.open("/formmode/menu/CreateMenu.jsp?menuaddress="+escape(url));
}
function viewmenu1(){
	var url = "/formmode/search/CustomSearchBySimple.jsp?customid=<%=id%>&viewtype=3";
	prompt("<%=SystemEnv.getHtmlLabelName(28624,user.getLanguage())%>",url);//查看菜单地址
}

function onShowFormSelect(inputName, spanName){
	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/setup/FormBrowser.jsp");
	if (datas){
	    if(datas.id!=""){
		    $(inputName).val(datas.id);
			if ($(inputName).val()==datas.id){
		    	$(spanName).html(datas.name);
			}
	    }else{
		    $(inputName).val("");
			$(spanName).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
		}
	} 
}

function toformtab(formid){
	var height = document.body.clientHeight;
	var width = document.body.clientWidth;
	var parm = "&formid="+formid;
	if(formid=='') 
		parm = '';
	var url = "/workflow/form/addDefineForm.jsp?isFromMode=1"+parm;
	var handw = "dialogHeight="+height+";dialogWidth="+width;
	//window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+escape(url),window,handw);
	window.open(url);
}
</script>
</body>
</html>
