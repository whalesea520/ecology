<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">
		try{
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("15812",user.getLanguage())%>");
		}catch(e){
			if(window.console)console.log(e+"-->BankBrowser.jsp");
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
String bankname=Util.null2String(request.getParameter("bankname"));
String bankdesc=Util.null2String(request.getParameter("bankdesc"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!bankname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where bankname like '%" + Util.fromScreen2(bankname,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and bankname like '%" + Util.fromScreen2(bankname,user.getLanguage()) +"%' ";
}
if(!bankdesc.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where bankdesc like '%" + Util.fromScreen2(bankdesc,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and bankdesc like '%" + Util.fromScreen2(bankdesc,user.getLanguage()) +"%' ";
}

String sqlstr = "select * from HrmBank" + sqlwhere ;
%>
<BODY>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM NAME=SearchForm id="SearchForm" STYLE="margin-bottom:0" action="BankBrowser.jsp" method=post>
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
<BUTTON class=btnReset accessKey=T type=reset onclick="doReset()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="btncancel_onclick()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>

<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item><input name=bankname value='<%=bankname%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
		<wea:item><input name=bankdesc value='<%=bankdesc%>'></wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(33046,user.getLanguage())%>' attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true'}">
			<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0;width: 100%">
			<TR class=DataHeader>
	      <TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      
	      <TH width=30%><%=SystemEnv.getHtmlLabelName(185,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>      
	      <TH width=70%><%=SystemEnv.getHtmlLabelName(185,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH>
			<%
			int i=0;
			RecordSet.executeSql(sqlstr);
			while(RecordSet.next()){
				String ids = RecordSet.getString("id");
				String banknames = Util.toScreen(RecordSet.getString("bankname"),user.getLanguage());
				String bankdescs = Util.toScreen(RecordSet.getString("bankdesc"),user.getLanguage());
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
				<TD style="display:none"><A HREF=#><%=ids%></A></TD>
				<TD><%=banknames%></TD>
				<td><%=bankdescs%></td>
			</TR>
			<%}
			%>
			</TABLE>
		</wea:item>
	</wea:group>
</wea:layout>
  <input type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
</FORM>
</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col" needImportDefaultJsAndCss="false">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button"  class="zd_btn_submit" id="btnclear" onclick="btnclear_onclick();" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>">
        <input type="button"  class="zd_btn_cancle" id="btncancel" onclick="btncancel_onclick()" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>">
			</wea:item>
		</wea:group>
	</wea:layout>		
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
	</div>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY>
</HTML>
<script>
  function doSearch(){
    jQuery("#SearchForm").submit();
  }
  
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
    }		 
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
		window.parent.parent.returnValue = {id:"",name:""};
    window.parent.parent.close();
	}
}  

function doReset(){
      jQuery("input[name=bankname]").val('');
      jQuery("input[name=bankdesc]").val('');
}

function btncancel_onclick(){
	if(dialog){
		dialog.close();
	}else{
    window.parent.close();
  }
}

jQuery(function(){
	jQuery("#BrowseTable").mouseover(BrowseTable_onmouseover);
	jQuery("#BrowseTable").mouseout(BrowseTable_onmouseout);
	jQuery("#BrowseTable").click(BrowseTable_onclick);
	
	jQuery("#btnclear").click(btnclear_onclick);
	
});  
</script>
