<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.docs.docs.reply.DocReplyModel" %>
<%@ page import="weaver.conn.RecordSet" %>
<jsp:useBean id="drm" class="weaver.docs.docs.reply.DocReplyManager" scope="page" />
<jsp:useBean id="SpopForDoc" class="weaver.splitepage.operate.SpopForDoc" scope="page"/>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;


//操作方式  saveReply：回复  delReply：删除回复  praise：点赞  unpraise：取消点赞
String operation = Util.null2String(request.getParameter("operation"));
int replyid = Util.getIntValue(request.getParameter("replyid"));
String docid = Util.null2String(request.getParameter("docid"));
int replytype = Util.getIntValue(request.getParameter("replytype"));
String orderby = Util.null2String(request.getParameter("orderby"),"desc");
int requestid = Util.getIntValue(request.getParameter("requestid"));
int currentnodeid = Util.getIntValue(request.getParameter("currentnodeid"));
Map result = new HashMap();
boolean canReader=false;
SpopForDoc.setIscloseMoreSql(true);
int userid=user.getUID();
String logintype = user.getLogintype();
String userType = ""+user.getType();
String userSeclevel = user.getSeclevel();
String userdepartment = ""+user.getUserDepartment();
String usersubcomany = ""+user.getUserSubCompany1();
String userInfo=logintype+"_"+userid+"_"+userSeclevel+"_"+userType+"_"+userdepartment+"_"+usersubcomany;
ArrayList PdocList = SpopForDoc.getDocOpratePopedom(""+docid,userInfo);
if (((String)PdocList.get(0)).equals("true")) canReader = true ;

if(operation.equals("workflowremark")){
	int cnodeid = 0;
	RecordSet rs = new RecordSet();
	String sql = "select * from workflow_requestbase where requestid ="+requestid;
	rs.executeSql(sql);
	if(rs.next()){
		cnodeid = rs.getInt("currentnodeid");
	}
	if(cnodeid==currentnodeid){
	result.put("result","success");
	}else{
    result.put("result","error");
	}
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
}else if(!canReader){ //文档没有查看权限，不能回复相关的操作
	result.put("error","0");
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
}else if(operation.equals("delReply")){
    String replymainid = Util.null2String(request.getParameter("replymainid"));
    RecordSet rs = new RecordSet();
    String sql = "select count(0) as replycount from doc_reply where docid = "+docid+" and PARENTID = "+replymainid+" and id > " +replyid +" AND reply_parentid != parentid";
    rs.executeSql(sql);
   	boolean canDel = true;
    if(rs.next())
    {
        if(rs.getInt("replycount") > 0)
        {
            canDel = false;
        }
    }
	if(canDel){
		rs.executeSql("select count(0) as replycount from doc_reply where docid = "+docid+" and reply_parentid="+replyid);
		if(rs.next())
		{
			if(rs.getInt("replycount") > 0)
			{
				canDel = false; //要删除的回复包含子回复时(即存在reply_parentid为当前删除的回复id的数据时)，不能删除
			}
		}
	}
	if(canDel){
		rs.executeSql("select count(0) as replycount from doc_reply where docid = "+docid+" and id="+replyid+" and userid="+userid);
		if(rs.next())
		{
			if(rs.getInt("replycount") <= 0)
			{
				canDel = false; //要删除的回复和文档不对应，不能删除,要删除的回复必须是操作者本人操作的
			}
		}
	}
    if(canDel)
    {
        drm.deleteReplyContent(replyid,docid);
    	result.put("result","sucess");
    }
    else
    {
        result.put("error","0");
    }
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
}else if(operation.equals("praise")){
	drm.praise(replyid,replytype,user.getUID(),docid);
	result.put("result","sucess");
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
}else if(operation.equals("unpraise")){
    drm.unPraise(replyid,replytype,user.getUID(),docid);
    result.put("result","sucess");
    JSONObject jo = JSONObject.fromObject(result);
    out.println(jo);
}
// 分页获取主回复列表信息
else if(operation.equals("moreReply")){
    int pageSize = Util.getIntValue(request.getParameter("pageSize"));
    int childrenSize = Util.getIntValue(request.getParameter("childrenSize"),5);
    List<DocReplyModel> drms = drm.getDocReply(docid,user.getUID()+"",false,replyid,pageSize,childrenSize,orderby);
    String jsonData = JSONArray.fromObject(drms).toString();
    out.println(jsonData);
}
// 所有剩余主回复数据
else if(operation.equals("allResidueReply")){
    int childrenSize = Util.getIntValue(request.getParameter("childrenSize"),5);
    List<DocReplyModel> drms = drm.getDocReply(docid,replyid+"",user.getUID()+"",false,childrenSize);
    String jsonData = JSONArray.fromObject(drms).toString();
    out.println(jsonData);
}
// 获取回复详情
else if(operation.equals("getReply")){
    RecordSet rs = new RecordSet();
    String sql = "select count(0) as replycount from doc_reply where reply_parentid = " +replyid;
    rs.executeSql(sql);
   	boolean canEdit = true;
    if(rs.next())
    {
        if(rs.getInt("RC") > 0)
        {
            canEdit = false;
        }
    }
    if(canEdit)
    {
        DocReplyModel docReplyModel = drm.getReplyByRid(docid,replyid+"",user.getUID()+"",false);
    	result.put("result","sucess");
    	result.put("docReplyModel",docReplyModel);
    }
    else
    {
        result.put("error","0");
    }
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
}
// 获取剩余子回复列表
else if(operation.equals("residue")){
    String replymainid = Util.null2String(request.getParameter("replymainid"));
    String lastReplyid = Util.null2String(request.getParameter("lastReplyid"));
    List<DocReplyModel> jsonList = drm.getResidueReplysForReply(lastReplyid,replymainid,docid,user.getUID()+"",false);
    String jsonData = JSONArray.fromObject(jsonList).toString();
    out.println(jsonData);
}

%>