Ext.namespace("Ext.ux.form");
var win;
var triggerObj;
Ext.ux.form.BrowserField=Ext.extend(Ext.form.TriggerField,{
	defaultAutoCreate:{
		tag:"input",type:"text",size:"16",style:"cursor:default;",autocomplete:"off"
	}
	,triggerClass:"x-form-search-trigger",validateOnBlur:false,multiSelect:false,showOnFocus:false,sFeatures : "dialogHeight:500px;dialogWidth:800px;status:no;center:yes;resizable:yes",url:"blank",initComponent:function(){
		Ext.ux.form.BrowserField.superclass.initComponent.call(this);
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
		Ext.ux.form.BrowserField.superclass.onRender.call(this,b,a);
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
			if(this.store&&!this.store.getById(f[0])){
				var a=Ext.data.Record.create([{
					name:this.valueField
				}
				,{
					name:this.displayField
				}
				]);
				var e;
				if(f[1].indexOf("<a")>-1){
					var b=f[1].split("</a>");
					var d;
					for(var c=0;c<b.length;c++){
						if(c==0){
							d=b[c].substring(b[c].indexOf(">")+1,b[c].length)
						}
						else{
							d+=","+b[c].substring(b[c].indexOf(">")+1,b[c].length)
						}
					}
					e=Ext.decode("{'"+this.valueField+"':'"+f[0]+"','"+this.displayField+"':'"+d.substring(0,d.length-1)+"'}")
				}
				else{
					e=Ext.decode("{'"+this.valueField+"':'"+f[0]+"','"+this.displayField+"':'"+f[1]+"'}")
				}
				this.store.add([new a(e,f[0])])
			}
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
		if(this.valueField){
			return typeof this.value!="undefined"?this.value:""
		}
		else{
			return Ext.form.ComboBox.superclass.getValue.call(this)
		}
	}
	,setValue:function(a){
		var c=a;
		if(this.valueField){
			var b=this.findRecord(this.valueField,a);
			if(b){
				c=b.data[this.displayField]
			}
			else{
				if(this.valueNotFoundText!==undefined){
					c=this.valueNotFoundText
				}
			}
		}
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
		this.editgrid.stopEditing();
		var browserfieldDlg = top.createTopDialog();//定义Dialog对象
		browserfieldDlg.Model = true;
		browserfieldDlg.Width = 900;//定义长度
		browserfieldDlg.Height = 400;
		browserfieldDlg.URL = this.url;
		browserfieldDlg.Title = "选择自定义浏览框";
		browserfieldDlg.show();
		browserfieldDlg.callbackfun=this.callbackfun;
		browserfieldDlg.callbackfunParam=this.callbackfunParam;
	}
});
Ext.reg("xbrowserfield",Ext.ux.form.BrowserField);