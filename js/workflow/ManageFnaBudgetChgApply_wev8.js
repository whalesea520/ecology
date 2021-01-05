function changenumber(index){
    if(document.all("amount_"+index)&&document.all("oldamountspan_"+index)){
   	//TD12002 审批预算值大于0时预算差额以审批预算为准计算
	var aproveamount = Number(eval(toFloat(document.all("amount_"+index).value,0)));
    if(aproveamount > 0) {
    	changeval=eval(toFloat(document.all("amount_"+index).value,0)) -eval(toFloat(document.all("oldamountspan_"+index).innerHTML,0));
    } else {
    	changeapplynumber(index);
    	return;
    }
    //changeval=eval(toFloat(document.all("amount_"+index).value,0)) -eval(toFloat(document.all("oldamountspan_"+index).innerHTML,0));
    if(document.all("changeamountspan_"+index)) document.all("changeamountspan_"+index).innerHTML=changeval.toFixed(3);
    }
}


function changeapplynumber(index){
    if(document.all("applyamount_"+index)&&document.all("oldamountspan_"+index)){
	//TD12002 审批预算值大于0时预算差额以审批预算为准计算
	var aproveamount = Number("0");
	if(document.all("amount_"+index)) {
		aproveamount = Number(eval(toFloat(document.all("amount_"+index).value,0)));
	}
    if(aproveamount > 0) {
    	changenumber(index);
    	return;
    } else {
    	changeval=eval(toFloat(document.all("applyamount_"+index).value,0)) -eval(toFloat(document.all("oldamountspan_"+index).innerHTML,0));
    }
    //changeval=eval(toFloat(document.all("applyamount_"+index).value,0)) -eval(toFloat(document.all("oldamountspan_"+index).innerHTML,0));
    if(document.all("changeamountspan_"+index)) document.all("changeamountspan_"+index).innerHTML=changeval.toFixed(3);
    }
}


 function toFloat(str , def) {
     if(isNaN(parseFloat(str))) return def ;
     else return str ;
 }

 function toInt(str , def) {
     if(isNaN(parseInt(str))) return def ;
     else return str ;
 }

 function deleteRow1()
 {
     len = document.forms[0].elements.length;
     var i=0;
     var therowindex = 0 ;
     var rowsum1 = 0;
     for(i=len-1; i >= 0;i--) {
         if (document.forms[0].elements[i].name=='check_node')
             rowsum1 += 1;
     }
     for(i=len-1; i >= 0;i--) {
         if (document.forms[0].elements[i].name=='check_node'){
             if(document.forms[0].elements[i].checked==true) {
                 therowindex = document.forms[0].elements[i].value ;
                 deletearray[thedeletelength] = therowindex ;
                 thedeletelength ++ ;
                 oTable.deleteRow(rowsum1);
                 rowindex--;
             }
             rowsum1 -=1;
         }
     }

 }
 function clearSpan(index) {
    if(document.all("organizationspan_"+index)!=null&&organizationidisedit==1){
    if(organizationidismand==1){
    document.all("organizationspan_"+index).innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
    }else{
        document.all("organizationspan_"+index).innerHTML = "";
    }
    document.all("organizationspan_"+index).parentElement.parentElement.style.background=document.all("organizationtype_"+index).parentElement.parentElement.style.background;
    if (document.all("organizationid_" + index) != null) document.all("organizationid_"+index).value = "";
    if(document.all("oldamountspan_"+index)!=null)
    document.all("oldamountspan_"+index).innerHTML = "";
    }
}
function clearaumountspan(index){
    if(document.all("oldamountspan_"+index)!=null)
    document.all("oldamountspan_"+index).innerHTML = "";
    changenumber(index);
    changeapplynumber(index);
}
 function onShowOrganization(spanname, inputname, ismand, index) {
     if(document.all("organizationtype_" + index)!=null){
     if (document.all("organizationtype_" + index).value == "3")
         return onShowHR(spanname, inputname, ismand, index);
     else if (document.all("organizationtype_" + index).value == "2")
         return onShowDept(spanname, inputname, ismand, index);
     else if (document.all("organizationtype_" + index).value == "1")
         return onShowSubcom(spanname, inputname, ismand, index);
     else
         return null;
     }else{
         return null;
     }
 }
function onShowHR(spanname, inputname, ismand, index) {
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
    try {
        jsid = new VBArray(id).toArray();
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0"&&jsid[0] != "") {
            spanname.innerHTML = "<A href='javaScript:openhrm("+jsid[0]+");' onclick='pointerXY(event);'>"+jsid[1]+"</A>";
            inputname.value = jsid[0];
            if(jsid[0]!=<%=uid%>)
            spanname.parentElement.parentElement.style.background='#ff9999';
            else
            if(document.getElementById("organizationtype_"+index))
            spanname.parentElement.parentElement.style.background=document.getElementById("organizationtype_"+index).parentElement.parentElement.style.background;
            else
            spanname.parentElement.parentElement.style.background="";
            if(document.all("subject_" + index)!=null&&document.all("subject_" + index).value != "")
            getBudget(index,3, jsid[0],document.all("subject_" + index).value);
        } else {
            if (ismand == 1)
                spanname.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
            else
                spanname.innerHTML = "";
            inputname.value = "";
            clearaumountspan(index);
        }
    }
}

function onShowDept(spanname, inputname, ismand, index) {
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+inputname.value);
    try {
        jsid = new VBArray(id).toArray();
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0") {
            spanname.innerHTML = "<A href='/hrm/company/HrmDepartmentDsp.jsp?id="+jsid[0]+"'>"+jsid[1]+"</A>";
            inputname.value = jsid[0];
            if(jsid[0]!=<%=udept%>)
            spanname.parentElement.parentElement.style.background='#ff9999';
            else
            if(document.getElementById("organizationtype_"+index))
            spanname.parentElement.parentElement.style.background=document.getElementById("organizationtype_"+index).parentElement.parentElement.style.background;
            else
            spanname.parentElement.parentElement.style.background="";
            if(document.all("subject_" + index)!=null&&document.all("subject_" + index).value != "")
            getBudget(index,2, jsid[0],document.all("subject_" + index).value);
        }else {
            if (ismand == 1)
                spanname.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
            else
                spanname.innerHTML = "";
            inputname.value = "";
            clearaumountspan(index);
        }
    }

}
function onShowSubcom(spanname, inputname, ismand, index) {
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp");
    try {
        jsid = new VBArray(id).toArray();
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0") {
            spanname.innerHTML = "<A href='/hrm/company/HrmSubCompanyDsp.jsp?id="+jsid[0]+"'>"+jsid[1]+"</A>";
            inputname.value = jsid[0];
            if(jsid[0]!=<%=usubcom%>)
            spanname.parentElement.parentElement.style.background='#ff9999';
            else
            if(document.getElementById("organizationtype_"+index))
            spanname.parentElement.parentElement.style.background=document.getElementById("organizationtype_"+index).parentElement.parentElement.style.background;
            else
            spanname.parentElement.parentElement.style.background="";
            if(document.all("subject_" + index)!=null&&document.all("subject_" + index).value != "")
            getBudget(index,1, jsid[0],document.all("subject_" + index).value);
        }else {
            if (ismand == 1)
                spanname.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
            else
                spanname.innerHTML = "";
            inputname.value = "";
            clearaumountspan(index);
        }
    }
}



function onShowSubject(spanname, inputname, ismand, index) {
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp");
    try {
        jsid = new VBArray(id).toArray();
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0"){
            spanname.innerHTML = jsid[1];
            inputname.value = jsid[0];
            changeSubject(index,jsid[0]);
        }else {
            if (ismand == 1)
                spanname.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
            else
                spanname.innerHTML = "";
            inputname.value = "";
            clearaumountspan(index);
        }
    }
}

function onShowPrj(spanname, inputname, ismand, index) {
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp");
    try {
        jsid = new VBArray(id).toArray();
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0"){
            spanname.innerHTML = "<A href='/proj/data/ViewProject.jsp?isrequest=1&ProjID="+jsid[0]+"'>"+jsid[1]+"</A>";
            inputname.value = jsid[0];
        }else {
            if (ismand == 1)
                spanname.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
            else
                spanname.innerHTML = "";
            inputname.value = "";
        }
    }
}
function onShowCrm(spanname, inputname, ismand, index) {
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp");
    try {
        jsid = new VBArray(id).toArray();
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0"){
            spanname.innerHTML = "<A href='/CRM/data/ViewCustomer.jsp?isrequest=1&CustomerID="+jsid[0]+"'>"+jsid[1]+"</A>";
            inputname.value = jsid[0];
        }else {
            if (ismand == 1)
                spanname.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
            else
                spanname.innerHTML = "";
            inputname.value = "";
        }
    }
}
 function onShowWFDate(spanname, inputname, ismand, index) {
	var oncleaingFun = function(){
          if (ismand == 1)
             spanname.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
          else
             spanname.innerHTML = "";
        inputname.value="";
        clearaumountspan(index);
	}
	WdatePicker({el:spanname,onpicked:function(dp){
		var returndate = dp.cal.getDateStr();
		if (returndate != null) {
        if (returndate != ""){
            $dp.$(inputname).value = returndate;
            if(document.all("subject_" + index)!=null&&document.all("subject_" + index).value != "")
            changePeriod(index);
        }else {
            if (ismand == 1)
                spanname.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
            else
                spanname.innerHTML = "";
            $dp.$(inputname).value = "";
            clearaumountspan(index);
        }
      }
	},oncleared:oncleaingFun});

	if(ismand == 1){
	 var hidename = $(inputname).value;
	 if(hidename != ""){
		$(inputname).value = hidename; 
		$(spanname).innerHTML = hidename;
	 }else{
	  $(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 }
    }
}

 function changeSubject(index, subjid) {
     if(document.all("organizationtype_" + index)!=null){
     organizationtypeval = document.all("organizationtype_" + index).value;
     organizationidval = document.all("organizationid_" + index).value;
     getBudget(index, organizationtypeval, organizationidval, subjid);
     }
 }
 function changePeriod(index) {
             if(document.all("subject_" + index)!=null&&document.all("subject_" + index).value != "")
               changeSubject(index,document.all("subject_" + index).value)
 }
 function callback(o, index) {
     if(document.all("oldamountspan_" + index)) document.all("oldamountspan_" + index).innerHTML = o;
     changenumber(index);
     changeapplynumber(index);
 }

 function getBudget(index, organizationtype, organizationid, subjid) {
     var callbackProxy = function(o) {
         callback(o, index);
     };
     var callMetaData = { callback:callbackProxy };

     if (document.all("budgetperiod_"+index)!= null&&document.all("budgetperiod_"+index).value!= ""&&document.all("organizationid_"+index)!= null&&document.all("organizationid_"+index).value!= ""&&document.all("subject_"+index)!= null&&document.all("subject_"+index).value!= "")
         BudgetHandler.getBudgetByDate(document.all("budgetperiod_"+index).value, organizationtype, organizationid, subjid, callMetaData);
 }
function checknumber1(objectname)
{
	valuechar = objectname.value.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)&& valuechar[i]!=".") isnumber = true ;}
	if(isnumber) objectname.value = "" ;
}
