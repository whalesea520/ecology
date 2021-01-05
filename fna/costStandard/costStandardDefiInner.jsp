<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.fna.costStandard.CostStandard"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.common.util.taglib.BrowserTag"%>
<%@page import="org.json.JSONObject"%>
<%@ page import="weaver.secondary.xtable.*" %>	
<%@ page import="weaver.common.xtable.TableSql" %>
<%@ page import="weaver.common.xtable.TableConst" %>	
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<%
if(!HrmUserVarify.checkUserRight("CostStandardSetting:set", user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

DecimalFormat dfDouble = new DecimalFormat("#.###############################");
String guid1 = UUID.randomUUID().toString();

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int parentid=Util.getIntValue(request.getParameter("paraid"),0);

String nameQuery = Util.null2String(request.getParameter("nameQuery")).trim();
%>
<html>
<head>
<!-- js动态生成浏览框-begin -->
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<!-- browser 相关 -->
<script type="text/javascript" src="/js/workflow/wfbrow_wev8.js"></script>
<script type='text/javascript' src="/js/ecology8/request/autoSelect_wev8.js"></script>
<link type="text/css" href="/js/ecology8/base/jquery-ui_wev8.css" rel=stylesheet>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/jquery-autocomplete/jquery.autocomplete_wev8.js"></script>
<!-- js动态生成浏览框-end -->

	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<script language="javascript" src="/js/weaver_wev8.js"></script>
	<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
	<link rel="stylesheet" href="/fna/costStandard/css/ext-all_wev8.css?r=<%=guid1 %>" />
	<link rel="stylesheet" href="/fna/costStandard/css/costStandardDefiInner_wev8.css?r=<%=guid1 %>" />
	<link rel="stylesheet" href="/fna/costStandard/css/xtheme-gray_wev8.css" />
	<link rel='stylesheet' type='text/css' href='/css/weaver-ext_wev8.css' />
	<script type='text/javascript' src='/js/extjs/adapter/ext/ext-base_wev8.js'></script>
	<script type='text/javascript' src='/js/extjs/ext-all_wev8.js'></script>
<%if(user.getLanguage()==7) {%>
	<script type='text/javascript' src='/js/extjs/build/locale/ext-lang-zh_CN_wev8.js'></script>
	<script type='text/javascript' src='/js/weaver-lang-cn-gbk_wev8.js'></script>
<%} else if(user.getLanguage()==8) {%>
	<script type='text/javascript' src='/js/extjs/build/locale/ext-lang-en_wev8.js'></script>
	<script type='text/javascript' src='/js/weaver-lang-en-gbk_wev8.js'></script>
<%}%>
	<script type="text/javascript" src="/fna/costStandard/js/WeaverTableExtFna_wev8.js?r=10"></script>
	<script type="text/javascript" src="/fna/costStandard/js/columnLock_wev8.js?r=10"></script>
	<script type="text/javascript" src="/fna/costStandard/js/LockingGridView_wev8.js?r=<%=guid1 %>"></script>
	
	<link rel="stylesheet" type="text/css" href="/css/weaver-ext-grid_wev8.css" />
	
	<script language="javascript" src="/fna/costStandard/js/jquery.fuzzyquery.min2_wev8.js?r=5"></script>
	<script language="javascript" src="/fna/costStandard/js/util2_wev8.js?r=3"></script>
	
	<script src="/workrelate/js/jquery.ui.core_wev8.js"></script>
	<script src="/workrelate/js/jquery.ui.widget_wev8.js"></script>
	<script src="/fna/costStandard/js/jquery.ui.datepicker_wev8.js"></script>
	<script type="text/javascript" src="/fna/encrypt/des/des_wev8.js"></script>
	<link rel="stylesheet" href="/workrelate/css/ui/jquery.ui.all_wev8.css" />
	  
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>

</head>
<body style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:doAdd(),_self} ";//新建
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_self} ";//删除
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(77,user.getLanguage())+",javascript:doCopy(),_self} ";//复制
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} ";//保存
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<span id="searchTable" style="display: none;"></span>
<form id="form2" name="form2" method="post"  action="/fna/costStandard/costStandardDefiInner.jsp">
<table id="topTitle" cellpadding="0" cellspacing="0" style="overflow: visible;">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>" 
				class="e8_btn_top" onclick="doAdd();"/><!-- 新建 -->
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" 
				class="e8_btn_top" onclick="doDel();"/><!-- 删除 -->
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(77,user.getLanguage()) %>" 
				class="e8_btn_top" onclick="doCopy();"/><!-- 复制 -->
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" 
				class="e8_btn_top" onclick="doSave();"/><!-- 保存 -->
			<input type="text" class="searchInput" id="nameQuery" name="nameQuery" value="<%=FnaCommon.escapeHtml(nameQuery) %>" /><!-- 快速搜索 -->
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span><!-- 高级搜索 -->
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>
<%
CostStandard costStandard = new CostStandard();

StringBuffer extDataRecord = new StringBuffer("{");

ArrayList<TableColumn> xTableColumnList=new ArrayList<TableColumn>();

TableColumn xTableColumn_name=new TableColumn();
xTableColumn_name.setColumn("fcsdName");
xTableColumn_name.setDataIndex("fcsdName");
xTableColumn_name.setHeader(SystemEnv.getHtmlLabelName(125545,user.getLanguage()));//费用标准名称
xTableColumn_name.setSortable(true);
xTableColumn_name.setHideable(true);
xTableColumn_name.setMenuDisabled(true);
xTableColumn_name.setWidth(150); 
xTableColumn_name.setLocked(true);
xTableColumn_name.setTransmethod("weaver.fna.costStandard.CostStandard.getEdit");
xTableColumn_name.setPara_1("column:fcsdName");
xTableColumn_name.setPara_2("fold_fcsdName+0+-1+ +column:fcsdGuid1+"+user.getLanguage());
xTableColumnList.add(xTableColumn_name);
extDataRecord.append("\"fcsdName\":"+
	JSONObject.quote(costStandard.getEdit("", "fnew_fcsdName"+"+"+"0+-1+ +#rowindex112233#+"+user.getLanguage()))+",");

xTableColumn_name=new TableColumn();
xTableColumn_name.setColumn("csAmount");
xTableColumn_name.setDataIndex("csAmount");
xTableColumn_name.setHeader(SystemEnv.getHtmlLabelName(125546,user.getLanguage()));//费用标准
xTableColumn_name.setSortable(true);
xTableColumn_name.setHideable(true);
xTableColumn_name.setMenuDisabled(true);
xTableColumn_name.setWidth(150); 
xTableColumn_name.setLocked(true);
xTableColumn_name.setTransmethod("weaver.fna.costStandard.CostStandard.getEdit");
xTableColumn_name.setPara_1("column:csAmount");
xTableColumn_name.setPara_2("fold_csAmount+2+-1+ +column:fcsdGuid1+"+user.getLanguage());
xTableColumnList.add(xTableColumn_name);
extDataRecord.append("\"csAmount\":"+
	JSONObject.quote(costStandard.getEdit("", "fnew_csAmount"+"+"+"2+-1+ +#rowindex112233#+"+user.getLanguage()))+",");

StringBuffer sqlmain = new StringBuffer("select a.guid1 fcsdGuid1, a.fcsdName, a.csAmount, a.orderNumber \n");
int idx = -1;
String sql = "select * \n" +
		" from FnaCostStandard a \n" +
		" where a.enabled = 1 \n" +
		" order by a.orderNumber, a.name ";
rs.executeSql(sql);
while(rs.next()){
	idx++;
	
	String fcsGuid1 = Util.null2String(rs.getString("guid1"));
	String name = Util.null2String(rs.getString("name"));
	int paramtype = Util.getIntValue(rs.getString("paramtype"), -1);
	int browsertype = Util.getIntValue(rs.getString("browsertype"), -1);
	String fielddbtype = Util.null2String(rs.getString("fielddbtype")).trim();
	String definebroswerType = Util.null2String(rs.getString("definebroswerType"));
	if("".equals(definebroswerType)){
		definebroswerType = " ";
	}
	String compareoption1 = Util.null2String(rs.getString("compareoption1")).trim();
	
	sqlmain.append("  , MAX(case when (b.fcsGuid1='"+StringEscapeUtils.escapeSql(fcsGuid1)+"') then b.valChar else NULL end) valChar_"+idx+" \n");
	//sqlmain.append("  , '"+StringEscapeUtils.escapeSql(name)+"' name_"+idx+" \n");
	//sqlmain.append("  , '"+paramtype+"' paramtype_"+idx+" \n");
	//sqlmain.append("  , '"+browsertype+"' browsertype_"+idx+" \n");
	//sqlmain.append("  , '"+compareoption1+"' compareoption1_"+idx+" \n");
	
	int width = 200;
	if(paramtype==0){
		width = 150;
	}else if(paramtype==1){
		width = 150;
	}else if(paramtype==2){
		width = 150;
	}else if(paramtype==3){
		if(browsertype == 2){
			width = 100;
		}
	}

	String compareoption1Name = "";
	if("1".equals(compareoption1)){
		compareoption1Name = SystemEnv.getHtmlLabelName(15508,user.getLanguage());//大于
	}else if("2".equals(compareoption1)){
		compareoption1Name = SystemEnv.getHtmlLabelName(325,user.getLanguage());//大于或等于
	}else if("3".equals(compareoption1)){
		compareoption1Name = SystemEnv.getHtmlLabelName(15509,user.getLanguage());//小于
	}else if("4".equals(compareoption1)){
		compareoption1Name = SystemEnv.getHtmlLabelName(326,user.getLanguage());//小于或等于
	}else if("5".equals(compareoption1)){
		compareoption1Name = SystemEnv.getHtmlLabelName(327,user.getLanguage());//等于
	}else if("6".equals(compareoption1)){
		compareoption1Name = SystemEnv.getHtmlLabelName(15506,user.getLanguage());//不等于
	}else if("7".equals(compareoption1)){
		compareoption1Name = SystemEnv.getHtmlLabelName(353,user.getLanguage());//属于
	}else if("8".equals(compareoption1)){
		compareoption1Name = SystemEnv.getHtmlLabelName(21473,user.getLanguage());//不属于
	}else if("9".equals(compareoption1)){
		compareoption1Name = SystemEnv.getHtmlLabelName(346,user.getLanguage());//包含
	}else if("10".equals(compareoption1)){
		compareoption1Name = SystemEnv.getHtmlLabelName(15507,user.getLanguage());//不包含
	}else if("11".equals(compareoption1)){
		compareoption1Name = SystemEnv.getHtmlLabelName(82763,user.getLanguage());//属于（含下级）
	}else if("12".equals(compareoption1)){
		compareoption1Name = SystemEnv.getHtmlLabelName(82764,user.getLanguage());//不属于（含下级）
	}

	xTableColumn_name=new TableColumn();
	xTableColumn_name.setColumn("valChar_"+idx+"");
	xTableColumn_name.setDataIndex("valChar_"+idx+"");
	xTableColumn_name.setHeader(name+"<br />（"+compareoption1Name+"）");
	xTableColumn_name.setSortable(true);
	xTableColumn_name.setHideable(true);
	xTableColumn_name.setMenuDisabled(true);
	xTableColumn_name.setWidth(width); 
	xTableColumn_name.setTransmethod("weaver.fna.costStandard.CostStandard.getEdit");
	xTableColumn_name.setPara_1("column:valChar_"+idx+"");
	xTableColumn_name.setPara_2("fold_"+fcsGuid1+"+"+paramtype+"+"+browsertype+"+"+definebroswerType+"+column:fcsdGuid1+"+user.getLanguage()+"+"+fielddbtype);
	xTableColumnList.add(xTableColumn_name);
	extDataRecord.append("\"valChar_"+idx+"\":"+
		JSONObject.quote(costStandard.getEdit("", "fnew_"+fcsGuid1+"+"+paramtype+"+"+browsertype+"+"+definebroswerType+"+#rowindex112233#+"+user.getLanguage()+"+"+fielddbtype))+",");
}

extDataRecord.append("\"endFlagName\":0}");

sqlmain.append(" from FnaCostStandardDefi a \n"+
	" join FnaCostStandardDefiDtl b on a.guid1 = b.fcsdGuid1 \n"+
	" where 1=1 \n"
);
if(!"".equals(nameQuery)){
	sqlmain.append(" and a.fcsdName like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%' \n");
}
sqlmain.append(" group by a.guid1, a.fcsdName, a.csAmount, a.orderNumber \n");

StringBuffer sqlWhere = new StringBuffer(" where 1=1 \n");
%>
<!-- advanced search -->
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<wea:layout type="4Col">
	    <wea:group context='<%=SystemEnv.getHtmlLabelName(32905, user.getLanguage()) %>'>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(125545,user.getLanguage())%></wea:item><!-- 费用标准名称 -->
		    <wea:item>
		    	<input type=text id="advQryName" name="advQryName" class=Inputstyle value='<%=FnaCommon.escapeHtml(nameQuery) %>' />
		    </wea:item>
<%
int xTableColumnListLen = xTableColumnList.size();
for(int i=0;i<xTableColumnListLen;i++){
	xTableColumn_name = xTableColumnList.get(i);
	String column = xTableColumn_name.getColumn();
	if("fcsdName".equals(column) || "csAmount".equals(column)){
		continue;
	}
	String header = xTableColumn_name.getHeader().replaceAll("<br />", "");
	String otherpara = xTableColumn_name.getPara_2();
	String[] otherparaArray = otherpara.split("\\+");
	String fieldId = Util.null2String(otherparaArray[0]).trim();
	int paramtype = Util.getIntValue(otherparaArray[1]);
	int browsertype = Util.getIntValue(otherparaArray[2]);
	String definebroswerType = Util.null2String(otherparaArray[3]).trim();
	int languageId = Util.getIntValue(otherparaArray[5]);
	String fielddbtype = "";
	if(otherparaArray.length >= 7){
		fielddbtype = Util.null2String(otherparaArray[6]).trim();
	}
	
	String qryFieldId = "qry_"+fieldId;

	String vals1 = Util.null2String(request.getParameter(qryFieldId+"_1"));
	String vals2 = "";
	String otherpara1_new = qryFieldId+"+"+paramtype+"+"+browsertype+"+"+definebroswerType+"+1+"+languageId+"+"+fielddbtype+"+150px+1";
	String otherpara2_new = "";
	if(paramtype==1 || paramtype==2 || (paramtype==3 && browsertype==2)){
		otherpara2_new = qryFieldId+"+"+paramtype+"+"+browsertype+"+"+definebroswerType+"+2+"+languageId+"+"+fielddbtype+"+150px+1";
		vals2 = Util.null2String(request.getParameter(qryFieldId+"_2"));
	}
	
	if(paramtype==1){
		if(!"".equals(vals1)){
	        try {
	            double _d = Integer.parseInt(vals1);
	        } catch (Exception ex) {
	        	vals1 = "0";
	        }
	        if("oracle".equals(rs.getDBType())){
				sqlWhere.append(" and "+column+" >= "+vals1+" ");
	        }else if("mysql".equalsIgnoreCase(rs.getDBType())){
				sqlWhere.append(" and CONVERT("+column+", SIGNED) >= "+vals1+" ");
	        }else{
				sqlWhere.append(" and CONVERT(INT, "+column+") >= "+vals1+" ");
	        }
		}
		if(!"".equals(vals2)){
	        try {
	            double _d = Integer.parseInt(vals2);
	        } catch (Exception ex) {
	        	vals2 = "0";
	        }
	        if("oracle".equals(rs.getDBType())){
				sqlWhere.append(" and "+column+" <= "+vals2+" ");
	        }else if("mysql".equalsIgnoreCase(rs.getDBType())){
				sqlWhere.append(" and CONVERT("+column+", SIGNED) <= "+vals2+" ");
	        }else{
				sqlWhere.append(" and CONVERT(INT, "+column+") <= "+vals2+" ");
	        }
		}
		
	}else if(paramtype==2){
		if(!"".equals(vals1)){
	        try {
	            double _d = Double.parseDouble(vals1);
	        } catch (Exception ex) {
	        	vals1 = "0";
	        }
	        if("oracle".equals(rs.getDBType())){
				sqlWhere.append(" and "+column+" >= "+vals1+" ");
	        }else if("mysql".equalsIgnoreCase(rs.getDBType())){
				sqlWhere.append(" and CONVERT("+column+", DECIMAL(38,18)) >= "+vals1+" ");
	        }else{
				sqlWhere.append(" and CONVERT(DECIMAL(38,18), "+column+") >= "+vals1+" ");
	        }
		}
		if(!"".equals(vals2)){
	        try {
	            double _d = Double.parseDouble(vals2);
	        } catch (Exception ex) {
	        	vals2 = "0";
	        }
	        if("oracle".equals(rs.getDBType())){
				sqlWhere.append(" and "+column+" <= "+vals2+" ");
	        }else if("mysql".equalsIgnoreCase(rs.getDBType())){
				sqlWhere.append(" and CONVERT("+column+", DECIMAL(38,18)) <= "+vals2+" ");
	        }else{
				sqlWhere.append(" and CONVERT(DECIMAL(38,18), "+column+") <= "+vals2+" ");
	        }
		}
		
	}else if(paramtype==3 && browsertype==2){
		if(!"".equals(vals1)){
			sqlWhere.append(" and "+column+" >= '"+StringEscapeUtils.escapeSql(vals1)+"' ");
		}
		if(!"".equals(vals2)){
			sqlWhere.append(" and "+column+" <= '"+StringEscapeUtils.escapeSql(vals2)+"' ");
		}
		
	}else if(paramtype==3){
		if(!"".equals(vals1)){
			if("oracle".equals(rs.getDBType())){
				sqlWhere.append(" and ','||"+column+"||',' like '%,"+StringEscapeUtils.escapeSql(vals1)+".%' ");
			}else if("mysql".equalsIgnoreCase(rs.getDBType())){
				sqlWhere.append(" and CONCAT(',', "+column+", ',') like '%,"+StringEscapeUtils.escapeSql(vals1)+".%' ");
			}else{
				sqlWhere.append(" and ','+"+column+"+',' like '%,"+StringEscapeUtils.escapeSql(vals1)+",%' ");
			}
		}
	}else{
		if(!"".equals(vals1)){
			sqlWhere.append(" and "+column+" like '%"+StringEscapeUtils.escapeSql(vals1)+"%' ");
		}
	}
%>
	    	<wea:item><%=header %></wea:item>
		    <wea:item>
		    	<%=costStandard.getEdit(vals1, otherpara1_new) %>
<%
	if(!"".equals(otherpara2_new)){
%>
				&nbsp;~&nbsp;
				<%=costStandard.getEdit(vals2, otherpara2_new) %>
<%
	}
%>
		    </wea:item>
<%
}
%>
	    </wea:group>
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input class="e8_btn_submit" type="button" id="advSubmit" onclick="onBtnSearchClick('from_advSubmit');" 
	    			value="<%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%>"/><!-- 查询 -->
	    		<input class="e8_btn_submit" type="button" id="advReset" onclick="resetCondtion();"
	    			value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>"/><!-- 重置 -->
	    		<input class="e8_btn_cancel" type="button" id="cancel" 
	    			value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"/><!-- 取消 -->
	    	</wea:item>
	    </wea:group>
	</wea:layout>
</div>	

	<wea:layout type="1col">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item attributes="{'isTableList':'true'}">
<%
String backfields = " * \n";
String fromSql = " from ("+sqlmain.toString()+") aa000 \n";
String orderBy = "fcsdName,orderNumber";

//out.println(("select "+backfields+fromSql+sqlWhere.toString()+" order by "+orderBy+" asc").replaceAll(" ", "&nbsp;").replaceAll("\n", "<br />"));
//new BaseBean().writeLog("select "+backfields+fromSql+sqlWhere.toString()+" order by "+orderBy+" asc");

TableSql xTableSql=new TableSql();
xTableSql.setBackfields(backfields);
xTableSql.setPageSize(8);
xTableSql.setSqlform(fromSql);
xTableSql.setSqlwhere(sqlWhere.toString());
xTableSql.setSqlprimarykey("fcsdGuid1");
xTableSql.setSqlisdistinct("false");
xTableSql.setSort(orderBy);
xTableSql.setDir(TableConst.ASC);

Table xTable=new Table(request); 
								
xTable.setTableNeedRowNumber(false);
xTable.setTableSql(xTableSql);
xTable.setTableGridType("checkbox");
xTable.setTableColumnList(xTableColumnList);
%>
				<%=xTable.myToString("0")%>	
			</wea:item>
		</wea:group>
	</wea:layout>
	<input id="rowindex112233" name="rowindex112233" value="-1" type="hidden" />
</form>

<script language="javascript">
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...
var _global_grid = null;
var _global_store = null;


function _brow_callback(){
	doProcessRows();
}

function doProcessRows(){
	_global_grid.getView().processRows();
}

function doCopy(){
	var _postStr = "operation=doCopy";
	
	var _parentTableArray = jQuery(".x-grid3-row-selected");
	var _parentTableArrayLen = _parentTableArray.length;
	for(var i=0;i<_parentTableArrayLen;i++){
		var _parentTable = jQuery(_parentTableArray[i]);
		if(_parentTable.length){
			var _fold_fcsdName = _parentTable.find("input[id^='fold_fcsdName_']");
			if(_fold_fcsdName.length){
				var _iptId = _fold_fcsdName.attr("id");
				if(_iptId!=""){
					var _iptIdArray = _iptId.split("_");
					if(_iptIdArray.length==3){
						_postStr += "&fold_fcsdGuid1s_copyArray="+_iptIdArray[2];
					}
				}
			}
			
			_fold_fcsdName = _parentTable.find("input[id^='fnew_fcsdName_']");
			if(_fold_fcsdName.length){
				var _iptId = _fold_fcsdName.attr("id");
				if(_iptId!=""){
					var _iptIdArray = _iptId.split("_");
					if(_iptIdArray.length==3){
						_postStr += "&fnew_fcsdGuid1s_copyArray="+_iptIdArray[2];
					}
				}
			}
		}
	}
	
	if(_postStr=="" || _postStr=="operation=doCopy"){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125560,user.getLanguage()) %>");//请先选择需要复制的数据
		return;
	}
	
	//alert(_postStr);

	
	var inputArray1 = jQuery("input");
	var inputArray1len = inputArray1.length;
	for(var i=0;i<inputArray1len;i++){
		var _iptId = jQuery(inputArray1[i]).attr("id");
		if(_iptId!=""){
			_postStr += "&"+_iptId+"="+jQuery(inputArray1[i]).val();
		}
	}
	
	//alert(_postStr);
	
	openNewDiv_FnaBudgetViewInner1(_Label33574);
	var _data = _postStr;
	jQuery.ajax({
		url : "/fna/costStandard/costStandardDefiInnerOp.jsp",
		type : "post",
		cache : false,
		processData : false,
		data : _data,
		dataType : "json",
		success: function do4Success(_json){
		    try{
		    	try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
				if(_json.flag){
					var extDataRecordArray = _json.extDataRecordArray;
					var extDataRecordArrayLen = extDataRecordArray.length;
					for(var i=0;i<extDataRecordArrayLen;i++){
						doAdd(extDataRecordArray[i]);
					}
					
				}else{
					top.Dialog.alert(_json.msg);
				}
		    	showRightMenuIframe();
		    }catch(e1){
		    	showRightMenuIframe();
		    }
		}
	});
	
}

function doDel(){
	var _postStr = "operation=doDel";
	var _parentTableArray = jQuery(".x-grid3-row-selected");
	var _parentTableArrayLen = _parentTableArray.length;
	for(var i=0;i<_parentTableArrayLen;i++){
		var _parentTable = jQuery(_parentTableArray[i]);
		if(_parentTable.length){
			var _fold_fcsdName = _parentTable.find("input[id^='fold_fcsdName_']");
			if(_fold_fcsdName.length){
				var _iptId = _fold_fcsdName.attr("id");
				if(_iptId!=""){
					var _iptIdArray = _iptId.split("_");
					if(_iptIdArray.length==3){
						_postStr += "&fold_fcsdGuid1s_array="+_iptIdArray[2];
					}
				}
			}
		}
	}
	
	if(_postStr==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24244,user.getLanguage()) %>");//请先选择需要删除的数据
		return;
	}

	openNewDiv_FnaBudgetViewInner1(_Label33574);
	var _data = _postStr;
	jQuery.ajax({
		url : "/fna/costStandard/costStandardDefiInnerOp.jsp",
		type : "post",
		cache : false,
		processData : false,
		data : _data,
		dataType : "json",
		success: function do4Success(_json){
		    try{
		    	try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
				if(_json.flag){
					window.location.href = "/fna/costStandard/costStandardDefiInner.jsp";
				}else{
					top.Dialog.alert(_json.msg);
				}
		    	showRightMenuIframe();
		    }catch(e1){
		    	showRightMenuIframe();
		    }
		}
	});
}

function doSave(){
	var _postStr = "operation=doSave";

	var inputArray0 = jQuery("input[id^='fold_fcsdName_']");
	var inputArray0len = inputArray0.length;
	for(var i=0;i<inputArray0len;i++){
		if(jQuery(inputArray0[i]).val()==""){
			alert("<%=SystemEnv.getHtmlLabelNames("127954",user.getLanguage()) %>");//费用标准必填
			return;
		}
	}
	inputArray0 = jQuery("input[id^='fnew_fcsdName_']");
	inputArray0len = inputArray0.length;
	for(var i=0;i<inputArray0len;i++){
		if(jQuery(inputArray0[i]).val()==""){
			alert("<%=SystemEnv.getHtmlLabelNames("127954",user.getLanguage()) %>");//费用标准必填
			return;
		}
	}

	inputArray0 = jQuery("input[id^='fold_csAmount_']");
	inputArray0len = inputArray0.length;
	for(var i=0;i<inputArray0len;i++){
		if(jQuery(inputArray0[i]).val()==""){
			alert("<%=SystemEnv.getHtmlLabelNames("127954",user.getLanguage()) %>");//费用标准必填
			return;
		}
	}
	inputArray0 = jQuery("input[id^='fnew_csAmount_']");
	inputArray0len = inputArray0.length;
	for(var i=0;i<inputArray0len;i++){
		if(jQuery(inputArray0[i]).val()==""){
			alert("<%=SystemEnv.getHtmlLabelNames("127954",user.getLanguage()) %>");//费用标准必填
			return;
		}
	}
	
	var inputArray1 = jQuery("input");
	var inputArray1len = inputArray1.length;
	for(var i=0;i<inputArray1len;i++){
		var _iptId = jQuery(inputArray1[i]).attr("id");
		if(_iptId!=""){
			_postStr += "&"+_iptId+"="+jQuery(inputArray1[i]).val();
		}
	}

	var inputArray2 = jQuery("input[id^='fold_fcsdName_']");
	var inputArray2len = inputArray2.length;
	for(var i=0;i<inputArray2len;i++){
		var _iptId = jQuery(inputArray2[i]).attr("id");
		if(_iptId!=""){
			var _iptIdArray = _iptId.split("_");
			if(_iptIdArray.length==3){
				_postStr += "&fold_fcsdGuid1s_array="+_iptIdArray[2];
			}
		}
	}

	openNewDiv_FnaBudgetViewInner1(_Label33574);
	var _data = _postStr;
	//alert(_data);
	jQuery.ajax({
		url : "/fna/costStandard/costStandardDefiInnerOp.jsp",
		type : "post",
		cache : false,
		processData : false,
		data : _data,
		dataType : "json",
		success: function do4Success(_json){
		    try{
		    	try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
				if(_json.flag){
					window.location.href = "/fna/costStandard/costStandardDefiInner.jsp";
				}else{
					top.Dialog.alert(_json.msg);
				}
		    	showRightMenuIframe();
		    }catch(e1){
		    	showRightMenuIframe();
		    }
		}
	});
}

function doAdd(_addRecord){
	try{
		var rowindex112233 = fnaRound2(jQuery("#rowindex112233").val(), 0);
		rowindex112233++;
		jQuery("#rowindex112233").val(rowindex112233+"");
		
		var extDataRecordStr = <%=JSONObject.quote(extDataRecord.toString()) %>;
		if(_addRecord!=null){
			extDataRecordStr = _addRecord;
		}
		extDataRecordStr = extDataRecordStr._fnaReplaceAll("#rowindex112233#", rowindex112233);
		var extDataRecord = new Ext.data.Record(eval("("+extDataRecordStr+")"));
		//_global_store.insert(0, extDataRecord);
		_global_store.add(extDataRecord);
		
		jQuery("#fnew_fcsdName_"+rowindex112233)[0].focus();
		
	}catch(ex1){
		alert(ex1);
	}
}

//生成费用单位浏览按钮事件
function onShowOrganizationBtn_fna(colFieldId, insertindex, btnType, browserUtl, isSingle){
	var _objIdObj = jQuery("#field"+colFieldId+"_"+insertindex);
	_objIdObj.val("");
    var viewtype = "0";

	var _browserId = "";
	var _browserName = "";

    var detailbrowclick = "onShowBrowser2('"+colFieldId+"_"+insertindex+"','"+browserUtl+"','','"+btnType+"','"+viewtype+"')";
    initE8Browser_fna1(""+colFieldId+"_"+insertindex, insertindex, viewtype, _browserId, _browserName, detailbrowclick, 
    		"/data.jsp", colFieldId, isSingle);
}

//渲染浏览按钮initE8Browser_fna _fieldId=field5881_0;0
function initE8Browser_fna1(_fieldId, _insertindex, _ismand, _browserValue, _browserSpanValue, _detailbrowclick, _completeUrl, _fieldId2, _isSingle){
	jQuery("#field"+_fieldId+"wrapspan").html("");
	var _isMustInput = "1";
	if(_ismand==1){
		_isMustInput = "2";
	}
	jQuery("#field"+_fieldId+"wrapspan").e8Browser({
	   name:"field"+_fieldId,
	   viewType:"1",
	   browserValue: _browserValue,
	   browserSpanValue: _browserSpanValue,
	   browserOnClick: _detailbrowclick,
	   hasInput:true,
	   isSingle:true,
	   hasBrowser:true, 
	   isMustInput:_isMustInput,
	   completeUrl:_completeUrl,
	   width:"95%",
	   needHidden:true
	});
}

function WeaverTableExtFna_onload(_grid, _store){
	_global_grid = _grid;
	_global_store = _store;
}

//快速（高级）搜索事件
function onBtnSearchClick(from_advSubmit){
	if(from_advSubmit=="from_advSubmit"){
		jQuery("#nameQuery").val(jQuery("#advQryName").val());
	}else{
		jQuery("#advQryName").val(jQuery("#nameQuery").val());
	}
	form2.submit();
}

//关闭
function doClose1(){
	window.closeDialog();
}

function setRowsHeight(){
}

function setScrollDefault(){
}

function onShowdate_fna(spanname,inputname){
	var returnvalue;
	var oncleaingFun = function(){
		$ele4p(spanname).innerHTML = ""; 
		$ele4p(inputname).value = '';
	}
	WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
		$dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun
	});
	var hidename = $ele4p(inputname).value;
	if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	}else{
		$ele4p(spanname).innerHTML = "";
	}
}
</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</body>
</html>