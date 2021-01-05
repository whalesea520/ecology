<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.Prop,
				weaver.general.GCONST" %>
<!-- added by wcd 2014-07-08 -->
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>   
<%@page import="org.apache.commons.lang.StringUtils"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="adci" class="weaver.hrm.appdetach.AppDetachComInfo" scope="page" />
<jsp:useBean id="FnaCommon" class="weaver.fna.general.FnaCommon" scope="page" />
<jsp:useBean id="FnaCostCenter" class="weaver.fna.maintenance.FnaCostCenter" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<% 
String tabid = Util.null2String(request.getParameter("tabid"));
if(tabid.equals("")) tabid="0";

int uid=user.getUID();
//System.out.println("departmentid"+departmentid);
//System.out.println("tabid"+tabid);

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
//  String lastname = Util.toScreenToEdit(request.getParameter("searchid"),user.getLanguage(),"0");


String fccname = Util.null2String(request.getParameter("fccname"));
String fcccode = Util.null2String(request.getParameter("fcccode"));
String workflowid = Util.null2String(request.getParameter("workflowid"));
String fieldid = Util.null2String(request.getParameter("fieldid"));
String selectedid = Util.null2String(request.getParameter("selectedid"));
String fcctype = Util.null2String(request.getParameter("fcctype"));


String search = Util.null2String(request.getParameter("search"));
boolean isInit = Util.null2String(request.getParameter("isinit")).equals("");//是否点击过搜索
int fccGroupId = Util.getIntValue(request.getParameter("fccGroupId"), -1);

int perpage=6;

//获取所有浏览数据定义的成本中心id
//(fccArray0：存储成本中心类别;fccArray1：存储成本中心)
List fccArray = FnaCommon.getWfBrowdefList(workflowid, fieldid, "251");
Set fccArray0 = new HashSet();
Set fccArray1 = new HashSet();
try{
	//查找上下级所有的成本中心、成本中心类别
	if(fccArray!=null && fccArray.size()>0) {
		FnaCostCenter.getAllSubCostcenterType(fccArray, fccArray0, fccArray1);
	}
}catch(Exception e) {
	RecordSet.writeLog(e);
}


String backfields = " a.id,a.name,a.code ";
String fromSql  = " FnaCostCenter a";

String sqlwhere = " where "+FnaCostCenter.getDbUserName()+"getFccArchive1(a.id) = 0 and a.type = 0 ";
if(fccGroupId > -1) {
	sqlwhere += " and a.supFccId = "+fccGroupId+" ";
}
if(!"".equals(fccname)) {
	sqlwhere += " and a.name like '%"+StringEscapeUtils.escapeSql(fccname)+"%' ";
}
if(!"".equals(fcccode)) {
	sqlwhere += " and a.code like '%"+StringEscapeUtils.escapeSql(fcccode)+"%' ";
}

if("0".equals(fcctype) && !"".equals(selectedid)){
	sqlwhere += " and a.id not in ("+selectedid+")";
}

String supClause = "";
if(fccArray0 != null && fccArray0.size() > 0) {
	String ids = "0";
	for(Object obj : fccArray0) {
		ids += ","+(String)obj;
	}
	/* if(!ids.equals("")) {
		ids = ids.substring(1);
	} */
	supClause = " a.supFccId in ("+ids+") ";
	
}
String subClause = "";
if(fccArray1 != null && fccArray1.size() > 0) {
	String ids = "";
	for(Object obj : fccArray1) {
		ids += ","+(String)obj;
	}
	if(!ids.equals("")) {
		ids = ids.substring(1);
	}
	subClause = " a.id in ("+ids+") ";
}

sqlwhere += (!supClause.equals("")) ? " and "+supClause : "";
sqlwhere += (!subClause.equals("")) ? " and "+subClause : "";

String orderby =" a.code,a.name ";

//out.println("sql:\n select "+backfields+" from "+fromSql+" "+sqlwhere+" order by "+orderby);
String tableString =   " <table instanceid=\"FccBrowserList\" id=\"FccBrowserList\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
                "       <sql backfields=\""+Util.toHtmlForSplitPage(backfields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" "+
						" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\""+Util.toHtmlForSplitPage(orderby)+"\" "+
                		" sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"0%\" text=\"ID\" column=\"id\" "+
							" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getIptHidden2\" otherpara=\"column:id+id\" />"+
				"           <col width=\"50%\" text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" "+
							" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getIptHidden1\" otherpara=\"column:id+name\" />"+
				"           <col width=\"50%\" text=\""+SystemEnv.getHtmlLabelName(1321,user.getLanguage())+"\" column=\"code\" orderkey=\"code\" "+
	     				" transmethod=\"weaver.fna.general.FnaCommon.escapeHtml\" />"+
                "       </head>"+
                " </table>";
%>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
<script type="text/javascript">
	var dialog = null;
	try{
		dialog = parent.parent.parent.getDialog(parent.parent);
	}
	catch(e){}
</script>
</HEAD>
<BODY>
<%//@ include file="/systeminfo/RightClickMenuConent.jsp" %>	
<%//@ include file="/systeminfo/RightClickMenu.jsp" %>
<div class="zDialog_div_content">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" class="e8_btn_top" onclick="btnsub_onclick();" id="btnsub" <%if(!tabid.equals("2")){%>style="display:none"<%}%> value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>">
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
		<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/> 

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="">
		<wea:item type="toolbar">
			<input type="button" class="zd_btn_submit" onclick="btnclear_onclick();" id="btnclear" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>">
      		<input type="button" class="zd_btn_cancle" onclick="btncancel_onclick();" id="btncancel" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>">
		</wea:item>
	</wea:group>
</wea:layout>
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
</script>
</div>

<script language="javascript">
function btnclear_onclick(){
  var returnjson = {id:"",name:""};
	if(dialog){
		try{
          dialog.callback(returnjson);
     }catch(e){}

		try{
		     dialog.close(returnjson);
		 }catch(e){}
	}else{
		window.parent.parent.returnValue = returnjson;
  	window.parent.parent.close();
	}
}

function btnsub_onclick(){
     window.parent.frame1.document.SearchForm.btnsub.click();
}

function btncancel_onclick(){
	if(dialog){
		dialog.close();
	}else{
  	window.parent.parent.close();
	}
}

function replaceToHtml(str){
	str = str._fnaReplaceAll("&","&amp;")
		._fnaReplaceAll('"',"&quot;")
		._fnaReplaceAll("'","&apos;")
		._fnaReplaceAll("<","&lt;")
		._fnaReplaceAll(">","&gt;")
		._fnaReplaceAll(",","，");
	return str;
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

function BrowseTable_onclick(e){
	var e=e||event;
	var target=e.srcElement||e.target;
	if(target.nodeName =="TD"||target.nodeName =="A"  ){
		var curTr=jQuery(target).parents("tr")[0];
		var returnjson = {
    		id:jQuery(curTr.cells[0]).text(),
    		name:replaceToHtml(jQuery(curTr.cells[1]).text()),
    		a1:jQuery(curTr.cells[3]).text(),
    		a2:jQuery(curTr.cells[4]).text()};	 
		if(dialog){
			try{
				dialog.callback(returnjson);
			}catch(e){}

			try{
				dialog.close(returnjson);
			}catch(e){}
		}else{
			window.parent.parent.returnValue = returnjson;
			window.parent.parent.close();
	 	}
	}
}

function afterDoWhenLoaded(){
	$("#_xTable").find("table.ListStyle tbody").children("tr[class!='Spacing']").each(function(){
		var tr = jQuery(this);
		tr.bind("click",function(){
			var id = tr.children("td:first").next().children().val();
			var name = tr.children("td:first").next().next().children().val();
			var returnjson = {"id":id,"name":replaceToHtml(name)};	 
			if(dialog){
				try{
					dialog.callback(returnjson);
				}catch(e){}
				try{
					dialog.close(returnjson);
				}catch(e){}
			}else{
		    	window.parent.parent.returnValue = returnjson;
		    	window.parent.parent.close();
			}
		});
	});
}
</script>
</BODY>
</HTML>
