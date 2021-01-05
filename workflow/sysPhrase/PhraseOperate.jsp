
<%@page language="java" contentType="text/html; charset=UTF-8" %>

<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.general.Util" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<script>
	jQuery(document).ready(function(){
		parent.getDialog(window).close();
	});
</script>

<%
    User user = HrmUserVarify.getUser(request,response);

	String operation = Util.null2String(request.getParameter("operation"));

	String phraseId = Util.null2String(request.getParameter("phraseId"));
	String phraseShort = Util.null2String(request.getParameter("phraseShort"));
	String phraseDesc = Util.null2String(request.getParameter("phraseDesc"));
    //phraseShort = java.net.URLDecoder.decode(phraseShort,"UTF-8");
	//phraseDesc = java.net.URLDecoder.decode(phraseDesc,"UTF-8");
    phraseDesc= phraseDesc.replace("\r","");//update by liaodong for qc58473 in 20130909
	String userId = ""+user.getUID() ;
	char separator = Util.getSeparator() ;
	String para = "";

	if (operation.equals("add")) {
		phraseShort = phraseShort.replace("'", "''");
		phraseDesc = phraseDesc.replace("'", "''");
		para = userId + separator + phraseShort + separator + phraseDesc ;
		rs.executeSql("insert into sysPhrase (hrmId,phraseShort,phraseDesc) values("+userId+",'"+phraseShort+"','"+phraseDesc+"')");
	} else if (operation.equals("edit")) {
        rs.executeSql("select * from sysPhrase where hrmid="+userId+" and id="+phraseId) ;
        if(rs.next()){
		para = phraseId + separator + userId + separator + phraseShort + separator + phraseDesc ;
		rs.executeProc("sysPhrase_update",para);
        }
	} else if (operation.equals("delete")) {
		String ids = request.getParameter("ids");
		
        rs.executeSql("select id from sysPhrase where hrmid="+userId+" and id in (" + ids + ")") ;
        while(rs.next()){
			rs.executeProc("sysPhrase_deleteById", rs.getString("id"));
        }
	} else if(operation.equals("officaladd")) {
		String pdid = Util.null2String(request.getParameter("pdid"));
		String sortorder = Util.null2String(request.getParameter("sortorder"));
		if("".equals(sortorder))sortorder="0.0";
		String sql = "insert into workflow_processinst(pd_id,sortorder,phraseShort,phraseDesc,isdefault) values("+pdid+","+sortorder+",'"+phraseShort+"','"+phraseDesc+"',0)";
		rs.executeSql(sql);
	} else if(operation.equals("officaledit")) {
		String sortorder = Util.null2String(request.getParameter("sortorder"));
		if("".equals(sortorder))sortorder="0.0";
		String sql = "update workflow_processinst set sortorder="+sortorder+",phraseShort='"+phraseShort+"',phraseDesc='"+phraseDesc+"' where id="+phraseId;
		rs.executeSql(sql);
	}
%>

<script>
	function test() {
        var operation = "<%=operation %>";
        var phraseId = "<%=phraseId %>";
        var phraseShort = "<%=phraseShort %>";
        var phraseDesc = "<%=phraseDesc %>";
    }
</script>

