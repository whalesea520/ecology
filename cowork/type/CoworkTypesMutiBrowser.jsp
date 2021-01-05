<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
String check_per = Util.null2String(request.getParameter("coworkTypeIds"));
ArrayList chk_per = new ArrayList();
chk_per = Util.TokenizerString(check_per,",",false);

String documentids = "" ;
String documentnames ="";

if (!check_per.equals("")) {
	String strtmp = "select id,typename,departmentid from cowork_types where id in ("+check_per+")";
	RecordSet.executeSql(strtmp);
	while(RecordSet.next()){
			documentids +="," + RecordSet.getString("id");
			documentnames += ","+RecordSet.getString("typename");
	}
}


String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));

int coworkTypeId=Util.getIntValue(request.getParameter("coworkTypeId"),0);
String coworkTypeName = Util.null2String(request.getParameter("coworkTypeName"));

String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}


if(coworkTypeId!=0){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where  id = '";
		sqlwhere += coworkTypeId;
		sqlwhere += "'";
	}
	else{
		sqlwhere += " and id = '";
		sqlwhere += coworkTypeId;
		sqlwhere += "'";
	}
}
if(!"".equals(coworkTypeName)){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where typename like '%";
		sqlwhere += Util.fromScreen2(coworkTypeName,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and typename like '%";
		sqlwhere += Util.fromScreen2(coworkTypeName,user.getLanguage());
		sqlwhere += "%'";
	}
}

//out.println(sqlwhere);
%>
<BODY>


<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:onReset(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<FORM NAME=SearchForm STYLE="margin-bottom:0" action="DocMainCategoryMutiBrowser.jsp" method=post>
<div style="display:none">
<button type=button  class=btn accessKey=O id=btnok onclick="btnok_onclick()"><U>O1</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
</div>
<input type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere1)%>">

<%--added by XWJ on 2005-03-16 for td:1549--%>

<input type=hidden name="mainCategoryIds" value="<%=check_per%>">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="*">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top" width="100%">



<table width=100% class="viewform">

<tr>
<TD ><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TD>
<TD  class=field><input class=Inputstyle name=coworkTypeId value="<%=coworkTypeId%>"></TD>
<TD ><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
<TD  class=field><input class=Inputstyle  name=coworkTypeName value="<%=coworkTypeName%>"></TD>
</TR>
<TR class="Spacing"  style="height:1px;"><TD class="Line1" colspan=6></TD></TR>
</table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" width="100%">
<TR class=DataHeader>
<th></th>
<TH width=10% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
<TH width=60%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
</tr>

<TR class=Line  style="height:1px;"><th colspan="3" ></Th></TR> 
<%
int i=0;
sqlwhere = "select * from cowork_types "+sqlwhere;

//System.out.println("sql = "+sqlwhere);
//System.out.println("sqlWhere1 = "+sqlwhere1);
RecordSet.execute(sqlwhere);
while(RecordSet.next()){
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

	<%
	 String ischecked = "";
	 if(chk_per.contains(RecordSet.getString("id"))){
		ischecked = " checked ";
	 }
	 %>
	<td style="width:50px"><input type=checkbox name="check_per" value="<%=RecordSet.getString("id")%>" <%=ischecked%>>
	</td>
	<TD style="display:none"><A HREF=#><%=RecordSet.getString("id")%></A></TD>
	<TD><%=RecordSet.getString("typename")%></TD>
	<TD><%=RecordSet.getString("id")%></TD>
	
</TR>
<%}%>
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

</FORM></BODY></HTML>

<SCRIPT LANGUAGE="javascript">
var ids = "<%=documentids%>";
var names = "<%=documentnames%>";


function btnclear_onclick() {
     window.parent.returnValue = {id: "0",name: ""};
     window.parent.close();
}

//对返回的值进行id排序
//参考http://bbs.csdn.net/topics/390580999
function sortnumber(a,b){
	return a[0] - b[0];
}
function btnok_onclick() {
	var idssz=ids.split(',');
	var namessz=names.split(',');
	for(var i=0;i<idssz.length;i++) idssz[i]=[idssz[i],namessz[i]];
	idssz.sort(sortnumber);
	for(var i=0;i<idssz.length;i++) {
	    namessz[i]=idssz[i][1];
	    idssz[i]=idssz[i][0];
	}
	//alert(idssz+"--"+namessz);
	window.parent.returnValue = {id: idssz+"", name: namessz+""};//Array(documentids,documentnames)
    window.parent.close();
}


//多选
jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(event){
		if($(this)[0].tagName=="TR"&&event.target.tagName!="INPUT"){
			var obj = jQuery(this).find("input[name=check_per]");
		   	if (obj.attr("checked") == true){
		   		   obj.attr("checked", false);
		   		ids = ids.replace("," + jQuery(this).find("td:eq(1)").text(), "")
		   		names = names.replace("," + jQuery(this).find("td:eq(2)").text(), "")

		   	}else{
		   		    obj.attr("checked", true);
		   		ids = ids + "," + jQuery(this).find("td:eq(1)").text();
		   		names = names + "," + jQuery(this).find("td:eq(2)").text();
		   	}

		}
		//点击checkbox框
	    if(event.target.tagName=="INPUT"){
	       var obj = jQuery(this).find("input[name=check_per]");
		   	if (obj.attr("checked") == true){
		   	    ids = ids + "," + jQuery(this).find("td:eq(1)").text();
		   		names = names + "," + jQuery(this).find("td:eq(2)").text();
		   	}else{
		   		ids = ids.replace("," + jQuery(this).find("td:eq(1)").text(), "")
		   		names = names.replace("," + jQuery(this).find("td:eq(2)").text(), "")
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

});


</SCRIPT>

 <script language="javascript">

 function onSubmit() {
		$G("SearchForm").submit()
	}
	function onReset() {
		$G("SearchForm").reset()
	}
 
function submitData()
{
	btnok_onclick();
}

function submitClear()
{
	btnclear_onclick();
}

</script>