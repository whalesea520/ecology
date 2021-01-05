
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int	perpage=20;
String lastname = Util.null2String(request.getParameter("lastname"));
String firstname = Util.null2String(request.getParameter("firstname"));
String customer = Util.null2String(request.getParameter("customer"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!lastname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where lastname like '%" + Util.fromScreen2(lastname,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and lastname like '%" + Util.fromScreen2(lastname,user.getLanguage()) +"%' ";
}
if(!firstname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where firstname like '%" + Util.fromScreen2(firstname,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and firstname like '%" + Util.fromScreen2(firstname,user.getLanguage()) +"%' ";
}
if(!customer.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where name like '%" + Util.fromScreen2(customer,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and name like '%" + Util.fromScreen2(customer,user.getLanguage()) +"%' ";
}
String condition = "";
//找到用户能看到的所有客户
String userid = "" + user.getUID();
String loginType = "" + user.getLogintype();
//如果属于总部级的CRM管理员角色，则能查看到所有客户。
String sql = "select id from HrmRoleMembers where  roleid = 8 and rolelevel = 2 and resourceid = " + userid;
rs.executeSql(sql);
if (rs.next()) {
	condition = " (select id,name from CRM_CustomerInfo where deleted=0 or deleted is null) as customerIds ";
} else {
	String leftjointable = CrmShareBase.getTempTable(userid);
	condition = " (select distinct t1.id,t1.name "
		+ " from CRM_CustomerInfo t1 left join " + leftjointable + " t2 on t1.id = t2.relateditemid "
		+ " where t1.id = t2.relateditemid and (t1.deleted=0 or t1.deleted is null)) as customerIds ";
	//condition = " (select " + backFields + " " + sqlFrom + " " + sqlWhere1 + " ) customerIds";
}

String countsql = "select count(distinct CRM_CustomerContacter.id) RecordSetCounts from CRM_CustomerContacter,"+ condition + sqlwhere;
if(ishead ==0) countsql += "where CRM_CustomerContacter.customerid = customerIds.id" ;
else countsql += " and  CRM_CustomerContacter.customerid = customerIds.id" ;
RecordSet.executeSql(countsql);
boolean hasNextPage=false;
int RecordSetCounts = 0;
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}
if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}
int iTotal =RecordSetCounts;
int iNextNum = pagenum * perpage;
int ipageset = perpage;
if(iTotal - iNextNum + perpage < perpage) ipageset = iTotal - iNextNum + perpage;
if(iTotal < perpage) ipageset = iTotal;

String sqlstr = "select distinct top "+iNextNum+" CRM_CustomerContacter.id,fullname,jobtitle,name,customerid from CRM_CustomerContacter,"+condition + sqlwhere;
if(ishead ==0) sqlstr += "where CRM_CustomerContacter.customerid = customerIds.id" ;
else sqlstr += " and  CRM_CustomerContacter.customerid = customerIds.id" ;
sqlstr += " order by CRM_CustomerContacter.customerid desc,CRM_CustomerContacter.id desc";

sqlstr = "select top " + ipageset +" t2.* from (" + sqlstr + ") t2 order by t2.customerid asc,t2.id asc";
sqlstr = "select top " + ipageset +" t3.* from (" + sqlstr + ") t3 order by t3.customerid desc,t3.id desc";
%>
<BODY>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


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

<FORM id="SearchForm" NAME=SearchForm STYLE="margin-bottom:0" action="ContactBrowser.jsp" method=post>
<input type="hidden" id="pagenum" name="pagenum" value="" />
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close()(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=2 id=btnclear onclick="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=ViewForm>
<TR class=Spacing style="height: 1px"><TD class=Line1 colspan=4></TD></TR>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(461,user.getLanguage())%></TD>
<TD width=35% class=field><input  class=InputStyle name=lastname value="<%=lastname%>"></TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(460,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <input class=InputStyle  name=firstname value="<%=firstname%>">
      </TD>
</TR><tr style="height: 1px"><td class=Line colspan=4></td></tr>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></TD>
      <TD width=35% colspan=3 class=field>
        <input class=InputStyle  size=30 name=customer value="<%=customer%>">
      </TD>
</TR><tr style="height: 1px"><td class=Line colspan=4></td></tr>

<TR class=Spacing style="height: 1px"><TD class=Line1 colspan=4></TD></TR>
</table>
<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 width="100%">
<TR class=DataHeader>
<TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>      
      <TH width=20%><%=SystemEnv.getHtmlLabelName(460,user.getLanguage())%></TH>      
	  <TH width=20%><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%></TH>      
	  <TH width=15%><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></TH>
     </tr><TR class=Line style="height: 1px"><TH colSpan=3></TH></TR>
<%
int i=0;
int totalline=1;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String ids = RecordSet.getString("id");
	String fullnames = Util.toScreen(RecordSet.getString("fullname"),user.getLanguage());
	String jobtitles = Util.toScreen(RecordSet.getString("jobtitle"),user.getLanguage());
	String customernames = Util.toScreen(RecordSet.getString("name"),user.getLanguage());
	
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
	<TD><%=fullnames%></td>
	<TD><%=jobtitles%></TD>
	<TD><%=customernames%></TD>	
</TR>
<%
if(hasNextPage){
	totalline+=1;
	if(totalline>perpage)	break;
}
}
%>

</TABLE>
<%
	if(pagenum>1){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:prepage(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	if(hasNextPage){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:nextpage(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
%>
  <input type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script type="text/javascript">

jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
			
		window.parent.returnValue = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()};
			window.parent.close()
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
function prepage(){
	jQuery("#pagenum").val(<%=pagenum-1%>);
	jQuery("#SearchForm").submit();
}
function nextpage(){
	jQuery("#pagenum").val(<%=pagenum+1%>);
	jQuery("#SearchForm").submit();
}
</script>
</BODY></HTML>


