<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="java.io.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<!DOCTYPE html>
<%
	if (!HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
%>
<%@ include file="/workflow/request/CommonUtils.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+ $label(86,user.getLanguage()) +",javascript:pager.doSave(),_top} " ;
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
	//读取当前系统语言信息
	String sql = "select id,language,activable from syslanguage order by id asc";
	List<String[]> list = new ArrayList<String[]>();
	RecordSet.execute(sql);
	while(RecordSet.next()){
		String [] langInfo = new String[3];
		langInfo[0] = RecordSet.getString("id");
		langInfo[1] = RecordSet.getString("language");
		langInfo[2] = RecordSet.getString("activable");
		list.add(langInfo);
	}
	BaseBean bb = new BaseBean();
    //读取当前日志状态
	int flag = Util.getIntValue(bb.getPropValue("weaver_multi_lang", "isLog"), 0);
%>
<html>
	<head>
	    <title><%=$label(231,user.getLanguage()) + $label(68,user.getLanguage())%></title>
		<link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet">
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" src="/proj/js/common_wev8.js"></script>
		<script>
			var pager = {
				doSave : function(){
					var setlist=document.getElementsByName("lang");
					var activelangs;
					var inactivelangs;
					var count=0;
					for(var i=0;i<setlist.length;i++){
						if(setlist[i].checked){
							if(typeof(activelangs)!="undefined"){
								activelangs = activelangs+","+setlist[i].value;
							}else{
								activelangs = setlist[i].value;
							}
							count++;
						}else{
							if(typeof(inactivelangs)!="undefined"){
								inactivelangs = inactivelangs+","+setlist[i].value;
							}else{
								inactivelangs = setlist[i].value;
							}
						}
					}
					if( count > 5){
						return alert("<%=SystemEnv.getHtmlNoteName(4920,user.getLanguage())%>");
					}
					var logswitch=document.getElementsByName("logswitch");
					if(logswitch[0].checked){
						$('#logswitch').val('1');
					}else{
						$('#logswitch').val('0');
					}
                    $('#activelangs').val(activelangs);
					$('#inactivelangs').val(inactivelangs);
					$('#weaver').submit();
				}
			};
			
			function setMulitLangPermission(){
				var dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=80&isdialog=1";
				dialog.Title = "<%=SystemEnv.getHtmlLabelNames("34032,18599,33508",user.getLanguage())%>";
				dialog.Height = 650;
				dialog.Width = 600;
				dialog.Drag = true;
				dialog.URL = url;
				dialog.show();
			}

			function reloadconfigs(){
				$.post("ManageLanguageOperation.jsp",{ command: "refresh"}, function(data) {
					if(data.trim()=='1'){
						alert("<%=SystemEnv.getHtmlNoteName(4921,user.getLanguage())%>");
					}
				});
			}

			function openFavouriteBrowser(){
				var url=window.location.href;
				var fav_uri = escape(url); 
				var fav_pagename='<%=$label(231,user.getLanguage()) + $label(68,user.getLanguage())%>';
				fav_pagename = escape(fav_pagename);
				window.showModalDialog("/favourite/FavouriteBrowser.jsp?fav_pagename="+fav_pagename+"&fav_uri="+fav_uri+"&fav_querystring=");
			}
			
			function showHelp(){
			var pathKey = this.location.pathname;
			if(pathKey!=""){
					pathKey = pathKey.substr(1);
			}
			var operationPage = "https://www.e-cology.com.cn/formmode/apps/ktree/ktreeHelp.jsp";
			var screenWidth = window.screen.width*1;
			var screenHeight = window.screen.height*1;
			window.open(operationPage+"?pathKey="+pathKey,"_blank","top=0,left="+(screenWidth-800)/2+",height="+(screenHeight-90)+",width=900,status=no,scrollbars=yes,toolbar=yes,menubar=no,location=no");
			}
		</script>
	</head>
<body>

		<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="setting"/>
		   <jsp:param name="navName" value="<%=$label(231,user.getLanguage()) + $label(68,user.getLanguage())%>"/>
		</jsp:include>
	

		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">				
					<input id="btnSave" type="button" value="<%=$label(86,user.getLanguage()) %>" class="e8_btn_top" onclick="pager.doSave()" />
					<span title="<%=$label(86,user.getLanguage()) %>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
			
<form id="weaver" name="frmmain" action="ManageLanguageOperation.jsp" method="post" >
			<wea:layout type="twoCol" attributes="{'expandAllGroup':'true'}">
				<wea:group context='<%=$label(16066,user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1'}">
				<%
				    for(String[] str:list){
				%>
					<wea:item>
						<%=str[1]%>
					</wea:item>
				<%		
					String id = "lang_"+str[0].trim();
					if(Integer.parseInt(str[0])==7){%>	
							<wea:item>
								<input type="checkbox" id=<%=id%> name='lang' value='7' checked='checked' tzCheckbox="true" disabled='disabled'/>
								<span id="remind" style="cursor:hand;padding-left:15px;" title="<%=$label(382662,user.getLanguage())%>">
				        		<img src="/images/remind_wev8.png" align="absMiddle">
							    </span>
							</wea:item>
				<%  }else if(Integer.parseInt(str[2])>0){			
				%>
							<wea:item>
								<input type="checkbox" id=<%=id%> name='lang' value='<%=Integer.parseInt(str[0])%>' checked='checked' tzCheckbox="true"/>
							</wea:item>
				<%	}else{%>
							<wea:item>
								<input type="checkbox" id=<%=id%> name='lang' value='<%=Integer.parseInt(str[0])%>' tzCheckbox="true"/>
							</wea:item>
					<%
					}
				   }
				%>
				</wea:group>

				<wea:group context='<%=$label(34032,user.getLanguage()) + $label(18599,user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1'}">
					<wea:item>
						<%=SystemEnv.getHtmlLabelNames("18599,33508",user.getLanguage())%>
					</wea:item>
					<wea:item>
						<img src="/wui/theme/ecology8/page/images/back-end_wev8.png" onclick="setMulitLangPermission()" style="cursor:pointer;vertical-align:middle" />
					</wea:item>
				</wea:group>

				<wea:group context='<%=$label(34032,user.getLanguage()) + $label(83,user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1'}">
					<wea:item>
						<%=$label(83,user.getLanguage()) + $label(84137,user.getLanguage())%>
					</wea:item>
					<% if(flag==1){%>
					<wea:item>
						<input type="checkbox" id="logswitch" checked='checked' name="logswitch"  tzCheckbox="true"/>
					</wea:item>
					<%}else{%>
					<wea:item>
						<input type="checkbox" id="logswitch"  name="logswitch"  tzCheckbox="true"/>
					</wea:item>
					<%}%>
				</wea:group>
				
				<wea:group context='<%=$label(354,user.getLanguage()) + $label(84716,user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1'}">
					<wea:item>
						<%=$label(354,user.getLanguage()) + $label(724,user.getLanguage())%>
					</wea:item>				
					<wea:item>
						<input type="button" id='reloadConfig' onclick="reloadconfigs()" class='e8_btn_top_first' name="reloadConfig"  value="<%=$label(354,user.getLanguage())%>">	
						<span id="remind" style="cursor:hand;padding-left:15px;" title="<%=$label(382664,user.getLanguage())%>">
				        	<img src="/images/remind_wev8.png" align="absMiddle">
				        </span>
					</wea:item> 
				</wea:group>
				</wea:layout>
				<input type='hidden' id='activelangs' name='activelangs'/>
				<input type='hidden' id='inactivelangs' name='inactivelangs'/>
		</form>
	</body>
	</html>