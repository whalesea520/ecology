
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- modified by wcd 2014-07-07 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<%
	boolean cansave = HrmUserVarify.checkUserRight("CustomGroup:Edit", user);
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(17617,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String cmd = Util.null2String(request.getParameter("cmd"));
	String id = Util.null2String(request.getParameter("id"));
	
	String qname = Util.null2String(request.getParameter("flowTitle"));
	String _name = Util.null2String(request.getParameter("name"));
	String _type = Util.null2String(request.getParameter("type"));
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script type="text/javascript">
			var dialog = null;
			var dWidth = 700;
			var dHeight = 500;
			
			function onBtnSearchClick(){
				jQuery("#searchfrm").submit();
			}
			
			function doDel(id){
				if(!id){
					id = _xtable_CheckedCheckboxId();
				}
				if(!id){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
					return;
				}
				if(id.match(/,$/)){
					id = id.substring(0,id.length-1);
				}
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
					var idArr = id.split(",");
					var ajaxNum = 0;
					for(var i=0;i<idArr.length;i++){
						ajaxNum++;
						jQuery.ajax({
							url:"GroupOperation.jsp?operation=deletegroup&groupid="+idArr[i],
							type:"post",
							async:true,
							complete:function(xhr,status){
								ajaxNum--;
								if(ajaxNum==0){
									_table.reLoad();
								}
							}
						});
					}
				});
			}
			
			function closeDialog(){
				if(dialog)
					dialog.close();
				window.location.href="/hrm/group/HrmGroup.jsp";
			}
			
			function doOpen(url,title,_dWidth,_dHeight){
				if(dialog==null){
					dialog = new window.top.Dialog();
				}
				dialog.currentWindow = window;
				dialog.Title = title;
				dialog.Width = _dWidth ? _dWidth : dWidth;
				dialog.Height = _dHeight ? _dHeight : dHeight;
				dialog.Drag = true;
				dialog.maxiumnable = true;
				dialog.URL = url;
				dialog.show();
			}
			
			function doAddBase(){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmGroup&method=HrmGroupBaseAdd&isdialog=1","<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>");
			}
			
			function doDetail(id){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmGroup&method=HrmGroupBaseAdd&cmd=edit&showpage=1&isdialog=1&id="+id,"<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>");
			}
			
			function doEdit(id){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmGroup&method=HrmGroupBaseAdd&cmd=edit&showpage=1&isdialog=1&id="+id,"<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>");
			}
			
			function doShow(id){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmGroup&method=HrmGroupAdd&cmd=show&isdialog=1&id="+id,"<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())+SystemEnv.getHtmlLabelName(17748,user.getLanguage())%>");
			}
			
			function doMember(id){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmGroup&method=HrmGroupMember&cmd=edit&isdialog=1&showpage=2&id="+id,"<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>");
			}
			
			function doShare(id){
				//doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmGroup&method=HrmGroupAdd&cmd=share&isdialog=1&id="+id,"<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(17748,user.getLanguage())%>");
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmGroup&method=HrmGroupShare&cmd=edit&isdialog=1&showpage=3&id="+id,"<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>");
			}
			
			function doRemind(status){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmGroup&method=HrmGroupSuggestList&status="+status+"&isdialog=1","<%=SystemEnv.getHtmlLabelName(126253,user.getLanguage())%>",900,450);
			}
			
			function openImportDialog(){
				dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				dialog.Title = "<%=SystemEnv.getHtmlLabelName(125445,user.getLanguage())%>";;
				dialog.Width = 800;
				dialog.Height = 600;
				dialog.Drag = true;
				dialog.URL = "/hrm/HrmDialogTab.jsp?_fromURL=HrmResourceImport&importtype=group&title=125445";
				dialog.show();
			}
			
			function jsChangeRemindImg(){
				window.location.reload();
			}
		</script>
	</head>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:doAddBase();,_self} " ;
		RCMenuHeight += RCMenuHeightStep;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(18596,user.getLanguage())+",javascript:openImportDialog();,_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel();,_self} " ;
		RCMenuHeight += RCMenuHeightStep;
		
		boolean hasSuggest = false;
		String sql = "SELECT COUNT(1) from SysPoppupRemindInfoNew where type=25 and exists(select t2.id from HrmGroupSuggest t2 where t2.id=SysPoppupRemindInfoNew.requestid and status=0 ) ";
		if(user.getUID()==1){
			//管理员能看所有的
		}else{
			sql += " AND userid= "+user.getUID();
		}
		rs.executeSql(sql);
		if(rs.next()){
			if(rs.getInt(1)>0)hasSuggest = true;
		}
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form action="" name="searchfrm" id="searchfrm">
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<%if(cansave){
							if(hasSuggest){	
						%>
						<input type=button style="background:url(/hrm/group/icon/remind.png) no-repeat;border:0px;padding-left: 22px !important;height: 22px;cursor:pointer;" onclick="javascript:doRemind(0);"/>
						<%}else{ %>
						<input type=button style="background:url(/hrm/group/icon/remind1.png) no-repeat;border:0px;padding-left: 22px !important;height: 22px;cursor:pointer;" onclick="javascript:doRemind(1);"/>
						<%}} %>
						<input type=button class="e8_btn_top" onclick="doAddBase();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
						<input type=button class="e8_btn_top" onclick="openImportDialog();" value="<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%>"></input>
						<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
						<input type="text" class="searchInput" name="flowTitle" value="<%=_name %>"/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
						<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
				<wea:layout type="4col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
						<wea:item><input type="text" id="name" name="name" class="inputStyle" value='<%=_name%>'></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
						<wea:item>
							<span>
								<select class=inputstyle id="type" name="type">
									<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
									<option value="0" <%=_type.equals("0") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(17618,user.getLanguage())%></option>
									<option value="1" <%=_type.equals("1") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(17619,user.getLanguage())%></option>
								</select>
							</span>
						</wea:item>
					</wea:group>
					<wea:group context="">
						<wea:item type="toolbar">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick()"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
						</wea:item>
					</wea:group>
				</wea:layout>
			</div>
		</form>
		<%
			boolean isOracle = rs.getDBType().toUpperCase().equals("ORACLE");
			String backfields = " a.id,a.type,a.name,a.owner,a.sn,"+(isOracle?" nvl(b.result,0) ":"ISNULL(b.result,0)")+" result"; 
			String fromSql  = " HrmGroup a left join (select a.groupid,COUNT(*) as result from hrmgroupmembers a left join HrmResource b on a.userid=b.id where b.lastname is not null group by a.groupid) b on a.id = b.groupid";
			String sqlWhere = " where 1 = 1 and ((a.owner="+user.getUID()+" and a.type=0) "+(cansave?"or a.type = 1 ":"")+") ";
			String orderby = " a.type,a.sn " ;
			String tableString = "";
			
			if(qname.length() > 0){
				sqlWhere += " and a.name like '%"+qname+"%' ";
			}else if(_name.length() > 0){
				sqlWhere += " and a.name like '%"+_name+"%' ";
			}
			
			if(_type.length() > 0){
				sqlWhere += " and a.type = "+_type;
			}
			
			String operateString= "<operates width=\"20%\">";
			 operateString+=" <popedom transmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicOperate\" otherpara=\"true:+column:type+==0or"+String.valueOf(cansave)+":+column:type+==1and"+String.valueOf(cansave)+":(+column:type+==1and"+String.valueOf(cansave)+"and(+column:owner+=="+user.getUID()+"or"+(user.getUID()==1)+"))or(+column:type+==0and+column:owner+=="+user.getUID()+")\"></popedom> ";
 	     operateString+="     <operate href=\"javascript:doEdit();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
 	     operateString+="     <operate href=\"javascript:doMember()\" text=\""+SystemEnv.getHtmlLabelName(431,user.getLanguage())+"\" index=\"1\"/>";
			 operateString+="     <operate href=\"javascript:doShare()\" text=\""+SystemEnv.getHtmlLabelName(19910,user.getLanguage())+"\" index=\"2\"/>";
 	     operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"3\"/>";
			 operateString+="</operates>";
			tableString =" <table pageId=\""+Constants.HRM_Q_000+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Q_000,user.getUID(),Constants.HRM)+"\" tabletype=\"checkbox\">"+
			" <checkboxpopedom showmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicCheckbox\"  id=\"checkbox\"  popedompara=\"(+column:type+==1and"+String.valueOf(cansave)+"and(+column:owner+=="+user.getUID()+"or"+(user.getUID()==1)+"))or(+column:type+==0and+column:owner+=="+user.getUID()+") \" />"+
			" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"asc\" sqlisdistinct=\"true\"/>"+
		    operateString+
		    "	<head>"+
		    "		<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(84,user.getLanguage())+"\" column=\"id\" orderkey=\"id\" />"+
			"		<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"type\" orderkey=\"type\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:array["+user.getLanguage()+";0=17618,default=17619]}\"/>"+
			"		<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmGroup\" otherpara=\"column:id\"/>"+
			"		<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(431,user.getLanguage())+"\" column=\"result\" orderkey=\"result\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmGroupMembers\" otherpara=\"column:id\"/>"+
			"		<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(338,user.getLanguage())+"\" column=\"sn\" orderkey=\"sn\" />"+
		    "	</head>"+
		    " </table>";
		%>
		<input type="hidden" name="pageId" id="pageId" value="<%= Constants.HRM_Q_000 %>"/>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
	</BODY>
</HTML>