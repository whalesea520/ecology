/**
  @author lsj 2014/1/13
**/

//日期设置
function changeDate(obj,id,val){
	if(val==null)val='6';
	if(obj.value==val){
		jQuery("#"+id).show();
	}else{
		jQuery("#"+id).hide();
		jQuery("#"+id).siblings("input[type='hidden']").val("");
	}
}


//创建人,未操作者
function onShowResource(creatertype,creatername,createrid) {
	var tmpval = $GetEle(creatertype).value;
	var id = null;
	if (tmpval == "0") {
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
	}else {
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
	}
	if (id != null) {
        if (wuiUtil.getJsonValueByIndex(id, 0) != "" && wuiUtil.getJsonValueByIndex(id, 0) != "0") {
			$GetEle(creatername).value = wuiUtil.getJsonValueByIndex(id, 1);
			$GetEle(createrid).value=wuiUtil.getJsonValueByIndex(id, 0);
        }else
	    {
        	$GetEle(creatername).value = "";
			$GetEle(createrid).value="";
	    }
	}

}

//流程代理  被代理
function onShowSysUsers(creatername,createrid) {
	
	var id = null;
    
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
    
	if (id != null) {
        if (wuiUtil.getJsonValueByIndex(id, 0) != "" && wuiUtil.getJsonValueByIndex(id, 0) != "0") {
			$GetEle(creatername).value = wuiUtil.getJsonValueByIndex(id, 1);
			$GetEle(createrid).value=wuiUtil.getJsonValueByIndex(id, 0);
        }else
	    {
        	$GetEle(creatername).value = "";
			$GetEle(createrid).value="";
	    }
	}

}


//条件设置(input)
function  showAdvanceConditionSetForInput(url,inputitem,hideitem)
{

   var results = window.showModalDialog(url+"?selectedids="+$GetEle(hideitem).value);
   if(results){
	  if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	     $GetEle(inputitem).value=wuiUtil.getJsonValueByIndex(results,1);
         $GetEle(hideitem).value=wuiUtil.getJsonValueByIndex(results,0);
	  }else{
	     $GetEle(inputitem).value="";
         $GetEle(hideitem).value="";
	  }
	}

}


//创建人部门
function onShowDept(depfield,depfieldid){

	showAdvanceConditionSetForInput("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp",depfield,depfieldid);
}
//创建人分部
function onShowSubcompany(depbranchfield,depbranchfieldid){
	showAdvanceConditionSetForInput("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp",depbranchfield,depbranchfieldid);
}
//未操作者
function onShowUnOpHrms(unopname,unopids){
	showAdvanceConditionSetForInput("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp",unopname,unopids);
}

//条件设置(span)
function  showAdvanceConditionSetForSpan(url,spanitem,hidenameitem,hideiditem)
{

   var results = window.showModalDialog(url+"?selectedids="+$GetEle(hideiditem).value);
   if(results){
	  if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	     $GetEle(spanitem).innerHTML=wuiUtil.getJsonValueByIndex(results,1);
         $GetEle(hidenameitem).value=wuiUtil.getJsonValueByIndex(results,1);
         $GetEle(hideiditem).value=wuiUtil.getJsonValueByIndex(results,0);
	  }else{
	     $GetEle(spanitem).innerHTML="";
         $GetEle(hidenameitem).value="";
		 $GetEle(hideiditem).value="";
	  }
	}

}





//相关文档
function onShowDocids(docspanname,docinputname,docids) {
	showAdvanceConditionSetForSpan("/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1",docspanname,docinputname, docids);
}
//人力资源
function onShowHrmids(hrmidsspanname,hrmidsinputname,hrmids) {
	showAdvanceConditionSetForSpan("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp",hrmidsspanname,hrmidsinputname, hrmids);
}
//相关客户
function onShowCrmids(crmspanname,crminputname,crmids) {
	showAdvanceConditionSetForSpan("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp",crmspanname,crminputname, crmids);
	
}
//相关项目
function onShowPrjids(prospanname,proinputname,proids) {
	showAdvanceConditionSetForSpan("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp",prospanname,proinputname, proids);
}

//重置表格
function  resetForm()
{
  $("input[name='requestname']").val("");
  $("input[name='workcode']").val("");
  $("select[name='requestlevel']").val("");

  //创建人
  $("select[name='creatertype']").val("0");
  $("input[name='creatername']").val("");
  $("input[name='createrid']").val("");
  
  //部门
  $("input[name='ownerdeptname']").val("");
  $("input[name='ownerdepartmentid']").val("");
  
  //分部
  $("input[name='creatersubcompanyname']").val("");
  $("input[name='creatersubcompanyid']").val("");

  //接收日期
  $("select[name='recievedateselect']").val("0");
  //创建日期
  $("select[name='createdateselect']").val("0");
   
  //流程状态
  $("select[name='wfstatu']").val("");
  //节点类型
  $("select[name='nodetype']").val("");
  //未操作者
  $("input[name='unophrmname']").val("");
 
  //相关文档
  $("input[name='docinputname']").val("");  
  $("#docname").html("");
  $("input[name='docids']").val("");  

  //相关人力
  $("input[name='hrmidsinput']").val("");  
  $("#hrmidsspan").html("");
  $("input[name='hrmids']").val("");  

  
  //相关客户
  $("input[name='crmnameinput']").val("");  
  $("#crmname").html("");
  $("input[name='crmids']").val("");  

  //相关项目
  $("input[name='pronameinput']").val("");  
  $("#proname").html("");
  $("input[name='proids']").val("");  

}


//重置代理设置表格
function  resetAgentForm()
{
  $("input[name='wftypename']").val("");
  $("input[name='wfname']").val("");
  $("select[name='agentlevel']").val("");

  //创建人
  $("select[name='creatertype']").val("0");
  $("input[name='creatername']").val("");
  $("input[name='createrid']").val("");
  
  //被代理人
  $("input[name='beagentname']").val("");
  $("input[name='beagentid']").val("");
  
  //被代理人部门
  $("input[name='beagentdeptname']").val("");
  $("input[name='beagentdepartmentid']").val("");

  //被代理人分部
  $("input[name='beagentsubcompanyname']").val("");
  $("input[name='beagentsubcompanyid']").val("");


 //代理人
  $("input[name='agentname']").val("");
  $("input[name='agentid']").val("");
  
  //代理人部门
  $("input[name='agentdeptname']").val("");
  $("input[name='agentdepartmentid']").val("");

  //代理人分部
  $("input[name='agentsubcompanyname']").val("");
  $("input[name='agentsubcompanyid']").val("");



  //代理开始日期
  $("select[name='agentdateselect']").val("0");
   //代理结束日期
  $("select[name='agentdateendselect']").val("0");
  //创建日期
  $("select[name='agentcreatedateselect']").val("0");
   
  //流程状态
  $("select[name='wfstatu']").val("");


}