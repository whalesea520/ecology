Ext.namespace("Ext.ux.form");
var triggerObj;
Ext.ux.form.SelectitemEditField=Ext.extend(Ext.form.TriggerField,{
	defaultAutoCreate:{
		tag:"input",type:"text",size:"16",style:"cursor:default;",autocomplete:"off"
	}
	,triggerClass:"x-form-editor-trigger",validateOnBlur:false,multiSelect:false,showOnFocus:false,sFeatures : "dialogHeight:500px;dialogWidth:800px;status:no;center:yes;resizable:yes",url:"blank",initComponent:function(){
		Ext.ux.form.SelectitemEditField.superclass.initComponent.call(this);
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
		Ext.ux.form.SelectitemEditField.superclass.onRender.call(this,b,a);
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
		
		if(jQuery("#SeleteItem_" + theFormtablename + "_" + theRowIndex).length == 0){
			var $obj = jQuery("<div id=\"SeleteItem_"+theFormtablename+"_"+theRowIndex+"\"></div>");
			
			var html = "<div id=\"div5_"+theRowIndex+"\" style=\"vertical-align: middle; height:30px; line-height: 30px;text-align: left;padding-left: 5px;\">"
				+ "<button type=\"button\" class=\"addbtn\" id=\"btnaddRow\" name=\"btnaddRow\" onclick=\"addoTableRow("+theRowIndex+")\" title=\"添加内容\" style=\"margin-bottom:-5px;\"></BUTTON>"
				+ "<button type=\"button\" class=\"delbtn\" id=\"btnsubmitClear\" name=\"btnsubmitClear\" onclick=\"submitClear("+theRowIndex+")\" title=\"删除内容\" style=\"margin-bottom:-5px;\"></BUTTON>"
				+ "<span>关联子字段&nbsp;</span>"
				+ "<button type=\"button\" id=\"showChildFieldBotton\" class=\"Browser\" onClick=\"onShowChildField('childfieldidSpan_"+theRowIndex+"','childfieldid_"+theRowIndex+"','_"+theRowIndex+"')\"></BUTTON>"
				+ "<span id=\"childfieldidSpan_"+theRowIndex+"\"></span>"
				+ "<input type=\"hidden\" value=\"\" name=\"childfieldid_"+theRowIndex+"\" id=\"childfieldid_"+theRowIndex+"\">"
				+ "</div>";
				
			html += "<div id=\"div5_5_"+theRowIndex+"\">"
					  	+ "<table class=\"liststyle\" id=\"choiceTable_"+theRowIndex+"\" cols=\"6\" border=\"0\" style=\"width: 100%;\" cellspacing=\"collapse\">"
							+ "<COL width=\"5%\">"
							+ "<COL width=\"25%\">"
							+ "<COL width=\"5%\">"
							+ "<COL width=\"10%\">"
							+ "<COL width=\"33%\">"
							+ "<COL width=\"22%\">"
					  		+ "<tr>"
					  			+ "<td>选中</td>"
					  			+ "<td style='text-align: left;padding-left:15px;'>可选项文字</td>"
					  			+ "<td>排序</td>"
					  			+ "<td>默认值</td>"
					  			+ "<td>关联文档目录</td>"
								+ "<td>子字段选项</td>"
							+ "</tr>"
							+ "<input type=\"hidden\" value=\"0\" name=\"choiceRows_"+theRowIndex+"\" id=\"choiceRows_"+theRowIndex+"\">"
						+ "</table>"
					+ "</div>";
					
			$obj.append(html);	
			
			jQuery("#SeleteItem_ALL").append($obj);		
		}
		
		var valueIsChange = false;
		function changeValueFlag(){
	    	valueIsChange = true;
	    }
	    
		var diag = new Dialog({
			ID: "SeleteItemDialog_" + theRowIndex,
	        Width: 550,
	        Height: 300,
	        Modal: true,
	        ShowButtonRow:true
	    });
	    diag.CancelEvent = function () {
	    	setSelectValue();
	    };
	    diag.OKEvent = function () {
	    	setSelectValue();
	    };

	    function setSelectValue(){
	    	var selitems = $("#choiceTable_"+theRowIndex).find(".selectitemname");
	    	for(var i=0;i<selitems.length;i++){
	    		var obj = selitems.get(i);
	    		if(obj.value==''){
	    			Dialog.alert("可选项文字不能为空");
	    			return;
	    		}
	    	}
	    	jQuery("#SeleteItem_ALL").append(jQuery("#SeleteItem_" + theFormtablename + "_"  + theRowIndex));
	        diag.close();
	        
	        /*
	        var selectitemDisplayText = new Date().toLocaleTimeString();
	        triggerObj.onSelect([selectitemDisplayText, selectitemDisplayText]);
	        */
	        
	        var selectitemDisplayText = "";
	        jQuery("tr:gt(0)", "#choiceTable_" + theRowIndex).each(function(){
	        	var sv = jQuery("td:eq(1) input[type='text']", jQuery(this)).val();
	        	if(sv != ""){
	        		selectitemDisplayText += sv + ",";
	        	}
	        });
	        if(selectitemDisplayText != ""){
	        	selectitemDisplayText = selectitemDisplayText.substring(0, selectitemDisplayText.length - 1);
	        }
	        if(valueIsChange){	//加个空格，强制让record的fieldtype处于被修改过的状态
	        	selectitemDisplayText += " ";
	        }
			theStoreRecord.set('fieldtype',selectitemDisplayText);
			
	        jQuery("input", jQuery("#SeleteItem_" + theFormtablename + "_"  + theRowIndex)).unbind("click", changeValueFlag);
	    	jQuery("button.Browser", jQuery("#SeleteItem_" + theFormtablename + "_"  + theRowIndex)).unbind("click", changeValueFlag);
	    }
	    
	    diag.Title = "编辑选择框";
	    diag.InnerHtml = "<div id='SeleteItemContainer_"+theRowIndex+"'></div>";
	   	//diag.InnerHtml = jQuery("#SeleteItem_45")[0].outerHTML;
	    diag.show();
	    jQuery("#SeleteItemContainer_" + theRowIndex).append(jQuery("#SeleteItem_" + theFormtablename + "_"  + theRowIndex));
	    var dialogDiv = diag.getDialogDiv();
	    dialogDiv.style.zIndex = 99999;
	    jQuery("#_Container_SeleteItemDialog_" + theRowIndex).css("overflow","auto");
	    
	    jQuery("input", jQuery("#SeleteItem_" + theFormtablename + "_"  + theRowIndex)).bind("click", changeValueFlag);
	    jQuery("button.Browser", jQuery("#SeleteItem_" + theFormtablename + "_"  + theRowIndex)).bind("click", changeValueFlag);
	    $("#_ButtonCancel_SeleteItemDialog_"+theRowIndex).hide();//hide cancel button
		return;    
	}
});
Ext.reg("xselectitemeditfield",Ext.ux.form.SelectitemEditField);