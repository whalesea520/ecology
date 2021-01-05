
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	int ppicturetype = Util.getIntValue(Util.null2String(request.getParameter("picturetype")),1);
	String eid = Util.null2String(request.getParameter("eid"));
%>
<HTML>
	<HEAD>
		<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
		<link href="/page/maint/style/common_wev8.css" type="text/css" rel=stylesheet>
<link href="/css/Weaver_wev8.css" rel="stylesheet" type="text/css" >
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/jquery/jquery_wev8.js"></script>
		<link href="/js/jquery/ui/jquery-ui_wev8.css" type="text/css" rel=stylesheet>
		<SCRIPT type="text/javascript" src="/js/jquery/plugins/filetree/jquery.filetree_wev8.js"></script>
		<style type="">
		body{
			scroll:no;
			margin:0px;
			padding:0;
		}
		img{
		  vertical-align: middle;
		}
		
		</style>
	</HEAD>
	<BODY scroll=no>
		<FORM id="pictureForm" NAME=pictureForm STYLE="margin-bottom: 0;"
			action="/page/element/Picture/PictureOperation.jsp" method=post target="_parent">
			<input type="hidden" value="save" name="operation">
			<input type="hidden" value="<%=ppicturetype %>" name="picturetype">
			<input type="hidden" value="<%=eid %>" name="eid">
			<table width="100%" height="100%" border="0" cellspacing="0"
				cellpadding="0">
				<colgroup>
				<col width="1">
				<col width="100">
				<col width="1">
				</colgroup>
				<tr>
					<td height="10" colspan="3"></td>
				</tr>
				<tr>
				   <td width='10'></td>
					<td width="*" algin='center' valign="top" height="100%">
						<TABLE width='100%' class=Shadow height="100%">
							<tr>
								<td valign="top">
									
										<TABLE id="pictureTable"  class="ListStyle" cellSpacing=1 style="table-layout:fixed">
											<colgroup>
												
												<col width="190">
												<col width="190">
												<col width="190">
												<col>
												<col>
											</colgroup>
											<THEAD>
												<TR class=HeaderForXtalbe style='height:35px! important'>
													
													<TH title="<%=SystemEnv.getHtmlLabelName(26283, user.getLanguage())%>" >
														<%=SystemEnv.getHtmlLabelName(26283, user.getLanguage())%>
													</TH>
													<TH title="<%=SystemEnv.getHtmlLabelName(26284, user.getLanguage())%>">
														<%=SystemEnv.getHtmlLabelName(26284, user.getLanguage())%>
													</TH>
													<TH title="<%=SystemEnv.getHtmlLabelName(26285, user.getLanguage())%>">
														&nbsp;<%=SystemEnv.getHtmlLabelName(26285, user.getLanguage())%>&nbsp;
													</TH>
													<TH title="<%=SystemEnv.getHtmlLabelName(24986, user.getLanguage())%>">
														&nbsp;<%=SystemEnv.getHtmlLabelName(24986, user.getLanguage())%>&nbsp;
													</TH>
													<TH title="<%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%>">
														&nbsp;<%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%>
													</TH>
													<TH title="<%=SystemEnv.getHtmlLabelName(22932, user.getLanguage())%>" class=Header>
														&nbsp;<%=SystemEnv.getHtmlLabelName(22932, user.getLanguage())%>
													</TH>
												</TR>
											</THEAD>
											<TBODY>
												<%
													String sql="select * from slideElement where eid="+eid;
													rs.execute(sql);
													int size=0;
													while(rs.next()){
												%>
												<tr class="DataLight" id="">
													<td > 
														<input value="<%=Util.null2String(rs.getString("url1")) %>"  name="url1"  width="96%"   class="filetree pictureSrc" readonly="readonly"  />
													</td>
													<td >
														<input  value="<%=Util.null2String(rs.getString("url2")) %>"   name="url2"  width="96%" class="filetree pictureSrc" readonly="readonly"/>
													
													</td>
													<td >
														<input  value="<%=Util.null2String(rs.getString("url3")) %>"  name="url3"  width="96%" class="filetree pictureSrc"  readonly="readonly" />
													</td>
													<td>
														<input  value="<%=Util.null2String(rs.getString("title")) %>"  style="width:96%" class="inputstyle" name="title">
													</td>
													<td>
														<input  value="<%=Util.null2String(rs.getString("description")) %>"  style="width:96%" class="inputstyle" name="description">
													</td>
													<td>
														<input  value="<%=Util.null2String(rs.getString("link")) %>"  style="width:96%" class="inputstyle" name="link">
													</td>
												</tr>
												<% 
												size++;
													}
												while(size<4){%>
												<tr class="DataLight" id="">
													<td > 
														<input value=""  name="url1"  width="96%"   class="filetree pictureSrc" readonly="readonly"  />
													</td>
													<td >
														<input  value=""   name="url2"  width="96%" class="filetree pictureSrc" readonly="readonly"/>
													
													</td>
													<td >
														<input  value=""  name="url3"  width="96%" class="filetree pictureSrc"  readonly="readonly" />
													</td>
													<td>
														<input  value=""  style="width:96%" class="inputstyle" name="title">
													</td>
													<td>
														<input  value=""  style="width:96%" class="inputstyle" name="description">
													</td>
													<td>
														<input  value=""  style="width:96%" class="inputstyle" name="link">
													</td>
												</tr>
													
												<%
												size++;
												}%>
											</TBODY>
										</TABLE>
								</td>
							</tr>
						</TABLE>
					</td>
					<td width='10'></td>
				</tr>
			</table>
		</FORM>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="margin:auto;text-align:center;">
	    	<input type="button" accessKey=O  id=btnok  value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" id="zd_btn_submit_0" class="zd_btn_submit" onclick="onSave();">
	    	<input type="button" accessKey=T  id=btncancel value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
			<script type="text/javascript">
				jQuery(document).ready(function(){
					resizeDialog(document);
				});
			</script>
		</div>
	</BODY>
</HTML>

<script type="text/javascript">
	var dialog = parent.getDialog(window);
	var parentWin = parent.getParentWindow(window);
	 var trclass = "DataLight";
	 function onClose(){
	 	dialog.callbackfun();
	 }
	 
	 function onSave(){
	 	var formParams = $("#pictureForm").serialize();
	 	dialog.callbackfun(formParams);
	 }
	 
	
	$(".pictureSrc").filetree();

    $("input[name='url1']").css("width","auto");
	$("input[name='url2']").css("width","auto");
	$("input[name='url3']").css("width","auto");
</SCRIPT>