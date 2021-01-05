<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.cluster.*"%>
<%@ page import="sun.misc.BASE64Encoder"%>
<%@ page import="sun.misc.BASE64Decoder"%>
<%@ page import="java.io.*"%>
<%
    String data = request.getParameter("data");
	if(data == null){
		return;
	}
    //System.out.println(data);

    BASE64Decoder decoder = new BASE64Decoder();
    byte[] byteData = decoder.decodeBuffer(data);

    ByteArrayInputStream bis = new ByteArrayInputStream(byteData);
    ObjectInputStream ois = new ObjectInputStream(bis);

    CacheMessage message = (CacheMessage) ois.readObject();
    
    CacheManager cm = CacheManager.getInstance();
    cm.handleNotification(message);
%>
