<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.RecordSetDataSource" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.workflow.dmlaction.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldBase" class="weaver.workflow.dmlaction.commands.bases.FieldBase" scope="page" />
<HTML><HEAD>
<link href="/css/Weaver_wev8.css" rel="stylesheet" type="text/css" >
<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
<LINK REL=stylesheet type=text/css HREF="/css/Weaver_wev8.css"></HEAD>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<%
String datasourceid = Util.null2String(request.getParameter("datasourceid"));
boolean needcheckds = Util.null2String(request.getParameter("needcheckds")).equals("true");
int dmlformid = Util.getIntValue(Util.null2String(request.getParameter("dmlformid")),0);
int dmlisdetail = Util.getIntValue(Util.null2String(request.getParameter("dmlisdetail")),0);
String dmltablename = Util.null2String(request.getParameter("dmltablename"));
int ajax = Util.getIntValue(Util.null2String(request.getParameter("ajax")), 0);
String fielddes = Util.null2String(request.getParameter("fielddes"));
StringBuffer sql = new StringBuffer();
int shownameid=0;
if("hrmresource".equals(dmltablename)){
	sql.append("select fielddesc,fieldname,fielddbtype from Sys_fielddict where  tabledictid = 1 ");
	sql.append(" union ");
	sql.append(" select t2.hrm_fieldlable as fielddesc,t1.fieldname as fieldname,t1.fielddbtype from cus_formdict t1,cus_formfield t2 where t1.id = t2.fieldid and t2.scope = 'HrmCustomFieldByInfoType' ");
	sql.append(" union ");
	sql.append("  select '登陆账号' as fielddesc,'loginid' as fieldname,'varchar(60)' as fielddbtype ");
	if("oracle".equals(RecordSet.getDBType())){
		sql.append(" from dual ");
	}
	if(!"".equals(fielddes)){
		RecordSet.execute("select  * from ("+sql.toString()+") as a where a.fielddesc like '%"+fielddes+"%'");
	}else{
		RecordSet.execute(sql.toString());
	}
	shownameid = 15549;
}
%>
<BODY>
<div class="zDialog_div_content">
    <DIV align=right>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/integration/dmlTableFieldsBrowser.jsp" method=post>
<input type="hidden" id="datasourceid" name="datasourceid" value="<%=datasourceid%>">
<input type="hidden" id="dmltablename" name="dmltablename" value="<%=dmltablename%>">
<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
	<wea:group context="<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>">
		<wea:item><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></wea:item>
		<wea:item><input name=fielddes class="InputStyle" value="<%=fielddes%>"></wea:item>
	</wea:group>
	<wea:group context="<%=SystemEnv.getHtmlLabelName(82104,user.getLanguage())%>">
		<wea:item attributes="{'isTableList':'true'}">
			<TABLE ID=BrowseTable class="ListStyle" cellspacing="0" style="width: 100%">
			<TR class=header>
			<TH width=40%><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></TH>
			<TH width=30%><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></TH>
			<TH width=30%><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></TH>
			</TR>
			<%
			while(RecordSet.next()){
					boolean isright = true;
					String fielddesc = Util.null2String(RecordSet.getString("fielddesc"));
					String fieldname = Util.null2String(RecordSet.getString("fieldname"));
					String fielddbtype =Util.null2String(RecordSet.getString("fielddbtype"));
					
					fieldname = (fieldname.indexOf(" ")>0)?"["+fieldname+"]":fieldname;

			%>
				<tr height="20px" class=<%if(isright){ %>DataLight<%}else{%>DataDark<%} %>>
					<td><%=fielddesc %></td>
					<td><%=fieldname %></td>
					<td><%=fielddbtype %></td>
				</tr>
			<%
					isright = isright?false:true;
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
			    	<input type="button" class=zd_btn_cancle accessKey=2  id=btnclear value="2-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" onclick='onClear();'></input>
	        		<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" onclick='closeDialog();'></input>
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

<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelName(shownameid,user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e);
	}
</script>
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
function onSubmit()
{
	SearchForm.submit();
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
	    	dialog.callback({id:jQuery(curTr.cells[1]).text(),name:jQuery(curTr.cells[0]).text(),type:jQuery(curTr.cells[0]).text(),a1:jQuery(curTr.cells[2]).text()});
		}else{ 
		    window.parent.returnValue  = {id:jQuery(curTr.cells[0]).text(),name:jQuery(curTr.cells[0]).text(),type:jQuery(curTr.cells[1]).text(),a1:jQuery(curTr.cells[2]).text()};
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
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle();
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#advancedSearch").bind("click", function(){
	});
});
jQuery(function(){
	jQuery("#BrowseTable").mouseover(BrowseTable_onmouseover);
	jQuery("#BrowseTable").mouseout(BrowseTable_onmouseout);
	jQuery("#BrowseTable").click(BrowseTable_onclick);
	
	//$("#btncancel").click(btncancel_onclick);
	//$("#btnsub").click(btnsub_onclick);
	
	jQuery("#btnclear").click(btnclear_onclick);
	
});

</script>