
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
	if(!HrmUserVarify.checkUserRight("SubCompanyDefineInfo1:SubMaintain1", user)){
		response.sendRedirect("/notice/noright.jsp");	
		return;
	}
%>
<%
String formid = Util.null2String(request.getParameter("formid"));
String message = Util.null2String(request.getParameter("message"));
String isoldform = Util.null2String(request.getParameter("isoldform"));
String isEnableExtranetHelp = KtreeHelp.getInstance().isEnableExtranetHelp;
%>
<html>
<head>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
    <script language="JavaScript" src="/js/addRowBg_wev8.js" ></script>
    <script type='text/javascript' src='/dwr/interface/WorkflowSubwfSetUtil.js'></script>
    <script type='text/javascript' src='/dwr/engine.js'></script>
    <script type='text/javascript' src='/dwr/util.js'></script>
    <script type="text/javascript" src="/js/dojo_wev8.js"></script>
    <script src="/js/tab_wev8.js"></script>
    <script type="text/javascript">
        dojo.require("dojo.widget.TabSet");
        dojo.require("dojo.io.*");
        dojo.require("dojo.event.*");
    </script>
    <LINK href="/js/src/widget/templates/HtmlTabSet_wev8.css" type="text/css" media=screen>
</head>
<body>
			<!-- 
				<div id="mainTabSet" dojoType="TabSet" style="width: 100%; height: 100%;" selectedTab="tab1">
				<div id="tab2" dojoType="Tab" label="<%=SystemEnv.getHtmlLabelName(15449, user.getLanguage())%>" onSelected="settab2()">
					<iframe id="tab2iframe" src="/hrm/company/editSubcompanyFieldBatch.jsp?ajax=1" name="tab2iframe" frameborder="0" width=100% height=100% scrolling="auto"></iframe>
				</div>
				<div id="tab3" dojoType="Tab" label="<%=SystemEnv.getHtmlLabelName(15450, user.getLanguage())%>" onSelected="settab3()" url="" onSelected="setHelpURL('/hrm/company/addSubcompanyFieldlabel.jsp')" onmouseup="if(event.button==2) {initMenu(this);}" ></div>
			</div>
			 -->
			<div id="mainTabSet" dojoType="TabSet" style="width: 100%; height: 100%;" selectedTab="tab1">
				<iframe id="tab2iframe" src="/hrm/company/editSubcompanyFieldBatch.jsp?ajax=1" name="tab2iframe" frameborder="0" width=100% height=100% scrolling="auto"></iframe>
			</div>
</body>
</html>
<SCRIPT language="javascript">
	function settab11(){
		doGet(tab1,jQuery(tab1).attr('url'));
	}
	function viewSourceUrl(){
    prompt("",location);
	}
	function settab2(){
		$G('tab2iframe').src="/hrm/company/editSubcompanyFieldBatch.jsp?ajax=1";
	}
	function settab3(){
		doGet(tab3,"/hrm/company/addSubcompanyFieldlabel.jsp?ajax=1");
	}

	function addformtabsubmit0(obj){
		if(check_form(addformtabspecial,'formname,subcompanyid')){
            obj.disabled=true;
			doPost(addformtabspecial,tab1);
		}
	}
	function deleteform(){
	    if(isdel()){
	        addformtabspecial.action = "/workflow/form/delforms.jsp";
	        addformtabspecial.ajax.value="0";
	        addformtabspecial.submit();
	    }
	}
	function addformtabsubmit1(obj){
		if(check_form(addformtabspecial,'formname,subcompanyid')){
            obj.disabled=true;
			addformtabspecial.submit();
		}
	}
	function addformtabretun(){
		//history.back(-1);
		document.location = "manageform.jsp";
	}
	
	var fieldid = new Array();
	var fieldlable = new Array();
	var curindex = 0;
	var currowcalexp = "";
	var groups="";

	function addexp(obj){		
	    curindex = $G("curindex").value;
	    fieldid[curindex]=obj.accessKey;
	    if("+-*/()=".indexOf(obj.accessKey)==-1){
	    	if (groups==""||groups==obj.id){
				fieldlable[curindex]="<span style='color:#000000'>"+obj.innerHTML+"</span>";
				groups=obj.id;
	    	}else{
				window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(18909,user.getLanguage())%>');
				return;
	    	}
	    }else{
	    	fieldlable[curindex]=obj.innerHTML; 
	    }		
	    curindex++;
	    refreshcal();
	    $G("curindex").value = curindex;
	}
	function removeexp(){
	    curindex--;
	    if(curindex<0){
	        curindex = 0;
	    }
	    $("curindex").value = curindex;
	    refreshcal();
	}
	
	function refreshcal(){
	    currowcalexp = "";
	    $G("rowcalexp").innerHTML="";
		
	    for(var i=0; i<curindex; i++){
	        currowcalexp+=fieldid[i];
	        $G("rowcalexp").innerHTML+=fieldlable[i];
	    }
	}
	
	function addRowCal(){
	    if(currowcalexp==""){
	        return;
	    }
	    oRow = allcalexp.insertRow(-1);
	    oRow.style.background= "#efefef";
	
	    oCell = oRow.insertCell(-1);
	    oCell.style.color="red";
	    var oDiv = document.createElement("div");
	    var sHtml = $G("rowcalexp").innerHTML+"<input type='hidden' name='calstr' value='"+currowcalexp+"'>";
	    //alert(sHtml);
	    oDiv.innerHTML = sHtml;
	    oCell.appendChild(oDiv);
	
	    oDiv = document.createElement("div");
	    oCell = oRow.insertCell(-1);
	    var sHtml = "<a href='#' onclick='deleteRowcal(this)'><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>";
	    oDiv.innerHTML = sHtml;
	    //alert(oDiv.innerHTML)
	    oCell.appendChild(oDiv);
	
	    clearexp();
	}
	
	function clearexp(){
	    currowcalexp = "";
	    groups="";
	    curindex=0;
		fieldid = new Array();
		fieldlable = new Array();

	    $G("rowcalexp").innerHTML="";		
		$G("curindex").value=curindex;				
	}
	
	function deleteRowcal(obj){
	    //alert(obj.parentElement.parentElement.parentElement.rowIndex);
	    if(confirm('<%=SystemEnv.getHtmlLabelName(18688,user.getLanguage())%>')){
	        allcalexp.deleteRow(jQuery(obj).parent().parent().parent()[0].rowIndex);
	    }
	}
	
	function addcalnumber(){
	    var calnumber = prompt('<%=SystemEnv.getHtmlLabelName(18689,user.getLanguage())%>',"1.0");
	    if (isNaN(calnumber)){
	    	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20321,user.getLanguage())%>");
			return;
		}
	    if(calnumber!=null){
	        fieldid[curindex]=calnumber;
	        fieldlable[curindex]=calnumber;
	        curindex++;
			$("curindex").value = curindex;
	        refreshcal();
	    }
	}
	function rowsaveRole(){
		doPost(rowcalfrm,tab4);
	}
	function rowsaveRole1(){
		clearexp();
	    rowsaveRole();
	}
	function colsaveRole(){
		doPost(colcalfrm,tab5);
	}
	function setChange(fieldid){
		$G("checkitems").value += "field_"+fieldid+"_CN,"
		var changefieldids = $G("changefieldids").value;
		if(changefieldids.indexOf(fieldid)<0)
			$G("changefieldids").value = changefieldids + fieldid + ",";
	}
	function fieldlablesall(){
		if(document.fieldlabelfrm.fieldSize.value!="0")
			document.fieldlabelfrm.formfieldlabels.value=document.fieldlabelfrm.selectlangids.value;
		doPost(fieldlabelfrm,tab3);
	}
	function fieldlablesall0(){
		var checks = $G("checkitems").value;
		if(check_form(fieldlabelfrm,checks)){
			doPost(fieldlabelfrm,tab3);
		}else{
			return;
		}		
	}

var helpURL = "/hrm/company/editSubcompanyFieldBatch.jsp?ajax=1";	
function setHelpURL(url){
    helpURL = url;
}
function showHelp()
{
    var pathKey = helpURL;
    //alert(pathKey);
    
    var operationPage = "http://help.e-cology.com.cn/help/RemoteHelp.jsp";

    var screenWidth = window.screen.width*1;
    var screenHeight = window.screen.height*1;
	var isEnableExtranetHelp = <%=isEnableExtranetHelp%>;
    if(isEnableExtranetHelp==1){
    	operationPage = "http://e-cology.com.cn/formmode/apps/ktree/ktreeHelp.jsp";
    }
    window.open(operationPage+"?pathKey="+pathKey,"_blank","top=0,left="+(screenWidth-800)/2+",height="+(screenHeight-90)+",width=800,status=no,scrollbars=yes,toolbar=yes,menubar=no,location=no");

}

//表单显示名
var fieldrowindex = 0;
function fieldlabeladdRow()
{
	var oTable = $G("oTable");
    var selectlangids = document.fieldlabelfrm.selectlangids.value;
    var rowColor="" ;
    rowColor = getRowBg();
	//ncol = oTable.cols;
	ncol = oTable.rows[0].cells.length;
	var oOption=document.fieldlabelfrm.languageList;
	if(oOption.value==''){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15457,user.getLanguage())%>！");
		return;
	}
	if(selectlangids.indexOf(oOption.value)!=-1){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15458,user.getLanguage())%>!");
		return;
	}
	oRow = oTable.rows[0];          		//在table中第一行,返回行的id
	oCell = oRow.insertCell(-1);
	//oCell.style.background= rowColor;
	//oCell.style.height=23;
	var oDiv = document.createElement("div");
	var sHtml = "<input type='checkbox' name='check_lang' value='" + oOption.value +"'>";
	sHtml += "<%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%>("+ languagespan.innerHTML +")";
	oDiv.innerHTML = sHtml;    //内嵌html语句
	oCell.appendChild(oDiv);   //将odiv插入到ocell后面,作为ocell的内容
    eval(document.fieldlabelfrm.insertlabels.value);

	fieldrowindex +=parseInt(document.fieldlabelfrm.rownum.value);
	selectlangids += oOption.value;
	selectlangids += ",";
    document.fieldlabelfrm.selectlangids.value=selectlangids;
}

function fieldlabeldelRow()
{
    if (isdel()){
    var selectlangids = document.fieldlabelfrm.selectlangids.value;
	len = document.fieldlabelfrm.elements.length;
    rownum=parseInt(document.fieldlabelfrm.rownum.value);
    var i=0;
	var temps="";;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.fieldlabelfrm.elements[i].name=='check_lang')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.fieldlabelfrm.elements[i].name=='check_lang'){
			if(document.fieldlabelfrm.elements[i].checked==true) {
//				if(document.fieldlabelfrm.elements[i].value!='0')
//					delids +=","+ document.fieldlabelfrm.elements[i].value;
				var tmp = document.fieldlabelfrm.elements[i].value + ',';
				if (temps!="")
				temps= temps+","+document.fieldlabelfrm.elements[i].value;
				else
				temps= document.fieldlabelfrm.elements[i].value;
				selectlangids=selectlangids.replace(tmp, '');
				//alert(selectlangids+" "+tmp+" "+selectlangids);
				

			}
			rowsum1 -=1;
		}

	}
	
	if (temps!="")
	{
	temparray=temps.split(",");
	for (l=0;l<temparray.length;l++)
	{
	var m=0;
	var tempss=temparray[l];
    if(oTable.rows[0].cells.length>1)
	{
	for (k=0;k<oTable.rows[0].cells.length;k++)
		{
	     if (oTable.rows[0].cells[k].innerHTML.indexOf(tempss)>0&&oTable.rows[0].cells[k].innerHTML.indexOf("checkbox")>0)
			{
		      m=k;
		    }
	    }
	}
	for(j=0;j<oTable.rows.length;j++)
		{
			if(oTable.rows[j].cells.length>1)
			{ 
				oTable.rows[j].deleteCell(m);
			}
		}
	}
	}
    document.fieldlabelfrm.selectlangids.value=selectlangids;
    }
}
jQuery(document).ready(function(){
	
})
function showlanguage(){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	data = window.showModalDialog("/systeminfo/language/LanguageBrowser.jsp","","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if (data) {
		if (data.id!=""){
		    $G("languagespan").innerHTML = data.name;
			$G("languageList").value = data.id;
		}else{
			$G("languagespan").innerHTML = "";
			$G("languageList").value = "";
		}
	}
}
jQuery(document).ready(function(){
	jQuery(window).resize()
})
</script>
<script language="VBScript">
sub adfonShowSubcompany()
	id0 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowManage:All&selectedids="&addformtabspecial.subcompanyid.value)
	issame = false
	if (Not IsEmpty(id0)) then
	if id0(0)<> 0 then
	if id0(0) = addformtabspecial.subcompanyid.value then
		issame = true
	end if
	subcompanyspan1.innerHtml = id0(1)
	addformtabspecial.subcompanyid.value=id0(0)
	else
	subcompanyspan1.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	addformtabspecial.subcompanyid.value=""
	end if
	end if
end sub


sub onShowFormSelectForCopy(isbill,inputName, spanName,isMand)
	id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/wfFormBrowser.jsp?isbill="+isbill)

	if (Not IsEmpty(id1)) then
	    if id1(0)<>"" then
		    inputName.value=id1(0)
		    spanName.innerHtml = id1(1)
	    else
		    inputName.value=""
		    if isMand=1 then
			    spanName.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			else
			    spanName.innerHtml = ""
			end if
	    end if
	end if
end sub
</script>
