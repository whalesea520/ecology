	var	winImg;
	var storeDocImgs;

	var DocCommonExt = {
	 	replycount:0,
	 	isDocPropPaneHidden:true
	 };
	 /*文档内容*/ 
   DocCommonExt.getDocContentPanel=function(docTitle,contentEl,menubar,menubarForwf,isFromWf,mode,pagename,docid){
		if(mode=="view") {
			docTitle="<div style='overflow:hidden;white-space:nowrap;text-overflow:ellipsis;width:500px;'>"+docTitle+"</div>";
		}
		if(pagename=="docdsp"){ //use iframe
			if(isFromWf){
				return  {	
						xtype:'iframepanel',
		                region:'center',
		                activeTab:0,
		                buttons :menubarForwf,
		                buttonAlign:'center',
						id:'ifrmContent',  
						defaultSrc:'/docs/docs/DocDspHtmlShow.jsp?docid='+docid,
						closable:false,
						titleCollapse:false,             
		                autoScroll:true
		           };   
			} else {
			 return {					 
				 xtype:'tabpanel',
		           region:'center',					
		           //deferredRender:false,
		           activeTab:0,
		           bbar :menubar,           
				   id:'divContentTab',
				   items:{
						xtype:'panel',
						closable:false,
						title: docTitle, 
						autoScroll:true,				
						html: "<IFRAME name='ifrmContent' src='/docs/docs/DocDspHtmlShow.jsp?docid="+docid+"' id='ifrmContent' style='width:100%;height:100%'  BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE scrolling='auto'></IFRAME>"
					}
		        };
			} 
		
		} else { //use panel
			if(isFromWf){
				return  {		
						xtype:'panel',
		                region:'center',
		                activeTab:0,
		                buttons :menubarForwf,
		                buttonAlign:'center',
						id:'divContentTab',  
						contentEl:contentEl,
						titleCollapse:false,             
		                autoScroll:true
		           };
			} else {
			 return {	
					xtype:'tabpanel',
		            region:'center',					
		            //deferredRender:false,
		            activeTab:0,
		            bbar :menubar,           
					id:'divContentTab',                  
		           
		           items:[{
						//id:'divContentTab',
		                contentEl:contentEl,
						titleCollapse:false,
		                title: docTitle,                    
		                autoScroll:true
		            }]
		        };
			} 
		}
  }
  
	 /*PDF文档内容*/ 
   DocCommonExt.getDocPDFContentPanel=function(docTitle,contentEl,menubar,menubarForwf,isFromWf,mode,pagename,docid,isPDF,canPrint,canEditPDF,imagefileId){
		if(mode=="view") {
			docTitle="<div style='overflow:hidden;white-space:nowrap;text-overflow:ellipsis;width:500px;'>"+docTitle+"</div>";
		}
		if(pagename=="docdsp"){ //use iframe
			if(isFromWf){
				return  {	
						xtype:'iframepanel',
		                region:'center',
		                activeTab:0,
		                buttons :menubarForwf,
		                buttonAlign:'center',
						id:'ifrmContent',  
						defaultSrc:'/docs/docs/DocDspHtmlShow.jsp?docid='+docid+'&imagefileId='+imagefileId+'&isPDF='+isPDF+'&canPrint='+canPrint+'&canEdit='+canEditPDF,
						closable:false,
						titleCollapse:false,             
		                autoScroll:true
		           };   
			} else {
			 return {					 
				 xtype:'tabpanel',
		           region:'center',					
		           //deferredRender:false,
		           activeTab:0,
		           bbar :menubar,           
				   id:'divContentTab',
		           items:[{
		        	    id:'ifrmContent',
		        	    closable:false,
		        	    xtype:'iframepanel',
						//id:'divContentTab',
						defaultSrc:'/docs/docs/DocDspHtmlShow.jsp?docid='+docid+'&imagefileId='+imagefileId+'&isPDF='+isPDF+'&canPrint='+canPrint+'&canEdit='+canEditPDF,
		                //contentEl:contentEl,
						titleCollapse:false,
		                title: docTitle,                    
		                autoScroll:true
		            }]
		        };
			} 
		
		} else { //use panel
			if(isFromWf){
				return  {		
						xtype:'panel',
		                region:'center',
		                activeTab:0,
		                buttons :menubarForwf,
		                buttonAlign:'center',
						id:'divContentTab',  
						contentEl:contentEl,
						titleCollapse:false,             
		                autoScroll:true
		           };
			} else {
			 return {	
					xtype:'tabpanel',
		            region:'center',					
		            //deferredRender:false,
		            activeTab:0,
		            bbar :menubar,           
					id:'divContentTab',                  
		           
		           items:[{
						//id:'divContentTab',
		                contentEl:contentEl,
						titleCollapse:false,
		                title: docTitle,                    
		                autoScroll:true
		            }]
		        };
			} 
		}
  }
  
  
  /*文档属性*/
  DocCommonExt.getDocPropPanel=function(contentEl){
	return{
			xtype:'panel',
			id:'DocPropAdd',
			title:wmsg.doc.base,
			contentEl:contentEl,
			autoScroll:true
		}	;	
  }
 /*文档附件*/
 DocCommonExt.getDocImgPanel=function(maxUploadImageSize,mode,docid,canEdit,bacthDownloadFlag){    
 	var sUrl="/docs/docs/DocUploadComm.jsp?mode=" +mode+"&docid="+docid+"&maxUploadImageSize="+maxUploadImageSize;
 	if(mode!="add") sUrl+="&isEditionOpen="+(isEditionOpen?1:0);
   winImg = new Ext.Window({  	
			 listeners:{				
				  hide :function(w){
				 	//alert(1)
				 	//w.findByType("button")[0].setDisabled(false);
					//Ext.get("btnImgOk").setDisabled(false);
				  	//document.getElementById("ifrmUpload").location.reload();
				  	
				  	document.getElementById("ifrmUpload").src=sUrl;
				  
				  	
				}
			},
			layout:'fit',
			width:500,
			height:300,
			closeAction:'hide',
			plain: true,
			modal: true, 	
			title:wmsg.acc.addMulti,
			items:{
				xtype:'panel',
				autoScroll:true,				
				 html: "<IFRAME name='ifrmUpload' src='"+sUrl+"' id='ifrmUpload' style='width:100%;height:100%'  BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE scrolling='auto'></IFRAME>"
			}
			,buttons: [
			{
				id:"btnImgOk",
				text:wmsg.base.startUpload,//'开始上传',	
				handler: function(){						
					try {
						//document.frames["ifrmUpload"].oUploader.startUpload();
						document.getElementById("ifrmUpload").contentWindow.oUploader.startUpload();
						//this.setDisabled(true);						
					} catch (ex) { alert(ex); }
				}
			}
			]
	});	
		
	var smDocImgs= new  Ext.grid.CheckboxSelectionModel({handleMouseDown: Ext.emptyFn});
	
	var columnsDocImgs;
		if(mode=="add") {
	  canDownload=false;
	}
	if(mode=="add") {		
			storeDocImgs = new Ext.data.Store({	
				listeners :{
					 add :function(store,records, index ){
					 	var imgidstr = "";
					 	var namestr = "";
					 	store.each(function(record) {
							imgidstr += "," + record.get('imgid');
							namestr += "|" + record.get('name');
						});
						imgidstr=imgidstr.substr(1);
						namestr=namestr.substr(1);
						document.getElementById("imageidsExt").value=imgidstr;
						document.getElementById("imagenamesExt").value=namestr;
						//Ext.getCmp("DocImgs").setTitle(wmsg.doc.acc+'('+store.getCount()+wmsg.base.entries+')');
						if(document.getElementById("divAccATabTitle")) document.getElementById("divAccATabTitle").innerHTML = wmsg.doc.acc+'('+store.getCount()+')';
					},
					remove :function(store,records, index ){
					 	var imgidstr = "";
					 	var namestr = "";
					 	store.each(function(record) {
							imgidstr += "," + record.get('imgid');
							namestr += "|" + record.get('name');
						});
						imgidstr=imgidstr.substr(1);
						namestr=namestr.substr(1);
						document.getElementById("imageidsExt").value=imgidstr;
						document.getElementById("imagenamesExt").value=namestr;
						//Ext.getCmp("DocImgs").setTitle(wmsg.doc.acc+'('+store.getCount()+wmsg.base.entries+')');
						if(document.getElementById("divAccATabTitle")) document.getElementById("divAccATabTitle").innerHTML = wmsg.doc.acc+'('+store.getCount()+')';
					}
				},
				data:[],			
				reader: new Ext.data.ArrayReader({}, [{name: 'imgid'},{name: 'icon'},{name: 'name'},{name: 'size'}])
			});
			columnsDocImgs = new Ext.grid.ColumnModel([	
				new Ext.grid.RowNumberer({'width':43}),
				smDocImgs,			
				{header: wmsg.acc.name,width:.5, sortable: true,dataIndex: 'name',hideable:true},
				{header: wmsg.acc.size,width:.1, sortable: true,dataIndex: 'size',hideable:true}				
			]);
	} else if(mode=="view" || mode=="edit") {
		    storeDocImgs = new Ext.data.Store({
	        baseParams: {
	            docid: docid,showType: mode,coworkid: coworkid,meetingid: meetingid,requestid: requestid
	        },	        
	        proxy: new Ext.data.HttpProxy({
	            method: 'POST',     url: '/docs/docs/DocImgsGet.jsp?canEdit='+canDownload
	        }),	        
	        reader: new Ext.data.JsonReader({
	            root: 'data',
	            id: 'id',
	            fields: [{name: 'imgid'}, {name: 'icon'}, {name: 'name'}, {name: 'oprea'}, {name: 'size'}]
	        }),
	        
	        listeners: {
				 add :function(store,records, index ){
				 	var imgidstr = "";
				 	var namestr = "";
				 	store.each(function(record) {
						imgidstr += "," + record.get('imgid');
						namestr += "|" + record.get('name');
					});
					imgidstr=imgidstr.substr(1);
					namestr=namestr.substr(1);
					document.getElementById("imageidsExt").value=imgidstr;
					document.getElementById("imagenamesExt").value=namestr;
					//Ext.getCmp("DocImgs").setTitle(wmsg.doc.acc+'('+store.getCount()+wmsg.base.entries+')');
					if(document.getElementById("divAccATabTitle")) document.getElementById("divAccATabTitle").innerHTML = wmsg.doc.acc+'('+store.getCount()+')';
				},
				remove :function(store,records, index ){
				 	var imgidstr = "";
				 	var namestr = "";
				 	store.each(function(record) {
						imgidstr += "," + record.get('imgid');
						namestr += "|" + record.get('name');
					});
					imgidstr=imgidstr.substr(1);
					namestr=namestr.substr(1);
					document.getElementById("imageidsExt").value=imgidstr;
					document.getElementById("imagenamesExt").value=namestr;
					//Ext.getCmp("DocImgs").setTitle(wmsg.doc.acc+'('+store.getCount()+wmsg.base.entries+')');
					if(document.getElementById("divAccATabTitle")) document.getElementById("divAccATabTitle").innerHTML = wmsg.doc.acc+'('+store.getCount()+')';
				},
	            load: function(sm, records, options){
	                //Ext.getCmp("DocImgs").setTitle(wmsg.doc.acc + '(' + records.length + ')');
	        		if(document.getElementById("divAccATabTitle")) document.getElementById("divAccATabTitle").innerHTML = wmsg.doc.acc + '(' + records.length + ')';
	                try {
	                    fontImgAcc.innerHTML = records.length ;
	                }  catch (e) {}
	                try {
						if(records.length>0){
							Ext.getCmp("flowDocAcc_id").setText(wmsg.doc.acc + '(' + records.length + ')');
						}else{
						    Ext.getCmp('flowDocAcc_id').hide();
						}
	                }  catch (e) {}
	            }
	        }
	    });
	    storeDocImgs.load();
	    var arrayDocImgs_temp = [
	    	{header: wmsg.base.icon,width: .1,dataIndex: 'icon',hideable: true}, 
	    	{header: wmsg.acc.name,width: .5,sortable: true, dataIndex: 'name',hideable: true}, 
	    	{header: wmsg.acc.size,width: .1,sortable: true,dataIndex: 'size',hideable: true}, 
	    	{header: wmsg.acc.operate,width: .3,sortable: true,dataIndex: 'oprea',hideable: true}
	     ];
	        
	  //if (canEdit&&(!isEditionOpen||(mode=="edit"))&&mode!="view") {
	    if (canEdit&&(!isEditionOpen||(mode=="edit")||(mode=="view"))) {
	    	arrayDocImgs=[new Ext.grid.RowNumberer({'width':43}), smDocImgs].concat(arrayDocImgs_temp)
	    }
	    else {
	    	arrayDocImgs=[new Ext.grid.RowNumberer({'width':43})].concat(arrayDocImgs_temp)
	    }
	    columnsDocImgs=new Ext.grid.ColumnModel(arrayDocImgs);
	}
	
 	return {
	    						xtype:'grid',
								id:'DocImgs',								
								width:1200,
								height:380,		
								//title:wmsg.doc.acc,
								store: storeDocImgs,
								cm: columnsDocImgs,
								sm:smDocImgs,
								trackMouseOver:true,
								autoSizeColumns:true,
								stripeRows: true,
								disableSelection :true,		
								
								
								tbar:[{									
									text:wmsg.acc.maxAdd+maxUploadImageSize+'M)',
									iconCls: 'btn_add',
									tooltip:wmsg.acc.maxAdd+maxUploadImageSize+'M)',
									disabled:!canEdit || maxUploadImageSize==0 || mode=="view",
									handler: function(){	
											winImg.show(null);												
											//oUploader.selectFiles();
										}
										
								},'-', {									
									text:wmsg.acc.del,//'删除附件',
									iconCls: 'btn_remove',
									tooltip:wmsg.doc.del,
									disabled:!canEdit || mode=="view" ,
									handler: function(){
									var arrRecord=smDocImgs.getSelections();	
											//td33488 start
									var vid="",dvid=document.getElementById("WebOffice");
									if(dvid!=null){
									dvid=dvid.RecordID.split("_")[0];
									for (var i=0;i<arrRecord.length;i++ ){
											try{
												var record=arrRecord[i];
												var sd=record.get("name");
												var instr=sd.indexOf("versionId=");var inend=sd.indexOf("&imagefileId");
												sd=sd.substring(instr,inend).split("=")[1];
												if(dvid==sd){alert(SystemEnv.getHtmlNoteName(3511,readCookie("languageidweaver")));return;}
											}catch(e){}
									 }
									}
									//td33488 end

										if(arrRecord==""){
											alert(wmsg.acc.noImgSelected)
										} else {
											Ext.Msg.confirm(wmsg.base.confirmDel, wmsg.base.confirmDelNote, function(btn, text){	
																						
												if (btn == 'yes'){
													var arrRecord=smDocImgs.getSelections();													
													if(mode=="add") {
														var delImgIds="";
													    for (var i=0;i<arrRecord.length;i++ ){
															var record=arrRecord[i];
															var imgId=record.get("imgid");
															delImgIds+=imgId+",";													
														    storeDocImgs.remove(arrRecord[i]);
														}
														document.getElementById("delImageidsExt").value+=delImgIds;
											   		}  else if(isEditionOpen) {
														var delImgIds="";
													    for (var i=0;i<arrRecord.length;i++ ){
															var record=arrRecord[i];
															var imgId=record.get("imgid");
															delImgIds+=imgId+",";													
														    storeDocImgs.remove(arrRecord[i]);
														}
														document.getElementById("deleteaccessory").value+=delImgIds;
											   		}  else {

														var delImgIds="";
														for (var i=0;i<arrRecord.length;i++ ){
															var record=arrRecord[i];
															var imgId=record.get("imgid");
															delImgIds+=imgId+",";													
		
														}
														
														Ext.Ajax.request({
														   url: "/docs/docs/DocImgsUtil.jsp?method=delImgsOnly&docid="+docid+"&delImgIds="+delImgIds,
														   success: function(objRequest,objOptions ){
														   		
														   		
															 	 storeDocImgs.load();												   
														   },
														   failure:function(objRequest,objOptions ){
																var txt=objRequest.responseText.replace(/(^\s*)|(\s*$)/g, "");
																alert(txt);
														   }
														});
											   		}
												}
											});
										}
									}
								},'-',{									
									text:wmsg.acc.bacthDownload,//'批量下载附件',
									iconCls: 'btn_BacthDownload',
									tooltip:wmsg.acc.bacthDownload,
                                  //disabled:!canEdit|| mode=="add" || bacthDownloadFlag=="1",
									disabled:!canDownload|| mode=="add" || bacthDownloadFlag=="1",
									handler: function(){
										var arrRecord=smDocImgs.getSelections();	
										if(arrRecord==""){
											alert(wmsg.acc.noImgSelected)
										} else {
													var arrRecord=smDocImgs.getSelections();													
                                                    if(isEditionOpen) {
											   		    //alert("--1111---isEditionOpen:"+isEditionOpen);
														var delImgIds="";
														
													    for (var i=0;i<arrRecord.length;i++ ){
															var record=arrRecord[i];
															var imgId=record.get("imgid");
															delImgIds+=imgId+",";													
														    //storeDocImgs.remove(arrRecord[i]);
														}
														
														//alert("delImgIds:"+delImgIds+";docid="+docid);
														//document.getElementById("deleteaccessory").value+=delImgIds;
														//alert(!canEdit+"----"+canDownload);
														window.open("/weaver/weaver.file.FileDownload?fieldvalue="+docid+"&delImgIds="+delImgIds+"&download=1&downloadBatch=1&requestid=");
														storeDocImgs.load();
											   		}  else {
											   		    //alert("--2222---isEditionOpen:"+isEditionOpen);
														var delImgIds="";
														
														for (var i=0;i<arrRecord.length;i++ ){
															var record=arrRecord[i];
															var imgId=record.get("imgid");
															delImgIds+=imgId+",";													
		
														}
														
														/*
														Ext.Ajax.request({
														   //url: "/docs/docs/DocImgsUtil.jsp?method=delImgsOnly&docid="+docid+"&delImgIds="+delImgIds,
														   url: "/weaver/weaver.file.FileDownload?fieldvalue="+docid+"&delImgIds="+delImgIds+"&download=1&downloadBatch=1&requestid=",
														   success: function(objRequest,objOptions ){
														   		
														   		
															 	 storeDocImgs.load();												   
														   },
														   failure:function(objRequest,objOptions ){
																var txt=objRequest.responseText.replace(/(^\s*)|(\s*$)/g, "");
																alert(txt);
														   }
														});*/
														//alert(!canEdit+"----"+canDownload);
														//alert("--2222---delImgIds:"+delImgIds+";docid="+docid);
														window.open("/weaver/weaver.file.FileDownload?fieldvalue="+docid+"&delImgIds="+delImgIds+"&download=1&downloadBatch=1&requestid=");
														storeDocImgs.load();
											   		}											
										}
									}
								}],

								viewConfig: {
									forceFit:true								
								}
		};
  }
  
  
  /*文档版本*/
 DocCommonExt.getDocVerPanel=function(){
 	var storeDocVers = new Ext.data.Store({
        baseParams: {
            docid: docid,
            doceditionid: doceditionid,
            readerCanViewHistoryEdition: readerCanViewHistoryEdition,
            canEditHis: canEditHis
        },        
        proxy: new Ext.data.HttpProxy({
            method: 'POST',
            url: '/docs/docs/DocVersionGet.jsp'
        }),        
        reader: new Ext.data.JsonReader({
            fields: [{name: 'docsubject'}, {name: 'versionid' }, { name: 'docLastModUserId'}, {name: 'doclastmoditime'}]
        })      
        /*,listeners: {
            load: function(sm, records, options){
                Ext.getCmp("DocVersion").setTitle(wmsg.doc.version + '(' + records.length +  ')');
            }
        }*/
    });
    storeDocVers.load();
    
    var smDocVers = new Ext.grid.CheckboxSelectionModel({
        handleMouseDown: Ext.emptyFn 
    });
    var columnsDocVers = new Ext.grid.ColumnModel([
	    new Ext.grid.RowNumberer({'width':43}), 
	    {  header: wmsg.doc.name,width: .4, dataIndex: 'docsubject',hideable: true }, 
	    { header: wmsg.base.version, width: .2,sortable: true,dataIndex: 'versionid', hideable: true}, 
	    { header: wmsg.base.docLastModUserId,width: .1,sortable: true,dataIndex: 'docLastModUserId', hideable: true},
	    {header: wmsg.base.lastModiDate, width: .3, sortable: true,dataIndex: 'doclastmoditime', hideable: true}
    ]);  
 	
    
    return {
    	xtype:'grid',
    	listeners: {
	             activate : function(p){	               
	                storeDocVers.load();
	            }
	   },
    	
        id: 'DocVersion',
        //title: wmsg.doc.version,
        store: storeDocVers,
        cm: columnsDocVers,
        sm: smDocVers,
        trackMouseOver: true,
        autoSizeColumns: true,
        stripeRows: true,
        disableSelection: true,
        loadMask: true,
        viewConfig: {
            forceFit: true
        }
    }; 	
 }
 /*文档回复*/
 var winReply;
 DocCommonExt.getDocReplyPanel=function(){
 	
    
   
   var DocReplyTreeLoader = new Ext.tree.TreeLoader({
        listeners: {
            load: function(load, node, resp){
                try {   
                    treeNodeCount=DocCommonExt.getChildrensNodeCount(node);    
                    //alert(DocCommonExt.replycount)
                    //Ext.getCmp("DocReply").setTitle(wmsg.doc.reply + '(' + DocCommonExt.replycount +  ')');
                    //if(document.getElementById("divReplayATabTitle")) document.getElementById("divReplayATabTitle").innerHTML = wmsg.doc.reply + '(' + DocCommonExt.replycount +  ')';
                    //fontReply.innerHTML = DocCommonExt.replycount;
                } 
                catch (e) {
                }
            }
        },
        baseParams: {
            docid: docid,
            isReply: isReply
        },
        dataUrl: '/docs/docs/DocReplyGet.jsp',
        uiProviders: {
            'col': Ext.tree.ColumnNodeUI
        }
    });
    
   var  DocReplyTreeRoot = new Ext.tree.AsyncTreeNode({
        text: 'replys'
    });
    
    
    winReply = new Ext.Window({
        layout: 'fit',
        width: 700,
        //resizable: false,
        height: 700,
        closeAction: 'hide',
        plain: true,
        listeners :{
			 hide :function(cmp){
				setTimeout( function() {DocReplyTreeLoader.load(DocReplyTreeRoot); }, 4000); 
			}
		},
        modal: true,
        title: wmsg.doc.reply,// '文档回复',
        html: "<IFRAME NAME='ifrmReply' id='ifrmReply' SRC='/docs/docs/DocReply.jsp?id=" +
        docid +
        "&parentids=" +
        parentids +
        "' style='width:100%;height:100%'  BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE scrolling='auto'></IFRAME>",
        autoScroll: true
        /*,buttons: [
        {
            text: wmsg.base.submit,// '确定',
            handler: function(){
                document.frames["ifrmReply"].document.getElementById("btnSave").onclick();
                winReply.hide();
               	setTimeout( function() {DocReplyTreeLoader.load(DocReplyTreeRoot); }, 4000); 
                
            }
        }, {
            text: wmsg.base.draft,// '草稿',
            handler: function(){
                document.frames["ifrmReply"].document.getElementById("btnDraft").onclick();
                winReply.
                //winReply.hide();
            }
        }, {
            text: wmsg.base.acc,// '附件',
            handler: function(){
                document.frames["ifrmReply"].document.getElementById("btnAccAdd").onclick();
                
            }
        }, {
            text: 'HTML',// 'HTML',
            handler: function(){
                document.frames["ifrmReply"].document.getElementById("btnHtml").onclick();
                
            }
        },
        {
            text: wmsg.base.cancel,// '取消',
            handler: function(){
                winReply.hide();
            }
        }]*/
    });
   
	
    
    return  new Ext.tree.ColumnTree({		
	  		id:'DocReply',
	  		//title: wmsg.doc.reply,
	        rootVisible: false,
	        animate : false,
	        autoScroll: true,	      	             
	        lines :true,		 
	        border: true,
	        selModel:new Ext.tree.MultiSelectionModel({onNodeClick: Ext.emptyFn}),
	        disableSelection: true,
	        columns: [{
	            header: wmsg.doc.name,// '文档名称',
	            width: '69%',
	            dataIndex: 'docsubject'
	        }, {
	            header: wmsg.base.owner,// '文档所有者',
	            width: '12%',
	            dataIndex: 'doccreatorname'
	        }, {
	            header: wmsg.base.lastModiDate,// '文档最后修改日期',
	            width: '18%',
	            dataIndex: 'doclastmoditime'
	        }],	        
	        loader: DocReplyTreeLoader,	        
	        root: DocReplyTreeRoot
	    });	     
 }
 /*文档打分*/
  DocCommonExt.getDocMarkPanel=function(){ 
	  return {
	  	    xtype:'panel',
            autoScroll: 'true',
            id: 'docMark',
            //title: wmsg.doc.mark,// '文档打分',
          
            html: "<IFRAME  SRC='/docs/docmark/DocMarkAdd.jsp?docId=" +
            docid +
            "&secId=" +
            seccategory +
			"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+
            "'  style='width:100%;height:100%'  BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE scrolling='auto'></IFRAME>"
        };  
  }
 
  /*文档设置*/
  DocCommonExt.getDocAllPropPanel=function(isFromWf,DocSetTabPane){  
		var collapseMode='';
		if(isFromWf)  collapseMode='mini';
		
		return new Ext.Panel({
					xtype:'panel',
					id:'DocAllProp',
                    region:'south',                   
                    split:true,
                    height: 250,
                    minSize: 50,
                    maxSize: 600,   				   
                    collapsible: true,
					collapsed :true,	
					floatable:false,
					collapseMode:collapseMode,
						
			listeners :{
				  expand :function(p) {
				  	DocCommonExt.isDocPropPaneHidden=false;
					try{
						spanProp.innerHTML=wmsg.base.hiddenProp;
						document.getElementById("docPropTable").style.display='';	
						viewport.doLayout();
					} catch(e){}
				 },
				  collapse :function(p) {
				  	DocCommonExt.isDocPropPaneHidden=true;
					try{
						spanProp.innerHTML=wmsg.base.showProp;
						document.getElementById("docPropTable").style.display='none';	
						viewport.doLayout();
					} catch(e){}
				 }
			},					 
            title:wmsg.doc.prop,//'文档设置',
			layout:'fit',
            margins:'0 0 0 0',
			items:
			DocSetTabPane					
        });
  }
  DocCommonExt.finalDo=function(mode){
	 try{
	  	if(mode=="view"||mode=="edit"){  		
	  		DocSetTabPanel.setActiveTab("DocReply");
	  	}
	 }catch(e){}
	 
	//需要加上收藏与帮助按钮
	var divContentTabObj=Ext.get('divContentTab').dom;
	var divFavorite =document.createElement("DIV");
	divFavorite.id="divFavorite";
	//alert("params : "+params);
	divFavorite.innerHTML="<img src='/images/btnFavorite_wev8.gif' style='cursor:hand' onclick=\"openFavouriteBrowser();\" title="+wmsg.base.addToFavorite+">" +
			"&nbsp;<img src='/images/help2_wev8.gif'  style='cursor:hand' onclick='DocCommonExt.showHelp()' title="+wmsg.base.help+">"; 
	
	divFavorite.style.position="absolute";
	divFavorite.style.posTop="2";
	divFavorite.style.posRight="15";
	divContentTabObj.firstChild.appendChild(divFavorite);
	//alert(divContentTabObj.className)
    Ext.get('loading').fadeOut();
  }
   	
  
DocCommonExt.showorhiddenprop=function(){
	if(DocCommonExt.isDocPropPaneHidden){
		DocAllPropPanel.expand(true);		
	} else {
		DocAllPropPanel.collapse(true);	}
}

DocCommonExt.getChildrensNodeCount=function(node){
    	var children=node.childNodes;
    	if(node.attributes.iconCls=="icon_replyDoc_this"){
    		DocCommonExt.replycount=children.length;
    		return ;
    	};
    	for(var i=0;i<children.length;i++){   
    		DocCommonExt.getChildrensNodeCount(children[i]);   		
   	   } 
  }
 DocCommonExt.overTitleInput = function(type){
	var oInputTemp=Ext.get("spanDocTitle_temp");
	var oInputNew=Ext.get("spanDocTitle");					
	//if(oInputTemp.getXY()!="0,0")		oInputNew.setXY(oInputTemp.getXY());
	if(oInputTemp.getXY()!="0,0"){		
		oInputNew.setX(13);		
		oInputNew.setY(7);		
	}	
	oInputNew.setWidth(oInputTemp.getWidth());
	oInputNew.dom.style.display='';
 }
 DocCommonExt.showHelp = function(){
 	var pathKey = window.location.pathname;
    //alert(pathKey);
    if(pathKey!=""){
        pathKey = pathKey.substr(1);
    }
    var operationPage = "http://help.e-cology.com.cn/help/RemoteHelp.jsp";
    //var operationPage = "http://localhost/help/RemoteHelp.jsp";
    var screenWidth = window.screen.width*1;
    var screenHeight = window.screen.height*1;

    window.open(operationPage+"?pathKey="+pathKey,"_blank","top=0,left="+(screenWidth-800)/2+",height="+(screenHeight-90)+",width=800,status=no,scrollbars=yes,toolbar=yes,menubar=no,location=no");
 }
 
 var  addStoreDocImgsData=function(json){
 	storeDocImgs.add(new Ext.data.Record(json));	
 }
 function openFavouriteBrowser()
 {
	var favpagename = setFavPageName();
	var favuri = setFavUri();
	var favquerystring = setFavQueryString();
     jQuery.post("/systeminfo/FavouriteSession.jsp",{pagename:favpagename},function (data) {
         var sessionKey = data.sessionKey;
         window.showModalDialog('/systeminfo/BrowserMain.jsp?url=/favourite/FavouriteBrowser.jsp&fav_pagename='+sessionKey+'&fav_uri='+favuri+'&fav_querystring='+favquerystring+"&mouldID=doc");
     });

 }