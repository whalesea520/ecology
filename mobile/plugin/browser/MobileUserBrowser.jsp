
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.mobile.webservices.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.systeminfo.setting.*" %>
<%@ include file="MobileInit.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<LINK href="/mobile/plugin/browser/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type='text/javascript' src='/js/jquery/jquery_wev8.js'></script>
<script type='text/javascript' src='/mobile/plugin/browser/js/browserUtil_wev8.js'></script>
</head>

<script type="text/javascript">

	function doClear() {
	 	document.getElementById("seclevel").value = "0";
	 	document.getElementById("rolelevel").value = "0";
	 	document.getElementById("relatedshareid").value = "";
	 	document.getElementById("showrelatedsharename").innerHTML = "";
	}

	function onChangeSharetype(){
		var thisvalue=document.getElementById("sharetype").value;
		document.getElementById("relatedshareid").value="";
		document.getElementById("showseclevel").style.display='';
		document.getElementById("showsecleveltr").style.display='';
		if(thisvalue==0){
			document.getElementById("showresource").style.display='';
			document.getElementById("showseclevel").style.display='none';
			document.getElementById("showsecleveltr").style.display='none';
		} else {
			document.getElementById("showresource").style.display='none';
		}
		if(thisvalue==1){
	 		document.getElementById("showsubcompany").style.display='';
		} else {
			document.getElementById("showsubcompany").style.display='none';
		}
		if(thisvalue==2){
		 	document.getElementById("showdepartment").style.display='';
		} else {
			document.getElementById("showdepartment").style.display='none';
		}
		if(thisvalue==3){
		 	document.getElementById("showrole").style.display='';
			document.getElementById("showrolelevel").style.display='';
			document.getElementById("showroleleveltr").style.display='';
		    document.getElementById("rolelevel").style.display='';
		} else {
			document.getElementById("showrole").style.display='none';
			document.getElementById("showrolelevel").style.display='none';
			document.getElementById("showroleleveltr").style.display='none';
		    document.getElementById("rolelevel").style.display='none';
	    }
		
		doClear();
	}

	function onShowResource(input,span) {
		var result = window.showModalDialog("/mobile/plugin/browser/MutiResourceBrowser.jsp?browserType=resourceMulti&resourceids="+document.getElementById(input).value);
		
		if (result != null) {
			if (result.id!= ""&&result.name!= "") {
				
				document.getElementById(input).value=result.id;
				document.getElementById(span).innerHTML=result.name;
				
			}else {			
				document.getElementById(input).value="";
				document.getElementById(span).innerHTML="";
			}
		}
		
		
	}

	function onShowSubcompany(input,span) {
	    //组织架构树页面  page=HrmOrgTreeBrowser
		var result = window.showModalDialog("/mobile/plugin/browser/HrmOrgTreeBrowser.jsp?browserType=subcompanyMuti&selectedids="+document.getElementById(input).value);
		if (result != null) {
			if (result.id!= ""&&result.name!= "") {
				
				document.getElementById(input).value=result.id;
				document.getElementById(span).innerHTML=result.name;
			}else {			
				document.getElementById(input).value="";
				document.getElementById(span).innerHTML="";
			}
		}
		
	}

	function onShowDepartment(input,span) {
	    //组织架构树页面  page=HrmOrgTreeBrowser
	    var result = window.showModalDialog("/mobile/plugin/browser/HrmOrgTreeBrowser.jsp?browserType=departmentMulti&selectedids="+document.getElementById(input).value);
	    if (result != null) {
			if (result.id!= ""&&result.name!= "") {
				
			  document.getElementById(input).value=result.id;
			  document.getElementById(span).innerHTML=result.name;
			
			}else {			
			  document.getElementById(input).value="";
			  document.getElementById(span).innerHTML="";
			}
		}
	}

	function onShowRole(input,span) {
	    var result = window.showModalDialog("/mobile/plugin/browser/HrmRolesBrowser.jsp");
	    
		if (result != null) {
			if (result.id!= ""&&result.name!= "") {
				document.getElementById(input).value=result.id.split(",");
				document.getElementById(span).innerHTML=result.name.split(",");
			}else {			
				document.getElementById(input).value=""; 
				document.getElementById(span).innerHTML="";
		   }
		}
	}
	
	function dosave(){
	   var sharetype=jQuery("#sharetype").val();
	   var shareTypeName=jQuery("#sharetype").find("option:selected").text();
	   var relatedshareid=jQuery("#relatedshareid").val();
	   var shareName=jQuery("#showrelatedsharename").html();
	   var seclevel=jQuery("#seclevel").val();
	   var rolelevel=jQuery("#rolelevel").val();
	   var conditionStr=""
	   if(sharetype<4){
	   	  if(relatedshareid==""){
	   	  	 alert("请选择共享内容");
	   	  	 return ;
	   	  }	 
	      var shareValues=relatedshareid.split(",");
	      var shareValueNames=shareName.split(",");
	      for(var i=0;i<shareValues.length;i++){
	          var shareValue=shareValues[i];
	          var shareValueName=shareValueNames[i];
	          if(sharetype==3)
	             shareValue=shareValue+rolelevel;
	          conditionStr=conditionStr+",{authType:\'"+sharetype+"\',authTypeName:\'"+shareTypeName+"\',authValue:\'"+shareValue+"\',authValueName:\'"+shareValueName+"\',authSeclevel:\'"+seclevel+"\'}"
	      }
	      if(conditionStr.length>0)
	          conditionStr=conditionStr.substr(1);
	   }else
	      conditionStr=conditionStr+"{authType:\'"+sharetype+"\',authTypeName:\'"+shareTypeName+"\',authValue:\'"+relatedshareid+"\',authValueName:\'"+shareName+"\',authSeclevel:\'"+seclevel+"\'}"
	   conditionStr="["+conditionStr+"]"
	   window.returnValue=conditionStr;
	   window.close();
	   
	}
	
	function checkinput(obj){
		var seclevel=obj.value;
		if(!(seclevel==parseInt(seclevel)&&seclevel>=0)){
			alert("安全级别请输入正整数！");
			obj.value="0";
		}
	}
</script>

<body style="overflow-y:hidden;padding: 0px;margin: 0px;">
  <div style="height:455px;overflow: auto;">
           <TABLE class=ViewForm  style="width: 100%">
              <COLGROUP>
              <COL width="30%">
              <COL width="70%">
              <TBODY>            
                  <TR>
                      <TD>共享类型</TD>
                      <TD class="Field">
                          <SELECT class=InputStyle name="sharetype" id="sharetype" onChange="onChangeSharetype()" >   
                              <option value="0" selected>人员</option> 
                              <option value="1">分部</option>
                              <option value="2">部门</option>
                              <option value="3">角色</option>    
                              <option value="4">所有人</option>    
                          </SELECT>
                      </TD>
                  </TR>
                  <TR style="height:1px;"><TD class=Line colspan=2></TD></TR>
                  <TR>
                      <TD>共享内容</TD>
                      <TD class="Field">
                          <BUTTON class=Browser style="display:''" onClick="onShowResource('relatedshareid','showrelatedsharename');" name=showresource id="showresource"></BUTTON> 
                          <BUTTON class=Browser style="display:none" onClick="onShowSubcompany('relatedshareid','showrelatedsharename');" name=showsubcompany id="showsubcompany"></BUTTON> 
                          <BUTTON class=Browser style="display:none" onClick="onShowDepartment('relatedshareid','showrelatedsharename');" name=showdepartment id="showdepartment"></BUTTON> 
                          <BUTTON class=Browser style="display:none" onClick="onShowRole('relatedshareid','showrelatedsharename');" name=showrole id="showrole"></BUTTON>
                          <INPUT type=hidden name=relatedshareid  id="relatedshareid" value="">
                          <span id=showrelatedsharename name=showrelatedsharename></span>                                            
                      </TD>
                  </TR>
                  <TR style="height:1px;"><TD class=Line colspan=2></TD></TR>
                  <TR id=showrolelevel name=showrolelevel style="display:none">
                      <TD>共享级别</TD>
                      <td class="Field">
                           <SELECT id="rolelevel" name="rolelevel">
                                  <option value="0" selected>部门</option>
                                  <option value="1">分部</option>
                                  <option value="2">总部</option>
                           </SELECT>
                      </td>
                  </TR>
                  <TR id="showroleleveltr" style="height:1px;display:none"><TD class=Line colspan=2></TD></TR>
                    <TR id=showseclevel style="display:none">
                      <TD>安全级别</TD>
                      <td class="field">
                           <INPUT type=text name="seclevel" id="seclevel" maxlength="3" class=InputStyle size=6 value="0" onchange='checkinput(this)'>
                           <span id=seclevelimage></span>
                      </td>
                  </TR>
                  <TR id="showsecleveltr" style="height:1px;display:none"><TD class=Line colspan=2></TD></TR>
              </TBODY>
          </TABLE>
     </div>     
     <div align="center" style="background:rgb(246, 246, 246);vertical-align: middle;padding-top: 8px;border-top:#dadee5 solid 1px;">
            <BUTTON type="button" class=btn accessKey= O id="okBtn" onclick="dosave()"><u>O</u>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>&nbsp;&nbsp;&nbsp;&nbsp;
            <BUTTON type="button" class=btnReset accessKey= T id="cancelBtn" onclick="window.close();"><u>T</u>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
     </div>
</body>
</html>