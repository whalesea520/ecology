
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.DesUtil"%>	
<%@ page import="weaver.file.right.FileRightManager"%>
<%@ page import="weaver.file.constant.FileConstant"%>	
<jsp:useBean id="imgManger" class="weaver.docs.docs.DocImageManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	//request.setCharacterEncoding("utf-8");
	//String userid = Util.null2String()
	FileUpload fu = new FileUpload(request,"utf-8");
	int imagefileid = Util.getIntValue(fu.uploadFiles("Filedata"));
	String docfiletype = Util.null2String(fu.getParameter("docfiletype"));
	if(docfiletype.equals("")){
		docfiletype="1";
	}
	
	boolean hasRight = false;
	DesUtil desUtil = new DesUtil();
	
	User user = HrmUserVarify.getUser (request , response) ;
	
	if (null == user) {
	    return;
	}
	
	String userid = desUtil.encrypt(user.getUID()+"");

	if(!userid.equals("")){
		if(Util.getIntValue(desUtil.decrypt(userid))>0){
			hasRight = true;
		}
	}
	
	if(hasRight){
	    Calendar today = Calendar.getInstance();
	    String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
	            Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
	            Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
	    String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
	            Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
	            Util.add0(today.get(Calendar.SECOND), 2) ;
		int docid = Util.getIntValue(Util.null2String(fu.getParameter("docid")),0);
		rs.executeSql("insert into ImageFileTempPic(imagefileid,docid,createid,createdate,createtime,docfiletype) values("+imagefileid+","+docid+","+desUtil.decrypt(userid)+",'"+currentdate+"','"+currenttime+"','"+docfiletype+"')");

		FileRightManager.updateImageFileSource(imagefileid,FileConstant.comefrom_imagefiletemp,user.getUID(),user.getLogintype());
		
		out.println(imagefileid);
	}
	//out.println(imagefileid);	
	

%>





