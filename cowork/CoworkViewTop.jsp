
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="AllSubordinate" class="weaver.hrm.resource.AllSubordinate" scope="page"/>
<jsp:useBean id="CoTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page"/>
<jsp:useBean id="CoMainTypeComInfo" class="weaver.cowork.CoMainTypeComInfo" scope="page"/>
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17694,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
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
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name=weaver id=weaver>

<TABLE class=viewform width=100% id=oTable1 height=32px border=1>
  <COLGROUP>
  <COL width="50%">
  <COL width=5>
  <COL width="50%">
  <TBODY>
  <tr>
  	<td  height=30 colspan=3 background="/cowork/images/bg1_wev8.gif" align=left>
	  <table width=100% border=0 cellspacing=0 cellpadding=0 height=100%  scrolling=no>
	  <tr aligh=left>
	   <td nowrap background="/cowork/images/bg1_wev8.gif" width=15px height=100% align=center></td>
	 
	  <%
	  int isfirst = 0;
	  int firsttype = typeid;
	  int typetotal = 0;
	  int hasexact=0;
	  
	
		
	  String sqltype = "select distinct t2.id,t2.typename,t2.departmentid from cowork_items t1,cowork_types t2 where status=1 and t1.typeid=t2.id and  (( ','+t1.coworkers+',' like '%,"+user.getUID()+",%'  or t1.creater="+user.getUID()+") or','+managerid+',' like '%,"+user.getUID()+",%')";
	  RecordSet.executeSql(sqltype);
	  
	  if(firsttype==0){
	  %>
	  <td nowrap name="oTDtype_<%=typetotal%>"  id="oTDtype_<%=typetotal%>" background="/cowork/images/bglight_wev8.gif" width=70px height=100% align=center onmouseover="style.cursor='hand'" onclick="resetbanner(<%=typetotal%>,0)" ><b><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></b></td>
	 <%}else{%>
	 <td nowrap name="oTDtype_<%=typetotal%>" id="oTDtype_<%=typetotal%>"  background="/cowork/images/bgdark_wev8.gif" width=70px height=100% align=center onmouseover="style.cursor='hand'" onclick="resetbanner(<%=typetotal%>,0)"><b><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></b></td>
	 <%}
	 
	   typetotal++;
	   
	  if(isworkflow==1){
	  %>
	  <td nowrap name="oTDtype_<%=typetotal%>"  id="oTDtype_<%=typetotal%>" background="/cowork/images/bglight_wev8.gif" width=70px height=100% align=center onmouseover="style.cursor='hand'" onclick="resetbanner(<%=typetotal%>,-2)" ><b><%=SystemEnv.getHtmlLabelName(2118,user.getLanguage())%></b></td>
	 <%}else{%>
	 <td nowrap name="oTDtype_<%=typetotal%>" id="oTDtype_<%=typetotal%>"  background="/cowork/images/bgdark_wev8.gif" width=70px height=100% align=center onmouseover="style.cursor='hand'" onclick="resetbanner(<%=typetotal%>,-2)"><b><%=SystemEnv.getHtmlLabelName(2118,user.getLanguage())%></b></td>
	 <%}
	  //typetotal++;
	
	  while(RecordSet.next()){
	  	int tmpid = RecordSet.getInt("departmentid");
	  	if( maintypeids!=null){
	  		if(maintypeids.indexOf(""+tmpid)==-1)
	  			hasexact=1;
	  	}
	  	
		if(tmpid!= maintypeid){
			continue;
		}
	    typetotal++;
	    
	  if((firsttype!=0 &&firsttype == RecordSet.getInt("id"))){
	  
	  %>
	  <td nowrap name="oTDtype_<%=typetotal%>"  id="oTDtype_<%=typetotal%>" background="/cowork/images/bglight_wev8.gif" width=70px height=100% align=center onmouseover="style.cursor='hand'" onclick="resetbanner(<%=typetotal%>,<%=RecordSet.getString("id")%>)" ><b><%=RecordSet.getString("typename")%></b></td>
	  <%
	  isfirst=1;
	  }else{
	  %> <td nowrap name="oTDtype_<%=typetotal%>" id="oTDtype_<%=typetotal%>"  background="/cowork/images/bgdark_wev8.gif" width=70px height=100% align=center onmouseover="style.cursor='hand'" onclick="resetbanner(<%=typetotal%>,<%=RecordSet.getString("id")%>)"><b><%=RecordSet.getString("typename")%></b></td>
	 
	  <%
	  }
	  }%>
	<%if(hasexact==1){
	
	   typetotal++;
	   %>
	 <td nowrap name="oTDtype_<%=typetotal%>" id="oTDtype_<%=typetotal%>"  background="/cowork/images/bgdark_wev8.gif" width=70px height=100% align=center onmouseover="style.cursor='hand'" onclick="resetbanner(<%=typetotal%>,-1)"><b><%=SystemEnv.getHtmlLabelName(17693,user.getLanguage())%></b></td>
	 <%}%>
	 
	 
	  <td   nowrap valign=top width=100% height=100%></td>
	 <%if(maintypeids!=null){
		if(maintypeids.size()>1){
	   %>
	 <td nowrap   align=right onmouseover="style.cursor='hand'">
	 <select name=maintypeid onchange="changemaintype(this.value);">
	 <%for(int i=0;i<maintypeids.size();i++){%>
	 <option value="<%=maintypeids.get(i)%>" <%if(Util.getIntValue(""+maintypeids.get(i),0)==maintypeid){%> selected <%}%>><%=CoMainTypeComInfo.getCoMainTypename(""+maintypeids.get(i))%></option>
	 <%}%>
	 </select>
	 </td>
	 <%}}%>
	  </tr>
	  </table>
	</td>
  </tr>
  </TBODY>
</TABLE>
<tr></tr>
</table>
<input type=hidden name=typetotal value=<%=typetotal%>>
</form>
 </body>

 <script language=javascript>
 function changemaintype(objval){
 	window.parent.location.href="coworkview.jsp?maintypeid="+objval
 }
function resetbanner(objid,typeid){
  	for(i=0;i<=<%=typetotal%>;i++){
  		document.all("oTDtype_"+i).background="/cowork/images/bgdark_wev8.gif";
  	}
  	document.all("oTDtype_"+objid).background="/cowork/images/bglight_wev8.gif";
  	if(typeid == -2 )  		
		window.parent.document.getElementById("frameLeft").src="CoworkList.jsp?maintypeid=<%=maintypeid%>&projectid=<%=projectid%>&type=<%=type%>&CustomerID=<%=CustomerID%>&isworkflow=1&typeid="+typeid;		
 	else if(typeid == -3)
		window.parent.document.getElementById("frameLeft").src="CoworkList.jsp?maintypeid=<%=maintypeid%>&projectid=<%=projectid%>&type=<%=type%>&CustomerID=<%=CustomerID%>&isreward=1&typeid="+typeid;
 	else 
 		window.parent.document.getElementById("frameLeft").src="CoworkList.jsp?maintypeid=<%=maintypeid%>&projectid=<%=projectid%>&type=<%=type%>&CustomerID=<%=CustomerID%>&typeid="+typeid;
 		
 	//window.oTd1.style.display='';
 	//window.mainmiddleFrame.window.document.all("LeftHideShow").src = "/cowork/images/show_wev8.gif";
 	//window.mainmiddleFrame.window.document.all("LeftHideShow").title = '<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>';   
  }
  </script>
</html>
