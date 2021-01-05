<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="DocTypeComInfo" class="weaver.docs.type.DocTypeComInfo" scope="page" />
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="ProjectInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetRight" class="weaver.conn.RecordSet" scope="page" />


<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String Seclevel=user.getSeclevel();
String logintype = user.getLogintype();
String projectid = Util.null2String(request.getParameter("projectid")) ;
String userid=""+user.getUID();

String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(101,user.getLanguage())+":"
		+"<a href='/Proj/data/ViewProject.jsp?ProjID="+projectid+"'>"+ProjectInfo.getProjectInfoname(projectid)+"</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%

//权限检查
RecordSet.executeProc("Prj_ProjectInfo_SelectByID",projectid);
if(RecordSet.getCounts()<=0)
	response.sendRedirect("/proj/DBError.jsp?type=FindData_VP");
RecordSet.first();

String projCreater = RecordSet.getString("creater");

boolean canview=false;
 if(HrmUserVarify.checkUserRight("ViewProject:View",user)) {
	 canview=true;
 }else if(userid.equals(projCreater)){
	 canview=true;
 }else if(userid.equals(ResourceComInfo.getManagerID(projCreater))){
	 canview=true;
 }else if(userid.equals(RecordSet.getString("Manager"))){
	 canview=true;
 }else{
	 RecordSetRight.executeProc("Prj_Find_Member",projectid);
	 while(RecordSetRight.next()){
		if(userid.equals(RecordSetRight.getString("resourceid"))){
			canview=true;
			break;
		}
	 }
 }
if(!canview){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
//权限检查end

String orderby = Util.null2String(request.getParameter("orderby"));
String dspreply = Util.null2String(request.getParameter("dspreply"));
String dspachive = Util.null2String(request.getParameter("dspachive"));
String maincategorys = Util.null2String(request.getParameter("maincategory"));
String doctype = Util.null2String(request.getParameter("doctype"));
String dsptype = Util.null2String(request.getParameter("dsptype"));
if(orderby.equals("")) orderby ="4" ;
if(dspachive.equals("")) dspachive = "2" ;

String linkstr = "ProjectDocView.jsp?orderby="+orderby+"&dspreply="+dspreply+"&dspachive="+dspachive+"&maincategory="+
				 maincategorys+"&doctype="+doctype+"&dsptype="+dsptype+"&projectid="+projectid ;
String whereclause ="where projectid="+projectid ;
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

ArrayList rpydoclastmoddate = new ArrayList();
ArrayList rpydoclastmodtime = new ArrayList();
ArrayList rpyid = new ArrayList();
ArrayList rpydocsubject = new ArrayList();
ArrayList rpydoccreatedate = new ArrayList();
ArrayList rpydoccreatetime = new ArrayList();
ArrayList rpydoccreatername = new ArrayList();
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
if(perpage ==0 ) perpage=20;
if(dspachive.equals("2")) whereclause+=" and docstatus !='5'" ;
if(!maincategorys.equals("")) whereclause+=" and maincategory="+maincategorys;
if(!doctype.equals("")) whereclause+=" and doctype="+doctype;
if(orderby.equals("1") || orderby.equals("")) orderclause = "order by doccreatedate ";
if(orderby.equals("2")) orderclause = "order by doccreatedate desc ";
if(orderby.equals("3")) orderclause = "order by doclastmoddate ";
if(orderby.equals("4")) orderclause = "order by doclastmoddate desc ";
if(orderby.equals("5")) orderclause = "order by docsubject ";
if(orderby.equals("6")) orderclause = "order by id ";
DocSearchManage.setStart(start);
DocSearchManage.setPerpage(perpage);
if(logintype.equals("2"))
DocSearchManage.getSelectPortalResult(whereclause,orderclause,""+user.getType(),Seclevel);
else 
DocSearchManage.getSelectResult(whereclause,orderclause,""+user.getUID());
recordersize=DocSearchManage.getNoreplysize();
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
	if (UserDefaultManager.getHascreater().equals("1")) doccreatername.add(""+DocSearchManage.getDocCreaterID());
	//if (UserDefaultManager.getHasseclevel().equals("1")) docseclevel.add(""+DocSearchManage.getDocSecLevel());
	docreplyable.add(Util.null2String(DocSearchManage.getDocReplyAble()));
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
				 "doccreaterid,doclastmoddate,doclastmodtime,"+
				 "docsubject,docstatus,doccreatedate,doccreatetime,"+
				 "replydocid,docreplyable from DocDetail " ;
if(whereclause.equals(""))	whereclause+=" where isreply='1' ";
else	whereclause+=" and isreply='1' ";
sqlrpy+=whereclause+" "+orderclause;
RecordSet.executeSql(sqlrpy);
while(RecordSet.next()){
	rpydoclastmoddate.add(RecordSet.getString("doclastmoddate"));
	rpydoclastmodtime.add(RecordSet.getString("doclastmodtime"));
	rpyid.add(""+RecordSet.getString("id"));
	rpydocsubject.add(Util.toScreen(RecordSet.getString("docsubject"),user.getLanguage()));
	rpydoccreatedate.add(RecordSet.getString("doccreatedate"));
	rpydoccreatetime.add(RecordSet.getString("doccreatetime"));
	rpydoccreatername.add(""+RecordSet.getString("doccreaterid"));
	rpydocid.add(""+RecordSet.getString("replydocid"));
}
}

%>
<DIV class=HdrProps></DIV>
<FORM id=docsearch name=docsearch action="ProjectDocView.jsp" method=post >
<input type=hidden name="projectid" value="<%=projectid%>">
<TABLE class=ViewForm border=0>
  <TBODY>
  <TR>
    <TD noWrap><%=SystemEnv.getHtmlLabelName(338,user.getLanguage())%></TD>
    <TD class=Field><SELECT  class=InputStyle  id=orderby 
      onChange="docsearch.submit();" name=orderby>
          <option value="1" <%if(orderby.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(339,user.getLanguage())%>)</option>
          <option value="2" <%if(orderby.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(340,user.getLanguage())%>)</option>
          <option value="3" <%if(orderby.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(339,user.getLanguage())%>)</option>
          <option value="4" <%if(orderby.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%> (<%=SystemEnv.getHtmlLabelName(340,user.getLanguage())%>)</option>
          <option value="5" <%if(orderby.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></option>
          <option value="6" <%if(orderby.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></option>
        </SELECT> 
    </TD>
    <TD>&nbsp;</TD>
      <TD noWrap><%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%></TD>
    <TD class=Field><SELECT  class=InputStyle  id=dspreply 
      onChange="docsearch.submit();" name=dspreply>
          <option value="2" <%if(dspreply.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(233,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></option>
          <option value="1" <%if(dspreply.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></option>
		</SELECT> </TD>
    <TD>&nbsp;</TD>
      <TD noWrap><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></TD>
      <TD class=Field>
        <select  class=InputStyle  id=dspachive
      onChange="docsearch.submit();" name=dspachive>
          <option value="2" <%if(dspachive.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(233,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></option>
          <option value="1" <%if(dspachive.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></option>
		</select>
      </TD>
    </TR>
  <TR>
      <TD noWrap><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></TD>
    <TD class=Field><select  class=InputStyle  name=maincategory onChange="docsearch.submit();">
	  <option value=""> </option>
	  <%
	  while(MainCategoryComInfo.next()){
		String isselect = "";
		String curid = MainCategoryComInfo.getMainCategoryid();
		String curname = MainCategoryComInfo.getMainCategoryname();
		if(maincategorys.equals(curid)) isselect=" selected";
	  %>
	  <option value="<%=curid%>" <%=isselect%>><%=curname%></option>  
	  <%}%>
	  </select>
    </TD>
    <TD>&nbsp;</TD>
    <TD noWrap><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></TD>
    <TD class=Field>
      <select  class=InputStyle  id=dsptype 
      onChange="docsearch.submit();" name=dsptype>
          <option value="1" <%if(dspachive.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(95,user.getLanguage())%></option>
          <option value="2" <%if(dspachive.equals("2 ")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(341,user.getLanguage())%></option>
        </select>
    </TD>
    
    </TR></TBODY></TABLE>
	</form>
<TABLE class=ViewForm width="100%" border=0>
  <COLGROUP>
  <COL width="6%">
  <COL width="42%">
  <COL width=24>
  <COL width="40%">
  <COL width="8%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=5>
	<%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%>: 
      <% if(!maincategorys.equals("")) {%><%=MainCategoryComInfo.getMainCategoryname(maincategorys)%><%}%></TH></TR>
  <TR class=Spacing>
    <TD class=Line1 colSpan=5></TD></TR></TBODY></TABLE>
  <% int currentid = -1; 
  	 while(currentid+1 <recordersize )  {
	 	currentid++ ;
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
  <a href="javaScript:openhrm(<%=(String)rpydoccreatername.get(rpycurrentid)%>);" onclick='pointerXY(event);'>
	  <%=Util.toScreen(ResourceComInfo.getResourcename((String)rpydoccreatername.get(rpycurrentid)),user.getLanguage())%></a>, 
  <%=rpydoccreatedate.get(rpycurrentid)%>, 
  <%=rpydoccreatetime.get(rpycurrentid)%>, 
  <%=Util.add0(Util.getIntValue((String)rpyid.get(rpycurrentid),0),12)%>
  </DIV></NOBR></DIV></LI></UL>
  <%}}}%>
  </LI></UL>
  <%}%>

<TABLE class=ViewForm width="100%">
  <TBODY>
  <TR class=Spacing>
    <TD class=Sep2></TD></TR></TBODY></TABLE>
<TABLE width="100%" border=0>
  <TBODY> 
  <TR> 
    <TD noWrap><%=Util.makeNavbar(start, recordersize , perpage, linkstr)%></TD>
  </TR>
  </TBODY> 
</TABLE>
<br>
</BODY></HTML>
