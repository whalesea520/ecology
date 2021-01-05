
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.email.domain.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="crm" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="lms" class="weaver.email.service.LabelManagerService" scope="page" />
<jsp:useBean id="fms" class="weaver.email.service.FolderManagerService" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(19828,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(93,user.getLanguage());
String needfav ="1";
String needhelp ="";

String showTop = Util.null2String(request.getParameter("showTop"));

String sql = "";
String ruleName = "", matchAll = "", applyTime = "";
int mailAccountId = 0;
int ruleId = Util.getIntValue(request.getParameter("id"));
sql = "SELECT * FROM MailRule WHERE id="+ruleId+"";
rs.executeSql(sql);
if(rs.next()){
	ruleName = rs.getString("ruleName");
	matchAll = rs.getString("matchAll");
	applyTime = rs.getString("applyTime");
	mailAccountId = rs.getInt("mailAccountId");
}
%>

<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/js/prototype_wev8.js"></script>
<script type="text/javascript" src="/js/dojo_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
<script language="javascript">

jQuery(document).ready(function(){
  jQuery('body').jNice(); 
});

 function  MailRuleSubmit(){
     if(check_form(fMailRule,'ruleName')){
		
		if(jQuery("img[src='/images/BacoError_wev8.gif']").length !=0){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage())%>");
			return;
		}
		
		var boo=true;	
		try{
				
		var cSourceArray="";
		var operatorArray="";
		var cTargetArray="";
		var cTargetPriorityArray="";
		var SendDateArray="";
		
		for(var i=1;i<=termsRowlength;i++){
				   if(document.getElementById("cSource"+i)==null){
						continue;
				   }	         
				 cSourceArray+=document.getElementById("cSource"+i).value+",";
			
				  	
				  var operL=document.getElementById("operator"+i+"L").disabled;	
				 
				  var operK=document.getElementById("operator"+i+"K").disabled;
				 
				  var operJ=document.getElementById("operator"+i+"J").disabled;
				 
				  if(operL==false&&operK!=false&&operJ!=false){
				  		
				   		operatorArray+=document.getElementById("operator"+i+"L").value+",";
				  }	
				  if(operK==false&&operL!=false&&operJ!=false){
				  		
				  		operatorArray+=document.getElementById("operator"+i+"K").value+",";
				  }	
				  if(operJ==false&&operL!=false&&operK!=false){
				  		
				  		operatorArray+=document.getElementById("operator"+i+"J").value+",";
				  }	 
				  
				   		cTargetArray+=document.getElementById("cTarget"+i).value+",";
				  								
						cTargetPriorityArray+=document.getElementById("cTargetPriority"+i).value+",";
				  				 				  
						SendDateArray+=document.getElementById("sendDate"+i).value+"a,";
				
				}
		
		document.getElementById("cSource").value = cSourceArray;
		document.getElementById("operator").value = operatorArray;
		document.getElementById("cTarget").value = cTargetArray;
		document.getElementById("cTargetPriority").value = cTargetPriorityArray;
		document.getElementById("SendDateArrayass").value = SendDateArray;
		
		
		
		var aSourceArray="";
		var aTargetFolderIdArray="";
		var aTargetCRMIdArray="";
		var mainIdArray="";
		var subIdArray="";
		var secIdArray="";
		for(var j=1;j<=actionRowLength;j++){
			
			if(document.getElementById("aSource"+j)==null){
				continue
			}
			aSourceArray+=document.getElementById("aSource"+j).value+",";
			aTargetFolderIdArray+=document.getElementById("aTargetFolderId"+j).value+",";
			if(jQuery("#aTargetCRMId"+j).length==0){
				aTargetCRMIdArray+=",";
			}else{
				aTargetCRMIdArray+=document.getElementById("aTargetCRMId"+j).value+","
			}
			mainIdArray+=document.getElementById("mainId"+j).value+",";
			subIdArray+=document.getElementById("subId"+j).value+",";
			secIdArray+=document.getElementById("secId"+j).value+",";
		}
		document.getElementById("aSource").value = aSourceArray;
		document.getElementById("aTargetFolderId").value = aTargetFolderIdArray;
		document.getElementById("aTargetCRMId").value = aTargetCRMIdArray;
		document.getElementById("mainId").value = mainIdArray;
		document.getElementById("subId").value = subIdArray;
		document.getElementById("secId").value = secIdArray;
		
		var aSourceList=aSourceArray.split(",");
		var aTargetCRMIdList=aTargetCRMIdArray.split(",");
		var aTargetFolderId=aTargetFolderIdArray.split(",");
		for(var i=0;i<aSourceList.length;i++){
			if(aTargetCRMIdList[i]==""&&aSourceList[i]==4){
          	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
          	boo=false;   
        	}else if(aTargetFolderId[i]==""&&(aSourceList[i]==1||aSourceList[i]==2)){
         	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
         	boo=false;
         }
        }
		
		
		}catch(e){
		}
		
		if(boo){
			fMailRule.submit();
		}
	}
 }
 
 
 
function delrule(thisvalue,thisaction){
   var actionId=0;
   
   window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>",function(){
	   if(thisaction=="deleteRuleCondition"){
		     for(var k=document.getElementsByName("rule_1").length-1;k>-1;k--){
		     	var bool=false;
		         if(document.getElementsByName("rule_1")[k].checked==true){
		         	document.getElementById("conditionId").value+=","+document.getElementsByName("rule_1")[k].value; 
		         	if(document.getElementsByName("ck_1")[k].value=="1"){ 		
		          		// termsRowlength--;
		          		 bool=true;
		     		 }
		     		
		     		document.getElementsByName("rule_1")[k].parentNode.parentNode.style.border="#FFFFFF 0px";
		     		//document.getElementsByName("rule_1")[k].parentNode.parentNode.removeNode(document.getElementsByName("rule_1")[k].parentNode);
		     		if(document.getElementsByName("ck_1")[k].value=="1"){
		     			jQuery(jQuery("input[name=rule_1]")[k]).parent().parent().parent().remove()
		     		}else{
		     			jQuery(jQuery("input[name=rule_1]")[k]).parent().parent().parent().remove();
		     		}
		     		// jQuery(jQuery("input[name=rule_1]")[k]).parent().parent().remove();
		         }
		              
		     }
	   	}
	    if(thisaction=="deleteRuleAction"){
		     for(var k=document.getElementsByName("rule_2").length-1;k>-1;k--){
		     	var bool=false;
		        if(document.getElementsByName("rule_2")[k].checked==true){
		        	document.getElementById("actionId").value+=","+document.getElementsByName("rule_2")[k].value;
		        	if(document.getElementsByName("ck_2")[k].value=="1"){
		          	 	var bool=false;
		        	}
		        	document.getElementsByName("rule_2")[k].parentNode.parentNode.style.border="#FFFFFF 0px";
		        	//document.getElementsByName("rule_2")[k].parentNode.parentNode.removeNode(document.getElementsByName("rule_2")[k].parentNode);
					if(document.getElementsByName("ck_2")[k].value=="1"){
		     			jQuery(jQuery("input[name=rule_2]")[k]).parent().parent().parent().remove()
		     		}else{
		     			jQuery(jQuery("input[name=rule_2]")[k]).parent().parent().parent().remove();
		     		}
					// jQuery(jQuery("input[name=rule_2]")[k]).parent().parent().remove();
		        }
		     }   
   		}
   	})
}

function onSelectMailInbox(himself,num){
	switch(himself.value) {
	case "1" :
		var obj = dojo.byId("aTargetFolderId"+num);
		jQuery(obj).selectbox("detach");
		obj.options.length=0;
		 obj.options.add(new Option("<%=SystemEnv.getHtmlLabelName(19816,user.getLanguage())%>","0"))
		 obj.options.add(new Option("<%=SystemEnv.getHtmlLabelName(2038,user.getLanguage())%>","-1"))
		 obj.options.add(new Option("<%=SystemEnv.getHtmlLabelName(2039,user.getLanguage())%>","-2"))
		 obj.options.add(new Option("<%=SystemEnv.getHtmlLabelName(2040,user.getLanguage())%>","-3"))
		
      	<%
		ArrayList folderList= fms.getFolderManagerList(user.getUID());
		for(int i=0; i<folderList.size();i++){
			MailFolder mf = (MailFolder)folderList.get(i);
		%>
		 obj.options.add(new Option("<%=mf.getFolderName() %>","<%=mf.getId() %>"))
		
		<%
		}
		%>
		break;
	case "2" :
		var obj = dojo.byId("aTargetFolderId"+num);
		jQuery(obj).selectbox("detach");
		obj.options.length=0;
		 obj.options.add(new Option("<%=SystemEnv.getHtmlLabelName(19816,user.getLanguage())%>","0"))
		 obj.options.add(new Option("<%=SystemEnv.getHtmlLabelName(2038,user.getLanguage())%>","-1"))
		 obj.options.add(new Option("<%=SystemEnv.getHtmlLabelName(2039,user.getLanguage())%>","-2"))
		 obj.options.add(new Option("<%=SystemEnv.getHtmlLabelName(2040,user.getLanguage())%>","-3"))
		
      	<%
		for(int i=0; i<folderList.size();i++){
			MailFolder mf = (MailFolder)folderList.get(i);
		%>
		 obj.options.add(new Option("<%=mf.getFolderName() %>","<%=mf.getId() %>"))
		<%
		}
		%>
		
		break;
	case "6" :
		var obj = dojo.byId("aTargetFolderId"+num);
		jQuery(obj).selectbox("detach");
		obj.options.length=0;
      	<%
 			ArrayList lmsList= lms.getLabelManagerList(user.getUID());
			for(int i=0; i<lmsList.size();i++){
			MailLabel ml = (MailLabel)lmsList.get(i);
		%>
		 obj.options.add(new Option("<%=ml.getName() %>","<%=ml.getId() %>"));
		 // jQuery(obj).selectbox("option",jQuery(obj),"<%=ml.getName() %>","<%=ml.getId() %>");
		<%
			}
		%>
		break;
	default:
		dojo.byId("aTargetFolderId"+num).innerHTML = "";
		break;
	}
	beautySelect();
	
}

function getMailInboxFolderName(paramFolderId){
	var folderName = "";
	if(paramFolderId==-1){
		folderName = "<%=SystemEnv.getHtmlLabelName(2038,user.getLanguage())%>";
	}else if(paramFolderId==-2){
		folderName = "<%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%>";
	}else if(paramFolderId==-3){
		folderName = "<%=SystemEnv.getHtmlLabelName(19817,user.getLanguage())%>";
	}else if(paramFolderId==0){
		folderName = "<%=SystemEnv.getHtmlLabelName(19816,user.getLanguage())%>";
	}else{
		for(var i=0;i<$("folderSelect").options.length;i++){
			if(paramFolderId==$("folderSelect").options[i].value){
				folderName = $("folderSelect").options[i].innerHTML;
				break;
			}
		}
	}
	return folderName;
}
 
var termsRowlength=0;
var actionRowLength=0;

function addRow(tabName){
	var tab=document.getElementById(tabName);
	var row=tab.insertRow(-1);
	if(tabName=="termsBody"){
		termsRowlength++;
	}else{
		actionRowLength++;
	}
	
	for(var i=0;i<3;i++){
		cell=row.insertCell(-1);
		if(tabName=="termsBody"){
			
			if(i==0){
				cell.innerHTML='<input type="checkbox" name="rule_1"><input type="hidden" name="ck_1" value="1"/>';
			}else if(i == 1){
				cell.innerHTML='<select name="cSource" style="width:90px;" id="cSource'+termsRowlength+'" class="rule" onchange="conditionChange('+termsRowlength+',this)"> '+
				                  '<option value="1"><%=SystemEnv.getHtmlLabelName(344, user.getLanguage())%></option>'+
                     			  '<option value="2"><%=SystemEnv.getHtmlLabelName(2034, user.getLanguage())%></option>'+
                                  '<option value="3"><%=SystemEnv.getHtmlLabelName(2046, user.getLanguage())%></option>'+
                                  '<option value="4"><%=SystemEnv.getHtmlLabelName(2084, user.getLanguage())%></option>'+
                                  '<option value="5"><%=SystemEnv.getHtmlLabelName(848, user.getLanguage())%></option>'+
                                  '<option value="6"><%=SystemEnv.getHtmlLabelName(2047, user.getLanguage())%></option>'+
                                  '<option value="7"><%=SystemEnv.getHtmlLabelName(19842, user.getLanguage())%></option>'+
                            '</select>'+
			     			'&nbsp;'+
			     			'<select name="operator1" style="width:90px;" id="operator'+termsRowlength+'L">'+
								 '<option value="1"><%=SystemEnv.getHtmlLabelName(346, user.getLanguage())%></option>'+
								 '<option value="2"><%=SystemEnv.getHtmlLabelName(15507, user.getLanguage())%></option>'+
								 '<option value="3"><%=SystemEnv.getHtmlLabelName(163, user.getLanguage())%></option>'+
								 '<option value="4"><%=SystemEnv.getHtmlLabelName(19843, user.getLanguage())%></option>'+
							 '</select>'+
							 '<select name="operator2"  id="operator'+termsRowlength+'J" style="display:none;width:90px;" disabled="true">'+
								'<option value="5"><%=SystemEnv.getHtmlLabelName(15508, user.getLanguage())%></option>'+
								'<option value="6"><%=SystemEnv.getHtmlLabelName(15509, user.getLanguage())%></option>'+
							'</select>'+
							'<select name="operator3" id="operator'+termsRowlength+'K" style="display:none;width:90px;" disabled="true">'+
								'<option value="3"><%=SystemEnv.getHtmlLabelName(163, user.getLanguage())%></option>'+
							'</select>';
			}else{
				cell.innerHTML='<input type="text" name="cTarget" id="cTarget'+termsRowlength+'" style="width:250px" />'+
			     			'<select style="width:90px;display:none" name="cTargetPriority" id="cTargetPriority'+termsRowlength+'" >'+
								'<option value="3"><%=SystemEnv.getHtmlLabelName(2086, user.getLanguage())%></option>'+
								'<option value="1"><%=SystemEnv.getHtmlLabelName(2087, user.getLanguage())%></option>'+ //紧急
							'</select>'+
							'<button name="browserDate" type="button" class="calendar" id="browserDate'+termsRowlength+'" onclick="getDateMail(\'sendDate'+termsRowlength+'\',\'sendDateSpan'+termsRowlength+'\')" style="display:none"></button>'+
							'<span name="sendDateSpan" id="sendDateSpan'+termsRowlength+'"></span>'+
							'<input type="hidden" id="sendDate'+termsRowlength+'" name="sendDate" value="">';
			     	    		                         
			}
		}else{
			
			if(i==0){
				cell.innerHTML='<input type="checkbox" name="rule_2"><input type="hidden" name="ck_2" value="1"/>';
			}else if(i == 1){
				//cell.className="Field";
				cell.innerHTML='<select name="aSource" style="width:120px;" id="aSource'+actionRowLength+'" class="rule" onchange="actionChange('+actionRowLength+',this),onSelectMailInbox(this,'+actionRowLength+')">'+
										'<option value="1"><%=SystemEnv.getHtmlLabelName(19832,user.getLanguage())%></option>'+
										'<option value="3"><%=SystemEnv.getHtmlLabelName(18492,user.getLanguage())%></option>'+
										'<option value="5"><%=SystemEnv.getHtmlLabelName(31258,user.getLanguage())%></option>'+
										'<option value="4"><%=SystemEnv.getHtmlLabelName(19822,user.getLanguage())%></option>'+
										'<option value="6"><%=SystemEnv.getHtmlLabelName(81324,user.getLanguage())%></option>'+
						  '</select>';
			}else{
		     	cell.innerHTML='<span style="width:20px"></span>'+
			     		       '<select style="width:120px;" name="aTargetFolderId" id="aTargetFolderId'+actionRowLength+'">'+
				     		      	'<option value="0"><%=SystemEnv.getHtmlLabelName(19816,user.getLanguage())%></option>'+
				     		      	'<option value="-1"><%=SystemEnv.getHtmlLabelName(2038,user.getLanguage())%></option>'+
				     		      	'<option value="-2"><%=SystemEnv.getHtmlLabelName(2039,user.getLanguage())%></option>'+
				     		      	'<option value="-3"><%=SystemEnv.getHtmlLabelName(2040,user.getLanguage())%></option>'+
				     		      	<%
									for(int i=0; i<folderList.size();i++){
										MailFolder mf = (MailFolder)folderList.get(i);
									%>
										'<option value="<%=mf.getId() %>"><%=mf.getFolderName() %></option>'+
									<%
										}
									%>
			     		      '</select>'+
		   					  '<span id="aTargetCRMIdSpanShow'+actionRowLength+'">'+
		   					  	'<span name="aTargetCRMIdSpan" id="aTargetCRMIdSpan'+actionRowLength+'" class="browser"></span>'+
		   					  '</span>'+
		  					  '<input type="hidden" name="mainId" id="mainId'+actionRowLength+'"/>'+
		                      '<input type="hidden" name="subId" id="subId'+actionRowLength+'"/>'+
		                      '<input type="hidden" name="secId" id="secId'+actionRowLength+'"/>';	
			}
		}	
		row.appendChild(cell);
	}
	jQuery('body').jNice(); 
	beautySelect();
}


function encode(str){     
       return escape(str);
}

// 获取event
function getEvent() {
	if (window.ActiveXObject) {
		return window.event;// 如果是ie
	}
	func = getEvent.caller;
	while (func != null) {
		var arg0 = func.arguments[0];
		if (arg0) {
			if ((arg0.constructor == Event || arg0.constructor == MouseEvent)
					|| (typeof (arg0) == "object" && arg0.preventDefault && arg0.stopPropagation)) {
				return arg0;
			}
		}
		func = func.caller;
	}
	return null;
}

function conditionChange(num,o){

	var oValue = Value = o.options[o.selectedIndex].value;
	var skipFields = "";
	switch(oValue){
		case "1":
		case "2":
		case "3":
		case "4":
			skipFields = "operator"+num+"L,cTarget"+num+",";
			break;
		case "5"://重要性
			skipFields = "operator"+num+"K,cTargetPriority"+num+",";
			break;
		case "6"://发件日期
			skipFields = "operator"+num+"J,browserDate"+num+",sendDateSpan"+num+",";
			break;
		case "7"://邮件大小
			skipFields = "operator"+num+"J,cTarget"+num+",";
			break;
	}
	hideConditionFormField(skipFields,num);
	if(oValue == 7){
		jQuery("#cTarget"+num).live("blur",function(){
			checkFloat(this);
		})
	}
}
function hideConditionFormField(skipField,num){
	var fieldIds = ["operator"+num+"L","operator"+num+"J","operator"+num+"K","cTargetPriority"+num,"browserDate"+num,"sendDateSpan"+num,"cTarget"+num];
	for(var i=0;i<fieldIds.length;i++){
		if(skipField.indexOf(fieldIds[i]+",") !=- 1){
			if(-1 != fieldIds[i].indexOf("operator") || -1 != fieldIds[i].indexOf("cTargetPriority")){
				jQuery("#"+fieldIds[i]).selectbox("show");
				jQuery("#"+fieldIds[i]).selectbox("enable");
			}else{
				dojo.byId(fieldIds[i]).style.display = "";	
				dojo.byId(fieldIds[i]).disabled = false;
			}
			continue;
		}
		if(-1 != fieldIds[i].indexOf("operator") || -1 != fieldIds[i].indexOf("cTargetPriority")){
			jQuery("#"+fieldIds[i]).selectbox("hide");
			jQuery("#"+fieldIds[i]).selectbox("disable");
		}else{
			dojo.byId(fieldIds[i]).style.display = "none";
			dojo.byId(fieldIds[i]).disabled = true;
		}
	}
}
function actionChange(num,o){
	
	var oValue = Value = o.options[o.selectedIndex].value;
	switch(oValue){
		case "1" ://移动到
			// dojo.byId("aTargetFolderId"+num).style.display = "";
			jQuery("#aTargetFolderId"+num).selectbox("show");
			jQuery("#aTargetCRMIdSpanShow"+num).hide();
			break;
		case "2" ://复制到
			// dojo.byId("aTargetFolderId"+num).style.display = "";
			jQuery("#aTargetFolderId"+num).selectbox("show");
			jQuery("#aTargetCRMIdSpanShow"+num).hide();
			break;
		case "3" ://标记为已读
			// dojo.byId("aTargetFolderId"+num).style.display = "none";
			jQuery("#aTargetFolderId"+num).selectbox("hide");
			jQuery("#aTargetCRMIdSpanShow"+num).hide();
			break;
		case "4" ://导入客户联系
			// dojo.byId("aTargetFolderId"+num).style.display = "none";
			jQuery("#aTargetFolderId"+num).selectbox("hide");
			jQuery("#aTargetCRMIdSpanShow"+num).show();
			jQuery("#aTargetCRMIdSpan"+num).e8Browser({
			   name:"aTargetCRMId"+num,
			   viewType:"0",
			   browserValue:"0",
			   isMustInput:"2",
			   browserSpanValue:"",
			   hasInput:true,
			   linkUrl:"/CRM/data/ViewCustomer.jsp?isrequest=1&CustomerID=",
			   isSingle:true,
			   completeUrl:"/data.jsp?type=7",
			   browserUrl:"/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp",
			   width:"150px",
			   hasAdd:false,
			   isSingle:true
			  });	
			break;
		case "5" ://标记为星标
			// dojo.byId("aTargetFolderId"+num).style.display = "none";
			jQuery("#aTargetFolderId"+num).selectbox("hide");
			jQuery("#aTargetCRMIdSpanShow"+num).hide();
			break;
		case "6" ://标记为标签
			// dojo.byId("aTargetFolderId"+num).style.display = "";
			jQuery("#aTargetFolderId"+num).selectbox("show");
			jQuery("#aTargetCRMIdSpanShow"+num).hide();
			break;
	}
}
 
 
 function getDateMail(inputname,spanname){
	 WdatePicker({el:$dp.$(spanname),onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;
			},oncleared:function(dp){$dp.$(inputname).value = '';$dp.$(spanname).value = ''}});
}
 

function getCRM(inputname,spanname){
	returndate = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (returndate!=null){
		jQuery("#"+inputname).val(returndate.id);
		jQuery("#"+spanname).html(returndate.name);
		if (jQuery("#"+inputname).val()==""){
		    jQuery("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
		}
	}
}
 
 
 jQuery(function(){
 	checkinput('ruleName','ruleNameSpan');
 });
</script>

<script type="text/vbscript">
sub getDate1(inputname,spanname)
    returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
    spanname.innerHtml = returndate
    inputname.value = returndate
end sub

sub getCRM1(inputname,spanname)
	returndate = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (Not IsEmpty(returndate)) then
		
		inputname.value=returndate(0)
		spanname.innerHtml=returndate(1)	
		if (IsEmpty(inputname.value)) then
		    spanname.innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		end if
	end if
end sub


</script>

<script type="text/javascript" src="/js/prototype_wev8.js"></script>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCFromPage="mailOption";//屏蔽右键菜单时使用
//RCMenu += "{添加条件,javascript:redirect(\"MailRuleConditionAdd.jsp?ruleId="+ruleId+"\", \"tab2\"),_self} " ;    
//RCMenuHeight += RCMenuHeightStep;
//RCMenu += "{添加动作,javascript:redirect(\"MailRuleActionAdd.jsp?ruleId="+ruleId+"\", \"tab2\"),_self} " ;    
//RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:MailRuleSubmit(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="mail"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(19828,user.getLanguage())%>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="MailRuleSubmit()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<div class="zDialog_div_content" style="height:447px;">
<form method="post" action="MailRuleOperation.jsp" id="fMailRule" name="fMailRule">
<input type="hidden" name="operation" value="edit" />
<input type="hidden" name="id" value="<%=ruleId%>" />

<input type="hidden" name="conditionId" id="conditionId" value="0"> 
<input type="hidden" name="actionId" id="actionId" value="0">
<input type="hidden" name="ruleConditionRowIndex" id="ruleConditionRowIndex" value="10," />
<input type="hidden" name="ruleActionRowIndex" id="ruleActionRowIndex" value="16," />

<input type="hidden" name="cSource" id="cSource" value="">
<input type="hidden" name="operator" id="operator" value="">
<input type="hidden" name="cTarget" id="cTarget" value="">
<input type="hidden" name="cTargetPriority" id="cTargetPriority" value="">
<input type="hidden" name="SendDate" id="SendDate" value="">
<input type="hidden" name="SendDateArrayass" id="SendDateArrayass" value="">

<input type="hidden" name="aSource" id="aSource" value="">
<input type="hidden" name="aTargetFolderId" id="aTargetFolderId" value="">
<input type="hidden" name="aTargetCRMId" id="aTargetCRMId" value="">
<input type="hidden" name="mainId" id="mainId" value="">
<input type="hidden" name="subId" id="subId" value="">
<input type="hidden" name="secId" id="secId" value="">

<wea:layout>
<wea:group context='<%=SystemEnv.getHtmlLabelName(19834,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(19829,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="ruleNameSpan" required="true">
				<input type="text" name="ruleName" value="<%=ruleName%>" style="width:30%" 
					onchange="checkinput('ruleName','ruleNameSpan')" />
			</wea:required>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(19835,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="radio" id="matchAll0" name="matchAll" value="0" <%if(matchAll.equals("0"))out.print("checked");%> /><label for="matchAll0" class="ruleDefine m-l-10" style="font-weight: normal !important"><%=SystemEnv.getHtmlLabelName(19836,user.getLanguage())%></label>
			<input type="radio" id="matchAll1" name="matchAll" value="1" <%if(matchAll.equals("1"))out.print("checked");%> /><label for="matchAll1" class="ruleDefine m-l-10" style="font-weight: normal !important"><%=SystemEnv.getHtmlLabelName(19837,user.getLanguage())%></label>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(19838,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="radio" id="applyTime0" name="applyTime" value="0" <%if(applyTime.equals("0"))out.print("checked");%> /><label for="applyTime0" class="ruleDefine m-l-10" style="font-weight: normal !important"><%=SystemEnv.getHtmlLabelName(19839,user.getLanguage())%></label>
			<input type="radio" id="applyTime1" name="applyTime" value="1" <%if(applyTime.equals("1"))out.print("checked");%> /><label for="applyTime1" class="ruleDefine m-l-10" style="font-weight: normal !important"><%=SystemEnv.getHtmlLabelName(19840,user.getLanguage())%></label>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(19830,user.getLanguage())%></wea:item>
		<wea:item>
			<select name="mailAccountId" style="width: 150px;">
			<option value="-1" <%if(-1==mailAccountId)out.print("selected");%>><%=SystemEnv.getHtmlLabelName(31350,user.getLanguage())%></option>
			<%rs.executeSql("SELECT * FROM MailAccount WHERE userId="+user.getUID()+"");while(rs.next()){%>
				<option value="<%=rs.getInt("id")%>" <%if(rs.getInt("id")==mailAccountId)out.print("selected");%>><%=rs.getString("accountName")%></option>
			<%}%>
			</select>
		</wea:item>
	</wea:group>
</wea:layout>

<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(19841,user.getLanguage())%>'>
		<wea:item type="groupHead">
			<input type="button" class="addbtn" onclick="addRow('termsBody')" title="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>"/>
    		<input type="button" class="delbtn" onclick="javascript:delrule('<%=ruleId%>','deleteRuleCondition')" title="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"/>
		</wea:item>		
		
		<wea:item attributes="{'colspan':'2'}">

			<table id="termsBody" width="100%;" class="listStyle" style="vertical-align: top;">
			<%
				int cSource=0,operator=0;
				String sSource="",cTarget="",cTargetPriority="";
				rs.executeSql("SELECT * FROM MailRuleCondition WHERE ruleId="+ruleId+"");
				while(rs.next()){
					cSource = rs.getInt("cSource");
					operator = rs.getInt("operator");
					cTarget = rs.getString("cTarget");
					cTargetPriority = rs.getString("cTargetPriority");
					if(cSource==1){
						sSource = SystemEnv.getHtmlLabelName(344, user.getLanguage());
					}else if(cSource==2){
						sSource = SystemEnv.getHtmlLabelName(2034, user.getLanguage());
					}else if(cSource==3){
						sSource = SystemEnv.getHtmlLabelName(2046, user.getLanguage());
					}else if(cSource==4){
						sSource = SystemEnv.getHtmlLabelName(2084, user.getLanguage());
					}else if(cSource==5){
						sSource = SystemEnv.getHtmlLabelName(848, user.getLanguage());
						if(cTargetPriority.equals("2")){
							cTarget = SystemEnv.getHtmlLabelName(15533, user.getLanguage());
						}else if(cTargetPriority.equals("3")){
							cTarget = SystemEnv.getHtmlLabelName(2086, user.getLanguage());
						}else{
							cTarget = SystemEnv.getHtmlLabelName(2087, user.getLanguage());
						}
					}else if(cSource==6){
						sSource = SystemEnv.getHtmlLabelName(2047, user.getLanguage());
						cTarget = rs.getString("cSendDate");
					}else if(cSource==7){
						sSource = SystemEnv.getHtmlLabelName(19842, user.getLanguage());
					}
			%>	
				<tr class="dataLight">
				    <TD width="5%"><input type="checkbox" name="rule_1" value="<%=rs.getInt("id")%>"><input type="hidden" name="ck_1" value="0"/></TD>
					<td width="25%"><span style="width:105px"><%=sSource%> </span>&nbsp;<span style="color:red;style="width:105px""><%=getRuleConditionOperator(String.valueOf(operator), user)%></span></td>
					<td width="70%"><%=cTarget%></td>			
						
				</tr>
				<%}%>
			</table>
		</wea:item>
	</wea:group>
</wea:layout>

<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(19831,user.getLanguage())%>'>
		<wea:item type="groupHead">
			<input type="button" class="addbtn" onclick="addRow('actionBody')" title="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>"/>
    		<input type="button" class="delbtn" onclick="javascript:delrule('<%=ruleId%>','deleteRuleAction')" title="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"/>
		</wea:item>
		
		<wea:item attributes="{'colspan':'2'}">
			<table id="actionBody" width="100%;" class="listStyle">
				<%
					String aSource="",aSourceAction="",aTargetFolderId="",aTargetCRMId="",aMainId="",aSubId="",aSecId="";
					int aRowIndex = 0;
					rs.executeSql("SELECT * FROM MailRuleAction WHERE ruleId="+ruleId+"");
					while(rs.next()){
						aSource = rs.getString("aSource");
						aTargetFolderId = rs.getString("aTargetFolderId");
						aTargetCRMId = rs.getString("aTargetCRMId");
						aMainId = rs.getString("aMainId");
						aSubId = rs.getString("aSubId");
						aSecId = rs.getString("aSecId");
					
						if(aSource.equals("1")){
							aSourceAction = SystemEnv.getHtmlLabelName(19832,user.getLanguage());
						}else if(aSource.equals("2")){
							aSourceAction = SystemEnv.getHtmlLabelName(19833,user.getLanguage());
						}else if(aSource.equals("3")){
							aSourceAction = SystemEnv.getHtmlLabelName(18492,user.getLanguage());
						}else if(aSource.equals("4")){
							aSourceAction = SystemEnv.getHtmlLabelName(19822,user.getLanguage());
						}else if(aSource.equals("5")){
							aSourceAction = SystemEnv.getHtmlLabelName(31258,user.getLanguage());
						}else if(aSource.equals("6")){
							aSourceAction = SystemEnv.getHtmlLabelName(81324,user.getLanguage());
						}
				%>
				
					<tr class="dataLight">
					    <TD width="5%"><input type="checkbox" name="rule_2" value="<%=rs.getInt("id")%>"><input type="hidden" name="ck_2" value="0"/></TD>	
					    <td width="25%"><%=aSourceAction%></td>
						<td width="70%">
						<%
						if(aSource.equals("1") || aSource.equals("2")){
							out.print(getFolderName(aTargetFolderId, user.getUID(), user));
						}else	if(aSource.equals("4")){
							out.print(crm.getCustomerInfoname(aTargetCRMId));
						}else	if(aSource.equals("6")){
							MailLabel mailLable = lms.getLabelInfo(aTargetFolderId);
						%>
							<div style="display:inline-block; _zoom:1;_display:inline; margin-top:8px; border-radius:2px; height:10px; width:10px; background:<%=mailLable.getColor()%>;">&nbsp;</div>
							<span><%=mailLable.getName() %></span>
						<%
						}
						%>
						</td>
					</tr>
				<%}%>
			</table>
		</wea:item>
	</wea:group>
</wea:layout>
</form>
</div>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
</body>
<%!
String getRuleConditionOperator(String cOperator, weaver.hrm.User user){
	String operator = "";
	if(cOperator.equals("1")){
		 operator = SystemEnv.getHtmlLabelName(346, user.getLanguage());
	}else if(cOperator.equals("2")){
		operator = SystemEnv.getHtmlLabelName(15507, user.getLanguage());
	}else if(cOperator.equals("3")){
		operator = SystemEnv.getHtmlLabelName(163, user.getLanguage());
	}else if(cOperator.equals("4")){
		operator = SystemEnv.getHtmlLabelName(19843, user.getLanguage());
	}else if(cOperator.equals("5")){
		operator = SystemEnv.getHtmlLabelName(15508, user.getLanguage());
	}else if(cOperator.equals("6")){
		operator = SystemEnv.getHtmlLabelName(15509, user.getLanguage());
	}
	return operator;
}

String getFolderName(String fId, int userId, weaver.hrm.User user){
	int folderId = Util.getIntValue(fId);
	String folderName = "";
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	
	rs.executeSql("SELECT folderName FROM MailInboxFolder WHERE userId="+userId+" AND id="+folderId+"");
	if(rs.next()){
		folderName = Util.null2String(rs.getString("folderName"));
	}else{
		if(folderId==0){
			folderName = SystemEnv.getHtmlLabelName(19816,user.getLanguage());
		}else if(folderId==-1){
			folderName = SystemEnv.getHtmlLabelName(2038,user.getLanguage());
		}else if(folderId==-2){
			folderName = SystemEnv.getHtmlLabelName(220,user.getLanguage());
		}else if(folderId==-3){
			folderName = SystemEnv.getHtmlLabelName(19817,user.getLanguage());
		}
	}
	return folderName;
}
%>
	<script language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
	<script language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
	<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
	
