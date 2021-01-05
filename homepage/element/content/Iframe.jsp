
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/homepage/element/content/Common.jsp" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="java.io.BufferedReader" %>
<jsp:useBean id="dnm" class="weaver.docs.news.DocNewsManager" scope="page"/>
<jsp:useBean id="dm" class="weaver.docs.docs.DocManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="oDocManager" class="weaver.docs.docs.DocManager" scope="page"/>
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
		String strsqlwhere 格式为 条件1^,^条件2...
		int perpage  显示页数
		String linkmode 查看方式  1:当前页 2:弹出页
 
		
		字段信息
		--------------------------------------
		fieldIdList
		fieldColumnList
		fieldIsDate
		fieldTransMethodList
		fieldWidthList
		linkurlList
		strsqlwherecolumnList
		isLimitLengthList

		样式信息
		----------------------------------------
		String hpsb.getEsymbol() 列首图标
		String hpsb.getEsparatorimg()   行分隔线 
	*/

%>
<%
if("".equals(strsqlwhere)) return;

String strAddr="";
String strMore="";
String strWidth="";
String strHeight="";

String flag="^,^";
int pos1=strsqlwhere.indexOf(flag);
int pos2=strsqlwhere.indexOf(flag, pos1+3);
int pos3=strsqlwhere.indexOf(flag, pos2+3);

strAddr=strsqlwhere.substring(0,pos1);
strMore=strsqlwhere.substring(pos1+3,pos2);
strWidth=strsqlwhere.substring(pos2+3,pos3);
strHeight=strsqlwhere.substring(pos3+3);
%>
<iframe id="ifrm_<%=eid%>" name="ifrm_<%=eid%>" BORDER=0 FRAMEBORDER="no" NORESIZE=NORESIZE  scrolling="auto"
width="100%" height="<%=strHeight%>"  scrolling="NO" src="<%=strAddr%>"></iframe>






