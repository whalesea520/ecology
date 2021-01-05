
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.security.AclManager " %>
<%@ page import="weaver.docs.category.* " %>
<%@ page import="java.util.*"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="EsignatureManager" class="weaver.hrm.setting.esignature.EsignatureManager" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page" />
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page" />
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
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String step = Util.null2String(request.getParameter("step"),"3");
String id = Util.null2String(request.getParameter("id"));

EsignatureManager.resetParameter();
EsignatureManager.setId(Util.getIntValue(id));
EsignatureManager.getSignatureInfoById();
EsignatureManager.next();

String authId = Util.null2String(EsignatureManager.getAuthId(),"");

String operatelevel = Util.null2String(request.getParameter("operatelevel"));
int rolelevel = Util.getIntValue(Util.null2String(request.getParameter("rolelevel")));

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
</style>
<SCRIPT language="javascript">
var parentWin = parent.getParentWindow(window);
var dialog = parent.getDialog(window);	

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
  	if(ext!=".jpg"&&ext!=".bmp"&&ext!=".gif"){
  		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(127875,user.getLanguage())%>")
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

function step2(){
	window.location = "SignatureAdd02.jsp?step=2&id=<%=id%>";
}

function step4(){

	jQuery.ajax({
		url : "testAddress.jsp",
		type : "post",
		data:{method:'step4',id:'<%=id%>',authId:'<%=authId%>'},
		datatype : "json",
		success : function(datas) {
			//if(jQuery.trim(datas) == "0"){
				parentWin.onRefrush();
				window.location = "SignatureAdd04.jsp?step=4";
			//}
		}
	});
}

</script>
</head>
<BODY style="width: 100%;height:650px;overflow:hidden;">
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
	<div style="width: 100%;height: 80px;margin-top: 40px;margin-left: 50px;">
		<jsp:include page="flowchart.jsp">
			<jsp:param value="<%=step %>" name="step"/>
		</jsp:include>
	</div>
	<%
			subcompanyid = ""+EsignatureManager.getSubcompanyid();
	 %>
	<div style="width: 100%;">
		<wea:layout type="2col" needLogin="false" attributes="{'expandAllGroup':'true'}">
			<wea:group context="<%=SystemEnv.getHtmlLabelName(130986, languageid)%>" attributes="{'groupOperDisplay':'none'}">
				<wea:item><%=SystemEnv.getHtmlLabelName(17868, languageid)%></wea:item>
				<wea:item>
				<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(subcompanyid),user.getLanguage())%>
				</wea:item>
				
				<wea:item><%=SystemEnv.getHtmlLabelName(18415, languageid)%></wea:item>
				<wea:item>
					<%=EsignatureManager.getEnterpriseName()%>
				</wea:item>
				
				<wea:item><%=SystemEnv.getHtmlLabelName(27323, languageid)%></wea:item>
				<wea:item>
					<%=EsignatureManager.getRegistrationNumber()%>
				</wea:item>
				
				<wea:item><%=SystemEnv.getHtmlLabelNames("643,125163,18416", languageid)%></wea:item>
				<wea:item>
					<%=ProvinceComInfo.getProvincename(""+EsignatureManager.getProvincce()) %>
					&nbsp;&nbsp;&nbsp;
					<%=CityComInfo.getCityname(""+EsignatureManager.getCity()) %>
										
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(25627, languageid)%></wea:item>
				<wea:item>
					<%
						String businessLicenseName = "";
						RecordSet.executeSql("select  * from ImageFile where imagefileid="+EsignatureManager.getBusinessLicenseName());
						if(RecordSet.next()){
							businessLicenseName = RecordSet.getString("imagefilename");
						}
					 %>
					 <%=businessLicenseName %>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(130987, languageid)%></wea:item>
				<wea:item>
					<%
						String attorneyFileName = "";
						RecordSet.executeSql("select  * from ImageFile where imagefileid="+EsignatureManager.getAttorneyFileName());
						if(RecordSet.next()){
							attorneyFileName = RecordSet.getString("imagefilename");
						}
					 %>
					 <%=attorneyFileName %>
				</wea:item>
			</wea:group>
			<wea:group context="<%=SystemEnv.getHtmlLabelName(130986, languageid)%>" attributes="{'groupOperDisplay':'none'}">
			
				<wea:item><%=SystemEnv.getHtmlLabelName(130988, languageid)%></wea:item>
				<wea:item>
					<%=EsignatureManager.getLegalPerson()%>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(130989, languageid)%></wea:item>
				<wea:item>
					<%
					String IdentificationTypeName = "";
					if(0 == EsignatureManager.getIdentificationType()){
						IdentificationTypeName = SystemEnv.getHtmlLabelName(23792, languageid);
					}else if(1 == EsignatureManager.getIdentificationType()){
						IdentificationTypeName = SystemEnv.getHtmlLabelName(131056, languageid);
					}else if(2 == EsignatureManager.getIdentificationType()){
						IdentificationTypeName = SystemEnv.getHtmlLabelName(131057, languageid);
					}
					 %>
						<%=IdentificationTypeName%>
					<%=EsignatureManager.getIdentificationNumber()%>
				</wea:item>
			</wea:group>
			
			<wea:group context='<%=SystemEnv.getHtmlLabelNames("572,87", languageid)%>' attributes="{'groupOperDisplay':'none'}">
				<wea:item><%=SystemEnv.getHtmlLabelName(572, languageid)%></wea:item>
				<wea:item>
					<%=EsignatureManager.getContact()%>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelNames("572,421", languageid)%></wea:item>
				<wea:item>
					<%=EsignatureManager.getContactPhone()%>
				</wea:item>
			</wea:group>
		</wea:layout>
		<div style="margin-left: 320px;margin-top: 15px;">
	   		<input class="e8_btn_top" type="button" id="btnSave" onclick="step2();" 
	   	   		style="width: 60px;height: 25px;background-color: #30b5ff;color: #FFF;" 
	   			value="<%=SystemEnv.getHtmlLabelName(1876,user.getLanguage())%>"/>
	   		<input class="e8_btn_top" type="button" id="btnSave" onclick="step4();" 
	   	   		style="width: 60px;height: 25px;background-color: #30b5ff;color: #FFF;" 
	   			value="<%=SystemEnv.getHtmlLabelName(1402,user.getLanguage())%>"/>
		</div>
	</div>	
</form>
<%
 %>
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
