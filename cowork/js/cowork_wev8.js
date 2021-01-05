function onShowDoc(inputname,spanname){
       var currentids=jQuery("#"+inputname).val();
       var id1 = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="+currentids);
       if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>500)
	          alert("您选择的文档数量太多，数据库将无法保存所有的文档，请重新选择！");
	       else if(ids.length>0){
	          var tempids=ids.split(",");
	          var tempnames=names.split(",");
	          var sHtml="";
	          for(var i=0;i<tempids.length;i++){
	              var tempid=tempids[i];
	              var tempname=tempnames[i];
	              if(tempid!='')
	                sHtml = sHtml+"<a href='javascript:void(0)' onclick=openFullWindowForXtable('/docs/docs/DocDsp.jsp?id="+tempid+"')>"+tempname+"</a>&nbsp";
	          }
	          ids=ids.substr(1,ids.length);
	          jQuery("#"+inputname).val(ids);
	          jQuery("#"+spanname).html(sHtml);
	       }else{
	          jQuery("#"+inputname).val("");
	          jQuery("#"+spanname).html("");
	       }
       }
}

function onShowTask(inputname,spanname){
       var currentids=jQuery("#"+inputname).val();
       var id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/MultiTaskBrowser.jsp?resourceids="+currentids);
       if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>500)
	          alert("您选择的任务数量太多，数据库将无法保存所有的任务，请重新选择！");
	       else if(ids.length>0){
	          var tempids=ids.split(",");
	          var tempnames=names.split(",");
	          var sHtml="";
	          for(var i=0;i<tempids.length;i++){
	              var tempid=tempids[i];
	              var tempname=tempnames[i];
	              if(tempid!='')
	                sHtml = sHtml+"<a href='javascript:void(0)' onclick=openFullWindowForXtable('/proj/process/ViewTask.jsp?taskrecordid="+tempid+"')>"+tempname+"</a>&nbsp";
	          }
	          ids=ids.substr(1,ids.length);
	          jQuery("#"+inputname).val(ids);
	          jQuery("#"+spanname).html(sHtml);
	       }else{
	          jQuery("#"+inputname).val("");
	          jQuery("#"+spanname).html("");
	       }
       }
}

function onShowCRM(inputname,spanname){
       var currentids=jQuery("#"+inputname).val();
       var id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="+currentids);
       if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>500)
	          alert("您选择的客户数量太多，数据库将无法保存所有的客户，请重新选择！");
	       else if(ids.length>0){
	          var tempids=ids.split(",");
	          var tempnames=names.split(",");
	          var sHtml="";
	          for(var i=0;i<tempids.length;i++){
	              var tempid=tempids[i];
	              var tempname=tempnames[i];
	              if(tempid!='')
	                sHtml = sHtml+"<a href='javascript:void(0)' onclick=openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?CustomerID="+tempid+"')>"+tempname+"</a>&nbsp";
	          }
	          ids=ids.substr(1,ids.length);
	          jQuery("#"+inputname).val(ids);
	          jQuery("#"+spanname).html(sHtml);
	       }else{
	          jQuery("#"+inputname).val("");
	          jQuery("#"+spanname).html("");
	       }
       }
}

function onShowMultiProjectCowork(inputname,spanname){
       var currentids=jQuery("#"+inputname).val();
       var id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp?projectids="+currentids);
       if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>500)
	          alert("您选择的项目数量太多，数据库将无法保存所有的项目，请重新选择！");
	       else if(ids.length>0){
	          var tempids=ids.split(",");
	          var tempnames=names.split(",");
	          var sHtml="";
	          for(var i=0;i<tempids.length;i++){
	              var tempid=tempids[i];
	              var tempname=tempnames[i];
	              if(tempid!='')
	                sHtml = sHtml+"<a href='javascript:void(0)' onclick=openFullWindowForXtable('/proj/data/ViewProject.jsp?ProjID="+tempid+"')>"+tempname+"</a>&nbsp";
	          }
	          ids=ids.substr(1,ids.length);
	          jQuery("#"+inputname).val(ids);
	          jQuery("#"+spanname).html(sHtml);
	       }else{
	          jQuery("#"+inputname).val("");
	          jQuery("#"+spanname).html("");
	       }
       }
}

function onShowRequest(inputname,spanname){
       var currentids=jQuery("#"+inputname).val();
       var id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp?resourceids="+currentids);
       if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>500)
	          alert("您选择的流程数量太多，数据库将无法保存所有的流程，请重新选择！");
	       else if(ids.length>0){
	          var tempids=ids.split(",");
	          var tempnames=names.split(",");
	          var sHtml="";
	          for(var i=0;i<tempids.length;i++){
	              var tempid=tempids[i];
	              var tempname=tempnames[i];
	              if(tempid!='')
	                sHtml = sHtml+"<a href='javascript:void(0)' onclick=openFullWindowForXtable('/workflow/request/ViewRequest.jsp?requestid="+tempid+"')>"+tempname+"</a>&nbsp";
	          }
	          ids=ids.substr(1,ids.length);
	          jQuery("#"+inputname).val(ids);
	          jQuery("#"+spanname).html(sHtml);
	       }else{
	          jQuery("#"+inputname).val("");
	          jQuery("#"+spanname).html("");
	       }
       }
}


function onShowResourceOnly(inputid,spanid,isNeed){
  var id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
  if(id1){
	  var id=id1.id;
	  var name=id1.name;
	  if(id!=""){
	     jQuery("#"+inputid).val(id);
	     jQuery("#"+spanid).html("<a href='javaScript:openhrm("+id+");' onclick='pointerXY(event);'>"+name+"</a>");
	  }else{
	     jQuery("#"+inputid).val("");
	     if(isNeed)
	        jQuery("#"+spanid).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	     else
	        jQuery("#"+spanid).html(""); 
	  }
  }
  
}


function onShowSubcompany(inputid,spanid){
	   var currentids=jQuery("#"+inputid).val();
	   var id1=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+currentids);
	   if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>0){
	          var tempids=ids.split(",");
	          var tempnames=names.split(",");
	          var sHtml="";
	          for(var i=0;i<tempids.length;i++){
	              var tempid=tempids[i];
	              var tempname=tempnames[i];
	              if(tempid!='')
	                sHtml = sHtml+"<a href='javascript:void(0)' onclick=openFullWindowForXtable('/hrm/company/HrmSubCompanyDsp.jsp?id="+tempid+"')>"+tempname+"</a>&nbsp;";
	          }
	          ids=ids+",";
	          jQuery("#"+inputid).val(ids);
	          jQuery("#"+spanid).html(sHtml);
	       }else{
	          jQuery("#"+inputid).val("");
	          jQuery("#"+spanid).html("");
	       }
       }
	}
	
	
	
    function onShowDepartment(inputid,spanid){
	   var currentids=jQuery("#"+inputid).val();
	   var id1=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+currentids);
	   if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>0){
	          var tempids=ids.split(",");
	          var tempnames=names.split(",");
	          var sHtml="";
	          for(var i=0;i<tempids.length;i++){
	              var tempid=tempids[i];
	              var tempname=tempnames[i];
	              if(tempid!='')
	                sHtml = sHtml+"<a href='javascript:void(0)' onclick=openFullWindowForXtable('/hrm/company/HrmDepartmentDsp.jsp?id="+tempid+"')>"+tempname+"</a>&nbsp;";
	          }
	          ids=ids+",";
	          jQuery("#"+inputid).val(ids);
	          jQuery("#"+spanid).html(sHtml);
	       }else{
	          jQuery("#"+inputid).val("");
	          jQuery("#"+spanid).html("");
	       }
       }
	}
	
	function onShowResource(inputid,spanid){
	   var currentids=jQuery("#"+inputid).val();
	   var id1=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+currentids);
	   if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>0){
	          var tempids=ids.split(",");
	          var tempnames=names.split(",");
	          var sHtml="";
	          for(var i=0;i<tempids.length;i++){
	              var tempid=tempids[i];
	              var tempname=tempnames[i];
	              if(tempid!='')
	                sHtml = sHtml+"<a href='javascript:void(0)' onclick=openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id="+tempid+"')>"+tempname+"</a>&nbsp;";
	          }
	          ids=ids+",";
	          jQuery("#"+inputid).val(ids);
	          jQuery("#"+spanid).html(sHtml);
	       }else{
	          jQuery("#"+inputid).val("");
	          jQuery("#"+spanid).html("");
	       }
       }
	}
	
   function onShowRole(inputid,spanid){
	   var id1=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp");
	   if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>0){
	          jQuery("#"+inputid).val(ids);
	          jQuery("#"+spanid).html(names);
	       }else{
	          jQuery("#"+inputid).val("");
	          jQuery("#"+spanid).html("");
	       }
       }
	}
	
	
	function onShowCowork(inputid,spanid){
	   var currentids=jQuery("#"+inputid).val();
	   var id1=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cowork/MutiCoworkBrowser.jsp?resourceids="+currentids);
	   if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>0){
	          var tempids=ids.split(",");
	          var tempnames=names.split(",");
	          var sHtml="";
	          for(var i=0;i<tempids.length;i++){
	              var tempid=tempids[i];
	              var tempname=tempnames[i];
	              if(tempid!='')
	                sHtml = sHtml+"<a href='javascript:void(0)' onclick=openFullWindowForXtable('/cowork/ViewCoWork.jsp?id="+tempid+"')>"+tempname+"</a>&nbsp;";
	          }
	          //ids=ids+",";
	          jQuery("#"+inputid).val(ids.substr(1));
	          jQuery("#"+spanid).html(sHtml);
	       }else{
	          jQuery("#"+inputid).val("");
	          jQuery("#"+spanid).html("");
	       }
       }
	}
