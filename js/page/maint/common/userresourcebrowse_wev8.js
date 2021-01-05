var mystore = new Ext.data.SimpleStore({
    fields: [
       {name: 'name'},
       {name: 'size'},
       {name: 'date'}
    ],
    listeners:{
    	datachanged : function(){
    		setFileChecked(file);
    	}
    }
});

//选择文件名
var checkedFile='';

//当前操作
var operate='';
/*define tree panel*/
wfTreePanel = function(){
    wfTreePanel.superclass.constructor.call(this, { 
    	contentEl:"container_id",
        width: 200,
        minSize: 175,
        maxSize: 400,
        useArrows: true,
        animate:false,
        border:true,
		header : false,
		
        footer:false

    });

};

Ext.extend(wfTreePanel, Ext.Panel, {
    autoScroll:true
});

/*define Grid*/
Ext.override(Ext.grid.GridView, {
    templates: {
        cell: new Ext.Template('<td class="x-grid3-col x-grid3-cell x-grid3-td-{id} {css}" style="{style}" tabIndex="0" {cellAttr}>', '<div class="x-grid3-cell-inner x-grid3-col-{id}" {attr}>{value}</div>', "</td>")
    }
});


    
 var sm = new  Ext.grid.CheckboxSelectionModel({header:'',singleSelect:singleSelect,listeners :{rowselect: onCheckFile}});
 var gridColumns ;
 
 if(isSystem){
 	gridColumns =   new Ext.grid.ColumnModel([
 		sm,
 			{
           id:'name',
           header: urmsg.name,
           dataIndex: 'name',
           width: 200,
           sortable:true,
           editor: new Ext.form.TextField({
               allowBlank: false
           })
        },{
           header: urmsg.size,
           dataIndex: 'size',
           sortable:true,
           width: 40
        },{
           header: urmsg.lastModified,
           dataIndex: 'date',
           sortable:true,
           width: 80
           
        }
    ]);
 }else{
 gridColumns =   new Ext.grid.ColumnModel([
 		sm,
 			{
           id:'name',
           header: urmsg.name,
           dataIndex: 'name',
           width: 200,
           sortable:true
        },{
           header: urmsg.size,
           dataIndex: 'size',
           sortable:true,
           width: 20
        },{
           header: urmsg.lastModified,
           dataIndex: 'date',
           sortable:true,
           width: 80
           
        }
    ]);
 }

wfTreeGrid = function(viewer, config){
	
    this.viewer = viewer;
    Ext.apply(this, config);
    this.id = "id";
    this.store = mystore;
	this.store.setDefaultSort("name", "asc");
	this.stripeRows=true;
    
    //this.cm= new Ext.grid.ColumnModel([new Ext.grid.RowNumberer()].concat(sm).concat(mycolumns));	
    this.cm = gridColumns;
    this.columns =gridColumns;
    this.sm = sm;
    
    wfTreeGrid.superclass.constructor.call(this, {
    	border:false,
    	style:'border-top:1px solid  #D0D0D0',
        region: 'center',  
        clicksToEdit:2,
        
	    listeners: {
	       validateedit : function(e){
				if(!checkFileName(e.value,'file')){
					return false;
				}else{
					return rename(e.originalValue,e.value);
				}
				
	       }
        },
        loadMask: {
            msg: wmsg.grid.loadMask
        },        
        stripeRows: true,    
        viewConfig: {
            forceFit: true
        }
    });
};



/*GridPanel*/
Ext.extend(wfTreeGrid, Ext.grid.EditorGridPanel, {		

});


/*define mainPanel*/
MainPanel = function(){
	this.grid = new wfTreeGrid();
	wfTrees = new wfTreePanel();
    wfTrees.setTitle(urmsg.fileDir);
 	panelLeft=new Ext.TabPanel({		
			border:false,			
            activeTab: 0,
            region: 'west',
            id: 'east-panel',  
			//collapseMode:'mini',   				
			//collapsible: true,          
            //split: true,  
            width: 125,
            //collapseFirst:true, 
            tabPosition: 'top',
            minSize: 125,
            maxSize: 125,	                
           items: [wfTrees]
                          
        });
    //btn
    MainPanel.superclass.constructor.call(this, {
        id: 'main-tabs',
        activeTab: 0,
        region: 'center',
        layout:'fit',
        margins: '5 5 5 5',
        resizeTabs: true,
        tabWidth: 150,
        minTabWidth: 120,
        enableTabScroll: true,
        border:false,
        buttons :[{
		        	id:'submit',
		            text: urmsg.submit,
		            iconCls: '',
		            handler: onSubmit,
		            scope: this
		        },{
		        	id:'open',
		            text: urmsg.cancel,
		            iconCls: '',
		            handler: onCancel,
		            scope: this
		        },{
		        	id : 'clear',
		            text: urmsg.clear,
		            iconCls: '',
		            handler: onClear,
		            scope: this
		        }],
		buttonAlign :"center",
        items: {
            id: 'main-view',
            layout: 'border',
            items: [
	            panelLeft,
	            {   
	            	id:'panelRight',
	            	xtype:'panel',
	            	region: 'center',
	            	layout:'border',
	            	//border:false,
	            	tbar:[
	            		{
					        	id:'wfType',
					        	height:27,
					        	//handleMouseEvents :false,
					            text: urmsg.createDir,
					            hidden:!isSystem,
					            
					            iconCls: '',
					            handler: createDir,
					            scope: this
					        },{
					        	id:'open',
					        	height:27,
					        	//handleMouseEvents :false,
					            text: urmsg.renameDir,
					            hidden:!isSystem,
					           
					            iconCls: '',
					            handler: renameDir,
					            scope: this
					        },{
					        	id : 'deleteDir',
					        	height:27,
					        	//handleMouseEvents :false,
					            text: urmsg.deleteDir,
					            
					            hidden:!isSystem,
					            handler:deleteDir,
					            scope: this
					        },{
					        	id : 'deleteFile',
					        	//handleMouseEvents :false,
					        	height:27,
					            text: urmsg.deleteFile,
					           
					            hidden:!isSystem,
					            handler:deleteFile,
					           
					            scope: this
					        },uploadBtn
					        
					        ],
	            	items:[
	            		{
		            		id:'uploadPanel',	
		            		border:false,         		
		            		xtype:'panel',
		            		region: 'north',
							autoScroll:true,
							autoHeight : true,
		            		contentEl:"uploadDiv",
		            		listeners:{
		            			render:function(panel){
		            				panel.hide();
		            			}
		            		}
	            		},
	            		this.grid,
	            		
	            		{
	            			xtype:'panel',
	            			region: 'south',
	            			split:true,
	            			border:false,
	            			style:'border-top:1px solid  #D0D0D0',
	            			collapseMode:'mini',
	            			html:'<div style="overflow:auto;width:100%;height:100%"><table width="100%" height="100%"><tr><td style="overflow:auto;text-align:center;height:100%;" valign="middle" id="divPreview"></td></tr></table></div>',
	            			height:150
	            		}
	            		
	            	]
				}
			]
        }
    });
};

Ext.extend(MainPanel, Ext.Panel, {});
/*define viewport*/
Ext.onReady(function(){
	
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = '/js/extjs/resources/images/default/s_wev8.gif';
	Ext.useShims = true;
    mainPanel = new MainPanel();
	
    viewport = new Ext.Viewport({
        layout: 'border',
	     items: [        	
    	 mainPanel]
    });
    init();
   	if(fileExist=='false'){
   		$("#divPreview").append("<font>"+urmsg.fileNotExist+"</font>");   		
	}
    Ext.get('loading').fadeOut();
});

/**
 * 判断文件名是否合法
 * @param {} name
 * @return {Boolean}
 */
function checkFileName(name,type) {
    var pattern=/[\/\\\:\*\?\"\<\>\|]/;
    if($.trim(name)==''){
    	alert(urmsg.noNull);
    	return false;
    }
    
    if(name.indexOf(' ')!=-1) {
        alert(urmsg.noSpace);
        return false;
    }
   	if(type=='dir'){
   		if(name.length>100){
   			alert();
   		}
	    if(!name.toLowerCase().match(/^[0-9^a-za-z]*$/)) {
	        alert(urmsg.noSpecialChar);
	        return false;
	    }
   	}else{
   		if(!name.toLowerCase().match(/^[0-9^a-za-z^.]*$/)) {
	        alert(urmsg.noSpecialChar);
	        return false;
	    }
   	}
    
   
    
    if(/.*[\u4e00-\u9fa5]+.*$/.test(name)){
    	alert(urmsg.noChineseChar)
    	return false;
    }
    return true;
}

// 输入窗口
var height=110;
if(!isIE){
	height = 95
}
var win = new Ext.Window({
				layout: 'fit',
				width: 200,
				height: height,
				closeAction: 'hide',
				plain: true,
				shadow:false,
				autoScroll:true,
				modal: true,
				title:urmsg.dirName,
				items: new Ext.Panel({ 
				   id:'elDiv',         
				   autoHeight :true, 
				   autoWidth :true, 
				   border:false,
				   contentEl:'elDiv'
				   
				}),
				buttons:[{
					text:urmsg.submit,
					handler:submit
				},{
					text:urmsg.cancel,
					handler:cancel
				}]
})

//输入窗口确定按钮
function submit(){
	//创建目录
	if(operate=='createdir'){
		//验证目录名称
		newDir = $("#elId").val();
		if (checkFileName(newDir,'dir')){   
			var paras = "method=createDir&currentDir="+currentDir+"&newDir="+newDir;
			
			var result = doRequest(paras)
			if(!result["status"]){
				if(result["info"]==''){
					alert(urmsg.createDirFailure);
				}else{
					alert(result["info"]);
				}
			}else{
				reShowDir($("a[rel='"+currentDir+"']").parent(),escape($("a[rel='"+currentDir+"']").attr('rel').match( /.*\// )));
				$("#elDiv").hide();
				$("#elId").val('');
				win.hide();
			}
			
			
		}   
	}else if(operate=='renamedir'){ //重命名目录
		newDir = $("#elId").val();
		if (checkFileName(newDir,'dir')){  
			if(rename(currentDir,newDir)){
				var paretnDir = currentDir.substring(0,currentDir.substring(0,currentDir.length-1).lastIndexOf("/")+1);
				
				reShowDir($("a[rel='"+paretnDir+"']").parent(),escape($("a[rel='"+paretnDir+"']").attr('rel').match( /.*\// )));
				$("#elDiv").hide();
				$("#elId").val('');
				win.hide();
			}
			
		}    
	}
}

//输入窗口 取消按钮
function cancel(){
	$("#elDiv").hide();
	$("#elId").val('');
	win.hide();
	
}

/**
 * 创建目录
 */
function createDir(){
	operate='createdir'	
	$("#elDiv").show();
	$("#elId").val('');
	checkinput('elId','elIdSpan')
	win.show();
}

/**
 * 选中文件
 * @param {} filename
 */
function setFileChecked(filename){
	if(filename!=''){
		var index = mainPanel.grid.store.find('name',filename);
		if(index==-1){
			fileExist ='false';
		}else{
			sm.selectRow(mainPanel.grid.store.find('name',filename));
		}
	}

}

/**
 * 选择文件
 * @param {} sm
 * @param {} rowIndex
 * @param {} record
 * @return {Boolean}
 */
function onCheckFile(sm,rowIndex,record){

	checkedFile = currentDir+record.get('name');
	
	var extendname="";
	var pos=checkedFile.lastIndexOf(".");
	if(pos!=-1){
		extendname=checkedFile.substring(pos+1).toLowerCase();
		if(extendname=="jpg" ||extendname=="gif"||extendname=="png") {
			
			$("#divPreview").children().remove();
			$("#divPreview").append("<img id='previewImg'  src='"+checkedFile+"' align='absmiddle'>");
			
			if($("#previewImg").attr("width")>350){
				$("#previewImg").attr("width",350)
			}
			if($("#previewImg").attr("height")>120){
				$("#previewImg").attr("height",120)
				
			}
			return true;
		}		
	}
	$("#divPreview").children().remove();
	
}

/**
 * 确定
 */
var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}catch(e){}
function onSubmit(){
	//window.parent.returnValue=checkedFile;
	//window.parent.close();
		dialog.callbackfun(checkedFile);
		dialog.close();
}

/**
 * 取消
 */
function onCancel(){
	//window.parent.returnValue="false";
	//window.parent.close();
	dialog.close();
}

/**
 * 清除
 */
function onClear(){
	//checkedFile = "";
	//window.parent.returnValue="";
	//window.parent.close();
	dialog.callbackfun("");
	dialog.close();
}

/**
 * 显示上传队列
 */
function showUpload(){
	Ext.getDom('uploadDiv').style.display='';
	Ext.getCmp("uploadPanel").show();
	viewport.doLayout();
}	

/**
 * 隐藏上传队列
 */
function hideUpload(){
	Ext.getDom('uploadDiv').style.display='none';
	Ext.getCmp("uploadPanel").hide();
	viewport.doLayout();
}

/**
 * 删除目录
 */
function deleteDir(){
	//判断当前目录是否有权限删除
	if(!checkDirRight()){
		alert(urmsg.noRight);
		return false;
	}
	
	//确认删除
	if(isdel()){
		var paras = "method=deleteDir&currentDir="+currentDir;
		var result = doRequest(paras)
		
		if(!result["status"]){
			if(result["info"]==''){
				alert(urmsg.deleteFailure);
			}else{
				alert(result["info"]);
			}
			return false
		}else{
			var paretnDir = currentDir.substring(0,currentDir.substring(0,currentDir.length-1).lastIndexOf("/")+1);
			reShowDir($("a[rel='"+paretnDir+"']").parent(),escape($("a[rel='"+paretnDir+"']").attr('rel').match( /.*\// )));
			return true;
		}
	}
}

/**
 * 删除文件
 */
function deleteFile(){
	if(checkedFile==''){
		alert(urmsg.noSelect)
		return;
	}
	if(isdel()){
		var paras = "method=deleteFile&file="+checkedFile;
		
		var result = doRequest(paras)
		if(!result["status"]){
			if(result["info"]==''){
				alert(urmsg.deleteFailure);
			}else{
				alert(result["info"]);
			}
			return false
		}else{
			reShowDir($("a[rel='"+currentDir+"']").parent(),escape($("a[rel='"+currentDir+"']").attr('rel').match( /.*\// )));
			return true;
		}
	}
}

/**
 * 重命名目录
 */
function renameDir(){
	//判断当前目录是否可以重命名
	if(!checkDirRight()){
		alert(urmsg.noRight);
		return ;
	}
	operate='renamedir';
	var tmp = new Array();
	tmp = currentDir.split('/')	
	var dirName = tmp[tmp.length-2]
	$("#elId").val(dirName);
	$("#elDiv").show();
	checkinput('elId','elIdSpan')
	win.show();
}

/**
 * 重命名
 * @param {} oldName
 * @param {} newName
 * @return {Boolean}
 */
function rename(oldName,newName){
	
	var paras = "method=rename&currentDir="+currentDir+"&new="+newName+"&old="+oldName;
	var result = doRequest(paras)
	if(!result["status"]){
		if(result["info"]==''){
			alert(urmsg.renameFailure);
		}else{
			alert(result["info"]);
		}
		return false
	}else{
		return true;
	}
}

/**
 * Ajax 请求处理
 * @param {} paras
 */
function doRequest(paras){	 
	var obj; 
    if (window.ActiveXObject) { 
        obj = new ActiveXObject('Microsoft.XMLHTTP'); 
    } 
    else if (window.XMLHttpRequest) { 
        obj = new XMLHttpRequest(); 
    } 
	obj.open('post', "/weaver/weaver.page.maint.common.UserResourceServlet"+'?'+paras, false); 
    obj.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded'); 
    obj.send(null); 
    if (obj.status == "200") {
    	var responesText = obj.responseText.trim();
    	responesText = "var _result = " +responesText;
    	eval(responesText)
    	return _result;
	} else {
		return {status:'false',info:''};
	}			
    
}

/**
 * 判断当前目录权限是否可编辑
 */
function checkDirRight(){
	if(currentDir!="/page/resource/userfile/flash/"&&currentDir!="/page/resource/userfile/image/"
	&&currentDir!="/page/resource/userfile/video/"&&currentDir!="/page/resource/userfile/other/"){
		return true;
	}else{
		return false;
	}
}
