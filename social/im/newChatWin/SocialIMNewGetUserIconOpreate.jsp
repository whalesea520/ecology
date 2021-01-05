<%@page import="weaver.file.AESCoder"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
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
<%@ page import="java.util.zip.ZipInputStream"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="mdci" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<%
	User user = HrmUserVarify.getUser(request, response);
	if (user == null) return;
	
	
	String mode=Prop.getPropValue(GCONST.getConfigFile() , "authentic");
	String temploginid = Util.null2String(request.getParameter("temploginid"));
	String trmphomepage = Util.null2String(request.getParameter("trmphomepage"));
	String uploadPath = GCONST.getRootPath() + "messager"
			+ File.separatorChar + "usericon";
	String tempPath = uploadPath + File.separatorChar + "Temp";
	//自动创建目录：
	if (!new File(uploadPath).isDirectory())
		new File(uploadPath).mkdirs();
	if (!new File(tempPath).isDirectory())
		new File(tempPath).mkdirs();
	String method = "";
	String userId = "";
	String subcompanyid = "";
	String isManager = "";
	String loginid = "";
	int x1 = 0;
	int y1 = 0;
	int x2 = 0;
	int y2 = 0;
  int formatWidth = 0;
  int formatHeight = 0;
	String requestFrom="";
	
	int imagefileid=0;
	DiskFileUpload fu = new DiskFileUpload();
	fu.setSizeMax(4194304); //4MB
	fu.setSizeThreshold(4096); //缓冲区大小4kb
	fu.setRepositoryPath(tempPath);

	java.util.List fileItems = fu.parseRequest(request);
	Iterator ite = fileItems.iterator();

	//BufferedInputStream imagefile=null;
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
				if (item.getFieldName().equals("method"))
					method = Util.null2String(item.getString("UTF-8"));
				if (item.getFieldName().equals("userId"))
					userId = Util.null2String(item.getString("UTF-8"));
				if (item.getFieldName().equals("subcompanyid"))
					subcompanyid = Util.null2String(item.getString("UTF-8"));
				if (item.getFieldName().equals("isManager"))
					isManager = Util.null2String(item.getString("UTF-8"));
				if (item.getFieldName().equals("loginid"))
					loginid = Util.null2String(item.getString("UTF-8"));
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
				if (item.getFieldName().equals("requestFrom"))
					requestFrom = Util.null2String(item.getString("UTF-8"));

			}
		}
	} catch (Exception e) {
	}
	
	if(!"1".equals(isManager)){
		userId = ""+user.getUID();
		loginid = user.getLoginid();
	}else{
		int hrmdetachable = 0;
		if(session.getAttribute("hrmdetachable")!=null){
			hrmdetachable = Util.getIntValue(String.valueOf(session.getAttribute("hrmdetachable")),0);
		}else{
			boolean isUseHrmManageDetach = mdci.isUseHrmManageDetach();
			if(isUseHrmManageDetach){
				hrmdetachable = 1;
			}else{
				hrmdetachable = 0;
			}
		}
		int operatelevel = -1;
		if(hrmdetachable==1){
			operatelevel = CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmResourceEdit:Edit",Util.getIntValue(subcompanyid,0));
		}else{
			if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user)){
				operatelevel = 2;
			}
		}
		if(operatelevel<=0){
			userId = ""+user.getUID();
			loginid = user.getLoginid();
		}
	}
	
	if ("delete".equals(method)) {
		String strSql="update hrmresource set messagerurl='' where id="+userId;		
		rs.executeSql(strSql);
		ResourceComInfo resourceComInfo=new ResourceComInfo();
		resourceComInfo.updateResourceInfoCache(userId);

		out.println("<script>window.location='SocialIMNewGetUserIcon.jsp?isclosed=false&requestFrom="+requestFrom+"&isManager="+isManager+"&userId="+userId+"&subcompanyid="+subcompanyid+"&iconUrl="+resourceComInfo.getMessagerUrls(userId)+"&loginid="+loginid+"'</script>");
		
	}
	
	if ("usericon".equals(method)) {
		String iconName="loginid"+TimeUtil.getFormartString(Calendar.getInstance(),"yyyyMMddHHmmss")+".jpg";
		//生成缩略图		
		String targetUrl = uploadPath+ File.separatorChar +iconName;
		
		rs.executeSql("select isaesencrypt,aescode,filerealpath,iszip from imagefile where imagefileid="+imagefileid);
		rs.next();
		String filerealpath=Util.null2String(rs.getString("filerealpath"));  
        String iszip=Util.null2String(rs.getString("iszip"));
        String isaesencrypt = Util.null2String(rs.getString("isaesencrypt"));
        String aescode = Util.null2String(rs.getString("aescode"));
        InputStream imagefile = null;
        
        if(filerealpath==null || filerealpath.equals("")){
            out.println("<script>window.location='SocialIMNewGetUserIcon.jsp?requestFrom="+trmphomepage+"&isManager="+isManager+"&userId="+userId+"&subcompanyid="+subcompanyid+"&loginid="+temploginid+"'</script>");
            return;
          }
        
        
        File thefile = new File(filerealpath);
        if (iszip.equals("1")) {
          ZipInputStream zin = new ZipInputStream(new FileInputStream(thefile));
          if (zin.getNextEntry() != null) imagefile = new BufferedInputStream(zin);
        } else {
          imagefile = new BufferedInputStream(new FileInputStream(thefile));
        }
        if(isaesencrypt.equals("1")){
        	imagefile = AESCoder.decrypt(imagefile,aescode);
        }
         Image image = ImageIO.read(imagefile);

         if(formatWidth>477||formatHeight>287){ }
	         //创建一个BufferedImage  477px;height:287px
	         BufferedImage bufimage = new BufferedImage(formatWidth,formatHeight,BufferedImage.TYPE_3BYTE_BGR);
	       	 //把图片读到bufferedImage中
	
	         bufimage.getGraphics().drawImage(image,0,0, formatWidth, formatHeight, null);
	         //得到转换后的Image图片
	         image = bufimage;
        
         
         imagefile.close();
         
		//Image image = ImageIO.read(imagefile);
		//imagefile.close();

		
		int width = x2 - x1;
		int height = y2 - y1;
		if(width<=0)width=100;
		if(height<=0)height=100;
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

		BufferedOutputStream out2 = new BufferedOutputStream(
				new FileOutputStream(targetUrl));
		JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(out2);
		JPEGEncodeParam param = encoder
				.getDefaultJPEGEncodeParam(thumbImage);
		int quality = 80;
		quality = Math.max(0, Math.min(quality, 100));
		param.setQuality((float) quality / 100.0f, false);
		encoder.setJPEGEncodeParam(param);
		encoder.encode(thumbImage);
		out2.close();

		//保存进数据库
		//String whereSql = "and loginid='"+loginid+"'";
		//loginid、account字段整合  qc:128484
		//if(mode.equals("ldap")) whereSql = "and account='"+loginid+"'";
		//if(mode.equals("ldap")) whereSql = "and loginid='"+loginid+"'";
		String strSql="update hrmresource set messagerurl='/messager/usericon/"+iconName+"' where id="+userId;	
		rs.executeSql(strSql);
		ResourceComInfo resourceComInfo=new ResourceComInfo();
		resourceComInfo.updateResourceInfoCache(userId);
		out.println("<script>window.location='SocialIMNewGetUserIcon.jsp?isclosed=true&requestFrom="+
		        requestFrom+"&isManager="+isManager+"&userId="+userId+"&subcompanyid="+
		        subcompanyid+"&iconUrl=/messager/usericon/"+iconName+"&loginid="+
		        loginid+"';parent.window.Electron.ipcRenderer.send('plugin-setUserIcon-cb');parent.window.Electron.currentWindow.close();</script>");
	} 
%>