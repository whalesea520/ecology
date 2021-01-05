
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
	int extendHpWeb1Id = Util.getIntValue(fu.getParameter("extendHpWeb1Id"),0);	
	String templateName = Util.null2String(fu.getParameter("templateName"));
	String templateTitle = Util.null2String(fu.getParameter("templateTitle"));
	String hiddenLMenu = Util.null2String(fu.getParameter("txtHiddenLMenu"));
	String defaultHp =  Util.null2String(fu.getParameter("defaultHp"));
	
	String logo = Util.null2String(fu.uploadFiles("logo"));
	String navimg = Util.null2String(fu.uploadFiles("navimg"));
	String flash1 = Util.null2String(fu.uploadFiles("flash1"));
	String flash2 = Util.null2String(fu.uploadFiles("flash2"));
	String flash3 = Util.null2String(fu.uploadFiles("flash3"));
	String flash4 = Util.null2String(fu.uploadFiles("flash4"));
	String flash5 = Util.null2String(fu.uploadFiles("flash5"));
	String copyinfo = Util.null2String(fu.getParameter("copyinfo"));
	

	String strUpdate="";

	if (!"".equals(navimg)) {
		navimg=hpsu.getRealAddr(navimg);
		if(!"".equals(strUpdate)) strUpdate+=",";
		strUpdate+="navimg='"+navimg+"'";
	}
	if (!"".equals(flash1)) {
		flash1=hpsu.getRealAddr(flash1);
		if(!"".equals(strUpdate)) strUpdate+=",";
		strUpdate+="flash1='"+flash1+"'";
	}
	if (!"".equals(flash2)) {
		flash2=hpsu.getRealAddr(flash2);
		if(!"".equals(strUpdate)) strUpdate+=",";
		strUpdate+="flash2='"+flash2+"'";
	}
	if (!"".equals(flash3)) {
		flash3=hpsu.getRealAddr(flash3);
		if(!"".equals(strUpdate)) strUpdate+=",";
		strUpdate+="flash3='"+flash3+"'";
	}
	if (!"".equals(flash4)) {
		flash4=hpsu.getRealAddr(flash4);
		if(!"".equals(strUpdate)) strUpdate+=",";
		strUpdate+="flash4='"+flash4+"'";
	}
	if (!"".equals(flash5)) {
		flash5=hpsu.getRealAddr(flash5);
		if(!"".equals(strUpdate)) strUpdate+=",";
		strUpdate+="flash5='"+flash5+"'";
	}

	if (!"".equals(logo)) {
		logo=hpsu.getRealAddr(logo);
		if(!"".equals(strUpdate)) strUpdate+=",";
		strUpdate+="logo='"+logo+"'";
	}

	
	if(!"".equals(strUpdate)) strUpdate+=",";
	strUpdate+="copyinfo='"+copyinfo+"'";


	if(!"".equals(strUpdate)) strUpdate+=",";
	strUpdate+="hiddenLMenu='"+hiddenLMenu+"'";

	if("edit".equals(method)){

		

	

		String sql="";
		
		if(extendHpWeb1Id==0){
			sql="insert into extendHpWeb1(templateId,subCompanyId,logo,navimg,flash1,flash2,flash3,flash4,flash5,copyinfo,hiddenLMenu) values ('"+templateId+"','"+subCompanyId+"','"+logo+"','"+navimg+"','"+flash1+"','"+flash2+"','"+flash3+"','"+flash4+"','"+flash5+"','"+copyinfo+"','"+hiddenLMenu+"') ";

			

			rs.executeSql(sql);
			rs.executeSql("select max(id) from extendHpWeb1");
			if(rs.next()) extendHpWeb1Id=rs.getInt(1);

		} else {
			if(!"".equals(strUpdate)) 	sql="update extendHpWeb1 set "+strUpdate+" where id="+extendHpWeb1Id;
			
			rs.executeSql(sql);
		}
		
		//sql="update SystemTemplate set templateName='"+templateName+"',templateTitle='"+templateTitle+"',extendtempletid="+extendtempletid+",extendtempletvalueid="+extendHpWeb1Id+"  where id="+templateId;
		sql="update SystemTemplate set templateName='"+templateName+"',templateTitle='"+templateTitle+"',extendtempletid="+extendtempletid+",extendtempletvalueid="+extendHpWeb1Id+",defaultHp='"+defaultHp+"'  where id="+templateId;
		rs.executeSql(sql);		
		response.sendRedirect("setting.jsp?templateId="+templateId+"&subCompanyId="+subCompanyId+"&extendtempletid="+extendtempletid);		
} else if("saveas".equals(method)){
	
	String sql="insert into extendHpWeb1(templateId,subCompanyId,logo,navimg,flash1,flash2,flash3,flash4,flash5,copyinfo,hiddenLMenu) values ('"+templateId+"','"+subCompanyId+"','"+logo+"','"+navimg+"','"+flash1+"','"+flash2+"','"+flash3+"','"+flash4+"','"+flash5+"','"+copyinfo+"','"+hiddenLMenu+"') ";
	rs.executeSql(sql);
	rs.executeSql("select max(id) from extendHpWeb1");
	if(rs.next()) extendHpWeb1Id=rs.getInt(1);
	//sql="update SystemTemplate set templateName='"+templateName+"',templateTitle='"+templateTitle+"',extendtempletid="+extendtempletid+",extendtempletvalueid="+extendHpWeb1Id+"  where id="+templateId;
	sql = "INSERT INTO SystemTemplate (templateName,companyId,logo,topBgColor,topBgImage,toolbarBgColor,toolbarBgImage,leftbarBgColor,leftbarBgImage,leftbarBgImageH,leftbarFontColor,menubarBgColor,menubtnBgColor,menubtnBgColorActive,menubtnBgColorHover,menubtnBorderColorActive,menubtnBorderColorHover,menubtnFontColor,templateTitle,extendtempletid,extendtempletvalueid) VALUES ('"+templateName+"',"+subCompanyId+",'','#172971','','#DDDDDD','','#C4C4C4','','','#444444','#172971','#172971','#42549E','#42549E','#172971','#172971','#FFFFFF','"+templateTitle+"',"+extendtempletid+","+extendHpWeb1Id+")";
	rs.executeSql(sql);		
	rs.executeSql("select max(id) from SystemTemplate");
	if(rs.next()) templateId=rs.getInt(1);
	sql = "update extendHpWeb1 set templateid = "+templateId+" where id = "+extendHpWeb1Id;
	rs.executeSql(sql);		
	response.sendRedirect("/systeminfo/template/templateList.jsp?subCompanyId="+subCompanyId);
	return;

}else if("delete".equals(method)){
	String sql = "DELETE FROM SystemTemplate WHERE id="+templateId;
	rs.executeSql(sql);

	sql = "DELETE FROM extendHpWeb1 WHERE templateId="+templateId+" and subCompanyId="+subCompanyId;
	rs.executeSql(sql);

	response.sendRedirect("/systeminfo/template/templateList.jsp?subCompanyId="+subCompanyId);
	return;
}	else if ("delpic".equals(method)){
	String fieldname=Util.null2String(fu.getParameter("fieldname"));
	String sql="update extendHpWeb1 set "+fieldname+"='' where   templateId="+templateId+" and subCompanyId="+subCompanyId;	
	rs.executeSql(sql);
	response.sendRedirect("setting.jsp?templateId="+templateId+"&subCompanyId="+subCompanyId+"&extendtempletid="+extendtempletid);
}
%>