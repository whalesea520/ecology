<%@ page import="weaver.general.*" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
</head>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(129326 ,user.getLanguage());//"数据展现集成";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

String sqlwhere = "where 1=1 ";

int userid=user.getUID();
String backfields=" * " ;
String perpage="10";
String PageConstId = "OfsRmindList";
String fromSql=" ( select t2.requestid,t2.requestname,t3.syscode,t2.workflowname,t2.creatorid,t1.usertype,t2.createdate,t2.createtime,t2.receivedate,t2.receivetime,t3.pcprefixurl,t2.pcurl"+
				" from SysPoppupRemindInfoNew t1 "+
				" join ofs_todo_data t2 on t1.userid=t2.userid and t1.requestid=t2.requestid and t1.ifPup=1 and t1.type=26 "+
				" join ofs_sysinfo t3 on t2.sysid=t3.sysid "+
				" where t1.userid="+userid+" ) t1";

//out.print("select "+backfields+"from "+fromSql+" "+sqlwhere);
String tableString="";

tableString =  " <table instanceid=\"ListTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageConstId,user.getUID())+"\" >";
tableString += " <checkboxpopedom    popedompara=\"column:requestid\" />"+
		 " <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"requestid\"  sqlprimarykey=\"requestid\" sqlsortway=\"Desc\" sqlisdistinct=\"false\" />"+
         "       <head>"+
         "           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(1334 ,user.getLanguage())+"\" column=\"requestname\" orderkey=\"requestname\" otherpara=\"column:pcprefixurl+column:pcurl\" transmethod=\"weaver.ofs.util.OfsSplitPageTransmethod.getRequestname\"/>"+
		 "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(22677 ,user.getLanguage())+"\" column=\"syscode\" orderkey=\"syscode\" transmethod=\"weaver.ofs.util.OfsSplitPageTransmethod.getSysname\" />"+
		 "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(16579 ,user.getLanguage())+"\" column=\"workflowname\" orderkey=\"workflowname\" />"+
		 "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(882 ,user.getLanguage())+"\" column=\"creatorid\" otherpara=\"column:usertype\" transmethod=\"weaver.ofs.util.OfsSplitPageTransmethod.getHrmResourceName\" />"+
		 "           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(722 ,user.getLanguage())+"\" column=\"createdate\" orderkey=\"createdate,createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.ofs.util.OfsSplitPageTransmethod.getDateTime\" />"+
		 "           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(17994 ,user.getLanguage())+"\" column=\"receivedate\" orderkey=\"receivedate,receivetime\" otherpara=\"column:receivetime\" transmethod=\"weaver.ofs.util.OfsSplitPageTransmethod.getDateTime\" />" +
         "       </head>"+
         " </table>";

%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="/integration/WsShowEditSetList.jsp" method="post" name="frmmain" id="datalist">
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=SystemEnv.getHtmlLabelName(32301,user.getLanguage())%></span> <!-- 数据展示集成列表 -->
</div>

<TABLE width="100%">
    <tr>
        <td valign="top">  
        	<input type="hidden" name="pageId" id="pageId" value="<%=PageConstId %>"/>
           	<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
        </td>
    </tr>
</TABLE>
</form>
</BODY>
</HTML>
