<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="java.util.List" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.parseBrowser.*" %>
<%@ page import="weaver.interfaces.sap.SAPConn" %>
<%@ page import="com.sap.mw.jco.JCO" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SapBrowserComInfo" class="weaver.parseBrowser.SapBrowserComInfo" scope="page" />

<HTML><HEAD> 
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%

if(!HrmUserVarify.checkUserRight("SAPDataAuthSetting:Manage",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}


String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = "SAP数据授权详细设置";
String needfav ="1";
String needhelp ="";

String sapbrowserid = Util.null2String(request.getParameter("sapbrowserid"));//浏览框id
String sources = Util.null2String(request.getParameter("sources"));//数据源code

int curpage = Util.getIntValue(request.getParameter("curpage"),1);//当前页

int settingid = Util.getIntValue(request.getParameter("settingid"),0);


List sapcodeList = (List)session.getAttribute("Temp_SAPDataAuthSetting_SAPCodeList_"+settingid+"_"+sapbrowserid);
if(sapcodeList == null){
	sapcodeList = new ArrayList();
}

String[] check_nodes = request.getParameterValues("check_node");
String filtertype = Util.null2String(request.getParameter("filtertype"));

/**
if(check_nodes != null){
	for(int i = 0; i<check_nodes.length; i++){
		String tmpcode = Util.null2String(check_nodes[i]);
		if(!sapcodeList.contains(tmpcode)){
			sapcodeList.add(tmpcode);
		}
	}
}**/

//System.out.println("sapcodeList1=" + sapcodeList);

if(sapcodeList == null || sapcodeList.size() == 0){
	filtertype = "0";
	sapcodeList = new ArrayList();
	rs.execute("select * from SAPData_Auth_setting_detail where settingid='"+settingid+"' and browserid='"+sapbrowserid+"'");
	while(rs.next()){
		filtertype = Util.null2String(rs.getString("filtertype"));
		String tmpcode = Util.null2String(rs.getString("sapcode"));
		sapcodeList.add(tmpcode);
	}
}

//System.out.println("sapcodeList2=" + sapcodeList);
//System.out.println("filtertype=" + filtertype);

session.setAttribute("Temp_SAPDataAuthSetting_SAPCodeList_"+settingid+"_"+sapbrowserid,sapcodeList);




SapBaseBrowser SapBaseBrowser = (SapBaseBrowser)SapBrowserComInfo.getSapBaseBrowser(sapbrowserid);
String function = SapBaseBrowser.getFunction();//函数名
//System.out.println("function:"+function);

//执行函数
SAPConn SAPConn = new SAPConn(sources);
JCO.Table Table = null;
JCO.Client sapconnection = SAPConn.getConnection();
JCO.Function bapi = SAPConn.excuteBapi(function,sapconnection); //
ArrayList import_input = SapBaseBrowser.getImport_input();

for(int i=0;i<import_input.size();i++){
	Field Field = (Field)import_input.get(i);
	String fname = Field.getName().toUpperCase();
	//如果设置了固定值，固定值优先
	String fieldvalue = "";
	String constant = Util.null2String(Field.getConstant());
	if(!constant.equals("")){
		fieldvalue = constant;
	}
	//System.out.println("id:	"+fname+"	"+fieldname + "	" +fieldvalue);
	bapi.getImportParameterList().setValue(fieldvalue,fname);
	//System.out.println("fname====:		"+fname+"	"+fieldvalue);
}
ArrayList struct_input = SapBaseBrowser.getStruct_input();
for(int i=0;i<struct_input.size();i++){
	StructField StructField = (StructField)struct_input.get(i);//结构体对象
	ArrayList structFieldList = StructField.getStructFieldList();//结构体字段
	String StructName = StructField.getStructName();//结构体名称
	if(!StructName.equals("")&&structFieldList.size()>0){
		JCO.Structure Structure = bapi.getImportParameterList().getStructure(StructName);
		for(int j=0;j<structFieldList.size();j++){
			Field Field = (Field)structFieldList.get(j);
			String fname = Field.getName().toUpperCase();
			String fieldname = Field.getFromOaField().toUpperCase();
			String fieldvalue = Util.null2String(Field.getConstant());
			Structure.setValue(fieldvalue,fname);
		}
	}
}

sapconnection.execute(bapi);
SAPConn.releaseC(sapconnection);//释放连接

//获得返回结果 export
HashMap export_output_value_map = new HashMap();
ArrayList export_output = SapBaseBrowser.getExport_output();
for(int i=0;i<export_output.size();i++){
	Field Field = (Field)export_output.get(i);
	String fname = Field.getName().toUpperCase();
	String desc = Field.getDesc();
	String display = Field.getDisplay();
	String outvalue = Util.null2String(bapi.getExportParameterList().getString(fname));
	export_output_value_map.put("EXPORT_"+fname,outvalue);
	//System.out.println(fname+"	"+desc + "	" +display+"	"+outvalue);
}

ArrayList struct_output = SapBaseBrowser.getStruct_output();
for(int i=0;i<struct_output.size();i++){
	StructField StructField = (StructField)struct_output.get(i);//结构体对象
	ArrayList structFieldList = StructField.getStructFieldList();//结构体字段
	String StructName = StructField.getStructName();//结构体名称
	if(!StructName.equals("")&&structFieldList.size()>0){
		JCO.Structure Structure = bapi.getExportParameterList().getStructure(StructName);
		for(int j=0;j<structFieldList.size();j++){
			Field Field = (Field)structFieldList.get(j);
			String fname = Field.getName().toUpperCase();
			String desc = Field.getDesc();
			String display = Field.getDisplay();
			String outvalue = Util.null2String(Structure.getString(fname));
			export_output_value_map.put(StructName+"_"+fname,outvalue);
		}
	}
}

//获得返回结果 table
ArrayList searchList = new ArrayList();//获得查询字段
ArrayList table_output = SapBaseBrowser.getTable_output();
for(int i=0;i<table_output.size();i++){
	ArrayList table_output_value_list = new ArrayList();
	TableField TableField = (TableField)table_output.get(i);
	ArrayList tableFieldList = TableField.getTableFieldList();
	for(int k=0;k<tableFieldList.size();k++){
		Field Field = (Field)tableFieldList.get(k);
		String fname = Field.getName().toUpperCase();
		String desc = Field.getDesc();
		String display = Field.getDisplay();
		String search = Field.getSearch();
		String searchvalue = Util.null2String(request.getParameter(fname));
		Field.setSearchvalue(searchvalue);
		if(search.equals("Y")){
			searchList.add(Field);
		}
		//System.out.println(fname+"	"+desc + "	" +display+"	"+search);
	}
}

int sumcount = 0;//浏览按钮数据的总行数
HashMap Alltable_output_value_map = new HashMap();
for(int i=0;i<table_output.size();i++){
	ArrayList table_output_value_list = new ArrayList();
	TableField TableField = (TableField)table_output.get(i);
	String output_tablename = TableField.getTableName(); 
	ArrayList tableFieldList = TableField.getTableFieldList();
	Table = bapi.getTableParameterList().getTable(output_tablename);
	for(int j=0;j<Table.getNumRows();j++){
		Table.setRow(j);
		HashMap table_output_value_map = new HashMap();
		boolean isLegal = true;
		for(int k=0;k<tableFieldList.size();k++){
			Field Field = (Field)tableFieldList.get(k);
			String fname = Field.getName().toUpperCase();
			String desc = Field.getDesc();
			String display = Field.getDisplay();
			String search = Field.getSearch();
			String outvalue = Util.null2String(Table.getString(fname));
			if(search.equals("Y")){
				String searchvalue = Util.null2String(request.getParameter(fname));
				if(!searchvalue.equals("")){
					if(outvalue.indexOf(searchvalue)<0){
						isLegal = false;
						break;
					}
				}
			}
			//System.out.println(output_tablename+"	"+fname+"	"+desc + "	" +display+"	"+outvalue);
			table_output_value_map.put(output_tablename+"_"+fname,outvalue);
		}
		if(isLegal){
			sumcount++;
			table_output_value_list.add(table_output_value_map);
		}
	}
	Alltable_output_value_map.put(output_tablename,table_output_value_list);
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(searchList.size()>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:btnok_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>


<FORM NAME=SearchForm STYLE="margin-bottom:0" action="SAPDataAuthDetailSetting.jsp" method=post target="detailset">

<input type="hidden" id="curpage" name="curpage" value="<%=curpage%>">

<input type="hidden" id="sapbrowserid" name="sapbrowserid" value="<%=sapbrowserid%>">
<input type="hidden" id="sources" name="sources" value="<%=sources%>">
<input type="hidden" id="settingid" name="settingid" value="<%=settingid%>">

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
		
		<%
			if(searchList.size()>0){//有搜索字段
		%>		
			<table width=100% class=ViewForm>
				<%
					for(int i=0;i<searchList.size();i++){
						Field Field = (Field)searchList.get(i);
						String fieldname = Field.getName();
						String desc = Field.getDesc();
						String searchvalue = Field.getSearchvalue();
				%>
					<tr>
						<TD width=15%><%=desc%></TD>
						<TD width=35% class=field><input name="<%=fieldname%>" value="<%=searchvalue%>" class="InputStyle" size="20"></TD>
						<%
							i++;
							if(i<searchList.size()){
								Field = (Field)searchList.get(i);
								fieldname = Field.getName();
								desc = Field.getDesc();
								searchvalue = Field.getSearchvalue();
						%>
								<TD width=15%><%=desc%></TD>
								<TD width=35% class=field><input name="<%=fieldname%>" value="<%=searchvalue%>" class="InputStyle" size="20"></TD>
						<%
							}
						%>
					</tr>
					<TR><TD class=Line colSpan=4></TD></TR>
				<%
				 	}
				%>
			</table>
			<br>
		<%	
			}
		%>
		
		<table class="ViewForm">
			<tbody>
				<TR><TD class=Line1 colSpan=4></TD></TR>
				<tr>
					<td width="15%"><%=SystemEnv.getHtmlLabelName(28224,user.getLanguage()) %></td>
					<td class="Field">
						<input type="checkbox" class="inputstyle" checked="checked" disabled="disabled">
						<%=SystemEnv.getHtmlLabelName(346,user.getLanguage()) %>
						<!--<input type="radio" name="filtertype" value="0" <%if(filtertype.equals("0")){out.print("checked=\"checked\"");} %>>-->
						<input type="hidden" name="filtertype" value="0">
						<!-- 
						&nbsp;&nbsp;&nbsp;&nbsp;
						<%=SystemEnv.getHtmlLabelName(15507,user.getLanguage()) %><input type="radio" name="filtertype" value="1" <%if(filtertype.equals("1")){out.print("checked=\"checked\"");} %>>
						 -->
					</td>
				</tr>
				<TR><TD class=Line1 colSpan=4></TD></TR>
			</tbody>
		</table>
		
		<TABLE ID=BrowseTable class=BroswerStyle cellspacing="1">
		<TR class=DataHeader>
		<TH style='display:none'></TH>
		<TH style="width: 50"><input type="checkbox" name="select_all" id="select_all" onclick="selectall(this)"><%=SystemEnv.getHtmlLabelName(556,user.getLanguage()) %></TH>
		<%
			int sumcolumn = 1;//总列数
		%>
		<!-- export 显示列  -->
		<%
			for(int i=0;i<export_output.size();i++){
				sumcolumn++;
				Field Field = (Field)export_output.get(i);
				String fname = Field.getName().toUpperCase();
				String desc = Field.getDesc();
				String display = Field.getDisplay();
				if(display.equals("N")){//不显示
					out.println("<TH style=\"display:none\">"+desc+"</TH>");	
				}else{
					out.println("<TH>"+desc+"</TH>");
				}
			}
		%>
		
		<!-- table 显示列 -->
		<%
			for(int i=0;i<table_output.size();i++){
				TableField TableField = (TableField)table_output.get(i);
				String output_tablename = TableField.getTableName(); 
				ArrayList tableFieldList = TableField.getTableFieldList();
				for(int k=0;k<tableFieldList.size();k++){
					sumcolumn++;
					Field Field = (Field)tableFieldList.get(k);
					String fname = Field.getName().toUpperCase();
					String desc = Field.getDesc();
					String display = Field.getDisplay();
					if(display.equals("N")){//不显示
						out.println("<TH style=\"display:none\">"+desc+"</TH>");	
					}else{
						out.println("<TH>"+desc+"</TH>");
					}
				}
			}
		%>
		</TR>
		<TR class=Line><TH colspan="<%=sumcolumn%>"></TH></TR> 
		<%
		int perpage = 50;//每页行数
		boolean nextpage = false;
		boolean lastpage = false;
		if(curpage*perpage<sumcount){
			nextpage = true;
		}
		if(curpage>1){
			lastpage = true;				
		}
		if(lastpage){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:onPage("+(curpage-1)+"),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		if(nextpage){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:onPage("+(curpage+1)+"),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		
		boolean trclass = true;
		int displayrows = 1;
		if(table_output.size()==0){//table 没有值，显示一行
			trclass = !trclass;
			String styleclass = "DataLight";
			if(trclass){
				styleclass = "DataDark";
			}
		%>
			<TR class="<%=styleclass%>">
				<TD style="display:none" id="returnvalue_2"></TD>
				<td>
					<input type="checkbox" name="check_node">
				</td>
				<!-- 显示export 的值 -->
				<%
					for(int j=0;j<export_output.size();j++){
						Field Field = (Field)export_output.get(j);
						String fname = Field.getName().toUpperCase();
						String desc = Field.getDesc();
						String display = Field.getDisplay();
						String key = "EXPORT_"+fname;
						String outvalue = Util.null2String((String)export_output_value_map.get(key));
						if(display.equals("N")){
							out.println("<TD style=\"display:none\" id="+key+"_"+(2)+">"+outvalue+"</TD>");									
						}else{
							out.println("<TD div id="+key+"_"+(2)+">"+outvalue+"</TD>");
						}
					}
				%>
			</TR>
		<%
		}else{
			for(int i=0;i<table_output.size();i++){
				TableField TableField = (TableField)table_output.get(i);
				
				//标示字段
				String identityField = Util.null2String(TableField.getIdentityField()).toUpperCase();
				
				ArrayList tableFieldList = TableField.getTableFieldList();
				String output_tablename = TableField.getTableName();
				ArrayList table_output_value_list = (ArrayList)Alltable_output_value_map.get(output_tablename);
				if(table_output_value_list==null){
					table_output_value_list = new ArrayList();
				}
				
				int start = (curpage-1) * perpage;
				int end = curpage * perpage;
				if(end>sumcount) end = sumcount;//table_output_value_list.size()
				int index = -1;
				for(int j=start;j<end;j++){
					index++;
					HashMap table_output_value_map = (HashMap)table_output_value_list.get(j);
					if(table_output_value_map==null){
						table_output_value_map = new HashMap();
					}
					trclass = !trclass;
					String styleclass = "DataLight";
					if(trclass){
						styleclass = "DataDark";
					}
				%>
					<TR class="<%=styleclass%>">
						<TD style="display:none" id="returnvalue_<%=(index+2)%>"></TD>
						<td>
							<%
								String tmpidentityvalue = ""; 
								String identityFields[] = identityField.split(",");
								for(int ti=0;ti<identityFields.length;ti++){
									String _identityField = Util.null2String(identityFields[ti]);
									if(!_identityField.equals("")){
										tmpidentityvalue += (tmpidentityvalue.equals("")?"":"$_$") + Util.null2String((String)table_output_value_map.get(output_tablename+"_" + _identityField));
									}
								}
								
								String tmpchecked = sapcodeList.contains(tmpidentityvalue) ? "checked=\"checked\"" : "";
							%>
							<input type="checkbox" name="check_node" value="<%=tmpidentityvalue %>" <%=tmpchecked %>>
						</td>
						<!-- 显示export 的值 -->
						<%
							for(int k=0;k<export_output.size();k++){
								Field Field = (Field)export_output.get(k);
								String fname = Field.getName().toUpperCase();
								String desc = Field.getDesc();
								String key = "EXPORT_"+fname;
								String display = Field.getDisplay();
								String outvalue = Util.null2String((String)export_output_value_map.get(key));
								if(display.equals("N")){
									out.println("<TD style=\"display:none\" id="+key+"_"+(index+2)+">"+outvalue+"</TD>");
								}else{
									out.println("<TD id="+key+"_"+(index+2)+">"+outvalue+"</TD>");
								}
							}
						%>
						<!-- 显示table 的值 -->
						<%
							for(int k=0;k<tableFieldList.size();k++){
								Field Field = (Field)tableFieldList.get(k);
								String fname = Field.getName().toUpperCase();
								String desc = Field.getDesc();
								String display = Field.getDisplay();
								String key = output_tablename+"_"+fname;
								String outvalue = Util.null2String((String)table_output_value_map.get(key));
								if(display.equals("N")){
									out.println("<TD style=\"display:none\" id="+key+"_"+(index+2)+">"+outvalue+"</TD>");
								}else{
									out.println("<TD id="+key+"_"+(index+2)+">"+outvalue+"</TD>");
								}
							}
						%>
					</TR>
				<%}
			}
		}
		%>
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY></HTML>

<script type="text/javascript" src="/js/jquery/jquery_wev8.js"></script>
<script type="text/javascript">
jQuery(document).ready(function(){

	window.name = 'detailset';

	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(event){
		if($(this)[0].tagName=="TR"&&event.target.tagName!="INPUT"){
			var obj = jQuery(this).find("input[name=check_node]");
		   	if (obj.attr("checked") == true){
		   		obj.attr("checked", false);
				syncSAPCode(obj.val(),'<%=settingid%>','<%=sapbrowserid%>','delete');

		   	}else{
		   		obj.attr("checked", true);
				syncSAPCode(obj.val(),'<%=settingid%>','<%=sapbrowserid%>','add');
		   	}

		}
		//点击checkbox框
	    if(event.target.tagName=="INPUT"){
	       var obj = jQuery(this).find("input[name=check_node]");
		   	if (obj.attr("checked") == true){
				syncSAPCode(obj.val(),'<%=settingid%>','<%=sapbrowserid%>','add');
		   	}else{
				syncSAPCode(obj.val(),'<%=settingid%>','<%=sapbrowserid%>','delete');
		   	}
	    }
	});
	
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
		$(this).addClass("Selected");
	})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
		$(this).removeClass("Selected");
	})

});
</script>


<script language="javascript">

function getValue(from,rowindex){
	var froms = from.split(",");
	var rvalue = "";
	if(froms.length>1){
		for(var i=0;i<froms.length;i++){
			var tempfield = froms[i];
			if(tempfield.length>2){
				if(tempfield.substring(0,1)=="$"&&tempfield.substring(tempfield.length-1,tempfield.length)=="$"){
					tempfield = tempfield.substring(1,tempfield.length-1);
					rvalue += getFieldValue(tempfield+"_"+rowindex);
				}else{
					rvalue += tempfield;
				}
			}else{
				rvalue += tempfield;
			}
		}
	}else{
		rvalue = getFieldValue(from+"_"+rowindex);
	}
	return rvalue;
}
function getFieldValue(fieldid){
	var rvalue = "";
	if(document.getElementById(fieldid)!=null){
		rvalue = document.getElementById(fieldid).innerText;
	}
	//alert(fieldid+"	"+document.getElementById(fieldid));
	return rvalue;
}


function onSubmit()
{
	SearchForm.submit();
}
function onPage(index)
{
	document.SearchForm.curpage.value = index;	
	SearchForm.submit();
}






function onClose()
{
	window.parent.returnValue = {operation:'cancel',settingid:'<%=settingid%>',sapbrowserid:'<%=sapbrowserid%>'};
	window.parent.close() ;
}

function onClear()
{
	window.parent.returnValue = {operation:'clear',settingid:'<%=settingid%>',sapbrowserid:'<%=sapbrowserid%>'};
	window.parent.close() ;
}

function btnok_onclick(){
	/**
	var filtertype = jQuery("input[type='radio'][name='filtertype'][checked]").val();
	if(!filtertype){
		alert('<%=SystemEnv.getHtmlLabelName(28226,user.getLanguage())%>');
		return;
	}**/
	var filtertype = '0';
	var sapcodes = '';
	jQuery("input[type='checkbox'][name='check_node'][checked]").each(function(){
		sapcodes += this.value + ',';
	});
	window.parent.returnValue = {operation:'savedetail',settingid:'<%=settingid%>',sapbrowserid:'<%=sapbrowserid%>',sapcodes:sapcodes,filtertype:filtertype};
	window.parent.close() ;
}





function syncSAPCode(sapcodes,settingid,sapbrowserid,type,filtertype){
	var addflag = true;
	/**
	if(type && type == 'add'){
		jQuery.post('SAPDataAuthSaveDetailAjax.jsp',{type:type,operation:'checkConflict',sapcodes:sapcodes,settingid:settingid,sapbrowserid:sapbrowserid,filtertype:filtertype},function(data){
			eval('var obj = ' + data);
			var conflictCode = obj.conflictCode;
			if(conflictCode && conflictCode.length > 0){
				var filtertypestr = filtertype == '0' ? '已在包含列表中，请重新选择！' : '已在不包含列表中，请重新选择！';
				alert('您选择的数据有冲突，【'+conflictCode+'】'+filtertypestr);
				var conflictCodearr = conflictCode.split(',');
				for(var i = 0; i<conflictCodearr.length; i++){
					var tmpcode = conflictCodearr[i];
					var check_node = jQuery("input[type='checkbox'][name='check_node'][value='"+tmpcode+"']");
					check_node.attr({checked:false});
				}
				addflag = false;
			}
		});
	}**/
	sapcodes = encodeURIComponent(sapcodes);
	if(addflag){
		jQuery.post('SAPDataAuthSaveDetailAjax.jsp',{type:type,operation:'syncSAPCode',sapcodes:sapcodes,settingid:settingid,sapbrowserid:sapbrowserid},function(data){});
	}
}







function selectall(obj){
	var check_nodes = jQuery("input[type='checkbox'][name='check_node']"); 
	if(obj.checked){
		var allsapcode = '';
		check_nodes.each(function(){
			this.checked = true;
			allsapcode += this.value + ',';
		});
		syncSAPCode(allsapcode,'<%=settingid%>','<%=sapbrowserid%>','add');
	}else{
		var allsapcode = '';
		check_nodes.each(function(){
			this.checked = false;
			allsapcode += this.value + ',';
		});
		syncSAPCode(allsapcode,'<%=settingid%>','<%=sapbrowserid%>','delete');
	}
}
</script>