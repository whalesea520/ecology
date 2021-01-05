<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<% 
	boolean canedit = false;
	//判断是否有权限
	if (HrmUserVarify.checkUserRight("GP_BaseSettingMaint", user)) {
		canedit = true;
	}
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<style type="text/css">
			.maintable,.listtable{width: 100%;}
			.maintable td,.listtable td{line-height: 28px;padding-left: 5px;}
			.maintable td.title{background: #E9E7D8;}
			.listtable td{border-bottom: 1px #F1F0E7 solid;}
			.listtable tr.header td{font-weight: bold;border-bottom: 1px #DDD9C3 solid;}
		</style>
	<%@ include file="/secondwev/common/head.jsp" %>
	</head>
	<%
		String titlename = "任务模块基础设置";
	
		String operation = Util.null2String(request.getParameter("operation"));
		String docsecid = "";
		if("save".equals(operation)){
			docsecid = Util.null2String(request.getParameter("docsecid"));
			rs.executeSql("delete from TM_BaseSetting");
			boolean res = rs.executeSql("insert into TM_BaseSetting(docsecid) values('"+docsecid+"')");
			if(res) staticobj.putObject("docsecid",docsecid);
		}else{
			String sql = "select * from TM_BaseSetting";
			rs.executeSql(sql);
			if(rs.next()){
				docsecid = Util.null2String(rs.getString("docsecid"));  
			}
		}

		String docpath = "";
		if(!docsecid.equals("") && !docsecid.equals("0")){
			docpath = SecCategoryComInfo.getAllParentName(docsecid);
	    	if(!"".equals(docpath)) docpath += "/";
			docpath += SecCategoryComInfo.getSecCategoryname(docsecid);
		}
	%>
	<BODY style="overflow: auto">
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
		<%
			if(canedit){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>
		<form id="baseForm" name="baseForm" action="BaseSetting.jsp" method="post">
			<input type="hidden" id="operation" name="operation" value="">
			<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
				<colgroup>
					<col width="10">
					<col width="">
					<col width="10">
				</colgroup>
				<tr>
					<td height="1" colspan="3"></td>
				</tr>
				<tr>
					<td></td>
					<td valign="top">
						<div style="width: 100%;line-height: 28px;border-bottom:2px #D6D6D6 solid;font-size: 14px;font-weight: bold;margin-bottom: 10px;">
							<%=titlename %>
						</div>
						<table class="maintable" cellspacing="5" border="0" style="margin-top: 20px;">
							<colgroup><col width="20%"/><col width="30%"/><col width="*"/></colgroup>
							<tr>
								<td class="title">附件上传目录</td>
								<td>
									<%if(canedit){ %>
					        	<div id="docseciddiv" class="browserdiv"></div>
					        <%}else{ %>
										<%=docpath %>
									<%} %>
								</td>
								<td></td>
							</tr>
						</table>
					</td>
					<td></td>
				</tr>
			</table>
		</form>
		<script type="text/javascript" defer="defer">
			<%if("save".equals(operation)){%>
				alert("保存成功！");
			<%}%>
			<%if(canedit){ %>	
			jQuery(document).ready(function(){
				
				jQuery("#docseciddiv").e8Browser({
				   name:"docsecid",
				   viewType:"0",
				   browserValue:"<%=docsecid%>",
				   isMustInput:"1",
				   browserSpanValue:"<%=docpath%>",
				   hasInput:false,
				   linkUrl:"#",
				   isSingle:true,
				   completeUrl:"",
				   //browserUrl:"/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp",
				   browserUrl:"/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp",
				   width:"",
				   hasAdd:false,
				   needHidden:true,
				   defaultRow: 1,
				   zDialog:true,
				   isAutoComplete:false,
				   _callback:"",
				   nameKey:"path"
				});
			});
			function submitData(obj) {
				jQuery("#operation").val("save");
				obj.disabled = true;
				jQuery("#baseForm").submit();
			}
			function onShowCatalog() {
			    var datas = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp");
			    if (datas) {
			    	if (datas.id!= "") {
			    	  jQuery("#docpath").html(datas.path);
			          jQuery("#docsecid").val(datas.id);
			        }else{
			          jQuery("#docpath").html("");
			          jQuery("#docsecid").val("");
			        }
			    }
			}
			<%}%>
		</script>
	</BODY>
</HTML>