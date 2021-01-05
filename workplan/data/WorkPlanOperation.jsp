
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.Constants" %>
<%@ page import="weaver.domain.workplan.WorkPlan" %>
<%@ page import="weaver.WorkPlan.WorkPlanLogMan" %>
<%@ page import="weaver.WorkPlan.WorkPlanHandler" %>
<%@ page import="java.text.*"%>
<%@ page import="weaver.docs.docs.DocExtUtil" %>
<%@ page import="weaver.WorkPlan.WorkPlanShareUtil" %>
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsc" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="resource" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="exchange" class="weaver.WorkPlan.WorkPlanExchange" scope="page"/>
<jsp:useBean id="workPlanService" class="weaver.WorkPlan.WorkPlanService" scope="page"/>
<jsp:useBean id="workPlanViewer" class="weaver.WorkPlan.WorkPlanViewer" scope="page"/>
<jsp:useBean id="sysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page"/>
<jsp:useBean id="workPlanValuate" class="weaver.WorkPlan.WorkPlanValuate" scope="page"/>
<jsp:useBean id="workPlanShare" class="weaver.WorkPlan.WorkPlanShare" scope="page"/>
<%!
public void editAccessory(HttpServletRequest request,User user,String workplanid,RecordSet RecordSet)
{
	
	int accessorynum = Util.getIntValue(request.getParameter("accessory_num"),0);
	int deleteField_idnum = Util.getIntValue(request.getParameter("field_idnum"),0);
	RecordSet.executeSql("SELECT attachs FROM workplan WHERE id = " + workplanid);
	if(RecordSet.next()){
		String oldAccessory = Util.null2String(RecordSet.getString(1));
		String newAccessory = oldAccessory;
		
		if(deleteField_idnum>0){
			for(int i=0;i<deleteField_idnum;i++){
				String field_del_flag = Util.null2String(request.getParameter("field_del_"+i));
				if(field_del_flag.equals("1")){
					String field_del_value = Util.null2String(request.getParameter("field_id_"+i));
					RecordSet.executeSql("delete DocDetail where id = " + field_del_value);
					if(newAccessory.indexOf(field_del_value)==0){
						newAccessory = Util.StringReplace(newAccessory,field_del_value+",","");
					}else{
						newAccessory = Util.StringReplace(newAccessory,","+field_del_value,"");
					}
				}
			}
		}
		if(accessorynum>0){
			String[] uploadField=new String[accessorynum];
			for(int i=0;i<accessorynum;i++){
				uploadField[i]="accessory"+(i+1);
			}
			DocExtUtil mDocExtUtil=new DocExtUtil();
			String returnarry1 =request.getParameter("attachs");
			String[] returnarry = returnarry1.split(",");
			if(returnarry != null){
				for(int j=0;j<returnarry.length;j++){
					if(!returnarry[j].equals("-1")){
						if(newAccessory.equals("")){
							newAccessory = String.valueOf(returnarry[j]);
						}else{
							if(!"".equals(String.valueOf(returnarry[j]).trim())){
								newAccessory += ","+String.valueOf(returnarry[j]);
							}
						}
					}
				}
			}
		}
		RecordSet.executeSql("update workplan set attachs='"+newAccessory+"' where id="+workplanid);
		if(!newAccessory.equals("")){
			ArrayList accessoryList = Util.TokenizerString(newAccessory,",");
			for(int i=0;i<accessoryList.size();i++){
				String accessory = (String)accessoryList.get(i);
				//编辑时赋予创建者对附件文档的权限，而不是对所有参与者赋权。
				RecordSet.executeSql("insert into shareinnerdoc(sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource)values("+accessory+",1,"+user.getUID()+",0,1,1,"+user.getUID()+",1)");
			}
		}
	}
}
%>

<%	
	String userId = String.valueOf(user.getUID());
	String userType = user.getLogintype();
	
	Calendar current = Calendar.getInstance();
	String currentDate = Util.add0(current.get(Calendar.YEAR), 4) + "-" + Util.add0(current.get(Calendar.MONTH) + 1, 2) + "-" + Util.add0(current.get(Calendar.DAY_OF_MONTH), 2);
	String method = Util.null2String(request.getParameter("method"));
	String from = Util.null2String(request.getParameter("from"));
	//判断是否是从日历过来
	String frm = Util.null2String(request.getParameter("frm"));
	WorkPlanHandler workPlanHandler = new WorkPlanHandler();
	
	String[] logParams;
	WorkPlanLogMan workPlanLogMan = new WorkPlanLogMan();
	
    //判断是否为系统管理员sysadmin 
    int isSysadmin=0;
    RecordSet rssysadminmenu=new RecordSet();
    rssysadminmenu.executeSql("select count(*) from hrmresourcemanager where id="+userId);	
    if(rssysadminmenu.next()){
	     isSysadmin=rssysadminmenu.getInt(1);
    }    
  //保存附件信息
	
	if (method.equals("add") || method.equals("edit"))
	{	
	    String color = "";
	    String workPlanType = request.getParameter("workPlanType");  //日程类型    
	    String beginDate = Util.null2String(request.getParameter("beginDate"));  //开始日期	    
	    String beginTime = request.getParameter("beginTime");  //开始时间
	    String endDate = Util.null2String(request.getParameter("endDate")).trim();  //结束日期
	    String endTime = request.getParameter("endTime");  //结束时间
	    int timeRangeEnd=23;
		rs.executeSql("select timeRangeEnd from WorkPlanSet order by id");
		if(rs.next()){
			timeRangeEnd	= Util.getIntValue(rs.getString("timeRangeEnd"), 23);
		}
		//如果结束日期为空取开始日期
	    if("".equals(endDate)){
	    	endDate = beginDate;
	    	//如果结束时间为空时
	    	if("".equals(endTime) ){
	    		endTime=(timeRangeEnd<10?"0"+timeRangeEnd:timeRangeEnd)+":59";
	    	} else if(endTime.compareTo(beginTime) <= 0){
	    		//或者结束时间小于开始时间
	    		endDate = "2099-12-31";
	    	}
	    	
	    } else {
	    	if("".equals(endTime)){
	    		endTime=(timeRangeEnd<10?"0"+timeRangeEnd:timeRangeEnd)+":59";
	    	}
	    }
	    String remindBeforeStart = Util.null2String(request.getParameter("remindBeforeStart"));  //是否开始前提醒
	    String remindBeforeEnd = Util.null2String(request.getParameter("remindBeforeEnd"));  //是否结束前提醒
	    
	    WorkPlan workPlan = new WorkPlan();
	    
	    workPlan.setCreaterId(Integer.parseInt(userId));
	    workPlan.setCreateType(Integer.parseInt(userType));
	    
	    if(!"".equals(workPlanType) && null != workPlanType)
	    {
	        workPlan.setWorkPlanType(Integer.parseInt(workPlanType));  //日程类型	
	    }
	    workPlan.setWorkPlanName(Util.null2String(request.getParameter("planName")));  //标题	   
	    workPlan.setUrgentLevel(Util.null2String(request.getParameter("urgentLevel")));  //紧急程度
	    workPlan.setRemindType(Util.null2String(request.getParameter("remindType")));  //日程提醒方式
	    if(!"".equals(remindBeforeStart) && null != remindBeforeStart)
	    {
	        workPlan.setRemindBeforeStart(remindBeforeStart);  //是否开始前提醒
	    }
	    if(!"".equals(remindBeforeEnd) && null != remindBeforeEnd)
	    {
	        workPlan.setRemindBeforeEnd(remindBeforeEnd);  //是否结束前提醒
	    }
		
		String remindDateBeforeStart = request.getParameter("remindDateBeforeStart");
	    
	    if (remindDateBeforeStart != null ) {
	    	remindDateBeforeStart = remindDateBeforeStart.trim();
	    }

	    workPlan.setRemindTimesBeforeStart(Util.getIntValue(remindDateBeforeStart,0)*60+Util.getIntValue(Util.null2String(request.getParameter("remindTimeBeforeStart")),0));  //开始前提醒时间
	    workPlan.setRemindTimesBeforeEnd(Util.getIntValue(request.getParameter("remindDateBeforeEnd"),0)*60+Util.getIntValue(Util.null2String(request.getParameter("remindTimeBeforeEnd")),0));  //结束前提醒时间
		//workPlan.setRemindDateBeforeStart(Integer.parseInt(Util.null2String(request.getParameter("remindDateBeforeStart"))));  //开始前提醒时间(小时)
	    //workPlan.setRemindDateBeforeEnd(Integer.parseInt(Util.null2String(request.getParameter("remindDateBeforeEnd"))));  //结束前提醒时间（小时）
	    workPlan.setResourceId(Util.null2String(request.getParameter("memberIDs")));  //系统参与人
	    workPlan.setBeginDate(beginDate);  //开始日期   
	    if(!"".equals(beginTime) && null != beginTime)
	    {
	        workPlan.setBeginTime(beginTime);  //开始时间
	    }
	    else
	    {
	    	//考虑到新建日程的起始时间和结束时间不同
		    String validedatefrom = beginDate.substring(0,4)+"-01-01";
		    String validedateto = beginDate.substring(0,4)+"-12-31";
		    String startSql="select * from HrmSchedule  where validedatefrom <= '"+validedatefrom+"' and validedateto >= '"+validedateto+"' ";
	    	String startweek = getWeekByDate(beginDate)+"starttime1";
		    if(isSysadmin>0){//若为系统管理员则直接取总部时间
		    	startSql+=" and scheduletype = '3' ";
		    }else{
		    	startSql+=" and relatedid = (select m.subcompanyid1 from hrmresource m where m.id='"+userId+"')";
		    }
	    	rs.execute(startSql);
	    	if(rs.next()){
	              beginTime = rs.getString(startweek);
	              workPlan.setBeginTime(beginTime.equals("")?"00:00":beginTime);  //开始时间
	    	}else{//若无考勤时间记录取 00:00
	    		  workPlan.setBeginTime("00:00");  //开始时间
	    	}	    	
	    }
	    workPlan.setEndDate(endDate);  //结束日期
	    if(!"".equals(workPlan.getEndDate()) && null != workPlan.getEndDate() && ("".equals(endTime) || null == endTime))
	    {	        
		    String validedatefrom = endDate.substring(0,4)+"-01-01";
		    String validedateto = endDate.substring(0,4)+"-12-31";
		    String endSql="select * from HrmSchedule  where validedatefrom <= '"+validedatefrom+"' and validedateto >= '"+validedateto+"' ";	    	
		    String endweek = getWeekByDate(endDate)+"endtime2";		    
		    if(isSysadmin>0){//若为系统管理员则直接取总部时间
		    	endSql+=" and scheduletype = '3' ";
		    }else{
		    	endSql+=" and relatedid = (select m.subcompanyid1 from hrmresource m where m.id='"+userId+"')";
		    }
	    	rsc.execute(endSql);
	    	if(rsc.next()){		    
                endTime = rsc.getString(endweek);
                workPlan.setEndTime(endTime.equals("")?"00:00":endTime);  //结束时间
    	    }else{  //若无考勤时间记录取 00:00
    		    workPlan.setEndTime("00:00");  //结束时间
    	    }
	    }
	    else
	    {
	        workPlan.setEndTime(endTime);  //结束时间
	    }
	    workPlan.setDescription(Util.null2String(request.getParameter("description")));  //内容
	    
	    workPlan.setCustomer(Util.null2String(request.getParameter("crmIDs")));  //相关客户
	    workPlan.setDocument(Util.null2String(request.getParameter("docIDs")));  //相关文档 
	    workPlan.setProject(Util.null2String(request.getParameter("projectIDs")));  //相关项目
	    workPlan.setTask(Util.null2String(request.getParameter("taskIDs")));  //相关项目任务
	    workPlan.setWorkflow(Util.null2String(request.getParameter("requestIDs")));  //相关流程
	    workPlan.setMeeting(Util.null2String(request.getParameter("meetingIDs")));  //相关会议
	  	String attachs= Util.null2String(request.getParameter("attachs"));
	  	String[] arr=attachs.split(",");
	  	attachs="";
	  	for(int j=0;j<arr.length;j++){
	  		if(arr[j].length()>0){
	  			if(attachs.length()>0){
	  				attachs+=",";
	  			}
	  			attachs+=arr[j];
	  		}
	  	}
	   
	    String hrmPerformanceCheckDetailID = Util.null2String(request.getParameter("hrmPerformanceCheckDetailID"));
	    if(null == hrmPerformanceCheckDetailID || "".equals(hrmPerformanceCheckDetailID))
	    {
	        hrmPerformanceCheckDetailID = "-1";
	    }
	    workPlan.setPerformanceCheckId(Integer.parseInt(hrmPerformanceCheckDetailID));  //自定义考核叶子节点
	    
	    
	    if(!"".equals(workPlan.getBeginDate()) && null != workPlan.getBeginDate())
	    {	    	
	    	List beginDateTimeRemindList = Util.processTimeBySecond(workPlan.getBeginDate(), workPlan.getBeginTime(), workPlan.getRemindTimesBeforeStart() * -1 * 60);
	    	workPlan.setRemindDateBeforeStart((String)beginDateTimeRemindList.get(0));  //开始前提醒日期
	    	workPlan.setRemindTimeBeforeStart((String)beginDateTimeRemindList.get(1));  //开始前提醒时间
	    }
	    if(!"".equals(workPlan.getEndDate()) && null != workPlan.getEndDate())
	    {
	    	List endDateTimeRemindList = Util.processTimeBySecond(workPlan.getEndDate(), workPlan.getEndTime(), workPlan.getRemindTimesBeforeEnd() * -1 * 60);
	    	workPlan.setRemindDateBeforeEnd((String)endDateTimeRemindList.get(0));  //结束前提醒日期
	    	workPlan.setRemindTimeBeforeEnd((String)endDateTimeRemindList.get(1));  //结束前提醒时间
	    }

	    if (method.equals("add"))
	    {	
	    	
	        workPlanService.insertWorkPlan(workPlan);  //插入日程
			
		    workPlanShare.setDefaultShareDetail(user,String.valueOf(workPlan.getWorkPlanID()),workPlanType);//只在新增的时候设置默认共享	       
	        //插入日志
	        logParams = new String[]
	        { String.valueOf(workPlan.getWorkPlanID()), WorkPlanLogMan.TP_CREATE, userId, Util.getIpAddr(request) };
	        workPlanLogMan.writeViewLog(logParams);
	
	        //通过工作流提醒参与日程的人员 sean 2005-11-25 for td3273
	        /*String wfTitle = "";
	        String wfRemark = "";
	        if (!"".equals(workPlan.getResourceId()))
	        {
	            wfTitle = SystemEnv.getHtmlLabelName(16651, user.getLanguage());
	            wfTitle += workPlan.getWorkPlanName();
	            wfTitle += "-" + resource.getResourcename(userId);
	            wfTitle += "-" + currentDate;
	            wfRemark =SystemEnv.getHtmlLabelName(18170, user.getLanguage()) + ":<A href=/workplan/data/WorkPlan.jsp?workid=" + workPlan.getWorkPlanID() + ">" + Util.fromScreen2(workPlan.getWorkPlanName(), user.getLanguage()) + "</A>";
	            sysRemindWorkflow.setCRMSysRemind(wfTitle, 0, Util.getIntValue(userId), workPlan.getResourceId(), wfRemark);
	        }*/
		    editAccessory(request,user,workPlan.getWorkPlanID()+"",rs);
			//页面转向
			if (from.equals("1"))
			{
				//out.print("<script>window.opener.location.reload();</script>");
				%>
				<script type="text/javascript">
					try{
					var dialog = parent.getDialog(window);
					dialog.close();
					}catch(e){
					}
				</script>
				<%
				return;
			}else if(from.equals("2")){//客户模块，关闭之后刷新
				
				//out.print("<script>window.opener.document.frmmain.submit();window.close();</script>");	   
				%>
				<script type="text/javascript">
				var dialog = parent.parent.getDialog(parent);
				if(dialog){
					dialog.close();
				} else {
					try{
						parent.getParentWindow(window).closeWin();
					}catch(e){
						try{
							dialog = parent.getDialog(window);
							dialog.close();
						}catch(e1){
							//window.parent.close();
							window.top.close();
						}
					}
				}
				</script>
				<%
				return;
			} else { 
				response.sendRedirect("WorkPlanDetail.jsp?refresh=1&workid=" + workPlan.getWorkPlanID() + "&from=" + from);
			}
	    }
	    else
	    {	  
			String planID = Util.null2String(request.getParameter("workid"));
	    	int shareLevel=WorkPlanShareUtil.getShareLevel(planID,user);
	    	if(shareLevel!=2){//判断用户是否有编辑权限
	    		return;
	    	}
	        WorkPlan oldWorkPlan = new WorkPlan();
	        oldWorkPlan.setWorkPlanID(Integer.parseInt(request.getParameter("workid")));
	        workPlan.setWorkPlanID(oldWorkPlan.getWorkPlanID());
	        String ip = Util.getIpAddr(request);
	        
	        List workPlanList = workPlanService.getWorkPlanList(oldWorkPlan);
	        RecordSet rs1 = new RecordSet();
	        for(int i = 0; i < workPlanList.size(); i++)
	        {
	            oldWorkPlan = (WorkPlan)workPlanList.get(i);
	            //QC:255071修改日程日程类型变更后对应的日程类型权限不会改变
	            if(oldWorkPlan.getWorkPlanType()!=workPlan.getWorkPlanType()){
	            	workPlanShare.setDefaultShareDetail(user,String.valueOf(workPlan.getWorkPlanID()),workPlanType);
	            	rs1.execute("delete WorkPlanShare where workPlanId = "+oldWorkPlan.getWorkPlanID());
	            	rs1.execute("delete WorkPlanShareDetail where workid="+oldWorkPlan.getWorkPlanID());
	            }
	            workPlanService.updateWorkPlan(oldWorkPlan, workPlan);
	            workPlanLogMan.insertEditLog(oldWorkPlan, workPlan, userId, ip);	            
	        }
	        	        	       
		    editAccessory(request,user,workPlan.getWorkPlanID()+"",rs);
	        //重新建立工作流提醒日程修改  Modify by sean 2005-11-25 for td3273
	        /*String wfTitle = "";
	        String wfRemark = "";
	        if (!"".equals(workPlan.getResourceId()))
	        {
	            wfTitle = SystemEnv.getHtmlLabelNames("19899,18170", user.getLanguage());
	            wfTitle += workPlan.getWorkPlanName();
	            wfTitle += "-" + resource.getResourcename(userId);
	            wfTitle += "-" + currentDate;
	            wfRemark = SystemEnv.getHtmlLabelName(18170, user.getLanguage()) + ":<A href=/workplan/data/WorkPlan.jsp?workid=" + workPlan.getWorkPlanID() + ">" + Util.fromScreen2(workPlan.getWorkPlanName(), user.getLanguage()) + "</A>";
	            sysRemindWorkflow.setCRMSysRemind(wfTitle, 0, Util.getIntValue(userId), workPlan.getResourceId(), wfRemark);
	        }*/
	
	        //日程接受人员发生改动，则删除打分表中相关人员记录（打分功能已取消）
	        //workPlanValuate.changeWorkPlanMembers(planID);
			if (from.equals("1"))
			{
				//out.print("<script>window.opener.location.reload();</script>");
				%>
				<script type="text/javascript">
				    try{
					var dialog = parent.getDialog(window);
					if(!dialog){
						dialog = parent.parent.getDialog(parent);
					}
					dialog.close();
					}catch(e){alert(e);}
				</script>
				<%
				return;
			}
		    response.sendRedirect("WorkPlanDetail.jsp?refresh=1&workid=" + workPlan.getWorkPlanID() + "&from=" + from);
	    }	
	}
	
	else if (method.equals("delete"))
	{
		
	    String planID = Util.null2String(request.getParameter("workid"));
	    int shareLevel=WorkPlanShareUtil.getShareLevel(planID,user);
	    if(shareLevel!=2){//判断当前用户是否有此日程的编辑权限
	    	return;
	    }
	    PoppupRemindInfoUtil.deletePoppupRemindInfo(Util.getIntValue(planID),12);
		PoppupRemindInfoUtil.deletePoppupRemindInfo(Util.getIntValue(planID),13);
	    
	 	//插入日志
	    logParams = new String[]
	    { planID, WorkPlanLogMan.TP_DELETE, userId, Util.getIpAddr(request) };	    
	    workPlanLogMan.writeViewLog(logParams);
	    
	    workPlanHandler.delete(planID);
	    
	    exchange.workPlanDelete(Integer.parseInt(planID));
		if (from.equals("1"))
		{
			//out.print("<script>window.opener.document.frmmain.submit();window.close();</script>");
			%>
			<script type="text/javascript">
				try{
					var parentWin = parent.parent.getParentWindow(window.parent);
					parentWin.closeDlgAndRfsh();
				}catch(e){
					try{
						var dialog = parent.parent.getDialog(window.parent);
					    dialog.close();						
					}catch(e1){
 						//window.parent.close();
						window.top.close();
					}
				}
			</script>
			<%
			return;
		}
		else
		{
			%>
			<script type="text/javascript">
				try{
					window.parent.parent.closeDlgAndRfsh();
				}catch(e){
					try{
						var parentWin = parent.parent.getParentWindow(window.parent);
						parentWin.closeDlgAndRfsh();
					}catch(e1){
						try{
							var dialog = parent.parent.getDialog(window.parent);
						    dialog.close();
					    }catch(e2){
 							//window.parent.close();
					    	window.top.close();
						}
					}
				}
			</script>
			<%
			return;
		}
	}
	
	else if (method.equals("finish"))
	//非提交人完成
	{
	    String planID = Util.null2String(request.getParameter("workid"));
	    
	    List<User> userList=new ArrayList<User>();
		userList.add(user);
		List tempUserList=User.getBelongtoUsersByUserId(user.getUID());//获取主次帐号
		if(tempUserList!=null) userList.addAll(tempUserList);
		boolean canfinish=false;
		for(int i=0;i<userList.size();i++){
			int tempuid=userList.get(i).getUID();
			rs.executeSql("SELECT * FROM workplan WHERE id = " + planID+" and (resourceid='"+tempuid+"' or resourceid like '"+tempuid+",%' or resourceid like '%,"+tempuid+"' or resourceid like '%,"+tempuid+",%')");
		    if(rs.next()){
		    	canfinish=true;
		    	break;
		    }
		}
	    if(canfinish){//是日程接收人才可以生成并发送流程提醒

		    String[] creater = workPlanHandler.getCreater(planID);
		    String createrID = "";
		
		    if (creater != null)
		    {
		        createrID = creater[0];
		    }
		
		    String planName = workPlanHandler.getWorkPlanName(planID);
		
		    String accepter = createrID;
		    String wfTitle = "";
		    String wfRemark = "";
		
		    wfTitle = SystemEnv.getHtmlLabelName(16653, user.getLanguage())+":";
		    wfTitle += planName;
		    wfTitle += "-" + resource.getResourcename(userId);
		    wfTitle += "-" + currentDate;
		    wfRemark = SystemEnv.getHtmlLabelName(18170, user.getLanguage()) + ":<A href=/workplan/data/WorkPlan.jsp?workid=" + planID + ">" + Util.fromScreen2(planName, user.getLanguage()) + "</A>";
		
		    sysRemindWorkflow.setCRMSysRemind(wfTitle, 0, Util.getIntValue(userId), accepter, wfRemark);
		
		    workPlanHandler.memberFinishWorkPlan(planID);
	    }
		if (from.equals("1"))
		{
			//out.print("<script>window.opener.document.frmmain.submit();window.close();</script>");
			%>
			<script type="text/javascript">
				try{
				var dialog = parent.parent.getDialog(window.parent);
				dialog.close();
				}catch(e){}
			</script>
			<%
			return;
		}
		else
		{
			%>
			<script type="text/javascript">
				try{
					window.parent.parent.closeDlgAndRfsh();
				}catch(e){
					try{
						var parentWin = parent.parent.getParentWindow(window.parent);
						parentWin.closeDlgAndRfsh();
					}catch(e1){
						try{
							var dialog = parent.parent.getDialog(window.parent);
						    dialog.close();
					    }catch(e2){
 							//window.parent.close();
					    	window.top.close();
						}
					}
				}
			</script>
			<%
			return;
		}
	}
	
	else if (method.equals("valfinish"))
	//上级打分
	{
	    String planID = Util.null2String(request.getParameter("workid"));
	    String planStatus = Util.null2String(request.getParameter("status"));
	    String valMembers = Util.null2String(request.getParameter("valmembers"));
	    String valScores = Util.null2String(request.getParameter("valscores"));
	
	    String[] params;
	    if (planStatus.equals("0"))
		//创建人打分
	    { 
	        params = new String[]
	        { planID, valMembers, valScores, currentDate };
	        workPlanValuate.createrValuateMembers(params);
	    }
	
	    if (planStatus.equals("1"))
		//经理打分
	    {
	        params = new String[]
	        { planID, valMembers, valScores, userId, currentDate };
	        workPlanValuate.managerValuateMembers(params);
	    }
		
		%>
		<script type="text/javascript">
		try{
			window.parent.closeDlgAndRfsh();
		}catch(e){
			var parentWin = parent.getParentWindow(window);
			parentWin.closeDlgAndRfsh();
		}
		</script>
		<%
		return;

	    //out.print("<script>window.opener.location.reload();window.close();</script>");

	}
	
	else if (method.equals("notefinish"))
	//提交人完成
	{
	    String planID = Util.null2String(request.getParameter("workid"));
	    String planStatus = Util.null2String(request.getParameter("status"));
	    
	    List<User> userList=new ArrayList<User>();
		userList.add(user);
		List tempUserList=User.getBelongtoUsersByUserId(user.getUID());//获取主次帐号
		if(tempUserList!=null) userList.addAll(tempUserList);
		
		boolean canfinish=false;
		for(int k=0;k<userList.size();k++){
			int tempuid=userList.get(k).getUID();
			rs.executeSql("SELECT * FROM workplan WHERE id = "+ planID+" and createrid="+tempuid);
		    if(rs.next()){
		    	canfinish=true;//当前用户是创建人
		    	break;
		    }
		}
		if(canfinish){
		    if("".equals(planStatus)){
			    rs.executeSql("select status from workplan where id = " + planID);
				if(rs.next()){
					planStatus = Util.null2String(rs.getString("status"));
				}
			}
		
		    if (planStatus.equals("0"))
		    {
		        workPlanHandler.finishWorkPlan(planID);
		    }
		
		    if (planStatus.equals("1"))
		    {
		        workPlanHandler.closeWorkPlan(planID);
		    }
		}
		if (from.equals("1"))
		{
			//out.print("<script>window.opener.document.frmmain.submit();window.close();</script>");	   
			%>
			<script type="text/javascript">

				try{
					var parentWin = parent.parent.getParentWindow(window.parent);
					parentWin.closeDlgAndRfsh();
				}catch(e){
					try{
						var dialog = parent.parent.getDialog(window.parent);
					    dialog.close();
				    }catch(e2){
							//window.parent.close();
				    	window.top.close();
					}
				}
				window.parent.parent.location.reload();
			</script>
			<%
			return;
		}
		else
		{
			%>
			<script type="text/javascript">
				try{
					window.parent.parent.closeDlgAndRfsh();
				}catch(e){
					try{
						var parentWin = parent.parent.getParentWindow(window.parent);
						parentWin.closeDlgAndRfsh();
					}catch(e1){
						try{
							var dialog = parent.parent.getDialog(window.parent);
						    dialog.close();
					    }catch(e2){
							//window.parent.close();
					    	window.top.close();
						}
					}
				}
				window.parent.parent.location.reload();
			</script>
			<%
		}
	}
	else if (method.equals("convert"))
	{
	    String planID = Util.null2String(request.getParameter("workid"));
	
	    workPlanHandler.note2WorkPlan(planID);
	    response.sendRedirect("WorkPlanDetail.jsp?workid=" + planID + "&from=" + from);
	}
	else if (method.equals("addnote"))
	{
	    String note = Util.null2String(request.getParameter("note"));
	    String planID = String.valueOf(workPlanHandler.addNote(note, userId, userType));
	
	    workPlanViewer.setWorkPlanShareById(planID);
	
	    //插入日志
	    logParams = new String[]
	    { planID, WorkPlanLogMan.TP_CREATE, userId, Util.getIpAddr(request)};
	    workPlanLogMan.writeViewLog(logParams);

		if (from.equals("1"))
		{
			//out.print("<script>window.opener.location.reload();window.close();</script>");
			%>
			<script type="text/javascript">
			try{
				var dialog = parent.parent.getDialog(window.parent);
				dialog.close();
			}catch(e){
 				//window.parent.close();
				window.top.close();
			}
			</script>
			<%
		}
		else
		{
		 %>
		<script type="text/javascript">
		    try{
			window.parent.closeDlgAndRfsh();
			}catch(e){
				try{
					var parentWin = parent.getParentWindow(window.parent);
					parentWin.closeDlgAndRfsh();
				}catch(e1){
					try{
						var dialog = parent.getDialog(window.parent);
					    dialog.close();
				    }catch(e2){
						window.close();
					}
				}
			}
		</script>
		<%
		}

	}else if (method.equals("batchfinish"))
	//提交人完成
	{
		
		List<User> userList=new ArrayList<User>();
		userList.add(user);
		List tempUserList=User.getBelongtoUsersByUserId(user.getUID());//获取主次帐号
		if(tempUserList!=null) userList.addAll(tempUserList);
		
	    String planIds = Util.null2String(request.getParameter("workid"));
	    String[] planIdArr=planIds.split(",");
	    for(int i=0;i<planIdArr.length;i++){
	    	if(!planIdArr[i].equals("")){
	    		
	    		boolean canfinish=false;
	    		for(int k=0;k<userList.size();k++){
	    			int tempuid=userList.get(k).getUID();
	    			rs.executeSql("SELECT * FROM workplan WHERE id = "+ planIdArr[i]+" and createrid="+tempuid);
	    		    if(rs.next()){
	    		    	canfinish=true;//当前用户是创建人
	    		    	break;
	    		    }
	    		}
	    		if(canfinish){
	    			String planStatus="";
		    		 rs.executeSql("select status from workplan where id = " + planIdArr[i]);
		 			if(rs.next()){
		 				planStatus = Util.null2String(rs.getString("status"));
		 			}
		    		if (planStatus.equals("0"))
		    	    {
		    	        workPlanHandler.finishWorkPlan(planIdArr[i]);
		    	    }
		    	
		    	    if (planStatus.equals("1"))
		    	    {
		    	        workPlanHandler.closeWorkPlan(planIdArr[i]);
		    	    }
	    		}
	    		
	    	}
	    }
		if (from.equals("1"))
		{
			//out.print("<script>window.opener.document.frmmain.submit();window.close();</script>");	   
			%>
			<script type="text/javascript">
				try{
					var parentWin = parent.parent.getParentWindow(window.parent);
					parentWin.closeDlgAndRfsh();
				}catch(e){
					try{
						var dialog = parent.parent.getDialog(window.parent);
					    dialog.close();
				    }catch(e2){
						//window.parent.close();
				    	window.top.close();
					}
				}
			</script>
			<%
			return;
		}
		else
		{
			%>
			<script type="text/javascript">
				try{
					window.parent.parent.closeDlgAndRfsh();
				}catch(e){
					try{
						var parentWin = parent.parent.getParentWindow(window.parent);
						parentWin.closeDlgAndRfsh();
					}catch(e1){
						try{
							var dialog = parent.parent.getDialog(window.parent);
						    dialog.close();
					    }catch(e2){
 							//window.parent.close();
					    	window.top.close();
						}
					}
				}
			</script>
			<%
		}
	}
	else
	{
	    return;
	}
%>

<%!
// 根据日期取星期（TD20444）
public String getWeekByDate(String date){
	String week=""; 
	DateFormat format1 = new SimpleDateFormat("yyyy-MM-dd"); 
	   Date d=null;
	  try {
	   d = format1.parse(date);
	  } catch (Exception e) {
	   e.printStackTrace();
	  }
	   Calendar   c   =   Calendar.getInstance();   
	   c.setTime(d);
	   week = c.getTime().toString().substring(0,3).toLowerCase();
	   return week;    	
}


%>
