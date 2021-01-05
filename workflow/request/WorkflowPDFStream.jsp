<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="org.xhtmlrenderer.pdf.ITextRenderer,org.xhtmlrenderer.pdf.ITextFontResolver,com.lowagie.text.pdf.BaseFont" %>
<%
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
String uniqueKey = Util.null2String(request.getParameter("uniqueKey"));
String pdf_formhtml = Util.null2String(session.getAttribute("pdf_formhtml_"+uniqueKey));
session.removeAttribute("pdf_formhtml_"+uniqueKey);

BufferedInputStream bis = null;
BufferedOutputStream bos = null;
try {	
	//使用flyingsaucer转PDF
	//添加中文显示
    ITextRenderer renderer = new ITextRenderer();
    ITextFontResolver fontResolver = renderer.getFontResolver();
    fontResolver.addFont(basePath+"/font/arial.ttf",BaseFont.IDENTITY_H, BaseFont.NOT_EMBEDDED);		//Arial
	fontResolver.addFont(basePath+"/font/simsun.ttc",BaseFont.IDENTITY_H, BaseFont.NOT_EMBEDDED);		//宋体
	fontResolver.addFont(basePath+"/font/simhei.ttf",BaseFont.IDENTITY_H, BaseFont.NOT_EMBEDDED);		//黑体
	fontResolver.addFont(basePath+"/font/msyh.ttf",BaseFont.IDENTITY_H, BaseFont.NOT_EMBEDDED);		//微软雅黑
	fontResolver.addFont(basePath+"/font/simkai.ttf",BaseFont.IDENTITY_H, BaseFont.NOT_EMBEDDED);		//楷体
	fontResolver.addFont(basePath+"/font/SIMYOU.TTF",BaseFont.IDENTITY_H, BaseFont.NOT_EMBEDDED);		//幼圆
	fontResolver.addFont(basePath+"/font/simfang.ttf",BaseFont.IDENTITY_H, BaseFont.NOT_EMBEDDED);		//仿宋
    //jar冲突
    System.setProperty("javax.xml.transform.TransformerFactory","com.sun.org.apache.xalan.internal.xsltc.trax.TransformerFactoryImpl");
    System.setProperty("javax.xml.parsers.DocumentBuilderFactory","com.sun.org.apache.xerces.internal.jaxp.DocumentBuilderFactoryImpl"); 
    
	//Html格式化
    org.jsoup.nodes.Document doc = org.jsoup.Jsoup.parse(pdf_formhtml);
    String str = doc.html();
    
    //字符替换
    //System.err.println("beforeTrans"+str);
    str = str.replaceAll("<o:p></o:p>", "");
    str = str.replaceAll("(FONT-FAMILY|font-family)?[ ]*:[ ]*宋体", "font-family:SimSun");
    str = str.replaceAll("(FONT-FAMILY|font-family)?[ ]*:[ ]*黑体", "font-family:SimHei");
    str = str.replaceAll("(FONT-FAMILY|font-family)?[ ]*:[ ]*楷体(_GB2312)?", "font-family:KaiTi");
    str = str.replaceAll("(FONT-FAMILY|font-family)?[ ]*:[ ]*幼圆", "font-family:YouYuan");
    str = str.replaceAll("(FONT-FAMILY|font-family)?[ ]*:[ ]*仿宋(_GB2312)?", "font-family:FangSong");
    str = str.replaceAll("(FONT-FAMILY|font-family)?[ ]*:[ ]*隶书", "font-family:Microsoft YaHei");
    //System.out.println("afterTrans---"+str);
    
    renderer.setDocumentFromString(str);  
    renderer.layout();

    ByteArrayOutputStream pdfos = new ByteArrayOutputStream();
    renderer.createPDF(pdfos);
    pdfos.close();
	
	//PDF显示
    response.reset();
    response.setContentType("application/pdf");
      
    byte[] pdfbyte=pdfos.toByteArray();
    bis = new BufferedInputStream(new ByteArrayInputStream(pdfbyte));
    bos = new BufferedOutputStream(response.getOutputStream());

    byte[] buff = new byte[2048];
    int bytesRead;
    while((bytesRead = bis.read(buff, 0, buff.length)) != -1) {
        bos.write(buff, 0, bytesRead);
    }
    bos.flush();
    //out.clear();
    out = pageContext.pushBody();
    //添加下载流成功session，用于界面loading效果结束
    session.setAttribute("pdfstream_"+uniqueKey, "success");
} catch(IOException e) {
    e.printStackTrace();
} finally {
    if (bis != null) {
        try {
            bis.close();
            bis = null;
        } catch (IOException e) {
        }
    }
    if (bos != null) {
        try {
            bos.close();
            bos = null;
        } catch (IOException e) {
        }
    }
}
%>