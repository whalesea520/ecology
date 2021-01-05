 var DocContentPanel;
 var DocAllPropPanel;
 var DocSetTabPanel;
 var viewport;
 //document.title=wmsg.base.edit+":"+docTitle;
 Ext.onReady(function(){
 		
 		try{	
			onLoad();
		} catch(e){}
		
		var strTable="<table><tr>";
		if (canViewLog) {
			strTable+="<td width='105px'><a onClick='DocAllPropPanel.expand(true);DocSetTabPanel.setActiveTab(\"DocReply\");'><img align='absmiddle' src='/images/docs/reply_wev8.png'>&nbsp;"+wmsg.base.replycount+":<font color='red'  id='fontReply'>0</font></a></td>";
		} else{
			strTable+="<td width='105px'><img align='absmiddle' src='/images/docs/reply_wev8.png'>&nbsp;"+wmsg.base.replycount+":<font color='red'  id='fontReply'>0</font></td>";
		}
	 	//"<td width='96px'><img align='absmiddle' src='/images/docs/read_wev8.png'>&nbsp;"+wmsg.base.readcount+":<font color='red'>"+readCount_int+"</font></td>"+
//		if (canReplay) {
		   strTable+="<td width='100px'><a onClick='DocAllPropPanel.expand(true);DocSetTabPanel.setActiveTab(\"DocImgs\");'><img align='absmiddle' src='/images/docs/acc_wev8.png'>&nbsp;"+wmsg.base.acccount+":<font color='red' id='fontImgAcc'>0</font></a></td>";
//		 }
		   strTable+="<td width='16px'><img align='absmiddle' src='/images/docs/expand_wev8.png'></td>"+
					 "</tr></table> ";
					
	 	var tt = new Ext.Template(
	       '<span style="width:100%;text-align:right;cursor:hand">'+strTable+'</span>'
	    );
	    tt.disableFormats = true;
	    tt.compile();
		
		 Ext.override(Ext.layout.BorderLayout.Region, {	 	
	        toolTemplate:tt
	    });
	    
	    //define DocSetTabPanel
	    DocSetTabPanel = new Ext.TabPanel({
	        id: 'DocAllPanel',
	        border: false,
	        activeTab: 0,
	        tabPosition: 'bottom',
	        items: [DocCommonExt.getDocPropPanel('docPropTable')]
	    });    
		DocSetTabPanel.add(DocCommonExt.getDocImgPanel(maxUploadImageSize,"edit",docid,canEdit,""));	
	    //if (canReplay) {
	    //    DocSetTabPanel.add(DocCommonExt.getDocReplyPanel());
	    //}    
	    DocSetTabPanel.add(new DocShareSnip(docid,canShare).getGrid());    
	    //DocSetTabPanel.add(DocCommonExt.getDocVerPanel());
	    
	    if(canViewLog){	    	
	    	DocSetTabPanel.add(getDocDetailLogPane(docid,500,300,true));
	    }
	    if (canDocMark) {
	        DocSetTabPanel.add(DocCommonExt.getDocMarkPanel());
	    }
	    
	    //define DocAllPropPanel
	    DocAllPropPanel=DocCommonExt.getDocAllPropPanel(isFromWf,DocSetTabPanel);   
	    
	    
	    //define DocContentPanel     	
	    var docTitle="";    
		docTitle="<span  id='spanDocTitle_temp' style='width:400px;visibility:hidden'>&nbsp;<input></span>";
		DocContentPanel=DocCommonExt.getDocContentPanel(docTitle,"divContent",menubar,menubarForwf,isFromWf,"edit");
	
		//define viewport
	    viewport= new Ext.Viewport({
	        layout:'border',
	        items:[ DocContentPanel, DocAllPropPanel ]
	    });	  
		
		try{	
			document.getElementById("divContent").style.display='';
			//document.getElementById("docPropTable").style.display='';	
			document.getElementById('rightMenu').style.visibility="hidden";
			document.getElementById("divMenu").style.display='';	
			document.getElementById("divMark").style.display='';
		} catch(e){}

		Ext.get("divContentTab").on('resize', function() {
			adjustContentHeight("resize");
			if(!isFromWf) DocCommonExt.overTitleInput("resize");
		 });
		 adjustContentHeight("load");
		 if(!isFromWf) {			 
			 DocCommonExt.overTitleInput("load");	
		 } else {
    		try{
	    		Ext.getCmp('dispaly_id').hide();
			}catch(e){}
		 }

		DocCommonExt.finalDo("edit");		
		createTags();// by cyril on 2008-08-14 for td:9077
        
		try{	
			onLoadEnd();
		} catch(e){}

    });
    
     