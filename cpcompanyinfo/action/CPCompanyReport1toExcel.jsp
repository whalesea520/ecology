
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.*," %>
<%@page import="java.util.List"%>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String o4searchTX = Util.null2String(request.getParameter("o4searchTX"));
	String o4searchSL = Util.null2String(request.getParameter("o4searchSL"));
	String sqlwhere1 = "";
	String sqlwhere2 = "";
	String sqlwhere3 = "";
	if(o4searchSL.equals("d-officename")){
		//System.out.println();
		if(!o4searchTX.equals("")){
			sqlwhere2 = " and co.officename like '%"+o4searchTX+ "%'";
		}
		sqlwhere3 = " and 1 = 2";
	}else if(o4searchSL.equals("j-officename")){
		sqlwhere2 = " and 1 = 2";
		if(!o4searchTX.equals("")){
			sqlwhere3 = " and cu.supername like '%"+o4searchTX+ "%'";
		}
	}else{
		if(!o4searchTX.equals("")){
				sqlwhere1 = " and "+o4searchSL+" like '%"+o4searchTX+ "%'";
		}
	}
	
	
	String backfields = " companyid,archivenum,companyname,effectdate,corporation,usefuldate,officename,officedate,generalmanager,managerdate ";
	StringBuffer fromSql = new StringBuffer();
			fromSql.append("(");
			fromSql.append(" select ci.companyid,ci.archivenum,ci.companyname,(cs.effectbegindate||' - '||cs.effectenddate) as effectdate,");
			fromSql.append(" (select cb.corporation from cpbusinesslicense cb where cb.companyid = ci.companyid and cb.licenseaffixid = 1) as corporation,");
			fromSql.append(" ((select cb.usefulbegindate from cpbusinesslicense cb where cb.companyid = ci.companyid and cb.licenseaffixid = 1)||' - '||");
			fromSql.append(" (select cb.usefulenddate from cpbusinesslicense cb where cb.companyid = ci.companyid and cb.licenseaffixid = 1)) as usefuldate,");
			fromSql.append(" co.officename,(co.officebegindate||' - '||co.officeenddate) as officedate,cd.generalmanager,(cd.managerbegindate||' - '||cd.managerenddate) as managerdate");
			fromSql.append(" from cpcompanyinfo ci,cpconstitution cs,cpboarddirectors cd,cpboardofficer co where ci.companyid = cs.companyid");
			fromSql.append(" and cd.companyid = ci.companyid and cd.directorsid = co.directorsid" + sqlwhere2);
			fromSql.append(" union");
			fromSql.append(" select ci.companyid,ci.archivenum,ci.companyname,(cs.effectbegindate||' - '||cs.effectenddate) as effectdate,");
			fromSql.append(" (select cb.corporation from cpbusinesslicense cb where cb.companyid = ci.companyid and cb.licenseaffixid = 1) as corporation,");
			fromSql.append(" ((select cb.usefulbegindate from cpbusinesslicense cb where cb.companyid = ci.companyid and cb.licenseaffixid = 1)||' - '||");
			fromSql.append(" (select cb.usefulenddate from cpbusinesslicense cb where cb.companyid = ci.companyid and cb.licenseaffixid = 1)) as usefuldate,");
			fromSql.append(" cu.supername,(cu.superbegindate||' - '||cu.superenddate) as officedate,cd.generalmanager,(cd.managerbegindate||' - '||cd.managerenddate) as managerdate");
			fromSql.append(" from cpcompanyinfo ci,cpconstitution cs,cpboarddirectors cd,cpboardsuper cu where ci.companyid = cs.companyid");
			fromSql.append(" and cd.companyid = ci.companyid and cd.directorsid = cu.directorsid "+ sqlwhere3 +")");
	String sqlwhere = " where 1=1 " + sqlwhere1;
	
	String sqlorderby = " archivenum ";
	String sqlsortway = " asc ";
	
	String sql = "select "+backfields + " from "+fromSql.toString() + sqlwhere + "order by "+sqlorderby + sqlsortway;
	
  ExcelSheet es = new ExcelSheet() ;   // 初始化一个EXCEL的sheet对象
  ExcelRow er = es.newExcelRow () ;  //准备新增EXCEL中的一行

  er.addStringValue(SystemEnv.getHtmlLabelName(714,user.getLanguage())) ;  
  er.addStringValue(SystemEnv.getHtmlLabelName(1976,user.getLanguage())) ;
  er.addStringValue(SystemEnv.getHtmlLabelName(30937,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(18111,user.getLanguage())) ;
  er.addStringValue(SystemEnv.getHtmlLabelName(23797,user.getLanguage())) ;
  er.addStringValue(SystemEnv.getHtmlLabelName(23937,user.getLanguage())) ;
  er.addStringValue(SystemEnv.getHtmlLabelName(30938,user.getLanguage())) ;
  er.addStringValue(SystemEnv.getHtmlLabelName(23937,user.getLanguage())) ;
  er.addStringValue(SystemEnv.getHtmlLabelName(20696,user.getLanguage())) ;
  er.addStringValue(SystemEnv.getHtmlLabelName(23937,user.getLanguage())) ;
	
  es.addExcelRow(er) ;   //加入一行
  
	rs.execute(sql);
  while(rs.next()){
      ExcelRow er2 = es.newExcelRow () ;
      er2.addStringValue(rs.getString(2));    
      er2.addStringValue(rs.getString(3));
      er2.addStringValue(rs.getString(4));
      er2.addStringValue(rs.getString(5));
      er2.addStringValue(rs.getString(6));
      er2.addStringValue(rs.getString(7));
      er2.addStringValue(rs.getString(8));
      er2.addStringValue(rs.getString(9));
      er2.addStringValue(rs.getString(10));
      
      es.addExcelRow(er2) ;
  }
  
  String date = Util.date(1);
  String[] dates = date.split("-");
  ExcelFile.init() ;  
  ExcelFile.setFilename(SystemEnv.getHtmlLabelName(30939,user.getLanguage())) ;//
  ExcelFile.addSheet(SystemEnv.getHtmlLabelName(30939,user.getLanguage()), es) ; //为EXCEL文件插入一个SHEET
  //session.setAttribute("ExcelFile",ExcelFile);
  response.sendRedirect("/weaver/weaver.file.ExcelOut");
%>