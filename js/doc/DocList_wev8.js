var viewport;
var panelContent;

Ext.onReady(function() {
	var loadCount = 0;
	panelContent = new Ext.Panel({
		xtype:'panel',
		region : 'center',
		border : true,
		autoScroll : true,

		margins : '0 8 5 5',
		layout : 'column',
		tbar : bar,
		items : [{
			columnWidth : .03,
			border : false
		}, {			
			xtype : 'TreeAdd',
			columnWidth : .30,
			dataUrl : "/docs/docs/DocListJsonGet.jsp?remainder=0"
		}, {
			columnWidth : .03,
			border : false
		}, {
			xtype : 'TreeAdd',
			columnWidth : .30,
			dataUrl : "/docs/docs/DocListJsonGet.jsp?remainder=1"
		}, {
			columnWidth : .03,
			border : false
		}, {
			xtype : 'TreeAdd',
			columnWidth : .30,
			dataUrl : "/docs/docs/DocListJsonGet.jsp?remainder=2"
		}]
	});

	viewport = new Ext.Viewport({
		layout : 'border',
		items : [panelTitle, panelContent]
	});

	Ext.get('loading').fadeOut();

});

function ExpandOrCollapse(state){
 var arrs=panelContent.findByType("TreeAdd");
 if(arrs!=null){
 	for (key in arrs)   {
 		
 		if(key=="remove" || key=="indexOf" ) continue;
 		//alert(key)
 		if(state==0)  arrs[key].collapseAll();
 		else arrs[key].expandAll();
   }
    viewport.doLayout();
 }
}