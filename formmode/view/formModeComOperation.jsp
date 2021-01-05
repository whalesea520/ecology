<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.Util" %>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="java.text.SimpleDateFormat"%>
<jsp:useBean id="commentRecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("method"));
String rqmodeid = Util.null2String(request.getParameter("rqmodeid"));
String rqid = Util.null2String(request.getParameter("rqid"));
String commentid = Util.null2String(request.getParameter("commentid"));
if(operation.equals("editComment")){
	out.print(checkFormModeComment(rqmodeid,rqid,commentid));
}else if(operation.equals("deleteComment")){
	String optSign = Util.null2String(request.getParameter("sign"));
	if("comment".equals(optSign)){
		out.print(checkFormModeComment(rqmodeid,rqid,commentid));
	}else{
		commentRecordSet.executeSql("select * from uf_Reply where rqmodeid="+rqmodeid+" and rqid="+rqid+" and commentid="+commentid);
		if(commentRecordSet.getCounts()>0){
			out.print("1");
		}
	}
}else if(operation.equals("delRealyComment")){
	if(!StringHelper.isEmpty(commentid)){
		commentRecordSet.executeSql("delete uf_Reply where rqmodeid="+rqmodeid+" and rqid="+rqid+" and id="+commentid);
	}
}else if(operation.equals("getPagingInfo")){
	
	int modeId = Util.getIntValue(request.getParameter("modeId"),0);
	int billId = Util.getIntValue(request.getParameter("billId"),0);
	int pageSize = Util.getIntValue(request.getParameter("pageSize"),10);
	String sqlwhere = "";
	String fmCommentContent = Util.null2String(request.getParameter("fmCommentContent"));
	String fmCommentReplySdate = Util.null2String(request.getParameter("fmCommentReplySdate"));
	String fmCommentReplyEdate =  Util.null2String(request.getParameter("fmCommentReplyEdate"));
	String fmCommentReplyor = Util.null2String(request.getParameter("fmCommentReplyor"));
	String fmCommentFloorNum = Util.null2String(request.getParameter("fmCommentFloorNum"));
	if(!StringHelper.isEmpty(fmCommentContent)){
		sqlwhere+= " and replycontent like '%" + fmCommentContent + "%'";
	}
	if(!StringHelper.isEmpty(fmCommentReplySdate)){
		sqlwhere+= " and replydate >= '" + fmCommentReplySdate + "'";
	}
	if(!StringHelper.isEmpty(fmCommentReplyEdate)){
		sqlwhere+= " and replydate <= '" + fmCommentReplyEdate + "'";
	}
	if(!StringHelper.isEmpty(fmCommentReplyor)){
		sqlwhere+= " and replyor = '"+fmCommentReplyor+"'";
	}
	if (!StringHelper.isEmpty(fmCommentFloorNum)) { 
		sqlwhere+= " and floorNum = " + fmCommentFloorNum + "";
	}
	int totalCount = 0; //评论的总信息条数
	String selSql = "select count(1) from uf_Reply where rqmodeid="+modeId+" and rqid="+billId+" and commentid=0 "+sqlwhere+" ";
	commentRecordSet.executeSql(selSql);
	if(commentRecordSet.next()){
		totalCount = commentRecordSet.getInt(1);
	}
	int totalPages = (totalCount + pageSize - 1)/pageSize;//总共页数
    if (totalPages == 0) {
        totalPages = 1;
    }
	out.print(totalCount+"_"+totalPages);
}
%>
<%!
private int checkFormModeComment(String rqmodeid,String rqid,String commentid){
	Date nowdate=new Date();
	SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	RecordSet recordSet = new RecordSet();
	recordSet.executeSql("select * from uf_Reply where rqmodeid="+rqmodeid+" and rqid="+rqid+" and commenttopid="+commentid);
	if(recordSet.getCounts()>0){
		return 1;
	}
	recordSet.executeSql("select * from uf_Reply where rqmodeid="+rqmodeid+" and rqid="+rqid+" and quotesid="+commentid);
	if(recordSet.getCounts()>0){
		return 2;
	}
	recordSet.executeSql("select * from uf_Reply where rqmodeid="+rqmodeid+" and rqid="+rqid+" and id="+commentid);
	if(recordSet.next()){
		String dateStr = recordSet.getString("replydate")+" "+recordSet.getString("replytime");
	    try{
	    	Date discussDate=dateFormat.parse(dateStr);  
	    	long timePass=(nowdate.getTime()-discussDate.getTime())/(60*1000);
		    if(timePass>10){
		    	return 3;
		    }
	    }catch(Exception e){
	    	e.printStackTrace();
	    }
	}
	return 0;
}
%>
