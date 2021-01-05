
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpsu" class="weaver.homepage.style.HomepageStyleUtil" scope="page"/>

<%
	FileUpload fu = new FileUpload(request,false,"others");

	String method = Util.null2String(fu.getParameter("method"));	
	int templateId = Util.getIntValue(fu.getParameter("templateId"));	
	int subCompanyId = Util.getIntValue(fu.getParameter("subCompanyId"));
	int extendtempletid = Util.getIntValue(fu.getParameter("extendtempletid"));
	
	int extendHpSoft2Id = Util.getIntValue(fu.getParameter("extendHpSoft2Id"),0);	
	String templateName = Util.null2String(fu.getParameter("templateName"));
	String templateTitle = Util.null2String(fu.getParameter("templateTitle"));
	
	String logo = Util.null2String(fu.uploadFiles("logo"));
	 
	String bgimg = Util.null2String(fu.uploadFiles("bgimg"));
	
	String ostimg = Util.null2String(fu.uploadFiles("ostimg"));
	
	String osdimg = Util.null2String(fu.uploadFiles("osdimg"));
	String istimg = Util.null2String(fu.uploadFiles("istimg"));
	String iscimg1 = Util.null2String(fu.uploadFiles("iscimg1"));
	String iscimg2 = Util.null2String(fu.uploadFiles("iscimg2"));
	String isdimg = Util.null2String(fu.uploadFiles("isdimg"));
	
	String fontFamily = Util.null2String(fu.getParameter("fontFamily"));
	String fontSize = Util.null2String(fu.getParameter("fontSize"));
	String skin = Util.null2String(fu.getParameter("skin"));

	//String strUpdate="";
	StringBuffer sbupdate = new StringBuffer();
	
	if (!"".equals(logo)) {
		logo = hpsu.getRealAddr(logo);
		sbupdate.append(", logo='");
		sbupdate.append(logo);
		sbupdate.append("'");
	}
	
	if (!"".equals(bgimg)) {
		bgimg = hpsu.getRealAddr(bgimg);
		sbupdate.append(", bgimg='");
		sbupdate.append(bgimg);
		sbupdate.append("'");
	}
	
	
	
	
	
	if (!"".equals(ostimg)) {
		ostimg = hpsu.getRealAddr(ostimg);
		sbupdate.append(", ostimg='");
		sbupdate.append(ostimg);
		sbupdate.append("'");
	}
	if (!"".equals(osdimg)) {
		osdimg = hpsu.getRealAddr(osdimg);
		sbupdate.append(", osdimg='");
		sbupdate.append(osdimg);
		sbupdate.append("'");
	}
	if (!"".equals(istimg)) {
		istimg = hpsu.getRealAddr(istimg);
		sbupdate.append(", istimg='");
		sbupdate.append(istimg);
		sbupdate.append("'");
	}
	if (!"".equals(iscimg1)) {
		iscimg1 = hpsu.getRealAddr(iscimg1);
		sbupdate.append(", iscimg1='");
		sbupdate.append(iscimg1);
		sbupdate.append("'");
	}
	if (!"".equals(iscimg2)) {
		iscimg2 = hpsu.getRealAddr(iscimg2);
		sbupdate.append(", iscimg2='");
		sbupdate.append(iscimg2);
		sbupdate.append("'");
	}
	if (!"".equals(isdimg)) {
		isdimg = hpsu.getRealAddr(isdimg);
		sbupdate.append(", isdimg='");
		sbupdate.append(isdimg);
		sbupdate.append("'");
	}
	
	
	
	sbupdate.append(", fontFamily='");
	sbupdate.append(fontFamily);
	sbupdate.append("'");

	sbupdate.append(", fontSize='");
	sbupdate.append(fontSize);
	sbupdate.append("'");
	
	sbupdate.append(", skin='");
	sbupdate.append(skin);
	sbupdate.append("'");

	String strUpdate = sbupdate.toString().replaceAll("^,", "");
		
	if("edit".equals(method)){
		String sql="";
		if(extendHpSoft2Id == 0){
			sql=new StringBuffer("insert into extendHpSoft2(templateId, subCompanyId, logo, bgimg, ostimg, osdimg, istimg, iscimg1, iscimg2, isdimg, fontFamily, fontSize, skin) values (")
					.append(templateId).append(", ").append(subCompanyId).append(", '").append(logo).append("', '").append(bgimg).append("', '").append(ostimg).append("','").append(osdimg).append("','").append(istimg).append("','").append(iscimg1).append("','").append(iscimg2).append("','").append(isdimg).append("','").append(fontFamily).append("','").append(fontSize).append("', '").append(skin).append("')").toString();
			rs.executeSql(sql);
			rs.executeSql("select max(id) from extendHpSoft2");
			if(rs.next()) {
				extendHpSoft2Id = rs.getInt(1);
			} 
		} else {
			if(!"".equals(strUpdate)) {
				sql = new StringBuffer("update extendHpSoft2 set ").append(strUpdate).append(" where id=").append(extendHpSoft2Id).toString();
			}
			rs.executeSql(sql);
		}
		//sql="update SystemTemplate set templateName='"+templateName+"',templateTitle='"+templateTitle+"',extendtempletid="+extendtempletid+",extendtempletvalueid="+extendHpWeb1Id+"  where id="+templateId;
		sql = "update SystemTemplate set templateName='"+templateName+"',templateTitle='"+templateTitle+"',extendtempletid="+extendtempletid+",extendtempletvalueid="+extendHpSoft2Id+" where id="+templateId;

		rs.executeSql(sql);		
		response.sendRedirect("setting.jsp?templateId="+templateId+"&subCompanyId="+subCompanyId+"&extendtempletid="+extendtempletid);		
		
	} else if("saveas".equals(method)){
	
		String sql=new StringBuffer("insert into extendHpSoft2(templateId, subCompanyId, logo, bgimg, fontFamily, fontSize, skin) values (")
						.append(templateId).append(", ").append(subCompanyId).append(", '").append(logo).append("', '").append(bgimg).append("', '").append(fontFamily).append("','").append(fontSize).append("', '").append(skin).append("')").toString();
		rs.executeSql(sql);
		rs.executeSql("select max(id) from extendHpSoft2");
		if(rs.next()) {
			extendHpSoft2Id = rs.getInt(1);
		}
		//sql="update SystemTemplate set templateName='"+templateName+"',templateTitle='"+templateTitle+"',extendtempletid="+extendtempletid+",extendtempletvalueid="+extendHpWeb1Id+"  where id="+templateId;
		sql = "INSERT INTO SystemTemplate (templateName,companyId,logo,topBgColor,topBgImage,toolbarBgColor,toolbarBgImage,leftbarBgColor,leftbarBgImage,leftbarBgImageH,leftbarFontColor,menubarBgColor,menubtnBgColor,menubtnBgColorActive,menubtnBgColorHover,menubtnBorderColorActive,menubtnBorderColorHover,menubtnFontColor,templateTitle,extendtempletid,extendtempletvalueid) VALUES ('"+templateName+"',"+subCompanyId+",'','#172971','','#DDDDDD','','#C4C4C4','','','#444444','#172971','#172971','#42549E','#42549E','#172971','#172971','#FFFFFF','"+templateTitle+"',"+extendtempletid+","+extendHpSoft2Id+")";
		rs.executeSql(sql);		
		rs.executeSql("select max(id) from SystemTemplate");
		if(rs.next()) templateId=rs.getInt(1);
		sql = "update extendHpWeb1 set templateid = "+templateId+" where id = "+extendHpSoft2Id;
		rs.executeSql(sql);		
		response.sendRedirect("/systeminfo/template/templateList.jsp?subCompanyId="+subCompanyId);
		return;

	}else if("delete".equals(method)){
		String sql = "DELETE FROM SystemTemplate WHERE id="+templateId;
		rs.executeSql(sql);
	
		sql = "DELETE FROM extendHpSoft2 WHERE templateId="+templateId+" and subCompanyId="+subCompanyId;
		rs.executeSql(sql);
	
		response.sendRedirect("/systeminfo/template/templateList.jsp?subCompanyId="+subCompanyId);
		return;
	}	else if ("delpic".equals(method)){
		String fieldname=Util.null2String(fu.getParameter("fieldname"));
		String sql="update extendHpSoft2 set "+fieldname+"='' where   templateId="+templateId+" and subCompanyId="+subCompanyId;	
		rs.executeSql(sql);
		response.sendRedirect("setting.jsp?templateId="+templateId+"&subCompanyId="+subCompanyId+"&extendtempletid="+extendtempletid);
	}
%>