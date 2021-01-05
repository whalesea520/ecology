<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
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
if(!description.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where description like '%";
		sqlwhere += Util.fromScreen2(description,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and description like '%";
		sqlwhere += Util.fromScreen2(description,user.getLanguage());
		sqlwhere += "%'";
	}
}
%>

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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<BODY scroll="auto">

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("645",user.getLanguage()) %>'/>
</jsp:include>


<DIV align=right style="display:none">
	<button type="button" class=btnSearch accessKey=S type=submit onclick="document.SearchForm.submit()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
	<button type="button" class=btnReset accessKey=T type=reset onclick="document.SearchForm.reset()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
	<button type="button" class=btn accessKey=1 onclick="dialog.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
	<button type="button" class=btn accessKey=2 id=btnclear onclick="btnclear_onclick();"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>

<div class="zDialog_div_content">
	<FORM NAME=SearchForm  action="ContactWayBrowser.jsp" method=post>
	<input type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere1)%>">
	
	<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
			<wea:item><input class=InputStyle  name=fullname value='<%=fullname%>'></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
			<wea:item><input class=InputStyle  name=description value='<%=description%>'></wea:item>
		</wea:group>	
		
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item attributes="{'colspan':'full'}">&nbsp;</wea:item>
		</wea:group>
		
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item attributes="{'isTableList':'true'}">
				<wea:layout type="table" attributes="{'cols':'3','layoutTableId':'BrowseTable'}" needImportDefaultJsAndCss="false">
					<wea:group context="" attributes="{'groupDisplay':'none'}">
						<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></wea:item>
						<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
						<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
						
						<%
							sqlwhere = "select * from CRM_ContactWay "+sqlwhere+" order by id asc";
							RecordSet.execute(sqlwhere);
							while(RecordSet.next()){
						%>
							<wea:item><A HREF=#><%=RecordSet.getString(1)%></A></wea:item>
							<wea:item><%=RecordSet.getString(2)%></wea:item>
							<wea:item><%=RecordSet.getString(3)%></wea:item>
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
</div>


</BODY></HTML>
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
			try{
	            dialog.callback(returnValue);
	      	}catch(e){}
	      	 
		  	try{
		       dialog.close(returnValue);
		   }catch(e){}
		}else{
     		window.parent.parent.returnValue = returnValue;
	 		window.parent.parent.close();
		}
	}
}


function btnclear_onclick(){
    var returnValue = {id:"",name:""};
	if(dialog){
		try{
            dialog.callback(returnValue);
       }catch(e){}
	  	try{
	       dialog.close(returnValue);
	   }catch(e){}
	}else{
		window.parent.returnValue = returnValue;
		window.parent.close();
	}
}

</script>
