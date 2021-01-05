<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
	<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>

<HTML><HEAD>
<script type="text/javascript">
var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}catch(e){}
</script>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
String Members=Util.null2String(request.getParameter("Members"));
String Memname="";
String MembersName="";
ArrayList Members_proj = Util.TokenizerString(Members,",");
int Membernum = Members_proj.size();
%>
<BODY style="overflow:hidden;"> 
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="proj"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("2097",user.getLanguage()) %>'/>
</jsp:include>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="ProjectManagerBrowser.jsp" method=post>


		<TABLE class=Shadow>
		<tr>
		<td valign="top">


<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" style="width:100%">
<TR class=DataHeader>
<TH><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TH>
<TH>部门</TH>
<TH>分部</TH>
<TR class=Line><Th colspan="3" ></Th></TR> 
<%
for(int i=0;i<Membernum;i++){
    Memname= Memname+"<a href=\"/hrm/resource/HrmResource.jsp?id="+Members_proj.get(i)+"\">"+Util.toScreen(ResourceComInfo.getResourcename(""+Members_proj.get(i)),user.getLanguage())+"</a>";
    Memname+=" ";
    //MembersName+=ResourceComInfo.getResourcename(""+Members_proj.get(i))+",";
    if(i%2==0) {
%>
<TR class=DataLight>
<%
	}else{
%>
<TR class=DataDark>
	<%
	}
	%>
	<TD style="display:none"><%=Members_proj.get(i)%></TD>
	<TD>&nbsp;&nbsp;&nbsp;<%=Util.toScreen(ResourceComInfo.getResourcename(""+Members_proj.get(i)),user.getLanguage())%></TD>	
	<TD><%=Util.toScreen(DepartmentComInfo.getDepartmentname( ResourceComInfo.getDepartmentID (""+Members_proj.get(i))),user.getLanguage())%></TD>	
	<TD><%=Util.toScreen(SubCompanyComInfo.getSubCompanyname( ResourceComInfo.getSubCompanyID (""+Members_proj.get(i))),user.getLanguage())%></TD>
</TR>
<%}%>
</TABLE>
</td>
		</tr>
		</TABLE>
	

</FORM>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="btnclear_onclick();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btncancel_onclick()">
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


<SCRIPT type="text/javascript">


 function BrowseTable_onmouseover(e){
	e=e||event;
   var target=e.srcElement||e.target;
   if("TD"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }else if("A"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }
}
function BrowseTable_onmouseout(e){
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
}

function BrowseTable_onclick(e){
   var e=e||event;
   var target=e.srcElement||e.target;

   if( target.nodeName =="TD"||target.nodeName =="A"  ){
	   if(dialog){
			var returnjson={id:jQuery(jQuery(target).parents("tr")[0].cells[0]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[1]).text()};
			try{
	            dialog.callback(returnjson);
	       }catch(e){}
	       /**
		  	try{
		       dialog.close(returnjson);
		   }catch(e){}**/
		}else{
			window.parent.parent.returnValue = {id:jQuery(jQuery(target).parents("tr")[0].cells[0]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[1]).text()};
			 window.parent.parent.close();
		}  
	}
}

function btnclear_onclick(){
     //window.parent.returnValue = {id:"",name:""};
     //window.parent.close();
     if( dialog){
 		var returnjson={id:"",name:""};
 		try{
             dialog.callback(returnjson);
        }catch(e){}
 	  	/**try{
 	       dialog.close(returnjson);
 	   }catch(e){}**/
 	}else{
 		//window.parent.returnValue = {id:"",name:""};
 		//window.parent.close();
 		window.parent.parent.returnValue ={id:"",name:""};
 		window.parent.parent.close();
 	}
}

$(function(){
	$("#BrowseTable").mouseover(BrowseTable_onmouseover);
	$("#BrowseTable").mouseout(BrowseTable_onmouseout);
	$("#BrowseTable").click(BrowseTable_onclick);
	$("#btnclear").click(btnclear_onclick);
	
});
</SCRIPT>
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
function btncancel_onclick(){
	if(dialog){
  	dialog.close();
  }else{
    window.parent.parent.close();
	}   
}
</script>
