
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/web/inc/init1.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocNewsManager" class="weaver.docs.news.DocNewsManager" scope="page" />
<jsp:useBean id="DocNewsComInfo" class="weaver.docs.news.DocNewsComInfo" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />

<%
String key=Util.null2String(request.getParameter("key"));
String bgcolor=Util.null2String(request.getParameter("bgcolor"));
String index=""+Util.getIntValue(request.getParameter("index"),0);
String hot=""+Util.getIntValue(request.getParameter("hot"),0);
String isTime=""+Util.getIntValue(request.getParameter("isTime"),0);
String isPageNo=""+Util.getIntValue(request.getParameter("isPageNo"),0);
String isImage = "" + Util.getIntValue(request.getParameter("isImage"),0);
String onlyImage = "" + Util.getIntValue(request.getParameter("onlyImage"),0);
if (bgcolor.equals("")) bgcolor = "FFFFFF" ;
%>
<HTML><HEAD>
<META http-equiv=Content-Type content="text/html; charset=UTF-8">
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/web/css/style_wev8.css" type=text/css rel=STYLESHEET>
</head>
<BODY bgcolor="<%=bgcolor%>">
<%
String url = "" ;
String sqlstr = "" ;
String newsId = "" ;
String type = "" ; 
String researchId = "" ;
if(hot.equals("1"))
{	
	ArrayList keyArray = Util.TokenizerString(key,"|");
	for(int i=0;i<keyArray.size();i++){
		sqlstr = "select * from webSite where linkKey = '" + (String)keyArray.get(i) + "'";
		RecordSet.executeSql(sqlstr);
		if (RecordSet.next()) newsId += Util.getIntValue(RecordSet.getString("newsId"),0) + "|" ;
	}
	if(!newsId.equals("")) 
	{
		newsId = newsId.substring(0,newsId.length()-1);
		url = "WebListDspHot.jsp?newsId=" + newsId + "&isTime=" + isTime + "&bgcolor=" + bgcolor + "&isPageNo=" + isPageNo ;
		response.sendRedirect(url) ;
	}else{
		out.print(Util.toScreen("该模块正在建设中！",7,"0"));
	}
}else{
	sqlstr = "select * from webSite where linkKey = '" + key + "'";
	RecordSet.executeSql(sqlstr);
	if (RecordSet.next())
	{
		type = Util.null2String(RecordSet.getString("type"));
		newsId = Util.null2String(RecordSet.getString("newsId"));
		researchId = Util.null2String(RecordSet.getString("researchId"));
		if(type.equals("1")) //单文档
			{
				int publishtype = 0;
				String docid = "0" ;			
				String newsclause = "";
				String whereOrAnd = "" ;
				String newslistclause = "" ;
				DocNewsManager.resetParameter();
				DocNewsManager.setId(Util.getIntValue(newsId,0));
				DocNewsManager.getDocNewsInfoById();
				publishtype = DocNewsManager.getPublishtype();
				newsclause = DocNewsManager.getNewsclause();
				DocNewsManager.closeStatement();			
				if (publishtype ==0 ) whereOrAnd =" where " ; //0为发布类型为外部的不需要判断权限
				else whereOrAnd =" and " ;
				newslistclause=newsclause.trim();					
				if(!newslistclause.equals(""))  newslistclause = whereOrAnd + newslistclause ;
				newslistclause = newslistclause + " and docpublishtype='2' and docstatus in('1','2') order by id ";			
				if (publishtype ==0 )//0为发布类型为外部的不需要判断权限
				{
					DocManager.setSql_where(newslistclause);
					DocManager.selectDocInfo();
				}
				else 
				{
					DocManager.selectNewsDocInfo(newslistclause,user);
				}
				if(DocManager.next()) docid = ""+DocManager.getDocid();
				DocManager.closeStatement();
				url = "WebDetailDsp.jsp?id=" + docid + "&simple=y&bgcolor=" + bgcolor ;
			}
			else if(type.equals("2")) //列表显示
				{
					if (index.equals("1"))
						url = "WebListDspForIndex.jsp?id=" + newsId + "&isTime=" + isTime + "&bgcolor=" + bgcolor + "&isImage=" + isImage + "&onlyImage=" + onlyImage;
					else
						url = "WebListDsp.jsp?id=" + newsId + "&isTime=" + isTime + "&bgcolor=" + bgcolor + "&isPageNo=" + isPageNo ;
				}
				else if(type.equals("3")) //摘要显示
					{
						url = "WebDsp.jsp?id=" + newsId + "&isTime=" + isTime + "&bgcolor=" + bgcolor + "&isPageNo=" + isPageNo ;
					}
					else if(type.equals("4")) //论坛显示
						{
							url = "WebBBS.jsp?id=" + newsId + "&bgcolor=" + bgcolor ;
						}
						else if(type.equals("5")) //电子刊物显示
							{
								url = "WebJournalDsp.jsp?id=" + newsId + "&isTime=" + isTime + "&bgcolor=" + bgcolor ;
							}
							else if(type.equals("6")) //工作流
								{
									url = "/web/workflow/request/AddRequest.jsp?workflowid=" + newsId + "&bgcolor=" + bgcolor ;
								}
								else if(type.equals("7")) //调查
								{
									url = "/web/research/research.jsp?inprepId="+newsId+"&inputId=" + researchId + "&bgcolor=" + bgcolor ;
								}
									else if(type.equals("8")) //列表显示二
									{
										url = "WebListDspSecond.jsp?id=" + newsId + "&isTime=" + isTime + "&bgcolor=" + bgcolor + "&isPageNo=" + isPageNo ;
									}
		response.sendRedirect(url) ;
	}
	else
	{
		out.print(Util.toScreen("该模块正在建设中！",7,"0"));
	}
}
%>
</BODY>

