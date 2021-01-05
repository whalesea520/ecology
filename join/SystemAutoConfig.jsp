<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ 
page import="weaver.templetecheck.*,weaver.templetecheck.SystemAutoConfig" %><%@ 
page import="weaver.general.Util" %><%@ 
page import="weaver.general.MD5" %><%@ 
page import="weaver.conn.RecordSet" %><%@ 
page import="weaver.general.GCONST"%><%@ page import="wscheck.*"%><%
	MD5 md5 = new MD5();
	String token  = Util.null2String(request.getParameter("token"));//token
	String mainId = Util.null2String(request.getParameter("mainId"));//需要查询的主表id
	String pageIndex =  Util.null2String(request.getParameter("pageIndex"));
	String pageSize = Util.null2String(request.getParameter("pageSize"));
	String operation = Util.null2String(request.getParameter("operation"));//  1:自动配置  2:获取主表信息 3:获取明细 
	String checkCode ="";
	//验证token
	RecordSet rs = new RecordSet();
	rs.execute("select * from autoConfigKey where 1=1");
	if(rs.next()){
		checkCode = "weaver"+rs.getString("time");
	}
	if(("1".equals(operation)||"4".equals(operation))&&!token.equals(md5.getMD5ofStr(checkCode))){
		return;
	}
	SystemAutoConfig sac = new SystemAutoConfig();
	String result="";
	if("1".equals(operation)) {
		String configtype = Util.null2String(request.getParameter("configtype"));
		String ids = Util.null2String(request.getParameter("ids"));
		result = sac.systemAutoConfig(configtype,ids);
	}else if("2".equals(operation)){//获取主表信息，并做检查是否配置
		result = sac.getSystemConfigMain(pageSize,pageIndex);
		//rs.writeLog("result======"+result);
	}else if ("3".equals(operation)){//获取明细表信息并做检查是否配置
		result = sac.getSystemConfigDetail(mainId);
	}else if("4".equals(operation)){//根据明细id,自动配置明细
		String detailid =  Util.null2String(request.getParameter("detailid"));
		String updatetype =  Util.null2String(request.getParameter("updatetype"));
		String filetype =  Util.null2String(request.getParameter("filetype"));
		if(filetype.toLowerCase().equals("properties")){
			result = sac.updatePropConfig(detailid, updatetype);
		}else if(filetype.toLowerCase().equals("xml")){
			result = sac.updateXmlConfig(detailid,updatetype);
		}
	}
	result = SecurityHelper.encrypt("wEAVERiNFO",result);
	//System.out.println("result;;;"+result);
	out.print(result);%>
