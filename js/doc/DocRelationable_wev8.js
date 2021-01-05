//Ext.namespace('weaver.doc');
//weaver.doc.DocRelationable = function(docid) {
DocRelationable = function(docid) {
	
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

    var storeDocShare1 = new Ext.data.Store({
        baseParams: {
            docid: docid,
            olddocid: olddocid,
            requestid: requestid,
            isrequest: isrequest,
            doccreaterid: doccreaterid,
            docCreaterType: docCreaterType,
            ownerid: ownerid,
            ownerType: ownerType
        },        
        proxy: new Ext.data.HttpProxy({
            method: 'POST',
            url: '/docs/docs/DocRelationGet.jsp'
        }),
        reader: new Ext.data.JsonReader({
            fields: [{name: 'shareId'}, { name: 'chk'}, {name: 'shareName'},{ name: 'shareRealName'}]
        })
    });
    
    var smDocShare1 = new Ext.grid.CheckboxSelectionModel({
        handleMouseDown: Ext.emptyFn
    });   
    
    var arrayDocImgs_temp = [
	    {header: wmsg.share.docdyname,width: 250,dataIndex: 'shareName'},
	    {header: wmsg.share.docownname,width: 150, dataIndex: 'shareRealName' }
    ];
	        
    if (true) {
    	arrayDocImgs=[new Ext.grid.RowNumberer(), smDocShare1].concat(arrayDocImgs_temp)
    }
    else {
    	arrayDocImgs=[new Ext.grid.RowNumberer(),smDocShare1].concat(arrayDocImgs_temp)
    }
	var columnsDocShare=new Ext.grid.ColumnModel(arrayDocImgs);
    
    var DocSharePanelBar1 = [{
        text: wmsg.share.docdybut,
        iconCls: 'btn_add',
        tooltip: wmsg.share.docdybut,//
        disabled:false,
        handler: function(){
        	//TODO
        	var arrRecord = smDocShare1.getSelections();
            var delShareIds = "";		                   
            for (var i = 0; i < arrRecord.length; i++) {
                var record = arrRecord[i];
                var shareId = record.get("shareId");
               
                var chk=record.get("chk").replace(/(^\s*)|(\s*$)/g, "");	
                if(chk!="disabled"){
                	delShareIds += shareId + ",";
                } 		                       
            }
            var win = new Ext.Window({
                layout: 'fit',
                width: 700,
                height: 500,
                closeAction: 'hide',
                plain: true,
                modal: true,
                title: wmsg.share.docdybut,// '添加订阅',
                items: new Ext.TabPanel({
                    activeTab: 0,
                    items: [{                   	
                        title: wmsg.base.content,// '内容',
                        html: "<IFRAME NAME='ifrmShareAdd' id='ifrmShareAdd' SRC='/docs/docsubscribe/DocSubscribeAdd.jsp?subscribeDocId=" +
                        delShareIds + "'"+
                        "style='width:100%;height:100%'  BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE scrolling='auto'></IFRAME>"
                    }]
                }),
                
                buttons: [{
                    text: wmsg.base.cancel,// '取消',
                    handler: function(){                   
                        win.hide();
                    }
                }]
            });   
           
            win.show(null);
        }
    }];
    storeDocShare1.load();
    var DocSharePanel2 = {
    		xtype:'grid',
            id: 'DocRelation',           
            width: 1200,
            height: 200,
            loadMask: true,
            //title: wmsg.base.relationResource,// '文档共享',
            viewConfig: {
                forceFit: true
            },
            store: storeDocShare1,
            cm: columnsDocShare,
            trackMouseOver: true,
            autoSizeColumns: true,
            sm: smDocShare1,
            tbar: DocSharePanelBar1
    };
    return {
		getGrid:function(){			
			return DocSharePanel2;
		},
		init : function() {

		}
	}
}