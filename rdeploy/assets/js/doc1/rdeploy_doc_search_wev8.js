function onShowResource(tdname,inputename){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	if(results){
	  if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	     jQuery($GetEle(tdname)).html("<a href='javascript:openhrm("+wuiUtil.getJsonValueByIndex(results,0)+")'>"+wuiUtil.getJsonValueByIndex(results,1)+"</a>");
	     //alert(wuiUtil.getJsonValueByIndex(results,0))
	     jQuery("input[name='"+inputename+"']")[0].value=wuiUtil.getJsonValueByIndex(results,0);
	     $GetEle("usertype").value="1";
	     $GetEle("ownerid2span").innerHTML="";
	     $GetEle("ownerid2").value="";
	     $GetEle("doccreaterid2span").innerHTML="";
	     $GetEle("doccreaterid2").value="";
	  }else{
	     jQuery($GetEle(tdname)).html("");
	     jQuery("input[name='"+inputename+"']").val("");
	     jQuery($GetEle("usertype")).val("");
	  }
	}
}

function afterShowResource(e,data,name){
	if(data){
		if(data.id!=""){
			$GetEle("usertype").value="1";
		     $GetEle("ownerid2span").innerHTML="";
		     $GetEle("ownerid2").value="";
		     $GetEle("doccreaterid2span").innerHTML="";
		     $GetEle("doccreaterid2").value="";
		}else{
			jQuery($GetEle("usertype")).val("");
		}
	}
}


function onShowDept(tdname,inputename){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+$GetEle(inputename).value);
	if(results){
	  if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	     jQuery($GetEle(tdname)).html("<a href='#"+wuiUtil.getJsonValueByIndex(results,0)+"'>"+wuiUtil.getJsonValueByIndex(results,1)+"</a>");
         $GetEle(inputename).value=wuiUtil.getJsonValueByIndex(results,0);
	  }else{
	     jQuery($GetEle(tdname)).html("");
         $GetEle(inputename).value="";
	  }
	}
}




function onShowDepartment(id,url){
	datas = window.showModalDialog(url+"?selectedDepartmentIds="+$GetEle("con"+id+"_value").value);
	if (datas) {
        if (datas.id!=""){
            var shtml="";
            if(datas.name.indexOf(",")!=-1){
                 var namearray =datas.name.substr(1).split(",");
                 for(var i=0;i<namearray.length;i++){
                	 shtml +=namearray[i]+" ";
                 }
            }
        	$GetEle("con"+id+"_valuespan").innerHTML=shtml;
        	$GetEle("con"+id+"_value").value=datas.id;
        	$GetEle("con"+id+"_name").value=datas.name;
        }
		else{
			$GetEle("con"+id+"_valuespan").innerHTML="";
        	$GetEle("con"+id+"_value").value="";
        	$GetEle("con"+id+"_name").value="";
		}
	}
}


var isNeedSubmit = false;
var isUsedCustomSearch = "<%=isUsedCustomSearch%>"
function encode(str){
    return escape(str);
}
function search(){  //确认搜索提交按钮
	var docSearchForm =$GetEle("frmmain");
	if(isNeedSubmit){
		document.frmmain.submit();
	}
	var isinit = document.getElementById("isinit").value;
	if(displayUsage==0&&false){
		//if(isinit=="false")
		loadGrid(getSearchPara(),gridUrl);
	}else{
		$GetEle("customSearchPara").value = getSearchPara();
		
		
		docSearchForm.submit();
	}
}	

function onBtnSearchClickRight(){
	if(jQuery("#advancedSearchOuterDiv").css("display")!="none"){
		onBtnSearchClick();
	}else{
		try{
			jQuery("span#searchblockspan",parent.document).find("img:first").click();
		}catch(e){
			onBtnSearchClick();
		}
	}
}

function onBtnSearchClick(){
		try
		{
			var isinit = document.getElementById("isinit").value;
			if(isinit=="true")
			{
				document.getElementById("isinit").value = "false";
			}
		}
		catch(e)
		{
		}
		<%if(urlType.equals("14")){%>
			jQuery("#urlType").val("6");
		<%}%>
		$GetEle("self").value='true'
		search();	
}