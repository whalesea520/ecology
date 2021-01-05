 var DocAllPropPanel;
 var DocSetTabPanel;
 var DocContentPanel;

 Ext.onReady(function(){
	 
 		try{	
			onLoad();
		} catch(e){}

 		//define DocSetTabPanel
		DocSetTabPanel=new Ext.TabPanel({
						id:'DocAllPanel',
						border:false,
						activeTab:0,					    
						tabPosition:'bottom',						
						items:[	
							DocCommonExt.getDocPropPanel('docPropTable')
						]
		});
		DocSetTabPanel.add(DocCommonExt.getDocImgPanel(maxUploadImageSize,"add","",true,""));
		if(doctype=="html"){
			document.title=wmsg.doc.createHTML;
		} else if(doctype==".doc"){
			document.title=wmsg.doc.createWord;
		}else if(doctype==".xls"){
			document.title=wmsg.doc.createExcel;
		}else if(doctype==".ppt"){
			document.title=wmsg.doc.createPPT;
		}else if(doctype==".wps"){
			document.title=wmsg.doc.createWps;
		}		
		//define DocAllPropPanel
		DocAllPropPanel=DocCommonExt.getDocAllPropPanel(isFromWf,DocSetTabPanel);        
        	
		//define DocContentPanel
        var docTitle="";       
		docTitle="<span  id='spanDocTitle_temp' style='width:400px;visibility:hidden'>&nbsp;<input></span>";		
		DocContentPanel=DocCommonExt.getDocContentPanel(docTitle,"divContent",menubar,menubarForwf,isFromWf,"add");

		//define viewport
	    var viewport= new Ext.Viewport({
            layout:'border',
            items:[
                DocContentPanel,
                DocAllPropPanel
             ]
        });	        
        
        
		try{
			document.getElementById("divContent").style.display='';	
			//document.getElementById("docPropTable").style.display='';
			document.getElementById('rightMenu').style.visibility="hidden";
			document.getElementById("divMenu").style.display='';	
		} catch(e){}
		
		var oInputNew=Ext.get("spanDocTitle");
		Ext.get("divContentTab").on('resize', function() {
			adjustContentHeight("resize");
			if(!isFromWf)  DocCommonExt.overTitleInput("resize"); 
		});

		adjustContentHeight("load");
		if(!isFromWf) DocCommonExt.overTitleInput("load");

		DocCommonExt.finalDo("add");

		try{	
			onLoadEnd();
		} catch(e){}

    });
  


  


  