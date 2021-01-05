<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.workflow.UserWFOperateLevel" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="FormManager" class="weaver.workflow.form.FormManager" scope="session"/>
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<%FormFieldMainManager.resetParameter();%>
<jsp:useBean id="FormFieldlabelMainManager" class="weaver.workflow.form.FormFieldlabelMainManager" scope="page" />
<%FormFieldlabelMainManager.resetParameter();%>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="DetailFieldComInfo" class="weaver.workflow.field.DetailFieldComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<HTML><HEAD>
<%
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	int isbill = Util.getIntValue(request.getParameter("isbill"),0);
	int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
	int operatelevel=UserWFOperateLevel.checkWfFormOperateLevel(detachable,user,"FormManage:All",formid,isbill);
	if(!HrmUserVarify.checkUserRight("FormManage:All", user) || operatelevel < 0){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
    String ajax=Util.null2String(request.getParameter("ajax"));
%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<script language=javascript src="/js/weaver_wev8.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<%
	String formname="";
	String formdes="";
	

	FormManager.setFormid(formid);
	FormManager.getFormInfo();
	formname=FormManager.getFormname();
	formdes=FormManager.getFormdes();
	formdes = Util.StringReplace(formdes,"\n","<br>");
	formname = formname.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
	formdes = formdes.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
	int fieldsum = 0;
	int rownum = fieldsum+1;
	ArrayList langids=new ArrayList();
	ArrayList fields=new ArrayList();
	ArrayList detailfields=new ArrayList();
	ArrayList isdetails=new ArrayList();
	langids.clear();
	fields.clear();
	isdetails.clear();
	String insertlabels="";
	String haslabelslang = "";

	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(699,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(176,user.getLanguage());
	String needfav ="";
	if(!ajax.equals("1")){
		needfav ="1";
	}
	String needhelp ="";
    int subCompanyId= -1;

 
	FormFieldMainManager.setFormid(formid);
	FormFieldMainManager.selectAllFormField();
	while(FormFieldMainManager.next()){
		fieldsum+=1;
		int curid=FormFieldMainManager.getFieldid();
		fields.add(""+curid);
		isdetails.add(FormFieldMainManager.getIsdetail());
	}
	
	FormFieldMainManager.selectAllDetailFormField();
	while(FormFieldMainManager.next()){
		int curid=FormFieldMainManager.getFieldid();
		detailfields.add(""+curid);
	}
%>
<script>
rowindex = 0;
</script>

<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(operatelevel>0){
	if(!ajax.equals("1"))
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:selectall(),_self}" ;
	else
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:fieldlablesall(),_self}" ;
		RCMenuHeight += RCMenuHeightStep ;
}

if(!ajax.equals("1")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",addform.jsp?src=editform&formid="+formid+",_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
}
if(operatelevel>0){
    if(!ajax.equals("1"))
    RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:addRow(),_self}" ;
    else
    RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:fieldlabeladdRow(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    if(!ajax.equals("1"))
    RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:submitClear(),_self}" ;
    else
    RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:fieldlabeldelRow(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="fieldlabelfrm" id=fieldlabelfrm method=post action="/workflow/form/form_operation.jsp">
<input type="hidden" value="formfieldlabel" name="src">
<input type="hidden" value="<%=formid%>" name="formid">
<input type="hidden" value="" name="formfieldlabels">
<input type=hidden name="ajax" value="<%=ajax%>">
<input type="hidden" value="<%=fields.size()%>" name="fieldSize">
<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<%if(operatelevel > 0){ %>
    			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" <%if(!ajax.equals("1")) {%> onclick="javascript:selectall()" <%}else{ %> onclick="javascript:fieldlablesall()"<%}%> >
    			<%} %>
				<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
</table>
<% if(fields.size()==0){ %>
<div><font color="#FF0000"><%=SystemEnv.getHtmlLabelName(15454,user.getLanguage())%></font></div>
</form>
<script>
function selectall(){
	window.document.fieldlabelfrm.submit();
}
</script>
</body>
</html>
<% return; }%> 	
<wea:layout type="twoCol">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%>'>
    	<wea:item><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%></wea:item>
	    <wea:item>
		<brow:browser name="languageList" viewType="0" hasBrowser="true" hasAdd="false" 
        browserUrl="/systeminfo/BrowserMain.jsp?url=/systeminfo/language/LanguageBrowser.jsp" isMustInput="1" isSingle="true" hasInput="true"
        completeUrl=""  width="150px" browserValue="" browserSpanValue="" />
        <!--      
  			<button type="button" class=browser onClick="showlanguage()"></button>
		    <span id=languagespan></span>
	  		<input type=hidden name="languageList">
	  	-->	
  		</wea:item>
  		<wea:item attributes="{'isTableList':'true'}">
			<%
			int colnum =1;
			FormFieldlabelMainManager.setFormid(formid);
			FormFieldlabelMainManager.selectLanguage();
			%>
			<table cols=<%=colnum%> id="oTable" class=ListStyle cellspacing=0   width="100%">
				<tr class=header>
			  		<td><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
					<%
					while(FormFieldlabelMainManager.next()){
						int curid=FormFieldlabelMainManager.getLanguageid();
						langids.add(""+curid);
						haslabelslang += curid;
						haslabelslang += ",";
					%>
					<td><input type='checkbox' name='check_lang' value=<%=curid%>><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%>(<%=LanguageComInfo.getLanguagename(""+curid)%>)</td>
					<%}
					%>

				 </tr>
				<%
				int tmpnum = 1;
				int colorcount1 = 1;
				
				for(int tmpcount=0; tmpcount< fields.size(); tmpcount++) {
					String curid=(String)fields.get(tmpcount);
					int i=tmpcount+1;
					String isdetailtemp=(String)isdetails.get(tmpcount);
					insertlabels += "oRow = oTable.rows["+i+"];";
					insertlabels += "oCell = oRow.insertCell(-1);";
					insertlabels += "var oDiv = document.createElement('div');var sHtml = '<input type=input class=inputstyle name=label_'+oOption.value+'_";
					insertlabels += curid;
					insertlabels += " maxlength=\\'100\\' onblur=\\'javascript:checkMaxLength(this)\\'";
					insertlabels += " alt=\\'"+ SystemEnv.getHtmlLabelName(20246,user.getLanguage()) + "100(" + SystemEnv.getHtmlLabelName(20247,user.getLanguage())+")\\'";
				    insertlabels += " style=width:99%; >';";
					insertlabels += "oDiv.innerHTML = sHtml;oCell.appendChild(oDiv);";
				if(colorcount1==0){
						colorcount1=1;
				%>
				<tr class=DataLight>
				<%
				}else{
					colorcount1=0;
				%>
				<tr class=DataDark>
				<%}%>
					<td>
	       
					 <%if(detailfields.indexOf(""+curid)==-1){%>
					  <%=FieldComInfo.getFieldname(curid)%><%if(!FieldComInfo.getFieldDesc(curid).trim().equals("")){%><%="["+FieldComInfo.getFieldDesc(curid)+"]"%><%}%>
					  <%}else{
					  if(!"1".equals(isdetailtemp)){%>
					   <%=FieldComInfo.getFieldname(curid)%><%if(!FieldComInfo.getFieldDesc(curid).trim().equals("")){%><%="["+FieldComInfo.getFieldDesc(curid)+"]"%><%}%>
					  <%}else{%>
					  <%="["+DetailFieldComInfo.getFieldname(curid)+"]"%><%if(!DetailFieldComInfo.getFieldDesc(curid).trim().equals("")){%><%="["+DetailFieldComInfo.getFieldDesc(curid)+"]"%><%}%>
					  <%}
					  }%>
 					</td>

					<%
					int colorcount = 1;
					for (int tmpcount1=0;tmpcount1<langids.size();tmpcount1++)
						{
						String curidlanguage=(String)langids.get(tmpcount1);
						FormFieldlabelMainManager.resetParameter();
					
						tmpnum = 1;
					
						String tfieldid=(String)curid;
						FormFieldlabelMainManager.resetParameter();
						FormFieldlabelMainManager.setFormid(formid);
						FormFieldlabelMainManager.setFieldid(Util.getIntValue(tfieldid,0));
						FormFieldlabelMainManager.setLanguageid(Util.getIntValue(curidlanguage,0));
						FormFieldlabelMainManager.selectSingleFormField();
					%>


					<td><input type="text" class=inputstyle style="width:99%;" name="label_<%=curidlanguage%>_<%=tfieldid%>" value="<%=FormFieldlabelMainManager.getFieldlabel()%>" maxlength="100" onblur="checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>100(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)"></td>
					<%}%>
				</tr>
			<%}%>
			</table>
		    <input type="hidden" value="<%=rownum%>" name="rownum">
		    <input type="hidden" value="<%=insertlabels%>" name="insertlabels"> 
		    <input type="hidden" value="<%=haslabelslang%>" name="selectlangids"> 	
  		</wea:item>
    </wea:group>    
</wea:layout>
</form>
<br/>
<script language="JavaScript" src="/js/addRowBg_wev8.js" ></script>
<%
if(!ajax.equals("1")){
%>
<script type="text/javascript">
var selectlangids = document.fieldlabelfrm.selectlangids.value;
var rowColor="" ;
function addRow()
{	rowColor = getRowBg();
	ncol = oTable.cols;
	var oOption=document.fieldlabelfrm.languageList;
	if(oOption.value==''){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15457,user.getLanguage())%>！");
		return;
	}
	if(selectlangids.indexOf(oOption.value)!=-1){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15458,user.getLanguage())%>!");
		return;
	}
	oRow = oTable.rows[0];          		//在table中第一行,返回行的id
	oCell = oRow.insertCell();
	//oCell.style.background= rowColor;
	//oCell.style.height=23;
	var oDiv = document.createElement("div");
	var sHtml = "<input type='checkbox' name='check_lang' value='" + oOption.value +"'>";
//	oDiv.innerHTML = sHtml;    //内嵌html语句
//	oCell.appendChild(oDiv);   //将odiv插入到ocell后面,作为ocell的内容

//	oCell = oRow.insertCell();
//	oCell.style.background= "#D2D1F1";
//	oCell.style.height=23;
//	var oDiv = document.createElement("div");
	var languagelistspan = $("#languageListspan").find("a").html();
	sHtml += "<%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%>("+ languagelistspan +")";
	oDiv.innerHTML = sHtml;    //内嵌html语句
	oCell.appendChild(oDiv);   //将odiv插入到ocell后面,作为ocell的内容


	<%--oCell = oRow.insertCell();--%>
	<%--oCell.style.background= rowColor;--%>
	<%--oCell.style.height=23;--%>
	<%--var oDiv = document.createElement("div"); //在document中创建一个元素,参数表示这个元素的tagname--%>
	<%--var sHtml = "<input type='radio' name='isdefault' value='" + oOption.value+"'>"; // add value--%>
	<%--oDiv.innerHTML = sHtml;    //内嵌html语句--%>
	<%--oCell.appendChild(oDiv);   //将odiv插入到ocell后面,作为ocell的内容--%>
    <%--alert(oOption.value);--%>
    <%--alert("<%=insertlabels%>");--%>
	<%=insertlabels%>

	rowindex +=<%=rownum%>;
	selectlangids += oOption.value;
	selectlangids += ",";
//	document.fieldlabelfrm.languageList.options[document.fieldlabelfrm.languageList.selectedIndex].disabled  = true;
}

function deleteRow1()
{
	len = document.fieldlabelfrm.elements.length;
	var i=0;
	var temps="";
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
	if(temps == ""){
		 top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15445,user.getLanguage())%>");
		 return false;
	}
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
	if (temps!=""){
		temparray=temps.split(",");
		for (l=0;l<temparray.length;l++){
			var m=0;
			var tempss=temparray[l];
		    if(oTable.rows(0).cells.length>1){
				for (k=0;k<oTable.rows(0).cells.length;k++){
					if(oTable.rows(0).cells(k).innerHTML.indexOf(tempss)>0&&oTable.rows(0).cells(k).innerHTML.indexOf("checkbox")>0){
					      m=k;
					  }
				}
			}
			for(j=0;j<oTable.rows.length;j++){
					if(oTable.rows(j).cells.length>1){ 
						oTable.rows(j).deleteCell(m);
					}
			}
		}
	}
    document.fieldlabelfrm.selectlangids.value=selectlangids;
	}, function () {}, 320, 90,true);
	
}

function selectall(){
	
	window.document.fieldlabelfrm.formfieldlabels.value=selectlangids;
	window.document.fieldlabelfrm.submit();
}

function submitData()
{
	if (checksubmit())
		fieldlabelfrm.submit();
}

function submitClear()
{
	//if (isdel())
	//15457
	deleteRow1();
}

function showlanguage() {
	var id = window.showModalDialog("/systeminfo/language/LanguageBrowser.jsp");
	if (id != null) {
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		if (rid != 0) {
			$G("languagespan").innerHTML = rname;
			$G("languageList").value = rid;
		} else {
			$G("languagespan").innerHTML = "";
			$G("languageList").value = "";
		}
	}
}
</script>
<%}else{%>
<script type="text/javascript">
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
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15457,user.getLanguage())%>！");
		return;
	}
	if(selectlangids.indexOf(oOption.value)!=-1){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15458,user.getLanguage())%>!");
		return;
	}
	oRow = oTable.rows[0];          		//在table中第一行,返回行的id
	oCell = oRow.insertCell(-1);
	//oCell.style.background= rowColor;
	//oCell.style.height=23;
	var oDiv = document.createElement("div");
	var sHtml = "<input type='checkbox' name='check_lang' value='" + oOption.value +"'>";
	var languagelistspan = $("#languageListspan").find("a").html();
	sHtml += "<%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%>("+ languagelistspan +")";
	oDiv.innerHTML = sHtml;    //内嵌html语句
	oCell.appendChild(oDiv);   //将odiv插入到ocell后面,作为ocell的内容
	oRow = oTable.rows[1];
    <%=insertlabels %>

	fieldrowindex +=parseInt(document.fieldlabelfrm.rownum.value);
	selectlangids += oOption.value;
	selectlangids += ",";
    document.fieldlabelfrm.selectlangids.value=selectlangids;
    jQuery("body").jNice();
}

function fieldlabeldelRow()
{
    //if (isdel()){
			//deleteRow1();
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
	
	if(temps == ""){
		 top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15445,user.getLanguage())%>");
		 return false;
	}
	
    top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
	if (temps!=""){
		temparray=temps.split(",");
		for (l=0;l<temparray.length;l++){
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
    
    }, function () {}, 320, 90,true);
}

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

function fieldlablesall(){
    if(document.fieldlabelfrm.fieldSize.value!="0")
	document.fieldlabelfrm.formfieldlabels.value=document.fieldlabelfrm.selectlangids.value;
    tab04oldurl="";
    tab05oldurl="";
    fieldlabelfrm.submit();
}
</script>
<%} %>

</body>

</html>
