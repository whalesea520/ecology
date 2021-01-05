<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.formmode.service.BrowserInfoService"%>
<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@page import="org.apache.lucene.util.StringHelper"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.workflow.workflow.BillComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	if (!HrmUserVarify.checkUserRight("FORMMODEAPP:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
int id = Util.getIntValue(request.getParameter("id"), 0);

String subCompanyIdsql = "SELECT b.subcompanyid,a.formid FROM mode_custombrowser a,modeTreeField b WHERE a.appid=b.id AND a.id="+id;
RecordSet recordSet = new RecordSet();
recordSet.executeSql(subCompanyIdsql);
int subCompanyId = -1;
String formID="0";
if(recordSet.next()){
	subCompanyId = recordSet.getInt("subCompanyId");
	formID=Util.null2String(recordSet.getString("formid"));
}
String userRightStr = "FORMMODEAPP:ALL";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);

boolean isVirtualForm = VirtualFormHandler.isVirtualForm(formID);	//是否是虚拟表单的浏览框

String titlename=SystemEnv.getHtmlLabelName(32306,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(16503,user.getLanguage());//浏览框:字段定义
%>
<html>
<head>
<title></title>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET> 
<script language=javascript src="/js/weaver_wev8.js"></script>
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
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
<style>
html body{
	width:100%;
	height:100%;
}
.e8_forGridHidden{
	height: 10px;
}
/*Ext 表格对应的样式(框架)*/
.x-border-layout-ct{
	background-color: #fff;
}
.x-panel-body-noheader{
	border: none;
}
.x-panel-tl{
	border-bottom-width: 0px;
}
.x-panel-ml{
	padding-left: 0px;
	background-image: none;
}
.x-panel-mc{
	padding-top: 0px;
	background-color: #fff;
}
.x-panel-mr{
	padding-right: 0px;
	background-image: none;
}
.x-panel-nofooter .x-panel-bc{
	height: 0px;
	overflow:hidden;
}

/*Ext 表格对应的样式(表格)*/
.x-grid-panel .x-panel-mc .x-panel-body{
	border: none; 
}
.x-grid3-header{
	background: none;
	padding-left: 3px;
	background-color: #E5E5E5;
}
.x-grid3-hd-inner{
	background-image: none;
	background-color:#e5e5e5;
}
.x-grid3-hd-row td{
	background-color: #E5E5E5;
	border-left: none;
	border-right-color: #d0d0d0;
}
.x-grid3-hd-row td .x-grid3-hd-inner{
	color: #333;
}
.x-grid3-row-table td{
	
}
.x-grid3-header-inner{
	background-color: #E5E5E5;
}
td.x-grid3-hd-over .x-grid3-hd-inner{
	background-image: none;
	background-color: #E5E5E5;
}
.x-grid3-hd-over .x-grid3-hd-btn{
	display: none;
}
.x-grid3-scroller{

}
.x-grid3-locked .x-grid3-scroller{
	border-right-color: #d0d0d0;
}
.x-grid3-body .x-grid3-td-checker{
	padding-left: 3px;
	background: none;
}
.x-grid3-cell-inner{
	padding: 1px 3px 1px 5px;
}
.x-grid3-row, .x-grid3-row-selected{
	/*background-color: #fff !important;*/
	border-top: 1px solid #fff;
	border-bottom: 1px solid #ededed;
	border-left: 0px;
	border-right: 0px;
}

.x-grid3-body .x-grid3-row-selected .x-grid3-td-checker{
	background-image: none;
}
.x-panel-bc, .x-panel-bl, .x-panel-br{
	background-image:none;
}
.x-grid3-row-checker{
	height:17px;
}
.x-grid3-hd-inner{
	padding-left: 0;
}
.checkboxcommon{
	height:12px;
	line-height:12px;
	padding-left:5px;
}
</style>
<script>
Ext.override(Ext.grid.ColumnModel,{
	isLocked :function(colIndex){
		if(this.config[colIndex] instanceof Ext.grid.CheckboxSelectionModel){return true;}
		return this.config[colIndex].locked === true;
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

var ispkstore=new Ext.data.SimpleStore({
		id:0,
		fields:['value', 'text'],
		data: [['0','<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>'],['1','<%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>']] //否  是
	});
var isstore=new Ext.data.SimpleStore({
		id:0,
		fields:['value', 'text'],
		data: [['0','<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>'],['1','<%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>']] //否  是
	});
var istitlestore=new Ext.data.SimpleStore({
		id:0,
		fields:['value', 'text'],
		data: [['0','<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>'],['1','<%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>'],['2','<%=SystemEnv.getHtmlLabelName(124934,user.getLanguage())%>']] //否  是 无链接
	});
var orderTypeStore=new Ext.data.SimpleStore({
	id:0,
	fields:['value', 'text'],//是,默认升序,默认降序
	data: [['n','--'],['a','<%=SystemEnv.getHtmlLabelName(82027,user.getLanguage())%>'],['d','<%=SystemEnv.getHtmlLabelName(82028,user.getLanguage())%>']]
});

var grid;
var store;
var sm;
Ext.onReady(function(){
	
	//格式化是否标题列表
	function formatIsShow(value, cellmeta, record, rowIndex, columnIndex, store){
		var checked;
		if(value==1){
			sm.selectRow(rowIndex,true);
			checked="checked='checked'";
		}else{
			sm.deselectRow(rowIndex);
			checked='';
		}
		return "<input type='checkbox' class='checkboxcommon' name='checkboxIsTitle' onclick=\"commonCheckboxClick(this,"+record.id+","+rowIndex+",'isshow',true);checkSelectAll();\" "+checked+"></input>";
	};
	
	function formatTitle(value, m, record, rowIndex, colIndex){
		if (record.get('fieldhtmltype') != 1) 
			return "";
		var istitle=istitlestore.getById(value);
		if (typeof(istitle) == "undefined")
		     return '<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>';//否
		else
		    return istitle.get('text'); 
	}
	
	function formatQuickSearch(value, m, record, rowIndex, colIndex){
		if (record.get('fieldhtmltype') == 1||record.get('fieldhtmltype') == 2 ) {
			var isquicksearch=isstore.getById(value);
			if (typeof(isquicksearch) == "undefined")
			     return '<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>';//否
			else
			    return isquicksearch.get('text'); 
		}else{
			return "";
		}
	}
	
	function formatPk(value, m, record, rowIndex, colIndex, store){
		if (record.get('fieldhtmltype') == 1) {	
			var ispk=ispkstore.getById(value);
			if (typeof(ispk) == "undefined")
			     return '<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>';//否
			else
			    return ispk.get('text'); 
		}else{
			return "";
		}
	}
	
	function formatQuery(value, cellmeta, record, rowIndex, columnIndex, store){
		var checked;
		if(value==1){
			checked="checked='checked'";
		}else{
			checked='';
		}
		return "<input type='checkbox' class='checkboxcommon' onclick=commonCheckboxClick(this,"+record.id+","+rowIndex+",'isquery',false) "+checked+"></input>";
	}
	
	//格式化是否排序字段
	function formatIsOrder(value, cellmeta, record, rowIndex, columnIndex, store){
		if(record.get('fielddbtype') == 'text'||record.get('fielddbtype') == 'clob')return "";
		var checked;
		if(value==1){
			checked="checked='checked'";
		}else{
			checked='';
		}
		return "<input type='checkbox' class='checkboxcommon' onclick=commonCheckboxClick(this,"+record.id+","+rowIndex+",'isorder',false) "+checked+"></input>";
	};
	
	//格式化排序类型
	function formatOrderType(value, m, record, rowIndex, colIndex){
		var isorder = record.get('isorder');
		if(isorder!=1){
			return '';
		}else{
			var orderType=orderTypeStore.getById(value);
			if (typeof(orderType) == "undefined")
				return '';
			else
				return orderType.get('text');
		}
	};
	//格式化排序优先级字段
	function formatOrdernum(value, m, record, rowIndex, colIndex){
		var isorder = record.get('isorder');
		if(isorder!=1){
			return '';
		}else{
			return value;
		}
	};
	
	//下拉框条件转换
	function formatConditionTrans(value, m, record, rowIndex, colIndex){
		if (record.get('fieldhtmltype') == 5||record.get('fieldhtmltype') == 8){ 
			if (value==0||value == ""){
				return '<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>';//否
			}else{
				return '<%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>';//是
			}
		}else{
			return "";
		}
	}
	
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
	
	var contransCombo = new Ext.form.ComboBox({//是否转换  条件转换
        typeAhead: true,
        triggerAction: 'all',
        transform:'conditionTransition',
        lazyRender:true,
        listClass: 'x-combo-list-small'
	});
	
	sm = new Ext.grid.RowSelectionModel({
		handleMouseDown:Ext.emptyFn
	});
	
	var fm = Ext.form;
	
	var cm = new Ext.grid.LockingColumnModel([
	{
	    header: "<input type='checkbox' id='checkboxAll' onclick='selectAllFields(this)' style='margin:0 0 0 2px;height:13px;'/> <%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%>",//是否标题列
	    dataIndex: 'isshow',
	    width: 60,
	    renderer: formatIsShow,
	    locked: true
	}, {
	    header: "<%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%>",//字段
	    dataIndex: 'fieldname',
	    width: 150,
	    locked: true,
	    editor: new fm.TextField({
           allowBlank: false,
           readOnly:true
        })
	}, {
	    header: "<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>",//名称
	    dataIndex: 'fieldlabelname',
	    width: 100,
	    locked: true
	}, {
	    header: "<%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%>",//显示顺序
	    dataIndex: 'showorder',
	    width: 70,
	    editor: new Ext.form.TextField({                
		    allowBlank: true,
		    regex: new RegExp(/^[+-]?\d+$/),
     		regexText: "<%=SystemEnv.getHtmlLabelName(82023,user.getLanguage())%>"//用户格式错误
		})
	}, {
	    header: "<%=SystemEnv.getHtmlLabelName(82024,user.getLanguage())%>",//链接字段
	    dataIndex: 'istitle',
	    width: 80,
	    renderer: formatTitle
	},{
	    header: "<%=SystemEnv.getHtmlLabelName(82025,user.getLanguage())%>",//快捷搜索字段
	    dataIndex: 'isquicksearch',
	    width: 80,
	    renderer: formatQuickSearch
	},{
	    header: "<%=SystemEnv.getHtmlLabelName(338,user.getLanguage())%>",//是否排序
	    dataIndex: 'isorder',
	    width: 60,
	    renderer: formatIsOrder
	}, {
	    header: "<%=SystemEnv.getHtmlLabelName(17736,user.getLanguage())%>",//排序类型
	    dataIndex: 'ordertype',
	    renderer: formatOrderType,
	    width: 100
	}, {
	    header: "<%=SystemEnv.getHtmlLabelName(82054,user.getLanguage())%>",//默认排序优先级
	    dataIndex: 'ordernum',
	    renderer: formatOrdernum,
	    width: 100
	}, {
	    header: "<%=SystemEnv.getHtmlLabelName(19509,user.getLanguage())%>%",//显示列宽
	    dataIndex: 'colwidth',
	    editor: new fm.NumberField({
		        allowBlank: true,
		        allowNegative: false,
		        maxValue: 100000
		    }),
	    width: 80
	},{
	    header: "<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>",//查询条件?
	    dataIndex: 'isquery',
	    width: 80,
	    renderer: formatQuery
	}, {
	    header: "<%=SystemEnv.getHtmlLabelName(82026,user.getLanguage())%>",//查询显示顺序
	    dataIndex: 'queryorder',
	    width: 110,
	    editor: new Ext.form.TextField({                
		    allowBlank: true,
		    regex: new RegExp(/^[+-]?\d+$/),
     		regexText: "<%=SystemEnv.getHtmlLabelName(82023,user.getLanguage())%>"           //用户格式错误
		})
	},{
		    header: "<%=SystemEnv.getHtmlLabelName(127030,user.getLanguage())%>",//选择框多选
		    dataIndex: 'conditionTransition',
            width:60 ,
            renderer:formatConditionTrans,
            editor:contransCombo
	},{
	    header: "<%=SystemEnv.getHtmlLabelName(82103,user.getLanguage())%>",	//主键字段
	    dataIndex: 'ispk',
	    width: 80,
	    <%if(isVirtualForm){%>
	    hidden:true,
	    <%}%>
	    renderer: formatPk
	}
	
	
	]);

	store = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
      		method:"post",
       		url: '/weaver/weaver.formmode.servelt.BrowserAction?action=getFieldsJSON&id=<%=id%>'
		}),
		reader: new Ext.data.JsonReader({
			root: 'result',
			totalProperty: 'totalCount',
			fields: ['fieldid', 'fieldhtmltype', 'fieldtype', 'fielddbtype', 'fieldname', 'fieldlabel', 'fieldlabelname', 'isquery', 'isshow', 'showorder', 'queryorder', 'istitle','isquicksearch', 'colwidth', 'isorder','ordertype','ordernum','conditionTransition', 'ispk']
        }),
        remoteSort: true
	});
	
	grid = new Ext.grid.LockingEditorGridPanel({
	    store: store,
	    cm: cm,
	    sm: sm,
	    region: 'center',
	    monitorResize:true,
    	autoScroll:true,
	    loadMask: true,
	    frame: true,
	    clicksToEdit: 1,
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
	    },
	    listeners : {
			'afteredit' : function(e) {
				if (e.column == 4 && (e.value == 1||e.value == 2)) { //如果标题字段为是的时候，将其他行标题字段都标记为否，因为标题字段有且只能有一个
					var columnIndex = e.column;
					var rowIndex = e.row;
					var store_ = e.grid.store;
					var flag = true;
					for (var i = 0 ; i < store_.getCount() ; i++) {
						var record = store_.getAt(i);
						var istitle=record.get("istitle");
						var  tempIsquicksearch = record.get("isquicksearch");
						if(tempIsquicksearch == "1"){
							    flag = false;
						}
						if(i != rowIndex&&(istitle=="1"||istitle=="2" )){
							record.set("istitle",0);						
						}
					}
					if(flag){
					    store_.getAt(rowIndex).set("isquicksearch",1);
					}
					var record = store_.getAt(rowIndex);
					record.set("isshow", 1);
					sm.selectRow(record.id, true);
				}
				if(e.column == 13 && e.value == 1){//只能有一个主键字段，并且设置了标题字段为是的时候不能设置主键字段
					var columnIndex = e.column;
					var rowIndex = e.row;
					var store_ = e.grid.store;
					for (var i = 0 ; i < store_.getCount() ; i++) {
						var record = store_.getAt(i);
						var ispk=record.get("ispk");
						if(i != rowIndex&&ispk=="1"){
						record.set("ispk",0);
						}
					}
				}
			},
			'beforeedit' : function(e) {
			    var grid = e.grid;
			    var record = e.record;
			    var rowIndex = e.row;
			    var columnIndex = e.column;
			    if(columnIndex==6){
			    	if(record.get('fielddbtype')=='text'||record.get('fielddbtype') == 'clob') return false;
			    }else if(columnIndex==11){
			    	if (record.get('isquery') != 1){
			    		return false;
			    	}
			    }else if(columnIndex==12){
			    	if (record.get('fieldhtmltype') == 5||record.get('fieldhtmltype') == 8){ //下拉框  公共选择项
			    	
			    	}else{
			    		return false;
			    	}
			    }
			    dynamicSetEditor(grid, record, rowIndex, columnIndex, e);
			}
		}
	});
	
	grid.on("cellclick", function(grid, rowIndex, columnIndex, e){
	    var record = grid.store.getAt(rowIndex);
	    dynamicSetEditor(grid, record, rowIndex, columnIndex, e);
	});
	
	function dynamicSetEditor(grid, record, rowIndex, columnIndex, e){
		if(columnIndex==4){
				if (record.get('fieldhtmltype') == 1) {  //单行文本
			  	 	if(record.get('fieldtype') == 1 || record.get('fieldtype') == 2 || record.get('fieldtype') == 3 || record.get('fieldtype') == 4 || record.get('fieldtype') == 5 ) {
			  	    	grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                  		 	typeAhead: true,
                  		  	triggerAction: 'all',
                  		 	store:istitlestore,
                  		  	mode:'local',
                  		  	emptyText:'',
                  		  	valueField:'value',
                  		  	displayField:'text',
                  		 	selectOnFocus:true,
                  		  	listClass: 'x-combo-list-small'})));
                  	} else {
                  		e.cancel = true;
                  		grid.getColumnModel().setEditor(columnIndex, null);
                  	}
                 }else{
                 	e.cancel = true;
					grid.getColumnModel().setEditor(columnIndex, null);
				 }
		}else if(columnIndex==5){
				if (record.get('fieldhtmltype') == 1 || record.get('fieldhtmltype') == 2) {  //单行文本或多行文本
			  	 	if(record.get('fieldtype') == 1 || record.get('fieldtype') == 2 || record.get('fieldtype') == 3 || record.get('fieldtype') == 4 || record.get('fieldtype') == 5|| record.get('fieldhtmltype') == 2  ) {
			  	    	grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                  		 	typeAhead: true,
                  		  	triggerAction: 'all',
                  		 	store:isstore,
                  		  	mode:'local',
                  		  	emptyText:'',
                  		  	valueField:'value',
                  		  	displayField:'text',
                  		 	selectOnFocus:true,
                  		  	listClass: 'x-combo-list-small'})));
                  	} else {
                  		e.cancel = true;
                  		grid.getColumnModel().setEditor(columnIndex, null);
                  	}
                 }else{
                 	e.cancel = true;
					grid.getColumnModel().setEditor(columnIndex, null);
				 }
		}else if (columnIndex==7) {
			if (record.get('isorder') == 1) {
				grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(
						new Ext.form.ComboBox({
	             		 	typeAhead: true,
	             		  	triggerAction: 'all',
	             		 	store:orderTypeStore,
	             		  	mode:'local',
	             		  	emptyText:'',
	             		  	valueField:'value',
	             		  	displayField:'text',
	             		 	selectOnFocus:true,
	             		  	listClass: 'x-combo-list-small'})
				));
			}else {
	            e.cancel = true;
	            grid.getColumnModel().setEditor(columnIndex, null);
	        }
		}else if (columnIndex==8) {
			if (record.get('isorder') == 1 && (record.get('ordertype')=='a' || record.get('ordertype')=='d')) {
				grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.TextField({
		        	allowBlank: true,
		        	regex: new RegExp(/^[+-]?\d+$/),
	    				regexText: "<%=SystemEnv.getHtmlLabelName(82023,user.getLanguage())%>"//用户格式错误
		    	})));
			}else {
	            e.cancel = true;
	            grid.getColumnModel().setEditor(columnIndex, null);
	        }
		}else if(columnIndex==13){
				if (record.get('fieldhtmltype') == 1) {  //单行文本
			  	 	if(record.get('fieldtype') == 1 || record.get('fieldtype') == 2 || record.get('fieldtype') == 3 || record.get('fieldtype') == 4 || record.get('fieldtype') == 5|| record.get('fieldhtmltype') == 2  ) {
			  	    	grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                  		 	typeAhead: true,
                  		  	triggerAction: 'all',
                  		 	store:ispkstore,
                  		  	mode:'local',
                  		  	emptyText:'',
                  		  	valueField:'value',
                  		  	displayField:'text',
                  		 	selectOnFocus:true,
                  		  	listClass: 'x-combo-list-small'})));
                  	} else {
                  		e.cancel = true;
                  		grid.getColumnModel().setEditor(columnIndex, null);
                  	}
                 }else{
                 	e.cancel = true;
					grid.getColumnModel().setEditor(columnIndex, null);
				 }
		}
	}
	
	store.load();
	store.on('load',function(st,recs) {
        for (var i = 0; i < recs.length; i++) {
            var indoor = recs[i].get('isshow');
            if (indoor==1) {
                sm.selectRecords([recs[i]], true);
            }
        }
        //检查所有checkbox是否勾中
		checkSelectAll();
    });
	var viewport = new Ext.Viewport({
		layout: 'border',
		items: [grid]
	});
});

function commonCheckboxClick(obj,recordid,rowIndex,dataIndex,isSelectRow){
	var record=store.getById(recordid);
	var istitle=record.get("istitle");
	if(jQuery(obj).is(":checked")){
		record.set(dataIndex,1);
		if(isSelectRow){
			sm.selectRow(rowIndex,true);
		}
		if(dataIndex=='isorder'){
			record.set('ordertype','n');
		}
	}else{
		if(dataIndex=="isshow" && (istitle=="1"||istitle=="2")){ //有链接字段，不能不选
			Dialog.alert("该字段是链接字段，必须设置成显示字段");
			jQuery(obj).attr("checked",true);
		} else {
			record.set(dataIndex,0);
			if(isSelectRow){
				sm.deselectRow(rowIndex);
			}
			if(dataIndex=='isorder'){
				record.set('ordertype','');
				record.set('ordernum','');
			}
		}
	}
}
//检查所有checkbox是否勾中
function checkSelectAll(){
	var isSelectAll = true;
	Ext.select("*[name=checkboxIsTitle]").each(function(c){;
		if(!Ext.getDom(c).checked){
			isSelectAll = false;
			return false;
		}
	});
	Ext.getDom("checkboxAll").checked = isSelectAll;
}
//全选checkbox
function selectAllFields(o){
	if(o.checked){
		grid.store.each(function(r){
			r.set("isshow", 1);
			sm.selectRow(r.id, true);
		});
	}else{
		grid.store.each(function(r){
			var istitle=r.get("istitle");
			if(istitle=="1"||istitle=="2"){ //有链接字段，不能不选
				
			} else {
				r.set("isshow", 0);
				sm.deselectRow(r.id);
			}
		});
	}
}
</script>
</head>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(operatelevel>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_top} " ;//保存
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>

<div class="e8_forGridHidden">
	<select name="istitle" id="istitle" style="display: none;">
        <option value="1"><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><!-- 是 -->
        <option value="0"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><!-- 否 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(124934,user.getLanguage())%></option><!-- 无链接 -->
    </select>
	<select name="isquicksearch" id="isquicksearch" style="display: none;">
        <option value="1"><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><!-- 是 -->
        <option value="0"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><!-- 否 -->
    </select>
      <select name="isquery" id="isquery" style="display: none;">
        <option value="1"><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><!-- 是 -->
        <option value="0"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><!-- 否 -->
    </select>
    <select name="conditionTransition" id="conditionTransition" style="display: none;">
        <option value="1"><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><!-- 是 -->
        <option value="0"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><!-- 否 -->
    </select>
    <select name="ispk" id="ispk" style="display: none;">
        <option value="1"><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><!-- 是 -->
        <option value="0"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><!-- 否 -->
    </select>
</div>
</body>
<script type="text/javascript">
function submitData(){
    rightMenu.style.visibility = "hidden";
	var myMask = new Ext.LoadMask(Ext.getBody());
	var records = store.getModifiedRecords();
	var datas = [];
	Ext.each(records, function(item){
		datas.push(item.data);
	});

    var jsonFields = Ext.util.JSON.encode(datas);
	myMask.show();
    $.ajax({
    	type: 'POST',
    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	    url: '/weaver/weaver.formmode.servelt.BrowserAction?action=formfieldmanager',
	    data: {jsonFields: jsonFields, id:<%=id%>},
	    success: function(res) {
	    	myMask.hide();
	    	parent.location.reload();
	    }
	});
}
</script>
</html>
