<%@page import="weaver.formmode.setup.ModeSetUtil"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.systemright.CheckSubCompanyRight" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<%
String modeid = Util.null2String(request.getParameter("modeid"));
String name = Util.null2String(request.getParameter("name"));
String othercallback = Util.null2String(request.getParameter("othercallback"));
ModeSetUtil modeSetUtil = new ModeSetUtil();
modeSetUtil.setModeId(Util.getIntValue(modeid));
modeSetUtil.loadMode();
String formid = modeSetUtil.getFormId()+"";
%>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
</HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_top} " ;//搜索
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:searchReset(),_top} " ;//重新设置
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;//清除
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onCancel(),_top} " ;//取消
RCMenuHeight += RCMenuHeightStep ;

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div style="height: 60px;" >
	<div style="height: 45px; width: 43px; float: left; margin: 6px; visibility: visible; background-image: url('/js/tabs/images/nav/mnav0_wev8.png');" />
</div>
<div style="margin-left: 45px;margin-top: 18px;"> 
	<span style="font-size: 16px; font-family: Microsoft YaHei"><%=SystemEnv.getHtmlLabelName(126554, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(30177,user.getLanguage())%></span>
</div>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/formmode/setup/batchmodifyBrowser.jsp" method=post>
<input type="hidden" id="formid" name="formid" value="<%=formid%>" />
<input type="hidden" id="modeid" name="modeid" value="<%=modeid%>" />
<input type="hidden" id="othercallback" name="othercallback" value="<%=othercallback %>" />
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
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
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<table class="e8_tblForm" style="margin-bottom: 10px;">
<tr>
	<td colspan="3">
		<hr style=" height:1px;border:none;border-top:1px solid #EAEAEA;" />
	</td>
</tr>
<TR>
	<td class="e8_tblForm_label" width="20%">
		<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%><!-- 名称 -->
	</TD>
	<td class="e8_tblForm_field">
		<input name="name" value="<%=name%>" class="InputStyle">
	</TD>
</TR>
</table>

<TABLE ID=BrowseTable class="BroswerStyle" cellspacing="1" width="100%" >
	<colgroup>
		<col width="10%">
		<col width="45%">
		<col width="50%">
	</colgroup>
	<tbody>
		<tr class=DataHeader>
			<TH><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH><!-- 标识 -->
			<TH><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH><!-- 名称 -->
			<TH><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH><!-- 描述 -->
		</tr>
		<TR class=Line style="height:1px;"><Td colspan="3" ></Td></TR>
	    <%
	    	String sql = "select id,name,remark from mode_batchmodify where modeid="+modeid+" and formid="+formid;
			if(!name.equals("")){
				sql = sql + " and name like '%"+name+"%'";
			}
			sql+=" order by id asc";
			rs.executeSql(sql);
		    int m = 0;
		    while(rs.next()){
		    	int tmpid = rs.getInt("id");
		    	String tempname = Util.null2String(rs.getString("name"));
		    	String remark = Util.null2String(rs.getString("remark"));
				m++;
				if(m%2==0) {
		%>
					<TR class=DataLight>
		<%
				}else{
		%>
					<TR class=DataDark>
		<%
				}
		%>
						<TD><A HREF="#"><%=tmpid%></A></TD>
						<td><%=tempname%></TD>
						<td style="word-break:break-all;"><%=remark%></TD>
					</TR>
		<%
			}
		%>
	</tbody>
</TABLE>

</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
</FORM>
<div class="zDialog_div_bottom" id="zDialog_div_bottom">
	<table class="LayoutTable" style="width: 100%;">
		<colgroup>
			<col width="20%">
			<col width="80%">
		</colgroup>
		<tbody>
			<tr class="intervalTR">
				<td class="interval" style="text-align: center;" colspan="2">
					<input class="zd_btn_cancle" id="zd_btn_cancle" onclick="onCancel();" type="button" 
						value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
					/>
				</td>
			</tr>
		</tbody>
	</table>
</div>
</BODY></HTML>

<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);

function onCancel(){
	if(dialog){
	    dialog.close();
	}else{  
	    window.parent.close();
	}
}

function otherCallBackFun(returnjson){
	<%if(othercallback.equals("getSourceTableName")){%>
		if(parentWin.getSourceTableName){
	    	parentWin.getSourceTableName(returnjson);
	    }
	<%}%>
	<%if(othercallback.equals("getHrefTarget")){%>
		if(parentWin.getHrefTarget){
	    	parentWin.getHrefTarget(returnjson);
	    }
	<%}%>
}

function btnclear_onclick(){
	var returnjson = {id:"",name:""};
	if(dialog){
		otherCallBackFun(returnjson);
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
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
jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
	jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
})
function BrowseTable_onclick(e){
	var e=e||event;
	var target=e.srcElement||e.target;

	if( target.nodeName =="TD"||target.nodeName =="A"  ){
		var strname = jQuery(jQuery(target).parents("tr")[0].cells[1]).text();
		strname="<a href=\""+"javascript:modifyfeild("+jQuery(jQuery(target).parents("tr")[0].cells[0]).text()+")\">"+jQuery(jQuery(target).parents("tr")[0].cells[1]).text()+"</a>";
		var returnjson = {id:jQuery(jQuery(target).parents("tr")[0].cells[0]).text(),name:strname};
	 	if(dialog){
		    otherCallBackFun(returnjson);
		    dialog.callback(returnjson);
		}else{  
		    window.parent.returnValue  = returnjson;
		    window.parent.close();
		}
	}
}


function submitData()
{
	if (check_form(SearchForm,''))
		SearchForm.submit();
}

function submitClear()
{
	btnclear_onclick();
}

function nextPage(){
	document.all("pagenum").value=parseInt(document.all("pagenum").value)+1 ;
	SearchForm.submit();	
}

function perPage(){
	document.all("pagenum").value=document.all("pagenum").value-1 ;
	SearchForm.submit();
}

function searchReset() {
	SearchForm.name.value='';
}
</script>


