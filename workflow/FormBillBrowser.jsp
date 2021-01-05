<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<HTML>
    <HEAD>
    <%
    	String isBill = Util.null2String(request.getParameter("isBill"));
    	String name = Util.null2String(request.getParameter("formName"));
		String isfrom = Util.null2String(request.getParameter("from"));
    %>
        <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	    <script type="text/javascript">
			var parentWin = null;
			var dialog = null;
			try{
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
			}catch(e){}
		</script>
    </HEAD>
    <BODY >
	<div class="zDialog_div_content">
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	
		RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:onReset(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		
		RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top}";
		RCMenuHeight += RCMenuHeightStep ;
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(15451,user.getLanguage()) %>"/>
</jsp:include>
	<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(197 ,user.getLanguage()) %>" class="e8_btn_top" onclick="document.SearchForm.submit()"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(199 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onReset()"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(311 ,user.getLanguage()) %>" class="e8_btn_top" onclick="submitClear()"/>
					<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
					<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<div id="tabDiv" >
		   <span style="font-size:14px;font-weight:bold;"></span> 
		</div>
		<div class="cornerMenuDiv"></div>
		<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
		</div>
<FORM NAME=SearchForm action="FormBillBrowser.jsp" method=post>
<input name="from" value="<%=isfrom %>" type="hidden" id="from"/>			
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none','groupSHBtnDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(18411,user.getLanguage())%></wea:item>
		<wea:item>
			<SELECT name="isBill">
				<OPTION value="" <% if("".equals(isBill)) { %> selected <% } %> ></OPTION>
		    	<OPTION value="0" <% if("0".equals(isBill)) { %> selected <% } %> ><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></OPTION>
		    	<OPTION value="1" <% if("1".equals(isBill)) { %> selected <% } %> ><%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></OPTION>
			</SELECT>		
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name=formName value='<%= name %>'></wea:item>
		</wea:group>
	</wea:layout>
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelNames("563,320",user.getLanguage()) %>' attributes="{'samePair':'SearchInfo','groupOperDisplay':'none'}">
		<wea:item attributes="{'samePair':'tablelistdatas','isTableList':'true','colspan':'full'}">
			<TABLE ID=BrowseTable class=ListStyle cellspacing=0 style="width:100%;" >
				<TR class=header>
					<TH width=40%><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></TH>
					<TH width=60%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH>
				</TR>
	    <!--================== 表单 ================== -->
		<%						
			boolean flag = true;
									
			String subCompanyString = "";
			
			
			int detachable = 0;
			boolean isUseWfManageDetach = manageDetachComInfo.isUseWfManageDetach();
			if(isUseWfManageDetach){
				detachable = 1;
			}
	    	if(1 == detachable)
	    	{
	    	    int subCompany[] = checkSubCompanyRight.getSubComByUserRightId(user.getUID(), "WorkflowManage:All");
	    	    
				for(int i = 0; i < subCompany.length; i++)
				{
				    subCompanyString += subCompany[i] + ",";
				}
				if(!"".equals(subCompanyString) && null != subCompanyString)
				{
				    subCompanyString = subCompanyString.substring(0, subCompanyString.length() - 1);
				}
	    	}
	    	
			
			String SQL = "SELECT * FROM WorkFlow_FormBase WHERE 1=1 ";
			//SQL += " and id!=6"	;
			if(!"".equals(name))
			{
			    SQL += " AND formName like '%" + name + "%' ";
			}
			if(!"".equals(subCompanyString) && null != subCompanyString)
			{
				SQL += "AND "+Util.getSubINClause(subCompanyString,"subCompanyID","IN",999);
			}
	
			if(!"1".equals(isBill))
			{
			
				RecordSet.execute(SQL);
				while(!"prjwf".equalsIgnoreCase(isfrom) && RecordSet.next())
				{	
				    String formName = RecordSet.getString("formName");
				    
				    String formDesc = RecordSet.getString("formDesc");
		%>
				<TR class=<% if (flag) { %> DataLight <% } else { %> DataDark <% } %> >
					<TD style="display:none"><A HREF=#>0</A></TD>
					<TD style="display:none"><A HREF=#><%= RecordSet.getInt("ID") %></A></TD>
					<TD><%= formName %></TD>
					<TD><%= formDesc %></TD>
				</TR>
		<%
					flag = !flag;
				}
				
				SQL = "SELECT * FROM WorkFlow_Bill";
				if(!"".equals(name)){
			    SQL += ", HtmlLabelInfo where WorkFlow_Bill.nameLabel = HtmlLabelInfo.indexID AND HtmlLabelInfo.labelName like '%" + name + "%' AND languageID = " + user.getLanguage();
					if(!"".equals(subCompanyString) && null != subCompanyString)
					{
					    SQL += "AND "+Util.getSubINClause(subCompanyString,"subCompanyID","IN",999);
					}
				}else{
					if(!"".equals(subCompanyString) && null != subCompanyString)
					{
					    SQL += " where "+Util.getSubINClause(subCompanyString,"subCompanyID","IN",999);
					}
				}
				
				if(isfrom.equals("report")){
					if(SQL.indexOf("where")!=-1){
						SQL += " and id!=6" ;
					}else{
						SQL += " where id!=6" ;
					}
				}else if("prjwf".equalsIgnoreCase(isfrom)){
					String prjwhere=Util.null2String( request.getParameter("sqlwhere"));
					if(!"".equals(prjwhere)){
						if(SQL.indexOf("where")!=-1){
							SQL += " and "+prjwhere ;
						}else{
							SQL += " where "+prjwhere ;
						}
					}
				}
				RecordSet.execute(SQL);
				while(RecordSet.next())
				{	
				    String tablename = RecordSet.getString("tablename");
				    int billid = RecordSet.getInt("ID");
				    //if(!tablename.equals("formtable_main_"+billid*(-1)) || tablename.startsWith("uf_")) continue;
				    //以billid区分系统表单、自定义表单
				    if(billid > 0 || tablename.startsWith("uf_")) continue;
				    String billName = SystemEnv.getHtmlLabelName(RecordSet.getInt("nameLabel"), user.getLanguage());
		%>
				<TR class=<% if (flag) { %> DataLight <% } else { %> DataDark <% } %> >
					<TD style="display:none"><A HREF=#>1</A></TD>
					<TD style="display:none"><A HREF=#><%=billid%></A></TD>
					<TD><%=billName%></TD>
					<TD><%=RecordSet.getString("formdes")%></TD>
				</TR>
		<%
					flag = !flag;
				}
			}
		%>
		
		<!--================== 单据 ================== -->
		<%
			SQL = "SELECT * FROM WorkFlow_Bill";
		
			if(!"".equals(name))
			{
			    SQL += ", HtmlLabelInfo WHERE WorkFlow_Bill.nameLabel = HtmlLabelInfo.indexID AND HtmlLabelInfo.labelName like '%" + name + "%' AND languageID = " + user.getLanguage();
			}
			
			if(!"prjwf".equalsIgnoreCase(isfrom) && !"0".equals(isBill))
			{

				if(isfrom.equals("report")){
					if(SQL.indexOf("WHERE")!=-1){
						SQL += " and id!=6" ;
					}else{
						SQL += " where id!=6" ;
					}
				}
				RecordSet.execute(SQL);
				while(RecordSet.next())
				{
						String tablename = RecordSet.getString("tablename");
				    int billid = RecordSet.getInt("ID");
					if(tablename.equals("bill_HrmTime")||tablename.equals("Bill_HrmOvertimeSapa")||tablename.equals("Bill_HrmScheduleOvertime")) continue;
				    //if(tablename.equals("formtable_main_"+billid*(-1)) || tablename.startsWith("uf_")) continue;
				    //以billid区分系统表单、自定义表单
				    if(billid < 0 || tablename.startsWith("uf_")) continue;
				    String billName = SystemEnv.getHtmlLabelName(RecordSet.getInt("nameLabel"), user.getLanguage());
		%>
				<TR class=<% if (flag) { %> DataLight <% } else { %> DataDark <% } %> >
					<TD style="display:none"><A HREF=#>1</A></TD>
					<TD style="display:none"><A HREF=#><%= RecordSet.getInt("ID") %></A></TD>
					<TD><%= billName %></TD>
					<TD></TD>
				</TR>
		<%
					flag = !flag;
				}
			}
		%>
			</TABLE>		
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=T  id=btncancel value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
	</BODY>
</HTML>


<script type="text/javascript">
$(function(){
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelName(699, user.getLanguage())%>");
	}catch(e){}
});
function btnclear_onclick(){
	var returnjson = {isBill:"",id:"",name:""};
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}
}

jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
})
function BrowseTable_onclick(e){
   var e=e||event;
   var target=e.srcElement||e.target;

   if( target.nodeName =="TD"||target.nodeName =="A"  ){
   	 	var returnjson = {id:jQuery(jQuery(target).parents("tr")[0].cells[1]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[2]).text(),isBill:jQuery(jQuery(target).parents("tr")[0].cells[0]).text()};
		if(dialog){
		    dialog.callback(returnjson);
		}else{  
		    window.parent.returnValue  = returnjson;
		    window.parent.close();
		}
	}
}

function submitClear()
{
	btnclear_onclick();
}
function onClose()
{
	if(dialog){
	    dialog.close();
	}else{  
		window.parent.close() ;
	}	
}
function onview(objval1,objval2){
	SearchForm.listname.value=SearchForm.listname.value + objval2 + "->";
	SearchForm.parentid.value=objval1;
	SearchForm.submit();
}

function setSelectBoxValue(selector, value) {
	if (value == null) {
		value = jQuery(selector + ' option').first().val();
	}
	jQuery(selector).selectbox('change',value,jQuery(selector + ' option[value="'+value+'"]').text());
}

function onReset() {
	setSelectBoxValue('select[name="isBill"]', '<%=isBill%>');
	jQuery('input[name="formName"]').val('<%=name%>');
}
</SCRIPT>
