
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- modified by wcd 2014-06-17 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
	boolean hasright = false;
	if(HrmUserVarify.checkUserRight("HrmCareerInviteAdd:Add", user)){
	  hasright = true;
	}
	
	if(!hasright){
	     response.sendRedirect("/notice/noright.jsp");
	     return;
	}
	
	String planid = Util.null2String(request.getParameter("planid"));
	String cmd = Util.null2String(request.getParameter("cmd"));
	String qname = Util.null2String(request.getParameter("flowTitle"));
	String jobtitle = Util.null2String(request.getParameter("jobtitle"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(366,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script type="text/javascript">
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
						url:"save.jsp?isdialog=1&operation=delete&planid=<%=planid%>&inviteId="+idArr[i],
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
		
		var parentDialog = parent.parent.getDialog(parent);
		
		var dialog = null;
		var dWidth = 880;
		var dHeight = 500;;
		var _id = "";
		var _name = "";
		
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
		function closeDialog(cmd,planid){
			if(dialog)
				dialog.close();
			if(_id != null){
				window.location.href="/hrm/career/inviteinfo/save.jsp?operation=addinvite&planid=<%=planid%>&ids="+_id;
			}else{
				var param = "";
				if(cmd!=null && planid != null){
					param += "?cmd="+cmd+"&planid="+planid;
				}
				window.location.href="/hrm/career/inviteinfo/list.jsp"+param;
			}
		}
		
		function openDialog(id){
			if(window.top.Dialog){
				dialog = new window.top.Dialog();
			} else {
				dialog = new Dialog();
			}
			dialog.currentWindow = window;
			if(id == null){
				id = "";
			}
			var url = "";
			if(!!id){
				dialog.Title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(366,user.getLanguage())%>";
				url = "/hrm/HrmDialogTab.jsp?_fromURL=inviteInfo&method=edit&cmd=<%=cmd%>&planid=<%=planid%>&isdialog=1&id="+id;
				dialog.Modal = true;
				dialog.maxiumnable = true;
			}else{
				dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(366,user.getLanguage())%>";
				url = "/hrm/HrmDialogTab.jsp?_fromURL=inviteInfo&method=add&cmd=<%=cmd%>&planid=<%=planid%>&isdialog=1";
				dialog.Drag = true;
			}
			dialog.Width = 880;
			dialog.Height = 500;
			dialog.URL = url;
			dialog.show();
		}
		
		function showDetail(id){
			doOpen("/hrm/HrmDialogTab.jsp?_fromURL=inviteInfo&method=show&cmd=<%=cmd%>&planid=<%=planid%>&isdialog=1&id="+id,"<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())+SystemEnv.getHtmlLabelName(366,user.getLanguage())%>",880,500);
		}
		
		function showApplyInfo(id){
			doOpen("/hrm/HrmDialogTab.jsp?_fromURL=inviteInfo&method=showapplyinfo&cmd=<%=cmd%>&planid=<%=planid%>&isdialog=1&id="+id,"<%=SystemEnv.getHtmlLabelName(1863,user.getLanguage())+SystemEnv.getHtmlLabelName(33292,user.getLanguage())%>",880,500);
		}
		
		function onLog(id){
			var url = "";
			if(id && id!=""){
				url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=58 and relatedid=")%>&relatedid="+id;
			}else{
				url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=58")%>";
			}
			doOpen(url,"<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>",jQuery(window).width(),jQuery(window).height());
		}
		
		function selectInviteInfo(){
			doOpen("/systeminfo/BrowserMain.jsp?url=/hrm/career/inviteinfo/MultiInviteBrowser.jsp&cmd=cleanMID","<%=SystemEnv.getHtmlLabelNames("33251,366",user.getLanguage())%>",550,520);
		}
		</script>
	</head>
	<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			if(HrmUserVarify.checkUserRight("HrmCareerInviteAdd:Add", user)){				
				if(cmd.equals("notchangeplan") && planid.length() > 0){
					RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:selectInviteInfo();,_self} " ;
					RCMenuHeight += RCMenuHeightStep ;
				}
				RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog();,_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			if(HrmUserVarify.checkUserRight("HrmCareerInviteEdit:Delete", user)){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel();,_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form action="" name="searchfrm" id="searchfrm">
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<%
							if(HrmUserVarify.checkUserRight("HrmCareerApplyAdd:Add", user)){ 
								if(cmd.equals("notchangeplan") && planid.length() > 0){
						%>
								<input type=button class="e8_btn_top" onclick="selectInviteInfo();" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
						<%
								}
						%>
								<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
						<%	
							}
							if(HrmUserVarify.checkUserRight("HrmCareerInviteEdit:Delete", user)){ 
						%>
								<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
						<%	} %>
						<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
						<input type="hidden" name="planid" value="<%=planid %>"/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
				<wea:layout type="2col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item>
						<wea:item>
							<span>
								<brow:browser viewType="0" name="jobtitle" browserValue="" 
					                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp"
					                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					                completeUrl="/data.jsp?type=hrmjobtitles" width="30%" browserSpanValue="">
					        	</brow:browser>
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
			String backFields = " a.id,a.careername,j.jobtitlename,a.careerpeople,a.careersex,a.careeredu,a.createrid,a.createdate,a.isweb "; 
			String sqlFrom  = " from HrmCareerInvite a left join HrmJobTitles j on a.careername = j.id ";
			String sqlWhere = " where 1 = 1 ";
			String orderby = " a.createdate " ;
			String tableString = "";
			
			if(cmd.equals("notchangeplan") && planid.length() > 0){
				sqlWhere += " and a.careerplanid = "+planid;
			}
			if(!qname.equals("")){
				sqlWhere += " and j.jobtitlename like '%"+qname+"%' ";
			} else if (!"".equals(jobtitle)) {
				sqlWhere += " and a.careername  = "+jobtitle;
			}
			String operateString= "<operates width=\"20%\">";
 	    	operateString+=" <popedom transmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicOperate\" otherpara=\"+column:isweb+==1and"+HrmUserVarify.checkUserRight("HrmCareerInviteAdd:add", user)+":"+HrmUserVarify.checkUserRight("HrmCareerInviteEdit:Edit", user)+":"+HrmUserVarify.checkUserRight("HrmCareerInviteEdit:Delete", user)+":"+HrmUserVarify.checkUserRight("HrmCareerInvite:log", user)+":"+HrmUserVarify.checkUserRight("HrmCareerInviteEdit:Edit", user)+"\"></popedom> ";
 	       	operateString+="     <operate href=\"javascript:showDetail();\" text=\""+SystemEnv.getHtmlLabelName(221,user.getLanguage())+"\" index=\"0\"/>";
			operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"1\"/>";
 	       	operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"2\"/>";
 	       	operateString+="     <operate href=\"javascript:onLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"3\"/>";
			operateString+="     <operate href=\"javascript:showApplyInfo()\" text=\""+(SystemEnv.getHtmlLabelName(1863,user.getLanguage())+SystemEnv.getHtmlLabelName(33292,user.getLanguage()))+"\" index=\"4\"/>";
 	       	operateString+="</operates>";
			
			tableString=""+
				"<table pageId=\""+Constants.HRM_Z_053+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_053,user.getUID(),Constants.HRM)+"\" tabletype=\"checkbox\">"+
					" <checkboxpopedom showmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicCheckbox\"  id=\"checkbox\"  popedompara=\"true\" />"+
					"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"a.id\" sqlorderby=\""+orderby+"\" sqlsortway=\"Desc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"/>"+
					operateString+
					"<head>"+                             
						"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(6086,user.getLanguage())+"\" column=\"careername\" orderkey=\"careername\" transmethod=\"weaver.hrm.job.JobTitlesComInfo.getJobTitlesname\"/>"+
						"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(714,user.getLanguage())+"\" column=\"id\" orderkey=\"id\" transmethod=\"weaver.hrm.HrmTransMethod.getCode\" otherpara=\"12\"/>"+
						"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(1859,user.getLanguage())+"\" column=\"careerpeople\" orderkey=\"careerpeople\"/>"+
						"<col width=\"12%\"  text=\""+SystemEnv.getHtmlLabelName(416,user.getLanguage())+"\" column=\"careersex\" orderkey=\"careersex\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:array["+user.getLanguage()+";0=417,1=418,2=763]}\"/>"+
						"<col width=\"13%\"  text=\""+SystemEnv.getHtmlLabelName(1860,user.getLanguage())+"\" column=\"careeredu\" orderkey=\"careeredu\" transmethod=\"weaver.hrm.job.EducationLevelComInfo.getEducationLevelname\" />"+
						"<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(17883,user.getLanguage())+"\"  column=\"createdate\" orderkey=\"createdate\"/>"+ 
					"</head>"+
				"</table>";
		%>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" /> 
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="parentDialog.close();">
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
