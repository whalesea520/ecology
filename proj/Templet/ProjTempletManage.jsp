<%@page import="org.json.JSONObject"%>
<%@page import="weaver.proj.util.PropUtil"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
</HEAD>
<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(18375,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(320,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
    boolean canEdit = false ;
    
    int proTypeId = Util.getIntValue(request.getParameter("proTypeId"),0);
    String nameQuery1 = Util.null2String(request.getParameter("flowTitle"));
    String nameQuery = Util.null2String(request.getParameter("nameQuery"));
    String typedesc = Util.null2String(request.getParameter("typedesc"));
    

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    if(HrmUserVarify.checkUserRight("ProjTemplet:Maintenance", user)){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:addSub(),_self} " ;
        RCMenuHeight += RCMenuHeightStep;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:batchDel(),_self} " ;
        RCMenuHeight += RCMenuHeightStep;
        
        canEdit = true ;
    }
    //RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:window.history.go(-1),_self} " ;
    //RCMenuHeight += RCMenuHeightStep;



//added by hubo,20060228,为项目模板增加搜索功能
String strTemplateName = Util.null2String(request.getParameter("templateName"));
String strProTypeId = Util.null2String(request.getParameter("proTypeId"));
String strTemplateStatus = Util.null2String(request.getParameter("templateStatus"));

String pageId=Util.null2String(PropUtil.getPageId("prj_projtempletmanage"));
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<form name="frmSearch" id="frmSearch" method="post" >
<input type="hidden" name="pageId" id="pageId" value="<%=pageId  %>" />
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<%
		if(canEdit){
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("82",user.getLanguage())%>" class="e8_btn_top"  onclick="addSub()"/>
			<%
		}
		%>
		<%
		if(canEdit){
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("32136",user.getLanguage())%>" class="e8_btn_top" onclick="batchDel()"/>
			<%
		}
		%>
			
			
			<input type="text" class="searchInput" name="flowTitle" value="<%=nameQuery1 %>" />
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
	<div class="advancedSearchDiv" id="advancedSearchDiv">
		<wea:layout type="4col">
		    <wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage())%>'>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
			    <wea:item><input  name=nameQuery class=InputStyle value='<%=nameQuery %>'></wea:item>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
		    	<wea:item><input  name=typedesc class=InputStyle value='<%=typedesc %>'></wea:item>
		    </wea:group>
		    <wea:group context="">
		    	<wea:item type="toolbar">
		    		<input class="zd_btn_submit" type="submit" name="submit1" value="<%=SystemEnv.getHtmlLabelNames("197",user.getLanguage())%>"/>
		    		<input class="zd_btn_cancle" type="reset" name="reset" value="<%=SystemEnv.getHtmlLabelNames("2022",user.getLanguage())%>"/>
		    		<input class="zd_btn_cancle" type="button" name="cancel" id="cancel" value="<%=SystemEnv.getHtmlLabelNames("201",user.getLanguage())%>"  />
		    	</wea:item>
		    </wea:group>
		</wea:layout>
	</div>
</form>	

<%

String popedomOtherpara="";
//操作列参数
JSONObject operatorInfo=new JSONObject();
operatorInfo.put("userid", user.getUID());
operatorInfo.put("usertype", user.getLogintype());
operatorInfo.put("languageid", user.getLanguage());
operatorInfo.put("operatortype", "prj_template");//操作项类型
if(true||proTypeId>0){
	//popedomOtherpara=canEdit+"_"+canEdit+"_true_"+canEdit;
	operatorInfo.put("operator_num", 6);//操作项数量
}else{
	//popedomOtherpara=canEdit+"_"+canEdit+"_true";
	operatorInfo.put("operator_num", 5);//操作项数量
}
operatorInfo.put("operator_val", popedomOtherpara);


String sqlWhere = "WHERE 1=1 ";
if(proTypeId>0){
	sqlWhere+=" and proTypeId='"+proTypeId+"' ";
}


if(!nameQuery.equals("")){
	sqlWhere += " AND templetName LIKE '%"+nameQuery+"%'";
}
if(!nameQuery1.equals("")){
	sqlWhere += " AND templetName LIKE '%"+nameQuery1+"%'";
}
if(!typedesc.equals("")){
	sqlWhere += " AND templetDesc like '%"+typedesc+"%'";
}
if(!strTemplateStatus.equals("")){
	//status 3:退回草稿状态
	if(strTemplateStatus.equals("0")){
		sqlWhere += " AND (status='0' OR status='3')";
	}else{
		sqlWhere += " AND status='"+strTemplateStatus+"'";
	}
}
        String tableString=""+
                   "<table  pageId=\""+pageId+"\"   pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID(),"prj")+"\"  tabletype=\"checkbox\">"+
                	" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod='weaver.proj.util.ProjectTransUtil.getCanDelPrjTemplate' />"+
                   "<sql backfields=\"id,templetName,updatedate,templetDesc,proTypeId,workTypeId,isSeleCted,status\" sqlform=\"Prj_Template\" sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"/>"+
                   "<head>"+                             
                         "<col width=\"8%\"  text=\"ID\" column=\"id\"  orderkey=\"id\"/>"+
                         "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(18151,user.getLanguage())+"\" column=\"templetName\"   target=\"_fullwindow\" linkkey=\"templetId\" linkvaluecolumn=\"id\" href=\"ProjTempletView.jsp\" orderkey=\"templetName\"/>"+
                         "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(586,user.getLanguage())+"\" column=\"proTypeId\" orderkey=\"proTypeId\" transmethod=\"weaver.proj.Maint.ProjectTypeComInfo.getProjectTypename\" />"+
                         "<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\"  column=\"status\" orderkey=\"status\" transmethod=\"weaver.splitepage.transform.SptmForProj.getTemplateStatus\" otherpara=\""+user.getLanguage()+"\"/>"; 
                   if(proTypeId>0){
                	  tableString+= "<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(18631,user.getLanguage())+"\"  column=\"isSeleCted\" orderkey=\"isSeleCted\" transmethod=\"weaver.splitepage.transform.SptmForProj.getIsSelect\"/>";
                   }
                         
                   	tableString+=   "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(19521,user.getLanguage())+"\"  column=\"updatedate\" orderkey=\"updatedate\" />"+
                   "</head>"+
                   "<operates width=\"12%\">"+
                		   "   <popedom column='id' otherpara='"+operatorInfo.toString() +"' transmethod='weaver.proj.util.ProjectTransUtil.getOperates'  ></popedom>"+
                   "    <operate href=\"javascript:onEdit()\"  text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\"  index=\"0\"/>"+
                   "    <operate href=\"javascript:onDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\"  index=\"1\"/>";
                   tableString+="    <operate href=\"javascript:onTaskList()\" text=\""+SystemEnv.getHtmlLabelName(18505,user.getLanguage())+"\"  index=\"2\"/>";
                   tableString+="    <operate href=\"javascript:onApprove()\" text=\""+SystemEnv.getHtmlLabelNames("15143",user.getLanguage())+"\"  index=\"3\"/>";
                   //if(proTypeId>0){
                   	tableString+="    <operate href=\"javascript:onSel()\" text=\""+SystemEnv.getHtmlLabelName(17908,user.getLanguage())+"\"   index=\"4\"/>";
                   	tableString+="    <operate href=\"javascript:onSel()\" text=\""+SystemEnv.getHtmlLabelNames("311,17908",user.getLanguage())+"\"   index=\"5\"/>";
                   //}
                   tableString+= "</operates>"+
                   "</table>"; 
        
        %>
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/> 

 
 
 
<script type="text/javascript">


function onApprove(id){
	if(id){
		var url="/proj/Maint/ProjectTypeOperation.jsp?method=approvetemplate&templetId="+id+"&isdialog=1"; 
		var message="<%=SystemEnv.getHtmlLabelNames("83921",user.getLanguage())%>";
		var message2="<%=SystemEnv.getHtmlLabelNames("83975",user.getLanguage())%>";
		if(window.top.Dialog.confirm(message,function(){
			//提示
			var diag_tooltip = new window.top.Dialog();
			diag_tooltip.ShowCloseButton=false;
			diag_tooltip.ShowMessageRow=false;
			//diag_tooltip.hideDraghandle = true;
			diag_tooltip.Width = 300;
			diag_tooltip.Height = 50;
			diag_tooltip.InnerHtml="<div style=\"font-size:12px;\" >"+message2+"<br><img style='margin-top:-20px;' src='/images/ecology8/loadingSearch_wev8.gif' /></div>";
			diag_tooltip.show();
			
			jQuery.ajax({
				url : url,
				type : "post",
				async : true,
				data : "",
				dataType : "html",
				success: function do4Success(msg){
					diag_tooltip.close();
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83923",user.getLanguage())%>");
					window.location.reload();
				}
			});
		}));
	}
	
}


function onTaskList(id){
	var url="/proj/Templet/ProjTempletViewData.jsp?templetId="+id+"&isdialog=1";
	var title="<%=SystemEnv.getHtmlLabelNames("18505",user.getLanguage())%>";
	openDialog(url,title,1000,700,true,true);
}

function addSub(){
	var url="/proj/Templet/ProjTempletAdd.jsp?txtPrjType=<%=strProTypeId %>&isdialog=1";
	var title="<%=SystemEnv.getHtmlLabelNames("83977",user.getLanguage())%>";
	openDialog(url,title,1000,700,false,true);
}
function onEdit(id){
	var url="/proj/Templet/ProjTempletEdit.jsp?templetId="+id+"&isdialog=1";
	var title="<%=SystemEnv.getHtmlLabelNames("83978",user.getLanguage())%>";
	openDialog(url,title,1000,700,false,true);
}

function onSel(id){
	if(id){
		jQuery.post(
			"/proj/Templet/ProjTempletOperate.jsp",
			{"method":"select","templetId":id,"proTypeId":<%=proTypeId %>},
			function(data){
				//Dialog.alert("指定成功！",function(){
					_table.reLoad();
				//});
			}
		);
	}
}
function onDel(id){
	if(id){
		window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83600",user.getLanguage())%>',function(){
			jQuery.post(
				"/proj/Templet/ProjTempletOperate.jsp",
				{"method":"delete","templetId":id},
				function(data){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83472",user.getLanguage())%>",function(){
						_table.reLoad();
						refreshLeftTree();
					});
				}
			);
			
		});
	}
}

function batchDel(){
	var typeids = _xtable_CheckedCheckboxId();
	if(typeids=="") return ;
	window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83601",user.getLanguage())%>',function(){
		jQuery.ajax({
			url : "/proj/Templet/ProjTempletOperate.jsp",
			type : "post",
			async : true,
			data : {"method":"batchdelete","id":typeids},
			dataType : "html",
			contentType: "application/x-www-form-urlencoded; charset=utf-8", 
			success: function do4Success(msg){
				if(msg&&msg.referenced){
					var info="";
					for(var i=0;i<msg.referenced.length;i++){
						info+=msg.referenced[i]+" ";
					}
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83979",user.getLanguage())%>:\n"+info);
				}else{
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83472",user.getLanguage())%>");
				}
				_table.reLoad();
				refreshLeftTree();
			}
		});
	});
}

$(function(){
	var cptgroupname='<%=ProjectTypeComInfo.getProjectTypename(strProTypeId) %>';
	if(cptgroupname==''){
		cptgroupname='<%=SystemEnv.getHtmlLabelName(33090,user.getLanguage()) %>';
	}
	try{
		parent.setTabObjName(cptgroupname);
	}catch(e){}
	
	
});
function onBtnSearchClick(){
	frmSearch.submit();
}
$(function(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
});

function refreshLeftTree(){
	try{
		var tree= $("#leftframe",parent.parent.document);
		var src=tree.attr("src");
		if(src.indexOf("?")>=0){
			src=src+"&selectFirst=false";
		}else{
			src=src+"?selectFirst=false";
		}
		tree.attr("src",src);
	}catch(e){}
}
</script>

</BODY>
</HTML>

