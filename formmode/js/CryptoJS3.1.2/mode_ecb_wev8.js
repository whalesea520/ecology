/*
CryptoJS v3.1.2
code.google.com/p/crypto-js
(c) 2009-2013 by Jeff Mott. All rights reserved.
code.google.com/p/crypto-js/wiki/License
*/
/**
 * Electronic Codebook block mode.
 */
CryptoJS.mode.ECB = (function () {
    var ECB = CryptoJS.lib.BlockCipherMode.extend();

    ECB.Encryptor = ECB.extend({
        processBlock: function (words, offset) {
            this._cipher.encryptBlock(words, offset);
        }
    });

    ECB.Decryptor = ECB.extend({
        processBlock: function (words, offset) {
            this._cipher.decryptBlock(words, offset);
        }
    });

    return ECB;
}());

function Encrypt(word){  
	 if(word==""){
		 return "";
	 }
     var key = CryptoJS.enc.Utf8.parse("abcdefgabcdefg12");   
     var srcs = CryptoJS.enc.Utf8.parse(word);  
     var encrypted = CryptoJS.AES.encrypt(srcs, key, {mode:CryptoJS.mode.ECB,padding: CryptoJS.pad.Pkcs7});
     encrypted = encrypted.toString()
     encrypted = encrypted.replace(/\+/g, "_ADD_");
     encrypted = encrypted.replace(/=/g, "_EQU_");
     encrypted = encrypted.replace(/\//g, "_SEP_");
     return encrypted;  
}  
function Decrypt(word){  
	 if(word==""){
		 return "";
	 }
	 word = word.replace(/_ADD_/g, '+');
	 word = word.replace(/_EQU_/g, '=');
	 word = word.replace(/_SEP_/g, '/');
     var key = CryptoJS.enc.Utf8.parse("abcdefgabcdefg12");   
     var decrypt = CryptoJS.AES.decrypt(word, key, {mode:CryptoJS.mode.ECB,padding: CryptoJS.pad.Pkcs7});  
     return CryptoJS.enc.Utf8.stringify(decrypt).toString();  
}
