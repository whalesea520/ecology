
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.moduledetach.ManageDetachComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<script type="text/javascript">
		try{
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("15786",user.getLanguage())%>");
		}catch(e){
			if(window.console)console.log(e+"-->HrmConTempletBrowser.jsp");
		}
		var parentWin = null;
		var dialog = null;
		try{
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		}
		catch(e){}
	</script>
</HEAD>
<%
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String id = Util.null2String(request.getParameter("id"));
String templetname = Util.null2String(request.getParameter("templetname"));
String templetdocid = Util.null2String(request.getParameter("templetdocid"));
String  subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
int detachable=0;//Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(!templetname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where templetname like '%";
		sqlwhere += Util.fromScreen2(templetname,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and templetname like '%";
		sqlwhere += Util.fromScreen2(templetname,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!templetdocid.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where templetdocid ="+Util.fromScreen2(templetdocid,user.getLanguage());		
	}
	else{
		sqlwhere += " and templetdocid ="+Util.fromScreen2(templetdocid,user.getLanguage());		
	}
}
if(!id.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where id ="+Util.fromScreen2(id,user.getLanguage());		
	}
	else{
		sqlwhere += " and id  ="+Util.fromScreen2(id,user.getLanguage());		
	}
}

ManageDetachComInfo comInfo = new ManageDetachComInfo();
String hrmdftsubcomid = comInfo.getHrmdftsubcomid();
if(detachable==1){
	if(ishead==0){
		if(subcompanyid!= null &&!subcompanyid.equals(""))
		ishead = 1;
		if(subcompanyid.equals("-1")){
			subcompanyid = hrmdftsubcomid;
		}
		sqlwhere += " where subcompanyid = "+subcompanyid;		
	}
	else{
		if(subcompanyid.equals("-1")){
			subcompanyid = hrmdftsubcomid;
		}
		sqlwhere += " and subcompanyid = "+subcompanyid;
	}

}

%>
<BODY>
	<div class="zDialog_div_content">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type=button class="e8_btn_top" onclick="document.SearchForm.submit();" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>">
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<FORM NAME=SearchForm id="SearchForm" STYLE="margin-bottom:0" action="HrmConTempletBrowser.jsp" method=post>
<input class=inputstyle type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere1)%>">
<input class=inputstyle type=hidden name=subcompanyid value="<%=subcompanyid%>">
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:doReset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
	  <wea:item><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></wea:item>
    <wea:item>
      <input class=inputstyle size=10 id=id name=id value="<%=id%>">
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
    <wea:item>
      <input class=inputstyle size=20 id=templetname name=templetname value="<%=templetname%>">
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></wea:item>
    <wea:item>
      <input class=inputstyle size=10 id=templetdocid name=templetdocid value="<%=templetdocid%>">
    </wea:item>
	</wea:group>
</wea:layout>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0;width: 100%">
<TR class=DataHeader>
<TH width=30%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TH>
</tr><TR class=Line><TH colspan="4" ></TH></TR>
<%
int i=0;	
sqlwhere = "select * from HrmContractTemplet "+sqlwhere;
rs.execute(sqlwhere);
while(rs.next()){
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
	<TD><A HREF=#><%=rs.getString(1)%></A></TD>
	<TD><%=rs.getString(2)%></TD>	
	<TD><%=rs.getString(3)%></TD>	
</TR>
<%}%>
</TABLE></FORM>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btnclear_onclick();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
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


<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick1()
     window.parent.returnvalue = Array(0,"")
     window.parent.close
End Sub
Sub BrowseTable_onclick1()
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
Sub BrowseTable_onmouseover1()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then
      e.parentelement.className = "Selected"
   ElseIf e.TagName = "A" Then
      e.parentelement.parentelement.className = "Selected"
   End If
End Sub
Sub BrowseTable_onmouseout1()
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
<script>
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
	 var curTr=jQuery(target).parents("tr")[0];
	 var returnjson = {
    		 id:jQuery(curTr.cells[0]).text(),
    		 name:jQuery(curTr.cells[1]).text()
    		 };
    
    	if(dialog){
    		   	dialog.callback(returnjson);
    	}else{ 
     		window.parent.parent.returnValue =returnjson;
      	window.parent.parent.close();
      }
	}
}

function btnclear_onclick(){
  var returnjson = {id:"",name:""};
	if(dialog){
		dialog.callback(returnjson);
	}else{
    window.parent.parent.returnValue = returnjson;
    window.parent.parent.close();
  }
}

function btncancel_onclick(){
	if(dialog){
		dialog.close();
	}else{
    window.parent.parent.close();
  }
}

jQuery(function(){
	jQuery("#BrowseTable").mouseover(BrowseTable_onmouseover);
	jQuery("#BrowseTable").mouseout(BrowseTable_onmouseout);
	jQuery("#BrowseTable").click(BrowseTable_onclick);
	
	//$("#btncancel").click(btncancel_onclick);
	//$("#btnsub").click(btnsub_onclick);
	$("#btnclear").click(btnclear_onclick);
});

function doSearch(){
   jQuery("#SearchForm").submit();
}

function doReset(){
	jQuery("#id").val("");
	jQuery("#templetname").val("");
	jQuery("#templetdocid").val("");
}

</script>
