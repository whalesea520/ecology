
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="weaver.docs.docs.ShareManageDocOperation" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="log" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("DocManageSet:all", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String imagefilename = "/images/hdHRMCard_wev8.gif";

String titlename = SystemEnv.getHtmlLabelName(2115,user.getLanguage())+SystemEnv.getHtmlLabelName(31811,user.getLanguage());
String needfav ="1";
String needhelp ="";
String typeID = ""+Util.getIntValue(request.getParameter("typeID"),0);
String typeName = "";
String typeRemark = "";

String isSynchronous = Util.null2String(request.getParameter("isSynchronous")) ;
int delnum = Util.getIntValue(request.getParameter("delnum"),0);
int panum2 = Util.getIntValue(request.getParameter("panum"),0) ;
String fromtime = "" ;
String totime ="" ;
String operation = Util.null2String(request.getParameter("operation")) ;
String docsrecycle = Util.null2String(request.getParameter("docsrecycle")) ;
String docsautoclean = Util.null2String(request.getParameter("docsautoclean")) ;
String autodeletedays = Util.getIntValue(request.getParameter("autodeletedays"),30) +"";
ShareManageDocOperation manager = new ShareManageDocOperation();
if(operation.equals("add")){
	
	
	for(int j=0;j<panum2+1;j++){
		
     fromtime  += Util.null2String(request.getParameter("fromtime_"+j))+"_" ;
	 totime += Util.null2String(request.getParameter("totime_"+j))+"_";
	
	}
	log.insSysLogInfo(user, -1, SystemEnv.getHtmlLabelName(31811,user.getLanguage()), "", "274", "1", 0, request.getRemoteAddr());
	
	RecordSet.executeSql("update doc_prop set propvalue='"+docsrecycle+"' where propkey='docsrecycle'");
	RecordSet.executeSql("update doc_prop set propvalue='"+docsautoclean+"' where propkey='docsautoclean'");
	RecordSet.executeSql("update doc_prop set propvalue='"+autodeletedays+"' where propkey='autodeletedays'");
	
manager.editProp(isSynchronous,fromtime,totime,panum2);
}
if(operation.equals("add2")){
	if(!request.getParameter("fromtime").equals("")){

	fromtime+=Util.null2String(request.getParameter("fromtime"));
    totime += Util.null2String(request.getParameter("totime"));
	for(int j=0;j<panum2+1;j++){
		
     fromtime  += "_"+Util.null2String(request.getParameter("fromtime_"+j)) ;
	 totime += "_"+Util.null2String(request.getParameter("totime_"+j)) ;
	
	  }
	  panum2=panum2+1;
	}else{
	
	for(int j=0;j<panum2+1;j++){
		
     fromtime  += Util.null2String(request.getParameter("fromtime_"+j))+"_" ;
	 totime += Util.null2String(request.getParameter("totime_"+j))+"_";
	
	}
	
	}
	
	log.insSysLogInfo(user, -1, SystemEnv.getHtmlLabelName(31811,user.getLanguage()), "", "274", "1", 0, request.getRemoteAddr());	
	RecordSet.executeSql("update doc_prop set propvalue='"+docsrecycle+"' where propkey='docsrecycle'");
	RecordSet.executeSql("update doc_prop set propvalue='"+docsautoclean+"' where propkey='docsautoclean'");
	RecordSet.executeSql("update doc_prop set propvalue='"+autodeletedays+"' where propkey='autodeletedays'");
manager.editProp(isSynchronous,fromtime,totime,panum2);
}
if(operation.equals("delete")){
	

	for(int j=0;j<panum2+1;j++){
	if(j!=delnum){	
     fromtime  += Util.null2String(request.getParameter("fromtime_"+j))+"_" ;
	 totime += Util.null2String(request.getParameter("totime_"+j))+"_";
	}
	}
    if(panum2>0){
    panum2=panum2-1;
    log.insSysLogInfo(user, -1, SystemEnv.getHtmlLabelName(31811,user.getLanguage()), "", "274", "3", 0, request.getRemoteAddr());
	RecordSet.executeSql("update doc_prop set propvalue='"+docsrecycle+"' where propkey='docsrecycle'");
	RecordSet.executeSql("update doc_prop set propvalue='"+docsautoclean+"' where propkey='docsautoclean'");
	RecordSet.executeSql("update doc_prop set propvalue='"+autodeletedays+"' where propkey='autodeletedays'");
	manager.editProp(isSynchronous,fromtime,totime,panum2);
	}

}


%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
}
</script>
</head>
<%

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:_onViewLog(274),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" name="newBtn" onclick="doSubmit(this)" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=weaver action="DocProp.jsp" method=post >
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(31813,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></wea:item>
			<%
			    Prop prop2 = Prop.getInstance();  
				int isSynchronous2 = Util.getIntValue(prop2.getPropValue("isSynchronous" , "isSynchronous"),0);
			%>
			<wea:item>
				<input class=InputStyle tzCheckbox="true" name="isSynchronous" type="checkbox" value="<%=isSynchronous2%>" <%if(isSynchronous2==1){%> checked <%}%>onclick="setCheck(this)" />
			</wea:item>
			<%String attributes="{'samePair':'b1','display':'"+(isSynchronous2!=1?"none":"")+"'}"; %>
			<wea:item attributes='<%= attributes%>'>
				<%=SystemEnv.getHtmlLabelName(31814,user.getLanguage())%>
				(<%=SystemEnv.getHtmlLabelName(31815,user.getLanguage())%>)
			</wea:item>
			<wea:item attributes='<%= attributes%>'>
				<button type="button" class="Clock" id="selectfromtimebtn" onclick="onShowTime(selectfromtime,fromtime)"></button>
				<span id="selectfromtime"></span>
              	<input type="hidden" id="fromtime" name="fromtime" value="">
				-
				<button type="button" class="Clock" id="selecttotimebtn" onclick="onShowTime(selecttotime,totime)"></button> 
				
					<span id="selecttotime" style="margin-right:10px"></span>
					<a href="#" onclick="doSubmit2();return false;"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>
              	<input type="hidden" id="totime" name="totime" value="">
			</wea:item>
			<%attributes="{'samePair':'b2','display':'"+(isSynchronous2!=1?"none":"")+"'}"; %>
			<wea:item attributes='<%= attributes%>'>
				
			</wea:item>
			<wea:item attributes='<%= attributes%>'>
				<%
				    Prop prop = Prop.getInstance();  
					int panum = Util.getIntValue(prop.getPropValue("isSynchronous" , "panum"),0);
					
				%>
				<input type="hidden" id="panum" name="panum" value="<%=panum%>">

				<%
					for(int i=0;i<panum;i++){
										
				
				%>
					<span style="margin-right:10px"><%=prop.getPropValue("isSynchronous" , "fromtime_"+i)%>-<%=prop.getPropValue("isSynchronous" , "totime_"+i)%></span><a href="#" onclick="dodelete(<%=i%>);return false;"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a></br>
				<input type="hidden" id="fromtime_<%=i%>" name="fromtime_<%=i%>" value="<%=prop.getPropValue("isSynchronous" ,"fromtime_"+i)%>">
				<input type="hidden" id="totime_<%=i%>" name="totime_<%=i%>" value="<%=prop.getPropValue("isSynchronous" , "totime_"+i)%>">


					<%}%>
			</wea:item>
		</wea:group>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(130650,user.getLanguage())%>'>
			<%
			RecordSet.executeSql("select propvalue from   doc_prop  where propkey='docsrecycle'");
			RecordSet.next();
			int _docsrecycleIsOpen=Util.getIntValue(RecordSet.getString("propvalue"),0);
			RecordSet.executeSql("select propvalue from   doc_prop  where propkey='docsautoclean'");
			RecordSet.next();
			int _autoclean=Util.getIntValue(RecordSet.getString("propvalue"),0);
			RecordSet.executeSql("select propvalue from   doc_prop  where propkey='autodeletedays'");
			RecordSet.next();
			int _deletedays=Util.getIntValue(RecordSet.getString("propvalue"),30);			
			String recycleattrs = "{'isTableList':'true','samePair':'setting','display':'"+(_docsrecycleIsOpen==1?"":"none")+"'}";
			%>
			<wea:item><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></wea:item>
			<wea:item attributes="{'display':''}">
			<INPUT class=InputStyle  tzCheckbox="true" type=checkbox value="<%=_docsrecycleIsOpen%>" <%if(_docsrecycleIsOpen==1){%>checked<%}%> id="docsrecycle" name="docsrecycle" onclick="ondocsrecycleClick(this)">
			</wea:item>
			<wea:item attributes='<%=recycleattrs %>'>
				<wea:layout >
					<wea:group context="" attributes="{'groupDisplay':'none'}">
						<wea:item ><%=SystemEnv.getHtmlLabelName(130672,user.getLanguage())%></wea:item>
						<wea:item >
						<INPUT class=InputStyle  tzCheckbox="true" type=checkbox  value="<%=_autoclean%>" <%if(_autoclean==1){%>checked<%}%> id="docsautoclean" name="docsautoclean" onclick="ondocsautocleanClick(this)">
							<span  id="cleandayspan" <%if(_autoclean!=1){%>style="display:none"<%}%> >
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(130674,user.getLanguage())%>&nbsp;<INPUT class=InputStyle style="width:30px;text-align:center;"  onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" defValue="<%=_deletedays%>" value=<%=_deletedays%> onchange="checkPositiveNumber('<%=SystemEnv.getHtmlLabelName(130673,user.getLanguage())%>',this)" id="autodeletedays" name="autodeletedays" >&nbsp;<%=SystemEnv.getHtmlLabelName(130675,user.getLanguage())%>
							</span>
						</wea:item>
					</wea:group>
				</wea:layout>
			</wea:item>
		</wea:group>
	</wea:layout>
</Form>
</BODY>

</HTML>
<SCRIPT LANGUAGE="JavaScript">

function checkPositiveNumber(label,obj){
	var def = jQuery(obj).attr("defValue");
	if(obj.value<=0){
		alert("'"+label+"'<%=SystemEnv.getHtmlLabelName(24475,user.getLanguage())%>")
		obj.value=def;
	}
}
function ondocsrecycleClick(obj){
    if(obj.checked){
		obj.value='1';
		showEle("setting");
    } else {
		obj.value='0';
		hideEle("setting");
    }
}
function ondocsautocleanClick(obj){
	var cleandayspan=jQuery("#cleandayspan");
    if(obj.checked){
		obj.value='1';
    	cleandayspan.css("display",""); 
    } else {
		obj.value='0';
    	cleandayspan.css("display","none"); 
    }
}
function doSubmit() {
	
    weaver.action="DocProp.jsp?operation=add";
    
    weaver.submit();
}

function doSubmit2() {
	var starttime=$("#fromtime").val();              
	var endtime=$("#totime").val();

	var istart=parseInt(starttime.split(":")[0]) * 100 + parseInt(starttime.split(":")[1]);
	var iend=parseInt(endtime.split(":")[0]) * 100 + parseInt(endtime.split(":")[1]);
	if(weaver.fromtime.value==""&&weaver.totime.value==""){
		
	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31833,user.getLanguage())%>");
	return false ;
	}

	if(weaver.fromtime.value!=""&&weaver.totime.value==""){
		
	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18622,user.getLanguage())%>");
	return false ;
	}
	if(weaver.fromtime.value==""&&weaver.totime.value!=""){
	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18622,user.getLanguage())%>");
	return false ;
	}

	if(iend<=istart){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31832,user.getLanguage())%>");
		return false;
	
	}
    weaver.action="DocProp.jsp?operation=add2";
    
    weaver.submit();
}


function dodelete(a) {	


    weaver.action="DocProp.jsp?operation=delete&delnum="+a;
    weaver.submit();
}

function setCheck(a){

if(a.checked){

 a.value="1";
 /*document.getElementById("b1").style.display="";
 document.getElementById("b2").style.display="";*/
 showEle("b1");
 showEle("b2");

}else{
 a.value="";
 /*document.getElementById("b1").style.display="none";
 document.getElementById("b2").style.display="none";*/
 hideEle("b1");
 hideEle("b2");
}

}


</SCRIPT>
<SCRIPT language="javascript"  src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript"  src="/js/selectDateTime_wev8.js"></script>
