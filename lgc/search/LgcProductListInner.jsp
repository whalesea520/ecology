
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="LgcAssortmentComInfo" class="weaver.lgc.maintenance.LgcAssortmentComInfo" scope="page"/>
<%
	String assortmenttype = Util.null2String(request.getParameter("assortmenttype"));
	String assortmentid = Util.null2String(request.getParameter("assortmentid"));
	String productName = Util.null2String(request.getParameter("productName"));
	String wherestr = "";
	
	if(!"".equals(productName)){
		wherestr += " and t2.assetname like '%"+productName+"%' ";
	}
	
	if(!assortmentid.equals(""))
	{
		assortmenttype = Util.toScreen(LgcAssortmentComInfo.getAssortmentFullName(assortmentid),user.getLanguage());
		RecordSet rs1 = new RecordSet();
		String childsmentid = "";
		rs1.execute(" select id from LgcAssetAssortment where supassortmentstr like '%|"+assortmentid+"|%' ");
		while(rs1.next())
		{
			childsmentid += "," + rs1.getString(1) ;
		}
		if(childsmentid.length() > 0)
			childsmentid = childsmentid.substring(1);
		else
			childsmentid = assortmentid;
		
		wherestr += " and t1.assortmentid in ("+childsmentid + ") ";
	}
	else
		assortmenttype = SystemEnv.getHtmlLabelName(332,user.getLanguage());
	
	String sqlexport ="select t2.assetid,t2.assetname,t1.assetunitid,t2.currencyid,t2.salesprice,t1.assortmentid,t1.assortmentstr from LgcAsset t1,LgcAssetCountry t2 where t1.id=t2.assetid "+wherestr+" order by t1.assortmentstr desc, t2.assetname desc"; 
	
	session.setAttribute("psqlexport",sqlexport);
	
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript">
//搜索采用固定列的查找方式，列不能变化，如变化，需要修改此搜索高亮逻辑
//add by Dracula @2014-1-28
function searchTitle()
{
	
}
function refreshTreeNum(ids,isadd)
{	
	parent.refreshTreeNum(ids,isadd);
}
var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

//新建、编辑客户状况 add by Dracula @2014-1-28
function openDialog(id,type){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "";
	if(!!!type)
		url = "/lgc/asset/LgcAssetAdd.jsp?paraid=<%=assortmentid%>&assortmenttype=<%=assortmenttype%>";
	else
		url = "/lgc/asset/LgcAssetAdd.jsp?paraid="+type;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(27111 ,user.getLanguage()) %>";
	if(!!id){//编辑
		url = "/lgc/asset/LgcAssetEdit.jsp?paraid="+id;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(93 ,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(15115 ,user.getLanguage()) %>";
	}
	dialog.Width = 420;
	dialog.Height = 380;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

//编辑 add by Dracula @2014-1-28
function doEdit(id)
{
	openDialog(id);
}

function doNewSameProduct(id,popedomtypepara)
{
	openDialog(null,popedomtypepara);
}
//删除 add by Dracula @2014-1-28
function doDel(id,assortmentstr)
{
	if(isdel()){
		location.href="/lgc/asset/LgcAssetOperation.jsp?operation=deleteasset&assetid="+id+"&assortmentid=<%=assortmentid%>";
		refreshTreeNum(assortmentstr,false);
	}
}

//日志 add by Dracula @2014-1-28
function doLog(id)
{
	openLogDialog(id)
}

    
    //批量删除
    function delMutli()
    {
    	var id = _xtable_CheckedCheckboxId();
    	if(!id){
			window.top.Dialog.alert("请选择要删除的记录!");
			return;
		}
		if(id.match(/,$/)){
			id = id.substring(0,id.length-1);
		}
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
			var idArr = id.split(",");
			for(var i=0;i<idArr.length;i++){
				jQuery.ajax({
					url:"/lgc/asset/LgcAssetOperation.jsp?operation=deleteasset&assetid="+idArr[i]+"&assortmentid=<%=assortmentid%>&ajax=1",
					type:"post",
					async:true,
					complete:function(xhr,status){
						if(i==idArr.length-1){
							_table.reLoad();
						}
						refreshTreeNum(xhr.responseText,false);
					}
				});
			}
		});
		
    }
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(602,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:searchName(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>


<table id="topTitle" cellpadding="0" cellspacing="0" >
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan">
			<%
				if(HrmUserVarify.checkUserRight("CrmProduct:Add",user)) {
					if(!assortmentid.equals(""))
					{
						RecordSet rs1 = new RecordSet();
						rs1.executeSql("select count(t1.supassortmentid) as s from LgcAssetAssortment t1 where t1.supassortmentid ="+assortmentid);
						rs1.first();
						if(rs1.getInt(1) > 0 );
						else{
							RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog(),''} " ;
						    RCMenuHeight += RCMenuHeightStep ;	
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(27111, user.getLanguage()) %>" class="e8_btn_top"  onclick="openDialog()"/>&nbsp;&nbsp;
			<%}}} 
				RCMenu += "{"+"Excel,javascript:ContractExport(),_top} " ;
				RCMenuHeight += RCMenuHeightStep;
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(23777, user.getLanguage()) %>" class="e8_btn_top" onclick="delMutli()"/>&nbsp;&nbsp;
			<input type="text" class="searchInput" value="<%=productName %>" id="searchName" name="searchName"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 

<form action="LgcProductListInner.jsp" method="post" name="weaver">
	<input type="hidden" name="assortmenttype" value="<%=assortmenttype %>">
	<input type="hidden" name="assortmentid" value="<%=assortmentid %>">
	<input type="hidden" name="productName" value="<%=productName %>">
</form>

<%
	//原始页面未采用分页控件，现在改成分页控件 add by Dracula @2014-1-23
	String otherpara = "column:assetid";
	String tableString = "";
	String backfields = " t2.assetid,t2.assetname,t1.assetunitid,t2.currencyid,t2.salesprice,t1.assortmentid,t1.assortmentstr ";
	String fromSql = " LgcAsset t1,LgcAssetCountry t2 ";
	String orderkey = " t2.assetid ";
	String sqlWhere = " t1.id=t2.assetid ";
	sqlWhere = sqlWhere + wherestr;
	String popedomUserpara = String.valueOf(user.getUID());
	String checkpara = "column:assetid+"+popedomUserpara;
	String operateString = " ";
	String popedomtypepara = "column:assortmentid";
	String popedomtype1para = "column:assortmentstr";
	operateString = " <operates>";
	operateString +=" <popedom transmethod=\"weaver.crm.Maint.CRMTransMethod.getCRMProductListOperation\"  otherpara=\""+popedomUserpara+"\" ></popedom> ";
	operateString +="     <operate href=\"javascript:doEdit();\" text=\"" + SystemEnv.getHtmlLabelName(93, user.getLanguage()) + "\"  index=\"0\"/>";
	operateString +="     <operate href=\"javascript:doNewSameProduct();\" text=\"" + SystemEnv.getHtmlLabelName(32637, user.getLanguage()) + "\" otherpara=\""+popedomtypepara+"\" index=\"1\"/>";
	operateString +="     <operate href=\"javascript:doDel();\" text=\"" + SystemEnv.getHtmlLabelName(23777, user.getLanguage()) + "\" otherpara=\""+popedomtype1para+"\" index=\"2\"/>";
      		operateString +=" </operates>";
	tableString = " <table instanceid=\"MaintContacterTitleListTable\"  tabletype=\"checkbox\" pagesize=\"10\" >"
		+ " <checkboxpopedom  id=\"checkbox\"  popedompara=\""+checkpara+"\" showmethod=\"weaver.crm.Maint.CRMTransMethod.getCRMProductResultCheckbox\" />"
	+ "	<sql backfields=\"" + backfields 
	+ "\" sqlform=\"" + fromSql 
	+ "\" sqlwhere=\"" + Util.toHtmlForSplitPage(sqlWhere) 
	+ "\"  sqlorderby=\"" + orderkey
	+ "\"  sqlprimarykey=\"t2.assetid\" sqlsortway=\"desc\" sqlisdistinct=\"true\" />" ;
	
	tableString +=  operateString;
	tableString += " <head>"; 
	tableString += " <col width=\"20%\"  pageId=\""+PageIdConst.CRM_ProductList+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_ProductList,user.getUID(),PageIdConst.CRM)+"\" text=\"" + SystemEnv.getHtmlLabelName(15129,user.getLanguage())
	+ "\" column=\"assetname\" orderkey=\"t2.assetname\"  linkkey=\"t2.assetid\" linkvaluecolumn=\"t2.assetid\" transmethod=\"weaver.crm.Maint.CRMTransMethod.getCRMContacterLinkWithTitle\" otherpara=\""
	+ otherpara + "\" />";
	tableString += " <col width=\"10%\"  text=\"" + SystemEnv.getHtmlLabelName(705,user.getLanguage())
	+ "\" column=\"assetunitid\" orderkey=\"t1.assetunitid\" transmethod =\"weaver.lgc.maintenance.AssetUnitComInfo.getAssetUnitname\" />";
	tableString += " <col width=\"30%\"  text=\"" + SystemEnv.getHtmlLabelName(178,user.getLanguage())
	+ "\" column=\"assortmentid\" orderkey=\"t1.assortmentid\" transmethod =\"weaver.lgc.maintenance.LgcAssortmentComInfo.getAssortmentFullName\"/>";
	tableString += " <col width=\"20%\"  text=\"" + SystemEnv.getHtmlLabelName(17039,user.getLanguage())
	+ "\" column=\"currencyid\" orderkey=\"t2.currencyid\" transmethod =\"weaver.fna.maintenance.CurrencyComInfo.getCurrencyname1\" otherpara=\"column:salesprice\"/>";
	
	tableString += " </head>" + "</table>";
%>
	<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.CRM_ProductList%>">
	<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
								
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<iframe id="searchexport" style="display:none"></iframe>
<script language=javascript>
function ContractExport(){
     $("#searchexport").attr("src","LgcSearchProductExport.jsp");
}

$(document).ready(function(){
			
	jQuery("#topTitle").topMenuTitle({searchFn:searchName});
	jQuery("#hoverBtnSpan").hoverBtn();
				
});

function searchName(){
	
	var searchName = jQuery("#searchName").val();
	jQuery("input[name='productName']").val(searchName);
	window.weaver.submit();
	
}
</script>
</BODY>
</HTML>
