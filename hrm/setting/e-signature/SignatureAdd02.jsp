
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.security.AclManager " %>
<%@ page import="weaver.docs.category.* " %>
<%@ page import="java.util.*"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="EsignatureManager" class="weaver.hrm.setting.esignature.EsignatureManager" scope="page" />
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page" />
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page" />

<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
if(!HrmUserVarify.checkUserRight("Electronic-signature:Maintenance", user)){
    response.sendRedirect("/notice/noright.jsp");
}
int languageid = user.getLanguage();
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "<b>"+SystemEnv.getHtmlLabelName(16627,user.getLanguage())+"</b>";
String needfav = "1";
String needhelp = "1";
String result = Util.null2String(request.getParameter("result"));

String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String step = Util.null2String(request.getParameter("step"),"2");
String id = Util.null2String(request.getParameter("id"));

String operatelevel = Util.null2String(request.getParameter("operatelevel"));
int rolelevel = Util.getIntValue(Util.null2String(request.getParameter("rolelevel")));
String isError = Util.null2String(request.getParameter("isError"));

String departmentid = "",subcompanyid = "",sqlWhere = "";
subcompanyid= Util.null2String(request.getParameter("subcompanyid"),"0");

ArrayList<String> childList = new ArrayList<String>();

String hrmdetachable="0";
boolean isUseHrmManageDetach=ManageDetachComInfo.isUseHrmManageDetach();
if(isUseHrmManageDetach){
   hrmdetachable="1";
   session.setAttribute("detachable","1");
   session.setAttribute("hrmdetachable",hrmdetachable);
}else{
   hrmdetachable="0";
   session.setAttribute("detachable","0");
   session.setAttribute("hrmdetachable",hrmdetachable);
}

if(user.getUID() != 1){
	if("1".equals(hrmdetachable)){
			String companyid = "";
			int tmpoperatelevel = 0;
			int[] companyids = CheckSubCompanyRight.getSubComByUserRightId(user.getUID(),"Electronic-signature:Maintenance");
			for(int i=0;companyids!=null&&i<companyids.length;i++){
				tmpoperatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"Electronic-signature:Maintenance",companyids[i]);
				if(tmpoperatelevel > -1){
					companyid += ","+companyids[i];
				}
			}
			if(companyid.length() > 0){
				companyid = companyid.substring(1);	
			 	sqlWhere = "( hr.subcompanyid1 in("+companyid+"))";
			}else{
				sqlWhere = "( hr.subcompanyid1 in(0)";//分权而且没有选择机构权限
			}
	}else{
		
			if(rolelevel == 0){//部门
				departmentid = user.getUserDepartment()+"";
			 	sqlWhere = "( departmentid in("+departmentid+"))";
			}else if(rolelevel == 1){//分部
		       	subcompanyid = user.getUserSubCompany1()+"";
			 	sqlWhere = "( hr.subcompanyid1 in("+subcompanyid+"))";
		    }
	}
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
  <!-- 引入ystep插件 -->
<script src="js/ystep.js"></script>
    <!-- 引入ystep样式 -->
<link rel="stylesheet" href="css/ystep.css">
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<style type="text/css">
.introClazz{
	width: 100%;
	float: left;
	font-family:'微软雅黑 Regular', '微软雅黑';
	font-weight: 400;
	font-style: normal; 
	text-align:left;
}
.Title{
	font-size: 16px;
}
.content{
	font-size: 12px;
}
.nextstep{
	margin-left: 220px;
}
.contract{
	color: #0099FF;
	margin-top: 10px;
	margin-left: 270px;
}
.inputFile{
 	border-width: 1px;
    border-style: solid;
    border-color: rgba(228, 228, 228, 1);
    border-radius: 0px;
    -moz-box-shadow: none;
    -webkit-box-shadow: none;
    box-shadow: none;
}
.procityClass{
	width: 120px;
	border: 1px solid rgba(224, 224, 224, 1);
	border-radius: 2px;
}
.u1169{
	position:absolute;
	left:219px;
	top:0px;
}
.u1170{
	position:absolute;
	left:48px;
	top:14px;
}
.u1171{
	position:absolute;
	left:245px;
	top:15px;
}
.u1172{
	position:absolute;
	left:6px;
	top:0px;
	transform-origin:6px 7px 0px;
}
</style>
<SCRIPT language="javascript">
var parentWin = parent.getParentWindow(parent);
var dialog = parent.getDialog(parent);
var isError = "<%=isError%>";


if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}

function showHeader(){
	if(oDiv.style.display=='')
		oDiv.style.display='none';
	else
		oDiv.style.display='';
}


function onshowdocmain(vartmp){
	if(vartmp==1)
		otrtmp.style.display='';
	else
		otrtmp.style.display='none';
}

function onSave(){
	var val=document.getElementById("markPic").value;
	if(val!=""){
  	var ext = val.substr(val.indexOf(".")).toLowerCase();
  	if(ext!=".jpg"&&ext!=".jpeg"&&ext!=".PNG"&&ext!=".gif"){
  		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(131251,user.getLanguage())%>")
	    return false;
  	}
	}
    
    if(check_form(document.weaver,"markName,hrmresid")){
        weaver.opera.value="add";
        weaver.submit();
    }
}
function onShowResource(inputname,spanname){
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
	 linkurl="javaScript:openhrm(";
   datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp","","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
  if (datas) {
		    if (datas.id!= "") {
		        ids = datas.id.split(",");
			    names =datas.name.split(",");
			    sHtml = "";
			    for( var i=0;i<ids.length;i++){
				    if(ids[i]!=""){
				    	sHtml = sHtml+"<a href="+linkurl+ids[i]+")  onclick='pointerXY(event);'>"+names[i]+"</a>&nbsp";
				    }
			    }
			    $("#"+spanname).html(sHtml);
			    $("input[name="+inputname+"]").val(datas.id);
		    }
		    else	{
	    	     $("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			    $("input[name="+inputname+"]").val("");
		    }
		}
}
function cancel(){
	var dialog = parent.getDialog(window);	
	dialog.close();
}
function changeMarkImg(obj){
	var imgObj = document.getElementById("markPic");
	if(obj.value != ""){
		imgObj.src = obj.value;
		imgObj.style.display = "";
	}else{
		imgObj.src = "";
		imgObj.style.display = "none";
	}
}

function step1(){
	window.location = "SignatureAdd01.jsp?step=1&subcompanyid=<%=subcompanyid%>";
}

function step3(){
	var checks = "subcompanyid,enterpriseName,registrationNumber,businessLicense,attorneyFile,legalPerson,identificationNumber";
	if(jQuery("#id") && jQuery("#id").val() && jQuery.trim((jQuery("#id").val())) != "" ){
		checks = "subcompanyid,enterpriseName,registrationNumber,legalPerson,identificationNumber";
	}else{
		var val=jQuery("#businessLicense").val();
		if(val!=""){
		  	var ext = val.substr(val.indexOf(".")).toUpperCase();
		  	if(ext!=".JPG"&&ext!=".JPEG"&&ext!=".GIF"&&ext!=".PNG"&&ext!=".PDF"){
		  		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(127875,user.getLanguage())%>")
			    return false;
		  	}
		}
	}
    if(check_form(document.weaver,checks)){
    	if(jQuery("#id") && jQuery("#id").val() && jQuery.trim((jQuery("#id").val())) != "" ){
			weaver.opera.value="edit";
    	}else{
	        weaver.opera.value="saveInfo";
    	}
        weaver.submit();
    }	
}

function getCitys(){
	jQuery.ajax({
		url : "testAddress.jsp",
		type : "post",
		data:{method:'getCitys',province:jQuery("#province").val()},
		datatype : "json",
		success : function(datas) {
			console.log(datas);
			var ajaxobj=eval("("+jQuery.trim(datas)+")");  
        	var str="<option value=''><%=SystemEnv.getHtmlLabelName(18214, languageid)%></option>";  
			for (var i = 0; i < ajaxobj.length; i++) {
				var dataitem = ajaxobj[i];
                str=str+"<option value='"+dataitem.id+"'>"+dataitem.cityname+"</option>";   
			}
		 	jQuery("#city").html(str);  
		}
	
	});
}

function hideError(){
		jQuery("#errorMsg").hide();
}

jQuery(document).ready(function(){
	if(isError == "1"){
		jQuery("#errorMsg").show();
		setTimeout(hideError,1000);
	}
});

</script>
</head>
<BODY style="width: 100%;height:650px;overflow:hidden;">
		<div id="errorMsg" style="position:absolute;left:0px;top:0px;display: none;">
			<div class="u1169"  >
				<img src="u1169.png" />
				<div class="u1170">
                  <p><span><%=SystemEnv.getHtmlLabelName(131249,user.getLanguage()) %>
                  </span></p>
                </div>
			</div>
			<div class="u1171">
				<img src="u1171.png" />
				<div class="u1172">
					<p><span style="font-size:14px;color:#FFFFFF;">i</span></p>
				</div>
			</div>
		</div>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(Util.getIntValue(operatelevel) > 0 && HrmUserVarify.checkUserRight("Electronic-signature:Maintenance", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
}

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver name=weaver method=post enctype="multipart/form-data" action="UploadSignature.jsp">
	<INPUT TYPE="hidden" name = "opera">
	<INPUT TYPE="hidden" id="id" name = "id" value="<%=id %>">
	<div style="width: 100%;height: 80px;margin-top: 40px;margin-left: 50px;">
		<jsp:include page="flowchart.jsp">
			<jsp:param value="<%=step %>" name="step"/>
		</jsp:include>
	</div>
	<%
	if(!"".equals(result)){
	%>
	<div>
	<p>
		<span style="color: red;">
		<%=SystemEnv.getHtmlLabelName(131250,user.getLanguage()) %>
		
		</span>
	</p>
	</div>
<%	}
	 %>
	
	
	<%
		EsignatureManager.resetParameter();
		EsignatureManager.setId(Util.getIntValue(id));
		EsignatureManager.getSignatureInfoById();
		String subName = "",enterpriseName="",registrationNumber="",businessLicenseName = "",attorneyFileName = "",legalPerson="",identificationType="",identificationNumber="";
		String contact = "",contactPhone="",province="",city="",businessLicense="",attorneyFile="";
		if(EsignatureManager.next()){
			subcompanyid = ""+EsignatureManager.getSubcompanyid();
			enterpriseName = EsignatureManager.getEnterpriseName();
			registrationNumber = EsignatureManager.getRegistrationNumber();
			businessLicense = EsignatureManager.getBusinessLicenseName();
			RecordSet.executeSql("select  * from ImageFile where imagefileid="+businessLicense);
			if(RecordSet.next()){
				businessLicenseName = RecordSet.getString("imagefilename");
			}
			attorneyFile = EsignatureManager.getAttorneyFileName();
			RecordSet.executeSql("select  * from ImageFile where imagefileid="+attorneyFile);
			if(RecordSet.next()){
				attorneyFileName = RecordSet.getString("imagefilename");
			}
			legalPerson = EsignatureManager.getLegalPerson();
			identificationType = ""+EsignatureManager.getIdentificationType();
			identificationNumber = EsignatureManager.getIdentificationNumber();
			province = ""+EsignatureManager.getProvincce();
			city = ""+EsignatureManager.getCity();
			contact = EsignatureManager.getContact();
			contactPhone = EsignatureManager.getContactPhone();
		}
		%>
	<div style="width: 100%;height: 300px;">
		<wea:layout type="2col" needLogin="false" attributes="{'expandAllGroup':'true'}">
			<wea:group context="<%=SystemEnv.getHtmlLabelName(130986, languageid)%>" attributes="{'groupOperDisplay':'none'}">
				<wea:item><%=SystemEnv.getHtmlLabelName(17868, languageid)%></wea:item>
				<wea:item>
			    	<brow:browser viewType="0"  name="subcompanyid" browserValue='<%=subcompanyid %>' 
			            browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowserByDec.jsp?rightStr=Electronic-signature:Maintenance"
			            hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
			            completeUrl="/data.jsp?type=164" width="200px" 
			            browserSpanValue='<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(subcompanyid),user.getLanguage())%>'>
			      </brow:browser>
				</wea:item>
				
				<wea:item><%=SystemEnv.getHtmlLabelName(18415, languageid)%></wea:item>
				<wea:item>
				    <INPUT TYPE="text" class=InputStyle NAME="enterpriseName" value="<%=enterpriseName %>" onChange='checkinput("enterpriseName","enterpriseNamespan")' style="width: 170px;" />
				    <span id=enterpriseNamespan><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>
				</wea:item>
				
				<wea:item><%=SystemEnv.getHtmlLabelName(27323, languageid)%></wea:item>
				<wea:item>
				    <INPUT TYPE="text" class=InputStyle NAME="registrationNumber" onChange='checkinput("registrationNumber","registrationNumberspan")' style="width: 170px;" value="<%=registrationNumber %>" >
				    <span id=registrationNumberspan><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>
				</wea:item>
				
				<wea:item><%=SystemEnv.getHtmlLabelNames("643,125163,18416", languageid)%></wea:item>
				<wea:item>
						<select id="province" name="province" onchange="getCitys();" notBeauty="true" class="procityClass" >
							<option value=""><%=SystemEnv.getHtmlLabelName(18214, languageid)%></option>
							<%
								while(ProvinceComInfo.next()){%>
						<option value="<%=ProvinceComInfo.getProvinceid() %>" <%=ProvinceComInfo.getProvinceid().equals(province)?"selected":"" %> ><%=ProvinceComInfo.getProvincename()%></option>
	<%							}
							 %>
						</select>
						<select id="city" name="city" notBeauty="true" style="margin-left: 20px;" class="procityClass" >
							<%
if(!"".equals(province)){

String getCitys = "select* from HrmCity where provinceid = "+province;
rs.executeSql(getCitys);
while(rs.next()){
String cid = rs.getString("id");
%>
							<option value="<%=cid %>" <%=cid.equals(city)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(18214, languageid)%></option>
								<%							
								}
}else{%>
							<option value=""><%=SystemEnv.getHtmlLabelName(18214, languageid)%></option>

<%}							
							 %>
						</select>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(25627, languageid)%></wea:item>
				<wea:item>
					<%
					if(!"".equals(businessLicenseName)){%>
					<a style="cursor:hand" href="/weaver/weaver.file.FileDownload?fileid=<%=businessLicense%>&download=1" >
					<%=businessLicenseName %>
					</a>
					<INPUT TYPE="hidden" id="businessLicenseHidden" name = "businessLicenseHidden" value="<%=businessLicense %>">
					<%}
					 %>
					<input type="file" name="businessLicense" id="businessLicense" class="inputFile" />
					<span><%=SystemEnv.getHtmlLabelName(130994, languageid)%></span>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(130987, languageid)%></wea:item>
				<wea:item>
					<%
					if(!"".equals(attorneyFileName)){%>
					<a style="cursor:hand" href="/weaver/weaver.file.FileDownload?fileid=<%=attorneyFile%>&download=1" >
					<%=attorneyFileName %>
					</a>
					<INPUT TYPE="hidden" id="attorneyFileHidden" name = "attorneyFileHidden" value="<%=attorneyFile %>">
					<%}
					 %>
					<input type="file" name="attorneyFile" id="attorneyFile" class="inputFile" />
					<button><%=SystemEnv.getHtmlLabelName(28576, languageid)%></button>
					<span><%=SystemEnv.getHtmlLabelName(130994, languageid)%></span>
				</wea:item>
			</wea:group>
			<wea:group context='<%=SystemEnv.getHtmlLabelNames("23797,87", languageid)%>' attributes="{'groupOperDisplay':'none'}">
			
				<wea:item><%=SystemEnv.getHtmlLabelName(130988, languageid)%></wea:item>
				<wea:item>
				    <INPUT TYPE="text" class=InputStyle NAME="legalPerson" onChange='checkinput("legalPerson","legalPersonspan")' style="width: 170px;" value="<%=legalPerson %>" >
				    <span id=legalPersonspan><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(130989, languageid)%></wea:item>
				<wea:item>
					<select id="identificationType" name="identificationType" > 
						<option value="0" <%="0".equals(identificationType)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(23792, languageid)%></option>
						<option value="1" <%="1".equals(identificationType)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(131056, languageid)%></option>
						<option value="2" <%="2".equals(identificationType)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(131057, languageid)%></option>
					</select>
				    <INPUT TYPE="text" class=InputStyle NAME="identificationNumber" onChange='checkinput("identificationNumber","identificationNumberspan")' style="width: 170px;" value="<%=identificationNumber %>" >
				    <span id=identificationNumberspan><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>
				</wea:item>
			</wea:group>
			
			<wea:group context='<%=SystemEnv.getHtmlLabelNames("572,87", languageid)%>' attributes="{'groupOperDisplay':'none'}">
				<wea:item><%=SystemEnv.getHtmlLabelName(572, languageid)%></wea:item>
				<wea:item>
				    <INPUT TYPE="text" class=InputStyle NAME="contact" onChange='checkinput("contact","contactspan")' style="width: 170px;" value="<%=contact %>" >
				    <span id=contactspan><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelNames("572,421", languageid)%></wea:item>
				<wea:item>
				    <INPUT TYPE="text" class=InputStyle NAME="contactPhone" onChange='checkinput("contactPhone","contactPhonespan")' style="width: 170px;" value="<%=contactPhone %>" >
				    <span id=contactPhonespan><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>
				</wea:item>
			</wea:group>
		</wea:layout>
		<div style="margin-left: 320px;margin-top: 15px;">
	   		<input class="e8_btn_top" type="button" id="btnSave" onclick="step1();" 
	   	   		style="width: 60px;height: 25px;background-color: #30b5ff;color: #FFF;" 
	   			value="<%=SystemEnv.getHtmlLabelName(1876,user.getLanguage())%>"/>
	   		<input class="e8_btn_top" type="button" id="btnSave" onclick="step3();" 
	   	   		style="width: 60px;height: 25px;background-color: #30b5ff;color: #FFF;" 
	   			value="<%=SystemEnv.getHtmlLabelName(1402,user.getLanguage())%>"/>
		</div>
	</div>	
</form>

	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="cancel();">
				</wea:item>
				</wea:group>
				</wea:layout>
</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>

</body>
