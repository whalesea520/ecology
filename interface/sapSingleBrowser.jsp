<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map.Entry"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.parseBrowser.*" %>
<%@ page import="weaver.interfaces.sap.SAPConn" %>
<%@ page import="com.sap.mw.jco.JCO" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SapBrowserComInfo" class="weaver.parseBrowser.SapBrowserComInfo" scope="page" />
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page" />
<HTML><HEAD>
<style>
	#loading{
	    position:absolute;
	    //left:37%;
	    //top:40%;
	    background:#ffffff;
	    padding:8px;
	    z-index:20001;
	    height:auto;
	    border:1px solid #ccc;
	}
</style>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
String workflowid = Util.getIntValue(request.getParameter("workflowid"),-1)+"";
String formid = Util.getIntValue(request.getParameter("formid"),-1)+"";
String isbill = Util.getIntValue(request.getParameter("isbill"),-1)+"";
String currenttime = Util.null2String(request.getParameter("currenttime"));
String issearch = Util.null2String(request.getParameter("issearch"));
String sapbrowserid = Util.null2String(request.getParameter("sapbrowserid"));//浏览框id
String frombrowserid = Util.null2String(request.getParameter("frombrowserid"));//触发字段id
int curpage = Util.getIntValue(request.getParameter("curpage"),1);//当前页
String fromNodeorReport=Util.getIntValue(request.getParameter("fromNodeorReport"),0)+"";//1表示改浏览按钮的点击来源为报表或节点前或批次条件
//baseBean.writeLog("workflowid=" + workflowid);
//baseBean.writeLog("sapbrowserid=" + sapbrowserid);


//检查SAP浏览按钮是否有数据授权设置
List containFilterList = new ArrayList();
List noContainFilterList = new ArrayList();
String checksql = "select * from SAPData_Auth_setting where (browserids='"+sapbrowserid+"' or browserids like '"+sapbrowserid+",%' or browserids like '%,"+sapbrowserid+",%' or browserids like '%,"+sapbrowserid+"') and (wfids='"+workflowid+"' or wfids like '"+workflowid+",%' or wfids like '%,"+workflowid+",%' or wfids like '%,"+workflowid+"') ";
rs2.execute(checksql);
while(rs2.next()){
	boolean hasAuthSetting = false;
	int settingid = rs2.getInt("id");
	String resourcetype = Util.null2String(rs2.getString("resourcetype"));
	String resourceids = Util.null2String(rs2.getString("resourceids"));
	String roleids = Util.null2String(rs2.getString("roleids"));
	if(resourcetype.equals("0")){
		if(("," + resourceids + ",").indexOf(","+user.getUID()+",") >= 0){
			hasAuthSetting = true;
		}
	}else if(resourcetype.equals("1")){
		rs3.execute("select * from HrmRoleMembers where resourceid="+user.getUID());
		while(rs3.next()){
			String tmproleid = rs3.getString("roleid");
			if(("," + roleids + ",").indexOf(","+tmproleid+",") >= 0){
				hasAuthSetting = true;
				break;
			}
		}
	}
	if(hasAuthSetting){
		rs3.execute("select * from SAPData_Auth_setting_detail where settingid='"+settingid+"' and browserid='"+sapbrowserid+"'");
		while(rs3.next()){
			String filtertype = Util.null2String(rs3.getString("filtertype"));
			String sapcode = Util.null2String(rs3.getString("sapcode"));
			if(filtertype.equals("0")){
				containFilterList.add(sapcode);
			}else if(filtertype.equals("1")){
				noContainFilterList.add(sapcode);
			}
		}
	}
}

//baseBean.writeLog("containFilterList=" + containFilterList);
//baseBean.writeLog("noContainFilterList=" + noContainFilterList);

boolean ismainfiled = true;//是主字段
String detailrow = "";//如果是明字段，代表行号
String fromfieldid = "";//字段id
String strs[] = frombrowserid.split("_");
if(strs.length==2){
	fromfieldid = strs[0];
	detailrow = strs[1];
	ismainfiled = false;
}else{
	fromfieldid = strs[0];
}

String needChangeFieldString = Util.null2String((String)session.getAttribute("needChangeFieldString_"+workflowid+"_"+currenttime));
HashMap AllField = (HashMap)session.getAttribute("AllField_"+workflowid+"_"+currenttime);//把字段的名字转化为字段的id={ZZL_OUTPAR=field13162, AA=field13184}
baseBean.writeLog("AllField=="+AllField);
if(AllField==null){
	AllField = new HashMap();
}
StringBuffer hiddenValue = new StringBuffer();//生成输入参数、输入结构的文本框-------------这些参数是真正传入到sap
HashMap valueMap = new HashMap();//记录输入参数、输入结构-------------这些参数是真正传入到sap
String fieldids[] = needChangeFieldString.split(",");
for(int i=0;i<fieldids.length;i++){
	String fieldid = Util.null2String(fieldids[i]);
	if(!fieldid.equals("")){
		String fieldvalue = Util.null2String(request.getParameter(fieldid));//获得流程表单上的输入参数，输入结构
		hiddenValue.append("<input type=\"hidden\" id=\""+fieldid+"\" name=\""+fieldid+"\" value=\""+fieldvalue+"\">");
		if(fieldid.split("_").length==2){
			fieldid = fieldid.split("_")[0];
		}
		//baseBean.writeLog("获得传入到sap的搜索条件---------------------------------:	"+fieldid+"	"+fieldvalue);
		if(!"".equals(fieldvalue)){
			valueMap.put(fieldid,fieldvalue);//记录真正的搜索条件
		}
	}
}
//baseBean.writeLog(hiddenValue.toString());

SapBaseBrowser SapBaseBrowser = (SapBaseBrowser)SapBrowserComInfo.getSapBaseBrowser(sapbrowserid);
String function = SapBaseBrowser.getFunction();//函数名
//baseBean.writeLog("function:"+function);
if(null==function||"".equals(function)){//进行数据效验
		out.println("--------------------------------------------------------------------------------------------------------<br>");
		out.println("---------------------"+SystemEnv.getHtmlLabelName(83824,user.getLanguage()) +"!<br>");
		out.println("--------------------------------------------------------------------------------------------------------<br>");
		return; 
}
String authWorkflowID = Util.null2String(SapBaseBrowser.getAuthWorkflowID());

boolean authFlag = Util.null2String(SapBaseBrowser.getAuthFlag()).equalsIgnoreCase("Y") && (","+authWorkflowID+",").indexOf(","+workflowid+",") >= 0;
if(user.getUID()==1){
	authFlag=false;
}
String sources = "";
if(!workflowid.equals("")){
	rs.executeSql("select SAPSource from workflow_base where id="+workflowid);
	if(rs.next())
		sources = rs.getString(1);
}
//执行函数
//baseBean.writeLog("sources="+sources);
SAPConn SAPConn = new SAPConn(sources);
JCO.Table Table = null;
JCO.Client sapconnection = SAPConn.getConnection();
if(null==sapconnection){//进行数据效验
		out.println("--------------------------------------------------------------------------------------------------------<br>");
		out.println("---------------------"+SystemEnv.getHtmlLabelName(83820,user.getLanguage())+"!<br>");
		out.println("--------------------------------------------------------------------------------------------------------<br>");
		return; 
}
JCO.Function bapi = SAPConn.excuteBapi(function,sapconnection); //
ArrayList import_input = SapBaseBrowser.getImport_input();

//输入参数设置
for(int i=0;i<import_input.size();i++){
	Field Field = (Field)import_input.get(i);
	String fname = Field.getName().toUpperCase();
	String fieldname = Field.getFromOaField().toUpperCase();
	String fieldid = Util.null2String((String)AllField.get(fieldname));
	String fieldvalue = Util.null2String((String)valueMap.get(fieldid));
	//如果设置了固定值，固定值优先
	String constant = Util.null2String(Field.getConstant());
	if(!constant.equals("")){
		fieldvalue = constant;
	}
	//baseBean.writeLog("id:	"+fname+"	"+fieldname + "	" +fieldvalue);
	bapi.getImportParameterList().setValue(fieldvalue,fname);
	//baseBean.writeLog("fname====:		"+fname+"	"+fieldvalue);
}
ArrayList struct_input = SapBaseBrowser.getStruct_input();
//输入结构设置
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
			String fieldid = Util.null2String((String)AllField.get(fieldname));
			String fieldvalue = Util.null2String((String)valueMap.get(fieldid));
			//如果设置了固定值，固定值优先
			String constant = Util.null2String(Field.getConstant());
			if(!constant.equals("")){
				fieldvalue = constant;
			}
			
			Structure.setValue(fieldvalue,fname);
		}
	}
}
sapconnection.execute(bapi);
SAPConn.releaseC(sapconnection);//释放连接
//获得返回结果 export
HashMap export_output_value_map = new HashMap();
ArrayList export_output = SapBaseBrowser.getExport_output();
//输出参数
for(int i=0;i<export_output.size();i++){
	Field Field = (Field)export_output.get(i);
	String fname = Field.getName().toUpperCase();
	String desc = Field.getDesc();
	String display = Field.getDisplay();
	String outvalue = Util.null2String(bapi.getExportParameterList().getString(fname));
	export_output_value_map.put("EXPORT_"+fname,outvalue);
	//baseBean.writeLog(fname+"	"+desc + "	" +display+"	"+outvalue);
}
int searchcount=0;//记录查询条件的字段总个数
HashMap  searchMapstu=new HashMap();
//输出结构
ArrayList struct_output = SapBaseBrowser.getStruct_output();
//循环结构的个数
for(int i=0;i<struct_output.size();i++){
	ArrayList searchListstu = new ArrayList();//获得查询字段（查询字段目前只能来源于输出结构和输出表）
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
			String search = Field.getSearch();
			String searchvalue = Util.null2String(request.getParameter(fname));//获得搜索条件的值，以便在搜索文本框中显示
			//baseBean.writeLog("输出结构的搜索条件"+fname);
			Field.setSearchvalue(searchvalue);
			if(search.equals("Y")){
				searchListstu.add(Field);//记录输出结构里面的查询字段
				searchcount++;
			}
			String outvalue = Util.null2String(Structure.getString(fname));
			export_output_value_map.put(StructName+"."+fname,outvalue);
		}
		searchMapstu.put(Structure, searchListstu);//封装输出结构的查询参数到map
	}
}
HashMap searchMaptable = new HashMap();//获得查询字段（查询字段目前只能来源于输出结构和输出表）
//输出表
ArrayList table_output = SapBaseBrowser.getTable_output();
if(null!=table_output&&table_output.size()>0){
	for(int i=0;i<1;i++){//写死1，表示只支持一张输出表
		ArrayList searchListtable = new ArrayList();//获得查询字段（查询字段目前只能来源于输出结构和输出表）
		ArrayList table_output_value_list = new ArrayList();
		TableField TableField = (TableField)table_output.get(i);
		String outtablename=TableField.getTableName();//输出表的名字
		ArrayList tableFieldList = TableField.getTableFieldList();
		for(int k=0;k<tableFieldList.size();k++){
			Field Field = (Field)tableFieldList.get(k);
			String fname = Field.getName().toUpperCase();
			String desc = Field.getDesc();
			String display = Field.getDisplay();
			String search = Field.getSearch();
			String searchvalue = Util.null2String(request.getParameter(fname));//获得搜索条件的值，以便在搜索文本框中显示
			//baseBean.writeLog("输出表的搜索条件"+fname);
			Field.setSearchvalue(searchvalue);
			if(search.equals("Y")){
				searchListtable.add(Field);//记录输出表里面的搜索字段
				searchcount++;
			}
			//baseBean.writeLog(fname+"	"+desc + "	" +display+"	"+search);
		}
		searchMaptable.put(outtablename, searchListtable);//封装输出表的查询参数到map
	}
}

int sumcount = 0;//浏览按钮数据的总行数
HashMap Alltable_output_value_map = new HashMap();
if(null!=table_output&&table_output.size()>0){
		for(int i=0;i<1;i++){//写死1，表示只支持一张输出表
		ArrayList table_output_value_list = new ArrayList();
		TableField TableField = (TableField)table_output.get(i);
		String identityField = Util.null2String(TableField.getIdentityField()).toUpperCase();//得到表的主键列
		String output_tablename = TableField.getTableName(); //输出表的名字
		ArrayList tableFieldList = TableField.getTableFieldList();//输出表要输出的列
		Table = bapi.getTableParameterList().getTable(output_tablename);
		for(int j=0;j<Table.getNumRows();j++){//循环数据的总行
			Table.setRow(j);
			HashMap table_output_value_map = new HashMap();//表示一行数据
			boolean isLegal = true;
			//循环所有的列---start--------------
			for(int k=0;k<tableFieldList.size();k++){ 
				Field Field = (Field)tableFieldList.get(k);
				String fname = Field.getName().toUpperCase();
				String desc = Field.getDesc();
				String display = Field.getDisplay();
				String search = Field.getSearch();
				String outvalue = Util.null2String(Table.getString(fname));
				if(search.equals("Y")){
					String searchvalue = Util.null2String(request.getParameter(fname));//获得搜索条件的值，以便进行输出表的数据过滤
					if(!searchvalue.equals("")){
						if(outvalue.indexOf(searchvalue)<0){//过滤数据
							isLegal = false;
							break;
						}
					}
				}
				//封装一列数据
				table_output_value_map.put(output_tablename+"_"+fname,outvalue);//表_列名,值
			}
			//循环所有的列---end--------------
			if(authFlag){//判断是否进行权限控制
				if(!identityField.equals("")){
					String identityFieldValue = ""; 
					String identityFields[] = identityField.split(",");
					for(int ti=0;ti<identityFields.length;ti++){
						String _identityField = Util.null2String(identityFields[ti]);
						if(!_identityField.equals("")){
							identityFieldValue += (identityFieldValue.equals("")?"":"$_$") + Util.null2String((String)table_output_value_map.get(output_tablename+"_" + _identityField));
						}
					}
					//String identityFieldValue = Util.null2String((String)table_output_value_map.get(output_tablename+"_" + identityField));
					if(!(containFilterList.contains(identityFieldValue) && noContainFilterList.contains(identityFieldValue))){
						if( !containFilterList.contains(identityFieldValue)){
							continue;
						}
						if( noContainFilterList.contains(identityFieldValue)){
							continue;
						}
					}
				}
			}
			if(isLegal){//如果数据是有效的
				sumcount++;
				table_output_value_list.add(table_output_value_map);//把行数据进行封装
			}
		}
		//把这个表的数据进行封装
		Alltable_output_value_map.put(output_tablename,table_output_value_list);//表名,整个表的数据
	}
}
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(searchcount>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>

<div id="loading">
	<span><img src="/images/loading2_wev8.gif" align="absmiddle"></span>
	<!-- 数据导入中，请稍等... -->
	<span  id="loading-msg"><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%></span>
</div>

<div id="content">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="sapSingleBrowser.jsp" method=post>

<input type="hidden" id="curpage" name="curpage" value="<%=curpage%>">

<input type="hidden" id="workflowid" name="workflowid" value="<%=workflowid%>">
<input type="hidden" id="formid" name="formid" value="<%=formid%>">
<input type="hidden" id="isbill" name="isbill" value="<%=isbill%>">
<input type="hidden" id="currenttime" name="currenttime" value="<%=currenttime%>">
<input type="hidden" id="issearch" name="issearch" value="<%=issearch%>">
<input type="hidden" id="sapbrowserid" name="sapbrowserid" value="<%=sapbrowserid%>">
<input type="hidden" id="frombrowserid" name="frombrowserid" value="<%=frombrowserid%>">
<%=hiddenValue%>

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
			if(searchcount>0){//有搜索字段
					out.println("<table width=100% class=ViewForm>");
					Iterator itstu = searchMapstu.entrySet().iterator();  
					while(itstu.hasNext()){		//循环搜索结构里面的搜索字段
						Entry entry = (Entry) itstu.next();  
						String fieldkey=entry.getKey()+"";//key
						List FieldList = (List)entry.getValue();//value-->list
						for(int i=0;i<FieldList.size();i=i+2){
							Field Field=(Field)FieldList.get(i);//得到每个输出结构的搜索字段
							String fieldname = Field.getName();
							String desc = Field.getDesc();
							String searchvalue = Field.getSearchvalue();
							out.println("<tr>");
							out.println("<TD width='15%'>"+desc+"</TD>");
							out.println("<TD width='35%'  class=field><input name='"+fieldname+"'  value='"+searchvalue+"'  class='InputStyle' size='20'></TD>");
							if(i<FieldList.size()){//获取后一个搜索参数
								 //i++;
								 try{
									 Field=(Field)FieldList.get(i+1);//得到每个输出结构的搜索字段
									 fieldname = Field.getName();
									 desc = Field.getDesc();
									 searchvalue = Field.getSearchvalue();
									 out.println("<TD width='15%'>"+desc+"</TD>");
									 out.println("<TD width='35%'  class=field><input name='"+fieldname+"'  value='"+searchvalue+"'  class='InputStyle' size='20'></TD>");
								 }catch(Exception e){
									//e.printStackTrace();
								 }
							}
							 out.println("</tr>");
							 out.println("<TR><TD class=Line colSpan=4></TD></TR>");
						}
				 	}
				 	Iterator ittab = searchMaptable.entrySet().iterator();  
					while(ittab.hasNext()){		//循环输出表里面的搜索字段
						Entry entry = (Entry) ittab.next();  
						String fieldkey=entry.getKey()+"";//key
						List FieldList = (List)entry.getValue();//value-->list
						for(int i=0;i<FieldList.size();i=i+2){
							Field Field=(Field)FieldList.get(i);//得到每个输出表的搜索字段
							String fieldname = Field.getName();
							String desc = Field.getDesc();
							String searchvalue = Field.getSearchvalue();
							out.println("<tr>");
							out.println("<TD width='15%'>"+desc+"</TD>");
							out.println("<TD width='35%'  class=field><input name='"+fieldname+"'  value='"+searchvalue+"'  class='InputStyle' size='20'></TD>");
							if(i<FieldList.size()){//获取后一个搜索参数
								// i++;
								try{
								 Field=(Field)FieldList.get(i+1);//得到每个输出表的搜索字段
								 fieldname = Field.getName();
								 desc = Field.getDesc();
								 searchvalue = Field.getSearchvalue();
								 out.println("<TD width='15%'>"+desc+"</TD>");
								 out.println("<TD width='35%'  class=field><input name='"+fieldname+"'  value='"+searchvalue+"'  class='InputStyle' size='20'></TD>");
								}catch(Exception e){
									//e.printStackTrace();
								}
							}
							 out.println("</tr>");
							 out.println("<TR><TD class=Line colSpan=4></TD></TR>");
						}
				 	}
				 	out.println("</table>");
				 	out.println("<br>");
			}
			out.println("<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1  width='100%'>");
			out.println("<TR class=DataHeader>");
			out.println("<TH style='display:none'></TH>");//隐藏的第一列
			
			int sumcolumn = 0;//总列数
			//输出参数的显示列
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
			//输出结构的显示列
			for(int i=0;i<struct_output.size();i++){//循环结构的个数
					StructField StructField = (StructField)struct_output.get(i);//结构体对象
					ArrayList structFieldList = StructField.getStructFieldList();//结构体字段
					String StructName = StructField.getStructName();//结构体名称
					if(!StructName.equals("")&&structFieldList.size()>0){
						JCO.Structure Structure = bapi.getExportParameterList().getStructure(StructName);
						for(int j=0;j<structFieldList.size();j++){
							sumcolumn++;
							Field Field = (Field)structFieldList.get(j);
							String fname = Field.getName().toUpperCase();
							String desc = Field.getDesc();
							String display = Field.getDisplay();
							String search = Field.getSearch();
							if(display.equals("N")){//不显示
								out.println("<TH style=\"display:none\">"+desc+"</TH>");	
							}else{
								out.println("<TH>"+desc+"</TH>");
							}
						}
					}
			}
			//输出table的显示列
			if(null!=table_output&&table_output.size()>0){
					for(int i=0;i<1;i++){//写死1，表示只支持一张输出表
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
			}
		//out.println("总列数"+sumcolumn);
		out.println("</TR>");
		out.println("<TR class=Line><TH colspan="+sumcolumn+"></TH></TR> ");

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
		boolean falgshow=true;
		StringBuffer sb=new StringBuffer();
		if(table_output.size()==0){//表示没有一个输出表
			trclass = !trclass;
			String styleclass = "DataLight";
			if(trclass){
				styleclass = "DataDark";
			}
			sb.append("<TR class='"+styleclass+"' >");
			sb.append("<TD style='display:none' id='returnvalue_2'></TD>");//表示第2行---输出参数和结构合并为一行
			//显示输出参数的值
			for(int j=0;j<export_output.size();j++){
				Field Field = (Field)export_output.get(j);
				String fname = Field.getName().toUpperCase();
				String desc = Field.getDesc();
				String display = Field.getDisplay();
				String key = "EXPORT_"+fname;
				String outvalue = Util.null2String((String)export_output_value_map.get(key));
				if(display.equals("N")){
					sb.append("<TD style=\"display:none\" id="+key+"_"+(2)+">"+outvalue+"</TD>");									
				}else{
					sb.append("<TD  id="+key+"_"+(2)+">"+outvalue+"</TD>");
				}
			}
			//显示输出结构的值
			for(int i=0;i<struct_output.size();i++){//循环结构的个数
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
							String search = Field.getSearch();
							String key = StructName+"."+fname;
							String outvalue = Util.null2String((String)export_output_value_map.get(key));
							if(search.equals("Y")){
								String searchvalue = Util.null2String(request.getParameter(fname));//获得搜索条件的值，以便进行输出表的数据过滤
								if(!searchvalue.equals("")){
									if(outvalue.indexOf(searchvalue)<0){//过滤数据
										falgshow=false;//输出结构只有一条数据，如果这唯一的一条数据都不符合条件的话，那就参数列也不显示出来了
										break;
									}
								}
							}
							if(display.equals("N")){
								sb.append("<TD style=\"display:none\" id="+key+"_"+(2)+">"+outvalue+"</TD>");									
							}else{
								sb.append("<TD  id="+key+"_"+(2)+">"+outvalue+"</TD>");
							}
						}
					}
			}
			sb.append("</TR>");
			if(falgshow){
				out.println(sb);
			}
		}else{
					//表示有输出表
				if(null!=table_output&&table_output.size()>0){
					for(int i=0;i<1;i++){//写死1，表示只支持一张输出表
						TableField TableField = (TableField)table_output.get(i);
						ArrayList tableFieldList = TableField.getTableFieldList();
						String output_tablename = TableField.getTableName();
						ArrayList table_output_value_list = (ArrayList)Alltable_output_value_map.get(output_tablename);//通过表名，找出整张表的数据
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
							boolean falgshow_02=true;
							StringBuffer sb_02=new StringBuffer();
							sb_02.append("<TR class="+styleclass+">");//输出参数-输出结构-输出表的值合并为一个大表格
							sb_02.append("<TD style='display:none' id='returnvalue_"+(index+2)+"'></TD>");
							//显示输出参数的值
							for(int k=0;k<export_output.size();k++){
								Field Field = (Field)export_output.get(k);
								String fname = Field.getName().toUpperCase();
								String desc = Field.getDesc();
								String key = "EXPORT_"+fname;//参数名
								String display = Field.getDisplay();
								String outvalue = Util.null2String((String)export_output_value_map.get(key));
								if(display.equals("N")){
									sb_02.append("<TD style=\"display:none\" id="+key+"_"+(index+2)+">"+outvalue+"</TD>");
								}else{
									sb_02.append("<TD id="+key+"_"+(index+2)+">"+outvalue+"</TD>");
								}
							}
							
							//显示输出结构的值
							for(int k=0;k<struct_output.size();k++){//循环结构的个数
									StructField StructField = (StructField)struct_output.get(k);//结构体对象
									ArrayList structFieldList = StructField.getStructFieldList();//结构体字段
									String StructName = StructField.getStructName();//结构体名称
									if(!StructName.equals("")&&structFieldList.size()>0){
										JCO.Structure Structure = bapi.getExportParameterList().getStructure(StructName);
										for(int jk=0;jk<structFieldList.size();jk++){
											Field Field = (Field)structFieldList.get(jk);
											String fname = Field.getName().toUpperCase();
											String desc = Field.getDesc();
											String display = Field.getDisplay();
											String search = Field.getSearch();
											String key = StructName+"."+fname;//结构名.字段名
											String outvalue = Util.null2String((String)export_output_value_map.get(key));
											if(search.equals("Y")){
											String searchvalue = Util.null2String(request.getParameter(fname));//获得搜索条件的值，以便进行输出表的数据过滤
											if(!searchvalue.equals("")){
													if(outvalue.indexOf(searchvalue)<0){//过滤数据
														falgshow_02=false;//输出结构只有一条数据，如果这唯一的一条数据都不符合条件的话，那就表示整个行的数据都不符合条件
														break;
													}
												}
											}
											if(display.equals("N")){
												sb_02.append("<TD style=\"display:none\" id="+key+"_"+(index+2)+">"+outvalue+"</TD>");									
											}else{
												sb_02.append("<TD  id="+key+"_"+(index+2)+">"+outvalue+"</TD>");
											}
										}
									}
							}
							//显示输出表的值
							for(int k=0;k<tableFieldList.size();k++){
								Field Field = (Field)tableFieldList.get(k);
								String fname = Field.getName().toUpperCase();
								String desc = Field.getDesc();
								String display = Field.getDisplay();
								String key = output_tablename+"_"+fname;//表名_字段名
								String outvalue = Util.null2String((String)table_output_value_map.get(key));
								if(display.equals("N")){
									sb_02.append("<TD style=\"display:none\" id="+key+"_"+(index+2)+">"+outvalue+"</TD>");
								}else{
									sb_02.append("<TD id="+key+"_"+(index+2)+">"+outvalue+"</TD>");
								}
							}
							sb_02.append("</tr>");
							if(falgshow_02){
								out.println(sb_02);//输出一条数据，即经过输出表的过滤条件，也经过输出结构的过滤条件
							}
						}
					}
				}
		}
		out.println("</TABLE>");	
		//获得需要赋值的字段
		ArrayList assignment = SapBaseBrowser.getAssignment();//赋值列表
		%>
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
</div>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY></HTML>
<script type="text/javascript">
jQuery(document).ready(function(){
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
		<%
				//检查赋值设置是否有赋值给本身的情况
			/* 	if("1".equals(fromNodeorReport)){
					for(int i=0;i<assignment.size();i++){
						Field Field = (Field) assignment.get(i);
						String name = Field.getName();
						String from = Field.getFrom();
						String fieldid = (String)AllField.get(name);
						if(fieldid=="field"+fromfieldid){//找到赋值字段,并且赋值
								
						}
					}
			
				baseBean.writeLog("frombrowserid="+frombrowserid);//触发动作的字段id */
		%>
				
		
		<%		
				//}else{
		%>
					setParentWindowValue($(this).attr('rowIndex'));
					window.parent.returnValue = {id:$(this).find("td:first").text(),name:$(this).find("td:first").text()};
					window.parent.close();
		<%
				//}
		%>
	});
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
		$(this).addClass("Selected")
	});
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
		$(this).removeClass("Selected")
	});

});
jQuery(document).ready(function(){
	jQuery("#loading").hide();
})
function setParentWindowValue(rowindex){
	//alert("rowindex:"+rowindex);
	<%
		for(int i=0;i<assignment.size();i++){
			Field Field = (Field) assignment.get(i);
			String name = Field.getName();
			
			String from = Field.getFrom();
			//baseBean.writeLog("赋值字段="+from);
			String fieldid = (String)AllField.get(name);
	%>		
			var fieldid = "<%=fieldid%>";
			var from = "<%=from%>";
			var value = getValue(from,rowindex);
			//alert(from+"--"+rowindex+"--"+value);
			if(fieldid=="field<%=fromfieldid%>"){//找到赋值字段,并且赋值
				jQuery(document.getElementById("returnvalue_"+rowindex)).text(value);
			}else{
				setValue(fieldid,value);
			}
	<%		
			//baseBean.writeLog(name+"	"+from+"	"+fieldid);
		}
	%>
}
function setValue(fieldid,value){
	var ismainfiled = "<%=ismainfiled%>";//如果是明细字段，加上行号
	var detailrow = "<%=detailrow%>";
	if(ismainfiled=="false"){
		fieldid = fieldid+"_"+detailrow;
	}
	try{
		getDialogArgumentByName(fieldid).value = value;
		if(getDialogArgumentByName(fieldid).type=="hidden"){
			getDialogArgumentByName(fieldid+"span").innerHTML = value;
		}else{
			getDialogArgumentByName(fieldid+"span").innerHTML = "";
		}
	}catch(e){
		
	}
}
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
		//正常的一个输入参数进行这个逻辑
		rvalue = getFieldValue(from+"_"+rowindex);
	}
	return rvalue;
}
function getFieldValue(fieldid){
	var rvalue = "";
	if(document.getElementById(fieldid)!=null){
		rvalue = jQuery(document.getElementById(fieldid)).text();
	}
	//alert(fieldid+"	"+document.getElementById(fieldid).innerHTML);
	return rvalue;
}

function btnclear_onclick(){
	window.parent.returnValue ={id:"",name:""};
	window.parent.close();
}

function onClear()
{
	window.parent.returnValue ={id:"",name:""};
	window.parent.close();
}
function onSubmit()
{
	jQuery("#content").hide();
	jQuery("#rightMenuIframe").hide();
	jQuery("#loading").show();
	SearchForm.submit();
}
function onPage(index)
{
	jQuery("#content").hide();
	jQuery("#rightMenuIframe").hide();
	jQuery("#loading").show();
	document.SearchForm.curpage.value = index;	
	SearchForm.submit();
}
function onClose()
{
	window.parent.close() ;
}

function getDialogArgumentByName(name) {
	var _document = null;
    if (window.ActiveXObject) { 
    	_document = window.dialogArguments.document;
    } else{
    	_document = top.window.dialogArguments.document;
	}   

	var ele = _document.getElementById(name);
	if (ele == undefined || ele == null) {
		var eles = _document.getElementsByName(name);
		if (eles != undefined && eles != null && eles.length > 0) {
			ele = eles[0];
		}
	}
	return ele;
}
</script>