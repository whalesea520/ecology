function getTabPanel(arrTab_tem){
	var arrTab_new= new Array();
	for (var i=0;i<arrTab_tem.length;i++){
		var jsonTab=arrTab_tem[i];	
		if(!(jsonTab.url=="" || jsonTab.url==null || jsonTab.url=="undefind")){
			jsonTab.isFirstAccess="true";
			jsonTab.listeners={
				activate:function(p){
					if(p.isFirstAccess=="true"||(p.id=='crmContract'||p.id=='crmExchange')){						
						//需要设置IFRAME的值
						try{
							if(p.isFirstAccess=="true"){
								var divObj=p.getEl().dom.firstChild.firstChild.firstChild;
								var strIfrm="<IFRAME src='"+divObj.innerHTML+"' style='width:100%;height:100%' " +
										" BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE scrolling='auto'></IFRAME>";
								divObj.innerHTML=strIfrm;
							}else{
								var divObj=p.getEl().dom.firstChild.firstChild.firstChild;
								var arrIfrm=divObj.getElementsByTagName("IFRAME");
								if(arrIfrm.length>0){
									arrIfrm[0].src=arrIfrm[0].src;	
								}	
							}
							p.isFirstAccess="false";
						} catch(e){	}
					} 					
				}
			};	
			
			if(jsonTab.url.indexOf('?')!=-1){

				jsonTab.html="<div id='divIfrm'>"+jsonTab.url+"&isfromtab=true'</div>";
			}else{
			
				jsonTab.html="<div id='divIfrm'>"+jsonTab.url+"?isfromtab=true'</div>";
			}
		}
		
		arrTab_new.push(jsonTab);
	}
	return  {
		id:'crmtabpanel',
		xtype:'tabpanel',
		region : 'center',
		border : true,
		enableTabScroll: true, 
		activeTab:0,
		margins : '0 8 5 5',
		items : arrTab_new
	};
}
Ext.onReady(function(){	
	var viewport = new Ext.Viewport({
		layout : 'border',
		items : [panelTitle, getTabPanel(arrOtherTab)]
	});
	Ext.get('loading').fadeOut();
	
});
