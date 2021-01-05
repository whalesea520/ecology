<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.Util"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page import="weaver.conn.*" %>
<%@page import="java.util.HashMap"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.blog.AppDao"%>
<%@page import="weaver.blog.BlogDao"%>
<%@page import="weaver.blog.BlogManager"%>
<%@page import="java.util.List"%>
<%@page import="oracle.sql.CLOB"%>
<%@page import="java.io.Writer"%>
<%@page import="weaver.blog.BlogDiscessVo"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.conn.ConnStatement"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="weaver.hrm.resource.ResourceComInfo" %>
<%@page import="weaver.mobile.plugin.ecology.service.HrmResourceService" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cs" class="weaver.conn.ConnStatement" scope="page" />

<%

FileUpload fileUpload = new FileUpload(request,"UTF-8",false);
out.clearBuffer();
boolean isoracle = (cs.getDBType()).equals("oracle");
  
HashMap result=new HashMap();
HrmResourceService hrs = new HrmResourceService();
String userid = Util.null2String(fileUpload.getParameter("fieldname_userid"));
User user = hrs.getUserById(Util.getIntValue(userid));
if(user==null) {
	//未登录或登录超时
	result.put("error", "200001");
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
	return;
}
ResourceComInfo resourceComInfo=new ResourceComInfo();    
Date today=new Date();
String curDate=new SimpleDateFormat("yyyy-MM-dd").format(today);//当前日期
String curTime=new SimpleDateFormat("HH:mm:ss").format(today);//当前时间
SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
SimpleDateFormat dateFormat3=new SimpleDateFormat("yyyy年M月d日 HH:mm");

String content=Util.null2String(fileUpload.getParameter("fieldname_content"));//日志内容
String discussid=Util.null2String(fileUpload.getParameter("fieldname_discussid"));//被评论的日志id
String replyid=Util.null2String(fileUpload.getParameter("fieldname_comefrom"));//被评论的评论的id
String tempreplyid=Util.null2String(fileUpload.getParameter("fieldname_comefrom")); //被评论的评论的id

String relatedid=Util.null2String(fileUpload.getParameter("fieldname_relatedid")); //评论中相关人id


String commentType=Util.null2String(fileUpload.getParameter("fieldname_commentType"));//被评论的日志id
String workdate=Util.null2String(fileUpload.getParameter("fieldname_workdate"));//被评论的评论的id
String bediscussantid=Util.null2String(fileUpload.getParameter("fieldname_bediscussantid"));//被评论的评论的id

if("1".equals(relatedid)){
	content="<button type='button' relatedid='"+replyid+"' onclick='try{openBlog("+relatedid+");}catch(e){}' style='border:medium none;padding:0px;margin:0px;;background:none;color:#1d76a4;cursor:pointer;font-family:微软雅黑 !important;font-size:12px !important;font:none !important;height:18px !important;text-align:left;' contenteditable='false'  unselectable='off'>@"+resourceComInfo.getLastname(relatedid)+"</button>&nbsp;"+content;
}

HashMap backData=new HashMap();
ArrayList array=new ArrayList();
String remindSql="";
	
 try{
		String sql="insert into blog_reply (userid, discussid, createdate, createtime, content,comefrom,workdate,bediscussantid,commentType,relatedid)"+
			"VALUES (?, ?,?,?,?,?,?,?,?,?)";
		cs.setStatementSql(sql);
		cs.setString(1,""+userid);
		cs.setString(2,""+discussid);
		cs.setString(3,""+curDate);
		cs.setString(4,""+curTime);
		cs.setString(5,""+content);
		cs.setString(6,"4");
		cs.setString(7,""+workdate);
		cs.setString(8,""+bediscussantid);
		cs.setString(9,""+commentType);
		cs.setString(10,""+relatedid);
		if(cs.executeUpdate()>0){ 
			cs.close();
			sql="select max(id) maxid from blog_reply where userid="+userid;
			rs.execute(sql);
			rs.next();
			replyid=rs.getString("maxid");
			result.put("status","1");
		}else{
			result.put("status","0");
			result.put("backdata","内部错误");
		}
		}catch(Exception e){
			e.printStackTrace();
			result.put("status", "0");
			String errMsg = Util.null2String(e.getMessage());
			errMsg = URLEncoder.encode(errMsg, "UTF-8");
			errMsg = errMsg.replaceAll("\\+","%20");
			result.put("errMsg", errMsg);
		}
		finally{
			cs.close();
		}
		BlogDao blogdao=new BlogDao();
		if(!"0".equals(tempreplyid)){
			
			if(!bediscussantid.equals(userid))
				blogdao.addRemind(bediscussantid,userid,"9",discussid+"|0|"+replyid,"0");
			
			if(!relatedid.equals(userid)&&!bediscussantid.equals(relatedid))
			    blogdao.addRemind(relatedid,userid,"9",discussid+"|"+tempreplyid+"|"+replyid,"0");
		}else{ 
			
			if(!bediscussantid.equals(userid))
				   blogdao.addRemind(bediscussantid,userid,"9",discussid+"|0|"+replyid,"0");
		}
		
	result.put("fbuttonId", fileUpload.getParameter("fbuttonId"));// 提交按钮id
	JSONObject json=JSONObject.fromObject(result);
	out.print("<script type=\"text/javascript\">parent.Mobile_NS.formResponse("+json.toString()+");</script>");
out.flush();
out.close();    
%>