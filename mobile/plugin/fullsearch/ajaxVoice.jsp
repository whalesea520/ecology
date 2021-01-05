<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.*" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.mobile.webservices.workflow.WorkflowService"%>
<%@page import="weaver.mobile.webservices.workflow.WorkflowServiceImpl"%>
<%@page import="weaver.mobile.webservices.workflow.WorkflowRequestInfo"%>
<%@page import="weaver.hrm.attendance.manager.HrmAttVacationManager"%>
<%@page import="weaver.hrm.schedule.HrmAnnualManagement"%>
<%@page import="weaver.hrm.schedule.HrmPaidSickManagement"%>
<%@page import="weaver.hrm.attendance.manager.HrmPaidLeaveTimeManager"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.hrm.job.JobTitlesComInfo"%>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.WorkPlan.WorkPlanShareUtil"%>
<%@page import="weaver.fullsearch.LoadXmlConf"%>
<%@page import="weaver.fullsearch.XmlConf"%>
<%@page import="weaver.hrm.schedule.manager.HrmScheduleManager"%>
<%@page import="weaver.hrm.schedule.domain.HrmLeaveDay"%>
<%@page import="weaver.fullsearch.VoiceCreateWFUtil"%>
<%@page import="weaver.fullsearch.XmlBean"%>
<%@page import="weaver.hrm.attendance.manager.HrmLeaveTypeColorManager"%>
<%@page import="weaver.hrm.report.schedulediff.HrmScheduleDiffManager"%>
<%@page import="weaver.common.StringUtil"%>
<%@page import="weaver.hrm.attendance.domain.HrmLeaveTypeColor"%>
<%@page import="weaver.mobile.plugin.ecology.service.PluginServiceImpl"%>
<%@page import="ln.LN"%>
<%@page import="weaver.meeting.MeetingShareUtil"%>
<%@page import="weaver.meeting.Maint.MeetingSetInfo"%>
<%@page import="weaver.meeting.MeetingViewer"%>
<%@page import="weaver.meeting.Maint.MeetingComInfo"%>
<%@page import="weaver.meeting.defined.MeetingCreateWFUtil"%>
<%@page import="weaver.meeting.MeetingLog"%>
<%@page import="weaver.meeting.Maint.MeetingInterval"%>
<%@page import="weaver.splitepage.transform.SptmForMeeting"%>
<%@page import="weaver.fullsearch.NumberUtil"%>
<%@page import="weaver.fullsearch.EAssistantMsg"%>
<%@page import="weaver.Constants"%>
<%@page import="weaver.WorkPlan.WorkPlanService"%>
<%@page import="weaver.domain.workplan.WorkPlan"%>
<%@page import="weaver.WorkPlan.WorkPlanLogMan"%>
<%@page import="weaver.fullsearch.TrackInfoUtil"%>
<%@page import="weaver.fna.maintenance.BudgetfeeTypeComInfo"%>
<%@page import="org.apache.http.client.methods.HttpPost"%>
<%@page import="weaver.wechat.request.HttpManager"%>
<%@page import="org.apache.http.message.BasicNameValuePair"%>
<%@page import="org.apache.http.HttpResponse"%>
<%@page import="org.apache.http.HttpStatus"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="org.apache.http.client.entity.UrlEncodedFormEntity"%>
<%@page import="weaver.social.im.SocialIMClient"%>
<%@page import="weaver.mobile.webservices.common.ChatResourceShareManager"%>
<%@page import="weaver.hrm.attendance.manager.HrmScheduleSignManager"%>
<%@ page import="weaver.hrm.attendance.domain.*" %>
<%@ page import="weaver.hrm.attendance.domain.HrmScheduleSign.*" %>
<%@page import="org.apache.http.impl.client.DefaultHttpClient"%>
<%@page import="com.time.nlp.TimeNormalizer"%>
<%@page import="com.time.nlp.TimeUnit"%>
<%@page import="weaver.WorkPlan.WorkPlanEUtil"%>
<%@page import="java.lang.reflect.Method"%>
<%@page import="weaver.blog.service.BlogForXiaoE"%>
<%@page import="weaver.fullsearch.util.ECommonUtil"%>
<%@page import="weaver.hrm.service.HrmResource4EService"%>
<%@page import="weaver.docs.docs.forxe.DocForE"%>
<%@page import="weaver.meeting.MeetingReportUtil"%>
<%@page import="weaver.mobile.plugin.ecology.service.FullSearchService"%>
<%@page import="com.weaver.ecology.search.model.MobileResultItem"%>
<%
out.clearBuffer();
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
	Map result = new HashMap();
	//未登录或登录超时
	result.put("error", "200001");
	
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
	
	return;
}

int userLanguage = user.getLanguage();
userLanguage = (userLanguage == 0) ? 7:userLanguage;

response.setContentType("application/json;charset=UTF-8");
FileUpload fu = new FileUpload(request);

Map result = new HashMap();
String sessionkey = Util.null2String(fu.getParameter("sessionkey"));
String type = Util.null2String(fu.getParameter("type"));
String userId=user.getUID()+"";
//系统查询获取流程待办
if("getWfTodoList".equals(type)){
	String hrmId = Util.null2String(fu.getParameter("hrmId"));
	if("".equals(hrmId)){
		hrmId=user.getUID()+"";
	}
	String workflowid=Util.null2String(fu.getParameter("workflowid"));
	int count=0;
	List<Map<String,String>> list=new LinkedList<Map<String,String>>();
	if(Util.getIntValue(hrmId)>0){
		WorkflowRequestInfo[] requestInfos=null;
		List<String> conditionList = new ArrayList<String>();  
		if(!"".equals(workflowid)){
			conditionList.add(" t1.workflowid in ("+workflowid+") ");
		}
		String[] conditions=null;
		WorkflowServiceImpl ws=new WorkflowServiceImpl();
		if(hrmId.equals(user.getUID()+"")){//自己的待办
			if(conditionList.size()>0){
				conditions=(String[])conditionList.toArray(new String[conditionList.size()]);
			}
			count=ws.getToDoWorkflowRequestCount(user.getUID(),true,conditions);
			if(count>0){
				requestInfos=ws.getToDoWorkflowRequestList(true,1,20,count,user.getUID(),conditions);
			}
			
		}else{//他人的待办,有权限看的数据
			boolean superior = false;
	        //判断是否是上上下级.
            RecordSet rs = new RecordSet();
            rs.executeSql("SELECT * FROM HrmResource WHERE ID = " + Util.getIntValue(hrmId) + " AND managerStr LIKE '%," + userId + ",%'");
            if (rs.next()) {
                superior = true;
            }
            if(!superior){
            	conditionList.add(" EXISTS (SELECT 1 FROM workFlow_CurrentOperator workFlowCurrentOperator WHERE t2.workflowid = workFlowCurrentOperator.workflowid AND t2.requestid = workFlowCurrentOperator.requestid AND workFlowCurrentOperator.userid="
                + userId + " and workFlowCurrentOperator.usertype=0) ");
            }
            conditions=(String[])conditionList.toArray(new String[conditionList.size()]);
		        
			
            count=ws.getToDoWorkflowRequestCount(Util.getIntValue(hrmId), true, conditions);
			//count=ws.getToDoWorkflowRequestCount(user.getUID(),Util.getIntValue(hrmId));
			if(count>0){
				requestInfos=ws.getToDoWorkflowRequestList(true, 1, 20, count, Util.getIntValue(hrmId), conditions, 0);
				//requestInfos=ws.getToDoWorkflowRequestList(user.getUID(),Util.getIntValue(hrmId),1,20,count);
			}
		}
		if(requestInfos!=null){
			WorkflowRequestInfo requestInfo=null;
			Map<String,String> map=null;
			String[] requestids=new String[requestInfos.length];
			for(int i=0;i<requestInfos.length;i++){
				requestInfo=requestInfos[i];
				requestids[i]=requestInfo.getRequestId();
				map=new HashMap<String,String>();
				map.put("schema","WF");
				map.put("id",requestInfo.getRequestId());
				map.put("simpleTitle",requestInfo.getRequestName());
				map.put("simpleDesc",requestInfo.getCreatorName()+"&nbsp;&nbsp;&nbsp;&nbsp;"+requestInfo.getReceiveTime());
				map.put("url","");
				list.add(map);
			}
			//读取未读标识
			if(requestids.length>0){
				String[] userIds=new String[requestInfos.length];
				for(int i=0;i<userIds.length;i++) userIds[i] = userId;
				
				String[] newflagarray = ws.getWorkflowNewFlagByList(requestids, userIds);
    		    
    			if(newflagarray!=null&&newflagarray.length==requestids.length){
    				for(int i=0;i<requestids.length;i++){
    					list.get(i).put("isnew", newflagarray[i]);
    				}
    			}
			}
		}
		
	}
	result.put("list",list);
	result.put("count",count);
}else if("holiday".equals(type)){
	HrmAttVacationManager attVacationManager=new HrmAttVacationManager(); 
	float[] freezeDays = attVacationManager.getFreezeDays(user.getUID()+"");
	
	Calendar annualtoday = Calendar.getInstance(); 
	String nowdate = Util.add0(annualtoday.get(Calendar.YEAR),4) + "-" + Util.add0(annualtoday.get(Calendar.MONTH)+1,2) + "-" + Util.add0(annualtoday.get(Calendar.DAY_OF_MONTH),2);
	//年假
	boolean showAannualInfo=false;
	String aannualInfoTitle=SystemEnv.getHtmlLabelNames("21602,87",user.getLanguage());
	String annualinfo = HrmAnnualManagement.getUserAannualInfo(user.getUID()+"",nowdate);
	String thisyearannual = Util.TokenizerString2(annualinfo,"#")[0];
	String lastyearannual = Util.TokenizerString2(annualinfo,"#")[1];
	String allyearannual = Util.TokenizerString2(annualinfo,"#")[2];
	if(freezeDays[0] > 0) allyearannual += " - "+freezeDays[0];
	//调休
	boolean showLeaveTime=false;
	String leaveTimeTitle=SystemEnv.getHtmlLabelNames("31297,87",user.getLanguage());
	HrmPaidLeaveTimeManager paidLeaveTimeManager=new HrmPaidLeaveTimeManager();
	String pdDays = String.valueOf(paidLeaveTimeManager.getCurrentPaidLeaveDaysByUser(user.getUID()+""));
	if(freezeDays[2] > 0) pdDays += " - "+freezeDays[2];
	
	boolean hasPaidleave=false;
	Class clazz=null;
	Method method=null;
	
	Object attVacationObj=null;
	Method attVacationMethod=null;
	
	try{
        clazz = Class.forName("weaver.hrm.schedule.HrmPaidSickManagement");
        method = clazz.getMethod("getUserPaidSickInfo", String.class, String.class,String.class);  
        hasPaidleave=true;
        
        Class attVacationClazz = Class.forName("weaver.hrm.attendance.manager.HrmAttVacationManager");
        attVacationObj=attVacationClazz.newInstance();
        attVacationMethod = attVacationClazz.getMethod("getPaidFreezeDays", String.class, String.class);
    } catch (Exception e) {
    	//版本不支持配置带薪假
    }
    List<Map<String,String>> list=new LinkedList<Map<String,String>>();
    Map<String,String> tempMap;
    RecordSet rs = new RecordSet();
    if(!hasPaidleave){//老版本. 只有带薪病假
		rs.execute("select field001,field004 from hrmLeaveTypeColor where field004 in(-12,-13,-6) and field002=1");//启用的 年假, 带薪病假  调休
		String titleName=SystemEnv.getHtmlLabelNames("24032,87",user.getLanguage());
		while(rs.next()){
			int leaveType=rs.getInt("field004");
			if(leaveType==-13){//调休
				leaveTimeTitle=rs.getString("field001")+SystemEnv.getHtmlLabelNames("87",user.getLanguage());
				showLeaveTime=true;
				continue;
			}else if(leaveType==-6){//年假
				aannualInfoTitle=rs.getString("field001")+SystemEnv.getHtmlLabelNames("87",user.getLanguage());
				showAannualInfo=true;
				continue;
			}else{
				String pslinfo = HrmPaidSickManagement.getUserPaidSickInfo(user.getUID()+"",nowdate);
				String thisyearpsl = Util.TokenizerString2(pslinfo,"#")[0];
				String lastyearpsl = Util.TokenizerString2(pslinfo,"#")[1];
				String allyearpsl = Util.TokenizerString2(pslinfo,"#")[2];
				if(freezeDays[1] > 0) allyearpsl += " - "+freezeDays[1];
				
				titleName=rs.getString("field001")+SystemEnv.getHtmlLabelNames("87",user.getLanguage());
				tempMap=new HashMap<String,String>();
				tempMap.put("title",titleName);
				tempMap.put("lastvalue",lastyearpsl);
				tempMap.put("thisvalue",thisyearpsl);
				tempMap.put("allvalue",allyearpsl);
				list.add(tempMap);
			}
		}
		if(showLeaveTime){
			tempMap=new HashMap<String,String>();
			tempMap.put("title",leaveTimeTitle);
			tempMap.put("allvalue",pdDays);
			list.add(tempMap);
		}
    }else{//新版本. 所有带薪假
    	String lastvalue="0.0";
    	String thisvalue="0.0";
    	String allvalue="0.0";
    	
    	rs.execute("select field001,field004,ispaidleave from hrmLeaveTypeColor where field002=1");
    	
    	while(rs.next()){
    		int leaveType=rs.getInt("field004");
    		lastvalue = "0.0";
			thisvalue = "0.0";
			allvalue = "0.0";
			
			if(leaveType==-13){//调休
				leaveTimeTitle=rs.getString("field001")+SystemEnv.getHtmlLabelNames("87",user.getLanguage());
				showLeaveTime=true;
				continue;
			}else if(leaveType==-6){//年假
				aannualInfoTitle=rs.getString("field001")+SystemEnv.getHtmlLabelNames("87",user.getLanguage());
				showAannualInfo=true;
				continue;
			}else{
				int ispaidleave=Util.getIntValue(rs.getString("ispaidleave"),0);
				if(ispaidleave==1){//带薪假
					tempMap=new HashMap<String,String>();
					tempMap.put("title",rs.getString("field001")+SystemEnv.getHtmlLabelNames("87",user.getLanguage()));
					
					if(clazz!=null&&method!=null){
						String pslinfo =(String) method.invoke(clazz,user.getUID()+"",nowdate,leaveType+"");
						thisvalue = Util.TokenizerString2(pslinfo,"#")[0];
						lastvalue = Util.TokenizerString2(pslinfo,"#")[1];
						allvalue = Util.TokenizerString2(pslinfo,"#")[2];
						if(attVacationObj!=null&&attVacationMethod!=null){
							float freezeDay =(Float) attVacationMethod.invoke(attVacationObj,user.getUID()+"",leaveType+"");
							if(freezeDay > 0) allvalue += " - "+freezeDays;
						}
					}
					tempMap.put("lastvalue",lastvalue);
					tempMap.put("thisvalue",thisvalue);
					tempMap.put("allvalue",allvalue);
					list.add(tempMap);
				}else{
					continue;
				}
			}
    	}
    	if(showLeaveTime){
			tempMap=new HashMap<String,String>();
			tempMap.put("title",leaveTimeTitle);
			tempMap.put("allvalue",pdDays);
			list.add(tempMap);
		}
    }
	
	String htmlStr="<div class='holidayDiv' style='line-height:35px;'>";
		   if(showAannualInfo||list.size()==0){
			   htmlStr+="<div class='lineTips'>"+aannualInfoTitle+"</div>"+
					"<div class='lineBottom'><div class='labelName'>"+SystemEnv.getHtmlLabelName(132011,user.getLanguage()) +"</div><div>"+lastyearannual+"</div></div>"+
					"<div class='lineBottom'><div class='labelName'>"+SystemEnv.getHtmlLabelName(132012,user.getLanguage()) +"</div><div>"+thisyearannual+"</div></div>"+
					"<div class='lineBottom lastLi'><div class='labelName'>"+SystemEnv.getHtmlLabelName(132013,user.getLanguage()) +"</div><div>"+allyearannual+"</div></div>";
		   }
			//循环显示带薪假			
		    for(int i=0;i<list.size();i++){
			  tempMap=list.get(i);
			  htmlStr+="<div class='lineTips'>"+tempMap.get("title")+"</div>";
			  	if(tempMap.containsKey("lastvalue")){
			  		htmlStr+="<div class='lineBottom'><div class='labelName'>"+SystemEnv.getHtmlLabelName(132011,user.getLanguage()) +"</div><div>"+tempMap.get("lastvalue")+"</div></div>";
			  	}
			  	if(tempMap.containsKey("thisvalue")){
			  		htmlStr+="<div class='lineBottom'><div class='labelName'>"+SystemEnv.getHtmlLabelName(132012,user.getLanguage()) +"</div><div>"+tempMap.get("thisvalue")+"</div></div>";
			  	}
			  	htmlStr+="<div class='lineBottom lastLi'><div class='labelName'>"+SystemEnv.getHtmlLabelName(132013,user.getLanguage()) +"</div><div>"+tempMap.get("allvalue")+"</div></div>";
			}
			htmlStr+="</div>";

	result.put("result",htmlStr);
	
}else if("superior".equals(type)){//上级
	String hrmId = Util.null2String(fu.getParameter("hrmId"));
	int count=0;
	List list=new LinkedList();
	if(!"".equals(hrmId)){
		ResourceComInfo rsc=new  ResourceComInfo();
		JobTitlesComInfo job=new JobTitlesComInfo(); 
		SubCompanyComInfo subcomp=new SubCompanyComInfo();
		DepartmentComInfo dept=new DepartmentComInfo();
		String managerId=rsc.getManagerID(hrmId);
		if(Util.getIntValue(managerId)>0){
			count=1;
			
			Map map=new HashMap();
			map.put("schema","RSC");
			map.put("id",managerId);
			map.put("simpleTitle",rsc.getLastname(managerId));
			map.put("simpleDesc","");
			map.put("url","");
			
			Map other=new HashMap();
			other.put("URL",rsc.getMessagerUrls(managerId));
			other.put("SEX",rsc.getSexs(managerId)); 
			other.put("MOBILE",rsc.getMobile(managerId)); 
			other.put("SUBCOMP",subcomp.getSubcompanyname(rsc.getSubCompanyID(managerId))); 
			other.put("JOBTITLENAME",job.getJobTitlesname(rsc.getJobTitle(managerId))); 
			other.put("DEPT", dept.getDepartmentname(rsc.getDepartmentID(managerId))); 
				
			map.put("other",JSONObject.fromObject(other).toString());
			list.add(map);
		}
	}
	result.put("list",list);
	result.put("count",count);
}else if("subordinate".equals(type)){//下属.最多显示50个.
	String hrmId = Util.null2String(fu.getParameter("hrmId"));
	int count=0;
	List list=new LinkedList();
	if(!"".equals(hrmId)){
		Map map=null;
		Map other=null;
		JobTitlesComInfo job=new JobTitlesComInfo(); 
		SubCompanyComInfo subcomp=new SubCompanyComInfo();
		DepartmentComInfo dept=new DepartmentComInfo();
		RecordSet rs=new RecordSet();
		rs.execute("select id,lastname,messagerurl,departmentid,subcompanyid1,jobtitle,sex,mobile from HrmResource where status<4 and managerid='"+hrmId+"' order by id ");
		count=rs.getCounts();
		int i=1;
		while(rs.next()){
			map=new HashMap();
			other=new HashMap();
			
			map.put("schema","RSC");
			map.put("id",rs.getString("id"));
			map.put("simpleTitle",rs.getString("lastname"));
			map.put("simpleDesc","");
			map.put("url","");
			
			other.put("URL",rs.getString("messagerurl"));
			other.put("SEX",rs.getString("sex")); 
			other.put("MOBILE",rs.getString("mobile")); 
			other.put("SUBCOMP",subcomp.getSubcompanyname(rs.getString("subcompanyid1"))); 
			other.put("JOBTITLENAME",job.getJobTitlesname(rs.getString("jobtitle"))); 
			other.put("DEPT", dept.getDepartmentname(rs.getString("departmentid"))); 
				
			map.put("other",JSONObject.fromObject(other).toString());
			list.add(map);
			i++;
			if(i>50){
				break;
			}
		}
	}
	result.put("list",list);
	result.put("count",count);
}else if("workplan".equals(type)){//查询日程
	String hrmId = Util.null2String(fu.getParameter("hrmId"));
	String date = Util.null2String(fu.getParameter("date"));
	String sDate = Util.null2String(fu.getParameter("sDate"));//开始日期
	String eDate = Util.null2String(fu.getParameter("eDate"));//结束日期
	String type_n = Util.null2String(fu.getParameter("type_n"));
	String maybe = Util.null2String(fu.getParameter("maybe"));//可能操作
	
	int count=0;
	List list=new LinkedList();
	if(!"".equals(hrmId)){
		if("".equals(date)){
			date=TimeUtil.getCurrentDateString();
		}
		//if("".equals(sDate)) sDate=date;
		//if("".equals(eDate)) eDate=date;
		RecordSet rs=new RecordSet();
		StringBuffer sqlStringBuffer = new StringBuffer();
		sqlStringBuffer.append("select * from (select id,name,createrid,createdate,begindate,begintime,enddate,endtime from WorkPlan where status=0 and deleted <> 1 ");
		if (rs.getDBType().equals("oracle")) {
			sqlStringBuffer.append(" and  ','||resourceID||',' LIKE '%,"+ hrmId + ",%'");
		}else if (rs.getDBType().equalsIgnoreCase("mysql")) {
			sqlStringBuffer.append(" and  concat(',',resourceID,',') LIKE '%,"+ hrmId + ",%'");
		}else{
			sqlStringBuffer.append(" and  ','+resourceID+',' LIKE '%,"+ hrmId + ",%'");
		}
		if(!"".equals(type_n)){
			sqlStringBuffer.append(" and  type_n ='"+type_n+"'");
		}
		if(!"".equals(sDate)&&!"".equals(eDate)){
			sqlStringBuffer.append("and ( beginDate <= '").append(eDate).append("' AND endDate >= '").append(sDate).append("')"); 
		}else{
			sqlStringBuffer.append("and  endDate >= '").append(date).append("'"); 
		}
		sqlStringBuffer.append(") A ");	
		if(!hrmId.equals(user.getUID()+"")){//不是自己日程
			String sql=WorkPlanShareUtil.getShareSql(user);
			sqlStringBuffer.append(" JOIN").append(" (").append(sql).append(" ) B ON A.id = B.workId ");
		}
		sqlStringBuffer.append(" order by begindate , begintime");
		rs.execute(sqlStringBuffer.toString());
		Map map=null;
		Map other=null;
		ResourceComInfo rsc=new  ResourceComInfo();
		int i=1;
		count=rs.getCounts();
		while(rs.next()){
			map=new HashMap();
			other=new HashMap();
			
			map.put("schema","WKP");
			map.put("id",rs.getString("id"));
			map.put("simpleTitle",rs.getString("name"));
			map.put("simpleDesc",rsc.getLastname(rs.getString("createrid")));
			map.put("url","");
			
			other.put("CREATEDATE",rs.getString("createdate"));
			other.put("BEGINDATE",rs.getString("begindate"));
			other.put("BEINGTIME",rs.getString("begintime"));
			map.put("other",JSONObject.fromObject(other).toString());
			list.add(map);
			i++;
			if(i>50){
				break;
			}
		}
		
		if("todolist".equalsIgnoreCase(maybe)){
			if(Util.getIntValue(hrmId)>0){
				if(hrmId.equals(user.getUID()+"")){//自己的待办
					WorkflowService ws=new WorkflowServiceImpl();
					int wfcount=ws.getToDoWorkflowRequestCount(user.getUID(),true,null);
					if(wfcount>0){
						result.put("showMaybeStr","您有"+wfcount+"条待办 点击查看>>");
					}
					
				}else{//他人的待办,有权限看的数据
					WorkflowServiceImpl ws=new WorkflowServiceImpl();
					int wfcount=ws.getToDoWorkflowRequestCount(user.getUID(),Util.getIntValue(hrmId));
					if(wfcount>0){
						result.put("showMaybeStr",rsc.getLastname(hrmId)+"有"+wfcount+"条待办 点击查看>>");
					}
				}
			}
		} 
		
	}
	result.put("list",list);
	result.put("count",count);


}else if("insertFAQ".equals(type)){//手动提交不满意结果
	boolean intoFAQ=false;
	RecordSet rs=new RecordSet();
	rs.execute("select sValue from FullSearch_EAssistantSet where sKey='ALLOWSUBMITFAQ'");
	if(rs.next()){
		intoFAQ="1".equals(rs.getString("sValue"));
	}
	if(intoFAQ){
		String dateString=TimeUtil.getCurrentDateString();
		String timeString=TimeUtil.getOnlyCurrentTimeString();
		String ask = Util.null2String(fu.getParameter("ask"));
		String commitTag = Util.null2String(fu.getParameter("commitTag"));
		if("".equals(commitTag)){
			commitTag="1";
		}
		if(!"".equals(ask)){
			 String sql="insert into Fullsearch_E_Faq(ask,createdate,createtime,status,commitTag,createrId,sendReply,readFlag,targetFlag,checkOutId) "+
				  "values('"+ask+"','"+dateString+"','"+timeString+"',0,"+commitTag+","+user.getUID()+",0,0,0,0) ";
			 rs.execute(sql);
			 //通知消息接口
			 EAssistantMsg.noticeCustomerService();
		}
		result.put("result","success");
	}
}else if("AutoInsertFAQ".equals(type)){//自动提交无结果数据
	boolean intoFAQ=false;
	RecordSet rs=new RecordSet();
	rs.execute("select sValue from FullSearch_EAssistantSet where sKey='ALLOWAUTOSUBMITFAQ'");
	if(rs.next()){
		intoFAQ="1".equals(rs.getString("sValue"));
	}
	if(intoFAQ){
		String dateString=TimeUtil.getCurrentDateString();
		String timeString=TimeUtil.getOnlyCurrentTimeString();
		String ask = Util.null2String(fu.getParameter("ask"));
		if(!"".equals(ask)){
			 String sql="insert into Fullsearch_E_Faq(ask,createdate,createtime,status,commitTag,createrId,sendReply,readFlag,targetFlag,checkOutId) "+
				  "values('"+ask+"','"+dateString+"','"+timeString+"',0,0,"+user.getUID()+",0,0,0,0) ";
			 rs.execute(sql);
			 //通知消息接口
			 EAssistantMsg.noticeCustomerService();
		}
		result.put("result","success");
	}
}else if("LoadFAQAnswer".equals(type)){//加载小e回复通知
	RecordSet rs=new RecordSet();
	List list=new LinkedList();
	String sql="select  t1.*,t2.faqAnswer from Fullsearch_E_Faq t1 left join fullSearch_FaqDetail t2 on t1.faqTargetId=t2.id  where t1.status=1 and t1.createrId="+userId+" and t1.sendReply=1 and t1.readFlag=0 order by t1.processdate desc,t1.processtime desc";
	rs.execute(sql);
	Map map=null;
	String ids="";
	if(rs.next()){
		map=new HashMap();
		map.put("id",rs.getString("id"));
		map.put("ask",rs.getString("ask"));
		map.put("answer",rs.getString("answer"));
		if(Util.getIntValue(rs.getString("faqTargetId"))>0){
			map.put("answer",rs.getString("faqAnswer"));
		}
		map.put("changeAsk",Util.null2String(rs.getString("changeAsk")));
		list.add(map);
		ids+="".equals(ids)?rs.getString("id"):","+rs.getString("id");
	}
	result.put("result","success");
	result.put("ids",ids);
	result.put("list",list);
}else if("updateFAQAnswerFlag".equals(type)){//更新消息已读
	String ids = Util.null2String(fu.getParameter("ids"));
	if(!"".equals(ids)){
		RecordSet rs=new RecordSet();
		String sql="update Fullsearch_E_Faq set readFlag=1 where status=1 and createrId="+userId+" and sendReply=1 and readFlag=0 and id in("+ids+")";
		rs.execute(sql);
	}
	result.put("result","success");
}else if("checkWF".equals(type)){//检查流程是否有效
	String wftype = Util.null2String(fu.getParameter("wftype"));
	result.put("result","error");
	if(!"".equals(wftype)){
		XmlConf conf= LoadXmlConf.getInstance().loadXml(wftype);
		if(conf!=null){
			String workflowid= Util.null2String(conf.getWorkflowId());
			if(!"".equals(workflowid)){//有效
				result.put("result","success");
				result.put("workflowid",workflowid);
				result.put("workflowname",conf.getWorkflowName());
			}
		}
	}
}else if("LeaveParam".equals(type)){//获取请假初始值
	boolean hasPaidleave=false;//是否有配置带薪假
	Class clazz=null;
	Method method=null;
	
	Object attVacationObj=null;
	Method attVacationMethod=null;
	
	try{
        clazz = Class.forName("weaver.hrm.schedule.HrmPaidSickManagement");
        method = clazz.getMethod("getUserPaidSickInfo", String.class, String.class,String.class);  
        hasPaidleave=true;
        
        Class attVacationClazz = Class.forName("weaver.hrm.attendance.manager.HrmAttVacationManager");
        attVacationObj=attVacationClazz.newInstance();
        attVacationMethod = attVacationClazz.getMethod("getPaidFreezeDays", String.class, String.class);
    } catch (Exception e) {
    	//版本不支持配置带薪假
    }
    result.put("hasPaidleave",hasPaidleave);
    String checkLeaveType=",-6,-13,";//年假,调休, -12. 
    float real=0.0f;
    String show="";
    Map tempMap=null;
	//请假天数等判断
	HrmAttVacationManager attVacationManager=new HrmAttVacationManager(); 
	float[] freezeDays = attVacationManager.getFreezeDays(user.getUID()+"");
	
	Calendar annualtoday = Calendar.getInstance(); 
	String nowdate = Util.add0(annualtoday.get(Calendar.YEAR),4) + "-" + Util.add0(annualtoday.get(Calendar.MONTH)+1,2) + "-" + Util.add0(annualtoday.get(Calendar.DAY_OF_MONTH),2);
	//年假
	String annualinfo = HrmAnnualManagement.getUserAannualInfo(user.getUID()+"",nowdate);
	String allyearannual = Util.TokenizerString2(annualinfo,"#")[2];
	real=Util.getFloatValue(allyearannual,0.0f);
	if(freezeDays[0] > 0){
		allyearannual += " - "+freezeDays[0];
		real-=freezeDays[0];
	}
	tempMap=new HashMap();
	tempMap.put("real",real);
	tempMap.put("show",allyearannual);
	result.put("levave_-6",tempMap);
	
	//调休
	HrmPaidLeaveTimeManager paidLeaveTimeManager=new HrmPaidLeaveTimeManager();
	String pdDays = String.valueOf(paidLeaveTimeManager.getCurrentPaidLeaveDaysByUser(user.getUID()+""));
	real=Util.getFloatValue(pdDays,0.0f);
	if(freezeDays[2] > 0){
		pdDays += " - "+freezeDays[2];
		real-=freezeDays[0];
	}
	tempMap=new HashMap();
	tempMap.put("real",real);
	tempMap.put("show",pdDays);
	result.put("levave_-13",tempMap);
	
	RecordSet rs = new RecordSet();
	
	if(!hasPaidleave){
		String pslinfo = HrmPaidSickManagement.getUserPaidSickInfo(user.getUID()+"",nowdate);
		String allyearpsl = Util.TokenizerString2(pslinfo,"#")[2];
		real=Util.getFloatValue(allyearpsl,0.0f);
		if(freezeDays[1] > 0){
			allyearpsl += " - "+freezeDays[1];
			real-=freezeDays[1];
		}
		checkLeaveType+="-12,";
		tempMap=new HashMap();
		tempMap.put("real",real);
		tempMap.put("show",pdDays);
		result.put("levave_-12",tempMap);
		
		rs.execute("select field001,field004 from hrmLeaveTypeColor where field002=1");
		String LeaveTypeName="";
		String LeaveTypeId="";
		String allLeaveTypeName="";
		Map map=new HashMap();
		while(rs.next()){
			LeaveTypeName=rs.getString("field001");
			LeaveTypeId=rs.getString("field004");
			map.put(LeaveTypeName,LeaveTypeId);
			allLeaveTypeName+=("".equals(allLeaveTypeName)?"":"，")+LeaveTypeName;
		}
		result.put("LeaveTypeMap",map);
		result.put("allLeaveTypeName",allLeaveTypeName);
	}else{
    	String allvalue="0.0";
    	rs.execute("select field001,field004,ispaidleave from hrmLeaveTypeColor where field002=1");
    	String LeaveTypeName="";
		String LeaveTypeId="";
		String allLeaveTypeName="";
		Map map=new HashMap();
    	while(rs.next()){
    		int leaveType=rs.getInt("field004");
    		LeaveTypeName=rs.getString("field001");
			LeaveTypeId=rs.getString("field004");
			map.put(LeaveTypeName,LeaveTypeId);
			allLeaveTypeName+=("".equals(allLeaveTypeName)?"":"，")+LeaveTypeName;
			
			if(leaveType==-13){//调休
				continue;
			}else if(leaveType==-6){//年假
				continue;
			}else{
				int ispaidleave=Util.getIntValue(rs.getString("ispaidleave"),0);
				if(ispaidleave==1){//带薪假
					checkLeaveType+=leaveType+",";
				
					tempMap=new HashMap<String,String>();
					
					if(clazz!=null&&method!=null){
						String pslinfo =(String) method.invoke(clazz,user.getUID()+"",nowdate,leaveType+"");
						allvalue = Util.TokenizerString2(pslinfo,"#")[2];
						real=Util.getFloatValue(allvalue,0.0f);
						if(attVacationObj!=null&&attVacationMethod!=null){
							float freezeDay =(Float) attVacationMethod.invoke(attVacationObj,user.getUID()+"",leaveType+"");
							if(freezeDay > 0){
								allvalue += " - "+freezeDays;
								real-=freezeDays[1];
							}
						}
					}
					tempMap.put("real",real);
					tempMap.put("allvalue",allvalue);
					result.put("levave_"+leaveType,tempMap);
				}else{
					continue;
				}
			}
    	}
    	result.put("LeaveTypeMap",map);
		result.put("allLeaveTypeName",allLeaveTypeName);
    }
	result.put("checkLeaveType",checkLeaveType);

}else if("OutParam".equals(type)){//获取出差初始参数
	XmlConf conf= LoadXmlConf.getInstance().loadXml("Out");
	if(conf!=null){
		XmlBean bean=conf.getFieldMap().get("outType");
		result.put("outType",bean.getDefaultV());
		result.put("outTypeName",bean.getDefaultN());
	}
	
}else if("FnaNoInteractiveParam".equals(type)){//获取费用报销交互字段
	XmlConf conf= LoadXmlConf.getInstance().loadXml("Fna");
	if(conf!=null){
		Map<String, XmlBean> map=conf.getFieldMap();
		Iterator<String> it=map.keySet().iterator();
		String key="";
		XmlBean xmlbean=null; 
		String interactiveStr=",";
		while(it.hasNext()){
			key=it.next();
			xmlbean=map.get(key);
			if(xmlbean.isFnaNoInteractiveField()){
				interactiveStr+=key+",";
			}
		}
		result.put("fnaNoInteractiveField",interactiveStr);
		//获取科目的对应字段
		String formid=conf.getFormid();
		String feeColumn=map.get("feetypeid").getColumn();//此字段要么是主表,要么是明细, 只能有一个科目.
		if(feeColumn.startsWith("dt##")){
			feeColumn=feeColumn.split("##")[2];
		}
		RecordSet rs=new RecordSet();
		rs.execute("SELECT id FROM workflow_billfield  where billid="+formid+" and fieldname='"+feeColumn+"'");
		if(rs.next()){
			result.put("bdf_fieldid",rs.getString("id"));
		}
		//默认相关客户
		String defCrm=map.get("crm").getDefaultV();
		String defCrmName=map.get("crm").getDefaultN();
		result.put("defCrm",defCrm);
		result.put("defCrmName",defCrmName);
	}
	
}else if("getLeaveDays".equals(type)){//计算请假天数
	HrmScheduleManager hrmScheduleManager=new HrmScheduleManager(); 
	String fromDate = Util.null2String(fu.getParameter("fromDate"));
	String fromTime = Util.null2String(fu.getParameter("fromTime"));
	String toDate = Util.null2String(fu.getParameter("toDate"));
	String toTime = Util.null2String(fu.getParameter("toTime"));
	String resourceId = Util.null2String(fu.getParameter("resourceId"));
	
	HrmLeaveDay bean = new HrmLeaveDay();
	bean.setFromDate(fromDate);
	bean.setFromTime(fromTime);
	bean.setToDate(toDate);
	bean.setToTime(toTime);
	bean.setResourceId(String.valueOf(resourceId));
	bean.setScale(hrmScheduleManager.getScale());
	
	result.put("result", hrmScheduleManager.getLeaveDays(bean));
}else if("saveWF".equals(type)){//提交流程
	String wftype = Util.null2String(fu.getParameter("wftype"));
	result.put("result", "0");//失败
	if(!"".equals(wftype)){
		XmlConf conf= LoadXmlConf.getInstance().loadXml(wftype);
		if(conf!=null){
			String workflowid= Util.null2String(conf.getWorkflowId());
			if(!"".equals(workflowid)){//有效
				ResourceComInfo resc=new ResourceComInfo();
				//默认参数
				Map data=new HashMap();
				data.put("userId",user.getUID()+"");
				data.put("workcode",resc.getWorkcode(user.getUID()+""));
				data.put("departmentId",user.getUserDepartment()+"");
				data.put("subcompanyId",user.getUserSubCompany1()+"");
				data.put("manager",user.getManagerid()+"");
				data.put("submitDate",TimeUtil.getCurrentDateString());
				
				Enumeration enumname= fu.getParameterNames();
				while(enumname.hasMoreElements()){
					String key=(String)enumname.nextElement();
					if("wftype".equals(key)||"type".equals(key)||"clienttype".equals(key)||"viewmodule".equals(key)||"sessionkey".equals(key)) continue;
					String value=Util.null2String(fu.getParameter(key));
					data.put(key,value);
				}
				VoiceCreateWFUtil voiceCreateWFUtil=new VoiceCreateWFUtil();
				int requestid=voiceCreateWFUtil.createWF(conf,user,data);
				if(requestid>0){
					RecordSet rs=new RecordSet();
					rs.execute("select requestid,requestname,createdate  from workflow_requestbase where requestid="+requestid);
					Map map=new HashMap();
					if(rs.next()){
						map.put("schema","WF");
						map.put("id",rs.getString("requestid"));
						map.put("simpleTitle",rs.getString("requestname"));
						map.put("simpleDesc",user.getUsername()+"&nbsp;&nbsp;&nbsp;&nbsp;"+rs.getString("createdate"));
						map.put("url","");
						result.put("data", map);
					}
					result.put("result", "1");
				}else{
					result.put("requestid", requestid+"");
					result.put("msg", voiceCreateWFUtil.getRetMsg());
					
				}
			}
		}
	}
}else if("AttendanceReport".equals(type)){//考勤报表
	String hrmId = Util.null2String(fu.getParameter("hrmId"));
	result.put("result", "0");//请求成功.暂无返回
	boolean hasRight=false;
	if("".equals(hrmId)){
		hrmId=user.getUID()+"";
	}
	if(!hrmId.equals(user.getUID()+"")){//看其他人数据...
		ResourceComInfo rsc=new  ResourceComInfo();
		//有考勤报表权限或者是领导.
		if(HrmUserVarify.checkUserRight("BohaiInsuranceScheduleReport:View", user)||rsc.getManagers(hrmId).indexOf(","+user.getUID()+",")>-1){
			hasRight=true; 
		}
	}else{
		hasRight=true;
	}
	ResourceComInfo rsc=new  ResourceComInfo();
	if(hasRight){
		//获取时间判断
		String date = Util.null2String(fu.getParameter("date"));
		String datetype = Util.null2String(fu.getParameter("datetype"));//1 指定天 2 周  3月
		String dif = Util.null2String(fu.getParameter("dif"));
		if("".equals(date)){
			date=TimeUtil.getCurrentDateString();
		}
		String fromDate="";
		String toDate="";
		if("4".equals(datetype)){//年
			Date yearDate=TimeUtil.getString2Date(date,"yyyy-MM-dd");
			GregorianCalendar gc = (GregorianCalendar) Calendar.getInstance();
			gc.setTime(yearDate);
			gc.set(Calendar.DAY_OF_YEAR, 1);
			fromDate=TimeUtil.getDateString(gc.getTime());
			
			gc.set(Calendar.MONTH, Calendar.DECEMBER+1);
			gc.set(Calendar.DAY_OF_MONTH, 0);
			toDate=TimeUtil.getDateString(gc.getTime());
		}else if("3".equals(datetype)){//月份
			if("-1".equals(dif)){//上个月
				fromDate=TimeUtil.getDateByOption("7","0");
				toDate=TimeUtil.getDateByOption("7","1");
			}else if("1".equals(dif)){//下个月
				Calendar cal = Calendar.getInstance(); 
				cal.add(Calendar.MONTH, 1);
				cal.set(GregorianCalendar.DAY_OF_MONTH, 1); 
		        fromDate=TimeUtil.getDateString(cal);
		        cal.set( Calendar.DATE, 1 );
		        cal.roll(Calendar.DATE, - 1 );
		        toDate=TimeUtil.getDateString(cal);
			}else{//根据 date 指定月份
				fromDate=TimeUtil.getMonthBeginDay(date);
				toDate=TimeUtil.getMonthEndDay(date);
			} 
		}else if("2".equals(datetype)){//周
			if("-1".equals(dif)){//上周
				String lastWeekDateStr=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-7);
				Date lastWeekDate=TimeUtil.getString2Date(lastWeekDateStr,"yyyy-MM-dd");
				fromDate=TimeUtil.getDateString(TimeUtil.getFirstDayOfWeek(lastWeekDate));
				toDate=TimeUtil.getDateString(TimeUtil.getLastDayOfWeek(lastWeekDate));
			}else if("1".equals(dif)){//下周
				String nextWeekDateStr=TimeUtil.dateAdd(date,7);
				Date nextWeekDate=TimeUtil.getString2Date(nextWeekDateStr,"yyyy-MM-dd");
				fromDate=TimeUtil.getDateString(TimeUtil.getFirstDayOfWeek(nextWeekDate));
				toDate=TimeUtil.getDateString(TimeUtil.getLastDayOfWeek(nextWeekDate));
			}else{//本周
				fromDate=TimeUtil.getDateByOption("2","0");
				toDate=TimeUtil.getDateByOption("2","1");
			} 
		}else{//指定天
			fromDate=toDate=date;
		}
		result.put("fromDate",fromDate);
		result.put("toDate",toDate);
		StringUtil strUtil=new StringUtil();
		HrmLeaveTypeColorManager colorManager=new HrmLeaveTypeColorManager();
		List qList = colorManager.find("[map]subcompanyid:0;field002:1;field003:1");
		int qSize = qList == null ? 0 : qList.size();
		 
		HrmScheduleDiffManager diffManager = new HrmScheduleDiffManager();
		List scheduleList = diffManager.getScheduleList(fromDate,toDate,0,0,hrmId);
		Map scheduleMap=null;
		for(int i=0; i<scheduleList.size(); i++) {
			scheduleMap = (Map)scheduleList.get(i);
		}
		if(scheduleMap!=null){
			String htmlStr="<div class='holidayDiv' style='line-height:35px;'>"+
							"<div class='lineTips'>"+SystemEnv.getHtmlLabelNames("15880,61,622",user.getLanguage())+"</div>"+
							"<div class='lineBottom'><div class='labelName'>"+SystemEnv.getHtmlLabelName(34082,user.getLanguage()) +"</div><div>"+strUtil.vString(scheduleMap.get("workDays"),"0")+"</div></div>"+
							"<div class='lineBottom'><div class='labelName'>"+SystemEnv.getHtmlLabelNames("380,21551,81913,391,81914",user.getLanguage()) +"</div><div>"+strUtil.vString(scheduleMap.get("workHours"),"0")+"</div></div>"+
							"<div class='lineBottom'><div class='labelName'>"+SystemEnv.getHtmlLabelNames("20081,81913,18929,81914",user.getLanguage()) +"</div><div>"+strUtil.vString(scheduleMap.get("beLate"),"0")+"</div></div>"+
							"<div class='lineBottom'><div class='labelName'>"+SystemEnv.getHtmlLabelNames("20082,81913,18929,81914",user.getLanguage()) +"</div><div>"+strUtil.vString(scheduleMap.get("leaveEarly"),"0")+"</div></div>"+
							"<div class='lineBottom'><div class='labelName'>"+SystemEnv.getHtmlLabelNames("20085,81913,18929,81914",user.getLanguage()) +"</div><div>"+strUtil.vString(scheduleMap.get("absentFromWork"),"0")+"</div></div>"+
							"<div class='lineBottom lastLi'><div class='labelName'>"+SystemEnv.getHtmlLabelNames("20086,81913,18929,81914",user.getLanguage()) +"</div><div>"+strUtil.vString(scheduleMap.get("noSign"),"0")+"</div></div>";
							if(qSize>0){
								htmlStr+="<div class='lineTips'>"+SystemEnv.getHtmlLabelNames("670,622,81913,1925,81914",user.getLanguage())+"</div>";
								HrmLeaveTypeColor bean = null;
								for(int i=0; i<qSize; i++){
									String lName = "";
									bean = (HrmLeaveTypeColor)qList.get(i);
									switch(user.getLanguage()){
									case 7:
										lName = bean.getField007();
										break;
									case 8:
										lName = bean.getField008();
										break;
									case 9:
										lName = bean.getField009();
										break;
									}
									htmlStr+="<div class='lineBottom "+(i==qSize-1?"lastLi":"")+"'><div class='labelName'>"+strUtil.vString(lName, bean.getField001()) +"</div><div>"+strUtil.vString(scheduleMap.get("leave"+bean.getField004()),"0")+"</div></div>";
								}
							}
							//加班情况
							htmlStr+="<div class='lineTips'>"+SystemEnv.getHtmlLabelNames("6151,622,81913,391,81914",user.getLanguage())+"</div>"+
									 "<div class='lineBottom'><div class='labelName'>"+SystemEnv.getHtmlLabelName(125804,user.getLanguage()) +"</div><div>"+strUtil.vString(scheduleMap.get("overTimes0"),"0")+"</div></div>"+
									 "<div class='lineBottom lastLi'><div class='labelName'>"+SystemEnv.getHtmlLabelName(125805,user.getLanguage()) +"</div><div>"+strUtil.vString(scheduleMap.get("overTimes1"),"0")+"</div></div>";
							//其他
							htmlStr+="<div class='lineTips'>"+SystemEnv.getHtmlLabelNames("375",user.getLanguage())+"</div>"+
									 "<div class='lineBottom'><div class='labelName'>"+SystemEnv.getHtmlLabelNames("20084,81913,1925,81914",user.getLanguage()) +"</div><div>"+strUtil.vString(scheduleMap.get("evection"),"0")+"</div></div>"+
									 "<div class='lineBottom lastLi'><div class='labelName'>"+SystemEnv.getHtmlLabelNames("24058,81913,1925,81914",user.getLanguage()) +"</div><div>"+strUtil.vString(scheduleMap.get("outDays"),"0")+"</div></div>";
										
							
							htmlStr+="</div>";
			result.put("htmlStr",htmlStr);
			result.put("result","1");
		}
	}else{
		result.put("result", "-1");
		result.put("msg", "你无权查看"+rsc.getLastname(hrmId)+"的考勤数据");
	}
}else if("saveBlog".equals(type)){//追加微博
	PluginServiceImpl ps = new PluginServiceImpl();
	JSONObject jo=ps.getBlogJson(fu);
	
	if(jo.containsKey("discussItem")){//保存成功.
		jo.put("result", "1");//成功
		ResourceComInfo rsc=new  ResourceComInfo();
		JobTitlesComInfo job=new JobTitlesComInfo(); 
		SubCompanyComInfo subcomp=new SubCompanyComInfo();
		DepartmentComInfo dept=new DepartmentComInfo();
		
	 
		Map map=new HashMap();
		map.put("userid",userId);
		map.put("username",user.getLastname());
		map.put("imageUrl",rsc.getMessagerUrls(userId));
		map.put("sex",user.getSex()); 
		map.put("subName",subcomp.getSubcompanyname(user.getUserSubCompany1()+"")); 
		map.put("jobtitle",job.getJobTitlesname(user.getJobtitle())); 
		map.put("deptName", dept.getDepartmentname(user.getUserDepartment()+"")); 
		
		jo.put("userInfo",JSONObject.fromObject(map).toString());
		
		out.println(jo.toString());
		return;
		
	}else{//保存失败
		result.put("result", "0");//失败
	}
}else if("viewBlog".equals(type)){//追加微博
	PluginServiceImpl ps = new PluginServiceImpl();
	JSONObject jo=ps.getBlogJson(fu);
	out.println(jo.toString());
	return;
}else if("blogReport".equals(type)){//微博统计.填写人员和未填写人员
	result.put("result","0");
	String who = Util.null2String(fu.getParameter("who"));
	String workdate = Util.null2s(fu.getParameter("date"), TimeUtil.getCurrentDateString());
	String ids="";
	RecordSet rs=new RecordSet();
	if("subordinate".equals(who)){//下属
		rs.execute("select id from HrmResource where status<4 and managerid='"+userId+"' order by id ");
	}else if("team".equals(who)){//同部门
		rs.execute("select id from HrmResource where status<4 and departmentid='"+user.getUserDepartment()+"' order by id ");
	}else{
		rs.execute("select id from HrmResource where 1=2");
	}
	String temp_userid="";
	while(rs.next()){
		temp_userid=rs.getString("id");
		if(temp_userid.equals(userId)) continue;//排除自己
		ids+=("".equals(ids)?"":",")+rs.getString("id");
	}
	
	if(!"".equals(ids)){
		BlogForXiaoE blog=new BlogForXiaoE();
		result.putAll(blog.getStatistics(ids, workdate));
		result.put("result","1");
	}
}else if("MeetingParam".equals(type)){//获取会议类型初始参数
	result.put("result","0");
	XmlConf conf= LoadXmlConf.getInstance().loadXml("Meeting");
	if(conf!=null){
		XmlBean bean=conf.getFieldMap().get("meetingtype");
		if(bean!=null){
			String meetingtype=Util.null2String(bean.getDefaultV());
			if(!"".equals(meetingtype)){
				RecordSet rs=new RecordSet();
				rs.execute("select 1 from Meeting_Type where id="+meetingtype);
				if(!rs.next()){//指定类型不存在. 清空
					meetingtype="";
				}
			}
			MeetingSetInfo meetingSetInfo=new MeetingSetInfo();
			if(meetingSetInfo.getRoomConflictChk()==1){
				result.put("roomcheck",meetingSetInfo.getRoomConflict());
			}else{
				result.put("roomcheck","0");//未开启会议室冲突
			}
			
			LN ln=new LN();
			String version=ln.getEcologyBigVersion();
			if("8".equals(version)){//E8版本.必须指定会议类型
				if(!"".equals(meetingtype)){
					result.put("result","1");
					result.put("meetingtype",meetingtype);
				}
			}else{
				result.put("result","1");
				result.put("meetingtype",meetingtype);
			}
		}
	}
	
}else if("loadMeetingAddress".equals(type)){//加载空闲会议室
	result.put("result","0");
	String begindate = Util.null2String(fu.getParameter("begindate"));
	String begintime = Util.null2String(fu.getParameter("begintime"));
	String enddate = Util.null2String(fu.getParameter("enddate"));
	String endtime = Util.null2String(fu.getParameter("endtime"));
	String key = Util.null2String(fu.getParameter("key"));
	if(!"".equals(begindate)&&!"".equals(begintime)&&!"".equals(enddate)&&!"".equals(endtime)){
		if(begintime.length()==8) begintime=begintime.substring(0,5);
		if(endtime.length()==8) endtime=endtime.substring(0,5);
		//查询当前时间被占用会议室
		Set used=new LinkedHashSet();
		RecordSet rs=new RecordSet();
		if("oracle".equalsIgnoreCase(rs.getDBType())){
			rs.execute("SELECT address from meeting where meetingstatus in(1,2) and repeatType = 0 and isdecision<2 and (cancel is null or cancel<>'1') and begindate||' '||begintime <'"+enddate+" "+endtime+"' and enddate||' '||endtime>'"+begindate+" "+begintime+"'");
		}else if("mysql".equalsIgnoreCase(rs.getDBType())){
			rs.execute("SELECT address from meeting where meetingstatus in(1,2) and repeatType = 0 and isdecision<2 and (cancel is null or cancel<>'1') and concat(begindate,' ',begintime) <'"+enddate+" "+endtime+"' and concat(enddate,' ',endtime)>'"+begindate+" "+begintime+"'");
		}else{
			rs.execute("SELECT address from meeting where meetingstatus in(1,2) and repeatType = 0 and isdecision<2 and (cancel is null or cancel<>'1') and begindate+' '+begintime <'"+enddate+" "+endtime+"' and enddate+' '+endtime>'"+begindate+" "+begintime+"'");
		}
		while(rs.next()){
			String address=rs.getString("address");
			String[] addresss=address.split(",");
			for(String s:addresss){
				if("".equals(s)) continue;
				used.add(s);
			}
		}
		//查询可用会议室列表
		if(!"".equals(key)){
			String key1=NumberUtil.IntNumber2Chinese(key);
			String key2=NumberUtil.chineseNumber2Int(key);
			String keySql=" a.name like '%"+key+"%' ";
			if(!"".equals(key1)&&!key1.equals(key)){
				keySql+=" or a.name like '%"+key1+"%' ";
			}
			if(!"".equals(key2)&&!key2.equals(key)){
				keySql+=" or a.name like '%"+key2+"%' ";
			}
			rs.execute("select a.id,a.name from MeetingRoom a  where  ("+keySql+") and (a.status=1 or a.status is null ) "+ MeetingShareUtil.getRoomShareSql(user)+" ORDER BY a.dsporder,a.name");
		}else{
			rs.execute("select a.id,a.name from MeetingRoom a  where  (a.status=1 or a.status is null ) "+ MeetingShareUtil.getRoomShareSql(user)+" ORDER BY a.dsporder,a.name");
		}
		Map map=null;
		List addressList=new LinkedList();
		int i=1;
		while(rs.next()){
			map=new HashMap();
			map.put("id",rs.getString("id"));
			map.put("name",Util.formatMultiLang(rs.getString("name"),""+user.getLanguage()));
			if(used.contains(rs.getString("id"))){
				map.put("used","1");
			}else{
				map.put("used","0");
			}
			addressList.add(map);
			i++;
			if(i>50){
				break;
			}
		}
 
		result.put("list",addressList);
		result.put("size",addressList.size());
		result.put("result","1");
	}
	
}else if("loadConflictMeeting".equals(type)){//加载冲突会议
	result.put("result","0");
	String begindate = Util.null2String(fu.getParameter("begindate"));
	String begintime = Util.null2String(fu.getParameter("begintime"));
	String enddate = Util.null2String(fu.getParameter("enddate"));
	String endtime = Util.null2String(fu.getParameter("endtime"));
	String address = Util.null2String(fu.getParameter("address"));
	List list=new LinkedList();
	int count=0;
	if(!"".equals(begindate)&&!"".equals(begintime)&&!"".equals(enddate)&&!"".equals(endtime)){
		if(begintime.length()==8) begintime=begintime.substring(0,5);
		if(endtime.length()==8) endtime=endtime.substring(0,5);
		ResourceComInfo rsc=new  ResourceComInfo();
		//查询当前时间被占用会议室
		RecordSet rs=new RecordSet();
		if("oracle".equalsIgnoreCase(rs.getDBType())){
			rs.execute("SELECT id,name,caller, address,begindate,begintime,enddate,endtime from meeting where meetingstatus in(1,2) and repeatType = 0 and isdecision<2 and (cancel is null or cancel<>'1') and begindate||' '||begintime <'"+enddate+" "+endtime+"' and enddate||' '||endtime>'"+begindate+" "+begintime+"'");
		}else if("mysql".equalsIgnoreCase(rs.getDBType())){
			rs.execute("SELECT id,name,caller, address,begindate,begintime,enddate,endtime from meeting where meetingstatus in(1,2) and repeatType = 0 and isdecision<2 and (cancel is null or cancel<>'1') and concat(begindate,' ',begintime) <'"+enddate+" "+endtime+"' and concat(enddate,' ',endtime)>'"+begindate+" "+begintime+"'");
		}else{
			rs.execute("SELECT id,name,caller, address,begindate,begintime,enddate,endtime from meeting where meetingstatus in(1,2) and repeatType = 0 and isdecision<2 and (cancel is null or cancel<>'1') and begindate+' '+begintime <'"+enddate+" "+endtime+"' and enddate+' '+endtime>'"+begindate+" "+begintime+"'");
		}
		Map map=null;
		while(rs.next()){
			String temp_address=Util.null2String(rs.getString("address"));
			
			//当前选择会议室被占用的会议
			if((","+temp_address+",").indexOf(","+address+",")>-1){
				map=new HashMap();
				
				map.put("schema","MEETING");
				map.put("id",rs.getString("id"));
				map.put("simpleTitle",rs.getString("name"));
				map.put("simpleDesc","召集人："+rsc.getLastname(rs.getString("caller")));
				map.put("url","");
				map.put("begindate",rs.getString("begindate"));
				map.put("begintime",rs.getString("begintime"));
				map.put("enddate",rs.getString("enddate"));
				map.put("endtime",rs.getString("endtime"));
				list.add(map);
			}
			
		}
		count=list.size();
		result.put("result","1");
	}
	result.put("list",list);
	result.put("count",count);
	
}else if("submitMeeting".equals(type)){//提交会议
	result.put("result","0");
	
	String meetingtype=Util.null2String(fu.getParameter("meetingtype"));//会议类型
	//基本信息
	String name=Util.null2String(fu.getParameter("content"));//会议名称
	String caller=userId;
	String contacter=userId;
	
	int roomType = 1;
	String address=Util.null2String(fu.getParameter("addressId"));//会议地点
	String addressName = Util.null2String(fu.getParameter("addressName"));
	String customizeAddress=addressName;
	if(!"".equals(address)){//优先选择会议室
		customizeAddress="";
	}else{//自定义会议室
		roomType=2;
	}
	String desc=name;
	 
	//时间
	int repeatType =0;//是否是重复会议,0 正常会议.
	String begindate=Util.null2String(fu.getParameter("begindate"));
	String enddate=Util.null2String(fu.getParameter("enddate"));
	String begintime=Util.null2String(fu.getParameter("begintime"));
	String endtime=Util.null2String(fu.getParameter("endtime"));
	//提醒方式和时间
	String remindTypeNew="";//新的提示方式
	int remindImmediately = 0;  //是否立即提醒 
	int remindBeforeStart =0;  //是否开始前提醒
	int remindBeforeEnd = 0;  //是否结束前提醒
	int remindHoursBeforeStart =0;//开始前提醒小时
	int remindTimesBeforeStart = 0;  //开始前提醒时间
    int remindHoursBeforeEnd = 0;//结束前提醒小时
    int remindTimesBeforeEnd =0;  //结束前提醒时间
	//参会人员
    String hrmmembers=userId;//参会人员
    int totalmember=1;//参会人数
	String othermembers="";//其他参会人员
	String crmmembers="";//参会客户
	int crmtotalmember=0;//参会人数
	
	int remindType = 1;  //老的提醒方式,默认1不提醒
    
	char flag = 2;
	String ProcPara = "";
	
    String description = SystemEnv.getHtmlLabelNames("84535,2103",user.getLanguage())+": "+name+SystemEnv.getHtmlLabelName(81901,user.getLanguage())+"   :"+begindate+" "+begintime+SystemEnv.getHtmlLabelName(2105,user.getLanguage())+" :"+addressName;
    ProcPara =  meetingtype;
	ProcPara += flag + name;
	ProcPara += flag + userId;
	ProcPara += flag + userId;
	ProcPara += flag + ""; //加入项目id
	ProcPara += flag + address;
	ProcPara += flag + begindate;
	ProcPara += flag + begintime;
	ProcPara += flag + enddate;
	ProcPara += flag + endtime;
	ProcPara += flag + desc;
	ProcPara += flag + userId;
	ProcPara += flag + TimeUtil.getCurrentDateString();
	ProcPara += flag + TimeUtil.getOnlyCurrentTimeString();
    ProcPara += flag + "1";
    ProcPara += flag + "";
    ProcPara += flag + "";
    ProcPara += flag + description;
    ProcPara += flag + ""+remindType;
    ProcPara += flag + ""+remindBeforeStart;
    ProcPara += flag + ""+remindBeforeEnd;
    ProcPara += flag + ""+remindTimesBeforeStart;
    ProcPara += flag + ""+remindTimesBeforeEnd;
    ProcPara += flag + customizeAddress;
    
    RecordSet RecordSet=new RecordSet();
    
    if (RecordSet.getDBType().equals("oracle"))
	{
		RecordSet.executeProc("Meeting_Insert",ProcPara);
    
		RecordSet.executeSql("SELECT max(id) FROM Meeting where creater = "+userId);
	}
	else
	{
		RecordSet.executeProc("Meeting_Insert",ProcPara);
	}
	RecordSet.next();
	String MaxID = RecordSet.getString(1);

	String updateSql = "update Meeting set repeatType = 0 ,repeatdays='' ,repeatweeks =0,rptWeekDays = '', repeatbegindate = '"+ begindate +"', repeatenddate = '"+ enddate 
					+"', repeatmonths = 0, repeatmonthdays = 0, repeatStrategy = 0, roomType = "+ roomType+" , remindTypeNew = '' , remindImmediately = "+ 0
					+" , remindHoursBeforeStart = 0, remindHoursBeforeEnd =0, hrmmembers = '"+ userId+"', crmmembers = '', crmtotalmember =0 , accessorys = ''  where id = " + MaxID;

	RecordSet.executeSql(updateSql);
 	
	//自己是参会人
	ProcPara =  MaxID;
	ProcPara += flag + "1";
	ProcPara += flag + "" + userId;
	ProcPara += flag + "" + userId;
	RecordSet.executeProc("Meeting_Member2_Insert",ProcPara);
	
	//标识会议是否查看过
	StringBuffer stringBuffer = new StringBuffer();
	stringBuffer.append("INSERT INTO Meeting_View_Status(meetingId, userId, userType, status) VALUES(");
	stringBuffer.append(MaxID);
	stringBuffer.append(", ");
	stringBuffer.append(userId);
	stringBuffer.append(", '");
	stringBuffer.append("1");
	stringBuffer.append("', '");
	stringBuffer.append("1");
	stringBuffer.append("')");
	RecordSet.executeSql(stringBuffer.toString());
	
	new MeetingViewer().setMeetingShareById(""+MaxID);
	new MeetingComInfo().removeMeetingInfoCache();
	//判断会议类型提交问题
	LN ln=new LN();
	String version=ln.getEcologyBigVersion();
	String approvewfid="";
	if("8".equals(version)){//E8版本.必须指定会议类型
		if(!meetingtype.equals("")){
        	RecordSet.executeSql("Select approver,formid From Meeting_Type t1 join workflow_base t2 on t1.approver=t2.id  where t1.approver>0 and t1.ID ="+meetingtype);
            RecordSet.next();
            approvewfid = RecordSet.getString(1);
        }
	}else{
		if(!meetingtype.equals("")){
        	RecordSet.executeSql("Select approver,formid From Meeting_Type t1 join workflow_base t2 on t1.approver=t2.id  where t1.approver>0 and t1.ID ="+meetingtype);
            RecordSet.next();
            approvewfid = RecordSet.getString(1);
        }
    	if(approvewfid.equals("0")||approvewfid.equals("")){//如果没有指定审批工作流 查询是否存在默认审批流程
        	RecordSet.executeSql("Select defaultapprover,formid From meetingset t1 join workflow_base t2 on t1.defaultapprover=t2.id  where t1.defaultapprover>0");
            RecordSet.next();
            approvewfid = RecordSet.getString(1);
    	}
	}
	String meetingstatus="";
	if(!"0".equals(approvewfid)&&!"".equals(approvewfid)){
		MeetingCreateWFUtil.createWF(MaxID,user,approvewfid,"voice");
		result.put("result","1");
		RecordSet.execute("select meetingstatus from meeting where id='"+MaxID+"'");
		RecordSet.next();
		meetingstatus= RecordSet.getString(1);
	}else{
		RecordSet.executeSql("Update Meeting Set meetingstatus = 2 WHERE id="+MaxID);//更新会议状态为正常
		MeetingLog meetingLog=new MeetingLog();
		meetingLog.resetParameter();
       	meetingLog.insSysLogInfo(user,Util.getIntValue(MaxID),name,"新建正常会议","303","1",1,"voice");
       	//生成会议日程和会议提醒
        MeetingInterval.createWPAndRemind(MaxID,null,"voice");
        result.put("result","1");
        meetingstatus="2";
	}
	
	Map map=new HashMap();
	map.put("schema","MEETING");
	map.put("id",MaxID);
	map.put("simpleTitle",name+"&nbsp;&nbsp;("+new SptmForMeeting().getMeetingStatus(meetingstatus,user.getLanguage()+"+"+enddate+"+"+endtime+"+0")+")");
	map.put("simpleDesc","召集人："+user.getLastname());
	map.put("url","");
	map.put("begindate",begindate);
	map.put("begintime",begintime);
	map.put("enddate",enddate);
	map.put("endtime",endtime);
	map.put("address",addressName+((roomType==2)?"&nbsp;&nbsp;(自定义)":"")); 
	
	result.put("item",map);	 
	
}else if("ReportParam".equals(type)){//自定义报表
	result.put("result","0");
	String reportType=Util.null2String(fu.getParameter("reportType"));//报表类型
	XmlConf conf= LoadXmlConf.getInstance().loadXml("Report_"+reportType);
	if(conf!=null){
		XmlBean bean=conf.getFieldMap().get("url");
		if(bean!=null){
			String url=Util.null2String(bean.getDefaultV());
			if(!"".equals(url)){
				result.put("result","1"); 
				result.put("url",url); 
				result.put("map",conf.getFieldMap()); 
				result.put("retList",conf.getReturnList()); 
				result.put("retFlag",conf.getReturnFlag()); 
				result.put("statList",conf.getStatisticsList()); 
			}
		}
	}
}else if("getDateRange".equals(type)){//获取报表时间区间
	String date = Util.null2String(fu.getParameter("date"));
	String datetype = Util.null2String(fu.getParameter("datetype"));//1 指定天 2 周  3月 4年
	String dif = Util.null2String(fu.getParameter("dif"));
	if("".equals(date)){
		date=TimeUtil.getCurrentDateString();
	}
	String fromDate="";
	String toDate="";
	
	if("4".equals(datetype)){//年
		Date yearDate=TimeUtil.getString2Date(date,"yyyy-MM-dd");
		GregorianCalendar gc = (GregorianCalendar) Calendar.getInstance();
		gc.setTime(yearDate);
		gc.set(Calendar.DAY_OF_YEAR, 1);
		fromDate=TimeUtil.getDateString(gc.getTime());
		
		gc.set(Calendar.MONTH, Calendar.DECEMBER+1);
		gc.set(Calendar.DAY_OF_MONTH, 0);
		toDate=TimeUtil.getDateString(gc.getTime());
		result.put("year",fromDate.split("-")[0]);
	}else if("3".equals(datetype)){//月份
		if("-1".equals(dif)){//上个月
			fromDate=TimeUtil.getDateByOption("7","0");
			toDate=TimeUtil.getDateByOption("7","1");
		}else if("1".equals(dif)){//下个月
			Calendar cal = Calendar.getInstance(); 
			cal.add(Calendar.MONTH, 1);
			cal.set(GregorianCalendar.DAY_OF_MONTH, 1); 
	        fromDate=TimeUtil.getDateString(cal);
	        cal.set( Calendar.DATE, 1 );
	        cal.roll(Calendar.DATE, - 1 );
	        toDate=TimeUtil.getDateString(cal);
		}else{//根据 date 指定月份
			fromDate=TimeUtil.getMonthBeginDay(date);
			toDate=TimeUtil.getMonthEndDay(date);
		} 
		result.put("year",fromDate.split("-")[0]);
		result.put("month",fromDate.split("-")[1]);
	}else if("2".equals(datetype)){//周
		if("-1".equals(dif)){//上周
			String lastWeekDateStr=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-7);
			Date lastWeekDate=TimeUtil.getString2Date(lastWeekDateStr,"yyyy-MM-dd");
			fromDate=TimeUtil.getDateString(TimeUtil.getFirstDayOfWeek(lastWeekDate));
			toDate=TimeUtil.getDateString(TimeUtil.getLastDayOfWeek(lastWeekDate));
		}else if("1".equals(dif)){//下周
			String nextWeekDateStr=TimeUtil.dateAdd(date,7);
			Date nextWeekDate=TimeUtil.getString2Date(nextWeekDateStr,"yyyy-MM-dd");
			fromDate=TimeUtil.getDateString(TimeUtil.getFirstDayOfWeek(nextWeekDate));
			toDate=TimeUtil.getDateString(TimeUtil.getLastDayOfWeek(nextWeekDate));
		}else{//本周
			fromDate=TimeUtil.getDateByOption("2","0");
			toDate=TimeUtil.getDateByOption("2","1");
		} 
	}else{//指定天
		fromDate=toDate=date;
	}
	result.put("fromDate",fromDate);
	result.put("toDate",toDate);
}else if("saveCrmContact".equals(type)){//客户联系
	 
	String crmId = Util.null2String(fu.getParameter("crmId"));
	String crmName = Util.null2String(fu.getParameter("crmName"));
	String description = Util.null2String(fu.getParameter("content"));	//内容
	String date = Util.null2String(fu.getParameter("date"));	//客户联系日期.如果为空.默认今天
	
	if("".equals(crmId)||"".equals(crmName)||"".equals(description)){
		result.put("result", "0");//失败
	}else{
		String currDate = TimeUtil.getCurrentDateString();
		String currTime = TimeUtil.getOnlyCurrentTimeString().substring(0, 5);
		if("".equals(date)){
			date=currDate;
		}
		
		WorkPlanService workPlanService = new WorkPlanService();
		
		WorkPlan workPlan = new WorkPlan();
	    workPlan.setCreaterId(user.getUID());
	    workPlan.setCreateType(Integer.parseInt(user.getLogintype()));
	    workPlan.setWorkPlanType(Integer.parseInt(Constants.WorkPlan_Type_CustomerContact));        
	    workPlan.setWorkPlanName(crmName + "-" + SystemEnv.getHtmlLabelName(6082, user.getLanguage()));    
	    workPlan.setUrgentLevel(Constants.WorkPlan_Urgent_Normal);
	    workPlan.setRemindType(Constants.WorkPlan_Remind_No);  
	    workPlan.setResourceId(String.valueOf(user.getUID()));
	    workPlan.setBeginDate(date);  //开始日期
	    workPlan.setBeginTime("09:00");  //开始时间  
	    workPlan.setDescription(description);
	    workPlan.setStatus(Constants.WorkPlan_Status_Archived);  //直接归档
	    workPlan.setCustomer(crmId);
	    workPlan.setDocument("");
	    workPlan.setWorkflow("");
	    workPlan.setTask("");
	    workPlanService.insertWorkPlan(workPlan);  //插入日程
	    String workplanid = workPlan.getWorkPlanID()+"";
		//插入日志
		String[] logParams = new String[]{workplanid,
									WorkPlanLogMan.TP_CREATE,
									userId,
									"小e"};
		WorkPlanLogMan logMan = new WorkPlanLogMan();
		logMan.writeViewLog(logParams);
		
		result.put("result", "1");
		result.put("createdate",currDate+" "+currTime);
		
	}
}else if("saveTrackInfo".equals(type)){//日志收集
	String trackJson = Util.null2String(fu.getParameter("trackJson"));
	TrackInfoUtil.saveTrackInfo(user,trackJson); 
	result.put("result", "1");
}else if("loadFeeType".equals(type)){//加载费用科目
	String bdf_wfid = Util.null2String(fu.getParameter("bdf_wfid"));
	String bdf_fieldid = Util.null2String(fu.getParameter("bdf_fieldid"));
	String key = Util.null2String(fu.getParameter("q"));

	RecordSet rs=new RecordSet();
	RecordSet rs2=new RecordSet();
	
	String whereClause=" 1=1 ";
	String plusChar = "+";
	if("oracle".equalsIgnoreCase(rs.getDBType())){
		plusChar = "||";
	}
	
	//路径设置浏览按钮数据
	//科目过滤
	if(Util.getIntValue(bdf_wfid) > 0 && Util.getIntValue(bdf_fieldid) > 0){
		String sql = " SELECT count(*) cnt \n" +
			" from FnaFeetypeWfbrowdef_dt1 t1 \n" +
			" join FnaFeetypeWfbrowdef t2 on t1.mainid = t2.id \n" +
			" where t2.fieldType = "+BudgetfeeTypeComInfo.FNAFEETYPE_FIELDTYPE+"\n" +
			" and t2.fieldId = "+Util.getIntValue(bdf_fieldid)+"\n" +
			" and t2.workflowid = "+Util.getIntValue(bdf_wfid)+" ";
		rs.executeSql(sql);
		if(rs.next() && rs.getInt("cnt") > 0){
			String wfFeetypeClause = " ( exists ( "+
					" SELECT 1 \n" +
					" from FnaFeetypeWfbrowdef_dt1 t1 \n" +
					" join FnaFeetypeWfbrowdef t2 on t1.mainid = t2.id \n" +
					" join FnaBudgetfeeType t3 on t1.refid = t3.id \n" +
					" where a.allSupSubjectIds like (t3.allSupSubjectIds"+plusChar+"'%') \n"+
					" and t2.fieldType = "+BudgetfeeTypeComInfo.FNAFEETYPE_FIELDTYPE+"\n" +
					" and t2.fieldId = "+Util.getIntValue(bdf_fieldid)+"\n" +
					" and t2.workflowid = "+Util.getIntValue(bdf_wfid)+"\n"+
					" ) ) ";
			if(!"".equals(whereClause)){
				whereClause += " and ";
			}
			whereClause += wfFeetypeClause;
		}
	}
	
	if(!"".equals(whereClause)){
		whereClause += " and ";
	}
	
	whereClause += " (a.Archive is null or a.Archive = 0) and a.isEditFeeTypeId > 0 ";

	rs.execute("select a.id,a.name from FnaBudgetfeeType a where "+whereClause+" and a.name like '%"+key+"%'");
	
	Map map=null;
	List feetypeList=new LinkedList();
	int i=1;
	BudgetfeeTypeComInfo budgetfeeTypeComInfo=new BudgetfeeTypeComInfo();
	while(rs.next()){
		map=new HashMap();
		map.put("id",rs.getString("id"));
		map.put("name",rs.getString("name"));
		map.put("fullName",budgetfeeTypeComInfo.getSubjectFullName(rs.getString("id"), "->"));
		i++;
		if(i>50){
			break;
		}
		feetypeList.add(map);
	}
	result.put("list",feetypeList);
	result.put("size",feetypeList.size());
	result.put("result","1");
 
}else if("Forward".equals(type)){//用于异构系统的请求转发,兼容不支持的跨越请求.
	String url=fu.getParameter("uri");
	String SuccessF=fu.getParameter("SuccessF");
	String SuccessV=fu.getParameter("SuccessV");
	String Encode=fu.getParameter("Encode");
	if("".equals(Encode)) Encode="UTF-8";
	if(!"".equals(url)){
		url=URLDecoder.decode(url,"UTF-8");
		Enumeration enu=fu.getParameterNames();
		try {
			DefaultHttpClient client = HttpManager.getHttpClient();
			HttpPost post = new HttpPost(url);
	       	
			List<BasicNameValuePair> params = new ArrayList<BasicNameValuePair>();
			
			while(enu.hasMoreElements()){
				String objKey=Util.null2String(enu.nextElement());
				if("uri".equals(objKey)||"SuccessF".equals(objKey)||"SuccessV".equals(objKey)||"type".equals(objKey)||"clienttype".equals(objKey)||"viewmodule".equals(objKey)||"sessionkey".equals(objKey)) continue;
				params.add(new BasicNameValuePair(objKey, Util.null2String(fu.getParameter(objKey))));
			}
			post.setEntity(new UrlEncodedFormEntity(params, Encode));
			
	        HttpResponse resp = client.execute(post);
	        if (resp.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {
	        	ByteArrayOutputStream  baos  = new  ByteArrayOutputStream(); 
	        	resp.getEntity().writeTo(baos);
	        	out.println(baos.toString(Encode));
	        	return;
	        }
		}catch (Exception e) {
			e.printStackTrace();
        }
	}
	result.put("SuccessF",SuccessV+"1");//标记失败
}else if("chatShare".equals(type)){//聊天分享
	String resourcetype=fu.getParameter("resourcetype");  //0:流程 1：文档， 2：任务， 3：项目， 4：资产
	String resourceid=fu.getParameter("resourceid"); //资源id.
	String resources = Util.null2String(fu.getParameter("resourceids"));//分享范围人员ID集合， 以逗号分隔
	int sharer = user.getUID();
	if(Util.getIntValue(resources)<0){//群组 //4df85fae-afea-4040-b5b3-9ec5416d4aa8
		String resourcesJson=SocialIMClient.getGroupInfo(resources);
		JSONObject jo = JSONObject.fromObject(resourcesJson);
		resources=Util.null2String(jo.get("adminUserId"));
		String membersId=Util.null2String(jo.get("membersId"));
		if(!"".equals(membersId)){
			if("".equals(resources)){
				resources=membersId;
			}else{
				resources+=","+membersId;
			}
		}
	}
	boolean ret = ChatResourceShareManager.addShare(Util.getIntValue(resourcetype), Util.getIntValue(resourceid), sharer, "", resources);
	result.put("result",ret); 
}else if("getSignStatus".equals(type)){//获取签到相关参数
	result.put("result","0"); 
	HrmScheduleSignManager signManager = new HrmScheduleSignManager();
	HrmScheduleSign bean = signManager.getSignData(user.getUID());//传递用户ID
	List<ScheduleSignButton> currentButtons = bean.getCurrentSignButtons();	//获取当前签到组.(签到和签退).
	if(bean.isSchedulePerson() || bean.isWorkDay()||!bean.getSignSet().isOnlyWorkday()){
		for(int i=0;i<currentButtons.size();i++){
			result.put("result","1"); 
			ScheduleSignButton ssb = currentButtons.get(i);
			if(i==0){
				result.put("hasCheckIn",ssb.isSign());
			}else{
				result.put("canCheckOut",result.get("hasCheckIn"));				
			}
		}
	}
}else if("getTimeNLP".equals(type)){//时间语义获取时间.
	result.put("result","0"); 
	String timeSlot=Util.null2String(fu.getParameter("timeSlot"));
	if(!"".equals(timeSlot)){
		TimeNormalizer normalizer = new TimeNormalizer();
		normalizer.setPreferFuture(false);
		normalizer.parse(timeSlot);// 抽取时间
		TimeUnit[] unit = normalizer.getTimeUnit();
		if(unit.length>0){
			result.put("result","1"); 
			for(int i=0;i<unit.length;i++){
				result.put("date"+(i+1),com.time.util.DateUtil.formatJustDateDefault(unit[i].getTime()));
				result.put("time"+(i+1),com.time.util.DateUtil.formatJustTimeDefault(unit[i].getTime()));
			}
		}
	}
}else if("FreeWorkplanRSC".equals(type)){//空闲人员
	
	String begindate=Util.null2String(fu.getParameter("begindate"));
	String begintime=Util.null2String(fu.getParameter("begintime"));
	String enddate=Util.null2String(fu.getParameter("enddate"));
	String endtime=Util.null2String(fu.getParameter("endtime"));
	String hrmids=Util.null2String(fu.getParameter("hrmids"));
	
	int count=0;
	List list=new LinkedList();
	if(!"".equals(hrmids)){
		Set<String> hrmSet=WorkPlanEUtil.freeHrm(hrmids,begindate,begintime,enddate,endtime);
		
		
		Map map=null;
		Map other=null;
		ResourceComInfo rsc=new ResourceComInfo();
		JobTitlesComInfo job=new JobTitlesComInfo(); 
		SubCompanyComInfo subcomp=new SubCompanyComInfo();
		DepartmentComInfo dept=new DepartmentComInfo();
		for(String s:hrmSet){
			map=new HashMap();
			other=new HashMap();
			
			map.put("schema","RSC");
			map.put("id",s);
			map.put("simpleTitle",rsc.getLastname(s));
			map.put("simpleDesc","");
			map.put("url","");
			
			other.put("URL",rsc.getMessagerUrls(s));
			other.put("SEX",rsc.getSexs(s)); 
			other.put("MOBILE",rsc.getMobile(s)); 
			other.put("SUBCOMP",subcomp.getSubcompanyname(rsc.getSubCompanyID(s))); 
			other.put("JOBTITLENAME",job.getJobTitlesname(rsc.getJobTitle(s))); 
			other.put("DEPT", dept.getDepartmentname(rsc.getDepartmentID(s))); 
				
			map.put("other",JSONObject.fromObject(other).toString());
			list.add(map);
			
		}
	}
	result.put("list",list);
	result.put("count",count);

}else if("checkHrmFree".equals(type)){//判断是否有人没空.部门含自己
	result.put("result","0");

	String begindate=Util.null2String(fu.getParameter("begindate"));
	String begintime=Util.null2String(fu.getParameter("begintime"));
	String enddate=Util.null2String(fu.getParameter("enddate"));
	String endtime=Util.null2String(fu.getParameter("endtime"));
	String who=Util.null2String(fu.getParameter("who"));
	String rscName="";
	RecordSet rs=new RecordSet();
	if("subordinate".equals(who)){//下属
		rs.execute("select id,lastname from HrmResource where status<4 and managerid='"+userId+"' order by id ");
	}else if("team".equals(who)){//同部门
		rs.execute("select id,lastname from HrmResource where status<4 and departmentid='"+user.getUserDepartment()+"' order by id ");
	}else{
		rs.execute("select id,lastname from HrmResource where 1=2");
	}
	String hrmids="";
	String hrmnames="";
	String temp_userid="";
	Map<String,String> hrmMap=new LinkedHashMap<String,String>();
	Set<String> old_hrmSet=new HashSet<String>();
	while(rs.next()){
		temp_userid=rs.getString("id");
		old_hrmSet.add(temp_userid);
		hrmids+=("".equals(hrmids)?"":",")+temp_userid;
		hrmnames+=("".equals(hrmnames)?"":",")+rs.getString("lastname");
	}
	
	if(old_hrmSet.size()>0){
		Set<String> hrmSet=WorkPlanEUtil.freeHrm(hrmids,begindate,begintime,enddate,endtime);
		result.put("result","1");
		result.put("count",old_hrmSet.size()-hrmSet.size());
		result.put("rscId",hrmids);
		result.put("rscName",hrmnames);
	}

}else if("getHrmFreeTime".equals(type)){//获取人员空闲时间段,供交互人员参照.
	result.put("result","0");
	
	String date=Util.null2String(fu.getParameter("date"));
	String hrmids=Util.null2String(fu.getParameter("hrmids"));
	
	if(!"".equals(hrmids)&&!"".equals(date)){
		Date dateDate=TimeUtil.getString2Date(date,"yyyy-MM-dd");
		String begindate=TimeUtil.getDateString(TimeUtil.getFirstDayOfWeek(dateDate));
		String enddate=TimeUtil.getDateString(TimeUtil.getLastDayOfWeek(dateDate));
		ArrayList<HashMap<String,String>>  timeList=WorkPlanEUtil.searchFreeTime(hrmids,begindate,enddate);
		result.put("result","1");
		result.put("list",timeList);
	}

}else if("TeamWorking".equals(type)){//团队成员工作统计
	result.put("result","1");
	String who = Util.null2String(fu.getParameter("who"));
	String begindate = Util.null2String(fu.getParameter("begindate"));
	String enddate = Util.null2String(fu.getParameter("enddate"));
	String needKQ = Util.null2String(fu.getParameter("kq"),"1");
	//其中有个日期为空.默认本年
	if("".equals(begindate)||"".equals(enddate)){
		Calendar today = Calendar.getInstance();
		String year = Util.add0(today.get(Calendar.YEAR), 4);
		begindate=year+"-01-01";
		enddate=year+"-12-31";
	}
	String ids="";
	String dateShow="从"+begindate+"至"+enddate;
	if(begindate.equals(enddate)){
		dateShow=begindate;
	}
	RecordSet rs=new RecordSet();
	if("subordinate".equals(who)){//下属
		result.put("DisplayStr","以下是您的下属"+dateShow+"工作情况");
		rs.execute("select id,lastname from HrmResource where status<4 and managerid='"+userId+"' order by id ");
	}else if("team".equals(who)){//同部门
		result.put("DisplayStr","以下是您所在团队"+dateShow+"工作情况");
		rs.execute("select id,lastname from HrmResource where status<4 and departmentid='"+user.getUserDepartment()+"' order by id ");
	}else{
		rs.execute("select id,lastname from HrmResource where 1=2");
	}
	String temp_userid="";
	Map<String,String> hrmMap=new LinkedHashMap<String,String>();
	while(rs.next()){
		temp_userid=rs.getString("id");
		hrmMap.put(temp_userid,rs.getString("lastname"));
		ids+=("".equals(ids)?"":",")+rs.getString("id");
	}
	//培训参与情况、考勤情况、知识贡献度，知识的阅读、客户的滚动、商机的滚动、工作微博的填写
	//文档相关
	DocForE doc=new DocForE();
	Map docCreateMap=doc.getCreaterCount(ids,begindate,enddate);
	Map docReadMap=doc.getReadCount(ids,begindate,enddate);
	//考勤相关
	HrmResource4EService hrm=new HrmResource4EService();
	Map kqMap=null;
	if("1".equals(needKQ)){
		kqMap=hrm.getScheduleStatistics(ids,begindate,enddate);
	}
	//培训相关
	Map pxMap=hrm.getTrainStatistics(ids,begindate,enddate);
	//微博
	BlogForXiaoE blog=new BlogForXiaoE();
	Map blogMap=blog.getBlogStatistics(ids,begindate,enddate);
	//客户和商机
	Map crmRollMap=null;
	Map sellRoleMap=null;
	try{
        Class clazz = Class.forName("weaver.plugin.util.GetDataUtil");
        Object object = clazz.newInstance();
        Method method = clazz.getMethod("getMapData", String.class, String.class,String.class,String.class);  
        //客户滚动
        Object obj=method.invoke(object, "khgd",ids,begindate,enddate);
        crmRollMap=(Map)obj;
        //商机滚动
        obj=method.invoke(object, "sjgd",ids,begindate,enddate);
        sellRoleMap=(Map)obj;
    } catch (Exception e) {
    	
    }
    //构建数据
    List list=new LinkedList();
	Map map=null;
	Map temp_map=null;
	Iterator<String> it=hrmMap.keySet().iterator();
	while(it.hasNext()){
		temp_userid=it.next();
		map=new HashMap();
		map.put("id",temp_userid);
		map.put("name",hrmMap.get(temp_userid));
		map.put("train",ECommonUtil.getStringFromMap(pxMap,temp_userid,"0"));
		temp_map=ECommonUtil.getMapFromMap(kqMap,temp_userid);
		map.put("belate",ECommonUtil.getStringFromMap(temp_map,"belatecounts","0"));
		map.put("leaveearly",ECommonUtil.getStringFromMap(temp_map,"leaveearlycounts","0"));
		map.put("absent",ECommonUtil.getStringFromMap(temp_map,"absentcounts","0"));
		map.put("docCreate",ECommonUtil.getStringFromMap(docCreateMap,temp_userid,"0"));
		map.put("docRead",ECommonUtil.getStringFromMap(docReadMap,temp_userid,"0"));
		map.put("blog",ECommonUtil.getStringFromMap(blogMap,temp_userid,"0"));
		map.put("crm",ECommonUtil.getStringFromMap(crmRollMap,temp_userid,"0"));
		map.put("sell",ECommonUtil.getStringFromMap(sellRoleMap,temp_userid,"0"));
		list.add(map);
	}
	result.put("list",list);
	result.put("total",list.size());
	 
}else if("SelfWorking".equals(type)){//个人工作汇总
	result.put("result","1"); 
	String begindate = Util.null2String(fu.getParameter("begindate"));
	String enddate = Util.null2String(fu.getParameter("enddate"));
	//其中有个日期为空.默认本月
	if("".equals(begindate)||"".equals(enddate)){
		begindate=TimeUtil.getDateByOption("3","0");
		enddate=TimeUtil.getDateByOption("3","1");
	}
	String dateShow="从"+begindate+"至"+enddate;
	if(begindate.equals(enddate)){
		dateShow=begindate;
	}
	//知识的分享、培训的主持与参与、新增的客户以及滚动、协助与参与的任务、项目、会议
	//知识分享
	DocForE doc=new DocForE();
	Map docCreateMap=doc.getCreaterCount(userId,begindate,enddate); 
	result.put("docCreate",ECommonUtil.getStringFromMap(docCreateMap,userId,"0"));
	//培训主持
	HrmResource4EService hrm=new HrmResource4EService();
	Map pxMap=hrm.getTrainOperateStatistics(userId,begindate,enddate);
	result.put("train",ECommonUtil.getStringFromMap(pxMap,userId,"0"));
	//协助
	BlogForXiaoE blog=new BlogForXiaoE();
	Map coworkMap=blog.getCoworkStatistics(userId,begindate,enddate);
	result.put("cowork",ECommonUtil.getStringFromMap(coworkMap,userId,"0"));
	//参与任务
	Map taskMap=null;
	//项目
	Map prjMap=null;
	//新增客户
	Map crmAddMap=null;
	//滚动客户
	Map crmRollMap=null;
	try{
        Class clazz = Class.forName("weaver.plugin.util.GetDataUtil");
        Object object = clazz.newInstance();
        Method method = clazz.getMethod("getMapData", String.class, String.class,String.class,String.class);  
        
        Object obj=method.invoke(object, "cyrwck",userId,begindate,enddate);
        taskMap=(Map)obj;
        
      	//新增客户-xzkh
        obj=method.invoke(object, "xzkh",userId,begindate,enddate);
        crmAddMap=(Map)obj;
        
     	// 新增客户滚动-xzkhgd
        obj=method.invoke(object, "cyrwck",userId,begindate,enddate);
        crmRollMap=(Map)obj;
        //项目
        method = clazz.getMethod("getMapData", String.class, String.class,String.class,String.class,String.class);  
        obj=method.invoke(object, "xmysck",userId,begindate,enddate,userId);
        prjMap=(Map)obj;
    } catch (Exception e) {}
    result.put("task",ECommonUtil.getStringFromMap(taskMap,userId,"0"));
    result.put("prj",ECommonUtil.getStringFromMap(prjMap,userId,"0"));
	result.put("crmAdd",ECommonUtil.getStringFromMap(crmAddMap,userId,"0"));
	result.put("crmRoll",ECommonUtil.getStringFromMap(crmRollMap,userId,"0"));
	
	//会议
	MeetingReportUtil meeting=new MeetingReportUtil();
    result.put("meeting",meeting.getMeetingCount(userId,begindate,enddate));
    
    result.put("DisplayStr","以下是您"+dateShow+"工作汇总");
    //返回本次查询条件
    
    Map queryMap=new HashMap();
    queryMap.put("begindate",begindate);
    queryMap.put("enddate",enddate);
    //返回查询条件
    result.put("retQueryData",queryMap);
	
}else if("FlightParam".equals(type)){//判断是否启用航班查询
	result.put("result","0");
	XmlConf conf= LoadXmlConf.getInstance().loadXml("Flight");
	if(conf!=null){
		XmlBean bean=conf.getFieldMap().get("url");
		if(bean!=null){
			String url=Util.null2String(bean.getDefaultV());
			if(!"".equals(url)){
				result.put("result","1"); 
				result.put("url",url); 
				result.put("map",conf.getFieldMap()); 
				result.put("retList",conf.getReturnList()); 
				result.put("retFlag",conf.getReturnFlag()); 
				result.put("statList",conf.getStatisticsList()); 
			}
		}
	}
}else if("Url2Forward".equals(type)){//通过查询报表直接调用url,本地URL.这种一般不涉及参数
	result.put("result","0");
	String reportType=Util.null2String(fu.getParameter("reportType"));//报表类型
	XmlConf conf= LoadXmlConf.getInstance().loadXml(reportType);
	if(conf!=null){
		XmlBean bean=conf.getFieldMap().get("url");
		if(bean!=null){
			String url=Util.null2String(bean.getDefaultV());
			if(!"".equals(url)){
				request.getRequestDispatcher(url).forward(request, response);
				return;
			} 
		}
	}
}else if("getWorkflowTypeId".equals(type)){//获取待办里面最多的wfid.
	FullSearchService ps1=new FullSearchService();
	String keyword = Util.null2String(fu.getParameter("keyword"));
	Map ws_result = ps1.getFullSearchList("","WFTYPE:query",keyword,1, 200, sessionkey,"","1","",false,"");
	
	List retList=new LinkedList();
	Map map=new HashMap();
	List list=null;
	Map tempMap=null;
	String wfids="";
	String temp_id="";
	String temp_name="";
	boolean isFilter=false;
	String returnIds="";
	MobileResultItem mrItem=null;
	if(ws_result.containsKey("list")){
		list=(List)ws_result.get("list");
		for(int i=0;i<list.size();i++){
			mrItem=(MobileResultItem)list.get(i);
			temp_id=mrItem.getId();
			temp_name=mrItem.getSimpleTitle();
			map.put(temp_id,temp_name);
			wfids+=("".equals(wfids)?"":",")+temp_id;
			
			if(i<20){
				tempMap=new HashMap();
				tempMap.put("id",temp_id);
				tempMap.put("name",temp_name);
				retList.add(tempMap);
			}
		}
	}
	if(!"".equals(wfids)){//获取到了类型
		RecordSet rs=new RecordSet();
		String selectDate=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-100);
		rs.executeQuery("select a.workflowid, count(1) cnt from workflow_currentoperator a where a.receivedate >= '"+selectDate+"' and a.userid ="+userId+" and a.workflowid in ("+wfids+") group by a.workflowid 	order by cnt desc");
		if(rs.getCounts()>=0){
			retList=new LinkedList();
		}
		//显示前5条类型
		while(rs.next()){
			isFilter=true;
			temp_id=rs.getString("workflowid");
			tempMap=new HashMap();
			tempMap.put("id",temp_id);
			tempMap.put("name",map.get(temp_id));
			retList.add(tempMap);
		}
		
		result.put("wfids",wfids);
		result.put("list",retList);
	}
}else if("BillNoteParam".equals(type)){//判断是否记一笔
	result.put("result","0");
	XmlConf conf= LoadXmlConf.getInstance().loadXml("BillNote");
	if(conf!=null){
		XmlBean bean=conf.getFieldMap().get("url");
		if(bean!=null){
			String url=Util.null2String(bean.getDefaultV());
			if(!"".equals(url)){
				result.put("result","1"); 
				result.put("url",url); 
				result.put("retFlag",conf.getReturnFlag()); 
				
				result.put("map",conf.getFieldMap()); 
			}
		}
	}
}else if("getUserInfo".equals(type)){//获取用户id
	result.put("uid",userId);
}

JSONObject jo = JSONObject.fromObject(result);
out.println(jo.toString());
%>