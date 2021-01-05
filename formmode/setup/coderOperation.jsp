
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.system.code.*"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
  String method=  Util.null2String(request.getParameter("method"));
  //String codemainid=  Util.null2String(request.getParameter("codemainid"));
  String postValue=  Util.null2String(request.getParameter("postValue"));
  int txtUserUse=  Util.getIntValue(request.getParameter("txtUserUse"),0);
  int codeFieldId=  Util.getIntValue(request.getParameter("codeFieldId"),0);
  int startcodenum=  Util.getIntValue(request.getParameter("startcodenum"),1);
  int modeId=  Util.getIntValue(request.getParameter("modeId"),0);
  if ("update".equals(method)) {
    rs.executeSql("update ModeCode set isuse="+txtUserUse+",codeFieldId="+codeFieldId+",startCode="+startcodenum+" where modeid="+modeId);
    String[] members = Util.TokenizerString2(postValue,"\u0007");
    for (int i=0;i<members.length;i++){
      String member = members[i];
      String memberAttibutes[] = Util.TokenizerString2(member,"\u001b");
      String detailid = Util.null2String(memberAttibutes[0]); //
      String codeValue = Util.null2String(memberAttibutes[1]);
      if ("[(*_*)]".equals(codeValue)){codeValue="";}
      String fieldname = Util.null2String(memberAttibutes[2]);
      if ("[(*_*)]".equals(fieldname)){fieldname="";}
      String isSerial = Util.null2String(memberAttibutes[3]);
      
      String updateStr = "update ModeCodeDetail set showvalue='"+codeValue+"',codeorder='"+i+"',fieldname='"+fieldname+"',isSerial='"+isSerial+"' where id="+detailid;
      //String insertStr = "insert into ModeCodeDetail (codemainid,showname,showtype,showvalue,codeorder,tablename,fieldname,isSerial) values ("+codemainid+",'"+text+"','"+type+"','"+value+"',"+i+",'"+tablename+"','"+fieldname+"','"+isSerial+"')";   
      rs.executeSql(updateStr);          
    }
    
    response.sendRedirect("ModeCode.jsp?modeId="+modeId);
  }
%>


