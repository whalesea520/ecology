<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.ParseException"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.*,org.json.*" %>
<%@ page import="weaver.voting.bean.GroupChatVoteResult" %>
<%@ page import="weaver.social.im.SocialIMClient"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobComInfo" class="weaver.hrm.check.JobComInfo" scope="page"/>
<jsp:useBean id="GroupChatVotingManager" class="weaver.voting.groupchartvote.GroupChatVotingManager" scope="page"/>
<jsp:useBean id="GroupChatVotingResultManager" class="weaver.voting.groupchartvote.GroupChatVotingResultManager" scope="page"/>
<jsp:useBean id="GroupChatVotingIdUtil" class="weaver.voting.groupchartvote.GroupChatVotingIdUtil" scope="page"/>
<jsp:useBean id="GroupChatVotingScheduler" class="weaver.voting.groupchartvote.GroupChatVotingScheduler" scope="page"/>
<%	
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	Date curdate=new Date();
	SimpleDateFormat format=new SimpleDateFormat("yyyy-MM-dd HH:mm"); 
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ; 
	String curuserid=user.getUID()+"";
	String method = Util.null2String(request.getParameter("method"));//功能参数:delete:删除投票；vote:投票
	String votingid = Util.null2String(request.getParameter("votingid"));//投票主题id
	String groupid = Util.null2String(request.getParameter("groupid"));//群id
	//String groupowner= Util.null2String(request.getParameter("groupowner"));//群主账号
    String dataFrom = Util.null2String(request.getParameter("dataFrom"));
    String groupowner="";
    JSONObject groupobj=null;
    RecordSet logrs=new RecordSet();
    try {
    	String groupmembers=SocialIMClient.getGroupInfo(groupid);
    	logrs.writeLog("groupmembers=="+groupmembers);
		groupobj = new JSONObject(groupmembers);
		groupowner=groupobj.get("adminUserId")+"";//群主账号
	} catch (JSONException e) {	
	}
	if("delete".equals(method)){//删除投票
		Map<String,String> vote=GroupChatVotingManager.getVotingOnlyById(votingid);		
		GroupChatVotingManager.deleteVotingByGroupidAndVotingid(votingid);
		String voteremind=vote.get("voteremind");
		if(!"4".equals(voteremind)){
			String voteenddateString=vote.get("enddate")+" "+vote.get("endtime");
			Date voteenddate =null;
			String flag="";
			try{
				voteenddate = format.parse(voteenddateString);
				if(voteenddate!=null){
					if("1".equals(voteremind)){//提前30分钟
						flag=voteenddate.getTime()-curdate.getTime()>=30*60*1000?"1":"0";
					}else if("2".equals(voteremind)){//提前12小时
						flag=voteenddate.getTime()-curdate.getTime()>=12*60*60*1000?"1":"0";
					}else if("3".equals(voteremind)){//提前24小时
						flag=voteenddate.getTime()-curdate.getTime()>=24*60*60*1000?"1":"0";
					}
					if("1".equals(flag)){
						GroupChatVotingScheduler.removeJob(votingid);
					}
				}	
			}catch(ParseException e){
				e.printStackTrace();
			}
			
		}
		JSONObject obj = new JSONObject();
	    obj.put("status","1");
	    out.println(obj.toString());  
	}else if("vote".equals(method)){//投票弹出框获取投票信息
		String groupmemberids="";
		if(groupobj!=null ){
			groupmemberids=groupobj.get("membersId")+"";//群成员ids不包含群主账号
		}
		int groupusercount=0;
		if(!"".equals(groupmemberids) && groupmemberids.length()>0){
			groupusercount=groupmemberids.split(",").length+1;
		}
		Map<String,Object> vote=GroupChatVotingManager.getVoteById(votingid,"detail",groupid,curuserid,0);
		String votestatus="";
		String voteendtime=vote.get("enddate")+" "+vote.get("endtime");
 		try {
 			Date date = format.parse(voteendtime);
			votestatus=curdate.getTime()<date.getTime()? "0":"1";
		} catch (ParseException e) {
			e.printStackTrace();
		}
		String votestatusshow="";
		if("1".equals(votestatus)){
			votestatusshow="已结束";
		}else{
			votestatusshow="进行中";
		}
		vote.put("votestatus",votestatus);
		vote.put("voteendtime",voteendtime);
		vote.put("votestatusshow",votestatusshow);
		String choosemodel=vote.get("choosemodel")+"";
		String choosemodelshow="";
		if("0".equals(choosemodel)){
			choosemodelshow="单选";
		}else{
			choosemodelshow="多选";
		}
		vote.put("choosemodelshow",choosemodelshow);
		String votetotalcountshow="已投"+vote.get("votetotalcount")+"票";
		vote.put("votetotalcountshow",votetotalcountshow);
		String endtimelabel="截止时间：";
		vote.put("endtimelabel",endtimelabel);
		String createrid=vote.get("createrid")+"";
		vote.put("creatername", ResourceComInfo.getLastname(createrid));
		//判断当前登录人是否是群主或者发布人，如果是，则标记为1，可删除投票；如果不是，则标记为0，不可删除投票，不显示删除按钮；
		String deletestatus="";
		if(curuserid.equals(groupowner) || curuserid.equals(createrid) ){
			deletestatus="1";
		}else{
			deletestatus="0";
		}
		vote.put("deletestatus",deletestatus);
		String canviewvoteuser="0";//是否可以查看选项投票成员:0,不能查看，1，可以查看；
		if(curuserid.equals(createrid)){
			canviewvoteuser="1";
		}	
		vote.put("canviewvoteuser",canviewvoteuser);
		String voteprivacy=vote.get("voteprivacy")+"";
		String canviewvoteuser2="1";//是否可以查看投票成员:0,不能查看，1，可以查看；
		if("1".equals(voteprivacy)){//隐私，只能发布人能看
			if(!curuserid.equals(createrid)){
				canviewvoteuser2="0";
			}	
		}
		vote.put("canviewvoteuser2",canviewvoteuser2);
		
		int votepersoncount=Util.getIntValue(vote.get("havevotedpersoncount")+"",0);
		int notvotepersoncount=Util.getIntValue(vote.get("havenotvotedpersoncount")+"",0);
		String votelabel="参与投票"+votepersoncount+"人 / 群共"+groupusercount+"人";
		vote.put("votelabel",votelabel);
		String notvotelabel="未投票"+notvotepersoncount+"人";
		vote.put("notvotelabel",notvotelabel);
		JSONObject obj = new JSONObject();
	    obj.put("votedata",vote);
	    out.println(obj.toString()); 
	}else if("voteresult".equals(method)){//保存投票结果
		Map<String,String> vote=GroupChatVotingManager.getVotingOnlyById(votingid);
		JSONObject obj = new JSONObject();
		if(vote.get("votingid")==null){//已经删除
			obj.put("status","-1");
		}else{//存在，判断是否已经结束
			String votestatus="";
			String voteendtime=vote.get("enddate")+" "+vote.get("endtime");
	 		try {
	 			Date date = format.parse(voteendtime);
				votestatus=curdate.getTime()<date.getTime()? "0":"1";
				if("1".equals(votestatus)){//已结束
					obj.put("status","0");
				}else{//进行中，判断是否已经投过票了
					boolean ifhavevoted=GroupChatVotingManager.ifHaveVotedByVotingidAndUserid(votingid,curuserid);
					if(ifhavevoted){//投过票
						obj.put("status","2");
					}else{
						String votooptionradio = Util.null2String(request.getParameter("votooptionradio"));
						String votooptioncheck = Util.null2String(request.getParameter("votooptioncheck"));
						SimpleDateFormat format1=new SimpleDateFormat("yyyy-MM-dd");
						SimpleDateFormat format2=new SimpleDateFormat("HH:mm:ss");
						String votedate=format1.format(curdate);//投票日期
						String votetime = format2.format(curdate);//投票时间	
						if(!"".equals(votooptionradio) && !"undefined".equals(votooptionradio)){
							GroupChatVoteResult groupChatVoteResult =new GroupChatVoteResult();
							int resultid=GroupChatVotingIdUtil.getGroupChatVotingId("SequenceIndex_GroupChatVoteRid","groupchatvoteresult");
							groupChatVoteResult.setId(resultid+"");
							groupChatVoteResult.setVoteoptionid(votooptionradio);
							groupChatVoteResult.setVoteuserid(curuserid);
							groupChatVoteResult.setVotedate(votedate);
							groupChatVoteResult.setVotetime(votetime);
							groupChatVoteResult.setVotingid(votingid);	
							GroupChatVotingResultManager.saveVoteResult(groupChatVoteResult);
						}else if(!"".equals(votooptioncheck) && !"undefined".equals(votooptioncheck)){
							String[] voteoptions= votooptioncheck.split(",");
							if(voteoptions!=null && voteoptions.length>0){
								for(String option :voteoptions){
									GroupChatVoteResult groupChatVoteResult =new GroupChatVoteResult();
									int resultid=GroupChatVotingIdUtil.getGroupChatVotingId("SequenceIndex_GroupChatVoteRid","groupchatvoteresult");
									groupChatVoteResult.setId(resultid+"");
									groupChatVoteResult.setVoteoptionid(option);
									groupChatVoteResult.setVoteuserid(curuserid);
									groupChatVoteResult.setVotedate(votedate);
									groupChatVoteResult.setVotetime(votetime);
									groupChatVoteResult.setVotingid(votingid);
									GroupChatVotingResultManager.saveVoteResult(groupChatVoteResult);
								}
							}
						}
						String votetheme=vote.get("votetheme");
						obj.put("status","1");
						obj.put("voteuserid",curuserid);
						obj.put("votetheme",votetheme);
						obj.put("createrid",vote.get("createrid"));
					}
				}
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
	    out.println(obj.toString());
	}else if("detail".equals(method)){//投票详情
		String groupmemberids="";
		if(groupobj!=null ){
			groupmemberids=groupobj.get("membersId")+"";//群成员ids不包含群主账号
		}
		logrs.writeLog("groupmemberids=="+groupmemberids);
		int groupusercount=0;
		if(!"".equals(groupmemberids) && groupmemberids.length()>0){
			groupusercount=groupmemberids.split(",").length+1;
		}
		int maxNum = Util.getIntValue(request.getParameter("maxNum"),0);//详情页面显示最多成员图像个数
		Map<String,Object> vote=GroupChatVotingManager.getVoteById(votingid,"detail",groupid,curuserid,maxNum);
		String votestatus="";
		String voteendtime="";
		if(vote.get("votingid")!=null){
			voteendtime=vote.get("enddate")+" "+vote.get("endtime");
	 		try {
	 			Date date = format.parse(voteendtime);
				votestatus=curdate.getTime()<date.getTime()? "0":"1";
			} catch (ParseException e) {
			}
		}
		String votestatusshow="";
		if("1".equals(votestatus)){//考虑国际化时,这里需要处理
			votestatusshow="已结束";
		}else{
			votestatusshow="进行中";
		}
		vote.put("votestatus",votestatus);
		vote.put("votestatusshow",votestatusshow);
		vote.put("voteendtime",voteendtime);
		String createrid=vote.get("createrid")+"";
		vote.put("creatername", ResourceComInfo.getLastname(createrid));
		String choosemodel=vote.get("choosemodel")+"";
		String choosemodelshow="";
		if("0".equals(choosemodel)){
			choosemodelshow="单选";
		}else{
			choosemodelshow="多选";
		}
		vote.put("choosemodelshow",choosemodelshow);
		String votetotalcountshow="已投"+vote.get("votetotalcount")+"票";
		vote.put("votetotalcountshow",votetotalcountshow);
		String endtimelabel="截止时间：";
		vote.put("endtimelabel",endtimelabel);
		
		//int groupusercount = Util.getIntValue(request.getParameter("groupusercount"),0);//群成员数量		
		int votepersoncount=Util.getIntValue(vote.get("havevotedpersoncount")+"",0);
		int notvotepersoncount=Util.getIntValue(vote.get("havenotvotedpersoncount")+"",0);
		String votelabel="参与投票"+votepersoncount+"人 / 群共"+groupusercount+"人";
		vote.put("votelabel",votelabel);
		String notvotelabel="未投票"+notvotepersoncount+"人";
		vote.put("notvotelabel",notvotelabel);
		String deletestatus="";
		if(curuserid.equals(groupowner) || curuserid.equals(createrid) ){
			deletestatus="1";
		}else{
			deletestatus="0";
		}
		vote.put("deletestatus",deletestatus);
		String voteprivacy=vote.get("voteprivacy")+"";
		String canviewvoteuser="1";//是否可以查看投票成员:0,不能查看，1，可以查看；
		if("1".equals(voteprivacy)){//隐私，只能发布人能看
			if(!curuserid.equals(createrid)){
				canviewvoteuser="0";
			}	
		}
		vote.put("canviewvoteuser",canviewvoteuser);
		
	    if("mb".equals(dataFrom)){
	        vote.put("enddate",vote.get("enddate"));
	        vote.put("endtime",vote.get("endtime"));
	        vote.put("createrDept",DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(createrid)));
            RecordSet rs = new RecordSet();
            rs.executeSql("select messagerurl,sex from hrmresource where id=" + createrid);
            String messagerurl = "";
            if(rs.next()){
                messagerurl = Util.null2String(rs.getString("messagerurl"));
	            vote.put("createSex",rs.getString("sex"));
            }
            
            if(messagerurl.isEmpty()){
                messagerurl = "/social/icon/" + createrid + "_usericon.jpg";
            }
            vote.put("createrPhoto",messagerurl);
            
            rs.executeSql("select id from groupchatvoteresult where votingid=" + votingid + " and voteuserid=" + user.getUID());
            if(rs.next()){
                vote.put("hasSubmit","1");
            }else{
                vote.put("hasSubmit","0");
            }
            if(curuserid.equals(createrid)){
            	vote.put("ispublisher","1");
            }else{
            	vote.put("ispublisher","0");
            }
            
	    }
	    
	    JSONObject obj = new JSONObject();
        obj.put("votedata",vote);
        
	    
	    out.println(obj.toString()); 
	}else if("groupuser".equals(method)){//投票群成员列表
		String usertype = Util.null2String(request.getParameter("usertype"));
		String lastname = Util.null2String(request.getParameter("lastname"));
		List<Map<String,String>> userList=new ArrayList<Map<String,String>>();
		if("0".equals(usertype)){//投票人员信息
			userList=GroupChatVotingManager.getHaveVotedPersonsByVotingid(votingid,lastname);			
		}else{
			userList=GroupChatVotingManager.getHaveNotVotedPersonsByGroupidAndVotingid(groupid,votingid,lastname);
		}
		if(userList !=null && userList.size()>0){
			for(int i=0;i<userList.size();i++){
				Map<String,String> person=userList.get(i);
				String voteuserid=person.get("voteuserid");
				person.put("key",(i+1)+"");
				person.put("name",person.get("voteusername"));
				person.put("company",SubCompanyComInfo.getSubCompanyname(ResourceComInfo.getSubCompanyID(voteuserid)));
				person.put("department",DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(voteuserid)));
				person.put("position",JobComInfo.getJobName(ResourceComInfo.getJobTitle(voteuserid)));
			}
		}
		JSONObject obj = new JSONObject();
	    obj.put("userList",userList);
	    obj.put("usertype",usertype);
	    out.println(obj.toString());  
	}else if("optiondetail".equals(method)){		
		Map<String,String> vote=GroupChatVotingManager.getVotingOnlyById(votingid);
		String voteprivacy=vote.get("voteprivacy");
		String createrid=vote.get("createrid");
		String optioncanviewvoteuser="1";//能查看
		if("1".equals(voteprivacy) && !curuserid.equals(createrid)){//匿名并且非投票发布人，则不能查看投票成员信息；
			optioncanviewvoteuser="0";
		}
		String optionid = Util.null2String(request.getParameter("optionid"));//投票选项id
		Map<String,String> voteoptiondata=GroupChatVotingManager.getVoteOptionByOptionid(optionid);		
		List<Map<String,String>> optionVotePersons=GroupChatVotingManager.getOptionVotePersonsByOptionid(optionid);
		if("mb".equals(dataFrom)){
			if(optionVotePersons!=null && optionVotePersons.size()>0){
				for(Map<String,String> optionVotePerson:optionVotePersons){
					optionVotePerson.put("company",SubCompanyComInfo.getSubCompanyname(ResourceComInfo.getSubCompanyID(optionVotePerson.get("voteuserid"))));
					optionVotePerson.put("department",DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(optionVotePerson.get("voteuserid"))));
					optionVotePerson.put("position",JobComInfo.getJobName(ResourceComInfo.getJobTitle(optionVotePerson.get("voteuserid"))));	
				}
			}
		}
		voteoptiondata.put("headshowlabel","选项");
		voteoptiondata.put("voteoptionpersonlabel","投此选项的人:"+optionVotePersons.size()+"人");
		voteoptiondata.put("optioncanviewvoteuser",optioncanviewvoteuser);
		JSONObject obj = new JSONObject();
	    obj.put("voteoptiondata",voteoptiondata);
	    obj.put("optionVotePersons",optionVotePersons);
	    out.println(obj.toString());  
	}else if("chatmessage".equals(method)){//群聊天获取投票信息
		String votestatus="";
		Map<String,String> vote=GroupChatVotingManager.getVotingOnlyById(votingid);
		if(vote!=null &&vote.size()>0){
			String voteendtime=vote.get("enddate")+" "+vote.get("endtime");
	 		try {
	 			Date date = format.parse(voteendtime);
				if(curdate.getTime()<date.getTime()){//投票未结束
					//判断是否已经投过票
					boolean havevotedflag=GroupChatVotingManager.ifHaveVotedByVotingidAndUserid(votingid,curuserid);
					if(havevotedflag){
						votestatus="1";//1表示进行中且已经投票（进入详情页面）
					}else{
						votestatus="2";//2表示进行中还未投票（进入投票页面）
					}
				}else{
					votestatus="3";//3表示已结束(提示已结束，并且改变消息中投票状态为已结束,进入详情页面，)
				}
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}else{
			votestatus="0";//0表示已经删除(提示已删除,并且改变消息中投票状态为已删除,不进入任何页面)
		}
		JSONObject obj = new JSONObject();
	    obj.put("votestatus",votestatus);
	    out.println(obj.toString());  
	}else if("timetask".equals(method)){//定时任务
		String endtime = Util.null2String(request.getParameter("endtime"));
		String voteremind = Util.null2String(request.getParameter("voteremind"));
		String votetheme = Util.null2String(request.getParameter("votetheme"));
		GroupChatVotingScheduler.createTimedTask(groupid,votingid,votetheme,endtime,voteremind);
		JSONObject obj = new JSONObject();
	    obj.put("votingid",votingid);
	    obj.put("endtime",endtime);
	    obj.put("voteremind",voteremind);
	    obj.put("votetheme",votetheme);
	    out.println(obj.toString());  
	}
%>