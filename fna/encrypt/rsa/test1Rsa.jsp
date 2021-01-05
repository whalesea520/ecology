<%@page import="weaver.fna.encrypt.Des"%>
<%@page import="weaver.fna.encrypt.RSAUtils"%>
<%@page import="java.security.interfaces.RSAPrivateKey"%>
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
String descrypedPwd = "";
String descrypedPwdDes = "";
try{
	String encrypedPwd = "2b7454e791fdbb2925929c0e1de3320e5f0be04d3aa8fdff692e88c205caef217e00c1d0123fac93bdb2457a3ca3b6b956e0459868122cda2c18c64db6cd1425150cae73aab4b88d9a52ab58e2b69c19a3e95ee053ab48194abc46003f5dcdc66128d9a385f4de2416911e8b95772d9a38e0b35fab307415cd854eb23d19abea 7b320ba8a48ce8341422a2002c28ff605e359033713f1a03694d128fb2ef1698ee7c35fafc3e84094e57cd73397dbde646ad456179dd25995dda1d30449e0c8bc9def9f2fa8db523170e142453263f3dae947fb94305c3dd8cf330737a8b1c18fcc52eec1d5454a103c96b896e3ac863e53a4076daf7ae9e854b021f167da757 311ccceabc80845ff12ae70966976a99fe280e1d7cb0af6108716fe1a33233bbb958dcd7c5e30674b2177794afd0a4bf4f87191f7822cd4a0b503f67f68c56a6d4a98dcaecc0ac1ffdc328831941a6e68b415a63a48c54ee8796c48bd41476e39300551129db9c7c36cefeeb7827c90f21fd85fd7f9153cf99d42aad7aa888c5 0afe00ece3a6d26d11f68fd95233872a5102268b0aa9763949a03ef9ced2db996eefcafe0dc0d85e799de5f10824767961bbbae56f99cfc57053f43039e769ef76d307ab86e2b7d7bf7f5fcc59c366401cf8b12973283db260799d27d5c443fe0b721dacf0c90f3562d06cc02c40096d96b5912ec8c6ebf1faf9b6004b7c6955 306d821d614c022fab6e450a20397186ddddb5d53de356bc435655cf74bf02647ad47c8bc24756004e7356279460b163b11e759b8d1df19f54991263a789cc433318804c69718c69d755b5dacbbe229fd628ffcd8c67938b4eae9d07cacfccb744f54ef71fdaee9b2ce2dddca0928f86030f1644f6832b9487951ece9159dc28 037f3526ffc3e1e6ed85bf48e1907c18b1743de7e74c2bb12ee75816d5bccf9ca9ddd3d310ad39b89a24bdd8912b0aff9525b8c1ac9a64a0a59c509ff41931ac3145ed0fc927111a70c896f45900e2ecde868d0068f9f7a019d22d27bbcc9e4019940eba0e5522f9fd279f1c16f12420e09be0e8c8fd7cb31a507ccce48fc0e2 ";
	String[] encrypedPwdArray = encrypedPwd.trim().split(" ");
	int encrypedPwdArrayLen = encrypedPwdArray.length;
	out.println("encrypedPwdArrayLen="+encrypedPwdArrayLen+"<br>");
	
	for(int i=0;i<encrypedPwdArrayLen;i++){
		String _str = Util.null2String(encrypedPwdArray[i]).trim();
		out.println("encrypedPwdArray["+i+"]="+_str+"<br>");
		String _descrypedPwd = "";
		if(!"".equals(_str)){
			_descrypedPwd = RSAUtils.decryptStringByJs(_str); //解密后的密码,password是提交过来的密码
		}
		descrypedPwd += _descrypedPwd;
		out.println("_descrypedPwd="+_descrypedPwd+"<br>");
	}
	
	Des desObj = new Des();
	descrypedPwdDes = desObj.strDec(descrypedPwd, Des.KEY1, Des.KEY2, Des.KEY3);
}catch(Exception e){
	out.println(e);
}

%>
<!DOCTYPE unspecified PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head></head>
<body>
<%=descrypedPwd %><br />
<%=descrypedPwdDes %><br />
</body>
</html>