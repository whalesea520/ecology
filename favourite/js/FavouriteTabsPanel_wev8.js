FavouriteTabsPanel = function()
{
	var parenttab = this;
	var action = new Ext.Action({
        text: favourite.tabspanel.add,
        handler: function(){
            parenttab.addFavouriteTab();
        },
        iconCls: 'addtab'
    });
	FavouriteTabsPanel.superclass.constructor.call(this,{
        id:'favouritetabs',
        region:'north',
        height:25,
        width:"100%",
        style:"overflow:hidden;",
        
        items: [
           new Ext.Button(action)   
        ],
		listeners:
		{
			resize:function(bar,adjWidth,adjHeight,rawWidth,rawHeight) 
			{
				var divContent = null;
				if(Ext.get("favouriteinnertabs"))
				{
					divContent = Ext.get("favouriteinnertabs").dom;
					divContent.style.width = adjWidth -60;
					if(Ext.get("favouriteRightTab"))
					{
						var divRight = Ext.get("favouriteRightTab").dom;
						divRight.style.posLeft=divContent.offsetWidth+35;
					}
				}
			}
		}
	});
	
    this.initTabs();
};
Ext.extend(FavouriteTabsPanel,Ext.Toolbar,{
    initTabs: function()
    {
    	var parenttab = this;
    	var timestamp = (new Date()).valueOf();
    	Ext.Ajax.request({
			url : '/favourite/FavouriteTabOperation.jsp' , 
			method: 'POST',
			params: 
       		{
       		 	ti: timestamp
       		},
			success: function ( response, request) {				
				var responseArray = Ext.decode(response.responseText);
				 for(var i=0;i<responseArray.databody.length;i++)
				 {
				 	var data = responseArray.databody[i]; 
               		parenttab.addTab(data);
				 }		
				 parenttab.packFavouriteTab();
			},
			failure: function ( result, request) { 
				alert(favourite.tabspanel.addfailure+result);
			} 
		});
		
    },
    addTab:function(data)
    {
    	if(this.win)
    	{
    		this.win.close();
    	}
    	var id = data.id; 
   		var title = data.title;
   		var desc = data.desc;
        var order = data.order;
    	var parenttab = this;
    	var menu = new TabMenu(parenttab,data);
    	this.add({
    		id:"tbsplit_"+id,
    		iconCls: 'tabmenus',
    		xtype:"tbsplit",
    		handler:function()
    		{
    			parenttab.clickOpenFavouriteTab(id,title);
    		},
        	text: title,
        	title:title,
        	enableToggle: true,
        	menu: menu,
        	pressed: true
    	});
    },
    editTab : function(data)
    {
    	if(this.win)
    	{
    		this.win.close();
    	}
    	var edittab = this.items;
    	for(var i=1;i<edittab.getCount();i++)
   		 {
   		 	var obj= Ext.getCmp(edittab.get(i).id);  
   		 	if(obj)
		    {
	   		 	var objid = obj.id;
	   		 	objid = objid.substring(8,objid.lenght);
	   			if(data.id==objid)
	   			{
	   				obj.menu.setData(data);
			    	obj.menu.title = data.title;
			    	obj.title = data.title;
			    	obj.setText(data.title);
			    	obj.menu.items.items[0].title = data.title;
			    	obj.menu.items.items[1].title = data.title;
			    	obj.menu.items.items[2].title = data.title;
			    	var updatetab = Ext.getCmp("tab_"+objid);
			    	if(updatetab)
					{
						updatetab.setTitle(data.title);
					}
	   			}
   			}
   		 }
    	
    },
    deleteTab: function(data)
    {
    	var tabid = "tbsplit_"+data.id;
    	var obj= Ext.getCmp(tabid); 
    	var tabs = this.items;
    	tabs.remove(obj);
    	Ext.destroy(obj);
    	obj.destroy();
    },
    showTab:function(data)
    {
    	if(this.win)
    	{
    		this.win.close();
    	}
    	var id = data.id; 
   		var title = data.title;
   		var desc = data.desc;
        var order = data.order;
    	var parenttab = this;
    	var menu = new TabMenu(parenttab,data);
    	parenttab.add({
    		id:"tbsplit_"+id,
    		iconCls: 'tabmenus',
    		xtype:"tbsplit",
    		handler:function()
    		{
    			parenttab.clickOpenFavouriteTab(id,title);
    		},
        	text: title,
        	title:title,
        	enableToggle: true,
        	menu: menu,
        	pressed: true
    	});
    	parenttab.doLayout();
    	this.clickOpenFavouriteTab(id,title);
    },
    openFavouriteTab : function(item, checked)
    {
    	var itemid = item.id;
    	var tid = itemid.substring(5,itemid.length);
    	var title = item.title;
    	var mainpanel = Ext.getCmp('main-tabs');
        mainpanel.initTabPanel(tid,title);
        
    },
    clickOpenFavouriteTab : function(id, title)
    {
    	var mainpanel = Ext.getCmp('main-tabs');
        mainpanel.initTabPanel(id,title);
    },
    addFavouriteTab : function()
    {
    	this.win = new FavouriteEditWindow("",3,favourite.tabspanel.addtitle);
    	this.win.on('validfavouritetab', this.showTab, this);
    	var parray = this.getPosition();
        this.win.setPosition(parray[0]*1.5,parray[1]*60);
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
    editFavouriteTab : function(data)
    {
        this.win = new FavouriteEditWindow(data,3,favourite.tabspanel.edittitle);
        this.win.on('validfavouritetab', this.editTab, this);
        var parray = this.getPosition();
        this.win.setPosition(parray[0]*1.5,parray[1]*60);
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
    deleteFavouriteTab:function(data)
    {
    	var parenttab = this;
    	Ext.Ajax.request({
       		url: '/favourite/FavouriteTabOperation.jsp',
       		method: 'POST',
       		params: 
       		{
       		 	action: "delete",
       		 	tabid :data.id
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
						 	var tabdata = responseArray.databody[i];
						 	parenttab.deleteTab(tabdata);
						 }
						 var mainpanel = Ext.getCmp('main-tabs');
						 
						 var tabid = "tab_"+data.id;
						 mainpanel.closeTabPanel(tabid);
				 	}
    				else
    				{
    					alert(favourite.tabspanel.failure);
    					owindow.close();
    				}
    				
   				 }
   				 catch(e)
   				 {
   
   				 }
			},
       		failure: function ( result, request) 
       		{ 
				alert(favourite.tabspanel.failure); 
				owindow.close();
			},
       		scope: this
   		  });
    },
    packFavouriteTab : function()
    {
    	var divContent=Ext.get("favouritetabs").dom;
  		divContent.style.position="relative";
    	var divWrap= document.createElement("div");    	    	
    	divWrap.appendChild(divContent.firstChild);
    	divWrap.setAttribute("id","favouriteinnertabs");
    	divWrap.style.overflow="hidden";
    	divWrap.style.width=divContent.offsetWidth-50;
    	divWrap.style.margin="0 15 0 20";
    	
    	
    	var divLeft= document.createElement("div");   
    	divLeft.style.width="30px";
    	divLeft.style.position="absolute";
    	divLeft.style.posLeft=0;
    	divLeft.style.posTop=0;
    	divLeft.innerHTML="<img src='/favourite/images/scroll-left_wev8.gif' style=''>";
    	divLeft.onmousemove = Function("return doScrollerIE('left',20);");
    	
    	var divRight= document.createElement("div");
    	divRight.setAttribute("id","favouriteRightTab");
    	divRight.style.width="30px";
    	divRight.style.position="absolute";
    	divRight.style.posLeft=divContent.offsetWidth-20;
    	divRight.style.posTop=0;
    	divRight.innerHTML="<img src='/favourite/images/scroll-right_wev8.gif'>";
    	divRight.style.margin="0 0 0 0";
    	
    	divRight.onmousemove = Function("return doScrollerIE('right',20);");
    	divContent.appendChild(divLeft);
    	divContent.appendChild(divWrap);
    	divContent.appendChild(divRight);
    }
});
TabMenu = function(tab,data)
{
	var tab =tab;
	var data = data;
	this.setData(data);
	var id = data.id;
	var title = data.title;
	var parentMenu = this;
	TabMenu.superclass.constructor.call(this,{
		id: 'tabMenu_'+id,
        title:title,
        items: [
            {
            	id : 'open_'+id,
                text: favourite.tabspanel.open,
                title : title,
                iconCls: 'new-tab',
                handler : tab.openFavouriteTab
            },'-',
            {
            	id : 'rename_'+id,
                text: favourite.tabspanel.edit,
                title : title,
                iconCls: 'load-icon',
                handler : function()
                {
                	tab.editFavouriteTab(parentMenu.getData());
                }
            },'-',
            {
            	id : 'delete_'+id,
                text: favourite.tabspanel.deletedata,
                title : title,
                iconCls: 'delete-icon',
                handler : function()
                {
                	if(!confirm(favourite.tabspanel.deletetopic)) return;
                	tab.deleteFavouriteTab(parentMenu.getData());
                }
            }
        ]
	});
};
Ext.extend(TabMenu,Ext.menu.Menu,{
	getData: function()
	{
		return this.data;
	},
	setData : function(data)
	{
		this.data = data;
	}
});