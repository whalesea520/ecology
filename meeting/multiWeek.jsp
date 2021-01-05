<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.meeting.MeetingBrowser"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
 String rptWeekDays=","+Util.null2String(request.getParameter("selectedids"))+","; 
int langid=user.getLanguage();
 Map<String,String> map=MeetingBrowser.getWeekMap();
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(81911,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btn_cancle(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="meeting"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(81911,user.getLanguage()) %>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span id="hoverBtnSpan" class="hoverBtnSpan">
			
	</span>
</div>


<FORM id=weaver name=weaver action="" method=post >
		<TABLE class=Shadow>
			<tr>
				<td valign="top">
				<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
					<wea:group context="" attributes="{'groupDisplay':'none'}">
					<wea:item attributes="{'isTableList':'true'}">
					<TABLE CLASS="ListStyle" valign="top" cellspacing=1 style="position:fixed;z-index:99!important;">
					      <colgroup>
					      <col width="10%">                           
					      <col width="90%">
					     <TR class=HeaderForXtalbe>
						  	<th><input name="chkAll" type="checkbox" onclick="jsChkAll(this)"></th>
						  	<th><%=SystemEnv.getHtmlLabelName(18518,user.getLanguage())%></th>
						 </TR>
						 
						 <%if(map.size()>0){
							 Iterator<String> it =map.keySet().iterator();
							 while(it.hasNext()){
								 String i=it.next();
						 %>	<tr class="" style="vertical-align: middle;" >
							  	<td><INPUT id="checkbox_<%=i %>" type="checkbox"  name="rptWeekDay" value="<%=i %>" <%if(rptWeekDays.indexOf(","+i+",")!=-1){%>checked<%}%>></td>
							  	<td onclick="ChkTr('<%=i %>')" id="checkname_<%=i %>"><%=MeetingBrowser.getWeekName(Util.getIntValue(i),langid)%></td>
							</TR>
							<tr class="Spacing" style="height:1px!important;">
							 	<td colspan="2" class="paddingLeft0Table"><div class="intervalDivClass"></div></td>
							</tr>
						 <%	}
						} %>
						 
					</TABLE>
					</wea:item>
					</wea:group>
				</wea:layout>
		 		</td>
			</tr>
		</table>
</FORM>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes='{\"groupDisplay\":\"none\"}'>
			<wea:item type="toolbar">
		    	<input type="button" class="zd_btn_submit" accessKey=O  id=btnok value="O-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" onclick="doSubmit()"></input>
				<input type="button" class="zd_btn_submit" accessKey=2  id=btnclear value="2-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" onclick="onClear()"></input>
				<input type="button" class="zd_btn_cancle" accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" onclick="onClose()"></input>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>   

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

function ChkTr(id){
	changeCheckboxStatus($('#checkbox_'+id),!$('#checkbox_'+id).attr("checked"));
}

function jsChkAll(obj){
	$("input[name='rptWeekDay']").each(function(){
		changeCheckboxStatus(this,obj.checked);
	}); 
}

function btn_cancle(){
	onClose();
}

function onClear()
{
	returnjson = {id:"",name:""};
   if(dialog){
   	 	try{
   	 		dialog.callback(returnjson);
   		}catch(e){}
   	
   		 try{
   			 dialog.close(returnjson)
   		 }catch(e){}
	}else{ 
  	  window.parent.returnValue  = returnjson;
  	  window.parent.close();
 	}
}

function doSubmit()
{	
	checkids="";
	checknames="";
	 
	$("input[name='rptWeekDay']:checked").each(function(){
		id=$(this).val();
		if(checkids==""){
			checkids=id;
			checknames=$('#checkname_'+id).text()
		}else{
			checkids+=","+id;
			checknames+=","+$('#checkname_'+id).text()
		}
		
	}); 
	
	 returnjson = {id:checkids,name:checknames};
   if(dialog){
   	 	try{
   	 		dialog.callback(returnjson);
   		}catch(e){}
   	
   		 try{
   			 dialog.close(returnjson)
   		 }catch(e){}
	}else{ 
  	  window.parent.returnValue  = returnjson;
  	  window.parent.close();
 	}
}

</script>
</HTML>
