
<%@ page language="java" contentType="application/x-download" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.util.zip.*" %>
<%@ page import="java.security.*" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.conn.*" %>
<jsp:useBean id="ps" class="weaver.mobile.plugin.ecology.service.PluginServiceImpl" scope="page" />
<%!
public String getHash(byte[] content, String hashType) throws Exception {  
    InputStream fis = new ByteArrayInputStream(content);  
    byte[] buffer = new byte[1024];
    MessageDigest md5 = MessageDigest.getInstance(hashType);
    int numRead = 0;
    while ((numRead = fis.read(buffer)) > 0) {
        md5.update(buffer, 0, numRead);
    }
    fis.close();
    return toHexString(md5.digest());
}

public char[] hexChar = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };

public String toHexString(byte[] b) {  
    StringBuilder sb = new StringBuilder(b.length * 2);  
    for (int i = 0; i < b.length; i++) {  
        sb.append(hexChar[(b[i] & 0xf0) >>> 4]);
        sb.append(hexChar[b[i] & 0x0f]);
    }
    return sb.toString();
}  
%>
<%
String url = Util.null2String(request.getParameter("url"));
String sessionkey = Util.null2String(request.getParameter("sessionkey"));

if(ps.verify(sessionkey)) {

	String filepath = "";
	String iszip = "";
	String filename = "";
	String isaesencrypt="";
	String aescode = "";
	String hashcode = "";
	
	if(Util.getIntValue(url)>0) {
		
		RecordSet rs = new RecordSet();
		
		String sql = "select isaesencrypt,aescode,imagefilename,imagefiletype,filerealpath,iszip from imagefile where imagefileid = " + url;
		
		rs.executeSql(sql);
		
		if(rs.next()) {
	
			filepath = rs.getString("filerealpath");
			iszip = rs.getString("iszip");
			filename = rs.getString("imagefilename");
			isaesencrypt = rs.getString("isaesencrypt");
			aescode = rs.getString("aescode");
		}
	} else {
		filepath = request.getRealPath(url);
		iszip = "0";
		filename = filepath.substring(filepath.lastIndexOf("/")+1);
	}

	File file = new File(filepath);
	byte[] content = null;
	
	if(file.exists()) {
		
		InputStream is = null;
		try {

			if (Util.getIntValue(iszip) > 0) {
				ZipInputStream zin = new ZipInputStream(new FileInputStream(file));
				if (zin.getNextEntry() != null)
					is = new BufferedInputStream(zin);
			} else {
				is = new BufferedInputStream(new FileInputStream(file));
			}
			if(isaesencrypt.equals("1")){
				is = AESCoder.decrypt(is,aescode);
			}
			byte[] rbs = new byte[2048];
			ByteArrayOutputStream outp = new ByteArrayOutputStream();
			int len = 0;
			while (((len = is.read(rbs)) > 0)) {
				outp.write(rbs, 0, len);
			}

			content = outp.toByteArray();
			
			outp.flush();

		} catch (Exception e) {
			//System.out.println("Error!");
			e.printStackTrace();
		} finally {
			if (is != null) {
				is.close();
				is = null;
			}
		}

		hashcode = getHash(content,"MD5");
		
	}
	
	Map result = new HashMap();

	result.put("hashcode", hashcode);

	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
}
%>