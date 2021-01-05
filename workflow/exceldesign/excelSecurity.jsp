
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="org.bouncycastle.crypto.BufferedBlockCipher" %>
<%@ page import="org.bouncycastle.crypto.paddings.PaddedBufferedBlockCipher" %>
<%@ page import="org.bouncycastle.crypto.modes.CBCBlockCipher" %>
<%@ page import="org.bouncycastle.crypto.engines.AESFastEngine" %>
<%@ page import="org.bouncycastle.crypto.params.ParametersWithIV" %>
<%@ page import="org.bouncycastle.util.encoders.Hex" %>
<%@ page import="org.bouncycastle.crypto.params.KeyParameter" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%!
static byte[] keybytes = "WEAVER E-DESIGN.".getBytes();
static byte[] iv = "weaver e-design.".getBytes();

/**
 *为字符串加密
 * 
 * @param content
 * @return
 */
public String encode(String content) {
	try {
		BufferedBlockCipher engine = new PaddedBufferedBlockCipher(
				new CBCBlockCipher(new AESFastEngine()));
		engine.init(true, new ParametersWithIV(new KeyParameter(keybytes),
				iv));
		byte[] enc = new byte[engine
				.getOutputSize(content.getBytes().length)];
		int size1 = engine.processBytes(content.getBytes(), 0, content
				.getBytes().length, enc, 0);
		int size2 = engine.doFinal(enc, size1);
		byte[] encryptedContent = new byte[size1 + size2];
		System.arraycopy(enc, 0, encryptedContent, 0,
				encryptedContent.length);
		return new String(Hex.encode(encryptedContent));
	} catch (Exception ex) {
		ex.printStackTrace();
	}
	return "";
}

/**
 * 为字符串解密
 * 
 * @param content
 * @return
 */
public String decode(String content) {
	try {
		BufferedBlockCipher engine = new PaddedBufferedBlockCipher(
				new CBCBlockCipher(new AESFastEngine()));
		engine.init(true, new ParametersWithIV(new KeyParameter(keybytes),
				iv));
		byte[] deByte = Hex.decode(content);
		engine.init(false, new ParametersWithIV(new KeyParameter(keybytes),
				iv));
		byte[] dec = new byte[engine.getOutputSize(deByte.length)];
		int size1 = engine.processBytes(deByte, 0, deByte.length, dec, 0);
		int size2 = engine.doFinal(dec, size1);
		byte[] decryptedContent = new byte[size1 + size2];
		System.arraycopy(dec, 0, decryptedContent, 0,
				decryptedContent.length);
		return new String(decryptedContent);
	} catch (Exception ex) {
		ex.printStackTrace();
	}
	return "";
}
%>
<%
	//设置response
	response.setContentType("text/html;charset=utf-8");
	String str1 = Util.null2String(request.getParameter("str1"));
	String type = Util.null2String(request.getParameter("securitype"));
	if(type.equals("encode"))
		str1 = encode(str1);
	else
		str1 = decode(str1);
	out.clear();
	out.println(str1);
%>