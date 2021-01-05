
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="LgcAssortmentComInfo" class="weaver.lgc.maintenance.LgcAssortmentComInfo" scope="page"/>
<%
	String assortmenttype = Util.null2String(request.getParameter("assortmenttype"));
	String assortmentid = Util.null2String(request.getParameter("assortmentid"));
	
	String wherestr = "";
	if(!assortmentid.equals(""))
	{
		assortmenttype = Util.toScreen(LgcAssortmentComInfo.getAssortmentFullName(assortmentid),user.getLanguage());
		wherestr = " and t1.supassortmentid = "+assortmentid + " ";
	}
	else
	{
		assortmenttype = SystemEnv.getHtmlLabelName(332,user.getLanguage());
		wherestr = " and t1.supassortmentid=0 or t1.supassortmentid is null";
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/xtree_wev8.js"></script>
    <script type="text/javascript" src="/js/xloadtree_wev8.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$("#topTitle").topMenuTitle({searchFn:searchTitle});
	
});

function refreshTreeMain(id,parentId,needRefresh){
	parent.refreshTreeMain(id,parentId,needRefresh);
}

//搜索采用固定列的查找方式，列不能变化，如变化，需要修改此搜索高亮逻辑
//add by Dracula @2014-1-28
function searchTitle()
{
	
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

//新建、编辑客户状况 add by Dracula @2014-1-28
function openDialog(id,parentid,iself){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/lgc/maintenance/LgcAssortmentAdd.jsp";
	if(!!iself)
		url = url + "?iself="+iself;
	if(!!parentid)
	{
		url = "/lgc/maintenance/LgcAssortmentAdd.jsp?paraid="+parentid;
		if(!!iself)
			url = url + "&iself="+iself;
	}
	
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(82 ,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(178 ,user.getLanguage()) %>";
	dialog.Width = 420;
	dialog.Height = 300;
	
	if(!!id){//编辑
		url = "/lgc/maintenance/LgcAssortmentEdit.jsp?paraid="+id;
		if(!!iself)
		{
			url = "/lgc/maintenance/LgcAssortmentEdit.jsp?paraid="+id+"&iself="+iself;
		}
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(93 ,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(178 ,user.getLanguage()) %>";
		dialog.Height = 350;
	}
	
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

//编辑 add by Dracula @2014-1-28
function doEdit(id,iself)
{
	if(!!iself)
		openDialog(id,null,iself);
	else
		openDialog(id);
}
function openChildDialog()
{
	openDialog(null,"<%=assortmentid %>");
}

function doNewSameProduct(id,popedomtypepara)
{
	openDialog(null,popedomtypepara);
}
//删除 add by Dracula @2014-1-28
function doDel(id,fullname)
{
	if(isdel())
	{
		<%if(assortmentid.equals("")){%>
		location.href="/lgc/maintenance/LgcAssortmentOperation.jsp?operation=deleteassortment&assortmentid="+id;
		<%}else{%>
		location.href="/lgc/maintenance/LgcAssortmentOperation.jsp?operation=deleteassortment&assortmentid="+id+"&supassortmentid=<%=assortmentid %>";
		<%}%>
		refreshTreeMain(0,0,true);
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
		var urlstr = "";
		<%if(assortmentid.equals("")){%>
		urlstr="/lgc/maintenance/LgcAssortmentOperation.jsp?operation=deleteassortment&assortmentid=";
		<%}else{%>
		urlstr="/lgc/maintenance/LgcAssortmentOperation.jsp?operation=deleteassortment&supassortmentid=<%=assortmentid %>&assortmentid=";
		<%}%>
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
			var idArr = id.split(",");
			for(var i=0;i<idArr.length;i++){
				jQuery.ajax({
					url:urlstr+idArr[i],
					type:"post",
					async:true,
					complete:function(xhr,status){
							_table.reLoad();
							refreshTreeMain(0,0,true);
					}
				});
			}
		});
		
    }
    
    function initImg(img,w,h){
		var getResize=function(width,height,SCALE_WIDTH,SCALE_HEIGHT){
			var sizes=new Array(2);
			var rate=0;
			if(width<=SCALE_WIDTH && height<=SCALE_HEIGHT){
				sizes[0]=width;
				sizes[1]=height;
				return sizes;
			}
				
			if(width>=height){
				rate=height/width;
				sizes[0]=SCALE_WIDTH;
				sizes[1]=Math.ceil(SCALE_WIDTH*rate);
			}else{//height>width.
				rate=width/height;
				sizes[0]=Math.ceil(SCALE_HEIGHT*rate);
				sizes[1]=SCALE_HEIGHT;
			}
			return sizes;
		}
		var srcImg=new Image();
		srcImg.src=img.src;
		var size=getResize(parseInt(srcImg.width),parseInt(srcImg.height),w,h);
		img.width=size[0];
		img.height=size[1];
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


<table id="topTitle" cellpadding="0" cellspacing="0" >
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan">
		
			<%
				if(HrmUserVarify.checkUserRight("CrmProduct:Add", user)){
				if(!assortmentid.equals("")){ 
				
					RCMenu += "{"+SystemEnv.getHtmlLabelName(93, user.getLanguage())+SystemEnv.getHtmlLabelName(178, user.getLanguage())+",javascript:doEdit("+assortmentid+",1),''} " ;
					RCMenuHeight += RCMenuHeightStep ;
			%>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(93, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(178, user.getLanguage()) %>" class="e8_btn_top"  onclick="doEdit(<%=assortmentid %>,1)"/>&nbsp;&nbsp;
			<%}else{ 
					RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(178, user.getLanguage())+",javascript:openDialog(null,null,1),''} " ;
					RCMenuHeight += RCMenuHeightStep ;
			%>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(82, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(178, user.getLanguage()) %>" class="e8_btn_top"  onclick="openDialog(null,null,1)"/>&nbsp;&nbsp;
			<%}%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(23777, user.getLanguage()) %>" class="e8_btn_top" onclick="delMutli()"/>&nbsp;&nbsp;
			<%} %>
			<!-- <input type="button" value="刷新树" class="e8_btn_top" onclick="refreshTreeMain(11,6,true)"/>&nbsp;&nbsp;
			<input type="text" class="searchInput" value="" name="customerStatus"/>&nbsp;&nbsp; -->
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
	int havaproduct = 0;
	if(!assortmentid.equals("")){ 
	RecordSet rs1 = new RecordSet();
	rs1.executeSql("select * from LgcAssetAssortment where id="+assortmentid);
	String assortmentname = "";
	String assortmentimageid = "";
	String assortmentremark = "";
	String supassortmentid = "";
	if(rs1.next())
	{
		assortmentname = rs1.getString("assortmentname");
		assortmentimageid = rs1.getString("assortmentimageid");
		assortmentremark = rs1.getString("assortmentremark");
		supassortmentid = rs1.getString("supassortmentid");
	}
%>
	<TABLE width="100%" cellspacing="0" cellpadding="0"  class=ViewForm>
		<COLGROUP>
			<COL width="10%">
	  		<COL width="40%">
	  		<COL width="10%">
	  		<COL width="40%">
		</COLGROUP>
		<tbody>
		<tr>
			<td>
				<%=SystemEnv.getHtmlLabelName(23051, user.getLanguage())%>
			</td>
			<td  class=Field>
				<%=assortmentname %>
			</td>
			<td>
				<%=SystemEnv.getHtmlLabelName(596,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(178,user.getLanguage()) %>
			</td>
			<td  class=Field>
				<%=Util.toScreen(LgcAssortmentComInfo.getAssortmentFullName(supassortmentid),user.getLanguage()) %>
			</td>
		</tr><tr  style="height: 1px"><td class=Line colspan=4></td></tr>
		<tr style="height:80px">
			<td>
				<%=SystemEnv.getHtmlLabelName(454,user.getLanguage()) %>
			</td>
			<td class=Field>
				<textArea rows=4 class=InputStyle style="WIDTH: 284px" readonly><%=assortmentremark %></textArea>
			</td>
			<td>
				<%=SystemEnv.getHtmlLabelName(74,user.getLanguage()) %>
			</td>
			<td class=Field>
				<% if(!assortmentimageid.equals("") && !assortmentimageid.equals("0")) {%>
            		<img onload="initImg(this,100,100)" border=0 src="/weaver/weaver.file.FileDownload?fileid=<%=assortmentimageid%>"> 
            	<%}%>
			</td>
		</tr><tr  style="height: 1px"><td class=Line colspan=4></td></tr>
		<%
		RecordSet rs2 = new RecordSet();
		rs2.executeSql(" select count(t2.assetid) as c from LgcAsset t1,LgcAssetCountry t2 where t1.id=t2.assetid and t1.assortmentid="+assortmentid);
		rs2.first();
		havaproduct = rs2.getInt(1);	
		if(!(havaproduct>0)){
		%>
		<tr>
			<td colspan=3 >
				<%=SystemEnv.getHtmlLabelName(32660, user.getLanguage())%>
			</td>
			<td>
				<div class="e8_add_del_btn">
					<%
											
						if(havaproduct>0);
						else{
					%>
					<input type="button" class="addbtn" title="<%= SystemEnv.getHtmlLabelName(82,user.getLanguage())%>" onclick="javascript:openChildDialog();"/>
					<%} %>
					<input type="button" class="delbtn" title="<%= SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>" onclick="javascript:delMutli();"/>
				</div>
			</td>
		</tr><tr  style="height: 1px"><td class=Line colspan=4></td></tr>
		<%} %>
		</tbody>
	</TABLE>
<%} if(!(havaproduct>0)){%>
<table width=100% border="0" cellspacing="0" cellpadding="0">
		
	<tr>
		<td valign="top">
			<TABLE class=Shadow>
				<tr>
					<td valign="top">
						<TABLE width="100%" cellspacing="0" cellpadding="0">
							<tr>
								<td valign="top" class="_xTableOuter">
								<%
									//原始页面未采用分页控件，现在改成分页控件 add by Dracula @2014-1-23
									String otherpara = "column:id+column:description";
									String tableString = "";
									String backfields = " t1.id,t1.assortmentname,t1.assortmentimageid,t1.assortmentremark,t1.supassortmentid,t1.supassortmentstr,t1.subassortmentcount,t1.assetcount ";
									String fromSql = " LgcAssetAssortment t1 ";
									String orderkey = " t1.id ";
									String sqlWhere = " 1=1 ";
									sqlWhere = sqlWhere + wherestr;
									String popedomUserpara = String.valueOf(user.getUID());
									String checkpara = "column:id+"+popedomUserpara;
									String operateString = " ";
									String popedomtypepara = "column:assortmentid";
									operateString = " <operates>";
									operateString +=" <popedom transmethod=\"weaver.crm.Maint.CRMTransMethod.getLgcAssortmentListOperation\"  otherpara=\""+popedomUserpara+"\" ></popedom> ";
									operateString +="     <operate href=\"javascript:doEdit();\" text=\"" + SystemEnv.getHtmlLabelName(93, user.getLanguage()) + "\"  index=\"0\"/>";
									operateString +="     <operate href=\"javascript:doDel();\" text=\"" + SystemEnv.getHtmlLabelName(23777, user.getLanguage()) + "\" otherpara=\""+popedomtypepara+"\" index=\"1\"/>";
					 	       		operateString +=" </operates>";
									tableString = " <table instanceid=\"MaintContacterTitleListTable\"  tabletype=\"checkbox\" pageId=\""+PageIdConst.CRM_ProductType+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_ProductType,user.getUID(),PageIdConst.CRM)+"\" >"
										+ " <checkboxpopedom  id=\"checkbox\"  popedompara=\""+checkpara+"\" showmethod=\"weaver.crm.Maint.CRMTransMethod.getLgcAssortmentResultCheckbox\" />"
									+ "	<sql backfields=\"" + backfields 
									+ "\" sqlform=\"" + fromSql 
									+ "\" sqlwhere=\"" + Util.toHtmlForSplitPage(sqlWhere) 
									+ "\"  sqlorderby=\"" + orderkey
									+ "\"  sqlprimarykey=\"t1.id\" sqlsortway=\"desc\" sqlisdistinct=\"false\" />" ;
									
									tableString +=  operateString;
									tableString += " <head>"; 
									tableString += " <col width=\"30%\"  text=\"" + SystemEnv.getHtmlLabelName(23051,user.getLanguage())
									+ "\" column=\"assortmentname\" orderkey=\"t1.assortmentname\"  linkkey=\"t1.id\" linkvaluecolumn=\"t1.id\" transmethod=\"weaver.crm.Maint.CRMTransMethod.getCRMContacterLinkWithTitle\" otherpara=\""
									+ otherpara + "\" />";
									tableString += " <col width=\"65%\"  text=\"" + SystemEnv.getHtmlLabelName(454,user.getLanguage())
									+ "\" column=\"assortmentremark\" orderkey=\"t1.assortmentremark\" />";
									
									tableString += " </head>" + "</table>";
								%>
									<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
									<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.CRM_ProductType%>">
								</td>
							</tr>
						</TABLE>
					</td>
				</tr>
			</TABLE>
		</td>
	</tr>
</table>
<%} %>
</BODY>

</HTML>
