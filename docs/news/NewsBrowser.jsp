
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<HTML>


<HEAD>
<LINK REL=stylesheet type="text/css" HREF="/css/Weaver_wev8.css">

</HEAD>
<%
String name = Util.null2String(request.getParameter("name"));
String publishtype =  Util.null2String(request.getParameter("publishtype"));
String sqlwhere = "";
int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!name.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where frontpagename like '%" +name+"%' ";
	}
	else 
		sqlwhere += " and frontpagename like '%" +name +"%' ";
}

String sqlstr = "";
if(ishead==0){
		ishead = 1;
		sqlwhere += " where id != 0 " ;
}
if(!sqlwhere.equals(""))
{
	if(!publishtype.equals(""))
	{
		ishead = 1;
		sqlwhere += "  and publishtype="+publishtype+" " ;
	}
}
else
{
	if(!publishtype.equals(""))
	{
		ishead = 1;
		sqlwhere += "  where publishtype="+publishtype+" " ;
	}
}
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
//int perpage=Util.getIntValue(request.getParameter("perpage"),0);
int	perpage=30;
//添加判断权限的内容--new


String temptable = "newstemptable"+ Util.getNumberRandom() ;
String news_SearchSql = "";
//System.out.println("sqlwhere:"+sqlwhere);
if(RecordSet.getDBType().equals("oracle")){
	if(user.getLogintype().equals("1")){
		news_SearchSql = "create table "+temptable+"  as select * from (select id, frontpagename, frontpagedesc from DocFrontpage "+ sqlwhere +" order by id desc) where rownum<"+ (pagenum*perpage+2);
	}
}else{
	if(user.getLogintype().equals("1")){
		news_SearchSql = "select top "+(pagenum*perpage+1)+" id, frontpagename, frontpagedesc into "+temptable+" from DocFrontpage  "+ sqlwhere +" order by id desc";  
	}
}


//添加判断权限的内容--new*/
RecordSet.executeSql(news_SearchSql);
RecordSet.executeSql("Select count(id) RecordSetCounts from "+temptable);
boolean hasNextPage=false;
int RecordSetCounts = 0;
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}
if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}
	String sqltemp="";
if(RecordSet.getDBType().equals("oracle")){
	sqltemp="select * from (select * from  "+temptable+" order by id) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
}else{
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+"  order by id";
}
RecordSet.executeSql(sqltemp);

%>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<BODY>


<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="document.SearchForm.submit();" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>


<FORM NAME="SearchForm" action="NewsBrowser.jsp" method=post>
<input type="hidden" name="pagenum" value=''>
<input type="hidden" name="publishtype" value='<%=publishtype%>'>


<wea:layout type="2col">
  <wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
	<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
	<wea:item> <input name='name' class='inputstyle' value='<%=name%>'></wea:item>
  </wea:group>
  <wea:group context="" attributes="{'groupDisplay':'none'}">
  	<wea:item attributes="{'colspan':'full'}">&nbsp;</wea:item>
  </wea:group>
  <wea:group context="" attributes="{'groupDisplay':'none'}">
	<wea:item attributes="{'isTableList':'true','colspan':'full'}">
		<%
		String tableString="<table  pagesize=\"10\" tabletype=\"none\" valign=\"top\" >"+
		"<sql backfields=\"*\" sqlform=\" from DocFrontpage \"  sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"desc\" sqlwhere=\""+Util.toHtmlForSplitPage(""+sqlwhere)+"\" sqldistinct=\"true\" />"+
		"<head >"+
		 "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(84,user.getLanguage())+"\"   column=\"id\" />"+
		 "<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\"  column=\"frontpagename\" orderkey=\"frontpagename\" />"+
		 "<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\"  column=\"frontpagedesc\" orderkey=\"frontpagedesc\" />"+
		"</head>"+ "</table>";
	  	%>
	  	<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/>
	</wea:item>
  </wea:group>
    
  
</wea:layout>


</FORM>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
			    <input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btnclear_onclick()">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>

</BODY>
</HTML>

<script type="text/javascript">

	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}


function onClose(){
		 if(dialog){
	    	dialog.close()
	    }else{
		    window.parent.close();
		}
}

function btnclear_onclick(){
	if(dialog){
		try{
		dialog.callback({id:"",name:""});
		}catch(e){}
		try{
		dialog.close({id:"",name:""});
		}catch(e){}

	}else{
	     window.parent.returnValue = {id:"",name:""};
	     window.parent.close();
	}
}

jQuery("#_xTable").bind("click",function(e){
    var target =  e.srcElement||e.target ;
	try{
	    var curRow ;
		if(target.nodeName == "TD" || target.nodeName == "A"){
			curRow=$(target).parents("tr")[0];
		}
		
		if(dialog){
			try{
			    dialog.callback({id:$(curRow.cells[1]).text(),name:$(curRow.cells[2]).text()});
			}catch(e){}
			try{
			dialog.close({id:$(curRow.cells[1]).text(),name:$(curRow.cells[2]).text()});
			}catch(e){}
		}else{
			window.parent.returnValue = {id:$(curRow.cells[1]).text(),name:$(curRow.cells[2]).text()};
			window.parent.close()
		}
	}catch (en) {
		alert(en.message);
	}
});

</script>


