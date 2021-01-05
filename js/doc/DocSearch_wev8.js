var viewport;
var mainPanel;
var grid;
var sqlwhere;
var ishidden = false;
try
{
	var isinit = document.getElementById("isinit").value;
	if(isinit=="true")
	{
		ishidden = true;
	}
}
catch(e)
{
}
Ext.onReady(function(){
	/*var itemds=[];
	if(displayUsage==1){ //缩略图
		itemds=[{title:wmsg.doc.docList,contentEl:'divContent',autoScroll: true} ];
	} else{
		itemds=[{title:wmsg.doc.docList,contentEl:'divContent',autoScroll: true} ];
	}
	
	mainPanel=new Ext.Panel({		
		activeTab: 0,
        region: 'center',
        margins: '0 8 5 5',
        layout:'fit',
        border:false,
        resizeTabs: true,
        tabWidth: 150,
        minTabWidth: 120,
        enableTabScroll: true,
        plugins: new Ext.ux.TabCloseMenu(),       
        items: itemds
	});
	
		viewport = new Ext.Viewport({
        layout: 'border',
        items: [ panelTitle, mainPanel]
    
    });*/
    Ext.get('loading').fadeOut();
    //if(displayUsage!=1){
    	//search();
    //}
   
});
/*
function loadGrid(params,url){
	if(url.indexOf("?")==-1){
		url = url+"?"+params;
	}else{
		url = url+"&"+params;
	}
	
	Ext.Ajax.request({
					url : url, 
					params : {
								 paras: params,
								 columns:Ext.util.JSON.encode(tableJson.TableBaseParas.columns)
							 },
					method: 'POST',
					success: function ( result, request) {					
						eval(result.responseText.trim());
						//tableJson.TableBaseParas.sqlwhere = sqlInfo.where;
						
						//sqlwhere = sqlInfo.where;
						//tableJson.TableBaseParas.sort = sqlInfo.orderby;
						//tableJson.TableBaseParas.pageSize = sqlInfo.pagesize;
						//tableJson.TableBaseParas.sqlform = sqlInfo.from;
						//tableJson.TableBaseParas.sqlprimarykey = sqlInfo.primarykey;
						
						tableJson.TableBaseParas.sessionId=sqlInfo.sessionId;
						//alert(tableJson.TableBaseParas.sessionId)
						
						if(document.getElementById('noRightCount')!=null){
					    	document.getElementById('noRightCount').innerHTML=sqlInfo.noRightCount;
					    }
						grid.store.baseParams={
				    		paras: params,
							TableBaseParas : Ext.util.JSON.encode(tableJson.TableBaseParas)			
						};						
						
						grid.store.reload({
							params : {
								start:0,
								limit:tableJson.TableBaseParas.pageSize
							}
						});												
					},
					failure: function ( result, request) { 
						Ext.MessageBox.alert('Failed', 'Successfully posted form: '+result); 
					} 
				});	
								
}
*/


