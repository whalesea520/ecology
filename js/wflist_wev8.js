 var mainPanel;
 var wfTrees;
 var wfTrees2;
 var activewfTrees;
 var viewport;
 var pageToolBar;
 var btnOpen;
 var btnSearch;
 var btnMultiSubmit;
 var panelLeft;
 var contentPanel;
 var searchPara;

 var noSubmitColumn = TableBaseParas.columns;
/*define tree panel*/
wfTreePanel = function(){
    wfTreePanel.superclass.constructor.call(this, {                
        width: 200,
        minSize: 175,
        maxSize: 400,
        useArrows: true,
        animate:false,
        border:true,
        rootVisible: false,
        autoScroll: true,
		header : false,
        footer:false,
        collapsible: true, 
        loader: new Ext.tree.TreeLoader({
            dataUrl:treeUrl
        }),
        selModel:new Ext.tree.MultiSelectionModel({onNodeClick: Ext.emptyFn}),
        root: new Ext.tree.AsyncTreeNode({
            text: '',
            cls: 'wfTrees-node',
            expanded: false
        }),
        collapseFirst: false,
        tbar: [
		new Ext.form.TextField({
            id:'searchFieldTree',
			width: 150,
            emptyText: wmsg.tree.quickSearch,
		
            listeners: {
                render: function(f){
                    f.el.on('keydown', filterWfTypeTree, f, {buffer: 350});
                }
            },
			 scope: this
        }), '->', {
            iconCls: 'btn_expandAll',
            tooltip: wmsg.tree.expandAll,
            handler: function(){
                this.root.expand(true)
            },
            scope: this
        }, {
            iconCls: 'btn_collapseAll',
            tooltip: wmsg.tree.collapseAll,
            handler: function(){
                this.root.collapse(true)
            },
            scope: this
        }]
		
		
    });

    this.filter = new Ext.tree.TreeFilter(this, {
		clearBlank: true,
		autoClear: true
	});
};


Ext.extend(wfTreePanel, Ext.tree.TreePanel, {
    filterTree: function(text){      	       
        this.expandAll();
        var re = new RegExp(Ext.escapeRe(text), 'i');
		
        this.filter.filterBy(function(n){
	        return !n.leaf || re.test(n.text);
        });
    }
    
});

var filterWfTypeTree=function(e){	
	var text=e.target.value;
	
 	text=text.trim();       
	if (!text || text== "" ||  text== wmsg.tree.quickSearch) {
        activewfTrees.filter.clear();
        return;
    }	
	
	activewfTrees.filterTree(e.target.value);		
}



/*define Grid*/
Ext.override(Ext.grid.GridView, {
    templates: {
        cell: new Ext.Template('<td class="x-grid3-col x-grid3-cell x-grid3-td-{id} {css}" style="{style}" tabIndex="0" {cellAttr}>', '<div class="x-grid3-cell-inner x-grid3-col-{id}" {attr}>{value}</div>', "</td>")
    }
});
var colField = getColumnFields(colsTableBaseParas);
wfTreeGrid = function(viewer, config){
	var wfTreeCheckboxPlugin = new  Ext.ux.plugins.CheckBoxMemory({hdID:'hdCheckBox'});
    this.viewer = viewer;
    Ext.apply(this, config);
    this.id = TableBaseParas.gridId;
    this.store =new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
			method : 'POST',			
			url : gridUrl
		}),		
		reader : new Ext.data.JsonReader({
			root : 'data',
			totalProperty : 'totalCount',
			id : 'id',
			fields :colField
		}),		
		remoteSort : true
	});	
	this.store.setDefaultSort(TableBaseParas.sort, TableBaseParas.dir);
	this.stripeRows=true;
    var sm = new  Ext.grid.CheckboxSelectionModel({header:'<div id="hdCheckBox" class="x-grid3-hd-checker">&#160;</div>',handleMouseDown: Ext.emptyFn});
    this.cm= new Ext.grid.ColumnModel([new Ext.grid.RowNumberer()].concat(sm).concat(colsTableBaseParas));	
    this.columns =new Ext.grid.ColumnModel([new Ext.grid.RowNumberer()].concat(sm).concat(colsTableBaseParas));	
    pageToolBar = new Ext.PagingToolbar({
        pageSize: TableBaseParas.pageSize,
        store: this.store,
        displayInfo: true,
        displayMsg: wmsg.grid.gridDisp1 + '{0} - {1}' + wmsg.grid.gridDisp2
				+ '{2}' + wmsg.grid.gridDisp3,
        emptyMsg: wmsg.grid.noItem
        
    });
    this.bbar = pageToolBar;
    
    wfTreeGrid.superclass.constructor.call(this, {
    	border:false,
    	style:'border-top:1px solid  #D0D0D0',
        region: 'center',        
        loadMask: {
            msg: wmsg.grid.loadMask
        },        
        sm: sm,
        plugins:[wfTreeCheckboxPlugin],
        stripeRows: true,    
        viewConfig: {
            forceFit: true
        }
        
       
    });
   
};


SubmitGrid = function(viewer, config){
	var checkboxPlugin = new Ext.ux.plugins.CheckBoxMemory({hdID:'hdCheckBoxSubmit'});
    this.viewer = viewer;
    Ext.apply(this, config);
    this.id = 'submitGrid';
    this.store =new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
			method : 'POST',			
			url : gridUrl
		}),		
		reader : new Ext.data.JsonReader({
			root : 'data',
			totalProperty : 'totalCount',
			id : 'id',
			fields :colField
		}),		
		remoteSort : true
	});	
	this.store.setDefaultSort(TableBaseParas.sort, TableBaseParas.dir);
	this.stripeRows=true;
    var sm = new  Ext.grid.CheckboxSelectionModel({header:'<div id="hdCheckBoxSubmit" class="x-grid3-hd-checker">&#160;</div>',handleMouseDown: Ext.emptyFn});
    this.cm= new Ext.grid.ColumnModel([new Ext.grid.RowNumberer()].concat(sm).concat(colsTableBaseParas));	
    this.columns =new Ext.grid.ColumnModel([new Ext.grid.RowNumberer()].concat(sm).concat(colsTableBaseParas));	

    this.bbar = new Ext.PagingToolbar({
        pageSize: TableBaseParas.pageSize,
        store: this.store,
        displayInfo: true,
        displayMsg: wmsg.grid.gridDisp1 + '{0} - {1}' + wmsg.grid.gridDisp2
				+ '{2}' + wmsg.grid.gridDisp3,
        emptyMsg: wmsg.grid.noItem
        
    });
    
    SubmitGrid.superclass.constructor.call(this, {
    	border:false,
    	style:'border-top:1px solid  #D0D0D0',
        region: 'center',        
        loadMask: {
            msg: wmsg.grid.loadMask
        },        
        sm: sm,
        plugins: [checkboxPlugin],
        stripeRows: true,    
        viewConfig: {
            forceFit: true
        }
    });

    
};

Ext.extend(SubmitGrid, Ext.grid.GridPanel, {
	formatTitle: function(value, p, record){
        return String.format('<div class="topic"><b>{0}</b><span class="author">{1}</span></div>', value, record.data.author, record.id, record.data.forumid);
    }
	
});

/*GridPanel*/
Ext.extend(wfTreeGrid, Ext.grid.GridPanel, {
			  
    loadwfTree: function(paras,base){ 
    	var url = '/workflow/request/ext/GridExtProxy.jsp';
    	if(TableBaseParas.gridId =='supervise' ){
    		url ='/workflow/request/ext/GridSuperviseExtProxy.jsp';
    	}
		
    	if(base){
    	   basePara = paras;
    	}
    	if(TableBaseParas.gridId=='myrequest' && isFirst){
    		
    		isFirst = false;
    		return;
    	}
    	searchPara = paras;
        Ext.Ajax.request({
					url : url+'?'+paras , 
					params : {
								 paras: paras,
								 columns:Ext.util.JSON.encode(TableBaseParas.columns)
							 },
					method: 'POST',
					success: function ( result, request) {
					
						eval(result.responseText);
						TableBaseParas.columns = allColumns;
						
						mainPanel.grid.store.baseParams={
				    		paras: paras,
							TableBaseParas : Ext.util.JSON.encode(TableBaseParas)			
						};						
						
						mainPanel.grid.store.reload({
							params : {
								start:0,
								limit:TableBaseParas.pageSize
							
							}
						});
						
						var panelRight = mainPanel.findById('panelRight');
						var panelToolBar = panelRight.findById('panelToolBar');	
						var toolbar= panelToolBar.getTopToolbar();
						
						if(TableBaseParas.gridId =='view'){
							var iframe = document.all('rightMenuIframe').contentWindow.document;
							var span = iframe.getElementById('submitRightMenu')
							var row = span.parentNode.parentNode.parentNode;
							if(TableBaseParas.multiSubmit =="true"){
								toolbar.items.get('submit').setVisible(true);	
								row.style.display ='';
							}else{
								toolbar.items.get('submit').setVisible(false);
								row.style.display ='none';
								//var table = row.parentNode;
								//table.removeChild(row);
							}
						}
																					
					},
					failure: function ( result, request) { 
						Ext.MessageBox.alert('Failed', 'Successfully posted form: '+result); 
					} 
				});		
    	},
    formatTitle: function(value, p, record){
        return String.format('<div class="topic"><b>{0}</b><span class="author">{1}</span></div>', value, record.data.author, record.id, record.data.forumid);
    },
    getSelection: function(){
    	return this.plugins[0].getSelection();
    }
});


/*define mainPanel*/
MainPanel = function(){
	this.grid = new wfTreeGrid();
	
    treeUrl = treeUrl+'&requestType=unfinished';
    wfTrees = new wfTreePanel();
    treeUrl = treeUrl.replace('unfinished','finished');
    wfTrees2 = new wfTreePanel();
    
    wfTrees.setTitle(wmsg.wf.pending+':'+unFinishedCount);
    wfTrees2.setTitle(wmsg.wf.finished+':'+finishedCount);
    wfTrees2.id ='finished';
    wfTrees.id = 'unfinished';
   
    if(TableBaseParas.gridId=='myrequest'){
    	panelLeft=new Ext.TabPanel({		
    				border:false,			
	                activeTab: 0,
	                region: 'west',
	                id: 'east-panel',  
					collapseMode:'mini',   				
					collapsible: true,          
	                split: true,  
	                width: 250,
	                collapseFirst:true, 
	                tabPosition: 'bottom',
	                minSize: 200,
	                maxSize: 400,	                
	               items: [wfTrees,wfTrees2]
	                              
	            }
	            );
	            panelLeft.on('tabchange',function(tabParent,tabThis){
	            	
	            	if(tabThis.getId()=='finished'){
	            		loadGrid(finishedPara,true);
	            	}else if(tabThis.getId()=='unfinished'){
	            		loadGrid(unfinishedPara,true);
	            	}
	            	
	            	activewfTrees = tabThis;
            		activewfTrees.on('click',function(node,e){
            			if(node.isExpanded()){
							node.collapse();
							node.collapseChildNodes();
						}else{
							node.expand();
						}
					});
	            });		
         	 	          
    } else {
    	panelLeft=new Ext.Panel({ 
    				xtype:'panel',
    				border:false,					
	                activeTab: 0,
	                region: 'west',
	                id: 'east-panel',  
					collapseMode:'mini',   	
					collapsed:'view'==TableBaseParas.gridId,
					collapsible: true,          
	                split: true,  
	                width: 250,
	                tabPosition: 'bottom',
	                minSize: 200,
	                maxSize: 400,
	                layout:'fit',	               
	                items: wfTrees
	            });
	            
	     activewfTrees = wfTrees;
	     activewfTrees.on('click',function(node,e){
		 	if(node.isExpanded()){
				node.collapse();
				node.collapseChildNodes();
			}else{
				node.expand();
			}
		 });
    }
    
    //btn
    MainPanel.superclass.constructor.call(this, {
        id: 'main-tabs',
        activeTab: 0,
        region: 'center',
        layout:'fit',
        margins: '0 8 5 5',
        resizeTabs: true,
        tabWidth: 150,
        minTabWidth: 120,
        enableTabScroll: true,   
        items: {
            id: 'main-view',
            layout: 'border',
            //title: '<img src="/images/wf/list_wev8.gif" align=absMiddle>&nbsp;'+wmsg.wf.list,//'流程类型列表',    
            items: [
	            panelLeft,
	            {   
	            	id:'panelRight',
	            	xtype:'panel',
	            	region: 'center',
	            	layout:'border',
	            	items:[
	            		{
	            		id:'panelToolBar',	   
	            		border:false,         		
	            		xtype:'panel',
	            		region: 'north',
	            		contentEl:'divSearch',
	            		tbar:[
	            		{
					        	id:'wfType',
					            text: wmsg.wf.hideWfType,
					            tooltip: {
					                text: wmsg.wf.displayWfType+'/'+wmsg.wf.hideWfType
					            },
					            iconCls: 'btn_displayAndHide',
					            handler: this.displayOrHideWfType,
					            scope: this
					        },{
					        	id:'open',
					            text: wmsg.wf.openChosenWf,
					            tooltip: {
					                text: wmsg.wf.openChosenWf
					            },
					            iconCls: 'btn_doOpen',
					            handler: this.openSelecteds,
					            scope: this
					        },{
					        	id : 'submit',
					            text: wmsg.wf.multiSubmit,
					            tooltip: {
					                text: wmsg.wf.multiSubmit
					            },
					            hidden:true,
					            iconCls: 'btn_Supervise',
					            handler:this.getMultiSubmit,
					            scope: this
					        },{
					        	id:'search',
					        	iconCls:'btn_search',
					        	text:wmsg.grid.search,
					        	tooltip:{
					        		text:wmsg.grid.search+'/'+wmsg.grid.hideSearch
					        	},
					        	handler:this.onSearch,		
					        	scope: this			        	
					        }
					        ]
	            		},
	            		this.grid
	            	]
				}
			]
        }
    });
    this.grid.loadwfTree(firstGridPara,true);
    

};

Ext.extend(MainPanel, Ext.Panel, {

    loadwfTree: function(wfTree){
        this.grid.loadwfTree(wfTree.paras,true);
    },
    
    
    openTab: function(url,title){
        /*url = url+'&isfromtab=true';
        var tab;
        if (!(tab = this.getItem(id))) {
            tab = new Ext.Panel({
                //id: id,
                cls: 'preview single-preview',
                title: '<img src="/images/wf/topic_wev8.gif" align=absMiddle>&nbsp;'+title,
                tabTip: title,
                html: "<IFRAME  SRC='"+url+"'  style='width:100%;height:100%'  BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE scrolling='auto'></IFRAME>",
                closable: true,
                autoScroll: true
            });
            this.add(tab);
        }
        this.setActiveTab(tab);*/
    	openFullWindowHaveBar(url);
    },    
  
    openSelecteds: function(){
    
    	var ids=this.grid.getSelection()
    	
    	ids = ids.split(',')
    	
    	ids.length = ids.length-1
    	if(ids.length>10){
    		if(confirm(wmsg.wf.openChosenWfSuggestion)!=true){
    			return;
    		}
    		
    	}
    	for(var i=0;i<ids.length;i++){	
	    	var url = '/workflow/request/ViewRequest.jsp'
	    	url = url+'?requestid='+ids[i];
	    	if(TableBaseParas.gridId =='supervise'){
	    		url=url+'&urger=1';
	    	}
	    	else{
	    		url=url+'&isovertime=0';
	    	}
	    	//var title = records[i].get('requestname');
	    	//var strArray=new Array();   
	    	//strArray=title.split(",");   
	    	//title = strArray[1];
	    	//strArray = title.split("'");
	    	//title = strArray[1];
	    	//title =title.replace(new RegExp('&lt;','gm'),'<');
	    	//title =title.replace(new RegExp('&gt;','gm'),'>');
	    	this.openTab(url,'');
    	}
    },
    
    getMultiSubmit:function(){
    	/*重写CheckBoxSelectionModel*/
    	Ext.override(Ext.grid.CheckboxSelectionModel, {
			renderer : function(v, p, record){				
					var chk="";
					if(record.get("multiSubmit")!=null){
						chk = record.get("multiSubmit").replace(/(^\s*)|(\s*$)/g, "");
					}
					if(chk=="false"){
						return '<div></div>';
					} else {				
			        	return '<div class="x-grid3-row-checker">&#160;</div>';
					}
			    },
			    
			selectAll: function() {       
				if(this.locked) return;
		        this.selections.clear();
		        var record = this.grid.store.getRange();
		        for(var i = 0, len = this.grid.store.getCount(); i < len; i++){
		        	if(record[i].get('multiSubmit')=='true'){
		            	this.selectRow(i, true);
		        	}
		        }
			}   
		});

    	
		var url = '/workflow/request/ext/GridExtProxy.jsp';
		
		var submitGrid = new SubmitGrid();
		var winSubmit = new Ext.Window({
	        layout: 'fit',
	        width: mainPanel.getSize().width-48,
	        resizable: true,
	        height:  mainPanel.getSize().height-100,
	        modal: true,
	        title: wmsg.wf.multiSubmit,
	        items:  submitGrid,
	        autoScroll: true,
	        buttons: [{
	            text: wmsg.base.submit,// '确定',
	            handler: function(){
	                var ids=submitGrid.plugins[0].getSelection();
					if(ids==''){
						alert(wmsg.wf.noneSelected);
						return;
					}
					this.setDisabled(true);
					ids = ids.substr(0,ids.length-1)
					
					var paras = 'multiSubIds='+ids;
					Ext.Ajax.request({
					url : '/workflow/request/RequestListOperation.jsp?'+paras , 					
					method: 'POST',
					success: function ( result, request) {
						reLoad();
						winSubmit.close();											
					},
					failure: function ( result, request) { 
						Ext.MessageBox.alert('Failed', 'Failed posted form: '+result); 
					} 
				});	
    	
	            }
	        },{
	       		text: wmsg.base.cancel,// '取消',
	            handler: function(){
	                 winSubmit.close();
	                 submitGrid.destroy();
	            }
	        	}],
	        listeners:{
	        	'close':function(){
	        			/*恢复CheckboxSelectionModel*/
	        			Ext.override(Ext.grid.CheckboxSelectionModel, {
						renderer : function(v, p, record){				
						        	return '<div class="x-grid3-row-checker">&#160;</div>';	
						    },
						selectAll: function() {       
							if(this.locked) return;
					        this.selections.clear();
					        for(var i = 0, len = this.grid.store.getCount(); i < len; i++){
				            	this.selectRow(i, true);
					        }
						}   
						});
	        	}
	        }
	    });
		Ext.Ajax.request({
					url : url+'?'+searchPara , 
					params : {
								 paras: searchPara,
								 columns:Ext.util.JSON.encode(TableBaseParas.columns)
							 },
					method: 'POST',
					success: function ( result, request) {
					
						eval(result.responseText);
						TableBaseParas.columns = allColumns;
						
						submitGrid.store.baseParams={
				    		paras: searchPara,
							TableBaseParas : Ext.util.JSON.encode(TableBaseParas)			
						};						
						
						submitGrid.store.reload({
							params : {
								start:0,
								limit:TableBaseParas.pageSize
							
							}
						});
					
						winSubmit.show(null);    
																					
					},
					failure: function ( result, request) { 
						Ext.MessageBox.alert('Failed', 'Successfully posted form: '+result); 
					} 
				});		    
	},
	/*搜索*/
	onSearch:function(){
	
		var panelRight = mainPanel.findById('panelRight');
		var panelToolBar = panelRight.findById('panelToolBar');	
		var toolbar= panelToolBar.getTopToolbar();
			
		if(Ext.getDom("divSearch").style.display=='none'){
			Ext.getDom("divSearch").style.display='';
			panelToolBar.setHeight(78);
			toolbar.items.get('search').setText(wmsg.grid.hideSearch);
			mainPanel.doLayout();
		}else{
			Ext.getDom("divSearch").style.display='none';
			toolbar.items.get('search').setText(wmsg.grid.search);
			panelToolBar.setHeight(25);
			mainPanel.doLayout();
		}	
		
		
	},
	/*隐藏或打开流程类型*/
	displayOrHideWfType:function(){
		
		var panelRight = mainPanel.findById('panelRight');
		var panelToolBar = panelRight.findById('panelToolBar');	
		var toolbar= panelToolBar.getTopToolbar();
		var iframe = document.all('rightMenuIframe').contentWindow.document;
		//alert(iframe.getElementById('openwf'));
		if(toolbar.items.get('wfType').getText()==wmsg.wf.displayWfType){
			panelLeft.expand();
			mainPanel.doLayout();
			toolbar.items.get('wfType').setText(wmsg.wf.hideWfType);
			
			iframe.getElementById('displayWfType').innerHTML=wmsg.wf.hideWfType;
		}else if(toolbar.items.get('wfType').getText()==wmsg.wf.hideWfType){
			panelLeft.collapse();	
			toolbar.items.get('wfType').setText(wmsg.wf.displayWfType);
			iframe.getElementById('displayWfType').innerHTML=wmsg.wf.displayWfType;
		}
		
	}
	   
});




/*define viewport*/


Ext.onReady(function(){
	
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = '/js/extjs/resources/images/default/s_wev8.gif';
	Ext.useShims = true;
    mainPanel = new MainPanel();
   
    //contentPanel = mainPanel.findById('main-view');
    panelLeft.on('collapse',function(thisPanel ){
    	var panelRight = mainPanel.findById('panelRight');
		var panelToolBar = panelRight.findById('panelToolBar');	
		var toolbar= panelToolBar.getTopToolbar();
		toolbar.items.get('wfType').setText(wmsg.wf.displayWfType);
    });
    
    panelLeft.on('expand',function(thisPanel ){
    	var panelRight = mainPanel.findById('panelRight');
		var panelToolBar = panelRight.findById('panelToolBar');	
		var toolbar= panelToolBar.getTopToolbar();
		toolbar.items.get('wfType').setText(wmsg.wf.hideWfType);
    });
    
  	/* Do not Delete */
  	//var items ;
  	/*if(TableBaseParas.gridId !='supervise'&& false){
  		items = [title,'->',{text:alltobedealed,tooltip:alltobedealed,handler:function(){loadGrid('method=all&complete=0');}}
  		,'-',{text:alldealed,tooltip:alldealed,handler:function(){loadGrid('method=all&complete=2');}}
  		,'-',{text:allfinished,tooltip:allfinished,handler:function(){loadGrid('method=all&complete=1'); }}
  		];
  	}else{
  		items = [title,'->'];
  	}*/
    if(isfromtab=='true'){
	    viewport = new Ext.Viewport({
	        layout: 'border',
	        items: [        	
	        	 mainPanel]
	    });
    }else{
    	viewport = new Ext.Viewport({
        layout: 'border',
        items: [        	
        	panelTitle, mainPanel]
    });
    }
    
    Ext.get('loading').fadeOut();
    
    
});



/* define function*/
function openWfToTab(url,title){
	mainPanel.openTab(url,title);

}
	
function getColumnFields(colsTableBaseParas) {
	var strFields = new Array();

	for (var i = 0; i < colsTableBaseParas.length; i++) {	   
		strFields = strFields.concat( colsTableBaseParas[i].dataIndex);
		
	}
	return strFields.concat(multiSubmit.dataIndex);
}

function loadGrid(paras,base){
	
	mainPanel.grid.loadwfTree(paras,base);
}

function firstPage(){
	pageToolBar.onClick("first");
}

function prePage() {
	if(pageToolBar.items.get(1).disabled==false){
		pageToolBar.onClick("prev")
	}
}
function nextPage() {
	if(pageToolBar.items.get(7).disabled==false){
		pageToolBar.onClick("next")
	}			
}
function lastPage() {
	pageToolBar.onClick("last")
}
function reLoad() {
	pageToolBar.onClick("refresh")
}


