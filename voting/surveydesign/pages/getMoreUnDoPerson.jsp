<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.util.Set,java.util.Iterator" %>
<jsp:useBean id="VotingManager" class="weaver.voting.VotingManager" scope="page" />	
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<% 
        String vtid = Util.null2String(request.getParameter("votingid"));
		int currentnum=Util.getIntValue(request.getParameter("currentnum"),0);
	    String opeation = Util.null2String(request.getParameter("opeation"));
		if(opeation.equals("2")){
		VotingManager.setCurrentUnDonum(currentnum);
		Set undoUserSet=VotingManager.getUndoUserSet(vtid);
        for(Iterator i = undoUserSet.iterator();i.hasNext();)
				{ 
				   String tpnoname = (String)i.next();
				   tpnoname=ResourceComInfo.getResourcename(tpnoname);
	               out.println(tpnoname+"&nbsp;&nbsp;");				
				}
	    }else if (opeation.equals("1")){
		VotingManager.setCurrentDonum(currentnum);
		Set doUserSet=VotingManager.getDoUserSet(vtid);
        for(Iterator i = doUserSet.iterator();i.hasNext();)
				{ 
				   String tpnoname = (String)i.next();		
	               out.println(tpnoname+"&nbsp;&nbsp;");				
				}
		
		}
%>
 	
