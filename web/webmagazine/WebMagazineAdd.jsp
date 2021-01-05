
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("WebMagazine:Main", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
Calendar today = Calendar.getInstance();
int currentyear = today.get(Calendar.YEAR) ;
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String to = Util.null2String(request.getParameter("to"));
String id = Util.null2String(request.getParameter("id"));
String optype = Util.null2String(request.getParameter("optype"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(31516,user.getLanguage());
String needfav ="1";
String needhelp ="";
String needcheck = "name";
String typeID = ""+Util.getIntValue(request.getParameter("typeID"),0);
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
if(isDialog.equals("1")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32159,user.getLanguage())+",javascript:submitData(1),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
if(!isDialog.equals("1")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",WebMagazineList.jsp?typeID="+typeID+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%} %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="submitData();" value="<%=SystemEnv.getHtmlLabelName(30986, user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="submitData(1);" value="<%=SystemEnv.getHtmlLabelName(32159, user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
			<FORM name="Magazine"  action="WebMagazineOperation.jsp" method="post">
			<input type="hidden" name="method" value="MagazineAdd">
			<input type="hidden" name="typeID" value="<%=typeID%>">
			<input type="hidden" name="isdialog" value="<%=isDialog%>">
			<input type="hidden" name="to" id="to" value="<%=to%>">
			<wea:layout>
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(31517,user.getLanguage())%></wea:item>
					<wea:item>
						<%
							String typeName = "";
							RecordSet.executeSql("select * from WebMagazineType where id = " + typeID);
							if (RecordSet.next()) 
							{
								typeName = Util.null2String(RecordSet.getString("name"));
							}
							out.print(typeName);
						%>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(31518,user.getLanguage())%></wea:item>
					<wea:item>
							<!--年份-->
							<span class="jNiceSelectFloat">
								<select class=InputStyle  name = "releaseYear">
									<%
									for (int i = 2000 ; i <= currentyear+10 ; i++) {
									%>
									<option value=<%=i%> <%if (i == currentyear) {%> selected <%}%>><%=i%></option>
									<%}%>
								</select>
							</span>
							<span class="jNiceSelectFloat" style="padding-top:5px;">
								<%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>	
							</span>
							<wea:required id="NameSpan" required="true">
								<span class="jNiceSelectFloat">
									<INPUT style="width:100%;" class="InputStyle" type="text" name="name" onchange='checkinput("name","NameSpan")'>
								</span>
							</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(31519,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							   <brow:browser viewType="0" name="HeadDoc" browserValue="" 
								browserUrl="/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/docs/MutiDocBrowser.jsp?documentids="
								temptitle='<%=SystemEnv.getHtmlLabelName(31519,user.getLanguage())%>' language='<%=""+user.getLanguage() %>'
								hasInput="false" isSingle="false" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=9" linkUrl="/docs/docs/DocDsp.jsp"
								browserSpanValue=""></brow:browser>
						</span>	
					</wea:item>
				</wea:group>
			</wea:layout>
			
			  <input type="hidden" name="totaldetail" value=0> 
			  </FORM>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentDialog.closeByHand();">
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
<script language="JavaScript" src="/js/addRowBg_wev8.js" >   
</script>  
<script language="javascript">
var rowindex = 0;
var totalrows=0;
var needcheck = "<%=needcheck%>";
var rowColor="" ;
function addRow()
{
	ncol = oTable.rows.item(0).cells.length ;	
	oRow = oTable.insertRow(-1);
	//oRow.style.height=24;
	rowColor = getRowBg();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(j); 
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node' value='"+rowindex+"'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
					sHtml = "<input class='InputStyle' type='text' name='node_"+rowindex+"_group' onBlur=checkinput('node_"+rowindex+"_group','node_"+rowindex+"_groupspan')><span id='node_"+rowindex+"_groupspan'>";
					sHtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
					sHtml+="</span>";
					needcheck += ","+"node_"+rowindex+"_group";
        			oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
					sHtml = "<input type='checkbox' name='node_"+rowindex+"_isview' value='1' checked>";
	        		oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
					sHtml = "<BUTTON class=Browser type='button' onclick=onShowMDocs('node_"+rowindex+"_docs','node_"+rowindex+"_docsspan')></BUTTON>";
					sHtml += "<input id='node_"+rowindex+"_docs' name='node_"+rowindex+"_docs' type='hidden'>";
					sHtml += "<SPAN id='node_"+rowindex+"_docsspan' name='node_"+rowindex+"_docsspan'></SPAN>";
					oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
				
		}
	}
	rowindex = rowindex*1 +1;
	document.all.totaldetail.value=rowindex;
	totalrows = rowindex;
}


function deleteRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 2;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				tmprow = document.forms[0].elements[i].value;
				for(j=1; j<4; j++) {
				
						if(j==1)
							needcheck = needcheck.replace(",node_"+tmprow+"_group","");
						if(j==3)
							needcheck = needcheck.replace(",node_"+tmprow+"_docs","");
				
				}
				oTable.deleteRow(rowsum1-1);	
			}
			rowsum1 -=1;
		}
	
	}	
}

function submitData(to)
{
	if (check_form(Magazine,needcheck)){
		if(to){
			jQuery("#to").val(to);
		}
		Magazine.submit();
	}
}
function onShowMDocs(input,span){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			_displayTemplate:"#b{name}",
			_displaySelector:"",
			_required:"no",
			_displayText:"",
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;

	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="+$("#"+input).val(),"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	
	if (datas){
	if (datas.id!=""){
	ids = datas.id.split(",");
	names =datas.name.split(",");
	sHtml = "";
	for( var i=0;i<ids.length;i++){
	if(ids[i]!=""){
	sHtml = sHtml+"<a href=/docs/docs/DocDsp.jsp?id="+ids[i]+">"+names[i]+"</a>&nbsp";
	}
	}
	$("#"+span).html(sHtml);
	$("#"+input).val(datas.id);

	}else {
	$("#"+span).html("");
	$("#"+input).val("");
	}
	}
	}
	var parentWin = parent.parent.getParentWindow(parent);
	var parentDialog = parent.parent.getDialog(parent); 
	if("<%=isclose%>"=="1"){
		if("<%=to%>"=="1"){
			parentWin.parent.location = "/web/webmagazine/DocWebTab.jsp?_fromURL=3&id=<%=id%>";
			parentWin.closeDialog();
		}else if("<%=to%>"=="2"){
			parentWin.location="/web/webmagazine/WebMagazineList.jsp?optype=1&typeID=<%=typeID%>";
			parentWin.closeDialog();
		}else{
			parentWin.parent.location="/web/webmagazine/DocWebTab.jsp";
			parentWin.closeDialog();
		}	
	}
	

</script>
