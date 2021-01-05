<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />

<%
int formid = Util.getIntValue(request.getParameter("formid"),0) ;
String src = Util.null2String(request.getParameter("src")) ;	
String isview = Util.null2String(request.getParameter("isview")) ;	
int errorcode=Util.getIntValue(Util.null2String(request.getParameter("errorcode")),0);

String sql = "";

if(src.equals("editform")){
    sql = "select count(formid) from workflow_formprop where formid = "+formid;

    rs1.executeSql(sql);
    if(rs1.next() && rs1.getInt(1) == 0 ){
	
		sql = "select t1.fieldid,0 as isdetail,t2.fieldhtmltype from workflow_formfield t1,workflow_formdict t2 where t1.formid = "+formid+" and t1.fieldid = t2.id ";
		sql+=" union ";
		sql += "select t1.fieldid,1 as isdetail,t2.fieldhtmltype from workflow_formfield t1,workflow_formdictdetail t2 where t1.formid = "+formid+" and t1.fieldid = t2.id ";
		
		int objid=1;
		rs.executeSql(sql);
		while(rs.next()){
			String _fieldid = rs.getString("fieldid");
			String _isdetail = rs.getString("isdetail");
			int _objtype = rs.getInt("fieldhtmltype");
			
			if(_objtype==1)	_objtype=3;
			else if(_objtype==2)	_objtype=4;
			else if(_objtype==3)	_objtype=9;
			else if(_objtype==4)	_objtype=6;
			else if(_objtype==5)	_objtype=5;
			
			sql = "insert into workflow_formprop(formid,objid,objtype,fieldid,isdetail,ptx,pty,width,height,defvalue) values("+formid+","+objid+","+_objtype+","+_fieldid+","+_isdetail+","+30+","+(30*objid)+","+240+","+30+",'')";
			rs2.executeSql(sql);
			
			objid++;
		}
	}
}
%>
<HTML>
<frameset cols="200,*" frameborder="no" border="0" framespacing="0" id=MainBottom> 
    <frame name="leftFrame" scrolling="no" src="FormDesignLeft.jsp?src=<%=src%>&formid=<%=formid%>&isview=<%=isview%>&errorcode=<%=errorcode%>"  target="mainFrame">
    <frame name="mainFrame" src="FormDesign.jsp?src=<%=src%>&formid=<%=formid%>">
</frameset>    

</html>