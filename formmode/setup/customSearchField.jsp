<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.formmode.service.CustomSearchService"%>
<%@page import="org.apache.lucene.util.StringHelper"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.workflow.workflow.BillComInfo"%>
<%@ page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<%
	if (!HrmUserVarify.checkUserRight("FORMMODEAPP:ALL", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%

int id = Util.getIntValue(request.getParameter("id"), 0);
int formID = 0;
int modeID = 0;
rs.execute("select a.modeid,a.formid  from mode_customsearch a where a.id="+id);
if(rs.next()){
    formID=Util.getIntValue(rs.getString("formid"),0);
    modeID=Util.getIntValue(rs.getString("modeid"),0);
}
int isVirtualForm = 1;//是否是虚拟表单==0
String keyfield = "";
if(VirtualFormHandler.isVirtualForm(formID)){
	isVirtualForm = 0;
	rs.executeQuery(" select vprimarykey from modeformextend where formid = ?  ", formID);
	if(rs.next()) {
		keyfield = Util.null2String(rs.getString("vprimarykey"));
	}
} else {
	keyfield = "dataid";
}
//QC:365739 勾选无权限列表时批量修改不显示
String norightlist=Util.toScreen(Util.null2String(request.getParameter("norightlist")),user.getLanguage());
String titlename=SystemEnv.getHtmlLabelName(82051,user.getLanguage());//查询字段定义

String subCompanyIdsql = "SELECT b.subcompanyid FROM mode_customsearch a,modeTreeField b WHERE a.appid=b.id AND a.id="+id;
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
<html>
<head>
	<title></title>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET> 
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="/formmode/js/ext/resources/css/ext-all_wev8.css" />
<link rel="stylesheet" type="text/css" href="/formmode/js/ext/ux/css/columnLock_wev8.css"/>
<script type="text/javascript">
	/**定义js中一些中文label，改用标签显示**/
	var label = {"showmethod":"<%=SystemEnv.getHtmlLabelName(82403,user.getLanguage())%>"//显示方式转换
	};
</script>
<script type="text/javascript" src="/formmode/js/ext/adapter/ext/ext-base_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/ext/ext-all_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/ext/ux/miframe_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/ext/ux/iconMgr_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/ext/ux/columnLock_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/ext/ux/CardLayout_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/ext/ux/Wizard_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/ext/ux/showmethod_wev8.js"></script>
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

.x-grid3-col .x-grid3-col-6{
	width: 200px;
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
var mid = <%=modeID%>;
var isVir = <%=isVirtualForm%>;

Ext.override(Ext.grid.ColumnModel,{
	isLocked :function(colIndex){
		if(this.config[colIndex] instanceof Ext.grid.CheckboxSelectionModel){return true;}
		return this.config[colIndex].locked === true;
	}
});
var isKeyStore=new Ext.data.SimpleStore({
	id:0,
	fields:['value', 'text'],//否，是
	data: [['0','<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>'],['1','<%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>']]
});
var isTitleStore=new Ext.data.SimpleStore({
	id:0,
	fields:['value', 'text'],//否,表单建模,工作流,自定义
	data: [['0','<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>'],['1','<%=SystemEnv.getHtmlLabelName(30235,user.getLanguage())%>'],['2','<%=SystemEnv.getHtmlLabelName(26361,user.getLanguage())%>'],['3','<%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%>']]
});

var isOrdreFieldStore=new Ext.data.SimpleStore({
	id:0,
	fields:['value', 'text'],//否，是,默认升序,默认降序
	data: [['0','<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>'],['3','<%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>'],['1','<%=SystemEnv.getHtmlLabelName(82027,user.getLanguage())%>'],['2','<%=SystemEnv.getHtmlLabelName(82028,user.getLanguage())%>']]
});
var orderTypeStore=new Ext.data.SimpleStore({
	id:0,
	fields:['value', 'text'],//是,默认升序,默认降序
	data: [['n','--'],['a','<%=SystemEnv.getHtmlLabelName(82027,user.getLanguage())%>'],['d','<%=SystemEnv.getHtmlLabelName(82028,user.getLanguage())%>']]
});
var showmethodStore = new Ext.data.SimpleStore({
	id:0,
	fields: ['value', 'text'], 
	data: [['1',''],['0','<%=SystemEnv.getHtmlLabelName(82052,user.getLanguage())%>']] //转换
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
var sm;
var lastlinkurl;
Ext.onReady(function(){
	
	//格式化是否排序字段
	function formatIsOrder(value, cellmeta, record, rowIndex, columnIndex, store){
	    if(record.get('fieldname') == '<%=keyfield%>'){
	       return '';
	    }
		if(record.get('canorder') == 'false')return "";
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
	//格式化是否统计字段
	function formatIsSum(value, m, record, rowIndex, colIndex){
		if (record.get('fieldhtmltype') == 1){ //单行文本
    		if(record.get('fieldtype')==2 || record.get('fieldtype')==3 || record.get('fieldtype')==4 || record.get('fieldtype')==5){
    			var record=sumCombo.store.getById(value);
				if (typeof(record) == "undefined")
					return '<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>';//否
				else
					return record.get('text');
    		}
		}else{
			return "";
		}
	};
	//格式化是否分组字段
	function formatIsGroup(value, m, record, rowIndex, colIndex){
		if (record.get('fieldhtmltype') == 5||record.get('fieldhtmltype') == 8){ //选择框
			if(record.get('viewtype')!=1){
				var record=groupCombo.store.getById(value);
				if (typeof(record) == "undefined")
					return '<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>';//否
				else
					return record.get('text');
			}
		}else{
			return "";
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
	
	//格式化字段名称
	function formatFieldlabelname(value, cellmeta, record, rowIndex, columnIndex, store){
		var viewtype=record.get('viewtype');
		var showValue=value;
		if(viewtype==1){
			showValue+="(<%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%>)";//明细表
		}
		return showValue;
	};
	
	//格式化是否标题字段
	function formatIsTitle(value, m, record, rowIndex, colIndex){
		var fieldhtmltype = record.get('fieldhtmltype');
		var fieldtype = record.get('fieldtype');
		var canSetTitle = false;
		
		if(fieldhtmltype == 1 || fieldhtmltype ==5 || fieldhtmltype ==8){
			canSetTitle = true;
		}else if(fieldhtmltype == 3 && fieldtype != 2 && fieldtype != 19 && !checkMultiBrowser(fieldtype)){
			canSetTitle = true;
		}
		if(!canSetTitle){
			return "";
		}
		var isTitle=isTitleStore.getById(value);
		if (typeof(isTitle) == "undefined")
		     return '<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>';
		else
		    return isTitle.get('text');
	};
	
	//格式化是否查询字段
	function formatIsQuery(value, cellmeta, record, rowIndex, columnIndex, store){
	    if(record.get('fieldname') == 'dataid'){
	       return '';
	    }
		var checked;
		if(value==1){
			checked="checked='checked'";
		}else{
			checked='';
		}
		return "<input type='checkbox' class='checkboxcommon' onclick=commonCheckboxClick(this,"+record.id+","+rowIndex+",'isquery',false) "+checked+"></input>";
    };
    //格式化是否高级查询字段
	function formatIsAdvancedQuery(value, cellmeta, record, rowIndex, columnIndex, store){
	    if(record.get('fieldname') == 'dataid'){
	       return '';
	    }
		var checked;
		if(value==1){
			checked="checked='checked'";
		}else{
			checked='';
		}
		return "<input type='checkbox' class='checkboxcommon' onclick=commonCheckboxClick(this,"+record.id+","+rowIndex+",'isadvancedquery',false) "+checked+"></input>";
    };
    function ismaplocationTrans(value, cellmeta, record, rowIndex, columnIndex, store){
	    if(record.get('fieldhtmltype') == '1'&&record.get('fieldtype')=='1'){
	    
	    }else{
	    	return '';
	    }
	    var checked;
		if(value==1){
			checked="checked='checked'";
		}else{
			checked='';
		}
		return "<input type='checkbox' class='checkboxcommon' onclick=commonCheckboxClick(this,"+record.id+","+rowIndex+",'ismaplocation',false) "+checked+"></input>";
    };
    //格式化是否链接字段
	function formatIsHref(value){
		var record=hrefCombo.store.getById(value);
		if (typeof(record) == "undefined")
			return '<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>';//否
		else
			return record.get('text');
    };
	//格式化是否browser字段
	function formatIsBrowser(value){
		var record=browserCombo.store.getById(value);
		if (typeof(record) == "undefined")
			return '<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>';//否
		else
			return record.get('text');
	};
	//格式化显示方式字段
	function formatIsShowMethod(value){
		if(!value)value=-1;
		if(showMethodCombo.store.getById(value)==undefined)
			return;
		var record=showMethodCombo.store.getById(value);
		return record.get('text');
	};
	//格式化是否关键字查询字段
	function formatIsKey(value, m, record, rowIndex, colIndex){
		if (record.get('fieldhtmltype') != 1) 
			return "";
		var isKey=isKeyStore.getById(value);
		if (typeof(isKey) == "undefined")
		     return '<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>';//否
		else
		    return isKey.get('text'); 
	}
	//格式化是否转换字段
	function showmethodRender(value, m, record, rowIndex, colIndex){
		var str="";
		if (value == 1) 
			str = "<%=SystemEnv.getHtmlLabelName(82052,user.getLanguage())%>" ;//转换
		return str;
	}
	function editableRender(value, cellmeta, record, rowIndex, columnIndex, store){
		var fieldid = record.get('fieldid');
		var fieldhtmltype = record.get('fieldhtmltype');
		var fieldtype = record.get('fieldtype');
		var canSetEdit = false;
		
		if(<%= isVirtualForm %> == 0){
			return "";
		}
		if(fieldid<0){
			canSetEdit = false;
		}else if(fieldhtmltype == '1' || fieldhtmltype == '4' || fieldhtmltype == '5'){//单行文本
	    	canSetEdit = true;
		}else if(fieldhtmltype=='2' && fieldtype == '1'){//多行文本
			canSetEdit = true;
		}else if(fieldhtmltype=='3'){
			if(fieldtype == '2' || fieldtype == '19'){//日期
				canSetEdit = true;
			}else if(fieldtype == '1' || fieldtype == '17' || fieldtype == '165' || fieldtype == '166'){//人员
				canSetEdit = true;
			}else if(fieldtype == '4' || fieldtype == '57' || fieldtype == '167' || fieldtype == '168'){//部门
				canSetEdit = true;
			}else if(fieldtype == '164' || fieldtype == '194' || fieldtype == '169' || fieldtype == '170'){//分部
				canSetEdit = true;
			}else if(fieldtype == '24' || fieldtype == '278'){//岗位
				canSetEdit = true;
			}else if(fieldtype == '65' || fieldtype == '267'){//角色
				canSetEdit = true;
			}else if(fieldtype == '161' || fieldtype == '162' || fieldtype == '256' || fieldtype == '257'){//自定义单选、自定义多选、自定义树形单选、自定义树形多选
				canSetEdit = true;
			}else if(fieldtype == '16' || fieldtype == '152' || fieldtype == '171'){//流程、多流程、归档流程
				canSetEdit = true;
			}else if(fieldtype == '9' || fieldtype == '37'){//文档、多文档
				canSetEdit = true;
			}else if(fieldtype == '7' || fieldtype == '18'){//客户、多客户
				canSetEdit = true;
			}else if(fieldtype == '8' || fieldtype == '135'){//项目、多项目
				canSetEdit = true;
			}else if(fieldtype == '23'){//资产
				canSetEdit = true;
			}else if(fieldtype == '178'){//年份
				canSetEdit = true;
			}
		}
		if(!canSetEdit){
			return "";
		}
	    var checked;
		if(value==1){
			checked="checked='checked'";
		}else{
			checked='';
		}
		return "<input type='checkbox' class='checkboxcommon' onclick=commonCheckboxClick(this,"+record.id+","+rowIndex+",'editable',false) "+checked+"></input>";
	}
	
	var fm = Ext.form;
	var sumCombo=new Ext.form.ComboBox({//是否统计
        typeAhead: true,
        triggerAction: 'all',
        transform:'isstat',
        lazyRender:true,
        listClass: 'x-combo-list-small'
	});
	var groupCombo=new Ext.form.ComboBox({//是否分组
        typeAhead: true,
        triggerAction: 'all',
        transform:'isgroup',
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
	var showCombo=new Ext.form.ComboBox({//是否标题列
        typeAhead: true,
        triggerAction: 'all',
        transform:'isshow',
        lazyRender:true,
        listClass: 'x-combo-list-small'
	});
	var titleCombo=new Ext.form.ComboBox({//是否标题
        typeAhead: true,
        triggerAction: 'all',
        transform:'istitle',
        lazyRender:true,
        listClass: 'x-combo-list-small'
	});
	var queryCombo=new Ext.form.ComboBox({//是否查询
        typeAhead: true,
        triggerAction: 'all',
        transform:'isquery',
        lazyRender:true,
        listClass: 'x-combo-list-small'
	});
	var advancedQueryCombo=new Ext.form.ComboBox({//是否高级查询
        typeAhead: true,
        triggerAction: 'all',
        transform:'isadvancedquery',
        lazyRender:true,
        listClass: 'x-combo-list-small'
	});
	var hrefCombo=new Ext.form.ComboBox({//是否表单链接
        typeAhead: true,
        triggerAction: 'all',
        transform:'ishreffield',
        lazyRender:true,
        listClass: 'x-combo-list-small'
	});
	var browserCombo=new Ext.form.ComboBox({//是否browser
        typeAhead: true,
        triggerAction: 'all',
        transform:'isbrowser',
        lazyRender:true,
        listClass: 'x-combo-list-small'
		});
	
	sm = new Ext.grid.RowSelectionModel({
		handleMouseDown:Ext.emptyFn
	});
	var cm;
	if(<%= isVirtualForm %> == 0  || <%= "1".equals(norightlist) %>){
			cm = new Ext.grid.LockingColumnModel([{
				header: "",
				dataIndex: '',
				width: 12,
				hidden:true,
				fixed:true,
				locked: true
			}, {
				header: "<input type='checkbox' id='checkboxAll' onclick='selectAllFields(this)' style='margin:0 0 0 2px;height:13px;'/> <%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%>",//是否标题列
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
				width: 100,
				renderer:formatFieldlabelname,
				locked: true
			}, {
				header: "<%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%>",//显示顺序
				dataIndex: 'showorder',
				width: 60,
				editor: new fm.TextField({
					allowBlank: true,
					regex: new RegExp(/^[+-]?\d+$/),
					regexText: "<%=SystemEnv.getHtmlLabelName(82023,user.getLanguage())%>"//用户格式错误
				})
			}, {
				header: "<%=SystemEnv.getHtmlLabelName(82024,user.getLanguage())%>",//链接字段
				dataIndex: 'istitle',
				width: 60,
				renderer: formatIsTitle
			},{
				header: "<%=SystemEnv.getHtmlLabelName(82053,user.getLanguage())%>",//链接路径
				dataIndex: 'hreflink',
				width: 200,
				editor: new fm.TextField({
					allowBlank: true
				})
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
				width: 60,
				editor: new fm.NumberField({
					allowBlank: true,
					allowNegative: false,
					maxValue: 100000
				})
			}, {
				header: "<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>",//是否查询条件
				dataIndex: 'isquery',
				renderer: formatIsQuery,
				width: 70
			}, {
				header: "<%=SystemEnv.getHtmlLabelName(82830,user.getLanguage())%>",//条件参数
				dataIndex: 'searchpara',
				width: 70,
				editor: new fm.TextField({
					allowBlank: true
				})
			}, {
				header: "<%=SystemEnv.getHtmlLabelName(82055,user.getLanguage())%>",//条件显示顺序
				dataIndex: 'queryorder',
				width: 100,
				editor: new fm.TextField({
					allowBlank: true
				})
			},{
				header: "<%=SystemEnv.getHtmlLabelName(1889,user.getLanguage())%>",//是否高级查询条件
				dataIndex: 'isadvancedquery',
				renderer: formatIsAdvancedQuery,
				width: 100
			}, {
				header: "<%=SystemEnv.getHtmlLabelName(82851,user.getLanguage())%>",//高级查询条件显示顺序
				dataIndex: 'advancedqueryorder',
				width: 120,
				editor: new fm.TextField({
					allowBlank: true
				})
			},{
				header: "<%=SystemEnv.getHtmlLabelName(2095,user.getLanguage())%>",//是否关键字查询
				dataIndex: "iskey",
				width: 60,
				renderer: formatIsKey
			}, {
				header: "<%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%>",//是否统计
				dataIndex: 'isstat',
				renderer: formatIsSum,
				width: 60,
				editor: sumCombo
			},{
				header: "<%=SystemEnv.getHtmlLabelName(31458,user.getLanguage())%>",//是否分组
				dataIndex: 'isgroup',
				renderer: formatIsGroup,
				width: 60,
				editor: groupCombo
			},{
				header: "<%=SystemEnv.getHtmlLabelName(82056,user.getLanguage())%>",//显示方式
				dataIndex: 'showmethod',
				width:70 ,
				renderer:showmethodRender
			},{
				header: "<%=SystemEnv.getHtmlLabelName(127030,user.getLanguage())%>",//选择框多选
				dataIndex: 'conditionTransition',
				width:60 ,
				renderer:formatConditionTrans,
				editor:contransCombo
			},{
				header: "<%=SystemEnv.getHtmlLabelName(126784, user.getLanguage()) %>",//地图定位
				dataIndex: 'ismaplocation',
				width:60 ,
				renderer:ismaplocationTrans,
			}
		]);
	}else{
		cm = new Ext.grid.LockingColumnModel([{
				header: "",
				dataIndex: '',
				width: 12,
				hidden:true,
				fixed:true,
				locked: true
			}, {
				header: "<input type='checkbox' id='checkboxAll' onclick='selectAllFields(this)' style='margin:0 0 0 2px;height:13px;'/> <%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%>",//是否标题列
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
				width: 100,
				renderer:formatFieldlabelname,
				locked: true
			}, {
				header: "<%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%>",//显示顺序
				dataIndex: 'showorder',
				width: 60,
				editor: new fm.TextField({
					allowBlank: true,
					regex: new RegExp(/^[+-]?\d+$/),
					regexText: "<%=SystemEnv.getHtmlLabelName(82023,user.getLanguage())%>"//用户格式错误
				})
			}, {
				header: "<%=SystemEnv.getHtmlLabelName(82024,user.getLanguage())%>",//链接字段
				dataIndex: 'istitle',
				width: 60,
				renderer: formatIsTitle
			},{
				header: "<%=SystemEnv.getHtmlLabelName(82053,user.getLanguage())%>",//链接路径
				dataIndex: 'hreflink',
				width: 200,
				editor: new fm.TextField({
					allowBlank: true
				})
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
				width: 60,
				editor: new fm.NumberField({
					allowBlank: true,
					allowNegative: false,
					maxValue: 100000
				})
			}, {
				header: "<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>",//是否查询条件
				dataIndex: 'isquery',
				renderer: formatIsQuery,
				width: 70
			}, {
				header: "<%=SystemEnv.getHtmlLabelName(82830,user.getLanguage())%>",//条件参数
				dataIndex: 'searchpara',
				width: 70,
				editor: new fm.TextField({
					allowBlank: true
				})
			}, {
				header: "<%=SystemEnv.getHtmlLabelName(82055,user.getLanguage())%>",//条件显示顺序
				dataIndex: 'queryorder',
				width: 100,
				editor: new fm.TextField({
					allowBlank: true
				})
			},{
				header: "<%=SystemEnv.getHtmlLabelName(1889,user.getLanguage())%>",//是否高级查询条件
				dataIndex: 'isadvancedquery',
				renderer: formatIsAdvancedQuery,
				width: 100
			}, {
				header: "<%=SystemEnv.getHtmlLabelName(82851,user.getLanguage())%>",//高级查询条件显示顺序
				dataIndex: 'advancedqueryorder',
				width: 120,
				editor: new fm.TextField({
					allowBlank: true
				})
			},{
				header: "<%=SystemEnv.getHtmlLabelName(2095,user.getLanguage())%>",//是否关键字查询
				dataIndex: "iskey",
				width: 60,
				renderer: formatIsKey
			}, {
				header: "<%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%>",//是否统计
				dataIndex: 'isstat',
				renderer: formatIsSum,
				width: 60,
				editor: sumCombo
			},{
				header: "<%=SystemEnv.getHtmlLabelName(31458,user.getLanguage())%>",//是否分组
				dataIndex: 'isgroup',
				renderer: formatIsGroup,
				width: 60,
				editor: groupCombo
			},{
				header: "<%=SystemEnv.getHtmlLabelName(82056,user.getLanguage())%>",//显示方式
				dataIndex: 'showmethod',
				width:70 ,
				renderer:showmethodRender
			},{
				header: "<%=SystemEnv.getHtmlLabelName(127030,user.getLanguage())%>",//选择框多选
				dataIndex: 'conditionTransition',
				width:60 ,
				renderer:formatConditionTrans,
				editor:contransCombo
			},{
				header: "<%=SystemEnv.getHtmlLabelName(126784, user.getLanguage()) %>",//地图定位
				dataIndex: 'ismaplocation',
				width:60 ,
				renderer:ismaplocationTrans,
			},{
				header: "<%=SystemEnv.getHtmlLabelName(25465, user.getLanguage()) %>",//批量修改
				dataIndex: 'editable',
				width:60 ,
				renderer:editableRender,
			}
		]);
	}

   store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
        	method:"post",
        	url: '/weaver/weaver.formmode.servelt.CustomSearchAction?action=getFieldsJSON&id=<%=id%>'
   		}),

   		reader: new Ext.data.JsonReader({
             root: 'result',
             totalProperty: 'totalCount',
             fields: ['isdetail','fieldid', 'fieldhtmltype', 'fieldtype', 'fieldname', 'fieldlabel', 'fieldlabelname','viewtype', 'isquery','isadvancedquery', 'isshow', 'showorder', 'queryorder','advancedqueryorder', 'istitle', 'iskey', 'colwidth','canorder', 'isorder','ordertype','ordernum', 'ishreffield', 'hreflink','showmethod','isstat','isgroup','searchpara','conditionTransition','ismaplocation','editable']
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
    	listeners: {
    		'afteredit': function(e) {
    			if (e.column == 5 && (e.value == 1||e.value == 0||e.value == 2||e.value == 3)) {//确保是否标题字段为是是唯一的
    				var  record = e.record;
    				if(e.value == 1){
    						if(mid==0&&isVir==0){
    							record.set("hreflink","");
    							record.set("istitle","0");
    							alert("<%=SystemEnv.getHtmlLabelName(82057,user.getLanguage())%>");//虚拟表单查询列表未设置模块,不能设置表单建模链接!
    						}else{
    							record.set("hreflink","/formmode/view/AddFormMode.jsp?type=$type$&modeId=$modeId$&formId=$formId$&billid=$billid$&opentype=$opentype$&customid=$customid$&viewfrom=$viewfrom$");
    						}
    				}else if(e.value == 2){
    					record.set("hreflink","/workflow/request/ViewRequest.jsp?requestid=$requestId$&isovertime=0");
    				}else{
    					record.set("hreflink","");
    				}
    				if(record.get("istitle")==1||record.get("istitle")==2||record.get("istitle")==3){
    					if(record.get("showmethod")==1){
    						record.set("showmethod","0");
    					}
    				}
    			}
    			if (e.column == 16 && e.value == 1) {//确保是否关键字字段为是是唯一的
    				//var rowIndex = e.row;
    				//var store_ = e.grid.store;
    				//for (var i = 0 ; i < store_.getCount() ; i++) {
    					//var record = store_.getAt(i);
    					//if (i != rowIndex) {
    						//record.set("iskey",0);
    					//}
    				//} /*说明：关键字可以多个 可以相互or关系组合查询*/
    			}
    			if (e.column == 18&&e.value == 1) {//确保分组字段是唯一的
    				var rowIndex = e.row;
    				var store_ = e.grid.store;
    				for (var i = 0 ; i < store_.getCount() ; i++) {
    					var record = store_.getAt(i);
    					if (i != rowIndex&&(record.get('fieldhtmltype')==5||record.get('fieldhtmltype')==8)&&record.get("isgroup")==1) {
    						record.set("isgroup",0);
    					}
    				} 
    			}
    			if (e.column == 6) {//判断是标题字段，链接不能为空
    				var value = e.value;
    				var record = e.record;
    				if((value==null||value=='')&&record.get("istitle")!=0){
    					record.set("hreflink",lastlinkurl);
    				}
    			}
    		},
    		'beforeedit': function(e) {
    			var grid = e.grid;
			    var record = e.record;
			    var rowIndex = e.row;
			    var columnIndex = e.column;
			    //alert(record.get("fieldname"));
			    //alert(columnIndex);
			    if(columnIndex==6){
			    	lastlinkurl = record.get("hreflink");
			    }else if(columnIndex==7){
			    	if(record.get('canorder')=='false') return false;
			    }else if(columnIndex==17){
			    	if (record.get('fieldhtmltype') == 1){ //单行文本
			    		if(record.get('fieldtype')!=2 && record.get('fieldtype')!=3 && record.get('fieldtype')!=4 && record.get('fieldtype')!=5){
			    			return false;
			    		}
			    	}else{
			    		return false;
			    	}
			    }else if(columnIndex==18){
			    	if ((record.get('fieldhtmltype') == 5||record.get('fieldhtmltype') == 8) &&record.get('viewtype') == 0){ //下拉框  公共选择项
			    	}else{
			    		return false;
			    	}
			    }else if(columnIndex==20){
			    	if (record.get('fieldhtmltype') == 5||record.get('fieldhtmltype') == 8){ //下拉框  公共选择项
			    	}else{
			    		return false;
			    	}
			    }else if(record.get("fieldname") == 'dataid' && (columnIndex==12 || columnIndex==13 || columnIndex==15)){
			        return false;
			    }
			    dynamicSetEditor(grid, record, rowIndex, columnIndex, e);
    		}
    	}
    });
    		
    grid.on("cellclick", function(grid, rowIndex, columnIndex, e){
    		var record = grid.store.getAt(rowIndex);
    		dynamicSetEditor(grid, record, rowIndex, columnIndex, e);
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

function dynamicSetEditor(grid, record, rowIndex, columnIndex, e) {
   	if(columnIndex==5){
   		var fieldhtmltype = record.get('fieldhtmltype');
		var fieldtype = record.get('fieldtype');
		var canSetTitle = false;
		
		if(fieldhtmltype == 1 || fieldhtmltype ==5 || fieldhtmltype ==8){ //单行文本，选择框,公共选择项
			canSetTitle = true;
		}else if(fieldhtmltype == 3 && fieldtype != 2 && fieldtype != 19 && !checkMultiBrowser(fieldtype)){
			canSetTitle = true;
		}
		if(canSetTitle){
			grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.ComboBox({
           		 	typeAhead: true,
           		  	triggerAction: 'all',
           		 	store:isTitleStore,
           		  	mode:'local',
           		  	emptyText:'',
           		  	valueField:'value',
           		  	displayField:'text',
           		 	selectOnFocus:true,
           		  	listClass: 'x-combo-list-small'})));
		}else{
			e.cancel = true;
			grid.getColumnModel().setEditor(columnIndex, null);
		}
	}else if(columnIndex==6){
		//单行文本
			if(record.get('istitle') == 1 || record.get('istitle') == 2||record.get('istitle') == 3) {
		  	  	 	grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.TextField({
	        		allowBlank: true
		   	 	})));
       	 	} else {
                e.cancel = true;
                grid.getColumnModel().setEditor(columnIndex, null);
        	}
	}else if (columnIndex==8) {
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
	}else if (columnIndex==9) {
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
	}else if(columnIndex==16){
			if (record.get('fieldhtmltype') == 1) {  //单行文本
		  	 	if(record.get('fieldtype') == 1 || record.get('fieldtype') == 2 || record.get('fieldtype') == 3 || record.get('fieldtype') == 4 || record.get('fieldtype') == 5) {
		  	 		grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                 		 	typeAhead: true,
                 		  	triggerAction: 'all',
                 		 	store:isKeyStore,
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
	}else if(columnIndex==19){
            if (((record.get('fieldhtmltype') == 1 && record.get('fieldtype') != 1)||record.get('fieldhtmltype') == 4||
            	record.get('fieldhtmltype') ==5||record.get('fieldhtmltype') ==8||(record.get('fieldhtmltype') == 3 && record.get('fieldtype') == 2)||record.get('fieldid') == -1)&&
            	record.get("istitle")!=1&&record.get("istitle")!=2&&record.get("istitle")!=3) {  //单行文本
		  	 		grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.ux.form.Showmethod({
		                  allowBlank: true,
		                  storeRecord: record,
		                  store:showmethodStore,
		                  editgrid : grid,
		                  valueField:'value',
                 		  displayField:'text',
		                  url:"/formmode/setup/customSearchShowChange.jsp?value="+e.value+"&fieldid="+record.get("fieldid")+"&id="+<%=id%>
                      })));
             }else if(record.get('fieldhtmltype') == 6){ //附件  
                    grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.ux.form.Showmethod({
		                  allowBlank: true,
		                  storeRecord: record,
		                  store:showmethodStore,
		                  editgrid : grid,
		                  valueField:'value',
                 		  displayField:'text',
		                  url:"/formmode/setup/customSearchAttachDownChange.jsp?value="+e.value+"&fieldid="+record.get("fieldid")+"&id="+<%=id%>
                    })));
             }else{
                	e.cancel = true;
					grid.getColumnModel().setEditor(columnIndex, null);
			 }
     }else if(columnIndex==16){
		//单行文本
			if(record.get('isquery') == 1) {
		  	  	 	grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.TextField({
	        		allowBlank: true
		   	 	})));
       	 	} else {
                e.cancel = true;
                grid.getColumnModel().setEditor(columnIndex, null);
        	}
	}   
   }

	
function commonCheckboxClick(obj,recordid,rowIndex,dataIndex,isSelectRow){
	var record=store.getById(recordid);
	if(jQuery(obj).is(":checked")){
		record.set(dataIndex,1);
		if(isSelectRow){
			sm.selectRow(rowIndex,true);
		}
		if(dataIndex=='isorder'){
			record.set('ordertype','n');
		}
		if(dataIndex=='editable'){
			record.set('isshow',1);
			sm.selectRow(rowIndex,true);
		}
	}else{
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

function checkMultiBrowser(fieldType){
	var isMulti = false;
	var typeArr = ["17","18","27","37","57","65","135","141","142","152","160","162","166","168","170","171","194","257","261","278"];
	for(var i=0;i<typeArr.length;i++){
		if(fieldType == typeArr[i]){
			isMulti=true;
			break;
		}
	}
	return isMulti;
}
</script>
</head>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(operatelevel>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(221,user.getLanguage())+",javascript:onPreview(),_self} " ;//预览
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>

<div class="e8_forGridHidden">
    <select name="isstat" id="isstat" style="display: none;">
        <option value="1"><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><!-- 是 -->
        <option value="0"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><!-- 否 -->
    </select>
    <select name="isgroup" id="isgroup" style="display: none;">
        <option value="1"><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><!-- 是 -->
        <option value="0"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><!-- 否 -->
    </select>
    <select name="conditionTransition" id="conditionTransition" style="display: none;">
        <option value="1"><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><!-- 是 -->
        <option value="0"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><!-- 否 -->
    </select>
    <select name="isshow" id="isshow" style="display: none;">
        <option value="1"><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><!-- 是 -->
        <option value="0"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><!-- 否 -->
    </select>
    <select name="isquery" id="isquery" style="display: none;">
        <option value="1"><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><!-- 是 -->
        <option value="0"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><!-- 否 -->
    </select>
    <select name="isadvancedquery" id="isadvancedquery" style="display: none;">
        <option value="1"><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><!-- 是 -->
        <option value="0"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><!-- 否 -->
    </select>
      <select name="ishreffield" id="ishreffield" style="display: none;">
        <option value="1"><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><!-- 是 -->
        <option value="0"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><!-- 否 -->
    </select>
    <select name="istitle" id="istitle" style="display: none;">
        <option value="1"><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><!-- 是 -->
        <option value="0"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><!-- 否 -->
    </select>
    <select name="isbrowser" id="isbrowser" style="display: none;">
        <option value="1"><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><!-- 是 -->
        <option value="0"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><!-- 否 -->
    </select>
    <select name="showmethod" id="showmethod" style="display: none;">
        <option value="-1"></option>
        <option value="0"><%=SystemEnv.getHtmlLabelName(24120,user.getLanguage())%></option><!--选择项  -->
        <option value="1"><%=SystemEnv.getHtmlLabelName(22969,user.getLanguage())%></option><!-- 图标 -->
        <option value="2"><%=SystemEnv.getHtmlLabelName(22969,user.getLanguage())%>+<%=SystemEnv.getHtmlLabelName(24120,user.getLanguage())%></option><!-- 图标+选择项 -->
        <option value="3"><%=SystemEnv.getHtmlLabelName(17639,user.getLanguage())%></option><!-- 数值 -->
        <option value="4"><%=SystemEnv.getHtmlLabelName(82058,user.getLanguage())%></option><!-- 进度条 -->
    </select>
</div>
<script type="text/javascript">
function submitData(){
	var hrefisnull = false;
	store.each(function(record){
		if(!hrefisnull && record.get("isshow")==1 && record.get("istitle")==3 && record.get("hreflink").replace(/(^\s*)|(\s*$)/g, "")==""){
			alert("<%=SystemEnv.getHtmlLabelName(128160, user.getLanguage()) %>");
			hrefisnull = true;
		}
	});
	
	if(!hrefisnull){
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
		    url: '/weaver/weaver.formmode.servelt.CustomSearchAction?action=formfieldmanager',
		    data: {jsonFields: jsonFields, id:<%=id%>},
		    success: function(res) {
		    	myMask.hide();
		    	location.reload();
		    }
		});
    }
}
function onPreview(){
	var url = "/formmode/search/CustomSearchBySimple.jsp?customid=<%=id%>";
	window.open(url);
}
</script>
</body>
</html>
