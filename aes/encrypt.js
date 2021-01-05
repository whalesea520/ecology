var __AESEcrypt__ = (function(){
	 return (function(){
		 var AES_01 = null;
		 var AES_02 = null;
		 var RSA_AES_01 = null;
		 var RSA_AES_02 = null;
		 var RSA_PUB = null;
		 var RSA_CODE = null;
		 return {
			 aes_data_encrypt:function(value){
				    if(!value)return value;
					var  aes_check_data = function(value,aes_01, aes_02){
						if(!aes_01 || !aes_02){
							alert("发生错误");
							return false;
						}
						return true;
					}
					var checkResult = aes_check_data(value,AES_01,AES_02);
					if(checkResult){
						var key = CryptoJS.enc.Utf8.parse(AES_01);  
						var iv = CryptoJS.enc.Utf8.parse(AES_02);  
						 var encryptedData = CryptoJS.AES.encrypt(value, key, {iv:iv,mode:CryptoJS.mode.CBC,padding:CryptoJS.pad.ZeroPadding}).toString();
						return encryptedData;
					}
					return value;
				},
			get_rsa_aes_01: function(){
				return RSA_AES_01;
			},
			
			get_rsa_aes_02: function(){
				return RSA_AES_02;
			},
				
			aes_data_decrypt:function(value){
				    if(!value)return value;
					var  aes_check_data = function(value,aes_01, aes_02){
						if(!aes_01 || !aes_02){
							alert("发生错误");
							return false;
						}
						return true;
					}
					var checkResult = aes_check_data(value,AES_01,AES_02);
					if(checkResult){
						var key = CryptoJS.enc.Utf8.parse(AES_01);  
						var iv = CryptoJS.enc.Utf8.parse(AES_02);  
						var decryptedData = CryptoJS.AES.decrypt(value, key, {iv:iv,mode:CryptoJS.mode.CBC,padding:CryptoJS.pad.ZeroPadding}).toString();
						var prePro = function(data){
							if (data.length % 2) return '';
							var tmp='';
							for(i=0;i<data.length;i+=2)
							{
								tmp += '%' + data.charAt(i) + data.charAt(i+1);
							}
							return decodeURI(tmp);
						}
						var decryptedStr = prePro(decryptedData.toString(CryptoJS.enc.Utf8)); 
						return decryptedStr;
					}
					return value;
				},

		 	aes_encrypt:function(callback){
				__RSAEcrypt__.initAESCode(callback);
			},
			initAESCode:function(callback){
				if(AES_01 && AES_02){
					if(callback){
						callback();
					}
				}else{
					jQuery.ajax({
						url:"/rsa/weaver.rsa.GetRsaInfo?ts="+new Date().getTime(),
						type:"post",
						dataType:"json",
						success:function(data){
							RSA_PUB = data.rsa_pub;
							//初始化的时候生成好密钥和向量
							var uuid = function() {
								function S4() {
								   return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
								}
								return (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4()).substr(0,16);
							}
							AES_01 = uuid();
							AES_02 = uuid();
							//对密钥进行RSA加密处理
							var encrypt = new JSEncrypt();
							encrypt.setPublicKey(RSA_PUB);
							RSA_AES_01= encrypt.encrypt(AES_01);
							RSA_AES_02= encrypt.encrypt(AES_02);
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
	__AESEcrypt__.initAESCode();
});