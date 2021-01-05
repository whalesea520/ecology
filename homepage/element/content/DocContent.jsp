
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.conn.ConnStatement"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="oracle.sql.CLOB"%> 
<%@ page import="java.io.BufferedReader"%>
<%@ include file="/homepage/element/content/Common.jsp" %>
<jsp:useBean id="oDocManager" class="weaver.docs.docs.DocManager" scope="page"/>
<jsp:useBean id="SpopForDoc" class="weaver.splitepage.operate.SpopForDoc" scope="page"/>
<%
	/*
		基本信息
		--------------------------------------
		hpid:表首页ID
		subCompanyId:首页所属分部的分部ID
		eid:元素ID
		ebaseid:基本元素ID
		styleid:样式ID
		
		条件信息
		--------------------------------------
		strsqlwhere 格式为 条件1^,^条件2...
		perpage  显示页数
		linkmode 查看方式  1:当前页 2:弹出页

		
		字段信息
		--------------------------------------
		fieldIdList
		fieldColumnList
		fieldIsDate
		fieldTransMethodList
		fieldWidthList
		linkurlList
		valuecolumnList
		isLimitLengthList
	*/

%>
<%
String  docid=strsqlwhere;
if("".equals(docid)) return ;

String logintype = user.getLogintype();
String userSeclevel = user.getSeclevel();
String userType = ""+user.getType();
String userdepartment = ""+user.getUserDepartment();
String usersubcomany = ""+user.getUserSubCompany1();
String userInfo=logintype+"_"+user.getUID()+"_"+userSeclevel+"_"+userType+"_"+userdepartment+"_"+usersubcomany;
ArrayList PdocList = SpopForDoc.getDocOpratePopedom(""+docid,userInfo);

boolean canReader=false;
if (((String)PdocList.get(0)).equals("true")) canReader = true ;
if(!canReader) return;

RecordSet rs_DocContent=new RecordSet();

String docContent="";
String strSql_DocContent="";

if(("oracle").equals(rs_DocContent.getDBType())){
	ConnStatement statement = null;
	try{
		statement=new ConnStatement();
		docid=oDocManager.getNewDocid(docid);
		strSql_DocContent="select doccontent from docdetail d1,docdetailcontent d2 where d1.id=d2.docid and d1.id="+docid;
		statement.setStatementSql(strSql_DocContent, false);
	    statement.executeQuery();
		if(statement.next()) {
		 CLOB theclob = statement.getClob("doccontent");
		  String readline = "";
	      StringBuffer clobStrBuff = new StringBuffer("");
	      BufferedReader clobin = new BufferedReader(theclob.getCharacterStream());
	      while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline);
	      clobin.close() ;
	      docContent = clobStrBuff.toString();
		}	
		
	}catch(Exception e){
	}finally {
		statement.close();
	}
} else{
	docContent=oDocManager.getNewDocid(docid,true);
}

if(!"".equals(docContent)){
	String disptmp = "";
	int tmppos = docContent.indexOf("!@#$%^&*");
	if(tmppos!=-1)	{
		docContent = docContent.substring(tmppos+8);
	}
	out.println(docContent);
}

%>