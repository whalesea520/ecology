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
		tbar : [{text:wmsg.wf.outspread,iconCls: 'btn_expandAll', handler: function(){
              ExpandOrCollapse(1)
            }},{text:wmsg.wf.shrink,iconCls: 'btn_collapseAll', handler: function(){
               ExpandOrCollapse(0)
            }}],
		items : [{
			columnWidth : .03,
			border : false
		}, {			
			xtype :  'TreeAdd',
			columnWidth : .30,
			dataUrl : "/workflow/request/RequestTypeJsonGet.jsp?remainder=0"
		}, {
			columnWidth : .03,
			border : false
		}, {
			xtype : 'TreeAdd',
			columnWidth : .30,
			dataUrl : "/workflow/request/RequestTypeJsonGet.jsp?remainder=1"
		}, {
			columnWidth : .03,
			border : false
		}, {
			xtype : 'TreeAdd',
			columnWidth : .30,
			dataUrl : "/workflow/request/RequestTypeJsonGet.jsp?remainder=2"
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