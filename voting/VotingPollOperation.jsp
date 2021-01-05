
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.general.TimeUtil"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String userid = user.getUID()+"";
Date newdate = new Date() ;
long datetime = newdate.getTime() ;

String CurrentDate = TimeUtil.getCurrentDateString()  ;
String CurrentTime = TimeUtil.getCurrentTimeString().substring(11);

String method=Util.null2String(request.getParameter("method"));
String votingid=Util.null2String(request.getParameter("votingid"));
String useranony = Util.null2String(request.getParameter("useranony"));
if(useranony.equals(""))    useranony="0";


String remark = Util.fromScreen(request.getParameter("remark"),7);
RecordSet.executeProc("Voting_SelectByID",votingid);
RecordSet.next();
String isanony=RecordSet.getString("isanony");
String status = RecordSet.getString("status");

if(!status.equals("1")){
	out.println("<script language='javascript'>alert('"+SystemEnv.getHtmlLabelName(30348 ,user.getLanguage())+"');try{parent.parent.Dialog.close();}catch(e){e};</script>");
	return;
}
char flag = 2;
String Procpara="";

boolean canresulet = false;
String sqlstr = "select resourceid from VotingViewerDetail where votingid ="+votingid;
RecordSet.execute(sqlstr);
while(RecordSet.next()){
  if(userid.equals(RecordSet.getString("resourceid"))){
    canresulet = true;
  }
}

if(method.equals("pollsubmit")){
	//先查看一下，此人是否已提交过此网上调查
	RecordSet.executeSql("select * from VotingRemark where votingid="+votingid+" and resourceid="+userid);
	if(RecordSet.next()){
		out.println("<script language='javascript'>alert('"+SystemEnv.getHtmlLabelName(21508 ,user.getLanguage())+"');window.location='VotingPollResult.jsp?votingid="+votingid+"'</script>");
		//response.sendRedirect("VotingPollResult.jsp?votingid="+votingid);
		return;
	}	
    RecordSet.executeProc("VotingQuestion_SelectByVoting",votingid);
    ArrayList questionids = new ArrayList ();
    while(RecordSet.next()){
        String curid = RecordSet.getString("id");
        questionids.add(curid);
    }

    for(int i=0; i<questionids.size(); i++){
        String questionid = (String)questionids.get(i);
        String[] optionids = request.getParameterValues("questionid_"+questionid);
        if(optionids!=null){
            for(int j=0; j<optionids.length; j++){
                String optionid = optionids[j];
                Procpara=votingid + flag + questionid + flag + optionid + flag + userid + flag + CurrentDate + flag + CurrentTime ;
                RecordSet.executeProc("VotingResource_Insert",Procpara);
                RecordSet.executeProc("VotingOption_UpdateCount",optionid);
            }
        }
        RecordSet.executeSql("select isanony from voting where id = "+votingid);
        if (RecordSet.next()) useranony = Util.null2String(RecordSet.getString(1));
        String otherinput = Util.null2String(request.getParameter("otherinput_"+questionid));
        if(!otherinput.equals("")||!remark.equals("")){
            if(optionids == null){
              String optionidTemp = questionid;
              String ProcparaTemp = votingid + flag + questionid + flag + optionidTemp + flag + userid + flag + CurrentDate + flag + CurrentTime ; 
              RecordSet.executeProc("VotingResource_Insert",ProcparaTemp);
            }
            Procpara=votingid + flag + questionid + flag + userid + flag + useranony + flag +
                    otherinput + flag + CurrentDate + flag + CurrentTime;
            RecordSet.executeProc("VotingResourceRemark_Insert",Procpara);
        }    
        RecordSet.executeProc("VotingQuestion_UpdateCount",questionid);  
    } 
    RecordSet.executeProc("Voting_UpdateCount",votingid);  
    Procpara = votingid + flag + userid + flag + useranony + flag + remark + flag + CurrentDate + flag + CurrentTime;
    RecordSet.executeProc("VotingRemark_Insert",Procpara); 
    
    String isSeeResult = "0";
    RecordSet.executeSql("select isSeeResult from voting where id="+votingid);
    if(RecordSet.next()) isSeeResult = Util.null2String(RecordSet.getString("isSeeResult"));
	if("1".equals(isSeeResult) && !canresulet){
		out.println("<script language='javascript'>alert('"+SystemEnv.getHtmlLabelName(21724,user.getLanguage())+"');try{parent.parent.Dialog.close();}catch(e){window.close();};</script>");
	}else{
	  response.sendRedirect("VotingPollResult.jsp?votingid="+votingid); 
	}       
}
%>