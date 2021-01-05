
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util,weaver.file.*,weaver.conn.*, java.io.*,java.text.SimpleDateFormat,weaver.general.GCONST" %>
<%@ page import="java.io.Writer,oracle.sql.CLOB,weaver.conn.ConnStatement" %>
<%@page import="org.apache.ws.commons.util.Base64"%>
<%@ page import="weaver.file.FileUpload,weaver.file.Prop"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.email.ImageUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="com.sun.image.codec.jpeg.*"%>
<%@ page import="java.awt.*"%>
<%@ page import="java.awt.geom.Rectangle2D"%>
<%@ page import="java.awt.image.*"%>
<%@ page import="java.io.*"%>
<%@ page import="javax.imageio.ImageIO"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="java.util.zip.ZipInputStream"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="tcode" class="weaver.email.TwoDimensionCode" scope="page" />
<jsp:useBean id="syscominfo" class="weaver.system.SystemComInfo" scope="page" />
<%
int userId = user.getUID();

FileUpload fu = new FileUpload(request, false);
int id = Util.getIntValue(fu.getParameter("id"));
String ids = Util.null2String(fu.getParameter("ids"));

String showTop = Util.null2String(fu.getParameter("showTop"));

String sql = "";
String operation = Util.null2String(fu.getParameter("operation"));
String signName = Util.null2String(fu.getParameter("signName"));
String signDesc = Util.null2String(fu.getParameter("signDesc"));
String signContent = Util.null2String(fu.getParameter("signContent"));
String defaultSignId = Util.null2String(fu.getParameter("defaultSignId"));
String signType = Util.null2String(fu.getParameter("signType"));
String isActive = Util.null2String(fu.getParameter("isActive"));
	String lastname = Util.null2String(fu.getParameter("lastname"));
	String jobtitle = Util.null2String(fu.getParameter("jobtitle"));
	String email = Util.null2String(fu.getParameter("email"));
	String jobname = Util.null2String(fu.getParameter("jobname"));
	String location = Util.null2String(fu.getParameter("location"));
	String mobile = Util.null2String(fu.getParameter("mobile"));
	String telephone = Util.null2String(fu.getParameter("telephone"));
	String fax = Util.null2String(fu.getParameter("fax"));
	String url = Util.null2String(fu.getParameter("url"));
	String selectedId = Util.null2String(fu.getParameter("selecteIdItem"));
	String qrcodepath = Util.null2String(fu.getParameter("qrcodepath"));
	String signheadpath = Util.null2String(fu.getParameter("headimg"), "");
	String isheadimghid = Util.null2String(fu.getParameter("isheadimghid"), "0");
	String base64Headimg = "";
	
	
	if(!"".equals(signheadpath) || signheadpath != null) {
		if(signheadpath.length()>4) {
			signheadpath = GCONST.getRootPath() + signheadpath; 
			base64Headimg = ImageUtil.ImageToBase64String(signheadpath, true);
		}
	}
	
if("".equals(isActive) || isActive == null)
	isActive = "0";

defaultSignId = Util.getIntValue(request.getParameter("isclear"))==1?"0":defaultSignId;
if(operation.equals("add") || operation.equals("update")){
    /* String img_flag="<img alt=\"docimages_";
    int tmppos = signContent.indexOf(img_flag);
    ArrayList list = new ArrayList();
    String docimageNum = "0";
    int tmppos2 = 0;
    while(tmppos != -1) {
		tmppos2 = tmppos;
		tmppos = signContent.indexOf("src=\"",tmppos+20);
		docimageNum = signContent.substring(tmppos2+19, tmppos-1);
		docimageNum = docimageNum.substring(1,docimageNum.indexOf('"'));
		int startpos = signContent.indexOf("\"", tmppos);
		int endpos = signContent.indexOf("\"", startpos + 1);
		String tempStr = signContent.substring(startpos + 1, endpos);
		String replaceStr = "cid:img"+docimageNum+"@www.weaver.com.cn";

		if(tempStr.indexOf("weaver.email.FileDownloadLocation")!=-1){
			tmppos = signContent.indexOf(img_flag, startpos+tempStr.length());
		}
		signContent = Util.StringReplace(signContent, tempStr,replaceStr);
		tmppos = signContent.indexOf(img_flag, startpos+replaceStr.length());
		list.add(docimageNum);
	} */
	if(signContent.indexOf("'")!=-1){
		signContent = Util.StringReplace(signContent, "'","''");
	}
	signName = Util.StringReplace(signName, "'","''");
	signDesc = Util.StringReplace(signDesc, "'","''");
if(operation.equals("add"))
{
	signContent =signContent.replaceAll("'", "''");
	sql = "insert into MailSign(userId,signName,signDesc,signContent,signType,isActive) values("+userId+",'"+signName+"','"+signDesc+"','"+signContent+"',"+signType+","+isActive+")";
	rs.executeSql(sql);
	
	int signId=0;
	String signSql ="select max(id) as id from MailSign where userid="+userId;
	//电子名片
	rs.execute(signSql);
	if(rs.next())
		signId=rs.getInt(1);
	
	if("1".equals(isActive)) {
		sql = "update MailSign set isActive=0 where id != "+ signId +" and userId=" + userId;
		rs.executeSql(sql);
	}
	
	Map<String, String> map = new HashMap<String, String>();
	map.put("1", "N:"+lastname+" \n");
	map.put("2", "TITLE:"+jobtitle+" \n");
	map.put("3", "EMAIL:"+email+" \n");
	map.put("4", "NOTE:公司名称："+jobname+" \n");
	map.put("5", "ADR;WORK:"+location+" \n");
	map.put("6", "TEL;CELL;VOICE:"+mobile+" \n");
	map.put("7", "TEL;WORK;VOICE:"+telephone+" \n");
	map.put("8", "TEL;WORK;FAX:"+fax+" \n");
	map.put("9", "URL:"+url+" \n");
	
    StringBuffer encoderContent = new StringBuffer();
    encoderContent.append("BEGIN:VCARD \n");
    encoderContent.append("VERSION:3.0 \n");
	String[] arrayMailIds = Util.TokenizerString2(selectedId, ",");
	for(int i=0; i<arrayMailIds.length; i++) {
		encoderContent.append(map.get(arrayMailIds[i]));
	}
    encoderContent.append("END:VCARD");
    
	String imgfilename = user.getUID() + "_" +signId;
	String imgfilerealpath = syscominfo.getFilesystem();
	try {
		if ("".equals(imgfilerealpath)) 
			imgfilerealpath = GCONST.getRootPath();
		imgfilerealpath += "mailQRcodeTemp"
		+ File.separatorChar + imgfilename;
	} catch (Exception e) {
		BaseBean basebean = new BaseBean();
		basebean.writeLog(e);
	}
	
	tcode.encoderQRCode(encoderContent.toString(), imgfilerealpath, "png");
	
	
    String base64QRCode	= ImageUtil.ImageToBase64String(imgfilerealpath, true);
    
	String eleSignSql = "insert into MailElectronSign(signid, name, email, jobtitle, jobname, location, mobile, telephone, fax, url, selected, qrcodepath, signheadpath)  values (" +
		signId + ", '"+ lastname +"', '" + email +"', '" + jobtitle + "', '" + jobname + "', '" + location+ "', '" + mobile+ "', '" + telephone+ "', '" + fax + "', '" + url + "', '"+ selectedId + 
			"', '"+base64QRCode+"', '"+base64Headimg+"' ) ";
	
	if(signId != 0) {
		rs.execute(eleSignSql);
	}
		
}
else if(operation.equals("update"))
{	

	
	sql = "update MailSign set signName='"+signName+"',signDesc='"+signDesc+"',signContent='"+signContent+"', isActive='"+isActive+"' where userid="+userId+" and id="+id;
	rs.executeSql(sql);
	
	if("1".equals(isActive)) {
		sql = "update MailSign set isActive=0 where id != "+ id +" and userId=" + userId;
		rs.executeSql(sql);
	}
	
	if(!"1".equals(signType)) {
		out.println("<script>parent.getParentWindow(window).closeDialog()</script>");		
		return;
	}
	
	Map<String, String> map = new HashMap<String, String>();
	map.put("1", "N:"+lastname+" \n");
	map.put("2", "TITLE:"+jobtitle+" \n");
	map.put("3", "EMAIL:"+email+" \n");
	map.put("4", "NOTE:公司名称："+jobname+" \n");
	map.put("5", "ADR;WORK:"+location+" \n");
	map.put("6", "TEL;CELL;VOICE:"+mobile+" \n");
	map.put("7", "TEL;WORK;VOICE:"+telephone+" \n");
	map.put("8", "TEL;WORK;FAX:"+fax+" \n");
	map.put("9", "URL:"+url+" \n");
	
    StringBuffer encoderContent = new StringBuffer();
    encoderContent.append("BEGIN:VCARD \n");
    encoderContent.append("VERSION:3.0 \n");
	String[] arrayMailIds = Util.TokenizerString2(selectedId, ",");
	for(int i=0; i<arrayMailIds.length; i++) {
		encoderContent.append(map.get(arrayMailIds[i]));
	}
    encoderContent.append("END:VCARD");
    
	String imgfilename = user.getUID() + "_" +id;
	String imgfilerealpath = syscominfo.getFilesystem();
	try {
		if ("".equals(imgfilerealpath)) 
			imgfilerealpath = GCONST.getRootPath();
		imgfilerealpath += "mailQRcodeTemp"
		+ File.separatorChar + imgfilename;
	} catch (Exception e) {
		BaseBean basebean = new BaseBean();
		basebean.writeLog(e);
	}
	
	tcode.encoderQRCode(encoderContent.toString(), imgfilerealpath, "png");
	
    String base64QRCode	= ImageUtil.ImageToBase64String(imgfilerealpath, true);
	String eleSignSql = "update MailElectronSign set " +
		" name = '"+lastname+"', email='"+email+"', jobtitle='"+jobtitle+"', location='"+location+"', telephone='"+telephone+"', " + 
		"fax='"+fax+"', jobname='"+jobname+"', url='"+url+"', mobile='"+mobile+"', selected='"+selectedId+"', qrcodepath='"+base64QRCode +
        "', signheadpath='"+base64Headimg + "' where signid = " + id;
    rs.execute(eleSignSql);
	 

}

out.println("<script>parent.getParentWindow(window).closeDialog()</script>");
return;
}
else if(operation.equals("default")) {
	if(defaultSignId.equals("")) {
		sql = "update MailSign set isActive=0 where isActive=1 and userId="+ userId;
		rs.executeSql(sql);
	} else {
		sql = "update MailSign set isActive=0 where id in (select id from MailSign where isActive=1 and userId="+ userId +")";
		if(rs.executeSql(sql)) {
			sql = "update MailSign set isActive=1 where id="+ defaultSignId +"and userId=" + userId;
			rs.executeSql(sql);
		}
	}
}
else
{
	sql = "delete from MailSign where id in ("+ids+") and userid=" + userId;
	rs.executeSql(sql);
}
if(showTop.equals("")) {
	response.sendRedirect("MailSign.jsp");
} else if(showTop.equals("show800")) {
	response.sendRedirect("MailSign.jsp?showTop=show800");
}
%>