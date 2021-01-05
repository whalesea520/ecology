<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.*"%>
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<html>
<head>

<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/ext-all_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/xtheme-gray_wev8.css" />

<%

	if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user))
	{
		response.sendRedirect("/notice/noright.jsp");
    	
		return;
	}
%>

<%if(user.getLanguage()==7) {%>
	<script type="text/javascript" src="/js/workflow/design/lang-cn_wev8.js"></script>
<%} else if(user.getLanguage()==8) {%>
	<script type='text/javascript' src='/js/workflow/design/lang-en_wev8.js'></script>
<%} else if(user.getLanguage()==9) {%>
	<script type='text/javascript' src='/js/workflow/design/lang-tw_wev8.js'></script>
<%}%>
<script type="text/javascript" src="/js/extjs/adapter/ext/ext-base_wev8.js"></script>
<script type="text/javascript" src="/js/extjs/ext-all_wev8.js"></script>

<!-- 
 <script type="text/javascript" src="/js/extjs/adapter/ext/ext-base_wev8.js">
<script type="text/javascript" src="/js/extjs/source/adapter/ext-base_wev8.js"></script>

<script type="text/javascript" src="/js/extjs/ext-core-debug_wev8.js"></script>

<script type="text/javascript" src="/js/extjs/ext-all-debug_wev8.js"></script>


 -->
 	
<link rel="stylesheet" type="text/css" href="/css/Ext.ux.form.LovCombo_wev8.css">
<script type="text/javascript" src="/js/workflow/design/Ext.ux.form.LovCombo_wev8.js"></script>

<script type="text/javascript" src="/js/workflow/design/WeaverPropertyGrid_wev8.js"></script>
<script type="text/javascript" src="/js/workflow/design/Ext.ux.UploadDialog_wev8.js"></script>
<script type="text/javascript" src="/js/jquery/jquery_wev8.js"></script>

<script type="text/javascript" src="/js/workflow/design/WeaverMsgExt_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/css/wfdesign_wev8.css" />
<!-- <link rel="stylesheet" type="text/css" href="/css/weaver-ext-grid_wev8.css" -->	
<style>
#loading{
    position:absolute;
    left:45%;
    background:#ffffff;
    top:40%;
    padding:8px;
    z-index:20001;
    height:auto;
    border:1px solid #ccc;
}
</style>
<div id="loading">	
		<span><img src="/images/loading2_wev8.gif" align="absmiddle"></span>
		<span  id="loading-msg" style="font-size:12"><%=SystemEnv.getHtmlLabelName(19945, user.getLanguage())%></span>
</div>
<% 
	boolean showwayoutinfo=GCONST.getWorkflowWayOut();
	String type = Util.null2String(request.getParameter("type")); 
	String workflowId = Util.null2String(request.getParameter("wfId"));
	boolean isFullScreen = Util.null2String(request.getParameter("isFullScreen")).equals("true")?true:false;
	type= type==""?"edit":type;
	WFManager.setWfid(Util.getIntValue(workflowId));
	WFManager.getWfInfo();
%>
<script type='text/javascript'>
function design_callback(ev,returnvalue) {
	var step;
	switch(ev){
	case 'showButtonNameOperate':
		//自定义右键按钮
		//alert('自定义右键按钮');
	//td19600
		var $tdsib =  $("td:contains('"+wmsg.wfdesign.rightMenu+"')").next();
		if(returnvalue == "true") {
			$tdsib.removeClass("propertyWin");
			$tdsib.removeClass("propertyWin_ggy").addClass("propertyWin_ggy");
		}else {
			$tdsib.removeClass("propertyWin_ggy");
			$tdsib.removeClass("propertyWin").addClass("propertyWin");
		}
		//td19600
		openwin.close();
		openwin = null;
		break;
	case 'showpreaddinoperate':
		//节点前附加操作
		//alert('节点前附加操作');
		//td19600
		var $tdsib =  $("td:contains('"+wmsg.wfdesign.preAddInOperate+"')").next();
		if(returnvalue == "true") {
			$tdsib.removeClass("propertyWin");
			$tdsib.removeClass("propertyWin_ggy").addClass("propertyWin_ggy");
		}else {
			$tdsib.removeClass("propertyWin_ggy");
			$tdsib.removeClass("propertyWin").addClass("propertyWin");
		}
		//td19600
		openwin.close();
		openwin = null;
		break;
	case 'showaddinoperate_node':
		//节点后附加操作
		//alert('节点后附加操作');
	//td19600
		var $tdsib =  $("td:contains('"+wmsg.wfdesign.addInOperate+"')").next();
		if(returnvalue == "true") {
			$tdsib.removeClass("propertyWin");
			$tdsib.removeClass("propertyWin_ggy").addClass("propertyWin_ggy");
		}else {
			$tdsib.removeClass("propertyWin_ggy");
			$tdsib.removeClass("propertyWin").addClass("propertyWin");
		}
		//td19600
		openwin.close();
		openwin = null;
		break;
	case 'showaddinoperate_link':
		//出口附加规则
		//alert('出口附加规则');
		step = w._FLOW.getFocusStep();
		step.hasRole=returnvalue=="true";
	//TD19600
		var $tdsib =  $("td:contains('"+wmsg.wfdesign.stepAddInOperate+"')").next();
		if(returnvalue == "true") {
			$tdsib.removeClass("propertyWin");
			$tdsib.removeClass("propertyWin_ggy").addClass("propertyWin_ggy");
		}else {
			$tdsib.removeClass("propertyWin_ggy");
			$tdsib.removeClass("propertyWin").addClass("propertyWin");
		}
		//end td19600
		step.setStepInfo();
		openwin.close();
		break;
	case 'wfNodeBrownser':
		//日志查看范围
		//alert('日志查看范围');
	//td19600
		var $tdsib =  $("td:contains('"+wmsg.wfdesign.logBrownser+"')").next();
		if(returnvalue == "true") {
			$tdsib.removeClass("propertyWin");
			$tdsib.removeClass("propertyWin_ggy").addClass("propertyWin_ggy");
		}else {
			$tdsib.removeClass("propertyWin_ggy");
			$tdsib.removeClass("propertyWin").addClass("propertyWin");
		}
		//td19600
		openwin.close();
		openwin = null;
		break;
	case 'addwfnodefield':
		//节点表单字段
		//alert('节点表单字段');
		openwin.close();
		openwin = null;
		break;
	case 'addoperatorgroup':
	case 'editoperatorgroup':
		//节点操作者
		//alert('节点操作者');
		openwin.close();
		openwin = null;
		Ext.getCmp("operatorSelect").clearValue();
		operator_store.reload();
		
		break;
	case 'addnodeoperator':
		//节点操作组
		//alert('节点操作组');
		openwin.close();
		openwin = null;
		break;
	case 'showFormSignatureOperate':
		//是否表单签章
		//alert('是否表单签章');
	//TD19600
		var $tdsib =  $("td:contains('"+wmsg.wfdesign.procTitleInfo+"')").next();
		if(returnvalue == "true") {
			$tdsib.removeClass("propertyWin");
			$tdsib.removeClass("propertyWin_ggy").addClass("propertyWin_ggy");
		}else {
			$tdsib.removeClass("propertyWin_ggy");
			$tdsib.removeClass("propertyWin").addClass("propertyWin");
		}
		//end td19600
		openwin.close();
		openwin = null;
		break;
	case 'showNodeTitleOperate':
		//流程标题提示信息
		//alert('流程标题提示信息');
		openwin.close();
		openwin = null;
		break;
	case 'editoperatorgroup':
		//编辑操作者
		//alert('编辑操作者');
		openwin.close();
		openwin = null;
		break;
	case 'showcondition':
		//出口条件设置
		//alert('出口条件设置');
		step = w._FLOW.getFocusStep();
		step.hasCondition=returnvalue=="true";
		//TD19600
		var $tdsib =  $("td:contains('"+wmsg.wfdesign.condition+"')").next();
		if(returnvalue == "true") {
			$tdsib.removeClass("propertyWin");
			$tdsib.removeClass("propertyWin_ggy").addClass("propertyWin_ggy");
		}else {
			$tdsib.removeClass("propertyWin_ggy");
			$tdsib.removeClass("propertyWin").addClass("propertyWin");
		}
		//end td19600
		step.setStepInfo();
		openwin.close();
		openwin = null;
		break;
	}
}
var type='<%=type%>';
var isFullScreen ='<%=isFullScreen%>'
var hasCreate = false;
var property;
var showwayoutinfo = '<%=showwayoutinfo%>'
function setOperatorURL(FL,ID) {
	operator_url = new Array();//url+param;
	operator_url[0] = FL;
	operator_url[1] = ID;
}

function setPurposeNodeURL(FL,ID){
	operator_url = new Array();//url+param;
	purposeNode_url[0] = FL;
	purposeNode_url[1] = ID;
}

//判断节点名称是否已存在
function checkName(name){
	if(Ext.util.Format.trim(name)==""){
		return false;
	}
	for (i = 0; i < w._FLOW.Procs.length; i++) {
		Proc = w._FLOW.Procs[i];
		if(Proc.Text==Ext.util.Format.trim(name))
			return false;
	}
	
	return true;
}
var w
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = '/js/extjs/resources/images/default/s_wev8.gif';
	w = Ext.get('mycanavs').dom.contentWindow;
	
	property = new WeaverPropertyGrid({
		region:'east',
	    title: wmsg.wfdesign.property,
	    collapsible: true,
	    stripeRows :true,
	    //clicksToEdit:'auto',
	    loadMask :true,
	    split:true,
	    width: 230    
	});
	
	property.on({
    	'afteredit': function(e){
    		if(e.record.data["name"]==wmsg.wfdesign.type){
    			return false;
		    	
	    	}
    	 	if(!w._FOCUSTEDOBJ) return;
    		var obj = w._FOCUSTEDOBJ.typ == "Proc" ? w._FLOW.getProcByID(w._FOCUSTEDOBJ.id) : w._FLOW.getStepByID(w._FOCUSTEDOBJ.id);
    		switch(e.record.data["name"]){
    			case wmsg.wfdesign.nodeName:
    				obj.Text = Ext.util.Format.trim(e.value);
    				//alert(obj.Text)
    				break;
    			case wmsg.wfdesign.formSignature:
    				obj.FormSignature = e.value
    				break;
    			case wmsg.wfdesign.stepName:
    				//obj.TText.Text = e.value;
    				obj.Text = e.value;
    				break;
    			case wmsg.wfdesign.createNumber:
    				
					obj.isBuildCode = e.value;
					break;
				case wmsg.wfdesign.stepRemindMsg:
					obj.RemindMsg = e.value;
					break;
				case wmsg.wfdesign.isReject:
					obj.isReject = e.value;
					break;
				case wmsg.wfdesign.passnum:
					if(e.value>obj.branchCount||e.value<1){
						alert(wmsg.wfdesign.passnum+' : 1~'+obj.branchCount)
						return false;
					}else{
						obj.PassNum = e.value;
					}
					break;	    			
    		}
    		Ext.getDom("mycanavs").contentWindow.document.all(obj.ID).outerHTML = obj.toString();
	   			//w.DrawAll();
   			}
    });
    property .on("beforeedit", function(e){  
    	//在进行属性修改是必须先保存流程图
  		if(w._FLOW.Modified){ 			
 			e.cancel = true;  
 			return false;
     	}	
    	if(e.record.data["name"] == wmsg.wfdesign.flow||(e.record.get("value")!=undefined&&e.record.data["value"].type=="button")){
	    	e.cancel = true;  
	    	return false;  
    	}
	}); 
	property .on("cellclick", function(grid, row, column, e){  
		//在进行属性修改是必须先保存流程图
  		if(w._FLOW.Modified){
   			if(confirm(wmsg.wfdesign.saveBefore)){
   				w._FLOW.SaveToXML();
   				e.cancel = true;  
   				return false;
   			}else{
   				e.cancel = true;  
   				return false;
   			}
    	}
		var data  = property.getStore();
		var record = data.getAt(row);
		
    	if(record.get("value")!=undefined&&record.get("value").type == "button"){
    		WeaverPropertyColumnModel.url = record.get("value").url;
	    	openExtWin();
    	}
    	
	});   
	property.on('validateedit', function(e) {
		 if(e.record.data["name"]==wmsg.wfdesign.nodeName){
				if(!checkName(e.value)){
					alert("<%=SystemEnv.getHtmlLabelName(25217,user.getLanguage())%>！");
					e.cancel = true;  
					return false;  
				}
		 }
	});
    
if(type!='view'){
	
	 var tb = new Ext.Toolbar([
	 		{
            	text : wmsg.wfdesign.saveFlow,
            	tooltip: wmsg.wfdesign.saveFlow+'(Ctrl+S)',
            	iconCls: 'btn_save',
            	id: 'showTextSaveFlow',
            	handler: function(){w._FLOW.SaveToXML();}
            },{
				text : wmsg.wfdesign.del,
				tooltip:wmsg.wfdesign.del+'(Delete)',
				iconCls:'btn_delete',
				id:'showTextDelete',
				handler:function(){
					w.mnuDelObj();
				}
			},'-',{
            	//text : wmsg.wfdesign.undo,
				tooltip:wmsg.wfdesign.undo+'(Ctrl+Z)',
				iconCls: 'btn_undo',
				handler:function(){
					w.undoLog();
				}
			},{
				//text : wmsg.wfdesign.redo,
				tooltip:wmsg.wfdesign.redo+'(Ctrl+Y)',
				iconCls: 'btn_redo',
				handler:function(){
					w.redoLog();
				}
			},'-',{
				text : wmsg.wfdesign.create,
            	tooltip: wmsg.wfdesign.create,
            	iconCls: 'btn_create',
            	id:'showTextcreate',
            	enableToggle : true,
            	disabled:hasCreate,
            	handler: function(){
            		w._TOOLTYPE='roundrect';
            		w._NODETYPE='create'	
            		w._CREATENUMBER = 1;
            		w._TYPE = 0;	
            	},
            	listeners :{
	                render: function(btn){
	                   if(hasCreate){
							btn.enable()
						}else{
							btn.disable()
						}
	                }
                }
            },
            new Ext.Toolbar.SplitButton({
				text : wmsg.wfdesign.realize,
            	tooltip: wmsg.wfdesign.realize,
            	iconCls: 'btn_realize',
            	id:'showTextrealize',
            	enableToggle : true,
            	menu :{
            		items:[
	            		{
	            			text:wmsg.wfdesign.autoCreateStep,
	            			id:'createStepRealize',
	            			checked: true,
	            			handler:function (item){
	            				w._CREATESTEP = !item.checked
	            				Ext.getCmp('createStepApprove').setChecked(!item.checked)
	            			}
	            			
	            		},'-',{
	            			text:wmsg.wfdesign.selectProcNumber,
	            			menu:{
	            				items:[
	            				{
	            					text:'3',
	            					handler:function(item){
	            						w._TOOLTYPE='roundrect';
            							w._NODETYPE='realize'
            							w._CREATENUMBER = parseInt(item.text)	
            							w._TYPE = 2;
	            						showMessage(wmsg.wfdesign.info,wmsg.wfdesign.clickToAddProc)
	            					}
	            				},{
									text:'4',
	            					handler:function(item){
	            						w._TOOLTYPE='roundrect';
            							w._NODETYPE='realize'
            							w._CREATENUMBER = parseInt(item.text)	
            							w._TYPE = 2;
	            						showMessage(wmsg.wfdesign.info,wmsg.wfdesign.clickToAddProc)
	            					}
								},{
									text:'5',
	            					handler:function(item){
	            						w._TOOLTYPE='roundrect';
            							w._NODETYPE='realize'
            							w._CREATENUMBER = parseInt(item.text)
            							w._TYPE = 2;	
	            						showMessage(wmsg.wfdesign.info,wmsg.wfdesign.clickToAddProc)
	            					}
								},
	            				{
	            					text:wmsg.wfdesign.input,
	            					handler: function(){
	            					 Ext.MessageBox.prompt('', wmsg.wfdesign.inputProcNumber, function(btn,text){
										if(btn=='ok'){
											if (/^[0-9]+$/.test(text) && (text > 0))   
											{   
												w._TOOLTYPE='roundrect';
            									w._NODETYPE='realize'
            									w._CREATENUMBER = parseInt(text)
            									w._TYPE = 2;	
												showMessage(wmsg.wfdesign.info,wmsg.wfdesign.clickToAddProc)
												   
											}    
											else    
											{   
												alert(wmsg.wfdesign.inputInt)  
												   
											} 
										}
		            					
	            					 });		
	            					}
	            				}
	            				]
	            			}
	            			
	            		}
	            		]
	            	
	            	},
            	handler: function(){
            		w._TOOLTYPE='roundrect';
            		w._NODETYPE='realize'	
            		w._CREATENUMBER = 1;
            		w._TYPE = 2;	
            	}
			}),new Ext.Toolbar.SplitButton({
				text : wmsg.wfdesign.approve,
            	tooltip: wmsg.wfdesign.approve,
            	iconCls: 'btn_approve',
            	id:'showTextapprove',
            	enableToggle : true,
            	menu :{
            		items:[
	            		{
	            			text:wmsg.wfdesign.autoCreateStep,
	            			checked: true,
	            			id:'createStepApprove',
	            			handler:function (item){
	            				w._CREATESTEP = !item.checked
	            				Ext.getCmp('createStepRealize').setChecked(!item.checked)
	            			}
	            			
	            		},'-',{
	            			text:wmsg.wfdesign.selectProcNumber,
	            			menu:{
	            				items:[
	            				{
	            					text:'3',
	            					handler:function(item){
	            						w._TOOLTYPE='roundrect';
            							w._NODETYPE='realize'
            							w._CREATENUMBER = parseInt(item.text)	
            							w._TYPE = 1;
	            						showMessage(wmsg.wfdesign.info,wmsg.wfdesign.clickToAddProc)
	            					}
	            				},{
									text:'4',
	            					handler:function(item){
	            						w._TOOLTYPE='roundrect';
            							w._NODETYPE='approve'
            							w._CREATENUMBER = parseInt(item.text)
            							w._TYPE = 1;	
	            						showMessage(wmsg.wfdesign.info,wmsg.wfdesign.clickToAddProc)
	            					}
								},{
									text:'5',
	            					handler:function(item){
	            						w._TOOLTYPE='roundrect';
            							w._NODETYPE='approve'
            							w._CREATENUMBER = parseInt(item.text)
            							w._TYPE = 1;	
	            						showMessage(wmsg.wfdesign.info,wmsg.wfdesign.clickToAddProc)
	            					}
								},
	            				{
	            					text:wmsg.wfdesign.input,
	            					handler: function(){
	            					 Ext.MessageBox.prompt('', wmsg.wfdesign.inputProcNumber, function(btn,text){
										if(btn=='ok'){
											if (/^[0-9]+$/.test(text) && (text > 0))   
											{   
												w._TOOLTYPE='roundrect';
            									w._NODETYPE='approve'
            									w._CREATENUMBER = parseInt(text)
            									w._TYPE = 1;	
												showMessage(wmsg.wfdesign.info,wmsg.wfdesign.clickToAddProc)
												   
											}    
											else    
											{   
												alert(wmsg.wfdesign.inputInt)  
												   
											} 
										}
		            					
	            					 });		
	            					}
	            				}
	            				]
	            			}
	            			
	            		}
	            		]
	            	
	            	},
            	handler: function(){
            		w._TOOLTYPE='roundrect';
            		w._NODETYPE='approve'
            		w._CREATENUMBER = 1;	
            		w._TYPE = 1;	
            	}
			}),{
            	text : wmsg.wfdesign.fork,
            	tooltip: wmsg.wfdesign.fork,
            	iconCls: 'btn_fork',
            	id:'showTextfork',
            	enableToggle : true,
            	handler: function(){
            		w._TOOLTYPE='roundrect';
            		w._NODETYPE='fork'	
            		w._CREATENUMBER = 1;
            		w._TYPE = 2;	
            	}
            },{
            	text : wmsg.wfdesign.join,
            	tooltip: wmsg.wfdesign.join,
            	iconCls: 'btn_join',
            	id:'showTextjoin',
            	enableToggle : true,
            	handler: function(){
            		w._TOOLTYPE='roundrect';
            		w._NODETYPE='join'	
            		w._CREATENUMBER = 1;
            		w._TYPE = 2;	
            	}
            /*},{
            	text : wmsg.wfdesign.child,
            	tooltip: wmsg.wfdesign.child,
            	iconCls: 'btn_child',
            	id:'showTextchild',
            	enableToggle : true,
            	handler: function(){
            		w._TOOLTYPE='roundrect';
            		w._NODETYPE='child'	
            		w._CREATENUMBER = 1;	
            	}*/
            },{
            	text : wmsg.wfdesign.process,
            	tooltip: wmsg.wfdesign.process,
            	iconCls: 'btn_process',
            	enableToggle : true,
            	id:'showTextprocess',
            	//disabled:'<%=workflowId%>'!='',
            	handler: function(){
            		w._TOOLTYPE='roundrect';
            		w._NODETYPE='process'	
            		w._CREATENUMBER = 1;
            		w._TYPE = 3;	
            	}
            },{
            	text : wmsg.wfdesign.step,
            	tooltip: wmsg.wfdesign.step,
            	iconCls: 'btn_line',
            	enableToggle : true,
            	id:'showTextpolyline',
            	handler: function(){
            		w._TOOLTYPE='polyline';
            		w.clearSelect();
            	}
            },'-',
            {
            	//text : wmsg.wfdesign.alignLeft,
            	tooltip: wmsg.wfdesign.alignLeft,
            	iconCls: 'btn_alignLeft',
            	handler: function(){
            		w.alignLeft();
            	}
            },{
            	//text : wmsg.wfdesign.alignCenter,
            	tooltip: wmsg.wfdesign.alignCenter,
            	iconCls: 'btn_alignCenter',
            	handler: function(){
            		w.alignCenter();
            	}
            },{
            	//text : wmsg.wfdesign.alignRight,
            	tooltip: wmsg.wfdesign.alignRight,
            	iconCls: 'btn_alignRight',
            	handler: function(){
            		w.alignRight();
            	}
            },{
            	//text : wmsg.wfdesign.lignTop,
            	tooltip: wmsg.wfdesign.lignTop,
            	iconCls: 'btn_lignTop',
            	handler: function(){
            		w.lignTop();
            	}
            },{
            	//text : wmsg.wfdesign.lignMiddle,
            	tooltip: wmsg.wfdesign.lignMiddle,
            	iconCls: 'btn_lignMiddle',
            	handler: function(){
            		w.lignMiddle();
            	}
            },{
            	//text : wmsg.wfdesign.lignBottom,
            	tooltip: wmsg.wfdesign.lignBottom,
            	iconCls: 'btn_lignBottom',
            	handler: function(){
            		w.lignBottom();
            	}
            },'-',{
            	//text: wmsg.wfdesign.grid,
            	tooltip: wmsg.wfdesign.grid,
            	iconCls: 'btn_grid',
            	enableToggle : true,
            	pressed : type=='edit',
            	//id:'showTextGrid',
            	handler: function(){
            		w.grid();
            	}
            }, {
            	//text: wmsg.wfdesign.validate,
            	tooltip: wmsg.wfdesign.validate,
            	iconCls: 'btn_validate',
            	//enableToggle : true,
            	//id:'showTextValidate',
            	handler: function(){
            		var flow = w._FLOW;
					flow.validate()
            	}
            },{
            	//text: wmsg.wfdesign.validate,
            	tooltip: wmsg.wfdesign.adjustLine,
            	iconCls: 'btn_adjustLine',
            	//enableToggle : true,
            	//id:'showTextValidate',
            	handler: function(){
            		w.autoAdjust();
            	}
            	
            	
            },{
            	//text: wmsg.wfdesign.validate,
            	tooltip: wmsg.wfdesign.info,
            	iconCls: 'btn_info',
            	//enableToggle : true,
            	//id:'showTextValidate',
            	handler: function(){
            		showMessage(wmsg.wfdesign.info,"<span style='background:#04C93C;height:3px;width:20px'></span>&nbsp;"+wmsg.wfdesign.hasRoleAndCondition+"<br>"+
            		"<span style='background:#0584E6;height:3px;width:20px'></span>&nbsp;"+wmsg.wfdesign.hasRole+"<br>"+
            		"<span style='background:#003399;height:3px;width:20px'></span>&nbsp;"+wmsg.wfdesign.hasCondition+"<br>",5)
            	}
            	
            	
            },'->',{
            	xtype:'checkbox', 
            	id:'treeChb',
            	boxLabel :wmsg.wfdesign.showText,
            	checked :true,
            	listeners :{
            		'check':function(checkbox,checked){
            	
            			var buttons  = 	Ext.getCmp('tabDesign').getTopToolbar().items
            			if(checked){
            				for(var i=0;i<buttons.length;i++){
            					var obj = buttons.get(i);
 	           					if(obj instanceof Ext.Toolbar.Button || obj instanceof Ext.Toolbar.SplitButton){
 	           						if(obj.getId().indexOf('showText')!=-1)
 	           							if(obj.tooltip.indexOf('(')!=-1){
 	           								obj.setText(obj.tooltip.substr(0,obj.tooltip.indexOf('(')))
 	           							}else{
	           								obj.setText(obj.tooltip)
	           							}
	           					}
            				}
            				
            			}else{
            				for(var i=0;i<buttons.length;i++){
            					var obj = buttons.get(i);
 	           					if(obj instanceof Ext.Toolbar.Button || obj instanceof Ext.Toolbar.SplitButton){
 	           						if(obj.getId().indexOf('showText')!=-1)
	           							obj.setText('')
	           					}
            				}
            			}
            		}
            	}
            	
            }]);
	 var c = new Ext.TabPanel({
		region:'center',
        activeTab:0,
        items:[{
            id:'tabDesign', 
            contentEl: 'mycanavs',
            title: wmsg.wfdesign.title,
            //iconCls: 'tabDesign',
            tbar: tb,
            autoScroll:true
        }/*,{
        	contentEl: 'myxml',
        	iconCls: 'tabXML',
            title: 'XML',
            tbar:[ new Ext.ux.UploadDialog.TBBrowseButton({text:'打开本地文件'}),{
            	//text: wmsg.wfdesign.validate,
            	tooltip: wmsg.wfdesign.validate,
            	iconCls: 'btn_validate',
            	//enableToggle : true,
            	//id:'showTextValidate',
            	handler: function(){
            		var flow = w._FLOW;
					flow.validate()
            	}
            }]
            //tbar:[ new Ext.form.TextField({text:'打开本地文件',inputType:'file'})]
        }*/]
	});
	
	c.on({
		'beforetabchange': function(t, newTab, currentTab){
			
			if(newTab){
				if(newTab.title=="XML"){
					Ext.get("myxml").dom.innerText = w._FLOW.getXmlContent().toString();
				}
			}
		}
	});
	
	var viewport = new Ext.Viewport({
        layout: 'border',
        items: [property,c]
	});
}else{

	 var c = new Ext.Panel({
		region:'center',
        id:'tabDesign', 
         contentEl: 'mycanavs',
         iconCls: 'tabDesign',
         tbar: [
            <%if(!Util.null2String(WFManager.getIsEdit()).equals("1") 
            		|| (Util.null2String(WFManager.getIsEdit()).equals("1")
            				&& WFManager.getEditor()==user.getUID())
            				){%>
            {
         	text: wmsg.wfdesign.editFlow,
         	tooltip: wmsg.wfdesign.editFlow,
         	iconCls: 'btn_edit',
         	handler: function(){
         		Ext.Ajax.request({
					   url: '/workflow/workflow/addwfnodeportal.jsp',
					   params: { wfid: '<%=workflowId%>' }
				});
         		
         		if(isFullScreen=='true'){
         		 	parent.document.getElementById('designFRM').src = "/workflow/design/wfdesign.jsp?type=edit&wfId=<%=workflowId%>";
         		
         		}else{
         			window.showModalDialog('/workflow/design/wfdesignviewtmp.jsp?type=edit&wfId=<%=workflowId%>',window,
		         		'dialogWidth:'+document.body.offsetWidth+';dialogHeight:'+document.body.offsetHeight)
         		}
         		
         		
         		}	
         	},
			<%}%>
         	{
         		text:isFullScreen=='true'?wmsg.wfdesign.close:wmsg.wfdesign.fullScreen,
         		tooltip:isFullScreen=='true'?wmsg.wfdesign.close:wmsg.wfdesign.fullScreen,
         		iconCls:isFullScreen=='true'? 'btn_close':'btn_fullScreen',
         		id: 'fullScreen',
         		handler:function(){
         			var text = Ext.getCmp('fullScreen').getText();
         			if(text==wmsg.wfdesign.fullScreen){
         			
         				window.showModalDialog('/workflow/design/wfdesignviewtmp.jsp?type=view&isFullScreen=true&wfId=<%=workflowId%>&timeStamp='+new Date().getTime(),window,
         					'dialogWidth:'+document.body.offsetWidth+';dialogHeight:'+document.body.offsetHeight)
         			}else{
         				window.close();
         			}
         		}
         		
         	}
        ],
         autoScroll:true
        });
	
	var viewport = new Ext.Viewport({
        layout: 'fit',
        items: [c]
	});
}
Ext.get('loading').fadeOut();
Ext.getDom("mycanavs").style.display ="";
Ext.getDom("mycanavs").contentWindow.document.body.focus();
property.setSource(w._FLOW.getPropertySource());

document.onkeydown = function(){
	 switch(event.keyCode){
	 	case 83: //s
	      if(event.ctrlKey) Ext.getDom("mycanavs").contentWindow.mnuSaveFlow();
	      break;
	 }
}

});


function setNodeEnable(name,enabled){
	
	if(name == undefined){
		name = 'create';
		enabled = hasCreate;
	}
	//alert(hasCreate)
	var button = Ext.getCmp('showText'+name);
	if(enabled){
		button.enable()
	}else{
		button.disable()
	}
}

if(type=='edit'){
	//setTimeout('setNodeEnable()',2000);
}

function setButtonPressed(name,press){
	var btnName = 'showText'+name;
	var button = Ext.getCmp(btnName);
	if(button==undefined){
		//window.setTimeout("",2000)
	}else{
		button.toggle(press);
	}
	
}

function changeProcType(value){
	var w = Ext.get('mycanavs').dom.contentWindow
	var proc = w._FLOW.getProcByID(w._FOCUSTEDOBJ.id);
	if(proc.nodetype == 0){
		setNodeEnable("create",true);
	}
	
	switch(value){
		case wmsg.wfdesign.create:
			proc.nodetype = 0;
			setNodeEnable("create",false);
			break;
		case wmsg.wfdesign.approve:
			proc.nodetype = 1;
			break;
		case wmsg.wfdesign.realize:
			proc.nodetype = 2;
			break;
		case wmsg.wfdesign.process:
			proc.nodetype = 3;
			break;
	}
	
	
	if(proc.ProcType=='realize'||proc.ProcType=='approve'){
		proc.ProcType = value==wmsg.wfdesign.realize?'realize':'approve';
		proc.Img = w._FLOW.Config._ImgPath+proc.ProcType+".gif"
		Ext.getDom("mycanavs").contentWindow.document.getElementById(proc.ID+'Img').src = proc.Img;
	}
}

//显示消息提示框
function showMessage(title,content,time,position){
	Weaver.Message.msg(title,content,time,position);
}

/**
 * 退出时将流程签入
 */
function window.onbeforeunload() {
	closewindow();
}

function closewindow() 
{   
	if(type=='edit'){
		var xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
		xmlHttp.onreadystatechange = function(){
			if (xmlHttp.readyState == 4) {
				try {
					eval(xmlHttp.responseText)
					if(result.status=='0'){
						//成功，刷新流程设置页面
						if(window.dialogArguments!=null){
							var href = window.dialogArguments.parent.location.href;
							if(href.indexOf("?")!=-1){
								href = href+"&fromWfEdit=true";
							}else{
								href = href+"?fromWfEdit=true";
							}
							window.dialogArguments.parent.location.replace(href)
						}
					}else{
						//失败
						parent.showMessage(wmsg.wfdesign.error,result.errormsg)
					}
				}
				catch(e) {
					alert(wmsg.wfdesign.checkinError);
				}
		    }
		}
		xmlHttp.open("POST", "/weaver/weaver.workflow.layout.WorkflowDesignOperatoinServlet?method=checkin&wfId=<%=workflowId%>", false);
		xmlHttp.send();
	}
}

/**
 * 获取当前流程图的修改状态
 */
function checkModified() {
	var w = Ext.get('mycanavs').dom.contentWindow;
	return w._FLOW.Modified;
}

function loadLocalXMLFile(fileName){
	if(fileName.substr(fileName.lastIndexOf(".")).toUpperCase()!='.XML')
	{
	 	alert("<%=SystemEnv.getHtmlLabelName(128936,user.getLanguage())%>"+fileName.substr(fileName.lastIndexOf(".")).toUpperCase());
		return;
	}
	//fileName =fileName.replace(new RegExp('/','gm'),'\\');
	fileName="c:\\aa.xml"
	//alert(fileName); 
	
	var w = Ext.get('mycanavs').dom.contentWindow;
	w._FLOW.loadFromXML(Ext.get("myxml").dom.innerText);
	//w._FLOW.loadFromLocalXML(fileName);

}

<%if(Util.null2String(WFManager.getIsEdit()).equals("1") && WFManager.getEditor()!=user.getUID()){%>
if(isFullScreen!='true')
	alert(wmsg.wfdesign.checkoutMsg);
<%}%>
</script>
</head>
  
<body oncontextmenu="return false">
<div id="north">
	<div id="menudiv"></div>
</div>
<div id="south"></div>
<iframe id="mycanavs" style="display:none" src="wfdesigncontent.jsp?type=<%=type%>&wfId=<%=workflowId%>" style="width:100%;height:100%;" frameborder="0" scroll="auto"></iframe>
<textarea id="myxml" style="width:100%;height:100%;border:0;overflow:auto;"></textarea>
</body>
</html>