<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.systemright.CheckSubCompanyRight" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>

<HTML><HEAD>
<%
String customname = Util.null2String(request.getParameter("customname"));
String modeid=Util.null2String(request.getParameter("modeid"));
String othercallback = Util.null2String(request.getParameter("othercallback"));

String appid=Util.null2String(request.getParameter("appid"));

String modename = "";
String sql = "";
if(!modeid.equals("")){
	sql = "select modename from modeinfo where id = " + modeid;
	rs.executeSql(sql);
	while(rs.next()){
		modename = Util.null2String(rs.getString("modename"));
	}
}

String userRightStr = "FORMMODEAPP:All";
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top} " ;//取消
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
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/formmode/search/CustomSearchBrowserInResourceIframe.jsp" method=post>
<input type="hidden" name="othercallback" id="othercallback" value="<%=othercallback %>">
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

<table width=100% class=e8_tblForm>
<TR>
	<TD width=15% class="e8_tblForm_label"><!-- 应用名称 -->
		<%=SystemEnv.getHtmlLabelName(25432,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>
	</TD>
	<TD class=e8_tblForm_field colspan="1">
	
	 <select id=appid name=appid style="width:100px">
	 	<option></option>
		<%
		String appSql = " select * from modeTreeField where (isdelete is null or isdelete=0 )";
		if(fmdetachable.equals("1")){
	          	CheckSubCompanyRight mSubRight = new CheckSubCompanyRight();
	  			int[] mSubCom = mSubRight.getSubComByUserRightId(user.getUID(),"FORMMODEAPP:ALL",0);
	  			String subCompanyIds = "";
	  			for(int i=0;i<mSubCom.length;i++){
	  				if(i==0){
	  					subCompanyIds += ""+mSubCom[i];
	  				}else{
	  					subCompanyIds += ","+mSubCom[i];
	  				}
	  			}
	  			if(subCompanyIds.equals("")){
	  				appSql+= " and 1=2 ";
	  			}else{
	  				appSql+= " and subCompanyId in ("+subCompanyIds+") ";
	  			}
	      }
		appSql += " order  by showOrder asc ";
		rs.executeSql(appSql);
		boolean isInSubCompany = false;
		while(rs.next()){
			int tempAppId = Util.getIntValue(rs.getString("id"),0);
			if(tempAppId==Util.getIntValue(appid)){
				isInSubCompany = true;
			}
		%>
		<option value="<%=rs.getString("id")%>" <%if(tempAppId==Util.getIntValue(appid)){out.print("selected");}%>><%=rs.getString("treeFieldName")%></option>
		<%}
			if(!isInSubCompany){
				appSql = "select  * from modeTreeField where id="+Util.getIntValue(appid);
				rs.executeSql(appSql);
				if(rs.next()){
			%>
				<option value="<%=rs.getString("id")%>"  selected="selected" <%=rs.getString("treeFieldName")%></option>
			<% } }
		%>
  	</select>
						
	</td>
</TR>
<TR>
	<TD width=15% class="e8_tblForm_label"><!-- 自定义查询名称 -->
		<%=SystemEnv.getHtmlLabelName(20773,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>
	</TD>
	<TD width=35% class=e8_tblForm_field>
		<input name=customname value="<%=customname%>" class="InputStyle">
	</TD>
	<TD width=15% class="e8_tblForm_label">
		<%=SystemEnv.getHtmlLabelName(28485,user.getLanguage())%><!-- 模块名称 -->
	</td>
	<TD width=35% class=e8_tblForm_field>
	
	<%
		String tempTitle = SystemEnv.getHtmlLabelNames("18214,19049",user.getLanguage());
	%>
	 <brow:browser viewType="0" id="modeid" name="modeid" browserValue='<%=modeid%>' 
  		 				browserUrl="/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp"
						hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="1"
						completeUrl="/data.jsp" linkUrl=""  width="228px"
						browserDialogWidth="510px" tempTitle="<%=tempTitle %>"
						browserSpanValue='<%=modename %>'
						></brow:browser>
						
	</td>
</TR>
</table>
<br/>

<TABLE ID=BrowseTable class="BroswerStyle" cellspacing="1" width="100%" >
	<colgroup>
		<col width="10%">
		<col width="30%">
		<col width="30%">
		<col width="30%">
	</colgroup>
	<tbody>
		<tr class=DataHeader>
			<TH><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH><!-- 标识 -->
			<TH><%=SystemEnv.getHtmlLabelName(19049,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH><!-- 模块名称 -->
			<TH><%=SystemEnv.getHtmlLabelName(20773,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH><!-- 自定义查询名称 -->
			<TH><%=SystemEnv.getHtmlLabelName(20773,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH><!-- 自定义查询描述 -->
		</tr>
		<TR class=Line style="height:1px;"><Td colspan="3" ></Td></TR>
	    <%
	    	//sql = "select a.id,a.modeid,(select modename from modeinfo where id=a.modeid ) as modename,a.customname,a.customdesc from mode_customsearch a where 1=1 ";
			String sqlWhere = "";
		    if(fmdetachable.equals("1")){
	          	CheckSubCompanyRight mSubRight = new CheckSubCompanyRight();
	          	int[] mSubCom = mSubRight.getSubComByUserRightId(user.getUID(),"FORMMODEAPP:ALL",0);
	  			String subCompanyIds = "";
	  			for(int i=0;i<mSubCom.length;i++){
	  				if(i==0){
	  					subCompanyIds += ""+mSubCom[i];
	  				}else{
	  					subCompanyIds += ","+mSubCom[i];
	  				}
	  			}
	  			if(subCompanyIds.equals("")){
	  				sqlWhere+= " and 1=2 ";
	  			}else{
	  				sqlWhere+= " and c.subCompanyId in ("+subCompanyIds+") ";
	  			}
	      }
	    
		    if(rs.getDBType().equalsIgnoreCase("oracle")){
	    		sql = "select a.id,a.modeid,(select modename from modeinfo where id=a.modeid ) as modename,a.customname,a.customdesc "+
	    			"from mode_customsearch a,modeinfo b,modeTreeField c where a.modeid=b.id "+(appid.equals("")?"":" and c.id="+appid)+" and b.modetype=c.id and nvl(c.isdelete,0)<>1"+sqlWhere;
	    	}else{
	    		sql = "select a.id,a.modeid,(select modename from modeinfo where id=a.modeid ) as modename,a.customname,a.customdesc "+
				"from mode_customsearch a,modeinfo b,modeTreeField c where a.modeid=b.id "+(appid.equals("")?"":" and c.id="+appid)+" and b.modetype=c.id and isnull(c.isdelete,0)<>1"+sqlWhere;
	    	}
	    	if(!customname.equals("")){
				sql = sql + " and a.customname like '%"+customname+"%'";
			}
			if(!modeid.equals("")&&!modeid.equals("0")){
				sql = sql + " and a.modeid = '"+modeid+"'";
			}
			
			rs.executeSql(sql);
		    int m = 0;
		    while(rs.next()){
		    	int tmpid = rs.getInt("id");
		    	String tempmodename = Util.null2String(rs.getString("modename"));
		    	String tempcustomname = Util.null2String(rs.getString("customname"));
		    	String tempcustomdesc = Util.null2String(rs.getString("customdesc"));
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
						<td><%=tempcustomname%></TD>
						<td><%=tempcustomdesc%></TD>
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

function otherCallBackFun(returnjson){
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
     	var returnjson = {id:jQuery(jQuery(target).parents("tr")[0].cells[0]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[2]).text()};
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
	SearchForm.formname.value='';
}
function onShowModeSelect(inputName, spanName){
	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp");
	if (datas){
	    if(datas.id!=""){
		    $(inputName).val(datas.id);
			if ($(inputName).val()==datas.id){
		    	$(spanName).html(datas.name);
			}
	    }else{
		    $(inputName).val("");
			$(spanName).html("");
		}
	} 
}

</script>
