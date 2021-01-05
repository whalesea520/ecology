
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.file.*" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CptSearchComInfo" class="weaver.cpt.search.CptSearchComInfo" scope="session" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CapitalStateComInfo" class="weaver.cpt.maintenance.CapitalStateComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page" />
<jsp:useBean id="CapitalAssortmentList" class="weaver.cpt.maintenance.CapitalAssortmentList" scope="page" />
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>

<%

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String CurrentUser = ""+user.getUID();
String logintype = ""+user.getLogintype();
String ProcPara = "";
char flag = 2;
ProcPara = CurrentUser;
ProcPara += flag+logintype;

//查询部分
String assortmentid = CptSearchComInfo.getCapitalgroupid();

String tempsearchsql = CptSearchComInfo.FormatSQLSearch();

//put all capitalid into hashtable
Hashtable ht = new Hashtable();
String sql = "";

sql = " select * from CptCapital "+tempsearchsql+" order by mark,departmentid,id";

RecordSet.executeSql(sql);

while(RecordSet.next()){
	String tempid = RecordSet.getString("id");
	String tempassortmentid = RecordSet.getString("capitalgroupid");
	ArrayList tempal = (ht.get(tempassortmentid)==null)?new ArrayList():(ArrayList)ht.get(tempassortmentid);
	tempal.add(tempid);
	ht.put(tempassortmentid,tempal);
}

//initial AssortmentList
CapitalAssortmentList.initCapitalAssortmentList("0");
if(assortmentid.equals("")){
	CapitalAssortmentList.setCapitalAssortmentList2("0");
}
else{
	CapitalAssortmentList.setCapitalAssortmentList2(assortmentid);
}

//get max step
int stepcount = 0;
while(CapitalAssortmentList.next()){
	int step = Util.getIntValue(CapitalAssortmentList.getAssortmentStep());
	if(step>stepcount){
		stepcount=step;
	}
}

if(!(CptSearchComInfo.getCountType()).equals("")){
	stepcount = 2;
}

int tdwidth=(int)(24/stepcount);

String strData="";
String strURL="";
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(915,user.getLanguage());//TotalCount+" - "+pagenum+" - "+perpage;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps></DIV>
<DIV>
	<BUTTON class=btnSearch id=Search accessKey=S onclick="onReSearch()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(364,user.getLanguage())%></BUTTON>
	<BUTTON class=BtnLog accessKey=E name=button2 onclick="location='/weaver/weaver.file.ExcelOut'"><U>E</U>-Excel</BUTTON>

</DIV>
<table border="1" width=100%>
<tr>
<td>
<TABLE class=ListShort >
  <COLGROUP>
  <% for(int i=0;i<stepcount;i++){ %>	
  <COL width="<%=tdwidth%>%">
  <% } %>
  <COL width="12%"><COL width="13%"><COL width="6%"><COL width="6%">
  <COL width="9%"><COL width="12%"><COL width="9%"><COL width="9%">
  <TBODY>
  <TR class=Section>
    <TH colSpan=<%=stepcount+4%>>
    <%
		String searchmark = CptSearchComInfo.getMark();
		String searchname =  CptSearchComInfo.getName();   
		String searchdepartmentid =  CptSearchComInfo.getDepartmentid();   
		String searchresourceid =  CptSearchComInfo.getResourceid();   
		String searchstartdate =  CptSearchComInfo.getStartdate();   
		String searchstartdateto =  CptSearchComInfo.getStartdate1();   
		String searchenddate =  CptSearchComInfo.getEnddate();   
		String searchenddateto =  CptSearchComInfo.getEnddate1();   
		String searchstateid =  CptSearchComInfo.getStateid();   
		String searchgroupid =  CptSearchComInfo.getCapitalgroupid();   
		String searchcounttype = CptSearchComInfo.getCountType();   
		
    %>
 	<% if(!searchcounttype.equals("")){%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:
 	<% if(searchcounttype.equals("3")){%><%=SystemEnv.getHtmlLabelName(747,user.getLanguage())%><%}%>
 	<% if(searchcounttype.equals("1")){%><%=SystemEnv.getHtmlLabelName(15320,user.getLanguage())%><%}%>
 	<% if(searchcounttype.equals("2")){%><%=SystemEnv.getHtmlLabelName(15321,user.getLanguage())%><%}%>
	<%}%> 
    <% if(!searchmark.equals("")){%><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%>:<%=Util.toScreen(searchmark,user.getUID())%><%}%>
    <% if(!searchname.equals("")){%>&nbsp;<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>:<%=Util.toScreen(searchname,user.getUID())%><%}%>
    <% if(!searchdepartmentid.equals("")){%>&nbsp;<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>:<%=Util.toScreen(DepartmentComInfo.getDepartmentname(searchdepartmentid),user.getUID())%><%}%>
    <% if(!searchresourceid.equals("")){%>&nbsp;<%=SystemEnv.getHtmlLabelName(1508,user.getLanguage())%>:<%=Util.toScreen(ResourceComInfo.getResourcename(searchresourceid),user.getUID())%><%}%>
    <% if(!searchstartdate.equals("")){%>
    	&nbsp;<%=SystemEnv.getHtmlLabelName(717,user.getLanguage())%>:<%=Util.toScreen(searchstartdate,user.getUID())%>
 	    <%if(!searchstartdate.equals("")){%>
 		  	<%=SystemEnv.getHtmlLabelName(15322,user.getLanguage())%><%=Util.toScreen(searchstartdateto,user.getUID())%>
    <%	}
	  }
	%>
    <% if(!searchenddate.equals("")){%>
    	&nbsp;<%=SystemEnv.getHtmlLabelName(718,user.getLanguage())%>:<%=Util.toScreen(searchenddate,user.getUID())%>
   	    <%if(!searchenddateto.equals("")){%>
	    	<%=SystemEnv.getHtmlLabelName(15322,user.getLanguage())%><%=Util.toScreen(searchenddateto,user.getUID())%>
    <%	}
	  }
    %>
    <% if(!searchstateid.equals("")){%>&nbsp;<%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%>:<%=Util.toScreen(CapitalStateComInfo.getCapitalStatename(searchstateid),user.getLanguage())%><%}%>
    <% if(!searchgroupid.equals("")){%>&nbsp;<%=SystemEnv.getHtmlLabelName(831,user.getLanguage())%>:<%=Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(searchgroupid),user.getUID())%><%}%>
    </TH>
  	<TH colSpan=2 align=right><%=SystemEnv.getHtmlLabelName(1416,user.getLanguage())%>:</TH>
  	<TH colSpan=2 align=right><%=SystemEnv.getHtmlLabelName(1415,user.getLanguage())%>:</TH>
  </TR>
  <TR class=separator>
    <TD class=Sep1 colSpan=<%=stepcount+11%> ></TD></TR>
  <TR class=Header>
  
  <%
  // out excel
   ExcelSheet es = new ExcelSheet() ;
 ExcelRow er = es.newExcelRow () ;
 
  %>
  <% for(int i=1;i<=stepcount;i++){ %>	
  <TD><%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%><%=i%><%=SystemEnv.getHtmlLabelName(15324,user.getLanguage())%></TD>
  <% 
  er.addStringValue(SystemEnv.getHtmlLabelName(178,user.getLanguage())+i) ;
  } %>
    <TD><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1445,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1418,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(904,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1508,user.getLanguage())%></TD>
  </TR>
<%
er.addStringValue(SystemEnv.getHtmlLabelName(714,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(1445,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(1331,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(1418,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(124,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(904,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(602,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(1508,user.getLanguage())) ;

	 es.addExcelRow(er) ;     
int needchange = 0;
int totalline=1;

ArrayList loopal;

//get all assortment
int sumnum = 0;
double sumprice = 0;
int sumassortnum = 0;
double sumassortprice = 0;
int sumallnum = 0;
double sumallprice = 0;
String lastid = "";
boolean flagfirst = true;
String tempid = "";
String assortmentstep = "";
String assortmentname = "";

while(CapitalAssortmentList.next()){
	try{
		tempid = CapitalAssortmentList.getAssortmentId();
		assortmentstep = CapitalAssortmentList.getAssortmentStep();
		assortmentname = CapitalAssortmentList.getAssortmentName();
//		out.print("assortmentname:"+assortmentname);
		loopal = (ArrayList)ht.get(tempid);
		//do capital in each assortment
		for(int i=0;i<loopal.size();i++){
		String cptid = (String)loopal.get(i);
        RecordSet.executeProc("CptCapital_SelectByID",cptid);
	    RecordSet.next();
	    String tempmark = RecordSet.getString("mark");
		String tempcapitalnum = RecordSet.getString("capitalnum");
		String tempname = RecordSet.getString("name");
		String tempresourceid = RecordSet.getString("resourceid");
		String tempcapitalspec = RecordSet.getString("capitalspec");
		String tempstartprice = RecordSet.getString("startprice");
		String tempcapitalgroupid = RecordSet.getString("capitalgroupid");
		String tempstateid =  RecordSet.getString("stateid");
		String remark  = RecordSet.getString("remark");
		String departmentid  = RecordSet.getString("departmentid");
		String temptotal = ""+Util.getDoubleValue(tempstartprice)*(int)(Util.getDoubleValue(tempcapitalnum,0));
%>

<% 
//统计每大类资产数量和价格
String tempassortmentid = tempid;
for(int k=0;k<Util.getIntValue(assortmentstep,0)-1;k++){
  tempassortmentid = CapitalAssortmentComInfo.getSupAssortmentId(tempassortmentid);
}
assortmentname = CapitalAssortmentComInfo.getAssortmentName(lastid);
if(!tempassortmentid.equals(lastid)&&!flagfirst){
%>
  <TR class=<% if(needchange ==0){ needchange=1; %>datalight<%}else{ needchange=0;%>datadark<%}%>>
  <% for(int j=0;j<stepcount;j++){ %>	
    <TD class=Field></TD>
  <% } %>
    <TD class=Field></TD>
    <TD class=Field><%=assortmentname%><%=SystemEnv.getHtmlLabelName(1823,user.getLanguage())%>:</TD>
    <TD class=Field><%=sumassortnum%></TD>
    <TD class=Field></TD>
     <TD class=Field></TD>
   <TD class=Field></TD>
    <TD class=Field></TD>
    <TD class=Field></TD>
  </TR>
  <%
    	sumallnum += sumassortnum;
  		sumallprice += sumassortprice; 
  		sumassortnum  = 0;
  		sumassortprice = 0;
  	} // end if
 	flagfirst = false;
 	er = es.newExcelRow () ;
%>

   <TR class=<% if(needchange ==0){ needchange=1; %>datalight<%}else{ needchange=0;%>datadark<%}%>>
   <% for(int j=1;j<=stepcount;j++){ %>	
    <TD class=Field>
    <% //get assortmentid and name of current level
       tempassortmentid = tempid;
       if(Util.getIntValue(assortmentstep,0)>=j){
		   if(Util.getIntValue(assortmentstep,0)!=j){   
	    	  int t = Util.getIntValue(assortmentstep,0)-j;
	    	  for(int k=0;k<t;k++){
	    	  	tempassortmentid = CapitalAssortmentComInfo.getSupAssortmentId(tempassortmentid);
	    	  }
	       	  assortmentname = 	CapitalAssortmentComInfo.getAssortmentName(tempassortmentid);
	       }
	       else{
	       	  assortmentname = CapitalAssortmentList.getAssortmentName();
	       }// end if
	   if(j==1){
	   		lastid=tempassortmentid;
	   }
    %>
    <%=assortmentname%>
    <% }else{
    	 assortmentname="";
    	}
    	er.addStringValue(assortmentname); %>
    </TD>
   <% 
   	}//end for 
   %>
	<TD class=Field><A href="../capital/CptCapital.jsp?id=<%=cptid%>"><%=tempmark%></A></TD>
    <TD class=Field><%=tempname%></TD>
    <TD class=Field><%=(int)(Util.getDoubleValue(tempcapitalnum,0))%></TD>
    <TD class=Field></TD>
     <TD class=Field><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></TD>
   <TD class=Field><%=tempcapitalspec%></TD>
    <TD class=Field><%=Util.toScreen(CapitalStateComInfo.getCapitalStatename(tempstateid),user.getLanguage())%></TD>
    <TD class=Field><A href="../../hrm/resource/HrmResource.jsp?id=<%=tempresourceid%>">
		<%=Util.toScreen(ResourceComInfo.getResourcename(tempresourceid),user.getLanguage())%>
		</A>
	</TD>
	  </TR>
<%  		
 		
			
			er.addStringValue(tempmark);
			er.addStringValue(tempname);
			er.addValue(tempcapitalnum);
			er.addValue("");
			er.addStringValue(Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage()));
			er.addStringValue(tempcapitalspec);
			er.addValue(Util.toScreen(CapitalStateComInfo.getCapitalStatename(tempstateid),user.getLanguage()));
			er.addStringValue(Util.toScreen(ResourceComInfo.getResourcename(tempresourceid),user.getLanguage()));
			
			
            es.addExcelRow(er) ;
            
			sumnum += Util.getDoubleValue(tempcapitalnum);
			sumprice += Util.getDoubleValue(temptotal);
%>

<% 
//统计每小类资产数量和总价
if((i+1)==loopal.size()) {
%>
  <TR class=<% if(needchange ==0){ needchange=1; %>datalight<%}else{ needchange=0;%>datadark<%}%>>
  <% for(int j=0;j<stepcount;j++){ %>	
    <TD class=Field></TD>
  <% } %>
    <TD class=Field></TD>
    <TD class=Field><%=assortmentname%><%=SystemEnv.getHtmlLabelName(1823,user.getLanguage())%>:</TD>
    <TD class=Field><%=sumnum%></TD>
   <TD class=Field></TD>
     <TD class=Field></TD>
   <TD class=Field></TD>
    <TD class=Field></TD>
    <TD class=Field></TD>
  </TR>
  <%
  		sumassortnum += sumnum;
  		sumassortprice += sumprice; 
  		sumnum  = 0;
  		sumprice = 0;
  	} // end if
%>
<%
		}//end for
     }catch(Exception e){
        //System.out.println(e.toString());
     }
}// end while
%>
<% 
//统计每大类资产数量和价格
String tempassortmentid = tempid;
for(int k=0;k<(Util.getIntValue(assortmentstep,0)-1);k++){
  tempassortmentid = CapitalAssortmentComInfo.getSupAssortmentId(tempassortmentid);
}
assortmentname = CapitalAssortmentComInfo.getAssortmentName(lastid);
if(!flagfirst){
%>
  <TR class=<% if(needchange ==0){ needchange=1; %>datalight<%}else{ needchange=0;%>datadark<%}%>>
  <% for(int j=0;j<stepcount;j++){ %>	
    <TD class=Field></TD>
  <% } %>
    <TD class=Field></TD>
    <TD class=Field><%=assortmentname%><%=SystemEnv.getHtmlLabelName(1823,user.getLanguage())%>:</TD>

    <TD class=Field><%=sumassortnum%></TD>
    <TD class=Field></TD>     
    <TD class=Field></TD>
   <TD class=Field></TD>
    <TD class=Field></TD>
    <TD class=Field></TD>
  </TR>
  <%
    	sumallnum += sumassortnum;
  		sumallprice += sumassortprice; 
  		sumassortnum  = 0;
  		sumassortprice = 0;
  	} // end if
%>
<% //统计所有资产数量和价格 %>
  <TR class=<% if(needchange ==0){ needchange=1; %>datalight<%}else{ needchange=0;%>datadark<%}%>>
  <% for(int j=0;j<stepcount;j++){ %>	
    <TD class=Field></TD>
  <% } %>
    <TD class=Field></TD>
    <TD class=Field><%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%>:</TD>
    <TD class=Field><%=sumallnum%></TD>
    <TD class=Field></TD>
     <TD class=Field></TD>
   <TD class=Field></TD>
    <TD class=Field></TD>
    <TD class=Field></TD>
  </TR>
</TBODY>
</TABLE>
<%
 ExcelFile.init() ;
 ExcelFile.setFilename(SystemEnv.getHtmlLabelName(915,user.getLanguage())) ;
 ExcelFile.addSheet(SystemEnv.getHtmlLabelName(915,user.getLanguage()), es) ;
 %>
</td>
</tr>
</table>
<script>
function onReSearch(){
	location.href="CptRpCapitalCheckStock.jsp";
}
</script>

</body>
</html>
