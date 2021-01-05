<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/web/inc/init1.jsp" %>
<%@ include file="/web/inc/WebServer.jsp" %>
<%@ include file="/docs/common.jsp" %>
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DocNewsManager" class="weaver.docs.news.DocNewsManager" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>


<META http-equiv=Content-Type content="text/html; charset=UTF-8">
<title></title></head>
<%
int newsid = Util.getIntValue(request.getParameter("newsid"),0);
int docid = Util.getIntValue(request.getParameter("id"),0);
int languageid = Util.getIntValue(request.getParameter("languageid"),7);
String isTime=""+Util.getIntValue(request.getParameter("isTime"),0);
String fromComment=""+Util.getIntValue(request.getParameter("fromComment"),0);
String newsclause = "";
int publishtype = -1;
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
			RecordSet.executeSql("select sharelevel from "+tables+" where sourceid="+docid) ;
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

String simple = Util.null2String(request.getParameter("simple"));
//根据文档id初始化文档信息
DocManager.resetParameter();
DocManager.setId(docid);
DocManager.getDocInfoById();

//获取文档标题docsubject
String docsubject=DocManager.getDocsubject();
//获取文档内容doccontent
String doccontent=DocManager.getDoccontent();
//获取文档最新修改日期doclastmoddate
String doclastmoddate=DocManager.getDoclastmoddate();
//获取文档创建人id
int doccreaterid=DocManager.getDoccreaterid();
String usertype=DocManager.getUsertype();
char flag = 2;
//处理文档内容doccontent
int tmppos = doccontent.indexOf("!@#$%^&*");
if(tmppos!=-1)	doccontent = doccontent.substring(tmppos+8,doccontent.length());


/**********************向阅读标记表中插入阅读记录，修改阅读次数(只有当浏览者不是创建者时)********************/
if(!fromComment.equals("1"))
	if( userid != doccreaterid || !usertype.equals(logintype) ) 
		rs.executeProc("docReadTag_AddByUser",""+docid+flag+userid+flag+logintype);  // 他人


/********取出文章被阅读的次数begin***********/
int readCount_int = 0 ;
String sql_readCount ="select sum(readCount) from docreadtag where docid =" + docid ;
rs.execute(sql_readCount);
if(rs.next()) readCount_int = Util.getIntValue(rs.getString(1),0) ;
/********取出文章被阅读的次数end***********/

boolean isLight = false ;
%>

<BODY bgcolor=#ffffff>
<div align="right"></div>
<div align=center>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <%if(!simple.equals("y")){%>
    <tr> 
      <td class="p9grey" colspan=2 height="30">
	   <div align="center"><font color="#000000" size="3"><%=docsubject%></font></div>
      </td>
    </tr>
    <tr>
      <td class="p9grey" colspan=2  height="30"> 
	    <div align="center"> 
          <font color="#999999">发布日期：<%=doclastmoddate%></font> 
          &nbsp;&nbsp;&nbsp;&nbsp;<font color="#666666">浏览次数：<%=readCount_int%></font></div>  
      </td>
    </tr>
	<%}%>
    <tr> 
      <td class="p9grey" colspan=2 align="center" width="100%"> 
        <table width="94%" height="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td class="p9grey" colspan=2> <%=doccontent%> </td>
          </tr>
		  <%if(!simple.equals("y")){%>
		  <tr> 
          <td height="20" valign="bottom" width="10%">发布人：
          </td>
          <td height="20" >
		  <%if(usertype.equals("1")){%>
		  <%=ResourceComInfo.getResourcename(""+doccreaterid)%>
		  <%}else{%>
		  <%=CustomerInfoComInfo.getCustomerInfoname(""+doccreaterid)%>
		  <%}%>
		  </td>
        </tr>

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
		<td class=field width="10%"><%=curlabel%>:&nbsp&nbsp</td>
		<td class=field align=left valign=top> <a href="/weaver/weaver.file.FileDownload?fileid=<%=curimgid%>"><%=curimgname%></a>&nbsp; 
		<input type=hidden name=accessory<%=i%> value="<%=curimgid%>">
		<BUTTON class=btn accessKey=<%=i%> onclick="location='/weaver/weaver.file.FileDownload?fileid=<%=curimgid%>&download=1'"><U><%=i%></U>-<%=SystemEnv.getHtmlLabelName(258,languageid)%></BUTTON> 
		</td>
		</tr>
		<%
			}
		}
		%>
        </table>
		<BR><BR>
      </td>
    </tr>    
  </table>
</div>
</body>

