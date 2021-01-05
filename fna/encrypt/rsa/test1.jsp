<%@page import="org.apache.commons.codec.binary.Hex"%>
<%@page import="weaver.fna.encrypt.Des"%>
<%@page import="java.security.interfaces.RSAPrivateKey"%>
<%@page import="java.security.interfaces.RSAPublicKey"%>
<%@page import="weaver.fna.encrypt.RSAUtils"%>
<%@page import="java.util.HashMap"%>
<%@page import="weaver.workflow.request.RequestManager"%>
<%@page import="weaver.soa.workflow.request.RequestInfo"%>
<%@page import="weaver.soa.workflow.request.RequestService"%>
<%@page import="weaver.cpt.job.CptLowInventoryRemindJob"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="weaver.systeminfo.language.LanguageComInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<% 
if(true){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>

<HTML>
<head>
<script type="text/javascript" src="/fna/encrypt/des/des_wev8.js"></script>
<script src="/fna/encrypt/rsa/security_wev8.js" type="text/javascript"></script>
<script type="text/javascript">
	<%
	    RSAPublicKey publicKey = RSAUtils.getDefaultPublicKey();
		String modulus = new String(Hex.encodeHex(publicKey.getModulus().toByteArray()));
        String exponent = new String(Hex.encodeHex(publicKey.getPublicExponent().toByteArray()));
	%>
	function doEncryptRsa(str, key1, key2, key3){
		var encrypedPwd = "";
		var pwd = jQuery("#pwd").val();
		//第一个参数必须；第二个、第三个参数可选
		var key1 = "<%=Des.KEY1 %>";  
		var key2 = "<%=Des.KEY2 %>";
		var key3 = "<%=Des.KEY3 %>";
		//加密方法		
		var pwdDes = strEnc(pwd,key1,key2,key3);
		encrypedPwd = doEncryptRsa1(pwdDes);

		jQuery("#pwdDes").val(pwdDes);
		jQuery("#encrypedPwd").val(encrypedPwd);
	}
	function _doEncryptRsa1(str){
		var publicKeyExponent = "<%=exponent %>";
		var publicKeyModulus = "<%=modulus %>";
		
		RSAUtils.setMaxDigits(200);
		var key = new RSAUtils.getKeyPair(publicKeyExponent, "", publicKeyModulus);
		
		return RSAUtils.encryptedString(key,str);
	}
    </script>
</head>

<BODY>
<input id="pwd" name="pwd" value="" style="width: 100%" /><br />
<input value="jiami" onclick="doEncryptRsa();" type="button" /><br />
<input id="pwdDes" name="pwdDes" value="" style="width: 100%" /><br />
<input id="encrypedPwd" name="encrypedPwd" value="" style="width: 100%" /><br />
</BODY>
</HTML>