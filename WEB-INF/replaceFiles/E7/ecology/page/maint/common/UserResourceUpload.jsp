<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="java.io.*"%>

<%@ page import="weaver.hrm.*"%>

<%@page import="weaver.general.*"%>
<%@page import="weaver.file.FileType"%>
<%!
	private boolean validateFileExt(String filename){
		if(filename==null)return false;
		if(filename.indexOf(".")!=filename.lastIndexOf(".")){
			return false;
		}
		String[] allowTypes  = new String[]{".jpg",".jpeg",".gif",".ico",".bmp",".png",".flv",".mp3",".swf",".mp4",".wmv"};
		if(filename!=null && allowTypes!=null){
			for(int i=0;i<allowTypes.length;i++){
				if(filename.toLowerCase().endsWith(allowTypes[i].toLowerCase())){
					return true;
				}
			}
			return false;
		}else{
			return false;
		}
	}
%>
<%

	User user = HrmUserVarify.getUser (request , response) ;
	
	if(user==null)return;
	
	String dir  = Util.null2String(request.getParameter("dir"));
	if(!(dir.startsWith("/page/resource/userfile")||dir.startsWith("page/resource/userfile"))){
		out.println("error");
		return;
	}
	String rootPath;
	DataInputStream in = null;
	FileOutputStream fileOut = null;
	String realPath = GCONST.getRootPath();
	rootPath = realPath + dir;
	String contentType = request.getContentType();
	try {
		if (contentType.indexOf("multipart/form-data") >= 0) {
			in = new DataInputStream(request.getInputStream());
			int formDataLength = request.getContentLength();
			byte dataBytes[] = new byte[formDataLength];
			int byteRead = 0;
			int totalBytesRead = 0;
			while (totalBytesRead < formDataLength) {
				byteRead = in.read(dataBytes, totalBytesRead,
						formDataLength);
				totalBytesRead += byteRead;
			}
			String file = new String(dataBytes);			
			
			String saveFile = file.substring(file.indexOf("filename=\"") + 10);
			
			
			
			saveFile = saveFile.substring(0, saveFile.indexOf("\n"));
			saveFile = saveFile.substring(
			saveFile.lastIndexOf("\\") + 1, saveFile.indexOf("\""));
			int lastIndex = contentType.lastIndexOf("=");
			String boundary = contentType.substring(lastIndex + 1,
			contentType.length());
			String fileName = rootPath + saveFile;
			fileName = fileName.replaceAll("%00","").replaceAll("%","");
			if(!validateFileExt(fileName)) return;
			
			int pos;
			pos = file.indexOf("filename=\"");
			pos = file.indexOf("\n", pos) + 1;
			pos = file.indexOf("\n", pos) + 1;
			pos = file.indexOf("\n", pos) + 1;
			int boundaryLocation = file.indexOf(boundary, pos)-4;
			int startPos = ((file.substring(0, pos)).getBytes()).length;
			File checkFile = new File(fileName);
			if (checkFile.exists()) {
				return;
			}
			File fileDir = new File(rootPath);
			if (!fileDir.exists()) {
				fileDir.mkdirs();
			}
			
		    int endLength= file.substring(boundaryLocation,file.length()).getBytes().length;
			
			try{
				//System.out.println(startPos+"::"+dataBytes.length+"::"+"::"+(dataBytes.length-startPos-endLength));
				byte fileBytes[] = new byte[dataBytes.length-startPos-endLength];
				
				System.arraycopy(dataBytes, startPos, fileBytes, 0, dataBytes.length-startPos-endLength);  
				String fileType = FileType.getFileTypeByByte(fileBytes);
				//System.out.println("fileType:::"+fileType);
				if(validateFileExt(fileType)){
					fileOut = new FileOutputStream(fileName);
					fileOut.write(dataBytes, startPos,dataBytes.length-startPos-endLength);
				}else{
					out.println("file type is not valid!");
				}
			}catch(Exception e){
				e.printStackTrace();
			}finally{
				try{
					if(fileOut!=null)
						fileOut.close();
					if(in!=null)
						in.close();
				}catch(Exception e){}
			}
			
		} else {
			String content = request.getContentType();
		}
	} catch (Exception ex) {
		throw new ServletException(ex.getMessage());
	}
%>
