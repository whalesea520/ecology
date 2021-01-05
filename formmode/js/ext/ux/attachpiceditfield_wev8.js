Ext.namespace("Ext.ux.form");
var triggerObj;
Ext.ux.form.AttachpicEditField=Ext.extend(Ext.form.TriggerField,{
	defaultAutoCreate:{
		tag:"input",type:"text",size:"16",style:"cursor:default;",autocomplete:"off"
	}
	,triggerClass:"x-form-editor-trigger",validateOnBlur:false,multiSelect:false,showOnFocus:false,sFeatures : "dialogHeight:500px;dialogWidth:800px;status:no;center:yes;resizable:yes",url:"blank",initComponent:function(){
		Ext.ux.form.AttachpicEditField.superclass.initComponent.call(this);
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
		Ext.ux.form.AttachpicEditField.superclass.onRender.call(this,b,a);
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
			ID: "AttachPicDialog_" + theRowIndex,
	        Width: 300,
	        Height: 100,
	        Modal: true
	    });
	    diag.CancelEvent = function () {
	    	var _v1 = document.getElementById("strlength_" + theRowIndex).value;
    		var _v2 = document.getElementById("imgwidth_" + theRowIndex).value;
    		var _v3 = document.getElementById("imgheight_" + theRowIndex).value;
    		var _v = _v1 + ";" + _v2 + ";" + _v3;
	    	theStoreRecord.set('fieldattr', _v);
	    	
	        diag.close();
	    };
	    diag.Title = SystemEnv.getHtmlNoteName(3553,readCookie("languageidweaver"));
	    diag.InnerHtml = "<DIV style='text-align: left;padding:8px 8px 8px 18px;color: #929393;'>"
	    	+"<div style='padding-bottom:5px;'><span style='display:inline-block;width:98px;text-align:right;'>"+SystemEnv.getHtmlNoteName(3554,readCookie("languageidweaver"))+"</span><INPUT onblur=\"checkPlusnumber1(this)\" class=\"inputstyle\" onkeypress=\"ItemPlusCount_KeyPress()\" maxLength=\"3\" size=\"27\" id=\"strlength_"+theRowIndex+"\"></div>"
	    	+"<div style='padding-bottom:5px;'><span style='display:inline-block;width:98px;text-align:right;'>"+SystemEnv.getHtmlNoteName(3555,readCookie("languageidweaver"))+"</span><INPUT onblur=\"checkPlusnumber1(this)\" class=\"inputstyle\" onkeypress=\"ItemPlusCount_KeyPress()\" maxLength=\"4\" size=\"27\" id=\"imgwidth_"+theRowIndex+"\"></div>"
	    	+"<div style='padding-bottom:5px;'><span style='display:inline-block;width:98px;text-align:right;'>"+SystemEnv.getHtmlNoteName(3555,readCookie("languageidweaver"))+"</span><INPUT onblur=\"checkPlusnumber1(this)\" class=\"inputstyle\" onkeypress=\"ItemPlusCount_KeyPress()\" maxLength=\"4\" size=\"27\" id=\"imgheight_"+theRowIndex+"\"></div>"
	    	+"</DIV>";
	    diag.show();
	    var dialogDiv = diag.getDialogDiv();
	    dialogDiv.style.zIndex = 99999;
	    
	    var vfieldattr = theStoreRecord.get('fieldattr');
	    var vArr = vfieldattr.split(";");
    	var v1 = vArr.length > 0 ? vArr[0] : "";
    	var v2 = vArr.length > 1 ? vArr[1] : "";
    	var v3 = vArr.length > 2 ? vArr[2] : "";
    	
    	document.getElementById("strlength_" + theRowIndex).value = v1;
    	document.getElementById("imgwidth_" + theRowIndex).value = v2;
    	document.getElementById("imgheight_" + theRowIndex).value = v3;
	    
	    setTimeout(function(){
	    	document.getElementById("strlength_" + theRowIndex).focus();
	    }, 500);
		return;    
	}
});
Ext.reg("xattachpiceditfield",Ext.ux.form.AttachpicEditField);