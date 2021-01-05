
function highEditor(remarkid,height){
	    height=!height||height<150?150:height;
	    
	    if(jQuery("#"+remarkid).is(":visible")){
			
			var  items=[
							'justifyleft', 'justifycenter', 'justifyright','forecolor','bold','italic','fullscreen'
					   ];
				 
			 K.createEditor({
					id : remarkid,
					height :height+'px',
					themeType:'mobile',
					resizeType:1,
					uploadJson:'/weaverEditor/jsp/upload_json.jsp',
				    allowFileManager : false,
	                newlineTag:'br',
	                filterMode:false,
					imageTabIndex:1,
					langType : 'en',
	                items : items,
				    afterCreate : function(id) {
						//KE.util.focus(id);
						this.focus();
				    }
	   		});
		}
	}

function isShowEditor(){
	if(clienttype=="android"||clienttype=="androidpad"){
	clientVersion=mobileInterface.getClientVersion();
	}
	if(!((clienttype=="android"||clienttype=="androidpad")&&clientVersion<16))
		return true;
	else
		return false;
}
