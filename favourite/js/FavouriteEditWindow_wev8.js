/*
 * Ext JS Library 2.2
 * Copyright(c) 2006-2008, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * http://extjs.com/license
 */

FavouriteEditWindow = function(data,type,title) 
{
	this.type = type;
	this.data = data;
	this.initfield = this.init(data,type);
    this.form = new Ext.FormPanel({
        frame : false,
        title : "",
        labelAlign:'right',
        labelWidth:85,
        bodyBorder :false,
        width: '100%',
        height: '100%',
        waitMsgTarget: true,
        items:[
        	new Ext.form.FieldSet(
        	{
        		autoHeight:true,
        		defaultType : 'textfield',
        		items :this.initfield
        	})
        ],
        border: false,
        bodyStyle:'background:transparent;padding:10px;'
    });

    FavouriteEditWindow.superclass.constructor.call(this, {
        title: title,
        iconCls: 'feed-icon',
        id: 'add-feed-win',
        width: 350,
        autoHeight: true,
        resizable: false,
        plain:true,
        modal: true,
        autoScroll: true,
        closeAction: 'close',

        buttons:[{
            text: favourite.window.save,
            handler: this.save,
            scope: this
        },{
            text: favourite.window.cancel,
            handler: this.closewin,
            scope: this
        }],
        items: this.form
    });

    this.addEvents({add:true});
}

Ext.extend(FavouriteEditWindow, Ext.Window, {
	defaultImportLevel : [
        [favourite.window.simple,'1'],
        [favourite.window.middle,'2'],
        [favourite.window.imports,'3']
    ],
    defaultFavouriteType : [
        [favourite.window.doc,'1'],
        [favourite.window.workflow,'2'],
        [favourite.window.project,'3'],
        [favourite.window.custom,'4'],
        [favourite.window.other,'0']
    ],
    save: function() 
    {
    	var id = "";
        var desc = "";
        var order = "";
        var importlevel = "";
        var favouritetype = "";
        if(this.data!="")
        {
        	id = this.data.id;
        }
        var title = this.form.getForm().findField("title").getValue();
        var descfield = this.form.getForm().findField("desc");
        var orderfield = this.form.getForm().findField("order");
        var importlevelfield = this.form.getForm().findField("importlevel");
        var favouritetypefield = this.form.getForm().findField("favouritetype");
        title=title.replace(/(^\s*)|(\s*$)/g, "");
        if(title == "")
        {
        	alert(favourite.window.namenonull);
        	var titlefield = this.form.getForm().findField("title");
        	titlefield.reset();
        	titlefield.focus(true,100);
   			return;
        }
        if(descfield)
        {
        	desc = descfield.getValue();
	        order = this.form.getForm().findField("order").getValue();
	        var r = /^-?[0-9]+$/g;　　//整数 
            var flag = r.test(order);
	        if(!flag)
	        {
	        	alert(favourite.window.order);
	        	orderfield.reset();
	        	orderfield.focus(true,100);
	   			return;
	        }
        }
        if(importlevelfield)
        {
        	importlevel = importlevelfield.getValue();
        }
        if(favouritetypefield)
        {
        	favouritetype = favouritetypefield.getValue();
        }
        var SaveRecord = Ext.data.Record.create([ 
			{name: 'id'}, 
			{name: 'title'}, 
			{name: 'desc'}, 
			{name: 'order'},
			{name: 'importlevel'},
			{name: 'favouritetype'}
		]);
		var savedata = new SaveRecord({ 
              			id: id, 
              			title: title, 
              			desc: desc, 
              			order: order,
              			importlevel:importlevel,
              			favouritetype:favouritetype
         			});  
        if(this.type=="1")
        {
        	this.saveFavourite(savedata.data);
        }
        else if(this.type=="2")
        {
        	this.saveSysFavourite(savedata.data);
        }
        else if(this.type=="3")
        {
        	this.saveFavouriteTab(savedata.data);
        }
    },
    closewin :function()
    {
    	this.close();
    },
    init: function(data,type)
    {
    	var initfield = null;
		if(type==1)
		{
			var title = "";
			var order ="";
			var desc = "";
			if(data!="")
			{
				title = data.title;
				order = data.order;
				desc = data.desc;
			}
			initfield = [{
        			fieldLabel: favourite.window.name,
        			name: 'title',
        			allowBlank :false,
        			msgTarget :'side',
        			value: title,
        			width:180
        		},{
        			fieldLabel: favourite.window.desc,
        			name: 'desc',
        			width:180,
        			value: desc
        		},
        		{
        			fieldLabel: favourite.window.displayorder,
        			name: 'order',
        			allowBlank :false,
        			msgTarget :'side',
        			width:50,
        			value: order
        		}];
		}
		else if(type==2)
		{
			var importlevel= "";
			var displayimport = "";
			var favouritetype = "";
			var displayfavouritetype = "";
			
			var title = "";
			if(data!="")
			{
				importlevel= data.importlevel;
				favouritetype = data.favouritetype;
				displayimport = this.getImportDisplay(importlevel);
				displayfavouritetype = this.getFavouriteTypeDisplay(favouritetype);
				title = data.title;
			}
			initfield = [{
        			fieldLabel: favourite.window.fname,
        			name: 'title',
        			value: title,
        			allowBlank :false,
        			msgTarget :'side',
        			width:180
        		},
        		new Ext.form.ComboBox({
        			fieldLabel: favourite.window.importlevel,
        			hiddenName: 'importlevel',
        			listeners:{
			            valid: this.syncShadow,
			            invalid: this.syncShadow,
			            scope: this
			        },
        			store: new Ext.data.SimpleStore({
			            fields: ['text','valuelevel'],
			            data : this.defaultImportLevel
			        }),
			        valueField:'valuelevel',
                    displayField:'text',
                    typeAhead: true,
                    mode: 'local',
                    triggerAction: 'all',
                    emptyText:displayimport,
                    value :importlevel,
                    selectOnFocus:true,
                    width:180
        		}),
        		new Ext.form.ComboBox({
        			fieldLabel: favourite.window.type,
        			hiddenName: 'favouritetype',
        			listeners:{
			            valid: this.syncShadow,
			            invalid: this.syncShadow,
			            scope: this
			        },
        			store: new Ext.data.SimpleStore({
			            fields: ['text','favouritetype'],
			            data : this.defaultFavouriteType
			        }),
			        valueField:'favouritetype',
                    displayField:'text',
                    typeAhead: true,
                    mode: 'local',
                    triggerAction: 'all',
                    emptyText:displayfavouritetype,
                    value :favouritetype,
                    selectOnFocus:true,
                    width:180
        		})];
		}
		else if(type==3)
		{
			var title = "";
			var order ="";
			var desc = "";
			if(data!="")
			{
				title = data.title;
				order = data.order;
				desc = data.desc;
			}
			initfield = [{
        			fieldLabel: favourite.window.tabname,
        			name: 'title',
        			value: title,
        			allowBlank:false,
        			msgTarget :'side',
        			width:180
        		},{
        			fieldLabel: favourite.window.desc,
        			name: 'desc',
        			width:180,
        			value: desc
        		},{
        			fieldLabel: favourite.window.displayorder,
        			name: 'order',
        			width:50,
        			allowBlank :false,
        			msgTarget :'side',
        			value: order
        		}];
		}
		return initfield;
    },
    getImportDisplay : function(importlevel)
    {
    	var displayimport = "";
    	if(importlevel==2)
		{
			displayimport = favourite.window.middle;
		}
		else if(importlevel==3)
		{
			displayimport = favourite.window.imports;
		}
		else
		{
			displayimport = favourite.window.simple;
		}
		return displayimport;
    },
    getFavouriteTypeDisplay : function(favouritetype)
    {
    	var displayfavouritetype = "";
    	if(favouritetype==1)
		{
			displayfavouritetype = favourite.window.doc;
		}
		else if(favouritetype==2)
		{
			displayfavouritetype = favourite.window.workflow;
		}
		else if(favouritetype==3)
		{
			displayfavouritetype = favourite.window.project;
		}
		else if(favouritetype==4)
		{
			displayfavouritetype = favourite.window.custom;
		}
		else
		{
			displayfavouritetype = favourite.window.other;
		}
		return displayfavouritetype;
    },
    saveFavourite: function(data)
    {
    	 var needtosave = this.favouriteIsChange(this.data,data);
    	 if(!needtosave&&this.data!="")
    	 {
    	 	this.close();
    	 	return;
    	 }
    	 if(!needtosave&&this.data=="")
    	 {
	    	 var fs = Ext.getCmp("favourite-tree").favourites.childNodes;
	   		 for(var i=0;i<fs.length;i++)
	   		 {
	   			if(fs[i].attributes.text==data.title)
	   			{
	   				alert(favourite.window.fanameexist);
	   				return;
	   			}
	   		 }
   		 }
   		 if(needtosave)
   		 {
   		 	if(data.title!=this.data.title)
   		 	{
   		 		 var fs = Ext.getCmp("favourite-tree").favourites.childNodes;
		   		 for(var i=0;i<fs.length;i++)
		   		 {
		   			if(fs[i].attributes.text==data.title&&this.data.id!=fs[i].attributes.id)
		   			{
		   				alert(favourite.window.tabnameexist);
		   				return;
		   			}
		   		 }
   		 	}
   		 }
    	 var owindow = this;
    	 var id = data.id;
    	 var action = "edit";
    	 if(id=="")
    	 {
    	 	action = "add";
    	 }
    	 Ext.Ajax.request({
       		url: '/favourite/FavouriteOperation.jsp',
       		method: 'POST',
       		params: 
       		{
       		 	action: action,
       		 	favouriteid:data.id,
       		 	favouritename:data.title,
       		 	favouritedesc:data.desc,
       		 	favouriteorder:data.order
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
	    					//Ext.MessageBox.alert('Success', favourite.window.success);
	    					return this.fireEvent('validfavourite', attributes);
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
			},
       		failure: function ( result, request) 
       		{ 
				alert(favourite.window.failure); 
				owindow.close();
			},
       		scope: this
   		  });
    },
   	saveSysFavourite: function(data)
   	{
   		var sysfavouriteid = this.data.id;
    	var oldtitle = this.data.title;
    	var oldimportlevel = this.data.importlevel;
    	var oldfavouritetype = this.data.favouritetype;
        var newtitle = data.title;
        var newimportlevel = data.importlevel;
        var newfavouritetype = data.favouritetype;
        if(oldtitle==newtitle&&oldimportlevel==newimportlevel&&oldfavouritetype==newfavouritetype)
        {
        	this.close();
        }
        else
        {
        	Ext.Ajax.request({
	            url: '/favourite/SysFavouriteOperation.jsp',
	            params: {
	            	title: newtitle,
	            	importlevel: newimportlevel,
	            	favouritetype:newfavouritetype,
	            	sysfavouriteid: sysfavouriteid,
	            	action: "edit"
	            },
	            success: function(response, request)
	            {
	            	var responseArray = Ext.decode(response.responseText);
				 	if(responseArray.databody.length>0)
				 	{
						 for(var i=0;i<responseArray.databody.length;i++)
						 {
						 	var tabdata = responseArray.databody[i];
	    					//Ext.MessageBox.alert('Success', favourite.window.success);
	    					return this.fireEvent('validsysfavourite', tabdata);
						 }
				 	}
    				else
    				{
    					alert(favourite.window.failure);
    					this.close();
    				}
	            },
	            failure: this.failure,
	            scope: this
        	});
        }
   	},
   	saveFavouriteTab : function(data)
   	{
   		var id = data.id;
    	var action = "edit";
    	if(id=="")
    	{
    	 	action = "add";
    	}
    	var needtosave = this.favouriteIsChange(this.data,data);
    	 if(!needtosave&&this.data!="")
    	 {
    	 	this.close();
    	 	return;
    	 }
	    var fs = Ext.getCmp("favouritetabs").items;
	    if(!needtosave&&this.data=="")
    	 {
    	 	var count = fs.getCount();
    	 	if(count!=1)
    	 	{
		   		 for(var i=1;i<fs.getCount();i++)
		   		 {
		   		 	var obj= Ext.getCmp(fs.get(i).id);  
		   		 	if(obj)
		   		 	{
			   		 	var objid = obj.id;
			   		 	objid = objid.substring(8,objid.lenght);
			   			if(obj.title==data.title)
			   			{
			   				alert(favourite.window.tabnameexist);
			   				return;
			   			}
		   			}
		   		 }
	   		}
   		 }
   		 if(needtosave)
   		 {
   		 	if(data.title!=this.data.title)
   		 	{
	   		 	var count = fs.getCount();
	    	 	if(count!=1)
	    	 	{
		   		 	for(var i=1;i<fs.getCount();i++)
			   		 {
			   		 	var obj= Ext.getCmp(fs.get(i).id);  
			   		 	var objid = obj.id;
			   		 	objid = objid.substring(8,objid.lenght);
			   			if(obj.title==data.title&&this.data.id!=objid)
			   			{
			   				alert(favourite.window.tabnameexist);
			   				return;
			   			}
			   		 }
			   	}
		   	}
   		}
   		Ext.Ajax.request({
       		url: '/favourite/FavouriteTabOperation.jsp',
       		method: 'POST',
       		params: 
       		{
       		 	action: action,
       		 	tabid :data.id,
       		 	tabname :data.title,
       		 	tabdesc :data.desc,
       		 	displayorder :data.order
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
						 	alert(favourite.window.success);
	    					return this.fireEvent('validfavouritetab', tabdata);
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
			},
       		failure: function ( result, request) 
       		{ 
				alert(favourite.window.failure); 
				owindow.close();
			},
       		scope: this
   		  });
   	},
    favouriteIsChange : function(olddata,newdata)
    {
    	var changed = false;
    	if(olddata!="")
    	{
    		if(olddata.title!=newdata.title)
    		{
    			changed = true; 
    		}
    		if(this.type==1||this.type==3)
    		{
    			if(olddata.desc!=newdata.desc)
	    		{
	    			changed = true; 
	    		}
	    		if(olddata.order!=newdata.order)
	    		{
	    			changed = true; 
	    		}
    		}
    		else
    		{
	    		if(olddata.importlevel!=newdata.importlevel)
	    		{
	    			changed = true; 
	    		}
	    	}
    	}
    	return changed;
    }
});