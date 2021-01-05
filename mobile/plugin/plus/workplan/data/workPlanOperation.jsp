<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.domain.workplan.WorkPlan"%>
<%@ page import="weaver.Constants" %>
<%@ page import="weaver.WorkPlan.WorkPlanLogMan"%>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="weaver.wxinterface.FormatMultiLang"%>
<%@ page import="java.lang.reflect.Method"%>
<%@ page import="weaver.hrm.User"%>
<jsp:useBean id="requestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="docComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="meetingComInfo" class="weaver.meeting.Maint.MeetingComInfo" scope="page"/>
<jsp:useBean id="workPlanService" class="weaver.WorkPlan.WorkPlanService" scope="page"/>
<jsp:useBean id="workPlanShare" class="weaver.WorkPlan.WorkPlanShare" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="scheduleService" class="weaver.mobile.plugin.ecology.service.ScheduleService" scope="page"/>
<%
	request.setCharacterEncoding("UTF-8");
	JSONObject json = new JSONObject();
	int status = 1;String msg = "";
	String userId = String.valueOf(user.getUID());
	String userType = user.getLogintype();
	String operation = Util.null2String(request.getParameter("operation"));
	if(operation.equals("getWorkPlanType")){
		rs.executeSql("SELECT * FROM WorkPlanType" + Constants.WorkPlan_Type_Query_By_Menu);
		JSONArray js = new JSONArray();
		while(rs.next()){
			String id = Util.null2String(rs.getString("workPlanTypeID"));
		    String name = Util.null2String(rs.getString("workPlanTypeName"));
		    JSONObject j = new JSONObject();
		    j.put("id",id);
		    j.put("name",name);
		    js.add(j);
		}
		json.put("js",js);
		ResourceComInfo rc = new ResourceComInfo();
		json.put("userid", userId);
		json.put("userName", rc.getLastname(userId));
		status = 0;
	}else if("addWorkPlan".equals(operation)){//新增日程
		try{
			String planName = Util.null2String(request.getParameter("planName"));//日程标题
			int workPlanType = Util.getIntValue(request.getParameter("workPlanType"));//日程类型
			String urgentLevel = Util.null2String(request.getParameter("urgentLevel"));//紧急程度
			String remindType = Util.null2String(request.getParameter("remindType"));//日程提醒方式
			String memberIDs = Util.null2String(request.getParameter("memberIDs"));//参与人
			String description = Util.null2String(request.getParameter("description"));//日程内容
		    String beginDate = Util.null2String(request.getParameter("beginDate"));//开始日期	 
		    String endDate = Util.null2String(request.getParameter("endDate"));//结束日期
		    
		    String[] bDates = transDate(beginDate);
		    beginDate = bDates[0];
		    String beginTime = bDates[1];
		    String[] eDates = transDate(endDate);
		    endDate = eDates[0];
		    String endTime = eDates[1];
		    
		    String remindBeforeStart = Util.null2String(request.getParameter("remindBeforeStart"));//是否开始前提醒
		    String remindBeforeEnd = Util.null2String(request.getParameter("remindBeforeEnd"));//是否结束前提醒
		  	//开始前提醒时间
		    int remindDateBeforeStart = Util.getIntValue(request.getParameter("remindDateBeforeStart"),0);
		    int remindTimeBeforeStart = Util.getIntValue(request.getParameter("remindTimeBeforeStart"),0);
			//结束前提醒时间
		    int remindDateBeforeEnd = Util.getIntValue(request.getParameter("remindDateBeforeEnd"),0);
		    int remindTimeBeforeEnd = Util.getIntValue(request.getParameter("remindTimeBeforeEnd"),0);
		     
		    WorkPlan workPlan = new WorkPlan();
			workPlan.setCreaterId(Integer.parseInt(userId));
			workPlan.setCreateType(Integer.parseInt(userType));
			workPlan.setWorkPlanType(workPlanType);
			workPlan.setWorkPlanName(planName);  
			workPlan.setUrgentLevel(urgentLevel);
			workPlan.setRemindType(remindType);
			if(!"".equals(remindBeforeStart)){
				workPlan.setRemindBeforeStart(remindBeforeStart);  //是否开始前提醒
			}
			if(!"".equals(remindBeforeEnd)){
				workPlan.setRemindBeforeEnd(remindBeforeEnd);  //是否结束前提醒
			}
		    workPlan.setRemindTimesBeforeStart(remindDateBeforeStart*60+remindTimeBeforeStart);
		    workPlan.setRemindTimesBeforeEnd(remindDateBeforeEnd*60+remindTimeBeforeEnd);
		    workPlan.setResourceId(memberIDs);
		    workPlan.setBeginDate(beginDate);
		    workPlan.setBeginTime(beginTime);
		    workPlan.setEndDate(endDate);
		    workPlan.setEndTime(endTime);
		    
		    workPlan.setDescription(description);
		    
		  	//自定义考核叶子节点
		    int hrmPerformanceCheckDetailID = Util.getIntValue(request.getParameter("hrmPerformanceCheckDetailID"),-1);
		    workPlan.setPerformanceCheckId(hrmPerformanceCheckDetailID);
		    
		    if(!"".equals(workPlan.getBeginDate())){	    	
		    	List beginDateTimeRemindList = Util.processTimeBySecond(workPlan.getBeginDate(), workPlan.getBeginTime(), workPlan.getRemindTimesBeforeStart() * -1 * 60);
		    	workPlan.setRemindDateBeforeStart((String)beginDateTimeRemindList.get(0));  //开始前提醒日期
		    	workPlan.setRemindTimeBeforeStart((String)beginDateTimeRemindList.get(1));  //开始前提醒时间
		    }
		    if(!"".equals(workPlan.getEndDate())){
		    	List endDateTimeRemindList = Util.processTimeBySecond(workPlan.getEndDate(), workPlan.getEndTime(), workPlan.getRemindTimesBeforeEnd() * -1 * 60);
		    	workPlan.setRemindDateBeforeEnd((String)endDateTimeRemindList.get(0));  //结束前提醒日期
		    	workPlan.setRemindTimeBeforeEnd((String)endDateTimeRemindList.get(1));  //结束前提醒时间
		    }
		    
		    workPlanService.insertWorkPlan(workPlan);//插入日程
		  	//只在新增的时候设置默认共享
		    workPlanShare.setDefaultShareDetail(user,String.valueOf(workPlan.getWorkPlanID()),workPlanType+"");	       
	        //插入日志
	        WorkPlanLogMan workPlanLogMan = new WorkPlanLogMan();
	        String[] logParams  = new String[]
	        {String.valueOf(workPlan.getWorkPlanID()), WorkPlanLogMan.TP_CREATE, userId, this.getIpAddr(request)};
	        workPlanLogMan.writeViewLog(logParams);
	        status = 0;
		}catch(Exception e){
			msg = "保存日程出错:"+e.getMessage();
		}
	}else if("editWorkPlan".equals(operation)){//修改日程
		try{
			String wpid = request.getParameter("wpid");
			String rightSql = " SELECT 1 FROM workPlanShareDetail WHERE workId = " + wpid + " AND userId = " + userId+ "  AND userType = 1  AND shareLevel > 1 ";
			rs.executeSql(rightSql);
			if(rs.next()){
				int workPlanType = Util.getIntValue(request.getParameter("workPlanType"));
				WorkPlan workPlan = new WorkPlan();
				workPlan.setWorkPlanType(workPlanType);
				workPlan.setWorkPlanName(Util.null2String(request.getParameter("planName")));
				workPlan.setResourceId(Util.null2String(request.getParameter("memberIDs")));
				workPlan.setBeginDate(Util.null2String(request.getParameter("beginDate")));
				workPlan.setBeginTime(Util.null2String(request.getParameter("beginTime")));
				workPlan.setEndDate(Util.null2String(request.getParameter("endDate")));
				workPlan.setEndTime(Util.null2String(request.getParameter("endTime")));
				workPlan.setDescription(Util.null2String(request.getParameter("description")));
				workPlan.setCreaterId(Integer.parseInt(userId));
				workPlan.setCreateType(Integer.parseInt(userType));
				workPlan.setUrgentLevel(Util.null2String(request.getParameter("urgentLevel")));
				workPlan.setRemindType(Util.null2String(request.getParameter("remindType")));
				workPlan.setRemindBeforeStart(Util.null2String(request.getParameter("remindBeforeStart")));
				workPlan.setRemindBeforeEnd(Util.null2String(request.getParameter("remindBeforeEnd")));
				workPlan.setRemindDateBeforeEnd(Util.null2String(request.getParameter("remindDateBeforeEnd")));
				workPlan.setRemindTimeBeforeEnd(Util.null2String(request.getParameter("remindTimeBeforeEnd")));
				WorkPlan oldWorkPlan = new WorkPlan();
		        oldWorkPlan.setWorkPlanID(Integer.parseInt(wpid));
		        workPlan.setWorkPlanID(oldWorkPlan.getWorkPlanID());
		        String ip = this.getIpAddr(request);
		        List workPlanList = workPlanService.getWorkPlanList(oldWorkPlan);
		        WorkPlanLogMan workPlanLogMan = new WorkPlanLogMan();
		        for(int i = 0; i < workPlanList.size(); i++)
		        {
		            oldWorkPlan = (WorkPlan)workPlanList.get(i);
		            workPlanService.updateWorkPlan(oldWorkPlan, workPlan);
		            workPlanLogMan.insertEditLog(oldWorkPlan, workPlan, userId, ip);	            
		        }
				status = 0;
			}else{
				msg = "没有修改权限";
			}
		}catch(Exception e){
			msg = "修改日程出错:"+e.getMessage();
		}
	}else if("getWorkPlanSummary".equals(operation)){//获取时间段内每日日程数
		try{
			String start = Util.null2String(request.getParameter("start"));
			String end = Util.null2String(request.getParameter("end"));
			int subUserid = Util.getIntValue(request.getParameter("subUserid"),0);
			boolean canView = true;
			if(subUserid==0){
				subUserid = user.getUID();
			}else{
				ResourceComInfo rc = new ResourceComInfo();
				String managerstr = rc.getManagersIDs(subUserid+"");
				if(managerstr.indexOf(","+user.getUID()+",")<0){
					canView = false;
				}
			}
			if(canView){
				String sql = "SELECT * FROM WorkPlan WHERE (workPlan.status = 0)"
						+" AND deleted <> 1 AND createrType = '1'"
						+" AND ( resourceID = '"+subUserid+"' OR resourceID LIKE '"+subUserid
						+",%' OR resourceID LIKE '%,"+subUserid+",%' OR resourceID LIKE '%,"+subUserid+"' ) "
						+" AND ((beginDate>='"+start+"' AND beginDate <='"+end+"')"
						+" OR (endDate>='"+start+"' AND endDate <='"+end+"')"	
						+" OR (endDate>='"+end+"' AND beginDate <='"+start+"')"
						+" OR ((endDate IS null OR endDate = '') AND beginDate <='"+start+"')"
						+")";
				rs.executeSql(sql);
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Map<String, Integer> summaryMap = new TreeMap<String, Integer>( );
				JSONArray selectedList = new JSONArray(); // 返回的结果
				while(rs.next()){
					String beginDate = Util.null2String(rs.getString("begindate"));
					String endDate = Util.null2String(rs.getString("enddate"));
					if(!("".equals(beginDate) && "".equals(endDate)) && endDate.compareTo(beginDate) > 0){
						String[] beginArr =  beginDate.split("-");
						String[] endArr =  endDate.split("-");
						Calendar cBegin = Calendar.getInstance();
						Calendar cEnd = Calendar.getInstance();
						cBegin.set(Integer.valueOf(beginArr[0]), Integer.valueOf(beginArr[1])-1, Integer.valueOf(beginArr[2]));
						cEnd.set(Integer.valueOf(endArr[0]), Integer.valueOf(endArr[1])-1, Integer.valueOf(endArr[2]));
						long cBeginMS = cBegin.getTimeInMillis();
						long cEndMS = cEnd.getTimeInMillis();
						long diffDays = (cEndMS - cBeginMS) / (24 * 60 * 60 * 1000);
						for(int i=0; i<diffDays;i++){ // 添加后面几天
							cBegin.add(Calendar.DATE, 1);
							boolean hasKey = summaryMap.containsKey(sdf.format(cBegin.getTime()));
							String key = sdf.format(cBegin.getTime());
							if(hasKey){
								summaryMap.put(key, summaryMap.get(key) + 1);
							}else{
								summaryMap.put(key, 1);
							}
						}
					}
					boolean hasKey = summaryMap.containsKey(beginDate);
					if(hasKey){
						summaryMap.put(beginDate, summaryMap.get(beginDate) +1);
					}else{
						summaryMap.put(beginDate, 1);
					} 
				}
				JSONObject dayJSON = null;
				for (String key : summaryMap.keySet()) {
					dayJSON = new JSONObject();
					Integer num = summaryMap.get(key);
					dayJSON.put("time",key);
					dayJSON.put("num",num);
					selectedList.add(dayJSON);
				}
				json.put("selectedList",selectedList);
				status = 0;
			}else{
				msg = "您没有权限查看";
			}
		}catch(Exception e){
			msg = "获取日程合计出错:"+e.getMessage();
		}
	}else if("getWorkPlanWeek".equals(operation)){//获取一周的日程数据
		try{
			int subUserid = Util.getIntValue(request.getParameter("subUserid"),0);
			boolean canView = true;
			if(subUserid==0){
				subUserid = user.getUID();
			}else{
				ResourceComInfo rc = new ResourceComInfo();
				String managerstr = rc.getManagersIDs(subUserid+"");
				if(managerstr.indexOf(","+user.getUID()+",")<0){
					canView = false;
				}
			}
			if(canView){
				String start = Util.null2String(request.getParameter("start"));
				String end = Util.null2String(request.getParameter("end"));
				String sql = "SELECT * FROM WorkPlan WHERE (workPlan.status = 0)"
						+" AND deleted <> 1 AND createrType = '1'"
						+" AND ( resourceID = '"+subUserid+"' OR resourceID LIKE '"+subUserid
						+",%' OR resourceID LIKE '%,"+subUserid+",%' OR resourceID LIKE '%,"+subUserid+"' ) "
						+" AND ((beginDate>='"+start+"' AND beginDate <='"+end+"')"
						+" OR (endDate>='"+start+"' AND endDate <='"+end+"')"	
						+" OR (endDate>='"+end+"' AND beginDate <='"+start+"')"
						+" OR ((endDate IS null OR endDate = '') AND beginDate <='"+start+"')"
						+") order by begindate,begintime";
				rs.executeSql(sql);
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Map<String, JSONArray> weekMap = new TreeMap<String, JSONArray>();
				JSONArray dataList = new JSONArray(); // 返回的结果
				JSONArray wpList = null; //装每天的日程
				ResourceComInfo rc = new ResourceComInfo();
				while(rs.next()){
					String beginDate = Util.null2String(rs.getString("begindate"));
					String endDate = Util.null2String(rs.getString("enddate"));
					String beginTime = Util.null2String(rs.getString("begintime"));
					String id = Util.null2String(rs.getString("id"));
					String name = Util.null2String(rs.getString("name"));
					String level = Util.null2String(rs.getString("urgentLevel"));				
					String resourceid = Util.null2String(rs.getString("resourceid"));	
					//增加获取当前用户姓名，多个值取第一个
					String[] users = resourceid.split(",");
					String userName = "";
					if(users!=null&&users.length>0){
						for(String u:users){
							if(!"".equals(u)){
								userName = rc.getLastname(u);
								break;
							}
						}
					}
					if(!("".equals(beginDate) && "".equals(endDate)) && endDate.compareTo(beginDate) > 0){
						String[] beginArr = beginDate.split("-");
						String[] endArr = endDate.split("-");
						Calendar cBegin = Calendar.getInstance();
						Calendar cEnd = Calendar.getInstance();
						cBegin.set(Integer.valueOf(beginArr[0]), Integer.valueOf(beginArr[1])-1, Integer.valueOf(beginArr[2]));
						cEnd.set(Integer.valueOf(endArr[0]), Integer.valueOf(endArr[1])-1, Integer.valueOf(endArr[2]));
						long cBeginMS = cBegin.getTimeInMillis();
						long cEndMS = cEnd.getTimeInMillis();
						long diffDays = (cEndMS - cBeginMS) / (24 * 60 * 60 * 1000);
						for(int i=0; i<diffDays;i++){ // 添加后面几天
							cBegin.add(Calendar.DATE, 1);
							String key = sdf.format(cBegin.getTime());
							boolean hasKey = weekMap.containsKey(key);
							if(!hasKey){
								wpList = new JSONArray();
								weekMap.put(key, wpList);
							}
							JSONArray oldWpList = weekMap.get(key);
							JSONObject dayJSON = new JSONObject();
							dayJSON.put("id",id);
							dayJSON.put("name",name);
							dayJSON.put("level",level);
							dayJSON.put("begindate",beginDate);
							dayJSON.put("enddate",endDate);
							dayJSON.put("begintime",beginTime);
							dayJSON.put("userName",userName);
							oldWpList.add(dayJSON);
						}
					}
					boolean hasKey = weekMap.containsKey(beginDate);
					if(!hasKey){
						wpList = new JSONArray();
						weekMap.put(beginDate, wpList);
					}
					JSONArray oldWpList = weekMap.get(beginDate);
					JSONObject dayJSON = new JSONObject();
					dayJSON.put("id",id);
					dayJSON.put("name",name);
					dayJSON.put("level",level);
					dayJSON.put("begindate",beginDate);
					dayJSON.put("enddate",endDate);
					dayJSON.put("begintime",beginTime);
					dayJSON.put("userName",userName);
					oldWpList.add(dayJSON);
				}
	
				Calendar cFirst = Calendar.getInstance();
				Calendar cLast = Calendar.getInstance();
				String[] firstArr =  start.split("-");
				String[] lastArr =  end.split("-");
				cFirst.set(Integer.valueOf(firstArr[0]), Integer.valueOf(firstArr[1])-1, Integer.valueOf(firstArr[2]));
				cLast.set(Integer.valueOf(lastArr[0]), Integer.valueOf(lastArr[1])-1, Integer.valueOf(lastArr[2]));
				long cFirstMS = cFirst.getTimeInMillis();
				long cLastMS = cLast.getTimeInMillis();
				long diffDays = (cLastMS - cFirstMS) / (24 * 60 * 60 * 1000);
				JSONObject dayJSON = null;
				for(int i=0; i<=diffDays;i++){ // 添加每一天的数据
					if(i > 0){
						cFirst.add(Calendar.DATE, 1);
					}
					String key = sdf.format(cFirst.getTime());
					boolean hasKey = weekMap.containsKey(key);
					dayJSON = new JSONObject();
					dayJSON.put("day",key);
					if(hasKey){
						dayJSON.put("wpList", weekMap.get(key));
					}else{
						dayJSON.put("wpList", null);
					}
					dataList.add(dayJSON);
				}
				json.put("data",dataList); 
				status = 0;
			}else{
				msg = "您没有权限查看";
			}
		}catch(Exception e){
			msg = "获取周日程数据出错:"+e.getMessage();
		}
	}else if("getWorkPlanById".equals(operation)){//根据ID获取某一个日程信息
		try{
			String wpid = Util.null2String(request.getParameter("wpid")); // 日程ID
			if("".equals(wpid)){
				json.put("status",status);
				json.put("msg","无效的日程");
				out.print(json.toString());
				return;
			}
			String sql = "SELECT t1.*,t2.workPlanTypeName FROM WorkPlan t1 left join WorkPlanType t2 on t1.type_n = t2.workPlanTypeID WHERE t1.id = " + wpid;
			rs.executeSql(sql);
			if(rs.next()){
				JSONObject wpJSON = new JSONObject();	
				String workplanid = Util.null2String(rs.getString("id"));
				wpJSON.put("id", workplanid);
				wpJSON.put("type_n", FormatMultiLang.formatByUserid(Util.null2String(rs.getString("type_n")),userId));
				wpJSON.put("workPlanTypeName", Util.null2String(rs.getString("workPlanTypeName")));
				wpJSON.put("name", Util.null2String(rs.getString("name")));
				wpJSON.put("begindate", Util.null2String(rs.getString("begindate")));
				wpJSON.put("begintime", Util.null2String(rs.getString("begintime")));
				wpJSON.put("enddate", Util.null2String(rs.getString("enddate")));
				wpJSON.put("endtime", Util.null2String(rs.getString("endtime")));
				wpJSON.put("description", FormatMultiLang.formatByUserid(Util.null2String(rs.getString("description")),userId));
				wpJSON.put("createrid", Util.null2String(rs.getString("createrid")));
				wpJSON.put("urgentLevel", Util.null2String(rs.getString("urgentLevel")));
				String requestid = Util.null2String(rs.getString("requestid"));
				String requestNames = "";
				if(!requestid.equals("")){
					String[] requestids = requestid.split(",");
					for(String rid:requestids){
						requestNames += "<a href='/mobile/plugin/1/view.jsp?module=1&detailid="+rid+"' class='link external'>"
								+requestComInfo.getRequestname(rid)+"</a>&nbsp;<br/>";
					}
				}
				wpJSON.put("requestid", requestid);
				wpJSON.put("requestNames", requestNames);
				String docid = Util.null2String(rs.getString("docid"));
				String docNames = "";
				if(!docid.equals("")){
					String[] docids = docid.split(",");
					for(String rid:docids){
						docNames += "<a href='/wxclient/viewDoc?docid="+rid+"&workplanid="+workplanid+"' class='link external'>"
								+docComInfo.getDocname(rid)+"</a>&nbsp;<br/>";
					}
				}
				wpJSON.put("docid", docid);
				wpJSON.put("docNames", docNames);
				String meetingid = Util.null2String(rs.getString("meetingid"));
				String meetingNames = "";
				if(!meetingid.equals("")&&!meetingid.equals("0")){
					String[] meetingids = meetingid.split(",");
					for(String rid:meetingids){
						meetingNames += "<a href='/wxclient/app/maw/meetingview?id="+rid+"' class='link external'>"
								+meetingComInfo.getMeetingInfoname(rid)+"</a>&nbsp;<br/>";
					}
				}
				wpJSON.put("meetingid", meetingid);
				wpJSON.put("meetingNames", meetingNames);
				int remindTimesBeforeStart = Util.getIntValue(rs.getString("remindTimesBeforeStart"));
				int remindTimesBeforeEnd = Util.getIntValue(rs.getString("remindTimesBeforeEnd"));
				int remindBeforeStart = Util.getIntValue(rs.getString("remindBeforeStart"),0);
				int remindBeforeEnd = Util.getIntValue(rs.getString("remindBeforeEnd"),0);
				wpJSON.put("remindType", Util.null2String(rs.getString("remindType")));
				wpJSON.put("rtbs", remindBeforeStart);
				wpJSON.put("rtbsH", remindTimesBeforeStart / 60);
				wpJSON.put("rtbsM", remindTimesBeforeStart % 60);
				wpJSON.put("rtbe", remindBeforeEnd);
				wpJSON.put("rtbeH", remindTimesBeforeEnd / 60);
				wpJSON.put("rtbeM", remindTimesBeforeEnd % 60);
				String resourceId = Util.null2String(rs.getString("resourceid"));
				String rsIdStr = "";
				String rsNameStr = "";
				ResourceComInfo rci = new ResourceComInfo();
				if(resourceId != null && !"".equals(resourceId)){
					String[] rsIdArr = resourceId.split(",");
					for(String rsid : rsIdArr){
						if(!"".endsWith(rsid)){
							rsIdStr += (rsid + ",");
							rsNameStr += (Util.null2String(rci.getLastname(rsid)) + ",");
						}
					}
				}
				if(!"".equals(rsIdStr)){
					rsIdStr = rsIdStr.substring(0, rsIdStr.length()-1);
				}
				if(!"".equals(rsNameStr)){
					rsNameStr = rsNameStr.substring(0, rsNameStr.length()-1);
				}
				wpJSON.put("resourceid", rsIdStr);
				wpJSON.put("resourcename", rsNameStr);
				json.put("wp",wpJSON);
				//插入日志
		        WorkPlanLogMan workPlanLogMan = new WorkPlanLogMan();
		        String[] logParams  = new String[]
		        {wpid, WorkPlanLogMan.TP_VIEW, userId,"mobile"};
		        workPlanLogMan.writeViewLog(logParams);
				status = 0;
			}
		}catch(Exception e){
			msg = "获取周日程数据出错:"+e.getMessage();
		}
	}else if("getAllWorkPlanSummary".equals(operation)){
		try{
			String start = Util.null2String(request.getParameter("start"));
			String end = Util.null2String(request.getParameter("end"));
			int subUserid = Util.getIntValue(request.getParameter("subUserid"),0);
			boolean canView = true;
			if(subUserid==0){
				subUserid = user.getUID();
			}else{
				ResourceComInfo rc = new ResourceComInfo();
				String managerstr = rc.getManagersIDs(subUserid+"");
				if(managerstr.indexOf(","+user.getUID()+",")<0){
					canView = false;
				}
			}
			if(canView){
				String resultStr="";
				boolean exceptionFlag=true;
				try{
					Class<?> workPlanShareUtil = Class.forName("weaver.WorkPlan.WorkPlanShareUtil");
					Method m = workPlanShareUtil.getDeclaredMethod("getShareSql",weaver.hrm.User.class);
					resultStr= (String)m.invoke(null,user);
				}catch(Exception e){
					exceptionFlag=false;
					status = -1;
					msg = "当前oa版本不支持获取全部日程:"+e.getMessage();
				}
				if(exceptionFlag){
					
					int overColor = 0;
					int overAvailable = 0;
					int archiveAvailable = 0;
					int archiveColor = 0;
					String oversql = "select * from overworkplan order by workplanname desc";
							rs.executeSql(oversql);
							while (rs.next()) {
								int workplancolor = Util.getIntValue(rs.getString("workplancolor").trim());
								String wavailable = rs.getString("wavailable");
								if ("1".equals(rs.getString("id"))) {//完成日程
									overColor = workplancolor;
									if ("1".equals(wavailable))
										overAvailable = 1;
								} else {//归档日程
									archiveColor = workplancolor;
									if ("1".equals(wavailable))
										archiveAvailable = 2;
								}
							}
				StringBuffer sql=new StringBuffer();
				//查询所有我能查看的日程
				sql.append("select a.id,a.name,a.resourceid,a.begindate,a.begintime,a.enddate,a.endtime,a.urgentLevel, a.status,a.createrid,c.workplanTypeColor ");
				sql.append("from workplan a join WorkPlanType c on a.type_n= c.workplantypeId join ( "+resultStr+" ) b ON a.id = b.workId ");
				sql.append("where deleted <>1 ");
				sql.append(" and (");
				sql.append(" a.status=0 ");
				if(overAvailable==1){
					sql.append(" or a.status=1 ");
				}
				if(archiveAvailable==2){
					sql.append(" or a.status=2 ");
				}
				sql.append(") ");
				
				sql.append("and begindate>='"+start+"' and begindate<='"+end+"' ");
				sql.append(" ORDER BY a.begindate asc,a.begintime asc");
				rs.executeSql(sql.toString());
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Map<String, Integer> summaryMap = new TreeMap<String, Integer>( );
				JSONArray selectedList = new JSONArray(); // 返回的结果
				while(rs.next()){
					String beginDate = Util.null2String(rs.getString("begindate"));
					String endDate = Util.null2String(rs.getString("enddate"));
					if(!("".equals(beginDate) && "".equals(endDate)) && endDate.compareTo(beginDate) > 0){
						String[] beginArr =  beginDate.split("-");
						String[] endArr =  endDate.split("-");
						Calendar cBegin = Calendar.getInstance();
						Calendar cEnd = Calendar.getInstance();
						cBegin.set(Integer.valueOf(beginArr[0]), Integer.valueOf(beginArr[1])-1, Integer.valueOf(beginArr[2]));
						cEnd.set(Integer.valueOf(endArr[0]), Integer.valueOf(endArr[1])-1, Integer.valueOf(endArr[2]));
						long cBeginMS = cBegin.getTimeInMillis();
						long cEndMS = cEnd.getTimeInMillis();
						long diffDays = (cEndMS - cBeginMS) / (24 * 60 * 60 * 1000);
						for(int i=0; i<diffDays;i++){ // 添加后面几天
							cBegin.add(Calendar.DATE, 1);
							boolean hasKey = summaryMap.containsKey(sdf.format(cBegin.getTime()));
							String key = sdf.format(cBegin.getTime());
							if(hasKey){
								summaryMap.put(key, summaryMap.get(key) + 1);
							}else{
								summaryMap.put(key, 1);
							}
						}
					}
					boolean hasKey = summaryMap.containsKey(beginDate);
					if(hasKey){
						summaryMap.put(beginDate, summaryMap.get(beginDate) +1);
					}else{
						summaryMap.put(beginDate, 1);
					} 
				}
				JSONObject dayJSON = null;
				for (String key : summaryMap.keySet()) {
					dayJSON = new JSONObject();
					Integer num = summaryMap.get(key);
					dayJSON.put("time",key);
					dayJSON.put("num",num);
					selectedList.add(dayJSON);
				}
				json.put("selectedList",selectedList);
				status = 0;
			}
		}else{
			msg = "您没有权限查看";
		}
		}catch(Exception e){
			msg = "获取日程合计出错:"+e.getMessage();
		}
		
	
	}else if("getAllWorkPlan".equals(operation)){
		String resultStr="";
		boolean exceptionFlag=true;
		try{
			Class<?> workPlanShareUtil = Class.forName("weaver.WorkPlan.WorkPlanShareUtil");
			Method m = workPlanShareUtil.getDeclaredMethod("getShareSql",weaver.hrm.User.class);
			resultStr= (String)m.invoke(null,user);
		}catch(Exception e){
			exceptionFlag=false;
			status = -1;
			msg = "当前oa版本不支持获取全部日程:"+e.getMessage();
		}
		if(exceptionFlag){
			try{
				int overColor = 0;
			int overAvailable = 0;
			int archiveAvailable = 0;
		    int archiveColor = 0;
			String start = Util.null2String(request.getParameter("start"));
			String end = Util.null2String(request.getParameter("end"));
			String oversql = "select * from overworkplan order by workplanname desc";
					rs.executeSql(oversql);
					while (rs.next()) {
						int workplancolor = Util.getIntValue(rs.getString("workplancolor").trim());
						String wavailable = rs.getString("wavailable");
						if ("1".equals(rs.getString("id"))) {//完成日程
							overColor = workplancolor;
							if ("1".equals(wavailable))
								overAvailable = 1;
						} else {//归档日程
							archiveColor = workplancolor;
							if ("1".equals(wavailable))
								archiveAvailable = 2;
						}
					}
				StringBuffer sql=new StringBuffer();
				//查询所有我能查看的日程
				sql.append("select a.id,a.name,a.resourceid,a.begindate,a.begintime,a.enddate,a.endtime,a.urgentLevel, a.status,a.createrid,c.workplanTypeColor ");
				sql.append("from workplan a join WorkPlanType c on a.type_n= c.workplantypeId join ( "+resultStr+" ) b ON a.id = b.workId ");
				sql.append("where deleted <>1 ");
				sql.append(" and (");
				sql.append(" a.status=0 ");
				if(overAvailable==1){
					sql.append(" or a.status=1 ");
				}
				if(archiveAvailable==2){
					sql.append(" or a.status=2 ");
				}
				sql.append(") ");
				
				sql.append("and begindate>='"+start+"' and begindate<='"+end+"' ");
				sql.append(" ORDER BY a.begindate asc,a.begintime asc");
				rs.execute(sql.toString());
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Map<String, JSONArray> weekMap = new TreeMap<String, JSONArray>();
				JSONArray dataList = new JSONArray(); // 返回的结果
				JSONArray wpList = null; //装每天的日程
				ResourceComInfo rc = new ResourceComInfo();
				while(rs.next()){
					String beginDate = Util.null2String(rs.getString("begindate"));
					String endDate = Util.null2String(rs.getString("enddate"));
					String beginTime = Util.null2String(rs.getString("begintime"));
					String id = Util.null2String(rs.getString("id"));
					String name = Util.null2String(rs.getString("name"));
					String level = Util.null2String(rs.getString("urgentLevel"));				
					String resourceid = Util.null2String(rs.getString("resourceid"));				
					if(!("".equals(beginDate) && "".equals(endDate)) && endDate.compareTo(beginDate) > 0){
						String[] beginArr = beginDate.split("-");
						String[] endArr = endDate.split("-");
						Calendar cBegin = Calendar.getInstance();
						Calendar cEnd = Calendar.getInstance();
						cBegin.set(Integer.valueOf(beginArr[0]), Integer.valueOf(beginArr[1])-1, Integer.valueOf(beginArr[2]));
						cEnd.set(Integer.valueOf(endArr[0]), Integer.valueOf(endArr[1])-1, Integer.valueOf(endArr[2]));
						long cBeginMS = cBegin.getTimeInMillis();
						long cEndMS = cEnd.getTimeInMillis();
						long diffDays = (cEndMS - cBeginMS) / (24 * 60 * 60 * 1000);
						for(int i=0; i<diffDays;i++){ // 添加后面几天
							cBegin.add(Calendar.DATE, 1);
							String key = sdf.format(cBegin.getTime());
							boolean hasKey = weekMap.containsKey(key);
							if(!hasKey){
								wpList = new JSONArray();
								weekMap.put(key, wpList);
							}
							JSONArray oldWpList = weekMap.get(key);
							JSONObject dayJSON = new JSONObject();
							dayJSON.put("id",id);
							dayJSON.put("name",name);
							dayJSON.put("level",level);
							dayJSON.put("begindate",beginDate);
							dayJSON.put("enddate",endDate);
							dayJSON.put("begintime",beginTime);
							oldWpList.add(dayJSON);
						}
					}
					boolean hasKey = weekMap.containsKey(beginDate);
					if(!hasKey){
						wpList = new JSONArray();
						weekMap.put(beginDate, wpList);
					}
					JSONArray oldWpList = weekMap.get(beginDate);
					JSONObject dayJSON = new JSONObject();
					dayJSON.put("id",id);
					dayJSON.put("name",name);
					dayJSON.put("level",level);
					dayJSON.put("begindate",beginDate);
					dayJSON.put("enddate",endDate);
					dayJSON.put("begintime",beginTime);
					//增加获取当前用户姓名，多个值取第一个
					String[] users = resourceid.split(",");
					String userName = "";
					if(users!=null&&users.length>0){
						for(String u:users){
							if(!"".equals(u)){
								userName = rc.getLastname(u);
								break;
							}
						}
					}
					dayJSON.put("userName",userName);
					oldWpList.add(dayJSON);
				}

				Calendar cFirst = Calendar.getInstance();
				Calendar cLast = Calendar.getInstance();
				String[] firstArr =  start.split("-");
				String[] lastArr =  end.split("-");
				cFirst.set(Integer.valueOf(firstArr[0]), Integer.valueOf(firstArr[1])-1, Integer.valueOf(firstArr[2]));
				cLast.set(Integer.valueOf(lastArr[0]), Integer.valueOf(lastArr[1])-1, Integer.valueOf(lastArr[2]));
				long cFirstMS = cFirst.getTimeInMillis();
				long cLastMS = cLast.getTimeInMillis();
				long diffDays = (cLastMS - cFirstMS) / (24 * 60 * 60 * 1000);
				JSONObject dayJSON = null;
				for(int i=0; i<=diffDays;i++){ // 添加每一天的数据
					if(i > 0){
						cFirst.add(Calendar.DATE, 1);
					}
					String key = sdf.format(cFirst.getTime());
					boolean hasKey = weekMap.containsKey(key);
					dayJSON = new JSONObject();
					dayJSON.put("day",key);
					if(hasKey){
						dayJSON.put("wpList", weekMap.get(key));
					}else{
						dayJSON.put("wpList", null);
					}
					dataList.add(dayJSON);
					
				}
				json.put("data",dataList); 
				status = 0;
			}catch(Exception e){
				msg = "获取全部日程出错:"+e.getMessage();
			}
		}	
	}
	json.put("status",status);
	json.put("msg",msg);
	out.print(json.toString());
%>
<%!
	public String[] transDate(String dateSource){
		String[] result = new String[2];
		String date = "";
		String time = "";
		if(!dateSource.equals("")){
			 SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			 Calendar c = Calendar.getInstance();
			 try{
	    		Date bDate = sdf.parse(dateSource);
	    		c.setTime(bDate);
	    		int year = c.get(Calendar.YEAR);
	    		int month = c.get(Calendar.MONTH)+1;
	    		int day  = c.get(Calendar.DAY_OF_MONTH);
	    		int hour = c.get(Calendar.HOUR_OF_DAY);
	    		int minute = c.get(Calendar.MINUTE);
	    		
	    		String months = month+"";
	    		String days = day+"";
	    		String hours = hour+"";
	    		String minutes = minute+"";
	    		if(month<10){
	    			months = "0"+months;
	    		}
	    		if(day<10){
	    			days = "0"+days;
	    		}
	    		if(hour<10){
	    			hours = "0"+hours;
	    		}
	    		if(minute<10){
	    			minutes = "0"+minutes;
	    		}
	    		
	    		date = year+"-"+months+"-"+days;
	    		time = hours+":"+minutes;
	    	}catch(Exception e){
	    		e.printStackTrace();
	    	}
		}
		result[0] = date;
		result[1] = time;
		return result;
	}
	public String getIpAddr(HttpServletRequest request) {      
	    String ip = request.getHeader("x-forwarded-for");      
	    if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {      
	        ip = request.getHeader("Proxy-Client-IP");      
	    }      
	    if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {      
	        ip = request.getHeader("WL-Proxy-Client-IP");      
	    }      
	    if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {      
	        ip = request.getRemoteAddr();      
	    }   
	    if ((ip.indexOf(",") >= 0)){
	        ip = ip.substring(0 , ip.indexOf(","));
	    }
	    return ip;      
	}
%>