<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.general.*"%>
<%@page import="java.util.*"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.contractn.util.Constant" %>
<%@page import="java.net.*"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.contractn.entity.CommentEntity"%>
<jsp:useBean id="dynamic"
    class="weaver.contractn.entity.DynamicEntity" scope="page" />
<jsp:useBean id="commentServiceImpl"
	class="weaver.contractn.serviceImpl.CommentServiceImpl" scope="page" />
<jsp:useBean id="dynamicServiceImpl"
	class="weaver.contractn.serviceImpl.DynamicServiceImpl" scope="page" />
<jsp:useBean id="selectItemServiceImpl"
	class="weaver.contractn.serviceImpl.SelectItemServiceImpl" scope="page" />
<jsp:useBean id="ResourceComInfo"
	class="weaver.hrm.resource.ResourceComInfo" scope="page" />
	<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%
User user = MobileUserInit.getUser(request, response);
    String userid = user.getUID() + "";
    String userName = user.getLastname();
    String date = TimeUtil.getCurrentDateString();
    String time = TimeUtil.getOnlyCurrentTimeString();
    String action = request.getParameter("action");//动作
    String cid = request.getParameter("cid");//合同id
    String dynamicType = request.getParameter("dynamicType");
    CommentEntity comment = new CommentEntity();
    if ("getConsComment".equals(action)) {//获取合同评论
        if ("comment".equals(dynamicType)) {
            comment.setDataid(cid);
            out.print(Util.null2String(commentServiceImpl.queryCommentList(comment)));
        } else if ("dynamic".equals(dynamicType)) {
            dynamic.setDataid(cid);
            out.print(Util.null2String(dynamicServiceImpl.queryDynamic(dynamic)));
        } else {
        	out.print(Util.null2String(dynamicServiceImpl.queryDynamicIncludeComments(cid)));
        //添加查看日志
        dynamic.setType(Constant.COMMENT_TYPE_DYNAMIC_SELECTITEMVALUE);
        dynamic.setModule("cons_info");
        dynamic.setDataid(cid);
        dynamic.setOperateType(Constant.VIEW_OPERATETYPE_DYNAMIC_SELECTITEMVALUE);
        dynamic.setUsrId(Integer.parseInt(userid == null ? "1" : userid));
        dynamic.setCreateUser(userName);
        dynamicServiceImpl.sava(dynamic);
        }
        
    } else if ("addComment".equals(action)) {//添加合同评论
            String moduleid = request.getParameter("moduleid");
            String fileIds = Util.null2String(request.getParameter("fileIds"));
            String content = URLDecoder.decode(request.getParameter("content"), "UTF-8");//内容
            String requestId = UUID.randomUUID().toString();
            String sql = "insert into uf_t_cons_comment (dataid,moduleid,content,create_date,create_time,create_usr,requestId) values('" + cid + "','" + moduleid + "','" + content + "','" + date + "','" + time + "','" + userid + "','"+requestId+"')";
            RecordSet rs = new RecordSet();
            rs.executeSql(sql);
            RecordSet rs1 = new RecordSet();
            String id = "";
            rs1.executeSql("select id from uf_t_cons_comment where requestId = '"+requestId+"'");
            while(rs1.next()){
                 id = rs1.getString("id");
            }
            if(!"".equals(id)){
                String[] files = fileIds.split(",");
                int len = files == null ? 0 : files.length;
                for(int i = 0 ;i < len ;i++){
                    RecordSet rs2 = new RecordSet();
                    sql = "update "+Constant.FILE_TABLENAME+" set data_id = "+ id +" where id = '"+files[i]+"'";
                    rs2.executeSql(sql);
                }
            }
            if("comment".equals(dynamicType)){
            	 comment.setDataid(cid);
                 out.print(commentServiceImpl.queryCommentList(comment));
            }else{
            	out.print(dynamicServiceImpl.queryDynamicIncludeComments(cid));
            }
            
            
    } else if ("addReply".equals(action)) {//添加合同评论的回复
        String moduleid = request.getParameter("moduleid");
        String content = URLDecoder.decode(request.getParameter("content"), "UTF-8");//内容
        String pid = request.getParameter("pid");//
        String sql = "insert into uf_t_cons_comment (pid,dataid,moduleid,content,create_date,create_time,create_usr) values('" + pid + "','" + cid + "','" + moduleid + "','" + content + "','" + date + "','" + time + "','" + userid + "')";
        RecordSet rs = new RecordSet();
        rs.executeSql(sql);
        if("comment".equals(dynamicType)){
        	 comment.setDataid(cid);
             out.print(commentServiceImpl.queryCommentList(comment));
        }else{
        	out.print(dynamicServiceImpl.queryDynamicIncludeComments(cid));
        }
    } else if ("delReply".equals(action)) {//删除
    	String data_id = request.getParameter("data_id");
        String sql = "delete from uf_t_cons_comment where id='" + data_id + "'";
        RecordSet rs = new RecordSet();
        rs.executeSql(sql);
        if("comment".equals(dynamicType)){
        	 comment.setDataid(cid);
             out.print(commentServiceImpl.queryCommentList(comment));
        }else{
        	out.print(dynamicServiceImpl.queryDynamicIncludeComments(cid));
        }
    } else if ("editComment".equals(action)) {//编辑评论信息
    	String data_id = request.getParameter("id");
        String content = URLDecoder.decode(request.getParameter("content"), "UTF-8");//内容
        String sql = "update uf_t_cons_comment set content='" + content + "' where id=" + data_id;
        RecordSet rs = new RecordSet();
        rs.executeSql(sql);
        if("comment".equals(dynamicType)){
        	 comment.setDataid(cid);
             out.print(commentServiceImpl.queryCommentList(comment));
        }else{
        	out.print(dynamicServiceImpl.queryDynamicIncludeComments(cid));
        }
    }
    
%>

