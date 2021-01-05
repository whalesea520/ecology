/**
 * 系统安全验证加密
 * @param content
 * @returns
 */
function $m_encrypt(content, unEncodeWhenFirewallDisabled){
	if(typeof(unEncodeWhenFirewallDisabled) == "undefined"){
		unEncodeWhenFirewallDisabled = false;
	}
	
	var url = jionActionUrl("com.weaver.formmodel.mobile.security.EDAction", "action=encrypt&content="+encodeURIComponent(content));
	$.ajax({
	    url: url,
	    data: {"unEncodeWhenFirewallDisabled":unEncodeWhenFirewallDisabled},
	    async: false,
	    cache: false,
	    dataType: 'json',
	    type: 'get',
	    success: function (res) {
	    	content = res["content"];
	    	if(!content){
	    		content = "";
	    		var msg = res["msg"];
	    		if(msg && msg != ""){
	    			alert(msg);
	    		}
	    	}
	    },
	    error: function(res){
	    	//alert("error");
	    }
	});
	return content;
}