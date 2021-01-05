Ext.ns('Weaver');
//dataUrl是必须要配置的
Weaver.TreeAdd = function(config) {
	var config = config || {};
	Ext.apply(this, config);

	Weaver.TreeAdd.superclass.constructor.call(this, {		
		listeners : {
			click : function(node, e) {
				this.onTreeClick(node, e);
			}
		},
		// hideCollapseTool:false,
		// useArrows: true,
		// collapsible : false,
		// animCollapse : false,
		border : false,		
		trackMouseOver:false,
		// autoScroll : false,
		 animate : false,
		// enableDD : false,
		// containerScroll : false,
		// collapseFirst : true,
		selModel : new Ext.tree.MultiSelectionModel({
			onNodeClick : Ext.emptyFn
		}),
		// singleExpand :true,
		// style:'height:20px',
		// pathSeparator :'|',
		rootVisible : false,
		root : new Ext.tree.AsyncTreeNode({
			expanded:true,
			text : 'root'
		}),
		loader : new Ext.tree.TreeLoader({
			listeners : {
				load : function(obj, node, response) {
					viewport.doLayout();
				}
			},
			dataUrl : config.dataUrl
		})
	});
};
Ext.extend(Weaver.TreeAdd, Ext.tree.TreePanel, {
	onTreeClick : function(node, e) {
		if (!node.isLeaf()) {
			if (node.isExpanded())
				node.collapse();
			else
				node.expand();
		}
	}
});
Ext.reg('TreeAdd', Weaver.TreeAdd);
