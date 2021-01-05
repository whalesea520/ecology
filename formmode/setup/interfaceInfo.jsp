<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/formmode/pub.jsp"%>
<%@ page import="weaver.general.Util"%>
<%
if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)
		&&!HrmUserVarify.checkUserRight("FORMMODEFORM:ALL", user)
		&&!HrmUserVarify.checkUserRight("FORMMODEAPP:ALL", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
int customSearchId = Util.getIntValue(request.getParameter("id"), 0);
%>
<html>
<head>
	<title></title>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	
	<style>
	*{
		font: 12px Microsoft YaHei;
	}
	.e8_tblForm{
		width: 100%;
		margin: 0 0;
		border-collapse: collapse;
	}
	.e8_tblForm .e8_tblForm_label{
		vertical-align: top;
		border-bottom: 1px solid #e6e6e6;
		padding: 5px 2px;
	}
	.e8_tblForm .e8_tblForm_field{
		border-bottom: 1px solid #e6e6e6;
		padding: 5px 7px;
		background-color: #f8f8f8;
	}
	.e8_label_desc{
		color: #aaa;
	}
	</style>
	<style type="text/css">
		* {font:12px Microsoft YaHei}
		html,body{
			height: 100%;
			margin: 0px;
			padding: 0px 0 0 2px;
		}
		.e8_right_top{
			padding: 13px 10px 0px 10px;
			position: relative;
		}
		.e8_right_top .e8_baseinfo{
			border-bottom: 1px solid #E9E9E9;
			padding-bottom: 16px;
		}
		.e8_right_top .e8_baseinfo_name{
			font-size: 18px;
			color: #333;
		}
		.e8_right_top .e8_baseinfo_modify{
			font-size: 12px;
			color: #AFAFAF;
		}
		.e8_right_top ul{
			list-style: none;
			position: absolute;
			right: 20px;
			bottom: 15px;
		}
		.e8_right_top ul li{
			float: left;
			padding: 0px 5px;
		}
		.e8_right_top ul li a{
			display: block;
			font-size: 15px;
			color: #A3A3A3;
			padding: 1px;
			text-decoration: none;
			cursor: pointer;
		}
		.e8_right_top ul li.selected a{
			color: #0072C6;		
			border-bottom: 2px solid #0072C6;
		}
		.e8_right_center{
			overflow: hidden;
			padding: 0px 10px;
		}
		.e8_right_center .e8_right_frameContainer{
			display: none;
			height: 100%;
		}
		.e8_formmode_gray{
			color: #aaa;
		}
	</style>
	<script type="text/javascript">
		
		$(document).ready(function () {
			$(window).resize(forPageResize);
			forPageResize();
		});
		
		function forPageResize(){
			var $body = $(document.body);
			var $e8_right_top = $(".e8_right_top");
			var $e8_right_center = $(".e8_right_center");
			
			var centerHeight = $body.height() - $e8_right_top.outerHeight(true);
			
			$e8_right_center.height(centerHeight);
		}
	</script>
</head>
  
<body>
	<div class="e8_right_top">
		<div style="width:40px;float:left;margin:2px 10px 0 0;"><img src="/formmode/images/interfaceIconRounded_wev8.png" /></div>
		<div class="e8_baseinfo">
			<div class="e8_baseinfo_name">
				Web Service 
			</div>
			<div class="e8_baseinfo_modify">
				webservices.services.weaver.com.cn
			</div>
		</div>
	</div>
	
	<div class="e8_right_center" style="">
		<table class="e8_tblForm">
		<tr>
			<td class="e8_tblForm_label" width="20%">Name<div class="e8_label_desc"></div></td>
			<td class="e8_tblForm_field" width="80%">
			ModeDataService
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label" width="20%">Service Class<div class="e8_label_desc"></div></td>
			<td class="e8_tblForm_field" width="80%">
			weaver.formmode.webservices.ModeDataService
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label" width="20%">WSDL<div class="e8_label_desc"></div></td>
			<td class="e8_tblForm_field" width="80%">
			http://ip:port//services/ModeDataService?wsdl
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%><!-- 说明 --></td>
			<td class="e8_tblForm_field">
			<%if(customSearchId==1){%>
					<%=SystemEnv.getHtmlLabelName(82143,user.getLanguage())%><!-- 获取表单数据列表（分页） -->
			<%}else if(customSearchId==2){%>
					<%=SystemEnv.getHtmlLabelName(82144,user.getLanguage())%><!-- 跟据条件获取表单数据总数 -->
			<%}else if(customSearchId==3){%>
					<%=SystemEnv.getHtmlLabelName(82145,user.getLanguage())%><!-- 通过ID获取详细信息 -->
			<%}else if(customSearchId==4){%>
					<%=SystemEnv.getHtmlLabelName(82146,user.getLanguage())%><!-- 保存表单数据（新增、更新） -->
			<%}else if(customSearchId==5){%>
					<%=SystemEnv.getHtmlLabelName(82147,user.getLanguage())%><!-- 根据数据ID删除表单数据 -->
			<%}%>
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(28245,user.getLanguage())%><!-- 输入参数 --><div class="e8_label_desc"></div></td>
			<td class="e8_tblForm_field" width="80%">
			<%if(customSearchId==1){%>
				@param modeId <%=SystemEnv.getHtmlLabelName(19049,user.getLanguage())%>ID<br><!-- 表单 -->
				@param pageNo <%=SystemEnv.getHtmlLabelName(82148,user.getLanguage())%><!-- 当前页数 --><br>
				@param pageSize <%=SystemEnv.getHtmlLabelName(82149,user.getLanguage())%><!-- 每页记录数 --><br>
		 		@param recordCount <%=SystemEnv.getHtmlLabelName(82150,user.getLanguage())%><!-- 记录总数（小于等于0时自动计算记录总数） --><br>
				@param userid <%=SystemEnv.getHtmlLabelName(82151,user.getLanguage())%><!-- 当前用户 --><br>
				@param conditions <%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%><!-- 查询条件 --><br>
				@param right （y/n） <%=SystemEnv.getHtmlLabelName(82152,user.getLanguage())%><!-- 是否受权限控制 --><br>
				@param isReturnDetail （y/n） <%=SystemEnv.getHtmlLabelName(82153,user.getLanguage())%><!-- 是否返回明细表数据 -->
			<%}else if(customSearchId==2){%>
				@param modeId <%=SystemEnv.getHtmlLabelName(19049,user.getLanguage())%><!-- 表单 -->ID<br>
				@param userId <%=SystemEnv.getHtmlLabelName(24533,user.getLanguage())%><!-- 用户 -->ID<br>
				@param conditions <%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%><!-- 查询条件 --><br>
				@param right （y/n） <%=SystemEnv.getHtmlLabelName(82152,user.getLanguage())%><!-- 是否受权限控制 -->
			<%}else if(customSearchId==3){%>
				@param modeId <%=SystemEnv.getHtmlLabelName(19049,user.getLanguage())%><!-- 表单 -->ID<br>
	 			@param Id <%=SystemEnv.getHtmlLabelName(563,user.getLanguage())%><!-- 数据 -->ID<br>
				@param userId <%=SystemEnv.getHtmlLabelName(24533,user.getLanguage())%><!-- 用户 -->ID<br>
	 			@param right （y/n）  <%=SystemEnv.getHtmlLabelName(82152,user.getLanguage())%><!-- 是否受权限控制 --><br>
				@param isReturnDetail （y/n） <%=SystemEnv.getHtmlLabelName(82153,user.getLanguage())%><!-- 是否返回明细表数据 -->
			<%}else if(customSearchId==4){%>
				@param paramXml
			<%}else if(customSearchId==5){%>
				@param modeId <%=SystemEnv.getHtmlLabelName(19049,user.getLanguage())%><!-- 表单 -->ID<br>
			 	@param Id <%=SystemEnv.getHtmlLabelName(563,user.getLanguage())%><!-- 数据 -->ID<br>
				@param userId <%=SystemEnv.getHtmlLabelName(24533,user.getLanguage())%><!-- 用户 -->ID<br>
				@param right （y/n）   <%=SystemEnv.getHtmlLabelName(82152,user.getLanguage())%><!-- 是否受权限控制 -->
			<%}%>
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label" ><%=SystemEnv.getHtmlLabelName(28255,user.getLanguage())%><!-- 输出参数 --></td>
			<td class="e8_tblForm_field" width="80%">
			<%if(customSearchId==1){%>
					String: <%=SystemEnv.getHtmlLabelName(82154,user.getLanguage())%><!-- 表单数据列表（分页） -->
			<%}else if(customSearchId==2){%>
					int: <%=SystemEnv.getHtmlLabelName(82155,user.getLanguage())%><!-- 表单总数 -->
			<%}else if(customSearchId==3){%>
					String: <%=SystemEnv.getHtmlLabelName(33473,user.getLanguage())%><!-- 表单内容 -->
			<%}else if(customSearchId==4){%>
					String: <%=SystemEnv.getHtmlLabelName(82156,user.getLanguage())%><!-- 返回保存状态 -->
			<%}else if(customSearchId==5){%>
					String: <%=SystemEnv.getHtmlLabelName(82157,user.getLanguage())%><!-- 返回删除状态 -->
			<%}%>
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(82158,user.getLanguage())%><!-- 客户端生成说明 --><div class="e8_label_desc"></div></td>
			<td class="e8_tblForm_field" width="80%">
			<%=SystemEnv.getHtmlLabelName(160,user.getLanguage())%><!-- 使用 -->Myeclipse -> File -> new -> Other -> Myeclipse -> Web Services -> Web Service Client 
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(82159,user.getLanguage())%><!-- 示例 --><div class="e8_label_desc"><%=SystemEnv.getHtmlLabelName(82160,user.getLanguage())%><!-- 外部系统调用接口的示例代码 --></div></td>
			<td class="e8_tblForm_field">
				<a href="/weaver/weaver.formmode.servelt.DownloadFile?filename=/formmode/setup/webservice_example.rar"><%=SystemEnv.getHtmlLabelName(30235,user.getLanguage())%><!-- 表单建模 -->webservice_example.rar</a>
			</td>
		</tr>
		</table>
	</div>
</body>
</html>
