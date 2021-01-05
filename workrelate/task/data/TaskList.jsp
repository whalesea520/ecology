<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page" />
<%
	String userid = user.getUID()+"";

	String requestid = Util.null2String(request.getParameter("requestids"));
	String docid = Util.null2String(request.getParameter("docids"));
	String crmid = Util.null2String(request.getParameter("crmids"));
	
	int _pagesize = 10;
	int _total = 0;//总数
	StringBuffer querysql = new StringBuffer();
	querysql.append("select count(t1.id) from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null)"
		+" and (t1.principalid="+userid+" or t1.creater="+userid
		+ " or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+")"
		+ " or exists (select 1 from TM_TaskSharer ts where ts.taskid=t1.id and ts.sharerid="+userid+")"
		+ " or exists (select 1 from HrmResource hrm where (hrm.id=t1.principalid or hrm.id=t1.creater) and hrm.managerstr like '%,"+userid+",%')"
		+ " or exists (select 1 from HrmResource hrm,TM_TaskPartner tp where tp.taskid=t1.id and hrm.id=tp.partnerid and hrm.managerstr like '%,"+userid+",%')"
		+ ")");
	
	String title = "";
	if(!requestid.equals("")){
		querysql.append(" and t1.wfids like '%,"+requestid+",%'");
		title = "流程："+cmutil.getRequestName(requestid);
	}else if(!docid.equals("")){
		querysql.append(" and t1.docids like '%,"+docid+",%'");
		title = "文档："+cmutil.getDocName(docid);
	}else if(!crmid.equals("")){
		querysql.append(" and t1.crmids like '%,"+crmid+",%'");
		title = "客户："+cmutil.getCustomer(crmid);
	}
	title += "相关任务列表";
	
	rs.executeSql(querysql.toString());
	if(rs.next()){
		_total = rs.getInt(1);
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title><%=this.replaceHtml(title) %></title>
		<script language="javascript" src="/workrelate/js/jquery-1.8.3.min.js"></script>
		<link rel="stylesheet" href="../css/main.css" />
		<link rel="stylesheet" href="/workrelate/css/perfect-scrollbar.css" rel="stylesheet" />
      	<script language="javascript" src="/workrelate/js/jquery.mousewheel.js"></script>
      	<script language="javascript" src="/workrelate/js/perfect-scrollbar.js"></script>
      	<script language="javascript" src="/workrelate/js/util.js"></script>
		<style type="text/css">
			html,body{margin: 0px;padding: 0px;}	
			*{font-size: 12px;font-family: '微软雅黑';}		
			
			.maintable{width: 100%;border-collapse: collapse;}
			.datatable{width: 100%;table-layout: fixed;margin-bottom: 0px;border-collapse: collapse;}
			.datatable td,.datatable td a,.doclist td font,.datatable td div{
				line-height: 30px;height: 30px;empty-cells: show;word-break: keep-all;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;color: #909090;}
			.datatable td{border:0px;border-bottom:1px #EFEFEF solid;padding-left: 2px;padding-right: 2px;}
			.datatable td a{text-decoration: none;}
			.datatable tr.datahover td{background: #F5F5F5;}
			.datatable tr.newlink td{color: #C00000;}
			.title{padding-left: 0px;color: #404040;height: 30px;border-bottom: 2px #DFEFFF solid;}
			.nodata{font-style: italic;color: #C1C1C1;}
			.date{color:#bdbdbd !important;}
			.title_txt,.title_txt a{color: #404040;line-height: 30px;margin-left: 5px;font-weight: bold;font-size: 14px;text-decoration: none;}
			.title_txt{height: 30px;margin-left: 5px;}
			.title_txt a:hover{color: #EC0000;}
			.more{width:50px;float:right;margin-right:2px;text-align: right;line-height: 24px;font-style: normal;color: #7F7F7F;cursor: pointer;}
			.filediv{float: left;width:auto;margin-right: 20px;word-break: keep-all;white-space: nowrap;}
			
			.linkbtn{position: absolute;line-height: 28px;right: 5px;top: 0px;cursor: pointer;color: #969696;font-style: italic;}
			.linkbtn_hover{color: #0000A0}
			
			.newinput{font-weight: bold;color:#800000 !important;}
			.listmore{height: 30px;line-height: 30px;}
			.listmore_hover{background: #EEF7FF;}
		</style>
	<%@ include file="/secondwev/common/head.jsp" %>
	</head>
	<%
		
	%>
	<body style="overflow: hidden;">
		<div id="title">
			<table width=100% border="0" cellspacing="0" cellpadding="0">
				<colgroup>
					<col width="10"/>
					<col width=""/>
					<col width="10"/>
				</colgroup>
				<tr>
					<td></td>
					<td><div class="title"><div class="title_txt"><%=title %></div></div></td>
					<td></td>
				</tr>
			</table>
		</div>
		<div id="main" style="width: 100%;height: 400px;position: relative;overflow: hidden;">
			<table width=100% border="0" cellspacing="0" cellpadding="0">
				<colgroup>
					<col width="10"/>
					<col width=""/>
					<col width="10"/>
				</colgroup>
				<tr>
					<td></td>
					<td valign="top">
						<table id="datatable" class="datatable" cellpadding="0" cellspacing="0" border="0">
							<colgroup><col width="30px"/><col width="23px"/><col width="*"/><col width="30px"/><col width="44px"/><col width="44px"/></colgroup>
						</table>	
						<%if(_total==0){ %>
							<div class="feedbackinfo" style="font-style: italic;color:#999999;line-height: 28px;">
								暂无相关任务信息！
							</div>
						<%} %>
						<div id="btn_more" class="listmore" style="display: none;background-image: none;margin-bottom: 0px;" 
							_currentpage="0" _pagesize="<%=_pagesize %>" _total="<%=_total %>" onclick="getList(this)" title="显示更多数据">更多</div>
						<div style="width: 100%;height: 10px;">&nbsp;</div>
					</td>
					<td></td>
				</tr>
			</table>
		</div>
		
		<script type="text/javascript" defer="defer">
			var index = 0;
			jQuery(document).ready(function(){
				$("#datatable").find("tr").live("mouseover",function(){
					$(this).addClass("datahover");
				}).live("mouseout",function(){
					$(this).removeClass("datahover");
				});
				$("#btn_more").bind("mouseover",function(){
					$(this).addClass("listmore_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("listmore_hover");
				});
				<%if(_total>0){ %>
				getList($("#btn_more"));
				setHeight();
				jQuery("#main").perfectScrollbar({"wheelSpeed": 40,"suppressScrollX":true});
				<%}%>
			});
			$(window).resize(function(){
				setHeight();
			});
			function getList(obj){
				var _currentpage = parseInt($(obj).attr("_currentpage"))+1;
				var _pagesize = $(obj).attr("_pagesize");
				var _total = $(obj).attr("_total");
				$(obj).html("<img src='../images/loading2.gif' style='margin-top:5px;' align='absMiddle'/>");
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"get_more_list","currentpage":_currentpage,"pagesize":_pagesize,"total":_total
				    	,"requestid":"<%=requestid%>","docid":"<%=docid%>","crmid":"<%=crmid%>"}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
				    	var records = $.trim(data.responseText);
				    	$("#datatable").append(records);
				    	if(_currentpage*_pagesize>=_total){
				    		$("#btn_more").hide();
					    }else{
					    	$(obj).attr("_currentpage",_currentpage).html("显示更多");
					    	$("#btn_more").show();
						}
				    	setIndex();
				    	$('#main').perfectScrollbar("update");
					}
			    });
			}
			function setHeight(){
				$("#main").height($(window).height()-$("#title").height());
			}
			function setIndex(){
				var sh = 330;
				var mh = $("#main").height();
				if(mh<sh) sh = mh;
				$("#main").scrollTop($("#main").scrollTop()+sh);
				$("td.index").each(function(){
					index++;
					$(this).html(index).removeClass("index");
				});
			}
		</script>
	</body>
</html>
<%!
public static String replaceHtml(String s) {
	// 去掉所有html元素
    s = s.replaceAll("\\&[a-zA-Z]{1,10};", "").replaceAll("<[^>]*>", "");   
    s = s.replaceAll("[(/>)<]", "");
    s = s.replaceAll("initFlashVideo();", "");

    return s;
}
%>