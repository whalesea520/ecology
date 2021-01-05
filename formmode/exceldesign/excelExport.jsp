<%@ page language="java" contentType="application/x-download; charset=UTF-8"%>
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
<%@ page import="weaver.formmode.exceldesign.HtmlLayoutOperate"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%!
static byte[] keybytes = "WEAVER E-DESIGN.".getBytes();
static byte[] iv = "weaver e-design.".getBytes();

/**
 * 为字符串加密
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
%>
<%
	int layoutid = Util.getIntValue(request.getParameter("layoutid"), 0);
	int modeid = Util.getIntValue(request.getParameter("modeid"),0);
	int layouttype = Util.getIntValue(request.getParameter("layouttype"),0);
	int languageid = Util.getIntValue(request.getParameter("languageid"), 0);
	String layoutname = "";
	if(layoutid<=0){
		HtmlLayoutOperate htmlLayoutOperate = new HtmlLayoutOperate();
		layoutname = htmlLayoutOperate.getLayoutName(modeid, layouttype,languageid);
	}else{
		String layoutnamesql = "select layoutname from modehtmllayout where id ="+layoutid;
		RecordSet.executeSql(layoutnamesql);
		if(RecordSet.first())
			layoutname = Util.null2String(RecordSet.getString("layoutname"));
	}
	String filename = layoutname+".wef";
	response.setContentType("application/x-download;charset=UTF-8");
	final String userAgent = request.getHeader("USER-AGENT");
    try {
        String finalFileName = null;
        if(StringUtils.contains(userAgent, "MSIE")){//IE浏览器
            finalFileName = URLEncoder.encode(filename,"UTF8");
        }else if(StringUtils.contains(userAgent, "Mozilla")){//google,火狐浏览器
            finalFileName = new String(filename.getBytes(), "ISO8859-1");
        }else{
            finalFileName = URLEncoder.encode(filename,"UTF8");//其他浏览器
        }
       
	 response.setHeader("Content-Disposition", "attachment; filename=\"" + finalFileName + "\"");//这里设置一下让浏览器弹出下载提示框，而不是直接在浏览器中打开
    } catch (Exception e) {
    }
	String jsonObj = Util.null2String(request.getParameter("exportJson"));	
	jsonObj = encode(jsonObj);
	out.clear();
	out.println(jsonObj);
%>