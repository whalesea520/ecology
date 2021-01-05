var mainComboBox;
var subComboBox;
var secComboBox;

function ComboBoxExtProxy()
{
	var url='/docs/search/ext/ComboBoxExtProxy.jsp';
	
	var mainStore = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			method:'POST',
			url:url+'?type=main'
		}),
		reader: new Ext.data.JsonReader({
			root:'row',
			id:'mainStoreReader'
		},[
			{name:'name',mapping:'name'},
		   	{name:'value',mapping:'value'}
		])		
	});
	
	
	var subStore = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			method:'POST',
			url:url+'?type=sub'
		}),
		reader: new Ext.data.JsonReader({
			root:'row',
			id:'subStoreReader'
		},[
			{name:'name',mapping:'name'},
		   	{name:'value',mapping:'value'},
		   	{name:'main',mapping:'main'}
		])		
	});
	
	var secStore = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			method:'POST',
			url:url+'?type=sec'
		}),
		reader: new Ext.data.JsonReader({
			root:'row',
			id:'secStoreReader'
		},[
			{name:'name',mapping:'name'},
		   	{name:'value',mapping:'value'},
	   	 	{name:'main',mapping:'main'},
		 	{name:'sub',mapping:'sub'},
		 	{name:'isUsedCustomSearch',mapping:'isUsedCustomSearch'}
		])		
	});
	
    secComboBox = new Ext.form.ComboBox({
		
		store:secStore,
		mode:'local',
		valueField:'value',
		displayField:'name',
		triggerAction: 'all',
		emptyText:'---',
		cls:'InputStyle',
		transform:'seccategory',
		lastQuery:'',
		editable: false,
		width:146,
		listeners:{
		       	'select': function(combo,record,index){
					seccategoryid =record.get('value');
		     		if(record.get('isUsedCustomSearch')=='true'){
		     			isNeedSubmit = true;
		     			isUsedCustomSearch = "true";
		     			document.frmmain.isUsedCustomSearch.value="true";
						document.frmmain.seccategoryid.value = seccategoryid;
						setCustomSearch();
		     		}else{
		     			if(isUsedCustomSearch=="true"){
		     				isNeedSubmit = true;
		     			}else{
		     				isNeedSubmit = false;
		     			}
		     			document.frmmain.isUsedCustomSearch.value="false";
						document.frmmain.seccategoryid.value = "";
		     			isUsedCustomSearch = "false";
		     			setCustomSearch();
		     		}
				},
			       expand:  function () {
		            this .list.setWidth( this .width);
		            this.innerList.setWidth(this.width);
		       }
		}
	});
	
	subComboBox = new Ext.form.ComboBox({
		store:subStore,
		mode:'local',
		valueField:'value',
		displayField:'name',
		triggerAction: 'all',
		emptyText:'---',
		cls:'InputStyle',
		transform:'subcategory',
		lastQuery:'',
		editable: false,
		width:'165',
		listeners:{
		       	'select': function(combo,record,index){
					subcategoryid = record.get('value');
					if(subcategoryid=='0'){
						secStore.clearFilter();
					}else{
						//secStore.clearFilter();
			       		secStore.filter('sub',subcategoryid);
						secStore.filterBy(
		       				function(record,id){
		       					if(record.get('sub') == subcategoryid){
		       						return true;
		       					}
		       					else return false;
		       			});
					}
		       		secComboBox.clearValue();
		       		seccategoryid = '0';
		       		setCustomSearch();
		       },
		       expand:  function () {
                   this.list.setWidth( this.width);
                   this.innerList.setWidth(this.width);
              }
		}
	});
	
	mainComboBox = new Ext.form.ComboBox({
		store:mainStore,
		mode:'local',
		valueField:'value',
		displayField:'name',
		triggerAction: 'all',
		queryParam:'name',
		emptyText:'---',
		transform:'maincategory',
		typeAhead: true,
		editable: false,
	    triggerAction: 'all',
		lastQuery:'',
		width:'165',
		height:50,
		listeners:{
		       	'select': function(combo,record,index){
		       		maincategoryid = record.get('value');
		       		if(maincategoryid=='0'){
		       			subStore.clearFilter();
		       			secStore.clearFilter();       			
		       			
		       		}else{
			       		//subStore.filter('main',maincategoryid);  
			       		//secStore.filter('main',maincategoryid); 		
		       			subStore.filterBy(
		       				function(record,id){
		       					if(record.get('main') == maincategoryid){
		       						return true;
		       					}
		       					else return false;
		       			});
						secStore.filterBy(
		       				function(record,id){
		       					if(record.get('main') == maincategoryid){
		       						return true;
		       					}
		       					else return false;
		       			});
		       		}
		       		subComboBox.clearValue();
		       		secComboBox.clearValue();
		       		subcategoryid = '0';
		       		seccategoryid = '0';
		       		setCustomSearch();
		       },
		       expand:  function () {
		    	  
                   this.list.setWidth(this.width);
		    	   this.innerList.setWidth(this.width);
              }
		}
		
	});
	
	
	secStore.load({
		callback: function(r,options,success){
			if(success==false){
				//Ext.Msg.alert("ERROR"," There was an error parsing the Seccategory Combo.")
			}else{
				secComboBox.setValue(seccategoryid);
				
				if(subcategoryid!='0'){
					secStore.filterBy(
		       				function(record,id){
		       					if(record.get('sub') == subcategoryid){
		       						
		       						return true;
		       					}
		       					else return false;
		       		});	
				}
				if(maincategoryid!='0'){
					secStore.filterBy(
		       				function(record,id){
		       					if(record.get('main') == maincategoryid){
		       						
		       						return true;
		       					}
		       					else return false;
		       		});
				}
				setCustomSearch();
						
					
			}
		}
	});
	
	subStore.load({
		callback : function(r, options, success) {  
	          if (success == false) {  
	               //Ext.Msg.alert("ERROR",   "There was an error parsing the Country Combo."); 
	          } 
	          else{ 
	          	
			  	 	subComboBox.setValue(subcategoryid);
					if(subcategoryid=='0'){
		       			secStore.clearFilter();       			
		       		}else{
		       			
		       			//secStore.filter('sub',subcategoryid);		
						secStore.filterBy(
		       				function(record,id){
		       					if(record.get('sub') == subcategoryid){
		       						
		       						return true;
		       					}
		       					else return false;
		       			});
	    	   		}
	          }  
	      }  
	});
	
	mainStore.load({
		callback : function(r, options, success) {  
	          if (success == false) {  
	               //Ext.Msg.alert("ERROR",   "There was an error parsing the Maincategory Combo."); 
	          } 
	          else{ 
	          	
	           mainComboBox.setValue(maincategoryid);
	           if(maincategoryid=='0'){
		       			subStore.clearFilter();
		       			//secStore.clearFilter();       			
		       			
	       		}else{
		       		//subStore.filter('main', maincategoryid);  
		       		//secStore.filter('main',maincategoryid); 		
					subStore.filterBy(
		       				function(record,id){
		       					if(record.get('main') == maincategoryid){
		       						return true;
		       					}
		       					else return false;
		       		});
					
	       		}
	          }  
	      }  
	
	});
	
	

	var docstatus = new Ext.form.ComboBox({
		mode:'local',
		
		triggerAction: 'all',
		
		transform:'docstatus',
		typeAhead: true,
	    triggerAction: 'all',
	    editable: false,
		lastQuery:'',
		width:146,
		listeners:{
		 expand: function () {
			        this .list.setWidth( this .width);
			        this.innerList.setWidth(this.width);
			    }
		
		}
	      
	});
	
	var dspreply = new Ext.form.ComboBox({
		mode:'local',
		
		triggerAction: 'all',
		
		transform:'dspreply',
		typeAhead: true,
	    triggerAction: 'all',
	    editable: false,
		lastQuery:'',
		width:146,
		listeners:{
		 expand: function () {
			        this .list.setWidth( this .width);
			        this.innerList.setWidth(this.width);
			    }
		
		}
	});
	
	
	var docpublishtype = new Ext.form.ComboBox({
		mode:'local',
		
		triggerAction: 'all',
		
		transform:'docpublishtype',
		typeAhead: true,
	    triggerAction: 'all',
	    editable: false,
		lastQuery:'',
		width:146,
		listeners:{
		 expand: function () {
			        this .list.setWidth( this .width);
			        this.innerList.setWidth(this.width);
			    }
		
		}
	});
	
	function setCustomSearch(){
		var message_Div = document.createElement("div");
		

		var obj; 
		var content;
	    if (window.ActiveXObject) { 
	        obj = new ActiveXObject('Microsoft.XMLHTTP'); 
	    } 
	    else if (window.XMLHttpRequest) { 
	        obj = new XMLHttpRequest(); 
	    } 
		obj.open('GET', '/docs/search/ext/CustomFieldExtProxy.jsp?seccategory='+seccategoryid, false); 
	    obj.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded'); 
	    obj.send(null); 
	    if (obj.status == "200") {
	    	content =  obj.responseText.trim();
		} else {
		}		
		
		var customSearchDiv  = document.getElementById("customSearchDiv");
			customSearchDiv.innerHTML=''
			
		//var searchPanel = panelTitle.findById('searchPanel');
	
			if(content!='0'){
				var strArry = content.split('</table>')
				customSearchDiv.innerHTML=strArry[0]+"</table>"
				rowCount =strArry[1]-0+2;
				//alert(rowCount);
				if(document.getElementById("advicedSearchDiv").style.display=='none'){
					customSearch = true;
				}else{
					customSearch = true;
					/*_divSearchDivHeight = baseDiv+baseRow*rowCount;
					if(basePanel+baseRow*rowCount<450){
						
						searchPanel.setHeight(5+basePanel+baseRow*rowCount);
						if(userightmenu_self!=1){
							searchPanel.setHeight(5+basePanel+baseRow*rowCount-25);
						}else{
							searchPanel.setHeight(5+basePanel+baseRow*rowCount);
						}
						panelTitle.setHeight(5+baseDiv+baseRow*rowCount);
					}else{
						_divSearchDivHeight = 450;
						if(userightmenu_self!=1){
							searchPanel.setHeight(410-25);
						}else{
							searchPanel.setHeight(410);
						}
						panelTitle.setHeight(450);
					}*/
				
					/*//searchPanel.doLayout();
					//panelTitle.doLayout();
					viewport.doLayout();*/
				}
			}else{
				if(document.getElementById("advicedSearchDiv").style.display=='none'){
					customSearch = false;
				}else{
					customSearch = false;
					/*_divSearchDivHeight = 400;
					if(userightmenu_self!=1){
						searchPanel.setHeight(360-25);
					}else{
						searchPanel.setHeight(360);
					}
					panelTitle.setHeight(400);
					searchPanel.doLayout();
					panelTitle.doLayout();
					viewport.doLayout();*/
				}
				
				
			}
	}
}
	
