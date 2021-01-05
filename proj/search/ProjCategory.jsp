<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page"/>
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
int userid=user.getUID();
String username=ResourceComInfo.getResourcename(userid+"");
String main=Util.fromScreen(request.getParameter("main"),user.getLanguage());
String sub=Util.fromScreen(request.getParameter("sub"),user.getLanguage());
if(main.equals(""))	main="prjtype";
if(sub.equals(""))	sub="worktype";
String con1=main;
String con2=sub;
%>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(101,user.getLanguage())+":"+Util.toScreen(username,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>


<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name=frmmain method=post action="ProjCategory.jsp">


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



<table class=viewform>
  <colgroup>
  <col width="15%">
  <col width="35%">
  <col width="15%">
  <col width="35%">
  <tr class=title><th colspan=4><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></th></tr>
  <tr class="separator"><td colspan="4" class="Sep1"></td>
  <tr>
  	<td><%=SystemEnv.getHtmlLabelName(863,user.getLanguage())%></td>
  	<td class=field>
  	<select class=inputstyle  size=1 name=main style="width:95%" onChange="checkSame()">
  	<option class="InputStyle" value="prjtype" <%if(main.equals("prjtype")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></option>
  	<option class="InputStyle" value="status" <%if(main.equals("status")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(587,user.getLanguage())%></option>
  	<option  class="InputStyle"value="worktype" <%if(main.equals("worktype")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></option>
  	</select>
  	</td>
  	<td><%=SystemEnv.getHtmlLabelName(1281,user.getLanguage())%></td>
  	<td class=field>
  	<select class=inputstyle  size=1 name=sub style="width:95%" onChange="checkSame()">
  	<option class="InputStyle" value="prjtype" <%if(sub.equals("prjtype")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></option>
  	<option class="InputStyle" value="status" <%if(sub.equals("status")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(587,user.getLanguage())%></option>
  	<option  class="InputStyle"value="worktype" <%if(sub.equals("worktype")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></option>
  	</select>
  	</td>
  </tr>
</table>
<script language=javascript>
	function checkSame(){
		if(frmmain.main.value==frmmain.sub.value)
			if(frmmain.main.options[0].selected)
				frmmain.sub.options[1].selected=true;
			else
				frmmain.sub.options[0].selected=true;
	}
</script>
<%
ArrayList maincounts=new ArrayList();
ArrayList mainids=new ArrayList();
//String sql="select count(distinct t1.id) count,t1."+main+" from prj_projectinfo t1,prj_taskprocess t2 where ( t2.hrmid="+userid+" and t2.prjid=t1.id and t1.isblock=1 ) or t1.manager="+userid+" group by t1."+main+" order by t1."+main;
String sql ="";
if((RecordSet.getDBType()).equals("oracle")) {
	sql="select count(id),"+main+" from prj_projectinfo  where ( concat(concat(',',members),',')  like '%"+(","+userid+",")+"%' and isblock=1 )  or manager="+userid+" group by "+main+" order by "+main;
}else if((RecordSet.getDBType()).equals("db2")) {
	sql="select count(id),"+main+" from prj_projectinfo  where ( concat(concat(',',members),',')  like '%"+(","+userid+",")+"%' and isblock=1 )  or manager="+userid+" group by "+main+" order by "+main;
}else{
	sql="select count(id),"+main+" from prj_projectinfo  where ( ','+members+','  like '%,"+userid+",%' and isblock=1 )  or manager="+userid+" group by "+main+" order by "+main;

}


RecordSet.executeSql(sql);
while(RecordSet.next()){
	maincounts.add(RecordSet.getString(1));
	mainids.add(RecordSet.getString(2));
}
ArrayList subcounts=new ArrayList();
ArrayList subids=new ArrayList();
ArrayList sub_mainids=new ArrayList();
//sql="select count(distinct t1.id),t1."+main+",t1."+sub+" from prj_projectinfo t1,prj_taskprocess t2 where ( t2.hrmid="+userid+" and t2.prjid=t1.id and t1.isblock=1 ) or t1.manager="+userid+" group by t1."+main+",t1."+sub+" order by t1."+main+",t1."+sub;

if((RecordSet.getDBType()).equals("oracle")) {
	sql="select count(id),"+main+", "+sub+" from prj_projectinfo   where ( concat(concat(',',members),',')  like '%"+(","+userid+",")+"%' and isblock=1 ) or manager="+userid+" group by "+main+","+sub+" order by "+main+","+sub;
}else if((RecordSet.getDBType()).equals("db2")) {
	sql="select count(id),"+main+", "+sub+" from prj_projectinfo   where ( concat(concat(',',members),',')  like '%"+(","+userid+",")+"%' and isblock=1 ) or manager="+userid+" group by "+main+","+sub+" order by "+main+","+sub;
}else{
	sql="select count(id),"+main+", "+sub+" from prj_projectinfo   where ( ','+members+','  like '%,"+userid+",%' and isblock=1 ) or manager="+userid+" group by "+main+","+sub+" order by "+main+","+sub;
}




RecordSet.executeSql(sql);
while(RecordSet.next()){
	subcounts.add(RecordSet.getString(1));
	subids.add(RecordSet.getString(3));
	sub_mainids.add(RecordSet.getString(2));
}

int mainnum=mainids.size();
int rownum = (mainnum+1)/2;
//out.print(subcounts);
%>
<table class=viewform>
  <tr class="separator"><td colspan="2" class="Sep1"></td></tr>
  <tr><td colspan=2>&nbsp;</td></tr>
  <tr>
     <td width="50%" align=left valign=top>
<%
 	int needtd=rownum;
 	for(int i=0;i<mainids.size();i++){
 		String mainid = (String)mainids.get(i);
 		String maincount=(String)maincounts.get(i);
 		if(maincount.equals(""))	maincount="0";
 		String mainname="";
 		if(main.equals("prjtype"))	mainname=ProjectTypeComInfo.getProjectTypename(mainid);
 		if(main.equals("status"))	mainname=SystemEnv.getHtmlLabelName(Util.getIntValue(ProjectStatusComInfo.getProjectStatusname(mainid)),user.getLanguage());
 		if(main.equals("worktype"))	mainname=WorkTypeComInfo.getWorkTypename(mainid);
 		needtd--;
%>
	<table><tr><td>
	<ul><li>
	<%if(!maincount.equals("0")){%><a href="SearchOperation.jsp?<%=con1%>=<%=mainid%>&member=<%=userid%>"><%}%>
	<%=Util.toScreen(mainname,user.getLanguage())%>(<%=maincount%>)<%if(!maincount.equals("0")){%></a><%}%>
<%
		for(int j=0;j<subids.size();j++){
			String subid=(String)subids.get(j);
			String subcount=(String)subcounts.get(j);
 			if(subcount.equals(""))	subcount="0";
 			String sub_mainid=(String)sub_mainids.get(j);
 			if(!sub_mainid.equals(mainid))	continue;
 			String subname="";
	 		if(sub.equals("prjtype"))	subname=ProjectTypeComInfo.getProjectTypename(subid);
 			 if(sub.equals("status"))	subname=SystemEnv.getHtmlLabelName(Util.getIntValue(ProjectStatusComInfo.getProjectStatusname(subid)),user.getLanguage());
 			if(sub.equals("worktype"))	subname=WorkTypeComInfo.getWorkTypename(subid);
 		%>
 		<ul><li>
 		<%if(!subcount.equals("0")){%><a href="SearchOperation.jsp?<%=con1%>=<%=mainid%>&<%=con2%>=<%=subid%>&member=<%=userid%>"><%}%>
 		<%=Util.toScreen(subname,user.getLanguage())%>(<%=subcount%>)<%if(!subcount.equals("0")){%></a><%}%></li></ul>
 		<%
		}
%>
	</li></ul></td></tr></table>
	<%
		if(needtd==0){
			needtd=mainnum/2;
	%>
		</td><td align=left valign=top>
	<%
		}
	}
%>
</table>
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


</form>
<script language="javascript">
function submitData()
{
	
		frmmain.submit();
}

function submitDel()
{
	if(isdel()){
		document.all("method").value="delete" ;
		weaver.submit();
		}
}
</script>
</body>
</html>