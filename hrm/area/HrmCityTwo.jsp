<%@ page import="weaver.general.Util,weaver.hrm.common.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/hrm/area/areainit.jsp" %>
<%
String cityid = Util.null2String(request.getParameter("cityid"));
String citytwoid = Util.null2String(request.getParameter("citytwoid"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
				jQuery("#SearchForm").submit();
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
							url:"CityOperationTwo.jsp?operation=delete&id="+idArr[i],
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
			var dWidth = 560;
			var dHeight = 300;
			function closeDialog(){
				if(dialog){
					dialog.close();
					onBtnSearchClick();	
				}
			}
			function doCanceled(id){
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22153,user.getLanguage())%>",function(){
				  var ajax=ajaxinit();
				  ajax.open("POST", "/hrm/area/HrmCanceledCheck.jsp", true);
				  ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
				  ajax.send("ope=citytwo&cancelFlag=0&id="+id);
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
				  ajax.send("ope=citytwo&cancelFlag=1&id="+id);
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
			function doImport(){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=HrmResourceImport&importtype=area&title=126168","<%=SystemEnv.getHtmlLabelName(126168,user.getLanguage())%>",800,600);
			}
			function doAdd(){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmAreaCityTwo&method=HrmCityAddTwo&cityid=<%=cityid%>&isdialog=1","<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(25223,user.getLanguage())%>",600,420);
			}
			
			function doEdit(id){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmAreaCityTwo&method=HrmCityEditTwo&isdialog=1&id="+id,"<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(25223,user.getLanguage())%>",600,420);
			}
			
			function reloadTable(){
				_table.reLoad();
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
			jQuery(document).ready(function(){
				areromancedivbyid("_areaselect_cityid");
			});
</script>
</head>
<%
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(25223,user.getLanguage());
String needfav ="1";
String needhelp ="";
String qname = Util.null2String(request.getParameter("flowTitle"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmCityAdd:Add", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:doAdd(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(18596,user.getLanguage())+",javascript:doImport();,_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
if(HrmUserVarify.checkUserRight("HrmCityEdit:Delete", user)){ 
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmCity:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:doLog(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=SearchForm NAME=SearchForm STYLE="margin-bottom:0" action="HrmCityTwo.jsp" method=post>
  	<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<%
							if(HrmUserVarify.checkUserRight("HrmCityAdd:Add", user)){ 
						%>
								<input type=button class="e8_btn_top" onclick="doAdd();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
								<input type=button class="e8_btn_top" onclick="doImport();" value="<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%>"></input>
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
			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;height: 200px;" >
				<wea:layout type="4col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></wea:item>
						<wea:item>        
							<div areaType="city" areaName="cityid" areaValue="<%=cityid %>" 
		 						areaSpanValue="<%=CityComInfo.getCityname(Util.null2String(cityid))%>"  areaMustInput="1"  areaCallback=""  class="_areaselect" id="_areaselect_cityid"></div>
						</wea:item>
						<wea:item attributes="{'colspan':'2'}"></wea:item>
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
 </FORM>
 <%
			String backfields = " a.id,a.cityname,a.cityid,a.citylongitude,a.citylatitude,b.countryid,(case when a.canceled IS NULL then '0' else a.canceled end) as canceled,(case when b.canceled IS NULL then '0' else b.canceled end)  as pcanceled ";
			String fromSql  = " from HrmCityTwo a left join HrmCity b on a.cityid = b.id ";
			String sqlWhere = " where 1 = 1 ";
			String orderby = " a.cityid ASC " ;
			String tableString = "";
			
			if(qname.length() > 0){
				sqlWhere += " and a.cityname like '%"+qname+"%'";
			}
			
			if(cityid.length() > 0){
				sqlWhere += " and a.cityid = "+cityid;
			}
			if(citytwoid.length() > 0){
				sqlWhere += " and a.id = "+citytwoid;
			}
			String operateString= "<operates width=\"20%\">";
 	    	operateString+=" <popedom transmethod=\"weaver.hrm.HrmTransMethod.getCityListOperate\" otherpara=\""+HrmUserVarify.checkUserRight("HrmCityAdd:Add", user)+":"+HrmUserVarify.checkUserRight("HrmCityAdd:Add", user)+":+column:canceled+==0and"+HrmUserVarify.checkUserRight("HrmCityAdd:Add", user)+":+column:canceled+==1and+column:pcanceled+==0and"+HrmUserVarify.checkUserRight("HrmCityAdd:Add", user)+":"+HrmUserVarify.checkUserRight("HrmCity:log", user)+"\"></popedom> ";
 	      	operateString+="     <operate href=\"javascript:doEdit();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\" isalwaysshow='true'/>";
 	       	operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\" isalwaysshow='true'/>";
 	        operateString+="     <operate href=\"javascript:doCanceled();\" text=\""+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+"\" index=\"2\"/>";
	       	operateString+="     <operate href=\"javascript:doISCanceled();\" text=\""+SystemEnv.getHtmlLabelName(22152,user.getLanguage())+"\" index=\"3\"/>";
 	       	operateString+="     <operate href=\"javascript:doLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"4\" isalwaysshow='true'/>";
 	       	operateString+="</operates>";
			tableString =" <table pageId=\""+Constants.HRM_Z_233+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_233,user.getUID(),Constants.HRM)+"\" tabletype=\"checkbox\">"+
				" <checkboxpopedom showmethod=\"weaver.hrm.HrmTransMethod.getHrmCityTwoCheckbox\"  id=\"checkbox\"  popedompara=\"column:result+==0\" />"+
				" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
		    operateString+
		    "	<head>"+
		    "		<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(25223,user.getLanguage())+"\" column=\"cityname\" orderkey=\"cityname\" transmethod=\"weaver.hrm.HrmTransMethod.openDialogForHrmAreaEdit\" otherpara=\"column:id\"/>"+
				"		<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelNames("33476,493",user.getLanguage())+"\" column=\"cityid\" orderkey=\"cityid\" transmethod=\"weaver.hrm.city.CityComInfo.getCityname\"/>"+
				"		<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelNames("33476,377",user.getLanguage())+"\" column=\"countryid\" orderkey=\"countryid\" transmethod=\"weaver.hrm.country.CountryComInfo.getCountryname\"/>"+
				"		<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(801,user.getLanguage())+"\" column=\"citylongitude\" orderkey=\"citylongitude\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:array[default=+column:citylongitude+,-1.000=null]}\"/>"+
				"		<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(802,user.getLanguage())+"\" column=\"citylatitude\" orderkey=\"citylatitude\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:array[default=+column:citylatitude+,-1.000=null]}\"/>"+
				"		<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"canceled\" orderkey=\"canceled\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:style[1=color:red]}{cmd:array["+user.getLanguage()+";default=225,1=22205]}\"/>"+
		    "	</head>"+
		    " </table>";
		%>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
</BODY>
</HTML>
