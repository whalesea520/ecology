<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.systemright.CheckSubCompanyRight" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />


<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />

<HTML><HEAD>
<%
String formname = Util.null2String(request.getParameter("formname"));
	
%>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_top} " ;//搜索
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:searchReset(),_top} " ;//重新设置
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;//清除
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top} " ;//取消
RCMenuHeight += RCMenuHeightStep ;

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="WfFormBrowser.jsp" method=post>
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



<table width=100% class=viewform>
<TR>
<TD width=20%><!-- 自定义表单 -->
  <%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></tr>
</TD>
<TD width=80% class=field><input name=formname value="<%=formname%>" class="InputStyle"></TD>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR> 
<TR class="Spacing" style="height:1px;">
      <TD class="Line1" colspan=4></TD>
    </TR>
</table>
<TABLE ID=BrowseTable class="BroswerStyle" cellspacing="1" width="100%" >
<TR class=DataHeader>
<TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH><!-- 名称 -->
  <TH ><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></TH></tr><!-- 自定义表单 -->
  <TR class=Line style="height:1px;"><Th colspan="2" ></Th></TR> 
    <%
    RecordSet.executeSql("select * from workflow_bill where id<0 and invalid is null");
    int m = 0;
    while(RecordSet.next()){
    	int tmpid = RecordSet.getInt("id");
    	int tmplable = RecordSet.getInt("namelabel");
     	String checktmp = "";
     	String tablename = RecordSet.getString("tablename");
     	if(tablename.equals("formtable_main_"+tmpid*(-1))){
	     	String lbname = SystemEnv.getHtmlLabelName(tmplable,user.getLanguage());
	     	if(!formname.equals("") && lbname.indexOf(formname)==-1) continue;
				m++;
	        	if(m%2==0) {
	        %>
				<TR class=DataLight>
				<%
					}else{
				%>
				<TR class=DataDark>
				<%
				}
				%>
					<TD style="display:none"><A HREF=#><%=tmpid%></A></TD>
					<td> <%=lbname%></TD>
				</TR>
		<%}
	}
	%>
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

</FORM>
</BODY></HTML>

<script type="text/javascript">
function btnclear_onclick(){
	window.parent.returnValue = {id:"",name:""};
	window.parent.close();
}

function BrowseTable_onmouseover(e){
	e=e||event;
   var target=e.srcElement||e.target;
   if("TD"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }else if("A"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }
}
function BrowseTable_onmouseout(e){
	var e=e||event;
   var target=e.srcElement||e.target;
   var p;
	if(target.nodeName == "TD" || target.nodeName == "A" ){
      p=jQuery(target).parents("tr")[0];
      if( p.rowIndex % 2 ==0){
         p.className = "DataDark"
      }else{
         p.className = "DataLight"
      }
   }
}
jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
	jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
})
function BrowseTable_onclick(e){
   var e=e||event;
   var target=e.srcElement||e.target;

   if( target.nodeName =="TD"||target.nodeName =="A"  ){
     window.parent.parent.returnValue = {id:jQuery(jQuery(target).parents("tr")[0].cells[0]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[1]).text()};
	 window.parent.parent.close();
	}
}


function submitData()
{
	if (check_form(SearchForm,''))
		SearchForm.submit();
}

function submitClear()
{
	btnclear_onclick();
}

function nextPage(){
	document.all("pagenum").value=parseInt(document.all("pagenum").value)+1 ;
	SearchForm.submit();	
}

function perPage(){
	document.all("pagenum").value=document.all("pagenum").value-1 ;
	SearchForm.submit();
}

function searchReset() {
	SearchForm.formname.value='';
}
</script>


