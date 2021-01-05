Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
Ext.namespace('Weaver');
Weaver.WeaverTableExt = function(config,tbar) {
	//alert(tbar)
	var store = new Ext.data.Store({
		baseParams : {
			TableBaseParas : Ext.util.JSON.encode(config.TableBaseParas)
		},
		// load using script tags for cross domain, if the data in on the same
		// domain as
		// this page, an HttpProxy would be better
		proxy : new Ext.data.HttpProxy({
			method : 'POST',
			// url: '/js/extjs/zdp/GridData.jsp'
			url : '/weaver/weaver.common.util.taglib.SplitPageXmlServletNew'
		}),

		// create reader that reads the Topic records
		reader : new Ext.data.JsonReader({
			root : 'data',
			totalProperty : 'totalCount',
			id : 'id',
			fields : getColumnFields(config)
		}),
		// turn on remote sorting
		remoteSort : true
	});
	// alert(config.TableBaseParas.sort)
	store.setDefaultSort(config.TableBaseParas.sort, config.TableBaseParas.dir);
	store.on('load', function () {
		try{window.WeaverTableExtFna_onload(grid, store);}catch(ex1){}
	}); 
	// the column model has information about grid columns
	// dataIndex maps the column to the specific data field in
	// the data store

	var bbar = new Ext.PagingToolbar({
		pageSize : config.TableBaseParas.pageSize,
		store : store,
		displayInfo : true,
		displayMsg : wmsg.grid.gridDisp1 + '{0} - {1}' + wmsg.grid.gridDisp2
				+ '{2}' + wmsg.grid.gridDisp3,
		emptyMsg : wmsg.grid.noItem
			/*
			 * ,items:[ '-', { pressed: true, enableToggle:true, text:
			 * wmsg.grid.preview, iconCls: 'btn_details', toggleHandler:
			 * toggleDetails } ]
			 */
	});

	var columns = config.TableBaseParas.columns;

	var sm = new Ext.grid.RowSelectionModel({handleMouseDown: Ext.emptyFn});
	// 需要Checkbox
	if (config.gridType == "checkbox") {
		//sm = new Ext.grid.CheckboxSelectionModel({handleMouseDown: Ext.emptyFn});
		var sm = new Ext.grid.CheckboxSelectionModel({
			handleMouseDown: function(g, rowIndex, e) {
				if (e.button !== 0 || this.isLocked()) {
					return;
				}
				var view = this.grid.getView();
				if (e.shiftKey && !this.singleSelect && this.last !== false) {
					var last = this.last;
					this.selectRange(last, rowIndex, e.ctrlKey);
					this.last = last;
					view.focusRow(rowIndex);
				} else {
					var target=$.event.fix(e).target;
					if($(target).hasClass("x-grid3-row-checker")){
						var isSelected = this.isSelected(rowIndex);
						if (isSelected) {
							this.deselectRow(rowIndex);
						} else if (!isSelected || this.getCount() > 1) {
							this.selectRow(rowIndex, true);
							view.focusRow(rowIndex);
						}
						
					}
					
				}
			},
			isLocked: Ext.emptyFn,
			initEvents: function() {
				Ext.grid.CheckboxSelectionModel.superclass.initEvents.call(this);
				this.grid.on('render',
				function() {
					var view = this.grid.getView();
					view.mainBody.on('mousedown', this.onMouseDown, this);
					Ext.fly(view.lockedInnerHd).on('mousedown', this.onHdMouseDown, this);
				},
				this);
			}
		});
		columns = [sm].concat(columns);
	}
	sm.lock();

	// 如果需要行号
	if (config.isNeedRowNumber == true) {
		columns = [new Ext.grid.RowNumberer()].concat(columns);
	}
	// by default columns are sortable

	// 如果需要操作权限
	// if(config.TableBaseParas.operates!=null){
	// columns=columns.concat([{id:'operates', header: "操作1", width: 0.3,
	// sortable: false, dataIndex: 'operates', column:'operates',hidden:
	// false}]);
	// }
	var gridHeight = config.TableBaseParas.pageSize * config.columnWidth + 60;
	var cm = new Ext.ux.grid.LockingColumnModel(columns);
	cm.defaultSortable = true;
	// alert(config.TableBaseParas.pageSize*35)
	Ext.override(Ext.grid.GridView, {
		templates : {
			cell : new Ext.Template(
					'<td class="x-grid3-col x-grid3-cell x-grid3-td-{id} {css}" style="{style}" tabIndex="0" {cellAttr}>',
					'<div class="x-grid3-cell-inner x-grid3-col-{id}" {attr}>{value}</div>',
					"</td>")
		}
	});
	var grid;
	if(tbar=="[]"||tbar==""){
		grid = new Ext.grid.LockingGridPanel({
			id : config.tableId,
			el : config.el,
			syncHeights : true,
			width : document.getElementById(config.el_temp).offsetWidth,
			height : gridHeight,
			title : config.title,
			store : store,
			cm : cm,
			trackMouseOver : true,
			autoSizeColumns : true,
			sm : sm,
			stripeRows : true,
			loadMask : true,
			//plugins:[new Ext.ux.plugins.LockedGroupHeaderGrid()],
			viewConfig : {
				forceFit : false,
				emptyText : wmsg.grid.noItem,
				onLoad : Ext.emptyFn,
				listeners : {
					beforerefresh : function(v) {
						v.scrollTop = v.scroller.dom.scrollTop;
						v.scrollHeight = v.scroller.dom.scrollHeight;
					},
					refresh : function(v) {
						v.scroller.dom.scrollTop = v.scrollTop
								+ (v.scrollTop == 0
										? 0
										: v.scroller.dom.scrollHeight
												- v.scrollHeight);
					}
				}
			},
			bbar : bbar
		});		
	} else { 
		gridHeight = gridHeight+20;
		grid = new Ext.grid.LockingGridPanel({
			id : config.tableId,
			el : config.el,
			syncHeights : true,
			width : document.getElementById(config.el_temp).offsetWidth,
			height : gridHeight,
			title : config.title,
			store : store,
			cm : cm,
			trackMouseOver : true,
			autoSizeColumns : true,
			sm : sm,
			stripeRows : true,
			loadMask : true,
			viewConfig : {
				forceFit : true,
				emptyText : wmsg.grid.noItem
			},
			tbar : eval(tbar),
			bbar : bbar
		});
	}
	
	
	

	// render it

	// grid.on('rowmousedown', function(grid, rowIndex, columnIndex, e) {

	// infoArea.value=infoArea.value+"rowmousedown cus\n";
	// });

	// grid.removeListener("rowclick", function(){});
	grid.render();
	store.load({
		params : {
			start : 0,
			limit : config.TableBaseParas.pageSize
		},
		callback:function(){
		}
	});
	
	// trigger the data store load
//	grid.removeListener("rowmousedown", sm.handleMouseDown, sm);
	document.getElementById(config.el_temp).style.height = gridHeight;
	// alert(gridHeight)
	// alert(document.getElementById(config.el_temp).style.height);
	return {
		init : function() {
			
		},	
		getGridWidth : function() {
			return grid.width;
		},
		setGridWidth : function(newWidth) {
			grid.setWidth(newWidth);
		},
		getGridHeight : function() {
			return grid.height;
		},
		setGridHeight : function(newHeight) {
			grid.setHeight(newHeight);
		},
		firstPage : function() {
			bbar.moveFirst();
		},
		prePage : function() {
			if(bbar.items.get(1).disabled==false){
				bbar.movePrevious();
			}
		},
		nextPage : function() {
			if(bbar.items.get(7).disabled==false){
				bbar.moveNext();
			}			
		},
		lastPage : function() {
			bbar.moveLast();
		},
		reLoad : function() {
			bbar.onClick("refresh");
		},
		refresh : function() {
			bbar.doLoad(bbar.cursor);
		},
		_xtable_CheckedCheckboxId : function() {
			var selections = sm.getSelections();
			var selectionIds = "";
			for (var i = 0; i < selections.length; i++) {
				//alert(selections[i].id); 
				selectionIds+=selections[i].id+",";
			}

			return selectionIds;
		}
	}

	function toggleDetails(btn, pressed) {
		var view = grid.getView();
		view.showPreview = pressed;
		view.refresh();
	}

	function getColumnFields(config) {
		var strFields = new Array();
		var tableColumns = config.TableBaseParas.columns;
		for (var i = 0; i < tableColumns.length; i++)
			strFields = strFields.concat(tableColumns[i].column);
		// alert(strFields.length)
		return strFields;
	}
}