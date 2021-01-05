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
		if(!Ext.isSafari){
			returnVal=window.showModalDialog(this.url,this.value,this.sFeatures);
			try{
				if(typeof(returnVal)=="undefined"){
					return
				}
				if(Object.prototype.toString.apply(returnVal)==="[object Array]"){
					this.onSelect(returnVal)
				}
				else{
					this.onSelect([returnVal,returnVal])
				}
			}
			catch(a){
				this.onSelect([returnVal,returnVal])
			}
		}else{
	var container = this.container;
    var callback = function() {
    
                returnVal = dialog.getFrameWindow().dialogValue;
               // var evt=getEvent();
				//var e=evt.srcElement || evt.target;
	            try{
					if(typeof(returnVal)=="undefined"){
						return
					}
					if(Object.prototype.toString.apply(returnVal)==="[object Array]"){
						triggerObj.onSelect(returnVal)
					}
					else{
						triggerObj.onSelect([returnVal,returnVal])
					}
				}
				catch(a){
					triggerObj.onSelect([returnVal,returnVal])
				}
        }
	    var winHeight = Ext.getBody().getHeight() * 0.9;
	    var winWidth = Ext.getBody().getWidth() * 0.9;
	    if(winHeight>500){//最大高度500
	    	winHeight = 500;
	    }
	    if(winWidth>880){//最大宽度800
	    	winWidth = 880;
	    }
        if (!win) {
             win = new Ext.Window({
                layout:'border',
                width:winWidth,
                height:winHeight,
                plain: true,
                modal:true,
                items: {
                    id:'dialog',
                    region:'center',
                    iconCls:'portalIcon',
                    xtype     :'iframepanel',
                    frameConfig: {
                        autoCreate:{ id:'portal', name:'portal', frameborder:0 },
                        eventsFollowFrameLinks : false
                    },
                    closable:false,
                    autoScroll:true
                }
            });
        }
        win.close=function(){
                    this.hide();
                    win.getComponent('dialog').setSrc('about:blank');
                    callback();
                } ;
        win.render(Ext.getBody());
        var dialog = win.getComponent('dialog');
        dialog.setSrc(this.url);
        win.show();
		}
	}
});
Ext.reg("xbrowserfield",Ext.ux.form.BrowserField);