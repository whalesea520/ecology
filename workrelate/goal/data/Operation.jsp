<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@page import="java.net.URLDecoder"%>
<%@ page import="weaver.docs.docs.*"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.conn.*"%>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="weaver.workrelate.util.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<%
	String operation = Util.fromScreen3(request.getParameter("operation"), user.getLanguage());
	String currentDate = TimeUtil.getCurrentDateString();
	String currentTime = TimeUtil.getOnlyCurrentTimeString();
	String yesterday = TimeUtil.dateAdd(currentDate,-1);
	String tomorrow = TimeUtil.dateAdd(currentDate,1);
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
	fn.put("goalids","相关目标");
	fn.put("docids","相关文档");
	fn.put("wfids","相关流程");
	fn.put("crmids","相关客户");
	fn.put("projectids","相关项目");
	fn.put("fileids","相关附件");
	fn.put("date","任务日期");
	fn.put("parentid","上级任务");
	fn.put("cate","类型");
	fn.put("target","目标值");
	fn.put("result","完成值");
	fn.put("rate","完成率");
	fn.put("period","周期");
	fn.put("showorder","排序");
	
	
	//新建
	if("add".equals(operation)){
		String name = Util.fromScreen3(URLDecoder.decode(Util.null2String(request.getParameter("taskName")),"utf-8"),user.getLanguage());
		String sorttype = Util.fromScreen3(request.getParameter("sorttype"), user.getLanguage());
		String datetype = Util.fromScreen3(request.getParameter("datetype"), user.getLanguage());
		//System.out.println("sorttype:"+sorttype);
		//System.out.println("datetype:"+datetype);
		String principalid = Util.fromScreen3(request.getParameter("principalid"), user.getLanguage());
		String parentid = Util.fromScreen3(request.getParameter("parentid"), user.getLanguage());
		if(principalid.equals("") || principalid.equals("0")){
			principalid = user.getUID()+"";
		}
		//判断是否有新建下级目标的权限
		if(!parentid.equals("")){
			if(cmutil.getGoalRight(parentid,user)<2){
				rs.executeSql("select id from GM_GoalPartner tp where tp.goalid="+parentid+" and tp.partnerid="+user.getUID());
				if(!rs.next()) return;
			}
		}
		String begindate = Util.fromScreen3(request.getParameter("begindate"), user.getLanguage());
		String enddate = Util.fromScreen3(request.getParameter("enddate"), user.getLanguage());
		String cate = Util.fromScreen3(URLDecoder.decode(Util.null2String(request.getParameter("cate")),"utf-8"),user.getLanguage());
		int period = Util.getIntValue(request.getParameter("period"),3);
		int periody = Util.getIntValue(request.getParameter("periody"),Integer.parseInt(TimeUtil.getCurrentDateString().substring(0,4)));
		int periodm = Util.getIntValue(request.getParameter("periodm"),Integer.parseInt(TimeUtil.getCurrentDateString().substring(5,7)));
		int periods = Util.getIntValue(request.getParameter("periods"),Integer.parseInt(TimeUtil.getCurrentSeason()));
		if(enddate.equals("")){
			if(period==1){
				//enddate = TimeUtil.getYearMonthEndDay(year,month);
			}else if(period==2){
				if(periods==1) periodm = 3;
				if(periods==2) periodm = 6;
				if(periods==3) periodm = 9;
				if(periods==4) periodm = 12;
			}else if(period==3){
				periodm = 12;
			}else if(period==4){
				periody = periody+2;
				periodm = 12;
			}else if(period==5){
				periody = periody+4;
				periodm = 12;
			}
			enddate = TimeUtil.getYearMonthEndDay(periody,periodm);
		}
		int level = 0;
		if(sorttype.equals("2")){
			if(datetype.equals("1")){
				enddate = yesterday;
			}else if(datetype.equals("2")){
				enddate = currentDate;
			}else if(datetype.equals("3")){
				enddate = tomorrow;
			}else if(datetype.equals("4")){
				enddate = TimeUtil.dateAdd(tomorrow,1);
			}else if(datetype.equals("5")){
				enddate = "";
			}
		}
		if(sorttype.equals("3") && cate.equals("")){
			if(datetype.equals("1")){
				cate = "财务效益类";
			}else if(datetype.equals("2")){
				cate = "客户运营类";
			}else if(datetype.equals("3")){
				cate = "内部经营类";
			}else if(datetype.equals("4")){
				cate = "学习成长类";
			}else if(datetype.equals("5")){
				cate = "备忘类";
			}
		}
		if(cate.equals("")) cate = "备忘类";
		
		if(level==5) level=0;
		sql = "insert into GM_GoalInfo (name,status,creater,createdate,createtime,begindate,enddate,cate,principalid,parentid,period) "
			+"values('"+name+"',1,"+user.getUID()+",'"+currentDate+"','"+currentTime+"','"+begindate+"','"+enddate+"','"+cate+"',"+principalid+",'"+parentid+"','"+period+"')";
		boolean res = rs.executeSql(sql);
		if(res){
			String taskId = "";
			rs.executeSql("select max(id) from GM_GoalInfo");
			if(rs.next()) taskId = rs.getString(1);
			restr.append(taskId+"_"+this.getHrmLink(principalid));
			
			//添加新建反馈
			String content = "新建";
			sql = "insert into GM_GoalFeedback (goalid,content,hrmid,docids,wfids,crmids,projectids,meetingids,fileids,createdate,createtime)"
				+" values("+taskId+",'"+content+"',"+user.getUID()+",'','','','','','','"+currentDate+"','"+currentTime+"')";
			rs.executeSql(sql);
			//记录日志
			this.writeLog(user,1,taskId,"","",fn);
			//判断下级任务则需要默认加入查看日志并更新所有上级任务的参与人
			if(!parentid.equals("")){
				this.writeLog(user,0,taskId,"","",fn);
				this.updateSupPartner(taskId);
			}
			//增加个人Todolist标记
			if(sorttype.equals("5")){
				String tododate = "";
				if(datetype.equals("1")){
					tododate = currentDate;
				}else if(datetype.equals("2")){
					tododate = tomorrow;
				}else if(datetype.equals("3")){
					tododate = TimeUtil.dateAdd(currentDate,7);
				}else if(datetype.equals("5")){
					tododate = "1";
				}
				if(!tododate.equals("")){
					sql = "insert into GM_GoalTodo (goalid,userid,tododate) values('"+taskId+"','"+principalid+"','"+tododate+"')";
					rs.executeSql(sql);
				}
			}
			StaticObj staticobj = StaticObj.getInstance();
			staticobj.removeObject("GM_GOALSHOW");
			
			//通过计划报告创建任务
			/**
			String plandetailid = Util.fromScreen3(request.getParameter("plandetailid"), user.getLanguage());
			if(!plandetailid.equals("")){
				rs.executeSql("select taskids from PR_PlanReportDetail where id="+plandetailid);
				if(rs.next()){
					String taskids = Util.null2String(rs.getString(1));
					if(taskids.equals("")) taskids = "," + taskId + ",";
					else taskids += taskId + ",";
					
					rs.executeSql("update PR_PlanReportDetail set taskids='"+taskids+"' where id="+plandetailid);
				}
			}
			*/
		}
	}
	//编辑名称
	if("edit_name".equals(operation)){
		String taskId = Util.fromScreen3(request.getParameter("taskId"),user.getLanguage());
		if(cmutil.getGoalRight(taskId,user)<2) return;
		String name = Util.fromScreen3(URLDecoder.decode(request.getParameter("taskName"),"utf-8"),user.getLanguage());
		sql = "update GM_GoalInfo set name='"+name+"' where id="+taskId;
		rs.executeSql(sql);
		//记录日志
		restr.append(this.writeLog(user,2,taskId,"name",name,fn));
		StaticObj staticobj = StaticObj.getInstance();
		staticobj.removeObject("GM_GOALSHOW");
	}
	//编辑字段
	if("edit_field".equals(operation)){
		String taskId = Util.fromScreen3(request.getParameter("taskId"),user.getLanguage());
		String fieldname = Util.fromScreen3(request.getParameter("fieldname"),user.getLanguage());
		if(cmutil.getGoalRight(taskId,user)<2 && !fieldname.equals("5")) return;
		String fieldvalue = Util.convertInput2DB(URLDecoder.decode(Util.null2String(request.getParameter("fieldvalue")),"utf-8"));
		String fieldtype = Util.fromScreen3(request.getParameter("fieldtype"),user.getLanguage());
		//System.out.println("fieldvalue:"+fieldvalue);
		if(fieldname.endsWith("ids") && fieldvalue.equals(",")){
			fieldvalue = "";
		}
		
		
		if(fieldname.equals("partnerid")){//参与人
			if(fieldtype.equals("del")){//删除
				rs.executeSql("delete from GM_GoalPartner where goalid="+taskId+" and partnerid="+fieldvalue);
				//记录日志
				restr.append(this.writeLog(user,4,taskId,"partnerid",fieldvalue,fn));
			}else{//添加
				List partneridList = Util.TokenizerString(fieldvalue,",");
				String partnerid = "";
				for(int i=0;i<partneridList.size();i++){
					partnerid = Util.null2String((String)partneridList.get(i));
					if(!partnerid.equals("")){
						rs.executeSql("insert into GM_GoalPartner (goalid,partnerid) values("+taskId+","+partnerid+")");
					}
				}
				//记录日志
				restr.append(this.writeLog(user,3,taskId,"partnerid",fieldvalue,fn));
				//调整上级任务的参与人
				this.updateSupPartner(taskId);
			}
		}else if(fieldname.equals("sharerid")){//分享人
			if(fieldtype.equals("del")){//删除
				rs.executeSql("delete from GM_GoalSharer where goalid="+taskId+" and sharerid="+fieldvalue);
				//记录日志
				restr.append(this.writeLog(user,4,taskId,"sharerid",fieldvalue,fn));
			}else{//添加
				List shareridList = Util.TokenizerString(fieldvalue,",");
				String sharerid = "";
				for(int i=0;i<shareridList.size();i++){
					sharerid = Util.null2String((String)shareridList.get(i));
					if(!sharerid.equals("")){
						rs.executeSql("insert into GM_GoalSharer (goalid,sharerid) values("+taskId+","+sharerid+")");
					}
					
				}
				//记录日志
				restr.append(this.writeLog(user,3,taskId,"sharerid",fieldvalue,fn));
			}
		}else if(fieldname.equals("principalid")){
			if(fieldtype.equals("del")) fieldvalue = "0";
			rs.executeSql("update GM_GoalInfo set principalid="+fieldvalue+"  where id="+taskId);
			//记录日志
			restr.append(this.writeLog(user,2,taskId,"principalid",fieldvalue,fn));
			//调整上级任务的参与人
			this.updateSupPartner(taskId);
		}else if(fieldname.equals("parentid")){
			if(fieldtype.equals("del")) fieldvalue = "0";
			rs.executeSql("update GM_GoalInfo set parentid="+fieldvalue+"  where id="+taskId);
			//记录日志
			restr.append(this.writeLog(user,2,taskId,"parentid",fieldvalue,fn));
			//调整上级任务的参与人
			this.updateSupPartner(taskId);
		}else if(fieldname.equals("fileids")){//附件
			String oldfileids = "";
			rs.executeSql("select fileids from GM_GoalInfo where id="+taskId);
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
					if(oldfileids.equals(",")) oldfileids="";
					rs.executeSql("update GM_GoalInfo set fileids='"+oldfileids+"'  where id="+taskId);
					//记录日志
					restr.append(this.writeLog(user,4,taskId,"fileids",delfilename,fn)+"$");
				}
			}else{
				fieldvalue = cmutil.cutString(fieldvalue,",",3);
				if(!"".equals(fieldvalue)) {
					if("".equals(oldfileids)) oldfileids = ",";
					oldfileids = oldfileids + fieldvalue + ",";
					rs.executeSql("update GM_GoalInfo set fileids='"+oldfileids+"' where id="+taskId);
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
				restr.append("<a href=javaScript:openFullWindowHaveBar('/workrelate/task/util/ViewDoc.jsp?id=" + fileidList.get(i)+"&taskId="+taskId+"')>"+docImagefilename+"</a>");
				restr.append("&nbsp;<a href='/workrelate/task/util/ViewDoc.jsp?id="+fileidList.get(i)+"&taskId="+taskId+"&fileid="+docImagefileid+"'>下载("+docImagefileSize/1000+"K)</a>");
				restr.append("&nbsp;"+weaver.workrelate.util.TransUtil.getReviewLink(docImagefilename, docImagefileid, user.getLanguage(), user,1,(String)fileidList.get(i),taskId,""));
				restr.append("</div>");
				restr.append("<div class='btn_del' onclick=delItem('fileids','"+fileidList.get(i)+"')></div>");
				restr.append("<div class='btn_wh'></div>");
				restr.append("</div>");
			}
			
		}else if(fieldname.equals("2")){//列表中调整日期
			String enddate = "";
			if(fieldvalue.equals("1")){
				enddate = yesterday;
			}else if(fieldvalue.equals("2")){
				enddate = currentDate;
			}else if(fieldvalue.equals("3")){
				enddate = tomorrow;
			}else if(fieldvalue.equals("4")){
				enddate = TimeUtil.dateAdd(currentDate,7);
			}else if(fieldvalue.equals("5")){
				enddate = "";
			}
			
			rs.executeSql("update GM_GoalInfo set enddate='"+enddate+"' where id="+taskId);
			//记录日志
			restr.append(this.writeLog(user,2,taskId,"date","结束:"+enddate,fn));
		}else if(fieldname.equals("3")){//调整类型
			String catename = "";
			int cate = Util.getIntValue(fieldvalue);
			if(cate==6) cate=0;
			if(cate==1){
				catename = "财务效益类";
			}else if(cate==2){
				catename = "客户运营类";
			}else if(cate==3){
				catename = "内部经营类";
			}else if(cate==4){
				catename = "学习成长类";
			}else if(cate==5){
				catename = "备忘类";
			}
			rs.executeSql("update GM_GoalInfo set cate='"+catename+"' where id="+taskId);
			//记录日志
			restr.append(this.writeLog(user,2,taskId,"cate",catename,fn));
		}else if(fieldname.equals("5")){//列表中调整标记
			String tododate = "";
			if(fieldvalue.equals("1")){
				tododate = currentDate;
			}else if(fieldvalue.equals("2")){
				tododate = tomorrow;
			}else if(fieldvalue.equals("3")){
				tododate = TimeUtil.dateAdd(currentDate,7);
			}else if(fieldvalue.equals("5")){
				tododate = "1";
			}
			rs.executeSql("delete from GM_GoalTodo where goalid="+taskId+" and userid="+user.getUID());
			if(!tododate.equals("")){
				sql = "insert into GM_GoalTodo (goalid,userid,tododate) values('"+taskId+"','"+user.getUID()+"','"+tododate+"')";
				rs.executeSql(sql);
			}
			//记录日志
			restr.append(this.writeLog(user,11,taskId,"todo",fieldvalue,fn));
		}else{
			if(fieldname.equals("target") || fieldname.equals("result")){
				fieldtype = "int";
			}
			if(fieldtype.equals("str")){
				sql = "update GM_GoalInfo set "+fieldname+"='"+fieldvalue+"' where id="+taskId;
			}else if(fieldtype.equals("int")){
				fieldvalue = Util.null2o(fieldvalue);
				sql = "update GM_GoalInfo set "+fieldname+"="+fieldvalue+" where id="+taskId;
			}
			//System.out.println(sql);
			rs.executeSql(sql);
			
			String addvalue = Util.convertInput2DB(URLDecoder.decode(Util.null2String(request.getParameter("addvalue")),"utf-8"));
			String delvalue = Util.convertInput2DB(URLDecoder.decode(Util.null2String(request.getParameter("delvalue")),"utf-8"));
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
		StaticObj staticobj = StaticObj.getInstance();
		staticobj.removeObject("GM_GOALSHOW");
	}
	//编辑状态
	if("edit_status".equals(operation)){
		String taskId = Util.fromScreen3(request.getParameter("taskId"),user.getLanguage());
		if(cmutil.getGoalRight(taskId,user)<2) return;
		String status = Util.fromScreen3(request.getParameter("status"),user.getLanguage());
		if(!taskId.equals("") && !status.equals("")){
			if(status.equals("4")){//删除
				rs.executeSql("update GM_GoalInfo set deleted=1 where id="+taskId);
				rs.executeSql("update GM_GoalInfo set parentid = null where parentid="+taskId);
				
				StaticObj staticobj = StaticObj.getInstance();
				staticobj.removeObject("GM_GOALSHOW");
			}else{
				rs.executeSql("update GM_GoalInfo set status="+status+" where id="+taskId);
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
			
			//更改为完成时加入反馈记录
			if(status.equals("2")){
				//添加完成反馈
				String content = "已完成！";
				sql = "insert into GM_GoalFeedback (goalid,content,hrmid,docids,wfids,crmids,projectids,meetingids,fileids,createdate,createtime)"
					+" values("+taskId+",'"+content+"',"+user.getUID()+",'','','','','','','"+currentDate+"','"+currentTime+"')";
				rs.executeSql(sql);
				restr.append("$<tr><td class='data fbdata'><div class='feedbackshow'>"
						+"<div class='feedbackinfo'>"+cmutil.getPerson(user.getUID()+"")+" "+currentDate+" "+currentTime+"</div>"
						+"<div class='feedbackrelate'>"
						+"<div style='width:100%'>"+Util.convertDB2Input(content)+"</div>");
				restr.append("</div></div></td></tr>");
			}
		}
	}
	//添加反馈
	if("add_feedback".equals(operation)){
		String taskId = Util.fromScreen3(request.getParameter("taskId"),user.getLanguage());
		if(cmutil.getGoalRight(taskId,user)<1) return;
		String content = Util.convertInput2DB(URLDecoder.decode(request.getParameter("content"),"utf-8"));
		String docids = cmutil.cutString(request.getParameter("docids"),",",3);
		String wfids = cmutil.cutString(request.getParameter("wfids"),",",3);
		String crmids = cmutil.cutString(request.getParameter("crmids"),",",3);
		String projectids = cmutil.cutString(request.getParameter("projectids"),",",3);
		String meetingids = cmutil.cutString(request.getParameter("meetingids"),",",3);
		String fileids = cmutil.cutString(request.getParameter("fileids"),",",3);
		if(!fileids.equals("")) fileids = "," + fileids + ",";
		if(!taskId.equals("") && !content.equals("")){
			sql = "insert into GM_GoalFeedback (goalid,content,hrmid,docids,wfids,crmids,projectids,meetingids,fileids,createdate,createtime)"
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
				restr.append("<div>相关附件："+this.getFileDoc(fileids,taskId,user)+"</div>");
			}
			restr.append("</div></div></td></tr>");
			
			//记录日志
			restr.append("$"+this.writeLog(user,10,taskId,"","",fn));
		}
	}
	//获取反馈记录
	if("get_feedback".equals(operation)){
		String taskId = Util.fromScreen3(request.getParameter("taskId"),user.getLanguage());
		if(cmutil.getGoalRight(taskId,user)<1) return;
		String lastId = Util.fromScreen3(request.getParameter("lastId"),user.getLanguage());
		String viewdate = Util.fromScreen3(request.getParameter("viewdate"),user.getLanguage());
		rs.executeSql("select id,content,hrmid,docids,wfids,crmids,projectids,meetingids,fileids,createdate,createtime from GM_GoalFeedback where goalid=" + taskId +" and id<"+lastId+" order by createdate desc,createtime desc");
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
				restr.append("<div class='relatetitle'>相关附件："+this.getFileDoc(fileids,taskId,user)+"</div>");
			}
			restr.append("</div></div></td></tr>");
		}
	}
	//获取附件
	if("get_file".equals(operation)){
		String taskId = Util.fromScreen3(request.getParameter("taskId"),user.getLanguage());
		if(!taskId.equals("")){
			String fileids = "";
			rs.executeSql("select fileids from GM_GoalInfo where id="+taskId);
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
		if(cmutil.getGoalRight(taskId,user)<1) return;
		int logcount = 0;
		String lastlogid = "";
		rs.executeSql("select count(*) from GM_GoalLog where goalid="+taskId);
		if(rs.next()){
			logcount = Util.getIntValue(rs.getString(1),0);
		}
		if(logcount>0){
			String ssql = "";
			if("oracle".equals(rs.getDBType())){
				ssql = "select t.* from (select id,type,operator,operatedate,operatetime,operatefiled,operatevalue from GM_GoalLog where goalid=" + taskId +" order by id desc) t where rownum<6";
			}else{
				ssql = "select top 5 id,type,operator,operatedate,operatetime,operatefiled,operatevalue from GM_GoalLog where goalid=" + taskId +" order by id desc";
			}
			rs.executeSql(ssql);
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
		rs.executeSql("select id,type,operator,operatedate,operatetime,operatefiled,operatevalue from GM_GoalLog where goalid=" + taskId +" and id<"+lastId+" order by operatedate desc,operatetime desc");
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
		String userid = user.getUID()+"";
		String currentdate = TimeUtil.getCurrentDateString();
		String orderby1 = " order by lastoperatedate desc";
		String orderby2 = " order by lastoperatedate asc";
		String orderby3 = " order by lastoperatedate desc";
		int currentpage = Util.getIntValue(request.getParameter("currentpage"),0);
		int pagesize = Util.getIntValue(request.getParameter("pagesize"),0);
		int total = Util.getIntValue(request.getParameter("total"),0);
		//String querysql = Util.null2String(URLDecoder.decode(request.getParameter("querysql"),"utf-8"));//.replaceAll("t3.createdate ' ' t3.createtime","t3.createdate+' '+t3.createtime").replaceAll("t2.operatedate ' ' t2.operatetime","t2.operatedate+' '+t2.operatetime");
		int _index = Util.getIntValue(request.getParameter("index"),0);
		String querysql = (String)request.getSession().getAttribute("TM_LIST_SQL_"+_index);
		String excludeids = Util.null2String(request.getParameter("excludeids"));
		if(!excludeids.equals("")){
			querysql += " and t1.id not in ("+cmutil.cutString(excludeids,",",3)+")";
		}
		int sorttype = Util.getIntValue(request.getParameter("sorttype"),2);//分类排序类型
		int status = Util.getIntValue(request.getParameter("status"),1);
		int iTotal =total; 
		int iNextNum = currentpage * pagesize;
		int ipageset = pagesize;
		if(iTotal - iNextNum + pagesize < pagesize) ipageset = iTotal - iNextNum + pagesize;
		if(iTotal < pagesize) ipageset = iTotal;
		//sql = "select top " + ipageset +" A.* from (select top "+ iNextNum + querysql+ orderby3 + ") A "+orderby2;
		//sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderby1;
		int dcount = 0;
		if("oracle".equals(rs.getDBType())){
			sql = "select " + querysql+ orderby3;
			sql = "select A.*,rownum rn from (" + sql + ") A where rownum <= " + (iNextNum-dcount);
			sql = "select B.* from (" + sql + ") B where rn > " + (iNextNum -dcount - pagesize);
		}else{
			sql = "select top " + ipageset +" A.* from (select top "+ (iNextNum-dcount) + querysql+ orderby3 + ") A "+orderby2;
			sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderby1;
		}
		
		//System.out.println(total+"---"+sql);
		rs.executeSql(sql);
		String statustitle = "";
		int _status = 0;
		boolean canEdit = true;
		boolean canDrag = true;
		int right = 0;
		int index = 0;
		
		String enddate = "";
		int fbcount = 0;
		boolean noreadfb = false;
		boolean isnew = false;
		int special = 0;
		String lastviewdate = "";
		String lastfbdate = "";
		String creater = "";
		
		String tododate = "";
		int todotype = 4;
		String todoname = "";
		String taskid = "";
		while(rs.next()){
			taskid = Util.null2String(rs.getString("id"));
			right = cmutil.getGoalRight(taskid,user);
			if(right==2) canEdit = true; else canEdit = false;
			if(sorttype==5){
				canDrag = true;
			}else if(sorttype==1 || sorttype==4){
				canDrag = false;
			}else{
				canDrag = canEdit;
			}
			_status = rs.getInt("status");
			if(canEdit){
				if(_status==1){
					statustitle = "标记完成";
				}else if(_status==2 || _status==3){
					statustitle = "标记进行";
				}
			}else{
				if(_status==1) _status=0;
			}
			//_level = Util.getIntValue(rs.getString("level"),0);
			enddate = Util.null2String(rs.getString("enddate"));
			fbcount = Util.getIntValue(rs.getString("fbcount"),0);
			special = Util.getIntValue(rs.getString("special"),0);
			//isnew = (Util.getIntValue(rs.getString("viewtag"),0)==0)?true:false;
			//noreadfb = (Util.getIntValue(rs.getString("noreadtag"),0)==1)?true:false;
			lastviewdate = Util.null2String(rs.getString("lastviewdate"));//最后查看时间
			lastfbdate = Util.null2String(rs.getString("lastfbdate"));//最后反馈时间
			creater = Util.null2String(rs.getString("creater"));
			if(creater.equals(userid)){
				isnew = false;
			}else{
				if(lastviewdate.equals("")){
					isnew = true;
				}else{
					isnew = false;
				}
			}
			if(!lastfbdate.equals("")){
				if(lastviewdate.equals("") || TimeUtil.dateInterval(lastviewdate,lastfbdate)>0){
					noreadfb = true;
				}else{
					noreadfb = false;
				}
			}else{
				noreadfb = false;
			}
			
			
			tododate = Util.null2String(rs.getString("tododate"));
			todotype = 4;
			todoname = "标记todo";
			if(!tododate.equals("")){
				if(tododate.equals("1")){
					todotype = 5;
					todoname = "备忘";
				}else if(TimeUtil.dateInterval(tododate,currentdate)>=0){
					todotype = 1;
					todoname = "今天";
				}else if(tododate.equals(TimeUtil.dateAdd(currentdate,1))){
					todotype = 2;
					todoname = "明天";
				}else{
					todotype = 3;
					todoname = "即将";
				}
			}	
	%>
			<tr id="item_tr_<%=taskid%>" class="item_tr" _taskid="<%=taskid%>">
				<td class='td_move<%if(canDrag){%> td_drag<%}%>' <%if(!canEdit){%>title="无权限编辑"<%}%>><div>&nbsp;</div></td>
				<td width="20px">
					<div id="status_<%=taskid %>" class="status status<%=_status%>">&nbsp;</div>
					<div id="todo_<%=taskid %>" class="<%if(_status==1 || _status==0){ %>div_todo<%} %>" style="" onclick="showTodo2(this)"
						title="<%=todoname %>" _val="<%=todotype%>" _taskid="<%=taskid %>"></div>
				</td>
				<td class='item_td'>
					<input type="text" <%if(!canEdit){%> readonly="readonly"<%}%> onfocus="doClickItem(this)" onblur='doBlurItem(this)' class="disinput <%if(isnew){%>newinput<%}%>" 
						id="<%=taskid %>" name="" <%if(sorttype==4){ %>_pid="-1"<%} %> title="<%=Util.null2String(rs.getString("name")) %>" 
						value="<%=Util.null2String(rs.getString("name")) %>" _index="<%=index++ %>"/>
					<div id="operate_<%=taskid %>" class="operatediv" _taskid="<%=taskid%>">
				<div class="operatebtn item_fb" onclick="quickfb(this)">反馈</div>
				<div class="operatebtn item_att" _special="<%=special %>" title="<%if(special==0){%>添加关注<%}else{%>取消关注<%}%>"><%if(special==0){%>添加关注<%}else{%>取消关注<%}%></div>
				<%if(canEdit){ %>
					<div class="operatebtn item_status" _status="<%=_status%>" onclick="changestatus(this)" title="<%=statustitle%>"><%=statustitle%></div>
				<%} %>
			</div>
				</td>
				<td class='item_count <%if(noreadfb){%>item_count_new<%}%>' _fbcount="<%=fbcount %>" <%if(noreadfb){%>title='有新反馈'<%}else if(fbcount>0){%>title='<%=fbcount %>条反馈'<%}%>>
					<%if(fbcount>0){%>(<%=fbcount %>)<%}else{%>&nbsp;<%}%>
				</td>
				<td style="text-align: center;">
					<div id="enddate_<%=taskid %>" class="div_enddate" title='<%=enddate%>'><%=this.convertdate(enddate) %></div>
				</td>
				<td class='item_hrm' title='责任人'><%=this.getHrmLink(rs.getString("principalid")) %></td>
			</tr>
	<%
		} 
	}
	//标记或取消关注
	if("set_special".equals(operation)){
		String taskid = Util.fromScreen3(request.getParameter("taskid"),user.getLanguage());
		if(cmutil.getGoalRight(taskid,user)<1) return;
		int special = Util.getIntValue(request.getParameter("special"),0);
		//System.out.println(taskid+"-"+special);
		rs.executeSql("delete from GM_GoalSpecial where goalid="+taskid+" and userid="+user.getUID());
		if(special==0){
			rs.executeSql("insert into GM_GoalSpecial (goalid,userid) values("+taskid+","+user.getUID()+")");
		}
		//记录日志
		restr.append(this.writeLog(user,12,taskid,"special",String.valueOf(special),fn));
	}
	
	//检查是否有新任务
	if("check_new".equals(operation)){
%>
		<script type="text/javascript">
			newMap = new Map();
<%
		String userid = user.getUID()+"";
		sql = 
			"select count(t1.id) as amount from GM_GoalInfo t1 where (t1.deleted=0 or t1.deleted is null)"
			+" and t1.creater = "+userid
			+" and ((select top 1 t3.createdate+' '+t3.createtime from GM_GoalFeedback t3 where t3.goalid=t1.id and t3.hrmid<>"+userid+" order by t3.createdate desc,t3.createtime desc)"
			+">(select top 1 t2.operatedate+' '+t2.operatetime from GM_GoalLog t2 where t2.goalid=t1.id and t2.type=0 and t2.operator="+userid+" order by t2.operatedate desc,t2.operatetime desc))"
			+" union all"
			+" select count(t1.id) as amount from GM_GoalInfo t1 where (t1.deleted=0 or t1.deleted is null)"
			+" and t1.principalid = "+userid
			+" and ((not exists (select 1 from GM_GoalLog t2 where t2.goalid=t1.id and t2.type=0 and t2.operator="+userid+") and t1.creater<>"+userid+")"
			+"or (select top 1 t3.createdate+' '+t3.createtime from GM_GoalFeedback t3 where t3.goalid=t1.id and t3.hrmid<>"+userid+" order by t3.createdate desc,t3.createtime desc)"
			+">(select top 1 t2.operatedate+' '+t2.operatetime from GM_GoalLog t2 where t2.goalid=t1.id and t2.type=0 and t2.operator="+userid+" order by t2.operatedate desc,t2.operatetime desc))"
			+" union all"
			+" select count(t1.id) as amount from GM_GoalInfo t1 where (t1.deleted=0 or t1.deleted is null)"
			+" and exists (select 1 from GM_GoalPartner tp where tp.goalid=t1.id and tp.partnerid="+userid+")"
			+" and ((not exists (select 1 from GM_GoalLog t2 where t2.goalid=t1.id and t2.type=0 and t2.operator="+userid+") and t1.creater<>"+userid+")"
			+"or (select top 1 t3.createdate+' '+t3.createtime from GM_GoalFeedback t3 where t3.goalid=t1.id and t3.hrmid<>"+userid+" order by t3.createdate desc,t3.createtime desc)"
			+">(select top 1 t2.operatedate+' '+t2.operatetime from GM_GoalLog t2 where t2.goalid=t1.id and t2.type=0 and t2.operator="+userid+" order by t2.operatedate desc,t2.operatetime desc))"
			+" union all"
			+" select count(t1.id) as amount from GM_GoalInfo t1 where (t1.deleted=0 or t1.deleted is null)"
			+" and exists (select 1 from GM_GoalSpecial special where special.goalid=t1.id and special.userid="+userid+")"
			+" and ((not exists (select 1 from GM_GoalLog t2 where t2.goalid=t1.id and t2.type=0 and t2.operator="+userid+") and t1.creater<>"+userid+")"
			+"or (select top 1 t3.createdate+' '+t3.createtime from GM_GoalFeedback t3 where t3.goalid=t1.id and t3.hrmid<>"+userid+" order by t3.createdate desc,t3.createtime desc)"
			+">(select top 1 t2.operatedate+' '+t2.operatetime from GM_GoalLog t2 where t2.goalid=t1.id and t2.type=0 and t2.operator="+userid+" order by t2.operatedate desc,t2.operatetime desc))"
			+" union all"
			+" select count(t1.id) as amount from GM_GoalInfo t1 where (t1.deleted=0 or t1.deleted is null)"
			+" and exists (select 1 from GM_GoalSharer ts where ts.goalid=t1.id and ts.sharerid="+userid+")"
			+" and ((not exists (select 1 from GM_GoalLog t2 where t2.goalid=t1.id and t2.type=0 and t2.operator="+userid+") and t1.creater<>"+userid+")"
			+"or (select top 1 t3.createdate+' '+t3.createtime from GM_GoalFeedback t3 where t3.goalid=t1.id and t3.hrmid<>"+userid+" order by t3.createdate desc,t3.createtime desc)"
			+">(select top 1 t2.operatedate+' '+t2.operatetime from GM_GoalLog t2 where t2.goalid=t1.id and t2.type=0 and t2.operator="+userid+" order by t2.operatedate desc,t2.operatetime desc))"
			+" union all"
			+" select count(t1.id) as amount from GM_GoalInfo t1 where (t1.deleted=0 or t1.deleted is null) and t1.status=2"
			+" and (t1.principalid="+user.getUID()+" or t1.creater="+user.getUID()
			+ " or exists (select 1 from GM_GoalPartner tp where tp.goalid=t1.id and tp.partnerid="+user.getUID()+")"
			+ " or exists (select 1 from GM_GoalSharer ts where ts.goalid=t1.id and ts.sharerid="+user.getUID()+")"
			+ " or exists (select 1 from GM_GoalSpecial special where special.goalid=t1.id and special.userid="+userid+")"
			+ ")"
			+" and ((select top 1 t3.operatedate+' '+t3.operatetime from GM_GoalLog t3 where t3.goalid=t1.id and t3.type=6 and t3.operator<>"+userid+" order by t3.operatedate desc,t3.operatetime desc)"
			+">(select top 1 t2.operatedate+' '+t2.operatetime from GM_GoalLog t2 where t2.goalid=t1.id and t2.type=0 and t2.operator="+userid+" order by t2.operatedate desc,t2.operatetime desc))"
			;
		if(rs.getDBType().equals("oracle")){
			sql = 
			//创建
			"select count(t1.id) as amount from GM_GoalInfo t1 where (t1.deleted=0 or t1.deleted is null)"
			+" and t1.creater = "+userid+" and t1.status=1"
			+" and (nvl((select v.datetime from (select CONCAT(CONCAT(t3.createdate,' '),t3.createtime) as datetime,t3.goalid from GM_GoalFeedback t3 where t3.hrmid<>"+userid+" order by t3.createdate desc,t3.createtime desc) v where v.goalid=t1.id and rownum=1),'')"
			+">nvl((select v.datetime from (select CONCAT(CONCAT(t2.operatedate,' '),t2.operatetime) as datetime,t2.goalid from GM_GoalLog t2 where t2.type=0 and t2.operator="+userid+" order by t2.operatedate desc,t2.operatetime desc) v where v.goalid=t1.id and rownum=1),''))"
			
			//负责
			+" union all"
			+" select count(t1.id) as amount from GM_GoalInfo t1 where (t1.deleted=0 or t1.deleted is null)"
			+" and t1.principalid = "+userid+" and t1.status=1"
			+" and ((not exists (select 1 from GM_GoalLog t2 where t2.goalid=t1.id and t2.type=0 and t2.operator="+userid+") and t1.creater<>"+userid+")"
			+" or nvl((select v.datetime from (select CONCAT(CONCAT(t3.createdate,' '),t3.createtime) as datetime,t3.goalid from GM_GoalFeedback t3 where t3.hrmid<>"+userid+" order by t3.createdate desc,t3.createtime desc) v where v.goalid=t1.id and rownum=1),'')"
			+">nvl((select v.datetime from (select CONCAT(CONCAT(t2.operatedate,' '),t2.operatetime) as datetime,t2.goalid from GM_GoalLog t2 where t2.type=0 and t2.operator="+userid+" order by t2.operatedate desc,t2.operatetime desc) v where v.goalid=t1.id and rownum=1),''))"
			
			//参与
			+" union all"
			+" select count(t1.id) as amount from GM_GoalInfo t1 where (t1.deleted=0 or t1.deleted is null) and t1.status=1"
			+" and exists (select 1 from GM_GoalPartner tp where tp.goalid=t1.id and tp.partnerid="+userid+")"
			+" and ((not exists (select 1 from GM_GoalLog t2 where t2.goalid=t1.id and t2.type=0 and t2.operator="+userid+") and t1.creater<>"+userid+")"
			+" or nvl((select v.datetime from (select CONCAT(CONCAT(t3.createdate,' '),t3.createtime) as datetime,t3.goalid from GM_GoalFeedback t3 where t3.hrmid<>"+userid+" order by t3.createdate desc,t3.createtime desc) v where v.goalid=t1.id and rownum=1),'')"
			+">nvl((select v.datetime from (select CONCAT(CONCAT(t2.operatedate,' '),t2.operatetime) as datetime,t2.goalid from GM_GoalLog t2 where t2.type=0 and t2.operator="+userid+" order by t2.operatedate desc,t2.operatetime desc) v where v.goalid=t1.id and rownum=1),''))"
			
			//关注
			+" union all"
			+" select count(t1.id) as amount from GM_GoalInfo t1 where (t1.deleted=0 or t1.deleted is null) and t1.status=1"
			+" and exists (select 1 from GM_GoalSpecial special where special.goalid=t1.id and special.userid="+userid+")"
			+" and ((not exists (select 1 from GM_GoalLog t2 where t2.goalid=t1.id and t2.type=0 and t2.operator="+userid+") and t1.creater<>"+userid+")"
			+" or nvl((select v.datetime from (select CONCAT(CONCAT(t3.createdate,' '),t3.createtime) as datetime,t3.goalid from GM_GoalFeedback t3 where t3.hrmid<>"+userid+" order by t3.createdate desc,t3.createtime desc) v where v.goalid=t1.id and rownum=1),'')"
			+">nvl((select v.datetime from (select CONCAT(CONCAT(t2.operatedate,' '),t2.operatetime) as datetime,t2.goalid from GM_GoalLog t2 where t2.type=0 and t2.operator="+userid+" order by t2.operatedate desc,t2.operatetime desc) v where v.goalid=t1.id and rownum=1),''))"
					
			//分享
			+" union all"
			+" select count(t1.id) as amount from GM_GoalInfo t1 where (t1.deleted=0 or t1.deleted is null) and t1.status=1"
			+" and exists (select 1 from GM_GoalSharer ts where ts.goalid=t1.id and ts.sharerid="+userid+")"
			+" and ((not exists (select 1 from GM_GoalLog t2 where t2.goalid=t1.id and t2.type=0 and t2.operator="+userid+") and t1.creater<>"+userid+")"
			+" or nvl((select v.datetime from (select CONCAT(CONCAT(t3.createdate,' '),t3.createtime) as datetime,t3.goalid from GM_GoalFeedback t3 where t3.hrmid<>"+userid+" order by t3.createdate desc,t3.createtime desc) v where v.goalid=t1.id and rownum=1),'')"
			+">nvl((select v.datetime from (select CONCAT(CONCAT(t2.operatedate,' '),t2.operatetime) as datetime,t2.goalid from GM_GoalLog t2 where t2.type=0 and t2.operator="+userid+" order by t2.operatedate desc,t2.operatetime desc) v where v.goalid=t1.id and rownum=1),''))"
			
			//已完成新反馈
			+" union all"
			+" select count(t1.id) as amount from GM_GoalInfo t1 where (t1.deleted=0 or t1.deleted is null) and t1.status=2"
			+" and (t1.principalid="+user.getUID()+" or t1.creater="+user.getUID()
			+ " or exists (select 1 from GM_GoalPartner tp where tp.goalid=t1.id and tp.partnerid="+user.getUID()+")"
			+ " or exists (select 1 from GM_GoalSharer ts where ts.goalid=t1.id and ts.sharerid="+user.getUID()+")"
			+ " or exists (select 1 from GM_GoalSpecial special where special.goalid=t1.id and special.userid="+userid+")"
			+ ")"
			+" and (nvl((select v.datetime from (select CONCAT(CONCAT(t3.createdate,' '),t3.createtime) as datetime,t3.goalid from GM_GoalFeedback t3 where t3.hrmid<>"+userid+" order by t3.createdate desc,t3.createtime desc) v where v.goalid=t1.id and rownum=1),'')"
			+">nvl((select v.datetime from (select CONCAT(CONCAT(t2.operatedate,' '),t2.operatetime) as datetime,t2.goalid from GM_GoalLog t2 where t2.type=0 and t2.operator="+userid+" order by t2.operatedate desc,t2.operatetime desc) v where v.goalid=t1.id and rownum=1),''))"
			
			//我分配
			+" union all"
			+" select count(t1.id) as amount from GM_GoalInfo t1 where (t1.deleted=0 or t1.deleted is null) and t1.status=1"
			+" and t1.creater = "+userid+" and t1.principalid<>"+userid 
			+" and (nvl((select v.datetime from (select CONCAT(CONCAT(t3.createdate,' '),t3.createtime) as datetime,t3.goalid from GM_GoalFeedback t3 where t3.hrmid<>"+userid+" order by t3.createdate desc,t3.createtime desc) v where v.goalid=t1.id and rownum=1),'')"
			+">nvl((select v.datetime from (select CONCAT(CONCAT(t2.operatedate,' '),t2.operatetime) as datetime,t2.goalid from GM_GoalLog t2 where t2.type=0 and t2.operator="+userid+" order by t2.operatedate desc,t2.operatetime desc) v where v.goalid=t1.id and rownum=1),''))"
			;		
		}
		rs.executeSql(sql);
		//System.out.println(sql);
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
	if("get_more_fb".equals(operation)){
		String userid = user.getUID()+"";
		String orderby1 = " order by createdate desc,createtime desc";
		String orderby2 = " order by createdate asc,createtime asc";
		String orderby3 = " order by t1.createdate desc,t1.createtime desc";
		int currentpage = Util.getIntValue(request.getParameter("currentpage"),0);
		int pagesize = Util.getIntValue(request.getParameter("pagesize"),0);
		int total = Util.getIntValue(request.getParameter("total"),0);
		//String querysql = Util.null2String(URLDecoder.decode(request.getParameter("querysql"),"utf-8"));//.replaceAll("t3.createdate ' ' t3.createtime","t3.createdate+' '+t3.createtime").replaceAll("t2.operatedate ' ' t2.operatetime","t2.operatedate+' '+t2.operatetime");
		String querysql = " t1.id,t1.content,t1.hrmid,t1.docids,t1.wfids,t1.crmids,t1.projectids,t1.meetingids,t1.fileids,t1.createdate,t1.createtime,t2.id as goalid,t2.name "
			+",(select top 1 tlog.operatedate+' '+tlog.operatetime from GM_GoalLog tlog where tlog.goalid=t2.id and tlog.type=0 and tlog.operator="+userid+" order by tlog.operatedate desc,tlog.operatetime desc) as lastviewdate"
			+" from GM_GoalFeedback t1,GM_GoalInfo t2 "
			+" where t1.goalid=t2.id and (t2.deleted=0 or t2.deleted is null)"
			+" and (t2.creater="+userid+" or t2.principalid="+userid+" or exists (select 1 from GM_GoalPartner tp where tp.goalid=t2.id and tp.partnerid="+userid+"))"
			+" and t1.hrmid<>"+userid;
		int iTotal =total; 
		int iNextNum = currentpage * pagesize;
		int ipageset = pagesize;
		if(iTotal - iNextNum + pagesize < pagesize) ipageset = iTotal - iNextNum + pagesize;
		if(iTotal < pagesize) ipageset = iTotal;
		sql = "select top " + ipageset +" A.* from (select top "+ iNextNum + querysql+ orderby3 + ") A "+orderby2;
		sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderby1;
		//System.out.println(total+"---"+sql);
		boolean isnew  = false;
		String lastviewdate = "";
		String createdate = "";
		rs.executeSql(sql);
		while(rs.next()){
			lastviewdate = Util.null2String(rs.getString("lastviewdate"));
			createdate = Util.null2String(rs.getString("createdate"))+" "+Util.null2String(rs.getString("createtime"));
			//System.out.println(lastviewdate+"-"+createdate);
			if(TimeUtil.timeInterval(lastviewdate,createdate)>0) isnew = true; else isnew = false;
	%>
	<tr>
		<td class="data">
			<div class="feedbackshow">
				<div class="feedbackinfo" style="font-weight: bold;"><a href="javascript:refreshDetail(<%=Util.null2String(rs.getString("goalid")) %>)"><%=Util.null2String(rs.getString("name")) %></a></div>
				<div class="feedbackinfo"><%=cmutil.getHrm(rs.getString("hrmid")) %> <%=Util.null2String(rs.getString("createdate")) %> <%=Util.null2String(rs.getString("createtime")) %>
				<%if(isnew){ %><font style='color: red;margin-left: 5px;font-style: italic;font-size: 11px;cursor: pointer;' title='新反馈'>new</font><%} %>
				</div>
				<div class="feedbackrelate">
					<div><%=Util.convertDB2Input(rs.getString("content")) %></div>
					<%if(!"".equals(rs.getString("docids"))){ %>
					<div class="relatetitle">相关文档：<%=cmutil.getDocName(rs.getString("docids")) %></div>
					<%} %>
					<%if(!"".equals(rs.getString("wfids"))){ %>
					<div class="relatetitle">相关流程：<%=cmutil.getRequestName(rs.getString("wfids")) %></div>
					<%} %>
					<%if(!"".equals(rs.getString("crmids"))){ %>
					<div class="relatetitle">相关客户：<%=cmutil.getCustomer(rs.getString("crmids")) %></div>
					<%} %>
					<%if(!"".equals(rs.getString("projectids"))){ %>
					<div class="relatetitle">相关项目：<%=cmutil.getProject(rs.getString("projectids")) %></div>
					<%} %>
					<%if(!"".equals(rs.getString("fileids"))){ %>
					<div class="relatetitle">相关附件：<%=this.getFileDoc(rs.getString("fileids"),Util.null2String(rs.getString("goalid")),user) %></div>
					<%} %>
				</div>
			</div>
		</td>
	</tr>
	<%}
	}
	
	if("get_allp".equals(operation)){
		String taskid = Util.fromScreen3(request.getParameter("taskid"),user.getLanguage());
		int right = cmutil.getGoalRight(taskid,user);
		if(right<1) return;
		rs.executeSql("select distinct partnerid from GM_GoalPartner where goalid="+taskid);
		String partnerid = "";
		while(rs.next()){
			partnerid = Util.null2String(rs.getString(1));
			if(!partnerid.equals("0") && !partnerid.equals("")){
			
	%>
	<div class="txtlink txtlink<%=partnerid %>" onmouseover="showdel(this)" onmouseout="hidedel(this)">
		<div style="float: left;"><%=cmutil.getHrm(partnerid) %></div>
		<%if(right==2){ %>
		<div class="btn_del" onclick="delItem('partnerid','<%=partnerid %>')"></div>
		<div class="btn_wh"></div>
		<%}else{ %>
		<div class="btn_wh2"></div>
		<%} %>
	</div>
	<% 		} 
		}
	}
	
	if("get_allsub".equals(operation)){
		String taskid = Util.fromScreen3(request.getParameter("taskid"),user.getLanguage());
		int right = cmutil.getGoalRight(taskid,user);
		if(right<1) return;
		int showallsub = Util.getIntValue(request.getParameter("showallsub"),0);
		boolean create = Util.null2String(request.getParameter("create")).equals("1");
		restr.append(this.getSubTask(taskid,user,1,showallsub,create));
	}
	
	out.print(restr.toString());
	//out.close();
%>
<%!
	public String getSubTask(String maintaskid,User user,int type,int showallsub,boolean create) throws Exception{
		String userid = user.getUID()+"";
		StringBuffer res = new StringBuffer();
		boolean editsub = false;
		boolean cancreate = false;
		RecordSet rs = new RecordSet();
		CommonTransUtil cmutil = new CommonTransUtil();
		StringBuffer sql = new StringBuffer();
		sql.append("select t1.id,t1.name,t1.principalid,t1.status from GM_GoalInfo t1 where (t1.deleted=0 or t1.deleted is null) and t1.parentid="+maintaskid);
		if(showallsub==0 && cmutil.getGoalMaint(userid)[0]==0){
			sql.append(" and (t1.principalid="+userid+" or t1.creater="+userid
				+ " or exists (select 1 from GM_GoalPartner tp where tp.goalid=t1.id and tp.partnerid="+userid+")"
				+ " or exists (select 1 from GM_GoalSharer ts where ts.goalid=t1.id and ts.sharerid="+userid+")"
				+ " or exists (select 1 from HrmResource hrm where (hrm.id=t1.principalid or hrm.id=t1.creater) and hrm.managerstr like '%,"+userid+",%')"
				+ " or exists (select 1 from HrmResource hrm,GM_GoalPartner tp where tp.goalid=t1.id and hrm.id=tp.partnerid and hrm.managerstr like '%,"+userid+",%')"
				+ ")");
		}
		sql.append(" order by t1.showorder,t1.id");
		rs.executeSql(sql.toString());
		//if(rs.getCounts()>0){
			if(type==2) res.append("<tr class='subtable_tr'><td colspan='5' style='padding:0px;padding-left:20px;border:0px;height:auto'><table class='subdatalist' cellpadding='0' cellspacing='0' border='0' align='center'><colgroup><col width='20px'/><col width='*'/><col width='50px'/><col width='30px'/><col width='20px'/></colgroup>");
			while(rs.next()){
				cancreate = false;
				editsub = cmutil.getGoalRight(rs.getString("id"),user)==2?true:false;
				if(!editsub){
					if(create){
						RecordSet rs2 = new RecordSet();
						rs2.executeSql("select id from GM_GoalPartner tp where tp.goalid="+rs.getString("id")+" and tp.partnerid="+userid);
						if(rs2.next()) cancreate = true;
					}
				}else{
					cancreate = true;
				}
				res.append("<tr class='subitem_tr'>");
				res.append("<td><div class='status status"+rs.getString("status")+"'>&nbsp;</div></td>");
				res.append("<td class='item_td'>");
				res.append("	<input "+((!editsub)?"readonly='readonly'":"")+" onfocus='doClickSubItem(this)' onblur='doBlurSubItem(this)'");
				res.append("		class='subdisinput' type='text' name='' id='sub_"+rs.getString("id")+"' _pid='"+maintaskid+"' _createsub='"+(cancreate?1:0)+"' title='"+Util.null2String(rs.getString("name"))+"'");
				res.append("		value='"+Util.null2String(rs.getString("name"))+"' _defaultname='"+Util.null2String(rs.getString("name"))+"'/>");
				res.append("</td>");
				res.append("<td class='item_hrm' title='责任人'>"+this.getHrmLink(rs.getString("principalid"))+"</td>");
				res.append("<td class='item_view'><a href='javascript:refreshDetail("+rs.getString("id")+")'>查看</a></td>");
				res.append("<td class='item_add'>");
				if(cancreate) res.append("<div class='subadd' title='建立下级目标' onclick='addSubItem("+rs.getString("id")+")'>+</div>");
				res.append("</td>");
				res.append("</tr>");
				res.append(this.getSubTask(rs.getString("id"),user,2,showallsub,editsub));
			}
			if(type==2) res.append("</table></td></tr>");
		//}
		
		return res.toString();
	}

	/**
	* type  0:查看 1:新建  2:编辑内容  3:新增内容  4:删除内容 5:进行 6:完成  7:撤销  8:删除 9:上传 10:反馈 11:标记 12:关注
	*/
	private String writeLog(User user,int type,String taskid,String field,String value,Map fn){
		RecordSet rs = new RecordSet();
		String currentdate = TimeUtil.getCurrentDateString();
		String currenttime = TimeUtil.getOnlyCurrentTimeString();
		rs.executeSql("insert into GM_GoalLog (goalid,type,operator,operatedate,operatetime,operatefiled,operatevalue)"
				+" values("+taskid+","+type+","+user.getUID()+",'"+currentdate+"','"+currenttime+"','"+field+"','"+value+"')");
		return getlogtext(user.getUID()+"",currentdate+" "+currenttime,type,field,value,fn,taskid);
	}
	private String getlogtext(String userid,String datetime,int type,String field,String value,Map fn,String taskId){
		String logtxt = "<div class='logitem'>"+getLink("hrmid",userid+"",taskId)+"&nbsp;&nbsp;<font class='datetxt'>"+datetime+"</font>&nbsp;&nbsp;";
		String valtxt = getLink(field,value,taskId);
		switch(type){
			case 0:logtxt+="查看目标";break;
			case 1:logtxt+="新建目标";break;
			case 2:logtxt+="更新"+fn.get(field)+"为&nbsp;&nbsp;"+valtxt;break;
			case 3:logtxt+="添加"+fn.get(field)+"&nbsp;&nbsp;"+valtxt;break;
			case 4:logtxt+="删除"+fn.get(field)+"&nbsp;&nbsp;"+valtxt;break;
			case 5:logtxt+="设置为进行中";break;
			case 6:logtxt+="设置为完成";break;
			case 7:logtxt+="设置为撤销";break;
			case 8:logtxt+="删除目标";break;
			case 9:logtxt+="上传"+fn.get(field)+"&nbsp;&nbsp;"+valtxt;break;
			case 10:logtxt+="添加反馈";break;
			case 11:logtxt+=this.getTodoLog(value);break;
			case 12:logtxt+=this.getSpecialLog(value);break;
		}
		logtxt += "</div>";
		return logtxt;
	}
	private String getTodoLog(String value){
		String todolog = "";
		if("4".equals(value)){
			todolog = "取消标记";
		}else if("1".equals(value)){
			todolog = "标记为今天";
		}else if("2".equals(value)){
			todolog = "标记为明天";
		}else if("3".equals(value)){
			todolog = "标记为即将";
		}else if("5".equals(value)){
			todolog = "标记为备注";
		}
		return todolog;
	}
	private String getSpecialLog(String value){
		String specialLog = "";
		if("0".equals(value)){
			specialLog = "添加关注";
		}else if("1".equals(value)){
			specialLog = "取消关注";
		}
		return specialLog;
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
		}else if("goalids".equals(field) || "parentid".equals(field)){
			return cmutil.getGoalName(value);
		}else if("taskids".equals(field)){
			return cmutil.getTaskName2(value);
		}else if("fileids".equals(field)){
			return value;
		}else if("level".equals(field)){
			if("1".equals(value)) return "重要紧急";
			if("2".equals(value)) return "重要";
			if("3".equals(value)) return "紧急";
			if("4".equals(value)) return "不重要不紧急";
			return "";
		}else if("period".equals(field)){
			if("1".equals(value)) return "月度";
			if("2".equals(value)) return "季度";
			if("3".equals(value)) return "年度";
			if("4".equals(value)) return "三年";
			if("5".equals(value)) return "五年";
			return "";
		}else{
			return value;
		}
	}
	public String getFileDoc(String ids,String goalid,User user) throws Exception{
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
		            returnstr += "<a href=javaScript:openFullWindowHaveBar('/workrelate/goal/util/ViewDoc.jsp?id="+docid+"&goalid="+goalid+"') >"+docImagefilename+"</a>";
		            returnstr += "&nbsp;<a href='/workrelate/goal/util/ViewDoc.jsp?id="+docid+"&goalid="+goalid+"&fileid="+docImagefileid+"'>下载("+docImagefileSize/1000+"K)</a>&";
		            returnstr += "&nbsp;"+ weaver.workrelate.util.TransUtil.getReviewLink(docImagefilename, docImagefileid, user.getLanguage(), user,1,docid,goalid,"")+"&nbsp;&nbsp;";
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
	/**
	* 更新所有上级任务的参与人
	*/
	private void updateSupPartner(String taskid){
		RecordSet rs = new RecordSet();
		List hrmids = new ArrayList();
		String parentid = "";
		String parentPrincipalid = "";
		rs.executeSql("select principalid,parentid from GM_GoalInfo where parentid<>0 and parentid is not null and (deleted=0 or deleted is null) and id="+taskid);
		if(rs.next()){
			parentid = Util.null2String(rs.getString("parentid"));
			if(!parentid.equals("")){
				hrmids.add(Util.null2String(rs.getString("principalid")));
				rs.executeSql("select principalid from GM_GoalInfo where (deleted=0 or deleted is null) and id="+parentid);
				if(rs.next()){
					parentPrincipalid = Util.null2String(rs.getString("principalid"));
					String partnerid = "";
					rs.executeSql("select partnerid from GM_GoalPartner where goalid="+taskid);
					while(rs.next()){
						partnerid = Util.null2String(rs.getString("partnerid"));
						if(!partnerid.equals("") && !partnerid.equals(parentPrincipalid) && hrmids.indexOf(partnerid)<0){
							hrmids.add(partnerid);
						}
					}
					for(int i=0;i<hrmids.size();i++){
						partnerid = (String)hrmids.get(i);
						if(!partnerid.equals("")){
							rs.executeSql("delete from GM_GoalPartner where goalid="+parentid+" and partnerid="+partnerid);
							rs.executeSql("insert into GM_GoalPartner (goalid,partnerid) values('"+parentid+"','"+partnerid+"')");
						}
					}
					this.updateSupPartner(parentid);
				}
			}
		}
	}
	private String convertdate(String datestr){
		datestr = Util.null2String(datestr);
		if(datestr.length()==10){
			datestr = datestr.substring(5).replace("-",".");
		}
		return datestr;
	}
%>
