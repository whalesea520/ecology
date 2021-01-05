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
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="weaver.hrm.definedfield.HrmDeptFieldManager"%>
<%@page import="weaver.hrm.resource.HrmSynDAO"%><HTML><HEAD>
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
int shownameid=15549;
int endshownameid=0;

String orderby = " issystem desc,fieldorder ";
if("oracle".equals( RecordSet.getDBType() )){
	orderby = " issystem,fieldorder ";
}

//17037:自定义字段；18020：主表字段
int type=0;
LinkedList<Map> data = new LinkedList<Map>();//存放数据的list
Map outkey = new HashMap();
outkey.put("fielddesc",SystemEnv.getHtmlLabelName(126059,user.getLanguage()));
outkey.put("fieldname","outkey");
outkey.put("fielddbtype","18020");
data.add(outkey);

if("hrmsubcompany".equals(dmltablename)){
	type = 1;
	endshownameid = 33553;
	sql.append(" ( select  fieldname,1 as issystem,0 as fieldorder,b.labelname from hrsyncsetaddfield a,HtmlLabelInfo b   where tablename='hrmsubcompany'   and  a.labelid = b.indexid and b.languageid="+user.getLanguage());
	sql.append(" union all ");
	sql.append(" select fieldname,issystem,fieldorder,h.labelname from hrm_formfield a, hrm_fieldgroup b,HtmlLabelInfo h where a.groupid = b.id and a.fieldlabel=h.indexid and h.languageid="+user.getLanguage()+" and grouptype =4 and isuse=1  ) t ");
}else if("hrmdepartment".equals(dmltablename)){
	type = 2;
	endshownameid = 82499;
	sql.append(" ( select  fieldname,1 as issystem,0 as fieldorder,b.labelname from hrsyncsetaddfield a,HtmlLabelInfo b   where tablename='hrmdepartment'   and  a.labelid = b.indexid and b.languageid="+user.getLanguage());
	sql.append(" union all ");
	//过滤掉无用的部门id列“and a.fieldname <> 'showid'”
	sql.append(" select fieldname,issystem, fieldorder,h.labelname from hrm_formfield a, hrm_fieldgroup b,HtmlLabelInfo h where a.groupid = b.id and a.fieldlabel=h.indexid and h.languageid="+user.getLanguage()+" and a.fieldname <> 'showid' and grouptype =5 and isuse=1 ) t ");
}else if("hrmjobtitles".equals(dmltablename)){
	type = 3;
	endshownameid = 6086;
	//QC306284 [80][90]优化-HR同步， 岗位表属性字段中的字段显示名进行调整以便于理解 -start
	Map<String,String> nameMap = HrmSynDAO.getFeildName(type,user.getLanguage());
	//职务ID
	nameMap.put("jobactivityid", SystemEnv.getHtmlLabelNames("1915,32011", user.getLanguage()));
	//任职资格
	nameMap.put("jobcompetency", SystemEnv.getHtmlLabelName(895, user.getLanguage()));
	//岗位简称
	nameMap.put("jobtitlemark", SystemEnv.getHtmlLabelNames("6086,399", user.getLanguage()));
	//岗位全称
	nameMap.put("jobtitlename", SystemEnv.getHtmlLabelNames("6086,15767", user.getLanguage()));
	RecordSetDataSource rsds=new RecordSetDataSource();
	TreeMap<String,String>	setColnums = (TreeMap) rsds.getAllColumnWithTypes(new RecordSet(), "HrmJobTitles");
	setColnums.remove("jobdepartmentid");
    //QC306284 [80][90]优化-HR同步， 岗位表属性字段中的字段显示名进行调整以便于理解 -end
	for(Map.Entry en : setColnums.entrySet()){
		if(StringUtils.isNotBlank(nameMap.get(en.getKey())) && !"outkey".equals(en.getKey()) && !"id".equals(en.getKey())){
			Map onefield = new HashMap();
		 	onefield.put("fielddesc",nameMap.get(en.getKey()));
		 	onefield.put("fieldname",en.getKey());
		 	onefield.put("fielddbtype","18020");
		 	data.add(onefield);
		}
	}
	
}else if("hrmresource".equals(dmltablename)){
	type = 4;
	endshownameid =33451;
	sql.append(" ( select  fieldname,'1' as issystem,0 as fieldorder,b.labelname  from hrsyncsetaddfield a,HtmlLabelInfo b  where tablename='hrmresource'  and  a.labelid = b.indexid and b.languageid="+user.getLanguage());
	sql.append(" union all ");
	sql.append(" SELECT fieldname,'1' as issystem,fieldorder,h.labelname FROM hrm_formfield a,hrm_fieldgroup b ,HtmlLabelInfo h ");
	sql.append(" WHERE a.groupid= b.id and a.fieldlabel=h.indexid and h.languageid="+user.getLanguage()+" AND grouptype in(-1,1,3) AND isuse=1  AND fieldname <>'jobactivity'");
	sql.append(" union all ");
	sql.append(" select t2.fieldname,'',fieldorder,hrm_fieldlable from cus_formfield t1 ,cus_formdict t2 where t1.fieldid = t2.id  and t1.isuse=1 and t1.scope='HrmCustomFieldByInfoType' and t1.scopeid=-1 ) t ");
}

String sqlwhere = " where 1=1 ";
if(StringUtils.isNotBlank(fielddes)){
	sqlwhere += " and labelname like '%"+fielddes+"%' ";
}
String backfields=" * " ;
String PageConstId = "hrsettingfield"+dmltablename;
String fromSql= sql.toString(); 
String tableString =  " <table instanceid=\"ListTable\" tabletype=\"none\"  pagesize=\""+PageIdConst.getPageSize(PageConstId,user.getUID(),PageIdConst.Browser)+"\" >";
tableString += " <checkboxpopedom popedompara=\"column:labelname\" showmethod=\"weaver.general.SplitPageTransmethod.getCheckBox\" />"+
		 " <sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"labelname\" sqlsortway=\"Asc\" sqlisdistinct=\"true\" />"+
         "       <head>"+
         "           <col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(15456 ,user.getLanguage())+"\" column=\"labelname\" />"+
         "           <col hide=\"true\" width=\"5%\" text=\"fieldname\" column=\"fieldname\" />"+
		 "           <col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(686 ,user.getLanguage())+"\" column=\"issystem\" transmethod=\"weaver.general.SplitPageTransmethod.getFieldTypeName\" otherpara=\""+user.getLanguage()+"\" />"+
         "       </head>"+
         " </table>";

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
String titlename = SystemEnv.getHtmlLabelName(33387,user.getLanguage());//集成

%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onSubmit()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/integration/hrsettingfield.jsp" method=post>
<input type="hidden" id="datasourceid" name="datasourceid" value="<%=datasourceid%>">
<input type="hidden" id="dmltablename" name="dmltablename" value="<%=dmltablename%>">
<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
	<wea:group context="<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>">
		<wea:item><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></wea:item>
		<wea:item><input name=fielddes class="InputStyle" id="search" value="<%=fielddes%>"></wea:item>
	</wea:group>
	<wea:group context="<%=SystemEnv.getHtmlLabelName(82104,user.getLanguage())%>"  attributes='{\"groupDisplay\":\"none\"}'>
		<wea:item attributes="{'isTableList':'true'}">
		<% if (type == 3 ){ %>
			<TABLE ID=BrowseTable class="ListStyle" cellspacing="0" style="width: 100%">
			<TR class=header>
			<TH width=50%><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></TH>
			<TH width=50%><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></TH>
			</TR>
			<%
			for (Map map:data){
					boolean isright = true;
					String fielddesc = Util.null2String(map.get("fielddesc"));
					String fieldname = Util.null2String(map.get("fieldname"));
					String fielddbtype =Util.null2String(map.get("fielddbtype"));
					fieldname = (fieldname.indexOf(" ")>0)?"["+fieldname+"]":fieldname;
					if(StringUtils.isNotBlank(fielddes) && fielddesc.indexOf(fielddes)<0) continue;
			%>
				<tr height="20px" class=<%if(isright){ %>DataLight<%}else{%>DataDark<%} %>>
					<td style="display:none"><input type="checkbox" value='<%=fielddesc %>'/></td>
					<td><%=fielddesc %></td>
					<td style="display:none"><%=fieldname %></td>
					<td><%=SystemEnv.getHtmlLabelNames(fielddbtype,user.getLanguage())%></td>
				</tr>
			<%
					isright = isright?false:true;
				}
			%>
			</TABLE>
		<% }else{ %>
			<input type="hidden" name="pageId" id="pageId" value="<%=PageConstId %>"/>
           	<wea:SplitPageTag  tableString="<%=tableString%>" isShowTopInfo="true" mode="run" />
		<%} %>	
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
		parent.setTabObjName("<%=(SystemEnv.getHtmlLabelName(shownameid,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(endshownameid,user.getLanguage()))%>");
	}catch(e){
		if(window.console)console.log(e);
	}
var parentWin1 = null;
var dialog1 = null;
try{
	parentWin1 = parent.parent.getParentWindow(parent);
	dialog1 = parent.parent.getDialog(parent);
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
	if(dialog1){
	    dialog1.callback(returnjson);
	}else{ 
	    window.parent.close() ;
	 } 
}
function closeDialog(){
	if(dialog1)
	{
		dialog1.close();
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
      	if(dialog1){
	    	dialog1.callback({id:jQuery(curTr.cells[0]).find("input").val(),name:jQuery(curTr.cells[0]).find("input").val(),type:jQuery(curTr.cells[1]).text(),a1:jQuery(curTr.cells[2]).text()});
		}else{ 
		    window.parent.returnValue  = {id:jQuery(curTr.cells[0]).find("input").val(),name:jQuery(curTr.cells[0]).find("input").val(),type:jQuery(curTr.cells[1]).text(),a1:jQuery(curTr.cells[2]).text()};
		    window.parent.close();
		}
	}
}

function btnclear_onclick(){
	//window.parent.returnValue ={id:"",name:"",a1:""};
	//window.parent.close();
	if(dialog1){
	    dialog1.callback({id:"",name:"",type:"",a1:""});
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
	$('#search').bind('keypress', function (event){
            if (event.keyCode == "13") {
            	onSubmit();
            }
        });
});
function afterDoWhenLoaded(){
	jQuery("#_xTable div[class=table] table[class=ListStyle]").click(BrowseTable_onclick);
}
jQuery(function(){
	jQuery("#BrowseTable").mouseover(BrowseTable_onmouseover);
	jQuery("#BrowseTable").mouseout(BrowseTable_onmouseout);
	jQuery("#BrowseTable").click(BrowseTable_onclick);
	//$("#btncancel").click(btncancel_onclick);
	//$("#btnsub").click(btnsub_onclick);
	
	jQuery("#btnclear").click(btnclear_onclick);
	
});

</script>