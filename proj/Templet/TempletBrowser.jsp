<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>

<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">
var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}catch(e){}
</script>
</HEAD>
<%
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String fullname = Util.null2String(request.getParameter("fullname"));
String status = Util.null2String(request.getParameter("status"));
String updatedate = Util.null2String(request.getParameter("updatedate"));
String updatedate1 = Util.null2String(request.getParameter("updatedate1"));
String sqlwhere = " where 1=1 ";
if(!"".equals(status)){
	sqlwhere+=" and status='"+status+"' ";
}
if(!"".equals(fullname)){
	sqlwhere+=" and templetName like '%"+fullname+"%' ";
}
if(!"".equals(updatedate)){
	sqlwhere+=" and updatedate >='"+updatedate+"' ";
}
if(!"".equals(updatedate1)){
	sqlwhere+=" and updatedate <='"+updatedate1+"' ";
}


%>
<BODY>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="proj"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("18375",user.getLanguage()) %>'/>
</jsp:include>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_top} " ;
//RCMenuHeight += RCMenuHeightStep;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:SearchForm.reset(),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:dialog.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("197",user.getLanguage())%>" class="e8_btn_top"  onclick="submitData()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="TempletBrowser.jsp" method=post>
<input type=hidden name=sqlwhere value="<%=sqlwhere1%>">




<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></wea:item>
		<wea:item><input name=fullname value='<%=fullname%>' class="InputStyle"></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
		<wea:item>
			<select name="status">
				<option value=""></option>
				<option value="1" <%="1".equals(status)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
				<option value="0" <%="0".equals(status)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%></option>
				<option value="2" <%="2".equals(status)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(2242,user.getLanguage())%></option>
			</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(19521,user.getLanguage())%></wea:item>
		<wea:item>
			<span class="wuiDateSpan" selectId="updatedate_sel" selectValue="">
				  <input class=wuiDateSel type="hidden" name="updatedate" value="<%=updatedate %>">
				  <input class=wuiDateSel  type="hidden" name="updatedate1" value="<%=updatedate1 %>">
			</span>
		</wea:item>
	</wea:group>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item></wea:item>
	</wea:group>
</wea:layout>


<%



String orderby =" updatedate ";
String tableString = "";
int perpage=10;                                 
String backfields = " id,templetName,updatedate,status,(case status when '1' then 225 when '2' then 2242 else 220 end) statuslabel ";
String fromSql  = " Prj_Template ";

tableString =   " <table instanceid=\"BrowseTable\" id=\"BrowseTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"desc\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"0%\" hide='true'  text=\""+"ID"+"\" column=\"id\"    />"+
                "           <col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(18151,user.getLanguage())+"\" column=\"templetName\" orderkey=\"templetName\"   />"+
                "           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"statuslabel\" orderkey=\"statuslabel\" transmethod='weaver.systeminfo.SystemEnv.getHtmlLabelNames' otherpara='"+""+user.getLanguage()+"'   />"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(19521,user.getLanguage())+"\" column=\"updatedate\" orderkey=\"updatedate\"  />"+
                "       </head>"+
                " </table>";
%>

<wea:SplitPageTag  tableString='<%=tableString %>'  mode="run" />



</FORM>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="submitClear();">
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


</BODY></HTML>
<script language="javascript">
function submitData()
{
	if (check_form(SearchForm,''))
		SearchForm.submit();
}

function submitClear()
{
	btnclear_onclick();
}

function BrowseTable_onclick(e){
   var e=e||event;
   var target=e.srcElement||e.target;

   if( target.nodeName =="TD"||target.nodeName =="A"  ){
	   if(dialog){
		   var returnjson={id:jQuery(jQuery(target).parents("tr")[0].cells[1]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[2]).text()};
		   try{
	            dialog.callback(returnjson);
	       }catch(e){}
		  	try{
		       dialog.close(returnjson);
		   }catch(e){}
	   }else{
		window.parent.parent.returnValue = {id:jQuery(jQuery(target).parents("tr")[0].cells[1]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[2]).text()};
		window.parent.parent.close();
	   }
     
	}
}

function btnclear_onclick(){
	if(dialog){
		var returnjson={id:"",name:""};
		try{
            dialog.callback(returnjson);
       }catch(e){}
	  	try{
	       dialog.close(returnjson);
	   }catch(e){}
	}else{
		window.parent.parent.returnValue = {id:"",name:""};
		window.parent.parent.close();
	}
	
}
$(function(){
	$("#_xTable").find("table.ListStyle").live('click',BrowseTable_onclick);
});
</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
