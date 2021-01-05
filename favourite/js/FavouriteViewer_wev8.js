FavouriteViewer = {

};

Ext.onReady(function()
{
	    Ext.QuickTips.init();
	    
	    FavouriteViewer.getTemplate = function(link){
	    	var tpl = new Ext.Template('<iframe width="100%" HEIGHT="100%" scrolling="auto" noresize id="text" src="'+link+'"></iframe>');
	        return tpl;
	    }
	    var favourites = new FavouritesPanel();
	    var favouriteTabs = new FavouriteTabsPanel();
	    sysFavourites = new SysFavouritesPanel('favourite');
	   	var mainPanel = new Ext.Panel(
	   				{
						region:'center',
	        			resizeTabs:true,
	        			tabWidth:150,
	        			minTabWidth: 120,
	        			disable:true,
	        			enableTabScroll: true,
						layout:"border",
						layoutConfig: 
						{
							animate: true
						},
						items:
						[
							favouriteTabs,
							sysFavourites
						]}
				);    
	    favourites.on('favouriteselect', function(favourite)
	    {
	        sysFavourites.loadSysFavouriteBySelect(favourite);
	    });
	    Ext.Ajax.request({
				url : '/favourite/FavouriteOperation.jsp' , 
				method: 'POST',
				success: function (response, request) {				
					var responseArray = Ext.decode(response.responseText);
					 for(var i=0;i<responseArray.databody.length;i++)
					 {
	           			var attributes = {
	    						id:responseArray.databody[i].id,
	        					url:'/favourite/SysFavouriteOperation.jsp?favouriteid='+responseArray.databody[i].id,
	        					title:responseArray.databody[i].title,
	        					text: responseArray.databody[i].title,
	        					desc: responseArray.databody[i].desc, 
	        					order: responseArray.databody[i].order
	    				};
					 	favourites.showFavourite(attributes);
					 }														
				},
				failure: function ( result, request) { 
					alert(favourite.wiewer.loadfailure+result); 
				} 
		});	
	    var viewport = new Ext.Viewport({
	        layout:'border',
	        items:[
	            favourites,
	            mainPanel
	         ]
	    }); 
	
});

FavouriteViewer.LinkInterceptor = {
    render: function(p){
        p.body.on({
            'mousedown': function(e, t){
                t.target = '_blank';
            },
            'click': function(e, t){
                if(String(t.target).toLowerCase() != '_blank')
                {
                    e.stopEvent();
                    window.open(t.href);
                }
            },
            delegate:'a'
        });
    }
};