
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="java.net.URLDecoder"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>


<%@page import="weaver.general.TimeUtil"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
	String method = Util.null2String(request.getParameter("method"));
	//System.out.println(method);
	String now = Util.date(2);
	if("add2License".equals(method)){
		String licensename = Util.null2String(request.getParameter("licensename"));
		String licenseindex = Util.null2String(request.getParameter("licenseindex"));
		licensename=URLDecoder.decode(licensename, "utf-8");
		String ismulti = Util.null2String(request.getParameter("ismulti"));
		String sql = "insert into CPLMLICENSEAFFIX (affixindex,licensename,licensetype,uploaddatetime,ismulti) values ("+licenseindex+",'"+licensename+"',0,'"+now+"','"+ismulti+"')";
		//System.out.println(sql);
		rs.execute(sql);
	}
	if("del2License".equals(method)){
		String licenseaffixids = Util.null2String(request.getParameter("licenseaffixids"));
		String _licenseaffixids = licenseaffixids.substring(0,licenseaffixids.lastIndexOf(","));
		
		String strSql=" delete from CPLMLICENSEAFFIX  where licenseaffixid in("+_licenseaffixids+")";
		//System.out.println(strSql.toString());
		rs.execute(strSql);
	}
	if("get2License".equals(method)){
		String licenseaffixid = Util.null2String(request.getParameter("licenseaffixid"));
		String sql = "select licensename,affixindex,ismulti from CPLMLICENSEAFFIX where licenseaffixid="+licenseaffixid;
		//System.out.println(sql);
		rs.execute(sql);
		String laname="";
		if(rs.next()){
			laname = rs.getString("licensename")+","+rs.getString("affixindex")+","+rs.getString("ismulti");
		}
		out.print(laname);
	}
	if("edit2License".equals(method)){
		String licenseaffixid = Util.null2String(request.getParameter("licenseaffixid"));
		String licensename = Util.null2String(request.getParameter("licensename"));
		licensename=URLDecoder.decode(licensename, "utf-8");
		String licenseindex = Util.null2String(request.getParameter("licenseindex"));
		String ismulti = Util.null2String(request.getParameter("ismulti"));
		String sql = "update CPLMLICENSEAFFIX set affixindex="+licenseindex+",licensename = '"+licensename+"',uploaddatetime='"+now+"',ismulti='"+ismulti+"' where licenseaffixid="+licenseaffixid;
		//System.out.println(sql);
		rs.execute(sql);
	}
	if("overtime2Save".equals(method)){
	
		String toid = Util.getIntValue(Util.null2String(request.getParameter("toid")),30)+"";
		String tofaren =  Util.getIntValue(Util.null2String(request.getParameter("tofaren")),30)+"";
		String todsh = Util.getIntValue( Util.null2String(request.getParameter("todsh")),30)+"";
		String tozhzh = Util.getIntValue( Util.null2String(request.getParameter("tozhzh")),30)+"";
		String tozhch = Util.getIntValue( Util.null2String(request.getParameter("tozhch")),30)+"";
		String tonjian = Util.getIntValue( Util.null2String(request.getParameter("tonjian")),30)+"";
		
		String chdsh =  Util.getIntValue(Util.null2String(request.getParameter("chdsh")),1)+"";
		String chzhzh = Util.getIntValue( Util.null2String(request.getParameter("chzhzh")),1)+"";
		String chzhch =  Util.getIntValue(Util.null2String(request.getParameter("chzhch")),1)+"";
		String chgd = Util.getIntValue( Util.null2String(request.getParameter("chgd")),1)+"";
		String chxgs = Util.getIntValue( Util.null2String(request.getParameter("chxgs")),1)+"";
		
		String sql = "";
		if(toid.equals("")){
			sql = "insert into CPCOMPANYTIMEOVER (tofaren,todsh,tozhzh,tozhch,tonjian,chdsh,chzhzh,chzhch,chgd,chxgs) values ('"+tofaren+"','"+todsh+"','"+tozhzh+"','"+tozhch+"','"+tonjian+"','"+chdsh+"','"+chzhzh+"','"+chzhch+"','"+chgd+"','"+chxgs+"')";
		}else{
			sql = "update CPCOMPANYTIMEOVER set tofaren='"+tofaren+"',todsh='"+todsh+"',tozhzh='"+tozhzh+"',tozhch='"+tozhch+"',tonjian='"+tonjian+"',chdsh='"+chdsh+"',chzhzh='"+chzhzh+"',chzhch='"+chzhch+"',chgd='"+chgd+"',chxgs='"+chxgs+"' where id="+toid;
		}
		boolean flag=rs.execute(sql);
		response.sendRedirect("/cpcompanyinfo/CompanyOvertimeMaintain.jsp?flag="+flag);
	}
	if("allotCompany".equals(method)){
		String subcompany = Util.null2String(request.getParameter("subcompany"));
		String requestids = Util.null2String(request.getParameter("requestids"));
		String _requestids = "";
		if(!requestids.equals("")){
			_requestids = requestids.substring(0,requestids.lastIndexOf(","));
		}
		String sql="update cpcompanyinfo set subcompanyid="+subcompany+"  where companyid in ("+_requestids+")";
		rs.execute(sql);
	}
%>
