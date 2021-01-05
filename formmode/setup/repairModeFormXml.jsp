
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="java.io.Writer" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ModeSetUtil" class="weaver.formmode.setup.ModeSetUtil" scope="page" />
<%
  User user = HrmUserVarify.getUser (request , response) ;
  if(user == null)  return ;
  String src = Util.null2String(request.getParameter("src"));
  response.reset();
  out.clear();
  if(src.equalsIgnoreCase("addFieldToDB"))
  {
	  try{
		  int fieldid = Util.getIntValue(request.getParameter("fieldid"));
		  RecordSet.executeSql("select * from workflow_billfield where id=" + fieldid);
		  if(RecordSet.next()){
			  String tablename = "";
			  String fieldname = RecordSet.getString("fieldname");
			  String billid = RecordSet.getString("billid");
			  String fielddbtype = RecordSet.getString("fielddbtype");
			  String viewtype = RecordSet.getString("viewtype");
			  String fieldhtmltype = RecordSet.getString("fieldhtmltype");
			  if(viewtype.equals("0")){
				  RecordSet.executeSql("select * from workflow_bill where id=" + billid);
				  if(RecordSet.next()){
					  tablename = RecordSet.getString("tablename");
				  }
			  }else{
				  tablename = RecordSet.getString("detailtable");
			  }
			  if(fieldhtmltype.equals("3")){
			  	boolean isoracle = (RecordSet.getDBType()).equals("oracle") ;
			  	if(isoracle){
			  		fielddbtype = "varchar2(2000)";
			  	}else{
			  		fielddbtype = "varchar(2000)";
			  	}
			  }
			  RecordSet.executeSql("alter table "+tablename+" add "+fieldname+" "+fielddbtype);
		  }
		  out.print("success");
	  }catch(Exception e){
		  e.printStackTrace();
		  out.print("error");
	  }
	 return;
  }else if(src.equalsIgnoreCase("testModeForm")){
	  try{
		  int formId = Util.getIntValue(request.getParameter("formId"));
		  boolean flag = ModeSetUtil.checkModeForm(formId);
		  if(flag){
			  out.print("0");
		  }else{
			  out.print("1");
		  }
	  }catch(Exception e){
		  e.printStackTrace();
		  out.print("error");
	  }
  }
%>