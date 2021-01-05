
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- modified by wcd 2014-08-06 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="SalaryComInfo" class="weaver.hrm.finance.SalaryComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<%
	String imagefilename = "/images/hdReport_wev8.gif" ; 
	String titlename = SystemEnv.getHtmlLabelName(6139 , user.getLanguage()) ; 
	String needfav = "1" ; 
	String needhelp = "" ;
	
	String subcompanyid = Util.null2String(request.getParameter("subcompanyid") ) ;
	//if(subcompanyid.length()==0)subcompanyid="0";
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	int operatelevel=-1;
	if(detachable==1){
		operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmScheduleDiffAdd:Add",Util.getIntValue(subcompanyid,0));
	}else{
		if(HrmUserVarify.checkUserRight("HrmScheduleDiffAdd:Add", user))
			operatelevel=2;
	}
	if(operatelevel<0){
				response.sendRedirect("/notice/noright.jsp") ;
				return ;
	}
	boolean CanAdd=false;
	if(operatelevel>0)
		CanAdd=true;

	String rolelevel=CheckUserRight.getRightLevel("HrmScheduleDiffAdd:Add" , user);
	String navName = "";
	if(!subcompanyid.equals(0))navName = SubCompanyComInfo.getMoreSubCompanyname(subcompanyid);
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
							url:"HrmScheduleDiffOperation.jsp?isdialog=1&operation=delete&id="+idArr[i],
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
			var dialog = null;
			var dWidth = 500;
			var dHeight = 400;
			function closeDialog(){
				if(dialog)
					dialog.close();
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
			
			function doAdd(){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=HrmScheduleDiffAdd&subcompanyid=<%=subcompanyid%>","<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(6139,user.getLanguage())%>");
			}
			
			function doEdit(id){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=HrmScheduleDiffEdit&isdialog=1&id="+id,"<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(6139,user.getLanguage())%>");
			}
		
			function doLog(id){
				doOpen("/systeminfo/SysMaintenanceLog.jsp?isdialog=1&sqlwhere=where operateitem=17 and relatedid="+id,"<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>",jQuery(window).width(),jQuery(window).height());
			}
			
			function showAllLog(){
				var url = "/systeminfo/SysMaintenanceLog.jsp?subcompanyid=<%=subcompanyid%>&sqlwhere=where operateitem=17";
				doOpen(url,"<%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%>",jQuery(window).width(),jQuery(window).height());
			}
		</script>
	</head>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
		if(CanAdd){ 
			RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",javascript:doAdd(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:showAllLog(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form action="" name="searchfrm" id="searchfrm">
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td>
					</td>
					<td class="rightSearchSpan" style="text-align:right;">
						<%if(CanAdd){ %>
							<input type=button class="e8_btn_top" onclick="doAdd();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
							<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
						<%} %>
						<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
		</form>
		<%
			String backfields = " a.id,a.diffname,a.diffscope,a.diffdesc,a.subcompanyid,b.subcompanyname "; 
			String fromSql  = " from HrmScheduleDiff a left join HrmSubCompany b on a.subcompanyid = b.id ";
			String sqlWhere = " where 1 = 1 ";
			String orderby = " a.id " ;
			String tableString = "";
			
			if(subcompanyid.length() > 0){
				sqlWhere += " and a.subcompanyid = "+subcompanyid;
			}
			
			String operateString= "<operates width=\"20%\">";
 	    	operateString+=" <popedom transmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicOperate\" otherpara=\""+String.valueOf(CanAdd)+":"+String.valueOf(CanAdd)+":"+String.valueOf(CanAdd)+"\"></popedom> ";
 	       	operateString+="     <operate href=\"javascript:doEdit();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
 	       	operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
 	       	operateString+="</operates>";
			tableString =" <table pageId=\""+Constants.HRM_Z_060+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_060,user.getUID(),Constants.HRM)+"\" tabletype=\"checkbox\">"+
				" <checkboxpopedom showmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicCheckbox\"  id=\"checkbox\"  popedompara=\"true\" />"+
				" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
		    operateString+
		    "	<head>"+
		    "		<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"diffname\" orderkey=\"diffname\" />"+
		    "		<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(19374,user.getLanguage())+"\" column=\"diffscope\" orderkey=\"diffscope\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:array["+user.getLanguage()+";default=141and18921,0=140,1=141]}\"/>"+
			"		<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(17868,user.getLanguage())+"\" column=\"subcompanyname\" orderkey=\"subcompanyname\"/>"+
		    "		<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(85,user.getLanguage())+"\" column=\"diffdesc\" orderkey=\"diffdesc\" />"+
		    "	</head>"+
		    " </table>";
		%>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
	</BODY>
</HTML>
