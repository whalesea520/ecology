/*
 * Ext JS Library 2.1
 * Copyright(c) 2006-2008, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * http://extjs.com/license
 */

SysFavouritesPanel = function(type){
    this.initFavouritePanel();
    SysFavouritesPanel.superclass.constructor.call(this, {
        id:'main-tabs',
        activeTab:0,
        margins:'0 5 5 0',
        resizeTabs:true,
        region:'center',
        tabWidth:150,
        minTabWidth: 120,
        enableTabScroll: true,
        items: {
            id:'main-view',
            layout:'border',
            title:favourite.mainpanel.myfavourite,
            text:"-1",
            hideMode:'offsets',
            items:[
                this.showpanel]
        }
    });
    
};

Ext.extend(SysFavouritesPanel, Ext.TabPanel, {
	showpanel :null,
	gsm : null,
    loadSysFavouriteBySelect : function(favourite){
        this.showpanel.loadSysFavourite(favourite);
        Ext.getCmp('main-view').setTitle(favourite.text);
        Ext.getCmp('main-view').text = favourite.id;
    },
    loadTabBySelect : function(tab)
	{	
		Ext.getCmp('main-view').setTitle(favourite.text);
        Ext.getCmp('main-view').text = favourite.id;
	},
	initFavouritePanel : function()
	{	
		var parentpanel = this;
		var menu = new Ext.menu.Menu({
	        id: 'Menu',
	        title:"",
	        items: [
	            {
	            	id : 'adddoc',
	                text: favourite.mainpanel.adddoc,
	                title : favourite.mainpanel.adddoc,
	                iconCls: 'add-doc',
	                handler : function()
	                {
	                	var url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp";
	                	document.cookie="favouritetypes=1"; 
	                	parentpanel.addSysFavourites(url);
	                }
	            },
	            {
	            	id : 'addworkflow',
	                text: favourite.mainpanel.addworkflow,
	                title : favourite.mainpanel.addworkflow,
	                iconCls: 'add-workflow',
	                handler : function()
	                {
	                	var url = "/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp";
	                	document.cookie="favouritetypes=2";
	                	parentpanel.addSysFavourites(url);
	                }
	            },
	            {
	            	id : 'addpro',
	                text: favourite.mainpanel.addproj,
	                title : favourite.mainpanel.addproj,
	                iconCls: 'add-project',
	                handler : function()
	                {
	                	var url = "/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp";
	                	document.cookie="favouritetypes=3";
	                	parentpanel.addSysFavourites(url);
	                }
	            },
	            {
	            	id : 'addcus',
	                text: favourite.mainpanel.addcus,
	                title : favourite.mainpanel.addcus,
	                iconCls: 'add-custom',
	                handler : function()
	                {
	                	var url = "/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp";
	                	document.cookie="favouritetypes=4";
	                	parentpanel.addSysFavourites(url);
	                }
	            }
	        ]
    	});
		this.showpanel = new SysFavouritesGrid(this, {
	        tbar:['-',{
	            id:"add",
	        	text: favourite.mainpanel.add,
	        	title:favourite.mainpanel.add,
	        	enableToggle: true,
	        	iconCls: 'add-bottom',
	        	menu: menu,
	        	pressed: true
	        },'-',{
	        	id: "search_field",
	        	xtype:"textfield",
	        	width:190,
	            text:favourite.mainpanel.searchcon
	        },'-',{
	        	id: "search_button",
	        	xtype:"button",
	        	iconCls: "search-button",
	        	handler: this.searchSysfavourite,
	            text:favourite.mainpanel.search
	        }]
	    });
	    
	    this.gsm = this.showpanel.getSelectionModel();
	    this.showpanel.on('rowdblclick', this.openTab, this);
	    
	    
	},
	initTabPanel : function(tabid,title)
	{
		var tabspanel = Ext.getCmp("tab_"+tabid);
		if(tabspanel)
		{
			this.activate(tabspanel);
		}
		else
		{
	    	tabspanel = new Ext.Panel({
	            cls:'preview single-preview',
	            title: title,
	            id:"tab_"+tabid,
	            text:title,
	            html:'<iframe width="100%" HEIGHT="100%" scrolling="auto" noresize id="favouritetabframe_'+tabid+'" name="favouritetabframe_'+tabid+'" src="/favourite/FavouriteTabs.jsp?favouritetabid='+tabid+'"></iframe>',
	            closable:true,
	            height:'100%',
	            width:'100%',
	            autoScroll:true,
	            border:true
	        });
	        this.add(tabspanel);
	        this.activate(tabspanel);
        }
        
	},
	addSysFavourites:function(url)
	{	
		onShowBrowser(url);
		var store = this.showpanel.store;
		var resourceids = $GetEle("resourceids").value;
		var resourcenames = $GetEle("resourcenames").value;
		var favouritetype = $GetEle("favouritetypes").value;
		var jsonvalues = $GetEle("jsonvalues").value;
		var ItemData = Ext.data.Record.create([ 
          				{name: 'id'}, 
          				{name: 'title'}, 
          				{name: 'link'}, 
          				{name: 'adddate'}, 
          				{name: 'importlevel'}
     				]);
		if(""!=resourceids)
		{
			var importlevel = "1";
			var favouriteid = Ext.getCmp('main-view').text;
			Ext.Ajax.request({
       		url: '/favourite/SysFavouriteOperation.jsp',
       		method: 'POST',
       		params: 
       		{
       		 	action: "add",
       		 	favouriteid: favouriteid,
       		 	jsonvalues:jsonvalues,
       		 	importlevel: importlevel,
       		 	favouritetype:favouritetype
       		},
       		success: function(response, request)
			{
				 var responseArray = Ext.decode(response.responseText);
				 for(var i=0;i<responseArray.databody.length;i++)
				 {
				 	var d = new ItemData({ 
               			id: responseArray.databody[i].id, 
               			title: responseArray.databody[i].title, 
               			link: responseArray.databody[i].link, 
               			adddate: responseArray.databody[i].adddate, 
               			importlevel: responseArray.databody[i].importlevel,
               			favouritetype:responseArray.databody[i].favouritetype
           			}); 
				 	store.insert(0,d);
				 }
			},
       		failure: function ( result, request) 
       		{ 
				alert(favourite.mainpanel.addfailure);
			},
       		scope: this
   		  });
		  $GetEle("resourceids").value = "";
		  $GetEle("resourcenames").value = "";
		  $GetEle("favouritetype").value = "";
		  $GetEle("jsonvalues").value = "";
    	}
	},
	closeTabPanel: function(tabid)
	{
		this.remove(tabid);
	},
	searchSysfavourite:function()
	{
		var searchtitle = Ext.getCmp('search_field').getValue();
		//if(searchtitle=="")
		//{
		//	alert(favourite.mainpanel.searchalert);
		//	return;
		//}
		var maintabs = Ext.getCmp('main-tabs');
		var mainpanel = Ext.getCmp('main-view');
		var attributes = {
	 						id:"-2",
	     					url:'/favourite/SysFavouriteOperation.jsp',
	     					title: searchtitle,
	     					text: searchtitle
	 				};
	 	maintabs.showpanel.loadSysFavourite(attributes);
	    Ext.getCmp('main-view').setTitle(favourite.mainpanel.searchshow);
	    Ext.getCmp('main-view').text = "-2";
		maintabs.activate(mainpanel);
	},
    openTab : function(record){
        record = (record && record.data) ? record : this.gsm.getSelected();
        var d = record.data;
        var id = !d.link ? Ext.id() : d.link.replace(/[^A-Z0-9-_]/gi, '');
        var tab;
        if(!(tab = this.getItem(id)))
        {
        	var tabid = "link_"+id;
            tab = new Ext.Panel({
                id: tabid,
                cls:'preview single-preview',
                title: d.title,
                tabTip: d.title,
                html:'<iframe width="100%" HEIGHT="100%" scrolling="auto" noresize id="text" src="'+d.link+'"></iframe>',
                closable:true,
                listeners: FavouriteViewer.LinkInterceptor,
                autoScroll:true,
                border:true
            });
            this.add(tab);
        }
        this.setActiveTab(tab);
    },

    afterRender : function()
    {
        SysFavouritesPanel.superclass.afterRender.call(this);
    }
});