<%@ page language="java" contentType="text/html; charset=UTF-8" %><jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/><%@page import="java.io.ByteArrayOutputStream"%><%@page import="java.io.OutputStream"%><%@page import="java.io.FileInputStream"%><%@page import="java.io.File"%><%@page import="java.util.ArrayList"%><%@page import="weaver.general.Util"%><%@ page import='weaver.hrm.User'%><%@ page import='weaver.hrm.HrmUserVarify'%><%@ page import='java.util.zip.ZipInputStream'%><%@ page import='java.io.BufferedInputStream'%><%@ page import='java.io.InputStream'%><%@ page import='weaver.file.AESCoder'%><%@ page import='weaver.systeminfo.SystemEnv'%><%
	
		InputStream imagefile = null;        

		ByteArrayOutputStream javaout = null;

	    User user = null;
	try {//此页面开头不能有回车，否则输入与之前不能完全一致

	    user = HrmUserVarify.getUser (request , response) ;
	    int  userId=user.getUID();
	    int  loginType= Util.getIntValue(user.getLogintype(),1);

        String loadDspSwfPara=Util.null2String((request.getParameter("loadDspSwfPara")));//传入附件参数

        int docId =0;//文档id
		int versionId=0;//文档版本id
		int imageFileId=0;//文档附件id
		ArrayList  strlist=Util.TokenizerString(loadDspSwfPara,"_");
		if(strlist.size()>=5){
			docId=Util.getIntValue((String)strlist.get(2),0);
			versionId=Util.getIntValue((String)strlist.get(3),0);
			imageFileId=Util.getIntValue((String)strlist.get(4),0);
		}

		boolean hasRight=false;
		int hasRightInt=Util.getIntValue((String)session.getAttribute("hasRight_"+userId+"_"+loginType+"_"+docId+"_"+versionId+"_"+imageFileId),-1);

		if(hasRightInt==1){
			hasRight=true;
		}
		if(docId<=0&&versionId<=0&&imageFileId<=0){
			hasRight=false;
		}
		int swfFileId=0;
		RecordSet.executeSql("select swfFileId from DocPreview where imageFileId="+imageFileId+" order by id desc");
		if(RecordSet.next()){
			swfFileId=Util.getIntValue(RecordSet.getString("swfFileId"));
		}
			
			String sql = "select filerealpath,iszip,isaesencrypt,aescode from ImageFile   where imageFileId = " + swfFileId;

			RecordSet.executeSql(sql);
			if (hasRight&&RecordSet.next()) {
				String filerealpath = Util.null2String("" + RecordSet.getString("filerealpath"));
				String iszip = Util.null2String("" + RecordSet.getString("iszip"));
				String isaesencrypt = Util.null2String("" + RecordSet.getString("isaesencrypt"));
				String aescode = Util.null2String("" + RecordSet.getString("aescode"));

					File thefile = new File(filerealpath);
					if (iszip.equals("1")) {
						ZipInputStream zin = new ZipInputStream(new FileInputStream(thefile));
						if (zin.getNextEntry() != null)
							imagefile = new BufferedInputStream(zin);
					} else {
						imagefile = new BufferedInputStream(new FileInputStream(thefile));
					}
	
				if(isaesencrypt.equals("1")){
					imagefile = AESCoder.decrypt(imagefile, aescode); 
				}   

				int byteread;
				byte data[] = new byte[1024];
				javaout = new ByteArrayOutputStream();
				while ((byteread = imagefile.read(data)) != -1) {
					javaout.write(data, 0, byteread);
					javaout.flush();
				}

				byte[] b = javaout.toByteArray();	
				OutputStream os = response.getOutputStream();
				os.write(b, 0, b.length);
				//os.flush();
				os.close();
			}
	} catch (Exception e) {
		e.printStackTrace();
		out.clear();
		out.print(SystemEnv.getHtmlLabelName(83410,user.getLanguage()));
		out.flush();

	} finally {

			try {
				if (imagefile != null) {
					imagefile.close();
				}
			} catch (Exception ex) {

			}
			try {
				if (javaout != null) {
					javaout.close();
				}
			} catch (Exception ex) {
			}
		}
%>