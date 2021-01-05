var __RSAEcrypt__ = (function(){
	 return (function(){
		 var RSA_CODE = null;
		 var RSA_PUB = null;
		 var RSA_FLAG = null;
		 return {
			 rsa_data_encrypt:function(value){
					var  rsa_check_data = function(value,rsa_pub){
						if(!value){
							alert("值不能为空！")
							return false;
						}else if(!rsa_pub){
							alert("公钥不能为空！请重新获取公钥！");
							return false;
						}
						return true;
					}
					var checkResult = rsa_check_data(value,RSA_PUB);
						if(checkResult){
							var encrypt = new JSEncrypt();
							encrypt.setPublicKey(RSA_PUB);
							if(!RSA_CODE)RSA_CODE = "";
							var data = encrypt.encrypt(value+RSA_CODE)+RSA_FLAG;
							return data;
						}
						return value;
				},
		 	rsa_encrypt:function(callback){
				__RSAEcrypt__.initRsaCode(callback);
			},
			initRsaCode:function(callback){
				if(RSA_CODE){
					if(callback){
						callback();
					}
				}else{
					jQuery.ajax({
						url:"/rsa/weaver.rsa.GetRsaInfo?ts="+new Date().getTime(),
						type:"post",
						dataType:"json",
						success:function(data){
							RSA_CODE = data.rsa_code;
							RSA_PUB = data.rsa_pub;
							RSA_FLAG = data.rsa_flag;
							if(callback){
								callback();
							}
						}
					});
				}
			}
		 }
	 })();
})();

jQuery(document).ready(function(){
	__RSAEcrypt__.initRsaCode();
});