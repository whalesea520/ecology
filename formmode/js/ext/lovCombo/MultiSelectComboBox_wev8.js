	this.getMultiSelectComboBox = function(title, url, width, name, editable,
			blank, handler) {
				
		title2 = stringFilter['filterBlank'](blank, title);
		var store = new Ext.data.JsonStore({
					url : url,
					fields : ['label', 'value', 'selected']
				});
		store.load();
		Ext.namespace("Ext.ux.form");
		store.on('load', function(ds, records, o) {
			 var isFirst = true;
             var selectedItems = "";
			for (i = 0; i < records.length; i++) {
				if (records[i].data.selected == 'y') {
					if(isFirst){
					selectedItems = selectedItems+records[i].data.value;
					isFirst =false;
					}else{
						selectedItems=selectedItems+","+records[i].data.value;
					}
				}
			}
			multiSelectComboBox.setValue(selectedItems);
		});
		var multiSelectComboBox = new Ext.ux.form.LovCombo({
					//id : 'lovcombo',
					name : name,
					hiddenName : name,
					fieldLabel : title2,
					width : width,
					listWidth : width,
					hideOnSelect : false,
					maxHeight : 200,
					readOnly : true,
					editable : false,
					store : store,
					displayField : 'label',
					valueField : 'value',
					typeAhead : true,
					allowBlank : blank,
					triggerAction : 'all',
					emptyText : "-=请选择=-",
					mode : 'local'
				});
		return multiSelectComboBox;
	};