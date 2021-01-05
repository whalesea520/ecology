
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.file.*,javax.servlet.jsp.JspWriter" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.file.multipart.*" %>
<%@ page import="org.bouncycastle.crypto.BufferedBlockCipher" %>
<%@ page import="org.bouncycastle.crypto.paddings.PaddedBufferedBlockCipher" %>
<%@ page import="org.bouncycastle.crypto.modes.CBCBlockCipher" %>
<%@ page import="org.bouncycastle.crypto.engines.AESFastEngine" %>
<%@ page import="org.bouncycastle.crypto.params.ParametersWithIV" %>
<%@ page import="org.bouncycastle.util.encoders.Hex" %>
<%@ page import="org.bouncycastle.crypto.params.KeyParameter" %>

<%!
	/**
	* 将一个输入流转化为字符串
	*/
	public String getStreamString(InputStream tInputStream){
		if (tInputStream != null){
			try{
				BufferedReader tBufferedReader = new BufferedReader(new InputStreamReader(tInputStream));
				StringBuffer tStringBuffer = new StringBuffer();
				String sTempOneLine = new String("");
				while ((sTempOneLine = tBufferedReader.readLine()) != null){
					tStringBuffer.append(sTempOneLine);
				}
				return tStringBuffer.toString();
			}catch (Exception ex){
				ex.printStackTrace();
			}
		}
		return null;
	}
	static byte[] keybytes = "WEAVER E-DESIGN.".getBytes();
	static byte[] iv = "weaver e-design.".getBytes();
	/**
	 * 解密字符串
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
	int modeid = Util.getIntValue(request.getParameter("modeid"), 0);
	int formid = Util.getIntValue(request.getParameter("formid"), 0);
	int layouttype = Util.getIntValue(request.getParameter("layouttype"), -1);
	
	int layoutid = Util.getIntValue(request.getParameter("layoutid"), 0);
	int isform = Util.getIntValue(request.getParameter("isform"), 0);
	int isdefault = Util.getIntValue(request.getParameter("isdefault"), 0);
	String tStringBuffer = "";
	try{
		MultipartParser mp = new MultipartParser(request, request.getContentLength()); 
		boolean isMultipartData = Util.null2String(request.getContentType()).toLowerCase().startsWith("multipart/form-data");
		if(!isMultipartData) return ;
		Part part;
		while ((part = mp.readNextPart()) != null) { 
			if (part.isParam()) { 
				ParamPart paramPart = (ParamPart) part; 
				if(paramPart.getName().equals("modeid"))modeid = Util.getIntValue(paramPart.getStringValue(),0);
				else if(paramPart.getName().equals("formid")) formid = Util.getIntValue(paramPart.getStringValue(),0);
				else if(paramPart.getName().equals("layouttype")) layouttype = Util.getIntValue(paramPart.getStringValue(),0);
				else if(paramPart.getName().equals("layoutid"))layoutid = Util.getIntValue(paramPart.getStringValue(),0);
				else if(paramPart.getName().equals("isform")) isform = Util.getIntValue(paramPart.getStringValue(),0);
				else if(paramPart.getName().equals("isdefault")) isdefault = Util.getIntValue(paramPart.getStringValue(),0);
			}
			else if (part.isFile()) { 
				FilePart filePart = (FilePart) part; 
		        InputStream is = filePart.getInputStream(); 
		        
		        tStringBuffer = getStreamString(is);
		        tStringBuffer = decode(tStringBuffer);
		        is.close();
			}
		}
	}catch(Exception ex){
		ex.printStackTrace();
	}
	

%>
<html>
<head>
<script type="text/javascript">
	var dialog;
	var parentWin;
	
	jQuery(document).ready(function(){
		dialog = window.top.getDialog(window);
		parentWin = parent.getParentWindow(window);
		parentWin.formOperate.importTemplateFace(jQuery("#importJson").html(), "impTemplate");
		dialog.close();
	});
</script>
</head>
<body>
	<textarea id="importJson" name="importJson" style="display:none"><%=tStringBuffer %></textarea>
</body>
</html>