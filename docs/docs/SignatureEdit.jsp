
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.security.AclManager " %>
<%@ page import="weaver.docs.category.* " %>
<%@ page import="java.util.*"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="SignatureManager" class="weaver.docs.docs.SignatureManager" scope="page" />
<jsp:useBean id="KnowledgeTransMethod" class="weaver.general.KnowledgeTransMethod" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("SignatureEdit:Edit", user)){
    response.sendRedirect("/notice/noright.jsp");
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "<b>"+SystemEnv.getHtmlLabelName(131267111,user.getLanguage())+"</b>";
String needfav = "1";
String needhelp = "1";
int markId = Util.getIntValue(request.getParameter("markId"), 0) ;
SignatureManager.setMarkId(markId);
SignatureManager.getSignatureInfoById();
SignatureManager.next();
int hrmresid = SignatureManager.getHrmresId();
String markName = SignatureManager.getMarkName();
int sealType = SignatureManager.getSealType();
//用于判断是否默认签章
String isDefault = SignatureManager.getIsDefault();
String isDialog = Util.null2String(request.getParameter("isdialog"));
String isclose = Util.null2String(request.getParameter("isclose"));

String operatelevel = Util.null2String(request.getParameter("operatelevel"));
int rolelevel = Util.getIntValue(Util.null2String(request.getParameter("rolelevel")));
String departmentid = "",subcompanyid = "",sqlWhere = "";
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
			int[] companyids = CheckSubCompanyRight.getSubComByUserRightId(user.getUID(),"SignatureAdd:Add");
			for(int i=0;companyids!=null&&i<companyids.length;i++){
				tmpoperatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"SignatureAdd:Add",companyids[i]);
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
<SCRIPT language="javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
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
    if(ext!=".jpg"&&ext!=".bmp"&&ext!=".gif"&&ext!=".png"){
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82744,user.getLanguage())%>.jpg,.bmp,.gif,.png")
	    return false;
  	}
	}
    if(check_form(document.weaver,"markName,hrmresid,subcompanyid")){
        weaver.opera.value="edit";
        weaver.submit();
    }
}

function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
    weaver.opera.value="delete";
    weaver.submit();
	}
}

//更改必填的显示提示
function changeMandantry(objId){
	var obj = document.getElementById(objId);
	var objSpan = document.getElementById(objId + "Span");
	if(obj && objSpan){
		if(obj.value == ""){
			objSpan.style.display = "";
		}else{
			objSpan.style.display = "none";
		}
	}
}

function changeMarkImg(obj){
	var imgObj = document.getElementById("markImg");
	if(obj.value != ""){
	  alert(obj.value)
		imgObj.src = obj.value;
		imgObj.style.display = "";
	}else{
		imgObj.src = "";
		imgObj.style.display = "none";
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
function jsonerror(){
	jQuery("#markImg").hide();
}
</script>



</head>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

if(Util.getIntValue(operatelevel) > 0 && HrmUserVarify.checkUserRight("SignatureAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(Util.getIntValue(operatelevel) > 1 && HrmUserVarify.checkUserRight("SignatureEdit:Delete", user)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}

//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:location='/docs/docs/SignatureList.jsp',_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
		<%
if(Util.getIntValue(operatelevel) > 0 && HrmUserVarify.checkUserRight("SignatureAdd:Add", user)){
		 %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="onSave();">
			<%
}
			 %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=weaver method=post enctype="multipart/form-data" action="UploadSignature.jsp">
<INPUT TYPE="hidden" name = "opera">
<INPUT TYPE="hidden" name = "markId" value="<%=markId%>">
<input type="hidden" name="isdialog" value="<%=isDialog%>">
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(24893,user.getLanguage())%>'>
    <wea:item><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></wea:item>
    <wea:item>
    <%
    if(Util.getIntValue(operatelevel) > 0){
    	//String completeUrl = "/data.jsp?sqlwhere="+xssUtil.put(sqlWhere);
		String sqlWhere1 = sqlWhere.replace("hr.", "t1.");
    	String completeUrl = "/data.jsp?sqlwhere="+xssUtil.put(sqlWhere1);
    	String browserUrlStr = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?sqlwhere="+xssUtil.put(sqlWhere)+"&rightStr=SignatureEdit:Edit&operatelevel="+operatelevel+"&rolelevel="+rolelevel;
     %>
    	<brow:browser viewType="0"  name="hrmresid" browserValue='<%=hrmresid+"" %>' 
      browserUrl="<%=browserUrlStr %>"
      hasInput="true" isSingle="true" hasBrowser="true" isMustInput='2'
      completeUrl="<%=completeUrl %>" linkUrl="javascript:openhrm($id$)" width="150px" browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(""+hrmresid),user.getLanguage())%>' >
      </brow:browser>
      <%
      }else{
      %>
      <span><%=Util.toScreen(ResourceComInfo.getResourcename(""+hrmresid),user.getLanguage())%></span>
      <%
      }
       %>
		</wea:item>
    <!-- 签章名称 -->
    <wea:item><%=SystemEnv.getHtmlLabelName(18694,user.getLanguage())%></wea:item>
        <%if(Util.getIntValue(operatelevel) > 0){ %>
    <wea:item>

        <input type="text" class=InputStyle id ="markName" name="markName" value='<%=markName%>' onchange="changeMandantry(this.id);">
        <span id="markNameSpan" style="display:none">
            <img align=absMiddle src="/images/BacoError_wev8.gif">
        </span>
    </wea:item>
    <!-- 签章类型 -->
    <wea:item><%=SystemEnv.getHtmlLabelName(127436,user.getLanguage())%></wea:item>
    <wea:item>
        <select name="sealType" txt='<%=sealType%>' onchange="toggleIsDefault(this.value)">
            <option value="1" <%=(1==sealType) ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(127439,user.getLanguage())%></option>
            <option value="2" <%=(2==sealType) ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(127438,user.getLanguage())%></option>
        </select>
    </wea:item>
    <!-- 是否默认签章 -->
    <wea:item><%=SystemEnv.getHtmlLabelName(131265,user.getLanguage())%></wea:item>
    <wea:item>
        <input class=inputstyle tzCheckbox="true" type="checkbox" name="isDefault" value="1" <% if("1".equals(isDefault)){ %> checked <%} %>/>
    </wea:item>
    	<%}else{
    	%>
    <wea:item>
      	<span><%=markName%></span>
    </wea:item>
    <!-- 签章类型 -->
    <wea:item><%=SystemEnv.getHtmlLabelName(127436,user.getLanguage())%></wea:item>
    <wea:item>
        <%=KnowledgeTransMethod.getSealType(sealType + "",user.getLanguage() + "") %>
    </wea:item>
    <!-- 是否默认签章 -->
    <wea:item><%=SystemEnv.getHtmlLabelName(131265,user.getLanguage())%></wea:item>
    <wea:item>
        <%=KnowledgeTransMethod.isPersonalDefault(isDefault,user.getLanguage() + "+" + sealType) %>
    </wea:item>
    	<%
    	} %>
    <!-- 签章图片 -->
    <wea:item><%=SystemEnv.getHtmlLabelName(18695,user.getLanguage())%></wea:item>
    <wea:item>
    
    	<%if(Util.getIntValue(operatelevel) > 0){ %>
        <div align="left" style="float:left;width:300px;"><INPUT TYPE="file" id="markPic" NAME="markPic" style="width:100%;" class=InputStyle accept="image/gif,image/jpeg,image/png"></div>
        <div align="right" style="margin-right:10px;"><%=SystemEnv.getHtmlLabelName(131307,user.getLanguage()) %></div>
    	<%
    	} %>
    </wea:item>
    <wea:item attributes="{'colspan':'full'}">
    <img id="markImg" src="/weaver/weaver.file.SignatureDownLoad?markId=<%=markId%>" style="display: <%=markId==0?"none":"" %>;max-width:600px;" onerror="jsonerror()" ></img>
    </wea:item>
	</wea:group>
</wea:layout>
</form>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<table width="100%">
	    <tr><td style="text-align:center;" colspan="3">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
	    </td></tr>
	</table>
</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
            toggleIsDefault(jQuery("select[name='sealType']").val());
		});
        function toggleIsDefault(val){
            if(val == 2 ){
                jQuery("input[name='isDefault']").parent().parent().hide();
            }else{
                jQuery("input[name='isDefault']").parent().parent().show();
            }
        }
	</script>
<%}else{ %>
    <script type="text/javascript">
        jQuery(document).ready(function(){
            toggleIsDefault(jQuery("select[name='sealType']").val());
        });
        function toggleIsDefault(val){
		    if(val == 2 ){
		        jQuery("input[name='isDefault']").parent().parent().hide();
		    }else{
		        jQuery("input[name='isDefault']").parent().parent().show();
		    }
		}
    </script>
<%} %>
</body>
