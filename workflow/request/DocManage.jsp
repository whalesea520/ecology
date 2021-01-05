<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="DocTypeComInfo" class="weaver.docs.type.DocTypeComInfo" scope="page" />
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String Seclevel=user.getSeclevel();
String logintype = user.getLogintype();

String ownerid = user.getUID()+"";
String dspreply = Util.null2String(request.getParameter("dspreply"));
String linkstr="DocManage.jsp";
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+"-"+ResourceComInfo.getResourcename(ownerid);
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%
String whereclause ="where ownerid="+ownerid +" and (docstatus in(0,4) or docstatus<=0)";
String orderclause ="" ;
int start = Util.getIntValue(request.getParameter("start") , 1) ;
int perpage = 0;
int recordersize=0;
ArrayList doclastmoddate = new ArrayList();
ArrayList doclastmodtime = new ArrayList();
ArrayList id = new ArrayList();
ArrayList docsubject = new ArrayList();
ArrayList docstatus = new ArrayList();
ArrayList doccreatedate = null;
ArrayList doccreatetime = null;
ArrayList maincategory = null;
ArrayList subcategory = null;
ArrayList seccategory = null;
ArrayList doccreatername = null;
//ArrayList docseclevel = null;
ArrayList docreplyable = new ArrayList();
ArrayList docisreply = new ArrayList();

ArrayList rpydoclastmoddate = new ArrayList();
ArrayList rpydoclastmodtime = new ArrayList();
ArrayList rpyid = new ArrayList();
ArrayList rpydocsubject = new ArrayList();
ArrayList rpydoccreatedate = new ArrayList();
ArrayList rpydoccreatetime = new ArrayList();
ArrayList rpydocownername = new ArrayList();
ArrayList rpydocid = new ArrayList();

boolean dspdocid = false;
UserDefaultManager.setUserid(user.getUID());
UserDefaultManager.selectUserDefault();
perpage = UserDefaultManager.getNumperpage();
if (UserDefaultManager.getHascreater().equals("1")) doccreatername = new ArrayList();
if (UserDefaultManager.getHascreatedate().equals("1")) doccreatedate = new ArrayList();
if (UserDefaultManager.getHascreatetime().equals("1")) doccreatetime = new ArrayList();
if (UserDefaultManager.getHascategory().equals("1")) {
maincategory = new ArrayList();
subcategory = new ArrayList();
seccategory = new ArrayList();
}
//if (UserDefaultManager.getHasseclevel().equals("1")) docseclevel = new ArrayList();
if (UserDefaultManager.getHasdocid().equals("1")) dspdocid = true;
if(perpage <=1 ) perpage=20;

//DocSearchManage.getSelectResult(whereclause,orderclause);
if(logintype.equals("2"))
DocSearchManage.getSelectPortalResult(whereclause,orderclause,""+user.getType(),Seclevel);
else 
DocSearchManage.getSelectResult(whereclause,orderclause,""+user.getUID());

recordersize=DocSearchManage.getRecordersize();
while(DocSearchManage.next()){
	doclastmoddate.add(DocSearchManage.getDocLastModDate());
	doclastmodtime.add(DocSearchManage.getDocLastModTime());
	id.add(""+DocSearchManage.getID());
	docsubject.add(Util.toScreen(DocSearchManage.getDocSubject(),user.getLanguage()));
	String docstatusstr = DocSearchManage.getDocStatus();
    if (docstatusstr.equals("0")||Util.getIntValue(docstatusstr,0)<=0)  docstatus.add(SystemEnv.getHtmlLabelName(220,user.getLanguage()));
	if (docstatusstr.equals("1")||docstatusstr.equals("2"))  docstatus.add(SystemEnv.getHtmlLabelName(225,user.getLanguage()));
	if (docstatusstr.equals("3"))  docstatus.add(SystemEnv.getHtmlLabelName(360,user.getLanguage()));
	if (docstatusstr.equals("4"))  docstatus.add(SystemEnv.getHtmlLabelName(236,user.getLanguage()));
	if (docstatusstr.equals("5"))  docstatus.add(SystemEnv.getHtmlLabelName(251,user.getLanguage()));
 	if (UserDefaultManager.getHascreatedate().equals("1")) doccreatedate.add(DocSearchManage.getDocCreateDate());
	if (UserDefaultManager.getHascreatetime().equals("1")) doccreatetime.add(DocSearchManage.getDocCreateTime());
	if (UserDefaultManager.getHascategory().equals("1")) maincategory.add(Util.toScreen(MainCategoryComInfo.getMainCategoryname(""+DocSearchManage.getMainCategory()),user.getLanguage()));
	if (UserDefaultManager.getHascategory().equals("1")) subcategory.add(Util.toScreen(SubCategoryComInfo.getSubCategoryname(""+DocSearchManage.getSubCategory()),user.getLanguage()));
	if (UserDefaultManager.getHascategory().equals("1")) seccategory.add(Util.toScreen(SecCategoryComInfo.getSecCategoryname(""+DocSearchManage.getSecCategory()),user.getLanguage()));
	if (UserDefaultManager.getHascreater().equals("1")) doccreatername.add(""+DocSearchManage.getOwnerId());
	//if (UserDefaultManager.getHasseclevel().equals("1")) docseclevel.add(""+DocSearchManage.getDocSecLevel());
	docreplyable.add(Util.null2String(DocSearchManage.getDocReplyAble()));
	docisreply.add(Util.null2String(""+DocSearchManage.getDocReplyID()));
}
if(dspreply.equals("1")) {
whereclause ="" ;
for(int i=0 ; i<id.size() ; i++)  {
	if(((String)docreplyable.get(i)).equals("1"))  {
		if(whereclause.equals("")) whereclause ="where replydocid in (" +(String)id.get(i) ;
		else whereclause += ","+(String)id.get(i) ;
	}
}
if(id.size()>0)		whereclause += ")" ;
orderclause = "order by id" ;
String sqlrpy="select id,maincategory,subcategory,seccategory,"+
				 "ownerid,doclastmoddate,doclastmodtime,"+
				 "docsubject,docstatus,doccreatedate,doccreatetime,"+
				 "replydocid,docreplyable from DocDetail " ;
sqlrpy+=whereclause+" "+orderclause;
RecordSet.executeSql(sqlrpy);
//DocSearchManage.getSelectResult(whereclause,orderclause);
if(logintype.equals("2"))
DocSearchManage.getSelectPortalResult(whereclause,orderclause,""+user.getType(),Seclevel);
else 
DocSearchManage.getSelectResult(whereclause,orderclause,""+user.getUID());

while(RecordSet.next()){
	rpydoclastmoddate.add(RecordSet.getString("doclastmoddate"));
	rpydoclastmodtime.add(RecordSet.getString("doclastmodtime"));
	rpyid.add(""+RecordSet.getString("id"));
	rpydocsubject.add(Util.toScreen(RecordSet.getString("docsubject"),user.getLanguage()));
	rpydoccreatedate.add(RecordSet.getString("doccreatedate"));
	rpydoccreatetime.add(RecordSet.getString("doccreatetime"));
	rpydocownername.add(""+RecordSet.getString("ownerid"));
	rpydocid.add(""+RecordSet.getString("replydocid"));
}
}
%>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<TABLE class="viewform" width="100%" border=0>
  <COLGROUP>
  <COL width="6%">
  <COL width="42%">
  <COL width=24>
  <COL width="40%">
  <COL width="8%">
  
  <% int currentid = -1; 
  	 while(currentid+1 <id.size() )  {
	 	currentid++ ;
	 	if(!((String)docisreply.get(currentid)).equals("0")) continue;
  %>
  <UL style="MARGIN-TOP: 0px; MARGIN-BOTTOM: 1px; MARGIN-LEFT: 25px">
  <LI style="MARGIN-BOTTOM: 3px"><NOBR><%=doclastmoddate.get(currentid)%> <%=doclastmodtime.get(currentid)%>&nbsp;<A 
  href="/docs/docs/DocDsp.jsp?id=<%=id.get(currentid)%>"><B><%=docsubject.get(currentid)%></B></A>, 
  &nbsp; <FONT color=green>(<%=docstatus.get(currentid)%>)</FONT></NOBR>
  <DIV ><NOBR>
  <DIV style="MARGIN-LEFT: 126px"><%if(maincategory!=null){%><%=maincategory.get(currentid)%>/<%=subcategory.get(currentid)%>/<%=seccategory.get(currentid)%>  <%}%>
  <%if(doccreatername!=null){%><a href="javaScript:openhrm(<%=(String)doccreatername.get(currentid)%>);" onclick='pointerXY(event);'>
  <%=Util.toScreen(ResourceComInfo.getResourcename((String)doccreatername.get(currentid)),user.getLanguage())%></a><%}%>
  <%if(doccreatedate!=null){%><%=doccreatedate.get(currentid)%>  <%}%>
  <%if(doccreatetime!=null){%><%=doccreatetime.get(currentid)%>  <%}%>
  <%if(dspdocid){%><%=Util.add0(Util.getIntValue((String)id.get(currentid),0),12)%>  <%}%>
  </DIV></NOBR></DIV>
  <% if(dspreply.equals("1")) {
     if(((String)docreplyable.get(currentid)).equals("1")) {
  	   int rpycurrentid = -1 ; int rpyrecordersize=rpyid.size();
	   while(rpycurrentid+1<rpyrecordersize) {
	       rpycurrentid++ ;
		   if(!((String)rpydocid.get(rpycurrentid)).equals((String)id.get(currentid))) continue;
  %>
  <UL>
    <LI type=circle><NOBR><%=rpydoclastmoddate.get(rpycurrentid)%> <%=rpydoclastmodtime.get(rpycurrentid)%>&nbsp;<A 
  href="/docs/docs/DocDsp.jsp?id=<%=rpyid.get(rpycurrentid)%>"><B><%=rpydocsubject.get(rpycurrentid)%></B></A></NOBR>
  <DIV ><NOBR>
  <DIV style="MARGIN-LEFT: 126px">
  <a href="javaScript:openhrm(<%=(String)rpydocownername.get(rpycurrentid)%>);" onclick='pointerXY(event);'>
	  <%=Util.toScreen(ResourceComInfo.getResourcename((String)rpydocownername.get(rpycurrentid)),user.getLanguage())%></a>, 
  <%=rpydoccreatedate.get(rpycurrentid)%>, 
  <%=rpydoccreatetime.get(rpycurrentid)%>, 
  <%=Util.add0(Util.getIntValue((String)rpyid.get(rpycurrentid),0),12)%>
  </DIV></NOBR></DIV></LI></UL>
  <%}}}%>
  </LI></UL>
  <%}%>
</table>
<TABLE class="viewform" width="100%">
  <TBODY>
  <TR class="Spacing">
    <TD class=line1></TD></TR></TBODY></TABLE>
<TABLE width="100%" border=0>
  <TBODY> 
  <TR> 
    <TD noWrap><%=Util.makeNavbar(start, recordersize , perpage, linkstr)%></TD>
  </TR>
  </TBODY> 
</TABLE>
</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

<br>
</BODY></HTML>
