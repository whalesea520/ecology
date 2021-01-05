<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String fullname = Util.null2String(request.getParameter("fullname"));
String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(!fullname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where fullname like '%";
		sqlwhere += Util.fromScreen2(fullname,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and fullname like '%";
		sqlwhere += Util.fromScreen2(fullname,user.getLanguage());
		sqlwhere += "%'";
	}
}

%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:dialog.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<DIV align=right style="display:none">
	<button type="button" class=btnSearch accessKey=S type=submit onclick="document.SearchForm.submit()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
	<button type="button" class=btnReset accessKey=T type=reset onclick="document.SearchForm.reset()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
	<button type="button" class=btn accessKey=1 onclick="dialog.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
	<button type="button" class=btn accessKey=2 id=btnclear onclick="btnclear_onclick();"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>   

<div class="zDialog_div_content">
	<FORM NAME=SearchForm  action="TradeInfoBrowser.jsp" method=post>
	<input type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere1)%>">
	
	<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
			<wea:item><input class=InputStyle  name=fullname value='<%=fullname%>'></wea:item>
			<wea:item></wea:item>
			<wea:item></wea:item>
		</wea:group>	
		
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item attributes="{'colspan':'full'}">&nbsp;</wea:item>
		</wea:group>
		
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item attributes="{'isTableList':'true'}">
				<wea:layout type="table" attributes="{'cols':'4','layoutTableId':'BrowseTable'}" needImportDefaultJsAndCss="false">
					<wea:group context="" attributes="{'groupDisplay':'none'}">
						<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></wea:item>
						<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
						<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(1271,user.getLanguage())%></wea:item>
						<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(1270,user.getLanguage())%></wea:item>
						
						<%
							sqlwhere = "select * from CRM_TradeInfo "+sqlwhere+" order by id asc";
							RecordSet.execute(sqlwhere);
							while(RecordSet.next()){
						%>
							<wea:item><A HREF=#><%=RecordSet.getString(1)%></A></wea:item>
							<wea:item><%=RecordSet.getString(2)%></wea:item>
							<wea:item><%=RecordSet.getString(3)%></wea:item>
							<wea:item><%=RecordSet.getString(4)%></wea:item>
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
      var returnValue = {id:$.trim(jQuery(jQuery(target).parents("tr")[0].cells[0]).text()),name:jQuery(jQuery(target).parents("tr")[0].cells[1]).text()};
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
</script>
</BODY></HTML>


