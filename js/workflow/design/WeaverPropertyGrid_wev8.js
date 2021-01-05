var openwin;
WeaverPropertyColumnModel = function(grid,store){
	this.grid = grid;
    var g = Ext.grid;
    var url;
    WeaverPropertyColumnModel.superclass.constructor.call(this, [
        {header: this.nameText, width:50, sortable: false, dataIndex:'name', id: 'name', menuDisabled:true},
        {header: this.valueText, width:50, resizable:false, dataIndex: 'value', id: 'value', menuDisabled:true}
    ]);
    this.store = store;
    this.bselect = Ext.DomHelper.append(document.body, {
        tag: 'select', cls: 'x-grid-editor x-hide-display', children: [
            {tag: 'option', value: 'true', html: wmsg.wfdesign.yes},
            {tag: 'option', value: 'false', html: wmsg.wfdesign.no}
        ]
    });
    var f = Ext.form;
    
    var bfield = new f.Field({
    		
        el:this.bselect,
        bselect : this.bselect,
        autoShow: true,
        getValue : function(){
            return this.bselect.value == 'true';
        }
    });
    this.editors = {
        'date' : new g.GridEditor(new f.DateField({selectOnFocus:true})),
        'string' : new g.GridEditor(new f.TextField({selectOnFocus:true})),
        'number' : new g.GridEditor(new f.NumberField({selectOnFocus:true, style:'text-align:left;'})),
        //'boolean' : new g.GridEditor(new f.Checkbox({selectOnFocus:true})),
        'boolean' : new g.GridEditor(bfield),
        'button' : new Ext.grid.GridEditor(new f.TextField({
            listeners:{'focus':openExtWin}
        }))

    };
    this.renderCellDelegate = this.renderCell.createDelegate(this);
    this.renderPropDelegate = this.renderProp.createDelegate(this);
    
}

//属性页弹出窗体
function openExtWin(){
	var iframe = document.createElement('iframe');
	var randname = new Date().getTime();
	iframe.id = "iframe_"+randname;
	iframe.name = "iframe_"+randname;
	iframe.src=WeaverPropertyColumnModel.url;
	iframe.style.width= '100%';
	iframe.style.height= '100%';
	var win = new Ext.Window({
        layout: 'fit',
        width: 800,
        resizable: true,
        maximizable :true,
        height:  600,
        modal: true,
        contentEl:iframe,
        autoScroll: true,
        listeners:{
        	'close':function(){
				//关闭事件
				try{//调用页面的关闭事件，用于节点前、后、出口附加页面
					eval("iframe_"+randname+".window.designOnClose();");
				}catch(e){}
        	}
        }
    });
    win.show();
    openwin = win;
}

Ext.extend(WeaverPropertyColumnModel, Ext.grid.ColumnModel, {
    // private - strings used for locale support
    nameText : wmsg.wfdesign.name,
    valueText : wmsg.wfdesign.value,
    dateFormat : 'm/j/Y',

    // private
    renderDate : function(dateVal){
        return dateVal.dateFormat(this.dateFormat);
    },

    renderButton : function(buttonVal){
    	
    	return buttonVal.text;
    },
    renderComboBox : function(comboBoxVal){
    	return comboBoxVal.text;
    },
    
    // private
    renderBool : function(bVal){
        return bVal ? wmsg.wfdesign.yes : wmsg.wfdesign.no;
    },

    // private
    isCellEditable : function(colIndex, rowIndex){
        return colIndex == 1;
    },

    // private
    getRenderer : function(col){
        return col == 1 ?
            this.renderCellDelegate : this.renderPropDelegate;
    },

    // private
    renderProp : function(v){
        return this.getPropertyName(v);
    },

    // private
    renderCell : function(val,metaData, record, rowIndex, colIndex, store){
        var rv = val;
        if(Ext.isDate(val)){
            rv = this.renderDate(val);
        }else if(val.type=='button'){
	if(val.hasCon == "true") {
        		metaData_wev8.css = 'propertyWin_ggy';
        	}else {
        		metaData_wev8.css = 'propertyWin';
        	}
        	rv = this.renderButton(val)
        }else if(val.type =='combobox'){
        	rv = this.renderComboBox(val);
        }else if(typeof val == 'boolean'){
            rv = this.renderBool(val);
        }
        return Ext.util.Format.htmlEncode(rv);
    },

    // private
    getPropertyName : function(name){
        var pn = this.grid.propertyNames;
        return pn && pn[name] ? pn[name] : name;
    },

    // private
    getCellEditor : function(colIndex, rowIndex){
        var p = this.store.getProperty(rowIndex);
        var n = p.data['name'], val = p.data['value'];
        //alert(typeof(val));
        if(typeof(val)=="object"){
        	WeaverPropertyColumnModel.url = val.url;
        	p.data['value'] = val.text
        }
      
        if(this.grid.customEditors[n]){
            return this.grid.customEditors[n];
        }
        
        if(Ext.isDate(val)){
            return this.editors['date'];           
        }else if(val.type=='button'){
        	WeaverPropertyColumnModel.url = val.url;
        	val.toString = function(){
        		return val.text;
        	}
        	return this.editors['button']
        }else if(val.type=='combobox'){        
        	WeaverPropertyColumnModel.url =val.url;
        	val.toString = function(){
        		if(val.text==''){
        			return '...'
        		}else{
        			return val.text;
        		}
        	}
        	return this.editors['combobox']
        }else if(typeof val == 'number'){
            return this.editors['number'];
        }else if(typeof val == 'boolean'){
            return this.editors['boolean'];
        }else{
            return this.editors['string'];
        }
    }
});

WeaverPropertyStore = function(grid, source){
    this.grid = grid;
    this.store = new Ext.data.Store({
        recordType : Ext.grid.PropertyRecord
    });
    this.store.on('update', this.onUpdate,  this);
    if(source){
        this.setSource(source);
    }
    WeaverPropertyStore.superclass.constructor.call(this);
};
Ext.extend(WeaverPropertyStore, Ext.util.Observable, {
    // protected - should only be called by the grid.  Use grid.setSource instead.
    setSource : function(o){
        this.source = o;
        this.store.removeAll();
        var data = [];
        for(var k in o){
            if(this.isEditableValue(o[k])){
                data.push(new Ext.grid.PropertyRecord({name: k, value: o[k]}, k));
            }
        }
        this.store.loadRecords({records: data}, {}, true);
    },

    // private
    onUpdate : function(ds, record, type){
        if(type == Ext.data.Record.EDIT){
        	
			if(record.data['name']==wmsg.wfdesign.mustPass){
            	 record.data['value'] = passText;
            }
            var v = record.data['value'];
            var oldValue = record.modified['value'];
            if(this.grid.fireEvent('beforepropertychange', this.source, record.id, v, oldValue) !== false){
                this.source[record.id] = v;
                record.commit();
                this.grid.fireEvent('propertychange', this.source, record.id, v, oldValue);
            }else{
                record.reject();
            }
        }
    },

    // private
    getProperty : function(row){
       return this.store.getAt(row);
    },

    // private
    isEditableValue: function(val){
        if(Ext.isDate(val)){
            return true;
        }else if(val.type=='button'){
        	return true;
        }else if(val.type=='combobox'){
        	return true
        }else if(typeof val == 'object' || typeof val == 'function'){
            return false;
        }
        return true;
    },

    // private
    setValue : function(prop, value){
        this.source[prop] = value;
        this.store.getById(prop).set('value', value);
    },

    // protected - should only be called by the grid.  Use grid.getSource instead.
    getSource : function(){
        return this.source;
    }
});

//获取操作组列表
var operator_url = new Array();
var op_url = '/workflow/design/ds.jsp?design=1';
var operator_store = new Ext.data.Store({
	url: op_url,
	reader: new Ext.data.JsonReader({
		root:'options'
	},['name','type'])
});

//获取目标节点列表
var purposeNode_url = new Array();
var purpose_url = '/workflow/design/purposenode.jsp';
var purposeNode_store = new Ext.data.Store({
	url:purpose_url,
	reader: new Ext.data.JsonReader({
		root:'options'
	},['name','type'])
});

//获取指定出口列表

var mustPassStep_store = new Ext.data.Store({
	url:'/workflow/design/mustpassstep.jsp',
	reader: new Ext.data.JsonReader({
		root:'options'
	},['name','type','node'])
});

//打开操作组编辑窗口
var nodeoperator_url = '';
function changeGroup(type) {
	FL = operator_url[0];
	ID = operator_url[1];
	if(type=='')
		nodeoperator_url = '/workflow/workflow/addoperatorgroup.jsp?design=1&ajax=1';
	else
		nodeoperator_url = '/workflow/workflow/editoperatorgroup.jsp?design=1&ajax=1';
	nodeoperator_url += '&wfid='+FL.ID+'&nodeid='+ID+'&formid='+FL.FormID+'&isbill='+FL.IsBill+'&iscust='+FL.IsCust+'&id='+type;
	WeaverPropertyColumnModel.url = nodeoperator_url;
	openExtWin();
}
/*
Ext.namespace("Ext.ux");
Ext.ux.comboBoxRenderer = function(combo) {
  return function(value) {
    var idx = combo.store.find(combo.valueField, value);
    var rec = combo.store.getAt(idx);
    return rec.get(combo.displayField);
  };
}	*/
var passText;
var passComboBox = new Ext.ux.form.LovCombo({
				id:'mustPassStepSelect',
				triggerAction:'all',
				store: mustPassStep_store,
				displayField:'name',
				forceSelection:true,
				valueField:'type',
				mode:'local',
				//renderer:isRender,
				editable: false,
				listeners:{
					collapse: function(combo){
						var record = combo.store.getRange(); 
						setMustPassStep(combo.getCheckedValue('type'),record[0].get('node'));passText = combo.getCheckedValue('name');
					},
					expand: function(combo){
						var propertyGrid = Ext.getCmp("WeaverPropertyGrid");var source = propertyGrid.getSource();combo.setValue(WeaverPropertyColumnModel.url);
					}
				}
			});
		
function changePurposeNode(type){
	var stepID = purposeNode_url[1];

	var flow = Ext.get('mycanavs').dom.contentWindow._FLOW;
	var step =  flow.getStepByID(stepID+"T");
	var success = step.branchValidate(step.FromProc,type+"P")
	if(success){
		step.ToProc = type+"P";
		step.reGetPath();
		Ext.get('mycanavs').dom.contentWindow.document.all(stepID+"T").outerHTML = step.toString();
	}else{
		showMessage(wmsg.wfdesign.error,wmsg.wfdesign.noInSameBranch);
	}
	
}

function changePassType(type){
	
	var w = Ext.get('mycanavs').dom.contentWindow
	if(type==3){
		if(w._FLOW.getProcByID(w._FOCUSTEDOBJ.id).mustPassStep!=""){
			var _tmpAryId = w._FLOW.getProcByID(w._FOCUSTEDOBJ.id).mustPassStep.split(',');
			for(var i=0;i<_tmpAryId.length;i++){
				w._FLOW.getStepByID(_tmpAryId[i]+"T").isMustPass = 0;
			}
			w._FLOW.getProcByID(w._FOCUSTEDOBJ.id).mustPassStep = "";
		}
	}else if(type == 4){
		w._FLOW.getProcByID(w._FOCUSTEDOBJ.id).PassNum = 0;
	}
	w._FLOW.getProcByID(w._FOCUSTEDOBJ.id).passtype = type;
	w.stuffProp();
}

function setMustPassStep(type,node){
	WeaverPropertyColumnModel.url = type;
	var w = Ext.get('mycanavs').dom.contentWindow
	var joinNode = w._FLOW.getProcByID(node+"P");
	
	if(joinNode.mustPassStep!=""){
		var _tmpAryId = joinNode.mustPassStep.split(',');
		for(var i=0;i<_tmpAryId.length;i++){
			
			w._FLOW.getStepByID(_tmpAryId[i]+"T").isMustPass = 0;
		}
	}
	if(type != ""){
		var aryId = type.split(','); 
		for(var i=0;i<aryId.length;i++){
			w._FLOW.getStepByID(aryId[i]+"T").isMustPass = 1;
		}
		joinNode.mustPassStep = type;
	}
	
}

/**
 * 对于分叉起始点，应该可以为创建节点
 * 而分叉合并节点，应该可以为归档节点
 * @param {} combo
 */
function checkType(combo){
	
	var w = Ext.get('mycanavs').dom.contentWindow
	var proc = w._FLOW.getProcByID(w._FOCUSTEDOBJ.id);
	var myData;
	if(proc.ProcType=="fork"){
		myData = [
					[wmsg.wfdesign.create, wmsg.wfdesign.create],
	    			[wmsg.wfdesign.realize,wmsg.wfdesign.realize],
	    			[wmsg.wfdesign.approve, wmsg.wfdesign.approve]
    			 ];
		

	}else if(proc.ProcType=="join"){
		myData = [
	    			[wmsg.wfdesign.realize,wmsg.wfdesign.realize],
	    			[wmsg.wfdesign.approve, wmsg.wfdesign.approve],
	    			[wmsg.wfdesign.process,wmsg.wfdesign.process]
    			 ];
	}else{
		myData = [
	    			[wmsg.wfdesign.realize,wmsg.wfdesign.realize],
	    			[wmsg.wfdesign.approve, wmsg.wfdesign.approve]
    			 ];
	}
	combo.store.loadData(myData);
}

WeaverPropertyGrid = Ext.extend(Ext.grid.EditorGridPanel, {
	/**
    * @cfg {Object} source A data object to use as the data source of the grid (see {@link #setSource} for details).
    */
    /**
    * @cfg {Object} customEditors An object containing name/value pairs of custom editor type definitions that allow
    * the grid to support additional types of editable fields.  By default, the grid supports strongly-typed editing
    * of strings, dates, numbers and booleans using built-in form editors, but any custom type can be supported and
    * associated with a custom input control by specifying a custom editor.  The name of the editor
    * type should correspond with the name of the property that will use the editor.  Example usage:
    * <pre><code>
var grid = new Ext.grid.PropertyGrid({
    ...
    customEditors: {
        'Start Time': new Ext.grid.GridEditor(new Ext.form.TimeField({selectOnFocus:true}))
    },
    source: {
        'Start Time': '10:00 AM'
    }
});
</code></pre>
    */

    // private config overrides
	id:'WeaverPropertyGrid',
    enableColumnMove:true,
    stripeRows: true, 
    trackMouseOver: false,
    clicksToEdit:1,
    enableHdMenu : false,
    viewConfig : {
        forceFit:true
    },
	
    // private
    initComponent : function(){
    	var editorStr = 'this.customEditors = this.customEditors || '+
    		'{\''+wmsg.wfdesign.type+'\':new Ext.grid.GridEditor(new Ext.form.ComboBox({' +
    			' triggerAction: \'all\','+
    			' store: new Ext.data.SimpleStore({'+
    			' fields: [\'type\', \'name\'],'+
    			'data : ['+
    			' [\''+wmsg.wfdesign.create+'\',\''+ wmsg.wfdesign.create+'\'],'+
    			' [\''+wmsg.wfdesign.realize+'\',\''+ wmsg.wfdesign.realize+'\'],'+
    			' [\''+wmsg.wfdesign.approve+'\',\''+ wmsg.wfdesign.approve+'\'],'+
    			' [\''+wmsg.wfdesign.process+'\',\''+ wmsg.wfdesign.process+'\']'+
    			']'+
    			' }),'+
    			' displayField:\'name\','+
    			' forceSelection:true,'+
    			' valueField:\'type\','+
    			'mode:\'local\','+
				'editable: false,'+
				'listeners:{'+
				'\'select\': function(combo,record,index){'+
				'changeProcType(record.get(\'type\'));'+
				'},'+
				'expand :function(combo){'+
				'checkType(combo)'+
				'}'+
				'}'+
    		'})),'+
	    	'\''+wmsg.wfdesign.oerator+'\':new Ext.grid.GridEditor(new Ext.form.ComboBox({' +
				' id:\'operatorSelect\',triggerAction: \'all\','+
				' store: operator_store,'+
				' displayField:\'name\','+
				' forceSelection:true,'+
				' valueField:\'name\','+
				'mode:\'local\','+
				'editable: false,'+
				'listeners:{'+
				'\'select\': function(combo,record,index){'+
				'changeGroup(record.get(\'type\'));'+
				'}'+
				'}'+
			'})),'+
			'\''+wmsg.wfdesign.purposeNode+'\':new Ext.grid.GridEditor(new Ext.form.ComboBox({' +
				' id:\'purposeNodeSelect\',triggerAction: \'all\','+
				' store: purposeNode_store,'+
				' displayField:\'name\','+
				' forceSelection:true,'+
				' valueField:\'name\','+
				'mode:\'local\','+
				'editable: false,'+
				'listeners:{'+
				'\'select\': function(combo,record,index){'+
				'changePurposeNode(record.get(\'type\'));'+
				'}'+
				'}'+
			'})),'+
			'\''+wmsg.wfdesign.passType+'\':new Ext.grid.GridEditor(new Ext.form.ComboBox({' +
				' id:\'passTypeSelect\',triggerAction: \'all\','+
				' store: new Ext.data.SimpleStore({'+
    			' fields: [\'type\', \'name\'],'+
    			'data : ['+
    			' [3,\''+ wmsg.wfdesign.passByMum+'\'],'+
    			' [4,\''+ wmsg.wfdesign.mustPass+'\']'+
    			']'+
    			' }),'+
				' displayField:\'name\','+
				' forceSelection:true,'+
				' valueField:\'name\','+
				'mode:\'local\','+
				'editable: false,'+
				'listeners:{'+
				'\'select\': function(combo,record,index){'+
				'changePassType(record.get(\'type\'));'+
				'}'+
				'}'+
			'})),'+
			'\''+wmsg.wfdesign.mustPass+'\':new Ext.grid.GridEditor(passComboBox)'+
    		'} ';
    		
		eval(editorStr);

        this.lastEditRow = null;
        var store = new WeaverPropertyStore(this);
        this.propStore = store;
        var cm = new WeaverPropertyColumnModel(this, store);
        this.addEvents(
            /**
             * @event beforepropertychange
             * Fires before a property value changes.  Handlers can return false to cancel the property change
             * (this will internally call {@link Ext.data.Record#reject} on the property's record).
             * @param {Object} source The source data object for the grid (corresponds to the same object passed in
             * as the {@link #source} config property).
             * @param {String} recordId The record's id in the data store
             * @param {Mixed} value The current edited property value
             * @param {Mixed} oldValue The original property value prior to editing
             */
            'beforepropertychange',
            /**
             * @event propertychange
             * Fires after a property value has changed.
             * @param {Object} source The source data object for the grid (corresponds to the same object passed in
             * as the {@link #source} config property).
             * @param {String} recordId The record's id in the data store
             * @param {Mixed} value The current edited property value
             * @param {Mixed} oldValue The original property value prior to editing
             */
            'propertychange'
        );
        this.cm = cm;
        this.ds = store.store;
        this.getView().scrollOffset=1;
        Ext.grid.PropertyGrid.superclass.initComponent.call(this);

        this.selModel.on('beforecellselect', function(sm, rowIndex, colIndex){
        	//加载操作者数据
        	if(wmsg.wfdesign.oerator==store.store.getAt(rowIndex).get('name')) {
        		var arr = operator_url[0];
        		operator_store.reload({
					params : {
						wfid: arr.ID,
						formid: arr.FormID,
						nodeid: operator_url[1],
						isbill: arr.IsBill,
						iscust: arr.IsCust
					}
				});
        	}else if(wmsg.wfdesign.purposeNode == store.store.getAt(rowIndex).get('name')){
    			var arr = purposeNode_url[0];  
    			purposeNode_store.reload({
					params : {
						wfid: arr.ID,
						linkid : purposeNode_url[1]
					}
				});
        	}else if(wmsg.wfdesign.mustPass == store.store.getAt(rowIndex).get('name')){
        		var arr = operator_url[0];  
    			mustPassStep_store.reload({
					params : {
						wfid: arr.ID,
						nodeid : operator_url[1]
					}
				});
				//var combo = Ext.getCmp("mustPassStepSelect");
        		//combo.setValue(combo.value);
        	}
            if(colIndex === 0){
                this.startEditing.defer(200, this, [rowIndex, 1]);
                return false;
            }
        }, this);
    },

    // private
    onRender : function(){
        WeaverPropertyGrid.superclass.onRender.apply(this, arguments);

        this.getGridEl().addClass('x-props-grid');
    },

    // private
    afterRender: function(){
        Ext.grid.PropertyGrid.superclass.afterRender.apply(this, arguments);
        if(this.source){
            this.setSource(this.source);
        }
    },

    /**
     * Sets the source data object containing the property data.  The data object can contain one or more name/value
     * pairs representing all of the properties of an object to display in the grid, and this data will automatically
     * be loaded into the grid's {@link #store}.  The values should be supplied in the proper data type if needed,
     * otherwise string type will be assumed.  If the grid already contains data, this method will replace any
     * existing data.  See also the {@link #source} config value.  Example usage:
     * <pre><code>
grid.setSource({
    "(name)": "My Object",
    "Created": new Date(Date.parse('10/15/2006')),  // date type
    "Available": false,  // boolean type
    "Version": .01,      // decimal type
    "Description": "A test object"
});
</code></pre>
     * @param {Object} source The data object
     */
    setSource : function(source){
        this.propStore.setSource(source);
    },

    /**
     * Gets the source data object containing the property data.  See {@link #setSource} for details regarding the
     * format of the data object.
     * @return {Object} The data object
     */
    getSource : function(){
        return this.propStore.getSource();
    }
	
});