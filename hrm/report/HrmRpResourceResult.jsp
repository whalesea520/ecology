<%@ page import="weaver.general.Util,weaver.file.*" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="HrmSearchComInfo" class="weaver.hrm.search.HrmSearchComInfo" scope="session"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String userid =""+user.getUID();

/*权限判断,人力资产管理员以及其所有上级*/
boolean canView = false;
ArrayList allCanView = new ArrayList();
String tempsql = "select resourceid from HrmRoleMembers where roleid = 4 ";
RecordSet.executeSql(tempsql);
while(RecordSet.next()){
	String tempid = RecordSet.getString("resourceid");
	allCanView.add(tempid);
	AllManagers.getAll(tempid);
	while(AllManagers.next()){
		allCanView.add(AllManagers.getManagerID());
	}
}// end while

for (int i=0;i<allCanView.size();i++){
	if(userid.equals((String)allCanView.get(i))){
		canView = true;
	}
}

if(!canView) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*权限判断结束*/

String tempsearchsql = HrmSearchComInfo.FormatSQLSearch();

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+SystemEnv.getHtmlLabelName(352,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:onReSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{Excel,/weaver/weaver.file.ExcelOut,_self} " ;
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
<table border=1 width=100%>
  <tr>
<td>
      <TABLE class=ListStyle cellspacing=1 >
        <COLGROUP> 
        <COL width="5%"> 
        <COL width="5%"> 
        <COL width="5%"> 
        <COL width="5%"> 
        <COL width="5%"> 
        <COL width="5%"> 
        <COL width="5%"> 
        <COL width="5%"> 
        <COL width="5%"> 
        <COL width="5%"> 
        <COL width="3%"> 
        <COL width="5%"> 
        <COL width="5%"> 
        <COL width="5%"> 
        <COL width="5%"> 
        <COL width="5%"> 
        <COL width="5%"> 
        <COL width="7%"> 
        <COL width="5%"> 
        <TBODY> 
        <TR class=Header> 
          <TH colSpan=19><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())+SystemEnv.getHtmlLabelName(352,user.getLanguage())%></TH>
        </TR>
        
        </TR>
        <TR> 
          <TD height="1"><img src="/images/spacer_wev8.gif" width="100" height="1"></TD>
          <TD height="1"><img src="/images/spacer_wev8.gif" width="50" height="1"></TD>
          <TD height="1"><img src="/images/spacer_wev8.gif" width="90" height="1"></TD>
          <TD height="1"><img src="/images/spacer_wev8.gif" width="150" height="1"></TD>
          <TD height="1"><img src="/images/spacer_wev8.gif" width="50" height="1"></TD>
          <TD height="1"><img src="/images/spacer_wev8.gif" width="50" height="1"></TD>
          <TD height="1"><img src="/images/spacer_wev8.gif" width="90" height="1"></TD>
          <TD height="1"><img src="/images/spacer_wev8.gif" width="150" height="1"></TD>
          <TD height="1"><img src="/images/spacer_wev8.gif" width="60" height="1"></TD>
          <TD height="1"><img src="/images/spacer_wev8.gif" width="60" height="1"></TD>
          <TD height="1"><img src="/images/spacer_wev8.gif" width="100" height="1"></TD>
          <TD height="1"><img src="/images/spacer_wev8.gif" width="150" height="1"></TD>
          <TD height="1"><img src="/images/spacer_wev8.gif" width="100" height="1"></TD>
          <TD height="1"><img src="/images/spacer_wev8.gif" width="60" height="1"></TD>
          <TD height="1"><img src="/images/spacer_wev8.gif" width="60" height="1"></TD>
          <TD height="1"><img src="/images/spacer_wev8.gif" width="60" height="1"></TD>
          <TD height="1"><img src="/images/spacer_wev8.gif" width="60" height="1"></TD>
          <TD height="1"><img src="/images/spacer_wev8.gif" width="60" height="1"></TD>
          <TD height="1"><img src="/images/spacer_wev8.gif" width="60" height="1"></TD>
        </TR>

        <TR class=Header> 
          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(1516,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(1909,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(1884,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(1900,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(469,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(1901,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(1887,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(1517,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(1518,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(1519,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(1904,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(1898,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(1502,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(1923,user.getLanguage())%></TD>
        </TR>
        <TR class=Line><TD colspan="19" ></TD></TR> 
        <%
//Excel相关
ExcelSheet es = new ExcelSheet();
ExcelRow er = es.newExcelRow ();

er.addStringValue(SystemEnv.getHtmlLabelName(124,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(413,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(1516,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(1915,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(1909,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(416,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(1884,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(1900,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(469,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(1901,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(1887,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(1517,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(421,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(1518,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(1519,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(1904,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(1898,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(1502,user.getLanguage())) ;
er.addStringValue(SystemEnv.getHtmlLabelName(1923,user.getLanguage())) ;

es.addExcelRow(er) ;

//sql = "select top "+(pagenum*perpage+1)+" * into "+temptable+" from CptUseLog "+sql+" order by usedate desc";
//rs.execute(sql);   
//
//rs.executeSql("Select count(id) RecordSetCounts from "+temptable);
//boolean hasNextPage=false;
//int RecordSetCounts = 0;
//if(rs.next()){
//	RecordSetCounts = rs.getInt("RecordSetCounts");
//}
//if(RecordSetCounts>pagenum*perpage){
//	hasNextPage=true;
//}
//String sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+"  order by usedate";
//rs.executeSql(sqltemp);(被下面的搜索语句代替)


String sql = "select * from HrmResource "+tempsearchsql;
rs.executeSql(sql);

int needchange = 0;
    while(rs.next()){
        String  id = rs.getString("id");
     if(!id.equals("1")){  //过滤系统管理员
        String	departmentid=Util.toScreen(rs.getString("departmentid"),user.getLanguage());
        String	lastname=Util.toScreen(rs.getString("lastname"),user.getLanguage());
        String	startdate=Util.toScreen(rs.getString("startdate"),user.getLanguage());
        String	jobtitle=Util.toScreen(rs.getString("jobtitle"),user.getLanguage());
        String	joblevel=Util.toScreen(rs.getString("joblevel"),user.getLanguage());
        String	sex=Util.toScreen(rs.getString("sex"),user.getLanguage());
        String	birthday=Util.toScreen(rs.getString("birthday"),user.getLanguage());
        String	regresidentplace=Util.toScreen(rs.getString("regresidentplace"),user.getLanguage());
        String	maritalstatus=Util.toScreen(rs.getString("maritalstatus"),user.getLanguage());
        String	policy=Util.toScreen(rs.getString("policy"),user.getLanguage());
        String	certificatenum=Util.toScreen(rs.getString("certificatenum"),user.getLanguage());
        String	residentplace=Util.toScreen(rs.getString("residentplace"),user.getLanguage());
        String	residentphone=Util.toScreen(rs.getString("residentphone"),user.getLanguage());
        String	school= "";
        String	enddate="";
        String	speciality="";
        String	educationlevel="";
        String	certs="";
		if(rs1.getDBType().equals("oracle")){
			sql="select * from (select * from HrmEducationInfo where resourceid = "+id+" order by enddate desc) where rownum=1 ";
		}else{
			sql= "select top 1 * from HrmEducationInfo where resourceid = "+id+" order by enddate desc ";
		}        
       
        rs1.executeSql(sql);
        if(rs1.next()){
	        school=Util.toScreen(rs1.getString("school"),user.getLanguage());
	        enddate=Util.toScreen(rs1.getString("enddate"),user.getLanguage());
	        speciality=Util.toScreen(rs1.getString("speciality"),user.getLanguage());
	        educationlevel=Util.toScreen(rs1.getString("educationlevel"),user.getLanguage());
        }
        sql = "select certname from HrmCertification where resourceid = "+id+" order by id ";
        rs1.executeSql(sql);
        String tempname = "";
        while(rs1.next()){
        	 tempname=Util.toScreen(rs1.getString("certname"),user.getLanguage());  
        	 certs+=","+tempname;
        }
        if(!certs.equals("")){
        	certs=certs.substring(1);   
        }
        
        er = es.newExcelRow () ;
        er.addStringValue(Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage()));
		er.addStringValue(Util.toScreen(ResourceComInfo.getResourcename(id),user.getLanguage()));
		er.addStringValue(startdate);
		er.addStringValue(Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobtitle),user.getLanguage()));
		er.addStringValue(joblevel);
		if(sex.equals("0")){
			er.addStringValue(SystemEnv.getHtmlLabelName(417,user.getLanguage()));
		}
		else{
			er.addStringValue(SystemEnv.getHtmlLabelName(418,user.getLanguage()));
		}
		er.addStringValue(birthday);
		er.addStringValue(regresidentplace);
		if(maritalstatus.equals("0")){er.addStringValue(SystemEnv.getHtmlLabelName(470,user.getLanguage()));}
        else if(maritalstatus.equals("1")){er.addStringValue(SystemEnv.getHtmlLabelName(471,user.getLanguage()));}
        else if(maritalstatus.equals("2")){er.addStringValue(SystemEnv.getHtmlLabelName(472,user.getLanguage()));}
		er.addStringValue(policy);
		er.addStringValue(certificatenum);
		er.addStringValue(residentplace);
		er.addStringValue(residentphone);
		er.addStringValue(school);
		er.addStringValue(enddate);
		er.addStringValue(speciality);
		er.addStringValue(educationlevel);
		er.addStringValue(certs);
		es.addExcelRow(er) ;
		
       try{
       	if(needchange ==0){
       		needchange = 1;
%>
        <TR class=datalight> 
          <%
  	}else{
  		needchange=0;
  %>
        <TR class=datadark> 
          <%  	}
  %>
          <TD><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></TD>
          <TD><A HREF="../resource/HrmResource.jsp?id=<%=id%>"><%=Util.toScreen(ResourceComInfo.getResourcename(id),user.getLanguage())%></A></TD>
          <TD><%=startdate%></TD>
          <TD><%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobtitle),user.getLanguage())%> 
          </TD>
          <TD><%if(!joblevel.equals("0")) out.print(joblevel);%> </TD>
          <TD> 
            <%if(sex.equals("0")){%>
            <%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%> 
            <%}%>
            <%if(sex.equals("1")){%>
            <%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%> 
            <%}%>
          </TD>
          <TD><%=birthday%> </TD>
          <TD><%=regresidentplace%> </TD>
          <TD> 
            <%if(maritalstatus.equals("0")){%>
            <%=SystemEnv.getHtmlLabelName(470,user.getLanguage())%> 
            <%}%>
            <%if(maritalstatus.equals("1")){%>
            <%=SystemEnv.getHtmlLabelName(471,user.getLanguage())%> 
            <%}%>
            <%if(maritalstatus.equals("2")){%>
            <%=SystemEnv.getHtmlLabelName(472,user.getLanguage())%> 
            <%}%>
          </TD>
          <TD><%=policy%> </TD>
          <TD><%=certificatenum%> </TD>
          <TD><%=residentplace%> </TD>
          <TD><%=residentphone%> </TD>
          <TD><%=school%> </TD>
          <TD><%=enddate%> </TD>
          <TD><%=speciality%> </TD>
          <TD><%=educationlevel%></TD>
          <TD><%=certs%> </TD>
          <TD> </TD>
        </TR>
        <% // if(hasNextPage){
//		totalline+=1;
//		if(totalline>perpage)	break;
//	 }
      }catch(Exception e){
       rs.writeLog(e.toString());
      }
     }//end if
    };
// rs.executeSql("drop table "+temptable);

 ExcelFile.init() ;
 ExcelFile.setFilename(SystemEnv.getHtmlLabelName(179,user.getLanguage())+SystemEnv.getHtmlLabelName(352,user.getLanguage())) ;
 ExcelFile.addSheet(SystemEnv.getHtmlLabelName(179,user.getLanguage())+SystemEnv.getHtmlLabelName(352,user.getLanguage()), es) ;
%>
        </TBODY> 
      </TABLE>
</td>
</tr>
</table>
</FORM>
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
<script language=javascript>
function onReSearch(){
	location.href="HrmRpResource.jsp";
}
</script>
</BODY>
</HTML>