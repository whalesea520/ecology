
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@page import="weaver.formmode.service.ReportInfoService"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.workflow.workflow.BillComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
	if (!HrmUserVarify.checkUserRight("FORMMODEAPP:ALL", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
int id = Util.getIntValue(request.getParameter("id"), 0);

String titlename=SystemEnv.getHtmlLabelName(15101,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(16503,user.getLanguage());//报表：字段定义

String subCompanyIdsql = "SELECT b.subcompanyid FROM mode_Report a,modeTreeField b WHERE a.appid=b.id AND a.id="+id;
RecordSet recordSet = new RecordSet();
recordSet.executeSql(subCompanyIdsql);
int subCompanyId = -1;
if(recordSet.next()){
	subCompanyId = recordSet.getInt("subCompanyId");
}
String userRightStr = "FORMMODEAPP:ALL";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);
%>
<HTML>
	<HEAD>
<title></title>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET> 
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
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
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
	function formatStat(value, cellmeta, record, rowIndex, columnIndex, store){
		var checked;
		if (record.get('fieldhtmltype') == 1){ //单行文本
			if(record.get('fieldtype')==2 || record.get('fieldtype')==3 || record.get('fieldtype')==4){
				if(value==1){
					checked="checked='checked'";
				}else{
					checked='';
				}
				return "<input type='checkbox' class='checkboxcommon' onclick=commonCheckboxClick(this,"+record.id+","+rowIndex+",'isstat',false) "+checked+"></input>";
			}	
		}
	}
	function formatDborder(value){
		var record=dborderCombo.store.getById(value);
		if (typeof(record) == "undefined")
			return '<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>';//否
		else
			return record.get('text');
	}
	function formatDbordertype(value, m, record, rowIndex, colIndex){
		if(!record.get("ordercanedit"))return "";
		var dbordertype=dbordertypeCombo.store.getById(value);
		if (typeof(dbordertype) == "undefined")
			return '<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>';//否
		else
			return dbordertype.get('text');
	}
	
	var fm = Ext.form;
	var statCombo=new Ext.form.ComboBox({
        typeAhead: true,
        triggerAction: 'all',
        transform:'isstat',
        lazyRender:true,
        listClass: 'x-combo-list-small'
	});
	var dborderCombo=new Ext.form.ComboBox({
        typeAhead: true,
        triggerAction: 'all',
        transform:'dborder',
        lazyRender:true,
        listClass: 'x-combo-list-small'
	});
	var dbordertypeCombo=new Ext.form.ComboBox({
        typeAhead: true,
        triggerAction: 'all',
        transform:'dbordertype',
        lazyRender:true,
        listClass: 'x-combo-list-small'
	});
	
    sm = new Ext.grid.RowSelectionModel({
		handleMouseDown:Ext.emptyFn
	});
    
    var cm = new Ext.grid.LockingColumnModel([ 
        {
		    header: "<input type='checkbox' id='checkboxAll' onclick='selectAllFields(this)' style='margin:0 0 0 2px;height:13px;'/> <%=SystemEnv.getHtmlLabelName(24986 ,user.getLanguage())%>",//是否标题列
		    dataIndex: 'isshow',
		    width: 60,
		    renderer: formatIsShow,
		    locked: true
		}, {
		    header: "<%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%>",//表单字段
		    dataIndex: 'fieldname',
		    width: 150,
		    locked: true,
		    editor: new fm.TextField({
                allowBlank: false,
                readOnly:true
            })
		}, {
		    header: "<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>",//显示名称
		    dataIndex: 'fieldlabelname',
		    width: 150,
		    locked: true
		}, {
		    header: "<%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%>",//显示顺序
		    dataIndex: 'dsporder',
		    width: 150,
		    editor: new fm.TextField({
		        allowBlank: true,
		        regex: new RegExp(/^[+-]?\d+$/),
  				regexText: "<%=SystemEnv.getHtmlLabelName(82023,user.getLanguage())%>"//用户格式错误
		    })
		}, {
		    header: "<%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%>",//是否统计
		    dataIndex: 'isstat',
		    width: 150,
		    renderer: formatStat
		}, {
		    header: "<%=SystemEnv.getHtmlLabelName(17736,user.getLanguage())%>",//排序类型
		    dataIndex: 'dbordertype',
		    width: 100,
		    renderer: formatDbordertype,
		    editor: dbordertypeCombo
		}, {
		    header: "<%=SystemEnv.getHtmlLabelName(18559,user.getLanguage())%>",//排序关键字顺序
		    dataIndex: 'compositororder',
		    width: 120,
		    editor: new fm.TextField({
		        allowBlank: true,
		        regex: new RegExp(/^[+-]?\d+$/),
  				regexText: "<%=SystemEnv.getHtmlLabelName(82023,user.getLanguage())%>"//用户格式错误
		    })
		}
	]);

   store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
        	method:"post",
        	url: '/weaver/weaver.formmode.servelt.ReportInfoAction?action=getFieldsJSON&id=<%=id%>'
   		}),

   		reader: new Ext.data.JsonReader({
             root: 'result',
             totalProperty: 'totalCount',
             fields: ['fieldid', 'fieldname', 'fieldhtmltype', 'fieldtype', 'fieldlabel', 'fieldlabelname','isshow', 'isstat', 'dborder', 'dsporder', 'dbordertype','compositororder','ordercanedit']
   		}),
        remoteSort: true
   });
	
   grid = new Ext.grid.LockingEditorGridPanel({
    	store: store,
    	cm: cm,
    	sm: sm,
    	region:'center',
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
    		 'beforeedit' : function(e) {
				  var record = e.record;
				  var canedit = record.data.ordercanedit;
				  var field = e.field;
				  if(field=="dbordertype"&&!canedit){
					  return false;
				  }
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
        //检查所有checkbox是否勾中
		checkSelectAll();
    });
    
    var viewport = new Ext.Viewport({
		layout: 'border',
		items: [grid]
	});
})

function commonCheckboxClick(obj,recordid,rowIndex,dataIndex,isSelectRow){
	var record=store.getById(recordid);
	if(jQuery(obj).is(":checked")){
		record.set(dataIndex,1);
		if(isSelectRow){
			sm.selectRow(rowIndex,true);
		}
	}else{
		record.set(dataIndex,0);
		if(isSelectRow){
			sm.deselectRow(rowIndex);
		}
	}
}
//检查所有checkbox是否勾中
function checkSelectAll(){
	var isSelectAll = true;
	Ext.select("*[name=checkboxIsTitle]").each(function(c){
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
			r.set("isshow", 0);
			sm.deselectRow(r.id);
		});
	}
}
</script>
</HEAD>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	if(operatelevel>0){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
	RCMenu += "{"+SystemEnv.getHtmlLabelName(221,user.getLanguage())+",javascript:onPreview(),_self} " ;//预览
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<BODY>
<div class="e8_forGridHidden">
	<select name="isstat" id="isstat" style="display: none;">
        <option value="1"><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><!-- 是 -->
        <option value="0"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><!-- 否 -->
    </select>
    <select name="dborder" id="dborder" style="display: none;">
        <option value="1"><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><!-- 是 -->
        <option value="0"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><!-- 否 -->
    </select>
	<select name="dbordertype" id="dbordertype" style="display: none;">
		<option value="n"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><!-- 否 -->
        <option value="a"><%=SystemEnv.getHtmlLabelName(339,user.getLanguage())%></option><!-- 升序 -->
        <option value="d"><%=SystemEnv.getHtmlLabelName(340,user.getLanguage())%></option><!-- 降序 -->
    </select>
</div>
</BODY>
<script>
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
	    url: '/weaver/weaver.formmode.servelt.ReportInfoAction?action=formfieldmanager',
	    data: {jsonFields: jsonFields, id:<%=id%>},
	    success: function(res) {
	    	myMask.hide();
	    	location.reload();
	    }
	});
}

function onPreview(){
	var url = "/formmode/report/ReportCondition.jsp?id=<%=id%>";
	window.open(url);
}
</script>
</HTML>