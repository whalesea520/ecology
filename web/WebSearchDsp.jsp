<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/web/inc/init1.jsp" %>
<%@ include file="/web/inc/WebServer.jsp" %>
<jsp:useBean id="DocNewsManager" class="weaver.docs.news.DocNewsManager" scope="page" />
<jsp:useBean id="DocNewsComInfo" class="weaver.docs.news.DocNewsComInfo" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="DocTypeComInfo" class="weaver.docs.type.DocTypeComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="SysDefaultsComInfo" class="weaver.docs.tools.SysDefaultsComInfo" scope="page" />
<jsp:useBean id="PicUploadManager" class="weaver.docs.tools.PicUploadManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetImg" class="weaver.conn.RecordSet" scope="page"/>
<%@ include file="/docs/common.jsp" %>
<%
String userName = "";
String usertype = "1" ;
String seclevel = "0" ; 
userName =  user.getUsername() ;
usertype = ""+user.getType() ;
seclevel = ""+user.getSeclevel() ;

//获取参数及设置基本变量
String bgcolor = Util.null2String(request.getParameter("bgcolor"));
if (bgcolor.equals("")) bgcolor = "#FFFFFF" ;
String searchKey = Util.null2String(request.getParameter("searchKey"));
searchKey = searchKey.trim();//如果搜不出注意转码的问题
String key = Util.null2String(request.getParameter("key"));//栏目名称
key = key.trim();
if(key.equals("null")) key = "" ;
if(searchKey.equals("null")) searchKey = "" ;
int intervalType = Util.getIntValue(request.getParameter("intervalType"),0);//时间区间 1:周，2：月，3：年
Calendar today = Calendar.getInstance();
String selectDate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

int selectyear=Util.getIntValue(selectDate.substring(0,4));
int selectmonth=Util.getIntValue(selectDate.substring(5,7))-1;
int selectday=Util.getIntValue(selectDate.substring(8,10));  

switch(intervalType) {
	case 1:
		Date thedate = today.getTime() ;
		int diffdate = (-1)*thedate.getDay()-1 ;//thedate.getDay()为当星期的第几天由于西方星期的第一天为星期日再-1
		today.add(Calendar.DATE,diffdate) ;
		today.add(Calendar.DATE,1);
		break ;
	case 2:
		today.set(selectyear,selectmonth,1) ;
		break;
	case 3:
		today.set(selectyear,0,1) ;
		break;
}

selectDate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

switch (intervalType) {
	case 1 :
		today.add(Calendar.WEEK_OF_YEAR,1) ;
		break ;
	case 2:
		today.add(Calendar.MONTH,1) ;		
		break ;
	case 3:
		today.add(Calendar.YEAR,1) ;
		break;
}

String selectToDate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

int id = 0;
int start= Util.getIntValue(request.getParameter("start"),1);
int hstart = Util.getIntValue(request.getParameter("hstart"),1);
int recordersize = 0;
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=0;

String linkstr="";

String frontpagename = "" ;
String frontpagedesc = "" ;
String isactive = "" ;
int departmentid = 0 ;
String linktype = "" ;
String hasdocsubject = "" ;
String hasfrontpagelist = "" ;
int newsperpage = 0 ;
int titlesperpage = 0 ;
int defnewspicid = 0 ;
int backgroundpicid = 0 ;
int importdocid = 0 ;
int headerdocid = 0 ;
int footerdocid = 0 ;
String secopt = "" ;
int seclevelopt = 0;
int departmentopt = 0;
int dateopt = 0;
int languageopt = 0 ;
int languageid = 7 ;
String clauseopt = "" ;
String newsclause = "" ;
int defaultimgid= 0 ;
int defaultimgwidth=0;
int publishtype = 0;
int RecordSetCounts = 0;
//获取新闻页基本信息
String temptable = "WebSearchTemp"+ Util.getRandom() ;
String temptable2 = "WebSearchTempT"+ Util.getRandom() ;
String sql="" ;
String sqlTemp = "" ;
String newsclauseTemp = "" ;
String newsIds = "" ;
boolean isOracle = false;
isOracle = RecordSet.getDBType().equals("oracle");
boolean isdb2 = false;
isdb2 = RecordSet.getDBType().equals("db2");
sqlTemp = "select distinct newsId from webSite where type='2' or type='3' or type='5' or type='8' "; //指定栏目时
RecordSet.executeSql(sqlTemp);
while (RecordSet.next()) {
	newsIds += RecordSet.getString("newsId") + ",";
}
int isInsert = 0 ;//用来循环的第一次创建temptable临时表
if (!key.equals(""))
	sqlTemp = "select distinct newsId from webSite where linkKey = '" + key + "' and (type='2' or type='3' or type='5' or type='8')"; //指定栏目时
else
{
	sqlTemp = "select id from DocFrontpage " ;
	if (!newsIds.equals("")) 
	{
		newsIds = newsIds.substring(0,newsIds.length()-1);
		sqlTemp += " where id in (" + newsIds + ") ";
	}
	else
		sqlTemp += " where id = 0 ";
}
RecordSet.executeSql(sqlTemp);
while (RecordSet.next()) {
	if (!key.equals(""))
		id = Util.getIntValue(RecordSet.getString("newsId"),0); //指定栏目时
	else
		id = Util.getIntValue(RecordSet.getString("id"),0);
	if(id != 0) {
		DocNewsManager.resetParameter();
		DocNewsManager.setId(id);
		DocNewsManager.getDocNewsInfoById();
		publishtype = DocNewsManager.getPublishtype();
		frontpagename = DocNewsManager.getFrontpagename();
		frontpagedesc = DocNewsManager.getFrontpagedesc();
		isactive = DocNewsManager.getIsactive();
		departmentid = DocNewsManager.getDepartmentid();
		linktype = DocNewsManager.getLinktype();
		hasdocsubject = DocNewsManager.getHasdocsubject();
		hasfrontpagelist = DocNewsManager.getHasfrontpagelist();
		newsperpage = DocNewsManager.getNewsperpage();
		titlesperpage = DocNewsManager.getTitlesperpage();
		defnewspicid = DocNewsManager.getDefnewspicid();
		backgroundpicid = DocNewsManager.getBackgroundpicid();
		importdocid =  Util.getIntValue(DocNewsManager.getImportdocid());
		headerdocid = DocNewsManager.getHeaderdocid();
		footerdocid = DocNewsManager.getFooterdocid();
		secopt = DocNewsManager.getSecopt();
		seclevelopt = DocNewsManager.getSeclevelopt();
		departmentopt = DocNewsManager.getDepartmentopt();
		dateopt = DocNewsManager.getDateopt();
		languageopt = DocNewsManager.getLanguageopt();
		languageid = DocNewsManager.getLanguageid();
		clauseopt = Util.toScreenToEdit(DocNewsManager.getClauseopt(),languageid);
		newsclause = DocNewsManager.getNewsclause();

		DocNewsManager.closeStatement();
		perpage = newsperpage; 		
		
		if(publishtype == 0) //如publishtype不为0则需要判断权限
			{
				if (isInsert==0) 
				sql="select id,docsubject,doclastmoddate,doclastmodtime into "+temptable+" from DocDetail " ;
				else 
				sql="select id,docsubject,doclastmoddate,doclastmodtime from DocDetail " ;

				if (!newsclause.equals("")) newsclause = " where " + newsclause ;
				sql += newsclause + " and (docsubject like '%" + searchKey + "%') ";
			}
			else
				{
					if (isInsert==0) 
						if(isOracle){	
							sql="create table "+temptable+" as select 	t1.id,t1.docsubject,t1.doclastmoddate,doclastmodtime  from DocDetail  t1, "+tables+"  t2 " ;
						 }else if(isdb2){	
							sql="create table "+temptable+" as (select 	t1.id,t1.docsubject,t1.doclastmoddate,doclastmodtime  from DocDetail  t1, "+tables+"  t2 )definition only " ;
						    rs.executeSql(sql);
							sql="insert into "+temptable+" (select t1.id,t1.docsubject,t1.doclastmoddate,doclastmodtime  from DocDetail  t1, "+tables+"  t2 )" ;
						}else{
							sql="select t1.id,t1.docsubject,t1.doclastmoddate,doclastmodtime into "+temptable+" from DocDetail  t1, "+tables+"  t2 " ;
						}
					else
					sql="select t1.id,t1.docsubject,t1.doclastmoddate,doclastmodtime from DocDetail  t1, "+tables+"  t2 " ;

					if (!newsclause.equals("")) newsclause = " and " + newsclause ;
					if(!logintype.equals("2")) {
							sql +=" where t1.id=t2.sourceid " + newsclause + " and (t1.docsubject like '%" + searchKey + "%') ";
					}
					else {
							sql +=" where t1.id=t2.sourceid " + newsclause + " and (t1.docsubject like '%" + searchKey + "%') ";
					}
				}
		sql += " and  docstatus in ('1','2','5') " ;
		if(intervalType>0)
			sql += " and (doclastmoddate>='" + selectDate +"' and doclastmoddate<'" + selectToDate +"') ";
		rs.executeSql(sql);
		if (isInsert!=0)
			{
				String idTemp = "" ;
				String docsubjectTemp = "" ;
				String doccreatedateTemp = "" ;
				String doccreatetimeTemp= "" ;
				while (rs.next())
				{	
					idTemp = rs.getString("id");
					docsubjectTemp = Util.fromScreen2(rs.getString("docsubject"),language);
					doccreatedateTemp = Util.fromScreen2(rs.getString("doclastmoddate"),language);
					doccreatetimeTemp = Util.fromScreen2(rs.getString("doclastmodtime"),language);
					sqlTemp = "INSERT INTO "+temptable+" VALUES ("+idTemp+",'"+docsubjectTemp+"','"+doccreatedateTemp+"','"+doccreatetimeTemp+"')";
					rs1.executeSql(sqlTemp);
				}
			}

		isInsert++ ;
	}
}
if(isOracle){
	sql = "create table "+temptable2+" as select * from (select distinct id ,docsubject,doclastmoddate,doclastmodtime from " + temptable + " order by doclastmoddate asc, doclastmodtime asc ) where rownum<"+ (pagenum*perpage+2) ;
}else if(isdb2){
	sql = "create table "+temptable2+" as (select distinct id ,docsubject,doclastmoddate,doclastmodtime from " + temptable + " )definition only " ;
    RecordSet.executeSql(sql);
	sql = "insert into " + temptable2 + " (select distinct  id ,docsubject,doclastmoddate,doclastmodtime  from " + temptable + " order by doclastmoddate asc, doclastmodtime asc fetch first "+(pagenum*perpage+1)+" rows only )" ;
}else{
	sql = "select distinct top "+(pagenum*perpage+1)+" id ,docsubject,doclastmoddate,doclastmodtime into " + temptable2 + " from " + temptable + " order by doclastmoddate asc, doclastmodtime asc " ;
}
RecordSet.executeSql(sql);
RecordSet.executeSql("drop table "+temptable);
RecordSet.executeSql("Select count(id) RecordSetCounts from "+temptable2);
boolean hasNextPage=false;
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}
if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}
if(isOracle){
	sql="select * from (select * from "+temptable2+" order by doclastmoddate desc, doclastmodtime desc) where rownum<"+ (RecordSetCounts-(pagenum-1)*perpage) ;
}else if(isdb2){
    sql="select  * from "+temptable2+" order by doclastmoddate desc, doclastmodtime desc fetch first  "+(RecordSetCounts-(pagenum-1)*perpage)+" rows only " ;
}else{
	sql="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable2+" order by doclastmoddate desc, doclastmodtime desc " ;
}
RecordSet.executeSql(sql);

%>
<HTML><HEAD>
<META http-equiv=Content-Type content="text/html; charset=UTF-8">
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<BODY bgcolor="<%=bgcolor%>">
<FORM id=form1 name=form1  method="post"  action="/web/WebSearchDsp.jsp">
<input type=hidden id=pagenum name=pagenum value="<%=pagenum%>">
<input type=hidden id=searchKey name=searchKey value="<%=Util.toScreen(searchKey,language,"0")%>">
  <TABLE class=form valign=top>
	<TBODY> 
	<tr> 
	<tr>
		<td>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" valign=top>
		  <tr>
			<td width="100%" valign=top> 
				  <table class=form valign=top>
						<%
							String docid= "" ;
							String docsubject= "" ;							
							String doclastmoddate= "" ;
							while(RecordSet.next()){
							docid=RecordSet.getString("id");	
							docsubject=RecordSet.getString("docsubject");							
							doclastmoddate=RecordSet.getString("doclastmoddate");
							RecordSetImg.executeSql("select imagefileid from DocImageFile where docid = " + docid + " and docfiletype = '1' ");
							int curimgid = 0 ;
							if (RecordSetImg.next())
							curimgid = Util.getIntValue(RecordSetImg.getString("imagefileid"),0);
						%>
						<tr> 
						  <td width=5% valign="top"><img src="/web/images/i_wev8.gif" align="absmiddle"></td>
						  <td width=95% valign=top > 
							<a href="<%=webServer%>/web/WebDetailDsp.jsp?newsid=<%=id%>&id=<%=docid%>&languageid=<%=language%>" target="_blank"><%=docsubject%></a>
							<%if(curimgid>0){%>&nbsp;&nbsp;[图文]<%}%>
						  </td>
						</tr>
						<%
							}
						%>					
				  </table>
			</td>
		  </tr>
		  
		  </tr>
		  <tr><td>&nbsp</td><td></td></tr>
		  <tr>
			  <!--主题新闻分页导航:begin-->
			  <td align=center  noWrap > 
				<%if(pagenum>1){%>
					<button class=btn accessKey=P onclick='OnSubmit(<%=pagenum-1%>)'><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button>
				<%}
				if(hasNextPage){%>
					<button class=btn accessKey=N onclick='OnSubmit(<%=pagenum+1%>)'><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button>
				<%}%>	
			  </td>
			  <!--主题新闻分页导航:end-->			 
		  </tr>
		</table>
	  </td>
	</tbody> 
  </table>
</FORM>
<%
	RecordSet.executeSql("drop table "+temptable2);
%>
<SCRIPT language="javascript">
function OnSubmit(pagenum){
		document.form1.pagenum.value = pagenum;
		document.form1.submit();
}
</script>
</body>
<%if (RecordSetCounts==0){%>
没有相关记录！
<%}%>