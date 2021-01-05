<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.formmode.service.FormInfoService"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="weaver.interfaces.workflow.browser.Browser"%>
<%@page import="weaver.parseBrowser.SapBrowserComInfo"%>
<%@ include file="/formmode/pub.jsp"%>
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
int formId = Util.getIntValue(request.getParameter("id"), 0);
FormInfoService formInfoService = new FormInfoService();
Map<String, Object> formInfo = formInfoService.getFormInfoById(formId);
boolean isvirtualform = formInfoService.isVirtualForm(formInfo);
String mainTablename = Util.null2String(formInfo.get("tablename"));

List<Map<String, Object>> allFields = formInfoService.getAllField(formId);

List<Map<String, Object>> detailTables = formInfoService.getAllDetailTable(formId);
formInfoService.setUser(user);
JSONArray browserArr = formInfoService.getBrowserInfoWithJSON();

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
	<script type="text/javascript" src="/formmode/js/ext/ux/selectitemeditfield_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ux/pubselectitemeditfield_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ux/attachpiceditfield_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ux/specialeditfield_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ux/columnLock_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ux/browserfield_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ux/browserpiceditfield_wev8.js?v=<%=System.currentTimeMillis() %>"></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
	<script language=javascript src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
	<link rel="stylesheet" type="text/css" href="/formmode/js/ext/ux/css/columnLock_wev8.css"/>
	
	<script language="javascript" type="text/javascript" src="/js/init_wev8.js"></script>
	<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
	
	<link type="text/css" rel="stylesheet" href="/formmode/js/jquery/jquery-ui-1.10.3/themes/base/jquery.ui.all_wev8.css" />
	<script type="text/javascript" src="/formmode/js/jquery/jquery-ui-1.10.3/ui/minified/jquery-ui.min_wev8.js"></script>
	<!-- 
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET> -->
	
	<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET> <!-- 为选择项编辑表格移植的css -->
	<script type="text/javascript" src="/formmode/js/ext/ux/showexpendattr_wev8.js"></script>
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
			color: #a3a3a3;
			
		}
		.e8_formfield_tabs .ui-tabs-nav li a:hover{

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
		
		.x-combo-list-small .x-combo-list-item, .x-combo-list-item{
			font-size: 11px;
			font-family: Microsoft YaHei;
		}
		.x-small-editor .x-form-field{
			font-size: 11px;
			font-family: Microsoft YaHei;
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
		
		table.liststyle td{
			color: #929393;
			border-bottom: 1px solid #DADADA;
			padding: 5px 0px;
		}
		
		.x-form-editor-trigger{
		/*
			background:transparent url("/formmode/js/ext/resources/images/default/editor/tb-sprite_wev8.gif") no-repeat !important;
			background-position:-192px 0px !important;*/
			background:transparent url("/formmode/images/list_edit_wev8.png") no-repeat !important;
			background-position:1px 1px !important;
			border-bottom: none !important;
		}
		.x-form-textarea{
			margin-bottom: 0px !important;
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
			//data: [['1','单行文本框'],['2','多行文本框'],['3','浏览按钮'],['4','CHECK框'],['5','选择框'],['8','公共选择框'],['6','附件上传'],['7','特殊字段']]
			data: [
					['1','<%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%>'],['2','<%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%>'],['3','<%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%>'],['4','<%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%>'],
					['5','<%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%>'],
					['8','<%=SystemEnv.getHtmlLabelName(82477,user.getLanguage())%>'],
					['6','<%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%>'],
					['7','<%=SystemEnv.getHtmlLabelName(21691,user.getLanguage())%>']
			]
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
		var attachstore=new Ext.data.SimpleStore({
			id:0,
			fields:['value', 'text'],
			//data: [['1','上传文件'],['2','上传图片']]
			data: [['1','<%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%>'],['2','<%=SystemEnv.getHtmlLabelName(20001,user.getLanguage())%>']]
		});
		
		var isHtmlEditorStore = new Ext.data.SimpleStore({
			id:0,
			fields:['value', 'text'],
			//data: [['1','否'],['2','是']]
			data: [['1','<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>'],['2','<%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>']]
		});
		var expendattrStore = new Ext.data.SimpleStore({
			id:0,
			fields: ['value', 'text'], 
			data:[]
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
		
		var customBrowserStore = new Ext.data.SimpleStore({
			id:0,
			fields:['value', 'text'],
			data: [
					<%
					List l=StaticObj.getServiceIds(Browser.class);
					for(int j=0;j<l.size();j++){
						if(j>0){
							out.print(",");
						}
					%>
						['<%=l.get(j)%>','<%=l.get(j)%>']
					<%}%>
				]
		});
		
		var SapBrowserStore = new Ext.data.SimpleStore({
			id:0,
			fields:['value', 'text'],
			data: [
					<%
					SapBrowserComInfo sapBrowserComInfo = new SapBrowserComInfo();
					List AllBrowserId=sapBrowserComInfo.getAllBrowserId();
					for(int j=0;j<AllBrowserId.size();j++){
						if(j>0){
							out.print(",");
						}
					%>
						['<%=AllBrowserId.get(j)%>','<%=AllBrowserId.get(j)%>']
					<%}%>
				]
		});
		
		var browserStore = new Ext.data.SimpleStore({
			id:0,
			fields:['value', 'text'],
			//data: [['0','aaaaa'],['1','bbbbb'],['2','ccccc']]
			data: <%=browserArr%>
		});
		
		var specialFieldStore = new Ext.data.SimpleStore({
			id:0,
			fields:['value', 'text'],
			//data: [['1','自定义链接'],['2','描述性文字']]
			data: [['1','<%=SystemEnv.getHtmlLabelName(21692,user.getLanguage())%>'],['2','<%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%>']]
		});
		
		function fieldtypeRender(value, m, record, rowIndex, colIndex){
			if(record.get("htmltype")==5||record.get("htmltype")==8){ //选择框
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
		
		function htmltypeRender(value, m, record, rowIndex, colIndex) {
	         var htmltypecombox = bstore.getById(value);
	         if (typeof(htmltypecombox) == "undefined")
	             return ''
	         else
	             return htmltypecombox.get('text');
		}
		
		function isRender(value, cellmeta, record, rowIndex, columnIndex, ostore){
		    var checked;
			if(value==1){
				checked="checked='checked'";
			}else{
				checked='';
			}
			return "<input type='checkbox' class='checkboxcommon' onclick=commonCheckboxClick(this,"+record.id+","+rowIndex+",'needlog',false,'"+ostore.storeId+"') "+checked+"></input>";
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

		function directoryRender(value, m, record, rowIndex, colIndex){
		     var docdirectory=categorystore.getById(value);
		     if (typeof(docdirectory) == "undefined")
		         return ''
		     else
		         return docdirectory.get('text');
		}
      	function isExpendattr(value, cellmeta, record, rowIndex, columnIndex){
			return value;
		}
		function fieldattrrender(value, m, record, rowIndex, colIndex){
			var str;
			if(record.get("htmltype")==1){
				if(record.get("fieldtype")==1){
					if(value!='')
           			str= '<%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%>:'+value;//文本长度
	        	}else if(record.get("fieldtype")==3 ){
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
			}else if(record.get("htmltype")==2){ //多行文本
				var isHtmlEditor = isHtmlEditorStore.getById(value);
				var hText;
				if(typeof(isHtmlEditor) == "undefined"){
					hText = "<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>";//否
				}else{
					hText = isHtmlEditor.get('text');
				}
	        	str = "Html<%=SystemEnv.getHtmlLabelName(15449,user.getLanguage())%>：" + hText;
	        }else if(record.get("htmltype")==3){ //浏览按钮--
	        	 if(record.get('fieldtype')==161||record.get('fieldtype')==162||record.get('fieldtype')==224){
		        	str = value;
	        	 }else if(record.get('fieldtype')==256||record.get('fieldtype')==257){
		        	var customBrowserTree=customBrowserTreeStore.getById(value);
					if (typeof(customBrowserTree) == "undefined"){
						return "";	
					}else{
						return customBrowserTree.get('text');	
					}
	        	 }
	        }else if(record.get("htmltype")==6){ //附件
	        	if(value == null || typeof(value) == "undefined"){
	        		value = "";
	        	}
	        	if(record.get("fieldtype")==2){	//上传图片
		        	var vArr = value.split(";");
		        	var v1 = vArr.length > 0 ? vArr[0] : "";
		        	var v2 = vArr.length > 1 ? vArr[1] : "";
		        	var v3 = vArr.length > 2 ? vArr[2] : "";
		        	str = "<%=SystemEnv.getHtmlLabelName(82118,user.getLanguage())%>:" + v1;//每行
		        	str += " <%=SystemEnv.getHtmlLabelName(26901,user.getLanguage())%>:" + v2;//宽
		        	str += " <%=SystemEnv.getHtmlLabelName(27734,user.getLanguage())%>:" + v3;//高
	        	}else{
	        		str= value;
	        	}
	        }else if(record.get("htmltype")==7){ //特殊字段
	        	if(value == null || typeof(value) == "undefined"){
	        		value = "";
	        	}
	        	if(record.get("fieldtype")==1 && value != ""){	//自定义链接
		        	var vArr = value.split(";");
		        	var v1 = vArr.length > 0 ? vArr[0] : "";
		        	var v2 = vArr.length > 1 ? vArr[1] : "";
		        	str = " <%=SystemEnv.getHtmlLabelName(606,user.getLanguage())%>:" + v1;//显示名
		        	str += " <%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%>:" + v2;//链接地址
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
		
		function dynamicSetEditor(grid, record, rowIndex, columnIndex, e){
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
				  }else if(record.get('htmltype')==5){   //选择框
					  grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.ux.form.SelectitemEditField({
						  allowBlank: true,
						  rowIndex: rowIndex,
						  storeRecord: record,
						  editgrid : grid,
						  formtablename: record.get("formtablename")
					  })));
					  
					  if(jQuery("img.x-form-editor-trigger").length > 0){
						  jQuery("img.x-form-editor-trigger").attr("src","/formmode/images/blank_wev8.gif");
					  }
				  }else if(record.get('htmltype')==8){   //公共选择框
					  grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.ux.form.PubSelectitemEditField({
						  allowBlank: true,
						  rowIndex: rowIndex,
						  storeRecord: record,
						  editgrid : grid,
						  formtablename: record.get("formtablename")
					  })));
					  
					  if(jQuery("img.x-form-editor-trigger").length > 0){
						  jQuery("img.x-form-editor-trigger").attr("src","/formmode/images/blank_wev8.gif");
					  }
				  }else if(record.get('htmltype')==3) {  //浏览按钮 modify by cjl 2015-12-07
					  grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.ux.form.BrowserpicEditField({
						  allowBlank: true,
						  rowIndex: rowIndex,
						  storeRecord: record,
						  editgrid : grid,
						  formtablename: record.get("formtablename")
					  })));
					  if(jQuery("img.x-form-editor-trigger").length > 0){
						  jQuery("img.x-form-editor-trigger").attr("src","/formmode/images/blank_wev8.gif");
					  }
				  }else if(record.get('htmltype')==6) {  //附件
					  grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.ComboBox({
						  typeAhead: true,
						  triggerAction: 'all',
						  mode: 'local',
						  valueField:'value',
						  displayField:'text',
						  store:attachstore
					  })));
				  }else if(record.get('htmltype')==2) {   //多行文本
					  grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.TextField({
					  	   value:record.get('fieldtype'),
						   allowBlank: true
					  })));
				  }else if(record.get('htmltype')==7) {  //特殊字段
					  grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.ComboBox({
						  typeAhead: true,
						  triggerAction: 'all',
						  mode: 'local',
						  valueField:'value',
						  displayField:'text',
						  store:specialFieldStore
					  })));
				  }else{
					  e.cancel = true;
					  grid.getColumnModel().setEditor(columnIndex, null);
				  }


			  }
			  if(columnIndex==5) {
				  if (record.get('htmltype') == 1) {  //单行文本
					  if (record.get('fieldtype')==1) {      //文本
						  if(record.get('fieldattr')=='') {
							   grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.TextField({
							  value:'256',
							  allowBlank: true
						  })));
						  } else{
							  grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.TextField({
							  allowBlank: true ,
							   value:record.get('fieldattr')
						  })));
						  }

					  }else if(record.get('fieldtype')==3){//浮点数
						  grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.TextField({
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
					  } else {    //其他
						  grid.getColumnModel().setEditor(columnIndex, null);
					  }
				  }else if(record.get('htmltype') == 2){//多行文本
					  grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.ComboBox({
						  typeAhead: true,
						  triggerAction: 'all',
						  mode: 'local',
						  valueField:'value',
						  displayField:'text',
						  store:isHtmlEditorStore
					  })));
				  }else if(record.get('htmltype') == 3){//浏览按钮--
					  if(record.get('fieldtype')==161||record.get('fieldtype')==162){
						  grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.ux.form.BrowserField({
							  allowBlank: true,
							  editgrid : grid,
							  url:"/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp",
							  callbackfun:setBrowserfieldVal,
							  callbackfunParam:{record:record,dataIndex:'fieldattr'}
						  })));
					  }else if(record.get('fieldtype')==224){
						  grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.ComboBox({
							  typeAhead: true,
							  triggerAction: 'all',
							  mode: 'local',
							  valueField:'value',
							  displayField:'text',
							  store:SapBrowserStore
						  })));
					  }else if(record.get('fieldtype')==256||record.get('fieldtype')==257){
						  grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.ux.form.BrowserField({
							  allowBlank: true,
							  editgrid : grid,
							  url:"/systeminfo/BrowserMain.jsp?url=/formmode/tree/treebrowser/TreeBrowser.jsp",
							  callbackfun:setBrowserfieldVal,
							  callbackfunParam:{record:record,dataIndex:'fieldattr'}
						  })));
					  }else{
						  e.cancel = true;
					  	  grid.getColumnModel().setEditor(columnIndex, null);
					  }
				  }else if (record.get('htmltype') == 6) {//附件
					  if(record.get('fieldtype')==2){//上传图片
						  grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.ux.form.AttachpicEditField({
							  allowBlank: true,
							  rowIndex: rowIndex,
							  storeRecord: record,
							  editgrid : grid
						  })));
					  }else{
						  e.cancel = true;
						  grid.getColumnModel().setEditor(columnIndex, null);
					  }
				  
				  }else if(record.get('htmltype') == 7){ //特殊字段
					  if(record.get('fieldtype')==1){ //自定义链接
						  grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.ux.form.SpecialEditField({
							  allowBlank: true,
							  rowIndex: rowIndex,
							  storeRecord: record,
							  editgrid : grid
						  })));
					  }else if(record.get('fieldtype')==2){//描述性文字
						  grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.TextArea({
							  value:record.get('fieldattr'),
							  allowBlank: true
						  })));
					  }
				  }else {  //其他
					  e.cancel = true;
					  grid.getColumnModel().setEditor(columnIndex, null);
				  }

			  }
			  if(columnIndex==8){
			  		if(record.get('htmltype') == 3&&(record.get('fieldtype') == 161||record.get('fieldtype') == 162||record.get('fieldtype') == 256||record.get('fieldtype') == 257)){
		  				var _fieldid = record.get('id');
		  				var dialogurl = '/formmode/setup/formfieldexpendattr.jsp?fieldid='+_fieldid+'&fieldtype='+record.get('fieldtype') +'&formid=<%=formId%>';
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
							//grid.getColumnModel().setEditor(columnIndex, null);
							grid.getColumnModel().setEditor(columnIndex, new Ext.form.TextField({
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
		}
		
		var readonlyColumnStyle="color:#AAAAAA;";
		
		function createAGridIfNotExist(containerId, store){
			if(gridIndexOfQueue(containerId) != -1){
				return null;
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
               id:'htmltype',
               header: "<%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%>",//字段名称
               dataIndex: 'fieldname',
               locked:true,
               width:180,
               css:readonlyColumnStyle,
               editor: new fm.TextField({
                   allowBlank: false,
                   readOnly:true
               })
           },
           {
             header: "<%=SystemEnv.getHtmlLabelName(30828,user.getLanguage())%>",//显示名称
             dataIndex: 'fieldlabelname',
             width:180,
             locked:true,
             editor: new fm.TextField({
             	allowBlank: true
             })
          },
          {
              header: "<%=SystemEnv.getHtmlLabelName(82112,user.getLanguage())%>",//UI组件
              dataIndex: 'htmltype',
              width:140,
              renderer:htmltypeRender
          },{
              header: "<%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%>",//字段类型
              dataIndex:'fieldtype',
              width:120 ,
              renderer:fieldtypeRender
          },{
             header: "<%=SystemEnv.getHtmlLabelName(82113,user.getLanguage())%>",//字段属性
             dataIndex: 'fieldattr',
               width:150,
              renderer:fieldattrrender
          },{
              header: "<%=SystemEnv.getHtmlLabelName(82114,user.getLanguage())%>",//记录日志
              dataIndex:'needlog',
              width:100,
              hidden:true,
              renderer:isRender
          },{
              header: "<%=SystemEnv.getHtmlLabelName(82115,user.getLanguage())%>",//数据提醒
              dataIndex:'isprompt',
              width:100,
              hidden:true,
              renderer:isRenderFromIsprompt 
          },{
          	  header: "<%=SystemEnv.getHtmlLabelName(124938,user.getLanguage())%>",//字段扩展
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
              width:120,
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

          }
          ,{

             header: "formtablename",
             dataIndex:'formtablename',
             hidden:true

          }
      ]);

      Plant = Ext.data.Record.create([
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
          {name: 'isprompt'},
          {name: 'expendattr'},
          {name: 'ismoney'},
          {name: 'isencryption'},
          {name:'isselect'},
          {name: 'selurl',type:'string'},
          {name: 'refurl',type:'string'},
          {name: 'docdir',type:'string'},
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
		        	var record = e.record;
		            if(e.column==3 ){
		                if(e.value==1){
			                e.record.set('fieldtype','1');
			                e.record.set('fieldattr','256');
			                e.record.set('fieldcheck','');
			                e.record.set('isselect','');
			                e.record.set('isprompt','0');  
		                }else if(e.value==2){	//多行文本
		                	e.record.set('fieldtype','4');
			                e.record.set('fieldattr','0');
			                e.record.set('isprompt','');  
		                }else if(e.value==6){	//附件
		                	e.record.set('fieldtype','1');
			                e.record.set('fieldattr','');
			                e.record.set('fieldcheck','');
			                e.record.set('isselect','');
				            e.record.set('isencryption','');
				            e.record.set('isprompt','');  
		                }else if(e.value==7){	//特殊字段
		                	e.record.set('fieldtype','1');
		                	e.record.set('fieldattr','');
		                	e.record.set('isprompt','');  
		                }else if(e.value!=1&&e.value!=5){
		                	e.record.set('fieldtype','');
			                e.record.set('fieldattr','');
			                e.record.set('fieldcheck','');
			                e.record.set('isselect','');
				            e.record.set('isencryption','');
				            e.record.set('isprompt','');  
		                }else{
			                e.record.set('fieldtype','');
			                e.record.set('fieldattr','');
			                e.record.set('fieldcheck','');
			                e.record.set('isselect','');
			                e.record.set('isprompt','');  
		                }
		
						
		
		            }
		            else if (e.column ==4 ) {
		            	if(record.get('htmltype')==1){
			                if(e.value==1){  //当为文本时 字段属性的值是256
			                    e.record.set('fieldattr','256');
			                    e.record.set('fieldcheck','');  
			                    e.record.set('ismoney','0');
			
			                }else if(e.value==2){    //当为整数时 字段验证有默认值
			                    e.record.set('fieldcheck','^-?\\d+$');
			                    e.record.set('fieldattr','');
			                    e.record.set('ismoney','0');
			
			
			                }else if(e.value==3){//浮点数
			                    e.record.set('fieldcheck','^(-?[\\d+]{0,22})(\\.[\\d+]{0,2})?$');
			                    e.record.set('fieldattr','2');
			                    e.record.set('ismoney','0');
			                }else if(e.value==4){//金额转换
			                	e.record.set('fieldattr','');
			                	e.record.set('ismoney','');
			                }else if(e.value==5){//金额千分位
			                	 e.record.set('fieldcheck','^(-?[\\d+]{0,22})(\\.[\\d+]{0,2})?$');
			                	 e.record.set('fieldattr','');
			                }else{
			                    e.record.set('fieldcheck','');
			                    e.record.set('fieldattr','');
			                    e.record.set('ismoney','');
			                }
		                }else if(record.get('htmltype')==6){	//附件
		                	if(e.value == 2){	//上传图片
		                		e.record.set('fieldattr','5;100;100');
		                	}else{
		                		e.record.set('fieldattr','');
		                	}
		                	e.record.set('isprompt','');
		                }else{
		                	e.record.set('fieldattr','');
		                	e.record.set('isprompt','');
		                }
		            }
		            else if(e.column==13){
		                if(e.value==2)
		                    e.record.set('docdir','');
					}
				  },
				  'beforeedit' : function(e) {
					  var grid = e.grid;
					  var record = e.record;
					  var columnIndex = e.column;
					  var rowIndex = e.row;
					  if(columnIndex==5){
						  if(record.get('htmltype')==1&&record.get('fieldtype')==5){
							  return false;
						  }
					  }
					  dynamicSetEditor(grid, record, rowIndex, columnIndex, e);
				  }
				}
			});
		
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
			var demoJSONData = <%=formInfoService.getAllFieldJSON(allFields, "", formId)%>;
			for(var i = 0; i < demoJSONData.result.length; i++){
				var jData = demoJSONData.result[i];
				jData["formtablename"] = "<%=mainTablename%>";
			}
			
			//明细表
			<%for(int i=1;i<=detailTables.size();i++){
				String detailTablename = Util.null2String(detailTables.get(i-1).get("tablename"));
			%>
			var demoJSONData<%=i%> = <%=formInfoService.getAllFieldJSON(allFields, detailTablename,formId)%>;
			for(var i = 0; i < demoJSONData<%=i%>.result.length; i++){
				var jData = demoJSONData<%=i%>.result[i];
				jData["formtablename"] = "<%=detailTablename%>";
			}
			<%}%>
			
			
			var store = new Ext.data.JsonStore({
				storeId:"storeId",
				data: demoJSONData,
				autoLoad:true,
				root:'result',
				fields: ['fieldname','label','htmltype','fieldtype','fieldattr','fieldcheck','labelname','fieldlabelname','ordernum','only','needlog','id','docdir','docdirurl','selurl','refurl','fieldtype1','isprompt','ismoney','isencryption','isselect','formtablename','expendattr']
			});
			addStoreToArray("tabs-center-0", store);
			
			<%for(int i=1;i<=detailTables.size();i++){%>
			var store<%=i%> = new Ext.data.JsonStore({
				storeId:"storeId<%=i%>",
				data: demoJSONData<%=i%>,
				autoLoad:true,
				root:'result',
				fields: ['fieldname','label','htmltype','fieldtype','fieldattr','fieldcheck','labelname','fieldlabelname','ordernum','only','needlog','id','docdir','docdirurl','selurl','refurl','fieldtype1','isprompt','ismoney','isencryption','isselect','formtablename','expendattr']
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
				fields: ['fieldname','label','htmltype','fieldtype','fieldattr','fieldcheck','labelname','fieldlabelname','ordernum','only','needlog','id','docdir','docdirurl','selurl','refurl','fieldtype1','isprompt','ismoney','isencryption','isselect']
			});
			return emptyStore;
		}
		
		function onSave(){
			var modifiedDatas = new Array();
			for(var i = 0; i < storeArray.length; i++){
				var store = storeArray[i]["store"];
				var modifiedRecords = store.getModifiedRecords();
				for (j = 0; j < modifiedRecords.length; j++) {
					var record = modifiedRecords[j];
					var r_index = store.indexOf(record); 
					var r_data = record.data;
					
					var sel_data = {};

					if(record.get('htmltype')==5){	//选择框
						var theFormtablename = record.get('formtablename');
						var $selitemContainer = $("#SeleteItem_" + theFormtablename + "_" + r_index);
						if($selitemContainer.length != 0){
							var childfieldid = $("#childfieldid_" + r_index, $selitemContainer).val();
							sel_data["childfieldid"] = childfieldid;
							
							var $choiceTable = $("#choiceTable_" + r_index, $selitemContainer);
							var rowsum = $choiceTable[0].rows.length - 1;
							sel_data["rowsum"] = rowsum;
							
							var sel_detaildata = [];
							var tempIndex = $("#choiceTable_"+r_index).find("input[name=chkField]");
							for(var m = 0; m < rowsum; m++){
								var sel_d_data = {};
								 
								var q = $(tempIndex.get(m)).attr('index');
								
								var name1 = "field_"+r_index+"_"+q+"_name";
								var value1 = $("input[name='"+name1+"']", $selitemContainer).val();
								//sel_d_data[name1] = value1;
								sel_d_data["field_name"] = value1;
								
								var name2 = "field_count_"+r_index+"_"+q+"_name";
								var value2 = $("input[name='"+name2+"']", $selitemContainer).val();
								//sel_d_data[name2] = value2;
								sel_d_data["field_count_name"] = value2;
								
								var name3 = "field_checked_"+r_index+"_"+q+"_name";
								var value3 = $("input[name='"+name3+"']").get(0).checked ? "1" : "0";
								//sel_d_data[name3] = value3;
								sel_d_data["field_checked_name"] = value3;
								
								var name4 = "isAccordToSubCom"+r_index+"_"+q;
								var value4 = $("input[name='"+name4+"']").get(0).checked ? "1" : "0";
								//sel_d_data[name4] = value4;
								sel_d_data["isAccordToSubCom"] = value4;
								
								var name5 = "pathcategory_"+r_index+"_"+q;
								var value5 = $("#"+name5, $selitemContainer).val();
								//sel_d_data[name5] = value5;
								sel_d_data["pathcategory"] = value5;
								
								var name6 = "maincategory_"+r_index+"_"+q;
								var value6 = $("#"+name6, $selitemContainer).val();
								//sel_d_data[name6] = value6;
								sel_d_data["maincategory"] = value6;
								
								var name7 = "childItem_"+r_index+"_"+q;
								var value7 = $("input[name='"+name7+"']", $selitemContainer).val();
								//sel_d_data[name7] = value7;
								sel_d_data["childItem"] = value7;
								
								sel_detaildata.push(sel_d_data);
							}
							
							sel_data["sel_detaildata"] = sel_detaildata;
						}
					}
					
					if(record.get('htmltype')==8){	//公共选择框
						var fieldid = record.get('id');
						var pubTr = $("#pubTR_" + fieldid);
						if(pubTr.length != 0){
							var pubselect = pubTr.find("[name=pubselect]").val();
							var pubselectType = pubTr.find("[name=pubselectType]").val();
							var publinkfield = pubTr.find("[name=publinkfield]").val();
							
							sel_data["pubselect"] = pubselect;
							sel_data["pubselectType"] = pubselectType;
							sel_data["publinkfield"] = publinkfield;
						}
						if(record.data.fieldtype==''){
							window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(82477,user.getLanguage())%>('+record.data.fieldlabelname+')<%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(82241,user.getLanguage())%>',function(){
								dynamicSetEditor(gridQueue[0].grid, record, r_index, 4, null);
								gridQueue[0].grid.startEditing(r_index,4);
							});
							return;
						}
					}
					r_data["sel_data"] = sel_data;
					modifiedDatas.push(r_data);
				}
			}
			if(modifiedDatas.length == 0){
				rightMenu.style.visibility = "hidden";
				return;
			}
			var jsonstr = Ext.util.JSON.encode(modifiedDatas);
			//alert(jsonstr);
			//return;
			//escape(jsonstr)
			enableAllmenu();
			var paramData = {"data": encodeURI(jsonstr), "formId": "<%=formId%>"};
	    	var url = "/formmode/setup/formSettingsAction.jsp?action=saveFormfield2";
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
		
		function setBrowserfieldVal(params,datas){
			var record=params.record;
			var dataIndex=params.dataIndex;
			record.set(dataIndex,datas.id);
		}
	</script>
	
</head>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
    <%
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
	    RCMenuHeight += RCMenuHeightStep ;
	    
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(82021,user.getLanguage())+",javascript:createForm(),_top} " ;//新建表单
	    RCMenuHeight += RCMenuHeightStep ;
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(82119,user.getLanguage())+",javascript:refreshForm(),_top} " ;//更新表单
	    RCMenuHeight += RCMenuHeightStep ;
	%>
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
	<form action="/formmode/setup/formfield2operation.jsp" name="fm" method="post" >
		<input type="hidden" name="actiontype" value="refreshform">
		<input type="hidden" name="formId" value="<%=formId%>"> 
	</form>
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
	
	
	
	<div id="SeleteItem_ALL" style="display: none;">
		<%
			
			RecordSet rs = new RecordSet();
			FormFieldTransMethod formFieldTransMethod = new FormFieldTransMethod();
		
			List<Map<String, Object>> formfieldList = formInfoService.getTargetFormField(formId, null);
			
			for(int rowIndex = 0; rowIndex < formfieldList.size(); rowIndex++){
				Map<String, Object> formfieldMap = formfieldList.get(rowIndex);
				String f_fieldhtmltype = Util.null2String(formfieldMap.get("fieldhtmltype"));
				String f_pubchoiceid = Util.null2String(formfieldMap.get("pubchoiceid"));
				String f_pubchilchoiceid = Util.null2String(formfieldMap.get("pubchilchoiceid"));
				if((!"".equals(f_pubchoiceid)&&!"0".equals(f_pubchoiceid))||(!"".equals(f_pubchilchoiceid)&&!"0".equals(f_pubchilchoiceid))){
					f_fieldhtmltype="8";
				}
				if(!f_fieldhtmltype.equals("5")){	//不是选择框
					continue;
				}
				
				String fieldid = Util.null2String(formfieldMap.get("id"));
				
				String f_fieldname = Util.null2String(formfieldMap.get("fieldname"));
				
				String tablename = mainTablename;
				
				int childfieldid_tmp = Util.getIntValue(Util.null2String(formfieldMap.get("childfieldid")));
				String childfieldStr = "";
				Hashtable childItem_hs = new Hashtable();
				if(childfieldid_tmp > 0){
					rs.execute("select fieldlabel from workflow_billfield where id="+childfieldid_tmp);
					if(rs.next()){
						int childfieldlabel = rs.getInt("fieldlabel");
						childfieldStr = SystemEnv.getHtmlLabelName(childfieldlabel, user.getLanguage());
					}
					rs.execute("select * from workflow_SelectItem where isbill=1 and fieldid="+childfieldid_tmp);
					while(rs.next()){
						int selectvalue_tmp = Util.getIntValue(rs.getString("selectvalue"), -1);
						String selectname_tmp = Util.null2String(rs.getString("selectname"));
						childItem_hs.put("item_"+selectvalue_tmp, selectname_tmp);
					}
				}
				
				String canDeleteCheckBox = "true";
				if(!isvirtualform){
					String para = f_fieldname+"+0+"+f_fieldhtmltype+"+ +"+formId;
					canDeleteCheckBox = formFieldTransMethod.getCanCheckBox(para);
				}
		%>
				<div id="SeleteItem_<%=tablename %>_<%=rowIndex %>">
					<div id="div5_<%=rowIndex%>" style="vertical-align: middle; height:30px; line-height: 30px;text-align: left;padding-left: 5px;">
						<button type="button" class="addbtn" id="btnaddRow" name="btnaddRow" onclick='addoTableRow(<%=rowIndex%>)' title="<%=SystemEnv.getHtmlLabelName(15443,user.getLanguage())%>" style="margin-bottom:-5px;"></BUTTON><!-- 添加内容 -->
						<button type="button" class="delbtn" id="btnsubmitClear" name="btnsubmitClear" onclick='submitClear(<%=rowIndex%>)' title="<%=SystemEnv.getHtmlLabelName(15444,user.getLanguage())%>" style="margin-bottom:-5px;"></BUTTON><!-- 删除内容 -->
						<span><%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>&nbsp;</span><!-- 关联子字段 -->
						<button type="button" id="showChildFieldBotton" class="Browser" onClick="onShowChildField(childfieldidSpan_<%=rowIndex%>,childfieldid_<%=rowIndex%>,'_<%=rowIndex%>')"></BUTTON>
						<span id='childfieldidSpan_<%=rowIndex%>'><%=childfieldStr%></span>
						<input type='hidden' value='<%=childfieldid_tmp%>' name='childfieldid_<%=rowIndex%>' id='childfieldid_<%=rowIndex%>'>
						<input type='hidden' name='modifyflag_<%=rowIndex%>' value="<%=fieldid%>">
					</div>
						
					<div id="div5_5_<%=rowIndex%>">
					  	<table class='liststyle' id='choiceTable_<%=rowIndex%>' cols='6' border=0 style="width: 100%;" cellspacing="collapse">
							<COL width="5%">
							<COL width="25%">
							<COL width="5%">
							<COL width="10%">
							<COL width="33%">
							<COL width="22%">
					  		<tr>
					  			<td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td><!-- 选中 -->
					  			<td style='text-align: left;padding-left:15px;'><%=SystemEnv.getHtmlLabelName(15442,user.getLanguage())%></td><!-- 可选项文字 -->
					  			<td><%=SystemEnv.getHtmlLabelName(338,user.getLanguage())%></td><!-- 排序 -->
					  			<td><%=SystemEnv.getHtmlLabelName(19206,user.getLanguage())%></td><!-- 默认值 -->
					  			<td><%=SystemEnv.getHtmlLabelName(19207,user.getLanguage())%></td><!-- 关联文档目录 -->
								<td><%=SystemEnv.getHtmlLabelName(22663,user.getLanguage())%></td><!-- 子字段选项 -->
							</tr>
					  		<%
					  		int recordchoicerowindex = 0;
					  		rs.executeSql("select * from workflow_SelectItem where isbill=1 and fieldid="+fieldid+" order by selectvalue ");
					  		while(rs.next()){
						  		recordchoicerowindex+=1;
								String childitemid_tmp = Util.null2String(rs.getString("childitemid"));
								String childitemidStr = "";
								int isAccordToSubCom_tmp = Util.getIntValue(rs.getString("isaccordtosubcom"), 0);
								String isAccordToSubCom_Str = "";
								if(isAccordToSubCom_tmp == 1){
									isAccordToSubCom_Str = " checked ";
								}
								String[] childitemid_sz = Util.TokenizerString2(childitemid_tmp, ",");
								for(int cx=0; (childitemid_sz!=null && cx<childitemid_sz.length); cx++){
									String childitemidTemp = Util.null2String(childitemid_sz[cx]);
									String childitemnameTemp = Util.null2String((String)childItem_hs.get("item_"+childitemidTemp));
									if(!"".equals(childitemnameTemp)){
										childitemidStr += (childitemnameTemp+",");
									}
								}
								if(!"".equals(childitemidStr)){
									childitemidStr = childitemidStr.substring(0, childitemidStr.length()-1);
								}
					  		%>
						  	<tr>
						  		<td><div><input type="checkbox" name="chkField" index="<%=recordchoicerowindex%>" value="0" <%if(canDeleteCheckBox.equals("false")){%>disabled<%}%>></div></td>
						  		<td style='text-align: left;padding-left:15px;'><div><input class="InputStyle selectitemname" value="<%=rs.getString("selectname")%>" type="text" size="10" name="field_<%=rowIndex%>_<%=recordchoicerowindex%>_name" style="width:80%" onchange="checkinput('field_<%=rowIndex%>_<%=recordchoicerowindex%>_name','field_<%=rowIndex%>_<%=recordchoicerowindex%>_span');">
						  			<span id="field_<%=rowIndex%>_<%=recordchoicerowindex%>_span"><%if(rs.getString("selectname").equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></span></div></td>
						  		<td><div><input class="InputStyle" type="text" size="4" value = "<%=rs.getString("listorder")%>" name="field_count_<%=rowIndex%>_<%=recordchoicerowindex%>_name" style="width:90%" onchange="" onKeyPress="ItemNum_KeyPress('field_count_<%=rowIndex%>_<%=recordchoicerowindex%>_name')"></div></td>
						  		<td><div><input type="checkbox" name="field_checked_<%=rowIndex%>_<%=recordchoicerowindex%>_name" onchange='' onclick="if(this.checked){this.value=1;}else{this.value=0}" <%if(rs.getString("isdefault").equals("y")){%>checked<%}%>></div></td>
						  			
						  		<td><div><input type="hidden" id="selectvalue<%=rowIndex%>_<%=recordchoicerowindex%>" name="selectvalue<%=rowIndex%>_<%=recordchoicerowindex%>" value="<%=rs.getString("selectvalue")%>">
									<input type='checkbox' name='isAccordToSubCom<%=rowIndex%>_<%=recordchoicerowindex%>'   onchange=''  value='1' <%=isAccordToSubCom_Str%>><%=SystemEnv.getHtmlLabelName(22878,user.getLanguage())%>&nbsp;&nbsp;<!-- 根据分部区分 -->
									<button type='button' class=Browser name="selectCategory" onClick="onShowCatalog(mypath_<%=rowIndex%>_<%=recordchoicerowindex%>,'<%=rowIndex%>','<%=recordchoicerowindex%>');"></BUTTON>
									<span id="mypath_<%=rowIndex%>_<%=recordchoicerowindex%>"><%=rs.getString("docPath")%></span>
								  	<input type=hidden id="pathcategory_<%=rowIndex%>_<%=recordchoicerowindex%>" name="pathcategory_<%=rowIndex%>_<%=recordchoicerowindex%>" value="<%=rs.getString("docPath")%>">
								  	<input type=hidden id="maincategory_<%=rowIndex%>_<%=recordchoicerowindex%>" name="maincategory_<%=rowIndex%>_<%=recordchoicerowindex%>" value="<%=rs.getString("docCategory")%>"></div></td>
								<td><div>
									<button type='button' class="Browser" onClick="onShowChildSelectItem(childItemSpan_<%=rowIndex%>_<%=recordchoicerowindex%>,childItem_<%=rowIndex%>_<%=recordchoicerowindex%>,'_<%=rowIndex%>')" id="selectChildItem_<%=rowIndex%>_<%=recordchoicerowindex%>" name="selectChildItem_<%=rowIndex%>_<%=recordchoicerowindex%>"></BUTTON>
									<input type="hidden" id="childItem_<%=rowIndex%>_<%=recordchoicerowindex%>" name="childItem_<%=rowIndex%>_<%=recordchoicerowindex%>" value="<%=childitemid_tmp%>" >
									<span id="childItemSpan_<%=rowIndex%>_<%=recordchoicerowindex%>" name="childItemSpan_<%=rowIndex%>_<%=recordchoicerowindex%>"><%=childitemidStr%></span>
								</div></td>
							</tr>
						  	<%}%>
						  	<input type="hidden" value="<%=recordchoicerowindex%>" name="choiceRows_<%=rowIndex%>">
						</table>
					</div>
					
				</div>
				
		<%		
			}
		%>
	</div>
	
	<div id="PubSeleteItem_ALL" style="display: none;">
		<table id="pubSeleteItemTable">
			<%
			for(int rowIndex = 0; rowIndex < formfieldList.size(); rowIndex++){
				Map<String, Object> formfieldMap = formfieldList.get(rowIndex);
				String f_fieldhtmltype = Util.null2String(formfieldMap.get("fieldhtmltype"));
				if(!f_fieldhtmltype.equals("8")){	//选择框
					continue;
				}
				
				String fieldid = Util.null2String(formfieldMap.get("id"));
				String selectitem = Util.null2String(formfieldMap.get("selectitem"));
				String linkfield = Util.null2String(formfieldMap.get("linkfield"));
				%>
					<tr id="pubTR_<%=fieldid %>">
						<td>
							<input type="text" name="pubselect" value="<%=fieldid %>" >
							<input type="text" name="pubselectType" value="<%=selectitem %>" >
							<input type="text" name="publinkfield" value="<%=linkfield %>" >
						</td>
					</tr>
				<%
			}
			%>
		</table>
	</div>
	
	<script type="text/javascript">
	    function refreshForm(){
	    	if(confirm("<%=SystemEnv.getHtmlLabelName(82120,user.getLanguage())%>")){//是否确定要更新表单字段？
	    		fm.submit();
	    	}
	    }
		//主表字段 选择框 添加选项
		function addoTableRow(index){
			var obj1 = $G("choiceTable_"+index);
			var choicerowindex =$G("choiceRows_"+index).value*1+1;
			$G("choiceRows_"+index).value = choicerowindex;
			ncol1 = obj1.rows[0].cells.length;
			oRow1 = obj1.insertRow(-1);
			for(j=0; j<ncol1; j++) {
				oCell1 = oRow1.insertCell(j);
				switch(j) {
					case 0:
						var oDiv1 = document.createElement("div");
						var sHtml1 = "<input   type='checkbox' name='chkField' index='"+choicerowindex+"' value='0'>";
						oDiv1.innerHTML = sHtml1;
						oCell1.appendChild(oDiv1);
						break;
					case 1:
						var oDiv1 = document.createElement("div");
						var sHtml1 = "<input class='InputStyle selectitemname' type='text' size='10' name='field_"+index+"_"+choicerowindex+"_name' style='width:80%'"+
									" onchange=\"checkinput('field_"+index+"_"+choicerowindex+"_name','field_"+index+"_"+choicerowindex+"_span')\">"+
									" <span id='field_"+index+"_"+choicerowindex+"_span'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>";
						oDiv1.innerHTML = sHtml1;
						oCell1.appendChild(oDiv1);
						oCell1.style.textAlign = "left";
						oCell1.style.paddingLeft = "15px";
						break;
					case 2:
						var oDiv1 = document.createElement("div");
						var sHtml1 = " <input class='InputStyle' type='text' size='4' value = '0.00' onchange='' name='field_count_"+index+"_"+choicerowindex+"_name' style='width:90%'"+
									" onKeyPress=ItemNum_KeyPress('field_count_"+index+"_"+choicerowindex+"_name') onchange=checknumber('field_count_"+index+"_"+choicerowindex+"_name')>";
						oDiv1.innerHTML = sHtml1;
						oCell1.appendChild(oDiv1);
						break;
					case 3:
						var oDiv1 = document.createElement("div");
						var sHtml1 = " <input type='checkbox' name='field_checked_"+index+"_"+choicerowindex+"_name' onchange='' onclick='if(this.checked){this.value=1;}else{this.value=0}'>";
						oDiv1.innerHTML = sHtml1;
						oCell1.appendChild(oDiv1);
						break;
					case 4:
						var oDiv1 = document.createElement("div");
						var sHtml1 = "<input type='checkbox' name='isAccordToSubCom"+index+"_"+choicerowindex+"' value='1' ><%=SystemEnv.getHtmlLabelName(22878,user.getLanguage())%>&nbsp;&nbsp;"//根据分部区分
									+ "<button type='button' class=Browser onClick=\"onShowCatalog(mypath_"+index+"_"+choicerowindex+","+index+","+choicerowindex+")\" name=selectCategory></BUTTON>"
									+ "<span id=mypath_"+index+"_"+choicerowindex+"></span>"
								    + "<input type=hidden id='pathcategory_" + index + "_"+choicerowindex+"' name='pathcategory_" + index + "_"+choicerowindex+"' value=''>"
								    + "<input type=hidden id='maincategory_" + index + "_"+choicerowindex+"' name='maincategory_" + index + "_"+choicerowindex+"' value=''>";
		
						oDiv1.innerHTML = sHtml1;
						oCell1.appendChild(oDiv1);
						break;
					case 5:
						var oDiv1 = document.createElement("div");
						var sHtml1 = "<button type='button' class=\"Browser\" onClick=\"onShowChildSelectItem(childItemSpan_"+index+"_"+choicerowindex+",childItem_"+index+"_"+choicerowindex+",'_"+index+"')\" id=\"selectChildItem_"+index+"_"+choicerowindex+"\" name=\"selectChildItem_"+index+"_"+choicerowindex+"\"></BUTTON>"
									+ "<input type=\"hidden\" id=\"childItem_"+index+"_"+choicerowindex+"\" name=\"childItem_"+index+"_"+choicerowindex+"\" value=\"\" >"
									+ "<span id=\"childItemSpan_"+index+"_"+choicerowindex+"\" name=\"childItemSpan_"+index+"_"+choicerowindex+"\"></span>";
						oDiv1.innerHTML = sHtml1;
						oCell1.appendChild(oDiv1);
						break;
				}		
			}
			jQuery("body").jNice();
		}
		
		//主表选择框字段删除选项
		function submitClear(index){
		  var flag = false;
			var ids = document.getElementsByName('chkField');
			for(i=0; i<ids.length; i++) {
				if(ids[i].checked==true) {
					flag = true;
					break;
				}
			}
		    if(flag) {
		        if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){//确定要删除吗?
				    deleteRow1(index);
		        }
		    }else{
		        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');//请选择需要删除的数据
				return;
		    }
		}
		
		//主表选择框字段删除选项
		function deleteRow1(index){
			var objTbl = $("#choiceTable_"+index);
			var objChecks=objTbl.find("input[name=chkField]");	
			
			for(var i=objChecks.length-1;i>=0;i--){
				if(objChecks.get(i).checked) {
					$(objChecks.get(i)).parent().parent().parent().parent().remove();
				}
			}
		}
		
		function onShowChildField(spanname, inputname, childstr) {
		    isdetail = "0";
		    hasdetail=childstr.indexOf("detail");
		    if (hasdetail > 0) {
		        isdetail = "1";
		    }
		
		    pfieldidsql = getParentField(childstr);
		    oldvalue = inputname.value;
		    hasdetail=childstr.indexOf("detail");
		    if (hasdetail > 0) {
		        tablename = getDetailTableName(childstr);
		        //将"&&" 更改为 (SQL语句中)查询条件的 "And" 
		        pfieldidsql = pfieldidsql + " AND detailtable='" + tablename + "' ";
		    }
			url = escape("/workflow/workflow/fieldBrowser.jsp?sqlwhere=where fieldhtmltype=5  and billid=<%=formId%>" + pfieldidsql + "&isdetail=" + isdetail + "&isbill=1");
			$('#_DialogDiv_SeleteItemDialog_3').css('z-index',1002);
			__browserNamespace__.showModalDialogForBrowser(event,"/systeminfo/BrowserMain.jsp?url=" + url,'#','hrefid',true,1,'',
					{name:'hrefid',hasInput:false,zDialog:true,needHidden:true,dialogTitle:'<%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>',dialogWidth:600,arguments:'dialogWidth=500px',
					_callback:function(event,datas,name,_callbackParams){
				        if (wuiUtil.getJsonValueByIndex(datas,0)!= "") {
				            inputname.value =wuiUtil.getJsonValueByIndex(datas,0);
				            spanname.innerHTML =wuiUtil.getJsonValueByIndex(datas,1);
				        } else {
				            inputname.value = "";
				            spanname.innerHTML = "";
				        }
					}});
		}
		
		function getParentField(childstr){
			var pfieldidsql = "";
			try{
				if(childstr.indexOf("detail")>-1){
					childstr = "_"+childstr.substring(7, childstr.length);
				}
				var pfield = document.all("modifyflag"+childstr).value;	//TO DO
				pfieldidsql = " and id!="+pfield+" ";
			}catch(e){}
			return pfieldidsql;
		}
		
		function onShowCatalog(spanName, index, choicerowindex){
			var isAccordToSubCom=0;
			if($G("isAccordToSubCom"+index+"_"+choicerowindex)!=null){
				if($G("isAccordToSubCom"+index+"_"+choicerowindex).checked){
					isAccordToSubCom=1;
				}
			}
			if(isAccordToSubCom==1){
				onShowCatalogSubCom(spanName, index, choicerowindex);
			}else{
				onShowCatalogHis(spanName, index, choicerowindex);
			}
		}
		
		function onShowCatalogHis(spanName, index, choicerowindex) {
			$('#_DialogDiv_SeleteItemDialog_3').css('z-index',1002);
			__browserNamespace__.showModalDialogForBrowser(event,"/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp",'#','hrefid',true,1,'',
					{name:'hrefid',hasInput:false,zDialog:true,needHidden:true,dialogTitle:'<%=SystemEnv.getHtmlLabelName(19207,user.getLanguage())%>',dialogWidth:600,arguments:'dialogWidth=500px',
					_callback:function(event,datas,name,_callbackParams){						
				        if (wuiUtil.getJsonValueByIndex(datas,0)> 0){
				            spanName.innerHTML=wuiUtil.getJsonValueByIndex(datas,2);
				            $G("pathcategory_"+index+"_"+choicerowindex).value=wuiUtil.getJsonValueByIndex(datas,2);
				            $G("maincategory_"+index+"_"+choicerowindex).value=wuiUtil.getJsonValueByIndex(datas,3)+","+wuiUtil.getJsonValueByIndex(datas,4)+","+wuiUtil.getJsonValueByIndex(datas,1);
				        }else{
				            spanName.innerHTML="";
				            $G("pathcategory_"+index+"_"+choicerowindex).value="";
				            $G("maincategory_"+index+"_"+choicerowindex).value="";
				       }
					}});
		}
		
		function onShowCatalogSubCom(spanName, index, choicerowindex) {
			if($G("selectvalue"+index+"_"+choicerowindex)==null){
				alert("<%=SystemEnv.getHtmlLabelName(24460,user.getLanguage())%>");//请先保存后再选择！
				return;
			}
		
			var fieldid = $G("modifyflag_"+index).value;
			var selectvalue=$G("selectvalue"+index+"_"+choicerowindex).value;
			url =escape("/workflow/field/SubcompanyDocCategoryBrowser.jsp?fieldId="+fieldid+"&isBill=1&selectValue="+selectvalue)
		    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
		}
		
		function onShowChildSelectItem(spanname, inputname, childidstr) {

		    var cfid = $G("childfieldid" + childidstr).value;
		    var oldids = inputname.value;
		    //url = escape("/workflow/field/SelectItemBrowser.jsp?isbill=1+isdetail=1+childfieldid=" + cfid + "+resourceids=" + oldids);
		    var url = escape("/workflow/field/SelectItemBrowser.jsp?isbill=1&isdetail=1&childfieldid=" + cfid + "&resourceids=" + oldids);
			$('#_DialogDiv_SeleteItemDialog_3').css('z-index',1002);
			__browserNamespace__.showModalDialogForBrowser(event,"/systeminfo/BrowserMain.jsp?url=" + url,'#','hrefid',true,1,'',
					{name:'hrefid',hasInput:false,zDialog:true,needHidden:true,dialogTitle:'<%=SystemEnv.getHtmlLabelName(22663,user.getLanguage())%>',dialogWidth:600,arguments:'dialogWidth=500px',
					_callback:function(event,datas,name,_callbackParams){						
				        if (wuiUtil.getJsonValueByIndex(datas,0)!= "") {
				            resourceids =wuiUtil.getJsonValueByIndex(datas,0);
				            resourcenames =wuiUtil.getJsonValueByIndex(datas,1);
				            resourceids =resourceids.substr(1);
				            resourcenames =resourcenames.substr(1);             
				            
				            inputname.value = resourceids;
				            spanname.innerHTML = resourcenames;
				        } else {
				            inputname.value = "";
				            spanname.innerHTML = "";
				        }
					}});
		}
	</script>
    <script language="javascript" src="/js/browsertypechooser/btc_wev8.js"></script>
    <link rel="stylesheet" type="text/css" href="/js/browsertypechooser/browserTypeChooser_wev8.css">
    <style>
    .btc_container{
	border:0px solid #cad1d7 !important;
	box-shadow:0px 0px 0px 0px;
	}
    </style>
    <script type="text/javascript">
	 function BTCOpen(theRowIndex,diag,theStoreRecord){
	       var btc = new BTC();
	       var btcspan = $("#browsertype_autoSelect");
	       var tempBtc;
           while(tempBtc = BTCArray.shift()){
              btcspan.find(".sbToggle").removeClass("sbToggle-btc-reverse")
              tempBtc.remove();
           }
           <%
            if (HrmUserVarify.checkUserRight("SysadminRight:Maintenance", user)){ 
           %>
           btcspan.next(".btc_type_edit").remove();
           btcspan.after("<img onclick='setBTC()' style='cursor:pointer;' class='btc_type_edit' src='/images/ecology8/workflow/setting_wev8.png'>");
    	   <%}%>
		   btc.init({
			  renderTo:btcspan,
		      headerURL:"/workflow/field/BTCAjax.jsp?action=queryHead",
			  contentURL:"/workflow/field/BTCAjax.jsp?action=queryContent&isFromMode=1",
			  contentHandler:function(value){
					try{
					    theStoreRecord.set('fieldtype', value);
						diag.close();
						// btc.remove();
					}catch(e){}
			  }
	  	  });  
    }    
    function setBTC(){
            var url = "/systeminfo/BrowserMain.jsp?url=/workflow/field/browsertypesetting.jsp?isFromMode=1";
            var dlg=new window.top.Dialog();//定义Dialog对象
			var title = "<%=SystemEnv.getHtmlLabelName(125117, user.getLanguage()) %>";
			dlg.Width=550;//定义长度
			dlg.Height=600;
			dlg.URL=url;
			dlg.Title=title;
			dlg.show();
    }
	</script>
</body>
</html>