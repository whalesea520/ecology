<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%@ include file="/hrm/header.jsp" %>
<%
	if(!HrmUserVarify.checkUserRight("CustomGroup:Edit", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(17617,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String suggesttitleq = Util.null2String(request.getParameter("suggesttitleq"));
	String qname = Util.null2String(request.getParameter("flowTitle"));
	if(qname.length()>0&&suggesttitleq.length()==0)suggesttitleq=qname;
	String status = Util.null2String(request.getParameter("status"));
	String creater = Util.null2String(request.getParameter("creater"));
	String suggesttitle = Util.null2String(request.getParameter("suggesttitle"));
	if(qname.length()==0 && suggesttitle.length()>0)qname = suggesttitle;
	if(suggesttitle.length()==0&&qname.length()>0)suggesttitle=qname;
	String groupid = Util.null2String(request.getParameter("groupid"));
	String groupname = "";
	String[] arrgroupid = groupid.split(",");
	for(int i=0;arrgroupid!=null&&i<arrgroupid.length;i++){
		rs.executeSql("select name from hrmgroup where id = "+arrgroupid[i]);
		if(rs.next()){
			if(groupname.length()>0)groupname+=",";
			groupname += rs.getString("name");
		}
	}
	String createdateselect = Util.null2String(request.getParameter("createdateselect"));
	
	String createdate = Util.fromScreen(request.getParameter("createdate"),user.getLanguage());
	String createdateTo = Util.fromScreen(request.getParameter("createdateTo"),user.getLanguage());
	if(!createdateselect.equals("") && !createdateselect.equals("0")&& !createdateselect.equals("6")){
		createdate = TimeUtil.getDateByOption(createdateselect,"0");
		createdateTo = TimeUtil.getDateByOption(createdateselect,"1");
	}
	
	//清理已处理的提醒
	String sql=" delete from SysPoppupRemindInfoNew where type=25 and " +
						 " (exists(select t2.id from HrmGroupSuggest t2 where t2.id=SysPoppupRemindInfoNew.requestid and status=1 )"+
						 " or requestid not in (select id from HrmGroupSuggest)) ";
	rs.executeSql(sql);
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>		
		<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script type="text/javascript">
		var dialog = parent.parent.getDialog(parent);
		var parentWin = parent.parent.getParentWindow(parent);
		function resetCondition1(selector){
	if(!selector)selector="#advancedSearchDiv";
	//清空文本框
	jQuery(selector).find("input[type='text']").val("");
	//清空浏览按钮及对应隐藏域
	jQuery(selector).find(".e8_os").find("span.e8_showNameClass").remove();
	jQuery(selector).find(".e8_os").find("input[type='hidden']").val("");
	//清空下拉框
	try{
		jQuery(selector).find("select").selectbox("reset");
	}catch(e){
		jQuery(selector).find("select").each(function(){
			var $target = jQuery(this);
			var _defaultValue = $target.attr("_defaultValue");
			if(!_defaultValue){
				var option = $target.find("option:first");
				_defaultValue = option.attr("value");
			}
			$target.val(_defaultValue).trigger("change");
		});
	}
	//清空日期
	jQuery(selector).find(".calendar").siblings("span").html("");
	jQuery(selector).find(".calendar").siblings("input[type='hidden']").val("");
	
	jQuery(selector).find(".Calendar").siblings("span").html("");
	jQuery(selector).find(".Calendar").siblings("input[type='hidden']").val("");
	
	jQuery(selector).find("input[type='checkbox']").each(function(){
		try{
			changeCheckboxStatus(this,false);
		}catch(e){
			this.checked = false;
		}
	});
}
			var dWidth = 700;
			var dHeight = 500;
			
			function onBtnSearchClick(){
				jQuery("#searchfrm").submit();
			}
			
			function doAdd(id){
				var msg="<%=SystemEnv.getHtmlLabelName(126568,user.getLanguage())%>";
				jQuery.ajax({
					url:"GroupOperation.jsp?operation=getmsginfo&id="+id,
					type:"post",
					dataType:"json",
					async:true,
					cache : false,
					processData : false,
					success:function(data){
						msg = msg.replace(/{#members}/g,data.members);
						msg = msg.replace(/{#groupname}/g,data.groupname);
						doSuggest("addsuggest",id,msg);
					}
				});
			}
			
			function doDel(id){
				var msg="<%=SystemEnv.getHtmlLabelName(126569,user.getLanguage())%>";
				jQuery.ajax({
					url:"GroupOperation.jsp?operation=getmsginfo&id="+id,
					type:"post",
					dataType:"json",
					async:true,
					cache : false,
					processData : false,
					success:function(data){
						if(parseInt(data.type1, 10)>1){
						 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126567,user.getLanguage())%>");
						 return;
						}
						msg = msg.replace(/{#members}/g,data.members);
						msg = msg.replace(/{#groupname}/g,data.groupname);
						doSuggest("delsuggest",id,msg)
					}
				});
			}
			
			function doChangeStatus(id){
				jQuery.ajax({
					url:"GroupOperation.jsp?operation=changesuggeststatus&id="+id,
					type:"post",
					dataType:"json",
					async:true,
					cache : false,
					processData : false,
					success:function(data){
						if(data.flag || data.flag=="true"){
							window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83885,user.getLanguage())%>");
							_table.reLoad();
							parentWin.jsChangeRemindImg();
						}
					}
				});
			}
			
			
			function doSuggest(cmd,id, msg){
				if(!id){
					id = _xtable_CheckedCheckboxId();
				}
				if(!id){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31017,user.getLanguage())%>");
					return;
				}
				if(id.match(/,$/)){
					id = id.substring(0,id.length-1);
				}
				
				window.top.Dialog.confirm(msg,function(){
					var idArr = id.split(",");
					var ajaxNum = 0;
					for(var i=0;i<idArr.length;i++){
						ajaxNum++;
						jQuery.ajax({
							url:"GroupOperation.jsp?operation="+cmd+"&id="+idArr[i],
							type:"post",
							async:true,
							complete:function(xhr,status){
								ajaxNum--;
								if(ajaxNum==0){
									_table.reLoad();
									parentWin.jsChangeRemindImg();
								}
							}
						});
					}
				});
			}
			
			function doShow(id){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmGroup&method=HrmGroupAdd&cmd=show&isdialog=1&id="+id,"<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())+SystemEnv.getHtmlLabelName(17748,user.getLanguage())%>");
			}
			function doOpen(url,title,_dWidth,_dHeight){
				var dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				dialog.Title = title;
				dialog.Width = _dWidth ? _dWidth : dWidth;
				dialog.Height = _dHeight ? _dHeight : dHeight;
				dialog.Drag = true;
				dialog.maxiumnable = true;
				dialog.URL = url;
				dialog.show();
			}
		</script>
	</head>
	<BODY>
	<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="text" class="searchInput" id="flowTitle" name="flowTitle" value="<%=qname %>" onchange="setKeyword('flowTitle','suggesttitle','searchfrm');"/>
					<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<form action="" name="searchfrm" id="searchfrm">
			<input name="status" type="hidden" value="<%=status %>">
			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
				<wea:layout type="4col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(15175,user.getLanguage())%></wea:item>
						<wea:item>
							<span class="wuiDateSpan" selectId="createdateselect" selectValue="<%=createdateselect %>" _needAllOption="true">
								<input class=wuiDateSel type="hidden" name="createdate" id="createdate" value="<%=createdate%>">
								<input class=wuiDateSel type="hidden" name="createdateTo" id="createdateTo" value="<%=createdateTo%>">
							</span>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="creater" browserValue="<%=creater %>" 
			            browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?show_virtual_org=-1&selectedids="
			            hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
			            completeUrl="/data.jsp?show_virtual_org=-1"  temptitle="<%= SystemEnv.getHtmlLabelName(6087,user.getLanguage())%>"
			            browserSpanValue="<%=ResourceComInfo.getResourcename(creater) %>" width="70%" >
			        </brow:browser>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(126442,user.getLanguage())%></wea:item>
						<wea:item><input type="text" id="suggesttitle" name="suggesttitle" class="inputStyle" value='<%=suggesttitle%>'></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(126437,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="groupid" browserValue="<%=groupid %>" 
			            browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/group/MultiGroupBrowser.jsp?sqlwhere=type=1&selectedids="
			            hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
			            completeUrl="/data.jsp?type=hrmgroup&whereClause=type=1"
			            browserSpanValue="<%=groupname %>" width="70%" >
			        </brow:browser>
						</wea:item>
					</wea:group>
					<wea:group context="">
						<wea:item type="toolbar">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick()"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondition1();"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
						</wea:item>
					</wea:group>
				</wea:layout>
			</div>
		</form>
		<%
			String backfields = " a.id, a.suggesttitle, a.groupid, b.name as groupname, a.suggesttype, a.content, a.status , a.creater, a.createdate "; 
			String fromSql  = " HrmGroupSuggest a, hrmgroup b ";
			String sqlWhere = " where a.groupid = b.id ";
			String orderby = " a.id " ;
			String tableString = "";
			if(user.getUID()==1){
				//管理员能看所有的
			}else if(status.equals("0")){
				sqlWhere += " AND EXISTS (SELECT 1 FROM SysPoppupRemindInfoNew WHERE a.id=requestid AND  TYPE=25 AND userid= "+user.getUID()+")";
			}
			
			if(suggesttitleq.length() > 0){
				sqlWhere += " and suggesttitle like '%"+suggesttitleq+"%' ";
			}
			
			if(qname.length() > 0){
				sqlWhere += " and suggesttitle like '%"+qname+"%' ";
			}
			
			if(status.length() > 0){
				sqlWhere += " and status = "+status;
			}
			
			if(createdate.length()>0){
				sqlWhere += " and createdate >='"+createdate+"' ";
			}
			
			if(createdateTo.length()>0){
				sqlWhere += " and createdate <='"+createdateTo+"' ";
			}
			
			if(creater.length()>0){
				sqlWhere += " and creater ='"+creater+"' ";
			}
			
			if(suggesttitle.length()>0){
				sqlWhere += " and suggesttitle like '%"+suggesttitle+"%' ";
			}
			
			if(groupid.length()>0){
				sqlWhere += " and a.groupid in ("+groupid+")";
			}
			
			String operateString= "<operates width=\"20%\">";
 	    	operateString+=" <popedom transmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicOperate\" otherpara=\"+column:suggesttype+==1and+column:status+==0:+column:suggesttype+==2and+column:status+==0:+column:status+==0\"></popedom> ";
 	       	operateString+="     <operate href=\"javascript:doAdd();\" text=\""+SystemEnv.getHtmlLabelName(126516,user.getLanguage())+"\" index=\"0\"/>";
 	       	operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(126517,user.getLanguage())+"\" index=\"1\"/>";
 	       	operateString+="     <operate href=\"javascript:doChangeStatus()\" text=\""+SystemEnv.getHtmlLabelName(126518,user.getLanguage())+"\" index=\"2\"/>";
 	       	operateString+="</operates>";
				tableString =" <table pageId=\""+PageIdConst.Hrm_HrmGroupSuggestList+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.Hrm_HrmGroupSuggestList,user.getUID(),Constants.HRM)+"\" tabletype=\"none\">"+
				" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"asc\" sqlisdistinct=\"true\"/>"+
		    operateString+
		    "	<head>"+
		    "		<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(15175,user.getLanguage())+"\" column=\"createdate\" orderkey=\"createdate\" />"+
				"		<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(616,user.getLanguage())+"\" column=\"creater\" orderkey=\"creater\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" linkvaluecolumn=\"creater\" linkkey=\"id\" href=\"/hrm/HrmTab.jsp?_fromURL=HrmResource\" target=\"_fullwindow\" />"+
				"		<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(126442,user.getLanguage())+"\" column=\"suggesttitle\" orderkey=\"suggesttitle\" />"+
				"		<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(126437,user.getLanguage())+"\" column=\"groupname\" orderkey=\"groupname\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmGroup\" otherpara=\"column:groupid\"/>"+
				"		<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(15821,user.getLanguage())+"\" column=\"suggesttype\" orderkey=\"suggesttype\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmGroupSuggestType\" otherpara=\""+user.getLanguage()+"\"/>"+
				"		<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(22045,user.getLanguage())+"\" column=\"content\" orderkey=\"content\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getMulResourcename\" />"+
				"		<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"status\" orderkey=\"status\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmGroupSuggestStatus\" otherpara=\""+user.getLanguage()+"\"/>"+
		    "	</head>"+
		    " </table>";
		%>
		<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.Hrm_HrmGroupSuggestList %>"/>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
		<%if("1".equals(isDialog)){ %>
  </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
	    	</wea:item>
	   	</wea:group>
	  </wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
	</BODY>
</HTML>