
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />

<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getIntValue(request.getParameter("perpage"),1);

String prjtype = Util.null2String(request.getParameter("ProjectType"));
String prjstatus = Util.null2String(request.getParameter("ProjectStatus"));
String worktype = Util.null2String(request.getParameter("WorkType"));
String prjname = Util.null2String(request.getParameter("ProjectName"));
String procode = Util.null2String(request.getParameter("procode"));

// added by lupeng 2004-7-16.
String unread = Util.null2String(request.getParameter("unread"));
// end.

if(perpage<=1 )	perpage=10;



/*
String tablename = "prjtemptable"+ Util.getRandom() ;

RecordSet.executeSql("select id,name,description,prjtype,worktype,status into "+tablename+" from Prj_ProjectInfo "+SearchComInfo1.FormatSQLSearch(user.getLanguage()));

RecordSet.executeSql(" select count(id) from "+ tablename );
RecordSet.next() ;
int recordersize = RecordSet.getInt(1) ;

String sqltemp="delete from "+tablename+" where id in(select top "+(start-1)+" id from "+ tablename+ ")";
RecordSet.executeSql(sqltemp);
sqltemp="select top "+perpage+" * from "+ tablename;
RecordSet.executeSql(sqltemp);
RecordSet.executeSql("drop table "+ tablename);
*/
/*
//添加判断权限的内容--new--begin
String temptable = "prjstemptable"+ Util.getRandom() ;
String temptable2 = "prjstemptable2"+Util.getRandom() ;
String SearchSql = "";
String SqlWhere = "";

String sql ="";
if(RecordSet.getDBType().equals("oracle")){
	sql ="create table "+temptable2+" as select * from (select t1.id,t1.name,t1.procode,t1.prjtype,t1.worktype,t1.status,t1.manager, concat(concat(',',t1.members),',') as members from Prj_ProjectInfo t1)"	;
}else if(RecordSet.getDBType().equals("db2")){
    sql ="create table "+temptable2+" as (select t1.id,t1.name,t1.procode,t1.prjtype,t1.worktype,t1.status,t1.manager, concat(concat(',',t1.members),',') as members from Prj_ProjectInfo t1) definition only ";

   RecordSet.executeSql(sql);
  
   sql ="insert into "+temptable2+" (select t1.id,t1.name,t1.procode,t1.prjtype,t1.worktype,t1.status,t1.manager,(','+t1.members+',') as members from Prj_ProjectInfo t1 fetch first "+temptable2+" rows only )";
}else{
	sql ="select t1.id,t1.name,t1.procode,t1.prjtype,t1.worktype,t1.status,t1.manager,(','+t1.members+',') as members into "+temptable2+" from Prj_ProjectInfo t1" ;
}

RecordSet.executeSql(sql);
*/
String SqlWhere = "";
SqlWhere = " where t1.id = t2.prjid and t2.usertype="+user.getLogintype()+" and t2.userid="+user.getUID()+" and (t1.manager="+user.getUID()
+ " or t1.members like '"+user.getUID() +",%'" + " or t1.members like '%,"+user.getUID() +"'" +" or t1.members like '%,"+user.getUID()+",%')   and t1.status in (1,2,3,4,5) ";


if(!prjtype.equals(""))
	SqlWhere += " and t1.prjtype ="+prjtype;
if(prjstatus.equals("1") || prjstatus.equals("2") || prjstatus.equals("3") || prjstatus.equals("4") || prjstatus.equals("5"))
	SqlWhere += " and t1.status ="+prjstatus;

// added by lupeng 2004-07-16 for unachieved projects.
if(prjstatus.equals("12"))
	SqlWhere += " and t1.status in (1,2,4,5)";
// end.

if(!worktype.equals(""))
	SqlWhere += " and t1.worktype ="+worktype;
if(!prjname.equals(""))
	SqlWhere += " and t1.name like '%"+prjname+"%'";
if(!procode.equals(""))
	SqlWhere += " and t1.procode like '%"+procode+"%'";

// added by lupeng 2004-07-16 for unread projects.
if(unread.equals("1"))
	SqlWhere += " and t1.status in (1,2,4,5) AND t1.id NOT IN (SELECT projId FROM Prj_ViewedLog" 
				+ " WHERE userId = " + String.valueOf(user.getUID()) + " AND userType = '" 
				+ user.getLogintype() + "')";
// end.
/*
int TotalCount = Util.getIntValue(request.getParameter("TotalCount"),0);


	SearchSql = "select distinct count(*) from "+temptable2+"  t1,PrjShareDetail  t2  "+ SqlWhere;  

	RecordSet.executeSql(SearchSql);

	if(RecordSet.next()){
	TotalCount = RecordSet.getInt(1);
	}

if(RecordSet.getDBType().equals("oracle")){
	SearchSql = "create table "+temptable+"  as select * from (select distinct t1.id,t1.name,t1.procode,t1.prjtype,t1.worktype,t1.status,t1.manager,t1.members from "+temptable2+"  t1,PrjShareDetail  t2  " + SqlWhere + " order by t1.id desc ) where rownum<"+ (pagenum*perpage+2);
}else if(RecordSet.getDBType().equals("db2")){
    SearchSql = "create table "+temptable+"  as (select distinct t1.id,t1.name,t1.procode,t1.prjtype,t1.worktype,t1.status,t1.manager,t1.members from "+temptable2+"  t1,PrjShareDetail  t2  ) definition only ";

    RecordSet.executeSql(SearchSql);

    SearchSql = "insert into "+temptable+" (select distinct  t1.id,t1.name,t1.procode,t1.prjtype,t1.worktype,t1.status,t1.manager,t1.members from "+temptable2+"  t1,PrjShareDetail  t2  " + SqlWhere + " order by t1.id desc fetch first top "+(pagenum*perpage+1)+" rows only ) "; 
}else{
	SearchSql = "select distinct top "+(pagenum*perpage+1)+" t1.id,t1.name,t1.procode,t1.prjtype,t1.worktype,t1.status,t1.manager,t1.members into "+temptable+" from "+temptable2+"  t1,PrjShareDetail  t2  " + SqlWhere + " order by t1.id desc"; 
}

RecordSet.executeSql(SearchSql);

//添加判断权限的内容--new--end
*/

/*
RecordSet.executeSql("Select count(id) RecordSetCounts from "+temptable);
boolean hasNextPage=false;
int RecordSetCounts = 0;
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}
if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}

	String sqltemp="";
if(RecordSet.getDBType().equals("oracle")){
	sqltemp="select * from (select * from  "+temptable+" order by id) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
}else if(RecordSet.getDBType().equals("db2")){
    sqltemp="select * from "+temptable+"  order by id fetch first "+(RecordSetCounts-(pagenum-1)*perpage)+" rows only ";
}else{
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+"  order by id";
}
RecordSet.executeSql(sqltemp);

RecordSet.executeSql("drop table "+temptable);
RecordSet.executeSql("drop table "+temptable2);
*/
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16408,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
/*
RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:onReSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
*/
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:search(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

//RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:prevPage(),_self} " ;
//RCMenuHeight += RCMenuHeightStep;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:nextPage(),_self} " ;
//RCMenuHeight += RCMenuHeightStep;
   
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
   
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>




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
		<FORM method="GET" name="searchForm">
			<TABLE class=ViewForm border=0>
				<TR>
					<TD><%=SystemEnv.getHtmlLabelName(1353,user.getLanguage())%></TD>
					<TD CLASS="Field">
						<Input type="text" class="inputstyle" name="ProjectName" value="<%=prjname%>"/>
					</TD>
					<td></td>
					<TD><%=SystemEnv.getHtmlLabelName(17852,user.getLanguage())%></TD>
					<TD CLASS="Field">
						<Input type="text" class="inputstyle" name="procode" value="<%=procode%>"/>
					</TD>
					<td></td>
					<TD><%=SystemEnv.getHtmlLabelName(587,user.getLanguage())%></TD>
					<TD CLASS="Field">
					<Select class="inputstyle" name="ProjectStatus">
						<option value=""></option>
						<%while(ProjectStatusComInfo.next()){%>
							<%if(!ProjectStatusComInfo.getProjectStatusid().equals("6") && !ProjectStatusComInfo.getProjectStatusid().equals("7")){%>
								<option value="<%=ProjectStatusComInfo.getProjectStatusid()%>"
								<%if(prjstatus.equals(ProjectStatusComInfo.getProjectStatusid())){%> selected="true"<%}%>
								>
								<%=SystemEnv.getHtmlLabelName(Util.getIntValue(ProjectStatusComInfo.getProjectStatusname()),user.getLanguage())%></option>
							<%}%>
						<%}%>
					</Select>
					</TD>
				</tr>
				<tr>
					<TD><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></TD>
					<TD CLASS="Field">
						<Select class="inputstyle" name="ProjectType">
							<option value=""></option>
							<%while(ProjectTypeComInfo.next()){%>
								<option value="<%=ProjectTypeComInfo.getProjectTypeid()%>"
								<%if(prjtype.equals(ProjectTypeComInfo.getProjectTypeid())){%> selected="true"<%}%>
								>
								<%=ProjectTypeComInfo.getProjectTypename()%></option>
							<%}%>
						</Select>
					</TD>
					<td></td>
					<TD><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></TD>
					<TD CLASS="Field">
						<Select class="inputstyle" name="WorkType">
							<option value=""></option>
							<%while(WorkTypeComInfo.next()){%>
								<option value="<%=WorkTypeComInfo.getWorkTypeid()%>"
								<%if(worktype.equals(WorkTypeComInfo.getWorkTypeid())){%> selected="true"<%}%>
								>
								<%=WorkTypeComInfo.getWorkTypename()%></option>
							<%}%>
						</Select>
					</TD>				
					<td></td>
					<td></td>
					<td></td>
				</TR>
				<TR style="height:1px;"><TD class=Line colSpan=8></TD></TR>
			</TABLE>

		</FORM>
		<br/>
<TABLE class=liststyle cellspacing=0  >
  		<tr> <td valign="top">  
  			<%  
  			String tableString  =  "";  
  			String backfields  =  "t1.id,t1.name,t1.procode,t1.prjtype,t1.worktype,t1.status,t1.manager,t1.members"; 
  			String fromSql  = " from Prj_ProjectInfo t1, PrjShareDetail t2"; 
  			String orderby  =  "id";
  			String sqlwhere = SqlWhere;
  			//System.out.println("select " + backfields + fromSql + sqlwhere);
  			tableString =" <table instanceid=\"workflowRequestListTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+      
  									 "<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" sqlorderby=\""+orderby+"\" sqlprimarykey=\"id\" sqlsortway=\"desc\" />"+   
  									 "<head>";   
  			tableString+="<col width=\"9%\" text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\"  column=\"name\" orderkey=\"name\"  linkkey=\"ProjID\" linkvaluecolumn=\"id\" href=\"/proj/data/ViewProject.jsp\" target=\"_fullwindow\"  />";            
  			tableString+="<col width=\"13%\" text=\""+SystemEnv.getHtmlLabelName(17852,user.getLanguage())+"\" column=\"procode\" orderkey=\"procode\" target=\"_fullwindow\" linkkey=\"ProjID\" linkvaluecolumn=\"id\" href=\"/proj/data/ViewProject.jsp\"/>"; 
        tableString+="<col width=\"13%\" text=\""+SystemEnv.getHtmlLabelName(101,user.getLanguage())+SystemEnv.getHtmlLabelName(1332,user.getLanguage())+"\"  column=\"id\" orderkey=\"id\" transmethod=\"weaver.splitepage.transform.SptmForProj.linkToProjTask\" otherpara=\""+user.getLanguage()+"\"/>";           
        tableString+="<col width=\"13%\" text=\""+SystemEnv.getHtmlLabelName(586,user.getLanguage())+"\" column=\"prjtype\" orderkey=\"prjtype\" transmethod=\"weaver.splitepage.transform.SptmForProj.getProjTypeName\"/>";           
        tableString+="<col width=\"13%\" text=\""+SystemEnv.getHtmlLabelName(432,user.getLanguage())+"\" column=\"worktype\" orderkey=\"worktype\" transmethod=\"weaver.splitepage.transform.SptmForProj.getWorkTypeName\"/>";  
        tableString+="<col width=\"13%\" text=\""+SystemEnv.getHtmlLabelName(587,user.getLanguage())+"\" column=\"status\" orderkey=\"status\" transmethod=\"weaver.splitepage.transform.SptmForProj.getProjStatusName\" otherpara=\""+user.getLanguage()+"\"/>";     
				tableString+="<col width=\"13%\" text=\""+SystemEnv.getHtmlLabelName(16573,user.getLanguage())+"\" column=\"manager\" orderkey=\"manager\" linkkey=\"id\" target=\"_self\" href=\"/hrm/resource/HrmResource.jsp\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\"/>";  
        tableString+="<col width=\"13%\" text=\""+SystemEnv.getHtmlLabelName(18628,user.getLanguage())+"\" column=\"members\" orderkey=\"members\" transmethod=\"weaver.splitepage.transform.SptmForProj.getMembers\" otherpara=\""+user.getLanguage()+"\"/>";
				tableString+="</head>";
	      tableString+="</table>";
        %> 
         
			<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
		</td>
	</tr>
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

	  
<script>
function onReSearch(){
	location.href="/proj/search/Search.jsp";
}
</script>
<script>
function nextPage()
{
    document.all("pagenum").value = parseInt(document.all("pagenum").value) + 1 ;
	searchForm.submit();
	
}
function prevPage(){
   document.all("pagenum").value = parseInt(document.all("pagenum").value) - 1 ;
	searchForm.submit();
}


function search(){
	searchForm.submit();

}

</script>
</body>
</html>
