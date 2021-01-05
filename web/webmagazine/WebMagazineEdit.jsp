
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
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
String id = ""+Util.getIntValue(request.getParameter("id"),0);
String typeID = "0";
String releaseYear = "";
String name = "";
String HeadDoc = "";
RecordSet.executeSql("select * from WebMagazine where id = " + id);
if (RecordSet.next()) 
{
	typeID = ""+Util.getIntValue(RecordSet.getString("typeID"),0);  
	releaseYear = Util.null2String(RecordSet.getString("releaseYear"));
	name = Util.null2String(RecordSet.getString("name"));
	HeadDoc = Util.null2String(RecordSet.getString("docID"));	
}
String optype=Util.null2String(request.getParameter("optype"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>

<script type="text/javascript">
	try{
		parent.setTabObjName("<%= releaseYear+SystemEnv.getHtmlLabelName(445,user.getLanguage())+name %>");
	}catch(e){}
</script>

<script type="text/javascript">
var parentWin = null;
var parentDialog = null;
<%if("1".equals(isDialog)){%>
parentWin = parent.parent.getParentWindow(parent);
parentDialog = parent.parent.getDialog(parent); 
<%}%>
	if("<%=isclose%>"=="1"){
		parentWin = parent.parent.getParentWindow(parent);
		parentDialog = parent.parent.getDialog(parent); 
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

	var pluginName = {
		type:"input",
		name:"node_#rowIndex#_group",
		notNull:true
	};
	var pluginIsView = {
		type:"checkbox",
		options:[
			{text:"",value:"1",name:"node_#rowIndex#_isview"}
		]
	};
	var pluginDoc={
		type:"browser",
		addIndex:false,
		attr:{
			name:"node_#rowIndex#_docs",
			viewType:"0",
			browserValue:"0",
			isMustInput:"1",
			browserSpanValue:"",
			hasInput:true,
			linkUrl:"#",
			isSingle:false,
			completeUrl:"/data.jsp?type=9",
			browserUrl:"/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids=",
			width:"90%",
			hasAdd:false,
			isSingle:false
		}
	};
	
	function afterDoWhenLoaded(){
		hideTH();
	}
	
	function onBtnSearchClick(){}

</script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(31516,user.getLanguage());
String needfav ="1";
String needhelp ="";
String needcheck = "name";


String qname = Util.null2String(request.getParameter("flowTitle"));
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(isDialog.equals("1")||!optype.equals("1")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	if(isDialog.equals("1")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(32159,user.getLanguage())+",javascript:submitData(1),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
}else{
	if(optype.equals("1")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:addNewRow(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteSelectedRow(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
}
/*RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/web/webmagazine/WebMagazineView.jsp?id="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;*/
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="" name="frmmain" id="frmmain">
<input type="hidden" name="id" value="<%=id%>"/>
<input type="hidden" name="typeID" value="<%=typeID%>"/>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="submitData();" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
			<%if(!optype.equals("1")){ %>
				<%if(isDialog.equals("1")){ %>
					<input type=button class="e8_btn_top" onclick="submitData(1);" value="<%=SystemEnv.getHtmlLabelName(32159, user.getLanguage())%>"></input>
				<%} %>
			<%}else{ %>
				<input class="e8_btn_top" type=button accessKey=A onclick="addNewRow();" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
				<input Class="e8_btn_top" type=button accessKey=E onclick="deleteSelectedRow();" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>
			<FORM name="Magazine"  action="WebMagazineOperation.jsp" method="post">
			<input type="hidden" name="method" value="MagazineUpdate"/>
			<input type="hidden" name="id" value="<%=id%>"/>
			<input type="hidden" name="typeID" value="<%=typeID%>"/>
			<input type="hidden" name="optype" value="<%=optype%>"/>
			<input type="hidden" name="tableMax" value="0"/>
			<input type="hidden" name="isdialog" value="<%=isDialog%>">
			<input type="hidden" name="to" id="to" value="<%=to%>">

			<wea:layout>
				<%
				String attr1 = "{'groupDisplay':'"+(!optype.equals("1")?"":"none")+"','itemAreaDisplay':'"+(!optype.equals("1")?"":"none")+"'}";
				String attr2 = "{'groupDisplay':'none','itemAreaDisplay':'"+((optype.equals("1")&&!"1".equals(isDialog))?"":"none")+"'}";
				%>
					<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="<%=attr1 %>">
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
									<select class=InputStyle  name = "releaseYear" style="width:80px">
										<%
										for (int i = 2000 ; i <= currentyear+10 ; i++) {
										%>
										<option value=<%=i%> <%if (i == Util.getIntValue(releaseYear,0)) {%> selected <%}%>><%=i%></option>
										<%}%>
									</select>
								</span>
								<span class="jNiceSelectFloat" style="padding-top:5px;">
									<%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>	
								</span>
								<wea:required id="NameSpan" required="true" value='<%=name%>'>
									<span class="jNiceSelectFloat">
										<INPUT style="width:100%;" class="InputStyle" type="text" name="name" onchange='checkinput("name","NameSpan")' style="width:100px;" value="<%=name%>">
									</span>
								</wea:required>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(31519,user.getLanguage())%></wea:item>
						<wea:item>
							<%
							ArrayList docIDArray= Util.TokenizerString(HeadDoc,",");
							String spanValue = "";
							for(int i=0;i<docIDArray.size();i++)
							{
								if(spanValue.equals("")){
									spanValue = "<a target='_blank' href =/docs/docs/DocDsp.jsp?id="+(String)docIDArray.get(i)+">"+DocComInfo.getDocname((String)docIDArray.get(i))+"</a>";
								}else{
									spanValue += ",<a target='_blank' href =/docs/docs/DocDsp.jsp?id="+(String)docIDArray.get(i)+">"+DocComInfo.getDocname((String)docIDArray.get(i))+"</a>";
								}
								//out.print("<a href =/docs/docs/DocDsp.jsp?id="+(String)docIDArray.get(i)+">"+DocComInfo.getDocname((String)docIDArray.get(i))+"</a>&nbsp;&nbsp;");
							}
							%>
							<span>
								   <brow:browser viewType="0" name="HeadDoc" browserValue='<%=HeadDoc%>' 
									browserUrl="/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/docs/MutiDocBrowser.jsp?documentids="
									hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
									completeUrl="/data.jsp?type=9" linkUrl="/docs/docs/DocDsp.jsp"
									language='<%=""+user.getLanguage() %>'
									temptitle='<%=SystemEnv.getHtmlLabelName(31519,user.getLanguage())%>'
									browserSpanValue='<%= spanValue	 %>'></brow:browser>
							</span>	
						</wea:item>
					</wea:group>
				<%if(true){ %>
					<wea:group context='<%=SystemEnv.getHtmlLabelName(32870,user.getLanguage())%>' attributes="<%=attr2 %>">
						<wea:item attributes="{'isTableList':'true'}">
							<%
								String sqlWhere = "mainID = " + id ;
								if(!qname.equals("")){
									sqlWhere += " and name like '%"+qname+"%'";
								}									
								String tableString=""+
								   "<table needPage=\"false\"  pageId=\""+PageIdConst.DOC_WEBMAGAZINEDETAIL+"\" instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_WEBMAGAZINEDETAIL,user.getUID(),PageIdConst.DOC)+"\" tabletype=\"checkbox\">"+
									" <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.general.KnowledgeTransMethod.getDocNumberOperate\"  popedompara=\"true\" />"+
								   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"WebMagazineDetail\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"desc\"  sqldistinct=\"true\" />"+
								   "<head>"+							 
										 "<col width=\"30%\" editPlugin=\"pluginName\"  text=\""+SystemEnv.getHtmlLabelName(31520,user.getLanguage())+"\"  column=\"name\" />"+
										 "<col width=\"15%\" editPlugin=\"pluginIsView\"   text=\""+SystemEnv.getHtmlLabelName(15603,user.getLanguage())+SystemEnv.getHtmlLabelName(31520,user.getLanguage())+"\" column=\"isView\"/>"+
										 "<col width=\"55%\" editPlugin=\"pluginDoc\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNamesNew\"   text=\""+SystemEnv.getHtmlLabelName(30041,user.getLanguage())+"\" column=\"docId\"/>"+
								   "</head>"+
								   "</table>";
							%> 
							<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
							<input type="hidden" name="pageId" _showCol="false" id="pageId" value="<%= PageIdConst.DOC_WEBMAGAZINEDETAIL %>"/>
						</wea:item>
					</wea:group>
				<%}%>
			</wea:layout>

			
			  <input type="hidden" name="totaldetail" value=""> 
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
<script language="javascript">

function submitData(to)
{
	var needcheck = "<%= needcheck%>";
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

	function onBtnSearchClick(){
		jQuery("#frmmain").submit();
	}
	
	function addNewRow(){
		$(".ListStyle:last").addNewRow();
		$(".ListStyle:last").jNice();
	}
	
	function deleteSelectedRow(){
		$(".ListStyle").deleteSelectedRow();
	}
	
</script>

