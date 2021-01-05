<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
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
String description = Util.null2String(request.getParameter("description"));
String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(!description.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.summary like '%";
		sqlwhere += Util.fromScreen2(description,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and t1.summary like '%";
		sqlwhere += Util.fromScreen2(description,user.getLanguage());
		sqlwhere += "%'";
	}
}
%>
<BODY>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="proj"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("587",user.getLanguage()) %>'/>
</jsp:include>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_top} " ;
//RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:dialog.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
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

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="ProjectStatusBrowser.jsp" method=post>
<input type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere1)%>">





<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
		<wea:item><input name=fullname value='<%=fullname%>' class="InputStyle"></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
		<wea:item><input name=description value='<%=description%>' class="InputStyle"></wea:item>
	</wea:group>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item></wea:item>
	</wea:group>
</wea:layout>

<%



String orderby =" t1.dsporder ";
String tableString = "";
int perpage=10;                                 
String backfields = " t1.id,t1.fullname,t1.description,t1.dsporder,t1.summary";
String fromSql  = " Prj_ProjectStatus t1 join HtmlLabelInfo t2 on t1.fullname=t2.indexid and t2.languageid="+user.getLanguage()+" ";
if(!"".equals(fullname) ){
	fromSql+= " and t2.labelname like '%"+Util.fromScreen2(fullname,user.getLanguage())+"%' ";
}
tableString =   " <table instanceid=\"BrowseTable\" id=\"BrowseTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"asc\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"0%\" hide='true'  text=\""+"ID"+"\" column=\"id\"    />"+
                "           <col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelNames("399",user.getLanguage())+"\" column=\"fullname\" orderkey=\"fullname\" transmethod='weaver.systeminfo.SystemEnv.getHtmlLabelNames' otherpara='"+""+user.getLanguage()+"'   />"+
                "           <col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelNames("433",user.getLanguage())+"\" column=\"summary\" orderkey=\"summary\"  />"+
                "       </head>"+
                " </table>";
%>

<wea:SplitPageTag  tableString='<%=tableString %>'  mode="run" />




</FORM>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="btnclear_onclick();">
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

<script	language="javascript">
function replaceToHtml(str){
	var re = str;
	var re1 = "<";
	var re2 = ">";
	do{
		re = re.replace(re1,"&lt;");
		re = re.replace(re2,"&gt;");
        re = re.replace(",","，");
	}while(re.indexOf("<")!=-1 || re.indexOf(">")!=-1)
	return re;
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

</script>
