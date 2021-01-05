
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.*,java.util.*"%>
<%@ page import="weaver.hrm.*,weaver.conn.*,org.json.*,java.math.*"%>
<%@ page import="weaver.systeminfo.setting.HrmUserSettingComInfo" %>
<jsp:useBean id="userinputrs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsbelongs" class="weaver.conn.RecordSet" scope="page" />
<%
    HrmUserSettingComInfo userSetting=new HrmUserSettingComInfo();
    User useritem = HrmUserVarify.getUser (request , response) ;
    String belongtoshow = userSetting.getBelongtoshowByUserId(useritem.getUID()+""); 
	String belongtoids = useritem.getBelongtoids();
	String account_type = useritem.getAccount_type();
    String votingid= Util.null2String(request.getParameter("votingid"));
	String voresourceid="";
   Map<String,String> userinput;
   String sql=" select resourceid from VotingRemark where votingid="+votingid+" and resourceid ="+useritem.getUID();
   userinputrs.execute(sql);
   if(userinputrs.next()){
	   voresourceid=userinputrs.getString("resourceid");       	  
   }else{
      sql=" select resourceid from VotingRemark where votingid="+votingid+" and  resourceid in("+belongtoids+")";
	  rsbelongs.execute(sql);
	  if(rsbelongs.next()){
	    voresourceid=rsbelongs.getString("resourceid");   
	  
	  }

   }

  
   JSONObject oJson= new JSONObject();
   oJson.put("resourceid",voresourceid);
   out.print(oJson.toString());
%>



