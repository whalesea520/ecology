
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- modified by wcd 2014-07-02 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
	String qname = Util.null2String(request.getParameter("flowTitle"));
	String cityName = Util.null2String(request.getParameter("cityName"));
	String provinceid = Util.null2String(request.getParameter("provinceid"));
	String countryid = Util.null2String(request.getParameter("countryid"));
	
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(493,user.getLanguage());
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
							url:"CityOperation.jsp?operation=delete&id="+idArr[i],
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
				if(dialog){
					dialog.close();
					onBtnSearchClick();	
				}
				//window.location.href="/hrm/city/HrmCity.jsp";
			}
			function doCanceled(id){
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22153,user.getLanguage())%>",function(){
				  var ajax=ajaxinit();
				  ajax.open("POST", "/hrm/country/HrmCanceledCheck.jsp", true);
				  ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
				  ajax.send("ope=city&cancelFlag=0&id="+id);
				  ajax.onreadystatechange = function() {
					if (ajax.readyState == 4 && ajax.status == 200) {
						try{
						   window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22155, user.getLanguage())%>");
						   onBtnSearchClick();
						   //window.location.href = "/hrm/city/HrmCity.jsp";
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
				  ajax.open("POST", "/hrm/country/HrmCanceledCheck.jsp", true);
				  ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
				  ajax.send("ope=city&cancelFlag=1&id="+id);
				  ajax.onreadystatechange = function() {
					if (ajax.readyState == 4 && ajax.status == 200) {
						try{
						  window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22156, user.getLanguage())%>");
						  onBtnSearchClick();	
						  //window.location.href = "/hrm/city/HrmCity.jsp";
						}catch(e){
							return false;
						}
					}
				 }
			   });
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
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmCity&method=HrmCityAdd&provinceid=<%=provinceid%>&isdialog=1","<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(493,user.getLanguage())%>");
			}
			
			function doEdit(id){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmCity&method=HrmCityEdit&isdialog=1&id="+id,"<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(493,user.getLanguage())%>");
			}
		
			function doLog(id){
				var url = "";
				if(id && id!=""){
					url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=61 and relatedid=")%>&relatedid="+id;
				}else{
					url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=61")%>";
				}
				doOpen(url,"<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>",jQuery(window).width(),jQuery(window).height());
			}
		</script>
	</head>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
		if(HrmUserVarify.checkUserRight("HrmCityAdd:Add", user)){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:doAdd();,_self} " ;
			RCMenuHeight += RCMenuHeightStep;
		}
		if(HrmUserVarify.checkUserRight("HrmCityEdit:Delete", user)){ 
			RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel();,_self} " ;
			RCMenuHeight += RCMenuHeightStep;
		}
		if(HrmUserVarify.checkUserRight("HrmCity:log", user)){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:doLog();,_self} " ;
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
							if(HrmUserVarify.checkUserRight("HrmCityAdd:Add", user)){ 
						%>
								<input type=button class="e8_btn_top" onclick="doAdd();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
						<%	
							}
							if(HrmUserVarify.checkUserRight("HrmCityEdit:Delete", user)){ 
						%>
								<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
						<%	} %>
						<input type="text" class="searchInput" name="flowTitle" value="<%=qname%>"/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
				<wea:layout type="4col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></wea:item>
						<wea:item><input type="text" id="cityName" name="cityName" class="inputStyle" value='<%=cityName%>'></wea:item>
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
						<wea:item><%=SystemEnv.getHtmlLabelName(800,user.getLanguage())%></wea:item>
						<wea:item>
							<span>
								<brow:browser viewType="0" name="provinceid" browserValue='<%=provinceid%>' 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/province/ProvinceBrowser.jsp"
									hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
									completeUrl="/data.jsp?type=2222" width="60%" browserSpanValue='<%=ProvinceComInfo.getProvincename(provinceid)%>'>
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
			String backfields = " a.id,a.cityname,a.citylongitude,a.citylatitude,a.provinceid,b.provincename,a.countryid,(case when a.canceled IS NULL then '0' else a.canceled end) as canceled,b.canceled as pcanceled,(select count(id) from HrmLocations where locationcity = a.id) as result ";
			String fromSql  = " from HrmCity a left join HrmProvince b on a.provinceid = b.id left join HrmCountry c on a.countryid = c.id ";
			String sqlWhere = " where 1 = 1 ";
			String orderby = " a.id " ;
			String tableString = "";
			
			if(qname.length() > 0){
				sqlWhere += " and a.cityname like '%"+qname+"%'";
			}else if(cityName.length() > 0){
				sqlWhere += " and a.cityname like '%"+cityName+"%'";
			}
			if(countryid.length() > 0){
				sqlWhere += " and a.countryid = "+countryid;
			}
			if(provinceid.length() > 0){
				sqlWhere += " and a.provinceid = "+provinceid;
			}
			
			String operateString= "<operates width=\"20%\">";
 	    	operateString+=" <popedom transmethod=\"weaver.hrm.HrmTransMethod.getCityListOperate\" otherpara=\""+HrmUserVarify.checkUserRight("HrmCityEdit:Edit", user)+":+column:result+==0and"+HrmUserVarify.checkUserRight("HrmCityEdit:Delete", user)+":+column:canceled+==0and+column:result+==0and"+HrmUserVarify.checkUserRight("HrmCityEdit:Edit", user)+":+column:canceled+==1and"+HrmUserVarify.checkUserRight("HrmCityEdit:Edit", user)+":"+HrmUserVarify.checkUserRight("HrmCity:log", user)+"\"></popedom> ";
 	       	operateString+="     <operate href=\"javascript:doEdit();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
 	       	operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
 	       	operateString+="     <operate href=\"javascript:doCanceled();\" text=\""+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+"\" index=\"2\"/>";
 	       	operateString+="     <operate href=\"javascript:doISCanceled();\" text=\""+SystemEnv.getHtmlLabelName(22152,user.getLanguage())+"\" index=\"3\"/>";
 	       	operateString+="     <operate href=\"javascript:doLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"4\"/>";
 	       	operateString+="</operates>";
			tableString =" <table pageId=\""+Constants.HRM_Z_033+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_033,user.getUID(),Constants.HRM)+"\" tabletype=\"checkbox\">"+
				" <checkboxpopedom showmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicCheckbox\"  id=\"checkbox\"  popedompara=\"column:result+==0and"+HrmUserVarify.checkUserRight("HrmCityEdit:Delete", user)+"\" />"+
				" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
		    operateString+
		    "	<head>"+
		    "		<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(800,user.getLanguage())+"\" column=\"provincename\" orderkey=\"provincename\" />"+
		    "		<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(493,user.getLanguage())+"\" column=\"cityname\" orderkey=\"cityname\" />"+
			"		<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"canceled\" orderkey=\"canceled\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:style[1=color:red]}{cmd:array["+user.getLanguage()+";default=225,1=22205]}\"/>"+
			"		<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(801,user.getLanguage())+"\" column=\"citylongitude\" orderkey=\"citylongitude\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:array[default=+column:citylongitude+,-1.000=null]}\"/>"+
			"		<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(802,user.getLanguage())+"\" column=\"citylatitude\" orderkey=\"citylatitude\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:array[default=+column:citylatitude+,-1.000=null]}\"/>"+
		    "	</head>"+
		    " </table>";
		%>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
	</BODY>
</HTML>
