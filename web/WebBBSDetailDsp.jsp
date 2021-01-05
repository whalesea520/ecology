<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/web/inc/init1.jsp" %>
<%@ include file="/docs/common.jsp" %>
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DocNewsManager" class="weaver.docs.news.DocNewsManager" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/web/css/style_wev8.css" type=text/css rel=STYLESHEET>
<META http-equiv=Content-Type content="text/html; charset=UTF-8">
</head>
<%
char flag = 2 ;
int newsid = Util.getIntValue(request.getParameter("newsid"),0);
int mainid = Util.getIntValue(request.getParameter("mainid"),0);
int secid = Util.getIntValue(request.getParameter("secid"),0);
int subid =  Util.getIntValue(SecCategoryComInfo.getSubCategoryid(""+secid),0);
mainid = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(""+subid),0);
int docid = Util.getIntValue(request.getParameter("id"),0);
int publishtype = 0;
String newsclause = "" ;
if(newsid != 0) {
    DocNewsManager.resetParameter();
    DocNewsManager.setId(newsid);
    DocNewsManager.getDocNewsInfoById();
	publishtype = DocNewsManager.getPublishtype();
	newsclause = DocNewsManager.getNewsclause();
	DocNewsManager.closeStatement();
	if (publishtype!=0) {		
		boolean  canReader = false;
		if(logintype.equals("1")) {
			RecordSet.executeSql("select sharelevel from "+tables+" where sourceid="+docid);			
		}
		else {
			RecordSet.executeSql("select sharelevel from "+tables+" where sourceid="+docid);
		}

		if(RecordSet.next()) {
			canReader = true ;
		}
		if(!canReader)  {
			response.sendRedirect("/web/notice/noright.jsp") ;
			return ;
		}
	}
}

//根据文档id初始化文档信息
DocManager.resetParameter();
DocManager.setId(docid);
DocManager.getDocInfoById();

//获取文档标题docsubject
String docsubject=DocManager.getDocsubject();
//获取文档内容doccontent
String doccontent=DocManager.getDoccontent();
//获取文档创建日期doclastmoddate
String doclastmoddate=DocManager.getDoclastmoddate();
//获取文档创建时间doclastmodtime
String doclastmodtime=DocManager.getDoclastmodtime();
//获取文档最新修改日期doclastmoddate
String doclastmoddate=DocManager.getDoclastmoddate();
//获取创建人类型
String ownertype=DocManager.getUsertype();
//获取创建人ID
int ownerid=DocManager.getOwnerid();
String username = "";
//处理文档内容doccontent
int tmppos = doccontent.indexOf("!@#$%^&*");
if(tmppos!=-1)	doccontent = doccontent.substring(tmppos+8,doccontent.length());

/**********************向阅读标记表中插入阅读记录，修改阅读次数(只有当浏览者不是创建者时)********************/
if( userid != ownerid || !ownertype.equals(logintype) ) 
    rs.executeProc("docReadTag_AddByUser",""+docid+flag+userid+flag+logintype);  // 他人
DocManager.closeStatement();

String sqlStr = "" ;
String userLevelStr = "" ;
int docCountForUser = 0 ;
%>

<BODY bgcolor=#ffffff>

<div align=center>
<table valign=top border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr height="25">
		<td>
		:: <a href="WebBBS.jsp?id=<%=newsid%>"><%=MainCategoryComInfo.getMainCategoryname(""+mainid)%></a>	> 
		<a href="/web/WebBBSDsp.jsp?newsid=<%=newsid%>&mainid=<%=mainid%>&id=<%=secid%>">		<%=SecCategoryComInfo.getSecCategoryname(""+secid)%>
		</a>
		</td>
		<td align="right">
		<a href="/web/DocAdd.jsp?newsid=<%=newsid %>&mainid=<%=mainid%>&subid=<%=subid%>&secid=<%=secid%>">
		<img src="/web/images/bbs_button_newpost_wev8.gif" border="0"></a>
		<a href="/web/DocReply.jsp?newsid=<%=newsid%>&id=<%=docid%>&parentids=<%=docid%>">
		<img src="/web/images/bbs_button_replay_wev8.gif" border="0"></a>
		</td>
	</tr>
</table>
<table bgcolor="D8D8D8" valign=top border="0" cellspacing="1" cellpadding="0" width="100%">
	  <COLGROUP> 
	  <COL width=20%> 
	  <COL width=80%>

	  <tr bgcolor="229CC4">
		  <td><font color="#FFFFFF"><b>作者</b></font></td>
		  <td><font color="#FFFFFF"><b><%=docsubject%></b> &nbsp;&nbsp;创建于[<%=doclastmoddate%>&nbsp;&nbsp;<%=doclastmodtime%>]&nbsp;&nbsp;
		  </font><%if( (userid == ownerid) && ownertype.equals(logintype) ) {%><a href="DocEdit.jsp?newsid=<%=newsid%>&id=<%=docid%>"><font color="#FFFFFF">[编辑]</font></a><%}%></td>
	  </tr>
	  <tr bgcolor="FFFFFF"> 
		  <td valign="top">
			  <%
			  docCountForUser = 0 ;
			  if(ownertype.equals("1"))
			  {
			  username=Util.toScreen(ResourceComInfo.getResourcename(""+ownerid),7);
			  sqlStr = "select count(distinct id) from DocDetail where doccreaterid="+ownerid+" and usertype=1 and docstatus in('1','2','5')  ";
			  userLevelStr = Util.toScreen("管理员",7,"0") ;
			  }
			  else
			  {
			  username=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+ownerid),7);
			  sqlStr = "select count(distinct id) from DocDetail where doccreaterid="+ownerid+" and usertype=2 and docstatus in('1','2','5') ";
			  userLevelStr = CustomerInfoComInfo.getCustomerInfotype(""+ownerid);
			  userLevelStr =  Util.toScreen(CustomerTypeComInfo.getCustomerTypename(userLevelStr),7);
			  }
    		  if (!newsclause.equals("")) sqlStr += " and " + newsclause ;
			  rs.executeSql(sqlStr);
			  if(rs.next())	docCountForUser=rs.getInt(1);	
			  %>
			  <li><b><%=username%></b>
			  <BR>
			  <li><b><%=userLevelStr%></b>
			  <BR>
			  <li><b>发贴: <%=docCountForUser%></b>
		  </td>
		  <td><%=doccontent%><BR>
			  <table valign=top border="0" cellspacing="1" cellpadding="0" width="100%">
			  <tr height="1" background="/web/images/bg_hdotline_wev8.gif" colspan="2"><td></td></tr>
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
					String curlabel = SystemEnv.getHtmlLabelName(156,language)+i;
				%>
				<tr>
					<td class=field width=10%><%=curlabel%>:&nbsp&nbsp</td>
					<td class=field valign=top>
					<a href="/weaver/weaver.file.FileDownload?fileid=<%=curimgid%>"><%=curimgname%></a>&nbsp;
					<input type=hidden name=accessory<%=i%> value="<%=curimgid%>">
					<BUTTON class=btn accessKey=<%=i%> onclick="location='/weaver/weaver.file.FileDownload?fileid=<%=curimgid%>&download=1'"><U><%=i%></U>-<%=SystemEnv.getHtmlLabelName(258,language)%></BUTTON>
					</td>
				</tr>
				<%}
				DocImageManager.closeStatement();
				%>
				<!--获取并显示文档文档附件:end-->
				</table>
		  </td>
	  </tr>

	  <%
		String sqlrpy="select id,doccreaterid,docsubject,doccontent,doclastmoddate,doclastmodtime,parentids,usertype "+
		"from DocDetail where replydocid =" +docid +" order by parentids ";
		RecordSet.executeSql(sqlrpy);
		while(RecordSet.next()) {
		docid = Util.getIntValue(RecordSet.getString("id"),0) ;
		ownerid = Util.getIntValue(RecordSet.getString("doccreaterid"),0) ;
		docsubject = Util.toScreen(RecordSet.getString("docsubject"),7) ;
		doccontent = Util.toScreen(RecordSet.getString("doccontent"),7) ;
		doclastmoddate = Util.null2String(RecordSet.getString("doclastmoddate")) ;
		doclastmodtime = Util.null2String(RecordSet.getString("doclastmodtime")) ;
		ownertype = Util.null2String(RecordSet.getString("usertype")) ;
		tmppos = doccontent.indexOf("!@#$%^&*");
		if(tmppos!=-1)	doccontent = doccontent.substring(tmppos+8,doccontent.length());
		%>
		<tr bgcolor="229CC4">
		  <td><font color="#FFFFFF"><b>作者</b></font></td>
		  <td><font color="#FFFFFF"><b><%=docsubject%></b> &nbsp;&nbsp;创建于[<%=doclastmoddate%>&nbsp;&nbsp;<%=doclastmodtime%>]&nbsp;&nbsp;
			</font><%if( (userid == ownerid) && ownertype.equals(logintype) ) {%><a href="DocEdit.jsp?newsid=<%=newsid%>&id=<%=docid%>"><font color="#FFFFFF">[编辑]</font></a><%}%></td>
		</tr>
		<tr bgcolor="FFFFFF"> 
		  <td valign="top">
			  <%
			  docCountForUser = 0 ;
			  if(ownertype.equals("1"))
			  {
			  username=Util.toScreen(ResourceComInfo.getResourcename(""+ownerid),7);
			  sqlStr = "select count(distinct id) from DocDetail where doccreaterid="+ownerid+" and usertype=1 and docstatus in('1','2','5')  ";
			  userLevelStr = Util.toScreen("管理员",7,"0") ;
			  }
			  else
			  {
			  username=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+ownerid),7);
			  sqlStr = "select count(distinct id) from DocDetail where doccreaterid="+ownerid+" and usertype=2 and docstatus in('1','2','5') ";
			  userLevelStr = CustomerInfoComInfo.getCustomerInfotype(""+ownerid);
			  userLevelStr =  Util.toScreen(CustomerTypeComInfo.getCustomerTypename(userLevelStr),7);
			  }
    		  if (!newsclause.equals("")) sqlStr += " and " + newsclause ;
			  rs.executeSql(sqlStr);
			  if(rs.next())	docCountForUser=rs.getInt(1);	
			  %>
			  <li><b><%=username%></b>
			  <BR>
			  <li><b><%=userLevelStr%></b>
			  <BR>
			  <li><b>发贴: <%=docCountForUser%></b>
		  </td>
		  <td><%=doccontent%><BR>
			  <table valign=top border="0" cellspacing="1" cellpadding="0" width="100%">
			  <tr height="1" background="/web/images/bg_hdotline_wev8.gif" colspan="2"><td></td></tr>
			  <!--获取并显示文档文档附件:begin-->
				<%
				i= 0;
				DocImageManager.resetParameter();
				DocImageManager.setDocid(docid);
				DocImageManager.selectDocImageInfo();
				while(DocImageManager.next()){
					String curimgid = DocImageManager.getImagefileid();
					String curimgname = DocImageManager.getImagefilename();
					i++;
					String curlabel = SystemEnv.getHtmlLabelName(156,language)+i;
				%>
				<tr>
					<td class=field width=10%><%=curlabel%>:&nbsp&nbsp</td>
					<td class=field valign=top>
					<a href="/weaver/weaver.file.FileDownload?fileid=<%=curimgid%>"><%=curimgname%></a>&nbsp;
					<input type=hidden name=accessory<%=i%> value="<%=curimgid%>">
					<BUTTON class=btn accessKey=<%=i%> onclick="location='/weaver/weaver.file.FileDownload?fileid=<%=curimgid%>&download=1'"><U><%=i%></U>-<%=SystemEnv.getHtmlLabelName(258,language)%></BUTTON>
					</td>
				</tr>
				<%}
				DocImageManager.closeStatement();
				%>
				<!--获取并显示文档文档附件:end-->
				</table>
		  </td>
		</tr>

	   <%}%>

</table>
</div>
</body>
<script language=javascript>
function onDelete(delId){
	if(confirm("你确定要删除这条记录吗?")) {
	location.href="UploadDoc.jsp?id="+delId+"&operation＝delete&docapprovable=0"
	}
}
</script>