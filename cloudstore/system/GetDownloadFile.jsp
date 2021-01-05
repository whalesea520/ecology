<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.Map,java.util.HashMap" %>
<%@ page import="weaver.conn.RecordSet" %>

<%
	//第一步，获取fieldid和fileid,只要两个有一个为空就返回;
	String fieldid = Util.null2String(request.getParameter("fieldid"));
	String fileid = Util.null2String(request.getParameter("fileid"));
	String requestid = Util.null2String(request.getParameter("requestid"));
	if("".equals(fieldid)||"".equals(fileid)) return;
	RecordSet rs = new RecordSet();
	//String checksql = "select fieldhtmltype,type from workflow_billfield where id ="+fieldid;
	//rs.execute(checksql);
	//if(rs.next()){
		//String htmldbtype =Util.null2String(rs.getString("fieldhtmltype"));
		//String type = Util.null2String(rs.getString("type"));
		String newfileid = fileid;
		//if("6".equals(htmldbtype)&&("1".equals(type)||"2".equals(type))){
		//	if("2".equals(type)){
				RecordSet rs2 = new RecordSet();
				String getnewidsql = "select ifa.imagefileid from DocDetail dd ,DocImageFile dcf ,ImageFile ifa where dd.id = dcf.docid and dcf.imagefileid = ifa.imagefileid and dd.id ='"+ fileid + "'";
				rs2.execute(getnewidsql);
				if(rs2.next()){
					newfileid = Util.null2String(rs2.getString(1));
				}
		//	}
			System.out.println("555555");
			if(!"".equals(newfileid)){
				System.out.println("new Url is :"+"/weaver/weaver.file.FileDownload?fileid="+newfileid+"&requestid="+requestid);
				response.sendRedirect("/weaver/weaver.file.FileDownload?fileid="+newfileid+"&requestid="+requestid);
			}
		//}
	//}
	
//response.sendRedirect("http://"+ip+"/person?key="+result+"&?");
%>
