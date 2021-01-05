<%@page import="weaver.file.AESCoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.file.FileUpload,weaver.file.Prop"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.sun.image.codec.jpeg.*"%>
<%@ page import="java.awt.*"%>
<%@ page import="java.awt.geom.Rectangle2D"%>
<%@ page import="java.awt.image.*"%>
<%@ page import="java.io.*"%>
<%@ page import="javax.imageio.ImageIO"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="java.util.zip.*"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.alioss.AliOSSObjectManager"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;	
	String method = Util.null2String(request.getParameter("method"));	
	if("preview".equals(method)){
		FileUpload fu = new FileUpload(request,"utf-8",false,true);
		int imagefileid = Util.getIntValue(fu.uploadFiles("Filedata"));			
		response.sendRedirect("SocialGetGroupIconSub.jsp?imagefileid="+imagefileid);
	}else if("setGroupIcon".equals(method)){
			String discussid  = Util.null2String(request.getParameter("discussid"));
			int x1 = 0;
			int y1 = 0;
			int x2 = 0;
			int y2 = 0;
			int formatWidth = 0;
			int formatHeight = 0;	
			int imagefileid=0;
			DiskFileUpload dfu = new DiskFileUpload();
			dfu.setSizeMax(4194304); //4MB
			dfu.setSizeThreshold(4096); //缓冲区大小4kb
			java.util.List fileItems = dfu.parseRequest(request);
			Iterator ite = fileItems.iterator();
			try {
				while (ite.hasNext()) {
					FileItem item = (FileItem) ite.next();
					if (!item.isFormField()) {
						String name = item.getName();
						if(Util.isExcuteFile(name)) continue;
						long size = item.getSize();
						if ((name == null || name.equals("")) || size == 0)
							continue;
						
						//imagefile = new BufferedInputStream(item.getInputStream());
					} else {
						if (item.getFieldName().equals("x1"))
							x1 = Util.getIntValue(item.getString("UTF-8"));
						if (item.getFieldName().equals("y1"))
							y1 = Util.getIntValue(item.getString("UTF-8"));
						if (item.getFieldName().equals("x2"))
							x2 = Util.getIntValue(item.getString("UTF-8"));
						if (item.getFieldName().equals("y2"))
							y2 = Util.getIntValue(item.getString("UTF-8"));	
						if (item.getFieldName().equals("formatHeight"))
							formatHeight = Util.getIntValue(item.getString("UTF-8"));
						if (item.getFieldName().equals("formatWidth"))
							formatWidth = Util.getIntValue(item.getString("UTF-8"));
						if (item.getFieldName().equals("imagefileid"))
							imagefileid = Util.getIntValue(item.getString("UTF-8"));	
					}
				}
			} catch (Exception e) {	
			}							
				rs.executeSql("select imagefilename,isaesencrypt,aescode,filerealpath,iszip from imagefile where imagefileid="+imagefileid);
				rs.next();
				String filerealpath=Util.null2String(rs.getString("filerealpath"));  
				String iszip=Util.null2String(rs.getString("iszip"));
				String isaesencrypt = Util.null2String(rs.getString("isaesencrypt"));
				String aescode = Util.null2String(rs.getString("aescode"));
				String imagefilename  =Util.null2String(rs.getString("imagefilename"));
				InputStream imagefile = null;
				Image image =null;
				try{
					File thefile = new File(filerealpath);
					if (iszip.equals("1")) {
					ZipInputStream zin = new ZipInputStream(new FileInputStream(thefile));
					if (zin.getNextEntry() != null) {
						imagefile = new BufferedInputStream(zin);
					}
					} else {
						imagefile = new BufferedInputStream(new FileInputStream(thefile));
					}
					if(isaesencrypt.equals("1")){
						imagefile = AESCoder.decrypt(imagefile,aescode);
					}
					 image = ImageIO.read(imagefile);
					//创建一个BufferedImage  477px;height:287px
					BufferedImage bufimage = new BufferedImage(formatWidth,formatHeight,BufferedImage.TYPE_3BYTE_BGR);
					//把图片读到bufferedImage中	
					bufimage.getGraphics().drawImage(image,0,0, formatWidth, formatHeight, null);
						//得到转换后的Image图片
					image = bufimage;
					imagefile.close(); 
				}catch (Exception e) {e.printStackTrace();}  
				
				int width = x2 - x1;
				int height = y2 - y1;
				if(width<0)width=100;
				if(height<0)height=100;
				BufferedImage thumbImage = new BufferedImage(width, height,
						BufferedImage.TYPE_INT_RGB);
				int[] data = new int[width * height];
				int i = 0;
				for (int y = 0; y < height; y++) {
					for (int x = 0; x < width; x++) {
						data[i++] = 0xffffffff;
					}
				}
				thumbImage.setRGB(0, 0, width, height, data, 0, width);
				Graphics2D graphics2D = thumbImage.createGraphics();
				graphics2D.setRenderingHint(RenderingHints.KEY_INTERPOLATION,
						RenderingHints.VALUE_INTERPOLATION_BILINEAR);
				graphics2D.drawImage(image, 0, 0, width, height, x1, y1, x2,
						y2, Color.white, null);
				try{
					ImageIO.write(thumbImage, "jpg", new File(filerealpath));				
				}catch (Exception e) {e.printStackTrace();}
				JSONObject result = new JSONObject();
				result.put("issuccess","1");
				result.put("discussid",discussid);
				result.put("imagefileid",imagefileid);
				out.println(result.toString());
		
	}		
%>