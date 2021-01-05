<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/web/inc/init1.jsp" %>
<%@ include file="/web/inc/WebServer.jsp" %>
<jsp:useBean id="DocNewsManager" class="weaver.docs.news.DocNewsManager" scope="page" />
<jsp:useBean id="DocNewsComInfo" class="weaver.docs.news.DocNewsComInfo" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="DocTypeComInfo" class="weaver.docs.type.DocTypeComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="SysDefaultsComInfo" class="weaver.docs.tools.SysDefaultsComInfo" scope="page" />
<jsp:useBean id="PicUploadManager" class="weaver.docs.tools.PicUploadManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetImg" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />


<%
String userName = "";
String usertype = "1" ;
String seclevel = "0" ; 
userName =  user.getUsername() ;
usertype = ""+user.getType() ;
seclevel = ""+user.getSeclevel() ;

String key=Util.null2String(request.getParameter("key"));
String bgcolor=Util.null2String(request.getParameter("bgcolor"));
String isTime=""+Util.getIntValue(request.getParameter("isTime"),0);
String isPageNo=""+Util.getIntValue(request.getParameter("isPageNo"),0);
if (bgcolor.equals("")) bgcolor = "FFFFFF" ;
int newsId = 0; 
String newsIdS = Util.null2String(request.getParameter("newsId"));
ArrayList newsIdSArray = Util.TokenizerString(newsIdS,"|");
String sqlstr = "";
String newsclause = "" ;
for(int i=0;i<newsIdSArray.size();i++){
	newsId =  Util.getIntValue((String)newsIdSArray.get(i),0) ;
	if(newsId>0){
		DocNewsManager.resetParameter();
		DocNewsManager.setId(newsId);
		DocNewsManager.getDocNewsInfoById();
		newsclause += " (" + DocNewsManager.getNewsclause() + ") or";
		DocNewsManager.closeStatement();
	}
}
if(!newsclause.equals("")) 
{
	newsclause = newsclause.substring(0,newsclause.length()-2);
	newsclause = "(" + newsclause + ")" ; 
}
%>
<HTML><HEAD>
<META http-equiv=Content-Type content="text/html; charset=UTF-8">
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<BODY bgcolor="<%=bgcolor%>">
  <TABLE class=form valign=top>
	<TBODY> 
	<tr> 
	<tr>
		<td>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" valign=top>
		  <tr>
			<td width="100%" valign=top> 
				  <table class=form valign=top>
						<%
							String docid= "" ;
							String docsubject= "" ;							
							String doclastmoddate= "" ;
							RecordSet.executeSql("select top 10 t1.id,sum(readCount) readCount  from Docdetail t1, docreadtag t2 where t1.id=t2.docid  and " + newsclause + " group by t1.id order by readCount desc ");
							while(RecordSet.next()){
							docid=RecordSet.getString("id");	
							docsubject=DocComInfo.getDocname(docid);
							RecordSetImg.executeSql("select imagefileid from DocImageFile where docid = " + docid + " and docfiletype = '1' ");
							int curimgid = 0 ;
							if (RecordSetImg.next())
							curimgid = Util.getIntValue(RecordSetImg.getString("imagefileid"),0);
						%>
						<tr> 
						  <td width=5% valign="top"><img src="/web/images/i_wev8.gif" align="absmiddle"></td>
						  <td width=95% valign=top > 
							<a href="<%=webServer%>/web/WebDetailDsp.jsp?newsid=<%=newsId%>&id=<%=docid%>&languageid=<%=language%>" target="_blank"><%=docsubject%></a>
							<%if(curimgid>0){%>&nbsp;&nbsp;[图文]<%}%>
						  </td>
						</tr>
						<%
							}
						%>					
				  </table>
			</td>
		  </tr>
		  
		  </tr>
		  <tr><td>&nbsp</td><td></td></tr>
		</table>
	  </td>
	</tbody> 
  </table>
</body>