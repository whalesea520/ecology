
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpsu" class="weaver.homepage.style.HomepageStyleUtil" scope="page"/>

<%
	FileUpload fu = new FileUpload(request,false,"others");

	String method = Util.null2String(request.getParameter("method"));	
	int templateId = Util.getIntValue(request.getParameter("templateId"));	
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"));
	int extendtempletid = Util.getIntValue(request.getParameter("extendtempletid"));
	int extendHpWebCustomId = Util.getIntValue(request.getParameter("extendHpWebCustomId"),0);	
	String templateName = Util.null2String(request.getParameter("templateName"));
	String templateTitle = Util.null2String(request.getParameter("templateTitle"));
	
	
	String pagetemplateid = Util.null2String(request.getParameter("pagetemplateid"));
	String menuid = Util.null2String(request.getParameter("menuid"));
	String menustyleid = Util.null2String(request.getParameter("menustyleid"));
	String useVoting = Util.null2String(request.getParameter("useVoting"));
	String useRTX = Util.null2String(request.getParameter("useRTX"));
	String useWfNote = Util.null2String(request.getParameter("useWfNote"));
	String useBirthdayNote = Util.null2String(request.getParameter("useBirthdayNote"));
	String defaultshow = Util.null2String(request.getParameter("defaultshow"));

	String docId = Util.null2String(request.getParameter("docId"));
	String floatwidth = Util.null2String(request.getParameter("floatwidth"));
	String floatheight = Util.null2String(request.getParameter("floatheight"));
	String menutype = Util.null2String(request.getParameter("menuType")) ;
	String leftmenuid = Util.null2String(request.getParameter("leftmenuid"));
	String leftmenustyleid = Util.null2String(request.getParameter("leftmenustyleid"));
    String useDoc = Util.null2String(request.getParameter("useDoc"));
	if("edit".equals(method)){

		String sql="";
		
		if(extendHpWebCustomId==0){
			sql="insert into extendHpWebCustom(templateId,subCompanyId,pagetemplateid,menuid,menustyleid,useVoting,useRTX,useWfNote,useBirthdayNote,defaultshow,floatWidth,floatHeight,docId,menutype,leftmenuid,leftmenustyleid,useDoc) values ('"+templateId+"','"+subCompanyId+"','"+pagetemplateid+"','"+menuid+"','"+menustyleid+"','"+useVoting+"','"+useRTX+"','"+useWfNote+"','"+useBirthdayNote+"','"+defaultshow+"','"+floatwidth+"','"+floatheight+"','"+docId+"','"+menutype+"','"+leftmenuid+"','"+leftmenustyleid+"','"+useDoc+"') ";

			rs.executeSql(sql);
			rs.executeSql("select max(id) from extendHpWebCustom");
			if(rs.next()) extendHpWebCustomId=rs.getInt(1);

		} else {
			if(templateId==1){
				sql="update extendHpWebCustom set pagetemplateid='"+pagetemplateid+"',menuid='"+menuid+"',menustyleid='"+menustyleid+"',useVoting='"+useVoting+"',useRTX='"+useRTX+"',useWfNote='"+useWfNote+"',useBirthdayNote='"+useBirthdayNote+"', defaultshow='"+defaultshow+"', floatWidth='"+floatwidth+"', floatHeight='"+floatheight+"',docId = '"+docId+"' ,menutype='"+menutype+"', leftmenuid='"+leftmenuid+"', leftmenustyleid='"+leftmenustyleid+"', useDoc='"+useDoc+"' where id="+extendHpWebCustomId+"";
			}else{
			    sql="update extendHpWebCustom set pagetemplateid='"+pagetemplateid+"',menuid='"+menuid+"',menustyleid='"+menustyleid+"',useVoting='"+useVoting+"',useRTX='"+useRTX+"',useWfNote='"+useWfNote+"',useBirthdayNote='"+useBirthdayNote+"', defaultshow='"+defaultshow+"', floatWidth='"+floatwidth+"', floatHeight='"+floatheight+"',docId = '"+docId+"' ,menutype='"+menutype+"', leftmenuid='"+leftmenuid+"', leftmenustyleid='"+leftmenustyleid+"', useDoc='"+useDoc+"' where id="+extendHpWebCustomId+ " and subCompanyId='"+subCompanyId+"'";
			}
			rs.executeSql(sql);
		}
		
		sql="update SystemTemplate set templateName='"+templateName+"',templateTitle='"+templateTitle+"',extendtempletid="+extendtempletid+",extendtempletvalueid="+extendHpWebCustomId+"  where id="+templateId;

		rs.executeSql(sql);		
		response.sendRedirect("setting.jsp?templateId="+templateId+"&subCompanyId="+subCompanyId+"&extendtempletid="+extendtempletid);		

} else if("saveas".equals(method)){
	String sql="insert into extendHpWebCustom(templateId,subCompanyId,pagetemplateid,menuid,menustyleid,useVoting,useRTX,useWfNote,useBirthdayNote,defaultshow,floatWidth,floatHeight,docId,menutype,leftmenuid,leftmenustyleid) values ('"+templateId+"','"+subCompanyId+"','"+pagetemplateid+"','"+menuid+"','"+menustyleid+"','"+useVoting+"','"+useRTX+"','"+useWfNote+"','"+useBirthdayNote+"','"+defaultshow+"','"+floatwidth+"','"+floatheight+"','"+docId+"','"+menutype+"','"+leftmenuid+"','"+leftmenustyleid+"') ";

	rs.executeSql(sql);
	rs.executeSql("select max(id) from extendHpWebCustom");
	if(rs.next()) extendHpWebCustomId=rs.getInt(1);
	
	sql = "INSERT INTO SystemTemplate (templateName,companyId,logo,topBgColor,topBgImage,toolbarBgColor,toolbarBgImage,leftbarBgColor,leftbarBgImage,leftbarBgImageH,leftbarFontColor,menubarBgColor,menubtnBgColor,menubtnBgColorActive,menubtnBgColorHover,menubtnBorderColorActive,menubtnBorderColorHover,menubtnFontColor,templateTitle,extendtempletid,extendtempletvalueid) VALUES ('"+templateName+"',"+subCompanyId+",'','#172971','','#DDDDDD','','#C4C4C4','','','#444444','#172971','#172971','#42549E','#42549E','#172971','#172971','#FFFFFF','"+templateTitle+"',"+extendtempletid+","+extendHpWebCustomId+")";
	rs.executeSql(sql);		
	rs.executeSql("select max(id) from SystemTemplate");
	if(rs.next()) templateId=rs.getInt(1);
	sql = "update extendHpWebCustom set templateid = "+templateId+" where id = "+extendHpWebCustomId;
	rs.executeSql(sql);		
	response.sendRedirect("/systeminfo/template/templateList.jsp?subCompanyId="+subCompanyId);
	return;
}else if("delete".equals(method)){
	String sql = "DELETE FROM SystemTemplate WHERE id="+templateId;
	rs.executeSql(sql);

	sql = "DELETE FROM extendHpWebCustom WHERE templateId="+templateId+" and subCompanyId="+subCompanyId;
	rs.executeSql(sql);

	response.sendRedirect("/systeminfo/template/templateList.jsp?subCompanyId="+subCompanyId);
	return;
}	
%>