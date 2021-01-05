
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
	//pagetype 为1：出口条件； 2：批次条件; 4:督办条件; 3:规则设计
	String pagetype = Util.null2String(request.getParameter("pagetype"));
	if(pagetype.equals("")) pagetype = "1";
	//pagetype = "2";
	//出口条件传过来的参数   start
	String formid = Util.null2String(request.getParameter("formid"));
	
	String isbill = Util.null2String(request.getParameter("isbill"));
	//System.out.println(formid+"+++"+isbill);
	String linkid = Util.null2String(request.getParameter("linkid"));
	
	String src = Util.null2String(request.getParameter("method"));
	String fshowname = Util.null2String(request.getParameter("fshowname"));
	String ftype = Util.null2String(request.getParameter("ftype"));
	if(ftype.equals(""))ftype="2";
	
	//出口条件传过来的参数   end
%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
</HEAD>

<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow" />
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(33331,user.getLanguage())+SystemEnv.getHtmlLabelName(320,user.getLanguage()) %>" />
</jsp:include>
<div class="zDialog_div_content">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/workflow/ruleDesign/showFieldBrowser.jsp" method=post>
<input type="hidden" name="method" value="search" >
<input type="hidden" name="pagetype" value="<%=pagetype %>" >
<input type="hidden" name="formid" value="<%=formid %>" >
<input type="hidden" name="isbill" value="<%=isbill %>" >
<input type="hidden" name="linkid" value="<%=linkid %>" >
<table id="topTitle" cellpadding="0" cellspacing="0" >
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage()) %>" class="e8_btn_top"  onclick="onSearch();"/>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 
<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage()) %>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage()) %></wea:item>
		<wea:item><input name="fshowname" type="text" style="width:130px"/></wea:item>
		<%if(pagetype.equals("2") || pagetype.equals("4")|| pagetype.equals("5")||pagetype.equals("6")){ %>
		<wea:item><%=SystemEnv.getHtmlLabelName(686,user.getLanguage()) %></wea:item>
		<wea:item>
			<select name="ftype" style="width:100px" onchange="onSearch();">
				<option value="1" <%=ftype.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(28415,user.getLanguage()) %></option>
				<option value="2" <%=ftype.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21740,user.getLanguage()) %></option>
			</select>
		</wea:item>
		<%}else{ %>
		<wea:item></wea:item>
		<%} %>
	</wea:group>
</wea:layout>
</FORM>
<%if(ftype.equals("2")){ %>
<div id="fieldTableDiv">
	<%
	String tableString = "";
	String backfields = "";
	String fromSql="";
	String sqlWhere = "";
	String orderkey = "";
	String pageIdStr = "16";
	if(isbill.equals("0")){
		backfields = " workflow_formfield.fieldid as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formdict.fieldhtmltype as htmltype,workflow_formdict.type as type,workflow_formdict.fielddbtype as dbtype,workflow_formfield.isdetail as isdetail,workflow_formfield.groupid,workflow_formfield.fieldorder ";
		fromSql = " from workflow_formfield,workflow_formdict,workflow_fieldlable ";
		sqlWhere = " where workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.isdefault = '1' and workflow_formdict.fieldhtmltype!=6 and not(workflow_formdict.fieldhtmltype=2 and workflow_formdict.type=2) and workflow_formdict.fieldhtmltype<>7 and workflow_fieldlable.fieldid =workflow_formfield.fieldid and workflow_formdict.id = workflow_formfield.fieldid and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid+" ";
		if(src.equals("search") && !fshowname.equals(""))
			sqlWhere += " and workflow_fieldlable.fieldlable like '%"+fshowname+"%'";
		orderkey = " workflow_formfield.isdetail,workflow_formfield.groupid,workflow_formfield.fieldorder ";
	}else if(isbill.equals("1")){
		backfields = " t1.id as id,t1.fieldname as name,t1.fieldlabel as label,t1.fieldhtmltype as htmltype,t1.type as type, t1.fielddbtype as dbtype,t1.viewtype as isdetail,t1.detailtable,t1.dsporder ";
		if(src.equals("search") && !fshowname.equals("")){
			fromSql = " from workflow_billfield t1,HtmlLabelInfo t2";
			sqlWhere = " where (t1.viewtype is null or t1.viewtype!=1) and t1.billid = "+formid + " and t1.fieldhtmltype!=6 and not(t1.fieldhtmltype=2 and t1.type=2) and t1.fieldhtmltype<>7 ";
			sqlWhere += " and t2.indexid=t1.fieldlabel and t2.languageid="+user.getLanguage()+" and t2.labelname like '%"+fshowname+"%'";
		}else{
			fromSql = " from workflow_billfield t1 ";
			sqlWhere = " where (t1.viewtype is null or t1.viewtype!=1) and t1.billid = "+formid + " and t1.fieldhtmltype!=6 and not(t1.fieldhtmltype=2 and t1.type=2) and t1.fieldhtmltype<>7 ";
		}
		orderkey = " t1.viewtype,t1.detailtable,t1.dsporder ";
	}
	tableString ="<table instanceid=\"\" name=\"fieldList\" tabletype=\"none\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.getWFPageId(pageIdStr),user.getUID())+"\" >"+
    "<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderkey+"\"  sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlisdistinct=\"true\" />";
    tableString += " <head>";
    tableString+="<col hide=\"true\"  text=\"\" column=\"id\" />";
    tableString+="<col hide=\"true\"  text=\"\" column=\"htmltype\" />";
    tableString+="<col hide=\"true\"  text=\"\" column=\"type\" />";
    tableString+="<col hide=\"true\"  text=\"\" column=\"dbtype\" />";
    tableString+="<col width=\"34%\"  text=\""+SystemEnv.getHtmlLabelName(15456,user.getLanguage())+"\" column=\"label\" otherpara=\""+user.getLanguage()+"+"+isbill+"\" transmethod=\"weaver.workflow.design.WFDesignTransMethod.getFieldLabel\"/>";
   	tableString+="<col width=\"33%\"  text=\""+SystemEnv.getHtmlLabelName(17997,user.getLanguage())+"\" column=\"isdetail\"  otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.workflow.design.WFDesignTransMethod.getFieldViewType\"  />";
   	tableString+="<col width=\"33%\"  text=\""+SystemEnv.getHtmlLabelName(687,user.getLanguage())+"\" column=\"htmltype\"  otherpara=\"column:type"+"+"+user.getLanguage()+"+"+"column:id"+"\" transmethod=\"weaver.workflow.design.WFDesignTransMethod.getFieldShowType\"  />";
   	//tableString+="<col width=\"14%\"  text=\""+SystemEnv.getHtmlLabelName(686,user.getLanguage())+"\" column=\"id\"  otherpara=\""+user.getLanguage()+"+"+pagetype+"\" transmethod=\"weaver.workflow.design.WFDesignTransMethod.getFieldType\"  />";
   	tableString+="<col hide=\"true\"  text=\"\" column=\"htmltype\" otherpara=\"column:id\" transmethod=\"weaver.workflow.design.WFDesignTransMethod.getSelectVal\" />";
   	tableString+="</head></table>";
	%>
	<input type="hidden" name="pageId" _showCol="false" id="pageId" value="<%=PageIdConst.getWFPageId(pageIdStr)%>"/>
	<wea:SplitPageTag tableString='<%=tableString%>' mode="run"/>
</div>
<%}else if(ftype.equals("1")){ %>
	<div id="_xTable" class="_xTableSplit" style="background:#FFFFFF;padding:0px;width:100%" valign="top"> 
		<div>
			<div class="table">
			<table cellspacing="0" class="ListStyle" style="table-layout: fixed;">
			<colgroup>
			<col width="34%" style="width: 34%;">
			<col width="33%" style="width: 33%;">
			<col width="33%" style="width: 33%;">
			</colgroup>
			<thead>
			<tr class="HeaderForXtalbe">
				<th align="left" title="" style="height: 30px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; display: none;"></th>
				<th align="left" title="" style="height: 30px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; display: none;"></th>
				<th align="left" title="" style="height: 30px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; display: none;"></th>
				<th align="left" title="" style="height: 30px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; display: none;"></th>
				<th align="left" title="" style="height: 30px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; display: none;"></th>
				<th align="left" title="<%=SystemEnv.getHtmlLabelName(15456, user.getLanguage())%>" style="height: 30px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; width: 34%;"><%=SystemEnv.getHtmlLabelName(15456, user.getLanguage())%></th>
				<th align="left" title="<%=SystemEnv.getHtmlLabelName(17997, user.getLanguage())%>" style="height: 30px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; width: 33%;"><%=SystemEnv.getHtmlLabelName(17997, user.getLanguage())%></th>
				<th align="left" title="<%=SystemEnv.getHtmlLabelName(687, user.getLanguage())%>" style="height: 30px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; width: 33%;"><%=SystemEnv.getHtmlLabelName(687, user.getLanguage())%></th>
				<th align="left" title="" style="height: 30px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; display: none;"></th>
			</tr>
			</thead>
			<tbody>
			<tr style="vertical-align: middle;">
			<td style="height: 30px; display: none; width: 5%;"></td>
			<td align="left" style="height: 30px; display: none; vertical-align: middle; word-wrap: break-word; word-break: break-all;">-10</td>
			<td align="left" style="height: 30px; display: none; vertical-align: middle; word-wrap: break-word; word-break: break-all;">3</td>
			<td align="left" style="height: 30px; display: none; vertical-align: middle; word-wrap: break-word; word-break: break-all;">1</td>
			<td align="left" style="height: 30px; display: none; vertical-align: middle; word-wrap: break-word; word-break: break-all;">int</td>
			<td align="left" style="height: 30px; vertical-align: middle; word-wrap: break-word; word-break: break-all;"><%=SystemEnv.getHtmlLabelName(882, user.getLanguage())%></td>
			<td align="left" style="height: 30px; vertical-align: middle; word-wrap: break-word; word-break: break-all;"><%=SystemEnv.getHtmlLabelName(28415, user.getLanguage())%></td>
			<td align="left" style="height: 30px; vertical-align: middle; word-wrap: break-word; word-break: break-all;"><%=SystemEnv.getHtmlLabelName(32306, user.getLanguage())%> - <%=SystemEnv.getHtmlLabelName(179, user.getLanguage())%></td>
			<td align="left" style="height: 30px; display: none; vertical-align: middle; word-wrap: break-word; word-break: break-all;">&nbsp;</td>
			</tr>
			<tr class="Spacing" style="height:1px!important;">
			<td colspan="3" class="paddingLeft0Table"><div class="intervalDivClass"></div></td>
			</tr>
			<tr style="vertical-align: middle;">
			<td style="height: 30px; display: none; width: 5%;"></td>
			<td align="left" style="height: 30px; display: none; vertical-align: middle; word-wrap: break-word; word-break: break-all;">-11</td>
			<td align="left" style="height: 30px; display: none; vertical-align: middle; word-wrap: break-word; word-break: break-all;">3</td>
			<td align="left" style="height: 30px; display: none; vertical-align: middle; word-wrap: break-word; word-break: break-all;">1</td>
			<td align="left" style="height: 30px; display: none; vertical-align: middle; word-wrap: break-word; word-break: break-all;">int</td>
			<td align="left" style="height: 30px; vertical-align: middle; word-wrap: break-word; word-break: break-all;"><%=SystemEnv.getHtmlLabelName(15080, user.getLanguage())%></td>
			<td align="left" style="height: 30px; vertical-align: middle; word-wrap: break-word; word-break: break-all;"><%=SystemEnv.getHtmlLabelName(28415, user.getLanguage())%></td>
			<td align="left" style="height: 30px; vertical-align: middle; word-wrap: break-word; word-break: break-all;"><%=SystemEnv.getHtmlLabelName(32306, user.getLanguage())%> - <%=SystemEnv.getHtmlLabelName(179, user.getLanguage())%></td>
			<td align="left" style="height: 30px; display: none; vertical-align: middle; word-wrap: break-word; word-break: break-all;">&nbsp;</td>
			</tr>
			<tr class="Spacing" style="height:1px!important;">
			<td colspan="3" class="paddingLeft0Table"><div class="intervalDivClass"></div></td>
			</tr>
			<tr style="vertical-align: middle;">
			<td style="height: 30px; display: none; width: 5%;"></td>
			<td align="left" style="height: 30px; display: none; vertical-align: middle; word-wrap: break-word; word-break: break-all;">-12</td>
			<td align="left" style="height: 30px; display: none; vertical-align: middle; word-wrap: break-word; word-break: break-all;">3</td>
			<td align="left" style="height: 30px; display: none; vertical-align: middle; word-wrap: break-word; word-break: break-all;">4</td>
			<td align="left" style="height: 30px; display: none; vertical-align: middle; word-wrap: break-word; word-break: break-all;">int</td>
			<td align="left" style="height: 30px; vertical-align: middle; word-wrap: break-word; word-break: break-all;"><%=SystemEnv.getHtmlLabelName(15081, user.getLanguage())%></td>
			<td align="left" style="height: 30px; vertical-align: middle; word-wrap: break-word; word-break: break-all;"><%=SystemEnv.getHtmlLabelName(28415, user.getLanguage())%></td>
			<td align="left" style="height: 30px; vertical-align: middle; word-wrap: break-word; word-break: break-all;"><%=SystemEnv.getHtmlLabelName(32306, user.getLanguage())%> - <%=SystemEnv.getHtmlLabelName(124, user.getLanguage())%></td>
			<td align="left" style="height: 30px; display: none; vertical-align: middle; word-wrap: break-word; word-break: break-all;">&nbsp;</td>
			</tr>
			<tr class="Spacing" style="height:1px!important;">
			<td colspan="3" class="paddingLeft0Table"><div class="intervalDivClass"></div></td>
			</tr style="vertical-align: middle;">
			<td style="height: 30px; display: none; width: 5%;"></td>
			<td align="left" style="height: 30px; display: none; vertical-align: middle; word-wrap: break-word; word-break: break-all;">-13</td>
			<td align="left" style="height: 30px; display: none; vertical-align: middle; word-wrap: break-word; word-break: break-all;">3</td>
			<td align="left" style="height: 30px; display: none; vertical-align: middle; word-wrap: break-word; word-break: break-all;">164</td>
			<td align="left" style="height: 30px; display: none; vertical-align: middle; word-wrap: break-word; word-break: break-all;">int</td>
			<td align="left" style="height: 30px; vertical-align: middle; word-wrap: break-word; word-break: break-all;"><%=SystemEnv.getHtmlLabelName(15577, user.getLanguage())%></td>
			<td align="left" style="height: 30px; vertical-align: middle; word-wrap: break-word; word-break: break-all;"><%=SystemEnv.getHtmlLabelName(28415, user.getLanguage())%></td>
			<td align="left" style="height: 30px; vertical-align: middle; word-wrap: break-word; word-break: break-all;"><%=SystemEnv.getHtmlLabelName(32306, user.getLanguage())%> - <%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%></td>
			<td align="left" style="height: 30px; display: none; vertical-align: middle; word-wrap: break-word; word-break: break-all;">&nbsp;</td>
			</tr>
			<tr class="Spacing" style="height:1px!important;">
			<td colspan="3" class="paddingLeft0Table"><div class="intervalDivClass"></div></td>
			</tr>
			</tbody></table>
			</div>
		</div>
	</div>
<%} %>
</div>
<script language=javascript>
	var dialog = parent.parent.getDialog(parent);
	$(document).ready(function(){
  		resizeDialog(document);
	});
</script>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="submitClear();">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
	    </wea:item>
		</wea:group>
	</wea:layout>
</div>	
<script type="text/javascript">
jQuery(document).ready(function(){
	if("<%=ftype%>" === "1")
		ontrclick();
});

function onSearch()
{
	SearchForm.submit();
}

function afterDoWhenLoaded(){
	ontrclick();
}

var weaverSplit = "||~WEAVERSPLIT~||";
function ontrclick()
{
	jQuery(".ListStyle").find("tbody tr:not([class='Spacing'])").click(function(){
		var fieldid=$(this).children("td").eq(1).html();
		var htmltype = $(this).children("td").eq(2).html()+"";
		var type = $(this).children("td").eq(3).html()+"";
		var dbtype = $(this).children("td").eq(4).html()+"";
		var label = $(this).children("td").eq(5).html()+"";
		if(htmltype==="")htmltype="0";
		if(type==="")type="0";
		if(dbtype==="")dbtype="-1";
		//保证组合个值不为空，不然截取会有问题；
		var pfieldstr = htmltype + weaverSplit + type + weaverSplit + dbtype;
		if(htmltype === "5") //下拉框需要值
		{
			var selectVal = $(this).children("td").eq(8).html()+"";
			pfieldstr+= weaverSplit + selectVal;
		}
		var returnjson = {id:fieldid,name:label,pfiled:pfieldstr};		
		if(dialog){
			dialog.callback(returnjson);
		}else
		{
			window.parent.parent.returnValue = returnjson;
		  	window.parent.parent.close();
		}
	});
}


function submitClear()
{
	if(dialog) {
		dialog.callback({id:"",name:""});
	} else {
		window.parent.returnValue = {id:"",name:""};
		window.parent.close()
	}
}

</script>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
</BODY>
</HTML>

