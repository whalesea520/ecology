function updatecptstockinnum(userid,parentwin){
	try{
		var levelid=594;
		jQuery.ajax({
	            url: "/workflow/request/menuCount.jsp?levelid="+levelid+"&userid="+userid+"&usertype=0&lftmn" + new Date().getTime() + "=",
	            dataType: "json", 
	            contentType : "charset=UTF-8", 
	            error:function(ajaxrequest){
				}, 
	            success:function(content){
	            	try{
						var json = content; 
						for(var key in json){
							jQuery("#"+key,parent.parent.parent.document).html("<span style='padding-left:5px;padding-right:5px;'>"+json[key]+"</span>");
						}
						if(parentwin){
							parentwin.closeDialog();
						}
					}catch(e){
						if(window.console)console.log(e);
					}
				}
		});
	}catch(e){}
};