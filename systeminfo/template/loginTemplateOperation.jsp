
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.security.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
String operationType="", sql="";
int subCompanyId = 0;
//Select LoginTemplate
if(request.getParameter("operationType")!=null){
	operationType = request.getParameter("operationType");
	String templateid = Util.null2String(request.getParameter("templateid"));
	if(operationType.equals("selectLoginTemplate")){
		int loginTemplateId = Util.getIntValue(request.getParameter("loginTemplateId"),0);
		sql = "UPDATE SystemLoginTemplate SET isCurrent='1' WHERE loginTemplateId="+loginTemplateId;
		rs.executeSql(sql);
		sql = "UPDATE SystemLoginTemplate SET isCurrent='0' WHERE loginTemplateId<>"+loginTemplateId;
		rs.executeSql(sql);
	}
	if(operationType.equals("delete")){	
		
		if(templateid.endsWith(",")){
			templateid = templateid.substring(0,templateid.length()-1);
		}
		
		sql = "DELETE FROM SystemLoginTemplate WHERE loginTemplateId in ("+templateid+")";
	
		rs.executeSql(sql);
	}
	if(operationType.equals("saveAs")){
		String tempatename = Util.null2String(request.getParameter("saveAsName"));
		sql = "INSERT INTO SystemLoginTemplate (lasteditdate,loginTemplateName,loginTemplateTitle,templateType,isCurrent,extendloginid,modeid,menuid,menutype,menutypeid,floatwidth, floatheight,windowwidth, windowheight,docId,openWindowLink,defaultshow,leftmenuid,leftmenustyleid,imageId,imageId2,backgroundColor,recordcode) select '"+TimeUtil.getCurrentDateString()+"','"+tempatename+"',loginTemplateTitle,templateType,0,extendloginid,modeid,menuid,menutype,menutypeid,floatwidth, floatheight,windowwidth, windowheight,docId,openWindowLink,defaultshow,leftmenuid,leftmenustyleid,imageId,imageId2,backgroundColor,recordcode from SystemLoginTemplate where logintemplateid = "+templateid;
		String from = Util.null2String(request.getParameter("from"));
		if("dialog".equals(from)){
			sql = "INSERT INTO SystemLoginTemplate (lasteditdate,loginTemplateName,loginTemplateTitle,templateType,isCurrent,extendloginid,modeid,menuid,menutype,menutypeid,floatwidth, floatheight,windowwidth, windowheight,docId,openWindowLink,defaultshow,leftmenuid,leftmenustyleid,imageId,imageId2,backgroundColor,recordcode) select '"+TimeUtil.getCurrentDateString()+"','"+tempatename+"',loginTemplateTitle,templateType,0,extendloginid,modeid,menuid,menutype,menutypeid,floatwidth, floatheight,windowwidth, windowheight,docId,openWindowLink,defaultshow,leftmenuid,leftmenustyleid,imageId,imageId2,backgroundColor,recordcode from SystemLoginTemplateTemp where logintemplateid = "+templateid;
		}
		rs.executeSql(sql);
		

		
		
		response.sendRedirect("loginTemplateSaveAs.jsp?from="+from+"&closeDialog=close");
		return;
	}

	response.sendRedirect("loginTemplateList.jsp");

//Edit LoginTemplate
}else{
	int loginTemplateId=0;
	String loginTemplateName="", loginTemplateTitle="", templateType="", imageId="", imageIdOld="",extendloginid="",loginTemplateModeid="",loginTemplateMenuId="",loginTemplateMenuType="",loginTemplateMenuTypeId="",floatwidth="", floatheight="",windowwidth="",windowheight="",docId="",openWindowLink="",defaultshow="";
	String imageId2Old = "";
	String imageId2OldTemp="";
	//H2背景颜色
	String backgroundColor = "";
	String recordcode = "";
	//H2背景图片2
	String imageId2 = "";
	String uploadPath = GCONST.getRootPath()+File.separatorChar+"LoginTemplateFile";
	String tempPath = GCONST.getRootPath()+File.separatorChar+"LoginTemplateFile"+File.separatorChar+"Temp";
	
	String leftmenuid="";
	String leftmenustyleid="";
	//自动创建目录：
	if(!new File(uploadPath).isDirectory())	new File(uploadPath).mkdirs();
	if(!new File(tempPath).isDirectory())		new File(tempPath).mkdirs();

	DiskFileUpload fu = new DiskFileUpload();
	//fu.setSizeMax(4194304);				//4MB
	fu.setSizeThreshold(4096);			//缓冲区大小4kb
	fu.setRepositoryPath(tempPath);

	List fileItems = fu.parseRequest(request);
	Iterator i = fileItems.iterator();
	try{
		while(i.hasNext()) {
			FileItem item = (FileItem)i.next();
			if(!item.isFormField()){
				String name = item.getName();
				if(Util.isExcuteFile(name)) continue;
				long size = item.getSize();
				if((name==null || name.equals("")) || size==0)	continue;

				//imageId = TimeUtil.getFormartString(Calendar.getInstance(),"yyyyMMddHHmmss");
                if(item.getFieldName().equals("imageId")) {
                    imageId = "img"+loginTemplateId+new Random().nextInt();
                    item.write(new File(uploadPath + File.separatorChar + imageId));
                } else if(item.getFieldName().equals("imageId2")) {
                	//imageId2 = "img"+loginTemplateId+new Random().nextInt();
                    //item.write(new File(uploadPath + File.separatorChar + imageId2));
                }else if(item.getFieldName().startsWith("imageId_")){
                	String imageId2temp= "img"+loginTemplateId+new Random().nextInt();
                	item.write(new File(uploadPath + File.separatorChar + imageId2temp));
                	imageId2=imageId2+","+imageId2temp;
                }
			}else{
				if(item.getFieldName().equals("operationType")) operationType=Util.null2String(item.getString("UTF-8"));
				if(item.getFieldName().equals("loginTemplateId")) loginTemplateId=Util.getIntValue(item.getString("UTF-8"));
				if(item.getFieldName().equals("imageIdOld")) imageIdOld=Util.null2String(item.getString("UTF-8"));
				if(item.getFieldName().equals("imageId2Old")) imageId2Old=Util.null2String(item.getString("UTF-8"));
				if(item.getFieldName().equals("loginTemplateName")) loginTemplateName=Util.null2String(item.getString("UTF-8"));
				if(item.getFieldName().equals("loginTemplateTitle")) loginTemplateTitle=Util.null2String(item.getString("UTF-8"));
				if(item.getFieldName().equals("templateType")) templateType=Util.null2String(item.getString("UTF-8"));
				if(item.getFieldName().equals("extendloginid")) extendloginid=Util.null2String(item.getString("UTF-8"));
				if(item.getFieldName().equals("modeid")) loginTemplateModeid=Util.null2String(item.getString("UTF-8"));
				if(item.getFieldName().equals("menuId")) loginTemplateMenuId=Util.null2String(item.getString("UTF-8"));
				if(item.getFieldName().equals("menuType")) loginTemplateMenuType=Util.null2String(item.getString("UTF-8"));
				if(item.getFieldName().equals("menuTypeId")) loginTemplateMenuTypeId=Util.null2String(item.getString("UTF-8"));
				
				if(item.getFieldName().equals("floatwidth")) floatwidth=Util.null2String(item.getString("UTF-8"));
				if(item.getFieldName().equals("floatheight")) floatheight=Util.null2String(item.getString("UTF-8"));
				if(item.getFieldName().equals("windowwidth")) windowwidth=Util.null2String(item.getString("UTF-8"));
				if(item.getFieldName().equals("windowheight")) windowheight=Util.null2String(item.getString("UTF-8"));
				
				if(item.getFieldName().equals("docId")) docId=Util.null2String(item.getString("UTF-8"));
				if(item.getFieldName().equals("openWindowLink")) openWindowLink=Util.null2String(item.getString("UTF-8"));
				if(item.getFieldName().equals("defaultshow")) defaultshow=Util.null2String(item.getString("UTF-8"));
				if(item.getFieldName().equals("leftmenuId")) leftmenuid=Util.null2String(item.getString("UTF-8"));
				if(item.getFieldName().equals("leftmenuTypeId")) leftmenustyleid=Util.null2String(item.getString("UTF-8"));
				if(item.getFieldName().equals("backgroundColor")) backgroundColor=Util.null2String(item.getString("UTF-8"));
				if(item.getFieldName().equals("recordcode")) recordcode=Util.null2String(item.getString("UTF-8"));
				if(item.getFieldName().equals("imageId2OldTemp")) imageId2OldTemp=Util.null2String(item.getString("UTF-8"));
				
			}
		}
	}catch(java.io.FileNotFoundException e){
		
	}
	if("".equals(defaultshow.trim()))
		defaultshow="#";
	boolean flag = true;
	rs.executeSql("select loginTemplateId from SystemLoginTemplate where imageId='"+imageIdOld+"' and loginTemplateId !="+loginTemplateId);
	while(rs.next()){
		flag = false;
	}
	if(!imageId.equals("")){
		File file = new File(uploadPath + File.separatorChar + imageIdOld);
        if(file != null && flag){
            file.delete();
        }
	}
	//幻灯片图片处理
	List imageId2List=Util.TokenizerString(imageId2,",");
	for(int k=0;k<imageId2List.size();k++){
		String imageId2temp=(String)imageId2List.get(k);
		int index=imageId2OldTemp.indexOf(",,");
		if(index!=-1){
			imageId2OldTemp=imageId2OldTemp.substring(0,index+1)+imageId2temp+imageId2OldTemp.substring(index+1);
		}else{
			imageId2OldTemp=imageId2OldTemp+imageId2temp+",";
		}
	}
	if(!imageId2OldTemp.startsWith(","))
		imageId2OldTemp=","+imageId2OldTemp;
	List imageId2OldList=Util.TokenizerString(imageId2Old,",");
	for(int k=0;k<imageId2OldList.size();k++){
		String imageId2temp=(String)imageId2OldList.get(k);
		if(imageId2OldTemp.indexOf(","+imageId2temp+",")==-1){ 
			flag = true;
			rs.executeSql("select loginTemplateId from SystemLoginTemplate where imageId2 like '%"+imageId2temp+"%' and loginTemplateId !="+loginTemplateId);
			while(rs.next()){
				flag = false;
			}
			File file = new File(uploadPath + File.separatorChar + imageId2temp);
            if(file != null && flag){
                file.delete();
            }
		}
	}
	if(Util.TokenizerString(imageId2OldTemp,",").size()==0)
		imageId2OldTemp="";
	imageId2OldTemp=imageId2OldTemp.replace(",,",",");
	//幻灯片图片处理
	
	imageId = imageId.equals("") ? imageIdOld : imageId;
	imageId2=imageId2OldTemp;
	
	backgroundColor=backgroundColor.equals("")?"#e8ebef":backgroundColor; //H2背景颜色
	
	if(operationType.equals("editLoginTemplate"))
	{	
		sql = "UPDATE SystemLoginTemplate SET lasteditdate='"+TimeUtil.getCurrentDateString()+"', loginTemplateName='"+loginTemplateName+"',loginTemplateTitle='"+loginTemplateTitle+"',templateType='"+templateType+"',imageId='"+imageId+"',extendloginid="+Util.getIntValue(extendloginid)+",modeid='"+loginTemplateModeid+"',menuid='"+loginTemplateMenuId+"',menutype='"+loginTemplateMenuType+"',menutypeid='"+loginTemplateMenuTypeId+"',floatwidth='"+floatwidth+"', floatheight='"+floatheight+"',windowwidth='"+windowwidth+"', windowheight='"+windowheight+"',docId='"+docId+"',openWindowLink='"+openWindowLink+"',defaultshow='"+defaultshow+"',leftmenuid='"+leftmenuid+"', leftmenustyleid='"+leftmenustyleid+"', imageId2='" + imageId2 + "', backgroundColor='" + backgroundColor + "' WHERE loginTemplateId="+loginTemplateId;
		rs.executeSql(sql);
		response.sendRedirect("loginTemplateEdit.jsp?id="+loginTemplateId+"&saved=true");
	}

	if(operationType.equals("saveasLoginTemplate")){

		sql = "INSERT INTO SystemLoginTemplate (lasteditdate,loginTemplateName,loginTemplateTitle,templateType,isCurrent,extendloginid,modeid,menuid,menutype,menutypeid,floatwidth, floatheight,windowwidth, windowheight,docId,openWindowLink,defaultshow,leftmenuid,leftmenustyleid) VALUES ('"+TimeUtil.getCurrentDateString()+"','"+loginTemplateName+"','"+loginTemplateTitle+"','"+templateType+"','0',"+Util.getIntValue(extendloginid)+",'"+loginTemplateModeid+"','"+loginTemplateMenuId+"','"+loginTemplateMenuType+"','"+loginTemplateMenuTypeId+"','"+floatwidth+"', '"+floatheight+"','"+windowwidth+"','"+windowheight+"','"+docId+"','"+openWindowLink+"','"+defaultshow+"','"+leftmenuid+"','"+leftmenustyleid+"')";

		rs.executeSql(sql);
		sql = "SELECT MAX(loginTemplateId) AS maxLoginTemplateId FROM SystemLoginTemplate";
		rs.executeSql(sql);

		if(rs.next()){
			sql = "UPDATE SystemLoginTemplate SET lasteditdate='"+TimeUtil.getCurrentDateString()+",'imageId='"+imageId+"', imageId2='"+imageId2+"' WHERE loginTemplateId="+rs.getInt("maxLoginTemplateId");
			rs.executeSql(sql);
		}
		
		response.sendRedirect("loginTemplateList.jsp");
	}

	if(operationType.equals("delete")){	
		sql = "DELETE FROM SystemLoginTemplate WHERE loginTemplateId="+loginTemplateId;
		rs.executeSql(sql);
		response.sendRedirect("loginTemplateList.jsp");
	}
}
%>