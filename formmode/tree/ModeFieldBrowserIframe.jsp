<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.systemright.CheckSubCompanyRight" %>
<%@ page import="weaver.formmode.virtualform.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.form.FormManager"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<%
String fieldname = Util.null2String(request.getParameter("fieldname"));
int sourceid = Util.getIntValue(Util.null2String(request.getParameter("sourceid")),0);
int sourcefrom = Util.getIntValue(Util.null2String(request.getParameter("sourcefrom")),0);
int hrefid = Util.getIntValue(Util.null2String(request.getParameter("hrefid")),0);
int hreftype = Util.getIntValue(Util.null2String(request.getParameter("hreftype")),0);
int supnode = Util.getIntValue(Util.null2String(request.getParameter("supnode")),0);
String tablename = Util.null2String(request.getParameter("tablename"));
String fielddesc = Util.null2String(request.getParameter("fielddesc"));
//from 1当前节点模块字段，2链接目标关联字段,3上级关联字段,4链接目标地址字段,5节点图标字段
int from = Util.getIntValue(Util.null2String(request.getParameter("from")),0);
FormManager fManager = new FormManager();
int formid = 0;
String sql = "";
String temptablename = "";
boolean showsourcefield = false;
int isvirtualform = 0;
boolean isVirtualForm = false;
if(from==1||from==4||from==5){//当前节点模块字段
	if(sourcefrom==1){//模块
		sql = "select * from modeinfo where id = " + sourceid;
		rs.executeSql(sql);
		while(rs.next()){
			formid = rs.getInt("formid");
			RecordSet.executeSql("select isvirtualform from ModeFormExtend where formid="+formid);
			if(RecordSet.next()){
				isvirtualform = RecordSet.getInt("isvirtualform");
			}
			temptablename = fManager.getTablename(formid);
			if(VirtualFormHandler.isVirtualForm(formid)){
				isVirtualForm=true;
				temptablename = VirtualFormHandler.getRealFromName(temptablename);
			}
			//temptablename = "formtable_main_" + Math.abs(formid);
		}
	}
}else if(from==2){//链接目标关联字段
	if(hreftype==1){//模块
		sql = "select * from modeinfo where id = " + hrefid;
		rs.executeSql(sql);
		while(rs.next()){
			formid = rs.getInt("formid");
			RecordSet.executeSql("select isvirtualform from ModeFormExtend where formid="+formid);
			if(RecordSet.next()){
				isvirtualform = RecordSet.getInt("isvirtualform");
			}
			tablename = fManager.getTablename(formid);
			temptablename = fManager.getTablename(formid);
			if(VirtualFormHandler.isVirtualForm(formid)){
				isVirtualForm = true;
				tablename = VirtualFormHandler.getRealFromName(tablename);
				temptablename = VirtualFormHandler.getRealFromName(temptablename);
			}
			//tablename = "formtable_main_" + Math.abs(formid);
			//temptablename = "formtable_main_" + Math.abs(formid);
		}
	}else if(hreftype==3){//查询列表
		sql = "select b.formid from mode_customsearch a,modeinfo b where a.modeid = b.id and a.id = " + hrefid;
		rs.executeSql(sql);
		while(rs.next()){
			formid = rs.getInt("formid");
			RecordSet.executeSql("select isvirtualform from ModeFormExtend where formid="+formid);
			if(RecordSet.next()){
				isvirtualform = RecordSet.getInt("isvirtualform");
			}
			tablename = fManager.getTablename(formid);
			temptablename = fManager.getTablename(formid);
			if(VirtualFormHandler.isVirtualForm(formid)){
				isVirtualForm = true;
				tablename = VirtualFormHandler.getRealFromName(tablename);
				temptablename = VirtualFormHandler.getRealFromName(temptablename);
			}
			//tablename = "formtable_main_" + Math.abs(formid);
			//temptablename = "formtable_main_" + Math.abs(formid);
		}
	}
}else if(from==3){//上级字段
	//supnode
	sql = "select id,sourcefrom,sourceid,tablename from mode_customtreedetail where id = " + supnode;
	rs.executeSql(sql);
	//out.println(sql);
	while(rs.next()){
		sourceid = Util.getIntValue(Util.null2String(rs.getString("sourceid")),0);
		sourcefrom = Util.getIntValue(Util.null2String(rs.getString("sourcefrom")),0);
		tablename = Util.null2String(rs.getString("tablename"));
	}
	
	if(sourcefrom==1){//模块
		sql = "select * from modeinfo where id = " + sourceid;
		rs.executeSql(sql);
		while(rs.next()){
			formid = rs.getInt("formid");
			RecordSet.executeSql("select isvirtualform from ModeFormExtend where formid="+formid);
			if(RecordSet.next()){
				isvirtualform = RecordSet.getInt("isvirtualform");
			}
			temptablename = fManager.getTablename(formid);
			if(VirtualFormHandler.isVirtualForm(formid)){
				isVirtualForm = true;
				temptablename = VirtualFormHandler.getRealFromName(temptablename);
			}
			//temptablename = "formtable_main_" + Math.abs(formid);
		}
	}
}
if(temptablename.equalsIgnoreCase(tablename)&&!temptablename.equals("")){
	showsourcefield = true;
}
//out.println(temptablename+"	"+tablename);
//out.println("tablename:"+tablename+"	sourcefrom:"+sourcefrom+"	sourceid:"+sourceid+"	hreftype:"+hreftype+"	hrefid:"+hrefid);
//out.println(showsourcefield);
%>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:searchReset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onCancel(),_top} " ;
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
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/formmode/tree/ModeFieldBrowserIframe.jsp" method=post>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
</colgroup>
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
		
		<input type="hidden" id="sourceid" name="sourceid" value="<%=sourceid %>">
		<input type="hidden" id="sourcefrom" name="sourcefrom" value="<%=sourcefrom %>">
		<input type="hidden" id="hrefid" name="hrefid" value="<%=hrefid %>">
		<input type="hidden" id="hreftype" name="hreftype" value="<%=hreftype %>">
		<input type="hidden" id="supnode" name="supnode" value="<%=supnode %>">
		<input type="hidden" id="tablename" name="tablename" value="<%=tablename %>">
		<input type="hidden" id="from" name="from" value="<%=from %>">
		
<table width=100% class=viewform>
	<TR>
		<TD width=15%>
			<%=SystemEnv.getHtmlLabelName(31149,user.getLanguage())%><!-- 表字段名 -->
		</TD>
		<TD width=35% class=field>
			<input name="fieldname" id="fieldname" value="<%=fieldname%>" class="InputStyle">
		</TD>
		<TD width=15%>
			<%=SystemEnv.getHtmlLabelName(21934,user.getLanguage())%><!-- 字段描述 -->
		</TD>
		<TD width=35% class=field>
			<input name="fielddesc" id="fielddesc" value="<%=fielddesc%>" class="InputStyle">
		</TD>
	</TR>
	<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
	<TR class="Spacing" style="height:1px;">
		<TD class="Line1" colspan=4></TD>
	</TR>
</table>
		

<TABLE ID=BrowseTable class="BroswerStyle" cellspacing="1" width="100%" >
	<colgroup>
		<col width="0%">
		<col width="50%">
		<col width="50%">
	</colgroup>
	<tbody>
		<tr class=DataHeader>
			<TH style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH><!-- 标识 -->
			<TH><%=SystemEnv.getHtmlLabelName(31149,user.getLanguage())%></TH><!-- 表字段名 -->
			<TH><%=SystemEnv.getHtmlLabelName(21934,user.getLanguage())%></TH><!-- 字段描述 -->
		</tr>
		<TR class=Line style="height:1px;"><Td colspan="3" ></Td></TR>
		<%
			if(!isVirtualForm&&showsourcefield&&from!=4&&from!=5){
				if(!fieldname.equals("")||!fielddesc.equals("")){
					if("ID".indexOf(fieldname.toUpperCase())>-1){
						if(!fielddesc.equals("")&&"ID".indexOf(fielddesc.toUpperCase())<0){
							
						}else{
		%>
						<TR class=DataDark>
							<TD style="display:none"><A HREF="#">ID</A></TD>
							<td>ID</TD>
							<td>ID</TD>
						</TR>
		<%						
						}
					}
				}else{
					if(isvirtualform==0){
		%>
					<TR class=DataDark>
						<TD style="display:none"><A HREF="#">ID</A></TD>
						<td>ID</TD>
						<td>ID</TD>
					</TR>
		<%					
				}
					}
			}
		%>
	    <%
	    	String sqlwhere = "";
	    	if(showsourcefield){
		    	if(!fieldname.equals("")){
		    		sqlwhere = " and upper(a.fieldname) like upper('%"+fieldname+"%')";
		    	}
		    	if(from==4){//4链接目标地址字段
		    		sqlwhere += " and ((a.fieldhtmltype = 1 and a.type = 1) or (a.fieldhtmltype = 2 and a.type = 1))";
		    	}else if(from==5){//5节点图标字段
		    		sqlwhere += " and ((a.fieldhtmltype = 1 and a.type = 1) or (a.fieldhtmltype = 2 and a.type = 1) or (a.fieldhtmltype = 6 and a.type = 2))";
		    	}
	    		sql = "select upper(a.fieldname) fieldname,b.indexdesc from workflow_billfield a,HtmlLabelIndex b where a.fieldlabel = b.id and billid = " + formid + " and viewtype = 0 "+sqlwhere+" order by upper(a.fieldname) asc";
	    	}else{
	    		if(rs.getDBType().equals("oracle")){
			    	if(!fieldname.equals("")){
			    		sqlwhere = " and upper(COLUMN_NAME) like upper('%"+fieldname+"%')";
			    	}
	    			sql = "select upper(COLUMN_NAME) fieldname,upper(COLUMN_NAME) indexdesc from user_tab_columns where upper(table_name)=upper('" + tablename + "') "+sqlwhere+" ORDER BY upper(COLUMN_NAME) asc";	    			
	    		}else{
			    	if(!fieldname.equals("")){
			    		sqlwhere = " and upper(c.name) like upper('%"+fieldname+"%')";
			    	}
	    			sql = "select upper(c.name) fieldname,upper(c.name) indexdesc from sysobjects o,syscolumns c where o.id=c.id and upper(o.name)=upper('" + tablename + "') "+sqlwhere+" order by upper(c.name) asc";
	    		}
	    	}
	    	//out.println(sql);

			rs.executeSql(sql);
		    int m = 0;
		    while(rs.next()){
		    	String tempfieldname = Util.null2String(rs.getString("fieldname"));
		    	String tempindexdesc = Util.null2String(rs.getString("indexdesc"));
		    	if(tempindexdesc.equals("")){
		    		tempindexdesc = tempfieldname;
		    	}
		    	if(!fielddesc.equals("")){
		    		if(tempindexdesc.toUpperCase().indexOf(fielddesc.toUpperCase())<0){
		    			continue;
		    		}
		    	}
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
						<TD style="display:none"><A HREF="#"><%=tempfieldname%></A></TD>
						<td><%=tempfieldname%></TD>
						<td><%=tempindexdesc%></TD>
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

function btnclear_onclick(){
	var returnjson = {id:"",name:""};
	if(dialog){
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
	jQuery("#fieldname").val("");
	jQuery("#fielddesc").val("");
}
</script>


