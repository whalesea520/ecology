<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.systemright.CheckSubCompanyRight" %>
<%@ page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ page import="weaver.workflow.form.FormManager"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="com.weaver.formmodel.util.NumberHelper"%>
<%@page import="com.weaver.formmodel.util.DateHelper"%>
<%@page import="weaver.formmode.tree.CustomTreeData"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />


<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />

<HTML><HEAD>
<%
int pageNo = 1;
int pageSize = 12;
String showname = Util.null2String(request.getParameter("showname"));
int treeid = Util.getIntValue(Util.null2String(request.getParameter("treeid")));
String titlename = SystemEnv.getHtmlLabelName(18412,user.getLanguage());
%>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
</HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_top} " ;//搜索
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(82176,user.getLanguage())+",javascript:searchReset(),_top} " ;//清空条件
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;//清除
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onCancel(),_top} " ;//取消
RCMenuHeight += RCMenuHeightStep ;

%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" id="btnsearch1" class="e8_btn_top" onclick="javascript:submitData()" ><!-- 搜索 -->
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>

<FORM NAME=SearchForm action="/formmode/tree/treebrowser/TreeSingleBrowser.jsp" method=post>
<input type="hidden" name="treeid" id="treeid" value="<%=treeid %>">
<table  width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td ></td>
	<td valign="top">
	  <TABLE class=Shadow>
		<tr>
		  <td valign="top">
			 <table class="e8_tblForm" style="margin: 10px 0;">
			   <TR>
				 <TD width="20%" class="e8_tblForm_label"><!-- 显示名称 -->
				   <%=SystemEnv.getHtmlLabelName(30828,user.getLanguage())%>
				 </TD>
				 <TD width="50%" class="e8_tblForm_field"><input id="showname" name="showname"  value="<%=showname %>" class="InputStyle"></TD>
			    </TR>
			  </table>
			  <%
			  String sql = "select * from mode_customtreedetail where mainid="+treeid+" order by showorder";
			  rs.executeSql(sql);
			  List<Map<String,String>> treeNodeList = new ArrayList<Map<String,String>>();
			  CustomTreeData customTreeData = new CustomTreeData();
			  
			  String sqls = "";
			  String vdatasource = "";
			  String dbtypeStr = "";
			  RecordSet rs1 = new RecordSet();
			  
			  //先计算数据源
			  while(rs.next()){
				  String id = rs.getString("id");
				  String tablename = rs.getString("tablename");
				  String vdatasourceTemp = customTreeData.getVdatasourceByNodeId(id);
				  if(vdatasourceTemp.equals("")){
				  	  dbtypeStr = rs1.getDBType();
				  }else{
					  vdatasource = vdatasourceTemp;
					  dbtypeStr = rs1.getDBTypeByPoolName(vdatasource);
					  break;
				  }
			  }
			  
			  String connStr = "";
			  if(dbtypeStr.equalsIgnoreCase("sqlserver")){
				  connStr = "+";
			  }else{
				  connStr = "||";
			  }
			  
			  rs.beforFirst();
			  while(rs.next()){
				  String tablekey = rs.getString("tablekey");
				  String showfield = rs.getString("showfield");
				  String tablename = rs.getString("tablename");
				  String id = rs.getString("id");
				  String nodename = rs.getString("nodename");
				  String datacondition = rs.getString("datacondition");
				  String tempkey = tablekey;
				  
				  
				  if(dbtypeStr.equalsIgnoreCase("sqlserver")){
					  tempkey = "convert(varchar(4000),"+tablekey+")";
				  }
				  
				  String nodeSql = "select '"+id+"_'"+connStr+tempkey+" as id,"+tablekey+" as objid,"+showfield+" as showname,'"+nodename+"' as nodename, '"+id+"' as nodeid from "+tablename;
				  if(!StringHelper.isEmpty(datacondition)){
					  datacondition = customTreeData.replaceParam(datacondition);
					  nodeSql += " where 1=1 and ("+datacondition+")";
				  }
				  if(sqls.equals("")){
					  sqls +=  nodeSql;
				  }else{
					  sqls += " union all "+nodeSql;
				  }
			  }
			  String perpage = "10";
			  
			  String backFields = " a.id,a.showname,a.nodename,a.nodeid ";
			  String sqlFrom = " from ("+sqls+") a " ;
              String SqlWhere = " where 1=1 ";
              if(!showname.equals("")){
            	  SqlWhere += " and a.showname like '%"+showname+"%'";
              }
              
		  	 String tableString=""+
				"<table pagesize=\""+perpage+"\" tabletype=\"none\">"+
					"<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlprimarykey=\"a.id\" poolname=\""+vdatasource+"\" sqlsortway=\"desc\" sqldistinct=\"true\" sqlorderby=\"nodeid asc,objid asc\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
						"<head>"+            //自定义浏览框名称 
							"<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(30828,user.getLanguage())+"\" column=\"showname\" orderkey=\"showname\"   />"+
							//"<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(15070,user.getLanguage())+"\" column=\"nodename\" orderkey=\"nodename\"   />"+
						"</head>"+
				"</table>";
			
			  %>
			  <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" isShowTopInfo="true"/>
			</td>
		  </tr>
		</TABLE>
	 </td>
	 <td></td>
  </tr>
</table>
</FORM>
</BODY></HTML>

<script type="text/javascript">
var dialog;
var parentWin;
try{
	parentWin = window.parent.parent.parent.getParentWindow(parent);
	dialog = window.parent.parent.parent.getDialog(parent);
	if(!dialog){
		parentWin = parent.parentWin;
		dialog = parent.dialog;
	}
}catch(e){
	
}

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
		window.parent.parent.parent.returnValue=returnjson;
		window.parent.parent.parent.close();
	}
}

function onCancel(){
	if(dialog){
		 try{
		     dialog.close();
		 }catch(e){}
	}else{  
		window.parent.parent.parent.close();
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
	$(".loading", window.document).hide();
	$("#_xTable").bind("click",BrowseTable_onclick);
	$("#showname").bind('keydown',function(event){
		if(event.keyCode == 13){    
			submitData();
		}
	});
})


function BrowseTable_onclick(e){
	var e=e||event;
	var target=e.srcElement||e.target;

	if( target.nodeName =="TD"||target.nodeName =="A"  ){
		var tr ;
		if(target.nodeName=="TD"){
			tr = jQuery(target).parent();
		}else if(target.nodeName =="A" ){
			tr = jQuery(target).parent().parent();
		}
		var idValue = tr.find("input[type='checkbox']").val();
		var isvirtualform = 0;
		var vstr = tr.find("td:last").html();
		if(vstr=="<%=SystemEnv.getHtmlLabelName(33885,user.getLanguage())%>"){//虚拟表单
			isvirtualform = 1;
		}
   	 	var nameValue = ""+
   	 				 jQuery(jQuery(target).parents("tr")[0].cells[1]).text();
   	 	if(dialog){
			nameValue ="<a target='_blank' href='/formmode/search/CustomSearchOpenTree.jsp?pid="+idValue+"' title='"+nameValue+"'>"+ nameValue+"</a>";
   	 	}
		var returnjson = {id:idValue,name:nameValue};
		if(dialog){
	    	 try{
			     dialog.callback(returnjson);
			 }catch(e){}
			 
			 try{
			     dialog.close(returnjson);
			 }catch(e){}
		}else{
	    	window.parent.parent.parent.returnValue=returnjson;
		window.parent.parent.parent.close();
		}
	}
}
function submitData(){
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
	SearchForm.showname.value='';
}
</script>
