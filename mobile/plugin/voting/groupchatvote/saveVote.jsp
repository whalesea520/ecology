<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util,weaver.common.StringUtil,weaver.general.TimeUtil" %>
<%@ page import="weaver.voting.bean.GroupChatVote" %>
<%@ page import="weaver.voting.bean.GroupChatVoteOption" %>
<%@ page import="weaver.hrm.*,weaver.conn.RecordSet" %>
<%@ page import="net.sf.json.JSONObject" %>
<jsp:useBean id="GroupChatVotingManager" class="weaver.voting.groupchartvote.GroupChatVotingManager" scope="page"/>
<jsp:useBean id="GroupChatVotingIdUtil" class="weaver.voting.groupchartvote.GroupChatVotingIdUtil" scope="page"/>
<jsp:useBean id="GroupChatVotingScheduler" class="weaver.voting.groupchartvote.GroupChatVotingScheduler" scope="page"/>
<%  
User user = HrmUserVarify.getUser(request,response);
RecordSet rs = new RecordSet();
    
    String votetheme = Util.null2String(request.getParameter("votetheme"));//投票主题
    String choosemodel = Util.null2String(request.getParameter("choosemodel"));//投票模式
    String maxvoteoption = Util.null2String(request.getParameter("maxvoteoption"));//选择最多项
    String keys = Util.null2String(request.getParameter("keys"));//投票选项数组ID,参数是以voteoption开头
    String voteprivacy = Util.null2String(request.getParameter("publishAnony"));//投票隐私
    String createdate = TimeUtil.getCurrentDateString();//投票创建日期
    String createtime = TimeUtil.getOnlyCurrentTimeString();//投票创建时间
    String enddate = Util.null2String(request.getParameter("enddate"));
    String endtime = Util.null2String(request.getParameter("endtime"));
    String voteremind = Util.null2String(request.getParameter("voteremind"));//投票提醒
    String groupid = Util.null2String(request.getParameter("groupid"));//群ID
    GroupChatVote groupChatVote = new GroupChatVote();
    List<GroupChatVoteOption> groupChatVoteOptions=new ArrayList<GroupChatVoteOption>();
    int votingid=GroupChatVotingIdUtil.getGroupChatVotingId("SequenceIndex_GroupChatVoteid","groupchatvote");
    
    
    String themeImageid = Util.null2String(request.getParameter("imagefileid"));//图片id
    
    groupChatVote.setId(votingid+"");
    groupChatVote.setVotetheme(votetheme);
    groupChatVote.setChoosemodel(choosemodel);
    if("1".equals(choosemodel)){
        groupChatVote.setMaxvoteoption(maxvoteoption);
    }else{
        groupChatVote.setMaxvoteoption("0");
    }
    groupChatVote.setVoteprivacy(voteprivacy);
    groupChatVote.setCreaterid(user == null ? "-1" : (user.getUID() + ""));
    groupChatVote.setCreatedate(createdate);
    groupChatVote.setCreatetime(createtime);
    groupChatVote.setThemeimageid(themeImageid);
    
    groupChatVote.setEnddate(enddate);
    groupChatVote.setEndtime(endtime);
    groupChatVote.setVoteremind(voteremind);
    groupChatVote.setVotestatus("0");//进行中
    groupChatVote.setGroupid(groupid);
    
    JSONObject json = new JSONObject();
    try{
	    if(StringUtil.isNotNull(keys)){
	        if(keys.startsWith("[") && keys.endsWith("]")){
	            keys = keys.substring(1,keys.length() - 1);
	        }
	        String[] optionids= keys.split(",");
	        for(String optionid : optionids){
	        	String voteoptioncontent = Util.null2String(request.getParameter("voteoption" + optionid));
	        	if(StringUtil.isNotNull(voteoptioncontent)&&!"undefined".equals(voteoptioncontent)){
	        		GroupChatVoteOption groupChatVoteOption=new GroupChatVoteOption();
		            int voteoptionid=GroupChatVotingIdUtil.getGroupChatVotingId("SequenceIndex_GroupChatVoteOid","groupchatvoteoption");
		            groupChatVoteOption.setId(voteoptionid + "");
		            groupChatVoteOption.setOptioncontent(voteoptioncontent);
		            groupChatVoteOption.setVotingid(votingid + "");
		            groupChatVoteOptions.add(groupChatVoteOption);
	        	}	            
	        }
	    }
	    groupChatVote.setOptions(groupChatVoteOptions);
	    GroupChatVotingManager.saveGroupChatVote(groupChatVote);
	    
	    json.put("status",1);
    }catch(Exception e){
        json.put("status",0);
    }

   
    json.put("voteid",votingid);
    json.put("imageid",themeImageid);
    
    try{
        if("1".equals(voteremind) || "2".equals(voteremind) || "3".equals(voteremind)){
            GroupChatVotingScheduler.createTimedTask(groupid,votingid + "",votetheme,enddate+" "+endtime,voteremind);
        }
    }catch(Exception e){
        
    }
    out.println(json.toString());
%>