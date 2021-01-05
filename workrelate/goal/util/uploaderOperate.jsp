<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="deu" class="weaver.docs.docs.DocExtUtil" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<jsp:useBean id="DesUtil" class="weaver.general.DesUtil" scope="page" />
<%
	
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	//request.setCharacterEncoding("utf-8");
	

	//User user = HrmUserVarify.getUser (request , response) ;
	//if(user == null)  return ;

	FileUpload fu = new FileUpload(request,"utf-8");
	int mainId=Util.getIntValue(fu.getParameter("mainId"),0);
	int subId=Util.getIntValue(fu.getParameter("subId"),0);
	int secId=Util.getIntValue(fu.getParameter("secId"),0);
	String taskId=Util.getIntValue(fu.getParameter("taskId"),0)+"";
	
	int userid=Util.getIntValue(DesUtil.decrypt(fu.getParameter("userid")),0);
	int language=Util.getIntValue(fu.getParameter("language"),0);
	int logintype=Util.getIntValue(fu.getParameter("logintype"),0);
	int departmentid=Util.getIntValue(fu.getParameter("departmentid"),0);
	User user=new User();
	user.setUid(userid);
	user.setLanguage(language);
	user.setLogintype(""+logintype);
	user.setUserDepartment(departmentid);
	
	StringBuffer restr = new StringBuffer();
	if(secId!=0){	
		int docid=deu.uploadDocToImg(fu,user, "Filedata",mainId,subId,secId,"","");
		if(!"0".equals(taskId)){
			String addfilename = "";
			DocImageManager.resetParameter();
	        DocImageManager.setDocid(docid);
	        DocImageManager.selectDocImageInfo();
	        if(DocImageManager.next()) addfilename = DocImageManager.getImagefilename();
			
			String fieldvalue = docid+"";
			String oldfileids = "";
			
			rs.executeSql("select fileids from GM_GoalInfo where id="+taskId);
			if(rs.next()){
				oldfileids = Util.null2String(rs.getString(1));
			}
			fieldvalue = cmutil.cutString(fieldvalue,",",3);
			if(!"".equals(fieldvalue)) {
				String currentdate = TimeUtil.getCurrentDateString();
				String currenttime = TimeUtil.getOnlyCurrentTimeString();
				if("".equals(oldfileids)) oldfileids = ",";
				oldfileids = oldfileids + fieldvalue + ",";
				rs.executeSql("update GM_GoalInfo set fileids='"+oldfileids+"' where id="+taskId);
				rs.executeSql("insert into GM_GoalLog (goalid,type,operator,operatedate,operatetime,operatefiled,operatevalue)"
							+" values("+taskId+",9,"+user.getUID()+",'"+currentdate+"','"+currenttime+"','fileids','"+addfilename+"')");
				restr.append("<div class='logitem'>"+cmutil.getHrm(user.getUID()+"")+"&nbsp;&nbsp;<font class='datetxt'>"+currentdate+" "+currenttime+"</font>&nbsp;&nbsp;"+"上传相关附件&nbsp;&nbsp;"+addfilename+"</div>$");
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
				restr.append("<a href=javaScript:openFullWindowHaveBar('/workrelate/goal/util/ViewDoc.jsp?id=" + fileidList.get(i)+"&taskId="+taskId+"')>"+docImagefilename+"</a>");
				restr.append("&nbsp;<a href='/workrelate/goal/util/ViewDoc.jsp?id="+fileidList.get(i)+"&taskId="+taskId+"&fileid="+docImagefileid+"'>下载("+docImagefileSize/1000+"K)</a>");
				restr.append("&nbsp;"+weaver.workrelate.util.TransUtil.getReviewLink(docImagefilename, docImagefileid, user.getLanguage(), user,1,String.valueOf(docid),taskId,""));
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





