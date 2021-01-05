<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>

<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<script language=javascript src="/js/jquery/jquery_wev8.js"></script>
<%
String cssname = Util.null2String(request.getParameter("cssname"));
String sqlwhere = "";
if(!cssname.equals("")) {
	sqlwhere = " where cssname like '%"+cssname+"%' ";
}
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:clearData(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:topWindowClose(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="WorkFlowCssBrowser.jsp" method=post>
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
				<TD width=20%>
					CSS<%=SystemEnv.getHtmlLabelName(17517,user.getLanguage())%>
				</TD>
				<TD width=80% class=field>
					<input type="text" class="InputStyle" id="cssname" name="cssname" value="<%=cssname%>">
				</TD>
			</TR>
			<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
			<TR class="Spacing" style="height:1px;"><TD class="Line1" colspan=4></TD></TR>
		</table>
		<TABLE ID=BrowseTable class="BroswerStyle" cellspacing="1" width="100%" onmouseover="BrowseTable_onmouseover(event);" onmouseout="BrowseTable_onmouseout(event);" onclick="BrowseTable_onclick(event);">
			<TR class=DataHeader>
				<TH width=0% style="display:none">CSS<%=SystemEnv.getHtmlLabelName(17517,user.getLanguage())%></TH>
				<TH >CSS<%=SystemEnv.getHtmlLabelName(17517,user.getLanguage())%></TH>
			</TR>
			<TR class=Line style="height:1px;"><Th colspan="2" ></Th></TR> 
			<%
				String sql="";
				sql = "select * from workflow_crmcssfile";
				sql += sqlwhere;
				sql += " order by id";

				RecordSet.executeSql(sql);
				int m = 0;
				while(RecordSet.next()){
					int id_tmp = Util.getIntValue(RecordSet.getString("id"));
					String cssname_tmp = Util.null2String(RecordSet.getString("cssname"));
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
				<TD style="display:none"><A HREF="#"><%=id_tmp%></A></TD>
				<td> <%=cssname_tmp%></TD>
			</TR>
			<%
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

var dialog;
var parentWin;
try{
	parentWin = window.parent.parent.parent.getParentWindow(parent);
	dialog = window.parent.parent.parent.getDialog(parent);
	if(!dialog){
		parentWin = parent.parentWin;
		dialog = parent.dialog;
	}
}catch(e){
	
}


function btnclear_onclick(){
	//window.parent.returnValue = {id:"",name:""};
	//window.parent.close();
	var returnjson = {id:"",name:""};
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}
}
function topWindowClose(){
	
	dialog.close();
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

function BrowseTable_onclick(e){
	var e=e||event;
	var target=e.srcElement||e.target;
	if( target.nodeName =="TD"||target.nodeName =="A"  ){
		//window.parent.parent.returnValue = Array(jQuery(jQuery(target).parents("tr")[0].cells[0]).text(),jQuery(jQuery(target).parents("tr")[0].cells[1]).text());
		//window.parent.parent.close();
	    var returnjson = {id:jQuery(jQuery(target).parents("tr")[0].cells[0]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[1]).text()};
		if(dialog){
		    dialog.callback(returnjson);
		}else{  
		    window.parent.returnValue  = returnjson;
		    window.parent.close();
		}
	}
}
function clearData(){
	//window.parent.parent.returnValue = Array("","");
	//window.parent.parent.close();
	btnclear_onclick();
}

function submitData(){
	SearchForm.submit();
}

function submitClear(){
	btnclear_onclick();
}

</script>
