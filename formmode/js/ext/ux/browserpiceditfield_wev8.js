Ext.namespace("Ext.ux.form");
var triggerObj;
Ext.ux.form.BrowserpicEditField=Ext.extend(Ext.form.TriggerField,{
	defaultAutoCreate:{
		tag:"input",type:"text",size:"16",style:"cursor:default;",autocomplete:"off"
	}
	,triggerClass:"x-form-editor-trigger",validateOnBlur:false,multiSelect:false,showOnFocus:false,sFeatures : "dialogHeight:500px;dialogWidth:800px;status:no;center:yes;resizable:yes",url:"blank",initComponent:function(){
		Ext.ux.form.BrowserpicEditField.superclass.initComponent.call(this);
		if(this.store){
			if(!this.valueField){
				this.valueField="value"
			}
			if(!this.displayField){
				this.displayField="text"
			}
		}
	}
	,onRender:function(b,a){
		if(this.isRendered){
			return
		}
		this.readOnly=true;
		if(this.textarea){
			this.defaultAutoCreate={
				tag:"textarea",style:"cursor:default;width:124px;height:65px;",autocomplete:"off"
			};
			this.displaySeparator="\n"
		}
		Ext.ux.form.BrowserpicEditField.superclass.onRender.call(this,b,a);
		if(this.hiddenName){
			this.hiddenField=this.el.insertSibling({
				tag:"input",type:"hidden",name:this.hiddenName,id:(this.hiddenId||this.hiddenName)
			}
			,"before",true);
			this.hiddenField.value=this.hiddenValue!==undefined?this.hiddenValue:this.value!==undefined?this.value:"";
			this.el.dom.removeAttribute("name")
		}
		this.el.dom.removeAttribute("name");
		if(this.showOnFocus){
			this.on("focus",this.onTriggerClick,this)
		}
		this.isRendered=true
	}
	,onSelect:function(f){
		if(f){
			Ext.form.ComboBox.superclass.setValue.call(this,f[1]);
			this.value=f[0];
			if(this.hiddenField){
				this.hiddenField.setAttribute("value",f[0])
			}
		}
		if(Ext.QuickTips){
			Ext.QuickTips.enable()
		}
	}
	,getValue:function(){
		return Ext.form.ComboBox.superclass.getValue.call(this);
	}
	,setValue:function(a){
		var c=a;
		this.lastSelectionText=c;
		if(this.hiddenField){
			this.hiddenField.value=a
		}
		Ext.form.ComboBox.superclass.setValue.call(this,c);
		this.value=a
	}
	,findRecord:function(c,b){
		var a;
		if(this.store.getCount()>0){
			this.store.each(function(d){
				if(d.data[c]==b){
					a=d;
					return false
				}
			})
		}
		return a
	}
	,onTriggerClick:function(a){
		triggerObj = Ext.getCmp(this.id);
		
		var theEditGrid = this.editgrid;
		theEditGrid.stopEditing();
		
		var theRowIndex = this.rowIndex;
		
		var theStoreRecord = this.storeRecord;
		
		var diag = new Dialog({
			ID: "BrowserTypeDialog_" + theRowIndex,
	        Width: 546,
	        Height: 400,
	        Modal: true
	    });
	    diag.CancelEvent = function () {
	    	// theStoreRecord.set('fieldtype', "");
	        diag.close();
	    };
	    diag.Title = "选择框";
	    diag.InnerHtml = "<div class='autoSelect' id='browsertype_autoSelect' style='border: red solid 0px;width:100%;height:100%'></div>";
	    diag.show();
	    var dialogDiv = diag.getDialogDiv();
	    dialogDiv.style.zIndex = 99999;
	    var vfieldattr = theStoreRecord.get('fieldtype');
    	BTCOpen(theRowIndex,diag,theStoreRecord);
		return;    
	}
});
Ext.reg("xbrowserpiceditfield",Ext.ux.form.BrowserpicEditField);