<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
String check_per = Util.null2String(request.getParameter("wfids"));
ArrayList chk_per = new ArrayList();
chk_per = Util.TokenizerString(check_per,",",false);

String fullname = Util.null2String(request.getParameter("fullname"));
String description = Util.null2String(request.getParameter("description"));
int typeid=Util.getIntValue(request.getParameter("typeid"),0);
String sqlwhere = " ";
int ishead = 0;

if(!fullname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where typename like '%";
		sqlwhere += Util.fromScreen2(fullname,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " typename like '%";
		sqlwhere += Util.fromScreen2(fullname,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!description.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where typedesc like '%";
		sqlwhere += Util.fromScreen2(description,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and   typedesc like '%";
		sqlwhere += Util.fromScreen2(description,user.getLanguage());
		sqlwhere += "%'";
	}
}
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


<FORM NAME=SearchForm STYLE="margin-bottom:0" action="WFTypeMutiBrowser.jsp" method=post>
<div style="display:none">
<button type=button  class=btn accessKey=O id=btnok onclick="btnok_onclick()"><U>O1</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
</div>

<input type=hidden name="wfids" value="<%=check_per%>">
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

<TR style="height:1px;"><TD class=Line colSpan=6></TD></TR> 
<tr>
<TD ><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
<TD  class=field><input class=Inputstyle name=fullname value="<%=fullname%>"></TD>
<TD ><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
<TD  class=field><input class=Inputstyle  name=description value="<%=description%>"></TD>
</TR>
<TR class="Spacing"  style="height:1px;"><TD class="Line" colspan=6></TD></TR>
</table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" width="100%">
<TR class=DataHeader>
<TH width="10%" style="padding-left:0px;"><input type=checkbox name="check_perAll" onclick="checkperAll(this.checked)"></TH>
<TH width=45%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TH>
<TH width=45%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH></tr>

<TR class=Line  style="height:1px;"><th colspan="3" ></Th></TR> 
<%
int i=0;
sqlwhere = "select * from workflow_type "+sqlwhere;
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
	<td><input type=checkbox name="check_per" value="<%=RecordSet.getString(1)%>" <%=ischecked%>>
	</td>
	<TD><%=RecordSet.getString(2)%></TD>
	<TD><%=RecordSet.getString(3)%></TD>
	
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

 <script language="javascript">
function checkperAll(ischecked){
    jQuery("input[name='check_per']").each(function(){
    	jQuery(this).attr("checked",ischecked);
    	if(ischecked){
        	jQuery(this).next().addClass("jNiceChecked");
        }else{
        	jQuery(this).next().removeClass("jNiceChecked");
        }
    });
    
}
function btnclear_onclick() {
     window.parent.returnValue = {id: "0",name: ""};
     window.parent.close();
}

function btnok_onclick() {
    var idssz = "";
    var namessz = "";
    jQuery("input[name='check_per']").each(function(){
    	var obj =jQuery(this)
    	if(obj.attr("checked")){
    		idssz +=obj.val()+",";
    		namessz +=obj.parent().parent().next().html()+",";
    	}
    });
	window.parent.returnValue = {id: idssz+"", name: namessz+""};
    window.parent.close();
}


//多选
jQuery(document).ready(function(){
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
		$(this).addClass("Selected")
	})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
		$(this).removeClass("Selected")
	})

});

function onSubmit() {
	$G("SearchForm").submit()
}
function onReset() {
	jQuery("input[name='fullname']").val("");
	jQuery("input[name='description']").val("");
	$G("SearchForm").submit();
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