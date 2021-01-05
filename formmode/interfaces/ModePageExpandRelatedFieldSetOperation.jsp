
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;
String sql = "";

int modeid = Util.getIntValue(request.getParameter("modeid"),0);
int id = Util.getIntValue(request.getParameter("id"),0);
int pageexpandid = Util.getIntValue(request.getParameter("pageexpandid"),0);
int hrefid = Util.getIntValue(request.getParameter("hrefid"),0);
int hreftype = Util.getIntValue(request.getParameter("hreftype"),0);

//先删除数据再重新保存
if (operation.equals("save")) {
	String hreffieldnames[] = request.getParameterValues("hreffieldname");
	String modefieldnames[] = request.getParameterValues("modefieldname");
	if(id>0){
		sql = "update mode_pagerelatefield set modeid = " + modeid + ",hrefid="+hrefid+",hreftype="+hreftype+",pageexpandid="+pageexpandid+" where id = " + id;
		
		rs.executeSql(sql);
	}else{
		sql = "insert into mode_pagerelatefield(modeid,hreftype,hrefid,pageexpandid) values("+modeid+","+hreftype+","+hrefid+","+pageexpandid+")";
		rs.executeSql(sql);
		
		sql = "select id from mode_pagerelatefield where modeid="+modeid+" and hrefid="+hrefid+" and hreftype="+hreftype+" and pageexpandid="+pageexpandid;
		rs.executeSql(sql);
		while(rs.next()){
			id = rs.getInt("id");
		}
	}
	
	sql = "delete from mode_pagerelatefielddetail where mainid = " + id;
	rs.executeSql(sql);
	
	if(hreffieldnames!=null&&modefieldnames!=null){
		for(int i=0;i<modefieldnames.length;i++){
			String hreffieldname = Util.null2String(hreffieldnames[i]);
			String modefieldname = Util.null2String(modefieldnames[i]);

			if(!modefieldname.equals("")&&!hreffieldname.equals("")){
				sql = "insert into mode_pagerelatefielddetail(mainid,modefieldname,hreffieldname) values ("+id+",'"+modefieldname+"','"+hreffieldname+"')";
				rs.executeSql(sql);
			}
		}
	}
	
%>
	<script type="text/javascript">
	<!--
	parent.doClose();
	//-->
	</script>
<%
	
	//response.sendRedirect("/formmode/interfaces/ModePageExpandRelatedFieldSet.jsp?modeid="+modeid+"&hrefid="+hrefid+"&hreftype="+hreftype+"&id="+id);
}else if (operation.equals("del")) {
    //删除主表数据
	sql = "delete from mode_pagerelatefield where id = " + id;
	rs.executeSql(sql);

	//删除明细表数据
	sql = "delete from mode_pagerelatefielddetail where mainid = " + id;
	rs.executeSql(sql);
%>
	<script type="text/javascript">
	<!--
	parent.doClose();
	//-->
	</script>
<%	
}

%>