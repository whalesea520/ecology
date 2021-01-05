
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util,weaver.conn.*" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cs" class="weaver.conn.ConnStatement" scope="page" />

<%
request.setCharacterEncoding("UTF-8");
//调查id
String votingid = Util.null2String(request.getParameter("votingid"));
//// 问题 question
String subject = "";//标题
String ismulti = "";// 选择题 类型 0 radio 1checkbox 2select
String isother = ""; // 是否其他输入
String questioncount = "";//问题数
String ismultino = "";//是否其他
String showorder = "";//排序顺序
String pagenum = "";//所属页
String questiontype = "";//问题类型 0 选择题 1组合选 2 说明  3 填空
String description = "";//描述
String ismustinput = "";//是否必须输入
String limit  = "";//最少多少项
String max = "";//最多选择多少项
String perrowcols = "";//每列显示多少个
String israndomsort = "";//是否随机排序

///// 选项 option
String descr = "";//选项描述
String optioncount = "";//选项数
String oshoworder = "";//排序
String roworcolumn = "";//0 行标签, 1 列标签

String sql = "";


//获取 总页数
int pagecount = Util.getIntValue(request.getParameter("pagecount"),0);
//所在页的问题数
int qcount = 0;
//问题的选项数
int ocount = 0;
//问题的id
int qid = 0;
//System.out.println("=================votingid"+votingid);
   if(!"".equals(votingid) && votingid != null){
	   
	   //更新标题数据
	  // RecordSet.executeSql("update voting set subject='"+Util.null2String(request.getParameter("surveysubject"))+"' where id="+votingid);
	   
	   //先将已存储的内容全部删除
	//   RecordSet.executeSql("delete from votingquestion where votingid="+votingid);
	//   RecordSet.executeSql("delete from votingoption where votingid="+votingid);
	   
	   //保存外观设置
	   RecordSet.executeSql("delete from votingviewset where votingid="+votingid);
	   sql = "insert into votingviewset (votingid,viewjson) values(?,?)";
	   cs.setStatementSql(sql);
	   cs.setInt(1, Util.getIntValue(votingid,0));
	   cs.setString(2,Util.null2String(request.getParameter("designerset")));
	   //System.out.println(Util.null2String(request.getParameter("designerset")));
	   cs.executeUpdate();
	   cs.close();
	   out.print("{\"success\":\"1\"}");
	   return;
   }
   
   out.print("{\"success\":\"0\"}");

%>

