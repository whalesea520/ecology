<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.RecordSet" %>
<HTML><HEAD>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<%
String titlename = "";
String needfav ="1";
String needhelp ="";

boolean isright = true;
String kbname = Util.null2String(request.getParameter("kbname"));
String sysversion = Util.null2String(request.getParameter("sysversion"));
String sysversionsql = "select * from CustomerSysVersion order by name desc";
%>
<BODY>
<div class="zDialog_div_content">

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{查询,javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{清除,javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="check"/>
   <jsp:param name="navName" value="选择系统版本"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="查询" class="e8_btn_top" onclick="submitData()"/>
			<span title="菜单" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<DIV align=right>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"></span> 
</div>
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'></div>


<FORM name=form1 STYLE="margin-bottom:0" action="SysBrowser.jsp" method=post>
<wea:layout type="4col">
<wea:group context="查询">
<wea:item>名称</wea:item>
<wea:item>
<input name="sysversion" value="<%=sysversion%>"></input>
</wea:item>
</wea:group>
</wea:layout>
<wea:layout type="4col">
	<wea:group context="系统版本列表">
		<wea:item attributes="{'isTableList':'true'}">
			<TABLE ID=BrowseTable class="ListStyle" cellspacing="0" style="width: 100%">
			<TR class=header>
			<TH style="display:none">ID</TH>
			<TH width=70%>名称</TH>
<%-- 			<TH width=30%>描述</TH> --%>
			</TR>
			<%
			RecordSet rs1 = new RecordSet();
			RecordSet rs2 = new RecordSet();
			rs1.executeSql(sysversionsql);
			String name = "";
			String description = "";
			while(rs1.next()) {
				String sysid = rs1.getString("id");
				name = rs1.getString("name");
				//description = rs1.getString("description");
				if("".equals(sysversion)||name.indexOf(sysversion)>-1) {
					
				
			%>
			<tr height="20px" class=<%if(isright){ %>DataLight<%}else{%>DataDark<%} %>>
					<td style="display:none"><%=name %></td>
					<td><%=name %></td>
			</tr>
			<%
				}
			}
			%>
			</TABLE>
		</wea:item>
	</wea:group>
</wea:layout>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	    <wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
			    	<input type="button" class=zd_btn_cancle accessKey=2  id=btnclear value="2-清除" onclick='onClear();'></input>
	        		<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-取消" onclick='closeDialog();'></input>
				</wea:item>
			</wea:group>
		</wea:layout>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				resizeDialog(document);
			});
		</script>
</div>
</FORM>
</DIV>
</BODY>
</HTML>

<script language="javascript">
var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}catch(e){}
function onClear()
{
	btnclear_onclick() ;
}
function onClose()
{
	if(dialog){
	    dialog.callback(returnjson);
	}else{ 
	    window.parent.close() ;
	 } 
}
function closeDialog(){
	if(dialog)
	{
		dialog.close();
	}else{
	    window.parent.close();
	}
}

function BrowseTable_onmouseover(e){
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
     //window.parent.returnValue = {id:jQuery(curTr.cells[0]).text(),name:jQuery(curTr.cells[1]).text(),a1:jQuery(curTr.cells[2]).text()};
     // window.parent.close();
      	if(dialog){
	    	dialog.callback({id:jQuery(curTr.cells[0]).text(),name:jQuery(curTr.cells[1]).text()});
		}else{ 
		    window.parent.returnValue  = {id:jQuery(curTr.cells[0]).text(),name:jQuery(curTr.cells[1]).text()};
		    window.parent.close();
		}
	}
}

function btnclear_onclick(){
	//window.parent.returnValue ={id:"",name:"",a1:""};
	//window.parent.close();
	if(dialog){
	    dialog.callback({id:"",name:"",type:"",a1:""});
	}else{ 
	    window.parent.returnValue  = {id:"",name:"",type:"",a1:""};
	    window.parent.close();
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

function submitData() {
	form1.submit();
}

</script>