
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.conn.RecordSet"%>
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	//request.setCharacterEncoding("utf-8");
	
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	request.setAttribute("emessage_savepath", "emessage");
	FileUpload fu = new FileUpload(request,"utf-8");
	String uploadType=Util.null2String(fu.getParameter("uploadType"));	
	String docid=fu.uploadFiles("Filedata");
	try {
			RecordSet rs=new RecordSet();
                Calendar today = Calendar.getInstance();
                String formatdate = Util.add0(today.get(Calendar.YEAR), 4) + "-"
                        + Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-"
                        + Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
                String formattime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":"
                        + Util.add0(today.get(Calendar.MINUTE), 2) + ":" + Util.add0(today.get(Calendar.SECOND), 2);
            	rs.executeSql("insert into fileclean (imagefileid,comefrom,filecreatedate,filecreatetime) values ("+docid+",'emessage','"+formatdate+"','"+formattime+"')");
		} catch (Exception e) {}
	if("image".equals(uploadType)||"pasteimage".equals(uploadType)){
		String url=""+docid+"";
		String filename = System.currentTimeMillis() + ".png";
		String filesize = "";
		RecordSet recordSet=new RecordSet();
		if("pasteimage".equals(uploadType)){
			recordSet.execute("update ImageFile set imagefilename='"+filename+"' where imagefileid="+docid);
		}
		recordSet.execute("select fileSize from ImageFile where imagefileid =" + docid);
		recordSet.next();
		filesize = recordSet.getString(1);
		
		// InputStream is=ImageFileManager.getInputStreamById(Util.getIntValue(docid));
		// String base64Str = null;
		// try{
		//	SocialImgCompress imgCompress=new SocialImgCompress(is);
		//	base64Str=imgCompress.compressImg(240, 240).replaceAll("\r\n","").replaceAll("\r","").replaceAll("\n","");
		// }catch(Exception e){
		//	new BaseBean().writeLog(e.toString());
		// }
		
		JSONObject result=new JSONObject();
		// result.put("content",base64Str);
		result.put("imgUrl",url);
		result.put("filename", Util.forHtml(filename));
		result.put("filesize", filesize);
		out.println(result);
	}else{
		RecordSet recordSet=new RecordSet();
		recordSet.execute("select imagefilename, fileSize from ImageFile where imagefileid =" + docid);
		recordSet.next();
		JSONObject result = new JSONObject();
		result.put("fileId", docid);
		result.put("filename", Util.forHtml(recordSet.getString(1)));
		result.put("filesize", recordSet.getString(2));
		out.println(result);
	} 
	
%>
