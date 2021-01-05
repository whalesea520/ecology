var DocAllPropPanel;
var DocSetTabPanel;
var DocContentPanel;

Ext.onReady(function(){
	
	try{	
		onLoad();
	} catch(e){}

	//document.title=wmsg.base.view+":"+docTitle;
	var strTable="<table><tr>";
		
	if (canViewLog) {
		strTable+="<td  style='padding-right:5px'><a onClick='DocAllPropPanel.expand(true);DocSetTabPanel.setActiveTab(\"DocDetailLog\");'><img align='absmiddle' src='/images/docs/read_wev8.png'>&nbsp;"+wmsg.base.readcount+":<font color='red'>"+readCount_int+"</font></a></td>";
	}	else {
		strTable+="<td  style='padding-right:5px'><img align='absmiddle' src='/images/docs/read_wev8.png'>&nbsp;"+wmsg.base.readcount+":<font color='red'>"+readCount_int+"</font></td>";
	}
	
	if (canReplay) {
		strTable+="<td  style='padding-right:5px'><a onClick='DocAllPropPanel.expand(true);DocSetTabPanel.setActiveTab(\"DocReply\");'><img align='absmiddle' src='/images/docs/reply_wev8.png'>&nbsp;"+wmsg.base.replycount+":<font color='red'  id='fontReply'>0</font></a></td>";
	}
	
	
	
	
	strTable+="<td width='100px'><a onClick='DocAllPropPanel.expand(true);DocSetTabPanel.setActiveTab(\"DocImgs\");'><img align='absmiddle' src='/images/docs/acc_wev8.png'>&nbsp;"+wmsg.base.acccount+":<font color='red' id='fontImgAcc'>0</font></a></td>"+
				"<td width='16px'><img align='absmiddle' src='/images/docs/expand_wev8.png'></td>"+
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
        items: [DocCommonExt.getDocPropPanel('divProp')]
    });    
	DocSetTabPanel.add(DocCommonExt.getDocImgPanel(maxUploadImageSize,"view",docid,canEdit,""));	
    if (canReplay) {
        DocSetTabPanel.add(DocCommonExt.getDocReplyPanel());
    }    
    DocSetTabPanel.add(new DocShareSnip(docid,canShare).getGrid());    
    DocSetTabPanel.add(DocCommonExt.getDocVerPanel());
    if(canViewLog){
    	DocSetTabPanel.add(getDocDetailLogPane(docid,500,300,true));
    }
    if (canDocMark) {
        DocSetTabPanel.add(DocCommonExt.getDocMarkPanel());
    }
    
    if(relationable) {
    	DocSetTabPanel.add(new DocRelationable(docid).getGrid()); 
    }
    
    //define DocAllPropPanel
    DocAllPropPanel=DocCommonExt.getDocAllPropPanel(isFromWf,DocSetTabPanel);   
    
    //define DocContentPanel
    if(isPDF&&isPDF==1)
		DocContentPanel=DocCommonExt.getDocPDFContentPanel(docTitle,"divContent",menubar,menubarForwf,isFromWf,"view",pagename,docid,isPDF,canPrint,canEdit,imagefileId);
	else
		DocContentPanel=DocCommonExt.getDocContentPanel(docTitle,"divContent",menubar,menubarForwf,isFromWf,"view",pagename,docid);

	//define viewport
    var viewport= new Ext.Viewport({
        layout:'border',
        items:[ DocContentPanel, DocAllPropPanel ]
    });	  
    
    Ext.get("divContentTab").on('resize', function(){
        adjustContentHeight("resize");
    });
    
    adjustContentHeight("load");
	if(isFromWf) {			 
		try{
			if(isFromWfTH && isFromWfSN){
			  Ext.getCmp('signature_id1').hide();
			  Ext.getCmp('signature_id2').hide();
			}
	    	Ext.getCmp('hide_id').hide();
		} catch(e){}
    }
    
    DocCommonExt.finalDo("view");
    document.getElementById("divContent").style.display = '';
    try {
        document.getElementById("divProp").style.display = '';
        document.getElementById('rightMenu').style.visibility = "hidden";
        document.getElementById("divMenu").style.display = '';
    } 
    catch (e) {
    }
	
    try{	
    	onLoadEnd();
    } catch(e){}
	
  	if(isAutoExtendInfo&&isAutoExtendInfo>0&&accessorycount&&accessorycount>0){
		DocAllPropPanel.expand(true);
		DocSetTabPanel.setActiveTab("DocImgs");  
    }
  
});

