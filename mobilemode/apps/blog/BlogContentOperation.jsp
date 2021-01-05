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
    
Date today=new Date();
String curDate=new SimpleDateFormat("yyyy-MM-dd").format(today);//当前日期
String curTime=new SimpleDateFormat("HH:mm:ss").format(today);//当前时间
SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
SimpleDateFormat dateFormat3=new SimpleDateFormat("yyyy年M月d日 HH:mm");

String content=Util.null2String(fileUpload.getParameter("fieldname_content"));//日志内容

String forDate=Util.null2String(fileUpload.getParameter("fieldname_workdate"));
String appItemId=Util.null2String(fileUpload.getParameter("fieldname_appItemId"));
int discussid=Util.getIntValue(Util.null2String(fileUpload.getParameter("fieldname_comefrom")),0);
//防止数据传输缺失
if(content.equals("")||forDate.equals("")||appItemId.equals("0")){
	result.put("status","3");
	JSONObject json=JSONObject.fromObject(result);
	out.println(json);
}else{
	appItemId=appItemId.equals("2")?appItemId:"1"; //处理心情丢失情况	
	String score="0";
	String comefrom="0";
	
	BlogDao blogDao=new BlogDao();
	String isManagerScore=blogDao.getSysSetting("isManagerScore");  //启用上级评分
	//System.out.println("content:"+content+"discussid:"+discussid);
	boolean isEdit=discussid!=0?true:false;  //是否是编辑
	
	String lastUpdateTime=""+today.getTime();
	String sql="";
	AppDao appDao=new AppDao();
	boolean isAppend=false;
	try{
		if(!isEdit){ //如果微博记录id=0 则表示为创建
			BlogDiscessVo discessVo=blogDao.getDiscussVoByDate(userid,forDate);
			if(discessVo!=null){ //判断是否为新增微薄，discessVo为null为新增，否则当天的内容追加当天内容下：冯广硕
			 if(discessVo.getUserid().equals(userid)){ //防止通过ajax更新他人微博
				isAppend=true;
				content=discessVo.getContent()+content;
				if(isoracle){//oracle数据库的clob字段需要用流的方式加到数据库
					sql="update blog_discuss set lastUpdatetime=?,content=empty_clob() where id=?";
					cs.setStatementSql(sql);
					cs.setString(1,lastUpdateTime);
					//cs.setString(2,"empty_clob()");
					cs.setString(2,discessVo.getId());
					//System.out.println("++++++++++++++++++++1");
					cs.executeQuery();
					sql="select content from blog_discuss where id=? for update ";
					cs.setStatementSql(sql, false);
					cs.setString(1,discessVo.getId());
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
					sql="update blog_discuss set lastUpdatetime=?,content=? where id=?";
					cs.setStatementSql(sql);
					cs.setString(1,lastUpdateTime);
					cs.setString(2,content);
					cs.setString(3,discessVo.getId());
				}			
			   }	
			}else{//新增微薄
			 if (isoracle) {
				 sql="insert into blog_discuss (userid, createdate, createtime,content,lastUpdatetime,isReplenish,workdate,score,comefrom)"+
						"values (?, ?,?,empty_clob(),?,?,?,?,?)";
					cs.setStatementSql(sql);
					cs.setString(1,""+userid);
					cs.setString(2,""+curDate);
					cs.setString(3,""+curTime);
					//cs.setString(4,"empty_clob()");
					//System.out.println("++++++++++++++++++++2");
					cs.setString(4,""+lastUpdateTime);
					cs.setString(5,""+(forDate.equals(curDate)?"0":"1"));
					cs.setString(6,""+forDate);
					cs.setString(7,"0");
					cs.setString(8,"4");
				    cs.executeQuery();
				   
					sql="select content from  blog_discuss where id = (select max(id) from blog_discuss ) for update ";
					cs.setStatementSql(sql, false);
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
				sql="insert into blog_discuss (userid, createdate, createtime,content,lastUpdatetime,isReplenish,workdate,score,comefrom)"+
					"values (?, ?,?,?,?,?,?,?,?)";	
				cs.setStatementSql(sql);
				cs.setString(1,""+userid);
				cs.setString(2,""+curDate);
				cs.setString(3,""+curTime);
				cs.setString(4,""+content);
				cs.setString(5,""+lastUpdateTime);
				cs.setString(6,""+(forDate.equals(curDate)?"0":"1"));
				cs.setString(7,""+forDate);
				cs.setString(8,"0");
				cs.setString(9,"4");
				}
			}
		}else{            //更新
			if(isoracle){
			    sql="update blog_discuss set lastUpdatetime=?,content=empty_clob() where id=? and userid="+userid;
				cs.setStatementSql(sql);
				cs.setString(1,""+lastUpdateTime);
				//cs.setString(2,"empty_clob()");
				//System.out.println("++++++++++++++++++++3");
				cs.setString(2,""+discussid);
				 if(cs.executeUpdate()>0){ //判断是否为修改自身微博 
				  sql="select content from  blog_discuss where id =? for update " ;
				   cs.setStatementSql(sql, false);
					cs.setString(1,""+discussid);
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
				 }  
			}else{
			    sql="update blog_discuss set lastUpdatetime=?,content=? where id=? and userid="+userid;
				cs.setStatementSql(sql);
				cs.setString(1,""+lastUpdateTime);
				cs.setString(2,""+content);
				cs.setString(3,""+discussid);
			
			}
		}
		
		HashMap backData=new HashMap();
		if(cs.executeUpdate()>0){
			cs.close(); //关闭数据库连接
			
			//如果是编辑，则取创建时的时间
			if(isEdit){
				BlogDiscessVo discessVo=blogDao.getDiscussVo(""+discussid);	
				curDate=discessVo.getCreatedate();
				curTime=discessVo.getCreatetime();
				score=discessVo.getScore();
				comefrom=discessVo.getComefrom();
			}
			//discuss=0表示新建
			if(!isEdit){
				sql="select max(id) as maxid  from blog_discuss where userid="+userid+"";
				rs.executeSql(sql);
				if(rs.next()){
					discussid=rs.getInt("maxid");
				}
			}
			
			
			
			String createdatetime=dateFormat3.format(dateFormat.parse(curDate+" "+curTime));
			String type=(!forDate.equals(curDate))?"1":"0"; //是否为补交  1补交 0正常提交
			
			result.put("status","1");  //保存是否成功
			
			if(appDao.getAppVoByType("mood").isActive()){
				if(!isEdit&&!isAppend){
					sql="INSERT INTO blog_appDatas(userid,workDate,createDate,createTime,discussid,appitemId)"+
						 "VALUES('"+user.getUID()+"','"+forDate+"','"+curDate+"','"+curTime+"','"+discussid+"','"+appItemId+"')";
				}else{
					sql="update blog_appDatas set  appitemId='"+appItemId+"' where discussid='"+discussid+"'";
				}
				rs.executeSql(sql);
				sql="SELECT * FROM blog_appDatas LEFT JOIN blog_AppItem ON blog_appDatas.appItemId=blog_AppItem.id WHERE discussid='"+discussid+"'";
				rs.executeSql(sql);
				if(rs.next()){
					backData.put("appItemId",appItemId);
					backData.put("faceImg",rs.getString("face"));
					backData.put("itemName",SystemEnv.getHtmlLabelName(Util.getIntValue(rs.getString("itemName")),user.getLanguage()));
				}
			}
			//提交新的微博时给予提醒
			if(!isEdit&&!isAppend){
				//删除阅读记录
				sql="DELETE FROM blog_read WHERE blogid='"+user.getUID()+"'";
				rs.executeSql(sql);
				
				//给关注我的人发送微博提交提醒
				List attentionMeList=blogDao.getAttentionMe(userid);
				for(int i=0;i<attentionMeList.size();i++){
					blogDao.addRemind((String)attentionMeList.get(i),userid,"6",""+discussid,"0");
				}
			}
			
		}else{
			result.put("status","0");
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
	result.put("fbuttonId", fileUpload.getParameter("fbuttonId"));// 提交按钮id
	JSONObject json=JSONObject.fromObject(result);
	out.print("<script type=\"text/javascript\">parent.Mobile_NS.formResponse("+json.toString()+");</script>");
}
out.flush();
out.close();    
%>