
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.task.TaskUtil"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.SplitPageParaBean"%>
<%@page import="weaver.general.SplitPageUtil"%>
<%@page import="weaver.general.TimeUtil"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.docs.docs.DocImageManager"%>
<jsp:useBean id="cmutil" class="weaver.task.CommonTransUtil" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
 String userid=user.getUID()+"";
 String type=Util.null2String(request.getParameter("type"));
 String operation=Util.null2String(request.getParameter("operation"));
 int pageindex=Util.getIntValue(Util.null2String(request.getParameter("pageindex")),1);
 type=type.equals("")?"task":type;
 TaskUtil taskUtil=new TaskUtil();
 String sql="";
 String todaydate=TimeUtil.getCurrentDateString();
 String halfMonthDate=TimeUtil.dateAdd(todaydate,-180);
 String timesql="b.createdate+' '+b.createtime>a.readdate+' '+a.readtime";
 if(rs.getDBType().equals("oracle"))
	 timesql="b.createdate||' '||b.createtime>a.readdate||' '||a.readtime";
 if(type.equals("task")){    //任务反馈 
    sql=" (SELECT content,b.createdate,b.createtime,hrmid as creator,a.taskid,a.taskname,a.tasktype FROM TM_TaskFeedback b,"+taskUtil.getTaskSql(1,user.getUID()+"","")
        +" WHERE b.createdate>'"+halfMonthDate+"' and b.taskid=a.taskid AND "+timesql+") a ";
 }else if(type.equals("cowork")){ //协作反馈
	sql=" (SELECT remark AS content,b.createdate,b.createtime,discussant as creator,a.taskid,a.taskname,a.tasktype FROM cowork_discuss b,(select a.*,c.readdate,c.readtime from "+taskUtil.getCoworkSql(0,user.getUID()+"",halfMonthDate)+",(SELECT coworkid,modifydate AS readdate,modifytime AS readtime FROM cowork_log s1,(SELECT max(id) AS maxid FROM cowork_log WHERE modifier="+userid+" GROUP BY coworkid) s2 WHERE s1.id=s2.maxid) c where a.taskid=c.coworkid) a "
        +" WHERE b.createdate>'"+halfMonthDate+"' and b.coworkid=a.taskid AND "+timesql+") a";
 }else if(type.equals("wf")){ //流程反馈
	sql=" (select remark AS content,b.operatedate as createdate,b.operatetime as createtime,b.operator as creator,a.taskid,a.taskname,a.tasktype from "
		+"(SELECT * FROM workflow_requestLog s1,(SELECT max(logid) AS maxid FROM workflow_requestLog where operatedate>'"+halfMonthDate+"' GROUP BY requestid) s2 WHERE s1.logid=s2.maxid) b,"+taskUtil.getWorkflowSql(4,user.getUID()+"","")
	    +" where (a.isfeedback=0 or a.isnew=0) and  b.requestid=a.taskid ) a ";
 }else if(type.equals("blog")){ //微博反馈
	sql=" (select content,createdate,createtime,userid AS creator,userid AS taskid,workdate AS taskname,7 AS tasktype FROM (SELECT id,remindValue FROM blog_remind WHERE createdate>'"+halfMonthDate+"' and remindid="+userid+" AND remindType=6) t0 " 
		+"LEFT JOIN blog_discuss t1 ON cast(t0.remindValue as int)=t1.id ) a ";
}
 
 if(type.equals("news")){      //新闻
	 sql="( select taskid,taskname,createdate,createtime from "+taskUtil.getDocSql(1,userid,halfMonthDate)+" where createdate>'"+halfMonthDate+"' and isnew=0 and docpublishtype in(2,3) ) a ";
 }else if(type.equals("doc")){ //最新文档
	 sql="( select taskid,taskname,createdate,createtime from "+taskUtil.getDocSql(1,userid,halfMonthDate)+" where createdate>'"+halfMonthDate+"' and isnew=0 and docpublishtype=1 ) a ";
 }
 
    SplitPageParaBean spp = new SplitPageParaBean();
	SplitPageUtil spu=new SplitPageUtil();
	
	Map orderBy=new LinkedHashMap();
	//orderBy.put("taskdate",spp.ASC);
	orderBy.put("createdate",spp.DESC); 
	orderBy.put("createtime",spp.DESC);
	
	spp.setBackFields("*");
	spp.setSqlFrom(sql);
	spp.setPrimaryKey("taskid");
	//spp.setSqlOrderBy(orderBy);
	spp.setOrderByMap(orderBy);
	spp.setSortWay(spp.ASC);
	
	spp.setSqlWhere("");
	spu.setSpp(spp);
	spu.setRecordCount(0);
    int total = spu.getRecordCount();
    int pagesize=20;
	int totalpage=total%pagesize==0?total/pagesize:(total/pagesize+1);
	rs = spu.getCurrentPageRs(pageindex, pagesize);
 
    //System.out.println("feedback========="+sql);
    //rs.execute(sql);
 
 if(!type.equals("news")&&!type.equals("doc")){
      while(rs.next()){
	      String taskid=rs.getString("taskid");
	      String taskname=rs.getString("taskname");
	      String content=rs.getString("content");
	      String createdate=rs.getString("createdate");
	      String createtime=rs.getString("createtime");
	      String creator=rs.getString("creator");
	      String tasktype=rs.getString("tasktype");
	      if(tasktype.equals("7"))
	    	     taskname=resourceComInfo.getLastname(taskid)+taskname+"的微博";
	    %>
	    <table class="message_contend" style="width:98%;margin-top:10px;">
	       <tr>
	           <td valign="top" width="45px">
	                <div class="imgDiv"><img src="<%=resourceComInfo.getMessagerUrls(creator)%>" width="40px"></div>
	                <div align="center" style="margin-top: 5px;color:#999999"><a class="a1" href="/hrm/resource/HrmResource.jsp?id=<%=creator%>" target="_blank"><%=resourceComInfo.getLastname(creator)%></a></div>
	           </td>
	           <td valign="top" style="padding-bottom:8px;">
					<div>
					    <div style="height:16px;">
					        <div class="taskItems" style="float: left;margin-top: 0px;" ><a title="<%=taskname %>" class="a1" href="javascript:openTask(<%=taskid%>,<%=tasktype%>)"><%=taskname%></a>&nbsp;&nbsp;</div>
					        <div style="margin-right:18px; float:right;color:#999999"><span><%=createdate %>&nbsp;<%=createtime %></span></div>
					        <div style="clear: both;"></div>
					    </div>
					    <div>
							<div class="taskImg"></div>
							<div class="taskContend" style="width:98%">
								<div style="padding: 10px;">
								    <%=content%>
								</div>
							</div>
							<div style="clear: both;"></div>
						</div>
					</div>
	           </td>
	       </tr>
	    </table>
		<%}%>
		   
<%}else{
       while(rs.next()){
    	  String taskid=rs.getString("taskid");
 	      String taskname=rs.getString("taskname");
 	      String createdate=rs.getString("createdate");
	      String createtime=rs.getString("createtime");
	      String tasktype="4";
%>
       <div class="message_contend" style="padding-top: 8px;padding-bottom: 8px;padding-left: 5px;">
          <div class="taskItems" style="float: left;margin-top: 0px;"><a title="<%=taskname %>" class="a1" href="javascript:openTask(<%=taskid%>,<%=tasktype%>)"><%=taskname%></a>&nbsp;&nbsp;</div>
		  <div style="margin-right:18px; float:right;color:#999999"><span><%=createdate %>&nbsp;<%=createtime %></span></div>
		  <div style="clear: both;"></div>
      </div>
<%
       }
}%>
<%if(totalpage>1&&!operation.equals("listmore")){ %>
<DIV id=moreList _totalpage="<%=totalpage%>" _pageindex="2" _type="<%=type%>" class=moreFoot onclick="getMore(this)" style="margin-bottom: 20px;margin-top:10px;width:98%;position: inherit">
  <A hideFocus href="javascript:void(0)">
     <EM class=ico_load></EM>更 多<EM class="more_down"></EM> 
  </A>
</DIV>
<%}else if(!operation.equals("listmore")&&rs.getCounts()==0){%>
   <div style="color:#999999;height: 40px;text-align: center;"><%=SystemEnv.getHtmlLabelName(30645,user.getLanguage())%></div>
<%}%>
