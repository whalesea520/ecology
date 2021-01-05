
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SearchComInfo1" class="weaver.proj.search.SearchComInfo" scope="session" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />

<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />

<jsp:useBean id="spp" class="weaver.general.SplitPageParaBean" scope="page" />
<jsp:useBean id="spu" class="weaver.general.SplitPageUtil" scope="page" />


<%
SearchComInfo1.resetSearchInfo();	

int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getIntValue(request.getParameter("perpage"),1);
boolean hasNextPage=false;

if(perpage<=1 )	perpage=10;

String SearchSql = "";
String SqlWhere = "";
String userid = "" + user.getUID();
if(!SearchComInfo1.FormatSQLSearch(user.getLanguage()).equals("")){
	SqlWhere = SearchComInfo1.FormatSQLSearch(user.getLanguage()) +" and t1.id = t2.prjid and t2.usertype="+user.getLogintype()+" and t2.userid="+user.getUID();  
}else{
	SqlWhere = " where t1.id = t2.prjid and t2.usertype="+user.getLogintype()+" and t2.userid="+user.getUID();  
}
int TotalCount = Util.getIntValue(request.getParameter("TotalCount"),0);
spp.setBackFields("t1.id,t1.name,t1.prjtype,t1.worktype,t1.status" );
spp.setSqlFrom("Prj_ProjectInfo  t1, prj_taskprocess  t2");
spp.setSqlWhere("( t2.hrmid=" +userid+" and t2.prjid=t1.id and t1.isblock=1 ) or (t1.manager="+userid+")");
spp.setSqlOrderBy("t1.id");
spp.setPrimaryKey("t1.id");
spp.setDistinct(true);
spp.setSortWay(spp.DESC);

spu.setSpp(spp);       
RecordSet = spu.getCurrentPageRs(pagenum,perpage);      

if(TotalCount==0){
	TotalCount = spu.getRecordCount();
}
if(TotalCount>pagenum*perpage){
	hasNextPage=true;
}

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table class=ListStyle id=tblReport cellspacing=1>
    <tbody> 
    <tr class=Header> 
      <th colspan = 2 ><%=SystemEnv.getHtmlLabelName(1211,user.getLanguage())%></th>
    </tr>

<%
     
boolean isLight = false;
int totalline=1;
if(RecordSet.last()){
	do{
		if(isLight)
		{%>	
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>
    <TD><a href="/proj/data/ViewProject.jsp?ProjID=<%=RecordSet.getString("id")%>" target = "mainFrame"><%=RecordSet.getString("name")%></a></TD>
    <TD>
    <%
	   //modify by dongping for TD1131
	   String status = RecordSet.getString("status");
	   if (status.equals("0")) {
	   	  out.println(SystemEnv.getHtmlLabelName(220,user.getLanguage()));
	   }
	   else {
	      out.println(ProjectStatusComInfo.getProjectStatusname(RecordSet.getString("status")));
	   }     
   %>
    </TD>
  </TR>
<%
	isLight = !isLight;
	if(hasNextPage){
		totalline+=1;
		if(totalline>perpage)	break;
	}
}while(RecordSet.previous());
}

%>  
 </TBODY>
 </TABLE>
 	<TABLE align=right>
   <tr>
   <td>&nbsp;</td>
   <td><%if(pagenum>1){%><button class=btn accessKey=P onclick="location.href='HomePageProject.jsp?pagenum=<%=pagenum-1%>&TotalCount=<%=TotalCount%>'"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button><%}%></td>
   <td><%if(hasNextPage){%><button class=btn accessKey=N onclick="location.href='HomePageProject.jsp?pagenum=<%=pagenum+1%>&TotalCount=<%=TotalCount%>'"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button><%}%></td>
   <td>&nbsp;</td>
   </tr>
	  </TABLE>

</body>
</html>