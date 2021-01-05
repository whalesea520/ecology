<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>

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
<%
//获取参数及设置基本变量
String id = Util.null2String(request.getParameter("id"));
int start= Util.getIntValue(request.getParameter("start"),1);
int hstart = Util.getIntValue(request.getParameter("hstart"),1);
String isTime = "" + Util.getIntValue(request.getParameter("isTime"),0);
String isImage = "" + Util.getIntValue(request.getParameter("isImage"),0);
String onlyImage = "" + Util.getIntValue(request.getParameter("onlyImage"),0);
int recordersize = 0;
int perpage=Util.getIntValue(request.getParameter("perpage"),0);
int subjectMaxLength = 1000;
String linkstr="";
String usertype = "" ;

String frontpagename = "" ;
String frontpagedesc = "" ;
String isactive = "" ;
int departmentid = 0 ;
String linktype = "" ;
String hasdocsubject = "" ;
String hasfrontpagelist = "" ;
int newsperpage = 0 ;
int titlesperpage = 0 ;
int defnewspicid = 0 ;
int backgroundpicid = 0 ;
int importdocid = 0 ;
int headerdocid = 0 ;
int footerdocid = 0 ;
String secopt = "" ;
int seclevelopt = 0;
int departmentopt = 0;
int dateopt = 0;
int languageopt = 0 ;
int languageid = 7 ;
String clauseopt = "" ;
String newsclause = "" ;
int defaultimgid= 0 ;
int defaultimgwidth=0;
int publishtype = 0;
//获取新闻页基本信息

ArrayList newsIdSArray = Util.TokenizerString(id,"|");
String sqlstr = "";
int newsId = 0 ;
for(int i=0;i<newsIdSArray.size();i++){
	newsId =  Util.getIntValue((String)newsIdSArray.get(i),0) ;
	if(newsId>0){
		DocNewsManager.resetParameter();
		DocNewsManager.setId(newsId);
		DocNewsManager.getDocNewsInfoById();
		publishtype = DocNewsManager.getPublishtype();
		newsperpage = DocNewsManager.getNewsperpage();
		importdocid =  Util.getIntValue(DocNewsManager.getImportdocid());
		languageid = DocNewsManager.getLanguageid();
		newsclause += " (" + DocNewsManager.getNewsclause() + ") or";
		DocNewsManager.closeStatement();
		if(perpage==0)
			perpage = newsperpage; 
	}
}
if(!newsclause.equals("")) 
{
	newsclause = newsclause.substring(0,newsclause.length()-2);
	newsclause = "(" + newsclause + ")" ; 
}



int needtr = 0;
int currec = 0;
String whereOrAnd = "" ;
//if (publishtype ==0 ) whereOrAnd =" where " ; //0为发布类型为外部的不需要判断权限
whereOrAnd =" and " ;
String newslistclause=newsclause.trim();					
if(!newslistclause.equals(""))  newslistclause = whereOrAnd + newslistclause ;
newslistclause = newslistclause + " and docpublishtype='2' and docstatus in('1','2') order by doclastmoddate desc, doclastmodtime desc";

String bgcolor = Util.null2String(request.getParameter("bgcolor"));
if (bgcolor.equals("")) bgcolor = "FFFFFF" ;
%>
<HTML>
<HEAD>
<META http-equiv=Content-Type content="text/html; charset=UTF-8">
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<script language=javascript>
function window.onload()
{
	document.body.style.scrollbarFaceColor="<%=bgcolor%>";
	document.body.style.scrollbarHighlightColor="<%=bgcolor%>";
	document.body.style.scrollbarShadowColor="<%=bgcolor%>";
	document.body.style.scrollbar3dLightColor="<%=bgcolor%>";
	document.body.style.scrollbarTrackColor="<%=bgcolor%>";
	document.body.style.scrollbarDarkShadowColor="<%=bgcolor%>";
	document.body.style.scrollbarArrowColor="000000";
}
</script>
<BODY bgcolor="<%=bgcolor%>">
<FORM id=form1 name=form1  method="post"  action="/web/WebListDsp.jsp?id=<%=id%>">
  <TABLE class=form valign=top>
    <TBODY> 
    <tr> 
	<td valign="top">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" valign=top>
          <tr>
			<%if(!onlyImage.equals("1")){%>
            <td width="100%" valign=top> 
				  <!--主题新闻显示:begin-->
				  <!--marquee align='center' scrollamount='1' scrolldelay='10' behavior='loop' direction='up' border='0' onmouseover='this.stop()' onmouseout='this.start()'-->
				  <table class=form valign=top>
					
						  <!--根据条件设置自动提取地主题新闻显示:begin-->
						  <%
							if (publishtype ==0 )//0为发布类型为外部的不需要判断权限
							{
								DocManager.setSql_where(newslistclause);
								DocManager.selectDocInfo();
							}
							else 
							{
								DocManager.selectNewsDocInfo(newslistclause,user);
							}
							
							while(DocManager.next()){
								int docid = DocManager.getDocid();
								if(docid == importdocid) continue;
								recordersize += 1;
								currec +=1;
								if(currec < start) continue;
								if(currec >= start + perpage) continue;
								needtr +=1;
								
								String docsubject=DocManager.getDocsubject();
								String doccontent=DocManager.getDoccontent();
								String doclastmoddate=DocManager.getDoclastmoddate();
								if (docsubject.length()>subjectMaxLength)
								docsubject = docsubject.substring(0,subjectMaxLength)+"...";
						%>
						<tr> 
						  <td width=3% valign="top"><img src="/web/images/i_wev8.gif" align="absmiddle"></td>
						  <td width=75% valign=top > 
							<a href="<%=webServer%>/web/WebDetailDsp.jsp?newsid=<%=id%>&id=<%=docid%>&languageid=<%=languageid%>" target="_blank"><%=docsubject%></a>&nbsp;&nbsp;
						  <%if(isTime.equals("1")){%>
						  [<%=doclastmoddate%>]
						  <%}%>
						   </td>
						  </tr>
						<%
							}
							DocManager.closeStatement();
						%>
						  <!--根据条件设置自动提取地主题新闻显示:end-->

					
				  </table>
				  <!--/marquee-->
				  <!--主题新闻显示:end-->
            </td>
			<%
			}	
				if(isImage.equals("1")||onlyImage.equals("1")){
				if (publishtype ==0 )//0为发布类型为外部的不需要判断权限
				{
					DocManager.setSql_where(newslistclause);
					DocManager.selectDocInfo();
				}
				else 
				{
					DocManager.selectNewsDocInfo(newslistclause,user);
				}
				String docidStr = "" ;
				while(DocManager.next()){
					docidStr += DocManager.getDocid() + ",";
				}
				String sqlTemp = "" ;
				String imageidTemp = "" ;
				String docidTemp = "" ;
				String doccontentTemp = "" ;
				if(!docidStr.equals("")){
					docidStr = docidStr.substring(0,docidStr.length()-1);
					sqlTemp = "select top 1 imagefileid,docid from DocImageFile where docid in (" + docidStr + ") order by docid desc";
					RecordSet.executeSql(sqlTemp);
					if(RecordSet.next()){
						docidTemp = RecordSet.getString("docid");
						imageidTemp = RecordSet.getString("imagefileid");
						if(onlyImage.equals("1")){
							sqlTemp = "select doccontent from DocDetail where id = " + docidTemp;
							RecordSet.executeSql(sqlTemp);
							if(RecordSet.next())
								doccontentTemp = RecordSet.getString("doccontent");
							int tmppos = doccontentTemp.indexOf("!@#$%^&*");
							if(tmppos!=-1){
								doccontentTemp = doccontentTemp.substring(0,tmppos);
							}
			%>
			<td align="left" valign="top" width="60%"><%=doccontentTemp%></td>
			<%}%>
			<td align="left" valign="top">
				<a href="<%=webServer%>/web/WebDetailDsp.jsp?newsid=<%=id%>&id=<%=docidTemp%>&languageid=<%=languageid%>" target="_blank">
				<IMG src="/weaver/weaver.file.FileDownload?fileid=<%=imageidTemp%>" cellPadding=0 height="120" width="180" border="1">
				</a>
			</td>
			<%
					}
				}
				DocManager.closeStatement();
			}%>
          </tr>
          
        </table>
      </td>
    </tbody> 
  </table>

</FORM>
</body>