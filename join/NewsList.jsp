<?xml version="1.0" encoding="UTF-8"?>

<%@ page language="java" contentType="text/xml; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<jsp:useBean id="dnm" class="weaver.docs.news.DocNewsManager" scope="page" />
<jsp:useBean id="sppb" class="weaver.general.SplitPageParaBean" scope="page" />
<jsp:useBean id="spu" class="weaver.general.SplitPageUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsIn" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cci" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="rc" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<%
int npid=Util.getIntValue(request.getParameter("npid"),0); //表示新闻页的ID
int ni=Util.getIntValue(request.getParameter("ni"),0);  //:表示是否是仅得到新闻页信息  0:不是 1:是
int ps=Util.getIntValue(request.getParameter("ps"),5);  //:表示返回的条数
int pi=Util.getIntValue(request.getParameter("pi"),1);  //表示返回的当前页数
int st=Util.getIntValue(request.getParameter("st"),1);  //:表示排序类型  0:升序 1:降序
String serverName=Util.null2String(request.getParameter("hostUrl"));
//String serverName=request.getHeader("Host");

//int cd=Util.getIntValue(request.getParameter("cd"),0);  //:表示是否只返回当日数据 0:不是 1:是

String strProtocol=request.getProtocol();
if(strProtocol.startsWith("HTTP")) {
	strProtocol="http";
} else {
	strProtocol="https";
}

if(npid<=0){
	%>
	
	<rss version="2.0">
		<channel>
			<title><![CDATA[没有指定新闻页或新闻页不能为负数]]></title>
			<description><![CDATA[]]></description>
			<language>zh-cn</language>
			<generator><![CDATA[Ecology System]]></generator>		
		</channel>
	</rss>
	<%	return;
}
dnm.resetParameter();
dnm.setId(npid);
dnm.getDocNewsInfoById();
String newsclause = dnm.getNewsclause();
String frontpagename = dnm.getFrontpagename();
String frontpagedesc = dnm.getFrontpagedesc();
int publishtype=dnm.getPublishtype();
dnm.closeStatement();

newsclause = newsclause.trim();
if (!newsclause.equals("")){
	newsclause = " and (" + newsclause+") ";
} else{
	newsclause = " ";
}

newsclause =  " (docpublishtype='2' or docpublishtype='3') and docstatus in('1','2') "+newsclause;
//得到当前数据
if ((rs.getDBType()).equals("oracle")) { // oralce
	sppb.setBackFields("a.id,a.docsubject,b.doccontent,a.doclastmoddate,a.doclastmodtime,a.doccreaterid, a.usertype");
	sppb.setSqlFrom("from DocDetail a, DocDetailContent b");
	sppb.setSqlWhere(" where  a.id=b.docid  and "+newsclause);
	sppb.setPrimaryKey("a.id");
	sppb.setSqlOrderBy("a.doclastmoddate,a.doclastmodtime");
	sppb.setSortWay(st);
} else {
	sppb.setBackFields("id,docsubject,doccontent,doclastmoddate,doclastmodtime,doccreaterid,usertype");
	sppb.setSqlFrom("from DocDetail");
	sppb.setSqlWhere(" where "+newsclause);

	sppb.setPrimaryKey("id");
	sppb.setSqlOrderBy("doclastmoddate,doclastmodtime");
	sppb.setSortWay(st);
}

//sppb.setIsPrintExecuteSql(true);
spu.setSpp(sppb);
int count=spu.getRecordCount();
rs = spu.getCurrentPageRs(pi, ps);

//publishtype为0表示的是新闻是发布在外部的新闻

if(publishtype!=0){
	%>	
	<rss version="2.0">
		<channel>
			<title><![CDATA[此新闻页不是外部新闻不能通过此接口浏览]]></title>
			<description><![CDATA[]]></description>
			<language>zh-cn</language>
			<generator><![CDATA[Ecology System]]></generator>		
		</channel>
	</rss>
	<%	return;
}

if(ni==1){
	%>	
	<rss version="2.0">
		<channel>
			<title><![CDATA[<%=frontpagename%>]]></title>
			<description><![CDATA[<%=frontpagedesc%>]]></description>
			<language>zh-cn</language>
			<generator><![CDATA[Ecology System]]></generator>
			<count><%=count%></count>
		</channel>
	</rss>
	<%	return;
}
%>
<rss version="2.0">
	<channel>
		<title><![CDATA[<%=frontpagename%>]]></title>
		<description><![CDATA[<%=frontpagedesc%>]]></description>
		<language>zh-cn</language>
		<generator><![CDATA[Ecology System]]></generator>	
		<count><%=count%></count>
	</channel>
<%while (rs.next()){
	String tempId=Util.null2String(rs.getString("id"));	
	String docsubject=Util.null2String(rs.getString("docsubject"));	
	String doclastmoddate=Util.null2String(rs.getString("doclastmoddate"));	
	String doclastmodtime=Util.null2String(rs.getString("doclastmodtime"));	
	String doccreaterid=Util.null2String(rs.getString("doccreaterid"));	
	String usertype=Util.null2String(rs.getString("usertype"));	
	String doccontent=Util.null2String(rs.getString("doccontent"));	
		
	String desc="";
	String content="";
	int tmppos = doccontent.indexOf("!@#$%^&*");
	if (tmppos != -1) {
		desc = doccontent.substring(0, tmppos);
		//content=doccontent.substring(tmppos+8);
	}

	String resultStr=strProtocol+"://"+serverName+"/weaver/weaver.homepage.HomepageCreateImage?fileid=";
	String imgs="";
	ArrayList imglist=Util.matchAll(doccontent,"/weaver/weaver.file.FileDownload\\?fileid=([0-9]+)",1,-1);
	for(int i=0;i<imglist.size();i++){
		String imgid=(String)imglist.get(i);
		imgs+=resultStr+imgid+",";
	}

    


	String username="";
	if ("2".equals(usertype)) { //外部
		username =  cci.getCustomerInfoname(doccreaterid) ;
	} else { //内部
		username =  rc.getResourcename(doccreaterid) ;
	}

	String link=strProtocol+"://"+serverName+"/docs/docs/DocDsp.jsp?id="+tempId;
	
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
	<item>
		<newsid><![CDATA[<%=tempId%>&npid=<%=npid%>]]></newsid>
		<title><![CDATA[<%=docsubject%>]]></title>
		<link><![CDATA[<%=link%>]]></link>
		<pubDate><![CDATA[<%=doclastmoddate%> <%=doclastmodtime%>]]></pubDate>
		<description><![CDATA[<%=desc%>]]></description>
		<!--<content><![CDATA[<%=content%>]]></content>-->
		<author><![CDATA[<%=username%>]]></author>
		<imgs><![CDATA[<%=imgs%>]]></imgs>
		<accs><![CDATA[<%=accs%>]]></accs>
	</item>
<%}%>
</rss>