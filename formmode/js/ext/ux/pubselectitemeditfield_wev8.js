Ext.namespace("Ext.ux.form");
var triggerObj;
Ext.ux.form.PubSelectitemEditField=Ext.extend(Ext.form.TriggerField,{
	defaultAutoCreate:{
		tag:"input",type:"text",size:"16",style:"cursor:default;",autocomplete:"off"
	}
	,triggerClass:"x-form-editor-trigger",validateOnBlur:false,multiSelect:false,showOnFocus:false,sFeatures : "dialogHeight:500px;dialogWidth:800px;status:no;center:yes;resizable:yes",url:"blank",initComponent:function(){
		Ext.ux.form.PubSelectitemEditField.superclass.initComponent.call(this);
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
		Ext.ux.form.PubSelectitemEditField.superclass.onRender.call(this,b,a);
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
		
		var theFormtablename = this.formtablename;
		
		var fieldid = theStoreRecord.data.id;
		
		var url = "/systeminfo/BrowserMain.jsp?url=/formmode/setup/SelectItemFieldEdit.jsp?fieldid="+fieldid;
		
		
		var valueIsChange = false;
		function changeValueFlag(){
	    	valueIsChange = true;
	    }
		
		var dialogurl = url;
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.URL = dialogurl;
		dialog.callbackfun = function (paramobj, id1) {
			if (id1 != null) {
				var pubSelTab = jQuery("#pubSeleteItemTable");
				var oldTr = pubSelTab.find("#pubTR_"+fieldid);
				if(oldTr.length>0){
					oldTr.remove();
				}
				
				var selectType = id1.selectType;
				var linkfield = id1.linkfield;
				var selectitemDisplayText = "";
				if(selectType&&selectType>0){
					selectitemDisplayText = id1.selectTypeText;
				}else {
					if(linkfield&&linkfield>0){
						selectitemDisplayText = id1.linkfieldText;
					}
				}
				var newTr = "<tr id='pubTR_"+fieldid+"'><td>";
				newTr += "<input type='text' name='pubselect' value='"+fieldid+"' >";
				newTr += "<input type='text' name='pubselectType' value='"+id1.selectType+"' >";
				newTr += "<input type='text' name='publinkfield' value='"+id1.linkfield+"' >";
				newTr += "</td></tr>";
				pubSelTab.append(newTr);
				
				theStoreRecord.set('fieldtype',selectitemDisplayText);
			}
		}
		
		
		dialog.Title = "公共选择框";
		dialog.Width = 500 ;
		dialog.Height = 400;
		dialog.Drag = true;
		dialog.show();
		return;
	}
});
Ext.reg("xpubselectitemeditfield",Ext.ux.form.PubSelectitemEditField);