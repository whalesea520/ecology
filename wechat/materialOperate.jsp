<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@page import="weaver.wechat.cache.*"%>
<%@page import="weaver.wechat.bean.*"%>
<%@ page import="weaver.general.Util,java.net.*" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.wechat.util.DateUtil"%>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@page import="oracle.sql.CLOB"%>
<%@page import="java.io.Writer"%>
<%@page import="weaver.wechat.request.menu.*,weaver.wechat.util.Const.MENU_TYPE"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cs" class="weaver.conn.ConnStatement" scope="page" />
<%
	String operate=request.getParameter("operate");
	String newsId=Util.null2String(request.getParameter("newsId"));
	String userId=Util.null2String(request.getParameter("userId"));
	String dsporder=Util.null2String(request.getParameter("dsporder"));
	if("add".equals(operate)){//添加
		try{
			boolean isoracle = (cs.getDBType()).equals("oracle");

			String picUrl=Util.null2String(request.getParameter("picUrl"));
			String url=Util.null2String(request.getParameter("url"));

			String title=URLDecoder.decode(Util.null2String(request.getParameter("title")),"UTF-8");
			String summary=URLDecoder.decode(Util.null2String(request.getParameter("summary")),"UTF-8");
			String content=URLDecoder.decode(Util.null2String(request.getParameter("content")),"UTF-8");
			String all=Util.null2String(request.getParameter("all"));
			String time=DateUtil.getCurrentTime(null);
			//true 自动保存 false 主动保存
			if("true".equals(all)||"false".equals(all)){//只有最后离开页面或者主动点击保存，记录备注和更新时间
				String remark=URLDecoder.decode(Util.null2String(request.getParameter("remark")),"UTF-8");
				if("false".equals(all)){//
					rs.execute("update wechat_news set name='"+remark+"',updatetime='"+time+"' where id="+newsId);
				}else{
					rs.execute("update wechat_news set name='"+remark+"' where id="+newsId);
				}
				
				
			}else{
				//rs.execute("update wechat_news set updatetime='"+time+"' where id="+newsId);
			}
			String sql="";
			rs.execute("select id from wechat_news_material where newsId="+newsId+" and dsporder="+dsporder+" and userid="+userId);
			if(rs.next()){
				if(isoracle){
					sql="update wechat_news_material set title=?,summary=?,content=empty_clob(),picUrl=?,url=? where id=?";
					cs.setStatementSql(sql);
					cs.setString(1,title);
					cs.setString(2,summary);
					cs.setString(3,picUrl);
					cs.setString(4,url);
					cs.setString(5,rs.getString("id"));
					cs.executeUpdate();

					sql="select content from wechat_news_material where id=? for update ";
					cs.setStatementSql(sql, false);
					cs.setString(1,rs.getString("id"));
					cs.executeQuery();
					cs.next();
					CLOB theclob = cs.getClob(1);

					String contenttemp = content; // (new
					// String(this.doccontent.getBytes("ISO8859_1"),
					// "GBK")) ;
					char[] contentchar = contenttemp.toCharArray();
					Writer contentwrite = theclob.getCharacterOutputStream();
					contentwrite.write(contentchar);
					contentwrite.flush();
					contentwrite.close();

				}else{
					sql="update wechat_news_material set title=?,summary=?,content=?,picUrl=?,url=? where id=?";
					cs.setStatementSql(sql);
					cs.setString(1,title);
					cs.setString(2,summary);
					cs.setString(3,content);
					cs.setString(4,picUrl);
					cs.setString(5,url);
					cs.setString(6,rs.getString("id"));
					cs.executeUpdate();
				}
				cs.close(); //关闭数据库连接
			}else{
				if(isoracle){
					sql="insert into wechat_news_material(title,summary,content,picUrl,url,newsId,dsporder,userid) values(?,?,empty_clob(),?,?,?,?,?)";
					cs.setStatementSql(sql);
					cs.setString(1,title);
					cs.setString(2,summary);
					cs.setString(3,picUrl);
					cs.setString(4,url);
					cs.setString(5,newsId);
					cs.setString(6,dsporder);
					cs.setString(7,userId);
					cs.executeUpdate();

					sql="select content from wechat_news_material  where newsId=? and dsporder=? and userid=? for update ";
					cs.setStatementSql(sql, false);
					cs.setString(1,newsId);
					cs.setString(2,dsporder);
					cs.setString(3,userId);
					cs.executeQuery();
					cs.next();
					CLOB theclob = cs.getClob(1);

					String contenttemp = content; // (new
					// String(this.doccontent.getBytes("ISO8859_1"),
					// "GBK")) ;
					char[] contentchar = contenttemp.toCharArray();
					Writer contentwrite = theclob.getCharacterOutputStream();
					contentwrite.write(contentchar);
					contentwrite.flush();
					contentwrite.close();

				}else{
					sql="insert into wechat_news_material(title,summary,content,picUrl,url,newsId,dsporder,userid) values(?,?,?,?,?,?,?,?)";
					cs.setStatementSql(sql);
					cs.setString(1,title);
					cs.setString(2,summary);
					cs.setString(3,content);
					cs.setString(4,picUrl);
					cs.setString(5,url);
					cs.setString(6,newsId);
					cs.setString(7,dsporder);
					cs.setString(8,userId);
					cs.executeUpdate();
				}
				cs.close(); //关闭数据库连接
			} 
			out.print(true);
		}catch(Exception e){
			out.print(false);
		}
		
	}else if("del".equals(operate)){//删除
		rs.execute("delete from wechat_news_material where newsId="+newsId+" and dsporder="+dsporder+" and userid="+userId);
		out.print(true);
	}else if("query".equals(operate)){//查询
		rs.execute("select * from wechat_news_material where newsId="+newsId+" and dsporder="+dsporder+" and userid="+userId);
		String title="";
		String picUrl="";
		String summary="";
		String content="";
		String url="";
		if(rs.next()){
			title=Util.null2String(rs.getString("title"));
			summary=Util.null2String(rs.getString("summary"));
			content=Util.null2String(rs.getString("content"));
			picUrl=Util.null2String(rs.getString("picUrl"));
			url=Util.null2String(rs.getString("url"));
		}
		Map map=new HashMap();
		map.put("title",title);
		map.put("summary",summary);
		map.put("content",content);
		map.put("picUrl",picUrl);
		map.put("url",url);
		out.print(JSONObject.toJSONString(map));
	}else if("queryUrl".equals(operate)){
		String url="";
		rs.execute("select url from wechat_news_material where newsId="+newsId+" and dsporder="+dsporder+" and userid="+userId);
		if(rs.next()){
			url=Util.null2String(rs.getString("url"));
		}
		if("".equals(url)){
			url="/wechat/view.jsp?nid="+newsId+"&uid="+userId+"&dsp="+dsporder;
		}
		Map map=new HashMap();
		map.put("url",url);
		out.print(JSONObject.toJSONString(map));
	}
%>
