<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="java.security.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.*" %>

<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
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
String operationType="", sql="", sqlWhere="";

if(request.getParameter("operationType")!=null){
	operationType = request.getParameter("operationType");

	if(operationType.equals("open")){
		int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"));
		String openStr = Util.null2String(request.getParameter("openStr"));
		boolean includeClose = false;

		ArrayList tmp = Util.TokenizerString(openStr,"*");
		ArrayList ids,values;
		ids = Util.TokenizerString((String)tmp.get(0),",");
		values = Util.TokenizerString((String)tmp.get(1),",");
		for(int i=0;i<ids.size();i++){
			sql = "UPDATE SystemTemplate SET isOpen='"+values.get(i)+"' WHERE id="+ids.get(i);
			rs.executeSql(sql);
			if(((String)values.get(i)).equals("0")){
				includeClose = true;
				sqlWhere+=" OR templateId="+ids.get(i);
			}
		}

		//
		if(includeClose){
			int forceTemplateId = 1;
			sql = "SELECT id FROM SystemTemplate WHERE companyId="+subCompanyId+" AND isOpen='1' ORDER BY id ASC";
			rs.executeSql(sql);
			if (rs.next()) forceTemplateId=rs.getInt("id");

			sql = "SELECT userid FROM SystemTemplateUser WHERE 1=2"+sqlWhere;
			rs.executeSql(sql);
			while(rs.next()){
				sqlWhere += " OR userId="+rs.getInt("userid");
			}
			sql = "UPDATE SystemTemplateUser SET templateId="+forceTemplateId+" WHERE 1=2"+sqlWhere;
			rs.executeSql(sql);
		}

		//指定模板
		int tId = Util.getIntValue(request.getParameter("tId"),-1);

		//================================================================
		//TD4908
		boolean subcompanyHasTemplate = false;
		rs.execute("SELECT templateid FROM SystemTemplateSubComp WHERE subcompanyid="+subCompanyId+"");
		if(rs.next()){
			subcompanyHasTemplate = true;
		}
		if(subcompanyHasTemplate){
			rs.execute("UPDATE SystemTemplateSubComp SET templateid="+tId+" WHERE subcompanyid="+subCompanyId+"");
		}else{
			rs.execute("INSERT INTO SystemTemplateSubComp VALUES ("+subCompanyId+", "+tId+")");
		}
		//================================================================
		if(tId!=-1){
			sql = "UPDATE SystemTemplateUser SET templateId="+tId+" WHERE userid IN (SELECT id FROM HrmResource WHERE subcompanyid1="+subCompanyId+")";
			rs.executeSql(sql);
		}

		response.sendRedirect("templateList.jsp?subCompanyId="+subCompanyId);
		return;
	}
	
	/* 更换(选择)模板 */
	if(operationType.equals("selectTemplate")){
		int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"));
		int userId = 0;
		userId = user.getUID();
		int templateId = Util.getIntValue(request.getParameter("templateId"));
		sql = "SELECT templateId FROM SystemTemplateUser WHERE userid="+userId;
		rs.executeSql(sql);
		if(rs.next()){
			sql = "UPDATE SystemTemplateUser SET templateId="+templateId+" WHERE userid="+userId;
			rs.executeSql(sql);
		}else{
			sql = "INSERT INTO SystemTemplateUser (userId,templateId) VALUES ("+userId+","+templateId+")";
			rs.executeSql(sql);
		}
		response.sendRedirect("templateSelect.jsp?subCompanyId="+subCompanyId);
		return;
	}

}else{
	String sqlTemp = "";
	int templateId = 0;
	int subCompanyId = 0;
	String templateName = "";
	String topBgColor = "";
	String toolbarBgColor = "";
	String leftbarBgColor = "";
	String leftbarFontColor = "";
	//String leftMenuBgColor = "";
	//String leftMenuFontColor = "";
	String menubarBgColor = "";
	String menubtnBgColor = "";
	String menubtnBgColorActive = "";
	String menubtnBgColorHover = "";
	String menubtnBorderColorActive = "";
	String menubtnBorderColorHover = "";
	String menubtnFontColor = "";
	String isShowMainMenu = "";
	String templateTitle = "";

	String logoHidden = "";
	String topBgImageHidden = "";
	String toolbarBgImageHidden = "";
	String leftbarBgImageHidden = "";
	String leftbarBgImageHHidden = "";

	//图片
	String logo = "";
	String logoBottom ="";
	String topBgImage = "";
	String toolbarBgImage = "";
	String leftbarBgImage = "";
	String leftbarBgImageH = "";
	String menuborderbg = "";
	String menuInBoldBorderbg = "";
	String menuBottomCusbg = "";

	String bgImage = "";
	String defaultHp="";

	String uploadPath = GCONST.getRootPath()+File.separatorChar+"TemplateFile";
	String tempPath = GCONST.getRootPath()+File.separatorChar+"TemplateFile"+File.separatorChar+"Temp";
	//自动创建目录
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
				//if(Util.isExcuteFile(name)) continue;
				long size = item.getSize();
				if((name==null || name.equals("")) || size==0)	continue;
				if(!validateFileExt(name)) continue;
				if(item.getFieldName().equals("logo")){
					name = name.replace('\\','/');
					File fullFile = new File(name);
					File savedFile = new File(uploadPath+File.separatorChar ,"logo_"+templateId+"_"+fullFile.getName());
					item.write(savedFile);
					sqlTemp += ",logo='logo_"+templateId+"_"+fullFile.getName()+"'";
					logo = "logo_"+templateId+"_"+fullFile.getName();
				}
				if(item.getFieldName().equals("logoBottom")){
					name = name.replace('\\','/');
					File fullFile = new File(name);
					File savedFile = new File(uploadPath+File.separatorChar ,"logoBottom_"+templateId+"_"+fullFile.getName());
					item.write(savedFile);
					sqlTemp += ",logoBottom='logoBottom_"+templateId+"_"+fullFile.getName()+"'";
					logoBottom = "logoBottom_"+templateId+"_"+fullFile.getName();
				}
				if(item.getFieldName().equals("topBgImage")){
					name = name.replace('\\','/');
					File fullFile = new File(name);
					File savedFile = new File(uploadPath+File.separatorChar ,"topBgImage_"+templateId+"_"+fullFile.getName());
					item.write(savedFile);
					sqlTemp += ",topBgImage='topBgImage_"+templateId+"_"+fullFile.getName()+"'";
					topBgImage = "logo_"+templateId+"_"+fullFile.getName();
				}
				if(item.getFieldName().equals("toolbarBgImage")){
					name = name.replace('\\','/');
					File fullFile = new File(name);
					File savedFile = new File(uploadPath+File.separatorChar ,"toolbarBgImage_"+templateId+"_"+fullFile.getName());
					item.write(savedFile);
					sqlTemp += ",toolbarBgImage='toolbarBgImage_"+templateId+"_"+fullFile.getName()+"'";
					toolbarBgImage = "toolbarBgImage_"+templateId+"_"+fullFile.getName();
				}
				if(item.getFieldName().equals("leftbarBgImage")){
					name = name.replace('\\','/');
					File fullFile = new File(name);
					File savedFile = new File(uploadPath+File.separatorChar ,"leftbarBgImage_"+templateId+"_"+fullFile.getName());
					item.write(savedFile);
					sqlTemp += ",leftbarBgImage='leftbarBgImage_"+templateId+"_"+fullFile.getName()+"'";
					leftbarBgImage = "leftbarBgImage_"+templateId+"_"+fullFile.getName();
				}
				if(item.getFieldName().equals("leftbarBgImageH")){
					name = name.replace('\\','/');
					File fullFile = new File(name);
					File savedFile = new File(uploadPath+File.separatorChar ,"leftbarBgImageH_"+templateId+"_"+fullFile.getName());
					item.write(savedFile);
					sqlTemp += ",leftbarBgImageH='leftbarBgImageH_"+templateId+"_"+fullFile.getName()+"'";
					leftbarBgImageH = "leftbarBgImageH_"+templateId+"_"+fullFile.getName();
				}
				if(item.getFieldName().equals("menuborderbg")){
					name = name.replace('\\','/');
					File fullFile = new File(name);
					File savedFile = new File(uploadPath+File.separatorChar ,"menuborderbg_"+templateId+"_"+fullFile.getName());
					item.write(savedFile);
					sqlTemp += ",menuborderbg='menuborderbg_"+templateId+"_"+fullFile.getName()+"'";
					menuborderbg = "menuborderbg_"+templateId+"_"+fullFile.getName();
				}
				if(item.getFieldName().equals("menuInBoldBorderbg")){
					name = name.replace('\\','/');
					File fullFile = new File(name);
					File savedFile = new File(uploadPath+File.separatorChar ,"menuInBoldBorderbg_"+templateId+"_"+fullFile.getName());
					item.write(savedFile);
					sqlTemp += ",menuInBoldBorderbg='menuInBoldBorderbg_"+templateId+"_"+fullFile.getName()+"'";
					menuInBoldBorderbg = "menuInBoldBorderbg_"+templateId+"_"+fullFile.getName();
				}
				if(item.getFieldName().equals("menuBottomCusbg")){
					name = name.replace('\\','/');
					File fullFile = new File(name);
					File savedFile = new File(uploadPath+File.separatorChar ,"menuBottomCusbg_"+templateId+"_"+fullFile.getName());
					item.write(savedFile);
					sqlTemp += ",menuBottomCusbg='menuBottomCusbg_"+templateId+"_"+fullFile.getName()+"'";
					menuBottomCusbg = "menuBottomCusbg_"+templateId+"_"+fullFile.getName();

				}


			}else{
				if(item.getFieldName().equals("logoHidden"))						logo = Util.null2String(item.getString());
				if(item.getFieldName().equals("logoBottomHidden"))					logoBottom = Util.null2String(item.getString());
				if(item.getFieldName().equals("topBgImageHidden"))				topBgImage = Util.null2String(item.getString());
				if(item.getFieldName().equals("toolbarBgImageHidden"))		toolbarBgImage = Util.null2String(item.getString());
				if(item.getFieldName().equals("leftbarBgImageHidden"))		leftbarBgImage = Util.null2String(item.getString());
				if(item.getFieldName().equals("leftbarBgImageHHidden"))		leftbarBgImageH = Util.null2String(item.getString());
				if(item.getFieldName().equals("operationType"))					operationType = Util.null2String(item.getString());
				if(item.getFieldName().equals("id"))								templateId = Util.getIntValue(item.getString());
				if(item.getFieldName().equals("subCompanyId"))					subCompanyId = Util.getIntValue(item.getString());
				if(item.getFieldName().equals("templateName"))					templateName = Util.null2String(item.getString("GBK"));
				if(item.getFieldName().equals("topBgColor"))						topBgColor = Util.null2String(item.getString());
				if(item.getFieldName().equals("toolbarBgColor"))				toolbarBgColor = Util.null2String(item.getString());
				if(item.getFieldName().equals("leftbarBgColor"))				leftbarBgColor = Util.null2String(item.getString());
				if(item.getFieldName().equals("leftbarFontColor"))				leftbarFontColor = Util.null2String(item.getString());
				//MainMenu
				if(item.getFieldName().equals("menubarBgColor"))				menubarBgColor = Util.null2String(item.getString());
				if(item.getFieldName().equals("menubtnBgColor"))				menubtnBgColor = Util.null2String(item.getString());
				if(item.getFieldName().equals("menubtnBgColorActive"))		menubtnBgColorActive = Util.null2String(item.getString());
				if(item.getFieldName().equals("menubtnBgColorHover"))			menubtnBgColorHover = Util.null2String(item.getString());
				if(item.getFieldName().equals("menubtnBorderColorActive"))	menubtnBorderColorActive = Util.null2String(item.getString());
				if(item.getFieldName().equals("menubtnBorderColorHover"))	menubtnBorderColorHover = Util.null2String(item.getString());
				if(item.getFieldName().equals("menubtnFontColor"))				menubtnFontColor = Util.null2String(item.getString());
				if(item.getFieldName().equals("isShowMainMenu"))				isShowMainMenu = Util.null2String(item.getString());

				if(item.getFieldName().equals("menuborderbgHidden"))		menuborderbg = Util.null2String(item.getString());
				if(item.getFieldName().equals("menuInBoldBorderbgHidden"))		menuInBoldBorderbg = Util.null2String(item.getString());
				if(item.getFieldName().equals("menuBottomCusbgHidden"))		menuBottomCusbg = Util.null2String(item.getString());

				if(item.getFieldName().equals("templateTitle"))					templateTitle = Util.null2String(item.getString("GBK"));
				//DeleteImage
				if(item.getFieldName().equals("bgImage"))							bgImage = Util.null2String(item.getString());
				if(item.getFieldName().equals("defaultHp"))							defaultHp = Util.null2String(item.getString());
			}
		}
	}catch(java.io.FileNotFoundException e){
		//TODO
	}

	isShowMainMenu = isShowMainMenu.equals("") ? "0" : "1";

	/* 编辑模板 */ 
	if(operationType.equals("edit")){
		//sql = "UPDATE SystemTemplate SET templateName='"+templateName+"',topBgColor='"+topBgColor+"',toolbarBgColor='"+toolbarBgColor+"',leftbarBgColor='"+leftbarBgColor+"',leftbarFontColor='"+leftbarFontColor+"',menubarBgColor='"+menubarBgColor+"',menubtnBgColor='"+menubtnBgColor+"',menubtnBgColorActive='"+menubtnBgColorActive+"',menubtnBgColorHover='"+menubtnBgColorHover+"',menubtnBorderColorActive='"+menubtnBorderColorActive+"',menubtnBorderColorHover='"+menubtnBorderColorHover+"',menubtnFontColor='"+menubtnFontColor+"',templateTitle='"+templateTitle+"',extendtempletid=0,isShowMainMenu='"+isShowMainMenu+"'"+sqlTemp+" WHERE id="+templateId;
		sql = "UPDATE SystemTemplate SET templateName='"+templateName+"',topBgColor='"+topBgColor+"',toolbarBgColor='"+toolbarBgColor+"',leftbarBgColor='"+leftbarBgColor+"',leftbarFontColor='"+leftbarFontColor+"',menubarBgColor='"+menubarBgColor+"',menubtnBgColor='"+menubtnBgColor+"',menubtnBgColorActive='"+menubtnBgColorActive+"',menubtnBgColorHover='"+menubtnBgColorHover+"',menubtnBorderColorActive='"+menubtnBorderColorActive+"',menubtnBorderColorHover='"+menubtnBorderColorHover+"',menubtnFontColor='"+menubtnFontColor+"',templateTitle='"+templateTitle+"',extendtempletid=0,defaultHp='"+defaultHp+"',isShowMainMenu='"+isShowMainMenu+"'"+sqlTemp+" WHERE id="+templateId;

		//out.println(sql);
		rs.executeSql(sql);

		//Hide SystemSettingLeftMenu
		/*if(isShowMainMenu.equals("1")){
			int hideWhoseMenu=0;
			sql = "SELECT companyId FROM SystemTemplate WHERE id="+templateId;
			rs.executeSql(sql);
			if(rs.next())	{hideWhoseMenu=rs.getInt("companyId");}

			sql = hideWhoseMenu==0 ? "UPDATE LeftMenuConfig SET visible='0' WHERE infoid=114" : "UPDATE LeftMenuConfig SET visible='0' WHERE infoid=114 AND userid IN (SELECT id FROM HrmResource WHERE subcompanyid1="+hideWhoseMenu+")";
			rs.executeSql(sql);
		}*/

		response.sendRedirect("templateEdit.jsp?id="+templateId+"&subCompanyId="+subCompanyId);
		return;
	}

	/* 另存模板 */
	if(operationType.equals("saveas")){
		//sql = "INSERT INTO SystemTemplate (templateName,companyId,logo,topBgColor,topBgImage,toolbarBgColor,toolbarBgImage,leftbarBgColor,leftbarBgImage,leftbarBgImageH,leftbarFontColor,menubarBgColor,menubtnBgColor,menubtnBgColorActive,menubtnBgColorHover,menubtnBorderColorActive,menubtnBorderColorHover,menubtnFontColor,templateTitle,isShowMainMenu,menuborderbg,menuInBoldBorderbg,menuBottomCusbg) VALUES ('"+templateName+"',"+subCompanyId+",'"+logo+"','"+topBgColor+"','"+topBgImage+"','"+toolbarBgColor+"','"+toolbarBgImage+"','"+leftbarBgColor+"','"+leftbarBgImage+"','"+leftbarBgImageH+"','"+leftbarFontColor+"','"+menubarBgColor+"','"+menubtnBgColor+"','"+menubtnBgColorActive+"','"+menubtnBgColorHover+"','"+menubtnBorderColorActive+"','"+menubtnBorderColorHover+"','"+menubtnFontColor+"','"+templateTitle+"','"+isShowMainMenu+"','"+menuborderbg+"','"+menuInBoldBorderbg+"','"+menuBottomCusbg+"')";
		sql = "INSERT INTO SystemTemplate (templateName,companyId,logo,topBgColor,topBgImage,toolbarBgColor,toolbarBgImage,leftbarBgColor,leftbarBgImage,leftbarBgImageH,leftbarFontColor,menubarBgColor,menubtnBgColor,menubtnBgColorActive,menubtnBgColorHover,menubtnBorderColorActive,menubtnBorderColorHover,menubtnFontColor,templateTitle,isShowMainMenu,menuborderbg,menuInBoldBorderbg,menuBottomCusbg,defaultHp) VALUES ('"+templateName+"',"+subCompanyId+",'"+logo+"','"+topBgColor+"','"+topBgImage+"','"+toolbarBgColor+"','"+toolbarBgImage+"','"+leftbarBgColor+"','"+leftbarBgImage+"','"+leftbarBgImageH+"','"+leftbarFontColor+"','"+menubarBgColor+"','"+menubtnBgColor+"','"+menubtnBgColorActive+"','"+menubtnBgColorHover+"','"+menubtnBorderColorActive+"','"+menubtnBorderColorHover+"','"+menubtnFontColor+"','"+templateTitle+"','"+isShowMainMenu+"','"+menuborderbg+"','"+menuInBoldBorderbg+"','"+menuBottomCusbg+"','"+defaultHp+"')";
		//out.println(sql);
		rs.executeSql(sql);
	}

	/* 恢复模板 */
	if(operationType.equals("resetTemplate")){
		//sql = "UPDATE SystemTemplate SET templateName='Ecology默认模板',companyId=0,logo='',topBgColor='#172971',topBgImage='',toolbarBgColor='#DDDDDD',toolbarBgImage='',leftbarBgColor='#C4C4C4',leftbarBgImage='',leftbarBgImageH='',leftbarFontColor='#444444',menubarBgColor='#172971',menubtnBgColor='#172971',menubtnBgColorActive='#42549E',menubtnBgColorHover='#42549E',menubtnBorderColorActive='#172971',menubtnBorderColorHover='#172971',menubtnFontColor='#FFFFFF',templateTitle='高效源于协同',menuborderbg='',menuInBoldBorderbg='',menuBottomCusbg='' WHERE id=1";
				sql = "UPDATE SystemTemplate SET templateName='Ecology默认模板',companyId=0,logo='',topBgColor='#172971',topBgImage='',toolbarBgColor='#DDDDDD',toolbarBgImage='',leftbarBgColor='#C4C4C4',leftbarBgImage='',leftbarBgImageH='',leftbarFontColor='#444444',menubarBgColor='#172971',menubtnBgColor='#172971',menubtnBgColorActive='#42549E',menubtnBgColorHover='#42549E',menubtnBorderColorActive='#172971',menubtnBorderColorHover='#172971',menubtnFontColor='#FFFFFF',templateTitle='高效源于协同',menuborderbg='',menuInBoldBorderbg='',menuBottomCusbg='',defaultHp='' WHERE id=1";
		//out.println(sql);
		rs.executeSql(sql);
		response.sendRedirect("templateList.jsp?subCompanyId="+subCompanyId);
		return;
	}

	/* 删除模板 */
	if(operationType.equals("delete")){
		sql = "DELETE FROM SystemTemplate WHERE id="+templateId;
		rs.executeSql(sql);
		response.sendRedirect("templateList.jsp?subCompanyId="+subCompanyId);
		return;
	}

	if(operationType.equals("deleteBgImage")){
		sql = "UPDATE SystemTemplate SET "+bgImage+"='0' WHERE id="+templateId;
		//out.println(sql);
		rs.executeSql(sql);
		response.sendRedirect("templateEdit.jsp?id="+templateId+"&subCompanyId="+subCompanyId);
		return;
	}

	response.sendRedirect("templateList.jsp?subCompanyId="+subCompanyId);
}
%>