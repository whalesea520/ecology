
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.*" %>
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DocNewsManager" class="weaver.docs.news.DocNewsManager" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<META http-equiv=Content-Type content="text/html; charset=UTF-8">
</head>
<%
int docid = Util.getIntValue(request.getParameter("id"),0);
int languageid = Util.getIntValue(request.getParameter("languageid"),7);
int newsid = Util.getIntValue(request.getParameter("newsid"),0);

if(newsid==0){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
//需要做文档权限判断
String newslistclause=(String)session.getValue("newslistclause");
DocNewsManager.resetParameter();
DocNewsManager.setId(newsid);
DocNewsManager.getDocNewsInfoById();
newslistclause = DocNewsManager.getNewsclause();
if(!"".equals(newslistclause.trim())){
	newslistclause =" and "+newslistclause;
}
newslistclause = newslistclause + " and docpublishtype in('2','3') and docstatus in('1','2','5') ";

String strVerifySql="select id from docdetail where id="+docid+" "+newslistclause;

RecordSet.executeSql(strVerifySql);
if(!RecordSet.next()){
	//out.println("对不起,您无权访问此新闻!");
	response.sendRedirect("/notice/noright.jsp");
	return;
}



//根据文档id初始化文档信息
DocManager.resetParameter();
DocManager.setId(docid);
DocManager.getDocInfoById();

//获取文档标题docsubject
String docsubject=DocManager.getDocsubject();
//获取文档内容doccontent
String doccontent=DocManager.getDoccontent();
doccontent = Util.replace(doccontent, "<script>initFlashVideo();</script>", "", 0);
int tmp_int = doccontent.indexOf("<script>initFlashVideo();</script>");
while(tmp_int > -1){
	doccontent = doccontent.substring(0, tmp_int) + doccontent.substring(tmp_int+34, doccontent.length());
	tmp_int = doccontent.indexOf("<script>initFlashVideo();</script>");
}
//获取文档创建日期doclastmoddate
String doccreatedate=DocManager.getDoccreatedate();
//获取文档最新修改日期doclastmoddate
String doclastmoddate=DocManager.getDoclastmoddate();

//处理文档内容doccontent
int tmppos = doccontent.indexOf("!@#$%^&*");
if(tmppos!=-1)	doccontent = doccontent.substring(tmppos+8,doccontent.length());
%>

<BODY bgcolor=#e7e7e7>

<TABLE  width=80% align=center>
<TBODY>

<tr><td colspan=2>&nbsp;</td></tr>

<!--显示文档标题docsubject及文档最新修改日期doclastmoddate-->
<tr><td align=center colspan=2><b><%=docsubject%></b><hr><%=doclastmoddate%></td></tr>

<!--显示文档文档内容doccontent-->
<tr><td colspan=2><br><%=doccontent%></td></tr>

<tr><td colspan=2>&nbsp;</td></tr>

<!--获取并显示文档文档附件:begin-->
	<%
	int i= 0;
	DocImageManager.resetParameter();
	DocImageManager.setDocid(docid);
	DocImageManager.selectDocImageInfo();
	while(DocImageManager.next()){
		String curimgid = DocImageManager.getImagefileid();
		String curimgname = DocImageManager.getImagefilename();
		i++;
		String curlabel = SystemEnv.getHtmlLabelName(156,languageid)+i;
	%>
<tr>
	<td class=field width=5%><%=curlabel%>:&nbsp&nbsp</td>
	<td class=field valign=top>
	<a href="/weaver/weaver.file.FileDownload?fileid=<%=curimgid%>"><%=curimgname%></a>&nbsp;
	<input type=hidden name=accessory<%=i%> value="<%=curimgid%>">
	<BUTTON class=btn accessKey=<%=i%> onclick="location='/weaver/weaver.file.FileDownload?fileid=<%=curimgid%>&download=1'"><U><%=i%></U>-<%=SystemEnv.getHtmlLabelName(258,languageid)%></BUTTON>
	</td>
</tr>
	<%}%>
<!--获取并显示文档文档附件:end-->

<tr><td align=right colspan=2><br><a href='#' onclick=javascript:history.back()>--BACK--</a>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td></tr>
</tbody>
</table>
</body>

