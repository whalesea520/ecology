
<%@ page language="java" contentType="application/x-download" pageEncoding="UTF-8"%><%@ 
page import="java.net.URLEncoder"%><%@ 
page import="java.util.zip.*" %><%@ 
page import="java.io.*" %><%@ 
page import="weaver.general.*" %><%@
page import="DBstep.iMsgServer2000" %><%@ 
page import="weaver.conn.*" %><%
//上面这句话的<%一定不要敲到下面来，否则会导致输出的附件打不开或内容乱码
	int fileid = Util.getIntValue(request.getParameter("fileid"),0);
	String filepath = "";
	String iszip = "";
	String filename = "";
	String contenttype = "";
	String markType = "";
	
	InputStream is = null;

    // 判断是否启用手写签批，如果没有启用就不用对word excel做文件处理
	boolean isMsgObjToDocument=true;
	BaseBean basebean = new BaseBean();
	String mClientName=Util.null2String(basebean.getPropValue("weaver_obj","iWebOfficeClientName"));
	boolean isIWebOffice2003 = (mClientName.indexOf("iWebOffice2003")>-1)?true:false;
	String isHandWriteForIWebOffice2009=Util.null2String(basebean.getPropValue("weaver_obj","isHandWriteForIWebOffice2009"));
	if(isIWebOffice2003||isHandWriteForIWebOffice2009.equals("0")){
		isMsgObjToDocument=false;
	}
    //

	
	if(fileid>0) {
		
		RecordSet rs = new RecordSet();
		
		//String sql = "select b.imagefilename,a.imagefiletype,a.filerealpath,a.iszip from imagefile a LEFT join docimagefile b ON a.imagefileid = b.imagefileid where a.imagefileid = " + fileid;
		String sql = "select imagefilename,imagefiletype,filerealpath,iszip from imagefile where imagefileid = " + fileid;;
		rs.executeSql(sql);
		
		if(rs.next()) {
			filepath = rs.getString("filerealpath");
			iszip = rs.getString("iszip");
			filename = rs.getString("imagefilename");
			contenttype = rs.getString("imagefiletype");
			
			String extName = "";
			if(filename.indexOf(".") > -1){
				int bx = filename.lastIndexOf(".");
				extName = filename.substring(bx+1, filename.length());
			}
			
			File file = new File(filepath);
			if (Util.getIntValue(iszip) > 0) {
				ZipInputStream zin = new ZipInputStream(new FileInputStream(file));
				if (zin.getNextEntry() != null)
					is = new BufferedInputStream(zin);
			} else {
				is = new BufferedInputStream(new FileInputStream(file));
			}
			if(("xls".equalsIgnoreCase(extName) || "doc".equalsIgnoreCase(extName) || "ppt".equalsIgnoreCase(extName)
					|| "xlsx".equalsIgnoreCase(extName) || "docx".equalsIgnoreCase(extName) || "pptx".equalsIgnoreCase(extName)
					|| "wps".equalsIgnoreCase(extName) || "et".equalsIgnoreCase(extName))&&isMsgObjToDocument) {
				//正文的处理
				ByteArrayOutputStream bout = null;
				try {
					int byteread = 0;
					byte[] rbs = new byte[2048];
					bout = new ByteArrayOutputStream();
	                while((byteread = is.read(rbs)) != -1) {
	                    bout.write(rbs, 0, byteread);
	                    bout.flush();
	                }
	                byte[] fileBody = bout.toByteArray();
	                iMsgServer2000 MsgObj = new DBstep.iMsgServer2000();
					MsgObj.MsgFileBody(fileBody);			//将文件信息打包
					fileBody = MsgObj.ToDocument(MsgObj.MsgFileBody());    //通过iMsgServer200 将pgf文件流转化为普通Office文件流
	                is = new ByteArrayInputStream(fileBody);
	                bout.close();
				}
				catch(Exception e) {
					if(bout!=null) {
						bout.close();
					}
				}
			}
		
		}
	} else {
		//Enumeration enumeration = request.getParameterNames();
		//while (enumeration.hasMoreElements()) {
		//	String parameterName = (String) enumeration.nextElement();
		//	if(parameterName.equals("sessionkey")) continue;
		//	if(parameterName.equals("url")) continue;
		//	String urlSeparator = "&";
		//	if(url.indexOf("?")==-1) urlSeparator = "?";
		//	if(url.indexOf(parameterName)==-1) {
		//		Object parameterValue = request.getParameter(parameterName);
		//		String value = parameterValue.toString();
		//		url += urlSeparator + parameterName + "=" + value;
		//	}
		//}
		//request.getRequestDispatcher(url).forward(request, response);
		return;
	}
	
	
	if(is != null) {
			boolean isexist= true;
			try{    
				Class.forName("weaver.file.AESCoder");
			}catch(Exception e){ 
				isexist = false;	//判断有没有打加密补丁
			}
			if(isexist){
				try {
					RecordSet rs1 = new RecordSet();
					String sql1 = "select isaesencrypt,aescode from imagefile where imagefileid = " + fileid;;
					rs1.executeSql(sql1);
					if(rs1.next()){
						String isaesencrypt = rs1.getString(1);
						String aescode = rs1.getString(2);
						if(isaesencrypt.equals("1")){
							is = weaver.messager.AESCoder.decrypt(is, aescode); // 解密
			            }
					}
				} catch (Exception e) {
					//e.printStackTrace();
				}
			}
			try {
				response.setHeader("Content-disposition","attachment; filename=" + URLEncoder.encode(filename,"UTF-8"));

				byte[] rbs = new byte[2048];
				OutputStream outp = response.getOutputStream();
				int len = 0;
				while (((len = is.read(rbs)) > 0)) {
					outp.write(rbs, 0, len);
				}

				outp.flush();
				//out.clear();
				out = pageContext.pushBody();

			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				if (is != null) {
					is.close();
					is = null;
				}
			}
			return;
	} else {
		response.sendError(HttpServletResponse.SC_NOT_FOUND);
	}

%>