
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.general.SplitPageParaBean"%>
<%@page import="weaver.general.SplitPageUtil"%>
<%@page import="weaver.conn.RecordSet"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="weaver.general.TimeUtil"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="cmutil" class="weaver.task.CommonTransUtil" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="taskUtil" class="weaver.task.TaskUtil" scope="page"/>
<%	
    String viewType=Util.null2String(request.getParameter("viewType"));//查看类型
    String moduleType=Util.null2String(request.getParameter("moduleType"));//被查看模块类型
    int filterType=Util.getIntValue(request.getParameter("filterType"));//过滤类型  默认为0
    String mainlineid = Util.null2String(request.getParameter("mainlineid"));//被查看主线Id
    String labelid = Util.null2String(request.getParameter("labelid"));//被查看主线Id
    String hrmid = Util.null2String(request.getParameter("hrmid"));    //被查看人Id
    String keyword = Util.null2String(request.getParameter("keyword"));    //查询关键字
    String operation = Util.null2String(request.getParameter("operation"));  //操作方式   listmoren 获取更多
    StringBuffer str = new StringBuffer();
    //String querystr=request.getQueryString();
    String querystr=new String(request.getQueryString().getBytes("ISO-8859-1"));
    
    int pageIndex=Util.getIntValue(request.getParameter("pageindex"),1);
    int pagesize=Util.getIntValue(request.getParameter("pagesize"),30);
    
    boolean isCanCheck=true;
    boolean isCanMarkdate=true;
    boolean canEdit = true;
    
	String userid = user.getUID()+"";
	String principalid = userid;
	
	String todaydate=TimeUtil.getCurrentDateString();   //今天时间
	String tomorrowdate=TimeUtil.dateAdd(todaydate,1);  //明天时间
	String acquireddate=TimeUtil.dateAdd(todaydate,2);  //后天时间
	
	String currentdate = TimeUtil.getCurrentDateString();
	String currenttime=TimeUtil.getOnlyCurrentTimeString();
	
	String[] tasktypes={"task","wf","meeting","doc","cowork","email"};
	Map tasktypeMap = new HashMap();
	tasktypeMap.put("task","1");
	tasktypeMap.put("wf","2");
	tasktypeMap.put("meeting","3");
	tasktypeMap.put("doc","4");
	tasktypeMap.put("cowork","5");
	tasktypeMap.put("email","6");
	
	
	String status="1";
	int index = 0;
	
	boolean noreadfb = false;//是否有未读反馈
	int special = 0;//是否标记为重要
	
	String basesql="";
	String sqlform="";
	Map orderBy=new LinkedHashMap();
	String backfields="*";
	
	if(viewType.equals("mainlineset"))
		backfields="*";  
	else
	    backfields="tasktype,taskid,taskName,creater,isnew,isfeedback,createdate,createtime";
	
	String sqlwhere=Util.null2String(request.getParameter("sqlwhere"));
	String sqlprimarykey="";
	int sortway=1;
    int otype=1;
	
    String sqlall="";
    
    String startdate=startdate=TimeUtil.dateAdd(todaydate,-180);
    
    if(viewType.equals("workcenter")){
    	
   		backfields="tasktype,taskid,taskName,creater,isnew,isfeedback,createdate,createtime,begindate,enddate";
   		basesql="("+taskUtil.getWorkCenterSql(userid,moduleType,filterType,backfields,startdate)+") a ";
   		
    }else if(viewType.equals("allFeedback")){   //所有反馈
    	
    	startdate=TimeUtil.dateAdd(todaydate,-180);
    	basesql="("+taskUtil.getallFeedbackSql(userid,moduleType,filterType,backfields,startdate)+") a "; 
   	    
    }else if(viewType.equals("attTask")||viewType.equals("attFeedback")){  //查看关注事项
    	
    	basesql="("+taskUtil.getAttTaskSql(userid,moduleType,filterType,backfields,startdate)+") a " ;
    
	}else if(viewType.equals("mainline")){  //查看主线任务
		
		basesql="("+taskUtil.getMainlineTaskSql(userid,moduleType,filterType,backfields,startdate,mainlineid)+") a " ; 
	}else if(viewType.equals("label")){    //查看标签任务 
		basesql="("+taskUtil.getLabelTaskSql(userid,moduleType,filterType,backfields,startdate,labelid)+") a " ;
	}else if(viewType.equals("viewhrm")){  //查看人员
		backfields="tasktype,taskid,taskName,creater,isnew,isfeedback,createdate,createtime,begindate,enddate ";
		basesql="("+taskUtil.getViewHrmSql(userid,hrmid,moduleType,filterType,backfields,startdate)+") a " ;
	}else if(viewType.equals("search")){  //搜索
		sqlall="("
   		       +taskUtil.getBaseSql(userid,moduleType,filterType,backfields,startdate);  
   		       if(moduleType.equals("aff")) //全部时才显示人员
   		    	sqlall+="UNION ALL "
	           		  +"SELECT tasktype,taskid,taskName,creater,isnew,isfeedback,createdate,createtime FROM (SELECT 8 AS tasktype,id AS taskid,lastname AS taskname,CAST(id AS VARCHAR(100)) AS creater,0 AS isnew ,0 AS isfeedback,'"+currentdate+"' AS createdate,'"+currenttime+"' AS createtime  FROM HrmResource WHERE (status =0 or status = 1 or status = 2 or status = 3) and lastname LIKE '%"+keyword+"%') a ";
   		  	   sqlall+=" ) a ";
   		basesql=sqlall;
	}
	
	backfields=backfields+",taskdate,attentionid";
	sqlform=basesql
	        +" LEFT JOIN "
            +"(SELECT distinct taskid AS scheduleid,taskdate,tasktype as stasktype FROM Task_schedule WHERE userid="+(viewType.equals("viewhrm")?hrmid:userid)+") s1 ON a.tasktype=s1.stasktype and a.taskid=s1.scheduleid "
	        +" LEFT JOIN "
	        +"(SELECT distinct taskid AS attentionid FROM Task_attention WHERE userid="+userid+") s2 ON a.taskid=s2.attentionid "; 
	sqlprimarykey="tasktype";
	
	boolean sqlisdistinct=false;
	boolean sqlisprintsql=true;
    
	SplitPageParaBean spp = new SplitPageParaBean();
	SplitPageUtil spu=new SplitPageUtil();
	
	//按照 未读  反馈  时间 排序
	orderBy.put("isnew",spp.ASC);
	orderBy.put("isfeedback",spp.ASC);
	orderBy.put("createdate",spp.DESC);
	orderBy.put("createtime",spp.DESC);
	
	spp.setBackFields(backfields);
	spp.setSqlFrom(sqlform);
	spp.setPrimaryKey(sqlprimarykey);
	spp.setOrderByMap(orderBy);
	spp.setSortWay(spp.ASC);
    
	int dateType=Util.getIntValue(request.getParameter("dateType"),0);  // 0 今天事务  1 明天事务  2 将要进行

	String[] typeNames={"任务","流程","会议","文档","协作","邮件","","人员"};
		
	if((viewType.equals("workcenter")||viewType.equals("viewhrm"))&&(moduleType.equals("aff")||moduleType.equals("task")||(moduleType.equals("wf")&&filterType==0)||moduleType.equals("meeting"))){
	    if(dateType==0)       //事务中今天包含 任务，流程，会议 标记时间的协作、文档、邮件 以及新到达的协作
		   sqlwhere=" (taskdate is null or taskdate<='"+todaydate+"') and (tasktype in(2,8) or (tasktype in (1,3) and (begindate<='"+todaydate+"' or isnew=0)) or (tasktype=5 and (taskdate is not null or isnew=0)) or ((tasktype=4 or tasktype=6) and taskdate is not null) )";
	    else if(dateType==1)  //今天事务
	       sqlwhere=" taskdate='"+tomorrowdate+"' or (tasktype in (1,3) and begindate='"+tomorrowdate+"' and isnew<>0 ) ";
	    else if(dateType==2)  //将要进行
	       sqlwhere=" taskdate>='"+acquireddate+"' or (tasktype in (1,3) and begindate>='"+acquireddate+"' and isnew<>0 ) ";
	}else if(viewType.equals("attTask")){ //查看关注事项
		sqlwhere=" attentionid is not null";
	}else if(viewType.equals("attFeedback")){  //查看我关注的所有反馈
		sqlwhere=" attentionid is not null and isfeedback=0 and isnew<>0 ";
	}else if(viewType.equals("allFeedback")){  //查看我负责的所有反馈
		sqlwhere=" isfeedback=0 and isnew<>0 ";
	}else if(viewType.equals("search")){  //查看我负责的所有反馈
		sqlwhere=" taskname like '%"+keyword+"%' ";
	}
	spp.setSqlWhere(sqlwhere);
	spu.setSpp(spp);
	
	int total= Util.getIntValue(request.getParameter("operation"),0);
	if(operation.equals("listmore"))
		spu.setRecordCount(total);
	else
        total = spu.getRecordCount();
	
	int totalpage=total%pagesize==0?total/pagesize:(total/pagesize+1);
	rs = spu.getCurrentPageRs(pageIndex, pagesize);
	
	while(rs.next()){
		
		int taskType=rs.getInt("tasktype");       //任务类型
		String taskid=rs.getString("taskid");     //任务id
		String taskName1=rs.getString("taskName"); //任务名称
		String taskdate=rs.getString("taskdate"); //标记日期
		String creater=rs.getString("creater");   //创建人
		String createrName=taskType!=6?resourceComInfo.getLastname(creater):creater; //创建人 邮件为发件人
		int isnew=rs.getInt("isnew");             //阅读状态
		int isfeedback=rs.getInt("isfeedback");   //是否有反馈
		int isattention=rs.getString("attentionid").equals("")?0:1; //关注状态
		String taskName = Util.toHtmltextarea(taskName1);
	%>
			<tr class="item_tr" _taskid="<%=taskid%>" _tasktype="<%=taskType%>" _creater="<%=creater%>" _dateType="<%=dateType%>" style="height: 28px;padding: 0px;margin: 0px;">
				<td width="23px" nowrap="nowrap" class='td_move'><div>&nbsp;</div></td>
				<td width="18px" class="checkbox" nowrap="nowrap">
				   <%if(taskType!=8){%>
				    <input name="check_items" type="checkbox" class="check_input" onclick="checkOnClick(this,event)">
				   <%}%> 
				</td>
				<td width="18px" valign="middle" nowrap="nowrap">
				  <%if(taskType!=8&&viewType.equals("workcenter")){
				  		if(taskType==3||taskType==1) taskdate=rs.getString("begindate");
				  		int isCanMark=1;
				  		if(taskType==3) isCanMark=0; //会议不能标记时间
				  		if(taskType==1&&!userid.equals(creater)) isCanMark=0; //任务只有任务负责人才可以标记时间
				  %>
				      <div id="date_<%=taskid%>" _isCanMark="<%=isCanMark%>" class="<%=taskdate.equals("")&&isCanMark==0?"":"div_date"%> <%=taskdate.equals("")?"":"div_date_show" %>" _taskdate="<%=taskdate%>" title="<%=taskdate.equals("")?"未标记日期":taskdate%>"><div style="width: 100%;height: 100%;display:none;"></div></div>
				  <%}else {%>
				  	   &nbsp;
				  <%}%>
				</td>
				<td width="18px" valign="middle" nowrap="nowrap">
				  <%if(taskType!=8){%>
				   <div  style="cursor: pointer;" class='item_att item_att<%=isattention %>' title="<%if(isattention==0){%>标记关注<%}else{%>取消关注<%}%>" _special="<%=isattention %>"></div>
				  <%}%>
				</td>
				<td class='item_td' valign="top" style="position: relative;">
				  <div   contenteditable='<%=(taskType == 1 && creater.equals(userid))?"true":"false" %>' onfocus="doClickItem(this)" onblur='doBlurItem(this)' class="itemTitleDiv disinput <%if(isnew==0){%>newinput<%}else if(isfeedback==0){%>fbinput<%}%>" type="text" name="" _tasktype="<%=taskType%>" id="<%=taskid%>" _taskid="<%=taskid%>" title="<%=taskName%>"  value="<%=taskName%>" _index="<%=index++ %>"><%=taskName %></div>
				</td>
				
				<td width="60px" align="left" class='item_count'>
				    <%
				      String sql=" SELECT t1.labelid AS labelid,t2.name,1 AS labeltype FROM Task_labelTask t1,task_label t2 WHERE  t1.labelid=t2.id AND tasktype="+taskType+" AND taskid="+taskid+" AND userid="+userid
				    	        +" UNION ALL"
				    	        +" SELECT t1.mainlineid AS labelid,t2.name,2 AS labeltype FROM Taks_mainlineTask t1,Task_mainline t2  WHERE t1.mainlineid=t2.id AND tasktype="+taskType+" AND taskid="+taskid;
				      rs2.execute(sql);
				      String labelstr="";
				      String labelTitle="";
				      while(rs2.next()){
				    	 labelstr=labelstr+"<span id='labelstr"+rs2.getInt("labelid")+"'  _type='"+rs2.getInt("labeltype")+"'>"+rs2.getString("name")+"</span>&nbsp;&nbsp;";
				    	 labelTitle = labelTitle + rs2.getString("name")+" " ;
				      }
				    %>
				    <div id="labelstr" class="labelstr" title="<%=labelTitle%>"><%=labelstr%></div>
				</td>
				<td width="30px" align="center"><div class="div_today" id="today_<%=taskid%>"><%=typeNames[taskType-1] %></div></td>
				<td width="40px" class='item_hrm' title='<%=createrName%>'><a href="javascript:viewHrm('<%=creater%>',<%=taskType%>)"><%=createrName%></a></td>
			</tr>
		<%			
		   }
		   if(moduleType.equals("task")&&!operation.equals("listmore")){
		%>
		    <tr class='item_tr' _tasktype=1>
				<td class="td_blank"><div>&nbsp;</div></td>
				<td></td>
				<td><div id='' class="div_m_date" title=''>&nbsp;</div></td>
				<td class='item_att'>&nbsp;</td>
				<td class='item_td'>
					<div onfocus='doClickItem(this)' contenteditable="true" onblur='doBlurItem(this)' class='disinput addinput definput' type='text' name='' value='' id='' _index="<%=index++ %>">新建任务</div>
				</td>
				<td class='item_count'>&nbsp;</td>
				<td><div id="" class="div_today" title=''>&nbsp;</div></td>
				<td class='item_hrm'>&nbsp;</td>
			</tr>
		  <%} %>
		
		<%if(totalpage>pageIndex&&!operation.equals("listmore")){%>
		  <tr style="padding:0px;margin: 0px;">
		     <td width="23px" style="height: 27px;;background: #EFEFEF;border-top: 0px;"></td>
		     <td colspan="7" style="height: 27px;border-top: 0px;" valign="top">
		      <div class="listmore" id="listmorediv" _init="0" _viewType="<%=viewType%>" _moduleType="<%=moduleType%>" _filterType="<%=filterType%>" onclick="getListMore(this)" _datalist="datalist<%=dateType%>" _dateType="<%=dateType%>" _pageindex="<%=pageIndex+1%>" _pagesize="<%=pagesize%>" _total="<%=total%>" _totalpage="<%=totalpage%>" _sqlwhere="<%=sqlwhere%>" _querystr="<%=querystr%>" _querysql="" _excludeids="" title="显示更多数据">
		              更多&nbsp;<img src="/blog/images/more_down_wev8.png" align="absmiddle">
		      </div>
		    </td>
		  </tr>  
		<%} %>
		
		<%
		 if(!moduleType.equals("task")&&total==0&&!operation.equals("listmore")){
		%>
			<tr style="padding:0px;margin: 0px;" class="norecord">
		     <td width="23px" style="height: 27px;;background: #EFEFEF;border-top: 0px;"></td>
		     <td colspan="7" style="height: 27px;border-top: 0px;" valign="middle" align="center">
		      	暂时没有数据
		    </td>
		  </tr>
		<%}%>   
