
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.net.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String operate=request.getParameter("operate");
	if("save".equals(operate)){//添加	编辑
		String id=request.getParameter("id");
		String publicid=request.getParameter("publicid");
		String name=URLDecoder.decode(request.getParameter("name"),"UTF-8");
		String sort=request.getParameter("sort");
		String replytype=request.getParameter("replytype");
		String replymsg=URLDecoder.decode(request.getParameter("replymsg"),"UTF-8");
		String classname=request.getParameter("classname");
		String state=request.getParameter("state");
		String news=request.getParameter("news");
		if("2".equals(replytype)){
			replymsg=news;
		}
		
		if(id!=null&&!"".equals(id)){//存在ID 编辑
			if(rs.executeSql("update wechat_reply set state='"+state+"', name='"+name+"',sort='"+sort+"',replytype='"+replytype+"',replymsg='"+replymsg+"',classname='"+classname+"' where id="+id)){
				out.print(true);
			}else{
				out.print(false);
			}
		}else{
			if(rs.executeSql("insert into wechat_reply(publicid,name,sort,replytype,replymsg,classname,state) values('"+publicid+"','"+name+"','"+sort+"','"+replytype+"','"+replymsg+"','"+classname+"','"+state+"')")){
				out.print(true);
			}else{
				out.print(false);
			}
		}
	}else if("del".equals(operate)){//删除
		String IDS=Util.null2String(request.getParameter("IDS"));//当前节点id
		if(IDS!=null&&!"".equals(IDS)){
			rs.executeSql("delete wechat_reply_rule where replyid in("+IDS+")");
			rs.executeSql("delete wechat_reply where id in ("+IDS+")");
			out.print(true);
		}else{
			out.print(false);
		}
	}else if("state".equals(operate)){//查询
		String id=request.getParameter("id");
		String state=request.getParameter("state");
		if(rs.executeSql("update wechat_reply set state='"+state+"' where id="+id)){
			out.print(true);
		}else{
		out.print(false);
		}
	}else if("addKeyword".equals(operate)){
		String replyid= request.getParameter("replyid");
		String keytype= request.getParameter("keytype");
		String keyword= URLDecoder.decode(request.getParameter("keyword"),"UTF-8").toUpperCase();
		if(rs.executeSql("insert into wechat_reply_rule(replyid,keytype,keyword) values('"+replyid+"','"+keytype+"','"+keyword+"')")){
			out.print(true);
		}else{
			out.print(false);
		}
	}else if("delKeyword".equals(operate)){
		String id= request.getParameter("id");
		if(rs.executeSql("delete wechat_reply_rule where id in ("+id+")")){
			out.print(true);
		}else{
			out.print(false);
		}
	}
%>
