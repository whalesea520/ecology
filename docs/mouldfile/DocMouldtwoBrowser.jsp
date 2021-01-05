
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.*" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MouldManager" class="weaver.docs.mouldfile.MouldManager" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="CareerPlanComInfo" class="weaver.hrm.career.CareerPlanComInfo" scope="page"/>
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<% 
String urlfrom = Util.null2String(request.getParameter("urlfrom"));
%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames(urlfrom.equals("hr")?"15786":"28052",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e);
	}
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
	
	function btnOnSearch(){
		document.SearchForm.submit();
	}
	
	function onClose(){
		 if(dialog){
	    	dialog.close()
	    }else{
		    window.parent.close();
		}
	}
</script>

</HEAD>

<BODY scroll="auto">
<div class="zDialog_div_content">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<%
String hrmdetachable="0";
boolean isUseHrmManageDetach=ManageDetachComInfo.isUseHrmManageDetach();
int subcompanyid1 = Util.getIntValue(request.getParameter("subcompanyid1"),0);
if(isUseHrmManageDetach){
   hrmdetachable="1";
   session.setAttribute("detachable","1");
   session.setAttribute("hrmdetachable",hrmdetachable);
   subcompanyid1 = Util.getIntValue(ManageDetachComInfo.getHrmdftsubcomid());
}else{
   hrmdetachable="0";
   session.setAttribute("detachable","0");
   session.setAttribute("hrmdetachable",hrmdetachable);
}

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
String doctype = request.getParameter("doctype");

if(doctype!=null&&"".equals(doctype)) doctype = "0";
else if(doctype!=null&&!"".equals(doctype)){
	if(doctype.equals(".htm")) doctype = "0";
	else if(doctype.equals(".doc")) doctype = "2";
	else if(doctype.equals(".xls")) doctype = "3";
	else if(doctype.equals(".wps")) doctype = "4";
	else if(doctype.equals(".et")) doctype = "5";
}


String imagefilename = "/images/hdMaintenance_wev8.gif";
String needfav ="1";
String needhelp ="";
String titlename = "";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<FORM NAME=SearchForm STYLE="margin-bottom:0;margin-right:0">
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON type="button" class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
  
<wea:layout>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true'}">
			<wea:layout type="table"  attributes="{'formTableId':'BrowseTable','cols':'2'}" needImportDefaultJsAndCss="false">
				<wea:group context="" attributes="{'groupDisplay':'none'}">
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>

						<%
						int i= 0;
						String sqlstr = "";
						if(detachable==1 && user.getUID()!=1){
							sqlstr = "select id,mouldname,mouldType from DocMouldFile WHERE ID  IN (Select TEMPLETDOCID From HrmContractTemplet where subcompanyid = "+subcompanyid1+")and mouldType="+Util.getIntValue(doctype,-1)+" order by id asc" ;
						}else{
							sqlstr = "select id,mouldname,mouldType from DocMouldFile WHERE ID  IN (Select TEMPLETDOCID From HrmContractTemplet)and mouldType="+Util.getIntValue(doctype,-1)+" order by id asc" ;
						}


						//System.out.println("sqlstr###:"+sqlstr);
						rs.executeSql(sqlstr);
						while(rs.next()) {
							String id = rs.getString("id") ;
							//String templetdocid = Util.toScreen(rs.getString("templetdocid"),user.getLanguage()) ;
							String mouldname = Util.toScreen(rs.getString("mouldname"),user.getLanguage()) ;
						%>

							<wea:item><%=id%></wea:item>
							<wea:item><%=mouldname%></wea:item>
						<%}%>
				</wea:group>
			</wea:layout>
		</wea:item>
	</wea:group>
</wea:layout>
</form>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
				<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="submitClear();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
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
jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr").bind("click",function(){
			
			if(dialog){
				try{
				dialog.callback({id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()});
				}catch(e){}
				try{
				dialog.close({id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()});
				}catch(e){}
			}else{
				window.parent.returnValue = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()};
				window.parent.close()
			}
		})
	jQuery("#BrowseTable").find("tr").bind("mouseover",function(){
			$(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr").bind("mouseout",function(){
			$(this).removeClass("Selected")
		})

})
function submitClear()
{
	if(dialog){
		try{
		dialog.callback({id:"",name:""});
		}catch(e){}
		try{
		dialog.close({id:"",name:""});
		}catch(e){}
	}else{
		window.parent.returnValue = {id:"",name:""};
		window.parent.close()
	}
}
</script>
<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick()
     window.parent.returnvalue = Array(0,"")
     window.parent.close
End Sub
Sub BrowseTable_onclick()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then   	
     window.parent.returnvalue = Array(e.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText)
    //  window.parent.returnvalue = e.parentelement.cells(0).innerText
      window.parent.Close
   ElseIf e.TagName = "A" Then
      window.parent.returnvalue = Array(e.parentelement.parentelement.cells(0).innerText,e.parentelement.parentelement.cells(1).innerText)
     // window.parent.returnvalue = e.parentelement.parentelement.cells(0).innerText
      window.parent.Close
   End If
End Sub
Sub BrowseTable_onmouseover()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then
      e.parentelement.className = "Selected"
   ElseIf e.TagName = "A" Then
      e.parentelement.parentelement.className = "Selected"
   End If
End Sub
Sub BrowseTable_onmouseout()
   Set e = window.event.srcElement
   If e.TagName = "TD" Or e.TagName = "A" Then
      If e.TagName = "TD" Then
         Set p = e.parentelement
      Else
         Set p = e.parentelement.parentelement
      End If
      If p.RowIndex Mod 2 Then
         p.className = "DataLight"
      Else
         p.className = "DataDark"
      End If
   End If
End Sub

</SCRIPT>
