<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.ParseException"%>
<%@ page import="weaver.hrm.*,weaver.conn.RecordSet" %>
<%@ page import="weaver.general.*,org.json.*" %>
<%@ page import="weaver.social.im.SocialIMClient"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="GroupChatVotingManager" class="weaver.voting.groupchartvote.GroupChatVotingManager" scope="page"/>

<%
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
    User user = HrmUserVarify.getUser (request , response) ;
    if(user == null)  return ; 
    Date curdate=new Date();//系统当前时间
    SimpleDateFormat format1=new SimpleDateFormat("yyyy-MM-dd HH:mm");
    String groupid = Util.null2String(request.getParameter("groupid"));
    String votetheme = Util.null2String(request.getParameter("votetheme"));	
	//String groupowner= Util.null2String(request.getParameter("groupowner"));//群主账号	
	String groupowner="";
    JSONObject groupobj=null;
    try {
    	String groupmembers=SocialIMClient.getGroupInfo(groupid);
		groupobj = new JSONObject(groupmembers);
		groupowner=groupobj.get("adminUserId")+"";//群主账号
	} catch (JSONException e) {	
	}
	String dataFrom = Util.null2String(request.getParameter("dataFrom"));
	String ifsearch = Util.null2String(request.getParameter("ifsearch"));//为null说明是直接加载，为search说明是查询
	String curuserid=user.getUID()+"";
  	List<Map<String,String>> sourcedatavotes=GroupChatVotingManager.getVoteListsByGroupid(groupid,votetheme,curuserid);
  	List<Map<String,String>> targetdatavotes=new ArrayList<Map<String,String>>();
  	if(sourcedatavotes!=null && sourcedatavotes.size()>0){
  		for(Map<String,String> vote:sourcedatavotes){
  			Map<String,String> map=new HashMap<String,String>();
  			String createrid=vote.get("createrid");
  			map.put("votingid", vote.get("votingid"));
  			map.put("votetheme", vote.get("votetheme"));
  			map.put("createrid", createrid);
  			map.put("creatername", ResourceComInfo.getLastname(createrid));
  			map.put("createdate", vote.get("createdate"));
  			map.put("createtime", vote.get("createtime"));
  			
  			//String votestatus=vote.get("votestatus");
  			String votestatus="";
  			String voteendtime=vote.get("enddate")+" "+vote.get("endtime");
  			try {
  				Date date = format1.parse(voteendtime);
				votestatus=curdate.getTime()<date.getTime()? "0":"1";
			} catch (ParseException e) {
				e.printStackTrace();
			}
  			String canvote="";
  			//String votestatusshow="";
  			String votestatusendshow="已结束";
  			String votestatusongoingshow="进行中";
  			if("1".equals(votestatus)){
  				//votestatusshow="已结束";
  				canvote="0";
  			}else{
  				String ifvoted=vote.get("ifvoted");
  				if("0".equals(ifvoted)){
  					canvote="1";
  				}else{
  					canvote="0";
  				}
  				//votestatusshow="进行中";
  			}
  			map.put("votestatus",votestatus);
  			//map.put("votestatusshow",votestatusshow);
  			map.put("voteendtime",voteendtime);
  			map.put("votestatusendshow",votestatusendshow);
  			map.put("votestatusongoingshow",votestatusongoingshow);
  			map.put("canvote",canvote);
  			//判断当前登录人是否是群主或者发布人，如果是，则标记为1，可删除投票；如果不是，则标记为0，不可删除投票，不显示删除按钮；
  			String deletestatus="";
  			if(curuserid.equals(groupowner) || curuserid.equals(createrid) ){
  				deletestatus="1";
  			}else{
  				deletestatus="0";
  			}
  			map.put("deletestatus",deletestatus);
  			targetdatavotes.add(map);
  			
  			if("mb".equals(dataFrom)){
  			   // Map<String,Object> voteMap = GroupChatVotingManager.getVoteById(vote.get("votingid"),"",groupid);
  			  //  voteMap.get("options");
  			  //  map.put("options",voteMap.get("options"));
  			    
  			    map.put("ifvoted",vote.get("ifvoted")); 
  			    map.put("enddate",vote.get("enddate"));
  			    map.put("endtime",vote.get("endtime"));
  			    map.put("themeimageid",Util.getIntValue(vote.get("themeimageid"),0)+"");
  			    map.put("createrDept",DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(createrid)));
  			    RecordSet rs = new RecordSet();
  			    rs.executeSql("select messagerurl,sex from hrmresource where id=" + createrid);
	  			String messagerurl = "";
	            if(rs.next()){
	                messagerurl = Util.null2String(rs.getString("messagerurl"));
	                map.put("createSex",rs.getString("sex"));
	            }
	              
	            if(messagerurl.isEmpty()){
	                messagerurl = "/social/icon/" + createrid + "_usericon.jpg";
	            }
	            map.put("createrPhoto",messagerurl);
  			    
  			    
  			}
  			
  		}
  	}
    JSONObject obj = new JSONObject();
    obj.put("dataList",targetdatavotes);
    obj.put("ifsearch",ifsearch);
    out.println(obj.toString()); 
%>