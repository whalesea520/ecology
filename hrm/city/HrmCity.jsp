
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- modified by wcd 2014-07-02 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<%
	String cmd = Util.null2String(request.getParameter("cmd"));
	String qname = Util.null2String(request.getParameter("flowTitle"));
	String provinceName = Util.null2String(request.getParameter("provinceName"));
	String provinceid = Util.null2String(request.getParameter("provinceid"));
	if (provinceid.equals("0")){
		provinceid = "";
	}
	String countryid = Util.null2String(request.getParameter("countryid"));
	if (countryid.equals("0")){
		countryid = "";
	}
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(800,user.getLanguage());
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
							url:"ProvinceOperation.jsp?operation=delete&id="+idArr[i],
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
				window.location.href="/hrm/province/HrmProvince.jsp";
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
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmProvince&method=HrmProvinceAdd&countryid=<%=countryid%>&isdialog=1","<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(800,user.getLanguage())%>");
			}
			
			function doEdit(id){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmProvince&method=HrmProvinceEdit&isdialog=1&id="+id,"<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(800,user.getLanguage())%>");
			}
		
			function doLog(id){
				doOpen("/systeminfo/SysMaintenanceLog.jsp?isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=61 and relatedid=")%>&relatedid="+id,"<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>",jQuery(window).width(),jQuery(window).height());
			}
			
			function showCity(id){
				window.location.href = "/hrm/city/HrmCityList.jsp?provinceid="+id;
			}
			
			function showAllLog(){
				var _sqlwhere = "<%=rs.getDBType().equals("db2")?"int(operateitem)":"operateitem"%>";
				var url = "/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where "+_sqlwhere+"=61";
				doOpen(url,"<%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%>",jQuery(window).width(),jQuery(window).height());
			}
			
			jQuery(document).ready(function(){
				if('<%=cmd%>' == 'f' || "<%=provinceid.length()%>" != "0"){
					showCity('<%=provinceid%>');
				}
			})
		</script>
	</head>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			if(HrmUserVarify.checkUserRight("HrmProvince:Log", user)){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:showAllLog();,_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form action="" name="searchfrm" id="searchfrm">
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<input type="text" class="searchInput" name="flowTitle" value="<%=qname%>"/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
				<wea:layout type="4col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(800,user.getLanguage())%></wea:item>
						<wea:item><input type="text" id="provinceName" name="provinceName" class="inputStyle" value='<%=provinceName%>'></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></wea:item>
						<wea:item>
							<span>
								<brow:browser viewType="0" name="countryid" browserValue='<%=countryid%>' 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp"
									hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
									completeUrl="/data.jsp?type=1111" width="60%" browserSpanValue='<%=CountryComInfo.getCountryname(countryid)%>'>
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
			String _sql = rs.getDBType().equals("oracle")?"where nvl(a.canceled,0) != 1":"where ISNULL(a.canceled,0) != 1";
			String backfields = " a.id,a.provincename,a.provincedesc,a.canceled,a.countryid,c.countryname,(case when b.result IS NULL then 0 else b.result end) as result "; 
			String fromSql  = " from HrmProvince a left join ( select a.provinceid,count(a.id) as result from HrmCity a "+_sql+" group by a.provinceid ) b on a.id = b.provinceid left join HrmCountry c on a.countryid = c.id ";
			String sqlWhere = " where 1 = 1 and (a.canceled is null or a.canceled = 0) ";
			String orderby = " a.id " ;
			String tableString = "";
			
			if(qname.length() > 0){
				sqlWhere += " and a.provincename like '%"+qname+"%'";
			}else if(provinceName.length() > 0){
				sqlWhere += " and a.provincename like '%"+provinceName+"%'";
			}
			if(countryid.length() > 0){
				sqlWhere += " and a.countryid = "+countryid;
			}
			if(provinceid.length() > 0){
				sqlWhere += " and a.id = "+provinceid;
			}
			
			String operateString= "<operates width=\"20%\">";
 	    	operateString+=" <popedom transmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicOperate\" otherpara=\""+HrmUserVarify.checkUserRight("HrmProvinceEdit:Edit", user)+":"+HrmUserVarify.checkUserRight("HrmProvinceEdit:log", user)+"\"></popedom> ";
 	       	operateString+="     <operate href=\"javascript:showCity();\" text=\""+SystemEnv.getHtmlLabelNames("367,493",user.getLanguage())+"\" index=\"0\"/>";
 	       	operateString+="     <operate href=\"javascript:doLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"1\"/>";
 	       	operateString+="</operates>";
			tableString =" <table pageId=\""+Constants.HRM_Z_032+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_032,user.getUID(),Constants.HRM)+"\" tabletype=\"none\">"+
				" <checkboxpopedom showmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicCheckbox\"  id=\"checkbox\"  popedompara=\"column:result+==0\" />"+
				" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
		    operateString+
		    "	<head>"+
		    "		<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(800,user.getLanguage())+"\" column=\"provincename\" orderkey=\"provincename\" />"+
		    "		<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelNames("33476,377",user.getLanguage())+"\" column=\"countryname\" orderkey=\"countryname\" />"+
			"		<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelNames("493,1331",user.getLanguage())+"\" column=\"result\" orderkey=\"result\" linkkey=\"provinceid\" linkvaluecolumn=\"id\" href=\"HrmCity.jsp?cmd=f\" target=\"_self\"/>"+
		    "	</head>"+
		    " </table>";
		%>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
	</BODY>
</HTML>
