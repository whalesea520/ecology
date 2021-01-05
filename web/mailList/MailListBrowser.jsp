<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>  <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser_wev8.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
String resourceids ="";
String resourcenames ="";
String check_per = ","+Util.null2String(request.getParameter("resourceids"))+",";
String name = Util.null2String(request.getParameter("name"));

String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));

String strtmp = "select id,name from webMailList ";
RecordSet.executeSql(strtmp);
while(RecordSet.next()){
	if(check_per.indexOf(","+RecordSet.getString("id")+",")!=-1){
		 	resourceids +="," + RecordSet.getString("id");
		 	resourcenames += ","+RecordSet.getString("name");
	}
}
int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!name.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and t1.name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";
}

String sqlstr = "";
if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.id != 0 " ;
}

int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int	perpage=50;


String temptable = "mailListTempTable"+ Util.getNumberRandom() ;

if(RecordSet.getDBType().equals("oracle")){

		sqlstr = "create table "+temptable+"  as select * from (select t1.* from webMailList  t1 "+ sqlwhere +" order by t1.id  desc) where rownum<"+ (pagenum*perpage+2);

}else{
		sqlstr = "select top "+(pagenum*perpage+1)+" t1.* into "+temptable+" from webMailList  t1 "+ sqlwhere + " order by t1.id desc";  
}

//添加判断权限的内容--new*/
RecordSet.executeSql(sqlstr);
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
}else{
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+"  order by id";
}
RecordSet.executeSql(sqltemp);

%>
<BODY>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="MailListBrowser.jsp" method=post>
  <input type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input type="hidden" name="pagenum" value=''>
    <input type="hidden" name="resourceids" value="">
<DIV align=right>
<BUTTON type="button" class=btnSearch accessKey=S id=btnsub onclick="btnsub_onclick()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<BUTTON  class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<BUTTON type="button" class=btn accessKey=O id=btnok onclick="btnok_onclick()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
<BUTTON type="button" class=btn accessKey=2 id=btnclear onclick="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=form>
<TR class=separator><TD class=Sep1 colspan=4></TD></TR>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(460,user.getLanguage())%></TD>
<TD width=35% class=field><input name=name value="<%=name%>"></TD>
<TD width=15%></TD>
<TD width=35% class=field></TD>
</TR>
<TR class=separator><TD class=Sep1 colspan=4></TD></TR>
</table>
<TABLE ID=BrowseTable class=Data STYLE="margin-top:0">
<TR class=DataHeader>
<TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      
 <TH width=5%></TH>  
      <TH><%=SystemEnv.getHtmlLabelName(460,user.getLanguage())%></TH>      
	  <TH><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TH>
<%

int i=0;
int totalline=1;
if(RecordSet.last()){
	do{
	String ids = RecordSet.getString("id");
	String names = Util.toScreen(RecordSet.getString("name"),user.getLanguage());
	String mailDescs = Util.toScreen(RecordSet.getString("mailDesc"),user.getLanguage());
	if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
<%
}
%>
	<TD style="display:none"><A HREF=#><%=ids%></A></TD>
	<%
	 String ischecked = "";
	 if(check_per.indexOf(","+ids+",")!=-1){
	 	ischecked = " checked ";
	 }%>
	<TD><input type=checkbox name="check_per" value="<%=ids%>" <%=ischecked%>></TD>
	
	<td><%=names%></TD>
	<TD><%=mailDescs%></TD>
</TR>
<%
	if(hasNextPage){
		totalline+=1;
		if(totalline>perpage)	break;
	}
}while(RecordSet.previous());
}
RecordSet.executeSql("drop table "+temptable);
%>
</TABLE>
<table align=right>
<tr>
   <td>&nbsp;</td>
   <td>
	   <%if(pagenum>1){%>
			<button type=submit class=btn accessKey=P onclick="document.all('pagenum').value=<%=pagenum-1%>;"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage()) %></button>
	   <%}%>
   </td>
   <td>
	   <%if(hasNextPage){%>
			<button type=submit class=btn accessKey=N onclick="document.all('pagenum').value=<%=pagenum+1%>;"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage()) %></button>
	   <%}%>
   </td>
   <td>&nbsp;</td>
</tr>
</table>
</FORM>
<script type="text/javascript">
var resourceids = "<%=resourceids%>";
var resourcenames = "<%=resourcenames%>";

//多选
jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(event){
		if(event.target.tagName=="TR"){
			var obj = $(this).find("input[name=check_per]");
		   	if (obj.attr("checked")=="true"){
		   		obj.attr("checked","false");
		   		ids = ids.replace(","+$(this).find("td:first").text(),"")
		   		names = names.replace(","+$(this).find("td:eq(2)").text(),"")

		   	}else{
		   		obj.attr("checked","true");
		   		ids = ids + "," + $(this).find("td:first").text();
		   		names = names + "," + $(this).find("td:eq(2)").text();
		   	}

		}	
		//window.parent.returnValue = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()};
		//	window.parent.close()
		})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			$(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
			$(this).removeClass("Selected")
		})

})

function submitClear()
{
	window.parent.returnValue = {id:"",name:""};
	window.parent.close()
}
  
function btnok_onclick(){
	window.parent.returnValue ={id:resourceids,name:resourcenames}
	window.parent.close();
}

function btnsub_onclick(){
	document.all("resourceids").value = resourceids
	document.SearchForm.submit();
}

</script>
</BODY></HTML>
