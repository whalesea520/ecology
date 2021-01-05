<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@page import="weaver.crm.customer.CustomerShareUtil"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.cowork.CoworkDiscussVO"%>
<%@page import="weaver.systeminfo.setting.HrmUserSettingComInfo"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.io.*" %>
<%@page import="java.util.*"%>
<%@page import="weaver.hrm.*" %>
<%@ page import="weaver.Constants" %>
<%@page import="weaver.general.Util" %>
<%@ page import="weaver.file.FileUpload" %>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="weaver.cowork.*" %>
<%@page import="weaver.mobile.plugin.ecology.service.HrmResourceService" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="csm" class="weaver.cowork.CoworkShareManager" scope="page" />
<jsp:useBean id="CoworkService" class="weaver.cowork.CoworkService" scope="page" />

<%
request.setCharacterEncoding("UTF-8");
FileUpload fu = new FileUpload(request);
String userid = Util.null2String(fu.getParameter("userid"));
JSONObject json = new JSONObject();
HrmResourceService hrs = new HrmResourceService();
User user = hrs.getUserById(Util.getIntValue(userid));
if(user==null) {
	json.put("status", "0");
	json.put("errMsg", "未登录或登录超时");
	out.print(json.toString());
	return ;
}

int accessorynum = Util.getIntValue(fu.getParameter("accessory_num"),0);
int deleteField_idnum = Util.getIntValue(fu.getParameter("field_idnum"),0);
String operation = Util.fromScreen(fu.getParameter("method"),user.getLanguage());
String id = Util.null2String(fu.getParameter("id"));      //协作id
String did = "";//回复ID                            
String replyType = "";                     //回复类型
String from = "cowork";//用来表示从哪个页面进入的，从协作区进入from="cowork"，从其他地方进入from="other"
String extendField=Util.null2String(fu.getParameter("extendField"));
String parm[] = extendField.split("_");
if(parm.length>2){
	did =  parm[0];
	id = parm[1];
	if("2".equals(parm[2])){
		replyType = "comment";
	}
}
String name = Util.fromScreen(fu.getParameter("name"),user.getLanguage());
BaseBean baseBean = new BaseBean();
String typeid = Util.fromScreen(fu.getParameter("typeid"),user.getLanguage());
int isApply = Util.getIntValue(fu.getParameter("isApply"),0);
String levelvalue = Util.null2String(fu.getParameter("levelvalue"),"0");
String creater = Util.fromScreen(fu.getParameter("creater"),user.getLanguage());
String coworkers = Util.fromScreen(fu.getParameter("coworkers"),user.getLanguage());
String begindate = Util.fromScreen(fu.getParameter("begindate"),user.getLanguage());
String beingtime = Util.fromScreen(fu.getParameter("beingtime"),user.getLanguage());
String enddate = Util.fromScreen(fu.getParameter("enddate"),user.getLanguage());
String endtime = Util.fromScreen(fu.getParameter("endtime"),user.getLanguage());
String relatedprj = Util.fromScreen(fu.getParameter("relatedprj"),user.getLanguage()); //相关项目任务
String relatedcus = Util.fromScreen(fu.getParameter("relatedcus"),user.getLanguage()); //相关客户
relatedcus=CustomerShareUtil.customerRightFilter(""+user.getUID(),relatedcus);
String relatedwf = Util.fromScreen(fu.getParameter("relatedwf"),user.getLanguage());   //相关流程
String relateddoc = Util.fromScreen(fu.getParameter("relateddoc"),user.getLanguage()); //相关文档
if("0".equals(relateddoc)) relateddoc="";
String relatedacc =Util.fromScreen(fu.getParameter("relatedacc"),user.getLanguage());  //相关附件

String projectIDs = Util.null2String(fu.getParameter("projectIDs"));//td11838          //相关项目

String principal = Util.null2String(fu.getParameter("txtPrincipal"));                  //协作负责人



String commentuserid = Util.null2String(fu.getParameter("commentuserid"));             //被评论人id

String topdiscussid = Util.null2String(fu.getParameter("topdiscussid"));               //被评论的留言id

String approvalAtatus = Util.null2String(fu.getParameter("approvalAtatus")); //审批状态 1 为待审批 
String isApproval = "";
String isAnonymous = ""; //是否匿名


String createdate =TimeUtil.getCurrentDateString();     //当前日期
String createtime =TimeUtil.getOnlyCurrentTimeString(); //当前时间

String status ="1";
char flag = 2;
String Proc="";
String userId =""+user.getUID();
boolean isoracle = (RecordSet.getDBType()).equals("oracle");
String disType=Util.null2String((String)session.getAttribute("disType")); //协作讨论显示方式，tree为树形
int floorNum=0;
if(operation.equals("doremark")){ //回复讨论

		try{
			String content=Util.null2String(fu.getParameter("content"));
			
			CoworkDAO dao = new CoworkDAO(Util.getIntValue(id));
			CoworkItemsVO vo = dao.getCoworkItemsVO();
			String cname = Util.null2String(vo.getName());                 //协作名称
			String ccreater = Util.null2String(vo.getCreater());           //协作创建人
			principal=Util.null2String(vo.getPrincipal());         		   //协作负责人
			String ctypeid=Util.null2String(vo.getTypeid());               //所属协作区
			String cbegindate = Util.null2String(vo.getBegindate());       //开始日期
			String cbeingtime = Util.null2String(vo.getBeingtime());       //开始时间      
			String cenddate = Util.null2String(vo.getEnddate());           //结束日期
			String cendtime = Util.null2String(vo.getEndtime());           //结束时间
			String capprovalAtatus=vo.getApprovalAtatus();                 //审批状态，待审批
			isAnonymous = vo.getIsAnonymous();
			isAnonymous=isAnonymous.equals("")?"0":isAnonymous;
			isApproval = vo.getIsApproval();
			
			CoworkDiscussVO cvo  = dao.getCoworkDiscussVO(did);
			topdiscussid = did;               //被评论的留言id
			commentuserid = cvo.getDiscussant();             //被评论人id
			if(!"".equals(relatedacc)){
		   		csm.addCoworkDocShare(userid,relatedacc,typeid,id,principal); //添加附件共享
			}
	    
		    int replayid= Util.getIntValue(did);
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
			Proc=id+flag+userid+flag+createdate+flag+createtime+flag+content+flag+relatedprj+flag+relatedcus+flag+relatedwf+flag+relateddoc+flag+relatedacc+flag+projectIDs+flag+floorNum+flag+replayid;
			
		    RecordSet.executeProc("cowork_discuss_insert",Proc);
		    
		    RecordSet.executeSql("select max(id) as maxid from cowork_discuss where coworkid="+id+" and discussant="+userid);
			String currentid="0";
			String discussid="0";
			if(RecordSet.next()){
				currentid=RecordSet.getString("maxid");
			}
			ArrayList reminderidList=new ArrayList();
			
		    if(replyType.equals("comment")){ //
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
				if(!reminderidList.contains(reminderid)&&!reminderid.equals(userid)){
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
		    if(!reminderidList.contains(principal)&&!principal.equals(userid)){
				reminderidList.add(principal);
			}
		    
			//协作提醒
			CoworkService.addSysRemind(id,userid,reminderidList);
			
			if(replyType.equals("comment")){
				//只清除评论相关人的阅读记录
				for(int i=0;i<reminderidList.size();i++){
					
					CoworkService.delReadByUserid(id,(String)reminderidList.get(i));
				}
			}else{
				//所有看过协作的参与者，都会记录到cowork_read，协作更新后就要删除cowork_read中的已经查看者
				CoworkService.delRead(id);
				//将当前回复者添加到已读者中
				CoworkService.addRead(id,userid);
			}
			json.put("status", "1");
		}catch(Exception ex){
			ex.printStackTrace();
			json.put("status", "0");
			String errMsg = Util.null2String(ex.getMessage());
			errMsg = URLEncoder.encode(errMsg, "UTF-8");
			errMsg = errMsg.replaceAll("\\+","%20");
			json.put("errMsg", errMsg);
		}
		out.print(json.toString());
}else if(operation.equals("subcontent")){
 //回复
		try{
			String content=Util.null2String(fu.getParameter("content"));
			
			if(!"".equals(relatedacc)){
		   		csm.addCoworkDocShare(userid,relatedacc,typeid,id,principal); //添加附件共享
			}
	    
		    int replayid= Util.getIntValue(did);
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
			Proc=id+flag+userid+flag+createdate+flag+createtime+flag+content+flag+relatedprj+flag+relatedcus+flag+relatedwf+flag+relateddoc+flag+relatedacc+flag+projectIDs+flag+floorNum+flag+replayid;
			
		    RecordSet.executeProc("cowork_discuss_insert",Proc);
		    
		    RecordSet.executeSql("select max(id) as maxid from cowork_discuss where coworkid="+id+" and discussant="+userid);
			String currentid="0";
			String discussid="0";
			if(RecordSet.next()){
				currentid=RecordSet.getString("maxid");
			}
			ArrayList reminderidList=new ArrayList();
			
		    if(replyType.equals("comment")){ //
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
				if(!reminderidList.contains(reminderid)&&!reminderid.equals(userid)){
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
		    if(!reminderidList.contains(principal)&&!principal.equals(userid)){
				reminderidList.add(principal);
			}
		    
			//协作提醒
			CoworkService.addSysRemind(id,userid,reminderidList);
			
			if(replyType.equals("comment")){
				//只清除评论相关人的阅读记录
				for(int i=0;i<reminderidList.size();i++){
					
					CoworkService.delReadByUserid(id,(String)reminderidList.get(i));
				}
			}else{
				//所有看过协作的参与者，都会记录到cowork_read，协作更新后就要删除cowork_read中的已经查看者
				CoworkService.delRead(id);
				//将当前回复者添加到已读者中
				CoworkService.addRead(id,userid);
			}
			json.put("status", "1");
		}catch(Exception ex){
			ex.printStackTrace();
			json.put("status", "0");
			String errMsg = Util.null2String(ex.getMessage());
			errMsg = URLEncoder.encode(errMsg, "UTF-8");
			errMsg = errMsg.replaceAll("\\+","%20");
			json.put("errMsg", errMsg);
		}
		out.print(json.toString());
}
%>