<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSetHrm" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<script type="text/javascript">
var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}catch(e){}
</script>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>

<%
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;


String sqlwhere="";


String check_per = ","+Util.null2String(request.getParameter("taskids"))+",";
String taskids ="";
String tasknames ="";
String strtmp = "select id,taskName from Prj_TemplateTask ";
RecordSet.executeSql(strtmp);
while(RecordSet.next()){
	if(check_per.indexOf(","+RecordSet.getString("id")+",")!=-1){
		 	
		 	taskids +="," + RecordSet.getString("id");
		 	tasknames += ","+RecordSet.getString("taskName");
	}
}


int k;
String log = Util.null2String(request.getParameter("log"));
String level = Util.null2String(request.getParameter("level"));
String subject= Util.fromScreen2(request.getParameter("subject"),user.getLanguage());
String begindate01= Util.null2String(request.getParameter("begindate01"));
String begindate02= Util.null2String(request.getParameter("begindate02"));
String enddate01= Util.null2String(request.getParameter("enddate01"));
String enddate02= Util.null2String(request.getParameter("enddate02"));
String hrmid = Util.null2String(request.getParameter("hrmid"));
if(level.equals("")){
	level = "10" ;
}


String ProjID = Util.null2String(request.getParameter("ProjID"));
String taskrecordid = Util.null2String(request.getParameter("taskrecordid"));


//RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
//if(RecordSet.getCounts()<=0)
	//response.sendRedirect("/base/error/DBError.jsp?type=FindData");
//RecordSet.first();

sqlwhere=" where templetId = "+ProjID+" ";
if(!subject.equals("")){
	sqlwhere+=" and taskName like '%"+subject+"%' ";
}
if(!begindate01.equals("")){
	sqlwhere+=" and begindate>='"+begindate01+"'";
}
if(!begindate02.equals("")){
	sqlwhere+=" and begindate<='"+begindate02+"'";
}
if(!enddate01.equals("")){
	sqlwhere+=" and enddate>='"+enddate01+"'";
}
if(!enddate02.equals("")){
	sqlwhere+=" and enddate<='"+enddate02+"'";
}
if(!hrmid.equals("")){
	sqlwhere+=" and taskManager='"+hrmid+"'";
}

String sqlstr = "select * from Prj_TemplateTask"+sqlwhere+ "order by templetTaskId,parentTaskId" ;
if(!taskrecordid.equals("")){
    sqlstr = "select * from Prj_TemplateTask"+sqlwhere+" and id<>"+taskrecordid +" order by templetTaskId,parentTaskId";
}
char flag = 2;
String ProcPara = "";
ProcPara = ProjID + flag + "" ;
RecordSetHrm.executeSql("select distinct t1.taskManager from Prj_TemplateTask t1 where t1.templetId="+ProjID);
%>

</HEAD>

<BODY>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="proj"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("2233",user.getLanguage())%>'/>
</jsp:include>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
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

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="SingleTaskBrowser.jsp" method=post>


<DIV align=left>
 <input type=hidden  name=ProjID value="<%=ProjID%>">
 <input type=hidden  name=taskrecordid value="<%=taskrecordid%>">


</DIV>

<div style="max-height:155px;overflow:hidden;" id="e8QuerySearchArea">
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage())%>'  attributes="{'groupSHBtnDisplay':'none'}" >
		<wea:item><%=SystemEnv.getHtmlLabelName(2099,user.getLanguage())%></wea:item>
		<wea:item>
			<select  name=level size=1 class=inputstyle >
					 <%for(k=1;k<=10;k++){%>
						 <option value="<%=k%>" <%if(level.equals(""+k)){%>selected<%}%>><%=k%></option>
						
					 <%}%>
					 </select>	
					  <input type=hidden name=level value="<%=k%>">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1352,user.getLanguage())%></wea:item>
		<wea:item>
			<input name=subject size=15 value="<%=Util.toScreenToEdit(request.getParameter("subject"),user.getLanguage())%>" class=inputstyle>
					 <input type=hidden name=subject value="<%=Util.toScreenToEdit(request.getParameter("subject"),user.getLanguage())%>" class=inputstyle>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></wea:item>
		<wea:item>
			<select   name=hrmid size=1 class=inputstyle  >
						 <option value="" ></option>
					 <%while(RecordSetHrm.next()){%>
						 <option value="<%=RecordSetHrm.getString("taskManager")%>" <%if(RecordSetHrm.getString("taskManager").equals(""+hrmid)){%>selected<%}%>><%=ResourceComInfo.getResourcename(RecordSetHrm.getString("taskManager"))%></option>
					 <%}%>
					 </select>	 
					  <input type=hidden  name=hrmid value="<%=RecordSetHrm.getString("hrmid")%>">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></wea:item>
		<wea:item>
			<button type="button" class=calendar id=SelectDate onclick=getDate('begindate01span','begindate01')></BUTTON>&nbsp;
			  <SPAN id=begindate01span ><%=begindate01%></SPAN>
			  <input type="hidden" name="begindate01" value="<%=begindate01%>">- &nbsp;<button type="button" class=calendar id=SelectDate onclick=getDate('begindate02span','begindate02')></BUTTON>&nbsp;
			  <SPAN id=begindate02span ><%=begindate02%></SPAN>
			  <input type="hidden" name="begindate02" value="<%=begindate02%>">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1323,user.getLanguage())%></wea:item>
		<wea:item>
			<button type="button" class=calendar id=SelectDate onclick=getDate('enddate01span','enddate01')></BUTTON>&nbsp;
		  <SPAN id=enddate01span ><%=enddate01%></SPAN>
		  <input type="hidden" name="enddate01" value="<%=enddate01%>">- &nbsp;<button type="button" class=calendar id=SelectDate onclick=getDate('enddate02span','enddate02')></BUTTON>&nbsp;
		  <SPAN id=enddate02span ><%=enddate02%></SPAN>
		  <input type="hidden" name="enddate02" value="<%=enddate02%>">
		</wea:item>
	</wea:group>
</wea:layout>
</div>


<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" style="width:100%">
		<TR class=DataHeader>
			  <TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      
			 <TH width=5%></TH>  
			 <TH width=35%><%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>      
			  <TH width=8%><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TH>
			  <TH width=13%><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></TH>
			  <TH width=13%><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TH></tr>
			  <TR class=Line><Th colspan="6" ></Th></TR> 
		<%
		RecordSet.executeSql(sqlstr);
		while(RecordSet.next()){
			int i=0;
			String ids =""+Util.getIntValue( RecordSet.getString("templetTaskId"),0);
			subject = Util.toScreen(RecordSet.getString("taskName"),user.getLanguage());
			hrmid = Util.toScreen(RecordSet.getString("taskManager"),user.getLanguage());
			String workday = RecordSet.getString("workday");
			//String childnum =RecordSet.getString("childnum");
			//String level_n =RecordSet.getString("level_n");

			if(i==0){
				i=1;
		%>
		<TR class=DataLight>
		<%
			}else{
				i=0;
		%>
		<TR class=DataDark>
		<%}%>
			<TD style="display:none"><A HREF=#><%=ids%></A></TD>
			
			 <%
			 String ischecked = "";
			 if(check_per.indexOf(","+ids+",")!=-1){
				ischecked = " checked ";
			 }%>
			<TD><input type="radio" name="check_per" value="<%=ids%>" <%=ischecked%>></TD>
				   
			<TD>
			 <%=RecordSet.getString("taskName")%>
				</TD>
			<TD><%=ResourceComInfo.getResourcename(RecordSet.getString("taskManager"))%></TD>
			 <td nowrap><%if(!RecordSet.getString("begindate").equals("x")){%><%=RecordSet.getString("begindate")%><%}%></td>
			<td nowrap><%if(!RecordSet.getString("enddate").equals("-")){%><%=RecordSet.getString("enddate")%><%}%></td>
		</TR>
		<%}
		%>

		</TABLE>

  <input type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input type="hidden" name="taskids" value="">
</FORM>
<div style="height: 50px;"></div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=2  id=btnok value="<%="2-"+SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="btnok_onclick();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btnclear_onclick();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
</BODY>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>

<script type="text/javascript">
taskids = "<%=taskids%>";
tasknames = "<%=tasknames%>";
function btnclear_onclick(){
	if(dialog){
		var returnjson={id:"",name:""};
		try{
            dialog.callback(returnjson);
       }catch(e){}
	}else{
		window.parent.parent.returnValue ={id:"",name:""};
		window.parent.parent.close();
	}  
	
}

$("#BrowseTable").bind("mouseover",function(e){
	e=e||event;
   var target=e.srcElement||e.target;
   if("TD"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }else if("A"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }
});
$("#BrowseTable").bind("mouseout",function(e){
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
});

function btnok_onclick(){
	var checkedbox=jQuery("input[name=check_per]:checked");
    taskids = $.trim($(checkedbox.parents("tr")[0].cells[0]).text());
	tasknames =$.trim($(checkedbox.parents("tr")[0].cells[2]).text());
	if(dialog){
		var returnjson={id:taskids,name:tasknames};
		try{
            dialog.callback(returnjson);
       }catch(e){}
	}else{
		window.parent.parent.returnValue = {id:taskids,name:tasknames};
		window.parent.parent.close();
	}  
}
function btnsub_onclick(){
	$("input[name=taskids]").val(taskids);
	document.SearchForm.submit();
}

function CheckAll(checked) {
//	alert(taskids);
//	taskids = "";
//	tasknames = "";
	len = document.SearchForm.elements.length;
	var i=0;
	for( i=0; i<len; i++) {	
		if (document.SearchForm.elements[i].name=='check_per') {
			if(!document.SearchForm.elements[i].checked) {
				taskids = taskids + "," + document.SearchForm.elements[i].parentElement.parentElement.cells(0).innerText;
		   		tasknames = tasknames + "," + document.SearchForm.elements[i].parentElement.parentElement.cells(2).innerText;
		   	}
		   	document.SearchForm.elements[i].checked=(checked==true?true:false);			
		}
 	} 
 //	alert(taskids);
}
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
