
<%@page import="weaver.crm.customer.CustomerShareUtil"%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.cowork.CoworkDiscussVO"%>
<%@page import="weaver.systeminfo.setting.HrmUserSettingComInfo"%>
<%@page import="weaver.systeminfo.setting.HrmUserSettingHandler" %>
<%@page import="weaver.systeminfo.setting.HrmUserSetting" %>
<%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.general.TimeUtil"%>
<%@page import="weaver.cowork.CoworkShareManager"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.Constants" %>
<%@ page import="weaver.domain.workplan.WorkPlan" %>
<%@ page import="weaver.WorkPlan.WorkPlanHandler" %>
<%@ page import="weaver.WorkPlan.WorkPlanLogMan" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.cowork.CoworkDAO" %>
<jsp:useBean id="cs" class="weaver.conn.ConnStatement" scope="page" />

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetTrans" class="weaver.conn.RecordSetTrans" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CoworkDao" class="weaver.cowork.CoworkDAO" scope="page"/>
<jsp:useBean id="workPlanService" class="weaver.WorkPlan.WorkPlanService" scope="page"/>
<jsp:useBean id="CoTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page" />
<jsp:useBean id="csm" class="weaver.cowork.CoworkShareManager" scope="page" />
<jsp:useBean id="CoworkService" class="weaver.cowork.CoworkService" scope="page" />
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page" />

<%
request.setCharacterEncoding("UTF-8");
FileUpload fu = new FileUpload(request);

int accessorynum = Util.getIntValue(fu.getParameter("accessory_num"),0);
int deleteField_idnum = Util.getIntValue(fu.getParameter("field_idnum"),0);
String operation = Util.fromScreen(fu.getParameter("method"),user.getLanguage());
String id = Util.null2String(fu.getParameter("id"));                                  //协作id
String from = Util.null2String(fu.getParameter("from"));//用来表示从哪个页面进入的，从协作区进入from="cowork"，从其他地方进入from="other"

String name = Util.fromScreen(fu.getParameter("name"),user.getLanguage());
BaseBean baseBean = new BaseBean();
String typeid = Util.fromScreen(fu.getParameter("typeid"),user.getLanguage());
int isApply = Util.getIntValue(fu.getParameter("isApply"),0);
String levelvalue = Util.null2s(fu.getParameter("levelvalue"),"0");
String creater = Util.fromScreen(fu.getParameter("creater"),user.getLanguage());
String coworkers = Util.fromScreen(fu.getParameter("coworkers"),user.getLanguage());
String begindate = Util.fromScreen(fu.getParameter("begindate"),user.getLanguage());
String beingtime = Util.fromScreen(fu.getParameter("beingtime"),user.getLanguage());
String enddate = Util.fromScreen(fu.getParameter("enddate"),user.getLanguage());
String endtime = Util.fromScreen(fu.getParameter("endtime"),user.getLanguage());
String relatedprj = Util.fromScreen(fu.getParameter("relatedprj"),user.getLanguage()); //相关项目任务
if("".equals(relatedprj)){
	relatedprj = Util.fromScreen(fu.getParameter("prjid"),user.getLanguage());
}
String relatedcus = Util.fromScreen(fu.getParameter("relatedcus"),user.getLanguage()); //相关客户
relatedcus=CustomerShareUtil.customerRightFilter(""+user.getUID(),relatedcus);
String relatedwf = Util.fromScreen(fu.getParameter("relatedwf"),user.getLanguage());   //相关流程
String relateddoc = Util.fromScreen(fu.getParameter("relateddoc"),user.getLanguage()); //相关文档
if("0".equals(relateddoc)) relateddoc="";
String relatedacc =Util.fromScreen(fu.getParameter("relatedacc"),user.getLanguage());  //相关附件

String remark = Util.null2String(fu.getParameter("remark"));                           //评论

String projectIDs = Util.null2String(fu.getParameter("projectIDs"));//td11838          //相关项目

String principal = Util.null2String(fu.getParameter("txtPrincipal"));                  //协作负责人

String replyType = Util.null2String(fu.getParameter("replyType"));                     //回复类型

String commentuserid = Util.null2String(fu.getParameter("commentuserid"));             //被评论人id

String topdiscussid = Util.null2String(fu.getParameter("topdiscussid"));               //被评论的留言id

String approvalAtatus = Util.null2String(fu.getParameter("approvalAtatus")); //审批状态 1 为待审批 
String isApproval = Util.null2String(fu.getParameter("isApproval"));
String isAnonymous = Util.null2String(fu.getParameter("isAnonymous")); //是否匿名
isAnonymous=isAnonymous.equals("")?"0":isAnonymous;
String isDelAll = Util.null2String(fu.getParameter("isDelAll")); //是否删除交流的评论

String createdate =TimeUtil.getCurrentDateString();     //当前日期
String createtime =TimeUtil.getOnlyCurrentTimeString(); //当前时间
String status ="1";
char flag = 2;
String Proc="";
String userId =""+user.getUID();
boolean isoracle = (RecordSet.getDBType()).equals("oracle");
String disType=Util.null2String((String)session.getAttribute("disType")); //协作讨论显示方式，tree为树形
int floorNum=0;

if(operation.equals("add")){ //添加协作
	
	if(name.equals("")  || begindate.equals("")  || enddate.equals("") ){
		response.sendRedirect("/cowork/AddCoWork.jsp");
		return;
	}
	String tempdocids = "";
	ArrayList docids = new ArrayList();
	docids = Util.TokenizerString(relateddoc,",");
	for(int i=0;i<docids.size();i++){
		tempdocids =tempdocids+docids.get(i).toString()+"|"+userId+",";
	}
	//添加事务控制，创建异常回滚数据
    RecordSetTrans rst=new RecordSetTrans();
	rst.setAutoCommit(false);
	try{
		 Proc=name+flag+typeid+flag+levelvalue+flag+creater+flag+principal+flag+
	          createdate+flag+createtime+flag+begindate+flag+beingtime+flag+enddate+flag+
	          endtime+flag+relatedprj+flag+relatedcus+flag+relatedwf+flag+tempdocids+flag+
	          remark+flag+status+flag+relatedacc+flag+projectIDs+flag+creater;
		 rst.executeProc("cowork_items_insert",Proc);
		
		//获取当前协作id
		 while(rst.next()){
		     id = rst.getString(1);
		     rst.execute("update cowork_items set isApply = "+isApply+" where id = "+id);
		 }
		 rst.commit();
	}catch(Exception e){
		rst.rollback();
		e.printStackTrace();
	}
	//判断协作是否创建成功不为空表示创建成功
	if(!id.equals("")){
	
		//添加协作参与人共享表	     
	    csm.addShare(id,creater,principal,fu);
		
	    //附件共享
	    //if(!"".equals(relatedacc)){
	    //   csm.addCoworkDocShare(userId,relatedacc,typeid,id,principal);
	    //}
		
		//将创建者添加到已读
		CoworkService.addRead(id,userId);
		
		//协作创建日志
		CoworkDao.addCoworkLog(Util.getIntValue(id),1,Util.getIntValue(userId),fu);
		
		RecordSet.execute("update cowork_items set lastupdatedate='"+createdate+"',lastupdatetime='"+createtime+"',isApproval="+isApproval+",isAnonymous="+isAnonymous+",approvalAtatus="+isApproval+",istop=0,readNum=0,replyNum=0 where id="+id);
		
		//协作提醒
		List parterList=csm.getShareList("parter",id);
		
		if(approvalAtatus.equals("1")){
			CoworkService.addSysRemind(id,userId,parterList);
		}
		
		if("cowork".equals(from)){
			out.print("<script>parent.getParentWindow(window).addCoworkCallback("+id+");</script>");
		}else{
			out.print("<script>parent.getDialog(window).close()</script>");
		}
  }else
	response.sendRedirect("/cowork/AddCoWork.jsp?from="+from+"&message=error"); //协作创建失败，返回协作创建页面
}
else if(operation.equals("addtoplan")) //添加日程
//添加到日程安排
{
	ConnStatement statement = new ConnStatement();
	String sqlselect = "SELECT * FROM CoWork_Items WHERE id = " + id;
	try 
	{
		statement.setStatementSql(sqlselect);
		statement.executeQuery();
		if(statement.next())
		{
			name = statement.getString("name");
			typeid = statement.getString("typeid");
			levelvalue = statement.getString("levelvalue");
			creater = statement.getString("creater");
			
			begindate = statement.getString("begindate");
			beingtime = statement.getString("beingtime");
			enddate = statement.getString("enddate");
			endtime = statement.getString("endtime");
			relatedprj = statement.getString("relatedprj");
			relatedcus = statement.getString("relatedcus");
			relatedwf = statement.getString("relatedwf");
			relateddoc = statement.getString("relateddoc");
			remark = statement.getString("remark");
		}
	}
	finally
	{
		statement.close();
	}
	
    WorkPlanHandler workPlanHandler = new WorkPlanHandler();
    WorkPlanLogMan logMan = new WorkPlanLogMan();
    
    String[] logParams;
    WorkPlan workPlan = new WorkPlan();

    workPlan.setCreaterId(user.getUID());
    workPlan.setCreateType(Integer.parseInt(user.getLogintype()));

    workPlan.setWorkPlanType(Integer.parseInt(Constants.WorkPlan_Type_Plan));        
    workPlan.setWorkPlanName(name);    
    workPlan.setUrgentLevel(Constants.WorkPlan_Urgent_Normal);
    workPlan.setRemindType(Constants.WorkPlan_Remind_No);  
    
    //协作参与人
    List parterList=csm.getShareList("parter",id);
    
    String resourceids="";
    for(int i=0;i<parterList.size();i++){
        resourceids=resourceids+(String)parterList.get(i)+",";
    }
    workPlan.setResourceId(resourceids);
    workPlan.setBeginDate(begindate);

    if(null != beingtime && !"".equals(beingtime.trim()))
    {
        workPlan.setBeginTime(beingtime);  //开始时间
    }
    else
    {
        workPlan.setBeginTime(Constants.WorkPlan_StartTime);  //开始时间
    }	    
    workPlan.setEndDate(enddate);
    if(null != enddate && !"".equals(enddate.trim()) && (null == endtime || "".equals(endtime.trim())))
    {
        workPlan.setEndTime(Constants.WorkPlan_EndTime);  //结束时间
    }
    else
    {
        workPlan.setEndTime(endtime);  //结束时间
    }
    
    String workPlanDescription = Util.null2String(remark);
    workPlanDescription = Util.replace(workPlanDescription, "\n", "", 0);
    workPlanDescription = Util.replace(workPlanDescription, "\r", "", 0);
    workPlan.setDescription(workPlanDescription);
    
    workPlan.setCustomer(relatedcus);
    String docIds ="";
    ArrayList relatedDocs = Util.TokenizerString(relateddoc, ",");
    for(int i=0;i<relatedDocs.size();i++)
    {
        String tempDocId = (String)relatedDocs.get(i);
        int flagIndex = tempDocId.indexOf("|");
        if(flagIndex!=-1)
        {
            if(i!=relatedDocs.size())
            {
                docIds+=tempDocId.substring(0,flagIndex)+",";
            }
            else
            {
                docIds+=tempDocId.substring(0,flagIndex);
            }
        }
        else
        {
            if(i!=relatedDocs.size())
            {
                docIds+=tempDocId+",";
            }
            else
            {
                docIds+=tempDocId;
            }
        }
    }
    workPlan.setDocument(docIds);
    workPlan.setProject(CoworkDao.getAllProjsByTaskIds(relatedprj));
    workPlan.setWorkflow(relatedwf);
    workPlan.setTask(relatedprj);

    workPlanService.insertWorkPlan(workPlan);  //插入日程

	logParams = new String[] {String.valueOf(workPlan.getWorkPlanID()), WorkPlanLogMan.TP_CREATE, ""+userId, request.getRemoteAddr()};
	logMan.writeViewLog(logParams);

	//response.sendRedirect("/cowork/ViewCoWork.jsp?needfresh=2&id=" + id);
}
else if(operation.equals("edit")){ //编辑协作
	String oldcoworkers = ","+Util.fromScreen(fu.getParameter("oldcoworkers"),user.getLanguage())+",";
	if(name.equals("") ||begindate.equals("")  || enddate.equals("") ){
		response.sendRedirect("/cowork/EditCoWork.jsp?id="+id);
		return;
	}
	String tempdocids = "";
	ArrayList docids = new ArrayList();
	docids = Util.TokenizerString(relateddoc,",");//多个doc
	for(int i=0;i<docids.size();i++){
		tempdocids =tempdocids+docids.get(i).toString()+"|"+userId+",";
	}
   
   String delrelatedacc =Util.fromScreen(fu.getParameter("delrelatedacc"),user.getLanguage());  //删除相关附件id
   
   String newrelatedacc =Util.fromScreen(fu.getParameter("newrelatedacc"),user.getLanguage());  //新添加相关附件id
   
   String isChangeCoworker =Util.fromScreen(fu.getParameter("isChangeCoworker"),user.getLanguage());  //是否改变了协作参与者
   
   relatedacc=relatedacc+newrelatedacc;//新附件id
   
   if(isChangeCoworker.equals("1")){
	   //csm.deleteShare(id); //删除原有参与条件
	   csm.addShare(id,creater,principal,fu);//添加的新的参与条件
       //如果退出协作者再次加入协作，删除退出人的退出记录
       csm.deleteCowrkQuiters(fu);
	   CoworkDAO dao = new CoworkDAO(Integer.parseInt(id));
	   ArrayList accList=dao.getRelatedAccs();//获得该协作的所有附件id
	   String accStr=accList.toString();
	   accStr=accStr.substring(1,accStr.length()-1);
	   accStr=accStr+","+newrelatedacc;
	   //csm.addCoworkDocShare(userId,accStr,typeid,id,principal);//添加新的附件权限
   }else{
	  // if(!"".equals(relatedacc))
       //   csm.addCoworkDocShare(userId,relatedacc,typeid,id,principal);
   }
  
   //删除相关附件
   if(!"".equals(delrelatedacc)) 
      RecordSet.executeSql("delete DocDetail where id in ("+delrelatedacc.substring(0,delrelatedacc.length()-1)+")" );
   
   Proc=id+flag+name+flag+typeid+flag+levelvalue+flag+principal+flag+
        projectIDs+flag+begindate+flag+beingtime+flag+enddate+flag+endtime+flag+
        relatedprj+flag+relatedcus+flag+relatedwf+flag+tempdocids+flag+remark+flag+
        relatedacc;
   RecordSet.executeProc("cowork_items_update",Proc);     
   RecordSet.execute("update cowork_items set isApply="+isApply+",lastupdatedate='"+createdate+"',lastupdatetime='"+createtime+"',isApproval="+isApproval+",isAnonymous="+isAnonymous+",approvalAtatus="+isApproval+" where id="+id);
   
	//将当前操作者者添加到已读者中
	CoworkService.addRead(id,userId);
	
	//协作编辑日志
	CoworkDao.addCoworkLog(Util.getIntValue(id),3,Util.getIntValue(userId),fu);
    
	//更新当前协作区所属协作负责人缓存
    CoworkShareManager shareManager=new CoworkShareManager();
    shareManager.deleteCache("typemanager",id); //删除协作缓存
	
	//response.sendRedirect("/cowork/ViewCoWork.jsp?from="+from+"&needfresh=1&id="+id);
	out.print("<script>parent.getParentWindow(window).editCoworkCallback();</script>");
}else if(operation.equals("doremark")){ //回复讨论
	
	//if(!"".equals(relatedacc)){
	//   csm.addCoworkDocShare(userId,relatedacc,typeid,id,principal); //添加附件共享
	//}
    
    int replayid=Util.getIntValue(fu.getParameter("replayid"),0);
    int commentid=replayid;
    String sql="";
    if(!replyType.equals("comment")){ //引用产生新的楼层
	    //获取当前最大楼数
	    sql="select max(floorNum) as floorNum  from cowork_discuss where coworkid="+id;
	    RecordSet.execute(sql);
	    if(RecordSet.next())
	    	floorNum=RecordSet.getInt("floorNum");
	    if(floorNum==-1)
			floorNum=0;
	    floorNum=floorNum+1;
    }else
    	replayid=0;
	
    //添加讨论
	Proc=id+flag+userId+flag+createdate+flag+createtime+flag+remark+flag+relatedprj+flag+relatedcus+flag+relatedwf+flag+relateddoc+flag+relatedacc+flag+projectIDs+flag+floorNum+flag+replayid;
	
    RecordSet.executeProc("cowork_discuss_insert",Proc);
    
    RecordSet.executeSql("select max(id) as maxid from cowork_discuss where coworkid="+id+" and discussant="+userId);
	String currentid="0";
	String discussid="0";
	if(RecordSet.next()){
		currentid=RecordSet.getString("maxid");
	}
	
	RecordSet.executeSql("update cowork_discuss set TOPDISCUSSID=0,COMMENTID=0,COMMENTUSERID=0,ISTOP=0,APPROVALATATUS=0,ISANONYMOUS=0,ISDEL=0 where id="+currentid);
	
	ArrayList reminderidList=new ArrayList();
	
    if(replyType.equals("comment")){ //
		if(isAnonymous.equals("1")&&!commentuserid.equals("0")){
    		commentuserid="-1";
    	}
    	RecordSet.executeSql("update cowork_discuss set commentid="+commentid+",topdiscussid="+topdiscussid+",commentuserid="+commentuserid+" where id="+currentid);
    	
    	sql="select discussant from cowork_discuss where topdiscussid="+topdiscussid+" or id="+topdiscussid;
    }else{
    	//引用、评论时计算回复数
    	RecordSet.executeSql("update cowork_items set replyNum=replyNum+1,lastupdatedate='"+createdate+"',lastupdatetime='"+createtime+"',lastdiscussant="+(isAnonymous.equals("1")?"0":userId)+" where id="+id);
    	
    	sql="select discussant from cowork_discuss where id="+replayid;
    }
    
    RecordSet.execute(sql);
    //提醒评论相关人
    while(RecordSet.next()){
		String reminderid=RecordSet.getString("discussant");
		if(!reminderidList.contains(reminderid)&&!reminderid.equals(userId)){
			reminderidList.add(reminderid);
		}
	}
    
    for(int i=0;i<reminderidList.size();i++){
    	discussid=replyType.equals("comment")?topdiscussid:currentid;
    	sql="select id from cowork_remind where reminderid="+reminderidList.get(i)+" and discussid="+discussid;
    	RecordSet.execute(sql);
    	if(RecordSet.next()){
    		sql="update cowork_remind set createdate='"+createdate+"',createtime='"+createtime+"' where reminderid="+reminderidList.get(i)+" and discussid="+discussid;
    	}else{
	    	sql="insert into cowork_remind(reminderid,discussid,coworkid,createdate,createtime) values"+
	    		"("+reminderidList.get(i)+","+discussid+","+id+",'"+createdate+"','"+createtime+"')";
    	}	
    	RecordSet.execute(sql);
    }
    
    RecordSet.executeSql("update cowork_discuss set approvalAtatus="+isApproval+",isAnonymous="+isAnonymous+" where id="+currentid);
	
  	//提醒协作负责人
    if(!reminderidList.contains(principal)&&!principal.equals(userId)){
		reminderidList.add(principal);
	}
    
	//协作提醒
	CoworkService.addSysRemind(id,userId,reminderidList);
	
	if(replyType.equals("comment")){
		//只清除评论相关人的阅读记录
		for(int i=0;i<reminderidList.size();i++){
			
			CoworkService.delReadByUserid(id,(String)reminderidList.get(i));
		}
	}else{
		//所有看过协作的参与者，都会记录到cowork_read，协作更新后就要删除cowork_read中的已经查看者
		CoworkService.delRead(id);
		//将当前回复者添加到已读者中
		CoworkService.addRead(id,userId);
	}
	out.println(currentid);
	
}else if(operation.equals("end")){ //关闭协作
	
    //获取当前最大楼数
    String sql="select max(floorNum) as floorNum  from cowork_discuss where coworkid="+id;
    RecordSet.execute(sql);
    if(RecordSet.next())
    	floorNum=RecordSet.getInt("floorNum");
    if(floorNum==-1)
		floorNum=0;
    floorNum=floorNum+1;

 	remark = SystemEnv.getHtmlLabelName(19076,user.getLanguage());
 	Proc=id+flag+userId+flag+createdate+flag+createtime+flag+remark+flag+""+flag+""+flag+""+flag+""+flag+""+flag+""+flag+floorNum+flag+"0";
	RecordSet.executeProc("cowork_discuss_insert",Proc);
	
	String sqlupdate = " update cowork_items set status=2 where id = "+id;

	RecordSet.executeSql(sqlupdate);
	
	response.sendRedirect("/cowork/ViewCoWork.jsp?from="+from+"&needfresh=1&id="+id);
}else if(operation.equals("open")){ //打开协作

    //获取当前最大楼数
    String sql="select max(floorNum) as floorNum  from cowork_discuss where coworkid="+id;
    RecordSet.execute(sql);
    if(RecordSet.next())
    	floorNum=RecordSet.getInt("floorNum");
    if(floorNum==-1)
		floorNum=0;
    floorNum=floorNum+1;
	
 	remark = SystemEnv.getHtmlLabelName(19077,user.getLanguage());
 	Proc=id+flag+userId+flag+createdate+flag+createtime+flag+remark+flag+""+flag+""+flag+""+flag+""+flag+""+flag+""+flag+floorNum+flag+"0";
 	RecordSet.executeProc("cowork_discuss_insert",Proc);

	String sqlupdate = " update cowork_items set status=1 where id = "+id;
	RecordSet.executeSql(sqlupdate);
	
	response.sendRedirect("/cowork/ViewCoWork.jsp?from="+from+"&needfresh=1&id="+id);
}else if(operation.equals("editdiscuss")){   //编辑评论
	String discussid=fu.getParameter("discussid"); //讨论记录id
	
	SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	Date nowdate=new Date();
	boolean result=true;
	long timePass=100L;
	
	CoworkDiscussVO vo2=(CoworkDiscussVO)CoworkDao.getCoworkDiscussVO(discussid);
	String coworkid=vo2.getCoworkid();
	String discussant = Util.null2String(vo2.getDiscussant());
	
	createdate = Util.null2String(vo2.getCreatedate());
	createtime = Util.null2String(vo2.getCreatetime());
	
	String maxdiscussid=CoworkDao.getMaxDiscussid(""+coworkid);//最大讨论记录id
	
	String dateStr="";
	if(createtime.length()==5)
		dateStr=createdate+" "+createtime+":00";
	else
		dateStr=createdate+" "+createtime;
	Date discussDate=dateFormat.parse(dateStr);  //回复时间
	timePass=(nowdate.getTime()-discussDate.getTime())/(60*1000);
	 //获取协作基础配置信息(删除交流内容时间)
    RecordSet1.execute("select dealchangeminute from cowork_base_set");
    int basedeletetime;//设置时间//0-表示提交后不能再修改；空-表示提交后一直可修改
    if(RecordSet1.next()){
        basedeletetime=RecordSet1.getInt("dealchangeminute");
    }else{
        basedeletetime=10;
    }
    if(basedeletetime==0){
        out.println("3");
        result=false;
   }else if(basedeletetime==-1){
        if(!maxdiscussid.equals(discussid)){
		out.println("1");
	    result=false;
       }
	}else if(timePass>basedeletetime){
		out.println("2");
	    result=false;
	}
    if(result){
	String edit_relatedprj = Util.fromScreen(fu.getParameter("edit_relatedprj"),user.getLanguage());  //相关项目任务
	String edit_relatedcus = Util.fromScreen(fu.getParameter("edit_relatedcus"),user.getLanguage());  //相关客户
	edit_relatedcus=CustomerShareUtil.customerRightFilter(""+user.getUID(),edit_relatedcus);
	String edit_relatedwf = Util.fromScreen(fu.getParameter("edit_relatedwf"),user.getLanguage());    //相关流程
	String edit_relateddoc = Util.fromScreen(fu.getParameter("edit_relateddoc"),user.getLanguage());  //相关文档
	if(edit_relateddoc.equals("0")) relateddoc="";
	
	//String edit_remark = Util.null2String(fu.getParameter("edit_remark"));                            //评论   
	String edit_remark = Util.null2String(fu.getParameter("remark"));

	String edit_projectIDs = Util.null2String(fu.getParameter("edit_projectIDs"));                    //相关任务
	
    String edit_relatedacc=Util.null2String(fu.getParameter("edit_relatedacc"));                      //相关附件
    
	String delrelatedacc=Util.null2String(fu.getParameter("delrelatedacc"));                          //需要删除的相关附件  
	
	String newrelatedacc=Util.null2String(fu.getParameter("newrelatedacc"));                          //新上传的相关附件
	
	//删除需要删除的附件
	if(!delrelatedacc.equals("")){
		delrelatedacc = delrelatedacc.substring(0,delrelatedacc.length()-1);
		RecordSet.executeSql("delete DocDetail where id in(" + delrelatedacc+")");
	}
	
	
	//新添加附件共享
   // if(!"".equals(newrelatedacc)){
   //    csm.addCoworkDocShare(userId,newrelatedacc,typeid,id,principal);
   // }
    //新附件id
    edit_relatedacc=edit_relatedacc+newrelatedacc;
	
	String sql="update cowork_discuss set createdate=?, createtime=?,remark=?"+
			    ",relatedprj=?,relatedcus=?,relatedwf=?"+
			    ",relateddoc=?,ralatedaccessory=?,mutil_prjs=?,approvalAtatus=? where id=?";
	cs.setStatementSql(sql);
	cs.setString(1,createdate);
	cs.setString(2,createtime);
	cs.setString(3,edit_remark);
	cs.setString(4,edit_relatedprj);
	cs.setString(5,edit_relatedcus);
	cs.setString(6,edit_relatedwf);
	cs.setString(7,edit_relateddoc);
	cs.setString(8,edit_relatedacc);
	cs.setString(9,edit_projectIDs);
	cs.setString(10,isApproval);
	cs.setString(11,discussid);
	
	cs.executeUpdate();
	cs.close();
		
	//所有看过协作的参与者，都会记录到cowork_read，协作更新后就要删除cowork_read中的意境查看者
	RecordSet.executeSql("delete from cowork_read where coworkid="+id);
	
	//将当前操作者者添加到已读者中
	RecordSet.executeSql("insert into cowork_read(coworkid,userid) values("+id+","+userId+")");
    }
}else if(operation.equals("delete")){  //删除讨论记录
	
	String discussid=Util.fromScreen(fu.getParameter("discussid"),user.getLanguage());
	
	CoworkDAO dao=new CoworkDAO();
    CoworkDiscussVO vo2=(CoworkDiscussVO)dao.getCoworkDiscussVO(discussid);
	String coworkid=vo2.getCoworkid();
	String discussant = Util.null2String(vo2.getDiscussant());
		
	createdate = Util.null2String(vo2.getCreatedate());
	createtime = Util.null2String(vo2.getCreatetime());
		
	String maxdiscussid=dao.getMaxDiscussid(""+coworkid);//最大讨论记录id
        
	Date nowdate=new Date();
	SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	boolean result=true;
	long timePass=100L;
		
	String dateStr="";
	if(createtime.length()==5)
		dateStr=createdate+" "+createtime+":00";
	else
		dateStr=createdate+" "+createtime;
	Date discussDate=dateFormat.parse(dateStr);  //回复时间
	timePass=(nowdate.getTime()-discussDate.getTime())/(60*1000);
    
	//获取协作基础配置信息(删除交流内容时间)Start
    
    RecordSet1.execute("select * from cowork_base_set");
    int basedeletetime;//设置时间//0-表示提交后不能再修改；空-表示提交后一直可修改
    if(RecordSet1.next()){
        basedeletetime=RecordSet1.getInt("dealchangeminute");
    }else{
        basedeletetime=10;
    }
	
	boolean isCanEdit=csm.isCanEdit(""+id,""+userId,"all"); //权限判断
	
	if(isCanEdit){
		result=true;
	}else{
		if(!discussant.equals(userId)){
			result=false;
		}
		if(!maxdiscussid.equals(discussid)){
			out.println("1");
			result=false;
	    }else if(basedeletetime==0){
			out.println("3");
			result=false;
		}else if(basedeletetime==-1){
		    result=true;
        }else if(timePass>basedeletetime){
            out.println("2");
			result=false;
        }
	}
	if(result){
		//删除附件
		String delrelatedaccString = "select ralatedaccessory from cowork_discuss where id="+discussid;
		RecordSet.execute(delrelatedaccString);
		if(RecordSet.next()){
			String delrelatedacc = Util.null2String(RecordSet.getString("ralatedaccessory"));
			if(!"".equals(delrelatedacc)){
				delrelatedacc = delrelatedacc.substring(0,delrelatedacc.length()-1);
				RecordSet.executeSql("delete DocDetail where id in(" + delrelatedacc+")");
			}
		}
		
       String sql="delete from cowork_discuss where id="+discussid;
	   RecordSet.execute(sql);
	   
	   //引用、评论时计算回复数
   	   RecordSet.executeSql("update cowork_items set replyNum=replyNum-1 where id="+id);
	   out.println("0");
    }
}else if(operation.equals("showHead")){
	String isCoworkHead=fu.getParameter("isCoworkHead");
	HrmUserSettingComInfo settingComInfo=new HrmUserSettingComInfo();
	String hrmSettingid=settingComInfo.getId(userId);
	HrmUserSettingHandler handler = new HrmUserSettingHandler();
	HrmUserSetting setting = handler.getSetting(user.getUID());
	boolean rtxload = setting.isRtxOnload();
	String isload = "0";
	if(rtxload){
		isload = "1";
	}
	if(hrmSettingid.equals("")){
		RecordSet.execute("insert into HrmUserSetting(resourceid,rtxOnload,isCoworkHead,skin,cutoverWay,transitionTime,transitionWay) values("+userId+","+isload+",1,'','','','')");
		settingComInfo.removeHrmUserSettingComInfoCache();
		settingComInfo=new HrmUserSettingComInfo();
		hrmSettingid =settingComInfo.getId(userId);
	}
	RecordSet.execute("update HrmUserSetting set isCoworkHead="+isCoworkHead+" where id="+hrmSettingid);
	settingComInfo.removeHrmUserSettingComInfoCache();
}else if(operation.equals("dotop")){ //顶置
	boolean isCanEdit=csm.isCanEdit(""+id,""+userId,"all"); //权限判断
	if(isCanEdit){
		String discussid=Util.null2String(fu.getParameter("discussid"));
		RecordSet.execute("update cowork_discuss set istop=1 where id="+discussid);
	}
}else if(operation.equals("canceltop")){ //取消顶置
	boolean isCanEdit=csm.isCanEdit(""+id,""+userId,"all"); //权限判断
	if(isCanEdit){
		String discussid=Util.null2String(fu.getParameter("discussid"));
		RecordSet.execute("update cowork_discuss set istop=0 where id="+discussid);
	}
}else if(operation.equals("getTypeSet")){
	isApproval=CoTypeComInfo.getIsApprovals(typeid);
	isAnonymous=CoTypeComInfo.getIsAnonymouss(typeid);
	out.println("{isApproval:"+isApproval+",isAnonymous:"+isAnonymous+"}");
}else if(operation.equals("doApprove")){ //审批协作
	List parterList=csm.getShareList("parter",id);
	CoworkService.addSysRemind(id,userId,parterList);
	RecordSet.execute("update cowork_items set approvalAtatus=0 where id in("+id+")");
}else if(operation.equals("doApproveDiscuss")){ //审批协作留言
	String discussid=fu.getParameter("discussid"); //讨论记录id
	RecordSet.execute("update cowork_discuss set approvalAtatus=0 where id in("+discussid+")");
}

else if(operation.equals("logicDel")){ //删除协作留言
    String discussid=Util.TrimComma(Util.fromScreen(fu.getParameter("discussid"),user.getLanguage())); //讨论记录id
    String delUserId = userId;
    String delTime=  TimeUtil.getCurrentTimeString();
    String sql="";
    String delRemark= "";
    /*权限判断暂时取消
    //删除权限判断
    boolean isCanEdit = true;
    if(!"1".equals(userId)) {
        for(String did : discussid.split(",")) {
            isCanEdit = isCanEdit && csm.isCanEdit(did, userId, "all"); //权限判断
            System.out.println(isCanEdit);
            if(!isCanEdit) {
                return;
            }
        }
    }
    if(isCanEdit) {
        delRemark = "<span style=\"color:blue\">【" + SystemEnv.getHtmlLabelName(83248, user.getLanguage()) + "】</span>";
        String sql="update cowork_discuss set remarkback=remark, delUserId = ?, delTime = ?,remark= ?,isDel=1,approvalAtatus=0 where isDel = 0 and id in("+discussid+")";
    	RecordSet.executeUpdate(sql, delUserId, delTime , remark);
    	out.println("0");
    	return;
    }
    */
    
    delRemark = "<span style=\"color:blue\">【" + SystemEnv.getHtmlLabelName(83248, user.getLanguage()) + "】</span>";
    sql="update cowork_discuss set remarkback=remark, delUserId = '"+delUserId+"', delTime = '"+delTime+"',remark= '"+delRemark+"',isDel=1,approvalAtatus=0 where isDel = 0 and id in ("+discussid+")";
    RecordSet.execute(sql);
    if("true".equals(isDelAll)){
        sql="delete from cowork_discuss where topdiscussid in ("+discussid+")";
        RecordSet.execute(sql);
    }
	out.println("0");
	return;
}

else if(operation.equals("delcowork")){ //删除协作
    // 判断有无菜单权限
    if(!HrmUserVarify.checkUserRight("collaborationtype:edit", user)) {
        return;
    }
    RecordSetTrans rst = new RecordSetTrans();
    rst.setAutoCommit(false);
    try {
    	String coworkids=Util.TrimComma(fu.getParameter("coworkids")); //讨论记录id
    	 //删除主题
    	String sql="delete from cowork_items where id in("+coworkids+")";
    	rst.executeUpdate(sql);
    
        //删除交流
        sql = "delete from cowork_discuss where coworkid in (" + coworkids + ")";
        rst.executeUpdate(sql);
        
        //删除相关收藏
        sql = "delete from cowork_collect where itemid in (" + coworkids + ")";
        rst.executeUpdate(sql);
        
        //log
        logger.error("协作主题删除,userid=" + userId + ",lastname=" + user.getUsername() 
                + ",itemid=" + coworkids + ",time=" + TimeUtil.getCurrentTimeString());
        
        rst.commit();
    } catch (Exception e) {
        rst.rollback();
    }
}else if(operation.equals("endCowork")){ //结束协作
	String[] coworkids=Util.null2String(fu.getParameter("coworkids")).split(","); //讨论记录id
	remark = SystemEnv.getHtmlLabelName(19076,user.getLanguage());
	for(int i=0;i<coworkids.length;i++){
		CoworkDao.endCowork(coworkids[i],userId,remark);
	}
}else if(operation.equals("topCowork")){ //顶置协作
	String coworkids=fu.getParameter("coworkids"); //讨论记录id
	String sql="update cowork_items set isTop=1 where id in("+coworkids+")";
	RecordSet.execute(sql);
}else if(operation.equals("updateremind")){ //更新与我相关提醒
	String coworkid=fu.getParameter("coworkid"); //讨论记录id
	CoworkService.updateRelatedUnread(userId,coworkid);
}else if(operation.equals("coworkRemindLink")){//更新门户左下角弹出框中的协作提醒信息
	String ids = Util.null2String(request.getParameter("ids"));
	if(!"".equals(ids)){
		RecordSet rs = new RecordSet();
		ArrayList list =  Util.TokenizerString(ids,",");//coworkids集合
		for(int i=0 ; i<list.size() ; i++){
			CoworkService.addRead(list.get(i)+"",userId);
			//PoppupRemindInfoUtil.deletePoppupRemindInfo(Util.getIntValue(list.get(i).toString()),9);
			rs.executeSql("delete from SysPoppupRemindInfoNew where type=9 and  requestid="+Util.getIntValue(list.get(i).toString())+" and userid="+userId);
		}
	}
}else if(operation.equals("delComment")){//本人删除评论
	String discussid = Util.null2String(request.getParameter("discussid"));
	CoworkService.delComment(discussid,userId);
}else if(operation.equals("logicDelComment")){//管理员删除评论
    String discussid = Util.null2String(request.getParameter("discussid"));
    String sql="update cowork_discuss set remarkback =remark,remark='<span style=\"color:blue\">【"+SystemEnv.getHtmlLabelName(83248,user.getLanguage())+"】</span>',isDel=1,approvalAtatus=0 where id in("+discussid+")";
    RecordSet.execute(sql);
}
else if(operation.equals("cancelCollect")){//取消收藏
    String[] coworkids=Util.null2String(fu.getParameter("coworkids")).split(","); //讨论记录id
    for(int i=0;i<coworkids.length;i++){
		CoworkDao.cancelCollect(coworkids[i]);
	}
}
%>