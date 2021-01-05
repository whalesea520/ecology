<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.systemright.CheckSubCompanyRight" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.formmode.service.FormInfoService"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />

<HTML><HEAD>
<%
int formId = Util.getIntValue(request.getParameter("formId"), 0);
String fieldSearch = Util.null2String(request.getParameter("fieldSearch"));
FormInfoService formInfoService = new FormInfoService();
List<Map<String, Object>> fieldList = formInfoService.getTargetFormField(formId, "");
%>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onOk(),_top} " ;//确定
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;//清除
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_top} " ;//搜索
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onCancel(),_top} " ;//取消
RCMenuHeight += RCMenuHeightStep ;

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM NAME=SearchForm action="FormFieldBrowser.jsp" method=post>
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
				<table width=100% class=viewform>
					<TR>
						<TD width=20%>
						 <%=SystemEnv.getHtmlLabelName(685,user.getLanguage()) %><!-- 字段名称 -->
						</TD>
						<TD width=80% class=field><input name="fieldSearch" value="<%=fieldSearch %>" class="InputStyle"></TD>
					</TR>
					<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR> 
					<TR class="Spacing" style="height:1px;">
						<TD class="Line1" colspan=4></TD>
					</TR>
				</table>

				<TABLE ID=BrowseTable class="BroswerStyle" cellspacing="1" width="100%">
					<colgroup>
						<col width="10%"/>
						<col width="45%"/>
						<col width="45%"/>
					</colgroup>
					<TR class=DataHeader>
						<TH colspan="3"><%=SystemEnv.getHtmlLabelName(21740,user.getLanguage()) %></TH><!-- 表单字段 -->
					</tr>
					<TR class=Line style="height:1px;"><Th colspan="3" ></Th></TR>
					<% for(int i = 0; i < fieldList.size(); i++){ 
						Map<String, Object> fieldMap = fieldList.get(i);
						String labelName = Util.null2String(fieldMap.get("labelName"));
						String fieldname = Util.null2String(fieldMap.get("fieldname"));
						if(!fieldSearch.equals("")){
							if(labelName.indexOf(fieldSearch) == -1 && fieldname.indexOf(fieldSearch) == -1){
								continue;
							}
						}
					%>
						<tr <%if((i+1)%2==0){%>class="DataDark"<%}else{%>class="DataLight"<%}%>>
					    	<td><input type="checkbox" name="fieldname" value="<%=fieldname %>" fieldlabel="<%=labelName %>"/></td>
					    	<td><%=labelName %></td>
					    	<td><%=fieldname %></td>
					    </tr>
					<%}%> 
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
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);

function onCancel(){
	if(dialog){
	    dialog.close();
	}else{  
	    window.parent.close();
	}
}

function onOk(){
	var idVar = "";
	var nameVar = "";
	jQuery("input[type='checkbox'][name='fieldname']:checked").each(function(){
		idVar += $(this).val() + ",";
		nameVar += $(this).attr("fieldlabel") + ",";
	});
	if(idVar != ""){
		idVar = idVar.substring(0, idVar.length - 1);
	}
	if(nameVar != ""){
		nameVar = nameVar.substring(0, nameVar.length - 1);
	}
	var returnjson = {id:idVar,name:nameVar};
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
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

function submitData(){
	SearchForm.submit();
}

function submitClear()
{
	btnclear_onclick();
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
		var $jNiceCheckbox = jQuery(jQuery(target).parents("tr")[0].cells[0]).find(".jNiceCheckbox");
		$jNiceCheckbox.click();
	}
}
</script>


