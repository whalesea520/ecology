
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpsu" class="weaver.homepage.style.HomepageStyleUtil" scope="page"/>

<%
	String method = Util.null2String(request.getParameter("method"));
	int templateId = Util.getIntValue(request.getParameter("templateId"));	
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"));
	String templateName = Util.null2String(request.getParameter("templateName"));
	String templateTitle = Util.null2String(request.getParameter("templateTitle"));
	int extendtempletid = Util.getIntValue(request.getParameter("extendtempletid"));
	
	int extandHpThemeId = Util.getIntValue(request.getParameter("extandHpThemeId"), 0);
	
	String sbmtskvToStr = Util.null2String(request.getParameter("sbmtskvToStr"));
	String islock = Util.null2String(request.getParameter("themeLock"));
	
	String[] themeArray = sbmtskvToStr.split(",");
	if (themeArray == null) {
		themeArray = new String[0];
	}
	String instLock = "";
	String sql="";
	
	if("edit".equals(method)){
		if(extandHpThemeId == 0){
			sql=new StringBuffer("insert into extandHpTheme(templateId, subCompanyId) values (")
					.append(templateId).append(", ").append(subCompanyId).append(")").toString();
			
			
			rs.executeSql(sql);
			rs.executeSql("select max(id) from extandHpTheme");
			if(rs.next()) {
				extandHpThemeId = rs.getInt(1);
			}
			for (int i=0; i<themeArray.length; i++) {
				String sbmts = themeArray[i];
				String sbmtsIsOpen = Util.null2String(request.getParameter(sbmts + "isopen"));
				if (sbmtsIsOpen == null || sbmtsIsOpen.equals("")) {
					sbmtsIsOpen = "0";
				}
				String[] tsarry = sbmts.split("-");
				
				String theme = tsarry[0];
				String skin = tsarry[1];
			
				if (sbmts.equals(islock)) {
					instLock = "1";
				} else {
					instLock = "0";
				}
				rs.execute("insert into extandHpThemeItem(extandHpThemeId, theme, skin, isopen, islock) values(" + extandHpThemeId + ",'" + theme + "', '" + skin + "'," + sbmtsIsOpen + "," + instLock + ")");				
			}
		} else {
			
			for (int i=0; i<themeArray.length; i++) {
				String sbmts = themeArray[i];
				String sbmtsIsOpen = Util.null2String(request.getParameter(sbmts + "isopen"));
				
				if (sbmtsIsOpen.equals("")) {
					sbmtsIsOpen = "0";
				}
			
				String[] tsarry = sbmts.split("-");
				if (tsarry != null && tsarry.length == 2) {
					String theme = tsarry[0];
					String skin = tsarry[1];
					if (sbmts.equals(islock)) {
						instLock = "1";
					} else {
						instLock = "0";
					}
					
					rs.execute("select extandHpThemeId from extandHpThemeItem where extandHpThemeId=" + extandHpThemeId + " and theme='" + theme.trim() + "' and skin='" + skin.trim() + "'");
					if (rs.next()) {
						sql = "update extandHpThemeItem set isopen=" + sbmtsIsOpen + ", islock=" + instLock + "  where extandHpThemeId=" + extandHpThemeId + " and theme='" + theme + "' and skin='" + skin + "'";
					} else {
						sql = "insert into extandHpThemeItem(extandHpThemeId, theme, skin, isopen, islock) values(" + extandHpThemeId + ",'" + theme + "', '" + skin + "'," + sbmtsIsOpen + "," + instLock + ")";
					}
					rs.executeSql(sql);
				}
			}
		}
		sql = "update SystemTemplate set extendtempletid="+extendtempletid+",extendtempletvalueid=" + extandHpThemeId + " where id=" + templateId;
	
		rs.executeSql(sql);		
		response.sendRedirect("setting.jsp?templateId="+templateId+"&subCompanyId="+subCompanyId+"&extendtempletid="+extendtempletid);		
	} else if("saveas".equals(method)){
		sql=new StringBuffer("insert into extandHpTheme(templateId, subCompanyId) values (")
			.append(templateId).append(", ").append(subCompanyId).append(")").toString();
		rs.executeSql(sql);
		rs.executeSql("select max(id) from extandHpTheme");
		if(rs.next()) {
			extandHpThemeId = rs.getInt(1);
		}
		
		for (int i=0; i<themeArray.length; i++) {
			String sbmts = themeArray[i];
			String sbmtsIsOpen = Util.null2String(request.getParameter(sbmts + "isopen"));
			if (sbmtsIsOpen == null || sbmtsIsOpen.equals("")) {
				sbmtsIsOpen = "0";
			}
			String[] tsarry = sbmts.split("-");
			
			String theme = tsarry[0];
			String skin = tsarry[1];
			if (sbmts.equals(islock)) {
				instLock = "1";
			} else {
				instLock = "0";
			}
			rs.execute("insert into extandHpThemeItem(extandHpThemeId, theme, skin, isopen, islock) values(" + extandHpThemeId + ",'" + theme + "', '" + skin + "'," + sbmtsIsOpen + "," + instLock + ")");				
		}
		
		sql = "INSERT INTO SystemTemplate (templateName,companyId,logo,topBgColor,topBgImage,toolbarBgColor,toolbarBgImage,leftbarBgColor,leftbarBgImage,leftbarBgImageH,leftbarFontColor,menubarBgColor,menubtnBgColor,menubtnBgColorActive,menubtnBgColorHover,menubtnBorderColorActive,menubtnBorderColorHover,menubtnFontColor,templateTitle,extendtempletid,extendtempletvalueid) VALUES ('"+templateName+"',"+subCompanyId+",'','#172971','','#DDDDDD','','#C4C4C4','','','#444444','#172971','#172971','#42549E','#42549E','#172971','#172971','#FFFFFF','"+templateTitle+"',"+extendtempletid+","+extandHpThemeId+")";
		rs.executeSql(sql);		
		rs.executeSql("select max(id) from SystemTemplate");
		if(rs.next()) templateId=rs.getInt(1);
		sql = "update extandHpTheme set templateid=" + templateId + " where id=" + extandHpThemeId;
		rs.executeSql(sql);		
		response.sendRedirect("/systeminfo/template/templateList.jsp?subCompanyId="+subCompanyId);
		return;
	} else if("delete".equals(method)){
		sql = "DELETE FROM SystemTemplate WHERE id="+templateId;
		rs.executeSql(sql);
		
		sql = "DELETE FROM extandHpThemeItem WHERE extandHpThemeId=(select id from extandHpTheme where templateId=" +templateId+" and subCompanyId="+subCompanyId + ")";
		rs.executeSql(sql);
		
		sql = "DELETE FROM extandHpTheme WHERE templateId="+templateId+" and subCompanyId="+subCompanyId;
		rs.executeSql(sql);
		
		response.sendRedirect("/systeminfo/template/templateList.jsp?subCompanyId="+subCompanyId);
		return;
	}
%>