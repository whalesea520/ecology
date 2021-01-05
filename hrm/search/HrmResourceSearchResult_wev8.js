function onBtnSearchClick(){
	resource.submit();
}

function jsChangeMould(obj){
	window.location.href="HrmResourceSearchResult.jsp?cmd=changeMould&mouldid="+obj.value;
}

jQuery(document).ready(function(){
	hideGroup("moreKeyWord");
	var languageid=readCookie("languageidweaver");
	var showText = SystemEnv.getHtmlNoteName(3550,languageid);
	var hideText = SystemEnv.getHtmlNoteName(3549,languageid);

	jQuery(".myHideBlockDiv").unbind("click").bind("click", function () {
		var _status = jQuery(this).attr("_status");
		var currentTREle = jQuery(this).closest("table").closest("TR");
		if (!!!_status || _status == "0") {
			jQuery(this).attr("_status", "1");
			jQuery(this).html(showText+"<image src='/wui/theme/ecology8/templates/default/images/1_wev8.png'>");
			currentTREle.next("TR.Spacing").next("TR.items").hide();
			hideGroup("moreKeyWord");
		} else {
			jQuery(this).attr("_status", "0");
			jQuery(this).html(hideText+"<image src='/wui/theme/ecology8/templates/default/images/2_wev8.png'>");
			currentTREle.next("TR.Spacing").next("TR.items").show();
			showGroup("moreKeyWord");
		}
	}).hover(function(){
		$(this).css("color","#000000");
	},function(){
		$(this).css("color","#cccccc");
	});
});

function doAddWorkPlan(id) {
	openFullWindowForXtable("/workplan/data/WorkPlan.jsp?resourceid="+id+"&add=1")	
}

function jsHrmResourceSystemView(id){
openFullWindowForXtable('/hrm/HrmTab.jsp?_fromURL=HrmResourceSystemView&id='+id);
}

function submitData() {
	//jQuery("#advancedSearch").click();
	jQuery("#searchForm").val("hrmResource");
	resource.submit();
}

function onRefresh(){
	document.frmMain.submit();
}

function onNewResource(departmentid){
	window.location.href="/hrm/resource/HrmResourceAdd.jsp?departmentid="+departmentid;
}


function onNumberBlur(f,id){
	checknumber(id+"_"+f);
	var o=document.getElementById(id);
	var iStart=document.all(id+"_start").value;
	iStart=(iStart!="")?parseInt(iStart):'A';

	var iEnd=document.all(id+"_end").value;
	iEnd=(iEnd!="")?parseInt(iEnd):'A';

	o.value=iStart+","+iEnd;
	//alert(o.value);
}
function customDateAction(realInputDate,span1,date1){
	
	var inputDate=document.getElementById(realInputDate);
	
	var strDate=date1+"_dateSpan";
	var objDate=document.getElementById(strDate);

	var dates=inputDate.value.split(",");
	var prefixStr=span1.id.substring(0,3);
	if(prefixStr=="sta"){
		objDate.value=dates[0];
	}else if(prefixStr=="end"){
		objDate.value=dates[1];
	}	
	getDate(span1,objDate);//getDate
	if(prefixStr=="sta"){
		dates[0]=objDate.value;
		dates[0]=(dates[0]=="")?"A":dates[0];
	}else if(prefixStr=="end"){
		dates[1]=objDate.value;
		dates[1]=(dates[1]=="")?"A":dates[1];
	}
	inputDate.value=dates.join(",");

	//alert(inputDate.value);
}

function checkNewmould(){
	if(document.resource.mouldname.value==''){
		oTrname.style.display='';
		return false;
		}
	return true;
}
function doSaveas(mouldname){
	document.resource.mouldname.value = mouldname;
	document.resource.opera.value="insert";
	document.resource.action="HrmResourceSearchMouldOperation.jsp";
	document.resource.target="";
	document.resource.submit();
	dialog.close();
	jQuery("#advancedSearch").click();
}

function onUpdateSaveas(){
	document.resource.opera.value="update";
	document.resource.action="HrmResourceSearchMouldOperation.jsp";
	document.resource.target="";
	document.resource.submit();
}

function onDelSaveas(){
	document.resource.opera.value="delete";
	document.resource.action="HrmResourceSearchMouldOperation.jsp";
	document.resource.target="";
	document.resource.submit();
}

function onSave(){
	document.resource.opera.value="update";
	document.resource.action="HrmResourceSearchMouldOperation.jsp";
	document.resource.target="";
	document.resource.submit();
	jQuery("#advancedSearch").click();
}

function HrmUserDefine(){
	window.location.href="/hrm/userdefine/HrmUserDefine.jsp";
}

function onShowBrowser(id,url,linkurl,type1,ismand, scopeid){
    spanname = "column_"+scopeid+"_"+id+"span";
	inputname = "column_"+scopeid+"_"+id;
	if (type1== 2 || type1 == 19){
		if (type1 == 2){
		 onShowADTDate(id);
		}else{
		 onShowTime(spanname,inputname);
		}
	}else{
		if (type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=4 && type1!=166 && type1!=167 && type1!=164 && type1!=169 && type1!=170&&type1!=161&&type1!=162){
			tmpids = jQuery("input[name=column_"+scopeid+"_"+id+"]").val();
			id1 = window.showModalDialog(url+"?resourceids="+tmpids);
		}else if (type1==4 || type1==167 || type1==164 || type1==169 || type1==170){
            tmpids = jQuery("input[name=column_"+scopeid+"_"+id+"]").val();
			id1 = window.showModalDialog(url+"?selectedids="+tmpids)
		}else if (type1==37){
            tmpids = jQuery("input[name=column_"+scopeid+"_"+id+"]").val();
			id1 = window.showModalDialog(url+"?documentids="+tmpids)
		}else if (type1==161||type1==162){
      tmpids = jQuery("input[name=column_"+scopeid+"_"+id+"]").val();
			id1 = window.showModalDialog(url+"&selectedids="+tmpids)
		}else{
			tmpids = jQuery("input[name=column_"+scopeid+"_"+id+"]").val();
			id1 = window.showModalDialog(url+"?resourceids="+tmpids)
		}
			//alert(id1.id+"  "+id1.name)
		if (id1!=null){
			if (type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65){
				if (id1.id!= ""  && id1.id!= "0"){
					ids = id1.id.split(",");
					names =id1.name.split(",");
					sHtml = "";
					for( var i=0;i<ids.length;i++){
						if(ids[i]!=""){
					
							sHtml = sHtml+"<a href="+linkurl+curid+">"+curname+"</a>&nbsp;";
						}
					}
					
					jQuery("#column_"+scopeid+"_"+id+"span").html(sHtml);
					
				}else{
					if (ismand==0){
						jQuery("#column_"+scopeid+"_"+id+"span").html("");
					}else{
						jQuery("#column_"+scopeid+"_"+id+"span").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
						}
					jQuery("input[name=column_"+scopeid+"_"+id+"]").val("");
				}
			}else{
			   if  (id1.id!="" && id1.id!= "0"){
			        if (linkurl == ""){
						jQuery("#column_"+scopeid+"_"+id+"span").html(id1.name);
					}else{
						jQuery("#column_"+scopeid+"_"+id+"span").html("<a href="+linkurl+id1.id+">"+id1.name+"</a>");
					}
					jQuery("input[name=column_"+scopeid+"_"+id+"]").val(id1.id);
			   }else{
					if (ismand==0){
						jQuery("#column_"+scopeid+"_"+id+"span").html("");
					}else{
						jQuery("#column_"+scopeid+"_"+id+"span").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
					}
					jQuery("input[name=column_"+scopeid+"_"+id+"]").val("");
				}
			}
		}
	}

}