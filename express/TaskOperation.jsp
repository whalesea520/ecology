
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.blog.BlogDao"%>
<%@page import="weaver.task.TaskUtil"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.workflow.request.WFLinkInfo"%>
<%@page import="weaver.task.CommonTransUtil"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@page import="java.net.URLDecoder"%>
<%@ page import="weaver.docs.docs.*"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.conn.*"%>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.blog.BlogDao"%>
<%@page import="weaver.blog.BlogDiscessVo"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.blog.BlogShareManager"%>
<%@page import="java.text.MessageFormat"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.docs.docs.DocImageManager"%>
<jsp:useBean id="cmutil" class="weaver.task.CommonTransUtil" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo"></jsp:useBean>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo"></jsp:useBean>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo"></jsp:useBean>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
	String operation=Util.null2String(request.getParameter("operation"));
	String taskId = Util.null2String(request.getParameter("taskId"));
	String taskType = Util.null2String(request.getParameter("taskType"));
	String creater = Util.null2String(request.getParameter("creater"));
	String labelName = URLDecoder.decode(Util.null2String(request.getParameter("labei_name")),"utf-8");
	
	String userid=""+user.getUID();
	TaskUtil taskUtil=new TaskUtil();
	
	Date date = new Date();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    String d = sdf.format(date);
    StringBuffer remarkStr = new StringBuffer("");
	
    if(operation.equals("attention")||operation.equals("canview")){  //关注的，可查看的
    	BlogDao blogDao=new BlogDao();
        String returnstr="";
    	String nodes="";
    	String managerid=Util.null2String(request.getParameter("id"));
    	int total=0;
    	int pagesize=30;
    	int isFirst=Util.getIntValue(request.getParameter("isFirst"),0);
    	int pageindex=Util.getIntValue(request.getParameter("pageindex"),1);
    	if(managerid.equals("")){
	    	Map conditions=new HashMap();
	    	Map result=blogDao.getBlogMapList(userid,operation,conditions,pageindex,pagesize); 
	    	List blogList=(List)result.get("list");
	    	total=(Integer)result.get("total");
	    	for(int i=0;i<blogList.size();i++){
			      Map map=(Map)blogList.get(i);	 
			      String attentionid=(String)map.get("attentionid");
			      String username=resourceComInfo.getLastname(attentionid);
			      boolean isParent=taskUtil.hasHrmChild(attentionid);
			      nodes=nodes+",{id:"+attentionid+",pid:0,name:\""+username+"\",isParent:"+isParent+"}";
	    	}
    	}else{
    		List childList=taskUtil.getHrmChild(managerid);
    		for(int i=0;i<childList.size();i++){
    			String attentionid=(String)childList.get(i);
    			String username=resourceComInfo.getLastname(attentionid);
    			boolean isParent=taskUtil.hasHrmChild(attentionid);
    			nodes=nodes+",{id:"+attentionid+",pid:"+managerid+",name:\""+username+"\",isParent:"+isParent+"}";
    		}
    	}
    	if(nodes.length()>0) nodes=nodes.substring(1);
    	nodes="["+nodes+"]";
    	int totalpage=total%pagesize==0?total/pagesize:(total/pagesize+1);
    	returnstr="{nodes:"+nodes+",totalpage:"+totalpage+"}";
    	out.println(returnstr);
    }else if(operation.equals("markdate")){    //时间标记
    	String taskid=Util.null2String(request.getParameter("taskid"));
    	String tasktype=Util.null2String(request.getParameter("tasktype"));
    	String taskdate=Util.null2String(request.getParameter("taskdate"));
    	
    	taskUtil.markdate(taskid,tasktype,userid,taskdate);
    }else if(operation.equals("cleardate")){  //清除时间标记
    	
    	String taskid=Util.null2String(request.getParameter("taskid"));
    	String tasktype=Util.null2String(request.getParameter("tasktype"));
    	
    	String sql="delete from Task_schedule where userid="+userid+" and taskid="+taskid+" and tasktype="+tasktype;
    	rs.execute(sql);
    }
    //添加标签
    if(operation.equals("addLabel")){
    	String abeiId  = "";
    	int usreId = Integer.parseInt(userid);
    	if(!labelName.equals("")&&!labelName.equals("undefined")){
	    	rs.executeSql("select * from task_label where name ='"+labelName+"'");
	    	if(rs.getCounts() ==0){
	    	  	String sql1 = "INSERT into task_label (name,createor,createdate) values ('"+labelName+"',"+usreId+",'"+d+"')";
	        	rs.executeSql(sql1);
	        	String sql2 = "select * from task_label where name ='"+labelName+"'";
	        	rs.executeSql(sql2);
	        	while(rs.next()){
	        	  abeiId  = rs.getInt("id")+"";
	        	}
	        	String sql3 = "insert into Task_labelTask (userid,labelid,tasktype,taskid) values("+usreId+","+abeiId+","+taskType+","+taskId+")";
	       		rs.executeSql(sql3);
           		out.clearBuffer();
           		out.print(abeiId.toString());
           		out.flush();
	    	}else{
           		out.clearBuffer();
           		out.print("0".toString());
           		out.flush();
	    	}
    	}
    }
    //检查主线名称是否已经存在
    if(operation.equals("checkMainName")){
    	String labelName1 = Util.null2String(request.getParameter("name"));
    	String type = Util.null2String(request.getParameter("type"));
    	int result =0;
    	if(type.equals("mainlineset")){
    		rs.executeSql("select * from Task_mainline where name = '"+labelName1+"'");
    		if(rs.getCounts() == 0){
    			result = 1;
    		}
    	}else{
    		rs.executeSql("select * from task_label where name ='"+labelName1+"'");
    		if(rs.getCounts() == 0){
    			result = 1;
    		}
    	}
    	out.clearBuffer();
   		out.print(result+"");
   		out.flush();
    }
    //添加主线
    if(operation.equals("addMain")){
    	String idResult = "";
    	int abeiId  = 0;
    	int usreId = Integer.parseInt(userid);
    	if(labelName.equals("undefined") || labelName.equals("")){
    		return;
    	}else{
    		rs.executeSql("select * from Task_mainline where name = '"+labelName+"'");
    		if(rs.getCounts() == 0){
    			String sql1 = "INSERT into Task_mainline (name,createor,createdate,principalid) values ('"+labelName+"',"+usreId+",'"+d+"',"+userid+")";
            	rs.executeSql(sql1);
            	String sql2 = "select * from Task_mainline where name ='"+labelName+"'";
            	rs.executeSql(sql2);
            	while(rs.next()){
            		idResult  = rs.getInt("id")+"";
            		abeiId = Integer.parseInt(idResult);
            	}
            	out.print(idResult.toString());
            	String sql3 = "insert into Taks_mainlineTask (userid,mainlineid,tasktype,taskid) values ("+usreId+","+abeiId+","+taskType+","+taskId+")";
           		rs.executeSql(sql3);
           		rs.executeSql("select max(id) from Task_mainline");
           		String newID1 = "";
           		while(rs.next()){
           			newID1 = rs.getInt(1)+"";
           		}
           		out.clearBuffer();
           		out.print(newID1.toString());
           		out.flush();
    		}else{
           		out.clearBuffer();
    			out.print("0");
           		out.flush();
    		}
    	}
    	
    }
    if(operation.equals("getLableName")){
    	String sqlLabel = "SELECT name FROM task_label LEFT JOIN Task_labelTask t ON  task_label.id = t.labelid WHERE(t.userid="+userid+" AND t.taskid="+taskId+" AND t.tasktype="+taskType+")";
    	rs.executeSql(sqlLabel);
    	while(rs.next()){
    		remarkStr.append(rs.getString("name"));
    		remarkStr.append(" ");
    	}
    	String sqlMain = "SELECT name FROM Task_mainline LEFT JOIN Taks_mainlineTask t ON  Task_mainline.id = t.mainlineid WHERE(t.userid="+userid+" AND t.taskid="+taskId+" AND t.tasktype="+taskType+")";
    	rs.executeSql(sqlMain);
    	while(rs.next()){
			remarkStr.append(rs.getString("name"));
			remarkStr.append(" ");
    	}
    	out.print(remarkStr.toString());
   		out.flush();
    	
    }
    
    //关注操作
    if(operation.equals("addAttention1")){
    	String sql = "insert into Task_attention (userid,tasktype,taskid) values("+userid+","+taskType+","+taskId+")";
    	rs.executeSql(sql);
    }
    if(operation.equals("delAttention2")){
    	String sql = "delete from Task_attention where (userid = "+userid+" and tasktype="+taskType+" and taskid="+taskId+")";
    	rs.executeSql(sql);
    }
    //添加提醒
    if(operation.equals("addRemind")){
    	//remarktype为提醒的类型：1为一般提醒，2为关注提醒
    	String uid = Util.null2String(request.getParameter("userid"));
    	if(!uid.equals("0")){
    		String remarktype = Util.null2String(request.getParameter("remarktype"));
        	rs.executeSql("select * from Task_msg where( senderid ="+userid +"and receiverid="+creater +" and tasktype="+taskType+" and taskid="+taskId+")");
        	if(rs.getCounts() == 0){
    	    	String sql  = "insert into Task_msg (senderid,receiverid,tasktype,taskid,createdate,type) values ("+userid+"," + creater+ ","+ taskType +" ,"+ taskId+ " ,'"+ d+"',"+remarktype+")";
    	    	rs.executeSql(sql);
        	}
    	}
    }
    if(operation.equals("getAttention")){
    	CommonTransUtil ctu = new CommonTransUtil();
		rs.executeSql("select *from Task_msg where receiverid ="+user.getUID()+" and (type=2 or type=3 )");  
		String returnstr="";
		while(rs.next()){
			String tasktype = rs.getString("tasktype");
			String taskid = rs.getString("taskid");
			int id = rs.getInt("id");
			if(rs.getString("type").equals("2")){
				returnstr+="<div  onmousemove='delRemind("+tasktype+","+id+",this)'  class='message_contend'>"
						    +"<div class='task_name'>"
						    +"	<div style='float:left'>"+cmutil.getHrm(rs.getInt("senderid")+"")+"&nbsp;&nbsp;</div>"
						    +"	<div style='color:#666666; font-size:12px;float:left;'>关注了您的</div>&nbsp;"+ctu.getTaskName(tasktype,taskid) 
						    +"</div>"
						    +"&nbsp;&nbsp;&nbsp;&nbsp;<img id='newMsg' src='/express/images/msg_new_wev8.png'/>"
						    +"<div class='task_time'>"+rs.getString("createdate") +"</div>"
						   +"</div>";
				
			}else{
				returnstr+="<div  onmousemove='delRemind("+tasktype+","+id+",this)'  class='message_contend'>"
				    +"<div class='task_name'>"
				    +"	<div style='float:left'>"+cmutil.getHrm(rs.getInt("senderid")+"")+"&nbsp;&nbsp;</div>"
				    +"	<div style='color:#666666; font-size:12px;float:left;'>给您分享&nbsp;&nbsp;&nbsp;&nbsp;</div>&nbsp;"+ctu.getTaskName(tasktype,taskid) 
				    +"</div>"
				    +"&nbsp;&nbsp;&nbsp;&nbsp;<img id='newMsg' src='/express/images/msg_new_wev8.png'/>"
				    +"<div class='task_time'>"+rs.getString("createdate") +"</div>"
				   +"</div>";
			}
	    }
		out.println(returnstr);
	}
    if(operation.equals("getBlogRemind")){
    	
		BlogDao blogDao = new BlogDao();
		SimpleDateFormat dateFormat1=new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat dateFormat2=new SimpleDateFormat("M月d日");
		List remindList=blogDao.getMsgRemidList(user,"remind",""); 
		Map count=blogDao.getReindCount(user); 
	  	int remindCount=((Integer)count.get("remindCount")).intValue();  
	  	StringBuffer blogRemindStr = new StringBuffer();
	  	blogRemindStr.append("<div style='text-align: left; padding-left: 20px; padding-top: 10px;' class='msgContainer'>");
	  	 for(int i=0;i<remindList.size();i++){ 
	  	    Map map=(Map)remindList.get(i);
	  	    String id=(String)map.get("id");
	  	    String remindType=(String)map.get("remindType");
	  	    String remindid=(String)map.get("remindid");
	  	    String relatedid=(String)map.get("relatedid");
	  	    String remindValue=(String)map.get("remindValue");
	  	    blogRemindStr.append("<div id='msg_"+id+"' class='msg' style='width: 95%;border-bottom: #e3eef8 1px solid;margin-bottom: 8px;clear: both;height: 22px;background: url('images/remind_wev8.gif') no-repeat;padding-left: 20px;'>"+
	  	     					"<div style='text-align: left; float: left; padding-left: 5px;width:100%'>");
	  	    if(remindType.equals("1")){
	  	    	blogRemindStr.append(" <div style='text-decoration: none;float: left;'>"+
				  						 "<FONT class=font><FONT class=font>"+ResourceComInfo.getLastname(relatedid)+"&nbsp;"+SystemEnv.getHtmlLabelName(26988,user.getLanguage())+"</FONT></FONT>"+
				  						" </div>"+
				  						" <div style='float: right;'>"+
				       					"<a  style='margin-right: 8px;color: #1d76a4;text-decoration: none;'href='javascript:dealRequest("+relatedid+","+id+",'"+ResourceComInfo.getLastname(relatedid)+"',-1)>"+ResourceComInfo.getLastname(relatedid) +"</a>"+
				       					"<a  style='margin-right: 8px;color: #1d76a4;text-decoration: none;'href='javascript:dealRequest("+relatedid+","+relatedid+",'"+ResourceComInfo.getLastname(relatedid) +"',1)>"+ResourceComInfo.getLastname(relatedid) +"</a>"+
				   					"</div>");
	  	    }else if(remindType.equals("2")){
	  	    	blogRemindStr.append(" <div><a href='viewBlog.jsp?blogid="+relatedid+"' target='_blank' style='margin-right: 3px'>"+ResourceComInfo.getLastname(relatedid)+"</a>&nbsp;"+SystemEnv.getHtmlLabelName(26989,user.getLanguage())+"</div>");
	  	    	
	  	    }else if(remindType.equals("3")){
	  	    	blogRemindStr.append(" <div><a href='viewBlog.jsp?blogid="+relatedid+"' target='_blank' style='margin-right: 3px'>"+ResourceComInfo.getLastname(relatedid)+"</a>&nbsp;"+ResourceComInfo.getLastname(relatedid)+"</div>");
	  	    }
	  	}
	  	out.print(blogRemindStr.toString());
    }
    
    if(operation.equals("getRemind")){
    	CommonTransUtil ctu = new CommonTransUtil();
    	String taskType1 = Util.null2String(request.getParameter("taskType"));
    	String typesql="";
    	String returnstr="";
    	typesql=taskType1.equals("0")?"":" and tasktype="+taskType1;
    	rs.executeSql("select * from Task_msg where ( receiverid ="+user.getUID()+ typesql +" and type=1) ORDER BY createdate desc ");
    	while(rs.next()){
    		String tasktype = rs.getString("tasktype");
    		String taskid=rs.getString("taskid");
    		String type=rs.getString("type");
    		int id = rs.getInt("id");
    		
        	returnstr+="<div  onmousemove='delRemind("+tasktype+","+id+",this)' remindType='"+tasktype+"' class='message_contend'>"
					    +"<div class='task_name'>"
					    +"	<div style='float:left;width:40px'>"+cmutil.getHrm(rs.getInt("senderid")+"")+"&nbsp;&nbsp;</div>"
					    +"	<div style='color:#666666; font-size:12px;float:left'>"+(type.equals("1")?"提醒您处理":"提醒您关注")+"</div>&nbsp;"
					    +ctu.getTaskName(tasktype,taskid) 
					    +"</div>"
					    +"&nbsp;&nbsp;&nbsp;&nbsp;<img id='newMsg' src='/express/images/msg_new_wev8.png'/>"
					    +"<div class='task_time'>"+rs.getString("createdate") +"</div>"
					   +"</div>";
    	}
    	out.println(returnstr);
    }
    if(operation.equals("delRemind")){
    	String id = Util.null2String(request.getParameter("id"));
    	String resultString = "faile";
    	rs.executeSql("select * from task_msg where id = "+id);
    	if(rs.getCounts()>0){
    		resultString="success";
    	}
    	rs.executeSql("DELETE task_msg WHERE id = "+ id);
    	out.clearBuffer();
   		out.print(resultString.toString());
   		out.flush();
    }
    if(operation.equals("del_main")){
    	String mainId = Util.null2String(request.getParameter("mainId"));
    	rs.executeSql("delete Task_mainline where id = "+ mainId);
    }
    if(operation.equals("del_label")){
    	String labelid = Util.null2String(request.getParameter("labelid"));
    	rs.executeSql("DELETE Task_labelTask WHERE userid ="+userid+" AND labelid ="+labelid);
    	
    }
    //删除标签或者主线
    if(operation.equals("del_Label")){
    	String type = Util.null2String(request.getParameter("type"));
    	String id = Util.null2String(request.getParameter("id"));
    	String taskid = Util.null2String(request.getParameter("taskid"));
    	String tasktype = Util.null2String(request.getParameter("tasktype"));
    	if(type.equals("1")){
	    		rs.executeSql("DELETE FROM Task_labelTask WHERE (labelid = "+ id + " and taskid = " +taskid+ " and  tasktype ="+ tasktype +")" );
    	}
    	if(type.equals("2")){
    		rs.executeSql("DELETE FROM Taks_mainlineTask WHERE (mainlineid = "+ id +" and taskid = " +taskid+  " and  tasktype ="+tasktype+")" );
    	}
    }
    //给某个任务添加主线或者标签
    if(operation.equals("add_label_main")){
    	
    	String type = Util.null2String(request.getParameter("type"));
    	String id = Util.null2String(request.getParameter("id"));
    	String taskid = Util.null2String(request.getParameter("taskid"));
    	String tasktype = Util.null2String(request.getParameter("tasktype"));
    	String resqlt ="";
    	if(type.equals("1")){
    		rs.executeSql("select * from Task_labelTask where (userid= "+user.getUID()+" and labelid ="+id +" and tasktype ="+ tasktype + " and taskid =" +taskid +")");
    		if(rs.getCounts() == 0){
		    	rs.executeSql("insert into Task_labelTask (userid,labelid,tasktype,taskid) values("+user.getUID()+","+id+","+tasktype+","+taskid+")");
		    	resqlt = "1";
	    		}
    		}
    	
    	if(type.equals("2")){
    		rs.executeSql("select * from Taks_mainlineTask where (userid= "+user.getUID()+" and mainlineid ="+id +" and tasktype ="+ tasktype + " and taskid =" +taskid +")");
    		if(rs.getCounts() == 0){
    			String sql = "insert into Taks_mainlineTask (userid,mainlineid,tasktype,taskid) values ("+user.getUID()+","+id+","+tasktype+","+taskid+")";
	    		rs.executeSql(sql);
	    		resqlt="1";
    			}
    	}
    	out.println(resqlt.toString());
    	out.flush();
    }else if(operation.equals("getTaskFeedbackTotal")){
    	int allFeedbackTotal=taskUtil.getTaskFeedbackTotal(userid,"");
    	int attFeedbackTotal=taskUtil.getTaskFeedbackTotal(userid,"getAttFeedbackTotal");
    	String returnstr="{allFeedbackTotal:"+allFeedbackTotal+",attFeedbackTotal:"+attFeedbackTotal+"}";
    	out.println(returnstr);
    }else if(operation.equals("getFeedbackTotal")){
    	
    	String todaydate=TimeUtil.getCurrentDateString();
    	String halfMonthDate=TimeUtil.dateAdd(todaydate,-180);
    	
    	String timesql="b.createdate+' '+b.createtime>a.readdate+' '+a.readtime";
    	if(rs.getDBType().equals("oracle"))
    		 timesql="b.createdate||' '||b.createtime>a.readdate||' '||a.readtime";
    	
    	String tasksql="SELECT count(*) as total FROM TM_TaskFeedback b,"+taskUtil.getTaskSql(1,user.getUID()+"","") 
    	+" WHERE b.createdate>'"+halfMonthDate+"' and b.taskid=a.taskid AND "+timesql;

    	String coworksql="SELECT count(*) as total FROM cowork_discuss b,(select a.*,c.readdate,c.readtime from "+taskUtil.getCoworkSql(0,user.getUID()+"",halfMonthDate)+",(SELECT coworkid,modifydate AS readdate,modifytime AS readtime FROM cowork_log s1,(SELECT max(id) AS maxid FROM cowork_log WHERE modifier="+userid+" GROUP BY coworkid) s2 WHERE s1.id=s2.maxid) c where a.taskid=c.coworkid) a "
    	+" WHERE b.createdate>'"+halfMonthDate+"' and b.coworkid=a.taskid AND "+timesql;
    	
    	//未归档状态下所有流程
    	String wfsql="select count(*) total from "
    		+"(SELECT *  FROM workflow_requestLog s1,(SELECT max(logid) AS maxid FROM workflow_requestLog where operatedate>'"+halfMonthDate+"' GROUP BY requestid) s2 WHERE s1.logid=s2.maxid) b,"+taskUtil.getWorkflowSql(4,user.getUID()+"","")
    	    +" where (a.isfeedback=0 or a.isnew=0) and  b.requestid=a.taskid ";

    	String blogsql=" select count(*) as total FROM (SELECT id,remindValue FROM blog_remind WHERE createdate>'"+halfMonthDate+"' and remindid="+user.getUID()+" AND remindType=6) t0 LEFT JOIN blog_discuss t1 ON cast(t0.remindValue as int)=t1.id ";

    	String newssql="select count(*) total from "+taskUtil.getDocSql(1,userid,halfMonthDate)+" where createdate>'"+halfMonthDate+"' and isnew=0 and docpublishtype in(2,3)";
    	String docsql="select count(*) total from "+taskUtil.getDocSql(1,userid,halfMonthDate)+" where createdate>'"+halfMonthDate+"' and isnew=0 and docpublishtype=1";
    	
    	int alltotal=0;
    	int tasktotal=0;
    	int coworktotal=0;
    	int wftotal=0;
    	int blogtotal=0;
    	int newstotal=0;
    	int doctotal=0;

    	rs.execute(tasksql);
    	if(rs.next())
    	   tasktotal=rs.getInt("total");

    	rs.execute(coworksql);
    	if(rs.next())
    	   coworktotal=rs.getInt("total");

    	rs.execute(wfsql);
    	if(rs.next())
    		wftotal=rs.getInt("total");

    	rs.execute(blogsql);
    	if(rs.next())
    		blogtotal=rs.getInt("total");
    	
    	rs.execute(newssql);
    	if(rs.next())
    		newstotal=rs.getInt("total");
    	
    	rs.execute(docsql);
    	if(rs.next())
    		doctotal=rs.getInt("total");
    	
    	alltotal=tasktotal+coworktotal+wftotal+blogtotal;
    	
    	String result="{'tasktotal':"+tasktotal+",'coworktotal':"+coworktotal+",'wftotal':"+wftotal+",'blogtotal':"+blogtotal+",'alltotal':"+alltotal+",'newstotal':"+newstotal+",'doctotal':"+doctotal+"}";
    	out.println(result);
    }else if(operation.equals("getMainlineList")){   //获取主线列表
    	String sql="SELECT id,name from " 
    			  +"("
    			  +"SELECT DISTINCT id,name FROM Task_mainline a "
    			  +" left join (SELECT DISTINCT mainlineid FROM Task_mainlineShare WHERE userid="+userid+") b on b.mainlineid=a.id "
    			  +" WHERE b.mainlineid is not null OR a.createor="+userid+" OR principalid="+userid
    			  +" ) a "
    			  +",(SELECT DISTINCT mainlineid  FROM Taks_mainlineTask) c WHERE a.id=c.mainlineid ";
    	String resultstr="";
    	rs.execute(sql);
    	while(rs.next()){
    		String id=rs.getString("id");
    		String name=rs.getString("name");
    		resultstr+="<div class=\"label_item\" _type=\"mainline\" id=\""+id+"\">"+name+"</div>";
    	}

    	out.println(resultstr);
    }else if(operation.equals("getLabelList")){ ////获得标签列表
    	    String returnstr="";
    		rs.executeSql(taskUtil.getLabelTaskSql(userid,"tasktype,taskid",""));
    		while(rs.next()){
    			returnstr+="  <div class='label_item' _type='label' id="+rs.getInt("id")+">"+rs.getString("name")+"</div>";
    		}
    		out.print(returnstr);
    }else if(operation.equals("checkwfstatus")){  //检查流程状态
		int status=0;
		String taskid=Util.null2String(request.getParameter("taskid"));
		String sql="select taskid from "+taskUtil.getWorkflowSql(0,userid,"") +" where a.taskid="+taskid;
		rs.execute(sql);
		if(rs.next())
			status=1;
		out.println(status);
	}else if(operation.equals("checknew")){  //检查最新任务
	    
	    String sql=taskUtil.getCheckNewSql(userid);
	    
	    String returnstr="";
	    String newstr="";
	    String[] tasktypeNames={"任务","流程","会议","文档","协作","邮件"};
	    Map tasktypeMap=new HashMap();
	    tasktypeMap.put("0","流程");
	    
	    rs.execute(sql);
	    while(rs.next()){
	    	int tasktype=rs.getInt("tasktype");
	    	int total=rs.getInt("total");
	    	newstr+="<div align='left'>"
	    				+total+"个新到"+tasktypeMap.get(""+tasktype)
	    			   +"</div>";
	    }
	    /* type  0:流程 */
	    sql = "update SysPoppupRemindInfoNew set ifPup=0 where type=0 and userid ="+userid+" and usertype =0";
	    rs.execute(sql);
	    
	    int allFeedbackTotal=taskUtil.getTaskFeedbackTotal(userid,"");
    	int attFeedbackTotal=taskUtil.getTaskFeedbackTotal(userid,"getAttFeedbackTotal");
    	returnstr="{allFeedbackTotal:"+allFeedbackTotal+",attFeedbackTotal:"+attFeedbackTotal+",newstr:'"+newstr+"'}";
	    
	    out.println(returnstr);
	}else if(operation.equals("addShare")){ //添加分享
		String taskid=Util.null2String(request.getParameter("taskid"));
		String tasktype=Util.null2String(request.getParameter("tasktype"));
		String sharevalue=Util.null2String(request.getParameter("sharevalue"));
		
		if(tasktype.equals("2")){ //流程转发
			int requestid=Integer.parseInt(taskid);
			int workflowid=0;
			String requestname="";
			int wfcurrrid=0;
		
			WFLinkInfo WFLinkInfo=new WFLinkInfo();
			int nodeid=WFLinkInfo.getCurrentNodeid(requestid,Integer.parseInt(userid),0);
			rs.executeProc("workflow_Requestbase_SByID",requestid+"");
			if(rs.next()){ 
				workflowid=rs.getInt("workflowid");
				requestname= Util.null2String(rs.getString("requestname")) ;
			}
			rs.executeSql("select isremark,isreminded,preisremark,id,groupdetailid,nodeid from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and usertype=0 order by isremark,id ");
			if(rs.next()){
				wfcurrrid=rs.getInt("id");
			}
			session.setAttribute(userid+"_"+requestid+"wfcurrrid",wfcurrrid+"");
			session.setAttribute(userid+"_"+requestid+"nodeid",""+nodeid);
			session.setAttribute(userid+"_"+requestid+"workflowid",""+workflowid);
			session.setAttribute(userid+"_"+requestid+"requestname",requestname);
			if(sharevalue.startsWith(","))  sharevalue=sharevalue.substring(1);
			if(sharevalue.endsWith(","))  sharevalue=sharevalue.substring(0,sharevalue.length()-1);
			response.sendRedirect("/workflow/request/RemarkOperate.jsp?operate=save&remark=&requestid="+taskid+"&field5="+sharevalue);//节点id
		}else
			taskUtil.addTaskShare(taskid,tasktype,sharevalue);
		
		//发送分享提醒
		String[] sharevalues=sharevalue.split(",");
		String sql="";
		String createdate=TimeUtil.getCurrentDateString();
		for(int i=0;i<sharevalues.length;i++){
			String receiverid=sharevalues[i];
				if(!userid.equals(receiverid)){
					rs.executeSql("select * from Task_msg where senderid="+userid+" and receiverid="+receiverid+" and tasktype="+tasktype+" and taskid="+taskid+" and type=3");
					if(rs.getCounts() == 0){
						sql="insert into Task_msg(senderid,receiverid,tasktype,taskid,createdate,type) values ("+userid+","+receiverid+","+tasktype+","+taskid+",'"+createdate+"',3)";
				    	rs.execute(sql);
					}
				}
		}
	}
%>
