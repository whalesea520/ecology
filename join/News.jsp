<?xml version="1.0" encoding="UTF-8"?>

<%@ page language="java" contentType="text/xml; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<jsp:useBean id="dnm" class="weaver.docs.news.DocNewsManager" scope="page" />
<jsp:useBean id="sppb" class="weaver.general.SplitPageParaBean" scope="page" />
<jsp:useBean id="spu" class="weaver.general.SplitPageUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cci" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="rc" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="rsIn" class="weaver.conn.RecordSet" scope="page" />
<%
int nid=Util.getIntValue(request.getParameter("nid"),0); //新闻的ID
int npid=Util.getIntValue(request.getParameter("npid"),0); //新闻页的ID

String serverName=Util.null2String(request.getParameter("hostUrl"));
if("".equals(serverName)) serverName=request.getHeader("Host");

String strProtocol=request.getProtocol();
if(strProtocol.startsWith("HTTP")) {
	strProtocol="http";
} else {
	strProtocol="https";
}
if(nid<=0){
	%>
	<rss version="2.0">
		<channel>
			<title><![CDATA[没有指定新闻ID或新闻ID不能为负数]]></title>
			<description><![CDATA[]]></description>
			<language>zh-cn</language>
			<generator><![CDATA[Ecology System]]></generator>		
		</channel>
	</rss>
	<%	return;
}
String strSqlNews="";
int npPublishtype = 0;
dnm.resetParameter();
dnm.setId(npid);
dnm.getDocNewsInfoById();
strSqlNews = dnm.getNewsclause();
npPublishtype = dnm.getPublishtype();
dnm.closeStatement();

if("".equals(strSqlNews)) strSqlNews="1=1";

if (!strSqlNews.equals("")){
	strSqlNews = " and (" + strSqlNews+") ";
} else{
	strSqlNews = " ";
}

strSqlNews =  " (docpublishtype='2' or docpublishtype='3') and docstatus in('1','2') "+strSqlNews;
if ((rs.getDBType()).equals("oracle")) { // oralce
	rs.executeSql("select a.id,a.docpublishtype,a.docsubject,b.doccontent,a.doclastmoddate,a.doclastmodtime,a.doccreaterid, a.usertype from DocDetail a,DocDetailContent b where a.id=b.docid and  "+strSqlNews+" and a.id="+nid);
} else {
	rs.executeSql("select id,docpublishtype,docsubject,doccontent,doclastmoddate,doclastmodtime,doccreaterid,usertype from DocDetail  where "+strSqlNews+" and id="+nid);
}
%>

<%if (rs.next()){
	String tempId=Util.null2String(rs.getString("id"));	
	String docsubject=Util.null2String(rs.getString("docsubject"));	
	String doclastmoddate=Util.null2String(rs.getString("doclastmoddate"));	
	String doclastmodtime=Util.null2String(rs.getString("doclastmodtime"));	
	String doccreaterid=Util.null2String(rs.getString("doccreaterid"));	
	String usertype=Util.null2String(rs.getString("usertype"));	
	String doccontent=Util.null2String(rs.getString("doccontent"));	
	int docpublishtype=Util.getIntValue(rs.getString("docpublishtype"));	
	

if(docpublishtype==1&&(dnm.getPublishtype()!=0||npid==0||npPublishtype!=0)){ //只能查看到新闻文档的文件
	%>
	<rss version="2.0">
		<channel>
			<title><![CDATA[此文档不是新闻，你不能从此接口查看]]></title>
			<description><![CDATA[]]></description>
			<language>zh-cn</language>
			<generator><![CDATA[Ecology System]]></generator>		
		</channel>
	</rss>
	<%	return;
}

	
	
	String desc="";
	String content="";
	int tmppos = doccontent.indexOf("!@#$%^&*");
	String imgs="";
	if (tmppos != -1) {
		desc = doccontent.substring(0, tmppos);
		content=doccontent.substring(tmppos+8);
		
		String regStr= "/weaver/weaver.file.FileDownload\\?fileid=";
		String resultStr=strProtocol+"://"+serverName+"/weaver/weaver.homepage.HomepageCreateImage?fileid=";

		
		ArrayList imglist=Util.matchAll(doccontent,"/weaver/weaver.file.FileDownload\\?fileid=([0-9]+)",1,-1);
		for(int i=0;i<imglist.size();i++){
			String imgid=(String)imglist.get(i);
			imgs+=resultStr+imgid+",";
		}

		content=Util.replace(content,regStr,resultStr,0,false);
	}else if(docpublishtype == 3||docpublishtype == 2){
		content=doccontent;
	}

	

	String username="";
	if ("2".equals(usertype)) { //外部
		username =  cci.getCustomerInfoname(doccreaterid) ;
	} else { //内部
		username =  rc.getResourcename(doccreaterid) ;
	}
	String link=strProtocol+"://"+serverName+"/join/News.jsp?nid="+tempId;
	
	
	//得到此文档下所带的附件IDs
	String accs="";	
	rsIn.executeSql("select imagefileid from docimagefile where docid="+tempId);
	String strAccUrl=strProtocol+"://"+serverName+"/weaver/weaver.file.FileDownload?fileid=";
	while (rsIn.next()){
		String imagefileid=Util.null2String(rsIn.getString("imagefileid"));
		
		accs+=strAccUrl+imagefileid+",";		
	}
	if(!"".equals(accs)) accs=accs.substring(0,accs.length());
%>

<rss version="2.0">	
<channel>
	<title><![CDATA[]]></title>
	<description><![CDATA[]]></description>
	<language>zh-cn</language>
	<generator><![CDATA[Ecology System]]></generator>		
</channel>
	<item>
		<newsid><%=tempId%></newsid>
		<title><![CDATA[<%=docsubject%>]]></title>
		<link><![CDATA[<%=link%>]]></link>
		<pubDate><![CDATA[<%=doclastmoddate%> <%=doclastmodtime%>]]></pubDate>
		<description><![CDATA[<%=desc%>]]></description>
		<content><![CDATA[<%=content%>]]></content>
		<author><![CDATA[<%=username%>]]></author>
		<imgs><![CDATA[<%=imgs%>]]></imgs>
		<accs><![CDATA[<%=accs%>]]></accs>
	</item>
	</rss>
<%} else {%>
<rss version="2.0">	
<channel>
	<title><![CDATA[文档不存在或查询文档出错]]></title>
	<description><![CDATA[]]></description>
	<language>zh-cn</language>
	<generator><![CDATA[Ecology System]]></generator>		
</channel>
</rss>
<%}%>
