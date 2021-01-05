
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,java.util.Comparator" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" /> 
<jsp:useBean id="RequestRejectManager" class="weaver.workflow.request.RequestRejectManager" scope="page" />
<jsp:useBean id="WorkflowIsFreeStartNode" class="weaver.workflow.request.WorkflowIsFreeStartNode" scope="page" />

<%
    int requestid=Util.getIntValue(Util.null2String(request.getParameter("requestid")),0);
	int workflowid=Util.getIntValue(Util.null2String(request.getParameter("workflowid")),0);
	int isrejecttype=Util.getIntValue(Util.null2String(request.getParameter("isrejecttype")),0);
    int nodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
	int isFreeNode=Util.getIntValue(Util.null2String(request.getParameter("isFreeNode")),0);//是否自由节点 
	int isrejectremind=Util.getIntValue(Util.null2String(request.getParameter("isrejectremind")),0);
	int ischangrejectnode=Util.getIntValue(Util.null2String(request.getParameter("ischangrejectnode")),0);
	RecordSet.executeSql("select startnodeid from workflow_nodebase where id="+nodeid);
	String startnodeid="";//自由流程的开始节点

	if(RecordSet.next()){
		startnodeid=RecordSet.getString("startnodeid");
	}
	
	String startnodeid01="";
        String sql02="";
         if("oracle".equals(RecordSet.getDBType())){
            sql02="select nodeid from workflow_nodelink  where nvl(isreject,0)!=1   and destnodeid="+nodeid;
         }else{
                            sql02="select nodeid from workflow_nodelink  where isnull(isreject,0)!=1  and destnodeid="+nodeid;
                }

	RecordSet.executeSql(sql02);
	if(RecordSet.next()){
		startnodeid01=RecordSet.getString("nodeid");
	}
	 

    ArrayList list=new ArrayList();
	List listnodeid=WorkflowIsFreeStartNode.getAllNodeid(""+nodeid,""+workflowid,""+startnodeid,list);

    Collections.sort(listnodeid);
	Collections.sort(listnodeid, new Comparator() {
	public int compare(Object o1, Object o2) {
	    return new Double((String) o1).compareTo(new Double((String) o2));
	  }
	});
       
	 
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" type="text/css" href="/css/xpSpin_wev8.css">
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>

<BODY style="overflow:hidden">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(84508,user.getLanguage())%>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onsave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btnclose_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<wea:layout>
<%
if(isrejecttype!=1){
%>
  <wea:group context='<%=SystemEnv.getHtmlLabelName(26437,user.getLanguage())%>'>
	     <wea:item attributes="{'isTableList':'true'}">
	        <table class="ListStyle" id="oTable" cellspacing=0>
	            <COLGROUP>
					<COL width="30%">
					<COL width="70%">
				</COLGROUP>
				<tr class=header>
					<td><%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%></td>
					<td><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></td>
				</tr>
				<%
	             for(int i=0;i<listnodeid.size();i++){
	            	 String nodeidst=(String)listnodeid.get(i);
	            	 RecordSet.executeSql("select nodename from workflow_nodebase where id="+nodeidst);
	                 String nodename="";
	            	 if(RecordSet.next()){
	            		 nodename=RecordSet.getString("nodename");
	                 }
	            %>
	            <tr class=DataDark>
					<td>
					 <input type="radio" name="rejectnodeid" onchange="checkIfSingle(this)" value="<%=nodeidst %>"  <%if(nodeidst.equals(startnodeid01)){%>checked<%}%>>
					</td>
					<td>
					<%=nodename %>
					</td>
				</tr>
 		        <%}%>
		    </table>
	     </wea:item> 
  </wea:group>
<%}%>
<%if(isrejectremind==1&&ischangrejectnode==1){ %>
    <wea:group context='<%=SystemEnv.getHtmlLabelName(26438,user.getLanguage())%>'>
	    <wea:item attributes="{'isTableList':'true'}">
	        <table class="ListStyle" id="oTable" cellspacing=0>
	            <COLGROUP>
					<COL width="30%">
					<COL width="70%">
				</COLGROUP>
				<tr class=header>
		            <td><input type="checkbox" value="-1" id="checkall" checked onclick="oncheckall(this)"><%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%></td>
		            <td><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></td>
				</tr>
				<%
	             for(int i=0;i<listnodeid.size();i++){
	            	 String nodeidst=(String)listnodeid.get(i);
	            	 RecordSet.executeSql("select nodename from workflow_nodebase where id="+nodeidst);
	                 String nodename="";
	            	 if(RecordSet.next()){
	            		 nodename=RecordSet.getString("nodename");
	                 }
	            %>
	            <tr class=DataLight>
 					<td>
				        <input type="checkbox" name="nodeid_<%=nodeidst%>" value="<%=nodeidst%>" checked onclick="clearcheckall()">
				    </td>
				    <td>
				        <%=nodename %>
				    </td>
				</tr>
				<%}%>
				<% 
				 RecordSet.executeSql("select nodename from workflow_nodebase where id="+nodeid);
				 String nodename="";
				 if(RecordSet.next()){
					 nodename=RecordSet.getString("nodename");
				 }
				%>
				 <tr class=DataLight>
					 <td>
					     <input type="checkbox" name="nodeid_<%=nodeid%>" value="<%=nodeid%>" checked onclick="clearcheckall()">
					 </td>
					 <td>
				        <%=nodename %>
				     </td>
				</tr>
		    </table>
		</wea:item>
	</wea:group>
<%}%>
</wea:layout>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes='{\"groupDisplay\":\"none\"}'>
			<wea:item type="toolbar">
		    	<input type="button" value="<%="O-"
					+ SystemEnv.getHtmlLabelName(826, user.getLanguage())%>"
								id="zd_btn_submit_0" class="zd_btn_submit" onclick="onsave();">
				<input type="button" accessKey=T id=btncancel
								value="<%="T-"
					+ SystemEnv.getHtmlLabelName(201, user.getLanguage())%>"
								id="zd_btn_cancle" class="zd_btn_cancle" onclick="btnclose_onclick();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script language=javascript>

var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}catch(e){
}

// 关闭
function btnclose_onclick(){
    if(dialog){
        try{
		dialog.close();
		}catch(e){
		}
	}else{
	    window.parent.close();
	}
}

function callback(returnjson){
	if(dialog){
		try{
			dialog.callback(returnjson);
		}catch(e){
		}
		dialog.close(returnjson);
	}else{ 
	   	window.parent.returnValue  = returnjson;
	   	window.parent.close();
	}
}

function oncheckall(obj){
    	if(jQuery(obj).is(":checked")){
	       jQuery("input[name^=nodeid_]").each(function(){
	        	changeCheckboxStatus($(this),true);
		   });
       }else{
	       jQuery("input[name^=nodeid_]").each(function(){
	        	changeCheckboxStatus($(this),false);
		   });
       }
}

function clearcheckall(){
     if($G("checkall").checked){
          changeCheckboxStatus($("#checkall"),false);
     }
}

function getRadioValue(name){
if(document.getElementsByName(name)){
var radioes = document.getElementsByName(name);
for(var i=0;i<radioes.length;i++)
{
     if(radioes[i].checked){
      return radioes[i].value;
     }
}
}
return "";
}

 function onsave(){
    var nodeids="";
    var rejectnodeid="";
    <%if(ischangrejectnode==1){%>
    
       if($G("checkall").checked){ 
		    nodeids="-1";
       }else{ 
        <%
        for(int j=0;j<listnodeid.size();j++){
        %>
        if($G("nodeid_<%=listnodeid.get(j)%>").checked){
            if(nodeids.length>0){
                nodeids+=","+$G("nodeid_<%=listnodeid.get(j)%>").value;
            }else{
                nodeids=$G("nodeid_<%=listnodeid.get(j)%>").value;
            }
        }
        <%}%>
         if($G("nodeid_<%=nodeid%>").checked){
            if(nodeids.length>0){
                nodeids+=","+$G("nodeid_<%=nodeid%>").value;
            }else{
                nodeids=$G("nodeid_<%=nodeid%>").value;
            }
         }
        
        //alert(nodeids);
           }
    <%}%>
    
    <%
    if(isrejecttype!=1){
    %>
	    rejectnodeid=getRadioValue("rejectnodeid");
	    if(rejectnodeid==""){
	        alert("<%=SystemEnv.getHtmlLabelName(26436,user.getLanguage())%>");
	        return false;
	    }
    <%}%>
    
      if(nodeids==""){
        nodeids=rejectnodeid;
      }
     var returnjson = {id:nodeids,name:nodeids+'|'+rejectnodeid+"|0"}
     callback(returnjson);
}
function checkIfSingle(obj){
	if(jQuery(obj).is(":checked")){
		jQuery(obj).next(".jNiceRadio").addClass("jNiceChecked");
	}
}
</script>
</body>
</html>


