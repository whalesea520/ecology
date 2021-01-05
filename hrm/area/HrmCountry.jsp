
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- modified by wcd 2014-07-02 [E7 to E8] -->
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ include file="/hrm/header.jsp" %>
<%
	String cmd = Util.null2String(request.getParameter("cmd"));
	String qname = Util.null2String(request.getParameter("flowTitle"));
	String countryname= Util.null2String(request.getParameter("countryname"));
	if(qname.length()==0 && countryname.length()>0)qname = countryname;
	if(countryname.length()==0&&qname.length()>0)countryname=qname;
	String countrydesc= Util.null2String(request.getParameter("countrydesc"));
	String countryid = Util.null2String(request.getParameter("countryid"));
	if (countryid.equals("0")){
		countryid = "";
	}
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(377,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script type="text/javascript">
			function onBtnSearchClick(){
				jQuery("#searchfrm").submit();
			}
			var _cmd = "";
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
							url:"CountryOperation.jsp?operation=delete&id="+idArr[i],
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
					if(_cmd == "closeDialog"){
						closeDialog();
					}
				});
			}
			var dialog = null;
			var dWidth = 500;
			var dHeight = 300;
			function closeDialog(){
				if(dialog)
					dialog.close();
					onBtnSearchClick();
				//window.parent.contentframe1.window.location.reload();
				//window.location.href="/hrm/area/HrmCountries.jsp";
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
			
			function doCanceled(id){
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22153,user.getLanguage())%>",function(){
				  var ajax=ajaxinit();
				  ajax.open("POST", "/hrm/area/HrmCanceledCheck.jsp", true);
				  ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
				  ajax.send("ope=country&cancelFlag=0&id="+id);
				  ajax.onreadystatechange = function() {
					if (ajax.readyState == 4 && ajax.status == 200) {
						try{
						   window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22155, user.getLanguage())%>");
						   onBtnSearchClick();
						}catch(e){
							return false;
						}
					}
				 }
			  });
			}

			function doISCanceled(id){
			   window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22154,user.getLanguage())%>",function(){
				  var ajax=ajaxinit();
				  ajax.open("POST", "/hrm/area/HrmCanceledCheck.jsp", true);
				  ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
				  ajax.send("ope=country&cancelFlag=1&id="+id);
				  ajax.onreadystatechange = function() {
					if (ajax.readyState == 4 && ajax.status == 200) {
						try{
						  window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22156, user.getLanguage())%>");
						  onBtnSearchClick();
						}catch(e){
							return false;
						}
					}
				 }
			   });
			 }
			function doImport(){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=HrmResourceImport&importtype=area&title=126168","<%=SystemEnv.getHtmlLabelName(126168,user.getLanguage())%>",800,600);
			}
			function showProvince(id){
				window.location.href = "/hrm/area/HrmProvinceList.jsp?countryid="+id;
			}
		
			function doLog(id){
				doOpen("/systeminfo/SysMaintenanceLog.jsp?isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=22 and relatedid=")%>&relatedid="+id,"<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>",jQuery(window).width(),jQuery(window).height());
			}
			
			function doAdd(){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmAreaCountries&method=HrmCountriesAdd&isdialog=1","<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(377,user.getLanguage())%>",600,420);
			}
			
			function doEdit(id){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmAreaCountries&method=HrmCountriesEdit&isdialog=1&id="+id,"<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(377,user.getLanguage())%>",600,420);
			}
			
			function showAllLog(){
				var _sqlwhere = "<%=rs.getDBType().equals("db2")?"int(operateitem)":"operateitem"%>";
				var url = "/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where "+_sqlwhere+"=22";
				doOpen(url,"<%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%>",jQuery(window).width(),jQuery(window).height());
			}
			
			function reloadTable(){
				_table.reLoad();
			}
			function showProvinceToParent(id){
				window.parent.location.href = "/hrm/HrmTab.jsp?_fromURL=hrmAreaProvince&countryid="+id;
			}
			
			jQuery(document).ready(function(){
				if('<%=cmd%>' == 'f' || '<%=countryid.length()%>' != '0'){
					showProvince('<%=countryid%>');
				}
			})
		</script>
	</head>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
		if(HrmUserVarify.checkUserRight("HrmCountriesAdd:Add", user)){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:doAdd();,_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(18596,user.getLanguage())+",javascript:doImport();,_self} " ;
			RCMenuHeight += RCMenuHeightStep;
		}
		if(HrmUserVarify.checkUserRight("HrmCountriesEdit:Delete", user)){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel();,_self} " ;
			RCMenuHeight += RCMenuHeightStep;
		}
			if(HrmUserVarify.checkUserRight("HrmCountries:Log", user)){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:showAllLog();,_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<%
						if(HrmUserVarify.checkUserRight("HrmCountriesAdd:Add", user)){ 
					%>
							<input type=button class="e8_btn_top" onclick="doAdd();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
							<input type=button class="e8_btn_top" onclick="doImport();" value="<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%>"></input>
					<%	
						}
						if(HrmUserVarify.checkUserRight("HrmCountriesEdit:Delete", user)){ 
					%>
							<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
					<%	} %>
					<input type="text" class="searchInput" name="flowTitle" value="<%=qname%>" id="flowTitle" onchange="setKeyword('flowTitle','countryname','searchfrm');"/>
					<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<form action="" name="searchfrm" id="searchfrm">
			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
				<wea:layout type="4col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelNames("377,399",user.getLanguage())%></wea:item>
						<wea:item><input type="text" id="countryname" name="countryname" class="inputStyle" value='<%=countryname %>'></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelNames("377,15767",user.getLanguage())%></wea:item>
						<wea:item><input type="text" id="countrydesc" name="countrydesc" class="inputStyle" value='<%=countrydesc%>'></wea:item>
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
			//String _sql = rs.getDBType().equals("oracle")?"where nvl(a.canceled,0) != 1":"where ISNULL(a.canceled,0) != 1";
			String backfields = " a.id,a.countryname,a.countrydesc,(case when a.canceled IS NULL then '0' else a.canceled end) as canceled,(case when b.result IS NULL then 0 else b.result end) as result "; 
			String fromSql  = " from HrmCountry a left join ( select a.countryid,count(a.id) as result from HrmProvince a  group by a.countryid ) b on a.id = b.countryid ";
			String sqlWhere = " where 1=1 ";
			String orderby = " a.id " ;
			String tableString = "";
			
			if(qname.length() > 0){
				sqlWhere += " and a.countryname like '%"+qname+"%'";
			}else if(countryname.length() > 0){
				sqlWhere += " and a.countryname like '%"+countryname+"%'";
			}
			
			if(countrydesc.length() > 0){
				sqlWhere += " and a.countrydesc like '%"+countrydesc+"%'";
			}

			
			if(countryid.length() > 0){
				sqlWhere += " and a.id = "+countryid;
			}
			
			String operateString= "<operates width=\"20%\">";
 	    	operateString+=" <popedom transmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicOperate\" otherpara=\""+HrmUserVarify.checkUserRight("HrmCountriesEdit:Edit", user)+":+column:result+==0and"+HrmUserVarify.checkUserRight("HrmCountriesEdit:Delete", user)+":+column:canceled+==0and"+HrmUserVarify.checkUserRight("HrmCountriesEdit:Edit", user)+":+column:canceled+==1and"+HrmUserVarify.checkUserRight("HrmCountriesEdit:Edit", user)+":"+HrmUserVarify.checkUserRight("HrmCountriesEdit:log", user)+"\"></popedom> ";
 	       	operateString+="     <operate href=\"javascript:doEdit();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
 	       	operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
 	       	operateString+="     <operate href=\"javascript:doCanceled();\" text=\""+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+"\" index=\"2\"/>";
 	       	operateString+="     <operate href=\"javascript:doISCanceled();\" text=\""+SystemEnv.getHtmlLabelName(22152,user.getLanguage())+"\" index=\"3\"/>";
 	       	operateString+="     <operate href=\"javascript:doLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"4\"/>";
 	       	operateString+="</operates>";
			tableString =" <table pageId=\""+Constants.HRM_Z_031+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_031,user.getUID(),Constants.HRM)+"\" tabletype=\"checkbox\">"+
				" <checkboxpopedom showmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicCheckbox\"  id=\"checkbox\"  popedompara=\"column:result+==0\" />"+
				" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
		    operateString+
		    "	<head>"+
		    "		<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelNames("377,399",user.getLanguage())+"\" column=\"countryname\" orderkey=\"countryname\" transmethod=\"weaver.hrm.HrmTransMethod.openDialogForHrmAreaEdit\" otherpara=\"column:id\" />"+
		    "		<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelNames("377,15767",user.getLanguage())+"\" column=\"countrydesc\" orderkey=\"countrydesc\" />"+
			"		<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelNames("800,1331",user.getLanguage())+"\" column=\"result\" orderkey=\"result\" transmethod=\"weaver.hrm.HrmTransMethod.openshowProvinceToParent\" otherpara=\"column:id\"/>"+//linkkey=\"countryid\" linkvaluecolumn=\"id\" href=\"HrmProvince.jsp?cmd=f\" target=\"_self\"
			"		<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelNames("602",user.getLanguage())+"\" column=\"canceled\" orderkey=\"canceled\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:style[1=color:red]}{cmd:array["+user.getLanguage()+";default=225,1=22205]}\"/>"+//linkkey=\"countryid\" linkvaluecolumn=\"id\" href=\"HrmProvince.jsp?cmd=f\" target=\"_self\"
		    "	</head>"+
		    " </table>";
		%>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
	</BODY>
</HTML>
