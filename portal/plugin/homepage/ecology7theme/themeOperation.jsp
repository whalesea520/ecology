
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.page.common.HomepageFileUpload" %>
<%@page import="java.io.StringBufferInputStream"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpsu" class="weaver.homepage.style.HomepageStyleUtil" scope="page"/>
<%
	HomepageFileUpload fu = new HomepageFileUpload(request,false,"others");

	String method = Util.null2String(fu.getParameter("method"));	
	int templateId = Util.getIntValue(fu.getParameter("templateId"));	
	int subCompanyId = Util.getIntValue(fu.getParameter("subCompanyId"));
	int extendtempletid = Util.getIntValue(fu.getParameter("extendtempletid"));
	
	int extandHpThemeId = Util.getIntValue(fu.getParameter("extandHpThemeId"),0);
	int extandHpThemeItemId = Util.getIntValue(fu.getParameter("extandHpThemeItemId"),0);
	
	String theme = Util.null2String(fu.getParameter("theme"));
	String skin = Util.null2String(fu.getParameter("skin"));
	
	String templateName = Util.null2String(fu.getParameter("templateName"));
	String templateTitle = Util.null2String(fu.getParameter("templateTitle"));
	
	String logoTop = Util.null2String(fu.uploadFiles("logoTop"));
	String logoBottom = Util.null2String(fu.uploadFiles("logoBottom"));
	
	
	//新增配置项 Start
	
	String bodyBg = Util.null2String(fu.uploadFiles("bodyBg"));
	String topBgImage = Util.null2String(fu.uploadFiles("topBgImage"));
	String toolbarBgColor = Util.null2String(fu.uploadFiles("toolbarBgColor"));
	String menuborderColor = Util.null2String(fu.getParameter("menuborderColor"));
	
	String leftbarBgImage = Util.null2String(fu.uploadFiles("leftbarBgImage"));
	String leftbarBgImageH = Util.null2String(fu.uploadFiles("leftbarBgImageH"));
	
	String leftbarborderColor = Util.null2String(fu.getParameter("leftbarborderColor"));
	String leftbarFontColor = Util.null2String(fu.getParameter("leftbarFontColor"));
	
	String topleftbarBgImage_left = Util.null2String(fu.uploadFiles("topleftbarBgImage_left"));
	String topleftbarBgImage_center = Util.null2String(fu.uploadFiles("topleftbarBgImage_center"));
	String topleftbarBgImage_right = Util.null2String(fu.uploadFiles("topleftbarBgImage_right"));
	
	String bottomleftbarBgImage_left = Util.null2String(fu.uploadFiles("bottomleftbarBgImage_left"));
	String bottomleftbarBgImage_center = Util.null2String(fu.uploadFiles("bottomleftbarBgImage_center"));
	String bottomleftbarBgImage_right = Util.null2String(fu.uploadFiles("bottomleftbarBgImage_right"));
	
	if ("ecology7".equals(theme)) {
		Map cssMap = new HashMap();
		copyFile(getBgImageRealAddr(hpsu, Util.null2String(fu.uploadFiles("leftBlockTopBgLeft"))), "/wui/theme/ecology7/skins/" + skin + "/page/left/leftBlockTopBgLeft_wev8.jpg");
		copyFile(getBgImageRealAddr(hpsu, Util.null2String(fu.uploadFiles("leftBlockTopBgCenter"))),    "/wui/theme/ecology7/skins/" + skin + "/page/left/leftBlockTopBgCenter_wev8.jpg");
		copyFile(getBgImageRealAddr(hpsu, Util.null2String(fu.uploadFiles("leftBlockTopBgRight"))),      "/wui/theme/ecology7/skins/" + skin + "/page/left/leftBlockTopBgRight_wev8.jpg");
		copyFile(getBgImageRealAddr(hpsu, Util.null2String(fu.uploadFiles("leftBlockHrmInfoBgLeft"))),  "/wui/theme/ecology7/skins/" + skin + "/page/left/leftBlockHrmInfoBgLeft_wev8.png");
		copyFile(getBgImageRealAddr(hpsu, Util.null2String(fu.uploadFiles("leftBlockHrmInfoBgCenter"))), "/wui/theme/ecology7/skins/" + skin + "/page/left/leftBlockHrmInfoBgCenter_wev8.png");
		copyFile(getBgImageRealAddr(hpsu, Util.null2String(fu.uploadFiles("leftBlockHrmInfoBgRight"))), "/wui/theme/ecology7/skins/" + skin + "/page/left/leftBlockHrmInfoBgRight_wev8.png");
		copyFile(getBgImageRealAddr(hpsu, Util.null2String(fu.uploadFiles("leftMenuBottomLeft"))), "/wui/theme/ecology7/skins/" + skin + "/page/left/leftMenuBottomLeft_wev8.png");
		copyFile(getBgImageRealAddr(hpsu, Util.null2String(fu.uploadFiles("leftMenuBottomCenter"))), "/wui/theme/ecology7/skins/" + skin + "/page/left/leftMenuBottomCenter_wev8.png");
		copyFile(getBgImageRealAddr(hpsu, Util.null2String(fu.uploadFiles("leftMenuBottomRight"))), "/wui/theme/ecology7/skins/" + skin + "/page/left/leftMenuBottomRight_wev8.png");
		copyFile(getBgImageRealAddr(hpsu, Util.null2String(fu.uploadFiles("leftMenuItemLeft"))), "/wui/theme/ecology7/skins/" + skin + "/page/left/leftMenuItemLeft_wev8.png");
		copyFile(getBgImageRealAddr(hpsu, Util.null2String(fu.uploadFiles("leftMenuItemCenter"))), "/wui/theme/ecology7/skins/" + skin + "/page/left/leftMenuItemCenter_wev8.png");
		copyFile(getBgImageRealAddr(hpsu, Util.null2String(fu.uploadFiles("leftMenuItemRight"))), "/wui/theme/ecology7/skins/" + skin + "/page/left/leftMenuItemRight_wev8.png");
		copyFile(getBgImageRealAddr(hpsu, Util.null2String(fu.uploadFiles("leftMenuItemNavLeft"))), "/wui/theme/ecology7/skins/" + skin + "/page/left/leftMenuItemNavLeft_wev8.png");
		copyFile(getBgImageRealAddr(hpsu, Util.null2String(fu.uploadFiles("leftMenuItemNavCenter"))), "/wui/theme/ecology7/skins/" + skin + "/page/left/leftMenuItemNavCenter_wev8.png");
		copyFile(getBgImageRealAddr(hpsu, Util.null2String(fu.uploadFiles("leftMenuItemNavRight"))), "/wui/theme/ecology7/skins/" + skin + "/page/left/leftMenuNavRight_wev8.png");
		
		cssMark(cssMap, "#leftmenucontainer", "background", Util.null2String(fu.getParameter("leftmenucontainer")));
		cssMark(cssMap, "#drillcrumb", "background", Util.null2String(fu.getParameter("drillcrumb")));
		cssMark(cssMap, ".leftMenuBottomNavDiv", "background", Util.null2String(fu.getParameter("leftMenuBottomNavDiv")));
		cssMark(cssMap, "#leftmenu-bottom", "background-color", Util.null2String(fu.getParameter("leftmenu_bottom")));
		cssMark(cssMap, ".leftmenutopnavdiv", "border-top", Util.null2String(fu.getParameter("leftMenuTopNavDiv")));
		cssMark(cssMap, "#drillcrumb", "border-left", Util.null2String(fu.getParameter("drillcrumb_border_left")));
		cssMark(cssMap, "#drillcrumb", "border-top", Util.null2String(fu.getParameter("drillcrumb_border_top")));
		cssMark(cssMap, "#drillcrumb", "border-right", Util.null2String(fu.getParameter("drillcrumb_border_right")));
		cssMark(cssMap, "#drillcrumb", "border-bottom", Util.null2String(fu.getParameter("drillcrumb_border_bottom")));
		cssMark(cssMap, ".leftmenubottomnavdiv", "border-top", Util.null2String(fu.getParameter("leftMenuBottomNavDiv_border")));
		cssMark(cssMap, ".leftmenubottomnavtbl", "border-left", Util.null2String(fu.getParameter("leftMenuBottomNavTbl_left")));
		cssMark(cssMap, ".leftmenubottomnavtbl", "border-top", Util.null2String(fu.getParameter("leftMenuBottomNavTbl_top")));
		cssMark(cssMap, ".leftmenubottomnavtbl", "border-right", Util.null2String(fu.getParameter("leftMenuBottomNavTbl_right")));
		cssMark(cssMap, ".leftmenubottomnavtbl", "border-bottom", Util.null2String(fu.getParameter("leftMenuBottomNavTbl_bottom")));
		
		String cssString = cssMark(cssMap);
		String projectPath = this.getServletConfig().getServletContext().getRealPath("/");
		if (projectPath.lastIndexOf("/") != (projectPath.length() - 1) && projectPath.lastIndexOf("\\") != (projectPath.length() - 1)) {
			projectPath += "/";
		}
		writerCss(projectPath + "wui/theme/ecology7/skins/" + skin + "/page/left_wev8.css", cssString);
	}
	
	//新增配置项END
	
	StringBuffer sbupdate = new StringBuffer();
	
	if (!"".equals(logoTop)) {
		//logoTop = hpsu.getRealAddr(logoTop);
		sbupdate.append(", logoTop='");
		sbupdate.append(logoTop);
		sbupdate.append("'");
		
	}
	
	if (!"".equals(logoBottom)) {
		logoBottom = hpsu.getRealAddr(logoBottom);
		sbupdate.append(", logoBottom='");
		sbupdate.append(logoBottom);
		sbupdate.append("'");
	}
	
	if (!"".equals(bodyBg)) {
		bodyBg = hpsu.getRealAddr(bodyBg);
		sbupdate.append(", bodyBg='");
		sbupdate.append(bodyBg);
		sbupdate.append("'");
	}
	if (!"".equals(topBgImage)) {
		topBgImage = hpsu.getRealAddr(topBgImage);
		sbupdate.append(", topBgImage='");
		sbupdate.append(topBgImage);
		sbupdate.append("'");
	}
	if (!"".equals(toolbarBgColor)) {
		sbupdate.append(", toolbarBgColor='");
		sbupdate.append(toolbarBgColor);
		sbupdate.append("'");
	}
	
	if (!"".equals(leftbarBgImage)) {
		leftbarBgImage = hpsu.getRealAddr(leftbarBgImage);
		sbupdate.append(", leftbarBgImage='");
		sbupdate.append(leftbarBgImage);
		sbupdate.append("'");
	}
	if (!"".equals(leftbarBgImageH)) {
		leftbarBgImageH = hpsu.getRealAddr(leftbarBgImageH);
		sbupdate.append(", leftbarBgImageH='");
		sbupdate.append(leftbarBgImageH);
		sbupdate.append("'");
	}
	
	if (!"".equals(topleftbarBgImage_left)) {
		topleftbarBgImage_left = hpsu.getRealAddr(topleftbarBgImage_left);
		sbupdate.append(", topleftbarBgImage_left='");
		sbupdate.append(topleftbarBgImage_left);
		sbupdate.append("'");
	}
	if (!"".equals(topleftbarBgImage_center)) {
		topleftbarBgImage_center = hpsu
				.getRealAddr(topleftbarBgImage_center);
		sbupdate.append(", topleftbarBgImage_center='");
		sbupdate.append(topleftbarBgImage_center);
		sbupdate.append("'");
	}
	if (!"".equals(topleftbarBgImage_right)) {
		topleftbarBgImage_right = hpsu.getRealAddr(topleftbarBgImage_right);
		sbupdate.append(", topleftbarBgImage_right='");
		sbupdate.append(topleftbarBgImage_right);
		sbupdate.append("'");
	}
	if (!"".equals(bottomleftbarBgImage_left)) {
		bottomleftbarBgImage_left = hpsu
				.getRealAddr(bottomleftbarBgImage_left);
		sbupdate.append(", bottomleftbarBgImage_left='");
		sbupdate.append(bottomleftbarBgImage_left);
		sbupdate.append("'");
	}
	if (!"".equals(bottomleftbarBgImage_center)) {
		bottomleftbarBgImage_center = hpsu
				.getRealAddr(bottomleftbarBgImage_center);
		sbupdate.append(", bottomleftbarBgImage_center='");
		sbupdate.append(bottomleftbarBgImage_center);
		sbupdate.append("'");
	}
	if (!"".equals(bottomleftbarBgImage_right)) {
		bottomleftbarBgImage_right = hpsu
				.getRealAddr(bottomleftbarBgImage_right);
		sbupdate.append(", bottomleftbarBgImage_right='");
		sbupdate.append(bottomleftbarBgImage_right);
		sbupdate.append("'");
	}
	
	sbupdate.append(", menuborderColor='");
	sbupdate.append(menuborderColor);
	sbupdate.append("'");
	
	sbupdate.append(", leftbarborderColor='");
	sbupdate.append(leftbarborderColor);
	sbupdate.append("'");
	
	sbupdate.append(", leftbarFontColor='");
	sbupdate.append(leftbarFontColor);
	sbupdate.append("'");
	
	String strUpdate = sbupdate.toString().replaceAll("^,", "");
	if("edit".equals(method)){
		String sql="";
		if(extandHpThemeId == 0){
			sql=new StringBuffer("insert into extandHpTheme(templateId, subCompanyId) values (")
					.append(templateId).append(", ").append(subCompanyId).append(")").toString();
			rs.executeSql(sql);
			rs.executeSql("select max(id) from extandHpTheme");
			if(rs.next()) {
				extandHpThemeId = rs.getInt(1);
			} 
			rs.execute("insert into extandHpThemeItem(extandHpThemeId, theme, skin, logoTop, logoBottom, bodyBg, topBgImage, toolbarBgColor, menuborderColor, leftbarBgImage, leftbarBgImageH, leftbarborderColor, leftbarFontColor, topleftbarBgImage_left, topleftbarBgImage_center, topleftbarBgImage_right, bottomleftbarBgImage_left, bottomleftbarBgImage_center, bottomleftbarBgImage_right) values(" + extandHpThemeId + ",'" + theme + "', '" + skin + "', '" + logoTop + "', '" + logoBottom  + "', '" + bodyBg + "', '" + topBgImage + "', '" + toolbarBgColor + "', '" + menuborderColor + "', '" + leftbarBgImage + "', '" + leftbarBgImageH + "', '" + leftbarborderColor + "', '" + leftbarFontColor + "', '" + topleftbarBgImage_left + "', '" + topleftbarBgImage_center + "', '" + topleftbarBgImage_right + "', '" + bottomleftbarBgImage_left + "', '" + bottomleftbarBgImage_center + "', '" + bottomleftbarBgImage_right + "')");
		} else {
			if(!"".equals(strUpdate)) {
				if (extandHpThemeItemId == 0) {
					sql = "insert into extandHpThemeItem(extandHpThemeId, theme, skin, logoTop, logoBottom, bodyBg, topBgImage, toolbarBgColor, menuborderColor, leftbarBgImage, leftbarBgImageH, leftbarborderColor, leftbarFontColor, topleftbarBgImage_left, topleftbarBgImage_center, topleftbarBgImage_right, bottomleftbarBgImage_left, bottomleftbarBgImage_center, bottomleftbarBgImage_right) values(" + extandHpThemeId + ",'" + theme + "', '" + skin + "', '" + logoTop + "', '" + logoBottom  + "', '" + bodyBg + "', '" + topBgImage + "', '" + toolbarBgColor + "', '" + menuborderColor + "', '" + leftbarBgImage + "', '" + leftbarBgImageH + "', '" + leftbarborderColor + "', '" + leftbarFontColor + "', '" + topleftbarBgImage_left + "', '" + topleftbarBgImage_center + "', '" + topleftbarBgImage_right + "', '" + bottomleftbarBgImage_left + "', '" + bottomleftbarBgImage_center + "', '" + bottomleftbarBgImage_right + "')";
				} else {
					sql = new StringBuffer("update extandHpThemeItem set ").append(strUpdate).append(" where id=").append(extandHpThemeItemId).toString();
				}
			}
			rs.executeSql(sql);
		}

		sql = "update SystemTemplate set templateName='"+templateName+"',templateTitle='"+templateTitle+"',extendtempletid="+extendtempletid+",extendtempletvalueid="+extandHpThemeId+" where id="+templateId;

		rs.executeSql(sql);		
		response.sendRedirect("themeSetting.jsp?templateId=" + templateId
								+ "&subCompanyId=" + subCompanyId
								+ "&extendtempletid=" + extendtempletid
								+ "&theme=" + theme
								+ "&skin=" + skin
								+ "&extandHpThemeId=" + extandHpThemeId
								+ "&extandHpThemeItemId=" + extandHpThemeItemId
								);		
	} else if("saveas".equals(method)){
	/*
		String sql=new StringBuffer("insert into extandHpTheme(templateId, subCompanyId) values (")
						.append(templateId).append(", ").append(subCompanyId).append(")").toString();
		rs.executeSql(sql);
		rs.executeSql("select max(id) from extandHpTheme");
		if(rs.next()) {
			extandHpThemeId = rs.getInt(1);
		}
		
		rs.execute("insert into extandHpThemeItem(extandHpThemeId, theme, skin, logoTop, logoBottom) values(" + extandHpThemeId + ",'" + theme + "', '" + skin + "', '" + logoTop + "', '" + logoBottom + "')");
		
		sql = "INSERT INTO SystemTemplate (templateName,companyId,logo,topBgColor,topBgImage,toolbarBgColor,toolbarBgImage,leftbarBgColor,leftbarBgImage,leftbarBgImageH,leftbarFontColor,menubarBgColor,menubtnBgColor,menubtnBgColorActive,menubtnBgColorHover,menubtnBorderColorActive,menubtnBorderColorHover,menubtnFontColor,templateTitle,extendtempletid,extendtempletvalueid) VALUES ('"+templateName+"',"+subCompanyId+",'','#172971','','#DDDDDD','','#C4C4C4','','','#444444','#172971','#172971','#42549E','#42549E','#172971','#172971','#FFFFFF','"+templateTitle+"',"+extendtempletid+","+extandHpThemeId+")";
		rs.executeSql(sql);		
		rs.executeSql("select max(id) from SystemTemplate");
		if(rs.next()) templateId=rs.getInt(1);
		sql = "update extandHpTheme set templateid=" + templateId + " where id=" + extandHpThemeId;
		rs.executeSql(sql);		
		response.sendRedirect("/systeminfo/template/templateList.jsp?subCompanyId="+subCompanyId);
		return;
*/
	} else if("delete".equals(method)){
		/*
		String sql = "DELETE FROM SystemTemplate WHERE id="+templateId;
		rs.executeSql(sql);
		
		sql = "DELETE FROM extandHpThemeItem WHERE extandHpThemeId=(select id from extandHpTheme where templateId=" +templateId+" and subCompanyId="+subCompanyId + ") and theme='" + theme + "' and skin='" + skin + "'";
		rs.executeSql(sql);
		
		sql = "DELETE FROM extandHpTheme WHERE templateId="+templateId+" and subCompanyId="+subCompanyId;
		rs.executeSql(sql);
		
		response.sendRedirect("/systeminfo/template/templateList.jsp?subCompanyId="+subCompanyId);
		return;
		*/
	}	else if ("delpic".equals(method)){
		String fieldname=Util.null2String(fu.getParameter("fieldname"));
		rs.executeSql("update extandHpThemeItem set " + fieldname + "='' where extandHpThemeId=(select id from extandHpTheme where templateId=" +templateId+" and subCompanyId="+subCompanyId + ") and theme='" + theme + "' and skin='" + skin + "'");
		response.sendRedirect("themeSetting.jsp?templateId=" + templateId
				+ "&subCompanyId=" + subCompanyId
				+ "&extendtempletid=" + extendtempletid
				+ "&theme=" + theme
				+ "&skin=" + skin
				+ "&extandHpThemeId=" + extandHpThemeId
				+ "&extandHpThemeItemId=" + extandHpThemeItemId
				);		
	}
%>

<%!
private void cssMark(Map cssMap, String key, String innerKey, String value) {
	if (isNullOrEmpty(key) || isNullOrEmpty(innerKey) || isNullOrEmpty(value)) {
		return ;
	}
	if (cssMap == null) {
		cssMap = new HashMap();
	}
	
	Map cssKv = (Map)cssMap.get(key);
	
	if (cssKv == null) {
		cssKv = new HashMap();
		cssMap.put(key, cssKv);
	}
	
	cssKv.put(innerKey, value);
}

private String cssMark(Map cssMap) {
	StringBuffer cssstring = new StringBuffer();
	Set cssKeySet = cssMap.keySet();
	
	for(Iterator it=cssKeySet.iterator(); it.hasNext();) {
		String key = (String)it.next();
		Map cssKv = (Map)cssMap.get(key);
		cssstring.append(key).append(" {");
		if (cssKv != null) {
			Set cssSet = (Set)cssKv.keySet();
			for(Iterator it2=cssSet.iterator(); it2.hasNext();) {
				String cssKey = (String)it2.next();
				String value = (String)cssKv.get(cssKey);
				if (!isNullOrEmpty(cssKey) && !isNullOrEmpty(value)) {
					cssstring.append("\r\n    ").append(cssKey).append(" : ").append(value).append("!important;");
				}
			}
		}
		cssstring.append("\r\n}\r\n");
	}
	
	
	return cssstring.toString();
}

private String getBgImageRealAddr(weaver.homepage.style.HomepageStyleUtil hsu, String imageId) {
	if (isNullOrEmpty(imageId)) {
		return "";
	}
	String rtnBgVal = hsu.getRealAddr(imageId);
	rtnBgVal = Util.StringReplace(rtnBgVal, "\\", "/");
	return rtnBgVal;
	
}

private boolean isNullOrEmpty(String value) {
	if (value == null || "".equals(value.trim())) {
		return true;
	} 
	return false;
}

public void copyFile(String oldPath, String newPath) {
	if (oldPath == null || "".equals(oldPath)) {
		return;
	}
	
	oldPath = GCONST.getRootPath().substring(0, GCONST.getRootPath().length() - 1) + oldPath;
	newPath = GCONST.getRootPath().substring(0, GCONST.getRootPath().length() - 1) + newPath;
	
	try {
		int bytesum = 0;
		int byteread = 0;
		java.io.File oldfile = new java.io.File(oldPath);
           
		if (oldfile.exists()) { //文件存在时     
			java.io.File myDelFile = new java.io.File(newPath);     
			if (myDelFile.exists()) {
				myDelFile.delete();  
			}
			
			java.io.InputStream inStream = new java.io.FileInputStream(oldPath); //读入原文件     
			java.io.FileOutputStream fs = new java.io.FileOutputStream(newPath);
			byte[] buffer = new byte[1444];
			int length;
			while ((byteread = inStream.read(buffer)) != -1) {
				bytesum += byteread; //字节数     文件大小     
				new BaseBean().writeLog(bytesum);
				fs.write(buffer, 0, byteread);
			}
			inStream.close();
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
} 

public void writerCss(String path, String cssString) {
	
	new BaseBean().writeLog(cssString);
	
	if (path == null || "".equals(path)) {
		return;
	}
	
	java.io.File cssfile = new java.io.File(path);
	//存在且为文件
	if (!cssfile.exists() || !cssfile.isFile() ) {
		return;
	}
	
	java.io.BufferedReader br = null;
	try {
		int bytesum = 0;
		int byteread = 0;
		java.io.InputStream inStream = new StringBufferInputStream(cssString);     
		java.io.FileOutputStream fs = new java.io.FileOutputStream(path);
		byte[] buffer = new byte[1444];
		int length;
		while ((byteread = inStream.read(buffer)) != -1) {
			bytesum += byteread; //字节数     文件大小     
			new BaseBean().writeLog(bytesum);
			fs.write(buffer, 0, byteread);
		}
		inStream.close();
		
	} catch (Exception e) {
		e.printStackTrace();
	}
}
%>