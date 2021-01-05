<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="MouldManager" class="weaver.docs.mould.MouldManager" scope="page" />
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mould.DocMouldComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="log" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%
	MouldManager.resetParameter();
  	MouldManager.setLanguageid(user.getLanguage());
	MouldManager.setClientAddress(request.getRemoteAddr());
	MouldManager.setUserid(user.getUID());
	String operation = Util.null2String(request.getParameter("operation"));
	if(operation.equalsIgnoreCase("setDefault")){//设置默认模板
		String id = Util.null2String(request.getParameter("id"));
		String isuserdefault = Util.null2String(request.getParameter("isuserdefault"));
		rs.executeSql("select mouldType,mouldname from DocMould where id = "+id);
		String mouldType = "";
		String mouldName = "";
		String logsql = "";
		String sql = "";
		if(rs.next()){
			mouldType = Util.null2String(rs.getString(1));
			mouldName = Util.null2String(rs.getString(2));
		}
		sql = "update docMould set isuserdefault='0' where isuserdefault='1' and mouldType="+mouldType;
		boolean r = rs.executeSql(sql);
		logsql = sql;
		if(r){
			sql = "update docMould set isuserdefault='"+isuserdefault+"' where id="+id;
			logsql = logsql + ";"+sql;
			rs.executeSql(sql);
		}
		log.insSysLogInfo(user, Util.getIntValue(id), mouldName, logsql, "5", "2", 0, request.getRemoteAddr());
		out.println("1");
		MouldManager.removeDefaultMouldCache();
		return;
	}
  	String message = MouldManager.UploadMould(request);
  	DocMouldComInfo.removeDocMouldCache();
  	if(message.startsWith("delete_")){  		
  		int id=MouldManager.getId();
  		MouldManager.getMouldInfoById();
  		int mouldType = MouldManager.getMouldType();
  		String imgid=message.substring(7,8);
  		if(mouldType>1)
  			response.sendRedirect("DocMouldEditExt.jsp?messageid="+imgid+"&id="+id);
  		else
  			response.sendRedirect("DocMouldEdit.jsp?messageid="+imgid+"&id="+id);
  	}
  	else{
  		if(MouldManager.getIsDialog().equals("1")){
  			int mouldType = MouldManager.getMouldType();
	  		if(mouldType>1){
	  			response.sendRedirect("DocMouldAddExt.jsp?id="+MouldManager.getId()+"&isclose=1");
	  		}else{
	  			response.sendRedirect("DocMouldAdd.jsp?isclose=1");
	  		}
	  	}else if(MouldManager.getIsDialog().equals("2")){
	  		int mouldType = MouldManager.getMouldType();
			String oop2=MouldManager.getOperation();
	  		if(mouldType>1){
	  			response.sendRedirect("DocMouldEditExt.jsp?isclose=1");
	  		}else{
	  			response.sendRedirect("DocMouldEdit.jsp?isclose=1&operation="+oop2);
	  		}
	  	}else{
	  		response.sendRedirect("DocMould.jsp");
	  	}
	 }
	
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">