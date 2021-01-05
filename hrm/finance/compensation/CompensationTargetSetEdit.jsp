
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
boolean hasright=true;
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));
String msg1=Util.null2String(request.getParameter("msg1"));
int Targetid=Util.getIntValue(request.getParameter("id"));
//是否分权系统，如不是，则不显示框架，直接转向到列表页面
int detachable=Util.getIntValue((String)session.getAttribute("detachable"));
if(detachable==1){
    if(subcompanyid>0){
    int operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"Compensation:Setting",subcompanyid);
    if(subcompanyid!=0 && operatelevel<1){
        hasright=false;
    }
    }else{
       hasright=false;
    }
}
if(!HrmUserVarify.checkUserRight("Compensation:Setting", user) && !hasright){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
String rightlevel=HrmUserVarify.getRightLevel("Compensation:Setting", user);
String TargetName="";
String Explain="";
int AreaType=-1;
String Areaids="";
String memo="";
String Areaname="";
double  showOrder=1;
if(Targetid<=0){
	RecordSet.executeSql("select max(showOrder) as maxShowOrder from HRM_CompensationTargetSet");
	if(RecordSet.next()){
		showOrder=Util.getDoubleValue(RecordSet.getString("maxShowOrder"),0);
		showOrder++;
	}
}
if(Targetid>0){
    RecordSet.executeSql("select a.TargetName,a.Explain,a.AreaType,b.companyordeptid,a.subcompanyid,a.memo,a.showOrder from HRM_CompensationTargetSet a,HRM_ComTargetSetDetail b where a.id=b.Targetid and a.id="+Targetid);
    while(RecordSet.next()){
        TargetName=Util.null2String(RecordSet.getString("TargetName"));
        Explain=Util.null2String(RecordSet.getString("Explain"));
        AreaType=RecordSet.getInt("AreaType");
        subcompanyid = RecordSet.getInt("subcompanyid");
        String companyordeptid=RecordSet.getString("companyordeptid");
        memo=Util.null2String(RecordSet.getString("memo"));
        showOrder = Util.getDoubleValue(RecordSet.getString("showOrder"),0);  
        if(AreaType==3){
        		if(Areaids.length()>0)Areaids+=",";
            Areaids+=companyordeptid;
            Areaname+=" "+SubCompanyComInfo.getSubCompanyname(companyordeptid);
        }
        if(AreaType==4){
	       		if(Areaids.length()>0)Areaids+=",";
	          Areaids+=companyordeptid;
            Areaname+=" "+DepartmentComInfo.getDepartmentname(companyordeptid);
        }
    }
    if(Areaname.equals("")){
	    if(AreaType==3){
	      Areaname = SubCompanyComInfo.getSubcompanynames(Areaids);
		  }
		  if(AreaType==4){
		    Areaname+=" "+DepartmentComInfo.getDepartmentNames(Areaids);
		  }
    }
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);

<%if(isclose.equals("1")){%>
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();
<%}%>
</script>
</head>
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19427,user.getLanguage())+":"+SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
/*
if(Targetid>0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:ondelete(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",CompensationTargetSet.jsp?subCompanyId="+subcompanyid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
*/
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="onSave();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%if(msg1.equals("1")){%>
<font color="red"><%=SystemEnv.getHtmlLabelName(17049,user.getLanguage())%></font>
<%}%>
<FORM id=weaver name=frmMain action="CompensationTargetSetOperation.jsp" method=post >
<input type="hidden" id="option" name="option" value="add">
<input type="hidden" id="Targetid" name="Targetid" value="<%=Targetid%>">
<input type="hidden" id="Areaids" name="Areaids" value="<%=Areaids%>">
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(19427,user.getLanguage())%>'>
  	<wea:item><%=SystemEnv.getHtmlLabelName(33365,user.getLanguage())%></wea:item>
    <wea:item><input class=inputstyle type="text"  name="TargetName" maxlength="50" value='<%=Util.toScreenToEdit(TargetName,user.getLanguage())%>' onBlur="checkinput('TargetName','TargetNamespan')">
    	<span id=TargetNamespan name=TargetNamespan><%if(TargetName.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></span>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></wea:item>
    <wea:item>
    	<brow:browser viewType="0" name="subcompanyid" browserValue='<%=subcompanyid==-1?"":""+subcompanyid %>' 
	        browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowserByDec.jsp?rightStr=Compensation:Setting&selectedids="
	        hasInput="true" isSingle="true" hasBrowser="true" isMustInput='2'
	        completeUrl="/data.jsp?type=164"
	        browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(""+subcompanyid) %>'>
	    </brow:browser>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(19374,user.getLanguage())%></wea:item>
    <wea:item>
      <select name="AreaType" onchange="onChangeLevel()" id="AreaType">
          <%if(rightlevel.equals("2")){%>
          <option value="0" <%if(AreaType==0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
          <%}%>
          <option value="1" <%if(AreaType==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18919,user.getLanguage())%></option>
          <option value="2" <%if(AreaType==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19436,user.getLanguage())%></option>
          <option value="3" <%if(AreaType==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19437,user.getLanguage())%></option>
          <option value="4" <%if(AreaType==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19438,user.getLanguage())%></option>
      </select>
    </wea:item>
    <wea:item attributes="{'samePair':'subcompany','display':'none'}"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
    <wea:item attributes="{'samePair':'subcompany','display':'none'}">
			<brow:browser viewType="0" name="Areaids1" browserValue='<%=Areaids %>' 
	        browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/MutiSubCompanyByRightBrowser.jsp?rightStr=Compensation:Setting&selectedids="
	        hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
	        completeUrl="/data.jsp?type=164"
	        _callback="setAreaids"
	        browserSpanValue='<%=Areaname %>'>
	    </brow:browser>
    </wea:item>
    <wea:item attributes="{'samePair':'mutiDepartment','display':'none'}"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
    <wea:item attributes="{'samePair':'mutiDepartment','display':'none'}">
			<brow:browser viewType="0" name="Areaids2" browserValue='<%=Areaids %>' 
	     browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/MutiDepartmentByRightBrowser.jsp?rightStr=Compensation:Setting&selectedids="
	     hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
	     completeUrl="/data.jsp?type=4"
	     _callback="setAreaids"
	     browserSpanValue='<%=Areaname %>'>
	    </brow:browser>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></wea:item>
    <wea:item><input class=inputstyle type="text"  name="Explain" size=40 maxlength="100" value='<%=Util.toScreenToEdit(Explain,user.getLanguage())%>'></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></wea:item>
    <wea:item><textarea name="memo" rows="5" cols="60"><%=Util.toScreenToEdit(memo,user.getLanguage())%></textarea></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></wea:item>
    <wea:item><INPUT class=inputStyle maxLength=15 size=15
    name=showOrder value="<%=showOrder%>" onKeyPress='ItemDecimal_KeyPress("showOrder",15,2)'  onchange='checknumber("showOrder");checkDigit("showOrder",15,2);checkinput("showOrder","showOrderImage")'>
		<SPAN id=showOrderImage></SPAN>
	</wea:item>
	</wea:group>
</wea:layout>
</FORM>
 <%if("1".equals(isDialog)){ %>
 </div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
    <wea:group context="">
    	<wea:item type="toolbar">
    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
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
<script language=javascript>
function onSave() {
 var checkstr="TargetName,subcompanyid,showOrder";
 if(document.frmMain.AreaType.value>2){
     checkstr+=",Areaids";
 }
 //当应用范围为指定分部和指定部门时验证
 if(jQuery("#AreaType").val() == 3){
 	var comstr = document.frmMain.Areaids1.value;
 	if(comstr == null || comstr.length ==0){
 		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
 		return;
 	}
 }
 
 if(jQuery("#AreaType").val() == 4){
 	var comstr = document.frmMain.Areaids2.value;
 	if(comstr == null || comstr.length ==0){
 		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
 		return;
 	}
 }
 if(check_form(document.frmMain,checkstr)){
    <%if(Targetid>0){%>
    document.frmMain.option.value="edit";
    <%}%>
    document.frmMain.submit();
 }
}

function onChangeLevel(){
	thisvalue=document.frmMain.AreaType.value;
	hideEle("subcompany");
	hideEle("mutiDepartment");
	_writeBackData("Areaids1",1,{id:"",name:""},{
		hasInput:true,
		replace:true,
		isSingle:true,
		isedit:true
	});
	_writeBackData("Areaids2",1,{id:"",name:""},{
		hasInput:true,
		replace:true,
		isSingle:true,
		isedit:true
	});
	document.frmMain.Areaids.value="";
	if(thisvalue==3){
		showEle("subcompany");
  }else if(thisvalue==4){
		showEle("mutiDepartment");
  }
}
function encode(str){
    return escape(str);
}

function onShowMutiDepartment(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentByRightBrowser.jsp");
	if (data!=null) {
	    if (data.id!="") {
	    	$("#"+tdname).html(data.name.substring(1));
	    	$("#"+inputename).val(data.id);
	    }else{
	    	$("#"+tdname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	    	$("#"+inputename).val("");
	    }
	}
}

function onShowSubcompany(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubCompanyByRightBrowser.jsp");
	
	if (data!=null) {
	    if (data.id!="") {
	    	$("#"+tdname).html(data.name.substring(1));
	    	$("#"+inputename).val(data.id);
	    }else{
	    	$("#"+tdname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	    	$("#"+inputename).val("");
	    }
	}
}


/*
p（精度）
指定小数点左边和右边可以存储的十进制数字的最大个数。精度必须是从 1 到最大精度之间的值。最大精度为 38。

s（小数位数）
指定小数点右边可以存储的十进制数字的最大个数。小数位数必须是从 0 到 p 之间的值。默认小数位数是 0，因而 0 <= s <= p。最大存储大小基于精度而变化。
*/
function checkDigit(elementName,p,s){
	tmpvalue = document.all(elementName).value;

    var len = -1;
    if(elementName){
		len = tmpvalue.length;
    }

	var integerCount=0;
	var afterDotCount=0;
	var hasDot=false;

    var newIntValue="";
	var newDecValue="";
    for(i = 0; i < len; i++){
		if(tmpvalue.charAt(i) == "."){ 
			hasDot=true;
		}else{
			if(hasDot==false){
				integerCount++;
				if(integerCount<=p-s){
					newIntValue+=tmpvalue.charAt(i);
				}
			}else{
				afterDotCount++;
				if(afterDotCount<=s){
					newDecValue+=tmpvalue.charAt(i);
				}
			}
		}		
    }

    var newValue="";
	if(newDecValue==""){
		newValue=newIntValue;
	}else{
		newValue=newIntValue+"."+newDecValue;
	}
    document.all(elementName).value=newValue;
}

jQuery(document).ready(function(){
<%if(AreaType==3){%>
	showEle("subcompany");
<%}else if(AreaType==4){%>
	showEle("mutiDepartment");
<%}%>
})

function setAreaids(e,datas,name){
	jQuery("#Areaids").val(datas.id);
}
</script>
</BODY>
</HTML>
