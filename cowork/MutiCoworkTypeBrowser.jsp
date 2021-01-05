<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.cowork.CoTypeComInfo"%>
<%@page import="weaver.cowork.CoMainTypeComInfo"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CoMainTypeComInfo" class="weaver.cowork.CoMainTypeComInfo" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%
String coworkTypeIds = Util.null2String(request.getParameter("coworkTypeIds"));
coworkTypeIds=","+coworkTypeIds+",";
String typename = Util.null2String(request.getParameter("typename"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String sqlwhere = " where 1=1 ";
if(!"".equals(typename))
	sqlwhere+=" and typename like '%"+typename+"%'";
if(!"".equals(departmentid))
	sqlwhere+=" and departmentid="+departmentid+"";
%>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:doClick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:dialog.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<BODY scroll="auto">

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="collaboration"/>
   <jsp:param name="navName" value="协作板块83265"/>
</jsp:include>

<DIV align=right style="display:none">
	<button type="button" class=btnSearch accessKey=S type=submit onclick="document.SearchForm.submit()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
	<button type="button" class=btnReset accessKey=T type=reset onclick="document.SearchForm.reset()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
	<button type="button" class=btn accessKey=1 onclick="dialog.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
	<button type="button" class=btn accessKey=2 id=btnclear onclick="btnclear_onclick();"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>

<div class="zDialog_div_content">
	<FORM NAME=SearchForm  action="MutiCoworkTypeBrowser.jsp" method=post>
	
	<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(34242,user.getLanguage())%></wea:item>
			<wea:item><input class="InputStyle"  name="typename" value='<%=typename%>'></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
			<wea:item>
				<select name="departmentid" id="departmentid">
					<option value="" <%=departmentid.equals("")?"selected:":""%>></option>
					<%
					CoMainTypeComInfo.setTofirstRow();
					while(CoMainTypeComInfo.next()){
					%>
						<option value="<%=CoMainTypeComInfo.getCoMainTypeid()%>" <%=departmentid.equals(CoMainTypeComInfo.getCoMainTypeid())?"selected:":""%>><%=CoMainTypeComInfo.getCoMainTypename() %></option>
					<%}%>
				</select>
			</wea:item>
		</wea:group>	
		
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item attributes="{'colspan':'full'}">&nbsp;</wea:item>
		</wea:group>
		
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item attributes="{'isTableList':'true'}">
				<wea:layout type="table" attributes="{'cols':'3','layoutTableId':'BrowseTable'}" needImportDefaultJsAndCss="false">
					<wea:group context="" attributes="{'groupDisplay':'none'}">
						<wea:item type="thead">
							<input type="checkbox" onclick="checkAll(this)"/>
						</wea:item>
						<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(83265,user.getLanguage())%></wea:item>
						<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(83266,user.getLanguage())%></wea:item>
						
						<%
							sqlwhere = "select * from cowork_types "+sqlwhere+" order by id asc";
							RecordSet.execute(sqlwhere);
							while(RecordSet.next()){
								String typeid=RecordSet.getString("id");
						%>
							<wea:item><input name="typeid" type="checkbox" <%=coworkTypeIds.indexOf(","+typeid+",")>-1?"checked":""%> _typename='<%=RecordSet.getString("typename")%>' value='<%=RecordSet.getString("id")%>'/></wea:item>
							<wea:item><%=RecordSet.getString("typename")%></wea:item>
							<wea:item><%=CoMainTypeComInfo.getCoMainTypename(RecordSet.getString("departmentid"))%></wea:item>
						<%} %>
					</wea:group>
				</wea:layout>
			</wea:item>
		</wea:group>	
	</wea:layout>
	</FORM>
</div>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" accessKey=O  id=btnclear value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="doClick();">
				<input type="button" accessKey=2  id=btnclear value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btnclear_onclick();">
		    	<input type="button" accessKey=T  id=btncancel value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
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
<script type="text/javascript">

var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}catch(e){}

function btnclear_onclick(){
    var returnValue = {id:"",name:""};
	if(dialog){
		dialog.callback(returnValue);
	}else{
       window.parent.returnValue  = returnValue;
       window.parent.close();
	}
}

function doClick(){

	var typeids="";
	var typeNames="";
	$("input:checked").each(function(){
		if($(this).attr("name")=="typeid"){
		  typeids+=","+$(this).val();
		  typeNames+=","+$(this).attr("_typename");
		}  
	});
	
	if(typeids.length==0){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83267,user.getLanguage())%>");
		return ;
	}else{
		typeids=typeids.substring(1);
		typeNames=typeNames.substring(1);
	}
	
	var returnValue = {id:typeids,name:typeNames};
	
	if(dialog){
		dialog.callback(returnValue);
	}else{
       window.parent.returnValue  = returnValue;
       window.parent.close();
	}
}


function checkAll(obj){
	$("input[name=typeid]").each(function(){
		if(obj.checked)
			changeCheckboxStatus(this,true);
		else
			changeCheckboxStatus(this,false);	
	});	

}


</script>
