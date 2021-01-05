
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.*,java.util.*,weaver.voting.*"%>
<%@ page import="weaver.hrm.*,weaver.conn.*,org.json.*,java.math.*"%>
<jsp:useBean id="voters" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="VotingManager" class="weaver.voting.VotingManager" scope="page" />		
<%
   //结果集
   List<List<Map<String,String>>>  rsallitems=new ArrayList<List<Map<String,String>>>();
   //结果子集
   List<Map<String,String>>  rsitems;
   //分部id集合
   String subcompanyids= Util.null2String(request.getParameter("subcompanyids"));
   //subcompanyids="-1,-2";
   //统计方式
   String statisform= Util.null2String(request.getParameter("statics"));
   //默认汇总
   if("".equals(statisform)){
      statisform="0";   
   }

   //调查id
   String vtid = Util.null2String(request.getParameter("votingid"));
   //分部id集合
   List<String>  subcomids=new ArrayList<String>();
   //分部名称集合
   List<String>  subcomnames=new ArrayList<String>();
   
   //统计所有
   if("".equals(subcompanyids)){
	   rsitems=VotingSearchResult.votingAllRs(vtid);
	   rsallitems.add(rsitems);
	   subcomids.add("-1");
	   subcomnames.add("");
   //汇总统计
   }else if(!"".equals(subcompanyids) && "0".equals(statisform)){
	   String allsubids=VotingSearchResult.getChildIdsAll(subcompanyids);
	   rsitems=VotingSearchResult.votingAllRsWithSubCompanyStatis(vtid,allsubids);
	   rsallitems.add(rsitems);
	   subcomids.add(subcompanyids);
	   subcomnames.add("");
   //按分部统计
   }else if(!"".equals(subcompanyids) && "1".equals(statisform)){
	 
       String[] subids=subcompanyids.split(",");
       String allsubids;
       for(String subid:subids){
		   allsubids=VotingSearchResult.getChildIdsAll(subid);
		   rsitems=VotingSearchResult.votingAllRsWithSubCompanyStatis(vtid,allsubids);   
    	   rsallitems.add(rsitems);
    	   subcomids.add(subid);
		  
		   sql="select subcompanyname  from HrmSubCompany where id='"+subid+"'";
		    if(Util.getIntValue(subid,0)<0){
		    sql="select subcompanyname  from HrmSubCompanyVirtual where id='"+subid+"'";
		   }
           voters.execute(sql);
		   if(voters.next()){
		      subcomnames.add(voters.getString("subcompanyname"));
		   }else{
		      subcomnames.add("");
		   }
       }
   }   

   Map<String,List<Map<String,String>>> optionvoters=new HashMap<String,List<Map<String,String>>>();
   List<Map<String,String>> voteitems; 
   Map<String,String> voteitem;
   String opitem;
   String resourceid;
   String lastname;
   String subcomid;
   String useranony;
 
 
   sql="select optionid,a.resourceid,lastname,subcompanyid1,c.useranony  from VotingResource a inner join HrmResource b on a.resourceid=b.id left join VotingRemark c on a.votingid=c.votingid and a.resourceid=c.resourceid  where a.votingid='"+vtid+"' ";
  if(!subcompanyids.equals("")){
   String[]  firstsubs=Util.TokenizerString2(subcompanyids,",");  
   if(Util.getIntValue(firstsubs[0],0)<0){
   sql="select optionid,a.resourceid,lastname,subcompanyid1,c.useranony  from VotingResource a inner join (select t2.lastname,t1.subcompanyid as subcompanyid1 ,t2.id  from HrmResourceVirtual t1,HrmResource t2 where t1.resourceid=t2.id and t1.subcompanyid  in ("+subcompanyids+")) b on a.resourceid=b.id left join VotingRemark c on a.votingid=c.votingid and a.resourceid=c.resourceid  where a.votingid='"+vtid+"' ";
   }
  }
   voters.execute(sql);
   while(voters.next()){
	   opitem=voters.getString("optionid");
	   resourceid=voters.getString("resourceid");
	   lastname=voters.getString("lastname");
	   subcomid=voters.getString("subcompanyid1");
	   useranony=Util.null2String(voters.getString("useranony"));
	   voteitem=new HashMap<String,String>();
	   voteitem.put("rid",resourceid);
	   voteitem.put("name",lastname);
	   voteitem.put("subcomid",subcomid);
	   voteitem.put("useranony",useranony);
	   if(!optionvoters.containsKey(opitem)){
		   voteitems=new ArrayList<Map<String,String>>();
		   optionvoters.put(opitem,voteitems);
	   }
	   voteitems=optionvoters.get(opitem);
	   voteitems.add(voteitem);
   }
   
   JSONArray votersobj=new JSONArray(rsallitems);
   String votersitems=votersobj.toString();
   JSONArray subcomidsobj=new JSONArray(subcomids);
   String subcomidsitems=subcomidsobj.toString();
   JSONArray subnamesobj=new JSONArray(subcomnames);
   String subnamesitems=subnamesobj.toString();
   JSONObject optionvotersobj=new JSONObject(optionvoters);
   String   optionvoteritems=optionvotersobj.toString();
   
 //获取没有投票的人员信息
   	List novotingperson = new ArrayList();
		Set undoUserSet=VotingManager.getUndoUserSet(vtid);
		novotingperson.clear();
		novotingperson.addAll(undoUserSet);
	
	//获取已投票的人员信息
   List votingperson = new ArrayList();
   Set doUserSet=VotingManager.getDoUserSet(vtid);
   votingperson.addAll(doUserSet);

	
%>



