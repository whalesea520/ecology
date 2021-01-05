<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("15879",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e+"-->HrmTrainResourceBrowser.jsp");
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
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String id = Util.null2String(request.getParameter("id"));
String name = Util.null2String(request.getParameter("name"));
String fare = Util.null2String(request.getParameter("fare"));
String time = Util.null2String(request.getParameter("time"));
String type = Util.null2String(request.getParameter("type"));
String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(!name.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where name like '%";
		sqlwhere += Util.fromScreen2(name,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and name like '%";
		sqlwhere += Util.fromScreen2(name,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!fare.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where fare like '%"+Util.fromScreen2(fare,user.getLanguage())+"%' ";
	}
	else{
		sqlwhere += " and fare like '%"+Util.fromScreen2(fare,user.getLanguage())+"%' ";
	}
}
if(!time.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where time like '%"+Util.fromScreen2(time,user.getLanguage())+"%' ";
	}
	else{
		sqlwhere += " and time like '%"+Util.fromScreen2(time,user.getLanguage())+"%' ";
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
if(!type.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where type_n ="+Util.fromScreen2(type,user.getLanguage());		
	}
	else{
		sqlwhere += " and type_n ="+Util.fromScreen2(type,user.getLanguage());		
	}
}

%>
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
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<FORM NAME=SearchForm id="SearchForm" STYLE="margin-bottom:0" action="HrmTrainResourceBrowser.jsp" method=post>
<input class=inputstyle type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere1)%>">
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:jsClose(),_self} " ;
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
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1360,user.getLanguage())%>'>
    <wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
    <wea:item>
      <input class=inputstyle size=10 name=name value="<%=id%>">
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
    <wea:item>
      <select class=inputstyle name=type value="<%=type%>">
        <option value="" <%if(type.equals("")){%>selected <%}%>></option>
        <option value=1 <%if(type.equals("1")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%></option>
        <option value=0 <%if(type.equals("0")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(1994,user.getLanguage())%></option>
      </select>
    </wea:item>    
    <wea:item><%=SystemEnv.getHtmlLabelName(1491,user.getLanguage())%></wea:item>
    <wea:item>
      <input class=inputstyle size=10 name=fare value="<%=fare%>">
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15386,user.getLanguage())%></wea:item>
    <wea:item>
      <input class=inputstyle size=20 name=time value="<%=time%>">
    </wea:item>
	</wea:group>
</wea:layout>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0;width: 100%">
<TR class=DataHeader>
<TH width=40%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
<TH width=20%><%=SystemEnv.getHtmlLabelName(1491,user.getLanguage())%></TH>
<TH width=20%><%=SystemEnv.getHtmlLabelName(15386,user.getLanguage())%></TH>
<TH width=20%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TH>
</tr><TR class=Line><TH colspan="4" ></TH></TR>
<%
int i=0;
sqlwhere = "select * from HrmTrainResource "+sqlwhere;
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
	<TD style="display:none"><A HREF=#><%=rs.getString("id")%></A></TD>
	<TD><%=rs.getString("name")%></A></TD>
	<TD><%=rs.getString("fare")%></TD>	
	<TD><%=rs.getString("time")%></TD>	
	<TD>
	  <%if(rs.getString("type_n").equals("1")){%><%=SystemEnv.getHtmlLabelName(16165,user.getLanguage())%><%}%>
	  <%if(rs.getString("type_n").equals("0")){%><%=SystemEnv.getHtmlLabelName(16166,user.getLanguage())%><%}%>
	</TD>	
</TR>
<%}%>
</TABLE></FORM>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
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
      window.parent.returnvalue = Array(e.parentelement.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText)
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
   var returnjson = { id:jQuery(curTr.cells[0]).text(), name:jQuery(curTr.cells[1]).text()};
	 if(dialog){
	 	dialog.callback(returnjson);
	 }else{    
	 	window.parent.parent.returnValue = returnjson;
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

jQuery(function(){
	jQuery("#BrowseTable").mouseover(BrowseTable_onmouseover);
	jQuery("#BrowseTable").mouseout(BrowseTable_onmouseout);
	jQuery("#BrowseTable").click(BrowseTable_onclick);
	
	//$("#btncancel").click(btncancel_onclick);
	//$("#btnsub").click(btnsub_onclick);
	
	jQuery("#btnclear").click(btnclear_onclick);
	
});

function doSearch(){
  jQuery("#SearchForm").submit();
}

function doReset(){
  jQuery("#SearchForm")[0].reset();
}


function jsClose(){
	if(dialog){
   	dialog.close();
  }else{
    window.parent.close();
	}
}

</script>
