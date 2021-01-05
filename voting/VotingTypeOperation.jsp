
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%
String method = Util.null2String(request.getParameter("method"));
String name=Util.null2String(request.getParameter("typename"));
int approver=Util.getIntValue(request.getParameter("approver"),0);
if(method.equals("add")) {
	if(!"".equals(name)) {
		RecordSet.executeSql("insert into voting_type (typename,approver) values ('"+name+"',"+approver+")");
	}
	out.println("<script>parent.getParentWindow(window).MainCallback();</script>");
}

if(method.equals("edit")) {
	String id=Util.null2String(request.getParameter("id"));
	if(!"".equals(id) && !"".equals(name)) {
		RecordSet.executeSql("update voting_type set typename = '"+name+"',approver="+approver+" where id ="+id);
	}
	out.println("<script>parent.getParentWindow(window).MainCallback();</script>");
}

//验证是否 重名
if(method.equals("checkname")) {
	String id=Util.null2String(request.getParameter("id"));
	//System.out.println("select * from voting_type where typename = '"+name+"'");
	if(!"".equals(id) && !"".equals(name)) {
		RecordSet.executeSql("select * from voting_type where typename = '"+name+"' and id !="+id);
	}else{
		RecordSet.executeSql("select * from voting_type where typename = '"+name+"'");
	}
	if(RecordSet.next()) out.println("1");
}


if (method.equals("canApprove")) {//是否可以执行 批准操作
	String votingid = Util.null2String(request.getParameter("votingid"));
    String str = "0";
	RecordSet.executeSql("select * from votingoption where votingid ="+votingid);
	if(RecordSet.next()){
		str = "1"; 
	}else{
	   String isother = "";
	   RecordSet.executeSql("select * from votingQuestion where votingid ="+votingid);
	   if(RecordSet.next()) {
		   str = "1"; 
	   }
	}
	//0 是不可执行批准操作。1 是可以执行
    out.println(str);
	return;
}



String votingTypeIDs[]=Util.null2String(request.getParameter("votingTypeIDs")).split(",");
if(method.equals("delete")) {
    String noDelVotingTypes ="";
	if(votingTypeIDs != null) {
		for(int i=0;i<votingTypeIDs.length;i++) {
			RecordSet.executeSql("select subject from Voting where votingtype="+votingTypeIDs[i]);
			while(RecordSet.next()) {
				noDelVotingTypes += RecordSet.getString(1)+"," ;
			}
			if(RecordSet.getCounts() <= 0) {
				rs.executeSql("delete from voting_type where id ="+votingTypeIDs[i]);
			}
		}
	}
    if(noDelVotingTypes.length()>0) 
    noDelVotingTypes = noDelVotingTypes.substring(0,noDelVotingTypes.length()-1);
    session.setAttribute("noDelVotingTypes",noDelVotingTypes);
    //out.println("<script>parent.getParentWindow(window).MainCallback();</script>");
}
%>
