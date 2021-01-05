<%@ page import="weaver.general.Util,weaver.file.*" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="HrmSearchComInfo" class="weaver.hrm.search.HrmSearchComInfo" scope="session"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="RpResourceDefine" class="weaver.hrm.report.RpResourceDefine" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String userid =""+user.getUID();
/*权限判断,人力资产管理员以及其所有上级*/
boolean canView = false;
ArrayList allCanView = new ArrayList();
String tempsql ="select resourceid from HrmRoleMembers where resourceid>1 and roleid in (select roleid from SystemRightRoles where rightid=22)";
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
String dbtype=RecordSet.getDBType() ;
if(tempsearchsql.indexOf("cus_fielddata")>0){ //inner join
if(dbtype.equalsIgnoreCase("oracle"))
tempsearchsql=Util.replace(tempsearchsql,"where",",cus_fielddata where hrmresource.id=cus_fielddata.id and  cus_fielddata.scopeid=1 and ",1);
else
tempsearchsql=Util.replace(tempsearchsql,"where",",cus_fielddata where hrmresource.id=cus_fielddata.id and cus_fielddata.scopeid=1 and ",1);
}else{//left join
    if(dbtype.equalsIgnoreCase("oracle"))
    tempsearchsql=Util.replace(tempsearchsql,"where",",cus_fielddata where hrmresource.id=cus_fielddata.id(+) and  cus_fielddata.scopeid(+)=1 and ",1);
    else
     tempsearchsql = "left join cus_fielddata on hrmresource.id=cus_fielddata.id and cus_fielddata.scopeid=1 " +tempsearchsql;
}



//",cus_fielddata "+tempsearchsql;
   //System.out.println("tempsearchsql:"+tempsearchsql);
HrmSearchComInfo.resetSearchInfo();    
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
RCMenu += "{Excel,/weaver/weaver.file.ExcelOut,ExcelOut} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
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
<table border=0 width=100%>
 <tr>
<td>
<TABLE class=ListStyle cellspacing=1 >
<TBODY>
<TR class=Header>
<TH colSpan=50><%=SystemEnv.getHtmlLabelName(15929,user.getLanguage())%></TH>
</TR>
<TR class=Header>

<%
   ExcelFile.init ();
   String filename = SystemEnv.getHtmlLabelName(15929,user.getLanguage());
   ExcelFile.setFilename(""+filename) ;

   // 下面建立一个头部的样式, 我们系统中的表头都采用这个样式!
   ExcelStyle es = ExcelFile.newExcelStyle("Header") ;
   es.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
   es.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
   es.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
   es.setAlign(ExcelStyle.WeaverHeaderAlign) ;

   ExcelSheet et = ExcelFile.newExcelSheet(""+filename) ;

   ExcelRow er = null ;
   er = et.newExcelRow() ;

ArrayList header = RpResourceDefine.getHeader(userid);
for(int i = 0;i<header.size();i++){
  String head = (String)header.get(i);
  er.addStringValue(head,"Header") ;
%>
          <TD><%=head%></TD>

<%}%>
        </TR>
  <TR class=Line><TD colspan=<%=header.size()%> ></TD></TR>


        <%
int needchange = 0;
ArrayList content = new ArrayList();
RpResourceDefine.setUserlanguage(user.getLanguage());
content = RpResourceDefine.getContent(tempsearchsql);
for(int i =0;i<content.size();i++){
  ExcelRow erdep = et.newExcelRow() ;
  ArrayList al = new ArrayList();
    al = (ArrayList)content.get(i);
    if(al!=null&&al.size()>0){ 
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

        for(int j=0;j<al.size();j++){
          String show = (String)al.get(j);
		  String excelshow=show;
		  if(excelshow.indexOf("<input type=checkbox value=1 name=")>=0&&excelshow.indexOf(" checked>")>=0){
			  excelshow="1";
		  }
		  excelshow=Util.replace(excelshow,"<[^>]+>","",0);
          erdep.addStringValue(excelshow);
  %>
          <TD><%=Util.toScreen(show,7)%></TD>
<%}%>
        </TR>
<%
    }
}
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
</BODY></HTML>
