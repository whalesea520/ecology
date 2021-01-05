<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="TrainLayoutComInfo" class="weaver.hrm.train.TrainLayoutComInfo" scope="page" />
<jsp:useBean id="TrainPlanComInfo" class="weaver.hrm.train.TrainPlanComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("6156",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e+"-->HrmTrainPlanBrowser.jsp");
	}
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6156,user.getLanguage());
String needfav ="1";
String needhelp ="";
int userid = user.getUID();

String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String planname = Util.null2String(request.getParameter("planname"));
String layoutid = Util.null2String(request.getParameter("layoutid"));
String planaim = Util.null2String(request.getParameter("planaim"));
String plancontent = Util.null2String(request.getParameter("plancontent"));
String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(!planname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where planname like '%";
		sqlwhere += Util.fromScreen2(planname,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and planname like '%";
		sqlwhere += Util.fromScreen2(planname,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!layoutid.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where layoutid =";
		sqlwhere += Util.fromScreen2(layoutid,user.getLanguage());
		sqlwhere += " ";
	}
	else{
		sqlwhere += " and layoutid =";
		sqlwhere += Util.fromScreen2(layoutid,user.getLanguage());
		sqlwhere += " ";
	}
}
if(!planaim.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where planaim like '%";
		sqlwhere += Util.fromScreen2(planaim,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and planaim like '%";
		sqlwhere += Util.fromScreen2(planaim,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!plancontent.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where plancontent like '%";
		sqlwhere += Util.fromScreen2(plancontent,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and plancontent like '%";
		sqlwhere += Util.fromScreen2(plancontent,user.getLanguage());
		sqlwhere += "%'";
	}
}
%>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<div class="zDialog_div_content">
<BODY>
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="HrmTrainPlanBrowser.jsp" method=post>
<input class=inputstyle type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere1)%>">
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btnCancel_Onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON type="button" class=btn accessKey=2 id=btnclear onblur="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name=planname value='<%=planname%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(6128,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="layoutid" browserValue='<%=layoutid %>' 
		      browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/train/trainlayout/TrainLayoutBrowser.jsp?selectedids="
		      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
		      completeUrl="/data.jsp?type=HrmTrainLayout"
		      browserSpanValue='<%=TrainLayoutComInfo.getLayoutname(layoutid)%>'>
		  </brow:browser>     
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name=plancontent value='<%=plancontent%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(16142,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name=planaim value='<%=planaim%>'></wea:item>
	</wea:group>
</wea:layout>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
<TR class=DataHeader>
<TH width=15%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
<TH width=15%><%=SystemEnv.getHtmlLabelName(6101,user.getLanguage())%></TH>
<TH width=35%><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></TH>
<TH width=35%><%=SystemEnv.getHtmlLabelName(16142,user.getLanguage())%></TH>
</tr><TR class=Line style="height: 1px"><TH colspan="4" ></TH></TR>
<%
int i=0;
sqlwhere = "select * from HrmTrainPlan "+sqlwhere;
//System.out.println(sqlwhere);
RecordSet.execute(sqlwhere);
while(RecordSet.next()){
  String id = RecordSet.getString("id");
  boolean canView = TrainPlanComInfo.isViewer(id,""+userid); 
  if(HrmUserVarify.checkUserRight("HrmTrainLayoutEdit:Edit", user)){
   canView = true;
	}
  if(!canView)continue;
	if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
	<%
	}
	%>
	<TD style="display:none"><%=id%></TD>
	<TD><%=RecordSet.getString("planname")%></TD>
	<TD><%=TrainLayoutComInfo.getLayoutname(RecordSet.getString("layoutid"))%></TD>
	<TD><%=RecordSet.getString("plancontent")%></TD>
	<TD><%=RecordSet.getString("planaim")%></TD>	
</TR>
<%}%>
</TABLE></FORM>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="submitClear();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btnCancel_Onclick();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
<script type="text/javascript">
function btnCancel_Onclick(){
	if(dialog){
		dialog.close();
	}else{ 
	  window.parent.close();
	}
}
jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){

		var returnjson = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()};
		if(dialog){
			try{
	        dialog.callback(returnjson);
	   		}catch(e){}
	
			try{
			     dialog.close(returnjson);
			 }catch(e){}
		}else{ 
		  window.parent.returnValue  = returnjson;
		  window.parent.close();
		}

		})

})


function submitClear()
{
	var returnjson = {id:"",name:""};

	if(dialog){
			try{
	        dialog.callback(returnjson);
	   		}catch(e){}
	
			try{
			     dialog.close(returnjson);
			 }catch(e){}
	}else{ 
	  window.parent.returnValue  = returnjson;
	  window.parent.close();
	}
}
  
</script>
</BODY></HTML>
