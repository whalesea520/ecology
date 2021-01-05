
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.lang.reflect.Constructor" %>
<%@ page import="java.lang.reflect.Method" %>
<jsp:useBean id="sci" class="weaver.system.SystemComInfo" scope="page" />

<%@ include file="/homepage/element/content/Common.jsp" %>
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
String tableStr = "";
%>
<%
if("2".equals(sci.getRsstype())){
	try{
		Class tempClass=null;
		Method tempMethod=null;
		Constructor ct=null;
		tempClass = Class.forName("weaver.homepage.HomepageExtShow");	
		tempMethod = tempClass.getMethod("getRssContent", new Class[]{java.util.ArrayList.class,java.util.ArrayList.class,java.util.ArrayList.class,java.util.ArrayList.class,java.util.ArrayList.class,String.class,weaver.homepage.style.HomepageStyleBean.class,String.class,String.class,String.class,weaver.hrm.User.class,
		javax.servlet.http.HttpServletRequest.class,String.class,String.class});
		ct = tempClass.getConstructor(null);
		tableStr=(String)tempMethod.invoke(ct.newInstance(null), new Object[] {fieldIdList,fieldColumnList,fieldIsDate,fieldWidthList,isLimitLengthList,strsqlwhere,hpsb,eid,linkmode,""+perpage,user,request,hpid,""+subCompanyId});
 		
 	}catch(Exception ex){
 		tableStr = "";
 	}
 	%>
 	
 	<TABLE style="color: <%=hpsb.getEcolor()%>"
	id="_contenttable_<%=eid%>" class=Econtent width="100%" >
	         <TR>
	          <TD width=1px></TD>
	           <TD width='*'>
	               <%=tableStr%>
	           </TD>
	           <TD width=1px></TD>
	         </TR>
	</TABLE>
 	<%
 }%>
 <%		
if("1".equals(sci.getRsstype())){
if("^,^1".equals(strsqlwhere)||"^,^2".equals(strsqlwhere)) return ;
String rssUrl =hpes.getRssUrlStr(strsqlwhere,perpage);
if("".equals(rssUrl)) return;

String imgSymbol="";
if (!"".equals(hpsb.getEsymbol())) {
	imgSymbol="<img  src='"+hpsb.getEsymbol()+"'/>";
	imgSymbol=Util.replace(imgSymbol,"\\\\","/",0);
}
int size = fieldIdList.size();
int rssTitleLength=4;
boolean hasTitle=false;
boolean hasDate=false;
boolean hasTime=false;

String titleWidth="0";
String dateWidth="0";
String timeWidth="0";

for (int j = 0; j < size; j++) {
    String fieldId = (String) fieldIdList.get(j);
    String columnName = (String) fieldColumnList.get(j);
    String strIsDate = (String) fieldIsDate.get(j);
    String fieldwidth = (String) fieldWidthList.get(j);
    String isLimitLength = (String) isLimitLengthList.get(j);	
    if ("subject".equals(columnName)) {
        rssTitleLength = hpu.getLimitLength(""+eid, fieldId, "",user,""+hpid,subCompanyId);
		hasTitle=true;
		titleWidth="*";       
    } else if ("createdate".equals(columnName)) {
        hasDate=true;
		dateWidth=fieldwidth;		
    } else if ("createtime".equals(columnName)) {
        hasTime=true;
	    timeWidth=fieldwidth;
    }   
}
//System.out.println(imgSymbol);
%>

"<%=eid%>","<%=rssUrl%>","<%=imgSymbol%>","<%=hasTitle%>","<%=hasDate%>","<%=hasTime%>","<%=titleWidth%>","<%=dateWidth%>","<%=timeWidth%>","<%=rssTitleLength%>","<%=linkmode%>","<%=size%>","<%=perpage%>"
<%} %>
