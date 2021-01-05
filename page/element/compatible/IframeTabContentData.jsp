
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ include file="/page/element/loginViewCommon.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="sci" class="weaver.system.SystemComInfo" scope="page" />
<%@page import="weaver.page.style.ElementStyleCominfo"%>
<%@ page import="java.lang.reflect.Constructor" %>
<%@ page import="java.lang.reflect.Method" %>
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
		valuecolumnList
		isLimitLengthList

		样式信息
		----------------------------------------
		String esc.getIconEsymbol(pc.getStyleid(eid)) 列首图标
		class='sparator' 行分隔线 
	*/
String tabId = Util.null2String(request.getParameter("tabId"));

 String tabSql="select tabId,tabTitle,sqlWhere from hpNewsTabInfo where eid=? and tabId=?";

  // rs.execute(tabSql);
  rs.executeQuery(tabSql,eid,tabId); 
  
   if(rs.next()){
	  strsqlwhere = rs.getString("sqlWhere");
  }
if("".equals(strsqlwhere)) return;

//更新当前tab信息
String updateSql = "";
if(loginuser != null){
	
	updateSql = "update  hpcurrenttab set currenttab =? where eid=? and userid=? and usertype=?";
		
	rs.executeUpdate(updateSql,tabId,eid,loginuser.getUID(),loginuser.getType());
}


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
if(strAddr.indexOf("~")!=-1)
	strAddr = strAddr.replaceAll("~", "&");
%>
<iframe id="ifrm_<%=eid%>" name="ifrm_<%=eid%>" BORDER=0 FRAMEBORDER="no" NORESIZE=NORESIZE  scrolling="auto"
width="100%" height="<%=strHeight%>"  scrolling="NO" src="<%=strAddr%>"></iframe>






