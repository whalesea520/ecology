
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
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
</script>
</HEAD>


<%
    String title = SystemEnv.getHtmlLabelName(81785,user.getLanguage()); 
	String workflowid = Util.null2String(request.getParameter("workflowId"));
	String nodeid = Util.null2String(request.getParameter("nodeid"));
	String action = Util.null2String(request.getParameter("action"));
	String completeType = Util.null2String(request.getParameter("completeType"));
	String IsBeForwardModify = Util.null2String(request.getParameter("IsBeForwardModify"),"0");
	String IsSubmitedOpinion = Util.null2String(request.getParameter("IsSubmitedOpinion"),"0");
	String IsBeForwardSubmit = Util.null2String(request.getParameter("IsBeForwardSubmit"),"0");
	String IsWaitForwardOpinion = Util.null2String(request.getParameter("IsWaitForwardOpinion"),"0");
	String IsBeForwardTodo = Util.null2String(request.getParameter("IsBeForwardTodo"),"0");
	String IsBeForwardSubmitAlready = Util.null2String(request.getParameter("IsBeForwardSubmitAlready"),"0");
	String IsBeForwardAlready = Util.null2String(request.getParameter("IsBeForwardAlready"),"0");
	String IsBeForwardSubmitNotaries = Util.null2String(request.getParameter("IsBeForwardSubmitNotaries"),"0");
	String IsBeForward = Util.null2String(request.getParameter("IsBeForward"),"0");
	
	String BeForwardModify="";
	String SubmitedOpinion="";
	String BeForwardSubmit="";
	String BeForwardPending="";
	String WaitForwardOpinion = "";
	String BeForwardTodo="";
	String BeForwardSubmitAlready="";
	String BeForwardAlready="";
	String BeForwardSubmitNotaries="";
	String BeForward="";
	
	RecordSet.executeSql("select CustFieldName from workflow_CustFieldName where workflowId="+workflowid+" and nodeId = "+nodeid+" and fieldname = 'BeForwardModify' and Languageid = "+user.getLanguage());
    if(RecordSet.next()){
    	BeForwardModify = RecordSet.getString("CustFieldName");
    }else{
    	BeForwardModify = SystemEnv.getHtmlLabelName(81772,user.getLanguage());
    }
    RecordSet.executeSql("select CustFieldName from workflow_CustFieldName where workflowId="+workflowid+" and nodeId = "+nodeid+" and fieldname = 'SubmitedOpinion' and Languageid = "+user.getLanguage());
    if(RecordSet.next()){
    	SubmitedOpinion = RecordSet.getString("CustFieldName");	    	
    }else{
    	SubmitedOpinion = SystemEnv.getHtmlLabelName(81779,user.getLanguage());
    }
    RecordSet.executeSql("select CustFieldName from workflow_CustFieldName where workflowId="+workflowid+" and nodeId = "+nodeid+" and fieldname = 'BeForwardSubmit' and Languageid = "+user.getLanguage());
    if(RecordSet.next()){
    	BeForwardSubmit = RecordSet.getString("CustFieldName");
    }else{
    	BeForwardSubmit = SystemEnv.getHtmlLabelName(81780,user.getLanguage());
    }
    RecordSet.executeSql("select CustFieldName from workflow_CustFieldName where workflowId="+workflowid+" and nodeId = "+nodeid+" and fieldname = 'WaitForwardOpinion' and Languageid = "+user.getLanguage());
    if(RecordSet.next()){
    	WaitForwardOpinion = RecordSet.getString("CustFieldName");
    }else{
    	WaitForwardOpinion = SystemEnv.getHtmlLabelName(81781,user.getLanguage());
    }
    RecordSet.executeSql("select CustFieldName from workflow_CustFieldName where workflowId="+workflowid+" and nodeId = "+nodeid+" and fieldname = 'BeForwardPending' and Languageid = "+user.getLanguage());
    if(RecordSet.next()){
    	BeForwardPending = RecordSet.getString("CustFieldName");
    }else{
    	BeForwardPending = ""+SystemEnv.getHtmlLabelName(84495,user.getLanguage());
    }
    RecordSet.executeSql("select CustFieldName from workflow_CustFieldName where workflowId="+workflowid+" and nodeId = "+nodeid+" and fieldname = 'BeForwardTodo' and Languageid = "+user.getLanguage());
    if(RecordSet.next()){
    	BeForwardTodo = RecordSet.getString("CustFieldName");
    }else{
    	BeForwardTodo = SystemEnv.getHtmlLabelName(81776,user.getLanguage());	
    }
    RecordSet.executeSql("select CustFieldName from workflow_CustFieldName where workflowId="+workflowid+" and nodeId = "+nodeid+" and fieldname = 'BeForwardSubmitAlready' and Languageid = "+user.getLanguage());
    if(RecordSet.next()){
    	BeForwardSubmitAlready = RecordSet.getString("CustFieldName");
    }else{
    	BeForwardSubmitAlready = SystemEnv.getHtmlLabelName(81777,user.getLanguage());		    	
    }
    RecordSet.executeSql("select CustFieldName from workflow_CustFieldName where workflowId="+workflowid+" and nodeId = "+nodeid+" and fieldname = 'BeForwardAlready' and Languageid = "+user.getLanguage());
    if(RecordSet.next()){
    	BeForwardAlready = RecordSet.getString("CustFieldName");
    }else{
    	BeForwardAlready = SystemEnv.getHtmlLabelName(81776,user.getLanguage());
    }
    RecordSet.executeSql("select CustFieldName from workflow_CustFieldName where workflowId="+workflowid+" and nodeId = "+nodeid+" and fieldname = 'BeForwardSubmitNotaries' and Languageid = "+user.getLanguage());
    if(RecordSet.next()){
    	BeForwardSubmitNotaries = RecordSet.getString("CustFieldName");
    }else{
    	BeForwardSubmitNotaries = SystemEnv.getHtmlLabelName(81777,user.getLanguage());
    }
    RecordSet.executeSql("select CustFieldName from workflow_CustFieldName where workflowId="+workflowid+" and nodeId = "+nodeid+" and fieldname = 'BeForward' and Languageid = "+user.getLanguage());
    if(RecordSet.next()){
    	BeForward = RecordSet.getString("CustFieldName");
    }else{
    	BeForward = SystemEnv.getHtmlLabelName(81776,user.getLanguage());	
    }
	
    if(action.equals("save")){
    	if(completeType.equals("doing")){
    		RecordSet.executeSql("update workflow_flownode set IsBeForwardModify="+IsBeForwardModify+",IsSubmitedOpinion="+IsSubmitedOpinion+",IsBeForwardSubmit="+IsBeForwardSubmit+",IsWaitForwardOpinion="+IsWaitForwardOpinion+",IsBeForwardTodo="+IsBeForwardTodo+" where workflowid="+workflowid+" and nodeid = "+nodeid);
    	    //System.err.println("doing sql");
    	}
    	if(completeType.equals("done")){
    		RecordSet.executeSql("update workflow_flownode set IsBeForwardSubmitAlready="+IsBeForwardSubmitAlready+",IsBeForwardAlready="+IsBeForwardAlready+" where workflowid="+workflowid+" and nodeid = "+nodeid);
    		//System.err.println("done sql");
    	}
    	if(completeType.equals("complete")){
    		RecordSet.executeSql("update workflow_flownode set IsBeForwardSubmitNotaries="+IsBeForwardSubmitNotaries+",IsBeForward="+IsBeForward+" where workflowid="+workflowid+" and nodeid = "+nodeid);
    		//System.err.println("complete sql");
    	}
    }
%>

<BODY style="overflow:hidden">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=title%>"/>
</jsp:include>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:btnok_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<div class="zDialog_div_content">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/workflow/request/chooseRemarkRights.jsp" method=post>
<DIV align=right style="display:none">
</DIV>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top"  onclick="btnok_onclick()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(81711,user.getLanguage())%>'>
	   <wea:item>
	   	 <%=SystemEnv.getHtmlLabelName(81768,user.getLanguage())%>
	   </wea:item>
	   <wea:item>
	        <input type="hidden" name="completeType" value="<%=completeType%>">
	        <input type="hidden" name="workflowId" value="<%=workflowid%>">
	        <input type="hidden" name="nodeid" value="<%=nodeid%>">
	        <input type="hidden" name="action" value="save">
	     <%if(completeType.equals("doing")){//待办%>
	        <input type="checkbox" onclick="CheckClick('IsBeForwardModify')" id="IsBeForwardModify" name="IsBeForwardModify" value="1" <%if(IsBeForwardModify.equals("1")){%>checked<%}%>><span><%=BeForwardModify%></span><br>
	        <input type="checkbox" onclick="CheckClick('IsSubmitedOpinion')" id="IsSubmitedOpinion" name="IsSubmitedOpinion" value="1" <%if(IsSubmitedOpinion.equals("1")){%>checked<%}%>><span><%=SubmitedOpinion%></span><br>
	        <input type="checkbox" onclick="CheckClick('IsBeForwardSubmit')" id="IsBeForwardSubmit" name="IsBeForwardSubmit" value="1" <%if(IsBeForwardSubmit.equals("1")){%>checked<%}%>><span><%=BeForwardSubmit%></span><br>
	        <input type="checkbox" onclick="CheckClick('IsWaitForwardOpinion')" id="IsWaitForwardOpinion" name="IsWaitForwardOpinion" value="1" <%if(IsWaitForwardOpinion.equals("1")){%>checked<%}%>><span><%=WaitForwardOpinion%></span><br>
	        <input type="checkbox" onclick="CheckClick('IsBeForwardTodo')" id="IsBeForwardTodo" name="IsBeForwardTodo" value="1" <%if(IsBeForwardTodo.equals("1")){%>checked<%}%>><span><%=BeForwardTodo%></span>
	     <%}%>
	     <%if(completeType.equals("done")){//已办%>
	     	<input type="checkbox" onclick="CheckClick('IsBeForwardSubmitAlready')" id="IsBeForwardSubmitAlready" name="IsBeForwardSubmitAlready" value="1" <%if(IsBeForwardSubmitAlready.equals("1")){%>checked<%}%>><span><%=BeForwardSubmitAlready%></span><br>
	     	<input type="checkbox" onclick="CheckClick('IsBeForwardAlready')" id="IsBeForwardAlready" name="IsBeForwardAlready" value="1" <%if(IsBeForwardAlready.equals("1")){%>checked<%}%>><span><%=BeForwardAlready%></span>
	     <%}%>
	     <%if(completeType.equals("complete")){//办结%>
	     	<input type="checkbox" onclick="CheckClick('IsBeForwardSubmitNotaries')" id="IsBeForwardSubmitNotaries" name="IsBeForwardSubmitNotaries" value="1" <%if(IsBeForwardSubmitNotaries.equals("1")){%>checked<%}%>><span><%=BeForwardSubmitNotaries%></span><br>
	     	<input type="checkbox" onclick="CheckClick('IsBeForward')" id="IsBeForward" name="IsBeForward" value="1" <%if(IsBeForward.equals("1")){%>checked<%}%>><span><%=BeForward%></span>
	     <%}%>
	   </wea:item>
	</wea:group>
</wea:layout>
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes='{\"groupDisplay\":\"none\"}'>
			<wea:item type="toolbar">
		    	<input type="button" accessKey="S"  id="btnclose" value="<%="T-"+SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btnclose_onclick()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY></HTML>

<script language="javascript" >
var disabledList,undisabledList,checkList,uncheckList;
function changejNiceClass(disabledList,undisabledList,checkList,uncheckList){
    for(var i=0;i<checkList.length;i++){
		var name = checkList[i].attr("name");
		$("input[name="+name+"]").attr("checked","checked");
		$("input[name="+name+"]").next().addClass("jNiceChecked");
	}
	
	for(var i=0;i<uncheckList.length;i++){
		var name = uncheckList[i].attr("name");
		$("input[name="+name+"]").removeAttr("checked");
		$("input[name="+name+"]").next().removeClass("jNiceChecked");
	}	
	
	for(var i=0;i<disabledList.length;i++){
		var name = disabledList[i].attr("name");
		$("input[name="+name+"]").attr("disabled","disabled");
		$("input[name="+name+"]").next().removeClass("jNiceCheckbox").addClass("jNiceCheckbox_disabled");
	}
	
	for(var i=0;i<undisabledList.length;i++){
		var name = undisabledList[i].attr("name");
		$("input[name="+name+"]").removeAttr("disabled");
		$("input[name="+name+"]").next().removeClass("jNiceCheckbox_disabled").addClass("jNiceCheckbox");
	}
	jNiceClassFilter();			
}
function jNiceClassFilter(){

   var a1 = $("input[name=IsBeForwardModify]");
   var a2 = $("input[name=IsSubmitedOpinion]");
   var a3 = $("input[name=IsBeForwardSubmit]");
   var a4 = $("input[name=IsWaitForwardOpinion]");
   var a5 = $("input[name=IsBeForwardTodo]");

   var array = [a1,a2,a3,a4,a5];
   var p;
   while(p = array.shift()){
      if(p.is(":disabled")){
         p.removeAttr("checked");
      }
   }
}
function CheckClick(checkname){
   jNiceClassFilter();
   var disabledList = new Array();
   var undisabledList = new Array();
   var checkList = new Array();
   var uncheckList = new Array();

   var a1 = $("input[name=IsBeForwardModify]");
   var a2 = $("input[name=IsSubmitedOpinion]");
   var a3 = $("input[name=IsBeForwardSubmit]");
   var a4 = $("input[name=IsWaitForwardOpinion]");
   var a5 = $("input[name=IsBeForwardTodo]");

   //全不选

   if( !a1.is(':checked')&&
       !a2.is(':checked')&&
       !a3.is(':checked')&&
       !a4.is(':checked')){
	    disabledList = [a4];
	    undisabledList = [a1,a2,a3];
	    checkList = [];
	    uncheckList = [a1,a2,a3,a4];
   }else if( a1.is(':checked')&&
            !a2.is(':checked')&&
            !a3.is(':checked')&&
            !a4.is(':checked')){
	    disabledList = [];
	    undisabledList = [a2,a3,a4];
	    checkList = [];
	    uncheckList = [a2,a3,a4];
   }else if(a2.is(':checked')){
	    disabledList = [a3,a4];
	    undisabledList = [a1];
	    checkList = [];
	    uncheckList = [a3,a4];
   }else if(a3.is(':checked')||a4.is(':checked')){
        disabledList = [a2];
        undisabledList = [a1,a3,a4];
        checkList = [];
	    uncheckList = [a2];
   }else{
        disabledList = [];
	    undisabledList = [];
	    checkList = [];
	    uncheckList = [];
   }
   changejNiceClass(disabledList,undisabledList,checkList,uncheckList);
}
// 关闭
function btnclose_onclick(){
    	if(dialog){
			dialog.close();
   		}
}
// 保存
function btnok_onclick(){
		SearchForm.submit();  
}
jQuery(document).ready(function(){
	<%if(action.equals("save")){%>
		var ids="",names="";
        jQuery("input[type=checkbox]").each(function(){
           if(jQuery(this).is(":checked")){
            ids +=  jQuery(this).attr("name")+"_1,";
            names += jQuery(this).parent().next("span").html()+",";
           }else{
            ids +=  jQuery(this).attr("name")+"_0,";
           }
        });
        if(ids!=""){
        	ids = ids.substring(0,ids.length-1);
        	names = names.substring(0,names.length-1);
        }   
        var returnjson = {id:ids,name:names};
		if(dialog){
			try{
				dialog.callback(returnjson);
			}catch(e){
			}
			dialog.close(returnjson);
   		}
<%}%>
});
</script>
