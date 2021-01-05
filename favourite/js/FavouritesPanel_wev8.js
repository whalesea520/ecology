/*
 * Ext JS Library 2.1
 * Copyright(c) 2006-2008, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * http://extjs.com/license
 */

FavouritesPanel = function() {
    FavouritesPanel.superclass.constructor.call(this, {
        id:'favourite-tree',
        region:'west',
        title:favourite.favouritepanel.manager,
        split:true,
        width: 225,
        minSize: 175,
        maxSize: 400,
        collapsible: true,
        margins:'0 0 5 5',
        cmargins:'0 5 5 5',
        rootVisible:false,
        lines:false,
        //enableDD : true,
        hlDrop :true,
        autoScroll:true,
        useArrows:true,
        //ddGroup:'gridDDGroup',
        animate:true,
        collapseFirst:false,
        root: new Ext.tree.TreeNode(favourite.favouritepanel.view),
        
		
        tbar: [{
            iconCls:'add-favourite',
            text:favourite.favouritepanel.add,
            handler: this.addFavourite,
            scope: this
        },'-',{
            id:'delete',
            iconCls:'delete-icon',
            text:favourite.favouritepanel.deleteitem,
            handler: function(){
                var s = this.getSelectionModel().getSelectedNode();
                if(s)
                {
                    this.removeFavourite(s);
                }
            },
            scope: this
        }],
        listeners: 
        {   
        	beforenodedrop: function(dropEvent) 
        	{   
            	var node = dropEvent.target;    // 目标结点   
            	var data = dropEvent.data;      // 拖拽的数据   
            	var point = dropEvent.point;    // 拖拽到目标结点的位置    
            	var source = dropEvent.source;
            	var currid = Ext.getCmp('main-view').text;
            	var targetid = node.id;
            	if(!data.node) 
            	{    
            		if(targetid==currid)
            		{
            			alert(favourite.favouritepanel.cannocopy);
            		}
            		else
            		{
            			this.ddToOtherFavourite(targetid,data.selections);
            		}
            	}   
          	},
          	dblclick :function(node,e)
          	{          		
          		var isExpanded = this.favourites.isExpanded();
            	if(!isExpanded)
            	{
            		this.favourites.expand(true,true,true);
            	}
          		var tab = Ext.getCmp('main-tabs').getActiveTab();
          		var id = tab.id;
          		var favouriteid = node.id;
          		if(id.indexOf('tab_')==0)
          		{
          			var rid = id.substring(4,id.lenght);
          			var currentframe = jQuery('#favouritetabframe_'+rid)[0];
          			var isexist = currentframe.contentWindow.document.getElementById("favouriteid_"+favouriteid);
          			if(isexist==null)
          			{
          				currentframe.contentWindow.onAddElement(favouriteid,rid);
	          		}
	          		else
	          		{
	          			alert(favourite.favouritepanel.exist);
	          		}
          		}
          		
          	}
       }
    });
    this.favourites = this.root.appendChild(
        new Ext.tree.TreeNode({
        	id:"-1",
            text:favourite.favouritepanel.myfavourite,
            cls:'favourites-node',
            id:"-1",
            url:'/favourite/SysFavouriteOperation.jsp',
            expanded:true
        })
    );
    this.favourites.expand(true,true,true);
    this.getSelectionModel().on({'selectionchange' : function(sm, node)
        {            
            if(node)
            {	
            	var tab = Ext.getCmp('main-tabs').getActiveTab();
          		var id = tab.id;
          		if(id.indexOf('tab_')!=0)
          		{
                	this.fireEvent('favouriteselect', node.attributes);
                }
            }
            this.getTopToolbar().items.get('delete').setDisabled(!node);
        },
        scope:this
    });

	
    this.addEvents({favouriteselect:true});
    this.on('contextmenu', this.onContextMenu, this);
     

};

Ext.extend(FavouritesPanel, Ext.tree.TreePanel, {
    onContextMenu : function(node, e){
        if(!this.menu){ // create context menu on first right click
            this.menu = new Ext.menu.Menu({
                id:'favourites-ctx',
                items: [{
                    id:'load',
                    iconCls:'load-icon',
                    text:favourite.favouritepanel.edit,
                    scope: this,
                    handler:function()
                    {
                    	var attributes = this.ctxNode.attributes;
                    	
                    	var id = attributes.id;
                    	var title = attributes.title;
                    	var desc = attributes.desc;
                    	var order = attributes.order;
                    	
                    	var FavouriteRecord = Ext.data.Record.create([ 
	          				{name: 'id'}, 
	          				{name: 'title'}, 
	          				{name: 'desc'}, 
	          				{name: 'order'}
	     				]);
						var favouriteRecord = new FavouriteRecord({ 
	               			id: id, 
	               			title: title, 
	               			desc: desc, 
	               			order: order
           				});  
           				
						var data = favouriteRecord.data;
                		this.showEditWindow(data);
            		}
                },'-',{
                    text:favourite.favouritepanel.deletes,
                    iconCls:'delete-icon',
                    scope: this,
                    handler:function(){
                        this.ctxNode.ui.removeClass('x-node-ctx');
                        this.removeFavourite(this.ctxNode);
                        this.ctxNode = null;
                    }
                },'-',{
                    iconCls:'add-favourite',
                    text:favourite.favouritepanel.addsys,
                    handler: this.addFavourite,
                    scope: this
                }]
            });
            this.menu.on('hide', this.onContextHide, this);
        }
        if(this.ctxNode){
            this.ctxNode.ui.removeClass('x-node-ctx');
            this.ctxNode = null;
        }
        if(node.isLeaf()){
            this.ctxNode = node;
            this.ctxNode.ui.addClass('x-node-ctx');
            this.menu.showAt(e.getXY());
        }
    },

    onContextHide : function(){
        if(this.ctxNode){
            this.ctxNode.ui.removeClass('x-node-ctx');
            this.ctxNode = null;
        }
    },
	newIndex :1,
    removeFavourite: function(node)
    {
    	var url = node.id;
        var favouriteid = url.substring(url.indexOf('=')+1,url.length);
    	if(favouriteid==-1)
        {
        	alert(favourite.favouritepanel.deleteerror);
        	return;
        }
    	if(!confirm(favourite.favouritepanel.deletetopic)) return;
        
		var parenttree = this;
        Ext.Ajax.request({
            url: '/favourite/FavouriteOperation.jsp',
            method: 'POST',
            params: {
            		 action: "delete",
            		 favouriteid:favouriteid
            		},
            success: function(response, request)
            {
            	var tabs = Ext.getCmp('main-tabs').items;
	           	for(var i=0;i<tabs.getCount();i++)
		   		{
		   			var id = tabs.itemAt(i).id;
		   			if(id.indexOf('tab_')==0)
	          		{
	                	var rid = id.substring(4,id.lenght);
	          			var currentframe = document.getElementById('favouritetabframe_'+rid);
	          			var isexist = document.getElementById("favouriteid_"+favouriteid);
	          			if(isexist!=null)
	          			{
	          				var oEdel = isexist.parentNode.parentNode;
	          				oEdel.parentNode.removeChild(oEdel);
		          		}
	                }
		   		}
		   		node.unselect();
	            Ext.get(node.ui.elNode).ghost('l', {
	                callback: node.remove, scope: node, duration: .4
	            });
	            parenttree.favourites.select();
          		
            },
            failure: function(response, request)
            {
            	//Ext.MessageBox.alert('Failed', '删除目录失败!'); 
            },
            scope: this
        });
    },
	editFavourite:function(attributes)
	{
		 if(this.win)
    	 {
    		this.win.close();
    	 }
    	 var fs = this.favourites.childNodes;
  		 for(var i=0;i<fs.length;i++)
  		 {
  			if(fs[i].attributes.id==attributes.id)
  			{
  				fs[i].setText(attributes.title);
  				fs[i].attributes.title = attributes.title;
  				fs[i].attributes.text = attributes.title;
  				fs[i].attributes.desc = attributes.desc;
  				fs[i].attributes.order = attributes.order;
  				var aid = Ext.getCmp('main-view').text;
  				if(aid==attributes.id)
  				{
  					Ext.getCmp('main-view').setTitle(attributes.title);
  				}
  				return;
  			}
  		 }
	},
	showFavourite : function(attributes)
    {
    	if(this.win)
    	{
    		this.win.close();
    	}
    	var favouriteid = attributes.id;
    	
       	Ext.apply(attributes, {
           	iconCls: 'favourite-icon',
           	leaf:true,
           	cls:'favourite',
           	id: favouriteid
       	});
       	var node = new Ext.tree.TreeNode(attributes);
       	this.favourites.appendChild(node);
    },
    ddToOtherFavourite :function(favouriteid, selections) 
    {   
    	var sysfavouriteid = "";
    	var count = 0;
    	for(var i = 0; i < selections.length; i++) 
    	{   
        	var record = selections[i];
        	sysfavouriteid = sysfavouriteid+","+record.get("id"); 
        	count++;
    	}   
    	Ext.Ajax.request({
            	url: '/favourite/SysFavouriteOperation.jsp',
            	method: 'POST',
            	params: 
            	{
            		 action: "append",
            		 favouriteid:favouriteid,
            		 sysfavouriteid:sysfavouriteid
            	},
            	success: function(response, request)
    			{
            		alert(favourite.favouritepanel.addsuccess);         			
        		},
            	failure: function ( result, request) 
            	{ 
        			alert(favourite.favouritepanel.copyfailure); 
				},
            	scope: this
        });       	
	},
	addFavourite : function(attrs)
    {
    	var isExpanded = this.favourites.isExpanded();
    	if(!isExpanded)
    	{
    		this.favourites.expand(true,true,true);
    	}
    	var node = new Ext.tree.TreeNode({
        			iconCls: 'favourite-icon',
        			leaf:true,
                    text:favourite.favouritepanel.newfavourite + (this.newIndex++),
                    cls:'favourite',
                    id: "",
                    url:""
                });
        var fs = this.favourites.childNodes;
        this.favourites.appendChild(node);
        var ge = new Ext.tree.TreeEditor(this, {
       		allowBlank:false,
       		blankText:favourite.favouritepanel.input,
       		selectOnFocus:true,
       		disabled:false,
       		editNode:false
   		});
       	ge.editNode = node;
       	ge.startEdit(node.ui.textNode);
       	ge.on("complete",function(objGe,n,o)
       	{   
       		var existnode = true;
       		for(var i=0;i<fs.length;i++)
       		{
       			if(fs[i].attributes.text==n&&fs[i]!=node)
       			{
       				existnode = false;
       			}
       		}
       		if(existnode)
       		{
			  var parenttree = this;       		
			  Ext.Ajax.request({
           		url: '/favourite/FavouriteOperation.jsp',
           		method: 'POST',
           		params: 
           		{
           		 	action: "add",
	       		 	favouriteid:"",
	       		 	favouritename:n,
	       		 	favouritedesc:n,
	       		 	favouriteorder:"1"
           		},
           		success: function(response, request)
   				{
       				try
       				{
           				var responseArray = Ext.decode(response.responseText);
					 	if(responseArray.databody.length>0)
					 	{
							 for(var i=0;i<responseArray.databody.length;i++)
							 {
			               		var attributes = {
			   						id:responseArray.databody[i].id,
			       					url:'/favourite/SysFavouriteOperation.jsp?favouriteid='+responseArray.databody[i].id,
			       					text: responseArray.databody[i].title,
			       					title:responseArray.databody[i].title,
			       					desc: responseArray.databody[i].desc, 
			       					order: responseArray.databody[i].order
			   					};
			   					node.id = attributes.id;
			   					node.setText(attributes.title);
			   					node.attributes.id = attributes.id;
				  				node.attributes.title = attributes.title;
				  				node.attributes.text = attributes.title;
				  				node.attributes.desc = attributes.desc;
				  				node.attributes.order = attributes.order;
							 }
					 	}
	    				else
	    				{
	    					alert(favourite.window.failure);
	    					owindow.close();
	    				}
       				 }
       				 catch(e)
       				 {
       
       				 }
       				 objGe.destroy();
   				},
           		failure: function ( result, request) 
           		{ 
					alert(favourite.favouritepanel.addfailure); 
				},
           		scope: this
       		  });
       		}
       		else
       		{
       			alert(favourite.other.fanameexist); 
       			objGe.editNode = node;
       		    setTimeout(function(){objGe.startEdit(node.ui.textNode);},100);
       		}
       		
       	});
        return node;
    },
	showAddWindow: function()
	{
        this.win = new FavouriteEditWindow("",1,favourite.favouritepanel.addfavourite);
        this.win.on('validfavourite', this.addFavourite, this);
        this.win.show();
	},
	showEditWindow: function(data)
	{
        this.win = new FavouriteEditWindow(data,1,favourite.favouritepanel.editfavourite);
        this.win.on('validfavourite', this.editFavourite, this);
        this.win.setPosition(this.getInnerWidth()/2,this.getInnerHeight()/4);
        this.win.show();
        var orderfield = this.win.form.getForm().findField("order");
        orderfield.getEl().on("keypress", function(e)
        {
        	if(!(((window.event.keyCode>=48) && (window.event.keyCode<=57))|| window.event.keyCode==45))
        	{
		    	window.event.keyCode=0;
		    }
        }, this);
	},
    afterRender : function(){
        FavouritesPanel.superclass.afterRender.call(this);
        this.el.on('contextmenu', function(e)
        {
            e.preventDefault();
        });
    }
});