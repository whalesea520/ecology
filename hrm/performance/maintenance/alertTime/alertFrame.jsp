<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<%
String imagefilename = "/images/hdHRM.gif";
String titlename = SystemEnv.getHtmlLabelName(17694,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
/*
int userid=user.getUID();
String userdepartment=user.getUserDepartment()+"";
String userseclevel=user.getSeclevel();
String logintype = ""+user.getLogintype();
int usertype = 0;
if(logintype.equals("2"))   usertype= 1;
int typeid=Util.getIntValue(Util.null2String(request.getParameter("typeid")),0);
int id = Util.getIntValue(Util.null2String(request.getParameter("id")),0);

String CustomerID = Util.null2String(request.getParameter("CustomerID"));
String projectid = Util.null2String(request.getParameter("projectid"));
String type = Util.null2String(request.getParameter("type"));

int isworkflow = Util.getIntValue(Util.null2String(request.getParameter("isworkflow")),0);
int isreward = Util.getIntValue(Util.null2String(request.getParameter("isreward")),0);

int maintypeid = Util.getIntValue(Util.null2String(request.getParameter("maintypeid")),0);

ArrayList maintypeids = new ArrayList();


String sqltmp = "select distinct t1.id from cowork_maintypes t1,cowork_types t2 where t2.departmentid=t1.id and ( ','+managerid+',' like '%,"+user.getUID()+",%' or ','+members+',' like '%,"+user.getUID()+",%')";
RecordSet.executeSql(sqltmp);
while(RecordSet.next()){
	maintypeids.add(RecordSet.getString(1));
	if(maintypeid==0)
		maintypeid = RecordSet.getInt(1);
}

if(typeid!=0){
    maintypeid=Util.getIntValue(CoTypeComInfo.getCoTypendepartmentid(""+typeid),0);	
}
*/
%>
<body style="overflow:auto">
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr>
<td height="60">
<%@ include file="/systeminfo/TopTitle.jsp" %>
<form name=weaver id=weaver>
<TABLE class=viewform width=100% id=oTable1 height=32px border=0>
  <COLGROUP>
  <COL width="50%">
  <COL width=5>
  <COL width="50%">
  <TBODY>
  <tr>
  	<td  height=30 colspan=3 background="/cowork/images/bg1.gif" align=left>
	  <table width=100% border=0 cellspacing=0 cellpadding=0 height=100%  scrolling=no>
	  <tr aligh=left>
	   <td nowrap background="/cowork/images/bg1.gif" width=15px height=100% align=center></td>
	  <td nowrap name="oTDtype_0"  id="oTDtype_0 background="/cowork/images/bglight.gif" width=70px height=100% align=center onmouseover="style.cursor='hand'" onclick="resetbanner(1,0)" ><b><%=SystemEnv.getHtmlLabelName(18106,user.getLanguage())%></b></td>
	  <td nowrap name="oTDtype_1"  id="oTDtype_1 background="/cowork/images/bglight.gif" width=70px height=100% align=center onmouseover="style.cursor='hand'" onclick="resetbanner(1,-2)" ><b><%=SystemEnv.getHtmlLabelName(18106,user.getLanguage())%></b></td>
	  <td nowrap name="oTDtype_2" id="oTDtype_2  background="/cowork/images/bgdark.gif" width=70px height=100% align=center onmouseover="style.cursor='hand'" onclick="resetbanner(2,-2)"><b><%=SystemEnv.getHtmlLabelName(18106,user.getLanguage())%></b></td>
	  <td nowrap name="oTDtype_3"  id="oTDtype_3 background="/cowork/images/bglight.gif" width=70px height=100% align=center onmouseover="style.cursor='hand'" onclick="resetbanner(3,0)" ><b><%=SystemEnv.getHtmlLabelName(18106,user.getLanguage())%></b></td>

	  </tr>
	  </table>
	</td>
  </tr>
  </TBODY>
</TABLE>

<input type=hidden name=typetotal value=<%=typetotal%>>
</form>


 <script language=javascript>
 function changemaintype(objval){
 	location.href="coworkview.jsp?maintypeid="+objval
 }
function resetbanner(objid,typeid){
  	for(i=0;i<=<%=typetotal%>;i++){
  		document.all("oTDtype_"+i).background="/cowork/images/bgdark.gif";
  	}
  	document.all("oTDtype_"+objid).background="/cowork/images/bglight.gif";

var o = document.frames[1].document.frames[0];
//alert(o.location);return false;

  	if(typeid == -2 )  		
		o.location="CoworkList.jsp?maintypeid=<%=maintypeid%>&projectid=<%=projectid%>&type=<%=type%>&CustomerID=<%=CustomerID%>&isworkflow=1&typeid="+typeid;		
 	else if(typeid == -3)
		o.location="CoworkList.jsp?maintypeid=<%=maintypeid%>&projectid=<%=projectid%>&type=<%=type%>&CustomerID=<%=CustomerID%>&isreward=1&typeid="+typeid;
 	else 
 		o.location="CoworkList.jsp?maintypeid=<%=maintypeid%>&projectid=<%=projectid%>&type=<%=type%>&CustomerID=<%=CustomerID%>&typeid="+typeid;
 		
 	//window.oTd1.style.display='';
 	//window.mainmiddleFrame.window.document.all("LeftHideShow").src = "/cowork/images/show.gif";
 	//window.mainmiddleFrame.window.document.all("LeftHideShow").title = '<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>';   
  }
  </script>
</td>
</tr>
<tr>
<td height="*">
 <iframe src="" ID="iframeCoworkView" name="iframeCoworkView" style="width:100%;height:100%" scrolling="auto"/>
</td></tr>
</table>
</body>