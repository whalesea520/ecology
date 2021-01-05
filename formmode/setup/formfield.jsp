<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@page import="net.sf.json.JSONArray"%>
<%@ page import="weaver.formmode.service.FormInfoService"%>
<%@ include file="/formmode/pub.jsp"%>
<%
	if (!HrmUserVarify.checkUserRight("FORMMODEFORM:ALL", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
int formId = Util.getIntValue(request.getParameter("id"), 0);
FormInfoService formInfoService = new FormInfoService();
formInfoService.setUser(user);
Map<String, Object> formInfo = formInfoService.getFormInfoById(formId);
boolean isvirtualform = formInfoService.isVirtualForm(formInfo);

if(formInfoService.isVirtualForm(formId)){
	response.sendRedirect("/formmode/setup/formfield2.jsp?id="+formId);
	return;
}
List<Map<String, Object>> detailTables = formInfoService.getAllDetailTable(formId);
JSONArray browserArr = formInfoService.getBrowserInfoWithJSON();

String titlename=SystemEnv.getHtmlLabelName(82107,user.getLanguage());//表单字段设置

String subCompanyIdsql = "select subCompanyId3  from workflow_bill where id="+formId;
RecordSet recordSet = new RecordSet();
recordSet.executeSql(subCompanyIdsql);
int subCompanyId = -1;
if(recordSet.next()){
	subCompanyId = recordSet.getInt("subCompanyId3");
}
String userRightStr = "FORMMODEFORM:ALL";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);

RecordSet rs2 = new RecordSet();
String treeSql = "select  a.id,a.treename from mode_customtree a where a.showtype=1  order by a.treename";
rs2.executeSql(treeSql);
List treeList = new ArrayList();
while(rs2.next()){
	Map map = new HashMap();
	map.put("id",rs2.getString("id"));
	map.put("treebrowsername",rs2.getString("treename"));
	treeList.add(map);
}
%>
<html>
<head>
	<title></title>
	<link rel="stylesheet" type="text/css" href="/formmode/js/ext/resources/css/ext-all_wev8.css" />
	<script type="text/javascript" src="/formmode/js/ext/adapter/ext/ext-base_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ext-all_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ux/miframe_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ux/columnLock_wev8.js"></script>
	<link rel="stylesheet" type="text/css" href="/formmode/js/ext/ux/css/columnLock_wev8.css"/>
	<script type="text/javascript" src="/formmode/js/ext/ux/showexpendattr_wev8.js"></script>
	
	<link type="text/css" rel="stylesheet" href="/formmode/js/jquery/jquery-ui-1.10.3/themes/base/jquery.ui.all_wev8.css" />
	<script type="text/javascript" src="/formmode/js/jquery/jquery-ui-1.10.3/ui/minified/jquery-ui.min_wev8.js"></script>
	<!-- 
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET> -->
	<style type="text/css">
		* {font:12px Microsoft YaHei}
		html,body{
			height: 100%;
			margin: 0px;
			padding: 0px;
		}
		.e8_formfield_tabs{
			height: 100%;
			margin: 0px;
			padding: 0px;
			border: none;
			position: relative;
		}
		.e8_formfield_tabs .ui-tabs-nav {
			background:none;
			border:none;
			padding-left: 0px;
		}
		.e8_formfield_tabs .ui-tabs-nav li{
			margin-right: 0px;
			border:0;
		}
		.e8_formfield_tabs .ui-tabs-nav li.ui-state-default{
			background: none;
		}
		.e8_formfield_tabs .ui-tabs-nav li a{
			font-size: 12px;
			padding-left: 0px;
			padding-right: 10px;
			color: #333;
			
		}
		.e8_formfield_tabs .ui-tabs-nav li a:hover{
			color: #0072C6;
		}
		.e8_formfield_tabs .ui-tabs-nav li a:active{
			background: none;
		}
		.e8_formfield_tabs .ui-tabs-nav li.ui-state-active a{
			color: #0072C6;
			font-weight: bold;
		}
		.e8_formfield_tabs .ui-tabs-nav li a span.ui-icon-close{
			position: absolute;
			top:0px;
			right: 0px;
			display: none;
			cursor: pointer;
		}
		.e8_formfield_tabs .ui-tabs-nav li a:hover span.ui-icon-close{
			display: block;
		}
		
		.e8_formfield_tabs .ui-tabs-panel{
			padding: 0px;
			overflow: hidden;
		}
		/*Ext 表格对应的样式(框架)*/
		.e8_formfield_tabs .ui-tabs-panel .x-border-layout-ct{
			background-color: #fff;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-panel-body-noheader{
			border: none;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-panel-tl{
			border-bottom-width: 0px;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-panel-ml{
			padding-left: 0px;
			background-image: none;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-panel-mc{
			padding-top: 0px;
			background-color: #fff;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-panel-mr{
			padding-right: 0px;
			background-image: none;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-panel-nofooter .x-panel-bc{
			height: 0px;
			overflow:hidden;
		}
		
		/*Ext 表格对应的样式(表格)*/
		.e8_formfield_tabs .ui-tabs-panel .x-grid-panel .x-panel-mc .x-panel-body{
			border: none; 
		}
		.e8_formfield_tabs .ui-tabs-panel .x-grid3-header{
			background: none;
			padding-left: 3px;
			background-color: #E5E5E5;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-grid3-hd-row td{
			background-color: #E5E5E5;
			border-left: none;
			border-right-color: #d0d0d0;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-grid3-hd-row td .x-grid3-hd-inner{
			color: #333;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-grid3-row-table td{
			
		}
		.e8_formfield_tabs .ui-tabs-panel .x-grid3-header-inner{
			background-color: #E5E5E5;
		}
		.e8_formfield_tabs .ui-tabs-panel td.x-grid3-hd-over .x-grid3-hd-inner{
			background-image: none;
			background-color: #E5E5E5;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-grid3-hd-over .x-grid3-hd-btn{
			display: none;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-grid3-scroller{
		
		}
		.e8_formfield_tabs .ui-tabs-panel .x-grid3-locked .x-grid3-scroller{
			border-right-color: #d0d0d0;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-grid3-body .x-grid3-td-checker{
			padding-left: 3px;
			background: none;
		}
		.e8_formfield_tabs .x-grid3-cell-inner{
			padding: 1px 3px 1px 5px;
		}
		.e8_formfield_tabs .x-grid3-row{
			border-left-width: 0px;
		}
		
		.e8_formfield_addTab{
			position: absolute;
			width: 10px;
			height: 10px;
			top: 11px;
			left: -10px;
			cursor: pointer;
			background: url("/formmode/images/add_wev8.png") no-repeat;
			z-index: 1000;
			margin-left: 2px;
		}
		.checkboxcommon{
			height:12px;
			line-height:12px;
			padding-left:5px;
		}
	</style>
	<script type="text/javascript">
		function forPageResize(){
			var $e8_formfield_tabs = $(".e8_formfield_tabs");
			var $ui_tabs_nav = $(".e8_formfield_tabs .ui-tabs-nav");
			var $ui_tabs_panel = $(".e8_formfield_tabs .ui-tabs-panel");
			
			var panelHeight = $e8_formfield_tabs.height() - $ui_tabs_nav.outerHeight(true);
			
			$ui_tabs_panel.height(panelHeight);
		}
		
		Ext.override(Ext.grid.ColumnModel,{
	        isLocked :function(colIndex){
			if(this.config[colIndex] instanceof Ext.grid.CheckboxSelectionModel){return true;}
	                return this.config[colIndex].locked === true;
	        }
		});
		Ext.override(Ext.grid.CheckboxSelectionModel,{
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
	
		var selectitemtypestore = new Ext.data.SimpleStore({
			id:0,
			fields: ['value', 'text'], 
			data : []
		});
		var refobjstore = new Ext.data.SimpleStore({
			id:0,
			fields: ['value', 'text'],
			data : []
		});
		var categorystore = new Ext.data.SimpleStore({
			id:0,
			fields: ['value', 'text'],
			data : []
		});
		var bstore=new Ext.data.SimpleStore({
			id:0,
			fields:['value', 'text'],
			//data: [['1','单行文本框'],['2','多行文本框'],['3','浏览按钮'],['4','CHECK框'],['5','选择框'],['6','附件上传'],['7','特殊字段']]
			data: [['1','<%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%>'],['2','<%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%>'],['3','<%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%>'],['4','<%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%>'],['5','<%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%>'],['6','<%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%>'],['7','<%=SystemEnv.getHtmlLabelName(21691,user.getLanguage())%>'],['8','<%=SystemEnv.getHtmlLabelName(82477,user.getLanguage())%>']]
		});
		var fieldtypestore=new Ext.data.SimpleStore({
			id:0,
			fields: ['value', 'text'],
			//data: [['1','文本'],['2','整数'],['3','浮点数'],['4','金额转换'],['5','金额千分位']]
			data: [['1','<%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%>'],['2','<%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%>'],['3','<%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%>'],['4','<%=SystemEnv.getHtmlLabelName(18004,user.getLanguage())%>'],['5','<%=SystemEnv.getHtmlLabelName(22395,user.getLanguage())%>']]
		});
		var isstore=new Ext.data.SimpleStore({
			id:0,
			fields:['value', 'text'],
			//data: [['0','否'],['1','是']]
			data: [['0','<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>'],['1','<%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>']]
		});
		var isselectstore=new Ext.data.SimpleStore({
			id:0,
			fields:['value', 'text'],
			//data: [['0','可选择可新建'],['1','只新建'],['2','只选择']]
			data: [['0','<%=SystemEnv.getHtmlLabelName(82108,user.getLanguage())%>'],['1','<%=SystemEnv.getHtmlLabelName(82109,user.getLanguage())%>'],['2','<%=SystemEnv.getHtmlLabelName(82110,user.getLanguage())%>']]
		});
		var attachstore=new Ext.data.SimpleStore({
			id:0,
			fields:['value', 'text'],
			//data: [['1','上传文件'],['2','上传图片']]
			data: [['1','<%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%>'],['2','<%=SystemEnv.getHtmlLabelName(20001,user.getLanguage())%>']]
		});
		var customBrowserTreeStore = new Ext.data.SimpleStore({
			id:0,
			fields:['value', 'text'],
			data: [
					<%
					for(int m=0;m<treeList.size();m++){
						Map tmap = (Map)treeList.get(m);
	            		String treeBrowserId = tmap.get("id")+"";
	            		String treebrowsername = tmap.get("treebrowsername")+"";
	            		if(m>0){
							out.print(",");
						}
					%>
						['<%=treeBrowserId%>','<%=treebrowsername%>']
					<%}%>
				]
		});
		var browserStore = new Ext.data.SimpleStore({
			id:0,
			fields:['value', 'text'],
			data: <%=browserArr%>
		});
		var expendattrStore = new Ext.data.SimpleStore({
			id:0,
			fields: ['value', 'text'], 
			data:[]
			//data: [['1',''],['0','<%=SystemEnv.getHtmlLabelName(20614,user.getLanguage())%>']] //扩展
		});
		var specialFieldStore = new Ext.data.SimpleStore({
			id:0,
			fields:['value', 'text'],
			//data: [['1','自定义链接'],['2','描述性文字']]
			data: [['1','<%=SystemEnv.getHtmlLabelName(21692,user.getLanguage())%>'],['2','<%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%>']]
		});
		
		var impcheckstore=new Ext.data.SimpleStore({
			id:0,
			fields: ['value', 'text'],
			//data: [['0','否'],['1','电话'],['2','手机'],['3','邮编'],['4','身份证'],['5','日期'],['6','时间'],['7','email'],['8','自定义']]
			data: [['0','<%=SystemEnv.getHtmlLabelName(161, user.getLanguage())%>'],
			['1','<%=SystemEnv.getHtmlLabelName(421, user.getLanguage())%>'],
			['2','<%=SystemEnv.getHtmlLabelName(422, user.getLanguage())%>'],
			['3','<%=SystemEnv.getHtmlLabelName(1899, user.getLanguage())%>'],
			['4','<%=SystemEnv.getHtmlLabelName(23792, user.getLanguage())%>'],
			['5','<%=SystemEnv.getHtmlLabelName(97, user.getLanguage())%>'],
			['6','<%=SystemEnv.getHtmlLabelName(277, user.getLanguage())%>'],['7','email'],
			['8','<%=SystemEnv.getHtmlLabelName(19516, user.getLanguage())%>']]
		});
		
		var checkexpressionstore = new Ext.data.SimpleStore({
			id:0,
			fields: ['value', 'text'],
			data: [
				["0",""],
				["1","^((\\\d{7,8})|(\\\d{4}|\\\d{3})-(\\\d{7,8})|(\\\d{4}|\\\d{3})-(\\\d{7,8})-(\\\d{4}|\\\d{3}|\\\d{2}|\\\d{1})|(\\\d{7,8})-(\\\d{4}|\\\d{3}|\\\d{2}|\\\d{1}))$"],
				["2","^\\\d{11}$"],
				["3","^[1-9]\\\d{5}$"],
				["4","^[1-9]\\\d{5}[1-9]\\\d{3}((0\\\d)|(1[0-2]))(([0|1|2]\\\d)|3[0-1])\\\d{3}([0-9]|[Xx])$"],
				["5","^(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)$"],
				["6","^(([0-1][0-9])|2[0-3]):[0-5][0-9]$"],
				["7","([0-9]|[a-z]|[A-Z])\\\w*@([0-9]|[a-z]|[A-Z])\\\w*"],
				["8",""]
			]
		});
		
		function fieldtypeRender(value, m, record, rowIndex, colIndex){
			if(record.get("htmltype")==5||record.get("htmltype")==8){ //选择
				if(typeof(value) == "undefined"){
				    return '';
				}else{
				    return value;
				}
				/*var selcombox = selectitemtypestore.getById(value);
				if (typeof(selcombox) == "undefined"){
				    return '';
				}else{
				    return selcombox.get('text');
				}*/
	        }/*else if(record.get("htmltype")==6){ //关联
				var relcombox=refobjstore.getById(value);
				if (typeof(relcombox) == "undefined")
					return '';
				else
					return relcombox.get('text');
	
	        }*/else if(record.get("htmltype")==6){ //附件
	            var relcombox=attachstore.getById(value);
	            if (typeof(relcombox) == "undefined")
	                 return '';
	            else
	                 return relcombox.get('text');
	        }else if(record.get("htmltype")==2){ //多行文本
	        	return "<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>：" + value;//高度
	        }else if(record.get("htmltype")==3){ //浏览按钮
	        	var browserbox=browserStore.getById(value);
				if (typeof(browserbox) == "undefined"){
					return '';	
				}else{
					return browserbox.get('text');	
				}
	        }else if(record.get("htmltype")==4){	//checkbox框
	        	return '';
	        }else if(record.get("htmltype")==7){	//特殊字段
	        	var specialFieldbox=specialFieldStore.getById(value);
				if (typeof(specialFieldbox) == "undefined"){
					return '';	
				}else{
					return specialFieldbox.get('text');	
				}
	        }else {
               var bcombox = fieldtypestore.getById(value);			
               if (typeof(bcombox) == "undefined")
                   return ''
               else
                   return bcombox.get('text');
               
			}
     	}
     	
     	function impcheckRender(value, m, record, rowIndex, colIndex){
			var iscombox=impcheckstore.getById(value);
			if (typeof(iscombox) == "undefined")
		      return '';
			else
		      return iscombox.get('text');
     	}
     	
     	function checkexpressionRender(value, m, record, rowIndex, colIndex){
			return value;
     	}
     	
		function htmltypeRender(value, m, record, rowIndex, colIndex) {
	         var htmltypecombox = bstore.getById(value);
	         if (typeof(htmltypecombox) == "undefined")
	             return ''
	         else
	             return htmltypecombox.get('text');
		}
		
		function isRender(value, cellmeta, record, rowIndex, columnIndex, ostore){
			if(record.get("fieldname")=='id' || record.get("fieldname")=='modedatacreater' || record.get("fieldname")=='modedatacreatedate' || record.get("fieldname")=='modedatacreatetime'){
			       return "";
			}
		    var checked;
			if(value==1){
				checked="checked='checked'";
			}else{
				checked='';
			}
			return "<input type='checkbox' class='checkboxcommon' onclick=commonCheckboxClick(this,"+record.id+","+rowIndex+",'needlog',false,'"+ostore.storeId+"') "+checked+"></input>";
		}
		
		function isRenderFromNeedExcel(value, cellmeta, record, rowIndex, columnIndex, ostore){
			var checked;
			if (record.get('htmltype')==6 || record.get('htmltype')==7) return "";
			if(value==1){
				checked="checked='checked'";
			}else{
				checked='';
			}
			return "<input type='checkbox' class='checkboxcommon' onclick=commonCheckboxClick(this,"+record.id+","+rowIndex+",'needExcel',false,'"+ostore.storeId+"') "+checked+"></input>";
		}
		
		function isRenderFromIsprompt(value, cellmeta, record, rowIndex, columnIndex, ostore){
			if (record.get('htmltype')!=1) return "";
			if (record.get('htmltype')==1 && record.get('fieldtype')==4) return "";
			var checked;
			if(value==1){
				checked="checked='checked'";
			}else{
				checked='';
			}
			return "<input type='checkbox' class='checkboxcommon' onclick=commonCheckboxClick(this,"+record.id+","+rowIndex+",'isprompt',false,'"+ostore.storeId+"') "+checked+"></input>";
		}
		
		function isExpendattr(value, cellmeta, record, rowIndex, columnIndex){
			return value;
		}
      
		function isEncrypt(value, m, record, rowIndex, colIndex){
			var iscombox=isstore.getById(value);
			if (typeof(iscombox) == "undefined"){
		      if(record.get("htmltype")==1||record.get("htmltype")==5) {
		        return '<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>';//否
		      }else{
		         return '';
		      }
			}
		  	else
		      return iscombox.get('text'); 
		}
		
		function isRendermoney(value, m, record, rowIndex, colIndex){
			var iscombox=isstore.getById(value);
			if (typeof(iscombox) == "undefined")
			{
			    if(record.get("fieldtype")==3) {
			      return '<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>';//否
			    }else{
			       return '';
			    }
			}
			else
	           return iscombox.get('text');
		}

		function isselectRender(value, m, record, rowIndex, colIndex){
			var iscombox=isselectstore.getById(value);
			if (typeof(iscombox) == "undefined")
		      return ''
			else
		      return iscombox.get('text');
		}
      
		function directoryRender(value, m, record, rowIndex, colIndex){
		     var docdirectory=categorystore.getById(value);
		     if (typeof(docdirectory) == "undefined")
		         return ''
		     else
		         return docdirectory.get('text');
		}
      
		function fieldattrrender(value, m, record, rowIndex, colIndex){
			var str;
			if(record.get("htmltype")==1){
				if(record.get("fieldtype")==1){
					if(value!='')
           			str= '<%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%>:'+value;//文本长度
	        	}else if(record.get("fieldtype")==3 || record.get("fieldtype")==5){
	            	if(value!='')
	            	str= '<%=SystemEnv.getHtmlLabelName(82111,user.getLanguage())%>:'+value;//小数点位数
	        	}else if(record.get("fieldtype")==4||record.get("fieldtype")==6){
	            	if(value!=''){
	            		str= value;//文本长度
					}else if(record.get("fieldcheck")==""){
					 //str="(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)";
					}
		        }else {
		           str='';                
		        }
			}else if(record.get("htmltype")==3){ //浏览按钮--
	        	 if(record.get('fieldtype')==256||record.get('fieldtype')==257){
		        	var customBrowserTree=customBrowserTreeStore.getById(value);
					if (typeof(customBrowserTree) == "undefined"){
						str ="";	
					}else{
						str = customBrowserTree.get('text');	
					}
	        	 }else{
	        	 	str= value;
	        	 }
	        }else{
		         if(record.get("fieldtype")=='402881e70bc70ed1010bc710b74b000d'){
		            if(value!=''){
		                 str='<%=SystemEnv.getHtmlLabelName(505,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(82108,user.getLanguage())%>'//文档类型:可选择可新建
		                if(value==1){
		                    str='<%=SystemEnv.getHtmlLabelName(505,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(82109,user.getLanguage())%>'//文档类型:只新建
		
		                }else if(value==2){
		                    str='<%=SystemEnv.getHtmlLabelName(505,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(82110,user.getLanguage())%>'//文档类型:只选择
		                }
		            }
		         }else{
		             str= value;
		
		         }
			}
			return str;
 		}
		
		var readonlyColumnStyle="color:#666;";
		
		function createAGridIfNotExist(containerId, store){
			if(gridIndexOfQueue(containerId) != -1){
				return null;
			}
			var isDetailTable = false;
			if (containerId != "tabs-center-0"){
				isDetailTable = true;
			}
			var fm = Ext.form;
			var sm = new Ext.grid.CheckboxSelectionModel({
				handleMouseDown:Ext.emptyFn
			});
			var cm = new Ext.grid.LockingColumnModel([
			{
	    	 	header: "",
			    dataIndex: '',
			    width: 11,
			    hidden:true,
			    fixed:true,
			    locked: true
	    	},
            {
               id:'fid',
               header: "<%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%>ID",//字段ID
               dataIndex: 'id',
               locked:true,
               width:60,
               css:readonlyColumnStyle,
               editor: new fm.TextField({
                   allowBlank: false,
                   readOnly:true
               })
           },
            {
               id:'htmltype',
               header: "<%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%>",//字段名称
               dataIndex: 'fieldname',
               locked:true,
               width:120,
               css:readonlyColumnStyle,
               editor: new fm.TextField({
                   allowBlank: false,
                   readOnly:true
               })
           },
           /*
		   {
               header: '',
               dataIndex: 'label',
                width:15,
                locked:true
            },*/
			{
             header: "<%=SystemEnv.getHtmlLabelName(30828,user.getLanguage())%>",//显示名称
             dataIndex: 'fieldlabelname',
             locked:true,
             width:120,
             css:readonlyColumnStyle,
             editor: new fm.TextField({
                 allowBlank: true,
                 readOnly:true
             })
          },
          {
              header: "<%=SystemEnv.getHtmlLabelName(82112,user.getLanguage())%>",//UI组件
              dataIndex: 'htmltype',
              width:100,
              css:readonlyColumnStyle,
              renderer:htmltypeRender
          },{
              header: "<%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%>",//字段类型
              dataIndex:'fieldtype',
              width:100 ,
              css:readonlyColumnStyle,
              renderer:fieldtypeRender
          },{
             header: "<%=SystemEnv.getHtmlLabelName(82113,user.getLanguage())%>",//字段属性
             dataIndex: 'fieldattr',
               width:120,
               css:readonlyColumnStyle,
              renderer:fieldattrrender
          },{
              header: "<%=SystemEnv.getHtmlLabelName(82114,user.getLanguage())%>",//记录日志
              dataIndex:'needlog',
              width:100,
              renderer:isRender,
              hidden: isDetailTable
          },{ 
          	  header: "Excel"+"<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%>",//Excel导入
              dataIndex:'needExcel',
              width:100,
              renderer:isRenderFromNeedExcel
          },{
              header: "<%=SystemEnv.getHtmlLabelName(82115,user.getLanguage())%>",//数据提醒
              dataIndex:'isprompt',
              width:100,
              hidden: isDetailTable,
              renderer:isRenderFromIsprompt
          },{
          	  header: "<%=SystemEnv.getHtmlLabelName(124938,user.getLanguage())%>",//扩展属性
          	  dataIndex:'expendattr',
          	  width:100,
          	  //hidden: isDetailTable,
          	  renderer: isExpendattr,
          	  editor: new fm.TextField({
	                   allowBlank: true
               	})
          },{
             header: "<%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%>",//显示顺序
             dataIndex: 'ordernum',
              width:100,
              css:readonlyColumnStyle,
              //locked:true,
            editor: new fm.TextField({
                   allowBlank: true
               })
          }
          ,{
             header: "selurl",
             dataIndex:'selurl',
              hidden:true

          },{
             header: "refurl",
             dataIndex:'refurl',
              hidden:true
          },{
             header: "docdirurl",
             dataIndex:'docdirurl',
              hidden:true
          }
          ,{

             header: "id",
             dataIndex:'id',
              hidden:true

          },{
             header: "<%=SystemEnv.getHtmlLabelName(126882 , user.getLanguage())%>",//导入验证
             dataIndex: 'impcheck',
             width:100,
             renderer:impcheckRender
          },{
             header: "<%=SystemEnv.getHtmlLabelName(126883, user.getLanguage())%>",//验证表达式
             dataIndex: 'checkexpression',
             width:100,
             editor: new fm.TextField({
		        allowBlank: true
		    })
          }
      ]);

      Plant = Ext.data.Record.create([
          {name: 'id', type: 'string'},
          {name: 'fieldname', type: 'string'},
          {name: 'label', type: 'auto'},
          {name: 'htmltype', type: 'string'},
          {name: 'ordernum', type: 'string'},
          {name: 'feildtype', type: 'string'},
          {name: 'fieldattr',type:'string'},
          {name: 'fieldcheck',type:'string'},
          {name: 'labelname',type:'string'},
          {name: 'docdir',type:'string'},
          {name: 'fieldlabelname', type: 'string'},
          {name: 'only'},
          {name: 'needlog'},
          {name: 'needExcel'},
          {name: 'isprompt'},
          {name: 'expendattr'},
          {name: 'ismoney'},
          {name: 'isencryption'},
          {name:'isselect'},
          {name: 'selurl',type:'string'},
          {name: 'refurl',type:'string'},
          {name: 'docdir',type:'string'},
          {name: 'impchek',type:'string'},
          {name: 'checkexpression',type:'string'},
          
      ]);
      
		var grid = new Ext.grid.LockingEditorGridPanel({
			sm:sm ,
			store: store,
			cm: cm,
			region: 'center',
			renderTo: containerId,
			height: $("#" + containerId).height(),
			loadMask: true,
			frame:true,
			clicksToEdit:1,
			viewConfig: {
				center: {autoScroll: true},
				forceFit:false,
				enableRowBody:true,
				lockText:'<%=SystemEnv.getHtmlLabelName(16213,user.getLanguage())%>',//锁定
				unlockText:'<%=SystemEnv.getHtmlLabelName(82116,user.getLanguage())%>',//不锁定
				sortAscText:'<%=SystemEnv.getHtmlLabelName(339,user.getLanguage())%>',//升序
				sortDescText:'<%=SystemEnv.getHtmlLabelName(340,user.getLanguage())%>',//降序
				columnsText:'<%=SystemEnv.getHtmlLabelName(82117,user.getLanguage())%>',//列定义
				getRowClass : function(record, rowIndex, p, store){
					return 'x-grid3-row-collapsed';
				}
			},
			listeners : {
	        'validateedit' : function(e) {
	            if (e.column ==1) {
	                 var valid =true;
	                //*******验证字段名称不能是中文，数字，还有特殊字符（start）**********************/
	                valuechar = e.value.split("");
	                notcharnum = false;
	                notchar = false;
	                notnum = false;
	                for (var i = 0; i < valuechar.length; i++) {
	                    notchar = false;
	                    notnum = false;
	                    charnumber = parseInt(valuechar[i]);
	                    if (isNaN(charnumber)) {
	                        notnum = true;
	                    }
	                    if (valuechar[i].toLowerCase() < 'a' || valuechar[i].toLowerCase() > 'z') {
	                        notchar = true;
	                    }
	                    if (notnum && notchar) {
	                        notcharnum = true;
	                    }
	                }
	                if (valuechar[0].toLowerCase() < 'a' || valuechar[0].toLowerCase() > 'z') {
	                    notcharnum = true;
	                }
	                if (notcharnum) {
	                   return false;
	                }
	                return valid;
	            }else if(e.column==4||e.column==5||e.column==6) {
	                if (e.column == 5) {
	                    if (e.record.data.htmltype == 5 || e.record.data.htmltype == 6 || e.record.data.htmltype == 8) //下拉列表,checkbox多选和关联选择不需要验证
	                        return;
	                }
	                if(e.column==6){
	                	if(e.record.get('fieldtype')=='C48B871B2F084A7684CD258E85397381'||e.record.get('fieldtype')==5||e.record.get('fieldtype')==6){	 				                	
				             return ;
				        }else if((e.record.data.htmltype == 1&&e.record.get('fieldtype')=='1')){
	                		
	                	}else if((e.record.data.htmltype == 1&&e.record.get('fieldtype')=='3')){
	                		
					            
	                	}else if(e.record.get('fieldtype')==4){
	                		return ;
	                	}
	                }
	            }
	            else if(e.column==9){
	            	
	            }
	
	        },
	        'afteredit' : function(e) {
	            if(e.column==3 ){
	                if(e.value==1){
		                e.record.set('fieldtype','1');
		                e.record.set('fieldattr','256');
		                e.record.set('fieldcheck','');
		                e.record.set('isselect','');  
		                e.record.set('ismoney','0');
	                }else if(e.value==7){
	                	e.record.set('fieldtype','8');
		                e.record.set('fieldattr','');
		                e.record.set('fieldcheck','');
		                e.record.set('isselect','');
			            e.record.set('isencryption','');
			            e.record.set('ismoney','');
	                }else if(e.value!=1&&e.value!=5){
	                	e.record.set('fieldtype','');
		                e.record.set('fieldattr','');
		                e.record.set('fieldcheck','');
		                e.record.set('isselect','');
			            e.record.set('isencryption','');
			            e.record.set('ismoney','');
	                }else{
		                e.record.set('fieldtype','');
		                e.record.set('fieldattr','');
		                e.record.set('fieldcheck','');
		                e.record.set('isselect','');
		                e.record.set('ismoney','');
	                }
	
	
	
	            }
	            else if (e.column ==4 ) {
	                if(e.value==1){  //当为文本时 字段属性的值是256
	                    e.record.set('fieldattr','256');
	                    e.record.set('fieldcheck','');  
	                    e.record.set('ismoney','0');
	
	                }else if(e.value==2){    //当为整数时 字段验证有默认值
	                    e.record.set('fieldcheck','^-?\\d+$');
	                    e.record.set('fieldattr','');
	                    e.record.set('ismoney','0');
	
	
	                }else if(e.value==3||e.value==5){//浮点数
	                    e.record.set('fieldcheck','^(-?[\\d+]{0,22})(\\.[\\d+]{0,2})?$');
	                     e.record.set('fieldattr','2');
	                     e.record.set('ismoney','0');
	
	                }else if(e.value==4){//金额转换
	                	
	                }/*else if(e.value==5){
	                	e.record.set('fieldattr','^((\\d)|(1\\d)|(2[0-3])):[0-5]\\d:[0-5]\\d$');
	                    e.record.set('fieldcheck','');  
	                    e.record.set('ismoney','');
	                }else if(e.value==6){
	                	e.record.set('fieldattr','(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29) ^((\\d)|(1\\d)|(2[0-3])):[0-5]\\d:[0-5]\\d$');
	                    e.record.set('fieldcheck','{dateFmt:\'yyyy-MM-dd HH:mm:ss\',alwaysUseStartDate:true}');  
	                    e.record.set('ismoney','');
	                }*/else{
	                    e.record.set('fieldcheck','');
	                    e.record.set('fieldattr','');
	                    e.record.set('ismoney','0');
	                }
	            }
	            else if(e.column==13){
	                if(e.value==2)
	                    e.record.set('docdir','');
				}else if(e.column==16){
					var impcheckvalue = e.value;
					var iscombox=checkexpressionstore.getById(impcheckvalue);
					if (typeof(iscombox) == "undefined"){
				      record.set("checkexpression","");
					}else{
				      e.record.set("checkexpression",iscombox.get('text'));
				    }
				}
			  },
			  'beforeedit' : function(e) {
				  if(e.field !="id" && e.field !="fieldname" && e.field!="fieldlabelname" && e.field != "needlog" && e.field != "needExcel" && e.field != "isprompt"&&e.field!="expendattr"&&e.field!="impcheck"&&e.field!="checkexpression"){
					  e.cancel = true;
				  }
				  var grid = e.grid;
				  var record = e.record;
				  var rowIndex = e.row;
				  var columnIndex = e.column;
				  dynamicSetEditor(grid, record, rowIndex, columnIndex, e);
			  }
			}
		});
		
		function dynamicSetEditor(grid, record, rowIndex, columnIndex, e){
			/*
			if(columnIndex==3){
					grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.ComboBox({
						  typeAhead: true,
						  triggerAction: 'all',
						  store:bstore,
						  mode: 'local',
						  valueField:'value',
						  displayField:'text',
						  lazyRender:true,
						  listClass: 'x-combo-list-small'})));
				}
			*/
			  if(columnIndex==4){
				  if(record.get('htmltype')==1) {   //单行文本
					  grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.ComboBox({
						  typeAhead: true,
						  triggerAction: 'all',
						  store:fieldtypestore,
						  mode: 'local',
						  valueField:'value',
						  displayField:'text',
						  lazyRender:true,
						  listClass: 'x-combo-list-small'})));
				  }else if(record.get('htmltype')==5){   //选择项
					  selectitemtypestore.reload();
					  grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.ux.form.BrowserField({
						  allowBlank: true,
						  store:selectitemtypestore,
						  url:record.get('selurl')
					  })));
				  }else if(record.get('htmltype')==8){   //选择项
					  selectitemtypestore.reload();
					  grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.ux.form.BrowserField({
						  allowBlank: true,
						  store:selectitemtypestore,
						  url:record.get('selurl')
					  })));
				  }else if(record.get('htmltype')==3) {  //关联选择
					  grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.ux.form.BrowserField({
						  allowBlank: true,
						  store:refobjstore,
						  url:record.get('refurl')
					  })));
				  }else if(record.get('htmltype')==7) {  //附件
					  grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.ComboBox({
						  typeAhead: true,
						  triggerAction: 'all',
						  mode: 'local',
						  valueField:'value',
						  displayField:'text',
						  store:attachstore
					  })));
				  }else{
					  grid.getColumnModel().setEditor(columnIndex, null);
				  }


			  }
			  if(columnIndex==5) {
				  if (record.get('htmltype') == 1) {  //单行文本
					  if (record.get('fieldtype')==1) {      //文本
						  if(record.get('fieldattr')=='') {
							   grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new fm.TextField({
							  value:'256',
							  allowBlank: true
						  })));
						  } else{
							  grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new fm.TextField({
							  allowBlank: true ,
							   value:record.get('fieldattr')
						  })));
						  }

					  }else if(record.get('fieldtype')==3){//浮点数
						  grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new fm.TextField({
							  allowBlank: true,
							  value:'',
							  listeners : {       
								change : function(field,newValue,oldValue){
									//更改浮点数的正则表达式验证
									if(newValue == ""){
										newValue = oldValue;
									}
									newValue = parseInt(newValue);
									var newFieldcheck = '^(-?[\\d+]{0,'+(24-newValue)+'})(\\.[\\d+]{0,'+newValue+'})?$';
									record.set('fieldcheck',newFieldcheck);
								}
							  }
						  })));
					  }else if(record.get('fieldtype')==4||record.get('fieldtype')==5||record.get('fieldtype')==6){//日期
						  grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new fm.TextField({
							  value:record.get('fieldattr'),
							  allowBlank: true
						  })));
					  } else {    //其他
						  grid.getColumnModel().setEditor(columnIndex, null);
					  }
				  } else if (record.get('htmltype') == 6) {//关联选择
					  if(record.get('fieldtype')=='C48B871B2F084A7684CD258E85397381'){//节点多选2
						  grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new fm.TextField({
							  allowBlank: true,
								 value:record.get('fieldattr')
						  })));
					  }else{
						  grid.getColumnModel().setEditor(columnIndex, null);
					  }
				  
				  } else {  //其他
					  grid.getColumnModel().setEditor(columnIndex, null);
				  }

			  }
			  if(columnIndex==10){
			  		if(record.get('htmltype') == 3&&(record.get('fieldtype') == 161||record.get('fieldtype') == 162||record.get('fieldtype') == 256||record.get('fieldtype') == 257)){//关联选择
		  				var _fieldid = record.get('id');
		  				var dialogurl = '/formmode/setup/formfieldexpendattr.jsp?fieldid='+_fieldid+'&fieldtype='+record.get('fieldtype')+'&formid=<%=formId%>';
						grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.ux.form.Expendattr({
			                  allowBlank: true,
			                  storeRecord: record,
			                  store:expendattrStore,
			                  editgrid : grid,
			                  valueField:'value',
	                 		  displayField:'text',
			                  url:dialogurl
	                      })));
			  		}else{
		                	e.cancel = true;
							grid.getColumnModel().setEditor(columnIndex, new fm.TextField({
				                   allowBlank: true
			               	}));
					 }
			  }
				if(columnIndex==12){
					  if (record.get('htmltype') == 1) {  //单行文本
						if(record.get('fieldtype') == 3) {
							grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.ComboBox({
								typeAhead: true,
								triggerAction: 'all',
								store: isstore,
								mode: 'local',
								valueField:'value',
								displayField:'text',
								lazyRender:true,
								listClass: 'x-combo-list-small'})));
						} else{
						grid.getColumnModel().setEditor(columnIndex, null);
						}
					  }else{
							grid.getColumnModel().setEditor(columnIndex, null);
					  }
				}
				  if(columnIndex==13){
					  if (record.get('htmltype') == 6) {
						if(record.get('fieldtype') == '402881e70bc70ed1010bc710b74b000d') {
							grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.ComboBox({
								typeAhead: true,
								triggerAction: 'all',
								store: isselectstore,
								mode: 'local',
								valueField:'value',
								displayField:'text',
								lazyRender:true,
								listClass: 'x-combo-list-small'})));
						} else{
						grid.getColumnModel().setEditor(columnIndex, null);
						}
					  }else{
							grid.getColumnModel().setEditor(columnIndex, null);
					  }
				}
				if(columnIndex==14){
						  if (record.get('htmltype') == 6) {
						if(record.get('fieldtype') == '402881e70bc70ed1010bc710b74b000d'&&record.get('isselect')!=2) {
							  grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.ux.form.BrowserField({
						  allowBlank: true,
						  store:categorystore,
						  url:record.get('docdirurl')
					  })));
						} else{
						grid.getColumnModel().setEditor(columnIndex, null);
						}
					  }else{
							grid.getColumnModel().setEditor(columnIndex, null);
					  }
				}
				if(columnIndex==15){
					   if (record.get('htmltype') == 1||record.get('htmltype') == 5) {
							  grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.ComboBox({
								typeAhead: true,
								triggerAction: 'all',
								store: isstore,
								mode: 'local',
								valueField:'value',
								displayField:'text',
								lazyRender:true,
								listClass: 'x-combo-list-small'})));
					  }else{
							grid.getColumnModel().setEditor(columnIndex, null);
					  }
				}

				if(columnIndex==16){
					if(record.get("fieldname")!='id'){
					grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.ComboBox({
								typeAhead: true,
								triggerAction: 'all',
								store: impcheckstore,
								mode: 'local',
								valueField:'value',
								displayField:'text',
								lazyRender:true,
								listClass: 'x-combo-list-small'})));
					
				     }
					
				}
				if(columnIndex==17){
					if(record.get('impcheck') != '0'&&record.get('impcheck') != '' && record.get('impcheck') != undefined && record.get('impcheck') != 'undefined'){
						grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.TextField({
			        		allowBlank: true
				   	 	})));
			   	 	}else{
			   	 		e.cancel = true;
               			grid.getColumnModel().setEditor(columnIndex, null);
			   	 	}
					
				}
		}
			grid.on("cellclick",function (grid, rowIndex, columnIndex, e) {
					var record = grid.store.getAt(rowIndex);
					dynamicSetEditor(grid, record, rowIndex, columnIndex, e);
			});
			
			addGridToQueue(containerId, grid);
			return grid;
		}
		
		var currentContainerId = "tabs-center-0";
		function addField(){
	              var p = new Plant({
	              	  id: '',
	                  fieldname: '',
	                  label: '',
	                  htmltype: '',
	                  fieldtype: '',
	                  fieldattr: '',
	                  fieldcheck: '',
	                  labelname:'',
	                  fieldlabelname:'',
	                  ismoney:'',
	                  only:'0',
	                  needlog:'0',
	                  needExcel:'0',
	                  isprompt:'0',
	                  refurl:'/base/refobj/refobjbrowser.jsp?moduleid=402880483874376b0138a7641b49343e' ,
	                  selurl:'/base/selectitem/selectitemtypebrowser.jsp?moduleid=402880483874376b0138a7641b49343e',
	                  docdirurl:'/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id=4028819b124662b301125662b73603e7',
	                   id:'',
	                  isselect:'',
	                  ordernum:'0'
	              });

	              var grid = gridQueue[gridIndexOfQueue(currentContainerId)].grid;
	              grid.stopEditing();
	              grid.store.insert(0, p);
	              grid.startEditing(0, 0);
	          }
		
		var gridQueue = new Array();	//表格队列
		var storeArray = new Array();
		
		function gridIndexOfQueue(containerId){
			var result = -1;
			for(var i = 0; i < gridQueue.length; i++){
				if(gridQueue[i]["containerId"] == containerId){
					result = i;
					break;
				}
			}
			return result;
		}
		
		function addGridToQueue(containerId, grid){
			if(gridIndexOfQueue(containerId) == -1){
				var q = {"containerId":containerId, "grid":grid};
				gridQueue.push(q);
			}
		}
		
		function removeGridOfQueue(containerId){
			var i = gridIndexOfQueue(containerId);
			if(i == -1){
				return;
			}
			gridQueue.splice(i, 1);
		}
		
		function resizeGridHeight(containerId){
			var i = gridIndexOfQueue(containerId);
			if(i == -1){
				return;
			}
			var grid = gridQueue[i]["grid"]; 
			grid.setHeight($("#" + containerId).height());  
		}
		
		function storeIndexOfArray(containerId){
			var result = -1;
			for(var i = 0; i < storeArray.length; i++){
				if(storeArray[i]["containerId"] == containerId){
					result = i;
					break;
				}
			}
			return result;
		}
		
		function addStoreToArray(containerId, store){
			if(storeIndexOfArray(containerId) == -1){
				var a = {"containerId":containerId, "store":store};
				storeArray.push(a);
			}
		}
		
		function removeStoreOfArray(containerId){
			var i = storeIndexOfArray(containerId);
			if(i == -1){
				return;
			}
			storeArray.splice(i, 1);
		}
		 
		$(document).ready(function () {
			var tabs = $(".e8_formfield_tabs").tabs({
				active: 0,
	 			activate: function (event, ui) {
	 				var containerId = (ui.newPanel).attr("id");
	 				currentContainerId = containerId;
	 				var storeIndex = storeIndexOfArray(containerId);
	 				if(storeIndex != -1){
	 					var store = storeArray[storeIndex]["store"];
	 					var grid = createAGridIfNotExist(containerId, store);
	 					if(grid == null){	//表格已创建了
	 						resizeGridHeight(containerId);
	 					}
	 				}else{
	 					resizeGridHeight(containerId);
	 				}
	 			}
			});
			
			tabs.delegate( "span.ui-icon-close", "click", function() {
				var panelId = $( this ).closest( "li" ).remove().attr( "aria-controls" );
				$( "#" + panelId ).remove();
				
				removeGridOfQueue(panelId);
				removeStoreOfArray(panelId);
				
				tabs.tabs( "refresh" );
				
				postionAddTabIcon();
			});
			
			forPageResize();
			
			$(window).resize(function(){  
	  			forPageResize();
	  			var activeTabIndex = $(".e8_formfield_tabs").tabs("option", "active");
				var activeTabId = $(".e8_formfield_tabs .ui-tabs-panel:eq("+activeTabIndex+")").attr("id");
				resizeGridHeight(activeTabId);
			});
			
			//主表
			var demoJSONData = <%=formInfoService.getAllFieldJSON(formId, "")%>;
			//明细表
			<%for(int i=1;i<=detailTables.size();i++){
				String detailTablename = Util.null2String(detailTables.get(i-1).get("tablename"));
			%>
			var demoJSONData<%=i%> = <%=formInfoService.getAllFieldJSON(formId, detailTablename)%>;
			<%}%>
			
			
			var store = new Ext.data.JsonStore({
				storeId:"storeId",
				data: demoJSONData,
				autoLoad:true,
				root:'result',
				fields: ['id','fieldname','label','htmltype','fieldtype','fieldattr','fieldcheck','labelname','fieldlabelname','ordernum','only','needlog','needExcel','id','docdir','docdirurl','selurl','refurl','fieldtype1','isprompt','ismoney','isencryption','isselect','expendattr','impcheck','checkexpression']
			});
			addStoreToArray("tabs-center-0", store);
			
			<%for(int i=1;i<=detailTables.size();i++){%>
			var store<%=i%> = new Ext.data.JsonStore({
				storeId:"storeId<%=i%>",
				data: demoJSONData<%=i%>,
				autoLoad:true,
				root:'result',
				fields: ['id','fieldname','label','htmltype','fieldtype','fieldattr','fieldcheck','labelname','fieldlabelname','ordernum','only','needlog','needExcel','id','docdir','docdirurl','selurl','refurl','fieldtype1','isprompt','ismoney','isencryption','isselect','expendattr','impcheck','checkexpression']
			});
			addStoreToArray("tabs-center-<%=i%>", store<%=i%>);
			<%}%>
			
			createAGridIfNotExist("tabs-center-0", store);
			
			postionAddTabIcon();
		});
		
		function postionAddTabIcon(){
			var t = 0;
			$(".e8_formfield_tabs .ui-tabs-nav li").each(function(){
				t += $(this).outerWidth(true);
			});
			$(".e8_formfield_addTab").css("left", parseInt(t, 10) + "px");
		}
		
		var formCount = <%=detailTables.size()+1%>;
		
		function addFormTab(){
			var tabid = "tabs-center-" + (formCount + 1);
			var tabLabel = "<%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%>" + formCount;//明细表
			
			var tabs = $(".e8_formfield_tabs");
			
			var tabTemplate = "";
			var li = "<li><a href='#"+tabid+"'>"+tabLabel+"<span class='ui-icon ui-icon-close' role='presentation'></span></a></li>";
			
			tabs.find(".ui-tabs-nav" ).append(li);
			tabs.append( "<div id='" + tabid + "'></div>" );
			tabs.tabs( "refresh" );
			
			postionAddTabIcon();
			
			forPageResize();
			
			addStoreToArray(tabid, createEmptyStore());
			
			tabs.tabs("option", "active", (tabs.find(".ui-tabs-nav" ).children("li").length - 1));
			
			formCount++;
		}
		
		function createEmptyStore(){
			var emptyStore = new Ext.data.JsonStore({
				data: {"totalcount":0,"result":[]},
				autoLoad:true,
				root:'result',
				fields: ['id','fieldname','label','htmltype','fieldtype','fieldattr','fieldcheck','labelname','fieldlabelname','ordernum','only','needlog','needExcel','id','docdir','docdirurl','selurl','refurl','fieldtype1','isprompt','ismoney','isencryption','isselect']
			});
			return emptyStore;
		}
		
		function onSave(){
			var modifiedDatas = new Array();
			for(var i = 0; i < storeArray.length; i++){
				var store = storeArray[i]["store"];
				var modifiedRecords = store.getModifiedRecords();
				for (j = 0; j < modifiedRecords.length; j++) {
					modifiedDatas.push(modifiedRecords[j].data);
				}
			}
			if(modifiedDatas.length == 0){
				rightMenu.style.visibility = "hidden";
				return;
			}
			var jsonstr = Ext.util.JSON.encode(modifiedDatas);
			//escape(jsonstr)
			enableAllmenu();
			var paramData = {"data": encodeURI(jsonstr), "formId": "<%=formId%>"};
	    	var url = "/formmode/setup/formSettingsAction.jsp?action=saveFormfield";
	    	FormmodeUtil.doAjaxDataSave(url, paramData, function(res){
	    		if(res == "1"){
	    			window.location.reload(); 
	    		}else if(res == "0"){
	    			alert("error");
	    		}
	    	});
		}
		
		function createForm(){
			rightMenu.style.visibility = "hidden";
			parent.parent.createForm();
		}
		
		function commonCheckboxClick(obj,recordid,rowIndex,dataIndex,isSelectRow,storeId){
			var ostore;
			for(var i = 0; i < storeArray.length; i++){
				var store = storeArray[i]["store"];
				if(store.storeId==storeId){
					ostore=store;
					break;
				}
			}
			var record=ostore.getById(recordid);
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
		
		function toformtab(){
			var formid = "<%=formId %>";
		    if (<%=isvirtualform%> == 1) {
		        top.$(".subMenu").removeClass("subMenuSelected");
				top.$(".subMenu").each(function(i){
					if (i == 2)
						top.$(this).addClass("subMenuSelected");
				});
		    	top.changeFormModuleUrl('/formmode/setup/formSettings.jsp?formid='+formid);
		    } else {
				var parm = "&formid="+formid;
				if(formid=='') 
					parm = '';
				diag_vote = new window.top.Dialog();
				diag_vote.currentWindow = window;	
				diag_vote.Width = 1000;
				diag_vote.Height = 600;
				diag_vote.Modal = true;
				diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82021,user.getLanguage())%>";//新建表单
				diag_vote.URL = "/workflow/form/addDefineForm.jsp?dialog=1&isFromMode=1"+parm;
				diag_vote.isIframe=false;
				diag_vote.show();
			}
		}
	</script>
	
</head>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
    <%
    	if(operatelevel>0){
		    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
		    RCMenuHeight += RCMenuHeightStep ;
		    
		    RCMenu += "{"+SystemEnv.getHtmlLabelName(82022,user.getLanguage())+",javascript:toformtab(),_self} " ;//编辑表单
		    RCMenuHeight += RCMenuHeightStep ;
		    
		    RCMenu += "{"+SystemEnv.getHtmlLabelName(82106,user.getLanguage())+",javascript:createForm(),_top} " ;//新建虚拟表单
		    RCMenuHeight += RCMenuHeightStep ;
    	}
	%>
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
	
	<div class="e8_formfield_tabs">
		<!-- <div class="e8_formfield_addTab" onclick="javascript: addFormTab()"></div>  -->
		<UL>
			<LI><A href="#tabs-center-0"><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></A></LI><!-- 主表 -->
			<%
			for(int i=1;i<=detailTables.size();i++){
			%>
			<LI><A href="#tabs-center-<%=i %>"><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><%=i %></A></LI><!-- 明细表 -->
			<%} %>
		</UL>
		
		<DIV id="tabs-center-0"></DIV>
		<%
		for(int i=1;i<=detailTables.size();i++){
		%>
		<DIV id="tabs-center-<%=i %>"></DIV>
		<%} %>
	</div>

</body>
</html>