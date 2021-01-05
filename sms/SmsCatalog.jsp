<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
String id =Util.null2String(request.getParameter("id"));
String names ="";

String userID = ""+user.getUID();
String name=Util.null2String(request.getParameter("name"));//备注
String newstype =Util.null2String(request.getParameter("type"));//类型
String clazzname =Util.null2String(request.getParameter("clazzname"));//接口类 
String keyword=Util.null2String(request.getParameter("keyword"));//接口类 
String sqlwhere="where 1=1 ";


if(name!=null&&!"".equals(name)){
	sqlwhere+=" and t1.name like '%"+name+"%' ";
}
if(newstype!=null&&!"".equals(newstype)){
	sqlwhere+=" and t1.type = '"+newstype+"' ";
}
if(clazzname!=null&&!"".equals(clazzname)){
	sqlwhere+=" and t1.clazzname like '%"+clazzname+"%' ";
}
if(keyword!=null&&!"".equals(keyword)){
	sqlwhere+=" and t1.keyword like '%"+keyword+"%' ";
} 
int perpage=Util.getPerpageLog();
if(perpage<10) perpage=10;

 
String backFields = " t1.* ";
String sqlFrom = " sms_interface t1";
String tableString=""+
			  "<table  pagesize=\""+perpage+"\" instanceid=\"SmsInterfaceSelect\" tabletype=\"radio\">"+
			  "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\"t1.dsporder\" sqlprimarykey=\"t1.id\" sqlsortway=\"asc\"  sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"/>"+
			  "<head>"+                             
					  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"name\" />"+ 
					  "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(23683,user.getLanguage())+"\" column=\"clazzname\" />"+
					  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(2095,user.getLanguage())+"\" column=\"keyword\" />"+
					  "<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"type\"/>"+
					  "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(454,user.getLanguage())+"\" column=\"remark\"/>"+
			  "</head>";
tableString += "</table>";
 
 
%>
<BODY style="overflow:hidden">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="communicate"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(126231,user.getLanguage()) %>"/>
</jsp:include>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>" class="e8_btn_top" onclick="doSearch()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span id="hoverBtnSpan" class="hoverBtnSpan">
			
	</span>
</div>

<div class="zDialog_div_content" style="overflow:auto;overflow-x: hidden">
		<form id=SearchForm name=SearchForm method=post action="SmsCatalog.jsp">
		<input type="hidden" name="id" value="<%=id %>">
			<wea:layout type="4Col">
			     <wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>' attributes="{'groupSHBtnDisplay':'none'}">
				      <wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
				      <wea:item>
				          <input type="text" id="name" name="name" value="<%=name%>" class="InputStyle">
				      </wea:item>
				      
				      <wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
				      <wea:item>
				      	<select name="type">
							<option value="" <%="".equals(newstype)?"selected":""%> ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
							<option value="HTTP" <%="HTTP".equals(newstype)?"selected":""%>>HTTP</option>
							<option value="WebService" <%="WebService".equals(newstype)?"selected":""%>>WebService</option>
							<option value="SDK" <%="SDK".equals(newstype)?"selected":""%>>SDK</option>
						</select>
				      </wea:item>
				      
				      <wea:item><%=SystemEnv.getHtmlLabelName(2095,user.getLanguage())%></wea:item>
				      <wea:item>
				          <input type="text" id="keyword" name="keyword" value="<%=keyword%>" class="InputStyle">
				      </wea:item>
				      
			     </wea:group>
			     
			     <wea:group context='<%=SystemEnv.getHtmlLabelName(33046,user.getLanguage())%>' attributes="{'groupDisplay':'none','itemAreaDisplay':'inline-block'}" >
				      <wea:item attributes="{'isTableList':'true'}" >
				      		<wea:SplitPageTag  tableString='<%=tableString%>'  selectedstrs="<%=id %>"/>
				      </wea:item>
			     </wea:group>
				 
			</wea:layout>
	 	</form>
 		</div>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout type="2Col">
				<!-- 操作 -->
			     <wea:group context="">
			    	<wea:item type="toolbar">
			    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%>" class="e8_btn_submit" onclick="doSubmit()">
					    <input type="button" value="<%=SystemEnv.getHtmlLabelName(311, user.getLanguage())%>" class="e8_btn_submit" onclick="onClear()">
					    <input type="button" value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>" class="e8_btn_cancel" onclick="btn_cancle()">
				    </wea:item>
			    </wea:group>
		    </wea:layout>
		</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>   		
</BODY>
</HTML>

<script language="javascript">
jQuery(document).ready(function(){
	resizeDialog();
});

var dialog;
 try{
 	dialog = parent.getDialog(window);
 }catch(e){}
 if(!dialog){
 	try{
  	dialog = parent.parent.getDialog(parent);
  }catch(e){}
 }
 
var checkids="";
var checknames="";
function btn_cancle(){
	dialog.close();
}

function onClear()
{
    var returnjson= {id:"",name:""};
    if(dialog){
    	dialog.callback(returnjson);
	}else{
    	window.parent.returnValue  = returnjson;
    	window.parent.close();
 	}
}

function doSubmit()
{
	checkids=_xtalbe_radiocheckId;
	if(checkids==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18214, user.getLanguage())%>");
		return;
	}
    checknames=$('#_xTable_'+checkids).parent().parent().next().next().html();
    var returnjson= {id:checkids,name:checknames};
    if(dialog){
    	dialog.callback(returnjson);
	}else{ 
    	window.parent.returnValue  = returnjson;
    	window.parent.close();
 	}
}

function doSearch()
{
    document.SearchForm.submit();
}

function onClose()
{
	window.parent.close() ;
}

</script>
