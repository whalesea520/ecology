<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.hrm.util.html.HtmlElement,org.json.JSONObject" %>
<%@ page import="weaver.docs.docs.CustomFieldManager,weaver.hrm.definedfield.HrmFieldManager" %>
<!-- modified by wcd 2014-07-04 [E7 to E8] -->
<%@ include file="/hrm/resource/uploader.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="HrmResourceFile" class="weaver.hrm.tools.HrmResourceFile" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="HrmFieldGroupComInfo" class="weaver.hrm.definedfield.HrmFieldGroupComInfo" scope="page"/>
<jsp:useBean id="DepartmentVirtualComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page"/>
<%
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String planid = Util.null2String(request.getParameter("planid"));
	String id = Util.null2String(request.getParameter("id"));
	String sql = "select a.lastname,a.sex,c.id as jobtitle,a.departmentid from HrmCareerApply a left join HrmCareerInvite b on a.jobtitle = b.id left join HrmJobTitles c on b.careername = c.id where a.id = "+id;
	rs.executeSql(sql);
	rs.next();
	String jobtitle =Util.null2String(rs.getString("jobtitle"));
	String lastname,sex;
	lastname = rs.getString("lastname");
	sex = rs.getString("sex");
	String departmentidtmp = Util.null2String(rs.getString("departmentid"));
	boolean flagaccount = weaver.general.GCONST.getMOREACCOUNTLANDING();
	boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(773,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(1853,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	int scopeId = -1;
	String workcode ="";
	String needinputitems = "";
	String mobileshowtype = "";
	String isView = request.getParameter("isView");
%>
<HTML>
	<HEAD>
		<STYLE>
		.SectionHeader {
			FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
		}
		.InputStyle{width:30%!important;}
		.inputstyle{width:30%!important;}
		.Inputstyle{width:30%!important;}
		.inputStyle{width:30%!important;}
		.e8_os{width:30%!important;}
		select.InputStyle{width:10%!important;} 
		select.inputstyle{width:10%!important;} 
		select.inputStyle{width:10%!important;} 
		select.Inputstyle{width:10%!important;} 
		textarea.InputStyle{width:70%!important;} 
		</STYLE>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/chechinput_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<link href="/hrm/css/Contacts_wev8.css" rel="stylesheet" type="text/css" />
		<link href="/hrm/css/Public_wev8.css" rel="stylesheet" type="text/css" />
		<SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/checknumber_wev8.js"></script>
		<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
		<script language="javascript" type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var parentDialog = parent.parent.getDialog(parent);
			if("<%=isclose%>"=="1"){
				openResource();
				parentWin.closeDialog();
			}
		 	function doSave(){
				if(check_form(document.frmMain,'departmentid,costcenterid,jobtitle,managerid,locationid')){
					document.frmMain.submit();
				}
		 	}
			
			function openResource(){
				window.open("/hrm/HrmTab.jsp?_fromURL=HrmResource&id=<%=id%>");
			}
			var common = new MFCommon();
			function onDepartmentDel(text,fieldid,params){
				_writeBackData('jobtitle','2',{'id':'','name':''});
				hideEle("itemjobtitle");
			}

			function showAlert(msg){
				window.top.Dialog.alert(msg);
			}
			function showConfirm(msg){
				return confirm(msg);
			}
			function checkPass(){
				saveBtn.disabled = true;
				document.resourcebasicinfo.submit() ;
			}

			function onBelongToChange(){
				val = jQuery("#accounttype").val();
				if(val=="0"){
					hideEle("belongtodata");
					jQuery("input[name=belongto]").attr("ismustinput","1")
				}
				else {
					showEle("belongtodata");
					if (jQuery("input[name=belongto]").val() == "" ||jQuery("input[name=belongto]").val() == "-1"){
						jQuery("input[name=belongto]").attr("ismustinput","2")
						jQuery("#belongtospanimg").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
					}
				} 
			}

			jQuery(document).ready(function(){
				$("#accounttype").change(function(){
				onBelongToChange();
				});
			})
		</script>
	</head>
	<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave();,_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM id=weaver name=frmMain action="HrmApplyOperation.jsp" method=post enctype="multipart/form-data">
			<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
<%
HrmFieldGroupComInfo.setTofirstRow();
HrmFieldManager hfm = new HrmFieldManager("HrmCustomFieldByInfoType",scopeId);
CustomFieldManager cfm = new CustomFieldManager("HrmCustomFieldByInfoType",scopeId);
hfm.getHrmData(Util.getIntValue(id));
cfm.getCustomData(Util.getIntValue(id));
while(HrmFieldGroupComInfo.next()){
	int grouptype = Util.getIntValue(HrmFieldGroupComInfo.getType());
	if(grouptype!=scopeId)continue;
	int grouplabel = Util.getIntValue(HrmFieldGroupComInfo.getLabel());
	int groupid = Util.getIntValue(HrmFieldGroupComInfo.getid());
	hfm.getCustomFields(groupid);
	if(hfm.getGroupCount()==0)continue;
	%>
<wea:group context='<%=SystemEnv.getHtmlLabelName(grouplabel,user.getLanguage())%>'>	
<%
	while(hfm.next()){
		if(!hfm.isUse())continue;
		int fieldlabel=Util.getIntValue(hfm.getLable());
		String fieldName=hfm.getFieldname();
		int fieldId=hfm.getFieldid();
		int type = hfm.getType();
		int fieldhtmltype = Util.getIntValue(hfm.getHtmlType());
		String fieldValue="";
		if(hfm.isBaseField(fieldName)){
			fieldValue = hfm.getHrmData(fieldName);
			if(hfm.isMand() && !fieldName.equals("managerid"))  needinputitems+= ","+fieldName;
		}else{
			fieldValue = cfm.getData("field"+hfm.getFieldid());
			if(hfm.isMand())  needinputitems+= ",customfield"+hfm.getFieldid();
		}
		if(fieldName.equals("jobactivity"))continue;
		else if(fieldName.equals("systemlanguage") && !isMultilanguageOK)continue;
		else if(fieldName.equals("workcode"))workcode=fieldValue;
		else if(fieldName.equals("lastname"))fieldValue=lastname;
		else if(fieldName.equals("sex"))fieldValue=sex;
		//else if(fieldName.equals("departmentid"))fieldValue = JobTitlesComInfo.getDepartmentid(jobtitle);
		else if(fieldName.equals("jobtitle"))fieldValue = jobtitle;
		JSONObject hrmFieldConf = hfm.getHrmFieldConf(fieldName);
		String attr = "{}";
		if(fieldName.equals("belongto"))attr = "{\"samePair\":\"belongtodata\",'display':'none'}";
		//if(fieldName.equals("jobtitle"))attr = "{\"samePair\":\"itemjobtitle\",'display':'none'}";
		if(fieldName.equals("mobile")){
			RemindSettings hrmsettings=(RemindSettings)application.getAttribute("hrmsettings");
		  String mobileShowSet = Util.null2String(hrmsettings.getMobileShowSet());
		  String mobileShowType = Util.null2String(hrmsettings.getMobileShowType());
		%>
		<wea:item><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></wea:item>
		<wea:item>
		  <input class=inputstyle type=text name=mobile value="<%=fieldValue%>">
			<%if(mobileShowSet.equals("1")){ 
			%>
			<select name="mobileshowtype" style="width: 200px">
				<%if(mobileShowType.indexOf("1")!=-1){ %>
			<option value="1" <%=mobileshowtype.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(2161,user.getLanguage())%></option>
			<%}if(mobileShowType.indexOf("2")!=-1){ %>
			<option value="2" <%=mobileshowtype.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32670,user.getLanguage())%></option>
			<%}if(mobileShowType.indexOf("3")!=-1){ %>
			<option value="3" <%=mobileshowtype.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32671,user.getLanguage())%></option>
			<%} %>
			</select>
			<%} %>
		</wea:item>		
		<%
		}else if(fieldName.equals("resourceimageid")){
		//照片特殊处理
		%>
		<%if(!fieldValue.equals("0")&&!fieldValue.equals("") ){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(15707,user.getLanguage())%></wea:item>
      	<wea:item>
      		<BUTTON class=delbtn accessKey=D onClick="delpic()" type="button" title="<%=SystemEnv.getHtmlLabelName(16075,user.getLanguage())%>"></BUTTON>
      		<span style="vertical-align: middle;"><%=SystemEnv.getHtmlLabelName(16075,user.getLanguage())%></span>
      		<input class=inputstyle type=hidden name=oldresourceimage value="<%=fieldValue%>">
      	</wea:item>
			<%}else{%>
			<wea:item><%=SystemEnv.getHtmlLabelName(15707,user.getLanguage())%></wea:item>
			<wea:item><input class=inputstyle type=file name=photoid value='<%=fieldValue%>' style="width: 300px"></wea:item>
			<wea:item>&nbsp;</wea:item>
			<wea:item>(<%=SystemEnv.getHtmlLabelName(21130,user.getLanguage())%>:400*450)</wea:item>
			<%}%>
			<%if(!fieldValue.equals("0")&&fieldValue.length()>0){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(33470,user.getLanguage())%></wea:item>
 				<wea:item><img class="ContactsAvatar" style="right: 0;z-index: 999" border=0 id=resourceimage src="/weaver/weaver.file.FileDownload?fileid=<%=fieldValue%>"></div></wea:item>
			<%} %>
		<% 
		}else if(fieldName.equals("departmentvirtualids")){%>
		<%
			//有虚拟部门才显示
			boolean hasHrmDeartmentVirtual = false;
			rs.executeSql(" select count(*) from hrmdepartmentvirtual");
			if(rs.next()){
				if(rs.getInt(1)>0)hasHrmDeartmentVirtual = true;
			}
			if(hasHrmDeartmentVirtual){
				//显示人员所在的虚拟部门
				String departmentvirtualids= "";
				rs.executeSql(" select departmentid from hrmresourcevirtual where resourceid = "+id);
				while(rs.next()){
					if(departmentvirtualids.length()>0)departmentvirtualids+=",";
					departmentvirtualids+=rs.getString("departmentid");
				}
			%>
			<wea:item><%=SystemEnv.getHtmlLabelName(34101,user.getLanguage()) %></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="departmentvirtualids" browserValue='<%=departmentvirtualids %>' 
	       browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/companyvirtual/MutiDepartmentBrowser.jsp?selectedids="
	       hasInput="true" isSingle="false" hasBrowser="true" isMustInput='1'
	       completeUrl="/data.jsp?type=hrmdepartmentvirtual" width="200px"
	       browserSpanValue='<%=DepartmentVirtualComInfo.getDepartmentNames(departmentvirtualids) %>'>
       	</brow:browser> 
			</wea:item>
		<%}}else if(hfm.getHtmlType().equals("6")){
        	String[] resourceFile = HrmResourceFile.getResourceFile(""+id, scopeId, hfm.getFieldid());
        	int maxsize = 100;
       %>
     <wea:item attributes='<%=attr %>'><%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%></wea:item>
     <wea:item attributes='<%=attr %>'>
      <div id="uploadDiv" name="uploadDiv" maxsize="<%=maxsize%>" resourceId="<%=id%>" scopeId="<%=scopeId %>" fieldId="<%=hfm.getFieldid()%>"></div>
      <div>
        <%=resourceFile[1] %>
      	<input class=inputstyle type="hidden" id="customfield<%=hfm.getFieldid()%>" name="customfield<%=hfm.getFieldid()%>" value="<%=resourceFile[0].equals("")?"":"1" %>" onchange='checkinput("customfield<%=hfm.getFieldid()%>","customfield<%=hfm.getFieldid()%>span");'>
      		<SPAN id="customfield<%=hfm.getFieldid()%>span">
      		<%
							  if(hfm.isMand()&&resourceFile[0].equals("")) {
							%>
							    <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
							<%
							  }
							%>
					</SPAN>
      </div>
     </wea:item>
		<%}else{%>
		<wea:item attributes='<%=attr %>'><%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=attr %>'>
			<%=((HtmlElement)Class.forName(hrmFieldConf.getString("eleclazzname")).newInstance()).getHtmlElementString(fieldValue, hrmFieldConf, user) %>
		</wea:item>
	<%}
	}
%>
</wea:group>
<%} %>
</wea:layout>
			<%  if(software.equals("ALL") || software.equals("HRM")){%>	
				<input class=inputstyle id=costcenterid type=hidden name=costcenterid value='1'> 
			<%}else{%>
				<input class=inputstyle id=costcenterid type=hidden name=costcenterid value='1'>              
			<%}%>
			<input class=inputstyle type=hidden name=operation value="add">
			<input class=inputstyle type=hidden name=id value="<%=id%>">
			<input class=inputstyle type=hidden name=planid value="<%=planid%>">
		</form>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="parentDialog.closeByHand();">
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
<script type="text/javascript">
function getCompleteUrl(){
	var url= "/data.jsp?type=hrmjobtitles";
			url+="&sqlwhere= jobdepartmentid="+jQuery("input[name=departmentid]").val();
	return url;		
}
function onShowJobtitle(){ 
	url=encode("/hrm/jobtitles/JobTitlesBrowser.jsp?sqlwhere= where jobdepartmentid="+jQuery("input[name=departmentid]").val()+"&fromPage=add");
	url="/systeminfo/BrowserMain.jsp?mouldID=hrm&url="+url;
	return url;
	
	url=encode("/hrm/jobtitles/JobTitlesBrowser.jsp?sqlwhere= where jobdepartmentid="+jQuery("input[name=departmentid]").val()+"&fromPage=add");
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
	if (data!=null){
		if (data.id != 0 ){
			jQuery("#jobtitlespan").html(data.name);
			jQuery("input[name=jobtitle]").val(data.id);
		}else{
			jQuery("#jobtitlespan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			jQuery("input[name=jobtitle]").val("");
		}
	}
}


function onDepartmentAdd(e,datas,name){
		_writeBackData('jobtitle','2',{'id':'','name':''});
	if(datas.id==""){
		hideEle("itemjobtitle");
	}
	else {
		showEle("itemjobtitle");
	} 
}


function onShowDepartment(){
    url=encode("/hrm/company/DepartmentBrowser2.jsp?isedit=1&rightStr=HrmResourceEdit:Edit&selectedids="+$GetEle("departmentid").value);
    url = "/systeminfo/BrowserMain.jsp?mouldID=hrm&url="+url;
    return url;
}
</script>
 <script type="text/javascript">
  var saveBtn;
  var upfilesnum=0;//获得上传文件总数
  function encode(str){
       return escape(str);
    }  
  
  function dosave(obj){
    saveBtn = obj;
     if(jQuery("#accounttype").val()=="1"){
    	if (jQuery("input[name=belongto]").val() == "" ||jQuery("input[name=belongto]").val() == "-1"){
    		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
    		return false;
    	}
    }
    if(check_form(document.resourcebasicinfo,'<%=needinputitems%>')) {
		try{
			var oldDeptId = "<%=departmentidtmp%>";
			var newDeptId = $GetEle("departmentid").value;
			if(newDeptId != oldDeptId){
				var result = common.ajax("cmd=checkNewDeptUsers&arg="+newDeptId);
				if(result && result == "true"){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81926,user.getLanguage())%>");
					return false;
				}
			}
		}catch(e){}
	  	jQuery("div[name=uploadDiv]").each(function(){
	  		var oUploader=window[jQuery(this).attr("oUploaderIndex")];
	    	if(oUploader.getStats().files_queued>0){
	    		upfilesnum+=oUploader.getStats().files_queued;
	    		oUploader.startUpload();
	    	}
	    });
	  	if(upfilesnum==0) doSaveAfterAccUpload();
  	}
	}
function doSaveAfterAccUpload(){
  var frmLastName = encodeURI(document.all("lastname").value);//url编码 utf-8；
  var lastname = "<%=java.net.URLEncoder.encode(lastname,"utf-8")%>";
    
  if(jQuery("input[name=managerid]").val()==""){
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16072,user.getLanguage())%>",function(){
	 		//校验电子邮件
  	if(!chkMail()) return false;
  	if(<%=flagaccount%>){
	  	if(document.resourcebasicinfo.accounttype.value ==0){
	    	if(document.resourcebasicinfo.departmentid.value==""||
     			document.resourcebasicinfo.jobtitle.value==""||
     			document.resourcebasicinfo.locationid.value==""){
    			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>")
  			}else{
    			if(document.resourcebasicinfo.costcenterid.value=="") document.resourcebasicinfo.costcenterid.value=1;
    			if(check_formM(document.resourcebasicinfo,'lastname,locationid')){
      			document.resourcebasicinfo.operation.value = "editbasicinfo";
      			if(frmLastName!=lastname&&jQuery("#workcode").val()!="<%=workcode%>"){
        			checkHas.src="HrmResourceCheck.jsp?lastname="+jQuery("#lastname").val()+"&workcode="+jQuery("#workcode").val();
      			}else if(jQuery("#workcode").val()!="<%=workcode%>"){
        			checkHas.src="HrmResourceCheck.jsp?workcode="+jQuery("#workcode").val();
      			}else if(frmLastName!=lastname){
        			checkHas.src="HrmResourceCheck.jsp?lastname="+jQuery("#lastname").val();
      			}else{
        			saveBtn.disabled = true;
        			document.resourcebasicinfo.submit() ;
      			}
    			}
  			}
	  	}else{
	    	if(document.resourcebasicinfo.departmentid.value==""||
     			 document.resourcebasicinfo.jobtitle.value==""||
	 				 document.resourcebasicinfo.belongto.value==""||
     			 document.resourcebasicinfo.locationid.value==""){
     			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>")
  			}else{
    			if(document.resourcebasicinfo.costcenterid.value=="")document.resourcebasicinfo.costcenterid.value=1;
    			if(check_formM(document.resourcebasicinfo,'lastname,locationid')){
      			document.resourcebasicinfo.operation.value = "editbasicinfo";
	      		if(frmLastName!=lastname&&jQuery("#workcode").val()!="<%=workcode%>"){
	        		checkHas.src="HrmResourceCheck.jsp?lastname="+jQuery("#lastname").val()+"&workcode="+jQuery("#workcode").val();
	      		}else if(jQuery("#workcode").val()!="<%=workcode%>"){
	        		checkHas.src="HrmResourceCheck.jsp?workcode="+jQuery("#workcode").val();
	      		}else if(frmLastName!=lastname){
	        		checkHas.src="HrmResourceCheck.jsp?lastname="+jQuery("#lastname").val();
	      		}else{
	        		saveBtn.disabled = true;
	        		document.resourcebasicinfo.submit() ;
	      		}
    			}
  			}
	  	}
	  }else{
	  	if(document.resourcebasicinfo.departmentid.value==""||
     		 document.resourcebasicinfo.jobtitle.value==""||
     		 document.resourcebasicinfo.locationid.value==""){
     		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>")
  		}else{
    		if(document.resourcebasicinfo.costcenterid.value=="")document.resourcebasicinfo.costcenterid.value=1;
    		if(check_formM(document.resourcebasicinfo,'lastname,locationid')){
      		document.resourcebasicinfo.operation.value = "editbasicinfo";
	      	if(frmLastName!=lastname&&jQuery("#workcode").val()!="<%=workcode%>"){
	        	checkHas.src="HrmResourceCheck.jsp?lastname="+jQuery("#lastname").val()+"&workcode="+jQuery("#workcode").val();
	      	}else if(jQuery("#workcode").val()!="<%=workcode%>"){
	        	checkHas.src="HrmResourceCheck.jsp?workcode="+jQuery("#workcode").val();
	      	}else if(frmLastName!=lastname){
	        	checkHas.src="HrmResourceCheck.jsp?lastname="+jQuery("#lastname").val();
	      	}else{
	        	saveBtn.disabled = true;
	       		document.resourcebasicinfo.submit() ;
	      	}
    		}
  		}
	  }
	},function(){
	  	return false;
	  });
	}else{
		//校验电子邮件
  	if(!chkMail()) return false;
  	if(<%=flagaccount%>){
	  	if(document.resourcebasicinfo.accounttype.value ==0){
	    	if(document.resourcebasicinfo.departmentid.value==""||
     			 document.resourcebasicinfo.jobtitle.value==""||
     			 document.resourcebasicinfo.locationid.value==""){
     			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
  			}else{
    			if(document.resourcebasicinfo.costcenterid.value=="")document.resourcebasicinfo.costcenterid.value=1;
    			if(check_formM(document.resourcebasicinfo,'lastname,locationid')){
      			document.resourcebasicinfo.operation.value = "editbasicinfo";
      			if(jQuery("#lastname").val()!="<%=lastname%>"&&jQuery("#workcode").val()!="<%=workcode%>"){
        			var tmpSrc ="HrmResourceCheck.jsp?lastname="+jQuery("#lastname").val()+"&workcode="+jQuery("#workcode").val();
        			jQuery("#checkHas").attr("src",tmpSrc);
        			//checkHas.src="HrmResourceCheck.jsp?lastname="+jQuery("#lastname").val()+"&workcode="+jQuery("#workcode").val();
			      }else if(jQuery("#workcode").val()!="<%=workcode%>"){
			        var tmpSrc ="HrmResourceCheck.jsp?workcode="+jQuery("#workcode").val();
			        jQuery("#checkHas").attr("src",tmpSrc);
			        //checkHas.src="HrmResourceCheck.jsp?workcode="+jQuery("#workcode").val();
			      }else if(jQuery("#lastname").val()!="<%=lastname%>"){
			        var tmpSrc ="HrmResourceCheck.jsp?lastname="+jQuery("#lastname").val();
			        jQuery("#checkHas").attr("src",tmpSrc);
			        //checkHas.src="HrmResourceCheck.jsp?lastname="+jQuery("#lastname").val();
			      }else{
        			saveBtn.disabled = true;
        			document.resourcebasicinfo.submit() ;
      			}
      		}
  		  }
	  	}else{
	  		if(document.resourcebasicinfo.departmentid.value==""||
     			document.resourcebasicinfo.jobtitle.value==""||
	 				document.resourcebasicinfo.belongto.value==""||
     			document.resourcebasicinfo.locationid.value==""){
     	 			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
  			}else{
    			if(document.resourcebasicinfo.costcenterid.value=="")document.resourcebasicinfo.costcenterid.value=1;
    			if(check_formM(document.resourcebasicinfo,'lastname,locationid')){
      			document.resourcebasicinfo.operation.value = "editbasicinfo";
	      		if(jQuery("#lastname").val()!="<%=lastname%>"&&jQuery("#workcode").val()!="<%=workcode%>"){
	        		var tmpSrc="HrmResourceCheck.jsp?lastname="+jQuery("#lastname").val()+"&workcode="+jQuery("#workcode").val();
	        		jQuery("#checkHas").attr("src",tmpSrc);
	        		//checkHas.src="HrmResourceCheck.jsp?lastname="+jQuery("#lastname").val()+"&workcode="+jQuery("#workcode").val();
	      		}else if(jQuery("#workcode").val()!="<%=workcode%>"){
	       	 		var tmpSrc="HrmResourceCheck.jsp?workcode="+jQuery("#workcode").val();
	       	 		jQuery("#checkHas").attr("src",tmpSrc);
	       	 		//checkHas.src="HrmResourceCheck.jsp?workcode="+jQuery("#workcode").val();
	      		}else if(jQuery("#lastname").val()!="<%=lastname%>"){
	        		var tmpSrc="HrmResourceCheck.jsp?lastname="+jQuery("#lastname").val();
	        		jQuery("#checkHas").attr("src",tmpSrc);
	        		//checkHas.src="HrmResourceCheck.jsp?lastname="+jQuery("#lastname").val();
	      		}else{
	        		saveBtn.disabled = true;
	        		document.resourcebasicinfo.submit() ;
	      		}
    			}
  			}
	  	}
		}else{
	  	if(document.resourcebasicinfo.departmentid.value==""||
     		 document.resourcebasicinfo.jobtitle.value==""||
     		 document.resourcebasicinfo.locationid.value==""){
     		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>")
  		}else{
    		if(document.resourcebasicinfo.costcenterid.value=="")document.resourcebasicinfo.costcenterid.value=1;
    		if(check_formM(document.resourcebasicinfo,'lastname,locationid')){
      		document.resourcebasicinfo.operation.value = "editbasicinfo";
      		if(jQuery("#lastname").val()!="<%=lastname%>"&&jQuery("#workcode").val()!="<%=workcode%>"){
        		var tmpSrc="HrmResourceCheck.jsp?lastname="+jQuery("#lastname").val()+"&workcode="+jQuery("#workcode").val();
        		jQuery("#checkHas").attr("src",tmpSrc);
        		//checkHas.src="HrmResourceCheck.jsp?lastname="+jQuery("#lastname").val()+"&workcode="+jQuery("#workcode").val();
      		}else if(jQuery("#workcode").val()!="<%=workcode%>"){
        		var tmpSrc="HrmResourceCheck.jsp?workcode="+jQuery("#workcode").val();
        		jQuery("#checkHas").attr("src",tmpSrc);
        		//checkHas.src="HrmResourceCheck.jsp?workcode="+jQuery("#workcode").val();
      		}else if(jQuery("#lastname").val()!="<%=lastname%>"){
        		var tmpSrc="HrmResourceCheck.jsp?lastname="+jQuery("#lastname").val();
        		jQuery("#checkHas").attr("src",tmpSrc);
        		//checkHas.src="HrmResourceCheck.jsp?lastname="+jQuery("#lastname").val();
      		}else{
        		saveBtn.disabled = true;
        		document.resourcebasicinfo.submit() ;
      		}
    		}
  		}
	  }
	}
}

 function delpic(){
      if(confirm("<%=SystemEnv.getHtmlLabelName(83460,user.getLanguage())%>")){
	  document.resourcebasicinfo.operation.value = "delpic";
	  document.resourcebasicinfo.submit();
       }
  }
  function viewBasicInfo(){
    if(<%=isView%> == 0){
      location = "/hrm/resource/HrmResourceBase.jsp?id=<%=id%>";  
    }else{
      if('<%=isfromtab%>'=='true')
      	location = "/hrm/resource/HrmResourceBase.jsp?id=<%=id%>";
      else
      	location = "/hrm/resource/HrmResource.jsp?id=<%=id%>";
    }
  }

function check_formM(thiswins,items)
{
	thiswin = thiswins
	items = ","+items + ",";
	for(i=1;i<=thiswin.length;i++)
	{
	tmpname = thiswin.elements[i-1].name;
	tmpvalue = thiswin.elements[i-1].value;
	if(tmpname=="locationid"){
		if(tmpvalue == 0){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>"); 
			return false;
		}
	}
    if(tmpvalue==null){
        continue;
    }
	while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);
	
	if(tmpname!="" &&items.indexOf(","+tmpname+",")!=-1 && tmpvalue == ""){
		 window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
		 return false;
		}

	}
	return true;
}
    
  jQuery(document).ready(function(){
    //绑定附件上传
    if(jQuery("div[name=uploadDiv]").length>0)
    	jQuery("div[name=uploadDiv]").each(function(){
        bindUploaderDiv($(this),"relatedacc"); 
      });
  });
  
  function filedel(inputname,spanname,fileid){
  	jQuery("#file"+fileid).remove();
  	//删除附件
		jQuery.ajax({
		type:'post',
		url:'uploaderOperate.jsp',
		data:{"cmd":"delete","fileId":fileid},
		dataType:'text',
		success:function(msg){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20461, user.getLanguage())%>");
		},
		error:function(){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20462, user.getLanguage())%>");
		}
		});
  }
  
  function downloads(files)
  { 
  	$G("fileDownload").src="/weaver/weaver.file.FileDownload?fileid="+files+"&download=1";
  }
  onBelongToChange()
  
  jQuery(document).ready(function(){
	<%if(departmentidtmp.length()>0){%>
	showEle("itemjobtitle");
	<%}%>
	})

function chkMail(){
	if(document.resourcebasicinfo.email.value == ''){
		return true;
	}

	var email = document.resourcebasicinfo.email.value;
	var pattern =  /^(?:[a-z\d]+[_\-\+\.]?)*[a-z\d]+@(?:([a-z\d]+\-?)*[a-z\d]+\.)+([a-z]{2,})+$/i;
	chkFlag = pattern.test(email);
	if(chkFlag){
		return true;
	}
	else
	{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24570,user.getLanguage())%>");
		document.resourcebasicinfo.email.focus();
		return false;
	}
	}
	
	function onShowBrowser(id,url,linkurl,type1,ismand){
    spanname = "customfield"+id+"span";
	inputname = "customfield"+id;
	if (type1== 2 || type1 == 19){
		if (type1 == 2){
			onWorkFlowShowDate(spanname,inputname,ismand);
		}else{
			onWorkFlowShowTime(spanname,inputname,ismand);
		}
	}else{
		if (type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170&& type1!=168){
			tmpids = jQuery("input[name=customfield"+id+"]").val();
			id1 = window.showModalDialog(url+"?resourceids="+tmpids);
		}else if (type1==4 || type1==167 || type1==164 || type1==169 || type1==170){
            tmpids = jQuery("input[name=customfield"+id+"]").val();
			id1 = window.showModalDialog(url+"?selectedids="+tmpids)
		}else if (type1==37){
            tmpids = jQuery("input[name=customfield"+id+"]").val();
			id1 = window.showModalDialog(url+"?documentids="+tmpids)
		}else{
			tmpids = jQuery("input[name=customfield"+id+"]").val();
			id1 = window.showModalDialog(url+"?resourceids="+tmpids)
		}
		if (id1!=null){
			if (type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65|| type1==168){
				if (id1.id!= ""  && id1.id!= "0"){
					ids = id1.id.split(",");
					names =id1.name.split(",");
					sHtml = "";
					id1ids="";
					id1idnum=0;
					for( var i=0;i<ids.length;i++){
						if(ids[i]!=""){
							curid=ids[i];
							curname=names[i];					
							sHtml = sHtml+"<a href="+linkurl+curid+">"+curname+"</a>&nbsp;";
							if(id1idnum==0){
								id1ids=curid;
								id1idnum++;
							}else{
								id1ids=id1ids+","+curid;
								id1idnum++;
							}
						}
					}
					
					jQuery("#customfield"+id+"span").html(sHtml);
					jQuery("input[name=customfield"+id+"]").val(id1ids);					
				}else{
					if (ismand==0){
						jQuery("#customfield"+id+"span").html("");
					}else{
						jQuery("#customfield"+id+"span").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
						}
					jQuery("input[name=customfield"+id+"]").val("");
				}
			}else{
			   if  (id1.id!="" && id1.id!= "0"){
			        if (linkurl == ""){
						jQuery("#customfield"+id+"span").html(id1.name);
					}else{
						jQuery("#customfield"+id+"span").html("<a href="+linkurl+id1.id+">"+id1.name+"</a>");
					}
					jQuery("input[name=customfield"+id+"]").val(id1.id);
			   }else{
					if (ismand==0){
						jQuery("#customfield"+id+"span").html("");
					}else{
						jQuery("#customfield"+id+"span").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
					}
					jQuery("input[name=customfield"+id+"]").val("");
				}
			}
		}
	}
}

jQuery(document).ready(function(){
	if(jQuery("#accounttype").val() =="1"){
		jQuery("input[name=belongto]").attr("ismustinput","2")
	}
})
</script>
	</BODY>
</HTML>
