<%@ page language="java" contentType="application/json;charset=UTF-8" %>
<%@page import="weaver.general.Util,
				weaver.hrm.*,
				weaver.systeminfo.setting.HrmUserSettingComInfo,java.util.*,
				java.text.SimpleDateFormat"%>
<%@page import="org.json.JSONObject"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />


<%
	JSONObject returnObject = new JSONObject();
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null){
	    return;
	}
	String votingid = Util.null2String(request.getParameter("votingId"));
	if(votingid.isEmpty()){
	    returnObject.put("flag","-2");
	    out.print(returnObject.toString());
	    return; //参数异常
	}
	Object obj = request.getSession().getAttribute("votingMap");
	Map<String,String> votingMap = null;
	if(obj == null){
	    HrmUserSettingComInfo userSetting=new HrmUserSettingComInfo();
	    String belongtoshow = userSetting.getBelongtoshowByUserId(user.getUID()+""); 
		String belongtoids = user.getBelongtoids();
		String account_type = user.getAccount_type();
	    String votingshareids=""+user.getUID();
		if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
		votingshareids+=","+belongtoids;	
		}
	    String sql = "select t1.* from voting t1,VotingShareDetail t2 where t1.id=t2.votingid "
			+ " and t2.resourceid in("
			+ votingshareids
			+ ") and t1.status!=0 and t1.id=" + votingid;
	
		rs.executeSql(sql);
		if (!rs.next()) {
		    returnObject.put("flag","-1");
		    out.print(returnObject.toString());
			return;//没有权限
		}
		votingMap = new HashMap<String,String>();
		votingMap.put(votingid,"");
		request.getSession().setAttribute("votingMap",votingMap);
	}else{
	    votingMap = (Map)obj;
	    if(votingMap.get(votingid) == null){
	        returnObject.put("flag","-1");
	        out.print(returnObject.toString());
	        return;//没有权限
	    }
	}
	String qid = Util.null2String(request.getParameter("qid"));
	String oid = Util.null2String(request.getParameter("oid"));
	String remark = Util.null2String(request.getParameter("remark"));
	String type = Util.null2String(request.getParameter("type"));   //checkbox-多选 。radio-单选。select-下拉
	String operate = Util.null2String(request.getParameter("operate"));   // 1-选中。0-取消 。-1-其他输入
	String questiontype = Util.null2String(request.getParameter("questiontype")); //0-选择题，1-组合题，2-填空题，-1-选择题其他输入
	if(qid.isEmpty()){
	    returnObject.put("flag","-2");
	    out.print(returnObject.toString());
	    return; //参数异常
	}
	
	Date date = new Date();
	String dateString = new SimpleDateFormat("yyyy-MM-dd").format(date);
	String timeString = new SimpleDateFormat("HH:mm:ss").format(date);
	
	if(type.equals("radio") || type.equals("select") || questiontype.equals("2")){ 
	    if(questiontype.equals("1")){
	        String rowOpid = oid.contains("_") ? oid.substring(0,oid.indexOf("_")) : oid;
	        rs.executeSql("delete VotingResourceTemp where votingid=" + votingid + " and questionid=" + qid + " and resourceid=" + user.getUID() + " and optionid like '" + rowOpid + "_%'");
	    }else{
			rs.executeSql("delete VotingResourceTemp where votingid=" + votingid + " and questionid=" + qid + " and resourceid=" + user.getUID());
	    }
	}else if(type.equals("checkbox") && operate.equals("0")){
	    rs.executeSql("delete VotingResourceTemp where votingid=" + votingid + " and questionid=" + qid + " and resourceid=" + user.getUID() + 
	          (oid.isEmpty() ? " and optionid is null" : (" and optionid='" + oid + "'")));
	}
	
	if("-100".equals(oid)){
	    remark = remark.replaceAll("'","''");
	}else{
	    remark = remark.replaceAll("'","''");
	}
	returnObject.put("flag","0");
	if(operate.equals("1") || questiontype.equals("2")){
	    if(questiontype.equals("2") && remark.trim().isEmpty()){
	    }else{
			rs.executeSql("insert into VotingResourceTemp(votingid,questionid,optionid,resourceid,operatedate,operatetime,remark) " +
	        	" values(" + votingid + "," + qid + "," + (oid.isEmpty() ? null : ("'" + oid + "'")) + "," + user.getUID() + ",'" + dateString +"','" + timeString + "','" + remark + "') ");
	    }
		returnObject.put("flag","1");
	}else if(operate.equals("-1")){
	    rs.executeSql("update VotingResourceTemp set remark='" + remark + "' where votingid=" + votingid + " and questionid=" + qid + " and resourceid=" + user.getUID());
	    returnObject.put("flag","1");
	}else if(operate.equals("0")){
	    returnObject.put("flag","1");
	}
	out.print(returnObject.toString());
	

%>