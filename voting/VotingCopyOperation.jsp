
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page buffer="4kb" autoFlush="true" errorPage="/notice/error.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet4" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet5" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet6" class="weaver.conn.RecordSet" scope="page" />
<%

	String currentdate = "";	   // 当前日期
	String currenttime = "";	   // 当前时间
	String sql = "";
	Calendar today = Calendar.getInstance();
	currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
			Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
			Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
	currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
			Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
			Util.add0(today.get(Calendar.SECOND), 2);
		
	String votingids = Util.null2String(request.getParameter("ids"));
	//是否为模板,给个默认值
	String istemplate =  Util.getIntValue(Util.null2String(request.getParameter("istempatea")),0)+"";
	//votingids = votingids.substring(0,votingids.lastIndexOf(","));
	//System.out.println("istemplate===="+istemplate);
	boolean isOracle = RecordSet1.getDBType().equals("oracle");
	String[] ids = votingids.split(",");
	for(int i=0;i<ids.length;i++){
		String id = ids[i];
		String insertSql = "";
		
		//调查基本信息 保持一致
		if(isOracle){
			insertSql=" insert into voting (id,subject,detail,createrid,createdate,createtime,approverid,begindate,begintime,enddate,endtime,isanony,status,isSeeResult,votingtype , descr , deploytype , autoshowvote , votetimecontrol , votetimecontroltime , forcevote , remindtype , remindtimebeforestart , remindtimebeforeend, istemplate) "
				 +" (select voting_id.nextval,subject,detail,"+user.getUID()+",'"+currentdate+"','"+currenttime+"',approverid,begindate,begintime,enddate,endtime,isanony,0,isSeeResult,votingtype,descr , deploytype , autoshowvote , votetimecontrol , votetimecontroltime , forcevote , remindtype , remindtimebeforestart , remindtimebeforeend,"+istemplate+" from voting where id = "+id+")";
		}else{    
			insertSql=" insert into voting (subject,detail,createrid,createdate,createtime,approverid,begindate,begintime,enddate,endtime,isanony,status,isSeeResult,votingtype , descr , deploytype , autoshowvote , votetimecontrol , votetimecontroltime , forcevote , remindtype , remindtimebeforestart , remindtimebeforeend, istemplate) "
				 +" (select subject,detail,"+user.getUID()+",'"+currentdate+"','"+currenttime+"',approverid,begindate,begintime,enddate,endtime,isanony,0,isSeeResult,votingtype, descr , deploytype , autoshowvote , votetimecontrol , votetimecontroltime , forcevote , remindtype , remindtimebeforestart , remindtimebeforeend,"+istemplate+" from voting where id = "+id+")";
		}
		RecordSet1.execute(insertSql);
		
		String idsSql = "select id from voting where createrid="+user.getUID()+" and createdate='"+currentdate+"' and createtime='"+currenttime+"' order by id desc ";
		RecordSet2.executeSql(idsSql);
		if(RecordSet2.next()){
			String votingId = RecordSet2.getString("id");
			String insertQuestionSql = "";
			if(isOracle){
				insertQuestionSql=" insert into votingquestion (id,description,votingid,ismulti,isother,questioncount,ismultino,subject,showorder,pagenum,questiontype,ismustinput,limit,max,perrowcols,israndomsort,imageWidth,imageHeight,copyquestion) "
					 +" ( select votingquestion_id.nextval,description,"+votingId+",ismulti,isother,questioncount,ismultino,subject,showorder,pagenum,questiontype,ismustinput,limit,max,perrowcols,israndomsort,imageWidth,imageHeight,id "
					 +" from ( select description,"+votingId+",ismulti,isother,questioncount,ismultino,subject,showorder,pagenum,questiontype,ismustinput,limit,max,perrowcols,israndomsort,imageWidth,imageHeight,id from votingquestion where votingid = "+id+" order by id))";
			}else{    
				insertQuestionSql = "insert into votingquestion (description,votingid,ismulti,isother,questioncount,ismultino,subject,showorder,pagenum,questiontype,ismustinput,limit,max,perrowcols,israndomsort,imageWidth,imageHeight,copyquestion)"
					 +" select description,"+votingId+",ismulti,isother,questioncount,ismultino,subject,showorder,pagenum,questiontype,ismustinput,limit,max,perrowcols,israndomsort,imageWidth,imageHeight,id from votingquestion where votingid="+id+" order by id ";
			}
			RecordSet3.execute(insertQuestionSql);
			//System.out.println(insertQuestionSql);
			//new question id
			//String questionIdsSql = "select id from votingquestion where votingid="+votingId+" order by id";
			//RecordSet4.executeSql(questionIdsSql);
			
			//old question id
			//String oldQuestionIdsSql = "select id from votingquestion where votingid="+id+" order by id";
			//RecordSet5.executeSql(oldQuestionIdsSql);
			
		//	while(RecordSet4.next() && RecordSet5.next()){
		//		String newQuestionId = RecordSet4.getString("id");
		//		String oldQuestionId = RecordSet5.getString("id");
		//		String insertOptionSql = "";
		//		if(isOracle){
		//			insertOptionSql = "insert into votingoption (id,votingid,questionid,description,optioncount,showorder,roworcolumn)"
		//				 +" (select votingoption_id.nextval,"+votingId+","+newQuestionId+",description,optioncount,showorder,roworcolumn "
		//				 +" from ( select "+votingId+","+newQuestionId+",description,optioncount,showorder,roworcolumn from votingoption where votingid="+id+" and questionid="+oldQuestionId+" order by id))";				
		//		}else{    
		//			insertOptionSql = "insert into votingoption (votingid,questionid,description,optioncount,showorder,roworcolumn)"
		//				 +" (select "+votingId+","+newQuestionId+",description,optioncount,showorder,roworcolumn from votingoption where votingid="+id+" and questionid="+oldQuestionId+")";
		//		}
		//		RecordSet6.execute(insertOptionSql);
		//	}
		
		String insertOptionSql = "";
		if(isOracle){
		    insertOptionSql = "insert into votingoption (id,votingid,questionid,description,optioncount,showorder,roworcolumn,remark,innershow,remarkorder,copyoption) " +
		    			" (select votingoption_id.nextval," + votingId + ",questionid,description,optioncount,showorder,roworcolumn,remark,innershow,remarkorder,copyoption " +
		    	        " from (select q.id questionid,o.description,o.optioncount,o.showorder,o.roworcolumn,remark,innershow,remarkorder,o.id copyoption " +
		    	        " from VotingQuestion q,VotingOption o where q.votingid=" + votingId + " and q.copyquestion=o.questionid  order by o.id))";
		}else{
		    insertOptionSql = "insert into votingoption (votingid,questionid,description,optioncount,showorder,roworcolumn,remark,innershow,remarkorder,copyoption) " +
		    			" (select " + votingId + ",q.id questionid,o.description,o.optioncount,o.showorder,o.roworcolumn,remark,innershow,remarkorder,o.id copyoption" +
		    	        " from VotingQuestion q,VotingOption o where q.votingid=" + votingId + " and q.copyquestion=o.questionid)";
		}
		
		RecordSet4.executeSql(insertOptionSql);
		
		String insertPathSql = "";
		if(isOracle){
		    insertPathSql = "insert into VotingPath(id,type,title,optionid,imagefileid,innershow) " +
		    			"(select votingpath_id.nextval,type,title,optionid,imagefileid,innershow " +
		    			" from (select p.type,p.title,o.id optionid,p.imagefileid,p.innershow "+
		    			" from VotingPath p,VotingOption o where o.votingid=" + votingId + " and o.copyoption=p.optionid order by o.id,p.id))";        
		}else{
		    insertPathSql = "insert into VotingPath(type,title,optionid,imagefileid,innershow) " +
		    			" (select p.type,p.title,o.id optionid,p.imagefileid,p.innershow "+
		    			" from VotingPath p,VotingOption o where o.votingid=" + votingId + " and o.copyoption=p.optionid)";    
		}
		
		RecordSet5.executeSql(insertPathSql);
			
			
			//处理参与范围
			if(isOracle){
				sql=" insert into VotingShare (id ,votingid ,sharetype , resourceid , subcompanyid ,departmentid , roleid , seclevel , rolelevel , foralluser,seclevelmax,joblevel,jobdepartment,jobsubcompany,jobtitles) "
					 +" ( select votingquestion_id.nextval,"+votingId+",sharetype , resourceid , subcompanyid ,departmentid , roleid , seclevel , rolelevel , foralluser,seclevelmax,joblevel,jobdepartment,jobsubcompany,jobtitles "
					 +" from ( select "+votingId+",sharetype , resourceid , subcompanyid ,departmentid , roleid , seclevel , rolelevel , foralluser,seclevelmax,joblevel,jobdepartment,jobsubcompany,jobtitles from VotingShare where votingid = "+id+" order by id))";
			}else{    
				sql = "insert into VotingShare (votingid ,sharetype , resourceid , subcompanyid ,departmentid , roleid , seclevel , rolelevel , foralluser,seclevelmax,joblevel,jobdepartment,jobsubcompany,jobtitles)"
					 +" select "+votingId+",sharetype , resourceid , subcompanyid ,departmentid , roleid , seclevel , rolelevel , foralluser,seclevelmax,joblevel,jobdepartment,jobsubcompany,jobtitles  from VotingShare where votingid="+id+" order by id ";
			}
			//System.out.println(sql);
			RecordSet6.execute(sql);
			//RecordSet6.executeProc("VotingShareDetail_Update",votingId);	
			
			//处理查看范围
			if(isOracle){
				sql=" insert into votingviewer (id ,votingid ,sharetype , resourceid , subcompanyid ,departmentid , roleid , seclevel , rolelevel , foralluser,seclevelmax,joblevel,jobdepartment,jobsubcompany,jobtitles) "
					 +" ( select votingquestion_id.nextval,"+votingId+",sharetype , resourceid , subcompanyid ,departmentid , roleid , seclevel , rolelevel , foralluser,seclevelmax,joblevel,jobdepartment,jobsubcompany,jobtitles "
					 +" from ( select "+votingId+",sharetype , resourceid , subcompanyid ,departmentid , roleid , seclevel , rolelevel , foralluser,seclevelmax,joblevel,jobdepartment,jobsubcompany,jobtitles from votingviewer where votingid = "+id+" order by id))";
			}else{    
				sql = "insert into votingviewer (votingid ,sharetype , resourceid , subcompanyid ,departmentid , roleid , seclevel , rolelevel , foralluser,seclevelmax,joblevel,jobdepartment,jobsubcompany,jobtitles)"
					 +" select "+votingId+",sharetype , resourceid , subcompanyid ,departmentid , roleid , seclevel , rolelevel , foralluser,seclevelmax,joblevel,jobdepartment,jobsubcompany,jobtitles from votingviewer where votingid="+id+" order by id ";
			}
			//System.out.println(sql);
			RecordSet6.execute(sql);
			//RecordSet6.executeProc("VotingViewerDetail_Update",votingId);
			
			
			//拷贝处理 调查表外观设置
			if(isOracle){
				sql=" insert into votingviewset (votingid ,viewjson) "
					 +" ( select "+votingId+",viewjson "
					 +" from ( select "+votingId+",viewjson from votingviewset where votingid = "+id+" ))";
			}else{    
				sql = "insert into votingviewset (votingid ,viewjson)"
					 +" select "+votingId+",viewjson from votingviewset where votingid="+id;
			}
			//System.out.println(sql);
			RecordSet6.execute(sql);
		}
	}
	//response.sendRedirect("VotingList.jsp");
	
	String alertsuccess = Util.null2String(request.getParameter("alertsuccess"));
	if("1".equals(alertsuccess)){
		out.println("<script>parent.alertsuccess("+istemplate+");window.open('VotingList.jsp?','mainFrame','') </script>");
		return;
	}
	
	//获取操作类型  importVoting 为 导入模板。为空则为 复制 或 另存模板操作
	String type = Util.null2String(request.getParameter("type"));
	if("importVoting".equals(type) && type != null){
		out.println("<script>parent.getParentWindow(window).MainCallback();</script>");
		
	}else{
		out.println("<script>window.open('VotingList.jsp?','mainFrame','') </script>");
	}
	//return;  
%>