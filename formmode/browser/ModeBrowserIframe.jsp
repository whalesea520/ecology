<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.systemright.CheckSubCompanyRight" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<%
String modename = Util.null2String(request.getParameter("modename"));
String formid = Util.null2String(request.getParameter("formid"));
String othercallback = Util.null2String(request.getParameter("othercallback"));

String userRightStr = "ModeSetting:All";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable ,-1,"",request,response,session);
int subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
String subCompanyId2 = ""+subCompanyId;
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
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" onclick="submitData()" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input><!-- 搜索 -->
			<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span><!-- 确定 -->
		</td>
	</tr>
</table>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/formmode/browser/ModeBrowserIframe.jsp" method=post>
<input type="hidden" id="formid" name="formid" value="<%=formid%>" />
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
<TR>
	<td class="e8_tblForm_label" width="20%">
		<%=SystemEnv.getHtmlLabelName(19049,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%><!-- 模块名称 -->
	</TD>
	<td class="e8_tblForm_field">
		<input name=modename value="<%=modename%>" class="InputStyle">
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
			<TH><%=SystemEnv.getHtmlLabelName(19049,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH><!-- 模块名称 -->
			<TH><%=SystemEnv.getHtmlLabelName(19049,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH><!-- 模块描述 -->
		</tr>
		<TR class=Line style="height:1px;"><Td colspan="3" ></Td></TR>
	    <%
	    	String sql = "select id,modename,modedesc,modetype from modeinfo mi where exists (select 1 from modeTreeField mtf where mtf.id=mi.modetype and (isdelete is null or isdelete=0))";
			if(!modename.equals("")){
				sql = sql + " and modename like '%"+modename+"%'";
			}
			if(!"".equals(formid)){
				sql = sql + " and formid="+formid;
			}
			if(fmdetachable.equals("1")){
              	CheckSubCompanyRight mSubRight = new CheckSubCompanyRight();
	  			int[] mSubCom = mSubRight.getSubComByUserRightId(user.getUID(),"ModeSetting:All",0);
	  			String subCompanyIds = "";
	  			for(int i=0;i<mSubCom.length;i++){
	  				if(i==0){
	  					subCompanyIds += ""+mSubCom[i];
	  				}else{
	  					subCompanyIds += ","+mSubCom[i];
	  				}
	  			}
	  			if(subCompanyIds.equals("")){
	  				sql+= " and 1=2 ";
	  			}else{
	  				sql+= " and subCompanyId in ("+subCompanyIds+") ";
	  			}
          }
			sql+=" order by id asc";
	    
			rs.executeSql(sql);
		    int m = 0;
		    while(rs.next()){
		    	int tmpid = rs.getInt("id");
		    	String tempmodename = Util.null2String(rs.getString("modename"));
		    	String tempmodedesc = Util.null2String(rs.getString("modedesc"));
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
						<td><%=tempmodename%></TD>
						<td style="word-break:break-all;"><%=tempmodedesc%></TD>
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
</BODY></HTML>

<script type="text/javascript">
var parentWin = parent.parent.parent.getParentWindow(parent.parent);
var dialog = parent.parent.parent.getDialog(parent.parent);

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
		var returnjson = {id:jQuery(jQuery(target).parents("tr")[0].cells[0]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[1]).text()};
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
	SearchForm.modename.value='';
}
</script>


