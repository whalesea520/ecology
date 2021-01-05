
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.hrm.*" %>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" language="javascript" src="/workflow/request/jquery/jquery_wev8.js"></script>
<script type='text/javascript' language="javascript" src="/workflow/request/jquery/jquery.autocomplete_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/workflow/request/jquery/jquery.autocomplete_wev8.css" />
<%
User user = HrmUserVarify.getUser (request , response); 
String cellvalue = request.getParameter("cellvalue");
String uservalue = request.getParameter("uservalue");
String fieldtype = request.getParameter("fieldtype");
String urlid = request.getParameter("urlid");
%>
<html>
	<head>
	</head>
	<body style="overflow:hidden" leftMargin=0 topMargin=0>
		<form>
			<table class=ViewForm>
				<%if(fieldtype.equals("1")&&(1==2)){%>
				<tr>
					<td valign=top class=Field>
						<button type='button' class=Browser onclick="onShowResourceBrowser('<%=uservalue%>')"></button>
						<input type="hidden" id="temphidden<%=uservalue%>" name="temphidden<%=uservalue%>" value="<%=urlid%>">
						<input type="hidden" id="tempname<%=uservalue%>" name="tempname<%=uservalue%>" value="<%=cellvalue%>">
						<input type="text" size=20 name="temp<%=uservalue%>" id="temp<%=uservalue%>" value="<%=cellvalue%>">
					</td>
					<td class=Field>
						<a href="#" onclick="clearResult()"><%=SystemEnv.getHtmlLabelNames("311,356",user.getLanguage()) %></a>
					</td>
					<td class=Field>
						<a href="#" onclick="onConfirm()"><%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%></a>
					</td>
				</tr>
				<tr>
					<td width="100%" height="150" class=Field colspan=3></td>
				</tr>
				<script type="text/javascript">
					jQuery.noConflict();
					jQuery(document).ready(function(){
						jQuery(jQuery("#temp<%=uservalue%>")).autocomplete("../request/search.jsp", {
							max:100,
							width: 150,
							scrollHeight:100,
							delay:400,
							multiple:false,
							selectFirst: false
						});
						jQuery(jQuery("#temp<%=uservalue%>")).result(function(event, data, formatted) {
							if (data){
								document.all("temphidden<%=uservalue%>").value = data[1];
								document.all("tempname<%=uservalue%>").value = data[0].substring(0,data[0].indexOf("/"));
							}
						});
						jQuery(jQuery("#temp<%=uservalue%>")).keydown(function() {
							var keyBoardCode = event.keyCode;
							if(event.keyCode==8||event.keyCode==46){
								document.all("temp<%=uservalue%>").value = "";
								document.all("temphidden<%=uservalue%>").value = "";
								document.all("tempname<%=uservalue%>").value = "";
							}
						});
						jQuery(jQuery("#temp<%=uservalue%>")).blur(function() {
							var temp1 = document.all("temp<%=uservalue%>").value;
							var temp2 = document.all("tempname<%=uservalue%>").value;
							if(temp1!=temp2) document.all("temp<%=uservalue%>").value = "";
							if(document.all("temp<%=uservalue%>").value=="")
								document.all("tempname<%=uservalue%>").value = "";
						});
					});
				</script>	
				<script language=vbs>
					sub onShowResourceBrowser(uservalue)
						id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
						if (Not IsEmpty(id)) then
						if id(0)<> "" then
						document.all("temphidden"+uservalue).value=id(0)
						document.all("temp"+uservalue).value=id(1)
						document.all("tempname"+uservalue).value=id(1)
						else 
						document.all("temphidden"+uservalue).value=""
						document.all("temp"+uservalue).value=""
						document.all("tempname"+uservalue).value=""
						end if
						end if
					end sub
				</script>
				<%}else if((1==1)||(fieldtype.equals("17")||fieldtype.equals("165")||fieldtype.equals("166"))){%>
				
				<COLGROUP>
  			<COL width="70%">
  			<COL width="20%">
  			<COL width="10%">
				<tr>
					<td valign=top class=Field>
						<button type='button' class=Browser onclick="onShowResourceBrowserMuti('<%=uservalue%>')"></button>
						<input type="hidden" id="temphidden<%=uservalue%>" name="temphidden<%=uservalue%>" <%if(!urlid.equals("")){%>value="<%=urlid%>,"<%}%>>
						<input type="hidden" id="tempname<%=uservalue%>" name="tempname<%=uservalue%>" <%if(!cellvalue.equals("")){%>value="<%=cellvalue%>,"<%}%>>
						<textarea cols=40 rows=1 style="overflow:visible" textmode="multiline" name="temp<%=uservalue%>" id="temp<%=uservalue%>" ><%if(!cellvalue.equals("")){%><%=cellvalue%>,<%}%></textarea>
					</td>
					<td class=Field>
						<a href="#" onclick="clearResult()"><%=SystemEnv.getHtmlLabelNames("311,356",user.getLanguage()) %></a>
					</td>
					<td class=Field>
						<a href="#" onclick="onConfirm()"><%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%></a>
					</td>
				</tr>
				<tr>
					<td width="100%" height="150" class=Field colspan=3></td>
				</tr>
				<script type="text/javascript">
					jQuery.noConflict();
					jQuery(document).ready(function(){
						jQuery(jQuery("#temp<%=uservalue%>")).autocomplete("../request/search.jsp", {
							max:100,
							width: 150,
							scrollHeight:100,
							delay:400,
							multiple:true,
							selectFirst: false
						});
						jQuery(jQuery("#temp<%=uservalue%>")).result(function(event, data, formatted) {
							if (data){
								if(document.all("temphidden<%=uservalue%>").value!=""){
									if((","+document.all("temphidden<%=uservalue%>").value).indexOf(","+data[1]+",")==-1)
										document.all("temphidden<%=uservalue%>").value = document.all("temphidden<%=uservalue%>").value + data[1] + "," ;
								}else document.all("temphidden<%=uservalue%>").value = data[1]+",";
								
								if(document.all("tempname<%=uservalue%>").value!=""){
									if((","+document.all("tempname<%=uservalue%>").value).indexOf(","+data[0].substring(0,data[0].indexOf("/"))+",")==-1)
										document.all("tempname<%=uservalue%>").value = document.all("tempname<%=uservalue%>").value + data[0].substring(0,data[0].indexOf("/")) + "," ;
									else document.all("tempname<%=uservalue%>").value = document.all("tempname<%=uservalue%>").value;
								}else document.all("tempname<%=uservalue%>").value = data[0].substring(0,data[0].indexOf("/")) + "," ;
							}
						});
						jQuery(jQuery("#temp<%=uservalue%>")).keydown(function() {
							var keyBoardCode = event.keyCode;
							if(event.keyCode==8||event.keyCode==46){//删除
								var tempValue = document.all("temp<%=uservalue%>").value;
								
								if(tempValue.length>0){
									var spanArray = tempValue.substring(0,tempValue.length-1).split(",");
									var nameArray = document.all("tempname<%=uservalue%>").value.substring(0,document.all("tempname<%=uservalue%>").value.length-1).split(",");
									var idArray = document.all("temphidden<%=uservalue%>").value.substring(0,document.all("temphidden<%=uservalue%>").value.length-1).split(",");
								
									document.all("temp<%=uservalue%>").focus;
									var sel = document.selection.createRange();
		        			var clone = sel.duplicate();
		        			clone.moveToElementText(document.all("temp<%=uservalue%>"));
									clone.setEndPoint("StartToStart",sel);
									tempValue = tempValue.replace(clone.text,"");
									var focusWhere = tempValue.length;//光标所在位置
									
									var newSpanString = "";
									var newNameString = "";
									var newIdString = "";
									var continueFlag = true;
									for(var v=0;v<spanArray.length;v++){
										if(focusWhere==0&&continueFlag){
											continueFlag = false;
											continue;
										}
										var tempSpanString = newSpanString+spanArray[v]+",";
										if(continueFlag && (focusWhere>newSpanString.length) && (focusWhere<tempSpanString.length)){
											continueFlag = false;
											continue;
										}
										newSpanString += spanArray[v]+",";
										newNameString += nameArray[v]+",";
										newIdString += idArray[v]+",";
									}
									document.all("temp<%=uservalue%>").value = newSpanString;
									document.all("tempname<%=uservalue%>").value = newNameString;
									document.all("temphidden<%=uservalue%>").value = newIdString;
								}
							}
						});
						jQuery(jQuery("#temp<%=uservalue%>")).blur(function() {
							var temp1 = document.all("temp<%=uservalue%>").value;
							var temp2 = document.all("tempname<%=uservalue%>").value;
							if(temp1!=temp2){
								document.all("temp<%=uservalue%>").value = temp2;
							}
							if(document.all("temp<%=uservalue%>").value=="")
								document.all("temphidden<%=uservalue%>").value = "";
						});
						jQuery(jQuery("#temp<%=uservalue%>")).keypress(function() {
							var keyBoardCode = event.keyCode;
							if(keyBoardCode==44){//不允许手动输入逗号
								event.keyCode = 0;
							}
						});
					});
				</script>	
				<script language=vbs>
					sub onShowResourceBrowserMuti(uservalue)
						resourse = document.all("temphidden<%=uservalue%>").value
						id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="&resourse)
						if (Not IsEmpty(id)) then
						if id(0)<> "" then
						document.all("temphidden"+uservalue).value=Mid(id(0),2,len(id(0)))&","
						document.all("temp"+uservalue).value=Mid(id(1),2,len(id(1)))&","
						document.all("tempname"+uservalue).value=Mid(id(1),2,len(id(1)))&","
						else 
						document.all("temphidden"+uservalue).value=""
						document.all("temp"+uservalue).value=""
						document.all("tempname"+uservalue).value=""
						end if
						end if
					end sub
				</script>
				<%}%>
			</table>
		</form>
		<script type="text/javascript">
			function clearResult(){
				window.parent.document.all("<%=uservalue%>").value="";
				var wcell = window.parent.document.frmmain.ChinaExcel;
				var temprow=wcell.GetCellUserStringValueRow("<%=uservalue%>_<%=fieldtype%>_3");
    		var tempcol=wcell.GetCellUserStringValueCol("<%=uservalue%>_<%=fieldtype%>_3");
    		wcell.SetCellVal(temprow,tempcol,"");
    		wcell.RefreshViewSize();
				window.parent.document.getElementById("_xTable").style.display="none";
			}
			function onConfirm(){
				window.parent.document.all("<%=uservalue%>").value=document.all("temphidden<%=uservalue%>").value;
				var wcell = window.parent.document.frmmain.ChinaExcel;
				var temprow=wcell.GetCellUserStringValueRow("<%=uservalue%>_<%=fieldtype%>_3");
    		var tempcol=wcell.GetCellUserStringValueCol("<%=uservalue%>_<%=fieldtype%>_3");
    		var setValue = document.all("tempname<%=uservalue%>").value;
    		setValue = setValue.substring(0,setValue.length-1);
    		wcell.SetCellVal(temprow,tempcol,setValue);
    		wcell.RefreshViewSize();
				window.parent.document.getElementById("_xTable").style.display="none";
			}
		</script>
	</body>
</html>	