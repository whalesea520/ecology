
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.SplitPageParaBean" %>
<%@ page import="weaver.general.SplitPageUtil" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<% 
if(!HrmUserVarify.checkUserRight("Car:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17631,user.getLanguage());

String needfav ="1";
String needhelp ="";

int perpage = 30;
String linkstr = "CarDriverDataList.jsp?islink=1" ;
int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;

String sql="" ;
String show=Util.fromScreen(request.getParameter("show"),user.getLanguage());
String driverid = Util.fromScreen(request.getParameter("driverid"),user.getLanguage());
String cartype = Util.fromScreen(request.getParameter("cartype"),user.getLanguage());
String startdate1 = Util.fromScreen(request.getParameter("startdate1"),user.getLanguage());
String startdate2 = Util.fromScreen(request.getParameter("startdate2"),user.getLanguage());
//String starttime1 = Util.fromScreen(request.getParameter("starttime1"),user.getLanguage());
//String starttime2 = Util.fromScreen(request.getParameter("starttime2"),user.getLanguage());

if(show.equals("default")){
    Calendar today = Calendar.getInstance();
    String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                         Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                         Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
    int thisyear=today.get(Calendar.YEAR);
    int thismonth=today.get(Calendar.MONTH);
    int thisday=today.get(Calendar.DAY_OF_MONTH)+1;

    int fromday=1;
    int endday=0;
    today.set(thisyear,thismonth,fromday);
    startdate1= Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
    today.set(thisyear,thismonth+1,endday);
    startdate2=Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                   Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                   Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",CarDriverDataAdd.jsp,_self} " ;
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
			
			<TABLE class="Shadow">
			<tr>
			<td valign="top">
			
<form name=frmmain action="CarDriverDataList.jsp">
<table class=viewform>
  <COLGROUP>
  <COL width="20%"><COL width="30%"><COL width="20%"><COL width="30%">
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(17649,user.getLanguage())%></td>
    <TD class=Field>
        <select name="driverid" size=1 style="width:80%" onchange="frmmain.submit()">
        <option value=""><%=SystemEnv.getHtmlLabelName(17650,user.getLanguage())%></option>
<%
     sql="select distinct driverid from cardriverdata";
     RecordSet.executeSql(sql);
     while(RecordSet.next()){
        String tmpdriverid=RecordSet.getString("driverid");
        String tmpdrivername=Util.toScreen(ResourceComInfo.getResourcename(tmpdriverid),user.getLanguage());
        String selected ="" ;
        if(tmpdriverid.equals(driverid))    selected="selected " ;
%>      <option value="<%=tmpdriverid%>" <%=selected%>><%=tmpdrivername%></option>
<%
     }
%>
        </select>
    </TD>
    <td><%=SystemEnv.getHtmlLabelName(17651,user.getLanguage())%></td>
    <td class=field>
        <select name="cartype" size=1 style="width:80%" onchange="frmmain.submit()">
        <option value=""><%=SystemEnv.getHtmlLabelName(17652,user.getLanguage())%></option>
<%
     sql="select * from cartype";
     RecordSet.executeSql(sql);
     while(RecordSet.next()){
        String tmpcartypeid=RecordSet.getString("id");
        String tmpcartypename=RecordSet.getString("name");
        String selected = "" ;
        if(tmpcartypeid.equals(cartype))    selected="selected";
%>      <option value="<%=tmpcartypeid%>" <%=selected%>><%=tmpcartypename%></option>
<%
     }
%>
        </select>
    </td>
  </tr>  
    <td><%=SystemEnv.getHtmlLabelName(17653,user.getLanguage())%></td>
    <TD class=Field><BUTTON type='button' class=Calendar onclick="getStartdate1()"></BUTTON>
    <input type=hidden name="startdate1" value="<%=startdate1%>">
    <SPAN id=startdate1span><%=startdate1%></SPAN>
    </TD>
    <td><%=SystemEnv.getHtmlLabelName(17654,user.getLanguage())%></td>
    <TD class=Field><BUTTON type='button' class=Calendar onclick="getStartdate2()"></BUTTON>
    <input type=hidden name="startdate2" value="<%=startdate2%>">
    <SPAN id=startdate2span><%=startdate2%></SPAN>
  </tr>
</table>
</form>


<br>
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
  <COL width="6%"><COL width="8%"><COL width="2%"><COL width="12%"><COL width="8%"><COL width="8%">
  <COL width="6%"><COL width="6%"><COL width="6%">
  <COL width="6%"><COL width="6%"><COL width="6%"><COL width="15%"><COL width="5%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=14><%=SystemEnv.getHtmlLabelName(17631,user.getLanguage())%></TH></TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(17649,user.getLanguage())%></TD>
    <td><%=SystemEnv.getHtmlLabelName(17651,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(17655,user.getLanguage())%></td>
    <TD><%=SystemEnv.getHtmlLabelName(17656,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(17657,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(17658,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(17659,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(17660,user.getLanguage())%></TD>
    <td><%=SystemEnv.getHtmlLabelName(17661,user.getLanguage())%></td>
    <TD><%=SystemEnv.getHtmlLabelName(17662,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(17663,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(17664,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(17665,user.getLanguage())%></TD>
    <td>&nbsp;</td>
  </TR>
  <TR class=Line><TD colspan="14" ></TD></TR>
<%
    boolean islight=true;
    sql="select * from cardriverdata ";
    String sqlwhere = "" ;
    if(!driverid.equals("")){
        if(sqlwhere.equals(""))
            sqlwhere+=" where driverid =" + driverid ;
        else 
            sqlwhere+=" and driverid =" + driverid ;
    }
    if(!cartype.equals("")){
        if(sqlwhere.equals(""))
            sqlwhere+=" where cartypeid =" + cartype ;
        else 
            sqlwhere+=" and cartypeid =" + cartype ;
    }
    if(!startdate1.equals("")){
        if(sqlwhere.equals(""))
            sqlwhere+=" where startdate >='" + startdate1 + "'" ;
        else 
            sqlwhere+=" and startdate >='" + startdate1 + "'" ;
    }
    if(!startdate2.equals("")){
        if(sqlwhere.equals(""))
            sqlwhere+=" where startdate <='" + startdate2 + "'" ;
        else 
            sqlwhere+=" and startdate <='" + startdate2 + "'" ;
    }
    
    sql=sql + sqlwhere + " order by startdate desc,starttime desc " ;

    String tmpsql="";
        SplitPageParaBean spp = new SplitPageParaBean();

        SplitPageUtil spu = new SplitPageUtil();

 

        spp.setBackFields("id,driverid,cartypeid,isreception,startdate,starttime,backdate,backtime,runKM,runtime,normalkm,overtimekm,normaltime,overtime");

        spp.setSqlFrom("cardriverdata");

        spp.setSqlWhere(sqlwhere);         

        spp.setSqlOrderBy ("startdate");                      

        spp.setPrimaryKey("starttime");           

        spp.setSortWay(spp.DESC);           //如果是升序可省略

        spu.setSpp(spp);

        int recordCount = spu.getRecordCount() ;

        RecordSet rsPage = spu.getCurrentPageRs(pagenum,perpage);


			 while(rsPage.next()){
    	String	id=rsPage.getString("id");
    	String	driverid1=rsPage.getString("driverid");
    	String	cartypeid=rsPage.getString("cartypeid");
    	String  isreception=rsPage.getString("isreception");
    	String	startdate=rsPage.getString("startdate");
    	String	starttime=rsPage.getString("starttime");
    	String	backdate=rsPage.getString("backdate");
    	String	backtime=rsPage.getString("backtime");
    	String  runKM=rsPage.getString("runKM");
    	String  runtime = rsPage.getString("runtime");
    	String normalkm=rsPage.getString("normalkm");
    	String overtimekm=rsPage.getString("overtimekm");
    	String normaltime=rsPage.getString("normaltime");
    	String overtime=rsPage.getString("overtime");
    	
    	tmpsql="select * from cartype where id="+cartypeid ;
    	rs.executeSql(tmpsql);
    	rs.next();
    	String cartypename=rs.getString("name");
    	
    	String drivername=Util.toScreen(ResourceComInfo.getResourcename(driverid1),user.getLanguage());
    	
    	String paradesc="";
    	tmpsql="select t1.* from carparameter t1,cardriverdatapara t2 where t1.id=t2.paraid and t2.driverdataid="+id ;
    	rs.executeSql(tmpsql);
    	while(rs.next()){
    	    paradesc+=","+rs.getString("name");
    	}
    	if(!paradesc.equals(""))    paradesc=paradesc.substring(1);
%>
    <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
        <TD><%=drivername%></TD>
        <TD><%=cartypename%></TD>
        <td><%if(isreception.equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%> <%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> <%}%></td>
        <TD><%=startdate%></TD>
        <td><%=starttime%></td>
        <TD><%=backtime%></TD>
        <td><%=runKM%></td>
        <td><%=normalkm%></td>
        <td><%=overtimekm%></td>
        <td><%=runtime%></td>
        <td><%=normaltime%></td>
        <td><%=overtime%></td>
        <td><%=paradesc%></td>
        <td><a href="CarDriverDataEdit.jsp?id=<%=id%>"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></a></td>
    </TR>
<%
        islight=!islight ; 
    }
%>  <td></td>
		</tr>
		<tr>
			<td height="10" colspan="3"></td>
		</tr>
<%



        
%>
	</table>
<TABLE width="100%" border=0>
  <TBODY>
  <TR>
    <TD noWrap><%=Util.makeNavbar2(pagenum, recordCount , perpage, linkstr)%></TD>
  </TR>
  </TBODY>
</TABLE>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
