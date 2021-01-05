
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	
	
	FileUpload fu = new FileUpload(request);	

	
	String fileid = Util.null2String(fu.uploadFiles("Filedata"));
	/*String fileName="";
	if(!"".equals(fileid)){		
		String  strSql="select imagefilename from imagefile where imagefileid="+fileid;	
		rs.executeSql(strSql);
		if(rs.next()){
			fileName=Util.null2String(rs.getString("imagefilename"));
		}
	}*/
%>



<SCRIPT LANGUAGE=VBS>
     window.parent.returnvalue = Array("<%=fileid%>","<a href='/weaver/weaver.file.FileDownload?fileid=<%=fileid%>' target='_blank'><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></a>")
     window.parent.close
</SCRIPT>