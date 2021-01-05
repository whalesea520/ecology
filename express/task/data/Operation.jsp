
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="javax.print.attribute.standard.Fidelity"%>
<%@page import="weaver.task.CommonTransUtil"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@page import="java.net.URLDecoder"%>
<%@ page import="weaver.docs.docs.*"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.conn.*"%>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="cmutil" class="weaver.task.CommonTransUtil" scope="page"/>
<jsp:useBean id="taskUtil" class="weaver.task.TaskUtil" scope="page"/>
<%
	String operation = Util.fromScreen3(request.getParameter("operation"), user.getLanguage());
	String currentDate = TimeUtil.getCurrentDateString();
	String currentTime = TimeUtil.getOnlyCurrentTimeString();
	String sql = "";
	StringBuffer restr = new StringBuffer();
	
	Map fn = new HashMap();
	fn.put("name","名称");
	fn.put("level","紧急程度");
	fn.put("remark","描述");
	fn.put("risk","风险点");
	fn.put("difficulty","难度点");
	fn.put("assist","需协助点");
	fn.put("tag","任务标签");
	fn.put("principalid","责任人");
	fn.put("partnerid","参与人");
	fn.put("sharerid","分享者");
	fn.put("begindate","开始日期");
	fn.put("enddate","结束日期");
	fn.put("taskids","相关任务");
	fn.put("docids","相关文档");
	fn.put("wfids","相关流程");
	fn.put("crmids","相关客户");
	fn.put("projectids","相关项目");
	fn.put("fileids","相关附件");
	fn.put("date","任务日期");
	
	//新建
	if("add".equals(operation)){
		String name = Util.fromScreen3(URLDecoder.decode(request.getParameter("taskName"),"utf-8"),user.getLanguage());
		String sorttype = Util.fromScreen3(request.getParameter("sorttype"), user.getLanguage());
		String datetype = Util.fromScreen3(request.getParameter("datetype"), user.getLanguage());
		String principalid = Util.fromScreen3(request.getParameter("principalid"), user.getLanguage());
		if(principalid.equals("") || principalid.equals("0")){
			principalid = user.getUID()+"";
		}
		String begindate = "";
		String enddate = "";
		int level = 0;
		
		if(datetype.equals("0")){ //今天任务
			begindate = currentDate;
			enddate = currentDate;
		}else if(datetype.equals("1")){ //明天任务
			begindate = TimeUtil.dateAdd(currentDate,1);
			enddate = TimeUtil.dateAdd(currentDate,1);
		}else if(datetype.equals("2")){ //后天任务
			begindate = TimeUtil.dateAdd(currentDate,2);
			enddate = TimeUtil.dateAdd(currentDate,2);
		}
		if(sorttype.equals("3")){
			level = Util.getIntValue(datetype);
		}
		if(level==5) level=0;
		sql = "insert into TM_TaskInfo (name,status,creater,createdate,createtime,begindate,enddate,tasklevel,principalid) "
			+"values('"+name+"',1,"+user.getUID()+",'"+currentDate+"','"+currentTime+"','"+begindate+"','"+enddate+"',"+level+","+principalid+")";
		boolean res = rs.executeSql(sql);
		if(res){
			String taskId = "";
			rs.executeSql("select max(id) from TM_TaskInfo");
			if(rs.next()) taskId = rs.getString(1);
			restr.append(taskId);
			
			//taskUtil.markdate(taskId,"1",principalid,begindate);
			//记录日志
			this.writeLog(user,1,taskId,"","",fn);
		}
	}
	//编辑名称
	if("edit_name".equals(operation)){
		String taskId = Util.fromScreen3(request.getParameter("taskId"),user.getLanguage());
		String name = Util.fromScreen3(URLDecoder.decode(request.getParameter("taskName"),"utf-8"),user.getLanguage());
		sql = "update TM_TaskInfo set name='"+name+"' where id="+taskId;
		rs.executeSql(sql);
		//记录日志
		restr.append(this.writeLog(user,2,taskId,"name",name,fn));
	}
	
	if("edit_main".equals(operation)){
		String mainlineid = Util.fromScreen3(request.getParameter("mainlineid"),user.getLanguage());
		String fieldname = Util.fromScreen3(request.getParameter("fieldname"),user.getLanguage());
		String fieldvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("fieldvalue"),"utf-8"));
		String fieldtype = Util.fromScreen3(request.getParameter("fieldtype"),user.getLanguage());
		if(fieldname.endsWith("ids") && fieldvalue.equals(",")){
			fieldvalue = "";
		}
		if(fieldname.equals("name")){
			rs.executeSql("update Task_mainline set name = '"+fieldvalue +"', modifydate='"+currentDate +"' where id = "+mainlineid);
		}
		if(fieldname.equals("principalid")){
			if(fieldtype.equals("del")){//删除
				rs.executeSql("update Task_mainline set principalid = '0' where id = "+ mainlineid);
			}else{//添加
				rs.executeSql("update Task_mainline set principalid = "+ fieldvalue +", modifydate ='"+currentDate +"' where id = "+ mainlineid);
				}
			}
		if(fieldname.equals("remark")){
			rs.executeSql("update  Task_mainline set remark = '"+fieldvalue+"', modifydate ='"+currentDate+"' where id ="+mainlineid);
		}
		if(fieldname.equals("sharerid")){
			if(fieldtype.equals("del")){//删除
				rs.executeSql("delete from Task_mainlineShare where userid="+fieldvalue+" and mainlineid="+mainlineid+" and usertype=3");
			}else{//添加
				List shareridList = Util.TokenizerString(fieldvalue,",");
				String sharerid = "";
				for(int i=0;i<shareridList.size();i++){
					sharerid = Util.null2String((String)shareridList.get(i));
					if(!sharerid.equals("")){
						rs.executeSql("select from Task_mainlineShare where userid ="+sharerid+" and mainlineid="+mainlineid+" and usertype=3");
						if(rs.getCounts() == 0){
							rs.executeSql("insert into Task_mainlineShare (userid,mainlineid,usertype) values("+sharerid+","+mainlineid+",3)");
					}
				}
			}
			}
		}
		if(fieldname.equals("partnerid")){
			if(fieldtype.equals("del")){//删除
				rs.executeSql("delete from Task_mainlineShare where userid="+fieldvalue+" and mainlineid="+mainlineid+" and usertype=2");
			}else{//添加
				List shareridList = Util.TokenizerString(fieldvalue,",");
				String sharerid = "";
				for(int i=0;i<shareridList.size();i++){
					sharerid = Util.null2String((String)shareridList.get(i));
					if(!sharerid.equals("")){
						rs.executeSql("select from Task_mainlineShare where userid ="+sharerid+" and mainlineid="+mainlineid+" and usertype=2");
						if(rs.getCounts() == 0){
							rs.executeSql("insert into Task_mainlineShare (userid,mainlineid,usertype) values("+sharerid+","+mainlineid+",2)");
					}
				}
			}
			}
			}
		}
		
		
	if("edit_label".equals(operation)){
		String labelId = Util.fromScreen3(request.getParameter("labelId"),user.getLanguage());
		String fieldname = Util.fromScreen3(request.getParameter("fieldname"),user.getLanguage());
		String fieldvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("fieldvalue"),"utf-8"));
		String fieldtype = Util.fromScreen3(request.getParameter("fieldtype"),user.getLanguage());
		String ids = Util.null2String(request.getParameter("ids"));
		if(fieldname.equals("name")){
			rs.executeSql("select * from task_label where name = "+fieldvalue);
			if(rs.getCounts() == 0){
			    rs.executeSql("INSERT into task_label (name,createor,createdate) values ('"+fieldvalue+"',"+user.getUID()+",'"+currentDate+"')");
			    rs.executeSql("select max(id) from task_label");
				String newLabelId = "";
			    if(rs.next()){
			    	newLabelId = rs.getString(1);
			    }
				rs.executeSql("select * from Task_labelTask where userid="+user.getUID()+" and labelid =" + labelId);
				while(rs.next()){
					int taskType = rs.getInt("tasktype");
					int taskId = rs.getInt("taskid");
			    	rs2.executeSql("insert into Task_labelTask (userid,labelid,tasktype,taskid) values("+user.getUID()+","+newLabelId+","+taskType+","+taskId+")");
					rs2.executeSql("delete Task_labelTask where id = "+ rs.getInt("id"));
					
				}
			}
		}
		
	    	
		}

	//编辑字段
	if("edit_field".equals(operation)){
		String taskId = Util.fromScreen3(request.getParameter("taskId"),user.getLanguage());
		String fieldname = Util.fromScreen3(request.getParameter("fieldname"),user.getLanguage());
		String fieldvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("fieldvalue"),"utf-8"));
		String fieldtype = Util.fromScreen3(request.getParameter("fieldtype"),user.getLanguage());
		if(fieldname.endsWith("ids") && fieldvalue.equals(",")){
			fieldvalue = "";
		}
		if(fieldname.equals("partnerid")){//参与人
			if(fieldtype.equals("del")){//删除
				rs.executeSql("delete from TM_TaskPartner where taskid="+taskId+" and partnerid="+fieldvalue);
				//记录日志
				restr.append(this.writeLog(user,4,taskId,"partnerid",fieldvalue,fn));
			}else{//添加
				List partneridList = Util.TokenizerString(fieldvalue,",");
				String partnerid = "";
				for(int i=0;i<partneridList.size();i++){
					partnerid = Util.null2String((String)partneridList.get(i));
					if(!partnerid.equals("")){
						rs.executeSql("insert into TM_TaskPartner (taskid,partnerid) values("+taskId+","+partnerid+")");
					}
				}
				//记录日志
				restr.append(this.writeLog(user,3,taskId,"partnerid",fieldvalue,fn));
			}
		}else if(fieldname.equals("sharerid")){//分享人
			if(fieldtype.equals("del")){//删除
				rs.executeSql("delete from TM_TaskSharer where taskid="+taskId+" and sharerid="+fieldvalue);
				//记录日志
				restr.append(this.writeLog(user,4,taskId,"sharerid",fieldvalue,fn));
			}else{//添加
				List shareridList = Util.TokenizerString(fieldvalue,",");
				String sharerid = "";
				for(int i=0;i<shareridList.size();i++){
					sharerid = Util.null2String((String)shareridList.get(i));
					if(!sharerid.equals("")){
						rs.executeSql("insert into TM_TaskSharer (taskid,sharerid) values("+taskId+","+sharerid+")");
					}
					
				}
				//记录日志
				restr.append(this.writeLog(user,3,taskId,"sharerid",fieldvalue,fn));
			}
		}else if(fieldname.equals("principalid")){
			if(fieldtype.equals("del")) fieldvalue = "0";
			rs.executeSql("update TM_TaskInfo set principalid="+fieldvalue+"  where id="+taskId);
			//记录日志
			restr.append(this.writeLog(user,2,taskId,"principalid",fieldvalue,fn));
		}else if(fieldname.equals("fileids")){//附件
			String oldfileids = "";
			rs.executeSql("select fileids from TM_TaskInfo where id="+taskId);
			if(rs.next()){
				oldfileids = Util.null2String(rs.getString(1));
			}
			if(fieldtype.equals("del")){
				int docid = Util.getIntValue(fieldvalue); 
				String delfilename = "";
				
				DocImageManager.resetParameter();
	            DocImageManager.setDocid(docid);
	            DocImageManager.selectDocImageInfo();
	            if(DocImageManager.next()) delfilename = DocImageManager.getImagefilename();
				
				DocManager dm = new DocManager();
				dm.setId(docid);
				dm.setUserid(user.getUID());
				dm.DeleteDocInfo();
				
				int index = oldfileids.indexOf(","+fieldvalue+",");
				if(index>-1){
					oldfileids = oldfileids.substring(0,index+1)+ oldfileids.substring(index+fieldvalue.length()+2);
					rs.executeSql("update TM_TaskInfo set fileids='"+oldfileids+"'  where id="+taskId);
					//记录日志
					restr.append(this.writeLog(user,4,taskId,"fileids",delfilename,fn)+"$");
				}
			}else{
				fieldvalue = cmutil.cutString(fieldvalue,",",3);
				if(!"".equals(fieldvalue)) {
					if("".equals(oldfileids)) oldfileids = ",";
					oldfileids = oldfileids + fieldvalue + ",";
					rs.executeSql("update TM_TaskInfo set fileids='"+oldfileids+"' where id="+taskId);
					//记录日志
					restr.append(this.writeLog(user,9,taskId,"fileids",fieldvalue,fn)+"$");
				}
			}
			List fileidList = Util.TokenizerString(oldfileids,",");
			for(int i=0;i<fileidList.size();i++){
				/**
				restr.append("<div class='txtlink txtlink"+fileidList.get(i)+"' onmouseover='showdel(this)' onmouseout='hidedel(this)'>");
				restr.append("<div style='float: left;'>"+cmutil.getFileDoc((String)fileidList.get(i),taskId)+"</div>");
				restr.append("<div class='btn_del' onclick=delItem('fileids','"+fileidList.get(i)+"')></div>");
				restr.append("<div class='btn_wh'></div>");
				restr.append("</div>");
				*/
				
				DocImageManager.resetParameter();
	            DocImageManager.setDocid(Integer.parseInt((String)fileidList.get(i)));
	            DocImageManager.selectDocImageInfo();
	            DocImageManager.next();
	            String docImagefileid = DocImageManager.getImagefileid();
	            int docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
	            String docImagefilename = DocImageManager.getImagefilename();
				restr.append("<div class='txtlink txtlink"+fileidList.get(i)+"' onmouseover='showdel(this)' onmouseout='hidedel(this)'>");
				restr.append("<div style='float: left;'>");
				restr.append("<a href=javaScript:openFullWindowHaveBar('/express/task/util/ViewDoc.jsp?id=" + fileidList.get(i)+"&taskId="+taskId+"')>"+docImagefilename+"</a>");
				restr.append("&nbsp;<a href='/express/task/util/ViewDoc.jsp?id="+fileidList.get(i)+"&taskId="+taskId+"&fileid="+docImagefileid+"'>下载("+docImagefileSize/1000+"K)</a>");
				restr.append("</div>");
				restr.append("<div class='btn_del' onclick=delItem('fileids','"+fileidList.get(i)+"')></div>");
				restr.append("<div class='btn_wh'></div>");
				restr.append("</div>");
			}
			
		}else if(fieldname.equals("2")){//列表中调整日期
			String begindate = "";
			String enddate = "";
			if(fieldvalue.equals("1")){
				begindate = currentDate;
				enddate = currentDate;
			}else if(fieldvalue.equals("2")){
				begindate = TimeUtil.dateAdd(currentDate,1);
			}else if(fieldvalue.equals("3")){
				enddate = TimeUtil.dateAdd(currentDate,-1);
			}
			rs.executeSql("update TM_TaskInfo set begindate='"+begindate+"',enddate='"+enddate+"' where id="+taskId);
			//记录日志
			restr.append(this.writeLog(user,2,taskId,"date","开始:"+begindate+" 结束:"+enddate,fn));
		}else if(fieldname.equals("3")){//列表中调整紧急程度
			int level = Util.getIntValue(fieldvalue);
			if(level==5) level=0;
			rs.executeSql("update TM_TaskInfo set tasklevel="+level+" where id="+taskId);
			//记录日志
			restr.append(this.writeLog(user,2,taskId,"level",level+"",fn));
		}else{
			if(fieldtype.equals("str")){
				sql = "update TM_TaskInfo set "+fieldname+"='"+fieldvalue+"' where id="+taskId;
			}else if(fieldtype.equals("int")){
				fieldvalue = Util.null2o(fieldvalue);
				sql = "update TM_TaskInfo set "+fieldname+"="+fieldvalue+" where id="+taskId;
			}
			rs.executeSql(sql);
			
			String addvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("addvalue"),"utf-8"));
			String delvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("delvalue"),"utf-8"));
			if(!addvalue.equals("")){
				//记录日志
				restr.append(this.writeLog(user,3,taskId,fieldname,cmutil.cutString(addvalue,",",3),fn));
			}else if(!delvalue.equals("")){
				//记录日志
				restr.append(this.writeLog(user,4,taskId,fieldname,cmutil.cutString(delvalue,",",3),fn));
			}else{
				//记录日志
				restr.append(this.writeLog(user,2,taskId,fieldname,fieldvalue,fn));
			}
		}
		
	}
	//编辑状态
	if("edit_status".equals(operation)){
		String taskId = Util.fromScreen3(request.getParameter("taskId"),user.getLanguage());
		String status = Util.fromScreen3(request.getParameter("status"),user.getLanguage());
		if(!taskId.equals("") && !status.equals("")){
			if(status.equals("4")){//删除
				rs.executeSql("update TM_TaskInfo set deleted=1 where id="+taskId);
			}else{
				rs.executeSql("update TM_TaskInfo set status="+status+" where id="+taskId);
			}
			int type = 0;
			if(status.equals("1")){
				type = 5;
			}else if(status.equals("2")){
				type = 6;
			}else if(status.equals("3")){
				type = 7;
			}else{
				type = 8;
			}
			//记录日志
			restr.append(this.writeLog(user,type,taskId,"","",fn));
		}
	}
	//添加反馈
	if("add_feedback".equals(operation)){
		
		String taskId = Util.fromScreen3(request.getParameter("taskId"),user.getLanguage());
		String content = Util.convertInput2DB(URLDecoder.decode(request.getParameter("content"),"utf-8"));
		String docids = cmutil.cutString(request.getParameter("docids"),",",3);
		String wfids = cmutil.cutString(request.getParameter("wfids"),",",3);
		String crmids = cmutil.cutString(request.getParameter("crmids"),",",3);
		String projectids = cmutil.cutString(request.getParameter("projectids"),",",3);
		String meetingids = cmutil.cutString(request.getParameter("meetingids"),",",3);
		String fileids = cmutil.cutString(request.getParameter("fileids"),",",3);
		
		rs.execute("delete from task_read where taskid="+taskId); //删除阅读记录
		rs.execute("insert into task_read(userid,taskid)values("+user.getUID()+","+taskId+")");
		
		if(!fileids.equals("")) fileids = "," + fileids + ",";
		if(!taskId.equals("") && !content.equals("")){
			sql = "insert into TM_TaskFeedback (taskid,content,hrmid,docids,wfids,crmids,projectids,meetingids,fileids,createdate,createtime)"
				+" values("+taskId+",'"+content+"',"+user.getUID()+",'"+docids+"','"+wfids+"','"+crmids+"','"+projectids+"','"+meetingids+"','"+fileids+"','"+currentDate+"','"+currentTime+"')";
			rs.executeSql(sql);
			restr.append("<tr><td class='data fbdata'><div class='feedbackshow'>"
					+"<div class='feedbackinfo'>"+cmutil.getPerson(user.getUID()+"")+" "+currentDate+" "+currentTime+"</div>"
					+"<div class='feedbackrelate'>"
					+"<div style='width:100%'>"+Util.convertDB2Input(content)+"</div>");
			if(!"".equals(docids)){
				restr.append("<div>相关文档："+cmutil.getDocName(docids)+"</div>");
			}
			if(!"".equals(wfids)){
				restr.append("<div>相关流程："+cmutil.getRequestName(wfids)+"</div>");
			}
			if(!"".equals(crmids)){
				restr.append("<div>相关客户："+cmutil.getCustomer(crmids)+"</div>");
			}
			if(!"".equals(projectids)){
				restr.append("<div>相关项目："+cmutil.getProject(projectids)+"</div>");
			}
			if(!"".equals(fileids)){
				restr.append("<div>相关附件："+this.getFileDoc(fileids,taskId)+"</div>");
			}
			restr.append("</div></div></td></tr>");
			
			//记录日志
			restr.append("$"+this.writeLog(user,10,taskId,"","",fn));
		}
	}
	//获取反馈记录
	if("get_feedback".equals(operation)){
		String taskId = Util.fromScreen3(request.getParameter("taskId"),user.getLanguage());
		String lastId = Util.fromScreen3(request.getParameter("lastId"),user.getLanguage());
		String viewdate = Util.fromScreen3(request.getParameter("viewdate"),user.getLanguage());
		rs.executeSql("select id,content,hrmid,docids,wfids,crmids,projectids,meetingids,fileids,createdate,createtime from TM_TaskFeedback where taskid=" + taskId +" and id<"+lastId+" order by id desc");
		String docids = "";
		String wfids = "";
		String crmids = "";
		String projectids = "";
		String fileids = "";
		while(rs.next()){
			docids = Util.null2String(rs.getString("docids"));
			wfids = Util.null2String(rs.getString("wfids"));
			crmids = Util.null2String(rs.getString("crmids"));
			projectids = Util.null2String(rs.getString("projectids"));
			fileids = Util.null2String(rs.getString("fileids"));
			restr.append("<tr><td class='data fbdata'><div class='feedbackshow'>"
					+"<div class='feedbackinfo'>"+cmutil.getPerson(rs.getString("hrmid"))+" "+rs.getString("createdate")+" "+rs.getString("createtime"));
			if(!viewdate.equals("") && !(user.getUID()+"").equals(rs.getString("hrmid")) && TimeUtil.timeInterval(viewdate,Util.null2String(rs.getString("createdate"))+" "+Util.null2String(rs.getString("createtime")))>0){
				restr.append("<font style='color: red;margin-left: 5px;font-style: italic;font-size: 11px;cursor: pointer;' title='新反馈'>new</font>");
			}
			restr.append("</div>");
			restr.append("<div class='feedbackrelate'>");
			restr.append("	<div>"+Util.convertDB2Input(rs.getString("content"))+"</div>");
			if(!"".equals(docids)){
				restr.append("<div class='relatetitle'>相关文档："+cmutil.getDocName(docids)+"</div>");
			}
			if(!"".equals(wfids)){
				restr.append("<div class='relatetitle'>相关流程："+cmutil.getRequestName(wfids)+"</div>");
			}
			if(!"".equals(crmids)){
				restr.append("<div class='relatetitle'>相关客户："+cmutil.getCustomer(crmids)+"</div>");
			}
			if(!"".equals(projectids)){
				restr.append("<div class='relatetitle'>相关项目："+cmutil.getProject(projectids)+"</div>");
			}
			if(!"".equals(fileids)){
				restr.append("<div class='relatetitle'>相关附件："+this.getFileDoc(fileids,taskId)+"</div>");
			}
			restr.append("</div></div></td></tr>");
		}
	}
	//获取附件
	if("get_file".equals(operation)){
		String taskId = Util.fromScreen3(request.getParameter("taskId"),user.getLanguage());
		if(!taskId.equals("")){
			String fileids = "";
			rs.executeSql("select fileids from TM_TaskInfo where id="+taskId);
			if(rs.next()){
				fileids = rs.getString(1);
			}
			List fileidList = Util.TokenizerString(fileids,","); 
			for(int i=0;i<fileidList.size();i++){
				restr.append("<div class='txtlink txtlink"+fileidList.get(i)+" onmouseover='showdel(this)' onmouseout='hidedel(this)'>");
				restr.append("<div style='float: left;'>"+cmutil.getFileDoc((String)fileidList.get(i),taskId)+"</div>");
				restr.append("<div class='btn_del' onclick=delItem('fileids','"+fileidList.get(i)+"')></div>");
				restr.append("<div class='btn_wh'></div>");
				restr.append("</div>");
			}
		}
	}
	//获取最新日志记录
	if("get_toplog".equals(operation)){
		String taskId = Util.fromScreen3(request.getParameter("taskId"),user.getLanguage());
		int logcount = 0;
		String lastlogid = "";
		rs.executeSql("select count(*) from TM_TaskLog where taskid="+taskId);
		if(rs.next()){
			logcount = Util.getIntValue(rs.getString(1),0);
		}
		if(logcount>0){
			if(rs.getDBType().equals("oracle"))
				rs.executeSql("select * from (select id,type,operator,operatedate,operatetime,operatefiled,operatevalue,rownum as rm from TM_TaskLog where taskid=" + taskId +" order by id desc) where rm<6 ");
			else
				rs.executeSql("select top 5 id,type,operator,operatedate,operatetime,operatefiled,operatevalue from TM_TaskLog where taskid=" + taskId +" order by id desc");
			while(rs.next()){
				lastlogid = Util.null2String(rs.getString("id"));
				restr.append(getlogtext(rs.getString("operator"),Util.null2String(rs.getString("operatedate"))+" "+Util.null2String(rs.getString("operatetime")),rs.getInt("type"),rs.getString("operatefiled"),rs.getString("operatevalue"),fn,taskId));
			}
		}
		int lastlogcount = logcount-5;
		if(lastlogcount>0){
			restr.append("<div id='getlog' class='logitem'>");
			restr.append("	<a href='javascript:getLogRecord("+lastlogid+")' style='margin-left: 0px;line-height: 25px;font-style: italic;font-weight: bold;float: left;'>");
			restr.append("		显示剩余"+lastlogcount+"条记录");
			restr.append("	</a>");
			restr.append("</div>");
		}
		
	}
	//获取剩余日志记录
	if("get_log".equals(operation)){
		String taskId = Util.fromScreen3(request.getParameter("taskId"),user.getLanguage());
		String lastId = Util.fromScreen3(request.getParameter("lastId"),user.getLanguage());
		rs.executeSql("select id,type,operator,operatedate,operatetime,operatefiled,operatevalue from TM_TaskLog where taskid=" + taskId +" and id<"+lastId+" order by operatedate desc,operatetime desc");
		while(rs.next()){
			restr.append(getlogtext(rs.getString("operator"),Util.null2String(rs.getString("operatedate"))+" "+Util.null2String(rs.getString("operatetime")),rs.getInt("type"),rs.getString("operatefiled"),rs.getString("operatevalue"),fn,taskId));
		}
	}
	//添加查看日志
	if("add_log".equals(operation)){
		String taskId = Util.fromScreen3(request.getParameter("taskId"),user.getLanguage());
		this.writeLog(user,0,taskId,"","",fn);
	}
	//获取列表更多数据
	if("get_more".equals(operation)){
		String orderby1 = " order by viewtag asc,noreadtag desc,special desc,createdate desc,createtime desc";
		String orderby2 = " order by viewtag desc,noreadtag asc,special asc,createdate asc,createtime asc";
		String orderby3 = " order by viewtag asc,noreadtag desc,special desc,t1.createdate desc,t1.createtime desc";
		int currentpage = Util.getIntValue(request.getParameter("currentpage"),0);
		int pagesize = Util.getIntValue(request.getParameter("pagesize"),0);
		int total = Util.getIntValue(request.getParameter("total"),0);
		String querysql = Util.null2String(URLDecoder.decode(request.getParameter("querysql"),"utf-8"));//.replaceAll("t3.createdate ' ' t3.createtime","t3.createdate+' '+t3.createtime").replaceAll("t2.operatedate ' ' t2.operatetime","t2.operatedate+' '+t2.operatetime");
		String excludeids = Util.null2String(request.getParameter("excludeids"));
		if(!excludeids.equals("")){
			querysql += " and t1.id not in ("+cmutil.cutString(excludeids,",",3)+")";
		}
		int iTotal =total; 
		int iNextNum = currentpage * pagesize;
		int ipageset = pagesize;
		if(iTotal - iNextNum + pagesize < pagesize) ipageset = iTotal - iNextNum + pagesize;
		if(iTotal < pagesize) ipageset = iTotal;
		sql = "select top " + ipageset +" A.* from (select top "+ iNextNum + querysql+ orderby3 + ") A "+orderby2;
		sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderby1;
		rs.executeSql(sql);
		String statustitle = "";
		int _status = 0;
		boolean canEdit = true;
		int right = 0;
		int index = 0;
		
		int _level = 0;
		String[] leveltitle = {"未设置紧急程度","重要紧急","重要不紧急","不重要紧急","不重要不紧急"};
		String begindate = "";
		String enddate = "";
		boolean isToday = false;
		int fbcount = 0;
		boolean noreadfb = false;
		boolean isnew = false;
		int special = 0;
		while(rs.next()){
			right = cmutil.getRight(rs.getString("id"),user);
			if(right==2) canEdit = true; else canEdit = false;
			_status = rs.getInt("status");
			if(canEdit){
				if(_status==1){
					statustitle = "设置为完成";
				}else if(_status==2 || _status==3){
					statustitle = "设置为进行中";
				}
			}else{
				if(_status==1) _status=0;
			}
			_level = Util.getIntValue(rs.getString("tasklevel"),0);
			
			//判断是否今天
			begindate = Util.null2String(rs.getString("begindate"));
			enddate = Util.null2String(rs.getString("enddate"));
			if((!begindate.equals("") && !enddate.equals("") && TimeUtil.dateInterval(begindate,currentDate)>=0 && TimeUtil.dateInterval(currentDate,enddate)>=0)
					|| (!begindate.equals("") && enddate.equals("") && TimeUtil.dateInterval(begindate,currentDate)>=0)
					|| (begindate.equals("") && !enddate.equals("") && TimeUtil.dateInterval(currentDate,enddate)>=0)){
				isToday = true;
			}else{
				isToday = false;
			}
			
			fbcount = Util.getIntValue(rs.getString("fbcount"),0);
			special = Util.getIntValue(rs.getString("special"),0);
			noreadfb = (Util.getIntValue(rs.getString("noreadtag"),0)==1)?true:false;
			isnew = (Util.getIntValue(rs.getString("viewtag"),0)==0)?true:false;
	%>
			<tr class="item_tr">
				<td class='td_move<%if(canEdit){%> td_drag<%}%>' <%if(!canEdit){%>title="无权限编辑"<%}%>><div>&nbsp;</div></td>
				<td width="20px"><div id="status_<%=rs.getString("id") %>" class="<%if(canEdit){%>status_do <%}%>status status<%=_status%>" _taskid="<%=rs.getString("id") %>" _status="<%=_status%>" <%if(canEdit){%>title="<%=statustitle%>" onclick="changestatus(this)"<%}%>></div></td>
				<td width="20px"><div id="level_<%=rs.getString("id") %>" class="div_level" style="background: url('../images/level_0<%=_level %>_wev8.png') center no-repeat;" title="<%=leveltitle[_level] %>"></div></td>
				<td class='item_td'><input <%if(!canEdit){%> readonly="readonly"<%}%> onfocus="doClickItem(this)" onblur='doBlurItem(this)' class="disinput <%if(isnew){%>newinput<%}%>" type="text" name="" id="<%=rs.getString("id") %>" title="<%=Util.null2String(rs.getString("name")) %>"  value="<%=Util.null2String(rs.getString("name")) %>" _index="<%=index++ %>"/></td>
				<td class='item_count <%if(noreadfb){%>item_count_new<%}%>' _fbcount="<%=fbcount %>" <%if(noreadfb){%>title='有新反馈'<%}else if(fbcount>0){%>title='<%=fbcount %>条反馈'<%}%>><%if(fbcount>0){%>(<%=fbcount %>)<%}else{%>&nbsp;<%}%></td>
				<td><div id="today_<%=rs.getString("id") %>" <%if(isToday){%>title='今天的任务'<%}%> ><%if(isToday){%>今天<%}else{%>&nbsp;<%}%></div></td>
				<td class='item_hrm' title='责任人'><%=this.getHrmLink(rs.getString("principalid")) %></td>
				<td class='item_att item_att<%=special %>' title="<%if(special==0){%>标记关注<%}else{%>取消关注<%}%>" _special="<%=special %>">&nbsp;</td>
			</tr>
	<%
		} 
	}
	//标记或取消关注
	if("set_special".equals(operation)){
		String userid = user.getUID()+"";
		int special = Util.getIntValue(request.getParameter("special"),0);
		String taskId = Util.null2String(request.getParameter("taskId"));
		String taskType = Util.null2String(request.getParameter("taskType"));
		String creater = Util.null2String(request.getParameter("creater"));
		String remindType = Util.null2String(request.getParameter("remindType"));
		rs.executeSql("delete from Task_attention where taskid="+taskId+" and userid="+user.getUID() +"and tasktype = "+taskType);
		if(special==0){
		    rs.executeSql("select * from Task_attention where taskid="+ taskId +" and userid="+user.getUID() +"and tasktype = "+taskType);
		    if(rs.getCounts() == 0){
				rs.executeSql("insert into Task_attention (userid,tasktype,taskid) values("+userid+","+taskType+","+taskId+")");
				
				//发送提醒
				if(!userid.equals(creater)){
					//System.out.println("==============userid"+userid + "--"+ creater);
					rs.executeSql("select * from Task_msg where( senderid ="+userid +"and receiverid="+creater +" and tasktype="+taskType+" and taskid="+taskId+")");
			    	if(rs.getCounts() == 0){
				    	sql  = "insert into Task_msg (senderid,receiverid,tasktype,taskid,createdate,type) values ("+userid+"," + creater+ ","+ taskType +" ,"+ taskId+ " ,'"+currentDate+"',"+remindType+")";
				    	rs.executeSql(sql);
			    	}
				}
		    }
		}
	}
	
	//检查是否有新任务
	if("check_new".equals(operation)){
%>
		<script type="text/javascript">
			newMap = new Map();
<%
		String userid = user.getUID()+"";
		sql = 
			"select count(t1.id) as amount from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null)"
			+" and t1.creater = "+userid
			+" and (not exists (select 1 from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+")"
			+"or (select top 1 t3.createdate+' '+t3.createtime from TM_TaskFeedback t3 where t3.taskid=t1.id and t3.hrmid<>"+userid+" order by t3.createdate desc,t3.createtime desc)"
			+">(select top 1 t2.operatedate+' '+t2.operatetime from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+" order by t2.operatedate desc,t2.operatetime desc))"
			+" union all"
			+" select count(t1.id) as amount from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null)"
			+" and t1.principalid = "+userid
			+" and (not exists (select 1 from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+")"
			+"or (select top 1 t3.createdate+' '+t3.createtime from TM_TaskFeedback t3 where t3.taskid=t1.id and t3.hrmid<>"+userid+" order by t3.createdate desc,t3.createtime desc)"
			+">(select top 1 t2.operatedate+' '+t2.operatetime from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+" order by t2.operatedate desc,t2.operatetime desc))"
			+" union all"
			+" select count(t1.id) as amount from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null)"
			+" and exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+")"
			+" and (not exists (select 1 from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+")"
			+"or (select top 1 t3.createdate+' '+t3.createtime from TM_TaskFeedback t3 where t3.taskid=t1.id and t3.hrmid<>"+userid+" order by t3.createdate desc,t3.createtime desc)"
			+">(select top 1 t2.operatedate+' '+t2.operatetime from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+" order by t2.operatedate desc,t2.operatetime desc))"
			+" union all"
			+" select count(t1.id) as amount from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null)"
			+" and exists (select 1 from TM_TaskSpecial special where special.taskid=t1.id and special.userid="+userid+")"
			+" and (not exists (select 1 from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+")"
			+"or (select top 1 t3.createdate+' '+t3.createtime from TM_TaskFeedback t3 where t3.taskid=t1.id and t3.hrmid<>"+userid+" order by t3.createdate desc,t3.createtime desc)"
			+">(select top 1 t2.operatedate+' '+t2.operatetime from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+" order by t2.operatedate desc,t2.operatetime desc))"
			+" union all"
			+" select count(t1.id) as amount from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null)"
			+" and exists (select 1 from TM_TaskSharer ts where ts.taskid=t1.id and ts.sharerid="+userid+")"
			+" and (not exists (select 1 from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+")"
			+"or (select top 1 t3.createdate+' '+t3.createtime from TM_TaskFeedback t3 where t3.taskid=t1.id and t3.hrmid<>"+userid+" order by t3.createdate desc,t3.createtime desc)"
			+">(select top 1 t2.operatedate+' '+t2.operatetime from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+" order by t2.operatedate desc,t2.operatetime desc))";
		rs.executeSql(sql);
		int index = 2;
		while(rs.next()){
%>
			newMap.put("mine<%=index%>","<%=rs.getInt(1)%>");
<%		
			index++;
		}
%>
		</script>
<%			
	}
	
	out.print(restr.toString());
	out.close();
%>
<%!
	/**
	* type  1:新建  2:编辑内容  3:新增内容  4:删除内容 5:进行 6:完成  7:撤销  8:删除
	*/
	private String writeLog(User user,int type,String taskid,String field,String value,Map fn){
		RecordSet rs = new RecordSet();
		String currentdate = TimeUtil.getCurrentDateString();
		String currenttime = TimeUtil.getOnlyCurrentTimeString();
		rs.executeSql("insert into TM_TaskLog (taskid,type,operator,operatedate,operatetime,operatefiled,operatevalue)"
				+" values("+taskid+","+type+","+user.getUID()+",'"+currentdate+"','"+currenttime+"','"+field+"','"+value+"')");
		return getlogtext(user.getUID()+"",currentdate+" "+currenttime,type,field,value,fn,taskid);
	}
	private String getlogtext(String userid,String datetime,int type,String field,String value,Map fn,String taskId){
		String logtxt = "<div class='logitem'>"+getLink("hrmid",userid+"",taskId)+"&nbsp;&nbsp;<font class='datetxt'>"+datetime+"</font>&nbsp;&nbsp;";
		String valtxt = getLink(field,value,taskId);
		switch(type){
			case 0:logtxt+="查看任务";break;
			case 1:logtxt+="新建任务";break;
			case 2:logtxt+="更新"+fn.get(field)+"为&nbsp;&nbsp;"+valtxt;break;
			case 3:logtxt+="添加"+fn.get(field)+"&nbsp;&nbsp;"+valtxt;break;
			case 4:logtxt+="删除"+fn.get(field)+"&nbsp;&nbsp;"+valtxt;break;
			case 5:logtxt+="设置为进行中";break;
			case 6:logtxt+="设置为完成";break;
			case 7:logtxt+="设置为撤销";break;
			case 8:logtxt+="删除任务";break;
			case 9:logtxt+="上传"+fn.get(field)+"&nbsp;&nbsp;"+valtxt;break;
			case 10:logtxt+="反馈任务";break;
		}
		logtxt += "</div>";
		return logtxt;
	}
	private String getLink(String field,String value,String taskId){
		CommonTransUtil cmutil = new CommonTransUtil();
		if("principalid".equals(field) || "partnerid".equals(field) || "sharerid".equals(field) || "hrmid".equals(field)){
			return cmutil.getHrm(value);
		}else if("docids".equals(field)){
			return cmutil.getDocName(value);
		}else if("wfids".equals(field)){
			return cmutil.getRequestName(value);
		}else if("crmids".equals(field)){
			return cmutil.getCustomer(value);
		}else if("projectids".equals(field)){
			return cmutil.getProject(value);
		}else if("taskids".equals(field)){
			return cmutil.getTaskName(value);
		}else if("fileids".equals(field)){
			return value;
		}else if("level".equals(field)){
			if("1".equals(value)) return "重要紧急";
			if("2".equals(value)) return "重要";
			if("3".equals(value)) return "紧急";
			if("4".equals(value)) return "不重要不紧急";
			return "";
		}else{
			return value;
		}
	}
	public String getFileDoc(String ids,String taskId) throws Exception{
		String returnstr = "";
		String docid = "";
		String docImagefileid = "";
		int docImagefileSize = 0;
		String docImagefilename = "";
		DocImageManager DocImageManager = null;
		if(ids != null && !"".equals(ids)){
			List idList = Util.TokenizerString(ids, ",");
			for (int i = 0; i < idList.size(); i++) {
				docid = Util.null2String((String)idList.get(i));
				if(!docid.equals("")){
					DocImageManager = new DocImageManager();
					DocImageManager.resetParameter();
		            DocImageManager.setDocid(Integer.parseInt((String)idList.get(i)));
		            DocImageManager.selectDocImageInfo();
		            DocImageManager.next();
		            docImagefileid = DocImageManager.getImagefileid();
		            docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
		            docImagefilename = DocImageManager.getImagefilename();
		            returnstr += "<a href=javaScript:openFullWindowHaveBar('/express/task/util/ViewDoc.jsp?id="+docid+"&taskId="+taskId+"') >"+docImagefilename+"</a>";
		            returnstr += "&nbsp;<a href='/express/task/util/ViewDoc.jsp?id="+docid+"&taskId="+taskId+"&fileid="+docImagefileid+"'>下载("+docImagefileSize/1000+"K)</a>&nbsp;&nbsp;";
				}
			}
		}
		return returnstr;
	}
	private String getHrmLink(String id) throws Exception{
		String returnstr = "";
		if(!"".equals(id) && !"0".equals(id)){
			ResourceComInfo rc = new ResourceComInfo();
			returnstr = "<a href=javascript:searchList("+id+",'"+rc.getLastname(id)+"')>"+rc.getLastname(id)+"</a>";
		}else{
			returnstr = "&nbsp;";
		}
		return returnstr;
	}
%>
