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

function submitData() {
//window.parent.showMyTree();
	document.resource.submit();
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
			if (type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65|| type1==168){
				if (id1.id!= ""  && id1.id!= "0"){
					ids = id1.id.split(",");
					names =id1.name.split(",");
					sHtml = "";
					id1ids="";
					id1idnum=0;
					for( var i=0;i<ids.length;i++){
						if(ids[i]!=""){
							curid=ids[i];
							curname=names[i];					
							sHtml = sHtml+"<a href="+linkurl+curid+">"+curname+"</a>&nbsp;";
							if(id1idnum==0){
								id1ids=curid;
								id1idnum++;
							}else{
								id1ids=id1ids+","+curid;
								id1idnum++;
							}
						}
					}
					
					jQuery("#column_"+scopeid+"_"+id+"span").html(sHtml);
					jQuery("input[name=column_"+scopeid+"_"+id+"]").val(id1ids);					
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

function doSaveas(mouldname){
	document.resource.mouldname.value = mouldname;
	document.resource.opera.value="insert";
	document.resource.action="HrmResourceSearchMouldOperation.jsp";
	document.resource.target="";
	document.resource.submit();
	dialog.close();
}

function onUpdateSaveas(){
	document.resource.opera.value="update";
	document.resource.action="HrmResourceSearchMouldOperation.jsp";
	document.resource.target="";
	document.resource.submit();
}

function onDelSaveas(){
	var languageid=readCookie("languageidweaver");
	top.Dialog.confirm(SystemEnv.getHtmlNoteName(3580,languageid),function() {					
		document.resource.opera.value="delete";
		document.resource.action="HrmResourceSearchMouldOperation.jsp";
		document.resource.target="";
		document.resource.submit();
	});
}

function onSaveas(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var languageid=readCookie("languageidweaver");
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmResourceSearchMould&isdialog=1";
	dialog.Title = SystemEnv.getHtmlNoteName(3645,languageid);
	dialog.Width = 500;
	dialog.Height = 203;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function HrmUserDefine(){
	window.location.href="/hrm/userdefine/HrmUserDefine.jsp";
}

function jsChangeMould(obj){
	window.location.href="HrmResourceSearch.jsp?cmd=changeMould&mouldid="+obj.value;
}