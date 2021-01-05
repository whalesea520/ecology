
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$("#topTitle").topMenuTitle({searchFn:searchTitle});
	registerDragEvent();
});
//搜索采用固定列的查找方式，列不能变化，如变化，需要修改此搜索高亮逻辑
//add by Dracula @2014-1-26
function searchTitle()
{
	var value=$("input[name='customerSize']",parent.document).val();
	if(value.length > 0)
	{
		//还原第二列的值
		$(".ListStyle").find("tbody tr").children("td:nth-child(2)").each(function(){
			$(this).children("a").html($(this).attr("title"));
		});
		//还原第三列的值
		$(".ListStyle").find("tbody tr").children("td:nth-child(3)").each(function(){
			$(this).html($(this).attr("title"));
		});
		//搜索第二列的值
		$(".ListStyle").find("tbody tr").children("td:nth-child(2)").each(function(){
			$(this).children("a").html(eachColor($(this).children("a"),value));
		});
		//搜索第三列的值
		$(".ListStyle").find("tbody tr").children("td:nth-child(3)").each(function(){
			$(this).html(eachColor($(this),value));
		});
	}
}

function eachColor(p,t){
    var nt = '<label class="textHighLight">'+t+'</label>';
    var reg = RegExp(t,"g");
    return  p.text().replace(reg,nt);
}
var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

//新建、编辑客户规模 add by Dracula @2014-1-26
function openDialog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/CRM/Maint/AddCustomerSize.jsp";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(82 ,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(1285 ,user.getLanguage()) %>";
	if(!!id){//编辑
		url = "/CRM/Maint/EditCustomerSize.jsp?id="+id;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(93 ,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(1285 ,user.getLanguage()) %>";
	}
	dialog.Width = 420;
	dialog.Height = 220;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

//打开单条记录的日志
function openLogDialog(id)
{
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/systeminfo/SysMaintenanceLog.jsp?operateitem="+106;
	if(id!=0)
		url+="&relatedid="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(31709,user.getLanguage()) %>";
	dialog.Width = 600;
	dialog.Height =550;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

//编辑 add by Dracula @2014-1-26
function doEdit(id)
{
	openDialog(id);
}
//删除 add by Dracula @2014-1-26
function doDel(id,fullname)
{
	   //location.href="/CRM/Maint/CustomerSizeOperation.jsp?method=delete&id="+id+"&name="+fullname;
	   window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>",function(){
            jQuery.post("/CRM/Maint/CustomerSizeOperation.jsp?method=delete&id="+id+"&name="+fullname,function(msg){
                var isb=false;
                if(msg.indexOf("issuccess")>=0) {
                    isb=true;
                }
                if(jQuery.trim(msg) !=""&&!isb){
                    window.top.Dialog.alert(msg);
                }else{
                    location.reload();
                }
            });
        });
}

//日志 add by Dracula @2014-1-26
function doLog(id)
{
	openLogDialog(id)
}

function registerDragEvent(){
	 var fixHelper = function(e, ui) {
        ui.children().each(function() {  
            jQuery(this).width(jQuery(this).width());     //在拖动时，拖动行的cell（单元格）宽度会发生改变。在这里做了处理就没问题了  
            jQuery(this).height("40");						//在CSS中定义为40px,目前不能动态获取
        });  
        return ui;  
    }; 
     jQuery("#customSizeTable").find("table.ListStyle tbody").sortable({                //这里是talbe tbody，绑定 了sortable  
         helper: fixHelper,                  //调用fixHelper  
         axis:"y",  
         start:function(e, ui){
         	 ui.helper.addClass("moveMousePoint");
             ui.helper.addClass("e8_hover_tr")     //拖动时的行，要用ui.helper  
             if(ui.item.hasClass("notMove")){
             	e.stopPropagation();
             }
             $(".hoverDiv").css("display","none");
             return ui;  
         },  
         stop:function(e, ui){
             //ui.item.removeClass("ui-state-highlight"); //释放鼠标时，要用ui.item才是释放的行  
             jQuery(ui.item).hover(function(){
            	jQuery(this).addClass("e8_hover_tr");
            },function(){
            	jQuery(this).removeClass("e8_hover_tr");
            	
            });
            jQuery(ui.item).removeClass("moveMousePoint");
            sortOrderTitle();
            return ui;  
         }  
     });  
}
    //只有不分页才可以这样拖拉排序，因为要循环获取分页控件的checkboxid
    //add by Dracula @2014-1-26
    function sortOrderTitle()
    {
    	var _tableids = "";
    	$(".ListStyle").find("tbody tr").children("td:nth-child(1)").each(function(){
			if(typeof($(this).find("input[type=checkbox]").attr("checkboxid")) == "undefined")
    			_tableids += "_"+$(this).find("input[type=checkbox]").attr("id");
			else
				_tableids += "_"+$(this).find("input[type=checkbox]").attr("checkboxid");
		});
    	$.ajax({ 
	        type: "post",
	        url: "CustomerSizeOperation.jsp?method=sort&ids="+_tableids,
	        async:true,
	        success:function(data){
	        	//成功后不需要做操作
	        }
        });
    }
    
    //批量删除
    function delMutli()
    {
    	var id = _xtable_CheckedCheckboxId();
    	if(!id){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
			return;
		}
		if(id.match(/,$/)){
			id = id.substring(0,id.length-1);
		}
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
			var idArr = id.split(",");
			for(var i=0;i<idArr.length;i++){
				jQuery.post("/CRM/Maint/CustomerSizeOperation.jsp",{"method":"delete","id":idArr[i]},function(){
					_table.reLoad()
				});
			}
		});
		
    }
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(576,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("AddCustomerSize:add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog(),''} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if(HrmUserVarify.checkUserRight("CustomerSize:Log", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:openLogDialog(0),_self} " ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0" >
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan">
			<%if(HrmUserVarify.checkUserRight("AddCustomerSize:add", user)){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82, user.getLanguage()) %>" class="e8_btn_top"  onclick="openDialog()"/>&nbsp;&nbsp;
			<%}if(HrmUserVarify.checkUserRight("EditCustomerSize:Delete", user)){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(23777, user.getLanguage()) %>" class="e8_btn_top" onclick="delMutli()"/>&nbsp;&nbsp;
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0" id="customSizeTable">
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
									String backfields = " t1.id, t1.fullname, t1.description, t1.orderkey ";
									String fromSql = " from crm_customersize t1 ";
									String orderkey = " t1.orderkey ";
									String sqlWhere = " 1=1 ";
									String fullnamepara = "column:fullname";
									String popedomUserpara = String.valueOf(user.getUID());
									String checkpara = "column:id+"+popedomUserpara;
									String operateString = "";
									operateString = " <operates>";
									operateString +=" <popedom transmethod=\"weaver.crm.Maint.CRMTransMethod.getCRMCustomerSizeListOperation\"  otherpara=\""+popedomUserpara+"\" ></popedom> ";
									operateString +="     <operate href=\"javascript:doEdit();\" text=\"" + SystemEnv.getHtmlLabelName(93, user.getLanguage()) + "\"  index=\"0\"/>";
									operateString +="     <operate href=\"javascript:doDel();\" text=\"" + SystemEnv.getHtmlLabelName(23777, user.getLanguage()) + "\" otherpara=\""+fullnamepara+"\" index=\"1\"/>";
					 	       		operateString +="     <operate href=\"javascript:doLog();\" text=\"" + SystemEnv.getHtmlLabelName(83, user.getLanguage()) + "\"  index=\"2\"/>";
					 	       		operateString +=" </operates>";
									tableString = " <table instanceid=\"MaintContacterTitleListTable\"  tabletype=\"checkbox\" pageId=\""+PageIdConst.CRM_SizeSet+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_SizeSet,user.getUID(),PageIdConst.CRM)+"\" >"
									+ " <checkboxpopedom  id=\"checkbox\"  popedompara=\""+checkpara+"\" showmethod=\"weaver.crm.Maint.CRMTransMethod.getCRMCustomerSizeResultCheckbox\" />"
									+ "	<sql backfields=\"" + backfields 
									+ "\" sqlform=\"" + fromSql 
									+ "\" sqlwhere=\"" + Util.toHtmlForSplitPage(sqlWhere) 
									+ "\"  sqlorderby=\"" + orderkey
									+ "\"  sqlprimarykey=\"t1.id\" sqlsortway=\"asc\" sqlisdistinct=\"true\" />" ;
									
									tableString +=  operateString;
									tableString += " <head>"; 
									tableString += " <col width=\"25%\"  text=\"" + SystemEnv.getHtmlLabelName(576,user.getLanguage()) + SystemEnv.getHtmlLabelName(195,user.getLanguage())
									+ "\" column=\"fullname\" orderkey=\"t1.fullname\"  linkkey=\"t1.id\" linkvaluecolumn=\"t1.id\" transmethod=\"weaver.crm.Maint.CRMTransMethod.getCRMContacterLinkWithTitle\" otherpara=\""
									+ otherpara + "\" />";
									tableString += " <col width=\"75%\"  text=\"" + SystemEnv.getHtmlLabelName(576,user.getLanguage()) + SystemEnv.getHtmlLabelName(433,user.getLanguage())
									+ "\" column=\"description\" orderkey=\"t1.description\"/>";
									
									tableString += " </head>" + "</table>";
								%>
									<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.CRM_SizeSet%>">
									<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" isShowBottomInfo ="true" />
								</td>
							</tr>
						</TABLE>
					</td>
				</tr>
			</TABLE>
		</td>
	</tr>	
</table>
</BODY>
</HTML>
