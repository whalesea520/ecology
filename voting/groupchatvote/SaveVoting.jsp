<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.common.StringUtil"%>
<%@ page import="weaver.voting.bean.GroupChatVote" %>
<%@ page import="weaver.voting.bean.GroupChatVoteOption" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="org.json.*" %>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.file.FileUpload"%>
<jsp:useBean id="GroupChatVotingManager" class="weaver.voting.groupchartvote.GroupChatVotingManager" scope="page"/>
<jsp:useBean id="GroupChatVotingIdUtil" class="weaver.voting.groupchartvote.GroupChatVotingIdUtil" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="GroupChatVotingScheduler" class="weaver.voting.groupchartvote.GroupChatVotingScheduler" scope="page"/>
<%	
	Date curdate=new Date();
	SimpleDateFormat format1=new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat format2=new SimpleDateFormat("HH:mm");
	SimpleDateFormat format3=new SimpleDateFormat("HH:mm:ss");
	String dataFrom = Util.null2String(request.getParameter("dataFrom"));//数据来源： mb:mobile;null：PC端
	String votetheme = Util.null2String(request.getParameter("votetheme"));//投票主题
	String themeimageid = Util.null2String(request.getParameter("themeimageid"));//主题图片id 
	String choosemodel = Util.null2String(request.getParameter("choosemodel"));//投票模式
	String maxvoteoption = Util.null2String(request.getParameter("maxvoteoption"));//选择最多项
	String keys = Util.null2String(request.getParameter("keys"));//投票选项数组ID,参数是以voteoption开头
	String voteprivacy = Util.null2String(request.getParameter("voteprivacy"));//投票隐私
	String createrid = Util.null2String(request.getParameter("createrid"));//投票创建人
	String createdate=format1.format(curdate);//投票创建日期
	String createtime = format3.format(curdate);//投票创建时间
	String enddate="";//截止日期
	String endtime="";//截止时间
	RecordSet.writeLog("dataFrom=="+dataFrom);
	if("mb".equals(dataFrom)){//mobile端
		RecordSet.writeLog("mobile");
		String moendtime = Util.null2String(request.getParameter("finishTime"));//投票截止日期
		Date modateenddate=new Date(moendtime);
		enddate=format1.format(modateenddate);
		endtime=format2.format(modateenddate);
	}else{//pc端
		RecordSet.writeLog("pc");
		String stringenddate = Util.null2String(request.getParameter("enddate"));//投票截止日期
		Date dateenddate=new Date(stringenddate);
		enddate=format1.format(dateenddate);
		String stringendtime = Util.null2String(request.getParameter("endtime"));//投票截止时间
		Date dateendtime=new Date(stringendtime);
		endtime=format2.format(dateendtime);
	}	
	String voteremind = Util.null2String(request.getParameter("voteremind"));//投票提醒
	String groupid = Util.null2String(request.getParameter("groupid"));//群ID
	User user = HrmUserVarify.getUser (request , response) ;
	createrid=user.getUID()+"";
	GroupChatVote groupChatVote = new GroupChatVote();
	List<GroupChatVoteOption> groupChatVoteOptions=new ArrayList<GroupChatVoteOption>();
	int votingid=GroupChatVotingIdUtil.getGroupChatVotingId("SequenceIndex_GroupChatVoteid","groupchatvote");
	groupChatVote.setId(votingid+"");
	groupChatVote.setVotetheme(votetheme);
	groupChatVote.setThemeimageid(themeimageid);
	groupChatVote.setChoosemodel(choosemodel);
	if("1".equals(choosemodel)){
		groupChatVote.setMaxvoteoption(maxvoteoption);
	}else{
		groupChatVote.setMaxvoteoption("0");
	}
	groupChatVote.setVoteprivacy(voteprivacy);
	groupChatVote.setCreaterid(createrid);
	groupChatVote.setCreatedate(createdate);
	groupChatVote.setCreatetime(createtime);
	groupChatVote.setEnddate(enddate);
	groupChatVote.setEndtime(endtime);
	groupChatVote.setVoteremind(voteremind);
	groupChatVote.setVotestatus("0");//进行中
	groupChatVote.setGroupid(groupid);
	if(StringUtil.isNotNull(keys)){
		String[] optionids= keys.split(",");
		for(String optionid:optionids){
			String voteoptioncontent=request.getParameter("voteoption"+optionid);
			if(StringUtil.isNotNull(voteoptioncontent) && !"undefined".equals(voteoptioncontent)){
				GroupChatVoteOption groupChatVoteOption=new GroupChatVoteOption();
				int voteoptionid=GroupChatVotingIdUtil.getGroupChatVotingId("SequenceIndex_GroupChatVoteOid","groupchatvoteoption");
				groupChatVoteOption.setId(voteoptionid+"");
				groupChatVoteOption.setOptioncontent(voteoptioncontent);
				groupChatVoteOption.setVotingid(votingid+"");
				groupChatVoteOptions.add(groupChatVoteOption);
			}
		}
	}
	groupChatVote.setOptions(groupChatVoteOptions);
	GroupChatVotingManager.saveGroupChatVote(groupChatVote);
	Map<String,String> map=new HashMap<String,String>();
	map.put("votingid",groupChatVote.getId());
	map.put("votetheme",groupChatVote.getVotetheme());
	map.put("themeimageid",groupChatVote.getThemeimageid());
	map.put("createrid", groupChatVote.getCreaterid());
	map.put("creatername", ResourceComInfo.getLastname(groupChatVote.getCreaterid()));
	map.put("createdate", groupChatVote.getCreatedate());
	map.put("createtime", groupChatVote.getCreatetime());
	map.put("enddate", groupChatVote.getEnddate());
	map.put("endtime", groupChatVote.getEndtime());
	map.put("voteremind", groupChatVote.getVoteremind());
	map.put("votestatus", groupChatVote.getVotestatus());
	map.put("deletestatus","1");
	map.put("saveflag","sucess");
	RecordSet.writeLog("groupChatVote.getGroupid()=="+groupChatVote.getGroupid()+";groupChatVote.getId()==="+groupChatVote.getId()+";groupChatVote.getVotetheme()==="+groupChatVote.getVotetheme()+";endtime===="+groupChatVote.getEnddate()+" "+groupChatVote.getEndtime()+";groupChatVote.getVoteremind()=="+groupChatVote.getVoteremind());
	try {
		if("1".equals(groupChatVote.getVoteremind()) || "2".equals(groupChatVote.getVoteremind()) || "3".equals(groupChatVote.getVoteremind())){
			GroupChatVotingScheduler.createTimedTask(groupChatVote.getGroupid(),groupChatVote.getId(),groupChatVote.getVotetheme(),groupChatVote.getEnddate()+" "+groupChatVote.getEndtime(),groupChatVote.getVoteremind());
		}
	} catch (Exception e) {	
	}	
	JSONObject obj = new JSONObject();
    obj.put("vote",map);
    out.println(obj.toString());
%>