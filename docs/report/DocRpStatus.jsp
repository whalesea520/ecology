<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="DocTypeComInfo" class="weaver.docs.type.DocTypeComInfo" scope="page" />
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(169,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%
String orderby = Util.null2String(request.getParameter("orderby"));
String docstatuss = Util.null2String(request.getParameter("docstatus"));
String publish = Util.null2String(request.getParameter("publish"));
String department = Util.null2String(request.getParameter("department"));
String linkstr = "DocRpStatus.jsp?orderby="+orderby+"&docstatus="+docstatuss+"&publish="+publish+"&department="+department ;
String whereclause ="" ;
String orderclause ="" ;
int start = Util.getIntValue(request.getParameter("start") , 1) ;
int perpage = 0;

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

boolean dspdocid = false;
UserDefaultManager.setUserid(user.getUID());
UserDefaultManager.selectUserDefault();
perpage = UserDefaultManager.getNumperpage();
if(perpage <=1 ) perpage=20 ;
if (UserDefaultManager.getHascreater().equals("1")) doccreatername = new ArrayList();
if (UserDefaultManager.getHascreatedate().equals("1")) doccreatedate = new ArrayList();
if (UserDefaultManager.getHascreatetime().equals("1")) doccreatetime = new ArrayList();
if (UserDefaultManager.getHascategory().equals("1")) {
maincategory = new ArrayList();
subcategory = new ArrayList();
seccategory = new ArrayList();
}

if (UserDefaultManager.getHasdocid().equals("1")) dspdocid = true;

if(!docstatuss.equals("")) whereclause+="where docstatus ='"+docstatuss+"'" ;
if(!publish.equals("")) {
	if(whereclause.equals("")) whereclause +="where docpublishtype ='"+publish+"'";
	else whereclause +=" and docpublishtype ='"+publish+"'";
}
if(!department.equals("")) {
	if(whereclause.equals("")) whereclause +="where docdepartmentid ='"+department+"'";
	else whereclause +=" and docdepartmentid ='"+department+"'";
}

if(orderby.equals("1") || orderby.equals("")) orderclause = "order by doccreatedate ";
if(orderby.equals("2")) orderclause = "order by doccreatedate desc ";
if(orderby.equals("3")) orderclause = "order by doclastmoddate ";
if(orderby.equals("4")) orderclause = "order by doclastmoddate desc ";
if(orderby.equals("5")) orderclause = "order by docsubject ";
if(orderby.equals("6")) orderclause = "order by id ";

DocSearchManage.setStart(start) ;
DocSearchManage.setPerpage(perpage) ;
DocSearchManage.getSelectResult(whereclause,orderclause,""+user.getUID());
int recordersize = DocSearchManage.getRecordersize() ;

while(DocSearchManage.next()){
	doclastmoddate.add(DocSearchManage.getDocLastModDate());
	doclastmodtime.add(DocSearchManage.getDocLastModTime());
	id.add(""+DocSearchManage.getID());
	docsubject.add(Util.toScreen(DocSearchManage.getDocSubject(),user.getLanguage()));
	String docstatusstr = DocSearchManage.getDocStatus();
    if (docstatusstr.equals("0")||Util.getIntValue(docstatusstr,0)<=0)  docstatus.add(SystemEnv.getHtmlLabelName(220,user.getLanguage()));
	if (docstatusstr.equals("1")||docstatusstr.equals("2"))  docstatus.add(SystemEnv.getHtmlLabelName(1984,user.getLanguage()),user.getLanguage(),"0"));
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
}

%>
<DIV class=HdrProps></DIV>
<FORM id=Baco name=Baco action="DocRpStatus.jsp" method=post>
  <DIV class=btnbar><BUTTON class=btnRefresh accessKey=R type=submit><U>R</U>-<%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%></BUTTON></DIV>
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="20%">
  <COL width="30%">
  <COL width="20%">
  <COL width="30%">
  <TBODY>
  <TR class=Spacing>
    <TD class=Line1 colSpan=5></TD></TR>
  <TR>
      <TD><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></TD>
      <TD class=Field>
        <select class=InputStyle  name=docstatus>
          <option value=""></option>
		  <option value=1 <%if(docstatuss.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1984,user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(233,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(359,user.getLanguage())%></option>
          <option value=2 <%if(docstatuss.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1984,user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(359,user.getLanguage())%></option>
          <option value=3 <%if(docstatuss.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(360,user.getLanguage())%></option>
		  <option value=5 <%if(docstatuss.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
        </select>
      
      <TD><%=SystemEnv.getHtmlLabelName(114,user.getLanguage())%></TD>
      <TD class=Field>
        <select  class=InputStyle name=publish>
          <option value=""></option>
          <option value=1 <%if(publish.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1984,user.getLanguage())%></option>
          <option value=2 <%if(publish.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(227,user.getLanguage())%></option>
          <option value=3 <%if(publish.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></option>
        </select>
      </TD>
    </TR>
  <TR>
      <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
    <TD class=Field><BUTTON type="button" class=Browser onClick="onShowDepartment()"></BUTTON>&nbsp;
    <SPAN id=departmentdesc>
	<%if(!department.equals("")) {%>
	<%=Util.toScreen((DepartmentComInfo.getDepartmentmark(department))+" - "+DepartmentComInfo.getDepartmentname(department),user.getLanguage())%><%}%></SPAN>
      <INPUT id=department type=hidden name=department value="<%=department%>" >
       </TD>
<script language="vbs">
sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&Baco.department.value)
	if NOT isempty(id) then
	        if id(0)<> 0 then
		departmentdesc.innerHtml = id(1)
		Baco.department.value=id(0)
		else
		departmentdesc.innerHtml = empty
		Baco.department.value=""
		end if
	end if
end sub
</script>
      <TD><%=SystemEnv.getHtmlLabelName(338,user.getLanguage())%></TD>
      <TD class=Field> 
        <select class=InputStyle  class=FieldLongB id=orderby name=orderby>
          <option value="1" <%if(orderby.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%> 
          (<%=SystemEnv.getHtmlLabelName(339,user.getLanguage())%>)</option>
          <option value="2" <%if(orderby.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%> 
          (<%=SystemEnv.getHtmlLabelName(340,user.getLanguage())%>)</option>
          <option value="3" <%if(orderby.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%> 
          (<%=SystemEnv.getHtmlLabelName(339,user.getLanguage())%>)</option>
          <option value="4" <%if(orderby.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%> 
          (<%=SystemEnv.getHtmlLabelName(340,user.getLanguage())%>)</option>
          <option value="5" <%if(orderby.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></option>
          <option value="6" <%if(orderby.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></option>
        </select>
      </TD>
    </TR>
  <TR class=Title>
      <TH colSpan=5><%=SystemEnv.getHtmlLabelName(356,user.getLanguage())%></TH>
    </TR></TBODY></TABLE></FORM>
<TABLE class=ViewForm width="100%">
  <TBODY>
  <TR class=Spacing>
    <TD class=Line1></TD></TR></TBODY></TABLE>
<% 
    for(int currentid=0 ; currentid<id.size() ; currentid++) {
  %>
  <UL style="MARGIN-TOP: 0px; MARGIN-BOTTOM: 1px; MARGIN-LEFT: 25px">
  <LI style="MARGIN-BOTTOM: 3px"><NOBR><%=doclastmoddate.get(currentid)%> <%=doclastmodtime.get(currentid)%>&nbsp;<A 
  href="/docs/docs/DocDsp.jsp?id=<%=id.get(currentid)%>"><B><%=docsubject.get(currentid)%></B></A>, 
  &nbsp; <FONT color=green>(<%=docstatus.get(currentid)%>)</FONT></NOBR>
  <DIV ><NOBR>
  <DIV style="MARGIN-LEFT: 126px"><%if(maincategory!=null){%><%=maincategory.get(currentid)%>/<%=subcategory.get(currentid)%>/<%=seccategory.get(currentid)%>  <%}%>
  <%if(doccreatername!=null){%>
  <a href="javaScript:openhrm(<%=(String)doccreatername.get(currentid)%>);" onclick='pointerXY(event);'>
  <%=Util.toScreen(ResourceComInfo.getResourcename((String)doccreatername.get(currentid)),user.getLanguage())%></a><%}%>
  <%if(doccreatedate!=null){%><%=doccreatedate.get(currentid)%>  <%}%>
  <%if(doccreatetime!=null){%><%=doccreatetime.get(currentid)%>  <%}%>
  <%if(dspdocid){%><%=Util.add0(Util.getIntValue((String)id.get(currentid),0),12)%>  <%}%>

  </DIV></NOBR></DIV>
  </LI></UL>
  <%}%>
<TABLE class=ViewForm width="100%">
  <TBODY>
  <TR class=Spacing>
    <TD class=Sep2 colSpan=5></TD></TR></TBODY></TABLE>
<TABLE width="100%" border=0>
  <TBODY> 
  <TR> 
    <TD noWrap><%=Util.makeNavbar(start, recordersize , perpage, linkstr)%></TD>
  </TR>
  </TBODY> 
</TABLE>
<br>
</BODY></HTML>
