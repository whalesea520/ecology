<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String sqlwhere1 = sqlwhere ;
int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if (ishead == 0) {
	sqlwhere = "where subassortmentcount = 0";
}
else
	sqlwhere += " and subassortmentcount = 0";

String sqlstr = "select * from LgcAssetAssortment " ;
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class="Shadow">
		<tr>
		<td valign="top">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="LgcAssetAssortmentBrowser.jsp" method=post>
<DIV align=right style="display:none">
<!-- onclick 单击事件 的关闭页面的函数应该用window.parent.close() 之前出现错误是window.close() 这样写只有IE能识别 -->
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<!-- onclick 单击事件 的关闭页面的函数应该用window.parent.close() 之前出现错误是window.close() 这样写只有IE能识别 -->
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=2 id=btnclear onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table ID="BrowseTable" class="BroswerStyle"  cellspacing="1">
<tr class="DataHeader">
	  <th width=0% style="display:none" ></th>  
	  <th width=30% ><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></th>    
      <th width=30% ><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th></tr><tr class="Line"><th colSpan="3"></th>
</tr>
<%
int i=0;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String assortmentid = RecordSet.getString("id");
	String assortmentmark = Util.toScreen(RecordSet.getString("assortmentmark"),user.getLanguage());
	String assortmentname = Util.toScreen(RecordSet.getString("assortmentname"),user.getLanguage());
if(i==0){
		i=1;
%>
<tr class="DataLight">
<%
	}else{
		i=0;
%>
<tr class="DataDark">
<%
}
%>
	<!-- 给现实列宽的td定义列宽 2012-08-07 ypc 修改 start -->
	<td width=0% style="display:none"><a href="#"><%=assortmentid%></a></td>
    <td  width="800px;"><%=assortmentid%></td>
	<td  width="800px;"><%=assortmentname%></td>
	<!-- 给现实列宽的td定义列宽 2012-08-07 ypc 修改 end -->
</tr>
<%}
%>

</table>
  <input type="hidden" name="sqlwhere1" value="<%=xssUtil.put(sqlwhere)%>">
</FORM>
		</td>
		</tr>
		</TABLE>
	</td>
	
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY></HTML>


<SCRIPT type="text/javascript">
var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}catch(e){}
function btnclear_onclick(e){
     var returnValue = {id:"",name:"",name2:""};
     if(dialog){
			try{
	           dialog.callback(returnValue);
		       dialog.close(returnValue);
		   }catch(e){}
	  }else{
	      window.parent.returnValue = returnValue;
	      window.parent.close();
      }
}

jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
	jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
})

function BrowseTable_onclick(e){
	var  target = e.srcElement||e.target;
	if( target.nodeName =="TD"||target.nodeName =="A"  ){  	
	 var returnValue = {id:jQuery(jQuery(target).parents("tr")[0].cells[0]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[2]).text(),name2:jQuery(jQuery(target).parents("tr")[0].cells[2]).text()};
	 if(dialog){
			try{
	           dialog.callback(returnValue);
		       dialog.close(returnValue);
		   }catch(e){}
	  }else{
	      window.parent.returnValue = returnValue;
	      window.parent.close();
      }
   }
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

</SCRIPT>
