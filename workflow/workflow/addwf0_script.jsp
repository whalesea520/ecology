<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String ajax = Util.null2String(request.getParameter("ajax"));
String wfid = Util.null2String(request.getParameter("wfid"));
String isTemplate = Util.null2String(request.getParameter("isTemplate"));
String isnewform_str = Util.null2String(request.getParameter("isnewform"));
String isrejectremind = Util.null2String(request.getParameter("isrejectremind"));
String chatsType = Util.null2String(request.getParameter("chatsType"));

boolean isnewform = false;
if("true".equals(isnewform_str))
	isnewform = true;
%>

<script type="text/javascript">
var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
//add by wshen
$("#SAPSource").change(function(){
	var poolid = $("#SAPSource").val();
	var isUseOldVersion = $("#isUseOldVersion").val();
	if(isUseOldVersion=="0"){
		$.ajax({
					data:"poolid="+poolid+"&wFid=<%=wfid%>",
					url:"/workflow/workflow/checkSapFunsExistAjax.jsp",
					type:"get",
					dataType:"json",
					success:function(data) {
						if (data != null) {
							var msg = data.message;
							var flag = data.flag;
							if (flag == false) {
								alert(msg);
								var selObj = document.getElementById("SAPSource");
								var theOptions = selObj.options;
								var optNum = theOptions.length;
								for(var i=0;i<optNum;i++) {
									if(theOptions[i].value==""){
										jQuery("#SAPSource").selectbox("detach");
										theOptions[i].selected = true;
										jQuery("#SAPSource").selectbox("attach");
										break;
									}
								}
							}
						}
					},
					error:function(data){
						alert("Ajax data error!");
					}
				}
		);
	}
});

 $(function() {    
   $("#defaultName").click(function() {
       if (!$("#defaultName").attr("checked")) {
	        $("#defaultitle").hide();
	   }else{
		   $("#defaultitle").show();
	   }
    });  
  }); 
</script>
<%
if(!ajax.equals("1")){
%>
<script language=javascript>
function onchangeisbill(objval){
   var oldval=$G("oldisbill").value;
   if(oldval!=3 && objval!=oldval){
       top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(18682, user.getLanguage())%>",function(){
			$G("isbill").value=objval;
	   },function(){
			$G("isbill").value=$G("oldisbill").value;
	   });
       //if(!confirm("<%=SystemEnv.getHtmlLabelName(18682,user.getLanguage())%>")){
       //     $G("isbill").value=$G("oldisbill").value;
       //}       
   }
   objval=$G("isbill").value;
   if(objval!=3){
   		$("#showFormSpan").show();
   }else{
   		$("#showFormSpan").hide();
   }
}
function onchangeiscust(objval){
    var srctype=$G("src").value;
	if(srctype=="editwf"&&objval!=$G("oldiscust").value){
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(18685, user.getLanguage())%>",function(){
			$G("iscust").value=$G("oldiscust").value;
	   },function(){
			return false;
	   });
		//if(!confirm("<%=SystemEnv.getHtmlLabelName(18685,user.getLanguage())%>")){
        //    $G("iscust").value=$G("oldiscust").value;
        //}
	}
}
/*
function onchangeformid(objval){
    var oldisbillval=$G("oldisbill").value;
    var isbillval=$G("isbill").value;
	if(oldisbillval!=3 && objval!=$G("oldformid").value){
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(18683, user.getLanguage())%>",function(){
			$G("formid").value=$G("oldformid").value;
		},function(){
			return false;
		});
		//if(!confirm("<%=SystemEnv.getHtmlLabelName(18683,user.getLanguage())%>")){
        //    $G("formid").value=$G("oldformid").value;
        //}
	}
}
*/
function onchangebillid(objval){
    var oldisbillval=$G("oldisbill").value;
    var isbillval=$G("isbill").value;
	if(oldisbillval!=3 && objval!=$G("oldformid").value){
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(18684, user.getLanguage())%>",function(){
			$G("formid").value=$G("oldformid").value;
		},function(){
			return false;
		});
		//if(!confirm("<%=SystemEnv.getHtmlLabelName(18684,user.getLanguage())%>")){
        //    $G("billid").value=$G("oldformid").value;
        //}
	}
}

//modify by xhheng @20050204 for TD 1538
function submitData(obj){
	if (check_form($G("weaver"),'wfname,subcompanyid')){
		$G("weaver").submit();
        obj.disabled=true;
    }
}

function switchCataLogType(objval){
	objval=document.weaver.catalogtype.value;
    if(objval == 0){
		$("#selectcatalog").next().hide().find("div").hide();
        document.all("mypath").style.display = '';
    }else{
    	$("#selectcatalog").next().show().find("div").show();
        document.all("mypath").style.display = 'none';
    }
}


function onShowWfCatalog(spanName) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp");
    result = json2Array(result);
    if (result != null) {
        if (result[0] > 0)  {
            spanName.innerHTML=result[2];
            $G("wfdocpath").value=result[3]+","+result[4]+","+result[1];
        }
        else{
            spanName.innerHTML="";
            $G("wfdocpath").value="";
            }
    }
}
function onShowDocCatalog(spanName) {
    //var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp");
    var urls= "/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp";
    var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	//dialog.callbackfunParam = {id:"test", name:"testname"};
	dialog.URL = urls;
	dialog.callbackfun = function (paramobj, datas) {
		var result = json2Array(datas);
		if (result != null) {
	        if (result[0] > 0)  {
	            spanName.innerHTML="<a href='#'>" +result[2]+"</a>";
	            $G("newdocpath").value=result[3]+","+result[4]+","+result[1];
	        }
	        else{
	            spanName.innerHTML="";
	            $G("newdocpath").value="";
	            }
	    }
	} ;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(125058, user.getLanguage())%>";
	dialog.Width = 550 ;
	dialog.Height = 550 ;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.show();
}

function onShowWorkflow(inputname,spanname){
	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser_frm.jsp?isTemplate=1");
	//datas = json2Array(datas);
	if(datas){
	    if(datas.id!="") {
			$G(spanname).innerTML = datas.name;
			$G(inputname).value = datas.id;
	        $G("addwf0div").style.display="none";
	        $G("addwf1div").style.display="none";
	    }else{
	    	$G(spanname).innerHTML = "";
	    	$G(inputname).value="";
	    	$G("addwf0div").style.display="";
	    	$G("addwf1div").style.display="";
	   }
	}
}

function showDoc(){
	datas = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp");
	//datas = json2Array(datas);
	if(datas){
		weaver.helpdocid.value=datas.id+"";
		$("#Documentname").html("<a href='/docs/docs/DocDsp.jsp?id="+datas.id+"'>"+datas.name+"</a>");
	}
}

function onShowSubcompany(){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowManage:All&isedit=1&selectedids="+weaver.subcompanyid.value);
	//datas = json2Array(datas);
	issame = false;
	if (datas){
	if(datas.id!="0"&&datas.id!=""){
		if(datas.id == weaver.subcompanyid.value){
			issame = true;
		}
		$(subcompanyspan).html(datas.name);  //ypc 2012-09-24
		$GetEle("subcompanyid").value=datas.id;  //ypc 2012-09-24
	}
	else{
		$GetEle("subcompanyspan").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" ;//ypc 2012-09-24
		$GetEle("subcompanyid").value = "" ; //ypc 2012-09-24
	}
	}
} 
</script>
<%}else {%>
<script type="text/javascript">
function showDoc(){
	datas = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	if(datas){
		$("input[name=helpdocid]").val(datas.id);
		$("#Documentname").html("<a href='/docs/docs/DocDsp.jsp?id="+datas.id+"'>"+datas.name+"</a>");
	}
}

function onShowDocCatalog(spanName) {
    //var datas = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
    var urls= "/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp";
    var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	//dialog.callbackfunParam = {id:"test", name:"testname"};
	dialog.URL = urls;
	dialog.callbackfun = function (paramobj, datas) {
		if (datas) {
	        if (datas.tag > 0)  {
	            $("#"+spanName).html("<a href='#"+datas.id+"'>"+datas.path+"</a>");
	            $GetEle("newdocpath").value=datas.mainid+","+datas.subid+","+datas.id;
	        }
	        else{
	        	$(spanName).html("");
	            $GetEle("newdocpath").value="";
	            }
	    }
	} ;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(125058, user.getLanguage())%>";
	dialog.Width = 550 ;
	dialog.Height = 550 ;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.show();
}

function showNoSynFields(inputname, spanname){
	var oldfields = $GetEle(inputname).value;
	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+escape("/workflow/workflow/fieldMutilBrowser.jsp?workflowid=<%=wfid%>&oldfields="+oldfields));
	if(datas != null){
		if(datas[0]!=null && datas[0]!=""){
			$GetEle(inputname).value = datas[0];
			$GetEle(spanname).innerHTML = "<a href='#"+datas[0]+"'>"+datas[1]+"</a>";
		}else{
			$GetEle(inputname).value = "";
			$GetEle(spanname).innerHTML = "";
		}
	}
}

function onShowCatalog(spanName) {
    //var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	var urls = "/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp";
    var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	//dialog.callbackfunParam = {id:"test", name:"testname"};
	dialog.URL = urls;
	dialog.callbackfun = function (paramobj, result) {
		if (result) {
	        if (result.tag>0)  {
	           $G(spanName).innerHTML = "<a href='#"+result.id+"'>"+result.path+"</a>";
	           $G("pathcategory").value = result.path;
	           $G("maincategory").value=result.mainid;
	           $G("subcategory").value=result.subid;
	           $G("seccategory").value=result.id;
	        }else{
	           $G(spanName).innerHTML = "";
	           $G("pathcategory").value="";
	           $G("maincategory").value="";
	           $G("subcategory").value="";
	           $G("seccategory").value="";
	        }
	    }
	} ;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(125058,user.getLanguage()) %>";
	dialog.Width = 550 ;
	dialog.Height = 550 ;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.show();
}

function showFieldNotImport(inputname, spanname){
	var oldfields = $GetEle(inputname).value;
	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=" + escape("/workflow/workflow/browserFieldMutil.jsp?workflowid=<%=wfid %>&oldfields=" + oldfields));
	if(datas != null) {
		if(datas[0] != null && datas[0] != "") {
			$GetEle(inputname).value = datas[0];
			var data0Arr = datas[0].split(",");
			var data1Arr = datas[1].split(",");
			$GetEle(spanname).innerHTML = "";
			for(var i = 0; i < data0Arr.length; i++) {
				$GetEle(spanname).innerHTML += "<a href='#" + data0Arr[i] + "'>" + data1Arr[i] + "</a>";
			}			
		}else {
			$GetEle(inputname).value = "";
			$GetEle(spanname).innerHTML = "";
		}
	}
}

function onShowCatalogData(event,datas,name,paras){
	var ids = datas.id;
	var idarr= new Array();
	idarr=ids.split(","); 
	$G("pathcategory").value = datas.name;
   	$G("maincategory").value=datas.mainid;
    $G("subcategory").value=datas.subid;
    $G("seccategory").value=datas.id;
}
/*
function  _userBeforeDelCallback(text,name){
	if(name=="formid"){
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(18683, user.getLanguage())%>",function(){
			$G("formid").value=$G("oldformid").value;
		},function(){
			return false;
		});
		//if(!confirm("<%=SystemEnv.getHtmlLabelName(18683,user.getLanguage())%>")){
	    //       $G("formid").value=$G("oldformid").value;	          
	    //       return false;
	    //}
	}
	 return true;
}
*/
function submitData(obj){
	try{
		var _isFree = jQuery("input[name='isFree']").attr("checked")?"1":"";
		if(_isFree=="1"){
	        var _isbills=document.weaver.isbill.value;
	        if(_isbills=="4"){
	            //新建时不允许同时选择【自定义表单-费用类流程】和【自由流程】！
	        	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128755, user.getLanguage())%>");
				return;
	        }
		}
	}catch(e){}
try{
	if(!checkLengtpointerCut("wfdes",'200',"<%=SystemEnv.getHtmlLabelName(15594, user.getLanguage())%>",'<%=SystemEnv.getHtmlLabelName(20246, user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247, user.getLanguage())%>')){
		return;
		}
}catch(e){}
	var multiSubmit = jQuery('#multiSubmit').is(":checked");
	var checkFields = 'wfname,subcompanyid';
	if(multiSubmit){
		var submittype = jQuery('#submittype').val();
		if(submittype == 1)
			checkFields += ",submitnode";
		if(submittype == 2)
			checkFields += ",submitnode2";
	}
    if (check_form(weaver,checkFields)) {
        obj.disabled=true;
        var isbills=document.weaver.isbill.value;
        var iscust=document.weaver.iscust.value;
        var oldiscust=document.weaver.oldiscust.value;
		if(isbills == "1"){
			var billid_t = "";
			var formid_t = $G("formid").value;
			if(billid_t == ""){
				if (formid_t == ""){
					if (formid_t > 0 && billid_t == ""){
					} else {
						alert("<%=SystemEnv.getHtmlLabelName(27615,user.getLanguage())%>");
						obj.disabled=false;
						return;
					}							
				}
			}
		}else if(isbills == "0"){
			var formid_t = $G("formid").value;
			if(formid_t == ""){
				alert("<%=SystemEnv.getHtmlLabelName(27616,user.getLanguage())%>");
				obj.disabled=false;
				return;
			}
		}else if(isbills == "4"){
		}else{
			if($("[name='templateid']").val()==""){
				alert("<%=SystemEnv.getHtmlLabelName(27617,user.getLanguage())%>");
				obj.disabled=false;
				return ;
			}
		}     
        weaver.submit();
        //refreshAddwf("<%=wfid%>");
   }
}

function refreshAddwf(wfid1){
	var isbill1 = "";
	try{
		isbill1 = document.weaver.isbill.value;
	}catch(e){
		isbill1 = "";
	}
	if(isbill1 != ""){
		try{
			parent.parent.location.href = "addwf.jsp?ajax=1&src=editwf&wfid="+wfid1+"&isTemplate=<%=isTemplate%>";
		}catch(e){parent.parent.location.href = "addwf.jsp?ajax=1&src=editwf&wfid="+wfid1+"&isTemplate=<%=isTemplate%>";} // update by liaodong for qc52610 in 20130922
		
	}else{
		window.setTimeout(function(){refreshAddwf(wfid1);},100);
	}
}

function fnaWfType1_onchange(){
	var fnaWfType1 = jQuery("#fnaWfType1").val();
	if(fnaWfType1=="4" || fnaWfType1=="5" || fnaWfType1=="7" || fnaWfType1=="8" || fnaWfType1=="9" || fnaWfType1=="10"){
		jQuery("#showFormSpan_fnaWfType2").hide();
	}else{
		jQuery("#showFormSpan_fnaWfType2").show();
	}
}

function onchangeisbill(objval){
    var oldval=document.weaver.oldisbill.value;
    <%if (isnewform) {%>
    	oldval = 0;//新表单


    <%}%>
    if(true){
        top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(18682, user.getLanguage())%>",function(){
			document.weaver.isbill.value=objval;
			objval=$GetEle("isbill").value;

			jQuery("#showFormSpan_fnaWfType").hide();
			jQuery("#showFormSpan").hide();
			fnaWfType1_onchange();
			if(objval==4){//自定义表单-费用类流程
				jQuery("#showFormSpan_fnaWfType").show();
			}else if(objval==0){
				jQuery("#showFormSpan").show();
				$("#showFormSpan").show();
				$("#formid").value = "";
				$("#formidspan").html("");
		        $G("isaffirmance").disabled=false;
		        $G("isShowChart").disabled=false;
		        $G("isImportDetail").value = 1;
		        //jQuery("#isImportDetail").attr("tzCheckbox","true");
		        //jQuery("#isImportDetail_fake").attr("tzCheckbox","false");
		        //$G("isImportDetail").style.display = '';
		        //$G("isImportDetail_fake").style.display = 'none';
		        disOrEnableSwitch("#isImportDetail", false);
			}else{
				jQuery("#showFormSpan").show();
		        if(objval==1){
		        	$("#showFormSpan").show();
					$("#formid").value = "";
					$("#formidspan").html("");
		            var endaffirmances=$GetEle("endaffirmances").value;
		            var endShowCharts=$GetEle("endShowCharts").value;
		            if(endaffirmances.indexOf(","+$G("formid").value+",")>-1){
		                $GetEle("isaffirmance").checked=false;
		                $GetEle("isaffirmance").disabled=true;
		            }else{
		                $GetEle("isaffirmance").disabled=false;
		            }
		            if(endShowCharts.indexOf(","+$G("formid").value+",")>-1){
		                $GetEle("isShowChart").checked=false;
		                $GetEle("isShowChart").disabled=true;
		            }else{
		                $GetEle("isShowChart").disabled=false;
		            }
		            $G("isImportDetail").value = 0;  
		            //jQuery("#isImportDetail").attr("tzCheckbox","false");
		            //jQuery("#isImportDetail_fake").attr("tzCheckbox","true");
		            //$G("isImportDetail").style.display = 'none';
		            //$G("isImportDetail_fake").style.display = '';
		            disOrEnableSwitch("#isImportDetail", true);
		        	changeSwitchStatus("#isImportDetail", false); 
		        }else{
		        	$("#showFormSpan").hide();
		            $G("isaffirmance").disabled=false;
		            $G("isShowChart").disabled=false;
					
		            $G("isImportDetail").value = 1;
		            //jQuery("#isImportDetail").attr("tzCheckbox","true");
		            //jQuery("#isImportDetail_fake").attr("tzCheckbox","false");
		            //$G("isImportDetail").style.display = '';
		            //$G("isImportDetail_fake").style.display = 'none';
		            disOrEnableSwitch("#isImportDetail", false); 
		        }
		    }
		    isImportDetailChanged();
		},function(){
			document.weaver.isbill.value=oldval;
			$("[name=isbill]").selectbox("detach");
			jsSelectItemByValue($G("isbill"),oldval);
			$("[name=isbill]").selectbox();
			return false;
		});
    }
}
function jsSelectItemByValue(objSelect,objItemText) {  
     for(var i=0;i<objSelect.options.length;i++) {  
           if(objSelect.options[i].value == objItemText) {  
                objSelect.options[i].selected = true;  
                break;  
           }  
     }  
}  

function onchangeiscust(objval){
    var srctype=document.weaver.src.value;
	if(srctype=="editwf"&&objval<document.weaver.oldiscust.value){
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(18685, user.getLanguage())%>",function(){
			document.weaver.iscust.value=document.weaver.oldiscust.value;
		},function(){
			return false;
		});
	}
}

function switchCataLogType(objval){
	objval=document.weaver.catalogtype.value;
    if(objval == 0){
		$("#selectcatalog").next().hide().find("div").hide();
        document.all("mypath").style.display = '';
    }else{
    	$("#selectcatalog").next().show().find("div").show();
        document.all("mypath").style.display = 'none';
    }
}
</script>
<%} %>

<script type="text/javascript">

$(document).ready(function(){
  <%if(!isrejectremind.equals("1")){%>
        $("#ischangrejectnode").attr("disabled","disabled");
  <%}%>
  <%if(!chatsType.equals("1")){%>
  		hideEle("chatsType");
  <%}%>
    switchCataLogType();
});
function onShowDepartment(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+jQuery("#fnadepartmentid").val());    
    if (data!=null){
		if (data.id != "" ){
			ids = data.id.split(",");
			names =data.name.split(",");
			sHtml = "";
			for( var i=0;i<ids.length;i++){
				if(ids[i]!=""){
					sHtml = sHtml+names[i]+"&nbsp;&nbsp;";
				}
			}
			jQuery("#fnadepartmentspan").html(sHtml);
			jQuery("input[name=fnadepartmentid]").val(data.id.substr(1));
		}else{
			jQuery("#fnadepartmentspan").html("");
			jQuery("input[name=fnadepartmentid]").val("");
		}
	}
}

function onShowFnaNodes(inputName,spanName,workflowId){
	printNodes=inputName.value;
    tempUrl=escape("/workflow/workflow/WorkflowNodeBrowserMulti.jsp?printNodes="+printNodes+"&workflowId="+workflowId);
    var result =window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+tempUrl,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");

    if (result != null){
		if (result.id!=""){  
		    inputName.value=result.id;
		    spanName.innerHTML=result.name;
		}else{
		    inputName.value="0";
		    spanName.innerHTML="";
		}
    }
}
 
function ShowFnaHidden(obj,tr1name,tr2name){
    if(obj.checked){
        showEle(tr1name);
        showEle(tr2name);
    }else{
        hideEle(tr1name);
        hideEle(tr2name);
    }
}

var diag_saveaswf = null;
function Savetemplate(workflowids){
	window.location.href ="/workflow/workflow/addwf0.jsp?isTemplate=1&isSaveas=1&ajax=1&templateid="+workflowids;
}
function copytemplate(obj){
	if(check_form(weaver,'wfname,subcompanyid')) {
		weaver.submit();
		obj.disabled=true;
		try{
        	parent.parent.parent.wfleftFrame.location="/workflow/workflow/wfmanage_left2.jsp?isTemplate=<%=isTemplate%>";
		}catch(e){} 
   	}
}
function exportWorkflow(workflowid){
	var xmlHttp = ajaxinit();
	xmlHttp.open("post","/workflow/export/wf_operationxml.jsp", true);
	var postStr = "src=export&wfid="+workflowid;
	xmlHttp.onreadystatechange = function () 
	{
		switch (xmlHttp.readyState) 
		{
		   case 4 : 
		   		if (xmlHttp.status==200)
		   		{
		   			var downxml = xmlHttp.responseText.replace(/(^\s*)|(\s*$)/g, "");
		   			window.open(downxml,"_self");
		   		}
			    break;
		} 
	}
	xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded;");
	xmlHttp.send(postStr);
}

function doShowBaseData(wfid_){
	openFullWindow("/system/basedata/basedata_workflow.jsp?wfid="+wfid_);
}

function ShowORHidden(obj,trnames,tabobj){
	var tr_names=trnames.split(',');
	for(var i=0;i<tr_names.length;i++){
	    if(obj.checked){
	    	showEle(tr_names[i]);
	    }else{
	    	hideEle(tr_names[i]);
	    }
    }
    if(tabobj!=''){
   		tabobj.checked=obj.checked;
   	}
}

function wfTitleSet(){
	diag_saveaswf = new window.top.Dialog();
	diag_saveaswf.currentWindow = window;
	diag_saveaswf.Width = 700;
	diag_saveaswf.Height = 410;
	diag_saveaswf.Modal = true;
	diag_saveaswf.Title = "<%=SystemEnv.getHtmlLabelName(19501, user.getLanguage())%>"; 
	diag_saveaswf.URL = "/workflow/workflow/WFTitleSet.jsp?isdialog=1&ajax=1&wfid=<%=wfid%>";
	diag_saveaswf.show();
}
function cancelsaveAsWorkflow(){ 
	diag_saveaswf.close();
}
function showtitle(evt){   
	if($.browser.msie){
		
		jQuery(".vtip").attr("title","");
		obj = evt.srcElement
		if(obj.selectedIndex!=-1){   
			
			if(obj.options[obj.selectedIndex].text.length > 2){  					
				$("#simpleTooltip").remove();					
				var  tipX;
				var  tipY;
				tipX=evt.clientX+document.body.scrollLeft+6;
				tipY=evt.clientY+document.body.scrollTop+6;		
				$("body").append("<div id='simpleTooltip' style='position: absolute; z-index: 100; display: none;'>" + obj.options[obj.selectedIndex].text + "</div>");
				var tipWidth = $("#simpleTooltip").outerWidth(true)
				$("#simpleTooltip").width(tipWidth);
				$("#simpleTooltip").css("left", tipX).css("top", tipY).fadeIn("medium");
			}
			
		}
		
		jQuery(obj).bind("mouseout",function(){
			
			$("#simpleTooltip").remove();		
		})
	}else{
		jQuery(".vtip").simpletooltip("click");
	}
}

function addSrcToDestListTit() {
	destList = window.document.flowTitleForm.destList;
	srcList = window.document.flowTitleForm.srcList;
	var len = destList.length;
	for ( var i = 0; i < srcList.length; i++) {
		if ((srcList.options[i] != null) && (srcList.options[i].selected)) {
			var found = false;
			for ( var count = 0; count < len; count++) {
				if (destList.options[count] != null) {
					if (srcList.options[i].text == destList.options[count].text) {
						found = true;
						break;
					}
				}
			}
			if (found != true) {
				destList.options[len] = new Option(srcList.options[i].text,
						srcList.options[i].value);
				len++;
			}
		}
	}
	jQuery(".vtip").simpletooltip("click");
       if($.browser.msie){
   		jQuery(".vtip").attr("title","");
   	}
}

function deleteFromDestListTit() {
	var destList = window.document.flowTitleForm.destList;
	var len = destList.options.length;
	for ( var i = (len - 1); i >= 0; i--) {
		if ((destList.options[i] != null)
				&& (destList.options[i].selected == true)) {
			destList.options[i] = null;
		}
	}
}

function changeOrderShow(){
	var orderbytype = $G("orderbytype").value;
	if(orderbytype == 1){
		$G("orderShowSpan").innerHTML="<%=SystemEnv.getHtmlLabelName(21629,user.getLanguage())%>";
	}else{
		$G("orderShowSpan").innerHTML="<%=SystemEnv.getHtmlLabelName(21628,user.getLanguage())%>";
	}
}

function rejectremindChange(obj,tdname){
	var tzCheckBox = $("input[name='"+tdname+"']").next(".tzCheckBox");
    if(obj.checked){
        $G(tdname).disabled=false;
        tzCheckBox.attr("disabled",false);
    }else{
        $G(tdname).checked=false;
        $G(tdname).disabled=true;
        var isChecked = tzCheckBox.hasClass("checked");
        if(isChecked){
        	tzCheckBox.toggleClass("checked");
        }
        tzCheckBox.attr("disabled",true);
    }
}

function onShowAnnexCatalog(spanName) {
    //var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
    var urls = "/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp";
    var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = urls;
	dialog.callbackfun = function (paramobj, result) {
	    if (result) {
	        if (result.tag>0)  {
	            $('[name='+spanName+']').html("<a href='#"+result.id+"'>"+result.path+"</a>");
	            $("#annexmaincategory").val(result.mainid);
	            $("#annexsubcategory").val(result.subid);
	            $("#annexseccategory").val(result.id);
	        }else{ //<!--added xwj for td2048 on 2005-6-1 begin -->
	            spanName.innerHTML="";
	            $("#annexmaincategory").val("");
	            $("#annexsubcategory").val("");
	            $("#annexseccategory").val("");
	        }

	        //<!--added xwj for td2048 on 2005-6-1 end -->
	    }
	} ;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(125058, user.getLanguage())%>";
	dialog.Width = 550 ;
	dialog.Height = 550 ;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.show();
}

function annexseccategoryData(event,datas,name,paras){
	var ids = datas.id;
	var idarr= new Array();
	try{
		if(ids.indexOf(",")!=-1){
			idarr=ids.split(","); 
		    $("#annexmaincategory").val(idarr[0]);
		    $("#annexsubcategory").val(idarr[1]);
		    $("#annexseccategory").val(idarr[2]);
		}else{
			$("#annexmaincategory").val(datas.mainid);
		    $("#annexsubcategory").val(datas.subid);
		    $("#annexseccategory").val(datas.id);
		}
	 }catch(e){
	 	
	 }
}
function json2Array(josinobj) {
	if (josinobj == undefined || josinobj == null) {
		return null;
	}
	var ary = new Array();
	var _index = 0;
	try {
		for(var key in josinobj){
			ary[_index++] = josinobj[key];
		}
	} catch (e) {}
	return ary;
}

function getformajaxurl(){
	var isbill = $("select[name=isbill]").val();
	return url = "/data.jsp?type=wfFormBrowser&isbill="+isbill;
}

function onShowFormSelect(){
	var isbillValue = $("select[name=isbill]").val();
	var url ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/wfFormBrowser.jsp?isbill="+isbillValue;
	return url;
}

function formSelectCallback(event,datas,name,_callbackParams){
	var isbill = $("select[name=isbill]").val();
	var endaffirmances,endShowCharts,affpos,showpos;
	endaffirmances=$("#endaffirmances").val();
	endShowCharts=$("#endShowCharts").val();

	if (datas){
	    if(datas.id!=""){
	        if( isbill==1){
	        	affpos=endaffirmances.indexOf(","+datas.id+",");
	        
		        if (affpos>0){
			        $GetEle("isaffirmance").checked=false
			        $GetEle("isaffirmance").disabled=true
		        }else{
		        	$GetEle("isaffirmance").disabled=false
		        }
	       		showpos=endShowCharts.indexOf(","+datas.id+",");
		        if(showpos>0){
			        $GetEle("isShowChart").checked=false
			        $GetEle("isShowChart").disabled=true
		        }
		        else{
		        	$GetEle("isShowChart").disabled=false
		        }
	        }
	        var oldisbillval=$G("oldisbill").value;
			if(oldisbillval!=3 && datas.id!=$G("oldformid").value){
				//top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(18683, user.getLanguage())%>",function(){
				//	$G("formid").value=$G("oldformid").value;
				//},function(){
				//	return false;
				//});
				//if(!confirm("<%=SystemEnv.getHtmlLabelName(18683,user.getLanguage())%>")){
		        //    $G("formid").value=$G("oldformid").value;
		        //}
			}
	    }
	} else{
		    inputName.value=""
	        $GetEle("isaffirmance").disabled=false
	        $GetEle("isShowChart").disabled=false
	}
}
function toMiaoji(name){
	var href = "";
	if(name=="<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>"){
		href="#basicA";
	}else if(name=="<%=SystemEnv.getHtmlLabelName(21946, user.getLanguage())%>"){
		href="#messageB";
	}else if(name=="<%=SystemEnv.getHtmlLabelName(23796, user.getLanguage())%>"){
		href="#FUJIAN";
	}else if(name=="<%=SystemEnv.getHtmlLabelName(32383, user.getLanguage())%>"){
		href="#corC";
	}else if(name=="<%=SystemEnv.getHtmlLabelName(84508, user.getLanguage())%>"){
		href="#TUIHUI";
	}else if(name=="<%=SystemEnv.getHtmlLabelName(17614, user.getLanguage())%>"){
		href="#QIANZI";
	}else if(name=='<%=SystemEnv.getHtmlLabelName(32825, user.getLanguage())%>'){
    href='#freeWorkflow';
  }
	$("#miaoji").attr("href",href);
	miaoji.click();
}

function toformtab(){
	window.parent.location = "/workflow/form/addform.jsp?ajax=1&isformadd=1";
}

function totitletab(){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 900;
	diag_vote.Height = 650;
	diag_vote.Modal = true;
	diag_vote.maxiumnable = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(31844,user.getLanguage())%>";
	diag_vote.URL = "/workflow/workflow/WFTitleCode.jsp?workflowid=<%=wfid%>";
	diag_vote.show();
}

var diag_saveaswf = null;
/**
 * 存为新版
 */
function saveAsWorkflow(wfid) {
	var flashs = new Array(); 
	var flashobj = jQuery("#wfdesign")[0];
	if (!!jQuery("#wfdesign")[0]) {
		flashobj = jQuery("#wfdesign")[0].contentWindow.document.getElementById("container");
	}
	if (!!flashobj) {
		flashs[0] = flashobj;
	}
    if (!!window.top.Dialog) {
	   diag_saveaswf = new window.top.Dialog();
	} else {
	   diag_saveaswf = new Dialog();
	}
	diag_saveaswf.currentWindow = window;
	diag_saveaswf.flashs = flashs;
	diag_saveaswf.Width = 376;
	diag_saveaswf.Height = 182;
	diag_saveaswf.Modal = true;
	diag_saveaswf.Title = "<%=SystemEnv.getHtmlLabelName(129416, user.getLanguage())%>"; 
	diag_saveaswf.URL = "/workflow/workflow/addVersion.jsp?targetwfid=" + wfid + "&date=" + new Date().getTime();
	diag_saveaswf.show();
}

function _userDelCallback(text,name){
	if(name=="pathcategory"){
		$G("pathcategory").value="";
	   	$G("maincategory").value="";
	    $G("subcategory").value="";
	    $G("seccategory").value="";	
	}else if(name=="annexseccategory"){
		$("#annexmaincategory").val("");
        $("#annexsubcategory").val("");
        $("#annexseccategory").val("");
	}else if(name=="newdocpath"){
		$G("newdocpath").value="";
	}
}
jQuery(document).ready(function(){
	jQuery(".e8tips").wTooltip({html:true});

  jQuery(".setting").hover(function(){
    $(this).attr("src","/images/homepage/style/settingOver_wev8.png")
  },function(){
    $(this).attr("src","/images/homepage/style/setting_wev8.png")
  });
  importDetailTypeChanged();
});

function onLog(wfid){
	dialog=new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Model=true;
	dialog.Width=1000;
	dialog.Height=600;
	dialog.URL="/workflow/workflow/WFLog.jsp?wfid="+wfid;
	dialog.Title="<%=SystemEnv.getHtmlLabelName(17480,user.getLanguage()) %>";
	dialog.show();
}

function isImportDetailChanged() {
	if (jQuery('#isImportDetail').is(':checked')) {
		jQuery('#importDetailType').selectbox('show');
	} else {
		jQuery('#importDetailType').selectbox('hide');
	}
}

function importDetailTypeChanged() {
	jQuery('#isImportDetail').val(jQuery('#importDetailType').find('option:selected').val());
}

function isimportwfClicked(obj) {
	if(obj.checked) {
		jQuery("#importReadOnlyFieldSpan").show();
	}else {
		jQuery("#importReadOnlyFieldSpan").hide();
	}
}

function docheckisvalid(obj){
	var isvalid = jQuery("#isvalid").val();
	var oldisvalid = jQuery("#oldisvalid").val();
	if(isvalid == "1"){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(28058,user.getLanguage())%>");
		jQuery("#isvalid").selectbox("detach");
		jQuery("#isvalid").val(oldisvalid);
		jQuery("#isvalid").selectbox("attach");
	}
	
}

function nodeopadd(formid,nodeid,isbill,iscust){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/workflow/workflow/operatorgroupContent.jsp?ajax=1&wfid=<%=wfid%>&nodeid="+nodeid+"&formid="+formid+"&isbill="+isbill+"&iscust="+iscust;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) + SystemEnv.getHtmlLabelName(15072,user.getLanguage()) %>";
	dialog.Width = 1020;
	dialog.Height = 580;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

function nodeopedit(formid,nodeid,id,isbill,iscust){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/workflow/workflow/operatorgroupContent.jsp?ajax=1&wfid=<%=wfid%>&nodeid="+nodeid+"&formid="+formid+"&isbill="+isbill+"&iscust="+iscust+"&id="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) + SystemEnv.getHtmlLabelName(15072,user.getLanguage()) %>";
	dialog.Width = 1020;
	dialog.Height = 600;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}
function wchatStateChange(obj){
   if(jQuery(obj).is(":checked")){
   		showEle("chatsType");
   		showEle("notRemind");	
   }else{
   		hideEle("chatsType");
   		hideEle("notRemind");
   }
}
function ShowOrHiddenLable(obj,spanid){
	var isAutoApprove = jQuery(obj).val();
	if(isAutoApprove == 0){
		jQuery("#"+spanid).hide();
		jQuery("#isAutoRemarkdiv").hide();
	}else{
		jQuery("#"+spanid).show();
		jQuery("#isAutoRemarkdiv").show();
		//if(jQuery('#isAutoCommit').attr('checked')){
		//	jQuery('#isAutoCommit').attr('checked',false);
		//}
	}
}

function clickMultisubmit() {
	if (jQuery('#multiSubmit').is(':checked')) {
		jQuery('#multiSubmitSpan').show();
	} else {
		jQuery('#multiSubmitSpan').hide();
	}
}

function getShowNodesUrl1() {
	var wfid = "<%=wfid%>";
	if(wfid == 0)
		wfid = -1;
	var selectids = $G("submitnode").value;
	if(selectids == ""){
		selectids = "0";		
	}
	var urls="/workflow/workflow/WfnodeBrow.jsp?wfid="+wfid+"&selectedids="+selectids;
	urls="/systeminfo/BrowserMain.jsp?url="+urls
	return urls;
}

function getShowNodesUrl2() {
	var wfid = "<%=wfid%>";
	if(wfid == 0)
		wfid = -1;
	var selectids = $G("submitnode2").value;
	if(selectids == ""){
		selectids = "0";		
	}
	var urls="/workflow/workflow/WfnodeBrow.jsp?wfid="+wfid+"&selectedids="+selectids;
	urls="/systeminfo/BrowserMain.jsp?url="+urls
	return urls;
}

function typeChange(obj){
	var type = obj.value;
	if(type == 0){
		jQuery('#submitNode_Span').hide();
		jQuery('#submitNode_Span2').hide();
	}else if(type == 1){
		jQuery('#submitNode_Span').show();
		jQuery('#submitNode_Span2').hide();
	}else if(type == 2){
		jQuery('#submitNode_Span').hide();
		jQuery('#submitNode_Span2').show();
	}
}


jQuery(function(){
     <%if(!chatsType.equals("1")){%>
     	hideEle("notRemind");
     <%}%>
     
});
</script>
