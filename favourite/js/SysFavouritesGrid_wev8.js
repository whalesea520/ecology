SysFavouritesGrid = function(viewer, config) {
    this.viewer = viewer;
    this.fields = ["id","title","link","adddate","importlevel","favouritetype"];
    Ext.apply(this, config);
    this.store = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url: '/favourite/SysFavouriteOperation.jsp'
		}),
		reader : new Ext.data.JsonReader({
			root : 'databody',
			totalProperty : 'total',
			id : 'id',
			fields :this.fields
		})
	});	
	this.store.load({params:{start:0, limit:10}});
	this.pagingBar = new Ext.PagingToolbar({
        pageSize: 10,
        store: this.store,
        displayInfo: true,
        displayMsg: favourite.maingrid.showitems+' {0} - {1} '+favourite.maingrid.of+' {2}',
        emptyMsg: favourite.maingrid.noitem
    });
    this.selectm = new Ext.grid.CheckboxSelectionModel();
    this.columns = [
      this.selectm,
      {
        id: 'type',
        header: favourite.maingrid.type,
        dataIndex: 'type',
        width: 20,
        renderer:  this.formatType
      },{
          id: 'title',
          header: favourite.maingrid.title,
          dataIndex: 'title',
          width: 350,
          renderer:  this.formatTitle,
          sortable:true
      },{
        id: 'importlevel',
        header: favourite.maingrid.importlevel,
        dataIndex: 'importlevel',
        width: 50,
        renderer:  this.formatImportlevel,
        sortable:true
    },{
        id: 'operation',
        header: favourite.maingrid.operation,
        width: 50,
        renderer:  this.formatOperation,
        sortable:true
    }];
    
    SysFavouritesGrid.superclass.constructor.call(this, {
        region: 'center',
        id: 'topic-grid',
        text :"topic-grid",
        //enableDragDrop : true,
        //ddGroup:'gridDDGroup',
        multiSelect: true,
        stripeRows: true,
        columns:this.columns,
        loadMask: {msg:favourite.maingrid.load},

        sm: this.selectm,
        viewConfig: {
            forceFit:true,
            enableRowBody:true,
            showPreview:true
        },
        width:600,
        bbar: this.pagingBar
    });
	
    this.on('contextmenu', this.onContextClick, this);
};

Ext.extend(SysFavouritesGrid, Ext.grid.GridPanel, {
    onContextClick : function(e){
        if(!this.menu){ 
            this.menu = new Ext.menu.Menu({
                id:'grid-ctx',
                items: [{
                    text: favourite.maingrid.newtab,
                    iconCls: 'new-tab',
                    scope:this,
                    handler: function(){
                    	if(this.ctxRecord)
                    	{
                        	this.viewer.openTab(this.ctxRecord);
                        }
                        else
                        {
                        	alert(favourite.maingrid.noselect);
                        }
                    }
                },'-',{
                    iconCls: 'new-win',
                    text: favourite.maingrid.newwin,
                    scope:this,
                    handler: function(){
                    	if(this.ctxRecord)
                    	{
                        	window.open(this.ctxRecord.data.link);
                        }
                        else
                        {
                        	alert(favourite.maingrid.noselect);
                        }
                    }
                },'-',{
                    iconCls: 'refresh-icon',
                    text:favourite.maingrid.flash,
                    scope:this,
                    handler: function(){
                        this.store.reload();
                    }
                }
                ,'-',{
                    iconCls: 'copy-icon',
                    text:favourite.maingrid.copy,
                    scope:this,
                    handler: function()
                    {
                    	var selections = this.getSelectionModel().getSelections();
                    	var returnvalue = this.copySysFavourites(selections);
                    	this.getSelectionModel().clearSelections();
                    }
                }
                ,'-',{
                    iconCls: 'move-icon',
                    text:favourite.maingrid.move,
                    scope:this,
                    handler: function()
                    {
                    	var selections = this.getSelectionModel().getSelections();
                    	var returnvalue = this.copySysFavourites(selections);
                    	if(returnvalue==1)
                    	{
                    		this.deleteSysFavourites(selections,2);
                    	}
                    	this.getSelectionModel().clearSelections();
                    }
                }
                ,'-',{
                    iconCls: 'delete-icon',
                    text:favourite.maingrid.deletedata,
                    scope:this,
                    handler: function(){
                    	var selections = this.getSelectionModel().getSelections();
                    	this.deleteSysFavourites(selections,1);
                    	this.getSelectionModel().clearSelections();
                    }
                }]
            });
            this.menu.on('hide', this.onContextHide, this);
        }
        e.stopEvent();
        this.ctxRecord = this.getSelectionModel().getSelected();
        this.menu.showAt(e.getXY());
    },
    onContextHide : function()
    {
    },
    loadSysFavourite : function(favourite) 
    {
   	    var favouriteid = favourite.id;
   	    var timestamp = (new Date()).valueOf();
        this.store.baseParams = {
            favouriteid:favouriteid,
            title: favourite.title,
            ti:timestamp
        };
        this.store.load({params:{start:0, limit:10}});
    },
	copySysFavourites: function(selections)
	{
		var sysfavouriteids = "";
		var count = 0;
		if(selections.length!=0)
		{
	        for(var i = 0; i < selections.length; i++) 
	    	{   
	        	var record = selections[i];
	        	sysfavouriteids = sysfavouriteids+","+record.get("id"); 
	        	count++;
	    	}   
	        var returnvalue = window.showModalDialog('/favourite/FavouriteBrowser.jsp?action=append&sysfavouriteids='+sysfavouriteids);
	        //alert("returnvalue : "+returnvalue);
	        return returnvalue;
        }
        else
        {
        	alert(favourite.maingrid.noselect);
        	return 0;
        }
	},
	deleteSysFavourites: function(selections,type)
	{
		var sysfavouriteid = "";
		var count = 0;
		if(selections.length!=0)
		{
			if(type==1)
			{
				if(!confirm(favourite.maingrid.suredelete)) return;
			}
	        for(var i = 0; i < selections.length; i++) 
	    	{   
	        	var record = selections[i];
	        	this.deleteSysFavourite(record,type);
	    	}   
        }
        else
        {
        	alert(favourite.maingrid.noselect);
        	return;
        }
	},
    togglePreview : function(show){
        this.view.showPreview = show;
        this.view.refresh();
    },

    formatImportlevel : function(value, p, record) 
    {
    	if(record.data.importlevel=="1")
    	{
    		return String.format(
                    '<span style="vertical-align:middle">'+favourite.maingrid.simple+'</span>');
    	}
    	else if(record.data.importlevel=="2")
    	{
    		return String.format(
                    '<span style="vertical-align:middle">'+favourite.maingrid.middle+'</span>');
    	}
    	else
    	{
    		return String.format(
                    '<span style="vertical-align:middle">'+favourite.maingrid.imports+'</span>');
    	}
    },
    formatOperation : function(value, p, record) 
    {
    	var title = record.data.title;
    	var re;
    	re = /\&/g;
   		title = title.replace(re, "��");
    	re = /\</g;
   		title = title.replace(re, "&lt;");    
   		re = /\>/g;
   		title = title.replace(re, "&gt;");  
   		re = /\"/g;
   		title = title.replace(re, "&quot;"); 
   		re = /\'/g;
   		title = title.replace(re, "��"); 
    	return "<a href=\"javascript:void(0);\" onclick=\"javascript:showOuterEditWindow('"+record.data.id+"','"+title+"','"+record.data.importlevel+"','"+record.data.favouritetype+"');\">"+favourite.maingrid.operatedit+"</a>";
    },
    editSysFavourite : function(data)
    {
    	if(this.win)
    	{
    		this.win.close();
    	}
    	this.store.reload();
    },
	deleteSysFavourite : function(selected,type)
	{
		var sysfavouriteid = selected.data.id;
		var store = this.getStore();
		Ext.Ajax.request({
            url: '/favourite/SysFavouriteOperation.jsp',
            method: 'POST',
            params: 
            {
            	action: "delete",
            	sysfavouriteid: sysfavouriteid
            },
            success: function(response, request)
    		{
    			store.remove(selected);
    		},
            failure: function ( result, request) 
            { 
				alert(favourite.maingrid.deletefailure);
			},
            scope: this
        });
	},
    formatOperate: function(value, p, record) 
    {
        return String.format(
                '<span style="vertical-align:middle">'+favourite.maingrid.operationtopic+'</span>');
    },
    formatTitle: function(value, p, record) 
    {
    	var title = record.data.title;
    	var re;
    	re = /\&nbsp/g;
   		title = title.replace(re, "��nbsp");
    	re = /\</g;
   		title = title.replace(re, "&lt;");    
   		re = /\>/g;
   		title = title.replace(re, "&gt;");  
   		re = /\"/g;
   		title = title.replace(re, "&quot;");
    	return String.format(
                '<a href="javascript:void(0)" onclick=\'javascript:openFullWindowForXtable("{0}");\'>{1}</a>',
                record.data.link, title
                );
    },
    formatType: function(value, p, record) 
    {
    	var image ="";
    	if(record.data.favouritetype=="1")
    	{
    		image = "<img src='/images_face/ecologyFace_2/LeftMenuIcon/MyDoc_wev8.gif' title='"+favourite.window.doc+"'>";
    	}
    	else if(record.data.favouritetype=="2")
    	{
    		image = "<img src='/images_face/ecologyFace_2/LeftMenuIcon/MyWorkflow_wev8.gif' title='"+favourite.window.workflow+"'>";
    	}
    	else if(record.data.favouritetype=="3")
    	{
    		image = "<img src='/images_face/ecologyFace_2/LeftMenuIcon/MyProject_wev8.gif' title='"+favourite.window.project+"'>";
    	}
    	else if(record.data.favouritetype=="4")
    	{
    		image = "<img src='/images_face/ecologyFace_2/LeftMenuIcon/MyCRM_wev8.gif' title='"+favourite.window.custom+"'>";
    	}
    	else
    	{
    		image = "<img src='/images/filetypeicons/html_wev8.gif' title='"+favourite.window.other+"'>";
    	}
    	return image;
    },
    showEditWindow : function(data)
    {
        this.win = new FavouriteEditWindow(data,2,favourite.maingrid.editfavourite);
        this.win.on('validsysfavourite', this.editSysFavourite, this);
        this.win.show();
    },
    afterRender : function(){
        SysFavouritesGrid.superclass.afterRender.call(this);
    }
});