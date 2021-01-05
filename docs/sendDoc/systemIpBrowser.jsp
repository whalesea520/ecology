<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<%
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String name = Util.null2String(request.getParameter("name"));
String ip = Util.null2String(request.getParameter("ip"));

String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));

/*==========*/
String check_per = ","+Util.null2String(request.getParameter("ids"))+",";
String ids = "" ;
String names ="";
String strtmp = "select id,name from systemIp ";
RecordSet.executeSql(strtmp);
while(RecordSet.next()){
	if(check_per.indexOf(","+RecordSet.getString("id")+",")!=-1){

		 	ids +="," + RecordSet.getString("id");
		 	names += ","+RecordSet.getString("name");
	}
}
/*==========*/


if(!sqlwhere.equals("")) {
    if(!name.equals("")){
     sqlwhere += " and name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";
    }
}
else{
    if(!name.equals("")){
     sqlwhere += " where name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";
    }
}

if(!sqlwhere.equals("")) {
    if(!ip.equals("")){
     sqlwhere += " and ip like '%" + Util.fromScreen2(ip,user.getLanguage()) +"%' ";
    }
}
else{
    if(!ip.equals("")){
     sqlwhere += " where ip like '%" + Util.fromScreen2(ip,user.getLanguage()) +"%' ";
    }
}

String sqlstr ="";
String userid=""+user.getUID();
sqlstr = "select * from systemIp "+sqlwhere+" order by id  desc ";
%>

</HEAD>

<BODY>
<TR class=Line style="height: 1px"><TH colSpan=4></TH></TR>

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

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="systemIpBrowser.jsp" method=post>
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:btnsub_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S id=btnsub onclick="btnsub_onclick()" type="button"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btn accessKey=O id=btnok onclick="btnok_onclick()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type='button' class=btn accessKey=C id=btnclear onclick="submitClear()"><U>C</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=ViewForm>
<TR class=Spacing style="height: 1px">
<TD class=Line1 colspan=5></TD></TR>
<TR>
    <TD width=15%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
    <TD width=35% class=field>
        <input class=InputStyle  name=name value="<%=name%>" size=20>
    </TD>
    <TD width=15%><%=SystemEnv.getHtmlLabelName(16989,user.getLanguage())%> </TD>
    <TD class=Field width=35%>
        <input class=InputStyle  name=ip value="<%=ip%>" size=20>
    </TD>

</TR>
<TR class=Spacing><TD class=Line1 colspan=4></TD></TR>

</table>
<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 width="100%">
<TR class=DataHeader>
      <TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
	 <TH width=5%></TH>
     <TH width=20%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
      <TH width=20%><%=SystemEnv.getHtmlLabelName(16989,user.getLanguage())%></TH>
      </tr><TR class=Line><TH colSpan=5></TH></TR>
<%
int i=0;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String idTemp = RecordSet.getString("id");
	String nameTemp = Util.toScreen(RecordSet.getString("name"),user.getLanguage());
	String ipTemp = RecordSet.getString("ip");
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
	<TD style="display:none"><A HREF=#><%=idTemp%></A></TD>

	 <%
	 String ischecked = "";
	 if(check_per.indexOf(","+idTemp+",")!=-1){
	 	ischecked = " checked ";
	 }%>
	<TD><input type=checkbox name="check_per" value="<%=idTemp%>" <%=ischecked%>></TD>
	<TD><%=nameTemp%></TD>
	<TD>http://<%=ipTemp%></TD>
</TR>
<%}
%>

</TABLE>
  <input type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input type="hidden" name="ids" value="">
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
var ids = "<%=ids%>"
var names = "<%=names%>"
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
			//window.parent.close()
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
	window.parent.returnValue = {id:ids,name:names}
	window.parent.close()
}

function btnsub_onclick(){
	document.all("ids").value = ids
	document.SearchForm.submit();
}

function CheckAll(checked) {
//	alert(ids);
//	ids = "";
//	names = "";
	len = document.SearchForm.elements.length;
	var i=0;
	for( i=0; i<len; i++) {
		if (document.SearchForm.elements[i].name=='check_per') {
			if(!document.SearchForm.elements[i].checked) {
				ids = ids + "," + document.SearchForm.elements[i].parentElement.parentElement.cells(0).innerText;
		   		names = names + "," + document.SearchForm.elements[i].parentElement.parentElement.cells(2).innerText;
		   	}
		   	document.SearchForm.elements[i].checked=(checked==true?true:false);
		}
 	}
 //	alert(ids);
}
</script>
</BODY></HTML>