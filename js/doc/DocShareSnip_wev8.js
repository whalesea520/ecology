//Ext.namespace('weaver.doc');
//weaver.doc.
DocShareSnip = function(docid,canShare) {
	var pageSize=15;
	
	Ext.Ajax.request({
        url: "/docs/docs/DocShareUtil.jsp?method=getCanShare" +
        "&docid=" +
        docid,
        success: function(objRequest, objOptions){
			var result = objRequest.responseText.trim();
			if((canShare==true||canShare=="true")&&result=="0,0"){
				canShare = false;
			}

			if(Ext.getCmp("DocShare").getTopToolbar().id){
				Ext.getCmp("DocShare").getTopToolbar().disable();
				if((canShare==true||canShare=="true")&&result.substr(2,1)=="1"){
					Ext.getCmp("DocShare").getTopToolbar().items.items[0].enable();
				}
				if(((canShare==true||canShare=="true")&&result.substr(0,1)=="1")||((canShare==true||canShare=="true")&&result.substr(2,1)=="1")){
					Ext.getCmp("DocShare").getTopToolbar().items.items[1].enable();
				}
			} else {
				 Ext.each(Ext.getCmp("DocShare").getTopToolbar(), function(obj) {   
					 obj.disabled = true;
				 });
				 if((canShare==true||canShare=="true")&&result.substr(2,1)=="1"){
					 Ext.getCmp("DocShare").getTopToolbar()[0].disabled = false;
				 }
				 if(((canShare==true||canShare=="true")&&result.substr(0,1)=="1")||((canShare==true||canShare=="true")&&result.substr(2,1)=="1")){
					 Ext.getCmp("DocShare").getTopToolbar()[1].disabled = false;
				 }
			}
        },
        failure: function(objRequest, objOptions){
            var txt = objRequest.responseText.replace(/(^\s*)|(\s*$)/g, "");
            alert(txt);
        }
    }); 
	
	Ext.override(Ext.grid.CheckboxSelectionModel, {
		renderer : function(v, p, record){				
				var chk="";				
				if(record.get("chk")!=null){
					chk=record.get("chk").replace(/(^\s*)|(\s*$)/g, "");
				}
				if(chk=="disabled"){
					return '<div></div>';
				} else {				
		        	return '<div class="x-grid3-row-checker">&#160;</div>';
				}
		    },
		 selectAll: function() {       
			if(this.locked) return;
	        this.selections.clear();
	        var record = this.grid.store.getRange();
	        for(var i = 0, len = this.grid.store.getCount(); i < len; i++){	  
	        		var chk="";
	        		if(record[i].get("chk")!=null){
						chk=record[i].get("chk").replace(/(^\s*)|(\s*$)/g, "");
					}	        									
		        	if(chk!='disabled'){
		            	this.selectRow(i, true);
		        	}	        	
	        }
		} 
		    
	});

    var storeDocShare = new Ext.data.Store({
        baseParams: {
            docid: docid
        },        
        proxy: new Ext.data.HttpProxy({
            method: 'POST',
            url: '/docs/docs/DocShareGet.jsp'
        }),
        reader: new Ext.data.JsonReader({
        	root : 'data',
			totalProperty : 'totalCount',
			fields: [{name: 'shareId'}, { name: 'chk'}, {name: 'shareName'}, { name: 'type'}, {}, { name: 'shareRealName'}, { name: 'shareRealType'}, { name: 'shareRealLevel'}, { name: 'downloadlevelName'}, { name: 'downloadlevel'}]
        })
    });    
    
    var smDocShare = new Ext.grid.CheckboxSelectionModel({
        handleMouseDown: Ext.emptyFn
    });   
    
    var arrayDocImgs_temp = [
	    {header: wmsg.share.name,width: 250,dataIndex: 'shareName'},
		{header: wmsg.share.type, width: 250,sortable: true,dataIndex: 'type'}, 
		{ header: wmsg.share.level,width: 200, dataIndex: 'shareRealLevel'}, 
		{header: wmsg.share.object,width: 150, dataIndex: 'shareRealName' }, 
		{header: wmsg.share.prom,width: 150, dataIndex: 'shareRealType' },
		{header: wmsg.share.downloadLevel,width: 150, dataIndex: 'downloadlevelName' }
    ];
	        
    if (canShare==true||canShare=="true") {
    	arrayDocImgs=[new Ext.grid.RowNumberer(), smDocShare].concat(arrayDocImgs_temp)
    }
    else {
    	arrayDocImgs=[new Ext.grid.RowNumberer()].concat(arrayDocImgs_temp)
    }
	var columnsDocShare=new Ext.grid.ColumnModel(arrayDocImgs);
    
    var DocSharePanelBar = [{
        text: wmsg.share.add,// '添加共享',
        iconCls: 'btn_add',
        tooltip: wmsg.share.add,//
        disabled:!(canShare==true||canShare=="true"),
        handler: function(){
            var win = new Ext.Window({
                layout: 'fit',
                width: 500,
                height: 300,
                closeAction: 'hide',
                plain: true,
                modal: true,
                title: wmsg.share.add,// '添加共享',
                items: new Ext.TabPanel({
                    activeTab: 0,
                    items: [{                    	
                        title: wmsg.base.content,// '内容',
                        html: "<IFRAME NAME='ifrmShareAdd' id='ifrmShareAdd' SRC='/docs/docs/DocShareAddBrowserExt.jsp?para=2_" +
                        docid +"&time="+new Date()+
                        "&blnOsp=false' style='width:100%;height:100%'  BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE scrolling='auto'></IFRAME>"
                    }]
                }),
                
                buttons: [{
                    text: wmsg.base.submit,// '确定',
                    handler: function(){
						if(ifrmShareAdd.document.getElementById("txtShare")!=null){
                            jQuery(ifrmShareAdd.document.getElementById("txtShare")).trigger("click");
                            //去掉换行符
                            var reg = /[\r\n]/g; 
                            eval(ifrmShareAdd.document.getElementById("txtShare").value.replace(reg,""));    
						}else{
	                        win.close();
						} 
                 
                        if(typeof(shareJson)!="undefined") {
	                        var txtShareDetail = shareJson.txtShareDetail;
	                        Ext.Ajax.request({
	                            url: "/docs/docs/DocShareUtil.jsp?method=addMulti&txtShareDetail=" +
	                            txtShareDetail +
	                            "&docid=" +
	                            docid,
	                            success: function(objRequest, objOptions){
		                        	storeDocShare.load({
		        			   			params : {
		        							start:0,
		        							limit:pageSize
		        						}
		        			    	});
	                            },
	                            failure: function(objRequest, objOptions){
	                                var txt = objRequest.responseText.replace(/(^\s*)|(\s*$)/g, "");
	                                alert(txt);
	                            }
	                        }); 
	                        win.close();
                        }                       
                    }
                }, {
                    text: wmsg.base.cancel,// '取消',
                    handler: function(){
                        win.close();
                    }
                }]
            });
            
            win.show(null);
        }
    }, {
        text: wmsg.share.del,// '删除共享',
        iconCls: 'btn_remove',
        disabled:!(canShare==true||canShare=="true"),
        tooltip: wmsg.share.del,// '删除共享',
        handler: function(){
            Ext.Msg.confirm(wmsg.base.confirmDel, wmsg.share.confirmDelNote, function(btn, text){
                if (btn == 'yes') {
                    var arrRecord = smDocShare.getSelections();
                    var delShareIds = "";
                    for (var i = 0; i < arrRecord.length; i++) {
                        var record = arrRecord[i];
                        var shareId = record.get("shareId");
                       
                        var chk=record.get("chk").replace(/(^\s*)|(\s*$)/g, "");	
                        if(chk!="disabled"){
                        	 delShareIds += shareId + ",";
	                        // alert(shareId)
	                        storeDocShare.remove(record);
	                        // alert(record.get("type"));
                        } 
                       
                    }
                    Ext.Ajax.request({
                        url: "/docs/docs/DocShareUtil.jsp?method=delMulti&shareIds=" +
                        delShareIds +
                        "&docid=" +
                        docid,
                        success: function(objRequest, objOptions){
		                    storeDocShare.load({
		        			   	params : {
		        					start:0,
		        					limit:pageSize
		        				}
		        			}); 
							var result = objRequest.responseText.trim();
							if(result!=""){
								alert(result);
							}
                        },
                        failure: function(objRequest, objOptions){
                            var txt = objRequest.responseText.replace(/(^\s*)|(\s*$)/g, "");
                            alert(txt);
                        }
                    });
                }
            });
        }
    }];
    //storeDocShare.load();
    storeDocShare.load({
			params : {
			start:0,
			limit:pageSize
		}
	});
    var DocSharePanel = {
	    	listeners: {
	              /*show  : function(p){	    
			    	storeDocShare.load({
			   			params : {
							start:0,
							limit:pageSize
						}
			    	});
	            },*/	           
	        },
	        
    		xtype:'grid',
            id: 'DocShare',            
            width: 1200,
            height: 200,
            loadMask: true,
            //title: wmsg.doc.share,// '文档共享',
            viewConfig: {
                forceFit: true
            },
            store: storeDocShare,
            cm: columnsDocShare,
            trackMouseOver: true,
            autoSizeColumns: true,
            sm: smDocShare,
            tbar: DocSharePanelBar,
            bbar : new Ext.PagingToolbar({
   				pageSize : pageSize,
   				store : storeDocShare,
   				displayInfo : true,
   				displayMsg : wmsg.grid.gridDisp1 + '{0} - {1}' + wmsg.grid.gridDisp2
   						+ '{2}' + wmsg.grid.gridDisp3,
   				emptyMsg : wmsg.grid.noItem			
   			})
    };
    return {
		getGrid:function(){			
			return DocSharePanel;
		},
		init : function() {

		}
	}
}