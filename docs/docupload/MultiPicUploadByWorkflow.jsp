
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.docs.docs.DocExtUtil" %>
<%@ page import="weaver.conn.RecordSet" %>

<%
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
    //request.setCharacterEncoding("utf-8");


    User user = HrmUserVarify.getUser(request, response);
    if (user == null) return;

    FileUpload fu = new FileUpload(request, "utf-8",false);
    int mainId = Util.getIntValue(fu.getParameter("mainId"),0);
    int subId = Util.getIntValue(fu.getParameter("subId"),0);
    int secId = Util.getIntValue(fu.getParameter("secId"),0);
	RecordSet rs = new RecordSet();
	rs.executeSql("select count(1) as count from docseccategory where id ="+secId);
	rs.next();
	int count=rs.getInt("count");
	if( count<1 ){
		rs.writeLog("category "+secId+" is not exist");
		return ;
	}
    String[] filedata = new String[1];
    filedata[0] = "Filedata";
    DocExtUtil mDocExtUtil = new DocExtUtil();
    int[] returnarry = null;
    try{
    returnarry = mDocExtUtil.uploadDocsToImgs(fu, user, filedata,mainId,subId,secId,"","");
	}catch(Exception e){
		fu.writeLog("uplodError:"+e);
		fu.writeLog("errorWorkflowid:"+Util.getIntValue(fu.getParameter("workflowid"),0));
	}
    String tempvalue = "";
    if (returnarry != null) {
        for (int i = 0; i < returnarry.length; i++) {
            if (returnarry[i] != -1)
                if (tempvalue.trim().equals(""))
                    tempvalue = String.valueOf(returnarry[i]);
                else
                    tempvalue = tempvalue + "," + String.valueOf(returnarry[i]);
        }
    }
	fu.writeLog("from MultiPicUploadByWorkflow.jsp:workflowid"+Util.getIntValue(fu.getParameter("workflowid"),0)+",returnValue:"+tempvalue);
    out.println(tempvalue);
%>