<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="deu" class="weaver.docs.docs.DocExtUtil" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="cmutil" class="weaver.pr.util.TransUtil" scope="page"/>
<%
	DesUtil desUtil=new DesUtil();
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	//request.setCharacterEncoding("utf-8");
	FileUpload fu = new FileUpload(request,"utf-8");

	//User user = HrmUserVarify.getUser (request , response) ;
	//if(user == null)  return ;
	int userid=Util.getIntValue(desUtil.decrypt(fu.getParameter("userid")),0);
	int language=Util.getIntValue(fu.getParameter("language"),0);
	int logintype=Util.getIntValue(fu.getParameter("logintype"),0);
	int departmentid=Util.getIntValue(fu.getParameter("departmentid"),0);
	User user=new User();
	user.setUid(userid);
	user.setLanguage(language);
	user.setLogintype(""+logintype);
	user.setUserDepartment(departmentid);

	int mainId=Util.getIntValue(fu.getParameter("mainId"),0);
	int subId=Util.getIntValue(fu.getParameter("subId"),0);
	int secId=Util.getIntValue(fu.getParameter("secId"),0);
	String plandetailid=Util.getIntValue(fu.getParameter("plandetailid"),0)+"";

	StringBuffer restr = new StringBuffer();
	if(secId!=0){	
		int docid=deu.uploadDocToImg(fu,user, "Filedata",mainId,subId,secId,"","");
		if(!"0".equals(plandetailid)){
			String fieldvalue = docid+"";
			String oldfileids = "";
			
			rs.executeSql("select fileids from PR_PlanReportDetail where id="+plandetailid);
			if(rs.next()){
				oldfileids = Util.null2String(rs.getString(1));
			}
			fieldvalue = cmutil.cutString(fieldvalue,",",3);
			if(!"".equals(fieldvalue)) {
				if("".equals(oldfileids)) oldfileids = ",";
				oldfileids = oldfileids + fieldvalue + ",";
				rs.executeSql("update PR_PlanReportDetail set fileids='"+oldfileids+"' where id="+plandetailid);
			}
			List fileidList = Util.TokenizerString(oldfileids,",");
			for(int i=0;i<fileidList.size();i++){
				DocImageManager.resetParameter();
	            DocImageManager.setDocid(Integer.parseInt((String)fileidList.get(i)));
	            DocImageManager.selectDocImageInfo();
	            DocImageManager.next();
	            String docImagefileid = DocImageManager.getImagefileid();
	            int docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
	            String docImagefilename = DocImageManager.getImagefilename();
				restr.append("<div class='txtlink txtlink"+fileidList.get(i)+"' onmouseover='showdel(this)' onmouseout='hidedel(this)'>");
				restr.append("<div style='float: left;'>");
				restr.append("<a href=javaScript:openFullWindowHaveBar('/workrelate/plan/util/ViewDoc.jsp?id=" + fileidList.get(i)+"&plandetailid="+plandetailid+"')>"+docImagefilename+"</a>");
				restr.append("&nbsp;<a href='/workrelate/plan/util/ViewDoc.jsp?id="+fileidList.get(i)+"&plandetailid="+plandetailid+"&fileid="+docImagefileid+"'>下载("+docImagefileSize/1000+"K)</a>");
				restr.append("</div>");
				restr.append("<div class='btn_del' onclick=delItem('fileids','"+fileidList.get(i)+"')></div>");
				restr.append("<div class='btn_wh'></div>");
				restr.append("</div>");
			}
		}else{
			restr.append(docid);
		}
		
		out.println(restr.toString());
	} 
%>





