
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.task.TaskUtil"%>
<%@page import="weaver.general.TimeUtil"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ShareManager" class="weaver.share.ShareManager" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="cmutil" class="weaver.task.CommonTransUtil" scope="page"/>
<jsp:useBean id="taskUtil" class="weaver.task.TaskUtil" scope="page"/>
<%
int rows = 5;
String userid = user.getUID()+"";
String temptable = "";
String usertype="0";
if(user.getLogintype().equals("2")) usertype="1";
String json = "";
String key_word = Util.null2String(request.getParameter("key_word"));
String searchtype = Util.null2String(request.getParameter("searchtype"));
String iscreate = Util.null2String(request.getParameter("iscreate"));  //没有结果时是否显示创建
StringBuffer sql = new StringBuffer();
String sqlWhere = "";
String sqlWhere2 = "";
if(!key_word.equals("")){
	if(key_word.indexOf("+")>0){
		String[] ands = key_word.split("\\+");
		if(ands.length>0){
			sqlWhere += " ( ";
			sqlWhere2 += " ( ";
			for(int i=0;i<ands.length;i++){
				if(i == 0){
					sqlWhere += " #### like '%" + ands[i] + "%'";
					sqlWhere2 += " #### like '%," + ands[i] + ",%'";
				}else{
					sqlWhere += " and  #### like '%" + ands[i] + "%'";
					sqlWhere2 += " and  #### like '%," + ands[i] + ",%'";
				}
			}
			sqlWhere += " ) ";
			sqlWhere2 += " ) ";
		}
	}else{
		String[] ors = key_word.split(" ");
		if(ors.length>0){
			sqlWhere += " ( ";
			sqlWhere2 += " ( ";
			for(int i=0;i<ors.length;i++){
				if(i == 0){
					sqlWhere += " #### like '%" + ors[i] + "%'";
					sqlWhere2 += " #### like '%," + ors[i] + ",%'";
				}else{
					sqlWhere += " or  #### like '%" + ors[i] + "%'";
					sqlWhere2 += " or  #### like '%," + ors[i] + ",%'";
				}
			}
			sqlWhere += " ) ";
			sqlWhere2 += " ) ";
		}
	}
	
	String backfields="";
	String fromsql="";
	if(searchtype.equals("hrm")){ 
		
		backfields="id,lastname";
		fromsql="HrmResource where (status =0 or status = 1 or status = 2 or status = 3) and ("+sqlWhere.replaceAll("####","lastname")+" or "+sqlWhere.replaceAll("####","pinyinlastname")+") order by dsporder";
		sql.append(taskUtil.getTopSql(backfields,fromsql,rows,rs));
		
	}else if(searchtype.equals("doc")){
		
		backfields="id,docsubject";	
		fromsql=" DocDetail  t1," + ShareManager.getShareDetailTableByUser("doc", user) + " t2 "
		+"where (ishistory is null or ishistory = 0) and  ( ( t1.docstatus = 7 and  (sharelevel>1)) or t1.docstatus in ('1','2','5')) "
		+"and "+sqlWhere.replaceAll("####","docsubject")+" and maincategory!=0  and subcategory!=0 and seccategory!=0 and t1.id=t2.sourceid order by doclastmoddate desc,doclastmodtime desc,id desc";
		sql.append(taskUtil.getTopSql(backfields,fromsql,rows,rs));
		
	}else if(searchtype.equals("wf")){
		
		backfields="workflow_requestbase.requestid ,workflow_requestbase.requestname";
		fromsql=" workflow_requestbase , workflow_currentoperator , workflow_base "
			+"where "+sqlWhere.replaceAll("####","requestname")
			+" and (workflow_requestbase.currentstatus is null or (workflow_requestbase.currentstatus=0 and workflow_requestbase.creater="+user.getUID()+")) "
			+"and workflow_currentoperator.requestid = workflow_requestbase.requestid and workflow_currentoperator.userid=" +userid + " and workflow_currentoperator.usertype="+usertype+" and workflow_requestbase.workflowid = workflow_base.id and (workflow_base.isvalid='1' or workflow_base.isvalid='3') order by createdate desc , createtime desc";
		sql.append(taskUtil.getTopSql(backfields,fromsql,rows,rs));
		
	}else if(searchtype.equals("crm")){
		String condition = "";
		//找到用户能看到的所有客户
		//如果属于总部级的CRM管理员角色，则能查看到所有客户。
		rs.executeSql("select id from HrmRoleMembers where  roleid = 8 and rolelevel = 2 and resourceid = " + userid);
		if (rs.next()) {
			backfields="id,name";
			fromsql=" CRM_CustomerInfo where (deleted=0 or deleted is null) and "+sqlWhere.replaceAll("####","name")+" order by createdate desc,id desc";
		} else {
			String leftjointable = CrmShareBase.getTempTable(userid);
			backfields="t1.id,t1.name";
			fromsql=" CRM_CustomerInfo t1 left join " + leftjointable + " t2 on t1.id = t2.relateditemid "
			+ " where t1.id = t2.relateditemid and (t1.deleted=0 or t1.deleted is null) and "+sqlWhere.replaceAll("####","t1.name")+" order by createdate desc,id desc";
		}
		sql.append(taskUtil.getTopSql(backfields,fromsql,rows,rs));
	}else if(searchtype.equals("proj")){
		
		String SearchSql = "";
		String SqlWhere = " where "+sqlWhere.replaceAll("####","t1.subject")+" and t1.prjid = t2.prjid and t2.usertype="+user.getLogintype()+" and t2.userid="+user.getUID();
		
		backfields="t1.id,t1.subject,t1.prjid,t1.hrmid";
		fromsql="Prj_TaskProcess  t1,PrjShareDetail t2 "+ SqlWhere + " order by t1.id desc";
		sql.append(taskUtil.getTopSql(backfields,fromsql,rows,rs));
		
	}else if(searchtype.equals("task")){
		String currentid = Util.null2String(request.getParameter("currentid"));
		
		backfields="t1.id,t1.name,t1.status";
		fromsql="TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null) and "+sqlWhere.replaceAll("####","t1.name")+" "
				+" and (t1.principalid="+user.getUID()+" or t1.creater="+user.getUID()
				+ " or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+user.getUID()+")"
				+ " or exists (select 1 from TM_TaskSharer ts where ts.taskid=t1.id and ts.sharerid="+user.getUID()+")"
				+ " or exists (select 1 from HrmResource hrm where (hrm.id=t1.principalid or hrm.id=t1.creater) and hrm.managerstr like '%,"+user.getUID()+",%')"
				+ " or exists (select 1 from HrmResource hrm,TM_TaskPartner tp where tp.taskid=t1.id and hrm.id=tp.partnerid and hrm.managerstr like '%,"+user.getUID()+",%')"
				+ ")"+(!currentid.equals("")?" and t1.id<>"+currentid:"")+" order by t1.id desc";
		sql.append(taskUtil.getTopSql(backfields,fromsql,rows,rs));
		
	}else if(searchtype.equals("search")){
		
		String currentdate = TimeUtil.getCurrentDateString();
		String currenttime=TimeUtil.getOnlyCurrentTimeString();
		backfields="tasktype,taskid,taskName,creater,isnew,isfeedback,createdate,createtime";
		fromsql="("
		       +taskUtil.getBaseSql(userid,"aff",0,backfields,"") 
		       +"UNION ALL "
	           +"SELECT tasktype,taskid,taskName,creater,isnew,isfeedback,createdate,createtime FROM (SELECT 8 AS tasktype,id AS taskid,lastname AS taskname,CAST(id AS VARCHAR(100)) AS creater,1 AS isnew ,1 AS isfeedback,'"+currentdate+"' AS createdate,'"+currenttime+"' AS createtime  FROM HrmResource WHERE (status =0 or status = 1 or status = 2 or status = 3)) a "
		       +" ) a  where taskname like '%"+key_word+"%' order by createdate desc,createtime desc ";
		sql.append(taskUtil.getTopSql(backfields,fromsql,rows,rs));
		
	}else if(searchtype.equals("tag")){
		String tags = "";
		String tag = "";
		String history = ",";
		rs.executeSql("select tag from TM_TaskInfo where (deleted =0 or deleted is null) order by createdate desc,createtime desc");
		while(rs.next()){
			tag = Util.null2String(rs.getString("tag"));
			if(!tag.equals("")) tags += tag;
		}
		List tagList = Util.TokenizerString(tags,",");
		for(int i=0;i<tagList.size();i++){
			tag = (String)tagList.get(i);
			if(!tag.equals("") && history.indexOf(","+tag+",")<0 && tag.indexOf(key_word)>-1){
				history += tag + ",";
				json += "{id:'"+tag+"',name:'"+tag+"'},";
			}
		}
	}else if(searchtype.equals("mainline")){
		sql.append("SELECT id,name FROM Task_mainline where name like '%"+key_word+"%'");
	}else if(searchtype.equals("labelline")){
		sql.append("SELECT id,name FROM task_label where name like '%"+key_word+"%'");
	}
	if(!searchtype.equals("tag")){
		if(searchtype.equals("mainline")){
			rs.executeSql("SELECT id,name,createor,principalid FROM Task_mainline where (name like '%"+key_word+"%')");
			while(rs.next()){
				if(rs.getInt("createor")== user.getUID()){
					json +="{id:'"+rs.getInt("id")+"',name:'"+rs.getString("name")+"'},";
				}else if(rs.getInt("principalid")== user.getUID()){
					json +="{id:'"+rs.getInt("id")+"',name:'"+rs.getString("name")+"'},";
				}else{
					rs2.executeSql("select * from Task_mainlineShare where mainlineid ="+rs.getInt("id")+" and usertype = 2  and userid =" +userid);
					if(rs2.next()){
						json +="{id:'"+rs.getInt("id")+"',name:'"+rs.getString("name")+"'},";
						}
					}
					}if(json.equals("")){
						 json += "{id:'0',name:'创建\""+key_word+"\"'},";			 
					 }
				}else{
					rs.executeSql(sql.toString());
					if(rs.getCounts()>0){
						while(rs.next()){
							if(searchtype.equals("search")){
								String[] typeNames={"任务","流程","会议","文档","协作","邮件","","人员"};
								String taskid=rs.getString("taskid");
								int tasktype=rs.getInt("tasktype");
								String taskname=rs.getString("taskname");
								String taskTypeName=typeNames[tasktype-1];
								String creater=rs.getString("creater");   //创建人
							    int taskType=rs.getInt("tasktype");       //任务类型
							
							    json += "{id:'"+taskid+"',name:'"+taskname+"',typename:'"+taskTypeName+"',type:"+tasktype+",creater:'"+creater+"'";
						   }else
							    json += "{id:'"+rs.getString(1)+"',name:'"+rs.getString(2)+"'";
						json += "},";
					}
				}else if(iscreate.equals("1")){
					json += "{id:'0',name:'创建\""+key_word+"\"'},";
				}
					
				}		
					
		
	}
	}
	if(!json.equals("")){
		json = "[" + json.substring(0,json.length()-1) + "]";
	}
	//if(searchtype.equals("proj")) rs.executeSql("drop table "+temptable);
out.println(json);
%>
