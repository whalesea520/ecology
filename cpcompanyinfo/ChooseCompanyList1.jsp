
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

<%

String companyid = Util.null2String(request.getParameter("companyid"));
String se_fieldname = Util.null2String(request.getParameter("se_fieldname"));
String se_fielddesc = Util.null2String(request.getParameter("se_fielddesc"));
String sql="";
if("sqlserver".equals(rs.getDBType())){
	 sql = "select t1.*,(case substring(t1.archivenum,0,1) when 'L' then 1 when 'H' then 2 when 'R' then 3 when 'W' then 4 end ) as ablity from CPCOMPANYINFO t1 where t1.isdel='T' and t1.companyid !='"+companyid+"' ";
}else{
	 sql = "select t1.*,(case substr(t1.archivenum,0,1) when 'L' then 1 when 'H' then 2 when 'R' then 3 when 'W' then 4 end ) as ablity from CPCOMPANYINFO t1 where t1.isdel='T' and t1.companyid !='"+companyid+"' ";
}
if(!"".equals(se_fieldname)){
	sql+=" and ARCHIVENUM like '%"+se_fieldname+"%'";
}
if(!"".equals(se_fielddesc)){
	sql+=" and COMPANYNAME like '%"+se_fielddesc+"%'";
}
sql+=" order by ablity asc,t1.archivenum asc";
rs.execute(sql);
//System.out.println("执行的sql==============="+sql);
int i = 1;

%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onseach(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:dialog.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>




<div class="zDialog_div_content">

<form action="/cpcompanyinfo/ChooseCompanyList1.jsp" method="post"  id="SearchForm">
	<input type="hidden" name="companyid"  value="<%=companyid %>" >
	
	<table width=100% class="viewform">
						<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
						<tr>
						<TD ><%=SystemEnv.getHtmlLabelNames("128191",user.getLanguage())%></TD>
						<TD  class=field>
								<input type='text' name='se_fieldname' value='<%=se_fieldname%>'>
						</TD>
						<TD ><%=SystemEnv.getHtmlLabelNames("1976",user.getLanguage())%></TD>
						<TD  class=field>
								<input type='text' name='se_fielddesc' value='<%=se_fielddesc%>'>
						</TD>
						</TR>
						<TR class="Spacing"  style="height:1px;"><TD class="Line1" colspan=2></TD></TR>
	</table>
	
<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item attributes="{'isTableList':'true'}">
				<wea:layout type="table" attributes="{'cols':'3','layoutTableId':'BrowseTable'}" needImportDefaultJsAndCss="false">
					<wea:group context="" attributes="{'groupDisplay':'none'}">
						<wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("22089",user.getLanguage())%>ID</wea:item>
						<wea:item  type="thead"><%=SystemEnv.getHtmlLabelNames("128191",user.getLanguage())%></wea:item>
						<wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("1976",user.getLanguage())%></wea:item>
						
							<%
										while(rs.next()){
											if(i%2==0){
												out.println("<tr class=DataDark>");
											}else{
												out.println("<tr class=DataLight>");
											}	
							%>
							<wea:item ><%=rs.getString("COMPANYID") %></wea:item>
							<wea:item><%=rs.getString("ARCHIVENUM") %></wea:item>
							<wea:item><%=rs.getString("COMPANYNAME") %></wea:item>
						<%
							i++;
						} %>
					</wea:group>
				</wea:layout>
			</wea:item>
		</wea:group>	
	</wea:layout>
</form>
</div>





<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btnclear_onclick();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script type="text/javascript">

var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}catch(e){}


jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
})


function BrowseTable_onclick(e){

  var e=e||event;
  var target=e.srcElement||e.target;
	
  if( target.nodeName =="TD"||target.nodeName =="A"  ){
      var returnValue = {id:jQuery.trim(jQuery(jQuery(target).parents("tr")[0].cells[0]).text()),name:jQuery(jQuery(target).parents("tr")[0].cells[2]).text()};
		if(dialog){
			dialog.callback(returnValue);
			// dialog.close();
		}else{
			
	       window.parent.returnValue  = returnValue;
	       window.parent.close();
		}
	}
}

function btnclear_onclick(){
    var returnValue = {id:"",name:""};
	if(dialog){
		dialog.callback(returnValue);
	}else{
       window.parent.returnValue  = returnValue;
       window.parent.close();
	}
}
function onseach(){
	$("#SearchForm").submit()
}
</script>
</BODY></HTML>

