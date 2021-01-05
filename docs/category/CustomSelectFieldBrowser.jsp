<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>

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
<FORM NAME=SearchForm STYLE="margin-bottom:0" method=post>
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type='button' class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
</DIV>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
<TR class=DataHeader>
<TH width=20%>ID</TH>
<TH width=80%><%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%></TH>
</tr><TR class=Line><TH colspan="4" ></TH></TR>
<%
int i=0;
String sql = "select * from cus_selectitem order by fieldid,fieldorder";
RecordSet.execute(sql);
int preFieldId = -1;
boolean isFirst = true;
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
    if(RecordSet.getInt("fieldid")!= preFieldId){
        preFieldId = RecordSet.getInt("fieldid");

    %>
    <TD><A HREF=#><%=RecordSet.getInt("fieldid")%></A></TD>
    <TD>
        <select style="width:200">
            <%
        if(isFirst){
            isFirst = false;
            %>
            <option><%=RecordSet.getString("selectname")%>
            <%
        }
        RecordSet.previous();
        while(RecordSet.next()){
            if(RecordSet.getInt("fieldid")!= preFieldId){
                RecordSet.previous();
                break;
            }
            %>
            <option><%=RecordSet.getString("selectname")%>
                <%
        }
                %>
        </select>
    </TD>
    <%}%>

</TR>
<%}%>
</TABLE></FORM>
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
	jQuery("#BrowseTable").find("tr").bind("click",function(event){
			if(event.target.nodeName=="SELECT")
				return;
			window.parent.returnValue = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().html()};
			window.parent.close()
		})
	jQuery("#BrowseTable").find("tr").bind("mouseover",function(){
			$(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr").bind("mouseout",function(){
			$(this).removeClass("Selected")
		})

})
function submitClear()
{
	window.parent.returnValue = {id:"",name:""};
	window.parent.close()
}
</script>
</BODY></HTML>

