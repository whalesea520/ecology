
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.system.code.*"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%

if(!HrmUserVarify.checkUserRight("WorktaskManage:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<%
	int wtid = Util.getIntValue(request.getParameter("wtid"), 0);

	int selectField=  Util.getIntValue(request.getParameter("selectField"), 0);
	String postValue=  Util.null2String(request.getParameter("postValue"));
	String worktaskSeqAlone=  Util.null2String(request.getParameter("worktaskSeqAlone"));
	int dateSeqAlone=  Util.getIntValue(request.getParameter("dateSeqAlone"), 0);
	int dateSeqSelect=  Util.getIntValue(request.getParameter("dateSeqSelect"), 0);

	int txtUserUse=  Util.getIntValue(request.getParameter("txtUserUse"), 0);

	if("1".equals(worktaskSeqAlone)){

		rs.executeSql("select * from  worktask_code  where taskid="+wtid);
		if (rs.next()){
			rs.executeSql("update  worktask_code  set codeField="+selectField+",isUse='"+txtUserUse+"',worktaskSeqAlone='"+worktaskSeqAlone+"',dateSeqAlone='"+dateSeqAlone+"',dateSeqSelect='"+dateSeqSelect+"' where taskid="+wtid);
		}else{
			rs.executeSql("insert into  worktask_code (taskid, isuse, codefield, worktaskSeqAlone, dateSeqAlone, dateSeqSelect) values("+wtid+","+txtUserUse+","+selectField+", "+worktaskSeqAlone+", "+dateSeqAlone+", "+dateSeqSelect+")");
		}

		rs.executeSql("delete worktask_codeDetail where taskid="+wtid);
		String[] members = Util.TokenizerString2(postValue,"\u0007");
		for (int i=0;i<members.length;i++){
			String member = members[i];
			String memberAttibutes[] = Util.TokenizerString2(member,"\u001b");
			String text = memberAttibutes[0];
			String value = memberAttibutes[1];
			if ("[(*_*)]".equals(value)){
				value="";
			}
			String type = memberAttibutes[2];

			String insertStr = "insert into worktask_codeDetail (showId,codeValue,codeOrder,taskid) values ("+text+", '"+value+"', "+i+", "+wtid+")";
			//System.out.println(insertStr);
			rs.executeSql(insertStr);          
		}
	}else{
		//rs.executeSql("update worktask_Code set worktaskSeqAlone=0 where taskid="+wtid);
		rs.executeSql("select * from  worktask_code  where taskid="+wtid);
		if (rs.next()){
			rs.executeSql("update  worktask_code  set codeField="+selectField+", isUse="+txtUserUse+", worktaskSeqAlone=0, dateSeqAlone="+dateSeqAlone+", dateSeqSelect="+dateSeqSelect+" where taskid="+wtid);
		}else{
			rs.executeSql("insert into worktask_code (taskid, isUse, codeField, worktaskSeqAlone, dateSeqAlone, dateSeqSelect) values("+wtid+", "+txtUserUse+", "+selectField+", 0, "+dateSeqAlone+", "+dateSeqSelect+")");
		}
		//System.out.println("insert into worktask_code (taskid, isUse, codeField, worktaskSeqAlone, dateSeqAlone, dateSeqSelect) values("+wtid+", "+txtUserUse+", "+selectField+", 0, "+dateSeqAlone+", "+dateSeqSelect+")");
		rs.executeSql("delete worktask_codeDetail where taskid=0");
		String[] members = Util.TokenizerString2(postValue,"\u0007");
		for (int i=0;i<members.length;i++){
			String member = members[i];
			String memberAttibutes[] = Util.TokenizerString2(member,"\u001b");
			String text = memberAttibutes[0];
			String value = memberAttibutes[1];
			if ("[(*_*)]".equals(value)){
				value="";
			}
			String type = memberAttibutes[2];
			String insertStr = "insert into worktask_codeDetail (taskid, showid, codeValue, codeOrder) values (0, "+text+", '"+value+"', "+i+")";	  
			rs.executeSql(insertStr);
		}
	}
	response.sendRedirect("WTCode.jsp?wtid="+wtid);

%>


