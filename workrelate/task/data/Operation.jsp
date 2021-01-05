<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@page import="java.net.URLDecoder"%>
<%@ page import="weaver.docs.docs.*"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.conn.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="weaver.file.Prop" %>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="weaver.workrelate.util.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<%
	String operation = Util.fromScreen3(request.getParameter("operation"), user.getLanguage());
	String currentDate = TimeUtil.getCurrentDateString();
	String currentTime = TimeUtil.getOnlyCurrentTimeString();
	String yesterday = TimeUtil.dateAdd(currentDate,-1);
	String tomorrow = TimeUtil.dateAdd(currentDate,1);
	String userid = user.getUID()+"";
	String sql = "";
	StringBuffer restr = new StringBuffer();
	
	String func1 = "";
	String operatedt = "";
	String createdt = "";
	if(!rs.getDBType().equals("oracle")){
		func1 = "isnull";
		operatedt = "max(operatedate+' '+operatetime)";
		createdt = "max(createdate+' '+createtime)";
	}else{
		func1 = "nvl";
		operatedt = "max(CONCAT(CONCAT(operatedate,' '),operatetime))";
		createdt = "max(CONCAT(CONCAT(createdate,' '),createtime))";
	}
	
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
	fn.put("parentid","上级任务");
	fn.put("showallsub","是否开放下级任务");
	//新建
	if("add".equals(operation)){
		int relateadd = Util.getIntValue(request.getParameter("relateadd"),0);
		String tname = Util.null2String(request.getParameter("taskName")).replaceAll("%(?![0-9a-fA-F]{2})", "%25");//输入%时候会调用URLDecoder.decode会报错，主要原因是% 在URL中是特殊字符，需要特殊转义一下
		String name = Util.fromScreen3(URLDecoder.decode(tname,"utf-8"),user.getLanguage());
		if(relateadd==1) name = Util.fromScreen3(Util.null2String(request.getParameter("taskName")),user.getLanguage());
		String sorttype = Util.fromScreen3(request.getParameter("sorttype"), user.getLanguage());
		String datetype = Util.fromScreen3(request.getParameter("datetype"), user.getLanguage());
		int saveType = Util.getIntValue(request.getParameter("saveType"),0);
		String eid = Util.fromScreen3(request.getParameter("eid"), user.getLanguage());
		//System.out.println("sorttype:"+sorttype);
		//System.out.println("datetype:"+datetype);
		String principalid = Util.fromScreen3(request.getParameter("principalid"), user.getLanguage());
		String parentid = Util.fromScreen3(request.getParameter("parentid"), user.getLanguage());
		if(principalid.equals("") || principalid.equals("0")){
			principalid = user.getUID()+"";
		}
		//判断是否有新建下级任务的权限
		if(!parentid.equals("")){
			if(cmutil.getRight(parentid,user)<2){
				rs.executeSql("select id from TM_TaskPartner tp where tp.taskid="+parentid+" and tp.partnerid="+user.getUID());
				if(!rs.next()) return;
			}
		}
		String begindate = Util.fromScreen3(request.getParameter("begindate"), user.getLanguage());
		String enddate = Util.fromScreen3(request.getParameter("enddate"), user.getLanguage());
		String tag = Util.fromScreen3(URLDecoder.decode(Util.null2String(request.getParameter("tag")),"utf-8"),user.getLanguage());
		if(!tag.equals("")){
			if(!tag.startsWith(",")) tag = "," + tag;
			if(!tag.endsWith(",")) tag += ",";
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
		if(sorttype.equals("3")){
			level = Util.getIntValue(datetype);
		}
		if(level==5) level=0;
		
		if(relateadd==1) level = Util.getIntValue(request.getParameter("lev"),0);
		String remark = Util.convertDbInput(request.getParameter("remark"));
		String risk = Util.convertDbInput(request.getParameter("risk"));
		String difficulty = Util.convertDbInput(request.getParameter("difficulty"));
		String assist = Util.convertDbInput(request.getParameter("assist"));
		String taskids2 = this.transRelateid(request.getParameter("taskids"));
		String goalids = this.transRelateid(request.getParameter("goalids"));
		String docids = this.transRelateid(request.getParameter("docids"));
		String wfids = this.transRelateid(request.getParameter("wfids"));
		String meetingids = this.transRelateid(request.getParameter("meetingids"));
		String crmids = this.transRelateid(request.getParameter("crmids"));
		String projectids = this.transRelateid(request.getParameter("projectids"));
		String fileids = this.transRelateid(request.getParameter("relatedacc"));
		
		sql = "insert into TM_TaskInfo (name,status,creater,createdate,createtime,begindate,enddate,lev,principalid,parentid,tag"
			+",remark,risk,difficulty,assist,taskids,goalids,docids,wfids,meetingids,crmids,projectids,fileids)"
			+" values('"+name+"',1,"+user.getUID()+",'"+currentDate+"','"+currentTime+"','"+begindate+"','"+enddate+"',"+level+","+principalid+",'"+parentid+"','"+tag+"'"
			+",'"+remark+"','"+risk+"','"+difficulty+"','"+assist+"','"+taskids2+"','"+goalids+"','"+docids+"','"+wfids+"','"+meetingids+"','"+crmids+"','"+projectids+"','"+fileids+"')";
		boolean res = rs.executeSql(sql);
		if(res){
			String taskId = "";
			String dutyMan = this.getHrmLink(principalid);
			rs.executeSql("select max(id) from TM_TaskInfo");
			if(rs.next()) taskId = rs.getString(1);
			restr.append(taskId+"$"+this.getHrmLink(principalid));
			if(!parentid.equals("")){
				restr.append("<input type='hidden' id='subprincipalid_"+taskId+"' name='subprincipalid_"+taskId+"' value='"+principalid+"'/>");
			}
			
			//添加新建反馈  zhw 20140911修改 取消增加新建反馈
			//String content = "新建";
			//sql = "insert into TM_TaskFeedback (taskid,content,hrmid,docids,wfids,crmids,projectids,meetingids,fileids,createdate,createtime)"
			//	+" values("+taskId+",'"+content+"',"+user.getUID()+",'','','','','','','"+currentDate+"','"+currentTime+"')";
			//rs.executeSql(sql);
			//记录日志
			this.writeLog(user,1,taskId,"","",fn);
			//判断下级任务则需要默认加入查看日志并更新所有上级任务的参与人
			if(!parentid.equals("") && relateadd==0){
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
					sql = "insert into TM_TaskTodo (taskid,userid,tododate) values('"+taskId+"','"+principalid+"','"+tododate+"')";
					rs.executeSql(sql);
				}
			}
			
			//通过计划报告创建任务
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
			
			
			//增加参与人
			String partnerids = Util.null2String(request.getParameter("partnerid"));
			List partneridList = Util.TokenizerString(partnerids,",");
			String partnerid = "";
			if(null!=partneridList&&partneridList.size()>0){
				for(int i=0;i<partneridList.size();i++){
					partnerid = Util.null2String((String)partneridList.get(i));
					if(!partnerid.equals("")){
						rs.executeSql("insert into TM_TaskPartner (taskid,partnerid) values("+taskId+","+partnerid+")");
					}
				}
			}
			//发送消息提醒
			SendMsg.sendMsg(taskId,user.getUID()+"","newTask","","","","","","","");
			//相关信息创建任务
			if(relateadd==1){
				//调整上级任务的参与人
				if(!parentid.equals("")) this.updateSupPartner(taskId);
				//增加共享人
				String sharerids = Util.null2String(request.getParameter("sharerid"));
				List shareridList = Util.TokenizerString(sharerids,",");
				String sharerid = "";
				for(int i=0;i<shareridList.size();i++){
					sharerid = Util.null2String((String)shareridList.get(i));
					if(!sharerid.equals("")){
						rs.executeSql("insert into TM_TaskSharer (taskid,sharerid) values("+taskId+","+sharerid+")");
					}
					
				}
			%>
			<script type="text/javascript">
				if(<%=saveType%>==0){
					openFullWindowHaveBar("/workrelate/task/data/Main.jsp?taskid=<%=taskId%>");
					try{
						window.close();
					}catch(e){
						window.close();
					}
				}else if(<%=saveType%>==1){
					parent.closeAddDialog_<%=eid%>();
					alert("保存成功");
					//parent.closeShadowBox();
				}else if(<%=saveType%>==2){
					parent.reloadList_<%=eid%>();
					location.href="/workrelate/task/data/Add.jsp?saveType=1&eid=<%=eid%>";
					alert("保存成功");
				}else if(<%=saveType%>==3){
					openFullWindowHaveBar("/workrelate/task/data/Main.jsp?taskid=<%=taskId%>");
					parent.closeAddDialog_<%=eid%>();
					//parent.closeShadowBox();
				}else if(<%=saveType%>==4){
					parent.doCloneClick("<%=taskId%>","<%=name%>","<%=dutyMan%>",0,'<%=enddate%>','<%=datetype%>','<%=level%>');
				}else if(<%=saveType%>==5){
					parent.doCloneClick("<%=taskId%>","<%=name%>","<%=dutyMan%>",1,'<%=enddate%>','<%=datetype%>','<%=level%>');
				}
				
				function openFullWindowHaveBar(url){
					  var redirectUrl = url ;
					  var width = screen.availWidth-10 ;
					  var height = screen.availHeight-50 ;
					  //if (height == 768 ) height -= 75 ;
					  //if (height == 600 ) height -= 60 ;
					   var szFeatures = "top=0," ;
					  szFeatures +="left=0," ;
					  szFeatures +="width="+width+"," ;
					  szFeatures +="height="+height+"," ;
					  szFeatures +="directories=no," ;
					  szFeatures +="status=yes,toolbar=no,location=no," ;
					  szFeatures +="menubar=no," ;
					  szFeatures +="scrollbars=yes," ;
					  szFeatures +="resizable=yes" ; //channelmode
					  window.open(redirectUrl,"",szFeatures) ;
				}
			</script>
			<%
				return;
			}
		}
	}
	//编辑名称
	if("edit_name".equals(operation)){
		String taskId = Util.fromScreen3(request.getParameter("taskId"),user.getLanguage());
		if(cmutil.getRight(taskId,user)<2) return;
		String name = Util.fromScreen3(URLDecoder.decode(request.getParameter("taskName"),"utf-8"),user.getLanguage());
		sql = "update TM_TaskInfo set name='"+name+"' where id="+taskId;
		rs.executeSql(sql);
		//记录日志
		restr.append(this.writeLog(user,2,taskId,"name",name,fn));
	}
	//编辑字段
	if("edit_field".equals(operation)){
		String taskId = Util.fromScreen3(request.getParameter("taskId"),user.getLanguage());
		String fieldname = Util.fromScreen3(request.getParameter("fieldname"),user.getLanguage());
		if(cmutil.getRight(taskId,user)<2 && !fieldname.equals("5")) return;
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
				//调整上级任务的参与人
				this.updateSupPartner(taskId);
				//给新增加的参与人发送消息提醒
				SendMsg.sendMsg(taskId,user.getUID()+"","newPartners",fieldvalue,"","","","","","");
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
			//调整上级任务的参与人
			this.updateSupPartner(taskId);
			//给责任人发送消息提醒
			SendMsg.sendMsg(taskId,user.getUID()+"","newDutyMan",fieldvalue,"","","","","","");
		}else if(fieldname.equals("parentid")){
			if(fieldtype.equals("del")) fieldvalue = "0";
			rs.executeSql("update TM_TaskInfo set parentid="+fieldvalue+"  where id="+taskId);
			//记录日志
			restr.append(this.writeLog(user,2,taskId,"parentid",fieldvalue,fn));
			//调整上级任务的参与人
			this.updateSupPartner(taskId);
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
				restr.append("<a href=javaScript:openFullWindowHaveBar('/workrelate/task/util/ViewDoc.jsp?id=" + fileidList.get(i)+"&taskId="+taskId+"')>"+docImagefilename+"</a>");
				restr.append("&nbsp;<a href='/workrelate/task/util/ViewDoc.jsp?id="+fileidList.get(i)+"&taskId="+taskId+"&fileid="+docImagefileid+"'>下载("+docImagefileSize/1000+"K)</a>");
				restr.append("&nbsp;"+weaver.workrelate.util.TransUtil.getReviewLink(docImagefilename, docImagefileid, user.getLanguage(), user,3,(String)fileidList.get(i),taskId,""));
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
			
			rs.executeSql("update TM_TaskInfo set enddate='"+enddate+"' where id="+taskId);
			//记录日志
			restr.append(this.writeLog(user,2,taskId,"date","结束:"+enddate,fn));
		}else if(fieldname.equals("3")){//列表中调整紧急程度
			int level = Util.getIntValue(fieldvalue);
			if(level==5) level=0;
			rs.executeSql("update TM_TaskInfo set lev="+level+" where id="+taskId);
			//记录日志
			restr.append(this.writeLog(user,2,taskId,"level",level+"",fn));
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
			rs.executeSql("delete from TM_TaskTodo where taskid="+taskId+" and userid="+user.getUID());
			if(!tododate.equals("")){
				sql = "insert into TM_TaskTodo (taskid,userid,tododate) values('"+taskId+"','"+user.getUID()+"','"+tododate+"')";
				rs.executeSql(sql);
			}
			//记录日志
			restr.append(this.writeLog(user,11,taskId,"todo",fieldvalue,fn));
		}else{
			String fname = fieldname;
			if(fname.equals("level")) fname = "lev";
			if(fieldtype.equals("str")){
				sql = "update TM_TaskInfo set "+fname+"='"+fieldvalue+"' where id="+taskId;
			}else if(fieldtype.equals("int")){
				fieldvalue = Util.null2o(fieldvalue);
				sql = "update TM_TaskInfo set "+fname+"="+fieldvalue+" where id="+taskId;
			}
			//System.out.println(sql);
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
		if(cmutil.getRight(taskId,user)<2) return;
		String status = Util.fromScreen3(request.getParameter("status"),user.getLanguage());
		if(!taskId.equals("") && !status.equals("")){
			if(status.equals("4")){//删除
				rs.executeSql("update TM_TaskInfo set deleted=1 where id="+taskId);
				rs.executeSql("update TM_TaskInfo set parentid = null where parentid="+taskId);
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
			
			//更改为完成时加入反馈记录
			if(status.equals("2")){
				//添加完成反馈
				String content = "已完成！";
				sql = "insert into TM_TaskFeedback (taskid,content,hrmid,docids,wfids,crmids,projectids,meetingids,fileids,createdate,createtime)"
					+" values("+taskId+",'"+content+"',"+user.getUID()+",'','','','','','','"+currentDate+"','"+currentTime+"')";
				rs.executeSql(sql);
				restr.append("$<tr><td class='data fbdata'><div class='feedbackshow'>"
						+"<div class='feedbackinfo'>"+cmutil.getPerson(user.getUID()+"")+" "+currentDate+" "+currentTime+"</div>"
						+"<div class='feedbackrelate'>"
						+"<div style='width:100%'>"+Util.null2String(content)+"</div>");
				restr.append("</div></div></td></tr>");
			}
		}
	}
	//添加反馈
	if("add_feedback".equals(operation)){
		String taskId = Util.fromScreen3(request.getParameter("taskId"),user.getLanguage());
		if(this.getRight(taskId,user)<1) return;
		String content = Util.convertInput2DB(URLDecoder.decode(request.getParameter("content"),"utf-8"));
		String docids = cmutil.cutString(request.getParameter("docids"),",",3);
		String wfids = cmutil.cutString(request.getParameter("wfids"),",",3);
		String crmids = cmutil.cutString(request.getParameter("crmids"),",",3);
		String projectids = cmutil.cutString(request.getParameter("projectids"),",",3);
		String meetingids = cmutil.cutString(request.getParameter("meetingids"),",",3);
		String fileids = cmutil.cutString(request.getParameter("fileids"),",",3);
		if(!fileids.equals("")) fileids = "," + fileids + ",";
		String replyid = Util.fromScreen3(request.getParameter("replyid"),user.getLanguage());
		
		if(!taskId.equals("") && !content.equals("")){
			sql = "insert into TM_TaskFeedback (taskid,content,hrmid,docids,wfids,crmids,projectids,meetingids,fileids,createdate,createtime,replyid)"
				+" values("+taskId+",'"+content+"',"+userid+",'"+docids+"','"+wfids+"','"+crmids+"','"+projectids+"','"+meetingids+"','"+fileids+"','"+currentDate+"','"+currentTime+"','"+replyid+"')";
			rs.executeSql(sql);
			String fbid = "";
			rs.executeSql("select max(id) from TM_TaskFeedback");
			if(rs.next()) fbid = Util.null2String(rs.getString(1));
			restr.append("<tr><td id='fbdata_"+fbid+"' class='data fbdata'><div class='feedbackshow'>"
					+"<div class='feedbackinfo'>"+cmutil.getPerson(user.getUID()+"")+" "+currentDate+" "+currentTime);
			restr.append("<div class='fboperate'>");
			restr.append(this.getDelOperate(fbid,userid,userid,currentDate,currentTime));
			restr.append("<a href=\"javascript:doReply('"+fbid+"')\">回复</a></div>");
			restr.append("</div>");
			restr.append("<div class='feedbackrelate'>"
				+"<div style='width:100%'>"+Util.null2String(content)+"</div>");
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
			restr.append("</div>");
			if(!replyid.equals("")){
				rs2.executeSql("select id,content,hrmid,docids,wfids,crmids,projectids,meetingids,fileids,createdate,createtime,replyid from TM_TaskFeedback where id="+replyid);
				if(rs2.next()){
					restr.append("<div class='fbreply'>");
					restr.append("<div class='feedbackinfo2'>@ "+cmutil.getHrm(rs2.getString("hrmid"))+" "+Util.null2String(rs2.getString("createdate"))+" "+Util.null2String(rs2.getString("createtime"))+"</div>");
					restr.append("<div class='feedbackrelate2'>");
					restr.append("<div>"+Util.null2String(rs2.getString("content"))+"</div>");
					if(!"".equals(rs2.getString("docids"))){
						restr.append("<div class='relatetitle2'>相关文档："+cmutil.getDocName(rs2.getString("docids"))+"</div>");
					}
					if(!"".equals(rs2.getString("wfids"))){
						restr.append("<div class='relatetitle2'>相关流程："+cmutil.getRequestName(rs2.getString("wfids"))+"</div>");
					}
					if(!"".equals(rs2.getString("crmids"))){
						restr.append("<div class='relatetitle2'>相关客户："+cmutil.getCustomer(rs2.getString("crmids"))+"</div>");
					} 
					if(!"".equals(rs2.getString("projectids"))){ 
						restr.append("<div class='relatetitle2'>相关项目："+cmutil.getProject(rs2.getString("projectids"))+"</div>");
					}
					if(!"".equals(rs2.getString("fileids"))){
						restr.append("<div class='relatetitle2'>相关附件："+this.getFileDoc(rs2.getString("fileids"),taskId,user)+"</div>");
					}
					restr.append("</div>");
					restr.append("</div>");
				}
			}
			
			restr.append("</div></td></tr>");
			//发送消息提醒
			SendMsg.sendMsg(taskId,user.getUID()+"","newFb","",fbid,"","","","","");
			//记录日志
			restr.append("$"+this.writeLog(user,10,taskId,"","",fn));
		}
	}
	//获取反馈记录
	if("get_feedback".equals(operation)){
		String taskId = Util.fromScreen3(request.getParameter("taskId"),user.getLanguage());
		if(this.getRight(taskId,user)<1) return;
		String lastId = Util.fromScreen3(request.getParameter("lastId"),user.getLanguage());
		String viewdate = Util.fromScreen3(request.getParameter("viewdate"),user.getLanguage());
		rs.executeSql("select id,content,hrmid,docids,wfids,crmids,projectids,meetingids,fileids,createdate,createtime,replyid from TM_TaskFeedback where taskid=" + taskId +" and id<"+lastId+" order by createdate desc,createtime desc");
		String docids = "";
		String wfids = "";
		String crmids = "";
		String projectids = "";
		String fileids = "";
		String replyid = "";
		String fbid = "";
		while(rs.next()){
			fbid = Util.null2String(rs.getString("id"));
			docids = Util.null2String(rs.getString("docids"));
			wfids = Util.null2String(rs.getString("wfids"));
			crmids = Util.null2String(rs.getString("crmids"));
			projectids = Util.null2String(rs.getString("projectids"));
			fileids = Util.null2String(rs.getString("fileids"));
			replyid = Util.null2String(rs.getString("replyid"));
			restr.append("<tr><td id='fbdata_"+fbid+"' class='data fbdata'><div class='feedbackshow'>"
					+"<div class='feedbackinfo'>"+cmutil.getPerson(rs.getString("hrmid"))+" "+rs.getString("createdate")+" "+rs.getString("createtime"));
			if(!viewdate.equals("") && !(user.getUID()+"").equals(rs.getString("hrmid")) && TimeUtil.timeInterval(viewdate,Util.null2String(rs.getString("createdate"))+" "+Util.null2String(rs.getString("createtime")))>0){
				restr.append("<font style='color: red;margin-left: 5px;font-style: italic;font-size: 11px;cursor: pointer;' title='新反馈'>new</font>");
			}
			restr.append("<div class='fboperate'>");
			restr.append(this.getDelOperate(fbid,rs.getString("hrmid"),userid,rs.getString("createdate"),rs.getString("createtime")));
			restr.append("<a href=\"javascript:doReply('"+fbid+"')\">回复</a></div>");
			restr.append("</div>");
			restr.append("<div class='feedbackrelate'>");
			restr.append("	<div>"+Util.convertDB2Input(Util.null2String(rs.getString("content")))+"</div>");
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
			restr.append("</div>");
			if(!replyid.equals("")){
				rs2.executeSql("select id,content,hrmid,docids,wfids,crmids,projectids,meetingids,fileids,createdate,createtime,replyid from TM_TaskFeedback where id="+replyid);
				if(rs2.next()){
					restr.append("<div class='fbreply'>");
					restr.append("<div class='feedbackinfo2'>@ "+cmutil.getHrm(rs2.getString("hrmid"))+" "+Util.null2String(rs2.getString("createdate"))+" "+Util.null2String(rs2.getString("createtime"))+"</div>");
					restr.append("<div class='feedbackrelate2'>");
					restr.append("<div>"+Util.null2String(rs2.getString("content"))+"</div>");
					if(!"".equals(rs2.getString("docids"))){
						restr.append("<div class='relatetitle2'>相关文档："+cmutil.getDocName(rs2.getString("docids"))+"</div>");
					}
					if(!"".equals(rs2.getString("wfids"))){
						restr.append("<div class='relatetitle2'>相关流程："+cmutil.getRequestName(rs2.getString("wfids"))+"</div>");
					}
					if(!"".equals(rs2.getString("crmids"))){
						restr.append("<div class='relatetitle2'>相关客户："+cmutil.getCustomer(rs2.getString("crmids"))+"</div>");
					} 
					if(!"".equals(rs2.getString("projectids"))){ 
						restr.append("<div class='relatetitle2'>相关项目："+cmutil.getProject(rs2.getString("projectids"))+"</div>");
					}
					if(!"".equals(rs2.getString("fileids"))){
						restr.append("<div class='relatetitle2'>相关附件："+this.getFileDoc(rs2.getString("fileids"),taskId,user)+"</div>");
					}
					restr.append("</div>");
					restr.append("</div>");
				}
			}
			restr.append("</div></td></tr>");
		}
	}
	//删除反馈
	if("del_feedback".equals(operation)){
		String taskId = Util.fromScreen3(request.getParameter("taskId"),user.getLanguage());
		if(this.getRight(taskId,user)<1) return;
		String fbid = Util.fromScreen3(request.getParameter("fbid"),user.getLanguage());
		rs.executeSql("select createdate,createtime,fileids from TM_TaskFeedback where hrmid="+userid+" and id="+fbid);
		if(rs.next()){
			String currentdate = TimeUtil.getCurrentDateString();
			String currenttime = TimeUtil.getOnlyCurrentTimeString();
			String createdate = Util.null2String(rs.getString("createdate"));
			String createtime = Util.null2String(rs.getString("createtime"));
			if(TimeUtil.timeInterval(createdate+" "+createtime,currentdate+" "+currenttime)/60<5){
				rs.executeSql("delete from TM_TaskFeedback where id="+fbid);
				//删除相关附件
				String fileids = Util.null2String(rs.getString("fileids"));
				List fileidList = Util.TokenizerString(fileids,",");
				int docid = 0;
				for(int i=0;i<fileidList.size();i++){
					docid = Util.getIntValue((String)fileidList.get(i),0);
					if(docid!=0){
						DocManager dm = new DocManager();
						dm.setId(docid);
						dm.setUserid(user.getUID());
						dm.DeleteDocInfo();
					}
				}
				restr.append(this.writeLog(user,13,taskId,"","",fn));
			}
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
		if(this.getRight(taskId,user)<1) return;
		int logcount = 0;
		String lastlogid = "";
		rs.executeSql("select count(*) from TM_TaskLog where taskid="+taskId);
		if(rs.next()){
			logcount = Util.getIntValue(rs.getString(1),0);
		}
		if(logcount>0){
			String ssql = "select top 5 id,type,operator,operatedate,operatetime,operatefiled,operatevalue from TM_TaskLog where taskid=" + taskId +" order by id desc";
			if(rs.getDBType().equals("oracle")){
				ssql = "select t.* from (select id,type,operator,operatedate,operatetime,operatefiled,operatevalue from TM_TaskLog where taskid=" + taskId +" order by id desc) t where rownum<6";
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
		String countsql = (String)request.getSession().getAttribute("TM_COUNT_SQL_"+_index);
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
		int dcount = 0;
		if(currentpage>1){
			rs.executeSql(countsql);
			if(rs.next()) dcount = total - rs.getInt(1);
		}
		if(rs.getDBType().equals("oracle")){
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
		String _principalid = "";
		String _createrid = "";
		int showallsub = 0;
		while(rs.next()){
			taskid = Util.null2String(rs.getString("id"));
			_principalid = Util.null2String(rs.getString("principalid"));
			_createrid = Util.null2String(rs.getString("creater"));
			if(_principalid.equals(userid) || _createrid.equals(userid)) canEdit = true; else canEdit = false;
			//right = cmutil.getRight(taskid,user);
			//if(right==2) canEdit = true; else canEdit = false;
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
			showallsub = Util.getIntValue(rs.getString("showallsub"),0);
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
					<div id='operate_<%=taskid %>' class='operatediv' _taskid='<%=taskid%>'>
						<%if(canEdit){ %>
							<div class='operatebtn item_del' onclick='quickDel(<%=taskid %>)'>删&nbsp;&nbsp;除</div>
						<%} %>
						<div class='operatebtn item_fb' onclick='quickfb(this)'>反&nbsp;&nbsp;馈</div>
						<div class='operatebtn item_att' _special='<%=special %>' title='<%if(special==0){%>添加关注<%}else{%>取消关注<%}%>'><%if(special==0){%>添加关注<%}else{%>取消关注<%}%></div>
						<%if(canEdit){ %>
							<div class='operatebtn item_status' _status='<%=_status%>' onclick='changestatus(this)' title='<%=statustitle%>'><%=statustitle%></div>
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
			
		<%if(sorttype==4){ %>
			<%=this.getSubTask(rs.getString("id"),user,6,showallsub) %>
		<%} %>
	<%
		} 
	}
	//标记或取消关注
	if("set_special".equals(operation)){
		String taskid = Util.fromScreen3(request.getParameter("taskid"),user.getLanguage());
		if(this.getRight(taskid,user)<1) return;
		int special = Util.getIntValue(request.getParameter("special"),0);
		//System.out.println(taskid+"-"+special);
		rs.executeSql("delete from TM_TaskSpecial where taskid="+taskid+" and userid="+user.getUID());
		if(special==0){
			rs.executeSql("insert into TM_TaskSpecial (taskid,userid) values("+taskid+","+user.getUID()+")");
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
		sql = 
				//创建
				"select count(t1.id) as amount from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null)"
				+" and t1.creater = "+userid+" and t1.status=1"
				+" and ("+func1+"((select "+createdt+" from TM_TaskFeedback t3 where t3.taskid=t1.id and t3.hrmid<>"+userid+"),'')"
				+">"+func1+"((select "+operatedt+" from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+"),''))"
				
				//负责
				+" union all"
				+" select count(t1.id) as amount from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null)"
				+" and t1.principalid = "+userid+" and t1.status=1"
				+" and ((not exists (select 1 from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+") and t1.creater<>"+userid+")"
				+"or "+func1+"((select "+createdt+" from TM_TaskFeedback t3 where t3.taskid=t1.id and t3.hrmid<>"+userid+"),'')"
				+">"+func1+"((select "+operatedt+" from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+"),''))"
				
				//参与
				+" union all"
				+" select count(t1.id) as amount from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null) and t1.status=1"
				+" and exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+")"
				+" and ((not exists (select 1 from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+") and t1.creater<>"+userid+")"
				+"or "+func1+"((select "+createdt+" from TM_TaskFeedback t3 where t3.taskid=t1.id and t3.hrmid<>"+userid+"),'')"
				+">"+func1+"((select "+operatedt+" from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+"),''))"
				
				//关注
				+" union all"
				+" select count(t1.id) as amount from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null) and t1.status=1"
				+" and exists (select 1 from TM_TaskSpecial special where special.taskid=t1.id and special.userid="+userid+")"
				+" and ((not exists (select 1 from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+") and t1.creater<>"+userid+")"
				+"or "+func1+"((select "+createdt+" from TM_TaskFeedback t3 where t3.taskid=t1.id and t3.hrmid<>"+userid+"),'')"
				+">"+func1+"((select "+operatedt+" from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+"),''))"
				
				//分享
				+" union all"
				+" select count(t1.id) as amount from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null) and t1.status=1"
				+" and exists (select 1 from TM_TaskSharer ts where ts.taskid=t1.id and ts.sharerid="+userid+")"
				+" and ((not exists (select 1 from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+") and t1.creater<>"+userid+")"
				+"or "+func1+"((select "+createdt+" from TM_TaskFeedback t3 where t3.taskid=t1.id and t3.hrmid<>"+userid+"),'')"
				+">"+func1+"((select "+operatedt+" from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+"),''))"
				
				//已完成新反馈
				+" union all"
				+" select count(t1.id) as amount from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null) and t1.status=2"
				+" and (t1.principalid="+user.getUID()+" or t1.creater="+user.getUID()
				+ " or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+user.getUID()+")"
				+ " or exists (select 1 from TM_TaskSharer ts where ts.taskid=t1.id and ts.sharerid="+user.getUID()+")"
				+ " or exists (select 1 from TM_TaskSpecial special where special.taskid=t1.id and special.userid="+userid+")"
				+ ")"
				+" and ("+func1+"((select "+createdt+" from TM_TaskFeedback t3 where t3.taskid=t1.id and t3.hrmid<>"+userid+"),'')"
				+">"+func1+"((select "+operatedt+" from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+"),''))"
				
				//我分配
				+" union all"
				+" select count(t1.id) as amount from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null) and t1.status=1"
				+" and t1.creater = "+userid+" and t1.principalid<>"+userid 
				+" and ("+func1+"((select "+createdt+" from TM_TaskFeedback t3 where t3.taskid=t1.id and t3.hrmid<>"+userid+"),'')"
				+">"+func1+"((select "+operatedt+" from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+"),''))"
				
				//负责和参与
				+" union all"
				+" select count(t1.id) as amount from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null)"
				+" and t1.status=1"
				+" and (t1.principalid = "+userid+" or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+"))"
				+" and ((not exists (select 1 from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+") and t1.creater<>"+userid+")"
				+"or "+func1+"((select "+createdt+" from TM_TaskFeedback t3 where t3.taskid=t1.id and t3.hrmid<>"+userid+"),'')"
				+">"+func1+"((select "+operatedt+" from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+"),''))"
				;
		
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
		//表示是否查看的是自己的最新反馈 0是 1否
		int ifMySelf = Util.getIntValue(request.getParameter("ifMySelf"),0);
		if(ifMySelf==1){//查看的是下属的
			String hrmid = Util.null2String(request.getParameter("hrmid"));
			if(hrmid.equals("")) hrmid = userid; 
			ResourceComInfo rc = new ResourceComInfo();
			if(rc.isManager(Util.getIntValue(userid),hrmid)){
				String sevenDay = TimeUtil.dateAdd(currentDate,-6);
				String querySql = "select t1.*,t2.id as taskid,t2.name from TM_TaskFeedback t1,TM_TaskInfo t2 "
				+" where t1.taskid=t2.id and (t2.deleted=0 or t2.deleted is null)  and t1.hrmid="+hrmid
				+" and t1.createdate>='"+sevenDay+"' and t1.createdate <= '"+currentDate+"'"
				+" order by t1.createdate desc,t1.createtime desc";
				//System.out.println(querySql);
				rs.executeSql(querySql);
				int count = rs.getCounts();
				if(count>0){
					HashMap<String,HashMap<String,List>> fbMap = new HashMap<String,HashMap<String,List>>();//反馈map
					while(rs.next()){
						String createdate = Util.null2String(rs.getString("createdate"));
						String createtime = Util.null2String(rs.getString("createtime"));
						int taskid = Util.getIntValue(rs.getString("taskid"));
						String taskName = Util.null2String(rs.getString("name"));
						String fbid =  Util.null2String(rs.getString("id"));
						String content = Util.null2String(rs.getString("content"));
						String docids = Util.null2String(rs.getString("docids"));
						String wfids = Util.null2String(rs.getString("wfids"));
						String crmids = Util.null2String(rs.getString("crmids"));
						String projectids = Util.null2String(rs.getString("projectids"));
						String meetingids = Util.null2String(rs.getString("meetingids"));
						String fileids = Util.null2String(rs.getString("fileids"));
						String replyid =  Util.null2String(rs.getString("replyid"));
						String[] fbArrays = {fbid,content,docids,wfids,crmids,projectids,meetingids,fileids,replyid,createtime};
						String taskIdName = taskid+"|"+taskName;
						if(fbMap.containsKey(createdate)){
							HashMap<String,List> taskMap = fbMap.get(createdate);
							if(null!=taskMap){
								if(taskMap.containsKey(taskIdName)){//包含了此任务
									List fbList = (List)taskMap.get(taskIdName);
									if(null!=fbList){
										fbList.add(fbArrays);
									}
								}else{//不包含任务，新建一个LIST，将反馈的内容作为一个数组对象放入list中，在把list作为value放入taskMap中
									List fbList = new ArrayList();
									fbList.add(fbArrays);
									taskMap.put(taskIdName,fbList);
								}
							}
						}else{
							HashMap<String,List> taskMap = new LinkedHashMap<String,List>();//任务map
							if(taskMap.containsKey(taskIdName)){//包含了此任务
								List fbList = (List)taskMap.get(taskIdName);
								if(null!=fbList){
									fbList.add(fbArrays);
								}
							}else{//不包含任务，新建一个LIST，将反馈的内容作为一个数组对象放入list中，在把list作为value放入taskMap中
								List fbList = new ArrayList();
								fbList.add(fbArrays);
								taskMap.put(taskIdName,fbList);
							}
							fbMap.put(createdate,taskMap);
						}
					}
					String[] weekDays = {"星期天","星期一","星期二","星期三","星期四","星期五","星期六"};
					for(int i=0;i>-7;i--){
						String createdate = TimeUtil.dateAdd(currentDate,i);
						String weekDay = "今天";
						if(i!=0){
							weekDay = weekDays[TimeUtil.dateWeekday(createdate)];
						}
						SimpleDateFormat sdf = new SimpleDateFormat("M月dd日");
				%>
					<tr>
						<td valign="top" width="70">
							<DIV class=dateArea><DIV class=day><%=weekDay %></DIV>
							<DIV class=yearAndMonth><%=sdf.format(TimeUtil.getString2Date(createdate,"yyyy-MM-dd")) %></DIV></DIV>
						</td>
					<%		
						if(fbMap.containsKey(createdate)){
					%>
						<td>
							<table class="datatable">
								
					<% 	
							HashMap<String,List> taskMap = fbMap.get(createdate);
							for(Map.Entry task:taskMap.entrySet()){
								String taskIdName = (String)task.getKey();
								String taskId = taskIdName.split("\\|")[0];
								String taskName = taskIdName.split("\\|")[1];
								List fbList = (List)task.getValue();
					%>
								<tr>
									<td>
										<div class="taskName" onclick="refreshDetail(<%=taskId %>)"><%=taskName %></div>
										<div class="taskFb">
											<%for(int j=0;j<fbList.size();j++){
												String[] fbArrays = (String[])fbList.get(j);
											%>
												<div class="feedbackrelate" style="margin-bottom:5px;">
													<div><%=fbArrays[1] %>&nbsp;&nbsp;<%=fbArrays[9] %></div>
													<%if(!"".equals(fbArrays[2])){ %>
													<div class="relatetitle">相关文档：<%=cmutil.getDocName(fbArrays[2]) %></div>
													<%} %>
													<%if(!"".equals(fbArrays[3])){ %>
													<div class="relatetitle">相关流程：<%=cmutil.getRequestName(fbArrays[3]) %></div>
													<%} %>
													<%if(!"".equals(fbArrays[4])){ %>
													<div class="relatetitle">相关客户：<%=cmutil.getCustomer(fbArrays[4]) %></div>
													<%} %>
													<%if(!"".equals(fbArrays[5])){ %>
													<div class="relatetitle">相关项目：<%=cmutil.getProject(fbArrays[5]) %></div>
													<%} %>
													<%if(!"".equals(fbArrays[7])){ %>
													<div class="relatetitle">相关附件：<%=this.getFileDoc(fbArrays[7],taskId,user) %></div>
													<%} %>
													<%
													  //读取回复信息
													  if(!fbArrays[8].equals("")){ 
														rs2.executeSql("select id,content,hrmid,docids,wfids,crmids,projectids,meetingids,fileids,createdate,createtime,replyid from TM_TaskFeedback where id="+fbArrays[8]);
														if(rs2.next()){
													%>
													<div class="fbreply">
														<div class="feedbackinfo2">@ <%=cmutil.getHrm(rs2.getString("hrmid")) %> <%=Util.null2String(rs2.getString("createdate")) %> <%=Util.null2String(rs2.getString("createtime")) %></div>
														<div class="feedbackrelate2">
															<div><%=Util.null2String(rs2.getString("content")) %></div>
															<%if(!"".equals(rs2.getString("docids"))){ %>
															<div class="relatetitle2">相关文档：<%=cmutil.getDocName(rs2.getString("docids")) %></div>
															<%} %>
															<%if(!"".equals(rs2.getString("wfids"))){ %>
															<div class="relatetitle2">相关流程：<%=cmutil.getRequestName(rs2.getString("wfids")) %></div>
															<%} %>
															<%if(!"".equals(rs2.getString("crmids"))){ %>
															<div class="relatetitle2">相关客户：<%=cmutil.getCustomer(rs2.getString("crmids")) %></div>
															<%} %>
															<%if(!"".equals(rs2.getString("projectids"))){ %>
															<div class="relatetitle2">相关项目：<%=cmutil.getProject(rs2.getString("projectids")) %></div>
															<%} %>
															<%if(!"".equals(rs2.getString("fileids"))){ %>
															<div class="relatetitle2">相关附件：<%=this.getFileDoc(rs2.getString("fileids"),Util.null2String(rs.getString("taskid")),user) %></div>
															<%} %>
														</div>
													</div>
													<%	} }%>
												</div>
											<%} %>
										</div>
									</td>
								</tr>
								<% } %>	
							</table>
						</td>
					<%}else{%>	
						<td><span class="spanTips">当日暂无反馈记录!</span></td>
					<%}%>
					</tr>
					<%	
					}
				}else{
					out.print("<tr><td><span class='spanTips'>一周内暂无最新反馈记录</span></td></tr>");
				}
			}else{
				out.print("您没有查看权限");
			}
		}else if(ifMySelf==0){
			String orderby1 = " order by createdate desc,createtime desc";
			String orderby2 = " order by createdate asc,createtime asc";
			String orderby3 = " order by t1.createdate desc,t1.createtime desc";
			int currentpage = Util.getIntValue(request.getParameter("currentpage"),0);
			int pagesize = Util.getIntValue(request.getParameter("pagesize"),0);
			int total = Util.getIntValue(request.getParameter("total"),0);
			//String querysql = Util.null2String(URLDecoder.decode(request.getParameter("querysql"),"utf-8"));//.replaceAll("t3.createdate ' ' t3.createtime","t3.createdate+' '+t3.createtime").replaceAll("t2.operatedate ' ' t2.operatetime","t2.operatedate+' '+t2.operatetime");
			String querysql = " t1.id,t1.content,t1.hrmid,t1.docids,t1.wfids,t1.crmids,t1.projectids,t1.meetingids,t1.fileids,t1.createdate,t1.createtime,t2.id as taskid,t2.name,t1.replyid "
				+",(select "+operatedt+" from TM_TaskLog tlog where tlog.taskid=t2.id and tlog.type=0 and tlog.operator="+userid+") as lastviewdate"
				+" from TM_TaskFeedback t1,TM_TaskInfo t2 "
				+" where t1.taskid=t2.id and (t2.deleted=0 or t2.deleted is null)"
				+" and (t2.creater="+userid+" or t2.principalid="+userid
				+" or exists (select 1 from TM_TaskPartner tp where tp.taskid=t2.id and tp.partnerid="+userid+")"
				+" or exists (select 1 from TM_TaskSharer ts where ts.taskid=t2.id and ts.sharerid="+userid+"))"
				+" and t1.hrmid<>"+userid;
			/**
			if(rs.getDBType().equals("oracle")){
				querysql = " t1.id,t1.content,t1.hrmid,t1.docids,t1.wfids,t1.crmids,t1.projectids,t1.meetingids,t1.fileids,t1.createdate,t1.createtime,t2.id as taskid,t2.name,t1.replyid "
						+",(select v.lastviewdate from (select (operatedate+' '+tlog.operatetime) as lastviewdate,taskid from TM_TaskLog where type=0 and operator="+userid+" order by operatedate desc,operatetime desc) v where v.taskid=t2.id and v.rownum=1) as lastviewdate"
						+" from TM_TaskFeedback t1,TM_TaskInfo t2 "
						+" where t1.taskid=t2.id and (t2.deleted=0 or t2.deleted is null)"
						+" and (t2.creater="+userid+" or t2.principalid="+userid+" or exists (select 1 from TM_TaskPartner tp where tp.taskid=t2.id and tp.partnerid="+userid+"))"
						+" and t1.hrmid<>"+userid;
			}*/
			int iTotal =total; 
			int iNextNum = currentpage * pagesize;
			int ipageset = pagesize;
			if(iTotal - iNextNum + pagesize < pagesize) ipageset = iTotal - iNextNum + pagesize;
			if(iTotal < pagesize) ipageset = iTotal;
			if(rs.getDBType().equals("oracle")){
				sql = "select " + querysql+ orderby3;
				sql = "select A.*,rownum rn from (" + sql + ") A where rownum <= " + (iNextNum);
				sql = "select B.* from (" + sql + ") B where rn > " + (iNextNum - pagesize);
			}else{
				sql = "select top " + ipageset +" A.* from (select top "+ iNextNum + querysql+ orderby3 + ") A "+orderby2;
				sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderby1;
			}
			//System.out.println(total+"---"+sql);
			boolean isnew  = false;
			String lastviewdate = "";
			String createdate = "";
			String replyid = "";
			rs.executeSql(sql);
			while(rs.next()){
				lastviewdate = Util.null2String(rs.getString("lastviewdate"));
				createdate = Util.null2String(rs.getString("createdate"))+" "+Util.null2String(rs.getString("createtime"));
				//System.out.println(lastviewdate+"-"+createdate);
				if(TimeUtil.timeInterval(lastviewdate,createdate)>0) isnew = true; else isnew = false;
				replyid = Util.null2String(rs.getString("replyid"));
	%>
	<tr>
		<td class="data">
			<div class="feedbackshow">
				<div class="feedbackinfo" style="font-weight: bold;"><a href="javascript:refreshDetail(<%=Util.null2String(rs.getString("taskid")) %>)"><%=Util.null2String(rs.getString("name")) %></a></div>
				<div class="feedbackinfo"><%=cmutil.getHrm(rs.getString("hrmid")) %> <%=Util.null2String(rs.getString("createdate")) %> <%=Util.null2String(rs.getString("createtime")) %>
				<%if(isnew){ %><font style='color: red;margin-left: 5px;font-style: italic;font-size: 11px;cursor: pointer;' title='新反馈'>new</font><%} %>
				</div>
				<div class="feedbackrelate">
					<div><%=Util.null2String(rs.getString("content")) %></div>
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
					<div class="relatetitle">相关附件：<%=this.getFileDoc(rs.getString("fileids"),Util.null2String(rs.getString("taskid")),user) %></div>
					<%} %>
				</div>
				<%
				  //读取回复信息
				  if(!replyid.equals("")){ 
					rs2.executeSql("select id,content,hrmid,docids,wfids,crmids,projectids,meetingids,fileids,createdate,createtime,replyid from TM_TaskFeedback where id="+replyid);
					if(rs2.next()){
				%>
				<div class="fbreply">
					<div class="feedbackinfo2">@ <%=cmutil.getHrm(rs2.getString("hrmid")) %> <%=Util.null2String(rs2.getString("createdate")) %> <%=Util.null2String(rs2.getString("createtime")) %></div>
					<div class="feedbackrelate2">
						<div><%=Util.null2String(rs2.getString("content")) %></div>
						<%if(!"".equals(rs2.getString("docids"))){ %>
						<div class="relatetitle2">相关文档：<%=cmutil.getDocName(rs2.getString("docids")) %></div>
						<%} %>
						<%if(!"".equals(rs2.getString("wfids"))){ %>
						<div class="relatetitle2">相关流程：<%=cmutil.getRequestName(rs2.getString("wfids")) %></div>
						<%} %>
						<%if(!"".equals(rs2.getString("crmids"))){ %>
						<div class="relatetitle2">相关客户：<%=cmutil.getCustomer(rs2.getString("crmids")) %></div>
						<%} %>
						<%if(!"".equals(rs2.getString("projectids"))){ %>
						<div class="relatetitle2">相关项目：<%=cmutil.getProject(rs2.getString("projectids")) %></div>
						<%} %>
						<%if(!"".equals(rs2.getString("fileids"))){ %>
						<div class="relatetitle2">相关附件：<%=this.getFileDoc(rs2.getString("fileids"),Util.null2String(rs.getString("taskid")),user) %></div>
						<%} %>
					</div>
				</div>
				<%	} %>
				<%} %>							  
			</div>
		</td>
	</tr>
	<%}}
	}
	//读取更多任务单独列表数据
	if("get_more_list".equals(operation)){
		String orderby1 = " order by lastoperatedate desc";
		String orderby2 = " order by lastoperatedate asc";
		String orderby3 = " order by lastoperatedate desc";
		int currentpage = Util.getIntValue(request.getParameter("currentpage"),0);
		int pagesize = Util.getIntValue(request.getParameter("pagesize"),0);
		int total = Util.getIntValue(request.getParameter("total"),0);
		//String querysql = Util.null2String(URLDecoder.decode(request.getParameter("querysql"),"utf-8"));//.replaceAll("t3.createdate ' ' t3.createtime","t3.createdate+' '+t3.createtime").replaceAll("t2.operatedate ' ' t2.operatetime","t2.operatedate+' '+t2.operatetime");
		StringBuffer querysql = new StringBuffer();
		querysql.append(" t1.id,t1.name,t1.status,t1.creater,t1.principalid,t1.lev,t1.begindate,t1.enddate,t1.createdate,t1.createtime,t1.showallsub "
				+",(select count(tfb.id) from TM_TaskFeedback tfb where tfb.taskid=t1.id) as fbcount"
				+",(select "+operatedt+" from TM_TaskLog tlog where tlog.taskid=t1.id and tlog.type=0 and tlog.operator="+userid+") as lastviewdate"
				+",(select "+createdt+" from TM_TaskFeedback fb where fb.taskid=t1.id and fb.hrmid<>"+userid+") as lastfbdate"
				+","+func1+"((select distinct 1 from TM_TaskSpecial tts where tts.taskid=t1.id and tts.userid="+userid+"),0) as special"
				+",(select tt.tododate from TM_TaskTodo tt where tt.taskid=t1.id and tt.userid="+userid+") as tododate"
				+",(select "+operatedt+" from TM_TaskLog tlog where tlog.taskid=t1.id and tlog.type not in (0,11,12)) as lastoperatedate"
				+" from TM_TaskInfo t1 "
				+" where (t1.deleted=0 or t1.deleted is null)"
				+" and (t1.principalid="+userid+" or t1.creater="+userid
				+" or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+")"
				+" or exists (select 1 from TM_TaskSharer ts where ts.taskid=t1.id and ts.sharerid="+userid+")"
				+" or exists (select 1 from HrmResource hrm where (hrm.id=t1.principalid or hrm.id=t1.creater) and hrm.managerstr like '%,"+userid+",%')"
				+" or exists (select 1 from HrmResource hrm,TM_TaskPartner tp where tp.taskid=t1.id and hrm.id=tp.partnerid and hrm.managerstr like '%,"+userid+",%')"
				+")");
		String requestid = Util.null2String(request.getParameter("requestid"));
		String docid = Util.null2String(request.getParameter("docid"));
		String crmid = Util.null2String(request.getParameter("crmid"));
		if(!requestid.equals("")){
			querysql.append(" and t1.wfids like '%,"+requestid+",%'");
		}else if(!docid.equals("")){
			querysql.append(" and t1.docids like '%,"+docid+",%'");
		}else if(!crmid.equals("")){
			querysql.append(" and t1.crmids like '%,"+crmid+",%'");
		}
		
		int iTotal =total; 
		int iNextNum = currentpage * pagesize;
		int ipageset = pagesize;
		if(iTotal - iNextNum + pagesize < pagesize) ipageset = iTotal - iNextNum + pagesize;
		if(iTotal < pagesize) ipageset = iTotal;
		if(rs.getDBType().equals("oracle")){
			sql = "select " + querysql+ orderby3;
			sql = "select A.*,rownum rn from (" + sql + ") A where rownum <= " + (iNextNum);
			sql = "select B.* from (" + sql + ") B where rn > " + (iNextNum - pagesize);
		}else{
			sql = "select top " + ipageset +" A.* from (select top "+ iNextNum + querysql.toString()+ orderby3 + ") A "+orderby2;
			sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderby1;
		}
		//System.out.println(total+"---"+sql);
		String createdate = "";
		String taskid = "";
		int status = 0; 
		int fbcount = 0;//反馈数
		boolean noreadfb = false;//是否有未读反馈
		boolean isnew = false;//最后未查看
		int special = 0;//是否标记为重要
		String lastviewdate = "";
		String lastfbdate = "";
		String creater = "";
		String enddate = "";
		rs.executeSql(sql);
		while(rs.next()){
			lastviewdate = Util.null2String(rs.getString("lastviewdate"));
			createdate = Util.null2String(rs.getString("createdate"))+" "+Util.null2String(rs.getString("createtime"));
			if(TimeUtil.timeInterval(lastviewdate,createdate)>0) isnew = true; else isnew = false;
			taskid = Util.null2String(rs.getString("id"));
			status = Util.getIntValue(rs.getString("status"),1);
			enddate = Util.null2String(rs.getString("enddate"));
			fbcount = Util.getIntValue(rs.getString("fbcount"),0);
			special = Util.getIntValue(rs.getString("special"),0);
			
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
%>
			<tr id="item_tr_<%=taskid%>" class="item_tr">
				<td class="index"></td>
				<td>
					<div class="status status<%=status%>">&nbsp;</div>
				</td>
				<td class='item_td'>
					<div class="disinput <%if(isnew){%>newinput<%}%>" title="<%=Util.null2String(rs.getString("name")) %>" 
						onclick="showTask(<%=taskid %>)">
						<%=Util.null2String(rs.getString("name")) %>
					</div>
				</td>
				<td class='item_count <%if(noreadfb){%>item_count_new<%}%>' _fbcount="<%=fbcount %>" <%if(noreadfb){%>title='有新反馈'<%}else if(fbcount>0){%>title='<%=fbcount %>条反馈'<%}%>>
					<%if(fbcount>0){%>(<%=fbcount %>)<%}else{%>&nbsp;<%}%>
				</td>
				<td style="text-align: center;">
					<div id="enddate_<%=taskid %>" class="div_enddate" title='到期日：<%=enddate%>'><%=this.convertdate(enddate) %></div>
				</td>
				<td class='item_hrm' title='责任人'><%=cmutil.getHrm(rs.getString("principalid")) %></td>
			</tr>
<%	
		}
	}
	
	//微信提醒
	if("wechatremind".equals(operation)){
		if(Util.null2String(Prop.getPropValue("wechatapi", "ifuse")).equals("1")){
			List userlist = new ArrayList();
			String taskid = Util.null2String(request.getParameter("taskId"));
			rs.executeSql("select name,principalid from TM_TaskInfo where id="+taskid+" and creater="+userid);
			if(rs.next()){
				String taskname = Util.null2String(rs.getString("name"));
				String principalid = Util.null2String(rs.getString("principalid"));
				if(!principalid.equals(userid) && !principalid.equals("")) userlist.add(principalid);
				rs.executeSql("select partnerid from  TM_TaskPartner where taskid="+taskid);
				String partnerid = "";
				while(rs.next()){
					partnerid = Util.null2String(rs.getString(1));
					if(!partnerid.equals(userid) && !partnerid.equals("")) userlist.add(partnerid);
				}
				String msg = "";
				if(userlist.size()>0){
					String content = "新任务："+taskname+" 创建人："+user.getUsername();
					weaver.wechat.WechatIFService ws = new weaver.wechat.WechatIFService(userlist,content,false);
					String returnstr = ws.deal();
					if(!returnstr.equals("")){
						msg = "成功";
					}else{
						msg = "失败";
					}
				}else{
					msg = "无接收人";
				}
				restr.append(this.writeLog(user,14,taskid,"",msg,fn));
			}
		}
	}
	
	out.print(restr.toString());
	//out.close();
%>
<%!
	/**
	* type  0:查看 1:新建  2:编辑内容  3:新增内容  4:删除内容 5:进行 6:完成  7:撤销  8:删除 9:上传 10:反馈 11:标记 12:关注 13:删除反馈 14:微信提醒
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
			case 2:logtxt+="更新"+Util.null2String((String)fn.get(field))+"为&nbsp;&nbsp;"+valtxt;break;
			case 3:logtxt+="添加"+Util.null2String((String)fn.get(field))+"&nbsp;&nbsp;"+valtxt;break;
			case 4:logtxt+="删除"+Util.null2String((String)fn.get(field))+"&nbsp;&nbsp;"+valtxt;break;
			case 5:logtxt+="设置为进行中";break;
			case 6:logtxt+="设置为完成";break;
			case 7:logtxt+="设置为撤销";break;
			case 8:logtxt+="删除任务";break;
			case 9:logtxt+="上传"+Util.null2String((String)fn.get(field))+"&nbsp;&nbsp;"+valtxt;break;
			case 10:logtxt+="反馈任务";break;
			case 11:logtxt+=this.getTodoLog(value);break;
			case 12:logtxt+=this.getSpecialLog(value);break;
			case 13:logtxt+="删除反馈";break;
			case 14:logtxt+="微信提醒-"+value;break;
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
		}else if("taskids".equals(field) || "parentid".equals(field)){
			return cmutil.getTaskName(value);
		}else if("fileids".equals(field)){
			return value;
		}else if("level".equals(field)){
			if("1".equals(value)) return "重要紧急";
			if("2".equals(value)) return "重要不紧急";
			if("3".equals(value)) return "不重要紧急";
			if("4".equals(value)) return "不重要不紧急";
			return "";
		}else if("showallsub".equals(field)){
			if("1".equals(value)) return "是";
			if("0".equals(value)) return "否";
			return "";
		}else{
			return value;
		}
	}
	public String getFileDoc(String ids,String taskId,User user) throws Exception{
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
		            returnstr += "<a href=javaScript:openFullWindowHaveBar('/workrelate/task/util/ViewDoc.jsp?id="+docid+"&taskId="+taskId+"') >"+docImagefilename+"</a>";
		            returnstr += "&nbsp;<a href='/workrelate/task/util/ViewDoc.jsp?id="+docid+"&taskId="+taskId+"&fileid="+docImagefileid+"'>下载("+docImagefileSize/1000+"K)</a>";
		            returnstr += "&nbsp;"+ weaver.workrelate.util.TransUtil.getReviewLink(docImagefilename, docImagefileid, user.getLanguage(), user,3,docid,taskId,"")+"&nbsp;&nbsp;";
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
		rs.executeSql("select principalid,parentid from TM_TaskInfo where parentid<>0 and parentid is not null and (deleted=0 or deleted is null) and id="+taskid);
		if(rs.next()){
			parentid = Util.null2String(rs.getString("parentid"));
			if(!parentid.equals("")){
				hrmids.add(Util.null2String(rs.getString("principalid")));
				rs.executeSql("select principalid from TM_TaskInfo where (deleted=0 or deleted is null) and id="+parentid);
				if(rs.next()){
					parentPrincipalid = Util.null2String(rs.getString("principalid"));
					String partnerid = "";
					rs.executeSql("select partnerid from TM_TaskPartner where taskid="+taskid);
					while(rs.next()){
						partnerid = Util.null2String(rs.getString("partnerid"));
						if(!partnerid.equals("") && !partnerid.equals(parentPrincipalid) && hrmids.indexOf(partnerid)<0){
							hrmids.add(partnerid);
						}
					}
					for(int i=0;i<hrmids.size();i++){
						partnerid = (String)hrmids.get(i);
						if(!partnerid.equals("")){
							rs.executeSql("delete from TM_TaskPartner where taskid="+parentid+" and partnerid="+partnerid);
							rs.executeSql("insert into TM_TaskPartner (taskid,partnerid) values('"+parentid+"','"+partnerid+"')");
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
	/**
	 * 取得某人对某人任务具有的权限
	 * @param taskid
	 * @param user
	 * @return
	 */
	 private int getRight(String taskid,User user) throws Exception{
		if(taskid == null || "".equals(taskid)){
			return 0;
		}
		int level = 0;
		RecordSet rs = new RecordSet();
		rs.executeSql("select t1.creater,t1.principalid from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null) "
				+ " and (t1.principalid="+user.getUID()+" or t1.creater="+user.getUID()
				+ " or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+user.getUID()+")"
				+ " or exists (select 1 from TM_TaskSharer ts where ts.taskid=t1.id and ts.sharerid="+user.getUID()+")"
				+ " or exists (select 1 from HrmResource hrm where (hrm.id=t1.principalid or hrm.id=t1.creater) and hrm.managerstr like '%,"+user.getUID()+",%')"
				+ " or exists (select 1 from HrmResource hrm,TM_TaskPartner tp where tp.taskid=t1.id and hrm.id=tp.partnerid and hrm.managerstr like '%,"+user.getUID()+",%')"
				+ ") and t1.id="+taskid);
		if(rs.next()){
			level = 1;
			if(Util.getIntValue(rs.getString("principalid"),0)==user.getUID() || Util.getIntValue(rs.getString("creater"),0)==user.getUID()){
				level = 2;
			}
		}
		if(level==0){
			String parentid = this.getParentid(taskid);
			if(!parentid.equals("")){
				rs.executeSql("select showallsub from TM_TaskInfo where id="+parentid);
				if(rs.next()){
					int showallsub = Util.getIntValue(rs.getString(1));
					if(showallsub==1){
						int plevel = this.getRight(parentid,user);
						if(plevel>0) level = 1;
					}
				}
			}
		}
		return level;
	}
	 public String getParentid(String taskid) throws Exception{
		RecordSet rs = new RecordSet();
		rs.executeSql("select parentid from TM_TaskInfo where parentid is not null and parentid<>0 and id="+taskid);
		if(rs.next()){
			taskid = Util.null2String(rs.getString(1));
			if(!taskid.equals("")) taskid = this.getParentid(taskid);
		}
		return taskid;
	}
	private String getDelOperate(String fbid,String hrmid,String userid,String createdate,String createtime){
		String returnstr = "";
		String currentdate = TimeUtil.getCurrentDateString();
		String currenttime = TimeUtil.getOnlyCurrentTimeString();
		long interval = TimeUtil.timeInterval(createdate+" "+createtime,currentdate+" "+currenttime)/60;
		if(hrmid.equals(userid) && interval<5){
			returnstr = "<a href=\"javascript:doDelFB('"+fbid+"')\">删除</a>&nbsp;&nbsp;";
		}
		return returnstr;
	}	 
	public String getSubTask(String maintaskid,User user,int colspan,int showallsub) throws Exception{
		String userid = user.getUID()+"";
		StringBuffer res = new StringBuffer();
		RecordSet rs = new RecordSet();
		String func1 = "";
		String operatedt = "";
		String createdt = "";
		if(!rs.getDBType().equals("oracle")){
			func1 = "isnull";
			operatedt = "max(operatedate+' '+operatetime)";
			createdt = "max(createdate+' '+createtime)";
		}else{
			func1 = "nvl";
			operatedt = "max(CONCAT(CONCAT(operatedate,' '),operatetime))";
			createdt = "max(CONCAT(CONCAT(createdate,' '),createtime))";
		}
		//CommonTransUtil cmutil = new CommonTransUtil();
		StringBuffer basesql = new StringBuffer();
		basesql.append("select t1.id,t1.name,t1.status,t1.creater,t1.principalid,t1.lev,t1.begindate,t1.enddate,t1.createdate,t1.createtime "
				+",(select count(tfb.id) from TM_TaskFeedback tfb where tfb.taskid=t1.id) as fbcount"
				+",(select "+operatedt+" from TM_TaskLog tlog where tlog.taskid=t1.id and tlog.type=0 and tlog.operator="+userid+") as lastviewdate"
				+",(select "+createdt+" from TM_TaskFeedback fb where fb.taskid=t1.id and fb.hrmid<>"+userid+") as lastfbdate"
				+","+func1+"((select distinct 1 from TM_TaskSpecial tts where tts.taskid=t1.id and tts.userid="+userid+"),0) as special"
				+" from TM_TaskInfo t1 "
				+" where (t1.deleted=0 or t1.deleted is null) and t1.parentid="+maintaskid)
				;
		
		if(showallsub==0){
			basesql.append(" and (t1.principalid="+userid+" or t1.creater="+userid
				+ " or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+")"
				+ " or exists (select 1 from TM_TaskSharer ts where ts.taskid=t1.id and ts.sharerid="+userid+")"
				+ " or exists (select 1 from HrmResource hrm where (hrm.id=t1.principalid or hrm.id=t1.creater) and hrm.managerstr like '%,"+userid+",%')"
				+ " or exists (select 1 from HrmResource hrm,TM_TaskPartner tp where tp.taskid=t1.id and hrm.id=tp.partnerid and hrm.managerstr like '%,"+userid+",%')"
				+ ")");
		}
		//basesql.append(" order by lastoperatedate desc");
		basesql.append(" order by t1.enddate,t1.id");
		rs.executeSql(basesql.toString());
		//if(rs.getCounts()>0){
			res.append("<tr class='subtable_tr'>"+(colspan==6?"<td class='td_blank' style='padding:0px;border:0px;height:auto'></td>":"")+"<td colspan='"+(colspan==6?colspan-1:colspan)+"' style='padding:0px;padding-left:20px;border:0px;height:auto'><table class='subdatalist' cellpadding='0' cellspacing='0' border='0' align='center'>"
				+"<colgroup><col width='20px'/><col width='*'/><col width='22px'/><col width='44px'/><col width='44px'/></colgroup>");
			String statustitle = "";
			int _status = 0;
			boolean canEdit = true;
			int right = 0;
			int index = 0;
			String enddate = "";
			
			int fbcount = 0;//反馈数
			boolean noreadfb = false;//是否有未读反馈
			boolean isnew = false;//最后未查看
			int special = 0;//是否标记为重要
			String specialname = "";
			String lastviewdate = "";
			String lastfbdate = "";
			String creater = "";
			String taskid = "";
			String tododate = "";
			int todotype = 4;
			String todoname = "";
			String currentdate = TimeUtil.getCurrentDateString();
			String _principalid = "";
			String _createrid = "";
			while(rs.next()){
				taskid = Util.null2String(rs.getString("id"));
				_principalid = Util.null2String(rs.getString("principalid"));
				_createrid = Util.null2String(rs.getString("creater"));
				if(_principalid.equals(userid) || _createrid.equals(userid)) canEdit = true; else canEdit = false;
				//right = cmutil.getRight(taskid,user);
				//if(right==2) canEdit = true; else canEdit = false;
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
				enddate = Util.null2String(rs.getString("enddate"));
				fbcount = Util.getIntValue(rs.getString("fbcount"),0);
				special = Util.getIntValue(rs.getString("special"),0);
				if(special==0){
					specialname = "添加关注";
				}else{
					specialname = "取消关注";
				}
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
					if(TimeUtil.dateInterval(tododate,currentdate)>=0){
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
				
				res.append("<tr id='item_tr_"+taskid+"' class='item_tr' _taskid='"+taskid+"'>");
				//res.append("<td class='' "+(!canEdit?"title='无权限编辑'":"")+"><div>&nbsp;</div></td>");
				res.append("<td width='20px' class='td_status'><div id=\"status_"+taskid+"\" class=\"status status"+_status+"\">&nbsp;</div>");
				res.append("<div id='todo_"+taskid+"' class='"+((_status==1 || _status==0)?"div_todo":"")+"'  onclick='showTodo2(this)'"
						+" title='"+todoname+"' _val='"+todotype+"' _taskid='"+taskid+"'></div></td>");
				res.append("<td class='item_td'><input "+(!canEdit?" readonly='readonly'":"")+" onfocus=\"doClickItem(this)\" onblur='doBlurItem(this)' class=\"disinput "+(isnew?"newinput":"")+"\" type=\"text\" name=\"\" id=\""+taskid+"\" _pid=\""+maintaskid+"\" title=\""+Util.null2String(rs.getString("name"))+"\" value=\""+Util.null2String(rs.getString("name"))+"\" _index=\""+(index++)+"\"/></td>");
				res.append("<td class='item_count "+(noreadfb?"item_count_new":"")+"' _fbcount=\""+fbcount+"\" ");
				if(noreadfb){
					res.append("title='有新反馈'");
				}else if(fbcount>0){
					res.append("title='"+fbcount+"条反馈'");
				}
				res.append(">"+(fbcount>0?"("+fbcount+")":"&nbsp;")+"</td>");
				res.append("<td style='text-align: center;'>");
				res.append("<div id='enddate_"+taskid+"' class='div_enddate' title='"+enddate+"'>"+this.convertdate(enddate)+"</div>");
				res.append("</td>");
				//res.append("<td><div id=\"today_"+rs.getString("id")+"\" class=\"div_today\" "+(isToday?"title='今天的任务'":"")+" >"+(isToday?"今天":"&nbsp;")+"</div></td>");
				res.append("<td class='item_hrm' title='责任人'>"+this.getHrmLink(rs.getString("principalid"))+"</td>");
				res.append("</tr>");
				res.append("<div id='operate_"+taskid+"' class='operatediv' _taskid='"+taskid+"'>");
				if(canEdit){
					res.append("<div class='operatebtn item_del' onclick='quickDel("+taskid+")'>删&nbsp;&nbsp;除</div>");
				}
				res.append("<div class='operatebtn item_fb' onclick='quickfb(this)'>反&nbsp;&nbsp;馈</div>");
				res.append("<div class='operatebtn item_att' _special='"+special+"' title='"+specialname+"'>"+specialname+"</div>");
				if(canEdit){
					res.append("<div class='operatebtn item_status' _status='"+_status+"' onclick='changestatus(this)' title='"+statustitle+"'>"+statustitle+"</div>");
				}
				res.append("</div>");
				res.append(this.getSubTask(taskid,user,5,showallsub));
			}
			res.append("</table></td></tr>");
		//}
		
		return res.toString();
	}
	
	private String transRelateid(String ids) throws Exception{
		String relateids = Util.null2String(ids);
		if(relateids.equals(",")) relateids = "";
		if(!relateids.equals("")){
			if(!relateids.startsWith(",")) relateids = "," + relateids;
			if(!relateids.endsWith(",")) relateids += ",";
		}
		return relateids;
	}
%>
